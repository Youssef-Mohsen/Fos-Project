
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
  800052:	68 20 1f 80 00       	push   $0x801f20
  800057:	e8 cf 0a 00 00       	call   800b2b <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 22 0f 00 00       	call   800f94 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 c8 12 00 00       	call   801350 <malloc>
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
  8000ab:	e8 c9 12 00 00       	call   801379 <free>
  8000b0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000bc:	68 3e 1f 80 00       	push   $0x801f3e
  8000c1:	e8 ff 02 00 00       	call   8003c5 <atomic_cprintf>
  8000c6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000c9:	e8 bd 17 00 00       	call   80188b <inctst>
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
  80017d:	e8 cb 15 00 00       	call   80174d <sys_getenvindex>
  800182:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800185:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800188:	89 d0                	mov    %edx,%eax
  80018a:	c1 e0 06             	shl    $0x6,%eax
  80018d:	29 d0                	sub    %edx,%eax
  80018f:	c1 e0 02             	shl    $0x2,%eax
  800192:	01 d0                	add    %edx,%eax
  800194:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80019b:	01 c8                	add    %ecx,%eax
  80019d:	c1 e0 03             	shl    $0x3,%eax
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001a9:	29 c2                	sub    %eax,%edx
  8001ab:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8001b2:	89 c2                	mov    %eax,%edx
  8001b4:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001ba:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001bf:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c4:	8a 40 20             	mov    0x20(%eax),%al
  8001c7:	84 c0                	test   %al,%al
  8001c9:	74 0d                	je     8001d8 <libmain+0x61>
		binaryname = myEnv->prog_name;
  8001cb:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d0:	83 c0 20             	add    $0x20,%eax
  8001d3:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001dc:	7e 0a                	jle    8001e8 <libmain+0x71>
		binaryname = argv[0];
  8001de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e1:	8b 00                	mov    (%eax),%eax
  8001e3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001e8:	83 ec 08             	sub    $0x8,%esp
  8001eb:	ff 75 0c             	pushl  0xc(%ebp)
  8001ee:	ff 75 08             	pushl  0x8(%ebp)
  8001f1:	e8 42 fe ff ff       	call   800038 <_main>
  8001f6:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001f9:	e8 d3 12 00 00       	call   8014d1 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001fe:	83 ec 0c             	sub    $0xc,%esp
  800201:	68 6c 1f 80 00       	push   $0x801f6c
  800206:	e8 8d 01 00 00       	call   800398 <cprintf>
  80020b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80020e:	a1 04 30 80 00       	mov    0x803004,%eax
  800213:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800219:	a1 04 30 80 00       	mov    0x803004,%eax
  80021e:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	52                   	push   %edx
  800228:	50                   	push   %eax
  800229:	68 94 1f 80 00       	push   $0x801f94
  80022e:	e8 65 01 00 00       	call   800398 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800236:	a1 04 30 80 00       	mov    0x803004,%eax
  80023b:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800241:	a1 04 30 80 00       	mov    0x803004,%eax
  800246:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80024c:	a1 04 30 80 00       	mov    0x803004,%eax
  800251:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800257:	51                   	push   %ecx
  800258:	52                   	push   %edx
  800259:	50                   	push   %eax
  80025a:	68 bc 1f 80 00       	push   $0x801fbc
  80025f:	e8 34 01 00 00       	call   800398 <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800267:	a1 04 30 80 00       	mov    0x803004,%eax
  80026c:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	50                   	push   %eax
  800276:	68 14 20 80 00       	push   $0x802014
  80027b:	e8 18 01 00 00       	call   800398 <cprintf>
  800280:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	68 6c 1f 80 00       	push   $0x801f6c
  80028b:	e8 08 01 00 00       	call   800398 <cprintf>
  800290:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800293:	e8 53 12 00 00       	call   8014eb <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800298:	e8 19 00 00 00       	call   8002b6 <exit>
}
  80029d:	90                   	nop
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    

008002a0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002a6:	83 ec 0c             	sub    $0xc,%esp
  8002a9:	6a 00                	push   $0x0
  8002ab:	e8 69 14 00 00       	call   801719 <sys_destroy_env>
  8002b0:	83 c4 10             	add    $0x10,%esp
}
  8002b3:	90                   	nop
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <exit>:

void
exit(void)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002bc:	e8 be 14 00 00       	call   80177f <sys_exit_env>
}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cd:	8b 00                	mov    (%eax),%eax
  8002cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8002d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d5:	89 0a                	mov    %ecx,(%edx)
  8002d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002da:	88 d1                	mov    %dl,%cl
  8002dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002df:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e6:	8b 00                	mov    (%eax),%eax
  8002e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ed:	75 2c                	jne    80031b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002ef:	a0 08 30 80 00       	mov    0x803008,%al
  8002f4:	0f b6 c0             	movzbl %al,%eax
  8002f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002fa:	8b 12                	mov    (%edx),%edx
  8002fc:	89 d1                	mov    %edx,%ecx
  8002fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800301:	83 c2 08             	add    $0x8,%edx
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	50                   	push   %eax
  800308:	51                   	push   %ecx
  800309:	52                   	push   %edx
  80030a:	e8 80 11 00 00       	call   80148f <sys_cputs>
  80030f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800312:	8b 45 0c             	mov    0xc(%ebp),%eax
  800315:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	8b 40 04             	mov    0x4(%eax),%eax
  800321:	8d 50 01             	lea    0x1(%eax),%edx
  800324:	8b 45 0c             	mov    0xc(%ebp),%eax
  800327:	89 50 04             	mov    %edx,0x4(%eax)
}
  80032a:	90                   	nop
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800336:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80033d:	00 00 00 
	b.cnt = 0;
  800340:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800347:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80034a:	ff 75 0c             	pushl  0xc(%ebp)
  80034d:	ff 75 08             	pushl  0x8(%ebp)
  800350:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800356:	50                   	push   %eax
  800357:	68 c4 02 80 00       	push   $0x8002c4
  80035c:	e8 11 02 00 00       	call   800572 <vprintfmt>
  800361:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800364:	a0 08 30 80 00       	mov    0x803008,%al
  800369:	0f b6 c0             	movzbl %al,%eax
  80036c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800372:	83 ec 04             	sub    $0x4,%esp
  800375:	50                   	push   %eax
  800376:	52                   	push   %edx
  800377:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80037d:	83 c0 08             	add    $0x8,%eax
  800380:	50                   	push   %eax
  800381:	e8 09 11 00 00       	call   80148f <sys_cputs>
  800386:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800389:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800390:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800396:	c9                   	leave  
  800397:	c3                   	ret    

00800398 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80039e:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8003a5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ae:	83 ec 08             	sub    $0x8,%esp
  8003b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003b4:	50                   	push   %eax
  8003b5:	e8 73 ff ff ff       	call   80032d <vcprintf>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003c3:	c9                   	leave  
  8003c4:	c3                   	ret    

008003c5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003cb:	e8 01 11 00 00       	call   8014d1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003d0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	83 ec 08             	sub    $0x8,%esp
  8003dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8003df:	50                   	push   %eax
  8003e0:	e8 48 ff ff ff       	call   80032d <vcprintf>
  8003e5:	83 c4 10             	add    $0x10,%esp
  8003e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003eb:	e8 fb 10 00 00       	call   8014eb <sys_unlock_cons>
	return cnt;
  8003f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f3:	c9                   	leave  
  8003f4:	c3                   	ret    

008003f5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
  8003f8:	53                   	push   %ebx
  8003f9:	83 ec 14             	sub    $0x14,%esp
  8003fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800408:	8b 45 18             	mov    0x18(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800413:	77 55                	ja     80046a <printnum+0x75>
  800415:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800418:	72 05                	jb     80041f <printnum+0x2a>
  80041a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80041d:	77 4b                	ja     80046a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80041f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800422:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800425:	8b 45 18             	mov    0x18(%ebp),%eax
  800428:	ba 00 00 00 00       	mov    $0x0,%edx
  80042d:	52                   	push   %edx
  80042e:	50                   	push   %eax
  80042f:	ff 75 f4             	pushl  -0xc(%ebp)
  800432:	ff 75 f0             	pushl  -0x10(%ebp)
  800435:	e8 7e 18 00 00       	call   801cb8 <__udivdi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	83 ec 04             	sub    $0x4,%esp
  800440:	ff 75 20             	pushl  0x20(%ebp)
  800443:	53                   	push   %ebx
  800444:	ff 75 18             	pushl  0x18(%ebp)
  800447:	52                   	push   %edx
  800448:	50                   	push   %eax
  800449:	ff 75 0c             	pushl  0xc(%ebp)
  80044c:	ff 75 08             	pushl  0x8(%ebp)
  80044f:	e8 a1 ff ff ff       	call   8003f5 <printnum>
  800454:	83 c4 20             	add    $0x20,%esp
  800457:	eb 1a                	jmp    800473 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800459:	83 ec 08             	sub    $0x8,%esp
  80045c:	ff 75 0c             	pushl  0xc(%ebp)
  80045f:	ff 75 20             	pushl  0x20(%ebp)
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	ff d0                	call   *%eax
  800467:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80046a:	ff 4d 1c             	decl   0x1c(%ebp)
  80046d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800471:	7f e6                	jg     800459 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800473:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800476:	bb 00 00 00 00       	mov    $0x0,%ebx
  80047b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80047e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800481:	53                   	push   %ebx
  800482:	51                   	push   %ecx
  800483:	52                   	push   %edx
  800484:	50                   	push   %eax
  800485:	e8 3e 19 00 00       	call   801dc8 <__umoddi3>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	05 54 22 80 00       	add    $0x802254,%eax
  800492:	8a 00                	mov    (%eax),%al
  800494:	0f be c0             	movsbl %al,%eax
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	ff 75 0c             	pushl  0xc(%ebp)
  80049d:	50                   	push   %eax
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	ff d0                	call   *%eax
  8004a3:	83 c4 10             	add    $0x10,%esp
}
  8004a6:	90                   	nop
  8004a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004aa:	c9                   	leave  
  8004ab:	c3                   	ret    

008004ac <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004ac:	55                   	push   %ebp
  8004ad:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004af:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004b3:	7e 1c                	jle    8004d1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	8d 50 08             	lea    0x8(%eax),%edx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	89 10                	mov    %edx,(%eax)
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	83 e8 08             	sub    $0x8,%eax
  8004ca:	8b 50 04             	mov    0x4(%eax),%edx
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	eb 40                	jmp    800511 <getuint+0x65>
	else if (lflag)
  8004d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d5:	74 1e                	je     8004f5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	8b 00                	mov    (%eax),%eax
  8004dc:	8d 50 04             	lea    0x4(%eax),%edx
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	89 10                	mov    %edx,(%eax)
  8004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e7:	8b 00                	mov    (%eax),%eax
  8004e9:	83 e8 04             	sub    $0x4,%eax
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f3:	eb 1c                	jmp    800511 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f8:	8b 00                	mov    (%eax),%eax
  8004fa:	8d 50 04             	lea    0x4(%eax),%edx
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	89 10                	mov    %edx,(%eax)
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
  800505:	8b 00                	mov    (%eax),%eax
  800507:	83 e8 04             	sub    $0x4,%eax
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800511:	5d                   	pop    %ebp
  800512:	c3                   	ret    

00800513 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800513:	55                   	push   %ebp
  800514:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800516:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80051a:	7e 1c                	jle    800538 <getint+0x25>
		return va_arg(*ap, long long);
  80051c:	8b 45 08             	mov    0x8(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	8d 50 08             	lea    0x8(%eax),%edx
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	89 10                	mov    %edx,(%eax)
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	83 e8 08             	sub    $0x8,%eax
  800531:	8b 50 04             	mov    0x4(%eax),%edx
  800534:	8b 00                	mov    (%eax),%eax
  800536:	eb 38                	jmp    800570 <getint+0x5d>
	else if (lflag)
  800538:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80053c:	74 1a                	je     800558 <getint+0x45>
		return va_arg(*ap, long);
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	8b 00                	mov    (%eax),%eax
  800543:	8d 50 04             	lea    0x4(%eax),%edx
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	89 10                	mov    %edx,(%eax)
  80054b:	8b 45 08             	mov    0x8(%ebp),%eax
  80054e:	8b 00                	mov    (%eax),%eax
  800550:	83 e8 04             	sub    $0x4,%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	99                   	cltd   
  800556:	eb 18                	jmp    800570 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	8b 00                	mov    (%eax),%eax
  80055d:	8d 50 04             	lea    0x4(%eax),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	89 10                	mov    %edx,(%eax)
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	83 e8 04             	sub    $0x4,%eax
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	99                   	cltd   
}
  800570:	5d                   	pop    %ebp
  800571:	c3                   	ret    

00800572 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	56                   	push   %esi
  800576:	53                   	push   %ebx
  800577:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80057a:	eb 17                	jmp    800593 <vprintfmt+0x21>
			if (ch == '\0')
  80057c:	85 db                	test   %ebx,%ebx
  80057e:	0f 84 c1 03 00 00    	je     800945 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800584:	83 ec 08             	sub    $0x8,%esp
  800587:	ff 75 0c             	pushl  0xc(%ebp)
  80058a:	53                   	push   %ebx
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	ff d0                	call   *%eax
  800590:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800593:	8b 45 10             	mov    0x10(%ebp),%eax
  800596:	8d 50 01             	lea    0x1(%eax),%edx
  800599:	89 55 10             	mov    %edx,0x10(%ebp)
  80059c:	8a 00                	mov    (%eax),%al
  80059e:	0f b6 d8             	movzbl %al,%ebx
  8005a1:	83 fb 25             	cmp    $0x25,%ebx
  8005a4:	75 d6                	jne    80057c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005a6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005aa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005bf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c9:	8d 50 01             	lea    0x1(%eax),%edx
  8005cc:	89 55 10             	mov    %edx,0x10(%ebp)
  8005cf:	8a 00                	mov    (%eax),%al
  8005d1:	0f b6 d8             	movzbl %al,%ebx
  8005d4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005d7:	83 f8 5b             	cmp    $0x5b,%eax
  8005da:	0f 87 3d 03 00 00    	ja     80091d <vprintfmt+0x3ab>
  8005e0:	8b 04 85 78 22 80 00 	mov    0x802278(,%eax,4),%eax
  8005e7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005e9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005ed:	eb d7                	jmp    8005c6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005ef:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005f3:	eb d1                	jmp    8005c6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ff:	89 d0                	mov    %edx,%eax
  800601:	c1 e0 02             	shl    $0x2,%eax
  800604:	01 d0                	add    %edx,%eax
  800606:	01 c0                	add    %eax,%eax
  800608:	01 d8                	add    %ebx,%eax
  80060a:	83 e8 30             	sub    $0x30,%eax
  80060d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800610:	8b 45 10             	mov    0x10(%ebp),%eax
  800613:	8a 00                	mov    (%eax),%al
  800615:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800618:	83 fb 2f             	cmp    $0x2f,%ebx
  80061b:	7e 3e                	jle    80065b <vprintfmt+0xe9>
  80061d:	83 fb 39             	cmp    $0x39,%ebx
  800620:	7f 39                	jg     80065b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800622:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800625:	eb d5                	jmp    8005fc <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	83 c0 04             	add    $0x4,%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	83 e8 04             	sub    $0x4,%eax
  800636:	8b 00                	mov    (%eax),%eax
  800638:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80063b:	eb 1f                	jmp    80065c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80063d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800641:	79 83                	jns    8005c6 <vprintfmt+0x54>
				width = 0;
  800643:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80064a:	e9 77 ff ff ff       	jmp    8005c6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80064f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800656:	e9 6b ff ff ff       	jmp    8005c6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80065b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80065c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800660:	0f 89 60 ff ff ff    	jns    8005c6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800669:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80066c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800673:	e9 4e ff ff ff       	jmp    8005c6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800678:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80067b:	e9 46 ff ff ff       	jmp    8005c6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800680:	8b 45 14             	mov    0x14(%ebp),%eax
  800683:	83 c0 04             	add    $0x4,%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	83 e8 04             	sub    $0x4,%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	83 ec 08             	sub    $0x8,%esp
  800694:	ff 75 0c             	pushl  0xc(%ebp)
  800697:	50                   	push   %eax
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	ff d0                	call   *%eax
  80069d:	83 c4 10             	add    $0x10,%esp
			break;
  8006a0:	e9 9b 02 00 00       	jmp    800940 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	83 c0 04             	add    $0x4,%eax
  8006ab:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	83 e8 04             	sub    $0x4,%eax
  8006b4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006b6:	85 db                	test   %ebx,%ebx
  8006b8:	79 02                	jns    8006bc <vprintfmt+0x14a>
				err = -err;
  8006ba:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006bc:	83 fb 64             	cmp    $0x64,%ebx
  8006bf:	7f 0b                	jg     8006cc <vprintfmt+0x15a>
  8006c1:	8b 34 9d c0 20 80 00 	mov    0x8020c0(,%ebx,4),%esi
  8006c8:	85 f6                	test   %esi,%esi
  8006ca:	75 19                	jne    8006e5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006cc:	53                   	push   %ebx
  8006cd:	68 65 22 80 00       	push   $0x802265
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	ff 75 08             	pushl  0x8(%ebp)
  8006d8:	e8 70 02 00 00       	call   80094d <printfmt>
  8006dd:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006e0:	e9 5b 02 00 00       	jmp    800940 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006e5:	56                   	push   %esi
  8006e6:	68 6e 22 80 00       	push   $0x80226e
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	ff 75 08             	pushl  0x8(%ebp)
  8006f1:	e8 57 02 00 00       	call   80094d <printfmt>
  8006f6:	83 c4 10             	add    $0x10,%esp
			break;
  8006f9:	e9 42 02 00 00       	jmp    800940 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	83 c0 04             	add    $0x4,%eax
  800704:	89 45 14             	mov    %eax,0x14(%ebp)
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	83 e8 04             	sub    $0x4,%eax
  80070d:	8b 30                	mov    (%eax),%esi
  80070f:	85 f6                	test   %esi,%esi
  800711:	75 05                	jne    800718 <vprintfmt+0x1a6>
				p = "(null)";
  800713:	be 71 22 80 00       	mov    $0x802271,%esi
			if (width > 0 && padc != '-')
  800718:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071c:	7e 6d                	jle    80078b <vprintfmt+0x219>
  80071e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800722:	74 67                	je     80078b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800724:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800727:	83 ec 08             	sub    $0x8,%esp
  80072a:	50                   	push   %eax
  80072b:	56                   	push   %esi
  80072c:	e8 26 05 00 00       	call   800c57 <strnlen>
  800731:	83 c4 10             	add    $0x10,%esp
  800734:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800737:	eb 16                	jmp    80074f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800739:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	50                   	push   %eax
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	ff d0                	call   *%eax
  800749:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80074c:	ff 4d e4             	decl   -0x1c(%ebp)
  80074f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800753:	7f e4                	jg     800739 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800755:	eb 34                	jmp    80078b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800757:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80075b:	74 1c                	je     800779 <vprintfmt+0x207>
  80075d:	83 fb 1f             	cmp    $0x1f,%ebx
  800760:	7e 05                	jle    800767 <vprintfmt+0x1f5>
  800762:	83 fb 7e             	cmp    $0x7e,%ebx
  800765:	7e 12                	jle    800779 <vprintfmt+0x207>
					putch('?', putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	6a 3f                	push   $0x3f
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	ff d0                	call   *%eax
  800774:	83 c4 10             	add    $0x10,%esp
  800777:	eb 0f                	jmp    800788 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	ff 75 0c             	pushl  0xc(%ebp)
  80077f:	53                   	push   %ebx
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	ff d0                	call   *%eax
  800785:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800788:	ff 4d e4             	decl   -0x1c(%ebp)
  80078b:	89 f0                	mov    %esi,%eax
  80078d:	8d 70 01             	lea    0x1(%eax),%esi
  800790:	8a 00                	mov    (%eax),%al
  800792:	0f be d8             	movsbl %al,%ebx
  800795:	85 db                	test   %ebx,%ebx
  800797:	74 24                	je     8007bd <vprintfmt+0x24b>
  800799:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80079d:	78 b8                	js     800757 <vprintfmt+0x1e5>
  80079f:	ff 4d e0             	decl   -0x20(%ebp)
  8007a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a6:	79 af                	jns    800757 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a8:	eb 13                	jmp    8007bd <vprintfmt+0x24b>
				putch(' ', putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	6a 20                	push   $0x20
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	ff d0                	call   *%eax
  8007b7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007ba:	ff 4d e4             	decl   -0x1c(%ebp)
  8007bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c1:	7f e7                	jg     8007aa <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007c3:	e9 78 01 00 00       	jmp    800940 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ce:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d1:	50                   	push   %eax
  8007d2:	e8 3c fd ff ff       	call   800513 <getint>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e6:	85 d2                	test   %edx,%edx
  8007e8:	79 23                	jns    80080d <vprintfmt+0x29b>
				putch('-', putdat);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	ff 75 0c             	pushl  0xc(%ebp)
  8007f0:	6a 2d                	push   $0x2d
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800800:	f7 d8                	neg    %eax
  800802:	83 d2 00             	adc    $0x0,%edx
  800805:	f7 da                	neg    %edx
  800807:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80080d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800814:	e9 bc 00 00 00       	jmp    8008d5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	ff 75 e8             	pushl  -0x18(%ebp)
  80081f:	8d 45 14             	lea    0x14(%ebp),%eax
  800822:	50                   	push   %eax
  800823:	e8 84 fc ff ff       	call   8004ac <getuint>
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800831:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800838:	e9 98 00 00 00       	jmp    8008d5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	6a 58                	push   $0x58
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	6a 58                	push   $0x58
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	ff d0                	call   *%eax
  80085a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	6a 58                	push   $0x58
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	ff d0                	call   *%eax
  80086a:	83 c4 10             	add    $0x10,%esp
			break;
  80086d:	e9 ce 00 00 00       	jmp    800940 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	ff 75 0c             	pushl  0xc(%ebp)
  800878:	6a 30                	push   $0x30
  80087a:	8b 45 08             	mov    0x8(%ebp),%eax
  80087d:	ff d0                	call   *%eax
  80087f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	6a 78                	push   $0x78
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	ff d0                	call   *%eax
  80088f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 c0 04             	add    $0x4,%eax
  800898:	89 45 14             	mov    %eax,0x14(%ebp)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008ad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008b4:	eb 1f                	jmp    8008d5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	ff 75 e8             	pushl  -0x18(%ebp)
  8008bc:	8d 45 14             	lea    0x14(%ebp),%eax
  8008bf:	50                   	push   %eax
  8008c0:	e8 e7 fb ff ff       	call   8004ac <getuint>
  8008c5:	83 c4 10             	add    $0x10,%esp
  8008c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008ce:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008d5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dc:	83 ec 04             	sub    $0x4,%esp
  8008df:	52                   	push   %edx
  8008e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008e3:	50                   	push   %eax
  8008e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	ff 75 08             	pushl  0x8(%ebp)
  8008f0:	e8 00 fb ff ff       	call   8003f5 <printnum>
  8008f5:	83 c4 20             	add    $0x20,%esp
			break;
  8008f8:	eb 46                	jmp    800940 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	53                   	push   %ebx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	ff d0                	call   *%eax
  800906:	83 c4 10             	add    $0x10,%esp
			break;
  800909:	eb 35                	jmp    800940 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80090b:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800912:	eb 2c                	jmp    800940 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800914:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80091b:	eb 23                	jmp    800940 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80091d:	83 ec 08             	sub    $0x8,%esp
  800920:	ff 75 0c             	pushl  0xc(%ebp)
  800923:	6a 25                	push   $0x25
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	ff d0                	call   *%eax
  80092a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80092d:	ff 4d 10             	decl   0x10(%ebp)
  800930:	eb 03                	jmp    800935 <vprintfmt+0x3c3>
  800932:	ff 4d 10             	decl   0x10(%ebp)
  800935:	8b 45 10             	mov    0x10(%ebp),%eax
  800938:	48                   	dec    %eax
  800939:	8a 00                	mov    (%eax),%al
  80093b:	3c 25                	cmp    $0x25,%al
  80093d:	75 f3                	jne    800932 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80093f:	90                   	nop
		}
	}
  800940:	e9 35 fc ff ff       	jmp    80057a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800945:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800946:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800949:	5b                   	pop    %ebx
  80094a:	5e                   	pop    %esi
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800953:	8d 45 10             	lea    0x10(%ebp),%eax
  800956:	83 c0 04             	add    $0x4,%eax
  800959:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80095c:	8b 45 10             	mov    0x10(%ebp),%eax
  80095f:	ff 75 f4             	pushl  -0xc(%ebp)
  800962:	50                   	push   %eax
  800963:	ff 75 0c             	pushl  0xc(%ebp)
  800966:	ff 75 08             	pushl  0x8(%ebp)
  800969:	e8 04 fc ff ff       	call   800572 <vprintfmt>
  80096e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800971:	90                   	nop
  800972:	c9                   	leave  
  800973:	c3                   	ret    

00800974 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	8b 40 08             	mov    0x8(%eax),%eax
  80097d:	8d 50 01             	lea    0x1(%eax),%edx
  800980:	8b 45 0c             	mov    0xc(%ebp),%eax
  800983:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800986:	8b 45 0c             	mov    0xc(%ebp),%eax
  800989:	8b 10                	mov    (%eax),%edx
  80098b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098e:	8b 40 04             	mov    0x4(%eax),%eax
  800991:	39 c2                	cmp    %eax,%edx
  800993:	73 12                	jae    8009a7 <sprintputch+0x33>
		*b->buf++ = ch;
  800995:	8b 45 0c             	mov    0xc(%ebp),%eax
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	8d 48 01             	lea    0x1(%eax),%ecx
  80099d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a0:	89 0a                	mov    %ecx,(%edx)
  8009a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009a5:	88 10                	mov    %dl,(%eax)
}
  8009a7:	90                   	nop
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	01 d0                	add    %edx,%eax
  8009c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009cf:	74 06                	je     8009d7 <vsnprintf+0x2d>
  8009d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009d5:	7f 07                	jg     8009de <vsnprintf+0x34>
		return -E_INVAL;
  8009d7:	b8 03 00 00 00       	mov    $0x3,%eax
  8009dc:	eb 20                	jmp    8009fe <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009de:	ff 75 14             	pushl  0x14(%ebp)
  8009e1:	ff 75 10             	pushl  0x10(%ebp)
  8009e4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e7:	50                   	push   %eax
  8009e8:	68 74 09 80 00       	push   $0x800974
  8009ed:	e8 80 fb ff ff       	call   800572 <vprintfmt>
  8009f2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a06:	8d 45 10             	lea    0x10(%ebp),%eax
  800a09:	83 c0 04             	add    $0x4,%eax
  800a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a12:	ff 75 f4             	pushl  -0xc(%ebp)
  800a15:	50                   	push   %eax
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	ff 75 08             	pushl  0x8(%ebp)
  800a1c:	e8 89 ff ff ff       	call   8009aa <vsnprintf>
  800a21:	83 c4 10             	add    $0x10,%esp
  800a24:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a36:	74 13                	je     800a4b <readline+0x1f>
		cprintf("%s", prompt);
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	ff 75 08             	pushl  0x8(%ebp)
  800a3e:	68 e8 23 80 00       	push   $0x8023e8
  800a43:	e8 50 f9 ff ff       	call   800398 <cprintf>
  800a48:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a52:	83 ec 0c             	sub    $0xc,%esp
  800a55:	6a 00                	push   $0x0
  800a57:	e8 67 10 00 00       	call   801ac3 <iscons>
  800a5c:	83 c4 10             	add    $0x10,%esp
  800a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a62:	e8 49 10 00 00       	call   801ab0 <getchar>
  800a67:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a6e:	79 22                	jns    800a92 <readline+0x66>
			if (c != -E_EOF)
  800a70:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a74:	0f 84 ad 00 00 00    	je     800b27 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800a7a:	83 ec 08             	sub    $0x8,%esp
  800a7d:	ff 75 ec             	pushl  -0x14(%ebp)
  800a80:	68 eb 23 80 00       	push   $0x8023eb
  800a85:	e8 0e f9 ff ff       	call   800398 <cprintf>
  800a8a:	83 c4 10             	add    $0x10,%esp
			break;
  800a8d:	e9 95 00 00 00       	jmp    800b27 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a92:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a96:	7e 34                	jle    800acc <readline+0xa0>
  800a98:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a9f:	7f 2b                	jg     800acc <readline+0xa0>
			if (echoing)
  800aa1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800aa5:	74 0e                	je     800ab5 <readline+0x89>
				cputchar(c);
  800aa7:	83 ec 0c             	sub    $0xc,%esp
  800aaa:	ff 75 ec             	pushl  -0x14(%ebp)
  800aad:	e8 df 0f 00 00       	call   801a91 <cputchar>
  800ab2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab8:	8d 50 01             	lea    0x1(%eax),%edx
  800abb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800abe:	89 c2                	mov    %eax,%edx
  800ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac3:	01 d0                	add    %edx,%eax
  800ac5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ac8:	88 10                	mov    %dl,(%eax)
  800aca:	eb 56                	jmp    800b22 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800acc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800ad0:	75 1f                	jne    800af1 <readline+0xc5>
  800ad2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ad6:	7e 19                	jle    800af1 <readline+0xc5>
			if (echoing)
  800ad8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800adc:	74 0e                	je     800aec <readline+0xc0>
				cputchar(c);
  800ade:	83 ec 0c             	sub    $0xc,%esp
  800ae1:	ff 75 ec             	pushl  -0x14(%ebp)
  800ae4:	e8 a8 0f 00 00       	call   801a91 <cputchar>
  800ae9:	83 c4 10             	add    $0x10,%esp

			i--;
  800aec:	ff 4d f4             	decl   -0xc(%ebp)
  800aef:	eb 31                	jmp    800b22 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800af1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800af5:	74 0a                	je     800b01 <readline+0xd5>
  800af7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800afb:	0f 85 61 ff ff ff    	jne    800a62 <readline+0x36>
			if (echoing)
  800b01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b05:	74 0e                	je     800b15 <readline+0xe9>
				cputchar(c);
  800b07:	83 ec 0c             	sub    $0xc,%esp
  800b0a:	ff 75 ec             	pushl  -0x14(%ebp)
  800b0d:	e8 7f 0f 00 00       	call   801a91 <cputchar>
  800b12:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	01 d0                	add    %edx,%eax
  800b1d:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b20:	eb 06                	jmp    800b28 <readline+0xfc>
		}
	}
  800b22:	e9 3b ff ff ff       	jmp    800a62 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b27:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b28:	90                   	nop
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b31:	e8 9b 09 00 00       	call   8014d1 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b3a:	74 13                	je     800b4f <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 08             	pushl  0x8(%ebp)
  800b42:	68 e8 23 80 00       	push   $0x8023e8
  800b47:	e8 4c f8 ff ff       	call   800398 <cprintf>
  800b4c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b4f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	6a 00                	push   $0x0
  800b5b:	e8 63 0f 00 00       	call   801ac3 <iscons>
  800b60:	83 c4 10             	add    $0x10,%esp
  800b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b66:	e8 45 0f 00 00       	call   801ab0 <getchar>
  800b6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800b6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b72:	79 22                	jns    800b96 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800b74:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800b78:	0f 84 ad 00 00 00    	je     800c2b <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800b7e:	83 ec 08             	sub    $0x8,%esp
  800b81:	ff 75 ec             	pushl  -0x14(%ebp)
  800b84:	68 eb 23 80 00       	push   $0x8023eb
  800b89:	e8 0a f8 ff ff       	call   800398 <cprintf>
  800b8e:	83 c4 10             	add    $0x10,%esp
				break;
  800b91:	e9 95 00 00 00       	jmp    800c2b <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800b96:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b9a:	7e 34                	jle    800bd0 <atomic_readline+0xa5>
  800b9c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ba3:	7f 2b                	jg     800bd0 <atomic_readline+0xa5>
				if (echoing)
  800ba5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ba9:	74 0e                	je     800bb9 <atomic_readline+0x8e>
					cputchar(c);
  800bab:	83 ec 0c             	sub    $0xc,%esp
  800bae:	ff 75 ec             	pushl  -0x14(%ebp)
  800bb1:	e8 db 0e 00 00       	call   801a91 <cputchar>
  800bb6:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bbc:	8d 50 01             	lea    0x1(%eax),%edx
  800bbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bc2:	89 c2                	mov    %eax,%edx
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	01 d0                	add    %edx,%eax
  800bc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bcc:	88 10                	mov    %dl,(%eax)
  800bce:	eb 56                	jmp    800c26 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800bd0:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bd4:	75 1f                	jne    800bf5 <atomic_readline+0xca>
  800bd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800bda:	7e 19                	jle    800bf5 <atomic_readline+0xca>
				if (echoing)
  800bdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800be0:	74 0e                	je     800bf0 <atomic_readline+0xc5>
					cputchar(c);
  800be2:	83 ec 0c             	sub    $0xc,%esp
  800be5:	ff 75 ec             	pushl  -0x14(%ebp)
  800be8:	e8 a4 0e 00 00       	call   801a91 <cputchar>
  800bed:	83 c4 10             	add    $0x10,%esp
				i--;
  800bf0:	ff 4d f4             	decl   -0xc(%ebp)
  800bf3:	eb 31                	jmp    800c26 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800bf5:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800bf9:	74 0a                	je     800c05 <atomic_readline+0xda>
  800bfb:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800bff:	0f 85 61 ff ff ff    	jne    800b66 <atomic_readline+0x3b>
				if (echoing)
  800c05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c09:	74 0e                	je     800c19 <atomic_readline+0xee>
					cputchar(c);
  800c0b:	83 ec 0c             	sub    $0xc,%esp
  800c0e:	ff 75 ec             	pushl  -0x14(%ebp)
  800c11:	e8 7b 0e 00 00       	call   801a91 <cputchar>
  800c16:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1f:	01 d0                	add    %edx,%eax
  800c21:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c24:	eb 06                	jmp    800c2c <atomic_readline+0x101>
			}
		}
  800c26:	e9 3b ff ff ff       	jmp    800b66 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c2b:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c2c:	e8 ba 08 00 00       	call   8014eb <sys_unlock_cons>
}
  800c31:	90                   	nop
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c41:	eb 06                	jmp    800c49 <strlen+0x15>
		n++;
  800c43:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c46:	ff 45 08             	incl   0x8(%ebp)
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	84 c0                	test   %al,%al
  800c50:	75 f1                	jne    800c43 <strlen+0xf>
		n++;
	return n;
  800c52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c5d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c64:	eb 09                	jmp    800c6f <strnlen+0x18>
		n++;
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c69:	ff 45 08             	incl   0x8(%ebp)
  800c6c:	ff 4d 0c             	decl   0xc(%ebp)
  800c6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c73:	74 09                	je     800c7e <strnlen+0x27>
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	84 c0                	test   %al,%al
  800c7c:	75 e8                	jne    800c66 <strnlen+0xf>
		n++;
	return n;
  800c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c8f:	90                   	nop
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8d 50 01             	lea    0x1(%eax),%edx
  800c96:	89 55 08             	mov    %edx,0x8(%ebp)
  800c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca2:	8a 12                	mov    (%edx),%dl
  800ca4:	88 10                	mov    %dl,(%eax)
  800ca6:	8a 00                	mov    (%eax),%al
  800ca8:	84 c0                	test   %al,%al
  800caa:	75 e4                	jne    800c90 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc4:	eb 1f                	jmp    800ce5 <strncpy+0x34>
		*dst++ = *src;
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	8d 50 01             	lea    0x1(%eax),%edx
  800ccc:	89 55 08             	mov    %edx,0x8(%ebp)
  800ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd2:	8a 12                	mov    (%edx),%dl
  800cd4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	84 c0                	test   %al,%al
  800cdd:	74 03                	je     800ce2 <strncpy+0x31>
			src++;
  800cdf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ce2:	ff 45 fc             	incl   -0x4(%ebp)
  800ce5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ceb:	72 d9                	jb     800cc6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d02:	74 30                	je     800d34 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d04:	eb 16                	jmp    800d1c <strlcpy+0x2a>
			*dst++ = *src++;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8d 50 01             	lea    0x1(%eax),%edx
  800d0c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d12:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d15:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d18:	8a 12                	mov    (%edx),%dl
  800d1a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d1c:	ff 4d 10             	decl   0x10(%ebp)
  800d1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d23:	74 09                	je     800d2e <strlcpy+0x3c>
  800d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	84 c0                	test   %al,%al
  800d2c:	75 d8                	jne    800d06 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3a:	29 c2                	sub    %eax,%edx
  800d3c:	89 d0                	mov    %edx,%eax
}
  800d3e:	c9                   	leave  
  800d3f:	c3                   	ret    

00800d40 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d43:	eb 06                	jmp    800d4b <strcmp+0xb>
		p++, q++;
  800d45:	ff 45 08             	incl   0x8(%ebp)
  800d48:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	84 c0                	test   %al,%al
  800d52:	74 0e                	je     800d62 <strcmp+0x22>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 10                	mov    (%eax),%dl
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	38 c2                	cmp    %al,%dl
  800d60:	74 e3                	je     800d45 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	0f b6 d0             	movzbl %al,%edx
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	0f b6 c0             	movzbl %al,%eax
  800d72:	29 c2                	sub    %eax,%edx
  800d74:	89 d0                	mov    %edx,%eax
}
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d7b:	eb 09                	jmp    800d86 <strncmp+0xe>
		n--, p++, q++;
  800d7d:	ff 4d 10             	decl   0x10(%ebp)
  800d80:	ff 45 08             	incl   0x8(%ebp)
  800d83:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8a:	74 17                	je     800da3 <strncmp+0x2b>
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	84 c0                	test   %al,%al
  800d93:	74 0e                	je     800da3 <strncmp+0x2b>
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 10                	mov    (%eax),%dl
  800d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	38 c2                	cmp    %al,%dl
  800da1:	74 da                	je     800d7d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800da3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da7:	75 07                	jne    800db0 <strncmp+0x38>
		return 0;
  800da9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dae:	eb 14                	jmp    800dc4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	8a 00                	mov    (%eax),%al
  800db5:	0f b6 d0             	movzbl %al,%edx
  800db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	0f b6 c0             	movzbl %al,%eax
  800dc0:	29 c2                	sub    %eax,%edx
  800dc2:	89 d0                	mov    %edx,%eax
}
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 04             	sub    $0x4,%esp
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd2:	eb 12                	jmp    800de6 <strchr+0x20>
		if (*s == c)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddc:	75 05                	jne    800de3 <strchr+0x1d>
			return (char *) s;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	eb 11                	jmp    800df4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800de3:	ff 45 08             	incl   0x8(%ebp)
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	84 c0                	test   %al,%al
  800ded:	75 e5                	jne    800dd4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800def:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df4:	c9                   	leave  
  800df5:	c3                   	ret    

00800df6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	83 ec 04             	sub    $0x4,%esp
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e02:	eb 0d                	jmp    800e11 <strfind+0x1b>
		if (*s == c)
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e0c:	74 0e                	je     800e1c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e0e:	ff 45 08             	incl   0x8(%ebp)
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	84 c0                	test   %al,%al
  800e18:	75 ea                	jne    800e04 <strfind+0xe>
  800e1a:	eb 01                	jmp    800e1d <strfind+0x27>
		if (*s == c)
			break;
  800e1c:	90                   	nop
	return (char *) s;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e34:	eb 0e                	jmp    800e44 <memset+0x22>
		*p++ = c;
  800e36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e42:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e44:	ff 4d f8             	decl   -0x8(%ebp)
  800e47:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e4b:	79 e9                	jns    800e36 <memset+0x14>
		*p++ = c;

	return v;
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e50:	c9                   	leave  
  800e51:	c3                   	ret    

00800e52 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e64:	eb 16                	jmp    800e7c <memcpy+0x2a>
		*d++ = *s++;
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 dd                	jne    800e66 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ea6:	73 50                	jae    800ef8 <memmove+0x6a>
  800ea8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eab:	8b 45 10             	mov    0x10(%ebp),%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eb3:	76 43                	jbe    800ef8 <memmove+0x6a>
		s += n;
  800eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ec1:	eb 10                	jmp    800ed3 <memmove+0x45>
			*--d = *--s;
  800ec3:	ff 4d f8             	decl   -0x8(%ebp)
  800ec6:	ff 4d fc             	decl   -0x4(%ebp)
  800ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecc:	8a 10                	mov    (%eax),%dl
  800ece:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed9:	89 55 10             	mov    %edx,0x10(%ebp)
  800edc:	85 c0                	test   %eax,%eax
  800ede:	75 e3                	jne    800ec3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ee0:	eb 23                	jmp    800f05 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee5:	8d 50 01             	lea    0x1(%eax),%edx
  800ee8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eeb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eee:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ef4:	8a 12                	mov    (%edx),%dl
  800ef6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  800efb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800efe:	89 55 10             	mov    %edx,0x10(%ebp)
  800f01:	85 c0                	test   %eax,%eax
  800f03:	75 dd                	jne    800ee2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f08:	c9                   	leave  
  800f09:	c3                   	ret    

00800f0a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f1c:	eb 2a                	jmp    800f48 <memcmp+0x3e>
		if (*s1 != *s2)
  800f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f21:	8a 10                	mov    (%eax),%dl
  800f23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	38 c2                	cmp    %al,%dl
  800f2a:	74 16                	je     800f42 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	0f b6 d0             	movzbl %al,%edx
  800f34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	0f b6 c0             	movzbl %al,%eax
  800f3c:	29 c2                	sub    %eax,%edx
  800f3e:	89 d0                	mov    %edx,%eax
  800f40:	eb 18                	jmp    800f5a <memcmp+0x50>
		s1++, s2++;
  800f42:	ff 45 fc             	incl   -0x4(%ebp)
  800f45:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f48:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f4e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f51:	85 c0                	test   %eax,%eax
  800f53:	75 c9                	jne    800f1e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f5a:	c9                   	leave  
  800f5b:	c3                   	ret    

00800f5c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f62:	8b 55 08             	mov    0x8(%ebp),%edx
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	01 d0                	add    %edx,%eax
  800f6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f6d:	eb 15                	jmp    800f84 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	0f b6 d0             	movzbl %al,%edx
  800f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7a:	0f b6 c0             	movzbl %al,%eax
  800f7d:	39 c2                	cmp    %eax,%edx
  800f7f:	74 0d                	je     800f8e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f81:	ff 45 08             	incl   0x8(%ebp)
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f8a:	72 e3                	jb     800f6f <memfind+0x13>
  800f8c:	eb 01                	jmp    800f8f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f8e:	90                   	nop
	return (void *) s;
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f92:	c9                   	leave  
  800f93:	c3                   	ret    

00800f94 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fa1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa8:	eb 03                	jmp    800fad <strtol+0x19>
		s++;
  800faa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 20                	cmp    $0x20,%al
  800fb4:	74 f4                	je     800faa <strtol+0x16>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 09                	cmp    $0x9,%al
  800fbd:	74 eb                	je     800faa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 2b                	cmp    $0x2b,%al
  800fc6:	75 05                	jne    800fcd <strtol+0x39>
		s++;
  800fc8:	ff 45 08             	incl   0x8(%ebp)
  800fcb:	eb 13                	jmp    800fe0 <strtol+0x4c>
	else if (*s == '-')
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 2d                	cmp    $0x2d,%al
  800fd4:	75 0a                	jne    800fe0 <strtol+0x4c>
		s++, neg = 1;
  800fd6:	ff 45 08             	incl   0x8(%ebp)
  800fd9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fe0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe4:	74 06                	je     800fec <strtol+0x58>
  800fe6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fea:	75 20                	jne    80100c <strtol+0x78>
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 30                	cmp    $0x30,%al
  800ff3:	75 17                	jne    80100c <strtol+0x78>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	40                   	inc    %eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 78                	cmp    $0x78,%al
  800ffd:	75 0d                	jne    80100c <strtol+0x78>
		s += 2, base = 16;
  800fff:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801003:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80100a:	eb 28                	jmp    801034 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80100c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801010:	75 15                	jne    801027 <strtol+0x93>
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	3c 30                	cmp    $0x30,%al
  801019:	75 0c                	jne    801027 <strtol+0x93>
		s++, base = 8;
  80101b:	ff 45 08             	incl   0x8(%ebp)
  80101e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801025:	eb 0d                	jmp    801034 <strtol+0xa0>
	else if (base == 0)
  801027:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102b:	75 07                	jne    801034 <strtol+0xa0>
		base = 10;
  80102d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	8a 00                	mov    (%eax),%al
  801039:	3c 2f                	cmp    $0x2f,%al
  80103b:	7e 19                	jle    801056 <strtol+0xc2>
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3c 39                	cmp    $0x39,%al
  801044:	7f 10                	jg     801056 <strtol+0xc2>
			dig = *s - '0';
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	0f be c0             	movsbl %al,%eax
  80104e:	83 e8 30             	sub    $0x30,%eax
  801051:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801054:	eb 42                	jmp    801098 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8a 00                	mov    (%eax),%al
  80105b:	3c 60                	cmp    $0x60,%al
  80105d:	7e 19                	jle    801078 <strtol+0xe4>
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 7a                	cmp    $0x7a,%al
  801066:	7f 10                	jg     801078 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	0f be c0             	movsbl %al,%eax
  801070:	83 e8 57             	sub    $0x57,%eax
  801073:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801076:	eb 20                	jmp    801098 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	3c 40                	cmp    $0x40,%al
  80107f:	7e 39                	jle    8010ba <strtol+0x126>
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8a 00                	mov    (%eax),%al
  801086:	3c 5a                	cmp    $0x5a,%al
  801088:	7f 30                	jg     8010ba <strtol+0x126>
			dig = *s - 'A' + 10;
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	0f be c0             	movsbl %al,%eax
  801092:	83 e8 37             	sub    $0x37,%eax
  801095:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80109e:	7d 19                	jge    8010b9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
  8010a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010aa:	89 c2                	mov    %eax,%edx
  8010ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010af:	01 d0                	add    %edx,%eax
  8010b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010b4:	e9 7b ff ff ff       	jmp    801034 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010b9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010be:	74 08                	je     8010c8 <strtol+0x134>
		*endptr = (char *) s;
  8010c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010cc:	74 07                	je     8010d5 <strtol+0x141>
  8010ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d1:	f7 d8                	neg    %eax
  8010d3:	eb 03                	jmp    8010d8 <strtol+0x144>
  8010d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <ltostr>:

void
ltostr(long value, char *str)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010f2:	79 13                	jns    801107 <ltostr+0x2d>
	{
		neg = 1;
  8010f4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fe:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801101:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801104:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80110f:	99                   	cltd   
  801110:	f7 f9                	idiv   %ecx
  801112:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801115:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801118:	8d 50 01             	lea    0x1(%eax),%edx
  80111b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80111e:	89 c2                	mov    %eax,%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	01 d0                	add    %edx,%eax
  801125:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801128:	83 c2 30             	add    $0x30,%edx
  80112b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80112d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801130:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801135:	f7 e9                	imul   %ecx
  801137:	c1 fa 02             	sar    $0x2,%edx
  80113a:	89 c8                	mov    %ecx,%eax
  80113c:	c1 f8 1f             	sar    $0x1f,%eax
  80113f:	29 c2                	sub    %eax,%edx
  801141:	89 d0                	mov    %edx,%eax
  801143:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801146:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80114a:	75 bb                	jne    801107 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80114c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801153:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801156:	48                   	dec    %eax
  801157:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80115a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80115e:	74 3d                	je     80119d <ltostr+0xc3>
		start = 1 ;
  801160:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801167:	eb 34                	jmp    80119d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801169:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	01 d0                	add    %edx,%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801176:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	01 c2                	add    %eax,%edx
  80117e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	01 c8                	add    %ecx,%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80118a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	01 c2                	add    %eax,%edx
  801192:	8a 45 eb             	mov    -0x15(%ebp),%al
  801195:	88 02                	mov    %al,(%edx)
		start++ ;
  801197:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80119a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80119d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a3:	7c c4                	jl     801169 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011a5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ab:	01 d0                	add    %edx,%eax
  8011ad:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011b0:	90                   	nop
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    

008011b3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011b9:	ff 75 08             	pushl  0x8(%ebp)
  8011bc:	e8 73 fa ff ff       	call   800c34 <strlen>
  8011c1:	83 c4 04             	add    $0x4,%esp
  8011c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011c7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ca:	e8 65 fa ff ff       	call   800c34 <strlen>
  8011cf:	83 c4 04             	add    $0x4,%esp
  8011d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011e3:	eb 17                	jmp    8011fc <strcconcat+0x49>
		final[s] = str1[s] ;
  8011e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011eb:	01 c2                	add    %eax,%edx
  8011ed:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	01 c8                	add    %ecx,%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011f9:	ff 45 fc             	incl   -0x4(%ebp)
  8011fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ff:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801202:	7c e1                	jl     8011e5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801204:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80120b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801212:	eb 1f                	jmp    801233 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801214:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801217:	8d 50 01             	lea    0x1(%eax),%edx
  80121a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80121d:	89 c2                	mov    %eax,%edx
  80121f:	8b 45 10             	mov    0x10(%ebp),%eax
  801222:	01 c2                	add    %eax,%edx
  801224:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	01 c8                	add    %ecx,%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801230:	ff 45 f8             	incl   -0x8(%ebp)
  801233:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801236:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801239:	7c d9                	jl     801214 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80123b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	01 d0                	add    %edx,%eax
  801243:	c6 00 00             	movb   $0x0,(%eax)
}
  801246:	90                   	nop
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80124c:	8b 45 14             	mov    0x14(%ebp),%eax
  80124f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 d0                	add    %edx,%eax
  801266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80126c:	eb 0c                	jmp    80127a <strsplit+0x31>
			*string++ = 0;
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8d 50 01             	lea    0x1(%eax),%edx
  801274:	89 55 08             	mov    %edx,0x8(%ebp)
  801277:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	8a 00                	mov    (%eax),%al
  80127f:	84 c0                	test   %al,%al
  801281:	74 18                	je     80129b <strsplit+0x52>
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	0f be c0             	movsbl %al,%eax
  80128b:	50                   	push   %eax
  80128c:	ff 75 0c             	pushl  0xc(%ebp)
  80128f:	e8 32 fb ff ff       	call   800dc6 <strchr>
  801294:	83 c4 08             	add    $0x8,%esp
  801297:	85 c0                	test   %eax,%eax
  801299:	75 d3                	jne    80126e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8a 00                	mov    (%eax),%al
  8012a0:	84 c0                	test   %al,%al
  8012a2:	74 5a                	je     8012fe <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a7:	8b 00                	mov    (%eax),%eax
  8012a9:	83 f8 0f             	cmp    $0xf,%eax
  8012ac:	75 07                	jne    8012b5 <strsplit+0x6c>
		{
			return 0;
  8012ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b3:	eb 66                	jmp    80131b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b8:	8b 00                	mov    (%eax),%eax
  8012ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8012bd:	8b 55 14             	mov    0x14(%ebp),%edx
  8012c0:	89 0a                	mov    %ecx,(%edx)
  8012c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	01 c2                	add    %eax,%edx
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012d3:	eb 03                	jmp    8012d8 <strsplit+0x8f>
			string++;
  8012d5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	84 c0                	test   %al,%al
  8012df:	74 8b                	je     80126c <strsplit+0x23>
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	0f be c0             	movsbl %al,%eax
  8012e9:	50                   	push   %eax
  8012ea:	ff 75 0c             	pushl  0xc(%ebp)
  8012ed:	e8 d4 fa ff ff       	call   800dc6 <strchr>
  8012f2:	83 c4 08             	add    $0x8,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	74 dc                	je     8012d5 <strsplit+0x8c>
			string++;
	}
  8012f9:	e9 6e ff ff ff       	jmp    80126c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012fe:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801302:	8b 00                	mov    (%eax),%eax
  801304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80130b:	8b 45 10             	mov    0x10(%ebp),%eax
  80130e:	01 d0                	add    %edx,%eax
  801310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801316:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801323:	83 ec 04             	sub    $0x4,%esp
  801326:	68 fc 23 80 00       	push   $0x8023fc
  80132b:	68 3f 01 00 00       	push   $0x13f
  801330:	68 1e 24 80 00       	push   $0x80241e
  801335:	e8 93 07 00 00       	call   801acd <_panic>

0080133a <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801340:	83 ec 0c             	sub    $0xc,%esp
  801343:	ff 75 08             	pushl  0x8(%ebp)
  801346:	e8 ef 06 00 00       	call   801a3a <sys_sbrk>
  80134b:	83 c4 10             	add    $0x10,%esp
}
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801356:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80135a:	75 07                	jne    801363 <malloc+0x13>
  80135c:	b8 00 00 00 00       	mov    $0x0,%eax
  801361:	eb 14                	jmp    801377 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	68 2c 24 80 00       	push   $0x80242c
  80136b:	6a 1b                	push   $0x1b
  80136d:	68 51 24 80 00       	push   $0x802451
  801372:	e8 56 07 00 00       	call   801acd <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801377:	c9                   	leave  
  801378:	c3                   	ret    

00801379 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80137f:	83 ec 04             	sub    $0x4,%esp
  801382:	68 60 24 80 00       	push   $0x802460
  801387:	6a 29                	push   $0x29
  801389:	68 51 24 80 00       	push   $0x802451
  80138e:	e8 3a 07 00 00       	call   801acd <_panic>

00801393 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	83 ec 18             	sub    $0x18,%esp
  801399:	8b 45 10             	mov    0x10(%ebp),%eax
  80139c:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80139f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013a3:	75 07                	jne    8013ac <smalloc+0x19>
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013aa:	eb 14                	jmp    8013c0 <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	68 84 24 80 00       	push   $0x802484
  8013b4:	6a 38                	push   $0x38
  8013b6:	68 51 24 80 00       	push   $0x802451
  8013bb:	e8 0d 07 00 00       	call   801acd <_panic>
	return NULL;
}
  8013c0:	c9                   	leave  
  8013c1:	c3                   	ret    

008013c2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013c8:	83 ec 04             	sub    $0x4,%esp
  8013cb:	68 ac 24 80 00       	push   $0x8024ac
  8013d0:	6a 43                	push   $0x43
  8013d2:	68 51 24 80 00       	push   $0x802451
  8013d7:	e8 f1 06 00 00       	call   801acd <_panic>

008013dc <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	68 d0 24 80 00       	push   $0x8024d0
  8013ea:	6a 5b                	push   $0x5b
  8013ec:	68 51 24 80 00       	push   $0x802451
  8013f1:	e8 d7 06 00 00       	call   801acd <_panic>

008013f6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013fc:	83 ec 04             	sub    $0x4,%esp
  8013ff:	68 f4 24 80 00       	push   $0x8024f4
  801404:	6a 72                	push   $0x72
  801406:	68 51 24 80 00       	push   $0x802451
  80140b:	e8 bd 06 00 00       	call   801acd <_panic>

00801410 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801416:	83 ec 04             	sub    $0x4,%esp
  801419:	68 1a 25 80 00       	push   $0x80251a
  80141e:	6a 7e                	push   $0x7e
  801420:	68 51 24 80 00       	push   $0x802451
  801425:	e8 a3 06 00 00       	call   801acd <_panic>

0080142a <shrink>:

}
void shrink(uint32 newSize)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801430:	83 ec 04             	sub    $0x4,%esp
  801433:	68 1a 25 80 00       	push   $0x80251a
  801438:	68 83 00 00 00       	push   $0x83
  80143d:	68 51 24 80 00       	push   $0x802451
  801442:	e8 86 06 00 00       	call   801acd <_panic>

00801447 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80144d:	83 ec 04             	sub    $0x4,%esp
  801450:	68 1a 25 80 00       	push   $0x80251a
  801455:	68 88 00 00 00       	push   $0x88
  80145a:	68 51 24 80 00       	push   $0x802451
  80145f:	e8 69 06 00 00       	call   801acd <_panic>

00801464 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	57                   	push   %edi
  801468:	56                   	push   %esi
  801469:	53                   	push   %ebx
  80146a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8b 55 0c             	mov    0xc(%ebp),%edx
  801473:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801476:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801479:	8b 7d 18             	mov    0x18(%ebp),%edi
  80147c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80147f:	cd 30                	int    $0x30
  801481:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801484:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801487:	83 c4 10             	add    $0x10,%esp
  80148a:	5b                   	pop    %ebx
  80148b:	5e                   	pop    %esi
  80148c:	5f                   	pop    %edi
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    

0080148f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 45 10             	mov    0x10(%ebp),%eax
  801498:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80149b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	52                   	push   %edx
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	50                   	push   %eax
  8014ab:	6a 00                	push   $0x0
  8014ad:	e8 b2 ff ff ff       	call   801464 <syscall>
  8014b2:	83 c4 18             	add    $0x18,%esp
}
  8014b5:	90                   	nop
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 02                	push   $0x2
  8014c7:	e8 98 ff ff ff       	call   801464 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 03                	push   $0x3
  8014e0:	e8 7f ff ff ff       	call   801464 <syscall>
  8014e5:	83 c4 18             	add    $0x18,%esp
}
  8014e8:	90                   	nop
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 04                	push   $0x4
  8014fa:	e8 65 ff ff ff       	call   801464 <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
}
  801502:	90                   	nop
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	52                   	push   %edx
  801515:	50                   	push   %eax
  801516:	6a 08                	push   $0x8
  801518:	e8 47 ff ff ff       	call   801464 <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	56                   	push   %esi
  801526:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801527:	8b 75 18             	mov    0x18(%ebp),%esi
  80152a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80152d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801530:	8b 55 0c             	mov    0xc(%ebp),%edx
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	56                   	push   %esi
  801537:	53                   	push   %ebx
  801538:	51                   	push   %ecx
  801539:	52                   	push   %edx
  80153a:	50                   	push   %eax
  80153b:	6a 09                	push   $0x9
  80153d:	e8 22 ff ff ff       	call   801464 <syscall>
  801542:	83 c4 18             	add    $0x18,%esp
}
  801545:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801548:	5b                   	pop    %ebx
  801549:	5e                   	pop    %esi
  80154a:	5d                   	pop    %ebp
  80154b:	c3                   	ret    

0080154c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80154f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	52                   	push   %edx
  80155c:	50                   	push   %eax
  80155d:	6a 0a                	push   $0xa
  80155f:	e8 00 ff ff ff       	call   801464 <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	ff 75 0c             	pushl  0xc(%ebp)
  801575:	ff 75 08             	pushl  0x8(%ebp)
  801578:	6a 0b                	push   $0xb
  80157a:	e8 e5 fe ff ff       	call   801464 <syscall>
  80157f:	83 c4 18             	add    $0x18,%esp
}
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 0c                	push   $0xc
  801593:	e8 cc fe ff ff       	call   801464 <syscall>
  801598:	83 c4 18             	add    $0x18,%esp
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 0d                	push   $0xd
  8015ac:	e8 b3 fe ff ff       	call   801464 <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 0e                	push   $0xe
  8015c5:	e8 9a fe ff ff       	call   801464 <syscall>
  8015ca:	83 c4 18             	add    $0x18,%esp
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 0f                	push   $0xf
  8015de:	e8 81 fe ff ff       	call   801464 <syscall>
  8015e3:	83 c4 18             	add    $0x18,%esp
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	ff 75 08             	pushl  0x8(%ebp)
  8015f6:	6a 10                	push   $0x10
  8015f8:	e8 67 fe ff ff       	call   801464 <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 11                	push   $0x11
  801611:	e8 4e fe ff ff       	call   801464 <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
}
  801619:	90                   	nop
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <sys_cputc>:

void
sys_cputc(const char c)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 04             	sub    $0x4,%esp
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801628:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	50                   	push   %eax
  801635:	6a 01                	push   $0x1
  801637:	e8 28 fe ff ff       	call   801464 <syscall>
  80163c:	83 c4 18             	add    $0x18,%esp
}
  80163f:	90                   	nop
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 14                	push   $0x14
  801651:	e8 0e fe ff ff       	call   801464 <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
}
  801659:	90                   	nop
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	83 ec 04             	sub    $0x4,%esp
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801668:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80166b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	6a 00                	push   $0x0
  801674:	51                   	push   %ecx
  801675:	52                   	push   %edx
  801676:	ff 75 0c             	pushl  0xc(%ebp)
  801679:	50                   	push   %eax
  80167a:	6a 15                	push   $0x15
  80167c:	e8 e3 fd ff ff       	call   801464 <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801689:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	52                   	push   %edx
  801696:	50                   	push   %eax
  801697:	6a 16                	push   $0x16
  801699:	e8 c6 fd ff ff       	call   801464 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	51                   	push   %ecx
  8016b4:	52                   	push   %edx
  8016b5:	50                   	push   %eax
  8016b6:	6a 17                	push   $0x17
  8016b8:	e8 a7 fd ff ff       	call   801464 <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	52                   	push   %edx
  8016d2:	50                   	push   %eax
  8016d3:	6a 18                	push   $0x18
  8016d5:	e8 8a fd ff ff       	call   801464 <syscall>
  8016da:	83 c4 18             	add    $0x18,%esp
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	6a 00                	push   $0x0
  8016e7:	ff 75 14             	pushl  0x14(%ebp)
  8016ea:	ff 75 10             	pushl  0x10(%ebp)
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	50                   	push   %eax
  8016f1:	6a 19                	push   $0x19
  8016f3:	e8 6c fd ff ff       	call   801464 <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_run_env>:

void sys_run_env(int32 envId)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	50                   	push   %eax
  80170c:	6a 1a                	push   $0x1a
  80170e:	e8 51 fd ff ff       	call   801464 <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	90                   	nop
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	50                   	push   %eax
  801728:	6a 1b                	push   $0x1b
  80172a:	e8 35 fd ff ff       	call   801464 <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 05                	push   $0x5
  801743:	e8 1c fd ff ff       	call   801464 <syscall>
  801748:	83 c4 18             	add    $0x18,%esp
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 06                	push   $0x6
  80175c:	e8 03 fd ff ff       	call   801464 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 07                	push   $0x7
  801775:	e8 ea fc ff ff       	call   801464 <syscall>
  80177a:	83 c4 18             	add    $0x18,%esp
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <sys_exit_env>:


void sys_exit_env(void)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 1c                	push   $0x1c
  80178e:	e8 d1 fc ff ff       	call   801464 <syscall>
  801793:	83 c4 18             	add    $0x18,%esp
}
  801796:	90                   	nop
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80179f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a2:	8d 50 04             	lea    0x4(%eax),%edx
  8017a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	52                   	push   %edx
  8017af:	50                   	push   %eax
  8017b0:	6a 1d                	push   $0x1d
  8017b2:	e8 ad fc ff ff       	call   801464 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
	return result;
  8017ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017c3:	89 01                	mov    %eax,(%ecx)
  8017c5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	c9                   	leave  
  8017cc:	c2 04 00             	ret    $0x4

008017cf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	ff 75 10             	pushl  0x10(%ebp)
  8017d9:	ff 75 0c             	pushl  0xc(%ebp)
  8017dc:	ff 75 08             	pushl  0x8(%ebp)
  8017df:	6a 13                	push   $0x13
  8017e1:	e8 7e fc ff ff       	call   801464 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e9:	90                   	nop
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_rcr2>:
uint32 sys_rcr2()
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 1e                	push   $0x1e
  8017fb:	e8 64 fc ff ff       	call   801464 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801811:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	50                   	push   %eax
  80181e:	6a 1f                	push   $0x1f
  801820:	e8 3f fc ff ff       	call   801464 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
	return ;
  801828:	90                   	nop
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <rsttst>:
void rsttst()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 21                	push   $0x21
  80183a:	e8 25 fc ff ff       	call   801464 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
	return ;
  801842:	90                   	nop
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	8b 45 14             	mov    0x14(%ebp),%eax
  80184e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801851:	8b 55 18             	mov    0x18(%ebp),%edx
  801854:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801858:	52                   	push   %edx
  801859:	50                   	push   %eax
  80185a:	ff 75 10             	pushl  0x10(%ebp)
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	6a 20                	push   $0x20
  801865:	e8 fa fb ff ff       	call   801464 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
	return ;
  80186d:	90                   	nop
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <chktst>:
void chktst(uint32 n)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	ff 75 08             	pushl  0x8(%ebp)
  80187e:	6a 22                	push   $0x22
  801880:	e8 df fb ff ff       	call   801464 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
	return ;
  801888:	90                   	nop
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <inctst>:

void inctst()
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 23                	push   $0x23
  80189a:	e8 c5 fb ff ff       	call   801464 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a2:	90                   	nop
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <gettst>:
uint32 gettst()
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 24                	push   $0x24
  8018b4:	e8 ab fb ff ff       	call   801464 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 25                	push   $0x25
  8018d0:	e8 8f fb ff ff       	call   801464 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
  8018d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018db:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018df:	75 07                	jne    8018e8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8018e6:	eb 05                	jmp    8018ed <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 25                	push   $0x25
  801901:	e8 5e fb ff ff       	call   801464 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
  801909:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80190c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801910:	75 07                	jne    801919 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801912:	b8 01 00 00 00       	mov    $0x1,%eax
  801917:	eb 05                	jmp    80191e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801919:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 25                	push   $0x25
  801932:	e8 2d fb ff ff       	call   801464 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
  80193a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80193d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801941:	75 07                	jne    80194a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801943:	b8 01 00 00 00       	mov    $0x1,%eax
  801948:	eb 05                	jmp    80194f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80194a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 25                	push   $0x25
  801963:	e8 fc fa ff ff       	call   801464 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
  80196b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80196e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801972:	75 07                	jne    80197b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801974:	b8 01 00 00 00       	mov    $0x1,%eax
  801979:	eb 05                	jmp    801980 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80197b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	ff 75 08             	pushl  0x8(%ebp)
  801990:	6a 26                	push   $0x26
  801992:	e8 cd fa ff ff       	call   801464 <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
	return ;
  80199a:	90                   	nop
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	53                   	push   %ebx
  8019b0:	51                   	push   %ecx
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	6a 27                	push   $0x27
  8019b5:	e8 aa fa ff ff       	call   801464 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	52                   	push   %edx
  8019d2:	50                   	push   %eax
  8019d3:	6a 28                	push   $0x28
  8019d5:	e8 8a fa ff ff       	call   801464 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8019e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	6a 00                	push   $0x0
  8019ed:	51                   	push   %ecx
  8019ee:	ff 75 10             	pushl  0x10(%ebp)
  8019f1:	52                   	push   %edx
  8019f2:	50                   	push   %eax
  8019f3:	6a 29                	push   $0x29
  8019f5:	e8 6a fa ff ff       	call   801464 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	ff 75 10             	pushl  0x10(%ebp)
  801a09:	ff 75 0c             	pushl  0xc(%ebp)
  801a0c:	ff 75 08             	pushl  0x8(%ebp)
  801a0f:	6a 12                	push   $0x12
  801a11:	e8 4e fa ff ff       	call   801464 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
	return ;
  801a19:	90                   	nop
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	52                   	push   %edx
  801a2c:	50                   	push   %eax
  801a2d:	6a 2a                	push   $0x2a
  801a2f:	e8 30 fa ff ff       	call   801464 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
	return;
  801a37:	90                   	nop
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	68 2a 25 80 00       	push   $0x80252a
  801a48:	68 2e 01 00 00       	push   $0x12e
  801a4d:	68 3e 25 80 00       	push   $0x80253e
  801a52:	e8 76 00 00 00       	call   801acd <_panic>

00801a57 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	68 2a 25 80 00       	push   $0x80252a
  801a65:	68 35 01 00 00       	push   $0x135
  801a6a:	68 3e 25 80 00       	push   $0x80253e
  801a6f:	e8 59 00 00 00       	call   801acd <_panic>

00801a74 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801a7a:	83 ec 04             	sub    $0x4,%esp
  801a7d:	68 2a 25 80 00       	push   $0x80252a
  801a82:	68 3b 01 00 00       	push   $0x13b
  801a87:	68 3e 25 80 00       	push   $0x80253e
  801a8c:	e8 3c 00 00 00       	call   801acd <_panic>

00801a91 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801a9d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801aa1:	83 ec 0c             	sub    $0xc,%esp
  801aa4:	50                   	push   %eax
  801aa5:	e8 72 fb ff ff       	call   80161c <sys_cputc>
  801aaa:	83 c4 10             	add    $0x10,%esp
}
  801aad:	90                   	nop
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <getchar>:


int
getchar(void)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ab6:	e8 fd f9 ff ff       	call   8014b8 <sys_cgetc>
  801abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <iscons>:

int iscons(int fdnum)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801ac6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801acb:	5d                   	pop    %ebp
  801acc:	c3                   	ret    

00801acd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801ad3:	8d 45 10             	lea    0x10(%ebp),%eax
  801ad6:	83 c0 04             	add    $0x4,%eax
  801ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801adc:	a1 24 30 80 00       	mov    0x803024,%eax
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	74 16                	je     801afb <_panic+0x2e>
		cprintf("%s: ", argv0);
  801ae5:	a1 24 30 80 00       	mov    0x803024,%eax
  801aea:	83 ec 08             	sub    $0x8,%esp
  801aed:	50                   	push   %eax
  801aee:	68 4c 25 80 00       	push   $0x80254c
  801af3:	e8 a0 e8 ff ff       	call   800398 <cprintf>
  801af8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801afb:	a1 00 30 80 00       	mov    0x803000,%eax
  801b00:	ff 75 0c             	pushl  0xc(%ebp)
  801b03:	ff 75 08             	pushl  0x8(%ebp)
  801b06:	50                   	push   %eax
  801b07:	68 51 25 80 00       	push   $0x802551
  801b0c:	e8 87 e8 ff ff       	call   800398 <cprintf>
  801b11:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801b14:	8b 45 10             	mov    0x10(%ebp),%eax
  801b17:	83 ec 08             	sub    $0x8,%esp
  801b1a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b1d:	50                   	push   %eax
  801b1e:	e8 0a e8 ff ff       	call   80032d <vcprintf>
  801b23:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801b26:	83 ec 08             	sub    $0x8,%esp
  801b29:	6a 00                	push   $0x0
  801b2b:	68 6d 25 80 00       	push   $0x80256d
  801b30:	e8 f8 e7 ff ff       	call   80032d <vcprintf>
  801b35:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801b38:	e8 79 e7 ff ff       	call   8002b6 <exit>

	// should not return here
	while (1) ;
  801b3d:	eb fe                	jmp    801b3d <_panic+0x70>

00801b3f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801b45:	a1 04 30 80 00       	mov    0x803004,%eax
  801b4a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	39 c2                	cmp    %eax,%edx
  801b55:	74 14                	je     801b6b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801b57:	83 ec 04             	sub    $0x4,%esp
  801b5a:	68 70 25 80 00       	push   $0x802570
  801b5f:	6a 26                	push   $0x26
  801b61:	68 bc 25 80 00       	push   $0x8025bc
  801b66:	e8 62 ff ff ff       	call   801acd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801b72:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b79:	e9 c5 00 00 00       	jmp    801c43 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	01 d0                	add    %edx,%eax
  801b8d:	8b 00                	mov    (%eax),%eax
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	75 08                	jne    801b9b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801b93:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801b96:	e9 a5 00 00 00       	jmp    801c40 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801b9b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ba2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801ba9:	eb 69                	jmp    801c14 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801bab:	a1 04 30 80 00       	mov    0x803004,%eax
  801bb0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801bb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bb9:	89 d0                	mov    %edx,%eax
  801bbb:	01 c0                	add    %eax,%eax
  801bbd:	01 d0                	add    %edx,%eax
  801bbf:	c1 e0 03             	shl    $0x3,%eax
  801bc2:	01 c8                	add    %ecx,%eax
  801bc4:	8a 40 04             	mov    0x4(%eax),%al
  801bc7:	84 c0                	test   %al,%al
  801bc9:	75 46                	jne    801c11 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801bcb:	a1 04 30 80 00       	mov    0x803004,%eax
  801bd0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801bd6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bd9:	89 d0                	mov    %edx,%eax
  801bdb:	01 c0                	add    %eax,%eax
  801bdd:	01 d0                	add    %edx,%eax
  801bdf:	c1 e0 03             	shl    $0x3,%eax
  801be2:	01 c8                	add    %ecx,%eax
  801be4:	8b 00                	mov    (%eax),%eax
  801be6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801be9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bf1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	01 c8                	add    %ecx,%eax
  801c02:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801c04:	39 c2                	cmp    %eax,%edx
  801c06:	75 09                	jne    801c11 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801c08:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801c0f:	eb 15                	jmp    801c26 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c11:	ff 45 e8             	incl   -0x18(%ebp)
  801c14:	a1 04 30 80 00       	mov    0x803004,%eax
  801c19:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c22:	39 c2                	cmp    %eax,%edx
  801c24:	77 85                	ja     801bab <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801c26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c2a:	75 14                	jne    801c40 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801c2c:	83 ec 04             	sub    $0x4,%esp
  801c2f:	68 c8 25 80 00       	push   $0x8025c8
  801c34:	6a 3a                	push   $0x3a
  801c36:	68 bc 25 80 00       	push   $0x8025bc
  801c3b:	e8 8d fe ff ff       	call   801acd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801c40:	ff 45 f0             	incl   -0x10(%ebp)
  801c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c46:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c49:	0f 8c 2f ff ff ff    	jl     801b7e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801c4f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c56:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c5d:	eb 26                	jmp    801c85 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801c5f:	a1 04 30 80 00       	mov    0x803004,%eax
  801c64:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801c6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c6d:	89 d0                	mov    %edx,%eax
  801c6f:	01 c0                	add    %eax,%eax
  801c71:	01 d0                	add    %edx,%eax
  801c73:	c1 e0 03             	shl    $0x3,%eax
  801c76:	01 c8                	add    %ecx,%eax
  801c78:	8a 40 04             	mov    0x4(%eax),%al
  801c7b:	3c 01                	cmp    $0x1,%al
  801c7d:	75 03                	jne    801c82 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801c7f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c82:	ff 45 e0             	incl   -0x20(%ebp)
  801c85:	a1 04 30 80 00       	mov    0x803004,%eax
  801c8a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c93:	39 c2                	cmp    %eax,%edx
  801c95:	77 c8                	ja     801c5f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801c9d:	74 14                	je     801cb3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801c9f:	83 ec 04             	sub    $0x4,%esp
  801ca2:	68 1c 26 80 00       	push   $0x80261c
  801ca7:	6a 44                	push   $0x44
  801ca9:	68 bc 25 80 00       	push   $0x8025bc
  801cae:	e8 1a fe ff ff       	call   801acd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801cb3:	90                   	nop
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    
  801cb6:	66 90                	xchg   %ax,%ax

00801cb8 <__udivdi3>:
  801cb8:	55                   	push   %ebp
  801cb9:	57                   	push   %edi
  801cba:	56                   	push   %esi
  801cbb:	53                   	push   %ebx
  801cbc:	83 ec 1c             	sub    $0x1c,%esp
  801cbf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cc3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cc7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ccb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ccf:	89 ca                	mov    %ecx,%edx
  801cd1:	89 f8                	mov    %edi,%eax
  801cd3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cd7:	85 f6                	test   %esi,%esi
  801cd9:	75 2d                	jne    801d08 <__udivdi3+0x50>
  801cdb:	39 cf                	cmp    %ecx,%edi
  801cdd:	77 65                	ja     801d44 <__udivdi3+0x8c>
  801cdf:	89 fd                	mov    %edi,%ebp
  801ce1:	85 ff                	test   %edi,%edi
  801ce3:	75 0b                	jne    801cf0 <__udivdi3+0x38>
  801ce5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cea:	31 d2                	xor    %edx,%edx
  801cec:	f7 f7                	div    %edi
  801cee:	89 c5                	mov    %eax,%ebp
  801cf0:	31 d2                	xor    %edx,%edx
  801cf2:	89 c8                	mov    %ecx,%eax
  801cf4:	f7 f5                	div    %ebp
  801cf6:	89 c1                	mov    %eax,%ecx
  801cf8:	89 d8                	mov    %ebx,%eax
  801cfa:	f7 f5                	div    %ebp
  801cfc:	89 cf                	mov    %ecx,%edi
  801cfe:	89 fa                	mov    %edi,%edx
  801d00:	83 c4 1c             	add    $0x1c,%esp
  801d03:	5b                   	pop    %ebx
  801d04:	5e                   	pop    %esi
  801d05:	5f                   	pop    %edi
  801d06:	5d                   	pop    %ebp
  801d07:	c3                   	ret    
  801d08:	39 ce                	cmp    %ecx,%esi
  801d0a:	77 28                	ja     801d34 <__udivdi3+0x7c>
  801d0c:	0f bd fe             	bsr    %esi,%edi
  801d0f:	83 f7 1f             	xor    $0x1f,%edi
  801d12:	75 40                	jne    801d54 <__udivdi3+0x9c>
  801d14:	39 ce                	cmp    %ecx,%esi
  801d16:	72 0a                	jb     801d22 <__udivdi3+0x6a>
  801d18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d1c:	0f 87 9e 00 00 00    	ja     801dc0 <__udivdi3+0x108>
  801d22:	b8 01 00 00 00       	mov    $0x1,%eax
  801d27:	89 fa                	mov    %edi,%edx
  801d29:	83 c4 1c             	add    $0x1c,%esp
  801d2c:	5b                   	pop    %ebx
  801d2d:	5e                   	pop    %esi
  801d2e:	5f                   	pop    %edi
  801d2f:	5d                   	pop    %ebp
  801d30:	c3                   	ret    
  801d31:	8d 76 00             	lea    0x0(%esi),%esi
  801d34:	31 ff                	xor    %edi,%edi
  801d36:	31 c0                	xor    %eax,%eax
  801d38:	89 fa                	mov    %edi,%edx
  801d3a:	83 c4 1c             	add    $0x1c,%esp
  801d3d:	5b                   	pop    %ebx
  801d3e:	5e                   	pop    %esi
  801d3f:	5f                   	pop    %edi
  801d40:	5d                   	pop    %ebp
  801d41:	c3                   	ret    
  801d42:	66 90                	xchg   %ax,%ax
  801d44:	89 d8                	mov    %ebx,%eax
  801d46:	f7 f7                	div    %edi
  801d48:	31 ff                	xor    %edi,%edi
  801d4a:	89 fa                	mov    %edi,%edx
  801d4c:	83 c4 1c             	add    $0x1c,%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5f                   	pop    %edi
  801d52:	5d                   	pop    %ebp
  801d53:	c3                   	ret    
  801d54:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d59:	89 eb                	mov    %ebp,%ebx
  801d5b:	29 fb                	sub    %edi,%ebx
  801d5d:	89 f9                	mov    %edi,%ecx
  801d5f:	d3 e6                	shl    %cl,%esi
  801d61:	89 c5                	mov    %eax,%ebp
  801d63:	88 d9                	mov    %bl,%cl
  801d65:	d3 ed                	shr    %cl,%ebp
  801d67:	89 e9                	mov    %ebp,%ecx
  801d69:	09 f1                	or     %esi,%ecx
  801d6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d6f:	89 f9                	mov    %edi,%ecx
  801d71:	d3 e0                	shl    %cl,%eax
  801d73:	89 c5                	mov    %eax,%ebp
  801d75:	89 d6                	mov    %edx,%esi
  801d77:	88 d9                	mov    %bl,%cl
  801d79:	d3 ee                	shr    %cl,%esi
  801d7b:	89 f9                	mov    %edi,%ecx
  801d7d:	d3 e2                	shl    %cl,%edx
  801d7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d83:	88 d9                	mov    %bl,%cl
  801d85:	d3 e8                	shr    %cl,%eax
  801d87:	09 c2                	or     %eax,%edx
  801d89:	89 d0                	mov    %edx,%eax
  801d8b:	89 f2                	mov    %esi,%edx
  801d8d:	f7 74 24 0c          	divl   0xc(%esp)
  801d91:	89 d6                	mov    %edx,%esi
  801d93:	89 c3                	mov    %eax,%ebx
  801d95:	f7 e5                	mul    %ebp
  801d97:	39 d6                	cmp    %edx,%esi
  801d99:	72 19                	jb     801db4 <__udivdi3+0xfc>
  801d9b:	74 0b                	je     801da8 <__udivdi3+0xf0>
  801d9d:	89 d8                	mov    %ebx,%eax
  801d9f:	31 ff                	xor    %edi,%edi
  801da1:	e9 58 ff ff ff       	jmp    801cfe <__udivdi3+0x46>
  801da6:	66 90                	xchg   %ax,%ax
  801da8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801dac:	89 f9                	mov    %edi,%ecx
  801dae:	d3 e2                	shl    %cl,%edx
  801db0:	39 c2                	cmp    %eax,%edx
  801db2:	73 e9                	jae    801d9d <__udivdi3+0xe5>
  801db4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801db7:	31 ff                	xor    %edi,%edi
  801db9:	e9 40 ff ff ff       	jmp    801cfe <__udivdi3+0x46>
  801dbe:	66 90                	xchg   %ax,%ax
  801dc0:	31 c0                	xor    %eax,%eax
  801dc2:	e9 37 ff ff ff       	jmp    801cfe <__udivdi3+0x46>
  801dc7:	90                   	nop

00801dc8 <__umoddi3>:
  801dc8:	55                   	push   %ebp
  801dc9:	57                   	push   %edi
  801dca:	56                   	push   %esi
  801dcb:	53                   	push   %ebx
  801dcc:	83 ec 1c             	sub    $0x1c,%esp
  801dcf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dd3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ddb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ddf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801de3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801de7:	89 f3                	mov    %esi,%ebx
  801de9:	89 fa                	mov    %edi,%edx
  801deb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801def:	89 34 24             	mov    %esi,(%esp)
  801df2:	85 c0                	test   %eax,%eax
  801df4:	75 1a                	jne    801e10 <__umoddi3+0x48>
  801df6:	39 f7                	cmp    %esi,%edi
  801df8:	0f 86 a2 00 00 00    	jbe    801ea0 <__umoddi3+0xd8>
  801dfe:	89 c8                	mov    %ecx,%eax
  801e00:	89 f2                	mov    %esi,%edx
  801e02:	f7 f7                	div    %edi
  801e04:	89 d0                	mov    %edx,%eax
  801e06:	31 d2                	xor    %edx,%edx
  801e08:	83 c4 1c             	add    $0x1c,%esp
  801e0b:	5b                   	pop    %ebx
  801e0c:	5e                   	pop    %esi
  801e0d:	5f                   	pop    %edi
  801e0e:	5d                   	pop    %ebp
  801e0f:	c3                   	ret    
  801e10:	39 f0                	cmp    %esi,%eax
  801e12:	0f 87 ac 00 00 00    	ja     801ec4 <__umoddi3+0xfc>
  801e18:	0f bd e8             	bsr    %eax,%ebp
  801e1b:	83 f5 1f             	xor    $0x1f,%ebp
  801e1e:	0f 84 ac 00 00 00    	je     801ed0 <__umoddi3+0x108>
  801e24:	bf 20 00 00 00       	mov    $0x20,%edi
  801e29:	29 ef                	sub    %ebp,%edi
  801e2b:	89 fe                	mov    %edi,%esi
  801e2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e31:	89 e9                	mov    %ebp,%ecx
  801e33:	d3 e0                	shl    %cl,%eax
  801e35:	89 d7                	mov    %edx,%edi
  801e37:	89 f1                	mov    %esi,%ecx
  801e39:	d3 ef                	shr    %cl,%edi
  801e3b:	09 c7                	or     %eax,%edi
  801e3d:	89 e9                	mov    %ebp,%ecx
  801e3f:	d3 e2                	shl    %cl,%edx
  801e41:	89 14 24             	mov    %edx,(%esp)
  801e44:	89 d8                	mov    %ebx,%eax
  801e46:	d3 e0                	shl    %cl,%eax
  801e48:	89 c2                	mov    %eax,%edx
  801e4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e4e:	d3 e0                	shl    %cl,%eax
  801e50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e54:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e58:	89 f1                	mov    %esi,%ecx
  801e5a:	d3 e8                	shr    %cl,%eax
  801e5c:	09 d0                	or     %edx,%eax
  801e5e:	d3 eb                	shr    %cl,%ebx
  801e60:	89 da                	mov    %ebx,%edx
  801e62:	f7 f7                	div    %edi
  801e64:	89 d3                	mov    %edx,%ebx
  801e66:	f7 24 24             	mull   (%esp)
  801e69:	89 c6                	mov    %eax,%esi
  801e6b:	89 d1                	mov    %edx,%ecx
  801e6d:	39 d3                	cmp    %edx,%ebx
  801e6f:	0f 82 87 00 00 00    	jb     801efc <__umoddi3+0x134>
  801e75:	0f 84 91 00 00 00    	je     801f0c <__umoddi3+0x144>
  801e7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e7f:	29 f2                	sub    %esi,%edx
  801e81:	19 cb                	sbb    %ecx,%ebx
  801e83:	89 d8                	mov    %ebx,%eax
  801e85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e89:	d3 e0                	shl    %cl,%eax
  801e8b:	89 e9                	mov    %ebp,%ecx
  801e8d:	d3 ea                	shr    %cl,%edx
  801e8f:	09 d0                	or     %edx,%eax
  801e91:	89 e9                	mov    %ebp,%ecx
  801e93:	d3 eb                	shr    %cl,%ebx
  801e95:	89 da                	mov    %ebx,%edx
  801e97:	83 c4 1c             	add    $0x1c,%esp
  801e9a:	5b                   	pop    %ebx
  801e9b:	5e                   	pop    %esi
  801e9c:	5f                   	pop    %edi
  801e9d:	5d                   	pop    %ebp
  801e9e:	c3                   	ret    
  801e9f:	90                   	nop
  801ea0:	89 fd                	mov    %edi,%ebp
  801ea2:	85 ff                	test   %edi,%edi
  801ea4:	75 0b                	jne    801eb1 <__umoddi3+0xe9>
  801ea6:	b8 01 00 00 00       	mov    $0x1,%eax
  801eab:	31 d2                	xor    %edx,%edx
  801ead:	f7 f7                	div    %edi
  801eaf:	89 c5                	mov    %eax,%ebp
  801eb1:	89 f0                	mov    %esi,%eax
  801eb3:	31 d2                	xor    %edx,%edx
  801eb5:	f7 f5                	div    %ebp
  801eb7:	89 c8                	mov    %ecx,%eax
  801eb9:	f7 f5                	div    %ebp
  801ebb:	89 d0                	mov    %edx,%eax
  801ebd:	e9 44 ff ff ff       	jmp    801e06 <__umoddi3+0x3e>
  801ec2:	66 90                	xchg   %ax,%ax
  801ec4:	89 c8                	mov    %ecx,%eax
  801ec6:	89 f2                	mov    %esi,%edx
  801ec8:	83 c4 1c             	add    $0x1c,%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5e                   	pop    %esi
  801ecd:	5f                   	pop    %edi
  801ece:	5d                   	pop    %ebp
  801ecf:	c3                   	ret    
  801ed0:	3b 04 24             	cmp    (%esp),%eax
  801ed3:	72 06                	jb     801edb <__umoddi3+0x113>
  801ed5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ed9:	77 0f                	ja     801eea <__umoddi3+0x122>
  801edb:	89 f2                	mov    %esi,%edx
  801edd:	29 f9                	sub    %edi,%ecx
  801edf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ee3:	89 14 24             	mov    %edx,(%esp)
  801ee6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801eea:	8b 44 24 04          	mov    0x4(%esp),%eax
  801eee:	8b 14 24             	mov    (%esp),%edx
  801ef1:	83 c4 1c             	add    $0x1c,%esp
  801ef4:	5b                   	pop    %ebx
  801ef5:	5e                   	pop    %esi
  801ef6:	5f                   	pop    %edi
  801ef7:	5d                   	pop    %ebp
  801ef8:	c3                   	ret    
  801ef9:	8d 76 00             	lea    0x0(%esi),%esi
  801efc:	2b 04 24             	sub    (%esp),%eax
  801eff:	19 fa                	sbb    %edi,%edx
  801f01:	89 d1                	mov    %edx,%ecx
  801f03:	89 c6                	mov    %eax,%esi
  801f05:	e9 71 ff ff ff       	jmp    801e7b <__umoddi3+0xb3>
  801f0a:	66 90                	xchg   %ax,%ax
  801f0c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f10:	72 ea                	jb     801efc <__umoddi3+0x134>
  801f12:	89 d9                	mov    %ebx,%ecx
  801f14:	e9 62 ff ff ff       	jmp    801e7b <__umoddi3+0xb3>
