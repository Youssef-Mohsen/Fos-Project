
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
  800052:	68 00 3e 80 00       	push   $0x803e00
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
  8000ec:	68 1e 3e 80 00       	push   $0x803e1e
  8000f1:	e8 ff 02 00 00       	call   8003f5 <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 d8 1b 00 00       	call   801cd6 <inctst>
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
  8001bb:	e8 d8 19 00 00       	call   801b98 <sys_getenvindex>
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
  800229:	e8 ee 16 00 00       	call   80191c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	68 4c 3e 80 00       	push   $0x803e4c
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
  800259:	68 74 3e 80 00       	push   $0x803e74
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
  80028a:	68 9c 3e 80 00       	push   $0x803e9c
  80028f:	e8 34 01 00 00       	call   8003c8 <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800297:	a1 20 50 80 00       	mov    0x805020,%eax
  80029c:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	50                   	push   %eax
  8002a6:	68 f4 3e 80 00       	push   $0x803ef4
  8002ab:	e8 18 01 00 00       	call   8003c8 <cprintf>
  8002b0:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	68 4c 3e 80 00       	push   $0x803e4c
  8002bb:	e8 08 01 00 00       	call   8003c8 <cprintf>
  8002c0:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002c3:	e8 6e 16 00 00       	call   801936 <sys_unlock_cons>
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
  8002db:	e8 84 18 00 00       	call   801b64 <sys_destroy_env>
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
  8002ec:	e8 d9 18 00 00       	call   801bca <sys_exit_env>
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
  80033a:	e8 9b 15 00 00       	call   8018da <sys_cputs>
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
  8003b1:	e8 24 15 00 00       	call   8018da <sys_cputs>
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
  8003fb:	e8 1c 15 00 00       	call   80191c <sys_lock_cons>
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
  80041b:	e8 16 15 00 00       	call   801936 <sys_unlock_cons>
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
  800465:	e8 2e 37 00 00       	call   803b98 <__udivdi3>
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
  8004b5:	e8 ee 37 00 00       	call   803ca8 <__umoddi3>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	05 34 41 80 00       	add    $0x804134,%eax
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
  800610:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
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
  8006f1:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  8006f8:	85 f6                	test   %esi,%esi
  8006fa:	75 19                	jne    800715 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006fc:	53                   	push   %ebx
  8006fd:	68 45 41 80 00       	push   $0x804145
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
  800716:	68 4e 41 80 00       	push   $0x80414e
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
  800743:	be 51 41 80 00       	mov    $0x804151,%esi
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
  800a6e:	68 c8 42 80 00       	push   $0x8042c8
  800a73:	e8 50 f9 ff ff       	call   8003c8 <cprintf>
  800a78:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a82:	83 ec 0c             	sub    $0xc,%esp
  800a85:	6a 00                	push   $0x0
  800a87:	e8 17 2f 00 00       	call   8039a3 <iscons>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a92:	e8 f9 2e 00 00       	call   803990 <getchar>
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
  800ab0:	68 cb 42 80 00       	push   $0x8042cb
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
  800add:	e8 8f 2e 00 00       	call   803971 <cputchar>
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
  800b14:	e8 58 2e 00 00       	call   803971 <cputchar>
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
  800b3d:	e8 2f 2e 00 00       	call   803971 <cputchar>
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
  800b61:	e8 b6 0d 00 00       	call   80191c <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6a:	74 13                	je     800b7f <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	68 c8 42 80 00       	push   $0x8042c8
  800b77:	e8 4c f8 ff ff       	call   8003c8 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	6a 00                	push   $0x0
  800b8b:	e8 13 2e 00 00       	call   8039a3 <iscons>
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b96:	e8 f5 2d 00 00       	call   803990 <getchar>
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
  800bb4:	68 cb 42 80 00       	push   $0x8042cb
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
  800be1:	e8 8b 2d 00 00       	call   803971 <cputchar>
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
  800c18:	e8 54 2d 00 00       	call   803971 <cputchar>
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
  800c41:	e8 2b 2d 00 00       	call   803971 <cputchar>
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
  800c5c:	e8 d5 0c 00 00       	call   801936 <sys_unlock_cons>
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
  801356:	68 dc 42 80 00       	push   $0x8042dc
  80135b:	68 3f 01 00 00       	push   $0x13f
  801360:	68 fe 42 80 00       	push   $0x8042fe
  801365:	e8 43 26 00 00       	call   8039ad <_panic>

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
  801376:	e8 0a 0b 00 00       	call   801e85 <sys_sbrk>
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
  8013f1:	e8 13 09 00 00       	call   801d09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	74 16                	je     801410 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 53 0e 00 00       	call   802258 <alloc_block_FF>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80140b:	e9 8a 01 00 00       	jmp    80159a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801410:	e8 25 09 00 00       	call   801d3a <sys_isUHeapPlacementStrategyBESTFIT>
  801415:	85 c0                	test   %eax,%eax
  801417:	0f 84 7d 01 00 00    	je     80159a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80141d:	83 ec 0c             	sub    $0xc,%esp
  801420:	ff 75 08             	pushl  0x8(%ebp)
  801423:	e8 ec 12 00 00       	call   802714 <alloc_block_BF>
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
  801473:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8014c0:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  801517:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
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
  801579:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	ff 75 08             	pushl  0x8(%ebp)
  801586:	ff 75 f0             	pushl  -0x10(%ebp)
  801589:	e8 2e 09 00 00       	call   801ebc <sys_allocate_user_mem>
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
  8015d1:	e8 02 09 00 00       	call   801ed8 <get_block_size>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	ff 75 08             	pushl  0x8(%ebp)
  8015e2:	e8 35 1b 00 00       	call   80311c <free_block>
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
  80161c:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801659:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
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
  801679:	e8 22 08 00 00       	call   801ea0 <sys_free_user_mem>
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
  801687:	68 0c 43 80 00       	push   $0x80430c
  80168c:	68 85 00 00 00       	push   $0x85
  801691:	68 36 43 80 00       	push   $0x804336
  801696:	e8 12 23 00 00       	call   8039ad <_panic>
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
  8016ad:	75 0a                	jne    8016b9 <smalloc+0x1c>
  8016af:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b4:	e9 9a 00 00 00       	jmp    801753 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8016b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016bf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cc:	39 d0                	cmp    %edx,%eax
  8016ce:	73 02                	jae    8016d2 <smalloc+0x35>
  8016d0:	89 d0                	mov    %edx,%eax
  8016d2:	83 ec 0c             	sub    $0xc,%esp
  8016d5:	50                   	push   %eax
  8016d6:	e8 a5 fc ff ff       	call   801380 <malloc>
  8016db:	83 c4 10             	add    $0x10,%esp
  8016de:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  8016e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e5:	75 07                	jne    8016ee <smalloc+0x51>
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ec:	eb 65                	jmp    801753 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8016ee:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016f2:	ff 75 ec             	pushl  -0x14(%ebp)
  8016f5:	50                   	push   %eax
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	ff 75 08             	pushl  0x8(%ebp)
  8016fc:	e8 a6 03 00 00       	call   801aa7 <sys_createSharedObject>
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801707:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80170b:	74 06                	je     801713 <smalloc+0x76>
  80170d:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801711:	75 07                	jne    80171a <smalloc+0x7d>
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
  801718:	eb 39                	jmp    801753 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  80171a:	83 ec 08             	sub    $0x8,%esp
  80171d:	ff 75 ec             	pushl  -0x14(%ebp)
  801720:	68 42 43 80 00       	push   $0x804342
  801725:	e8 9e ec ff ff       	call   8003c8 <cprintf>
  80172a:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  80172d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801730:	a1 20 50 80 00       	mov    0x805020,%eax
  801735:	8b 40 78             	mov    0x78(%eax),%eax
  801738:	29 c2                	sub    %eax,%edx
  80173a:	89 d0                	mov    %edx,%eax
  80173c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801741:	c1 e8 0c             	shr    $0xc,%eax
  801744:	89 c2                	mov    %eax,%edx
  801746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801749:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801750:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	ff 75 0c             	pushl  0xc(%ebp)
  801761:	ff 75 08             	pushl  0x8(%ebp)
  801764:	e8 68 03 00 00       	call   801ad1 <sys_getSizeOfSharedObject>
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80176f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801773:	75 07                	jne    80177c <sget+0x27>
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
  80177a:	eb 7f                	jmp    8017fb <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801782:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801789:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80178c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178f:	39 d0                	cmp    %edx,%eax
  801791:	7d 02                	jge    801795 <sget+0x40>
  801793:	89 d0                	mov    %edx,%eax
  801795:	83 ec 0c             	sub    $0xc,%esp
  801798:	50                   	push   %eax
  801799:	e8 e2 fb ff ff       	call   801380 <malloc>
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8017a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8017a8:	75 07                	jne    8017b1 <sget+0x5c>
  8017aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017af:	eb 4a                	jmp    8017fb <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8017b1:	83 ec 04             	sub    $0x4,%esp
  8017b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	ff 75 08             	pushl  0x8(%ebp)
  8017bd:	e8 2c 03 00 00       	call   801aee <sys_getSharedObject>
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8017c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8017d0:	8b 40 78             	mov    0x78(%eax),%eax
  8017d3:	29 c2                	sub    %eax,%edx
  8017d5:	89 d0                	mov    %edx,%eax
  8017d7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017dc:	c1 e8 0c             	shr    $0xc,%eax
  8017df:	89 c2                	mov    %eax,%edx
  8017e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e4:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8017eb:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8017ef:	75 07                	jne    8017f8 <sget+0xa3>
  8017f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f6:	eb 03                	jmp    8017fb <sget+0xa6>
	return ptr;
  8017f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801803:	8b 55 08             	mov    0x8(%ebp),%edx
  801806:	a1 20 50 80 00       	mov    0x805020,%eax
  80180b:	8b 40 78             	mov    0x78(%eax),%eax
  80180e:	29 c2                	sub    %eax,%edx
  801810:	89 d0                	mov    %edx,%eax
  801812:	2d 00 10 00 00       	sub    $0x1000,%eax
  801817:	c1 e8 0c             	shr    $0xc,%eax
  80181a:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801821:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801824:	83 ec 08             	sub    $0x8,%esp
  801827:	ff 75 08             	pushl  0x8(%ebp)
  80182a:	ff 75 f4             	pushl  -0xc(%ebp)
  80182d:	e8 db 02 00 00       	call   801b0d <sys_freeSharedObject>
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801838:	90                   	nop
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801841:	83 ec 04             	sub    $0x4,%esp
  801844:	68 54 43 80 00       	push   $0x804354
  801849:	68 de 00 00 00       	push   $0xde
  80184e:	68 36 43 80 00       	push   $0x804336
  801853:	e8 55 21 00 00       	call   8039ad <_panic>

00801858 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185e:	83 ec 04             	sub    $0x4,%esp
  801861:	68 7a 43 80 00       	push   $0x80437a
  801866:	68 ea 00 00 00       	push   $0xea
  80186b:	68 36 43 80 00       	push   $0x804336
  801870:	e8 38 21 00 00       	call   8039ad <_panic>

00801875 <shrink>:

}
void shrink(uint32 newSize)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187b:	83 ec 04             	sub    $0x4,%esp
  80187e:	68 7a 43 80 00       	push   $0x80437a
  801883:	68 ef 00 00 00       	push   $0xef
  801888:	68 36 43 80 00       	push   $0x804336
  80188d:	e8 1b 21 00 00       	call   8039ad <_panic>

00801892 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	68 7a 43 80 00       	push   $0x80437a
  8018a0:	68 f4 00 00 00       	push   $0xf4
  8018a5:	68 36 43 80 00       	push   $0x804336
  8018aa:	e8 fe 20 00 00       	call   8039ad <_panic>

008018af <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	57                   	push   %edi
  8018b3:	56                   	push   %esi
  8018b4:	53                   	push   %ebx
  8018b5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018c7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ca:	cd 30                	int    $0x30
  8018cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	5b                   	pop    %ebx
  8018d6:	5e                   	pop    %esi
  8018d7:	5f                   	pop    %edi
  8018d8:	5d                   	pop    %ebp
  8018d9:	c3                   	ret    

008018da <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	52                   	push   %edx
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	50                   	push   %eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	e8 b2 ff ff ff       	call   8018af <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	90                   	nop
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_cgetc>:

int
sys_cgetc(void)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 02                	push   $0x2
  801912:	e8 98 ff ff ff       	call   8018af <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 03                	push   $0x3
  80192b:	e8 7f ff ff ff       	call   8018af <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	90                   	nop
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 04                	push   $0x4
  801945:	e8 65 ff ff ff       	call   8018af <syscall>
  80194a:	83 c4 18             	add    $0x18,%esp
}
  80194d:	90                   	nop
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801953:	8b 55 0c             	mov    0xc(%ebp),%edx
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	52                   	push   %edx
  801960:	50                   	push   %eax
  801961:	6a 08                	push   $0x8
  801963:	e8 47 ff ff ff       	call   8018af <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	56                   	push   %esi
  801971:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801972:	8b 75 18             	mov    0x18(%ebp),%esi
  801975:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801978:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	56                   	push   %esi
  801982:	53                   	push   %ebx
  801983:	51                   	push   %ecx
  801984:	52                   	push   %edx
  801985:	50                   	push   %eax
  801986:	6a 09                	push   $0x9
  801988:	e8 22 ff ff ff       	call   8018af <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801993:	5b                   	pop    %ebx
  801994:	5e                   	pop    %esi
  801995:	5d                   	pop    %ebp
  801996:	c3                   	ret    

00801997 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80199a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	52                   	push   %edx
  8019a7:	50                   	push   %eax
  8019a8:	6a 0a                	push   $0xa
  8019aa:	e8 00 ff ff ff       	call   8018af <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	ff 75 0c             	pushl  0xc(%ebp)
  8019c0:	ff 75 08             	pushl  0x8(%ebp)
  8019c3:	6a 0b                	push   $0xb
  8019c5:	e8 e5 fe ff ff       	call   8018af <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 0c                	push   $0xc
  8019de:	e8 cc fe ff ff       	call   8018af <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 0d                	push   $0xd
  8019f7:	e8 b3 fe ff ff       	call   8018af <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 0e                	push   $0xe
  801a10:	e8 9a fe ff ff       	call   8018af <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 0f                	push   $0xf
  801a29:	e8 81 fe ff ff       	call   8018af <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	ff 75 08             	pushl  0x8(%ebp)
  801a41:	6a 10                	push   $0x10
  801a43:	e8 67 fe ff ff       	call   8018af <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 11                	push   $0x11
  801a5c:	e8 4e fe ff ff       	call   8018af <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	90                   	nop
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	83 ec 04             	sub    $0x4,%esp
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a73:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	50                   	push   %eax
  801a80:	6a 01                	push   $0x1
  801a82:	e8 28 fe ff ff       	call   8018af <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
}
  801a8a:	90                   	nop
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 14                	push   $0x14
  801a9c:	e8 0e fe ff ff       	call   8018af <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	90                   	nop
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
  801aaa:	83 ec 04             	sub    $0x4,%esp
  801aad:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ab3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ab6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	51                   	push   %ecx
  801ac0:	52                   	push   %edx
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	50                   	push   %eax
  801ac5:	6a 15                	push   $0x15
  801ac7:	e8 e3 fd ff ff       	call   8018af <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ad4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	52                   	push   %edx
  801ae1:	50                   	push   %eax
  801ae2:	6a 16                	push   $0x16
  801ae4:	e8 c6 fd ff ff       	call   8018af <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801af1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	51                   	push   %ecx
  801aff:	52                   	push   %edx
  801b00:	50                   	push   %eax
  801b01:	6a 17                	push   $0x17
  801b03:	e8 a7 fd ff ff       	call   8018af <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 18                	push   $0x18
  801b20:	e8 8a fd ff ff       	call   8018af <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	6a 00                	push   $0x0
  801b32:	ff 75 14             	pushl  0x14(%ebp)
  801b35:	ff 75 10             	pushl  0x10(%ebp)
  801b38:	ff 75 0c             	pushl  0xc(%ebp)
  801b3b:	50                   	push   %eax
  801b3c:	6a 19                	push   $0x19
  801b3e:	e8 6c fd ff ff       	call   8018af <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	50                   	push   %eax
  801b57:	6a 1a                	push   $0x1a
  801b59:	e8 51 fd ff ff       	call   8018af <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	50                   	push   %eax
  801b73:	6a 1b                	push   $0x1b
  801b75:	e8 35 fd ff ff       	call   8018af <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 05                	push   $0x5
  801b8e:	e8 1c fd ff ff       	call   8018af <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 06                	push   $0x6
  801ba7:	e8 03 fd ff ff       	call   8018af <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 07                	push   $0x7
  801bc0:	e8 ea fc ff ff       	call   8018af <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_exit_env>:


void sys_exit_env(void)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 1c                	push   $0x1c
  801bd9:	e8 d1 fc ff ff       	call   8018af <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	90                   	nop
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bed:	8d 50 04             	lea    0x4(%eax),%edx
  801bf0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	6a 1d                	push   $0x1d
  801bfd:	e8 ad fc ff ff       	call   8018af <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
	return result;
  801c05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c0e:	89 01                	mov    %eax,(%ecx)
  801c10:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	c9                   	leave  
  801c17:	c2 04 00             	ret    $0x4

00801c1a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	ff 75 10             	pushl  0x10(%ebp)
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	ff 75 08             	pushl  0x8(%ebp)
  801c2a:	6a 13                	push   $0x13
  801c2c:	e8 7e fc ff ff       	call   8018af <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
	return ;
  801c34:	90                   	nop
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 1e                	push   $0x1e
  801c46:	e8 64 fc ff ff       	call   8018af <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 04             	sub    $0x4,%esp
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c5c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	50                   	push   %eax
  801c69:	6a 1f                	push   $0x1f
  801c6b:	e8 3f fc ff ff       	call   8018af <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
	return ;
  801c73:	90                   	nop
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <rsttst>:
void rsttst()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 21                	push   $0x21
  801c85:	e8 25 fc ff ff       	call   8018af <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8d:	90                   	nop
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 04             	sub    $0x4,%esp
  801c96:	8b 45 14             	mov    0x14(%ebp),%eax
  801c99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c9c:	8b 55 18             	mov    0x18(%ebp),%edx
  801c9f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ca3:	52                   	push   %edx
  801ca4:	50                   	push   %eax
  801ca5:	ff 75 10             	pushl  0x10(%ebp)
  801ca8:	ff 75 0c             	pushl  0xc(%ebp)
  801cab:	ff 75 08             	pushl  0x8(%ebp)
  801cae:	6a 20                	push   $0x20
  801cb0:	e8 fa fb ff ff       	call   8018af <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb8:	90                   	nop
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <chktst>:
void chktst(uint32 n)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	ff 75 08             	pushl  0x8(%ebp)
  801cc9:	6a 22                	push   $0x22
  801ccb:	e8 df fb ff ff       	call   8018af <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd3:	90                   	nop
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <inctst>:

void inctst()
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 23                	push   $0x23
  801ce5:	e8 c5 fb ff ff       	call   8018af <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ced:	90                   	nop
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <gettst>:
uint32 gettst()
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 24                	push   $0x24
  801cff:	e8 ab fb ff ff       	call   8018af <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 25                	push   $0x25
  801d1b:	e8 8f fb ff ff       	call   8018af <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
  801d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d26:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d2a:	75 07                	jne    801d33 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d31:	eb 05                	jmp    801d38 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 25                	push   $0x25
  801d4c:	e8 5e fb ff ff       	call   8018af <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
  801d54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d57:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d5b:	75 07                	jne    801d64 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d62:	eb 05                	jmp    801d69 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 25                	push   $0x25
  801d7d:	e8 2d fb ff ff       	call   8018af <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
  801d85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d88:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d8c:	75 07                	jne    801d95 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d93:	eb 05                	jmp    801d9a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 25                	push   $0x25
  801dae:	e8 fc fa ff ff       	call   8018af <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
  801db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801db9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dbd:	75 07                	jne    801dc6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc4:	eb 05                	jmp    801dcb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	ff 75 08             	pushl  0x8(%ebp)
  801ddb:	6a 26                	push   $0x26
  801ddd:	e8 cd fa ff ff       	call   8018af <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
	return ;
  801de5:	90                   	nop
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801def:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801df2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	6a 00                	push   $0x0
  801dfa:	53                   	push   %ebx
  801dfb:	51                   	push   %ecx
  801dfc:	52                   	push   %edx
  801dfd:	50                   	push   %eax
  801dfe:	6a 27                	push   $0x27
  801e00:	e8 aa fa ff ff       	call   8018af <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
}
  801e08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	52                   	push   %edx
  801e1d:	50                   	push   %eax
  801e1e:	6a 28                	push   $0x28
  801e20:	e8 8a fa ff ff       	call   8018af <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e2d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e33:	8b 45 08             	mov    0x8(%ebp),%eax
  801e36:	6a 00                	push   $0x0
  801e38:	51                   	push   %ecx
  801e39:	ff 75 10             	pushl  0x10(%ebp)
  801e3c:	52                   	push   %edx
  801e3d:	50                   	push   %eax
  801e3e:	6a 29                	push   $0x29
  801e40:	e8 6a fa ff ff       	call   8018af <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	ff 75 10             	pushl  0x10(%ebp)
  801e54:	ff 75 0c             	pushl  0xc(%ebp)
  801e57:	ff 75 08             	pushl  0x8(%ebp)
  801e5a:	6a 12                	push   $0x12
  801e5c:	e8 4e fa ff ff       	call   8018af <syscall>
  801e61:	83 c4 18             	add    $0x18,%esp
	return ;
  801e64:	90                   	nop
}
  801e65:	c9                   	leave  
  801e66:	c3                   	ret    

00801e67 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	52                   	push   %edx
  801e77:	50                   	push   %eax
  801e78:	6a 2a                	push   $0x2a
  801e7a:	e8 30 fa ff ff       	call   8018af <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
	return;
  801e82:	90                   	nop
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	50                   	push   %eax
  801e94:	6a 2b                	push   $0x2b
  801e96:	e8 14 fa ff ff       	call   8018af <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	ff 75 0c             	pushl  0xc(%ebp)
  801eac:	ff 75 08             	pushl  0x8(%ebp)
  801eaf:	6a 2c                	push   $0x2c
  801eb1:	e8 f9 f9 ff ff       	call   8018af <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
	return;
  801eb9:	90                   	nop
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	ff 75 0c             	pushl  0xc(%ebp)
  801ec8:	ff 75 08             	pushl  0x8(%ebp)
  801ecb:	6a 2d                	push   $0x2d
  801ecd:	e8 dd f9 ff ff       	call   8018af <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
	return;
  801ed5:	90                   	nop
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	83 e8 04             	sub    $0x4,%eax
  801ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801ee7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eea:	8b 00                	mov    (%eax),%eax
  801eec:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	83 e8 04             	sub    $0x4,%eax
  801efd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f03:	8b 00                	mov    (%eax),%eax
  801f05:	83 e0 01             	and    $0x1,%eax
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	0f 94 c0             	sete   %al
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1f:	83 f8 02             	cmp    $0x2,%eax
  801f22:	74 2b                	je     801f4f <alloc_block+0x40>
  801f24:	83 f8 02             	cmp    $0x2,%eax
  801f27:	7f 07                	jg     801f30 <alloc_block+0x21>
  801f29:	83 f8 01             	cmp    $0x1,%eax
  801f2c:	74 0e                	je     801f3c <alloc_block+0x2d>
  801f2e:	eb 58                	jmp    801f88 <alloc_block+0x79>
  801f30:	83 f8 03             	cmp    $0x3,%eax
  801f33:	74 2d                	je     801f62 <alloc_block+0x53>
  801f35:	83 f8 04             	cmp    $0x4,%eax
  801f38:	74 3b                	je     801f75 <alloc_block+0x66>
  801f3a:	eb 4c                	jmp    801f88 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	ff 75 08             	pushl  0x8(%ebp)
  801f42:	e8 11 03 00 00       	call   802258 <alloc_block_FF>
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f4d:	eb 4a                	jmp    801f99 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	ff 75 08             	pushl  0x8(%ebp)
  801f55:	e8 fa 19 00 00       	call   803954 <alloc_block_NF>
  801f5a:	83 c4 10             	add    $0x10,%esp
  801f5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f60:	eb 37                	jmp    801f99 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f62:	83 ec 0c             	sub    $0xc,%esp
  801f65:	ff 75 08             	pushl  0x8(%ebp)
  801f68:	e8 a7 07 00 00       	call   802714 <alloc_block_BF>
  801f6d:	83 c4 10             	add    $0x10,%esp
  801f70:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f73:	eb 24                	jmp    801f99 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f75:	83 ec 0c             	sub    $0xc,%esp
  801f78:	ff 75 08             	pushl  0x8(%ebp)
  801f7b:	e8 b7 19 00 00       	call   803937 <alloc_block_WF>
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f86:	eb 11                	jmp    801f99 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f88:	83 ec 0c             	sub    $0xc,%esp
  801f8b:	68 8c 43 80 00       	push   $0x80438c
  801f90:	e8 33 e4 ff ff       	call   8003c8 <cprintf>
  801f95:	83 c4 10             	add    $0x10,%esp
		break;
  801f98:	90                   	nop
	}
	return va;
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	53                   	push   %ebx
  801fa2:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801fa5:	83 ec 0c             	sub    $0xc,%esp
  801fa8:	68 ac 43 80 00       	push   $0x8043ac
  801fad:	e8 16 e4 ff ff       	call   8003c8 <cprintf>
  801fb2:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801fb5:	83 ec 0c             	sub    $0xc,%esp
  801fb8:	68 d7 43 80 00       	push   $0x8043d7
  801fbd:	e8 06 e4 ff ff       	call   8003c8 <cprintf>
  801fc2:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fcb:	eb 37                	jmp    802004 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801fcd:	83 ec 0c             	sub    $0xc,%esp
  801fd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd3:	e8 19 ff ff ff       	call   801ef1 <is_free_block>
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	0f be d8             	movsbl %al,%ebx
  801fde:	83 ec 0c             	sub    $0xc,%esp
  801fe1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe4:	e8 ef fe ff ff       	call   801ed8 <get_block_size>
  801fe9:	83 c4 10             	add    $0x10,%esp
  801fec:	83 ec 04             	sub    $0x4,%esp
  801fef:	53                   	push   %ebx
  801ff0:	50                   	push   %eax
  801ff1:	68 ef 43 80 00       	push   $0x8043ef
  801ff6:	e8 cd e3 ff ff       	call   8003c8 <cprintf>
  801ffb:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  802001:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802004:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802008:	74 07                	je     802011 <print_blocks_list+0x73>
  80200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200d:	8b 00                	mov    (%eax),%eax
  80200f:	eb 05                	jmp    802016 <print_blocks_list+0x78>
  802011:	b8 00 00 00 00       	mov    $0x0,%eax
  802016:	89 45 10             	mov    %eax,0x10(%ebp)
  802019:	8b 45 10             	mov    0x10(%ebp),%eax
  80201c:	85 c0                	test   %eax,%eax
  80201e:	75 ad                	jne    801fcd <print_blocks_list+0x2f>
  802020:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802024:	75 a7                	jne    801fcd <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802026:	83 ec 0c             	sub    $0xc,%esp
  802029:	68 ac 43 80 00       	push   $0x8043ac
  80202e:	e8 95 e3 ff ff       	call   8003c8 <cprintf>
  802033:	83 c4 10             	add    $0x10,%esp

}
  802036:	90                   	nop
  802037:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802042:	8b 45 0c             	mov    0xc(%ebp),%eax
  802045:	83 e0 01             	and    $0x1,%eax
  802048:	85 c0                	test   %eax,%eax
  80204a:	74 03                	je     80204f <initialize_dynamic_allocator+0x13>
  80204c:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80204f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802053:	0f 84 c7 01 00 00    	je     802220 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802059:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  802060:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802063:	8b 55 08             	mov    0x8(%ebp),%edx
  802066:	8b 45 0c             	mov    0xc(%ebp),%eax
  802069:	01 d0                	add    %edx,%eax
  80206b:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  802070:	0f 87 ad 01 00 00    	ja     802223 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	85 c0                	test   %eax,%eax
  80207b:	0f 89 a5 01 00 00    	jns    802226 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  802081:	8b 55 08             	mov    0x8(%ebp),%edx
  802084:	8b 45 0c             	mov    0xc(%ebp),%eax
  802087:	01 d0                	add    %edx,%eax
  802089:	83 e8 04             	sub    $0x4,%eax
  80208c:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  802091:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802098:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80209d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a0:	e9 87 00 00 00       	jmp    80212c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  8020a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a9:	75 14                	jne    8020bf <initialize_dynamic_allocator+0x83>
  8020ab:	83 ec 04             	sub    $0x4,%esp
  8020ae:	68 07 44 80 00       	push   $0x804407
  8020b3:	6a 79                	push   $0x79
  8020b5:	68 25 44 80 00       	push   $0x804425
  8020ba:	e8 ee 18 00 00       	call   8039ad <_panic>
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	8b 00                	mov    (%eax),%eax
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	74 10                	je     8020d8 <initialize_dynamic_allocator+0x9c>
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	8b 00                	mov    (%eax),%eax
  8020cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d0:	8b 52 04             	mov    0x4(%edx),%edx
  8020d3:	89 50 04             	mov    %edx,0x4(%eax)
  8020d6:	eb 0b                	jmp    8020e3 <initialize_dynamic_allocator+0xa7>
  8020d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020db:	8b 40 04             	mov    0x4(%eax),%eax
  8020de:	a3 30 50 80 00       	mov    %eax,0x805030
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	8b 40 04             	mov    0x4(%eax),%eax
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	74 0f                	je     8020fc <initialize_dynamic_allocator+0xc0>
  8020ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f0:	8b 40 04             	mov    0x4(%eax),%eax
  8020f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f6:	8b 12                	mov    (%edx),%edx
  8020f8:	89 10                	mov    %edx,(%eax)
  8020fa:	eb 0a                	jmp    802106 <initialize_dynamic_allocator+0xca>
  8020fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ff:	8b 00                	mov    (%eax),%eax
  802101:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802109:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80210f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802112:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802119:	a1 38 50 80 00       	mov    0x805038,%eax
  80211e:	48                   	dec    %eax
  80211f:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802124:	a1 34 50 80 00       	mov    0x805034,%eax
  802129:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802130:	74 07                	je     802139 <initialize_dynamic_allocator+0xfd>
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 00                	mov    (%eax),%eax
  802137:	eb 05                	jmp    80213e <initialize_dynamic_allocator+0x102>
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	a3 34 50 80 00       	mov    %eax,0x805034
  802143:	a1 34 50 80 00       	mov    0x805034,%eax
  802148:	85 c0                	test   %eax,%eax
  80214a:	0f 85 55 ff ff ff    	jne    8020a5 <initialize_dynamic_allocator+0x69>
  802150:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802154:	0f 85 4b ff ff ff    	jne    8020a5 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  802160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802163:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802169:	a1 44 50 80 00       	mov    0x805044,%eax
  80216e:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802173:	a1 40 50 80 00       	mov    0x805040,%eax
  802178:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	83 c0 08             	add    $0x8,%eax
  802184:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	83 c0 04             	add    $0x4,%eax
  80218d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802190:	83 ea 08             	sub    $0x8,%edx
  802193:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802195:	8b 55 0c             	mov    0xc(%ebp),%edx
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	01 d0                	add    %edx,%eax
  80219d:	83 e8 08             	sub    $0x8,%eax
  8021a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a3:	83 ea 08             	sub    $0x8,%edx
  8021a6:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8021a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8021b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021bf:	75 17                	jne    8021d8 <initialize_dynamic_allocator+0x19c>
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	68 40 44 80 00       	push   $0x804440
  8021c9:	68 90 00 00 00       	push   $0x90
  8021ce:	68 25 44 80 00       	push   $0x804425
  8021d3:	e8 d5 17 00 00       	call   8039ad <_panic>
  8021d8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e1:	89 10                	mov    %edx,(%eax)
  8021e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e6:	8b 00                	mov    (%eax),%eax
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	74 0d                	je     8021f9 <initialize_dynamic_allocator+0x1bd>
  8021ec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021f4:	89 50 04             	mov    %edx,0x4(%eax)
  8021f7:	eb 08                	jmp    802201 <initialize_dynamic_allocator+0x1c5>
  8021f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fc:	a3 30 50 80 00       	mov    %eax,0x805030
  802201:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802204:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802209:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802213:	a1 38 50 80 00       	mov    0x805038,%eax
  802218:	40                   	inc    %eax
  802219:	a3 38 50 80 00       	mov    %eax,0x805038
  80221e:	eb 07                	jmp    802227 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802220:	90                   	nop
  802221:	eb 04                	jmp    802227 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802223:	90                   	nop
  802224:	eb 01                	jmp    802227 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802226:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
  80222f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	8d 50 fc             	lea    -0x4(%eax),%edx
  802238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	83 e8 04             	sub    $0x4,%eax
  802243:	8b 00                	mov    (%eax),%eax
  802245:	83 e0 fe             	and    $0xfffffffe,%eax
  802248:	8d 50 f8             	lea    -0x8(%eax),%edx
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	01 c2                	add    %eax,%edx
  802250:	8b 45 0c             	mov    0xc(%ebp),%eax
  802253:	89 02                	mov    %eax,(%edx)
}
  802255:	90                   	nop
  802256:	5d                   	pop    %ebp
  802257:	c3                   	ret    

00802258 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	83 e0 01             	and    $0x1,%eax
  802264:	85 c0                	test   %eax,%eax
  802266:	74 03                	je     80226b <alloc_block_FF+0x13>
  802268:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80226b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80226f:	77 07                	ja     802278 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802271:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802278:	a1 24 50 80 00       	mov    0x805024,%eax
  80227d:	85 c0                	test   %eax,%eax
  80227f:	75 73                	jne    8022f4 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	83 c0 10             	add    $0x10,%eax
  802287:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80228a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802297:	01 d0                	add    %edx,%eax
  802299:	48                   	dec    %eax
  80229a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80229d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a5:	f7 75 ec             	divl   -0x14(%ebp)
  8022a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022ab:	29 d0                	sub    %edx,%eax
  8022ad:	c1 e8 0c             	shr    $0xc,%eax
  8022b0:	83 ec 0c             	sub    $0xc,%esp
  8022b3:	50                   	push   %eax
  8022b4:	e8 b1 f0 ff ff       	call   80136a <sbrk>
  8022b9:	83 c4 10             	add    $0x10,%esp
  8022bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8022bf:	83 ec 0c             	sub    $0xc,%esp
  8022c2:	6a 00                	push   $0x0
  8022c4:	e8 a1 f0 ff ff       	call   80136a <sbrk>
  8022c9:	83 c4 10             	add    $0x10,%esp
  8022cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8022cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022d2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8022d5:	83 ec 08             	sub    $0x8,%esp
  8022d8:	50                   	push   %eax
  8022d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022dc:	e8 5b fd ff ff       	call   80203c <initialize_dynamic_allocator>
  8022e1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022e4:	83 ec 0c             	sub    $0xc,%esp
  8022e7:	68 63 44 80 00       	push   $0x804463
  8022ec:	e8 d7 e0 ff ff       	call   8003c8 <cprintf>
  8022f1:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f8:	75 0a                	jne    802304 <alloc_block_FF+0xac>
	        return NULL;
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ff:	e9 0e 04 00 00       	jmp    802712 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802304:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80230b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802310:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802313:	e9 f3 02 00 00       	jmp    80260b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80231e:	83 ec 0c             	sub    $0xc,%esp
  802321:	ff 75 bc             	pushl  -0x44(%ebp)
  802324:	e8 af fb ff ff       	call   801ed8 <get_block_size>
  802329:	83 c4 10             	add    $0x10,%esp
  80232c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	83 c0 08             	add    $0x8,%eax
  802335:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802338:	0f 87 c5 02 00 00    	ja     802603 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	83 c0 18             	add    $0x18,%eax
  802344:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802347:	0f 87 19 02 00 00    	ja     802566 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80234d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802350:	2b 45 08             	sub    0x8(%ebp),%eax
  802353:	83 e8 08             	sub    $0x8,%eax
  802356:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	8d 50 08             	lea    0x8(%eax),%edx
  80235f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802362:	01 d0                	add    %edx,%eax
  802364:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	83 c0 08             	add    $0x8,%eax
  80236d:	83 ec 04             	sub    $0x4,%esp
  802370:	6a 01                	push   $0x1
  802372:	50                   	push   %eax
  802373:	ff 75 bc             	pushl  -0x44(%ebp)
  802376:	e8 ae fe ff ff       	call   802229 <set_block_data>
  80237b:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	8b 40 04             	mov    0x4(%eax),%eax
  802384:	85 c0                	test   %eax,%eax
  802386:	75 68                	jne    8023f0 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802388:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80238c:	75 17                	jne    8023a5 <alloc_block_FF+0x14d>
  80238e:	83 ec 04             	sub    $0x4,%esp
  802391:	68 40 44 80 00       	push   $0x804440
  802396:	68 d7 00 00 00       	push   $0xd7
  80239b:	68 25 44 80 00       	push   $0x804425
  8023a0:	e8 08 16 00 00       	call   8039ad <_panic>
  8023a5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8023ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ae:	89 10                	mov    %edx,(%eax)
  8023b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b3:	8b 00                	mov    (%eax),%eax
  8023b5:	85 c0                	test   %eax,%eax
  8023b7:	74 0d                	je     8023c6 <alloc_block_FF+0x16e>
  8023b9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023be:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023c1:	89 50 04             	mov    %edx,0x4(%eax)
  8023c4:	eb 08                	jmp    8023ce <alloc_block_FF+0x176>
  8023c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c9:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8023e5:	40                   	inc    %eax
  8023e6:	a3 38 50 80 00       	mov    %eax,0x805038
  8023eb:	e9 dc 00 00 00       	jmp    8024cc <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 00                	mov    (%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	75 65                	jne    80245e <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023f9:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023fd:	75 17                	jne    802416 <alloc_block_FF+0x1be>
  8023ff:	83 ec 04             	sub    $0x4,%esp
  802402:	68 74 44 80 00       	push   $0x804474
  802407:	68 db 00 00 00       	push   $0xdb
  80240c:	68 25 44 80 00       	push   $0x804425
  802411:	e8 97 15 00 00       	call   8039ad <_panic>
  802416:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80241c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80241f:	89 50 04             	mov    %edx,0x4(%eax)
  802422:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	85 c0                	test   %eax,%eax
  80242a:	74 0c                	je     802438 <alloc_block_FF+0x1e0>
  80242c:	a1 30 50 80 00       	mov    0x805030,%eax
  802431:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802434:	89 10                	mov    %edx,(%eax)
  802436:	eb 08                	jmp    802440 <alloc_block_FF+0x1e8>
  802438:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802440:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802443:	a3 30 50 80 00       	mov    %eax,0x805030
  802448:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80244b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802451:	a1 38 50 80 00       	mov    0x805038,%eax
  802456:	40                   	inc    %eax
  802457:	a3 38 50 80 00       	mov    %eax,0x805038
  80245c:	eb 6e                	jmp    8024cc <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80245e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802462:	74 06                	je     80246a <alloc_block_FF+0x212>
  802464:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802468:	75 17                	jne    802481 <alloc_block_FF+0x229>
  80246a:	83 ec 04             	sub    $0x4,%esp
  80246d:	68 98 44 80 00       	push   $0x804498
  802472:	68 df 00 00 00       	push   $0xdf
  802477:	68 25 44 80 00       	push   $0x804425
  80247c:	e8 2c 15 00 00       	call   8039ad <_panic>
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 10                	mov    (%eax),%edx
  802486:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802489:	89 10                	mov    %edx,(%eax)
  80248b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80248e:	8b 00                	mov    (%eax),%eax
  802490:	85 c0                	test   %eax,%eax
  802492:	74 0b                	je     80249f <alloc_block_FF+0x247>
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 00                	mov    (%eax),%eax
  802499:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80249c:	89 50 04             	mov    %edx,0x4(%eax)
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024a5:	89 10                	mov    %edx,(%eax)
  8024a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ad:	89 50 04             	mov    %edx,0x4(%eax)
  8024b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	75 08                	jne    8024c1 <alloc_block_FF+0x269>
  8024b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024bc:	a3 30 50 80 00       	mov    %eax,0x805030
  8024c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8024c6:	40                   	inc    %eax
  8024c7:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8024cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d0:	75 17                	jne    8024e9 <alloc_block_FF+0x291>
  8024d2:	83 ec 04             	sub    $0x4,%esp
  8024d5:	68 07 44 80 00       	push   $0x804407
  8024da:	68 e1 00 00 00       	push   $0xe1
  8024df:	68 25 44 80 00       	push   $0x804425
  8024e4:	e8 c4 14 00 00       	call   8039ad <_panic>
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 00                	mov    (%eax),%eax
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	74 10                	je     802502 <alloc_block_FF+0x2aa>
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	8b 00                	mov    (%eax),%eax
  8024f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fa:	8b 52 04             	mov    0x4(%edx),%edx
  8024fd:	89 50 04             	mov    %edx,0x4(%eax)
  802500:	eb 0b                	jmp    80250d <alloc_block_FF+0x2b5>
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 40 04             	mov    0x4(%eax),%eax
  802508:	a3 30 50 80 00       	mov    %eax,0x805030
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 40 04             	mov    0x4(%eax),%eax
  802513:	85 c0                	test   %eax,%eax
  802515:	74 0f                	je     802526 <alloc_block_FF+0x2ce>
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 40 04             	mov    0x4(%eax),%eax
  80251d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802520:	8b 12                	mov    (%edx),%edx
  802522:	89 10                	mov    %edx,(%eax)
  802524:	eb 0a                	jmp    802530 <alloc_block_FF+0x2d8>
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 00                	mov    (%eax),%eax
  80252b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802543:	a1 38 50 80 00       	mov    0x805038,%eax
  802548:	48                   	dec    %eax
  802549:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80254e:	83 ec 04             	sub    $0x4,%esp
  802551:	6a 00                	push   $0x0
  802553:	ff 75 b4             	pushl  -0x4c(%ebp)
  802556:	ff 75 b0             	pushl  -0x50(%ebp)
  802559:	e8 cb fc ff ff       	call   802229 <set_block_data>
  80255e:	83 c4 10             	add    $0x10,%esp
  802561:	e9 95 00 00 00       	jmp    8025fb <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802566:	83 ec 04             	sub    $0x4,%esp
  802569:	6a 01                	push   $0x1
  80256b:	ff 75 b8             	pushl  -0x48(%ebp)
  80256e:	ff 75 bc             	pushl  -0x44(%ebp)
  802571:	e8 b3 fc ff ff       	call   802229 <set_block_data>
  802576:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257d:	75 17                	jne    802596 <alloc_block_FF+0x33e>
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	68 07 44 80 00       	push   $0x804407
  802587:	68 e8 00 00 00       	push   $0xe8
  80258c:	68 25 44 80 00       	push   $0x804425
  802591:	e8 17 14 00 00       	call   8039ad <_panic>
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 00                	mov    (%eax),%eax
  80259b:	85 c0                	test   %eax,%eax
  80259d:	74 10                	je     8025af <alloc_block_FF+0x357>
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a7:	8b 52 04             	mov    0x4(%edx),%edx
  8025aa:	89 50 04             	mov    %edx,0x4(%eax)
  8025ad:	eb 0b                	jmp    8025ba <alloc_block_FF+0x362>
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 40 04             	mov    0x4(%eax),%eax
  8025b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 40 04             	mov    0x4(%eax),%eax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	74 0f                	je     8025d3 <alloc_block_FF+0x37b>
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cd:	8b 12                	mov    (%edx),%edx
  8025cf:	89 10                	mov    %edx,(%eax)
  8025d1:	eb 0a                	jmp    8025dd <alloc_block_FF+0x385>
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f0:	a1 38 50 80 00       	mov    0x805038,%eax
  8025f5:	48                   	dec    %eax
  8025f6:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8025fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025fe:	e9 0f 01 00 00       	jmp    802712 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802603:	a1 34 50 80 00       	mov    0x805034,%eax
  802608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260f:	74 07                	je     802618 <alloc_block_FF+0x3c0>
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 00                	mov    (%eax),%eax
  802616:	eb 05                	jmp    80261d <alloc_block_FF+0x3c5>
  802618:	b8 00 00 00 00       	mov    $0x0,%eax
  80261d:	a3 34 50 80 00       	mov    %eax,0x805034
  802622:	a1 34 50 80 00       	mov    0x805034,%eax
  802627:	85 c0                	test   %eax,%eax
  802629:	0f 85 e9 fc ff ff    	jne    802318 <alloc_block_FF+0xc0>
  80262f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802633:	0f 85 df fc ff ff    	jne    802318 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	83 c0 08             	add    $0x8,%eax
  80263f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802642:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802649:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80264c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80264f:	01 d0                	add    %edx,%eax
  802651:	48                   	dec    %eax
  802652:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802655:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802658:	ba 00 00 00 00       	mov    $0x0,%edx
  80265d:	f7 75 d8             	divl   -0x28(%ebp)
  802660:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802663:	29 d0                	sub    %edx,%eax
  802665:	c1 e8 0c             	shr    $0xc,%eax
  802668:	83 ec 0c             	sub    $0xc,%esp
  80266b:	50                   	push   %eax
  80266c:	e8 f9 ec ff ff       	call   80136a <sbrk>
  802671:	83 c4 10             	add    $0x10,%esp
  802674:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802677:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80267b:	75 0a                	jne    802687 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax
  802682:	e9 8b 00 00 00       	jmp    802712 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802687:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80268e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802691:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802694:	01 d0                	add    %edx,%eax
  802696:	48                   	dec    %eax
  802697:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80269a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80269d:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a2:	f7 75 cc             	divl   -0x34(%ebp)
  8026a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8026a8:	29 d0                	sub    %edx,%eax
  8026aa:	8d 50 fc             	lea    -0x4(%eax),%edx
  8026ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026b0:	01 d0                	add    %edx,%eax
  8026b2:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026b7:	a1 40 50 80 00       	mov    0x805040,%eax
  8026bc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8026c2:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8026c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026cc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026cf:	01 d0                	add    %edx,%eax
  8026d1:	48                   	dec    %eax
  8026d2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026dd:	f7 75 c4             	divl   -0x3c(%ebp)
  8026e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026e3:	29 d0                	sub    %edx,%eax
  8026e5:	83 ec 04             	sub    $0x4,%esp
  8026e8:	6a 01                	push   $0x1
  8026ea:	50                   	push   %eax
  8026eb:	ff 75 d0             	pushl  -0x30(%ebp)
  8026ee:	e8 36 fb ff ff       	call   802229 <set_block_data>
  8026f3:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026f6:	83 ec 0c             	sub    $0xc,%esp
  8026f9:	ff 75 d0             	pushl  -0x30(%ebp)
  8026fc:	e8 1b 0a 00 00       	call   80311c <free_block>
  802701:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802704:	83 ec 0c             	sub    $0xc,%esp
  802707:	ff 75 08             	pushl  0x8(%ebp)
  80270a:	e8 49 fb ff ff       	call   802258 <alloc_block_FF>
  80270f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802712:	c9                   	leave  
  802713:	c3                   	ret    

00802714 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
  802717:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80271a:	8b 45 08             	mov    0x8(%ebp),%eax
  80271d:	83 e0 01             	and    $0x1,%eax
  802720:	85 c0                	test   %eax,%eax
  802722:	74 03                	je     802727 <alloc_block_BF+0x13>
  802724:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802727:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80272b:	77 07                	ja     802734 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80272d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802734:	a1 24 50 80 00       	mov    0x805024,%eax
  802739:	85 c0                	test   %eax,%eax
  80273b:	75 73                	jne    8027b0 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80273d:	8b 45 08             	mov    0x8(%ebp),%eax
  802740:	83 c0 10             	add    $0x10,%eax
  802743:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802746:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80274d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802750:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802753:	01 d0                	add    %edx,%eax
  802755:	48                   	dec    %eax
  802756:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802759:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80275c:	ba 00 00 00 00       	mov    $0x0,%edx
  802761:	f7 75 e0             	divl   -0x20(%ebp)
  802764:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802767:	29 d0                	sub    %edx,%eax
  802769:	c1 e8 0c             	shr    $0xc,%eax
  80276c:	83 ec 0c             	sub    $0xc,%esp
  80276f:	50                   	push   %eax
  802770:	e8 f5 eb ff ff       	call   80136a <sbrk>
  802775:	83 c4 10             	add    $0x10,%esp
  802778:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80277b:	83 ec 0c             	sub    $0xc,%esp
  80277e:	6a 00                	push   $0x0
  802780:	e8 e5 eb ff ff       	call   80136a <sbrk>
  802785:	83 c4 10             	add    $0x10,%esp
  802788:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80278b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80278e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802791:	83 ec 08             	sub    $0x8,%esp
  802794:	50                   	push   %eax
  802795:	ff 75 d8             	pushl  -0x28(%ebp)
  802798:	e8 9f f8 ff ff       	call   80203c <initialize_dynamic_allocator>
  80279d:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8027a0:	83 ec 0c             	sub    $0xc,%esp
  8027a3:	68 63 44 80 00       	push   $0x804463
  8027a8:	e8 1b dc ff ff       	call   8003c8 <cprintf>
  8027ad:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8027b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8027be:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8027cc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d4:	e9 1d 01 00 00       	jmp    8028f6 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027df:	83 ec 0c             	sub    $0xc,%esp
  8027e2:	ff 75 a8             	pushl  -0x58(%ebp)
  8027e5:	e8 ee f6 ff ff       	call   801ed8 <get_block_size>
  8027ea:	83 c4 10             	add    $0x10,%esp
  8027ed:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f3:	83 c0 08             	add    $0x8,%eax
  8027f6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027f9:	0f 87 ef 00 00 00    	ja     8028ee <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802802:	83 c0 18             	add    $0x18,%eax
  802805:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802808:	77 1d                	ja     802827 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80280a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802810:	0f 86 d8 00 00 00    	jbe    8028ee <alloc_block_BF+0x1da>
				{
					best_va = va;
  802816:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802819:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80281c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80281f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802822:	e9 c7 00 00 00       	jmp    8028ee <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	83 c0 08             	add    $0x8,%eax
  80282d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802830:	0f 85 9d 00 00 00    	jne    8028d3 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802836:	83 ec 04             	sub    $0x4,%esp
  802839:	6a 01                	push   $0x1
  80283b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80283e:	ff 75 a8             	pushl  -0x58(%ebp)
  802841:	e8 e3 f9 ff ff       	call   802229 <set_block_data>
  802846:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284d:	75 17                	jne    802866 <alloc_block_BF+0x152>
  80284f:	83 ec 04             	sub    $0x4,%esp
  802852:	68 07 44 80 00       	push   $0x804407
  802857:	68 2c 01 00 00       	push   $0x12c
  80285c:	68 25 44 80 00       	push   $0x804425
  802861:	e8 47 11 00 00       	call   8039ad <_panic>
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	74 10                	je     80287f <alloc_block_BF+0x16b>
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 00                	mov    (%eax),%eax
  802874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802877:	8b 52 04             	mov    0x4(%edx),%edx
  80287a:	89 50 04             	mov    %edx,0x4(%eax)
  80287d:	eb 0b                	jmp    80288a <alloc_block_BF+0x176>
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 04             	mov    0x4(%eax),%eax
  802885:	a3 30 50 80 00       	mov    %eax,0x805030
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 40 04             	mov    0x4(%eax),%eax
  802890:	85 c0                	test   %eax,%eax
  802892:	74 0f                	je     8028a3 <alloc_block_BF+0x18f>
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 40 04             	mov    0x4(%eax),%eax
  80289a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289d:	8b 12                	mov    (%edx),%edx
  80289f:	89 10                	mov    %edx,(%eax)
  8028a1:	eb 0a                	jmp    8028ad <alloc_block_BF+0x199>
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 00                	mov    (%eax),%eax
  8028a8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c0:	a1 38 50 80 00       	mov    0x805038,%eax
  8028c5:	48                   	dec    %eax
  8028c6:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8028cb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028ce:	e9 24 04 00 00       	jmp    802cf7 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8028d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028d9:	76 13                	jbe    8028ee <alloc_block_BF+0x1da>
					{
						internal = 1;
  8028db:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028e2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8028e8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028eb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8028ee:	a1 34 50 80 00       	mov    0x805034,%eax
  8028f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fa:	74 07                	je     802903 <alloc_block_BF+0x1ef>
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	eb 05                	jmp    802908 <alloc_block_BF+0x1f4>
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	a3 34 50 80 00       	mov    %eax,0x805034
  80290d:	a1 34 50 80 00       	mov    0x805034,%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	0f 85 bf fe ff ff    	jne    8027d9 <alloc_block_BF+0xc5>
  80291a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291e:	0f 85 b5 fe ff ff    	jne    8027d9 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802924:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802928:	0f 84 26 02 00 00    	je     802b54 <alloc_block_BF+0x440>
  80292e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802932:	0f 85 1c 02 00 00    	jne    802b54 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802938:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293b:	2b 45 08             	sub    0x8(%ebp),%eax
  80293e:	83 e8 08             	sub    $0x8,%eax
  802941:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	8d 50 08             	lea    0x8(%eax),%edx
  80294a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294d:	01 d0                	add    %edx,%eax
  80294f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802952:	8b 45 08             	mov    0x8(%ebp),%eax
  802955:	83 c0 08             	add    $0x8,%eax
  802958:	83 ec 04             	sub    $0x4,%esp
  80295b:	6a 01                	push   $0x1
  80295d:	50                   	push   %eax
  80295e:	ff 75 f0             	pushl  -0x10(%ebp)
  802961:	e8 c3 f8 ff ff       	call   802229 <set_block_data>
  802966:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296c:	8b 40 04             	mov    0x4(%eax),%eax
  80296f:	85 c0                	test   %eax,%eax
  802971:	75 68                	jne    8029db <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802973:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802977:	75 17                	jne    802990 <alloc_block_BF+0x27c>
  802979:	83 ec 04             	sub    $0x4,%esp
  80297c:	68 40 44 80 00       	push   $0x804440
  802981:	68 45 01 00 00       	push   $0x145
  802986:	68 25 44 80 00       	push   $0x804425
  80298b:	e8 1d 10 00 00       	call   8039ad <_panic>
  802990:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802996:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802999:	89 10                	mov    %edx,(%eax)
  80299b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80299e:	8b 00                	mov    (%eax),%eax
  8029a0:	85 c0                	test   %eax,%eax
  8029a2:	74 0d                	je     8029b1 <alloc_block_BF+0x29d>
  8029a4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8029a9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029ac:	89 50 04             	mov    %edx,0x4(%eax)
  8029af:	eb 08                	jmp    8029b9 <alloc_block_BF+0x2a5>
  8029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8029b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029cb:	a1 38 50 80 00       	mov    0x805038,%eax
  8029d0:	40                   	inc    %eax
  8029d1:	a3 38 50 80 00       	mov    %eax,0x805038
  8029d6:	e9 dc 00 00 00       	jmp    802ab7 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8029db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	75 65                	jne    802a49 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029e4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029e8:	75 17                	jne    802a01 <alloc_block_BF+0x2ed>
  8029ea:	83 ec 04             	sub    $0x4,%esp
  8029ed:	68 74 44 80 00       	push   $0x804474
  8029f2:	68 4a 01 00 00       	push   $0x14a
  8029f7:	68 25 44 80 00       	push   $0x804425
  8029fc:	e8 ac 0f 00 00       	call   8039ad <_panic>
  802a01:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a07:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0a:	89 50 04             	mov    %edx,0x4(%eax)
  802a0d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a10:	8b 40 04             	mov    0x4(%eax),%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	74 0c                	je     802a23 <alloc_block_BF+0x30f>
  802a17:	a1 30 50 80 00       	mov    0x805030,%eax
  802a1c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a1f:	89 10                	mov    %edx,(%eax)
  802a21:	eb 08                	jmp    802a2b <alloc_block_BF+0x317>
  802a23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a26:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a2b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a2e:	a3 30 50 80 00       	mov    %eax,0x805030
  802a33:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3c:	a1 38 50 80 00       	mov    0x805038,%eax
  802a41:	40                   	inc    %eax
  802a42:	a3 38 50 80 00       	mov    %eax,0x805038
  802a47:	eb 6e                	jmp    802ab7 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a4d:	74 06                	je     802a55 <alloc_block_BF+0x341>
  802a4f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a53:	75 17                	jne    802a6c <alloc_block_BF+0x358>
  802a55:	83 ec 04             	sub    $0x4,%esp
  802a58:	68 98 44 80 00       	push   $0x804498
  802a5d:	68 4f 01 00 00       	push   $0x14f
  802a62:	68 25 44 80 00       	push   $0x804425
  802a67:	e8 41 0f 00 00       	call   8039ad <_panic>
  802a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6f:	8b 10                	mov    (%eax),%edx
  802a71:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a74:	89 10                	mov    %edx,(%eax)
  802a76:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a79:	8b 00                	mov    (%eax),%eax
  802a7b:	85 c0                	test   %eax,%eax
  802a7d:	74 0b                	je     802a8a <alloc_block_BF+0x376>
  802a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a87:	89 50 04             	mov    %edx,0x4(%eax)
  802a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a90:	89 10                	mov    %edx,(%eax)
  802a92:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
  802a9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	75 08                	jne    802aac <alloc_block_BF+0x398>
  802aa4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802aa7:	a3 30 50 80 00       	mov    %eax,0x805030
  802aac:	a1 38 50 80 00       	mov    0x805038,%eax
  802ab1:	40                   	inc    %eax
  802ab2:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802ab7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802abb:	75 17                	jne    802ad4 <alloc_block_BF+0x3c0>
  802abd:	83 ec 04             	sub    $0x4,%esp
  802ac0:	68 07 44 80 00       	push   $0x804407
  802ac5:	68 51 01 00 00       	push   $0x151
  802aca:	68 25 44 80 00       	push   $0x804425
  802acf:	e8 d9 0e 00 00       	call   8039ad <_panic>
  802ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	74 10                	je     802aed <alloc_block_BF+0x3d9>
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	8b 00                	mov    (%eax),%eax
  802ae2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae5:	8b 52 04             	mov    0x4(%edx),%edx
  802ae8:	89 50 04             	mov    %edx,0x4(%eax)
  802aeb:	eb 0b                	jmp    802af8 <alloc_block_BF+0x3e4>
  802aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af0:	8b 40 04             	mov    0x4(%eax),%eax
  802af3:	a3 30 50 80 00       	mov    %eax,0x805030
  802af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afb:	8b 40 04             	mov    0x4(%eax),%eax
  802afe:	85 c0                	test   %eax,%eax
  802b00:	74 0f                	je     802b11 <alloc_block_BF+0x3fd>
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	8b 40 04             	mov    0x4(%eax),%eax
  802b08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0b:	8b 12                	mov    (%edx),%edx
  802b0d:	89 10                	mov    %edx,(%eax)
  802b0f:	eb 0a                	jmp    802b1b <alloc_block_BF+0x407>
  802b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2e:	a1 38 50 80 00       	mov    0x805038,%eax
  802b33:	48                   	dec    %eax
  802b34:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b39:	83 ec 04             	sub    $0x4,%esp
  802b3c:	6a 00                	push   $0x0
  802b3e:	ff 75 d0             	pushl  -0x30(%ebp)
  802b41:	ff 75 cc             	pushl  -0x34(%ebp)
  802b44:	e8 e0 f6 ff ff       	call   802229 <set_block_data>
  802b49:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4f:	e9 a3 01 00 00       	jmp    802cf7 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b54:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b58:	0f 85 9d 00 00 00    	jne    802bfb <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b5e:	83 ec 04             	sub    $0x4,%esp
  802b61:	6a 01                	push   $0x1
  802b63:	ff 75 ec             	pushl  -0x14(%ebp)
  802b66:	ff 75 f0             	pushl  -0x10(%ebp)
  802b69:	e8 bb f6 ff ff       	call   802229 <set_block_data>
  802b6e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b75:	75 17                	jne    802b8e <alloc_block_BF+0x47a>
  802b77:	83 ec 04             	sub    $0x4,%esp
  802b7a:	68 07 44 80 00       	push   $0x804407
  802b7f:	68 58 01 00 00       	push   $0x158
  802b84:	68 25 44 80 00       	push   $0x804425
  802b89:	e8 1f 0e 00 00       	call   8039ad <_panic>
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	8b 00                	mov    (%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 10                	je     802ba7 <alloc_block_BF+0x493>
  802b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9f:	8b 52 04             	mov    0x4(%edx),%edx
  802ba2:	89 50 04             	mov    %edx,0x4(%eax)
  802ba5:	eb 0b                	jmp    802bb2 <alloc_block_BF+0x49e>
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	8b 40 04             	mov    0x4(%eax),%eax
  802bad:	a3 30 50 80 00       	mov    %eax,0x805030
  802bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb5:	8b 40 04             	mov    0x4(%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 0f                	je     802bcb <alloc_block_BF+0x4b7>
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 40 04             	mov    0x4(%eax),%eax
  802bc2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc5:	8b 12                	mov    (%edx),%edx
  802bc7:	89 10                	mov    %edx,(%eax)
  802bc9:	eb 0a                	jmp    802bd5 <alloc_block_BF+0x4c1>
  802bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bce:	8b 00                	mov    (%eax),%eax
  802bd0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be8:	a1 38 50 80 00       	mov    0x805038,%eax
  802bed:	48                   	dec    %eax
  802bee:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf6:	e9 fc 00 00 00       	jmp    802cf7 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	83 c0 08             	add    $0x8,%eax
  802c01:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c04:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c0b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c0e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c11:	01 d0                	add    %edx,%eax
  802c13:	48                   	dec    %eax
  802c14:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c17:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c1f:	f7 75 c4             	divl   -0x3c(%ebp)
  802c22:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c25:	29 d0                	sub    %edx,%eax
  802c27:	c1 e8 0c             	shr    $0xc,%eax
  802c2a:	83 ec 0c             	sub    $0xc,%esp
  802c2d:	50                   	push   %eax
  802c2e:	e8 37 e7 ff ff       	call   80136a <sbrk>
  802c33:	83 c4 10             	add    $0x10,%esp
  802c36:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c39:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c3d:	75 0a                	jne    802c49 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802c44:	e9 ae 00 00 00       	jmp    802cf7 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c49:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c50:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c53:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c56:	01 d0                	add    %edx,%eax
  802c58:	48                   	dec    %eax
  802c59:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c5c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c5f:	ba 00 00 00 00       	mov    $0x0,%edx
  802c64:	f7 75 b8             	divl   -0x48(%ebp)
  802c67:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c6a:	29 d0                	sub    %edx,%eax
  802c6c:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c6f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c72:	01 d0                	add    %edx,%eax
  802c74:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c79:	a1 40 50 80 00       	mov    0x805040,%eax
  802c7e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c84:	83 ec 0c             	sub    $0xc,%esp
  802c87:	68 cc 44 80 00       	push   $0x8044cc
  802c8c:	e8 37 d7 ff ff       	call   8003c8 <cprintf>
  802c91:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c94:	83 ec 08             	sub    $0x8,%esp
  802c97:	ff 75 bc             	pushl  -0x44(%ebp)
  802c9a:	68 d1 44 80 00       	push   $0x8044d1
  802c9f:	e8 24 d7 ff ff       	call   8003c8 <cprintf>
  802ca4:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ca7:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cae:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cb1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cb4:	01 d0                	add    %edx,%eax
  802cb6:	48                   	dec    %eax
  802cb7:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802cba:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc2:	f7 75 b0             	divl   -0x50(%ebp)
  802cc5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cc8:	29 d0                	sub    %edx,%eax
  802cca:	83 ec 04             	sub    $0x4,%esp
  802ccd:	6a 01                	push   $0x1
  802ccf:	50                   	push   %eax
  802cd0:	ff 75 bc             	pushl  -0x44(%ebp)
  802cd3:	e8 51 f5 ff ff       	call   802229 <set_block_data>
  802cd8:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802cdb:	83 ec 0c             	sub    $0xc,%esp
  802cde:	ff 75 bc             	pushl  -0x44(%ebp)
  802ce1:	e8 36 04 00 00       	call   80311c <free_block>
  802ce6:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802ce9:	83 ec 0c             	sub    $0xc,%esp
  802cec:	ff 75 08             	pushl  0x8(%ebp)
  802cef:	e8 20 fa ff ff       	call   802714 <alloc_block_BF>
  802cf4:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802cf7:	c9                   	leave  
  802cf8:	c3                   	ret    

00802cf9 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802cf9:	55                   	push   %ebp
  802cfa:	89 e5                	mov    %esp,%ebp
  802cfc:	53                   	push   %ebx
  802cfd:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d12:	74 1e                	je     802d32 <merging+0x39>
  802d14:	ff 75 08             	pushl  0x8(%ebp)
  802d17:	e8 bc f1 ff ff       	call   801ed8 <get_block_size>
  802d1c:	83 c4 04             	add    $0x4,%esp
  802d1f:	89 c2                	mov    %eax,%edx
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	01 d0                	add    %edx,%eax
  802d26:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d29:	75 07                	jne    802d32 <merging+0x39>
		prev_is_free = 1;
  802d2b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d36:	74 1e                	je     802d56 <merging+0x5d>
  802d38:	ff 75 10             	pushl  0x10(%ebp)
  802d3b:	e8 98 f1 ff ff       	call   801ed8 <get_block_size>
  802d40:	83 c4 04             	add    $0x4,%esp
  802d43:	89 c2                	mov    %eax,%edx
  802d45:	8b 45 10             	mov    0x10(%ebp),%eax
  802d48:	01 d0                	add    %edx,%eax
  802d4a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d4d:	75 07                	jne    802d56 <merging+0x5d>
		next_is_free = 1;
  802d4f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5a:	0f 84 cc 00 00 00    	je     802e2c <merging+0x133>
  802d60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d64:	0f 84 c2 00 00 00    	je     802e2c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d6a:	ff 75 08             	pushl  0x8(%ebp)
  802d6d:	e8 66 f1 ff ff       	call   801ed8 <get_block_size>
  802d72:	83 c4 04             	add    $0x4,%esp
  802d75:	89 c3                	mov    %eax,%ebx
  802d77:	ff 75 10             	pushl  0x10(%ebp)
  802d7a:	e8 59 f1 ff ff       	call   801ed8 <get_block_size>
  802d7f:	83 c4 04             	add    $0x4,%esp
  802d82:	01 c3                	add    %eax,%ebx
  802d84:	ff 75 0c             	pushl  0xc(%ebp)
  802d87:	e8 4c f1 ff ff       	call   801ed8 <get_block_size>
  802d8c:	83 c4 04             	add    $0x4,%esp
  802d8f:	01 d8                	add    %ebx,%eax
  802d91:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d94:	6a 00                	push   $0x0
  802d96:	ff 75 ec             	pushl  -0x14(%ebp)
  802d99:	ff 75 08             	pushl  0x8(%ebp)
  802d9c:	e8 88 f4 ff ff       	call   802229 <set_block_data>
  802da1:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802da4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802da8:	75 17                	jne    802dc1 <merging+0xc8>
  802daa:	83 ec 04             	sub    $0x4,%esp
  802dad:	68 07 44 80 00       	push   $0x804407
  802db2:	68 7d 01 00 00       	push   $0x17d
  802db7:	68 25 44 80 00       	push   $0x804425
  802dbc:	e8 ec 0b 00 00       	call   8039ad <_panic>
  802dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc4:	8b 00                	mov    (%eax),%eax
  802dc6:	85 c0                	test   %eax,%eax
  802dc8:	74 10                	je     802dda <merging+0xe1>
  802dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dd2:	8b 52 04             	mov    0x4(%edx),%edx
  802dd5:	89 50 04             	mov    %edx,0x4(%eax)
  802dd8:	eb 0b                	jmp    802de5 <merging+0xec>
  802dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ddd:	8b 40 04             	mov    0x4(%eax),%eax
  802de0:	a3 30 50 80 00       	mov    %eax,0x805030
  802de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de8:	8b 40 04             	mov    0x4(%eax),%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	74 0f                	je     802dfe <merging+0x105>
  802def:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df2:	8b 40 04             	mov    0x4(%eax),%eax
  802df5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df8:	8b 12                	mov    (%edx),%edx
  802dfa:	89 10                	mov    %edx,(%eax)
  802dfc:	eb 0a                	jmp    802e08 <merging+0x10f>
  802dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1b:	a1 38 50 80 00       	mov    0x805038,%eax
  802e20:	48                   	dec    %eax
  802e21:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e26:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e27:	e9 ea 02 00 00       	jmp    803116 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e30:	74 3b                	je     802e6d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e32:	83 ec 0c             	sub    $0xc,%esp
  802e35:	ff 75 08             	pushl  0x8(%ebp)
  802e38:	e8 9b f0 ff ff       	call   801ed8 <get_block_size>
  802e3d:	83 c4 10             	add    $0x10,%esp
  802e40:	89 c3                	mov    %eax,%ebx
  802e42:	83 ec 0c             	sub    $0xc,%esp
  802e45:	ff 75 10             	pushl  0x10(%ebp)
  802e48:	e8 8b f0 ff ff       	call   801ed8 <get_block_size>
  802e4d:	83 c4 10             	add    $0x10,%esp
  802e50:	01 d8                	add    %ebx,%eax
  802e52:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e55:	83 ec 04             	sub    $0x4,%esp
  802e58:	6a 00                	push   $0x0
  802e5a:	ff 75 e8             	pushl  -0x18(%ebp)
  802e5d:	ff 75 08             	pushl  0x8(%ebp)
  802e60:	e8 c4 f3 ff ff       	call   802229 <set_block_data>
  802e65:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e68:	e9 a9 02 00 00       	jmp    803116 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e71:	0f 84 2d 01 00 00    	je     802fa4 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e77:	83 ec 0c             	sub    $0xc,%esp
  802e7a:	ff 75 10             	pushl  0x10(%ebp)
  802e7d:	e8 56 f0 ff ff       	call   801ed8 <get_block_size>
  802e82:	83 c4 10             	add    $0x10,%esp
  802e85:	89 c3                	mov    %eax,%ebx
  802e87:	83 ec 0c             	sub    $0xc,%esp
  802e8a:	ff 75 0c             	pushl  0xc(%ebp)
  802e8d:	e8 46 f0 ff ff       	call   801ed8 <get_block_size>
  802e92:	83 c4 10             	add    $0x10,%esp
  802e95:	01 d8                	add    %ebx,%eax
  802e97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e9a:	83 ec 04             	sub    $0x4,%esp
  802e9d:	6a 00                	push   $0x0
  802e9f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ea2:	ff 75 10             	pushl  0x10(%ebp)
  802ea5:	e8 7f f3 ff ff       	call   802229 <set_block_data>
  802eaa:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ead:	8b 45 10             	mov    0x10(%ebp),%eax
  802eb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802eb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eb7:	74 06                	je     802ebf <merging+0x1c6>
  802eb9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ebd:	75 17                	jne    802ed6 <merging+0x1dd>
  802ebf:	83 ec 04             	sub    $0x4,%esp
  802ec2:	68 e0 44 80 00       	push   $0x8044e0
  802ec7:	68 8d 01 00 00       	push   $0x18d
  802ecc:	68 25 44 80 00       	push   $0x804425
  802ed1:	e8 d7 0a 00 00       	call   8039ad <_panic>
  802ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed9:	8b 50 04             	mov    0x4(%eax),%edx
  802edc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802edf:	89 50 04             	mov    %edx,0x4(%eax)
  802ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ee8:	89 10                	mov    %edx,(%eax)
  802eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eed:	8b 40 04             	mov    0x4(%eax),%eax
  802ef0:	85 c0                	test   %eax,%eax
  802ef2:	74 0d                	je     802f01 <merging+0x208>
  802ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ef7:	8b 40 04             	mov    0x4(%eax),%eax
  802efa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802efd:	89 10                	mov    %edx,(%eax)
  802eff:	eb 08                	jmp    802f09 <merging+0x210>
  802f01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f04:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f0f:	89 50 04             	mov    %edx,0x4(%eax)
  802f12:	a1 38 50 80 00       	mov    0x805038,%eax
  802f17:	40                   	inc    %eax
  802f18:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f21:	75 17                	jne    802f3a <merging+0x241>
  802f23:	83 ec 04             	sub    $0x4,%esp
  802f26:	68 07 44 80 00       	push   $0x804407
  802f2b:	68 8e 01 00 00       	push   $0x18e
  802f30:	68 25 44 80 00       	push   $0x804425
  802f35:	e8 73 0a 00 00       	call   8039ad <_panic>
  802f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3d:	8b 00                	mov    (%eax),%eax
  802f3f:	85 c0                	test   %eax,%eax
  802f41:	74 10                	je     802f53 <merging+0x25a>
  802f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f4b:	8b 52 04             	mov    0x4(%edx),%edx
  802f4e:	89 50 04             	mov    %edx,0x4(%eax)
  802f51:	eb 0b                	jmp    802f5e <merging+0x265>
  802f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f56:	8b 40 04             	mov    0x4(%eax),%eax
  802f59:	a3 30 50 80 00       	mov    %eax,0x805030
  802f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f61:	8b 40 04             	mov    0x4(%eax),%eax
  802f64:	85 c0                	test   %eax,%eax
  802f66:	74 0f                	je     802f77 <merging+0x27e>
  802f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6b:	8b 40 04             	mov    0x4(%eax),%eax
  802f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f71:	8b 12                	mov    (%edx),%edx
  802f73:	89 10                	mov    %edx,(%eax)
  802f75:	eb 0a                	jmp    802f81 <merging+0x288>
  802f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f94:	a1 38 50 80 00       	mov    0x805038,%eax
  802f99:	48                   	dec    %eax
  802f9a:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f9f:	e9 72 01 00 00       	jmp    803116 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  802fa7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802faa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fae:	74 79                	je     803029 <merging+0x330>
  802fb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fb4:	74 73                	je     803029 <merging+0x330>
  802fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fba:	74 06                	je     802fc2 <merging+0x2c9>
  802fbc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fc0:	75 17                	jne    802fd9 <merging+0x2e0>
  802fc2:	83 ec 04             	sub    $0x4,%esp
  802fc5:	68 98 44 80 00       	push   $0x804498
  802fca:	68 94 01 00 00       	push   $0x194
  802fcf:	68 25 44 80 00       	push   $0x804425
  802fd4:	e8 d4 09 00 00       	call   8039ad <_panic>
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	8b 10                	mov    (%eax),%edx
  802fde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe1:	89 10                	mov    %edx,(%eax)
  802fe3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe6:	8b 00                	mov    (%eax),%eax
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	74 0b                	je     802ff7 <merging+0x2fe>
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ff4:	89 50 04             	mov    %edx,0x4(%eax)
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ffd:	89 10                	mov    %edx,(%eax)
  802fff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803002:	8b 55 08             	mov    0x8(%ebp),%edx
  803005:	89 50 04             	mov    %edx,0x4(%eax)
  803008:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80300b:	8b 00                	mov    (%eax),%eax
  80300d:	85 c0                	test   %eax,%eax
  80300f:	75 08                	jne    803019 <merging+0x320>
  803011:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803014:	a3 30 50 80 00       	mov    %eax,0x805030
  803019:	a1 38 50 80 00       	mov    0x805038,%eax
  80301e:	40                   	inc    %eax
  80301f:	a3 38 50 80 00       	mov    %eax,0x805038
  803024:	e9 ce 00 00 00       	jmp    8030f7 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803029:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302d:	74 65                	je     803094 <merging+0x39b>
  80302f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803033:	75 17                	jne    80304c <merging+0x353>
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	68 74 44 80 00       	push   $0x804474
  80303d:	68 95 01 00 00       	push   $0x195
  803042:	68 25 44 80 00       	push   $0x804425
  803047:	e8 61 09 00 00       	call   8039ad <_panic>
  80304c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803052:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803055:	89 50 04             	mov    %edx,0x4(%eax)
  803058:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305b:	8b 40 04             	mov    0x4(%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 0c                	je     80306e <merging+0x375>
  803062:	a1 30 50 80 00       	mov    0x805030,%eax
  803067:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80306a:	89 10                	mov    %edx,(%eax)
  80306c:	eb 08                	jmp    803076 <merging+0x37d>
  80306e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803071:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803076:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803079:	a3 30 50 80 00       	mov    %eax,0x805030
  80307e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803081:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803087:	a1 38 50 80 00       	mov    0x805038,%eax
  80308c:	40                   	inc    %eax
  80308d:	a3 38 50 80 00       	mov    %eax,0x805038
  803092:	eb 63                	jmp    8030f7 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803094:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803098:	75 17                	jne    8030b1 <merging+0x3b8>
  80309a:	83 ec 04             	sub    $0x4,%esp
  80309d:	68 40 44 80 00       	push   $0x804440
  8030a2:	68 98 01 00 00       	push   $0x198
  8030a7:	68 25 44 80 00       	push   $0x804425
  8030ac:	e8 fc 08 00 00       	call   8039ad <_panic>
  8030b1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8030b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ba:	89 10                	mov    %edx,(%eax)
  8030bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bf:	8b 00                	mov    (%eax),%eax
  8030c1:	85 c0                	test   %eax,%eax
  8030c3:	74 0d                	je     8030d2 <merging+0x3d9>
  8030c5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030cd:	89 50 04             	mov    %edx,0x4(%eax)
  8030d0:	eb 08                	jmp    8030da <merging+0x3e1>
  8030d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d5:	a3 30 50 80 00       	mov    %eax,0x805030
  8030da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030dd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8030f1:	40                   	inc    %eax
  8030f2:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8030f7:	83 ec 0c             	sub    $0xc,%esp
  8030fa:	ff 75 10             	pushl  0x10(%ebp)
  8030fd:	e8 d6 ed ff ff       	call   801ed8 <get_block_size>
  803102:	83 c4 10             	add    $0x10,%esp
  803105:	83 ec 04             	sub    $0x4,%esp
  803108:	6a 00                	push   $0x0
  80310a:	50                   	push   %eax
  80310b:	ff 75 10             	pushl  0x10(%ebp)
  80310e:	e8 16 f1 ff ff       	call   802229 <set_block_data>
  803113:	83 c4 10             	add    $0x10,%esp
	}
}
  803116:	90                   	nop
  803117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80311a:	c9                   	leave  
  80311b:	c3                   	ret    

0080311c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80311c:	55                   	push   %ebp
  80311d:	89 e5                	mov    %esp,%ebp
  80311f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803122:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803127:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  80312a:	a1 30 50 80 00       	mov    0x805030,%eax
  80312f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803132:	73 1b                	jae    80314f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803134:	a1 30 50 80 00       	mov    0x805030,%eax
  803139:	83 ec 04             	sub    $0x4,%esp
  80313c:	ff 75 08             	pushl  0x8(%ebp)
  80313f:	6a 00                	push   $0x0
  803141:	50                   	push   %eax
  803142:	e8 b2 fb ff ff       	call   802cf9 <merging>
  803147:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80314a:	e9 8b 00 00 00       	jmp    8031da <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80314f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803154:	3b 45 08             	cmp    0x8(%ebp),%eax
  803157:	76 18                	jbe    803171 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803159:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80315e:	83 ec 04             	sub    $0x4,%esp
  803161:	ff 75 08             	pushl  0x8(%ebp)
  803164:	50                   	push   %eax
  803165:	6a 00                	push   $0x0
  803167:	e8 8d fb ff ff       	call   802cf9 <merging>
  80316c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80316f:	eb 69                	jmp    8031da <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803171:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803176:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803179:	eb 39                	jmp    8031b4 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  80317b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803181:	73 29                	jae    8031ac <free_block+0x90>
  803183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803186:	8b 00                	mov    (%eax),%eax
  803188:	3b 45 08             	cmp    0x8(%ebp),%eax
  80318b:	76 1f                	jbe    8031ac <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	8b 00                	mov    (%eax),%eax
  803192:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803195:	83 ec 04             	sub    $0x4,%esp
  803198:	ff 75 08             	pushl  0x8(%ebp)
  80319b:	ff 75 f0             	pushl  -0x10(%ebp)
  80319e:	ff 75 f4             	pushl  -0xc(%ebp)
  8031a1:	e8 53 fb ff ff       	call   802cf9 <merging>
  8031a6:	83 c4 10             	add    $0x10,%esp
			break;
  8031a9:	90                   	nop
		}
	}
}
  8031aa:	eb 2e                	jmp    8031da <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031ac:	a1 34 50 80 00       	mov    0x805034,%eax
  8031b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b8:	74 07                	je     8031c1 <free_block+0xa5>
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	8b 00                	mov    (%eax),%eax
  8031bf:	eb 05                	jmp    8031c6 <free_block+0xaa>
  8031c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031c6:	a3 34 50 80 00       	mov    %eax,0x805034
  8031cb:	a1 34 50 80 00       	mov    0x805034,%eax
  8031d0:	85 c0                	test   %eax,%eax
  8031d2:	75 a7                	jne    80317b <free_block+0x5f>
  8031d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d8:	75 a1                	jne    80317b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031da:	90                   	nop
  8031db:	c9                   	leave  
  8031dc:	c3                   	ret    

008031dd <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8031dd:	55                   	push   %ebp
  8031de:	89 e5                	mov    %esp,%ebp
  8031e0:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8031e3:	ff 75 08             	pushl  0x8(%ebp)
  8031e6:	e8 ed ec ff ff       	call   801ed8 <get_block_size>
  8031eb:	83 c4 04             	add    $0x4,%esp
  8031ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8031f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8031f8:	eb 17                	jmp    803211 <copy_data+0x34>
  8031fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803200:	01 c2                	add    %eax,%edx
  803202:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	01 c8                	add    %ecx,%eax
  80320a:	8a 00                	mov    (%eax),%al
  80320c:	88 02                	mov    %al,(%edx)
  80320e:	ff 45 fc             	incl   -0x4(%ebp)
  803211:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803214:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803217:	72 e1                	jb     8031fa <copy_data+0x1d>
}
  803219:	90                   	nop
  80321a:	c9                   	leave  
  80321b:	c3                   	ret    

0080321c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80321c:	55                   	push   %ebp
  80321d:	89 e5                	mov    %esp,%ebp
  80321f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803222:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803226:	75 23                	jne    80324b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803228:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80322c:	74 13                	je     803241 <realloc_block_FF+0x25>
  80322e:	83 ec 0c             	sub    $0xc,%esp
  803231:	ff 75 0c             	pushl  0xc(%ebp)
  803234:	e8 1f f0 ff ff       	call   802258 <alloc_block_FF>
  803239:	83 c4 10             	add    $0x10,%esp
  80323c:	e9 f4 06 00 00       	jmp    803935 <realloc_block_FF+0x719>
		return NULL;
  803241:	b8 00 00 00 00       	mov    $0x0,%eax
  803246:	e9 ea 06 00 00       	jmp    803935 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80324b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80324f:	75 18                	jne    803269 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803251:	83 ec 0c             	sub    $0xc,%esp
  803254:	ff 75 08             	pushl  0x8(%ebp)
  803257:	e8 c0 fe ff ff       	call   80311c <free_block>
  80325c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80325f:	b8 00 00 00 00       	mov    $0x0,%eax
  803264:	e9 cc 06 00 00       	jmp    803935 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803269:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80326d:	77 07                	ja     803276 <realloc_block_FF+0x5a>
  80326f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803276:	8b 45 0c             	mov    0xc(%ebp),%eax
  803279:	83 e0 01             	and    $0x1,%eax
  80327c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80327f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803282:	83 c0 08             	add    $0x8,%eax
  803285:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803288:	83 ec 0c             	sub    $0xc,%esp
  80328b:	ff 75 08             	pushl  0x8(%ebp)
  80328e:	e8 45 ec ff ff       	call   801ed8 <get_block_size>
  803293:	83 c4 10             	add    $0x10,%esp
  803296:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803299:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80329c:	83 e8 08             	sub    $0x8,%eax
  80329f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8032a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a5:	83 e8 04             	sub    $0x4,%eax
  8032a8:	8b 00                	mov    (%eax),%eax
  8032aa:	83 e0 fe             	and    $0xfffffffe,%eax
  8032ad:	89 c2                	mov    %eax,%edx
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	01 d0                	add    %edx,%eax
  8032b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8032b7:	83 ec 0c             	sub    $0xc,%esp
  8032ba:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032bd:	e8 16 ec ff ff       	call   801ed8 <get_block_size>
  8032c2:	83 c4 10             	add    $0x10,%esp
  8032c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032cb:	83 e8 08             	sub    $0x8,%eax
  8032ce:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032d7:	75 08                	jne    8032e1 <realloc_block_FF+0xc5>
	{
		 return va;
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	e9 54 06 00 00       	jmp    803935 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8032e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032e7:	0f 83 e5 03 00 00    	jae    8036d2 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8032ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f0:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8032f6:	83 ec 0c             	sub    $0xc,%esp
  8032f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032fc:	e8 f0 eb ff ff       	call   801ef1 <is_free_block>
  803301:	83 c4 10             	add    $0x10,%esp
  803304:	84 c0                	test   %al,%al
  803306:	0f 84 3b 01 00 00    	je     803447 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80330c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80330f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803312:	01 d0                	add    %edx,%eax
  803314:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803317:	83 ec 04             	sub    $0x4,%esp
  80331a:	6a 01                	push   $0x1
  80331c:	ff 75 f0             	pushl  -0x10(%ebp)
  80331f:	ff 75 08             	pushl  0x8(%ebp)
  803322:	e8 02 ef ff ff       	call   802229 <set_block_data>
  803327:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80332a:	8b 45 08             	mov    0x8(%ebp),%eax
  80332d:	83 e8 04             	sub    $0x4,%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	83 e0 fe             	and    $0xfffffffe,%eax
  803335:	89 c2                	mov    %eax,%edx
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	01 d0                	add    %edx,%eax
  80333c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80333f:	83 ec 04             	sub    $0x4,%esp
  803342:	6a 00                	push   $0x0
  803344:	ff 75 cc             	pushl  -0x34(%ebp)
  803347:	ff 75 c8             	pushl  -0x38(%ebp)
  80334a:	e8 da ee ff ff       	call   802229 <set_block_data>
  80334f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803352:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803356:	74 06                	je     80335e <realloc_block_FF+0x142>
  803358:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80335c:	75 17                	jne    803375 <realloc_block_FF+0x159>
  80335e:	83 ec 04             	sub    $0x4,%esp
  803361:	68 98 44 80 00       	push   $0x804498
  803366:	68 f6 01 00 00       	push   $0x1f6
  80336b:	68 25 44 80 00       	push   $0x804425
  803370:	e8 38 06 00 00       	call   8039ad <_panic>
  803375:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803378:	8b 10                	mov    (%eax),%edx
  80337a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80337d:	89 10                	mov    %edx,(%eax)
  80337f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803382:	8b 00                	mov    (%eax),%eax
  803384:	85 c0                	test   %eax,%eax
  803386:	74 0b                	je     803393 <realloc_block_FF+0x177>
  803388:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338b:	8b 00                	mov    (%eax),%eax
  80338d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803390:	89 50 04             	mov    %edx,0x4(%eax)
  803393:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803396:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803399:	89 10                	mov    %edx,(%eax)
  80339b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80339e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033a1:	89 50 04             	mov    %edx,0x4(%eax)
  8033a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033a7:	8b 00                	mov    (%eax),%eax
  8033a9:	85 c0                	test   %eax,%eax
  8033ab:	75 08                	jne    8033b5 <realloc_block_FF+0x199>
  8033ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8033b5:	a1 38 50 80 00       	mov    0x805038,%eax
  8033ba:	40                   	inc    %eax
  8033bb:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8033c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033c4:	75 17                	jne    8033dd <realloc_block_FF+0x1c1>
  8033c6:	83 ec 04             	sub    $0x4,%esp
  8033c9:	68 07 44 80 00       	push   $0x804407
  8033ce:	68 f7 01 00 00       	push   $0x1f7
  8033d3:	68 25 44 80 00       	push   $0x804425
  8033d8:	e8 d0 05 00 00       	call   8039ad <_panic>
  8033dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e0:	8b 00                	mov    (%eax),%eax
  8033e2:	85 c0                	test   %eax,%eax
  8033e4:	74 10                	je     8033f6 <realloc_block_FF+0x1da>
  8033e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e9:	8b 00                	mov    (%eax),%eax
  8033eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ee:	8b 52 04             	mov    0x4(%edx),%edx
  8033f1:	89 50 04             	mov    %edx,0x4(%eax)
  8033f4:	eb 0b                	jmp    803401 <realloc_block_FF+0x1e5>
  8033f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f9:	8b 40 04             	mov    0x4(%eax),%eax
  8033fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803404:	8b 40 04             	mov    0x4(%eax),%eax
  803407:	85 c0                	test   %eax,%eax
  803409:	74 0f                	je     80341a <realloc_block_FF+0x1fe>
  80340b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340e:	8b 40 04             	mov    0x4(%eax),%eax
  803411:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803414:	8b 12                	mov    (%edx),%edx
  803416:	89 10                	mov    %edx,(%eax)
  803418:	eb 0a                	jmp    803424 <realloc_block_FF+0x208>
  80341a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341d:	8b 00                	mov    (%eax),%eax
  80341f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803427:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80342d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803430:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803437:	a1 38 50 80 00       	mov    0x805038,%eax
  80343c:	48                   	dec    %eax
  80343d:	a3 38 50 80 00       	mov    %eax,0x805038
  803442:	e9 83 02 00 00       	jmp    8036ca <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803447:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80344b:	0f 86 69 02 00 00    	jbe    8036ba <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803451:	83 ec 04             	sub    $0x4,%esp
  803454:	6a 01                	push   $0x1
  803456:	ff 75 f0             	pushl  -0x10(%ebp)
  803459:	ff 75 08             	pushl  0x8(%ebp)
  80345c:	e8 c8 ed ff ff       	call   802229 <set_block_data>
  803461:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803464:	8b 45 08             	mov    0x8(%ebp),%eax
  803467:	83 e8 04             	sub    $0x4,%eax
  80346a:	8b 00                	mov    (%eax),%eax
  80346c:	83 e0 fe             	and    $0xfffffffe,%eax
  80346f:	89 c2                	mov    %eax,%edx
  803471:	8b 45 08             	mov    0x8(%ebp),%eax
  803474:	01 d0                	add    %edx,%eax
  803476:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803479:	a1 38 50 80 00       	mov    0x805038,%eax
  80347e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803481:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803485:	75 68                	jne    8034ef <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803487:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80348b:	75 17                	jne    8034a4 <realloc_block_FF+0x288>
  80348d:	83 ec 04             	sub    $0x4,%esp
  803490:	68 40 44 80 00       	push   $0x804440
  803495:	68 06 02 00 00       	push   $0x206
  80349a:	68 25 44 80 00       	push   $0x804425
  80349f:	e8 09 05 00 00       	call   8039ad <_panic>
  8034a4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ad:	89 10                	mov    %edx,(%eax)
  8034af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b2:	8b 00                	mov    (%eax),%eax
  8034b4:	85 c0                	test   %eax,%eax
  8034b6:	74 0d                	je     8034c5 <realloc_block_FF+0x2a9>
  8034b8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034c0:	89 50 04             	mov    %edx,0x4(%eax)
  8034c3:	eb 08                	jmp    8034cd <realloc_block_FF+0x2b1>
  8034c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c8:	a3 30 50 80 00       	mov    %eax,0x805030
  8034cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034df:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e4:	40                   	inc    %eax
  8034e5:	a3 38 50 80 00       	mov    %eax,0x805038
  8034ea:	e9 b0 01 00 00       	jmp    80369f <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8034ef:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034f4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034f7:	76 68                	jbe    803561 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034f9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034fd:	75 17                	jne    803516 <realloc_block_FF+0x2fa>
  8034ff:	83 ec 04             	sub    $0x4,%esp
  803502:	68 40 44 80 00       	push   $0x804440
  803507:	68 0b 02 00 00       	push   $0x20b
  80350c:	68 25 44 80 00       	push   $0x804425
  803511:	e8 97 04 00 00       	call   8039ad <_panic>
  803516:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80351c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351f:	89 10                	mov    %edx,(%eax)
  803521:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803524:	8b 00                	mov    (%eax),%eax
  803526:	85 c0                	test   %eax,%eax
  803528:	74 0d                	je     803537 <realloc_block_FF+0x31b>
  80352a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80352f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803532:	89 50 04             	mov    %edx,0x4(%eax)
  803535:	eb 08                	jmp    80353f <realloc_block_FF+0x323>
  803537:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353a:	a3 30 50 80 00       	mov    %eax,0x805030
  80353f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803542:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803547:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803551:	a1 38 50 80 00       	mov    0x805038,%eax
  803556:	40                   	inc    %eax
  803557:	a3 38 50 80 00       	mov    %eax,0x805038
  80355c:	e9 3e 01 00 00       	jmp    80369f <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803561:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803566:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803569:	73 68                	jae    8035d3 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80356b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80356f:	75 17                	jne    803588 <realloc_block_FF+0x36c>
  803571:	83 ec 04             	sub    $0x4,%esp
  803574:	68 74 44 80 00       	push   $0x804474
  803579:	68 10 02 00 00       	push   $0x210
  80357e:	68 25 44 80 00       	push   $0x804425
  803583:	e8 25 04 00 00       	call   8039ad <_panic>
  803588:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80358e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803591:	89 50 04             	mov    %edx,0x4(%eax)
  803594:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803597:	8b 40 04             	mov    0x4(%eax),%eax
  80359a:	85 c0                	test   %eax,%eax
  80359c:	74 0c                	je     8035aa <realloc_block_FF+0x38e>
  80359e:	a1 30 50 80 00       	mov    0x805030,%eax
  8035a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8035a6:	89 10                	mov    %edx,(%eax)
  8035a8:	eb 08                	jmp    8035b2 <realloc_block_FF+0x396>
  8035aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8035ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8035c8:	40                   	inc    %eax
  8035c9:	a3 38 50 80 00       	mov    %eax,0x805038
  8035ce:	e9 cc 00 00 00       	jmp    80369f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8035da:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035e2:	e9 8a 00 00 00       	jmp    803671 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ea:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ed:	73 7a                	jae    803669 <realloc_block_FF+0x44d>
  8035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f2:	8b 00                	mov    (%eax),%eax
  8035f4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035f7:	73 70                	jae    803669 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8035f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035fd:	74 06                	je     803605 <realloc_block_FF+0x3e9>
  8035ff:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803603:	75 17                	jne    80361c <realloc_block_FF+0x400>
  803605:	83 ec 04             	sub    $0x4,%esp
  803608:	68 98 44 80 00       	push   $0x804498
  80360d:	68 1a 02 00 00       	push   $0x21a
  803612:	68 25 44 80 00       	push   $0x804425
  803617:	e8 91 03 00 00       	call   8039ad <_panic>
  80361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361f:	8b 10                	mov    (%eax),%edx
  803621:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803624:	89 10                	mov    %edx,(%eax)
  803626:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803629:	8b 00                	mov    (%eax),%eax
  80362b:	85 c0                	test   %eax,%eax
  80362d:	74 0b                	je     80363a <realloc_block_FF+0x41e>
  80362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803632:	8b 00                	mov    (%eax),%eax
  803634:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803637:	89 50 04             	mov    %edx,0x4(%eax)
  80363a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803640:	89 10                	mov    %edx,(%eax)
  803642:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803648:	89 50 04             	mov    %edx,0x4(%eax)
  80364b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80364e:	8b 00                	mov    (%eax),%eax
  803650:	85 c0                	test   %eax,%eax
  803652:	75 08                	jne    80365c <realloc_block_FF+0x440>
  803654:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803657:	a3 30 50 80 00       	mov    %eax,0x805030
  80365c:	a1 38 50 80 00       	mov    0x805038,%eax
  803661:	40                   	inc    %eax
  803662:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803667:	eb 36                	jmp    80369f <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803669:	a1 34 50 80 00       	mov    0x805034,%eax
  80366e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803675:	74 07                	je     80367e <realloc_block_FF+0x462>
  803677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367a:	8b 00                	mov    (%eax),%eax
  80367c:	eb 05                	jmp    803683 <realloc_block_FF+0x467>
  80367e:	b8 00 00 00 00       	mov    $0x0,%eax
  803683:	a3 34 50 80 00       	mov    %eax,0x805034
  803688:	a1 34 50 80 00       	mov    0x805034,%eax
  80368d:	85 c0                	test   %eax,%eax
  80368f:	0f 85 52 ff ff ff    	jne    8035e7 <realloc_block_FF+0x3cb>
  803695:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803699:	0f 85 48 ff ff ff    	jne    8035e7 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80369f:	83 ec 04             	sub    $0x4,%esp
  8036a2:	6a 00                	push   $0x0
  8036a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8036a7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8036aa:	e8 7a eb ff ff       	call   802229 <set_block_data>
  8036af:	83 c4 10             	add    $0x10,%esp
				return va;
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	e9 7b 02 00 00       	jmp    803935 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8036ba:	83 ec 0c             	sub    $0xc,%esp
  8036bd:	68 15 45 80 00       	push   $0x804515
  8036c2:	e8 01 cd ff ff       	call   8003c8 <cprintf>
  8036c7:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8036ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cd:	e9 63 02 00 00       	jmp    803935 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8036d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036d8:	0f 86 4d 02 00 00    	jbe    80392b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8036de:	83 ec 0c             	sub    $0xc,%esp
  8036e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036e4:	e8 08 e8 ff ff       	call   801ef1 <is_free_block>
  8036e9:	83 c4 10             	add    $0x10,%esp
  8036ec:	84 c0                	test   %al,%al
  8036ee:	0f 84 37 02 00 00    	je     80392b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8036f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8036fa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8036fd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803700:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803703:	76 38                	jbe    80373d <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803705:	83 ec 0c             	sub    $0xc,%esp
  803708:	ff 75 08             	pushl  0x8(%ebp)
  80370b:	e8 0c fa ff ff       	call   80311c <free_block>
  803710:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803713:	83 ec 0c             	sub    $0xc,%esp
  803716:	ff 75 0c             	pushl  0xc(%ebp)
  803719:	e8 3a eb ff ff       	call   802258 <alloc_block_FF>
  80371e:	83 c4 10             	add    $0x10,%esp
  803721:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803724:	83 ec 08             	sub    $0x8,%esp
  803727:	ff 75 c0             	pushl  -0x40(%ebp)
  80372a:	ff 75 08             	pushl  0x8(%ebp)
  80372d:	e8 ab fa ff ff       	call   8031dd <copy_data>
  803732:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803735:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803738:	e9 f8 01 00 00       	jmp    803935 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80373d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803740:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803743:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803746:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80374a:	0f 87 a0 00 00 00    	ja     8037f0 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803750:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803754:	75 17                	jne    80376d <realloc_block_FF+0x551>
  803756:	83 ec 04             	sub    $0x4,%esp
  803759:	68 07 44 80 00       	push   $0x804407
  80375e:	68 38 02 00 00       	push   $0x238
  803763:	68 25 44 80 00       	push   $0x804425
  803768:	e8 40 02 00 00       	call   8039ad <_panic>
  80376d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803770:	8b 00                	mov    (%eax),%eax
  803772:	85 c0                	test   %eax,%eax
  803774:	74 10                	je     803786 <realloc_block_FF+0x56a>
  803776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803779:	8b 00                	mov    (%eax),%eax
  80377b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80377e:	8b 52 04             	mov    0x4(%edx),%edx
  803781:	89 50 04             	mov    %edx,0x4(%eax)
  803784:	eb 0b                	jmp    803791 <realloc_block_FF+0x575>
  803786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803789:	8b 40 04             	mov    0x4(%eax),%eax
  80378c:	a3 30 50 80 00       	mov    %eax,0x805030
  803791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803794:	8b 40 04             	mov    0x4(%eax),%eax
  803797:	85 c0                	test   %eax,%eax
  803799:	74 0f                	je     8037aa <realloc_block_FF+0x58e>
  80379b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379e:	8b 40 04             	mov    0x4(%eax),%eax
  8037a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a4:	8b 12                	mov    (%edx),%edx
  8037a6:	89 10                	mov    %edx,(%eax)
  8037a8:	eb 0a                	jmp    8037b4 <realloc_block_FF+0x598>
  8037aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ad:	8b 00                	mov    (%eax),%eax
  8037af:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8037b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c7:	a1 38 50 80 00       	mov    0x805038,%eax
  8037cc:	48                   	dec    %eax
  8037cd:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d8:	01 d0                	add    %edx,%eax
  8037da:	83 ec 04             	sub    $0x4,%esp
  8037dd:	6a 01                	push   $0x1
  8037df:	50                   	push   %eax
  8037e0:	ff 75 08             	pushl  0x8(%ebp)
  8037e3:	e8 41 ea ff ff       	call   802229 <set_block_data>
  8037e8:	83 c4 10             	add    $0x10,%esp
  8037eb:	e9 36 01 00 00       	jmp    803926 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8037f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037f6:	01 d0                	add    %edx,%eax
  8037f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8037fb:	83 ec 04             	sub    $0x4,%esp
  8037fe:	6a 01                	push   $0x1
  803800:	ff 75 f0             	pushl  -0x10(%ebp)
  803803:	ff 75 08             	pushl  0x8(%ebp)
  803806:	e8 1e ea ff ff       	call   802229 <set_block_data>
  80380b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80380e:	8b 45 08             	mov    0x8(%ebp),%eax
  803811:	83 e8 04             	sub    $0x4,%eax
  803814:	8b 00                	mov    (%eax),%eax
  803816:	83 e0 fe             	and    $0xfffffffe,%eax
  803819:	89 c2                	mov    %eax,%edx
  80381b:	8b 45 08             	mov    0x8(%ebp),%eax
  80381e:	01 d0                	add    %edx,%eax
  803820:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803823:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803827:	74 06                	je     80382f <realloc_block_FF+0x613>
  803829:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80382d:	75 17                	jne    803846 <realloc_block_FF+0x62a>
  80382f:	83 ec 04             	sub    $0x4,%esp
  803832:	68 98 44 80 00       	push   $0x804498
  803837:	68 44 02 00 00       	push   $0x244
  80383c:	68 25 44 80 00       	push   $0x804425
  803841:	e8 67 01 00 00       	call   8039ad <_panic>
  803846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803849:	8b 10                	mov    (%eax),%edx
  80384b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80384e:	89 10                	mov    %edx,(%eax)
  803850:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803853:	8b 00                	mov    (%eax),%eax
  803855:	85 c0                	test   %eax,%eax
  803857:	74 0b                	je     803864 <realloc_block_FF+0x648>
  803859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385c:	8b 00                	mov    (%eax),%eax
  80385e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803861:	89 50 04             	mov    %edx,0x4(%eax)
  803864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803867:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80386a:	89 10                	mov    %edx,(%eax)
  80386c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80386f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803872:	89 50 04             	mov    %edx,0x4(%eax)
  803875:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803878:	8b 00                	mov    (%eax),%eax
  80387a:	85 c0                	test   %eax,%eax
  80387c:	75 08                	jne    803886 <realloc_block_FF+0x66a>
  80387e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803881:	a3 30 50 80 00       	mov    %eax,0x805030
  803886:	a1 38 50 80 00       	mov    0x805038,%eax
  80388b:	40                   	inc    %eax
  80388c:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803891:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803895:	75 17                	jne    8038ae <realloc_block_FF+0x692>
  803897:	83 ec 04             	sub    $0x4,%esp
  80389a:	68 07 44 80 00       	push   $0x804407
  80389f:	68 45 02 00 00       	push   $0x245
  8038a4:	68 25 44 80 00       	push   $0x804425
  8038a9:	e8 ff 00 00 00       	call   8039ad <_panic>
  8038ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b1:	8b 00                	mov    (%eax),%eax
  8038b3:	85 c0                	test   %eax,%eax
  8038b5:	74 10                	je     8038c7 <realloc_block_FF+0x6ab>
  8038b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ba:	8b 00                	mov    (%eax),%eax
  8038bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038bf:	8b 52 04             	mov    0x4(%edx),%edx
  8038c2:	89 50 04             	mov    %edx,0x4(%eax)
  8038c5:	eb 0b                	jmp    8038d2 <realloc_block_FF+0x6b6>
  8038c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ca:	8b 40 04             	mov    0x4(%eax),%eax
  8038cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8038d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d5:	8b 40 04             	mov    0x4(%eax),%eax
  8038d8:	85 c0                	test   %eax,%eax
  8038da:	74 0f                	je     8038eb <realloc_block_FF+0x6cf>
  8038dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038df:	8b 40 04             	mov    0x4(%eax),%eax
  8038e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038e5:	8b 12                	mov    (%edx),%edx
  8038e7:	89 10                	mov    %edx,(%eax)
  8038e9:	eb 0a                	jmp    8038f5 <realloc_block_FF+0x6d9>
  8038eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ee:	8b 00                	mov    (%eax),%eax
  8038f0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803901:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803908:	a1 38 50 80 00       	mov    0x805038,%eax
  80390d:	48                   	dec    %eax
  80390e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803913:	83 ec 04             	sub    $0x4,%esp
  803916:	6a 00                	push   $0x0
  803918:	ff 75 bc             	pushl  -0x44(%ebp)
  80391b:	ff 75 b8             	pushl  -0x48(%ebp)
  80391e:	e8 06 e9 ff ff       	call   802229 <set_block_data>
  803923:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803926:	8b 45 08             	mov    0x8(%ebp),%eax
  803929:	eb 0a                	jmp    803935 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80392b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803932:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803935:	c9                   	leave  
  803936:	c3                   	ret    

00803937 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803937:	55                   	push   %ebp
  803938:	89 e5                	mov    %esp,%ebp
  80393a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80393d:	83 ec 04             	sub    $0x4,%esp
  803940:	68 1c 45 80 00       	push   $0x80451c
  803945:	68 58 02 00 00       	push   $0x258
  80394a:	68 25 44 80 00       	push   $0x804425
  80394f:	e8 59 00 00 00       	call   8039ad <_panic>

00803954 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803954:	55                   	push   %ebp
  803955:	89 e5                	mov    %esp,%ebp
  803957:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80395a:	83 ec 04             	sub    $0x4,%esp
  80395d:	68 44 45 80 00       	push   $0x804544
  803962:	68 61 02 00 00       	push   $0x261
  803967:	68 25 44 80 00       	push   $0x804425
  80396c:	e8 3c 00 00 00       	call   8039ad <_panic>

00803971 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  803971:	55                   	push   %ebp
  803972:	89 e5                	mov    %esp,%ebp
  803974:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  803977:	8b 45 08             	mov    0x8(%ebp),%eax
  80397a:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80397d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  803981:	83 ec 0c             	sub    $0xc,%esp
  803984:	50                   	push   %eax
  803985:	e8 dd e0 ff ff       	call   801a67 <sys_cputc>
  80398a:	83 c4 10             	add    $0x10,%esp
}
  80398d:	90                   	nop
  80398e:	c9                   	leave  
  80398f:	c3                   	ret    

00803990 <getchar>:


int
getchar(void)
{
  803990:	55                   	push   %ebp
  803991:	89 e5                	mov    %esp,%ebp
  803993:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803996:	e8 68 df ff ff       	call   801903 <sys_cgetc>
  80399b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80399e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8039a1:	c9                   	leave  
  8039a2:	c3                   	ret    

008039a3 <iscons>:

int iscons(int fdnum)
{
  8039a3:	55                   	push   %ebp
  8039a4:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8039a6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8039ab:	5d                   	pop    %ebp
  8039ac:	c3                   	ret    

008039ad <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8039ad:	55                   	push   %ebp
  8039ae:	89 e5                	mov    %esp,%ebp
  8039b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8039b3:	8d 45 10             	lea    0x10(%ebp),%eax
  8039b6:	83 c0 04             	add    $0x4,%eax
  8039b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8039bc:	a1 60 50 98 00       	mov    0x985060,%eax
  8039c1:	85 c0                	test   %eax,%eax
  8039c3:	74 16                	je     8039db <_panic+0x2e>
		cprintf("%s: ", argv0);
  8039c5:	a1 60 50 98 00       	mov    0x985060,%eax
  8039ca:	83 ec 08             	sub    $0x8,%esp
  8039cd:	50                   	push   %eax
  8039ce:	68 6c 45 80 00       	push   $0x80456c
  8039d3:	e8 f0 c9 ff ff       	call   8003c8 <cprintf>
  8039d8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8039db:	a1 00 50 80 00       	mov    0x805000,%eax
  8039e0:	ff 75 0c             	pushl  0xc(%ebp)
  8039e3:	ff 75 08             	pushl  0x8(%ebp)
  8039e6:	50                   	push   %eax
  8039e7:	68 71 45 80 00       	push   $0x804571
  8039ec:	e8 d7 c9 ff ff       	call   8003c8 <cprintf>
  8039f1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8039f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8039f7:	83 ec 08             	sub    $0x8,%esp
  8039fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8039fd:	50                   	push   %eax
  8039fe:	e8 5a c9 ff ff       	call   80035d <vcprintf>
  803a03:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a06:	83 ec 08             	sub    $0x8,%esp
  803a09:	6a 00                	push   $0x0
  803a0b:	68 8d 45 80 00       	push   $0x80458d
  803a10:	e8 48 c9 ff ff       	call   80035d <vcprintf>
  803a15:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a18:	e8 c9 c8 ff ff       	call   8002e6 <exit>

	// should not return here
	while (1) ;
  803a1d:	eb fe                	jmp    803a1d <_panic+0x70>

00803a1f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a1f:	55                   	push   %ebp
  803a20:	89 e5                	mov    %esp,%ebp
  803a22:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a25:	a1 20 50 80 00       	mov    0x805020,%eax
  803a2a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a33:	39 c2                	cmp    %eax,%edx
  803a35:	74 14                	je     803a4b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a37:	83 ec 04             	sub    $0x4,%esp
  803a3a:	68 90 45 80 00       	push   $0x804590
  803a3f:	6a 26                	push   $0x26
  803a41:	68 dc 45 80 00       	push   $0x8045dc
  803a46:	e8 62 ff ff ff       	call   8039ad <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803a52:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a59:	e9 c5 00 00 00       	jmp    803b23 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a68:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6b:	01 d0                	add    %edx,%eax
  803a6d:	8b 00                	mov    (%eax),%eax
  803a6f:	85 c0                	test   %eax,%eax
  803a71:	75 08                	jne    803a7b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a73:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a76:	e9 a5 00 00 00       	jmp    803b20 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a7b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a82:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a89:	eb 69                	jmp    803af4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a8b:	a1 20 50 80 00       	mov    0x805020,%eax
  803a90:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a96:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a99:	89 d0                	mov    %edx,%eax
  803a9b:	01 c0                	add    %eax,%eax
  803a9d:	01 d0                	add    %edx,%eax
  803a9f:	c1 e0 03             	shl    $0x3,%eax
  803aa2:	01 c8                	add    %ecx,%eax
  803aa4:	8a 40 04             	mov    0x4(%eax),%al
  803aa7:	84 c0                	test   %al,%al
  803aa9:	75 46                	jne    803af1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803aab:	a1 20 50 80 00       	mov    0x805020,%eax
  803ab0:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ab6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ab9:	89 d0                	mov    %edx,%eax
  803abb:	01 c0                	add    %eax,%eax
  803abd:	01 d0                	add    %edx,%eax
  803abf:	c1 e0 03             	shl    $0x3,%eax
  803ac2:	01 c8                	add    %ecx,%eax
  803ac4:	8b 00                	mov    (%eax),%eax
  803ac6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803ac9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803acc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803ad1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ad6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803add:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae0:	01 c8                	add    %ecx,%eax
  803ae2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803ae4:	39 c2                	cmp    %eax,%edx
  803ae6:	75 09                	jne    803af1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803ae8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803aef:	eb 15                	jmp    803b06 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803af1:	ff 45 e8             	incl   -0x18(%ebp)
  803af4:	a1 20 50 80 00       	mov    0x805020,%eax
  803af9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803aff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b02:	39 c2                	cmp    %eax,%edx
  803b04:	77 85                	ja     803a8b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b06:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b0a:	75 14                	jne    803b20 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b0c:	83 ec 04             	sub    $0x4,%esp
  803b0f:	68 e8 45 80 00       	push   $0x8045e8
  803b14:	6a 3a                	push   $0x3a
  803b16:	68 dc 45 80 00       	push   $0x8045dc
  803b1b:	e8 8d fe ff ff       	call   8039ad <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b20:	ff 45 f0             	incl   -0x10(%ebp)
  803b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b26:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b29:	0f 8c 2f ff ff ff    	jl     803a5e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b36:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b3d:	eb 26                	jmp    803b65 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b3f:	a1 20 50 80 00       	mov    0x805020,%eax
  803b44:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b4d:	89 d0                	mov    %edx,%eax
  803b4f:	01 c0                	add    %eax,%eax
  803b51:	01 d0                	add    %edx,%eax
  803b53:	c1 e0 03             	shl    $0x3,%eax
  803b56:	01 c8                	add    %ecx,%eax
  803b58:	8a 40 04             	mov    0x4(%eax),%al
  803b5b:	3c 01                	cmp    $0x1,%al
  803b5d:	75 03                	jne    803b62 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b5f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b62:	ff 45 e0             	incl   -0x20(%ebp)
  803b65:	a1 20 50 80 00       	mov    0x805020,%eax
  803b6a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b73:	39 c2                	cmp    %eax,%edx
  803b75:	77 c8                	ja     803b3f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b7d:	74 14                	je     803b93 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b7f:	83 ec 04             	sub    $0x4,%esp
  803b82:	68 3c 46 80 00       	push   $0x80463c
  803b87:	6a 44                	push   $0x44
  803b89:	68 dc 45 80 00       	push   $0x8045dc
  803b8e:	e8 1a fe ff ff       	call   8039ad <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b93:	90                   	nop
  803b94:	c9                   	leave  
  803b95:	c3                   	ret    
  803b96:	66 90                	xchg   %ax,%ax

00803b98 <__udivdi3>:
  803b98:	55                   	push   %ebp
  803b99:	57                   	push   %edi
  803b9a:	56                   	push   %esi
  803b9b:	53                   	push   %ebx
  803b9c:	83 ec 1c             	sub    $0x1c,%esp
  803b9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ba3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ba7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803baf:	89 ca                	mov    %ecx,%edx
  803bb1:	89 f8                	mov    %edi,%eax
  803bb3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bb7:	85 f6                	test   %esi,%esi
  803bb9:	75 2d                	jne    803be8 <__udivdi3+0x50>
  803bbb:	39 cf                	cmp    %ecx,%edi
  803bbd:	77 65                	ja     803c24 <__udivdi3+0x8c>
  803bbf:	89 fd                	mov    %edi,%ebp
  803bc1:	85 ff                	test   %edi,%edi
  803bc3:	75 0b                	jne    803bd0 <__udivdi3+0x38>
  803bc5:	b8 01 00 00 00       	mov    $0x1,%eax
  803bca:	31 d2                	xor    %edx,%edx
  803bcc:	f7 f7                	div    %edi
  803bce:	89 c5                	mov    %eax,%ebp
  803bd0:	31 d2                	xor    %edx,%edx
  803bd2:	89 c8                	mov    %ecx,%eax
  803bd4:	f7 f5                	div    %ebp
  803bd6:	89 c1                	mov    %eax,%ecx
  803bd8:	89 d8                	mov    %ebx,%eax
  803bda:	f7 f5                	div    %ebp
  803bdc:	89 cf                	mov    %ecx,%edi
  803bde:	89 fa                	mov    %edi,%edx
  803be0:	83 c4 1c             	add    $0x1c,%esp
  803be3:	5b                   	pop    %ebx
  803be4:	5e                   	pop    %esi
  803be5:	5f                   	pop    %edi
  803be6:	5d                   	pop    %ebp
  803be7:	c3                   	ret    
  803be8:	39 ce                	cmp    %ecx,%esi
  803bea:	77 28                	ja     803c14 <__udivdi3+0x7c>
  803bec:	0f bd fe             	bsr    %esi,%edi
  803bef:	83 f7 1f             	xor    $0x1f,%edi
  803bf2:	75 40                	jne    803c34 <__udivdi3+0x9c>
  803bf4:	39 ce                	cmp    %ecx,%esi
  803bf6:	72 0a                	jb     803c02 <__udivdi3+0x6a>
  803bf8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bfc:	0f 87 9e 00 00 00    	ja     803ca0 <__udivdi3+0x108>
  803c02:	b8 01 00 00 00       	mov    $0x1,%eax
  803c07:	89 fa                	mov    %edi,%edx
  803c09:	83 c4 1c             	add    $0x1c,%esp
  803c0c:	5b                   	pop    %ebx
  803c0d:	5e                   	pop    %esi
  803c0e:	5f                   	pop    %edi
  803c0f:	5d                   	pop    %ebp
  803c10:	c3                   	ret    
  803c11:	8d 76 00             	lea    0x0(%esi),%esi
  803c14:	31 ff                	xor    %edi,%edi
  803c16:	31 c0                	xor    %eax,%eax
  803c18:	89 fa                	mov    %edi,%edx
  803c1a:	83 c4 1c             	add    $0x1c,%esp
  803c1d:	5b                   	pop    %ebx
  803c1e:	5e                   	pop    %esi
  803c1f:	5f                   	pop    %edi
  803c20:	5d                   	pop    %ebp
  803c21:	c3                   	ret    
  803c22:	66 90                	xchg   %ax,%ax
  803c24:	89 d8                	mov    %ebx,%eax
  803c26:	f7 f7                	div    %edi
  803c28:	31 ff                	xor    %edi,%edi
  803c2a:	89 fa                	mov    %edi,%edx
  803c2c:	83 c4 1c             	add    $0x1c,%esp
  803c2f:	5b                   	pop    %ebx
  803c30:	5e                   	pop    %esi
  803c31:	5f                   	pop    %edi
  803c32:	5d                   	pop    %ebp
  803c33:	c3                   	ret    
  803c34:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c39:	89 eb                	mov    %ebp,%ebx
  803c3b:	29 fb                	sub    %edi,%ebx
  803c3d:	89 f9                	mov    %edi,%ecx
  803c3f:	d3 e6                	shl    %cl,%esi
  803c41:	89 c5                	mov    %eax,%ebp
  803c43:	88 d9                	mov    %bl,%cl
  803c45:	d3 ed                	shr    %cl,%ebp
  803c47:	89 e9                	mov    %ebp,%ecx
  803c49:	09 f1                	or     %esi,%ecx
  803c4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c4f:	89 f9                	mov    %edi,%ecx
  803c51:	d3 e0                	shl    %cl,%eax
  803c53:	89 c5                	mov    %eax,%ebp
  803c55:	89 d6                	mov    %edx,%esi
  803c57:	88 d9                	mov    %bl,%cl
  803c59:	d3 ee                	shr    %cl,%esi
  803c5b:	89 f9                	mov    %edi,%ecx
  803c5d:	d3 e2                	shl    %cl,%edx
  803c5f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c63:	88 d9                	mov    %bl,%cl
  803c65:	d3 e8                	shr    %cl,%eax
  803c67:	09 c2                	or     %eax,%edx
  803c69:	89 d0                	mov    %edx,%eax
  803c6b:	89 f2                	mov    %esi,%edx
  803c6d:	f7 74 24 0c          	divl   0xc(%esp)
  803c71:	89 d6                	mov    %edx,%esi
  803c73:	89 c3                	mov    %eax,%ebx
  803c75:	f7 e5                	mul    %ebp
  803c77:	39 d6                	cmp    %edx,%esi
  803c79:	72 19                	jb     803c94 <__udivdi3+0xfc>
  803c7b:	74 0b                	je     803c88 <__udivdi3+0xf0>
  803c7d:	89 d8                	mov    %ebx,%eax
  803c7f:	31 ff                	xor    %edi,%edi
  803c81:	e9 58 ff ff ff       	jmp    803bde <__udivdi3+0x46>
  803c86:	66 90                	xchg   %ax,%ax
  803c88:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c8c:	89 f9                	mov    %edi,%ecx
  803c8e:	d3 e2                	shl    %cl,%edx
  803c90:	39 c2                	cmp    %eax,%edx
  803c92:	73 e9                	jae    803c7d <__udivdi3+0xe5>
  803c94:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c97:	31 ff                	xor    %edi,%edi
  803c99:	e9 40 ff ff ff       	jmp    803bde <__udivdi3+0x46>
  803c9e:	66 90                	xchg   %ax,%ax
  803ca0:	31 c0                	xor    %eax,%eax
  803ca2:	e9 37 ff ff ff       	jmp    803bde <__udivdi3+0x46>
  803ca7:	90                   	nop

00803ca8 <__umoddi3>:
  803ca8:	55                   	push   %ebp
  803ca9:	57                   	push   %edi
  803caa:	56                   	push   %esi
  803cab:	53                   	push   %ebx
  803cac:	83 ec 1c             	sub    $0x1c,%esp
  803caf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cb3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cb7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cbb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803cbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803cc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cc7:	89 f3                	mov    %esi,%ebx
  803cc9:	89 fa                	mov    %edi,%edx
  803ccb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ccf:	89 34 24             	mov    %esi,(%esp)
  803cd2:	85 c0                	test   %eax,%eax
  803cd4:	75 1a                	jne    803cf0 <__umoddi3+0x48>
  803cd6:	39 f7                	cmp    %esi,%edi
  803cd8:	0f 86 a2 00 00 00    	jbe    803d80 <__umoddi3+0xd8>
  803cde:	89 c8                	mov    %ecx,%eax
  803ce0:	89 f2                	mov    %esi,%edx
  803ce2:	f7 f7                	div    %edi
  803ce4:	89 d0                	mov    %edx,%eax
  803ce6:	31 d2                	xor    %edx,%edx
  803ce8:	83 c4 1c             	add    $0x1c,%esp
  803ceb:	5b                   	pop    %ebx
  803cec:	5e                   	pop    %esi
  803ced:	5f                   	pop    %edi
  803cee:	5d                   	pop    %ebp
  803cef:	c3                   	ret    
  803cf0:	39 f0                	cmp    %esi,%eax
  803cf2:	0f 87 ac 00 00 00    	ja     803da4 <__umoddi3+0xfc>
  803cf8:	0f bd e8             	bsr    %eax,%ebp
  803cfb:	83 f5 1f             	xor    $0x1f,%ebp
  803cfe:	0f 84 ac 00 00 00    	je     803db0 <__umoddi3+0x108>
  803d04:	bf 20 00 00 00       	mov    $0x20,%edi
  803d09:	29 ef                	sub    %ebp,%edi
  803d0b:	89 fe                	mov    %edi,%esi
  803d0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d11:	89 e9                	mov    %ebp,%ecx
  803d13:	d3 e0                	shl    %cl,%eax
  803d15:	89 d7                	mov    %edx,%edi
  803d17:	89 f1                	mov    %esi,%ecx
  803d19:	d3 ef                	shr    %cl,%edi
  803d1b:	09 c7                	or     %eax,%edi
  803d1d:	89 e9                	mov    %ebp,%ecx
  803d1f:	d3 e2                	shl    %cl,%edx
  803d21:	89 14 24             	mov    %edx,(%esp)
  803d24:	89 d8                	mov    %ebx,%eax
  803d26:	d3 e0                	shl    %cl,%eax
  803d28:	89 c2                	mov    %eax,%edx
  803d2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d2e:	d3 e0                	shl    %cl,%eax
  803d30:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d34:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d38:	89 f1                	mov    %esi,%ecx
  803d3a:	d3 e8                	shr    %cl,%eax
  803d3c:	09 d0                	or     %edx,%eax
  803d3e:	d3 eb                	shr    %cl,%ebx
  803d40:	89 da                	mov    %ebx,%edx
  803d42:	f7 f7                	div    %edi
  803d44:	89 d3                	mov    %edx,%ebx
  803d46:	f7 24 24             	mull   (%esp)
  803d49:	89 c6                	mov    %eax,%esi
  803d4b:	89 d1                	mov    %edx,%ecx
  803d4d:	39 d3                	cmp    %edx,%ebx
  803d4f:	0f 82 87 00 00 00    	jb     803ddc <__umoddi3+0x134>
  803d55:	0f 84 91 00 00 00    	je     803dec <__umoddi3+0x144>
  803d5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d5f:	29 f2                	sub    %esi,%edx
  803d61:	19 cb                	sbb    %ecx,%ebx
  803d63:	89 d8                	mov    %ebx,%eax
  803d65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d69:	d3 e0                	shl    %cl,%eax
  803d6b:	89 e9                	mov    %ebp,%ecx
  803d6d:	d3 ea                	shr    %cl,%edx
  803d6f:	09 d0                	or     %edx,%eax
  803d71:	89 e9                	mov    %ebp,%ecx
  803d73:	d3 eb                	shr    %cl,%ebx
  803d75:	89 da                	mov    %ebx,%edx
  803d77:	83 c4 1c             	add    $0x1c,%esp
  803d7a:	5b                   	pop    %ebx
  803d7b:	5e                   	pop    %esi
  803d7c:	5f                   	pop    %edi
  803d7d:	5d                   	pop    %ebp
  803d7e:	c3                   	ret    
  803d7f:	90                   	nop
  803d80:	89 fd                	mov    %edi,%ebp
  803d82:	85 ff                	test   %edi,%edi
  803d84:	75 0b                	jne    803d91 <__umoddi3+0xe9>
  803d86:	b8 01 00 00 00       	mov    $0x1,%eax
  803d8b:	31 d2                	xor    %edx,%edx
  803d8d:	f7 f7                	div    %edi
  803d8f:	89 c5                	mov    %eax,%ebp
  803d91:	89 f0                	mov    %esi,%eax
  803d93:	31 d2                	xor    %edx,%edx
  803d95:	f7 f5                	div    %ebp
  803d97:	89 c8                	mov    %ecx,%eax
  803d99:	f7 f5                	div    %ebp
  803d9b:	89 d0                	mov    %edx,%eax
  803d9d:	e9 44 ff ff ff       	jmp    803ce6 <__umoddi3+0x3e>
  803da2:	66 90                	xchg   %ax,%ax
  803da4:	89 c8                	mov    %ecx,%eax
  803da6:	89 f2                	mov    %esi,%edx
  803da8:	83 c4 1c             	add    $0x1c,%esp
  803dab:	5b                   	pop    %ebx
  803dac:	5e                   	pop    %esi
  803dad:	5f                   	pop    %edi
  803dae:	5d                   	pop    %ebp
  803daf:	c3                   	ret    
  803db0:	3b 04 24             	cmp    (%esp),%eax
  803db3:	72 06                	jb     803dbb <__umoddi3+0x113>
  803db5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803db9:	77 0f                	ja     803dca <__umoddi3+0x122>
  803dbb:	89 f2                	mov    %esi,%edx
  803dbd:	29 f9                	sub    %edi,%ecx
  803dbf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dc3:	89 14 24             	mov    %edx,(%esp)
  803dc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dca:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dce:	8b 14 24             	mov    (%esp),%edx
  803dd1:	83 c4 1c             	add    $0x1c,%esp
  803dd4:	5b                   	pop    %ebx
  803dd5:	5e                   	pop    %esi
  803dd6:	5f                   	pop    %edi
  803dd7:	5d                   	pop    %ebp
  803dd8:	c3                   	ret    
  803dd9:	8d 76 00             	lea    0x0(%esi),%esi
  803ddc:	2b 04 24             	sub    (%esp),%eax
  803ddf:	19 fa                	sbb    %edi,%edx
  803de1:	89 d1                	mov    %edx,%ecx
  803de3:	89 c6                	mov    %eax,%esi
  803de5:	e9 71 ff ff ff       	jmp    803d5b <__umoddi3+0xb3>
  803dea:	66 90                	xchg   %ax,%ax
  803dec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803df0:	72 ea                	jb     803ddc <__umoddi3+0x134>
  803df2:	89 d9                	mov    %ebx,%ecx
  803df4:	e9 62 ff ff ff       	jmp    803d5b <__umoddi3+0xb3>
