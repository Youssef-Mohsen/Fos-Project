
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
  800052:	68 80 3d 80 00       	push   $0x803d80
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
  8000bc:	68 9e 3d 80 00       	push   $0x803d9e
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
  8001f3:	68 cc 3d 80 00       	push   $0x803dcc
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
  80021b:	68 f4 3d 80 00       	push   $0x803df4
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
  80024c:	68 1c 3e 80 00       	push   $0x803e1c
  800251:	e8 34 01 00 00       	call   80038a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 74 3e 80 00       	push   $0x803e74
  80026d:	e8 18 01 00 00       	call   80038a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 cc 3d 80 00       	push   $0x803dcc
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
  800427:	e8 e8 36 00 00       	call   803b14 <__udivdi3>
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
  800477:	e8 a8 37 00 00       	call   803c24 <__umoddi3>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	05 b4 40 80 00       	add    $0x8040b4,%eax
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
  8005d2:	8b 04 85 d8 40 80 00 	mov    0x8040d8(,%eax,4),%eax
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
  8006b3:	8b 34 9d 20 3f 80 00 	mov    0x803f20(,%ebx,4),%esi
  8006ba:	85 f6                	test   %esi,%esi
  8006bc:	75 19                	jne    8006d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006be:	53                   	push   %ebx
  8006bf:	68 c5 40 80 00       	push   $0x8040c5
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
  8006d8:	68 ce 40 80 00       	push   $0x8040ce
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
  800705:	be d1 40 80 00       	mov    $0x8040d1,%esi
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
  800a30:	68 48 42 80 00       	push   $0x804248
  800a35:	e8 50 f9 ff ff       	call   80038a <cprintf>
  800a3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a44:	83 ec 0c             	sub    $0xc,%esp
  800a47:	6a 00                	push   $0x0
  800a49:	e8 d2 2e 00 00       	call   803920 <iscons>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a54:	e8 b4 2e 00 00       	call   80390d <getchar>
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
  800a72:	68 4b 42 80 00       	push   $0x80424b
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
  800a9f:	e8 4a 2e 00 00       	call   8038ee <cputchar>
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
  800ad6:	e8 13 2e 00 00       	call   8038ee <cputchar>
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
  800aff:	e8 ea 2d 00 00       	call   8038ee <cputchar>
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
  800b34:	68 48 42 80 00       	push   $0x804248
  800b39:	e8 4c f8 ff ff       	call   80038a <cprintf>
  800b3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b48:	83 ec 0c             	sub    $0xc,%esp
  800b4b:	6a 00                	push   $0x0
  800b4d:	e8 ce 2d 00 00       	call   803920 <iscons>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b58:	e8 b0 2d 00 00       	call   80390d <getchar>
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
  800b76:	68 4b 42 80 00       	push   $0x80424b
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
  800ba3:	e8 46 2d 00 00       	call   8038ee <cputchar>
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
  800bda:	e8 0f 2d 00 00       	call   8038ee <cputchar>
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
  800c03:	e8 e6 2c 00 00       	call   8038ee <cputchar>
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
  801318:	68 5c 42 80 00       	push   $0x80425c
  80131d:	68 3f 01 00 00       	push   $0x13f
  801322:	68 7e 42 80 00       	push   $0x80427e
  801327:	e8 fe 25 00 00       	call   80392a <_panic>

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
  8013c2:	e8 41 0e 00 00       	call   802208 <alloc_block_FF>
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
  8013e5:	e8 da 12 00 00       	call   8026c4 <alloc_block_BF>
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
  801593:	e8 f0 08 00 00       	call   801e88 <get_block_size>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 00 1b 00 00       	call   8030a9 <free_block>
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
  801649:	68 8c 42 80 00       	push   $0x80428c
  80164e:	68 87 00 00 00       	push   $0x87
  801653:	68 b6 42 80 00       	push   $0x8042b6
  801658:	e8 cd 22 00 00       	call   80392a <_panic>
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
  8017f4:	68 c4 42 80 00       	push   $0x8042c4
  8017f9:	68 e4 00 00 00       	push   $0xe4
  8017fe:	68 b6 42 80 00       	push   $0x8042b6
  801803:	e8 22 21 00 00       	call   80392a <_panic>

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
  801811:	68 ea 42 80 00       	push   $0x8042ea
  801816:	68 f0 00 00 00       	push   $0xf0
  80181b:	68 b6 42 80 00       	push   $0x8042b6
  801820:	e8 05 21 00 00       	call   80392a <_panic>

00801825 <shrink>:

}
void shrink(uint32 newSize)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	68 ea 42 80 00       	push   $0x8042ea
  801833:	68 f5 00 00 00       	push   $0xf5
  801838:	68 b6 42 80 00       	push   $0x8042b6
  80183d:	e8 e8 20 00 00       	call   80392a <_panic>

00801842 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	68 ea 42 80 00       	push   $0x8042ea
  801850:	68 fa 00 00 00       	push   $0xfa
  801855:	68 b6 42 80 00       	push   $0x8042b6
  80185a:	e8 cb 20 00 00       	call   80392a <_panic>

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

00801e88 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	83 e8 04             	sub    $0x4,%eax
  801e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e9a:	8b 00                	mov    (%eax),%eax
  801e9c:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	83 e8 04             	sub    $0x4,%eax
  801ead:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eb3:	8b 00                	mov    (%eax),%eax
  801eb5:	83 e0 01             	and    $0x1,%eax
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	0f 94 c0             	sete   %al
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ec5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ecf:	83 f8 02             	cmp    $0x2,%eax
  801ed2:	74 2b                	je     801eff <alloc_block+0x40>
  801ed4:	83 f8 02             	cmp    $0x2,%eax
  801ed7:	7f 07                	jg     801ee0 <alloc_block+0x21>
  801ed9:	83 f8 01             	cmp    $0x1,%eax
  801edc:	74 0e                	je     801eec <alloc_block+0x2d>
  801ede:	eb 58                	jmp    801f38 <alloc_block+0x79>
  801ee0:	83 f8 03             	cmp    $0x3,%eax
  801ee3:	74 2d                	je     801f12 <alloc_block+0x53>
  801ee5:	83 f8 04             	cmp    $0x4,%eax
  801ee8:	74 3b                	je     801f25 <alloc_block+0x66>
  801eea:	eb 4c                	jmp    801f38 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	ff 75 08             	pushl  0x8(%ebp)
  801ef2:	e8 11 03 00 00       	call   802208 <alloc_block_FF>
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801efd:	eb 4a                	jmp    801f49 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801eff:	83 ec 0c             	sub    $0xc,%esp
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	e8 c7 19 00 00       	call   8038d1 <alloc_block_NF>
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f10:	eb 37                	jmp    801f49 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f12:	83 ec 0c             	sub    $0xc,%esp
  801f15:	ff 75 08             	pushl  0x8(%ebp)
  801f18:	e8 a7 07 00 00       	call   8026c4 <alloc_block_BF>
  801f1d:	83 c4 10             	add    $0x10,%esp
  801f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f23:	eb 24                	jmp    801f49 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	ff 75 08             	pushl  0x8(%ebp)
  801f2b:	e8 84 19 00 00       	call   8038b4 <alloc_block_WF>
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f36:	eb 11                	jmp    801f49 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f38:	83 ec 0c             	sub    $0xc,%esp
  801f3b:	68 fc 42 80 00       	push   $0x8042fc
  801f40:	e8 45 e4 ff ff       	call   80038a <cprintf>
  801f45:	83 c4 10             	add    $0x10,%esp
		break;
  801f48:	90                   	nop
	}
	return va;
  801f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	53                   	push   %ebx
  801f52:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	68 1c 43 80 00       	push   $0x80431c
  801f5d:	e8 28 e4 ff ff       	call   80038a <cprintf>
  801f62:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	68 47 43 80 00       	push   $0x804347
  801f6d:	e8 18 e4 ff ff       	call   80038a <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f75:	8b 45 08             	mov    0x8(%ebp),%eax
  801f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7b:	eb 37                	jmp    801fb4 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	ff 75 f4             	pushl  -0xc(%ebp)
  801f83:	e8 19 ff ff ff       	call   801ea1 <is_free_block>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	0f be d8             	movsbl %al,%ebx
  801f8e:	83 ec 0c             	sub    $0xc,%esp
  801f91:	ff 75 f4             	pushl  -0xc(%ebp)
  801f94:	e8 ef fe ff ff       	call   801e88 <get_block_size>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	53                   	push   %ebx
  801fa0:	50                   	push   %eax
  801fa1:	68 5f 43 80 00       	push   $0x80435f
  801fa6:	e8 df e3 ff ff       	call   80038a <cprintf>
  801fab:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fae:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb8:	74 07                	je     801fc1 <print_blocks_list+0x73>
  801fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbd:	8b 00                	mov    (%eax),%eax
  801fbf:	eb 05                	jmp    801fc6 <print_blocks_list+0x78>
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc6:	89 45 10             	mov    %eax,0x10(%ebp)
  801fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	75 ad                	jne    801f7d <print_blocks_list+0x2f>
  801fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd4:	75 a7                	jne    801f7d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	68 1c 43 80 00       	push   $0x80431c
  801fde:	e8 a7 e3 ff ff       	call   80038a <cprintf>
  801fe3:	83 c4 10             	add    $0x10,%esp

}
  801fe6:	90                   	nop
  801fe7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff5:	83 e0 01             	and    $0x1,%eax
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	74 03                	je     801fff <initialize_dynamic_allocator+0x13>
  801ffc:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802003:	0f 84 c7 01 00 00    	je     8021d0 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802009:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802010:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802013:	8b 55 08             	mov    0x8(%ebp),%edx
  802016:	8b 45 0c             	mov    0xc(%ebp),%eax
  802019:	01 d0                	add    %edx,%eax
  80201b:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802020:	0f 87 ad 01 00 00    	ja     8021d3 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	85 c0                	test   %eax,%eax
  80202b:	0f 89 a5 01 00 00    	jns    8021d6 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802031:	8b 55 08             	mov    0x8(%ebp),%edx
  802034:	8b 45 0c             	mov    0xc(%ebp),%eax
  802037:	01 d0                	add    %edx,%eax
  802039:	83 e8 04             	sub    $0x4,%eax
  80203c:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802048:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80204d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802050:	e9 87 00 00 00       	jmp    8020dc <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802055:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802059:	75 14                	jne    80206f <initialize_dynamic_allocator+0x83>
  80205b:	83 ec 04             	sub    $0x4,%esp
  80205e:	68 77 43 80 00       	push   $0x804377
  802063:	6a 79                	push   $0x79
  802065:	68 95 43 80 00       	push   $0x804395
  80206a:	e8 bb 18 00 00       	call   80392a <_panic>
  80206f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802072:	8b 00                	mov    (%eax),%eax
  802074:	85 c0                	test   %eax,%eax
  802076:	74 10                	je     802088 <initialize_dynamic_allocator+0x9c>
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	8b 00                	mov    (%eax),%eax
  80207d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802080:	8b 52 04             	mov    0x4(%edx),%edx
  802083:	89 50 04             	mov    %edx,0x4(%eax)
  802086:	eb 0b                	jmp    802093 <initialize_dynamic_allocator+0xa7>
  802088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208b:	8b 40 04             	mov    0x4(%eax),%eax
  80208e:	a3 30 50 80 00       	mov    %eax,0x805030
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	8b 40 04             	mov    0x4(%eax),%eax
  802099:	85 c0                	test   %eax,%eax
  80209b:	74 0f                	je     8020ac <initialize_dynamic_allocator+0xc0>
  80209d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a0:	8b 40 04             	mov    0x4(%eax),%eax
  8020a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a6:	8b 12                	mov    (%edx),%edx
  8020a8:	89 10                	mov    %edx,(%eax)
  8020aa:	eb 0a                	jmp    8020b6 <initialize_dynamic_allocator+0xca>
  8020ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020af:	8b 00                	mov    (%eax),%eax
  8020b1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8020ce:	48                   	dec    %eax
  8020cf:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8020d4:	a1 34 50 80 00       	mov    0x805034,%eax
  8020d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e0:	74 07                	je     8020e9 <initialize_dynamic_allocator+0xfd>
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 00                	mov    (%eax),%eax
  8020e7:	eb 05                	jmp    8020ee <initialize_dynamic_allocator+0x102>
  8020e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ee:	a3 34 50 80 00       	mov    %eax,0x805034
  8020f3:	a1 34 50 80 00       	mov    0x805034,%eax
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	0f 85 55 ff ff ff    	jne    802055 <initialize_dynamic_allocator+0x69>
  802100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802104:	0f 85 4b ff ff ff    	jne    802055 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802113:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802119:	a1 44 50 80 00       	mov    0x805044,%eax
  80211e:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802123:	a1 40 50 80 00       	mov    0x805040,%eax
  802128:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	83 c0 08             	add    $0x8,%eax
  802134:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	83 c0 04             	add    $0x4,%eax
  80213d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802140:	83 ea 08             	sub    $0x8,%edx
  802143:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802145:	8b 55 0c             	mov    0xc(%ebp),%edx
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	01 d0                	add    %edx,%eax
  80214d:	83 e8 08             	sub    $0x8,%eax
  802150:	8b 55 0c             	mov    0xc(%ebp),%edx
  802153:	83 ea 08             	sub    $0x8,%edx
  802156:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802161:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802164:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80216b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80216f:	75 17                	jne    802188 <initialize_dynamic_allocator+0x19c>
  802171:	83 ec 04             	sub    $0x4,%esp
  802174:	68 b0 43 80 00       	push   $0x8043b0
  802179:	68 90 00 00 00       	push   $0x90
  80217e:	68 95 43 80 00       	push   $0x804395
  802183:	e8 a2 17 00 00       	call   80392a <_panic>
  802188:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80218e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802191:	89 10                	mov    %edx,(%eax)
  802193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802196:	8b 00                	mov    (%eax),%eax
  802198:	85 c0                	test   %eax,%eax
  80219a:	74 0d                	je     8021a9 <initialize_dynamic_allocator+0x1bd>
  80219c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021a4:	89 50 04             	mov    %edx,0x4(%eax)
  8021a7:	eb 08                	jmp    8021b1 <initialize_dynamic_allocator+0x1c5>
  8021a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8021b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8021c8:	40                   	inc    %eax
  8021c9:	a3 38 50 80 00       	mov    %eax,0x805038
  8021ce:	eb 07                	jmp    8021d7 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8021d0:	90                   	nop
  8021d1:	eb 04                	jmp    8021d7 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8021d3:	90                   	nop
  8021d4:	eb 01                	jmp    8021d7 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8021d6:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021df:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021eb:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	83 e8 04             	sub    $0x4,%eax
  8021f3:	8b 00                	mov    (%eax),%eax
  8021f5:	83 e0 fe             	and    $0xfffffffe,%eax
  8021f8:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	01 c2                	add    %eax,%edx
  802200:	8b 45 0c             	mov    0xc(%ebp),%eax
  802203:	89 02                	mov    %eax,(%edx)
}
  802205:	90                   	nop
  802206:	5d                   	pop    %ebp
  802207:	c3                   	ret    

00802208 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	83 e0 01             	and    $0x1,%eax
  802214:	85 c0                	test   %eax,%eax
  802216:	74 03                	je     80221b <alloc_block_FF+0x13>
  802218:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80221b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80221f:	77 07                	ja     802228 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802221:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802228:	a1 24 50 80 00       	mov    0x805024,%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	75 73                	jne    8022a4 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	83 c0 10             	add    $0x10,%eax
  802237:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80223a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802241:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802244:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802247:	01 d0                	add    %edx,%eax
  802249:	48                   	dec    %eax
  80224a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80224d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802250:	ba 00 00 00 00       	mov    $0x0,%edx
  802255:	f7 75 ec             	divl   -0x14(%ebp)
  802258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80225b:	29 d0                	sub    %edx,%eax
  80225d:	c1 e8 0c             	shr    $0xc,%eax
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	50                   	push   %eax
  802264:	e8 c3 f0 ff ff       	call   80132c <sbrk>
  802269:	83 c4 10             	add    $0x10,%esp
  80226c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80226f:	83 ec 0c             	sub    $0xc,%esp
  802272:	6a 00                	push   $0x0
  802274:	e8 b3 f0 ff ff       	call   80132c <sbrk>
  802279:	83 c4 10             	add    $0x10,%esp
  80227c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80227f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802282:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802285:	83 ec 08             	sub    $0x8,%esp
  802288:	50                   	push   %eax
  802289:	ff 75 e4             	pushl  -0x1c(%ebp)
  80228c:	e8 5b fd ff ff       	call   801fec <initialize_dynamic_allocator>
  802291:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802294:	83 ec 0c             	sub    $0xc,%esp
  802297:	68 d3 43 80 00       	push   $0x8043d3
  80229c:	e8 e9 e0 ff ff       	call   80038a <cprintf>
  8022a1:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a8:	75 0a                	jne    8022b4 <alloc_block_FF+0xac>
	        return NULL;
  8022aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022af:	e9 0e 04 00 00       	jmp    8026c2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8022b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022bb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c3:	e9 f3 02 00 00       	jmp    8025bb <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022ce:	83 ec 0c             	sub    $0xc,%esp
  8022d1:	ff 75 bc             	pushl  -0x44(%ebp)
  8022d4:	e8 af fb ff ff       	call   801e88 <get_block_size>
  8022d9:	83 c4 10             	add    $0x10,%esp
  8022dc:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	83 c0 08             	add    $0x8,%eax
  8022e5:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022e8:	0f 87 c5 02 00 00    	ja     8025b3 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	83 c0 18             	add    $0x18,%eax
  8022f4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022f7:	0f 87 19 02 00 00    	ja     802516 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802300:	2b 45 08             	sub    0x8(%ebp),%eax
  802303:	83 e8 08             	sub    $0x8,%eax
  802306:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8d 50 08             	lea    0x8(%eax),%edx
  80230f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802312:	01 d0                	add    %edx,%eax
  802314:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	83 c0 08             	add    $0x8,%eax
  80231d:	83 ec 04             	sub    $0x4,%esp
  802320:	6a 01                	push   $0x1
  802322:	50                   	push   %eax
  802323:	ff 75 bc             	pushl  -0x44(%ebp)
  802326:	e8 ae fe ff ff       	call   8021d9 <set_block_data>
  80232b:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 40 04             	mov    0x4(%eax),%eax
  802334:	85 c0                	test   %eax,%eax
  802336:	75 68                	jne    8023a0 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802338:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80233c:	75 17                	jne    802355 <alloc_block_FF+0x14d>
  80233e:	83 ec 04             	sub    $0x4,%esp
  802341:	68 b0 43 80 00       	push   $0x8043b0
  802346:	68 d7 00 00 00       	push   $0xd7
  80234b:	68 95 43 80 00       	push   $0x804395
  802350:	e8 d5 15 00 00       	call   80392a <_panic>
  802355:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80235b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80235e:	89 10                	mov    %edx,(%eax)
  802360:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	74 0d                	je     802376 <alloc_block_FF+0x16e>
  802369:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80236e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802371:	89 50 04             	mov    %edx,0x4(%eax)
  802374:	eb 08                	jmp    80237e <alloc_block_FF+0x176>
  802376:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802379:	a3 30 50 80 00       	mov    %eax,0x805030
  80237e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802381:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802386:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802389:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802390:	a1 38 50 80 00       	mov    0x805038,%eax
  802395:	40                   	inc    %eax
  802396:	a3 38 50 80 00       	mov    %eax,0x805038
  80239b:	e9 dc 00 00 00       	jmp    80247c <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 00                	mov    (%eax),%eax
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	75 65                	jne    80240e <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023a9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023ad:	75 17                	jne    8023c6 <alloc_block_FF+0x1be>
  8023af:	83 ec 04             	sub    $0x4,%esp
  8023b2:	68 e4 43 80 00       	push   $0x8043e4
  8023b7:	68 db 00 00 00       	push   $0xdb
  8023bc:	68 95 43 80 00       	push   $0x804395
  8023c1:	e8 64 15 00 00       	call   80392a <_panic>
  8023c6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023cf:	89 50 04             	mov    %edx,0x4(%eax)
  8023d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d5:	8b 40 04             	mov    0x4(%eax),%eax
  8023d8:	85 c0                	test   %eax,%eax
  8023da:	74 0c                	je     8023e8 <alloc_block_FF+0x1e0>
  8023dc:	a1 30 50 80 00       	mov    0x805030,%eax
  8023e1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023e4:	89 10                	mov    %edx,(%eax)
  8023e6:	eb 08                	jmp    8023f0 <alloc_block_FF+0x1e8>
  8023e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023eb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8023f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802401:	a1 38 50 80 00       	mov    0x805038,%eax
  802406:	40                   	inc    %eax
  802407:	a3 38 50 80 00       	mov    %eax,0x805038
  80240c:	eb 6e                	jmp    80247c <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80240e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802412:	74 06                	je     80241a <alloc_block_FF+0x212>
  802414:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802418:	75 17                	jne    802431 <alloc_block_FF+0x229>
  80241a:	83 ec 04             	sub    $0x4,%esp
  80241d:	68 08 44 80 00       	push   $0x804408
  802422:	68 df 00 00 00       	push   $0xdf
  802427:	68 95 43 80 00       	push   $0x804395
  80242c:	e8 f9 14 00 00       	call   80392a <_panic>
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 10                	mov    (%eax),%edx
  802436:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802439:	89 10                	mov    %edx,(%eax)
  80243b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	85 c0                	test   %eax,%eax
  802442:	74 0b                	je     80244f <alloc_block_FF+0x247>
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80244c:	89 50 04             	mov    %edx,0x4(%eax)
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802455:	89 10                	mov    %edx,(%eax)
  802457:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245d:	89 50 04             	mov    %edx,0x4(%eax)
  802460:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802463:	8b 00                	mov    (%eax),%eax
  802465:	85 c0                	test   %eax,%eax
  802467:	75 08                	jne    802471 <alloc_block_FF+0x269>
  802469:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246c:	a3 30 50 80 00       	mov    %eax,0x805030
  802471:	a1 38 50 80 00       	mov    0x805038,%eax
  802476:	40                   	inc    %eax
  802477:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80247c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802480:	75 17                	jne    802499 <alloc_block_FF+0x291>
  802482:	83 ec 04             	sub    $0x4,%esp
  802485:	68 77 43 80 00       	push   $0x804377
  80248a:	68 e1 00 00 00       	push   $0xe1
  80248f:	68 95 43 80 00       	push   $0x804395
  802494:	e8 91 14 00 00       	call   80392a <_panic>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	74 10                	je     8024b2 <alloc_block_FF+0x2aa>
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024aa:	8b 52 04             	mov    0x4(%edx),%edx
  8024ad:	89 50 04             	mov    %edx,0x4(%eax)
  8024b0:	eb 0b                	jmp    8024bd <alloc_block_FF+0x2b5>
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 40 04             	mov    0x4(%eax),%eax
  8024b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	74 0f                	je     8024d6 <alloc_block_FF+0x2ce>
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 40 04             	mov    0x4(%eax),%eax
  8024cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d0:	8b 12                	mov    (%edx),%edx
  8024d2:	89 10                	mov    %edx,(%eax)
  8024d4:	eb 0a                	jmp    8024e0 <alloc_block_FF+0x2d8>
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8024f8:	48                   	dec    %eax
  8024f9:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024fe:	83 ec 04             	sub    $0x4,%esp
  802501:	6a 00                	push   $0x0
  802503:	ff 75 b4             	pushl  -0x4c(%ebp)
  802506:	ff 75 b0             	pushl  -0x50(%ebp)
  802509:	e8 cb fc ff ff       	call   8021d9 <set_block_data>
  80250e:	83 c4 10             	add    $0x10,%esp
  802511:	e9 95 00 00 00       	jmp    8025ab <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	6a 01                	push   $0x1
  80251b:	ff 75 b8             	pushl  -0x48(%ebp)
  80251e:	ff 75 bc             	pushl  -0x44(%ebp)
  802521:	e8 b3 fc ff ff       	call   8021d9 <set_block_data>
  802526:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252d:	75 17                	jne    802546 <alloc_block_FF+0x33e>
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	68 77 43 80 00       	push   $0x804377
  802537:	68 e8 00 00 00       	push   $0xe8
  80253c:	68 95 43 80 00       	push   $0x804395
  802541:	e8 e4 13 00 00       	call   80392a <_panic>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	74 10                	je     80255f <alloc_block_FF+0x357>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802557:	8b 52 04             	mov    0x4(%edx),%edx
  80255a:	89 50 04             	mov    %edx,0x4(%eax)
  80255d:	eb 0b                	jmp    80256a <alloc_block_FF+0x362>
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 40 04             	mov    0x4(%eax),%eax
  802565:	a3 30 50 80 00       	mov    %eax,0x805030
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 04             	mov    0x4(%eax),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	74 0f                	je     802583 <alloc_block_FF+0x37b>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 40 04             	mov    0x4(%eax),%eax
  80257a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257d:	8b 12                	mov    (%edx),%edx
  80257f:	89 10                	mov    %edx,(%eax)
  802581:	eb 0a                	jmp    80258d <alloc_block_FF+0x385>
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 00                	mov    (%eax),%eax
  802588:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8025a5:	48                   	dec    %eax
  8025a6:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8025ab:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025ae:	e9 0f 01 00 00       	jmp    8026c2 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8025b3:	a1 34 50 80 00       	mov    0x805034,%eax
  8025b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bf:	74 07                	je     8025c8 <alloc_block_FF+0x3c0>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	eb 05                	jmp    8025cd <alloc_block_FF+0x3c5>
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cd:	a3 34 50 80 00       	mov    %eax,0x805034
  8025d2:	a1 34 50 80 00       	mov    0x805034,%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	0f 85 e9 fc ff ff    	jne    8022c8 <alloc_block_FF+0xc0>
  8025df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e3:	0f 85 df fc ff ff    	jne    8022c8 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	83 c0 08             	add    $0x8,%eax
  8025ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8025f2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025ff:	01 d0                	add    %edx,%eax
  802601:	48                   	dec    %eax
  802602:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802605:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802608:	ba 00 00 00 00       	mov    $0x0,%edx
  80260d:	f7 75 d8             	divl   -0x28(%ebp)
  802610:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802613:	29 d0                	sub    %edx,%eax
  802615:	c1 e8 0c             	shr    $0xc,%eax
  802618:	83 ec 0c             	sub    $0xc,%esp
  80261b:	50                   	push   %eax
  80261c:	e8 0b ed ff ff       	call   80132c <sbrk>
  802621:	83 c4 10             	add    $0x10,%esp
  802624:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802627:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80262b:	75 0a                	jne    802637 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80262d:	b8 00 00 00 00       	mov    $0x0,%eax
  802632:	e9 8b 00 00 00       	jmp    8026c2 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802637:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80263e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802641:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802644:	01 d0                	add    %edx,%eax
  802646:	48                   	dec    %eax
  802647:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80264a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80264d:	ba 00 00 00 00       	mov    $0x0,%edx
  802652:	f7 75 cc             	divl   -0x34(%ebp)
  802655:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802658:	29 d0                	sub    %edx,%eax
  80265a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80265d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802660:	01 d0                	add    %edx,%eax
  802662:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802667:	a1 40 50 80 00       	mov    0x805040,%eax
  80266c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802672:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802679:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80267c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80267f:	01 d0                	add    %edx,%eax
  802681:	48                   	dec    %eax
  802682:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802685:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802688:	ba 00 00 00 00       	mov    $0x0,%edx
  80268d:	f7 75 c4             	divl   -0x3c(%ebp)
  802690:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802693:	29 d0                	sub    %edx,%eax
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	6a 01                	push   $0x1
  80269a:	50                   	push   %eax
  80269b:	ff 75 d0             	pushl  -0x30(%ebp)
  80269e:	e8 36 fb ff ff       	call   8021d9 <set_block_data>
  8026a3:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026a6:	83 ec 0c             	sub    $0xc,%esp
  8026a9:	ff 75 d0             	pushl  -0x30(%ebp)
  8026ac:	e8 f8 09 00 00       	call   8030a9 <free_block>
  8026b1:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8026b4:	83 ec 0c             	sub    $0xc,%esp
  8026b7:	ff 75 08             	pushl  0x8(%ebp)
  8026ba:	e8 49 fb ff ff       	call   802208 <alloc_block_FF>
  8026bf:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
  8026c7:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cd:	83 e0 01             	and    $0x1,%eax
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	74 03                	je     8026d7 <alloc_block_BF+0x13>
  8026d4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026d7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026db:	77 07                	ja     8026e4 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026dd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026e4:	a1 24 50 80 00       	mov    0x805024,%eax
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	75 73                	jne    802760 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f0:	83 c0 10             	add    $0x10,%eax
  8026f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026f6:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802703:	01 d0                	add    %edx,%eax
  802705:	48                   	dec    %eax
  802706:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802709:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80270c:	ba 00 00 00 00       	mov    $0x0,%edx
  802711:	f7 75 e0             	divl   -0x20(%ebp)
  802714:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802717:	29 d0                	sub    %edx,%eax
  802719:	c1 e8 0c             	shr    $0xc,%eax
  80271c:	83 ec 0c             	sub    $0xc,%esp
  80271f:	50                   	push   %eax
  802720:	e8 07 ec ff ff       	call   80132c <sbrk>
  802725:	83 c4 10             	add    $0x10,%esp
  802728:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80272b:	83 ec 0c             	sub    $0xc,%esp
  80272e:	6a 00                	push   $0x0
  802730:	e8 f7 eb ff ff       	call   80132c <sbrk>
  802735:	83 c4 10             	add    $0x10,%esp
  802738:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80273b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80273e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802741:	83 ec 08             	sub    $0x8,%esp
  802744:	50                   	push   %eax
  802745:	ff 75 d8             	pushl  -0x28(%ebp)
  802748:	e8 9f f8 ff ff       	call   801fec <initialize_dynamic_allocator>
  80274d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802750:	83 ec 0c             	sub    $0xc,%esp
  802753:	68 d3 43 80 00       	push   $0x8043d3
  802758:	e8 2d dc ff ff       	call   80038a <cprintf>
  80275d:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802760:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802767:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80276e:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802775:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80277c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802781:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802784:	e9 1d 01 00 00       	jmp    8028a6 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80278f:	83 ec 0c             	sub    $0xc,%esp
  802792:	ff 75 a8             	pushl  -0x58(%ebp)
  802795:	e8 ee f6 ff ff       	call   801e88 <get_block_size>
  80279a:	83 c4 10             	add    $0x10,%esp
  80279d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	83 c0 08             	add    $0x8,%eax
  8027a6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027a9:	0f 87 ef 00 00 00    	ja     80289e <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027af:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b2:	83 c0 18             	add    $0x18,%eax
  8027b5:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027b8:	77 1d                	ja     8027d7 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8027ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027c0:	0f 86 d8 00 00 00    	jbe    80289e <alloc_block_BF+0x1da>
				{
					best_va = va;
  8027c6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8027cc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027d2:	e9 c7 00 00 00       	jmp    80289e <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8027d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027da:	83 c0 08             	add    $0x8,%eax
  8027dd:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027e0:	0f 85 9d 00 00 00    	jne    802883 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027e6:	83 ec 04             	sub    $0x4,%esp
  8027e9:	6a 01                	push   $0x1
  8027eb:	ff 75 a4             	pushl  -0x5c(%ebp)
  8027ee:	ff 75 a8             	pushl  -0x58(%ebp)
  8027f1:	e8 e3 f9 ff ff       	call   8021d9 <set_block_data>
  8027f6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8027f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fd:	75 17                	jne    802816 <alloc_block_BF+0x152>
  8027ff:	83 ec 04             	sub    $0x4,%esp
  802802:	68 77 43 80 00       	push   $0x804377
  802807:	68 2c 01 00 00       	push   $0x12c
  80280c:	68 95 43 80 00       	push   $0x804395
  802811:	e8 14 11 00 00       	call   80392a <_panic>
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 00                	mov    (%eax),%eax
  80281b:	85 c0                	test   %eax,%eax
  80281d:	74 10                	je     80282f <alloc_block_BF+0x16b>
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802827:	8b 52 04             	mov    0x4(%edx),%edx
  80282a:	89 50 04             	mov    %edx,0x4(%eax)
  80282d:	eb 0b                	jmp    80283a <alloc_block_BF+0x176>
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 40 04             	mov    0x4(%eax),%eax
  802835:	a3 30 50 80 00       	mov    %eax,0x805030
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	8b 40 04             	mov    0x4(%eax),%eax
  802840:	85 c0                	test   %eax,%eax
  802842:	74 0f                	je     802853 <alloc_block_BF+0x18f>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 40 04             	mov    0x4(%eax),%eax
  80284a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284d:	8b 12                	mov    (%edx),%edx
  80284f:	89 10                	mov    %edx,(%eax)
  802851:	eb 0a                	jmp    80285d <alloc_block_BF+0x199>
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802870:	a1 38 50 80 00       	mov    0x805038,%eax
  802875:	48                   	dec    %eax
  802876:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80287b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80287e:	e9 01 04 00 00       	jmp    802c84 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802886:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802889:	76 13                	jbe    80289e <alloc_block_BF+0x1da>
					{
						internal = 1;
  80288b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802892:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802895:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802898:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80289b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80289e:	a1 34 50 80 00       	mov    0x805034,%eax
  8028a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028aa:	74 07                	je     8028b3 <alloc_block_BF+0x1ef>
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	eb 05                	jmp    8028b8 <alloc_block_BF+0x1f4>
  8028b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b8:	a3 34 50 80 00       	mov    %eax,0x805034
  8028bd:	a1 34 50 80 00       	mov    0x805034,%eax
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	0f 85 bf fe ff ff    	jne    802789 <alloc_block_BF+0xc5>
  8028ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ce:	0f 85 b5 fe ff ff    	jne    802789 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8028d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028d8:	0f 84 26 02 00 00    	je     802b04 <alloc_block_BF+0x440>
  8028de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028e2:	0f 85 1c 02 00 00    	jne    802b04 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028eb:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ee:	83 e8 08             	sub    $0x8,%eax
  8028f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	8d 50 08             	lea    0x8(%eax),%edx
  8028fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fd:	01 d0                	add    %edx,%eax
  8028ff:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	83 c0 08             	add    $0x8,%eax
  802908:	83 ec 04             	sub    $0x4,%esp
  80290b:	6a 01                	push   $0x1
  80290d:	50                   	push   %eax
  80290e:	ff 75 f0             	pushl  -0x10(%ebp)
  802911:	e8 c3 f8 ff ff       	call   8021d9 <set_block_data>
  802916:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	75 68                	jne    80298b <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802923:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802927:	75 17                	jne    802940 <alloc_block_BF+0x27c>
  802929:	83 ec 04             	sub    $0x4,%esp
  80292c:	68 b0 43 80 00       	push   $0x8043b0
  802931:	68 45 01 00 00       	push   $0x145
  802936:	68 95 43 80 00       	push   $0x804395
  80293b:	e8 ea 0f 00 00       	call   80392a <_panic>
  802940:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802946:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802949:	89 10                	mov    %edx,(%eax)
  80294b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	74 0d                	je     802961 <alloc_block_BF+0x29d>
  802954:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802959:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80295c:	89 50 04             	mov    %edx,0x4(%eax)
  80295f:	eb 08                	jmp    802969 <alloc_block_BF+0x2a5>
  802961:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802964:	a3 30 50 80 00       	mov    %eax,0x805030
  802969:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80296c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802971:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802974:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297b:	a1 38 50 80 00       	mov    0x805038,%eax
  802980:	40                   	inc    %eax
  802981:	a3 38 50 80 00       	mov    %eax,0x805038
  802986:	e9 dc 00 00 00       	jmp    802a67 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	85 c0                	test   %eax,%eax
  802992:	75 65                	jne    8029f9 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802994:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802998:	75 17                	jne    8029b1 <alloc_block_BF+0x2ed>
  80299a:	83 ec 04             	sub    $0x4,%esp
  80299d:	68 e4 43 80 00       	push   $0x8043e4
  8029a2:	68 4a 01 00 00       	push   $0x14a
  8029a7:	68 95 43 80 00       	push   $0x804395
  8029ac:	e8 79 0f 00 00       	call   80392a <_panic>
  8029b1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ba:	89 50 04             	mov    %edx,0x4(%eax)
  8029bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c0:	8b 40 04             	mov    0x4(%eax),%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	74 0c                	je     8029d3 <alloc_block_BF+0x30f>
  8029c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8029cc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029cf:	89 10                	mov    %edx,(%eax)
  8029d1:	eb 08                	jmp    8029db <alloc_block_BF+0x317>
  8029d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029de:	a3 30 50 80 00       	mov    %eax,0x805030
  8029e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8029f1:	40                   	inc    %eax
  8029f2:	a3 38 50 80 00       	mov    %eax,0x805038
  8029f7:	eb 6e                	jmp    802a67 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8029f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029fd:	74 06                	je     802a05 <alloc_block_BF+0x341>
  8029ff:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a03:	75 17                	jne    802a1c <alloc_block_BF+0x358>
  802a05:	83 ec 04             	sub    $0x4,%esp
  802a08:	68 08 44 80 00       	push   $0x804408
  802a0d:	68 4f 01 00 00       	push   $0x14f
  802a12:	68 95 43 80 00       	push   $0x804395
  802a17:	e8 0e 0f 00 00       	call   80392a <_panic>
  802a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1f:	8b 10                	mov    (%eax),%edx
  802a21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a24:	89 10                	mov    %edx,(%eax)
  802a26:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	74 0b                	je     802a3a <alloc_block_BF+0x376>
  802a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a32:	8b 00                	mov    (%eax),%eax
  802a34:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a37:	89 50 04             	mov    %edx,0x4(%eax)
  802a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a40:	89 10                	mov    %edx,(%eax)
  802a42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a48:	89 50 04             	mov    %edx,0x4(%eax)
  802a4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	75 08                	jne    802a5c <alloc_block_BF+0x398>
  802a54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a57:	a3 30 50 80 00       	mov    %eax,0x805030
  802a5c:	a1 38 50 80 00       	mov    0x805038,%eax
  802a61:	40                   	inc    %eax
  802a62:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a6b:	75 17                	jne    802a84 <alloc_block_BF+0x3c0>
  802a6d:	83 ec 04             	sub    $0x4,%esp
  802a70:	68 77 43 80 00       	push   $0x804377
  802a75:	68 51 01 00 00       	push   $0x151
  802a7a:	68 95 43 80 00       	push   $0x804395
  802a7f:	e8 a6 0e 00 00       	call   80392a <_panic>
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	74 10                	je     802a9d <alloc_block_BF+0x3d9>
  802a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a90:	8b 00                	mov    (%eax),%eax
  802a92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a95:	8b 52 04             	mov    0x4(%edx),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
  802a9b:	eb 0b                	jmp    802aa8 <alloc_block_BF+0x3e4>
  802a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa0:	8b 40 04             	mov    0x4(%eax),%eax
  802aa3:	a3 30 50 80 00       	mov    %eax,0x805030
  802aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aab:	8b 40 04             	mov    0x4(%eax),%eax
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	74 0f                	je     802ac1 <alloc_block_BF+0x3fd>
  802ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab5:	8b 40 04             	mov    0x4(%eax),%eax
  802ab8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802abb:	8b 12                	mov    (%edx),%edx
  802abd:	89 10                	mov    %edx,(%eax)
  802abf:	eb 0a                	jmp    802acb <alloc_block_BF+0x407>
  802ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ade:	a1 38 50 80 00       	mov    0x805038,%eax
  802ae3:	48                   	dec    %eax
  802ae4:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802ae9:	83 ec 04             	sub    $0x4,%esp
  802aec:	6a 00                	push   $0x0
  802aee:	ff 75 d0             	pushl  -0x30(%ebp)
  802af1:	ff 75 cc             	pushl  -0x34(%ebp)
  802af4:	e8 e0 f6 ff ff       	call   8021d9 <set_block_data>
  802af9:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aff:	e9 80 01 00 00       	jmp    802c84 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802b04:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b08:	0f 85 9d 00 00 00    	jne    802bab <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b0e:	83 ec 04             	sub    $0x4,%esp
  802b11:	6a 01                	push   $0x1
  802b13:	ff 75 ec             	pushl  -0x14(%ebp)
  802b16:	ff 75 f0             	pushl  -0x10(%ebp)
  802b19:	e8 bb f6 ff ff       	call   8021d9 <set_block_data>
  802b1e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b25:	75 17                	jne    802b3e <alloc_block_BF+0x47a>
  802b27:	83 ec 04             	sub    $0x4,%esp
  802b2a:	68 77 43 80 00       	push   $0x804377
  802b2f:	68 58 01 00 00       	push   $0x158
  802b34:	68 95 43 80 00       	push   $0x804395
  802b39:	e8 ec 0d 00 00       	call   80392a <_panic>
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	85 c0                	test   %eax,%eax
  802b45:	74 10                	je     802b57 <alloc_block_BF+0x493>
  802b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4f:	8b 52 04             	mov    0x4(%edx),%edx
  802b52:	89 50 04             	mov    %edx,0x4(%eax)
  802b55:	eb 0b                	jmp    802b62 <alloc_block_BF+0x49e>
  802b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5a:	8b 40 04             	mov    0x4(%eax),%eax
  802b5d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b65:	8b 40 04             	mov    0x4(%eax),%eax
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	74 0f                	je     802b7b <alloc_block_BF+0x4b7>
  802b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6f:	8b 40 04             	mov    0x4(%eax),%eax
  802b72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b75:	8b 12                	mov    (%edx),%edx
  802b77:	89 10                	mov    %edx,(%eax)
  802b79:	eb 0a                	jmp    802b85 <alloc_block_BF+0x4c1>
  802b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b98:	a1 38 50 80 00       	mov    0x805038,%eax
  802b9d:	48                   	dec    %eax
  802b9e:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba6:	e9 d9 00 00 00       	jmp    802c84 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	83 c0 08             	add    $0x8,%eax
  802bb1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802bb4:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802bbb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bbe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bc1:	01 d0                	add    %edx,%eax
  802bc3:	48                   	dec    %eax
  802bc4:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bc7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bca:	ba 00 00 00 00       	mov    $0x0,%edx
  802bcf:	f7 75 c4             	divl   -0x3c(%ebp)
  802bd2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bd5:	29 d0                	sub    %edx,%eax
  802bd7:	c1 e8 0c             	shr    $0xc,%eax
  802bda:	83 ec 0c             	sub    $0xc,%esp
  802bdd:	50                   	push   %eax
  802bde:	e8 49 e7 ff ff       	call   80132c <sbrk>
  802be3:	83 c4 10             	add    $0x10,%esp
  802be6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802be9:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802bed:	75 0a                	jne    802bf9 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802bef:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf4:	e9 8b 00 00 00       	jmp    802c84 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802bf9:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c00:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c03:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c06:	01 d0                	add    %edx,%eax
  802c08:	48                   	dec    %eax
  802c09:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c0c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c0f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c14:	f7 75 b8             	divl   -0x48(%ebp)
  802c17:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c1a:	29 d0                	sub    %edx,%eax
  802c1c:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c1f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c22:	01 d0                	add    %edx,%eax
  802c24:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c29:	a1 40 50 80 00       	mov    0x805040,%eax
  802c2e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c34:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c3b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c3e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c41:	01 d0                	add    %edx,%eax
  802c43:	48                   	dec    %eax
  802c44:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c47:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c4f:	f7 75 b0             	divl   -0x50(%ebp)
  802c52:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c55:	29 d0                	sub    %edx,%eax
  802c57:	83 ec 04             	sub    $0x4,%esp
  802c5a:	6a 01                	push   $0x1
  802c5c:	50                   	push   %eax
  802c5d:	ff 75 bc             	pushl  -0x44(%ebp)
  802c60:	e8 74 f5 ff ff       	call   8021d9 <set_block_data>
  802c65:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c68:	83 ec 0c             	sub    $0xc,%esp
  802c6b:	ff 75 bc             	pushl  -0x44(%ebp)
  802c6e:	e8 36 04 00 00       	call   8030a9 <free_block>
  802c73:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c76:	83 ec 0c             	sub    $0xc,%esp
  802c79:	ff 75 08             	pushl  0x8(%ebp)
  802c7c:	e8 43 fa ff ff       	call   8026c4 <alloc_block_BF>
  802c81:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c84:	c9                   	leave  
  802c85:	c3                   	ret    

00802c86 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c86:	55                   	push   %ebp
  802c87:	89 e5                	mov    %esp,%ebp
  802c89:	53                   	push   %ebx
  802c8a:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9f:	74 1e                	je     802cbf <merging+0x39>
  802ca1:	ff 75 08             	pushl  0x8(%ebp)
  802ca4:	e8 df f1 ff ff       	call   801e88 <get_block_size>
  802ca9:	83 c4 04             	add    $0x4,%esp
  802cac:	89 c2                	mov    %eax,%edx
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	01 d0                	add    %edx,%eax
  802cb3:	3b 45 10             	cmp    0x10(%ebp),%eax
  802cb6:	75 07                	jne    802cbf <merging+0x39>
		prev_is_free = 1;
  802cb8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802cbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cc3:	74 1e                	je     802ce3 <merging+0x5d>
  802cc5:	ff 75 10             	pushl  0x10(%ebp)
  802cc8:	e8 bb f1 ff ff       	call   801e88 <get_block_size>
  802ccd:	83 c4 04             	add    $0x4,%esp
  802cd0:	89 c2                	mov    %eax,%edx
  802cd2:	8b 45 10             	mov    0x10(%ebp),%eax
  802cd5:	01 d0                	add    %edx,%eax
  802cd7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cda:	75 07                	jne    802ce3 <merging+0x5d>
		next_is_free = 1;
  802cdc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ce3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce7:	0f 84 cc 00 00 00    	je     802db9 <merging+0x133>
  802ced:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf1:	0f 84 c2 00 00 00    	je     802db9 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802cf7:	ff 75 08             	pushl  0x8(%ebp)
  802cfa:	e8 89 f1 ff ff       	call   801e88 <get_block_size>
  802cff:	83 c4 04             	add    $0x4,%esp
  802d02:	89 c3                	mov    %eax,%ebx
  802d04:	ff 75 10             	pushl  0x10(%ebp)
  802d07:	e8 7c f1 ff ff       	call   801e88 <get_block_size>
  802d0c:	83 c4 04             	add    $0x4,%esp
  802d0f:	01 c3                	add    %eax,%ebx
  802d11:	ff 75 0c             	pushl  0xc(%ebp)
  802d14:	e8 6f f1 ff ff       	call   801e88 <get_block_size>
  802d19:	83 c4 04             	add    $0x4,%esp
  802d1c:	01 d8                	add    %ebx,%eax
  802d1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d21:	6a 00                	push   $0x0
  802d23:	ff 75 ec             	pushl  -0x14(%ebp)
  802d26:	ff 75 08             	pushl  0x8(%ebp)
  802d29:	e8 ab f4 ff ff       	call   8021d9 <set_block_data>
  802d2e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d35:	75 17                	jne    802d4e <merging+0xc8>
  802d37:	83 ec 04             	sub    $0x4,%esp
  802d3a:	68 77 43 80 00       	push   $0x804377
  802d3f:	68 7d 01 00 00       	push   $0x17d
  802d44:	68 95 43 80 00       	push   $0x804395
  802d49:	e8 dc 0b 00 00       	call   80392a <_panic>
  802d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d51:	8b 00                	mov    (%eax),%eax
  802d53:	85 c0                	test   %eax,%eax
  802d55:	74 10                	je     802d67 <merging+0xe1>
  802d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d5f:	8b 52 04             	mov    0x4(%edx),%edx
  802d62:	89 50 04             	mov    %edx,0x4(%eax)
  802d65:	eb 0b                	jmp    802d72 <merging+0xec>
  802d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6a:	8b 40 04             	mov    0x4(%eax),%eax
  802d6d:	a3 30 50 80 00       	mov    %eax,0x805030
  802d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d75:	8b 40 04             	mov    0x4(%eax),%eax
  802d78:	85 c0                	test   %eax,%eax
  802d7a:	74 0f                	je     802d8b <merging+0x105>
  802d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7f:	8b 40 04             	mov    0x4(%eax),%eax
  802d82:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d85:	8b 12                	mov    (%edx),%edx
  802d87:	89 10                	mov    %edx,(%eax)
  802d89:	eb 0a                	jmp    802d95 <merging+0x10f>
  802d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8e:	8b 00                	mov    (%eax),%eax
  802d90:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da8:	a1 38 50 80 00       	mov    0x805038,%eax
  802dad:	48                   	dec    %eax
  802dae:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802db3:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802db4:	e9 ea 02 00 00       	jmp    8030a3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802db9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbd:	74 3b                	je     802dfa <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802dbf:	83 ec 0c             	sub    $0xc,%esp
  802dc2:	ff 75 08             	pushl  0x8(%ebp)
  802dc5:	e8 be f0 ff ff       	call   801e88 <get_block_size>
  802dca:	83 c4 10             	add    $0x10,%esp
  802dcd:	89 c3                	mov    %eax,%ebx
  802dcf:	83 ec 0c             	sub    $0xc,%esp
  802dd2:	ff 75 10             	pushl  0x10(%ebp)
  802dd5:	e8 ae f0 ff ff       	call   801e88 <get_block_size>
  802dda:	83 c4 10             	add    $0x10,%esp
  802ddd:	01 d8                	add    %ebx,%eax
  802ddf:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802de2:	83 ec 04             	sub    $0x4,%esp
  802de5:	6a 00                	push   $0x0
  802de7:	ff 75 e8             	pushl  -0x18(%ebp)
  802dea:	ff 75 08             	pushl  0x8(%ebp)
  802ded:	e8 e7 f3 ff ff       	call   8021d9 <set_block_data>
  802df2:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802df5:	e9 a9 02 00 00       	jmp    8030a3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802dfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dfe:	0f 84 2d 01 00 00    	je     802f31 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e04:	83 ec 0c             	sub    $0xc,%esp
  802e07:	ff 75 10             	pushl  0x10(%ebp)
  802e0a:	e8 79 f0 ff ff       	call   801e88 <get_block_size>
  802e0f:	83 c4 10             	add    $0x10,%esp
  802e12:	89 c3                	mov    %eax,%ebx
  802e14:	83 ec 0c             	sub    $0xc,%esp
  802e17:	ff 75 0c             	pushl  0xc(%ebp)
  802e1a:	e8 69 f0 ff ff       	call   801e88 <get_block_size>
  802e1f:	83 c4 10             	add    $0x10,%esp
  802e22:	01 d8                	add    %ebx,%eax
  802e24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e27:	83 ec 04             	sub    $0x4,%esp
  802e2a:	6a 00                	push   $0x0
  802e2c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e2f:	ff 75 10             	pushl  0x10(%ebp)
  802e32:	e8 a2 f3 ff ff       	call   8021d9 <set_block_data>
  802e37:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  802e3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e44:	74 06                	je     802e4c <merging+0x1c6>
  802e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e4a:	75 17                	jne    802e63 <merging+0x1dd>
  802e4c:	83 ec 04             	sub    $0x4,%esp
  802e4f:	68 3c 44 80 00       	push   $0x80443c
  802e54:	68 8d 01 00 00       	push   $0x18d
  802e59:	68 95 43 80 00       	push   $0x804395
  802e5e:	e8 c7 0a 00 00       	call   80392a <_panic>
  802e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e66:	8b 50 04             	mov    0x4(%eax),%edx
  802e69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6c:	89 50 04             	mov    %edx,0x4(%eax)
  802e6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e72:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e75:	89 10                	mov    %edx,(%eax)
  802e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7a:	8b 40 04             	mov    0x4(%eax),%eax
  802e7d:	85 c0                	test   %eax,%eax
  802e7f:	74 0d                	je     802e8e <merging+0x208>
  802e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e84:	8b 40 04             	mov    0x4(%eax),%eax
  802e87:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e8a:	89 10                	mov    %edx,(%eax)
  802e8c:	eb 08                	jmp    802e96 <merging+0x210>
  802e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e91:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e9c:	89 50 04             	mov    %edx,0x4(%eax)
  802e9f:	a1 38 50 80 00       	mov    0x805038,%eax
  802ea4:	40                   	inc    %eax
  802ea5:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802eaa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eae:	75 17                	jne    802ec7 <merging+0x241>
  802eb0:	83 ec 04             	sub    $0x4,%esp
  802eb3:	68 77 43 80 00       	push   $0x804377
  802eb8:	68 8e 01 00 00       	push   $0x18e
  802ebd:	68 95 43 80 00       	push   $0x804395
  802ec2:	e8 63 0a 00 00       	call   80392a <_panic>
  802ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	74 10                	je     802ee0 <merging+0x25a>
  802ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed3:	8b 00                	mov    (%eax),%eax
  802ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed8:	8b 52 04             	mov    0x4(%edx),%edx
  802edb:	89 50 04             	mov    %edx,0x4(%eax)
  802ede:	eb 0b                	jmp    802eeb <merging+0x265>
  802ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee3:	8b 40 04             	mov    0x4(%eax),%eax
  802ee6:	a3 30 50 80 00       	mov    %eax,0x805030
  802eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eee:	8b 40 04             	mov    0x4(%eax),%eax
  802ef1:	85 c0                	test   %eax,%eax
  802ef3:	74 0f                	je     802f04 <merging+0x27e>
  802ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef8:	8b 40 04             	mov    0x4(%eax),%eax
  802efb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802efe:	8b 12                	mov    (%edx),%edx
  802f00:	89 10                	mov    %edx,(%eax)
  802f02:	eb 0a                	jmp    802f0e <merging+0x288>
  802f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f07:	8b 00                	mov    (%eax),%eax
  802f09:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f21:	a1 38 50 80 00       	mov    0x805038,%eax
  802f26:	48                   	dec    %eax
  802f27:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f2c:	e9 72 01 00 00       	jmp    8030a3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f31:	8b 45 10             	mov    0x10(%ebp),%eax
  802f34:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3b:	74 79                	je     802fb6 <merging+0x330>
  802f3d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f41:	74 73                	je     802fb6 <merging+0x330>
  802f43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f47:	74 06                	je     802f4f <merging+0x2c9>
  802f49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f4d:	75 17                	jne    802f66 <merging+0x2e0>
  802f4f:	83 ec 04             	sub    $0x4,%esp
  802f52:	68 08 44 80 00       	push   $0x804408
  802f57:	68 94 01 00 00       	push   $0x194
  802f5c:	68 95 43 80 00       	push   $0x804395
  802f61:	e8 c4 09 00 00       	call   80392a <_panic>
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	8b 10                	mov    (%eax),%edx
  802f6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f6e:	89 10                	mov    %edx,(%eax)
  802f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 0b                	je     802f84 <merging+0x2fe>
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f81:	89 50 04             	mov    %edx,0x4(%eax)
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f8a:	89 10                	mov    %edx,(%eax)
  802f8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f92:	89 50 04             	mov    %edx,0x4(%eax)
  802f95:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f98:	8b 00                	mov    (%eax),%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	75 08                	jne    802fa6 <merging+0x320>
  802f9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa1:	a3 30 50 80 00       	mov    %eax,0x805030
  802fa6:	a1 38 50 80 00       	mov    0x805038,%eax
  802fab:	40                   	inc    %eax
  802fac:	a3 38 50 80 00       	mov    %eax,0x805038
  802fb1:	e9 ce 00 00 00       	jmp    803084 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fba:	74 65                	je     803021 <merging+0x39b>
  802fbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fc0:	75 17                	jne    802fd9 <merging+0x353>
  802fc2:	83 ec 04             	sub    $0x4,%esp
  802fc5:	68 e4 43 80 00       	push   $0x8043e4
  802fca:	68 95 01 00 00       	push   $0x195
  802fcf:	68 95 43 80 00       	push   $0x804395
  802fd4:	e8 51 09 00 00       	call   80392a <_panic>
  802fd9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fdf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe2:	89 50 04             	mov    %edx,0x4(%eax)
  802fe5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe8:	8b 40 04             	mov    0x4(%eax),%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	74 0c                	je     802ffb <merging+0x375>
  802fef:	a1 30 50 80 00       	mov    0x805030,%eax
  802ff4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ff7:	89 10                	mov    %edx,(%eax)
  802ff9:	eb 08                	jmp    803003 <merging+0x37d>
  802ffb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ffe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803003:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803006:	a3 30 50 80 00       	mov    %eax,0x805030
  80300b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803014:	a1 38 50 80 00       	mov    0x805038,%eax
  803019:	40                   	inc    %eax
  80301a:	a3 38 50 80 00       	mov    %eax,0x805038
  80301f:	eb 63                	jmp    803084 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803021:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803025:	75 17                	jne    80303e <merging+0x3b8>
  803027:	83 ec 04             	sub    $0x4,%esp
  80302a:	68 b0 43 80 00       	push   $0x8043b0
  80302f:	68 98 01 00 00       	push   $0x198
  803034:	68 95 43 80 00       	push   $0x804395
  803039:	e8 ec 08 00 00       	call   80392a <_panic>
  80303e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803044:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803047:	89 10                	mov    %edx,(%eax)
  803049:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	74 0d                	je     80305f <merging+0x3d9>
  803052:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803057:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80305a:	89 50 04             	mov    %edx,0x4(%eax)
  80305d:	eb 08                	jmp    803067 <merging+0x3e1>
  80305f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803062:	a3 30 50 80 00       	mov    %eax,0x805030
  803067:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80306a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80306f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803072:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803079:	a1 38 50 80 00       	mov    0x805038,%eax
  80307e:	40                   	inc    %eax
  80307f:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803084:	83 ec 0c             	sub    $0xc,%esp
  803087:	ff 75 10             	pushl  0x10(%ebp)
  80308a:	e8 f9 ed ff ff       	call   801e88 <get_block_size>
  80308f:	83 c4 10             	add    $0x10,%esp
  803092:	83 ec 04             	sub    $0x4,%esp
  803095:	6a 00                	push   $0x0
  803097:	50                   	push   %eax
  803098:	ff 75 10             	pushl  0x10(%ebp)
  80309b:	e8 39 f1 ff ff       	call   8021d9 <set_block_data>
  8030a0:	83 c4 10             	add    $0x10,%esp
	}
}
  8030a3:	90                   	nop
  8030a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030a7:	c9                   	leave  
  8030a8:	c3                   	ret    

008030a9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030a9:	55                   	push   %ebp
  8030aa:	89 e5                	mov    %esp,%ebp
  8030ac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030af:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030b4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030b7:	a1 30 50 80 00       	mov    0x805030,%eax
  8030bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030bf:	73 1b                	jae    8030dc <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030c1:	a1 30 50 80 00       	mov    0x805030,%eax
  8030c6:	83 ec 04             	sub    $0x4,%esp
  8030c9:	ff 75 08             	pushl  0x8(%ebp)
  8030cc:	6a 00                	push   $0x0
  8030ce:	50                   	push   %eax
  8030cf:	e8 b2 fb ff ff       	call   802c86 <merging>
  8030d4:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030d7:	e9 8b 00 00 00       	jmp    803167 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e4:	76 18                	jbe    8030fe <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030e6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030eb:	83 ec 04             	sub    $0x4,%esp
  8030ee:	ff 75 08             	pushl  0x8(%ebp)
  8030f1:	50                   	push   %eax
  8030f2:	6a 00                	push   $0x0
  8030f4:	e8 8d fb ff ff       	call   802c86 <merging>
  8030f9:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030fc:	eb 69                	jmp    803167 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030fe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803103:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803106:	eb 39                	jmp    803141 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310e:	73 29                	jae    803139 <free_block+0x90>
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	8b 00                	mov    (%eax),%eax
  803115:	3b 45 08             	cmp    0x8(%ebp),%eax
  803118:	76 1f                	jbe    803139 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311d:	8b 00                	mov    (%eax),%eax
  80311f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803122:	83 ec 04             	sub    $0x4,%esp
  803125:	ff 75 08             	pushl  0x8(%ebp)
  803128:	ff 75 f0             	pushl  -0x10(%ebp)
  80312b:	ff 75 f4             	pushl  -0xc(%ebp)
  80312e:	e8 53 fb ff ff       	call   802c86 <merging>
  803133:	83 c4 10             	add    $0x10,%esp
			break;
  803136:	90                   	nop
		}
	}
}
  803137:	eb 2e                	jmp    803167 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803139:	a1 34 50 80 00       	mov    0x805034,%eax
  80313e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803141:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803145:	74 07                	je     80314e <free_block+0xa5>
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8b 00                	mov    (%eax),%eax
  80314c:	eb 05                	jmp    803153 <free_block+0xaa>
  80314e:	b8 00 00 00 00       	mov    $0x0,%eax
  803153:	a3 34 50 80 00       	mov    %eax,0x805034
  803158:	a1 34 50 80 00       	mov    0x805034,%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	75 a7                	jne    803108 <free_block+0x5f>
  803161:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803165:	75 a1                	jne    803108 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803167:	90                   	nop
  803168:	c9                   	leave  
  803169:	c3                   	ret    

0080316a <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80316a:	55                   	push   %ebp
  80316b:	89 e5                	mov    %esp,%ebp
  80316d:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803170:	ff 75 08             	pushl  0x8(%ebp)
  803173:	e8 10 ed ff ff       	call   801e88 <get_block_size>
  803178:	83 c4 04             	add    $0x4,%esp
  80317b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80317e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803185:	eb 17                	jmp    80319e <copy_data+0x34>
  803187:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80318a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318d:	01 c2                	add    %eax,%edx
  80318f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	01 c8                	add    %ecx,%eax
  803197:	8a 00                	mov    (%eax),%al
  803199:	88 02                	mov    %al,(%edx)
  80319b:	ff 45 fc             	incl   -0x4(%ebp)
  80319e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031a4:	72 e1                	jb     803187 <copy_data+0x1d>
}
  8031a6:	90                   	nop
  8031a7:	c9                   	leave  
  8031a8:	c3                   	ret    

008031a9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031a9:	55                   	push   %ebp
  8031aa:	89 e5                	mov    %esp,%ebp
  8031ac:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b3:	75 23                	jne    8031d8 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8031b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031b9:	74 13                	je     8031ce <realloc_block_FF+0x25>
  8031bb:	83 ec 0c             	sub    $0xc,%esp
  8031be:	ff 75 0c             	pushl  0xc(%ebp)
  8031c1:	e8 42 f0 ff ff       	call   802208 <alloc_block_FF>
  8031c6:	83 c4 10             	add    $0x10,%esp
  8031c9:	e9 e4 06 00 00       	jmp    8038b2 <realloc_block_FF+0x709>
		return NULL;
  8031ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d3:	e9 da 06 00 00       	jmp    8038b2 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8031d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031dc:	75 18                	jne    8031f6 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031de:	83 ec 0c             	sub    $0xc,%esp
  8031e1:	ff 75 08             	pushl  0x8(%ebp)
  8031e4:	e8 c0 fe ff ff       	call   8030a9 <free_block>
  8031e9:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f1:	e9 bc 06 00 00       	jmp    8038b2 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8031f6:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031fa:	77 07                	ja     803203 <realloc_block_FF+0x5a>
  8031fc:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803203:	8b 45 0c             	mov    0xc(%ebp),%eax
  803206:	83 e0 01             	and    $0x1,%eax
  803209:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80320c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80320f:	83 c0 08             	add    $0x8,%eax
  803212:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803215:	83 ec 0c             	sub    $0xc,%esp
  803218:	ff 75 08             	pushl  0x8(%ebp)
  80321b:	e8 68 ec ff ff       	call   801e88 <get_block_size>
  803220:	83 c4 10             	add    $0x10,%esp
  803223:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803226:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803229:	83 e8 08             	sub    $0x8,%eax
  80322c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80322f:	8b 45 08             	mov    0x8(%ebp),%eax
  803232:	83 e8 04             	sub    $0x4,%eax
  803235:	8b 00                	mov    (%eax),%eax
  803237:	83 e0 fe             	and    $0xfffffffe,%eax
  80323a:	89 c2                	mov    %eax,%edx
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	01 d0                	add    %edx,%eax
  803241:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803244:	83 ec 0c             	sub    $0xc,%esp
  803247:	ff 75 e4             	pushl  -0x1c(%ebp)
  80324a:	e8 39 ec ff ff       	call   801e88 <get_block_size>
  80324f:	83 c4 10             	add    $0x10,%esp
  803252:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803255:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803258:	83 e8 08             	sub    $0x8,%eax
  80325b:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80325e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803261:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803264:	75 08                	jne    80326e <realloc_block_FF+0xc5>
	{
		 return va;
  803266:	8b 45 08             	mov    0x8(%ebp),%eax
  803269:	e9 44 06 00 00       	jmp    8038b2 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80326e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803271:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803274:	0f 83 d5 03 00 00    	jae    80364f <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80327a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327d:	2b 45 0c             	sub    0xc(%ebp),%eax
  803280:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803283:	83 ec 0c             	sub    $0xc,%esp
  803286:	ff 75 e4             	pushl  -0x1c(%ebp)
  803289:	e8 13 ec ff ff       	call   801ea1 <is_free_block>
  80328e:	83 c4 10             	add    $0x10,%esp
  803291:	84 c0                	test   %al,%al
  803293:	0f 84 3b 01 00 00    	je     8033d4 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803299:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80329c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80329f:	01 d0                	add    %edx,%eax
  8032a1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8032a4:	83 ec 04             	sub    $0x4,%esp
  8032a7:	6a 01                	push   $0x1
  8032a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8032ac:	ff 75 08             	pushl  0x8(%ebp)
  8032af:	e8 25 ef ff ff       	call   8021d9 <set_block_data>
  8032b4:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	83 e8 04             	sub    $0x4,%eax
  8032bd:	8b 00                	mov    (%eax),%eax
  8032bf:	83 e0 fe             	and    $0xfffffffe,%eax
  8032c2:	89 c2                	mov    %eax,%edx
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	01 d0                	add    %edx,%eax
  8032c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8032cc:	83 ec 04             	sub    $0x4,%esp
  8032cf:	6a 00                	push   $0x0
  8032d1:	ff 75 cc             	pushl  -0x34(%ebp)
  8032d4:	ff 75 c8             	pushl  -0x38(%ebp)
  8032d7:	e8 fd ee ff ff       	call   8021d9 <set_block_data>
  8032dc:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032df:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032e3:	74 06                	je     8032eb <realloc_block_FF+0x142>
  8032e5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032e9:	75 17                	jne    803302 <realloc_block_FF+0x159>
  8032eb:	83 ec 04             	sub    $0x4,%esp
  8032ee:	68 08 44 80 00       	push   $0x804408
  8032f3:	68 f6 01 00 00       	push   $0x1f6
  8032f8:	68 95 43 80 00       	push   $0x804395
  8032fd:	e8 28 06 00 00       	call   80392a <_panic>
  803302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803305:	8b 10                	mov    (%eax),%edx
  803307:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80330a:	89 10                	mov    %edx,(%eax)
  80330c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80330f:	8b 00                	mov    (%eax),%eax
  803311:	85 c0                	test   %eax,%eax
  803313:	74 0b                	je     803320 <realloc_block_FF+0x177>
  803315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80331d:	89 50 04             	mov    %edx,0x4(%eax)
  803320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803323:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803326:	89 10                	mov    %edx,(%eax)
  803328:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80332b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80332e:	89 50 04             	mov    %edx,0x4(%eax)
  803331:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803334:	8b 00                	mov    (%eax),%eax
  803336:	85 c0                	test   %eax,%eax
  803338:	75 08                	jne    803342 <realloc_block_FF+0x199>
  80333a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80333d:	a3 30 50 80 00       	mov    %eax,0x805030
  803342:	a1 38 50 80 00       	mov    0x805038,%eax
  803347:	40                   	inc    %eax
  803348:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80334d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803351:	75 17                	jne    80336a <realloc_block_FF+0x1c1>
  803353:	83 ec 04             	sub    $0x4,%esp
  803356:	68 77 43 80 00       	push   $0x804377
  80335b:	68 f7 01 00 00       	push   $0x1f7
  803360:	68 95 43 80 00       	push   $0x804395
  803365:	e8 c0 05 00 00       	call   80392a <_panic>
  80336a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336d:	8b 00                	mov    (%eax),%eax
  80336f:	85 c0                	test   %eax,%eax
  803371:	74 10                	je     803383 <realloc_block_FF+0x1da>
  803373:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803376:	8b 00                	mov    (%eax),%eax
  803378:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80337b:	8b 52 04             	mov    0x4(%edx),%edx
  80337e:	89 50 04             	mov    %edx,0x4(%eax)
  803381:	eb 0b                	jmp    80338e <realloc_block_FF+0x1e5>
  803383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803386:	8b 40 04             	mov    0x4(%eax),%eax
  803389:	a3 30 50 80 00       	mov    %eax,0x805030
  80338e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803391:	8b 40 04             	mov    0x4(%eax),%eax
  803394:	85 c0                	test   %eax,%eax
  803396:	74 0f                	je     8033a7 <realloc_block_FF+0x1fe>
  803398:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339b:	8b 40 04             	mov    0x4(%eax),%eax
  80339e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033a1:	8b 12                	mov    (%edx),%edx
  8033a3:	89 10                	mov    %edx,(%eax)
  8033a5:	eb 0a                	jmp    8033b1 <realloc_block_FF+0x208>
  8033a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033aa:	8b 00                	mov    (%eax),%eax
  8033ac:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c4:	a1 38 50 80 00       	mov    0x805038,%eax
  8033c9:	48                   	dec    %eax
  8033ca:	a3 38 50 80 00       	mov    %eax,0x805038
  8033cf:	e9 73 02 00 00       	jmp    803647 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8033d4:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033d8:	0f 86 69 02 00 00    	jbe    803647 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033de:	83 ec 04             	sub    $0x4,%esp
  8033e1:	6a 01                	push   $0x1
  8033e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8033e6:	ff 75 08             	pushl  0x8(%ebp)
  8033e9:	e8 eb ed ff ff       	call   8021d9 <set_block_data>
  8033ee:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	83 e8 04             	sub    $0x4,%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	83 e0 fe             	and    $0xfffffffe,%eax
  8033fc:	89 c2                	mov    %eax,%edx
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	01 d0                	add    %edx,%eax
  803403:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803406:	a1 38 50 80 00       	mov    0x805038,%eax
  80340b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80340e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803412:	75 68                	jne    80347c <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803414:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803418:	75 17                	jne    803431 <realloc_block_FF+0x288>
  80341a:	83 ec 04             	sub    $0x4,%esp
  80341d:	68 b0 43 80 00       	push   $0x8043b0
  803422:	68 06 02 00 00       	push   $0x206
  803427:	68 95 43 80 00       	push   $0x804395
  80342c:	e8 f9 04 00 00       	call   80392a <_panic>
  803431:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803437:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80343a:	89 10                	mov    %edx,(%eax)
  80343c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80343f:	8b 00                	mov    (%eax),%eax
  803441:	85 c0                	test   %eax,%eax
  803443:	74 0d                	je     803452 <realloc_block_FF+0x2a9>
  803445:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80344a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80344d:	89 50 04             	mov    %edx,0x4(%eax)
  803450:	eb 08                	jmp    80345a <realloc_block_FF+0x2b1>
  803452:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803455:	a3 30 50 80 00       	mov    %eax,0x805030
  80345a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803462:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803465:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346c:	a1 38 50 80 00       	mov    0x805038,%eax
  803471:	40                   	inc    %eax
  803472:	a3 38 50 80 00       	mov    %eax,0x805038
  803477:	e9 b0 01 00 00       	jmp    80362c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80347c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803481:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803484:	76 68                	jbe    8034ee <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803486:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80348a:	75 17                	jne    8034a3 <realloc_block_FF+0x2fa>
  80348c:	83 ec 04             	sub    $0x4,%esp
  80348f:	68 b0 43 80 00       	push   $0x8043b0
  803494:	68 0b 02 00 00       	push   $0x20b
  803499:	68 95 43 80 00       	push   $0x804395
  80349e:	e8 87 04 00 00       	call   80392a <_panic>
  8034a3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ac:	89 10                	mov    %edx,(%eax)
  8034ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b1:	8b 00                	mov    (%eax),%eax
  8034b3:	85 c0                	test   %eax,%eax
  8034b5:	74 0d                	je     8034c4 <realloc_block_FF+0x31b>
  8034b7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034bf:	89 50 04             	mov    %edx,0x4(%eax)
  8034c2:	eb 08                	jmp    8034cc <realloc_block_FF+0x323>
  8034c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8034cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034cf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034de:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e3:	40                   	inc    %eax
  8034e4:	a3 38 50 80 00       	mov    %eax,0x805038
  8034e9:	e9 3e 01 00 00       	jmp    80362c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034ee:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034f3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034f6:	73 68                	jae    803560 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034f8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034fc:	75 17                	jne    803515 <realloc_block_FF+0x36c>
  8034fe:	83 ec 04             	sub    $0x4,%esp
  803501:	68 e4 43 80 00       	push   $0x8043e4
  803506:	68 10 02 00 00       	push   $0x210
  80350b:	68 95 43 80 00       	push   $0x804395
  803510:	e8 15 04 00 00       	call   80392a <_panic>
  803515:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80351b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351e:	89 50 04             	mov    %edx,0x4(%eax)
  803521:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803524:	8b 40 04             	mov    0x4(%eax),%eax
  803527:	85 c0                	test   %eax,%eax
  803529:	74 0c                	je     803537 <realloc_block_FF+0x38e>
  80352b:	a1 30 50 80 00       	mov    0x805030,%eax
  803530:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803533:	89 10                	mov    %edx,(%eax)
  803535:	eb 08                	jmp    80353f <realloc_block_FF+0x396>
  803537:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80353f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803542:	a3 30 50 80 00       	mov    %eax,0x805030
  803547:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803550:	a1 38 50 80 00       	mov    0x805038,%eax
  803555:	40                   	inc    %eax
  803556:	a3 38 50 80 00       	mov    %eax,0x805038
  80355b:	e9 cc 00 00 00       	jmp    80362c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803560:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803567:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80356c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80356f:	e9 8a 00 00 00       	jmp    8035fe <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803577:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80357a:	73 7a                	jae    8035f6 <realloc_block_FF+0x44d>
  80357c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357f:	8b 00                	mov    (%eax),%eax
  803581:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803584:	73 70                	jae    8035f6 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803586:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80358a:	74 06                	je     803592 <realloc_block_FF+0x3e9>
  80358c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803590:	75 17                	jne    8035a9 <realloc_block_FF+0x400>
  803592:	83 ec 04             	sub    $0x4,%esp
  803595:	68 08 44 80 00       	push   $0x804408
  80359a:	68 1a 02 00 00       	push   $0x21a
  80359f:	68 95 43 80 00       	push   $0x804395
  8035a4:	e8 81 03 00 00       	call   80392a <_panic>
  8035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ac:	8b 10                	mov    (%eax),%edx
  8035ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b1:	89 10                	mov    %edx,(%eax)
  8035b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b6:	8b 00                	mov    (%eax),%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	74 0b                	je     8035c7 <realloc_block_FF+0x41e>
  8035bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035c4:	89 50 04             	mov    %edx,0x4(%eax)
  8035c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035cd:	89 10                	mov    %edx,(%eax)
  8035cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d5:	89 50 04             	mov    %edx,0x4(%eax)
  8035d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035db:	8b 00                	mov    (%eax),%eax
  8035dd:	85 c0                	test   %eax,%eax
  8035df:	75 08                	jne    8035e9 <realloc_block_FF+0x440>
  8035e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8035ee:	40                   	inc    %eax
  8035ef:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035f4:	eb 36                	jmp    80362c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035f6:	a1 34 50 80 00       	mov    0x805034,%eax
  8035fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803602:	74 07                	je     80360b <realloc_block_FF+0x462>
  803604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803607:	8b 00                	mov    (%eax),%eax
  803609:	eb 05                	jmp    803610 <realloc_block_FF+0x467>
  80360b:	b8 00 00 00 00       	mov    $0x0,%eax
  803610:	a3 34 50 80 00       	mov    %eax,0x805034
  803615:	a1 34 50 80 00       	mov    0x805034,%eax
  80361a:	85 c0                	test   %eax,%eax
  80361c:	0f 85 52 ff ff ff    	jne    803574 <realloc_block_FF+0x3cb>
  803622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803626:	0f 85 48 ff ff ff    	jne    803574 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80362c:	83 ec 04             	sub    $0x4,%esp
  80362f:	6a 00                	push   $0x0
  803631:	ff 75 d8             	pushl  -0x28(%ebp)
  803634:	ff 75 d4             	pushl  -0x2c(%ebp)
  803637:	e8 9d eb ff ff       	call   8021d9 <set_block_data>
  80363c:	83 c4 10             	add    $0x10,%esp
				return va;
  80363f:	8b 45 08             	mov    0x8(%ebp),%eax
  803642:	e9 6b 02 00 00       	jmp    8038b2 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	e9 63 02 00 00       	jmp    8038b2 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  80364f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803652:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803655:	0f 86 4d 02 00 00    	jbe    8038a8 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  80365b:	83 ec 0c             	sub    $0xc,%esp
  80365e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803661:	e8 3b e8 ff ff       	call   801ea1 <is_free_block>
  803666:	83 c4 10             	add    $0x10,%esp
  803669:	84 c0                	test   %al,%al
  80366b:	0f 84 37 02 00 00    	je     8038a8 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803671:	8b 45 0c             	mov    0xc(%ebp),%eax
  803674:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803677:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80367a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80367d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803680:	76 38                	jbe    8036ba <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  803682:	83 ec 0c             	sub    $0xc,%esp
  803685:	ff 75 0c             	pushl  0xc(%ebp)
  803688:	e8 7b eb ff ff       	call   802208 <alloc_block_FF>
  80368d:	83 c4 10             	add    $0x10,%esp
  803690:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803693:	83 ec 08             	sub    $0x8,%esp
  803696:	ff 75 c0             	pushl  -0x40(%ebp)
  803699:	ff 75 08             	pushl  0x8(%ebp)
  80369c:	e8 c9 fa ff ff       	call   80316a <copy_data>
  8036a1:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8036a4:	83 ec 0c             	sub    $0xc,%esp
  8036a7:	ff 75 08             	pushl  0x8(%ebp)
  8036aa:	e8 fa f9 ff ff       	call   8030a9 <free_block>
  8036af:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036b2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036b5:	e9 f8 01 00 00       	jmp    8038b2 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036bd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8036c0:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8036c3:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8036c7:	0f 87 a0 00 00 00    	ja     80376d <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8036cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036d1:	75 17                	jne    8036ea <realloc_block_FF+0x541>
  8036d3:	83 ec 04             	sub    $0x4,%esp
  8036d6:	68 77 43 80 00       	push   $0x804377
  8036db:	68 38 02 00 00       	push   $0x238
  8036e0:	68 95 43 80 00       	push   $0x804395
  8036e5:	e8 40 02 00 00       	call   80392a <_panic>
  8036ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ed:	8b 00                	mov    (%eax),%eax
  8036ef:	85 c0                	test   %eax,%eax
  8036f1:	74 10                	je     803703 <realloc_block_FF+0x55a>
  8036f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f6:	8b 00                	mov    (%eax),%eax
  8036f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036fb:	8b 52 04             	mov    0x4(%edx),%edx
  8036fe:	89 50 04             	mov    %edx,0x4(%eax)
  803701:	eb 0b                	jmp    80370e <realloc_block_FF+0x565>
  803703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803706:	8b 40 04             	mov    0x4(%eax),%eax
  803709:	a3 30 50 80 00       	mov    %eax,0x805030
  80370e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803711:	8b 40 04             	mov    0x4(%eax),%eax
  803714:	85 c0                	test   %eax,%eax
  803716:	74 0f                	je     803727 <realloc_block_FF+0x57e>
  803718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371b:	8b 40 04             	mov    0x4(%eax),%eax
  80371e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803721:	8b 12                	mov    (%edx),%edx
  803723:	89 10                	mov    %edx,(%eax)
  803725:	eb 0a                	jmp    803731 <realloc_block_FF+0x588>
  803727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372a:	8b 00                	mov    (%eax),%eax
  80372c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803734:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80373a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803744:	a1 38 50 80 00       	mov    0x805038,%eax
  803749:	48                   	dec    %eax
  80374a:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80374f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803752:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803755:	01 d0                	add    %edx,%eax
  803757:	83 ec 04             	sub    $0x4,%esp
  80375a:	6a 01                	push   $0x1
  80375c:	50                   	push   %eax
  80375d:	ff 75 08             	pushl  0x8(%ebp)
  803760:	e8 74 ea ff ff       	call   8021d9 <set_block_data>
  803765:	83 c4 10             	add    $0x10,%esp
  803768:	e9 36 01 00 00       	jmp    8038a3 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80376d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803770:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803773:	01 d0                	add    %edx,%eax
  803775:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803778:	83 ec 04             	sub    $0x4,%esp
  80377b:	6a 01                	push   $0x1
  80377d:	ff 75 f0             	pushl  -0x10(%ebp)
  803780:	ff 75 08             	pushl  0x8(%ebp)
  803783:	e8 51 ea ff ff       	call   8021d9 <set_block_data>
  803788:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
  80378e:	83 e8 04             	sub    $0x4,%eax
  803791:	8b 00                	mov    (%eax),%eax
  803793:	83 e0 fe             	and    $0xfffffffe,%eax
  803796:	89 c2                	mov    %eax,%edx
  803798:	8b 45 08             	mov    0x8(%ebp),%eax
  80379b:	01 d0                	add    %edx,%eax
  80379d:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037a4:	74 06                	je     8037ac <realloc_block_FF+0x603>
  8037a6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037aa:	75 17                	jne    8037c3 <realloc_block_FF+0x61a>
  8037ac:	83 ec 04             	sub    $0x4,%esp
  8037af:	68 08 44 80 00       	push   $0x804408
  8037b4:	68 44 02 00 00       	push   $0x244
  8037b9:	68 95 43 80 00       	push   $0x804395
  8037be:	e8 67 01 00 00       	call   80392a <_panic>
  8037c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c6:	8b 10                	mov    (%eax),%edx
  8037c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037cb:	89 10                	mov    %edx,(%eax)
  8037cd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	85 c0                	test   %eax,%eax
  8037d4:	74 0b                	je     8037e1 <realloc_block_FF+0x638>
  8037d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d9:	8b 00                	mov    (%eax),%eax
  8037db:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037de:	89 50 04             	mov    %edx,0x4(%eax)
  8037e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037e7:	89 10                	mov    %edx,(%eax)
  8037e9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ef:	89 50 04             	mov    %edx,0x4(%eax)
  8037f2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037f5:	8b 00                	mov    (%eax),%eax
  8037f7:	85 c0                	test   %eax,%eax
  8037f9:	75 08                	jne    803803 <realloc_block_FF+0x65a>
  8037fb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803803:	a1 38 50 80 00       	mov    0x805038,%eax
  803808:	40                   	inc    %eax
  803809:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80380e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803812:	75 17                	jne    80382b <realloc_block_FF+0x682>
  803814:	83 ec 04             	sub    $0x4,%esp
  803817:	68 77 43 80 00       	push   $0x804377
  80381c:	68 45 02 00 00       	push   $0x245
  803821:	68 95 43 80 00       	push   $0x804395
  803826:	e8 ff 00 00 00       	call   80392a <_panic>
  80382b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382e:	8b 00                	mov    (%eax),%eax
  803830:	85 c0                	test   %eax,%eax
  803832:	74 10                	je     803844 <realloc_block_FF+0x69b>
  803834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803837:	8b 00                	mov    (%eax),%eax
  803839:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80383c:	8b 52 04             	mov    0x4(%edx),%edx
  80383f:	89 50 04             	mov    %edx,0x4(%eax)
  803842:	eb 0b                	jmp    80384f <realloc_block_FF+0x6a6>
  803844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803847:	8b 40 04             	mov    0x4(%eax),%eax
  80384a:	a3 30 50 80 00       	mov    %eax,0x805030
  80384f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803852:	8b 40 04             	mov    0x4(%eax),%eax
  803855:	85 c0                	test   %eax,%eax
  803857:	74 0f                	je     803868 <realloc_block_FF+0x6bf>
  803859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385c:	8b 40 04             	mov    0x4(%eax),%eax
  80385f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803862:	8b 12                	mov    (%edx),%edx
  803864:	89 10                	mov    %edx,(%eax)
  803866:	eb 0a                	jmp    803872 <realloc_block_FF+0x6c9>
  803868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386b:	8b 00                	mov    (%eax),%eax
  80386d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803875:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80387b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803885:	a1 38 50 80 00       	mov    0x805038,%eax
  80388a:	48                   	dec    %eax
  80388b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803890:	83 ec 04             	sub    $0x4,%esp
  803893:	6a 00                	push   $0x0
  803895:	ff 75 bc             	pushl  -0x44(%ebp)
  803898:	ff 75 b8             	pushl  -0x48(%ebp)
  80389b:	e8 39 e9 ff ff       	call   8021d9 <set_block_data>
  8038a0:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8038a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a6:	eb 0a                	jmp    8038b2 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8038a8:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038b2:	c9                   	leave  
  8038b3:	c3                   	ret    

008038b4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038b4:	55                   	push   %ebp
  8038b5:	89 e5                	mov    %esp,%ebp
  8038b7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038ba:	83 ec 04             	sub    $0x4,%esp
  8038bd:	68 74 44 80 00       	push   $0x804474
  8038c2:	68 58 02 00 00       	push   $0x258
  8038c7:	68 95 43 80 00       	push   $0x804395
  8038cc:	e8 59 00 00 00       	call   80392a <_panic>

008038d1 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038d1:	55                   	push   %ebp
  8038d2:	89 e5                	mov    %esp,%ebp
  8038d4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038d7:	83 ec 04             	sub    $0x4,%esp
  8038da:	68 9c 44 80 00       	push   $0x80449c
  8038df:	68 61 02 00 00       	push   $0x261
  8038e4:	68 95 43 80 00       	push   $0x804395
  8038e9:	e8 3c 00 00 00       	call   80392a <_panic>

008038ee <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8038ee:	55                   	push   %ebp
  8038ef:	89 e5                	mov    %esp,%ebp
  8038f1:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8038f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f7:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8038fa:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8038fe:	83 ec 0c             	sub    $0xc,%esp
  803901:	50                   	push   %eax
  803902:	e8 10 e1 ff ff       	call   801a17 <sys_cputc>
  803907:	83 c4 10             	add    $0x10,%esp
}
  80390a:	90                   	nop
  80390b:	c9                   	leave  
  80390c:	c3                   	ret    

0080390d <getchar>:


int
getchar(void)
{
  80390d:	55                   	push   %ebp
  80390e:	89 e5                	mov    %esp,%ebp
  803910:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803913:	e8 9b df ff ff       	call   8018b3 <sys_cgetc>
  803918:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80391b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80391e:	c9                   	leave  
  80391f:	c3                   	ret    

00803920 <iscons>:

int iscons(int fdnum)
{
  803920:	55                   	push   %ebp
  803921:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803923:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803928:	5d                   	pop    %ebp
  803929:	c3                   	ret    

0080392a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80392a:	55                   	push   %ebp
  80392b:	89 e5                	mov    %esp,%ebp
  80392d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803930:	8d 45 10             	lea    0x10(%ebp),%eax
  803933:	83 c0 04             	add    $0x4,%eax
  803936:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803939:	a1 60 50 98 00       	mov    0x985060,%eax
  80393e:	85 c0                	test   %eax,%eax
  803940:	74 16                	je     803958 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803942:	a1 60 50 98 00       	mov    0x985060,%eax
  803947:	83 ec 08             	sub    $0x8,%esp
  80394a:	50                   	push   %eax
  80394b:	68 c4 44 80 00       	push   $0x8044c4
  803950:	e8 35 ca ff ff       	call   80038a <cprintf>
  803955:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803958:	a1 00 50 80 00       	mov    0x805000,%eax
  80395d:	ff 75 0c             	pushl  0xc(%ebp)
  803960:	ff 75 08             	pushl  0x8(%ebp)
  803963:	50                   	push   %eax
  803964:	68 c9 44 80 00       	push   $0x8044c9
  803969:	e8 1c ca ff ff       	call   80038a <cprintf>
  80396e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803971:	8b 45 10             	mov    0x10(%ebp),%eax
  803974:	83 ec 08             	sub    $0x8,%esp
  803977:	ff 75 f4             	pushl  -0xc(%ebp)
  80397a:	50                   	push   %eax
  80397b:	e8 9f c9 ff ff       	call   80031f <vcprintf>
  803980:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803983:	83 ec 08             	sub    $0x8,%esp
  803986:	6a 00                	push   $0x0
  803988:	68 e5 44 80 00       	push   $0x8044e5
  80398d:	e8 8d c9 ff ff       	call   80031f <vcprintf>
  803992:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803995:	e8 0e c9 ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  80399a:	eb fe                	jmp    80399a <_panic+0x70>

0080399c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80399c:	55                   	push   %ebp
  80399d:	89 e5                	mov    %esp,%ebp
  80399f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8039a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8039a7:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039b0:	39 c2                	cmp    %eax,%edx
  8039b2:	74 14                	je     8039c8 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8039b4:	83 ec 04             	sub    $0x4,%esp
  8039b7:	68 e8 44 80 00       	push   $0x8044e8
  8039bc:	6a 26                	push   $0x26
  8039be:	68 34 45 80 00       	push   $0x804534
  8039c3:	e8 62 ff ff ff       	call   80392a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8039c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8039cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8039d6:	e9 c5 00 00 00       	jmp    803aa0 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8039db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e8:	01 d0                	add    %edx,%eax
  8039ea:	8b 00                	mov    (%eax),%eax
  8039ec:	85 c0                	test   %eax,%eax
  8039ee:	75 08                	jne    8039f8 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8039f0:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8039f3:	e9 a5 00 00 00       	jmp    803a9d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8039f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a06:	eb 69                	jmp    803a71 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a08:	a1 20 50 80 00       	mov    0x805020,%eax
  803a0d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a13:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a16:	89 d0                	mov    %edx,%eax
  803a18:	01 c0                	add    %eax,%eax
  803a1a:	01 d0                	add    %edx,%eax
  803a1c:	c1 e0 03             	shl    $0x3,%eax
  803a1f:	01 c8                	add    %ecx,%eax
  803a21:	8a 40 04             	mov    0x4(%eax),%al
  803a24:	84 c0                	test   %al,%al
  803a26:	75 46                	jne    803a6e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a28:	a1 20 50 80 00       	mov    0x805020,%eax
  803a2d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a36:	89 d0                	mov    %edx,%eax
  803a38:	01 c0                	add    %eax,%eax
  803a3a:	01 d0                	add    %edx,%eax
  803a3c:	c1 e0 03             	shl    $0x3,%eax
  803a3f:	01 c8                	add    %ecx,%eax
  803a41:	8b 00                	mov    (%eax),%eax
  803a43:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a46:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a4e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a53:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5d:	01 c8                	add    %ecx,%eax
  803a5f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a61:	39 c2                	cmp    %eax,%edx
  803a63:	75 09                	jne    803a6e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a65:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a6c:	eb 15                	jmp    803a83 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a6e:	ff 45 e8             	incl   -0x18(%ebp)
  803a71:	a1 20 50 80 00       	mov    0x805020,%eax
  803a76:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7f:	39 c2                	cmp    %eax,%edx
  803a81:	77 85                	ja     803a08 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a87:	75 14                	jne    803a9d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803a89:	83 ec 04             	sub    $0x4,%esp
  803a8c:	68 40 45 80 00       	push   $0x804540
  803a91:	6a 3a                	push   $0x3a
  803a93:	68 34 45 80 00       	push   $0x804534
  803a98:	e8 8d fe ff ff       	call   80392a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803a9d:	ff 45 f0             	incl   -0x10(%ebp)
  803aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803aa6:	0f 8c 2f ff ff ff    	jl     8039db <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803aac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ab3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803aba:	eb 26                	jmp    803ae2 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803abc:	a1 20 50 80 00       	mov    0x805020,%eax
  803ac1:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ac7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803aca:	89 d0                	mov    %edx,%eax
  803acc:	01 c0                	add    %eax,%eax
  803ace:	01 d0                	add    %edx,%eax
  803ad0:	c1 e0 03             	shl    $0x3,%eax
  803ad3:	01 c8                	add    %ecx,%eax
  803ad5:	8a 40 04             	mov    0x4(%eax),%al
  803ad8:	3c 01                	cmp    $0x1,%al
  803ada:	75 03                	jne    803adf <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803adc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803adf:	ff 45 e0             	incl   -0x20(%ebp)
  803ae2:	a1 20 50 80 00       	mov    0x805020,%eax
  803ae7:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803af0:	39 c2                	cmp    %eax,%edx
  803af2:	77 c8                	ja     803abc <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803afa:	74 14                	je     803b10 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803afc:	83 ec 04             	sub    $0x4,%esp
  803aff:	68 94 45 80 00       	push   $0x804594
  803b04:	6a 44                	push   $0x44
  803b06:	68 34 45 80 00       	push   $0x804534
  803b0b:	e8 1a fe ff ff       	call   80392a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b10:	90                   	nop
  803b11:	c9                   	leave  
  803b12:	c3                   	ret    
  803b13:	90                   	nop

00803b14 <__udivdi3>:
  803b14:	55                   	push   %ebp
  803b15:	57                   	push   %edi
  803b16:	56                   	push   %esi
  803b17:	53                   	push   %ebx
  803b18:	83 ec 1c             	sub    $0x1c,%esp
  803b1b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b1f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b2b:	89 ca                	mov    %ecx,%edx
  803b2d:	89 f8                	mov    %edi,%eax
  803b2f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b33:	85 f6                	test   %esi,%esi
  803b35:	75 2d                	jne    803b64 <__udivdi3+0x50>
  803b37:	39 cf                	cmp    %ecx,%edi
  803b39:	77 65                	ja     803ba0 <__udivdi3+0x8c>
  803b3b:	89 fd                	mov    %edi,%ebp
  803b3d:	85 ff                	test   %edi,%edi
  803b3f:	75 0b                	jne    803b4c <__udivdi3+0x38>
  803b41:	b8 01 00 00 00       	mov    $0x1,%eax
  803b46:	31 d2                	xor    %edx,%edx
  803b48:	f7 f7                	div    %edi
  803b4a:	89 c5                	mov    %eax,%ebp
  803b4c:	31 d2                	xor    %edx,%edx
  803b4e:	89 c8                	mov    %ecx,%eax
  803b50:	f7 f5                	div    %ebp
  803b52:	89 c1                	mov    %eax,%ecx
  803b54:	89 d8                	mov    %ebx,%eax
  803b56:	f7 f5                	div    %ebp
  803b58:	89 cf                	mov    %ecx,%edi
  803b5a:	89 fa                	mov    %edi,%edx
  803b5c:	83 c4 1c             	add    $0x1c,%esp
  803b5f:	5b                   	pop    %ebx
  803b60:	5e                   	pop    %esi
  803b61:	5f                   	pop    %edi
  803b62:	5d                   	pop    %ebp
  803b63:	c3                   	ret    
  803b64:	39 ce                	cmp    %ecx,%esi
  803b66:	77 28                	ja     803b90 <__udivdi3+0x7c>
  803b68:	0f bd fe             	bsr    %esi,%edi
  803b6b:	83 f7 1f             	xor    $0x1f,%edi
  803b6e:	75 40                	jne    803bb0 <__udivdi3+0x9c>
  803b70:	39 ce                	cmp    %ecx,%esi
  803b72:	72 0a                	jb     803b7e <__udivdi3+0x6a>
  803b74:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b78:	0f 87 9e 00 00 00    	ja     803c1c <__udivdi3+0x108>
  803b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b83:	89 fa                	mov    %edi,%edx
  803b85:	83 c4 1c             	add    $0x1c,%esp
  803b88:	5b                   	pop    %ebx
  803b89:	5e                   	pop    %esi
  803b8a:	5f                   	pop    %edi
  803b8b:	5d                   	pop    %ebp
  803b8c:	c3                   	ret    
  803b8d:	8d 76 00             	lea    0x0(%esi),%esi
  803b90:	31 ff                	xor    %edi,%edi
  803b92:	31 c0                	xor    %eax,%eax
  803b94:	89 fa                	mov    %edi,%edx
  803b96:	83 c4 1c             	add    $0x1c,%esp
  803b99:	5b                   	pop    %ebx
  803b9a:	5e                   	pop    %esi
  803b9b:	5f                   	pop    %edi
  803b9c:	5d                   	pop    %ebp
  803b9d:	c3                   	ret    
  803b9e:	66 90                	xchg   %ax,%ax
  803ba0:	89 d8                	mov    %ebx,%eax
  803ba2:	f7 f7                	div    %edi
  803ba4:	31 ff                	xor    %edi,%edi
  803ba6:	89 fa                	mov    %edi,%edx
  803ba8:	83 c4 1c             	add    $0x1c,%esp
  803bab:	5b                   	pop    %ebx
  803bac:	5e                   	pop    %esi
  803bad:	5f                   	pop    %edi
  803bae:	5d                   	pop    %ebp
  803baf:	c3                   	ret    
  803bb0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bb5:	89 eb                	mov    %ebp,%ebx
  803bb7:	29 fb                	sub    %edi,%ebx
  803bb9:	89 f9                	mov    %edi,%ecx
  803bbb:	d3 e6                	shl    %cl,%esi
  803bbd:	89 c5                	mov    %eax,%ebp
  803bbf:	88 d9                	mov    %bl,%cl
  803bc1:	d3 ed                	shr    %cl,%ebp
  803bc3:	89 e9                	mov    %ebp,%ecx
  803bc5:	09 f1                	or     %esi,%ecx
  803bc7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bcb:	89 f9                	mov    %edi,%ecx
  803bcd:	d3 e0                	shl    %cl,%eax
  803bcf:	89 c5                	mov    %eax,%ebp
  803bd1:	89 d6                	mov    %edx,%esi
  803bd3:	88 d9                	mov    %bl,%cl
  803bd5:	d3 ee                	shr    %cl,%esi
  803bd7:	89 f9                	mov    %edi,%ecx
  803bd9:	d3 e2                	shl    %cl,%edx
  803bdb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bdf:	88 d9                	mov    %bl,%cl
  803be1:	d3 e8                	shr    %cl,%eax
  803be3:	09 c2                	or     %eax,%edx
  803be5:	89 d0                	mov    %edx,%eax
  803be7:	89 f2                	mov    %esi,%edx
  803be9:	f7 74 24 0c          	divl   0xc(%esp)
  803bed:	89 d6                	mov    %edx,%esi
  803bef:	89 c3                	mov    %eax,%ebx
  803bf1:	f7 e5                	mul    %ebp
  803bf3:	39 d6                	cmp    %edx,%esi
  803bf5:	72 19                	jb     803c10 <__udivdi3+0xfc>
  803bf7:	74 0b                	je     803c04 <__udivdi3+0xf0>
  803bf9:	89 d8                	mov    %ebx,%eax
  803bfb:	31 ff                	xor    %edi,%edi
  803bfd:	e9 58 ff ff ff       	jmp    803b5a <__udivdi3+0x46>
  803c02:	66 90                	xchg   %ax,%ax
  803c04:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c08:	89 f9                	mov    %edi,%ecx
  803c0a:	d3 e2                	shl    %cl,%edx
  803c0c:	39 c2                	cmp    %eax,%edx
  803c0e:	73 e9                	jae    803bf9 <__udivdi3+0xe5>
  803c10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c13:	31 ff                	xor    %edi,%edi
  803c15:	e9 40 ff ff ff       	jmp    803b5a <__udivdi3+0x46>
  803c1a:	66 90                	xchg   %ax,%ax
  803c1c:	31 c0                	xor    %eax,%eax
  803c1e:	e9 37 ff ff ff       	jmp    803b5a <__udivdi3+0x46>
  803c23:	90                   	nop

00803c24 <__umoddi3>:
  803c24:	55                   	push   %ebp
  803c25:	57                   	push   %edi
  803c26:	56                   	push   %esi
  803c27:	53                   	push   %ebx
  803c28:	83 ec 1c             	sub    $0x1c,%esp
  803c2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c43:	89 f3                	mov    %esi,%ebx
  803c45:	89 fa                	mov    %edi,%edx
  803c47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c4b:	89 34 24             	mov    %esi,(%esp)
  803c4e:	85 c0                	test   %eax,%eax
  803c50:	75 1a                	jne    803c6c <__umoddi3+0x48>
  803c52:	39 f7                	cmp    %esi,%edi
  803c54:	0f 86 a2 00 00 00    	jbe    803cfc <__umoddi3+0xd8>
  803c5a:	89 c8                	mov    %ecx,%eax
  803c5c:	89 f2                	mov    %esi,%edx
  803c5e:	f7 f7                	div    %edi
  803c60:	89 d0                	mov    %edx,%eax
  803c62:	31 d2                	xor    %edx,%edx
  803c64:	83 c4 1c             	add    $0x1c,%esp
  803c67:	5b                   	pop    %ebx
  803c68:	5e                   	pop    %esi
  803c69:	5f                   	pop    %edi
  803c6a:	5d                   	pop    %ebp
  803c6b:	c3                   	ret    
  803c6c:	39 f0                	cmp    %esi,%eax
  803c6e:	0f 87 ac 00 00 00    	ja     803d20 <__umoddi3+0xfc>
  803c74:	0f bd e8             	bsr    %eax,%ebp
  803c77:	83 f5 1f             	xor    $0x1f,%ebp
  803c7a:	0f 84 ac 00 00 00    	je     803d2c <__umoddi3+0x108>
  803c80:	bf 20 00 00 00       	mov    $0x20,%edi
  803c85:	29 ef                	sub    %ebp,%edi
  803c87:	89 fe                	mov    %edi,%esi
  803c89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c8d:	89 e9                	mov    %ebp,%ecx
  803c8f:	d3 e0                	shl    %cl,%eax
  803c91:	89 d7                	mov    %edx,%edi
  803c93:	89 f1                	mov    %esi,%ecx
  803c95:	d3 ef                	shr    %cl,%edi
  803c97:	09 c7                	or     %eax,%edi
  803c99:	89 e9                	mov    %ebp,%ecx
  803c9b:	d3 e2                	shl    %cl,%edx
  803c9d:	89 14 24             	mov    %edx,(%esp)
  803ca0:	89 d8                	mov    %ebx,%eax
  803ca2:	d3 e0                	shl    %cl,%eax
  803ca4:	89 c2                	mov    %eax,%edx
  803ca6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803caa:	d3 e0                	shl    %cl,%eax
  803cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cb0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cb4:	89 f1                	mov    %esi,%ecx
  803cb6:	d3 e8                	shr    %cl,%eax
  803cb8:	09 d0                	or     %edx,%eax
  803cba:	d3 eb                	shr    %cl,%ebx
  803cbc:	89 da                	mov    %ebx,%edx
  803cbe:	f7 f7                	div    %edi
  803cc0:	89 d3                	mov    %edx,%ebx
  803cc2:	f7 24 24             	mull   (%esp)
  803cc5:	89 c6                	mov    %eax,%esi
  803cc7:	89 d1                	mov    %edx,%ecx
  803cc9:	39 d3                	cmp    %edx,%ebx
  803ccb:	0f 82 87 00 00 00    	jb     803d58 <__umoddi3+0x134>
  803cd1:	0f 84 91 00 00 00    	je     803d68 <__umoddi3+0x144>
  803cd7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cdb:	29 f2                	sub    %esi,%edx
  803cdd:	19 cb                	sbb    %ecx,%ebx
  803cdf:	89 d8                	mov    %ebx,%eax
  803ce1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ce5:	d3 e0                	shl    %cl,%eax
  803ce7:	89 e9                	mov    %ebp,%ecx
  803ce9:	d3 ea                	shr    %cl,%edx
  803ceb:	09 d0                	or     %edx,%eax
  803ced:	89 e9                	mov    %ebp,%ecx
  803cef:	d3 eb                	shr    %cl,%ebx
  803cf1:	89 da                	mov    %ebx,%edx
  803cf3:	83 c4 1c             	add    $0x1c,%esp
  803cf6:	5b                   	pop    %ebx
  803cf7:	5e                   	pop    %esi
  803cf8:	5f                   	pop    %edi
  803cf9:	5d                   	pop    %ebp
  803cfa:	c3                   	ret    
  803cfb:	90                   	nop
  803cfc:	89 fd                	mov    %edi,%ebp
  803cfe:	85 ff                	test   %edi,%edi
  803d00:	75 0b                	jne    803d0d <__umoddi3+0xe9>
  803d02:	b8 01 00 00 00       	mov    $0x1,%eax
  803d07:	31 d2                	xor    %edx,%edx
  803d09:	f7 f7                	div    %edi
  803d0b:	89 c5                	mov    %eax,%ebp
  803d0d:	89 f0                	mov    %esi,%eax
  803d0f:	31 d2                	xor    %edx,%edx
  803d11:	f7 f5                	div    %ebp
  803d13:	89 c8                	mov    %ecx,%eax
  803d15:	f7 f5                	div    %ebp
  803d17:	89 d0                	mov    %edx,%eax
  803d19:	e9 44 ff ff ff       	jmp    803c62 <__umoddi3+0x3e>
  803d1e:	66 90                	xchg   %ax,%ax
  803d20:	89 c8                	mov    %ecx,%eax
  803d22:	89 f2                	mov    %esi,%edx
  803d24:	83 c4 1c             	add    $0x1c,%esp
  803d27:	5b                   	pop    %ebx
  803d28:	5e                   	pop    %esi
  803d29:	5f                   	pop    %edi
  803d2a:	5d                   	pop    %ebp
  803d2b:	c3                   	ret    
  803d2c:	3b 04 24             	cmp    (%esp),%eax
  803d2f:	72 06                	jb     803d37 <__umoddi3+0x113>
  803d31:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d35:	77 0f                	ja     803d46 <__umoddi3+0x122>
  803d37:	89 f2                	mov    %esi,%edx
  803d39:	29 f9                	sub    %edi,%ecx
  803d3b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d3f:	89 14 24             	mov    %edx,(%esp)
  803d42:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d46:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d4a:	8b 14 24             	mov    (%esp),%edx
  803d4d:	83 c4 1c             	add    $0x1c,%esp
  803d50:	5b                   	pop    %ebx
  803d51:	5e                   	pop    %esi
  803d52:	5f                   	pop    %edi
  803d53:	5d                   	pop    %ebp
  803d54:	c3                   	ret    
  803d55:	8d 76 00             	lea    0x0(%esi),%esi
  803d58:	2b 04 24             	sub    (%esp),%eax
  803d5b:	19 fa                	sbb    %edi,%edx
  803d5d:	89 d1                	mov    %edx,%ecx
  803d5f:	89 c6                	mov    %eax,%esi
  803d61:	e9 71 ff ff ff       	jmp    803cd7 <__umoddi3+0xb3>
  803d66:	66 90                	xchg   %ax,%ax
  803d68:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d6c:	72 ea                	jb     803d58 <__umoddi3+0x134>
  803d6e:	89 d9                	mov    %ebx,%ecx
  803d70:	e9 62 ff ff ff       	jmp    803cd7 <__umoddi3+0xb3>
