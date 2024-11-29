
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
  800052:	68 c0 3d 80 00       	push   $0x803dc0
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
  8000bc:	68 de 3d 80 00       	push   $0x803dde
  8000c1:	e8 f1 02 00 00       	call   8003b7 <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 ca 1b 00 00       	call   801c98 <inctst>
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
  80017d:	e8 d8 19 00 00       	call   801b5a <sys_getenvindex>
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
  8001eb:	e8 ee 16 00 00       	call   8018de <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 0c 3e 80 00       	push   $0x803e0c
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
  80021b:	68 34 3e 80 00       	push   $0x803e34
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
  80024c:	68 5c 3e 80 00       	push   $0x803e5c
  800251:	e8 34 01 00 00       	call   80038a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 b4 3e 80 00       	push   $0x803eb4
  80026d:	e8 18 01 00 00       	call   80038a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 0c 3e 80 00       	push   $0x803e0c
  80027d:	e8 08 01 00 00       	call   80038a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800285:	e8 6e 16 00 00       	call   8018f8 <sys_unlock_cons>
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
  80029d:	e8 84 18 00 00       	call   801b26 <sys_destroy_env>
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
  8002ae:	e8 d9 18 00 00       	call   801b8c <sys_exit_env>
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
  8002fc:	e8 9b 15 00 00       	call   80189c <sys_cputs>
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
  800373:	e8 24 15 00 00       	call   80189c <sys_cputs>
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
  8003bd:	e8 1c 15 00 00       	call   8018de <sys_lock_cons>
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
  8003dd:	e8 16 15 00 00       	call   8018f8 <sys_unlock_cons>
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
  800427:	e8 2c 37 00 00       	call   803b58 <__udivdi3>
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
  800477:	e8 ec 37 00 00       	call   803c68 <__umoddi3>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	05 f4 40 80 00       	add    $0x8040f4,%eax
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
  8005d2:	8b 04 85 18 41 80 00 	mov    0x804118(,%eax,4),%eax
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
  8006b3:	8b 34 9d 60 3f 80 00 	mov    0x803f60(,%ebx,4),%esi
  8006ba:	85 f6                	test   %esi,%esi
  8006bc:	75 19                	jne    8006d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006be:	53                   	push   %ebx
  8006bf:	68 05 41 80 00       	push   $0x804105
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
  8006d8:	68 0e 41 80 00       	push   $0x80410e
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
  800705:	be 11 41 80 00       	mov    $0x804111,%esi
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
  800a30:	68 88 42 80 00       	push   $0x804288
  800a35:	e8 50 f9 ff ff       	call   80038a <cprintf>
  800a3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a44:	83 ec 0c             	sub    $0xc,%esp
  800a47:	6a 00                	push   $0x0
  800a49:	e8 17 2f 00 00       	call   803965 <iscons>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a54:	e8 f9 2e 00 00       	call   803952 <getchar>
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
  800a72:	68 8b 42 80 00       	push   $0x80428b
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
  800a9f:	e8 8f 2e 00 00       	call   803933 <cputchar>
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
  800ad6:	e8 58 2e 00 00       	call   803933 <cputchar>
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
  800aff:	e8 2f 2e 00 00       	call   803933 <cputchar>
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
  800b23:	e8 b6 0d 00 00       	call   8018de <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b2c:	74 13                	je     800b41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 08             	pushl  0x8(%ebp)
  800b34:	68 88 42 80 00       	push   $0x804288
  800b39:	e8 4c f8 ff ff       	call   80038a <cprintf>
  800b3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b48:	83 ec 0c             	sub    $0xc,%esp
  800b4b:	6a 00                	push   $0x0
  800b4d:	e8 13 2e 00 00       	call   803965 <iscons>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b58:	e8 f5 2d 00 00       	call   803952 <getchar>
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
  800b76:	68 8b 42 80 00       	push   $0x80428b
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
  800ba3:	e8 8b 2d 00 00       	call   803933 <cputchar>
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
  800bda:	e8 54 2d 00 00       	call   803933 <cputchar>
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
  800c03:	e8 2b 2d 00 00       	call   803933 <cputchar>
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
  800c1e:	e8 d5 0c 00 00       	call   8018f8 <sys_unlock_cons>
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
  801318:	68 9c 42 80 00       	push   $0x80429c
  80131d:	68 3f 01 00 00       	push   $0x13f
  801322:	68 be 42 80 00       	push   $0x8042be
  801327:	e8 43 26 00 00       	call   80396f <_panic>

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
  801338:	e8 0a 0b 00 00       	call   801e47 <sys_sbrk>
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
  8013b3:	e8 13 09 00 00       	call   801ccb <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	74 16                	je     8013d2 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 08             	pushl  0x8(%ebp)
  8013c2:	e8 53 0e 00 00       	call   80221a <alloc_block_FF>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013cd:	e9 8a 01 00 00       	jmp    80155c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013d2:	e8 25 09 00 00       	call   801cfc <sys_isUHeapPlacementStrategyBESTFIT>
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	0f 84 7d 01 00 00    	je     80155c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013df:	83 ec 0c             	sub    $0xc,%esp
  8013e2:	ff 75 08             	pushl  0x8(%ebp)
  8013e5:	e8 ec 12 00 00       	call   8026d6 <alloc_block_BF>
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
  80154b:	e8 2e 09 00 00       	call   801e7e <sys_allocate_user_mem>
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
  801593:	e8 02 09 00 00       	call   801e9a <get_block_size>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 35 1b 00 00       	call   8030de <free_block>
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
  80163b:	e8 22 08 00 00       	call   801e62 <sys_free_user_mem>
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
  801649:	68 cc 42 80 00       	push   $0x8042cc
  80164e:	68 85 00 00 00       	push   $0x85
  801653:	68 f6 42 80 00       	push   $0x8042f6
  801658:	e8 12 23 00 00       	call   80396f <_panic>
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
  8016be:	e8 a6 03 00 00       	call   801a69 <sys_createSharedObject>
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
  8016e2:	68 02 43 80 00       	push   $0x804302
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
  801726:	e8 68 03 00 00       	call   801a93 <sys_getSizeOfSharedObject>
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801731:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801735:	75 07                	jne    80173e <sget+0x27>
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
  80173c:	eb 7f                	jmp    8017bd <sget+0xa6>
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
  801771:	eb 4a                	jmp    8017bd <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801773:	83 ec 04             	sub    $0x4,%esp
  801776:	ff 75 e8             	pushl  -0x18(%ebp)
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	ff 75 08             	pushl  0x8(%ebp)
  80177f:	e8 2c 03 00 00       	call   801ab0 <sys_getSharedObject>
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80178a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80178d:	a1 20 50 80 00       	mov    0x805020,%eax
  801792:	8b 40 78             	mov    0x78(%eax),%eax
  801795:	29 c2                	sub    %eax,%edx
  801797:	89 d0                	mov    %edx,%eax
  801799:	2d 00 10 00 00       	sub    $0x1000,%eax
  80179e:	c1 e8 0c             	shr    $0xc,%eax
  8017a1:	89 c2                	mov    %eax,%edx
  8017a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a6:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8017ad:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8017b1:	75 07                	jne    8017ba <sget+0xa3>
  8017b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b8:	eb 03                	jmp    8017bd <sget+0xa6>
	return ptr;
  8017ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8017c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8017cd:	8b 40 78             	mov    0x78(%eax),%eax
  8017d0:	29 c2                	sub    %eax,%edx
  8017d2:	89 d0                	mov    %edx,%eax
  8017d4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017d9:	c1 e8 0c             	shr    $0xc,%eax
  8017dc:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8017e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	ff 75 08             	pushl  0x8(%ebp)
  8017ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ef:	e8 db 02 00 00       	call   801acf <sys_freeSharedObject>
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8017fa:	90                   	nop
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	68 14 43 80 00       	push   $0x804314
  80180b:	68 de 00 00 00       	push   $0xde
  801810:	68 f6 42 80 00       	push   $0x8042f6
  801815:	e8 55 21 00 00       	call   80396f <_panic>

0080181a <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	68 3a 43 80 00       	push   $0x80433a
  801828:	68 ea 00 00 00       	push   $0xea
  80182d:	68 f6 42 80 00       	push   $0x8042f6
  801832:	e8 38 21 00 00       	call   80396f <_panic>

00801837 <shrink>:

}
void shrink(uint32 newSize)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183d:	83 ec 04             	sub    $0x4,%esp
  801840:	68 3a 43 80 00       	push   $0x80433a
  801845:	68 ef 00 00 00       	push   $0xef
  80184a:	68 f6 42 80 00       	push   $0x8042f6
  80184f:	e8 1b 21 00 00       	call   80396f <_panic>

00801854 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185a:	83 ec 04             	sub    $0x4,%esp
  80185d:	68 3a 43 80 00       	push   $0x80433a
  801862:	68 f4 00 00 00       	push   $0xf4
  801867:	68 f6 42 80 00       	push   $0x8042f6
  80186c:	e8 fe 20 00 00       	call   80396f <_panic>

00801871 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	57                   	push   %edi
  801875:	56                   	push   %esi
  801876:	53                   	push   %ebx
  801877:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801880:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801883:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801886:	8b 7d 18             	mov    0x18(%ebp),%edi
  801889:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80188c:	cd 30                	int    $0x30
  80188e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801891:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801894:	83 c4 10             	add    $0x10,%esp
  801897:	5b                   	pop    %ebx
  801898:	5e                   	pop    %esi
  801899:	5f                   	pop    %edi
  80189a:	5d                   	pop    %ebp
  80189b:	c3                   	ret    

0080189c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 04             	sub    $0x4,%esp
  8018a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	52                   	push   %edx
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	50                   	push   %eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	e8 b2 ff ff ff       	call   801871 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	90                   	nop
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 02                	push   $0x2
  8018d4:	e8 98 ff ff ff       	call   801871 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 03                	push   $0x3
  8018ed:	e8 7f ff ff ff       	call   801871 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	90                   	nop
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 04                	push   $0x4
  801907:	e8 65 ff ff ff       	call   801871 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	90                   	nop
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801915:	8b 55 0c             	mov    0xc(%ebp),%edx
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	52                   	push   %edx
  801922:	50                   	push   %eax
  801923:	6a 08                	push   $0x8
  801925:	e8 47 ff ff ff       	call   801871 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	56                   	push   %esi
  801933:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801934:	8b 75 18             	mov    0x18(%ebp),%esi
  801937:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80193a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	56                   	push   %esi
  801944:	53                   	push   %ebx
  801945:	51                   	push   %ecx
  801946:	52                   	push   %edx
  801947:	50                   	push   %eax
  801948:	6a 09                	push   $0x9
  80194a:	e8 22 ff ff ff       	call   801871 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801955:	5b                   	pop    %ebx
  801956:	5e                   	pop    %esi
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    

00801959 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80195c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195f:	8b 45 08             	mov    0x8(%ebp),%eax
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	52                   	push   %edx
  801969:	50                   	push   %eax
  80196a:	6a 0a                	push   $0xa
  80196c:	e8 00 ff ff ff       	call   801871 <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	ff 75 08             	pushl  0x8(%ebp)
  801985:	6a 0b                	push   $0xb
  801987:	e8 e5 fe ff ff       	call   801871 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 0c                	push   $0xc
  8019a0:	e8 cc fe ff ff       	call   801871 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 0d                	push   $0xd
  8019b9:	e8 b3 fe ff ff       	call   801871 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 0e                	push   $0xe
  8019d2:	e8 9a fe ff ff       	call   801871 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 0f                	push   $0xf
  8019eb:	e8 81 fe ff ff       	call   801871 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	ff 75 08             	pushl  0x8(%ebp)
  801a03:	6a 10                	push   $0x10
  801a05:	e8 67 fe ff ff       	call   801871 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 11                	push   $0x11
  801a1e:	e8 4e fe ff ff       	call   801871 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	90                   	nop
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a35:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	50                   	push   %eax
  801a42:	6a 01                	push   $0x1
  801a44:	e8 28 fe ff ff       	call   801871 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	90                   	nop
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 14                	push   $0x14
  801a5e:	e8 0e fe ff ff       	call   801871 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	90                   	nop
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 04             	sub    $0x4,%esp
  801a6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a72:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a75:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a78:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	6a 00                	push   $0x0
  801a81:	51                   	push   %ecx
  801a82:	52                   	push   %edx
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	50                   	push   %eax
  801a87:	6a 15                	push   $0x15
  801a89:	e8 e3 fd ff ff       	call   801871 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	52                   	push   %edx
  801aa3:	50                   	push   %eax
  801aa4:	6a 16                	push   $0x16
  801aa6:	e8 c6 fd ff ff       	call   801871 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ab3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	51                   	push   %ecx
  801ac1:	52                   	push   %edx
  801ac2:	50                   	push   %eax
  801ac3:	6a 17                	push   $0x17
  801ac5:	e8 a7 fd ff ff       	call   801871 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	52                   	push   %edx
  801adf:	50                   	push   %eax
  801ae0:	6a 18                	push   $0x18
  801ae2:	e8 8a fd ff ff       	call   801871 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	ff 75 14             	pushl  0x14(%ebp)
  801af7:	ff 75 10             	pushl  0x10(%ebp)
  801afa:	ff 75 0c             	pushl  0xc(%ebp)
  801afd:	50                   	push   %eax
  801afe:	6a 19                	push   $0x19
  801b00:	e8 6c fd ff ff       	call   801871 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	50                   	push   %eax
  801b19:	6a 1a                	push   $0x1a
  801b1b:	e8 51 fd ff ff       	call   801871 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	90                   	nop
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	50                   	push   %eax
  801b35:	6a 1b                	push   $0x1b
  801b37:	e8 35 fd ff ff       	call   801871 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 05                	push   $0x5
  801b50:	e8 1c fd ff ff       	call   801871 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 06                	push   $0x6
  801b69:	e8 03 fd ff ff       	call   801871 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 07                	push   $0x7
  801b82:	e8 ea fc ff ff       	call   801871 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_exit_env>:


void sys_exit_env(void)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 1c                	push   $0x1c
  801b9b:	e8 d1 fc ff ff       	call   801871 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	90                   	nop
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801baf:	8d 50 04             	lea    0x4(%eax),%edx
  801bb2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	52                   	push   %edx
  801bbc:	50                   	push   %eax
  801bbd:	6a 1d                	push   $0x1d
  801bbf:	e8 ad fc ff ff       	call   801871 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
	return result;
  801bc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bd0:	89 01                	mov    %eax,(%ecx)
  801bd2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	c9                   	leave  
  801bd9:	c2 04 00             	ret    $0x4

00801bdc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	ff 75 10             	pushl  0x10(%ebp)
  801be6:	ff 75 0c             	pushl  0xc(%ebp)
  801be9:	ff 75 08             	pushl  0x8(%ebp)
  801bec:	6a 13                	push   $0x13
  801bee:	e8 7e fc ff ff       	call   801871 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf6:	90                   	nop
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 1e                	push   $0x1e
  801c08:	e8 64 fc ff ff       	call   801871 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 04             	sub    $0x4,%esp
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c1e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	50                   	push   %eax
  801c2b:	6a 1f                	push   $0x1f
  801c2d:	e8 3f fc ff ff       	call   801871 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
	return ;
  801c35:	90                   	nop
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <rsttst>:
void rsttst()
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 21                	push   $0x21
  801c47:	e8 25 fc ff ff       	call   801871 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4f:	90                   	nop
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	83 ec 04             	sub    $0x4,%esp
  801c58:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c5e:	8b 55 18             	mov    0x18(%ebp),%edx
  801c61:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c65:	52                   	push   %edx
  801c66:	50                   	push   %eax
  801c67:	ff 75 10             	pushl  0x10(%ebp)
  801c6a:	ff 75 0c             	pushl  0xc(%ebp)
  801c6d:	ff 75 08             	pushl  0x8(%ebp)
  801c70:	6a 20                	push   $0x20
  801c72:	e8 fa fb ff ff       	call   801871 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7a:	90                   	nop
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <chktst>:
void chktst(uint32 n)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	ff 75 08             	pushl  0x8(%ebp)
  801c8b:	6a 22                	push   $0x22
  801c8d:	e8 df fb ff ff       	call   801871 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
	return ;
  801c95:	90                   	nop
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <inctst>:

void inctst()
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 23                	push   $0x23
  801ca7:	e8 c5 fb ff ff       	call   801871 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
	return ;
  801caf:	90                   	nop
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <gettst>:
uint32 gettst()
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 24                	push   $0x24
  801cc1:	e8 ab fb ff ff       	call   801871 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 25                	push   $0x25
  801cdd:	e8 8f fb ff ff       	call   801871 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
  801ce5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ce8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cec:	75 07                	jne    801cf5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cee:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf3:	eb 05                	jmp    801cfa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 25                	push   $0x25
  801d0e:	e8 5e fb ff ff       	call   801871 <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
  801d16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d19:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d1d:	75 07                	jne    801d26 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d24:	eb 05                	jmp    801d2b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 25                	push   $0x25
  801d3f:	e8 2d fb ff ff       	call   801871 <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
  801d47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d4a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d4e:	75 07                	jne    801d57 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d50:	b8 01 00 00 00       	mov    $0x1,%eax
  801d55:	eb 05                	jmp    801d5c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 25                	push   $0x25
  801d70:	e8 fc fa ff ff       	call   801871 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
  801d78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d7b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d7f:	75 07                	jne    801d88 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d81:	b8 01 00 00 00       	mov    $0x1,%eax
  801d86:	eb 05                	jmp    801d8d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	ff 75 08             	pushl  0x8(%ebp)
  801d9d:	6a 26                	push   $0x26
  801d9f:	e8 cd fa ff ff       	call   801871 <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
	return ;
  801da7:	90                   	nop
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	6a 00                	push   $0x0
  801dbc:	53                   	push   %ebx
  801dbd:	51                   	push   %ecx
  801dbe:	52                   	push   %edx
  801dbf:	50                   	push   %eax
  801dc0:	6a 27                	push   $0x27
  801dc2:	e8 aa fa ff ff       	call   801871 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	52                   	push   %edx
  801ddf:	50                   	push   %eax
  801de0:	6a 28                	push   $0x28
  801de2:	e8 8a fa ff ff       	call   801871 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801def:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801df2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	6a 00                	push   $0x0
  801dfa:	51                   	push   %ecx
  801dfb:	ff 75 10             	pushl  0x10(%ebp)
  801dfe:	52                   	push   %edx
  801dff:	50                   	push   %eax
  801e00:	6a 29                	push   $0x29
  801e02:	e8 6a fa ff ff       	call   801871 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	ff 75 10             	pushl  0x10(%ebp)
  801e16:	ff 75 0c             	pushl  0xc(%ebp)
  801e19:	ff 75 08             	pushl  0x8(%ebp)
  801e1c:	6a 12                	push   $0x12
  801e1e:	e8 4e fa ff ff       	call   801871 <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
	return ;
  801e26:	90                   	nop
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	52                   	push   %edx
  801e39:	50                   	push   %eax
  801e3a:	6a 2a                	push   $0x2a
  801e3c:	e8 30 fa ff ff       	call   801871 <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
	return;
  801e44:	90                   	nop
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	50                   	push   %eax
  801e56:	6a 2b                	push   $0x2b
  801e58:	e8 14 fa ff ff       	call   801871 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	ff 75 0c             	pushl  0xc(%ebp)
  801e6e:	ff 75 08             	pushl  0x8(%ebp)
  801e71:	6a 2c                	push   $0x2c
  801e73:	e8 f9 f9 ff ff       	call   801871 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
	return;
  801e7b:	90                   	nop
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	ff 75 0c             	pushl  0xc(%ebp)
  801e8a:	ff 75 08             	pushl  0x8(%ebp)
  801e8d:	6a 2d                	push   $0x2d
  801e8f:	e8 dd f9 ff ff       	call   801871 <syscall>
  801e94:	83 c4 18             	add    $0x18,%esp
	return;
  801e97:	90                   	nop
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	83 e8 04             	sub    $0x4,%eax
  801ea6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eac:	8b 00                	mov    (%eax),%eax
  801eae:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	83 e8 04             	sub    $0x4,%eax
  801ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ec5:	8b 00                	mov    (%eax),%eax
  801ec7:	83 e0 01             	and    $0x1,%eax
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	0f 94 c0             	sete   %al
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ed7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee1:	83 f8 02             	cmp    $0x2,%eax
  801ee4:	74 2b                	je     801f11 <alloc_block+0x40>
  801ee6:	83 f8 02             	cmp    $0x2,%eax
  801ee9:	7f 07                	jg     801ef2 <alloc_block+0x21>
  801eeb:	83 f8 01             	cmp    $0x1,%eax
  801eee:	74 0e                	je     801efe <alloc_block+0x2d>
  801ef0:	eb 58                	jmp    801f4a <alloc_block+0x79>
  801ef2:	83 f8 03             	cmp    $0x3,%eax
  801ef5:	74 2d                	je     801f24 <alloc_block+0x53>
  801ef7:	83 f8 04             	cmp    $0x4,%eax
  801efa:	74 3b                	je     801f37 <alloc_block+0x66>
  801efc:	eb 4c                	jmp    801f4a <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801efe:	83 ec 0c             	sub    $0xc,%esp
  801f01:	ff 75 08             	pushl  0x8(%ebp)
  801f04:	e8 11 03 00 00       	call   80221a <alloc_block_FF>
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f0f:	eb 4a                	jmp    801f5b <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f11:	83 ec 0c             	sub    $0xc,%esp
  801f14:	ff 75 08             	pushl  0x8(%ebp)
  801f17:	e8 fa 19 00 00       	call   803916 <alloc_block_NF>
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f22:	eb 37                	jmp    801f5b <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f24:	83 ec 0c             	sub    $0xc,%esp
  801f27:	ff 75 08             	pushl  0x8(%ebp)
  801f2a:	e8 a7 07 00 00       	call   8026d6 <alloc_block_BF>
  801f2f:	83 c4 10             	add    $0x10,%esp
  801f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f35:	eb 24                	jmp    801f5b <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f37:	83 ec 0c             	sub    $0xc,%esp
  801f3a:	ff 75 08             	pushl  0x8(%ebp)
  801f3d:	e8 b7 19 00 00       	call   8038f9 <alloc_block_WF>
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f48:	eb 11                	jmp    801f5b <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f4a:	83 ec 0c             	sub    $0xc,%esp
  801f4d:	68 4c 43 80 00       	push   $0x80434c
  801f52:	e8 33 e4 ff ff       	call   80038a <cprintf>
  801f57:	83 c4 10             	add    $0x10,%esp
		break;
  801f5a:	90                   	nop
	}
	return va;
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	53                   	push   %ebx
  801f64:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f67:	83 ec 0c             	sub    $0xc,%esp
  801f6a:	68 6c 43 80 00       	push   $0x80436c
  801f6f:	e8 16 e4 ff ff       	call   80038a <cprintf>
  801f74:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f77:	83 ec 0c             	sub    $0xc,%esp
  801f7a:	68 97 43 80 00       	push   $0x804397
  801f7f:	e8 06 e4 ff ff       	call   80038a <cprintf>
  801f84:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8d:	eb 37                	jmp    801fc6 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f8f:	83 ec 0c             	sub    $0xc,%esp
  801f92:	ff 75 f4             	pushl  -0xc(%ebp)
  801f95:	e8 19 ff ff ff       	call   801eb3 <is_free_block>
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	0f be d8             	movsbl %al,%ebx
  801fa0:	83 ec 0c             	sub    $0xc,%esp
  801fa3:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa6:	e8 ef fe ff ff       	call   801e9a <get_block_size>
  801fab:	83 c4 10             	add    $0x10,%esp
  801fae:	83 ec 04             	sub    $0x4,%esp
  801fb1:	53                   	push   %ebx
  801fb2:	50                   	push   %eax
  801fb3:	68 af 43 80 00       	push   $0x8043af
  801fb8:	e8 cd e3 ff ff       	call   80038a <cprintf>
  801fbd:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fca:	74 07                	je     801fd3 <print_blocks_list+0x73>
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	8b 00                	mov    (%eax),%eax
  801fd1:	eb 05                	jmp    801fd8 <print_blocks_list+0x78>
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	89 45 10             	mov    %eax,0x10(%ebp)
  801fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	75 ad                	jne    801f8f <print_blocks_list+0x2f>
  801fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe6:	75 a7                	jne    801f8f <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	68 6c 43 80 00       	push   $0x80436c
  801ff0:	e8 95 e3 ff ff       	call   80038a <cprintf>
  801ff5:	83 c4 10             	add    $0x10,%esp

}
  801ff8:	90                   	nop
  801ff9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802004:	8b 45 0c             	mov    0xc(%ebp),%eax
  802007:	83 e0 01             	and    $0x1,%eax
  80200a:	85 c0                	test   %eax,%eax
  80200c:	74 03                	je     802011 <initialize_dynamic_allocator+0x13>
  80200e:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  802011:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802015:	0f 84 c7 01 00 00    	je     8021e2 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  80201b:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802022:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802025:	8b 55 08             	mov    0x8(%ebp),%edx
  802028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202b:	01 d0                	add    %edx,%eax
  80202d:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802032:	0f 87 ad 01 00 00    	ja     8021e5 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	85 c0                	test   %eax,%eax
  80203d:	0f 89 a5 01 00 00    	jns    8021e8 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802043:	8b 55 08             	mov    0x8(%ebp),%edx
  802046:	8b 45 0c             	mov    0xc(%ebp),%eax
  802049:	01 d0                	add    %edx,%eax
  80204b:	83 e8 04             	sub    $0x4,%eax
  80204e:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802053:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80205a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80205f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802062:	e9 87 00 00 00       	jmp    8020ee <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802067:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206b:	75 14                	jne    802081 <initialize_dynamic_allocator+0x83>
  80206d:	83 ec 04             	sub    $0x4,%esp
  802070:	68 c7 43 80 00       	push   $0x8043c7
  802075:	6a 79                	push   $0x79
  802077:	68 e5 43 80 00       	push   $0x8043e5
  80207c:	e8 ee 18 00 00       	call   80396f <_panic>
  802081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802084:	8b 00                	mov    (%eax),%eax
  802086:	85 c0                	test   %eax,%eax
  802088:	74 10                	je     80209a <initialize_dynamic_allocator+0x9c>
  80208a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208d:	8b 00                	mov    (%eax),%eax
  80208f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802092:	8b 52 04             	mov    0x4(%edx),%edx
  802095:	89 50 04             	mov    %edx,0x4(%eax)
  802098:	eb 0b                	jmp    8020a5 <initialize_dynamic_allocator+0xa7>
  80209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209d:	8b 40 04             	mov    0x4(%eax),%eax
  8020a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8020a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a8:	8b 40 04             	mov    0x4(%eax),%eax
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	74 0f                	je     8020be <initialize_dynamic_allocator+0xc0>
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	8b 40 04             	mov    0x4(%eax),%eax
  8020b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b8:	8b 12                	mov    (%edx),%edx
  8020ba:	89 10                	mov    %edx,(%eax)
  8020bc:	eb 0a                	jmp    8020c8 <initialize_dynamic_allocator+0xca>
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	8b 00                	mov    (%eax),%eax
  8020c3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020db:	a1 38 50 80 00       	mov    0x805038,%eax
  8020e0:	48                   	dec    %eax
  8020e1:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8020e6:	a1 34 50 80 00       	mov    0x805034,%eax
  8020eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f2:	74 07                	je     8020fb <initialize_dynamic_allocator+0xfd>
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	8b 00                	mov    (%eax),%eax
  8020f9:	eb 05                	jmp    802100 <initialize_dynamic_allocator+0x102>
  8020fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802100:	a3 34 50 80 00       	mov    %eax,0x805034
  802105:	a1 34 50 80 00       	mov    0x805034,%eax
  80210a:	85 c0                	test   %eax,%eax
  80210c:	0f 85 55 ff ff ff    	jne    802067 <initialize_dynamic_allocator+0x69>
  802112:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802116:	0f 85 4b ff ff ff    	jne    802067 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802122:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802125:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  80212b:	a1 44 50 80 00       	mov    0x805044,%eax
  802130:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802135:	a1 40 50 80 00       	mov    0x805040,%eax
  80213a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	83 c0 08             	add    $0x8,%eax
  802146:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	83 c0 04             	add    $0x4,%eax
  80214f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802152:	83 ea 08             	sub    $0x8,%edx
  802155:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	01 d0                	add    %edx,%eax
  80215f:	83 e8 08             	sub    $0x8,%eax
  802162:	8b 55 0c             	mov    0xc(%ebp),%edx
  802165:	83 ea 08             	sub    $0x8,%edx
  802168:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80216a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802176:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80217d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802181:	75 17                	jne    80219a <initialize_dynamic_allocator+0x19c>
  802183:	83 ec 04             	sub    $0x4,%esp
  802186:	68 00 44 80 00       	push   $0x804400
  80218b:	68 90 00 00 00       	push   $0x90
  802190:	68 e5 43 80 00       	push   $0x8043e5
  802195:	e8 d5 17 00 00       	call   80396f <_panic>
  80219a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a3:	89 10                	mov    %edx,(%eax)
  8021a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a8:	8b 00                	mov    (%eax),%eax
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	74 0d                	je     8021bb <initialize_dynamic_allocator+0x1bd>
  8021ae:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021b6:	89 50 04             	mov    %edx,0x4(%eax)
  8021b9:	eb 08                	jmp    8021c3 <initialize_dynamic_allocator+0x1c5>
  8021bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021be:	a3 30 50 80 00       	mov    %eax,0x805030
  8021c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8021da:	40                   	inc    %eax
  8021db:	a3 38 50 80 00       	mov    %eax,0x805038
  8021e0:	eb 07                	jmp    8021e9 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8021e2:	90                   	nop
  8021e3:	eb 04                	jmp    8021e9 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8021e5:	90                   	nop
  8021e6:	eb 01                	jmp    8021e9 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8021e8:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f1:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fd:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	83 e8 04             	sub    $0x4,%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	83 e0 fe             	and    $0xfffffffe,%eax
  80220a:	8d 50 f8             	lea    -0x8(%eax),%edx
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	01 c2                	add    %eax,%edx
  802212:	8b 45 0c             	mov    0xc(%ebp),%eax
  802215:	89 02                	mov    %eax,(%edx)
}
  802217:	90                   	nop
  802218:	5d                   	pop    %ebp
  802219:	c3                   	ret    

0080221a <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	83 e0 01             	and    $0x1,%eax
  802226:	85 c0                	test   %eax,%eax
  802228:	74 03                	je     80222d <alloc_block_FF+0x13>
  80222a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80222d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802231:	77 07                	ja     80223a <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802233:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80223a:	a1 24 50 80 00       	mov    0x805024,%eax
  80223f:	85 c0                	test   %eax,%eax
  802241:	75 73                	jne    8022b6 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	83 c0 10             	add    $0x10,%eax
  802249:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80224c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802253:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802256:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802259:	01 d0                	add    %edx,%eax
  80225b:	48                   	dec    %eax
  80225c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80225f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802262:	ba 00 00 00 00       	mov    $0x0,%edx
  802267:	f7 75 ec             	divl   -0x14(%ebp)
  80226a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80226d:	29 d0                	sub    %edx,%eax
  80226f:	c1 e8 0c             	shr    $0xc,%eax
  802272:	83 ec 0c             	sub    $0xc,%esp
  802275:	50                   	push   %eax
  802276:	e8 b1 f0 ff ff       	call   80132c <sbrk>
  80227b:	83 c4 10             	add    $0x10,%esp
  80227e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802281:	83 ec 0c             	sub    $0xc,%esp
  802284:	6a 00                	push   $0x0
  802286:	e8 a1 f0 ff ff       	call   80132c <sbrk>
  80228b:	83 c4 10             	add    $0x10,%esp
  80228e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802291:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802294:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802297:	83 ec 08             	sub    $0x8,%esp
  80229a:	50                   	push   %eax
  80229b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80229e:	e8 5b fd ff ff       	call   801ffe <initialize_dynamic_allocator>
  8022a3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022a6:	83 ec 0c             	sub    $0xc,%esp
  8022a9:	68 23 44 80 00       	push   $0x804423
  8022ae:	e8 d7 e0 ff ff       	call   80038a <cprintf>
  8022b3:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ba:	75 0a                	jne    8022c6 <alloc_block_FF+0xac>
	        return NULL;
  8022bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c1:	e9 0e 04 00 00       	jmp    8026d4 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8022c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022cd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d5:	e9 f3 02 00 00       	jmp    8025cd <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022e0:	83 ec 0c             	sub    $0xc,%esp
  8022e3:	ff 75 bc             	pushl  -0x44(%ebp)
  8022e6:	e8 af fb ff ff       	call   801e9a <get_block_size>
  8022eb:	83 c4 10             	add    $0x10,%esp
  8022ee:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	83 c0 08             	add    $0x8,%eax
  8022f7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022fa:	0f 87 c5 02 00 00    	ja     8025c5 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	83 c0 18             	add    $0x18,%eax
  802306:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802309:	0f 87 19 02 00 00    	ja     802528 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80230f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802312:	2b 45 08             	sub    0x8(%ebp),%eax
  802315:	83 e8 08             	sub    $0x8,%eax
  802318:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8d 50 08             	lea    0x8(%eax),%edx
  802321:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802324:	01 d0                	add    %edx,%eax
  802326:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	83 c0 08             	add    $0x8,%eax
  80232f:	83 ec 04             	sub    $0x4,%esp
  802332:	6a 01                	push   $0x1
  802334:	50                   	push   %eax
  802335:	ff 75 bc             	pushl  -0x44(%ebp)
  802338:	e8 ae fe ff ff       	call   8021eb <set_block_data>
  80233d:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 40 04             	mov    0x4(%eax),%eax
  802346:	85 c0                	test   %eax,%eax
  802348:	75 68                	jne    8023b2 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80234a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80234e:	75 17                	jne    802367 <alloc_block_FF+0x14d>
  802350:	83 ec 04             	sub    $0x4,%esp
  802353:	68 00 44 80 00       	push   $0x804400
  802358:	68 d7 00 00 00       	push   $0xd7
  80235d:	68 e5 43 80 00       	push   $0x8043e5
  802362:	e8 08 16 00 00       	call   80396f <_panic>
  802367:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80236d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802370:	89 10                	mov    %edx,(%eax)
  802372:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802375:	8b 00                	mov    (%eax),%eax
  802377:	85 c0                	test   %eax,%eax
  802379:	74 0d                	je     802388 <alloc_block_FF+0x16e>
  80237b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802380:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802383:	89 50 04             	mov    %edx,0x4(%eax)
  802386:	eb 08                	jmp    802390 <alloc_block_FF+0x176>
  802388:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80238b:	a3 30 50 80 00       	mov    %eax,0x805030
  802390:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802393:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802398:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80239b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a2:	a1 38 50 80 00       	mov    0x805038,%eax
  8023a7:	40                   	inc    %eax
  8023a8:	a3 38 50 80 00       	mov    %eax,0x805038
  8023ad:	e9 dc 00 00 00       	jmp    80248e <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	75 65                	jne    802420 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023bb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023bf:	75 17                	jne    8023d8 <alloc_block_FF+0x1be>
  8023c1:	83 ec 04             	sub    $0x4,%esp
  8023c4:	68 34 44 80 00       	push   $0x804434
  8023c9:	68 db 00 00 00       	push   $0xdb
  8023ce:	68 e5 43 80 00       	push   $0x8043e5
  8023d3:	e8 97 15 00 00       	call   80396f <_panic>
  8023d8:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e1:	89 50 04             	mov    %edx,0x4(%eax)
  8023e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 0c                	je     8023fa <alloc_block_FF+0x1e0>
  8023ee:	a1 30 50 80 00       	mov    0x805030,%eax
  8023f3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023f6:	89 10                	mov    %edx,(%eax)
  8023f8:	eb 08                	jmp    802402 <alloc_block_FF+0x1e8>
  8023fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023fd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802402:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802405:	a3 30 50 80 00       	mov    %eax,0x805030
  80240a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802413:	a1 38 50 80 00       	mov    0x805038,%eax
  802418:	40                   	inc    %eax
  802419:	a3 38 50 80 00       	mov    %eax,0x805038
  80241e:	eb 6e                	jmp    80248e <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802424:	74 06                	je     80242c <alloc_block_FF+0x212>
  802426:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80242a:	75 17                	jne    802443 <alloc_block_FF+0x229>
  80242c:	83 ec 04             	sub    $0x4,%esp
  80242f:	68 58 44 80 00       	push   $0x804458
  802434:	68 df 00 00 00       	push   $0xdf
  802439:	68 e5 43 80 00       	push   $0x8043e5
  80243e:	e8 2c 15 00 00       	call   80396f <_panic>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 10                	mov    (%eax),%edx
  802448:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244b:	89 10                	mov    %edx,(%eax)
  80244d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802450:	8b 00                	mov    (%eax),%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	74 0b                	je     802461 <alloc_block_FF+0x247>
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 00                	mov    (%eax),%eax
  80245b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80245e:	89 50 04             	mov    %edx,0x4(%eax)
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802467:	89 10                	mov    %edx,(%eax)
  802469:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246f:	89 50 04             	mov    %edx,0x4(%eax)
  802472:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802475:	8b 00                	mov    (%eax),%eax
  802477:	85 c0                	test   %eax,%eax
  802479:	75 08                	jne    802483 <alloc_block_FF+0x269>
  80247b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247e:	a3 30 50 80 00       	mov    %eax,0x805030
  802483:	a1 38 50 80 00       	mov    0x805038,%eax
  802488:	40                   	inc    %eax
  802489:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80248e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802492:	75 17                	jne    8024ab <alloc_block_FF+0x291>
  802494:	83 ec 04             	sub    $0x4,%esp
  802497:	68 c7 43 80 00       	push   $0x8043c7
  80249c:	68 e1 00 00 00       	push   $0xe1
  8024a1:	68 e5 43 80 00       	push   $0x8043e5
  8024a6:	e8 c4 14 00 00       	call   80396f <_panic>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	74 10                	je     8024c4 <alloc_block_FF+0x2aa>
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 00                	mov    (%eax),%eax
  8024b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bc:	8b 52 04             	mov    0x4(%edx),%edx
  8024bf:	89 50 04             	mov    %edx,0x4(%eax)
  8024c2:	eb 0b                	jmp    8024cf <alloc_block_FF+0x2b5>
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 40 04             	mov    0x4(%eax),%eax
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	74 0f                	je     8024e8 <alloc_block_FF+0x2ce>
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	8b 40 04             	mov    0x4(%eax),%eax
  8024df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e2:	8b 12                	mov    (%edx),%edx
  8024e4:	89 10                	mov    %edx,(%eax)
  8024e6:	eb 0a                	jmp    8024f2 <alloc_block_FF+0x2d8>
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 00                	mov    (%eax),%eax
  8024ed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802505:	a1 38 50 80 00       	mov    0x805038,%eax
  80250a:	48                   	dec    %eax
  80250b:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	6a 00                	push   $0x0
  802515:	ff 75 b4             	pushl  -0x4c(%ebp)
  802518:	ff 75 b0             	pushl  -0x50(%ebp)
  80251b:	e8 cb fc ff ff       	call   8021eb <set_block_data>
  802520:	83 c4 10             	add    $0x10,%esp
  802523:	e9 95 00 00 00       	jmp    8025bd <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802528:	83 ec 04             	sub    $0x4,%esp
  80252b:	6a 01                	push   $0x1
  80252d:	ff 75 b8             	pushl  -0x48(%ebp)
  802530:	ff 75 bc             	pushl  -0x44(%ebp)
  802533:	e8 b3 fc ff ff       	call   8021eb <set_block_data>
  802538:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80253b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253f:	75 17                	jne    802558 <alloc_block_FF+0x33e>
  802541:	83 ec 04             	sub    $0x4,%esp
  802544:	68 c7 43 80 00       	push   $0x8043c7
  802549:	68 e8 00 00 00       	push   $0xe8
  80254e:	68 e5 43 80 00       	push   $0x8043e5
  802553:	e8 17 14 00 00       	call   80396f <_panic>
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 00                	mov    (%eax),%eax
  80255d:	85 c0                	test   %eax,%eax
  80255f:	74 10                	je     802571 <alloc_block_FF+0x357>
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 00                	mov    (%eax),%eax
  802566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802569:	8b 52 04             	mov    0x4(%edx),%edx
  80256c:	89 50 04             	mov    %edx,0x4(%eax)
  80256f:	eb 0b                	jmp    80257c <alloc_block_FF+0x362>
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 40 04             	mov    0x4(%eax),%eax
  802577:	a3 30 50 80 00       	mov    %eax,0x805030
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 40 04             	mov    0x4(%eax),%eax
  802582:	85 c0                	test   %eax,%eax
  802584:	74 0f                	je     802595 <alloc_block_FF+0x37b>
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	8b 40 04             	mov    0x4(%eax),%eax
  80258c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258f:	8b 12                	mov    (%edx),%edx
  802591:	89 10                	mov    %edx,(%eax)
  802593:	eb 0a                	jmp    80259f <alloc_block_FF+0x385>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8025b7:	48                   	dec    %eax
  8025b8:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8025bd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025c0:	e9 0f 01 00 00       	jmp    8026d4 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8025c5:	a1 34 50 80 00       	mov    0x805034,%eax
  8025ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d1:	74 07                	je     8025da <alloc_block_FF+0x3c0>
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	eb 05                	jmp    8025df <alloc_block_FF+0x3c5>
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
  8025df:	a3 34 50 80 00       	mov    %eax,0x805034
  8025e4:	a1 34 50 80 00       	mov    0x805034,%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	0f 85 e9 fc ff ff    	jne    8022da <alloc_block_FF+0xc0>
  8025f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f5:	0f 85 df fc ff ff    	jne    8022da <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	83 c0 08             	add    $0x8,%eax
  802601:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802604:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80260b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80260e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802611:	01 d0                	add    %edx,%eax
  802613:	48                   	dec    %eax
  802614:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802617:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80261a:	ba 00 00 00 00       	mov    $0x0,%edx
  80261f:	f7 75 d8             	divl   -0x28(%ebp)
  802622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802625:	29 d0                	sub    %edx,%eax
  802627:	c1 e8 0c             	shr    $0xc,%eax
  80262a:	83 ec 0c             	sub    $0xc,%esp
  80262d:	50                   	push   %eax
  80262e:	e8 f9 ec ff ff       	call   80132c <sbrk>
  802633:	83 c4 10             	add    $0x10,%esp
  802636:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802639:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80263d:	75 0a                	jne    802649 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80263f:	b8 00 00 00 00       	mov    $0x0,%eax
  802644:	e9 8b 00 00 00       	jmp    8026d4 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802649:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802650:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802653:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802656:	01 d0                	add    %edx,%eax
  802658:	48                   	dec    %eax
  802659:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80265c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80265f:	ba 00 00 00 00       	mov    $0x0,%edx
  802664:	f7 75 cc             	divl   -0x34(%ebp)
  802667:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80266a:	29 d0                	sub    %edx,%eax
  80266c:	8d 50 fc             	lea    -0x4(%eax),%edx
  80266f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802672:	01 d0                	add    %edx,%eax
  802674:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802679:	a1 40 50 80 00       	mov    0x805040,%eax
  80267e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802684:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80268b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80268e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802691:	01 d0                	add    %edx,%eax
  802693:	48                   	dec    %eax
  802694:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802697:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80269a:	ba 00 00 00 00       	mov    $0x0,%edx
  80269f:	f7 75 c4             	divl   -0x3c(%ebp)
  8026a2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026a5:	29 d0                	sub    %edx,%eax
  8026a7:	83 ec 04             	sub    $0x4,%esp
  8026aa:	6a 01                	push   $0x1
  8026ac:	50                   	push   %eax
  8026ad:	ff 75 d0             	pushl  -0x30(%ebp)
  8026b0:	e8 36 fb ff ff       	call   8021eb <set_block_data>
  8026b5:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026b8:	83 ec 0c             	sub    $0xc,%esp
  8026bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8026be:	e8 1b 0a 00 00       	call   8030de <free_block>
  8026c3:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8026c6:	83 ec 0c             	sub    $0xc,%esp
  8026c9:	ff 75 08             	pushl  0x8(%ebp)
  8026cc:	e8 49 fb ff ff       	call   80221a <alloc_block_FF>
  8026d1:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
  8026d9:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	83 e0 01             	and    $0x1,%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	74 03                	je     8026e9 <alloc_block_BF+0x13>
  8026e6:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026e9:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026ed:	77 07                	ja     8026f6 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026ef:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026f6:	a1 24 50 80 00       	mov    0x805024,%eax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	75 73                	jne    802772 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802702:	83 c0 10             	add    $0x10,%eax
  802705:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802708:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80270f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802715:	01 d0                	add    %edx,%eax
  802717:	48                   	dec    %eax
  802718:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80271b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80271e:	ba 00 00 00 00       	mov    $0x0,%edx
  802723:	f7 75 e0             	divl   -0x20(%ebp)
  802726:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802729:	29 d0                	sub    %edx,%eax
  80272b:	c1 e8 0c             	shr    $0xc,%eax
  80272e:	83 ec 0c             	sub    $0xc,%esp
  802731:	50                   	push   %eax
  802732:	e8 f5 eb ff ff       	call   80132c <sbrk>
  802737:	83 c4 10             	add    $0x10,%esp
  80273a:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80273d:	83 ec 0c             	sub    $0xc,%esp
  802740:	6a 00                	push   $0x0
  802742:	e8 e5 eb ff ff       	call   80132c <sbrk>
  802747:	83 c4 10             	add    $0x10,%esp
  80274a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80274d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802750:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802753:	83 ec 08             	sub    $0x8,%esp
  802756:	50                   	push   %eax
  802757:	ff 75 d8             	pushl  -0x28(%ebp)
  80275a:	e8 9f f8 ff ff       	call   801ffe <initialize_dynamic_allocator>
  80275f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802762:	83 ec 0c             	sub    $0xc,%esp
  802765:	68 23 44 80 00       	push   $0x804423
  80276a:	e8 1b dc ff ff       	call   80038a <cprintf>
  80276f:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802772:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802779:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802780:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802787:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80278e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802793:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802796:	e9 1d 01 00 00       	jmp    8028b8 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027a1:	83 ec 0c             	sub    $0xc,%esp
  8027a4:	ff 75 a8             	pushl  -0x58(%ebp)
  8027a7:	e8 ee f6 ff ff       	call   801e9a <get_block_size>
  8027ac:	83 c4 10             	add    $0x10,%esp
  8027af:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b5:	83 c0 08             	add    $0x8,%eax
  8027b8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027bb:	0f 87 ef 00 00 00    	ja     8028b0 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	83 c0 18             	add    $0x18,%eax
  8027c7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027ca:	77 1d                	ja     8027e9 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8027cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cf:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027d2:	0f 86 d8 00 00 00    	jbe    8028b0 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8027d8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027db:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8027de:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027e4:	e9 c7 00 00 00       	jmp    8028b0 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8027e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ec:	83 c0 08             	add    $0x8,%eax
  8027ef:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027f2:	0f 85 9d 00 00 00    	jne    802895 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027f8:	83 ec 04             	sub    $0x4,%esp
  8027fb:	6a 01                	push   $0x1
  8027fd:	ff 75 a4             	pushl  -0x5c(%ebp)
  802800:	ff 75 a8             	pushl  -0x58(%ebp)
  802803:	e8 e3 f9 ff ff       	call   8021eb <set_block_data>
  802808:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80280b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280f:	75 17                	jne    802828 <alloc_block_BF+0x152>
  802811:	83 ec 04             	sub    $0x4,%esp
  802814:	68 c7 43 80 00       	push   $0x8043c7
  802819:	68 2c 01 00 00       	push   $0x12c
  80281e:	68 e5 43 80 00       	push   $0x8043e5
  802823:	e8 47 11 00 00       	call   80396f <_panic>
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 00                	mov    (%eax),%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	74 10                	je     802841 <alloc_block_BF+0x16b>
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802839:	8b 52 04             	mov    0x4(%edx),%edx
  80283c:	89 50 04             	mov    %edx,0x4(%eax)
  80283f:	eb 0b                	jmp    80284c <alloc_block_BF+0x176>
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 40 04             	mov    0x4(%eax),%eax
  802847:	a3 30 50 80 00       	mov    %eax,0x805030
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 40 04             	mov    0x4(%eax),%eax
  802852:	85 c0                	test   %eax,%eax
  802854:	74 0f                	je     802865 <alloc_block_BF+0x18f>
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	8b 40 04             	mov    0x4(%eax),%eax
  80285c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285f:	8b 12                	mov    (%edx),%edx
  802861:	89 10                	mov    %edx,(%eax)
  802863:	eb 0a                	jmp    80286f <alloc_block_BF+0x199>
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 00                	mov    (%eax),%eax
  80286a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802882:	a1 38 50 80 00       	mov    0x805038,%eax
  802887:	48                   	dec    %eax
  802888:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80288d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802890:	e9 24 04 00 00       	jmp    802cb9 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802895:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802898:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80289b:	76 13                	jbe    8028b0 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80289d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028a4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8028aa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028ad:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8028b0:	a1 34 50 80 00       	mov    0x805034,%eax
  8028b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bc:	74 07                	je     8028c5 <alloc_block_BF+0x1ef>
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 00                	mov    (%eax),%eax
  8028c3:	eb 05                	jmp    8028ca <alloc_block_BF+0x1f4>
  8028c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ca:	a3 34 50 80 00       	mov    %eax,0x805034
  8028cf:	a1 34 50 80 00       	mov    0x805034,%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	0f 85 bf fe ff ff    	jne    80279b <alloc_block_BF+0xc5>
  8028dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e0:	0f 85 b5 fe ff ff    	jne    80279b <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8028e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ea:	0f 84 26 02 00 00    	je     802b16 <alloc_block_BF+0x440>
  8028f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028f4:	0f 85 1c 02 00 00    	jne    802b16 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fd:	2b 45 08             	sub    0x8(%ebp),%eax
  802900:	83 e8 08             	sub    $0x8,%eax
  802903:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802906:	8b 45 08             	mov    0x8(%ebp),%eax
  802909:	8d 50 08             	lea    0x8(%eax),%edx
  80290c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290f:	01 d0                	add    %edx,%eax
  802911:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802914:	8b 45 08             	mov    0x8(%ebp),%eax
  802917:	83 c0 08             	add    $0x8,%eax
  80291a:	83 ec 04             	sub    $0x4,%esp
  80291d:	6a 01                	push   $0x1
  80291f:	50                   	push   %eax
  802920:	ff 75 f0             	pushl  -0x10(%ebp)
  802923:	e8 c3 f8 ff ff       	call   8021eb <set_block_data>
  802928:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	8b 40 04             	mov    0x4(%eax),%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	75 68                	jne    80299d <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802935:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802939:	75 17                	jne    802952 <alloc_block_BF+0x27c>
  80293b:	83 ec 04             	sub    $0x4,%esp
  80293e:	68 00 44 80 00       	push   $0x804400
  802943:	68 45 01 00 00       	push   $0x145
  802948:	68 e5 43 80 00       	push   $0x8043e5
  80294d:	e8 1d 10 00 00       	call   80396f <_panic>
  802952:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802958:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295b:	89 10                	mov    %edx,(%eax)
  80295d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	74 0d                	je     802973 <alloc_block_BF+0x29d>
  802966:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80296b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80296e:	89 50 04             	mov    %edx,0x4(%eax)
  802971:	eb 08                	jmp    80297b <alloc_block_BF+0x2a5>
  802973:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802976:	a3 30 50 80 00       	mov    %eax,0x805030
  80297b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802983:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802986:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298d:	a1 38 50 80 00       	mov    0x805038,%eax
  802992:	40                   	inc    %eax
  802993:	a3 38 50 80 00       	mov    %eax,0x805038
  802998:	e9 dc 00 00 00       	jmp    802a79 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80299d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a0:	8b 00                	mov    (%eax),%eax
  8029a2:	85 c0                	test   %eax,%eax
  8029a4:	75 65                	jne    802a0b <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029aa:	75 17                	jne    8029c3 <alloc_block_BF+0x2ed>
  8029ac:	83 ec 04             	sub    $0x4,%esp
  8029af:	68 34 44 80 00       	push   $0x804434
  8029b4:	68 4a 01 00 00       	push   $0x14a
  8029b9:	68 e5 43 80 00       	push   $0x8043e5
  8029be:	e8 ac 0f 00 00       	call   80396f <_panic>
  8029c3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029cc:	89 50 04             	mov    %edx,0x4(%eax)
  8029cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d2:	8b 40 04             	mov    0x4(%eax),%eax
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	74 0c                	je     8029e5 <alloc_block_BF+0x30f>
  8029d9:	a1 30 50 80 00       	mov    0x805030,%eax
  8029de:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029e1:	89 10                	mov    %edx,(%eax)
  8029e3:	eb 08                	jmp    8029ed <alloc_block_BF+0x317>
  8029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8029f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fe:	a1 38 50 80 00       	mov    0x805038,%eax
  802a03:	40                   	inc    %eax
  802a04:	a3 38 50 80 00       	mov    %eax,0x805038
  802a09:	eb 6e                	jmp    802a79 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a0f:	74 06                	je     802a17 <alloc_block_BF+0x341>
  802a11:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a15:	75 17                	jne    802a2e <alloc_block_BF+0x358>
  802a17:	83 ec 04             	sub    $0x4,%esp
  802a1a:	68 58 44 80 00       	push   $0x804458
  802a1f:	68 4f 01 00 00       	push   $0x14f
  802a24:	68 e5 43 80 00       	push   $0x8043e5
  802a29:	e8 41 0f 00 00       	call   80396f <_panic>
  802a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a31:	8b 10                	mov    (%eax),%edx
  802a33:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a36:	89 10                	mov    %edx,(%eax)
  802a38:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	85 c0                	test   %eax,%eax
  802a3f:	74 0b                	je     802a4c <alloc_block_BF+0x376>
  802a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a44:	8b 00                	mov    (%eax),%eax
  802a46:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a49:	89 50 04             	mov    %edx,0x4(%eax)
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a52:	89 10                	mov    %edx,(%eax)
  802a54:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5a:	89 50 04             	mov    %edx,0x4(%eax)
  802a5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	85 c0                	test   %eax,%eax
  802a64:	75 08                	jne    802a6e <alloc_block_BF+0x398>
  802a66:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a69:	a3 30 50 80 00       	mov    %eax,0x805030
  802a6e:	a1 38 50 80 00       	mov    0x805038,%eax
  802a73:	40                   	inc    %eax
  802a74:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a7d:	75 17                	jne    802a96 <alloc_block_BF+0x3c0>
  802a7f:	83 ec 04             	sub    $0x4,%esp
  802a82:	68 c7 43 80 00       	push   $0x8043c7
  802a87:	68 51 01 00 00       	push   $0x151
  802a8c:	68 e5 43 80 00       	push   $0x8043e5
  802a91:	e8 d9 0e 00 00       	call   80396f <_panic>
  802a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a99:	8b 00                	mov    (%eax),%eax
  802a9b:	85 c0                	test   %eax,%eax
  802a9d:	74 10                	je     802aaf <alloc_block_BF+0x3d9>
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa7:	8b 52 04             	mov    0x4(%edx),%edx
  802aaa:	89 50 04             	mov    %edx,0x4(%eax)
  802aad:	eb 0b                	jmp    802aba <alloc_block_BF+0x3e4>
  802aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab2:	8b 40 04             	mov    0x4(%eax),%eax
  802ab5:	a3 30 50 80 00       	mov    %eax,0x805030
  802aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abd:	8b 40 04             	mov    0x4(%eax),%eax
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	74 0f                	je     802ad3 <alloc_block_BF+0x3fd>
  802ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac7:	8b 40 04             	mov    0x4(%eax),%eax
  802aca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802acd:	8b 12                	mov    (%edx),%edx
  802acf:	89 10                	mov    %edx,(%eax)
  802ad1:	eb 0a                	jmp    802add <alloc_block_BF+0x407>
  802ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad6:	8b 00                	mov    (%eax),%eax
  802ad8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af0:	a1 38 50 80 00       	mov    0x805038,%eax
  802af5:	48                   	dec    %eax
  802af6:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802afb:	83 ec 04             	sub    $0x4,%esp
  802afe:	6a 00                	push   $0x0
  802b00:	ff 75 d0             	pushl  -0x30(%ebp)
  802b03:	ff 75 cc             	pushl  -0x34(%ebp)
  802b06:	e8 e0 f6 ff ff       	call   8021eb <set_block_data>
  802b0b:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b11:	e9 a3 01 00 00       	jmp    802cb9 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b16:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b1a:	0f 85 9d 00 00 00    	jne    802bbd <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b20:	83 ec 04             	sub    $0x4,%esp
  802b23:	6a 01                	push   $0x1
  802b25:	ff 75 ec             	pushl  -0x14(%ebp)
  802b28:	ff 75 f0             	pushl  -0x10(%ebp)
  802b2b:	e8 bb f6 ff ff       	call   8021eb <set_block_data>
  802b30:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b37:	75 17                	jne    802b50 <alloc_block_BF+0x47a>
  802b39:	83 ec 04             	sub    $0x4,%esp
  802b3c:	68 c7 43 80 00       	push   $0x8043c7
  802b41:	68 58 01 00 00       	push   $0x158
  802b46:	68 e5 43 80 00       	push   $0x8043e5
  802b4b:	e8 1f 0e 00 00       	call   80396f <_panic>
  802b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	74 10                	je     802b69 <alloc_block_BF+0x493>
  802b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b61:	8b 52 04             	mov    0x4(%edx),%edx
  802b64:	89 50 04             	mov    %edx,0x4(%eax)
  802b67:	eb 0b                	jmp    802b74 <alloc_block_BF+0x49e>
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	8b 40 04             	mov    0x4(%eax),%eax
  802b6f:	a3 30 50 80 00       	mov    %eax,0x805030
  802b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b77:	8b 40 04             	mov    0x4(%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 0f                	je     802b8d <alloc_block_BF+0x4b7>
  802b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b81:	8b 40 04             	mov    0x4(%eax),%eax
  802b84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b87:	8b 12                	mov    (%edx),%edx
  802b89:	89 10                	mov    %edx,(%eax)
  802b8b:	eb 0a                	jmp    802b97 <alloc_block_BF+0x4c1>
  802b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802baa:	a1 38 50 80 00       	mov    0x805038,%eax
  802baf:	48                   	dec    %eax
  802bb0:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb8:	e9 fc 00 00 00       	jmp    802cb9 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	83 c0 08             	add    $0x8,%eax
  802bc3:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802bc6:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802bcd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bd0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bd3:	01 d0                	add    %edx,%eax
  802bd5:	48                   	dec    %eax
  802bd6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bd9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bdc:	ba 00 00 00 00       	mov    $0x0,%edx
  802be1:	f7 75 c4             	divl   -0x3c(%ebp)
  802be4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802be7:	29 d0                	sub    %edx,%eax
  802be9:	c1 e8 0c             	shr    $0xc,%eax
  802bec:	83 ec 0c             	sub    $0xc,%esp
  802bef:	50                   	push   %eax
  802bf0:	e8 37 e7 ff ff       	call   80132c <sbrk>
  802bf5:	83 c4 10             	add    $0x10,%esp
  802bf8:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802bfb:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802bff:	75 0a                	jne    802c0b <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c01:	b8 00 00 00 00       	mov    $0x0,%eax
  802c06:	e9 ae 00 00 00       	jmp    802cb9 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c0b:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c12:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c15:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c18:	01 d0                	add    %edx,%eax
  802c1a:	48                   	dec    %eax
  802c1b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c1e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c21:	ba 00 00 00 00       	mov    $0x0,%edx
  802c26:	f7 75 b8             	divl   -0x48(%ebp)
  802c29:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c2c:	29 d0                	sub    %edx,%eax
  802c2e:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c31:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c34:	01 d0                	add    %edx,%eax
  802c36:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c3b:	a1 40 50 80 00       	mov    0x805040,%eax
  802c40:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c46:	83 ec 0c             	sub    $0xc,%esp
  802c49:	68 8c 44 80 00       	push   $0x80448c
  802c4e:	e8 37 d7 ff ff       	call   80038a <cprintf>
  802c53:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c56:	83 ec 08             	sub    $0x8,%esp
  802c59:	ff 75 bc             	pushl  -0x44(%ebp)
  802c5c:	68 91 44 80 00       	push   $0x804491
  802c61:	e8 24 d7 ff ff       	call   80038a <cprintf>
  802c66:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c69:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c70:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c73:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c76:	01 d0                	add    %edx,%eax
  802c78:	48                   	dec    %eax
  802c79:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c7c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c7f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c84:	f7 75 b0             	divl   -0x50(%ebp)
  802c87:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c8a:	29 d0                	sub    %edx,%eax
  802c8c:	83 ec 04             	sub    $0x4,%esp
  802c8f:	6a 01                	push   $0x1
  802c91:	50                   	push   %eax
  802c92:	ff 75 bc             	pushl  -0x44(%ebp)
  802c95:	e8 51 f5 ff ff       	call   8021eb <set_block_data>
  802c9a:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c9d:	83 ec 0c             	sub    $0xc,%esp
  802ca0:	ff 75 bc             	pushl  -0x44(%ebp)
  802ca3:	e8 36 04 00 00       	call   8030de <free_block>
  802ca8:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802cab:	83 ec 0c             	sub    $0xc,%esp
  802cae:	ff 75 08             	pushl  0x8(%ebp)
  802cb1:	e8 20 fa ff ff       	call   8026d6 <alloc_block_BF>
  802cb6:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802cb9:	c9                   	leave  
  802cba:	c3                   	ret    

00802cbb <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802cbb:	55                   	push   %ebp
  802cbc:	89 e5                	mov    %esp,%ebp
  802cbe:	53                   	push   %ebx
  802cbf:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802cc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cc9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802cd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd4:	74 1e                	je     802cf4 <merging+0x39>
  802cd6:	ff 75 08             	pushl  0x8(%ebp)
  802cd9:	e8 bc f1 ff ff       	call   801e9a <get_block_size>
  802cde:	83 c4 04             	add    $0x4,%esp
  802ce1:	89 c2                	mov    %eax,%edx
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	01 d0                	add    %edx,%eax
  802ce8:	3b 45 10             	cmp    0x10(%ebp),%eax
  802ceb:	75 07                	jne    802cf4 <merging+0x39>
		prev_is_free = 1;
  802ced:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802cf4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cf8:	74 1e                	je     802d18 <merging+0x5d>
  802cfa:	ff 75 10             	pushl  0x10(%ebp)
  802cfd:	e8 98 f1 ff ff       	call   801e9a <get_block_size>
  802d02:	83 c4 04             	add    $0x4,%esp
  802d05:	89 c2                	mov    %eax,%edx
  802d07:	8b 45 10             	mov    0x10(%ebp),%eax
  802d0a:	01 d0                	add    %edx,%eax
  802d0c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d0f:	75 07                	jne    802d18 <merging+0x5d>
		next_is_free = 1;
  802d11:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1c:	0f 84 cc 00 00 00    	je     802dee <merging+0x133>
  802d22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d26:	0f 84 c2 00 00 00    	je     802dee <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d2c:	ff 75 08             	pushl  0x8(%ebp)
  802d2f:	e8 66 f1 ff ff       	call   801e9a <get_block_size>
  802d34:	83 c4 04             	add    $0x4,%esp
  802d37:	89 c3                	mov    %eax,%ebx
  802d39:	ff 75 10             	pushl  0x10(%ebp)
  802d3c:	e8 59 f1 ff ff       	call   801e9a <get_block_size>
  802d41:	83 c4 04             	add    $0x4,%esp
  802d44:	01 c3                	add    %eax,%ebx
  802d46:	ff 75 0c             	pushl  0xc(%ebp)
  802d49:	e8 4c f1 ff ff       	call   801e9a <get_block_size>
  802d4e:	83 c4 04             	add    $0x4,%esp
  802d51:	01 d8                	add    %ebx,%eax
  802d53:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d56:	6a 00                	push   $0x0
  802d58:	ff 75 ec             	pushl  -0x14(%ebp)
  802d5b:	ff 75 08             	pushl  0x8(%ebp)
  802d5e:	e8 88 f4 ff ff       	call   8021eb <set_block_data>
  802d63:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d6a:	75 17                	jne    802d83 <merging+0xc8>
  802d6c:	83 ec 04             	sub    $0x4,%esp
  802d6f:	68 c7 43 80 00       	push   $0x8043c7
  802d74:	68 7d 01 00 00       	push   $0x17d
  802d79:	68 e5 43 80 00       	push   $0x8043e5
  802d7e:	e8 ec 0b 00 00       	call   80396f <_panic>
  802d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	74 10                	je     802d9c <merging+0xe1>
  802d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d94:	8b 52 04             	mov    0x4(%edx),%edx
  802d97:	89 50 04             	mov    %edx,0x4(%eax)
  802d9a:	eb 0b                	jmp    802da7 <merging+0xec>
  802d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9f:	8b 40 04             	mov    0x4(%eax),%eax
  802da2:	a3 30 50 80 00       	mov    %eax,0x805030
  802da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802daa:	8b 40 04             	mov    0x4(%eax),%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	74 0f                	je     802dc0 <merging+0x105>
  802db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db4:	8b 40 04             	mov    0x4(%eax),%eax
  802db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dba:	8b 12                	mov    (%edx),%edx
  802dbc:	89 10                	mov    %edx,(%eax)
  802dbe:	eb 0a                	jmp    802dca <merging+0x10f>
  802dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc3:	8b 00                	mov    (%eax),%eax
  802dc5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddd:	a1 38 50 80 00       	mov    0x805038,%eax
  802de2:	48                   	dec    %eax
  802de3:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802de8:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802de9:	e9 ea 02 00 00       	jmp    8030d8 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802dee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df2:	74 3b                	je     802e2f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802df4:	83 ec 0c             	sub    $0xc,%esp
  802df7:	ff 75 08             	pushl  0x8(%ebp)
  802dfa:	e8 9b f0 ff ff       	call   801e9a <get_block_size>
  802dff:	83 c4 10             	add    $0x10,%esp
  802e02:	89 c3                	mov    %eax,%ebx
  802e04:	83 ec 0c             	sub    $0xc,%esp
  802e07:	ff 75 10             	pushl  0x10(%ebp)
  802e0a:	e8 8b f0 ff ff       	call   801e9a <get_block_size>
  802e0f:	83 c4 10             	add    $0x10,%esp
  802e12:	01 d8                	add    %ebx,%eax
  802e14:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e17:	83 ec 04             	sub    $0x4,%esp
  802e1a:	6a 00                	push   $0x0
  802e1c:	ff 75 e8             	pushl  -0x18(%ebp)
  802e1f:	ff 75 08             	pushl  0x8(%ebp)
  802e22:	e8 c4 f3 ff ff       	call   8021eb <set_block_data>
  802e27:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e2a:	e9 a9 02 00 00       	jmp    8030d8 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e33:	0f 84 2d 01 00 00    	je     802f66 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e39:	83 ec 0c             	sub    $0xc,%esp
  802e3c:	ff 75 10             	pushl  0x10(%ebp)
  802e3f:	e8 56 f0 ff ff       	call   801e9a <get_block_size>
  802e44:	83 c4 10             	add    $0x10,%esp
  802e47:	89 c3                	mov    %eax,%ebx
  802e49:	83 ec 0c             	sub    $0xc,%esp
  802e4c:	ff 75 0c             	pushl  0xc(%ebp)
  802e4f:	e8 46 f0 ff ff       	call   801e9a <get_block_size>
  802e54:	83 c4 10             	add    $0x10,%esp
  802e57:	01 d8                	add    %ebx,%eax
  802e59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e5c:	83 ec 04             	sub    $0x4,%esp
  802e5f:	6a 00                	push   $0x0
  802e61:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e64:	ff 75 10             	pushl  0x10(%ebp)
  802e67:	e8 7f f3 ff ff       	call   8021eb <set_block_data>
  802e6c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  802e72:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e79:	74 06                	je     802e81 <merging+0x1c6>
  802e7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e7f:	75 17                	jne    802e98 <merging+0x1dd>
  802e81:	83 ec 04             	sub    $0x4,%esp
  802e84:	68 a0 44 80 00       	push   $0x8044a0
  802e89:	68 8d 01 00 00       	push   $0x18d
  802e8e:	68 e5 43 80 00       	push   $0x8043e5
  802e93:	e8 d7 0a 00 00       	call   80396f <_panic>
  802e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9b:	8b 50 04             	mov    0x4(%eax),%edx
  802e9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea1:	89 50 04             	mov    %edx,0x4(%eax)
  802ea4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eaa:	89 10                	mov    %edx,(%eax)
  802eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eaf:	8b 40 04             	mov    0x4(%eax),%eax
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	74 0d                	je     802ec3 <merging+0x208>
  802eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb9:	8b 40 04             	mov    0x4(%eax),%eax
  802ebc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ebf:	89 10                	mov    %edx,(%eax)
  802ec1:	eb 08                	jmp    802ecb <merging+0x210>
  802ec3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ece:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ed1:	89 50 04             	mov    %edx,0x4(%eax)
  802ed4:	a1 38 50 80 00       	mov    0x805038,%eax
  802ed9:	40                   	inc    %eax
  802eda:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802edf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ee3:	75 17                	jne    802efc <merging+0x241>
  802ee5:	83 ec 04             	sub    $0x4,%esp
  802ee8:	68 c7 43 80 00       	push   $0x8043c7
  802eed:	68 8e 01 00 00       	push   $0x18e
  802ef2:	68 e5 43 80 00       	push   $0x8043e5
  802ef7:	e8 73 0a 00 00       	call   80396f <_panic>
  802efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eff:	8b 00                	mov    (%eax),%eax
  802f01:	85 c0                	test   %eax,%eax
  802f03:	74 10                	je     802f15 <merging+0x25a>
  802f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f08:	8b 00                	mov    (%eax),%eax
  802f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f0d:	8b 52 04             	mov    0x4(%edx),%edx
  802f10:	89 50 04             	mov    %edx,0x4(%eax)
  802f13:	eb 0b                	jmp    802f20 <merging+0x265>
  802f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f18:	8b 40 04             	mov    0x4(%eax),%eax
  802f1b:	a3 30 50 80 00       	mov    %eax,0x805030
  802f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f23:	8b 40 04             	mov    0x4(%eax),%eax
  802f26:	85 c0                	test   %eax,%eax
  802f28:	74 0f                	je     802f39 <merging+0x27e>
  802f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2d:	8b 40 04             	mov    0x4(%eax),%eax
  802f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f33:	8b 12                	mov    (%edx),%edx
  802f35:	89 10                	mov    %edx,(%eax)
  802f37:	eb 0a                	jmp    802f43 <merging+0x288>
  802f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f56:	a1 38 50 80 00       	mov    0x805038,%eax
  802f5b:	48                   	dec    %eax
  802f5c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f61:	e9 72 01 00 00       	jmp    8030d8 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f66:	8b 45 10             	mov    0x10(%ebp),%eax
  802f69:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f70:	74 79                	je     802feb <merging+0x330>
  802f72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f76:	74 73                	je     802feb <merging+0x330>
  802f78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7c:	74 06                	je     802f84 <merging+0x2c9>
  802f7e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f82:	75 17                	jne    802f9b <merging+0x2e0>
  802f84:	83 ec 04             	sub    $0x4,%esp
  802f87:	68 58 44 80 00       	push   $0x804458
  802f8c:	68 94 01 00 00       	push   $0x194
  802f91:	68 e5 43 80 00       	push   $0x8043e5
  802f96:	e8 d4 09 00 00       	call   80396f <_panic>
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 10                	mov    (%eax),%edx
  802fa0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa3:	89 10                	mov    %edx,(%eax)
  802fa5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	85 c0                	test   %eax,%eax
  802fac:	74 0b                	je     802fb9 <merging+0x2fe>
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	8b 00                	mov    (%eax),%eax
  802fb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fb6:	89 50 04             	mov    %edx,0x4(%eax)
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fbf:	89 10                	mov    %edx,(%eax)
  802fc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc7:	89 50 04             	mov    %edx,0x4(%eax)
  802fca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fcd:	8b 00                	mov    (%eax),%eax
  802fcf:	85 c0                	test   %eax,%eax
  802fd1:	75 08                	jne    802fdb <merging+0x320>
  802fd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd6:	a3 30 50 80 00       	mov    %eax,0x805030
  802fdb:	a1 38 50 80 00       	mov    0x805038,%eax
  802fe0:	40                   	inc    %eax
  802fe1:	a3 38 50 80 00       	mov    %eax,0x805038
  802fe6:	e9 ce 00 00 00       	jmp    8030b9 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802feb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fef:	74 65                	je     803056 <merging+0x39b>
  802ff1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ff5:	75 17                	jne    80300e <merging+0x353>
  802ff7:	83 ec 04             	sub    $0x4,%esp
  802ffa:	68 34 44 80 00       	push   $0x804434
  802fff:	68 95 01 00 00       	push   $0x195
  803004:	68 e5 43 80 00       	push   $0x8043e5
  803009:	e8 61 09 00 00       	call   80396f <_panic>
  80300e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803014:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803017:	89 50 04             	mov    %edx,0x4(%eax)
  80301a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301d:	8b 40 04             	mov    0x4(%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	74 0c                	je     803030 <merging+0x375>
  803024:	a1 30 50 80 00       	mov    0x805030,%eax
  803029:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80302c:	89 10                	mov    %edx,(%eax)
  80302e:	eb 08                	jmp    803038 <merging+0x37d>
  803030:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803033:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803038:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303b:	a3 30 50 80 00       	mov    %eax,0x805030
  803040:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803043:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803049:	a1 38 50 80 00       	mov    0x805038,%eax
  80304e:	40                   	inc    %eax
  80304f:	a3 38 50 80 00       	mov    %eax,0x805038
  803054:	eb 63                	jmp    8030b9 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803056:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80305a:	75 17                	jne    803073 <merging+0x3b8>
  80305c:	83 ec 04             	sub    $0x4,%esp
  80305f:	68 00 44 80 00       	push   $0x804400
  803064:	68 98 01 00 00       	push   $0x198
  803069:	68 e5 43 80 00       	push   $0x8043e5
  80306e:	e8 fc 08 00 00       	call   80396f <_panic>
  803073:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803079:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307c:	89 10                	mov    %edx,(%eax)
  80307e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803081:	8b 00                	mov    (%eax),%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 0d                	je     803094 <merging+0x3d9>
  803087:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80308c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80308f:	89 50 04             	mov    %edx,0x4(%eax)
  803092:	eb 08                	jmp    80309c <merging+0x3e1>
  803094:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803097:	a3 30 50 80 00       	mov    %eax,0x805030
  80309c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8030b3:	40                   	inc    %eax
  8030b4:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8030b9:	83 ec 0c             	sub    $0xc,%esp
  8030bc:	ff 75 10             	pushl  0x10(%ebp)
  8030bf:	e8 d6 ed ff ff       	call   801e9a <get_block_size>
  8030c4:	83 c4 10             	add    $0x10,%esp
  8030c7:	83 ec 04             	sub    $0x4,%esp
  8030ca:	6a 00                	push   $0x0
  8030cc:	50                   	push   %eax
  8030cd:	ff 75 10             	pushl  0x10(%ebp)
  8030d0:	e8 16 f1 ff ff       	call   8021eb <set_block_data>
  8030d5:	83 c4 10             	add    $0x10,%esp
	}
}
  8030d8:	90                   	nop
  8030d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030dc:	c9                   	leave  
  8030dd:	c3                   	ret    

008030de <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030de:	55                   	push   %ebp
  8030df:	89 e5                	mov    %esp,%ebp
  8030e1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030e4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030e9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030ec:	a1 30 50 80 00       	mov    0x805030,%eax
  8030f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f4:	73 1b                	jae    803111 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030f6:	a1 30 50 80 00       	mov    0x805030,%eax
  8030fb:	83 ec 04             	sub    $0x4,%esp
  8030fe:	ff 75 08             	pushl  0x8(%ebp)
  803101:	6a 00                	push   $0x0
  803103:	50                   	push   %eax
  803104:	e8 b2 fb ff ff       	call   802cbb <merging>
  803109:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80310c:	e9 8b 00 00 00       	jmp    80319c <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803111:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803116:	3b 45 08             	cmp    0x8(%ebp),%eax
  803119:	76 18                	jbe    803133 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80311b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803120:	83 ec 04             	sub    $0x4,%esp
  803123:	ff 75 08             	pushl  0x8(%ebp)
  803126:	50                   	push   %eax
  803127:	6a 00                	push   $0x0
  803129:	e8 8d fb ff ff       	call   802cbb <merging>
  80312e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803131:	eb 69                	jmp    80319c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803133:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803138:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80313b:	eb 39                	jmp    803176 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	3b 45 08             	cmp    0x8(%ebp),%eax
  803143:	73 29                	jae    80316e <free_block+0x90>
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80314d:	76 1f                	jbe    80316e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 00                	mov    (%eax),%eax
  803154:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803157:	83 ec 04             	sub    $0x4,%esp
  80315a:	ff 75 08             	pushl  0x8(%ebp)
  80315d:	ff 75 f0             	pushl  -0x10(%ebp)
  803160:	ff 75 f4             	pushl  -0xc(%ebp)
  803163:	e8 53 fb ff ff       	call   802cbb <merging>
  803168:	83 c4 10             	add    $0x10,%esp
			break;
  80316b:	90                   	nop
		}
	}
}
  80316c:	eb 2e                	jmp    80319c <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80316e:	a1 34 50 80 00       	mov    0x805034,%eax
  803173:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803176:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317a:	74 07                	je     803183 <free_block+0xa5>
  80317c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317f:	8b 00                	mov    (%eax),%eax
  803181:	eb 05                	jmp    803188 <free_block+0xaa>
  803183:	b8 00 00 00 00       	mov    $0x0,%eax
  803188:	a3 34 50 80 00       	mov    %eax,0x805034
  80318d:	a1 34 50 80 00       	mov    0x805034,%eax
  803192:	85 c0                	test   %eax,%eax
  803194:	75 a7                	jne    80313d <free_block+0x5f>
  803196:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80319a:	75 a1                	jne    80313d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80319c:	90                   	nop
  80319d:	c9                   	leave  
  80319e:	c3                   	ret    

0080319f <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  80319f:	55                   	push   %ebp
  8031a0:	89 e5                	mov    %esp,%ebp
  8031a2:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8031a5:	ff 75 08             	pushl  0x8(%ebp)
  8031a8:	e8 ed ec ff ff       	call   801e9a <get_block_size>
  8031ad:	83 c4 04             	add    $0x4,%esp
  8031b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8031b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8031ba:	eb 17                	jmp    8031d3 <copy_data+0x34>
  8031bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c2:	01 c2                	add    %eax,%edx
  8031c4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	01 c8                	add    %ecx,%eax
  8031cc:	8a 00                	mov    (%eax),%al
  8031ce:	88 02                	mov    %al,(%edx)
  8031d0:	ff 45 fc             	incl   -0x4(%ebp)
  8031d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031d9:	72 e1                	jb     8031bc <copy_data+0x1d>
}
  8031db:	90                   	nop
  8031dc:	c9                   	leave  
  8031dd:	c3                   	ret    

008031de <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031de:	55                   	push   %ebp
  8031df:	89 e5                	mov    %esp,%ebp
  8031e1:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e8:	75 23                	jne    80320d <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8031ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031ee:	74 13                	je     803203 <realloc_block_FF+0x25>
  8031f0:	83 ec 0c             	sub    $0xc,%esp
  8031f3:	ff 75 0c             	pushl  0xc(%ebp)
  8031f6:	e8 1f f0 ff ff       	call   80221a <alloc_block_FF>
  8031fb:	83 c4 10             	add    $0x10,%esp
  8031fe:	e9 f4 06 00 00       	jmp    8038f7 <realloc_block_FF+0x719>
		return NULL;
  803203:	b8 00 00 00 00       	mov    $0x0,%eax
  803208:	e9 ea 06 00 00       	jmp    8038f7 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80320d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803211:	75 18                	jne    80322b <realloc_block_FF+0x4d>
	{
		free_block(va);
  803213:	83 ec 0c             	sub    $0xc,%esp
  803216:	ff 75 08             	pushl  0x8(%ebp)
  803219:	e8 c0 fe ff ff       	call   8030de <free_block>
  80321e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803221:	b8 00 00 00 00       	mov    $0x0,%eax
  803226:	e9 cc 06 00 00       	jmp    8038f7 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80322b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80322f:	77 07                	ja     803238 <realloc_block_FF+0x5a>
  803231:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80323b:	83 e0 01             	and    $0x1,%eax
  80323e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803241:	8b 45 0c             	mov    0xc(%ebp),%eax
  803244:	83 c0 08             	add    $0x8,%eax
  803247:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80324a:	83 ec 0c             	sub    $0xc,%esp
  80324d:	ff 75 08             	pushl  0x8(%ebp)
  803250:	e8 45 ec ff ff       	call   801e9a <get_block_size>
  803255:	83 c4 10             	add    $0x10,%esp
  803258:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80325b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325e:	83 e8 08             	sub    $0x8,%eax
  803261:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	83 e8 04             	sub    $0x4,%eax
  80326a:	8b 00                	mov    (%eax),%eax
  80326c:	83 e0 fe             	and    $0xfffffffe,%eax
  80326f:	89 c2                	mov    %eax,%edx
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	01 d0                	add    %edx,%eax
  803276:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803279:	83 ec 0c             	sub    $0xc,%esp
  80327c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80327f:	e8 16 ec ff ff       	call   801e9a <get_block_size>
  803284:	83 c4 10             	add    $0x10,%esp
  803287:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80328a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80328d:	83 e8 08             	sub    $0x8,%eax
  803290:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803293:	8b 45 0c             	mov    0xc(%ebp),%eax
  803296:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803299:	75 08                	jne    8032a3 <realloc_block_FF+0xc5>
	{
		 return va;
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	e9 54 06 00 00       	jmp    8038f7 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8032a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032a9:	0f 83 e5 03 00 00    	jae    803694 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8032af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b2:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8032b8:	83 ec 0c             	sub    $0xc,%esp
  8032bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032be:	e8 f0 eb ff ff       	call   801eb3 <is_free_block>
  8032c3:	83 c4 10             	add    $0x10,%esp
  8032c6:	84 c0                	test   %al,%al
  8032c8:	0f 84 3b 01 00 00    	je     803409 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8032ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032d4:	01 d0                	add    %edx,%eax
  8032d6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8032d9:	83 ec 04             	sub    $0x4,%esp
  8032dc:	6a 01                	push   $0x1
  8032de:	ff 75 f0             	pushl  -0x10(%ebp)
  8032e1:	ff 75 08             	pushl  0x8(%ebp)
  8032e4:	e8 02 ef ff ff       	call   8021eb <set_block_data>
  8032e9:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ef:	83 e8 04             	sub    $0x4,%eax
  8032f2:	8b 00                	mov    (%eax),%eax
  8032f4:	83 e0 fe             	and    $0xfffffffe,%eax
  8032f7:	89 c2                	mov    %eax,%edx
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	01 d0                	add    %edx,%eax
  8032fe:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803301:	83 ec 04             	sub    $0x4,%esp
  803304:	6a 00                	push   $0x0
  803306:	ff 75 cc             	pushl  -0x34(%ebp)
  803309:	ff 75 c8             	pushl  -0x38(%ebp)
  80330c:	e8 da ee ff ff       	call   8021eb <set_block_data>
  803311:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803314:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803318:	74 06                	je     803320 <realloc_block_FF+0x142>
  80331a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80331e:	75 17                	jne    803337 <realloc_block_FF+0x159>
  803320:	83 ec 04             	sub    $0x4,%esp
  803323:	68 58 44 80 00       	push   $0x804458
  803328:	68 f6 01 00 00       	push   $0x1f6
  80332d:	68 e5 43 80 00       	push   $0x8043e5
  803332:	e8 38 06 00 00       	call   80396f <_panic>
  803337:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333a:	8b 10                	mov    (%eax),%edx
  80333c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80333f:	89 10                	mov    %edx,(%eax)
  803341:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	85 c0                	test   %eax,%eax
  803348:	74 0b                	je     803355 <realloc_block_FF+0x177>
  80334a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334d:	8b 00                	mov    (%eax),%eax
  80334f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803352:	89 50 04             	mov    %edx,0x4(%eax)
  803355:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803358:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80335b:	89 10                	mov    %edx,(%eax)
  80335d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803360:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803363:	89 50 04             	mov    %edx,0x4(%eax)
  803366:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803369:	8b 00                	mov    (%eax),%eax
  80336b:	85 c0                	test   %eax,%eax
  80336d:	75 08                	jne    803377 <realloc_block_FF+0x199>
  80336f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803372:	a3 30 50 80 00       	mov    %eax,0x805030
  803377:	a1 38 50 80 00       	mov    0x805038,%eax
  80337c:	40                   	inc    %eax
  80337d:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803382:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803386:	75 17                	jne    80339f <realloc_block_FF+0x1c1>
  803388:	83 ec 04             	sub    $0x4,%esp
  80338b:	68 c7 43 80 00       	push   $0x8043c7
  803390:	68 f7 01 00 00       	push   $0x1f7
  803395:	68 e5 43 80 00       	push   $0x8043e5
  80339a:	e8 d0 05 00 00       	call   80396f <_panic>
  80339f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	74 10                	je     8033b8 <realloc_block_FF+0x1da>
  8033a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ab:	8b 00                	mov    (%eax),%eax
  8033ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033b0:	8b 52 04             	mov    0x4(%edx),%edx
  8033b3:	89 50 04             	mov    %edx,0x4(%eax)
  8033b6:	eb 0b                	jmp    8033c3 <realloc_block_FF+0x1e5>
  8033b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bb:	8b 40 04             	mov    0x4(%eax),%eax
  8033be:	a3 30 50 80 00       	mov    %eax,0x805030
  8033c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c6:	8b 40 04             	mov    0x4(%eax),%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	74 0f                	je     8033dc <realloc_block_FF+0x1fe>
  8033cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d0:	8b 40 04             	mov    0x4(%eax),%eax
  8033d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033d6:	8b 12                	mov    (%edx),%edx
  8033d8:	89 10                	mov    %edx,(%eax)
  8033da:	eb 0a                	jmp    8033e6 <realloc_block_FF+0x208>
  8033dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033df:	8b 00                	mov    (%eax),%eax
  8033e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8033fe:	48                   	dec    %eax
  8033ff:	a3 38 50 80 00       	mov    %eax,0x805038
  803404:	e9 83 02 00 00       	jmp    80368c <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803409:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80340d:	0f 86 69 02 00 00    	jbe    80367c <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803413:	83 ec 04             	sub    $0x4,%esp
  803416:	6a 01                	push   $0x1
  803418:	ff 75 f0             	pushl  -0x10(%ebp)
  80341b:	ff 75 08             	pushl  0x8(%ebp)
  80341e:	e8 c8 ed ff ff       	call   8021eb <set_block_data>
  803423:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	83 e8 04             	sub    $0x4,%eax
  80342c:	8b 00                	mov    (%eax),%eax
  80342e:	83 e0 fe             	and    $0xfffffffe,%eax
  803431:	89 c2                	mov    %eax,%edx
  803433:	8b 45 08             	mov    0x8(%ebp),%eax
  803436:	01 d0                	add    %edx,%eax
  803438:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80343b:	a1 38 50 80 00       	mov    0x805038,%eax
  803440:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803443:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803447:	75 68                	jne    8034b1 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803449:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80344d:	75 17                	jne    803466 <realloc_block_FF+0x288>
  80344f:	83 ec 04             	sub    $0x4,%esp
  803452:	68 00 44 80 00       	push   $0x804400
  803457:	68 06 02 00 00       	push   $0x206
  80345c:	68 e5 43 80 00       	push   $0x8043e5
  803461:	e8 09 05 00 00       	call   80396f <_panic>
  803466:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80346c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346f:	89 10                	mov    %edx,(%eax)
  803471:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803474:	8b 00                	mov    (%eax),%eax
  803476:	85 c0                	test   %eax,%eax
  803478:	74 0d                	je     803487 <realloc_block_FF+0x2a9>
  80347a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80347f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803482:	89 50 04             	mov    %edx,0x4(%eax)
  803485:	eb 08                	jmp    80348f <realloc_block_FF+0x2b1>
  803487:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348a:	a3 30 50 80 00       	mov    %eax,0x805030
  80348f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803492:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803497:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8034a6:	40                   	inc    %eax
  8034a7:	a3 38 50 80 00       	mov    %eax,0x805038
  8034ac:	e9 b0 01 00 00       	jmp    803661 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8034b1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034b6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034b9:	76 68                	jbe    803523 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034bf:	75 17                	jne    8034d8 <realloc_block_FF+0x2fa>
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	68 00 44 80 00       	push   $0x804400
  8034c9:	68 0b 02 00 00       	push   $0x20b
  8034ce:	68 e5 43 80 00       	push   $0x8043e5
  8034d3:	e8 97 04 00 00       	call   80396f <_panic>
  8034d8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e1:	89 10                	mov    %edx,(%eax)
  8034e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e6:	8b 00                	mov    (%eax),%eax
  8034e8:	85 c0                	test   %eax,%eax
  8034ea:	74 0d                	je     8034f9 <realloc_block_FF+0x31b>
  8034ec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034f1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034f4:	89 50 04             	mov    %edx,0x4(%eax)
  8034f7:	eb 08                	jmp    803501 <realloc_block_FF+0x323>
  8034f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803501:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803504:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803509:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803513:	a1 38 50 80 00       	mov    0x805038,%eax
  803518:	40                   	inc    %eax
  803519:	a3 38 50 80 00       	mov    %eax,0x805038
  80351e:	e9 3e 01 00 00       	jmp    803661 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803523:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803528:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80352b:	73 68                	jae    803595 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80352d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803531:	75 17                	jne    80354a <realloc_block_FF+0x36c>
  803533:	83 ec 04             	sub    $0x4,%esp
  803536:	68 34 44 80 00       	push   $0x804434
  80353b:	68 10 02 00 00       	push   $0x210
  803540:	68 e5 43 80 00       	push   $0x8043e5
  803545:	e8 25 04 00 00       	call   80396f <_panic>
  80354a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803550:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803553:	89 50 04             	mov    %edx,0x4(%eax)
  803556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803559:	8b 40 04             	mov    0x4(%eax),%eax
  80355c:	85 c0                	test   %eax,%eax
  80355e:	74 0c                	je     80356c <realloc_block_FF+0x38e>
  803560:	a1 30 50 80 00       	mov    0x805030,%eax
  803565:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803568:	89 10                	mov    %edx,(%eax)
  80356a:	eb 08                	jmp    803574 <realloc_block_FF+0x396>
  80356c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803574:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803577:	a3 30 50 80 00       	mov    %eax,0x805030
  80357c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80357f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803585:	a1 38 50 80 00       	mov    0x805038,%eax
  80358a:	40                   	inc    %eax
  80358b:	a3 38 50 80 00       	mov    %eax,0x805038
  803590:	e9 cc 00 00 00       	jmp    803661 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803595:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80359c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035a4:	e9 8a 00 00 00       	jmp    803633 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ac:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035af:	73 7a                	jae    80362b <realloc_block_FF+0x44d>
  8035b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b4:	8b 00                	mov    (%eax),%eax
  8035b6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035b9:	73 70                	jae    80362b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8035bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035bf:	74 06                	je     8035c7 <realloc_block_FF+0x3e9>
  8035c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035c5:	75 17                	jne    8035de <realloc_block_FF+0x400>
  8035c7:	83 ec 04             	sub    $0x4,%esp
  8035ca:	68 58 44 80 00       	push   $0x804458
  8035cf:	68 1a 02 00 00       	push   $0x21a
  8035d4:	68 e5 43 80 00       	push   $0x8043e5
  8035d9:	e8 91 03 00 00       	call   80396f <_panic>
  8035de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e1:	8b 10                	mov    (%eax),%edx
  8035e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e6:	89 10                	mov    %edx,(%eax)
  8035e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035eb:	8b 00                	mov    (%eax),%eax
  8035ed:	85 c0                	test   %eax,%eax
  8035ef:	74 0b                	je     8035fc <realloc_block_FF+0x41e>
  8035f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f4:	8b 00                	mov    (%eax),%eax
  8035f6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035f9:	89 50 04             	mov    %edx,0x4(%eax)
  8035fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803602:	89 10                	mov    %edx,(%eax)
  803604:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803607:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80360a:	89 50 04             	mov    %edx,0x4(%eax)
  80360d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803610:	8b 00                	mov    (%eax),%eax
  803612:	85 c0                	test   %eax,%eax
  803614:	75 08                	jne    80361e <realloc_block_FF+0x440>
  803616:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803619:	a3 30 50 80 00       	mov    %eax,0x805030
  80361e:	a1 38 50 80 00       	mov    0x805038,%eax
  803623:	40                   	inc    %eax
  803624:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803629:	eb 36                	jmp    803661 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80362b:	a1 34 50 80 00       	mov    0x805034,%eax
  803630:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803633:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803637:	74 07                	je     803640 <realloc_block_FF+0x462>
  803639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363c:	8b 00                	mov    (%eax),%eax
  80363e:	eb 05                	jmp    803645 <realloc_block_FF+0x467>
  803640:	b8 00 00 00 00       	mov    $0x0,%eax
  803645:	a3 34 50 80 00       	mov    %eax,0x805034
  80364a:	a1 34 50 80 00       	mov    0x805034,%eax
  80364f:	85 c0                	test   %eax,%eax
  803651:	0f 85 52 ff ff ff    	jne    8035a9 <realloc_block_FF+0x3cb>
  803657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365b:	0f 85 48 ff ff ff    	jne    8035a9 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803661:	83 ec 04             	sub    $0x4,%esp
  803664:	6a 00                	push   $0x0
  803666:	ff 75 d8             	pushl  -0x28(%ebp)
  803669:	ff 75 d4             	pushl  -0x2c(%ebp)
  80366c:	e8 7a eb ff ff       	call   8021eb <set_block_data>
  803671:	83 c4 10             	add    $0x10,%esp
				return va;
  803674:	8b 45 08             	mov    0x8(%ebp),%eax
  803677:	e9 7b 02 00 00       	jmp    8038f7 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80367c:	83 ec 0c             	sub    $0xc,%esp
  80367f:	68 d5 44 80 00       	push   $0x8044d5
  803684:	e8 01 cd ff ff       	call   80038a <cprintf>
  803689:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80368c:	8b 45 08             	mov    0x8(%ebp),%eax
  80368f:	e9 63 02 00 00       	jmp    8038f7 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803694:	8b 45 0c             	mov    0xc(%ebp),%eax
  803697:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80369a:	0f 86 4d 02 00 00    	jbe    8038ed <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8036a0:	83 ec 0c             	sub    $0xc,%esp
  8036a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036a6:	e8 08 e8 ff ff       	call   801eb3 <is_free_block>
  8036ab:	83 c4 10             	add    $0x10,%esp
  8036ae:	84 c0                	test   %al,%al
  8036b0:	0f 84 37 02 00 00    	je     8038ed <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8036b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8036bc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8036bf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036c2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036c5:	76 38                	jbe    8036ff <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8036c7:	83 ec 0c             	sub    $0xc,%esp
  8036ca:	ff 75 08             	pushl  0x8(%ebp)
  8036cd:	e8 0c fa ff ff       	call   8030de <free_block>
  8036d2:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8036d5:	83 ec 0c             	sub    $0xc,%esp
  8036d8:	ff 75 0c             	pushl  0xc(%ebp)
  8036db:	e8 3a eb ff ff       	call   80221a <alloc_block_FF>
  8036e0:	83 c4 10             	add    $0x10,%esp
  8036e3:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8036e6:	83 ec 08             	sub    $0x8,%esp
  8036e9:	ff 75 c0             	pushl  -0x40(%ebp)
  8036ec:	ff 75 08             	pushl  0x8(%ebp)
  8036ef:	e8 ab fa ff ff       	call   80319f <copy_data>
  8036f4:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036f7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036fa:	e9 f8 01 00 00       	jmp    8038f7 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803702:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803705:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803708:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80370c:	0f 87 a0 00 00 00    	ja     8037b2 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803712:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803716:	75 17                	jne    80372f <realloc_block_FF+0x551>
  803718:	83 ec 04             	sub    $0x4,%esp
  80371b:	68 c7 43 80 00       	push   $0x8043c7
  803720:	68 38 02 00 00       	push   $0x238
  803725:	68 e5 43 80 00       	push   $0x8043e5
  80372a:	e8 40 02 00 00       	call   80396f <_panic>
  80372f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803732:	8b 00                	mov    (%eax),%eax
  803734:	85 c0                	test   %eax,%eax
  803736:	74 10                	je     803748 <realloc_block_FF+0x56a>
  803738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373b:	8b 00                	mov    (%eax),%eax
  80373d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803740:	8b 52 04             	mov    0x4(%edx),%edx
  803743:	89 50 04             	mov    %edx,0x4(%eax)
  803746:	eb 0b                	jmp    803753 <realloc_block_FF+0x575>
  803748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374b:	8b 40 04             	mov    0x4(%eax),%eax
  80374e:	a3 30 50 80 00       	mov    %eax,0x805030
  803753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803756:	8b 40 04             	mov    0x4(%eax),%eax
  803759:	85 c0                	test   %eax,%eax
  80375b:	74 0f                	je     80376c <realloc_block_FF+0x58e>
  80375d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803760:	8b 40 04             	mov    0x4(%eax),%eax
  803763:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803766:	8b 12                	mov    (%edx),%edx
  803768:	89 10                	mov    %edx,(%eax)
  80376a:	eb 0a                	jmp    803776 <realloc_block_FF+0x598>
  80376c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376f:	8b 00                	mov    (%eax),%eax
  803771:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803782:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803789:	a1 38 50 80 00       	mov    0x805038,%eax
  80378e:	48                   	dec    %eax
  80378f:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803794:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80379a:	01 d0                	add    %edx,%eax
  80379c:	83 ec 04             	sub    $0x4,%esp
  80379f:	6a 01                	push   $0x1
  8037a1:	50                   	push   %eax
  8037a2:	ff 75 08             	pushl  0x8(%ebp)
  8037a5:	e8 41 ea ff ff       	call   8021eb <set_block_data>
  8037aa:	83 c4 10             	add    $0x10,%esp
  8037ad:	e9 36 01 00 00       	jmp    8038e8 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8037b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037b8:	01 d0                	add    %edx,%eax
  8037ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8037bd:	83 ec 04             	sub    $0x4,%esp
  8037c0:	6a 01                	push   $0x1
  8037c2:	ff 75 f0             	pushl  -0x10(%ebp)
  8037c5:	ff 75 08             	pushl  0x8(%ebp)
  8037c8:	e8 1e ea ff ff       	call   8021eb <set_block_data>
  8037cd:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d3:	83 e8 04             	sub    $0x4,%eax
  8037d6:	8b 00                	mov    (%eax),%eax
  8037d8:	83 e0 fe             	and    $0xfffffffe,%eax
  8037db:	89 c2                	mov    %eax,%edx
  8037dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e0:	01 d0                	add    %edx,%eax
  8037e2:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037e9:	74 06                	je     8037f1 <realloc_block_FF+0x613>
  8037eb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037ef:	75 17                	jne    803808 <realloc_block_FF+0x62a>
  8037f1:	83 ec 04             	sub    $0x4,%esp
  8037f4:	68 58 44 80 00       	push   $0x804458
  8037f9:	68 44 02 00 00       	push   $0x244
  8037fe:	68 e5 43 80 00       	push   $0x8043e5
  803803:	e8 67 01 00 00       	call   80396f <_panic>
  803808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380b:	8b 10                	mov    (%eax),%edx
  80380d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803810:	89 10                	mov    %edx,(%eax)
  803812:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803815:	8b 00                	mov    (%eax),%eax
  803817:	85 c0                	test   %eax,%eax
  803819:	74 0b                	je     803826 <realloc_block_FF+0x648>
  80381b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381e:	8b 00                	mov    (%eax),%eax
  803820:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803823:	89 50 04             	mov    %edx,0x4(%eax)
  803826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803829:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80382c:	89 10                	mov    %edx,(%eax)
  80382e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803831:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803834:	89 50 04             	mov    %edx,0x4(%eax)
  803837:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80383a:	8b 00                	mov    (%eax),%eax
  80383c:	85 c0                	test   %eax,%eax
  80383e:	75 08                	jne    803848 <realloc_block_FF+0x66a>
  803840:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803843:	a3 30 50 80 00       	mov    %eax,0x805030
  803848:	a1 38 50 80 00       	mov    0x805038,%eax
  80384d:	40                   	inc    %eax
  80384e:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803853:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803857:	75 17                	jne    803870 <realloc_block_FF+0x692>
  803859:	83 ec 04             	sub    $0x4,%esp
  80385c:	68 c7 43 80 00       	push   $0x8043c7
  803861:	68 45 02 00 00       	push   $0x245
  803866:	68 e5 43 80 00       	push   $0x8043e5
  80386b:	e8 ff 00 00 00       	call   80396f <_panic>
  803870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803873:	8b 00                	mov    (%eax),%eax
  803875:	85 c0                	test   %eax,%eax
  803877:	74 10                	je     803889 <realloc_block_FF+0x6ab>
  803879:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387c:	8b 00                	mov    (%eax),%eax
  80387e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803881:	8b 52 04             	mov    0x4(%edx),%edx
  803884:	89 50 04             	mov    %edx,0x4(%eax)
  803887:	eb 0b                	jmp    803894 <realloc_block_FF+0x6b6>
  803889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388c:	8b 40 04             	mov    0x4(%eax),%eax
  80388f:	a3 30 50 80 00       	mov    %eax,0x805030
  803894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803897:	8b 40 04             	mov    0x4(%eax),%eax
  80389a:	85 c0                	test   %eax,%eax
  80389c:	74 0f                	je     8038ad <realloc_block_FF+0x6cf>
  80389e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a1:	8b 40 04             	mov    0x4(%eax),%eax
  8038a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038a7:	8b 12                	mov    (%edx),%edx
  8038a9:	89 10                	mov    %edx,(%eax)
  8038ab:	eb 0a                	jmp    8038b7 <realloc_block_FF+0x6d9>
  8038ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b0:	8b 00                	mov    (%eax),%eax
  8038b2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8038cf:	48                   	dec    %eax
  8038d0:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8038d5:	83 ec 04             	sub    $0x4,%esp
  8038d8:	6a 00                	push   $0x0
  8038da:	ff 75 bc             	pushl  -0x44(%ebp)
  8038dd:	ff 75 b8             	pushl  -0x48(%ebp)
  8038e0:	e8 06 e9 ff ff       	call   8021eb <set_block_data>
  8038e5:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8038e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038eb:	eb 0a                	jmp    8038f7 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8038ed:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038f7:	c9                   	leave  
  8038f8:	c3                   	ret    

008038f9 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038f9:	55                   	push   %ebp
  8038fa:	89 e5                	mov    %esp,%ebp
  8038fc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038ff:	83 ec 04             	sub    $0x4,%esp
  803902:	68 dc 44 80 00       	push   $0x8044dc
  803907:	68 58 02 00 00       	push   $0x258
  80390c:	68 e5 43 80 00       	push   $0x8043e5
  803911:	e8 59 00 00 00       	call   80396f <_panic>

00803916 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803916:	55                   	push   %ebp
  803917:	89 e5                	mov    %esp,%ebp
  803919:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80391c:	83 ec 04             	sub    $0x4,%esp
  80391f:	68 04 45 80 00       	push   $0x804504
  803924:	68 61 02 00 00       	push   $0x261
  803929:	68 e5 43 80 00       	push   $0x8043e5
  80392e:	e8 3c 00 00 00       	call   80396f <_panic>

00803933 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  803933:	55                   	push   %ebp
  803934:	89 e5                	mov    %esp,%ebp
  803936:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  803939:	8b 45 08             	mov    0x8(%ebp),%eax
  80393c:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80393f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803943:	83 ec 0c             	sub    $0xc,%esp
  803946:	50                   	push   %eax
  803947:	e8 dd e0 ff ff       	call   801a29 <sys_cputc>
  80394c:	83 c4 10             	add    $0x10,%esp
}
  80394f:	90                   	nop
  803950:	c9                   	leave  
  803951:	c3                   	ret    

00803952 <getchar>:


int
getchar(void)
{
  803952:	55                   	push   %ebp
  803953:	89 e5                	mov    %esp,%ebp
  803955:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803958:	e8 68 df ff ff       	call   8018c5 <sys_cgetc>
  80395d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  803960:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803963:	c9                   	leave  
  803964:	c3                   	ret    

00803965 <iscons>:

int iscons(int fdnum)
{
  803965:	55                   	push   %ebp
  803966:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803968:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80396d:	5d                   	pop    %ebp
  80396e:	c3                   	ret    

0080396f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80396f:	55                   	push   %ebp
  803970:	89 e5                	mov    %esp,%ebp
  803972:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803975:	8d 45 10             	lea    0x10(%ebp),%eax
  803978:	83 c0 04             	add    $0x4,%eax
  80397b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80397e:	a1 60 50 98 00       	mov    0x985060,%eax
  803983:	85 c0                	test   %eax,%eax
  803985:	74 16                	je     80399d <_panic+0x2e>
		cprintf("%s: ", argv0);
  803987:	a1 60 50 98 00       	mov    0x985060,%eax
  80398c:	83 ec 08             	sub    $0x8,%esp
  80398f:	50                   	push   %eax
  803990:	68 2c 45 80 00       	push   $0x80452c
  803995:	e8 f0 c9 ff ff       	call   80038a <cprintf>
  80399a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80399d:	a1 00 50 80 00       	mov    0x805000,%eax
  8039a2:	ff 75 0c             	pushl  0xc(%ebp)
  8039a5:	ff 75 08             	pushl  0x8(%ebp)
  8039a8:	50                   	push   %eax
  8039a9:	68 31 45 80 00       	push   $0x804531
  8039ae:	e8 d7 c9 ff ff       	call   80038a <cprintf>
  8039b3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8039b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8039b9:	83 ec 08             	sub    $0x8,%esp
  8039bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8039bf:	50                   	push   %eax
  8039c0:	e8 5a c9 ff ff       	call   80031f <vcprintf>
  8039c5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8039c8:	83 ec 08             	sub    $0x8,%esp
  8039cb:	6a 00                	push   $0x0
  8039cd:	68 4d 45 80 00       	push   $0x80454d
  8039d2:	e8 48 c9 ff ff       	call   80031f <vcprintf>
  8039d7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8039da:	e8 c9 c8 ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  8039df:	eb fe                	jmp    8039df <_panic+0x70>

008039e1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8039e1:	55                   	push   %ebp
  8039e2:	89 e5                	mov    %esp,%ebp
  8039e4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8039e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8039ec:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039f5:	39 c2                	cmp    %eax,%edx
  8039f7:	74 14                	je     803a0d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8039f9:	83 ec 04             	sub    $0x4,%esp
  8039fc:	68 50 45 80 00       	push   $0x804550
  803a01:	6a 26                	push   $0x26
  803a03:	68 9c 45 80 00       	push   $0x80459c
  803a08:	e8 62 ff ff ff       	call   80396f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803a14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a1b:	e9 c5 00 00 00       	jmp    803ae5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2d:	01 d0                	add    %edx,%eax
  803a2f:	8b 00                	mov    (%eax),%eax
  803a31:	85 c0                	test   %eax,%eax
  803a33:	75 08                	jne    803a3d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a35:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a38:	e9 a5 00 00 00       	jmp    803ae2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a3d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a44:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a4b:	eb 69                	jmp    803ab6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a4d:	a1 20 50 80 00       	mov    0x805020,%eax
  803a52:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a58:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a5b:	89 d0                	mov    %edx,%eax
  803a5d:	01 c0                	add    %eax,%eax
  803a5f:	01 d0                	add    %edx,%eax
  803a61:	c1 e0 03             	shl    $0x3,%eax
  803a64:	01 c8                	add    %ecx,%eax
  803a66:	8a 40 04             	mov    0x4(%eax),%al
  803a69:	84 c0                	test   %al,%al
  803a6b:	75 46                	jne    803ab3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a6d:	a1 20 50 80 00       	mov    0x805020,%eax
  803a72:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a7b:	89 d0                	mov    %edx,%eax
  803a7d:	01 c0                	add    %eax,%eax
  803a7f:	01 d0                	add    %edx,%eax
  803a81:	c1 e0 03             	shl    $0x3,%eax
  803a84:	01 c8                	add    %ecx,%eax
  803a86:	8b 00                	mov    (%eax),%eax
  803a88:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a8e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a93:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a98:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa2:	01 c8                	add    %ecx,%eax
  803aa4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803aa6:	39 c2                	cmp    %eax,%edx
  803aa8:	75 09                	jne    803ab3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803aaa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803ab1:	eb 15                	jmp    803ac8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ab3:	ff 45 e8             	incl   -0x18(%ebp)
  803ab6:	a1 20 50 80 00       	mov    0x805020,%eax
  803abb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803ac1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac4:	39 c2                	cmp    %eax,%edx
  803ac6:	77 85                	ja     803a4d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803ac8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803acc:	75 14                	jne    803ae2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803ace:	83 ec 04             	sub    $0x4,%esp
  803ad1:	68 a8 45 80 00       	push   $0x8045a8
  803ad6:	6a 3a                	push   $0x3a
  803ad8:	68 9c 45 80 00       	push   $0x80459c
  803add:	e8 8d fe ff ff       	call   80396f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803ae2:	ff 45 f0             	incl   -0x10(%ebp)
  803ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803aeb:	0f 8c 2f ff ff ff    	jl     803a20 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803af1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803af8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803aff:	eb 26                	jmp    803b27 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b01:	a1 20 50 80 00       	mov    0x805020,%eax
  803b06:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b0f:	89 d0                	mov    %edx,%eax
  803b11:	01 c0                	add    %eax,%eax
  803b13:	01 d0                	add    %edx,%eax
  803b15:	c1 e0 03             	shl    $0x3,%eax
  803b18:	01 c8                	add    %ecx,%eax
  803b1a:	8a 40 04             	mov    0x4(%eax),%al
  803b1d:	3c 01                	cmp    $0x1,%al
  803b1f:	75 03                	jne    803b24 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b21:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b24:	ff 45 e0             	incl   -0x20(%ebp)
  803b27:	a1 20 50 80 00       	mov    0x805020,%eax
  803b2c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b35:	39 c2                	cmp    %eax,%edx
  803b37:	77 c8                	ja     803b01 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b3f:	74 14                	je     803b55 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b41:	83 ec 04             	sub    $0x4,%esp
  803b44:	68 fc 45 80 00       	push   $0x8045fc
  803b49:	6a 44                	push   $0x44
  803b4b:	68 9c 45 80 00       	push   $0x80459c
  803b50:	e8 1a fe ff ff       	call   80396f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b55:	90                   	nop
  803b56:	c9                   	leave  
  803b57:	c3                   	ret    

00803b58 <__udivdi3>:
  803b58:	55                   	push   %ebp
  803b59:	57                   	push   %edi
  803b5a:	56                   	push   %esi
  803b5b:	53                   	push   %ebx
  803b5c:	83 ec 1c             	sub    $0x1c,%esp
  803b5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b6f:	89 ca                	mov    %ecx,%edx
  803b71:	89 f8                	mov    %edi,%eax
  803b73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b77:	85 f6                	test   %esi,%esi
  803b79:	75 2d                	jne    803ba8 <__udivdi3+0x50>
  803b7b:	39 cf                	cmp    %ecx,%edi
  803b7d:	77 65                	ja     803be4 <__udivdi3+0x8c>
  803b7f:	89 fd                	mov    %edi,%ebp
  803b81:	85 ff                	test   %edi,%edi
  803b83:	75 0b                	jne    803b90 <__udivdi3+0x38>
  803b85:	b8 01 00 00 00       	mov    $0x1,%eax
  803b8a:	31 d2                	xor    %edx,%edx
  803b8c:	f7 f7                	div    %edi
  803b8e:	89 c5                	mov    %eax,%ebp
  803b90:	31 d2                	xor    %edx,%edx
  803b92:	89 c8                	mov    %ecx,%eax
  803b94:	f7 f5                	div    %ebp
  803b96:	89 c1                	mov    %eax,%ecx
  803b98:	89 d8                	mov    %ebx,%eax
  803b9a:	f7 f5                	div    %ebp
  803b9c:	89 cf                	mov    %ecx,%edi
  803b9e:	89 fa                	mov    %edi,%edx
  803ba0:	83 c4 1c             	add    $0x1c,%esp
  803ba3:	5b                   	pop    %ebx
  803ba4:	5e                   	pop    %esi
  803ba5:	5f                   	pop    %edi
  803ba6:	5d                   	pop    %ebp
  803ba7:	c3                   	ret    
  803ba8:	39 ce                	cmp    %ecx,%esi
  803baa:	77 28                	ja     803bd4 <__udivdi3+0x7c>
  803bac:	0f bd fe             	bsr    %esi,%edi
  803baf:	83 f7 1f             	xor    $0x1f,%edi
  803bb2:	75 40                	jne    803bf4 <__udivdi3+0x9c>
  803bb4:	39 ce                	cmp    %ecx,%esi
  803bb6:	72 0a                	jb     803bc2 <__udivdi3+0x6a>
  803bb8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bbc:	0f 87 9e 00 00 00    	ja     803c60 <__udivdi3+0x108>
  803bc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc7:	89 fa                	mov    %edi,%edx
  803bc9:	83 c4 1c             	add    $0x1c,%esp
  803bcc:	5b                   	pop    %ebx
  803bcd:	5e                   	pop    %esi
  803bce:	5f                   	pop    %edi
  803bcf:	5d                   	pop    %ebp
  803bd0:	c3                   	ret    
  803bd1:	8d 76 00             	lea    0x0(%esi),%esi
  803bd4:	31 ff                	xor    %edi,%edi
  803bd6:	31 c0                	xor    %eax,%eax
  803bd8:	89 fa                	mov    %edi,%edx
  803bda:	83 c4 1c             	add    $0x1c,%esp
  803bdd:	5b                   	pop    %ebx
  803bde:	5e                   	pop    %esi
  803bdf:	5f                   	pop    %edi
  803be0:	5d                   	pop    %ebp
  803be1:	c3                   	ret    
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	89 d8                	mov    %ebx,%eax
  803be6:	f7 f7                	div    %edi
  803be8:	31 ff                	xor    %edi,%edi
  803bea:	89 fa                	mov    %edi,%edx
  803bec:	83 c4 1c             	add    $0x1c,%esp
  803bef:	5b                   	pop    %ebx
  803bf0:	5e                   	pop    %esi
  803bf1:	5f                   	pop    %edi
  803bf2:	5d                   	pop    %ebp
  803bf3:	c3                   	ret    
  803bf4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bf9:	89 eb                	mov    %ebp,%ebx
  803bfb:	29 fb                	sub    %edi,%ebx
  803bfd:	89 f9                	mov    %edi,%ecx
  803bff:	d3 e6                	shl    %cl,%esi
  803c01:	89 c5                	mov    %eax,%ebp
  803c03:	88 d9                	mov    %bl,%cl
  803c05:	d3 ed                	shr    %cl,%ebp
  803c07:	89 e9                	mov    %ebp,%ecx
  803c09:	09 f1                	or     %esi,%ecx
  803c0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c0f:	89 f9                	mov    %edi,%ecx
  803c11:	d3 e0                	shl    %cl,%eax
  803c13:	89 c5                	mov    %eax,%ebp
  803c15:	89 d6                	mov    %edx,%esi
  803c17:	88 d9                	mov    %bl,%cl
  803c19:	d3 ee                	shr    %cl,%esi
  803c1b:	89 f9                	mov    %edi,%ecx
  803c1d:	d3 e2                	shl    %cl,%edx
  803c1f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c23:	88 d9                	mov    %bl,%cl
  803c25:	d3 e8                	shr    %cl,%eax
  803c27:	09 c2                	or     %eax,%edx
  803c29:	89 d0                	mov    %edx,%eax
  803c2b:	89 f2                	mov    %esi,%edx
  803c2d:	f7 74 24 0c          	divl   0xc(%esp)
  803c31:	89 d6                	mov    %edx,%esi
  803c33:	89 c3                	mov    %eax,%ebx
  803c35:	f7 e5                	mul    %ebp
  803c37:	39 d6                	cmp    %edx,%esi
  803c39:	72 19                	jb     803c54 <__udivdi3+0xfc>
  803c3b:	74 0b                	je     803c48 <__udivdi3+0xf0>
  803c3d:	89 d8                	mov    %ebx,%eax
  803c3f:	31 ff                	xor    %edi,%edi
  803c41:	e9 58 ff ff ff       	jmp    803b9e <__udivdi3+0x46>
  803c46:	66 90                	xchg   %ax,%ax
  803c48:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c4c:	89 f9                	mov    %edi,%ecx
  803c4e:	d3 e2                	shl    %cl,%edx
  803c50:	39 c2                	cmp    %eax,%edx
  803c52:	73 e9                	jae    803c3d <__udivdi3+0xe5>
  803c54:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c57:	31 ff                	xor    %edi,%edi
  803c59:	e9 40 ff ff ff       	jmp    803b9e <__udivdi3+0x46>
  803c5e:	66 90                	xchg   %ax,%ax
  803c60:	31 c0                	xor    %eax,%eax
  803c62:	e9 37 ff ff ff       	jmp    803b9e <__udivdi3+0x46>
  803c67:	90                   	nop

00803c68 <__umoddi3>:
  803c68:	55                   	push   %ebp
  803c69:	57                   	push   %edi
  803c6a:	56                   	push   %esi
  803c6b:	53                   	push   %ebx
  803c6c:	83 ec 1c             	sub    $0x1c,%esp
  803c6f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c73:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c77:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c7b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c87:	89 f3                	mov    %esi,%ebx
  803c89:	89 fa                	mov    %edi,%edx
  803c8b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c8f:	89 34 24             	mov    %esi,(%esp)
  803c92:	85 c0                	test   %eax,%eax
  803c94:	75 1a                	jne    803cb0 <__umoddi3+0x48>
  803c96:	39 f7                	cmp    %esi,%edi
  803c98:	0f 86 a2 00 00 00    	jbe    803d40 <__umoddi3+0xd8>
  803c9e:	89 c8                	mov    %ecx,%eax
  803ca0:	89 f2                	mov    %esi,%edx
  803ca2:	f7 f7                	div    %edi
  803ca4:	89 d0                	mov    %edx,%eax
  803ca6:	31 d2                	xor    %edx,%edx
  803ca8:	83 c4 1c             	add    $0x1c,%esp
  803cab:	5b                   	pop    %ebx
  803cac:	5e                   	pop    %esi
  803cad:	5f                   	pop    %edi
  803cae:	5d                   	pop    %ebp
  803caf:	c3                   	ret    
  803cb0:	39 f0                	cmp    %esi,%eax
  803cb2:	0f 87 ac 00 00 00    	ja     803d64 <__umoddi3+0xfc>
  803cb8:	0f bd e8             	bsr    %eax,%ebp
  803cbb:	83 f5 1f             	xor    $0x1f,%ebp
  803cbe:	0f 84 ac 00 00 00    	je     803d70 <__umoddi3+0x108>
  803cc4:	bf 20 00 00 00       	mov    $0x20,%edi
  803cc9:	29 ef                	sub    %ebp,%edi
  803ccb:	89 fe                	mov    %edi,%esi
  803ccd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803cd1:	89 e9                	mov    %ebp,%ecx
  803cd3:	d3 e0                	shl    %cl,%eax
  803cd5:	89 d7                	mov    %edx,%edi
  803cd7:	89 f1                	mov    %esi,%ecx
  803cd9:	d3 ef                	shr    %cl,%edi
  803cdb:	09 c7                	or     %eax,%edi
  803cdd:	89 e9                	mov    %ebp,%ecx
  803cdf:	d3 e2                	shl    %cl,%edx
  803ce1:	89 14 24             	mov    %edx,(%esp)
  803ce4:	89 d8                	mov    %ebx,%eax
  803ce6:	d3 e0                	shl    %cl,%eax
  803ce8:	89 c2                	mov    %eax,%edx
  803cea:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cee:	d3 e0                	shl    %cl,%eax
  803cf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cf4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cf8:	89 f1                	mov    %esi,%ecx
  803cfa:	d3 e8                	shr    %cl,%eax
  803cfc:	09 d0                	or     %edx,%eax
  803cfe:	d3 eb                	shr    %cl,%ebx
  803d00:	89 da                	mov    %ebx,%edx
  803d02:	f7 f7                	div    %edi
  803d04:	89 d3                	mov    %edx,%ebx
  803d06:	f7 24 24             	mull   (%esp)
  803d09:	89 c6                	mov    %eax,%esi
  803d0b:	89 d1                	mov    %edx,%ecx
  803d0d:	39 d3                	cmp    %edx,%ebx
  803d0f:	0f 82 87 00 00 00    	jb     803d9c <__umoddi3+0x134>
  803d15:	0f 84 91 00 00 00    	je     803dac <__umoddi3+0x144>
  803d1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d1f:	29 f2                	sub    %esi,%edx
  803d21:	19 cb                	sbb    %ecx,%ebx
  803d23:	89 d8                	mov    %ebx,%eax
  803d25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d29:	d3 e0                	shl    %cl,%eax
  803d2b:	89 e9                	mov    %ebp,%ecx
  803d2d:	d3 ea                	shr    %cl,%edx
  803d2f:	09 d0                	or     %edx,%eax
  803d31:	89 e9                	mov    %ebp,%ecx
  803d33:	d3 eb                	shr    %cl,%ebx
  803d35:	89 da                	mov    %ebx,%edx
  803d37:	83 c4 1c             	add    $0x1c,%esp
  803d3a:	5b                   	pop    %ebx
  803d3b:	5e                   	pop    %esi
  803d3c:	5f                   	pop    %edi
  803d3d:	5d                   	pop    %ebp
  803d3e:	c3                   	ret    
  803d3f:	90                   	nop
  803d40:	89 fd                	mov    %edi,%ebp
  803d42:	85 ff                	test   %edi,%edi
  803d44:	75 0b                	jne    803d51 <__umoddi3+0xe9>
  803d46:	b8 01 00 00 00       	mov    $0x1,%eax
  803d4b:	31 d2                	xor    %edx,%edx
  803d4d:	f7 f7                	div    %edi
  803d4f:	89 c5                	mov    %eax,%ebp
  803d51:	89 f0                	mov    %esi,%eax
  803d53:	31 d2                	xor    %edx,%edx
  803d55:	f7 f5                	div    %ebp
  803d57:	89 c8                	mov    %ecx,%eax
  803d59:	f7 f5                	div    %ebp
  803d5b:	89 d0                	mov    %edx,%eax
  803d5d:	e9 44 ff ff ff       	jmp    803ca6 <__umoddi3+0x3e>
  803d62:	66 90                	xchg   %ax,%ax
  803d64:	89 c8                	mov    %ecx,%eax
  803d66:	89 f2                	mov    %esi,%edx
  803d68:	83 c4 1c             	add    $0x1c,%esp
  803d6b:	5b                   	pop    %ebx
  803d6c:	5e                   	pop    %esi
  803d6d:	5f                   	pop    %edi
  803d6e:	5d                   	pop    %ebp
  803d6f:	c3                   	ret    
  803d70:	3b 04 24             	cmp    (%esp),%eax
  803d73:	72 06                	jb     803d7b <__umoddi3+0x113>
  803d75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d79:	77 0f                	ja     803d8a <__umoddi3+0x122>
  803d7b:	89 f2                	mov    %esi,%edx
  803d7d:	29 f9                	sub    %edi,%ecx
  803d7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d83:	89 14 24             	mov    %edx,(%esp)
  803d86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d8e:	8b 14 24             	mov    (%esp),%edx
  803d91:	83 c4 1c             	add    $0x1c,%esp
  803d94:	5b                   	pop    %ebx
  803d95:	5e                   	pop    %esi
  803d96:	5f                   	pop    %edi
  803d97:	5d                   	pop    %ebp
  803d98:	c3                   	ret    
  803d99:	8d 76 00             	lea    0x0(%esi),%esi
  803d9c:	2b 04 24             	sub    (%esp),%eax
  803d9f:	19 fa                	sbb    %edi,%edx
  803da1:	89 d1                	mov    %edx,%ecx
  803da3:	89 c6                	mov    %eax,%esi
  803da5:	e9 71 ff ff ff       	jmp    803d1b <__umoddi3+0xb3>
  803daa:	66 90                	xchg   %ax,%ax
  803dac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803db0:	72 ea                	jb     803d9c <__umoddi3+0x134>
  803db2:	89 d9                	mov    %ebx,%ecx
  803db4:	e9 62 ff ff ff       	jmp    803d1b <__umoddi3+0xb3>
