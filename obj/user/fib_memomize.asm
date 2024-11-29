
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
  800052:	68 e0 3e 80 00       	push   $0x803ee0
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
  8000ec:	68 fe 3e 80 00       	push   $0x803efe
  8000f1:	e8 ff 02 00 00       	call   8003f5 <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 b3 1c 00 00       	call   801db1 <inctst>
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
  8001bb:	e8 b3 1a 00 00       	call   801c73 <sys_getenvindex>
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
  800229:	e8 c9 17 00 00       	call   8019f7 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	68 2c 3f 80 00       	push   $0x803f2c
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
  800259:	68 54 3f 80 00       	push   $0x803f54
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
  80028a:	68 7c 3f 80 00       	push   $0x803f7c
  80028f:	e8 34 01 00 00       	call   8003c8 <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800297:	a1 20 50 80 00       	mov    0x805020,%eax
  80029c:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	50                   	push   %eax
  8002a6:	68 d4 3f 80 00       	push   $0x803fd4
  8002ab:	e8 18 01 00 00       	call   8003c8 <cprintf>
  8002b0:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	68 2c 3f 80 00       	push   $0x803f2c
  8002bb:	e8 08 01 00 00       	call   8003c8 <cprintf>
  8002c0:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002c3:	e8 49 17 00 00       	call   801a11 <sys_unlock_cons>
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
  8002db:	e8 5f 19 00 00       	call   801c3f <sys_destroy_env>
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
  8002ec:	e8 b4 19 00 00       	call   801ca5 <sys_exit_env>
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
  80031f:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  80033a:	e8 76 16 00 00       	call   8019b5 <sys_cputs>
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
  800394:	a0 2c 50 80 00       	mov    0x80502c,%al
  800399:	0f b6 c0             	movzbl %al,%eax
  80039c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003a2:	83 ec 04             	sub    $0x4,%esp
  8003a5:	50                   	push   %eax
  8003a6:	52                   	push   %edx
  8003a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003ad:	83 c0 08             	add    $0x8,%eax
  8003b0:	50                   	push   %eax
  8003b1:	e8 ff 15 00 00       	call   8019b5 <sys_cputs>
  8003b6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003b9:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  8003ce:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8003fb:	e8 f7 15 00 00       	call   8019f7 <sys_lock_cons>
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
  80041b:	e8 f1 15 00 00       	call   801a11 <sys_unlock_cons>
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
  800465:	e8 0a 38 00 00       	call   803c74 <__udivdi3>
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
  8004b5:	e8 ca 38 00 00       	call   803d84 <__umoddi3>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	05 14 42 80 00       	add    $0x804214,%eax
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
  800610:	8b 04 85 38 42 80 00 	mov    0x804238(,%eax,4),%eax
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
  8006f1:	8b 34 9d 80 40 80 00 	mov    0x804080(,%ebx,4),%esi
  8006f8:	85 f6                	test   %esi,%esi
  8006fa:	75 19                	jne    800715 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006fc:	53                   	push   %ebx
  8006fd:	68 25 42 80 00       	push   $0x804225
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
  800716:	68 2e 42 80 00       	push   $0x80422e
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
  800743:	be 31 42 80 00       	mov    $0x804231,%esi
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
  80093b:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  800942:	eb 2c                	jmp    800970 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800944:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  800a6e:	68 a8 43 80 00       	push   $0x8043a8
  800a73:	e8 50 f9 ff ff       	call   8003c8 <cprintf>
  800a78:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a82:	83 ec 0c             	sub    $0xc,%esp
  800a85:	6a 00                	push   $0x0
  800a87:	e8 f2 2f 00 00       	call   803a7e <iscons>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a92:	e8 d4 2f 00 00       	call   803a6b <getchar>
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
  800ab0:	68 ab 43 80 00       	push   $0x8043ab
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
  800add:	e8 6a 2f 00 00       	call   803a4c <cputchar>
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
  800b14:	e8 33 2f 00 00       	call   803a4c <cputchar>
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
  800b3d:	e8 0a 2f 00 00       	call   803a4c <cputchar>
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
  800b61:	e8 91 0e 00 00       	call   8019f7 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6a:	74 13                	je     800b7f <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	68 a8 43 80 00       	push   $0x8043a8
  800b77:	e8 4c f8 ff ff       	call   8003c8 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	6a 00                	push   $0x0
  800b8b:	e8 ee 2e 00 00       	call   803a7e <iscons>
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b96:	e8 d0 2e 00 00       	call   803a6b <getchar>
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
  800bb4:	68 ab 43 80 00       	push   $0x8043ab
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
  800be1:	e8 66 2e 00 00       	call   803a4c <cputchar>
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
  800c18:	e8 2f 2e 00 00       	call   803a4c <cputchar>
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
  800c41:	e8 06 2e 00 00       	call   803a4c <cputchar>
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
  800c5c:	e8 b0 0d 00 00       	call   801a11 <sys_unlock_cons>
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
  801356:	68 bc 43 80 00       	push   $0x8043bc
  80135b:	68 3f 01 00 00       	push   $0x13f
  801360:	68 de 43 80 00       	push   $0x8043de
  801365:	e8 1e 27 00 00       	call   803a88 <_panic>

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
  801376:	e8 e5 0b 00 00       	call   801f60 <sys_sbrk>
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
  8013f1:	e8 ee 09 00 00       	call   801de4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	74 16                	je     801410 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 2e 0f 00 00       	call   802333 <alloc_block_FF>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80140b:	e9 8a 01 00 00       	jmp    80159a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801410:	e8 00 0a 00 00       	call   801e15 <sys_isUHeapPlacementStrategyBESTFIT>
  801415:	85 c0                	test   %eax,%eax
  801417:	0f 84 7d 01 00 00    	je     80159a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80141d:	83 ec 0c             	sub    $0xc,%esp
  801420:	ff 75 08             	pushl  0x8(%ebp)
  801423:	e8 c7 13 00 00       	call   8027ef <alloc_block_BF>
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
  801473:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  8014c0:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801517:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  801579:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	ff 75 08             	pushl  0x8(%ebp)
  801586:	ff 75 f0             	pushl  -0x10(%ebp)
  801589:	e8 09 0a 00 00       	call   801f97 <sys_allocate_user_mem>
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
  8015d1:	e8 dd 09 00 00       	call   801fb3 <get_block_size>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	ff 75 08             	pushl  0x8(%ebp)
  8015e2:	e8 10 1c 00 00       	call   8031f7 <free_block>
  8015e7:	83 c4 10             	add    $0x10,%esp
		}

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
  80161c:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  801623:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801626:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801629:	c1 e0 0c             	shl    $0xc,%eax
  80162c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  80162f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801636:	eb 42                	jmp    80167a <free+0xdb>
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
  801659:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801660:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	83 ec 08             	sub    $0x8,%esp
  80166d:	52                   	push   %edx
  80166e:	50                   	push   %eax
  80166f:	e8 07 09 00 00       	call   801f7b <sys_free_user_mem>
  801674:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801677:	ff 45 f4             	incl   -0xc(%ebp)
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801680:	72 b6                	jb     801638 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801682:	eb 17                	jmp    80169b <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  801684:	83 ec 04             	sub    $0x4,%esp
  801687:	68 ec 43 80 00       	push   $0x8043ec
  80168c:	68 88 00 00 00       	push   $0x88
  801691:	68 16 44 80 00       	push   $0x804416
  801696:	e8 ed 23 00 00       	call   803a88 <_panic>
	}
}
  80169b:	90                   	nop
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 28             	sub    $0x28,%esp
  8016a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a7:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8016aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ae:	75 0a                	jne    8016ba <smalloc+0x1c>
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	e9 ec 00 00 00       	jmp    8017a6 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8016ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016c0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cd:	39 d0                	cmp    %edx,%eax
  8016cf:	73 02                	jae    8016d3 <smalloc+0x35>
  8016d1:	89 d0                	mov    %edx,%eax
  8016d3:	83 ec 0c             	sub    $0xc,%esp
  8016d6:	50                   	push   %eax
  8016d7:	e8 a4 fc ff ff       	call   801380 <malloc>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8016e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e6:	75 0a                	jne    8016f2 <smalloc+0x54>
  8016e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ed:	e9 b4 00 00 00       	jmp    8017a6 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8016f2:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016f6:	ff 75 ec             	pushl  -0x14(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	ff 75 0c             	pushl  0xc(%ebp)
  8016fd:	ff 75 08             	pushl  0x8(%ebp)
  801700:	e8 7d 04 00 00       	call   801b82 <sys_createSharedObject>
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80170b:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80170f:	74 06                	je     801717 <smalloc+0x79>
  801711:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801715:	75 0a                	jne    801721 <smalloc+0x83>
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
  80171c:	e9 85 00 00 00       	jmp    8017a6 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801721:	83 ec 08             	sub    $0x8,%esp
  801724:	ff 75 ec             	pushl  -0x14(%ebp)
  801727:	68 22 44 80 00       	push   $0x804422
  80172c:	e8 97 ec ff ff       	call   8003c8 <cprintf>
  801731:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801734:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801737:	a1 20 50 80 00       	mov    0x805020,%eax
  80173c:	8b 40 78             	mov    0x78(%eax),%eax
  80173f:	29 c2                	sub    %eax,%edx
  801741:	89 d0                	mov    %edx,%eax
  801743:	2d 00 10 00 00       	sub    $0x1000,%eax
  801748:	c1 e8 0c             	shr    $0xc,%eax
  80174b:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801751:	42                   	inc    %edx
  801752:	89 15 24 50 80 00    	mov    %edx,0x805024
  801758:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80175e:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801765:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801768:	a1 20 50 80 00       	mov    0x805020,%eax
  80176d:	8b 40 78             	mov    0x78(%eax),%eax
  801770:	29 c2                	sub    %eax,%edx
  801772:	89 d0                	mov    %edx,%eax
  801774:	2d 00 10 00 00       	sub    $0x1000,%eax
  801779:	c1 e8 0c             	shr    $0xc,%eax
  80177c:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801783:	a1 20 50 80 00       	mov    0x805020,%eax
  801788:	8b 50 10             	mov    0x10(%eax),%edx
  80178b:	89 c8                	mov    %ecx,%eax
  80178d:	c1 e0 02             	shl    $0x2,%eax
  801790:	89 c1                	mov    %eax,%ecx
  801792:	c1 e1 09             	shl    $0x9,%ecx
  801795:	01 c8                	add    %ecx,%eax
  801797:	01 c2                	add    %eax,%edx
  801799:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80179c:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8017a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017ae:	83 ec 08             	sub    $0x8,%esp
  8017b1:	ff 75 0c             	pushl  0xc(%ebp)
  8017b4:	ff 75 08             	pushl  0x8(%ebp)
  8017b7:	e8 f0 03 00 00       	call   801bac <sys_getSizeOfSharedObject>
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8017c2:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017c6:	75 0a                	jne    8017d2 <sget+0x2a>
  8017c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cd:	e9 e7 00 00 00       	jmp    8018b9 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8017d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017d8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e5:	39 d0                	cmp    %edx,%eax
  8017e7:	73 02                	jae    8017eb <sget+0x43>
  8017e9:	89 d0                	mov    %edx,%eax
  8017eb:	83 ec 0c             	sub    $0xc,%esp
  8017ee:	50                   	push   %eax
  8017ef:	e8 8c fb ff ff       	call   801380 <malloc>
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8017fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017fe:	75 0a                	jne    80180a <sget+0x62>
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
  801805:	e9 af 00 00 00       	jmp    8018b9 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	ff 75 e8             	pushl  -0x18(%ebp)
  801810:	ff 75 0c             	pushl  0xc(%ebp)
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 ae 03 00 00       	call   801bc9 <sys_getSharedObject>
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801821:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801824:	a1 20 50 80 00       	mov    0x805020,%eax
  801829:	8b 40 78             	mov    0x78(%eax),%eax
  80182c:	29 c2                	sub    %eax,%edx
  80182e:	89 d0                	mov    %edx,%eax
  801830:	2d 00 10 00 00       	sub    $0x1000,%eax
  801835:	c1 e8 0c             	shr    $0xc,%eax
  801838:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80183e:	42                   	inc    %edx
  80183f:	89 15 24 50 80 00    	mov    %edx,0x805024
  801845:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80184b:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801852:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801855:	a1 20 50 80 00       	mov    0x805020,%eax
  80185a:	8b 40 78             	mov    0x78(%eax),%eax
  80185d:	29 c2                	sub    %eax,%edx
  80185f:	89 d0                	mov    %edx,%eax
  801861:	2d 00 10 00 00       	sub    $0x1000,%eax
  801866:	c1 e8 0c             	shr    $0xc,%eax
  801869:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801870:	a1 20 50 80 00       	mov    0x805020,%eax
  801875:	8b 50 10             	mov    0x10(%eax),%edx
  801878:	89 c8                	mov    %ecx,%eax
  80187a:	c1 e0 02             	shl    $0x2,%eax
  80187d:	89 c1                	mov    %eax,%ecx
  80187f:	c1 e1 09             	shl    $0x9,%ecx
  801882:	01 c8                	add    %ecx,%eax
  801884:	01 c2                	add    %eax,%edx
  801886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801889:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  801890:	a1 20 50 80 00       	mov    0x805020,%eax
  801895:	8b 40 10             	mov    0x10(%eax),%eax
  801898:	83 ec 08             	sub    $0x8,%esp
  80189b:	50                   	push   %eax
  80189c:	68 31 44 80 00       	push   $0x804431
  8018a1:	e8 22 eb ff ff       	call   8003c8 <cprintf>
  8018a6:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8018a9:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8018ad:	75 07                	jne    8018b6 <sget+0x10e>
  8018af:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b4:	eb 03                	jmp    8018b9 <sget+0x111>
	return ptr;
  8018b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  8018c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8018c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8018c9:	8b 40 78             	mov    0x78(%eax),%eax
  8018cc:	29 c2                	sub    %eax,%edx
  8018ce:	89 d0                	mov    %edx,%eax
  8018d0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018d5:	c1 e8 0c             	shr    $0xc,%eax
  8018d8:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8018df:	a1 20 50 80 00       	mov    0x805020,%eax
  8018e4:	8b 50 10             	mov    0x10(%eax),%edx
  8018e7:	89 c8                	mov    %ecx,%eax
  8018e9:	c1 e0 02             	shl    $0x2,%eax
  8018ec:	89 c1                	mov    %eax,%ecx
  8018ee:	c1 e1 09             	shl    $0x9,%ecx
  8018f1:	01 c8                	add    %ecx,%eax
  8018f3:	01 d0                	add    %edx,%eax
  8018f5:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8018fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  8018ff:	83 ec 08             	sub    $0x8,%esp
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	ff 75 f4             	pushl  -0xc(%ebp)
  801908:	e8 db 02 00 00       	call   801be8 <sys_freeSharedObject>
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801913:	90                   	nop
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	68 40 44 80 00       	push   $0x804440
  801924:	68 e5 00 00 00       	push   $0xe5
  801929:	68 16 44 80 00       	push   $0x804416
  80192e:	e8 55 21 00 00       	call   803a88 <_panic>

00801933 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	68 66 44 80 00       	push   $0x804466
  801941:	68 f1 00 00 00       	push   $0xf1
  801946:	68 16 44 80 00       	push   $0x804416
  80194b:	e8 38 21 00 00       	call   803a88 <_panic>

00801950 <shrink>:

}
void shrink(uint32 newSize)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801956:	83 ec 04             	sub    $0x4,%esp
  801959:	68 66 44 80 00       	push   $0x804466
  80195e:	68 f6 00 00 00       	push   $0xf6
  801963:	68 16 44 80 00       	push   $0x804416
  801968:	e8 1b 21 00 00       	call   803a88 <_panic>

0080196d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801973:	83 ec 04             	sub    $0x4,%esp
  801976:	68 66 44 80 00       	push   $0x804466
  80197b:	68 fb 00 00 00       	push   $0xfb
  801980:	68 16 44 80 00       	push   $0x804416
  801985:	e8 fe 20 00 00       	call   803a88 <_panic>

0080198a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	57                   	push   %edi
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	8b 55 0c             	mov    0xc(%ebp),%edx
  801999:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80199c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80199f:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019a2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019a5:	cd 30                	int    $0x30
  8019a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019ad:	83 c4 10             	add    $0x10,%esp
  8019b0:	5b                   	pop    %ebx
  8019b1:	5e                   	pop    %esi
  8019b2:	5f                   	pop    %edi
  8019b3:	5d                   	pop    %ebp
  8019b4:	c3                   	ret    

008019b5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019c1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	52                   	push   %edx
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	50                   	push   %eax
  8019d1:	6a 00                	push   $0x0
  8019d3:	e8 b2 ff ff ff       	call   80198a <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	90                   	nop
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_cgetc>:

int
sys_cgetc(void)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 02                	push   $0x2
  8019ed:	e8 98 ff ff ff       	call   80198a <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 03                	push   $0x3
  801a06:	e8 7f ff ff ff       	call   80198a <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	90                   	nop
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 04                	push   $0x4
  801a20:	e8 65 ff ff ff       	call   80198a <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	90                   	nop
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	52                   	push   %edx
  801a3b:	50                   	push   %eax
  801a3c:	6a 08                	push   $0x8
  801a3e:	e8 47 ff ff ff       	call   80198a <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a4d:	8b 75 18             	mov    0x18(%ebp),%esi
  801a50:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a53:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	56                   	push   %esi
  801a5d:	53                   	push   %ebx
  801a5e:	51                   	push   %ecx
  801a5f:	52                   	push   %edx
  801a60:	50                   	push   %eax
  801a61:	6a 09                	push   $0x9
  801a63:	e8 22 ff ff ff       	call   80198a <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6e:	5b                   	pop    %ebx
  801a6f:	5e                   	pop    %esi
  801a70:	5d                   	pop    %ebp
  801a71:	c3                   	ret    

00801a72 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	52                   	push   %edx
  801a82:	50                   	push   %eax
  801a83:	6a 0a                	push   $0xa
  801a85:	e8 00 ff ff ff       	call   80198a <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	ff 75 0c             	pushl  0xc(%ebp)
  801a9b:	ff 75 08             	pushl  0x8(%ebp)
  801a9e:	6a 0b                	push   $0xb
  801aa0:	e8 e5 fe ff ff       	call   80198a <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 0c                	push   $0xc
  801ab9:	e8 cc fe ff ff       	call   80198a <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 0d                	push   $0xd
  801ad2:	e8 b3 fe ff ff       	call   80198a <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 0e                	push   $0xe
  801aeb:	e8 9a fe ff ff       	call   80198a <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 0f                	push   $0xf
  801b04:	e8 81 fe ff ff       	call   80198a <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	ff 75 08             	pushl  0x8(%ebp)
  801b1c:	6a 10                	push   $0x10
  801b1e:	e8 67 fe ff ff       	call   80198a <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 11                	push   $0x11
  801b37:	e8 4e fe ff ff       	call   80198a <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	90                   	nop
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_cputc>:

void
sys_cputc(const char c)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 04             	sub    $0x4,%esp
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b4e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	50                   	push   %eax
  801b5b:	6a 01                	push   $0x1
  801b5d:	e8 28 fe ff ff       	call   80198a <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	90                   	nop
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 14                	push   $0x14
  801b77:	e8 0e fe ff ff       	call   80198a <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	90                   	nop
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 04             	sub    $0x4,%esp
  801b88:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b91:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	6a 00                	push   $0x0
  801b9a:	51                   	push   %ecx
  801b9b:	52                   	push   %edx
  801b9c:	ff 75 0c             	pushl  0xc(%ebp)
  801b9f:	50                   	push   %eax
  801ba0:	6a 15                	push   $0x15
  801ba2:	e8 e3 fd ff ff       	call   80198a <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801baf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	52                   	push   %edx
  801bbc:	50                   	push   %eax
  801bbd:	6a 16                	push   $0x16
  801bbf:	e8 c6 fd ff ff       	call   80198a <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	51                   	push   %ecx
  801bda:	52                   	push   %edx
  801bdb:	50                   	push   %eax
  801bdc:	6a 17                	push   $0x17
  801bde:	e8 a7 fd ff ff       	call   80198a <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bee:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	52                   	push   %edx
  801bf8:	50                   	push   %eax
  801bf9:	6a 18                	push   $0x18
  801bfb:	e8 8a fd ff ff       	call   80198a <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	ff 75 14             	pushl  0x14(%ebp)
  801c10:	ff 75 10             	pushl  0x10(%ebp)
  801c13:	ff 75 0c             	pushl  0xc(%ebp)
  801c16:	50                   	push   %eax
  801c17:	6a 19                	push   $0x19
  801c19:	e8 6c fd ff ff       	call   80198a <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	50                   	push   %eax
  801c32:	6a 1a                	push   $0x1a
  801c34:	e8 51 fd ff ff       	call   80198a <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	90                   	nop
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c42:	8b 45 08             	mov    0x8(%ebp),%eax
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	50                   	push   %eax
  801c4e:	6a 1b                	push   $0x1b
  801c50:	e8 35 fd ff ff       	call   80198a <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 05                	push   $0x5
  801c69:	e8 1c fd ff ff       	call   80198a <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 06                	push   $0x6
  801c82:	e8 03 fd ff ff       	call   80198a <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 07                	push   $0x7
  801c9b:	e8 ea fc ff ff       	call   80198a <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_exit_env>:


void sys_exit_env(void)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 1c                	push   $0x1c
  801cb4:	e8 d1 fc ff ff       	call   80198a <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	90                   	nop
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cc5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc8:	8d 50 04             	lea    0x4(%eax),%edx
  801ccb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 1d                	push   $0x1d
  801cd8:	e8 ad fc ff ff       	call   80198a <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
	return result;
  801ce0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ce6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ce9:	89 01                	mov    %eax,(%ecx)
  801ceb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	c9                   	leave  
  801cf2:	c2 04 00             	ret    $0x4

00801cf5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	ff 75 10             	pushl  0x10(%ebp)
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	ff 75 08             	pushl  0x8(%ebp)
  801d05:	6a 13                	push   $0x13
  801d07:	e8 7e fc ff ff       	call   80198a <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0f:	90                   	nop
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 1e                	push   $0x1e
  801d21:	e8 64 fc ff ff       	call   80198a <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	83 ec 04             	sub    $0x4,%esp
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d37:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	50                   	push   %eax
  801d44:	6a 1f                	push   $0x1f
  801d46:	e8 3f fc ff ff       	call   80198a <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4e:	90                   	nop
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <rsttst>:
void rsttst()
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 21                	push   $0x21
  801d60:	e8 25 fc ff ff       	call   80198a <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
	return ;
  801d68:	90                   	nop
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 04             	sub    $0x4,%esp
  801d71:	8b 45 14             	mov    0x14(%ebp),%eax
  801d74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d77:	8b 55 18             	mov    0x18(%ebp),%edx
  801d7a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d7e:	52                   	push   %edx
  801d7f:	50                   	push   %eax
  801d80:	ff 75 10             	pushl  0x10(%ebp)
  801d83:	ff 75 0c             	pushl  0xc(%ebp)
  801d86:	ff 75 08             	pushl  0x8(%ebp)
  801d89:	6a 20                	push   $0x20
  801d8b:	e8 fa fb ff ff       	call   80198a <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
	return ;
  801d93:	90                   	nop
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <chktst>:
void chktst(uint32 n)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	ff 75 08             	pushl  0x8(%ebp)
  801da4:	6a 22                	push   $0x22
  801da6:	e8 df fb ff ff       	call   80198a <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
	return ;
  801dae:	90                   	nop
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <inctst>:

void inctst()
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 23                	push   $0x23
  801dc0:	e8 c5 fb ff ff       	call   80198a <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc8:	90                   	nop
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <gettst>:
uint32 gettst()
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 24                	push   $0x24
  801dda:	e8 ab fb ff ff       	call   80198a <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 25                	push   $0x25
  801df6:	e8 8f fb ff ff       	call   80198a <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
  801dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e01:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e05:	75 07                	jne    801e0e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e07:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0c:	eb 05                	jmp    801e13 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 25                	push   $0x25
  801e27:	e8 5e fb ff ff       	call   80198a <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
  801e2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e32:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e36:	75 07                	jne    801e3f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e38:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3d:	eb 05                	jmp    801e44 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 25                	push   $0x25
  801e58:	e8 2d fb ff ff       	call   80198a <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
  801e60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e63:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e67:	75 07                	jne    801e70 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e69:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6e:	eb 05                	jmp    801e75 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 25                	push   $0x25
  801e89:	e8 fc fa ff ff       	call   80198a <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
  801e91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e94:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e98:	75 07                	jne    801ea1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9f:	eb 05                	jmp    801ea6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	ff 75 08             	pushl  0x8(%ebp)
  801eb6:	6a 26                	push   $0x26
  801eb8:	e8 cd fa ff ff       	call   80198a <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec0:	90                   	nop
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ec7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ecd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	6a 00                	push   $0x0
  801ed5:	53                   	push   %ebx
  801ed6:	51                   	push   %ecx
  801ed7:	52                   	push   %edx
  801ed8:	50                   	push   %eax
  801ed9:	6a 27                	push   $0x27
  801edb:	e8 aa fa ff ff       	call   80198a <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
}
  801ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	52                   	push   %edx
  801ef8:	50                   	push   %eax
  801ef9:	6a 28                	push   $0x28
  801efb:	e8 8a fa ff ff       	call   80198a <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
}
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801f08:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	6a 00                	push   $0x0
  801f13:	51                   	push   %ecx
  801f14:	ff 75 10             	pushl  0x10(%ebp)
  801f17:	52                   	push   %edx
  801f18:	50                   	push   %eax
  801f19:	6a 29                	push   $0x29
  801f1b:	e8 6a fa ff ff       	call   80198a <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	ff 75 10             	pushl  0x10(%ebp)
  801f2f:	ff 75 0c             	pushl  0xc(%ebp)
  801f32:	ff 75 08             	pushl  0x8(%ebp)
  801f35:	6a 12                	push   $0x12
  801f37:	e8 4e fa ff ff       	call   80198a <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3f:	90                   	nop
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	52                   	push   %edx
  801f52:	50                   	push   %eax
  801f53:	6a 2a                	push   $0x2a
  801f55:	e8 30 fa ff ff       	call   80198a <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
	return;
  801f5d:	90                   	nop
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	50                   	push   %eax
  801f6f:	6a 2b                	push   $0x2b
  801f71:	e8 14 fa ff ff       	call   80198a <syscall>
  801f76:	83 c4 18             	add    $0x18,%esp
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	ff 75 0c             	pushl  0xc(%ebp)
  801f87:	ff 75 08             	pushl  0x8(%ebp)
  801f8a:	6a 2c                	push   $0x2c
  801f8c:	e8 f9 f9 ff ff       	call   80198a <syscall>
  801f91:	83 c4 18             	add    $0x18,%esp
	return;
  801f94:	90                   	nop
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	ff 75 0c             	pushl  0xc(%ebp)
  801fa3:	ff 75 08             	pushl  0x8(%ebp)
  801fa6:	6a 2d                	push   $0x2d
  801fa8:	e8 dd f9 ff ff       	call   80198a <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
	return;
  801fb0:	90                   	nop
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	83 e8 04             	sub    $0x4,%eax
  801fbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801fc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc5:	8b 00                	mov    (%eax),%eax
  801fc7:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	83 e8 04             	sub    $0x4,%eax
  801fd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fde:	8b 00                	mov    (%eax),%eax
  801fe0:	83 e0 01             	and    $0x1,%eax
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	0f 94 c0             	sete   %al
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ff0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffa:	83 f8 02             	cmp    $0x2,%eax
  801ffd:	74 2b                	je     80202a <alloc_block+0x40>
  801fff:	83 f8 02             	cmp    $0x2,%eax
  802002:	7f 07                	jg     80200b <alloc_block+0x21>
  802004:	83 f8 01             	cmp    $0x1,%eax
  802007:	74 0e                	je     802017 <alloc_block+0x2d>
  802009:	eb 58                	jmp    802063 <alloc_block+0x79>
  80200b:	83 f8 03             	cmp    $0x3,%eax
  80200e:	74 2d                	je     80203d <alloc_block+0x53>
  802010:	83 f8 04             	cmp    $0x4,%eax
  802013:	74 3b                	je     802050 <alloc_block+0x66>
  802015:	eb 4c                	jmp    802063 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	ff 75 08             	pushl  0x8(%ebp)
  80201d:	e8 11 03 00 00       	call   802333 <alloc_block_FF>
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802028:	eb 4a                	jmp    802074 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80202a:	83 ec 0c             	sub    $0xc,%esp
  80202d:	ff 75 08             	pushl  0x8(%ebp)
  802030:	e8 fa 19 00 00       	call   803a2f <alloc_block_NF>
  802035:	83 c4 10             	add    $0x10,%esp
  802038:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80203b:	eb 37                	jmp    802074 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80203d:	83 ec 0c             	sub    $0xc,%esp
  802040:	ff 75 08             	pushl  0x8(%ebp)
  802043:	e8 a7 07 00 00       	call   8027ef <alloc_block_BF>
  802048:	83 c4 10             	add    $0x10,%esp
  80204b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80204e:	eb 24                	jmp    802074 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802050:	83 ec 0c             	sub    $0xc,%esp
  802053:	ff 75 08             	pushl  0x8(%ebp)
  802056:	e8 b7 19 00 00       	call   803a12 <alloc_block_WF>
  80205b:	83 c4 10             	add    $0x10,%esp
  80205e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802061:	eb 11                	jmp    802074 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802063:	83 ec 0c             	sub    $0xc,%esp
  802066:	68 78 44 80 00       	push   $0x804478
  80206b:	e8 58 e3 ff ff       	call   8003c8 <cprintf>
  802070:	83 c4 10             	add    $0x10,%esp
		break;
  802073:	90                   	nop
	}
	return va;
  802074:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	53                   	push   %ebx
  80207d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802080:	83 ec 0c             	sub    $0xc,%esp
  802083:	68 98 44 80 00       	push   $0x804498
  802088:	e8 3b e3 ff ff       	call   8003c8 <cprintf>
  80208d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802090:	83 ec 0c             	sub    $0xc,%esp
  802093:	68 c3 44 80 00       	push   $0x8044c3
  802098:	e8 2b e3 ff ff       	call   8003c8 <cprintf>
  80209d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a6:	eb 37                	jmp    8020df <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8020a8:	83 ec 0c             	sub    $0xc,%esp
  8020ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ae:	e8 19 ff ff ff       	call   801fcc <is_free_block>
  8020b3:	83 c4 10             	add    $0x10,%esp
  8020b6:	0f be d8             	movsbl %al,%ebx
  8020b9:	83 ec 0c             	sub    $0xc,%esp
  8020bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8020bf:	e8 ef fe ff ff       	call   801fb3 <get_block_size>
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	83 ec 04             	sub    $0x4,%esp
  8020ca:	53                   	push   %ebx
  8020cb:	50                   	push   %eax
  8020cc:	68 db 44 80 00       	push   $0x8044db
  8020d1:	e8 f2 e2 ff ff       	call   8003c8 <cprintf>
  8020d6:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8020d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e3:	74 07                	je     8020ec <print_blocks_list+0x73>
  8020e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e8:	8b 00                	mov    (%eax),%eax
  8020ea:	eb 05                	jmp    8020f1 <print_blocks_list+0x78>
  8020ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f1:	89 45 10             	mov    %eax,0x10(%ebp)
  8020f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	75 ad                	jne    8020a8 <print_blocks_list+0x2f>
  8020fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ff:	75 a7                	jne    8020a8 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802101:	83 ec 0c             	sub    $0xc,%esp
  802104:	68 98 44 80 00       	push   $0x804498
  802109:	e8 ba e2 ff ff       	call   8003c8 <cprintf>
  80210e:	83 c4 10             	add    $0x10,%esp

}
  802111:	90                   	nop
  802112:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80211d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802120:	83 e0 01             	and    $0x1,%eax
  802123:	85 c0                	test   %eax,%eax
  802125:	74 03                	je     80212a <initialize_dynamic_allocator+0x13>
  802127:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80212a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80212e:	0f 84 c7 01 00 00    	je     8022fb <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802134:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80213b:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  80213e:	8b 55 08             	mov    0x8(%ebp),%edx
  802141:	8b 45 0c             	mov    0xc(%ebp),%eax
  802144:	01 d0                	add    %edx,%eax
  802146:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80214b:	0f 87 ad 01 00 00    	ja     8022fe <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	85 c0                	test   %eax,%eax
  802156:	0f 89 a5 01 00 00    	jns    802301 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80215c:	8b 55 08             	mov    0x8(%ebp),%edx
  80215f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802162:	01 d0                	add    %edx,%eax
  802164:	83 e8 04             	sub    $0x4,%eax
  802167:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  80216c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802173:	a1 30 50 80 00       	mov    0x805030,%eax
  802178:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217b:	e9 87 00 00 00       	jmp    802207 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802184:	75 14                	jne    80219a <initialize_dynamic_allocator+0x83>
  802186:	83 ec 04             	sub    $0x4,%esp
  802189:	68 f3 44 80 00       	push   $0x8044f3
  80218e:	6a 79                	push   $0x79
  802190:	68 11 45 80 00       	push   $0x804511
  802195:	e8 ee 18 00 00       	call   803a88 <_panic>
  80219a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219d:	8b 00                	mov    (%eax),%eax
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	74 10                	je     8021b3 <initialize_dynamic_allocator+0x9c>
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 00                	mov    (%eax),%eax
  8021a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ab:	8b 52 04             	mov    0x4(%edx),%edx
  8021ae:	89 50 04             	mov    %edx,0x4(%eax)
  8021b1:	eb 0b                	jmp    8021be <initialize_dynamic_allocator+0xa7>
  8021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b6:	8b 40 04             	mov    0x4(%eax),%eax
  8021b9:	a3 34 50 80 00       	mov    %eax,0x805034
  8021be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c1:	8b 40 04             	mov    0x4(%eax),%eax
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	74 0f                	je     8021d7 <initialize_dynamic_allocator+0xc0>
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 40 04             	mov    0x4(%eax),%eax
  8021ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d1:	8b 12                	mov    (%edx),%edx
  8021d3:	89 10                	mov    %edx,(%eax)
  8021d5:	eb 0a                	jmp    8021e1 <initialize_dynamic_allocator+0xca>
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	8b 00                	mov    (%eax),%eax
  8021dc:	a3 30 50 80 00       	mov    %eax,0x805030
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8021f9:	48                   	dec    %eax
  8021fa:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021ff:	a1 38 50 80 00       	mov    0x805038,%eax
  802204:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802207:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220b:	74 07                	je     802214 <initialize_dynamic_allocator+0xfd>
  80220d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802210:	8b 00                	mov    (%eax),%eax
  802212:	eb 05                	jmp    802219 <initialize_dynamic_allocator+0x102>
  802214:	b8 00 00 00 00       	mov    $0x0,%eax
  802219:	a3 38 50 80 00       	mov    %eax,0x805038
  80221e:	a1 38 50 80 00       	mov    0x805038,%eax
  802223:	85 c0                	test   %eax,%eax
  802225:	0f 85 55 ff ff ff    	jne    802180 <initialize_dynamic_allocator+0x69>
  80222b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222f:	0f 85 4b ff ff ff    	jne    802180 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80223b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802244:	a1 48 50 80 00       	mov    0x805048,%eax
  802249:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  80224e:	a1 44 50 80 00       	mov    0x805044,%eax
  802253:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	83 c0 08             	add    $0x8,%eax
  80225f:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	83 c0 04             	add    $0x4,%eax
  802268:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226b:	83 ea 08             	sub    $0x8,%edx
  80226e:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802270:	8b 55 0c             	mov    0xc(%ebp),%edx
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	01 d0                	add    %edx,%eax
  802278:	83 e8 08             	sub    $0x8,%eax
  80227b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227e:	83 ea 08             	sub    $0x8,%edx
  802281:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802283:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802286:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80228c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802296:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80229a:	75 17                	jne    8022b3 <initialize_dynamic_allocator+0x19c>
  80229c:	83 ec 04             	sub    $0x4,%esp
  80229f:	68 2c 45 80 00       	push   $0x80452c
  8022a4:	68 90 00 00 00       	push   $0x90
  8022a9:	68 11 45 80 00       	push   $0x804511
  8022ae:	e8 d5 17 00 00       	call   803a88 <_panic>
  8022b3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8022b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bc:	89 10                	mov    %edx,(%eax)
  8022be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c1:	8b 00                	mov    (%eax),%eax
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	74 0d                	je     8022d4 <initialize_dynamic_allocator+0x1bd>
  8022c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8022cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022cf:	89 50 04             	mov    %edx,0x4(%eax)
  8022d2:	eb 08                	jmp    8022dc <initialize_dynamic_allocator+0x1c5>
  8022d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8022dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022df:	a3 30 50 80 00       	mov    %eax,0x805030
  8022e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8022f3:	40                   	inc    %eax
  8022f4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8022f9:	eb 07                	jmp    802302 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022fb:	90                   	nop
  8022fc:	eb 04                	jmp    802302 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022fe:	90                   	nop
  8022ff:	eb 01                	jmp    802302 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802301:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802307:	8b 45 10             	mov    0x10(%ebp),%eax
  80230a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	8d 50 fc             	lea    -0x4(%eax),%edx
  802313:	8b 45 0c             	mov    0xc(%ebp),%eax
  802316:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	83 e8 04             	sub    $0x4,%eax
  80231e:	8b 00                	mov    (%eax),%eax
  802320:	83 e0 fe             	and    $0xfffffffe,%eax
  802323:	8d 50 f8             	lea    -0x8(%eax),%edx
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	01 c2                	add    %eax,%edx
  80232b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232e:	89 02                	mov    %eax,(%edx)
}
  802330:	90                   	nop
  802331:	5d                   	pop    %ebp
  802332:	c3                   	ret    

00802333 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	83 e0 01             	and    $0x1,%eax
  80233f:	85 c0                	test   %eax,%eax
  802341:	74 03                	je     802346 <alloc_block_FF+0x13>
  802343:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802346:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80234a:	77 07                	ja     802353 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80234c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802353:	a1 28 50 80 00       	mov    0x805028,%eax
  802358:	85 c0                	test   %eax,%eax
  80235a:	75 73                	jne    8023cf <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	83 c0 10             	add    $0x10,%eax
  802362:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802365:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80236c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80236f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802372:	01 d0                	add    %edx,%eax
  802374:	48                   	dec    %eax
  802375:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80237b:	ba 00 00 00 00       	mov    $0x0,%edx
  802380:	f7 75 ec             	divl   -0x14(%ebp)
  802383:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802386:	29 d0                	sub    %edx,%eax
  802388:	c1 e8 0c             	shr    $0xc,%eax
  80238b:	83 ec 0c             	sub    $0xc,%esp
  80238e:	50                   	push   %eax
  80238f:	e8 d6 ef ff ff       	call   80136a <sbrk>
  802394:	83 c4 10             	add    $0x10,%esp
  802397:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80239a:	83 ec 0c             	sub    $0xc,%esp
  80239d:	6a 00                	push   $0x0
  80239f:	e8 c6 ef ff ff       	call   80136a <sbrk>
  8023a4:	83 c4 10             	add    $0x10,%esp
  8023a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8023aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ad:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8023b0:	83 ec 08             	sub    $0x8,%esp
  8023b3:	50                   	push   %eax
  8023b4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023b7:	e8 5b fd ff ff       	call   802117 <initialize_dynamic_allocator>
  8023bc:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8023bf:	83 ec 0c             	sub    $0xc,%esp
  8023c2:	68 4f 45 80 00       	push   $0x80454f
  8023c7:	e8 fc df ff ff       	call   8003c8 <cprintf>
  8023cc:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8023cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d3:	75 0a                	jne    8023df <alloc_block_FF+0xac>
	        return NULL;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023da:	e9 0e 04 00 00       	jmp    8027ed <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8023df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023e6:	a1 30 50 80 00       	mov    0x805030,%eax
  8023eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ee:	e9 f3 02 00 00       	jmp    8026e6 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023f9:	83 ec 0c             	sub    $0xc,%esp
  8023fc:	ff 75 bc             	pushl  -0x44(%ebp)
  8023ff:	e8 af fb ff ff       	call   801fb3 <get_block_size>
  802404:	83 c4 10             	add    $0x10,%esp
  802407:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	83 c0 08             	add    $0x8,%eax
  802410:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802413:	0f 87 c5 02 00 00    	ja     8026de <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	83 c0 18             	add    $0x18,%eax
  80241f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802422:	0f 87 19 02 00 00    	ja     802641 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802428:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80242b:	2b 45 08             	sub    0x8(%ebp),%eax
  80242e:	83 e8 08             	sub    $0x8,%eax
  802431:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	8d 50 08             	lea    0x8(%eax),%edx
  80243a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80243d:	01 d0                	add    %edx,%eax
  80243f:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	83 c0 08             	add    $0x8,%eax
  802448:	83 ec 04             	sub    $0x4,%esp
  80244b:	6a 01                	push   $0x1
  80244d:	50                   	push   %eax
  80244e:	ff 75 bc             	pushl  -0x44(%ebp)
  802451:	e8 ae fe ff ff       	call   802304 <set_block_data>
  802456:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 40 04             	mov    0x4(%eax),%eax
  80245f:	85 c0                	test   %eax,%eax
  802461:	75 68                	jne    8024cb <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802463:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802467:	75 17                	jne    802480 <alloc_block_FF+0x14d>
  802469:	83 ec 04             	sub    $0x4,%esp
  80246c:	68 2c 45 80 00       	push   $0x80452c
  802471:	68 d7 00 00 00       	push   $0xd7
  802476:	68 11 45 80 00       	push   $0x804511
  80247b:	e8 08 16 00 00       	call   803a88 <_panic>
  802480:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802486:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802489:	89 10                	mov    %edx,(%eax)
  80248b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248e:	8b 00                	mov    (%eax),%eax
  802490:	85 c0                	test   %eax,%eax
  802492:	74 0d                	je     8024a1 <alloc_block_FF+0x16e>
  802494:	a1 30 50 80 00       	mov    0x805030,%eax
  802499:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80249c:	89 50 04             	mov    %edx,0x4(%eax)
  80249f:	eb 08                	jmp    8024a9 <alloc_block_FF+0x176>
  8024a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a4:	a3 34 50 80 00       	mov    %eax,0x805034
  8024a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8024b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024bb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8024c0:	40                   	inc    %eax
  8024c1:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8024c6:	e9 dc 00 00 00       	jmp    8025a7 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 00                	mov    (%eax),%eax
  8024d0:	85 c0                	test   %eax,%eax
  8024d2:	75 65                	jne    802539 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8024d4:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024d8:	75 17                	jne    8024f1 <alloc_block_FF+0x1be>
  8024da:	83 ec 04             	sub    $0x4,%esp
  8024dd:	68 60 45 80 00       	push   $0x804560
  8024e2:	68 db 00 00 00       	push   $0xdb
  8024e7:	68 11 45 80 00       	push   $0x804511
  8024ec:	e8 97 15 00 00       	call   803a88 <_panic>
  8024f1:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8024f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024fa:	89 50 04             	mov    %edx,0x4(%eax)
  8024fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802500:	8b 40 04             	mov    0x4(%eax),%eax
  802503:	85 c0                	test   %eax,%eax
  802505:	74 0c                	je     802513 <alloc_block_FF+0x1e0>
  802507:	a1 34 50 80 00       	mov    0x805034,%eax
  80250c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80250f:	89 10                	mov    %edx,(%eax)
  802511:	eb 08                	jmp    80251b <alloc_block_FF+0x1e8>
  802513:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802516:	a3 30 50 80 00       	mov    %eax,0x805030
  80251b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80251e:	a3 34 50 80 00       	mov    %eax,0x805034
  802523:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802531:	40                   	inc    %eax
  802532:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802537:	eb 6e                	jmp    8025a7 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802539:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253d:	74 06                	je     802545 <alloc_block_FF+0x212>
  80253f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802543:	75 17                	jne    80255c <alloc_block_FF+0x229>
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	68 84 45 80 00       	push   $0x804584
  80254d:	68 df 00 00 00       	push   $0xdf
  802552:	68 11 45 80 00       	push   $0x804511
  802557:	e8 2c 15 00 00       	call   803a88 <_panic>
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	8b 10                	mov    (%eax),%edx
  802561:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802564:	89 10                	mov    %edx,(%eax)
  802566:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 0b                	je     80257a <alloc_block_FF+0x247>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 00                	mov    (%eax),%eax
  802574:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802577:	89 50 04             	mov    %edx,0x4(%eax)
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802580:	89 10                	mov    %edx,(%eax)
  802582:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802588:	89 50 04             	mov    %edx,0x4(%eax)
  80258b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	75 08                	jne    80259c <alloc_block_FF+0x269>
  802594:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802597:	a3 34 50 80 00       	mov    %eax,0x805034
  80259c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8025a1:	40                   	inc    %eax
  8025a2:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8025a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ab:	75 17                	jne    8025c4 <alloc_block_FF+0x291>
  8025ad:	83 ec 04             	sub    $0x4,%esp
  8025b0:	68 f3 44 80 00       	push   $0x8044f3
  8025b5:	68 e1 00 00 00       	push   $0xe1
  8025ba:	68 11 45 80 00       	push   $0x804511
  8025bf:	e8 c4 14 00 00       	call   803a88 <_panic>
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	74 10                	je     8025dd <alloc_block_FF+0x2aa>
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d5:	8b 52 04             	mov    0x4(%edx),%edx
  8025d8:	89 50 04             	mov    %edx,0x4(%eax)
  8025db:	eb 0b                	jmp    8025e8 <alloc_block_FF+0x2b5>
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	8b 40 04             	mov    0x4(%eax),%eax
  8025e3:	a3 34 50 80 00       	mov    %eax,0x805034
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	74 0f                	je     802601 <alloc_block_FF+0x2ce>
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 40 04             	mov    0x4(%eax),%eax
  8025f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fb:	8b 12                	mov    (%edx),%edx
  8025fd:	89 10                	mov    %edx,(%eax)
  8025ff:	eb 0a                	jmp    80260b <alloc_block_FF+0x2d8>
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	a3 30 50 80 00       	mov    %eax,0x805030
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802623:	48                   	dec    %eax
  802624:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  802629:	83 ec 04             	sub    $0x4,%esp
  80262c:	6a 00                	push   $0x0
  80262e:	ff 75 b4             	pushl  -0x4c(%ebp)
  802631:	ff 75 b0             	pushl  -0x50(%ebp)
  802634:	e8 cb fc ff ff       	call   802304 <set_block_data>
  802639:	83 c4 10             	add    $0x10,%esp
  80263c:	e9 95 00 00 00       	jmp    8026d6 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802641:	83 ec 04             	sub    $0x4,%esp
  802644:	6a 01                	push   $0x1
  802646:	ff 75 b8             	pushl  -0x48(%ebp)
  802649:	ff 75 bc             	pushl  -0x44(%ebp)
  80264c:	e8 b3 fc ff ff       	call   802304 <set_block_data>
  802651:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802654:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802658:	75 17                	jne    802671 <alloc_block_FF+0x33e>
  80265a:	83 ec 04             	sub    $0x4,%esp
  80265d:	68 f3 44 80 00       	push   $0x8044f3
  802662:	68 e8 00 00 00       	push   $0xe8
  802667:	68 11 45 80 00       	push   $0x804511
  80266c:	e8 17 14 00 00       	call   803a88 <_panic>
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 00                	mov    (%eax),%eax
  802676:	85 c0                	test   %eax,%eax
  802678:	74 10                	je     80268a <alloc_block_FF+0x357>
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 00                	mov    (%eax),%eax
  80267f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802682:	8b 52 04             	mov    0x4(%edx),%edx
  802685:	89 50 04             	mov    %edx,0x4(%eax)
  802688:	eb 0b                	jmp    802695 <alloc_block_FF+0x362>
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 40 04             	mov    0x4(%eax),%eax
  802690:	a3 34 50 80 00       	mov    %eax,0x805034
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 40 04             	mov    0x4(%eax),%eax
  80269b:	85 c0                	test   %eax,%eax
  80269d:	74 0f                	je     8026ae <alloc_block_FF+0x37b>
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 40 04             	mov    0x4(%eax),%eax
  8026a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a8:	8b 12                	mov    (%edx),%edx
  8026aa:	89 10                	mov    %edx,(%eax)
  8026ac:	eb 0a                	jmp    8026b8 <alloc_block_FF+0x385>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026cb:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8026d0:	48                   	dec    %eax
  8026d1:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  8026d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026d9:	e9 0f 01 00 00       	jmp    8027ed <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8026de:	a1 38 50 80 00       	mov    0x805038,%eax
  8026e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ea:	74 07                	je     8026f3 <alloc_block_FF+0x3c0>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	eb 05                	jmp    8026f8 <alloc_block_FF+0x3c5>
  8026f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f8:	a3 38 50 80 00       	mov    %eax,0x805038
  8026fd:	a1 38 50 80 00       	mov    0x805038,%eax
  802702:	85 c0                	test   %eax,%eax
  802704:	0f 85 e9 fc ff ff    	jne    8023f3 <alloc_block_FF+0xc0>
  80270a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270e:	0f 85 df fc ff ff    	jne    8023f3 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	83 c0 08             	add    $0x8,%eax
  80271a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80271d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802724:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802727:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80272a:	01 d0                	add    %edx,%eax
  80272c:	48                   	dec    %eax
  80272d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802730:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802733:	ba 00 00 00 00       	mov    $0x0,%edx
  802738:	f7 75 d8             	divl   -0x28(%ebp)
  80273b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80273e:	29 d0                	sub    %edx,%eax
  802740:	c1 e8 0c             	shr    $0xc,%eax
  802743:	83 ec 0c             	sub    $0xc,%esp
  802746:	50                   	push   %eax
  802747:	e8 1e ec ff ff       	call   80136a <sbrk>
  80274c:	83 c4 10             	add    $0x10,%esp
  80274f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802752:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802756:	75 0a                	jne    802762 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802758:	b8 00 00 00 00       	mov    $0x0,%eax
  80275d:	e9 8b 00 00 00       	jmp    8027ed <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802762:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802769:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80276c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80276f:	01 d0                	add    %edx,%eax
  802771:	48                   	dec    %eax
  802772:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802775:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802778:	ba 00 00 00 00       	mov    $0x0,%edx
  80277d:	f7 75 cc             	divl   -0x34(%ebp)
  802780:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802783:	29 d0                	sub    %edx,%eax
  802785:	8d 50 fc             	lea    -0x4(%eax),%edx
  802788:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80278b:	01 d0                	add    %edx,%eax
  80278d:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  802792:	a1 44 50 80 00       	mov    0x805044,%eax
  802797:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80279d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8027a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027aa:	01 d0                	add    %edx,%eax
  8027ac:	48                   	dec    %eax
  8027ad:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8027b0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027b8:	f7 75 c4             	divl   -0x3c(%ebp)
  8027bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027be:	29 d0                	sub    %edx,%eax
  8027c0:	83 ec 04             	sub    $0x4,%esp
  8027c3:	6a 01                	push   $0x1
  8027c5:	50                   	push   %eax
  8027c6:	ff 75 d0             	pushl  -0x30(%ebp)
  8027c9:	e8 36 fb ff ff       	call   802304 <set_block_data>
  8027ce:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8027d1:	83 ec 0c             	sub    $0xc,%esp
  8027d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8027d7:	e8 1b 0a 00 00       	call   8031f7 <free_block>
  8027dc:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8027df:	83 ec 0c             	sub    $0xc,%esp
  8027e2:	ff 75 08             	pushl  0x8(%ebp)
  8027e5:	e8 49 fb ff ff       	call   802333 <alloc_block_FF>
  8027ea:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8027ed:	c9                   	leave  
  8027ee:	c3                   	ret    

008027ef <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8027ef:	55                   	push   %ebp
  8027f0:	89 e5                	mov    %esp,%ebp
  8027f2:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	83 e0 01             	and    $0x1,%eax
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	74 03                	je     802802 <alloc_block_BF+0x13>
  8027ff:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802802:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802806:	77 07                	ja     80280f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802808:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80280f:	a1 28 50 80 00       	mov    0x805028,%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	75 73                	jne    80288b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802818:	8b 45 08             	mov    0x8(%ebp),%eax
  80281b:	83 c0 10             	add    $0x10,%eax
  80281e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802821:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802828:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80282b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80282e:	01 d0                	add    %edx,%eax
  802830:	48                   	dec    %eax
  802831:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802834:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802837:	ba 00 00 00 00       	mov    $0x0,%edx
  80283c:	f7 75 e0             	divl   -0x20(%ebp)
  80283f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802842:	29 d0                	sub    %edx,%eax
  802844:	c1 e8 0c             	shr    $0xc,%eax
  802847:	83 ec 0c             	sub    $0xc,%esp
  80284a:	50                   	push   %eax
  80284b:	e8 1a eb ff ff       	call   80136a <sbrk>
  802850:	83 c4 10             	add    $0x10,%esp
  802853:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802856:	83 ec 0c             	sub    $0xc,%esp
  802859:	6a 00                	push   $0x0
  80285b:	e8 0a eb ff ff       	call   80136a <sbrk>
  802860:	83 c4 10             	add    $0x10,%esp
  802863:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802866:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802869:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80286c:	83 ec 08             	sub    $0x8,%esp
  80286f:	50                   	push   %eax
  802870:	ff 75 d8             	pushl  -0x28(%ebp)
  802873:	e8 9f f8 ff ff       	call   802117 <initialize_dynamic_allocator>
  802878:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80287b:	83 ec 0c             	sub    $0xc,%esp
  80287e:	68 4f 45 80 00       	push   $0x80454f
  802883:	e8 40 db ff ff       	call   8003c8 <cprintf>
  802888:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80288b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802892:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802899:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8028a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8028a7:	a1 30 50 80 00       	mov    0x805030,%eax
  8028ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028af:	e9 1d 01 00 00       	jmp    8029d1 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8028ba:	83 ec 0c             	sub    $0xc,%esp
  8028bd:	ff 75 a8             	pushl  -0x58(%ebp)
  8028c0:	e8 ee f6 ff ff       	call   801fb3 <get_block_size>
  8028c5:	83 c4 10             	add    $0x10,%esp
  8028c8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ce:	83 c0 08             	add    $0x8,%eax
  8028d1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028d4:	0f 87 ef 00 00 00    	ja     8029c9 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8028da:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dd:	83 c0 18             	add    $0x18,%eax
  8028e0:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028e3:	77 1d                	ja     802902 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8028e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028eb:	0f 86 d8 00 00 00    	jbe    8029c9 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028f7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028fd:	e9 c7 00 00 00       	jmp    8029c9 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	83 c0 08             	add    $0x8,%eax
  802908:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80290b:	0f 85 9d 00 00 00    	jne    8029ae <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802911:	83 ec 04             	sub    $0x4,%esp
  802914:	6a 01                	push   $0x1
  802916:	ff 75 a4             	pushl  -0x5c(%ebp)
  802919:	ff 75 a8             	pushl  -0x58(%ebp)
  80291c:	e8 e3 f9 ff ff       	call   802304 <set_block_data>
  802921:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802924:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802928:	75 17                	jne    802941 <alloc_block_BF+0x152>
  80292a:	83 ec 04             	sub    $0x4,%esp
  80292d:	68 f3 44 80 00       	push   $0x8044f3
  802932:	68 2c 01 00 00       	push   $0x12c
  802937:	68 11 45 80 00       	push   $0x804511
  80293c:	e8 47 11 00 00       	call   803a88 <_panic>
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 00                	mov    (%eax),%eax
  802946:	85 c0                	test   %eax,%eax
  802948:	74 10                	je     80295a <alloc_block_BF+0x16b>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802952:	8b 52 04             	mov    0x4(%edx),%edx
  802955:	89 50 04             	mov    %edx,0x4(%eax)
  802958:	eb 0b                	jmp    802965 <alloc_block_BF+0x176>
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	8b 40 04             	mov    0x4(%eax),%eax
  802960:	a3 34 50 80 00       	mov    %eax,0x805034
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	74 0f                	je     80297e <alloc_block_BF+0x18f>
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 40 04             	mov    0x4(%eax),%eax
  802975:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802978:	8b 12                	mov    (%edx),%edx
  80297a:	89 10                	mov    %edx,(%eax)
  80297c:	eb 0a                	jmp    802988 <alloc_block_BF+0x199>
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	a3 30 50 80 00       	mov    %eax,0x805030
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029a0:	48                   	dec    %eax
  8029a1:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  8029a6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029a9:	e9 24 04 00 00       	jmp    802dd2 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8029ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b1:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8029b4:	76 13                	jbe    8029c9 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8029b6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8029bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8029c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8029c3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8029c6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8029c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8029ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d5:	74 07                	je     8029de <alloc_block_BF+0x1ef>
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 00                	mov    (%eax),%eax
  8029dc:	eb 05                	jmp    8029e3 <alloc_block_BF+0x1f4>
  8029de:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e3:	a3 38 50 80 00       	mov    %eax,0x805038
  8029e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029ed:	85 c0                	test   %eax,%eax
  8029ef:	0f 85 bf fe ff ff    	jne    8028b4 <alloc_block_BF+0xc5>
  8029f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f9:	0f 85 b5 fe ff ff    	jne    8028b4 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a03:	0f 84 26 02 00 00    	je     802c2f <alloc_block_BF+0x440>
  802a09:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a0d:	0f 85 1c 02 00 00    	jne    802c2f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a16:	2b 45 08             	sub    0x8(%ebp),%eax
  802a19:	83 e8 08             	sub    $0x8,%eax
  802a1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	8d 50 08             	lea    0x8(%eax),%edx
  802a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a28:	01 d0                	add    %edx,%eax
  802a2a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	83 c0 08             	add    $0x8,%eax
  802a33:	83 ec 04             	sub    $0x4,%esp
  802a36:	6a 01                	push   $0x1
  802a38:	50                   	push   %eax
  802a39:	ff 75 f0             	pushl  -0x10(%ebp)
  802a3c:	e8 c3 f8 ff ff       	call   802304 <set_block_data>
  802a41:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a47:	8b 40 04             	mov    0x4(%eax),%eax
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	75 68                	jne    802ab6 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a4e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a52:	75 17                	jne    802a6b <alloc_block_BF+0x27c>
  802a54:	83 ec 04             	sub    $0x4,%esp
  802a57:	68 2c 45 80 00       	push   $0x80452c
  802a5c:	68 45 01 00 00       	push   $0x145
  802a61:	68 11 45 80 00       	push   $0x804511
  802a66:	e8 1d 10 00 00       	call   803a88 <_panic>
  802a6b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a71:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a74:	89 10                	mov    %edx,(%eax)
  802a76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a79:	8b 00                	mov    (%eax),%eax
  802a7b:	85 c0                	test   %eax,%eax
  802a7d:	74 0d                	je     802a8c <alloc_block_BF+0x29d>
  802a7f:	a1 30 50 80 00       	mov    0x805030,%eax
  802a84:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a87:	89 50 04             	mov    %edx,0x4(%eax)
  802a8a:	eb 08                	jmp    802a94 <alloc_block_BF+0x2a5>
  802a8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8f:	a3 34 50 80 00       	mov    %eax,0x805034
  802a94:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a97:	a3 30 50 80 00       	mov    %eax,0x805030
  802a9c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802aab:	40                   	inc    %eax
  802aac:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ab1:	e9 dc 00 00 00       	jmp    802b92 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab9:	8b 00                	mov    (%eax),%eax
  802abb:	85 c0                	test   %eax,%eax
  802abd:	75 65                	jne    802b24 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802abf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802ac3:	75 17                	jne    802adc <alloc_block_BF+0x2ed>
  802ac5:	83 ec 04             	sub    $0x4,%esp
  802ac8:	68 60 45 80 00       	push   $0x804560
  802acd:	68 4a 01 00 00       	push   $0x14a
  802ad2:	68 11 45 80 00       	push   $0x804511
  802ad7:	e8 ac 0f 00 00       	call   803a88 <_panic>
  802adc:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802ae2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ae5:	89 50 04             	mov    %edx,0x4(%eax)
  802ae8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aeb:	8b 40 04             	mov    0x4(%eax),%eax
  802aee:	85 c0                	test   %eax,%eax
  802af0:	74 0c                	je     802afe <alloc_block_BF+0x30f>
  802af2:	a1 34 50 80 00       	mov    0x805034,%eax
  802af7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802afa:	89 10                	mov    %edx,(%eax)
  802afc:	eb 08                	jmp    802b06 <alloc_block_BF+0x317>
  802afe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b01:	a3 30 50 80 00       	mov    %eax,0x805030
  802b06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b09:	a3 34 50 80 00       	mov    %eax,0x805034
  802b0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b17:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b1c:	40                   	inc    %eax
  802b1d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802b22:	eb 6e                	jmp    802b92 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802b24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b28:	74 06                	je     802b30 <alloc_block_BF+0x341>
  802b2a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802b2e:	75 17                	jne    802b47 <alloc_block_BF+0x358>
  802b30:	83 ec 04             	sub    $0x4,%esp
  802b33:	68 84 45 80 00       	push   $0x804584
  802b38:	68 4f 01 00 00       	push   $0x14f
  802b3d:	68 11 45 80 00       	push   $0x804511
  802b42:	e8 41 0f 00 00       	call   803a88 <_panic>
  802b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4a:	8b 10                	mov    (%eax),%edx
  802b4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b4f:	89 10                	mov    %edx,(%eax)
  802b51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	85 c0                	test   %eax,%eax
  802b58:	74 0b                	je     802b65 <alloc_block_BF+0x376>
  802b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b62:	89 50 04             	mov    %edx,0x4(%eax)
  802b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b68:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b6b:	89 10                	mov    %edx,(%eax)
  802b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b73:	89 50 04             	mov    %edx,0x4(%eax)
  802b76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	75 08                	jne    802b87 <alloc_block_BF+0x398>
  802b7f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b82:	a3 34 50 80 00       	mov    %eax,0x805034
  802b87:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802b8c:	40                   	inc    %eax
  802b8d:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b96:	75 17                	jne    802baf <alloc_block_BF+0x3c0>
  802b98:	83 ec 04             	sub    $0x4,%esp
  802b9b:	68 f3 44 80 00       	push   $0x8044f3
  802ba0:	68 51 01 00 00       	push   $0x151
  802ba5:	68 11 45 80 00       	push   $0x804511
  802baa:	e8 d9 0e 00 00       	call   803a88 <_panic>
  802baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	74 10                	je     802bc8 <alloc_block_BF+0x3d9>
  802bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc0:	8b 52 04             	mov    0x4(%edx),%edx
  802bc3:	89 50 04             	mov    %edx,0x4(%eax)
  802bc6:	eb 0b                	jmp    802bd3 <alloc_block_BF+0x3e4>
  802bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcb:	8b 40 04             	mov    0x4(%eax),%eax
  802bce:	a3 34 50 80 00       	mov    %eax,0x805034
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	8b 40 04             	mov    0x4(%eax),%eax
  802bd9:	85 c0                	test   %eax,%eax
  802bdb:	74 0f                	je     802bec <alloc_block_BF+0x3fd>
  802bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be0:	8b 40 04             	mov    0x4(%eax),%eax
  802be3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be6:	8b 12                	mov    (%edx),%edx
  802be8:	89 10                	mov    %edx,(%eax)
  802bea:	eb 0a                	jmp    802bf6 <alloc_block_BF+0x407>
  802bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bef:	8b 00                	mov    (%eax),%eax
  802bf1:	a3 30 50 80 00       	mov    %eax,0x805030
  802bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c09:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c0e:	48                   	dec    %eax
  802c0f:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802c14:	83 ec 04             	sub    $0x4,%esp
  802c17:	6a 00                	push   $0x0
  802c19:	ff 75 d0             	pushl  -0x30(%ebp)
  802c1c:	ff 75 cc             	pushl  -0x34(%ebp)
  802c1f:	e8 e0 f6 ff ff       	call   802304 <set_block_data>
  802c24:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2a:	e9 a3 01 00 00       	jmp    802dd2 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802c2f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802c33:	0f 85 9d 00 00 00    	jne    802cd6 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802c39:	83 ec 04             	sub    $0x4,%esp
  802c3c:	6a 01                	push   $0x1
  802c3e:	ff 75 ec             	pushl  -0x14(%ebp)
  802c41:	ff 75 f0             	pushl  -0x10(%ebp)
  802c44:	e8 bb f6 ff ff       	call   802304 <set_block_data>
  802c49:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802c4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c50:	75 17                	jne    802c69 <alloc_block_BF+0x47a>
  802c52:	83 ec 04             	sub    $0x4,%esp
  802c55:	68 f3 44 80 00       	push   $0x8044f3
  802c5a:	68 58 01 00 00       	push   $0x158
  802c5f:	68 11 45 80 00       	push   $0x804511
  802c64:	e8 1f 0e 00 00       	call   803a88 <_panic>
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 10                	je     802c82 <alloc_block_BF+0x493>
  802c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7a:	8b 52 04             	mov    0x4(%edx),%edx
  802c7d:	89 50 04             	mov    %edx,0x4(%eax)
  802c80:	eb 0b                	jmp    802c8d <alloc_block_BF+0x49e>
  802c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c85:	8b 40 04             	mov    0x4(%eax),%eax
  802c88:	a3 34 50 80 00       	mov    %eax,0x805034
  802c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c90:	8b 40 04             	mov    0x4(%eax),%eax
  802c93:	85 c0                	test   %eax,%eax
  802c95:	74 0f                	je     802ca6 <alloc_block_BF+0x4b7>
  802c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9a:	8b 40 04             	mov    0x4(%eax),%eax
  802c9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca0:	8b 12                	mov    (%edx),%edx
  802ca2:	89 10                	mov    %edx,(%eax)
  802ca4:	eb 0a                	jmp    802cb0 <alloc_block_BF+0x4c1>
  802ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca9:	8b 00                	mov    (%eax),%eax
  802cab:	a3 30 50 80 00       	mov    %eax,0x805030
  802cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802cc8:	48                   	dec    %eax
  802cc9:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd1:	e9 fc 00 00 00       	jmp    802dd2 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	83 c0 08             	add    $0x8,%eax
  802cdc:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802cdf:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ce6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ce9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802cec:	01 d0                	add    %edx,%eax
  802cee:	48                   	dec    %eax
  802cef:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802cf2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802cf5:	ba 00 00 00 00       	mov    $0x0,%edx
  802cfa:	f7 75 c4             	divl   -0x3c(%ebp)
  802cfd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d00:	29 d0                	sub    %edx,%eax
  802d02:	c1 e8 0c             	shr    $0xc,%eax
  802d05:	83 ec 0c             	sub    $0xc,%esp
  802d08:	50                   	push   %eax
  802d09:	e8 5c e6 ff ff       	call   80136a <sbrk>
  802d0e:	83 c4 10             	add    $0x10,%esp
  802d11:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802d14:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802d18:	75 0a                	jne    802d24 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802d1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1f:	e9 ae 00 00 00       	jmp    802dd2 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802d24:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802d2b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d2e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802d31:	01 d0                	add    %edx,%eax
  802d33:	48                   	dec    %eax
  802d34:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802d37:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d3f:	f7 75 b8             	divl   -0x48(%ebp)
  802d42:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802d45:	29 d0                	sub    %edx,%eax
  802d47:	8d 50 fc             	lea    -0x4(%eax),%edx
  802d4a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d4d:	01 d0                	add    %edx,%eax
  802d4f:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802d54:	a1 44 50 80 00       	mov    0x805044,%eax
  802d59:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802d5f:	83 ec 0c             	sub    $0xc,%esp
  802d62:	68 b8 45 80 00       	push   $0x8045b8
  802d67:	e8 5c d6 ff ff       	call   8003c8 <cprintf>
  802d6c:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802d6f:	83 ec 08             	sub    $0x8,%esp
  802d72:	ff 75 bc             	pushl  -0x44(%ebp)
  802d75:	68 bd 45 80 00       	push   $0x8045bd
  802d7a:	e8 49 d6 ff ff       	call   8003c8 <cprintf>
  802d7f:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d82:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d89:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d8c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d8f:	01 d0                	add    %edx,%eax
  802d91:	48                   	dec    %eax
  802d92:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d95:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d98:	ba 00 00 00 00       	mov    $0x0,%edx
  802d9d:	f7 75 b0             	divl   -0x50(%ebp)
  802da0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802da3:	29 d0                	sub    %edx,%eax
  802da5:	83 ec 04             	sub    $0x4,%esp
  802da8:	6a 01                	push   $0x1
  802daa:	50                   	push   %eax
  802dab:	ff 75 bc             	pushl  -0x44(%ebp)
  802dae:	e8 51 f5 ff ff       	call   802304 <set_block_data>
  802db3:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802db6:	83 ec 0c             	sub    $0xc,%esp
  802db9:	ff 75 bc             	pushl  -0x44(%ebp)
  802dbc:	e8 36 04 00 00       	call   8031f7 <free_block>
  802dc1:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802dc4:	83 ec 0c             	sub    $0xc,%esp
  802dc7:	ff 75 08             	pushl  0x8(%ebp)
  802dca:	e8 20 fa ff ff       	call   8027ef <alloc_block_BF>
  802dcf:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802dd2:	c9                   	leave  
  802dd3:	c3                   	ret    

00802dd4 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802dd4:	55                   	push   %ebp
  802dd5:	89 e5                	mov    %esp,%ebp
  802dd7:	53                   	push   %ebx
  802dd8:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ddb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802de2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ded:	74 1e                	je     802e0d <merging+0x39>
  802def:	ff 75 08             	pushl  0x8(%ebp)
  802df2:	e8 bc f1 ff ff       	call   801fb3 <get_block_size>
  802df7:	83 c4 04             	add    $0x4,%esp
  802dfa:	89 c2                	mov    %eax,%edx
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	01 d0                	add    %edx,%eax
  802e01:	3b 45 10             	cmp    0x10(%ebp),%eax
  802e04:	75 07                	jne    802e0d <merging+0x39>
		prev_is_free = 1;
  802e06:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802e0d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e11:	74 1e                	je     802e31 <merging+0x5d>
  802e13:	ff 75 10             	pushl  0x10(%ebp)
  802e16:	e8 98 f1 ff ff       	call   801fb3 <get_block_size>
  802e1b:	83 c4 04             	add    $0x4,%esp
  802e1e:	89 c2                	mov    %eax,%edx
  802e20:	8b 45 10             	mov    0x10(%ebp),%eax
  802e23:	01 d0                	add    %edx,%eax
  802e25:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e28:	75 07                	jne    802e31 <merging+0x5d>
		next_is_free = 1;
  802e2a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e35:	0f 84 cc 00 00 00    	je     802f07 <merging+0x133>
  802e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e3f:	0f 84 c2 00 00 00    	je     802f07 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802e45:	ff 75 08             	pushl  0x8(%ebp)
  802e48:	e8 66 f1 ff ff       	call   801fb3 <get_block_size>
  802e4d:	83 c4 04             	add    $0x4,%esp
  802e50:	89 c3                	mov    %eax,%ebx
  802e52:	ff 75 10             	pushl  0x10(%ebp)
  802e55:	e8 59 f1 ff ff       	call   801fb3 <get_block_size>
  802e5a:	83 c4 04             	add    $0x4,%esp
  802e5d:	01 c3                	add    %eax,%ebx
  802e5f:	ff 75 0c             	pushl  0xc(%ebp)
  802e62:	e8 4c f1 ff ff       	call   801fb3 <get_block_size>
  802e67:	83 c4 04             	add    $0x4,%esp
  802e6a:	01 d8                	add    %ebx,%eax
  802e6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e6f:	6a 00                	push   $0x0
  802e71:	ff 75 ec             	pushl  -0x14(%ebp)
  802e74:	ff 75 08             	pushl  0x8(%ebp)
  802e77:	e8 88 f4 ff ff       	call   802304 <set_block_data>
  802e7c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e83:	75 17                	jne    802e9c <merging+0xc8>
  802e85:	83 ec 04             	sub    $0x4,%esp
  802e88:	68 f3 44 80 00       	push   $0x8044f3
  802e8d:	68 7d 01 00 00       	push   $0x17d
  802e92:	68 11 45 80 00       	push   $0x804511
  802e97:	e8 ec 0b 00 00       	call   803a88 <_panic>
  802e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9f:	8b 00                	mov    (%eax),%eax
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	74 10                	je     802eb5 <merging+0xe1>
  802ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ead:	8b 52 04             	mov    0x4(%edx),%edx
  802eb0:	89 50 04             	mov    %edx,0x4(%eax)
  802eb3:	eb 0b                	jmp    802ec0 <merging+0xec>
  802eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb8:	8b 40 04             	mov    0x4(%eax),%eax
  802ebb:	a3 34 50 80 00       	mov    %eax,0x805034
  802ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec3:	8b 40 04             	mov    0x4(%eax),%eax
  802ec6:	85 c0                	test   %eax,%eax
  802ec8:	74 0f                	je     802ed9 <merging+0x105>
  802eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ecd:	8b 40 04             	mov    0x4(%eax),%eax
  802ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed3:	8b 12                	mov    (%edx),%edx
  802ed5:	89 10                	mov    %edx,(%eax)
  802ed7:	eb 0a                	jmp    802ee3 <merging+0x10f>
  802ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802edc:	8b 00                	mov    (%eax),%eax
  802ede:	a3 30 50 80 00       	mov    %eax,0x805030
  802ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802efb:	48                   	dec    %eax
  802efc:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802f01:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f02:	e9 ea 02 00 00       	jmp    8031f1 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802f07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0b:	74 3b                	je     802f48 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802f0d:	83 ec 0c             	sub    $0xc,%esp
  802f10:	ff 75 08             	pushl  0x8(%ebp)
  802f13:	e8 9b f0 ff ff       	call   801fb3 <get_block_size>
  802f18:	83 c4 10             	add    $0x10,%esp
  802f1b:	89 c3                	mov    %eax,%ebx
  802f1d:	83 ec 0c             	sub    $0xc,%esp
  802f20:	ff 75 10             	pushl  0x10(%ebp)
  802f23:	e8 8b f0 ff ff       	call   801fb3 <get_block_size>
  802f28:	83 c4 10             	add    $0x10,%esp
  802f2b:	01 d8                	add    %ebx,%eax
  802f2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802f30:	83 ec 04             	sub    $0x4,%esp
  802f33:	6a 00                	push   $0x0
  802f35:	ff 75 e8             	pushl  -0x18(%ebp)
  802f38:	ff 75 08             	pushl  0x8(%ebp)
  802f3b:	e8 c4 f3 ff ff       	call   802304 <set_block_data>
  802f40:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f43:	e9 a9 02 00 00       	jmp    8031f1 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802f48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4c:	0f 84 2d 01 00 00    	je     80307f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802f52:	83 ec 0c             	sub    $0xc,%esp
  802f55:	ff 75 10             	pushl  0x10(%ebp)
  802f58:	e8 56 f0 ff ff       	call   801fb3 <get_block_size>
  802f5d:	83 c4 10             	add    $0x10,%esp
  802f60:	89 c3                	mov    %eax,%ebx
  802f62:	83 ec 0c             	sub    $0xc,%esp
  802f65:	ff 75 0c             	pushl  0xc(%ebp)
  802f68:	e8 46 f0 ff ff       	call   801fb3 <get_block_size>
  802f6d:	83 c4 10             	add    $0x10,%esp
  802f70:	01 d8                	add    %ebx,%eax
  802f72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f75:	83 ec 04             	sub    $0x4,%esp
  802f78:	6a 00                	push   $0x0
  802f7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f7d:	ff 75 10             	pushl  0x10(%ebp)
  802f80:	e8 7f f3 ff ff       	call   802304 <set_block_data>
  802f85:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f88:	8b 45 10             	mov    0x10(%ebp),%eax
  802f8b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f92:	74 06                	je     802f9a <merging+0x1c6>
  802f94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f98:	75 17                	jne    802fb1 <merging+0x1dd>
  802f9a:	83 ec 04             	sub    $0x4,%esp
  802f9d:	68 cc 45 80 00       	push   $0x8045cc
  802fa2:	68 8d 01 00 00       	push   $0x18d
  802fa7:	68 11 45 80 00       	push   $0x804511
  802fac:	e8 d7 0a 00 00       	call   803a88 <_panic>
  802fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb4:	8b 50 04             	mov    0x4(%eax),%edx
  802fb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fba:	89 50 04             	mov    %edx,0x4(%eax)
  802fbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc3:	89 10                	mov    %edx,(%eax)
  802fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc8:	8b 40 04             	mov    0x4(%eax),%eax
  802fcb:	85 c0                	test   %eax,%eax
  802fcd:	74 0d                	je     802fdc <merging+0x208>
  802fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd2:	8b 40 04             	mov    0x4(%eax),%eax
  802fd5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fd8:	89 10                	mov    %edx,(%eax)
  802fda:	eb 08                	jmp    802fe4 <merging+0x210>
  802fdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fdf:	a3 30 50 80 00       	mov    %eax,0x805030
  802fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fea:	89 50 04             	mov    %edx,0x4(%eax)
  802fed:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ff2:	40                   	inc    %eax
  802ff3:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  802ff8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ffc:	75 17                	jne    803015 <merging+0x241>
  802ffe:	83 ec 04             	sub    $0x4,%esp
  803001:	68 f3 44 80 00       	push   $0x8044f3
  803006:	68 8e 01 00 00       	push   $0x18e
  80300b:	68 11 45 80 00       	push   $0x804511
  803010:	e8 73 0a 00 00       	call   803a88 <_panic>
  803015:	8b 45 0c             	mov    0xc(%ebp),%eax
  803018:	8b 00                	mov    (%eax),%eax
  80301a:	85 c0                	test   %eax,%eax
  80301c:	74 10                	je     80302e <merging+0x25a>
  80301e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	8b 55 0c             	mov    0xc(%ebp),%edx
  803026:	8b 52 04             	mov    0x4(%edx),%edx
  803029:	89 50 04             	mov    %edx,0x4(%eax)
  80302c:	eb 0b                	jmp    803039 <merging+0x265>
  80302e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803031:	8b 40 04             	mov    0x4(%eax),%eax
  803034:	a3 34 50 80 00       	mov    %eax,0x805034
  803039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303c:	8b 40 04             	mov    0x4(%eax),%eax
  80303f:	85 c0                	test   %eax,%eax
  803041:	74 0f                	je     803052 <merging+0x27e>
  803043:	8b 45 0c             	mov    0xc(%ebp),%eax
  803046:	8b 40 04             	mov    0x4(%eax),%eax
  803049:	8b 55 0c             	mov    0xc(%ebp),%edx
  80304c:	8b 12                	mov    (%edx),%edx
  80304e:	89 10                	mov    %edx,(%eax)
  803050:	eb 0a                	jmp    80305c <merging+0x288>
  803052:	8b 45 0c             	mov    0xc(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	a3 30 50 80 00       	mov    %eax,0x805030
  80305c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803065:	8b 45 0c             	mov    0xc(%ebp),%eax
  803068:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803074:	48                   	dec    %eax
  803075:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  80307a:	e9 72 01 00 00       	jmp    8031f1 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80307f:	8b 45 10             	mov    0x10(%ebp),%eax
  803082:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803089:	74 79                	je     803104 <merging+0x330>
  80308b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80308f:	74 73                	je     803104 <merging+0x330>
  803091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803095:	74 06                	je     80309d <merging+0x2c9>
  803097:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80309b:	75 17                	jne    8030b4 <merging+0x2e0>
  80309d:	83 ec 04             	sub    $0x4,%esp
  8030a0:	68 84 45 80 00       	push   $0x804584
  8030a5:	68 94 01 00 00       	push   $0x194
  8030aa:	68 11 45 80 00       	push   $0x804511
  8030af:	e8 d4 09 00 00       	call   803a88 <_panic>
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	8b 10                	mov    (%eax),%edx
  8030b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bc:	89 10                	mov    %edx,(%eax)
  8030be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	74 0b                	je     8030d2 <merging+0x2fe>
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	8b 00                	mov    (%eax),%eax
  8030cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030cf:	89 50 04             	mov    %edx,0x4(%eax)
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030d8:	89 10                	mov    %edx,(%eax)
  8030da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e6:	8b 00                	mov    (%eax),%eax
  8030e8:	85 c0                	test   %eax,%eax
  8030ea:	75 08                	jne    8030f4 <merging+0x320>
  8030ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ef:	a3 34 50 80 00       	mov    %eax,0x805034
  8030f4:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8030f9:	40                   	inc    %eax
  8030fa:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8030ff:	e9 ce 00 00 00       	jmp    8031d2 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803104:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803108:	74 65                	je     80316f <merging+0x39b>
  80310a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80310e:	75 17                	jne    803127 <merging+0x353>
  803110:	83 ec 04             	sub    $0x4,%esp
  803113:	68 60 45 80 00       	push   $0x804560
  803118:	68 95 01 00 00       	push   $0x195
  80311d:	68 11 45 80 00       	push   $0x804511
  803122:	e8 61 09 00 00       	call   803a88 <_panic>
  803127:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80312d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803130:	89 50 04             	mov    %edx,0x4(%eax)
  803133:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803136:	8b 40 04             	mov    0x4(%eax),%eax
  803139:	85 c0                	test   %eax,%eax
  80313b:	74 0c                	je     803149 <merging+0x375>
  80313d:	a1 34 50 80 00       	mov    0x805034,%eax
  803142:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803145:	89 10                	mov    %edx,(%eax)
  803147:	eb 08                	jmp    803151 <merging+0x37d>
  803149:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314c:	a3 30 50 80 00       	mov    %eax,0x805030
  803151:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803154:	a3 34 50 80 00       	mov    %eax,0x805034
  803159:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803162:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803167:	40                   	inc    %eax
  803168:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80316d:	eb 63                	jmp    8031d2 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80316f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803173:	75 17                	jne    80318c <merging+0x3b8>
  803175:	83 ec 04             	sub    $0x4,%esp
  803178:	68 2c 45 80 00       	push   $0x80452c
  80317d:	68 98 01 00 00       	push   $0x198
  803182:	68 11 45 80 00       	push   $0x804511
  803187:	e8 fc 08 00 00       	call   803a88 <_panic>
  80318c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803192:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803195:	89 10                	mov    %edx,(%eax)
  803197:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80319a:	8b 00                	mov    (%eax),%eax
  80319c:	85 c0                	test   %eax,%eax
  80319e:	74 0d                	je     8031ad <merging+0x3d9>
  8031a0:	a1 30 50 80 00       	mov    0x805030,%eax
  8031a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031a8:	89 50 04             	mov    %edx,0x4(%eax)
  8031ab:	eb 08                	jmp    8031b5 <merging+0x3e1>
  8031ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b0:	a3 34 50 80 00       	mov    %eax,0x805034
  8031b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8031bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8031cc:	40                   	inc    %eax
  8031cd:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  8031d2:	83 ec 0c             	sub    $0xc,%esp
  8031d5:	ff 75 10             	pushl  0x10(%ebp)
  8031d8:	e8 d6 ed ff ff       	call   801fb3 <get_block_size>
  8031dd:	83 c4 10             	add    $0x10,%esp
  8031e0:	83 ec 04             	sub    $0x4,%esp
  8031e3:	6a 00                	push   $0x0
  8031e5:	50                   	push   %eax
  8031e6:	ff 75 10             	pushl  0x10(%ebp)
  8031e9:	e8 16 f1 ff ff       	call   802304 <set_block_data>
  8031ee:	83 c4 10             	add    $0x10,%esp
	}
}
  8031f1:	90                   	nop
  8031f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031f5:	c9                   	leave  
  8031f6:	c3                   	ret    

008031f7 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8031f7:	55                   	push   %ebp
  8031f8:	89 e5                	mov    %esp,%ebp
  8031fa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8031fd:	a1 30 50 80 00       	mov    0x805030,%eax
  803202:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803205:	a1 34 50 80 00       	mov    0x805034,%eax
  80320a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80320d:	73 1b                	jae    80322a <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80320f:	a1 34 50 80 00       	mov    0x805034,%eax
  803214:	83 ec 04             	sub    $0x4,%esp
  803217:	ff 75 08             	pushl  0x8(%ebp)
  80321a:	6a 00                	push   $0x0
  80321c:	50                   	push   %eax
  80321d:	e8 b2 fb ff ff       	call   802dd4 <merging>
  803222:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803225:	e9 8b 00 00 00       	jmp    8032b5 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80322a:	a1 30 50 80 00       	mov    0x805030,%eax
  80322f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803232:	76 18                	jbe    80324c <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803234:	a1 30 50 80 00       	mov    0x805030,%eax
  803239:	83 ec 04             	sub    $0x4,%esp
  80323c:	ff 75 08             	pushl  0x8(%ebp)
  80323f:	50                   	push   %eax
  803240:	6a 00                	push   $0x0
  803242:	e8 8d fb ff ff       	call   802dd4 <merging>
  803247:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80324a:	eb 69                	jmp    8032b5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80324c:	a1 30 50 80 00       	mov    0x805030,%eax
  803251:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803254:	eb 39                	jmp    80328f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	3b 45 08             	cmp    0x8(%ebp),%eax
  80325c:	73 29                	jae    803287 <free_block+0x90>
  80325e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803261:	8b 00                	mov    (%eax),%eax
  803263:	3b 45 08             	cmp    0x8(%ebp),%eax
  803266:	76 1f                	jbe    803287 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803270:	83 ec 04             	sub    $0x4,%esp
  803273:	ff 75 08             	pushl  0x8(%ebp)
  803276:	ff 75 f0             	pushl  -0x10(%ebp)
  803279:	ff 75 f4             	pushl  -0xc(%ebp)
  80327c:	e8 53 fb ff ff       	call   802dd4 <merging>
  803281:	83 c4 10             	add    $0x10,%esp
			break;
  803284:	90                   	nop
		}
	}
}
  803285:	eb 2e                	jmp    8032b5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803287:	a1 38 50 80 00       	mov    0x805038,%eax
  80328c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80328f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803293:	74 07                	je     80329c <free_block+0xa5>
  803295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803298:	8b 00                	mov    (%eax),%eax
  80329a:	eb 05                	jmp    8032a1 <free_block+0xaa>
  80329c:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a1:	a3 38 50 80 00       	mov    %eax,0x805038
  8032a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8032ab:	85 c0                	test   %eax,%eax
  8032ad:	75 a7                	jne    803256 <free_block+0x5f>
  8032af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b3:	75 a1                	jne    803256 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8032b5:	90                   	nop
  8032b6:	c9                   	leave  
  8032b7:	c3                   	ret    

008032b8 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8032b8:	55                   	push   %ebp
  8032b9:	89 e5                	mov    %esp,%ebp
  8032bb:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8032be:	ff 75 08             	pushl  0x8(%ebp)
  8032c1:	e8 ed ec ff ff       	call   801fb3 <get_block_size>
  8032c6:	83 c4 04             	add    $0x4,%esp
  8032c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8032cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8032d3:	eb 17                	jmp    8032ec <copy_data+0x34>
  8032d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8032d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032db:	01 c2                	add    %eax,%edx
  8032dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	01 c8                	add    %ecx,%eax
  8032e5:	8a 00                	mov    (%eax),%al
  8032e7:	88 02                	mov    %al,(%edx)
  8032e9:	ff 45 fc             	incl   -0x4(%ebp)
  8032ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8032f2:	72 e1                	jb     8032d5 <copy_data+0x1d>
}
  8032f4:	90                   	nop
  8032f5:	c9                   	leave  
  8032f6:	c3                   	ret    

008032f7 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8032f7:	55                   	push   %ebp
  8032f8:	89 e5                	mov    %esp,%ebp
  8032fa:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8032fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803301:	75 23                	jne    803326 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803303:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803307:	74 13                	je     80331c <realloc_block_FF+0x25>
  803309:	83 ec 0c             	sub    $0xc,%esp
  80330c:	ff 75 0c             	pushl  0xc(%ebp)
  80330f:	e8 1f f0 ff ff       	call   802333 <alloc_block_FF>
  803314:	83 c4 10             	add    $0x10,%esp
  803317:	e9 f4 06 00 00       	jmp    803a10 <realloc_block_FF+0x719>
		return NULL;
  80331c:	b8 00 00 00 00       	mov    $0x0,%eax
  803321:	e9 ea 06 00 00       	jmp    803a10 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803326:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80332a:	75 18                	jne    803344 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80332c:	83 ec 0c             	sub    $0xc,%esp
  80332f:	ff 75 08             	pushl  0x8(%ebp)
  803332:	e8 c0 fe ff ff       	call   8031f7 <free_block>
  803337:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80333a:	b8 00 00 00 00       	mov    $0x0,%eax
  80333f:	e9 cc 06 00 00       	jmp    803a10 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803344:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803348:	77 07                	ja     803351 <realloc_block_FF+0x5a>
  80334a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803351:	8b 45 0c             	mov    0xc(%ebp),%eax
  803354:	83 e0 01             	and    $0x1,%eax
  803357:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80335a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80335d:	83 c0 08             	add    $0x8,%eax
  803360:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803363:	83 ec 0c             	sub    $0xc,%esp
  803366:	ff 75 08             	pushl  0x8(%ebp)
  803369:	e8 45 ec ff ff       	call   801fb3 <get_block_size>
  80336e:	83 c4 10             	add    $0x10,%esp
  803371:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803374:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803377:	83 e8 08             	sub    $0x8,%eax
  80337a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	83 e8 04             	sub    $0x4,%eax
  803383:	8b 00                	mov    (%eax),%eax
  803385:	83 e0 fe             	and    $0xfffffffe,%eax
  803388:	89 c2                	mov    %eax,%edx
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	01 d0                	add    %edx,%eax
  80338f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803392:	83 ec 0c             	sub    $0xc,%esp
  803395:	ff 75 e4             	pushl  -0x1c(%ebp)
  803398:	e8 16 ec ff ff       	call   801fb3 <get_block_size>
  80339d:	83 c4 10             	add    $0x10,%esp
  8033a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8033a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033a6:	83 e8 08             	sub    $0x8,%eax
  8033a9:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8033ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033af:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033b2:	75 08                	jne    8033bc <realloc_block_FF+0xc5>
	{
		 return va;
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	e9 54 06 00 00       	jmp    803a10 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8033bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033c2:	0f 83 e5 03 00 00    	jae    8037ad <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8033c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cb:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8033d1:	83 ec 0c             	sub    $0xc,%esp
  8033d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033d7:	e8 f0 eb ff ff       	call   801fcc <is_free_block>
  8033dc:	83 c4 10             	add    $0x10,%esp
  8033df:	84 c0                	test   %al,%al
  8033e1:	0f 84 3b 01 00 00    	je     803522 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8033e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ed:	01 d0                	add    %edx,%eax
  8033ef:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8033f2:	83 ec 04             	sub    $0x4,%esp
  8033f5:	6a 01                	push   $0x1
  8033f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8033fa:	ff 75 08             	pushl  0x8(%ebp)
  8033fd:	e8 02 ef ff ff       	call   802304 <set_block_data>
  803402:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	83 e8 04             	sub    $0x4,%eax
  80340b:	8b 00                	mov    (%eax),%eax
  80340d:	83 e0 fe             	and    $0xfffffffe,%eax
  803410:	89 c2                	mov    %eax,%edx
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	01 d0                	add    %edx,%eax
  803417:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80341a:	83 ec 04             	sub    $0x4,%esp
  80341d:	6a 00                	push   $0x0
  80341f:	ff 75 cc             	pushl  -0x34(%ebp)
  803422:	ff 75 c8             	pushl  -0x38(%ebp)
  803425:	e8 da ee ff ff       	call   802304 <set_block_data>
  80342a:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80342d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803431:	74 06                	je     803439 <realloc_block_FF+0x142>
  803433:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803437:	75 17                	jne    803450 <realloc_block_FF+0x159>
  803439:	83 ec 04             	sub    $0x4,%esp
  80343c:	68 84 45 80 00       	push   $0x804584
  803441:	68 f6 01 00 00       	push   $0x1f6
  803446:	68 11 45 80 00       	push   $0x804511
  80344b:	e8 38 06 00 00       	call   803a88 <_panic>
  803450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803453:	8b 10                	mov    (%eax),%edx
  803455:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803458:	89 10                	mov    %edx,(%eax)
  80345a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	85 c0                	test   %eax,%eax
  803461:	74 0b                	je     80346e <realloc_block_FF+0x177>
  803463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803466:	8b 00                	mov    (%eax),%eax
  803468:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80346b:	89 50 04             	mov    %edx,0x4(%eax)
  80346e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803471:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803474:	89 10                	mov    %edx,(%eax)
  803476:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803479:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80347c:	89 50 04             	mov    %edx,0x4(%eax)
  80347f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	85 c0                	test   %eax,%eax
  803486:	75 08                	jne    803490 <realloc_block_FF+0x199>
  803488:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80348b:	a3 34 50 80 00       	mov    %eax,0x805034
  803490:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803495:	40                   	inc    %eax
  803496:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80349b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80349f:	75 17                	jne    8034b8 <realloc_block_FF+0x1c1>
  8034a1:	83 ec 04             	sub    $0x4,%esp
  8034a4:	68 f3 44 80 00       	push   $0x8044f3
  8034a9:	68 f7 01 00 00       	push   $0x1f7
  8034ae:	68 11 45 80 00       	push   $0x804511
  8034b3:	e8 d0 05 00 00       	call   803a88 <_panic>
  8034b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bb:	8b 00                	mov    (%eax),%eax
  8034bd:	85 c0                	test   %eax,%eax
  8034bf:	74 10                	je     8034d1 <realloc_block_FF+0x1da>
  8034c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c4:	8b 00                	mov    (%eax),%eax
  8034c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034c9:	8b 52 04             	mov    0x4(%edx),%edx
  8034cc:	89 50 04             	mov    %edx,0x4(%eax)
  8034cf:	eb 0b                	jmp    8034dc <realloc_block_FF+0x1e5>
  8034d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d4:	8b 40 04             	mov    0x4(%eax),%eax
  8034d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8034dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034df:	8b 40 04             	mov    0x4(%eax),%eax
  8034e2:	85 c0                	test   %eax,%eax
  8034e4:	74 0f                	je     8034f5 <realloc_block_FF+0x1fe>
  8034e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e9:	8b 40 04             	mov    0x4(%eax),%eax
  8034ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034ef:	8b 12                	mov    (%edx),%edx
  8034f1:	89 10                	mov    %edx,(%eax)
  8034f3:	eb 0a                	jmp    8034ff <realloc_block_FF+0x208>
  8034f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f8:	8b 00                	mov    (%eax),%eax
  8034fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803512:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803517:	48                   	dec    %eax
  803518:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80351d:	e9 83 02 00 00       	jmp    8037a5 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803522:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803526:	0f 86 69 02 00 00    	jbe    803795 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80352c:	83 ec 04             	sub    $0x4,%esp
  80352f:	6a 01                	push   $0x1
  803531:	ff 75 f0             	pushl  -0x10(%ebp)
  803534:	ff 75 08             	pushl  0x8(%ebp)
  803537:	e8 c8 ed ff ff       	call   802304 <set_block_data>
  80353c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	83 e8 04             	sub    $0x4,%eax
  803545:	8b 00                	mov    (%eax),%eax
  803547:	83 e0 fe             	and    $0xfffffffe,%eax
  80354a:	89 c2                	mov    %eax,%edx
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	01 d0                	add    %edx,%eax
  803551:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803554:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803559:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80355c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803560:	75 68                	jne    8035ca <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803562:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803566:	75 17                	jne    80357f <realloc_block_FF+0x288>
  803568:	83 ec 04             	sub    $0x4,%esp
  80356b:	68 2c 45 80 00       	push   $0x80452c
  803570:	68 06 02 00 00       	push   $0x206
  803575:	68 11 45 80 00       	push   $0x804511
  80357a:	e8 09 05 00 00       	call   803a88 <_panic>
  80357f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803585:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803588:	89 10                	mov    %edx,(%eax)
  80358a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358d:	8b 00                	mov    (%eax),%eax
  80358f:	85 c0                	test   %eax,%eax
  803591:	74 0d                	je     8035a0 <realloc_block_FF+0x2a9>
  803593:	a1 30 50 80 00       	mov    0x805030,%eax
  803598:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80359b:	89 50 04             	mov    %edx,0x4(%eax)
  80359e:	eb 08                	jmp    8035a8 <realloc_block_FF+0x2b1>
  8035a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8035a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8035b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ba:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8035bf:	40                   	inc    %eax
  8035c0:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8035c5:	e9 b0 01 00 00       	jmp    80377a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8035ca:	a1 30 50 80 00       	mov    0x805030,%eax
  8035cf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035d2:	76 68                	jbe    80363c <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035d8:	75 17                	jne    8035f1 <realloc_block_FF+0x2fa>
  8035da:	83 ec 04             	sub    $0x4,%esp
  8035dd:	68 2c 45 80 00       	push   $0x80452c
  8035e2:	68 0b 02 00 00       	push   $0x20b
  8035e7:	68 11 45 80 00       	push   $0x804511
  8035ec:	e8 97 04 00 00       	call   803a88 <_panic>
  8035f1:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fa:	89 10                	mov    %edx,(%eax)
  8035fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ff:	8b 00                	mov    (%eax),%eax
  803601:	85 c0                	test   %eax,%eax
  803603:	74 0d                	je     803612 <realloc_block_FF+0x31b>
  803605:	a1 30 50 80 00       	mov    0x805030,%eax
  80360a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80360d:	89 50 04             	mov    %edx,0x4(%eax)
  803610:	eb 08                	jmp    80361a <realloc_block_FF+0x323>
  803612:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803615:	a3 34 50 80 00       	mov    %eax,0x805034
  80361a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361d:	a3 30 50 80 00       	mov    %eax,0x805030
  803622:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803625:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803631:	40                   	inc    %eax
  803632:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803637:	e9 3e 01 00 00       	jmp    80377a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80363c:	a1 30 50 80 00       	mov    0x805030,%eax
  803641:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803644:	73 68                	jae    8036ae <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803646:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80364a:	75 17                	jne    803663 <realloc_block_FF+0x36c>
  80364c:	83 ec 04             	sub    $0x4,%esp
  80364f:	68 60 45 80 00       	push   $0x804560
  803654:	68 10 02 00 00       	push   $0x210
  803659:	68 11 45 80 00       	push   $0x804511
  80365e:	e8 25 04 00 00       	call   803a88 <_panic>
  803663:	8b 15 34 50 80 00    	mov    0x805034,%edx
  803669:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80366c:	89 50 04             	mov    %edx,0x4(%eax)
  80366f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803672:	8b 40 04             	mov    0x4(%eax),%eax
  803675:	85 c0                	test   %eax,%eax
  803677:	74 0c                	je     803685 <realloc_block_FF+0x38e>
  803679:	a1 34 50 80 00       	mov    0x805034,%eax
  80367e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803681:	89 10                	mov    %edx,(%eax)
  803683:	eb 08                	jmp    80368d <realloc_block_FF+0x396>
  803685:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803688:	a3 30 50 80 00       	mov    %eax,0x805030
  80368d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803690:	a3 34 50 80 00       	mov    %eax,0x805034
  803695:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803698:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80369e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036a3:	40                   	inc    %eax
  8036a4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8036a9:	e9 cc 00 00 00       	jmp    80377a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8036ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8036b5:	a1 30 50 80 00       	mov    0x805030,%eax
  8036ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036bd:	e9 8a 00 00 00       	jmp    80374c <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8036c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036c8:	73 7a                	jae    803744 <realloc_block_FF+0x44d>
  8036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cd:	8b 00                	mov    (%eax),%eax
  8036cf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8036d2:	73 70                	jae    803744 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8036d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d8:	74 06                	je     8036e0 <realloc_block_FF+0x3e9>
  8036da:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8036de:	75 17                	jne    8036f7 <realloc_block_FF+0x400>
  8036e0:	83 ec 04             	sub    $0x4,%esp
  8036e3:	68 84 45 80 00       	push   $0x804584
  8036e8:	68 1a 02 00 00       	push   $0x21a
  8036ed:	68 11 45 80 00       	push   $0x804511
  8036f2:	e8 91 03 00 00       	call   803a88 <_panic>
  8036f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fa:	8b 10                	mov    (%eax),%edx
  8036fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ff:	89 10                	mov    %edx,(%eax)
  803701:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803704:	8b 00                	mov    (%eax),%eax
  803706:	85 c0                	test   %eax,%eax
  803708:	74 0b                	je     803715 <realloc_block_FF+0x41e>
  80370a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803712:	89 50 04             	mov    %edx,0x4(%eax)
  803715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803718:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80371b:	89 10                	mov    %edx,(%eax)
  80371d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803720:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803723:	89 50 04             	mov    %edx,0x4(%eax)
  803726:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803729:	8b 00                	mov    (%eax),%eax
  80372b:	85 c0                	test   %eax,%eax
  80372d:	75 08                	jne    803737 <realloc_block_FF+0x440>
  80372f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803732:	a3 34 50 80 00       	mov    %eax,0x805034
  803737:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80373c:	40                   	inc    %eax
  80373d:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803742:	eb 36                	jmp    80377a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803744:	a1 38 50 80 00       	mov    0x805038,%eax
  803749:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80374c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803750:	74 07                	je     803759 <realloc_block_FF+0x462>
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	8b 00                	mov    (%eax),%eax
  803757:	eb 05                	jmp    80375e <realloc_block_FF+0x467>
  803759:	b8 00 00 00 00       	mov    $0x0,%eax
  80375e:	a3 38 50 80 00       	mov    %eax,0x805038
  803763:	a1 38 50 80 00       	mov    0x805038,%eax
  803768:	85 c0                	test   %eax,%eax
  80376a:	0f 85 52 ff ff ff    	jne    8036c2 <realloc_block_FF+0x3cb>
  803770:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803774:	0f 85 48 ff ff ff    	jne    8036c2 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80377a:	83 ec 04             	sub    $0x4,%esp
  80377d:	6a 00                	push   $0x0
  80377f:	ff 75 d8             	pushl  -0x28(%ebp)
  803782:	ff 75 d4             	pushl  -0x2c(%ebp)
  803785:	e8 7a eb ff ff       	call   802304 <set_block_data>
  80378a:	83 c4 10             	add    $0x10,%esp
				return va;
  80378d:	8b 45 08             	mov    0x8(%ebp),%eax
  803790:	e9 7b 02 00 00       	jmp    803a10 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803795:	83 ec 0c             	sub    $0xc,%esp
  803798:	68 01 46 80 00       	push   $0x804601
  80379d:	e8 26 cc ff ff       	call   8003c8 <cprintf>
  8037a2:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8037a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a8:	e9 63 02 00 00       	jmp    803a10 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8037ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8037b3:	0f 86 4d 02 00 00    	jbe    803a06 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8037b9:	83 ec 0c             	sub    $0xc,%esp
  8037bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8037bf:	e8 08 e8 ff ff       	call   801fcc <is_free_block>
  8037c4:	83 c4 10             	add    $0x10,%esp
  8037c7:	84 c0                	test   %al,%al
  8037c9:	0f 84 37 02 00 00    	je     803a06 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8037cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037d2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8037d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037db:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037de:	76 38                	jbe    803818 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8037e0:	83 ec 0c             	sub    $0xc,%esp
  8037e3:	ff 75 08             	pushl  0x8(%ebp)
  8037e6:	e8 0c fa ff ff       	call   8031f7 <free_block>
  8037eb:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8037ee:	83 ec 0c             	sub    $0xc,%esp
  8037f1:	ff 75 0c             	pushl  0xc(%ebp)
  8037f4:	e8 3a eb ff ff       	call   802333 <alloc_block_FF>
  8037f9:	83 c4 10             	add    $0x10,%esp
  8037fc:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8037ff:	83 ec 08             	sub    $0x8,%esp
  803802:	ff 75 c0             	pushl  -0x40(%ebp)
  803805:	ff 75 08             	pushl  0x8(%ebp)
  803808:	e8 ab fa ff ff       	call   8032b8 <copy_data>
  80380d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803810:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803813:	e9 f8 01 00 00       	jmp    803a10 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803818:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80381b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80381e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803821:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803825:	0f 87 a0 00 00 00    	ja     8038cb <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80382b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80382f:	75 17                	jne    803848 <realloc_block_FF+0x551>
  803831:	83 ec 04             	sub    $0x4,%esp
  803834:	68 f3 44 80 00       	push   $0x8044f3
  803839:	68 38 02 00 00       	push   $0x238
  80383e:	68 11 45 80 00       	push   $0x804511
  803843:	e8 40 02 00 00       	call   803a88 <_panic>
  803848:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384b:	8b 00                	mov    (%eax),%eax
  80384d:	85 c0                	test   %eax,%eax
  80384f:	74 10                	je     803861 <realloc_block_FF+0x56a>
  803851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803854:	8b 00                	mov    (%eax),%eax
  803856:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803859:	8b 52 04             	mov    0x4(%edx),%edx
  80385c:	89 50 04             	mov    %edx,0x4(%eax)
  80385f:	eb 0b                	jmp    80386c <realloc_block_FF+0x575>
  803861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803864:	8b 40 04             	mov    0x4(%eax),%eax
  803867:	a3 34 50 80 00       	mov    %eax,0x805034
  80386c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386f:	8b 40 04             	mov    0x4(%eax),%eax
  803872:	85 c0                	test   %eax,%eax
  803874:	74 0f                	je     803885 <realloc_block_FF+0x58e>
  803876:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803879:	8b 40 04             	mov    0x4(%eax),%eax
  80387c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387f:	8b 12                	mov    (%edx),%edx
  803881:	89 10                	mov    %edx,(%eax)
  803883:	eb 0a                	jmp    80388f <realloc_block_FF+0x598>
  803885:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803888:	8b 00                	mov    (%eax),%eax
  80388a:	a3 30 50 80 00       	mov    %eax,0x805030
  80388f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803892:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038a2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8038a7:	48                   	dec    %eax
  8038a8:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8038ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b3:	01 d0                	add    %edx,%eax
  8038b5:	83 ec 04             	sub    $0x4,%esp
  8038b8:	6a 01                	push   $0x1
  8038ba:	50                   	push   %eax
  8038bb:	ff 75 08             	pushl  0x8(%ebp)
  8038be:	e8 41 ea ff ff       	call   802304 <set_block_data>
  8038c3:	83 c4 10             	add    $0x10,%esp
  8038c6:	e9 36 01 00 00       	jmp    803a01 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8038cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8038d1:	01 d0                	add    %edx,%eax
  8038d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8038d6:	83 ec 04             	sub    $0x4,%esp
  8038d9:	6a 01                	push   $0x1
  8038db:	ff 75 f0             	pushl  -0x10(%ebp)
  8038de:	ff 75 08             	pushl  0x8(%ebp)
  8038e1:	e8 1e ea ff ff       	call   802304 <set_block_data>
  8038e6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8038e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ec:	83 e8 04             	sub    $0x4,%eax
  8038ef:	8b 00                	mov    (%eax),%eax
  8038f1:	83 e0 fe             	and    $0xfffffffe,%eax
  8038f4:	89 c2                	mov    %eax,%edx
  8038f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f9:	01 d0                	add    %edx,%eax
  8038fb:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8038fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803902:	74 06                	je     80390a <realloc_block_FF+0x613>
  803904:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803908:	75 17                	jne    803921 <realloc_block_FF+0x62a>
  80390a:	83 ec 04             	sub    $0x4,%esp
  80390d:	68 84 45 80 00       	push   $0x804584
  803912:	68 44 02 00 00       	push   $0x244
  803917:	68 11 45 80 00       	push   $0x804511
  80391c:	e8 67 01 00 00       	call   803a88 <_panic>
  803921:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803924:	8b 10                	mov    (%eax),%edx
  803926:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803929:	89 10                	mov    %edx,(%eax)
  80392b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80392e:	8b 00                	mov    (%eax),%eax
  803930:	85 c0                	test   %eax,%eax
  803932:	74 0b                	je     80393f <realloc_block_FF+0x648>
  803934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803937:	8b 00                	mov    (%eax),%eax
  803939:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80393c:	89 50 04             	mov    %edx,0x4(%eax)
  80393f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803942:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803945:	89 10                	mov    %edx,(%eax)
  803947:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80394a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80394d:	89 50 04             	mov    %edx,0x4(%eax)
  803950:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803953:	8b 00                	mov    (%eax),%eax
  803955:	85 c0                	test   %eax,%eax
  803957:	75 08                	jne    803961 <realloc_block_FF+0x66a>
  803959:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80395c:	a3 34 50 80 00       	mov    %eax,0x805034
  803961:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803966:	40                   	inc    %eax
  803967:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80396c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803970:	75 17                	jne    803989 <realloc_block_FF+0x692>
  803972:	83 ec 04             	sub    $0x4,%esp
  803975:	68 f3 44 80 00       	push   $0x8044f3
  80397a:	68 45 02 00 00       	push   $0x245
  80397f:	68 11 45 80 00       	push   $0x804511
  803984:	e8 ff 00 00 00       	call   803a88 <_panic>
  803989:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398c:	8b 00                	mov    (%eax),%eax
  80398e:	85 c0                	test   %eax,%eax
  803990:	74 10                	je     8039a2 <realloc_block_FF+0x6ab>
  803992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803995:	8b 00                	mov    (%eax),%eax
  803997:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80399a:	8b 52 04             	mov    0x4(%edx),%edx
  80399d:	89 50 04             	mov    %edx,0x4(%eax)
  8039a0:	eb 0b                	jmp    8039ad <realloc_block_FF+0x6b6>
  8039a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a5:	8b 40 04             	mov    0x4(%eax),%eax
  8039a8:	a3 34 50 80 00       	mov    %eax,0x805034
  8039ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b0:	8b 40 04             	mov    0x4(%eax),%eax
  8039b3:	85 c0                	test   %eax,%eax
  8039b5:	74 0f                	je     8039c6 <realloc_block_FF+0x6cf>
  8039b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ba:	8b 40 04             	mov    0x4(%eax),%eax
  8039bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c0:	8b 12                	mov    (%edx),%edx
  8039c2:	89 10                	mov    %edx,(%eax)
  8039c4:	eb 0a                	jmp    8039d0 <realloc_block_FF+0x6d9>
  8039c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c9:	8b 00                	mov    (%eax),%eax
  8039cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8039d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8039e8:	48                   	dec    %eax
  8039e9:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  8039ee:	83 ec 04             	sub    $0x4,%esp
  8039f1:	6a 00                	push   $0x0
  8039f3:	ff 75 bc             	pushl  -0x44(%ebp)
  8039f6:	ff 75 b8             	pushl  -0x48(%ebp)
  8039f9:	e8 06 e9 ff ff       	call   802304 <set_block_data>
  8039fe:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803a01:	8b 45 08             	mov    0x8(%ebp),%eax
  803a04:	eb 0a                	jmp    803a10 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803a06:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803a0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803a10:	c9                   	leave  
  803a11:	c3                   	ret    

00803a12 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a12:	55                   	push   %ebp
  803a13:	89 e5                	mov    %esp,%ebp
  803a15:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a18:	83 ec 04             	sub    $0x4,%esp
  803a1b:	68 08 46 80 00       	push   $0x804608
  803a20:	68 58 02 00 00       	push   $0x258
  803a25:	68 11 45 80 00       	push   $0x804511
  803a2a:	e8 59 00 00 00       	call   803a88 <_panic>

00803a2f <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803a2f:	55                   	push   %ebp
  803a30:	89 e5                	mov    %esp,%ebp
  803a32:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803a35:	83 ec 04             	sub    $0x4,%esp
  803a38:	68 30 46 80 00       	push   $0x804630
  803a3d:	68 61 02 00 00       	push   $0x261
  803a42:	68 11 45 80 00       	push   $0x804511
  803a47:	e8 3c 00 00 00       	call   803a88 <_panic>

00803a4c <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  803a4c:	55                   	push   %ebp
  803a4d:	89 e5                	mov    %esp,%ebp
  803a4f:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  803a52:	8b 45 08             	mov    0x8(%ebp),%eax
  803a55:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  803a58:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803a5c:	83 ec 0c             	sub    $0xc,%esp
  803a5f:	50                   	push   %eax
  803a60:	e8 dd e0 ff ff       	call   801b42 <sys_cputc>
  803a65:	83 c4 10             	add    $0x10,%esp
}
  803a68:	90                   	nop
  803a69:	c9                   	leave  
  803a6a:	c3                   	ret    

00803a6b <getchar>:


int
getchar(void)
{
  803a6b:	55                   	push   %ebp
  803a6c:	89 e5                	mov    %esp,%ebp
  803a6e:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803a71:	e8 68 df ff ff       	call   8019de <sys_cgetc>
  803a76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  803a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  803a7c:	c9                   	leave  
  803a7d:	c3                   	ret    

00803a7e <iscons>:

int iscons(int fdnum)
{
  803a7e:	55                   	push   %ebp
  803a7f:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803a81:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a86:	5d                   	pop    %ebp
  803a87:	c3                   	ret    

00803a88 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a88:	55                   	push   %ebp
  803a89:	89 e5                	mov    %esp,%ebp
  803a8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a8e:	8d 45 10             	lea    0x10(%ebp),%eax
  803a91:	83 c0 04             	add    $0x4,%eax
  803a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a97:	a1 60 90 18 01       	mov    0x1189060,%eax
  803a9c:	85 c0                	test   %eax,%eax
  803a9e:	74 16                	je     803ab6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803aa0:	a1 60 90 18 01       	mov    0x1189060,%eax
  803aa5:	83 ec 08             	sub    $0x8,%esp
  803aa8:	50                   	push   %eax
  803aa9:	68 58 46 80 00       	push   $0x804658
  803aae:	e8 15 c9 ff ff       	call   8003c8 <cprintf>
  803ab3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803ab6:	a1 00 50 80 00       	mov    0x805000,%eax
  803abb:	ff 75 0c             	pushl  0xc(%ebp)
  803abe:	ff 75 08             	pushl  0x8(%ebp)
  803ac1:	50                   	push   %eax
  803ac2:	68 5d 46 80 00       	push   $0x80465d
  803ac7:	e8 fc c8 ff ff       	call   8003c8 <cprintf>
  803acc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803acf:	8b 45 10             	mov    0x10(%ebp),%eax
  803ad2:	83 ec 08             	sub    $0x8,%esp
  803ad5:	ff 75 f4             	pushl  -0xc(%ebp)
  803ad8:	50                   	push   %eax
  803ad9:	e8 7f c8 ff ff       	call   80035d <vcprintf>
  803ade:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803ae1:	83 ec 08             	sub    $0x8,%esp
  803ae4:	6a 00                	push   $0x0
  803ae6:	68 79 46 80 00       	push   $0x804679
  803aeb:	e8 6d c8 ff ff       	call   80035d <vcprintf>
  803af0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803af3:	e8 ee c7 ff ff       	call   8002e6 <exit>

	// should not return here
	while (1) ;
  803af8:	eb fe                	jmp    803af8 <_panic+0x70>

00803afa <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803afa:	55                   	push   %ebp
  803afb:	89 e5                	mov    %esp,%ebp
  803afd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803b00:	a1 20 50 80 00       	mov    0x805020,%eax
  803b05:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b0e:	39 c2                	cmp    %eax,%edx
  803b10:	74 14                	je     803b26 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803b12:	83 ec 04             	sub    $0x4,%esp
  803b15:	68 7c 46 80 00       	push   $0x80467c
  803b1a:	6a 26                	push   $0x26
  803b1c:	68 c8 46 80 00       	push   $0x8046c8
  803b21:	e8 62 ff ff ff       	call   803a88 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803b26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803b2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b34:	e9 c5 00 00 00       	jmp    803bfe <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803b43:	8b 45 08             	mov    0x8(%ebp),%eax
  803b46:	01 d0                	add    %edx,%eax
  803b48:	8b 00                	mov    (%eax),%eax
  803b4a:	85 c0                	test   %eax,%eax
  803b4c:	75 08                	jne    803b56 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803b4e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803b51:	e9 a5 00 00 00       	jmp    803bfb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803b56:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b5d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803b64:	eb 69                	jmp    803bcf <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803b66:	a1 20 50 80 00       	mov    0x805020,%eax
  803b6b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b74:	89 d0                	mov    %edx,%eax
  803b76:	01 c0                	add    %eax,%eax
  803b78:	01 d0                	add    %edx,%eax
  803b7a:	c1 e0 03             	shl    $0x3,%eax
  803b7d:	01 c8                	add    %ecx,%eax
  803b7f:	8a 40 04             	mov    0x4(%eax),%al
  803b82:	84 c0                	test   %al,%al
  803b84:	75 46                	jne    803bcc <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b86:	a1 20 50 80 00       	mov    0x805020,%eax
  803b8b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b94:	89 d0                	mov    %edx,%eax
  803b96:	01 c0                	add    %eax,%eax
  803b98:	01 d0                	add    %edx,%eax
  803b9a:	c1 e0 03             	shl    $0x3,%eax
  803b9d:	01 c8                	add    %ecx,%eax
  803b9f:	8b 00                	mov    (%eax),%eax
  803ba1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803ba4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ba7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803bac:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bb1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbb:	01 c8                	add    %ecx,%eax
  803bbd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803bbf:	39 c2                	cmp    %eax,%edx
  803bc1:	75 09                	jne    803bcc <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803bc3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803bca:	eb 15                	jmp    803be1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bcc:	ff 45 e8             	incl   -0x18(%ebp)
  803bcf:	a1 20 50 80 00       	mov    0x805020,%eax
  803bd4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bdd:	39 c2                	cmp    %eax,%edx
  803bdf:	77 85                	ja     803b66 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803be1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803be5:	75 14                	jne    803bfb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803be7:	83 ec 04             	sub    $0x4,%esp
  803bea:	68 d4 46 80 00       	push   $0x8046d4
  803bef:	6a 3a                	push   $0x3a
  803bf1:	68 c8 46 80 00       	push   $0x8046c8
  803bf6:	e8 8d fe ff ff       	call   803a88 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803bfb:	ff 45 f0             	incl   -0x10(%ebp)
  803bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c01:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c04:	0f 8c 2f ff ff ff    	jl     803b39 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803c0a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c11:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803c18:	eb 26                	jmp    803c40 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803c1a:	a1 20 50 80 00       	mov    0x805020,%eax
  803c1f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803c25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c28:	89 d0                	mov    %edx,%eax
  803c2a:	01 c0                	add    %eax,%eax
  803c2c:	01 d0                	add    %edx,%eax
  803c2e:	c1 e0 03             	shl    $0x3,%eax
  803c31:	01 c8                	add    %ecx,%eax
  803c33:	8a 40 04             	mov    0x4(%eax),%al
  803c36:	3c 01                	cmp    $0x1,%al
  803c38:	75 03                	jne    803c3d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803c3a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803c3d:	ff 45 e0             	incl   -0x20(%ebp)
  803c40:	a1 20 50 80 00       	mov    0x805020,%eax
  803c45:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803c4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c4e:	39 c2                	cmp    %eax,%edx
  803c50:	77 c8                	ja     803c1a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c55:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803c58:	74 14                	je     803c6e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803c5a:	83 ec 04             	sub    $0x4,%esp
  803c5d:	68 28 47 80 00       	push   $0x804728
  803c62:	6a 44                	push   $0x44
  803c64:	68 c8 46 80 00       	push   $0x8046c8
  803c69:	e8 1a fe ff ff       	call   803a88 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803c6e:	90                   	nop
  803c6f:	c9                   	leave  
  803c70:	c3                   	ret    
  803c71:	66 90                	xchg   %ax,%ax
  803c73:	90                   	nop

00803c74 <__udivdi3>:
  803c74:	55                   	push   %ebp
  803c75:	57                   	push   %edi
  803c76:	56                   	push   %esi
  803c77:	53                   	push   %ebx
  803c78:	83 ec 1c             	sub    $0x1c,%esp
  803c7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c8b:	89 ca                	mov    %ecx,%edx
  803c8d:	89 f8                	mov    %edi,%eax
  803c8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c93:	85 f6                	test   %esi,%esi
  803c95:	75 2d                	jne    803cc4 <__udivdi3+0x50>
  803c97:	39 cf                	cmp    %ecx,%edi
  803c99:	77 65                	ja     803d00 <__udivdi3+0x8c>
  803c9b:	89 fd                	mov    %edi,%ebp
  803c9d:	85 ff                	test   %edi,%edi
  803c9f:	75 0b                	jne    803cac <__udivdi3+0x38>
  803ca1:	b8 01 00 00 00       	mov    $0x1,%eax
  803ca6:	31 d2                	xor    %edx,%edx
  803ca8:	f7 f7                	div    %edi
  803caa:	89 c5                	mov    %eax,%ebp
  803cac:	31 d2                	xor    %edx,%edx
  803cae:	89 c8                	mov    %ecx,%eax
  803cb0:	f7 f5                	div    %ebp
  803cb2:	89 c1                	mov    %eax,%ecx
  803cb4:	89 d8                	mov    %ebx,%eax
  803cb6:	f7 f5                	div    %ebp
  803cb8:	89 cf                	mov    %ecx,%edi
  803cba:	89 fa                	mov    %edi,%edx
  803cbc:	83 c4 1c             	add    $0x1c,%esp
  803cbf:	5b                   	pop    %ebx
  803cc0:	5e                   	pop    %esi
  803cc1:	5f                   	pop    %edi
  803cc2:	5d                   	pop    %ebp
  803cc3:	c3                   	ret    
  803cc4:	39 ce                	cmp    %ecx,%esi
  803cc6:	77 28                	ja     803cf0 <__udivdi3+0x7c>
  803cc8:	0f bd fe             	bsr    %esi,%edi
  803ccb:	83 f7 1f             	xor    $0x1f,%edi
  803cce:	75 40                	jne    803d10 <__udivdi3+0x9c>
  803cd0:	39 ce                	cmp    %ecx,%esi
  803cd2:	72 0a                	jb     803cde <__udivdi3+0x6a>
  803cd4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803cd8:	0f 87 9e 00 00 00    	ja     803d7c <__udivdi3+0x108>
  803cde:	b8 01 00 00 00       	mov    $0x1,%eax
  803ce3:	89 fa                	mov    %edi,%edx
  803ce5:	83 c4 1c             	add    $0x1c,%esp
  803ce8:	5b                   	pop    %ebx
  803ce9:	5e                   	pop    %esi
  803cea:	5f                   	pop    %edi
  803ceb:	5d                   	pop    %ebp
  803cec:	c3                   	ret    
  803ced:	8d 76 00             	lea    0x0(%esi),%esi
  803cf0:	31 ff                	xor    %edi,%edi
  803cf2:	31 c0                	xor    %eax,%eax
  803cf4:	89 fa                	mov    %edi,%edx
  803cf6:	83 c4 1c             	add    $0x1c,%esp
  803cf9:	5b                   	pop    %ebx
  803cfa:	5e                   	pop    %esi
  803cfb:	5f                   	pop    %edi
  803cfc:	5d                   	pop    %ebp
  803cfd:	c3                   	ret    
  803cfe:	66 90                	xchg   %ax,%ax
  803d00:	89 d8                	mov    %ebx,%eax
  803d02:	f7 f7                	div    %edi
  803d04:	31 ff                	xor    %edi,%edi
  803d06:	89 fa                	mov    %edi,%edx
  803d08:	83 c4 1c             	add    $0x1c,%esp
  803d0b:	5b                   	pop    %ebx
  803d0c:	5e                   	pop    %esi
  803d0d:	5f                   	pop    %edi
  803d0e:	5d                   	pop    %ebp
  803d0f:	c3                   	ret    
  803d10:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d15:	89 eb                	mov    %ebp,%ebx
  803d17:	29 fb                	sub    %edi,%ebx
  803d19:	89 f9                	mov    %edi,%ecx
  803d1b:	d3 e6                	shl    %cl,%esi
  803d1d:	89 c5                	mov    %eax,%ebp
  803d1f:	88 d9                	mov    %bl,%cl
  803d21:	d3 ed                	shr    %cl,%ebp
  803d23:	89 e9                	mov    %ebp,%ecx
  803d25:	09 f1                	or     %esi,%ecx
  803d27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d2b:	89 f9                	mov    %edi,%ecx
  803d2d:	d3 e0                	shl    %cl,%eax
  803d2f:	89 c5                	mov    %eax,%ebp
  803d31:	89 d6                	mov    %edx,%esi
  803d33:	88 d9                	mov    %bl,%cl
  803d35:	d3 ee                	shr    %cl,%esi
  803d37:	89 f9                	mov    %edi,%ecx
  803d39:	d3 e2                	shl    %cl,%edx
  803d3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d3f:	88 d9                	mov    %bl,%cl
  803d41:	d3 e8                	shr    %cl,%eax
  803d43:	09 c2                	or     %eax,%edx
  803d45:	89 d0                	mov    %edx,%eax
  803d47:	89 f2                	mov    %esi,%edx
  803d49:	f7 74 24 0c          	divl   0xc(%esp)
  803d4d:	89 d6                	mov    %edx,%esi
  803d4f:	89 c3                	mov    %eax,%ebx
  803d51:	f7 e5                	mul    %ebp
  803d53:	39 d6                	cmp    %edx,%esi
  803d55:	72 19                	jb     803d70 <__udivdi3+0xfc>
  803d57:	74 0b                	je     803d64 <__udivdi3+0xf0>
  803d59:	89 d8                	mov    %ebx,%eax
  803d5b:	31 ff                	xor    %edi,%edi
  803d5d:	e9 58 ff ff ff       	jmp    803cba <__udivdi3+0x46>
  803d62:	66 90                	xchg   %ax,%ax
  803d64:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d68:	89 f9                	mov    %edi,%ecx
  803d6a:	d3 e2                	shl    %cl,%edx
  803d6c:	39 c2                	cmp    %eax,%edx
  803d6e:	73 e9                	jae    803d59 <__udivdi3+0xe5>
  803d70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d73:	31 ff                	xor    %edi,%edi
  803d75:	e9 40 ff ff ff       	jmp    803cba <__udivdi3+0x46>
  803d7a:	66 90                	xchg   %ax,%ax
  803d7c:	31 c0                	xor    %eax,%eax
  803d7e:	e9 37 ff ff ff       	jmp    803cba <__udivdi3+0x46>
  803d83:	90                   	nop

00803d84 <__umoddi3>:
  803d84:	55                   	push   %ebp
  803d85:	57                   	push   %edi
  803d86:	56                   	push   %esi
  803d87:	53                   	push   %ebx
  803d88:	83 ec 1c             	sub    $0x1c,%esp
  803d8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803da3:	89 f3                	mov    %esi,%ebx
  803da5:	89 fa                	mov    %edi,%edx
  803da7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dab:	89 34 24             	mov    %esi,(%esp)
  803dae:	85 c0                	test   %eax,%eax
  803db0:	75 1a                	jne    803dcc <__umoddi3+0x48>
  803db2:	39 f7                	cmp    %esi,%edi
  803db4:	0f 86 a2 00 00 00    	jbe    803e5c <__umoddi3+0xd8>
  803dba:	89 c8                	mov    %ecx,%eax
  803dbc:	89 f2                	mov    %esi,%edx
  803dbe:	f7 f7                	div    %edi
  803dc0:	89 d0                	mov    %edx,%eax
  803dc2:	31 d2                	xor    %edx,%edx
  803dc4:	83 c4 1c             	add    $0x1c,%esp
  803dc7:	5b                   	pop    %ebx
  803dc8:	5e                   	pop    %esi
  803dc9:	5f                   	pop    %edi
  803dca:	5d                   	pop    %ebp
  803dcb:	c3                   	ret    
  803dcc:	39 f0                	cmp    %esi,%eax
  803dce:	0f 87 ac 00 00 00    	ja     803e80 <__umoddi3+0xfc>
  803dd4:	0f bd e8             	bsr    %eax,%ebp
  803dd7:	83 f5 1f             	xor    $0x1f,%ebp
  803dda:	0f 84 ac 00 00 00    	je     803e8c <__umoddi3+0x108>
  803de0:	bf 20 00 00 00       	mov    $0x20,%edi
  803de5:	29 ef                	sub    %ebp,%edi
  803de7:	89 fe                	mov    %edi,%esi
  803de9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ded:	89 e9                	mov    %ebp,%ecx
  803def:	d3 e0                	shl    %cl,%eax
  803df1:	89 d7                	mov    %edx,%edi
  803df3:	89 f1                	mov    %esi,%ecx
  803df5:	d3 ef                	shr    %cl,%edi
  803df7:	09 c7                	or     %eax,%edi
  803df9:	89 e9                	mov    %ebp,%ecx
  803dfb:	d3 e2                	shl    %cl,%edx
  803dfd:	89 14 24             	mov    %edx,(%esp)
  803e00:	89 d8                	mov    %ebx,%eax
  803e02:	d3 e0                	shl    %cl,%eax
  803e04:	89 c2                	mov    %eax,%edx
  803e06:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e0a:	d3 e0                	shl    %cl,%eax
  803e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e10:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e14:	89 f1                	mov    %esi,%ecx
  803e16:	d3 e8                	shr    %cl,%eax
  803e18:	09 d0                	or     %edx,%eax
  803e1a:	d3 eb                	shr    %cl,%ebx
  803e1c:	89 da                	mov    %ebx,%edx
  803e1e:	f7 f7                	div    %edi
  803e20:	89 d3                	mov    %edx,%ebx
  803e22:	f7 24 24             	mull   (%esp)
  803e25:	89 c6                	mov    %eax,%esi
  803e27:	89 d1                	mov    %edx,%ecx
  803e29:	39 d3                	cmp    %edx,%ebx
  803e2b:	0f 82 87 00 00 00    	jb     803eb8 <__umoddi3+0x134>
  803e31:	0f 84 91 00 00 00    	je     803ec8 <__umoddi3+0x144>
  803e37:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e3b:	29 f2                	sub    %esi,%edx
  803e3d:	19 cb                	sbb    %ecx,%ebx
  803e3f:	89 d8                	mov    %ebx,%eax
  803e41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e45:	d3 e0                	shl    %cl,%eax
  803e47:	89 e9                	mov    %ebp,%ecx
  803e49:	d3 ea                	shr    %cl,%edx
  803e4b:	09 d0                	or     %edx,%eax
  803e4d:	89 e9                	mov    %ebp,%ecx
  803e4f:	d3 eb                	shr    %cl,%ebx
  803e51:	89 da                	mov    %ebx,%edx
  803e53:	83 c4 1c             	add    $0x1c,%esp
  803e56:	5b                   	pop    %ebx
  803e57:	5e                   	pop    %esi
  803e58:	5f                   	pop    %edi
  803e59:	5d                   	pop    %ebp
  803e5a:	c3                   	ret    
  803e5b:	90                   	nop
  803e5c:	89 fd                	mov    %edi,%ebp
  803e5e:	85 ff                	test   %edi,%edi
  803e60:	75 0b                	jne    803e6d <__umoddi3+0xe9>
  803e62:	b8 01 00 00 00       	mov    $0x1,%eax
  803e67:	31 d2                	xor    %edx,%edx
  803e69:	f7 f7                	div    %edi
  803e6b:	89 c5                	mov    %eax,%ebp
  803e6d:	89 f0                	mov    %esi,%eax
  803e6f:	31 d2                	xor    %edx,%edx
  803e71:	f7 f5                	div    %ebp
  803e73:	89 c8                	mov    %ecx,%eax
  803e75:	f7 f5                	div    %ebp
  803e77:	89 d0                	mov    %edx,%eax
  803e79:	e9 44 ff ff ff       	jmp    803dc2 <__umoddi3+0x3e>
  803e7e:	66 90                	xchg   %ax,%ax
  803e80:	89 c8                	mov    %ecx,%eax
  803e82:	89 f2                	mov    %esi,%edx
  803e84:	83 c4 1c             	add    $0x1c,%esp
  803e87:	5b                   	pop    %ebx
  803e88:	5e                   	pop    %esi
  803e89:	5f                   	pop    %edi
  803e8a:	5d                   	pop    %ebp
  803e8b:	c3                   	ret    
  803e8c:	3b 04 24             	cmp    (%esp),%eax
  803e8f:	72 06                	jb     803e97 <__umoddi3+0x113>
  803e91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e95:	77 0f                	ja     803ea6 <__umoddi3+0x122>
  803e97:	89 f2                	mov    %esi,%edx
  803e99:	29 f9                	sub    %edi,%ecx
  803e9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e9f:	89 14 24             	mov    %edx,(%esp)
  803ea2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ea6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803eaa:	8b 14 24             	mov    (%esp),%edx
  803ead:	83 c4 1c             	add    $0x1c,%esp
  803eb0:	5b                   	pop    %ebx
  803eb1:	5e                   	pop    %esi
  803eb2:	5f                   	pop    %edi
  803eb3:	5d                   	pop    %ebp
  803eb4:	c3                   	ret    
  803eb5:	8d 76 00             	lea    0x0(%esi),%esi
  803eb8:	2b 04 24             	sub    (%esp),%eax
  803ebb:	19 fa                	sbb    %edi,%edx
  803ebd:	89 d1                	mov    %edx,%ecx
  803ebf:	89 c6                	mov    %eax,%esi
  803ec1:	e9 71 ff ff ff       	jmp    803e37 <__umoddi3+0xb3>
  803ec6:	66 90                	xchg   %ax,%ax
  803ec8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ecc:	72 ea                	jb     803eb8 <__umoddi3+0x134>
  803ece:	89 d9                	mov    %ebx,%ecx
  803ed0:	e9 62 ff ff ff       	jmp    803e37 <__umoddi3+0xb3>
