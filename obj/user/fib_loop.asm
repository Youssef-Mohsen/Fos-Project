
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
  800052:	68 a0 3e 80 00       	push   $0x803ea0
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
  8000bc:	68 be 3e 80 00       	push   $0x803ebe
  8000c1:	e8 f1 02 00 00       	call   8003b7 <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 a5 1c 00 00       	call   801d73 <inctst>
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
  80017d:	e8 b3 1a 00 00       	call   801c35 <sys_getenvindex>
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
  8001eb:	e8 c9 17 00 00       	call   8019b9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 ec 3e 80 00       	push   $0x803eec
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
  80021b:	68 14 3f 80 00       	push   $0x803f14
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
  80024c:	68 3c 3f 80 00       	push   $0x803f3c
  800251:	e8 34 01 00 00       	call   80038a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 94 3f 80 00       	push   $0x803f94
  80026d:	e8 18 01 00 00       	call   80038a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 ec 3e 80 00       	push   $0x803eec
  80027d:	e8 08 01 00 00       	call   80038a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800285:	e8 49 17 00 00       	call   8019d3 <sys_unlock_cons>
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
  80029d:	e8 5f 19 00 00       	call   801c01 <sys_destroy_env>
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
  8002ae:	e8 b4 19 00 00       	call   801c67 <sys_exit_env>
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
  8002e1:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  8002fc:	e8 76 16 00 00       	call   801977 <sys_cputs>
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
  800356:	a0 2c 50 80 00       	mov    0x80502c,%al
  80035b:	0f b6 c0             	movzbl %al,%eax
  80035e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800364:	83 ec 04             	sub    $0x4,%esp
  800367:	50                   	push   %eax
  800368:	52                   	push   %edx
  800369:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80036f:	83 c0 08             	add    $0x8,%eax
  800372:	50                   	push   %eax
  800373:	e8 ff 15 00 00       	call   801977 <sys_cputs>
  800378:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80037b:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  800390:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8003bd:	e8 f7 15 00 00       	call   8019b9 <sys_lock_cons>
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
  8003dd:	e8 f1 15 00 00       	call   8019d3 <sys_unlock_cons>
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
  800427:	e8 08 38 00 00       	call   803c34 <__udivdi3>
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
  800477:	e8 c8 38 00 00       	call   803d44 <__umoddi3>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	05 d4 41 80 00       	add    $0x8041d4,%eax
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
  8005d2:	8b 04 85 f8 41 80 00 	mov    0x8041f8(,%eax,4),%eax
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
  8006b3:	8b 34 9d 40 40 80 00 	mov    0x804040(,%ebx,4),%esi
  8006ba:	85 f6                	test   %esi,%esi
  8006bc:	75 19                	jne    8006d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006be:	53                   	push   %ebx
  8006bf:	68 e5 41 80 00       	push   $0x8041e5
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
  8006d8:	68 ee 41 80 00       	push   $0x8041ee
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
  800705:	be f1 41 80 00       	mov    $0x8041f1,%esi
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
  8008fd:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800904:	eb 2c                	jmp    800932 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800906:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  800a30:	68 68 43 80 00       	push   $0x804368
  800a35:	e8 50 f9 ff ff       	call   80038a <cprintf>
  800a3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a44:	83 ec 0c             	sub    $0xc,%esp
  800a47:	6a 00                	push   $0x0
  800a49:	e8 f2 2f 00 00       	call   803a40 <iscons>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a54:	e8 d4 2f 00 00       	call   803a2d <getchar>
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
  800a72:	68 6b 43 80 00       	push   $0x80436b
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
  800a9f:	e8 6a 2f 00 00       	call   803a0e <cputchar>
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
  800ad6:	e8 33 2f 00 00       	call   803a0e <cputchar>
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
  800aff:	e8 0a 2f 00 00       	call   803a0e <cputchar>
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
  800b23:	e8 91 0e 00 00       	call   8019b9 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b2c:	74 13                	je     800b41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 08             	pushl  0x8(%ebp)
  800b34:	68 68 43 80 00       	push   $0x804368
  800b39:	e8 4c f8 ff ff       	call   80038a <cprintf>
  800b3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b48:	83 ec 0c             	sub    $0xc,%esp
  800b4b:	6a 00                	push   $0x0
  800b4d:	e8 ee 2e 00 00       	call   803a40 <iscons>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b58:	e8 d0 2e 00 00       	call   803a2d <getchar>
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
  800b76:	68 6b 43 80 00       	push   $0x80436b
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
  800ba3:	e8 66 2e 00 00       	call   803a0e <cputchar>
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
  800bda:	e8 2f 2e 00 00       	call   803a0e <cputchar>
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
  800c03:	e8 06 2e 00 00       	call   803a0e <cputchar>
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
  800c1e:	e8 b0 0d 00 00       	call   8019d3 <sys_unlock_cons>
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
  801318:	68 7c 43 80 00       	push   $0x80437c
  80131d:	68 3f 01 00 00       	push   $0x13f
  801322:	68 9e 43 80 00       	push   $0x80439e
  801327:	e8 1e 27 00 00       	call   803a4a <_panic>

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
  801338:	e8 e5 0b 00 00       	call   801f22 <sys_sbrk>
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
  8013b3:	e8 ee 09 00 00       	call   801da6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	74 16                	je     8013d2 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 08             	pushl  0x8(%ebp)
  8013c2:	e8 2e 0f 00 00       	call   8022f5 <alloc_block_FF>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013cd:	e9 8a 01 00 00       	jmp    80155c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013d2:	e8 00 0a 00 00       	call   801dd7 <sys_isUHeapPlacementStrategyBESTFIT>
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	0f 84 7d 01 00 00    	je     80155c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013df:	83 ec 0c             	sub    $0xc,%esp
  8013e2:	ff 75 08             	pushl  0x8(%ebp)
  8013e5:	e8 c7 13 00 00       	call   8027b1 <alloc_block_BF>
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
  801435:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801482:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  8014d9:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  80153b:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801542:	83 ec 08             	sub    $0x8,%esp
  801545:	ff 75 08             	pushl  0x8(%ebp)
  801548:	ff 75 f0             	pushl  -0x10(%ebp)
  80154b:	e8 09 0a 00 00       	call   801f59 <sys_allocate_user_mem>
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
  801593:	e8 dd 09 00 00       	call   801f75 <get_block_size>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 10 1c 00 00       	call   8031b9 <free_block>
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
  8015de:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  80161b:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801622:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801626:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	83 ec 08             	sub    $0x8,%esp
  80162f:	52                   	push   %edx
  801630:	50                   	push   %eax
  801631:	e8 07 09 00 00       	call   801f3d <sys_free_user_mem>
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
  801649:	68 ac 43 80 00       	push   $0x8043ac
  80164e:	68 88 00 00 00       	push   $0x88
  801653:	68 d6 43 80 00       	push   $0x8043d6
  801658:	e8 ed 23 00 00       	call   803a4a <_panic>
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
  801677:	e9 ec 00 00 00       	jmp    801768 <smalloc+0x108>
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
  8016a8:	75 0a                	jne    8016b4 <smalloc+0x54>
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016af:	e9 b4 00 00 00       	jmp    801768 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8016b4:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016b8:	ff 75 ec             	pushl  -0x14(%ebp)
  8016bb:	50                   	push   %eax
  8016bc:	ff 75 0c             	pushl  0xc(%ebp)
  8016bf:	ff 75 08             	pushl  0x8(%ebp)
  8016c2:	e8 7d 04 00 00       	call   801b44 <sys_createSharedObject>
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8016cd:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016d1:	74 06                	je     8016d9 <smalloc+0x79>
  8016d3:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016d7:	75 0a                	jne    8016e3 <smalloc+0x83>
  8016d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016de:	e9 85 00 00 00       	jmp    801768 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8016e9:	68 e2 43 80 00       	push   $0x8043e2
  8016ee:	e8 97 ec ff ff       	call   80038a <cprintf>
  8016f3:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8016f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8016fe:	8b 40 78             	mov    0x78(%eax),%eax
  801701:	29 c2                	sub    %eax,%edx
  801703:	89 d0                	mov    %edx,%eax
  801705:	2d 00 10 00 00       	sub    $0x1000,%eax
  80170a:	c1 e8 0c             	shr    $0xc,%eax
  80170d:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801713:	42                   	inc    %edx
  801714:	89 15 24 50 80 00    	mov    %edx,0x805024
  80171a:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801720:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801727:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80172a:	a1 20 50 80 00       	mov    0x805020,%eax
  80172f:	8b 40 78             	mov    0x78(%eax),%eax
  801732:	29 c2                	sub    %eax,%edx
  801734:	89 d0                	mov    %edx,%eax
  801736:	2d 00 10 00 00       	sub    $0x1000,%eax
  80173b:	c1 e8 0c             	shr    $0xc,%eax
  80173e:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801745:	a1 20 50 80 00       	mov    0x805020,%eax
  80174a:	8b 50 10             	mov    0x10(%eax),%edx
  80174d:	89 c8                	mov    %ecx,%eax
  80174f:	c1 e0 02             	shl    $0x2,%eax
  801752:	89 c1                	mov    %eax,%ecx
  801754:	c1 e1 09             	shl    $0x9,%ecx
  801757:	01 c8                	add    %ecx,%eax
  801759:	01 c2                	add    %eax,%edx
  80175b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80175e:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801765:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801770:	83 ec 08             	sub    $0x8,%esp
  801773:	ff 75 0c             	pushl  0xc(%ebp)
  801776:	ff 75 08             	pushl  0x8(%ebp)
  801779:	e8 f0 03 00 00       	call   801b6e <sys_getSizeOfSharedObject>
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801784:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801788:	75 0a                	jne    801794 <sget+0x2a>
  80178a:	b8 00 00 00 00       	mov    $0x0,%eax
  80178f:	e9 e7 00 00 00       	jmp    80187b <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801797:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80179a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a7:	39 d0                	cmp    %edx,%eax
  8017a9:	73 02                	jae    8017ad <sget+0x43>
  8017ab:	89 d0                	mov    %edx,%eax
  8017ad:	83 ec 0c             	sub    $0xc,%esp
  8017b0:	50                   	push   %eax
  8017b1:	e8 8c fb ff ff       	call   801342 <malloc>
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8017bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017c0:	75 0a                	jne    8017cc <sget+0x62>
  8017c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c7:	e9 af 00 00 00       	jmp    80187b <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8017cc:	83 ec 04             	sub    $0x4,%esp
  8017cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d2:	ff 75 0c             	pushl  0xc(%ebp)
  8017d5:	ff 75 08             	pushl  0x8(%ebp)
  8017d8:	e8 ae 03 00 00       	call   801b8b <sys_getSharedObject>
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8017e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8017eb:	8b 40 78             	mov    0x78(%eax),%eax
  8017ee:	29 c2                	sub    %eax,%edx
  8017f0:	89 d0                	mov    %edx,%eax
  8017f2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017f7:	c1 e8 0c             	shr    $0xc,%eax
  8017fa:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801800:	42                   	inc    %edx
  801801:	89 15 24 50 80 00    	mov    %edx,0x805024
  801807:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80180d:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801814:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801817:	a1 20 50 80 00       	mov    0x805020,%eax
  80181c:	8b 40 78             	mov    0x78(%eax),%eax
  80181f:	29 c2                	sub    %eax,%edx
  801821:	89 d0                	mov    %edx,%eax
  801823:	2d 00 10 00 00       	sub    $0x1000,%eax
  801828:	c1 e8 0c             	shr    $0xc,%eax
  80182b:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801832:	a1 20 50 80 00       	mov    0x805020,%eax
  801837:	8b 50 10             	mov    0x10(%eax),%edx
  80183a:	89 c8                	mov    %ecx,%eax
  80183c:	c1 e0 02             	shl    $0x2,%eax
  80183f:	89 c1                	mov    %eax,%ecx
  801841:	c1 e1 09             	shl    $0x9,%ecx
  801844:	01 c8                	add    %ecx,%eax
  801846:	01 c2                	add    %eax,%edx
  801848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80184b:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801852:	a1 20 50 80 00       	mov    0x805020,%eax
  801857:	8b 40 10             	mov    0x10(%eax),%eax
  80185a:	83 ec 08             	sub    $0x8,%esp
  80185d:	50                   	push   %eax
  80185e:	68 f1 43 80 00       	push   $0x8043f1
  801863:	e8 22 eb ff ff       	call   80038a <cprintf>
  801868:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80186b:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80186f:	75 07                	jne    801878 <sget+0x10e>
  801871:	b8 00 00 00 00       	mov    $0x0,%eax
  801876:	eb 03                	jmp    80187b <sget+0x111>
	return ptr;
  801878:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  801883:	8b 55 08             	mov    0x8(%ebp),%edx
  801886:	a1 20 50 80 00       	mov    0x805020,%eax
  80188b:	8b 40 78             	mov    0x78(%eax),%eax
  80188e:	29 c2                	sub    %eax,%edx
  801890:	89 d0                	mov    %edx,%eax
  801892:	2d 00 10 00 00       	sub    $0x1000,%eax
  801897:	c1 e8 0c             	shr    $0xc,%eax
  80189a:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8018a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8018a6:	8b 50 10             	mov    0x10(%eax),%edx
  8018a9:	89 c8                	mov    %ecx,%eax
  8018ab:	c1 e0 02             	shl    $0x2,%eax
  8018ae:	89 c1                	mov    %eax,%ecx
  8018b0:	c1 e1 09             	shl    $0x9,%ecx
  8018b3:	01 c8                	add    %ecx,%eax
  8018b5:	01 d0                	add    %edx,%eax
  8018b7:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018c1:	83 ec 08             	sub    $0x8,%esp
  8018c4:	ff 75 08             	pushl  0x8(%ebp)
  8018c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ca:	e8 db 02 00 00       	call   801baa <sys_freeSharedObject>
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8018d5:	90                   	nop
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018de:	83 ec 04             	sub    $0x4,%esp
  8018e1:	68 00 44 80 00       	push   $0x804400
  8018e6:	68 e5 00 00 00       	push   $0xe5
  8018eb:	68 d6 43 80 00       	push   $0x8043d6
  8018f0:	e8 55 21 00 00       	call   803a4a <_panic>

008018f5 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018fb:	83 ec 04             	sub    $0x4,%esp
  8018fe:	68 26 44 80 00       	push   $0x804426
  801903:	68 f1 00 00 00       	push   $0xf1
  801908:	68 d6 43 80 00       	push   $0x8043d6
  80190d:	e8 38 21 00 00       	call   803a4a <_panic>

00801912 <shrink>:

}
void shrink(uint32 newSize)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801918:	83 ec 04             	sub    $0x4,%esp
  80191b:	68 26 44 80 00       	push   $0x804426
  801920:	68 f6 00 00 00       	push   $0xf6
  801925:	68 d6 43 80 00       	push   $0x8043d6
  80192a:	e8 1b 21 00 00       	call   803a4a <_panic>

0080192f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801935:	83 ec 04             	sub    $0x4,%esp
  801938:	68 26 44 80 00       	push   $0x804426
  80193d:	68 fb 00 00 00       	push   $0xfb
  801942:	68 d6 43 80 00       	push   $0x8043d6
  801947:	e8 fe 20 00 00       	call   803a4a <_panic>

0080194c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	57                   	push   %edi
  801950:	56                   	push   %esi
  801951:	53                   	push   %ebx
  801952:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801961:	8b 7d 18             	mov    0x18(%ebp),%edi
  801964:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801967:	cd 30                	int    $0x30
  801969:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80196c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	5b                   	pop    %ebx
  801973:	5e                   	pop    %esi
  801974:	5f                   	pop    %edi
  801975:	5d                   	pop    %ebp
  801976:	c3                   	ret    

00801977 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	8b 45 10             	mov    0x10(%ebp),%eax
  801980:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801983:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	52                   	push   %edx
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	50                   	push   %eax
  801993:	6a 00                	push   $0x0
  801995:	e8 b2 ff ff ff       	call   80194c <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	90                   	nop
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 02                	push   $0x2
  8019af:	e8 98 ff ff ff       	call   80194c <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 03                	push   $0x3
  8019c8:	e8 7f ff ff ff       	call   80194c <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	90                   	nop
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 04                	push   $0x4
  8019e2:	e8 65 ff ff ff       	call   80194c <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
}
  8019ea:	90                   	nop
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	52                   	push   %edx
  8019fd:	50                   	push   %eax
  8019fe:	6a 08                	push   $0x8
  801a00:	e8 47 ff ff ff       	call   80194c <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	56                   	push   %esi
  801a0e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a0f:	8b 75 18             	mov    0x18(%ebp),%esi
  801a12:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a15:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	56                   	push   %esi
  801a1f:	53                   	push   %ebx
  801a20:	51                   	push   %ecx
  801a21:	52                   	push   %edx
  801a22:	50                   	push   %eax
  801a23:	6a 09                	push   $0x9
  801a25:	e8 22 ff ff ff       	call   80194c <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a30:	5b                   	pop    %ebx
  801a31:	5e                   	pop    %esi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    

00801a34 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	52                   	push   %edx
  801a44:	50                   	push   %eax
  801a45:	6a 0a                	push   $0xa
  801a47:	e8 00 ff ff ff       	call   80194c <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	ff 75 08             	pushl  0x8(%ebp)
  801a60:	6a 0b                	push   $0xb
  801a62:	e8 e5 fe ff ff       	call   80194c <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 0c                	push   $0xc
  801a7b:	e8 cc fe ff ff       	call   80194c <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 0d                	push   $0xd
  801a94:	e8 b3 fe ff ff       	call   80194c <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 0e                	push   $0xe
  801aad:	e8 9a fe ff ff       	call   80194c <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 0f                	push   $0xf
  801ac6:	e8 81 fe ff ff       	call   80194c <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	ff 75 08             	pushl  0x8(%ebp)
  801ade:	6a 10                	push   $0x10
  801ae0:	e8 67 fe ff ff       	call   80194c <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 11                	push   $0x11
  801af9:	e8 4e fe ff ff       	call   80194c <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	90                   	nop
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 04             	sub    $0x4,%esp
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	50                   	push   %eax
  801b1d:	6a 01                	push   $0x1
  801b1f:	e8 28 fe ff ff       	call   80194c <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	90                   	nop
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 14                	push   $0x14
  801b39:	e8 0e fe ff ff       	call   80194c <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	90                   	nop
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b50:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b53:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	51                   	push   %ecx
  801b5d:	52                   	push   %edx
  801b5e:	ff 75 0c             	pushl  0xc(%ebp)
  801b61:	50                   	push   %eax
  801b62:	6a 15                	push   $0x15
  801b64:	e8 e3 fd ff ff       	call   80194c <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	52                   	push   %edx
  801b7e:	50                   	push   %eax
  801b7f:	6a 16                	push   $0x16
  801b81:	e8 c6 fd ff ff       	call   80194c <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	51                   	push   %ecx
  801b9c:	52                   	push   %edx
  801b9d:	50                   	push   %eax
  801b9e:	6a 17                	push   $0x17
  801ba0:	e8 a7 fd ff ff       	call   80194c <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	52                   	push   %edx
  801bba:	50                   	push   %eax
  801bbb:	6a 18                	push   $0x18
  801bbd:	e8 8a fd ff ff       	call   80194c <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	6a 00                	push   $0x0
  801bcf:	ff 75 14             	pushl  0x14(%ebp)
  801bd2:	ff 75 10             	pushl  0x10(%ebp)
  801bd5:	ff 75 0c             	pushl  0xc(%ebp)
  801bd8:	50                   	push   %eax
  801bd9:	6a 19                	push   $0x19
  801bdb:	e8 6c fd ff ff       	call   80194c <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	50                   	push   %eax
  801bf4:	6a 1a                	push   $0x1a
  801bf6:	e8 51 fd ff ff       	call   80194c <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	90                   	nop
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	50                   	push   %eax
  801c10:	6a 1b                	push   $0x1b
  801c12:	e8 35 fd ff ff       	call   80194c <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 05                	push   $0x5
  801c2b:	e8 1c fd ff ff       	call   80194c <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 06                	push   $0x6
  801c44:	e8 03 fd ff ff       	call   80194c <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 07                	push   $0x7
  801c5d:	e8 ea fc ff ff       	call   80194c <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_exit_env>:


void sys_exit_env(void)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 1c                	push   $0x1c
  801c76:	e8 d1 fc ff ff       	call   80194c <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	90                   	nop
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c87:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c8a:	8d 50 04             	lea    0x4(%eax),%edx
  801c8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	52                   	push   %edx
  801c97:	50                   	push   %eax
  801c98:	6a 1d                	push   $0x1d
  801c9a:	e8 ad fc ff ff       	call   80194c <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
	return result;
  801ca2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ca8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cab:	89 01                	mov    %eax,(%ecx)
  801cad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	c9                   	leave  
  801cb4:	c2 04 00             	ret    $0x4

00801cb7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	ff 75 10             	pushl  0x10(%ebp)
  801cc1:	ff 75 0c             	pushl  0xc(%ebp)
  801cc4:	ff 75 08             	pushl  0x8(%ebp)
  801cc7:	6a 13                	push   $0x13
  801cc9:	e8 7e fc ff ff       	call   80194c <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd1:	90                   	nop
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 1e                	push   $0x1e
  801ce3:	e8 64 fc ff ff       	call   80194c <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cf9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	50                   	push   %eax
  801d06:	6a 1f                	push   $0x1f
  801d08:	e8 3f fc ff ff       	call   80194c <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d10:	90                   	nop
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <rsttst>:
void rsttst()
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 21                	push   $0x21
  801d22:	e8 25 fc ff ff       	call   80194c <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2a:	90                   	nop
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 04             	sub    $0x4,%esp
  801d33:	8b 45 14             	mov    0x14(%ebp),%eax
  801d36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d39:	8b 55 18             	mov    0x18(%ebp),%edx
  801d3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d40:	52                   	push   %edx
  801d41:	50                   	push   %eax
  801d42:	ff 75 10             	pushl  0x10(%ebp)
  801d45:	ff 75 0c             	pushl  0xc(%ebp)
  801d48:	ff 75 08             	pushl  0x8(%ebp)
  801d4b:	6a 20                	push   $0x20
  801d4d:	e8 fa fb ff ff       	call   80194c <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
	return ;
  801d55:	90                   	nop
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <chktst>:
void chktst(uint32 n)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	ff 75 08             	pushl  0x8(%ebp)
  801d66:	6a 22                	push   $0x22
  801d68:	e8 df fb ff ff       	call   80194c <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d70:	90                   	nop
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <inctst>:

void inctst()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 23                	push   $0x23
  801d82:	e8 c5 fb ff ff       	call   80194c <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8a:	90                   	nop
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <gettst>:
uint32 gettst()
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 24                	push   $0x24
  801d9c:	e8 ab fb ff ff       	call   80194c <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 25                	push   $0x25
  801db8:	e8 8f fb ff ff       	call   80194c <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
  801dc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dc3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dc7:	75 07                	jne    801dd0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dce:	eb 05                	jmp    801dd5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 25                	push   $0x25
  801de9:	e8 5e fb ff ff       	call   80194c <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
  801df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801df4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801df8:	75 07                	jne    801e01 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801dff:	eb 05                	jmp    801e06 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 25                	push   $0x25
  801e1a:	e8 2d fb ff ff       	call   80194c <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
  801e22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e25:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e29:	75 07                	jne    801e32 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e30:	eb 05                	jmp    801e37 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 25                	push   $0x25
  801e4b:	e8 fc fa ff ff       	call   80194c <syscall>
  801e50:	83 c4 18             	add    $0x18,%esp
  801e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e56:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e5a:	75 07                	jne    801e63 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e61:	eb 05                	jmp    801e68 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	ff 75 08             	pushl  0x8(%ebp)
  801e78:	6a 26                	push   $0x26
  801e7a:	e8 cd fa ff ff       	call   80194c <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e82:	90                   	nop
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e89:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	6a 00                	push   $0x0
  801e97:	53                   	push   %ebx
  801e98:	51                   	push   %ecx
  801e99:	52                   	push   %edx
  801e9a:	50                   	push   %eax
  801e9b:	6a 27                	push   $0x27
  801e9d:	e8 aa fa ff ff       	call   80194c <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	52                   	push   %edx
  801eba:	50                   	push   %eax
  801ebb:	6a 28                	push   $0x28
  801ebd:	e8 8a fa ff ff       	call   80194c <syscall>
  801ec2:	83 c4 18             	add    $0x18,%esp
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801eca:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ecd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	6a 00                	push   $0x0
  801ed5:	51                   	push   %ecx
  801ed6:	ff 75 10             	pushl  0x10(%ebp)
  801ed9:	52                   	push   %edx
  801eda:	50                   	push   %eax
  801edb:	6a 29                	push   $0x29
  801edd:	e8 6a fa ff ff       	call   80194c <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	ff 75 10             	pushl  0x10(%ebp)
  801ef1:	ff 75 0c             	pushl  0xc(%ebp)
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	6a 12                	push   $0x12
  801ef9:	e8 4e fa ff ff       	call   80194c <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
	return ;
  801f01:	90                   	nop
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	52                   	push   %edx
  801f14:	50                   	push   %eax
  801f15:	6a 2a                	push   $0x2a
  801f17:	e8 30 fa ff ff       	call   80194c <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
	return;
  801f1f:	90                   	nop
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	50                   	push   %eax
  801f31:	6a 2b                	push   $0x2b
  801f33:	e8 14 fa ff ff       	call   80194c <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	ff 75 0c             	pushl  0xc(%ebp)
  801f49:	ff 75 08             	pushl  0x8(%ebp)
  801f4c:	6a 2c                	push   $0x2c
  801f4e:	e8 f9 f9 ff ff       	call   80194c <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
	return;
  801f56:	90                   	nop
}
  801f57:	c9                   	leave  
  801f58:	c3                   	ret    

00801f59 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	ff 75 0c             	pushl  0xc(%ebp)
  801f65:	ff 75 08             	pushl  0x8(%ebp)
  801f68:	6a 2d                	push   $0x2d
  801f6a:	e8 dd f9 ff ff       	call   80194c <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
	return;
  801f72:	90                   	nop
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	83 e8 04             	sub    $0x4,%eax
  801f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f87:	8b 00                	mov    (%eax),%eax
  801f89:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	83 e8 04             	sub    $0x4,%eax
  801f9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa0:	8b 00                	mov    (%eax),%eax
  801fa2:	83 e0 01             	and    $0x1,%eax
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	0f 94 c0             	sete   %al
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801fb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbc:	83 f8 02             	cmp    $0x2,%eax
  801fbf:	74 2b                	je     801fec <alloc_block+0x40>
  801fc1:	83 f8 02             	cmp    $0x2,%eax
  801fc4:	7f 07                	jg     801fcd <alloc_block+0x21>
  801fc6:	83 f8 01             	cmp    $0x1,%eax
  801fc9:	74 0e                	je     801fd9 <alloc_block+0x2d>
  801fcb:	eb 58                	jmp    802025 <alloc_block+0x79>
  801fcd:	83 f8 03             	cmp    $0x3,%eax
  801fd0:	74 2d                	je     801fff <alloc_block+0x53>
  801fd2:	83 f8 04             	cmp    $0x4,%eax
  801fd5:	74 3b                	je     802012 <alloc_block+0x66>
  801fd7:	eb 4c                	jmp    802025 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fd9:	83 ec 0c             	sub    $0xc,%esp
  801fdc:	ff 75 08             	pushl  0x8(%ebp)
  801fdf:	e8 11 03 00 00       	call   8022f5 <alloc_block_FF>
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fea:	eb 4a                	jmp    802036 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fec:	83 ec 0c             	sub    $0xc,%esp
  801fef:	ff 75 08             	pushl  0x8(%ebp)
  801ff2:	e8 fa 19 00 00       	call   8039f1 <alloc_block_NF>
  801ff7:	83 c4 10             	add    $0x10,%esp
  801ffa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ffd:	eb 37                	jmp    802036 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fff:	83 ec 0c             	sub    $0xc,%esp
  802002:	ff 75 08             	pushl  0x8(%ebp)
  802005:	e8 a7 07 00 00       	call   8027b1 <alloc_block_BF>
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802010:	eb 24                	jmp    802036 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802012:	83 ec 0c             	sub    $0xc,%esp
  802015:	ff 75 08             	pushl  0x8(%ebp)
  802018:	e8 b7 19 00 00       	call   8039d4 <alloc_block_WF>
  80201d:	83 c4 10             	add    $0x10,%esp
  802020:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802023:	eb 11                	jmp    802036 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802025:	83 ec 0c             	sub    $0xc,%esp
  802028:	68 38 44 80 00       	push   $0x804438
  80202d:	e8 58 e3 ff ff       	call   80038a <cprintf>
  802032:	83 c4 10             	add    $0x10,%esp
		break;
  802035:	90                   	nop
	}
	return va;
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	53                   	push   %ebx
  80203f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802042:	83 ec 0c             	sub    $0xc,%esp
  802045:	68 58 44 80 00       	push   $0x804458
  80204a:	e8 3b e3 ff ff       	call   80038a <cprintf>
  80204f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802052:	83 ec 0c             	sub    $0xc,%esp
  802055:	68 83 44 80 00       	push   $0x804483
  80205a:	e8 2b e3 ff ff       	call   80038a <cprintf>
  80205f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802068:	eb 37                	jmp    8020a1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80206a:	83 ec 0c             	sub    $0xc,%esp
  80206d:	ff 75 f4             	pushl  -0xc(%ebp)
  802070:	e8 19 ff ff ff       	call   801f8e <is_free_block>
  802075:	83 c4 10             	add    $0x10,%esp
  802078:	0f be d8             	movsbl %al,%ebx
  80207b:	83 ec 0c             	sub    $0xc,%esp
  80207e:	ff 75 f4             	pushl  -0xc(%ebp)
  802081:	e8 ef fe ff ff       	call   801f75 <get_block_size>
  802086:	83 c4 10             	add    $0x10,%esp
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	53                   	push   %ebx
  80208d:	50                   	push   %eax
  80208e:	68 9b 44 80 00       	push   $0x80449b
  802093:	e8 f2 e2 ff ff       	call   80038a <cprintf>
  802098:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80209b:	8b 45 10             	mov    0x10(%ebp),%eax
  80209e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a5:	74 07                	je     8020ae <print_blocks_list+0x73>
  8020a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020aa:	8b 00                	mov    (%eax),%eax
  8020ac:	eb 05                	jmp    8020b3 <print_blocks_list+0x78>
  8020ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b3:	89 45 10             	mov    %eax,0x10(%ebp)
  8020b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	75 ad                	jne    80206a <print_blocks_list+0x2f>
  8020bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c1:	75 a7                	jne    80206a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020c3:	83 ec 0c             	sub    $0xc,%esp
  8020c6:	68 58 44 80 00       	push   $0x804458
  8020cb:	e8 ba e2 ff ff       	call   80038a <cprintf>
  8020d0:	83 c4 10             	add    $0x10,%esp

}
  8020d3:	90                   	nop
  8020d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
  8020dc:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e2:	83 e0 01             	and    $0x1,%eax
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	74 03                	je     8020ec <initialize_dynamic_allocator+0x13>
  8020e9:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020f0:	0f 84 c7 01 00 00    	je     8022bd <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020f6:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  8020fd:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802100:	8b 55 08             	mov    0x8(%ebp),%edx
  802103:	8b 45 0c             	mov    0xc(%ebp),%eax
  802106:	01 d0                	add    %edx,%eax
  802108:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80210d:	0f 87 ad 01 00 00    	ja     8022c0 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	85 c0                	test   %eax,%eax
  802118:	0f 89 a5 01 00 00    	jns    8022c3 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80211e:	8b 55 08             	mov    0x8(%ebp),%edx
  802121:	8b 45 0c             	mov    0xc(%ebp),%eax
  802124:	01 d0                	add    %edx,%eax
  802126:	83 e8 04             	sub    $0x4,%eax
  802129:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  80212e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802135:	a1 30 50 80 00       	mov    0x805030,%eax
  80213a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213d:	e9 87 00 00 00       	jmp    8021c9 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802142:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802146:	75 14                	jne    80215c <initialize_dynamic_allocator+0x83>
  802148:	83 ec 04             	sub    $0x4,%esp
  80214b:	68 b3 44 80 00       	push   $0x8044b3
  802150:	6a 79                	push   $0x79
  802152:	68 d1 44 80 00       	push   $0x8044d1
  802157:	e8 ee 18 00 00       	call   803a4a <_panic>
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	8b 00                	mov    (%eax),%eax
  802161:	85 c0                	test   %eax,%eax
  802163:	74 10                	je     802175 <initialize_dynamic_allocator+0x9c>
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	8b 00                	mov    (%eax),%eax
  80216a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216d:	8b 52 04             	mov    0x4(%edx),%edx
  802170:	89 50 04             	mov    %edx,0x4(%eax)
  802173:	eb 0b                	jmp    802180 <initialize_dynamic_allocator+0xa7>
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 40 04             	mov    0x4(%eax),%eax
  80217b:	a3 34 50 80 00       	mov    %eax,0x805034
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 40 04             	mov    0x4(%eax),%eax
  802186:	85 c0                	test   %eax,%eax
  802188:	74 0f                	je     802199 <initialize_dynamic_allocator+0xc0>
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 40 04             	mov    0x4(%eax),%eax
  802190:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802193:	8b 12                	mov    (%edx),%edx
  802195:	89 10                	mov    %edx,(%eax)
  802197:	eb 0a                	jmp    8021a3 <initialize_dynamic_allocator+0xca>
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 00                	mov    (%eax),%eax
  80219e:	a3 30 50 80 00       	mov    %eax,0x805030
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8021bb:	48                   	dec    %eax
  8021bc:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8021c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cd:	74 07                	je     8021d6 <initialize_dynamic_allocator+0xfd>
  8021cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d2:	8b 00                	mov    (%eax),%eax
  8021d4:	eb 05                	jmp    8021db <initialize_dynamic_allocator+0x102>
  8021d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021db:	a3 38 50 80 00       	mov    %eax,0x805038
  8021e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	0f 85 55 ff ff ff    	jne    802142 <initialize_dynamic_allocator+0x69>
  8021ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f1:	0f 85 4b ff ff ff    	jne    802142 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802200:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802206:	a1 48 50 80 00       	mov    0x805048,%eax
  80220b:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802210:	a1 44 50 80 00       	mov    0x805044,%eax
  802215:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	83 c0 08             	add    $0x8,%eax
  802221:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	83 c0 04             	add    $0x4,%eax
  80222a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222d:	83 ea 08             	sub    $0x8,%edx
  802230:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802232:	8b 55 0c             	mov    0xc(%ebp),%edx
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	01 d0                	add    %edx,%eax
  80223a:	83 e8 08             	sub    $0x8,%eax
  80223d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802240:	83 ea 08             	sub    $0x8,%edx
  802243:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802245:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802248:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80224e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802251:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802258:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80225c:	75 17                	jne    802275 <initialize_dynamic_allocator+0x19c>
  80225e:	83 ec 04             	sub    $0x4,%esp
  802261:	68 ec 44 80 00       	push   $0x8044ec
  802266:	68 90 00 00 00       	push   $0x90
  80226b:	68 d1 44 80 00       	push   $0x8044d1
  802270:	e8 d5 17 00 00       	call   803a4a <_panic>
  802275:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80227b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227e:	89 10                	mov    %edx,(%eax)
  802280:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	85 c0                	test   %eax,%eax
  802287:	74 0d                	je     802296 <initialize_dynamic_allocator+0x1bd>
  802289:	a1 30 50 80 00       	mov    0x805030,%eax
  80228e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802291:	89 50 04             	mov    %edx,0x4(%eax)
  802294:	eb 08                	jmp    80229e <initialize_dynamic_allocator+0x1c5>
  802296:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802299:	a3 34 50 80 00       	mov    %eax,0x805034
  80229e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8022a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8022b5:	40                   	inc    %eax
  8022b6:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8022bb:	eb 07                	jmp    8022c4 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022bd:	90                   	nop
  8022be:	eb 04                	jmp    8022c4 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022c0:	90                   	nop
  8022c1:	eb 01                	jmp    8022c4 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022c3:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022cc:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d8:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	83 e8 04             	sub    $0x4,%eax
  8022e0:	8b 00                	mov    (%eax),%eax
  8022e2:	83 e0 fe             	and    $0xfffffffe,%eax
  8022e5:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	01 c2                	add    %eax,%edx
  8022ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f0:	89 02                	mov    %eax,(%edx)
}
  8022f2:	90                   	nop
  8022f3:	5d                   	pop    %ebp
  8022f4:	c3                   	ret    

008022f5 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
  8022f8:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	83 e0 01             	and    $0x1,%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	74 03                	je     802308 <alloc_block_FF+0x13>
  802305:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802308:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80230c:	77 07                	ja     802315 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80230e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802315:	a1 28 50 80 00       	mov    0x805028,%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	75 73                	jne    802391 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	83 c0 10             	add    $0x10,%eax
  802324:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802327:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80232e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802331:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802334:	01 d0                	add    %edx,%eax
  802336:	48                   	dec    %eax
  802337:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80233a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80233d:	ba 00 00 00 00       	mov    $0x0,%edx
  802342:	f7 75 ec             	divl   -0x14(%ebp)
  802345:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802348:	29 d0                	sub    %edx,%eax
  80234a:	c1 e8 0c             	shr    $0xc,%eax
  80234d:	83 ec 0c             	sub    $0xc,%esp
  802350:	50                   	push   %eax
  802351:	e8 d6 ef ff ff       	call   80132c <sbrk>
  802356:	83 c4 10             	add    $0x10,%esp
  802359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80235c:	83 ec 0c             	sub    $0xc,%esp
  80235f:	6a 00                	push   $0x0
  802361:	e8 c6 ef ff ff       	call   80132c <sbrk>
  802366:	83 c4 10             	add    $0x10,%esp
  802369:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80236c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802372:	83 ec 08             	sub    $0x8,%esp
  802375:	50                   	push   %eax
  802376:	ff 75 e4             	pushl  -0x1c(%ebp)
  802379:	e8 5b fd ff ff       	call   8020d9 <initialize_dynamic_allocator>
  80237e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802381:	83 ec 0c             	sub    $0xc,%esp
  802384:	68 0f 45 80 00       	push   $0x80450f
  802389:	e8 fc df ff ff       	call   80038a <cprintf>
  80238e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802391:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802395:	75 0a                	jne    8023a1 <alloc_block_FF+0xac>
	        return NULL;
  802397:	b8 00 00 00 00       	mov    $0x0,%eax
  80239c:	e9 0e 04 00 00       	jmp    8027af <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023a8:	a1 30 50 80 00       	mov    0x805030,%eax
  8023ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b0:	e9 f3 02 00 00       	jmp    8026a8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023bb:	83 ec 0c             	sub    $0xc,%esp
  8023be:	ff 75 bc             	pushl  -0x44(%ebp)
  8023c1:	e8 af fb ff ff       	call   801f75 <get_block_size>
  8023c6:	83 c4 10             	add    $0x10,%esp
  8023c9:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	83 c0 08             	add    $0x8,%eax
  8023d2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023d5:	0f 87 c5 02 00 00    	ja     8026a0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	83 c0 18             	add    $0x18,%eax
  8023e1:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023e4:	0f 87 19 02 00 00    	ja     802603 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023ed:	2b 45 08             	sub    0x8(%ebp),%eax
  8023f0:	83 e8 08             	sub    $0x8,%eax
  8023f3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	8d 50 08             	lea    0x8(%eax),%edx
  8023fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023ff:	01 d0                	add    %edx,%eax
  802401:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	83 c0 08             	add    $0x8,%eax
  80240a:	83 ec 04             	sub    $0x4,%esp
  80240d:	6a 01                	push   $0x1
  80240f:	50                   	push   %eax
  802410:	ff 75 bc             	pushl  -0x44(%ebp)
  802413:	e8 ae fe ff ff       	call   8022c6 <set_block_data>
  802418:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	85 c0                	test   %eax,%eax
  802423:	75 68                	jne    80248d <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802425:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802429:	75 17                	jne    802442 <alloc_block_FF+0x14d>
  80242b:	83 ec 04             	sub    $0x4,%esp
  80242e:	68 ec 44 80 00       	push   $0x8044ec
  802433:	68 d7 00 00 00       	push   $0xd7
  802438:	68 d1 44 80 00       	push   $0x8044d1
  80243d:	e8 08 16 00 00       	call   803a4a <_panic>
  802442:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802448:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244b:	89 10                	mov    %edx,(%eax)
  80244d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802450:	8b 00                	mov    (%eax),%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	74 0d                	je     802463 <alloc_block_FF+0x16e>
  802456:	a1 30 50 80 00       	mov    0x805030,%eax
  80245b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80245e:	89 50 04             	mov    %edx,0x4(%eax)
  802461:	eb 08                	jmp    80246b <alloc_block_FF+0x176>
  802463:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802466:	a3 34 50 80 00       	mov    %eax,0x805034
  80246b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246e:	a3 30 50 80 00       	mov    %eax,0x805030
  802473:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802476:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802482:	40                   	inc    %eax
  802483:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802488:	e9 dc 00 00 00       	jmp    802569 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 00                	mov    (%eax),%eax
  802492:	85 c0                	test   %eax,%eax
  802494:	75 65                	jne    8024fb <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802496:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80249a:	75 17                	jne    8024b3 <alloc_block_FF+0x1be>
  80249c:	83 ec 04             	sub    $0x4,%esp
  80249f:	68 20 45 80 00       	push   $0x804520
  8024a4:	68 db 00 00 00       	push   $0xdb
  8024a9:	68 d1 44 80 00       	push   $0x8044d1
  8024ae:	e8 97 15 00 00       	call   803a4a <_panic>
  8024b3:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8024b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bc:	89 50 04             	mov    %edx,0x4(%eax)
  8024bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c2:	8b 40 04             	mov    0x4(%eax),%eax
  8024c5:	85 c0                	test   %eax,%eax
  8024c7:	74 0c                	je     8024d5 <alloc_block_FF+0x1e0>
  8024c9:	a1 34 50 80 00       	mov    0x805034,%eax
  8024ce:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024d1:	89 10                	mov    %edx,(%eax)
  8024d3:	eb 08                	jmp    8024dd <alloc_block_FF+0x1e8>
  8024d5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8024dd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e0:	a3 34 50 80 00       	mov    %eax,0x805034
  8024e5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8024f3:	40                   	inc    %eax
  8024f4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8024f9:	eb 6e                	jmp    802569 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ff:	74 06                	je     802507 <alloc_block_FF+0x212>
  802501:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802505:	75 17                	jne    80251e <alloc_block_FF+0x229>
  802507:	83 ec 04             	sub    $0x4,%esp
  80250a:	68 44 45 80 00       	push   $0x804544
  80250f:	68 df 00 00 00       	push   $0xdf
  802514:	68 d1 44 80 00       	push   $0x8044d1
  802519:	e8 2c 15 00 00       	call   803a4a <_panic>
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	8b 10                	mov    (%eax),%edx
  802523:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802526:	89 10                	mov    %edx,(%eax)
  802528:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80252b:	8b 00                	mov    (%eax),%eax
  80252d:	85 c0                	test   %eax,%eax
  80252f:	74 0b                	je     80253c <alloc_block_FF+0x247>
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 00                	mov    (%eax),%eax
  802536:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802539:	89 50 04             	mov    %edx,0x4(%eax)
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802542:	89 10                	mov    %edx,(%eax)
  802544:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802547:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254a:	89 50 04             	mov    %edx,0x4(%eax)
  80254d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	85 c0                	test   %eax,%eax
  802554:	75 08                	jne    80255e <alloc_block_FF+0x269>
  802556:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802559:	a3 34 50 80 00       	mov    %eax,0x805034
  80255e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802563:	40                   	inc    %eax
  802564:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256d:	75 17                	jne    802586 <alloc_block_FF+0x291>
  80256f:	83 ec 04             	sub    $0x4,%esp
  802572:	68 b3 44 80 00       	push   $0x8044b3
  802577:	68 e1 00 00 00       	push   $0xe1
  80257c:	68 d1 44 80 00       	push   $0x8044d1
  802581:	e8 c4 14 00 00       	call   803a4a <_panic>
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	8b 00                	mov    (%eax),%eax
  80258b:	85 c0                	test   %eax,%eax
  80258d:	74 10                	je     80259f <alloc_block_FF+0x2aa>
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 00                	mov    (%eax),%eax
  802594:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802597:	8b 52 04             	mov    0x4(%edx),%edx
  80259a:	89 50 04             	mov    %edx,0x4(%eax)
  80259d:	eb 0b                	jmp    8025aa <alloc_block_FF+0x2b5>
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 40 04             	mov    0x4(%eax),%eax
  8025a5:	a3 34 50 80 00       	mov    %eax,0x805034
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 40 04             	mov    0x4(%eax),%eax
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	74 0f                	je     8025c3 <alloc_block_FF+0x2ce>
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bd:	8b 12                	mov    (%edx),%edx
  8025bf:	89 10                	mov    %edx,(%eax)
  8025c1:	eb 0a                	jmp    8025cd <alloc_block_FF+0x2d8>
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	a3 30 50 80 00       	mov    %eax,0x805030
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e0:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8025e5:	48                   	dec    %eax
  8025e6:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  8025eb:	83 ec 04             	sub    $0x4,%esp
  8025ee:	6a 00                	push   $0x0
  8025f0:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025f3:	ff 75 b0             	pushl  -0x50(%ebp)
  8025f6:	e8 cb fc ff ff       	call   8022c6 <set_block_data>
  8025fb:	83 c4 10             	add    $0x10,%esp
  8025fe:	e9 95 00 00 00       	jmp    802698 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802603:	83 ec 04             	sub    $0x4,%esp
  802606:	6a 01                	push   $0x1
  802608:	ff 75 b8             	pushl  -0x48(%ebp)
  80260b:	ff 75 bc             	pushl  -0x44(%ebp)
  80260e:	e8 b3 fc ff ff       	call   8022c6 <set_block_data>
  802613:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261a:	75 17                	jne    802633 <alloc_block_FF+0x33e>
  80261c:	83 ec 04             	sub    $0x4,%esp
  80261f:	68 b3 44 80 00       	push   $0x8044b3
  802624:	68 e8 00 00 00       	push   $0xe8
  802629:	68 d1 44 80 00       	push   $0x8044d1
  80262e:	e8 17 14 00 00       	call   803a4a <_panic>
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 00                	mov    (%eax),%eax
  802638:	85 c0                	test   %eax,%eax
  80263a:	74 10                	je     80264c <alloc_block_FF+0x357>
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 00                	mov    (%eax),%eax
  802641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802644:	8b 52 04             	mov    0x4(%edx),%edx
  802647:	89 50 04             	mov    %edx,0x4(%eax)
  80264a:	eb 0b                	jmp    802657 <alloc_block_FF+0x362>
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 04             	mov    0x4(%eax),%eax
  802652:	a3 34 50 80 00       	mov    %eax,0x805034
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 40 04             	mov    0x4(%eax),%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 0f                	je     802670 <alloc_block_FF+0x37b>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266a:	8b 12                	mov    (%edx),%edx
  80266c:	89 10                	mov    %edx,(%eax)
  80266e:	eb 0a                	jmp    80267a <alloc_block_FF+0x385>
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	a3 30 50 80 00       	mov    %eax,0x805030
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802692:	48                   	dec    %eax
  802693:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802698:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80269b:	e9 0f 01 00 00       	jmp    8027af <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8026a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ac:	74 07                	je     8026b5 <alloc_block_FF+0x3c0>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	eb 05                	jmp    8026ba <alloc_block_FF+0x3c5>
  8026b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ba:	a3 38 50 80 00       	mov    %eax,0x805038
  8026bf:	a1 38 50 80 00       	mov    0x805038,%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	0f 85 e9 fc ff ff    	jne    8023b5 <alloc_block_FF+0xc0>
  8026cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d0:	0f 85 df fc ff ff    	jne    8023b5 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	83 c0 08             	add    $0x8,%eax
  8026dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026df:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026ec:	01 d0                	add    %edx,%eax
  8026ee:	48                   	dec    %eax
  8026ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fa:	f7 75 d8             	divl   -0x28(%ebp)
  8026fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802700:	29 d0                	sub    %edx,%eax
  802702:	c1 e8 0c             	shr    $0xc,%eax
  802705:	83 ec 0c             	sub    $0xc,%esp
  802708:	50                   	push   %eax
  802709:	e8 1e ec ff ff       	call   80132c <sbrk>
  80270e:	83 c4 10             	add    $0x10,%esp
  802711:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802714:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802718:	75 0a                	jne    802724 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80271a:	b8 00 00 00 00       	mov    $0x0,%eax
  80271f:	e9 8b 00 00 00       	jmp    8027af <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802724:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80272b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80272e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802731:	01 d0                	add    %edx,%eax
  802733:	48                   	dec    %eax
  802734:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802737:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80273a:	ba 00 00 00 00       	mov    $0x0,%edx
  80273f:	f7 75 cc             	divl   -0x34(%ebp)
  802742:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802745:	29 d0                	sub    %edx,%eax
  802747:	8d 50 fc             	lea    -0x4(%eax),%edx
  80274a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80274d:	01 d0                	add    %edx,%eax
  80274f:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802754:	a1 44 50 80 00       	mov    0x805044,%eax
  802759:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80275f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802766:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802769:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80276c:	01 d0                	add    %edx,%eax
  80276e:	48                   	dec    %eax
  80276f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802772:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802775:	ba 00 00 00 00       	mov    $0x0,%edx
  80277a:	f7 75 c4             	divl   -0x3c(%ebp)
  80277d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802780:	29 d0                	sub    %edx,%eax
  802782:	83 ec 04             	sub    $0x4,%esp
  802785:	6a 01                	push   $0x1
  802787:	50                   	push   %eax
  802788:	ff 75 d0             	pushl  -0x30(%ebp)
  80278b:	e8 36 fb ff ff       	call   8022c6 <set_block_data>
  802790:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802793:	83 ec 0c             	sub    $0xc,%esp
  802796:	ff 75 d0             	pushl  -0x30(%ebp)
  802799:	e8 1b 0a 00 00       	call   8031b9 <free_block>
  80279e:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027a1:	83 ec 0c             	sub    $0xc,%esp
  8027a4:	ff 75 08             	pushl  0x8(%ebp)
  8027a7:	e8 49 fb ff ff       	call   8022f5 <alloc_block_FF>
  8027ac:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027af:	c9                   	leave  
  8027b0:	c3                   	ret    

008027b1 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	83 e0 01             	and    $0x1,%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	74 03                	je     8027c4 <alloc_block_BF+0x13>
  8027c1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027c4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027c8:	77 07                	ja     8027d1 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027ca:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027d1:	a1 28 50 80 00       	mov    0x805028,%eax
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	75 73                	jne    80284d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	83 c0 10             	add    $0x10,%eax
  8027e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027e3:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f0:	01 d0                	add    %edx,%eax
  8027f2:	48                   	dec    %eax
  8027f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8027fe:	f7 75 e0             	divl   -0x20(%ebp)
  802801:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802804:	29 d0                	sub    %edx,%eax
  802806:	c1 e8 0c             	shr    $0xc,%eax
  802809:	83 ec 0c             	sub    $0xc,%esp
  80280c:	50                   	push   %eax
  80280d:	e8 1a eb ff ff       	call   80132c <sbrk>
  802812:	83 c4 10             	add    $0x10,%esp
  802815:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802818:	83 ec 0c             	sub    $0xc,%esp
  80281b:	6a 00                	push   $0x0
  80281d:	e8 0a eb ff ff       	call   80132c <sbrk>
  802822:	83 c4 10             	add    $0x10,%esp
  802825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802828:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80282b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80282e:	83 ec 08             	sub    $0x8,%esp
  802831:	50                   	push   %eax
  802832:	ff 75 d8             	pushl  -0x28(%ebp)
  802835:	e8 9f f8 ff ff       	call   8020d9 <initialize_dynamic_allocator>
  80283a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80283d:	83 ec 0c             	sub    $0xc,%esp
  802840:	68 0f 45 80 00       	push   $0x80450f
  802845:	e8 40 db ff ff       	call   80038a <cprintf>
  80284a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80284d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802854:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80285b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802862:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802869:	a1 30 50 80 00       	mov    0x805030,%eax
  80286e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802871:	e9 1d 01 00 00       	jmp    802993 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	ff 75 a8             	pushl  -0x58(%ebp)
  802882:	e8 ee f6 ff ff       	call   801f75 <get_block_size>
  802887:	83 c4 10             	add    $0x10,%esp
  80288a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	83 c0 08             	add    $0x8,%eax
  802893:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802896:	0f 87 ef 00 00 00    	ja     80298b <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80289c:	8b 45 08             	mov    0x8(%ebp),%eax
  80289f:	83 c0 18             	add    $0x18,%eax
  8028a2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028a5:	77 1d                	ja     8028c4 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028aa:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ad:	0f 86 d8 00 00 00    	jbe    80298b <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028b3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028b9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028bf:	e9 c7 00 00 00       	jmp    80298b <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	83 c0 08             	add    $0x8,%eax
  8028ca:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028cd:	0f 85 9d 00 00 00    	jne    802970 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028d3:	83 ec 04             	sub    $0x4,%esp
  8028d6:	6a 01                	push   $0x1
  8028d8:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028db:	ff 75 a8             	pushl  -0x58(%ebp)
  8028de:	e8 e3 f9 ff ff       	call   8022c6 <set_block_data>
  8028e3:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ea:	75 17                	jne    802903 <alloc_block_BF+0x152>
  8028ec:	83 ec 04             	sub    $0x4,%esp
  8028ef:	68 b3 44 80 00       	push   $0x8044b3
  8028f4:	68 2c 01 00 00       	push   $0x12c
  8028f9:	68 d1 44 80 00       	push   $0x8044d1
  8028fe:	e8 47 11 00 00       	call   803a4a <_panic>
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 00                	mov    (%eax),%eax
  802908:	85 c0                	test   %eax,%eax
  80290a:	74 10                	je     80291c <alloc_block_BF+0x16b>
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 00                	mov    (%eax),%eax
  802911:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802914:	8b 52 04             	mov    0x4(%edx),%edx
  802917:	89 50 04             	mov    %edx,0x4(%eax)
  80291a:	eb 0b                	jmp    802927 <alloc_block_BF+0x176>
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 40 04             	mov    0x4(%eax),%eax
  802922:	a3 34 50 80 00       	mov    %eax,0x805034
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	8b 40 04             	mov    0x4(%eax),%eax
  80292d:	85 c0                	test   %eax,%eax
  80292f:	74 0f                	je     802940 <alloc_block_BF+0x18f>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 40 04             	mov    0x4(%eax),%eax
  802937:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293a:	8b 12                	mov    (%edx),%edx
  80293c:	89 10                	mov    %edx,(%eax)
  80293e:	eb 0a                	jmp    80294a <alloc_block_BF+0x199>
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	a3 30 50 80 00       	mov    %eax,0x805030
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802962:	48                   	dec    %eax
  802963:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802968:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80296b:	e9 24 04 00 00       	jmp    802d94 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802970:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802973:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802976:	76 13                	jbe    80298b <alloc_block_BF+0x1da>
					{
						internal = 1;
  802978:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80297f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802982:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802985:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802988:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80298b:	a1 38 50 80 00       	mov    0x805038,%eax
  802990:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802993:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802997:	74 07                	je     8029a0 <alloc_block_BF+0x1ef>
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	eb 05                	jmp    8029a5 <alloc_block_BF+0x1f4>
  8029a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a5:	a3 38 50 80 00       	mov    %eax,0x805038
  8029aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	0f 85 bf fe ff ff    	jne    802876 <alloc_block_BF+0xc5>
  8029b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bb:	0f 85 b5 fe ff ff    	jne    802876 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029c5:	0f 84 26 02 00 00    	je     802bf1 <alloc_block_BF+0x440>
  8029cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029cf:	0f 85 1c 02 00 00    	jne    802bf1 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d8:	2b 45 08             	sub    0x8(%ebp),%eax
  8029db:	83 e8 08             	sub    $0x8,%eax
  8029de:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	8d 50 08             	lea    0x8(%eax),%edx
  8029e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ea:	01 d0                	add    %edx,%eax
  8029ec:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	83 c0 08             	add    $0x8,%eax
  8029f5:	83 ec 04             	sub    $0x4,%esp
  8029f8:	6a 01                	push   $0x1
  8029fa:	50                   	push   %eax
  8029fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8029fe:	e8 c3 f8 ff ff       	call   8022c6 <set_block_data>
  802a03:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a09:	8b 40 04             	mov    0x4(%eax),%eax
  802a0c:	85 c0                	test   %eax,%eax
  802a0e:	75 68                	jne    802a78 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a10:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a14:	75 17                	jne    802a2d <alloc_block_BF+0x27c>
  802a16:	83 ec 04             	sub    $0x4,%esp
  802a19:	68 ec 44 80 00       	push   $0x8044ec
  802a1e:	68 45 01 00 00       	push   $0x145
  802a23:	68 d1 44 80 00       	push   $0x8044d1
  802a28:	e8 1d 10 00 00       	call   803a4a <_panic>
  802a2d:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a33:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a36:	89 10                	mov    %edx,(%eax)
  802a38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	74 0d                	je     802a4e <alloc_block_BF+0x29d>
  802a41:	a1 30 50 80 00       	mov    0x805030,%eax
  802a46:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a49:	89 50 04             	mov    %edx,0x4(%eax)
  802a4c:	eb 08                	jmp    802a56 <alloc_block_BF+0x2a5>
  802a4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a51:	a3 34 50 80 00       	mov    %eax,0x805034
  802a56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a59:	a3 30 50 80 00       	mov    %eax,0x805030
  802a5e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a68:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a6d:	40                   	inc    %eax
  802a6e:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802a73:	e9 dc 00 00 00       	jmp    802b54 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	75 65                	jne    802ae6 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a81:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a85:	75 17                	jne    802a9e <alloc_block_BF+0x2ed>
  802a87:	83 ec 04             	sub    $0x4,%esp
  802a8a:	68 20 45 80 00       	push   $0x804520
  802a8f:	68 4a 01 00 00       	push   $0x14a
  802a94:	68 d1 44 80 00       	push   $0x8044d1
  802a99:	e8 ac 0f 00 00       	call   803a4a <_panic>
  802a9e:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802aa4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa7:	89 50 04             	mov    %edx,0x4(%eax)
  802aaa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aad:	8b 40 04             	mov    0x4(%eax),%eax
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	74 0c                	je     802ac0 <alloc_block_BF+0x30f>
  802ab4:	a1 34 50 80 00       	mov    0x805034,%eax
  802ab9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802abc:	89 10                	mov    %edx,(%eax)
  802abe:	eb 08                	jmp    802ac8 <alloc_block_BF+0x317>
  802ac0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac3:	a3 30 50 80 00       	mov    %eax,0x805030
  802ac8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802acb:	a3 34 50 80 00       	mov    %eax,0x805034
  802ad0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ad3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ade:	40                   	inc    %eax
  802adf:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ae4:	eb 6e                	jmp    802b54 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ae6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aea:	74 06                	je     802af2 <alloc_block_BF+0x341>
  802aec:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802af0:	75 17                	jne    802b09 <alloc_block_BF+0x358>
  802af2:	83 ec 04             	sub    $0x4,%esp
  802af5:	68 44 45 80 00       	push   $0x804544
  802afa:	68 4f 01 00 00       	push   $0x14f
  802aff:	68 d1 44 80 00       	push   $0x8044d1
  802b04:	e8 41 0f 00 00       	call   803a4a <_panic>
  802b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0c:	8b 10                	mov    (%eax),%edx
  802b0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b11:	89 10                	mov    %edx,(%eax)
  802b13:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b16:	8b 00                	mov    (%eax),%eax
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	74 0b                	je     802b27 <alloc_block_BF+0x376>
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b24:	89 50 04             	mov    %edx,0x4(%eax)
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b2d:	89 10                	mov    %edx,(%eax)
  802b2f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b35:	89 50 04             	mov    %edx,0x4(%eax)
  802b38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b3b:	8b 00                	mov    (%eax),%eax
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	75 08                	jne    802b49 <alloc_block_BF+0x398>
  802b41:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b44:	a3 34 50 80 00       	mov    %eax,0x805034
  802b49:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b4e:	40                   	inc    %eax
  802b4f:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b58:	75 17                	jne    802b71 <alloc_block_BF+0x3c0>
  802b5a:	83 ec 04             	sub    $0x4,%esp
  802b5d:	68 b3 44 80 00       	push   $0x8044b3
  802b62:	68 51 01 00 00       	push   $0x151
  802b67:	68 d1 44 80 00       	push   $0x8044d1
  802b6c:	e8 d9 0e 00 00       	call   803a4a <_panic>
  802b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	74 10                	je     802b8a <alloc_block_BF+0x3d9>
  802b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7d:	8b 00                	mov    (%eax),%eax
  802b7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b82:	8b 52 04             	mov    0x4(%edx),%edx
  802b85:	89 50 04             	mov    %edx,0x4(%eax)
  802b88:	eb 0b                	jmp    802b95 <alloc_block_BF+0x3e4>
  802b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8d:	8b 40 04             	mov    0x4(%eax),%eax
  802b90:	a3 34 50 80 00       	mov    %eax,0x805034
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	8b 40 04             	mov    0x4(%eax),%eax
  802b9b:	85 c0                	test   %eax,%eax
  802b9d:	74 0f                	je     802bae <alloc_block_BF+0x3fd>
  802b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba2:	8b 40 04             	mov    0x4(%eax),%eax
  802ba5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba8:	8b 12                	mov    (%edx),%edx
  802baa:	89 10                	mov    %edx,(%eax)
  802bac:	eb 0a                	jmp    802bb8 <alloc_block_BF+0x407>
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	8b 00                	mov    (%eax),%eax
  802bb3:	a3 30 50 80 00       	mov    %eax,0x805030
  802bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802bd0:	48                   	dec    %eax
  802bd1:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802bd6:	83 ec 04             	sub    $0x4,%esp
  802bd9:	6a 00                	push   $0x0
  802bdb:	ff 75 d0             	pushl  -0x30(%ebp)
  802bde:	ff 75 cc             	pushl  -0x34(%ebp)
  802be1:	e8 e0 f6 ff ff       	call   8022c6 <set_block_data>
  802be6:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bec:	e9 a3 01 00 00       	jmp    802d94 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802bf1:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802bf5:	0f 85 9d 00 00 00    	jne    802c98 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802bfb:	83 ec 04             	sub    $0x4,%esp
  802bfe:	6a 01                	push   $0x1
  802c00:	ff 75 ec             	pushl  -0x14(%ebp)
  802c03:	ff 75 f0             	pushl  -0x10(%ebp)
  802c06:	e8 bb f6 ff ff       	call   8022c6 <set_block_data>
  802c0b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c12:	75 17                	jne    802c2b <alloc_block_BF+0x47a>
  802c14:	83 ec 04             	sub    $0x4,%esp
  802c17:	68 b3 44 80 00       	push   $0x8044b3
  802c1c:	68 58 01 00 00       	push   $0x158
  802c21:	68 d1 44 80 00       	push   $0x8044d1
  802c26:	e8 1f 0e 00 00       	call   803a4a <_panic>
  802c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2e:	8b 00                	mov    (%eax),%eax
  802c30:	85 c0                	test   %eax,%eax
  802c32:	74 10                	je     802c44 <alloc_block_BF+0x493>
  802c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c3c:	8b 52 04             	mov    0x4(%edx),%edx
  802c3f:	89 50 04             	mov    %edx,0x4(%eax)
  802c42:	eb 0b                	jmp    802c4f <alloc_block_BF+0x49e>
  802c44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c47:	8b 40 04             	mov    0x4(%eax),%eax
  802c4a:	a3 34 50 80 00       	mov    %eax,0x805034
  802c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	74 0f                	je     802c68 <alloc_block_BF+0x4b7>
  802c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5c:	8b 40 04             	mov    0x4(%eax),%eax
  802c5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c62:	8b 12                	mov    (%edx),%edx
  802c64:	89 10                	mov    %edx,(%eax)
  802c66:	eb 0a                	jmp    802c72 <alloc_block_BF+0x4c1>
  802c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6b:	8b 00                	mov    (%eax),%eax
  802c6d:	a3 30 50 80 00       	mov    %eax,0x805030
  802c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c85:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c8a:	48                   	dec    %eax
  802c8b:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c93:	e9 fc 00 00 00       	jmp    802d94 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	83 c0 08             	add    $0x8,%eax
  802c9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ca1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ca8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cae:	01 d0                	add    %edx,%eax
  802cb0:	48                   	dec    %eax
  802cb1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cb4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  802cbc:	f7 75 c4             	divl   -0x3c(%ebp)
  802cbf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cc2:	29 d0                	sub    %edx,%eax
  802cc4:	c1 e8 0c             	shr    $0xc,%eax
  802cc7:	83 ec 0c             	sub    $0xc,%esp
  802cca:	50                   	push   %eax
  802ccb:	e8 5c e6 ff ff       	call   80132c <sbrk>
  802cd0:	83 c4 10             	add    $0x10,%esp
  802cd3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cd6:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cda:	75 0a                	jne    802ce6 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cdc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce1:	e9 ae 00 00 00       	jmp    802d94 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802ce6:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802ced:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cf0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802cf3:	01 d0                	add    %edx,%eax
  802cf5:	48                   	dec    %eax
  802cf6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802cf9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cfc:	ba 00 00 00 00       	mov    $0x0,%edx
  802d01:	f7 75 b8             	divl   -0x48(%ebp)
  802d04:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d07:	29 d0                	sub    %edx,%eax
  802d09:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d0c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d0f:	01 d0                	add    %edx,%eax
  802d11:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802d16:	a1 44 50 80 00       	mov    0x805044,%eax
  802d1b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	68 78 45 80 00       	push   $0x804578
  802d29:	e8 5c d6 ff ff       	call   80038a <cprintf>
  802d2e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d31:	83 ec 08             	sub    $0x8,%esp
  802d34:	ff 75 bc             	pushl  -0x44(%ebp)
  802d37:	68 7d 45 80 00       	push   $0x80457d
  802d3c:	e8 49 d6 ff ff       	call   80038a <cprintf>
  802d41:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d44:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d4b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d51:	01 d0                	add    %edx,%eax
  802d53:	48                   	dec    %eax
  802d54:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d57:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d5a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d5f:	f7 75 b0             	divl   -0x50(%ebp)
  802d62:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d65:	29 d0                	sub    %edx,%eax
  802d67:	83 ec 04             	sub    $0x4,%esp
  802d6a:	6a 01                	push   $0x1
  802d6c:	50                   	push   %eax
  802d6d:	ff 75 bc             	pushl  -0x44(%ebp)
  802d70:	e8 51 f5 ff ff       	call   8022c6 <set_block_data>
  802d75:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d78:	83 ec 0c             	sub    $0xc,%esp
  802d7b:	ff 75 bc             	pushl  -0x44(%ebp)
  802d7e:	e8 36 04 00 00       	call   8031b9 <free_block>
  802d83:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d86:	83 ec 0c             	sub    $0xc,%esp
  802d89:	ff 75 08             	pushl  0x8(%ebp)
  802d8c:	e8 20 fa ff ff       	call   8027b1 <alloc_block_BF>
  802d91:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d94:	c9                   	leave  
  802d95:	c3                   	ret    

00802d96 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d96:	55                   	push   %ebp
  802d97:	89 e5                	mov    %esp,%ebp
  802d99:	53                   	push   %ebx
  802d9a:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802da4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802dab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802daf:	74 1e                	je     802dcf <merging+0x39>
  802db1:	ff 75 08             	pushl  0x8(%ebp)
  802db4:	e8 bc f1 ff ff       	call   801f75 <get_block_size>
  802db9:	83 c4 04             	add    $0x4,%esp
  802dbc:	89 c2                	mov    %eax,%edx
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	01 d0                	add    %edx,%eax
  802dc3:	3b 45 10             	cmp    0x10(%ebp),%eax
  802dc6:	75 07                	jne    802dcf <merging+0x39>
		prev_is_free = 1;
  802dc8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802dcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dd3:	74 1e                	je     802df3 <merging+0x5d>
  802dd5:	ff 75 10             	pushl  0x10(%ebp)
  802dd8:	e8 98 f1 ff ff       	call   801f75 <get_block_size>
  802ddd:	83 c4 04             	add    $0x4,%esp
  802de0:	89 c2                	mov    %eax,%edx
  802de2:	8b 45 10             	mov    0x10(%ebp),%eax
  802de5:	01 d0                	add    %edx,%eax
  802de7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dea:	75 07                	jne    802df3 <merging+0x5d>
		next_is_free = 1;
  802dec:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df7:	0f 84 cc 00 00 00    	je     802ec9 <merging+0x133>
  802dfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e01:	0f 84 c2 00 00 00    	je     802ec9 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e07:	ff 75 08             	pushl  0x8(%ebp)
  802e0a:	e8 66 f1 ff ff       	call   801f75 <get_block_size>
  802e0f:	83 c4 04             	add    $0x4,%esp
  802e12:	89 c3                	mov    %eax,%ebx
  802e14:	ff 75 10             	pushl  0x10(%ebp)
  802e17:	e8 59 f1 ff ff       	call   801f75 <get_block_size>
  802e1c:	83 c4 04             	add    $0x4,%esp
  802e1f:	01 c3                	add    %eax,%ebx
  802e21:	ff 75 0c             	pushl  0xc(%ebp)
  802e24:	e8 4c f1 ff ff       	call   801f75 <get_block_size>
  802e29:	83 c4 04             	add    $0x4,%esp
  802e2c:	01 d8                	add    %ebx,%eax
  802e2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e31:	6a 00                	push   $0x0
  802e33:	ff 75 ec             	pushl  -0x14(%ebp)
  802e36:	ff 75 08             	pushl  0x8(%ebp)
  802e39:	e8 88 f4 ff ff       	call   8022c6 <set_block_data>
  802e3e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e45:	75 17                	jne    802e5e <merging+0xc8>
  802e47:	83 ec 04             	sub    $0x4,%esp
  802e4a:	68 b3 44 80 00       	push   $0x8044b3
  802e4f:	68 7d 01 00 00       	push   $0x17d
  802e54:	68 d1 44 80 00       	push   $0x8044d1
  802e59:	e8 ec 0b 00 00       	call   803a4a <_panic>
  802e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e61:	8b 00                	mov    (%eax),%eax
  802e63:	85 c0                	test   %eax,%eax
  802e65:	74 10                	je     802e77 <merging+0xe1>
  802e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e6f:	8b 52 04             	mov    0x4(%edx),%edx
  802e72:	89 50 04             	mov    %edx,0x4(%eax)
  802e75:	eb 0b                	jmp    802e82 <merging+0xec>
  802e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7a:	8b 40 04             	mov    0x4(%eax),%eax
  802e7d:	a3 34 50 80 00       	mov    %eax,0x805034
  802e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e85:	8b 40 04             	mov    0x4(%eax),%eax
  802e88:	85 c0                	test   %eax,%eax
  802e8a:	74 0f                	je     802e9b <merging+0x105>
  802e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8f:	8b 40 04             	mov    0x4(%eax),%eax
  802e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e95:	8b 12                	mov    (%edx),%edx
  802e97:	89 10                	mov    %edx,(%eax)
  802e99:	eb 0a                	jmp    802ea5 <merging+0x10f>
  802e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9e:	8b 00                	mov    (%eax),%eax
  802ea0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb8:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ebd:	48                   	dec    %eax
  802ebe:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ec3:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ec4:	e9 ea 02 00 00       	jmp    8031b3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ec9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecd:	74 3b                	je     802f0a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ecf:	83 ec 0c             	sub    $0xc,%esp
  802ed2:	ff 75 08             	pushl  0x8(%ebp)
  802ed5:	e8 9b f0 ff ff       	call   801f75 <get_block_size>
  802eda:	83 c4 10             	add    $0x10,%esp
  802edd:	89 c3                	mov    %eax,%ebx
  802edf:	83 ec 0c             	sub    $0xc,%esp
  802ee2:	ff 75 10             	pushl  0x10(%ebp)
  802ee5:	e8 8b f0 ff ff       	call   801f75 <get_block_size>
  802eea:	83 c4 10             	add    $0x10,%esp
  802eed:	01 d8                	add    %ebx,%eax
  802eef:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ef2:	83 ec 04             	sub    $0x4,%esp
  802ef5:	6a 00                	push   $0x0
  802ef7:	ff 75 e8             	pushl  -0x18(%ebp)
  802efa:	ff 75 08             	pushl  0x8(%ebp)
  802efd:	e8 c4 f3 ff ff       	call   8022c6 <set_block_data>
  802f02:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f05:	e9 a9 02 00 00       	jmp    8031b3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f0e:	0f 84 2d 01 00 00    	je     803041 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f14:	83 ec 0c             	sub    $0xc,%esp
  802f17:	ff 75 10             	pushl  0x10(%ebp)
  802f1a:	e8 56 f0 ff ff       	call   801f75 <get_block_size>
  802f1f:	83 c4 10             	add    $0x10,%esp
  802f22:	89 c3                	mov    %eax,%ebx
  802f24:	83 ec 0c             	sub    $0xc,%esp
  802f27:	ff 75 0c             	pushl  0xc(%ebp)
  802f2a:	e8 46 f0 ff ff       	call   801f75 <get_block_size>
  802f2f:	83 c4 10             	add    $0x10,%esp
  802f32:	01 d8                	add    %ebx,%eax
  802f34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f37:	83 ec 04             	sub    $0x4,%esp
  802f3a:	6a 00                	push   $0x0
  802f3c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f3f:	ff 75 10             	pushl  0x10(%ebp)
  802f42:	e8 7f f3 ff ff       	call   8022c6 <set_block_data>
  802f47:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  802f4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f54:	74 06                	je     802f5c <merging+0x1c6>
  802f56:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f5a:	75 17                	jne    802f73 <merging+0x1dd>
  802f5c:	83 ec 04             	sub    $0x4,%esp
  802f5f:	68 8c 45 80 00       	push   $0x80458c
  802f64:	68 8d 01 00 00       	push   $0x18d
  802f69:	68 d1 44 80 00       	push   $0x8044d1
  802f6e:	e8 d7 0a 00 00       	call   803a4a <_panic>
  802f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f76:	8b 50 04             	mov    0x4(%eax),%edx
  802f79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f7c:	89 50 04             	mov    %edx,0x4(%eax)
  802f7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f82:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f85:	89 10                	mov    %edx,(%eax)
  802f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	74 0d                	je     802f9e <merging+0x208>
  802f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f94:	8b 40 04             	mov    0x4(%eax),%eax
  802f97:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f9a:	89 10                	mov    %edx,(%eax)
  802f9c:	eb 08                	jmp    802fa6 <merging+0x210>
  802f9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa1:	a3 30 50 80 00       	mov    %eax,0x805030
  802fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fac:	89 50 04             	mov    %edx,0x4(%eax)
  802faf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fb4:	40                   	inc    %eax
  802fb5:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  802fba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fbe:	75 17                	jne    802fd7 <merging+0x241>
  802fc0:	83 ec 04             	sub    $0x4,%esp
  802fc3:	68 b3 44 80 00       	push   $0x8044b3
  802fc8:	68 8e 01 00 00       	push   $0x18e
  802fcd:	68 d1 44 80 00       	push   $0x8044d1
  802fd2:	e8 73 0a 00 00       	call   803a4a <_panic>
  802fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fda:	8b 00                	mov    (%eax),%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 10                	je     802ff0 <merging+0x25a>
  802fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe8:	8b 52 04             	mov    0x4(%edx),%edx
  802feb:	89 50 04             	mov    %edx,0x4(%eax)
  802fee:	eb 0b                	jmp    802ffb <merging+0x265>
  802ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff3:	8b 40 04             	mov    0x4(%eax),%eax
  802ff6:	a3 34 50 80 00       	mov    %eax,0x805034
  802ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffe:	8b 40 04             	mov    0x4(%eax),%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	74 0f                	je     803014 <merging+0x27e>
  803005:	8b 45 0c             	mov    0xc(%ebp),%eax
  803008:	8b 40 04             	mov    0x4(%eax),%eax
  80300b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80300e:	8b 12                	mov    (%edx),%edx
  803010:	89 10                	mov    %edx,(%eax)
  803012:	eb 0a                	jmp    80301e <merging+0x288>
  803014:	8b 45 0c             	mov    0xc(%ebp),%eax
  803017:	8b 00                	mov    (%eax),%eax
  803019:	a3 30 50 80 00       	mov    %eax,0x805030
  80301e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803021:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803031:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803036:	48                   	dec    %eax
  803037:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80303c:	e9 72 01 00 00       	jmp    8031b3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  803041:	8b 45 10             	mov    0x10(%ebp),%eax
  803044:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803047:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304b:	74 79                	je     8030c6 <merging+0x330>
  80304d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803051:	74 73                	je     8030c6 <merging+0x330>
  803053:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803057:	74 06                	je     80305f <merging+0x2c9>
  803059:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80305d:	75 17                	jne    803076 <merging+0x2e0>
  80305f:	83 ec 04             	sub    $0x4,%esp
  803062:	68 44 45 80 00       	push   $0x804544
  803067:	68 94 01 00 00       	push   $0x194
  80306c:	68 d1 44 80 00       	push   $0x8044d1
  803071:	e8 d4 09 00 00       	call   803a4a <_panic>
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	8b 10                	mov    (%eax),%edx
  80307b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307e:	89 10                	mov    %edx,(%eax)
  803080:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803083:	8b 00                	mov    (%eax),%eax
  803085:	85 c0                	test   %eax,%eax
  803087:	74 0b                	je     803094 <merging+0x2fe>
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	8b 00                	mov    (%eax),%eax
  80308e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803091:	89 50 04             	mov    %edx,0x4(%eax)
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80309a:	89 10                	mov    %edx,(%eax)
  80309c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309f:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a2:	89 50 04             	mov    %edx,0x4(%eax)
  8030a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a8:	8b 00                	mov    (%eax),%eax
  8030aa:	85 c0                	test   %eax,%eax
  8030ac:	75 08                	jne    8030b6 <merging+0x320>
  8030ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b1:	a3 34 50 80 00       	mov    %eax,0x805034
  8030b6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030bb:	40                   	inc    %eax
  8030bc:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8030c1:	e9 ce 00 00 00       	jmp    803194 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  8030c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ca:	74 65                	je     803131 <merging+0x39b>
  8030cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030d0:	75 17                	jne    8030e9 <merging+0x353>
  8030d2:	83 ec 04             	sub    $0x4,%esp
  8030d5:	68 20 45 80 00       	push   $0x804520
  8030da:	68 95 01 00 00       	push   $0x195
  8030df:	68 d1 44 80 00       	push   $0x8044d1
  8030e4:	e8 61 09 00 00       	call   803a4a <_panic>
  8030e9:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8030ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f2:	89 50 04             	mov    %edx,0x4(%eax)
  8030f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f8:	8b 40 04             	mov    0x4(%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 0c                	je     80310b <merging+0x375>
  8030ff:	a1 34 50 80 00       	mov    0x805034,%eax
  803104:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803107:	89 10                	mov    %edx,(%eax)
  803109:	eb 08                	jmp    803113 <merging+0x37d>
  80310b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80310e:	a3 30 50 80 00       	mov    %eax,0x805030
  803113:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803116:	a3 34 50 80 00       	mov    %eax,0x805034
  80311b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80311e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803124:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803129:	40                   	inc    %eax
  80312a:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80312f:	eb 63                	jmp    803194 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803131:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803135:	75 17                	jne    80314e <merging+0x3b8>
  803137:	83 ec 04             	sub    $0x4,%esp
  80313a:	68 ec 44 80 00       	push   $0x8044ec
  80313f:	68 98 01 00 00       	push   $0x198
  803144:	68 d1 44 80 00       	push   $0x8044d1
  803149:	e8 fc 08 00 00       	call   803a4a <_panic>
  80314e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803154:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803157:	89 10                	mov    %edx,(%eax)
  803159:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	85 c0                	test   %eax,%eax
  803160:	74 0d                	je     80316f <merging+0x3d9>
  803162:	a1 30 50 80 00       	mov    0x805030,%eax
  803167:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80316a:	89 50 04             	mov    %edx,0x4(%eax)
  80316d:	eb 08                	jmp    803177 <merging+0x3e1>
  80316f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803172:	a3 34 50 80 00       	mov    %eax,0x805034
  803177:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80317a:	a3 30 50 80 00       	mov    %eax,0x805030
  80317f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803182:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803189:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80318e:	40                   	inc    %eax
  80318f:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803194:	83 ec 0c             	sub    $0xc,%esp
  803197:	ff 75 10             	pushl  0x10(%ebp)
  80319a:	e8 d6 ed ff ff       	call   801f75 <get_block_size>
  80319f:	83 c4 10             	add    $0x10,%esp
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	6a 00                	push   $0x0
  8031a7:	50                   	push   %eax
  8031a8:	ff 75 10             	pushl  0x10(%ebp)
  8031ab:	e8 16 f1 ff ff       	call   8022c6 <set_block_data>
  8031b0:	83 c4 10             	add    $0x10,%esp
	}
}
  8031b3:	90                   	nop
  8031b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031b7:	c9                   	leave  
  8031b8:	c3                   	ret    

008031b9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031b9:	55                   	push   %ebp
  8031ba:	89 e5                	mov    %esp,%ebp
  8031bc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031bf:	a1 30 50 80 00       	mov    0x805030,%eax
  8031c4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8031c7:	a1 34 50 80 00       	mov    0x805034,%eax
  8031cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031cf:	73 1b                	jae    8031ec <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8031d1:	a1 34 50 80 00       	mov    0x805034,%eax
  8031d6:	83 ec 04             	sub    $0x4,%esp
  8031d9:	ff 75 08             	pushl  0x8(%ebp)
  8031dc:	6a 00                	push   $0x0
  8031de:	50                   	push   %eax
  8031df:	e8 b2 fb ff ff       	call   802d96 <merging>
  8031e4:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031e7:	e9 8b 00 00 00       	jmp    803277 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031ec:	a1 30 50 80 00       	mov    0x805030,%eax
  8031f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f4:	76 18                	jbe    80320e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031f6:	a1 30 50 80 00       	mov    0x805030,%eax
  8031fb:	83 ec 04             	sub    $0x4,%esp
  8031fe:	ff 75 08             	pushl  0x8(%ebp)
  803201:	50                   	push   %eax
  803202:	6a 00                	push   $0x0
  803204:	e8 8d fb ff ff       	call   802d96 <merging>
  803209:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80320c:	eb 69                	jmp    803277 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80320e:	a1 30 50 80 00       	mov    0x805030,%eax
  803213:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803216:	eb 39                	jmp    803251 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80321e:	73 29                	jae    803249 <free_block+0x90>
  803220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803223:	8b 00                	mov    (%eax),%eax
  803225:	3b 45 08             	cmp    0x8(%ebp),%eax
  803228:	76 1f                	jbe    803249 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80322a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803232:	83 ec 04             	sub    $0x4,%esp
  803235:	ff 75 08             	pushl  0x8(%ebp)
  803238:	ff 75 f0             	pushl  -0x10(%ebp)
  80323b:	ff 75 f4             	pushl  -0xc(%ebp)
  80323e:	e8 53 fb ff ff       	call   802d96 <merging>
  803243:	83 c4 10             	add    $0x10,%esp
			break;
  803246:	90                   	nop
		}
	}
}
  803247:	eb 2e                	jmp    803277 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803249:	a1 38 50 80 00       	mov    0x805038,%eax
  80324e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803251:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803255:	74 07                	je     80325e <free_block+0xa5>
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	eb 05                	jmp    803263 <free_block+0xaa>
  80325e:	b8 00 00 00 00       	mov    $0x0,%eax
  803263:	a3 38 50 80 00       	mov    %eax,0x805038
  803268:	a1 38 50 80 00       	mov    0x805038,%eax
  80326d:	85 c0                	test   %eax,%eax
  80326f:	75 a7                	jne    803218 <free_block+0x5f>
  803271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803275:	75 a1                	jne    803218 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803277:	90                   	nop
  803278:	c9                   	leave  
  803279:	c3                   	ret    

0080327a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80327a:	55                   	push   %ebp
  80327b:	89 e5                	mov    %esp,%ebp
  80327d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803280:	ff 75 08             	pushl  0x8(%ebp)
  803283:	e8 ed ec ff ff       	call   801f75 <get_block_size>
  803288:	83 c4 04             	add    $0x4,%esp
  80328b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80328e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803295:	eb 17                	jmp    8032ae <copy_data+0x34>
  803297:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80329a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329d:	01 c2                	add    %eax,%edx
  80329f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a5:	01 c8                	add    %ecx,%eax
  8032a7:	8a 00                	mov    (%eax),%al
  8032a9:	88 02                	mov    %al,(%edx)
  8032ab:	ff 45 fc             	incl   -0x4(%ebp)
  8032ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032b4:	72 e1                	jb     803297 <copy_data+0x1d>
}
  8032b6:	90                   	nop
  8032b7:	c9                   	leave  
  8032b8:	c3                   	ret    

008032b9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032b9:	55                   	push   %ebp
  8032ba:	89 e5                	mov    %esp,%ebp
  8032bc:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c3:	75 23                	jne    8032e8 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8032c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032c9:	74 13                	je     8032de <realloc_block_FF+0x25>
  8032cb:	83 ec 0c             	sub    $0xc,%esp
  8032ce:	ff 75 0c             	pushl  0xc(%ebp)
  8032d1:	e8 1f f0 ff ff       	call   8022f5 <alloc_block_FF>
  8032d6:	83 c4 10             	add    $0x10,%esp
  8032d9:	e9 f4 06 00 00       	jmp    8039d2 <realloc_block_FF+0x719>
		return NULL;
  8032de:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e3:	e9 ea 06 00 00       	jmp    8039d2 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8032e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032ec:	75 18                	jne    803306 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032ee:	83 ec 0c             	sub    $0xc,%esp
  8032f1:	ff 75 08             	pushl  0x8(%ebp)
  8032f4:	e8 c0 fe ff ff       	call   8031b9 <free_block>
  8032f9:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803301:	e9 cc 06 00 00       	jmp    8039d2 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803306:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80330a:	77 07                	ja     803313 <realloc_block_FF+0x5a>
  80330c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803313:	8b 45 0c             	mov    0xc(%ebp),%eax
  803316:	83 e0 01             	and    $0x1,%eax
  803319:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80331c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80331f:	83 c0 08             	add    $0x8,%eax
  803322:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803325:	83 ec 0c             	sub    $0xc,%esp
  803328:	ff 75 08             	pushl  0x8(%ebp)
  80332b:	e8 45 ec ff ff       	call   801f75 <get_block_size>
  803330:	83 c4 10             	add    $0x10,%esp
  803333:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803336:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803339:	83 e8 08             	sub    $0x8,%eax
  80333c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	83 e8 04             	sub    $0x4,%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	83 e0 fe             	and    $0xfffffffe,%eax
  80334a:	89 c2                	mov    %eax,%edx
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	01 d0                	add    %edx,%eax
  803351:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803354:	83 ec 0c             	sub    $0xc,%esp
  803357:	ff 75 e4             	pushl  -0x1c(%ebp)
  80335a:	e8 16 ec ff ff       	call   801f75 <get_block_size>
  80335f:	83 c4 10             	add    $0x10,%esp
  803362:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803365:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803368:	83 e8 08             	sub    $0x8,%eax
  80336b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80336e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803371:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803374:	75 08                	jne    80337e <realloc_block_FF+0xc5>
	{
		 return va;
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	e9 54 06 00 00       	jmp    8039d2 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80337e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803381:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803384:	0f 83 e5 03 00 00    	jae    80376f <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803390:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803393:	83 ec 0c             	sub    $0xc,%esp
  803396:	ff 75 e4             	pushl  -0x1c(%ebp)
  803399:	e8 f0 eb ff ff       	call   801f8e <is_free_block>
  80339e:	83 c4 10             	add    $0x10,%esp
  8033a1:	84 c0                	test   %al,%al
  8033a3:	0f 84 3b 01 00 00    	je     8034e4 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033af:	01 d0                	add    %edx,%eax
  8033b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033b4:	83 ec 04             	sub    $0x4,%esp
  8033b7:	6a 01                	push   $0x1
  8033b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8033bc:	ff 75 08             	pushl  0x8(%ebp)
  8033bf:	e8 02 ef ff ff       	call   8022c6 <set_block_data>
  8033c4:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	83 e8 04             	sub    $0x4,%eax
  8033cd:	8b 00                	mov    (%eax),%eax
  8033cf:	83 e0 fe             	and    $0xfffffffe,%eax
  8033d2:	89 c2                	mov    %eax,%edx
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	01 d0                	add    %edx,%eax
  8033d9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033dc:	83 ec 04             	sub    $0x4,%esp
  8033df:	6a 00                	push   $0x0
  8033e1:	ff 75 cc             	pushl  -0x34(%ebp)
  8033e4:	ff 75 c8             	pushl  -0x38(%ebp)
  8033e7:	e8 da ee ff ff       	call   8022c6 <set_block_data>
  8033ec:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033f3:	74 06                	je     8033fb <realloc_block_FF+0x142>
  8033f5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033f9:	75 17                	jne    803412 <realloc_block_FF+0x159>
  8033fb:	83 ec 04             	sub    $0x4,%esp
  8033fe:	68 44 45 80 00       	push   $0x804544
  803403:	68 f6 01 00 00       	push   $0x1f6
  803408:	68 d1 44 80 00       	push   $0x8044d1
  80340d:	e8 38 06 00 00       	call   803a4a <_panic>
  803412:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803415:	8b 10                	mov    (%eax),%edx
  803417:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80341a:	89 10                	mov    %edx,(%eax)
  80341c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80341f:	8b 00                	mov    (%eax),%eax
  803421:	85 c0                	test   %eax,%eax
  803423:	74 0b                	je     803430 <realloc_block_FF+0x177>
  803425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803428:	8b 00                	mov    (%eax),%eax
  80342a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80342d:	89 50 04             	mov    %edx,0x4(%eax)
  803430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803433:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803436:	89 10                	mov    %edx,(%eax)
  803438:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80343b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80343e:	89 50 04             	mov    %edx,0x4(%eax)
  803441:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	85 c0                	test   %eax,%eax
  803448:	75 08                	jne    803452 <realloc_block_FF+0x199>
  80344a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80344d:	a3 34 50 80 00       	mov    %eax,0x805034
  803452:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803457:	40                   	inc    %eax
  803458:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80345d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803461:	75 17                	jne    80347a <realloc_block_FF+0x1c1>
  803463:	83 ec 04             	sub    $0x4,%esp
  803466:	68 b3 44 80 00       	push   $0x8044b3
  80346b:	68 f7 01 00 00       	push   $0x1f7
  803470:	68 d1 44 80 00       	push   $0x8044d1
  803475:	e8 d0 05 00 00       	call   803a4a <_panic>
  80347a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	74 10                	je     803493 <realloc_block_FF+0x1da>
  803483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803486:	8b 00                	mov    (%eax),%eax
  803488:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348b:	8b 52 04             	mov    0x4(%edx),%edx
  80348e:	89 50 04             	mov    %edx,0x4(%eax)
  803491:	eb 0b                	jmp    80349e <realloc_block_FF+0x1e5>
  803493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803496:	8b 40 04             	mov    0x4(%eax),%eax
  803499:	a3 34 50 80 00       	mov    %eax,0x805034
  80349e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a1:	8b 40 04             	mov    0x4(%eax),%eax
  8034a4:	85 c0                	test   %eax,%eax
  8034a6:	74 0f                	je     8034b7 <realloc_block_FF+0x1fe>
  8034a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ab:	8b 40 04             	mov    0x4(%eax),%eax
  8034ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034b1:	8b 12                	mov    (%edx),%edx
  8034b3:	89 10                	mov    %edx,(%eax)
  8034b5:	eb 0a                	jmp    8034c1 <realloc_block_FF+0x208>
  8034b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8034c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034d9:	48                   	dec    %eax
  8034da:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8034df:	e9 83 02 00 00       	jmp    803767 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8034e4:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034e8:	0f 86 69 02 00 00    	jbe    803757 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034ee:	83 ec 04             	sub    $0x4,%esp
  8034f1:	6a 01                	push   $0x1
  8034f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8034f6:	ff 75 08             	pushl  0x8(%ebp)
  8034f9:	e8 c8 ed ff ff       	call   8022c6 <set_block_data>
  8034fe:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	83 e8 04             	sub    $0x4,%eax
  803507:	8b 00                	mov    (%eax),%eax
  803509:	83 e0 fe             	and    $0xfffffffe,%eax
  80350c:	89 c2                	mov    %eax,%edx
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	01 d0                	add    %edx,%eax
  803513:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803516:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80351b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80351e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803522:	75 68                	jne    80358c <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803524:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803528:	75 17                	jne    803541 <realloc_block_FF+0x288>
  80352a:	83 ec 04             	sub    $0x4,%esp
  80352d:	68 ec 44 80 00       	push   $0x8044ec
  803532:	68 06 02 00 00       	push   $0x206
  803537:	68 d1 44 80 00       	push   $0x8044d1
  80353c:	e8 09 05 00 00       	call   803a4a <_panic>
  803541:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803547:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354a:	89 10                	mov    %edx,(%eax)
  80354c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	85 c0                	test   %eax,%eax
  803553:	74 0d                	je     803562 <realloc_block_FF+0x2a9>
  803555:	a1 30 50 80 00       	mov    0x805030,%eax
  80355a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80355d:	89 50 04             	mov    %edx,0x4(%eax)
  803560:	eb 08                	jmp    80356a <realloc_block_FF+0x2b1>
  803562:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803565:	a3 34 50 80 00       	mov    %eax,0x805034
  80356a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356d:	a3 30 50 80 00       	mov    %eax,0x805030
  803572:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803575:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803581:	40                   	inc    %eax
  803582:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803587:	e9 b0 01 00 00       	jmp    80373c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80358c:	a1 30 50 80 00       	mov    0x805030,%eax
  803591:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803594:	76 68                	jbe    8035fe <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803596:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80359a:	75 17                	jne    8035b3 <realloc_block_FF+0x2fa>
  80359c:	83 ec 04             	sub    $0x4,%esp
  80359f:	68 ec 44 80 00       	push   $0x8044ec
  8035a4:	68 0b 02 00 00       	push   $0x20b
  8035a9:	68 d1 44 80 00       	push   $0x8044d1
  8035ae:	e8 97 04 00 00       	call   803a4a <_panic>
  8035b3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bc:	89 10                	mov    %edx,(%eax)
  8035be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c1:	8b 00                	mov    (%eax),%eax
  8035c3:	85 c0                	test   %eax,%eax
  8035c5:	74 0d                	je     8035d4 <realloc_block_FF+0x31b>
  8035c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8035cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035cf:	89 50 04             	mov    %edx,0x4(%eax)
  8035d2:	eb 08                	jmp    8035dc <realloc_block_FF+0x323>
  8035d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8035dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035df:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035f3:	40                   	inc    %eax
  8035f4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035f9:	e9 3e 01 00 00       	jmp    80373c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035fe:	a1 30 50 80 00       	mov    0x805030,%eax
  803603:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803606:	73 68                	jae    803670 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803608:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80360c:	75 17                	jne    803625 <realloc_block_FF+0x36c>
  80360e:	83 ec 04             	sub    $0x4,%esp
  803611:	68 20 45 80 00       	push   $0x804520
  803616:	68 10 02 00 00       	push   $0x210
  80361b:	68 d1 44 80 00       	push   $0x8044d1
  803620:	e8 25 04 00 00       	call   803a4a <_panic>
  803625:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80362b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362e:	89 50 04             	mov    %edx,0x4(%eax)
  803631:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803634:	8b 40 04             	mov    0x4(%eax),%eax
  803637:	85 c0                	test   %eax,%eax
  803639:	74 0c                	je     803647 <realloc_block_FF+0x38e>
  80363b:	a1 34 50 80 00       	mov    0x805034,%eax
  803640:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803643:	89 10                	mov    %edx,(%eax)
  803645:	eb 08                	jmp    80364f <realloc_block_FF+0x396>
  803647:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364a:	a3 30 50 80 00       	mov    %eax,0x805030
  80364f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803652:	a3 34 50 80 00       	mov    %eax,0x805034
  803657:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80365a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803660:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803665:	40                   	inc    %eax
  803666:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80366b:	e9 cc 00 00 00       	jmp    80373c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803670:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803677:	a1 30 50 80 00       	mov    0x805030,%eax
  80367c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80367f:	e9 8a 00 00 00       	jmp    80370e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803687:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80368a:	73 7a                	jae    803706 <realloc_block_FF+0x44d>
  80368c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368f:	8b 00                	mov    (%eax),%eax
  803691:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803694:	73 70                	jae    803706 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803696:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80369a:	74 06                	je     8036a2 <realloc_block_FF+0x3e9>
  80369c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036a0:	75 17                	jne    8036b9 <realloc_block_FF+0x400>
  8036a2:	83 ec 04             	sub    $0x4,%esp
  8036a5:	68 44 45 80 00       	push   $0x804544
  8036aa:	68 1a 02 00 00       	push   $0x21a
  8036af:	68 d1 44 80 00       	push   $0x8044d1
  8036b4:	e8 91 03 00 00       	call   803a4a <_panic>
  8036b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bc:	8b 10                	mov    (%eax),%edx
  8036be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c1:	89 10                	mov    %edx,(%eax)
  8036c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036c6:	8b 00                	mov    (%eax),%eax
  8036c8:	85 c0                	test   %eax,%eax
  8036ca:	74 0b                	je     8036d7 <realloc_block_FF+0x41e>
  8036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cf:	8b 00                	mov    (%eax),%eax
  8036d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036d4:	89 50 04             	mov    %edx,0x4(%eax)
  8036d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036dd:	89 10                	mov    %edx,(%eax)
  8036df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e5:	89 50 04             	mov    %edx,0x4(%eax)
  8036e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036eb:	8b 00                	mov    (%eax),%eax
  8036ed:	85 c0                	test   %eax,%eax
  8036ef:	75 08                	jne    8036f9 <realloc_block_FF+0x440>
  8036f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036f4:	a3 34 50 80 00       	mov    %eax,0x805034
  8036f9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036fe:	40                   	inc    %eax
  8036ff:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803704:	eb 36                	jmp    80373c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803706:	a1 38 50 80 00       	mov    0x805038,%eax
  80370b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80370e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803712:	74 07                	je     80371b <realloc_block_FF+0x462>
  803714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803717:	8b 00                	mov    (%eax),%eax
  803719:	eb 05                	jmp    803720 <realloc_block_FF+0x467>
  80371b:	b8 00 00 00 00       	mov    $0x0,%eax
  803720:	a3 38 50 80 00       	mov    %eax,0x805038
  803725:	a1 38 50 80 00       	mov    0x805038,%eax
  80372a:	85 c0                	test   %eax,%eax
  80372c:	0f 85 52 ff ff ff    	jne    803684 <realloc_block_FF+0x3cb>
  803732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803736:	0f 85 48 ff ff ff    	jne    803684 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80373c:	83 ec 04             	sub    $0x4,%esp
  80373f:	6a 00                	push   $0x0
  803741:	ff 75 d8             	pushl  -0x28(%ebp)
  803744:	ff 75 d4             	pushl  -0x2c(%ebp)
  803747:	e8 7a eb ff ff       	call   8022c6 <set_block_data>
  80374c:	83 c4 10             	add    $0x10,%esp
				return va;
  80374f:	8b 45 08             	mov    0x8(%ebp),%eax
  803752:	e9 7b 02 00 00       	jmp    8039d2 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803757:	83 ec 0c             	sub    $0xc,%esp
  80375a:	68 c1 45 80 00       	push   $0x8045c1
  80375f:	e8 26 cc ff ff       	call   80038a <cprintf>
  803764:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803767:	8b 45 08             	mov    0x8(%ebp),%eax
  80376a:	e9 63 02 00 00       	jmp    8039d2 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80376f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803772:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803775:	0f 86 4d 02 00 00    	jbe    8039c8 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80377b:	83 ec 0c             	sub    $0xc,%esp
  80377e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803781:	e8 08 e8 ff ff       	call   801f8e <is_free_block>
  803786:	83 c4 10             	add    $0x10,%esp
  803789:	84 c0                	test   %al,%al
  80378b:	0f 84 37 02 00 00    	je     8039c8 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803791:	8b 45 0c             	mov    0xc(%ebp),%eax
  803794:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803797:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80379a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80379d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037a0:	76 38                	jbe    8037da <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037a2:	83 ec 0c             	sub    $0xc,%esp
  8037a5:	ff 75 08             	pushl  0x8(%ebp)
  8037a8:	e8 0c fa ff ff       	call   8031b9 <free_block>
  8037ad:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037b0:	83 ec 0c             	sub    $0xc,%esp
  8037b3:	ff 75 0c             	pushl  0xc(%ebp)
  8037b6:	e8 3a eb ff ff       	call   8022f5 <alloc_block_FF>
  8037bb:	83 c4 10             	add    $0x10,%esp
  8037be:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037c1:	83 ec 08             	sub    $0x8,%esp
  8037c4:	ff 75 c0             	pushl  -0x40(%ebp)
  8037c7:	ff 75 08             	pushl  0x8(%ebp)
  8037ca:	e8 ab fa ff ff       	call   80327a <copy_data>
  8037cf:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8037d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037d5:	e9 f8 01 00 00       	jmp    8039d2 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8037da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037dd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8037e0:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8037e3:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037e7:	0f 87 a0 00 00 00    	ja     80388d <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037f1:	75 17                	jne    80380a <realloc_block_FF+0x551>
  8037f3:	83 ec 04             	sub    $0x4,%esp
  8037f6:	68 b3 44 80 00       	push   $0x8044b3
  8037fb:	68 38 02 00 00       	push   $0x238
  803800:	68 d1 44 80 00       	push   $0x8044d1
  803805:	e8 40 02 00 00       	call   803a4a <_panic>
  80380a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380d:	8b 00                	mov    (%eax),%eax
  80380f:	85 c0                	test   %eax,%eax
  803811:	74 10                	je     803823 <realloc_block_FF+0x56a>
  803813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803816:	8b 00                	mov    (%eax),%eax
  803818:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80381b:	8b 52 04             	mov    0x4(%edx),%edx
  80381e:	89 50 04             	mov    %edx,0x4(%eax)
  803821:	eb 0b                	jmp    80382e <realloc_block_FF+0x575>
  803823:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803826:	8b 40 04             	mov    0x4(%eax),%eax
  803829:	a3 34 50 80 00       	mov    %eax,0x805034
  80382e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803831:	8b 40 04             	mov    0x4(%eax),%eax
  803834:	85 c0                	test   %eax,%eax
  803836:	74 0f                	je     803847 <realloc_block_FF+0x58e>
  803838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383b:	8b 40 04             	mov    0x4(%eax),%eax
  80383e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803841:	8b 12                	mov    (%edx),%edx
  803843:	89 10                	mov    %edx,(%eax)
  803845:	eb 0a                	jmp    803851 <realloc_block_FF+0x598>
  803847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384a:	8b 00                	mov    (%eax),%eax
  80384c:	a3 30 50 80 00       	mov    %eax,0x805030
  803851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803854:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80385a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803864:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803869:	48                   	dec    %eax
  80386a:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80386f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803872:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803875:	01 d0                	add    %edx,%eax
  803877:	83 ec 04             	sub    $0x4,%esp
  80387a:	6a 01                	push   $0x1
  80387c:	50                   	push   %eax
  80387d:	ff 75 08             	pushl  0x8(%ebp)
  803880:	e8 41 ea ff ff       	call   8022c6 <set_block_data>
  803885:	83 c4 10             	add    $0x10,%esp
  803888:	e9 36 01 00 00       	jmp    8039c3 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80388d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803890:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803893:	01 d0                	add    %edx,%eax
  803895:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803898:	83 ec 04             	sub    $0x4,%esp
  80389b:	6a 01                	push   $0x1
  80389d:	ff 75 f0             	pushl  -0x10(%ebp)
  8038a0:	ff 75 08             	pushl  0x8(%ebp)
  8038a3:	e8 1e ea ff ff       	call   8022c6 <set_block_data>
  8038a8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ae:	83 e8 04             	sub    $0x4,%eax
  8038b1:	8b 00                	mov    (%eax),%eax
  8038b3:	83 e0 fe             	and    $0xfffffffe,%eax
  8038b6:	89 c2                	mov    %eax,%edx
  8038b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bb:	01 d0                	add    %edx,%eax
  8038bd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038c4:	74 06                	je     8038cc <realloc_block_FF+0x613>
  8038c6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8038ca:	75 17                	jne    8038e3 <realloc_block_FF+0x62a>
  8038cc:	83 ec 04             	sub    $0x4,%esp
  8038cf:	68 44 45 80 00       	push   $0x804544
  8038d4:	68 44 02 00 00       	push   $0x244
  8038d9:	68 d1 44 80 00       	push   $0x8044d1
  8038de:	e8 67 01 00 00       	call   803a4a <_panic>
  8038e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e6:	8b 10                	mov    (%eax),%edx
  8038e8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038eb:	89 10                	mov    %edx,(%eax)
  8038ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038f0:	8b 00                	mov    (%eax),%eax
  8038f2:	85 c0                	test   %eax,%eax
  8038f4:	74 0b                	je     803901 <realloc_block_FF+0x648>
  8038f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f9:	8b 00                	mov    (%eax),%eax
  8038fb:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038fe:	89 50 04             	mov    %edx,0x4(%eax)
  803901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803904:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803907:	89 10                	mov    %edx,(%eax)
  803909:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80390c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80390f:	89 50 04             	mov    %edx,0x4(%eax)
  803912:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803915:	8b 00                	mov    (%eax),%eax
  803917:	85 c0                	test   %eax,%eax
  803919:	75 08                	jne    803923 <realloc_block_FF+0x66a>
  80391b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80391e:	a3 34 50 80 00       	mov    %eax,0x805034
  803923:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803928:	40                   	inc    %eax
  803929:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80392e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803932:	75 17                	jne    80394b <realloc_block_FF+0x692>
  803934:	83 ec 04             	sub    $0x4,%esp
  803937:	68 b3 44 80 00       	push   $0x8044b3
  80393c:	68 45 02 00 00       	push   $0x245
  803941:	68 d1 44 80 00       	push   $0x8044d1
  803946:	e8 ff 00 00 00       	call   803a4a <_panic>
  80394b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394e:	8b 00                	mov    (%eax),%eax
  803950:	85 c0                	test   %eax,%eax
  803952:	74 10                	je     803964 <realloc_block_FF+0x6ab>
  803954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803957:	8b 00                	mov    (%eax),%eax
  803959:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80395c:	8b 52 04             	mov    0x4(%edx),%edx
  80395f:	89 50 04             	mov    %edx,0x4(%eax)
  803962:	eb 0b                	jmp    80396f <realloc_block_FF+0x6b6>
  803964:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803967:	8b 40 04             	mov    0x4(%eax),%eax
  80396a:	a3 34 50 80 00       	mov    %eax,0x805034
  80396f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803972:	8b 40 04             	mov    0x4(%eax),%eax
  803975:	85 c0                	test   %eax,%eax
  803977:	74 0f                	je     803988 <realloc_block_FF+0x6cf>
  803979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397c:	8b 40 04             	mov    0x4(%eax),%eax
  80397f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803982:	8b 12                	mov    (%edx),%edx
  803984:	89 10                	mov    %edx,(%eax)
  803986:	eb 0a                	jmp    803992 <realloc_block_FF+0x6d9>
  803988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398b:	8b 00                	mov    (%eax),%eax
  80398d:	a3 30 50 80 00       	mov    %eax,0x805030
  803992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803995:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80399b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039a5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039aa:	48                   	dec    %eax
  8039ab:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  8039b0:	83 ec 04             	sub    $0x4,%esp
  8039b3:	6a 00                	push   $0x0
  8039b5:	ff 75 bc             	pushl  -0x44(%ebp)
  8039b8:	ff 75 b8             	pushl  -0x48(%ebp)
  8039bb:	e8 06 e9 ff ff       	call   8022c6 <set_block_data>
  8039c0:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8039c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c6:	eb 0a                	jmp    8039d2 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8039c8:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8039cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8039d2:	c9                   	leave  
  8039d3:	c3                   	ret    

008039d4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8039d4:	55                   	push   %ebp
  8039d5:	89 e5                	mov    %esp,%ebp
  8039d7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8039da:	83 ec 04             	sub    $0x4,%esp
  8039dd:	68 c8 45 80 00       	push   $0x8045c8
  8039e2:	68 58 02 00 00       	push   $0x258
  8039e7:	68 d1 44 80 00       	push   $0x8044d1
  8039ec:	e8 59 00 00 00       	call   803a4a <_panic>

008039f1 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039f1:	55                   	push   %ebp
  8039f2:	89 e5                	mov    %esp,%ebp
  8039f4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039f7:	83 ec 04             	sub    $0x4,%esp
  8039fa:	68 f0 45 80 00       	push   $0x8045f0
  8039ff:	68 61 02 00 00       	push   $0x261
  803a04:	68 d1 44 80 00       	push   $0x8044d1
  803a09:	e8 3c 00 00 00       	call   803a4a <_panic>

00803a0e <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  803a0e:	55                   	push   %ebp
  803a0f:	89 e5                	mov    %esp,%ebp
  803a11:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  803a14:	8b 45 08             	mov    0x8(%ebp),%eax
  803a17:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  803a1a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803a1e:	83 ec 0c             	sub    $0xc,%esp
  803a21:	50                   	push   %eax
  803a22:	e8 dd e0 ff ff       	call   801b04 <sys_cputc>
  803a27:	83 c4 10             	add    $0x10,%esp
}
  803a2a:	90                   	nop
  803a2b:	c9                   	leave  
  803a2c:	c3                   	ret    

00803a2d <getchar>:


int
getchar(void)
{
  803a2d:	55                   	push   %ebp
  803a2e:	89 e5                	mov    %esp,%ebp
  803a30:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803a33:	e8 68 df ff ff       	call   8019a0 <sys_cgetc>
  803a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  803a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803a3e:	c9                   	leave  
  803a3f:	c3                   	ret    

00803a40 <iscons>:

int iscons(int fdnum)
{
  803a40:	55                   	push   %ebp
  803a41:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803a43:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a48:	5d                   	pop    %ebp
  803a49:	c3                   	ret    

00803a4a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a4a:	55                   	push   %ebp
  803a4b:	89 e5                	mov    %esp,%ebp
  803a4d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a50:	8d 45 10             	lea    0x10(%ebp),%eax
  803a53:	83 c0 04             	add    $0x4,%eax
  803a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a59:	a1 60 90 18 01       	mov    0x1189060,%eax
  803a5e:	85 c0                	test   %eax,%eax
  803a60:	74 16                	je     803a78 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a62:	a1 60 90 18 01       	mov    0x1189060,%eax
  803a67:	83 ec 08             	sub    $0x8,%esp
  803a6a:	50                   	push   %eax
  803a6b:	68 18 46 80 00       	push   $0x804618
  803a70:	e8 15 c9 ff ff       	call   80038a <cprintf>
  803a75:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803a78:	a1 00 50 80 00       	mov    0x805000,%eax
  803a7d:	ff 75 0c             	pushl  0xc(%ebp)
  803a80:	ff 75 08             	pushl  0x8(%ebp)
  803a83:	50                   	push   %eax
  803a84:	68 1d 46 80 00       	push   $0x80461d
  803a89:	e8 fc c8 ff ff       	call   80038a <cprintf>
  803a8e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a91:	8b 45 10             	mov    0x10(%ebp),%eax
  803a94:	83 ec 08             	sub    $0x8,%esp
  803a97:	ff 75 f4             	pushl  -0xc(%ebp)
  803a9a:	50                   	push   %eax
  803a9b:	e8 7f c8 ff ff       	call   80031f <vcprintf>
  803aa0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803aa3:	83 ec 08             	sub    $0x8,%esp
  803aa6:	6a 00                	push   $0x0
  803aa8:	68 39 46 80 00       	push   $0x804639
  803aad:	e8 6d c8 ff ff       	call   80031f <vcprintf>
  803ab2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803ab5:	e8 ee c7 ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  803aba:	eb fe                	jmp    803aba <_panic+0x70>

00803abc <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803abc:	55                   	push   %ebp
  803abd:	89 e5                	mov    %esp,%ebp
  803abf:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803ac2:	a1 20 50 80 00       	mov    0x805020,%eax
  803ac7:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ad0:	39 c2                	cmp    %eax,%edx
  803ad2:	74 14                	je     803ae8 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803ad4:	83 ec 04             	sub    $0x4,%esp
  803ad7:	68 3c 46 80 00       	push   $0x80463c
  803adc:	6a 26                	push   $0x26
  803ade:	68 88 46 80 00       	push   $0x804688
  803ae3:	e8 62 ff ff ff       	call   803a4a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803aef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803af6:	e9 c5 00 00 00       	jmp    803bc0 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803afe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b05:	8b 45 08             	mov    0x8(%ebp),%eax
  803b08:	01 d0                	add    %edx,%eax
  803b0a:	8b 00                	mov    (%eax),%eax
  803b0c:	85 c0                	test   %eax,%eax
  803b0e:	75 08                	jne    803b18 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803b10:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803b13:	e9 a5 00 00 00       	jmp    803bbd <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803b18:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b1f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b26:	eb 69                	jmp    803b91 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803b28:	a1 20 50 80 00       	mov    0x805020,%eax
  803b2d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b36:	89 d0                	mov    %edx,%eax
  803b38:	01 c0                	add    %eax,%eax
  803b3a:	01 d0                	add    %edx,%eax
  803b3c:	c1 e0 03             	shl    $0x3,%eax
  803b3f:	01 c8                	add    %ecx,%eax
  803b41:	8a 40 04             	mov    0x4(%eax),%al
  803b44:	84 c0                	test   %al,%al
  803b46:	75 46                	jne    803b8e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b48:	a1 20 50 80 00       	mov    0x805020,%eax
  803b4d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b56:	89 d0                	mov    %edx,%eax
  803b58:	01 c0                	add    %eax,%eax
  803b5a:	01 d0                	add    %edx,%eax
  803b5c:	c1 e0 03             	shl    $0x3,%eax
  803b5f:	01 c8                	add    %ecx,%eax
  803b61:	8b 00                	mov    (%eax),%eax
  803b63:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b6e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b73:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7d:	01 c8                	add    %ecx,%eax
  803b7f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b81:	39 c2                	cmp    %eax,%edx
  803b83:	75 09                	jne    803b8e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b85:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b8c:	eb 15                	jmp    803ba3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b8e:	ff 45 e8             	incl   -0x18(%ebp)
  803b91:	a1 20 50 80 00       	mov    0x805020,%eax
  803b96:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b9f:	39 c2                	cmp    %eax,%edx
  803ba1:	77 85                	ja     803b28 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803ba3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ba7:	75 14                	jne    803bbd <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803ba9:	83 ec 04             	sub    $0x4,%esp
  803bac:	68 94 46 80 00       	push   $0x804694
  803bb1:	6a 3a                	push   $0x3a
  803bb3:	68 88 46 80 00       	push   $0x804688
  803bb8:	e8 8d fe ff ff       	call   803a4a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803bbd:	ff 45 f0             	incl   -0x10(%ebp)
  803bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bc3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803bc6:	0f 8c 2f ff ff ff    	jl     803afb <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803bcc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bd3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803bda:	eb 26                	jmp    803c02 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803bdc:	a1 20 50 80 00       	mov    0x805020,%eax
  803be1:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803be7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bea:	89 d0                	mov    %edx,%eax
  803bec:	01 c0                	add    %eax,%eax
  803bee:	01 d0                	add    %edx,%eax
  803bf0:	c1 e0 03             	shl    $0x3,%eax
  803bf3:	01 c8                	add    %ecx,%eax
  803bf5:	8a 40 04             	mov    0x4(%eax),%al
  803bf8:	3c 01                	cmp    $0x1,%al
  803bfa:	75 03                	jne    803bff <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803bfc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bff:	ff 45 e0             	incl   -0x20(%ebp)
  803c02:	a1 20 50 80 00       	mov    0x805020,%eax
  803c07:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c10:	39 c2                	cmp    %eax,%edx
  803c12:	77 c8                	ja     803bdc <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c17:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c1a:	74 14                	je     803c30 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803c1c:	83 ec 04             	sub    $0x4,%esp
  803c1f:	68 e8 46 80 00       	push   $0x8046e8
  803c24:	6a 44                	push   $0x44
  803c26:	68 88 46 80 00       	push   $0x804688
  803c2b:	e8 1a fe ff ff       	call   803a4a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803c30:	90                   	nop
  803c31:	c9                   	leave  
  803c32:	c3                   	ret    
  803c33:	90                   	nop

00803c34 <__udivdi3>:
  803c34:	55                   	push   %ebp
  803c35:	57                   	push   %edi
  803c36:	56                   	push   %esi
  803c37:	53                   	push   %ebx
  803c38:	83 ec 1c             	sub    $0x1c,%esp
  803c3b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c3f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c4b:	89 ca                	mov    %ecx,%edx
  803c4d:	89 f8                	mov    %edi,%eax
  803c4f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c53:	85 f6                	test   %esi,%esi
  803c55:	75 2d                	jne    803c84 <__udivdi3+0x50>
  803c57:	39 cf                	cmp    %ecx,%edi
  803c59:	77 65                	ja     803cc0 <__udivdi3+0x8c>
  803c5b:	89 fd                	mov    %edi,%ebp
  803c5d:	85 ff                	test   %edi,%edi
  803c5f:	75 0b                	jne    803c6c <__udivdi3+0x38>
  803c61:	b8 01 00 00 00       	mov    $0x1,%eax
  803c66:	31 d2                	xor    %edx,%edx
  803c68:	f7 f7                	div    %edi
  803c6a:	89 c5                	mov    %eax,%ebp
  803c6c:	31 d2                	xor    %edx,%edx
  803c6e:	89 c8                	mov    %ecx,%eax
  803c70:	f7 f5                	div    %ebp
  803c72:	89 c1                	mov    %eax,%ecx
  803c74:	89 d8                	mov    %ebx,%eax
  803c76:	f7 f5                	div    %ebp
  803c78:	89 cf                	mov    %ecx,%edi
  803c7a:	89 fa                	mov    %edi,%edx
  803c7c:	83 c4 1c             	add    $0x1c,%esp
  803c7f:	5b                   	pop    %ebx
  803c80:	5e                   	pop    %esi
  803c81:	5f                   	pop    %edi
  803c82:	5d                   	pop    %ebp
  803c83:	c3                   	ret    
  803c84:	39 ce                	cmp    %ecx,%esi
  803c86:	77 28                	ja     803cb0 <__udivdi3+0x7c>
  803c88:	0f bd fe             	bsr    %esi,%edi
  803c8b:	83 f7 1f             	xor    $0x1f,%edi
  803c8e:	75 40                	jne    803cd0 <__udivdi3+0x9c>
  803c90:	39 ce                	cmp    %ecx,%esi
  803c92:	72 0a                	jb     803c9e <__udivdi3+0x6a>
  803c94:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c98:	0f 87 9e 00 00 00    	ja     803d3c <__udivdi3+0x108>
  803c9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803ca3:	89 fa                	mov    %edi,%edx
  803ca5:	83 c4 1c             	add    $0x1c,%esp
  803ca8:	5b                   	pop    %ebx
  803ca9:	5e                   	pop    %esi
  803caa:	5f                   	pop    %edi
  803cab:	5d                   	pop    %ebp
  803cac:	c3                   	ret    
  803cad:	8d 76 00             	lea    0x0(%esi),%esi
  803cb0:	31 ff                	xor    %edi,%edi
  803cb2:	31 c0                	xor    %eax,%eax
  803cb4:	89 fa                	mov    %edi,%edx
  803cb6:	83 c4 1c             	add    $0x1c,%esp
  803cb9:	5b                   	pop    %ebx
  803cba:	5e                   	pop    %esi
  803cbb:	5f                   	pop    %edi
  803cbc:	5d                   	pop    %ebp
  803cbd:	c3                   	ret    
  803cbe:	66 90                	xchg   %ax,%ax
  803cc0:	89 d8                	mov    %ebx,%eax
  803cc2:	f7 f7                	div    %edi
  803cc4:	31 ff                	xor    %edi,%edi
  803cc6:	89 fa                	mov    %edi,%edx
  803cc8:	83 c4 1c             	add    $0x1c,%esp
  803ccb:	5b                   	pop    %ebx
  803ccc:	5e                   	pop    %esi
  803ccd:	5f                   	pop    %edi
  803cce:	5d                   	pop    %ebp
  803ccf:	c3                   	ret    
  803cd0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803cd5:	89 eb                	mov    %ebp,%ebx
  803cd7:	29 fb                	sub    %edi,%ebx
  803cd9:	89 f9                	mov    %edi,%ecx
  803cdb:	d3 e6                	shl    %cl,%esi
  803cdd:	89 c5                	mov    %eax,%ebp
  803cdf:	88 d9                	mov    %bl,%cl
  803ce1:	d3 ed                	shr    %cl,%ebp
  803ce3:	89 e9                	mov    %ebp,%ecx
  803ce5:	09 f1                	or     %esi,%ecx
  803ce7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ceb:	89 f9                	mov    %edi,%ecx
  803ced:	d3 e0                	shl    %cl,%eax
  803cef:	89 c5                	mov    %eax,%ebp
  803cf1:	89 d6                	mov    %edx,%esi
  803cf3:	88 d9                	mov    %bl,%cl
  803cf5:	d3 ee                	shr    %cl,%esi
  803cf7:	89 f9                	mov    %edi,%ecx
  803cf9:	d3 e2                	shl    %cl,%edx
  803cfb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cff:	88 d9                	mov    %bl,%cl
  803d01:	d3 e8                	shr    %cl,%eax
  803d03:	09 c2                	or     %eax,%edx
  803d05:	89 d0                	mov    %edx,%eax
  803d07:	89 f2                	mov    %esi,%edx
  803d09:	f7 74 24 0c          	divl   0xc(%esp)
  803d0d:	89 d6                	mov    %edx,%esi
  803d0f:	89 c3                	mov    %eax,%ebx
  803d11:	f7 e5                	mul    %ebp
  803d13:	39 d6                	cmp    %edx,%esi
  803d15:	72 19                	jb     803d30 <__udivdi3+0xfc>
  803d17:	74 0b                	je     803d24 <__udivdi3+0xf0>
  803d19:	89 d8                	mov    %ebx,%eax
  803d1b:	31 ff                	xor    %edi,%edi
  803d1d:	e9 58 ff ff ff       	jmp    803c7a <__udivdi3+0x46>
  803d22:	66 90                	xchg   %ax,%ax
  803d24:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d28:	89 f9                	mov    %edi,%ecx
  803d2a:	d3 e2                	shl    %cl,%edx
  803d2c:	39 c2                	cmp    %eax,%edx
  803d2e:	73 e9                	jae    803d19 <__udivdi3+0xe5>
  803d30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d33:	31 ff                	xor    %edi,%edi
  803d35:	e9 40 ff ff ff       	jmp    803c7a <__udivdi3+0x46>
  803d3a:	66 90                	xchg   %ax,%ax
  803d3c:	31 c0                	xor    %eax,%eax
  803d3e:	e9 37 ff ff ff       	jmp    803c7a <__udivdi3+0x46>
  803d43:	90                   	nop

00803d44 <__umoddi3>:
  803d44:	55                   	push   %ebp
  803d45:	57                   	push   %edi
  803d46:	56                   	push   %esi
  803d47:	53                   	push   %ebx
  803d48:	83 ec 1c             	sub    $0x1c,%esp
  803d4b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d57:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d63:	89 f3                	mov    %esi,%ebx
  803d65:	89 fa                	mov    %edi,%edx
  803d67:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d6b:	89 34 24             	mov    %esi,(%esp)
  803d6e:	85 c0                	test   %eax,%eax
  803d70:	75 1a                	jne    803d8c <__umoddi3+0x48>
  803d72:	39 f7                	cmp    %esi,%edi
  803d74:	0f 86 a2 00 00 00    	jbe    803e1c <__umoddi3+0xd8>
  803d7a:	89 c8                	mov    %ecx,%eax
  803d7c:	89 f2                	mov    %esi,%edx
  803d7e:	f7 f7                	div    %edi
  803d80:	89 d0                	mov    %edx,%eax
  803d82:	31 d2                	xor    %edx,%edx
  803d84:	83 c4 1c             	add    $0x1c,%esp
  803d87:	5b                   	pop    %ebx
  803d88:	5e                   	pop    %esi
  803d89:	5f                   	pop    %edi
  803d8a:	5d                   	pop    %ebp
  803d8b:	c3                   	ret    
  803d8c:	39 f0                	cmp    %esi,%eax
  803d8e:	0f 87 ac 00 00 00    	ja     803e40 <__umoddi3+0xfc>
  803d94:	0f bd e8             	bsr    %eax,%ebp
  803d97:	83 f5 1f             	xor    $0x1f,%ebp
  803d9a:	0f 84 ac 00 00 00    	je     803e4c <__umoddi3+0x108>
  803da0:	bf 20 00 00 00       	mov    $0x20,%edi
  803da5:	29 ef                	sub    %ebp,%edi
  803da7:	89 fe                	mov    %edi,%esi
  803da9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803dad:	89 e9                	mov    %ebp,%ecx
  803daf:	d3 e0                	shl    %cl,%eax
  803db1:	89 d7                	mov    %edx,%edi
  803db3:	89 f1                	mov    %esi,%ecx
  803db5:	d3 ef                	shr    %cl,%edi
  803db7:	09 c7                	or     %eax,%edi
  803db9:	89 e9                	mov    %ebp,%ecx
  803dbb:	d3 e2                	shl    %cl,%edx
  803dbd:	89 14 24             	mov    %edx,(%esp)
  803dc0:	89 d8                	mov    %ebx,%eax
  803dc2:	d3 e0                	shl    %cl,%eax
  803dc4:	89 c2                	mov    %eax,%edx
  803dc6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dca:	d3 e0                	shl    %cl,%eax
  803dcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803dd0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803dd4:	89 f1                	mov    %esi,%ecx
  803dd6:	d3 e8                	shr    %cl,%eax
  803dd8:	09 d0                	or     %edx,%eax
  803dda:	d3 eb                	shr    %cl,%ebx
  803ddc:	89 da                	mov    %ebx,%edx
  803dde:	f7 f7                	div    %edi
  803de0:	89 d3                	mov    %edx,%ebx
  803de2:	f7 24 24             	mull   (%esp)
  803de5:	89 c6                	mov    %eax,%esi
  803de7:	89 d1                	mov    %edx,%ecx
  803de9:	39 d3                	cmp    %edx,%ebx
  803deb:	0f 82 87 00 00 00    	jb     803e78 <__umoddi3+0x134>
  803df1:	0f 84 91 00 00 00    	je     803e88 <__umoddi3+0x144>
  803df7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803dfb:	29 f2                	sub    %esi,%edx
  803dfd:	19 cb                	sbb    %ecx,%ebx
  803dff:	89 d8                	mov    %ebx,%eax
  803e01:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e05:	d3 e0                	shl    %cl,%eax
  803e07:	89 e9                	mov    %ebp,%ecx
  803e09:	d3 ea                	shr    %cl,%edx
  803e0b:	09 d0                	or     %edx,%eax
  803e0d:	89 e9                	mov    %ebp,%ecx
  803e0f:	d3 eb                	shr    %cl,%ebx
  803e11:	89 da                	mov    %ebx,%edx
  803e13:	83 c4 1c             	add    $0x1c,%esp
  803e16:	5b                   	pop    %ebx
  803e17:	5e                   	pop    %esi
  803e18:	5f                   	pop    %edi
  803e19:	5d                   	pop    %ebp
  803e1a:	c3                   	ret    
  803e1b:	90                   	nop
  803e1c:	89 fd                	mov    %edi,%ebp
  803e1e:	85 ff                	test   %edi,%edi
  803e20:	75 0b                	jne    803e2d <__umoddi3+0xe9>
  803e22:	b8 01 00 00 00       	mov    $0x1,%eax
  803e27:	31 d2                	xor    %edx,%edx
  803e29:	f7 f7                	div    %edi
  803e2b:	89 c5                	mov    %eax,%ebp
  803e2d:	89 f0                	mov    %esi,%eax
  803e2f:	31 d2                	xor    %edx,%edx
  803e31:	f7 f5                	div    %ebp
  803e33:	89 c8                	mov    %ecx,%eax
  803e35:	f7 f5                	div    %ebp
  803e37:	89 d0                	mov    %edx,%eax
  803e39:	e9 44 ff ff ff       	jmp    803d82 <__umoddi3+0x3e>
  803e3e:	66 90                	xchg   %ax,%ax
  803e40:	89 c8                	mov    %ecx,%eax
  803e42:	89 f2                	mov    %esi,%edx
  803e44:	83 c4 1c             	add    $0x1c,%esp
  803e47:	5b                   	pop    %ebx
  803e48:	5e                   	pop    %esi
  803e49:	5f                   	pop    %edi
  803e4a:	5d                   	pop    %ebp
  803e4b:	c3                   	ret    
  803e4c:	3b 04 24             	cmp    (%esp),%eax
  803e4f:	72 06                	jb     803e57 <__umoddi3+0x113>
  803e51:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e55:	77 0f                	ja     803e66 <__umoddi3+0x122>
  803e57:	89 f2                	mov    %esi,%edx
  803e59:	29 f9                	sub    %edi,%ecx
  803e5b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e5f:	89 14 24             	mov    %edx,(%esp)
  803e62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e66:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e6a:	8b 14 24             	mov    (%esp),%edx
  803e6d:	83 c4 1c             	add    $0x1c,%esp
  803e70:	5b                   	pop    %ebx
  803e71:	5e                   	pop    %esi
  803e72:	5f                   	pop    %edi
  803e73:	5d                   	pop    %ebp
  803e74:	c3                   	ret    
  803e75:	8d 76 00             	lea    0x0(%esi),%esi
  803e78:	2b 04 24             	sub    (%esp),%eax
  803e7b:	19 fa                	sbb    %edi,%edx
  803e7d:	89 d1                	mov    %edx,%ecx
  803e7f:	89 c6                	mov    %eax,%esi
  803e81:	e9 71 ff ff ff       	jmp    803df7 <__umoddi3+0xb3>
  803e86:	66 90                	xchg   %ax,%ax
  803e88:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e8c:	72 ea                	jb     803e78 <__umoddi3+0x134>
  803e8e:	89 d9                	mov    %ebx,%ecx
  803e90:	e9 62 ff ff ff       	jmp    803df7 <__umoddi3+0xb3>
