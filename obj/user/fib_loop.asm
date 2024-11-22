
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
  800052:	68 60 3d 80 00       	push   $0x803d60
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
  8000bc:	68 7e 3d 80 00       	push   $0x803d7e
  8000c1:	e8 f1 02 00 00       	call   8003b7 <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 5d 1b 00 00       	call   801c2b <inctst>
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
  80017d:	e8 6b 19 00 00       	call   801aed <sys_getenvindex>
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
  8001eb:	e8 81 16 00 00       	call   801871 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 ac 3d 80 00       	push   $0x803dac
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
  80021b:	68 d4 3d 80 00       	push   $0x803dd4
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
  80024c:	68 fc 3d 80 00       	push   $0x803dfc
  800251:	e8 34 01 00 00       	call   80038a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 54 3e 80 00       	push   $0x803e54
  80026d:	e8 18 01 00 00       	call   80038a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 ac 3d 80 00       	push   $0x803dac
  80027d:	e8 08 01 00 00       	call   80038a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800285:	e8 01 16 00 00       	call   80188b <sys_unlock_cons>
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
  80029d:	e8 17 18 00 00       	call   801ab9 <sys_destroy_env>
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
  8002ae:	e8 6c 18 00 00       	call   801b1f <sys_exit_env>
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
  8002fc:	e8 2e 15 00 00       	call   80182f <sys_cputs>
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
  800373:	e8 b7 14 00 00       	call   80182f <sys_cputs>
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
  8003bd:	e8 af 14 00 00       	call   801871 <sys_lock_cons>
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
  8003dd:	e8 a9 14 00 00       	call   80188b <sys_unlock_cons>
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
  800427:	e8 c0 36 00 00       	call   803aec <__udivdi3>
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
  800477:	e8 80 37 00 00       	call   803bfc <__umoddi3>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	05 94 40 80 00       	add    $0x804094,%eax
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
  8005d2:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
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
  8006b3:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  8006ba:	85 f6                	test   %esi,%esi
  8006bc:	75 19                	jne    8006d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006be:	53                   	push   %ebx
  8006bf:	68 a5 40 80 00       	push   $0x8040a5
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
  8006d8:	68 ae 40 80 00       	push   $0x8040ae
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
  800705:	be b1 40 80 00       	mov    $0x8040b1,%esi
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
  800a30:	68 28 42 80 00       	push   $0x804228
  800a35:	e8 50 f9 ff ff       	call   80038a <cprintf>
  800a3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a44:	83 ec 0c             	sub    $0xc,%esp
  800a47:	6a 00                	push   $0x0
  800a49:	e8 aa 2e 00 00       	call   8038f8 <iscons>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a54:	e8 8c 2e 00 00       	call   8038e5 <getchar>
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
  800a72:	68 2b 42 80 00       	push   $0x80422b
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
  800a9f:	e8 22 2e 00 00       	call   8038c6 <cputchar>
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
  800ad6:	e8 eb 2d 00 00       	call   8038c6 <cputchar>
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
  800aff:	e8 c2 2d 00 00       	call   8038c6 <cputchar>
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
  800b23:	e8 49 0d 00 00       	call   801871 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b2c:	74 13                	je     800b41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 08             	pushl  0x8(%ebp)
  800b34:	68 28 42 80 00       	push   $0x804228
  800b39:	e8 4c f8 ff ff       	call   80038a <cprintf>
  800b3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b48:	83 ec 0c             	sub    $0xc,%esp
  800b4b:	6a 00                	push   $0x0
  800b4d:	e8 a6 2d 00 00       	call   8038f8 <iscons>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b58:	e8 88 2d 00 00       	call   8038e5 <getchar>
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
  800b76:	68 2b 42 80 00       	push   $0x80422b
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
  800ba3:	e8 1e 2d 00 00       	call   8038c6 <cputchar>
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
  800bda:	e8 e7 2c 00 00       	call   8038c6 <cputchar>
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
  800c03:	e8 be 2c 00 00       	call   8038c6 <cputchar>
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
  800c1e:	e8 68 0c 00 00       	call   80188b <sys_unlock_cons>
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
  801318:	68 3c 42 80 00       	push   $0x80423c
  80131d:	68 3f 01 00 00       	push   $0x13f
  801322:	68 5e 42 80 00       	push   $0x80425e
  801327:	e8 d6 25 00 00       	call   803902 <_panic>

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
  801338:	e8 9d 0a 00 00       	call   801dda <sys_sbrk>
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
  8013b3:	e8 a6 08 00 00       	call   801c5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	74 16                	je     8013d2 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 08             	pushl  0x8(%ebp)
  8013c2:	e8 e6 0d 00 00       	call   8021ad <alloc_block_FF>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013cd:	e9 8a 01 00 00       	jmp    80155c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013d2:	e8 b8 08 00 00       	call   801c8f <sys_isUHeapPlacementStrategyBESTFIT>
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	0f 84 7d 01 00 00    	je     80155c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013df:	83 ec 0c             	sub    $0xc,%esp
  8013e2:	ff 75 08             	pushl  0x8(%ebp)
  8013e5:	e8 7f 12 00 00       	call   802669 <alloc_block_BF>
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
  801435:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801482:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  8014d9:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  80153b:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801542:	83 ec 08             	sub    $0x8,%esp
  801545:	ff 75 08             	pushl  0x8(%ebp)
  801548:	ff 75 f0             	pushl  -0x10(%ebp)
  80154b:	e8 c1 08 00 00       	call   801e11 <sys_allocate_user_mem>
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
  801593:	e8 95 08 00 00       	call   801e2d <get_block_size>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 c8 1a 00 00       	call   803071 <free_block>
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
  8015de:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  80161b:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  80163b:	e8 b5 07 00 00       	call   801df5 <sys_free_user_mem>
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
  801649:	68 6c 42 80 00       	push   $0x80426c
  80164e:	68 84 00 00 00       	push   $0x84
  801653:	68 96 42 80 00       	push   $0x804296
  801658:	e8 a5 22 00 00       	call   803902 <_panic>
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
  80166f:	75 07                	jne    801678 <smalloc+0x19>
  801671:	b8 00 00 00 00       	mov    $0x0,%eax
  801676:	eb 74                	jmp    8016ec <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801678:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80167e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801685:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168b:	39 d0                	cmp    %edx,%eax
  80168d:	73 02                	jae    801691 <smalloc+0x32>
  80168f:	89 d0                	mov    %edx,%eax
  801691:	83 ec 0c             	sub    $0xc,%esp
  801694:	50                   	push   %eax
  801695:	e8 a8 fc ff ff       	call   801342 <malloc>
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8016a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016a4:	75 07                	jne    8016ad <smalloc+0x4e>
  8016a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ab:	eb 3f                	jmp    8016ec <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8016ad:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b4:	50                   	push   %eax
  8016b5:	ff 75 0c             	pushl  0xc(%ebp)
  8016b8:	ff 75 08             	pushl  0x8(%ebp)
  8016bb:	e8 3c 03 00 00       	call   8019fc <sys_createSharedObject>
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8016c6:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016ca:	74 06                	je     8016d2 <smalloc+0x73>
  8016cc:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016d0:	75 07                	jne    8016d9 <smalloc+0x7a>
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d7:	eb 13                	jmp    8016ec <smalloc+0x8d>
	 cprintf("153\n");
  8016d9:	83 ec 0c             	sub    $0xc,%esp
  8016dc:	68 a2 42 80 00       	push   $0x8042a2
  8016e1:	e8 a4 ec ff ff       	call   80038a <cprintf>
  8016e6:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8016e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016f4:	83 ec 08             	sub    $0x8,%esp
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	ff 75 08             	pushl  0x8(%ebp)
  8016fd:	e8 24 03 00 00       	call   801a26 <sys_getSizeOfSharedObject>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801708:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80170c:	75 07                	jne    801715 <sget+0x27>
  80170e:	b8 00 00 00 00       	mov    $0x0,%eax
  801713:	eb 5c                	jmp    801771 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801718:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80171b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801722:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801728:	39 d0                	cmp    %edx,%eax
  80172a:	7d 02                	jge    80172e <sget+0x40>
  80172c:	89 d0                	mov    %edx,%eax
  80172e:	83 ec 0c             	sub    $0xc,%esp
  801731:	50                   	push   %eax
  801732:	e8 0b fc ff ff       	call   801342 <malloc>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80173d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801741:	75 07                	jne    80174a <sget+0x5c>
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
  801748:	eb 27                	jmp    801771 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80174a:	83 ec 04             	sub    $0x4,%esp
  80174d:	ff 75 e8             	pushl  -0x18(%ebp)
  801750:	ff 75 0c             	pushl  0xc(%ebp)
  801753:	ff 75 08             	pushl  0x8(%ebp)
  801756:	e8 e8 02 00 00       	call   801a43 <sys_getSharedObject>
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801761:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801765:	75 07                	jne    80176e <sget+0x80>
  801767:	b8 00 00 00 00       	mov    $0x0,%eax
  80176c:	eb 03                	jmp    801771 <sget+0x83>
	return ptr;
  80176e:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	68 a8 42 80 00       	push   $0x8042a8
  801781:	68 c2 00 00 00       	push   $0xc2
  801786:	68 96 42 80 00       	push   $0x804296
  80178b:	e8 72 21 00 00       	call   803902 <_panic>

00801790 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	68 cc 42 80 00       	push   $0x8042cc
  80179e:	68 d9 00 00 00       	push   $0xd9
  8017a3:	68 96 42 80 00       	push   $0x804296
  8017a8:	e8 55 21 00 00       	call   803902 <_panic>

008017ad <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	68 f2 42 80 00       	push   $0x8042f2
  8017bb:	68 e5 00 00 00       	push   $0xe5
  8017c0:	68 96 42 80 00       	push   $0x804296
  8017c5:	e8 38 21 00 00       	call   803902 <_panic>

008017ca <shrink>:

}
void shrink(uint32 newSize)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	68 f2 42 80 00       	push   $0x8042f2
  8017d8:	68 ea 00 00 00       	push   $0xea
  8017dd:	68 96 42 80 00       	push   $0x804296
  8017e2:	e8 1b 21 00 00       	call   803902 <_panic>

008017e7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	68 f2 42 80 00       	push   $0x8042f2
  8017f5:	68 ef 00 00 00       	push   $0xef
  8017fa:	68 96 42 80 00       	push   $0x804296
  8017ff:	e8 fe 20 00 00       	call   803902 <_panic>

00801804 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	57                   	push   %edi
  801808:	56                   	push   %esi
  801809:	53                   	push   %ebx
  80180a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8b 55 0c             	mov    0xc(%ebp),%edx
  801813:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801816:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801819:	8b 7d 18             	mov    0x18(%ebp),%edi
  80181c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80181f:	cd 30                	int    $0x30
  801821:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801824:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801827:	83 c4 10             	add    $0x10,%esp
  80182a:	5b                   	pop    %ebx
  80182b:	5e                   	pop    %esi
  80182c:	5f                   	pop    %edi
  80182d:	5d                   	pop    %ebp
  80182e:	c3                   	ret    

0080182f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80183b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	52                   	push   %edx
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	50                   	push   %eax
  80184b:	6a 00                	push   $0x0
  80184d:	e8 b2 ff ff ff       	call   801804 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	90                   	nop
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_cgetc>:

int
sys_cgetc(void)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 02                	push   $0x2
  801867:	e8 98 ff ff ff       	call   801804 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 03                	push   $0x3
  801880:	e8 7f ff ff ff       	call   801804 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	90                   	nop
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 04                	push   $0x4
  80189a:	e8 65 ff ff ff       	call   801804 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	90                   	nop
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	52                   	push   %edx
  8018b5:	50                   	push   %eax
  8018b6:	6a 08                	push   $0x8
  8018b8:	e8 47 ff ff ff       	call   801804 <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	56                   	push   %esi
  8018c6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c7:	8b 75 18             	mov    0x18(%ebp),%esi
  8018ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	56                   	push   %esi
  8018d7:	53                   	push   %ebx
  8018d8:	51                   	push   %ecx
  8018d9:	52                   	push   %edx
  8018da:	50                   	push   %eax
  8018db:	6a 09                	push   $0x9
  8018dd:	e8 22 ff ff ff       	call   801804 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e8:	5b                   	pop    %ebx
  8018e9:	5e                   	pop    %esi
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    

008018ec <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	52                   	push   %edx
  8018fc:	50                   	push   %eax
  8018fd:	6a 0a                	push   $0xa
  8018ff:	e8 00 ff ff ff       	call   801804 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	ff 75 0c             	pushl  0xc(%ebp)
  801915:	ff 75 08             	pushl  0x8(%ebp)
  801918:	6a 0b                	push   $0xb
  80191a:	e8 e5 fe ff ff       	call   801804 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 0c                	push   $0xc
  801933:	e8 cc fe ff ff       	call   801804 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 0d                	push   $0xd
  80194c:	e8 b3 fe ff ff       	call   801804 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 0e                	push   $0xe
  801965:	e8 9a fe ff ff       	call   801804 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 0f                	push   $0xf
  80197e:	e8 81 fe ff ff       	call   801804 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	ff 75 08             	pushl  0x8(%ebp)
  801996:	6a 10                	push   $0x10
  801998:	e8 67 fe ff ff       	call   801804 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 11                	push   $0x11
  8019b1:	e8 4e fe ff ff       	call   801804 <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	90                   	nop
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_cputc>:

void
sys_cputc(const char c)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 04             	sub    $0x4,%esp
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019c8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	50                   	push   %eax
  8019d5:	6a 01                	push   $0x1
  8019d7:	e8 28 fe ff ff       	call   801804 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	90                   	nop
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 14                	push   $0x14
  8019f1:	e8 0e fe ff ff       	call   801804 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	90                   	nop
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	8b 45 10             	mov    0x10(%ebp),%eax
  801a05:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a08:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a0b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	51                   	push   %ecx
  801a15:	52                   	push   %edx
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	50                   	push   %eax
  801a1a:	6a 15                	push   $0x15
  801a1c:	e8 e3 fd ff ff       	call   801804 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	52                   	push   %edx
  801a36:	50                   	push   %eax
  801a37:	6a 16                	push   $0x16
  801a39:	e8 c6 fd ff ff       	call   801804 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	51                   	push   %ecx
  801a54:	52                   	push   %edx
  801a55:	50                   	push   %eax
  801a56:	6a 17                	push   $0x17
  801a58:	e8 a7 fd ff ff       	call   801804 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	52                   	push   %edx
  801a72:	50                   	push   %eax
  801a73:	6a 18                	push   $0x18
  801a75:	e8 8a fd ff ff       	call   801804 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	6a 00                	push   $0x0
  801a87:	ff 75 14             	pushl  0x14(%ebp)
  801a8a:	ff 75 10             	pushl  0x10(%ebp)
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	50                   	push   %eax
  801a91:	6a 19                	push   $0x19
  801a93:	e8 6c fd ff ff       	call   801804 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	50                   	push   %eax
  801aac:	6a 1a                	push   $0x1a
  801aae:	e8 51 fd ff ff       	call   801804 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	90                   	nop
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	50                   	push   %eax
  801ac8:	6a 1b                	push   $0x1b
  801aca:	e8 35 fd ff ff       	call   801804 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 05                	push   $0x5
  801ae3:	e8 1c fd ff ff       	call   801804 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 06                	push   $0x6
  801afc:	e8 03 fd ff ff       	call   801804 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 07                	push   $0x7
  801b15:	e8 ea fc ff ff       	call   801804 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_exit_env>:


void sys_exit_env(void)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 1c                	push   $0x1c
  801b2e:	e8 d1 fc ff ff       	call   801804 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	90                   	nop
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b3f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b42:	8d 50 04             	lea    0x4(%eax),%edx
  801b45:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	52                   	push   %edx
  801b4f:	50                   	push   %eax
  801b50:	6a 1d                	push   $0x1d
  801b52:	e8 ad fc ff ff       	call   801804 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
	return result;
  801b5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b63:	89 01                	mov    %eax,(%ecx)
  801b65:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	c9                   	leave  
  801b6c:	c2 04 00             	ret    $0x4

00801b6f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	ff 75 10             	pushl  0x10(%ebp)
  801b79:	ff 75 0c             	pushl  0xc(%ebp)
  801b7c:	ff 75 08             	pushl  0x8(%ebp)
  801b7f:	6a 13                	push   $0x13
  801b81:	e8 7e fc ff ff       	call   801804 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
	return ;
  801b89:	90                   	nop
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_rcr2>:
uint32 sys_rcr2()
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 1e                	push   $0x1e
  801b9b:	e8 64 fc ff ff       	call   801804 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 04             	sub    $0x4,%esp
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bb1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	50                   	push   %eax
  801bbe:	6a 1f                	push   $0x1f
  801bc0:	e8 3f fc ff ff       	call   801804 <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc8:	90                   	nop
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <rsttst>:
void rsttst()
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 21                	push   $0x21
  801bda:	e8 25 fc ff ff       	call   801804 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801be2:	90                   	nop
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 04             	sub    $0x4,%esp
  801beb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bf1:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf8:	52                   	push   %edx
  801bf9:	50                   	push   %eax
  801bfa:	ff 75 10             	pushl  0x10(%ebp)
  801bfd:	ff 75 0c             	pushl  0xc(%ebp)
  801c00:	ff 75 08             	pushl  0x8(%ebp)
  801c03:	6a 20                	push   $0x20
  801c05:	e8 fa fb ff ff       	call   801804 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0d:	90                   	nop
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <chktst>:
void chktst(uint32 n)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	ff 75 08             	pushl  0x8(%ebp)
  801c1e:	6a 22                	push   $0x22
  801c20:	e8 df fb ff ff       	call   801804 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
	return ;
  801c28:	90                   	nop
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <inctst>:

void inctst()
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 23                	push   $0x23
  801c3a:	e8 c5 fb ff ff       	call   801804 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c42:	90                   	nop
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <gettst>:
uint32 gettst()
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 24                	push   $0x24
  801c54:	e8 ab fb ff ff       	call   801804 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 25                	push   $0x25
  801c70:	e8 8f fb ff ff       	call   801804 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
  801c78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c7b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c7f:	75 07                	jne    801c88 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c81:	b8 01 00 00 00       	mov    $0x1,%eax
  801c86:	eb 05                	jmp    801c8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 25                	push   $0x25
  801ca1:	e8 5e fb ff ff       	call   801804 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
  801ca9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cac:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cb0:	75 07                	jne    801cb9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb7:	eb 05                	jmp    801cbe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 25                	push   $0x25
  801cd2:	e8 2d fb ff ff       	call   801804 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
  801cda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cdd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ce1:	75 07                	jne    801cea <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ce3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce8:	eb 05                	jmp    801cef <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cef:	c9                   	leave  
  801cf0:	c3                   	ret    

00801cf1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 25                	push   $0x25
  801d03:	e8 fc fa ff ff       	call   801804 <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
  801d0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d0e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d12:	75 07                	jne    801d1b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d14:	b8 01 00 00 00       	mov    $0x1,%eax
  801d19:	eb 05                	jmp    801d20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	ff 75 08             	pushl  0x8(%ebp)
  801d30:	6a 26                	push   $0x26
  801d32:	e8 cd fa ff ff       	call   801804 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3a:	90                   	nop
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d41:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	6a 00                	push   $0x0
  801d4f:	53                   	push   %ebx
  801d50:	51                   	push   %ecx
  801d51:	52                   	push   %edx
  801d52:	50                   	push   %eax
  801d53:	6a 27                	push   $0x27
  801d55:	e8 aa fa ff ff       	call   801804 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	52                   	push   %edx
  801d72:	50                   	push   %eax
  801d73:	6a 28                	push   $0x28
  801d75:	e8 8a fa ff ff       	call   801804 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d82:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	6a 00                	push   $0x0
  801d8d:	51                   	push   %ecx
  801d8e:	ff 75 10             	pushl  0x10(%ebp)
  801d91:	52                   	push   %edx
  801d92:	50                   	push   %eax
  801d93:	6a 29                	push   $0x29
  801d95:	e8 6a fa ff ff       	call   801804 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	ff 75 10             	pushl  0x10(%ebp)
  801da9:	ff 75 0c             	pushl  0xc(%ebp)
  801dac:	ff 75 08             	pushl  0x8(%ebp)
  801daf:	6a 12                	push   $0x12
  801db1:	e8 4e fa ff ff       	call   801804 <syscall>
  801db6:	83 c4 18             	add    $0x18,%esp
	return ;
  801db9:	90                   	nop
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	52                   	push   %edx
  801dcc:	50                   	push   %eax
  801dcd:	6a 2a                	push   $0x2a
  801dcf:	e8 30 fa ff ff       	call   801804 <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
	return;
  801dd7:	90                   	nop
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	50                   	push   %eax
  801de9:	6a 2b                	push   $0x2b
  801deb:	e8 14 fa ff ff       	call   801804 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	ff 75 0c             	pushl  0xc(%ebp)
  801e01:	ff 75 08             	pushl  0x8(%ebp)
  801e04:	6a 2c                	push   $0x2c
  801e06:	e8 f9 f9 ff ff       	call   801804 <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
	return;
  801e0e:	90                   	nop
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	ff 75 0c             	pushl  0xc(%ebp)
  801e1d:	ff 75 08             	pushl  0x8(%ebp)
  801e20:	6a 2d                	push   $0x2d
  801e22:	e8 dd f9 ff ff       	call   801804 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
	return;
  801e2a:	90                   	nop
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e33:	8b 45 08             	mov    0x8(%ebp),%eax
  801e36:	83 e8 04             	sub    $0x4,%eax
  801e39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e3f:	8b 00                	mov    (%eax),%eax
  801e41:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	83 e8 04             	sub    $0x4,%eax
  801e52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e58:	8b 00                	mov    (%eax),%eax
  801e5a:	83 e0 01             	and    $0x1,%eax
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	0f 94 c0             	sete   %al
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
  801e67:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e74:	83 f8 02             	cmp    $0x2,%eax
  801e77:	74 2b                	je     801ea4 <alloc_block+0x40>
  801e79:	83 f8 02             	cmp    $0x2,%eax
  801e7c:	7f 07                	jg     801e85 <alloc_block+0x21>
  801e7e:	83 f8 01             	cmp    $0x1,%eax
  801e81:	74 0e                	je     801e91 <alloc_block+0x2d>
  801e83:	eb 58                	jmp    801edd <alloc_block+0x79>
  801e85:	83 f8 03             	cmp    $0x3,%eax
  801e88:	74 2d                	je     801eb7 <alloc_block+0x53>
  801e8a:	83 f8 04             	cmp    $0x4,%eax
  801e8d:	74 3b                	je     801eca <alloc_block+0x66>
  801e8f:	eb 4c                	jmp    801edd <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	ff 75 08             	pushl  0x8(%ebp)
  801e97:	e8 11 03 00 00       	call   8021ad <alloc_block_FF>
  801e9c:	83 c4 10             	add    $0x10,%esp
  801e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ea2:	eb 4a                	jmp    801eee <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ea4:	83 ec 0c             	sub    $0xc,%esp
  801ea7:	ff 75 08             	pushl  0x8(%ebp)
  801eaa:	e8 fa 19 00 00       	call   8038a9 <alloc_block_NF>
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eb5:	eb 37                	jmp    801eee <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801eb7:	83 ec 0c             	sub    $0xc,%esp
  801eba:	ff 75 08             	pushl  0x8(%ebp)
  801ebd:	e8 a7 07 00 00       	call   802669 <alloc_block_BF>
  801ec2:	83 c4 10             	add    $0x10,%esp
  801ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ec8:	eb 24                	jmp    801eee <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801eca:	83 ec 0c             	sub    $0xc,%esp
  801ecd:	ff 75 08             	pushl  0x8(%ebp)
  801ed0:	e8 b7 19 00 00       	call   80388c <alloc_block_WF>
  801ed5:	83 c4 10             	add    $0x10,%esp
  801ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801edb:	eb 11                	jmp    801eee <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	68 04 43 80 00       	push   $0x804304
  801ee5:	e8 a0 e4 ff ff       	call   80038a <cprintf>
  801eea:	83 c4 10             	add    $0x10,%esp
		break;
  801eed:	90                   	nop
	}
	return va;
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	53                   	push   %ebx
  801ef7:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801efa:	83 ec 0c             	sub    $0xc,%esp
  801efd:	68 24 43 80 00       	push   $0x804324
  801f02:	e8 83 e4 ff ff       	call   80038a <cprintf>
  801f07:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	68 4f 43 80 00       	push   $0x80434f
  801f12:	e8 73 e4 ff ff       	call   80038a <cprintf>
  801f17:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f20:	eb 37                	jmp    801f59 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f22:	83 ec 0c             	sub    $0xc,%esp
  801f25:	ff 75 f4             	pushl  -0xc(%ebp)
  801f28:	e8 19 ff ff ff       	call   801e46 <is_free_block>
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	0f be d8             	movsbl %al,%ebx
  801f33:	83 ec 0c             	sub    $0xc,%esp
  801f36:	ff 75 f4             	pushl  -0xc(%ebp)
  801f39:	e8 ef fe ff ff       	call   801e2d <get_block_size>
  801f3e:	83 c4 10             	add    $0x10,%esp
  801f41:	83 ec 04             	sub    $0x4,%esp
  801f44:	53                   	push   %ebx
  801f45:	50                   	push   %eax
  801f46:	68 67 43 80 00       	push   $0x804367
  801f4b:	e8 3a e4 ff ff       	call   80038a <cprintf>
  801f50:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f53:	8b 45 10             	mov    0x10(%ebp),%eax
  801f56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5d:	74 07                	je     801f66 <print_blocks_list+0x73>
  801f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f62:	8b 00                	mov    (%eax),%eax
  801f64:	eb 05                	jmp    801f6b <print_blocks_list+0x78>
  801f66:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6b:	89 45 10             	mov    %eax,0x10(%ebp)
  801f6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f71:	85 c0                	test   %eax,%eax
  801f73:	75 ad                	jne    801f22 <print_blocks_list+0x2f>
  801f75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f79:	75 a7                	jne    801f22 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	68 24 43 80 00       	push   $0x804324
  801f83:	e8 02 e4 ff ff       	call   80038a <cprintf>
  801f88:	83 c4 10             	add    $0x10,%esp

}
  801f8b:	90                   	nop
  801f8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9a:	83 e0 01             	and    $0x1,%eax
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	74 03                	je     801fa4 <initialize_dynamic_allocator+0x13>
  801fa1:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fa4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fa8:	0f 84 c7 01 00 00    	je     802175 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801fae:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801fb5:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801fb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbe:	01 d0                	add    %edx,%eax
  801fc0:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801fc5:	0f 87 ad 01 00 00    	ja     802178 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	0f 89 a5 01 00 00    	jns    80217b <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801fd6:	8b 55 08             	mov    0x8(%ebp),%edx
  801fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fdc:	01 d0                	add    %edx,%eax
  801fde:	83 e8 04             	sub    $0x4,%eax
  801fe1:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801fe6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801fed:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff5:	e9 87 00 00 00       	jmp    802081 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801ffa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffe:	75 14                	jne    802014 <initialize_dynamic_allocator+0x83>
  802000:	83 ec 04             	sub    $0x4,%esp
  802003:	68 7f 43 80 00       	push   $0x80437f
  802008:	6a 79                	push   $0x79
  80200a:	68 9d 43 80 00       	push   $0x80439d
  80200f:	e8 ee 18 00 00       	call   803902 <_panic>
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	8b 00                	mov    (%eax),%eax
  802019:	85 c0                	test   %eax,%eax
  80201b:	74 10                	je     80202d <initialize_dynamic_allocator+0x9c>
  80201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802020:	8b 00                	mov    (%eax),%eax
  802022:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802025:	8b 52 04             	mov    0x4(%edx),%edx
  802028:	89 50 04             	mov    %edx,0x4(%eax)
  80202b:	eb 0b                	jmp    802038 <initialize_dynamic_allocator+0xa7>
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	8b 40 04             	mov    0x4(%eax),%eax
  802033:	a3 30 50 80 00       	mov    %eax,0x805030
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	8b 40 04             	mov    0x4(%eax),%eax
  80203e:	85 c0                	test   %eax,%eax
  802040:	74 0f                	je     802051 <initialize_dynamic_allocator+0xc0>
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	8b 40 04             	mov    0x4(%eax),%eax
  802048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204b:	8b 12                	mov    (%edx),%edx
  80204d:	89 10                	mov    %edx,(%eax)
  80204f:	eb 0a                	jmp    80205b <initialize_dynamic_allocator+0xca>
  802051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802054:	8b 00                	mov    (%eax),%eax
  802056:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80205b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80206e:	a1 38 50 80 00       	mov    0x805038,%eax
  802073:	48                   	dec    %eax
  802074:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802079:	a1 34 50 80 00       	mov    0x805034,%eax
  80207e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802085:	74 07                	je     80208e <initialize_dynamic_allocator+0xfd>
  802087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208a:	8b 00                	mov    (%eax),%eax
  80208c:	eb 05                	jmp    802093 <initialize_dynamic_allocator+0x102>
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	a3 34 50 80 00       	mov    %eax,0x805034
  802098:	a1 34 50 80 00       	mov    0x805034,%eax
  80209d:	85 c0                	test   %eax,%eax
  80209f:	0f 85 55 ff ff ff    	jne    801ffa <initialize_dynamic_allocator+0x69>
  8020a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a9:	0f 85 4b ff ff ff    	jne    801ffa <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8020be:	a1 44 50 80 00       	mov    0x805044,%eax
  8020c3:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8020c8:	a1 40 50 80 00       	mov    0x805040,%eax
  8020cd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	83 c0 08             	add    $0x8,%eax
  8020d9:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	83 c0 04             	add    $0x4,%eax
  8020e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e5:	83 ea 08             	sub    $0x8,%edx
  8020e8:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	01 d0                	add    %edx,%eax
  8020f2:	83 e8 08             	sub    $0x8,%eax
  8020f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f8:	83 ea 08             	sub    $0x8,%edx
  8020fb:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802100:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802109:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802110:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802114:	75 17                	jne    80212d <initialize_dynamic_allocator+0x19c>
  802116:	83 ec 04             	sub    $0x4,%esp
  802119:	68 b8 43 80 00       	push   $0x8043b8
  80211e:	68 90 00 00 00       	push   $0x90
  802123:	68 9d 43 80 00       	push   $0x80439d
  802128:	e8 d5 17 00 00       	call   803902 <_panic>
  80212d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802133:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802136:	89 10                	mov    %edx,(%eax)
  802138:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213b:	8b 00                	mov    (%eax),%eax
  80213d:	85 c0                	test   %eax,%eax
  80213f:	74 0d                	je     80214e <initialize_dynamic_allocator+0x1bd>
  802141:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802146:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802149:	89 50 04             	mov    %edx,0x4(%eax)
  80214c:	eb 08                	jmp    802156 <initialize_dynamic_allocator+0x1c5>
  80214e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802151:	a3 30 50 80 00       	mov    %eax,0x805030
  802156:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802159:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80215e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802161:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802168:	a1 38 50 80 00       	mov    0x805038,%eax
  80216d:	40                   	inc    %eax
  80216e:	a3 38 50 80 00       	mov    %eax,0x805038
  802173:	eb 07                	jmp    80217c <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802175:	90                   	nop
  802176:	eb 04                	jmp    80217c <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802178:	90                   	nop
  802179:	eb 01                	jmp    80217c <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80217b:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802181:	8b 45 10             	mov    0x10(%ebp),%eax
  802184:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80218d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802190:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	83 e8 04             	sub    $0x4,%eax
  802198:	8b 00                	mov    (%eax),%eax
  80219a:	83 e0 fe             	and    $0xfffffffe,%eax
  80219d:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	01 c2                	add    %eax,%edx
  8021a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a8:	89 02                	mov    %eax,(%edx)
}
  8021aa:	90                   	nop
  8021ab:	5d                   	pop    %ebp
  8021ac:	c3                   	ret    

008021ad <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	83 e0 01             	and    $0x1,%eax
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	74 03                	je     8021c0 <alloc_block_FF+0x13>
  8021bd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8021c0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8021c4:	77 07                	ja     8021cd <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8021c6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	75 73                	jne    802249 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	83 c0 10             	add    $0x10,%eax
  8021dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021df:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8021e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ec:	01 d0                	add    %edx,%eax
  8021ee:	48                   	dec    %eax
  8021ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8021fa:	f7 75 ec             	divl   -0x14(%ebp)
  8021fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802200:	29 d0                	sub    %edx,%eax
  802202:	c1 e8 0c             	shr    $0xc,%eax
  802205:	83 ec 0c             	sub    $0xc,%esp
  802208:	50                   	push   %eax
  802209:	e8 1e f1 ff ff       	call   80132c <sbrk>
  80220e:	83 c4 10             	add    $0x10,%esp
  802211:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802214:	83 ec 0c             	sub    $0xc,%esp
  802217:	6a 00                	push   $0x0
  802219:	e8 0e f1 ff ff       	call   80132c <sbrk>
  80221e:	83 c4 10             	add    $0x10,%esp
  802221:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802224:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802227:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80222a:	83 ec 08             	sub    $0x8,%esp
  80222d:	50                   	push   %eax
  80222e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802231:	e8 5b fd ff ff       	call   801f91 <initialize_dynamic_allocator>
  802236:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802239:	83 ec 0c             	sub    $0xc,%esp
  80223c:	68 db 43 80 00       	push   $0x8043db
  802241:	e8 44 e1 ff ff       	call   80038a <cprintf>
  802246:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80224d:	75 0a                	jne    802259 <alloc_block_FF+0xac>
	        return NULL;
  80224f:	b8 00 00 00 00       	mov    $0x0,%eax
  802254:	e9 0e 04 00 00       	jmp    802667 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802260:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802265:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802268:	e9 f3 02 00 00       	jmp    802560 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802273:	83 ec 0c             	sub    $0xc,%esp
  802276:	ff 75 bc             	pushl  -0x44(%ebp)
  802279:	e8 af fb ff ff       	call   801e2d <get_block_size>
  80227e:	83 c4 10             	add    $0x10,%esp
  802281:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	83 c0 08             	add    $0x8,%eax
  80228a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80228d:	0f 87 c5 02 00 00    	ja     802558 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	83 c0 18             	add    $0x18,%eax
  802299:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80229c:	0f 87 19 02 00 00    	ja     8024bb <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022a5:	2b 45 08             	sub    0x8(%ebp),%eax
  8022a8:	83 e8 08             	sub    $0x8,%eax
  8022ab:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	8d 50 08             	lea    0x8(%eax),%edx
  8022b4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022b7:	01 d0                	add    %edx,%eax
  8022b9:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	83 c0 08             	add    $0x8,%eax
  8022c2:	83 ec 04             	sub    $0x4,%esp
  8022c5:	6a 01                	push   $0x1
  8022c7:	50                   	push   %eax
  8022c8:	ff 75 bc             	pushl  -0x44(%ebp)
  8022cb:	e8 ae fe ff ff       	call   80217e <set_block_data>
  8022d0:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d6:	8b 40 04             	mov    0x4(%eax),%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	75 68                	jne    802345 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022dd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022e1:	75 17                	jne    8022fa <alloc_block_FF+0x14d>
  8022e3:	83 ec 04             	sub    $0x4,%esp
  8022e6:	68 b8 43 80 00       	push   $0x8043b8
  8022eb:	68 d7 00 00 00       	push   $0xd7
  8022f0:	68 9d 43 80 00       	push   $0x80439d
  8022f5:	e8 08 16 00 00       	call   803902 <_panic>
  8022fa:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802300:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802303:	89 10                	mov    %edx,(%eax)
  802305:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802308:	8b 00                	mov    (%eax),%eax
  80230a:	85 c0                	test   %eax,%eax
  80230c:	74 0d                	je     80231b <alloc_block_FF+0x16e>
  80230e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802313:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802316:	89 50 04             	mov    %edx,0x4(%eax)
  802319:	eb 08                	jmp    802323 <alloc_block_FF+0x176>
  80231b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80231e:	a3 30 50 80 00       	mov    %eax,0x805030
  802323:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802326:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80232b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80232e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802335:	a1 38 50 80 00       	mov    0x805038,%eax
  80233a:	40                   	inc    %eax
  80233b:	a3 38 50 80 00       	mov    %eax,0x805038
  802340:	e9 dc 00 00 00       	jmp    802421 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 00                	mov    (%eax),%eax
  80234a:	85 c0                	test   %eax,%eax
  80234c:	75 65                	jne    8023b3 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80234e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802352:	75 17                	jne    80236b <alloc_block_FF+0x1be>
  802354:	83 ec 04             	sub    $0x4,%esp
  802357:	68 ec 43 80 00       	push   $0x8043ec
  80235c:	68 db 00 00 00       	push   $0xdb
  802361:	68 9d 43 80 00       	push   $0x80439d
  802366:	e8 97 15 00 00       	call   803902 <_panic>
  80236b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802371:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802374:	89 50 04             	mov    %edx,0x4(%eax)
  802377:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80237a:	8b 40 04             	mov    0x4(%eax),%eax
  80237d:	85 c0                	test   %eax,%eax
  80237f:	74 0c                	je     80238d <alloc_block_FF+0x1e0>
  802381:	a1 30 50 80 00       	mov    0x805030,%eax
  802386:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802389:	89 10                	mov    %edx,(%eax)
  80238b:	eb 08                	jmp    802395 <alloc_block_FF+0x1e8>
  80238d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802390:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802395:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802398:	a3 30 50 80 00       	mov    %eax,0x805030
  80239d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8023ab:	40                   	inc    %eax
  8023ac:	a3 38 50 80 00       	mov    %eax,0x805038
  8023b1:	eb 6e                	jmp    802421 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b7:	74 06                	je     8023bf <alloc_block_FF+0x212>
  8023b9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023bd:	75 17                	jne    8023d6 <alloc_block_FF+0x229>
  8023bf:	83 ec 04             	sub    $0x4,%esp
  8023c2:	68 10 44 80 00       	push   $0x804410
  8023c7:	68 df 00 00 00       	push   $0xdf
  8023cc:	68 9d 43 80 00       	push   $0x80439d
  8023d1:	e8 2c 15 00 00       	call   803902 <_panic>
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	8b 10                	mov    (%eax),%edx
  8023db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023de:	89 10                	mov    %edx,(%eax)
  8023e0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e3:	8b 00                	mov    (%eax),%eax
  8023e5:	85 c0                	test   %eax,%eax
  8023e7:	74 0b                	je     8023f4 <alloc_block_FF+0x247>
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023f1:	89 50 04             	mov    %edx,0x4(%eax)
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023fa:	89 10                	mov    %edx,(%eax)
  8023fc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802402:	89 50 04             	mov    %edx,0x4(%eax)
  802405:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802408:	8b 00                	mov    (%eax),%eax
  80240a:	85 c0                	test   %eax,%eax
  80240c:	75 08                	jne    802416 <alloc_block_FF+0x269>
  80240e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802411:	a3 30 50 80 00       	mov    %eax,0x805030
  802416:	a1 38 50 80 00       	mov    0x805038,%eax
  80241b:	40                   	inc    %eax
  80241c:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802425:	75 17                	jne    80243e <alloc_block_FF+0x291>
  802427:	83 ec 04             	sub    $0x4,%esp
  80242a:	68 7f 43 80 00       	push   $0x80437f
  80242f:	68 e1 00 00 00       	push   $0xe1
  802434:	68 9d 43 80 00       	push   $0x80439d
  802439:	e8 c4 14 00 00       	call   803902 <_panic>
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 00                	mov    (%eax),%eax
  802443:	85 c0                	test   %eax,%eax
  802445:	74 10                	je     802457 <alloc_block_FF+0x2aa>
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 00                	mov    (%eax),%eax
  80244c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244f:	8b 52 04             	mov    0x4(%edx),%edx
  802452:	89 50 04             	mov    %edx,0x4(%eax)
  802455:	eb 0b                	jmp    802462 <alloc_block_FF+0x2b5>
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 40 04             	mov    0x4(%eax),%eax
  80245d:	a3 30 50 80 00       	mov    %eax,0x805030
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 40 04             	mov    0x4(%eax),%eax
  802468:	85 c0                	test   %eax,%eax
  80246a:	74 0f                	je     80247b <alloc_block_FF+0x2ce>
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 04             	mov    0x4(%eax),%eax
  802472:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802475:	8b 12                	mov    (%edx),%edx
  802477:	89 10                	mov    %edx,(%eax)
  802479:	eb 0a                	jmp    802485 <alloc_block_FF+0x2d8>
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 00                	mov    (%eax),%eax
  802480:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802498:	a1 38 50 80 00       	mov    0x805038,%eax
  80249d:	48                   	dec    %eax
  80249e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024a3:	83 ec 04             	sub    $0x4,%esp
  8024a6:	6a 00                	push   $0x0
  8024a8:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024ab:	ff 75 b0             	pushl  -0x50(%ebp)
  8024ae:	e8 cb fc ff ff       	call   80217e <set_block_data>
  8024b3:	83 c4 10             	add    $0x10,%esp
  8024b6:	e9 95 00 00 00       	jmp    802550 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024bb:	83 ec 04             	sub    $0x4,%esp
  8024be:	6a 01                	push   $0x1
  8024c0:	ff 75 b8             	pushl  -0x48(%ebp)
  8024c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8024c6:	e8 b3 fc ff ff       	call   80217e <set_block_data>
  8024cb:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d2:	75 17                	jne    8024eb <alloc_block_FF+0x33e>
  8024d4:	83 ec 04             	sub    $0x4,%esp
  8024d7:	68 7f 43 80 00       	push   $0x80437f
  8024dc:	68 e8 00 00 00       	push   $0xe8
  8024e1:	68 9d 43 80 00       	push   $0x80439d
  8024e6:	e8 17 14 00 00       	call   803902 <_panic>
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 00                	mov    (%eax),%eax
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	74 10                	je     802504 <alloc_block_FF+0x357>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fc:	8b 52 04             	mov    0x4(%edx),%edx
  8024ff:	89 50 04             	mov    %edx,0x4(%eax)
  802502:	eb 0b                	jmp    80250f <alloc_block_FF+0x362>
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 40 04             	mov    0x4(%eax),%eax
  80250a:	a3 30 50 80 00       	mov    %eax,0x805030
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 40 04             	mov    0x4(%eax),%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	74 0f                	je     802528 <alloc_block_FF+0x37b>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 40 04             	mov    0x4(%eax),%eax
  80251f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802522:	8b 12                	mov    (%edx),%edx
  802524:	89 10                	mov    %edx,(%eax)
  802526:	eb 0a                	jmp    802532 <alloc_block_FF+0x385>
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 00                	mov    (%eax),%eax
  80252d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802545:	a1 38 50 80 00       	mov    0x805038,%eax
  80254a:	48                   	dec    %eax
  80254b:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802550:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802553:	e9 0f 01 00 00       	jmp    802667 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802558:	a1 34 50 80 00       	mov    0x805034,%eax
  80255d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802564:	74 07                	je     80256d <alloc_block_FF+0x3c0>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	eb 05                	jmp    802572 <alloc_block_FF+0x3c5>
  80256d:	b8 00 00 00 00       	mov    $0x0,%eax
  802572:	a3 34 50 80 00       	mov    %eax,0x805034
  802577:	a1 34 50 80 00       	mov    0x805034,%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	0f 85 e9 fc ff ff    	jne    80226d <alloc_block_FF+0xc0>
  802584:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802588:	0f 85 df fc ff ff    	jne    80226d <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	83 c0 08             	add    $0x8,%eax
  802594:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802597:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80259e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025a4:	01 d0                	add    %edx,%eax
  8025a6:	48                   	dec    %eax
  8025a7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b2:	f7 75 d8             	divl   -0x28(%ebp)
  8025b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025b8:	29 d0                	sub    %edx,%eax
  8025ba:	c1 e8 0c             	shr    $0xc,%eax
  8025bd:	83 ec 0c             	sub    $0xc,%esp
  8025c0:	50                   	push   %eax
  8025c1:	e8 66 ed ff ff       	call   80132c <sbrk>
  8025c6:	83 c4 10             	add    $0x10,%esp
  8025c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025cc:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025d0:	75 0a                	jne    8025dc <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d7:	e9 8b 00 00 00       	jmp    802667 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025dc:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025e9:	01 d0                	add    %edx,%eax
  8025eb:	48                   	dec    %eax
  8025ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f7:	f7 75 cc             	divl   -0x34(%ebp)
  8025fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025fd:	29 d0                	sub    %edx,%eax
  8025ff:	8d 50 fc             	lea    -0x4(%eax),%edx
  802602:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802605:	01 d0                	add    %edx,%eax
  802607:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80260c:	a1 40 50 80 00       	mov    0x805040,%eax
  802611:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802617:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80261e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802621:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802624:	01 d0                	add    %edx,%eax
  802626:	48                   	dec    %eax
  802627:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80262a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80262d:	ba 00 00 00 00       	mov    $0x0,%edx
  802632:	f7 75 c4             	divl   -0x3c(%ebp)
  802635:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802638:	29 d0                	sub    %edx,%eax
  80263a:	83 ec 04             	sub    $0x4,%esp
  80263d:	6a 01                	push   $0x1
  80263f:	50                   	push   %eax
  802640:	ff 75 d0             	pushl  -0x30(%ebp)
  802643:	e8 36 fb ff ff       	call   80217e <set_block_data>
  802648:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80264b:	83 ec 0c             	sub    $0xc,%esp
  80264e:	ff 75 d0             	pushl  -0x30(%ebp)
  802651:	e8 1b 0a 00 00       	call   803071 <free_block>
  802656:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802659:	83 ec 0c             	sub    $0xc,%esp
  80265c:	ff 75 08             	pushl  0x8(%ebp)
  80265f:	e8 49 fb ff ff       	call   8021ad <alloc_block_FF>
  802664:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	83 e0 01             	and    $0x1,%eax
  802675:	85 c0                	test   %eax,%eax
  802677:	74 03                	je     80267c <alloc_block_BF+0x13>
  802679:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80267c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802680:	77 07                	ja     802689 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802682:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802689:	a1 24 50 80 00       	mov    0x805024,%eax
  80268e:	85 c0                	test   %eax,%eax
  802690:	75 73                	jne    802705 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	83 c0 10             	add    $0x10,%eax
  802698:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80269b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a8:	01 d0                	add    %edx,%eax
  8026aa:	48                   	dec    %eax
  8026ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b6:	f7 75 e0             	divl   -0x20(%ebp)
  8026b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026bc:	29 d0                	sub    %edx,%eax
  8026be:	c1 e8 0c             	shr    $0xc,%eax
  8026c1:	83 ec 0c             	sub    $0xc,%esp
  8026c4:	50                   	push   %eax
  8026c5:	e8 62 ec ff ff       	call   80132c <sbrk>
  8026ca:	83 c4 10             	add    $0x10,%esp
  8026cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026d0:	83 ec 0c             	sub    $0xc,%esp
  8026d3:	6a 00                	push   $0x0
  8026d5:	e8 52 ec ff ff       	call   80132c <sbrk>
  8026da:	83 c4 10             	add    $0x10,%esp
  8026dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e3:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8026e6:	83 ec 08             	sub    $0x8,%esp
  8026e9:	50                   	push   %eax
  8026ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8026ed:	e8 9f f8 ff ff       	call   801f91 <initialize_dynamic_allocator>
  8026f2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026f5:	83 ec 0c             	sub    $0xc,%esp
  8026f8:	68 db 43 80 00       	push   $0x8043db
  8026fd:	e8 88 dc ff ff       	call   80038a <cprintf>
  802702:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802705:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80270c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802713:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80271a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802721:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802726:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802729:	e9 1d 01 00 00       	jmp    80284b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802734:	83 ec 0c             	sub    $0xc,%esp
  802737:	ff 75 a8             	pushl  -0x58(%ebp)
  80273a:	e8 ee f6 ff ff       	call   801e2d <get_block_size>
  80273f:	83 c4 10             	add    $0x10,%esp
  802742:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802745:	8b 45 08             	mov    0x8(%ebp),%eax
  802748:	83 c0 08             	add    $0x8,%eax
  80274b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80274e:	0f 87 ef 00 00 00    	ja     802843 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	83 c0 18             	add    $0x18,%eax
  80275a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80275d:	77 1d                	ja     80277c <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80275f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802762:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802765:	0f 86 d8 00 00 00    	jbe    802843 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80276b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80276e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802771:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802774:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802777:	e9 c7 00 00 00       	jmp    802843 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	83 c0 08             	add    $0x8,%eax
  802782:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802785:	0f 85 9d 00 00 00    	jne    802828 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80278b:	83 ec 04             	sub    $0x4,%esp
  80278e:	6a 01                	push   $0x1
  802790:	ff 75 a4             	pushl  -0x5c(%ebp)
  802793:	ff 75 a8             	pushl  -0x58(%ebp)
  802796:	e8 e3 f9 ff ff       	call   80217e <set_block_data>
  80279b:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80279e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a2:	75 17                	jne    8027bb <alloc_block_BF+0x152>
  8027a4:	83 ec 04             	sub    $0x4,%esp
  8027a7:	68 7f 43 80 00       	push   $0x80437f
  8027ac:	68 2c 01 00 00       	push   $0x12c
  8027b1:	68 9d 43 80 00       	push   $0x80439d
  8027b6:	e8 47 11 00 00       	call   803902 <_panic>
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	85 c0                	test   %eax,%eax
  8027c2:	74 10                	je     8027d4 <alloc_block_BF+0x16b>
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	8b 00                	mov    (%eax),%eax
  8027c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027cc:	8b 52 04             	mov    0x4(%edx),%edx
  8027cf:	89 50 04             	mov    %edx,0x4(%eax)
  8027d2:	eb 0b                	jmp    8027df <alloc_block_BF+0x176>
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 40 04             	mov    0x4(%eax),%eax
  8027da:	a3 30 50 80 00       	mov    %eax,0x805030
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 40 04             	mov    0x4(%eax),%eax
  8027e5:	85 c0                	test   %eax,%eax
  8027e7:	74 0f                	je     8027f8 <alloc_block_BF+0x18f>
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 04             	mov    0x4(%eax),%eax
  8027ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f2:	8b 12                	mov    (%edx),%edx
  8027f4:	89 10                	mov    %edx,(%eax)
  8027f6:	eb 0a                	jmp    802802 <alloc_block_BF+0x199>
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 00                	mov    (%eax),%eax
  8027fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802815:	a1 38 50 80 00       	mov    0x805038,%eax
  80281a:	48                   	dec    %eax
  80281b:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802820:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802823:	e9 24 04 00 00       	jmp    802c4c <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802828:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80282e:	76 13                	jbe    802843 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802830:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802837:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80283a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80283d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802840:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802843:	a1 34 50 80 00       	mov    0x805034,%eax
  802848:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284f:	74 07                	je     802858 <alloc_block_BF+0x1ef>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	eb 05                	jmp    80285d <alloc_block_BF+0x1f4>
  802858:	b8 00 00 00 00       	mov    $0x0,%eax
  80285d:	a3 34 50 80 00       	mov    %eax,0x805034
  802862:	a1 34 50 80 00       	mov    0x805034,%eax
  802867:	85 c0                	test   %eax,%eax
  802869:	0f 85 bf fe ff ff    	jne    80272e <alloc_block_BF+0xc5>
  80286f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802873:	0f 85 b5 fe ff ff    	jne    80272e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802879:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80287d:	0f 84 26 02 00 00    	je     802aa9 <alloc_block_BF+0x440>
  802883:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802887:	0f 85 1c 02 00 00    	jne    802aa9 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80288d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802890:	2b 45 08             	sub    0x8(%ebp),%eax
  802893:	83 e8 08             	sub    $0x8,%eax
  802896:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	8d 50 08             	lea    0x8(%eax),%edx
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	01 d0                	add    %edx,%eax
  8028a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8028a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028aa:	83 c0 08             	add    $0x8,%eax
  8028ad:	83 ec 04             	sub    $0x4,%esp
  8028b0:	6a 01                	push   $0x1
  8028b2:	50                   	push   %eax
  8028b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8028b6:	e8 c3 f8 ff ff       	call   80217e <set_block_data>
  8028bb:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8028be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	85 c0                	test   %eax,%eax
  8028c6:	75 68                	jne    802930 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028c8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028cc:	75 17                	jne    8028e5 <alloc_block_BF+0x27c>
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	68 b8 43 80 00       	push   $0x8043b8
  8028d6:	68 45 01 00 00       	push   $0x145
  8028db:	68 9d 43 80 00       	push   $0x80439d
  8028e0:	e8 1d 10 00 00       	call   803902 <_panic>
  8028e5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ee:	89 10                	mov    %edx,(%eax)
  8028f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 0d                	je     802906 <alloc_block_BF+0x29d>
  8028f9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028fe:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802901:	89 50 04             	mov    %edx,0x4(%eax)
  802904:	eb 08                	jmp    80290e <alloc_block_BF+0x2a5>
  802906:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802909:	a3 30 50 80 00       	mov    %eax,0x805030
  80290e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802911:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802916:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802919:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802920:	a1 38 50 80 00       	mov    0x805038,%eax
  802925:	40                   	inc    %eax
  802926:	a3 38 50 80 00       	mov    %eax,0x805038
  80292b:	e9 dc 00 00 00       	jmp    802a0c <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802933:	8b 00                	mov    (%eax),%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	75 65                	jne    80299e <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802939:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80293d:	75 17                	jne    802956 <alloc_block_BF+0x2ed>
  80293f:	83 ec 04             	sub    $0x4,%esp
  802942:	68 ec 43 80 00       	push   $0x8043ec
  802947:	68 4a 01 00 00       	push   $0x14a
  80294c:	68 9d 43 80 00       	push   $0x80439d
  802951:	e8 ac 0f 00 00       	call   803902 <_panic>
  802956:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80295c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295f:	89 50 04             	mov    %edx,0x4(%eax)
  802962:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802965:	8b 40 04             	mov    0x4(%eax),%eax
  802968:	85 c0                	test   %eax,%eax
  80296a:	74 0c                	je     802978 <alloc_block_BF+0x30f>
  80296c:	a1 30 50 80 00       	mov    0x805030,%eax
  802971:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802974:	89 10                	mov    %edx,(%eax)
  802976:	eb 08                	jmp    802980 <alloc_block_BF+0x317>
  802978:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802980:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802983:	a3 30 50 80 00       	mov    %eax,0x805030
  802988:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80298b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802991:	a1 38 50 80 00       	mov    0x805038,%eax
  802996:	40                   	inc    %eax
  802997:	a3 38 50 80 00       	mov    %eax,0x805038
  80299c:	eb 6e                	jmp    802a0c <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80299e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029a2:	74 06                	je     8029aa <alloc_block_BF+0x341>
  8029a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029a8:	75 17                	jne    8029c1 <alloc_block_BF+0x358>
  8029aa:	83 ec 04             	sub    $0x4,%esp
  8029ad:	68 10 44 80 00       	push   $0x804410
  8029b2:	68 4f 01 00 00       	push   $0x14f
  8029b7:	68 9d 43 80 00       	push   $0x80439d
  8029bc:	e8 41 0f 00 00       	call   803902 <_panic>
  8029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c4:	8b 10                	mov    (%eax),%edx
  8029c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c9:	89 10                	mov    %edx,(%eax)
  8029cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ce:	8b 00                	mov    (%eax),%eax
  8029d0:	85 c0                	test   %eax,%eax
  8029d2:	74 0b                	je     8029df <alloc_block_BF+0x376>
  8029d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029dc:	89 50 04             	mov    %edx,0x4(%eax)
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029e5:	89 10                	mov    %edx,(%eax)
  8029e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ed:	89 50 04             	mov    %edx,0x4(%eax)
  8029f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f3:	8b 00                	mov    (%eax),%eax
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	75 08                	jne    802a01 <alloc_block_BF+0x398>
  8029f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fc:	a3 30 50 80 00       	mov    %eax,0x805030
  802a01:	a1 38 50 80 00       	mov    0x805038,%eax
  802a06:	40                   	inc    %eax
  802a07:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a10:	75 17                	jne    802a29 <alloc_block_BF+0x3c0>
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	68 7f 43 80 00       	push   $0x80437f
  802a1a:	68 51 01 00 00       	push   $0x151
  802a1f:	68 9d 43 80 00       	push   $0x80439d
  802a24:	e8 d9 0e 00 00       	call   803902 <_panic>
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	74 10                	je     802a42 <alloc_block_BF+0x3d9>
  802a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a35:	8b 00                	mov    (%eax),%eax
  802a37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a3a:	8b 52 04             	mov    0x4(%edx),%edx
  802a3d:	89 50 04             	mov    %edx,0x4(%eax)
  802a40:	eb 0b                	jmp    802a4d <alloc_block_BF+0x3e4>
  802a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a45:	8b 40 04             	mov    0x4(%eax),%eax
  802a48:	a3 30 50 80 00       	mov    %eax,0x805030
  802a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a50:	8b 40 04             	mov    0x4(%eax),%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	74 0f                	je     802a66 <alloc_block_BF+0x3fd>
  802a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a60:	8b 12                	mov    (%edx),%edx
  802a62:	89 10                	mov    %edx,(%eax)
  802a64:	eb 0a                	jmp    802a70 <alloc_block_BF+0x407>
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a83:	a1 38 50 80 00       	mov    0x805038,%eax
  802a88:	48                   	dec    %eax
  802a89:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a8e:	83 ec 04             	sub    $0x4,%esp
  802a91:	6a 00                	push   $0x0
  802a93:	ff 75 d0             	pushl  -0x30(%ebp)
  802a96:	ff 75 cc             	pushl  -0x34(%ebp)
  802a99:	e8 e0 f6 ff ff       	call   80217e <set_block_data>
  802a9e:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa4:	e9 a3 01 00 00       	jmp    802c4c <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802aa9:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802aad:	0f 85 9d 00 00 00    	jne    802b50 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ab3:	83 ec 04             	sub    $0x4,%esp
  802ab6:	6a 01                	push   $0x1
  802ab8:	ff 75 ec             	pushl  -0x14(%ebp)
  802abb:	ff 75 f0             	pushl  -0x10(%ebp)
  802abe:	e8 bb f6 ff ff       	call   80217e <set_block_data>
  802ac3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802ac6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aca:	75 17                	jne    802ae3 <alloc_block_BF+0x47a>
  802acc:	83 ec 04             	sub    $0x4,%esp
  802acf:	68 7f 43 80 00       	push   $0x80437f
  802ad4:	68 58 01 00 00       	push   $0x158
  802ad9:	68 9d 43 80 00       	push   $0x80439d
  802ade:	e8 1f 0e 00 00       	call   803902 <_panic>
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	8b 00                	mov    (%eax),%eax
  802ae8:	85 c0                	test   %eax,%eax
  802aea:	74 10                	je     802afc <alloc_block_BF+0x493>
  802aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af4:	8b 52 04             	mov    0x4(%edx),%edx
  802af7:	89 50 04             	mov    %edx,0x4(%eax)
  802afa:	eb 0b                	jmp    802b07 <alloc_block_BF+0x49e>
  802afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aff:	8b 40 04             	mov    0x4(%eax),%eax
  802b02:	a3 30 50 80 00       	mov    %eax,0x805030
  802b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0a:	8b 40 04             	mov    0x4(%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	74 0f                	je     802b20 <alloc_block_BF+0x4b7>
  802b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b1a:	8b 12                	mov    (%edx),%edx
  802b1c:	89 10                	mov    %edx,(%eax)
  802b1e:	eb 0a                	jmp    802b2a <alloc_block_BF+0x4c1>
  802b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3d:	a1 38 50 80 00       	mov    0x805038,%eax
  802b42:	48                   	dec    %eax
  802b43:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4b:	e9 fc 00 00 00       	jmp    802c4c <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	83 c0 08             	add    $0x8,%eax
  802b56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b59:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b60:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b63:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b66:	01 d0                	add    %edx,%eax
  802b68:	48                   	dec    %eax
  802b69:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b6c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  802b74:	f7 75 c4             	divl   -0x3c(%ebp)
  802b77:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b7a:	29 d0                	sub    %edx,%eax
  802b7c:	c1 e8 0c             	shr    $0xc,%eax
  802b7f:	83 ec 0c             	sub    $0xc,%esp
  802b82:	50                   	push   %eax
  802b83:	e8 a4 e7 ff ff       	call   80132c <sbrk>
  802b88:	83 c4 10             	add    $0x10,%esp
  802b8b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b8e:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b92:	75 0a                	jne    802b9e <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b94:	b8 00 00 00 00       	mov    $0x0,%eax
  802b99:	e9 ae 00 00 00       	jmp    802c4c <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b9e:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802ba5:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ba8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bab:	01 d0                	add    %edx,%eax
  802bad:	48                   	dec    %eax
  802bae:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802bb1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  802bb9:	f7 75 b8             	divl   -0x48(%ebp)
  802bbc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bbf:	29 d0                	sub    %edx,%eax
  802bc1:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bc4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bc7:	01 d0                	add    %edx,%eax
  802bc9:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802bce:	a1 40 50 80 00       	mov    0x805040,%eax
  802bd3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802bd9:	83 ec 0c             	sub    $0xc,%esp
  802bdc:	68 44 44 80 00       	push   $0x804444
  802be1:	e8 a4 d7 ff ff       	call   80038a <cprintf>
  802be6:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802be9:	83 ec 08             	sub    $0x8,%esp
  802bec:	ff 75 bc             	pushl  -0x44(%ebp)
  802bef:	68 49 44 80 00       	push   $0x804449
  802bf4:	e8 91 d7 ff ff       	call   80038a <cprintf>
  802bf9:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bfc:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c03:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c06:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c09:	01 d0                	add    %edx,%eax
  802c0b:	48                   	dec    %eax
  802c0c:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c0f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c12:	ba 00 00 00 00       	mov    $0x0,%edx
  802c17:	f7 75 b0             	divl   -0x50(%ebp)
  802c1a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c1d:	29 d0                	sub    %edx,%eax
  802c1f:	83 ec 04             	sub    $0x4,%esp
  802c22:	6a 01                	push   $0x1
  802c24:	50                   	push   %eax
  802c25:	ff 75 bc             	pushl  -0x44(%ebp)
  802c28:	e8 51 f5 ff ff       	call   80217e <set_block_data>
  802c2d:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c30:	83 ec 0c             	sub    $0xc,%esp
  802c33:	ff 75 bc             	pushl  -0x44(%ebp)
  802c36:	e8 36 04 00 00       	call   803071 <free_block>
  802c3b:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c3e:	83 ec 0c             	sub    $0xc,%esp
  802c41:	ff 75 08             	pushl  0x8(%ebp)
  802c44:	e8 20 fa ff ff       	call   802669 <alloc_block_BF>
  802c49:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c4c:	c9                   	leave  
  802c4d:	c3                   	ret    

00802c4e <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c4e:	55                   	push   %ebp
  802c4f:	89 e5                	mov    %esp,%ebp
  802c51:	53                   	push   %ebx
  802c52:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c5c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c67:	74 1e                	je     802c87 <merging+0x39>
  802c69:	ff 75 08             	pushl  0x8(%ebp)
  802c6c:	e8 bc f1 ff ff       	call   801e2d <get_block_size>
  802c71:	83 c4 04             	add    $0x4,%esp
  802c74:	89 c2                	mov    %eax,%edx
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	01 d0                	add    %edx,%eax
  802c7b:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c7e:	75 07                	jne    802c87 <merging+0x39>
		prev_is_free = 1;
  802c80:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c8b:	74 1e                	je     802cab <merging+0x5d>
  802c8d:	ff 75 10             	pushl  0x10(%ebp)
  802c90:	e8 98 f1 ff ff       	call   801e2d <get_block_size>
  802c95:	83 c4 04             	add    $0x4,%esp
  802c98:	89 c2                	mov    %eax,%edx
  802c9a:	8b 45 10             	mov    0x10(%ebp),%eax
  802c9d:	01 d0                	add    %edx,%eax
  802c9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ca2:	75 07                	jne    802cab <merging+0x5d>
		next_is_free = 1;
  802ca4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802caf:	0f 84 cc 00 00 00    	je     802d81 <merging+0x133>
  802cb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb9:	0f 84 c2 00 00 00    	je     802d81 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802cbf:	ff 75 08             	pushl  0x8(%ebp)
  802cc2:	e8 66 f1 ff ff       	call   801e2d <get_block_size>
  802cc7:	83 c4 04             	add    $0x4,%esp
  802cca:	89 c3                	mov    %eax,%ebx
  802ccc:	ff 75 10             	pushl  0x10(%ebp)
  802ccf:	e8 59 f1 ff ff       	call   801e2d <get_block_size>
  802cd4:	83 c4 04             	add    $0x4,%esp
  802cd7:	01 c3                	add    %eax,%ebx
  802cd9:	ff 75 0c             	pushl  0xc(%ebp)
  802cdc:	e8 4c f1 ff ff       	call   801e2d <get_block_size>
  802ce1:	83 c4 04             	add    $0x4,%esp
  802ce4:	01 d8                	add    %ebx,%eax
  802ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ce9:	6a 00                	push   $0x0
  802ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  802cee:	ff 75 08             	pushl  0x8(%ebp)
  802cf1:	e8 88 f4 ff ff       	call   80217e <set_block_data>
  802cf6:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cfd:	75 17                	jne    802d16 <merging+0xc8>
  802cff:	83 ec 04             	sub    $0x4,%esp
  802d02:	68 7f 43 80 00       	push   $0x80437f
  802d07:	68 7d 01 00 00       	push   $0x17d
  802d0c:	68 9d 43 80 00       	push   $0x80439d
  802d11:	e8 ec 0b 00 00       	call   803902 <_panic>
  802d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	74 10                	je     802d2f <merging+0xe1>
  802d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d27:	8b 52 04             	mov    0x4(%edx),%edx
  802d2a:	89 50 04             	mov    %edx,0x4(%eax)
  802d2d:	eb 0b                	jmp    802d3a <merging+0xec>
  802d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d32:	8b 40 04             	mov    0x4(%eax),%eax
  802d35:	a3 30 50 80 00       	mov    %eax,0x805030
  802d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	85 c0                	test   %eax,%eax
  802d42:	74 0f                	je     802d53 <merging+0x105>
  802d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d47:	8b 40 04             	mov    0x4(%eax),%eax
  802d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d4d:	8b 12                	mov    (%edx),%edx
  802d4f:	89 10                	mov    %edx,(%eax)
  802d51:	eb 0a                	jmp    802d5d <merging+0x10f>
  802d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d70:	a1 38 50 80 00       	mov    0x805038,%eax
  802d75:	48                   	dec    %eax
  802d76:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d7b:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d7c:	e9 ea 02 00 00       	jmp    80306b <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d85:	74 3b                	je     802dc2 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d87:	83 ec 0c             	sub    $0xc,%esp
  802d8a:	ff 75 08             	pushl  0x8(%ebp)
  802d8d:	e8 9b f0 ff ff       	call   801e2d <get_block_size>
  802d92:	83 c4 10             	add    $0x10,%esp
  802d95:	89 c3                	mov    %eax,%ebx
  802d97:	83 ec 0c             	sub    $0xc,%esp
  802d9a:	ff 75 10             	pushl  0x10(%ebp)
  802d9d:	e8 8b f0 ff ff       	call   801e2d <get_block_size>
  802da2:	83 c4 10             	add    $0x10,%esp
  802da5:	01 d8                	add    %ebx,%eax
  802da7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802daa:	83 ec 04             	sub    $0x4,%esp
  802dad:	6a 00                	push   $0x0
  802daf:	ff 75 e8             	pushl  -0x18(%ebp)
  802db2:	ff 75 08             	pushl  0x8(%ebp)
  802db5:	e8 c4 f3 ff ff       	call   80217e <set_block_data>
  802dba:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dbd:	e9 a9 02 00 00       	jmp    80306b <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802dc2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc6:	0f 84 2d 01 00 00    	je     802ef9 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802dcc:	83 ec 0c             	sub    $0xc,%esp
  802dcf:	ff 75 10             	pushl  0x10(%ebp)
  802dd2:	e8 56 f0 ff ff       	call   801e2d <get_block_size>
  802dd7:	83 c4 10             	add    $0x10,%esp
  802dda:	89 c3                	mov    %eax,%ebx
  802ddc:	83 ec 0c             	sub    $0xc,%esp
  802ddf:	ff 75 0c             	pushl  0xc(%ebp)
  802de2:	e8 46 f0 ff ff       	call   801e2d <get_block_size>
  802de7:	83 c4 10             	add    $0x10,%esp
  802dea:	01 d8                	add    %ebx,%eax
  802dec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802def:	83 ec 04             	sub    $0x4,%esp
  802df2:	6a 00                	push   $0x0
  802df4:	ff 75 e4             	pushl  -0x1c(%ebp)
  802df7:	ff 75 10             	pushl  0x10(%ebp)
  802dfa:	e8 7f f3 ff ff       	call   80217e <set_block_data>
  802dff:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e02:	8b 45 10             	mov    0x10(%ebp),%eax
  802e05:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e0c:	74 06                	je     802e14 <merging+0x1c6>
  802e0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e12:	75 17                	jne    802e2b <merging+0x1dd>
  802e14:	83 ec 04             	sub    $0x4,%esp
  802e17:	68 58 44 80 00       	push   $0x804458
  802e1c:	68 8d 01 00 00       	push   $0x18d
  802e21:	68 9d 43 80 00       	push   $0x80439d
  802e26:	e8 d7 0a 00 00       	call   803902 <_panic>
  802e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2e:	8b 50 04             	mov    0x4(%eax),%edx
  802e31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e34:	89 50 04             	mov    %edx,0x4(%eax)
  802e37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e3d:	89 10                	mov    %edx,(%eax)
  802e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	74 0d                	je     802e56 <merging+0x208>
  802e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4c:	8b 40 04             	mov    0x4(%eax),%eax
  802e4f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e52:	89 10                	mov    %edx,(%eax)
  802e54:	eb 08                	jmp    802e5e <merging+0x210>
  802e56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e59:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e61:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e64:	89 50 04             	mov    %edx,0x4(%eax)
  802e67:	a1 38 50 80 00       	mov    0x805038,%eax
  802e6c:	40                   	inc    %eax
  802e6d:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e76:	75 17                	jne    802e8f <merging+0x241>
  802e78:	83 ec 04             	sub    $0x4,%esp
  802e7b:	68 7f 43 80 00       	push   $0x80437f
  802e80:	68 8e 01 00 00       	push   $0x18e
  802e85:	68 9d 43 80 00       	push   $0x80439d
  802e8a:	e8 73 0a 00 00       	call   803902 <_panic>
  802e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	85 c0                	test   %eax,%eax
  802e96:	74 10                	je     802ea8 <merging+0x25a>
  802e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea0:	8b 52 04             	mov    0x4(%edx),%edx
  802ea3:	89 50 04             	mov    %edx,0x4(%eax)
  802ea6:	eb 0b                	jmp    802eb3 <merging+0x265>
  802ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eab:	8b 40 04             	mov    0x4(%eax),%eax
  802eae:	a3 30 50 80 00       	mov    %eax,0x805030
  802eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb6:	8b 40 04             	mov    0x4(%eax),%eax
  802eb9:	85 c0                	test   %eax,%eax
  802ebb:	74 0f                	je     802ecc <merging+0x27e>
  802ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec0:	8b 40 04             	mov    0x4(%eax),%eax
  802ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec6:	8b 12                	mov    (%edx),%edx
  802ec8:	89 10                	mov    %edx,(%eax)
  802eca:	eb 0a                	jmp    802ed6 <merging+0x288>
  802ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ecf:	8b 00                	mov    (%eax),%eax
  802ed1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee9:	a1 38 50 80 00       	mov    0x805038,%eax
  802eee:	48                   	dec    %eax
  802eef:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ef4:	e9 72 01 00 00       	jmp    80306b <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  802efc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802eff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f03:	74 79                	je     802f7e <merging+0x330>
  802f05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f09:	74 73                	je     802f7e <merging+0x330>
  802f0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f0f:	74 06                	je     802f17 <merging+0x2c9>
  802f11:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f15:	75 17                	jne    802f2e <merging+0x2e0>
  802f17:	83 ec 04             	sub    $0x4,%esp
  802f1a:	68 10 44 80 00       	push   $0x804410
  802f1f:	68 94 01 00 00       	push   $0x194
  802f24:	68 9d 43 80 00       	push   $0x80439d
  802f29:	e8 d4 09 00 00       	call   803902 <_panic>
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	8b 10                	mov    (%eax),%edx
  802f33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	74 0b                	je     802f4c <merging+0x2fe>
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	8b 00                	mov    (%eax),%eax
  802f46:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f49:	89 50 04             	mov    %edx,0x4(%eax)
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f52:	89 10                	mov    %edx,(%eax)
  802f54:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f57:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5a:	89 50 04             	mov    %edx,0x4(%eax)
  802f5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	75 08                	jne    802f6e <merging+0x320>
  802f66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f69:	a3 30 50 80 00       	mov    %eax,0x805030
  802f6e:	a1 38 50 80 00       	mov    0x805038,%eax
  802f73:	40                   	inc    %eax
  802f74:	a3 38 50 80 00       	mov    %eax,0x805038
  802f79:	e9 ce 00 00 00       	jmp    80304c <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f82:	74 65                	je     802fe9 <merging+0x39b>
  802f84:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f88:	75 17                	jne    802fa1 <merging+0x353>
  802f8a:	83 ec 04             	sub    $0x4,%esp
  802f8d:	68 ec 43 80 00       	push   $0x8043ec
  802f92:	68 95 01 00 00       	push   $0x195
  802f97:	68 9d 43 80 00       	push   $0x80439d
  802f9c:	e8 61 09 00 00       	call   803902 <_panic>
  802fa1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fa7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802faa:	89 50 04             	mov    %edx,0x4(%eax)
  802fad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb0:	8b 40 04             	mov    0x4(%eax),%eax
  802fb3:	85 c0                	test   %eax,%eax
  802fb5:	74 0c                	je     802fc3 <merging+0x375>
  802fb7:	a1 30 50 80 00       	mov    0x805030,%eax
  802fbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fbf:	89 10                	mov    %edx,(%eax)
  802fc1:	eb 08                	jmp    802fcb <merging+0x37d>
  802fc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fcb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fce:	a3 30 50 80 00       	mov    %eax,0x805030
  802fd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdc:	a1 38 50 80 00       	mov    0x805038,%eax
  802fe1:	40                   	inc    %eax
  802fe2:	a3 38 50 80 00       	mov    %eax,0x805038
  802fe7:	eb 63                	jmp    80304c <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fe9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fed:	75 17                	jne    803006 <merging+0x3b8>
  802fef:	83 ec 04             	sub    $0x4,%esp
  802ff2:	68 b8 43 80 00       	push   $0x8043b8
  802ff7:	68 98 01 00 00       	push   $0x198
  802ffc:	68 9d 43 80 00       	push   $0x80439d
  803001:	e8 fc 08 00 00       	call   803902 <_panic>
  803006:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80300c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300f:	89 10                	mov    %edx,(%eax)
  803011:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803014:	8b 00                	mov    (%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 0d                	je     803027 <merging+0x3d9>
  80301a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80301f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803022:	89 50 04             	mov    %edx,0x4(%eax)
  803025:	eb 08                	jmp    80302f <merging+0x3e1>
  803027:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302a:	a3 30 50 80 00       	mov    %eax,0x805030
  80302f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803032:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803037:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803041:	a1 38 50 80 00       	mov    0x805038,%eax
  803046:	40                   	inc    %eax
  803047:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80304c:	83 ec 0c             	sub    $0xc,%esp
  80304f:	ff 75 10             	pushl  0x10(%ebp)
  803052:	e8 d6 ed ff ff       	call   801e2d <get_block_size>
  803057:	83 c4 10             	add    $0x10,%esp
  80305a:	83 ec 04             	sub    $0x4,%esp
  80305d:	6a 00                	push   $0x0
  80305f:	50                   	push   %eax
  803060:	ff 75 10             	pushl  0x10(%ebp)
  803063:	e8 16 f1 ff ff       	call   80217e <set_block_data>
  803068:	83 c4 10             	add    $0x10,%esp
	}
}
  80306b:	90                   	nop
  80306c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80306f:	c9                   	leave  
  803070:	c3                   	ret    

00803071 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803071:	55                   	push   %ebp
  803072:	89 e5                	mov    %esp,%ebp
  803074:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803077:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80307c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80307f:	a1 30 50 80 00       	mov    0x805030,%eax
  803084:	3b 45 08             	cmp    0x8(%ebp),%eax
  803087:	73 1b                	jae    8030a4 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803089:	a1 30 50 80 00       	mov    0x805030,%eax
  80308e:	83 ec 04             	sub    $0x4,%esp
  803091:	ff 75 08             	pushl  0x8(%ebp)
  803094:	6a 00                	push   $0x0
  803096:	50                   	push   %eax
  803097:	e8 b2 fb ff ff       	call   802c4e <merging>
  80309c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80309f:	e9 8b 00 00 00       	jmp    80312f <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ac:	76 18                	jbe    8030c6 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030b3:	83 ec 04             	sub    $0x4,%esp
  8030b6:	ff 75 08             	pushl  0x8(%ebp)
  8030b9:	50                   	push   %eax
  8030ba:	6a 00                	push   $0x0
  8030bc:	e8 8d fb ff ff       	call   802c4e <merging>
  8030c1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030c4:	eb 69                	jmp    80312f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ce:	eb 39                	jmp    803109 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d6:	73 29                	jae    803101 <free_block+0x90>
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e0:	76 1f                	jbe    803101 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	8b 00                	mov    (%eax),%eax
  8030e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	ff 75 08             	pushl  0x8(%ebp)
  8030f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8030f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8030f6:	e8 53 fb ff ff       	call   802c4e <merging>
  8030fb:	83 c4 10             	add    $0x10,%esp
			break;
  8030fe:	90                   	nop
		}
	}
}
  8030ff:	eb 2e                	jmp    80312f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803101:	a1 34 50 80 00       	mov    0x805034,%eax
  803106:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803109:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310d:	74 07                	je     803116 <free_block+0xa5>
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 00                	mov    (%eax),%eax
  803114:	eb 05                	jmp    80311b <free_block+0xaa>
  803116:	b8 00 00 00 00       	mov    $0x0,%eax
  80311b:	a3 34 50 80 00       	mov    %eax,0x805034
  803120:	a1 34 50 80 00       	mov    0x805034,%eax
  803125:	85 c0                	test   %eax,%eax
  803127:	75 a7                	jne    8030d0 <free_block+0x5f>
  803129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312d:	75 a1                	jne    8030d0 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80312f:	90                   	nop
  803130:	c9                   	leave  
  803131:	c3                   	ret    

00803132 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803132:	55                   	push   %ebp
  803133:	89 e5                	mov    %esp,%ebp
  803135:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803138:	ff 75 08             	pushl  0x8(%ebp)
  80313b:	e8 ed ec ff ff       	call   801e2d <get_block_size>
  803140:	83 c4 04             	add    $0x4,%esp
  803143:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803146:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80314d:	eb 17                	jmp    803166 <copy_data+0x34>
  80314f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803152:	8b 45 0c             	mov    0xc(%ebp),%eax
  803155:	01 c2                	add    %eax,%edx
  803157:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	01 c8                	add    %ecx,%eax
  80315f:	8a 00                	mov    (%eax),%al
  803161:	88 02                	mov    %al,(%edx)
  803163:	ff 45 fc             	incl   -0x4(%ebp)
  803166:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803169:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80316c:	72 e1                	jb     80314f <copy_data+0x1d>
}
  80316e:	90                   	nop
  80316f:	c9                   	leave  
  803170:	c3                   	ret    

00803171 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803171:	55                   	push   %ebp
  803172:	89 e5                	mov    %esp,%ebp
  803174:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803177:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317b:	75 23                	jne    8031a0 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80317d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803181:	74 13                	je     803196 <realloc_block_FF+0x25>
  803183:	83 ec 0c             	sub    $0xc,%esp
  803186:	ff 75 0c             	pushl  0xc(%ebp)
  803189:	e8 1f f0 ff ff       	call   8021ad <alloc_block_FF>
  80318e:	83 c4 10             	add    $0x10,%esp
  803191:	e9 f4 06 00 00       	jmp    80388a <realloc_block_FF+0x719>
		return NULL;
  803196:	b8 00 00 00 00       	mov    $0x0,%eax
  80319b:	e9 ea 06 00 00       	jmp    80388a <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8031a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031a4:	75 18                	jne    8031be <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031a6:	83 ec 0c             	sub    $0xc,%esp
  8031a9:	ff 75 08             	pushl  0x8(%ebp)
  8031ac:	e8 c0 fe ff ff       	call   803071 <free_block>
  8031b1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031b9:	e9 cc 06 00 00       	jmp    80388a <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8031be:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031c2:	77 07                	ja     8031cb <realloc_block_FF+0x5a>
  8031c4:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ce:	83 e0 01             	and    $0x1,%eax
  8031d1:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d7:	83 c0 08             	add    $0x8,%eax
  8031da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031dd:	83 ec 0c             	sub    $0xc,%esp
  8031e0:	ff 75 08             	pushl  0x8(%ebp)
  8031e3:	e8 45 ec ff ff       	call   801e2d <get_block_size>
  8031e8:	83 c4 10             	add    $0x10,%esp
  8031eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f1:	83 e8 08             	sub    $0x8,%eax
  8031f4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	83 e8 04             	sub    $0x4,%eax
  8031fd:	8b 00                	mov    (%eax),%eax
  8031ff:	83 e0 fe             	and    $0xfffffffe,%eax
  803202:	89 c2                	mov    %eax,%edx
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	01 d0                	add    %edx,%eax
  803209:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80320c:	83 ec 0c             	sub    $0xc,%esp
  80320f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803212:	e8 16 ec ff ff       	call   801e2d <get_block_size>
  803217:	83 c4 10             	add    $0x10,%esp
  80321a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80321d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803220:	83 e8 08             	sub    $0x8,%eax
  803223:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803226:	8b 45 0c             	mov    0xc(%ebp),%eax
  803229:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80322c:	75 08                	jne    803236 <realloc_block_FF+0xc5>
	{
		 return va;
  80322e:	8b 45 08             	mov    0x8(%ebp),%eax
  803231:	e9 54 06 00 00       	jmp    80388a <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803236:	8b 45 0c             	mov    0xc(%ebp),%eax
  803239:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80323c:	0f 83 e5 03 00 00    	jae    803627 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803242:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803245:	2b 45 0c             	sub    0xc(%ebp),%eax
  803248:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80324b:	83 ec 0c             	sub    $0xc,%esp
  80324e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803251:	e8 f0 eb ff ff       	call   801e46 <is_free_block>
  803256:	83 c4 10             	add    $0x10,%esp
  803259:	84 c0                	test   %al,%al
  80325b:	0f 84 3b 01 00 00    	je     80339c <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803261:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803264:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803267:	01 d0                	add    %edx,%eax
  803269:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80326c:	83 ec 04             	sub    $0x4,%esp
  80326f:	6a 01                	push   $0x1
  803271:	ff 75 f0             	pushl  -0x10(%ebp)
  803274:	ff 75 08             	pushl  0x8(%ebp)
  803277:	e8 02 ef ff ff       	call   80217e <set_block_data>
  80327c:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	83 e8 04             	sub    $0x4,%eax
  803285:	8b 00                	mov    (%eax),%eax
  803287:	83 e0 fe             	and    $0xfffffffe,%eax
  80328a:	89 c2                	mov    %eax,%edx
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	01 d0                	add    %edx,%eax
  803291:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803294:	83 ec 04             	sub    $0x4,%esp
  803297:	6a 00                	push   $0x0
  803299:	ff 75 cc             	pushl  -0x34(%ebp)
  80329c:	ff 75 c8             	pushl  -0x38(%ebp)
  80329f:	e8 da ee ff ff       	call   80217e <set_block_data>
  8032a4:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032ab:	74 06                	je     8032b3 <realloc_block_FF+0x142>
  8032ad:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032b1:	75 17                	jne    8032ca <realloc_block_FF+0x159>
  8032b3:	83 ec 04             	sub    $0x4,%esp
  8032b6:	68 10 44 80 00       	push   $0x804410
  8032bb:	68 f6 01 00 00       	push   $0x1f6
  8032c0:	68 9d 43 80 00       	push   $0x80439d
  8032c5:	e8 38 06 00 00       	call   803902 <_panic>
  8032ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cd:	8b 10                	mov    (%eax),%edx
  8032cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032d2:	89 10                	mov    %edx,(%eax)
  8032d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	74 0b                	je     8032e8 <realloc_block_FF+0x177>
  8032dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e0:	8b 00                	mov    (%eax),%eax
  8032e2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032e5:	89 50 04             	mov    %edx,0x4(%eax)
  8032e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032eb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032ee:	89 10                	mov    %edx,(%eax)
  8032f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032f6:	89 50 04             	mov    %edx,0x4(%eax)
  8032f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	75 08                	jne    80330a <realloc_block_FF+0x199>
  803302:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803305:	a3 30 50 80 00       	mov    %eax,0x805030
  80330a:	a1 38 50 80 00       	mov    0x805038,%eax
  80330f:	40                   	inc    %eax
  803310:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803319:	75 17                	jne    803332 <realloc_block_FF+0x1c1>
  80331b:	83 ec 04             	sub    $0x4,%esp
  80331e:	68 7f 43 80 00       	push   $0x80437f
  803323:	68 f7 01 00 00       	push   $0x1f7
  803328:	68 9d 43 80 00       	push   $0x80439d
  80332d:	e8 d0 05 00 00       	call   803902 <_panic>
  803332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803335:	8b 00                	mov    (%eax),%eax
  803337:	85 c0                	test   %eax,%eax
  803339:	74 10                	je     80334b <realloc_block_FF+0x1da>
  80333b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333e:	8b 00                	mov    (%eax),%eax
  803340:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803343:	8b 52 04             	mov    0x4(%edx),%edx
  803346:	89 50 04             	mov    %edx,0x4(%eax)
  803349:	eb 0b                	jmp    803356 <realloc_block_FF+0x1e5>
  80334b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334e:	8b 40 04             	mov    0x4(%eax),%eax
  803351:	a3 30 50 80 00       	mov    %eax,0x805030
  803356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803359:	8b 40 04             	mov    0x4(%eax),%eax
  80335c:	85 c0                	test   %eax,%eax
  80335e:	74 0f                	je     80336f <realloc_block_FF+0x1fe>
  803360:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803363:	8b 40 04             	mov    0x4(%eax),%eax
  803366:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803369:	8b 12                	mov    (%edx),%edx
  80336b:	89 10                	mov    %edx,(%eax)
  80336d:	eb 0a                	jmp    803379 <realloc_block_FF+0x208>
  80336f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803372:	8b 00                	mov    (%eax),%eax
  803374:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803379:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803385:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338c:	a1 38 50 80 00       	mov    0x805038,%eax
  803391:	48                   	dec    %eax
  803392:	a3 38 50 80 00       	mov    %eax,0x805038
  803397:	e9 83 02 00 00       	jmp    80361f <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80339c:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033a0:	0f 86 69 02 00 00    	jbe    80360f <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033a6:	83 ec 04             	sub    $0x4,%esp
  8033a9:	6a 01                	push   $0x1
  8033ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8033ae:	ff 75 08             	pushl  0x8(%ebp)
  8033b1:	e8 c8 ed ff ff       	call   80217e <set_block_data>
  8033b6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bc:	83 e8 04             	sub    $0x4,%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	83 e0 fe             	and    $0xfffffffe,%eax
  8033c4:	89 c2                	mov    %eax,%edx
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	01 d0                	add    %edx,%eax
  8033cb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033d6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033da:	75 68                	jne    803444 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033e0:	75 17                	jne    8033f9 <realloc_block_FF+0x288>
  8033e2:	83 ec 04             	sub    $0x4,%esp
  8033e5:	68 b8 43 80 00       	push   $0x8043b8
  8033ea:	68 06 02 00 00       	push   $0x206
  8033ef:	68 9d 43 80 00       	push   $0x80439d
  8033f4:	e8 09 05 00 00       	call   803902 <_panic>
  8033f9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803402:	89 10                	mov    %edx,(%eax)
  803404:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803407:	8b 00                	mov    (%eax),%eax
  803409:	85 c0                	test   %eax,%eax
  80340b:	74 0d                	je     80341a <realloc_block_FF+0x2a9>
  80340d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803412:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803415:	89 50 04             	mov    %edx,0x4(%eax)
  803418:	eb 08                	jmp    803422 <realloc_block_FF+0x2b1>
  80341a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80341d:	a3 30 50 80 00       	mov    %eax,0x805030
  803422:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803425:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80342a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803434:	a1 38 50 80 00       	mov    0x805038,%eax
  803439:	40                   	inc    %eax
  80343a:	a3 38 50 80 00       	mov    %eax,0x805038
  80343f:	e9 b0 01 00 00       	jmp    8035f4 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803444:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803449:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80344c:	76 68                	jbe    8034b6 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80344e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803452:	75 17                	jne    80346b <realloc_block_FF+0x2fa>
  803454:	83 ec 04             	sub    $0x4,%esp
  803457:	68 b8 43 80 00       	push   $0x8043b8
  80345c:	68 0b 02 00 00       	push   $0x20b
  803461:	68 9d 43 80 00       	push   $0x80439d
  803466:	e8 97 04 00 00       	call   803902 <_panic>
  80346b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803471:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803474:	89 10                	mov    %edx,(%eax)
  803476:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803479:	8b 00                	mov    (%eax),%eax
  80347b:	85 c0                	test   %eax,%eax
  80347d:	74 0d                	je     80348c <realloc_block_FF+0x31b>
  80347f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803484:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803487:	89 50 04             	mov    %edx,0x4(%eax)
  80348a:	eb 08                	jmp    803494 <realloc_block_FF+0x323>
  80348c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348f:	a3 30 50 80 00       	mov    %eax,0x805030
  803494:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803497:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80349c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ab:	40                   	inc    %eax
  8034ac:	a3 38 50 80 00       	mov    %eax,0x805038
  8034b1:	e9 3e 01 00 00       	jmp    8035f4 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034b6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034bb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034be:	73 68                	jae    803528 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034c0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034c4:	75 17                	jne    8034dd <realloc_block_FF+0x36c>
  8034c6:	83 ec 04             	sub    $0x4,%esp
  8034c9:	68 ec 43 80 00       	push   $0x8043ec
  8034ce:	68 10 02 00 00       	push   $0x210
  8034d3:	68 9d 43 80 00       	push   $0x80439d
  8034d8:	e8 25 04 00 00       	call   803902 <_panic>
  8034dd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e6:	89 50 04             	mov    %edx,0x4(%eax)
  8034e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ec:	8b 40 04             	mov    0x4(%eax),%eax
  8034ef:	85 c0                	test   %eax,%eax
  8034f1:	74 0c                	je     8034ff <realloc_block_FF+0x38e>
  8034f3:	a1 30 50 80 00       	mov    0x805030,%eax
  8034f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034fb:	89 10                	mov    %edx,(%eax)
  8034fd:	eb 08                	jmp    803507 <realloc_block_FF+0x396>
  8034ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803502:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803507:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350a:	a3 30 50 80 00       	mov    %eax,0x805030
  80350f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803512:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803518:	a1 38 50 80 00       	mov    0x805038,%eax
  80351d:	40                   	inc    %eax
  80351e:	a3 38 50 80 00       	mov    %eax,0x805038
  803523:	e9 cc 00 00 00       	jmp    8035f4 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803528:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80352f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803537:	e9 8a 00 00 00       	jmp    8035c6 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80353c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803542:	73 7a                	jae    8035be <realloc_block_FF+0x44d>
  803544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803547:	8b 00                	mov    (%eax),%eax
  803549:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80354c:	73 70                	jae    8035be <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80354e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803552:	74 06                	je     80355a <realloc_block_FF+0x3e9>
  803554:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803558:	75 17                	jne    803571 <realloc_block_FF+0x400>
  80355a:	83 ec 04             	sub    $0x4,%esp
  80355d:	68 10 44 80 00       	push   $0x804410
  803562:	68 1a 02 00 00       	push   $0x21a
  803567:	68 9d 43 80 00       	push   $0x80439d
  80356c:	e8 91 03 00 00       	call   803902 <_panic>
  803571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803574:	8b 10                	mov    (%eax),%edx
  803576:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803579:	89 10                	mov    %edx,(%eax)
  80357b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357e:	8b 00                	mov    (%eax),%eax
  803580:	85 c0                	test   %eax,%eax
  803582:	74 0b                	je     80358f <realloc_block_FF+0x41e>
  803584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803587:	8b 00                	mov    (%eax),%eax
  803589:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80358c:	89 50 04             	mov    %edx,0x4(%eax)
  80358f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803592:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803595:	89 10                	mov    %edx,(%eax)
  803597:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80359d:	89 50 04             	mov    %edx,0x4(%eax)
  8035a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a3:	8b 00                	mov    (%eax),%eax
  8035a5:	85 c0                	test   %eax,%eax
  8035a7:	75 08                	jne    8035b1 <realloc_block_FF+0x440>
  8035a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8035b6:	40                   	inc    %eax
  8035b7:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035bc:	eb 36                	jmp    8035f4 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035be:	a1 34 50 80 00       	mov    0x805034,%eax
  8035c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ca:	74 07                	je     8035d3 <realloc_block_FF+0x462>
  8035cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cf:	8b 00                	mov    (%eax),%eax
  8035d1:	eb 05                	jmp    8035d8 <realloc_block_FF+0x467>
  8035d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d8:	a3 34 50 80 00       	mov    %eax,0x805034
  8035dd:	a1 34 50 80 00       	mov    0x805034,%eax
  8035e2:	85 c0                	test   %eax,%eax
  8035e4:	0f 85 52 ff ff ff    	jne    80353c <realloc_block_FF+0x3cb>
  8035ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ee:	0f 85 48 ff ff ff    	jne    80353c <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035f4:	83 ec 04             	sub    $0x4,%esp
  8035f7:	6a 00                	push   $0x0
  8035f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8035fc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035ff:	e8 7a eb ff ff       	call   80217e <set_block_data>
  803604:	83 c4 10             	add    $0x10,%esp
				return va;
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	e9 7b 02 00 00       	jmp    80388a <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80360f:	83 ec 0c             	sub    $0xc,%esp
  803612:	68 8d 44 80 00       	push   $0x80448d
  803617:	e8 6e cd ff ff       	call   80038a <cprintf>
  80361c:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80361f:	8b 45 08             	mov    0x8(%ebp),%eax
  803622:	e9 63 02 00 00       	jmp    80388a <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803627:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80362d:	0f 86 4d 02 00 00    	jbe    803880 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803633:	83 ec 0c             	sub    $0xc,%esp
  803636:	ff 75 e4             	pushl  -0x1c(%ebp)
  803639:	e8 08 e8 ff ff       	call   801e46 <is_free_block>
  80363e:	83 c4 10             	add    $0x10,%esp
  803641:	84 c0                	test   %al,%al
  803643:	0f 84 37 02 00 00    	je     803880 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80364f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803652:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803655:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803658:	76 38                	jbe    803692 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80365a:	83 ec 0c             	sub    $0xc,%esp
  80365d:	ff 75 08             	pushl  0x8(%ebp)
  803660:	e8 0c fa ff ff       	call   803071 <free_block>
  803665:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803668:	83 ec 0c             	sub    $0xc,%esp
  80366b:	ff 75 0c             	pushl  0xc(%ebp)
  80366e:	e8 3a eb ff ff       	call   8021ad <alloc_block_FF>
  803673:	83 c4 10             	add    $0x10,%esp
  803676:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803679:	83 ec 08             	sub    $0x8,%esp
  80367c:	ff 75 c0             	pushl  -0x40(%ebp)
  80367f:	ff 75 08             	pushl  0x8(%ebp)
  803682:	e8 ab fa ff ff       	call   803132 <copy_data>
  803687:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80368a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80368d:	e9 f8 01 00 00       	jmp    80388a <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803695:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803698:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80369b:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80369f:	0f 87 a0 00 00 00    	ja     803745 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8036a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036a9:	75 17                	jne    8036c2 <realloc_block_FF+0x551>
  8036ab:	83 ec 04             	sub    $0x4,%esp
  8036ae:	68 7f 43 80 00       	push   $0x80437f
  8036b3:	68 38 02 00 00       	push   $0x238
  8036b8:	68 9d 43 80 00       	push   $0x80439d
  8036bd:	e8 40 02 00 00       	call   803902 <_panic>
  8036c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c5:	8b 00                	mov    (%eax),%eax
  8036c7:	85 c0                	test   %eax,%eax
  8036c9:	74 10                	je     8036db <realloc_block_FF+0x56a>
  8036cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ce:	8b 00                	mov    (%eax),%eax
  8036d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d3:	8b 52 04             	mov    0x4(%edx),%edx
  8036d6:	89 50 04             	mov    %edx,0x4(%eax)
  8036d9:	eb 0b                	jmp    8036e6 <realloc_block_FF+0x575>
  8036db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036de:	8b 40 04             	mov    0x4(%eax),%eax
  8036e1:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e9:	8b 40 04             	mov    0x4(%eax),%eax
  8036ec:	85 c0                	test   %eax,%eax
  8036ee:	74 0f                	je     8036ff <realloc_block_FF+0x58e>
  8036f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f3:	8b 40 04             	mov    0x4(%eax),%eax
  8036f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036f9:	8b 12                	mov    (%edx),%edx
  8036fb:	89 10                	mov    %edx,(%eax)
  8036fd:	eb 0a                	jmp    803709 <realloc_block_FF+0x598>
  8036ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803702:	8b 00                	mov    (%eax),%eax
  803704:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803715:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371c:	a1 38 50 80 00       	mov    0x805038,%eax
  803721:	48                   	dec    %eax
  803722:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803727:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80372a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80372d:	01 d0                	add    %edx,%eax
  80372f:	83 ec 04             	sub    $0x4,%esp
  803732:	6a 01                	push   $0x1
  803734:	50                   	push   %eax
  803735:	ff 75 08             	pushl  0x8(%ebp)
  803738:	e8 41 ea ff ff       	call   80217e <set_block_data>
  80373d:	83 c4 10             	add    $0x10,%esp
  803740:	e9 36 01 00 00       	jmp    80387b <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803745:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803748:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80374b:	01 d0                	add    %edx,%eax
  80374d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803750:	83 ec 04             	sub    $0x4,%esp
  803753:	6a 01                	push   $0x1
  803755:	ff 75 f0             	pushl  -0x10(%ebp)
  803758:	ff 75 08             	pushl  0x8(%ebp)
  80375b:	e8 1e ea ff ff       	call   80217e <set_block_data>
  803760:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803763:	8b 45 08             	mov    0x8(%ebp),%eax
  803766:	83 e8 04             	sub    $0x4,%eax
  803769:	8b 00                	mov    (%eax),%eax
  80376b:	83 e0 fe             	and    $0xfffffffe,%eax
  80376e:	89 c2                	mov    %eax,%edx
  803770:	8b 45 08             	mov    0x8(%ebp),%eax
  803773:	01 d0                	add    %edx,%eax
  803775:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803778:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80377c:	74 06                	je     803784 <realloc_block_FF+0x613>
  80377e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803782:	75 17                	jne    80379b <realloc_block_FF+0x62a>
  803784:	83 ec 04             	sub    $0x4,%esp
  803787:	68 10 44 80 00       	push   $0x804410
  80378c:	68 44 02 00 00       	push   $0x244
  803791:	68 9d 43 80 00       	push   $0x80439d
  803796:	e8 67 01 00 00       	call   803902 <_panic>
  80379b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379e:	8b 10                	mov    (%eax),%edx
  8037a0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037a3:	89 10                	mov    %edx,(%eax)
  8037a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037a8:	8b 00                	mov    (%eax),%eax
  8037aa:	85 c0                	test   %eax,%eax
  8037ac:	74 0b                	je     8037b9 <realloc_block_FF+0x648>
  8037ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b1:	8b 00                	mov    (%eax),%eax
  8037b3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037b6:	89 50 04             	mov    %edx,0x4(%eax)
  8037b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037bf:	89 10                	mov    %edx,(%eax)
  8037c1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037c7:	89 50 04             	mov    %edx,0x4(%eax)
  8037ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037cd:	8b 00                	mov    (%eax),%eax
  8037cf:	85 c0                	test   %eax,%eax
  8037d1:	75 08                	jne    8037db <realloc_block_FF+0x66a>
  8037d3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8037db:	a1 38 50 80 00       	mov    0x805038,%eax
  8037e0:	40                   	inc    %eax
  8037e1:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037ea:	75 17                	jne    803803 <realloc_block_FF+0x692>
  8037ec:	83 ec 04             	sub    $0x4,%esp
  8037ef:	68 7f 43 80 00       	push   $0x80437f
  8037f4:	68 45 02 00 00       	push   $0x245
  8037f9:	68 9d 43 80 00       	push   $0x80439d
  8037fe:	e8 ff 00 00 00       	call   803902 <_panic>
  803803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803806:	8b 00                	mov    (%eax),%eax
  803808:	85 c0                	test   %eax,%eax
  80380a:	74 10                	je     80381c <realloc_block_FF+0x6ab>
  80380c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380f:	8b 00                	mov    (%eax),%eax
  803811:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803814:	8b 52 04             	mov    0x4(%edx),%edx
  803817:	89 50 04             	mov    %edx,0x4(%eax)
  80381a:	eb 0b                	jmp    803827 <realloc_block_FF+0x6b6>
  80381c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381f:	8b 40 04             	mov    0x4(%eax),%eax
  803822:	a3 30 50 80 00       	mov    %eax,0x805030
  803827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382a:	8b 40 04             	mov    0x4(%eax),%eax
  80382d:	85 c0                	test   %eax,%eax
  80382f:	74 0f                	je     803840 <realloc_block_FF+0x6cf>
  803831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803834:	8b 40 04             	mov    0x4(%eax),%eax
  803837:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80383a:	8b 12                	mov    (%edx),%edx
  80383c:	89 10                	mov    %edx,(%eax)
  80383e:	eb 0a                	jmp    80384a <realloc_block_FF+0x6d9>
  803840:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803843:	8b 00                	mov    (%eax),%eax
  803845:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80384a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803856:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80385d:	a1 38 50 80 00       	mov    0x805038,%eax
  803862:	48                   	dec    %eax
  803863:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803868:	83 ec 04             	sub    $0x4,%esp
  80386b:	6a 00                	push   $0x0
  80386d:	ff 75 bc             	pushl  -0x44(%ebp)
  803870:	ff 75 b8             	pushl  -0x48(%ebp)
  803873:	e8 06 e9 ff ff       	call   80217e <set_block_data>
  803878:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80387b:	8b 45 08             	mov    0x8(%ebp),%eax
  80387e:	eb 0a                	jmp    80388a <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803880:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803887:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80388a:	c9                   	leave  
  80388b:	c3                   	ret    

0080388c <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80388c:	55                   	push   %ebp
  80388d:	89 e5                	mov    %esp,%ebp
  80388f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803892:	83 ec 04             	sub    $0x4,%esp
  803895:	68 94 44 80 00       	push   $0x804494
  80389a:	68 58 02 00 00       	push   $0x258
  80389f:	68 9d 43 80 00       	push   $0x80439d
  8038a4:	e8 59 00 00 00       	call   803902 <_panic>

008038a9 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038a9:	55                   	push   %ebp
  8038aa:	89 e5                	mov    %esp,%ebp
  8038ac:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038af:	83 ec 04             	sub    $0x4,%esp
  8038b2:	68 bc 44 80 00       	push   $0x8044bc
  8038b7:	68 61 02 00 00       	push   $0x261
  8038bc:	68 9d 43 80 00       	push   $0x80439d
  8038c1:	e8 3c 00 00 00       	call   803902 <_panic>

008038c6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8038c6:	55                   	push   %ebp
  8038c7:	89 e5                	mov    %esp,%ebp
  8038c9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8038d2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8038d6:	83 ec 0c             	sub    $0xc,%esp
  8038d9:	50                   	push   %eax
  8038da:	e8 dd e0 ff ff       	call   8019bc <sys_cputc>
  8038df:	83 c4 10             	add    $0x10,%esp
}
  8038e2:	90                   	nop
  8038e3:	c9                   	leave  
  8038e4:	c3                   	ret    

008038e5 <getchar>:


int
getchar(void)
{
  8038e5:	55                   	push   %ebp
  8038e6:	89 e5                	mov    %esp,%ebp
  8038e8:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8038eb:	e8 68 df ff ff       	call   801858 <sys_cgetc>
  8038f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8038f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8038f6:	c9                   	leave  
  8038f7:	c3                   	ret    

008038f8 <iscons>:

int iscons(int fdnum)
{
  8038f8:	55                   	push   %ebp
  8038f9:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8038fb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803900:	5d                   	pop    %ebp
  803901:	c3                   	ret    

00803902 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803902:	55                   	push   %ebp
  803903:	89 e5                	mov    %esp,%ebp
  803905:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803908:	8d 45 10             	lea    0x10(%ebp),%eax
  80390b:	83 c0 04             	add    $0x4,%eax
  80390e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803911:	a1 60 50 90 00       	mov    0x905060,%eax
  803916:	85 c0                	test   %eax,%eax
  803918:	74 16                	je     803930 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80391a:	a1 60 50 90 00       	mov    0x905060,%eax
  80391f:	83 ec 08             	sub    $0x8,%esp
  803922:	50                   	push   %eax
  803923:	68 e4 44 80 00       	push   $0x8044e4
  803928:	e8 5d ca ff ff       	call   80038a <cprintf>
  80392d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803930:	a1 00 50 80 00       	mov    0x805000,%eax
  803935:	ff 75 0c             	pushl  0xc(%ebp)
  803938:	ff 75 08             	pushl  0x8(%ebp)
  80393b:	50                   	push   %eax
  80393c:	68 e9 44 80 00       	push   $0x8044e9
  803941:	e8 44 ca ff ff       	call   80038a <cprintf>
  803946:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803949:	8b 45 10             	mov    0x10(%ebp),%eax
  80394c:	83 ec 08             	sub    $0x8,%esp
  80394f:	ff 75 f4             	pushl  -0xc(%ebp)
  803952:	50                   	push   %eax
  803953:	e8 c7 c9 ff ff       	call   80031f <vcprintf>
  803958:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80395b:	83 ec 08             	sub    $0x8,%esp
  80395e:	6a 00                	push   $0x0
  803960:	68 05 45 80 00       	push   $0x804505
  803965:	e8 b5 c9 ff ff       	call   80031f <vcprintf>
  80396a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80396d:	e8 36 c9 ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  803972:	eb fe                	jmp    803972 <_panic+0x70>

00803974 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803974:	55                   	push   %ebp
  803975:	89 e5                	mov    %esp,%ebp
  803977:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80397a:	a1 20 50 80 00       	mov    0x805020,%eax
  80397f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803985:	8b 45 0c             	mov    0xc(%ebp),%eax
  803988:	39 c2                	cmp    %eax,%edx
  80398a:	74 14                	je     8039a0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80398c:	83 ec 04             	sub    $0x4,%esp
  80398f:	68 08 45 80 00       	push   $0x804508
  803994:	6a 26                	push   $0x26
  803996:	68 54 45 80 00       	push   $0x804554
  80399b:	e8 62 ff ff ff       	call   803902 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8039a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8039a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8039ae:	e9 c5 00 00 00       	jmp    803a78 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8039b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c0:	01 d0                	add    %edx,%eax
  8039c2:	8b 00                	mov    (%eax),%eax
  8039c4:	85 c0                	test   %eax,%eax
  8039c6:	75 08                	jne    8039d0 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8039c8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8039cb:	e9 a5 00 00 00       	jmp    803a75 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8039d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8039de:	eb 69                	jmp    803a49 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8039e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8039e5:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039ee:	89 d0                	mov    %edx,%eax
  8039f0:	01 c0                	add    %eax,%eax
  8039f2:	01 d0                	add    %edx,%eax
  8039f4:	c1 e0 03             	shl    $0x3,%eax
  8039f7:	01 c8                	add    %ecx,%eax
  8039f9:	8a 40 04             	mov    0x4(%eax),%al
  8039fc:	84 c0                	test   %al,%al
  8039fe:	75 46                	jne    803a46 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a00:	a1 20 50 80 00       	mov    0x805020,%eax
  803a05:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a0b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a0e:	89 d0                	mov    %edx,%eax
  803a10:	01 c0                	add    %eax,%eax
  803a12:	01 d0                	add    %edx,%eax
  803a14:	c1 e0 03             	shl    $0x3,%eax
  803a17:	01 c8                	add    %ecx,%eax
  803a19:	8b 00                	mov    (%eax),%eax
  803a1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a26:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a2b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a32:	8b 45 08             	mov    0x8(%ebp),%eax
  803a35:	01 c8                	add    %ecx,%eax
  803a37:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a39:	39 c2                	cmp    %eax,%edx
  803a3b:	75 09                	jne    803a46 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a3d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a44:	eb 15                	jmp    803a5b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a46:	ff 45 e8             	incl   -0x18(%ebp)
  803a49:	a1 20 50 80 00       	mov    0x805020,%eax
  803a4e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a57:	39 c2                	cmp    %eax,%edx
  803a59:	77 85                	ja     8039e0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a5b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a5f:	75 14                	jne    803a75 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803a61:	83 ec 04             	sub    $0x4,%esp
  803a64:	68 60 45 80 00       	push   $0x804560
  803a69:	6a 3a                	push   $0x3a
  803a6b:	68 54 45 80 00       	push   $0x804554
  803a70:	e8 8d fe ff ff       	call   803902 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803a75:	ff 45 f0             	incl   -0x10(%ebp)
  803a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a7b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a7e:	0f 8c 2f ff ff ff    	jl     8039b3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803a84:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a8b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803a92:	eb 26                	jmp    803aba <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803a94:	a1 20 50 80 00       	mov    0x805020,%eax
  803a99:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803aa2:	89 d0                	mov    %edx,%eax
  803aa4:	01 c0                	add    %eax,%eax
  803aa6:	01 d0                	add    %edx,%eax
  803aa8:	c1 e0 03             	shl    $0x3,%eax
  803aab:	01 c8                	add    %ecx,%eax
  803aad:	8a 40 04             	mov    0x4(%eax),%al
  803ab0:	3c 01                	cmp    $0x1,%al
  803ab2:	75 03                	jne    803ab7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803ab4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ab7:	ff 45 e0             	incl   -0x20(%ebp)
  803aba:	a1 20 50 80 00       	mov    0x805020,%eax
  803abf:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803ac5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ac8:	39 c2                	cmp    %eax,%edx
  803aca:	77 c8                	ja     803a94 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803ad2:	74 14                	je     803ae8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803ad4:	83 ec 04             	sub    $0x4,%esp
  803ad7:	68 b4 45 80 00       	push   $0x8045b4
  803adc:	6a 44                	push   $0x44
  803ade:	68 54 45 80 00       	push   $0x804554
  803ae3:	e8 1a fe ff ff       	call   803902 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803ae8:	90                   	nop
  803ae9:	c9                   	leave  
  803aea:	c3                   	ret    
  803aeb:	90                   	nop

00803aec <__udivdi3>:
  803aec:	55                   	push   %ebp
  803aed:	57                   	push   %edi
  803aee:	56                   	push   %esi
  803aef:	53                   	push   %ebx
  803af0:	83 ec 1c             	sub    $0x1c,%esp
  803af3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803af7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803afb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b03:	89 ca                	mov    %ecx,%edx
  803b05:	89 f8                	mov    %edi,%eax
  803b07:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b0b:	85 f6                	test   %esi,%esi
  803b0d:	75 2d                	jne    803b3c <__udivdi3+0x50>
  803b0f:	39 cf                	cmp    %ecx,%edi
  803b11:	77 65                	ja     803b78 <__udivdi3+0x8c>
  803b13:	89 fd                	mov    %edi,%ebp
  803b15:	85 ff                	test   %edi,%edi
  803b17:	75 0b                	jne    803b24 <__udivdi3+0x38>
  803b19:	b8 01 00 00 00       	mov    $0x1,%eax
  803b1e:	31 d2                	xor    %edx,%edx
  803b20:	f7 f7                	div    %edi
  803b22:	89 c5                	mov    %eax,%ebp
  803b24:	31 d2                	xor    %edx,%edx
  803b26:	89 c8                	mov    %ecx,%eax
  803b28:	f7 f5                	div    %ebp
  803b2a:	89 c1                	mov    %eax,%ecx
  803b2c:	89 d8                	mov    %ebx,%eax
  803b2e:	f7 f5                	div    %ebp
  803b30:	89 cf                	mov    %ecx,%edi
  803b32:	89 fa                	mov    %edi,%edx
  803b34:	83 c4 1c             	add    $0x1c,%esp
  803b37:	5b                   	pop    %ebx
  803b38:	5e                   	pop    %esi
  803b39:	5f                   	pop    %edi
  803b3a:	5d                   	pop    %ebp
  803b3b:	c3                   	ret    
  803b3c:	39 ce                	cmp    %ecx,%esi
  803b3e:	77 28                	ja     803b68 <__udivdi3+0x7c>
  803b40:	0f bd fe             	bsr    %esi,%edi
  803b43:	83 f7 1f             	xor    $0x1f,%edi
  803b46:	75 40                	jne    803b88 <__udivdi3+0x9c>
  803b48:	39 ce                	cmp    %ecx,%esi
  803b4a:	72 0a                	jb     803b56 <__udivdi3+0x6a>
  803b4c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b50:	0f 87 9e 00 00 00    	ja     803bf4 <__udivdi3+0x108>
  803b56:	b8 01 00 00 00       	mov    $0x1,%eax
  803b5b:	89 fa                	mov    %edi,%edx
  803b5d:	83 c4 1c             	add    $0x1c,%esp
  803b60:	5b                   	pop    %ebx
  803b61:	5e                   	pop    %esi
  803b62:	5f                   	pop    %edi
  803b63:	5d                   	pop    %ebp
  803b64:	c3                   	ret    
  803b65:	8d 76 00             	lea    0x0(%esi),%esi
  803b68:	31 ff                	xor    %edi,%edi
  803b6a:	31 c0                	xor    %eax,%eax
  803b6c:	89 fa                	mov    %edi,%edx
  803b6e:	83 c4 1c             	add    $0x1c,%esp
  803b71:	5b                   	pop    %ebx
  803b72:	5e                   	pop    %esi
  803b73:	5f                   	pop    %edi
  803b74:	5d                   	pop    %ebp
  803b75:	c3                   	ret    
  803b76:	66 90                	xchg   %ax,%ax
  803b78:	89 d8                	mov    %ebx,%eax
  803b7a:	f7 f7                	div    %edi
  803b7c:	31 ff                	xor    %edi,%edi
  803b7e:	89 fa                	mov    %edi,%edx
  803b80:	83 c4 1c             	add    $0x1c,%esp
  803b83:	5b                   	pop    %ebx
  803b84:	5e                   	pop    %esi
  803b85:	5f                   	pop    %edi
  803b86:	5d                   	pop    %ebp
  803b87:	c3                   	ret    
  803b88:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b8d:	89 eb                	mov    %ebp,%ebx
  803b8f:	29 fb                	sub    %edi,%ebx
  803b91:	89 f9                	mov    %edi,%ecx
  803b93:	d3 e6                	shl    %cl,%esi
  803b95:	89 c5                	mov    %eax,%ebp
  803b97:	88 d9                	mov    %bl,%cl
  803b99:	d3 ed                	shr    %cl,%ebp
  803b9b:	89 e9                	mov    %ebp,%ecx
  803b9d:	09 f1                	or     %esi,%ecx
  803b9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ba3:	89 f9                	mov    %edi,%ecx
  803ba5:	d3 e0                	shl    %cl,%eax
  803ba7:	89 c5                	mov    %eax,%ebp
  803ba9:	89 d6                	mov    %edx,%esi
  803bab:	88 d9                	mov    %bl,%cl
  803bad:	d3 ee                	shr    %cl,%esi
  803baf:	89 f9                	mov    %edi,%ecx
  803bb1:	d3 e2                	shl    %cl,%edx
  803bb3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bb7:	88 d9                	mov    %bl,%cl
  803bb9:	d3 e8                	shr    %cl,%eax
  803bbb:	09 c2                	or     %eax,%edx
  803bbd:	89 d0                	mov    %edx,%eax
  803bbf:	89 f2                	mov    %esi,%edx
  803bc1:	f7 74 24 0c          	divl   0xc(%esp)
  803bc5:	89 d6                	mov    %edx,%esi
  803bc7:	89 c3                	mov    %eax,%ebx
  803bc9:	f7 e5                	mul    %ebp
  803bcb:	39 d6                	cmp    %edx,%esi
  803bcd:	72 19                	jb     803be8 <__udivdi3+0xfc>
  803bcf:	74 0b                	je     803bdc <__udivdi3+0xf0>
  803bd1:	89 d8                	mov    %ebx,%eax
  803bd3:	31 ff                	xor    %edi,%edi
  803bd5:	e9 58 ff ff ff       	jmp    803b32 <__udivdi3+0x46>
  803bda:	66 90                	xchg   %ax,%ax
  803bdc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803be0:	89 f9                	mov    %edi,%ecx
  803be2:	d3 e2                	shl    %cl,%edx
  803be4:	39 c2                	cmp    %eax,%edx
  803be6:	73 e9                	jae    803bd1 <__udivdi3+0xe5>
  803be8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803beb:	31 ff                	xor    %edi,%edi
  803bed:	e9 40 ff ff ff       	jmp    803b32 <__udivdi3+0x46>
  803bf2:	66 90                	xchg   %ax,%ax
  803bf4:	31 c0                	xor    %eax,%eax
  803bf6:	e9 37 ff ff ff       	jmp    803b32 <__udivdi3+0x46>
  803bfb:	90                   	nop

00803bfc <__umoddi3>:
  803bfc:	55                   	push   %ebp
  803bfd:	57                   	push   %edi
  803bfe:	56                   	push   %esi
  803bff:	53                   	push   %ebx
  803c00:	83 ec 1c             	sub    $0x1c,%esp
  803c03:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c07:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c0f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c1b:	89 f3                	mov    %esi,%ebx
  803c1d:	89 fa                	mov    %edi,%edx
  803c1f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c23:	89 34 24             	mov    %esi,(%esp)
  803c26:	85 c0                	test   %eax,%eax
  803c28:	75 1a                	jne    803c44 <__umoddi3+0x48>
  803c2a:	39 f7                	cmp    %esi,%edi
  803c2c:	0f 86 a2 00 00 00    	jbe    803cd4 <__umoddi3+0xd8>
  803c32:	89 c8                	mov    %ecx,%eax
  803c34:	89 f2                	mov    %esi,%edx
  803c36:	f7 f7                	div    %edi
  803c38:	89 d0                	mov    %edx,%eax
  803c3a:	31 d2                	xor    %edx,%edx
  803c3c:	83 c4 1c             	add    $0x1c,%esp
  803c3f:	5b                   	pop    %ebx
  803c40:	5e                   	pop    %esi
  803c41:	5f                   	pop    %edi
  803c42:	5d                   	pop    %ebp
  803c43:	c3                   	ret    
  803c44:	39 f0                	cmp    %esi,%eax
  803c46:	0f 87 ac 00 00 00    	ja     803cf8 <__umoddi3+0xfc>
  803c4c:	0f bd e8             	bsr    %eax,%ebp
  803c4f:	83 f5 1f             	xor    $0x1f,%ebp
  803c52:	0f 84 ac 00 00 00    	je     803d04 <__umoddi3+0x108>
  803c58:	bf 20 00 00 00       	mov    $0x20,%edi
  803c5d:	29 ef                	sub    %ebp,%edi
  803c5f:	89 fe                	mov    %edi,%esi
  803c61:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c65:	89 e9                	mov    %ebp,%ecx
  803c67:	d3 e0                	shl    %cl,%eax
  803c69:	89 d7                	mov    %edx,%edi
  803c6b:	89 f1                	mov    %esi,%ecx
  803c6d:	d3 ef                	shr    %cl,%edi
  803c6f:	09 c7                	or     %eax,%edi
  803c71:	89 e9                	mov    %ebp,%ecx
  803c73:	d3 e2                	shl    %cl,%edx
  803c75:	89 14 24             	mov    %edx,(%esp)
  803c78:	89 d8                	mov    %ebx,%eax
  803c7a:	d3 e0                	shl    %cl,%eax
  803c7c:	89 c2                	mov    %eax,%edx
  803c7e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c82:	d3 e0                	shl    %cl,%eax
  803c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c88:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c8c:	89 f1                	mov    %esi,%ecx
  803c8e:	d3 e8                	shr    %cl,%eax
  803c90:	09 d0                	or     %edx,%eax
  803c92:	d3 eb                	shr    %cl,%ebx
  803c94:	89 da                	mov    %ebx,%edx
  803c96:	f7 f7                	div    %edi
  803c98:	89 d3                	mov    %edx,%ebx
  803c9a:	f7 24 24             	mull   (%esp)
  803c9d:	89 c6                	mov    %eax,%esi
  803c9f:	89 d1                	mov    %edx,%ecx
  803ca1:	39 d3                	cmp    %edx,%ebx
  803ca3:	0f 82 87 00 00 00    	jb     803d30 <__umoddi3+0x134>
  803ca9:	0f 84 91 00 00 00    	je     803d40 <__umoddi3+0x144>
  803caf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cb3:	29 f2                	sub    %esi,%edx
  803cb5:	19 cb                	sbb    %ecx,%ebx
  803cb7:	89 d8                	mov    %ebx,%eax
  803cb9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cbd:	d3 e0                	shl    %cl,%eax
  803cbf:	89 e9                	mov    %ebp,%ecx
  803cc1:	d3 ea                	shr    %cl,%edx
  803cc3:	09 d0                	or     %edx,%eax
  803cc5:	89 e9                	mov    %ebp,%ecx
  803cc7:	d3 eb                	shr    %cl,%ebx
  803cc9:	89 da                	mov    %ebx,%edx
  803ccb:	83 c4 1c             	add    $0x1c,%esp
  803cce:	5b                   	pop    %ebx
  803ccf:	5e                   	pop    %esi
  803cd0:	5f                   	pop    %edi
  803cd1:	5d                   	pop    %ebp
  803cd2:	c3                   	ret    
  803cd3:	90                   	nop
  803cd4:	89 fd                	mov    %edi,%ebp
  803cd6:	85 ff                	test   %edi,%edi
  803cd8:	75 0b                	jne    803ce5 <__umoddi3+0xe9>
  803cda:	b8 01 00 00 00       	mov    $0x1,%eax
  803cdf:	31 d2                	xor    %edx,%edx
  803ce1:	f7 f7                	div    %edi
  803ce3:	89 c5                	mov    %eax,%ebp
  803ce5:	89 f0                	mov    %esi,%eax
  803ce7:	31 d2                	xor    %edx,%edx
  803ce9:	f7 f5                	div    %ebp
  803ceb:	89 c8                	mov    %ecx,%eax
  803ced:	f7 f5                	div    %ebp
  803cef:	89 d0                	mov    %edx,%eax
  803cf1:	e9 44 ff ff ff       	jmp    803c3a <__umoddi3+0x3e>
  803cf6:	66 90                	xchg   %ax,%ax
  803cf8:	89 c8                	mov    %ecx,%eax
  803cfa:	89 f2                	mov    %esi,%edx
  803cfc:	83 c4 1c             	add    $0x1c,%esp
  803cff:	5b                   	pop    %ebx
  803d00:	5e                   	pop    %esi
  803d01:	5f                   	pop    %edi
  803d02:	5d                   	pop    %ebp
  803d03:	c3                   	ret    
  803d04:	3b 04 24             	cmp    (%esp),%eax
  803d07:	72 06                	jb     803d0f <__umoddi3+0x113>
  803d09:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d0d:	77 0f                	ja     803d1e <__umoddi3+0x122>
  803d0f:	89 f2                	mov    %esi,%edx
  803d11:	29 f9                	sub    %edi,%ecx
  803d13:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d17:	89 14 24             	mov    %edx,(%esp)
  803d1a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d1e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d22:	8b 14 24             	mov    (%esp),%edx
  803d25:	83 c4 1c             	add    $0x1c,%esp
  803d28:	5b                   	pop    %ebx
  803d29:	5e                   	pop    %esi
  803d2a:	5f                   	pop    %edi
  803d2b:	5d                   	pop    %ebp
  803d2c:	c3                   	ret    
  803d2d:	8d 76 00             	lea    0x0(%esi),%esi
  803d30:	2b 04 24             	sub    (%esp),%eax
  803d33:	19 fa                	sbb    %edi,%edx
  803d35:	89 d1                	mov    %edx,%ecx
  803d37:	89 c6                	mov    %eax,%esi
  803d39:	e9 71 ff ff ff       	jmp    803caf <__umoddi3+0xb3>
  803d3e:	66 90                	xchg   %ax,%ax
  803d40:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d44:	72 ea                	jb     803d30 <__umoddi3+0x134>
  803d46:	89 d9                	mov    %ebx,%ecx
  803d48:	e9 62 ff ff ff       	jmp    803caf <__umoddi3+0xb3>
