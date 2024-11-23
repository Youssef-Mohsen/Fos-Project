
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
  800052:	68 40 3d 80 00       	push   $0x803d40
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
  8000bc:	68 5e 3d 80 00       	push   $0x803d5e
  8000c1:	e8 f1 02 00 00       	call   8003b7 <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 4d 1b 00 00       	call   801c1b <inctst>
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
  80017d:	e8 5b 19 00 00       	call   801add <sys_getenvindex>
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
  8001eb:	e8 71 16 00 00       	call   801861 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 8c 3d 80 00       	push   $0x803d8c
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
  80021b:	68 b4 3d 80 00       	push   $0x803db4
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
  80024c:	68 dc 3d 80 00       	push   $0x803ddc
  800251:	e8 34 01 00 00       	call   80038a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 34 3e 80 00       	push   $0x803e34
  80026d:	e8 18 01 00 00       	call   80038a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 8c 3d 80 00       	push   $0x803d8c
  80027d:	e8 08 01 00 00       	call   80038a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800285:	e8 f1 15 00 00       	call   80187b <sys_unlock_cons>
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
  80029d:	e8 07 18 00 00       	call   801aa9 <sys_destroy_env>
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
  8002ae:	e8 5c 18 00 00       	call   801b0f <sys_exit_env>
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
  8002fc:	e8 1e 15 00 00       	call   80181f <sys_cputs>
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
  800373:	e8 a7 14 00 00       	call   80181f <sys_cputs>
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
  8003bd:	e8 9f 14 00 00       	call   801861 <sys_lock_cons>
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
  8003dd:	e8 99 14 00 00       	call   80187b <sys_unlock_cons>
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
  800427:	e8 b0 36 00 00       	call   803adc <__udivdi3>
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
  800477:	e8 70 37 00 00       	call   803bec <__umoddi3>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	05 74 40 80 00       	add    $0x804074,%eax
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
  8005d2:	8b 04 85 98 40 80 00 	mov    0x804098(,%eax,4),%eax
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
  8006b3:	8b 34 9d e0 3e 80 00 	mov    0x803ee0(,%ebx,4),%esi
  8006ba:	85 f6                	test   %esi,%esi
  8006bc:	75 19                	jne    8006d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006be:	53                   	push   %ebx
  8006bf:	68 85 40 80 00       	push   $0x804085
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
  8006d8:	68 8e 40 80 00       	push   $0x80408e
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
  800705:	be 91 40 80 00       	mov    $0x804091,%esi
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
  800a30:	68 08 42 80 00       	push   $0x804208
  800a35:	e8 50 f9 ff ff       	call   80038a <cprintf>
  800a3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a44:	83 ec 0c             	sub    $0xc,%esp
  800a47:	6a 00                	push   $0x0
  800a49:	e8 9a 2e 00 00       	call   8038e8 <iscons>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a54:	e8 7c 2e 00 00       	call   8038d5 <getchar>
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
  800a72:	68 0b 42 80 00       	push   $0x80420b
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
  800a9f:	e8 12 2e 00 00       	call   8038b6 <cputchar>
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
  800ad6:	e8 db 2d 00 00       	call   8038b6 <cputchar>
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
  800aff:	e8 b2 2d 00 00       	call   8038b6 <cputchar>
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
  800b23:	e8 39 0d 00 00       	call   801861 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b2c:	74 13                	je     800b41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 08             	pushl  0x8(%ebp)
  800b34:	68 08 42 80 00       	push   $0x804208
  800b39:	e8 4c f8 ff ff       	call   80038a <cprintf>
  800b3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b48:	83 ec 0c             	sub    $0xc,%esp
  800b4b:	6a 00                	push   $0x0
  800b4d:	e8 96 2d 00 00       	call   8038e8 <iscons>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b58:	e8 78 2d 00 00       	call   8038d5 <getchar>
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
  800b76:	68 0b 42 80 00       	push   $0x80420b
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
  800ba3:	e8 0e 2d 00 00       	call   8038b6 <cputchar>
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
  800bda:	e8 d7 2c 00 00       	call   8038b6 <cputchar>
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
  800c03:	e8 ae 2c 00 00       	call   8038b6 <cputchar>
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
  800c1e:	e8 58 0c 00 00       	call   80187b <sys_unlock_cons>
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
  801318:	68 1c 42 80 00       	push   $0x80421c
  80131d:	68 3f 01 00 00       	push   $0x13f
  801322:	68 3e 42 80 00       	push   $0x80423e
  801327:	e8 c6 25 00 00       	call   8038f2 <_panic>

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
  801338:	e8 8d 0a 00 00       	call   801dca <sys_sbrk>
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
  8013b3:	e8 96 08 00 00       	call   801c4e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	74 16                	je     8013d2 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 08             	pushl  0x8(%ebp)
  8013c2:	e8 d6 0d 00 00       	call   80219d <alloc_block_FF>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013cd:	e9 8a 01 00 00       	jmp    80155c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013d2:	e8 a8 08 00 00       	call   801c7f <sys_isUHeapPlacementStrategyBESTFIT>
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	0f 84 7d 01 00 00    	je     80155c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013df:	83 ec 0c             	sub    $0xc,%esp
  8013e2:	ff 75 08             	pushl  0x8(%ebp)
  8013e5:	e8 6f 12 00 00       	call   802659 <alloc_block_BF>
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
  80154b:	e8 b1 08 00 00       	call   801e01 <sys_allocate_user_mem>
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
  801593:	e8 85 08 00 00       	call   801e1d <get_block_size>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 b8 1a 00 00       	call   803061 <free_block>
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
  80163b:	e8 a5 07 00 00       	call   801de5 <sys_free_user_mem>
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
  801649:	68 4c 42 80 00       	push   $0x80424c
  80164e:	68 84 00 00 00       	push   $0x84
  801653:	68 76 42 80 00       	push   $0x804276
  801658:	e8 95 22 00 00       	call   8038f2 <_panic>
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
  801676:	eb 64                	jmp    8016dc <smalloc+0x7d>
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
  8016ab:	eb 2f                	jmp    8016dc <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8016ad:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8016b4:	50                   	push   %eax
  8016b5:	ff 75 0c             	pushl  0xc(%ebp)
  8016b8:	ff 75 08             	pushl  0x8(%ebp)
  8016bb:	e8 2c 03 00 00       	call   8019ec <sys_createSharedObject>
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  8016c6:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016ca:	74 06                	je     8016d2 <smalloc+0x73>
  8016cc:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016d0:	75 07                	jne    8016d9 <smalloc+0x7a>
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d7:	eb 03                	jmp    8016dc <smalloc+0x7d>
	 return ptr;
  8016d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016e4:	83 ec 08             	sub    $0x8,%esp
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	e8 24 03 00 00       	call   801a16 <sys_getSizeOfSharedObject>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8016f8:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016fc:	75 07                	jne    801705 <sget+0x27>
  8016fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801703:	eb 5c                	jmp    801761 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801708:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80170b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801712:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801718:	39 d0                	cmp    %edx,%eax
  80171a:	7d 02                	jge    80171e <sget+0x40>
  80171c:	89 d0                	mov    %edx,%eax
  80171e:	83 ec 0c             	sub    $0xc,%esp
  801721:	50                   	push   %eax
  801722:	e8 1b fc ff ff       	call   801342 <malloc>
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80172d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801731:	75 07                	jne    80173a <sget+0x5c>
  801733:	b8 00 00 00 00       	mov    $0x0,%eax
  801738:	eb 27                	jmp    801761 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	ff 75 e8             	pushl  -0x18(%ebp)
  801740:	ff 75 0c             	pushl  0xc(%ebp)
  801743:	ff 75 08             	pushl  0x8(%ebp)
  801746:	e8 e8 02 00 00       	call   801a33 <sys_getSharedObject>
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801751:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801755:	75 07                	jne    80175e <sget+0x80>
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
  80175c:	eb 03                	jmp    801761 <sget+0x83>
	return ptr;
  80175e:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	68 84 42 80 00       	push   $0x804284
  801771:	68 c1 00 00 00       	push   $0xc1
  801776:	68 76 42 80 00       	push   $0x804276
  80177b:	e8 72 21 00 00       	call   8038f2 <_panic>

00801780 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	68 a8 42 80 00       	push   $0x8042a8
  80178e:	68 d8 00 00 00       	push   $0xd8
  801793:	68 76 42 80 00       	push   $0x804276
  801798:	e8 55 21 00 00       	call   8038f2 <_panic>

0080179d <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	68 ce 42 80 00       	push   $0x8042ce
  8017ab:	68 e4 00 00 00       	push   $0xe4
  8017b0:	68 76 42 80 00       	push   $0x804276
  8017b5:	e8 38 21 00 00       	call   8038f2 <_panic>

008017ba <shrink>:

}
void shrink(uint32 newSize)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	68 ce 42 80 00       	push   $0x8042ce
  8017c8:	68 e9 00 00 00       	push   $0xe9
  8017cd:	68 76 42 80 00       	push   $0x804276
  8017d2:	e8 1b 21 00 00       	call   8038f2 <_panic>

008017d7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017dd:	83 ec 04             	sub    $0x4,%esp
  8017e0:	68 ce 42 80 00       	push   $0x8042ce
  8017e5:	68 ee 00 00 00       	push   $0xee
  8017ea:	68 76 42 80 00       	push   $0x804276
  8017ef:	e8 fe 20 00 00       	call   8038f2 <_panic>

008017f4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	57                   	push   %edi
  8017f8:	56                   	push   %esi
  8017f9:	53                   	push   %ebx
  8017fa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8b 55 0c             	mov    0xc(%ebp),%edx
  801803:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801806:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801809:	8b 7d 18             	mov    0x18(%ebp),%edi
  80180c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180f:	cd 30                	int    $0x30
  801811:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801814:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	5b                   	pop    %ebx
  80181b:	5e                   	pop    %esi
  80181c:	5f                   	pop    %edi
  80181d:	5d                   	pop    %ebp
  80181e:	c3                   	ret    

0080181f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	8b 45 10             	mov    0x10(%ebp),%eax
  801828:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80182b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	52                   	push   %edx
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	50                   	push   %eax
  80183b:	6a 00                	push   $0x0
  80183d:	e8 b2 ff ff ff       	call   8017f4 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	90                   	nop
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_cgetc>:

int
sys_cgetc(void)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 02                	push   $0x2
  801857:	e8 98 ff ff ff       	call   8017f4 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 03                	push   $0x3
  801870:	e8 7f ff ff ff       	call   8017f4 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	90                   	nop
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 04                	push   $0x4
  80188a:	e8 65 ff ff ff       	call   8017f4 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	90                   	nop
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801898:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	52                   	push   %edx
  8018a5:	50                   	push   %eax
  8018a6:	6a 08                	push   $0x8
  8018a8:	e8 47 ff ff ff       	call   8017f4 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	56                   	push   %esi
  8018b6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8018ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
  8018c8:	51                   	push   %ecx
  8018c9:	52                   	push   %edx
  8018ca:	50                   	push   %eax
  8018cb:	6a 09                	push   $0x9
  8018cd:	e8 22 ff ff ff       	call   8017f4 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d8:	5b                   	pop    %ebx
  8018d9:	5e                   	pop    %esi
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    

008018dc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	52                   	push   %edx
  8018ec:	50                   	push   %eax
  8018ed:	6a 0a                	push   $0xa
  8018ef:	e8 00 ff ff ff       	call   8017f4 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	ff 75 08             	pushl  0x8(%ebp)
  801908:	6a 0b                	push   $0xb
  80190a:	e8 e5 fe ff ff       	call   8017f4 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 0c                	push   $0xc
  801923:	e8 cc fe ff ff       	call   8017f4 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 0d                	push   $0xd
  80193c:	e8 b3 fe ff ff       	call   8017f4 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 0e                	push   $0xe
  801955:	e8 9a fe ff ff       	call   8017f4 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 0f                	push   $0xf
  80196e:	e8 81 fe ff ff       	call   8017f4 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	ff 75 08             	pushl  0x8(%ebp)
  801986:	6a 10                	push   $0x10
  801988:	e8 67 fe ff ff       	call   8017f4 <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 11                	push   $0x11
  8019a1:	e8 4e fe ff ff       	call   8017f4 <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
}
  8019a9:	90                   	nop
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_cputc>:

void
sys_cputc(const char c)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 04             	sub    $0x4,%esp
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019b8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	50                   	push   %eax
  8019c5:	6a 01                	push   $0x1
  8019c7:	e8 28 fe ff ff       	call   8017f4 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 14                	push   $0x14
  8019e1:	e8 0e fe ff ff       	call   8017f4 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	90                   	nop
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019f8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019fb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	6a 00                	push   $0x0
  801a04:	51                   	push   %ecx
  801a05:	52                   	push   %edx
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	50                   	push   %eax
  801a0a:	6a 15                	push   $0x15
  801a0c:	e8 e3 fd ff ff       	call   8017f4 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	52                   	push   %edx
  801a26:	50                   	push   %eax
  801a27:	6a 16                	push   $0x16
  801a29:	e8 c6 fd ff ff       	call   8017f4 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a36:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	51                   	push   %ecx
  801a44:	52                   	push   %edx
  801a45:	50                   	push   %eax
  801a46:	6a 17                	push   $0x17
  801a48:	e8 a7 fd ff ff       	call   8017f4 <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	52                   	push   %edx
  801a62:	50                   	push   %eax
  801a63:	6a 18                	push   $0x18
  801a65:	e8 8a fd ff ff       	call   8017f4 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	6a 00                	push   $0x0
  801a77:	ff 75 14             	pushl  0x14(%ebp)
  801a7a:	ff 75 10             	pushl  0x10(%ebp)
  801a7d:	ff 75 0c             	pushl  0xc(%ebp)
  801a80:	50                   	push   %eax
  801a81:	6a 19                	push   $0x19
  801a83:	e8 6c fd ff ff       	call   8017f4 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	50                   	push   %eax
  801a9c:	6a 1a                	push   $0x1a
  801a9e:	e8 51 fd ff ff       	call   8017f4 <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
}
  801aa6:	90                   	nop
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	50                   	push   %eax
  801ab8:	6a 1b                	push   $0x1b
  801aba:	e8 35 fd ff ff       	call   8017f4 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 05                	push   $0x5
  801ad3:	e8 1c fd ff ff       	call   8017f4 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 06                	push   $0x6
  801aec:	e8 03 fd ff ff       	call   8017f4 <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 07                	push   $0x7
  801b05:	e8 ea fc ff ff       	call   8017f4 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_exit_env>:


void sys_exit_env(void)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 1c                	push   $0x1c
  801b1e:	e8 d1 fc ff ff       	call   8017f4 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	90                   	nop
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b2f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b32:	8d 50 04             	lea    0x4(%eax),%edx
  801b35:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	52                   	push   %edx
  801b3f:	50                   	push   %eax
  801b40:	6a 1d                	push   $0x1d
  801b42:	e8 ad fc ff ff       	call   8017f4 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
	return result;
  801b4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b53:	89 01                	mov    %eax,(%ecx)
  801b55:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	c9                   	leave  
  801b5c:	c2 04 00             	ret    $0x4

00801b5f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	ff 75 10             	pushl  0x10(%ebp)
  801b69:	ff 75 0c             	pushl  0xc(%ebp)
  801b6c:	ff 75 08             	pushl  0x8(%ebp)
  801b6f:	6a 13                	push   $0x13
  801b71:	e8 7e fc ff ff       	call   8017f4 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
	return ;
  801b79:	90                   	nop
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_rcr2>:
uint32 sys_rcr2()
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 1e                	push   $0x1e
  801b8b:	e8 64 fc ff ff       	call   8017f4 <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 04             	sub    $0x4,%esp
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ba1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	50                   	push   %eax
  801bae:	6a 1f                	push   $0x1f
  801bb0:	e8 3f fc ff ff       	call   8017f4 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb8:	90                   	nop
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <rsttst>:
void rsttst()
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 21                	push   $0x21
  801bca:	e8 25 fc ff ff       	call   8017f4 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd2:	90                   	nop
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	83 ec 04             	sub    $0x4,%esp
  801bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bde:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801be1:	8b 55 18             	mov    0x18(%ebp),%edx
  801be4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be8:	52                   	push   %edx
  801be9:	50                   	push   %eax
  801bea:	ff 75 10             	pushl  0x10(%ebp)
  801bed:	ff 75 0c             	pushl  0xc(%ebp)
  801bf0:	ff 75 08             	pushl  0x8(%ebp)
  801bf3:	6a 20                	push   $0x20
  801bf5:	e8 fa fb ff ff       	call   8017f4 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfd:	90                   	nop
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <chktst>:
void chktst(uint32 n)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	ff 75 08             	pushl  0x8(%ebp)
  801c0e:	6a 22                	push   $0x22
  801c10:	e8 df fb ff ff       	call   8017f4 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
	return ;
  801c18:	90                   	nop
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <inctst>:

void inctst()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 23                	push   $0x23
  801c2a:	e8 c5 fb ff ff       	call   8017f4 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c32:	90                   	nop
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <gettst>:
uint32 gettst()
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 24                	push   $0x24
  801c44:	e8 ab fb ff ff       	call   8017f4 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 25                	push   $0x25
  801c60:	e8 8f fb ff ff       	call   8017f4 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
  801c68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c6b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c6f:	75 07                	jne    801c78 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c71:	b8 01 00 00 00       	mov    $0x1,%eax
  801c76:	eb 05                	jmp    801c7d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 25                	push   $0x25
  801c91:	e8 5e fb ff ff       	call   8017f4 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
  801c99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c9c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ca0:	75 07                	jne    801ca9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ca2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca7:	eb 05                	jmp    801cae <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 25                	push   $0x25
  801cc2:	e8 2d fb ff ff       	call   8017f4 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
  801cca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ccd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cd1:	75 07                	jne    801cda <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd8:	eb 05                	jmp    801cdf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 25                	push   $0x25
  801cf3:	e8 fc fa ff ff       	call   8017f4 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
  801cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cfe:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d02:	75 07                	jne    801d0b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d04:	b8 01 00 00 00       	mov    $0x1,%eax
  801d09:	eb 05                	jmp    801d10 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	ff 75 08             	pushl  0x8(%ebp)
  801d20:	6a 26                	push   $0x26
  801d22:	e8 cd fa ff ff       	call   8017f4 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2a:	90                   	nop
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d31:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	53                   	push   %ebx
  801d40:	51                   	push   %ecx
  801d41:	52                   	push   %edx
  801d42:	50                   	push   %eax
  801d43:	6a 27                	push   $0x27
  801d45:	e8 aa fa ff ff       	call   8017f4 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	52                   	push   %edx
  801d62:	50                   	push   %eax
  801d63:	6a 28                	push   $0x28
  801d65:	e8 8a fa ff ff       	call   8017f4 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d72:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	6a 00                	push   $0x0
  801d7d:	51                   	push   %ecx
  801d7e:	ff 75 10             	pushl  0x10(%ebp)
  801d81:	52                   	push   %edx
  801d82:	50                   	push   %eax
  801d83:	6a 29                	push   $0x29
  801d85:	e8 6a fa ff ff       	call   8017f4 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	ff 75 10             	pushl  0x10(%ebp)
  801d99:	ff 75 0c             	pushl  0xc(%ebp)
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	6a 12                	push   $0x12
  801da1:	e8 4e fa ff ff       	call   8017f4 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
	return ;
  801da9:	90                   	nop
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801daf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	52                   	push   %edx
  801dbc:	50                   	push   %eax
  801dbd:	6a 2a                	push   $0x2a
  801dbf:	e8 30 fa ff ff       	call   8017f4 <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
	return;
  801dc7:	90                   	nop
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	50                   	push   %eax
  801dd9:	6a 2b                	push   $0x2b
  801ddb:	e8 14 fa ff ff       	call   8017f4 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	ff 75 0c             	pushl  0xc(%ebp)
  801df1:	ff 75 08             	pushl  0x8(%ebp)
  801df4:	6a 2c                	push   $0x2c
  801df6:	e8 f9 f9 ff ff       	call   8017f4 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
	return;
  801dfe:	90                   	nop
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	ff 75 0c             	pushl  0xc(%ebp)
  801e0d:	ff 75 08             	pushl  0x8(%ebp)
  801e10:	6a 2d                	push   $0x2d
  801e12:	e8 dd f9 ff ff       	call   8017f4 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
	return;
  801e1a:	90                   	nop
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	83 e8 04             	sub    $0x4,%eax
  801e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e2f:	8b 00                	mov    (%eax),%eax
  801e31:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	83 e8 04             	sub    $0x4,%eax
  801e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e48:	8b 00                	mov    (%eax),%eax
  801e4a:	83 e0 01             	and    $0x1,%eax
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	0f 94 c0             	sete   %al
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e64:	83 f8 02             	cmp    $0x2,%eax
  801e67:	74 2b                	je     801e94 <alloc_block+0x40>
  801e69:	83 f8 02             	cmp    $0x2,%eax
  801e6c:	7f 07                	jg     801e75 <alloc_block+0x21>
  801e6e:	83 f8 01             	cmp    $0x1,%eax
  801e71:	74 0e                	je     801e81 <alloc_block+0x2d>
  801e73:	eb 58                	jmp    801ecd <alloc_block+0x79>
  801e75:	83 f8 03             	cmp    $0x3,%eax
  801e78:	74 2d                	je     801ea7 <alloc_block+0x53>
  801e7a:	83 f8 04             	cmp    $0x4,%eax
  801e7d:	74 3b                	je     801eba <alloc_block+0x66>
  801e7f:	eb 4c                	jmp    801ecd <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e81:	83 ec 0c             	sub    $0xc,%esp
  801e84:	ff 75 08             	pushl  0x8(%ebp)
  801e87:	e8 11 03 00 00       	call   80219d <alloc_block_FF>
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e92:	eb 4a                	jmp    801ede <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e94:	83 ec 0c             	sub    $0xc,%esp
  801e97:	ff 75 08             	pushl  0x8(%ebp)
  801e9a:	e8 fa 19 00 00       	call   803899 <alloc_block_NF>
  801e9f:	83 c4 10             	add    $0x10,%esp
  801ea2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ea5:	eb 37                	jmp    801ede <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ea7:	83 ec 0c             	sub    $0xc,%esp
  801eaa:	ff 75 08             	pushl  0x8(%ebp)
  801ead:	e8 a7 07 00 00       	call   802659 <alloc_block_BF>
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eb8:	eb 24                	jmp    801ede <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801eba:	83 ec 0c             	sub    $0xc,%esp
  801ebd:	ff 75 08             	pushl  0x8(%ebp)
  801ec0:	e8 b7 19 00 00       	call   80387c <alloc_block_WF>
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ecb:	eb 11                	jmp    801ede <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ecd:	83 ec 0c             	sub    $0xc,%esp
  801ed0:	68 e0 42 80 00       	push   $0x8042e0
  801ed5:	e8 b0 e4 ff ff       	call   80038a <cprintf>
  801eda:	83 c4 10             	add    $0x10,%esp
		break;
  801edd:	90                   	nop
	}
	return va;
  801ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	53                   	push   %ebx
  801ee7:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801eea:	83 ec 0c             	sub    $0xc,%esp
  801eed:	68 00 43 80 00       	push   $0x804300
  801ef2:	e8 93 e4 ff ff       	call   80038a <cprintf>
  801ef7:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801efa:	83 ec 0c             	sub    $0xc,%esp
  801efd:	68 2b 43 80 00       	push   $0x80432b
  801f02:	e8 83 e4 ff ff       	call   80038a <cprintf>
  801f07:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f10:	eb 37                	jmp    801f49 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f12:	83 ec 0c             	sub    $0xc,%esp
  801f15:	ff 75 f4             	pushl  -0xc(%ebp)
  801f18:	e8 19 ff ff ff       	call   801e36 <is_free_block>
  801f1d:	83 c4 10             	add    $0x10,%esp
  801f20:	0f be d8             	movsbl %al,%ebx
  801f23:	83 ec 0c             	sub    $0xc,%esp
  801f26:	ff 75 f4             	pushl  -0xc(%ebp)
  801f29:	e8 ef fe ff ff       	call   801e1d <get_block_size>
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	83 ec 04             	sub    $0x4,%esp
  801f34:	53                   	push   %ebx
  801f35:	50                   	push   %eax
  801f36:	68 43 43 80 00       	push   $0x804343
  801f3b:	e8 4a e4 ff ff       	call   80038a <cprintf>
  801f40:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f43:	8b 45 10             	mov    0x10(%ebp),%eax
  801f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4d:	74 07                	je     801f56 <print_blocks_list+0x73>
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	8b 00                	mov    (%eax),%eax
  801f54:	eb 05                	jmp    801f5b <print_blocks_list+0x78>
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5b:	89 45 10             	mov    %eax,0x10(%ebp)
  801f5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801f61:	85 c0                	test   %eax,%eax
  801f63:	75 ad                	jne    801f12 <print_blocks_list+0x2f>
  801f65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f69:	75 a7                	jne    801f12 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f6b:	83 ec 0c             	sub    $0xc,%esp
  801f6e:	68 00 43 80 00       	push   $0x804300
  801f73:	e8 12 e4 ff ff       	call   80038a <cprintf>
  801f78:	83 c4 10             	add    $0x10,%esp

}
  801f7b:	90                   	nop
  801f7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8a:	83 e0 01             	and    $0x1,%eax
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	74 03                	je     801f94 <initialize_dynamic_allocator+0x13>
  801f91:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f94:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f98:	0f 84 c7 01 00 00    	je     802165 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f9e:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801fa5:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  801fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fae:	01 d0                	add    %edx,%eax
  801fb0:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801fb5:	0f 87 ad 01 00 00    	ja     802168 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	0f 89 a5 01 00 00    	jns    80216b <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fcc:	01 d0                	add    %edx,%eax
  801fce:	83 e8 04             	sub    $0x4,%eax
  801fd1:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801fd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801fdd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe5:	e9 87 00 00 00       	jmp    802071 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801fea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fee:	75 14                	jne    802004 <initialize_dynamic_allocator+0x83>
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	68 5b 43 80 00       	push   $0x80435b
  801ff8:	6a 79                	push   $0x79
  801ffa:	68 79 43 80 00       	push   $0x804379
  801fff:	e8 ee 18 00 00       	call   8038f2 <_panic>
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	8b 00                	mov    (%eax),%eax
  802009:	85 c0                	test   %eax,%eax
  80200b:	74 10                	je     80201d <initialize_dynamic_allocator+0x9c>
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	8b 00                	mov    (%eax),%eax
  802012:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802015:	8b 52 04             	mov    0x4(%edx),%edx
  802018:	89 50 04             	mov    %edx,0x4(%eax)
  80201b:	eb 0b                	jmp    802028 <initialize_dynamic_allocator+0xa7>
  80201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802020:	8b 40 04             	mov    0x4(%eax),%eax
  802023:	a3 30 50 80 00       	mov    %eax,0x805030
  802028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202b:	8b 40 04             	mov    0x4(%eax),%eax
  80202e:	85 c0                	test   %eax,%eax
  802030:	74 0f                	je     802041 <initialize_dynamic_allocator+0xc0>
  802032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802035:	8b 40 04             	mov    0x4(%eax),%eax
  802038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203b:	8b 12                	mov    (%edx),%edx
  80203d:	89 10                	mov    %edx,(%eax)
  80203f:	eb 0a                	jmp    80204b <initialize_dynamic_allocator+0xca>
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	8b 00                	mov    (%eax),%eax
  802046:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802057:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80205e:	a1 38 50 80 00       	mov    0x805038,%eax
  802063:	48                   	dec    %eax
  802064:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802069:	a1 34 50 80 00       	mov    0x805034,%eax
  80206e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802071:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802075:	74 07                	je     80207e <initialize_dynamic_allocator+0xfd>
  802077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207a:	8b 00                	mov    (%eax),%eax
  80207c:	eb 05                	jmp    802083 <initialize_dynamic_allocator+0x102>
  80207e:	b8 00 00 00 00       	mov    $0x0,%eax
  802083:	a3 34 50 80 00       	mov    %eax,0x805034
  802088:	a1 34 50 80 00       	mov    0x805034,%eax
  80208d:	85 c0                	test   %eax,%eax
  80208f:	0f 85 55 ff ff ff    	jne    801fea <initialize_dynamic_allocator+0x69>
  802095:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802099:	0f 85 4b ff ff ff    	jne    801fea <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8020ae:	a1 44 50 80 00       	mov    0x805044,%eax
  8020b3:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8020b8:	a1 40 50 80 00       	mov    0x805040,%eax
  8020bd:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	83 c0 08             	add    $0x8,%eax
  8020c9:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	83 c0 04             	add    $0x4,%eax
  8020d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d5:	83 ea 08             	sub    $0x8,%edx
  8020d8:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	01 d0                	add    %edx,%eax
  8020e2:	83 e8 08             	sub    $0x8,%eax
  8020e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e8:	83 ea 08             	sub    $0x8,%edx
  8020eb:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802100:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802104:	75 17                	jne    80211d <initialize_dynamic_allocator+0x19c>
  802106:	83 ec 04             	sub    $0x4,%esp
  802109:	68 94 43 80 00       	push   $0x804394
  80210e:	68 90 00 00 00       	push   $0x90
  802113:	68 79 43 80 00       	push   $0x804379
  802118:	e8 d5 17 00 00       	call   8038f2 <_panic>
  80211d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802123:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802126:	89 10                	mov    %edx,(%eax)
  802128:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212b:	8b 00                	mov    (%eax),%eax
  80212d:	85 c0                	test   %eax,%eax
  80212f:	74 0d                	je     80213e <initialize_dynamic_allocator+0x1bd>
  802131:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802136:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802139:	89 50 04             	mov    %edx,0x4(%eax)
  80213c:	eb 08                	jmp    802146 <initialize_dynamic_allocator+0x1c5>
  80213e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802141:	a3 30 50 80 00       	mov    %eax,0x805030
  802146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802149:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80214e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802151:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802158:	a1 38 50 80 00       	mov    0x805038,%eax
  80215d:	40                   	inc    %eax
  80215e:	a3 38 50 80 00       	mov    %eax,0x805038
  802163:	eb 07                	jmp    80216c <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802165:	90                   	nop
  802166:	eb 04                	jmp    80216c <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802168:	90                   	nop
  802169:	eb 01                	jmp    80216c <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80216b:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802171:	8b 45 10             	mov    0x10(%ebp),%eax
  802174:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80217d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802180:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	83 e8 04             	sub    $0x4,%eax
  802188:	8b 00                	mov    (%eax),%eax
  80218a:	83 e0 fe             	and    $0xfffffffe,%eax
  80218d:	8d 50 f8             	lea    -0x8(%eax),%edx
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	01 c2                	add    %eax,%edx
  802195:	8b 45 0c             	mov    0xc(%ebp),%eax
  802198:	89 02                	mov    %eax,(%edx)
}
  80219a:	90                   	nop
  80219b:	5d                   	pop    %ebp
  80219c:	c3                   	ret    

0080219d <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	83 e0 01             	and    $0x1,%eax
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	74 03                	je     8021b0 <alloc_block_FF+0x13>
  8021ad:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8021b0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8021b4:	77 07                	ja     8021bd <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8021b6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021bd:	a1 24 50 80 00       	mov    0x805024,%eax
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	75 73                	jne    802239 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	83 c0 10             	add    $0x10,%eax
  8021cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021cf:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8021d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021dc:	01 d0                	add    %edx,%eax
  8021de:	48                   	dec    %eax
  8021df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8021ea:	f7 75 ec             	divl   -0x14(%ebp)
  8021ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021f0:	29 d0                	sub    %edx,%eax
  8021f2:	c1 e8 0c             	shr    $0xc,%eax
  8021f5:	83 ec 0c             	sub    $0xc,%esp
  8021f8:	50                   	push   %eax
  8021f9:	e8 2e f1 ff ff       	call   80132c <sbrk>
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802204:	83 ec 0c             	sub    $0xc,%esp
  802207:	6a 00                	push   $0x0
  802209:	e8 1e f1 ff ff       	call   80132c <sbrk>
  80220e:	83 c4 10             	add    $0x10,%esp
  802211:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802214:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802217:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80221a:	83 ec 08             	sub    $0x8,%esp
  80221d:	50                   	push   %eax
  80221e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802221:	e8 5b fd ff ff       	call   801f81 <initialize_dynamic_allocator>
  802226:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802229:	83 ec 0c             	sub    $0xc,%esp
  80222c:	68 b7 43 80 00       	push   $0x8043b7
  802231:	e8 54 e1 ff ff       	call   80038a <cprintf>
  802236:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80223d:	75 0a                	jne    802249 <alloc_block_FF+0xac>
	        return NULL;
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
  802244:	e9 0e 04 00 00       	jmp    802657 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802249:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802250:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802255:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802258:	e9 f3 02 00 00       	jmp    802550 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80225d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802260:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802263:	83 ec 0c             	sub    $0xc,%esp
  802266:	ff 75 bc             	pushl  -0x44(%ebp)
  802269:	e8 af fb ff ff       	call   801e1d <get_block_size>
  80226e:	83 c4 10             	add    $0x10,%esp
  802271:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	83 c0 08             	add    $0x8,%eax
  80227a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80227d:	0f 87 c5 02 00 00    	ja     802548 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	83 c0 18             	add    $0x18,%eax
  802289:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80228c:	0f 87 19 02 00 00    	ja     8024ab <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802292:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802295:	2b 45 08             	sub    0x8(%ebp),%eax
  802298:	83 e8 08             	sub    $0x8,%eax
  80229b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	8d 50 08             	lea    0x8(%eax),%edx
  8022a4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022a7:	01 d0                	add    %edx,%eax
  8022a9:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	83 c0 08             	add    $0x8,%eax
  8022b2:	83 ec 04             	sub    $0x4,%esp
  8022b5:	6a 01                	push   $0x1
  8022b7:	50                   	push   %eax
  8022b8:	ff 75 bc             	pushl  -0x44(%ebp)
  8022bb:	e8 ae fe ff ff       	call   80216e <set_block_data>
  8022c0:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 40 04             	mov    0x4(%eax),%eax
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	75 68                	jne    802335 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022cd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022d1:	75 17                	jne    8022ea <alloc_block_FF+0x14d>
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	68 94 43 80 00       	push   $0x804394
  8022db:	68 d7 00 00 00       	push   $0xd7
  8022e0:	68 79 43 80 00       	push   $0x804379
  8022e5:	e8 08 16 00 00       	call   8038f2 <_panic>
  8022ea:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f3:	89 10                	mov    %edx,(%eax)
  8022f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f8:	8b 00                	mov    (%eax),%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	74 0d                	je     80230b <alloc_block_FF+0x16e>
  8022fe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802303:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802306:	89 50 04             	mov    %edx,0x4(%eax)
  802309:	eb 08                	jmp    802313 <alloc_block_FF+0x176>
  80230b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80230e:	a3 30 50 80 00       	mov    %eax,0x805030
  802313:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802316:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80231b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80231e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802325:	a1 38 50 80 00       	mov    0x805038,%eax
  80232a:	40                   	inc    %eax
  80232b:	a3 38 50 80 00       	mov    %eax,0x805038
  802330:	e9 dc 00 00 00       	jmp    802411 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 00                	mov    (%eax),%eax
  80233a:	85 c0                	test   %eax,%eax
  80233c:	75 65                	jne    8023a3 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80233e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802342:	75 17                	jne    80235b <alloc_block_FF+0x1be>
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	68 c8 43 80 00       	push   $0x8043c8
  80234c:	68 db 00 00 00       	push   $0xdb
  802351:	68 79 43 80 00       	push   $0x804379
  802356:	e8 97 15 00 00       	call   8038f2 <_panic>
  80235b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802361:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802364:	89 50 04             	mov    %edx,0x4(%eax)
  802367:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80236a:	8b 40 04             	mov    0x4(%eax),%eax
  80236d:	85 c0                	test   %eax,%eax
  80236f:	74 0c                	je     80237d <alloc_block_FF+0x1e0>
  802371:	a1 30 50 80 00       	mov    0x805030,%eax
  802376:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802379:	89 10                	mov    %edx,(%eax)
  80237b:	eb 08                	jmp    802385 <alloc_block_FF+0x1e8>
  80237d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802380:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802385:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802388:	a3 30 50 80 00       	mov    %eax,0x805030
  80238d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802396:	a1 38 50 80 00       	mov    0x805038,%eax
  80239b:	40                   	inc    %eax
  80239c:	a3 38 50 80 00       	mov    %eax,0x805038
  8023a1:	eb 6e                	jmp    802411 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a7:	74 06                	je     8023af <alloc_block_FF+0x212>
  8023a9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023ad:	75 17                	jne    8023c6 <alloc_block_FF+0x229>
  8023af:	83 ec 04             	sub    $0x4,%esp
  8023b2:	68 ec 43 80 00       	push   $0x8043ec
  8023b7:	68 df 00 00 00       	push   $0xdf
  8023bc:	68 79 43 80 00       	push   $0x804379
  8023c1:	e8 2c 15 00 00       	call   8038f2 <_panic>
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 10                	mov    (%eax),%edx
  8023cb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ce:	89 10                	mov    %edx,(%eax)
  8023d0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d3:	8b 00                	mov    (%eax),%eax
  8023d5:	85 c0                	test   %eax,%eax
  8023d7:	74 0b                	je     8023e4 <alloc_block_FF+0x247>
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 00                	mov    (%eax),%eax
  8023de:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023e1:	89 50 04             	mov    %edx,0x4(%eax)
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023ea:	89 10                	mov    %edx,(%eax)
  8023ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f2:	89 50 04             	mov    %edx,0x4(%eax)
  8023f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	75 08                	jne    802406 <alloc_block_FF+0x269>
  8023fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802401:	a3 30 50 80 00       	mov    %eax,0x805030
  802406:	a1 38 50 80 00       	mov    0x805038,%eax
  80240b:	40                   	inc    %eax
  80240c:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802411:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802415:	75 17                	jne    80242e <alloc_block_FF+0x291>
  802417:	83 ec 04             	sub    $0x4,%esp
  80241a:	68 5b 43 80 00       	push   $0x80435b
  80241f:	68 e1 00 00 00       	push   $0xe1
  802424:	68 79 43 80 00       	push   $0x804379
  802429:	e8 c4 14 00 00       	call   8038f2 <_panic>
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	8b 00                	mov    (%eax),%eax
  802433:	85 c0                	test   %eax,%eax
  802435:	74 10                	je     802447 <alloc_block_FF+0x2aa>
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 00                	mov    (%eax),%eax
  80243c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243f:	8b 52 04             	mov    0x4(%edx),%edx
  802442:	89 50 04             	mov    %edx,0x4(%eax)
  802445:	eb 0b                	jmp    802452 <alloc_block_FF+0x2b5>
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 40 04             	mov    0x4(%eax),%eax
  80244d:	a3 30 50 80 00       	mov    %eax,0x805030
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 40 04             	mov    0x4(%eax),%eax
  802458:	85 c0                	test   %eax,%eax
  80245a:	74 0f                	je     80246b <alloc_block_FF+0x2ce>
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 40 04             	mov    0x4(%eax),%eax
  802462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802465:	8b 12                	mov    (%edx),%edx
  802467:	89 10                	mov    %edx,(%eax)
  802469:	eb 0a                	jmp    802475 <alloc_block_FF+0x2d8>
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802488:	a1 38 50 80 00       	mov    0x805038,%eax
  80248d:	48                   	dec    %eax
  80248e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802493:	83 ec 04             	sub    $0x4,%esp
  802496:	6a 00                	push   $0x0
  802498:	ff 75 b4             	pushl  -0x4c(%ebp)
  80249b:	ff 75 b0             	pushl  -0x50(%ebp)
  80249e:	e8 cb fc ff ff       	call   80216e <set_block_data>
  8024a3:	83 c4 10             	add    $0x10,%esp
  8024a6:	e9 95 00 00 00       	jmp    802540 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024ab:	83 ec 04             	sub    $0x4,%esp
  8024ae:	6a 01                	push   $0x1
  8024b0:	ff 75 b8             	pushl  -0x48(%ebp)
  8024b3:	ff 75 bc             	pushl  -0x44(%ebp)
  8024b6:	e8 b3 fc ff ff       	call   80216e <set_block_data>
  8024bb:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c2:	75 17                	jne    8024db <alloc_block_FF+0x33e>
  8024c4:	83 ec 04             	sub    $0x4,%esp
  8024c7:	68 5b 43 80 00       	push   $0x80435b
  8024cc:	68 e8 00 00 00       	push   $0xe8
  8024d1:	68 79 43 80 00       	push   $0x804379
  8024d6:	e8 17 14 00 00       	call   8038f2 <_panic>
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 00                	mov    (%eax),%eax
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	74 10                	je     8024f4 <alloc_block_FF+0x357>
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ec:	8b 52 04             	mov    0x4(%edx),%edx
  8024ef:	89 50 04             	mov    %edx,0x4(%eax)
  8024f2:	eb 0b                	jmp    8024ff <alloc_block_FF+0x362>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 04             	mov    0x4(%eax),%eax
  8024fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 40 04             	mov    0x4(%eax),%eax
  802505:	85 c0                	test   %eax,%eax
  802507:	74 0f                	je     802518 <alloc_block_FF+0x37b>
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 40 04             	mov    0x4(%eax),%eax
  80250f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802512:	8b 12                	mov    (%edx),%edx
  802514:	89 10                	mov    %edx,(%eax)
  802516:	eb 0a                	jmp    802522 <alloc_block_FF+0x385>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802535:	a1 38 50 80 00       	mov    0x805038,%eax
  80253a:	48                   	dec    %eax
  80253b:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802540:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802543:	e9 0f 01 00 00       	jmp    802657 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802548:	a1 34 50 80 00       	mov    0x805034,%eax
  80254d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802554:	74 07                	je     80255d <alloc_block_FF+0x3c0>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 00                	mov    (%eax),%eax
  80255b:	eb 05                	jmp    802562 <alloc_block_FF+0x3c5>
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
  802562:	a3 34 50 80 00       	mov    %eax,0x805034
  802567:	a1 34 50 80 00       	mov    0x805034,%eax
  80256c:	85 c0                	test   %eax,%eax
  80256e:	0f 85 e9 fc ff ff    	jne    80225d <alloc_block_FF+0xc0>
  802574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802578:	0f 85 df fc ff ff    	jne    80225d <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	83 c0 08             	add    $0x8,%eax
  802584:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802587:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80258e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802591:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802594:	01 d0                	add    %edx,%eax
  802596:	48                   	dec    %eax
  802597:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80259a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80259d:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a2:	f7 75 d8             	divl   -0x28(%ebp)
  8025a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025a8:	29 d0                	sub    %edx,%eax
  8025aa:	c1 e8 0c             	shr    $0xc,%eax
  8025ad:	83 ec 0c             	sub    $0xc,%esp
  8025b0:	50                   	push   %eax
  8025b1:	e8 76 ed ff ff       	call   80132c <sbrk>
  8025b6:	83 c4 10             	add    $0x10,%esp
  8025b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025bc:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025c0:	75 0a                	jne    8025cc <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c7:	e9 8b 00 00 00       	jmp    802657 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025cc:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025d9:	01 d0                	add    %edx,%eax
  8025db:	48                   	dec    %eax
  8025dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025df:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025e7:	f7 75 cc             	divl   -0x34(%ebp)
  8025ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025ed:	29 d0                	sub    %edx,%eax
  8025ef:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025f5:	01 d0                	add    %edx,%eax
  8025f7:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8025fc:	a1 40 50 80 00       	mov    0x805040,%eax
  802601:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802607:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80260e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802611:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802614:	01 d0                	add    %edx,%eax
  802616:	48                   	dec    %eax
  802617:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80261a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80261d:	ba 00 00 00 00       	mov    $0x0,%edx
  802622:	f7 75 c4             	divl   -0x3c(%ebp)
  802625:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802628:	29 d0                	sub    %edx,%eax
  80262a:	83 ec 04             	sub    $0x4,%esp
  80262d:	6a 01                	push   $0x1
  80262f:	50                   	push   %eax
  802630:	ff 75 d0             	pushl  -0x30(%ebp)
  802633:	e8 36 fb ff ff       	call   80216e <set_block_data>
  802638:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80263b:	83 ec 0c             	sub    $0xc,%esp
  80263e:	ff 75 d0             	pushl  -0x30(%ebp)
  802641:	e8 1b 0a 00 00       	call   803061 <free_block>
  802646:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802649:	83 ec 0c             	sub    $0xc,%esp
  80264c:	ff 75 08             	pushl  0x8(%ebp)
  80264f:	e8 49 fb ff ff       	call   80219d <alloc_block_FF>
  802654:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802657:	c9                   	leave  
  802658:	c3                   	ret    

00802659 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	83 e0 01             	and    $0x1,%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	74 03                	je     80266c <alloc_block_BF+0x13>
  802669:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80266c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802670:	77 07                	ja     802679 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802672:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802679:	a1 24 50 80 00       	mov    0x805024,%eax
  80267e:	85 c0                	test   %eax,%eax
  802680:	75 73                	jne    8026f5 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	83 c0 10             	add    $0x10,%eax
  802688:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80268b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802692:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802695:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802698:	01 d0                	add    %edx,%eax
  80269a:	48                   	dec    %eax
  80269b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80269e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a6:	f7 75 e0             	divl   -0x20(%ebp)
  8026a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026ac:	29 d0                	sub    %edx,%eax
  8026ae:	c1 e8 0c             	shr    $0xc,%eax
  8026b1:	83 ec 0c             	sub    $0xc,%esp
  8026b4:	50                   	push   %eax
  8026b5:	e8 72 ec ff ff       	call   80132c <sbrk>
  8026ba:	83 c4 10             	add    $0x10,%esp
  8026bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026c0:	83 ec 0c             	sub    $0xc,%esp
  8026c3:	6a 00                	push   $0x0
  8026c5:	e8 62 ec ff ff       	call   80132c <sbrk>
  8026ca:	83 c4 10             	add    $0x10,%esp
  8026cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026d3:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8026d6:	83 ec 08             	sub    $0x8,%esp
  8026d9:	50                   	push   %eax
  8026da:	ff 75 d8             	pushl  -0x28(%ebp)
  8026dd:	e8 9f f8 ff ff       	call   801f81 <initialize_dynamic_allocator>
  8026e2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026e5:	83 ec 0c             	sub    $0xc,%esp
  8026e8:	68 b7 43 80 00       	push   $0x8043b7
  8026ed:	e8 98 dc ff ff       	call   80038a <cprintf>
  8026f2:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802703:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80270a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802711:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802716:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802719:	e9 1d 01 00 00       	jmp    80283b <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802724:	83 ec 0c             	sub    $0xc,%esp
  802727:	ff 75 a8             	pushl  -0x58(%ebp)
  80272a:	e8 ee f6 ff ff       	call   801e1d <get_block_size>
  80272f:	83 c4 10             	add    $0x10,%esp
  802732:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	83 c0 08             	add    $0x8,%eax
  80273b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80273e:	0f 87 ef 00 00 00    	ja     802833 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802744:	8b 45 08             	mov    0x8(%ebp),%eax
  802747:	83 c0 18             	add    $0x18,%eax
  80274a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80274d:	77 1d                	ja     80276c <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80274f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802752:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802755:	0f 86 d8 00 00 00    	jbe    802833 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80275b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80275e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802761:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802764:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802767:	e9 c7 00 00 00       	jmp    802833 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80276c:	8b 45 08             	mov    0x8(%ebp),%eax
  80276f:	83 c0 08             	add    $0x8,%eax
  802772:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802775:	0f 85 9d 00 00 00    	jne    802818 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80277b:	83 ec 04             	sub    $0x4,%esp
  80277e:	6a 01                	push   $0x1
  802780:	ff 75 a4             	pushl  -0x5c(%ebp)
  802783:	ff 75 a8             	pushl  -0x58(%ebp)
  802786:	e8 e3 f9 ff ff       	call   80216e <set_block_data>
  80278b:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80278e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802792:	75 17                	jne    8027ab <alloc_block_BF+0x152>
  802794:	83 ec 04             	sub    $0x4,%esp
  802797:	68 5b 43 80 00       	push   $0x80435b
  80279c:	68 2c 01 00 00       	push   $0x12c
  8027a1:	68 79 43 80 00       	push   $0x804379
  8027a6:	e8 47 11 00 00       	call   8038f2 <_panic>
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	74 10                	je     8027c4 <alloc_block_BF+0x16b>
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 00                	mov    (%eax),%eax
  8027b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bc:	8b 52 04             	mov    0x4(%edx),%edx
  8027bf:	89 50 04             	mov    %edx,0x4(%eax)
  8027c2:	eb 0b                	jmp    8027cf <alloc_block_BF+0x176>
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	8b 40 04             	mov    0x4(%eax),%eax
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	74 0f                	je     8027e8 <alloc_block_BF+0x18f>
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 40 04             	mov    0x4(%eax),%eax
  8027df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e2:	8b 12                	mov    (%edx),%edx
  8027e4:	89 10                	mov    %edx,(%eax)
  8027e6:	eb 0a                	jmp    8027f2 <alloc_block_BF+0x199>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802805:	a1 38 50 80 00       	mov    0x805038,%eax
  80280a:	48                   	dec    %eax
  80280b:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802810:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802813:	e9 24 04 00 00       	jmp    802c3c <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80281e:	76 13                	jbe    802833 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802820:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802827:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80282a:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80282d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802830:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802833:	a1 34 50 80 00       	mov    0x805034,%eax
  802838:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283f:	74 07                	je     802848 <alloc_block_BF+0x1ef>
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 00                	mov    (%eax),%eax
  802846:	eb 05                	jmp    80284d <alloc_block_BF+0x1f4>
  802848:	b8 00 00 00 00       	mov    $0x0,%eax
  80284d:	a3 34 50 80 00       	mov    %eax,0x805034
  802852:	a1 34 50 80 00       	mov    0x805034,%eax
  802857:	85 c0                	test   %eax,%eax
  802859:	0f 85 bf fe ff ff    	jne    80271e <alloc_block_BF+0xc5>
  80285f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802863:	0f 85 b5 fe ff ff    	jne    80271e <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802869:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80286d:	0f 84 26 02 00 00    	je     802a99 <alloc_block_BF+0x440>
  802873:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802877:	0f 85 1c 02 00 00    	jne    802a99 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80287d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802880:	2b 45 08             	sub    0x8(%ebp),%eax
  802883:	83 e8 08             	sub    $0x8,%eax
  802886:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	8d 50 08             	lea    0x8(%eax),%edx
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	01 d0                	add    %edx,%eax
  802894:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	83 c0 08             	add    $0x8,%eax
  80289d:	83 ec 04             	sub    $0x4,%esp
  8028a0:	6a 01                	push   $0x1
  8028a2:	50                   	push   %eax
  8028a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8028a6:	e8 c3 f8 ff ff       	call   80216e <set_block_data>
  8028ab:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	8b 40 04             	mov    0x4(%eax),%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	75 68                	jne    802920 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028b8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028bc:	75 17                	jne    8028d5 <alloc_block_BF+0x27c>
  8028be:	83 ec 04             	sub    $0x4,%esp
  8028c1:	68 94 43 80 00       	push   $0x804394
  8028c6:	68 45 01 00 00       	push   $0x145
  8028cb:	68 79 43 80 00       	push   $0x804379
  8028d0:	e8 1d 10 00 00       	call   8038f2 <_panic>
  8028d5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028de:	89 10                	mov    %edx,(%eax)
  8028e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	85 c0                	test   %eax,%eax
  8028e7:	74 0d                	je     8028f6 <alloc_block_BF+0x29d>
  8028e9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028ee:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028f1:	89 50 04             	mov    %edx,0x4(%eax)
  8028f4:	eb 08                	jmp    8028fe <alloc_block_BF+0x2a5>
  8028f6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8028fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802901:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802906:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802909:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802910:	a1 38 50 80 00       	mov    0x805038,%eax
  802915:	40                   	inc    %eax
  802916:	a3 38 50 80 00       	mov    %eax,0x805038
  80291b:	e9 dc 00 00 00       	jmp    8029fc <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	75 65                	jne    80298e <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802929:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80292d:	75 17                	jne    802946 <alloc_block_BF+0x2ed>
  80292f:	83 ec 04             	sub    $0x4,%esp
  802932:	68 c8 43 80 00       	push   $0x8043c8
  802937:	68 4a 01 00 00       	push   $0x14a
  80293c:	68 79 43 80 00       	push   $0x804379
  802941:	e8 ac 0f 00 00       	call   8038f2 <_panic>
  802946:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80294c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80294f:	89 50 04             	mov    %edx,0x4(%eax)
  802952:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802955:	8b 40 04             	mov    0x4(%eax),%eax
  802958:	85 c0                	test   %eax,%eax
  80295a:	74 0c                	je     802968 <alloc_block_BF+0x30f>
  80295c:	a1 30 50 80 00       	mov    0x805030,%eax
  802961:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802964:	89 10                	mov    %edx,(%eax)
  802966:	eb 08                	jmp    802970 <alloc_block_BF+0x317>
  802968:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80296b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802970:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802973:	a3 30 50 80 00       	mov    %eax,0x805030
  802978:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802981:	a1 38 50 80 00       	mov    0x805038,%eax
  802986:	40                   	inc    %eax
  802987:	a3 38 50 80 00       	mov    %eax,0x805038
  80298c:	eb 6e                	jmp    8029fc <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80298e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802992:	74 06                	je     80299a <alloc_block_BF+0x341>
  802994:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802998:	75 17                	jne    8029b1 <alloc_block_BF+0x358>
  80299a:	83 ec 04             	sub    $0x4,%esp
  80299d:	68 ec 43 80 00       	push   $0x8043ec
  8029a2:	68 4f 01 00 00       	push   $0x14f
  8029a7:	68 79 43 80 00       	push   $0x804379
  8029ac:	e8 41 0f 00 00       	call   8038f2 <_panic>
  8029b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b4:	8b 10                	mov    (%eax),%edx
  8029b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b9:	89 10                	mov    %edx,(%eax)
  8029bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029be:	8b 00                	mov    (%eax),%eax
  8029c0:	85 c0                	test   %eax,%eax
  8029c2:	74 0b                	je     8029cf <alloc_block_BF+0x376>
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029cc:	89 50 04             	mov    %edx,0x4(%eax)
  8029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029d5:	89 10                	mov    %edx,(%eax)
  8029d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029dd:	89 50 04             	mov    %edx,0x4(%eax)
  8029e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	75 08                	jne    8029f1 <alloc_block_BF+0x398>
  8029e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ec:	a3 30 50 80 00       	mov    %eax,0x805030
  8029f1:	a1 38 50 80 00       	mov    0x805038,%eax
  8029f6:	40                   	inc    %eax
  8029f7:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a00:	75 17                	jne    802a19 <alloc_block_BF+0x3c0>
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 5b 43 80 00       	push   $0x80435b
  802a0a:	68 51 01 00 00       	push   $0x151
  802a0f:	68 79 43 80 00       	push   $0x804379
  802a14:	e8 d9 0e 00 00       	call   8038f2 <_panic>
  802a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1c:	8b 00                	mov    (%eax),%eax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 10                	je     802a32 <alloc_block_BF+0x3d9>
  802a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a2a:	8b 52 04             	mov    0x4(%edx),%edx
  802a2d:	89 50 04             	mov    %edx,0x4(%eax)
  802a30:	eb 0b                	jmp    802a3d <alloc_block_BF+0x3e4>
  802a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a35:	8b 40 04             	mov    0x4(%eax),%eax
  802a38:	a3 30 50 80 00       	mov    %eax,0x805030
  802a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a40:	8b 40 04             	mov    0x4(%eax),%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 0f                	je     802a56 <alloc_block_BF+0x3fd>
  802a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4a:	8b 40 04             	mov    0x4(%eax),%eax
  802a4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a50:	8b 12                	mov    (%edx),%edx
  802a52:	89 10                	mov    %edx,(%eax)
  802a54:	eb 0a                	jmp    802a60 <alloc_block_BF+0x407>
  802a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a59:	8b 00                	mov    (%eax),%eax
  802a5b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a73:	a1 38 50 80 00       	mov    0x805038,%eax
  802a78:	48                   	dec    %eax
  802a79:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a7e:	83 ec 04             	sub    $0x4,%esp
  802a81:	6a 00                	push   $0x0
  802a83:	ff 75 d0             	pushl  -0x30(%ebp)
  802a86:	ff 75 cc             	pushl  -0x34(%ebp)
  802a89:	e8 e0 f6 ff ff       	call   80216e <set_block_data>
  802a8e:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a94:	e9 a3 01 00 00       	jmp    802c3c <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a99:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a9d:	0f 85 9d 00 00 00    	jne    802b40 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802aa3:	83 ec 04             	sub    $0x4,%esp
  802aa6:	6a 01                	push   $0x1
  802aa8:	ff 75 ec             	pushl  -0x14(%ebp)
  802aab:	ff 75 f0             	pushl  -0x10(%ebp)
  802aae:	e8 bb f6 ff ff       	call   80216e <set_block_data>
  802ab3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802ab6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aba:	75 17                	jne    802ad3 <alloc_block_BF+0x47a>
  802abc:	83 ec 04             	sub    $0x4,%esp
  802abf:	68 5b 43 80 00       	push   $0x80435b
  802ac4:	68 58 01 00 00       	push   $0x158
  802ac9:	68 79 43 80 00       	push   $0x804379
  802ace:	e8 1f 0e 00 00       	call   8038f2 <_panic>
  802ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad6:	8b 00                	mov    (%eax),%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	74 10                	je     802aec <alloc_block_BF+0x493>
  802adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae4:	8b 52 04             	mov    0x4(%edx),%edx
  802ae7:	89 50 04             	mov    %edx,0x4(%eax)
  802aea:	eb 0b                	jmp    802af7 <alloc_block_BF+0x49e>
  802aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aef:	8b 40 04             	mov    0x4(%eax),%eax
  802af2:	a3 30 50 80 00       	mov    %eax,0x805030
  802af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afa:	8b 40 04             	mov    0x4(%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 0f                	je     802b10 <alloc_block_BF+0x4b7>
  802b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0a:	8b 12                	mov    (%edx),%edx
  802b0c:	89 10                	mov    %edx,(%eax)
  802b0e:	eb 0a                	jmp    802b1a <alloc_block_BF+0x4c1>
  802b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2d:	a1 38 50 80 00       	mov    0x805038,%eax
  802b32:	48                   	dec    %eax
  802b33:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3b:	e9 fc 00 00 00       	jmp    802c3c <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	83 c0 08             	add    $0x8,%eax
  802b46:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b49:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b50:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b53:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b56:	01 d0                	add    %edx,%eax
  802b58:	48                   	dec    %eax
  802b59:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b5c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b5f:	ba 00 00 00 00       	mov    $0x0,%edx
  802b64:	f7 75 c4             	divl   -0x3c(%ebp)
  802b67:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b6a:	29 d0                	sub    %edx,%eax
  802b6c:	c1 e8 0c             	shr    $0xc,%eax
  802b6f:	83 ec 0c             	sub    $0xc,%esp
  802b72:	50                   	push   %eax
  802b73:	e8 b4 e7 ff ff       	call   80132c <sbrk>
  802b78:	83 c4 10             	add    $0x10,%esp
  802b7b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b7e:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b82:	75 0a                	jne    802b8e <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b84:	b8 00 00 00 00       	mov    $0x0,%eax
  802b89:	e9 ae 00 00 00       	jmp    802c3c <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b8e:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b95:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b98:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b9b:	01 d0                	add    %edx,%eax
  802b9d:	48                   	dec    %eax
  802b9e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ba1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ba4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba9:	f7 75 b8             	divl   -0x48(%ebp)
  802bac:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802baf:	29 d0                	sub    %edx,%eax
  802bb1:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bb4:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bb7:	01 d0                	add    %edx,%eax
  802bb9:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802bbe:	a1 40 50 80 00       	mov    0x805040,%eax
  802bc3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802bc9:	83 ec 0c             	sub    $0xc,%esp
  802bcc:	68 20 44 80 00       	push   $0x804420
  802bd1:	e8 b4 d7 ff ff       	call   80038a <cprintf>
  802bd6:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802bd9:	83 ec 08             	sub    $0x8,%esp
  802bdc:	ff 75 bc             	pushl  -0x44(%ebp)
  802bdf:	68 25 44 80 00       	push   $0x804425
  802be4:	e8 a1 d7 ff ff       	call   80038a <cprintf>
  802be9:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bec:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802bf3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bf6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bf9:	01 d0                	add    %edx,%eax
  802bfb:	48                   	dec    %eax
  802bfc:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802bff:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c02:	ba 00 00 00 00       	mov    $0x0,%edx
  802c07:	f7 75 b0             	divl   -0x50(%ebp)
  802c0a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c0d:	29 d0                	sub    %edx,%eax
  802c0f:	83 ec 04             	sub    $0x4,%esp
  802c12:	6a 01                	push   $0x1
  802c14:	50                   	push   %eax
  802c15:	ff 75 bc             	pushl  -0x44(%ebp)
  802c18:	e8 51 f5 ff ff       	call   80216e <set_block_data>
  802c1d:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c20:	83 ec 0c             	sub    $0xc,%esp
  802c23:	ff 75 bc             	pushl  -0x44(%ebp)
  802c26:	e8 36 04 00 00       	call   803061 <free_block>
  802c2b:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c2e:	83 ec 0c             	sub    $0xc,%esp
  802c31:	ff 75 08             	pushl  0x8(%ebp)
  802c34:	e8 20 fa ff ff       	call   802659 <alloc_block_BF>
  802c39:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c3c:	c9                   	leave  
  802c3d:	c3                   	ret    

00802c3e <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c3e:	55                   	push   %ebp
  802c3f:	89 e5                	mov    %esp,%ebp
  802c41:	53                   	push   %ebx
  802c42:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c57:	74 1e                	je     802c77 <merging+0x39>
  802c59:	ff 75 08             	pushl  0x8(%ebp)
  802c5c:	e8 bc f1 ff ff       	call   801e1d <get_block_size>
  802c61:	83 c4 04             	add    $0x4,%esp
  802c64:	89 c2                	mov    %eax,%edx
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	01 d0                	add    %edx,%eax
  802c6b:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c6e:	75 07                	jne    802c77 <merging+0x39>
		prev_is_free = 1;
  802c70:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c7b:	74 1e                	je     802c9b <merging+0x5d>
  802c7d:	ff 75 10             	pushl  0x10(%ebp)
  802c80:	e8 98 f1 ff ff       	call   801e1d <get_block_size>
  802c85:	83 c4 04             	add    $0x4,%esp
  802c88:	89 c2                	mov    %eax,%edx
  802c8a:	8b 45 10             	mov    0x10(%ebp),%eax
  802c8d:	01 d0                	add    %edx,%eax
  802c8f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c92:	75 07                	jne    802c9b <merging+0x5d>
		next_is_free = 1;
  802c94:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9f:	0f 84 cc 00 00 00    	je     802d71 <merging+0x133>
  802ca5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca9:	0f 84 c2 00 00 00    	je     802d71 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802caf:	ff 75 08             	pushl  0x8(%ebp)
  802cb2:	e8 66 f1 ff ff       	call   801e1d <get_block_size>
  802cb7:	83 c4 04             	add    $0x4,%esp
  802cba:	89 c3                	mov    %eax,%ebx
  802cbc:	ff 75 10             	pushl  0x10(%ebp)
  802cbf:	e8 59 f1 ff ff       	call   801e1d <get_block_size>
  802cc4:	83 c4 04             	add    $0x4,%esp
  802cc7:	01 c3                	add    %eax,%ebx
  802cc9:	ff 75 0c             	pushl  0xc(%ebp)
  802ccc:	e8 4c f1 ff ff       	call   801e1d <get_block_size>
  802cd1:	83 c4 04             	add    $0x4,%esp
  802cd4:	01 d8                	add    %ebx,%eax
  802cd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cd9:	6a 00                	push   $0x0
  802cdb:	ff 75 ec             	pushl  -0x14(%ebp)
  802cde:	ff 75 08             	pushl  0x8(%ebp)
  802ce1:	e8 88 f4 ff ff       	call   80216e <set_block_data>
  802ce6:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ce9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ced:	75 17                	jne    802d06 <merging+0xc8>
  802cef:	83 ec 04             	sub    $0x4,%esp
  802cf2:	68 5b 43 80 00       	push   $0x80435b
  802cf7:	68 7d 01 00 00       	push   $0x17d
  802cfc:	68 79 43 80 00       	push   $0x804379
  802d01:	e8 ec 0b 00 00       	call   8038f2 <_panic>
  802d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d09:	8b 00                	mov    (%eax),%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	74 10                	je     802d1f <merging+0xe1>
  802d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d12:	8b 00                	mov    (%eax),%eax
  802d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d17:	8b 52 04             	mov    0x4(%edx),%edx
  802d1a:	89 50 04             	mov    %edx,0x4(%eax)
  802d1d:	eb 0b                	jmp    802d2a <merging+0xec>
  802d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d22:	8b 40 04             	mov    0x4(%eax),%eax
  802d25:	a3 30 50 80 00       	mov    %eax,0x805030
  802d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2d:	8b 40 04             	mov    0x4(%eax),%eax
  802d30:	85 c0                	test   %eax,%eax
  802d32:	74 0f                	je     802d43 <merging+0x105>
  802d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d37:	8b 40 04             	mov    0x4(%eax),%eax
  802d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3d:	8b 12                	mov    (%edx),%edx
  802d3f:	89 10                	mov    %edx,(%eax)
  802d41:	eb 0a                	jmp    802d4d <merging+0x10f>
  802d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d46:	8b 00                	mov    (%eax),%eax
  802d48:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d60:	a1 38 50 80 00       	mov    0x805038,%eax
  802d65:	48                   	dec    %eax
  802d66:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d6b:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d6c:	e9 ea 02 00 00       	jmp    80305b <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d75:	74 3b                	je     802db2 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d77:	83 ec 0c             	sub    $0xc,%esp
  802d7a:	ff 75 08             	pushl  0x8(%ebp)
  802d7d:	e8 9b f0 ff ff       	call   801e1d <get_block_size>
  802d82:	83 c4 10             	add    $0x10,%esp
  802d85:	89 c3                	mov    %eax,%ebx
  802d87:	83 ec 0c             	sub    $0xc,%esp
  802d8a:	ff 75 10             	pushl  0x10(%ebp)
  802d8d:	e8 8b f0 ff ff       	call   801e1d <get_block_size>
  802d92:	83 c4 10             	add    $0x10,%esp
  802d95:	01 d8                	add    %ebx,%eax
  802d97:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d9a:	83 ec 04             	sub    $0x4,%esp
  802d9d:	6a 00                	push   $0x0
  802d9f:	ff 75 e8             	pushl  -0x18(%ebp)
  802da2:	ff 75 08             	pushl  0x8(%ebp)
  802da5:	e8 c4 f3 ff ff       	call   80216e <set_block_data>
  802daa:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dad:	e9 a9 02 00 00       	jmp    80305b <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802db2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db6:	0f 84 2d 01 00 00    	je     802ee9 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802dbc:	83 ec 0c             	sub    $0xc,%esp
  802dbf:	ff 75 10             	pushl  0x10(%ebp)
  802dc2:	e8 56 f0 ff ff       	call   801e1d <get_block_size>
  802dc7:	83 c4 10             	add    $0x10,%esp
  802dca:	89 c3                	mov    %eax,%ebx
  802dcc:	83 ec 0c             	sub    $0xc,%esp
  802dcf:	ff 75 0c             	pushl  0xc(%ebp)
  802dd2:	e8 46 f0 ff ff       	call   801e1d <get_block_size>
  802dd7:	83 c4 10             	add    $0x10,%esp
  802dda:	01 d8                	add    %ebx,%eax
  802ddc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ddf:	83 ec 04             	sub    $0x4,%esp
  802de2:	6a 00                	push   $0x0
  802de4:	ff 75 e4             	pushl  -0x1c(%ebp)
  802de7:	ff 75 10             	pushl  0x10(%ebp)
  802dea:	e8 7f f3 ff ff       	call   80216e <set_block_data>
  802def:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802df2:	8b 45 10             	mov    0x10(%ebp),%eax
  802df5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802df8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dfc:	74 06                	je     802e04 <merging+0x1c6>
  802dfe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e02:	75 17                	jne    802e1b <merging+0x1dd>
  802e04:	83 ec 04             	sub    $0x4,%esp
  802e07:	68 34 44 80 00       	push   $0x804434
  802e0c:	68 8d 01 00 00       	push   $0x18d
  802e11:	68 79 43 80 00       	push   $0x804379
  802e16:	e8 d7 0a 00 00       	call   8038f2 <_panic>
  802e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1e:	8b 50 04             	mov    0x4(%eax),%edx
  802e21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e24:	89 50 04             	mov    %edx,0x4(%eax)
  802e27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e2d:	89 10                	mov    %edx,(%eax)
  802e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e32:	8b 40 04             	mov    0x4(%eax),%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	74 0d                	je     802e46 <merging+0x208>
  802e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3c:	8b 40 04             	mov    0x4(%eax),%eax
  802e3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e42:	89 10                	mov    %edx,(%eax)
  802e44:	eb 08                	jmp    802e4e <merging+0x210>
  802e46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e49:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e51:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e54:	89 50 04             	mov    %edx,0x4(%eax)
  802e57:	a1 38 50 80 00       	mov    0x805038,%eax
  802e5c:	40                   	inc    %eax
  802e5d:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e66:	75 17                	jne    802e7f <merging+0x241>
  802e68:	83 ec 04             	sub    $0x4,%esp
  802e6b:	68 5b 43 80 00       	push   $0x80435b
  802e70:	68 8e 01 00 00       	push   $0x18e
  802e75:	68 79 43 80 00       	push   $0x804379
  802e7a:	e8 73 0a 00 00       	call   8038f2 <_panic>
  802e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e82:	8b 00                	mov    (%eax),%eax
  802e84:	85 c0                	test   %eax,%eax
  802e86:	74 10                	je     802e98 <merging+0x25a>
  802e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e90:	8b 52 04             	mov    0x4(%edx),%edx
  802e93:	89 50 04             	mov    %edx,0x4(%eax)
  802e96:	eb 0b                	jmp    802ea3 <merging+0x265>
  802e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9b:	8b 40 04             	mov    0x4(%eax),%eax
  802e9e:	a3 30 50 80 00       	mov    %eax,0x805030
  802ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea6:	8b 40 04             	mov    0x4(%eax),%eax
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	74 0f                	je     802ebc <merging+0x27e>
  802ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb0:	8b 40 04             	mov    0x4(%eax),%eax
  802eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb6:	8b 12                	mov    (%edx),%edx
  802eb8:	89 10                	mov    %edx,(%eax)
  802eba:	eb 0a                	jmp    802ec6 <merging+0x288>
  802ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ebf:	8b 00                	mov    (%eax),%eax
  802ec1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed9:	a1 38 50 80 00       	mov    0x805038,%eax
  802ede:	48                   	dec    %eax
  802edf:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ee4:	e9 72 01 00 00       	jmp    80305b <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  802eec:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802eef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef3:	74 79                	je     802f6e <merging+0x330>
  802ef5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ef9:	74 73                	je     802f6e <merging+0x330>
  802efb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eff:	74 06                	je     802f07 <merging+0x2c9>
  802f01:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f05:	75 17                	jne    802f1e <merging+0x2e0>
  802f07:	83 ec 04             	sub    $0x4,%esp
  802f0a:	68 ec 43 80 00       	push   $0x8043ec
  802f0f:	68 94 01 00 00       	push   $0x194
  802f14:	68 79 43 80 00       	push   $0x804379
  802f19:	e8 d4 09 00 00       	call   8038f2 <_panic>
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	8b 10                	mov    (%eax),%edx
  802f23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f26:	89 10                	mov    %edx,(%eax)
  802f28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f2b:	8b 00                	mov    (%eax),%eax
  802f2d:	85 c0                	test   %eax,%eax
  802f2f:	74 0b                	je     802f3c <merging+0x2fe>
  802f31:	8b 45 08             	mov    0x8(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f39:	89 50 04             	mov    %edx,0x4(%eax)
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f42:	89 10                	mov    %edx,(%eax)
  802f44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f47:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4a:	89 50 04             	mov    %edx,0x4(%eax)
  802f4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	75 08                	jne    802f5e <merging+0x320>
  802f56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f59:	a3 30 50 80 00       	mov    %eax,0x805030
  802f5e:	a1 38 50 80 00       	mov    0x805038,%eax
  802f63:	40                   	inc    %eax
  802f64:	a3 38 50 80 00       	mov    %eax,0x805038
  802f69:	e9 ce 00 00 00       	jmp    80303c <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f72:	74 65                	je     802fd9 <merging+0x39b>
  802f74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f78:	75 17                	jne    802f91 <merging+0x353>
  802f7a:	83 ec 04             	sub    $0x4,%esp
  802f7d:	68 c8 43 80 00       	push   $0x8043c8
  802f82:	68 95 01 00 00       	push   $0x195
  802f87:	68 79 43 80 00       	push   $0x804379
  802f8c:	e8 61 09 00 00       	call   8038f2 <_panic>
  802f91:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9a:	89 50 04             	mov    %edx,0x4(%eax)
  802f9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	74 0c                	je     802fb3 <merging+0x375>
  802fa7:	a1 30 50 80 00       	mov    0x805030,%eax
  802fac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802faf:	89 10                	mov    %edx,(%eax)
  802fb1:	eb 08                	jmp    802fbb <merging+0x37d>
  802fb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fbb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fbe:	a3 30 50 80 00       	mov    %eax,0x805030
  802fc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fcc:	a1 38 50 80 00       	mov    0x805038,%eax
  802fd1:	40                   	inc    %eax
  802fd2:	a3 38 50 80 00       	mov    %eax,0x805038
  802fd7:	eb 63                	jmp    80303c <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fd9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fdd:	75 17                	jne    802ff6 <merging+0x3b8>
  802fdf:	83 ec 04             	sub    $0x4,%esp
  802fe2:	68 94 43 80 00       	push   $0x804394
  802fe7:	68 98 01 00 00       	push   $0x198
  802fec:	68 79 43 80 00       	push   $0x804379
  802ff1:	e8 fc 08 00 00       	call   8038f2 <_panic>
  802ff6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ffc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fff:	89 10                	mov    %edx,(%eax)
  803001:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803004:	8b 00                	mov    (%eax),%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	74 0d                	je     803017 <merging+0x3d9>
  80300a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80300f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803012:	89 50 04             	mov    %edx,0x4(%eax)
  803015:	eb 08                	jmp    80301f <merging+0x3e1>
  803017:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301a:	a3 30 50 80 00       	mov    %eax,0x805030
  80301f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803022:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803027:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80302a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803031:	a1 38 50 80 00       	mov    0x805038,%eax
  803036:	40                   	inc    %eax
  803037:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80303c:	83 ec 0c             	sub    $0xc,%esp
  80303f:	ff 75 10             	pushl  0x10(%ebp)
  803042:	e8 d6 ed ff ff       	call   801e1d <get_block_size>
  803047:	83 c4 10             	add    $0x10,%esp
  80304a:	83 ec 04             	sub    $0x4,%esp
  80304d:	6a 00                	push   $0x0
  80304f:	50                   	push   %eax
  803050:	ff 75 10             	pushl  0x10(%ebp)
  803053:	e8 16 f1 ff ff       	call   80216e <set_block_data>
  803058:	83 c4 10             	add    $0x10,%esp
	}
}
  80305b:	90                   	nop
  80305c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80305f:	c9                   	leave  
  803060:	c3                   	ret    

00803061 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803061:	55                   	push   %ebp
  803062:	89 e5                	mov    %esp,%ebp
  803064:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803067:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80306c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80306f:	a1 30 50 80 00       	mov    0x805030,%eax
  803074:	3b 45 08             	cmp    0x8(%ebp),%eax
  803077:	73 1b                	jae    803094 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803079:	a1 30 50 80 00       	mov    0x805030,%eax
  80307e:	83 ec 04             	sub    $0x4,%esp
  803081:	ff 75 08             	pushl  0x8(%ebp)
  803084:	6a 00                	push   $0x0
  803086:	50                   	push   %eax
  803087:	e8 b2 fb ff ff       	call   802c3e <merging>
  80308c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80308f:	e9 8b 00 00 00       	jmp    80311f <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  803094:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803099:	3b 45 08             	cmp    0x8(%ebp),%eax
  80309c:	76 18                	jbe    8030b6 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  80309e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030a3:	83 ec 04             	sub    $0x4,%esp
  8030a6:	ff 75 08             	pushl  0x8(%ebp)
  8030a9:	50                   	push   %eax
  8030aa:	6a 00                	push   $0x0
  8030ac:	e8 8d fb ff ff       	call   802c3e <merging>
  8030b1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030b4:	eb 69                	jmp    80311f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030b6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030be:	eb 39                	jmp    8030f9 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c6:	73 29                	jae    8030f1 <free_block+0x90>
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	8b 00                	mov    (%eax),%eax
  8030cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d0:	76 1f                	jbe    8030f1 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d5:	8b 00                	mov    (%eax),%eax
  8030d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030da:	83 ec 04             	sub    $0x4,%esp
  8030dd:	ff 75 08             	pushl  0x8(%ebp)
  8030e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8030e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8030e6:	e8 53 fb ff ff       	call   802c3e <merging>
  8030eb:	83 c4 10             	add    $0x10,%esp
			break;
  8030ee:	90                   	nop
		}
	}
}
  8030ef:	eb 2e                	jmp    80311f <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030f1:	a1 34 50 80 00       	mov    0x805034,%eax
  8030f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030fd:	74 07                	je     803106 <free_block+0xa5>
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	8b 00                	mov    (%eax),%eax
  803104:	eb 05                	jmp    80310b <free_block+0xaa>
  803106:	b8 00 00 00 00       	mov    $0x0,%eax
  80310b:	a3 34 50 80 00       	mov    %eax,0x805034
  803110:	a1 34 50 80 00       	mov    0x805034,%eax
  803115:	85 c0                	test   %eax,%eax
  803117:	75 a7                	jne    8030c0 <free_block+0x5f>
  803119:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80311d:	75 a1                	jne    8030c0 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80311f:	90                   	nop
  803120:	c9                   	leave  
  803121:	c3                   	ret    

00803122 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803122:	55                   	push   %ebp
  803123:	89 e5                	mov    %esp,%ebp
  803125:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803128:	ff 75 08             	pushl  0x8(%ebp)
  80312b:	e8 ed ec ff ff       	call   801e1d <get_block_size>
  803130:	83 c4 04             	add    $0x4,%esp
  803133:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803136:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80313d:	eb 17                	jmp    803156 <copy_data+0x34>
  80313f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803142:	8b 45 0c             	mov    0xc(%ebp),%eax
  803145:	01 c2                	add    %eax,%edx
  803147:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	01 c8                	add    %ecx,%eax
  80314f:	8a 00                	mov    (%eax),%al
  803151:	88 02                	mov    %al,(%edx)
  803153:	ff 45 fc             	incl   -0x4(%ebp)
  803156:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803159:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80315c:	72 e1                	jb     80313f <copy_data+0x1d>
}
  80315e:	90                   	nop
  80315f:	c9                   	leave  
  803160:	c3                   	ret    

00803161 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803161:	55                   	push   %ebp
  803162:	89 e5                	mov    %esp,%ebp
  803164:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803167:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316b:	75 23                	jne    803190 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80316d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803171:	74 13                	je     803186 <realloc_block_FF+0x25>
  803173:	83 ec 0c             	sub    $0xc,%esp
  803176:	ff 75 0c             	pushl  0xc(%ebp)
  803179:	e8 1f f0 ff ff       	call   80219d <alloc_block_FF>
  80317e:	83 c4 10             	add    $0x10,%esp
  803181:	e9 f4 06 00 00       	jmp    80387a <realloc_block_FF+0x719>
		return NULL;
  803186:	b8 00 00 00 00       	mov    $0x0,%eax
  80318b:	e9 ea 06 00 00       	jmp    80387a <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803190:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803194:	75 18                	jne    8031ae <realloc_block_FF+0x4d>
	{
		free_block(va);
  803196:	83 ec 0c             	sub    $0xc,%esp
  803199:	ff 75 08             	pushl  0x8(%ebp)
  80319c:	e8 c0 fe ff ff       	call   803061 <free_block>
  8031a1:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a9:	e9 cc 06 00 00       	jmp    80387a <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8031ae:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031b2:	77 07                	ja     8031bb <realloc_block_FF+0x5a>
  8031b4:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031be:	83 e0 01             	and    $0x1,%eax
  8031c1:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c7:	83 c0 08             	add    $0x8,%eax
  8031ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031cd:	83 ec 0c             	sub    $0xc,%esp
  8031d0:	ff 75 08             	pushl  0x8(%ebp)
  8031d3:	e8 45 ec ff ff       	call   801e1d <get_block_size>
  8031d8:	83 c4 10             	add    $0x10,%esp
  8031db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e1:	83 e8 08             	sub    $0x8,%eax
  8031e4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	83 e8 04             	sub    $0x4,%eax
  8031ed:	8b 00                	mov    (%eax),%eax
  8031ef:	83 e0 fe             	and    $0xfffffffe,%eax
  8031f2:	89 c2                	mov    %eax,%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	01 d0                	add    %edx,%eax
  8031f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031fc:	83 ec 0c             	sub    $0xc,%esp
  8031ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  803202:	e8 16 ec ff ff       	call   801e1d <get_block_size>
  803207:	83 c4 10             	add    $0x10,%esp
  80320a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80320d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803210:	83 e8 08             	sub    $0x8,%eax
  803213:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803216:	8b 45 0c             	mov    0xc(%ebp),%eax
  803219:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80321c:	75 08                	jne    803226 <realloc_block_FF+0xc5>
	{
		 return va;
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	e9 54 06 00 00       	jmp    80387a <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803226:	8b 45 0c             	mov    0xc(%ebp),%eax
  803229:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80322c:	0f 83 e5 03 00 00    	jae    803617 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	2b 45 0c             	sub    0xc(%ebp),%eax
  803238:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80323b:	83 ec 0c             	sub    $0xc,%esp
  80323e:	ff 75 e4             	pushl  -0x1c(%ebp)
  803241:	e8 f0 eb ff ff       	call   801e36 <is_free_block>
  803246:	83 c4 10             	add    $0x10,%esp
  803249:	84 c0                	test   %al,%al
  80324b:	0f 84 3b 01 00 00    	je     80338c <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803251:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803254:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803257:	01 d0                	add    %edx,%eax
  803259:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80325c:	83 ec 04             	sub    $0x4,%esp
  80325f:	6a 01                	push   $0x1
  803261:	ff 75 f0             	pushl  -0x10(%ebp)
  803264:	ff 75 08             	pushl  0x8(%ebp)
  803267:	e8 02 ef ff ff       	call   80216e <set_block_data>
  80326c:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80326f:	8b 45 08             	mov    0x8(%ebp),%eax
  803272:	83 e8 04             	sub    $0x4,%eax
  803275:	8b 00                	mov    (%eax),%eax
  803277:	83 e0 fe             	and    $0xfffffffe,%eax
  80327a:	89 c2                	mov    %eax,%edx
  80327c:	8b 45 08             	mov    0x8(%ebp),%eax
  80327f:	01 d0                	add    %edx,%eax
  803281:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803284:	83 ec 04             	sub    $0x4,%esp
  803287:	6a 00                	push   $0x0
  803289:	ff 75 cc             	pushl  -0x34(%ebp)
  80328c:	ff 75 c8             	pushl  -0x38(%ebp)
  80328f:	e8 da ee ff ff       	call   80216e <set_block_data>
  803294:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803297:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80329b:	74 06                	je     8032a3 <realloc_block_FF+0x142>
  80329d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032a1:	75 17                	jne    8032ba <realloc_block_FF+0x159>
  8032a3:	83 ec 04             	sub    $0x4,%esp
  8032a6:	68 ec 43 80 00       	push   $0x8043ec
  8032ab:	68 f6 01 00 00       	push   $0x1f6
  8032b0:	68 79 43 80 00       	push   $0x804379
  8032b5:	e8 38 06 00 00       	call   8038f2 <_panic>
  8032ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bd:	8b 10                	mov    (%eax),%edx
  8032bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032c2:	89 10                	mov    %edx,(%eax)
  8032c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	85 c0                	test   %eax,%eax
  8032cb:	74 0b                	je     8032d8 <realloc_block_FF+0x177>
  8032cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d0:	8b 00                	mov    (%eax),%eax
  8032d2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032d5:	89 50 04             	mov    %edx,0x4(%eax)
  8032d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032db:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032de:	89 10                	mov    %edx,(%eax)
  8032e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032e6:	89 50 04             	mov    %edx,0x4(%eax)
  8032e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ec:	8b 00                	mov    (%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	75 08                	jne    8032fa <realloc_block_FF+0x199>
  8032f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8032fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8032ff:	40                   	inc    %eax
  803300:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803305:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803309:	75 17                	jne    803322 <realloc_block_FF+0x1c1>
  80330b:	83 ec 04             	sub    $0x4,%esp
  80330e:	68 5b 43 80 00       	push   $0x80435b
  803313:	68 f7 01 00 00       	push   $0x1f7
  803318:	68 79 43 80 00       	push   $0x804379
  80331d:	e8 d0 05 00 00       	call   8038f2 <_panic>
  803322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	85 c0                	test   %eax,%eax
  803329:	74 10                	je     80333b <realloc_block_FF+0x1da>
  80332b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332e:	8b 00                	mov    (%eax),%eax
  803330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803333:	8b 52 04             	mov    0x4(%edx),%edx
  803336:	89 50 04             	mov    %edx,0x4(%eax)
  803339:	eb 0b                	jmp    803346 <realloc_block_FF+0x1e5>
  80333b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333e:	8b 40 04             	mov    0x4(%eax),%eax
  803341:	a3 30 50 80 00       	mov    %eax,0x805030
  803346:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803349:	8b 40 04             	mov    0x4(%eax),%eax
  80334c:	85 c0                	test   %eax,%eax
  80334e:	74 0f                	je     80335f <realloc_block_FF+0x1fe>
  803350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803353:	8b 40 04             	mov    0x4(%eax),%eax
  803356:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803359:	8b 12                	mov    (%edx),%edx
  80335b:	89 10                	mov    %edx,(%eax)
  80335d:	eb 0a                	jmp    803369 <realloc_block_FF+0x208>
  80335f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803375:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337c:	a1 38 50 80 00       	mov    0x805038,%eax
  803381:	48                   	dec    %eax
  803382:	a3 38 50 80 00       	mov    %eax,0x805038
  803387:	e9 83 02 00 00       	jmp    80360f <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80338c:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803390:	0f 86 69 02 00 00    	jbe    8035ff <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803396:	83 ec 04             	sub    $0x4,%esp
  803399:	6a 01                	push   $0x1
  80339b:	ff 75 f0             	pushl  -0x10(%ebp)
  80339e:	ff 75 08             	pushl  0x8(%ebp)
  8033a1:	e8 c8 ed ff ff       	call   80216e <set_block_data>
  8033a6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	83 e8 04             	sub    $0x4,%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	83 e0 fe             	and    $0xfffffffe,%eax
  8033b4:	89 c2                	mov    %eax,%edx
  8033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b9:	01 d0                	add    %edx,%eax
  8033bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033be:	a1 38 50 80 00       	mov    0x805038,%eax
  8033c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033c6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033ca:	75 68                	jne    803434 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033cc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033d0:	75 17                	jne    8033e9 <realloc_block_FF+0x288>
  8033d2:	83 ec 04             	sub    $0x4,%esp
  8033d5:	68 94 43 80 00       	push   $0x804394
  8033da:	68 06 02 00 00       	push   $0x206
  8033df:	68 79 43 80 00       	push   $0x804379
  8033e4:	e8 09 05 00 00       	call   8038f2 <_panic>
  8033e9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f2:	89 10                	mov    %edx,(%eax)
  8033f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	85 c0                	test   %eax,%eax
  8033fb:	74 0d                	je     80340a <realloc_block_FF+0x2a9>
  8033fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803402:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803405:	89 50 04             	mov    %edx,0x4(%eax)
  803408:	eb 08                	jmp    803412 <realloc_block_FF+0x2b1>
  80340a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340d:	a3 30 50 80 00       	mov    %eax,0x805030
  803412:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803415:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80341a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80341d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803424:	a1 38 50 80 00       	mov    0x805038,%eax
  803429:	40                   	inc    %eax
  80342a:	a3 38 50 80 00       	mov    %eax,0x805038
  80342f:	e9 b0 01 00 00       	jmp    8035e4 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803434:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803439:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80343c:	76 68                	jbe    8034a6 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80343e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803442:	75 17                	jne    80345b <realloc_block_FF+0x2fa>
  803444:	83 ec 04             	sub    $0x4,%esp
  803447:	68 94 43 80 00       	push   $0x804394
  80344c:	68 0b 02 00 00       	push   $0x20b
  803451:	68 79 43 80 00       	push   $0x804379
  803456:	e8 97 04 00 00       	call   8038f2 <_panic>
  80345b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803461:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803464:	89 10                	mov    %edx,(%eax)
  803466:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803469:	8b 00                	mov    (%eax),%eax
  80346b:	85 c0                	test   %eax,%eax
  80346d:	74 0d                	je     80347c <realloc_block_FF+0x31b>
  80346f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803474:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803477:	89 50 04             	mov    %edx,0x4(%eax)
  80347a:	eb 08                	jmp    803484 <realloc_block_FF+0x323>
  80347c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347f:	a3 30 50 80 00       	mov    %eax,0x805030
  803484:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803487:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80348c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803496:	a1 38 50 80 00       	mov    0x805038,%eax
  80349b:	40                   	inc    %eax
  80349c:	a3 38 50 80 00       	mov    %eax,0x805038
  8034a1:	e9 3e 01 00 00       	jmp    8035e4 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034ab:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034ae:	73 68                	jae    803518 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034b0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034b4:	75 17                	jne    8034cd <realloc_block_FF+0x36c>
  8034b6:	83 ec 04             	sub    $0x4,%esp
  8034b9:	68 c8 43 80 00       	push   $0x8043c8
  8034be:	68 10 02 00 00       	push   $0x210
  8034c3:	68 79 43 80 00       	push   $0x804379
  8034c8:	e8 25 04 00 00       	call   8038f2 <_panic>
  8034cd:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d6:	89 50 04             	mov    %edx,0x4(%eax)
  8034d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034dc:	8b 40 04             	mov    0x4(%eax),%eax
  8034df:	85 c0                	test   %eax,%eax
  8034e1:	74 0c                	je     8034ef <realloc_block_FF+0x38e>
  8034e3:	a1 30 50 80 00       	mov    0x805030,%eax
  8034e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034eb:	89 10                	mov    %edx,(%eax)
  8034ed:	eb 08                	jmp    8034f7 <realloc_block_FF+0x396>
  8034ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803508:	a1 38 50 80 00       	mov    0x805038,%eax
  80350d:	40                   	inc    %eax
  80350e:	a3 38 50 80 00       	mov    %eax,0x805038
  803513:	e9 cc 00 00 00       	jmp    8035e4 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803518:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80351f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803524:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803527:	e9 8a 00 00 00       	jmp    8035b6 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80352c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803532:	73 7a                	jae    8035ae <realloc_block_FF+0x44d>
  803534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80353c:	73 70                	jae    8035ae <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80353e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803542:	74 06                	je     80354a <realloc_block_FF+0x3e9>
  803544:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803548:	75 17                	jne    803561 <realloc_block_FF+0x400>
  80354a:	83 ec 04             	sub    $0x4,%esp
  80354d:	68 ec 43 80 00       	push   $0x8043ec
  803552:	68 1a 02 00 00       	push   $0x21a
  803557:	68 79 43 80 00       	push   $0x804379
  80355c:	e8 91 03 00 00       	call   8038f2 <_panic>
  803561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803564:	8b 10                	mov    (%eax),%edx
  803566:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803569:	89 10                	mov    %edx,(%eax)
  80356b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356e:	8b 00                	mov    (%eax),%eax
  803570:	85 c0                	test   %eax,%eax
  803572:	74 0b                	je     80357f <realloc_block_FF+0x41e>
  803574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803577:	8b 00                	mov    (%eax),%eax
  803579:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80357c:	89 50 04             	mov    %edx,0x4(%eax)
  80357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803582:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803585:	89 10                	mov    %edx,(%eax)
  803587:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80358d:	89 50 04             	mov    %edx,0x4(%eax)
  803590:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	85 c0                	test   %eax,%eax
  803597:	75 08                	jne    8035a1 <realloc_block_FF+0x440>
  803599:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359c:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8035a6:	40                   	inc    %eax
  8035a7:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035ac:	eb 36                	jmp    8035e4 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035ae:	a1 34 50 80 00       	mov    0x805034,%eax
  8035b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ba:	74 07                	je     8035c3 <realloc_block_FF+0x462>
  8035bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	eb 05                	jmp    8035c8 <realloc_block_FF+0x467>
  8035c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8035c8:	a3 34 50 80 00       	mov    %eax,0x805034
  8035cd:	a1 34 50 80 00       	mov    0x805034,%eax
  8035d2:	85 c0                	test   %eax,%eax
  8035d4:	0f 85 52 ff ff ff    	jne    80352c <realloc_block_FF+0x3cb>
  8035da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035de:	0f 85 48 ff ff ff    	jne    80352c <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035e4:	83 ec 04             	sub    $0x4,%esp
  8035e7:	6a 00                	push   $0x0
  8035e9:	ff 75 d8             	pushl  -0x28(%ebp)
  8035ec:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035ef:	e8 7a eb ff ff       	call   80216e <set_block_data>
  8035f4:	83 c4 10             	add    $0x10,%esp
				return va;
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	e9 7b 02 00 00       	jmp    80387a <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035ff:	83 ec 0c             	sub    $0xc,%esp
  803602:	68 69 44 80 00       	push   $0x804469
  803607:	e8 7e cd ff ff       	call   80038a <cprintf>
  80360c:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	e9 63 02 00 00       	jmp    80387a <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80361a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80361d:	0f 86 4d 02 00 00    	jbe    803870 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803623:	83 ec 0c             	sub    $0xc,%esp
  803626:	ff 75 e4             	pushl  -0x1c(%ebp)
  803629:	e8 08 e8 ff ff       	call   801e36 <is_free_block>
  80362e:	83 c4 10             	add    $0x10,%esp
  803631:	84 c0                	test   %al,%al
  803633:	0f 84 37 02 00 00    	je     803870 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80363c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80363f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803642:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803645:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803648:	76 38                	jbe    803682 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80364a:	83 ec 0c             	sub    $0xc,%esp
  80364d:	ff 75 08             	pushl  0x8(%ebp)
  803650:	e8 0c fa ff ff       	call   803061 <free_block>
  803655:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803658:	83 ec 0c             	sub    $0xc,%esp
  80365b:	ff 75 0c             	pushl  0xc(%ebp)
  80365e:	e8 3a eb ff ff       	call   80219d <alloc_block_FF>
  803663:	83 c4 10             	add    $0x10,%esp
  803666:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803669:	83 ec 08             	sub    $0x8,%esp
  80366c:	ff 75 c0             	pushl  -0x40(%ebp)
  80366f:	ff 75 08             	pushl  0x8(%ebp)
  803672:	e8 ab fa ff ff       	call   803122 <copy_data>
  803677:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80367a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80367d:	e9 f8 01 00 00       	jmp    80387a <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803682:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803685:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803688:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80368b:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80368f:	0f 87 a0 00 00 00    	ja     803735 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803695:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803699:	75 17                	jne    8036b2 <realloc_block_FF+0x551>
  80369b:	83 ec 04             	sub    $0x4,%esp
  80369e:	68 5b 43 80 00       	push   $0x80435b
  8036a3:	68 38 02 00 00       	push   $0x238
  8036a8:	68 79 43 80 00       	push   $0x804379
  8036ad:	e8 40 02 00 00       	call   8038f2 <_panic>
  8036b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	85 c0                	test   %eax,%eax
  8036b9:	74 10                	je     8036cb <realloc_block_FF+0x56a>
  8036bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036be:	8b 00                	mov    (%eax),%eax
  8036c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036c3:	8b 52 04             	mov    0x4(%edx),%edx
  8036c6:	89 50 04             	mov    %edx,0x4(%eax)
  8036c9:	eb 0b                	jmp    8036d6 <realloc_block_FF+0x575>
  8036cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ce:	8b 40 04             	mov    0x4(%eax),%eax
  8036d1:	a3 30 50 80 00       	mov    %eax,0x805030
  8036d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d9:	8b 40 04             	mov    0x4(%eax),%eax
  8036dc:	85 c0                	test   %eax,%eax
  8036de:	74 0f                	je     8036ef <realloc_block_FF+0x58e>
  8036e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e3:	8b 40 04             	mov    0x4(%eax),%eax
  8036e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036e9:	8b 12                	mov    (%edx),%edx
  8036eb:	89 10                	mov    %edx,(%eax)
  8036ed:	eb 0a                	jmp    8036f9 <realloc_block_FF+0x598>
  8036ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f2:	8b 00                	mov    (%eax),%eax
  8036f4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803705:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80370c:	a1 38 50 80 00       	mov    0x805038,%eax
  803711:	48                   	dec    %eax
  803712:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803717:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80371a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80371d:	01 d0                	add    %edx,%eax
  80371f:	83 ec 04             	sub    $0x4,%esp
  803722:	6a 01                	push   $0x1
  803724:	50                   	push   %eax
  803725:	ff 75 08             	pushl  0x8(%ebp)
  803728:	e8 41 ea ff ff       	call   80216e <set_block_data>
  80372d:	83 c4 10             	add    $0x10,%esp
  803730:	e9 36 01 00 00       	jmp    80386b <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803735:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803738:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80373b:	01 d0                	add    %edx,%eax
  80373d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803740:	83 ec 04             	sub    $0x4,%esp
  803743:	6a 01                	push   $0x1
  803745:	ff 75 f0             	pushl  -0x10(%ebp)
  803748:	ff 75 08             	pushl  0x8(%ebp)
  80374b:	e8 1e ea ff ff       	call   80216e <set_block_data>
  803750:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	83 e8 04             	sub    $0x4,%eax
  803759:	8b 00                	mov    (%eax),%eax
  80375b:	83 e0 fe             	and    $0xfffffffe,%eax
  80375e:	89 c2                	mov    %eax,%edx
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	01 d0                	add    %edx,%eax
  803765:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803768:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80376c:	74 06                	je     803774 <realloc_block_FF+0x613>
  80376e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803772:	75 17                	jne    80378b <realloc_block_FF+0x62a>
  803774:	83 ec 04             	sub    $0x4,%esp
  803777:	68 ec 43 80 00       	push   $0x8043ec
  80377c:	68 44 02 00 00       	push   $0x244
  803781:	68 79 43 80 00       	push   $0x804379
  803786:	e8 67 01 00 00       	call   8038f2 <_panic>
  80378b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378e:	8b 10                	mov    (%eax),%edx
  803790:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803793:	89 10                	mov    %edx,(%eax)
  803795:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803798:	8b 00                	mov    (%eax),%eax
  80379a:	85 c0                	test   %eax,%eax
  80379c:	74 0b                	je     8037a9 <realloc_block_FF+0x648>
  80379e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a1:	8b 00                	mov    (%eax),%eax
  8037a3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037a6:	89 50 04             	mov    %edx,0x4(%eax)
  8037a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ac:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037af:	89 10                	mov    %edx,(%eax)
  8037b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037b7:	89 50 04             	mov    %edx,0x4(%eax)
  8037ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037bd:	8b 00                	mov    (%eax),%eax
  8037bf:	85 c0                	test   %eax,%eax
  8037c1:	75 08                	jne    8037cb <realloc_block_FF+0x66a>
  8037c3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8037cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8037d0:	40                   	inc    %eax
  8037d1:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037da:	75 17                	jne    8037f3 <realloc_block_FF+0x692>
  8037dc:	83 ec 04             	sub    $0x4,%esp
  8037df:	68 5b 43 80 00       	push   $0x80435b
  8037e4:	68 45 02 00 00       	push   $0x245
  8037e9:	68 79 43 80 00       	push   $0x804379
  8037ee:	e8 ff 00 00 00       	call   8038f2 <_panic>
  8037f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f6:	8b 00                	mov    (%eax),%eax
  8037f8:	85 c0                	test   %eax,%eax
  8037fa:	74 10                	je     80380c <realloc_block_FF+0x6ab>
  8037fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ff:	8b 00                	mov    (%eax),%eax
  803801:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803804:	8b 52 04             	mov    0x4(%edx),%edx
  803807:	89 50 04             	mov    %edx,0x4(%eax)
  80380a:	eb 0b                	jmp    803817 <realloc_block_FF+0x6b6>
  80380c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380f:	8b 40 04             	mov    0x4(%eax),%eax
  803812:	a3 30 50 80 00       	mov    %eax,0x805030
  803817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381a:	8b 40 04             	mov    0x4(%eax),%eax
  80381d:	85 c0                	test   %eax,%eax
  80381f:	74 0f                	je     803830 <realloc_block_FF+0x6cf>
  803821:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803824:	8b 40 04             	mov    0x4(%eax),%eax
  803827:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80382a:	8b 12                	mov    (%edx),%edx
  80382c:	89 10                	mov    %edx,(%eax)
  80382e:	eb 0a                	jmp    80383a <realloc_block_FF+0x6d9>
  803830:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803833:	8b 00                	mov    (%eax),%eax
  803835:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80383a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803846:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80384d:	a1 38 50 80 00       	mov    0x805038,%eax
  803852:	48                   	dec    %eax
  803853:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803858:	83 ec 04             	sub    $0x4,%esp
  80385b:	6a 00                	push   $0x0
  80385d:	ff 75 bc             	pushl  -0x44(%ebp)
  803860:	ff 75 b8             	pushl  -0x48(%ebp)
  803863:	e8 06 e9 ff ff       	call   80216e <set_block_data>
  803868:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80386b:	8b 45 08             	mov    0x8(%ebp),%eax
  80386e:	eb 0a                	jmp    80387a <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803870:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803877:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80387a:	c9                   	leave  
  80387b:	c3                   	ret    

0080387c <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80387c:	55                   	push   %ebp
  80387d:	89 e5                	mov    %esp,%ebp
  80387f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803882:	83 ec 04             	sub    $0x4,%esp
  803885:	68 70 44 80 00       	push   $0x804470
  80388a:	68 58 02 00 00       	push   $0x258
  80388f:	68 79 43 80 00       	push   $0x804379
  803894:	e8 59 00 00 00       	call   8038f2 <_panic>

00803899 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803899:	55                   	push   %ebp
  80389a:	89 e5                	mov    %esp,%ebp
  80389c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80389f:	83 ec 04             	sub    $0x4,%esp
  8038a2:	68 98 44 80 00       	push   $0x804498
  8038a7:	68 61 02 00 00       	push   $0x261
  8038ac:	68 79 43 80 00       	push   $0x804379
  8038b1:	e8 3c 00 00 00       	call   8038f2 <_panic>

008038b6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8038b6:	55                   	push   %ebp
  8038b7:	89 e5                	mov    %esp,%ebp
  8038b9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8038bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8038c2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8038c6:	83 ec 0c             	sub    $0xc,%esp
  8038c9:	50                   	push   %eax
  8038ca:	e8 dd e0 ff ff       	call   8019ac <sys_cputc>
  8038cf:	83 c4 10             	add    $0x10,%esp
}
  8038d2:	90                   	nop
  8038d3:	c9                   	leave  
  8038d4:	c3                   	ret    

008038d5 <getchar>:


int
getchar(void)
{
  8038d5:	55                   	push   %ebp
  8038d6:	89 e5                	mov    %esp,%ebp
  8038d8:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8038db:	e8 68 df ff ff       	call   801848 <sys_cgetc>
  8038e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8038e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8038e6:	c9                   	leave  
  8038e7:	c3                   	ret    

008038e8 <iscons>:

int iscons(int fdnum)
{
  8038e8:	55                   	push   %ebp
  8038e9:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8038eb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8038f0:	5d                   	pop    %ebp
  8038f1:	c3                   	ret    

008038f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8038f2:	55                   	push   %ebp
  8038f3:	89 e5                	mov    %esp,%ebp
  8038f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8038f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8038fb:	83 c0 04             	add    $0x4,%eax
  8038fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803901:	a1 60 50 90 00       	mov    0x905060,%eax
  803906:	85 c0                	test   %eax,%eax
  803908:	74 16                	je     803920 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80390a:	a1 60 50 90 00       	mov    0x905060,%eax
  80390f:	83 ec 08             	sub    $0x8,%esp
  803912:	50                   	push   %eax
  803913:	68 c0 44 80 00       	push   $0x8044c0
  803918:	e8 6d ca ff ff       	call   80038a <cprintf>
  80391d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803920:	a1 00 50 80 00       	mov    0x805000,%eax
  803925:	ff 75 0c             	pushl  0xc(%ebp)
  803928:	ff 75 08             	pushl  0x8(%ebp)
  80392b:	50                   	push   %eax
  80392c:	68 c5 44 80 00       	push   $0x8044c5
  803931:	e8 54 ca ff ff       	call   80038a <cprintf>
  803936:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803939:	8b 45 10             	mov    0x10(%ebp),%eax
  80393c:	83 ec 08             	sub    $0x8,%esp
  80393f:	ff 75 f4             	pushl  -0xc(%ebp)
  803942:	50                   	push   %eax
  803943:	e8 d7 c9 ff ff       	call   80031f <vcprintf>
  803948:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80394b:	83 ec 08             	sub    $0x8,%esp
  80394e:	6a 00                	push   $0x0
  803950:	68 e1 44 80 00       	push   $0x8044e1
  803955:	e8 c5 c9 ff ff       	call   80031f <vcprintf>
  80395a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80395d:	e8 46 c9 ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  803962:	eb fe                	jmp    803962 <_panic+0x70>

00803964 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803964:	55                   	push   %ebp
  803965:	89 e5                	mov    %esp,%ebp
  803967:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80396a:	a1 20 50 80 00       	mov    0x805020,%eax
  80396f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803975:	8b 45 0c             	mov    0xc(%ebp),%eax
  803978:	39 c2                	cmp    %eax,%edx
  80397a:	74 14                	je     803990 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80397c:	83 ec 04             	sub    $0x4,%esp
  80397f:	68 e4 44 80 00       	push   $0x8044e4
  803984:	6a 26                	push   $0x26
  803986:	68 30 45 80 00       	push   $0x804530
  80398b:	e8 62 ff ff ff       	call   8038f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803990:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803997:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80399e:	e9 c5 00 00 00       	jmp    803a68 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8039a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b0:	01 d0                	add    %edx,%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	85 c0                	test   %eax,%eax
  8039b6:	75 08                	jne    8039c0 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8039b8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8039bb:	e9 a5 00 00 00       	jmp    803a65 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8039c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8039ce:	eb 69                	jmp    803a39 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8039d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8039d5:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039de:	89 d0                	mov    %edx,%eax
  8039e0:	01 c0                	add    %eax,%eax
  8039e2:	01 d0                	add    %edx,%eax
  8039e4:	c1 e0 03             	shl    $0x3,%eax
  8039e7:	01 c8                	add    %ecx,%eax
  8039e9:	8a 40 04             	mov    0x4(%eax),%al
  8039ec:	84 c0                	test   %al,%al
  8039ee:	75 46                	jne    803a36 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8039f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8039f5:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039fe:	89 d0                	mov    %edx,%eax
  803a00:	01 c0                	add    %eax,%eax
  803a02:	01 d0                	add    %edx,%eax
  803a04:	c1 e0 03             	shl    $0x3,%eax
  803a07:	01 c8                	add    %ecx,%eax
  803a09:	8b 00                	mov    (%eax),%eax
  803a0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a16:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a22:	8b 45 08             	mov    0x8(%ebp),%eax
  803a25:	01 c8                	add    %ecx,%eax
  803a27:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a29:	39 c2                	cmp    %eax,%edx
  803a2b:	75 09                	jne    803a36 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a2d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a34:	eb 15                	jmp    803a4b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a36:	ff 45 e8             	incl   -0x18(%ebp)
  803a39:	a1 20 50 80 00       	mov    0x805020,%eax
  803a3e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a47:	39 c2                	cmp    %eax,%edx
  803a49:	77 85                	ja     8039d0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a4f:	75 14                	jne    803a65 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803a51:	83 ec 04             	sub    $0x4,%esp
  803a54:	68 3c 45 80 00       	push   $0x80453c
  803a59:	6a 3a                	push   $0x3a
  803a5b:	68 30 45 80 00       	push   $0x804530
  803a60:	e8 8d fe ff ff       	call   8038f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803a65:	ff 45 f0             	incl   -0x10(%ebp)
  803a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a6e:	0f 8c 2f ff ff ff    	jl     8039a3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803a74:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a7b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803a82:	eb 26                	jmp    803aaa <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803a84:	a1 20 50 80 00       	mov    0x805020,%eax
  803a89:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a92:	89 d0                	mov    %edx,%eax
  803a94:	01 c0                	add    %eax,%eax
  803a96:	01 d0                	add    %edx,%eax
  803a98:	c1 e0 03             	shl    $0x3,%eax
  803a9b:	01 c8                	add    %ecx,%eax
  803a9d:	8a 40 04             	mov    0x4(%eax),%al
  803aa0:	3c 01                	cmp    $0x1,%al
  803aa2:	75 03                	jne    803aa7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803aa4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803aa7:	ff 45 e0             	incl   -0x20(%ebp)
  803aaa:	a1 20 50 80 00       	mov    0x805020,%eax
  803aaf:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ab8:	39 c2                	cmp    %eax,%edx
  803aba:	77 c8                	ja     803a84 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803ac2:	74 14                	je     803ad8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803ac4:	83 ec 04             	sub    $0x4,%esp
  803ac7:	68 90 45 80 00       	push   $0x804590
  803acc:	6a 44                	push   $0x44
  803ace:	68 30 45 80 00       	push   $0x804530
  803ad3:	e8 1a fe ff ff       	call   8038f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803ad8:	90                   	nop
  803ad9:	c9                   	leave  
  803ada:	c3                   	ret    
  803adb:	90                   	nop

00803adc <__udivdi3>:
  803adc:	55                   	push   %ebp
  803add:	57                   	push   %edi
  803ade:	56                   	push   %esi
  803adf:	53                   	push   %ebx
  803ae0:	83 ec 1c             	sub    $0x1c,%esp
  803ae3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ae7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803aeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803af3:	89 ca                	mov    %ecx,%edx
  803af5:	89 f8                	mov    %edi,%eax
  803af7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803afb:	85 f6                	test   %esi,%esi
  803afd:	75 2d                	jne    803b2c <__udivdi3+0x50>
  803aff:	39 cf                	cmp    %ecx,%edi
  803b01:	77 65                	ja     803b68 <__udivdi3+0x8c>
  803b03:	89 fd                	mov    %edi,%ebp
  803b05:	85 ff                	test   %edi,%edi
  803b07:	75 0b                	jne    803b14 <__udivdi3+0x38>
  803b09:	b8 01 00 00 00       	mov    $0x1,%eax
  803b0e:	31 d2                	xor    %edx,%edx
  803b10:	f7 f7                	div    %edi
  803b12:	89 c5                	mov    %eax,%ebp
  803b14:	31 d2                	xor    %edx,%edx
  803b16:	89 c8                	mov    %ecx,%eax
  803b18:	f7 f5                	div    %ebp
  803b1a:	89 c1                	mov    %eax,%ecx
  803b1c:	89 d8                	mov    %ebx,%eax
  803b1e:	f7 f5                	div    %ebp
  803b20:	89 cf                	mov    %ecx,%edi
  803b22:	89 fa                	mov    %edi,%edx
  803b24:	83 c4 1c             	add    $0x1c,%esp
  803b27:	5b                   	pop    %ebx
  803b28:	5e                   	pop    %esi
  803b29:	5f                   	pop    %edi
  803b2a:	5d                   	pop    %ebp
  803b2b:	c3                   	ret    
  803b2c:	39 ce                	cmp    %ecx,%esi
  803b2e:	77 28                	ja     803b58 <__udivdi3+0x7c>
  803b30:	0f bd fe             	bsr    %esi,%edi
  803b33:	83 f7 1f             	xor    $0x1f,%edi
  803b36:	75 40                	jne    803b78 <__udivdi3+0x9c>
  803b38:	39 ce                	cmp    %ecx,%esi
  803b3a:	72 0a                	jb     803b46 <__udivdi3+0x6a>
  803b3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b40:	0f 87 9e 00 00 00    	ja     803be4 <__udivdi3+0x108>
  803b46:	b8 01 00 00 00       	mov    $0x1,%eax
  803b4b:	89 fa                	mov    %edi,%edx
  803b4d:	83 c4 1c             	add    $0x1c,%esp
  803b50:	5b                   	pop    %ebx
  803b51:	5e                   	pop    %esi
  803b52:	5f                   	pop    %edi
  803b53:	5d                   	pop    %ebp
  803b54:	c3                   	ret    
  803b55:	8d 76 00             	lea    0x0(%esi),%esi
  803b58:	31 ff                	xor    %edi,%edi
  803b5a:	31 c0                	xor    %eax,%eax
  803b5c:	89 fa                	mov    %edi,%edx
  803b5e:	83 c4 1c             	add    $0x1c,%esp
  803b61:	5b                   	pop    %ebx
  803b62:	5e                   	pop    %esi
  803b63:	5f                   	pop    %edi
  803b64:	5d                   	pop    %ebp
  803b65:	c3                   	ret    
  803b66:	66 90                	xchg   %ax,%ax
  803b68:	89 d8                	mov    %ebx,%eax
  803b6a:	f7 f7                	div    %edi
  803b6c:	31 ff                	xor    %edi,%edi
  803b6e:	89 fa                	mov    %edi,%edx
  803b70:	83 c4 1c             	add    $0x1c,%esp
  803b73:	5b                   	pop    %ebx
  803b74:	5e                   	pop    %esi
  803b75:	5f                   	pop    %edi
  803b76:	5d                   	pop    %ebp
  803b77:	c3                   	ret    
  803b78:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b7d:	89 eb                	mov    %ebp,%ebx
  803b7f:	29 fb                	sub    %edi,%ebx
  803b81:	89 f9                	mov    %edi,%ecx
  803b83:	d3 e6                	shl    %cl,%esi
  803b85:	89 c5                	mov    %eax,%ebp
  803b87:	88 d9                	mov    %bl,%cl
  803b89:	d3 ed                	shr    %cl,%ebp
  803b8b:	89 e9                	mov    %ebp,%ecx
  803b8d:	09 f1                	or     %esi,%ecx
  803b8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b93:	89 f9                	mov    %edi,%ecx
  803b95:	d3 e0                	shl    %cl,%eax
  803b97:	89 c5                	mov    %eax,%ebp
  803b99:	89 d6                	mov    %edx,%esi
  803b9b:	88 d9                	mov    %bl,%cl
  803b9d:	d3 ee                	shr    %cl,%esi
  803b9f:	89 f9                	mov    %edi,%ecx
  803ba1:	d3 e2                	shl    %cl,%edx
  803ba3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba7:	88 d9                	mov    %bl,%cl
  803ba9:	d3 e8                	shr    %cl,%eax
  803bab:	09 c2                	or     %eax,%edx
  803bad:	89 d0                	mov    %edx,%eax
  803baf:	89 f2                	mov    %esi,%edx
  803bb1:	f7 74 24 0c          	divl   0xc(%esp)
  803bb5:	89 d6                	mov    %edx,%esi
  803bb7:	89 c3                	mov    %eax,%ebx
  803bb9:	f7 e5                	mul    %ebp
  803bbb:	39 d6                	cmp    %edx,%esi
  803bbd:	72 19                	jb     803bd8 <__udivdi3+0xfc>
  803bbf:	74 0b                	je     803bcc <__udivdi3+0xf0>
  803bc1:	89 d8                	mov    %ebx,%eax
  803bc3:	31 ff                	xor    %edi,%edi
  803bc5:	e9 58 ff ff ff       	jmp    803b22 <__udivdi3+0x46>
  803bca:	66 90                	xchg   %ax,%ax
  803bcc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bd0:	89 f9                	mov    %edi,%ecx
  803bd2:	d3 e2                	shl    %cl,%edx
  803bd4:	39 c2                	cmp    %eax,%edx
  803bd6:	73 e9                	jae    803bc1 <__udivdi3+0xe5>
  803bd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bdb:	31 ff                	xor    %edi,%edi
  803bdd:	e9 40 ff ff ff       	jmp    803b22 <__udivdi3+0x46>
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	31 c0                	xor    %eax,%eax
  803be6:	e9 37 ff ff ff       	jmp    803b22 <__udivdi3+0x46>
  803beb:	90                   	nop

00803bec <__umoddi3>:
  803bec:	55                   	push   %ebp
  803bed:	57                   	push   %edi
  803bee:	56                   	push   %esi
  803bef:	53                   	push   %ebx
  803bf0:	83 ec 1c             	sub    $0x1c,%esp
  803bf3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bf7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c0b:	89 f3                	mov    %esi,%ebx
  803c0d:	89 fa                	mov    %edi,%edx
  803c0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c13:	89 34 24             	mov    %esi,(%esp)
  803c16:	85 c0                	test   %eax,%eax
  803c18:	75 1a                	jne    803c34 <__umoddi3+0x48>
  803c1a:	39 f7                	cmp    %esi,%edi
  803c1c:	0f 86 a2 00 00 00    	jbe    803cc4 <__umoddi3+0xd8>
  803c22:	89 c8                	mov    %ecx,%eax
  803c24:	89 f2                	mov    %esi,%edx
  803c26:	f7 f7                	div    %edi
  803c28:	89 d0                	mov    %edx,%eax
  803c2a:	31 d2                	xor    %edx,%edx
  803c2c:	83 c4 1c             	add    $0x1c,%esp
  803c2f:	5b                   	pop    %ebx
  803c30:	5e                   	pop    %esi
  803c31:	5f                   	pop    %edi
  803c32:	5d                   	pop    %ebp
  803c33:	c3                   	ret    
  803c34:	39 f0                	cmp    %esi,%eax
  803c36:	0f 87 ac 00 00 00    	ja     803ce8 <__umoddi3+0xfc>
  803c3c:	0f bd e8             	bsr    %eax,%ebp
  803c3f:	83 f5 1f             	xor    $0x1f,%ebp
  803c42:	0f 84 ac 00 00 00    	je     803cf4 <__umoddi3+0x108>
  803c48:	bf 20 00 00 00       	mov    $0x20,%edi
  803c4d:	29 ef                	sub    %ebp,%edi
  803c4f:	89 fe                	mov    %edi,%esi
  803c51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c55:	89 e9                	mov    %ebp,%ecx
  803c57:	d3 e0                	shl    %cl,%eax
  803c59:	89 d7                	mov    %edx,%edi
  803c5b:	89 f1                	mov    %esi,%ecx
  803c5d:	d3 ef                	shr    %cl,%edi
  803c5f:	09 c7                	or     %eax,%edi
  803c61:	89 e9                	mov    %ebp,%ecx
  803c63:	d3 e2                	shl    %cl,%edx
  803c65:	89 14 24             	mov    %edx,(%esp)
  803c68:	89 d8                	mov    %ebx,%eax
  803c6a:	d3 e0                	shl    %cl,%eax
  803c6c:	89 c2                	mov    %eax,%edx
  803c6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c72:	d3 e0                	shl    %cl,%eax
  803c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c78:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c7c:	89 f1                	mov    %esi,%ecx
  803c7e:	d3 e8                	shr    %cl,%eax
  803c80:	09 d0                	or     %edx,%eax
  803c82:	d3 eb                	shr    %cl,%ebx
  803c84:	89 da                	mov    %ebx,%edx
  803c86:	f7 f7                	div    %edi
  803c88:	89 d3                	mov    %edx,%ebx
  803c8a:	f7 24 24             	mull   (%esp)
  803c8d:	89 c6                	mov    %eax,%esi
  803c8f:	89 d1                	mov    %edx,%ecx
  803c91:	39 d3                	cmp    %edx,%ebx
  803c93:	0f 82 87 00 00 00    	jb     803d20 <__umoddi3+0x134>
  803c99:	0f 84 91 00 00 00    	je     803d30 <__umoddi3+0x144>
  803c9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ca3:	29 f2                	sub    %esi,%edx
  803ca5:	19 cb                	sbb    %ecx,%ebx
  803ca7:	89 d8                	mov    %ebx,%eax
  803ca9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cad:	d3 e0                	shl    %cl,%eax
  803caf:	89 e9                	mov    %ebp,%ecx
  803cb1:	d3 ea                	shr    %cl,%edx
  803cb3:	09 d0                	or     %edx,%eax
  803cb5:	89 e9                	mov    %ebp,%ecx
  803cb7:	d3 eb                	shr    %cl,%ebx
  803cb9:	89 da                	mov    %ebx,%edx
  803cbb:	83 c4 1c             	add    $0x1c,%esp
  803cbe:	5b                   	pop    %ebx
  803cbf:	5e                   	pop    %esi
  803cc0:	5f                   	pop    %edi
  803cc1:	5d                   	pop    %ebp
  803cc2:	c3                   	ret    
  803cc3:	90                   	nop
  803cc4:	89 fd                	mov    %edi,%ebp
  803cc6:	85 ff                	test   %edi,%edi
  803cc8:	75 0b                	jne    803cd5 <__umoddi3+0xe9>
  803cca:	b8 01 00 00 00       	mov    $0x1,%eax
  803ccf:	31 d2                	xor    %edx,%edx
  803cd1:	f7 f7                	div    %edi
  803cd3:	89 c5                	mov    %eax,%ebp
  803cd5:	89 f0                	mov    %esi,%eax
  803cd7:	31 d2                	xor    %edx,%edx
  803cd9:	f7 f5                	div    %ebp
  803cdb:	89 c8                	mov    %ecx,%eax
  803cdd:	f7 f5                	div    %ebp
  803cdf:	89 d0                	mov    %edx,%eax
  803ce1:	e9 44 ff ff ff       	jmp    803c2a <__umoddi3+0x3e>
  803ce6:	66 90                	xchg   %ax,%ax
  803ce8:	89 c8                	mov    %ecx,%eax
  803cea:	89 f2                	mov    %esi,%edx
  803cec:	83 c4 1c             	add    $0x1c,%esp
  803cef:	5b                   	pop    %ebx
  803cf0:	5e                   	pop    %esi
  803cf1:	5f                   	pop    %edi
  803cf2:	5d                   	pop    %ebp
  803cf3:	c3                   	ret    
  803cf4:	3b 04 24             	cmp    (%esp),%eax
  803cf7:	72 06                	jb     803cff <__umoddi3+0x113>
  803cf9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cfd:	77 0f                	ja     803d0e <__umoddi3+0x122>
  803cff:	89 f2                	mov    %esi,%edx
  803d01:	29 f9                	sub    %edi,%ecx
  803d03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d07:	89 14 24             	mov    %edx,(%esp)
  803d0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d12:	8b 14 24             	mov    (%esp),%edx
  803d15:	83 c4 1c             	add    $0x1c,%esp
  803d18:	5b                   	pop    %ebx
  803d19:	5e                   	pop    %esi
  803d1a:	5f                   	pop    %edi
  803d1b:	5d                   	pop    %ebp
  803d1c:	c3                   	ret    
  803d1d:	8d 76 00             	lea    0x0(%esi),%esi
  803d20:	2b 04 24             	sub    (%esp),%eax
  803d23:	19 fa                	sbb    %edi,%edx
  803d25:	89 d1                	mov    %edx,%ecx
  803d27:	89 c6                	mov    %eax,%esi
  803d29:	e9 71 ff ff ff       	jmp    803c9f <__umoddi3+0xb3>
  803d2e:	66 90                	xchg   %ax,%ax
  803d30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d34:	72 ea                	jb     803d20 <__umoddi3+0x134>
  803d36:	89 d9                	mov    %ebx,%ecx
  803d38:	e9 62 ff ff ff       	jmp    803c9f <__umoddi3+0xb3>
