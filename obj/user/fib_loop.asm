
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
  800052:	68 20 3e 80 00       	push   $0x803e20
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
  8000bc:	68 3e 3e 80 00       	push   $0x803e3e
  8000c1:	e8 f1 02 00 00       	call   8003b7 <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 b8 1b 00 00       	call   801c86 <inctst>
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
  80017d:	e8 c6 19 00 00       	call   801b48 <sys_getenvindex>
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
  8001eb:	e8 dc 16 00 00       	call   8018cc <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 6c 3e 80 00       	push   $0x803e6c
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
  80021b:	68 94 3e 80 00       	push   $0x803e94
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
  80024c:	68 bc 3e 80 00       	push   $0x803ebc
  800251:	e8 34 01 00 00       	call   80038a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 14 3f 80 00       	push   $0x803f14
  80026d:	e8 18 01 00 00       	call   80038a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 6c 3e 80 00       	push   $0x803e6c
  80027d:	e8 08 01 00 00       	call   80038a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800285:	e8 5c 16 00 00       	call   8018e6 <sys_unlock_cons>
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
  80029d:	e8 72 18 00 00       	call   801b14 <sys_destroy_env>
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
  8002ae:	e8 c7 18 00 00       	call   801b7a <sys_exit_env>
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
  8002fc:	e8 89 15 00 00       	call   80188a <sys_cputs>
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
  800373:	e8 12 15 00 00       	call   80188a <sys_cputs>
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
  8003bd:	e8 0a 15 00 00       	call   8018cc <sys_lock_cons>
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
  8003dd:	e8 04 15 00 00       	call   8018e6 <sys_unlock_cons>
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
  800427:	e8 84 37 00 00       	call   803bb0 <__udivdi3>
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
  800477:	e8 44 38 00 00       	call   803cc0 <__umoddi3>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	05 54 41 80 00       	add    $0x804154,%eax
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
  8005d2:	8b 04 85 78 41 80 00 	mov    0x804178(,%eax,4),%eax
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
  8006b3:	8b 34 9d c0 3f 80 00 	mov    0x803fc0(,%ebx,4),%esi
  8006ba:	85 f6                	test   %esi,%esi
  8006bc:	75 19                	jne    8006d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006be:	53                   	push   %ebx
  8006bf:	68 65 41 80 00       	push   $0x804165
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
  8006d8:	68 6e 41 80 00       	push   $0x80416e
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
  800705:	be 71 41 80 00       	mov    $0x804171,%esi
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
  800a30:	68 e8 42 80 00       	push   $0x8042e8
  800a35:	e8 50 f9 ff ff       	call   80038a <cprintf>
  800a3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a44:	83 ec 0c             	sub    $0xc,%esp
  800a47:	6a 00                	push   $0x0
  800a49:	e8 6e 2f 00 00       	call   8039bc <iscons>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a54:	e8 50 2f 00 00       	call   8039a9 <getchar>
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
  800a72:	68 eb 42 80 00       	push   $0x8042eb
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
  800a9f:	e8 e6 2e 00 00       	call   80398a <cputchar>
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
  800ad6:	e8 af 2e 00 00       	call   80398a <cputchar>
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
  800aff:	e8 86 2e 00 00       	call   80398a <cputchar>
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
  800b23:	e8 a4 0d 00 00       	call   8018cc <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b2c:	74 13                	je     800b41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 08             	pushl  0x8(%ebp)
  800b34:	68 e8 42 80 00       	push   $0x8042e8
  800b39:	e8 4c f8 ff ff       	call   80038a <cprintf>
  800b3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b48:	83 ec 0c             	sub    $0xc,%esp
  800b4b:	6a 00                	push   $0x0
  800b4d:	e8 6a 2e 00 00       	call   8039bc <iscons>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b58:	e8 4c 2e 00 00       	call   8039a9 <getchar>
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
  800b76:	68 eb 42 80 00       	push   $0x8042eb
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
  800ba3:	e8 e2 2d 00 00       	call   80398a <cputchar>
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
  800bda:	e8 ab 2d 00 00       	call   80398a <cputchar>
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
  800c03:	e8 82 2d 00 00       	call   80398a <cputchar>
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
  800c1e:	e8 c3 0c 00 00       	call   8018e6 <sys_unlock_cons>
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
  801318:	68 fc 42 80 00       	push   $0x8042fc
  80131d:	68 3f 01 00 00       	push   $0x13f
  801322:	68 1e 43 80 00       	push   $0x80431e
  801327:	e8 9a 26 00 00       	call   8039c6 <_panic>

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
  801338:	e8 f8 0a 00 00       	call   801e35 <sys_sbrk>
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
  8013b3:	e8 01 09 00 00       	call   801cb9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	74 16                	je     8013d2 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 08             	pushl  0x8(%ebp)
  8013c2:	e8 dd 0e 00 00       	call   8022a4 <alloc_block_FF>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013cd:	e9 8a 01 00 00       	jmp    80155c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013d2:	e8 13 09 00 00       	call   801cea <sys_isUHeapPlacementStrategyBESTFIT>
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	0f 84 7d 01 00 00    	je     80155c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013df:	83 ec 0c             	sub    $0xc,%esp
  8013e2:	ff 75 08             	pushl  0x8(%ebp)
  8013e5:	e8 76 13 00 00       	call   802760 <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801447:	05 00 10 00 00       	add    $0x1000,%eax
  80144c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80144f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  8014ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014f3:	75 16                	jne    80150b <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8014f5:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8014fc:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801503:	0f 86 15 ff ff ff    	jbe    80141e <malloc+0xdc>
  801509:	eb 01                	jmp    80150c <malloc+0x1ca>
				}
				

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
  80154b:	e8 1c 09 00 00       	call   801e6c <sys_allocate_user_mem>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	eb 07                	jmp    80155c <malloc+0x21a>
		
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
  801593:	e8 8c 09 00 00       	call   801f24 <get_block_size>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 9c 1b 00 00       	call   803145 <free_block>
  8015a9:	83 c4 10             	add    $0x10,%esp
		}

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
  8015f8:	eb 42                	jmp    80163c <free+0xdb>
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
			sys_free_user_mem((uint32)va, k);
  801626:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	83 ec 08             	sub    $0x8,%esp
  80162f:	52                   	push   %edx
  801630:	50                   	push   %eax
  801631:	e8 1a 08 00 00       	call   801e50 <sys_free_user_mem>
  801636:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801639:	ff 45 f4             	incl   -0xc(%ebp)
  80163c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801642:	72 b6                	jb     8015fa <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801644:	eb 17                	jmp    80165d <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	68 2c 43 80 00       	push   $0x80432c
  80164e:	68 87 00 00 00       	push   $0x87
  801653:	68 56 43 80 00       	push   $0x804356
  801658:	e8 69 23 00 00       	call   8039c6 <_panic>
	}
}
  80165d:	90                   	nop
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 28             	sub    $0x28,%esp
  801666:	8b 45 10             	mov    0x10(%ebp),%eax
  801669:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80166c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801670:	75 0a                	jne    80167c <smalloc+0x1c>
  801672:	b8 00 00 00 00       	mov    $0x0,%eax
  801677:	e9 87 00 00 00       	jmp    801703 <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  80167c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801682:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801689:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168f:	39 d0                	cmp    %edx,%eax
  801691:	73 02                	jae    801695 <smalloc+0x35>
  801693:	89 d0                	mov    %edx,%eax
  801695:	83 ec 0c             	sub    $0xc,%esp
  801698:	50                   	push   %eax
  801699:	e8 a4 fc ff ff       	call   801342 <malloc>
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8016a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016a8:	75 07                	jne    8016b1 <smalloc+0x51>
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016af:	eb 52                	jmp    801703 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8016b1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b8:	50                   	push   %eax
  8016b9:	ff 75 0c             	pushl  0xc(%ebp)
  8016bc:	ff 75 08             	pushl  0x8(%ebp)
  8016bf:	e8 93 03 00 00       	call   801a57 <sys_createSharedObject>
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8016ca:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016ce:	74 06                	je     8016d6 <smalloc+0x76>
  8016d0:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016d4:	75 07                	jne    8016dd <smalloc+0x7d>
  8016d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016db:	eb 26                	jmp    801703 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8016dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8016e5:	8b 40 78             	mov    0x78(%eax),%eax
  8016e8:	29 c2                	sub    %eax,%edx
  8016ea:	89 d0                	mov    %edx,%eax
  8016ec:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016f1:	c1 e8 0c             	shr    $0xc,%eax
  8016f4:	89 c2                	mov    %eax,%edx
  8016f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f9:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801700:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80170b:	83 ec 08             	sub    $0x8,%esp
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	ff 75 08             	pushl  0x8(%ebp)
  801714:	e8 68 03 00 00       	call   801a81 <sys_getSizeOfSharedObject>
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80171f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801723:	75 07                	jne    80172c <sget+0x27>
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
  80172a:	eb 7f                	jmp    8017ab <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80172c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801732:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801739:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80173c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173f:	39 d0                	cmp    %edx,%eax
  801741:	73 02                	jae    801745 <sget+0x40>
  801743:	89 d0                	mov    %edx,%eax
  801745:	83 ec 0c             	sub    $0xc,%esp
  801748:	50                   	push   %eax
  801749:	e8 f4 fb ff ff       	call   801342 <malloc>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801754:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801758:	75 07                	jne    801761 <sget+0x5c>
  80175a:	b8 00 00 00 00       	mov    $0x0,%eax
  80175f:	eb 4a                	jmp    8017ab <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	ff 75 e8             	pushl  -0x18(%ebp)
  801767:	ff 75 0c             	pushl  0xc(%ebp)
  80176a:	ff 75 08             	pushl  0x8(%ebp)
  80176d:	e8 2c 03 00 00       	call   801a9e <sys_getSharedObject>
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801778:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80177b:	a1 20 50 80 00       	mov    0x805020,%eax
  801780:	8b 40 78             	mov    0x78(%eax),%eax
  801783:	29 c2                	sub    %eax,%edx
  801785:	89 d0                	mov    %edx,%eax
  801787:	2d 00 10 00 00       	sub    $0x1000,%eax
  80178c:	c1 e8 0c             	shr    $0xc,%eax
  80178f:	89 c2                	mov    %eax,%edx
  801791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801794:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80179b:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80179f:	75 07                	jne    8017a8 <sget+0xa3>
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a6:	eb 03                	jmp    8017ab <sget+0xa6>
	return ptr;
  8017a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8017b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8017bb:	8b 40 78             	mov    0x78(%eax),%eax
  8017be:	29 c2                	sub    %eax,%edx
  8017c0:	89 d0                	mov    %edx,%eax
  8017c2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017c7:	c1 e8 0c             	shr    $0xc,%eax
  8017ca:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8017d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8017d4:	83 ec 08             	sub    $0x8,%esp
  8017d7:	ff 75 08             	pushl  0x8(%ebp)
  8017da:	ff 75 f4             	pushl  -0xc(%ebp)
  8017dd:	e8 db 02 00 00       	call   801abd <sys_freeSharedObject>
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	68 64 43 80 00       	push   $0x804364
  8017f9:	68 e4 00 00 00       	push   $0xe4
  8017fe:	68 56 43 80 00       	push   $0x804356
  801803:	e8 be 21 00 00       	call   8039c6 <_panic>

00801808 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	68 8a 43 80 00       	push   $0x80438a
  801816:	68 f0 00 00 00       	push   $0xf0
  80181b:	68 56 43 80 00       	push   $0x804356
  801820:	e8 a1 21 00 00       	call   8039c6 <_panic>

00801825 <shrink>:

}
void shrink(uint32 newSize)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	68 8a 43 80 00       	push   $0x80438a
  801833:	68 f5 00 00 00       	push   $0xf5
  801838:	68 56 43 80 00       	push   $0x804356
  80183d:	e8 84 21 00 00       	call   8039c6 <_panic>

00801842 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	68 8a 43 80 00       	push   $0x80438a
  801850:	68 fa 00 00 00       	push   $0xfa
  801855:	68 56 43 80 00       	push   $0x804356
  80185a:	e8 67 21 00 00       	call   8039c6 <_panic>

0080185f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	57                   	push   %edi
  801863:	56                   	push   %esi
  801864:	53                   	push   %ebx
  801865:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801871:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801874:	8b 7d 18             	mov    0x18(%ebp),%edi
  801877:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80187a:	cd 30                	int    $0x30
  80187c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80187f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	5b                   	pop    %ebx
  801886:	5e                   	pop    %esi
  801887:	5f                   	pop    %edi
  801888:	5d                   	pop    %ebp
  801889:	c3                   	ret    

0080188a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	83 ec 04             	sub    $0x4,%esp
  801890:	8b 45 10             	mov    0x10(%ebp),%eax
  801893:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801896:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	52                   	push   %edx
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	50                   	push   %eax
  8018a6:	6a 00                	push   $0x0
  8018a8:	e8 b2 ff ff ff       	call   80185f <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	90                   	nop
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 02                	push   $0x2
  8018c2:	e8 98 ff ff ff       	call   80185f <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 03                	push   $0x3
  8018db:	e8 7f ff ff ff       	call   80185f <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	90                   	nop
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 04                	push   $0x4
  8018f5:	e8 65 ff ff ff       	call   80185f <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	90                   	nop
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	52                   	push   %edx
  801910:	50                   	push   %eax
  801911:	6a 08                	push   $0x8
  801913:	e8 47 ff ff ff       	call   80185f <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	56                   	push   %esi
  801921:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801922:	8b 75 18             	mov    0x18(%ebp),%esi
  801925:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801928:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	56                   	push   %esi
  801932:	53                   	push   %ebx
  801933:	51                   	push   %ecx
  801934:	52                   	push   %edx
  801935:	50                   	push   %eax
  801936:	6a 09                	push   $0x9
  801938:	e8 22 ff ff ff       	call   80185f <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801943:	5b                   	pop    %ebx
  801944:	5e                   	pop    %esi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 0a                	push   $0xa
  80195a:	e8 00 ff ff ff       	call   80185f <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	6a 0b                	push   $0xb
  801975:	e8 e5 fe ff ff       	call   80185f <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 0c                	push   $0xc
  80198e:	e8 cc fe ff ff       	call   80185f <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 0d                	push   $0xd
  8019a7:	e8 b3 fe ff ff       	call   80185f <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 0e                	push   $0xe
  8019c0:	e8 9a fe ff ff       	call   80185f <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 0f                	push   $0xf
  8019d9:	e8 81 fe ff ff       	call   80185f <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	6a 10                	push   $0x10
  8019f3:	e8 67 fe ff ff       	call   80185f <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 11                	push   $0x11
  801a0c:	e8 4e fe ff ff       	call   80185f <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	90                   	nop
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 04             	sub    $0x4,%esp
  801a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a23:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	50                   	push   %eax
  801a30:	6a 01                	push   $0x1
  801a32:	e8 28 fe ff ff       	call   80185f <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	90                   	nop
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 14                	push   $0x14
  801a4c:	e8 0e fe ff ff       	call   80185f <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	90                   	nop
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 04             	sub    $0x4,%esp
  801a5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a60:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a63:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a66:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	6a 00                	push   $0x0
  801a6f:	51                   	push   %ecx
  801a70:	52                   	push   %edx
  801a71:	ff 75 0c             	pushl  0xc(%ebp)
  801a74:	50                   	push   %eax
  801a75:	6a 15                	push   $0x15
  801a77:	e8 e3 fd ff ff       	call   80185f <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	52                   	push   %edx
  801a91:	50                   	push   %eax
  801a92:	6a 16                	push   $0x16
  801a94:	e8 c6 fd ff ff       	call   80185f <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aa1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	51                   	push   %ecx
  801aaf:	52                   	push   %edx
  801ab0:	50                   	push   %eax
  801ab1:	6a 17                	push   $0x17
  801ab3:	e8 a7 fd ff ff       	call   80185f <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	52                   	push   %edx
  801acd:	50                   	push   %eax
  801ace:	6a 18                	push   $0x18
  801ad0:	e8 8a fd ff ff       	call   80185f <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	ff 75 14             	pushl  0x14(%ebp)
  801ae5:	ff 75 10             	pushl  0x10(%ebp)
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	50                   	push   %eax
  801aec:	6a 19                	push   $0x19
  801aee:	e8 6c fd ff ff       	call   80185f <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	50                   	push   %eax
  801b07:	6a 1a                	push   $0x1a
  801b09:	e8 51 fd ff ff       	call   80185f <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	90                   	nop
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	50                   	push   %eax
  801b23:	6a 1b                	push   $0x1b
  801b25:	e8 35 fd ff ff       	call   80185f <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 05                	push   $0x5
  801b3e:	e8 1c fd ff ff       	call   80185f <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 06                	push   $0x6
  801b57:	e8 03 fd ff ff       	call   80185f <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 07                	push   $0x7
  801b70:	e8 ea fc ff ff       	call   80185f <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_exit_env>:


void sys_exit_env(void)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 1c                	push   $0x1c
  801b89:	e8 d1 fc ff ff       	call   80185f <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	90                   	nop
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b9a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b9d:	8d 50 04             	lea    0x4(%eax),%edx
  801ba0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	52                   	push   %edx
  801baa:	50                   	push   %eax
  801bab:	6a 1d                	push   $0x1d
  801bad:	e8 ad fc ff ff       	call   80185f <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
	return result;
  801bb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bbe:	89 01                	mov    %eax,(%ecx)
  801bc0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	c9                   	leave  
  801bc7:	c2 04 00             	ret    $0x4

00801bca <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	ff 75 10             	pushl  0x10(%ebp)
  801bd4:	ff 75 0c             	pushl  0xc(%ebp)
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	6a 13                	push   $0x13
  801bdc:	e8 7e fc ff ff       	call   80185f <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
	return ;
  801be4:	90                   	nop
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 1e                	push   $0x1e
  801bf6:	e8 64 fc ff ff       	call   80185f <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 04             	sub    $0x4,%esp
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c0c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	50                   	push   %eax
  801c19:	6a 1f                	push   $0x1f
  801c1b:	e8 3f fc ff ff       	call   80185f <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
	return ;
  801c23:	90                   	nop
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <rsttst>:
void rsttst()
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 21                	push   $0x21
  801c35:	e8 25 fc ff ff       	call   80185f <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3d:	90                   	nop
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 04             	sub    $0x4,%esp
  801c46:	8b 45 14             	mov    0x14(%ebp),%eax
  801c49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c4c:	8b 55 18             	mov    0x18(%ebp),%edx
  801c4f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c53:	52                   	push   %edx
  801c54:	50                   	push   %eax
  801c55:	ff 75 10             	pushl  0x10(%ebp)
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	6a 20                	push   $0x20
  801c60:	e8 fa fb ff ff       	call   80185f <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
	return ;
  801c68:	90                   	nop
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <chktst>:
void chktst(uint32 n)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	ff 75 08             	pushl  0x8(%ebp)
  801c79:	6a 22                	push   $0x22
  801c7b:	e8 df fb ff ff       	call   80185f <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
	return ;
  801c83:	90                   	nop
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <inctst>:

void inctst()
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 23                	push   $0x23
  801c95:	e8 c5 fb ff ff       	call   80185f <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <gettst>:
uint32 gettst()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 24                	push   $0x24
  801caf:	e8 ab fb ff ff       	call   80185f <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 25                	push   $0x25
  801ccb:	e8 8f fb ff ff       	call   80185f <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
  801cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cd6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cda:	75 07                	jne    801ce3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cdc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce1:	eb 05                	jmp    801ce8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ce3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 25                	push   $0x25
  801cfc:	e8 5e fb ff ff       	call   80185f <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
  801d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d07:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d0b:	75 07                	jne    801d14 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d12:	eb 05                	jmp    801d19 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 25                	push   $0x25
  801d2d:	e8 2d fb ff ff       	call   80185f <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
  801d35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d38:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d3c:	75 07                	jne    801d45 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d43:	eb 05                	jmp    801d4a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 25                	push   $0x25
  801d5e:	e8 fc fa ff ff       	call   80185f <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
  801d66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d69:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d6d:	75 07                	jne    801d76 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d74:	eb 05                	jmp    801d7b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	ff 75 08             	pushl  0x8(%ebp)
  801d8b:	6a 26                	push   $0x26
  801d8d:	e8 cd fa ff ff       	call   80185f <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
	return ;
  801d95:	90                   	nop
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d9c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	6a 00                	push   $0x0
  801daa:	53                   	push   %ebx
  801dab:	51                   	push   %ecx
  801dac:	52                   	push   %edx
  801dad:	50                   	push   %eax
  801dae:	6a 27                	push   $0x27
  801db0:	e8 aa fa ff ff       	call   80185f <syscall>
  801db5:	83 c4 18             	add    $0x18,%esp
}
  801db8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	52                   	push   %edx
  801dcd:	50                   	push   %eax
  801dce:	6a 28                	push   $0x28
  801dd0:	e8 8a fa ff ff       	call   80185f <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ddd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	6a 00                	push   $0x0
  801de8:	51                   	push   %ecx
  801de9:	ff 75 10             	pushl  0x10(%ebp)
  801dec:	52                   	push   %edx
  801ded:	50                   	push   %eax
  801dee:	6a 29                	push   $0x29
  801df0:	e8 6a fa ff ff       	call   80185f <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	ff 75 10             	pushl  0x10(%ebp)
  801e04:	ff 75 0c             	pushl  0xc(%ebp)
  801e07:	ff 75 08             	pushl  0x8(%ebp)
  801e0a:	6a 12                	push   $0x12
  801e0c:	e8 4e fa ff ff       	call   80185f <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
	return ;
  801e14:	90                   	nop
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	52                   	push   %edx
  801e27:	50                   	push   %eax
  801e28:	6a 2a                	push   $0x2a
  801e2a:	e8 30 fa ff ff       	call   80185f <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
	return;
  801e32:	90                   	nop
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	50                   	push   %eax
  801e44:	6a 2b                	push   $0x2b
  801e46:	e8 14 fa ff ff       	call   80185f <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
}
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	ff 75 0c             	pushl  0xc(%ebp)
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	6a 2c                	push   $0x2c
  801e61:	e8 f9 f9 ff ff       	call   80185f <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
	return;
  801e69:	90                   	nop
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	ff 75 0c             	pushl  0xc(%ebp)
  801e78:	ff 75 08             	pushl  0x8(%ebp)
  801e7b:	6a 2d                	push   $0x2d
  801e7d:	e8 dd f9 ff ff       	call   80185f <syscall>
  801e82:	83 c4 18             	add    $0x18,%esp
	return;
  801e85:	90                   	nop
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 2e                	push   $0x2e
  801e9a:	e8 c0 f9 ff ff       	call   80185f <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
  801ea2:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	50                   	push   %eax
  801eb9:	6a 2f                	push   $0x2f
  801ebb:	e8 9f f9 ff ff       	call   80185f <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
	return;
  801ec3:	90                   	nop
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	52                   	push   %edx
  801ed6:	50                   	push   %eax
  801ed7:	6a 30                	push   $0x30
  801ed9:	e8 81 f9 ff ff       	call   80185f <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
	return;
  801ee1:	90                   	nop
}
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	50                   	push   %eax
  801ef6:	6a 31                	push   $0x31
  801ef8:	e8 62 f9 ff ff       	call   80185f <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
  801f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	50                   	push   %eax
  801f17:	6a 32                	push   $0x32
  801f19:	e8 41 f9 ff ff       	call   80185f <syscall>
  801f1e:	83 c4 18             	add    $0x18,%esp
	return;
  801f21:	90                   	nop
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	83 e8 04             	sub    $0x4,%eax
  801f30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f36:	8b 00                	mov    (%eax),%eax
  801f38:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
  801f40:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	83 e8 04             	sub    $0x4,%eax
  801f49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4f:	8b 00                	mov    (%eax),%eax
  801f51:	83 e0 01             	and    $0x1,%eax
  801f54:	85 c0                	test   %eax,%eax
  801f56:	0f 94 c0             	sete   %al
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6b:	83 f8 02             	cmp    $0x2,%eax
  801f6e:	74 2b                	je     801f9b <alloc_block+0x40>
  801f70:	83 f8 02             	cmp    $0x2,%eax
  801f73:	7f 07                	jg     801f7c <alloc_block+0x21>
  801f75:	83 f8 01             	cmp    $0x1,%eax
  801f78:	74 0e                	je     801f88 <alloc_block+0x2d>
  801f7a:	eb 58                	jmp    801fd4 <alloc_block+0x79>
  801f7c:	83 f8 03             	cmp    $0x3,%eax
  801f7f:	74 2d                	je     801fae <alloc_block+0x53>
  801f81:	83 f8 04             	cmp    $0x4,%eax
  801f84:	74 3b                	je     801fc1 <alloc_block+0x66>
  801f86:	eb 4c                	jmp    801fd4 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f88:	83 ec 0c             	sub    $0xc,%esp
  801f8b:	ff 75 08             	pushl  0x8(%ebp)
  801f8e:	e8 11 03 00 00       	call   8022a4 <alloc_block_FF>
  801f93:	83 c4 10             	add    $0x10,%esp
  801f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f99:	eb 4a                	jmp    801fe5 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f9b:	83 ec 0c             	sub    $0xc,%esp
  801f9e:	ff 75 08             	pushl  0x8(%ebp)
  801fa1:	e8 c7 19 00 00       	call   80396d <alloc_block_NF>
  801fa6:	83 c4 10             	add    $0x10,%esp
  801fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fac:	eb 37                	jmp    801fe5 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	ff 75 08             	pushl  0x8(%ebp)
  801fb4:	e8 a7 07 00 00       	call   802760 <alloc_block_BF>
  801fb9:	83 c4 10             	add    $0x10,%esp
  801fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fbf:	eb 24                	jmp    801fe5 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	ff 75 08             	pushl  0x8(%ebp)
  801fc7:	e8 84 19 00 00       	call   803950 <alloc_block_WF>
  801fcc:	83 c4 10             	add    $0x10,%esp
  801fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd2:	eb 11                	jmp    801fe5 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801fd4:	83 ec 0c             	sub    $0xc,%esp
  801fd7:	68 9c 43 80 00       	push   $0x80439c
  801fdc:	e8 a9 e3 ff ff       	call   80038a <cprintf>
  801fe1:	83 c4 10             	add    $0x10,%esp
		break;
  801fe4:	90                   	nop
	}
	return va;
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	53                   	push   %ebx
  801fee:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	68 bc 43 80 00       	push   $0x8043bc
  801ff9:	e8 8c e3 ff ff       	call   80038a <cprintf>
  801ffe:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802001:	83 ec 0c             	sub    $0xc,%esp
  802004:	68 e7 43 80 00       	push   $0x8043e7
  802009:	e8 7c e3 ff ff       	call   80038a <cprintf>
  80200e:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802017:	eb 37                	jmp    802050 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802019:	83 ec 0c             	sub    $0xc,%esp
  80201c:	ff 75 f4             	pushl  -0xc(%ebp)
  80201f:	e8 19 ff ff ff       	call   801f3d <is_free_block>
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	0f be d8             	movsbl %al,%ebx
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	ff 75 f4             	pushl  -0xc(%ebp)
  802030:	e8 ef fe ff ff       	call   801f24 <get_block_size>
  802035:	83 c4 10             	add    $0x10,%esp
  802038:	83 ec 04             	sub    $0x4,%esp
  80203b:	53                   	push   %ebx
  80203c:	50                   	push   %eax
  80203d:	68 ff 43 80 00       	push   $0x8043ff
  802042:	e8 43 e3 ff ff       	call   80038a <cprintf>
  802047:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80204a:	8b 45 10             	mov    0x10(%ebp),%eax
  80204d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802050:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802054:	74 07                	je     80205d <print_blocks_list+0x73>
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	8b 00                	mov    (%eax),%eax
  80205b:	eb 05                	jmp    802062 <print_blocks_list+0x78>
  80205d:	b8 00 00 00 00       	mov    $0x0,%eax
  802062:	89 45 10             	mov    %eax,0x10(%ebp)
  802065:	8b 45 10             	mov    0x10(%ebp),%eax
  802068:	85 c0                	test   %eax,%eax
  80206a:	75 ad                	jne    802019 <print_blocks_list+0x2f>
  80206c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802070:	75 a7                	jne    802019 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802072:	83 ec 0c             	sub    $0xc,%esp
  802075:	68 bc 43 80 00       	push   $0x8043bc
  80207a:	e8 0b e3 ff ff       	call   80038a <cprintf>
  80207f:	83 c4 10             	add    $0x10,%esp

}
  802082:	90                   	nop
  802083:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80208e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802091:	83 e0 01             	and    $0x1,%eax
  802094:	85 c0                	test   %eax,%eax
  802096:	74 03                	je     80209b <initialize_dynamic_allocator+0x13>
  802098:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80209b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80209f:	0f 84 c7 01 00 00    	je     80226c <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020a5:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020ac:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020af:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b5:	01 d0                	add    %edx,%eax
  8020b7:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020bc:	0f 87 ad 01 00 00    	ja     80226f <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	0f 89 a5 01 00 00    	jns    802272 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  8020cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d3:	01 d0                	add    %edx,%eax
  8020d5:	83 e8 04             	sub    $0x4,%eax
  8020d8:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  8020dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  8020e4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ec:	e9 87 00 00 00       	jmp    802178 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f5:	75 14                	jne    80210b <initialize_dynamic_allocator+0x83>
  8020f7:	83 ec 04             	sub    $0x4,%esp
  8020fa:	68 17 44 80 00       	push   $0x804417
  8020ff:	6a 79                	push   $0x79
  802101:	68 35 44 80 00       	push   $0x804435
  802106:	e8 bb 18 00 00       	call   8039c6 <_panic>
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	8b 00                	mov    (%eax),%eax
  802110:	85 c0                	test   %eax,%eax
  802112:	74 10                	je     802124 <initialize_dynamic_allocator+0x9c>
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802117:	8b 00                	mov    (%eax),%eax
  802119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211c:	8b 52 04             	mov    0x4(%edx),%edx
  80211f:	89 50 04             	mov    %edx,0x4(%eax)
  802122:	eb 0b                	jmp    80212f <initialize_dynamic_allocator+0xa7>
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 40 04             	mov    0x4(%eax),%eax
  80212a:	a3 30 50 80 00       	mov    %eax,0x805030
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	8b 40 04             	mov    0x4(%eax),%eax
  802135:	85 c0                	test   %eax,%eax
  802137:	74 0f                	je     802148 <initialize_dynamic_allocator+0xc0>
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	8b 40 04             	mov    0x4(%eax),%eax
  80213f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802142:	8b 12                	mov    (%edx),%edx
  802144:	89 10                	mov    %edx,(%eax)
  802146:	eb 0a                	jmp    802152 <initialize_dynamic_allocator+0xca>
  802148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214b:	8b 00                	mov    (%eax),%eax
  80214d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80215b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802165:	a1 38 50 80 00       	mov    0x805038,%eax
  80216a:	48                   	dec    %eax
  80216b:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802170:	a1 34 50 80 00       	mov    0x805034,%eax
  802175:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802178:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217c:	74 07                	je     802185 <initialize_dynamic_allocator+0xfd>
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	8b 00                	mov    (%eax),%eax
  802183:	eb 05                	jmp    80218a <initialize_dynamic_allocator+0x102>
  802185:	b8 00 00 00 00       	mov    $0x0,%eax
  80218a:	a3 34 50 80 00       	mov    %eax,0x805034
  80218f:	a1 34 50 80 00       	mov    0x805034,%eax
  802194:	85 c0                	test   %eax,%eax
  802196:	0f 85 55 ff ff ff    	jne    8020f1 <initialize_dynamic_allocator+0x69>
  80219c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a0:	0f 85 4b ff ff ff    	jne    8020f1 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021af:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021b5:	a1 44 50 80 00       	mov    0x805044,%eax
  8021ba:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021bf:	a1 40 50 80 00       	mov    0x805040,%eax
  8021c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8021ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cd:	83 c0 08             	add    $0x8,%eax
  8021d0:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	83 c0 04             	add    $0x4,%eax
  8021d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dc:	83 ea 08             	sub    $0x8,%edx
  8021df:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8021e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	01 d0                	add    %edx,%eax
  8021e9:	83 e8 08             	sub    $0x8,%eax
  8021ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ef:	83 ea 08             	sub    $0x8,%edx
  8021f2:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802200:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802207:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80220b:	75 17                	jne    802224 <initialize_dynamic_allocator+0x19c>
  80220d:	83 ec 04             	sub    $0x4,%esp
  802210:	68 50 44 80 00       	push   $0x804450
  802215:	68 90 00 00 00       	push   $0x90
  80221a:	68 35 44 80 00       	push   $0x804435
  80221f:	e8 a2 17 00 00       	call   8039c6 <_panic>
  802224:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80222a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222d:	89 10                	mov    %edx,(%eax)
  80222f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802232:	8b 00                	mov    (%eax),%eax
  802234:	85 c0                	test   %eax,%eax
  802236:	74 0d                	je     802245 <initialize_dynamic_allocator+0x1bd>
  802238:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80223d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802240:	89 50 04             	mov    %edx,0x4(%eax)
  802243:	eb 08                	jmp    80224d <initialize_dynamic_allocator+0x1c5>
  802245:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802248:	a3 30 50 80 00       	mov    %eax,0x805030
  80224d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802250:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802255:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802258:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80225f:	a1 38 50 80 00       	mov    0x805038,%eax
  802264:	40                   	inc    %eax
  802265:	a3 38 50 80 00       	mov    %eax,0x805038
  80226a:	eb 07                	jmp    802273 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80226c:	90                   	nop
  80226d:	eb 04                	jmp    802273 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80226f:	90                   	nop
  802270:	eb 01                	jmp    802273 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802272:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802278:	8b 45 10             	mov    0x10(%ebp),%eax
  80227b:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	8d 50 fc             	lea    -0x4(%eax),%edx
  802284:	8b 45 0c             	mov    0xc(%ebp),%eax
  802287:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	83 e8 04             	sub    $0x4,%eax
  80228f:	8b 00                	mov    (%eax),%eax
  802291:	83 e0 fe             	and    $0xfffffffe,%eax
  802294:	8d 50 f8             	lea    -0x8(%eax),%edx
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	01 c2                	add    %eax,%edx
  80229c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229f:	89 02                	mov    %eax,(%edx)
}
  8022a1:	90                   	nop
  8022a2:	5d                   	pop    %ebp
  8022a3:	c3                   	ret    

008022a4 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	83 e0 01             	and    $0x1,%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	74 03                	je     8022b7 <alloc_block_FF+0x13>
  8022b4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022b7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022bb:	77 07                	ja     8022c4 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022bd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8022c4:	a1 24 50 80 00       	mov    0x805024,%eax
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	75 73                	jne    802340 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	83 c0 10             	add    $0x10,%eax
  8022d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8022d6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8022dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e3:	01 d0                	add    %edx,%eax
  8022e5:	48                   	dec    %eax
  8022e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8022f1:	f7 75 ec             	divl   -0x14(%ebp)
  8022f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022f7:	29 d0                	sub    %edx,%eax
  8022f9:	c1 e8 0c             	shr    $0xc,%eax
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	50                   	push   %eax
  802300:	e8 27 f0 ff ff       	call   80132c <sbrk>
  802305:	83 c4 10             	add    $0x10,%esp
  802308:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80230b:	83 ec 0c             	sub    $0xc,%esp
  80230e:	6a 00                	push   $0x0
  802310:	e8 17 f0 ff ff       	call   80132c <sbrk>
  802315:	83 c4 10             	add    $0x10,%esp
  802318:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80231b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80231e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802321:	83 ec 08             	sub    $0x8,%esp
  802324:	50                   	push   %eax
  802325:	ff 75 e4             	pushl  -0x1c(%ebp)
  802328:	e8 5b fd ff ff       	call   802088 <initialize_dynamic_allocator>
  80232d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802330:	83 ec 0c             	sub    $0xc,%esp
  802333:	68 73 44 80 00       	push   $0x804473
  802338:	e8 4d e0 ff ff       	call   80038a <cprintf>
  80233d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802344:	75 0a                	jne    802350 <alloc_block_FF+0xac>
	        return NULL;
  802346:	b8 00 00 00 00       	mov    $0x0,%eax
  80234b:	e9 0e 04 00 00       	jmp    80275e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802350:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802357:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80235c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235f:	e9 f3 02 00 00       	jmp    802657 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80236a:	83 ec 0c             	sub    $0xc,%esp
  80236d:	ff 75 bc             	pushl  -0x44(%ebp)
  802370:	e8 af fb ff ff       	call   801f24 <get_block_size>
  802375:	83 c4 10             	add    $0x10,%esp
  802378:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	83 c0 08             	add    $0x8,%eax
  802381:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802384:	0f 87 c5 02 00 00    	ja     80264f <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	83 c0 18             	add    $0x18,%eax
  802390:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802393:	0f 87 19 02 00 00    	ja     8025b2 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802399:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80239c:	2b 45 08             	sub    0x8(%ebp),%eax
  80239f:	83 e8 08             	sub    $0x8,%eax
  8023a2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	8d 50 08             	lea    0x8(%eax),%edx
  8023ab:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	83 c0 08             	add    $0x8,%eax
  8023b9:	83 ec 04             	sub    $0x4,%esp
  8023bc:	6a 01                	push   $0x1
  8023be:	50                   	push   %eax
  8023bf:	ff 75 bc             	pushl  -0x44(%ebp)
  8023c2:	e8 ae fe ff ff       	call   802275 <set_block_data>
  8023c7:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 40 04             	mov    0x4(%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	75 68                	jne    80243c <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023d4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023d8:	75 17                	jne    8023f1 <alloc_block_FF+0x14d>
  8023da:	83 ec 04             	sub    $0x4,%esp
  8023dd:	68 50 44 80 00       	push   $0x804450
  8023e2:	68 d7 00 00 00       	push   $0xd7
  8023e7:	68 35 44 80 00       	push   $0x804435
  8023ec:	e8 d5 15 00 00       	call   8039c6 <_panic>
  8023f1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023fa:	89 10                	mov    %edx,(%eax)
  8023fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	85 c0                	test   %eax,%eax
  802403:	74 0d                	je     802412 <alloc_block_FF+0x16e>
  802405:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80240a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80240d:	89 50 04             	mov    %edx,0x4(%eax)
  802410:	eb 08                	jmp    80241a <alloc_block_FF+0x176>
  802412:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802415:	a3 30 50 80 00       	mov    %eax,0x805030
  80241a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802422:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802425:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80242c:	a1 38 50 80 00       	mov    0x805038,%eax
  802431:	40                   	inc    %eax
  802432:	a3 38 50 80 00       	mov    %eax,0x805038
  802437:	e9 dc 00 00 00       	jmp    802518 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	8b 00                	mov    (%eax),%eax
  802441:	85 c0                	test   %eax,%eax
  802443:	75 65                	jne    8024aa <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802445:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802449:	75 17                	jne    802462 <alloc_block_FF+0x1be>
  80244b:	83 ec 04             	sub    $0x4,%esp
  80244e:	68 84 44 80 00       	push   $0x804484
  802453:	68 db 00 00 00       	push   $0xdb
  802458:	68 35 44 80 00       	push   $0x804435
  80245d:	e8 64 15 00 00       	call   8039c6 <_panic>
  802462:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802468:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246b:	89 50 04             	mov    %edx,0x4(%eax)
  80246e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802471:	8b 40 04             	mov    0x4(%eax),%eax
  802474:	85 c0                	test   %eax,%eax
  802476:	74 0c                	je     802484 <alloc_block_FF+0x1e0>
  802478:	a1 30 50 80 00       	mov    0x805030,%eax
  80247d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802480:	89 10                	mov    %edx,(%eax)
  802482:	eb 08                	jmp    80248c <alloc_block_FF+0x1e8>
  802484:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802487:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80248c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248f:	a3 30 50 80 00       	mov    %eax,0x805030
  802494:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802497:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249d:	a1 38 50 80 00       	mov    0x805038,%eax
  8024a2:	40                   	inc    %eax
  8024a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8024a8:	eb 6e                	jmp    802518 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ae:	74 06                	je     8024b6 <alloc_block_FF+0x212>
  8024b0:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024b4:	75 17                	jne    8024cd <alloc_block_FF+0x229>
  8024b6:	83 ec 04             	sub    $0x4,%esp
  8024b9:	68 a8 44 80 00       	push   $0x8044a8
  8024be:	68 df 00 00 00       	push   $0xdf
  8024c3:	68 35 44 80 00       	push   $0x804435
  8024c8:	e8 f9 14 00 00       	call   8039c6 <_panic>
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 10                	mov    (%eax),%edx
  8024d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d5:	89 10                	mov    %edx,(%eax)
  8024d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024da:	8b 00                	mov    (%eax),%eax
  8024dc:	85 c0                	test   %eax,%eax
  8024de:	74 0b                	je     8024eb <alloc_block_FF+0x247>
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 00                	mov    (%eax),%eax
  8024e5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024e8:	89 50 04             	mov    %edx,0x4(%eax)
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024f1:	89 10                	mov    %edx,(%eax)
  8024f3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f9:	89 50 04             	mov    %edx,0x4(%eax)
  8024fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	85 c0                	test   %eax,%eax
  802503:	75 08                	jne    80250d <alloc_block_FF+0x269>
  802505:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802508:	a3 30 50 80 00       	mov    %eax,0x805030
  80250d:	a1 38 50 80 00       	mov    0x805038,%eax
  802512:	40                   	inc    %eax
  802513:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802518:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251c:	75 17                	jne    802535 <alloc_block_FF+0x291>
  80251e:	83 ec 04             	sub    $0x4,%esp
  802521:	68 17 44 80 00       	push   $0x804417
  802526:	68 e1 00 00 00       	push   $0xe1
  80252b:	68 35 44 80 00       	push   $0x804435
  802530:	e8 91 14 00 00       	call   8039c6 <_panic>
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 00                	mov    (%eax),%eax
  80253a:	85 c0                	test   %eax,%eax
  80253c:	74 10                	je     80254e <alloc_block_FF+0x2aa>
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 00                	mov    (%eax),%eax
  802543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802546:	8b 52 04             	mov    0x4(%edx),%edx
  802549:	89 50 04             	mov    %edx,0x4(%eax)
  80254c:	eb 0b                	jmp    802559 <alloc_block_FF+0x2b5>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 40 04             	mov    0x4(%eax),%eax
  802554:	a3 30 50 80 00       	mov    %eax,0x805030
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 40 04             	mov    0x4(%eax),%eax
  80255f:	85 c0                	test   %eax,%eax
  802561:	74 0f                	je     802572 <alloc_block_FF+0x2ce>
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 40 04             	mov    0x4(%eax),%eax
  802569:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256c:	8b 12                	mov    (%edx),%edx
  80256e:	89 10                	mov    %edx,(%eax)
  802570:	eb 0a                	jmp    80257c <alloc_block_FF+0x2d8>
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
				set_block_data(new_block_va, remaining_size, 0);
  80259a:	83 ec 04             	sub    $0x4,%esp
  80259d:	6a 00                	push   $0x0
  80259f:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025a2:	ff 75 b0             	pushl  -0x50(%ebp)
  8025a5:	e8 cb fc ff ff       	call   802275 <set_block_data>
  8025aa:	83 c4 10             	add    $0x10,%esp
  8025ad:	e9 95 00 00 00       	jmp    802647 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025b2:	83 ec 04             	sub    $0x4,%esp
  8025b5:	6a 01                	push   $0x1
  8025b7:	ff 75 b8             	pushl  -0x48(%ebp)
  8025ba:	ff 75 bc             	pushl  -0x44(%ebp)
  8025bd:	e8 b3 fc ff ff       	call   802275 <set_block_data>
  8025c2:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8025c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c9:	75 17                	jne    8025e2 <alloc_block_FF+0x33e>
  8025cb:	83 ec 04             	sub    $0x4,%esp
  8025ce:	68 17 44 80 00       	push   $0x804417
  8025d3:	68 e8 00 00 00       	push   $0xe8
  8025d8:	68 35 44 80 00       	push   $0x804435
  8025dd:	e8 e4 13 00 00       	call   8039c6 <_panic>
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 00                	mov    (%eax),%eax
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	74 10                	je     8025fb <alloc_block_FF+0x357>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f3:	8b 52 04             	mov    0x4(%edx),%edx
  8025f6:	89 50 04             	mov    %edx,0x4(%eax)
  8025f9:	eb 0b                	jmp    802606 <alloc_block_FF+0x362>
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 40 04             	mov    0x4(%eax),%eax
  802601:	a3 30 50 80 00       	mov    %eax,0x805030
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 40 04             	mov    0x4(%eax),%eax
  80260c:	85 c0                	test   %eax,%eax
  80260e:	74 0f                	je     80261f <alloc_block_FF+0x37b>
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 40 04             	mov    0x4(%eax),%eax
  802616:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802619:	8b 12                	mov    (%edx),%edx
  80261b:	89 10                	mov    %edx,(%eax)
  80261d:	eb 0a                	jmp    802629 <alloc_block_FF+0x385>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263c:	a1 38 50 80 00       	mov    0x805038,%eax
  802641:	48                   	dec    %eax
  802642:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802647:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80264a:	e9 0f 01 00 00       	jmp    80275e <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80264f:	a1 34 50 80 00       	mov    0x805034,%eax
  802654:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265b:	74 07                	je     802664 <alloc_block_FF+0x3c0>
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 00                	mov    (%eax),%eax
  802662:	eb 05                	jmp    802669 <alloc_block_FF+0x3c5>
  802664:	b8 00 00 00 00       	mov    $0x0,%eax
  802669:	a3 34 50 80 00       	mov    %eax,0x805034
  80266e:	a1 34 50 80 00       	mov    0x805034,%eax
  802673:	85 c0                	test   %eax,%eax
  802675:	0f 85 e9 fc ff ff    	jne    802364 <alloc_block_FF+0xc0>
  80267b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267f:	0f 85 df fc ff ff    	jne    802364 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802685:	8b 45 08             	mov    0x8(%ebp),%eax
  802688:	83 c0 08             	add    $0x8,%eax
  80268b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80268e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802695:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802698:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80269b:	01 d0                	add    %edx,%eax
  80269d:	48                   	dec    %eax
  80269e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a9:	f7 75 d8             	divl   -0x28(%ebp)
  8026ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026af:	29 d0                	sub    %edx,%eax
  8026b1:	c1 e8 0c             	shr    $0xc,%eax
  8026b4:	83 ec 0c             	sub    $0xc,%esp
  8026b7:	50                   	push   %eax
  8026b8:	e8 6f ec ff ff       	call   80132c <sbrk>
  8026bd:	83 c4 10             	add    $0x10,%esp
  8026c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8026c3:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8026c7:	75 0a                	jne    8026d3 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ce:	e9 8b 00 00 00       	jmp    80275e <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8026d3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8026da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026e0:	01 d0                	add    %edx,%eax
  8026e2:	48                   	dec    %eax
  8026e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8026e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ee:	f7 75 cc             	divl   -0x34(%ebp)
  8026f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026f4:	29 d0                	sub    %edx,%eax
  8026f6:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026fc:	01 d0                	add    %edx,%eax
  8026fe:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802703:	a1 40 50 80 00       	mov    0x805040,%eax
  802708:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80270e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802715:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802718:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80271b:	01 d0                	add    %edx,%eax
  80271d:	48                   	dec    %eax
  80271e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802721:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802724:	ba 00 00 00 00       	mov    $0x0,%edx
  802729:	f7 75 c4             	divl   -0x3c(%ebp)
  80272c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80272f:	29 d0                	sub    %edx,%eax
  802731:	83 ec 04             	sub    $0x4,%esp
  802734:	6a 01                	push   $0x1
  802736:	50                   	push   %eax
  802737:	ff 75 d0             	pushl  -0x30(%ebp)
  80273a:	e8 36 fb ff ff       	call   802275 <set_block_data>
  80273f:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802742:	83 ec 0c             	sub    $0xc,%esp
  802745:	ff 75 d0             	pushl  -0x30(%ebp)
  802748:	e8 f8 09 00 00       	call   803145 <free_block>
  80274d:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802750:	83 ec 0c             	sub    $0xc,%esp
  802753:	ff 75 08             	pushl  0x8(%ebp)
  802756:	e8 49 fb ff ff       	call   8022a4 <alloc_block_FF>
  80275b:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80275e:	c9                   	leave  
  80275f:	c3                   	ret    

00802760 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
  802763:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802766:	8b 45 08             	mov    0x8(%ebp),%eax
  802769:	83 e0 01             	and    $0x1,%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	74 03                	je     802773 <alloc_block_BF+0x13>
  802770:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802773:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802777:	77 07                	ja     802780 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802779:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802780:	a1 24 50 80 00       	mov    0x805024,%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	75 73                	jne    8027fc <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802789:	8b 45 08             	mov    0x8(%ebp),%eax
  80278c:	83 c0 10             	add    $0x10,%eax
  80278f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802792:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802799:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80279c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279f:	01 d0                	add    %edx,%eax
  8027a1:	48                   	dec    %eax
  8027a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ad:	f7 75 e0             	divl   -0x20(%ebp)
  8027b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027b3:	29 d0                	sub    %edx,%eax
  8027b5:	c1 e8 0c             	shr    $0xc,%eax
  8027b8:	83 ec 0c             	sub    $0xc,%esp
  8027bb:	50                   	push   %eax
  8027bc:	e8 6b eb ff ff       	call   80132c <sbrk>
  8027c1:	83 c4 10             	add    $0x10,%esp
  8027c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8027c7:	83 ec 0c             	sub    $0xc,%esp
  8027ca:	6a 00                	push   $0x0
  8027cc:	e8 5b eb ff ff       	call   80132c <sbrk>
  8027d1:	83 c4 10             	add    $0x10,%esp
  8027d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8027d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027da:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8027dd:	83 ec 08             	sub    $0x8,%esp
  8027e0:	50                   	push   %eax
  8027e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8027e4:	e8 9f f8 ff ff       	call   802088 <initialize_dynamic_allocator>
  8027e9:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027ec:	83 ec 0c             	sub    $0xc,%esp
  8027ef:	68 73 44 80 00       	push   $0x804473
  8027f4:	e8 91 db ff ff       	call   80038a <cprintf>
  8027f9:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802803:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80280a:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802811:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802818:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80281d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802820:	e9 1d 01 00 00       	jmp    802942 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80282b:	83 ec 0c             	sub    $0xc,%esp
  80282e:	ff 75 a8             	pushl  -0x58(%ebp)
  802831:	e8 ee f6 ff ff       	call   801f24 <get_block_size>
  802836:	83 c4 10             	add    $0x10,%esp
  802839:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80283c:	8b 45 08             	mov    0x8(%ebp),%eax
  80283f:	83 c0 08             	add    $0x8,%eax
  802842:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802845:	0f 87 ef 00 00 00    	ja     80293a <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	83 c0 18             	add    $0x18,%eax
  802851:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802854:	77 1d                	ja     802873 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802859:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80285c:	0f 86 d8 00 00 00    	jbe    80293a <alloc_block_BF+0x1da>
				{
					best_va = va;
  802862:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802865:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802868:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80286b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80286e:	e9 c7 00 00 00       	jmp    80293a <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	83 c0 08             	add    $0x8,%eax
  802879:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80287c:	0f 85 9d 00 00 00    	jne    80291f <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802882:	83 ec 04             	sub    $0x4,%esp
  802885:	6a 01                	push   $0x1
  802887:	ff 75 a4             	pushl  -0x5c(%ebp)
  80288a:	ff 75 a8             	pushl  -0x58(%ebp)
  80288d:	e8 e3 f9 ff ff       	call   802275 <set_block_data>
  802892:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802895:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802899:	75 17                	jne    8028b2 <alloc_block_BF+0x152>
  80289b:	83 ec 04             	sub    $0x4,%esp
  80289e:	68 17 44 80 00       	push   $0x804417
  8028a3:	68 2c 01 00 00       	push   $0x12c
  8028a8:	68 35 44 80 00       	push   $0x804435
  8028ad:	e8 14 11 00 00       	call   8039c6 <_panic>
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	74 10                	je     8028cb <alloc_block_BF+0x16b>
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 00                	mov    (%eax),%eax
  8028c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c3:	8b 52 04             	mov    0x4(%edx),%edx
  8028c6:	89 50 04             	mov    %edx,0x4(%eax)
  8028c9:	eb 0b                	jmp    8028d6 <alloc_block_BF+0x176>
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 40 04             	mov    0x4(%eax),%eax
  8028d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 40 04             	mov    0x4(%eax),%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	74 0f                	je     8028ef <alloc_block_BF+0x18f>
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e9:	8b 12                	mov    (%edx),%edx
  8028eb:	89 10                	mov    %edx,(%eax)
  8028ed:	eb 0a                	jmp    8028f9 <alloc_block_BF+0x199>
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80290c:	a1 38 50 80 00       	mov    0x805038,%eax
  802911:	48                   	dec    %eax
  802912:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802917:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80291a:	e9 01 04 00 00       	jmp    802d20 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80291f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802922:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802925:	76 13                	jbe    80293a <alloc_block_BF+0x1da>
					{
						internal = 1;
  802927:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80292e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802931:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802934:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802937:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80293a:	a1 34 50 80 00       	mov    0x805034,%eax
  80293f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802946:	74 07                	je     80294f <alloc_block_BF+0x1ef>
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	eb 05                	jmp    802954 <alloc_block_BF+0x1f4>
  80294f:	b8 00 00 00 00       	mov    $0x0,%eax
  802954:	a3 34 50 80 00       	mov    %eax,0x805034
  802959:	a1 34 50 80 00       	mov    0x805034,%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	0f 85 bf fe ff ff    	jne    802825 <alloc_block_BF+0xc5>
  802966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296a:	0f 85 b5 fe ff ff    	jne    802825 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802970:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802974:	0f 84 26 02 00 00    	je     802ba0 <alloc_block_BF+0x440>
  80297a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80297e:	0f 85 1c 02 00 00    	jne    802ba0 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802987:	2b 45 08             	sub    0x8(%ebp),%eax
  80298a:	83 e8 08             	sub    $0x8,%eax
  80298d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	8d 50 08             	lea    0x8(%eax),%edx
  802996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802999:	01 d0                	add    %edx,%eax
  80299b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	83 c0 08             	add    $0x8,%eax
  8029a4:	83 ec 04             	sub    $0x4,%esp
  8029a7:	6a 01                	push   $0x1
  8029a9:	50                   	push   %eax
  8029aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8029ad:	e8 c3 f8 ff ff       	call   802275 <set_block_data>
  8029b2:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b8:	8b 40 04             	mov    0x4(%eax),%eax
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	75 68                	jne    802a27 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029bf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029c3:	75 17                	jne    8029dc <alloc_block_BF+0x27c>
  8029c5:	83 ec 04             	sub    $0x4,%esp
  8029c8:	68 50 44 80 00       	push   $0x804450
  8029cd:	68 45 01 00 00       	push   $0x145
  8029d2:	68 35 44 80 00       	push   $0x804435
  8029d7:	e8 ea 0f 00 00       	call   8039c6 <_panic>
  8029dc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8029e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e5:	89 10                	mov    %edx,(%eax)
  8029e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ea:	8b 00                	mov    (%eax),%eax
  8029ec:	85 c0                	test   %eax,%eax
  8029ee:	74 0d                	je     8029fd <alloc_block_BF+0x29d>
  8029f0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029f5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	eb 08                	jmp    802a05 <alloc_block_BF+0x2a5>
  8029fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a00:	a3 30 50 80 00       	mov    %eax,0x805030
  802a05:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a08:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a17:	a1 38 50 80 00       	mov    0x805038,%eax
  802a1c:	40                   	inc    %eax
  802a1d:	a3 38 50 80 00       	mov    %eax,0x805038
  802a22:	e9 dc 00 00 00       	jmp    802b03 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2a:	8b 00                	mov    (%eax),%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	75 65                	jne    802a95 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a30:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a34:	75 17                	jne    802a4d <alloc_block_BF+0x2ed>
  802a36:	83 ec 04             	sub    $0x4,%esp
  802a39:	68 84 44 80 00       	push   $0x804484
  802a3e:	68 4a 01 00 00       	push   $0x14a
  802a43:	68 35 44 80 00       	push   $0x804435
  802a48:	e8 79 0f 00 00       	call   8039c6 <_panic>
  802a4d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a56:	89 50 04             	mov    %edx,0x4(%eax)
  802a59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a5c:	8b 40 04             	mov    0x4(%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	74 0c                	je     802a6f <alloc_block_BF+0x30f>
  802a63:	a1 30 50 80 00       	mov    0x805030,%eax
  802a68:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a6b:	89 10                	mov    %edx,(%eax)
  802a6d:	eb 08                	jmp    802a77 <alloc_block_BF+0x317>
  802a6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a72:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a88:	a1 38 50 80 00       	mov    0x805038,%eax
  802a8d:	40                   	inc    %eax
  802a8e:	a3 38 50 80 00       	mov    %eax,0x805038
  802a93:	eb 6e                	jmp    802b03 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a99:	74 06                	je     802aa1 <alloc_block_BF+0x341>
  802a9b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a9f:	75 17                	jne    802ab8 <alloc_block_BF+0x358>
  802aa1:	83 ec 04             	sub    $0x4,%esp
  802aa4:	68 a8 44 80 00       	push   $0x8044a8
  802aa9:	68 4f 01 00 00       	push   $0x14f
  802aae:	68 35 44 80 00       	push   $0x804435
  802ab3:	e8 0e 0f 00 00       	call   8039c6 <_panic>
  802ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abb:	8b 10                	mov    (%eax),%edx
  802abd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac0:	89 10                	mov    %edx,(%eax)
  802ac2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	74 0b                	je     802ad6 <alloc_block_BF+0x376>
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802ad3:	89 50 04             	mov    %edx,0x4(%eax)
  802ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802adc:	89 10                	mov    %edx,(%eax)
  802ade:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae4:	89 50 04             	mov    %edx,0x4(%eax)
  802ae7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	75 08                	jne    802af8 <alloc_block_BF+0x398>
  802af0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802af3:	a3 30 50 80 00       	mov    %eax,0x805030
  802af8:	a1 38 50 80 00       	mov    0x805038,%eax
  802afd:	40                   	inc    %eax
  802afe:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b07:	75 17                	jne    802b20 <alloc_block_BF+0x3c0>
  802b09:	83 ec 04             	sub    $0x4,%esp
  802b0c:	68 17 44 80 00       	push   $0x804417
  802b11:	68 51 01 00 00       	push   $0x151
  802b16:	68 35 44 80 00       	push   $0x804435
  802b1b:	e8 a6 0e 00 00       	call   8039c6 <_panic>
  802b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	85 c0                	test   %eax,%eax
  802b27:	74 10                	je     802b39 <alloc_block_BF+0x3d9>
  802b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2c:	8b 00                	mov    (%eax),%eax
  802b2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b31:	8b 52 04             	mov    0x4(%edx),%edx
  802b34:	89 50 04             	mov    %edx,0x4(%eax)
  802b37:	eb 0b                	jmp    802b44 <alloc_block_BF+0x3e4>
  802b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3c:	8b 40 04             	mov    0x4(%eax),%eax
  802b3f:	a3 30 50 80 00       	mov    %eax,0x805030
  802b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b47:	8b 40 04             	mov    0x4(%eax),%eax
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	74 0f                	je     802b5d <alloc_block_BF+0x3fd>
  802b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b51:	8b 40 04             	mov    0x4(%eax),%eax
  802b54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b57:	8b 12                	mov    (%edx),%edx
  802b59:	89 10                	mov    %edx,(%eax)
  802b5b:	eb 0a                	jmp    802b67 <alloc_block_BF+0x407>
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	8b 00                	mov    (%eax),%eax
  802b62:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7a:	a1 38 50 80 00       	mov    0x805038,%eax
  802b7f:	48                   	dec    %eax
  802b80:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b85:	83 ec 04             	sub    $0x4,%esp
  802b88:	6a 00                	push   $0x0
  802b8a:	ff 75 d0             	pushl  -0x30(%ebp)
  802b8d:	ff 75 cc             	pushl  -0x34(%ebp)
  802b90:	e8 e0 f6 ff ff       	call   802275 <set_block_data>
  802b95:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9b:	e9 80 01 00 00       	jmp    802d20 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802ba0:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802ba4:	0f 85 9d 00 00 00    	jne    802c47 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802baa:	83 ec 04             	sub    $0x4,%esp
  802bad:	6a 01                	push   $0x1
  802baf:	ff 75 ec             	pushl  -0x14(%ebp)
  802bb2:	ff 75 f0             	pushl  -0x10(%ebp)
  802bb5:	e8 bb f6 ff ff       	call   802275 <set_block_data>
  802bba:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bc1:	75 17                	jne    802bda <alloc_block_BF+0x47a>
  802bc3:	83 ec 04             	sub    $0x4,%esp
  802bc6:	68 17 44 80 00       	push   $0x804417
  802bcb:	68 58 01 00 00       	push   $0x158
  802bd0:	68 35 44 80 00       	push   $0x804435
  802bd5:	e8 ec 0d 00 00       	call   8039c6 <_panic>
  802bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	74 10                	je     802bf3 <alloc_block_BF+0x493>
  802be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802beb:	8b 52 04             	mov    0x4(%edx),%edx
  802bee:	89 50 04             	mov    %edx,0x4(%eax)
  802bf1:	eb 0b                	jmp    802bfe <alloc_block_BF+0x49e>
  802bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf6:	8b 40 04             	mov    0x4(%eax),%eax
  802bf9:	a3 30 50 80 00       	mov    %eax,0x805030
  802bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c01:	8b 40 04             	mov    0x4(%eax),%eax
  802c04:	85 c0                	test   %eax,%eax
  802c06:	74 0f                	je     802c17 <alloc_block_BF+0x4b7>
  802c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0b:	8b 40 04             	mov    0x4(%eax),%eax
  802c0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c11:	8b 12                	mov    (%edx),%edx
  802c13:	89 10                	mov    %edx,(%eax)
  802c15:	eb 0a                	jmp    802c21 <alloc_block_BF+0x4c1>
  802c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1a:	8b 00                	mov    (%eax),%eax
  802c1c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c34:	a1 38 50 80 00       	mov    0x805038,%eax
  802c39:	48                   	dec    %eax
  802c3a:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c42:	e9 d9 00 00 00       	jmp    802d20 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	83 c0 08             	add    $0x8,%eax
  802c4d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c50:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c57:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c5a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c5d:	01 d0                	add    %edx,%eax
  802c5f:	48                   	dec    %eax
  802c60:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c63:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c66:	ba 00 00 00 00       	mov    $0x0,%edx
  802c6b:	f7 75 c4             	divl   -0x3c(%ebp)
  802c6e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c71:	29 d0                	sub    %edx,%eax
  802c73:	c1 e8 0c             	shr    $0xc,%eax
  802c76:	83 ec 0c             	sub    $0xc,%esp
  802c79:	50                   	push   %eax
  802c7a:	e8 ad e6 ff ff       	call   80132c <sbrk>
  802c7f:	83 c4 10             	add    $0x10,%esp
  802c82:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c85:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c89:	75 0a                	jne    802c95 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c90:	e9 8b 00 00 00       	jmp    802d20 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c95:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c9c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c9f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ca2:	01 d0                	add    %edx,%eax
  802ca4:	48                   	dec    %eax
  802ca5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ca8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cab:	ba 00 00 00 00       	mov    $0x0,%edx
  802cb0:	f7 75 b8             	divl   -0x48(%ebp)
  802cb3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cb6:	29 d0                	sub    %edx,%eax
  802cb8:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cbb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cbe:	01 d0                	add    %edx,%eax
  802cc0:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802cc5:	a1 40 50 80 00       	mov    0x805040,%eax
  802cca:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802cd0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cd7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cda:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cdd:	01 d0                	add    %edx,%eax
  802cdf:	48                   	dec    %eax
  802ce0:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ce3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  802ceb:	f7 75 b0             	divl   -0x50(%ebp)
  802cee:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cf1:	29 d0                	sub    %edx,%eax
  802cf3:	83 ec 04             	sub    $0x4,%esp
  802cf6:	6a 01                	push   $0x1
  802cf8:	50                   	push   %eax
  802cf9:	ff 75 bc             	pushl  -0x44(%ebp)
  802cfc:	e8 74 f5 ff ff       	call   802275 <set_block_data>
  802d01:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d04:	83 ec 0c             	sub    $0xc,%esp
  802d07:	ff 75 bc             	pushl  -0x44(%ebp)
  802d0a:	e8 36 04 00 00       	call   803145 <free_block>
  802d0f:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d12:	83 ec 0c             	sub    $0xc,%esp
  802d15:	ff 75 08             	pushl  0x8(%ebp)
  802d18:	e8 43 fa ff ff       	call   802760 <alloc_block_BF>
  802d1d:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d20:	c9                   	leave  
  802d21:	c3                   	ret    

00802d22 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d22:	55                   	push   %ebp
  802d23:	89 e5                	mov    %esp,%ebp
  802d25:	53                   	push   %ebx
  802d26:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d3b:	74 1e                	je     802d5b <merging+0x39>
  802d3d:	ff 75 08             	pushl  0x8(%ebp)
  802d40:	e8 df f1 ff ff       	call   801f24 <get_block_size>
  802d45:	83 c4 04             	add    $0x4,%esp
  802d48:	89 c2                	mov    %eax,%edx
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	01 d0                	add    %edx,%eax
  802d4f:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d52:	75 07                	jne    802d5b <merging+0x39>
		prev_is_free = 1;
  802d54:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d5f:	74 1e                	je     802d7f <merging+0x5d>
  802d61:	ff 75 10             	pushl  0x10(%ebp)
  802d64:	e8 bb f1 ff ff       	call   801f24 <get_block_size>
  802d69:	83 c4 04             	add    $0x4,%esp
  802d6c:	89 c2                	mov    %eax,%edx
  802d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  802d71:	01 d0                	add    %edx,%eax
  802d73:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d76:	75 07                	jne    802d7f <merging+0x5d>
		next_is_free = 1;
  802d78:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d83:	0f 84 cc 00 00 00    	je     802e55 <merging+0x133>
  802d89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8d:	0f 84 c2 00 00 00    	je     802e55 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d93:	ff 75 08             	pushl  0x8(%ebp)
  802d96:	e8 89 f1 ff ff       	call   801f24 <get_block_size>
  802d9b:	83 c4 04             	add    $0x4,%esp
  802d9e:	89 c3                	mov    %eax,%ebx
  802da0:	ff 75 10             	pushl  0x10(%ebp)
  802da3:	e8 7c f1 ff ff       	call   801f24 <get_block_size>
  802da8:	83 c4 04             	add    $0x4,%esp
  802dab:	01 c3                	add    %eax,%ebx
  802dad:	ff 75 0c             	pushl  0xc(%ebp)
  802db0:	e8 6f f1 ff ff       	call   801f24 <get_block_size>
  802db5:	83 c4 04             	add    $0x4,%esp
  802db8:	01 d8                	add    %ebx,%eax
  802dba:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dbd:	6a 00                	push   $0x0
  802dbf:	ff 75 ec             	pushl  -0x14(%ebp)
  802dc2:	ff 75 08             	pushl  0x8(%ebp)
  802dc5:	e8 ab f4 ff ff       	call   802275 <set_block_data>
  802dca:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dd1:	75 17                	jne    802dea <merging+0xc8>
  802dd3:	83 ec 04             	sub    $0x4,%esp
  802dd6:	68 17 44 80 00       	push   $0x804417
  802ddb:	68 7d 01 00 00       	push   $0x17d
  802de0:	68 35 44 80 00       	push   $0x804435
  802de5:	e8 dc 0b 00 00       	call   8039c6 <_panic>
  802dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	85 c0                	test   %eax,%eax
  802df1:	74 10                	je     802e03 <merging+0xe1>
  802df3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dfb:	8b 52 04             	mov    0x4(%edx),%edx
  802dfe:	89 50 04             	mov    %edx,0x4(%eax)
  802e01:	eb 0b                	jmp    802e0e <merging+0xec>
  802e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e06:	8b 40 04             	mov    0x4(%eax),%eax
  802e09:	a3 30 50 80 00       	mov    %eax,0x805030
  802e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 0f                	je     802e27 <merging+0x105>
  802e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1b:	8b 40 04             	mov    0x4(%eax),%eax
  802e1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e21:	8b 12                	mov    (%edx),%edx
  802e23:	89 10                	mov    %edx,(%eax)
  802e25:	eb 0a                	jmp    802e31 <merging+0x10f>
  802e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2a:	8b 00                	mov    (%eax),%eax
  802e2c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e44:	a1 38 50 80 00       	mov    0x805038,%eax
  802e49:	48                   	dec    %eax
  802e4a:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e4f:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e50:	e9 ea 02 00 00       	jmp    80313f <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e59:	74 3b                	je     802e96 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e5b:	83 ec 0c             	sub    $0xc,%esp
  802e5e:	ff 75 08             	pushl  0x8(%ebp)
  802e61:	e8 be f0 ff ff       	call   801f24 <get_block_size>
  802e66:	83 c4 10             	add    $0x10,%esp
  802e69:	89 c3                	mov    %eax,%ebx
  802e6b:	83 ec 0c             	sub    $0xc,%esp
  802e6e:	ff 75 10             	pushl  0x10(%ebp)
  802e71:	e8 ae f0 ff ff       	call   801f24 <get_block_size>
  802e76:	83 c4 10             	add    $0x10,%esp
  802e79:	01 d8                	add    %ebx,%eax
  802e7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e7e:	83 ec 04             	sub    $0x4,%esp
  802e81:	6a 00                	push   $0x0
  802e83:	ff 75 e8             	pushl  -0x18(%ebp)
  802e86:	ff 75 08             	pushl  0x8(%ebp)
  802e89:	e8 e7 f3 ff ff       	call   802275 <set_block_data>
  802e8e:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e91:	e9 a9 02 00 00       	jmp    80313f <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e9a:	0f 84 2d 01 00 00    	je     802fcd <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ea0:	83 ec 0c             	sub    $0xc,%esp
  802ea3:	ff 75 10             	pushl  0x10(%ebp)
  802ea6:	e8 79 f0 ff ff       	call   801f24 <get_block_size>
  802eab:	83 c4 10             	add    $0x10,%esp
  802eae:	89 c3                	mov    %eax,%ebx
  802eb0:	83 ec 0c             	sub    $0xc,%esp
  802eb3:	ff 75 0c             	pushl  0xc(%ebp)
  802eb6:	e8 69 f0 ff ff       	call   801f24 <get_block_size>
  802ebb:	83 c4 10             	add    $0x10,%esp
  802ebe:	01 d8                	add    %ebx,%eax
  802ec0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ec3:	83 ec 04             	sub    $0x4,%esp
  802ec6:	6a 00                	push   $0x0
  802ec8:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ecb:	ff 75 10             	pushl  0x10(%ebp)
  802ece:	e8 a2 f3 ff ff       	call   802275 <set_block_data>
  802ed3:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  802ed9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802edc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ee0:	74 06                	je     802ee8 <merging+0x1c6>
  802ee2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ee6:	75 17                	jne    802eff <merging+0x1dd>
  802ee8:	83 ec 04             	sub    $0x4,%esp
  802eeb:	68 dc 44 80 00       	push   $0x8044dc
  802ef0:	68 8d 01 00 00       	push   $0x18d
  802ef5:	68 35 44 80 00       	push   $0x804435
  802efa:	e8 c7 0a 00 00       	call   8039c6 <_panic>
  802eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f02:	8b 50 04             	mov    0x4(%eax),%edx
  802f05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f08:	89 50 04             	mov    %edx,0x4(%eax)
  802f0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f11:	89 10                	mov    %edx,(%eax)
  802f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f16:	8b 40 04             	mov    0x4(%eax),%eax
  802f19:	85 c0                	test   %eax,%eax
  802f1b:	74 0d                	je     802f2a <merging+0x208>
  802f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f20:	8b 40 04             	mov    0x4(%eax),%eax
  802f23:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f26:	89 10                	mov    %edx,(%eax)
  802f28:	eb 08                	jmp    802f32 <merging+0x210>
  802f2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f35:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f38:	89 50 04             	mov    %edx,0x4(%eax)
  802f3b:	a1 38 50 80 00       	mov    0x805038,%eax
  802f40:	40                   	inc    %eax
  802f41:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f4a:	75 17                	jne    802f63 <merging+0x241>
  802f4c:	83 ec 04             	sub    $0x4,%esp
  802f4f:	68 17 44 80 00       	push   $0x804417
  802f54:	68 8e 01 00 00       	push   $0x18e
  802f59:	68 35 44 80 00       	push   $0x804435
  802f5e:	e8 63 0a 00 00       	call   8039c6 <_panic>
  802f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f66:	8b 00                	mov    (%eax),%eax
  802f68:	85 c0                	test   %eax,%eax
  802f6a:	74 10                	je     802f7c <merging+0x25a>
  802f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6f:	8b 00                	mov    (%eax),%eax
  802f71:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f74:	8b 52 04             	mov    0x4(%edx),%edx
  802f77:	89 50 04             	mov    %edx,0x4(%eax)
  802f7a:	eb 0b                	jmp    802f87 <merging+0x265>
  802f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7f:	8b 40 04             	mov    0x4(%eax),%eax
  802f82:	a3 30 50 80 00       	mov    %eax,0x805030
  802f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	74 0f                	je     802fa0 <merging+0x27e>
  802f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f94:	8b 40 04             	mov    0x4(%eax),%eax
  802f97:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f9a:	8b 12                	mov    (%edx),%edx
  802f9c:	89 10                	mov    %edx,(%eax)
  802f9e:	eb 0a                	jmp    802faa <merging+0x288>
  802fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa3:	8b 00                	mov    (%eax),%eax
  802fa5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbd:	a1 38 50 80 00       	mov    0x805038,%eax
  802fc2:	48                   	dec    %eax
  802fc3:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802fc8:	e9 72 01 00 00       	jmp    80313f <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  802fd0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802fd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd7:	74 79                	je     803052 <merging+0x330>
  802fd9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fdd:	74 73                	je     803052 <merging+0x330>
  802fdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe3:	74 06                	je     802feb <merging+0x2c9>
  802fe5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fe9:	75 17                	jne    803002 <merging+0x2e0>
  802feb:	83 ec 04             	sub    $0x4,%esp
  802fee:	68 a8 44 80 00       	push   $0x8044a8
  802ff3:	68 94 01 00 00       	push   $0x194
  802ff8:	68 35 44 80 00       	push   $0x804435
  802ffd:	e8 c4 09 00 00       	call   8039c6 <_panic>
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	8b 10                	mov    (%eax),%edx
  803007:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300a:	89 10                	mov    %edx,(%eax)
  80300c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300f:	8b 00                	mov    (%eax),%eax
  803011:	85 c0                	test   %eax,%eax
  803013:	74 0b                	je     803020 <merging+0x2fe>
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	8b 00                	mov    (%eax),%eax
  80301a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80301d:	89 50 04             	mov    %edx,0x4(%eax)
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803026:	89 10                	mov    %edx,(%eax)
  803028:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302b:	8b 55 08             	mov    0x8(%ebp),%edx
  80302e:	89 50 04             	mov    %edx,0x4(%eax)
  803031:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	75 08                	jne    803042 <merging+0x320>
  80303a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303d:	a3 30 50 80 00       	mov    %eax,0x805030
  803042:	a1 38 50 80 00       	mov    0x805038,%eax
  803047:	40                   	inc    %eax
  803048:	a3 38 50 80 00       	mov    %eax,0x805038
  80304d:	e9 ce 00 00 00       	jmp    803120 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803052:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803056:	74 65                	je     8030bd <merging+0x39b>
  803058:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80305c:	75 17                	jne    803075 <merging+0x353>
  80305e:	83 ec 04             	sub    $0x4,%esp
  803061:	68 84 44 80 00       	push   $0x804484
  803066:	68 95 01 00 00       	push   $0x195
  80306b:	68 35 44 80 00       	push   $0x804435
  803070:	e8 51 09 00 00       	call   8039c6 <_panic>
  803075:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80307b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307e:	89 50 04             	mov    %edx,0x4(%eax)
  803081:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803084:	8b 40 04             	mov    0x4(%eax),%eax
  803087:	85 c0                	test   %eax,%eax
  803089:	74 0c                	je     803097 <merging+0x375>
  80308b:	a1 30 50 80 00       	mov    0x805030,%eax
  803090:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803093:	89 10                	mov    %edx,(%eax)
  803095:	eb 08                	jmp    80309f <merging+0x37d>
  803097:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80309f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8030a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b0:	a1 38 50 80 00       	mov    0x805038,%eax
  8030b5:	40                   	inc    %eax
  8030b6:	a3 38 50 80 00       	mov    %eax,0x805038
  8030bb:	eb 63                	jmp    803120 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030bd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030c1:	75 17                	jne    8030da <merging+0x3b8>
  8030c3:	83 ec 04             	sub    $0x4,%esp
  8030c6:	68 50 44 80 00       	push   $0x804450
  8030cb:	68 98 01 00 00       	push   $0x198
  8030d0:	68 35 44 80 00       	push   $0x804435
  8030d5:	e8 ec 08 00 00       	call   8039c6 <_panic>
  8030da:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e3:	89 10                	mov    %edx,(%eax)
  8030e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e8:	8b 00                	mov    (%eax),%eax
  8030ea:	85 c0                	test   %eax,%eax
  8030ec:	74 0d                	je     8030fb <merging+0x3d9>
  8030ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030f6:	89 50 04             	mov    %edx,0x4(%eax)
  8030f9:	eb 08                	jmp    803103 <merging+0x3e1>
  8030fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803103:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803106:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80310b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803115:	a1 38 50 80 00       	mov    0x805038,%eax
  80311a:	40                   	inc    %eax
  80311b:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803120:	83 ec 0c             	sub    $0xc,%esp
  803123:	ff 75 10             	pushl  0x10(%ebp)
  803126:	e8 f9 ed ff ff       	call   801f24 <get_block_size>
  80312b:	83 c4 10             	add    $0x10,%esp
  80312e:	83 ec 04             	sub    $0x4,%esp
  803131:	6a 00                	push   $0x0
  803133:	50                   	push   %eax
  803134:	ff 75 10             	pushl  0x10(%ebp)
  803137:	e8 39 f1 ff ff       	call   802275 <set_block_data>
  80313c:	83 c4 10             	add    $0x10,%esp
	}
}
  80313f:	90                   	nop
  803140:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803143:	c9                   	leave  
  803144:	c3                   	ret    

00803145 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803145:	55                   	push   %ebp
  803146:	89 e5                	mov    %esp,%ebp
  803148:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80314b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803150:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803153:	a1 30 50 80 00       	mov    0x805030,%eax
  803158:	3b 45 08             	cmp    0x8(%ebp),%eax
  80315b:	73 1b                	jae    803178 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80315d:	a1 30 50 80 00       	mov    0x805030,%eax
  803162:	83 ec 04             	sub    $0x4,%esp
  803165:	ff 75 08             	pushl  0x8(%ebp)
  803168:	6a 00                	push   $0x0
  80316a:	50                   	push   %eax
  80316b:	e8 b2 fb ff ff       	call   802d22 <merging>
  803170:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803173:	e9 8b 00 00 00       	jmp    803203 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803178:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80317d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803180:	76 18                	jbe    80319a <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803182:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803187:	83 ec 04             	sub    $0x4,%esp
  80318a:	ff 75 08             	pushl  0x8(%ebp)
  80318d:	50                   	push   %eax
  80318e:	6a 00                	push   $0x0
  803190:	e8 8d fb ff ff       	call   802d22 <merging>
  803195:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803198:	eb 69                	jmp    803203 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80319a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80319f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a2:	eb 39                	jmp    8031dd <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031aa:	73 29                	jae    8031d5 <free_block+0x90>
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031b4:	76 1f                	jbe    8031d5 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031be:	83 ec 04             	sub    $0x4,%esp
  8031c1:	ff 75 08             	pushl  0x8(%ebp)
  8031c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8031c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8031ca:	e8 53 fb ff ff       	call   802d22 <merging>
  8031cf:	83 c4 10             	add    $0x10,%esp
			break;
  8031d2:	90                   	nop
		}
	}
}
  8031d3:	eb 2e                	jmp    803203 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031d5:	a1 34 50 80 00       	mov    0x805034,%eax
  8031da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e1:	74 07                	je     8031ea <free_block+0xa5>
  8031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	eb 05                	jmp    8031ef <free_block+0xaa>
  8031ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ef:	a3 34 50 80 00       	mov    %eax,0x805034
  8031f4:	a1 34 50 80 00       	mov    0x805034,%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	75 a7                	jne    8031a4 <free_block+0x5f>
  8031fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803201:	75 a1                	jne    8031a4 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803203:	90                   	nop
  803204:	c9                   	leave  
  803205:	c3                   	ret    

00803206 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803206:	55                   	push   %ebp
  803207:	89 e5                	mov    %esp,%ebp
  803209:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80320c:	ff 75 08             	pushl  0x8(%ebp)
  80320f:	e8 10 ed ff ff       	call   801f24 <get_block_size>
  803214:	83 c4 04             	add    $0x4,%esp
  803217:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80321a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803221:	eb 17                	jmp    80323a <copy_data+0x34>
  803223:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803226:	8b 45 0c             	mov    0xc(%ebp),%eax
  803229:	01 c2                	add    %eax,%edx
  80322b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80322e:	8b 45 08             	mov    0x8(%ebp),%eax
  803231:	01 c8                	add    %ecx,%eax
  803233:	8a 00                	mov    (%eax),%al
  803235:	88 02                	mov    %al,(%edx)
  803237:	ff 45 fc             	incl   -0x4(%ebp)
  80323a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80323d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803240:	72 e1                	jb     803223 <copy_data+0x1d>
}
  803242:	90                   	nop
  803243:	c9                   	leave  
  803244:	c3                   	ret    

00803245 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803245:	55                   	push   %ebp
  803246:	89 e5                	mov    %esp,%ebp
  803248:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80324b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80324f:	75 23                	jne    803274 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803251:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803255:	74 13                	je     80326a <realloc_block_FF+0x25>
  803257:	83 ec 0c             	sub    $0xc,%esp
  80325a:	ff 75 0c             	pushl  0xc(%ebp)
  80325d:	e8 42 f0 ff ff       	call   8022a4 <alloc_block_FF>
  803262:	83 c4 10             	add    $0x10,%esp
  803265:	e9 e4 06 00 00       	jmp    80394e <realloc_block_FF+0x709>
		return NULL;
  80326a:	b8 00 00 00 00       	mov    $0x0,%eax
  80326f:	e9 da 06 00 00       	jmp    80394e <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803274:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803278:	75 18                	jne    803292 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80327a:	83 ec 0c             	sub    $0xc,%esp
  80327d:	ff 75 08             	pushl  0x8(%ebp)
  803280:	e8 c0 fe ff ff       	call   803145 <free_block>
  803285:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803288:	b8 00 00 00 00       	mov    $0x0,%eax
  80328d:	e9 bc 06 00 00       	jmp    80394e <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803292:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803296:	77 07                	ja     80329f <realloc_block_FF+0x5a>
  803298:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80329f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a2:	83 e0 01             	and    $0x1,%eax
  8032a5:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ab:	83 c0 08             	add    $0x8,%eax
  8032ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032b1:	83 ec 0c             	sub    $0xc,%esp
  8032b4:	ff 75 08             	pushl  0x8(%ebp)
  8032b7:	e8 68 ec ff ff       	call   801f24 <get_block_size>
  8032bc:	83 c4 10             	add    $0x10,%esp
  8032bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c5:	83 e8 08             	sub    $0x8,%eax
  8032c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	83 e8 04             	sub    $0x4,%eax
  8032d1:	8b 00                	mov    (%eax),%eax
  8032d3:	83 e0 fe             	and    $0xfffffffe,%eax
  8032d6:	89 c2                	mov    %eax,%edx
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	01 d0                	add    %edx,%eax
  8032dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032e0:	83 ec 0c             	sub    $0xc,%esp
  8032e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032e6:	e8 39 ec ff ff       	call   801f24 <get_block_size>
  8032eb:	83 c4 10             	add    $0x10,%esp
  8032ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f4:	83 e8 08             	sub    $0x8,%eax
  8032f7:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032fd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803300:	75 08                	jne    80330a <realloc_block_FF+0xc5>
	{
		 return va;
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	e9 44 06 00 00       	jmp    80394e <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80330a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803310:	0f 83 d5 03 00 00    	jae    8036eb <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803316:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803319:	2b 45 0c             	sub    0xc(%ebp),%eax
  80331c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80331f:	83 ec 0c             	sub    $0xc,%esp
  803322:	ff 75 e4             	pushl  -0x1c(%ebp)
  803325:	e8 13 ec ff ff       	call   801f3d <is_free_block>
  80332a:	83 c4 10             	add    $0x10,%esp
  80332d:	84 c0                	test   %al,%al
  80332f:	0f 84 3b 01 00 00    	je     803470 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803335:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803338:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80333b:	01 d0                	add    %edx,%eax
  80333d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803340:	83 ec 04             	sub    $0x4,%esp
  803343:	6a 01                	push   $0x1
  803345:	ff 75 f0             	pushl  -0x10(%ebp)
  803348:	ff 75 08             	pushl  0x8(%ebp)
  80334b:	e8 25 ef ff ff       	call   802275 <set_block_data>
  803350:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	83 e8 04             	sub    $0x4,%eax
  803359:	8b 00                	mov    (%eax),%eax
  80335b:	83 e0 fe             	and    $0xfffffffe,%eax
  80335e:	89 c2                	mov    %eax,%edx
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	01 d0                	add    %edx,%eax
  803365:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803368:	83 ec 04             	sub    $0x4,%esp
  80336b:	6a 00                	push   $0x0
  80336d:	ff 75 cc             	pushl  -0x34(%ebp)
  803370:	ff 75 c8             	pushl  -0x38(%ebp)
  803373:	e8 fd ee ff ff       	call   802275 <set_block_data>
  803378:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80337b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80337f:	74 06                	je     803387 <realloc_block_FF+0x142>
  803381:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803385:	75 17                	jne    80339e <realloc_block_FF+0x159>
  803387:	83 ec 04             	sub    $0x4,%esp
  80338a:	68 a8 44 80 00       	push   $0x8044a8
  80338f:	68 f6 01 00 00       	push   $0x1f6
  803394:	68 35 44 80 00       	push   $0x804435
  803399:	e8 28 06 00 00       	call   8039c6 <_panic>
  80339e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a1:	8b 10                	mov    (%eax),%edx
  8033a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033a6:	89 10                	mov    %edx,(%eax)
  8033a8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033ab:	8b 00                	mov    (%eax),%eax
  8033ad:	85 c0                	test   %eax,%eax
  8033af:	74 0b                	je     8033bc <realloc_block_FF+0x177>
  8033b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b4:	8b 00                	mov    (%eax),%eax
  8033b6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033b9:	89 50 04             	mov    %edx,0x4(%eax)
  8033bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033c2:	89 10                	mov    %edx,(%eax)
  8033c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ca:	89 50 04             	mov    %edx,0x4(%eax)
  8033cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033d0:	8b 00                	mov    (%eax),%eax
  8033d2:	85 c0                	test   %eax,%eax
  8033d4:	75 08                	jne    8033de <realloc_block_FF+0x199>
  8033d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8033de:	a1 38 50 80 00       	mov    0x805038,%eax
  8033e3:	40                   	inc    %eax
  8033e4:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033ed:	75 17                	jne    803406 <realloc_block_FF+0x1c1>
  8033ef:	83 ec 04             	sub    $0x4,%esp
  8033f2:	68 17 44 80 00       	push   $0x804417
  8033f7:	68 f7 01 00 00       	push   $0x1f7
  8033fc:	68 35 44 80 00       	push   $0x804435
  803401:	e8 c0 05 00 00       	call   8039c6 <_panic>
  803406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803409:	8b 00                	mov    (%eax),%eax
  80340b:	85 c0                	test   %eax,%eax
  80340d:	74 10                	je     80341f <realloc_block_FF+0x1da>
  80340f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803412:	8b 00                	mov    (%eax),%eax
  803414:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803417:	8b 52 04             	mov    0x4(%edx),%edx
  80341a:	89 50 04             	mov    %edx,0x4(%eax)
  80341d:	eb 0b                	jmp    80342a <realloc_block_FF+0x1e5>
  80341f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803422:	8b 40 04             	mov    0x4(%eax),%eax
  803425:	a3 30 50 80 00       	mov    %eax,0x805030
  80342a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342d:	8b 40 04             	mov    0x4(%eax),%eax
  803430:	85 c0                	test   %eax,%eax
  803432:	74 0f                	je     803443 <realloc_block_FF+0x1fe>
  803434:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803437:	8b 40 04             	mov    0x4(%eax),%eax
  80343a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80343d:	8b 12                	mov    (%edx),%edx
  80343f:	89 10                	mov    %edx,(%eax)
  803441:	eb 0a                	jmp    80344d <realloc_block_FF+0x208>
  803443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803446:	8b 00                	mov    (%eax),%eax
  803448:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80344d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803459:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803460:	a1 38 50 80 00       	mov    0x805038,%eax
  803465:	48                   	dec    %eax
  803466:	a3 38 50 80 00       	mov    %eax,0x805038
  80346b:	e9 73 02 00 00       	jmp    8036e3 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803470:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803474:	0f 86 69 02 00 00    	jbe    8036e3 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80347a:	83 ec 04             	sub    $0x4,%esp
  80347d:	6a 01                	push   $0x1
  80347f:	ff 75 f0             	pushl  -0x10(%ebp)
  803482:	ff 75 08             	pushl  0x8(%ebp)
  803485:	e8 eb ed ff ff       	call   802275 <set_block_data>
  80348a:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	83 e8 04             	sub    $0x4,%eax
  803493:	8b 00                	mov    (%eax),%eax
  803495:	83 e0 fe             	and    $0xfffffffe,%eax
  803498:	89 c2                	mov    %eax,%edx
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	01 d0                	add    %edx,%eax
  80349f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034a2:	a1 38 50 80 00       	mov    0x805038,%eax
  8034a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034aa:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034ae:	75 68                	jne    803518 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034b0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034b4:	75 17                	jne    8034cd <realloc_block_FF+0x288>
  8034b6:	83 ec 04             	sub    $0x4,%esp
  8034b9:	68 50 44 80 00       	push   $0x804450
  8034be:	68 06 02 00 00       	push   $0x206
  8034c3:	68 35 44 80 00       	push   $0x804435
  8034c8:	e8 f9 04 00 00       	call   8039c6 <_panic>
  8034cd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d6:	89 10                	mov    %edx,(%eax)
  8034d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034db:	8b 00                	mov    (%eax),%eax
  8034dd:	85 c0                	test   %eax,%eax
  8034df:	74 0d                	je     8034ee <realloc_block_FF+0x2a9>
  8034e1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034e9:	89 50 04             	mov    %edx,0x4(%eax)
  8034ec:	eb 08                	jmp    8034f6 <realloc_block_FF+0x2b1>
  8034ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803501:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803508:	a1 38 50 80 00       	mov    0x805038,%eax
  80350d:	40                   	inc    %eax
  80350e:	a3 38 50 80 00       	mov    %eax,0x805038
  803513:	e9 b0 01 00 00       	jmp    8036c8 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803518:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80351d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803520:	76 68                	jbe    80358a <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803522:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803526:	75 17                	jne    80353f <realloc_block_FF+0x2fa>
  803528:	83 ec 04             	sub    $0x4,%esp
  80352b:	68 50 44 80 00       	push   $0x804450
  803530:	68 0b 02 00 00       	push   $0x20b
  803535:	68 35 44 80 00       	push   $0x804435
  80353a:	e8 87 04 00 00       	call   8039c6 <_panic>
  80353f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803545:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803548:	89 10                	mov    %edx,(%eax)
  80354a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354d:	8b 00                	mov    (%eax),%eax
  80354f:	85 c0                	test   %eax,%eax
  803551:	74 0d                	je     803560 <realloc_block_FF+0x31b>
  803553:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803558:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80355b:	89 50 04             	mov    %edx,0x4(%eax)
  80355e:	eb 08                	jmp    803568 <realloc_block_FF+0x323>
  803560:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803563:	a3 30 50 80 00       	mov    %eax,0x805030
  803568:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803570:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803573:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357a:	a1 38 50 80 00       	mov    0x805038,%eax
  80357f:	40                   	inc    %eax
  803580:	a3 38 50 80 00       	mov    %eax,0x805038
  803585:	e9 3e 01 00 00       	jmp    8036c8 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80358a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80358f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803592:	73 68                	jae    8035fc <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803594:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803598:	75 17                	jne    8035b1 <realloc_block_FF+0x36c>
  80359a:	83 ec 04             	sub    $0x4,%esp
  80359d:	68 84 44 80 00       	push   $0x804484
  8035a2:	68 10 02 00 00       	push   $0x210
  8035a7:	68 35 44 80 00       	push   $0x804435
  8035ac:	e8 15 04 00 00       	call   8039c6 <_panic>
  8035b1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ba:	89 50 04             	mov    %edx,0x4(%eax)
  8035bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c0:	8b 40 04             	mov    0x4(%eax),%eax
  8035c3:	85 c0                	test   %eax,%eax
  8035c5:	74 0c                	je     8035d3 <realloc_block_FF+0x38e>
  8035c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8035cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035cf:	89 10                	mov    %edx,(%eax)
  8035d1:	eb 08                	jmp    8035db <realloc_block_FF+0x396>
  8035d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035de:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f1:	40                   	inc    %eax
  8035f2:	a3 38 50 80 00       	mov    %eax,0x805038
  8035f7:	e9 cc 00 00 00       	jmp    8036c8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803603:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80360b:	e9 8a 00 00 00       	jmp    80369a <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803616:	73 7a                	jae    803692 <realloc_block_FF+0x44d>
  803618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361b:	8b 00                	mov    (%eax),%eax
  80361d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803620:	73 70                	jae    803692 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803626:	74 06                	je     80362e <realloc_block_FF+0x3e9>
  803628:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80362c:	75 17                	jne    803645 <realloc_block_FF+0x400>
  80362e:	83 ec 04             	sub    $0x4,%esp
  803631:	68 a8 44 80 00       	push   $0x8044a8
  803636:	68 1a 02 00 00       	push   $0x21a
  80363b:	68 35 44 80 00       	push   $0x804435
  803640:	e8 81 03 00 00       	call   8039c6 <_panic>
  803645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803648:	8b 10                	mov    (%eax),%edx
  80364a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364d:	89 10                	mov    %edx,(%eax)
  80364f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803652:	8b 00                	mov    (%eax),%eax
  803654:	85 c0                	test   %eax,%eax
  803656:	74 0b                	je     803663 <realloc_block_FF+0x41e>
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	8b 00                	mov    (%eax),%eax
  80365d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803660:	89 50 04             	mov    %edx,0x4(%eax)
  803663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803666:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803669:	89 10                	mov    %edx,(%eax)
  80366b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803671:	89 50 04             	mov    %edx,0x4(%eax)
  803674:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803677:	8b 00                	mov    (%eax),%eax
  803679:	85 c0                	test   %eax,%eax
  80367b:	75 08                	jne    803685 <realloc_block_FF+0x440>
  80367d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803680:	a3 30 50 80 00       	mov    %eax,0x805030
  803685:	a1 38 50 80 00       	mov    0x805038,%eax
  80368a:	40                   	inc    %eax
  80368b:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803690:	eb 36                	jmp    8036c8 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803692:	a1 34 50 80 00       	mov    0x805034,%eax
  803697:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80369a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80369e:	74 07                	je     8036a7 <realloc_block_FF+0x462>
  8036a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a3:	8b 00                	mov    (%eax),%eax
  8036a5:	eb 05                	jmp    8036ac <realloc_block_FF+0x467>
  8036a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ac:	a3 34 50 80 00       	mov    %eax,0x805034
  8036b1:	a1 34 50 80 00       	mov    0x805034,%eax
  8036b6:	85 c0                	test   %eax,%eax
  8036b8:	0f 85 52 ff ff ff    	jne    803610 <realloc_block_FF+0x3cb>
  8036be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036c2:	0f 85 48 ff ff ff    	jne    803610 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8036c8:	83 ec 04             	sub    $0x4,%esp
  8036cb:	6a 00                	push   $0x0
  8036cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8036d0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036d3:	e8 9d eb ff ff       	call   802275 <set_block_data>
  8036d8:	83 c4 10             	add    $0x10,%esp
				return va;
  8036db:	8b 45 08             	mov    0x8(%ebp),%eax
  8036de:	e9 6b 02 00 00       	jmp    80394e <realloc_block_FF+0x709>
			}
			
		}
		return va;
  8036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e6:	e9 63 02 00 00       	jmp    80394e <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8036eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ee:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036f1:	0f 86 4d 02 00 00    	jbe    803944 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8036f7:	83 ec 0c             	sub    $0xc,%esp
  8036fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036fd:	e8 3b e8 ff ff       	call   801f3d <is_free_block>
  803702:	83 c4 10             	add    $0x10,%esp
  803705:	84 c0                	test   %al,%al
  803707:	0f 84 37 02 00 00    	je     803944 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80370d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803710:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803713:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803716:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803719:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80371c:	76 38                	jbe    803756 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80371e:	83 ec 0c             	sub    $0xc,%esp
  803721:	ff 75 0c             	pushl  0xc(%ebp)
  803724:	e8 7b eb ff ff       	call   8022a4 <alloc_block_FF>
  803729:	83 c4 10             	add    $0x10,%esp
  80372c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80372f:	83 ec 08             	sub    $0x8,%esp
  803732:	ff 75 c0             	pushl  -0x40(%ebp)
  803735:	ff 75 08             	pushl  0x8(%ebp)
  803738:	e8 c9 fa ff ff       	call   803206 <copy_data>
  80373d:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  803740:	83 ec 0c             	sub    $0xc,%esp
  803743:	ff 75 08             	pushl  0x8(%ebp)
  803746:	e8 fa f9 ff ff       	call   803145 <free_block>
  80374b:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80374e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803751:	e9 f8 01 00 00       	jmp    80394e <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803756:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803759:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80375c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80375f:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803763:	0f 87 a0 00 00 00    	ja     803809 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803769:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80376d:	75 17                	jne    803786 <realloc_block_FF+0x541>
  80376f:	83 ec 04             	sub    $0x4,%esp
  803772:	68 17 44 80 00       	push   $0x804417
  803777:	68 38 02 00 00       	push   $0x238
  80377c:	68 35 44 80 00       	push   $0x804435
  803781:	e8 40 02 00 00       	call   8039c6 <_panic>
  803786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803789:	8b 00                	mov    (%eax),%eax
  80378b:	85 c0                	test   %eax,%eax
  80378d:	74 10                	je     80379f <realloc_block_FF+0x55a>
  80378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803792:	8b 00                	mov    (%eax),%eax
  803794:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803797:	8b 52 04             	mov    0x4(%edx),%edx
  80379a:	89 50 04             	mov    %edx,0x4(%eax)
  80379d:	eb 0b                	jmp    8037aa <realloc_block_FF+0x565>
  80379f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a2:	8b 40 04             	mov    0x4(%eax),%eax
  8037a5:	a3 30 50 80 00       	mov    %eax,0x805030
  8037aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ad:	8b 40 04             	mov    0x4(%eax),%eax
  8037b0:	85 c0                	test   %eax,%eax
  8037b2:	74 0f                	je     8037c3 <realloc_block_FF+0x57e>
  8037b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b7:	8b 40 04             	mov    0x4(%eax),%eax
  8037ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037bd:	8b 12                	mov    (%edx),%edx
  8037bf:	89 10                	mov    %edx,(%eax)
  8037c1:	eb 0a                	jmp    8037cd <realloc_block_FF+0x588>
  8037c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8037e5:	48                   	dec    %eax
  8037e6:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f1:	01 d0                	add    %edx,%eax
  8037f3:	83 ec 04             	sub    $0x4,%esp
  8037f6:	6a 01                	push   $0x1
  8037f8:	50                   	push   %eax
  8037f9:	ff 75 08             	pushl  0x8(%ebp)
  8037fc:	e8 74 ea ff ff       	call   802275 <set_block_data>
  803801:	83 c4 10             	add    $0x10,%esp
  803804:	e9 36 01 00 00       	jmp    80393f <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803809:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80380c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80380f:	01 d0                	add    %edx,%eax
  803811:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803814:	83 ec 04             	sub    $0x4,%esp
  803817:	6a 01                	push   $0x1
  803819:	ff 75 f0             	pushl  -0x10(%ebp)
  80381c:	ff 75 08             	pushl  0x8(%ebp)
  80381f:	e8 51 ea ff ff       	call   802275 <set_block_data>
  803824:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803827:	8b 45 08             	mov    0x8(%ebp),%eax
  80382a:	83 e8 04             	sub    $0x4,%eax
  80382d:	8b 00                	mov    (%eax),%eax
  80382f:	83 e0 fe             	and    $0xfffffffe,%eax
  803832:	89 c2                	mov    %eax,%edx
  803834:	8b 45 08             	mov    0x8(%ebp),%eax
  803837:	01 d0                	add    %edx,%eax
  803839:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80383c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803840:	74 06                	je     803848 <realloc_block_FF+0x603>
  803842:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803846:	75 17                	jne    80385f <realloc_block_FF+0x61a>
  803848:	83 ec 04             	sub    $0x4,%esp
  80384b:	68 a8 44 80 00       	push   $0x8044a8
  803850:	68 44 02 00 00       	push   $0x244
  803855:	68 35 44 80 00       	push   $0x804435
  80385a:	e8 67 01 00 00       	call   8039c6 <_panic>
  80385f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803862:	8b 10                	mov    (%eax),%edx
  803864:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803867:	89 10                	mov    %edx,(%eax)
  803869:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80386c:	8b 00                	mov    (%eax),%eax
  80386e:	85 c0                	test   %eax,%eax
  803870:	74 0b                	je     80387d <realloc_block_FF+0x638>
  803872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803875:	8b 00                	mov    (%eax),%eax
  803877:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80387a:	89 50 04             	mov    %edx,0x4(%eax)
  80387d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803880:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803883:	89 10                	mov    %edx,(%eax)
  803885:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803888:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80388b:	89 50 04             	mov    %edx,0x4(%eax)
  80388e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803891:	8b 00                	mov    (%eax),%eax
  803893:	85 c0                	test   %eax,%eax
  803895:	75 08                	jne    80389f <realloc_block_FF+0x65a>
  803897:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80389a:	a3 30 50 80 00       	mov    %eax,0x805030
  80389f:	a1 38 50 80 00       	mov    0x805038,%eax
  8038a4:	40                   	inc    %eax
  8038a5:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ae:	75 17                	jne    8038c7 <realloc_block_FF+0x682>
  8038b0:	83 ec 04             	sub    $0x4,%esp
  8038b3:	68 17 44 80 00       	push   $0x804417
  8038b8:	68 45 02 00 00       	push   $0x245
  8038bd:	68 35 44 80 00       	push   $0x804435
  8038c2:	e8 ff 00 00 00       	call   8039c6 <_panic>
  8038c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ca:	8b 00                	mov    (%eax),%eax
  8038cc:	85 c0                	test   %eax,%eax
  8038ce:	74 10                	je     8038e0 <realloc_block_FF+0x69b>
  8038d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d3:	8b 00                	mov    (%eax),%eax
  8038d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038d8:	8b 52 04             	mov    0x4(%edx),%edx
  8038db:	89 50 04             	mov    %edx,0x4(%eax)
  8038de:	eb 0b                	jmp    8038eb <realloc_block_FF+0x6a6>
  8038e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e3:	8b 40 04             	mov    0x4(%eax),%eax
  8038e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8038eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ee:	8b 40 04             	mov    0x4(%eax),%eax
  8038f1:	85 c0                	test   %eax,%eax
  8038f3:	74 0f                	je     803904 <realloc_block_FF+0x6bf>
  8038f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f8:	8b 40 04             	mov    0x4(%eax),%eax
  8038fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038fe:	8b 12                	mov    (%edx),%edx
  803900:	89 10                	mov    %edx,(%eax)
  803902:	eb 0a                	jmp    80390e <realloc_block_FF+0x6c9>
  803904:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803907:	8b 00                	mov    (%eax),%eax
  803909:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80390e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803921:	a1 38 50 80 00       	mov    0x805038,%eax
  803926:	48                   	dec    %eax
  803927:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80392c:	83 ec 04             	sub    $0x4,%esp
  80392f:	6a 00                	push   $0x0
  803931:	ff 75 bc             	pushl  -0x44(%ebp)
  803934:	ff 75 b8             	pushl  -0x48(%ebp)
  803937:	e8 39 e9 ff ff       	call   802275 <set_block_data>
  80393c:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80393f:	8b 45 08             	mov    0x8(%ebp),%eax
  803942:	eb 0a                	jmp    80394e <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803944:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80394b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80394e:	c9                   	leave  
  80394f:	c3                   	ret    

00803950 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803950:	55                   	push   %ebp
  803951:	89 e5                	mov    %esp,%ebp
  803953:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803956:	83 ec 04             	sub    $0x4,%esp
  803959:	68 14 45 80 00       	push   $0x804514
  80395e:	68 58 02 00 00       	push   $0x258
  803963:	68 35 44 80 00       	push   $0x804435
  803968:	e8 59 00 00 00       	call   8039c6 <_panic>

0080396d <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80396d:	55                   	push   %ebp
  80396e:	89 e5                	mov    %esp,%ebp
  803970:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803973:	83 ec 04             	sub    $0x4,%esp
  803976:	68 3c 45 80 00       	push   $0x80453c
  80397b:	68 61 02 00 00       	push   $0x261
  803980:	68 35 44 80 00       	push   $0x804435
  803985:	e8 3c 00 00 00       	call   8039c6 <_panic>

0080398a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80398a:	55                   	push   %ebp
  80398b:	89 e5                	mov    %esp,%ebp
  80398d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  803990:	8b 45 08             	mov    0x8(%ebp),%eax
  803993:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  803996:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80399a:	83 ec 0c             	sub    $0xc,%esp
  80399d:	50                   	push   %eax
  80399e:	e8 74 e0 ff ff       	call   801a17 <sys_cputc>
  8039a3:	83 c4 10             	add    $0x10,%esp
}
  8039a6:	90                   	nop
  8039a7:	c9                   	leave  
  8039a8:	c3                   	ret    

008039a9 <getchar>:


int
getchar(void)
{
  8039a9:	55                   	push   %ebp
  8039aa:	89 e5                	mov    %esp,%ebp
  8039ac:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8039af:	e8 ff de ff ff       	call   8018b3 <sys_cgetc>
  8039b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8039b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8039ba:	c9                   	leave  
  8039bb:	c3                   	ret    

008039bc <iscons>:

int iscons(int fdnum)
{
  8039bc:	55                   	push   %ebp
  8039bd:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8039bf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039c4:	5d                   	pop    %ebp
  8039c5:	c3                   	ret    

008039c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8039c6:	55                   	push   %ebp
  8039c7:	89 e5                	mov    %esp,%ebp
  8039c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8039cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8039cf:	83 c0 04             	add    $0x4,%eax
  8039d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8039d5:	a1 60 50 98 00       	mov    0x985060,%eax
  8039da:	85 c0                	test   %eax,%eax
  8039dc:	74 16                	je     8039f4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8039de:	a1 60 50 98 00       	mov    0x985060,%eax
  8039e3:	83 ec 08             	sub    $0x8,%esp
  8039e6:	50                   	push   %eax
  8039e7:	68 64 45 80 00       	push   $0x804564
  8039ec:	e8 99 c9 ff ff       	call   80038a <cprintf>
  8039f1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8039f4:	a1 00 50 80 00       	mov    0x805000,%eax
  8039f9:	ff 75 0c             	pushl  0xc(%ebp)
  8039fc:	ff 75 08             	pushl  0x8(%ebp)
  8039ff:	50                   	push   %eax
  803a00:	68 69 45 80 00       	push   $0x804569
  803a05:	e8 80 c9 ff ff       	call   80038a <cprintf>
  803a0a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  803a10:	83 ec 08             	sub    $0x8,%esp
  803a13:	ff 75 f4             	pushl  -0xc(%ebp)
  803a16:	50                   	push   %eax
  803a17:	e8 03 c9 ff ff       	call   80031f <vcprintf>
  803a1c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a1f:	83 ec 08             	sub    $0x8,%esp
  803a22:	6a 00                	push   $0x0
  803a24:	68 85 45 80 00       	push   $0x804585
  803a29:	e8 f1 c8 ff ff       	call   80031f <vcprintf>
  803a2e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a31:	e8 72 c8 ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  803a36:	eb fe                	jmp    803a36 <_panic+0x70>

00803a38 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a38:	55                   	push   %ebp
  803a39:	89 e5                	mov    %esp,%ebp
  803a3b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a3e:	a1 20 50 80 00       	mov    0x805020,%eax
  803a43:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a4c:	39 c2                	cmp    %eax,%edx
  803a4e:	74 14                	je     803a64 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a50:	83 ec 04             	sub    $0x4,%esp
  803a53:	68 88 45 80 00       	push   $0x804588
  803a58:	6a 26                	push   $0x26
  803a5a:	68 d4 45 80 00       	push   $0x8045d4
  803a5f:	e8 62 ff ff ff       	call   8039c6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803a6b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a72:	e9 c5 00 00 00       	jmp    803b3c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a7a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a81:	8b 45 08             	mov    0x8(%ebp),%eax
  803a84:	01 d0                	add    %edx,%eax
  803a86:	8b 00                	mov    (%eax),%eax
  803a88:	85 c0                	test   %eax,%eax
  803a8a:	75 08                	jne    803a94 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a8c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a8f:	e9 a5 00 00 00       	jmp    803b39 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a94:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a9b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803aa2:	eb 69                	jmp    803b0d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803aa4:	a1 20 50 80 00       	mov    0x805020,%eax
  803aa9:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803aaf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ab2:	89 d0                	mov    %edx,%eax
  803ab4:	01 c0                	add    %eax,%eax
  803ab6:	01 d0                	add    %edx,%eax
  803ab8:	c1 e0 03             	shl    $0x3,%eax
  803abb:	01 c8                	add    %ecx,%eax
  803abd:	8a 40 04             	mov    0x4(%eax),%al
  803ac0:	84 c0                	test   %al,%al
  803ac2:	75 46                	jne    803b0a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803ac4:	a1 20 50 80 00       	mov    0x805020,%eax
  803ac9:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803acf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ad2:	89 d0                	mov    %edx,%eax
  803ad4:	01 c0                	add    %eax,%eax
  803ad6:	01 d0                	add    %edx,%eax
  803ad8:	c1 e0 03             	shl    $0x3,%eax
  803adb:	01 c8                	add    %ecx,%eax
  803add:	8b 00                	mov    (%eax),%eax
  803adf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803ae2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ae5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803aea:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	01 c8                	add    %ecx,%eax
  803afb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803afd:	39 c2                	cmp    %eax,%edx
  803aff:	75 09                	jne    803b0a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b01:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b08:	eb 15                	jmp    803b1f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b0a:	ff 45 e8             	incl   -0x18(%ebp)
  803b0d:	a1 20 50 80 00       	mov    0x805020,%eax
  803b12:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1b:	39 c2                	cmp    %eax,%edx
  803b1d:	77 85                	ja     803aa4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b23:	75 14                	jne    803b39 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b25:	83 ec 04             	sub    $0x4,%esp
  803b28:	68 e0 45 80 00       	push   $0x8045e0
  803b2d:	6a 3a                	push   $0x3a
  803b2f:	68 d4 45 80 00       	push   $0x8045d4
  803b34:	e8 8d fe ff ff       	call   8039c6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b39:	ff 45 f0             	incl   -0x10(%ebp)
  803b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b42:	0f 8c 2f ff ff ff    	jl     803a77 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b48:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b4f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b56:	eb 26                	jmp    803b7e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b58:	a1 20 50 80 00       	mov    0x805020,%eax
  803b5d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b63:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b66:	89 d0                	mov    %edx,%eax
  803b68:	01 c0                	add    %eax,%eax
  803b6a:	01 d0                	add    %edx,%eax
  803b6c:	c1 e0 03             	shl    $0x3,%eax
  803b6f:	01 c8                	add    %ecx,%eax
  803b71:	8a 40 04             	mov    0x4(%eax),%al
  803b74:	3c 01                	cmp    $0x1,%al
  803b76:	75 03                	jne    803b7b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b78:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b7b:	ff 45 e0             	incl   -0x20(%ebp)
  803b7e:	a1 20 50 80 00       	mov    0x805020,%eax
  803b83:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b8c:	39 c2                	cmp    %eax,%edx
  803b8e:	77 c8                	ja     803b58 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b93:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b96:	74 14                	je     803bac <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b98:	83 ec 04             	sub    $0x4,%esp
  803b9b:	68 34 46 80 00       	push   $0x804634
  803ba0:	6a 44                	push   $0x44
  803ba2:	68 d4 45 80 00       	push   $0x8045d4
  803ba7:	e8 1a fe ff ff       	call   8039c6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803bac:	90                   	nop
  803bad:	c9                   	leave  
  803bae:	c3                   	ret    
  803baf:	90                   	nop

00803bb0 <__udivdi3>:
  803bb0:	55                   	push   %ebp
  803bb1:	57                   	push   %edi
  803bb2:	56                   	push   %esi
  803bb3:	53                   	push   %ebx
  803bb4:	83 ec 1c             	sub    $0x1c,%esp
  803bb7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bbb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bc3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bc7:	89 ca                	mov    %ecx,%edx
  803bc9:	89 f8                	mov    %edi,%eax
  803bcb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bcf:	85 f6                	test   %esi,%esi
  803bd1:	75 2d                	jne    803c00 <__udivdi3+0x50>
  803bd3:	39 cf                	cmp    %ecx,%edi
  803bd5:	77 65                	ja     803c3c <__udivdi3+0x8c>
  803bd7:	89 fd                	mov    %edi,%ebp
  803bd9:	85 ff                	test   %edi,%edi
  803bdb:	75 0b                	jne    803be8 <__udivdi3+0x38>
  803bdd:	b8 01 00 00 00       	mov    $0x1,%eax
  803be2:	31 d2                	xor    %edx,%edx
  803be4:	f7 f7                	div    %edi
  803be6:	89 c5                	mov    %eax,%ebp
  803be8:	31 d2                	xor    %edx,%edx
  803bea:	89 c8                	mov    %ecx,%eax
  803bec:	f7 f5                	div    %ebp
  803bee:	89 c1                	mov    %eax,%ecx
  803bf0:	89 d8                	mov    %ebx,%eax
  803bf2:	f7 f5                	div    %ebp
  803bf4:	89 cf                	mov    %ecx,%edi
  803bf6:	89 fa                	mov    %edi,%edx
  803bf8:	83 c4 1c             	add    $0x1c,%esp
  803bfb:	5b                   	pop    %ebx
  803bfc:	5e                   	pop    %esi
  803bfd:	5f                   	pop    %edi
  803bfe:	5d                   	pop    %ebp
  803bff:	c3                   	ret    
  803c00:	39 ce                	cmp    %ecx,%esi
  803c02:	77 28                	ja     803c2c <__udivdi3+0x7c>
  803c04:	0f bd fe             	bsr    %esi,%edi
  803c07:	83 f7 1f             	xor    $0x1f,%edi
  803c0a:	75 40                	jne    803c4c <__udivdi3+0x9c>
  803c0c:	39 ce                	cmp    %ecx,%esi
  803c0e:	72 0a                	jb     803c1a <__udivdi3+0x6a>
  803c10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c14:	0f 87 9e 00 00 00    	ja     803cb8 <__udivdi3+0x108>
  803c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c1f:	89 fa                	mov    %edi,%edx
  803c21:	83 c4 1c             	add    $0x1c,%esp
  803c24:	5b                   	pop    %ebx
  803c25:	5e                   	pop    %esi
  803c26:	5f                   	pop    %edi
  803c27:	5d                   	pop    %ebp
  803c28:	c3                   	ret    
  803c29:	8d 76 00             	lea    0x0(%esi),%esi
  803c2c:	31 ff                	xor    %edi,%edi
  803c2e:	31 c0                	xor    %eax,%eax
  803c30:	89 fa                	mov    %edi,%edx
  803c32:	83 c4 1c             	add    $0x1c,%esp
  803c35:	5b                   	pop    %ebx
  803c36:	5e                   	pop    %esi
  803c37:	5f                   	pop    %edi
  803c38:	5d                   	pop    %ebp
  803c39:	c3                   	ret    
  803c3a:	66 90                	xchg   %ax,%ax
  803c3c:	89 d8                	mov    %ebx,%eax
  803c3e:	f7 f7                	div    %edi
  803c40:	31 ff                	xor    %edi,%edi
  803c42:	89 fa                	mov    %edi,%edx
  803c44:	83 c4 1c             	add    $0x1c,%esp
  803c47:	5b                   	pop    %ebx
  803c48:	5e                   	pop    %esi
  803c49:	5f                   	pop    %edi
  803c4a:	5d                   	pop    %ebp
  803c4b:	c3                   	ret    
  803c4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c51:	89 eb                	mov    %ebp,%ebx
  803c53:	29 fb                	sub    %edi,%ebx
  803c55:	89 f9                	mov    %edi,%ecx
  803c57:	d3 e6                	shl    %cl,%esi
  803c59:	89 c5                	mov    %eax,%ebp
  803c5b:	88 d9                	mov    %bl,%cl
  803c5d:	d3 ed                	shr    %cl,%ebp
  803c5f:	89 e9                	mov    %ebp,%ecx
  803c61:	09 f1                	or     %esi,%ecx
  803c63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c67:	89 f9                	mov    %edi,%ecx
  803c69:	d3 e0                	shl    %cl,%eax
  803c6b:	89 c5                	mov    %eax,%ebp
  803c6d:	89 d6                	mov    %edx,%esi
  803c6f:	88 d9                	mov    %bl,%cl
  803c71:	d3 ee                	shr    %cl,%esi
  803c73:	89 f9                	mov    %edi,%ecx
  803c75:	d3 e2                	shl    %cl,%edx
  803c77:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c7b:	88 d9                	mov    %bl,%cl
  803c7d:	d3 e8                	shr    %cl,%eax
  803c7f:	09 c2                	or     %eax,%edx
  803c81:	89 d0                	mov    %edx,%eax
  803c83:	89 f2                	mov    %esi,%edx
  803c85:	f7 74 24 0c          	divl   0xc(%esp)
  803c89:	89 d6                	mov    %edx,%esi
  803c8b:	89 c3                	mov    %eax,%ebx
  803c8d:	f7 e5                	mul    %ebp
  803c8f:	39 d6                	cmp    %edx,%esi
  803c91:	72 19                	jb     803cac <__udivdi3+0xfc>
  803c93:	74 0b                	je     803ca0 <__udivdi3+0xf0>
  803c95:	89 d8                	mov    %ebx,%eax
  803c97:	31 ff                	xor    %edi,%edi
  803c99:	e9 58 ff ff ff       	jmp    803bf6 <__udivdi3+0x46>
  803c9e:	66 90                	xchg   %ax,%ax
  803ca0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ca4:	89 f9                	mov    %edi,%ecx
  803ca6:	d3 e2                	shl    %cl,%edx
  803ca8:	39 c2                	cmp    %eax,%edx
  803caa:	73 e9                	jae    803c95 <__udivdi3+0xe5>
  803cac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803caf:	31 ff                	xor    %edi,%edi
  803cb1:	e9 40 ff ff ff       	jmp    803bf6 <__udivdi3+0x46>
  803cb6:	66 90                	xchg   %ax,%ax
  803cb8:	31 c0                	xor    %eax,%eax
  803cba:	e9 37 ff ff ff       	jmp    803bf6 <__udivdi3+0x46>
  803cbf:	90                   	nop

00803cc0 <__umoddi3>:
  803cc0:	55                   	push   %ebp
  803cc1:	57                   	push   %edi
  803cc2:	56                   	push   %esi
  803cc3:	53                   	push   %ebx
  803cc4:	83 ec 1c             	sub    $0x1c,%esp
  803cc7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ccb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ccf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cd3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cdb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cdf:	89 f3                	mov    %esi,%ebx
  803ce1:	89 fa                	mov    %edi,%edx
  803ce3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ce7:	89 34 24             	mov    %esi,(%esp)
  803cea:	85 c0                	test   %eax,%eax
  803cec:	75 1a                	jne    803d08 <__umoddi3+0x48>
  803cee:	39 f7                	cmp    %esi,%edi
  803cf0:	0f 86 a2 00 00 00    	jbe    803d98 <__umoddi3+0xd8>
  803cf6:	89 c8                	mov    %ecx,%eax
  803cf8:	89 f2                	mov    %esi,%edx
  803cfa:	f7 f7                	div    %edi
  803cfc:	89 d0                	mov    %edx,%eax
  803cfe:	31 d2                	xor    %edx,%edx
  803d00:	83 c4 1c             	add    $0x1c,%esp
  803d03:	5b                   	pop    %ebx
  803d04:	5e                   	pop    %esi
  803d05:	5f                   	pop    %edi
  803d06:	5d                   	pop    %ebp
  803d07:	c3                   	ret    
  803d08:	39 f0                	cmp    %esi,%eax
  803d0a:	0f 87 ac 00 00 00    	ja     803dbc <__umoddi3+0xfc>
  803d10:	0f bd e8             	bsr    %eax,%ebp
  803d13:	83 f5 1f             	xor    $0x1f,%ebp
  803d16:	0f 84 ac 00 00 00    	je     803dc8 <__umoddi3+0x108>
  803d1c:	bf 20 00 00 00       	mov    $0x20,%edi
  803d21:	29 ef                	sub    %ebp,%edi
  803d23:	89 fe                	mov    %edi,%esi
  803d25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d29:	89 e9                	mov    %ebp,%ecx
  803d2b:	d3 e0                	shl    %cl,%eax
  803d2d:	89 d7                	mov    %edx,%edi
  803d2f:	89 f1                	mov    %esi,%ecx
  803d31:	d3 ef                	shr    %cl,%edi
  803d33:	09 c7                	or     %eax,%edi
  803d35:	89 e9                	mov    %ebp,%ecx
  803d37:	d3 e2                	shl    %cl,%edx
  803d39:	89 14 24             	mov    %edx,(%esp)
  803d3c:	89 d8                	mov    %ebx,%eax
  803d3e:	d3 e0                	shl    %cl,%eax
  803d40:	89 c2                	mov    %eax,%edx
  803d42:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d46:	d3 e0                	shl    %cl,%eax
  803d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d50:	89 f1                	mov    %esi,%ecx
  803d52:	d3 e8                	shr    %cl,%eax
  803d54:	09 d0                	or     %edx,%eax
  803d56:	d3 eb                	shr    %cl,%ebx
  803d58:	89 da                	mov    %ebx,%edx
  803d5a:	f7 f7                	div    %edi
  803d5c:	89 d3                	mov    %edx,%ebx
  803d5e:	f7 24 24             	mull   (%esp)
  803d61:	89 c6                	mov    %eax,%esi
  803d63:	89 d1                	mov    %edx,%ecx
  803d65:	39 d3                	cmp    %edx,%ebx
  803d67:	0f 82 87 00 00 00    	jb     803df4 <__umoddi3+0x134>
  803d6d:	0f 84 91 00 00 00    	je     803e04 <__umoddi3+0x144>
  803d73:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d77:	29 f2                	sub    %esi,%edx
  803d79:	19 cb                	sbb    %ecx,%ebx
  803d7b:	89 d8                	mov    %ebx,%eax
  803d7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d81:	d3 e0                	shl    %cl,%eax
  803d83:	89 e9                	mov    %ebp,%ecx
  803d85:	d3 ea                	shr    %cl,%edx
  803d87:	09 d0                	or     %edx,%eax
  803d89:	89 e9                	mov    %ebp,%ecx
  803d8b:	d3 eb                	shr    %cl,%ebx
  803d8d:	89 da                	mov    %ebx,%edx
  803d8f:	83 c4 1c             	add    $0x1c,%esp
  803d92:	5b                   	pop    %ebx
  803d93:	5e                   	pop    %esi
  803d94:	5f                   	pop    %edi
  803d95:	5d                   	pop    %ebp
  803d96:	c3                   	ret    
  803d97:	90                   	nop
  803d98:	89 fd                	mov    %edi,%ebp
  803d9a:	85 ff                	test   %edi,%edi
  803d9c:	75 0b                	jne    803da9 <__umoddi3+0xe9>
  803d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803da3:	31 d2                	xor    %edx,%edx
  803da5:	f7 f7                	div    %edi
  803da7:	89 c5                	mov    %eax,%ebp
  803da9:	89 f0                	mov    %esi,%eax
  803dab:	31 d2                	xor    %edx,%edx
  803dad:	f7 f5                	div    %ebp
  803daf:	89 c8                	mov    %ecx,%eax
  803db1:	f7 f5                	div    %ebp
  803db3:	89 d0                	mov    %edx,%eax
  803db5:	e9 44 ff ff ff       	jmp    803cfe <__umoddi3+0x3e>
  803dba:	66 90                	xchg   %ax,%ax
  803dbc:	89 c8                	mov    %ecx,%eax
  803dbe:	89 f2                	mov    %esi,%edx
  803dc0:	83 c4 1c             	add    $0x1c,%esp
  803dc3:	5b                   	pop    %ebx
  803dc4:	5e                   	pop    %esi
  803dc5:	5f                   	pop    %edi
  803dc6:	5d                   	pop    %ebp
  803dc7:	c3                   	ret    
  803dc8:	3b 04 24             	cmp    (%esp),%eax
  803dcb:	72 06                	jb     803dd3 <__umoddi3+0x113>
  803dcd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dd1:	77 0f                	ja     803de2 <__umoddi3+0x122>
  803dd3:	89 f2                	mov    %esi,%edx
  803dd5:	29 f9                	sub    %edi,%ecx
  803dd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ddb:	89 14 24             	mov    %edx,(%esp)
  803dde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803de2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803de6:	8b 14 24             	mov    (%esp),%edx
  803de9:	83 c4 1c             	add    $0x1c,%esp
  803dec:	5b                   	pop    %ebx
  803ded:	5e                   	pop    %esi
  803dee:	5f                   	pop    %edi
  803def:	5d                   	pop    %ebp
  803df0:	c3                   	ret    
  803df1:	8d 76 00             	lea    0x0(%esi),%esi
  803df4:	2b 04 24             	sub    (%esp),%eax
  803df7:	19 fa                	sbb    %edi,%edx
  803df9:	89 d1                	mov    %edx,%ecx
  803dfb:	89 c6                	mov    %eax,%esi
  803dfd:	e9 71 ff ff ff       	jmp    803d73 <__umoddi3+0xb3>
  803e02:	66 90                	xchg   %ax,%ax
  803e04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e08:	72 ea                	jb     803df4 <__umoddi3+0x134>
  803e0a:	89 d9                	mov    %ebx,%ecx
  803e0c:	e9 62 ff ff ff       	jmp    803d73 <__umoddi3+0xb3>
