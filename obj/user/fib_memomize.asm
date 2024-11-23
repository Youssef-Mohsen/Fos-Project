
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
  800052:	68 80 3d 80 00       	push   $0x803d80
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
  8000ec:	68 9e 3d 80 00       	push   $0x803d9e
  8000f1:	e8 ff 02 00 00       	call   8003f5 <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 5b 1b 00 00       	call   801c59 <inctst>
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
  8001bb:	e8 5b 19 00 00       	call   801b1b <sys_getenvindex>
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
  800229:	e8 71 16 00 00       	call   80189f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	68 cc 3d 80 00       	push   $0x803dcc
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
  800259:	68 f4 3d 80 00       	push   $0x803df4
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
  80028a:	68 1c 3e 80 00       	push   $0x803e1c
  80028f:	e8 34 01 00 00       	call   8003c8 <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800297:	a1 20 50 80 00       	mov    0x805020,%eax
  80029c:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	50                   	push   %eax
  8002a6:	68 74 3e 80 00       	push   $0x803e74
  8002ab:	e8 18 01 00 00       	call   8003c8 <cprintf>
  8002b0:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	68 cc 3d 80 00       	push   $0x803dcc
  8002bb:	e8 08 01 00 00       	call   8003c8 <cprintf>
  8002c0:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002c3:	e8 f1 15 00 00       	call   8018b9 <sys_unlock_cons>
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
  8002db:	e8 07 18 00 00       	call   801ae7 <sys_destroy_env>
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
  8002ec:	e8 5c 18 00 00       	call   801b4d <sys_exit_env>
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
  80033a:	e8 1e 15 00 00       	call   80185d <sys_cputs>
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
  8003b1:	e8 a7 14 00 00       	call   80185d <sys_cputs>
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
  8003fb:	e8 9f 14 00 00       	call   80189f <sys_lock_cons>
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
  80041b:	e8 99 14 00 00       	call   8018b9 <sys_unlock_cons>
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
  800465:	e8 b2 36 00 00       	call   803b1c <__udivdi3>
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
  8004b5:	e8 72 37 00 00       	call   803c2c <__umoddi3>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	05 b4 40 80 00       	add    $0x8040b4,%eax
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
  800610:	8b 04 85 d8 40 80 00 	mov    0x8040d8(,%eax,4),%eax
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
  8006f1:	8b 34 9d 20 3f 80 00 	mov    0x803f20(,%ebx,4),%esi
  8006f8:	85 f6                	test   %esi,%esi
  8006fa:	75 19                	jne    800715 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006fc:	53                   	push   %ebx
  8006fd:	68 c5 40 80 00       	push   $0x8040c5
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
  800716:	68 ce 40 80 00       	push   $0x8040ce
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
  800743:	be d1 40 80 00       	mov    $0x8040d1,%esi
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
  800a6e:	68 48 42 80 00       	push   $0x804248
  800a73:	e8 50 f9 ff ff       	call   8003c8 <cprintf>
  800a78:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a82:	83 ec 0c             	sub    $0xc,%esp
  800a85:	6a 00                	push   $0x0
  800a87:	e8 9a 2e 00 00       	call   803926 <iscons>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a92:	e8 7c 2e 00 00       	call   803913 <getchar>
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
  800ab0:	68 4b 42 80 00       	push   $0x80424b
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
  800add:	e8 12 2e 00 00       	call   8038f4 <cputchar>
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
  800b14:	e8 db 2d 00 00       	call   8038f4 <cputchar>
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
  800b3d:	e8 b2 2d 00 00       	call   8038f4 <cputchar>
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
  800b61:	e8 39 0d 00 00       	call   80189f <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6a:	74 13                	je     800b7f <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	68 48 42 80 00       	push   $0x804248
  800b77:	e8 4c f8 ff ff       	call   8003c8 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	6a 00                	push   $0x0
  800b8b:	e8 96 2d 00 00       	call   803926 <iscons>
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b96:	e8 78 2d 00 00       	call   803913 <getchar>
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
  800bb4:	68 4b 42 80 00       	push   $0x80424b
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
  800be1:	e8 0e 2d 00 00       	call   8038f4 <cputchar>
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
  800c18:	e8 d7 2c 00 00       	call   8038f4 <cputchar>
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
  800c41:	e8 ae 2c 00 00       	call   8038f4 <cputchar>
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
  800c5c:	e8 58 0c 00 00       	call   8018b9 <sys_unlock_cons>
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
  801356:	68 5c 42 80 00       	push   $0x80425c
  80135b:	68 3f 01 00 00       	push   $0x13f
  801360:	68 7e 42 80 00       	push   $0x80427e
  801365:	e8 c6 25 00 00       	call   803930 <_panic>

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
  801376:	e8 8d 0a 00 00       	call   801e08 <sys_sbrk>
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
  8013f1:	e8 96 08 00 00       	call   801c8c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	74 16                	je     801410 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 d6 0d 00 00       	call   8021db <alloc_block_FF>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80140b:	e9 8a 01 00 00       	jmp    80159a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801410:	e8 a8 08 00 00       	call   801cbd <sys_isUHeapPlacementStrategyBESTFIT>
  801415:	85 c0                	test   %eax,%eax
  801417:	0f 84 7d 01 00 00    	je     80159a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80141d:	83 ec 0c             	sub    $0xc,%esp
  801420:	ff 75 08             	pushl  0x8(%ebp)
  801423:	e8 6f 12 00 00       	call   802697 <alloc_block_BF>
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
  801589:	e8 b1 08 00 00       	call   801e3f <sys_allocate_user_mem>
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
  8015d1:	e8 85 08 00 00       	call   801e5b <get_block_size>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	ff 75 08             	pushl  0x8(%ebp)
  8015e2:	e8 b8 1a 00 00       	call   80309f <free_block>
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
  801679:	e8 a5 07 00 00       	call   801e23 <sys_free_user_mem>
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
  801687:	68 8c 42 80 00       	push   $0x80428c
  80168c:	68 84 00 00 00       	push   $0x84
  801691:	68 b6 42 80 00       	push   $0x8042b6
  801696:	e8 95 22 00 00       	call   803930 <_panic>
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
  8016b4:	eb 64                	jmp    80171a <smalloc+0x7d>
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
  8016e9:	eb 2f                	jmp    80171a <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8016eb:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8016f2:	50                   	push   %eax
  8016f3:	ff 75 0c             	pushl  0xc(%ebp)
  8016f6:	ff 75 08             	pushl  0x8(%ebp)
  8016f9:	e8 2c 03 00 00       	call   801a2a <sys_createSharedObject>
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801704:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801708:	74 06                	je     801710 <smalloc+0x73>
  80170a:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80170e:	75 07                	jne    801717 <smalloc+0x7a>
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
  801715:	eb 03                	jmp    80171a <smalloc+0x7d>
	 return ptr;
  801717:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801722:	83 ec 08             	sub    $0x8,%esp
  801725:	ff 75 0c             	pushl  0xc(%ebp)
  801728:	ff 75 08             	pushl  0x8(%ebp)
  80172b:	e8 24 03 00 00       	call   801a54 <sys_getSizeOfSharedObject>
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801736:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80173a:	75 07                	jne    801743 <sget+0x27>
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
  801741:	eb 5c                	jmp    80179f <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801746:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801749:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801750:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801756:	39 d0                	cmp    %edx,%eax
  801758:	7d 02                	jge    80175c <sget+0x40>
  80175a:	89 d0                	mov    %edx,%eax
  80175c:	83 ec 0c             	sub    $0xc,%esp
  80175f:	50                   	push   %eax
  801760:	e8 1b fc ff ff       	call   801380 <malloc>
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80176b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80176f:	75 07                	jne    801778 <sget+0x5c>
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	eb 27                	jmp    80179f <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	ff 75 e8             	pushl  -0x18(%ebp)
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	e8 e8 02 00 00       	call   801a71 <sys_getSharedObject>
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80178f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801793:	75 07                	jne    80179c <sget+0x80>
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
  80179a:	eb 03                	jmp    80179f <sget+0x83>
	return ptr;
  80179c:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	68 c4 42 80 00       	push   $0x8042c4
  8017af:	68 c1 00 00 00       	push   $0xc1
  8017b4:	68 b6 42 80 00       	push   $0x8042b6
  8017b9:	e8 72 21 00 00       	call   803930 <_panic>

008017be <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	68 e8 42 80 00       	push   $0x8042e8
  8017cc:	68 d8 00 00 00       	push   $0xd8
  8017d1:	68 b6 42 80 00       	push   $0x8042b6
  8017d6:	e8 55 21 00 00       	call   803930 <_panic>

008017db <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	68 0e 43 80 00       	push   $0x80430e
  8017e9:	68 e4 00 00 00       	push   $0xe4
  8017ee:	68 b6 42 80 00       	push   $0x8042b6
  8017f3:	e8 38 21 00 00       	call   803930 <_panic>

008017f8 <shrink>:

}
void shrink(uint32 newSize)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017fe:	83 ec 04             	sub    $0x4,%esp
  801801:	68 0e 43 80 00       	push   $0x80430e
  801806:	68 e9 00 00 00       	push   $0xe9
  80180b:	68 b6 42 80 00       	push   $0x8042b6
  801810:	e8 1b 21 00 00       	call   803930 <_panic>

00801815 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	68 0e 43 80 00       	push   $0x80430e
  801823:	68 ee 00 00 00       	push   $0xee
  801828:	68 b6 42 80 00       	push   $0x8042b6
  80182d:	e8 fe 20 00 00       	call   803930 <_panic>

00801832 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	57                   	push   %edi
  801836:	56                   	push   %esi
  801837:	53                   	push   %ebx
  801838:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801841:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801844:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801847:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80184d:	cd 30                	int    $0x30
  80184f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801852:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	5b                   	pop    %ebx
  801859:	5e                   	pop    %esi
  80185a:	5f                   	pop    %edi
  80185b:	5d                   	pop    %ebp
  80185c:	c3                   	ret    

0080185d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	8b 45 10             	mov    0x10(%ebp),%eax
  801866:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801869:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	52                   	push   %edx
  801875:	ff 75 0c             	pushl  0xc(%ebp)
  801878:	50                   	push   %eax
  801879:	6a 00                	push   $0x0
  80187b:	e8 b2 ff ff ff       	call   801832 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	90                   	nop
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_cgetc>:

int
sys_cgetc(void)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 02                	push   $0x2
  801895:	e8 98 ff ff ff       	call   801832 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 03                	push   $0x3
  8018ae:	e8 7f ff ff ff       	call   801832 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	90                   	nop
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 04                	push   $0x4
  8018c8:	e8 65 ff ff ff       	call   801832 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	90                   	nop
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	52                   	push   %edx
  8018e3:	50                   	push   %eax
  8018e4:	6a 08                	push   $0x8
  8018e6:	e8 47 ff ff ff       	call   801832 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	56                   	push   %esi
  8018f4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018f5:	8b 75 18             	mov    0x18(%ebp),%esi
  8018f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	56                   	push   %esi
  801905:	53                   	push   %ebx
  801906:	51                   	push   %ecx
  801907:	52                   	push   %edx
  801908:	50                   	push   %eax
  801909:	6a 09                	push   $0x9
  80190b:	e8 22 ff ff ff       	call   801832 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801916:	5b                   	pop    %ebx
  801917:	5e                   	pop    %esi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    

0080191a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80191d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	52                   	push   %edx
  80192a:	50                   	push   %eax
  80192b:	6a 0a                	push   $0xa
  80192d:	e8 00 ff ff ff       	call   801832 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	ff 75 0c             	pushl  0xc(%ebp)
  801943:	ff 75 08             	pushl  0x8(%ebp)
  801946:	6a 0b                	push   $0xb
  801948:	e8 e5 fe ff ff       	call   801832 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 0c                	push   $0xc
  801961:	e8 cc fe ff ff       	call   801832 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 0d                	push   $0xd
  80197a:	e8 b3 fe ff ff       	call   801832 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 0e                	push   $0xe
  801993:	e8 9a fe ff ff       	call   801832 <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 0f                	push   $0xf
  8019ac:	e8 81 fe ff ff       	call   801832 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	ff 75 08             	pushl  0x8(%ebp)
  8019c4:	6a 10                	push   $0x10
  8019c6:	e8 67 fe ff ff       	call   801832 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 11                	push   $0x11
  8019df:	e8 4e fe ff ff       	call   801832 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_cputc>:

void
sys_cputc(const char c)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 04             	sub    $0x4,%esp
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	50                   	push   %eax
  801a03:	6a 01                	push   $0x1
  801a05:	e8 28 fe ff ff       	call   801832 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	90                   	nop
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 14                	push   $0x14
  801a1f:	e8 0e fe ff ff       	call   801832 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	8b 45 10             	mov    0x10(%ebp),%eax
  801a33:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a36:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a39:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	6a 00                	push   $0x0
  801a42:	51                   	push   %ecx
  801a43:	52                   	push   %edx
  801a44:	ff 75 0c             	pushl  0xc(%ebp)
  801a47:	50                   	push   %eax
  801a48:	6a 15                	push   $0x15
  801a4a:	e8 e3 fd ff ff       	call   801832 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	52                   	push   %edx
  801a64:	50                   	push   %eax
  801a65:	6a 16                	push   $0x16
  801a67:	e8 c6 fd ff ff       	call   801832 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a74:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	51                   	push   %ecx
  801a82:	52                   	push   %edx
  801a83:	50                   	push   %eax
  801a84:	6a 17                	push   $0x17
  801a86:	e8 a7 fd ff ff       	call   801832 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	52                   	push   %edx
  801aa0:	50                   	push   %eax
  801aa1:	6a 18                	push   $0x18
  801aa3:	e8 8a fd ff ff       	call   801832 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	6a 00                	push   $0x0
  801ab5:	ff 75 14             	pushl  0x14(%ebp)
  801ab8:	ff 75 10             	pushl  0x10(%ebp)
  801abb:	ff 75 0c             	pushl  0xc(%ebp)
  801abe:	50                   	push   %eax
  801abf:	6a 19                	push   $0x19
  801ac1:	e8 6c fd ff ff       	call   801832 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_run_env>:

void sys_run_env(int32 envId)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	50                   	push   %eax
  801ada:	6a 1a                	push   $0x1a
  801adc:	e8 51 fd ff ff       	call   801832 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	90                   	nop
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	50                   	push   %eax
  801af6:	6a 1b                	push   $0x1b
  801af8:	e8 35 fd ff ff       	call   801832 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 05                	push   $0x5
  801b11:	e8 1c fd ff ff       	call   801832 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 06                	push   $0x6
  801b2a:	e8 03 fd ff ff       	call   801832 <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 07                	push   $0x7
  801b43:	e8 ea fc ff ff       	call   801832 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_exit_env>:


void sys_exit_env(void)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 1c                	push   $0x1c
  801b5c:	e8 d1 fc ff ff       	call   801832 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	90                   	nop
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b6d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b70:	8d 50 04             	lea    0x4(%eax),%edx
  801b73:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	52                   	push   %edx
  801b7d:	50                   	push   %eax
  801b7e:	6a 1d                	push   $0x1d
  801b80:	e8 ad fc ff ff       	call   801832 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
	return result;
  801b88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b91:	89 01                	mov    %eax,(%ecx)
  801b93:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	c9                   	leave  
  801b9a:	c2 04 00             	ret    $0x4

00801b9d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	ff 75 10             	pushl  0x10(%ebp)
  801ba7:	ff 75 0c             	pushl  0xc(%ebp)
  801baa:	ff 75 08             	pushl  0x8(%ebp)
  801bad:	6a 13                	push   $0x13
  801baf:	e8 7e fc ff ff       	call   801832 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb7:	90                   	nop
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_rcr2>:
uint32 sys_rcr2()
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 1e                	push   $0x1e
  801bc9:	e8 64 fc ff ff       	call   801832 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 04             	sub    $0x4,%esp
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bdf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	50                   	push   %eax
  801bec:	6a 1f                	push   $0x1f
  801bee:	e8 3f fc ff ff       	call   801832 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf6:	90                   	nop
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <rsttst>:
void rsttst()
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 21                	push   $0x21
  801c08:	e8 25 fc ff ff       	call   801832 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c10:	90                   	nop
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 04             	sub    $0x4,%esp
  801c19:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c1f:	8b 55 18             	mov    0x18(%ebp),%edx
  801c22:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c26:	52                   	push   %edx
  801c27:	50                   	push   %eax
  801c28:	ff 75 10             	pushl  0x10(%ebp)
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	ff 75 08             	pushl  0x8(%ebp)
  801c31:	6a 20                	push   $0x20
  801c33:	e8 fa fb ff ff       	call   801832 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3b:	90                   	nop
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <chktst>:
void chktst(uint32 n)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	ff 75 08             	pushl  0x8(%ebp)
  801c4c:	6a 22                	push   $0x22
  801c4e:	e8 df fb ff ff       	call   801832 <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
	return ;
  801c56:	90                   	nop
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <inctst>:

void inctst()
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 23                	push   $0x23
  801c68:	e8 c5 fb ff ff       	call   801832 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c70:	90                   	nop
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <gettst>:
uint32 gettst()
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 24                	push   $0x24
  801c82:	e8 ab fb ff ff       	call   801832 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 25                	push   $0x25
  801c9e:	e8 8f fb ff ff       	call   801832 <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
  801ca6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ca9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cad:	75 07                	jne    801cb6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801caf:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb4:	eb 05                	jmp    801cbb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 25                	push   $0x25
  801ccf:	e8 5e fb ff ff       	call   801832 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
  801cd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cda:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cde:	75 07                	jne    801ce7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ce0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce5:	eb 05                	jmp    801cec <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 25                	push   $0x25
  801d00:	e8 2d fb ff ff       	call   801832 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
  801d08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d0b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d0f:	75 07                	jne    801d18 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d11:	b8 01 00 00 00       	mov    $0x1,%eax
  801d16:	eb 05                	jmp    801d1d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 25                	push   $0x25
  801d31:	e8 fc fa ff ff       	call   801832 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
  801d39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d3c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d40:	75 07                	jne    801d49 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d42:	b8 01 00 00 00       	mov    $0x1,%eax
  801d47:	eb 05                	jmp    801d4e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	ff 75 08             	pushl  0x8(%ebp)
  801d5e:	6a 26                	push   $0x26
  801d60:	e8 cd fa ff ff       	call   801832 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
	return ;
  801d68:	90                   	nop
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	6a 00                	push   $0x0
  801d7d:	53                   	push   %ebx
  801d7e:	51                   	push   %ecx
  801d7f:	52                   	push   %edx
  801d80:	50                   	push   %eax
  801d81:	6a 27                	push   $0x27
  801d83:	e8 aa fa ff ff       	call   801832 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
}
  801d8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	52                   	push   %edx
  801da0:	50                   	push   %eax
  801da1:	6a 28                	push   $0x28
  801da3:	e8 8a fa ff ff       	call   801832 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801db0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801db3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	6a 00                	push   $0x0
  801dbb:	51                   	push   %ecx
  801dbc:	ff 75 10             	pushl  0x10(%ebp)
  801dbf:	52                   	push   %edx
  801dc0:	50                   	push   %eax
  801dc1:	6a 29                	push   $0x29
  801dc3:	e8 6a fa ff ff       	call   801832 <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	ff 75 10             	pushl  0x10(%ebp)
  801dd7:	ff 75 0c             	pushl  0xc(%ebp)
  801dda:	ff 75 08             	pushl  0x8(%ebp)
  801ddd:	6a 12                	push   $0x12
  801ddf:	e8 4e fa ff ff       	call   801832 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
	return ;
  801de7:	90                   	nop
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801ded:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	52                   	push   %edx
  801dfa:	50                   	push   %eax
  801dfb:	6a 2a                	push   $0x2a
  801dfd:	e8 30 fa ff ff       	call   801832 <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
	return;
  801e05:	90                   	nop
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	50                   	push   %eax
  801e17:	6a 2b                	push   $0x2b
  801e19:	e8 14 fa ff ff       	call   801832 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	ff 75 0c             	pushl  0xc(%ebp)
  801e2f:	ff 75 08             	pushl  0x8(%ebp)
  801e32:	6a 2c                	push   $0x2c
  801e34:	e8 f9 f9 ff ff       	call   801832 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
	return;
  801e3c:	90                   	nop
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	ff 75 0c             	pushl  0xc(%ebp)
  801e4b:	ff 75 08             	pushl  0x8(%ebp)
  801e4e:	6a 2d                	push   $0x2d
  801e50:	e8 dd f9 ff ff       	call   801832 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
	return;
  801e58:	90                   	nop
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	83 e8 04             	sub    $0x4,%eax
  801e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e6d:	8b 00                	mov    (%eax),%eax
  801e6f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7d:	83 e8 04             	sub    $0x4,%eax
  801e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e86:	8b 00                	mov    (%eax),%eax
  801e88:	83 e0 01             	and    $0x1,%eax
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	0f 94 c0             	sete   %al
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea2:	83 f8 02             	cmp    $0x2,%eax
  801ea5:	74 2b                	je     801ed2 <alloc_block+0x40>
  801ea7:	83 f8 02             	cmp    $0x2,%eax
  801eaa:	7f 07                	jg     801eb3 <alloc_block+0x21>
  801eac:	83 f8 01             	cmp    $0x1,%eax
  801eaf:	74 0e                	je     801ebf <alloc_block+0x2d>
  801eb1:	eb 58                	jmp    801f0b <alloc_block+0x79>
  801eb3:	83 f8 03             	cmp    $0x3,%eax
  801eb6:	74 2d                	je     801ee5 <alloc_block+0x53>
  801eb8:	83 f8 04             	cmp    $0x4,%eax
  801ebb:	74 3b                	je     801ef8 <alloc_block+0x66>
  801ebd:	eb 4c                	jmp    801f0b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801ebf:	83 ec 0c             	sub    $0xc,%esp
  801ec2:	ff 75 08             	pushl  0x8(%ebp)
  801ec5:	e8 11 03 00 00       	call   8021db <alloc_block_FF>
  801eca:	83 c4 10             	add    $0x10,%esp
  801ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ed0:	eb 4a                	jmp    801f1c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801ed2:	83 ec 0c             	sub    $0xc,%esp
  801ed5:	ff 75 08             	pushl  0x8(%ebp)
  801ed8:	e8 fa 19 00 00       	call   8038d7 <alloc_block_NF>
  801edd:	83 c4 10             	add    $0x10,%esp
  801ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ee3:	eb 37                	jmp    801f1c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ee5:	83 ec 0c             	sub    $0xc,%esp
  801ee8:	ff 75 08             	pushl  0x8(%ebp)
  801eeb:	e8 a7 07 00 00       	call   802697 <alloc_block_BF>
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ef6:	eb 24                	jmp    801f1c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ef8:	83 ec 0c             	sub    $0xc,%esp
  801efb:	ff 75 08             	pushl  0x8(%ebp)
  801efe:	e8 b7 19 00 00       	call   8038ba <alloc_block_WF>
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f09:	eb 11                	jmp    801f1c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f0b:	83 ec 0c             	sub    $0xc,%esp
  801f0e:	68 20 43 80 00       	push   $0x804320
  801f13:	e8 b0 e4 ff ff       	call   8003c8 <cprintf>
  801f18:	83 c4 10             	add    $0x10,%esp
		break;
  801f1b:	90                   	nop
	}
	return va;
  801f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	53                   	push   %ebx
  801f25:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	68 40 43 80 00       	push   $0x804340
  801f30:	e8 93 e4 ff ff       	call   8003c8 <cprintf>
  801f35:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f38:	83 ec 0c             	sub    $0xc,%esp
  801f3b:	68 6b 43 80 00       	push   $0x80436b
  801f40:	e8 83 e4 ff ff       	call   8003c8 <cprintf>
  801f45:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4e:	eb 37                	jmp    801f87 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	ff 75 f4             	pushl  -0xc(%ebp)
  801f56:	e8 19 ff ff ff       	call   801e74 <is_free_block>
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	0f be d8             	movsbl %al,%ebx
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	ff 75 f4             	pushl  -0xc(%ebp)
  801f67:	e8 ef fe ff ff       	call   801e5b <get_block_size>
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	83 ec 04             	sub    $0x4,%esp
  801f72:	53                   	push   %ebx
  801f73:	50                   	push   %eax
  801f74:	68 83 43 80 00       	push   $0x804383
  801f79:	e8 4a e4 ff ff       	call   8003c8 <cprintf>
  801f7e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f81:	8b 45 10             	mov    0x10(%ebp),%eax
  801f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8b:	74 07                	je     801f94 <print_blocks_list+0x73>
  801f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f90:	8b 00                	mov    (%eax),%eax
  801f92:	eb 05                	jmp    801f99 <print_blocks_list+0x78>
  801f94:	b8 00 00 00 00       	mov    $0x0,%eax
  801f99:	89 45 10             	mov    %eax,0x10(%ebp)
  801f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	75 ad                	jne    801f50 <print_blocks_list+0x2f>
  801fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa7:	75 a7                	jne    801f50 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fa9:	83 ec 0c             	sub    $0xc,%esp
  801fac:	68 40 43 80 00       	push   $0x804340
  801fb1:	e8 12 e4 ff ff       	call   8003c8 <cprintf>
  801fb6:	83 c4 10             	add    $0x10,%esp

}
  801fb9:	90                   	nop
  801fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc8:	83 e0 01             	and    $0x1,%eax
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	74 03                	je     801fd2 <initialize_dynamic_allocator+0x13>
  801fcf:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801fd2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fd6:	0f 84 c7 01 00 00    	je     8021a3 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801fdc:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801fe3:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fec:	01 d0                	add    %edx,%eax
  801fee:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801ff3:	0f 87 ad 01 00 00    	ja     8021a6 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	0f 89 a5 01 00 00    	jns    8021a9 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802004:	8b 55 08             	mov    0x8(%ebp),%edx
  802007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200a:	01 d0                	add    %edx,%eax
  80200c:	83 e8 04             	sub    $0x4,%eax
  80200f:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802014:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  80201b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802020:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802023:	e9 87 00 00 00       	jmp    8020af <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802028:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202c:	75 14                	jne    802042 <initialize_dynamic_allocator+0x83>
  80202e:	83 ec 04             	sub    $0x4,%esp
  802031:	68 9b 43 80 00       	push   $0x80439b
  802036:	6a 79                	push   $0x79
  802038:	68 b9 43 80 00       	push   $0x8043b9
  80203d:	e8 ee 18 00 00       	call   803930 <_panic>
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	8b 00                	mov    (%eax),%eax
  802047:	85 c0                	test   %eax,%eax
  802049:	74 10                	je     80205b <initialize_dynamic_allocator+0x9c>
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	8b 00                	mov    (%eax),%eax
  802050:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802053:	8b 52 04             	mov    0x4(%edx),%edx
  802056:	89 50 04             	mov    %edx,0x4(%eax)
  802059:	eb 0b                	jmp    802066 <initialize_dynamic_allocator+0xa7>
  80205b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205e:	8b 40 04             	mov    0x4(%eax),%eax
  802061:	a3 30 50 80 00       	mov    %eax,0x805030
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	8b 40 04             	mov    0x4(%eax),%eax
  80206c:	85 c0                	test   %eax,%eax
  80206e:	74 0f                	je     80207f <initialize_dynamic_allocator+0xc0>
  802070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802073:	8b 40 04             	mov    0x4(%eax),%eax
  802076:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802079:	8b 12                	mov    (%edx),%edx
  80207b:	89 10                	mov    %edx,(%eax)
  80207d:	eb 0a                	jmp    802089 <initialize_dynamic_allocator+0xca>
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	8b 00                	mov    (%eax),%eax
  802084:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80209c:	a1 38 50 80 00       	mov    0x805038,%eax
  8020a1:	48                   	dec    %eax
  8020a2:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8020a7:	a1 34 50 80 00       	mov    0x805034,%eax
  8020ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b3:	74 07                	je     8020bc <initialize_dynamic_allocator+0xfd>
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	8b 00                	mov    (%eax),%eax
  8020ba:	eb 05                	jmp    8020c1 <initialize_dynamic_allocator+0x102>
  8020bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c1:	a3 34 50 80 00       	mov    %eax,0x805034
  8020c6:	a1 34 50 80 00       	mov    0x805034,%eax
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	0f 85 55 ff ff ff    	jne    802028 <initialize_dynamic_allocator+0x69>
  8020d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d7:	0f 85 4b ff ff ff    	jne    802028 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8020e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8020ec:	a1 44 50 80 00       	mov    0x805044,%eax
  8020f1:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8020f6:	a1 40 50 80 00       	mov    0x805040,%eax
  8020fb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	83 c0 08             	add    $0x8,%eax
  802107:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	83 c0 04             	add    $0x4,%eax
  802110:	8b 55 0c             	mov    0xc(%ebp),%edx
  802113:	83 ea 08             	sub    $0x8,%edx
  802116:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802118:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	01 d0                	add    %edx,%eax
  802120:	83 e8 08             	sub    $0x8,%eax
  802123:	8b 55 0c             	mov    0xc(%ebp),%edx
  802126:	83 ea 08             	sub    $0x8,%edx
  802129:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  80212b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802137:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  80213e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802142:	75 17                	jne    80215b <initialize_dynamic_allocator+0x19c>
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	68 d4 43 80 00       	push   $0x8043d4
  80214c:	68 90 00 00 00       	push   $0x90
  802151:	68 b9 43 80 00       	push   $0x8043b9
  802156:	e8 d5 17 00 00       	call   803930 <_panic>
  80215b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802161:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802164:	89 10                	mov    %edx,(%eax)
  802166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802169:	8b 00                	mov    (%eax),%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	74 0d                	je     80217c <initialize_dynamic_allocator+0x1bd>
  80216f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802174:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802177:	89 50 04             	mov    %edx,0x4(%eax)
  80217a:	eb 08                	jmp    802184 <initialize_dynamic_allocator+0x1c5>
  80217c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217f:	a3 30 50 80 00       	mov    %eax,0x805030
  802184:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802187:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80218c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802196:	a1 38 50 80 00       	mov    0x805038,%eax
  80219b:	40                   	inc    %eax
  80219c:	a3 38 50 80 00       	mov    %eax,0x805038
  8021a1:	eb 07                	jmp    8021aa <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8021a3:	90                   	nop
  8021a4:	eb 04                	jmp    8021aa <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8021a6:	90                   	nop
  8021a7:	eb 01                	jmp    8021aa <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8021a9:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8021af:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b2:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8021bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021be:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	83 e8 04             	sub    $0x4,%eax
  8021c6:	8b 00                	mov    (%eax),%eax
  8021c8:	83 e0 fe             	and    $0xfffffffe,%eax
  8021cb:	8d 50 f8             	lea    -0x8(%eax),%edx
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	01 c2                	add    %eax,%edx
  8021d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d6:	89 02                	mov    %eax,(%edx)
}
  8021d8:	90                   	nop
  8021d9:	5d                   	pop    %ebp
  8021da:	c3                   	ret    

008021db <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	83 e0 01             	and    $0x1,%eax
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	74 03                	je     8021ee <alloc_block_FF+0x13>
  8021eb:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8021ee:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8021f2:	77 07                	ja     8021fb <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8021f4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021fb:	a1 24 50 80 00       	mov    0x805024,%eax
  802200:	85 c0                	test   %eax,%eax
  802202:	75 73                	jne    802277 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	83 c0 10             	add    $0x10,%eax
  80220a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80220d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802214:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221a:	01 d0                	add    %edx,%eax
  80221c:	48                   	dec    %eax
  80221d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802223:	ba 00 00 00 00       	mov    $0x0,%edx
  802228:	f7 75 ec             	divl   -0x14(%ebp)
  80222b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80222e:	29 d0                	sub    %edx,%eax
  802230:	c1 e8 0c             	shr    $0xc,%eax
  802233:	83 ec 0c             	sub    $0xc,%esp
  802236:	50                   	push   %eax
  802237:	e8 2e f1 ff ff       	call   80136a <sbrk>
  80223c:	83 c4 10             	add    $0x10,%esp
  80223f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802242:	83 ec 0c             	sub    $0xc,%esp
  802245:	6a 00                	push   $0x0
  802247:	e8 1e f1 ff ff       	call   80136a <sbrk>
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802252:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802255:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802258:	83 ec 08             	sub    $0x8,%esp
  80225b:	50                   	push   %eax
  80225c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80225f:	e8 5b fd ff ff       	call   801fbf <initialize_dynamic_allocator>
  802264:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802267:	83 ec 0c             	sub    $0xc,%esp
  80226a:	68 f7 43 80 00       	push   $0x8043f7
  80226f:	e8 54 e1 ff ff       	call   8003c8 <cprintf>
  802274:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802277:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80227b:	75 0a                	jne    802287 <alloc_block_FF+0xac>
	        return NULL;
  80227d:	b8 00 00 00 00       	mov    $0x0,%eax
  802282:	e9 0e 04 00 00       	jmp    802695 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802287:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80228e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802296:	e9 f3 02 00 00       	jmp    80258e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022a1:	83 ec 0c             	sub    $0xc,%esp
  8022a4:	ff 75 bc             	pushl  -0x44(%ebp)
  8022a7:	e8 af fb ff ff       	call   801e5b <get_block_size>
  8022ac:	83 c4 10             	add    $0x10,%esp
  8022af:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	83 c0 08             	add    $0x8,%eax
  8022b8:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022bb:	0f 87 c5 02 00 00    	ja     802586 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	83 c0 18             	add    $0x18,%eax
  8022c7:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8022ca:	0f 87 19 02 00 00    	ja     8024e9 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8022d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022d3:	2b 45 08             	sub    0x8(%ebp),%eax
  8022d6:	83 e8 08             	sub    $0x8,%eax
  8022d9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	8d 50 08             	lea    0x8(%eax),%edx
  8022e2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022e5:	01 d0                	add    %edx,%eax
  8022e7:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	83 c0 08             	add    $0x8,%eax
  8022f0:	83 ec 04             	sub    $0x4,%esp
  8022f3:	6a 01                	push   $0x1
  8022f5:	50                   	push   %eax
  8022f6:	ff 75 bc             	pushl  -0x44(%ebp)
  8022f9:	e8 ae fe ff ff       	call   8021ac <set_block_data>
  8022fe:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 40 04             	mov    0x4(%eax),%eax
  802307:	85 c0                	test   %eax,%eax
  802309:	75 68                	jne    802373 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80230b:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80230f:	75 17                	jne    802328 <alloc_block_FF+0x14d>
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	68 d4 43 80 00       	push   $0x8043d4
  802319:	68 d7 00 00 00       	push   $0xd7
  80231e:	68 b9 43 80 00       	push   $0x8043b9
  802323:	e8 08 16 00 00       	call   803930 <_panic>
  802328:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80232e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802331:	89 10                	mov    %edx,(%eax)
  802333:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802336:	8b 00                	mov    (%eax),%eax
  802338:	85 c0                	test   %eax,%eax
  80233a:	74 0d                	je     802349 <alloc_block_FF+0x16e>
  80233c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802341:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802344:	89 50 04             	mov    %edx,0x4(%eax)
  802347:	eb 08                	jmp    802351 <alloc_block_FF+0x176>
  802349:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234c:	a3 30 50 80 00       	mov    %eax,0x805030
  802351:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802354:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802359:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80235c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802363:	a1 38 50 80 00       	mov    0x805038,%eax
  802368:	40                   	inc    %eax
  802369:	a3 38 50 80 00       	mov    %eax,0x805038
  80236e:	e9 dc 00 00 00       	jmp    80244f <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 00                	mov    (%eax),%eax
  802378:	85 c0                	test   %eax,%eax
  80237a:	75 65                	jne    8023e1 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80237c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802380:	75 17                	jne    802399 <alloc_block_FF+0x1be>
  802382:	83 ec 04             	sub    $0x4,%esp
  802385:	68 08 44 80 00       	push   $0x804408
  80238a:	68 db 00 00 00       	push   $0xdb
  80238f:	68 b9 43 80 00       	push   $0x8043b9
  802394:	e8 97 15 00 00       	call   803930 <_panic>
  802399:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80239f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a2:	89 50 04             	mov    %edx,0x4(%eax)
  8023a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a8:	8b 40 04             	mov    0x4(%eax),%eax
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	74 0c                	je     8023bb <alloc_block_FF+0x1e0>
  8023af:	a1 30 50 80 00       	mov    0x805030,%eax
  8023b4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023b7:	89 10                	mov    %edx,(%eax)
  8023b9:	eb 08                	jmp    8023c3 <alloc_block_FF+0x1e8>
  8023bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023be:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8023cb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8023d9:	40                   	inc    %eax
  8023da:	a3 38 50 80 00       	mov    %eax,0x805038
  8023df:	eb 6e                	jmp    80244f <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8023e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e5:	74 06                	je     8023ed <alloc_block_FF+0x212>
  8023e7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023eb:	75 17                	jne    802404 <alloc_block_FF+0x229>
  8023ed:	83 ec 04             	sub    $0x4,%esp
  8023f0:	68 2c 44 80 00       	push   $0x80442c
  8023f5:	68 df 00 00 00       	push   $0xdf
  8023fa:	68 b9 43 80 00       	push   $0x8043b9
  8023ff:	e8 2c 15 00 00       	call   803930 <_panic>
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 10                	mov    (%eax),%edx
  802409:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240c:	89 10                	mov    %edx,(%eax)
  80240e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802411:	8b 00                	mov    (%eax),%eax
  802413:	85 c0                	test   %eax,%eax
  802415:	74 0b                	je     802422 <alloc_block_FF+0x247>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80241f:	89 50 04             	mov    %edx,0x4(%eax)
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802428:	89 10                	mov    %edx,(%eax)
  80242a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80242d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802430:	89 50 04             	mov    %edx,0x4(%eax)
  802433:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	85 c0                	test   %eax,%eax
  80243a:	75 08                	jne    802444 <alloc_block_FF+0x269>
  80243c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243f:	a3 30 50 80 00       	mov    %eax,0x805030
  802444:	a1 38 50 80 00       	mov    0x805038,%eax
  802449:	40                   	inc    %eax
  80244a:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80244f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802453:	75 17                	jne    80246c <alloc_block_FF+0x291>
  802455:	83 ec 04             	sub    $0x4,%esp
  802458:	68 9b 43 80 00       	push   $0x80439b
  80245d:	68 e1 00 00 00       	push   $0xe1
  802462:	68 b9 43 80 00       	push   $0x8043b9
  802467:	e8 c4 14 00 00       	call   803930 <_panic>
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 00                	mov    (%eax),%eax
  802471:	85 c0                	test   %eax,%eax
  802473:	74 10                	je     802485 <alloc_block_FF+0x2aa>
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 00                	mov    (%eax),%eax
  80247a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247d:	8b 52 04             	mov    0x4(%edx),%edx
  802480:	89 50 04             	mov    %edx,0x4(%eax)
  802483:	eb 0b                	jmp    802490 <alloc_block_FF+0x2b5>
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 40 04             	mov    0x4(%eax),%eax
  80248b:	a3 30 50 80 00       	mov    %eax,0x805030
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 40 04             	mov    0x4(%eax),%eax
  802496:	85 c0                	test   %eax,%eax
  802498:	74 0f                	je     8024a9 <alloc_block_FF+0x2ce>
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 40 04             	mov    0x4(%eax),%eax
  8024a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a3:	8b 12                	mov    (%edx),%edx
  8024a5:	89 10                	mov    %edx,(%eax)
  8024a7:	eb 0a                	jmp    8024b3 <alloc_block_FF+0x2d8>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 00                	mov    (%eax),%eax
  8024ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c6:	a1 38 50 80 00       	mov    0x805038,%eax
  8024cb:	48                   	dec    %eax
  8024cc:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8024d1:	83 ec 04             	sub    $0x4,%esp
  8024d4:	6a 00                	push   $0x0
  8024d6:	ff 75 b4             	pushl  -0x4c(%ebp)
  8024d9:	ff 75 b0             	pushl  -0x50(%ebp)
  8024dc:	e8 cb fc ff ff       	call   8021ac <set_block_data>
  8024e1:	83 c4 10             	add    $0x10,%esp
  8024e4:	e9 95 00 00 00       	jmp    80257e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8024e9:	83 ec 04             	sub    $0x4,%esp
  8024ec:	6a 01                	push   $0x1
  8024ee:	ff 75 b8             	pushl  -0x48(%ebp)
  8024f1:	ff 75 bc             	pushl  -0x44(%ebp)
  8024f4:	e8 b3 fc ff ff       	call   8021ac <set_block_data>
  8024f9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802500:	75 17                	jne    802519 <alloc_block_FF+0x33e>
  802502:	83 ec 04             	sub    $0x4,%esp
  802505:	68 9b 43 80 00       	push   $0x80439b
  80250a:	68 e8 00 00 00       	push   $0xe8
  80250f:	68 b9 43 80 00       	push   $0x8043b9
  802514:	e8 17 14 00 00       	call   803930 <_panic>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	74 10                	je     802532 <alloc_block_FF+0x357>
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 00                	mov    (%eax),%eax
  802527:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252a:	8b 52 04             	mov    0x4(%edx),%edx
  80252d:	89 50 04             	mov    %edx,0x4(%eax)
  802530:	eb 0b                	jmp    80253d <alloc_block_FF+0x362>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 40 04             	mov    0x4(%eax),%eax
  802538:	a3 30 50 80 00       	mov    %eax,0x805030
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	85 c0                	test   %eax,%eax
  802545:	74 0f                	je     802556 <alloc_block_FF+0x37b>
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 40 04             	mov    0x4(%eax),%eax
  80254d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802550:	8b 12                	mov    (%edx),%edx
  802552:	89 10                	mov    %edx,(%eax)
  802554:	eb 0a                	jmp    802560 <alloc_block_FF+0x385>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 00                	mov    (%eax),%eax
  80255b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802573:	a1 38 50 80 00       	mov    0x805038,%eax
  802578:	48                   	dec    %eax
  802579:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80257e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802581:	e9 0f 01 00 00       	jmp    802695 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802586:	a1 34 50 80 00       	mov    0x805034,%eax
  80258b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802592:	74 07                	je     80259b <alloc_block_FF+0x3c0>
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 00                	mov    (%eax),%eax
  802599:	eb 05                	jmp    8025a0 <alloc_block_FF+0x3c5>
  80259b:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a0:	a3 34 50 80 00       	mov    %eax,0x805034
  8025a5:	a1 34 50 80 00       	mov    0x805034,%eax
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	0f 85 e9 fc ff ff    	jne    80229b <alloc_block_FF+0xc0>
  8025b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b6:	0f 85 df fc ff ff    	jne    80229b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8025bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bf:	83 c0 08             	add    $0x8,%eax
  8025c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8025c5:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025d2:	01 d0                	add    %edx,%eax
  8025d4:	48                   	dec    %eax
  8025d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025db:	ba 00 00 00 00       	mov    $0x0,%edx
  8025e0:	f7 75 d8             	divl   -0x28(%ebp)
  8025e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025e6:	29 d0                	sub    %edx,%eax
  8025e8:	c1 e8 0c             	shr    $0xc,%eax
  8025eb:	83 ec 0c             	sub    $0xc,%esp
  8025ee:	50                   	push   %eax
  8025ef:	e8 76 ed ff ff       	call   80136a <sbrk>
  8025f4:	83 c4 10             	add    $0x10,%esp
  8025f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025fa:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025fe:	75 0a                	jne    80260a <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802600:	b8 00 00 00 00       	mov    $0x0,%eax
  802605:	e9 8b 00 00 00       	jmp    802695 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80260a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802614:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802617:	01 d0                	add    %edx,%eax
  802619:	48                   	dec    %eax
  80261a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80261d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802620:	ba 00 00 00 00       	mov    $0x0,%edx
  802625:	f7 75 cc             	divl   -0x34(%ebp)
  802628:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80262b:	29 d0                	sub    %edx,%eax
  80262d:	8d 50 fc             	lea    -0x4(%eax),%edx
  802630:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802633:	01 d0                	add    %edx,%eax
  802635:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80263a:	a1 40 50 80 00       	mov    0x805040,%eax
  80263f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802645:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80264c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80264f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802652:	01 d0                	add    %edx,%eax
  802654:	48                   	dec    %eax
  802655:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802658:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80265b:	ba 00 00 00 00       	mov    $0x0,%edx
  802660:	f7 75 c4             	divl   -0x3c(%ebp)
  802663:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802666:	29 d0                	sub    %edx,%eax
  802668:	83 ec 04             	sub    $0x4,%esp
  80266b:	6a 01                	push   $0x1
  80266d:	50                   	push   %eax
  80266e:	ff 75 d0             	pushl  -0x30(%ebp)
  802671:	e8 36 fb ff ff       	call   8021ac <set_block_data>
  802676:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802679:	83 ec 0c             	sub    $0xc,%esp
  80267c:	ff 75 d0             	pushl  -0x30(%ebp)
  80267f:	e8 1b 0a 00 00       	call   80309f <free_block>
  802684:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802687:	83 ec 0c             	sub    $0xc,%esp
  80268a:	ff 75 08             	pushl  0x8(%ebp)
  80268d:	e8 49 fb ff ff       	call   8021db <alloc_block_FF>
  802692:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802695:	c9                   	leave  
  802696:	c3                   	ret    

00802697 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
  80269a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80269d:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a0:	83 e0 01             	and    $0x1,%eax
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	74 03                	je     8026aa <alloc_block_BF+0x13>
  8026a7:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026aa:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026ae:	77 07                	ja     8026b7 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026b0:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026b7:	a1 24 50 80 00       	mov    0x805024,%eax
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	75 73                	jne    802733 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c3:	83 c0 10             	add    $0x10,%eax
  8026c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026c9:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8026d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d6:	01 d0                	add    %edx,%eax
  8026d8:	48                   	dec    %eax
  8026d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8026dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026df:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e4:	f7 75 e0             	divl   -0x20(%ebp)
  8026e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026ea:	29 d0                	sub    %edx,%eax
  8026ec:	c1 e8 0c             	shr    $0xc,%eax
  8026ef:	83 ec 0c             	sub    $0xc,%esp
  8026f2:	50                   	push   %eax
  8026f3:	e8 72 ec ff ff       	call   80136a <sbrk>
  8026f8:	83 c4 10             	add    $0x10,%esp
  8026fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026fe:	83 ec 0c             	sub    $0xc,%esp
  802701:	6a 00                	push   $0x0
  802703:	e8 62 ec ff ff       	call   80136a <sbrk>
  802708:	83 c4 10             	add    $0x10,%esp
  80270b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80270e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802711:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802714:	83 ec 08             	sub    $0x8,%esp
  802717:	50                   	push   %eax
  802718:	ff 75 d8             	pushl  -0x28(%ebp)
  80271b:	e8 9f f8 ff ff       	call   801fbf <initialize_dynamic_allocator>
  802720:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802723:	83 ec 0c             	sub    $0xc,%esp
  802726:	68 f7 43 80 00       	push   $0x8043f7
  80272b:	e8 98 dc ff ff       	call   8003c8 <cprintf>
  802730:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802733:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80273a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802741:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802748:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80274f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802754:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802757:	e9 1d 01 00 00       	jmp    802879 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802762:	83 ec 0c             	sub    $0xc,%esp
  802765:	ff 75 a8             	pushl  -0x58(%ebp)
  802768:	e8 ee f6 ff ff       	call   801e5b <get_block_size>
  80276d:	83 c4 10             	add    $0x10,%esp
  802770:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	83 c0 08             	add    $0x8,%eax
  802779:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80277c:	0f 87 ef 00 00 00    	ja     802871 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802782:	8b 45 08             	mov    0x8(%ebp),%eax
  802785:	83 c0 18             	add    $0x18,%eax
  802788:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80278b:	77 1d                	ja     8027aa <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80278d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802790:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802793:	0f 86 d8 00 00 00    	jbe    802871 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802799:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80279c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80279f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027a5:	e9 c7 00 00 00       	jmp    802871 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ad:	83 c0 08             	add    $0x8,%eax
  8027b0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027b3:	0f 85 9d 00 00 00    	jne    802856 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8027b9:	83 ec 04             	sub    $0x4,%esp
  8027bc:	6a 01                	push   $0x1
  8027be:	ff 75 a4             	pushl  -0x5c(%ebp)
  8027c1:	ff 75 a8             	pushl  -0x58(%ebp)
  8027c4:	e8 e3 f9 ff ff       	call   8021ac <set_block_data>
  8027c9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8027cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d0:	75 17                	jne    8027e9 <alloc_block_BF+0x152>
  8027d2:	83 ec 04             	sub    $0x4,%esp
  8027d5:	68 9b 43 80 00       	push   $0x80439b
  8027da:	68 2c 01 00 00       	push   $0x12c
  8027df:	68 b9 43 80 00       	push   $0x8043b9
  8027e4:	e8 47 11 00 00       	call   803930 <_panic>
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	74 10                	je     802802 <alloc_block_BF+0x16b>
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fa:	8b 52 04             	mov    0x4(%edx),%edx
  8027fd:	89 50 04             	mov    %edx,0x4(%eax)
  802800:	eb 0b                	jmp    80280d <alloc_block_BF+0x176>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 40 04             	mov    0x4(%eax),%eax
  802808:	a3 30 50 80 00       	mov    %eax,0x805030
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 04             	mov    0x4(%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	74 0f                	je     802826 <alloc_block_BF+0x18f>
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 40 04             	mov    0x4(%eax),%eax
  80281d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802820:	8b 12                	mov    (%edx),%edx
  802822:	89 10                	mov    %edx,(%eax)
  802824:	eb 0a                	jmp    802830 <alloc_block_BF+0x199>
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802843:	a1 38 50 80 00       	mov    0x805038,%eax
  802848:	48                   	dec    %eax
  802849:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  80284e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802851:	e9 24 04 00 00       	jmp    802c7a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802859:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80285c:	76 13                	jbe    802871 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80285e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802865:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802868:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80286b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80286e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802871:	a1 34 50 80 00       	mov    0x805034,%eax
  802876:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287d:	74 07                	je     802886 <alloc_block_BF+0x1ef>
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 00                	mov    (%eax),%eax
  802884:	eb 05                	jmp    80288b <alloc_block_BF+0x1f4>
  802886:	b8 00 00 00 00       	mov    $0x0,%eax
  80288b:	a3 34 50 80 00       	mov    %eax,0x805034
  802890:	a1 34 50 80 00       	mov    0x805034,%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	0f 85 bf fe ff ff    	jne    80275c <alloc_block_BF+0xc5>
  80289d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a1:	0f 85 b5 fe ff ff    	jne    80275c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8028a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ab:	0f 84 26 02 00 00    	je     802ad7 <alloc_block_BF+0x440>
  8028b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028b5:	0f 85 1c 02 00 00    	jne    802ad7 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8028bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028be:	2b 45 08             	sub    0x8(%ebp),%eax
  8028c1:	83 e8 08             	sub    $0x8,%eax
  8028c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ca:	8d 50 08             	lea    0x8(%eax),%edx
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	01 d0                	add    %edx,%eax
  8028d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8028d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d8:	83 c0 08             	add    $0x8,%eax
  8028db:	83 ec 04             	sub    $0x4,%esp
  8028de:	6a 01                	push   $0x1
  8028e0:	50                   	push   %eax
  8028e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8028e4:	e8 c3 f8 ff ff       	call   8021ac <set_block_data>
  8028e9:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8028ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ef:	8b 40 04             	mov    0x4(%eax),%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	75 68                	jne    80295e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028f6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028fa:	75 17                	jne    802913 <alloc_block_BF+0x27c>
  8028fc:	83 ec 04             	sub    $0x4,%esp
  8028ff:	68 d4 43 80 00       	push   $0x8043d4
  802904:	68 45 01 00 00       	push   $0x145
  802909:	68 b9 43 80 00       	push   $0x8043b9
  80290e:	e8 1d 10 00 00       	call   803930 <_panic>
  802913:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802919:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80291c:	89 10                	mov    %edx,(%eax)
  80291e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	74 0d                	je     802934 <alloc_block_BF+0x29d>
  802927:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80292c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80292f:	89 50 04             	mov    %edx,0x4(%eax)
  802932:	eb 08                	jmp    80293c <alloc_block_BF+0x2a5>
  802934:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802937:	a3 30 50 80 00       	mov    %eax,0x805030
  80293c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80293f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802944:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802947:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294e:	a1 38 50 80 00       	mov    0x805038,%eax
  802953:	40                   	inc    %eax
  802954:	a3 38 50 80 00       	mov    %eax,0x805038
  802959:	e9 dc 00 00 00       	jmp    802a3a <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80295e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	85 c0                	test   %eax,%eax
  802965:	75 65                	jne    8029cc <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802967:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80296b:	75 17                	jne    802984 <alloc_block_BF+0x2ed>
  80296d:	83 ec 04             	sub    $0x4,%esp
  802970:	68 08 44 80 00       	push   $0x804408
  802975:	68 4a 01 00 00       	push   $0x14a
  80297a:	68 b9 43 80 00       	push   $0x8043b9
  80297f:	e8 ac 0f 00 00       	call   803930 <_panic>
  802984:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80298a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80298d:	89 50 04             	mov    %edx,0x4(%eax)
  802990:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802993:	8b 40 04             	mov    0x4(%eax),%eax
  802996:	85 c0                	test   %eax,%eax
  802998:	74 0c                	je     8029a6 <alloc_block_BF+0x30f>
  80299a:	a1 30 50 80 00       	mov    0x805030,%eax
  80299f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029a2:	89 10                	mov    %edx,(%eax)
  8029a4:	eb 08                	jmp    8029ae <alloc_block_BF+0x317>
  8029a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b1:	a3 30 50 80 00       	mov    %eax,0x805030
  8029b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bf:	a1 38 50 80 00       	mov    0x805038,%eax
  8029c4:	40                   	inc    %eax
  8029c5:	a3 38 50 80 00       	mov    %eax,0x805038
  8029ca:	eb 6e                	jmp    802a3a <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8029cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029d0:	74 06                	je     8029d8 <alloc_block_BF+0x341>
  8029d2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029d6:	75 17                	jne    8029ef <alloc_block_BF+0x358>
  8029d8:	83 ec 04             	sub    $0x4,%esp
  8029db:	68 2c 44 80 00       	push   $0x80442c
  8029e0:	68 4f 01 00 00       	push   $0x14f
  8029e5:	68 b9 43 80 00       	push   $0x8043b9
  8029ea:	e8 41 0f 00 00       	call   803930 <_panic>
  8029ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f2:	8b 10                	mov    (%eax),%edx
  8029f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f7:	89 10                	mov    %edx,(%eax)
  8029f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	74 0b                	je     802a0d <alloc_block_BF+0x376>
  802a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a0a:	89 50 04             	mov    %edx,0x4(%eax)
  802a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a10:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a13:	89 10                	mov    %edx,(%eax)
  802a15:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1b:	89 50 04             	mov    %edx,0x4(%eax)
  802a1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	85 c0                	test   %eax,%eax
  802a25:	75 08                	jne    802a2f <alloc_block_BF+0x398>
  802a27:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a2f:	a1 38 50 80 00       	mov    0x805038,%eax
  802a34:	40                   	inc    %eax
  802a35:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a3e:	75 17                	jne    802a57 <alloc_block_BF+0x3c0>
  802a40:	83 ec 04             	sub    $0x4,%esp
  802a43:	68 9b 43 80 00       	push   $0x80439b
  802a48:	68 51 01 00 00       	push   $0x151
  802a4d:	68 b9 43 80 00       	push   $0x8043b9
  802a52:	e8 d9 0e 00 00       	call   803930 <_panic>
  802a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5a:	8b 00                	mov    (%eax),%eax
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	74 10                	je     802a70 <alloc_block_BF+0x3d9>
  802a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a68:	8b 52 04             	mov    0x4(%edx),%edx
  802a6b:	89 50 04             	mov    %edx,0x4(%eax)
  802a6e:	eb 0b                	jmp    802a7b <alloc_block_BF+0x3e4>
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	8b 40 04             	mov    0x4(%eax),%eax
  802a76:	a3 30 50 80 00       	mov    %eax,0x805030
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	8b 40 04             	mov    0x4(%eax),%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	74 0f                	je     802a94 <alloc_block_BF+0x3fd>
  802a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a88:	8b 40 04             	mov    0x4(%eax),%eax
  802a8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8e:	8b 12                	mov    (%edx),%edx
  802a90:	89 10                	mov    %edx,(%eax)
  802a92:	eb 0a                	jmp    802a9e <alloc_block_BF+0x407>
  802a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a97:	8b 00                	mov    (%eax),%eax
  802a99:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aaa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ab6:	48                   	dec    %eax
  802ab7:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802abc:	83 ec 04             	sub    $0x4,%esp
  802abf:	6a 00                	push   $0x0
  802ac1:	ff 75 d0             	pushl  -0x30(%ebp)
  802ac4:	ff 75 cc             	pushl  -0x34(%ebp)
  802ac7:	e8 e0 f6 ff ff       	call   8021ac <set_block_data>
  802acc:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad2:	e9 a3 01 00 00       	jmp    802c7a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802ad7:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802adb:	0f 85 9d 00 00 00    	jne    802b7e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802ae1:	83 ec 04             	sub    $0x4,%esp
  802ae4:	6a 01                	push   $0x1
  802ae6:	ff 75 ec             	pushl  -0x14(%ebp)
  802ae9:	ff 75 f0             	pushl  -0x10(%ebp)
  802aec:	e8 bb f6 ff ff       	call   8021ac <set_block_data>
  802af1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802af4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802af8:	75 17                	jne    802b11 <alloc_block_BF+0x47a>
  802afa:	83 ec 04             	sub    $0x4,%esp
  802afd:	68 9b 43 80 00       	push   $0x80439b
  802b02:	68 58 01 00 00       	push   $0x158
  802b07:	68 b9 43 80 00       	push   $0x8043b9
  802b0c:	e8 1f 0e 00 00       	call   803930 <_panic>
  802b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 10                	je     802b2a <alloc_block_BF+0x493>
  802b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b22:	8b 52 04             	mov    0x4(%edx),%edx
  802b25:	89 50 04             	mov    %edx,0x4(%eax)
  802b28:	eb 0b                	jmp    802b35 <alloc_block_BF+0x49e>
  802b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2d:	8b 40 04             	mov    0x4(%eax),%eax
  802b30:	a3 30 50 80 00       	mov    %eax,0x805030
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	8b 40 04             	mov    0x4(%eax),%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	74 0f                	je     802b4e <alloc_block_BF+0x4b7>
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	8b 40 04             	mov    0x4(%eax),%eax
  802b45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b48:	8b 12                	mov    (%edx),%edx
  802b4a:	89 10                	mov    %edx,(%eax)
  802b4c:	eb 0a                	jmp    802b58 <alloc_block_BF+0x4c1>
  802b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6b:	a1 38 50 80 00       	mov    0x805038,%eax
  802b70:	48                   	dec    %eax
  802b71:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b79:	e9 fc 00 00 00       	jmp    802c7a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	83 c0 08             	add    $0x8,%eax
  802b84:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b87:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b8e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b91:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b94:	01 d0                	add    %edx,%eax
  802b96:	48                   	dec    %eax
  802b97:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b9a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba2:	f7 75 c4             	divl   -0x3c(%ebp)
  802ba5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ba8:	29 d0                	sub    %edx,%eax
  802baa:	c1 e8 0c             	shr    $0xc,%eax
  802bad:	83 ec 0c             	sub    $0xc,%esp
  802bb0:	50                   	push   %eax
  802bb1:	e8 b4 e7 ff ff       	call   80136a <sbrk>
  802bb6:	83 c4 10             	add    $0x10,%esp
  802bb9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802bbc:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802bc0:	75 0a                	jne    802bcc <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc7:	e9 ae 00 00 00       	jmp    802c7a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802bcc:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802bd3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bd6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802bd9:	01 d0                	add    %edx,%eax
  802bdb:	48                   	dec    %eax
  802bdc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802bdf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802be2:	ba 00 00 00 00       	mov    $0x0,%edx
  802be7:	f7 75 b8             	divl   -0x48(%ebp)
  802bea:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802bed:	29 d0                	sub    %edx,%eax
  802bef:	8d 50 fc             	lea    -0x4(%eax),%edx
  802bf2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802bf5:	01 d0                	add    %edx,%eax
  802bf7:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802bfc:	a1 40 50 80 00       	mov    0x805040,%eax
  802c01:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c07:	83 ec 0c             	sub    $0xc,%esp
  802c0a:	68 60 44 80 00       	push   $0x804460
  802c0f:	e8 b4 d7 ff ff       	call   8003c8 <cprintf>
  802c14:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c17:	83 ec 08             	sub    $0x8,%esp
  802c1a:	ff 75 bc             	pushl  -0x44(%ebp)
  802c1d:	68 65 44 80 00       	push   $0x804465
  802c22:	e8 a1 d7 ff ff       	call   8003c8 <cprintf>
  802c27:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c2a:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c31:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c34:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c37:	01 d0                	add    %edx,%eax
  802c39:	48                   	dec    %eax
  802c3a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c3d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c40:	ba 00 00 00 00       	mov    $0x0,%edx
  802c45:	f7 75 b0             	divl   -0x50(%ebp)
  802c48:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c4b:	29 d0                	sub    %edx,%eax
  802c4d:	83 ec 04             	sub    $0x4,%esp
  802c50:	6a 01                	push   $0x1
  802c52:	50                   	push   %eax
  802c53:	ff 75 bc             	pushl  -0x44(%ebp)
  802c56:	e8 51 f5 ff ff       	call   8021ac <set_block_data>
  802c5b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c5e:	83 ec 0c             	sub    $0xc,%esp
  802c61:	ff 75 bc             	pushl  -0x44(%ebp)
  802c64:	e8 36 04 00 00       	call   80309f <free_block>
  802c69:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c6c:	83 ec 0c             	sub    $0xc,%esp
  802c6f:	ff 75 08             	pushl  0x8(%ebp)
  802c72:	e8 20 fa ff ff       	call   802697 <alloc_block_BF>
  802c77:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c7a:	c9                   	leave  
  802c7b:	c3                   	ret    

00802c7c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c7c:	55                   	push   %ebp
  802c7d:	89 e5                	mov    %esp,%ebp
  802c7f:	53                   	push   %ebx
  802c80:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c95:	74 1e                	je     802cb5 <merging+0x39>
  802c97:	ff 75 08             	pushl  0x8(%ebp)
  802c9a:	e8 bc f1 ff ff       	call   801e5b <get_block_size>
  802c9f:	83 c4 04             	add    $0x4,%esp
  802ca2:	89 c2                	mov    %eax,%edx
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	01 d0                	add    %edx,%eax
  802ca9:	3b 45 10             	cmp    0x10(%ebp),%eax
  802cac:	75 07                	jne    802cb5 <merging+0x39>
		prev_is_free = 1;
  802cae:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802cb5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cb9:	74 1e                	je     802cd9 <merging+0x5d>
  802cbb:	ff 75 10             	pushl  0x10(%ebp)
  802cbe:	e8 98 f1 ff ff       	call   801e5b <get_block_size>
  802cc3:	83 c4 04             	add    $0x4,%esp
  802cc6:	89 c2                	mov    %eax,%edx
  802cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  802ccb:	01 d0                	add    %edx,%eax
  802ccd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cd0:	75 07                	jne    802cd9 <merging+0x5d>
		next_is_free = 1;
  802cd2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdd:	0f 84 cc 00 00 00    	je     802daf <merging+0x133>
  802ce3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce7:	0f 84 c2 00 00 00    	je     802daf <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ced:	ff 75 08             	pushl  0x8(%ebp)
  802cf0:	e8 66 f1 ff ff       	call   801e5b <get_block_size>
  802cf5:	83 c4 04             	add    $0x4,%esp
  802cf8:	89 c3                	mov    %eax,%ebx
  802cfa:	ff 75 10             	pushl  0x10(%ebp)
  802cfd:	e8 59 f1 ff ff       	call   801e5b <get_block_size>
  802d02:	83 c4 04             	add    $0x4,%esp
  802d05:	01 c3                	add    %eax,%ebx
  802d07:	ff 75 0c             	pushl  0xc(%ebp)
  802d0a:	e8 4c f1 ff ff       	call   801e5b <get_block_size>
  802d0f:	83 c4 04             	add    $0x4,%esp
  802d12:	01 d8                	add    %ebx,%eax
  802d14:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d17:	6a 00                	push   $0x0
  802d19:	ff 75 ec             	pushl  -0x14(%ebp)
  802d1c:	ff 75 08             	pushl  0x8(%ebp)
  802d1f:	e8 88 f4 ff ff       	call   8021ac <set_block_data>
  802d24:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d2b:	75 17                	jne    802d44 <merging+0xc8>
  802d2d:	83 ec 04             	sub    $0x4,%esp
  802d30:	68 9b 43 80 00       	push   $0x80439b
  802d35:	68 7d 01 00 00       	push   $0x17d
  802d3a:	68 b9 43 80 00       	push   $0x8043b9
  802d3f:	e8 ec 0b 00 00       	call   803930 <_panic>
  802d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d47:	8b 00                	mov    (%eax),%eax
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	74 10                	je     802d5d <merging+0xe1>
  802d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d55:	8b 52 04             	mov    0x4(%edx),%edx
  802d58:	89 50 04             	mov    %edx,0x4(%eax)
  802d5b:	eb 0b                	jmp    802d68 <merging+0xec>
  802d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d60:	8b 40 04             	mov    0x4(%eax),%eax
  802d63:	a3 30 50 80 00       	mov    %eax,0x805030
  802d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6b:	8b 40 04             	mov    0x4(%eax),%eax
  802d6e:	85 c0                	test   %eax,%eax
  802d70:	74 0f                	je     802d81 <merging+0x105>
  802d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d75:	8b 40 04             	mov    0x4(%eax),%eax
  802d78:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d7b:	8b 12                	mov    (%edx),%edx
  802d7d:	89 10                	mov    %edx,(%eax)
  802d7f:	eb 0a                	jmp    802d8b <merging+0x10f>
  802d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d84:	8b 00                	mov    (%eax),%eax
  802d86:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9e:	a1 38 50 80 00       	mov    0x805038,%eax
  802da3:	48                   	dec    %eax
  802da4:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802da9:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802daa:	e9 ea 02 00 00       	jmp    803099 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802daf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db3:	74 3b                	je     802df0 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802db5:	83 ec 0c             	sub    $0xc,%esp
  802db8:	ff 75 08             	pushl  0x8(%ebp)
  802dbb:	e8 9b f0 ff ff       	call   801e5b <get_block_size>
  802dc0:	83 c4 10             	add    $0x10,%esp
  802dc3:	89 c3                	mov    %eax,%ebx
  802dc5:	83 ec 0c             	sub    $0xc,%esp
  802dc8:	ff 75 10             	pushl  0x10(%ebp)
  802dcb:	e8 8b f0 ff ff       	call   801e5b <get_block_size>
  802dd0:	83 c4 10             	add    $0x10,%esp
  802dd3:	01 d8                	add    %ebx,%eax
  802dd5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dd8:	83 ec 04             	sub    $0x4,%esp
  802ddb:	6a 00                	push   $0x0
  802ddd:	ff 75 e8             	pushl  -0x18(%ebp)
  802de0:	ff 75 08             	pushl  0x8(%ebp)
  802de3:	e8 c4 f3 ff ff       	call   8021ac <set_block_data>
  802de8:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802deb:	e9 a9 02 00 00       	jmp    803099 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802df0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df4:	0f 84 2d 01 00 00    	je     802f27 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802dfa:	83 ec 0c             	sub    $0xc,%esp
  802dfd:	ff 75 10             	pushl  0x10(%ebp)
  802e00:	e8 56 f0 ff ff       	call   801e5b <get_block_size>
  802e05:	83 c4 10             	add    $0x10,%esp
  802e08:	89 c3                	mov    %eax,%ebx
  802e0a:	83 ec 0c             	sub    $0xc,%esp
  802e0d:	ff 75 0c             	pushl  0xc(%ebp)
  802e10:	e8 46 f0 ff ff       	call   801e5b <get_block_size>
  802e15:	83 c4 10             	add    $0x10,%esp
  802e18:	01 d8                	add    %ebx,%eax
  802e1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e1d:	83 ec 04             	sub    $0x4,%esp
  802e20:	6a 00                	push   $0x0
  802e22:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e25:	ff 75 10             	pushl  0x10(%ebp)
  802e28:	e8 7f f3 ff ff       	call   8021ac <set_block_data>
  802e2d:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e30:	8b 45 10             	mov    0x10(%ebp),%eax
  802e33:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e3a:	74 06                	je     802e42 <merging+0x1c6>
  802e3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e40:	75 17                	jne    802e59 <merging+0x1dd>
  802e42:	83 ec 04             	sub    $0x4,%esp
  802e45:	68 74 44 80 00       	push   $0x804474
  802e4a:	68 8d 01 00 00       	push   $0x18d
  802e4f:	68 b9 43 80 00       	push   $0x8043b9
  802e54:	e8 d7 0a 00 00       	call   803930 <_panic>
  802e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e5c:	8b 50 04             	mov    0x4(%eax),%edx
  802e5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e62:	89 50 04             	mov    %edx,0x4(%eax)
  802e65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e68:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e6b:	89 10                	mov    %edx,(%eax)
  802e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e70:	8b 40 04             	mov    0x4(%eax),%eax
  802e73:	85 c0                	test   %eax,%eax
  802e75:	74 0d                	je     802e84 <merging+0x208>
  802e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7a:	8b 40 04             	mov    0x4(%eax),%eax
  802e7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e80:	89 10                	mov    %edx,(%eax)
  802e82:	eb 08                	jmp    802e8c <merging+0x210>
  802e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e87:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e92:	89 50 04             	mov    %edx,0x4(%eax)
  802e95:	a1 38 50 80 00       	mov    0x805038,%eax
  802e9a:	40                   	inc    %eax
  802e9b:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802ea0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ea4:	75 17                	jne    802ebd <merging+0x241>
  802ea6:	83 ec 04             	sub    $0x4,%esp
  802ea9:	68 9b 43 80 00       	push   $0x80439b
  802eae:	68 8e 01 00 00       	push   $0x18e
  802eb3:	68 b9 43 80 00       	push   $0x8043b9
  802eb8:	e8 73 0a 00 00       	call   803930 <_panic>
  802ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	74 10                	je     802ed6 <merging+0x25a>
  802ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec9:	8b 00                	mov    (%eax),%eax
  802ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ece:	8b 52 04             	mov    0x4(%edx),%edx
  802ed1:	89 50 04             	mov    %edx,0x4(%eax)
  802ed4:	eb 0b                	jmp    802ee1 <merging+0x265>
  802ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed9:	8b 40 04             	mov    0x4(%eax),%eax
  802edc:	a3 30 50 80 00       	mov    %eax,0x805030
  802ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee4:	8b 40 04             	mov    0x4(%eax),%eax
  802ee7:	85 c0                	test   %eax,%eax
  802ee9:	74 0f                	je     802efa <merging+0x27e>
  802eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eee:	8b 40 04             	mov    0x4(%eax),%eax
  802ef1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ef4:	8b 12                	mov    (%edx),%edx
  802ef6:	89 10                	mov    %edx,(%eax)
  802ef8:	eb 0a                	jmp    802f04 <merging+0x288>
  802efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f17:	a1 38 50 80 00       	mov    0x805038,%eax
  802f1c:	48                   	dec    %eax
  802f1d:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f22:	e9 72 01 00 00       	jmp    803099 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f27:	8b 45 10             	mov    0x10(%ebp),%eax
  802f2a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f31:	74 79                	je     802fac <merging+0x330>
  802f33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f37:	74 73                	je     802fac <merging+0x330>
  802f39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3d:	74 06                	je     802f45 <merging+0x2c9>
  802f3f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f43:	75 17                	jne    802f5c <merging+0x2e0>
  802f45:	83 ec 04             	sub    $0x4,%esp
  802f48:	68 2c 44 80 00       	push   $0x80442c
  802f4d:	68 94 01 00 00       	push   $0x194
  802f52:	68 b9 43 80 00       	push   $0x8043b9
  802f57:	e8 d4 09 00 00       	call   803930 <_panic>
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	8b 10                	mov    (%eax),%edx
  802f61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f64:	89 10                	mov    %edx,(%eax)
  802f66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f69:	8b 00                	mov    (%eax),%eax
  802f6b:	85 c0                	test   %eax,%eax
  802f6d:	74 0b                	je     802f7a <merging+0x2fe>
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f77:	89 50 04             	mov    %edx,0x4(%eax)
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f80:	89 10                	mov    %edx,(%eax)
  802f82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f85:	8b 55 08             	mov    0x8(%ebp),%edx
  802f88:	89 50 04             	mov    %edx,0x4(%eax)
  802f8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	75 08                	jne    802f9c <merging+0x320>
  802f94:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f97:	a3 30 50 80 00       	mov    %eax,0x805030
  802f9c:	a1 38 50 80 00       	mov    0x805038,%eax
  802fa1:	40                   	inc    %eax
  802fa2:	a3 38 50 80 00       	mov    %eax,0x805038
  802fa7:	e9 ce 00 00 00       	jmp    80307a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802fac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb0:	74 65                	je     803017 <merging+0x39b>
  802fb2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fb6:	75 17                	jne    802fcf <merging+0x353>
  802fb8:	83 ec 04             	sub    $0x4,%esp
  802fbb:	68 08 44 80 00       	push   $0x804408
  802fc0:	68 95 01 00 00       	push   $0x195
  802fc5:	68 b9 43 80 00       	push   $0x8043b9
  802fca:	e8 61 09 00 00       	call   803930 <_panic>
  802fcf:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fd5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd8:	89 50 04             	mov    %edx,0x4(%eax)
  802fdb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fde:	8b 40 04             	mov    0x4(%eax),%eax
  802fe1:	85 c0                	test   %eax,%eax
  802fe3:	74 0c                	je     802ff1 <merging+0x375>
  802fe5:	a1 30 50 80 00       	mov    0x805030,%eax
  802fea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fed:	89 10                	mov    %edx,(%eax)
  802fef:	eb 08                	jmp    802ff9 <merging+0x37d>
  802ff1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ff9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ffc:	a3 30 50 80 00       	mov    %eax,0x805030
  803001:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300a:	a1 38 50 80 00       	mov    0x805038,%eax
  80300f:	40                   	inc    %eax
  803010:	a3 38 50 80 00       	mov    %eax,0x805038
  803015:	eb 63                	jmp    80307a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803017:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80301b:	75 17                	jne    803034 <merging+0x3b8>
  80301d:	83 ec 04             	sub    $0x4,%esp
  803020:	68 d4 43 80 00       	push   $0x8043d4
  803025:	68 98 01 00 00       	push   $0x198
  80302a:	68 b9 43 80 00       	push   $0x8043b9
  80302f:	e8 fc 08 00 00       	call   803930 <_panic>
  803034:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80303a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303d:	89 10                	mov    %edx,(%eax)
  80303f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803042:	8b 00                	mov    (%eax),%eax
  803044:	85 c0                	test   %eax,%eax
  803046:	74 0d                	je     803055 <merging+0x3d9>
  803048:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80304d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803050:	89 50 04             	mov    %edx,0x4(%eax)
  803053:	eb 08                	jmp    80305d <merging+0x3e1>
  803055:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803058:	a3 30 50 80 00       	mov    %eax,0x805030
  80305d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803060:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803065:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803068:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306f:	a1 38 50 80 00       	mov    0x805038,%eax
  803074:	40                   	inc    %eax
  803075:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80307a:	83 ec 0c             	sub    $0xc,%esp
  80307d:	ff 75 10             	pushl  0x10(%ebp)
  803080:	e8 d6 ed ff ff       	call   801e5b <get_block_size>
  803085:	83 c4 10             	add    $0x10,%esp
  803088:	83 ec 04             	sub    $0x4,%esp
  80308b:	6a 00                	push   $0x0
  80308d:	50                   	push   %eax
  80308e:	ff 75 10             	pushl  0x10(%ebp)
  803091:	e8 16 f1 ff ff       	call   8021ac <set_block_data>
  803096:	83 c4 10             	add    $0x10,%esp
	}
}
  803099:	90                   	nop
  80309a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80309d:	c9                   	leave  
  80309e:	c3                   	ret    

0080309f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80309f:	55                   	push   %ebp
  8030a0:	89 e5                	mov    %esp,%ebp
  8030a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030aa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030ad:	a1 30 50 80 00       	mov    0x805030,%eax
  8030b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b5:	73 1b                	jae    8030d2 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030b7:	a1 30 50 80 00       	mov    0x805030,%eax
  8030bc:	83 ec 04             	sub    $0x4,%esp
  8030bf:	ff 75 08             	pushl  0x8(%ebp)
  8030c2:	6a 00                	push   $0x0
  8030c4:	50                   	push   %eax
  8030c5:	e8 b2 fb ff ff       	call   802c7c <merging>
  8030ca:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030cd:	e9 8b 00 00 00       	jmp    80315d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8030d2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030da:	76 18                	jbe    8030f4 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8030dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	ff 75 08             	pushl  0x8(%ebp)
  8030e7:	50                   	push   %eax
  8030e8:	6a 00                	push   $0x0
  8030ea:	e8 8d fb ff ff       	call   802c7c <merging>
  8030ef:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030f2:	eb 69                	jmp    80315d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030f4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030fc:	eb 39                	jmp    803137 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	3b 45 08             	cmp    0x8(%ebp),%eax
  803104:	73 29                	jae    80312f <free_block+0x90>
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310e:	76 1f                	jbe    80312f <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	8b 00                	mov    (%eax),%eax
  803115:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803118:	83 ec 04             	sub    $0x4,%esp
  80311b:	ff 75 08             	pushl  0x8(%ebp)
  80311e:	ff 75 f0             	pushl  -0x10(%ebp)
  803121:	ff 75 f4             	pushl  -0xc(%ebp)
  803124:	e8 53 fb ff ff       	call   802c7c <merging>
  803129:	83 c4 10             	add    $0x10,%esp
			break;
  80312c:	90                   	nop
		}
	}
}
  80312d:	eb 2e                	jmp    80315d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80312f:	a1 34 50 80 00       	mov    0x805034,%eax
  803134:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803137:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313b:	74 07                	je     803144 <free_block+0xa5>
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	eb 05                	jmp    803149 <free_block+0xaa>
  803144:	b8 00 00 00 00       	mov    $0x0,%eax
  803149:	a3 34 50 80 00       	mov    %eax,0x805034
  80314e:	a1 34 50 80 00       	mov    0x805034,%eax
  803153:	85 c0                	test   %eax,%eax
  803155:	75 a7                	jne    8030fe <free_block+0x5f>
  803157:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315b:	75 a1                	jne    8030fe <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80315d:	90                   	nop
  80315e:	c9                   	leave  
  80315f:	c3                   	ret    

00803160 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803160:	55                   	push   %ebp
  803161:	89 e5                	mov    %esp,%ebp
  803163:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803166:	ff 75 08             	pushl  0x8(%ebp)
  803169:	e8 ed ec ff ff       	call   801e5b <get_block_size>
  80316e:	83 c4 04             	add    $0x4,%esp
  803171:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80317b:	eb 17                	jmp    803194 <copy_data+0x34>
  80317d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803180:	8b 45 0c             	mov    0xc(%ebp),%eax
  803183:	01 c2                	add    %eax,%edx
  803185:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	01 c8                	add    %ecx,%eax
  80318d:	8a 00                	mov    (%eax),%al
  80318f:	88 02                	mov    %al,(%edx)
  803191:	ff 45 fc             	incl   -0x4(%ebp)
  803194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803197:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80319a:	72 e1                	jb     80317d <copy_data+0x1d>
}
  80319c:	90                   	nop
  80319d:	c9                   	leave  
  80319e:	c3                   	ret    

0080319f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80319f:	55                   	push   %ebp
  8031a0:	89 e5                	mov    %esp,%ebp
  8031a2:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a9:	75 23                	jne    8031ce <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8031ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031af:	74 13                	je     8031c4 <realloc_block_FF+0x25>
  8031b1:	83 ec 0c             	sub    $0xc,%esp
  8031b4:	ff 75 0c             	pushl  0xc(%ebp)
  8031b7:	e8 1f f0 ff ff       	call   8021db <alloc_block_FF>
  8031bc:	83 c4 10             	add    $0x10,%esp
  8031bf:	e9 f4 06 00 00       	jmp    8038b8 <realloc_block_FF+0x719>
		return NULL;
  8031c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c9:	e9 ea 06 00 00       	jmp    8038b8 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8031ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031d2:	75 18                	jne    8031ec <realloc_block_FF+0x4d>
	{
		free_block(va);
  8031d4:	83 ec 0c             	sub    $0xc,%esp
  8031d7:	ff 75 08             	pushl  0x8(%ebp)
  8031da:	e8 c0 fe ff ff       	call   80309f <free_block>
  8031df:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8031e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e7:	e9 cc 06 00 00       	jmp    8038b8 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8031ec:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8031f0:	77 07                	ja     8031f9 <realloc_block_FF+0x5a>
  8031f2:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031fc:	83 e0 01             	and    $0x1,%eax
  8031ff:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803202:	8b 45 0c             	mov    0xc(%ebp),%eax
  803205:	83 c0 08             	add    $0x8,%eax
  803208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80320b:	83 ec 0c             	sub    $0xc,%esp
  80320e:	ff 75 08             	pushl  0x8(%ebp)
  803211:	e8 45 ec ff ff       	call   801e5b <get_block_size>
  803216:	83 c4 10             	add    $0x10,%esp
  803219:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80321c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321f:	83 e8 08             	sub    $0x8,%eax
  803222:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	83 e8 04             	sub    $0x4,%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	83 e0 fe             	and    $0xfffffffe,%eax
  803230:	89 c2                	mov    %eax,%edx
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	01 d0                	add    %edx,%eax
  803237:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80323a:	83 ec 0c             	sub    $0xc,%esp
  80323d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803240:	e8 16 ec ff ff       	call   801e5b <get_block_size>
  803245:	83 c4 10             	add    $0x10,%esp
  803248:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80324b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80324e:	83 e8 08             	sub    $0x8,%eax
  803251:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803254:	8b 45 0c             	mov    0xc(%ebp),%eax
  803257:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80325a:	75 08                	jne    803264 <realloc_block_FF+0xc5>
	{
		 return va;
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	e9 54 06 00 00       	jmp    8038b8 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803264:	8b 45 0c             	mov    0xc(%ebp),%eax
  803267:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80326a:	0f 83 e5 03 00 00    	jae    803655 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803273:	2b 45 0c             	sub    0xc(%ebp),%eax
  803276:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803279:	83 ec 0c             	sub    $0xc,%esp
  80327c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80327f:	e8 f0 eb ff ff       	call   801e74 <is_free_block>
  803284:	83 c4 10             	add    $0x10,%esp
  803287:	84 c0                	test   %al,%al
  803289:	0f 84 3b 01 00 00    	je     8033ca <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80328f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803292:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803295:	01 d0                	add    %edx,%eax
  803297:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80329a:	83 ec 04             	sub    $0x4,%esp
  80329d:	6a 01                	push   $0x1
  80329f:	ff 75 f0             	pushl  -0x10(%ebp)
  8032a2:	ff 75 08             	pushl  0x8(%ebp)
  8032a5:	e8 02 ef ff ff       	call   8021ac <set_block_data>
  8032aa:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	83 e8 04             	sub    $0x4,%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	83 e0 fe             	and    $0xfffffffe,%eax
  8032b8:	89 c2                	mov    %eax,%edx
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	01 d0                	add    %edx,%eax
  8032bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8032c2:	83 ec 04             	sub    $0x4,%esp
  8032c5:	6a 00                	push   $0x0
  8032c7:	ff 75 cc             	pushl  -0x34(%ebp)
  8032ca:	ff 75 c8             	pushl  -0x38(%ebp)
  8032cd:	e8 da ee ff ff       	call   8021ac <set_block_data>
  8032d2:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8032d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032d9:	74 06                	je     8032e1 <realloc_block_FF+0x142>
  8032db:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8032df:	75 17                	jne    8032f8 <realloc_block_FF+0x159>
  8032e1:	83 ec 04             	sub    $0x4,%esp
  8032e4:	68 2c 44 80 00       	push   $0x80442c
  8032e9:	68 f6 01 00 00       	push   $0x1f6
  8032ee:	68 b9 43 80 00       	push   $0x8043b9
  8032f3:	e8 38 06 00 00       	call   803930 <_panic>
  8032f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032fb:	8b 10                	mov    (%eax),%edx
  8032fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803300:	89 10                	mov    %edx,(%eax)
  803302:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803305:	8b 00                	mov    (%eax),%eax
  803307:	85 c0                	test   %eax,%eax
  803309:	74 0b                	je     803316 <realloc_block_FF+0x177>
  80330b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330e:	8b 00                	mov    (%eax),%eax
  803310:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803313:	89 50 04             	mov    %edx,0x4(%eax)
  803316:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803319:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80331c:	89 10                	mov    %edx,(%eax)
  80331e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803321:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803324:	89 50 04             	mov    %edx,0x4(%eax)
  803327:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80332a:	8b 00                	mov    (%eax),%eax
  80332c:	85 c0                	test   %eax,%eax
  80332e:	75 08                	jne    803338 <realloc_block_FF+0x199>
  803330:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803333:	a3 30 50 80 00       	mov    %eax,0x805030
  803338:	a1 38 50 80 00       	mov    0x805038,%eax
  80333d:	40                   	inc    %eax
  80333e:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803343:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803347:	75 17                	jne    803360 <realloc_block_FF+0x1c1>
  803349:	83 ec 04             	sub    $0x4,%esp
  80334c:	68 9b 43 80 00       	push   $0x80439b
  803351:	68 f7 01 00 00       	push   $0x1f7
  803356:	68 b9 43 80 00       	push   $0x8043b9
  80335b:	e8 d0 05 00 00       	call   803930 <_panic>
  803360:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803363:	8b 00                	mov    (%eax),%eax
  803365:	85 c0                	test   %eax,%eax
  803367:	74 10                	je     803379 <realloc_block_FF+0x1da>
  803369:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803371:	8b 52 04             	mov    0x4(%edx),%edx
  803374:	89 50 04             	mov    %edx,0x4(%eax)
  803377:	eb 0b                	jmp    803384 <realloc_block_FF+0x1e5>
  803379:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337c:	8b 40 04             	mov    0x4(%eax),%eax
  80337f:	a3 30 50 80 00       	mov    %eax,0x805030
  803384:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803387:	8b 40 04             	mov    0x4(%eax),%eax
  80338a:	85 c0                	test   %eax,%eax
  80338c:	74 0f                	je     80339d <realloc_block_FF+0x1fe>
  80338e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803391:	8b 40 04             	mov    0x4(%eax),%eax
  803394:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803397:	8b 12                	mov    (%edx),%edx
  803399:	89 10                	mov    %edx,(%eax)
  80339b:	eb 0a                	jmp    8033a7 <realloc_block_FF+0x208>
  80339d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a0:	8b 00                	mov    (%eax),%eax
  8033a2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8033bf:	48                   	dec    %eax
  8033c0:	a3 38 50 80 00       	mov    %eax,0x805038
  8033c5:	e9 83 02 00 00       	jmp    80364d <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8033ca:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8033ce:	0f 86 69 02 00 00    	jbe    80363d <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8033d4:	83 ec 04             	sub    $0x4,%esp
  8033d7:	6a 01                	push   $0x1
  8033d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8033dc:	ff 75 08             	pushl  0x8(%ebp)
  8033df:	e8 c8 ed ff ff       	call   8021ac <set_block_data>
  8033e4:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	83 e8 04             	sub    $0x4,%eax
  8033ed:	8b 00                	mov    (%eax),%eax
  8033ef:	83 e0 fe             	and    $0xfffffffe,%eax
  8033f2:	89 c2                	mov    %eax,%edx
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	01 d0                	add    %edx,%eax
  8033f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033fc:	a1 38 50 80 00       	mov    0x805038,%eax
  803401:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803404:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803408:	75 68                	jne    803472 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80340a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80340e:	75 17                	jne    803427 <realloc_block_FF+0x288>
  803410:	83 ec 04             	sub    $0x4,%esp
  803413:	68 d4 43 80 00       	push   $0x8043d4
  803418:	68 06 02 00 00       	push   $0x206
  80341d:	68 b9 43 80 00       	push   $0x8043b9
  803422:	e8 09 05 00 00       	call   803930 <_panic>
  803427:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80342d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803430:	89 10                	mov    %edx,(%eax)
  803432:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803435:	8b 00                	mov    (%eax),%eax
  803437:	85 c0                	test   %eax,%eax
  803439:	74 0d                	je     803448 <realloc_block_FF+0x2a9>
  80343b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803440:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803443:	89 50 04             	mov    %edx,0x4(%eax)
  803446:	eb 08                	jmp    803450 <realloc_block_FF+0x2b1>
  803448:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344b:	a3 30 50 80 00       	mov    %eax,0x805030
  803450:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803453:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803458:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803462:	a1 38 50 80 00       	mov    0x805038,%eax
  803467:	40                   	inc    %eax
  803468:	a3 38 50 80 00       	mov    %eax,0x805038
  80346d:	e9 b0 01 00 00       	jmp    803622 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803472:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803477:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80347a:	76 68                	jbe    8034e4 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80347c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803480:	75 17                	jne    803499 <realloc_block_FF+0x2fa>
  803482:	83 ec 04             	sub    $0x4,%esp
  803485:	68 d4 43 80 00       	push   $0x8043d4
  80348a:	68 0b 02 00 00       	push   $0x20b
  80348f:	68 b9 43 80 00       	push   $0x8043b9
  803494:	e8 97 04 00 00       	call   803930 <_panic>
  803499:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80349f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a2:	89 10                	mov    %edx,(%eax)
  8034a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a7:	8b 00                	mov    (%eax),%eax
  8034a9:	85 c0                	test   %eax,%eax
  8034ab:	74 0d                	je     8034ba <realloc_block_FF+0x31b>
  8034ad:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034b5:	89 50 04             	mov    %edx,0x4(%eax)
  8034b8:	eb 08                	jmp    8034c2 <realloc_block_FF+0x323>
  8034ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8034c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8034d9:	40                   	inc    %eax
  8034da:	a3 38 50 80 00       	mov    %eax,0x805038
  8034df:	e9 3e 01 00 00       	jmp    803622 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8034e4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034e9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034ec:	73 68                	jae    803556 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034f2:	75 17                	jne    80350b <realloc_block_FF+0x36c>
  8034f4:	83 ec 04             	sub    $0x4,%esp
  8034f7:	68 08 44 80 00       	push   $0x804408
  8034fc:	68 10 02 00 00       	push   $0x210
  803501:	68 b9 43 80 00       	push   $0x8043b9
  803506:	e8 25 04 00 00       	call   803930 <_panic>
  80350b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803511:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803514:	89 50 04             	mov    %edx,0x4(%eax)
  803517:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351a:	8b 40 04             	mov    0x4(%eax),%eax
  80351d:	85 c0                	test   %eax,%eax
  80351f:	74 0c                	je     80352d <realloc_block_FF+0x38e>
  803521:	a1 30 50 80 00       	mov    0x805030,%eax
  803526:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803529:	89 10                	mov    %edx,(%eax)
  80352b:	eb 08                	jmp    803535 <realloc_block_FF+0x396>
  80352d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803530:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803535:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803538:	a3 30 50 80 00       	mov    %eax,0x805030
  80353d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803546:	a1 38 50 80 00       	mov    0x805038,%eax
  80354b:	40                   	inc    %eax
  80354c:	a3 38 50 80 00       	mov    %eax,0x805038
  803551:	e9 cc 00 00 00       	jmp    803622 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80355d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803562:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803565:	e9 8a 00 00 00       	jmp    8035f4 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80356a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803570:	73 7a                	jae    8035ec <realloc_block_FF+0x44d>
  803572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803575:	8b 00                	mov    (%eax),%eax
  803577:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80357a:	73 70                	jae    8035ec <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80357c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803580:	74 06                	je     803588 <realloc_block_FF+0x3e9>
  803582:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803586:	75 17                	jne    80359f <realloc_block_FF+0x400>
  803588:	83 ec 04             	sub    $0x4,%esp
  80358b:	68 2c 44 80 00       	push   $0x80442c
  803590:	68 1a 02 00 00       	push   $0x21a
  803595:	68 b9 43 80 00       	push   $0x8043b9
  80359a:	e8 91 03 00 00       	call   803930 <_panic>
  80359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a2:	8b 10                	mov    (%eax),%edx
  8035a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a7:	89 10                	mov    %edx,(%eax)
  8035a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ac:	8b 00                	mov    (%eax),%eax
  8035ae:	85 c0                	test   %eax,%eax
  8035b0:	74 0b                	je     8035bd <realloc_block_FF+0x41e>
  8035b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b5:	8b 00                	mov    (%eax),%eax
  8035b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035ba:	89 50 04             	mov    %edx,0x4(%eax)
  8035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035c3:	89 10                	mov    %edx,(%eax)
  8035c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035cb:	89 50 04             	mov    %edx,0x4(%eax)
  8035ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035d1:	8b 00                	mov    (%eax),%eax
  8035d3:	85 c0                	test   %eax,%eax
  8035d5:	75 08                	jne    8035df <realloc_block_FF+0x440>
  8035d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035da:	a3 30 50 80 00       	mov    %eax,0x805030
  8035df:	a1 38 50 80 00       	mov    0x805038,%eax
  8035e4:	40                   	inc    %eax
  8035e5:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8035ea:	eb 36                	jmp    803622 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8035ec:	a1 34 50 80 00       	mov    0x805034,%eax
  8035f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f8:	74 07                	je     803601 <realloc_block_FF+0x462>
  8035fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fd:	8b 00                	mov    (%eax),%eax
  8035ff:	eb 05                	jmp    803606 <realloc_block_FF+0x467>
  803601:	b8 00 00 00 00       	mov    $0x0,%eax
  803606:	a3 34 50 80 00       	mov    %eax,0x805034
  80360b:	a1 34 50 80 00       	mov    0x805034,%eax
  803610:	85 c0                	test   %eax,%eax
  803612:	0f 85 52 ff ff ff    	jne    80356a <realloc_block_FF+0x3cb>
  803618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80361c:	0f 85 48 ff ff ff    	jne    80356a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803622:	83 ec 04             	sub    $0x4,%esp
  803625:	6a 00                	push   $0x0
  803627:	ff 75 d8             	pushl  -0x28(%ebp)
  80362a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80362d:	e8 7a eb ff ff       	call   8021ac <set_block_data>
  803632:	83 c4 10             	add    $0x10,%esp
				return va;
  803635:	8b 45 08             	mov    0x8(%ebp),%eax
  803638:	e9 7b 02 00 00       	jmp    8038b8 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  80363d:	83 ec 0c             	sub    $0xc,%esp
  803640:	68 a9 44 80 00       	push   $0x8044a9
  803645:	e8 7e cd ff ff       	call   8003c8 <cprintf>
  80364a:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	e9 63 02 00 00       	jmp    8038b8 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803655:	8b 45 0c             	mov    0xc(%ebp),%eax
  803658:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80365b:	0f 86 4d 02 00 00    	jbe    8038ae <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803661:	83 ec 0c             	sub    $0xc,%esp
  803664:	ff 75 e4             	pushl  -0x1c(%ebp)
  803667:	e8 08 e8 ff ff       	call   801e74 <is_free_block>
  80366c:	83 c4 10             	add    $0x10,%esp
  80366f:	84 c0                	test   %al,%al
  803671:	0f 84 37 02 00 00    	je     8038ae <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803677:	8b 45 0c             	mov    0xc(%ebp),%eax
  80367a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80367d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803680:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803683:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803686:	76 38                	jbe    8036c0 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803688:	83 ec 0c             	sub    $0xc,%esp
  80368b:	ff 75 08             	pushl  0x8(%ebp)
  80368e:	e8 0c fa ff ff       	call   80309f <free_block>
  803693:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803696:	83 ec 0c             	sub    $0xc,%esp
  803699:	ff 75 0c             	pushl  0xc(%ebp)
  80369c:	e8 3a eb ff ff       	call   8021db <alloc_block_FF>
  8036a1:	83 c4 10             	add    $0x10,%esp
  8036a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8036a7:	83 ec 08             	sub    $0x8,%esp
  8036aa:	ff 75 c0             	pushl  -0x40(%ebp)
  8036ad:	ff 75 08             	pushl  0x8(%ebp)
  8036b0:	e8 ab fa ff ff       	call   803160 <copy_data>
  8036b5:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036b8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036bb:	e9 f8 01 00 00       	jmp    8038b8 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036c3:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8036c6:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8036c9:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8036cd:	0f 87 a0 00 00 00    	ja     803773 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8036d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036d7:	75 17                	jne    8036f0 <realloc_block_FF+0x551>
  8036d9:	83 ec 04             	sub    $0x4,%esp
  8036dc:	68 9b 43 80 00       	push   $0x80439b
  8036e1:	68 38 02 00 00       	push   $0x238
  8036e6:	68 b9 43 80 00       	push   $0x8043b9
  8036eb:	e8 40 02 00 00       	call   803930 <_panic>
  8036f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f3:	8b 00                	mov    (%eax),%eax
  8036f5:	85 c0                	test   %eax,%eax
  8036f7:	74 10                	je     803709 <realloc_block_FF+0x56a>
  8036f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fc:	8b 00                	mov    (%eax),%eax
  8036fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803701:	8b 52 04             	mov    0x4(%edx),%edx
  803704:	89 50 04             	mov    %edx,0x4(%eax)
  803707:	eb 0b                	jmp    803714 <realloc_block_FF+0x575>
  803709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80370c:	8b 40 04             	mov    0x4(%eax),%eax
  80370f:	a3 30 50 80 00       	mov    %eax,0x805030
  803714:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803717:	8b 40 04             	mov    0x4(%eax),%eax
  80371a:	85 c0                	test   %eax,%eax
  80371c:	74 0f                	je     80372d <realloc_block_FF+0x58e>
  80371e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803721:	8b 40 04             	mov    0x4(%eax),%eax
  803724:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803727:	8b 12                	mov    (%edx),%edx
  803729:	89 10                	mov    %edx,(%eax)
  80372b:	eb 0a                	jmp    803737 <realloc_block_FF+0x598>
  80372d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803730:	8b 00                	mov    (%eax),%eax
  803732:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803743:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80374a:	a1 38 50 80 00       	mov    0x805038,%eax
  80374f:	48                   	dec    %eax
  803750:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803755:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803758:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80375b:	01 d0                	add    %edx,%eax
  80375d:	83 ec 04             	sub    $0x4,%esp
  803760:	6a 01                	push   $0x1
  803762:	50                   	push   %eax
  803763:	ff 75 08             	pushl  0x8(%ebp)
  803766:	e8 41 ea ff ff       	call   8021ac <set_block_data>
  80376b:	83 c4 10             	add    $0x10,%esp
  80376e:	e9 36 01 00 00       	jmp    8038a9 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803773:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803776:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803779:	01 d0                	add    %edx,%eax
  80377b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80377e:	83 ec 04             	sub    $0x4,%esp
  803781:	6a 01                	push   $0x1
  803783:	ff 75 f0             	pushl  -0x10(%ebp)
  803786:	ff 75 08             	pushl  0x8(%ebp)
  803789:	e8 1e ea ff ff       	call   8021ac <set_block_data>
  80378e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803791:	8b 45 08             	mov    0x8(%ebp),%eax
  803794:	83 e8 04             	sub    $0x4,%eax
  803797:	8b 00                	mov    (%eax),%eax
  803799:	83 e0 fe             	and    $0xfffffffe,%eax
  80379c:	89 c2                	mov    %eax,%edx
  80379e:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a1:	01 d0                	add    %edx,%eax
  8037a3:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037aa:	74 06                	je     8037b2 <realloc_block_FF+0x613>
  8037ac:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037b0:	75 17                	jne    8037c9 <realloc_block_FF+0x62a>
  8037b2:	83 ec 04             	sub    $0x4,%esp
  8037b5:	68 2c 44 80 00       	push   $0x80442c
  8037ba:	68 44 02 00 00       	push   $0x244
  8037bf:	68 b9 43 80 00       	push   $0x8043b9
  8037c4:	e8 67 01 00 00       	call   803930 <_panic>
  8037c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037cc:	8b 10                	mov    (%eax),%edx
  8037ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037d1:	89 10                	mov    %edx,(%eax)
  8037d3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037d6:	8b 00                	mov    (%eax),%eax
  8037d8:	85 c0                	test   %eax,%eax
  8037da:	74 0b                	je     8037e7 <realloc_block_FF+0x648>
  8037dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037df:	8b 00                	mov    (%eax),%eax
  8037e1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037e4:	89 50 04             	mov    %edx,0x4(%eax)
  8037e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ea:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8037ed:	89 10                	mov    %edx,(%eax)
  8037ef:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037f5:	89 50 04             	mov    %edx,0x4(%eax)
  8037f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037fb:	8b 00                	mov    (%eax),%eax
  8037fd:	85 c0                	test   %eax,%eax
  8037ff:	75 08                	jne    803809 <realloc_block_FF+0x66a>
  803801:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803804:	a3 30 50 80 00       	mov    %eax,0x805030
  803809:	a1 38 50 80 00       	mov    0x805038,%eax
  80380e:	40                   	inc    %eax
  80380f:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803814:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803818:	75 17                	jne    803831 <realloc_block_FF+0x692>
  80381a:	83 ec 04             	sub    $0x4,%esp
  80381d:	68 9b 43 80 00       	push   $0x80439b
  803822:	68 45 02 00 00       	push   $0x245
  803827:	68 b9 43 80 00       	push   $0x8043b9
  80382c:	e8 ff 00 00 00       	call   803930 <_panic>
  803831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803834:	8b 00                	mov    (%eax),%eax
  803836:	85 c0                	test   %eax,%eax
  803838:	74 10                	je     80384a <realloc_block_FF+0x6ab>
  80383a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383d:	8b 00                	mov    (%eax),%eax
  80383f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803842:	8b 52 04             	mov    0x4(%edx),%edx
  803845:	89 50 04             	mov    %edx,0x4(%eax)
  803848:	eb 0b                	jmp    803855 <realloc_block_FF+0x6b6>
  80384a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384d:	8b 40 04             	mov    0x4(%eax),%eax
  803850:	a3 30 50 80 00       	mov    %eax,0x805030
  803855:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803858:	8b 40 04             	mov    0x4(%eax),%eax
  80385b:	85 c0                	test   %eax,%eax
  80385d:	74 0f                	je     80386e <realloc_block_FF+0x6cf>
  80385f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803862:	8b 40 04             	mov    0x4(%eax),%eax
  803865:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803868:	8b 12                	mov    (%edx),%edx
  80386a:	89 10                	mov    %edx,(%eax)
  80386c:	eb 0a                	jmp    803878 <realloc_block_FF+0x6d9>
  80386e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803878:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803884:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80388b:	a1 38 50 80 00       	mov    0x805038,%eax
  803890:	48                   	dec    %eax
  803891:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803896:	83 ec 04             	sub    $0x4,%esp
  803899:	6a 00                	push   $0x0
  80389b:	ff 75 bc             	pushl  -0x44(%ebp)
  80389e:	ff 75 b8             	pushl  -0x48(%ebp)
  8038a1:	e8 06 e9 ff ff       	call   8021ac <set_block_data>
  8038a6:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	eb 0a                	jmp    8038b8 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8038ae:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038b8:	c9                   	leave  
  8038b9:	c3                   	ret    

008038ba <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038ba:	55                   	push   %ebp
  8038bb:	89 e5                	mov    %esp,%ebp
  8038bd:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038c0:	83 ec 04             	sub    $0x4,%esp
  8038c3:	68 b0 44 80 00       	push   $0x8044b0
  8038c8:	68 58 02 00 00       	push   $0x258
  8038cd:	68 b9 43 80 00       	push   $0x8043b9
  8038d2:	e8 59 00 00 00       	call   803930 <_panic>

008038d7 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8038d7:	55                   	push   %ebp
  8038d8:	89 e5                	mov    %esp,%ebp
  8038da:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8038dd:	83 ec 04             	sub    $0x4,%esp
  8038e0:	68 d8 44 80 00       	push   $0x8044d8
  8038e5:	68 61 02 00 00       	push   $0x261
  8038ea:	68 b9 43 80 00       	push   $0x8043b9
  8038ef:	e8 3c 00 00 00       	call   803930 <_panic>

008038f4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8038f4:	55                   	push   %ebp
  8038f5:	89 e5                	mov    %esp,%ebp
  8038f7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8038fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fd:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  803900:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803904:	83 ec 0c             	sub    $0xc,%esp
  803907:	50                   	push   %eax
  803908:	e8 dd e0 ff ff       	call   8019ea <sys_cputc>
  80390d:	83 c4 10             	add    $0x10,%esp
}
  803910:	90                   	nop
  803911:	c9                   	leave  
  803912:	c3                   	ret    

00803913 <getchar>:


int
getchar(void)
{
  803913:	55                   	push   %ebp
  803914:	89 e5                	mov    %esp,%ebp
  803916:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803919:	e8 68 df ff ff       	call   801886 <sys_cgetc>
  80391e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  803921:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803924:	c9                   	leave  
  803925:	c3                   	ret    

00803926 <iscons>:

int iscons(int fdnum)
{
  803926:	55                   	push   %ebp
  803927:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803929:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80392e:	5d                   	pop    %ebp
  80392f:	c3                   	ret    

00803930 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803930:	55                   	push   %ebp
  803931:	89 e5                	mov    %esp,%ebp
  803933:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803936:	8d 45 10             	lea    0x10(%ebp),%eax
  803939:	83 c0 04             	add    $0x4,%eax
  80393c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80393f:	a1 60 50 90 00       	mov    0x905060,%eax
  803944:	85 c0                	test   %eax,%eax
  803946:	74 16                	je     80395e <_panic+0x2e>
		cprintf("%s: ", argv0);
  803948:	a1 60 50 90 00       	mov    0x905060,%eax
  80394d:	83 ec 08             	sub    $0x8,%esp
  803950:	50                   	push   %eax
  803951:	68 00 45 80 00       	push   $0x804500
  803956:	e8 6d ca ff ff       	call   8003c8 <cprintf>
  80395b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80395e:	a1 00 50 80 00       	mov    0x805000,%eax
  803963:	ff 75 0c             	pushl  0xc(%ebp)
  803966:	ff 75 08             	pushl  0x8(%ebp)
  803969:	50                   	push   %eax
  80396a:	68 05 45 80 00       	push   $0x804505
  80396f:	e8 54 ca ff ff       	call   8003c8 <cprintf>
  803974:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803977:	8b 45 10             	mov    0x10(%ebp),%eax
  80397a:	83 ec 08             	sub    $0x8,%esp
  80397d:	ff 75 f4             	pushl  -0xc(%ebp)
  803980:	50                   	push   %eax
  803981:	e8 d7 c9 ff ff       	call   80035d <vcprintf>
  803986:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803989:	83 ec 08             	sub    $0x8,%esp
  80398c:	6a 00                	push   $0x0
  80398e:	68 21 45 80 00       	push   $0x804521
  803993:	e8 c5 c9 ff ff       	call   80035d <vcprintf>
  803998:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80399b:	e8 46 c9 ff ff       	call   8002e6 <exit>

	// should not return here
	while (1) ;
  8039a0:	eb fe                	jmp    8039a0 <_panic+0x70>

008039a2 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8039a2:	55                   	push   %ebp
  8039a3:	89 e5                	mov    %esp,%ebp
  8039a5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8039a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8039ad:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039b6:	39 c2                	cmp    %eax,%edx
  8039b8:	74 14                	je     8039ce <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8039ba:	83 ec 04             	sub    $0x4,%esp
  8039bd:	68 24 45 80 00       	push   $0x804524
  8039c2:	6a 26                	push   $0x26
  8039c4:	68 70 45 80 00       	push   $0x804570
  8039c9:	e8 62 ff ff ff       	call   803930 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8039ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8039d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8039dc:	e9 c5 00 00 00       	jmp    803aa6 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8039e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ee:	01 d0                	add    %edx,%eax
  8039f0:	8b 00                	mov    (%eax),%eax
  8039f2:	85 c0                	test   %eax,%eax
  8039f4:	75 08                	jne    8039fe <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8039f6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8039f9:	e9 a5 00 00 00       	jmp    803aa3 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8039fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a0c:	eb 69                	jmp    803a77 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a0e:	a1 20 50 80 00       	mov    0x805020,%eax
  803a13:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a1c:	89 d0                	mov    %edx,%eax
  803a1e:	01 c0                	add    %eax,%eax
  803a20:	01 d0                	add    %edx,%eax
  803a22:	c1 e0 03             	shl    $0x3,%eax
  803a25:	01 c8                	add    %ecx,%eax
  803a27:	8a 40 04             	mov    0x4(%eax),%al
  803a2a:	84 c0                	test   %al,%al
  803a2c:	75 46                	jne    803a74 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a2e:	a1 20 50 80 00       	mov    0x805020,%eax
  803a33:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a3c:	89 d0                	mov    %edx,%eax
  803a3e:	01 c0                	add    %eax,%eax
  803a40:	01 d0                	add    %edx,%eax
  803a42:	c1 e0 03             	shl    $0x3,%eax
  803a45:	01 c8                	add    %ecx,%eax
  803a47:	8b 00                	mov    (%eax),%eax
  803a49:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a54:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a59:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a60:	8b 45 08             	mov    0x8(%ebp),%eax
  803a63:	01 c8                	add    %ecx,%eax
  803a65:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a67:	39 c2                	cmp    %eax,%edx
  803a69:	75 09                	jne    803a74 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a6b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a72:	eb 15                	jmp    803a89 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a74:	ff 45 e8             	incl   -0x18(%ebp)
  803a77:	a1 20 50 80 00       	mov    0x805020,%eax
  803a7c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a85:	39 c2                	cmp    %eax,%edx
  803a87:	77 85                	ja     803a0e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a89:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a8d:	75 14                	jne    803aa3 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803a8f:	83 ec 04             	sub    $0x4,%esp
  803a92:	68 7c 45 80 00       	push   $0x80457c
  803a97:	6a 3a                	push   $0x3a
  803a99:	68 70 45 80 00       	push   $0x804570
  803a9e:	e8 8d fe ff ff       	call   803930 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803aa3:	ff 45 f0             	incl   -0x10(%ebp)
  803aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803aac:	0f 8c 2f ff ff ff    	jl     8039e1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803ab2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ab9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803ac0:	eb 26                	jmp    803ae8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803ac2:	a1 20 50 80 00       	mov    0x805020,%eax
  803ac7:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803acd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ad0:	89 d0                	mov    %edx,%eax
  803ad2:	01 c0                	add    %eax,%eax
  803ad4:	01 d0                	add    %edx,%eax
  803ad6:	c1 e0 03             	shl    $0x3,%eax
  803ad9:	01 c8                	add    %ecx,%eax
  803adb:	8a 40 04             	mov    0x4(%eax),%al
  803ade:	3c 01                	cmp    $0x1,%al
  803ae0:	75 03                	jne    803ae5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803ae2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ae5:	ff 45 e0             	incl   -0x20(%ebp)
  803ae8:	a1 20 50 80 00       	mov    0x805020,%eax
  803aed:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803af3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803af6:	39 c2                	cmp    %eax,%edx
  803af8:	77 c8                	ja     803ac2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803afd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b00:	74 14                	je     803b16 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b02:	83 ec 04             	sub    $0x4,%esp
  803b05:	68 d0 45 80 00       	push   $0x8045d0
  803b0a:	6a 44                	push   $0x44
  803b0c:	68 70 45 80 00       	push   $0x804570
  803b11:	e8 1a fe ff ff       	call   803930 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b16:	90                   	nop
  803b17:	c9                   	leave  
  803b18:	c3                   	ret    
  803b19:	66 90                	xchg   %ax,%ax
  803b1b:	90                   	nop

00803b1c <__udivdi3>:
  803b1c:	55                   	push   %ebp
  803b1d:	57                   	push   %edi
  803b1e:	56                   	push   %esi
  803b1f:	53                   	push   %ebx
  803b20:	83 ec 1c             	sub    $0x1c,%esp
  803b23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b33:	89 ca                	mov    %ecx,%edx
  803b35:	89 f8                	mov    %edi,%eax
  803b37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b3b:	85 f6                	test   %esi,%esi
  803b3d:	75 2d                	jne    803b6c <__udivdi3+0x50>
  803b3f:	39 cf                	cmp    %ecx,%edi
  803b41:	77 65                	ja     803ba8 <__udivdi3+0x8c>
  803b43:	89 fd                	mov    %edi,%ebp
  803b45:	85 ff                	test   %edi,%edi
  803b47:	75 0b                	jne    803b54 <__udivdi3+0x38>
  803b49:	b8 01 00 00 00       	mov    $0x1,%eax
  803b4e:	31 d2                	xor    %edx,%edx
  803b50:	f7 f7                	div    %edi
  803b52:	89 c5                	mov    %eax,%ebp
  803b54:	31 d2                	xor    %edx,%edx
  803b56:	89 c8                	mov    %ecx,%eax
  803b58:	f7 f5                	div    %ebp
  803b5a:	89 c1                	mov    %eax,%ecx
  803b5c:	89 d8                	mov    %ebx,%eax
  803b5e:	f7 f5                	div    %ebp
  803b60:	89 cf                	mov    %ecx,%edi
  803b62:	89 fa                	mov    %edi,%edx
  803b64:	83 c4 1c             	add    $0x1c,%esp
  803b67:	5b                   	pop    %ebx
  803b68:	5e                   	pop    %esi
  803b69:	5f                   	pop    %edi
  803b6a:	5d                   	pop    %ebp
  803b6b:	c3                   	ret    
  803b6c:	39 ce                	cmp    %ecx,%esi
  803b6e:	77 28                	ja     803b98 <__udivdi3+0x7c>
  803b70:	0f bd fe             	bsr    %esi,%edi
  803b73:	83 f7 1f             	xor    $0x1f,%edi
  803b76:	75 40                	jne    803bb8 <__udivdi3+0x9c>
  803b78:	39 ce                	cmp    %ecx,%esi
  803b7a:	72 0a                	jb     803b86 <__udivdi3+0x6a>
  803b7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b80:	0f 87 9e 00 00 00    	ja     803c24 <__udivdi3+0x108>
  803b86:	b8 01 00 00 00       	mov    $0x1,%eax
  803b8b:	89 fa                	mov    %edi,%edx
  803b8d:	83 c4 1c             	add    $0x1c,%esp
  803b90:	5b                   	pop    %ebx
  803b91:	5e                   	pop    %esi
  803b92:	5f                   	pop    %edi
  803b93:	5d                   	pop    %ebp
  803b94:	c3                   	ret    
  803b95:	8d 76 00             	lea    0x0(%esi),%esi
  803b98:	31 ff                	xor    %edi,%edi
  803b9a:	31 c0                	xor    %eax,%eax
  803b9c:	89 fa                	mov    %edi,%edx
  803b9e:	83 c4 1c             	add    $0x1c,%esp
  803ba1:	5b                   	pop    %ebx
  803ba2:	5e                   	pop    %esi
  803ba3:	5f                   	pop    %edi
  803ba4:	5d                   	pop    %ebp
  803ba5:	c3                   	ret    
  803ba6:	66 90                	xchg   %ax,%ax
  803ba8:	89 d8                	mov    %ebx,%eax
  803baa:	f7 f7                	div    %edi
  803bac:	31 ff                	xor    %edi,%edi
  803bae:	89 fa                	mov    %edi,%edx
  803bb0:	83 c4 1c             	add    $0x1c,%esp
  803bb3:	5b                   	pop    %ebx
  803bb4:	5e                   	pop    %esi
  803bb5:	5f                   	pop    %edi
  803bb6:	5d                   	pop    %ebp
  803bb7:	c3                   	ret    
  803bb8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bbd:	89 eb                	mov    %ebp,%ebx
  803bbf:	29 fb                	sub    %edi,%ebx
  803bc1:	89 f9                	mov    %edi,%ecx
  803bc3:	d3 e6                	shl    %cl,%esi
  803bc5:	89 c5                	mov    %eax,%ebp
  803bc7:	88 d9                	mov    %bl,%cl
  803bc9:	d3 ed                	shr    %cl,%ebp
  803bcb:	89 e9                	mov    %ebp,%ecx
  803bcd:	09 f1                	or     %esi,%ecx
  803bcf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bd3:	89 f9                	mov    %edi,%ecx
  803bd5:	d3 e0                	shl    %cl,%eax
  803bd7:	89 c5                	mov    %eax,%ebp
  803bd9:	89 d6                	mov    %edx,%esi
  803bdb:	88 d9                	mov    %bl,%cl
  803bdd:	d3 ee                	shr    %cl,%esi
  803bdf:	89 f9                	mov    %edi,%ecx
  803be1:	d3 e2                	shl    %cl,%edx
  803be3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803be7:	88 d9                	mov    %bl,%cl
  803be9:	d3 e8                	shr    %cl,%eax
  803beb:	09 c2                	or     %eax,%edx
  803bed:	89 d0                	mov    %edx,%eax
  803bef:	89 f2                	mov    %esi,%edx
  803bf1:	f7 74 24 0c          	divl   0xc(%esp)
  803bf5:	89 d6                	mov    %edx,%esi
  803bf7:	89 c3                	mov    %eax,%ebx
  803bf9:	f7 e5                	mul    %ebp
  803bfb:	39 d6                	cmp    %edx,%esi
  803bfd:	72 19                	jb     803c18 <__udivdi3+0xfc>
  803bff:	74 0b                	je     803c0c <__udivdi3+0xf0>
  803c01:	89 d8                	mov    %ebx,%eax
  803c03:	31 ff                	xor    %edi,%edi
  803c05:	e9 58 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c0a:	66 90                	xchg   %ax,%ax
  803c0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c10:	89 f9                	mov    %edi,%ecx
  803c12:	d3 e2                	shl    %cl,%edx
  803c14:	39 c2                	cmp    %eax,%edx
  803c16:	73 e9                	jae    803c01 <__udivdi3+0xe5>
  803c18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c1b:	31 ff                	xor    %edi,%edi
  803c1d:	e9 40 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c22:	66 90                	xchg   %ax,%ax
  803c24:	31 c0                	xor    %eax,%eax
  803c26:	e9 37 ff ff ff       	jmp    803b62 <__udivdi3+0x46>
  803c2b:	90                   	nop

00803c2c <__umoddi3>:
  803c2c:	55                   	push   %ebp
  803c2d:	57                   	push   %edi
  803c2e:	56                   	push   %esi
  803c2f:	53                   	push   %ebx
  803c30:	83 ec 1c             	sub    $0x1c,%esp
  803c33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c37:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c4b:	89 f3                	mov    %esi,%ebx
  803c4d:	89 fa                	mov    %edi,%edx
  803c4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c53:	89 34 24             	mov    %esi,(%esp)
  803c56:	85 c0                	test   %eax,%eax
  803c58:	75 1a                	jne    803c74 <__umoddi3+0x48>
  803c5a:	39 f7                	cmp    %esi,%edi
  803c5c:	0f 86 a2 00 00 00    	jbe    803d04 <__umoddi3+0xd8>
  803c62:	89 c8                	mov    %ecx,%eax
  803c64:	89 f2                	mov    %esi,%edx
  803c66:	f7 f7                	div    %edi
  803c68:	89 d0                	mov    %edx,%eax
  803c6a:	31 d2                	xor    %edx,%edx
  803c6c:	83 c4 1c             	add    $0x1c,%esp
  803c6f:	5b                   	pop    %ebx
  803c70:	5e                   	pop    %esi
  803c71:	5f                   	pop    %edi
  803c72:	5d                   	pop    %ebp
  803c73:	c3                   	ret    
  803c74:	39 f0                	cmp    %esi,%eax
  803c76:	0f 87 ac 00 00 00    	ja     803d28 <__umoddi3+0xfc>
  803c7c:	0f bd e8             	bsr    %eax,%ebp
  803c7f:	83 f5 1f             	xor    $0x1f,%ebp
  803c82:	0f 84 ac 00 00 00    	je     803d34 <__umoddi3+0x108>
  803c88:	bf 20 00 00 00       	mov    $0x20,%edi
  803c8d:	29 ef                	sub    %ebp,%edi
  803c8f:	89 fe                	mov    %edi,%esi
  803c91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c95:	89 e9                	mov    %ebp,%ecx
  803c97:	d3 e0                	shl    %cl,%eax
  803c99:	89 d7                	mov    %edx,%edi
  803c9b:	89 f1                	mov    %esi,%ecx
  803c9d:	d3 ef                	shr    %cl,%edi
  803c9f:	09 c7                	or     %eax,%edi
  803ca1:	89 e9                	mov    %ebp,%ecx
  803ca3:	d3 e2                	shl    %cl,%edx
  803ca5:	89 14 24             	mov    %edx,(%esp)
  803ca8:	89 d8                	mov    %ebx,%eax
  803caa:	d3 e0                	shl    %cl,%eax
  803cac:	89 c2                	mov    %eax,%edx
  803cae:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cb2:	d3 e0                	shl    %cl,%eax
  803cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cb8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cbc:	89 f1                	mov    %esi,%ecx
  803cbe:	d3 e8                	shr    %cl,%eax
  803cc0:	09 d0                	or     %edx,%eax
  803cc2:	d3 eb                	shr    %cl,%ebx
  803cc4:	89 da                	mov    %ebx,%edx
  803cc6:	f7 f7                	div    %edi
  803cc8:	89 d3                	mov    %edx,%ebx
  803cca:	f7 24 24             	mull   (%esp)
  803ccd:	89 c6                	mov    %eax,%esi
  803ccf:	89 d1                	mov    %edx,%ecx
  803cd1:	39 d3                	cmp    %edx,%ebx
  803cd3:	0f 82 87 00 00 00    	jb     803d60 <__umoddi3+0x134>
  803cd9:	0f 84 91 00 00 00    	je     803d70 <__umoddi3+0x144>
  803cdf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ce3:	29 f2                	sub    %esi,%edx
  803ce5:	19 cb                	sbb    %ecx,%ebx
  803ce7:	89 d8                	mov    %ebx,%eax
  803ce9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ced:	d3 e0                	shl    %cl,%eax
  803cef:	89 e9                	mov    %ebp,%ecx
  803cf1:	d3 ea                	shr    %cl,%edx
  803cf3:	09 d0                	or     %edx,%eax
  803cf5:	89 e9                	mov    %ebp,%ecx
  803cf7:	d3 eb                	shr    %cl,%ebx
  803cf9:	89 da                	mov    %ebx,%edx
  803cfb:	83 c4 1c             	add    $0x1c,%esp
  803cfe:	5b                   	pop    %ebx
  803cff:	5e                   	pop    %esi
  803d00:	5f                   	pop    %edi
  803d01:	5d                   	pop    %ebp
  803d02:	c3                   	ret    
  803d03:	90                   	nop
  803d04:	89 fd                	mov    %edi,%ebp
  803d06:	85 ff                	test   %edi,%edi
  803d08:	75 0b                	jne    803d15 <__umoddi3+0xe9>
  803d0a:	b8 01 00 00 00       	mov    $0x1,%eax
  803d0f:	31 d2                	xor    %edx,%edx
  803d11:	f7 f7                	div    %edi
  803d13:	89 c5                	mov    %eax,%ebp
  803d15:	89 f0                	mov    %esi,%eax
  803d17:	31 d2                	xor    %edx,%edx
  803d19:	f7 f5                	div    %ebp
  803d1b:	89 c8                	mov    %ecx,%eax
  803d1d:	f7 f5                	div    %ebp
  803d1f:	89 d0                	mov    %edx,%eax
  803d21:	e9 44 ff ff ff       	jmp    803c6a <__umoddi3+0x3e>
  803d26:	66 90                	xchg   %ax,%ax
  803d28:	89 c8                	mov    %ecx,%eax
  803d2a:	89 f2                	mov    %esi,%edx
  803d2c:	83 c4 1c             	add    $0x1c,%esp
  803d2f:	5b                   	pop    %ebx
  803d30:	5e                   	pop    %esi
  803d31:	5f                   	pop    %edi
  803d32:	5d                   	pop    %ebp
  803d33:	c3                   	ret    
  803d34:	3b 04 24             	cmp    (%esp),%eax
  803d37:	72 06                	jb     803d3f <__umoddi3+0x113>
  803d39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d3d:	77 0f                	ja     803d4e <__umoddi3+0x122>
  803d3f:	89 f2                	mov    %esi,%edx
  803d41:	29 f9                	sub    %edi,%ecx
  803d43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d47:	89 14 24             	mov    %edx,(%esp)
  803d4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d52:	8b 14 24             	mov    (%esp),%edx
  803d55:	83 c4 1c             	add    $0x1c,%esp
  803d58:	5b                   	pop    %ebx
  803d59:	5e                   	pop    %esi
  803d5a:	5f                   	pop    %edi
  803d5b:	5d                   	pop    %ebp
  803d5c:	c3                   	ret    
  803d5d:	8d 76 00             	lea    0x0(%esi),%esi
  803d60:	2b 04 24             	sub    (%esp),%eax
  803d63:	19 fa                	sbb    %edi,%edx
  803d65:	89 d1                	mov    %edx,%ecx
  803d67:	89 c6                	mov    %eax,%esi
  803d69:	e9 71 ff ff ff       	jmp    803cdf <__umoddi3+0xb3>
  803d6e:	66 90                	xchg   %ax,%ax
  803d70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d74:	72 ea                	jb     803d60 <__umoddi3+0x134>
  803d76:	89 d9                	mov    %ebx,%ecx
  803d78:	e9 62 ff ff ff       	jmp    803cdf <__umoddi3+0xb3>
