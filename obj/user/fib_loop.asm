
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
  800052:	68 00 3d 80 00       	push   $0x803d00
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
  8000bc:	68 1e 3d 80 00       	push   $0x803d1e
  8000c1:	e8 f1 02 00 00       	call   8003b7 <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 f5 1a 00 00       	call   801bc3 <inctst>
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
  80017d:	e8 03 19 00 00       	call   801a85 <sys_getenvindex>
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
  8001eb:	e8 19 16 00 00       	call   801809 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 4c 3d 80 00       	push   $0x803d4c
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
  80021b:	68 74 3d 80 00       	push   $0x803d74
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
  80024c:	68 9c 3d 80 00       	push   $0x803d9c
  800251:	e8 34 01 00 00       	call   80038a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 f4 3d 80 00       	push   $0x803df4
  80026d:	e8 18 01 00 00       	call   80038a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 4c 3d 80 00       	push   $0x803d4c
  80027d:	e8 08 01 00 00       	call   80038a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800285:	e8 99 15 00 00       	call   801823 <sys_unlock_cons>
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
  80029d:	e8 af 17 00 00       	call   801a51 <sys_destroy_env>
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
  8002ae:	e8 04 18 00 00       	call   801ab7 <sys_exit_env>
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
  8002fc:	e8 c6 14 00 00       	call   8017c7 <sys_cputs>
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
  800373:	e8 4f 14 00 00       	call   8017c7 <sys_cputs>
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
  8003bd:	e8 47 14 00 00       	call   801809 <sys_lock_cons>
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
  8003dd:	e8 41 14 00 00       	call   801823 <sys_unlock_cons>
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
  800427:	e8 58 36 00 00       	call   803a84 <__udivdi3>
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
  800477:	e8 18 37 00 00       	call   803b94 <__umoddi3>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	05 34 40 80 00       	add    $0x804034,%eax
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
  8005d2:	8b 04 85 58 40 80 00 	mov    0x804058(,%eax,4),%eax
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
  8006b3:	8b 34 9d a0 3e 80 00 	mov    0x803ea0(,%ebx,4),%esi
  8006ba:	85 f6                	test   %esi,%esi
  8006bc:	75 19                	jne    8006d7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006be:	53                   	push   %ebx
  8006bf:	68 45 40 80 00       	push   $0x804045
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
  8006d8:	68 4e 40 80 00       	push   $0x80404e
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
  800705:	be 51 40 80 00       	mov    $0x804051,%esi
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
  800a30:	68 c8 41 80 00       	push   $0x8041c8
  800a35:	e8 50 f9 ff ff       	call   80038a <cprintf>
  800a3a:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a44:	83 ec 0c             	sub    $0xc,%esp
  800a47:	6a 00                	push   $0x0
  800a49:	e8 42 2e 00 00       	call   803890 <iscons>
  800a4e:	83 c4 10             	add    $0x10,%esp
  800a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a54:	e8 24 2e 00 00       	call   80387d <getchar>
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
  800a72:	68 cb 41 80 00       	push   $0x8041cb
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
  800a9f:	e8 ba 2d 00 00       	call   80385e <cputchar>
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
  800ad6:	e8 83 2d 00 00       	call   80385e <cputchar>
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
  800aff:	e8 5a 2d 00 00       	call   80385e <cputchar>
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
  800b23:	e8 e1 0c 00 00       	call   801809 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b2c:	74 13                	je     800b41 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 08             	pushl  0x8(%ebp)
  800b34:	68 c8 41 80 00       	push   $0x8041c8
  800b39:	e8 4c f8 ff ff       	call   80038a <cprintf>
  800b3e:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b48:	83 ec 0c             	sub    $0xc,%esp
  800b4b:	6a 00                	push   $0x0
  800b4d:	e8 3e 2d 00 00       	call   803890 <iscons>
  800b52:	83 c4 10             	add    $0x10,%esp
  800b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b58:	e8 20 2d 00 00       	call   80387d <getchar>
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
  800b76:	68 cb 41 80 00       	push   $0x8041cb
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
  800ba3:	e8 b6 2c 00 00       	call   80385e <cputchar>
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
  800bda:	e8 7f 2c 00 00       	call   80385e <cputchar>
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
  800c03:	e8 56 2c 00 00       	call   80385e <cputchar>
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
  800c1e:	e8 00 0c 00 00       	call   801823 <sys_unlock_cons>
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
  801318:	68 dc 41 80 00       	push   $0x8041dc
  80131d:	68 3f 01 00 00       	push   $0x13f
  801322:	68 fe 41 80 00       	push   $0x8041fe
  801327:	e8 6e 25 00 00       	call   80389a <_panic>

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
  801338:	e8 35 0a 00 00       	call   801d72 <sys_sbrk>
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
  8013b3:	e8 3e 08 00 00       	call   801bf6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	74 16                	je     8013d2 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 08             	pushl  0x8(%ebp)
  8013c2:	e8 7e 0d 00 00       	call   802145 <alloc_block_FF>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8013cd:	e9 8a 01 00 00       	jmp    80155c <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  8013d2:	e8 50 08 00 00       	call   801c27 <sys_isUHeapPlacementStrategyBESTFIT>
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	0f 84 7d 01 00 00    	je     80155c <malloc+0x21a>
			ptr = alloc_block_BF(size);
  8013df:	83 ec 0c             	sub    $0xc,%esp
  8013e2:	ff 75 08             	pushl  0x8(%ebp)
  8013e5:	e8 17 12 00 00       	call   802601 <alloc_block_BF>
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
  80154b:	e8 59 08 00 00       	call   801da9 <sys_allocate_user_mem>
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
  801593:	e8 2d 08 00 00       	call   801dc5 <get_block_size>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80159e:	83 ec 0c             	sub    $0xc,%esp
  8015a1:	ff 75 08             	pushl  0x8(%ebp)
  8015a4:	e8 60 1a 00 00       	call   803009 <free_block>
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
  80163b:	e8 4d 07 00 00       	call   801d8d <sys_free_user_mem>
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
  801649:	68 0c 42 80 00       	push   $0x80420c
  80164e:	68 84 00 00 00       	push   $0x84
  801653:	68 36 42 80 00       	push   $0x804236
  801658:	e8 3d 22 00 00       	call   80389a <_panic>
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
  8016bb:	e8 d4 02 00 00       	call   801994 <sys_createSharedObject>
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
  8016dc:	68 42 42 80 00       	push   $0x804242
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
  8016f1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016f4:	83 ec 04             	sub    $0x4,%esp
  8016f7:	68 48 42 80 00       	push   $0x804248
  8016fc:	68 a4 00 00 00       	push   $0xa4
  801701:	68 36 42 80 00       	push   $0x804236
  801706:	e8 8f 21 00 00       	call   80389a <_panic>

0080170b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	68 6c 42 80 00       	push   $0x80426c
  801719:	68 bc 00 00 00       	push   $0xbc
  80171e:	68 36 42 80 00       	push   $0x804236
  801723:	e8 72 21 00 00       	call   80389a <_panic>

00801728 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	68 90 42 80 00       	push   $0x804290
  801736:	68 d3 00 00 00       	push   $0xd3
  80173b:	68 36 42 80 00       	push   $0x804236
  801740:	e8 55 21 00 00       	call   80389a <_panic>

00801745 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80174b:	83 ec 04             	sub    $0x4,%esp
  80174e:	68 b6 42 80 00       	push   $0x8042b6
  801753:	68 df 00 00 00       	push   $0xdf
  801758:	68 36 42 80 00       	push   $0x804236
  80175d:	e8 38 21 00 00       	call   80389a <_panic>

00801762 <shrink>:

}
void shrink(uint32 newSize)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	68 b6 42 80 00       	push   $0x8042b6
  801770:	68 e4 00 00 00       	push   $0xe4
  801775:	68 36 42 80 00       	push   $0x804236
  80177a:	e8 1b 21 00 00       	call   80389a <_panic>

0080177f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	68 b6 42 80 00       	push   $0x8042b6
  80178d:	68 e9 00 00 00       	push   $0xe9
  801792:	68 36 42 80 00       	push   $0x804236
  801797:	e8 fe 20 00 00       	call   80389a <_panic>

0080179c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	57                   	push   %edi
  8017a0:	56                   	push   %esi
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017b4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017b7:	cd 30                	int    $0x30
  8017b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	5b                   	pop    %ebx
  8017c3:	5e                   	pop    %esi
  8017c4:	5f                   	pop    %edi
  8017c5:	5d                   	pop    %ebp
  8017c6:	c3                   	ret    

008017c7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 04             	sub    $0x4,%esp
  8017cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	52                   	push   %edx
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	50                   	push   %eax
  8017e3:	6a 00                	push   $0x0
  8017e5:	e8 b2 ff ff ff       	call   80179c <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	90                   	nop
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 02                	push   $0x2
  8017ff:	e8 98 ff ff ff       	call   80179c <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 03                	push   $0x3
  801818:	e8 7f ff ff ff       	call   80179c <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	90                   	nop
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 04                	push   $0x4
  801832:	e8 65 ff ff ff       	call   80179c <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	90                   	nop
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801840:	8b 55 0c             	mov    0xc(%ebp),%edx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	52                   	push   %edx
  80184d:	50                   	push   %eax
  80184e:	6a 08                	push   $0x8
  801850:	e8 47 ff ff ff       	call   80179c <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	56                   	push   %esi
  80185e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80185f:	8b 75 18             	mov    0x18(%ebp),%esi
  801862:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801865:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801868:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	56                   	push   %esi
  80186f:	53                   	push   %ebx
  801870:	51                   	push   %ecx
  801871:	52                   	push   %edx
  801872:	50                   	push   %eax
  801873:	6a 09                	push   $0x9
  801875:	e8 22 ff ff ff       	call   80179c <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801880:	5b                   	pop    %ebx
  801881:	5e                   	pop    %esi
  801882:	5d                   	pop    %ebp
  801883:	c3                   	ret    

00801884 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	52                   	push   %edx
  801894:	50                   	push   %eax
  801895:	6a 0a                	push   $0xa
  801897:	e8 00 ff ff ff       	call   80179c <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	ff 75 0c             	pushl  0xc(%ebp)
  8018ad:	ff 75 08             	pushl  0x8(%ebp)
  8018b0:	6a 0b                	push   $0xb
  8018b2:	e8 e5 fe ff ff       	call   80179c <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 0c                	push   $0xc
  8018cb:	e8 cc fe ff ff       	call   80179c <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 0d                	push   $0xd
  8018e4:	e8 b3 fe ff ff       	call   80179c <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 0e                	push   $0xe
  8018fd:	e8 9a fe ff ff       	call   80179c <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 0f                	push   $0xf
  801916:	e8 81 fe ff ff       	call   80179c <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	ff 75 08             	pushl  0x8(%ebp)
  80192e:	6a 10                	push   $0x10
  801930:	e8 67 fe ff ff       	call   80179c <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 11                	push   $0x11
  801949:	e8 4e fe ff ff       	call   80179c <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	90                   	nop
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_cputc>:

void
sys_cputc(const char c)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801960:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	50                   	push   %eax
  80196d:	6a 01                	push   $0x1
  80196f:	e8 28 fe ff ff       	call   80179c <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	90                   	nop
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 14                	push   $0x14
  801989:	e8 0e fe ff ff       	call   80179c <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	90                   	nop
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 04             	sub    $0x4,%esp
  80199a:	8b 45 10             	mov    0x10(%ebp),%eax
  80199d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019a0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019a3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	6a 00                	push   $0x0
  8019ac:	51                   	push   %ecx
  8019ad:	52                   	push   %edx
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	50                   	push   %eax
  8019b2:	6a 15                	push   $0x15
  8019b4:	e8 e3 fd ff ff       	call   80179c <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	52                   	push   %edx
  8019ce:	50                   	push   %eax
  8019cf:	6a 16                	push   $0x16
  8019d1:	e8 c6 fd ff ff       	call   80179c <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	51                   	push   %ecx
  8019ec:	52                   	push   %edx
  8019ed:	50                   	push   %eax
  8019ee:	6a 17                	push   $0x17
  8019f0:	e8 a7 fd ff ff       	call   80179c <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	52                   	push   %edx
  801a0a:	50                   	push   %eax
  801a0b:	6a 18                	push   $0x18
  801a0d:	e8 8a fd ff ff       	call   80179c <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	6a 00                	push   $0x0
  801a1f:	ff 75 14             	pushl  0x14(%ebp)
  801a22:	ff 75 10             	pushl  0x10(%ebp)
  801a25:	ff 75 0c             	pushl  0xc(%ebp)
  801a28:	50                   	push   %eax
  801a29:	6a 19                	push   $0x19
  801a2b:	e8 6c fd ff ff       	call   80179c <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	50                   	push   %eax
  801a44:	6a 1a                	push   $0x1a
  801a46:	e8 51 fd ff ff       	call   80179c <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	90                   	nop
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	50                   	push   %eax
  801a60:	6a 1b                	push   $0x1b
  801a62:	e8 35 fd ff ff       	call   80179c <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 05                	push   $0x5
  801a7b:	e8 1c fd ff ff       	call   80179c <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 06                	push   $0x6
  801a94:	e8 03 fd ff ff       	call   80179c <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 07                	push   $0x7
  801aad:	e8 ea fc ff ff       	call   80179c <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_exit_env>:


void sys_exit_env(void)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 1c                	push   $0x1c
  801ac6:	e8 d1 fc ff ff       	call   80179c <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	90                   	nop
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ad7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ada:	8d 50 04             	lea    0x4(%eax),%edx
  801add:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	52                   	push   %edx
  801ae7:	50                   	push   %eax
  801ae8:	6a 1d                	push   $0x1d
  801aea:	e8 ad fc ff ff       	call   80179c <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
	return result;
  801af2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801af5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801af8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801afb:	89 01                	mov    %eax,(%ecx)
  801afd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	c9                   	leave  
  801b04:	c2 04 00             	ret    $0x4

00801b07 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	ff 75 10             	pushl  0x10(%ebp)
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	ff 75 08             	pushl  0x8(%ebp)
  801b17:	6a 13                	push   $0x13
  801b19:	e8 7e fc ff ff       	call   80179c <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b21:	90                   	nop
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 1e                	push   $0x1e
  801b33:	e8 64 fc ff ff       	call   80179c <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 04             	sub    $0x4,%esp
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b49:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	50                   	push   %eax
  801b56:	6a 1f                	push   $0x1f
  801b58:	e8 3f fc ff ff       	call   80179c <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b60:	90                   	nop
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <rsttst>:
void rsttst()
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 21                	push   $0x21
  801b72:	e8 25 fc ff ff       	call   80179c <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7a:	90                   	nop
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	8b 45 14             	mov    0x14(%ebp),%eax
  801b86:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b89:	8b 55 18             	mov    0x18(%ebp),%edx
  801b8c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	ff 75 10             	pushl  0x10(%ebp)
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	6a 20                	push   $0x20
  801b9d:	e8 fa fb ff ff       	call   80179c <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba5:	90                   	nop
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <chktst>:
void chktst(uint32 n)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	ff 75 08             	pushl  0x8(%ebp)
  801bb6:	6a 22                	push   $0x22
  801bb8:	e8 df fb ff ff       	call   80179c <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc0:	90                   	nop
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <inctst>:

void inctst()
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 23                	push   $0x23
  801bd2:	e8 c5 fb ff ff       	call   80179c <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bda:	90                   	nop
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <gettst>:
uint32 gettst()
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 24                	push   $0x24
  801bec:	e8 ab fb ff ff       	call   80179c <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 25                	push   $0x25
  801c08:	e8 8f fb ff ff       	call   80179c <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
  801c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c13:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c17:	75 07                	jne    801c20 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c19:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1e:	eb 05                	jmp    801c25 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 25                	push   $0x25
  801c39:	e8 5e fb ff ff       	call   80179c <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
  801c41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c44:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c48:	75 07                	jne    801c51 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4f:	eb 05                	jmp    801c56 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
  801c5b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 25                	push   $0x25
  801c6a:	e8 2d fb ff ff       	call   80179c <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
  801c72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c75:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c79:	75 07                	jne    801c82 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c80:	eb 05                	jmp    801c87 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
  801c8c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 25                	push   $0x25
  801c9b:	e8 fc fa ff ff       	call   80179c <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
  801ca3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ca6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801caa:	75 07                	jne    801cb3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cac:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb1:	eb 05                	jmp    801cb8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	ff 75 08             	pushl  0x8(%ebp)
  801cc8:	6a 26                	push   $0x26
  801cca:	e8 cd fa ff ff       	call   80179c <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd2:	90                   	nop
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cd9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cdc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	53                   	push   %ebx
  801ce8:	51                   	push   %ecx
  801ce9:	52                   	push   %edx
  801cea:	50                   	push   %eax
  801ceb:	6a 27                	push   $0x27
  801ced:	e8 aa fa ff ff       	call   80179c <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	52                   	push   %edx
  801d0a:	50                   	push   %eax
  801d0b:	6a 28                	push   $0x28
  801d0d:	e8 8a fa ff ff       	call   80179c <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d1a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	6a 00                	push   $0x0
  801d25:	51                   	push   %ecx
  801d26:	ff 75 10             	pushl  0x10(%ebp)
  801d29:	52                   	push   %edx
  801d2a:	50                   	push   %eax
  801d2b:	6a 29                	push   $0x29
  801d2d:	e8 6a fa ff ff       	call   80179c <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	ff 75 10             	pushl  0x10(%ebp)
  801d41:	ff 75 0c             	pushl  0xc(%ebp)
  801d44:	ff 75 08             	pushl  0x8(%ebp)
  801d47:	6a 12                	push   $0x12
  801d49:	e8 4e fa ff ff       	call   80179c <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d51:	90                   	nop
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	52                   	push   %edx
  801d64:	50                   	push   %eax
  801d65:	6a 2a                	push   $0x2a
  801d67:	e8 30 fa ff ff       	call   80179c <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
	return;
  801d6f:	90                   	nop
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d75:	8b 45 08             	mov    0x8(%ebp),%eax
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	50                   	push   %eax
  801d81:	6a 2b                	push   $0x2b
  801d83:	e8 14 fa ff ff       	call   80179c <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	ff 75 0c             	pushl  0xc(%ebp)
  801d99:	ff 75 08             	pushl  0x8(%ebp)
  801d9c:	6a 2c                	push   $0x2c
  801d9e:	e8 f9 f9 ff ff       	call   80179c <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
	return;
  801da6:	90                   	nop
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	ff 75 0c             	pushl  0xc(%ebp)
  801db5:	ff 75 08             	pushl  0x8(%ebp)
  801db8:	6a 2d                	push   $0x2d
  801dba:	e8 dd f9 ff ff       	call   80179c <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
	return;
  801dc2:	90                   	nop
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dce:	83 e8 04             	sub    $0x4,%eax
  801dd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dd7:	8b 00                	mov    (%eax),%eax
  801dd9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801de4:	8b 45 08             	mov    0x8(%ebp),%eax
  801de7:	83 e8 04             	sub    $0x4,%eax
  801dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801df0:	8b 00                	mov    (%eax),%eax
  801df2:	83 e0 01             	and    $0x1,%eax
  801df5:	85 c0                	test   %eax,%eax
  801df7:	0f 94 c0             	sete   %al
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0c:	83 f8 02             	cmp    $0x2,%eax
  801e0f:	74 2b                	je     801e3c <alloc_block+0x40>
  801e11:	83 f8 02             	cmp    $0x2,%eax
  801e14:	7f 07                	jg     801e1d <alloc_block+0x21>
  801e16:	83 f8 01             	cmp    $0x1,%eax
  801e19:	74 0e                	je     801e29 <alloc_block+0x2d>
  801e1b:	eb 58                	jmp    801e75 <alloc_block+0x79>
  801e1d:	83 f8 03             	cmp    $0x3,%eax
  801e20:	74 2d                	je     801e4f <alloc_block+0x53>
  801e22:	83 f8 04             	cmp    $0x4,%eax
  801e25:	74 3b                	je     801e62 <alloc_block+0x66>
  801e27:	eb 4c                	jmp    801e75 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e29:	83 ec 0c             	sub    $0xc,%esp
  801e2c:	ff 75 08             	pushl  0x8(%ebp)
  801e2f:	e8 11 03 00 00       	call   802145 <alloc_block_FF>
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e3a:	eb 4a                	jmp    801e86 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e3c:	83 ec 0c             	sub    $0xc,%esp
  801e3f:	ff 75 08             	pushl  0x8(%ebp)
  801e42:	e8 fa 19 00 00       	call   803841 <alloc_block_NF>
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e4d:	eb 37                	jmp    801e86 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e4f:	83 ec 0c             	sub    $0xc,%esp
  801e52:	ff 75 08             	pushl  0x8(%ebp)
  801e55:	e8 a7 07 00 00       	call   802601 <alloc_block_BF>
  801e5a:	83 c4 10             	add    $0x10,%esp
  801e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e60:	eb 24                	jmp    801e86 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	ff 75 08             	pushl  0x8(%ebp)
  801e68:	e8 b7 19 00 00       	call   803824 <alloc_block_WF>
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e73:	eb 11                	jmp    801e86 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e75:	83 ec 0c             	sub    $0xc,%esp
  801e78:	68 c8 42 80 00       	push   $0x8042c8
  801e7d:	e8 08 e5 ff ff       	call   80038a <cprintf>
  801e82:	83 c4 10             	add    $0x10,%esp
		break;
  801e85:	90                   	nop
	}
	return va;
  801e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	53                   	push   %ebx
  801e8f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e92:	83 ec 0c             	sub    $0xc,%esp
  801e95:	68 e8 42 80 00       	push   $0x8042e8
  801e9a:	e8 eb e4 ff ff       	call   80038a <cprintf>
  801e9f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ea2:	83 ec 0c             	sub    $0xc,%esp
  801ea5:	68 13 43 80 00       	push   $0x804313
  801eaa:	e8 db e4 ff ff       	call   80038a <cprintf>
  801eaf:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb8:	eb 37                	jmp    801ef1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801eba:	83 ec 0c             	sub    $0xc,%esp
  801ebd:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec0:	e8 19 ff ff ff       	call   801dde <is_free_block>
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	0f be d8             	movsbl %al,%ebx
  801ecb:	83 ec 0c             	sub    $0xc,%esp
  801ece:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed1:	e8 ef fe ff ff       	call   801dc5 <get_block_size>
  801ed6:	83 c4 10             	add    $0x10,%esp
  801ed9:	83 ec 04             	sub    $0x4,%esp
  801edc:	53                   	push   %ebx
  801edd:	50                   	push   %eax
  801ede:	68 2b 43 80 00       	push   $0x80432b
  801ee3:	e8 a2 e4 ff ff       	call   80038a <cprintf>
  801ee8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  801eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef5:	74 07                	je     801efe <print_blocks_list+0x73>
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	8b 00                	mov    (%eax),%eax
  801efc:	eb 05                	jmp    801f03 <print_blocks_list+0x78>
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax
  801f03:	89 45 10             	mov    %eax,0x10(%ebp)
  801f06:	8b 45 10             	mov    0x10(%ebp),%eax
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	75 ad                	jne    801eba <print_blocks_list+0x2f>
  801f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f11:	75 a7                	jne    801eba <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f13:	83 ec 0c             	sub    $0xc,%esp
  801f16:	68 e8 42 80 00       	push   $0x8042e8
  801f1b:	e8 6a e4 ff ff       	call   80038a <cprintf>
  801f20:	83 c4 10             	add    $0x10,%esp

}
  801f23:	90                   	nop
  801f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f32:	83 e0 01             	and    $0x1,%eax
  801f35:	85 c0                	test   %eax,%eax
  801f37:	74 03                	je     801f3c <initialize_dynamic_allocator+0x13>
  801f39:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f40:	0f 84 c7 01 00 00    	je     80210d <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f46:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f4d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f50:	8b 55 08             	mov    0x8(%ebp),%edx
  801f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f56:	01 d0                	add    %edx,%eax
  801f58:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f5d:	0f 87 ad 01 00 00    	ja     802110 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	85 c0                	test   %eax,%eax
  801f68:	0f 89 a5 01 00 00    	jns    802113 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f74:	01 d0                	add    %edx,%eax
  801f76:	83 e8 04             	sub    $0x4,%eax
  801f79:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f85:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8d:	e9 87 00 00 00       	jmp    802019 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f96:	75 14                	jne    801fac <initialize_dynamic_allocator+0x83>
  801f98:	83 ec 04             	sub    $0x4,%esp
  801f9b:	68 43 43 80 00       	push   $0x804343
  801fa0:	6a 79                	push   $0x79
  801fa2:	68 61 43 80 00       	push   $0x804361
  801fa7:	e8 ee 18 00 00       	call   80389a <_panic>
  801fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faf:	8b 00                	mov    (%eax),%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	74 10                	je     801fc5 <initialize_dynamic_allocator+0x9c>
  801fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb8:	8b 00                	mov    (%eax),%eax
  801fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbd:	8b 52 04             	mov    0x4(%edx),%edx
  801fc0:	89 50 04             	mov    %edx,0x4(%eax)
  801fc3:	eb 0b                	jmp    801fd0 <initialize_dynamic_allocator+0xa7>
  801fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc8:	8b 40 04             	mov    0x4(%eax),%eax
  801fcb:	a3 30 50 80 00       	mov    %eax,0x805030
  801fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd3:	8b 40 04             	mov    0x4(%eax),%eax
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	74 0f                	je     801fe9 <initialize_dynamic_allocator+0xc0>
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	8b 40 04             	mov    0x4(%eax),%eax
  801fe0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe3:	8b 12                	mov    (%edx),%edx
  801fe5:	89 10                	mov    %edx,(%eax)
  801fe7:	eb 0a                	jmp    801ff3 <initialize_dynamic_allocator+0xca>
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	8b 00                	mov    (%eax),%eax
  801fee:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802006:	a1 38 50 80 00       	mov    0x805038,%eax
  80200b:	48                   	dec    %eax
  80200c:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802011:	a1 34 50 80 00       	mov    0x805034,%eax
  802016:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802019:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80201d:	74 07                	je     802026 <initialize_dynamic_allocator+0xfd>
  80201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802022:	8b 00                	mov    (%eax),%eax
  802024:	eb 05                	jmp    80202b <initialize_dynamic_allocator+0x102>
  802026:	b8 00 00 00 00       	mov    $0x0,%eax
  80202b:	a3 34 50 80 00       	mov    %eax,0x805034
  802030:	a1 34 50 80 00       	mov    0x805034,%eax
  802035:	85 c0                	test   %eax,%eax
  802037:	0f 85 55 ff ff ff    	jne    801f92 <initialize_dynamic_allocator+0x69>
  80203d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802041:	0f 85 4b ff ff ff    	jne    801f92 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80204d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802050:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802056:	a1 44 50 80 00       	mov    0x805044,%eax
  80205b:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802060:	a1 40 50 80 00       	mov    0x805040,%eax
  802065:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	83 c0 08             	add    $0x8,%eax
  802071:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	83 c0 04             	add    $0x4,%eax
  80207a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207d:	83 ea 08             	sub    $0x8,%edx
  802080:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802082:	8b 55 0c             	mov    0xc(%ebp),%edx
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	01 d0                	add    %edx,%eax
  80208a:	83 e8 08             	sub    $0x8,%eax
  80208d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802090:	83 ea 08             	sub    $0x8,%edx
  802093:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802098:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80209e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020ac:	75 17                	jne    8020c5 <initialize_dynamic_allocator+0x19c>
  8020ae:	83 ec 04             	sub    $0x4,%esp
  8020b1:	68 7c 43 80 00       	push   $0x80437c
  8020b6:	68 90 00 00 00       	push   $0x90
  8020bb:	68 61 43 80 00       	push   $0x804361
  8020c0:	e8 d5 17 00 00       	call   80389a <_panic>
  8020c5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ce:	89 10                	mov    %edx,(%eax)
  8020d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d3:	8b 00                	mov    (%eax),%eax
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	74 0d                	je     8020e6 <initialize_dynamic_allocator+0x1bd>
  8020d9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020e1:	89 50 04             	mov    %edx,0x4(%eax)
  8020e4:	eb 08                	jmp    8020ee <initialize_dynamic_allocator+0x1c5>
  8020e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8020ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802100:	a1 38 50 80 00       	mov    0x805038,%eax
  802105:	40                   	inc    %eax
  802106:	a3 38 50 80 00       	mov    %eax,0x805038
  80210b:	eb 07                	jmp    802114 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80210d:	90                   	nop
  80210e:	eb 04                	jmp    802114 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802110:	90                   	nop
  802111:	eb 01                	jmp    802114 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802113:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802119:	8b 45 10             	mov    0x10(%ebp),%eax
  80211c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	8d 50 fc             	lea    -0x4(%eax),%edx
  802125:	8b 45 0c             	mov    0xc(%ebp),%eax
  802128:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	83 e8 04             	sub    $0x4,%eax
  802130:	8b 00                	mov    (%eax),%eax
  802132:	83 e0 fe             	and    $0xfffffffe,%eax
  802135:	8d 50 f8             	lea    -0x8(%eax),%edx
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	01 c2                	add    %eax,%edx
  80213d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802140:	89 02                	mov    %eax,(%edx)
}
  802142:	90                   	nop
  802143:	5d                   	pop    %ebp
  802144:	c3                   	ret    

00802145 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	83 e0 01             	and    $0x1,%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	74 03                	je     802158 <alloc_block_FF+0x13>
  802155:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802158:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80215c:	77 07                	ja     802165 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80215e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802165:	a1 24 50 80 00       	mov    0x805024,%eax
  80216a:	85 c0                	test   %eax,%eax
  80216c:	75 73                	jne    8021e1 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	83 c0 10             	add    $0x10,%eax
  802174:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802177:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80217e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802181:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802184:	01 d0                	add    %edx,%eax
  802186:	48                   	dec    %eax
  802187:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80218a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80218d:	ba 00 00 00 00       	mov    $0x0,%edx
  802192:	f7 75 ec             	divl   -0x14(%ebp)
  802195:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802198:	29 d0                	sub    %edx,%eax
  80219a:	c1 e8 0c             	shr    $0xc,%eax
  80219d:	83 ec 0c             	sub    $0xc,%esp
  8021a0:	50                   	push   %eax
  8021a1:	e8 86 f1 ff ff       	call   80132c <sbrk>
  8021a6:	83 c4 10             	add    $0x10,%esp
  8021a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021ac:	83 ec 0c             	sub    $0xc,%esp
  8021af:	6a 00                	push   $0x0
  8021b1:	e8 76 f1 ff ff       	call   80132c <sbrk>
  8021b6:	83 c4 10             	add    $0x10,%esp
  8021b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8021bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021bf:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8021c2:	83 ec 08             	sub    $0x8,%esp
  8021c5:	50                   	push   %eax
  8021c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021c9:	e8 5b fd ff ff       	call   801f29 <initialize_dynamic_allocator>
  8021ce:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8021d1:	83 ec 0c             	sub    $0xc,%esp
  8021d4:	68 9f 43 80 00       	push   $0x80439f
  8021d9:	e8 ac e1 ff ff       	call   80038a <cprintf>
  8021de:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8021e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e5:	75 0a                	jne    8021f1 <alloc_block_FF+0xac>
	        return NULL;
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ec:	e9 0e 04 00 00       	jmp    8025ff <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8021f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8021f8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802200:	e9 f3 02 00 00       	jmp    8024f8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80220b:	83 ec 0c             	sub    $0xc,%esp
  80220e:	ff 75 bc             	pushl  -0x44(%ebp)
  802211:	e8 af fb ff ff       	call   801dc5 <get_block_size>
  802216:	83 c4 10             	add    $0x10,%esp
  802219:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	83 c0 08             	add    $0x8,%eax
  802222:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802225:	0f 87 c5 02 00 00    	ja     8024f0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	83 c0 18             	add    $0x18,%eax
  802231:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802234:	0f 87 19 02 00 00    	ja     802453 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80223a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80223d:	2b 45 08             	sub    0x8(%ebp),%eax
  802240:	83 e8 08             	sub    $0x8,%eax
  802243:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	8d 50 08             	lea    0x8(%eax),%edx
  80224c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80224f:	01 d0                	add    %edx,%eax
  802251:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	83 c0 08             	add    $0x8,%eax
  80225a:	83 ec 04             	sub    $0x4,%esp
  80225d:	6a 01                	push   $0x1
  80225f:	50                   	push   %eax
  802260:	ff 75 bc             	pushl  -0x44(%ebp)
  802263:	e8 ae fe ff ff       	call   802116 <set_block_data>
  802268:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 40 04             	mov    0x4(%eax),%eax
  802271:	85 c0                	test   %eax,%eax
  802273:	75 68                	jne    8022dd <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802275:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802279:	75 17                	jne    802292 <alloc_block_FF+0x14d>
  80227b:	83 ec 04             	sub    $0x4,%esp
  80227e:	68 7c 43 80 00       	push   $0x80437c
  802283:	68 d7 00 00 00       	push   $0xd7
  802288:	68 61 43 80 00       	push   $0x804361
  80228d:	e8 08 16 00 00       	call   80389a <_panic>
  802292:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802298:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80229b:	89 10                	mov    %edx,(%eax)
  80229d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022a0:	8b 00                	mov    (%eax),%eax
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	74 0d                	je     8022b3 <alloc_block_FF+0x16e>
  8022a6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022ab:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022ae:	89 50 04             	mov    %edx,0x4(%eax)
  8022b1:	eb 08                	jmp    8022bb <alloc_block_FF+0x176>
  8022b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8022bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8022d2:	40                   	inc    %eax
  8022d3:	a3 38 50 80 00       	mov    %eax,0x805038
  8022d8:	e9 dc 00 00 00       	jmp    8023b9 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8022dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e0:	8b 00                	mov    (%eax),%eax
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	75 65                	jne    80234b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022e6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022ea:	75 17                	jne    802303 <alloc_block_FF+0x1be>
  8022ec:	83 ec 04             	sub    $0x4,%esp
  8022ef:	68 b0 43 80 00       	push   $0x8043b0
  8022f4:	68 db 00 00 00       	push   $0xdb
  8022f9:	68 61 43 80 00       	push   $0x804361
  8022fe:	e8 97 15 00 00       	call   80389a <_panic>
  802303:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802309:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80230c:	89 50 04             	mov    %edx,0x4(%eax)
  80230f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802312:	8b 40 04             	mov    0x4(%eax),%eax
  802315:	85 c0                	test   %eax,%eax
  802317:	74 0c                	je     802325 <alloc_block_FF+0x1e0>
  802319:	a1 30 50 80 00       	mov    0x805030,%eax
  80231e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802321:	89 10                	mov    %edx,(%eax)
  802323:	eb 08                	jmp    80232d <alloc_block_FF+0x1e8>
  802325:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802328:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80232d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802330:	a3 30 50 80 00       	mov    %eax,0x805030
  802335:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233e:	a1 38 50 80 00       	mov    0x805038,%eax
  802343:	40                   	inc    %eax
  802344:	a3 38 50 80 00       	mov    %eax,0x805038
  802349:	eb 6e                	jmp    8023b9 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80234b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234f:	74 06                	je     802357 <alloc_block_FF+0x212>
  802351:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802355:	75 17                	jne    80236e <alloc_block_FF+0x229>
  802357:	83 ec 04             	sub    $0x4,%esp
  80235a:	68 d4 43 80 00       	push   $0x8043d4
  80235f:	68 df 00 00 00       	push   $0xdf
  802364:	68 61 43 80 00       	push   $0x804361
  802369:	e8 2c 15 00 00       	call   80389a <_panic>
  80236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802371:	8b 10                	mov    (%eax),%edx
  802373:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802376:	89 10                	mov    %edx,(%eax)
  802378:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80237b:	8b 00                	mov    (%eax),%eax
  80237d:	85 c0                	test   %eax,%eax
  80237f:	74 0b                	je     80238c <alloc_block_FF+0x247>
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 00                	mov    (%eax),%eax
  802386:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802389:	89 50 04             	mov    %edx,0x4(%eax)
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802392:	89 10                	mov    %edx,(%eax)
  802394:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802397:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239a:	89 50 04             	mov    %edx,0x4(%eax)
  80239d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	75 08                	jne    8023ae <alloc_block_FF+0x269>
  8023a6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8023b3:	40                   	inc    %eax
  8023b4:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bd:	75 17                	jne    8023d6 <alloc_block_FF+0x291>
  8023bf:	83 ec 04             	sub    $0x4,%esp
  8023c2:	68 43 43 80 00       	push   $0x804343
  8023c7:	68 e1 00 00 00       	push   $0xe1
  8023cc:	68 61 43 80 00       	push   $0x804361
  8023d1:	e8 c4 14 00 00       	call   80389a <_panic>
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	8b 00                	mov    (%eax),%eax
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	74 10                	je     8023ef <alloc_block_FF+0x2aa>
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 00                	mov    (%eax),%eax
  8023e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e7:	8b 52 04             	mov    0x4(%edx),%edx
  8023ea:	89 50 04             	mov    %edx,0x4(%eax)
  8023ed:	eb 0b                	jmp    8023fa <alloc_block_FF+0x2b5>
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 40 04             	mov    0x4(%eax),%eax
  8023f5:	a3 30 50 80 00       	mov    %eax,0x805030
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 40 04             	mov    0x4(%eax),%eax
  802400:	85 c0                	test   %eax,%eax
  802402:	74 0f                	je     802413 <alloc_block_FF+0x2ce>
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 40 04             	mov    0x4(%eax),%eax
  80240a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240d:	8b 12                	mov    (%edx),%edx
  80240f:	89 10                	mov    %edx,(%eax)
  802411:	eb 0a                	jmp    80241d <alloc_block_FF+0x2d8>
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 00                	mov    (%eax),%eax
  802418:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802430:	a1 38 50 80 00       	mov    0x805038,%eax
  802435:	48                   	dec    %eax
  802436:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80243b:	83 ec 04             	sub    $0x4,%esp
  80243e:	6a 00                	push   $0x0
  802440:	ff 75 b4             	pushl  -0x4c(%ebp)
  802443:	ff 75 b0             	pushl  -0x50(%ebp)
  802446:	e8 cb fc ff ff       	call   802116 <set_block_data>
  80244b:	83 c4 10             	add    $0x10,%esp
  80244e:	e9 95 00 00 00       	jmp    8024e8 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802453:	83 ec 04             	sub    $0x4,%esp
  802456:	6a 01                	push   $0x1
  802458:	ff 75 b8             	pushl  -0x48(%ebp)
  80245b:	ff 75 bc             	pushl  -0x44(%ebp)
  80245e:	e8 b3 fc ff ff       	call   802116 <set_block_data>
  802463:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246a:	75 17                	jne    802483 <alloc_block_FF+0x33e>
  80246c:	83 ec 04             	sub    $0x4,%esp
  80246f:	68 43 43 80 00       	push   $0x804343
  802474:	68 e8 00 00 00       	push   $0xe8
  802479:	68 61 43 80 00       	push   $0x804361
  80247e:	e8 17 14 00 00       	call   80389a <_panic>
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 00                	mov    (%eax),%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	74 10                	je     80249c <alloc_block_FF+0x357>
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802494:	8b 52 04             	mov    0x4(%edx),%edx
  802497:	89 50 04             	mov    %edx,0x4(%eax)
  80249a:	eb 0b                	jmp    8024a7 <alloc_block_FF+0x362>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 40 04             	mov    0x4(%eax),%eax
  8024a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 40 04             	mov    0x4(%eax),%eax
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	74 0f                	je     8024c0 <alloc_block_FF+0x37b>
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ba:	8b 12                	mov    (%edx),%edx
  8024bc:	89 10                	mov    %edx,(%eax)
  8024be:	eb 0a                	jmp    8024ca <alloc_block_FF+0x385>
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8024e2:	48                   	dec    %eax
  8024e3:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8024e8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024eb:	e9 0f 01 00 00       	jmp    8025ff <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024f0:	a1 34 50 80 00       	mov    0x805034,%eax
  8024f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fc:	74 07                	je     802505 <alloc_block_FF+0x3c0>
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 00                	mov    (%eax),%eax
  802503:	eb 05                	jmp    80250a <alloc_block_FF+0x3c5>
  802505:	b8 00 00 00 00       	mov    $0x0,%eax
  80250a:	a3 34 50 80 00       	mov    %eax,0x805034
  80250f:	a1 34 50 80 00       	mov    0x805034,%eax
  802514:	85 c0                	test   %eax,%eax
  802516:	0f 85 e9 fc ff ff    	jne    802205 <alloc_block_FF+0xc0>
  80251c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802520:	0f 85 df fc ff ff    	jne    802205 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802526:	8b 45 08             	mov    0x8(%ebp),%eax
  802529:	83 c0 08             	add    $0x8,%eax
  80252c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80252f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802536:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802539:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80253c:	01 d0                	add    %edx,%eax
  80253e:	48                   	dec    %eax
  80253f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802542:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802545:	ba 00 00 00 00       	mov    $0x0,%edx
  80254a:	f7 75 d8             	divl   -0x28(%ebp)
  80254d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802550:	29 d0                	sub    %edx,%eax
  802552:	c1 e8 0c             	shr    $0xc,%eax
  802555:	83 ec 0c             	sub    $0xc,%esp
  802558:	50                   	push   %eax
  802559:	e8 ce ed ff ff       	call   80132c <sbrk>
  80255e:	83 c4 10             	add    $0x10,%esp
  802561:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802564:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802568:	75 0a                	jne    802574 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80256a:	b8 00 00 00 00       	mov    $0x0,%eax
  80256f:	e9 8b 00 00 00       	jmp    8025ff <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802574:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80257b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80257e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802581:	01 d0                	add    %edx,%eax
  802583:	48                   	dec    %eax
  802584:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802587:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80258a:	ba 00 00 00 00       	mov    $0x0,%edx
  80258f:	f7 75 cc             	divl   -0x34(%ebp)
  802592:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802595:	29 d0                	sub    %edx,%eax
  802597:	8d 50 fc             	lea    -0x4(%eax),%edx
  80259a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80259d:	01 d0                	add    %edx,%eax
  80259f:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8025a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8025a9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025af:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025bc:	01 d0                	add    %edx,%eax
  8025be:	48                   	dec    %eax
  8025bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8025c2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ca:	f7 75 c4             	divl   -0x3c(%ebp)
  8025cd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025d0:	29 d0                	sub    %edx,%eax
  8025d2:	83 ec 04             	sub    $0x4,%esp
  8025d5:	6a 01                	push   $0x1
  8025d7:	50                   	push   %eax
  8025d8:	ff 75 d0             	pushl  -0x30(%ebp)
  8025db:	e8 36 fb ff ff       	call   802116 <set_block_data>
  8025e0:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	ff 75 d0             	pushl  -0x30(%ebp)
  8025e9:	e8 1b 0a 00 00       	call   803009 <free_block>
  8025ee:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8025f1:	83 ec 0c             	sub    $0xc,%esp
  8025f4:	ff 75 08             	pushl  0x8(%ebp)
  8025f7:	e8 49 fb ff ff       	call   802145 <alloc_block_FF>
  8025fc:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8025ff:	c9                   	leave  
  802600:	c3                   	ret    

00802601 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802601:	55                   	push   %ebp
  802602:	89 e5                	mov    %esp,%ebp
  802604:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802607:	8b 45 08             	mov    0x8(%ebp),%eax
  80260a:	83 e0 01             	and    $0x1,%eax
  80260d:	85 c0                	test   %eax,%eax
  80260f:	74 03                	je     802614 <alloc_block_BF+0x13>
  802611:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802614:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802618:	77 07                	ja     802621 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80261a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802621:	a1 24 50 80 00       	mov    0x805024,%eax
  802626:	85 c0                	test   %eax,%eax
  802628:	75 73                	jne    80269d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80262a:	8b 45 08             	mov    0x8(%ebp),%eax
  80262d:	83 c0 10             	add    $0x10,%eax
  802630:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802633:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80263a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80263d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802640:	01 d0                	add    %edx,%eax
  802642:	48                   	dec    %eax
  802643:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802646:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802649:	ba 00 00 00 00       	mov    $0x0,%edx
  80264e:	f7 75 e0             	divl   -0x20(%ebp)
  802651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802654:	29 d0                	sub    %edx,%eax
  802656:	c1 e8 0c             	shr    $0xc,%eax
  802659:	83 ec 0c             	sub    $0xc,%esp
  80265c:	50                   	push   %eax
  80265d:	e8 ca ec ff ff       	call   80132c <sbrk>
  802662:	83 c4 10             	add    $0x10,%esp
  802665:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802668:	83 ec 0c             	sub    $0xc,%esp
  80266b:	6a 00                	push   $0x0
  80266d:	e8 ba ec ff ff       	call   80132c <sbrk>
  802672:	83 c4 10             	add    $0x10,%esp
  802675:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80267b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80267e:	83 ec 08             	sub    $0x8,%esp
  802681:	50                   	push   %eax
  802682:	ff 75 d8             	pushl  -0x28(%ebp)
  802685:	e8 9f f8 ff ff       	call   801f29 <initialize_dynamic_allocator>
  80268a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80268d:	83 ec 0c             	sub    $0xc,%esp
  802690:	68 9f 43 80 00       	push   $0x80439f
  802695:	e8 f0 dc ff ff       	call   80038a <cprintf>
  80269a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80269d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026ab:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8026b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026b9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c1:	e9 1d 01 00 00       	jmp    8027e3 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8026cc:	83 ec 0c             	sub    $0xc,%esp
  8026cf:	ff 75 a8             	pushl  -0x58(%ebp)
  8026d2:	e8 ee f6 ff ff       	call   801dc5 <get_block_size>
  8026d7:	83 c4 10             	add    $0x10,%esp
  8026da:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8026dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e0:	83 c0 08             	add    $0x8,%eax
  8026e3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026e6:	0f 87 ef 00 00 00    	ja     8027db <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8026ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ef:	83 c0 18             	add    $0x18,%eax
  8026f2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026f5:	77 1d                	ja     802714 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8026f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fa:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026fd:	0f 86 d8 00 00 00    	jbe    8027db <alloc_block_BF+0x1da>
				{
					best_va = va;
  802703:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802706:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802709:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80270c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80270f:	e9 c7 00 00 00       	jmp    8027db <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	83 c0 08             	add    $0x8,%eax
  80271a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80271d:	0f 85 9d 00 00 00    	jne    8027c0 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802723:	83 ec 04             	sub    $0x4,%esp
  802726:	6a 01                	push   $0x1
  802728:	ff 75 a4             	pushl  -0x5c(%ebp)
  80272b:	ff 75 a8             	pushl  -0x58(%ebp)
  80272e:	e8 e3 f9 ff ff       	call   802116 <set_block_data>
  802733:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802736:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273a:	75 17                	jne    802753 <alloc_block_BF+0x152>
  80273c:	83 ec 04             	sub    $0x4,%esp
  80273f:	68 43 43 80 00       	push   $0x804343
  802744:	68 2c 01 00 00       	push   $0x12c
  802749:	68 61 43 80 00       	push   $0x804361
  80274e:	e8 47 11 00 00       	call   80389a <_panic>
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 00                	mov    (%eax),%eax
  802758:	85 c0                	test   %eax,%eax
  80275a:	74 10                	je     80276c <alloc_block_BF+0x16b>
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	8b 00                	mov    (%eax),%eax
  802761:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802764:	8b 52 04             	mov    0x4(%edx),%edx
  802767:	89 50 04             	mov    %edx,0x4(%eax)
  80276a:	eb 0b                	jmp    802777 <alloc_block_BF+0x176>
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 40 04             	mov    0x4(%eax),%eax
  802772:	a3 30 50 80 00       	mov    %eax,0x805030
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 40 04             	mov    0x4(%eax),%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	74 0f                	je     802790 <alloc_block_BF+0x18f>
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 40 04             	mov    0x4(%eax),%eax
  802787:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278a:	8b 12                	mov    (%edx),%edx
  80278c:	89 10                	mov    %edx,(%eax)
  80278e:	eb 0a                	jmp    80279a <alloc_block_BF+0x199>
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 00                	mov    (%eax),%eax
  802795:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8027b2:	48                   	dec    %eax
  8027b3:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8027b8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027bb:	e9 24 04 00 00       	jmp    802be4 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8027c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027c6:	76 13                	jbe    8027db <alloc_block_BF+0x1da>
					{
						internal = 1;
  8027c8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8027cf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8027d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027d8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8027db:	a1 34 50 80 00       	mov    0x805034,%eax
  8027e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e7:	74 07                	je     8027f0 <alloc_block_BF+0x1ef>
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	eb 05                	jmp    8027f5 <alloc_block_BF+0x1f4>
  8027f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f5:	a3 34 50 80 00       	mov    %eax,0x805034
  8027fa:	a1 34 50 80 00       	mov    0x805034,%eax
  8027ff:	85 c0                	test   %eax,%eax
  802801:	0f 85 bf fe ff ff    	jne    8026c6 <alloc_block_BF+0xc5>
  802807:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280b:	0f 85 b5 fe ff ff    	jne    8026c6 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802815:	0f 84 26 02 00 00    	je     802a41 <alloc_block_BF+0x440>
  80281b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80281f:	0f 85 1c 02 00 00    	jne    802a41 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802828:	2b 45 08             	sub    0x8(%ebp),%eax
  80282b:	83 e8 08             	sub    $0x8,%eax
  80282e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	8d 50 08             	lea    0x8(%eax),%edx
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	01 d0                	add    %edx,%eax
  80283c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	83 c0 08             	add    $0x8,%eax
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	6a 01                	push   $0x1
  80284a:	50                   	push   %eax
  80284b:	ff 75 f0             	pushl  -0x10(%ebp)
  80284e:	e8 c3 f8 ff ff       	call   802116 <set_block_data>
  802853:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802859:	8b 40 04             	mov    0x4(%eax),%eax
  80285c:	85 c0                	test   %eax,%eax
  80285e:	75 68                	jne    8028c8 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802860:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802864:	75 17                	jne    80287d <alloc_block_BF+0x27c>
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	68 7c 43 80 00       	push   $0x80437c
  80286e:	68 45 01 00 00       	push   $0x145
  802873:	68 61 43 80 00       	push   $0x804361
  802878:	e8 1d 10 00 00       	call   80389a <_panic>
  80287d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802883:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802886:	89 10                	mov    %edx,(%eax)
  802888:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	74 0d                	je     80289e <alloc_block_BF+0x29d>
  802891:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802896:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802899:	89 50 04             	mov    %edx,0x4(%eax)
  80289c:	eb 08                	jmp    8028a6 <alloc_block_BF+0x2a5>
  80289e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8028a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8028bd:	40                   	inc    %eax
  8028be:	a3 38 50 80 00       	mov    %eax,0x805038
  8028c3:	e9 dc 00 00 00       	jmp    8029a4 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	75 65                	jne    802936 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028d5:	75 17                	jne    8028ee <alloc_block_BF+0x2ed>
  8028d7:	83 ec 04             	sub    $0x4,%esp
  8028da:	68 b0 43 80 00       	push   $0x8043b0
  8028df:	68 4a 01 00 00       	push   $0x14a
  8028e4:	68 61 43 80 00       	push   $0x804361
  8028e9:	e8 ac 0f 00 00       	call   80389a <_panic>
  8028ee:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f7:	89 50 04             	mov    %edx,0x4(%eax)
  8028fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028fd:	8b 40 04             	mov    0x4(%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0c                	je     802910 <alloc_block_BF+0x30f>
  802904:	a1 30 50 80 00       	mov    0x805030,%eax
  802909:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80290c:	89 10                	mov    %edx,(%eax)
  80290e:	eb 08                	jmp    802918 <alloc_block_BF+0x317>
  802910:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802913:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802918:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80291b:	a3 30 50 80 00       	mov    %eax,0x805030
  802920:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802923:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802929:	a1 38 50 80 00       	mov    0x805038,%eax
  80292e:	40                   	inc    %eax
  80292f:	a3 38 50 80 00       	mov    %eax,0x805038
  802934:	eb 6e                	jmp    8029a4 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802936:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80293a:	74 06                	je     802942 <alloc_block_BF+0x341>
  80293c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802940:	75 17                	jne    802959 <alloc_block_BF+0x358>
  802942:	83 ec 04             	sub    $0x4,%esp
  802945:	68 d4 43 80 00       	push   $0x8043d4
  80294a:	68 4f 01 00 00       	push   $0x14f
  80294f:	68 61 43 80 00       	push   $0x804361
  802954:	e8 41 0f 00 00       	call   80389a <_panic>
  802959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295c:	8b 10                	mov    (%eax),%edx
  80295e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802961:	89 10                	mov    %edx,(%eax)
  802963:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	85 c0                	test   %eax,%eax
  80296a:	74 0b                	je     802977 <alloc_block_BF+0x376>
  80296c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802974:	89 50 04             	mov    %edx,0x4(%eax)
  802977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80297d:	89 10                	mov    %edx,(%eax)
  80297f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802982:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802985:	89 50 04             	mov    %edx,0x4(%eax)
  802988:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	75 08                	jne    802999 <alloc_block_BF+0x398>
  802991:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802994:	a3 30 50 80 00       	mov    %eax,0x805030
  802999:	a1 38 50 80 00       	mov    0x805038,%eax
  80299e:	40                   	inc    %eax
  80299f:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029a8:	75 17                	jne    8029c1 <alloc_block_BF+0x3c0>
  8029aa:	83 ec 04             	sub    $0x4,%esp
  8029ad:	68 43 43 80 00       	push   $0x804343
  8029b2:	68 51 01 00 00       	push   $0x151
  8029b7:	68 61 43 80 00       	push   $0x804361
  8029bc:	e8 d9 0e 00 00       	call   80389a <_panic>
  8029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c4:	8b 00                	mov    (%eax),%eax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	74 10                	je     8029da <alloc_block_BF+0x3d9>
  8029ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d2:	8b 52 04             	mov    0x4(%edx),%edx
  8029d5:	89 50 04             	mov    %edx,0x4(%eax)
  8029d8:	eb 0b                	jmp    8029e5 <alloc_block_BF+0x3e4>
  8029da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dd:	8b 40 04             	mov    0x4(%eax),%eax
  8029e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8029e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e8:	8b 40 04             	mov    0x4(%eax),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	74 0f                	je     8029fe <alloc_block_BF+0x3fd>
  8029ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f2:	8b 40 04             	mov    0x4(%eax),%eax
  8029f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f8:	8b 12                	mov    (%edx),%edx
  8029fa:	89 10                	mov    %edx,(%eax)
  8029fc:	eb 0a                	jmp    802a08 <alloc_block_BF+0x407>
  8029fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a01:	8b 00                	mov    (%eax),%eax
  802a03:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1b:	a1 38 50 80 00       	mov    0x805038,%eax
  802a20:	48                   	dec    %eax
  802a21:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a26:	83 ec 04             	sub    $0x4,%esp
  802a29:	6a 00                	push   $0x0
  802a2b:	ff 75 d0             	pushl  -0x30(%ebp)
  802a2e:	ff 75 cc             	pushl  -0x34(%ebp)
  802a31:	e8 e0 f6 ff ff       	call   802116 <set_block_data>
  802a36:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3c:	e9 a3 01 00 00       	jmp    802be4 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a41:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a45:	0f 85 9d 00 00 00    	jne    802ae8 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a4b:	83 ec 04             	sub    $0x4,%esp
  802a4e:	6a 01                	push   $0x1
  802a50:	ff 75 ec             	pushl  -0x14(%ebp)
  802a53:	ff 75 f0             	pushl  -0x10(%ebp)
  802a56:	e8 bb f6 ff ff       	call   802116 <set_block_data>
  802a5b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a62:	75 17                	jne    802a7b <alloc_block_BF+0x47a>
  802a64:	83 ec 04             	sub    $0x4,%esp
  802a67:	68 43 43 80 00       	push   $0x804343
  802a6c:	68 58 01 00 00       	push   $0x158
  802a71:	68 61 43 80 00       	push   $0x804361
  802a76:	e8 1f 0e 00 00       	call   80389a <_panic>
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 10                	je     802a94 <alloc_block_BF+0x493>
  802a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8c:	8b 52 04             	mov    0x4(%edx),%edx
  802a8f:	89 50 04             	mov    %edx,0x4(%eax)
  802a92:	eb 0b                	jmp    802a9f <alloc_block_BF+0x49e>
  802a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a97:	8b 40 04             	mov    0x4(%eax),%eax
  802a9a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 0f                	je     802ab8 <alloc_block_BF+0x4b7>
  802aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aac:	8b 40 04             	mov    0x4(%eax),%eax
  802aaf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab2:	8b 12                	mov    (%edx),%edx
  802ab4:	89 10                	mov    %edx,(%eax)
  802ab6:	eb 0a                	jmp    802ac2 <alloc_block_BF+0x4c1>
  802ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad5:	a1 38 50 80 00       	mov    0x805038,%eax
  802ada:	48                   	dec    %eax
  802adb:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	e9 fc 00 00 00       	jmp    802be4 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	83 c0 08             	add    $0x8,%eax
  802aee:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802af1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802af8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802afb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802afe:	01 d0                	add    %edx,%eax
  802b00:	48                   	dec    %eax
  802b01:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b07:	ba 00 00 00 00       	mov    $0x0,%edx
  802b0c:	f7 75 c4             	divl   -0x3c(%ebp)
  802b0f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b12:	29 d0                	sub    %edx,%eax
  802b14:	c1 e8 0c             	shr    $0xc,%eax
  802b17:	83 ec 0c             	sub    $0xc,%esp
  802b1a:	50                   	push   %eax
  802b1b:	e8 0c e8 ff ff       	call   80132c <sbrk>
  802b20:	83 c4 10             	add    $0x10,%esp
  802b23:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b26:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b2a:	75 0a                	jne    802b36 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b31:	e9 ae 00 00 00       	jmp    802be4 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b36:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b3d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b40:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b43:	01 d0                	add    %edx,%eax
  802b45:	48                   	dec    %eax
  802b46:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b49:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b4c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b51:	f7 75 b8             	divl   -0x48(%ebp)
  802b54:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b57:	29 d0                	sub    %edx,%eax
  802b59:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b5c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b5f:	01 d0                	add    %edx,%eax
  802b61:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b66:	a1 40 50 80 00       	mov    0x805040,%eax
  802b6b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b71:	83 ec 0c             	sub    $0xc,%esp
  802b74:	68 08 44 80 00       	push   $0x804408
  802b79:	e8 0c d8 ff ff       	call   80038a <cprintf>
  802b7e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802b81:	83 ec 08             	sub    $0x8,%esp
  802b84:	ff 75 bc             	pushl  -0x44(%ebp)
  802b87:	68 0d 44 80 00       	push   $0x80440d
  802b8c:	e8 f9 d7 ff ff       	call   80038a <cprintf>
  802b91:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b94:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b9b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b9e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ba1:	01 d0                	add    %edx,%eax
  802ba3:	48                   	dec    %eax
  802ba4:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ba7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802baa:	ba 00 00 00 00       	mov    $0x0,%edx
  802baf:	f7 75 b0             	divl   -0x50(%ebp)
  802bb2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bb5:	29 d0                	sub    %edx,%eax
  802bb7:	83 ec 04             	sub    $0x4,%esp
  802bba:	6a 01                	push   $0x1
  802bbc:	50                   	push   %eax
  802bbd:	ff 75 bc             	pushl  -0x44(%ebp)
  802bc0:	e8 51 f5 ff ff       	call   802116 <set_block_data>
  802bc5:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802bc8:	83 ec 0c             	sub    $0xc,%esp
  802bcb:	ff 75 bc             	pushl  -0x44(%ebp)
  802bce:	e8 36 04 00 00       	call   803009 <free_block>
  802bd3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802bd6:	83 ec 0c             	sub    $0xc,%esp
  802bd9:	ff 75 08             	pushl  0x8(%ebp)
  802bdc:	e8 20 fa ff ff       	call   802601 <alloc_block_BF>
  802be1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802be4:	c9                   	leave  
  802be5:	c3                   	ret    

00802be6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802be6:	55                   	push   %ebp
  802be7:	89 e5                	mov    %esp,%ebp
  802be9:	53                   	push   %ebx
  802bea:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802bed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802bf4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bff:	74 1e                	je     802c1f <merging+0x39>
  802c01:	ff 75 08             	pushl  0x8(%ebp)
  802c04:	e8 bc f1 ff ff       	call   801dc5 <get_block_size>
  802c09:	83 c4 04             	add    $0x4,%esp
  802c0c:	89 c2                	mov    %eax,%edx
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	01 d0                	add    %edx,%eax
  802c13:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c16:	75 07                	jne    802c1f <merging+0x39>
		prev_is_free = 1;
  802c18:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c23:	74 1e                	je     802c43 <merging+0x5d>
  802c25:	ff 75 10             	pushl  0x10(%ebp)
  802c28:	e8 98 f1 ff ff       	call   801dc5 <get_block_size>
  802c2d:	83 c4 04             	add    $0x4,%esp
  802c30:	89 c2                	mov    %eax,%edx
  802c32:	8b 45 10             	mov    0x10(%ebp),%eax
  802c35:	01 d0                	add    %edx,%eax
  802c37:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c3a:	75 07                	jne    802c43 <merging+0x5d>
		next_is_free = 1;
  802c3c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c47:	0f 84 cc 00 00 00    	je     802d19 <merging+0x133>
  802c4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c51:	0f 84 c2 00 00 00    	je     802d19 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c57:	ff 75 08             	pushl  0x8(%ebp)
  802c5a:	e8 66 f1 ff ff       	call   801dc5 <get_block_size>
  802c5f:	83 c4 04             	add    $0x4,%esp
  802c62:	89 c3                	mov    %eax,%ebx
  802c64:	ff 75 10             	pushl  0x10(%ebp)
  802c67:	e8 59 f1 ff ff       	call   801dc5 <get_block_size>
  802c6c:	83 c4 04             	add    $0x4,%esp
  802c6f:	01 c3                	add    %eax,%ebx
  802c71:	ff 75 0c             	pushl  0xc(%ebp)
  802c74:	e8 4c f1 ff ff       	call   801dc5 <get_block_size>
  802c79:	83 c4 04             	add    $0x4,%esp
  802c7c:	01 d8                	add    %ebx,%eax
  802c7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c81:	6a 00                	push   $0x0
  802c83:	ff 75 ec             	pushl  -0x14(%ebp)
  802c86:	ff 75 08             	pushl  0x8(%ebp)
  802c89:	e8 88 f4 ff ff       	call   802116 <set_block_data>
  802c8e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c95:	75 17                	jne    802cae <merging+0xc8>
  802c97:	83 ec 04             	sub    $0x4,%esp
  802c9a:	68 43 43 80 00       	push   $0x804343
  802c9f:	68 7d 01 00 00       	push   $0x17d
  802ca4:	68 61 43 80 00       	push   $0x804361
  802ca9:	e8 ec 0b 00 00       	call   80389a <_panic>
  802cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	74 10                	je     802cc7 <merging+0xe1>
  802cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cbf:	8b 52 04             	mov    0x4(%edx),%edx
  802cc2:	89 50 04             	mov    %edx,0x4(%eax)
  802cc5:	eb 0b                	jmp    802cd2 <merging+0xec>
  802cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cca:	8b 40 04             	mov    0x4(%eax),%eax
  802ccd:	a3 30 50 80 00       	mov    %eax,0x805030
  802cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd5:	8b 40 04             	mov    0x4(%eax),%eax
  802cd8:	85 c0                	test   %eax,%eax
  802cda:	74 0f                	je     802ceb <merging+0x105>
  802cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cdf:	8b 40 04             	mov    0x4(%eax),%eax
  802ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ce5:	8b 12                	mov    (%edx),%edx
  802ce7:	89 10                	mov    %edx,(%eax)
  802ce9:	eb 0a                	jmp    802cf5 <merging+0x10f>
  802ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d08:	a1 38 50 80 00       	mov    0x805038,%eax
  802d0d:	48                   	dec    %eax
  802d0e:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d13:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d14:	e9 ea 02 00 00       	jmp    803003 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1d:	74 3b                	je     802d5a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d1f:	83 ec 0c             	sub    $0xc,%esp
  802d22:	ff 75 08             	pushl  0x8(%ebp)
  802d25:	e8 9b f0 ff ff       	call   801dc5 <get_block_size>
  802d2a:	83 c4 10             	add    $0x10,%esp
  802d2d:	89 c3                	mov    %eax,%ebx
  802d2f:	83 ec 0c             	sub    $0xc,%esp
  802d32:	ff 75 10             	pushl  0x10(%ebp)
  802d35:	e8 8b f0 ff ff       	call   801dc5 <get_block_size>
  802d3a:	83 c4 10             	add    $0x10,%esp
  802d3d:	01 d8                	add    %ebx,%eax
  802d3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d42:	83 ec 04             	sub    $0x4,%esp
  802d45:	6a 00                	push   $0x0
  802d47:	ff 75 e8             	pushl  -0x18(%ebp)
  802d4a:	ff 75 08             	pushl  0x8(%ebp)
  802d4d:	e8 c4 f3 ff ff       	call   802116 <set_block_data>
  802d52:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d55:	e9 a9 02 00 00       	jmp    803003 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d5e:	0f 84 2d 01 00 00    	je     802e91 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d64:	83 ec 0c             	sub    $0xc,%esp
  802d67:	ff 75 10             	pushl  0x10(%ebp)
  802d6a:	e8 56 f0 ff ff       	call   801dc5 <get_block_size>
  802d6f:	83 c4 10             	add    $0x10,%esp
  802d72:	89 c3                	mov    %eax,%ebx
  802d74:	83 ec 0c             	sub    $0xc,%esp
  802d77:	ff 75 0c             	pushl  0xc(%ebp)
  802d7a:	e8 46 f0 ff ff       	call   801dc5 <get_block_size>
  802d7f:	83 c4 10             	add    $0x10,%esp
  802d82:	01 d8                	add    %ebx,%eax
  802d84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d87:	83 ec 04             	sub    $0x4,%esp
  802d8a:	6a 00                	push   $0x0
  802d8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d8f:	ff 75 10             	pushl  0x10(%ebp)
  802d92:	e8 7f f3 ff ff       	call   802116 <set_block_data>
  802d97:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d9a:	8b 45 10             	mov    0x10(%ebp),%eax
  802d9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802da0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802da4:	74 06                	je     802dac <merging+0x1c6>
  802da6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802daa:	75 17                	jne    802dc3 <merging+0x1dd>
  802dac:	83 ec 04             	sub    $0x4,%esp
  802daf:	68 1c 44 80 00       	push   $0x80441c
  802db4:	68 8d 01 00 00       	push   $0x18d
  802db9:	68 61 43 80 00       	push   $0x804361
  802dbe:	e8 d7 0a 00 00       	call   80389a <_panic>
  802dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc6:	8b 50 04             	mov    0x4(%eax),%edx
  802dc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dcc:	89 50 04             	mov    %edx,0x4(%eax)
  802dcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dd5:	89 10                	mov    %edx,(%eax)
  802dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	85 c0                	test   %eax,%eax
  802ddf:	74 0d                	je     802dee <merging+0x208>
  802de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dea:	89 10                	mov    %edx,(%eax)
  802dec:	eb 08                	jmp    802df6 <merging+0x210>
  802dee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802dfc:	89 50 04             	mov    %edx,0x4(%eax)
  802dff:	a1 38 50 80 00       	mov    0x805038,%eax
  802e04:	40                   	inc    %eax
  802e05:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e0e:	75 17                	jne    802e27 <merging+0x241>
  802e10:	83 ec 04             	sub    $0x4,%esp
  802e13:	68 43 43 80 00       	push   $0x804343
  802e18:	68 8e 01 00 00       	push   $0x18e
  802e1d:	68 61 43 80 00       	push   $0x804361
  802e22:	e8 73 0a 00 00       	call   80389a <_panic>
  802e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2a:	8b 00                	mov    (%eax),%eax
  802e2c:	85 c0                	test   %eax,%eax
  802e2e:	74 10                	je     802e40 <merging+0x25a>
  802e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e33:	8b 00                	mov    (%eax),%eax
  802e35:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e38:	8b 52 04             	mov    0x4(%edx),%edx
  802e3b:	89 50 04             	mov    %edx,0x4(%eax)
  802e3e:	eb 0b                	jmp    802e4b <merging+0x265>
  802e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e43:	8b 40 04             	mov    0x4(%eax),%eax
  802e46:	a3 30 50 80 00       	mov    %eax,0x805030
  802e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4e:	8b 40 04             	mov    0x4(%eax),%eax
  802e51:	85 c0                	test   %eax,%eax
  802e53:	74 0f                	je     802e64 <merging+0x27e>
  802e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e58:	8b 40 04             	mov    0x4(%eax),%eax
  802e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e5e:	8b 12                	mov    (%edx),%edx
  802e60:	89 10                	mov    %edx,(%eax)
  802e62:	eb 0a                	jmp    802e6e <merging+0x288>
  802e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e67:	8b 00                	mov    (%eax),%eax
  802e69:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e81:	a1 38 50 80 00       	mov    0x805038,%eax
  802e86:	48                   	dec    %eax
  802e87:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e8c:	e9 72 01 00 00       	jmp    803003 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e91:	8b 45 10             	mov    0x10(%ebp),%eax
  802e94:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9b:	74 79                	je     802f16 <merging+0x330>
  802e9d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ea1:	74 73                	je     802f16 <merging+0x330>
  802ea3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea7:	74 06                	je     802eaf <merging+0x2c9>
  802ea9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ead:	75 17                	jne    802ec6 <merging+0x2e0>
  802eaf:	83 ec 04             	sub    $0x4,%esp
  802eb2:	68 d4 43 80 00       	push   $0x8043d4
  802eb7:	68 94 01 00 00       	push   $0x194
  802ebc:	68 61 43 80 00       	push   $0x804361
  802ec1:	e8 d4 09 00 00       	call   80389a <_panic>
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	8b 10                	mov    (%eax),%edx
  802ecb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ece:	89 10                	mov    %edx,(%eax)
  802ed0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed3:	8b 00                	mov    (%eax),%eax
  802ed5:	85 c0                	test   %eax,%eax
  802ed7:	74 0b                	je     802ee4 <merging+0x2fe>
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	8b 00                	mov    (%eax),%eax
  802ede:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ee1:	89 50 04             	mov    %edx,0x4(%eax)
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eea:	89 10                	mov    %edx,(%eax)
  802eec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eef:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef2:	89 50 04             	mov    %edx,0x4(%eax)
  802ef5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef8:	8b 00                	mov    (%eax),%eax
  802efa:	85 c0                	test   %eax,%eax
  802efc:	75 08                	jne    802f06 <merging+0x320>
  802efe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f01:	a3 30 50 80 00       	mov    %eax,0x805030
  802f06:	a1 38 50 80 00       	mov    0x805038,%eax
  802f0b:	40                   	inc    %eax
  802f0c:	a3 38 50 80 00       	mov    %eax,0x805038
  802f11:	e9 ce 00 00 00       	jmp    802fe4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1a:	74 65                	je     802f81 <merging+0x39b>
  802f1c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f20:	75 17                	jne    802f39 <merging+0x353>
  802f22:	83 ec 04             	sub    $0x4,%esp
  802f25:	68 b0 43 80 00       	push   $0x8043b0
  802f2a:	68 95 01 00 00       	push   $0x195
  802f2f:	68 61 43 80 00       	push   $0x804361
  802f34:	e8 61 09 00 00       	call   80389a <_panic>
  802f39:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f42:	89 50 04             	mov    %edx,0x4(%eax)
  802f45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f48:	8b 40 04             	mov    0x4(%eax),%eax
  802f4b:	85 c0                	test   %eax,%eax
  802f4d:	74 0c                	je     802f5b <merging+0x375>
  802f4f:	a1 30 50 80 00       	mov    0x805030,%eax
  802f54:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f57:	89 10                	mov    %edx,(%eax)
  802f59:	eb 08                	jmp    802f63 <merging+0x37d>
  802f5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f66:	a3 30 50 80 00       	mov    %eax,0x805030
  802f6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f74:	a1 38 50 80 00       	mov    0x805038,%eax
  802f79:	40                   	inc    %eax
  802f7a:	a3 38 50 80 00       	mov    %eax,0x805038
  802f7f:	eb 63                	jmp    802fe4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f81:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f85:	75 17                	jne    802f9e <merging+0x3b8>
  802f87:	83 ec 04             	sub    $0x4,%esp
  802f8a:	68 7c 43 80 00       	push   $0x80437c
  802f8f:	68 98 01 00 00       	push   $0x198
  802f94:	68 61 43 80 00       	push   $0x804361
  802f99:	e8 fc 08 00 00       	call   80389a <_panic>
  802f9e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802fa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa7:	89 10                	mov    %edx,(%eax)
  802fa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0d                	je     802fbf <merging+0x3d9>
  802fb2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fba:	89 50 04             	mov    %edx,0x4(%eax)
  802fbd:	eb 08                	jmp    802fc7 <merging+0x3e1>
  802fbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc2:	a3 30 50 80 00       	mov    %eax,0x805030
  802fc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fca:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd9:	a1 38 50 80 00       	mov    0x805038,%eax
  802fde:	40                   	inc    %eax
  802fdf:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802fe4:	83 ec 0c             	sub    $0xc,%esp
  802fe7:	ff 75 10             	pushl  0x10(%ebp)
  802fea:	e8 d6 ed ff ff       	call   801dc5 <get_block_size>
  802fef:	83 c4 10             	add    $0x10,%esp
  802ff2:	83 ec 04             	sub    $0x4,%esp
  802ff5:	6a 00                	push   $0x0
  802ff7:	50                   	push   %eax
  802ff8:	ff 75 10             	pushl  0x10(%ebp)
  802ffb:	e8 16 f1 ff ff       	call   802116 <set_block_data>
  803000:	83 c4 10             	add    $0x10,%esp
	}
}
  803003:	90                   	nop
  803004:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803007:	c9                   	leave  
  803008:	c3                   	ret    

00803009 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803009:	55                   	push   %ebp
  80300a:	89 e5                	mov    %esp,%ebp
  80300c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80300f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803014:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803017:	a1 30 50 80 00       	mov    0x805030,%eax
  80301c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301f:	73 1b                	jae    80303c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803021:	a1 30 50 80 00       	mov    0x805030,%eax
  803026:	83 ec 04             	sub    $0x4,%esp
  803029:	ff 75 08             	pushl  0x8(%ebp)
  80302c:	6a 00                	push   $0x0
  80302e:	50                   	push   %eax
  80302f:	e8 b2 fb ff ff       	call   802be6 <merging>
  803034:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803037:	e9 8b 00 00 00       	jmp    8030c7 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80303c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803041:	3b 45 08             	cmp    0x8(%ebp),%eax
  803044:	76 18                	jbe    80305e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803046:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80304b:	83 ec 04             	sub    $0x4,%esp
  80304e:	ff 75 08             	pushl  0x8(%ebp)
  803051:	50                   	push   %eax
  803052:	6a 00                	push   $0x0
  803054:	e8 8d fb ff ff       	call   802be6 <merging>
  803059:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80305c:	eb 69                	jmp    8030c7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80305e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803063:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803066:	eb 39                	jmp    8030a1 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80306e:	73 29                	jae    803099 <free_block+0x90>
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 00                	mov    (%eax),%eax
  803075:	3b 45 08             	cmp    0x8(%ebp),%eax
  803078:	76 1f                	jbe    803099 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80307a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307d:	8b 00                	mov    (%eax),%eax
  80307f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803082:	83 ec 04             	sub    $0x4,%esp
  803085:	ff 75 08             	pushl  0x8(%ebp)
  803088:	ff 75 f0             	pushl  -0x10(%ebp)
  80308b:	ff 75 f4             	pushl  -0xc(%ebp)
  80308e:	e8 53 fb ff ff       	call   802be6 <merging>
  803093:	83 c4 10             	add    $0x10,%esp
			break;
  803096:	90                   	nop
		}
	}
}
  803097:	eb 2e                	jmp    8030c7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803099:	a1 34 50 80 00       	mov    0x805034,%eax
  80309e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a5:	74 07                	je     8030ae <free_block+0xa5>
  8030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	eb 05                	jmp    8030b3 <free_block+0xaa>
  8030ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8030b3:	a3 34 50 80 00       	mov    %eax,0x805034
  8030b8:	a1 34 50 80 00       	mov    0x805034,%eax
  8030bd:	85 c0                	test   %eax,%eax
  8030bf:	75 a7                	jne    803068 <free_block+0x5f>
  8030c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c5:	75 a1                	jne    803068 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030c7:	90                   	nop
  8030c8:	c9                   	leave  
  8030c9:	c3                   	ret    

008030ca <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8030ca:	55                   	push   %ebp
  8030cb:	89 e5                	mov    %esp,%ebp
  8030cd:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8030d0:	ff 75 08             	pushl  0x8(%ebp)
  8030d3:	e8 ed ec ff ff       	call   801dc5 <get_block_size>
  8030d8:	83 c4 04             	add    $0x4,%esp
  8030db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8030de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8030e5:	eb 17                	jmp    8030fe <copy_data+0x34>
  8030e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8030ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ed:	01 c2                	add    %eax,%edx
  8030ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	01 c8                	add    %ecx,%eax
  8030f7:	8a 00                	mov    (%eax),%al
  8030f9:	88 02                	mov    %al,(%edx)
  8030fb:	ff 45 fc             	incl   -0x4(%ebp)
  8030fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803101:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803104:	72 e1                	jb     8030e7 <copy_data+0x1d>
}
  803106:	90                   	nop
  803107:	c9                   	leave  
  803108:	c3                   	ret    

00803109 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803109:	55                   	push   %ebp
  80310a:	89 e5                	mov    %esp,%ebp
  80310c:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80310f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803113:	75 23                	jne    803138 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803115:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803119:	74 13                	je     80312e <realloc_block_FF+0x25>
  80311b:	83 ec 0c             	sub    $0xc,%esp
  80311e:	ff 75 0c             	pushl  0xc(%ebp)
  803121:	e8 1f f0 ff ff       	call   802145 <alloc_block_FF>
  803126:	83 c4 10             	add    $0x10,%esp
  803129:	e9 f4 06 00 00       	jmp    803822 <realloc_block_FF+0x719>
		return NULL;
  80312e:	b8 00 00 00 00       	mov    $0x0,%eax
  803133:	e9 ea 06 00 00       	jmp    803822 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803138:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80313c:	75 18                	jne    803156 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80313e:	83 ec 0c             	sub    $0xc,%esp
  803141:	ff 75 08             	pushl  0x8(%ebp)
  803144:	e8 c0 fe ff ff       	call   803009 <free_block>
  803149:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80314c:	b8 00 00 00 00       	mov    $0x0,%eax
  803151:	e9 cc 06 00 00       	jmp    803822 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803156:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80315a:	77 07                	ja     803163 <realloc_block_FF+0x5a>
  80315c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803163:	8b 45 0c             	mov    0xc(%ebp),%eax
  803166:	83 e0 01             	and    $0x1,%eax
  803169:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80316c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316f:	83 c0 08             	add    $0x8,%eax
  803172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803175:	83 ec 0c             	sub    $0xc,%esp
  803178:	ff 75 08             	pushl  0x8(%ebp)
  80317b:	e8 45 ec ff ff       	call   801dc5 <get_block_size>
  803180:	83 c4 10             	add    $0x10,%esp
  803183:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803186:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803189:	83 e8 08             	sub    $0x8,%eax
  80318c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	83 e8 04             	sub    $0x4,%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	83 e0 fe             	and    $0xfffffffe,%eax
  80319a:	89 c2                	mov    %eax,%edx
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	01 d0                	add    %edx,%eax
  8031a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031a4:	83 ec 0c             	sub    $0xc,%esp
  8031a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031aa:	e8 16 ec ff ff       	call   801dc5 <get_block_size>
  8031af:	83 c4 10             	add    $0x10,%esp
  8031b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b8:	83 e8 08             	sub    $0x8,%eax
  8031bb:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8031be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031c4:	75 08                	jne    8031ce <realloc_block_FF+0xc5>
	{
		 return va;
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	e9 54 06 00 00       	jmp    803822 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8031ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031d4:	0f 83 e5 03 00 00    	jae    8035bf <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	2b 45 0c             	sub    0xc(%ebp),%eax
  8031e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8031e3:	83 ec 0c             	sub    $0xc,%esp
  8031e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031e9:	e8 f0 eb ff ff       	call   801dde <is_free_block>
  8031ee:	83 c4 10             	add    $0x10,%esp
  8031f1:	84 c0                	test   %al,%al
  8031f3:	0f 84 3b 01 00 00    	je     803334 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8031f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031ff:	01 d0                	add    %edx,%eax
  803201:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803204:	83 ec 04             	sub    $0x4,%esp
  803207:	6a 01                	push   $0x1
  803209:	ff 75 f0             	pushl  -0x10(%ebp)
  80320c:	ff 75 08             	pushl  0x8(%ebp)
  80320f:	e8 02 ef ff ff       	call   802116 <set_block_data>
  803214:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	83 e8 04             	sub    $0x4,%eax
  80321d:	8b 00                	mov    (%eax),%eax
  80321f:	83 e0 fe             	and    $0xfffffffe,%eax
  803222:	89 c2                	mov    %eax,%edx
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	01 d0                	add    %edx,%eax
  803229:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80322c:	83 ec 04             	sub    $0x4,%esp
  80322f:	6a 00                	push   $0x0
  803231:	ff 75 cc             	pushl  -0x34(%ebp)
  803234:	ff 75 c8             	pushl  -0x38(%ebp)
  803237:	e8 da ee ff ff       	call   802116 <set_block_data>
  80323c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80323f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803243:	74 06                	je     80324b <realloc_block_FF+0x142>
  803245:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803249:	75 17                	jne    803262 <realloc_block_FF+0x159>
  80324b:	83 ec 04             	sub    $0x4,%esp
  80324e:	68 d4 43 80 00       	push   $0x8043d4
  803253:	68 f6 01 00 00       	push   $0x1f6
  803258:	68 61 43 80 00       	push   $0x804361
  80325d:	e8 38 06 00 00       	call   80389a <_panic>
  803262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803265:	8b 10                	mov    (%eax),%edx
  803267:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80326a:	89 10                	mov    %edx,(%eax)
  80326c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80326f:	8b 00                	mov    (%eax),%eax
  803271:	85 c0                	test   %eax,%eax
  803273:	74 0b                	je     803280 <realloc_block_FF+0x177>
  803275:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80327d:	89 50 04             	mov    %edx,0x4(%eax)
  803280:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803283:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803286:	89 10                	mov    %edx,(%eax)
  803288:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80328b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80328e:	89 50 04             	mov    %edx,0x4(%eax)
  803291:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803294:	8b 00                	mov    (%eax),%eax
  803296:	85 c0                	test   %eax,%eax
  803298:	75 08                	jne    8032a2 <realloc_block_FF+0x199>
  80329a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80329d:	a3 30 50 80 00       	mov    %eax,0x805030
  8032a2:	a1 38 50 80 00       	mov    0x805038,%eax
  8032a7:	40                   	inc    %eax
  8032a8:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032b1:	75 17                	jne    8032ca <realloc_block_FF+0x1c1>
  8032b3:	83 ec 04             	sub    $0x4,%esp
  8032b6:	68 43 43 80 00       	push   $0x804343
  8032bb:	68 f7 01 00 00       	push   $0x1f7
  8032c0:	68 61 43 80 00       	push   $0x804361
  8032c5:	e8 d0 05 00 00       	call   80389a <_panic>
  8032ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cd:	8b 00                	mov    (%eax),%eax
  8032cf:	85 c0                	test   %eax,%eax
  8032d1:	74 10                	je     8032e3 <realloc_block_FF+0x1da>
  8032d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d6:	8b 00                	mov    (%eax),%eax
  8032d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032db:	8b 52 04             	mov    0x4(%edx),%edx
  8032de:	89 50 04             	mov    %edx,0x4(%eax)
  8032e1:	eb 0b                	jmp    8032ee <realloc_block_FF+0x1e5>
  8032e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e6:	8b 40 04             	mov    0x4(%eax),%eax
  8032e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8032ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f1:	8b 40 04             	mov    0x4(%eax),%eax
  8032f4:	85 c0                	test   %eax,%eax
  8032f6:	74 0f                	je     803307 <realloc_block_FF+0x1fe>
  8032f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fb:	8b 40 04             	mov    0x4(%eax),%eax
  8032fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803301:	8b 12                	mov    (%edx),%edx
  803303:	89 10                	mov    %edx,(%eax)
  803305:	eb 0a                	jmp    803311 <realloc_block_FF+0x208>
  803307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330a:	8b 00                	mov    (%eax),%eax
  80330c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803311:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803314:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80331a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803324:	a1 38 50 80 00       	mov    0x805038,%eax
  803329:	48                   	dec    %eax
  80332a:	a3 38 50 80 00       	mov    %eax,0x805038
  80332f:	e9 83 02 00 00       	jmp    8035b7 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803334:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803338:	0f 86 69 02 00 00    	jbe    8035a7 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80333e:	83 ec 04             	sub    $0x4,%esp
  803341:	6a 01                	push   $0x1
  803343:	ff 75 f0             	pushl  -0x10(%ebp)
  803346:	ff 75 08             	pushl  0x8(%ebp)
  803349:	e8 c8 ed ff ff       	call   802116 <set_block_data>
  80334e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	83 e8 04             	sub    $0x4,%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	83 e0 fe             	and    $0xfffffffe,%eax
  80335c:	89 c2                	mov    %eax,%edx
  80335e:	8b 45 08             	mov    0x8(%ebp),%eax
  803361:	01 d0                	add    %edx,%eax
  803363:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803366:	a1 38 50 80 00       	mov    0x805038,%eax
  80336b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80336e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803372:	75 68                	jne    8033dc <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803374:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803378:	75 17                	jne    803391 <realloc_block_FF+0x288>
  80337a:	83 ec 04             	sub    $0x4,%esp
  80337d:	68 7c 43 80 00       	push   $0x80437c
  803382:	68 06 02 00 00       	push   $0x206
  803387:	68 61 43 80 00       	push   $0x804361
  80338c:	e8 09 05 00 00       	call   80389a <_panic>
  803391:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803397:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339a:	89 10                	mov    %edx,(%eax)
  80339c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339f:	8b 00                	mov    (%eax),%eax
  8033a1:	85 c0                	test   %eax,%eax
  8033a3:	74 0d                	je     8033b2 <realloc_block_FF+0x2a9>
  8033a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033ad:	89 50 04             	mov    %edx,0x4(%eax)
  8033b0:	eb 08                	jmp    8033ba <realloc_block_FF+0x2b1>
  8033b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8033ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d1:	40                   	inc    %eax
  8033d2:	a3 38 50 80 00       	mov    %eax,0x805038
  8033d7:	e9 b0 01 00 00       	jmp    80358c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8033dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033e1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033e4:	76 68                	jbe    80344e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033e6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033ea:	75 17                	jne    803403 <realloc_block_FF+0x2fa>
  8033ec:	83 ec 04             	sub    $0x4,%esp
  8033ef:	68 7c 43 80 00       	push   $0x80437c
  8033f4:	68 0b 02 00 00       	push   $0x20b
  8033f9:	68 61 43 80 00       	push   $0x804361
  8033fe:	e8 97 04 00 00       	call   80389a <_panic>
  803403:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803409:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340c:	89 10                	mov    %edx,(%eax)
  80340e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803411:	8b 00                	mov    (%eax),%eax
  803413:	85 c0                	test   %eax,%eax
  803415:	74 0d                	je     803424 <realloc_block_FF+0x31b>
  803417:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80341c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80341f:	89 50 04             	mov    %edx,0x4(%eax)
  803422:	eb 08                	jmp    80342c <realloc_block_FF+0x323>
  803424:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803427:	a3 30 50 80 00       	mov    %eax,0x805030
  80342c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803434:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803437:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80343e:	a1 38 50 80 00       	mov    0x805038,%eax
  803443:	40                   	inc    %eax
  803444:	a3 38 50 80 00       	mov    %eax,0x805038
  803449:	e9 3e 01 00 00       	jmp    80358c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80344e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803453:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803456:	73 68                	jae    8034c0 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803458:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80345c:	75 17                	jne    803475 <realloc_block_FF+0x36c>
  80345e:	83 ec 04             	sub    $0x4,%esp
  803461:	68 b0 43 80 00       	push   $0x8043b0
  803466:	68 10 02 00 00       	push   $0x210
  80346b:	68 61 43 80 00       	push   $0x804361
  803470:	e8 25 04 00 00       	call   80389a <_panic>
  803475:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80347b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347e:	89 50 04             	mov    %edx,0x4(%eax)
  803481:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803484:	8b 40 04             	mov    0x4(%eax),%eax
  803487:	85 c0                	test   %eax,%eax
  803489:	74 0c                	je     803497 <realloc_block_FF+0x38e>
  80348b:	a1 30 50 80 00       	mov    0x805030,%eax
  803490:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803493:	89 10                	mov    %edx,(%eax)
  803495:	eb 08                	jmp    80349f <realloc_block_FF+0x396>
  803497:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80349f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8034a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b0:	a1 38 50 80 00       	mov    0x805038,%eax
  8034b5:	40                   	inc    %eax
  8034b6:	a3 38 50 80 00       	mov    %eax,0x805038
  8034bb:	e9 cc 00 00 00       	jmp    80358c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8034c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8034c7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034cf:	e9 8a 00 00 00       	jmp    80355e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8034d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034da:	73 7a                	jae    803556 <realloc_block_FF+0x44d>
  8034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034df:	8b 00                	mov    (%eax),%eax
  8034e1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034e4:	73 70                	jae    803556 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8034e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ea:	74 06                	je     8034f2 <realloc_block_FF+0x3e9>
  8034ec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034f0:	75 17                	jne    803509 <realloc_block_FF+0x400>
  8034f2:	83 ec 04             	sub    $0x4,%esp
  8034f5:	68 d4 43 80 00       	push   $0x8043d4
  8034fa:	68 1a 02 00 00       	push   $0x21a
  8034ff:	68 61 43 80 00       	push   $0x804361
  803504:	e8 91 03 00 00       	call   80389a <_panic>
  803509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350c:	8b 10                	mov    (%eax),%edx
  80350e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803511:	89 10                	mov    %edx,(%eax)
  803513:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803516:	8b 00                	mov    (%eax),%eax
  803518:	85 c0                	test   %eax,%eax
  80351a:	74 0b                	je     803527 <realloc_block_FF+0x41e>
  80351c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351f:	8b 00                	mov    (%eax),%eax
  803521:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803524:	89 50 04             	mov    %edx,0x4(%eax)
  803527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80352d:	89 10                	mov    %edx,(%eax)
  80352f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803535:	89 50 04             	mov    %edx,0x4(%eax)
  803538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353b:	8b 00                	mov    (%eax),%eax
  80353d:	85 c0                	test   %eax,%eax
  80353f:	75 08                	jne    803549 <realloc_block_FF+0x440>
  803541:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803544:	a3 30 50 80 00       	mov    %eax,0x805030
  803549:	a1 38 50 80 00       	mov    0x805038,%eax
  80354e:	40                   	inc    %eax
  80354f:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803554:	eb 36                	jmp    80358c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803556:	a1 34 50 80 00       	mov    0x805034,%eax
  80355b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80355e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803562:	74 07                	je     80356b <realloc_block_FF+0x462>
  803564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803567:	8b 00                	mov    (%eax),%eax
  803569:	eb 05                	jmp    803570 <realloc_block_FF+0x467>
  80356b:	b8 00 00 00 00       	mov    $0x0,%eax
  803570:	a3 34 50 80 00       	mov    %eax,0x805034
  803575:	a1 34 50 80 00       	mov    0x805034,%eax
  80357a:	85 c0                	test   %eax,%eax
  80357c:	0f 85 52 ff ff ff    	jne    8034d4 <realloc_block_FF+0x3cb>
  803582:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803586:	0f 85 48 ff ff ff    	jne    8034d4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80358c:	83 ec 04             	sub    $0x4,%esp
  80358f:	6a 00                	push   $0x0
  803591:	ff 75 d8             	pushl  -0x28(%ebp)
  803594:	ff 75 d4             	pushl  -0x2c(%ebp)
  803597:	e8 7a eb ff ff       	call   802116 <set_block_data>
  80359c:	83 c4 10             	add    $0x10,%esp
				return va;
  80359f:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a2:	e9 7b 02 00 00       	jmp    803822 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035a7:	83 ec 0c             	sub    $0xc,%esp
  8035aa:	68 51 44 80 00       	push   $0x804451
  8035af:	e8 d6 cd ff ff       	call   80038a <cprintf>
  8035b4:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8035b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ba:	e9 63 02 00 00       	jmp    803822 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8035bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035c2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035c5:	0f 86 4d 02 00 00    	jbe    803818 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8035cb:	83 ec 0c             	sub    $0xc,%esp
  8035ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035d1:	e8 08 e8 ff ff       	call   801dde <is_free_block>
  8035d6:	83 c4 10             	add    $0x10,%esp
  8035d9:	84 c0                	test   %al,%al
  8035db:	0f 84 37 02 00 00    	je     803818 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8035e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8035e7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8035ea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035ed:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035f0:	76 38                	jbe    80362a <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8035f2:	83 ec 0c             	sub    $0xc,%esp
  8035f5:	ff 75 08             	pushl  0x8(%ebp)
  8035f8:	e8 0c fa ff ff       	call   803009 <free_block>
  8035fd:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803600:	83 ec 0c             	sub    $0xc,%esp
  803603:	ff 75 0c             	pushl  0xc(%ebp)
  803606:	e8 3a eb ff ff       	call   802145 <alloc_block_FF>
  80360b:	83 c4 10             	add    $0x10,%esp
  80360e:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803611:	83 ec 08             	sub    $0x8,%esp
  803614:	ff 75 c0             	pushl  -0x40(%ebp)
  803617:	ff 75 08             	pushl  0x8(%ebp)
  80361a:	e8 ab fa ff ff       	call   8030ca <copy_data>
  80361f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803622:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803625:	e9 f8 01 00 00       	jmp    803822 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80362a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80362d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803630:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803633:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803637:	0f 87 a0 00 00 00    	ja     8036dd <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80363d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803641:	75 17                	jne    80365a <realloc_block_FF+0x551>
  803643:	83 ec 04             	sub    $0x4,%esp
  803646:	68 43 43 80 00       	push   $0x804343
  80364b:	68 38 02 00 00       	push   $0x238
  803650:	68 61 43 80 00       	push   $0x804361
  803655:	e8 40 02 00 00       	call   80389a <_panic>
  80365a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365d:	8b 00                	mov    (%eax),%eax
  80365f:	85 c0                	test   %eax,%eax
  803661:	74 10                	je     803673 <realloc_block_FF+0x56a>
  803663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803666:	8b 00                	mov    (%eax),%eax
  803668:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80366b:	8b 52 04             	mov    0x4(%edx),%edx
  80366e:	89 50 04             	mov    %edx,0x4(%eax)
  803671:	eb 0b                	jmp    80367e <realloc_block_FF+0x575>
  803673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803676:	8b 40 04             	mov    0x4(%eax),%eax
  803679:	a3 30 50 80 00       	mov    %eax,0x805030
  80367e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803681:	8b 40 04             	mov    0x4(%eax),%eax
  803684:	85 c0                	test   %eax,%eax
  803686:	74 0f                	je     803697 <realloc_block_FF+0x58e>
  803688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368b:	8b 40 04             	mov    0x4(%eax),%eax
  80368e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803691:	8b 12                	mov    (%edx),%edx
  803693:	89 10                	mov    %edx,(%eax)
  803695:	eb 0a                	jmp    8036a1 <realloc_block_FF+0x598>
  803697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b4:	a1 38 50 80 00       	mov    0x805038,%eax
  8036b9:	48                   	dec    %eax
  8036ba:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8036bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036c5:	01 d0                	add    %edx,%eax
  8036c7:	83 ec 04             	sub    $0x4,%esp
  8036ca:	6a 01                	push   $0x1
  8036cc:	50                   	push   %eax
  8036cd:	ff 75 08             	pushl  0x8(%ebp)
  8036d0:	e8 41 ea ff ff       	call   802116 <set_block_data>
  8036d5:	83 c4 10             	add    $0x10,%esp
  8036d8:	e9 36 01 00 00       	jmp    803813 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8036dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036e0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036e3:	01 d0                	add    %edx,%eax
  8036e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8036e8:	83 ec 04             	sub    $0x4,%esp
  8036eb:	6a 01                	push   $0x1
  8036ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8036f0:	ff 75 08             	pushl  0x8(%ebp)
  8036f3:	e8 1e ea ff ff       	call   802116 <set_block_data>
  8036f8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	83 e8 04             	sub    $0x4,%eax
  803701:	8b 00                	mov    (%eax),%eax
  803703:	83 e0 fe             	and    $0xfffffffe,%eax
  803706:	89 c2                	mov    %eax,%edx
  803708:	8b 45 08             	mov    0x8(%ebp),%eax
  80370b:	01 d0                	add    %edx,%eax
  80370d:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803714:	74 06                	je     80371c <realloc_block_FF+0x613>
  803716:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80371a:	75 17                	jne    803733 <realloc_block_FF+0x62a>
  80371c:	83 ec 04             	sub    $0x4,%esp
  80371f:	68 d4 43 80 00       	push   $0x8043d4
  803724:	68 44 02 00 00       	push   $0x244
  803729:	68 61 43 80 00       	push   $0x804361
  80372e:	e8 67 01 00 00       	call   80389a <_panic>
  803733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803736:	8b 10                	mov    (%eax),%edx
  803738:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80373b:	89 10                	mov    %edx,(%eax)
  80373d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803740:	8b 00                	mov    (%eax),%eax
  803742:	85 c0                	test   %eax,%eax
  803744:	74 0b                	je     803751 <realloc_block_FF+0x648>
  803746:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803749:	8b 00                	mov    (%eax),%eax
  80374b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80374e:	89 50 04             	mov    %edx,0x4(%eax)
  803751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803754:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803757:	89 10                	mov    %edx,(%eax)
  803759:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80375c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80375f:	89 50 04             	mov    %edx,0x4(%eax)
  803762:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803765:	8b 00                	mov    (%eax),%eax
  803767:	85 c0                	test   %eax,%eax
  803769:	75 08                	jne    803773 <realloc_block_FF+0x66a>
  80376b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80376e:	a3 30 50 80 00       	mov    %eax,0x805030
  803773:	a1 38 50 80 00       	mov    0x805038,%eax
  803778:	40                   	inc    %eax
  803779:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80377e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803782:	75 17                	jne    80379b <realloc_block_FF+0x692>
  803784:	83 ec 04             	sub    $0x4,%esp
  803787:	68 43 43 80 00       	push   $0x804343
  80378c:	68 45 02 00 00       	push   $0x245
  803791:	68 61 43 80 00       	push   $0x804361
  803796:	e8 ff 00 00 00       	call   80389a <_panic>
  80379b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379e:	8b 00                	mov    (%eax),%eax
  8037a0:	85 c0                	test   %eax,%eax
  8037a2:	74 10                	je     8037b4 <realloc_block_FF+0x6ab>
  8037a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a7:	8b 00                	mov    (%eax),%eax
  8037a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ac:	8b 52 04             	mov    0x4(%edx),%edx
  8037af:	89 50 04             	mov    %edx,0x4(%eax)
  8037b2:	eb 0b                	jmp    8037bf <realloc_block_FF+0x6b6>
  8037b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b7:	8b 40 04             	mov    0x4(%eax),%eax
  8037ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8037bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c2:	8b 40 04             	mov    0x4(%eax),%eax
  8037c5:	85 c0                	test   %eax,%eax
  8037c7:	74 0f                	je     8037d8 <realloc_block_FF+0x6cf>
  8037c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cc:	8b 40 04             	mov    0x4(%eax),%eax
  8037cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037d2:	8b 12                	mov    (%edx),%edx
  8037d4:	89 10                	mov    %edx,(%eax)
  8037d6:	eb 0a                	jmp    8037e2 <realloc_block_FF+0x6d9>
  8037d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037db:	8b 00                	mov    (%eax),%eax
  8037dd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8037fa:	48                   	dec    %eax
  8037fb:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803800:	83 ec 04             	sub    $0x4,%esp
  803803:	6a 00                	push   $0x0
  803805:	ff 75 bc             	pushl  -0x44(%ebp)
  803808:	ff 75 b8             	pushl  -0x48(%ebp)
  80380b:	e8 06 e9 ff ff       	call   802116 <set_block_data>
  803810:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803813:	8b 45 08             	mov    0x8(%ebp),%eax
  803816:	eb 0a                	jmp    803822 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803818:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80381f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803822:	c9                   	leave  
  803823:	c3                   	ret    

00803824 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803824:	55                   	push   %ebp
  803825:	89 e5                	mov    %esp,%ebp
  803827:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80382a:	83 ec 04             	sub    $0x4,%esp
  80382d:	68 58 44 80 00       	push   $0x804458
  803832:	68 58 02 00 00       	push   $0x258
  803837:	68 61 43 80 00       	push   $0x804361
  80383c:	e8 59 00 00 00       	call   80389a <_panic>

00803841 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803841:	55                   	push   %ebp
  803842:	89 e5                	mov    %esp,%ebp
  803844:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803847:	83 ec 04             	sub    $0x4,%esp
  80384a:	68 80 44 80 00       	push   $0x804480
  80384f:	68 61 02 00 00       	push   $0x261
  803854:	68 61 43 80 00       	push   $0x804361
  803859:	e8 3c 00 00 00       	call   80389a <_panic>

0080385e <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80385e:	55                   	push   %ebp
  80385f:	89 e5                	mov    %esp,%ebp
  803861:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  803864:	8b 45 08             	mov    0x8(%ebp),%eax
  803867:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80386a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80386e:	83 ec 0c             	sub    $0xc,%esp
  803871:	50                   	push   %eax
  803872:	e8 dd e0 ff ff       	call   801954 <sys_cputc>
  803877:	83 c4 10             	add    $0x10,%esp
}
  80387a:	90                   	nop
  80387b:	c9                   	leave  
  80387c:	c3                   	ret    

0080387d <getchar>:


int
getchar(void)
{
  80387d:	55                   	push   %ebp
  80387e:	89 e5                	mov    %esp,%ebp
  803880:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803883:	e8 68 df ff ff       	call   8017f0 <sys_cgetc>
  803888:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80388b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80388e:	c9                   	leave  
  80388f:	c3                   	ret    

00803890 <iscons>:

int iscons(int fdnum)
{
  803890:	55                   	push   %ebp
  803891:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803893:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803898:	5d                   	pop    %ebp
  803899:	c3                   	ret    

0080389a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80389a:	55                   	push   %ebp
  80389b:	89 e5                	mov    %esp,%ebp
  80389d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8038a0:	8d 45 10             	lea    0x10(%ebp),%eax
  8038a3:	83 c0 04             	add    $0x4,%eax
  8038a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8038a9:	a1 60 50 90 00       	mov    0x905060,%eax
  8038ae:	85 c0                	test   %eax,%eax
  8038b0:	74 16                	je     8038c8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8038b2:	a1 60 50 90 00       	mov    0x905060,%eax
  8038b7:	83 ec 08             	sub    $0x8,%esp
  8038ba:	50                   	push   %eax
  8038bb:	68 a8 44 80 00       	push   $0x8044a8
  8038c0:	e8 c5 ca ff ff       	call   80038a <cprintf>
  8038c5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8038c8:	a1 00 50 80 00       	mov    0x805000,%eax
  8038cd:	ff 75 0c             	pushl  0xc(%ebp)
  8038d0:	ff 75 08             	pushl  0x8(%ebp)
  8038d3:	50                   	push   %eax
  8038d4:	68 ad 44 80 00       	push   $0x8044ad
  8038d9:	e8 ac ca ff ff       	call   80038a <cprintf>
  8038de:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8038e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8038e4:	83 ec 08             	sub    $0x8,%esp
  8038e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8038ea:	50                   	push   %eax
  8038eb:	e8 2f ca ff ff       	call   80031f <vcprintf>
  8038f0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8038f3:	83 ec 08             	sub    $0x8,%esp
  8038f6:	6a 00                	push   $0x0
  8038f8:	68 c9 44 80 00       	push   $0x8044c9
  8038fd:	e8 1d ca ff ff       	call   80031f <vcprintf>
  803902:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803905:	e8 9e c9 ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  80390a:	eb fe                	jmp    80390a <_panic+0x70>

0080390c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80390c:	55                   	push   %ebp
  80390d:	89 e5                	mov    %esp,%ebp
  80390f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803912:	a1 20 50 80 00       	mov    0x805020,%eax
  803917:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80391d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803920:	39 c2                	cmp    %eax,%edx
  803922:	74 14                	je     803938 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803924:	83 ec 04             	sub    $0x4,%esp
  803927:	68 cc 44 80 00       	push   $0x8044cc
  80392c:	6a 26                	push   $0x26
  80392e:	68 18 45 80 00       	push   $0x804518
  803933:	e8 62 ff ff ff       	call   80389a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80393f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803946:	e9 c5 00 00 00       	jmp    803a10 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80394b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803955:	8b 45 08             	mov    0x8(%ebp),%eax
  803958:	01 d0                	add    %edx,%eax
  80395a:	8b 00                	mov    (%eax),%eax
  80395c:	85 c0                	test   %eax,%eax
  80395e:	75 08                	jne    803968 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803960:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803963:	e9 a5 00 00 00       	jmp    803a0d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803968:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80396f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803976:	eb 69                	jmp    8039e1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803978:	a1 20 50 80 00       	mov    0x805020,%eax
  80397d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803983:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803986:	89 d0                	mov    %edx,%eax
  803988:	01 c0                	add    %eax,%eax
  80398a:	01 d0                	add    %edx,%eax
  80398c:	c1 e0 03             	shl    $0x3,%eax
  80398f:	01 c8                	add    %ecx,%eax
  803991:	8a 40 04             	mov    0x4(%eax),%al
  803994:	84 c0                	test   %al,%al
  803996:	75 46                	jne    8039de <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803998:	a1 20 50 80 00       	mov    0x805020,%eax
  80399d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a6:	89 d0                	mov    %edx,%eax
  8039a8:	01 c0                	add    %eax,%eax
  8039aa:	01 d0                	add    %edx,%eax
  8039ac:	c1 e0 03             	shl    $0x3,%eax
  8039af:	01 c8                	add    %ecx,%eax
  8039b1:	8b 00                	mov    (%eax),%eax
  8039b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8039b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8039be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8039c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	01 c8                	add    %ecx,%eax
  8039cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8039d1:	39 c2                	cmp    %eax,%edx
  8039d3:	75 09                	jne    8039de <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8039d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8039dc:	eb 15                	jmp    8039f3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039de:	ff 45 e8             	incl   -0x18(%ebp)
  8039e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8039e6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ef:	39 c2                	cmp    %eax,%edx
  8039f1:	77 85                	ja     803978 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8039f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039f7:	75 14                	jne    803a0d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8039f9:	83 ec 04             	sub    $0x4,%esp
  8039fc:	68 24 45 80 00       	push   $0x804524
  803a01:	6a 3a                	push   $0x3a
  803a03:	68 18 45 80 00       	push   $0x804518
  803a08:	e8 8d fe ff ff       	call   80389a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803a0d:	ff 45 f0             	incl   -0x10(%ebp)
  803a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a13:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a16:	0f 8c 2f ff ff ff    	jl     80394b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803a1c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a23:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803a2a:	eb 26                	jmp    803a52 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803a2c:	a1 20 50 80 00       	mov    0x805020,%eax
  803a31:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a37:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a3a:	89 d0                	mov    %edx,%eax
  803a3c:	01 c0                	add    %eax,%eax
  803a3e:	01 d0                	add    %edx,%eax
  803a40:	c1 e0 03             	shl    $0x3,%eax
  803a43:	01 c8                	add    %ecx,%eax
  803a45:	8a 40 04             	mov    0x4(%eax),%al
  803a48:	3c 01                	cmp    $0x1,%al
  803a4a:	75 03                	jne    803a4f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803a4c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a4f:	ff 45 e0             	incl   -0x20(%ebp)
  803a52:	a1 20 50 80 00       	mov    0x805020,%eax
  803a57:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a60:	39 c2                	cmp    %eax,%edx
  803a62:	77 c8                	ja     803a2c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a67:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803a6a:	74 14                	je     803a80 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803a6c:	83 ec 04             	sub    $0x4,%esp
  803a6f:	68 78 45 80 00       	push   $0x804578
  803a74:	6a 44                	push   $0x44
  803a76:	68 18 45 80 00       	push   $0x804518
  803a7b:	e8 1a fe ff ff       	call   80389a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803a80:	90                   	nop
  803a81:	c9                   	leave  
  803a82:	c3                   	ret    
  803a83:	90                   	nop

00803a84 <__udivdi3>:
  803a84:	55                   	push   %ebp
  803a85:	57                   	push   %edi
  803a86:	56                   	push   %esi
  803a87:	53                   	push   %ebx
  803a88:	83 ec 1c             	sub    $0x1c,%esp
  803a8b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a9b:	89 ca                	mov    %ecx,%edx
  803a9d:	89 f8                	mov    %edi,%eax
  803a9f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803aa3:	85 f6                	test   %esi,%esi
  803aa5:	75 2d                	jne    803ad4 <__udivdi3+0x50>
  803aa7:	39 cf                	cmp    %ecx,%edi
  803aa9:	77 65                	ja     803b10 <__udivdi3+0x8c>
  803aab:	89 fd                	mov    %edi,%ebp
  803aad:	85 ff                	test   %edi,%edi
  803aaf:	75 0b                	jne    803abc <__udivdi3+0x38>
  803ab1:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab6:	31 d2                	xor    %edx,%edx
  803ab8:	f7 f7                	div    %edi
  803aba:	89 c5                	mov    %eax,%ebp
  803abc:	31 d2                	xor    %edx,%edx
  803abe:	89 c8                	mov    %ecx,%eax
  803ac0:	f7 f5                	div    %ebp
  803ac2:	89 c1                	mov    %eax,%ecx
  803ac4:	89 d8                	mov    %ebx,%eax
  803ac6:	f7 f5                	div    %ebp
  803ac8:	89 cf                	mov    %ecx,%edi
  803aca:	89 fa                	mov    %edi,%edx
  803acc:	83 c4 1c             	add    $0x1c,%esp
  803acf:	5b                   	pop    %ebx
  803ad0:	5e                   	pop    %esi
  803ad1:	5f                   	pop    %edi
  803ad2:	5d                   	pop    %ebp
  803ad3:	c3                   	ret    
  803ad4:	39 ce                	cmp    %ecx,%esi
  803ad6:	77 28                	ja     803b00 <__udivdi3+0x7c>
  803ad8:	0f bd fe             	bsr    %esi,%edi
  803adb:	83 f7 1f             	xor    $0x1f,%edi
  803ade:	75 40                	jne    803b20 <__udivdi3+0x9c>
  803ae0:	39 ce                	cmp    %ecx,%esi
  803ae2:	72 0a                	jb     803aee <__udivdi3+0x6a>
  803ae4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ae8:	0f 87 9e 00 00 00    	ja     803b8c <__udivdi3+0x108>
  803aee:	b8 01 00 00 00       	mov    $0x1,%eax
  803af3:	89 fa                	mov    %edi,%edx
  803af5:	83 c4 1c             	add    $0x1c,%esp
  803af8:	5b                   	pop    %ebx
  803af9:	5e                   	pop    %esi
  803afa:	5f                   	pop    %edi
  803afb:	5d                   	pop    %ebp
  803afc:	c3                   	ret    
  803afd:	8d 76 00             	lea    0x0(%esi),%esi
  803b00:	31 ff                	xor    %edi,%edi
  803b02:	31 c0                	xor    %eax,%eax
  803b04:	89 fa                	mov    %edi,%edx
  803b06:	83 c4 1c             	add    $0x1c,%esp
  803b09:	5b                   	pop    %ebx
  803b0a:	5e                   	pop    %esi
  803b0b:	5f                   	pop    %edi
  803b0c:	5d                   	pop    %ebp
  803b0d:	c3                   	ret    
  803b0e:	66 90                	xchg   %ax,%ax
  803b10:	89 d8                	mov    %ebx,%eax
  803b12:	f7 f7                	div    %edi
  803b14:	31 ff                	xor    %edi,%edi
  803b16:	89 fa                	mov    %edi,%edx
  803b18:	83 c4 1c             	add    $0x1c,%esp
  803b1b:	5b                   	pop    %ebx
  803b1c:	5e                   	pop    %esi
  803b1d:	5f                   	pop    %edi
  803b1e:	5d                   	pop    %ebp
  803b1f:	c3                   	ret    
  803b20:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b25:	89 eb                	mov    %ebp,%ebx
  803b27:	29 fb                	sub    %edi,%ebx
  803b29:	89 f9                	mov    %edi,%ecx
  803b2b:	d3 e6                	shl    %cl,%esi
  803b2d:	89 c5                	mov    %eax,%ebp
  803b2f:	88 d9                	mov    %bl,%cl
  803b31:	d3 ed                	shr    %cl,%ebp
  803b33:	89 e9                	mov    %ebp,%ecx
  803b35:	09 f1                	or     %esi,%ecx
  803b37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b3b:	89 f9                	mov    %edi,%ecx
  803b3d:	d3 e0                	shl    %cl,%eax
  803b3f:	89 c5                	mov    %eax,%ebp
  803b41:	89 d6                	mov    %edx,%esi
  803b43:	88 d9                	mov    %bl,%cl
  803b45:	d3 ee                	shr    %cl,%esi
  803b47:	89 f9                	mov    %edi,%ecx
  803b49:	d3 e2                	shl    %cl,%edx
  803b4b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b4f:	88 d9                	mov    %bl,%cl
  803b51:	d3 e8                	shr    %cl,%eax
  803b53:	09 c2                	or     %eax,%edx
  803b55:	89 d0                	mov    %edx,%eax
  803b57:	89 f2                	mov    %esi,%edx
  803b59:	f7 74 24 0c          	divl   0xc(%esp)
  803b5d:	89 d6                	mov    %edx,%esi
  803b5f:	89 c3                	mov    %eax,%ebx
  803b61:	f7 e5                	mul    %ebp
  803b63:	39 d6                	cmp    %edx,%esi
  803b65:	72 19                	jb     803b80 <__udivdi3+0xfc>
  803b67:	74 0b                	je     803b74 <__udivdi3+0xf0>
  803b69:	89 d8                	mov    %ebx,%eax
  803b6b:	31 ff                	xor    %edi,%edi
  803b6d:	e9 58 ff ff ff       	jmp    803aca <__udivdi3+0x46>
  803b72:	66 90                	xchg   %ax,%ax
  803b74:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b78:	89 f9                	mov    %edi,%ecx
  803b7a:	d3 e2                	shl    %cl,%edx
  803b7c:	39 c2                	cmp    %eax,%edx
  803b7e:	73 e9                	jae    803b69 <__udivdi3+0xe5>
  803b80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b83:	31 ff                	xor    %edi,%edi
  803b85:	e9 40 ff ff ff       	jmp    803aca <__udivdi3+0x46>
  803b8a:	66 90                	xchg   %ax,%ax
  803b8c:	31 c0                	xor    %eax,%eax
  803b8e:	e9 37 ff ff ff       	jmp    803aca <__udivdi3+0x46>
  803b93:	90                   	nop

00803b94 <__umoddi3>:
  803b94:	55                   	push   %ebp
  803b95:	57                   	push   %edi
  803b96:	56                   	push   %esi
  803b97:	53                   	push   %ebx
  803b98:	83 ec 1c             	sub    $0x1c,%esp
  803b9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ba3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ba7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803baf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bb3:	89 f3                	mov    %esi,%ebx
  803bb5:	89 fa                	mov    %edi,%edx
  803bb7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bbb:	89 34 24             	mov    %esi,(%esp)
  803bbe:	85 c0                	test   %eax,%eax
  803bc0:	75 1a                	jne    803bdc <__umoddi3+0x48>
  803bc2:	39 f7                	cmp    %esi,%edi
  803bc4:	0f 86 a2 00 00 00    	jbe    803c6c <__umoddi3+0xd8>
  803bca:	89 c8                	mov    %ecx,%eax
  803bcc:	89 f2                	mov    %esi,%edx
  803bce:	f7 f7                	div    %edi
  803bd0:	89 d0                	mov    %edx,%eax
  803bd2:	31 d2                	xor    %edx,%edx
  803bd4:	83 c4 1c             	add    $0x1c,%esp
  803bd7:	5b                   	pop    %ebx
  803bd8:	5e                   	pop    %esi
  803bd9:	5f                   	pop    %edi
  803bda:	5d                   	pop    %ebp
  803bdb:	c3                   	ret    
  803bdc:	39 f0                	cmp    %esi,%eax
  803bde:	0f 87 ac 00 00 00    	ja     803c90 <__umoddi3+0xfc>
  803be4:	0f bd e8             	bsr    %eax,%ebp
  803be7:	83 f5 1f             	xor    $0x1f,%ebp
  803bea:	0f 84 ac 00 00 00    	je     803c9c <__umoddi3+0x108>
  803bf0:	bf 20 00 00 00       	mov    $0x20,%edi
  803bf5:	29 ef                	sub    %ebp,%edi
  803bf7:	89 fe                	mov    %edi,%esi
  803bf9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bfd:	89 e9                	mov    %ebp,%ecx
  803bff:	d3 e0                	shl    %cl,%eax
  803c01:	89 d7                	mov    %edx,%edi
  803c03:	89 f1                	mov    %esi,%ecx
  803c05:	d3 ef                	shr    %cl,%edi
  803c07:	09 c7                	or     %eax,%edi
  803c09:	89 e9                	mov    %ebp,%ecx
  803c0b:	d3 e2                	shl    %cl,%edx
  803c0d:	89 14 24             	mov    %edx,(%esp)
  803c10:	89 d8                	mov    %ebx,%eax
  803c12:	d3 e0                	shl    %cl,%eax
  803c14:	89 c2                	mov    %eax,%edx
  803c16:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c1a:	d3 e0                	shl    %cl,%eax
  803c1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c20:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c24:	89 f1                	mov    %esi,%ecx
  803c26:	d3 e8                	shr    %cl,%eax
  803c28:	09 d0                	or     %edx,%eax
  803c2a:	d3 eb                	shr    %cl,%ebx
  803c2c:	89 da                	mov    %ebx,%edx
  803c2e:	f7 f7                	div    %edi
  803c30:	89 d3                	mov    %edx,%ebx
  803c32:	f7 24 24             	mull   (%esp)
  803c35:	89 c6                	mov    %eax,%esi
  803c37:	89 d1                	mov    %edx,%ecx
  803c39:	39 d3                	cmp    %edx,%ebx
  803c3b:	0f 82 87 00 00 00    	jb     803cc8 <__umoddi3+0x134>
  803c41:	0f 84 91 00 00 00    	je     803cd8 <__umoddi3+0x144>
  803c47:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c4b:	29 f2                	sub    %esi,%edx
  803c4d:	19 cb                	sbb    %ecx,%ebx
  803c4f:	89 d8                	mov    %ebx,%eax
  803c51:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c55:	d3 e0                	shl    %cl,%eax
  803c57:	89 e9                	mov    %ebp,%ecx
  803c59:	d3 ea                	shr    %cl,%edx
  803c5b:	09 d0                	or     %edx,%eax
  803c5d:	89 e9                	mov    %ebp,%ecx
  803c5f:	d3 eb                	shr    %cl,%ebx
  803c61:	89 da                	mov    %ebx,%edx
  803c63:	83 c4 1c             	add    $0x1c,%esp
  803c66:	5b                   	pop    %ebx
  803c67:	5e                   	pop    %esi
  803c68:	5f                   	pop    %edi
  803c69:	5d                   	pop    %ebp
  803c6a:	c3                   	ret    
  803c6b:	90                   	nop
  803c6c:	89 fd                	mov    %edi,%ebp
  803c6e:	85 ff                	test   %edi,%edi
  803c70:	75 0b                	jne    803c7d <__umoddi3+0xe9>
  803c72:	b8 01 00 00 00       	mov    $0x1,%eax
  803c77:	31 d2                	xor    %edx,%edx
  803c79:	f7 f7                	div    %edi
  803c7b:	89 c5                	mov    %eax,%ebp
  803c7d:	89 f0                	mov    %esi,%eax
  803c7f:	31 d2                	xor    %edx,%edx
  803c81:	f7 f5                	div    %ebp
  803c83:	89 c8                	mov    %ecx,%eax
  803c85:	f7 f5                	div    %ebp
  803c87:	89 d0                	mov    %edx,%eax
  803c89:	e9 44 ff ff ff       	jmp    803bd2 <__umoddi3+0x3e>
  803c8e:	66 90                	xchg   %ax,%ax
  803c90:	89 c8                	mov    %ecx,%eax
  803c92:	89 f2                	mov    %esi,%edx
  803c94:	83 c4 1c             	add    $0x1c,%esp
  803c97:	5b                   	pop    %ebx
  803c98:	5e                   	pop    %esi
  803c99:	5f                   	pop    %edi
  803c9a:	5d                   	pop    %ebp
  803c9b:	c3                   	ret    
  803c9c:	3b 04 24             	cmp    (%esp),%eax
  803c9f:	72 06                	jb     803ca7 <__umoddi3+0x113>
  803ca1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ca5:	77 0f                	ja     803cb6 <__umoddi3+0x122>
  803ca7:	89 f2                	mov    %esi,%edx
  803ca9:	29 f9                	sub    %edi,%ecx
  803cab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803caf:	89 14 24             	mov    %edx,(%esp)
  803cb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cb6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cba:	8b 14 24             	mov    (%esp),%edx
  803cbd:	83 c4 1c             	add    $0x1c,%esp
  803cc0:	5b                   	pop    %ebx
  803cc1:	5e                   	pop    %esi
  803cc2:	5f                   	pop    %edi
  803cc3:	5d                   	pop    %ebp
  803cc4:	c3                   	ret    
  803cc5:	8d 76 00             	lea    0x0(%esi),%esi
  803cc8:	2b 04 24             	sub    (%esp),%eax
  803ccb:	19 fa                	sbb    %edi,%edx
  803ccd:	89 d1                	mov    %edx,%ecx
  803ccf:	89 c6                	mov    %eax,%esi
  803cd1:	e9 71 ff ff ff       	jmp    803c47 <__umoddi3+0xb3>
  803cd6:	66 90                	xchg   %ax,%ax
  803cd8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cdc:	72 ea                	jb     803cc8 <__umoddi3+0x134>
  803cde:	89 d9                	mov    %ebx,%ecx
  803ce0:	e9 62 ff ff ff       	jmp    803c47 <__umoddi3+0xb3>
