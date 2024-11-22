
obj/user/fib_memomize:     file format elf32-i386


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
  800031:	e8 7f 01 00 00       	call   8001b5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n, int64 *memo);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	int index=0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 a0 3d 80 00       	push   $0x803da0
  800057:	e8 ff 0a 00 00       	call   800b5b <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 52 0f 00 00       	call   800fc4 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 f8 12 00 00       	call   801380 <malloc>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (int i = 0; i <= index; ++i)
  80008e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800095:	eb 1f                	jmp    8000b6 <_main+0x7e>
	{
		memo[i] = 0;
  800097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80009a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a4:	01 d0                	add    %edx,%eax
  8000a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8000ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
	index = strtol(buff1, NULL, 10);

	int64 *memo = malloc((index+1) * sizeof(int64));
	for (int i = 0; i <= index; ++i)
  8000b3:	ff 45 f4             	incl   -0xc(%ebp)
  8000b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000bc:	7e d9                	jle    800097 <_main+0x5f>
	{
		memo[i] = 0;
	}
	int64 res = fibonacci(index, memo) ;
  8000be:	83 ec 08             	sub    $0x8,%esp
  8000c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8000c7:	e8 35 00 00 00       	call   800101 <fibonacci>
  8000cc:	83 c4 10             	add    $0x10,%esp
  8000cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8000d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)

	free(memo);
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000db:	e8 bf 14 00 00       	call   80159f <free>
  8000e0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ec:	68 be 3d 80 00       	push   $0x803dbe
  8000f1:	e8 ff 02 00 00       	call   8003f5 <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 6b 1b 00 00       	call   801c69 <inctst>
	return;
  8000fe:	90                   	nop
}
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    

00800101 <fibonacci>:


int64 fibonacci(int n, int64 *memo)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	57                   	push   %edi
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	83 ec 0c             	sub    $0xc,%esp
	if (memo[n]!=0)	return memo[n];
  80010a:	8b 45 08             	mov    0x8(%ebp),%eax
  80010d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800114:	8b 45 0c             	mov    0xc(%ebp),%eax
  800117:	01 d0                	add    %edx,%eax
  800119:	8b 50 04             	mov    0x4(%eax),%edx
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	09 d0                	or     %edx,%eax
  800120:	85 c0                	test   %eax,%eax
  800122:	74 16                	je     80013a <fibonacci+0x39>
  800124:	8b 45 08             	mov    0x8(%ebp),%eax
  800127:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80012e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800131:	01 d0                	add    %edx,%eax
  800133:	8b 50 04             	mov    0x4(%eax),%edx
  800136:	8b 00                	mov    (%eax),%eax
  800138:	eb 73                	jmp    8001ad <fibonacci+0xac>
	if (n <= 1)
  80013a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80013e:	7f 23                	jg     800163 <fibonacci+0x62>
		return memo[n] = 1 ;
  800140:	8b 45 08             	mov    0x8(%ebp),%eax
  800143:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80014a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014d:	01 d0                	add    %edx,%eax
  80014f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  800155:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80015c:	8b 50 04             	mov    0x4(%eax),%edx
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	eb 4a                	jmp    8001ad <fibonacci+0xac>
	return (memo[n] = fibonacci(n-1, memo) + fibonacci(n-2, memo)) ;
  800163:	8b 45 08             	mov    0x8(%ebp),%eax
  800166:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80016d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800170:	8d 3c 02             	lea    (%edx,%eax,1),%edi
  800173:	8b 45 08             	mov    0x8(%ebp),%eax
  800176:	48                   	dec    %eax
  800177:	83 ec 08             	sub    $0x8,%esp
  80017a:	ff 75 0c             	pushl  0xc(%ebp)
  80017d:	50                   	push   %eax
  80017e:	e8 7e ff ff ff       	call   800101 <fibonacci>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	89 c3                	mov    %eax,%ebx
  800188:	89 d6                	mov    %edx,%esi
  80018a:	8b 45 08             	mov    0x8(%ebp),%eax
  80018d:	83 e8 02             	sub    $0x2,%eax
  800190:	83 ec 08             	sub    $0x8,%esp
  800193:	ff 75 0c             	pushl  0xc(%ebp)
  800196:	50                   	push   %eax
  800197:	e8 65 ff ff ff       	call   800101 <fibonacci>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	01 d8                	add    %ebx,%eax
  8001a1:	11 f2                	adc    %esi,%edx
  8001a3:	89 07                	mov    %eax,(%edi)
  8001a5:	89 57 04             	mov    %edx,0x4(%edi)
  8001a8:	8b 07                	mov    (%edi),%eax
  8001aa:	8b 57 04             	mov    0x4(%edi),%edx
}
  8001ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b0:	5b                   	pop    %ebx
  8001b1:	5e                   	pop    %esi
  8001b2:	5f                   	pop    %edi
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    

008001b5 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001bb:	e8 6b 19 00 00       	call   801b2b <sys_getenvindex>
  8001c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001c6:	89 d0                	mov    %edx,%eax
  8001c8:	c1 e0 03             	shl    $0x3,%eax
  8001cb:	01 d0                	add    %edx,%eax
  8001cd:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001d4:	01 c8                	add    %ecx,%eax
  8001d6:	01 c0                	add    %eax,%eax
  8001d8:	01 d0                	add    %edx,%eax
  8001da:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8001e1:	01 c8                	add    %ecx,%eax
  8001e3:	01 d0                	add    %edx,%eax
  8001e5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ea:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f4:	8a 40 20             	mov    0x20(%eax),%al
  8001f7:	84 c0                	test   %al,%al
  8001f9:	74 0d                	je     800208 <libmain+0x53>
		binaryname = myEnv->prog_name;
  8001fb:	a1 20 50 80 00       	mov    0x805020,%eax
  800200:	83 c0 20             	add    $0x20,%eax
  800203:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800208:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80020c:	7e 0a                	jle    800218 <libmain+0x63>
		binaryname = argv[0];
  80020e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800211:	8b 00                	mov    (%eax),%eax
  800213:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 0c             	pushl  0xc(%ebp)
  80021e:	ff 75 08             	pushl  0x8(%ebp)
  800221:	e8 12 fe ff ff       	call   800038 <_main>
  800226:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800229:	e8 81 16 00 00       	call   8018af <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	68 ec 3d 80 00       	push   $0x803dec
  800236:	e8 8d 01 00 00       	call   8003c8 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80023e:	a1 20 50 80 00       	mov    0x805020,%eax
  800243:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800249:	a1 20 50 80 00       	mov    0x805020,%eax
  80024e:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  800254:	83 ec 04             	sub    $0x4,%esp
  800257:	52                   	push   %edx
  800258:	50                   	push   %eax
  800259:	68 14 3e 80 00       	push   $0x803e14
  80025e:	e8 65 01 00 00       	call   8003c8 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800266:	a1 20 50 80 00       	mov    0x805020,%eax
  80026b:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  800271:	a1 20 50 80 00       	mov    0x805020,%eax
  800276:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  80027c:	a1 20 50 80 00       	mov    0x805020,%eax
  800281:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800287:	51                   	push   %ecx
  800288:	52                   	push   %edx
  800289:	50                   	push   %eax
  80028a:	68 3c 3e 80 00       	push   $0x803e3c
  80028f:	e8 34 01 00 00       	call   8003c8 <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800297:	a1 20 50 80 00       	mov    0x805020,%eax
  80029c:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	50                   	push   %eax
  8002a6:	68 94 3e 80 00       	push   $0x803e94
  8002ab:	e8 18 01 00 00       	call   8003c8 <cprintf>
  8002b0:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	68 ec 3d 80 00       	push   $0x803dec
  8002bb:	e8 08 01 00 00       	call   8003c8 <cprintf>
  8002c0:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002c3:	e8 01 16 00 00       	call   8018c9 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8002c8:	e8 19 00 00 00       	call   8002e6 <exit>
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	6a 00                	push   $0x0
  8002db:	e8 17 18 00 00       	call   801af7 <sys_destroy_env>
  8002e0:	83 c4 10             	add    $0x10,%esp
}
  8002e3:	90                   	nop
  8002e4:	c9                   	leave  
  8002e5:	c3                   	ret    

008002e6 <exit>:

void
exit(void)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ec:	e8 6c 18 00 00       	call   801b5d <sys_exit_env>
}
  8002f1:	90                   	nop
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fd:	8b 00                	mov    (%eax),%eax
  8002ff:	8d 48 01             	lea    0x1(%eax),%ecx
  800302:	8b 55 0c             	mov    0xc(%ebp),%edx
  800305:	89 0a                	mov    %ecx,(%edx)
  800307:	8b 55 08             	mov    0x8(%ebp),%edx
  80030a:	88 d1                	mov    %dl,%cl
  80030c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80030f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800313:	8b 45 0c             	mov    0xc(%ebp),%eax
  800316:	8b 00                	mov    (%eax),%eax
  800318:	3d ff 00 00 00       	cmp    $0xff,%eax
  80031d:	75 2c                	jne    80034b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80031f:	a0 28 50 80 00       	mov    0x805028,%al
  800324:	0f b6 c0             	movzbl %al,%eax
  800327:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032a:	8b 12                	mov    (%edx),%edx
  80032c:	89 d1                	mov    %edx,%ecx
  80032e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800331:	83 c2 08             	add    $0x8,%edx
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	50                   	push   %eax
  800338:	51                   	push   %ecx
  800339:	52                   	push   %edx
  80033a:	e8 2e 15 00 00       	call   80186d <sys_cputs>
  80033f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80034b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034e:	8b 40 04             	mov    0x4(%eax),%eax
  800351:	8d 50 01             	lea    0x1(%eax),%edx
  800354:	8b 45 0c             	mov    0xc(%ebp),%eax
  800357:	89 50 04             	mov    %edx,0x4(%eax)
}
  80035a:	90                   	nop
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800366:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80036d:	00 00 00 
	b.cnt = 0;
  800370:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800377:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80037a:	ff 75 0c             	pushl  0xc(%ebp)
  80037d:	ff 75 08             	pushl  0x8(%ebp)
  800380:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800386:	50                   	push   %eax
  800387:	68 f4 02 80 00       	push   $0x8002f4
  80038c:	e8 11 02 00 00       	call   8005a2 <vprintfmt>
  800391:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800394:	a0 28 50 80 00       	mov    0x805028,%al
  800399:	0f b6 c0             	movzbl %al,%eax
  80039c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003a2:	83 ec 04             	sub    $0x4,%esp
  8003a5:	50                   	push   %eax
  8003a6:	52                   	push   %edx
  8003a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ad:	83 c0 08             	add    $0x8,%eax
  8003b0:	50                   	push   %eax
  8003b1:	e8 b7 14 00 00       	call   80186d <sys_cputs>
  8003b6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003b9:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8003c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003c6:	c9                   	leave  
  8003c7:	c3                   	ret    

008003c8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003ce:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8003d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003db:	8b 45 08             	mov    0x8(%ebp),%eax
  8003de:	83 ec 08             	sub    $0x8,%esp
  8003e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e4:	50                   	push   %eax
  8003e5:	e8 73 ff ff ff       	call   80035d <vcprintf>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f3:	c9                   	leave  
  8003f4:	c3                   	ret    

008003f5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
  8003f8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003fb:	e8 af 14 00 00       	call   8018af <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800400:	8d 45 0c             	lea    0xc(%ebp),%eax
  800403:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	ff 75 f4             	pushl  -0xc(%ebp)
  80040f:	50                   	push   %eax
  800410:	e8 48 ff ff ff       	call   80035d <vcprintf>
  800415:	83 c4 10             	add    $0x10,%esp
  800418:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80041b:	e8 a9 14 00 00       	call   8018c9 <sys_unlock_cons>
	return cnt;
  800420:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800423:	c9                   	leave  
  800424:	c3                   	ret    

00800425 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800425:	55                   	push   %ebp
  800426:	89 e5                	mov    %esp,%ebp
  800428:	53                   	push   %ebx
  800429:	83 ec 14             	sub    $0x14,%esp
  80042c:	8b 45 10             	mov    0x10(%ebp),%eax
  80042f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800438:	8b 45 18             	mov    0x18(%ebp),%eax
  80043b:	ba 00 00 00 00       	mov    $0x0,%edx
  800440:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800443:	77 55                	ja     80049a <printnum+0x75>
  800445:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800448:	72 05                	jb     80044f <printnum+0x2a>
  80044a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80044d:	77 4b                	ja     80049a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80044f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800452:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800455:	8b 45 18             	mov    0x18(%ebp),%eax
  800458:	ba 00 00 00 00       	mov    $0x0,%edx
  80045d:	52                   	push   %edx
  80045e:	50                   	push   %eax
  80045f:	ff 75 f4             	pushl  -0xc(%ebp)
  800462:	ff 75 f0             	pushl  -0x10(%ebp)
  800465:	e8 c2 36 00 00       	call   803b2c <__udivdi3>
  80046a:	83 c4 10             	add    $0x10,%esp
  80046d:	83 ec 04             	sub    $0x4,%esp
  800470:	ff 75 20             	pushl  0x20(%ebp)
  800473:	53                   	push   %ebx
  800474:	ff 75 18             	pushl  0x18(%ebp)
  800477:	52                   	push   %edx
  800478:	50                   	push   %eax
  800479:	ff 75 0c             	pushl  0xc(%ebp)
  80047c:	ff 75 08             	pushl  0x8(%ebp)
  80047f:	e8 a1 ff ff ff       	call   800425 <printnum>
  800484:	83 c4 20             	add    $0x20,%esp
  800487:	eb 1a                	jmp    8004a3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800489:	83 ec 08             	sub    $0x8,%esp
  80048c:	ff 75 0c             	pushl  0xc(%ebp)
  80048f:	ff 75 20             	pushl  0x20(%ebp)
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	ff d0                	call   *%eax
  800497:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80049a:	ff 4d 1c             	decl   0x1c(%ebp)
  80049d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004a1:	7f e6                	jg     800489 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004a3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004b1:	53                   	push   %ebx
  8004b2:	51                   	push   %ecx
  8004b3:	52                   	push   %edx
  8004b4:	50                   	push   %eax
  8004b5:	e8 82 37 00 00       	call   803c3c <__umoddi3>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	05 d4 40 80 00       	add    $0x8040d4,%eax
  8004c2:	8a 00                	mov    (%eax),%al
  8004c4:	0f be c0             	movsbl %al,%eax
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	ff 75 0c             	pushl  0xc(%ebp)
  8004cd:	50                   	push   %eax
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	ff d0                	call   *%eax
  8004d3:	83 c4 10             	add    $0x10,%esp
}
  8004d6:	90                   	nop
  8004d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004da:	c9                   	leave  
  8004db:	c3                   	ret    

008004dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004df:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004e3:	7e 1c                	jle    800501 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	8d 50 08             	lea    0x8(%eax),%edx
  8004ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f0:	89 10                	mov    %edx,(%eax)
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	83 e8 08             	sub    $0x8,%eax
  8004fa:	8b 50 04             	mov    0x4(%eax),%edx
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	eb 40                	jmp    800541 <getuint+0x65>
	else if (lflag)
  800501:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800505:	74 1e                	je     800525 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	8b 00                	mov    (%eax),%eax
  80050c:	8d 50 04             	lea    0x4(%eax),%edx
  80050f:	8b 45 08             	mov    0x8(%ebp),%eax
  800512:	89 10                	mov    %edx,(%eax)
  800514:	8b 45 08             	mov    0x8(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	83 e8 04             	sub    $0x4,%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	ba 00 00 00 00       	mov    $0x0,%edx
  800523:	eb 1c                	jmp    800541 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	8d 50 04             	lea    0x4(%eax),%edx
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	89 10                	mov    %edx,(%eax)
  800532:	8b 45 08             	mov    0x8(%ebp),%eax
  800535:	8b 00                	mov    (%eax),%eax
  800537:	83 e8 04             	sub    $0x4,%eax
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800541:	5d                   	pop    %ebp
  800542:	c3                   	ret    

00800543 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800543:	55                   	push   %ebp
  800544:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800546:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80054a:	7e 1c                	jle    800568 <getint+0x25>
		return va_arg(*ap, long long);
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	8d 50 08             	lea    0x8(%eax),%edx
  800554:	8b 45 08             	mov    0x8(%ebp),%eax
  800557:	89 10                	mov    %edx,(%eax)
  800559:	8b 45 08             	mov    0x8(%ebp),%eax
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	83 e8 08             	sub    $0x8,%eax
  800561:	8b 50 04             	mov    0x4(%eax),%edx
  800564:	8b 00                	mov    (%eax),%eax
  800566:	eb 38                	jmp    8005a0 <getint+0x5d>
	else if (lflag)
  800568:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80056c:	74 1a                	je     800588 <getint+0x45>
		return va_arg(*ap, long);
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	8d 50 04             	lea    0x4(%eax),%edx
  800576:	8b 45 08             	mov    0x8(%ebp),%eax
  800579:	89 10                	mov    %edx,(%eax)
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	83 e8 04             	sub    $0x4,%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	99                   	cltd   
  800586:	eb 18                	jmp    8005a0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	8b 00                	mov    (%eax),%eax
  80058d:	8d 50 04             	lea    0x4(%eax),%edx
  800590:	8b 45 08             	mov    0x8(%ebp),%eax
  800593:	89 10                	mov    %edx,(%eax)
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	83 e8 04             	sub    $0x4,%eax
  80059d:	8b 00                	mov    (%eax),%eax
  80059f:	99                   	cltd   
}
  8005a0:	5d                   	pop    %ebp
  8005a1:	c3                   	ret    

008005a2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	56                   	push   %esi
  8005a6:	53                   	push   %ebx
  8005a7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005aa:	eb 17                	jmp    8005c3 <vprintfmt+0x21>
			if (ch == '\0')
  8005ac:	85 db                	test   %ebx,%ebx
  8005ae:	0f 84 c1 03 00 00    	je     800975 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ba:	53                   	push   %ebx
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	ff d0                	call   *%eax
  8005c0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c6:	8d 50 01             	lea    0x1(%eax),%edx
  8005c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8005cc:	8a 00                	mov    (%eax),%al
  8005ce:	0f b6 d8             	movzbl %al,%ebx
  8005d1:	83 fb 25             	cmp    $0x25,%ebx
  8005d4:	75 d6                	jne    8005ac <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005d6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005da:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005ef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f9:	8d 50 01             	lea    0x1(%eax),%edx
  8005fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8005ff:	8a 00                	mov    (%eax),%al
  800601:	0f b6 d8             	movzbl %al,%ebx
  800604:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800607:	83 f8 5b             	cmp    $0x5b,%eax
  80060a:	0f 87 3d 03 00 00    	ja     80094d <vprintfmt+0x3ab>
  800610:	8b 04 85 f8 40 80 00 	mov    0x8040f8(,%eax,4),%eax
  800617:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800619:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80061d:	eb d7                	jmp    8005f6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80061f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800623:	eb d1                	jmp    8005f6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800625:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80062c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	c1 e0 02             	shl    $0x2,%eax
  800634:	01 d0                	add    %edx,%eax
  800636:	01 c0                	add    %eax,%eax
  800638:	01 d8                	add    %ebx,%eax
  80063a:	83 e8 30             	sub    $0x30,%eax
  80063d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800640:	8b 45 10             	mov    0x10(%ebp),%eax
  800643:	8a 00                	mov    (%eax),%al
  800645:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800648:	83 fb 2f             	cmp    $0x2f,%ebx
  80064b:	7e 3e                	jle    80068b <vprintfmt+0xe9>
  80064d:	83 fb 39             	cmp    $0x39,%ebx
  800650:	7f 39                	jg     80068b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800652:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800655:	eb d5                	jmp    80062c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	83 c0 04             	add    $0x4,%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	83 e8 04             	sub    $0x4,%eax
  800666:	8b 00                	mov    (%eax),%eax
  800668:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80066b:	eb 1f                	jmp    80068c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80066d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800671:	79 83                	jns    8005f6 <vprintfmt+0x54>
				width = 0;
  800673:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80067a:	e9 77 ff ff ff       	jmp    8005f6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80067f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800686:	e9 6b ff ff ff       	jmp    8005f6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80068b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80068c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800690:	0f 89 60 ff ff ff    	jns    8005f6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800696:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800699:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80069c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006a3:	e9 4e ff ff ff       	jmp    8005f6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006a8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006ab:	e9 46 ff ff ff       	jmp    8005f6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	83 c0 04             	add    $0x4,%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	83 e8 04             	sub    $0x4,%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	ff 75 0c             	pushl  0xc(%ebp)
  8006c7:	50                   	push   %eax
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	ff d0                	call   *%eax
  8006cd:	83 c4 10             	add    $0x10,%esp
			break;
  8006d0:	e9 9b 02 00 00       	jmp    800970 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	83 c0 04             	add    $0x4,%eax
  8006db:	89 45 14             	mov    %eax,0x14(%ebp)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	83 e8 04             	sub    $0x4,%eax
  8006e4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006e6:	85 db                	test   %ebx,%ebx
  8006e8:	79 02                	jns    8006ec <vprintfmt+0x14a>
				err = -err;
  8006ea:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006ec:	83 fb 64             	cmp    $0x64,%ebx
  8006ef:	7f 0b                	jg     8006fc <vprintfmt+0x15a>
  8006f1:	8b 34 9d 40 3f 80 00 	mov    0x803f40(,%ebx,4),%esi
  8006f8:	85 f6                	test   %esi,%esi
  8006fa:	75 19                	jne    800715 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006fc:	53                   	push   %ebx
  8006fd:	68 e5 40 80 00       	push   $0x8040e5
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	e8 70 02 00 00       	call   80097d <printfmt>
  80070d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800710:	e9 5b 02 00 00       	jmp    800970 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800715:	56                   	push   %esi
  800716:	68 ee 40 80 00       	push   $0x8040ee
  80071b:	ff 75 0c             	pushl  0xc(%ebp)
  80071e:	ff 75 08             	pushl  0x8(%ebp)
  800721:	e8 57 02 00 00       	call   80097d <printfmt>
  800726:	83 c4 10             	add    $0x10,%esp
			break;
  800729:	e9 42 02 00 00       	jmp    800970 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	83 c0 04             	add    $0x4,%eax
  800734:	89 45 14             	mov    %eax,0x14(%ebp)
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 30                	mov    (%eax),%esi
  80073f:	85 f6                	test   %esi,%esi
  800741:	75 05                	jne    800748 <vprintfmt+0x1a6>
				p = "(null)";
  800743:	be f1 40 80 00       	mov    $0x8040f1,%esi
			if (width > 0 && padc != '-')
  800748:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074c:	7e 6d                	jle    8007bb <vprintfmt+0x219>
  80074e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800752:	74 67                	je     8007bb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800754:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	50                   	push   %eax
  80075b:	56                   	push   %esi
  80075c:	e8 26 05 00 00       	call   800c87 <strnlen>
  800761:	83 c4 10             	add    $0x10,%esp
  800764:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800767:	eb 16                	jmp    80077f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800769:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	50                   	push   %eax
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	ff d0                	call   *%eax
  800779:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80077c:	ff 4d e4             	decl   -0x1c(%ebp)
  80077f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800783:	7f e4                	jg     800769 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800785:	eb 34                	jmp    8007bb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800787:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80078b:	74 1c                	je     8007a9 <vprintfmt+0x207>
  80078d:	83 fb 1f             	cmp    $0x1f,%ebx
  800790:	7e 05                	jle    800797 <vprintfmt+0x1f5>
  800792:	83 fb 7e             	cmp    $0x7e,%ebx
  800795:	7e 12                	jle    8007a9 <vprintfmt+0x207>
					putch('?', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	ff 75 0c             	pushl  0xc(%ebp)
  80079d:	6a 3f                	push   $0x3f
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	ff d0                	call   *%eax
  8007a4:	83 c4 10             	add    $0x10,%esp
  8007a7:	eb 0f                	jmp    8007b8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	53                   	push   %ebx
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	ff d0                	call   *%eax
  8007b5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007b8:	ff 4d e4             	decl   -0x1c(%ebp)
  8007bb:	89 f0                	mov    %esi,%eax
  8007bd:	8d 70 01             	lea    0x1(%eax),%esi
  8007c0:	8a 00                	mov    (%eax),%al
  8007c2:	0f be d8             	movsbl %al,%ebx
  8007c5:	85 db                	test   %ebx,%ebx
  8007c7:	74 24                	je     8007ed <vprintfmt+0x24b>
  8007c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007cd:	78 b8                	js     800787 <vprintfmt+0x1e5>
  8007cf:	ff 4d e0             	decl   -0x20(%ebp)
  8007d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007d6:	79 af                	jns    800787 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d8:	eb 13                	jmp    8007ed <vprintfmt+0x24b>
				putch(' ', putdat);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	6a 20                	push   $0x20
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	ff d0                	call   *%eax
  8007e7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f1:	7f e7                	jg     8007da <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007f3:	e9 78 01 00 00       	jmp    800970 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8007fe:	8d 45 14             	lea    0x14(%ebp),%eax
  800801:	50                   	push   %eax
  800802:	e8 3c fd ff ff       	call   800543 <getint>
  800807:	83 c4 10             	add    $0x10,%esp
  80080a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800813:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800816:	85 d2                	test   %edx,%edx
  800818:	79 23                	jns    80083d <vprintfmt+0x29b>
				putch('-', putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	ff 75 0c             	pushl  0xc(%ebp)
  800820:	6a 2d                	push   $0x2d
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	ff d0                	call   *%eax
  800827:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80082a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800830:	f7 d8                	neg    %eax
  800832:	83 d2 00             	adc    $0x0,%edx
  800835:	f7 da                	neg    %edx
  800837:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80083a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80083d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800844:	e9 bc 00 00 00       	jmp    800905 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800849:	83 ec 08             	sub    $0x8,%esp
  80084c:	ff 75 e8             	pushl  -0x18(%ebp)
  80084f:	8d 45 14             	lea    0x14(%ebp),%eax
  800852:	50                   	push   %eax
  800853:	e8 84 fc ff ff       	call   8004dc <getuint>
  800858:	83 c4 10             	add    $0x10,%esp
  80085b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80085e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800861:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800868:	e9 98 00 00 00       	jmp    800905 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	6a 58                	push   $0x58
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	6a 58                	push   $0x58
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	ff 75 0c             	pushl  0xc(%ebp)
  800893:	6a 58                	push   $0x58
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	ff d0                	call   *%eax
  80089a:	83 c4 10             	add    $0x10,%esp
			break;
  80089d:	e9 ce 00 00 00       	jmp    800970 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008a2:	83 ec 08             	sub    $0x8,%esp
  8008a5:	ff 75 0c             	pushl  0xc(%ebp)
  8008a8:	6a 30                	push   $0x30
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	ff d0                	call   *%eax
  8008af:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008b2:	83 ec 08             	sub    $0x8,%esp
  8008b5:	ff 75 0c             	pushl  0xc(%ebp)
  8008b8:	6a 78                	push   $0x78
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	ff d0                	call   *%eax
  8008bf:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 c0 04             	add    $0x4,%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008e4:	eb 1f                	jmp    800905 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008e6:	83 ec 08             	sub    $0x8,%esp
  8008e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ef:	50                   	push   %eax
  8008f0:	e8 e7 fb ff ff       	call   8004dc <getuint>
  8008f5:	83 c4 10             	add    $0x10,%esp
  8008f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800905:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800909:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80090c:	83 ec 04             	sub    $0x4,%esp
  80090f:	52                   	push   %edx
  800910:	ff 75 e4             	pushl  -0x1c(%ebp)
  800913:	50                   	push   %eax
  800914:	ff 75 f4             	pushl  -0xc(%ebp)
  800917:	ff 75 f0             	pushl  -0x10(%ebp)
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	ff 75 08             	pushl  0x8(%ebp)
  800920:	e8 00 fb ff ff       	call   800425 <printnum>
  800925:	83 c4 20             	add    $0x20,%esp
			break;
  800928:	eb 46                	jmp    800970 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	53                   	push   %ebx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
			break;
  800939:	eb 35                	jmp    800970 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80093b:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  800942:	eb 2c                	jmp    800970 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800944:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  80094b:	eb 23                	jmp    800970 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80094d:	83 ec 08             	sub    $0x8,%esp
  800950:	ff 75 0c             	pushl  0xc(%ebp)
  800953:	6a 25                	push   $0x25
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	ff d0                	call   *%eax
  80095a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80095d:	ff 4d 10             	decl   0x10(%ebp)
  800960:	eb 03                	jmp    800965 <vprintfmt+0x3c3>
  800962:	ff 4d 10             	decl   0x10(%ebp)
  800965:	8b 45 10             	mov    0x10(%ebp),%eax
  800968:	48                   	dec    %eax
  800969:	8a 00                	mov    (%eax),%al
  80096b:	3c 25                	cmp    $0x25,%al
  80096d:	75 f3                	jne    800962 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80096f:	90                   	nop
		}
	}
  800970:	e9 35 fc ff ff       	jmp    8005aa <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800975:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800976:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800979:	5b                   	pop    %ebx
  80097a:	5e                   	pop    %esi
  80097b:	5d                   	pop    %ebp
  80097c:	c3                   	ret    

0080097d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800983:	8d 45 10             	lea    0x10(%ebp),%eax
  800986:	83 c0 04             	add    $0x4,%eax
  800989:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80098c:	8b 45 10             	mov    0x10(%ebp),%eax
  80098f:	ff 75 f4             	pushl  -0xc(%ebp)
  800992:	50                   	push   %eax
  800993:	ff 75 0c             	pushl  0xc(%ebp)
  800996:	ff 75 08             	pushl  0x8(%ebp)
  800999:	e8 04 fc ff ff       	call   8005a2 <vprintfmt>
  80099e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009a1:	90                   	nop
  8009a2:	c9                   	leave  
  8009a3:	c3                   	ret    

008009a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009aa:	8b 40 08             	mov    0x8(%eax),%eax
  8009ad:	8d 50 01             	lea    0x1(%eax),%edx
  8009b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	8b 10                	mov    (%eax),%edx
  8009bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009be:	8b 40 04             	mov    0x4(%eax),%eax
  8009c1:	39 c2                	cmp    %eax,%edx
  8009c3:	73 12                	jae    8009d7 <sprintputch+0x33>
		*b->buf++ = ch;
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	8b 00                	mov    (%eax),%eax
  8009ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8009cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d0:	89 0a                	mov    %ecx,(%edx)
  8009d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009d5:	88 10                	mov    %dl,(%eax)
}
  8009d7:	90                   	nop
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	01 d0                	add    %edx,%eax
  8009f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009ff:	74 06                	je     800a07 <vsnprintf+0x2d>
  800a01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a05:	7f 07                	jg     800a0e <vsnprintf+0x34>
		return -E_INVAL;
  800a07:	b8 03 00 00 00       	mov    $0x3,%eax
  800a0c:	eb 20                	jmp    800a2e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a0e:	ff 75 14             	pushl  0x14(%ebp)
  800a11:	ff 75 10             	pushl  0x10(%ebp)
  800a14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a17:	50                   	push   %eax
  800a18:	68 a4 09 80 00       	push   $0x8009a4
  800a1d:	e8 80 fb ff ff       	call   8005a2 <vprintfmt>
  800a22:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a2e:	c9                   	leave  
  800a2f:	c3                   	ret    

00800a30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a36:	8d 45 10             	lea    0x10(%ebp),%eax
  800a39:	83 c0 04             	add    $0x4,%eax
  800a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800a42:	ff 75 f4             	pushl  -0xc(%ebp)
  800a45:	50                   	push   %eax
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 89 ff ff ff       	call   8009da <vsnprintf>
  800a51:	83 c4 10             	add    $0x10,%esp
  800a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5a:	c9                   	leave  
  800a5b:	c3                   	ret    

00800a5c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a66:	74 13                	je     800a7b <readline+0x1f>
		cprintf("%s", prompt);
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 08             	pushl  0x8(%ebp)
  800a6e:	68 68 42 80 00       	push   $0x804268
  800a73:	e8 50 f9 ff ff       	call   8003c8 <cprintf>
  800a78:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a82:	83 ec 0c             	sub    $0xc,%esp
  800a85:	6a 00                	push   $0x0
  800a87:	e8 aa 2e 00 00       	call   803936 <iscons>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a92:	e8 8c 2e 00 00       	call   803923 <getchar>
  800a97:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a9e:	79 22                	jns    800ac2 <readline+0x66>
			if (c != -E_EOF)
  800aa0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800aa4:	0f 84 ad 00 00 00    	je     800b57 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800aaa:	83 ec 08             	sub    $0x8,%esp
  800aad:	ff 75 ec             	pushl  -0x14(%ebp)
  800ab0:	68 6b 42 80 00       	push   $0x80426b
  800ab5:	e8 0e f9 ff ff       	call   8003c8 <cprintf>
  800aba:	83 c4 10             	add    $0x10,%esp
			break;
  800abd:	e9 95 00 00 00       	jmp    800b57 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ac2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ac6:	7e 34                	jle    800afc <readline+0xa0>
  800ac8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800acf:	7f 2b                	jg     800afc <readline+0xa0>
			if (echoing)
  800ad1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ad5:	74 0e                	je     800ae5 <readline+0x89>
				cputchar(c);
  800ad7:	83 ec 0c             	sub    $0xc,%esp
  800ada:	ff 75 ec             	pushl  -0x14(%ebp)
  800add:	e8 22 2e 00 00       	call   803904 <cputchar>
  800ae2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae8:	8d 50 01             	lea    0x1(%eax),%edx
  800aeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	01 d0                	add    %edx,%eax
  800af5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800af8:	88 10                	mov    %dl,(%eax)
  800afa:	eb 56                	jmp    800b52 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800afc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b00:	75 1f                	jne    800b21 <readline+0xc5>
  800b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b06:	7e 19                	jle    800b21 <readline+0xc5>
			if (echoing)
  800b08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b0c:	74 0e                	je     800b1c <readline+0xc0>
				cputchar(c);
  800b0e:	83 ec 0c             	sub    $0xc,%esp
  800b11:	ff 75 ec             	pushl  -0x14(%ebp)
  800b14:	e8 eb 2d 00 00       	call   803904 <cputchar>
  800b19:	83 c4 10             	add    $0x10,%esp

			i--;
  800b1c:	ff 4d f4             	decl   -0xc(%ebp)
  800b1f:	eb 31                	jmp    800b52 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b21:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b25:	74 0a                	je     800b31 <readline+0xd5>
  800b27:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b2b:	0f 85 61 ff ff ff    	jne    800a92 <readline+0x36>
			if (echoing)
  800b31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b35:	74 0e                	je     800b45 <readline+0xe9>
				cputchar(c);
  800b37:	83 ec 0c             	sub    $0xc,%esp
  800b3a:	ff 75 ec             	pushl  -0x14(%ebp)
  800b3d:	e8 c2 2d 00 00       	call   803904 <cputchar>
  800b42:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b50:	eb 06                	jmp    800b58 <readline+0xfc>
		}
	}
  800b52:	e9 3b ff ff ff       	jmp    800a92 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b57:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b58:	90                   	nop
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b61:	e8 49 0d 00 00       	call   8018af <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6a:	74 13                	je     800b7f <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	68 68 42 80 00       	push   $0x804268
  800b77:	e8 4c f8 ff ff       	call   8003c8 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	6a 00                	push   $0x0
  800b8b:	e8 a6 2d 00 00       	call   803936 <iscons>
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b96:	e8 88 2d 00 00       	call   803923 <getchar>
  800b9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800b9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ba2:	79 22                	jns    800bc6 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800ba4:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ba8:	0f 84 ad 00 00 00    	je     800c5b <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 ec             	pushl  -0x14(%ebp)
  800bb4:	68 6b 42 80 00       	push   $0x80426b
  800bb9:	e8 0a f8 ff ff       	call   8003c8 <cprintf>
  800bbe:	83 c4 10             	add    $0x10,%esp
				break;
  800bc1:	e9 95 00 00 00       	jmp    800c5b <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bc6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800bca:	7e 34                	jle    800c00 <atomic_readline+0xa5>
  800bcc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800bd3:	7f 2b                	jg     800c00 <atomic_readline+0xa5>
				if (echoing)
  800bd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bd9:	74 0e                	je     800be9 <atomic_readline+0x8e>
					cputchar(c);
  800bdb:	83 ec 0c             	sub    $0xc,%esp
  800bde:	ff 75 ec             	pushl  -0x14(%ebp)
  800be1:	e8 1e 2d 00 00       	call   803904 <cputchar>
  800be6:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bec:	8d 50 01             	lea    0x1(%eax),%edx
  800bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bf2:	89 c2                	mov    %eax,%edx
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	01 d0                	add    %edx,%eax
  800bf9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bfc:	88 10                	mov    %dl,(%eax)
  800bfe:	eb 56                	jmp    800c56 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800c00:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c04:	75 1f                	jne    800c25 <atomic_readline+0xca>
  800c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c0a:	7e 19                	jle    800c25 <atomic_readline+0xca>
				if (echoing)
  800c0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c10:	74 0e                	je     800c20 <atomic_readline+0xc5>
					cputchar(c);
  800c12:	83 ec 0c             	sub    $0xc,%esp
  800c15:	ff 75 ec             	pushl  -0x14(%ebp)
  800c18:	e8 e7 2c 00 00       	call   803904 <cputchar>
  800c1d:	83 c4 10             	add    $0x10,%esp
				i--;
  800c20:	ff 4d f4             	decl   -0xc(%ebp)
  800c23:	eb 31                	jmp    800c56 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c25:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c29:	74 0a                	je     800c35 <atomic_readline+0xda>
  800c2b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c2f:	0f 85 61 ff ff ff    	jne    800b96 <atomic_readline+0x3b>
				if (echoing)
  800c35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c39:	74 0e                	je     800c49 <atomic_readline+0xee>
					cputchar(c);
  800c3b:	83 ec 0c             	sub    $0xc,%esp
  800c3e:	ff 75 ec             	pushl  -0x14(%ebp)
  800c41:	e8 be 2c 00 00       	call   803904 <cputchar>
  800c46:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4f:	01 d0                	add    %edx,%eax
  800c51:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c54:	eb 06                	jmp    800c5c <atomic_readline+0x101>
			}
		}
  800c56:	e9 3b ff ff ff       	jmp    800b96 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c5b:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c5c:	e8 68 0c 00 00       	call   8018c9 <sys_unlock_cons>
}
  800c61:	90                   	nop
  800c62:	c9                   	leave  
  800c63:	c3                   	ret    

00800c64 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c71:	eb 06                	jmp    800c79 <strlen+0x15>
		n++;
  800c73:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c76:	ff 45 08             	incl   0x8(%ebp)
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	84 c0                	test   %al,%al
  800c80:	75 f1                	jne    800c73 <strlen+0xf>
		n++;
	return n;
  800c82:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c94:	eb 09                	jmp    800c9f <strnlen+0x18>
		n++;
  800c96:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c99:	ff 45 08             	incl   0x8(%ebp)
  800c9c:	ff 4d 0c             	decl   0xc(%ebp)
  800c9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca3:	74 09                	je     800cae <strnlen+0x27>
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	84 c0                	test   %al,%al
  800cac:	75 e8                	jne    800c96 <strnlen+0xf>
		n++;
	return n;
  800cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cbf:	90                   	nop
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	8d 50 01             	lea    0x1(%eax),%edx
  800cc6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd2:	8a 12                	mov    (%edx),%dl
  800cd4:	88 10                	mov    %dl,(%eax)
  800cd6:	8a 00                	mov    (%eax),%al
  800cd8:	84 c0                	test   %al,%al
  800cda:	75 e4                	jne    800cc0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cdf:	c9                   	leave  
  800ce0:	c3                   	ret    

00800ce1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ced:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf4:	eb 1f                	jmp    800d15 <strncpy+0x34>
		*dst++ = *src;
  800cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf9:	8d 50 01             	lea    0x1(%eax),%edx
  800cfc:	89 55 08             	mov    %edx,0x8(%ebp)
  800cff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d02:	8a 12                	mov    (%edx),%dl
  800d04:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	84 c0                	test   %al,%al
  800d0d:	74 03                	je     800d12 <strncpy+0x31>
			src++;
  800d0f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d12:	ff 45 fc             	incl   -0x4(%ebp)
  800d15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d18:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d1b:	72 d9                	jb     800cf6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d32:	74 30                	je     800d64 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d34:	eb 16                	jmp    800d4c <strlcpy+0x2a>
			*dst++ = *src++;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d45:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d48:	8a 12                	mov    (%edx),%dl
  800d4a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d4c:	ff 4d 10             	decl   0x10(%ebp)
  800d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d53:	74 09                	je     800d5e <strlcpy+0x3c>
  800d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	84 c0                	test   %al,%al
  800d5c:	75 d8                	jne    800d36 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d61:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d64:	8b 55 08             	mov    0x8(%ebp),%edx
  800d67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d6a:	29 c2                	sub    %eax,%edx
  800d6c:	89 d0                	mov    %edx,%eax
}
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d73:	eb 06                	jmp    800d7b <strcmp+0xb>
		p++, q++;
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	84 c0                	test   %al,%al
  800d82:	74 0e                	je     800d92 <strcmp+0x22>
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 10                	mov    (%eax),%dl
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	38 c2                	cmp    %al,%dl
  800d90:	74 e3                	je     800d75 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	0f b6 d0             	movzbl %al,%edx
  800d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	0f b6 c0             	movzbl %al,%eax
  800da2:	29 c2                	sub    %eax,%edx
  800da4:	89 d0                	mov    %edx,%eax
}
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    

00800da8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dab:	eb 09                	jmp    800db6 <strncmp+0xe>
		n--, p++, q++;
  800dad:	ff 4d 10             	decl   0x10(%ebp)
  800db0:	ff 45 08             	incl   0x8(%ebp)
  800db3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800db6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dba:	74 17                	je     800dd3 <strncmp+0x2b>
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	84 c0                	test   %al,%al
  800dc3:	74 0e                	je     800dd3 <strncmp+0x2b>
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 10                	mov    (%eax),%dl
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	38 c2                	cmp    %al,%dl
  800dd1:	74 da                	je     800dad <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd7:	75 07                	jne    800de0 <strncmp+0x38>
		return 0;
  800dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dde:	eb 14                	jmp    800df4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 d0             	movzbl %al,%edx
  800de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	0f b6 c0             	movzbl %al,%eax
  800df0:	29 c2                	sub    %eax,%edx
  800df2:	89 d0                	mov    %edx,%eax
}
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    

00800df6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	83 ec 04             	sub    $0x4,%esp
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e02:	eb 12                	jmp    800e16 <strchr+0x20>
		if (*s == c)
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e0c:	75 05                	jne    800e13 <strchr+0x1d>
			return (char *) s;
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	eb 11                	jmp    800e24 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e13:	ff 45 08             	incl   0x8(%ebp)
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8a 00                	mov    (%eax),%al
  800e1b:	84 c0                	test   %al,%al
  800e1d:	75 e5                	jne    800e04 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	83 ec 04             	sub    $0x4,%esp
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e32:	eb 0d                	jmp    800e41 <strfind+0x1b>
		if (*s == c)
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e3c:	74 0e                	je     800e4c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e3e:	ff 45 08             	incl   0x8(%ebp)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	75 ea                	jne    800e34 <strfind+0xe>
  800e4a:	eb 01                	jmp    800e4d <strfind+0x27>
		if (*s == c)
			break;
  800e4c:	90                   	nop
	return (char *) s;
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e50:	c9                   	leave  
  800e51:	c3                   	ret    

00800e52 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e52:	55                   	push   %ebp
  800e53:	89 e5                	mov    %esp,%ebp
  800e55:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e64:	eb 0e                	jmp    800e74 <memset+0x22>
		*p++ = c;
  800e66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e72:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e74:	ff 4d f8             	decl   -0x8(%ebp)
  800e77:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e7b:	79 e9                	jns    800e66 <memset+0x14>
		*p++ = c;

	return v;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e80:	c9                   	leave  
  800e81:	c3                   	ret    

00800e82 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e94:	eb 16                	jmp    800eac <memcpy+0x2a>
		*d++ = *s++;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8d 50 01             	lea    0x1(%eax),%edx
  800e9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eac:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	75 dd                	jne    800e96 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ed6:	73 50                	jae    800f28 <memmove+0x6a>
  800ed8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800edb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ede:	01 d0                	add    %edx,%eax
  800ee0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee3:	76 43                	jbe    800f28 <memmove+0x6a>
		s += n;
  800ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef1:	eb 10                	jmp    800f03 <memmove+0x45>
			*--d = *--s;
  800ef3:	ff 4d f8             	decl   -0x8(%ebp)
  800ef6:	ff 4d fc             	decl   -0x4(%ebp)
  800ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efc:	8a 10                	mov    (%eax),%dl
  800efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f01:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f03:	8b 45 10             	mov    0x10(%ebp),%eax
  800f06:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f09:	89 55 10             	mov    %edx,0x10(%ebp)
  800f0c:	85 c0                	test   %eax,%eax
  800f0e:	75 e3                	jne    800ef3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f10:	eb 23                	jmp    800f35 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f15:	8d 50 01             	lea    0x1(%eax),%edx
  800f18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f21:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f24:	8a 12                	mov    (%edx),%dl
  800f26:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f28:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f31:	85 c0                	test   %eax,%eax
  800f33:	75 dd                	jne    800f12 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f38:	c9                   	leave  
  800f39:	c3                   	ret    

00800f3a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f4c:	eb 2a                	jmp    800f78 <memcmp+0x3e>
		if (*s1 != *s2)
  800f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f51:	8a 10                	mov    (%eax),%dl
  800f53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	38 c2                	cmp    %al,%dl
  800f5a:	74 16                	je     800f72 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 d0             	movzbl %al,%edx
  800f64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	0f b6 c0             	movzbl %al,%eax
  800f6c:	29 c2                	sub    %eax,%edx
  800f6e:	89 d0                	mov    %edx,%eax
  800f70:	eb 18                	jmp    800f8a <memcmp+0x50>
		s1++, s2++;
  800f72:	ff 45 fc             	incl   -0x4(%ebp)
  800f75:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 c9                	jne    800f4e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f92:	8b 55 08             	mov    0x8(%ebp),%edx
  800f95:	8b 45 10             	mov    0x10(%ebp),%eax
  800f98:	01 d0                	add    %edx,%eax
  800f9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f9d:	eb 15                	jmp    800fb4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	0f b6 d0             	movzbl %al,%edx
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	0f b6 c0             	movzbl %al,%eax
  800fad:	39 c2                	cmp    %eax,%edx
  800faf:	74 0d                	je     800fbe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb1:	ff 45 08             	incl   0x8(%ebp)
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fba:	72 e3                	jb     800f9f <memfind+0x13>
  800fbc:	eb 01                	jmp    800fbf <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fbe:	90                   	nop
	return (void *) s;
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc2:	c9                   	leave  
  800fc3:	c3                   	ret    

00800fc4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fd1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd8:	eb 03                	jmp    800fdd <strtol+0x19>
		s++;
  800fda:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	3c 20                	cmp    $0x20,%al
  800fe4:	74 f4                	je     800fda <strtol+0x16>
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	3c 09                	cmp    $0x9,%al
  800fed:	74 eb                	je     800fda <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	3c 2b                	cmp    $0x2b,%al
  800ff6:	75 05                	jne    800ffd <strtol+0x39>
		s++;
  800ff8:	ff 45 08             	incl   0x8(%ebp)
  800ffb:	eb 13                	jmp    801010 <strtol+0x4c>
	else if (*s == '-')
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 2d                	cmp    $0x2d,%al
  801004:	75 0a                	jne    801010 <strtol+0x4c>
		s++, neg = 1;
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801010:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801014:	74 06                	je     80101c <strtol+0x58>
  801016:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80101a:	75 20                	jne    80103c <strtol+0x78>
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	3c 30                	cmp    $0x30,%al
  801023:	75 17                	jne    80103c <strtol+0x78>
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	40                   	inc    %eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 78                	cmp    $0x78,%al
  80102d:	75 0d                	jne    80103c <strtol+0x78>
		s += 2, base = 16;
  80102f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801033:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80103a:	eb 28                	jmp    801064 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80103c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801040:	75 15                	jne    801057 <strtol+0x93>
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	3c 30                	cmp    $0x30,%al
  801049:	75 0c                	jne    801057 <strtol+0x93>
		s++, base = 8;
  80104b:	ff 45 08             	incl   0x8(%ebp)
  80104e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801055:	eb 0d                	jmp    801064 <strtol+0xa0>
	else if (base == 0)
  801057:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105b:	75 07                	jne    801064 <strtol+0xa0>
		base = 10;
  80105d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8a 00                	mov    (%eax),%al
  801069:	3c 2f                	cmp    $0x2f,%al
  80106b:	7e 19                	jle    801086 <strtol+0xc2>
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 39                	cmp    $0x39,%al
  801074:	7f 10                	jg     801086 <strtol+0xc2>
			dig = *s - '0';
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	0f be c0             	movsbl %al,%eax
  80107e:	83 e8 30             	sub    $0x30,%eax
  801081:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801084:	eb 42                	jmp    8010c8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	8a 00                	mov    (%eax),%al
  80108b:	3c 60                	cmp    $0x60,%al
  80108d:	7e 19                	jle    8010a8 <strtol+0xe4>
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 7a                	cmp    $0x7a,%al
  801096:	7f 10                	jg     8010a8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	0f be c0             	movsbl %al,%eax
  8010a0:	83 e8 57             	sub    $0x57,%eax
  8010a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010a6:	eb 20                	jmp    8010c8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	3c 40                	cmp    $0x40,%al
  8010af:	7e 39                	jle    8010ea <strtol+0x126>
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 5a                	cmp    $0x5a,%al
  8010b8:	7f 30                	jg     8010ea <strtol+0x126>
			dig = *s - 'A' + 10;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	0f be c0             	movsbl %al,%eax
  8010c2:	83 e8 37             	sub    $0x37,%eax
  8010c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ce:	7d 19                	jge    8010e9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d0:	ff 45 08             	incl   0x8(%ebp)
  8010d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010da:	89 c2                	mov    %eax,%edx
  8010dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010df:	01 d0                	add    %edx,%eax
  8010e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010e4:	e9 7b ff ff ff       	jmp    801064 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ee:	74 08                	je     8010f8 <strtol+0x134>
		*endptr = (char *) s;
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fc:	74 07                	je     801105 <strtol+0x141>
  8010fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801101:	f7 d8                	neg    %eax
  801103:	eb 03                	jmp    801108 <strtol+0x144>
  801105:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <ltostr>:

void
ltostr(long value, char *str)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801110:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801117:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80111e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801122:	79 13                	jns    801137 <ltostr+0x2d>
	{
		neg = 1;
  801124:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80112b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801131:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801134:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80113f:	99                   	cltd   
  801140:	f7 f9                	idiv   %ecx
  801142:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	8d 50 01             	lea    0x1(%eax),%edx
  80114b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80114e:	89 c2                	mov    %eax,%edx
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	01 d0                	add    %edx,%eax
  801155:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801158:	83 c2 30             	add    $0x30,%edx
  80115b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80115d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801160:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801165:	f7 e9                	imul   %ecx
  801167:	c1 fa 02             	sar    $0x2,%edx
  80116a:	89 c8                	mov    %ecx,%eax
  80116c:	c1 f8 1f             	sar    $0x1f,%eax
  80116f:	29 c2                	sub    %eax,%edx
  801171:	89 d0                	mov    %edx,%eax
  801173:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801176:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80117a:	75 bb                	jne    801137 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80117c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801183:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801186:	48                   	dec    %eax
  801187:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80118a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80118e:	74 3d                	je     8011cd <ltostr+0xc3>
		start = 1 ;
  801190:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801197:	eb 34                	jmp    8011cd <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801199:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	01 d0                	add    %edx,%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	01 c2                	add    %eax,%edx
  8011ae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	01 c8                	add    %ecx,%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c0:	01 c2                	add    %eax,%edx
  8011c2:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011c5:	88 02                	mov    %al,(%edx)
		start++ ;
  8011c7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011ca:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d3:	7c c4                	jl     801199 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	01 d0                	add    %edx,%eax
  8011dd:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e0:	90                   	nop
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011e9:	ff 75 08             	pushl  0x8(%ebp)
  8011ec:	e8 73 fa ff ff       	call   800c64 <strlen>
  8011f1:	83 c4 04             	add    $0x4,%esp
  8011f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	e8 65 fa ff ff       	call   800c64 <strlen>
  8011ff:	83 c4 04             	add    $0x4,%esp
  801202:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801205:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80120c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801213:	eb 17                	jmp    80122c <strcconcat+0x49>
		final[s] = str1[s] ;
  801215:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801218:	8b 45 10             	mov    0x10(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	01 c8                	add    %ecx,%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801229:	ff 45 fc             	incl   -0x4(%ebp)
  80122c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80122f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801232:	7c e1                	jl     801215 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801234:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80123b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801242:	eb 1f                	jmp    801263 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801244:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801247:	8d 50 01             	lea    0x1(%eax),%edx
  80124a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80124d:	89 c2                	mov    %eax,%edx
  80124f:	8b 45 10             	mov    0x10(%ebp),%eax
  801252:	01 c2                	add    %eax,%edx
  801254:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	01 c8                	add    %ecx,%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801260:	ff 45 f8             	incl   -0x8(%ebp)
  801263:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801266:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801269:	7c d9                	jl     801244 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80126b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126e:	8b 45 10             	mov    0x10(%ebp),%eax
  801271:	01 d0                	add    %edx,%eax
  801273:	c6 00 00             	movb   $0x0,(%eax)
}
  801276:	90                   	nop
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80127c:	8b 45 14             	mov    0x14(%ebp),%eax
  80127f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801285:	8b 45 14             	mov    0x14(%ebp),%eax
  801288:	8b 00                	mov    (%eax),%eax
  80128a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801291:	8b 45 10             	mov    0x10(%ebp),%eax
  801294:	01 d0                	add    %edx,%eax
  801296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80129c:	eb 0c                	jmp    8012aa <strsplit+0x31>
			*string++ = 0;
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8d 50 01             	lea    0x1(%eax),%edx
  8012a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	84 c0                	test   %al,%al
  8012b1:	74 18                	je     8012cb <strsplit+0x52>
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	0f be c0             	movsbl %al,%eax
  8012bb:	50                   	push   %eax
  8012bc:	ff 75 0c             	pushl  0xc(%ebp)
  8012bf:	e8 32 fb ff ff       	call   800df6 <strchr>
  8012c4:	83 c4 08             	add    $0x8,%esp
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	75 d3                	jne    80129e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	84 c0                	test   %al,%al
  8012d2:	74 5a                	je     80132e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d7:	8b 00                	mov    (%eax),%eax
  8012d9:	83 f8 0f             	cmp    $0xf,%eax
  8012dc:	75 07                	jne    8012e5 <strsplit+0x6c>
		{
			return 0;
  8012de:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e3:	eb 66                	jmp    80134b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e8:	8b 00                	mov    (%eax),%eax
  8012ea:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ed:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f0:	89 0a                	mov    %ecx,(%edx)
  8012f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fc:	01 c2                	add    %eax,%edx
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801303:	eb 03                	jmp    801308 <strsplit+0x8f>
			string++;
  801305:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801308:	8b 45 08             	mov    0x8(%ebp),%eax
  80130b:	8a 00                	mov    (%eax),%al
  80130d:	84 c0                	test   %al,%al
  80130f:	74 8b                	je     80129c <strsplit+0x23>
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	8a 00                	mov    (%eax),%al
  801316:	0f be c0             	movsbl %al,%eax
  801319:	50                   	push   %eax
  80131a:	ff 75 0c             	pushl  0xc(%ebp)
  80131d:	e8 d4 fa ff ff       	call   800df6 <strchr>
  801322:	83 c4 08             	add    $0x8,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	74 dc                	je     801305 <strsplit+0x8c>
			string++;
	}
  801329:	e9 6e ff ff ff       	jmp    80129c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80132e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80132f:	8b 45 14             	mov    0x14(%ebp),%eax
  801332:	8b 00                	mov    (%eax),%eax
  801334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80133b:	8b 45 10             	mov    0x10(%ebp),%eax
  80133e:	01 d0                	add    %edx,%eax
  801340:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801346:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80134b:	c9                   	leave  
  80134c:	c3                   	ret    

0080134d <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801353:	83 ec 04             	sub    $0x4,%esp
  801356:	68 7c 42 80 00       	push   $0x80427c
  80135b:	68 3f 01 00 00       	push   $0x13f
  801360:	68 9e 42 80 00       	push   $0x80429e
  801365:	e8 d6 25 00 00       	call   803940 <_panic>

0080136a <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801370:	83 ec 0c             	sub    $0xc,%esp
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	e8 9d 0a 00 00       	call   801e18 <sys_sbrk>
  80137b:	83 c4 10             	add    $0x10,%esp
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80138a:	75 0a                	jne    801396 <malloc+0x16>
  80138c:	b8 00 00 00 00       	mov    $0x0,%eax
  801391:	e9 07 02 00 00       	jmp    80159d <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801396:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  80139d:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013a3:	01 d0                	add    %edx,%eax
  8013a5:	48                   	dec    %eax
  8013a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8013a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b1:	f7 75 dc             	divl   -0x24(%ebp)
  8013b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013b7:	29 d0                	sub    %edx,%eax
  8013b9:	c1 e8 0c             	shr    $0xc,%eax
  8013bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8013bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8013c4:	8b 40 78             	mov    0x78(%eax),%eax
  8013c7:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8013cc:	29 c2                	sub    %eax,%edx
  8013ce:	89 d0                	mov    %edx,%eax
  8013d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013d3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013db:	c1 e8 0c             	shr    $0xc,%eax
  8013de:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  8013e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  8013e8:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8013ef:	77 42                	ja     801433 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8013f1:	e8 a6 08 00 00       	call   801c9c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	74 16                	je     801410 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 e6 0d 00 00       	call   8021eb <alloc_block_FF>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80140b:	e9 8a 01 00 00       	jmp    80159a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801410:	e8 b8 08 00 00       	call   801ccd <sys_isUHeapPlacementStrategyBESTFIT>
  801415:	85 c0                	test   %eax,%eax
  801417:	0f 84 7d 01 00 00    	je     80159a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80141d:	83 ec 0c             	sub    $0xc,%esp
  801420:	ff 75 08             	pushl  0x8(%ebp)
  801423:	e8 7f 12 00 00       	call   8026a7 <alloc_block_BF>
  801428:	83 c4 10             	add    $0x10,%esp
  80142b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80142e:	e9 67 01 00 00       	jmp    80159a <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801433:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801436:	48                   	dec    %eax
  801437:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80143a:	0f 86 53 01 00 00    	jbe    801593 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801440:	a1 20 50 80 00       	mov    0x805020,%eax
  801445:	8b 40 78             	mov    0x78(%eax),%eax
  801448:	05 00 10 00 00       	add    $0x1000,%eax
  80144d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801450:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  801457:	e9 de 00 00 00       	jmp    80153a <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80145c:	a1 20 50 80 00       	mov    0x805020,%eax
  801461:	8b 40 78             	mov    0x78(%eax),%eax
  801464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801467:	29 c2                	sub    %eax,%edx
  801469:	89 d0                	mov    %edx,%eax
  80146b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801470:	c1 e8 0c             	shr    $0xc,%eax
  801473:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80147a:	85 c0                	test   %eax,%eax
  80147c:	0f 85 ab 00 00 00    	jne    80152d <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  801482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801485:	05 00 10 00 00       	add    $0x1000,%eax
  80148a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80148d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801494:	eb 47                	jmp    8014dd <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801496:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  80149d:	76 0a                	jbe    8014a9 <malloc+0x129>
  80149f:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a4:	e9 f4 00 00 00       	jmp    80159d <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8014a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8014ae:	8b 40 78             	mov    0x78(%eax),%eax
  8014b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014b4:	29 c2                	sub    %eax,%edx
  8014b6:	89 d0                	mov    %edx,%eax
  8014b8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014bd:	c1 e8 0c             	shr    $0xc,%eax
  8014c0:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	74 08                	je     8014d3 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  8014cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  8014d1:	eb 5a                	jmp    80152d <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  8014d3:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  8014da:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8014dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014e0:	48                   	dec    %eax
  8014e1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8014e4:	77 b0                	ja     801496 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  8014e6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  8014ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8014f4:	eb 2f                	jmp    801525 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  8014f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f9:	c1 e0 0c             	shl    $0xc,%eax
  8014fc:	89 c2                	mov    %eax,%edx
  8014fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801501:	01 c2                	add    %eax,%edx
  801503:	a1 20 50 80 00       	mov    0x805020,%eax
  801508:	8b 40 78             	mov    0x78(%eax),%eax
  80150b:	29 c2                	sub    %eax,%edx
  80150d:	89 d0                	mov    %edx,%eax
  80150f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801514:	c1 e8 0c             	shr    $0xc,%eax
  801517:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
  80151e:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801522:	ff 45 e0             	incl   -0x20(%ebp)
  801525:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801528:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80152b:	72 c9                	jb     8014f6 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80152d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801531:	75 16                	jne    801549 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801533:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  80153a:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801541:	0f 86 15 ff ff ff    	jbe    80145c <malloc+0xdc>
  801547:	eb 01                	jmp    80154a <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801549:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  80154a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80154e:	75 07                	jne    801557 <malloc+0x1d7>
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
  801555:	eb 46                	jmp    80159d <malloc+0x21d>
		ptr = (void*)i;
  801557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  80155d:	a1 20 50 80 00       	mov    0x805020,%eax
  801562:	8b 40 78             	mov    0x78(%eax),%eax
  801565:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801568:	29 c2                	sub    %eax,%edx
  80156a:	89 d0                	mov    %edx,%eax
  80156c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801571:	c1 e8 0c             	shr    $0xc,%eax
  801574:	89 c2                	mov    %eax,%edx
  801576:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801579:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	ff 75 08             	pushl  0x8(%ebp)
  801586:	ff 75 f0             	pushl  -0x10(%ebp)
  801589:	e8 c1 08 00 00       	call   801e4f <sys_allocate_user_mem>
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	eb 07                	jmp    80159a <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
  801598:	eb 03                	jmp    80159d <malloc+0x21d>
	}
	return ptr;
  80159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  8015a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8015aa:	8b 40 78             	mov    0x78(%eax),%eax
  8015ad:	05 00 10 00 00       	add    $0x1000,%eax
  8015b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  8015b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  8015bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8015c1:	8b 50 78             	mov    0x78(%eax),%edx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	39 c2                	cmp    %eax,%edx
  8015c9:	76 24                	jbe    8015ef <free+0x50>
		size = get_block_size(va);
  8015cb:	83 ec 0c             	sub    $0xc,%esp
  8015ce:	ff 75 08             	pushl  0x8(%ebp)
  8015d1:	e8 95 08 00 00       	call   801e6b <get_block_size>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	ff 75 08             	pushl  0x8(%ebp)
  8015e2:	e8 c8 1a 00 00       	call   8030af <free_block>
  8015e7:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8015ea:	e9 ac 00 00 00       	jmp    80169b <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015f5:	0f 82 89 00 00 00    	jb     801684 <free+0xe5>
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801603:	77 7f                	ja     801684 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801605:	8b 55 08             	mov    0x8(%ebp),%edx
  801608:	a1 20 50 80 00       	mov    0x805020,%eax
  80160d:	8b 40 78             	mov    0x78(%eax),%eax
  801610:	29 c2                	sub    %eax,%edx
  801612:	89 d0                	mov    %edx,%eax
  801614:	2d 00 10 00 00       	sub    $0x1000,%eax
  801619:	c1 e8 0c             	shr    $0xc,%eax
  80161c:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801623:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801626:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801629:	c1 e0 0c             	shl    $0xc,%eax
  80162c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80162f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801636:	eb 2f                	jmp    801667 <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  801638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163b:	c1 e0 0c             	shl    $0xc,%eax
  80163e:	89 c2                	mov    %eax,%edx
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	01 c2                	add    %eax,%edx
  801645:	a1 20 50 80 00       	mov    0x805020,%eax
  80164a:	8b 40 78             	mov    0x78(%eax),%eax
  80164d:	29 c2                	sub    %eax,%edx
  80164f:	89 d0                	mov    %edx,%eax
  801651:	2d 00 10 00 00       	sub    $0x1000,%eax
  801656:	c1 e8 0c             	shr    $0xc,%eax
  801659:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801660:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801664:	ff 45 f4             	incl   -0xc(%ebp)
  801667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80166d:	72 c9                	jb     801638 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	83 ec 08             	sub    $0x8,%esp
  801675:	ff 75 ec             	pushl  -0x14(%ebp)
  801678:	50                   	push   %eax
  801679:	e8 b5 07 00 00       	call   801e33 <sys_free_user_mem>
  80167e:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801681:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801682:	eb 17                	jmp    80169b <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	68 ac 42 80 00       	push   $0x8042ac
  80168c:	68 84 00 00 00       	push   $0x84
  801691:	68 d6 42 80 00       	push   $0x8042d6
  801696:	e8 a5 22 00 00       	call   803940 <_panic>
	}
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	83 ec 28             	sub    $0x28,%esp
  8016a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a6:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8016a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ad:	75 07                	jne    8016b6 <smalloc+0x19>
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	eb 74                	jmp    80172a <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8016b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016bc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	39 d0                	cmp    %edx,%eax
  8016cb:	73 02                	jae    8016cf <smalloc+0x32>
  8016cd:	89 d0                	mov    %edx,%eax
  8016cf:	83 ec 0c             	sub    $0xc,%esp
  8016d2:	50                   	push   %eax
  8016d3:	e8 a8 fc ff ff       	call   801380 <malloc>
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8016de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e2:	75 07                	jne    8016eb <smalloc+0x4e>
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e9:	eb 3f                	jmp    80172a <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8016eb:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8016f2:	50                   	push   %eax
  8016f3:	ff 75 0c             	pushl  0xc(%ebp)
  8016f6:	ff 75 08             	pushl  0x8(%ebp)
  8016f9:	e8 3c 03 00 00       	call   801a3a <sys_createSharedObject>
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801704:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801708:	74 06                	je     801710 <smalloc+0x73>
  80170a:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80170e:	75 07                	jne    801717 <smalloc+0x7a>
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
  801715:	eb 13                	jmp    80172a <smalloc+0x8d>
	 cprintf("153\n");
  801717:	83 ec 0c             	sub    $0xc,%esp
  80171a:	68 e2 42 80 00       	push   $0x8042e2
  80171f:	e8 a4 ec ff ff       	call   8003c8 <cprintf>
  801724:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  801727:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801732:	83 ec 08             	sub    $0x8,%esp
  801735:	ff 75 0c             	pushl  0xc(%ebp)
  801738:	ff 75 08             	pushl  0x8(%ebp)
  80173b:	e8 24 03 00 00       	call   801a64 <sys_getSizeOfSharedObject>
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801746:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80174a:	75 07                	jne    801753 <sget+0x27>
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
  801751:	eb 5c                	jmp    8017af <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801756:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801759:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801760:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801766:	39 d0                	cmp    %edx,%eax
  801768:	7d 02                	jge    80176c <sget+0x40>
  80176a:	89 d0                	mov    %edx,%eax
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	50                   	push   %eax
  801770:	e8 0b fc ff ff       	call   801380 <malloc>
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80177b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80177f:	75 07                	jne    801788 <sget+0x5c>
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
  801786:	eb 27                	jmp    8017af <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801788:	83 ec 04             	sub    $0x4,%esp
  80178b:	ff 75 e8             	pushl  -0x18(%ebp)
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	e8 e8 02 00 00       	call   801a81 <sys_getSharedObject>
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80179f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8017a3:	75 07                	jne    8017ac <sget+0x80>
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017aa:	eb 03                	jmp    8017af <sget+0x83>
	return ptr;
  8017ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	68 e8 42 80 00       	push   $0x8042e8
  8017bf:	68 c2 00 00 00       	push   $0xc2
  8017c4:	68 d6 42 80 00       	push   $0x8042d6
  8017c9:	e8 72 21 00 00       	call   803940 <_panic>

008017ce <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	68 0c 43 80 00       	push   $0x80430c
  8017dc:	68 d9 00 00 00       	push   $0xd9
  8017e1:	68 d6 42 80 00       	push   $0x8042d6
  8017e6:	e8 55 21 00 00       	call   803940 <_panic>

008017eb <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	68 32 43 80 00       	push   $0x804332
  8017f9:	68 e5 00 00 00       	push   $0xe5
  8017fe:	68 d6 42 80 00       	push   $0x8042d6
  801803:	e8 38 21 00 00       	call   803940 <_panic>

00801808 <shrink>:

}
void shrink(uint32 newSize)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	68 32 43 80 00       	push   $0x804332
  801816:	68 ea 00 00 00       	push   $0xea
  80181b:	68 d6 42 80 00       	push   $0x8042d6
  801820:	e8 1b 21 00 00       	call   803940 <_panic>

00801825 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	68 32 43 80 00       	push   $0x804332
  801833:	68 ef 00 00 00       	push   $0xef
  801838:	68 d6 42 80 00       	push   $0x8042d6
  80183d:	e8 fe 20 00 00       	call   803940 <_panic>

00801842 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	57                   	push   %edi
  801846:	56                   	push   %esi
  801847:	53                   	push   %ebx
  801848:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801851:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801854:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801857:	8b 7d 18             	mov    0x18(%ebp),%edi
  80185a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80185d:	cd 30                	int    $0x30
  80185f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801862:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	5b                   	pop    %ebx
  801869:	5e                   	pop    %esi
  80186a:	5f                   	pop    %edi
  80186b:	5d                   	pop    %ebp
  80186c:	c3                   	ret    

0080186d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	8b 45 10             	mov    0x10(%ebp),%eax
  801876:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801879:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	52                   	push   %edx
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	50                   	push   %eax
  801889:	6a 00                	push   $0x0
  80188b:	e8 b2 ff ff ff       	call   801842 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_cgetc>:

int
sys_cgetc(void)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 02                	push   $0x2
  8018a5:	e8 98 ff ff ff       	call   801842 <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 03                	push   $0x3
  8018be:	e8 7f ff ff ff       	call   801842 <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	90                   	nop
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 04                	push   $0x4
  8018d8:	e8 65 ff ff ff       	call   801842 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	90                   	nop
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	6a 08                	push   $0x8
  8018f6:	e8 47 ff ff ff       	call   801842 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801905:	8b 75 18             	mov    0x18(%ebp),%esi
  801908:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80190b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	56                   	push   %esi
  801915:	53                   	push   %ebx
  801916:	51                   	push   %ecx
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	6a 09                	push   $0x9
  80191b:	e8 22 ff ff ff       	call   801842 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801926:	5b                   	pop    %ebx
  801927:	5e                   	pop    %esi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    

0080192a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80192d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	52                   	push   %edx
  80193a:	50                   	push   %eax
  80193b:	6a 0a                	push   $0xa
  80193d:	e8 00 ff ff ff       	call   801842 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	6a 0b                	push   $0xb
  801958:	e8 e5 fe ff ff       	call   801842 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 0c                	push   $0xc
  801971:	e8 cc fe ff ff       	call   801842 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 0d                	push   $0xd
  80198a:	e8 b3 fe ff ff       	call   801842 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 0e                	push   $0xe
  8019a3:	e8 9a fe ff ff       	call   801842 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 0f                	push   $0xf
  8019bc:	e8 81 fe ff ff       	call   801842 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	ff 75 08             	pushl  0x8(%ebp)
  8019d4:	6a 10                	push   $0x10
  8019d6:	e8 67 fe ff ff       	call   801842 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 11                	push   $0x11
  8019ef:	e8 4e fe ff ff       	call   801842 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_cputc>:

void
sys_cputc(const char c)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a06:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	50                   	push   %eax
  801a13:	6a 01                	push   $0x1
  801a15:	e8 28 fe ff ff       	call   801842 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	90                   	nop
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 14                	push   $0x14
  801a2f:	e8 0e fe ff ff       	call   801842 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	90                   	nop
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	8b 45 10             	mov    0x10(%ebp),%eax
  801a43:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a46:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a49:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	51                   	push   %ecx
  801a53:	52                   	push   %edx
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	50                   	push   %eax
  801a58:	6a 15                	push   $0x15
  801a5a:	e8 e3 fd ff ff       	call   801842 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	52                   	push   %edx
  801a74:	50                   	push   %eax
  801a75:	6a 16                	push   $0x16
  801a77:	e8 c6 fd ff ff       	call   801842 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	51                   	push   %ecx
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	6a 17                	push   $0x17
  801a96:	e8 a7 fd ff ff       	call   801842 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	52                   	push   %edx
  801ab0:	50                   	push   %eax
  801ab1:	6a 18                	push   $0x18
  801ab3:	e8 8a fd ff ff       	call   801842 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	6a 00                	push   $0x0
  801ac5:	ff 75 14             	pushl  0x14(%ebp)
  801ac8:	ff 75 10             	pushl  0x10(%ebp)
  801acb:	ff 75 0c             	pushl  0xc(%ebp)
  801ace:	50                   	push   %eax
  801acf:	6a 19                	push   $0x19
  801ad1:	e8 6c fd ff ff       	call   801842 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_run_env>:

void sys_run_env(int32 envId)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	50                   	push   %eax
  801aea:	6a 1a                	push   $0x1a
  801aec:	e8 51 fd ff ff       	call   801842 <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	90                   	nop
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	50                   	push   %eax
  801b06:	6a 1b                	push   $0x1b
  801b08:	e8 35 fd ff ff       	call   801842 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 05                	push   $0x5
  801b21:	e8 1c fd ff ff       	call   801842 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 06                	push   $0x6
  801b3a:	e8 03 fd ff ff       	call   801842 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 07                	push   $0x7
  801b53:	e8 ea fc ff ff       	call   801842 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_exit_env>:


void sys_exit_env(void)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 1c                	push   $0x1c
  801b6c:	e8 d1 fc ff ff       	call   801842 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	90                   	nop
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b7d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b80:	8d 50 04             	lea    0x4(%eax),%edx
  801b83:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	52                   	push   %edx
  801b8d:	50                   	push   %eax
  801b8e:	6a 1d                	push   $0x1d
  801b90:	e8 ad fc ff ff       	call   801842 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
	return result;
  801b98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba1:	89 01                	mov    %eax,(%ecx)
  801ba3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	c9                   	leave  
  801baa:	c2 04 00             	ret    $0x4

00801bad <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	ff 75 10             	pushl  0x10(%ebp)
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	ff 75 08             	pushl  0x8(%ebp)
  801bbd:	6a 13                	push   $0x13
  801bbf:	e8 7e fc ff ff       	call   801842 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc7:	90                   	nop
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_rcr2>:
uint32 sys_rcr2()
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 1e                	push   $0x1e
  801bd9:	e8 64 fc ff ff       	call   801842 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 04             	sub    $0x4,%esp
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bef:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	50                   	push   %eax
  801bfc:	6a 1f                	push   $0x1f
  801bfe:	e8 3f fc ff ff       	call   801842 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
	return ;
  801c06:	90                   	nop
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <rsttst>:
void rsttst()
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 21                	push   $0x21
  801c18:	e8 25 fc ff ff       	call   801842 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c20:	90                   	nop
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 04             	sub    $0x4,%esp
  801c29:	8b 45 14             	mov    0x14(%ebp),%eax
  801c2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c2f:	8b 55 18             	mov    0x18(%ebp),%edx
  801c32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c36:	52                   	push   %edx
  801c37:	50                   	push   %eax
  801c38:	ff 75 10             	pushl  0x10(%ebp)
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	ff 75 08             	pushl  0x8(%ebp)
  801c41:	6a 20                	push   $0x20
  801c43:	e8 fa fb ff ff       	call   801842 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4b:	90                   	nop
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <chktst>:
void chktst(uint32 n)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	ff 75 08             	pushl  0x8(%ebp)
  801c5c:	6a 22                	push   $0x22
  801c5e:	e8 df fb ff ff       	call   801842 <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
	return ;
  801c66:	90                   	nop
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <inctst>:

void inctst()
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 23                	push   $0x23
  801c78:	e8 c5 fb ff ff       	call   801842 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c80:	90                   	nop
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <gettst>:
uint32 gettst()
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 24                	push   $0x24
  801c92:	e8 ab fb ff ff       	call   801842 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 25                	push   $0x25
  801cae:	e8 8f fb ff ff       	call   801842 <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
  801cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cb9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cbd:	75 07                	jne    801cc6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc4:	eb 05                	jmp    801ccb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 25                	push   $0x25
  801cdf:	e8 5e fb ff ff       	call   801842 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
  801ce7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cea:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cee:	75 07                	jne    801cf7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cf0:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf5:	eb 05                	jmp    801cfc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 25                	push   $0x25
  801d10:	e8 2d fb ff ff       	call   801842 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
  801d18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d1b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d1f:	75 07                	jne    801d28 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d21:	b8 01 00 00 00       	mov    $0x1,%eax
  801d26:	eb 05                	jmp    801d2d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 25                	push   $0x25
  801d41:	e8 fc fa ff ff       	call   801842 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
  801d49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d4c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d50:	75 07                	jne    801d59 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d52:	b8 01 00 00 00       	mov    $0x1,%eax
  801d57:	eb 05                	jmp    801d5e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	ff 75 08             	pushl  0x8(%ebp)
  801d6e:	6a 26                	push   $0x26
  801d70:	e8 cd fa ff ff       	call   801842 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
	return ;
  801d78:	90                   	nop
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d7f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	6a 00                	push   $0x0
  801d8d:	53                   	push   %ebx
  801d8e:	51                   	push   %ecx
  801d8f:	52                   	push   %edx
  801d90:	50                   	push   %eax
  801d91:	6a 27                	push   $0x27
  801d93:	e8 aa fa ff ff       	call   801842 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	52                   	push   %edx
  801db0:	50                   	push   %eax
  801db1:	6a 28                	push   $0x28
  801db3:	e8 8a fa ff ff       	call   801842 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801dc0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	6a 00                	push   $0x0
  801dcb:	51                   	push   %ecx
  801dcc:	ff 75 10             	pushl  0x10(%ebp)
  801dcf:	52                   	push   %edx
  801dd0:	50                   	push   %eax
  801dd1:	6a 29                	push   $0x29
  801dd3:	e8 6a fa ff ff       	call   801842 <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	ff 75 10             	pushl  0x10(%ebp)
  801de7:	ff 75 0c             	pushl  0xc(%ebp)
  801dea:	ff 75 08             	pushl  0x8(%ebp)
  801ded:	6a 12                	push   $0x12
  801def:	e8 4e fa ff ff       	call   801842 <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
	return ;
  801df7:	90                   	nop
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801dfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	52                   	push   %edx
  801e0a:	50                   	push   %eax
  801e0b:	6a 2a                	push   $0x2a
  801e0d:	e8 30 fa ff ff       	call   801842 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
	return;
  801e15:	90                   	nop
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	50                   	push   %eax
  801e27:	6a 2b                	push   $0x2b
  801e29:	e8 14 fa ff ff       	call   801842 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	ff 75 0c             	pushl  0xc(%ebp)
  801e3f:	ff 75 08             	pushl  0x8(%ebp)
  801e42:	6a 2c                	push   $0x2c
  801e44:	e8 f9 f9 ff ff       	call   801842 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
	return;
  801e4c:	90                   	nop
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	ff 75 0c             	pushl  0xc(%ebp)
  801e5b:	ff 75 08             	pushl  0x8(%ebp)
  801e5e:	6a 2d                	push   $0x2d
  801e60:	e8 dd f9 ff ff       	call   801842 <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
	return;
  801e68:	90                   	nop
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	83 e8 04             	sub    $0x4,%eax
  801e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e7d:	8b 00                	mov    (%eax),%eax
  801e7f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	83 e8 04             	sub    $0x4,%eax
  801e90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e96:	8b 00                	mov    (%eax),%eax
  801e98:	83 e0 01             	and    $0x1,%eax
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	0f 94 c0             	sete   %al
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ea8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb2:	83 f8 02             	cmp    $0x2,%eax
  801eb5:	74 2b                	je     801ee2 <alloc_block+0x40>
  801eb7:	83 f8 02             	cmp    $0x2,%eax
  801eba:	7f 07                	jg     801ec3 <alloc_block+0x21>
  801ebc:	83 f8 01             	cmp    $0x1,%eax
  801ebf:	74 0e                	je     801ecf <alloc_block+0x2d>
  801ec1:	eb 58                	jmp    801f1b <alloc_block+0x79>
  801ec3:	83 f8 03             	cmp    $0x3,%eax
  801ec6:	74 2d                	je     801ef5 <alloc_block+0x53>
  801ec8:	83 f8 04             	cmp    $0x4,%eax
  801ecb:	74 3b                	je     801f08 <alloc_block+0x66>
  801ecd:	eb 4c                	jmp    801f1b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801ecf:	83 ec 0c             	sub    $0xc,%esp
  801ed2:	ff 75 08             	pushl  0x8(%ebp)
  801ed5:	e8 11 03 00 00       	call   8021eb <alloc_block_FF>
  801eda:	83 c4 10             	add    $0x10,%esp
  801edd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ee0:	eb 4a                	jmp    801f2c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ee2:	83 ec 0c             	sub    $0xc,%esp
  801ee5:	ff 75 08             	pushl  0x8(%ebp)
  801ee8:	e8 fa 19 00 00       	call   8038e7 <alloc_block_NF>
  801eed:	83 c4 10             	add    $0x10,%esp
  801ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ef3:	eb 37                	jmp    801f2c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	ff 75 08             	pushl  0x8(%ebp)
  801efb:	e8 a7 07 00 00       	call   8026a7 <alloc_block_BF>
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f06:	eb 24                	jmp    801f2c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f08:	83 ec 0c             	sub    $0xc,%esp
  801f0b:	ff 75 08             	pushl  0x8(%ebp)
  801f0e:	e8 b7 19 00 00       	call   8038ca <alloc_block_WF>
  801f13:	83 c4 10             	add    $0x10,%esp
  801f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f19:	eb 11                	jmp    801f2c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	68 44 43 80 00       	push   $0x804344
  801f23:	e8 a0 e4 ff ff       	call   8003c8 <cprintf>
  801f28:	83 c4 10             	add    $0x10,%esp
		break;
  801f2b:	90                   	nop
	}
	return va;
  801f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	53                   	push   %ebx
  801f35:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f38:	83 ec 0c             	sub    $0xc,%esp
  801f3b:	68 64 43 80 00       	push   $0x804364
  801f40:	e8 83 e4 ff ff       	call   8003c8 <cprintf>
  801f45:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f48:	83 ec 0c             	sub    $0xc,%esp
  801f4b:	68 8f 43 80 00       	push   $0x80438f
  801f50:	e8 73 e4 ff ff       	call   8003c8 <cprintf>
  801f55:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f5e:	eb 37                	jmp    801f97 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f60:	83 ec 0c             	sub    $0xc,%esp
  801f63:	ff 75 f4             	pushl  -0xc(%ebp)
  801f66:	e8 19 ff ff ff       	call   801e84 <is_free_block>
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	0f be d8             	movsbl %al,%ebx
  801f71:	83 ec 0c             	sub    $0xc,%esp
  801f74:	ff 75 f4             	pushl  -0xc(%ebp)
  801f77:	e8 ef fe ff ff       	call   801e6b <get_block_size>
  801f7c:	83 c4 10             	add    $0x10,%esp
  801f7f:	83 ec 04             	sub    $0x4,%esp
  801f82:	53                   	push   %ebx
  801f83:	50                   	push   %eax
  801f84:	68 a7 43 80 00       	push   $0x8043a7
  801f89:	e8 3a e4 ff ff       	call   8003c8 <cprintf>
  801f8e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f91:	8b 45 10             	mov    0x10(%ebp),%eax
  801f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9b:	74 07                	je     801fa4 <print_blocks_list+0x73>
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 00                	mov    (%eax),%eax
  801fa2:	eb 05                	jmp    801fa9 <print_blocks_list+0x78>
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa9:	89 45 10             	mov    %eax,0x10(%ebp)
  801fac:	8b 45 10             	mov    0x10(%ebp),%eax
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	75 ad                	jne    801f60 <print_blocks_list+0x2f>
  801fb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb7:	75 a7                	jne    801f60 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	68 64 43 80 00       	push   $0x804364
  801fc1:	e8 02 e4 ff ff       	call   8003c8 <cprintf>
  801fc6:	83 c4 10             	add    $0x10,%esp

}
  801fc9:	90                   	nop
  801fca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd8:	83 e0 01             	and    $0x1,%eax
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	74 03                	je     801fe2 <initialize_dynamic_allocator+0x13>
  801fdf:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fe2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fe6:	0f 84 c7 01 00 00    	je     8021b3 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801fec:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801ff3:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801ff6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffc:	01 d0                	add    %edx,%eax
  801ffe:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802003:	0f 87 ad 01 00 00    	ja     8021b6 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802009:	8b 45 08             	mov    0x8(%ebp),%eax
  80200c:	85 c0                	test   %eax,%eax
  80200e:	0f 89 a5 01 00 00    	jns    8021b9 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802014:	8b 55 08             	mov    0x8(%ebp),%edx
  802017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201a:	01 d0                	add    %edx,%eax
  80201c:	83 e8 04             	sub    $0x4,%eax
  80201f:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802024:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80202b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802030:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802033:	e9 87 00 00 00       	jmp    8020bf <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802038:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203c:	75 14                	jne    802052 <initialize_dynamic_allocator+0x83>
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	68 bf 43 80 00       	push   $0x8043bf
  802046:	6a 79                	push   $0x79
  802048:	68 dd 43 80 00       	push   $0x8043dd
  80204d:	e8 ee 18 00 00       	call   803940 <_panic>
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	8b 00                	mov    (%eax),%eax
  802057:	85 c0                	test   %eax,%eax
  802059:	74 10                	je     80206b <initialize_dynamic_allocator+0x9c>
  80205b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205e:	8b 00                	mov    (%eax),%eax
  802060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802063:	8b 52 04             	mov    0x4(%edx),%edx
  802066:	89 50 04             	mov    %edx,0x4(%eax)
  802069:	eb 0b                	jmp    802076 <initialize_dynamic_allocator+0xa7>
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	8b 40 04             	mov    0x4(%eax),%eax
  802071:	a3 30 50 80 00       	mov    %eax,0x805030
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802079:	8b 40 04             	mov    0x4(%eax),%eax
  80207c:	85 c0                	test   %eax,%eax
  80207e:	74 0f                	je     80208f <initialize_dynamic_allocator+0xc0>
  802080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802083:	8b 40 04             	mov    0x4(%eax),%eax
  802086:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802089:	8b 12                	mov    (%edx),%edx
  80208b:	89 10                	mov    %edx,(%eax)
  80208d:	eb 0a                	jmp    802099 <initialize_dynamic_allocator+0xca>
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	8b 00                	mov    (%eax),%eax
  802094:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8020b1:	48                   	dec    %eax
  8020b2:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8020b7:	a1 34 50 80 00       	mov    0x805034,%eax
  8020bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c3:	74 07                	je     8020cc <initialize_dynamic_allocator+0xfd>
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	8b 00                	mov    (%eax),%eax
  8020ca:	eb 05                	jmp    8020d1 <initialize_dynamic_allocator+0x102>
  8020cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d1:	a3 34 50 80 00       	mov    %eax,0x805034
  8020d6:	a1 34 50 80 00       	mov    0x805034,%eax
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	0f 85 55 ff ff ff    	jne    802038 <initialize_dynamic_allocator+0x69>
  8020e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e7:	0f 85 4b ff ff ff    	jne    802038 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8020fc:	a1 44 50 80 00       	mov    0x805044,%eax
  802101:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802106:	a1 40 50 80 00       	mov    0x805040,%eax
  80210b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	83 c0 08             	add    $0x8,%eax
  802117:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	83 c0 04             	add    $0x4,%eax
  802120:	8b 55 0c             	mov    0xc(%ebp),%edx
  802123:	83 ea 08             	sub    $0x8,%edx
  802126:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802128:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	01 d0                	add    %edx,%eax
  802130:	83 e8 08             	sub    $0x8,%eax
  802133:	8b 55 0c             	mov    0xc(%ebp),%edx
  802136:	83 ea 08             	sub    $0x8,%edx
  802139:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80213b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802144:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802147:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80214e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802152:	75 17                	jne    80216b <initialize_dynamic_allocator+0x19c>
  802154:	83 ec 04             	sub    $0x4,%esp
  802157:	68 f8 43 80 00       	push   $0x8043f8
  80215c:	68 90 00 00 00       	push   $0x90
  802161:	68 dd 43 80 00       	push   $0x8043dd
  802166:	e8 d5 17 00 00       	call   803940 <_panic>
  80216b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802171:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802174:	89 10                	mov    %edx,(%eax)
  802176:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802179:	8b 00                	mov    (%eax),%eax
  80217b:	85 c0                	test   %eax,%eax
  80217d:	74 0d                	je     80218c <initialize_dynamic_allocator+0x1bd>
  80217f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802184:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802187:	89 50 04             	mov    %edx,0x4(%eax)
  80218a:	eb 08                	jmp    802194 <initialize_dynamic_allocator+0x1c5>
  80218c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218f:	a3 30 50 80 00       	mov    %eax,0x805030
  802194:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802197:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80219c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8021ab:	40                   	inc    %eax
  8021ac:	a3 38 50 80 00       	mov    %eax,0x805038
  8021b1:	eb 07                	jmp    8021ba <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8021b3:	90                   	nop
  8021b4:	eb 04                	jmp    8021ba <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8021b6:	90                   	nop
  8021b7:	eb 01                	jmp    8021ba <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8021b9:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c2:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ce:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	83 e8 04             	sub    $0x4,%eax
  8021d6:	8b 00                	mov    (%eax),%eax
  8021d8:	83 e0 fe             	and    $0xfffffffe,%eax
  8021db:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	01 c2                	add    %eax,%edx
  8021e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e6:	89 02                	mov    %eax,(%edx)
}
  8021e8:	90                   	nop
  8021e9:	5d                   	pop    %ebp
  8021ea:	c3                   	ret    

008021eb <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	83 e0 01             	and    $0x1,%eax
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	74 03                	je     8021fe <alloc_block_FF+0x13>
  8021fb:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8021fe:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802202:	77 07                	ja     80220b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802204:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80220b:	a1 24 50 80 00       	mov    0x805024,%eax
  802210:	85 c0                	test   %eax,%eax
  802212:	75 73                	jne    802287 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	83 c0 10             	add    $0x10,%eax
  80221a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80221d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802224:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802227:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222a:	01 d0                	add    %edx,%eax
  80222c:	48                   	dec    %eax
  80222d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802233:	ba 00 00 00 00       	mov    $0x0,%edx
  802238:	f7 75 ec             	divl   -0x14(%ebp)
  80223b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80223e:	29 d0                	sub    %edx,%eax
  802240:	c1 e8 0c             	shr    $0xc,%eax
  802243:	83 ec 0c             	sub    $0xc,%esp
  802246:	50                   	push   %eax
  802247:	e8 1e f1 ff ff       	call   80136a <sbrk>
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802252:	83 ec 0c             	sub    $0xc,%esp
  802255:	6a 00                	push   $0x0
  802257:	e8 0e f1 ff ff       	call   80136a <sbrk>
  80225c:	83 c4 10             	add    $0x10,%esp
  80225f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802262:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802265:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802268:	83 ec 08             	sub    $0x8,%esp
  80226b:	50                   	push   %eax
  80226c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80226f:	e8 5b fd ff ff       	call   801fcf <initialize_dynamic_allocator>
  802274:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802277:	83 ec 0c             	sub    $0xc,%esp
  80227a:	68 1b 44 80 00       	push   $0x80441b
  80227f:	e8 44 e1 ff ff       	call   8003c8 <cprintf>
  802284:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802287:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228b:	75 0a                	jne    802297 <alloc_block_FF+0xac>
	        return NULL;
  80228d:	b8 00 00 00 00       	mov    $0x0,%eax
  802292:	e9 0e 04 00 00       	jmp    8026a5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802297:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80229e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a6:	e9 f3 02 00 00       	jmp    80259e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022b1:	83 ec 0c             	sub    $0xc,%esp
  8022b4:	ff 75 bc             	pushl  -0x44(%ebp)
  8022b7:	e8 af fb ff ff       	call   801e6b <get_block_size>
  8022bc:	83 c4 10             	add    $0x10,%esp
  8022bf:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	83 c0 08             	add    $0x8,%eax
  8022c8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022cb:	0f 87 c5 02 00 00    	ja     802596 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	83 c0 18             	add    $0x18,%eax
  8022d7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022da:	0f 87 19 02 00 00    	ja     8024f9 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022e3:	2b 45 08             	sub    0x8(%ebp),%eax
  8022e6:	83 e8 08             	sub    $0x8,%eax
  8022e9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	8d 50 08             	lea    0x8(%eax),%edx
  8022f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022f5:	01 d0                	add    %edx,%eax
  8022f7:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	83 c0 08             	add    $0x8,%eax
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	6a 01                	push   $0x1
  802305:	50                   	push   %eax
  802306:	ff 75 bc             	pushl  -0x44(%ebp)
  802309:	e8 ae fe ff ff       	call   8021bc <set_block_data>
  80230e:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	8b 40 04             	mov    0x4(%eax),%eax
  802317:	85 c0                	test   %eax,%eax
  802319:	75 68                	jne    802383 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80231b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80231f:	75 17                	jne    802338 <alloc_block_FF+0x14d>
  802321:	83 ec 04             	sub    $0x4,%esp
  802324:	68 f8 43 80 00       	push   $0x8043f8
  802329:	68 d7 00 00 00       	push   $0xd7
  80232e:	68 dd 43 80 00       	push   $0x8043dd
  802333:	e8 08 16 00 00       	call   803940 <_panic>
  802338:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80233e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802341:	89 10                	mov    %edx,(%eax)
  802343:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802346:	8b 00                	mov    (%eax),%eax
  802348:	85 c0                	test   %eax,%eax
  80234a:	74 0d                	je     802359 <alloc_block_FF+0x16e>
  80234c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802351:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802354:	89 50 04             	mov    %edx,0x4(%eax)
  802357:	eb 08                	jmp    802361 <alloc_block_FF+0x176>
  802359:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80235c:	a3 30 50 80 00       	mov    %eax,0x805030
  802361:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802364:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802369:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80236c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802373:	a1 38 50 80 00       	mov    0x805038,%eax
  802378:	40                   	inc    %eax
  802379:	a3 38 50 80 00       	mov    %eax,0x805038
  80237e:	e9 dc 00 00 00       	jmp    80245f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 00                	mov    (%eax),%eax
  802388:	85 c0                	test   %eax,%eax
  80238a:	75 65                	jne    8023f1 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80238c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802390:	75 17                	jne    8023a9 <alloc_block_FF+0x1be>
  802392:	83 ec 04             	sub    $0x4,%esp
  802395:	68 2c 44 80 00       	push   $0x80442c
  80239a:	68 db 00 00 00       	push   $0xdb
  80239f:	68 dd 43 80 00       	push   $0x8043dd
  8023a4:	e8 97 15 00 00       	call   803940 <_panic>
  8023a9:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b2:	89 50 04             	mov    %edx,0x4(%eax)
  8023b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b8:	8b 40 04             	mov    0x4(%eax),%eax
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	74 0c                	je     8023cb <alloc_block_FF+0x1e0>
  8023bf:	a1 30 50 80 00       	mov    0x805030,%eax
  8023c4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023c7:	89 10                	mov    %edx,(%eax)
  8023c9:	eb 08                	jmp    8023d3 <alloc_block_FF+0x1e8>
  8023cb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ce:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8023db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8023e9:	40                   	inc    %eax
  8023ea:	a3 38 50 80 00       	mov    %eax,0x805038
  8023ef:	eb 6e                	jmp    80245f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f5:	74 06                	je     8023fd <alloc_block_FF+0x212>
  8023f7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023fb:	75 17                	jne    802414 <alloc_block_FF+0x229>
  8023fd:	83 ec 04             	sub    $0x4,%esp
  802400:	68 50 44 80 00       	push   $0x804450
  802405:	68 df 00 00 00       	push   $0xdf
  80240a:	68 dd 43 80 00       	push   $0x8043dd
  80240f:	e8 2c 15 00 00       	call   803940 <_panic>
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 10                	mov    (%eax),%edx
  802419:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241c:	89 10                	mov    %edx,(%eax)
  80241e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802421:	8b 00                	mov    (%eax),%eax
  802423:	85 c0                	test   %eax,%eax
  802425:	74 0b                	je     802432 <alloc_block_FF+0x247>
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 00                	mov    (%eax),%eax
  80242c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80242f:	89 50 04             	mov    %edx,0x4(%eax)
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802438:	89 10                	mov    %edx,(%eax)
  80243a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802440:	89 50 04             	mov    %edx,0x4(%eax)
  802443:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	85 c0                	test   %eax,%eax
  80244a:	75 08                	jne    802454 <alloc_block_FF+0x269>
  80244c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244f:	a3 30 50 80 00       	mov    %eax,0x805030
  802454:	a1 38 50 80 00       	mov    0x805038,%eax
  802459:	40                   	inc    %eax
  80245a:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80245f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802463:	75 17                	jne    80247c <alloc_block_FF+0x291>
  802465:	83 ec 04             	sub    $0x4,%esp
  802468:	68 bf 43 80 00       	push   $0x8043bf
  80246d:	68 e1 00 00 00       	push   $0xe1
  802472:	68 dd 43 80 00       	push   $0x8043dd
  802477:	e8 c4 14 00 00       	call   803940 <_panic>
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 00                	mov    (%eax),%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	74 10                	je     802495 <alloc_block_FF+0x2aa>
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 00                	mov    (%eax),%eax
  80248a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248d:	8b 52 04             	mov    0x4(%edx),%edx
  802490:	89 50 04             	mov    %edx,0x4(%eax)
  802493:	eb 0b                	jmp    8024a0 <alloc_block_FF+0x2b5>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 40 04             	mov    0x4(%eax),%eax
  80249b:	a3 30 50 80 00       	mov    %eax,0x805030
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 04             	mov    0x4(%eax),%eax
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	74 0f                	je     8024b9 <alloc_block_FF+0x2ce>
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 40 04             	mov    0x4(%eax),%eax
  8024b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b3:	8b 12                	mov    (%edx),%edx
  8024b5:	89 10                	mov    %edx,(%eax)
  8024b7:	eb 0a                	jmp    8024c3 <alloc_block_FF+0x2d8>
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d6:	a1 38 50 80 00       	mov    0x805038,%eax
  8024db:	48                   	dec    %eax
  8024dc:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024e1:	83 ec 04             	sub    $0x4,%esp
  8024e4:	6a 00                	push   $0x0
  8024e6:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024e9:	ff 75 b0             	pushl  -0x50(%ebp)
  8024ec:	e8 cb fc ff ff       	call   8021bc <set_block_data>
  8024f1:	83 c4 10             	add    $0x10,%esp
  8024f4:	e9 95 00 00 00       	jmp    80258e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	6a 01                	push   $0x1
  8024fe:	ff 75 b8             	pushl  -0x48(%ebp)
  802501:	ff 75 bc             	pushl  -0x44(%ebp)
  802504:	e8 b3 fc ff ff       	call   8021bc <set_block_data>
  802509:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80250c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802510:	75 17                	jne    802529 <alloc_block_FF+0x33e>
  802512:	83 ec 04             	sub    $0x4,%esp
  802515:	68 bf 43 80 00       	push   $0x8043bf
  80251a:	68 e8 00 00 00       	push   $0xe8
  80251f:	68 dd 43 80 00       	push   $0x8043dd
  802524:	e8 17 14 00 00       	call   803940 <_panic>
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	85 c0                	test   %eax,%eax
  802530:	74 10                	je     802542 <alloc_block_FF+0x357>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253a:	8b 52 04             	mov    0x4(%edx),%edx
  80253d:	89 50 04             	mov    %edx,0x4(%eax)
  802540:	eb 0b                	jmp    80254d <alloc_block_FF+0x362>
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 40 04             	mov    0x4(%eax),%eax
  802548:	a3 30 50 80 00       	mov    %eax,0x805030
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 40 04             	mov    0x4(%eax),%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	74 0f                	je     802566 <alloc_block_FF+0x37b>
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 40 04             	mov    0x4(%eax),%eax
  80255d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802560:	8b 12                	mov    (%edx),%edx
  802562:	89 10                	mov    %edx,(%eax)
  802564:	eb 0a                	jmp    802570 <alloc_block_FF+0x385>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802583:	a1 38 50 80 00       	mov    0x805038,%eax
  802588:	48                   	dec    %eax
  802589:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80258e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802591:	e9 0f 01 00 00       	jmp    8026a5 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802596:	a1 34 50 80 00       	mov    0x805034,%eax
  80259b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a2:	74 07                	je     8025ab <alloc_block_FF+0x3c0>
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	eb 05                	jmp    8025b0 <alloc_block_FF+0x3c5>
  8025ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b0:	a3 34 50 80 00       	mov    %eax,0x805034
  8025b5:	a1 34 50 80 00       	mov    0x805034,%eax
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	0f 85 e9 fc ff ff    	jne    8022ab <alloc_block_FF+0xc0>
  8025c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c6:	0f 85 df fc ff ff    	jne    8022ab <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8025cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cf:	83 c0 08             	add    $0x8,%eax
  8025d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8025d5:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025e2:	01 d0                	add    %edx,%eax
  8025e4:	48                   	dec    %eax
  8025e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f0:	f7 75 d8             	divl   -0x28(%ebp)
  8025f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025f6:	29 d0                	sub    %edx,%eax
  8025f8:	c1 e8 0c             	shr    $0xc,%eax
  8025fb:	83 ec 0c             	sub    $0xc,%esp
  8025fe:	50                   	push   %eax
  8025ff:	e8 66 ed ff ff       	call   80136a <sbrk>
  802604:	83 c4 10             	add    $0x10,%esp
  802607:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80260a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80260e:	75 0a                	jne    80261a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802610:	b8 00 00 00 00       	mov    $0x0,%eax
  802615:	e9 8b 00 00 00       	jmp    8026a5 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80261a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802621:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802624:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802627:	01 d0                	add    %edx,%eax
  802629:	48                   	dec    %eax
  80262a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80262d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802630:	ba 00 00 00 00       	mov    $0x0,%edx
  802635:	f7 75 cc             	divl   -0x34(%ebp)
  802638:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80263b:	29 d0                	sub    %edx,%eax
  80263d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802640:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802643:	01 d0                	add    %edx,%eax
  802645:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80264a:	a1 40 50 80 00       	mov    0x805040,%eax
  80264f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802655:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80265c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80265f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802662:	01 d0                	add    %edx,%eax
  802664:	48                   	dec    %eax
  802665:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802668:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80266b:	ba 00 00 00 00       	mov    $0x0,%edx
  802670:	f7 75 c4             	divl   -0x3c(%ebp)
  802673:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802676:	29 d0                	sub    %edx,%eax
  802678:	83 ec 04             	sub    $0x4,%esp
  80267b:	6a 01                	push   $0x1
  80267d:	50                   	push   %eax
  80267e:	ff 75 d0             	pushl  -0x30(%ebp)
  802681:	e8 36 fb ff ff       	call   8021bc <set_block_data>
  802686:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802689:	83 ec 0c             	sub    $0xc,%esp
  80268c:	ff 75 d0             	pushl  -0x30(%ebp)
  80268f:	e8 1b 0a 00 00       	call   8030af <free_block>
  802694:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802697:	83 ec 0c             	sub    $0xc,%esp
  80269a:	ff 75 08             	pushl  0x8(%ebp)
  80269d:	e8 49 fb ff ff       	call   8021eb <alloc_block_FF>
  8026a2:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8026a5:	c9                   	leave  
  8026a6:	c3                   	ret    

008026a7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
  8026aa:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	83 e0 01             	and    $0x1,%eax
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	74 03                	je     8026ba <alloc_block_BF+0x13>
  8026b7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026ba:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026be:	77 07                	ja     8026c7 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026c0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026c7:	a1 24 50 80 00       	mov    0x805024,%eax
  8026cc:	85 c0                	test   %eax,%eax
  8026ce:	75 73                	jne    802743 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	83 c0 10             	add    $0x10,%eax
  8026d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026d9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e6:	01 d0                	add    %edx,%eax
  8026e8:	48                   	dec    %eax
  8026e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f4:	f7 75 e0             	divl   -0x20(%ebp)
  8026f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026fa:	29 d0                	sub    %edx,%eax
  8026fc:	c1 e8 0c             	shr    $0xc,%eax
  8026ff:	83 ec 0c             	sub    $0xc,%esp
  802702:	50                   	push   %eax
  802703:	e8 62 ec ff ff       	call   80136a <sbrk>
  802708:	83 c4 10             	add    $0x10,%esp
  80270b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80270e:	83 ec 0c             	sub    $0xc,%esp
  802711:	6a 00                	push   $0x0
  802713:	e8 52 ec ff ff       	call   80136a <sbrk>
  802718:	83 c4 10             	add    $0x10,%esp
  80271b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80271e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802721:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802724:	83 ec 08             	sub    $0x8,%esp
  802727:	50                   	push   %eax
  802728:	ff 75 d8             	pushl  -0x28(%ebp)
  80272b:	e8 9f f8 ff ff       	call   801fcf <initialize_dynamic_allocator>
  802730:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802733:	83 ec 0c             	sub    $0xc,%esp
  802736:	68 1b 44 80 00       	push   $0x80441b
  80273b:	e8 88 dc ff ff       	call   8003c8 <cprintf>
  802740:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802743:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80274a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802751:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802758:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80275f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802764:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802767:	e9 1d 01 00 00       	jmp    802889 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802772:	83 ec 0c             	sub    $0xc,%esp
  802775:	ff 75 a8             	pushl  -0x58(%ebp)
  802778:	e8 ee f6 ff ff       	call   801e6b <get_block_size>
  80277d:	83 c4 10             	add    $0x10,%esp
  802780:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	83 c0 08             	add    $0x8,%eax
  802789:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80278c:	0f 87 ef 00 00 00    	ja     802881 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802792:	8b 45 08             	mov    0x8(%ebp),%eax
  802795:	83 c0 18             	add    $0x18,%eax
  802798:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80279b:	77 1d                	ja     8027ba <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80279d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027a3:	0f 86 d8 00 00 00    	jbe    802881 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8027a9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8027af:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027b5:	e9 c7 00 00 00       	jmp    802881 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8027ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bd:	83 c0 08             	add    $0x8,%eax
  8027c0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027c3:	0f 85 9d 00 00 00    	jne    802866 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027c9:	83 ec 04             	sub    $0x4,%esp
  8027cc:	6a 01                	push   $0x1
  8027ce:	ff 75 a4             	pushl  -0x5c(%ebp)
  8027d1:	ff 75 a8             	pushl  -0x58(%ebp)
  8027d4:	e8 e3 f9 ff ff       	call   8021bc <set_block_data>
  8027d9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8027dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e0:	75 17                	jne    8027f9 <alloc_block_BF+0x152>
  8027e2:	83 ec 04             	sub    $0x4,%esp
  8027e5:	68 bf 43 80 00       	push   $0x8043bf
  8027ea:	68 2c 01 00 00       	push   $0x12c
  8027ef:	68 dd 43 80 00       	push   $0x8043dd
  8027f4:	e8 47 11 00 00       	call   803940 <_panic>
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 00                	mov    (%eax),%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	74 10                	je     802812 <alloc_block_BF+0x16b>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 00                	mov    (%eax),%eax
  802807:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280a:	8b 52 04             	mov    0x4(%edx),%edx
  80280d:	89 50 04             	mov    %edx,0x4(%eax)
  802810:	eb 0b                	jmp    80281d <alloc_block_BF+0x176>
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 40 04             	mov    0x4(%eax),%eax
  802818:	a3 30 50 80 00       	mov    %eax,0x805030
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 40 04             	mov    0x4(%eax),%eax
  802823:	85 c0                	test   %eax,%eax
  802825:	74 0f                	je     802836 <alloc_block_BF+0x18f>
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 04             	mov    0x4(%eax),%eax
  80282d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802830:	8b 12                	mov    (%edx),%edx
  802832:	89 10                	mov    %edx,(%eax)
  802834:	eb 0a                	jmp    802840 <alloc_block_BF+0x199>
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802853:	a1 38 50 80 00       	mov    0x805038,%eax
  802858:	48                   	dec    %eax
  802859:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80285e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802861:	e9 24 04 00 00       	jmp    802c8a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802866:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802869:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80286c:	76 13                	jbe    802881 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80286e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802875:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802878:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80287b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80287e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802881:	a1 34 50 80 00       	mov    0x805034,%eax
  802886:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802889:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288d:	74 07                	je     802896 <alloc_block_BF+0x1ef>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	eb 05                	jmp    80289b <alloc_block_BF+0x1f4>
  802896:	b8 00 00 00 00       	mov    $0x0,%eax
  80289b:	a3 34 50 80 00       	mov    %eax,0x805034
  8028a0:	a1 34 50 80 00       	mov    0x805034,%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	0f 85 bf fe ff ff    	jne    80276c <alloc_block_BF+0xc5>
  8028ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b1:	0f 85 b5 fe ff ff    	jne    80276c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8028b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028bb:	0f 84 26 02 00 00    	je     802ae7 <alloc_block_BF+0x440>
  8028c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028c5:	0f 85 1c 02 00 00    	jne    802ae7 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8028d1:	83 e8 08             	sub    $0x8,%eax
  8028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8028d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028da:	8d 50 08             	lea    0x8(%eax),%edx
  8028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e0:	01 d0                	add    %edx,%eax
  8028e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	83 c0 08             	add    $0x8,%eax
  8028eb:	83 ec 04             	sub    $0x4,%esp
  8028ee:	6a 01                	push   $0x1
  8028f0:	50                   	push   %eax
  8028f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8028f4:	e8 c3 f8 ff ff       	call   8021bc <set_block_data>
  8028f9:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8028fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ff:	8b 40 04             	mov    0x4(%eax),%eax
  802902:	85 c0                	test   %eax,%eax
  802904:	75 68                	jne    80296e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802906:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80290a:	75 17                	jne    802923 <alloc_block_BF+0x27c>
  80290c:	83 ec 04             	sub    $0x4,%esp
  80290f:	68 f8 43 80 00       	push   $0x8043f8
  802914:	68 45 01 00 00       	push   $0x145
  802919:	68 dd 43 80 00       	push   $0x8043dd
  80291e:	e8 1d 10 00 00       	call   803940 <_panic>
  802923:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802929:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80292c:	89 10                	mov    %edx,(%eax)
  80292e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 0d                	je     802944 <alloc_block_BF+0x29d>
  802937:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80293c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80293f:	89 50 04             	mov    %edx,0x4(%eax)
  802942:	eb 08                	jmp    80294c <alloc_block_BF+0x2a5>
  802944:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802947:	a3 30 50 80 00       	mov    %eax,0x805030
  80294c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80294f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802954:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802957:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295e:	a1 38 50 80 00       	mov    0x805038,%eax
  802963:	40                   	inc    %eax
  802964:	a3 38 50 80 00       	mov    %eax,0x805038
  802969:	e9 dc 00 00 00       	jmp    802a4a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	8b 00                	mov    (%eax),%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	75 65                	jne    8029dc <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802977:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80297b:	75 17                	jne    802994 <alloc_block_BF+0x2ed>
  80297d:	83 ec 04             	sub    $0x4,%esp
  802980:	68 2c 44 80 00       	push   $0x80442c
  802985:	68 4a 01 00 00       	push   $0x14a
  80298a:	68 dd 43 80 00       	push   $0x8043dd
  80298f:	e8 ac 0f 00 00       	call   803940 <_panic>
  802994:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80299a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80299d:	89 50 04             	mov    %edx,0x4(%eax)
  8029a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a3:	8b 40 04             	mov    0x4(%eax),%eax
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	74 0c                	je     8029b6 <alloc_block_BF+0x30f>
  8029aa:	a1 30 50 80 00       	mov    0x805030,%eax
  8029af:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029b2:	89 10                	mov    %edx,(%eax)
  8029b4:	eb 08                	jmp    8029be <alloc_block_BF+0x317>
  8029b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c1:	a3 30 50 80 00       	mov    %eax,0x805030
  8029c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8029d4:	40                   	inc    %eax
  8029d5:	a3 38 50 80 00       	mov    %eax,0x805038
  8029da:	eb 6e                	jmp    802a4a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8029dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e0:	74 06                	je     8029e8 <alloc_block_BF+0x341>
  8029e2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029e6:	75 17                	jne    8029ff <alloc_block_BF+0x358>
  8029e8:	83 ec 04             	sub    $0x4,%esp
  8029eb:	68 50 44 80 00       	push   $0x804450
  8029f0:	68 4f 01 00 00       	push   $0x14f
  8029f5:	68 dd 43 80 00       	push   $0x8043dd
  8029fa:	e8 41 0f 00 00       	call   803940 <_panic>
  8029ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a02:	8b 10                	mov    (%eax),%edx
  802a04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a07:	89 10                	mov    %edx,(%eax)
  802a09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 0b                	je     802a1d <alloc_block_BF+0x376>
  802a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a1a:	89 50 04             	mov    %edx,0x4(%eax)
  802a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a20:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a23:	89 10                	mov    %edx,(%eax)
  802a25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a2b:	89 50 04             	mov    %edx,0x4(%eax)
  802a2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a31:	8b 00                	mov    (%eax),%eax
  802a33:	85 c0                	test   %eax,%eax
  802a35:	75 08                	jne    802a3f <alloc_block_BF+0x398>
  802a37:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a3f:	a1 38 50 80 00       	mov    0x805038,%eax
  802a44:	40                   	inc    %eax
  802a45:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a4e:	75 17                	jne    802a67 <alloc_block_BF+0x3c0>
  802a50:	83 ec 04             	sub    $0x4,%esp
  802a53:	68 bf 43 80 00       	push   $0x8043bf
  802a58:	68 51 01 00 00       	push   $0x151
  802a5d:	68 dd 43 80 00       	push   $0x8043dd
  802a62:	e8 d9 0e 00 00       	call   803940 <_panic>
  802a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 10                	je     802a80 <alloc_block_BF+0x3d9>
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	8b 00                	mov    (%eax),%eax
  802a75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a78:	8b 52 04             	mov    0x4(%edx),%edx
  802a7b:	89 50 04             	mov    %edx,0x4(%eax)
  802a7e:	eb 0b                	jmp    802a8b <alloc_block_BF+0x3e4>
  802a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a83:	8b 40 04             	mov    0x4(%eax),%eax
  802a86:	a3 30 50 80 00       	mov    %eax,0x805030
  802a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8e:	8b 40 04             	mov    0x4(%eax),%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	74 0f                	je     802aa4 <alloc_block_BF+0x3fd>
  802a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a98:	8b 40 04             	mov    0x4(%eax),%eax
  802a9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a9e:	8b 12                	mov    (%edx),%edx
  802aa0:	89 10                	mov    %edx,(%eax)
  802aa2:	eb 0a                	jmp    802aae <alloc_block_BF+0x407>
  802aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ac6:	48                   	dec    %eax
  802ac7:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802acc:	83 ec 04             	sub    $0x4,%esp
  802acf:	6a 00                	push   $0x0
  802ad1:	ff 75 d0             	pushl  -0x30(%ebp)
  802ad4:	ff 75 cc             	pushl  -0x34(%ebp)
  802ad7:	e8 e0 f6 ff ff       	call   8021bc <set_block_data>
  802adc:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae2:	e9 a3 01 00 00       	jmp    802c8a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802ae7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802aeb:	0f 85 9d 00 00 00    	jne    802b8e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802af1:	83 ec 04             	sub    $0x4,%esp
  802af4:	6a 01                	push   $0x1
  802af6:	ff 75 ec             	pushl  -0x14(%ebp)
  802af9:	ff 75 f0             	pushl  -0x10(%ebp)
  802afc:	e8 bb f6 ff ff       	call   8021bc <set_block_data>
  802b01:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b08:	75 17                	jne    802b21 <alloc_block_BF+0x47a>
  802b0a:	83 ec 04             	sub    $0x4,%esp
  802b0d:	68 bf 43 80 00       	push   $0x8043bf
  802b12:	68 58 01 00 00       	push   $0x158
  802b17:	68 dd 43 80 00       	push   $0x8043dd
  802b1c:	e8 1f 0e 00 00       	call   803940 <_panic>
  802b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	74 10                	je     802b3a <alloc_block_BF+0x493>
  802b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2d:	8b 00                	mov    (%eax),%eax
  802b2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b32:	8b 52 04             	mov    0x4(%edx),%edx
  802b35:	89 50 04             	mov    %edx,0x4(%eax)
  802b38:	eb 0b                	jmp    802b45 <alloc_block_BF+0x49e>
  802b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	a3 30 50 80 00       	mov    %eax,0x805030
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	74 0f                	je     802b5e <alloc_block_BF+0x4b7>
  802b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b52:	8b 40 04             	mov    0x4(%eax),%eax
  802b55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b58:	8b 12                	mov    (%edx),%edx
  802b5a:	89 10                	mov    %edx,(%eax)
  802b5c:	eb 0a                	jmp    802b68 <alloc_block_BF+0x4c1>
  802b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7b:	a1 38 50 80 00       	mov    0x805038,%eax
  802b80:	48                   	dec    %eax
  802b81:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	e9 fc 00 00 00       	jmp    802c8a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	83 c0 08             	add    $0x8,%eax
  802b94:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b97:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b9e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ba1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ba4:	01 d0                	add    %edx,%eax
  802ba6:	48                   	dec    %eax
  802ba7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802baa:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bad:	ba 00 00 00 00       	mov    $0x0,%edx
  802bb2:	f7 75 c4             	divl   -0x3c(%ebp)
  802bb5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bb8:	29 d0                	sub    %edx,%eax
  802bba:	c1 e8 0c             	shr    $0xc,%eax
  802bbd:	83 ec 0c             	sub    $0xc,%esp
  802bc0:	50                   	push   %eax
  802bc1:	e8 a4 e7 ff ff       	call   80136a <sbrk>
  802bc6:	83 c4 10             	add    $0x10,%esp
  802bc9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802bcc:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802bd0:	75 0a                	jne    802bdc <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802bd2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd7:	e9 ae 00 00 00       	jmp    802c8a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802bdc:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802be3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802be6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802be9:	01 d0                	add    %edx,%eax
  802beb:	48                   	dec    %eax
  802bec:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802bef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  802bf7:	f7 75 b8             	divl   -0x48(%ebp)
  802bfa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bfd:	29 d0                	sub    %edx,%eax
  802bff:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c02:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c05:	01 d0                	add    %edx,%eax
  802c07:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c0c:	a1 40 50 80 00       	mov    0x805040,%eax
  802c11:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c17:	83 ec 0c             	sub    $0xc,%esp
  802c1a:	68 84 44 80 00       	push   $0x804484
  802c1f:	e8 a4 d7 ff ff       	call   8003c8 <cprintf>
  802c24:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c27:	83 ec 08             	sub    $0x8,%esp
  802c2a:	ff 75 bc             	pushl  -0x44(%ebp)
  802c2d:	68 89 44 80 00       	push   $0x804489
  802c32:	e8 91 d7 ff ff       	call   8003c8 <cprintf>
  802c37:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c3a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c41:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c44:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c47:	01 d0                	add    %edx,%eax
  802c49:	48                   	dec    %eax
  802c4a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c4d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c50:	ba 00 00 00 00       	mov    $0x0,%edx
  802c55:	f7 75 b0             	divl   -0x50(%ebp)
  802c58:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c5b:	29 d0                	sub    %edx,%eax
  802c5d:	83 ec 04             	sub    $0x4,%esp
  802c60:	6a 01                	push   $0x1
  802c62:	50                   	push   %eax
  802c63:	ff 75 bc             	pushl  -0x44(%ebp)
  802c66:	e8 51 f5 ff ff       	call   8021bc <set_block_data>
  802c6b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c6e:	83 ec 0c             	sub    $0xc,%esp
  802c71:	ff 75 bc             	pushl  -0x44(%ebp)
  802c74:	e8 36 04 00 00       	call   8030af <free_block>
  802c79:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c7c:	83 ec 0c             	sub    $0xc,%esp
  802c7f:	ff 75 08             	pushl  0x8(%ebp)
  802c82:	e8 20 fa ff ff       	call   8026a7 <alloc_block_BF>
  802c87:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c8a:	c9                   	leave  
  802c8b:	c3                   	ret    

00802c8c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c8c:	55                   	push   %ebp
  802c8d:	89 e5                	mov    %esp,%ebp
  802c8f:	53                   	push   %ebx
  802c90:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ca1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca5:	74 1e                	je     802cc5 <merging+0x39>
  802ca7:	ff 75 08             	pushl  0x8(%ebp)
  802caa:	e8 bc f1 ff ff       	call   801e6b <get_block_size>
  802caf:	83 c4 04             	add    $0x4,%esp
  802cb2:	89 c2                	mov    %eax,%edx
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	01 d0                	add    %edx,%eax
  802cb9:	3b 45 10             	cmp    0x10(%ebp),%eax
  802cbc:	75 07                	jne    802cc5 <merging+0x39>
		prev_is_free = 1;
  802cbe:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802cc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cc9:	74 1e                	je     802ce9 <merging+0x5d>
  802ccb:	ff 75 10             	pushl  0x10(%ebp)
  802cce:	e8 98 f1 ff ff       	call   801e6b <get_block_size>
  802cd3:	83 c4 04             	add    $0x4,%esp
  802cd6:	89 c2                	mov    %eax,%edx
  802cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  802cdb:	01 d0                	add    %edx,%eax
  802cdd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ce0:	75 07                	jne    802ce9 <merging+0x5d>
		next_is_free = 1;
  802ce2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ce9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ced:	0f 84 cc 00 00 00    	je     802dbf <merging+0x133>
  802cf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf7:	0f 84 c2 00 00 00    	je     802dbf <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802cfd:	ff 75 08             	pushl  0x8(%ebp)
  802d00:	e8 66 f1 ff ff       	call   801e6b <get_block_size>
  802d05:	83 c4 04             	add    $0x4,%esp
  802d08:	89 c3                	mov    %eax,%ebx
  802d0a:	ff 75 10             	pushl  0x10(%ebp)
  802d0d:	e8 59 f1 ff ff       	call   801e6b <get_block_size>
  802d12:	83 c4 04             	add    $0x4,%esp
  802d15:	01 c3                	add    %eax,%ebx
  802d17:	ff 75 0c             	pushl  0xc(%ebp)
  802d1a:	e8 4c f1 ff ff       	call   801e6b <get_block_size>
  802d1f:	83 c4 04             	add    $0x4,%esp
  802d22:	01 d8                	add    %ebx,%eax
  802d24:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d27:	6a 00                	push   $0x0
  802d29:	ff 75 ec             	pushl  -0x14(%ebp)
  802d2c:	ff 75 08             	pushl  0x8(%ebp)
  802d2f:	e8 88 f4 ff ff       	call   8021bc <set_block_data>
  802d34:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d37:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d3b:	75 17                	jne    802d54 <merging+0xc8>
  802d3d:	83 ec 04             	sub    $0x4,%esp
  802d40:	68 bf 43 80 00       	push   $0x8043bf
  802d45:	68 7d 01 00 00       	push   $0x17d
  802d4a:	68 dd 43 80 00       	push   $0x8043dd
  802d4f:	e8 ec 0b 00 00       	call   803940 <_panic>
  802d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d57:	8b 00                	mov    (%eax),%eax
  802d59:	85 c0                	test   %eax,%eax
  802d5b:	74 10                	je     802d6d <merging+0xe1>
  802d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d65:	8b 52 04             	mov    0x4(%edx),%edx
  802d68:	89 50 04             	mov    %edx,0x4(%eax)
  802d6b:	eb 0b                	jmp    802d78 <merging+0xec>
  802d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d70:	8b 40 04             	mov    0x4(%eax),%eax
  802d73:	a3 30 50 80 00       	mov    %eax,0x805030
  802d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7b:	8b 40 04             	mov    0x4(%eax),%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	74 0f                	je     802d91 <merging+0x105>
  802d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d85:	8b 40 04             	mov    0x4(%eax),%eax
  802d88:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d8b:	8b 12                	mov    (%edx),%edx
  802d8d:	89 10                	mov    %edx,(%eax)
  802d8f:	eb 0a                	jmp    802d9b <merging+0x10f>
  802d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dae:	a1 38 50 80 00       	mov    0x805038,%eax
  802db3:	48                   	dec    %eax
  802db4:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802db9:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dba:	e9 ea 02 00 00       	jmp    8030a9 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802dbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc3:	74 3b                	je     802e00 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802dc5:	83 ec 0c             	sub    $0xc,%esp
  802dc8:	ff 75 08             	pushl  0x8(%ebp)
  802dcb:	e8 9b f0 ff ff       	call   801e6b <get_block_size>
  802dd0:	83 c4 10             	add    $0x10,%esp
  802dd3:	89 c3                	mov    %eax,%ebx
  802dd5:	83 ec 0c             	sub    $0xc,%esp
  802dd8:	ff 75 10             	pushl  0x10(%ebp)
  802ddb:	e8 8b f0 ff ff       	call   801e6b <get_block_size>
  802de0:	83 c4 10             	add    $0x10,%esp
  802de3:	01 d8                	add    %ebx,%eax
  802de5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802de8:	83 ec 04             	sub    $0x4,%esp
  802deb:	6a 00                	push   $0x0
  802ded:	ff 75 e8             	pushl  -0x18(%ebp)
  802df0:	ff 75 08             	pushl  0x8(%ebp)
  802df3:	e8 c4 f3 ff ff       	call   8021bc <set_block_data>
  802df8:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dfb:	e9 a9 02 00 00       	jmp    8030a9 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e04:	0f 84 2d 01 00 00    	je     802f37 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e0a:	83 ec 0c             	sub    $0xc,%esp
  802e0d:	ff 75 10             	pushl  0x10(%ebp)
  802e10:	e8 56 f0 ff ff       	call   801e6b <get_block_size>
  802e15:	83 c4 10             	add    $0x10,%esp
  802e18:	89 c3                	mov    %eax,%ebx
  802e1a:	83 ec 0c             	sub    $0xc,%esp
  802e1d:	ff 75 0c             	pushl  0xc(%ebp)
  802e20:	e8 46 f0 ff ff       	call   801e6b <get_block_size>
  802e25:	83 c4 10             	add    $0x10,%esp
  802e28:	01 d8                	add    %ebx,%eax
  802e2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e2d:	83 ec 04             	sub    $0x4,%esp
  802e30:	6a 00                	push   $0x0
  802e32:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e35:	ff 75 10             	pushl  0x10(%ebp)
  802e38:	e8 7f f3 ff ff       	call   8021bc <set_block_data>
  802e3d:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e40:	8b 45 10             	mov    0x10(%ebp),%eax
  802e43:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e4a:	74 06                	je     802e52 <merging+0x1c6>
  802e4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e50:	75 17                	jne    802e69 <merging+0x1dd>
  802e52:	83 ec 04             	sub    $0x4,%esp
  802e55:	68 98 44 80 00       	push   $0x804498
  802e5a:	68 8d 01 00 00       	push   $0x18d
  802e5f:	68 dd 43 80 00       	push   $0x8043dd
  802e64:	e8 d7 0a 00 00       	call   803940 <_panic>
  802e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6c:	8b 50 04             	mov    0x4(%eax),%edx
  802e6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e72:	89 50 04             	mov    %edx,0x4(%eax)
  802e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e7b:	89 10                	mov    %edx,(%eax)
  802e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e80:	8b 40 04             	mov    0x4(%eax),%eax
  802e83:	85 c0                	test   %eax,%eax
  802e85:	74 0d                	je     802e94 <merging+0x208>
  802e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8a:	8b 40 04             	mov    0x4(%eax),%eax
  802e8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e90:	89 10                	mov    %edx,(%eax)
  802e92:	eb 08                	jmp    802e9c <merging+0x210>
  802e94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e97:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ea2:	89 50 04             	mov    %edx,0x4(%eax)
  802ea5:	a1 38 50 80 00       	mov    0x805038,%eax
  802eaa:	40                   	inc    %eax
  802eab:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802eb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eb4:	75 17                	jne    802ecd <merging+0x241>
  802eb6:	83 ec 04             	sub    $0x4,%esp
  802eb9:	68 bf 43 80 00       	push   $0x8043bf
  802ebe:	68 8e 01 00 00       	push   $0x18e
  802ec3:	68 dd 43 80 00       	push   $0x8043dd
  802ec8:	e8 73 0a 00 00       	call   803940 <_panic>
  802ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed0:	8b 00                	mov    (%eax),%eax
  802ed2:	85 c0                	test   %eax,%eax
  802ed4:	74 10                	je     802ee6 <merging+0x25a>
  802ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed9:	8b 00                	mov    (%eax),%eax
  802edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ede:	8b 52 04             	mov    0x4(%edx),%edx
  802ee1:	89 50 04             	mov    %edx,0x4(%eax)
  802ee4:	eb 0b                	jmp    802ef1 <merging+0x265>
  802ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee9:	8b 40 04             	mov    0x4(%eax),%eax
  802eec:	a3 30 50 80 00       	mov    %eax,0x805030
  802ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef4:	8b 40 04             	mov    0x4(%eax),%eax
  802ef7:	85 c0                	test   %eax,%eax
  802ef9:	74 0f                	je     802f0a <merging+0x27e>
  802efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802efe:	8b 40 04             	mov    0x4(%eax),%eax
  802f01:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f04:	8b 12                	mov    (%edx),%edx
  802f06:	89 10                	mov    %edx,(%eax)
  802f08:	eb 0a                	jmp    802f14 <merging+0x288>
  802f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f27:	a1 38 50 80 00       	mov    0x805038,%eax
  802f2c:	48                   	dec    %eax
  802f2d:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f32:	e9 72 01 00 00       	jmp    8030a9 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f37:	8b 45 10             	mov    0x10(%ebp),%eax
  802f3a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f41:	74 79                	je     802fbc <merging+0x330>
  802f43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f47:	74 73                	je     802fbc <merging+0x330>
  802f49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4d:	74 06                	je     802f55 <merging+0x2c9>
  802f4f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f53:	75 17                	jne    802f6c <merging+0x2e0>
  802f55:	83 ec 04             	sub    $0x4,%esp
  802f58:	68 50 44 80 00       	push   $0x804450
  802f5d:	68 94 01 00 00       	push   $0x194
  802f62:	68 dd 43 80 00       	push   $0x8043dd
  802f67:	e8 d4 09 00 00       	call   803940 <_panic>
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	8b 10                	mov    (%eax),%edx
  802f71:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f74:	89 10                	mov    %edx,(%eax)
  802f76:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f79:	8b 00                	mov    (%eax),%eax
  802f7b:	85 c0                	test   %eax,%eax
  802f7d:	74 0b                	je     802f8a <merging+0x2fe>
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	8b 00                	mov    (%eax),%eax
  802f84:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f87:	89 50 04             	mov    %edx,0x4(%eax)
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f90:	89 10                	mov    %edx,(%eax)
  802f92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f95:	8b 55 08             	mov    0x8(%ebp),%edx
  802f98:	89 50 04             	mov    %edx,0x4(%eax)
  802f9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9e:	8b 00                	mov    (%eax),%eax
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	75 08                	jne    802fac <merging+0x320>
  802fa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa7:	a3 30 50 80 00       	mov    %eax,0x805030
  802fac:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb1:	40                   	inc    %eax
  802fb2:	a3 38 50 80 00       	mov    %eax,0x805038
  802fb7:	e9 ce 00 00 00       	jmp    80308a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802fbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc0:	74 65                	je     803027 <merging+0x39b>
  802fc2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fc6:	75 17                	jne    802fdf <merging+0x353>
  802fc8:	83 ec 04             	sub    $0x4,%esp
  802fcb:	68 2c 44 80 00       	push   $0x80442c
  802fd0:	68 95 01 00 00       	push   $0x195
  802fd5:	68 dd 43 80 00       	push   $0x8043dd
  802fda:	e8 61 09 00 00       	call   803940 <_panic>
  802fdf:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fe5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe8:	89 50 04             	mov    %edx,0x4(%eax)
  802feb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fee:	8b 40 04             	mov    0x4(%eax),%eax
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	74 0c                	je     803001 <merging+0x375>
  802ff5:	a1 30 50 80 00       	mov    0x805030,%eax
  802ffa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ffd:	89 10                	mov    %edx,(%eax)
  802fff:	eb 08                	jmp    803009 <merging+0x37d>
  803001:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803004:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803009:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300c:	a3 30 50 80 00       	mov    %eax,0x805030
  803011:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803014:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301a:	a1 38 50 80 00       	mov    0x805038,%eax
  80301f:	40                   	inc    %eax
  803020:	a3 38 50 80 00       	mov    %eax,0x805038
  803025:	eb 63                	jmp    80308a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803027:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80302b:	75 17                	jne    803044 <merging+0x3b8>
  80302d:	83 ec 04             	sub    $0x4,%esp
  803030:	68 f8 43 80 00       	push   $0x8043f8
  803035:	68 98 01 00 00       	push   $0x198
  80303a:	68 dd 43 80 00       	push   $0x8043dd
  80303f:	e8 fc 08 00 00       	call   803940 <_panic>
  803044:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80304a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304d:	89 10                	mov    %edx,(%eax)
  80304f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803052:	8b 00                	mov    (%eax),%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	74 0d                	je     803065 <merging+0x3d9>
  803058:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80305d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803060:	89 50 04             	mov    %edx,0x4(%eax)
  803063:	eb 08                	jmp    80306d <merging+0x3e1>
  803065:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803068:	a3 30 50 80 00       	mov    %eax,0x805030
  80306d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803070:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803075:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803078:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307f:	a1 38 50 80 00       	mov    0x805038,%eax
  803084:	40                   	inc    %eax
  803085:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80308a:	83 ec 0c             	sub    $0xc,%esp
  80308d:	ff 75 10             	pushl  0x10(%ebp)
  803090:	e8 d6 ed ff ff       	call   801e6b <get_block_size>
  803095:	83 c4 10             	add    $0x10,%esp
  803098:	83 ec 04             	sub    $0x4,%esp
  80309b:	6a 00                	push   $0x0
  80309d:	50                   	push   %eax
  80309e:	ff 75 10             	pushl  0x10(%ebp)
  8030a1:	e8 16 f1 ff ff       	call   8021bc <set_block_data>
  8030a6:	83 c4 10             	add    $0x10,%esp
	}
}
  8030a9:	90                   	nop
  8030aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030ad:	c9                   	leave  
  8030ae:	c3                   	ret    

008030af <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030af:	55                   	push   %ebp
  8030b0:	89 e5                	mov    %esp,%ebp
  8030b2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030b5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030bd:	a1 30 50 80 00       	mov    0x805030,%eax
  8030c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c5:	73 1b                	jae    8030e2 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8030cc:	83 ec 04             	sub    $0x4,%esp
  8030cf:	ff 75 08             	pushl  0x8(%ebp)
  8030d2:	6a 00                	push   $0x0
  8030d4:	50                   	push   %eax
  8030d5:	e8 b2 fb ff ff       	call   802c8c <merging>
  8030da:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030dd:	e9 8b 00 00 00       	jmp    80316d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030e2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ea:	76 18                	jbe    803104 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030ec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030f1:	83 ec 04             	sub    $0x4,%esp
  8030f4:	ff 75 08             	pushl  0x8(%ebp)
  8030f7:	50                   	push   %eax
  8030f8:	6a 00                	push   $0x0
  8030fa:	e8 8d fb ff ff       	call   802c8c <merging>
  8030ff:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803102:	eb 69                	jmp    80316d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803104:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803109:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310c:	eb 39                	jmp    803147 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	3b 45 08             	cmp    0x8(%ebp),%eax
  803114:	73 29                	jae    80313f <free_block+0x90>
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	8b 00                	mov    (%eax),%eax
  80311b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80311e:	76 1f                	jbe    80313f <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803128:	83 ec 04             	sub    $0x4,%esp
  80312b:	ff 75 08             	pushl  0x8(%ebp)
  80312e:	ff 75 f0             	pushl  -0x10(%ebp)
  803131:	ff 75 f4             	pushl  -0xc(%ebp)
  803134:	e8 53 fb ff ff       	call   802c8c <merging>
  803139:	83 c4 10             	add    $0x10,%esp
			break;
  80313c:	90                   	nop
		}
	}
}
  80313d:	eb 2e                	jmp    80316d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80313f:	a1 34 50 80 00       	mov    0x805034,%eax
  803144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803147:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314b:	74 07                	je     803154 <free_block+0xa5>
  80314d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	eb 05                	jmp    803159 <free_block+0xaa>
  803154:	b8 00 00 00 00       	mov    $0x0,%eax
  803159:	a3 34 50 80 00       	mov    %eax,0x805034
  80315e:	a1 34 50 80 00       	mov    0x805034,%eax
  803163:	85 c0                	test   %eax,%eax
  803165:	75 a7                	jne    80310e <free_block+0x5f>
  803167:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316b:	75 a1                	jne    80310e <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80316d:	90                   	nop
  80316e:	c9                   	leave  
  80316f:	c3                   	ret    

00803170 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803170:	55                   	push   %ebp
  803171:	89 e5                	mov    %esp,%ebp
  803173:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803176:	ff 75 08             	pushl  0x8(%ebp)
  803179:	e8 ed ec ff ff       	call   801e6b <get_block_size>
  80317e:	83 c4 04             	add    $0x4,%esp
  803181:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803184:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80318b:	eb 17                	jmp    8031a4 <copy_data+0x34>
  80318d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803190:	8b 45 0c             	mov    0xc(%ebp),%eax
  803193:	01 c2                	add    %eax,%edx
  803195:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	01 c8                	add    %ecx,%eax
  80319d:	8a 00                	mov    (%eax),%al
  80319f:	88 02                	mov    %al,(%edx)
  8031a1:	ff 45 fc             	incl   -0x4(%ebp)
  8031a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031aa:	72 e1                	jb     80318d <copy_data+0x1d>
}
  8031ac:	90                   	nop
  8031ad:	c9                   	leave  
  8031ae:	c3                   	ret    

008031af <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031af:	55                   	push   %ebp
  8031b0:	89 e5                	mov    %esp,%ebp
  8031b2:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b9:	75 23                	jne    8031de <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8031bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031bf:	74 13                	je     8031d4 <realloc_block_FF+0x25>
  8031c1:	83 ec 0c             	sub    $0xc,%esp
  8031c4:	ff 75 0c             	pushl  0xc(%ebp)
  8031c7:	e8 1f f0 ff ff       	call   8021eb <alloc_block_FF>
  8031cc:	83 c4 10             	add    $0x10,%esp
  8031cf:	e9 f4 06 00 00       	jmp    8038c8 <realloc_block_FF+0x719>
		return NULL;
  8031d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d9:	e9 ea 06 00 00       	jmp    8038c8 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8031de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031e2:	75 18                	jne    8031fc <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031e4:	83 ec 0c             	sub    $0xc,%esp
  8031e7:	ff 75 08             	pushl  0x8(%ebp)
  8031ea:	e8 c0 fe ff ff       	call   8030af <free_block>
  8031ef:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f7:	e9 cc 06 00 00       	jmp    8038c8 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8031fc:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803200:	77 07                	ja     803209 <realloc_block_FF+0x5a>
  803202:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803209:	8b 45 0c             	mov    0xc(%ebp),%eax
  80320c:	83 e0 01             	and    $0x1,%eax
  80320f:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803212:	8b 45 0c             	mov    0xc(%ebp),%eax
  803215:	83 c0 08             	add    $0x8,%eax
  803218:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80321b:	83 ec 0c             	sub    $0xc,%esp
  80321e:	ff 75 08             	pushl  0x8(%ebp)
  803221:	e8 45 ec ff ff       	call   801e6b <get_block_size>
  803226:	83 c4 10             	add    $0x10,%esp
  803229:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80322c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322f:	83 e8 08             	sub    $0x8,%eax
  803232:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	83 e8 04             	sub    $0x4,%eax
  80323b:	8b 00                	mov    (%eax),%eax
  80323d:	83 e0 fe             	and    $0xfffffffe,%eax
  803240:	89 c2                	mov    %eax,%edx
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	01 d0                	add    %edx,%eax
  803247:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80324a:	83 ec 0c             	sub    $0xc,%esp
  80324d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803250:	e8 16 ec ff ff       	call   801e6b <get_block_size>
  803255:	83 c4 10             	add    $0x10,%esp
  803258:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80325b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80325e:	83 e8 08             	sub    $0x8,%eax
  803261:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803264:	8b 45 0c             	mov    0xc(%ebp),%eax
  803267:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80326a:	75 08                	jne    803274 <realloc_block_FF+0xc5>
	{
		 return va;
  80326c:	8b 45 08             	mov    0x8(%ebp),%eax
  80326f:	e9 54 06 00 00       	jmp    8038c8 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803274:	8b 45 0c             	mov    0xc(%ebp),%eax
  803277:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80327a:	0f 83 e5 03 00 00    	jae    803665 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803280:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803283:	2b 45 0c             	sub    0xc(%ebp),%eax
  803286:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803289:	83 ec 0c             	sub    $0xc,%esp
  80328c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80328f:	e8 f0 eb ff ff       	call   801e84 <is_free_block>
  803294:	83 c4 10             	add    $0x10,%esp
  803297:	84 c0                	test   %al,%al
  803299:	0f 84 3b 01 00 00    	je     8033da <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80329f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032a5:	01 d0                	add    %edx,%eax
  8032a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8032aa:	83 ec 04             	sub    $0x4,%esp
  8032ad:	6a 01                	push   $0x1
  8032af:	ff 75 f0             	pushl  -0x10(%ebp)
  8032b2:	ff 75 08             	pushl  0x8(%ebp)
  8032b5:	e8 02 ef ff ff       	call   8021bc <set_block_data>
  8032ba:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c0:	83 e8 04             	sub    $0x4,%eax
  8032c3:	8b 00                	mov    (%eax),%eax
  8032c5:	83 e0 fe             	and    $0xfffffffe,%eax
  8032c8:	89 c2                	mov    %eax,%edx
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	01 d0                	add    %edx,%eax
  8032cf:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8032d2:	83 ec 04             	sub    $0x4,%esp
  8032d5:	6a 00                	push   $0x0
  8032d7:	ff 75 cc             	pushl  -0x34(%ebp)
  8032da:	ff 75 c8             	pushl  -0x38(%ebp)
  8032dd:	e8 da ee ff ff       	call   8021bc <set_block_data>
  8032e2:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032e9:	74 06                	je     8032f1 <realloc_block_FF+0x142>
  8032eb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032ef:	75 17                	jne    803308 <realloc_block_FF+0x159>
  8032f1:	83 ec 04             	sub    $0x4,%esp
  8032f4:	68 50 44 80 00       	push   $0x804450
  8032f9:	68 f6 01 00 00       	push   $0x1f6
  8032fe:	68 dd 43 80 00       	push   $0x8043dd
  803303:	e8 38 06 00 00       	call   803940 <_panic>
  803308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330b:	8b 10                	mov    (%eax),%edx
  80330d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803310:	89 10                	mov    %edx,(%eax)
  803312:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	85 c0                	test   %eax,%eax
  803319:	74 0b                	je     803326 <realloc_block_FF+0x177>
  80331b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803323:	89 50 04             	mov    %edx,0x4(%eax)
  803326:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803329:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80332c:	89 10                	mov    %edx,(%eax)
  80332e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803331:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803334:	89 50 04             	mov    %edx,0x4(%eax)
  803337:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80333a:	8b 00                	mov    (%eax),%eax
  80333c:	85 c0                	test   %eax,%eax
  80333e:	75 08                	jne    803348 <realloc_block_FF+0x199>
  803340:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803343:	a3 30 50 80 00       	mov    %eax,0x805030
  803348:	a1 38 50 80 00       	mov    0x805038,%eax
  80334d:	40                   	inc    %eax
  80334e:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803353:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803357:	75 17                	jne    803370 <realloc_block_FF+0x1c1>
  803359:	83 ec 04             	sub    $0x4,%esp
  80335c:	68 bf 43 80 00       	push   $0x8043bf
  803361:	68 f7 01 00 00       	push   $0x1f7
  803366:	68 dd 43 80 00       	push   $0x8043dd
  80336b:	e8 d0 05 00 00       	call   803940 <_panic>
  803370:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803373:	8b 00                	mov    (%eax),%eax
  803375:	85 c0                	test   %eax,%eax
  803377:	74 10                	je     803389 <realloc_block_FF+0x1da>
  803379:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337c:	8b 00                	mov    (%eax),%eax
  80337e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803381:	8b 52 04             	mov    0x4(%edx),%edx
  803384:	89 50 04             	mov    %edx,0x4(%eax)
  803387:	eb 0b                	jmp    803394 <realloc_block_FF+0x1e5>
  803389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338c:	8b 40 04             	mov    0x4(%eax),%eax
  80338f:	a3 30 50 80 00       	mov    %eax,0x805030
  803394:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803397:	8b 40 04             	mov    0x4(%eax),%eax
  80339a:	85 c0                	test   %eax,%eax
  80339c:	74 0f                	je     8033ad <realloc_block_FF+0x1fe>
  80339e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a1:	8b 40 04             	mov    0x4(%eax),%eax
  8033a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033a7:	8b 12                	mov    (%edx),%edx
  8033a9:	89 10                	mov    %edx,(%eax)
  8033ab:	eb 0a                	jmp    8033b7 <realloc_block_FF+0x208>
  8033ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b0:	8b 00                	mov    (%eax),%eax
  8033b2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ca:	a1 38 50 80 00       	mov    0x805038,%eax
  8033cf:	48                   	dec    %eax
  8033d0:	a3 38 50 80 00       	mov    %eax,0x805038
  8033d5:	e9 83 02 00 00       	jmp    80365d <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8033da:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033de:	0f 86 69 02 00 00    	jbe    80364d <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033e4:	83 ec 04             	sub    $0x4,%esp
  8033e7:	6a 01                	push   $0x1
  8033e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8033ec:	ff 75 08             	pushl  0x8(%ebp)
  8033ef:	e8 c8 ed ff ff       	call   8021bc <set_block_data>
  8033f4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	83 e8 04             	sub    $0x4,%eax
  8033fd:	8b 00                	mov    (%eax),%eax
  8033ff:	83 e0 fe             	and    $0xfffffffe,%eax
  803402:	89 c2                	mov    %eax,%edx
  803404:	8b 45 08             	mov    0x8(%ebp),%eax
  803407:	01 d0                	add    %edx,%eax
  803409:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80340c:	a1 38 50 80 00       	mov    0x805038,%eax
  803411:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803414:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803418:	75 68                	jne    803482 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80341a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80341e:	75 17                	jne    803437 <realloc_block_FF+0x288>
  803420:	83 ec 04             	sub    $0x4,%esp
  803423:	68 f8 43 80 00       	push   $0x8043f8
  803428:	68 06 02 00 00       	push   $0x206
  80342d:	68 dd 43 80 00       	push   $0x8043dd
  803432:	e8 09 05 00 00       	call   803940 <_panic>
  803437:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80343d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803440:	89 10                	mov    %edx,(%eax)
  803442:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803445:	8b 00                	mov    (%eax),%eax
  803447:	85 c0                	test   %eax,%eax
  803449:	74 0d                	je     803458 <realloc_block_FF+0x2a9>
  80344b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803450:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803453:	89 50 04             	mov    %edx,0x4(%eax)
  803456:	eb 08                	jmp    803460 <realloc_block_FF+0x2b1>
  803458:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345b:	a3 30 50 80 00       	mov    %eax,0x805030
  803460:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803463:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803468:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803472:	a1 38 50 80 00       	mov    0x805038,%eax
  803477:	40                   	inc    %eax
  803478:	a3 38 50 80 00       	mov    %eax,0x805038
  80347d:	e9 b0 01 00 00       	jmp    803632 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803482:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803487:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80348a:	76 68                	jbe    8034f4 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80348c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803490:	75 17                	jne    8034a9 <realloc_block_FF+0x2fa>
  803492:	83 ec 04             	sub    $0x4,%esp
  803495:	68 f8 43 80 00       	push   $0x8043f8
  80349a:	68 0b 02 00 00       	push   $0x20b
  80349f:	68 dd 43 80 00       	push   $0x8043dd
  8034a4:	e8 97 04 00 00       	call   803940 <_panic>
  8034a9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b2:	89 10                	mov    %edx,(%eax)
  8034b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b7:	8b 00                	mov    (%eax),%eax
  8034b9:	85 c0                	test   %eax,%eax
  8034bb:	74 0d                	je     8034ca <realloc_block_FF+0x31b>
  8034bd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034c2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034c5:	89 50 04             	mov    %edx,0x4(%eax)
  8034c8:	eb 08                	jmp    8034d2 <realloc_block_FF+0x323>
  8034ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8034d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e9:	40                   	inc    %eax
  8034ea:	a3 38 50 80 00       	mov    %eax,0x805038
  8034ef:	e9 3e 01 00 00       	jmp    803632 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034f4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034f9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034fc:	73 68                	jae    803566 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034fe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803502:	75 17                	jne    80351b <realloc_block_FF+0x36c>
  803504:	83 ec 04             	sub    $0x4,%esp
  803507:	68 2c 44 80 00       	push   $0x80442c
  80350c:	68 10 02 00 00       	push   $0x210
  803511:	68 dd 43 80 00       	push   $0x8043dd
  803516:	e8 25 04 00 00       	call   803940 <_panic>
  80351b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803521:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803524:	89 50 04             	mov    %edx,0x4(%eax)
  803527:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352a:	8b 40 04             	mov    0x4(%eax),%eax
  80352d:	85 c0                	test   %eax,%eax
  80352f:	74 0c                	je     80353d <realloc_block_FF+0x38e>
  803531:	a1 30 50 80 00       	mov    0x805030,%eax
  803536:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803539:	89 10                	mov    %edx,(%eax)
  80353b:	eb 08                	jmp    803545 <realloc_block_FF+0x396>
  80353d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803540:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803545:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803548:	a3 30 50 80 00       	mov    %eax,0x805030
  80354d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803550:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803556:	a1 38 50 80 00       	mov    0x805038,%eax
  80355b:	40                   	inc    %eax
  80355c:	a3 38 50 80 00       	mov    %eax,0x805038
  803561:	e9 cc 00 00 00       	jmp    803632 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803566:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80356d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803572:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803575:	e9 8a 00 00 00       	jmp    803604 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80357a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803580:	73 7a                	jae    8035fc <realloc_block_FF+0x44d>
  803582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803585:	8b 00                	mov    (%eax),%eax
  803587:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80358a:	73 70                	jae    8035fc <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80358c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803590:	74 06                	je     803598 <realloc_block_FF+0x3e9>
  803592:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803596:	75 17                	jne    8035af <realloc_block_FF+0x400>
  803598:	83 ec 04             	sub    $0x4,%esp
  80359b:	68 50 44 80 00       	push   $0x804450
  8035a0:	68 1a 02 00 00       	push   $0x21a
  8035a5:	68 dd 43 80 00       	push   $0x8043dd
  8035aa:	e8 91 03 00 00       	call   803940 <_panic>
  8035af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b2:	8b 10                	mov    (%eax),%edx
  8035b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b7:	89 10                	mov    %edx,(%eax)
  8035b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bc:	8b 00                	mov    (%eax),%eax
  8035be:	85 c0                	test   %eax,%eax
  8035c0:	74 0b                	je     8035cd <realloc_block_FF+0x41e>
  8035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c5:	8b 00                	mov    (%eax),%eax
  8035c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ca:	89 50 04             	mov    %edx,0x4(%eax)
  8035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035d3:	89 10                	mov    %edx,(%eax)
  8035d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035db:	89 50 04             	mov    %edx,0x4(%eax)
  8035de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035e1:	8b 00                	mov    (%eax),%eax
  8035e3:	85 c0                	test   %eax,%eax
  8035e5:	75 08                	jne    8035ef <realloc_block_FF+0x440>
  8035e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8035f4:	40                   	inc    %eax
  8035f5:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035fa:	eb 36                	jmp    803632 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035fc:	a1 34 50 80 00       	mov    0x805034,%eax
  803601:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803608:	74 07                	je     803611 <realloc_block_FF+0x462>
  80360a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360d:	8b 00                	mov    (%eax),%eax
  80360f:	eb 05                	jmp    803616 <realloc_block_FF+0x467>
  803611:	b8 00 00 00 00       	mov    $0x0,%eax
  803616:	a3 34 50 80 00       	mov    %eax,0x805034
  80361b:	a1 34 50 80 00       	mov    0x805034,%eax
  803620:	85 c0                	test   %eax,%eax
  803622:	0f 85 52 ff ff ff    	jne    80357a <realloc_block_FF+0x3cb>
  803628:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80362c:	0f 85 48 ff ff ff    	jne    80357a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803632:	83 ec 04             	sub    $0x4,%esp
  803635:	6a 00                	push   $0x0
  803637:	ff 75 d8             	pushl  -0x28(%ebp)
  80363a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80363d:	e8 7a eb ff ff       	call   8021bc <set_block_data>
  803642:	83 c4 10             	add    $0x10,%esp
				return va;
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	e9 7b 02 00 00       	jmp    8038c8 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80364d:	83 ec 0c             	sub    $0xc,%esp
  803650:	68 cd 44 80 00       	push   $0x8044cd
  803655:	e8 6e cd ff ff       	call   8003c8 <cprintf>
  80365a:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80365d:	8b 45 08             	mov    0x8(%ebp),%eax
  803660:	e9 63 02 00 00       	jmp    8038c8 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803665:	8b 45 0c             	mov    0xc(%ebp),%eax
  803668:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80366b:	0f 86 4d 02 00 00    	jbe    8038be <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803671:	83 ec 0c             	sub    $0xc,%esp
  803674:	ff 75 e4             	pushl  -0x1c(%ebp)
  803677:	e8 08 e8 ff ff       	call   801e84 <is_free_block>
  80367c:	83 c4 10             	add    $0x10,%esp
  80367f:	84 c0                	test   %al,%al
  803681:	0f 84 37 02 00 00    	je     8038be <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80368d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803690:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803693:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803696:	76 38                	jbe    8036d0 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803698:	83 ec 0c             	sub    $0xc,%esp
  80369b:	ff 75 08             	pushl  0x8(%ebp)
  80369e:	e8 0c fa ff ff       	call   8030af <free_block>
  8036a3:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8036a6:	83 ec 0c             	sub    $0xc,%esp
  8036a9:	ff 75 0c             	pushl  0xc(%ebp)
  8036ac:	e8 3a eb ff ff       	call   8021eb <alloc_block_FF>
  8036b1:	83 c4 10             	add    $0x10,%esp
  8036b4:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8036b7:	83 ec 08             	sub    $0x8,%esp
  8036ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8036bd:	ff 75 08             	pushl  0x8(%ebp)
  8036c0:	e8 ab fa ff ff       	call   803170 <copy_data>
  8036c5:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036c8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036cb:	e9 f8 01 00 00       	jmp    8038c8 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036d3:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8036d6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8036d9:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8036dd:	0f 87 a0 00 00 00    	ja     803783 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8036e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036e7:	75 17                	jne    803700 <realloc_block_FF+0x551>
  8036e9:	83 ec 04             	sub    $0x4,%esp
  8036ec:	68 bf 43 80 00       	push   $0x8043bf
  8036f1:	68 38 02 00 00       	push   $0x238
  8036f6:	68 dd 43 80 00       	push   $0x8043dd
  8036fb:	e8 40 02 00 00       	call   803940 <_panic>
  803700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803703:	8b 00                	mov    (%eax),%eax
  803705:	85 c0                	test   %eax,%eax
  803707:	74 10                	je     803719 <realloc_block_FF+0x56a>
  803709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370c:	8b 00                	mov    (%eax),%eax
  80370e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803711:	8b 52 04             	mov    0x4(%edx),%edx
  803714:	89 50 04             	mov    %edx,0x4(%eax)
  803717:	eb 0b                	jmp    803724 <realloc_block_FF+0x575>
  803719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80371c:	8b 40 04             	mov    0x4(%eax),%eax
  80371f:	a3 30 50 80 00       	mov    %eax,0x805030
  803724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803727:	8b 40 04             	mov    0x4(%eax),%eax
  80372a:	85 c0                	test   %eax,%eax
  80372c:	74 0f                	je     80373d <realloc_block_FF+0x58e>
  80372e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803731:	8b 40 04             	mov    0x4(%eax),%eax
  803734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803737:	8b 12                	mov    (%edx),%edx
  803739:	89 10                	mov    %edx,(%eax)
  80373b:	eb 0a                	jmp    803747 <realloc_block_FF+0x598>
  80373d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803740:	8b 00                	mov    (%eax),%eax
  803742:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803753:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375a:	a1 38 50 80 00       	mov    0x805038,%eax
  80375f:	48                   	dec    %eax
  803760:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803765:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803768:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80376b:	01 d0                	add    %edx,%eax
  80376d:	83 ec 04             	sub    $0x4,%esp
  803770:	6a 01                	push   $0x1
  803772:	50                   	push   %eax
  803773:	ff 75 08             	pushl  0x8(%ebp)
  803776:	e8 41 ea ff ff       	call   8021bc <set_block_data>
  80377b:	83 c4 10             	add    $0x10,%esp
  80377e:	e9 36 01 00 00       	jmp    8038b9 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803783:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803786:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803789:	01 d0                	add    %edx,%eax
  80378b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80378e:	83 ec 04             	sub    $0x4,%esp
  803791:	6a 01                	push   $0x1
  803793:	ff 75 f0             	pushl  -0x10(%ebp)
  803796:	ff 75 08             	pushl  0x8(%ebp)
  803799:	e8 1e ea ff ff       	call   8021bc <set_block_data>
  80379e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	83 e8 04             	sub    $0x4,%eax
  8037a7:	8b 00                	mov    (%eax),%eax
  8037a9:	83 e0 fe             	and    $0xfffffffe,%eax
  8037ac:	89 c2                	mov    %eax,%edx
  8037ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b1:	01 d0                	add    %edx,%eax
  8037b3:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037ba:	74 06                	je     8037c2 <realloc_block_FF+0x613>
  8037bc:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037c0:	75 17                	jne    8037d9 <realloc_block_FF+0x62a>
  8037c2:	83 ec 04             	sub    $0x4,%esp
  8037c5:	68 50 44 80 00       	push   $0x804450
  8037ca:	68 44 02 00 00       	push   $0x244
  8037cf:	68 dd 43 80 00       	push   $0x8043dd
  8037d4:	e8 67 01 00 00       	call   803940 <_panic>
  8037d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037dc:	8b 10                	mov    (%eax),%edx
  8037de:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037e1:	89 10                	mov    %edx,(%eax)
  8037e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037e6:	8b 00                	mov    (%eax),%eax
  8037e8:	85 c0                	test   %eax,%eax
  8037ea:	74 0b                	je     8037f7 <realloc_block_FF+0x648>
  8037ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ef:	8b 00                	mov    (%eax),%eax
  8037f1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037f4:	89 50 04             	mov    %edx,0x4(%eax)
  8037f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fa:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037fd:	89 10                	mov    %edx,(%eax)
  8037ff:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803802:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803805:	89 50 04             	mov    %edx,0x4(%eax)
  803808:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80380b:	8b 00                	mov    (%eax),%eax
  80380d:	85 c0                	test   %eax,%eax
  80380f:	75 08                	jne    803819 <realloc_block_FF+0x66a>
  803811:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803814:	a3 30 50 80 00       	mov    %eax,0x805030
  803819:	a1 38 50 80 00       	mov    0x805038,%eax
  80381e:	40                   	inc    %eax
  80381f:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803824:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803828:	75 17                	jne    803841 <realloc_block_FF+0x692>
  80382a:	83 ec 04             	sub    $0x4,%esp
  80382d:	68 bf 43 80 00       	push   $0x8043bf
  803832:	68 45 02 00 00       	push   $0x245
  803837:	68 dd 43 80 00       	push   $0x8043dd
  80383c:	e8 ff 00 00 00       	call   803940 <_panic>
  803841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803844:	8b 00                	mov    (%eax),%eax
  803846:	85 c0                	test   %eax,%eax
  803848:	74 10                	je     80385a <realloc_block_FF+0x6ab>
  80384a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384d:	8b 00                	mov    (%eax),%eax
  80384f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803852:	8b 52 04             	mov    0x4(%edx),%edx
  803855:	89 50 04             	mov    %edx,0x4(%eax)
  803858:	eb 0b                	jmp    803865 <realloc_block_FF+0x6b6>
  80385a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385d:	8b 40 04             	mov    0x4(%eax),%eax
  803860:	a3 30 50 80 00       	mov    %eax,0x805030
  803865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803868:	8b 40 04             	mov    0x4(%eax),%eax
  80386b:	85 c0                	test   %eax,%eax
  80386d:	74 0f                	je     80387e <realloc_block_FF+0x6cf>
  80386f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803872:	8b 40 04             	mov    0x4(%eax),%eax
  803875:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803878:	8b 12                	mov    (%edx),%edx
  80387a:	89 10                	mov    %edx,(%eax)
  80387c:	eb 0a                	jmp    803888 <realloc_block_FF+0x6d9>
  80387e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803881:	8b 00                	mov    (%eax),%eax
  803883:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803891:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803894:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80389b:	a1 38 50 80 00       	mov    0x805038,%eax
  8038a0:	48                   	dec    %eax
  8038a1:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8038a6:	83 ec 04             	sub    $0x4,%esp
  8038a9:	6a 00                	push   $0x0
  8038ab:	ff 75 bc             	pushl  -0x44(%ebp)
  8038ae:	ff 75 b8             	pushl  -0x48(%ebp)
  8038b1:	e8 06 e9 ff ff       	call   8021bc <set_block_data>
  8038b6:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8038b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bc:	eb 0a                	jmp    8038c8 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8038be:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038c8:	c9                   	leave  
  8038c9:	c3                   	ret    

008038ca <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038ca:	55                   	push   %ebp
  8038cb:	89 e5                	mov    %esp,%ebp
  8038cd:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038d0:	83 ec 04             	sub    $0x4,%esp
  8038d3:	68 d4 44 80 00       	push   $0x8044d4
  8038d8:	68 58 02 00 00       	push   $0x258
  8038dd:	68 dd 43 80 00       	push   $0x8043dd
  8038e2:	e8 59 00 00 00       	call   803940 <_panic>

008038e7 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038e7:	55                   	push   %ebp
  8038e8:	89 e5                	mov    %esp,%ebp
  8038ea:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038ed:	83 ec 04             	sub    $0x4,%esp
  8038f0:	68 fc 44 80 00       	push   $0x8044fc
  8038f5:	68 61 02 00 00       	push   $0x261
  8038fa:	68 dd 43 80 00       	push   $0x8043dd
  8038ff:	e8 3c 00 00 00       	call   803940 <_panic>

00803904 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  803904:	55                   	push   %ebp
  803905:	89 e5                	mov    %esp,%ebp
  803907:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80390a:	8b 45 08             	mov    0x8(%ebp),%eax
  80390d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  803910:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803914:	83 ec 0c             	sub    $0xc,%esp
  803917:	50                   	push   %eax
  803918:	e8 dd e0 ff ff       	call   8019fa <sys_cputc>
  80391d:	83 c4 10             	add    $0x10,%esp
}
  803920:	90                   	nop
  803921:	c9                   	leave  
  803922:	c3                   	ret    

00803923 <getchar>:


int
getchar(void)
{
  803923:	55                   	push   %ebp
  803924:	89 e5                	mov    %esp,%ebp
  803926:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803929:	e8 68 df ff ff       	call   801896 <sys_cgetc>
  80392e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  803931:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803934:	c9                   	leave  
  803935:	c3                   	ret    

00803936 <iscons>:

int iscons(int fdnum)
{
  803936:	55                   	push   %ebp
  803937:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803939:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80393e:	5d                   	pop    %ebp
  80393f:	c3                   	ret    

00803940 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803940:	55                   	push   %ebp
  803941:	89 e5                	mov    %esp,%ebp
  803943:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803946:	8d 45 10             	lea    0x10(%ebp),%eax
  803949:	83 c0 04             	add    $0x4,%eax
  80394c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80394f:	a1 60 50 90 00       	mov    0x905060,%eax
  803954:	85 c0                	test   %eax,%eax
  803956:	74 16                	je     80396e <_panic+0x2e>
		cprintf("%s: ", argv0);
  803958:	a1 60 50 90 00       	mov    0x905060,%eax
  80395d:	83 ec 08             	sub    $0x8,%esp
  803960:	50                   	push   %eax
  803961:	68 24 45 80 00       	push   $0x804524
  803966:	e8 5d ca ff ff       	call   8003c8 <cprintf>
  80396b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80396e:	a1 00 50 80 00       	mov    0x805000,%eax
  803973:	ff 75 0c             	pushl  0xc(%ebp)
  803976:	ff 75 08             	pushl  0x8(%ebp)
  803979:	50                   	push   %eax
  80397a:	68 29 45 80 00       	push   $0x804529
  80397f:	e8 44 ca ff ff       	call   8003c8 <cprintf>
  803984:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803987:	8b 45 10             	mov    0x10(%ebp),%eax
  80398a:	83 ec 08             	sub    $0x8,%esp
  80398d:	ff 75 f4             	pushl  -0xc(%ebp)
  803990:	50                   	push   %eax
  803991:	e8 c7 c9 ff ff       	call   80035d <vcprintf>
  803996:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803999:	83 ec 08             	sub    $0x8,%esp
  80399c:	6a 00                	push   $0x0
  80399e:	68 45 45 80 00       	push   $0x804545
  8039a3:	e8 b5 c9 ff ff       	call   80035d <vcprintf>
  8039a8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8039ab:	e8 36 c9 ff ff       	call   8002e6 <exit>

	// should not return here
	while (1) ;
  8039b0:	eb fe                	jmp    8039b0 <_panic+0x70>

008039b2 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8039b2:	55                   	push   %ebp
  8039b3:	89 e5                	mov    %esp,%ebp
  8039b5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8039b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8039bd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039c6:	39 c2                	cmp    %eax,%edx
  8039c8:	74 14                	je     8039de <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8039ca:	83 ec 04             	sub    $0x4,%esp
  8039cd:	68 48 45 80 00       	push   $0x804548
  8039d2:	6a 26                	push   $0x26
  8039d4:	68 94 45 80 00       	push   $0x804594
  8039d9:	e8 62 ff ff ff       	call   803940 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8039de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8039e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8039ec:	e9 c5 00 00 00       	jmp    803ab6 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8039f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fe:	01 d0                	add    %edx,%eax
  803a00:	8b 00                	mov    (%eax),%eax
  803a02:	85 c0                	test   %eax,%eax
  803a04:	75 08                	jne    803a0e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a06:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a09:	e9 a5 00 00 00       	jmp    803ab3 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a0e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a15:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a1c:	eb 69                	jmp    803a87 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a1e:	a1 20 50 80 00       	mov    0x805020,%eax
  803a23:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a29:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a2c:	89 d0                	mov    %edx,%eax
  803a2e:	01 c0                	add    %eax,%eax
  803a30:	01 d0                	add    %edx,%eax
  803a32:	c1 e0 03             	shl    $0x3,%eax
  803a35:	01 c8                	add    %ecx,%eax
  803a37:	8a 40 04             	mov    0x4(%eax),%al
  803a3a:	84 c0                	test   %al,%al
  803a3c:	75 46                	jne    803a84 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a3e:	a1 20 50 80 00       	mov    0x805020,%eax
  803a43:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a4c:	89 d0                	mov    %edx,%eax
  803a4e:	01 c0                	add    %eax,%eax
  803a50:	01 d0                	add    %edx,%eax
  803a52:	c1 e0 03             	shl    $0x3,%eax
  803a55:	01 c8                	add    %ecx,%eax
  803a57:	8b 00                	mov    (%eax),%eax
  803a59:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a64:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a69:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a70:	8b 45 08             	mov    0x8(%ebp),%eax
  803a73:	01 c8                	add    %ecx,%eax
  803a75:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a77:	39 c2                	cmp    %eax,%edx
  803a79:	75 09                	jne    803a84 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a7b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a82:	eb 15                	jmp    803a99 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a84:	ff 45 e8             	incl   -0x18(%ebp)
  803a87:	a1 20 50 80 00       	mov    0x805020,%eax
  803a8c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a95:	39 c2                	cmp    %eax,%edx
  803a97:	77 85                	ja     803a1e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a9d:	75 14                	jne    803ab3 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803a9f:	83 ec 04             	sub    $0x4,%esp
  803aa2:	68 a0 45 80 00       	push   $0x8045a0
  803aa7:	6a 3a                	push   $0x3a
  803aa9:	68 94 45 80 00       	push   $0x804594
  803aae:	e8 8d fe ff ff       	call   803940 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803ab3:	ff 45 f0             	incl   -0x10(%ebp)
  803ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803abc:	0f 8c 2f ff ff ff    	jl     8039f1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803ac2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ac9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803ad0:	eb 26                	jmp    803af8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803ad2:	a1 20 50 80 00       	mov    0x805020,%eax
  803ad7:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803add:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ae0:	89 d0                	mov    %edx,%eax
  803ae2:	01 c0                	add    %eax,%eax
  803ae4:	01 d0                	add    %edx,%eax
  803ae6:	c1 e0 03             	shl    $0x3,%eax
  803ae9:	01 c8                	add    %ecx,%eax
  803aeb:	8a 40 04             	mov    0x4(%eax),%al
  803aee:	3c 01                	cmp    $0x1,%al
  803af0:	75 03                	jne    803af5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803af2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803af5:	ff 45 e0             	incl   -0x20(%ebp)
  803af8:	a1 20 50 80 00       	mov    0x805020,%eax
  803afd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b06:	39 c2                	cmp    %eax,%edx
  803b08:	77 c8                	ja     803ad2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b10:	74 14                	je     803b26 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b12:	83 ec 04             	sub    $0x4,%esp
  803b15:	68 f4 45 80 00       	push   $0x8045f4
  803b1a:	6a 44                	push   $0x44
  803b1c:	68 94 45 80 00       	push   $0x804594
  803b21:	e8 1a fe ff ff       	call   803940 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b26:	90                   	nop
  803b27:	c9                   	leave  
  803b28:	c3                   	ret    
  803b29:	66 90                	xchg   %ax,%ax
  803b2b:	90                   	nop

00803b2c <__udivdi3>:
  803b2c:	55                   	push   %ebp
  803b2d:	57                   	push   %edi
  803b2e:	56                   	push   %esi
  803b2f:	53                   	push   %ebx
  803b30:	83 ec 1c             	sub    $0x1c,%esp
  803b33:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b37:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b43:	89 ca                	mov    %ecx,%edx
  803b45:	89 f8                	mov    %edi,%eax
  803b47:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b4b:	85 f6                	test   %esi,%esi
  803b4d:	75 2d                	jne    803b7c <__udivdi3+0x50>
  803b4f:	39 cf                	cmp    %ecx,%edi
  803b51:	77 65                	ja     803bb8 <__udivdi3+0x8c>
  803b53:	89 fd                	mov    %edi,%ebp
  803b55:	85 ff                	test   %edi,%edi
  803b57:	75 0b                	jne    803b64 <__udivdi3+0x38>
  803b59:	b8 01 00 00 00       	mov    $0x1,%eax
  803b5e:	31 d2                	xor    %edx,%edx
  803b60:	f7 f7                	div    %edi
  803b62:	89 c5                	mov    %eax,%ebp
  803b64:	31 d2                	xor    %edx,%edx
  803b66:	89 c8                	mov    %ecx,%eax
  803b68:	f7 f5                	div    %ebp
  803b6a:	89 c1                	mov    %eax,%ecx
  803b6c:	89 d8                	mov    %ebx,%eax
  803b6e:	f7 f5                	div    %ebp
  803b70:	89 cf                	mov    %ecx,%edi
  803b72:	89 fa                	mov    %edi,%edx
  803b74:	83 c4 1c             	add    $0x1c,%esp
  803b77:	5b                   	pop    %ebx
  803b78:	5e                   	pop    %esi
  803b79:	5f                   	pop    %edi
  803b7a:	5d                   	pop    %ebp
  803b7b:	c3                   	ret    
  803b7c:	39 ce                	cmp    %ecx,%esi
  803b7e:	77 28                	ja     803ba8 <__udivdi3+0x7c>
  803b80:	0f bd fe             	bsr    %esi,%edi
  803b83:	83 f7 1f             	xor    $0x1f,%edi
  803b86:	75 40                	jne    803bc8 <__udivdi3+0x9c>
  803b88:	39 ce                	cmp    %ecx,%esi
  803b8a:	72 0a                	jb     803b96 <__udivdi3+0x6a>
  803b8c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b90:	0f 87 9e 00 00 00    	ja     803c34 <__udivdi3+0x108>
  803b96:	b8 01 00 00 00       	mov    $0x1,%eax
  803b9b:	89 fa                	mov    %edi,%edx
  803b9d:	83 c4 1c             	add    $0x1c,%esp
  803ba0:	5b                   	pop    %ebx
  803ba1:	5e                   	pop    %esi
  803ba2:	5f                   	pop    %edi
  803ba3:	5d                   	pop    %ebp
  803ba4:	c3                   	ret    
  803ba5:	8d 76 00             	lea    0x0(%esi),%esi
  803ba8:	31 ff                	xor    %edi,%edi
  803baa:	31 c0                	xor    %eax,%eax
  803bac:	89 fa                	mov    %edi,%edx
  803bae:	83 c4 1c             	add    $0x1c,%esp
  803bb1:	5b                   	pop    %ebx
  803bb2:	5e                   	pop    %esi
  803bb3:	5f                   	pop    %edi
  803bb4:	5d                   	pop    %ebp
  803bb5:	c3                   	ret    
  803bb6:	66 90                	xchg   %ax,%ax
  803bb8:	89 d8                	mov    %ebx,%eax
  803bba:	f7 f7                	div    %edi
  803bbc:	31 ff                	xor    %edi,%edi
  803bbe:	89 fa                	mov    %edi,%edx
  803bc0:	83 c4 1c             	add    $0x1c,%esp
  803bc3:	5b                   	pop    %ebx
  803bc4:	5e                   	pop    %esi
  803bc5:	5f                   	pop    %edi
  803bc6:	5d                   	pop    %ebp
  803bc7:	c3                   	ret    
  803bc8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bcd:	89 eb                	mov    %ebp,%ebx
  803bcf:	29 fb                	sub    %edi,%ebx
  803bd1:	89 f9                	mov    %edi,%ecx
  803bd3:	d3 e6                	shl    %cl,%esi
  803bd5:	89 c5                	mov    %eax,%ebp
  803bd7:	88 d9                	mov    %bl,%cl
  803bd9:	d3 ed                	shr    %cl,%ebp
  803bdb:	89 e9                	mov    %ebp,%ecx
  803bdd:	09 f1                	or     %esi,%ecx
  803bdf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803be3:	89 f9                	mov    %edi,%ecx
  803be5:	d3 e0                	shl    %cl,%eax
  803be7:	89 c5                	mov    %eax,%ebp
  803be9:	89 d6                	mov    %edx,%esi
  803beb:	88 d9                	mov    %bl,%cl
  803bed:	d3 ee                	shr    %cl,%esi
  803bef:	89 f9                	mov    %edi,%ecx
  803bf1:	d3 e2                	shl    %cl,%edx
  803bf3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf7:	88 d9                	mov    %bl,%cl
  803bf9:	d3 e8                	shr    %cl,%eax
  803bfb:	09 c2                	or     %eax,%edx
  803bfd:	89 d0                	mov    %edx,%eax
  803bff:	89 f2                	mov    %esi,%edx
  803c01:	f7 74 24 0c          	divl   0xc(%esp)
  803c05:	89 d6                	mov    %edx,%esi
  803c07:	89 c3                	mov    %eax,%ebx
  803c09:	f7 e5                	mul    %ebp
  803c0b:	39 d6                	cmp    %edx,%esi
  803c0d:	72 19                	jb     803c28 <__udivdi3+0xfc>
  803c0f:	74 0b                	je     803c1c <__udivdi3+0xf0>
  803c11:	89 d8                	mov    %ebx,%eax
  803c13:	31 ff                	xor    %edi,%edi
  803c15:	e9 58 ff ff ff       	jmp    803b72 <__udivdi3+0x46>
  803c1a:	66 90                	xchg   %ax,%ax
  803c1c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c20:	89 f9                	mov    %edi,%ecx
  803c22:	d3 e2                	shl    %cl,%edx
  803c24:	39 c2                	cmp    %eax,%edx
  803c26:	73 e9                	jae    803c11 <__udivdi3+0xe5>
  803c28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c2b:	31 ff                	xor    %edi,%edi
  803c2d:	e9 40 ff ff ff       	jmp    803b72 <__udivdi3+0x46>
  803c32:	66 90                	xchg   %ax,%ax
  803c34:	31 c0                	xor    %eax,%eax
  803c36:	e9 37 ff ff ff       	jmp    803b72 <__udivdi3+0x46>
  803c3b:	90                   	nop

00803c3c <__umoddi3>:
  803c3c:	55                   	push   %ebp
  803c3d:	57                   	push   %edi
  803c3e:	56                   	push   %esi
  803c3f:	53                   	push   %ebx
  803c40:	83 ec 1c             	sub    $0x1c,%esp
  803c43:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c47:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c5b:	89 f3                	mov    %esi,%ebx
  803c5d:	89 fa                	mov    %edi,%edx
  803c5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c63:	89 34 24             	mov    %esi,(%esp)
  803c66:	85 c0                	test   %eax,%eax
  803c68:	75 1a                	jne    803c84 <__umoddi3+0x48>
  803c6a:	39 f7                	cmp    %esi,%edi
  803c6c:	0f 86 a2 00 00 00    	jbe    803d14 <__umoddi3+0xd8>
  803c72:	89 c8                	mov    %ecx,%eax
  803c74:	89 f2                	mov    %esi,%edx
  803c76:	f7 f7                	div    %edi
  803c78:	89 d0                	mov    %edx,%eax
  803c7a:	31 d2                	xor    %edx,%edx
  803c7c:	83 c4 1c             	add    $0x1c,%esp
  803c7f:	5b                   	pop    %ebx
  803c80:	5e                   	pop    %esi
  803c81:	5f                   	pop    %edi
  803c82:	5d                   	pop    %ebp
  803c83:	c3                   	ret    
  803c84:	39 f0                	cmp    %esi,%eax
  803c86:	0f 87 ac 00 00 00    	ja     803d38 <__umoddi3+0xfc>
  803c8c:	0f bd e8             	bsr    %eax,%ebp
  803c8f:	83 f5 1f             	xor    $0x1f,%ebp
  803c92:	0f 84 ac 00 00 00    	je     803d44 <__umoddi3+0x108>
  803c98:	bf 20 00 00 00       	mov    $0x20,%edi
  803c9d:	29 ef                	sub    %ebp,%edi
  803c9f:	89 fe                	mov    %edi,%esi
  803ca1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ca5:	89 e9                	mov    %ebp,%ecx
  803ca7:	d3 e0                	shl    %cl,%eax
  803ca9:	89 d7                	mov    %edx,%edi
  803cab:	89 f1                	mov    %esi,%ecx
  803cad:	d3 ef                	shr    %cl,%edi
  803caf:	09 c7                	or     %eax,%edi
  803cb1:	89 e9                	mov    %ebp,%ecx
  803cb3:	d3 e2                	shl    %cl,%edx
  803cb5:	89 14 24             	mov    %edx,(%esp)
  803cb8:	89 d8                	mov    %ebx,%eax
  803cba:	d3 e0                	shl    %cl,%eax
  803cbc:	89 c2                	mov    %eax,%edx
  803cbe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cc2:	d3 e0                	shl    %cl,%eax
  803cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cc8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ccc:	89 f1                	mov    %esi,%ecx
  803cce:	d3 e8                	shr    %cl,%eax
  803cd0:	09 d0                	or     %edx,%eax
  803cd2:	d3 eb                	shr    %cl,%ebx
  803cd4:	89 da                	mov    %ebx,%edx
  803cd6:	f7 f7                	div    %edi
  803cd8:	89 d3                	mov    %edx,%ebx
  803cda:	f7 24 24             	mull   (%esp)
  803cdd:	89 c6                	mov    %eax,%esi
  803cdf:	89 d1                	mov    %edx,%ecx
  803ce1:	39 d3                	cmp    %edx,%ebx
  803ce3:	0f 82 87 00 00 00    	jb     803d70 <__umoddi3+0x134>
  803ce9:	0f 84 91 00 00 00    	je     803d80 <__umoddi3+0x144>
  803cef:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cf3:	29 f2                	sub    %esi,%edx
  803cf5:	19 cb                	sbb    %ecx,%ebx
  803cf7:	89 d8                	mov    %ebx,%eax
  803cf9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cfd:	d3 e0                	shl    %cl,%eax
  803cff:	89 e9                	mov    %ebp,%ecx
  803d01:	d3 ea                	shr    %cl,%edx
  803d03:	09 d0                	or     %edx,%eax
  803d05:	89 e9                	mov    %ebp,%ecx
  803d07:	d3 eb                	shr    %cl,%ebx
  803d09:	89 da                	mov    %ebx,%edx
  803d0b:	83 c4 1c             	add    $0x1c,%esp
  803d0e:	5b                   	pop    %ebx
  803d0f:	5e                   	pop    %esi
  803d10:	5f                   	pop    %edi
  803d11:	5d                   	pop    %ebp
  803d12:	c3                   	ret    
  803d13:	90                   	nop
  803d14:	89 fd                	mov    %edi,%ebp
  803d16:	85 ff                	test   %edi,%edi
  803d18:	75 0b                	jne    803d25 <__umoddi3+0xe9>
  803d1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d1f:	31 d2                	xor    %edx,%edx
  803d21:	f7 f7                	div    %edi
  803d23:	89 c5                	mov    %eax,%ebp
  803d25:	89 f0                	mov    %esi,%eax
  803d27:	31 d2                	xor    %edx,%edx
  803d29:	f7 f5                	div    %ebp
  803d2b:	89 c8                	mov    %ecx,%eax
  803d2d:	f7 f5                	div    %ebp
  803d2f:	89 d0                	mov    %edx,%eax
  803d31:	e9 44 ff ff ff       	jmp    803c7a <__umoddi3+0x3e>
  803d36:	66 90                	xchg   %ax,%ax
  803d38:	89 c8                	mov    %ecx,%eax
  803d3a:	89 f2                	mov    %esi,%edx
  803d3c:	83 c4 1c             	add    $0x1c,%esp
  803d3f:	5b                   	pop    %ebx
  803d40:	5e                   	pop    %esi
  803d41:	5f                   	pop    %edi
  803d42:	5d                   	pop    %ebp
  803d43:	c3                   	ret    
  803d44:	3b 04 24             	cmp    (%esp),%eax
  803d47:	72 06                	jb     803d4f <__umoddi3+0x113>
  803d49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d4d:	77 0f                	ja     803d5e <__umoddi3+0x122>
  803d4f:	89 f2                	mov    %esi,%edx
  803d51:	29 f9                	sub    %edi,%ecx
  803d53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d57:	89 14 24             	mov    %edx,(%esp)
  803d5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d62:	8b 14 24             	mov    (%esp),%edx
  803d65:	83 c4 1c             	add    $0x1c,%esp
  803d68:	5b                   	pop    %ebx
  803d69:	5e                   	pop    %esi
  803d6a:	5f                   	pop    %edi
  803d6b:	5d                   	pop    %ebp
  803d6c:	c3                   	ret    
  803d6d:	8d 76 00             	lea    0x0(%esi),%esi
  803d70:	2b 04 24             	sub    (%esp),%eax
  803d73:	19 fa                	sbb    %edi,%edx
  803d75:	89 d1                	mov    %edx,%ecx
  803d77:	89 c6                	mov    %eax,%esi
  803d79:	e9 71 ff ff ff       	jmp    803cef <__umoddi3+0xb3>
  803d7e:	66 90                	xchg   %ax,%ax
  803d80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d84:	72 ea                	jb     803d70 <__umoddi3+0x134>
  803d86:	89 d9                	mov    %ebx,%ecx
  803d88:	e9 62 ff ff ff       	jmp    803cef <__umoddi3+0xb3>
