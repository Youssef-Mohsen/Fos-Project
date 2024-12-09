
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
  800052:	68 60 3e 80 00       	push   $0x803e60
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
  8000ec:	68 7e 3e 80 00       	push   $0x803e7e
  8000f1:	e8 ff 02 00 00       	call   8003f5 <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 c6 1b 00 00       	call   801cc4 <inctst>
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
  8001bb:	e8 c6 19 00 00       	call   801b86 <sys_getenvindex>
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
  800229:	e8 dc 16 00 00       	call   80190a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	68 ac 3e 80 00       	push   $0x803eac
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
  800259:	68 d4 3e 80 00       	push   $0x803ed4
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
  80028a:	68 fc 3e 80 00       	push   $0x803efc
  80028f:	e8 34 01 00 00       	call   8003c8 <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800297:	a1 20 50 80 00       	mov    0x805020,%eax
  80029c:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	50                   	push   %eax
  8002a6:	68 54 3f 80 00       	push   $0x803f54
  8002ab:	e8 18 01 00 00       	call   8003c8 <cprintf>
  8002b0:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	68 ac 3e 80 00       	push   $0x803eac
  8002bb:	e8 08 01 00 00       	call   8003c8 <cprintf>
  8002c0:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002c3:	e8 5c 16 00 00       	call   801924 <sys_unlock_cons>
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
  8002db:	e8 72 18 00 00       	call   801b52 <sys_destroy_env>
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
  8002ec:	e8 c7 18 00 00       	call   801bb8 <sys_exit_env>
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
  80033a:	e8 89 15 00 00       	call   8018c8 <sys_cputs>
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
  8003b1:	e8 12 15 00 00       	call   8018c8 <sys_cputs>
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
  8003fb:	e8 0a 15 00 00       	call   80190a <sys_lock_cons>
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
  80041b:	e8 04 15 00 00       	call   801924 <sys_unlock_cons>
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
  800465:	e8 86 37 00 00       	call   803bf0 <__udivdi3>
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
  8004b5:	e8 46 38 00 00       	call   803d00 <__umoddi3>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	05 94 41 80 00       	add    $0x804194,%eax
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
  800610:	8b 04 85 b8 41 80 00 	mov    0x8041b8(,%eax,4),%eax
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
  8006f1:	8b 34 9d 00 40 80 00 	mov    0x804000(,%ebx,4),%esi
  8006f8:	85 f6                	test   %esi,%esi
  8006fa:	75 19                	jne    800715 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006fc:	53                   	push   %ebx
  8006fd:	68 a5 41 80 00       	push   $0x8041a5
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
  800716:	68 ae 41 80 00       	push   $0x8041ae
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
  800743:	be b1 41 80 00       	mov    $0x8041b1,%esi
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
  800a6e:	68 28 43 80 00       	push   $0x804328
  800a73:	e8 50 f9 ff ff       	call   8003c8 <cprintf>
  800a78:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a82:	83 ec 0c             	sub    $0xc,%esp
  800a85:	6a 00                	push   $0x0
  800a87:	e8 6e 2f 00 00       	call   8039fa <iscons>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a92:	e8 50 2f 00 00       	call   8039e7 <getchar>
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
  800ab0:	68 2b 43 80 00       	push   $0x80432b
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
  800add:	e8 e6 2e 00 00       	call   8039c8 <cputchar>
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
  800b14:	e8 af 2e 00 00       	call   8039c8 <cputchar>
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
  800b3d:	e8 86 2e 00 00       	call   8039c8 <cputchar>
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
  800b61:	e8 a4 0d 00 00       	call   80190a <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6a:	74 13                	je     800b7f <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	68 28 43 80 00       	push   $0x804328
  800b77:	e8 4c f8 ff ff       	call   8003c8 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	6a 00                	push   $0x0
  800b8b:	e8 6a 2e 00 00       	call   8039fa <iscons>
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b96:	e8 4c 2e 00 00       	call   8039e7 <getchar>
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
  800bb4:	68 2b 43 80 00       	push   $0x80432b
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
  800be1:	e8 e2 2d 00 00       	call   8039c8 <cputchar>
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
  800c18:	e8 ab 2d 00 00       	call   8039c8 <cputchar>
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
  800c41:	e8 82 2d 00 00       	call   8039c8 <cputchar>
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
  800c5c:	e8 c3 0c 00 00       	call   801924 <sys_unlock_cons>
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
  801356:	68 3c 43 80 00       	push   $0x80433c
  80135b:	68 3f 01 00 00       	push   $0x13f
  801360:	68 5e 43 80 00       	push   $0x80435e
  801365:	e8 9a 26 00 00       	call   803a04 <_panic>

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
  801376:	e8 f8 0a 00 00       	call   801e73 <sys_sbrk>
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
  8013f1:	e8 01 09 00 00       	call   801cf7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	74 16                	je     801410 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 dd 0e 00 00       	call   8022e2 <alloc_block_FF>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80140b:	e9 8a 01 00 00       	jmp    80159a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801410:	e8 13 09 00 00       	call   801d28 <sys_isUHeapPlacementStrategyBESTFIT>
  801415:	85 c0                	test   %eax,%eax
  801417:	0f 84 7d 01 00 00    	je     80159a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80141d:	83 ec 0c             	sub    $0xc,%esp
  801420:	ff 75 08             	pushl  0x8(%ebp)
  801423:	e8 76 13 00 00       	call   80279e <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  801482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801485:	05 00 10 00 00       	add    $0x1000,%eax
  80148a:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  80148d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  80152d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801531:	75 16                	jne    801549 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801533:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  80153a:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801541:	0f 86 15 ff ff ff    	jbe    80145c <malloc+0xdc>
  801547:	eb 01                	jmp    80154a <malloc+0x1ca>
				}
				

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
  801589:	e8 1c 09 00 00       	call   801eaa <sys_allocate_user_mem>
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	eb 07                	jmp    80159a <malloc+0x21a>
		
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
  8015d1:	e8 8c 09 00 00       	call   801f62 <get_block_size>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	ff 75 08             	pushl  0x8(%ebp)
  8015e2:	e8 9c 1b 00 00       	call   803183 <free_block>
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
  80161c:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  801659:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801660:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	83 ec 08             	sub    $0x8,%esp
  80166d:	52                   	push   %edx
  80166e:	50                   	push   %eax
  80166f:	e8 1a 08 00 00       	call   801e8e <sys_free_user_mem>
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
  801687:	68 6c 43 80 00       	push   $0x80436c
  80168c:	68 87 00 00 00       	push   $0x87
  801691:	68 96 43 80 00       	push   $0x804396
  801696:	e8 69 23 00 00       	call   803a04 <_panic>
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
  8016b5:	e9 87 00 00 00       	jmp    801741 <smalloc+0xa3>
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
  8016e6:	75 07                	jne    8016ef <smalloc+0x51>
  8016e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ed:	eb 52                	jmp    801741 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  8016ef:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8016f6:	50                   	push   %eax
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	ff 75 08             	pushl  0x8(%ebp)
  8016fd:	e8 93 03 00 00       	call   801a95 <sys_createSharedObject>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801708:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80170c:	74 06                	je     801714 <smalloc+0x76>
  80170e:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801712:	75 07                	jne    80171b <smalloc+0x7d>
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
  801719:	eb 26                	jmp    801741 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80171b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80171e:	a1 20 50 80 00       	mov    0x805020,%eax
  801723:	8b 40 78             	mov    0x78(%eax),%eax
  801726:	29 c2                	sub    %eax,%edx
  801728:	89 d0                	mov    %edx,%eax
  80172a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80172f:	c1 e8 0c             	shr    $0xc,%eax
  801732:	89 c2                	mov    %eax,%edx
  801734:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801737:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80173e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801749:	83 ec 08             	sub    $0x8,%esp
  80174c:	ff 75 0c             	pushl  0xc(%ebp)
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	e8 68 03 00 00       	call   801abf <sys_getSizeOfSharedObject>
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80175d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801761:	75 07                	jne    80176a <sget+0x27>
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	eb 7f                	jmp    8017e9 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80176a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801770:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801777:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80177a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177d:	39 d0                	cmp    %edx,%eax
  80177f:	73 02                	jae    801783 <sget+0x40>
  801781:	89 d0                	mov    %edx,%eax
  801783:	83 ec 0c             	sub    $0xc,%esp
  801786:	50                   	push   %eax
  801787:	e8 f4 fb ff ff       	call   801380 <malloc>
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801792:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801796:	75 07                	jne    80179f <sget+0x5c>
  801798:	b8 00 00 00 00       	mov    $0x0,%eax
  80179d:	eb 4a                	jmp    8017e9 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80179f:	83 ec 04             	sub    $0x4,%esp
  8017a2:	ff 75 e8             	pushl  -0x18(%ebp)
  8017a5:	ff 75 0c             	pushl  0xc(%ebp)
  8017a8:	ff 75 08             	pushl  0x8(%ebp)
  8017ab:	e8 2c 03 00 00       	call   801adc <sys_getSharedObject>
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8017b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8017be:	8b 40 78             	mov    0x78(%eax),%eax
  8017c1:	29 c2                	sub    %eax,%edx
  8017c3:	89 d0                	mov    %edx,%eax
  8017c5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017ca:	c1 e8 0c             	shr    $0xc,%eax
  8017cd:	89 c2                	mov    %eax,%edx
  8017cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d2:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8017d9:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8017dd:	75 07                	jne    8017e6 <sget+0xa3>
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e4:	eb 03                	jmp    8017e9 <sget+0xa6>
	return ptr;
  8017e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8017f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8017f9:	8b 40 78             	mov    0x78(%eax),%eax
  8017fc:	29 c2                	sub    %eax,%edx
  8017fe:	89 d0                	mov    %edx,%eax
  801800:	2d 00 10 00 00       	sub    $0x1000,%eax
  801805:	c1 e8 0c             	shr    $0xc,%eax
  801808:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80180f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801812:	83 ec 08             	sub    $0x8,%esp
  801815:	ff 75 08             	pushl  0x8(%ebp)
  801818:	ff 75 f4             	pushl  -0xc(%ebp)
  80181b:	e8 db 02 00 00       	call   801afb <sys_freeSharedObject>
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801826:	90                   	nop
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	68 a4 43 80 00       	push   $0x8043a4
  801837:	68 e4 00 00 00       	push   $0xe4
  80183c:	68 96 43 80 00       	push   $0x804396
  801841:	e8 be 21 00 00       	call   803a04 <_panic>

00801846 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	68 ca 43 80 00       	push   $0x8043ca
  801854:	68 f0 00 00 00       	push   $0xf0
  801859:	68 96 43 80 00       	push   $0x804396
  80185e:	e8 a1 21 00 00       	call   803a04 <_panic>

00801863 <shrink>:

}
void shrink(uint32 newSize)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	68 ca 43 80 00       	push   $0x8043ca
  801871:	68 f5 00 00 00       	push   $0xf5
  801876:	68 96 43 80 00       	push   $0x804396
  80187b:	e8 84 21 00 00       	call   803a04 <_panic>

00801880 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	68 ca 43 80 00       	push   $0x8043ca
  80188e:	68 fa 00 00 00       	push   $0xfa
  801893:	68 96 43 80 00       	push   $0x804396
  801898:	e8 67 21 00 00       	call   803a04 <_panic>

0080189d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	57                   	push   %edi
  8018a1:	56                   	push   %esi
  8018a2:	53                   	push   %ebx
  8018a3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018af:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018b5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018b8:	cd 30                	int    $0x30
  8018ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018c0:	83 c4 10             	add    $0x10,%esp
  8018c3:	5b                   	pop    %ebx
  8018c4:	5e                   	pop    %esi
  8018c5:	5f                   	pop    %edi
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    

008018c8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 04             	sub    $0x4,%esp
  8018ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018d4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	52                   	push   %edx
  8018e0:	ff 75 0c             	pushl  0xc(%ebp)
  8018e3:	50                   	push   %eax
  8018e4:	6a 00                	push   $0x0
  8018e6:	e8 b2 ff ff ff       	call   80189d <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	90                   	nop
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 02                	push   $0x2
  801900:	e8 98 ff ff ff       	call   80189d <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 03                	push   $0x3
  801919:	e8 7f ff ff ff       	call   80189d <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 04                	push   $0x4
  801933:	e8 65 ff ff ff       	call   80189d <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	90                   	nop
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801941:	8b 55 0c             	mov    0xc(%ebp),%edx
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	52                   	push   %edx
  80194e:	50                   	push   %eax
  80194f:	6a 08                	push   $0x8
  801951:	e8 47 ff ff ff       	call   80189d <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	56                   	push   %esi
  80195f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801960:	8b 75 18             	mov    0x18(%ebp),%esi
  801963:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801966:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	56                   	push   %esi
  801970:	53                   	push   %ebx
  801971:	51                   	push   %ecx
  801972:	52                   	push   %edx
  801973:	50                   	push   %eax
  801974:	6a 09                	push   $0x9
  801976:	e8 22 ff ff ff       	call   80189d <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801981:	5b                   	pop    %ebx
  801982:	5e                   	pop    %esi
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    

00801985 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	52                   	push   %edx
  801995:	50                   	push   %eax
  801996:	6a 0a                	push   $0xa
  801998:	e8 00 ff ff ff       	call   80189d <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	ff 75 08             	pushl  0x8(%ebp)
  8019b1:	6a 0b                	push   $0xb
  8019b3:	e8 e5 fe ff ff       	call   80189d <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 0c                	push   $0xc
  8019cc:	e8 cc fe ff ff       	call   80189d <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 0d                	push   $0xd
  8019e5:	e8 b3 fe ff ff       	call   80189d <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 0e                	push   $0xe
  8019fe:	e8 9a fe ff ff       	call   80189d <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 0f                	push   $0xf
  801a17:	e8 81 fe ff ff       	call   80189d <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	ff 75 08             	pushl  0x8(%ebp)
  801a2f:	6a 10                	push   $0x10
  801a31:	e8 67 fe ff ff       	call   80189d <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 11                	push   $0x11
  801a4a:	e8 4e fe ff ff       	call   80189d <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	90                   	nop
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a61:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	50                   	push   %eax
  801a6e:	6a 01                	push   $0x1
  801a70:	e8 28 fe ff ff       	call   80189d <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	90                   	nop
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 14                	push   $0x14
  801a8a:	e8 0e fe ff ff       	call   80189d <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	90                   	nop
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 04             	sub    $0x4,%esp
  801a9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aa1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	6a 00                	push   $0x0
  801aad:	51                   	push   %ecx
  801aae:	52                   	push   %edx
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	50                   	push   %eax
  801ab3:	6a 15                	push   $0x15
  801ab5:	e8 e3 fd ff ff       	call   80189d <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	52                   	push   %edx
  801acf:	50                   	push   %eax
  801ad0:	6a 16                	push   $0x16
  801ad2:	e8 c6 fd ff ff       	call   80189d <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801adf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	51                   	push   %ecx
  801aed:	52                   	push   %edx
  801aee:	50                   	push   %eax
  801aef:	6a 17                	push   $0x17
  801af1:	e8 a7 fd ff ff       	call   80189d <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	6a 18                	push   $0x18
  801b0e:	e8 8a fd ff ff       	call   80189d <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	ff 75 14             	pushl  0x14(%ebp)
  801b23:	ff 75 10             	pushl  0x10(%ebp)
  801b26:	ff 75 0c             	pushl  0xc(%ebp)
  801b29:	50                   	push   %eax
  801b2a:	6a 19                	push   $0x19
  801b2c:	e8 6c fd ff ff       	call   80189d <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	50                   	push   %eax
  801b45:	6a 1a                	push   $0x1a
  801b47:	e8 51 fd ff ff       	call   80189d <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	50                   	push   %eax
  801b61:	6a 1b                	push   $0x1b
  801b63:	e8 35 fd ff ff       	call   80189d <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 05                	push   $0x5
  801b7c:	e8 1c fd ff ff       	call   80189d <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 06                	push   $0x6
  801b95:	e8 03 fd ff ff       	call   80189d <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 07                	push   $0x7
  801bae:	e8 ea fc ff ff       	call   80189d <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_exit_env>:


void sys_exit_env(void)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 1c                	push   $0x1c
  801bc7:	e8 d1 fc ff ff       	call   80189d <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	90                   	nop
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bd8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bdb:	8d 50 04             	lea    0x4(%eax),%edx
  801bde:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	52                   	push   %edx
  801be8:	50                   	push   %eax
  801be9:	6a 1d                	push   $0x1d
  801beb:	e8 ad fc ff ff       	call   80189d <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
	return result;
  801bf3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bf9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bfc:	89 01                	mov    %eax,(%ecx)
  801bfe:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	c9                   	leave  
  801c05:	c2 04 00             	ret    $0x4

00801c08 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	ff 75 10             	pushl  0x10(%ebp)
  801c12:	ff 75 0c             	pushl  0xc(%ebp)
  801c15:	ff 75 08             	pushl  0x8(%ebp)
  801c18:	6a 13                	push   $0x13
  801c1a:	e8 7e fc ff ff       	call   80189d <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c22:	90                   	nop
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 1e                	push   $0x1e
  801c34:	e8 64 fc ff ff       	call   80189d <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 04             	sub    $0x4,%esp
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c4a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	50                   	push   %eax
  801c57:	6a 1f                	push   $0x1f
  801c59:	e8 3f fc ff ff       	call   80189d <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c61:	90                   	nop
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <rsttst>:
void rsttst()
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 21                	push   $0x21
  801c73:	e8 25 fc ff ff       	call   80189d <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7b:	90                   	nop
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 04             	sub    $0x4,%esp
  801c84:	8b 45 14             	mov    0x14(%ebp),%eax
  801c87:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c8a:	8b 55 18             	mov    0x18(%ebp),%edx
  801c8d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c91:	52                   	push   %edx
  801c92:	50                   	push   %eax
  801c93:	ff 75 10             	pushl  0x10(%ebp)
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	6a 20                	push   $0x20
  801c9e:	e8 fa fb ff ff       	call   80189d <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca6:	90                   	nop
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <chktst>:
void chktst(uint32 n)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	ff 75 08             	pushl  0x8(%ebp)
  801cb7:	6a 22                	push   $0x22
  801cb9:	e8 df fb ff ff       	call   80189d <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc1:	90                   	nop
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <inctst>:

void inctst()
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 23                	push   $0x23
  801cd3:	e8 c5 fb ff ff       	call   80189d <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdb:	90                   	nop
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <gettst>:
uint32 gettst()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 24                	push   $0x24
  801ced:	e8 ab fb ff ff       	call   80189d <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 25                	push   $0x25
  801d09:	e8 8f fb ff ff       	call   80189d <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
  801d11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d14:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d18:	75 07                	jne    801d21 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1f:	eb 05                	jmp    801d26 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 25                	push   $0x25
  801d3a:	e8 5e fb ff ff       	call   80189d <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
  801d42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d45:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d49:	75 07                	jne    801d52 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d50:	eb 05                	jmp    801d57 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 25                	push   $0x25
  801d6b:	e8 2d fb ff ff       	call   80189d <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
  801d73:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d76:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d7a:	75 07                	jne    801d83 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d7c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d81:	eb 05                	jmp    801d88 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 25                	push   $0x25
  801d9c:	e8 fc fa ff ff       	call   80189d <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
  801da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801da7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dab:	75 07                	jne    801db4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dad:	b8 01 00 00 00       	mov    $0x1,%eax
  801db2:	eb 05                	jmp    801db9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	ff 75 08             	pushl  0x8(%ebp)
  801dc9:	6a 26                	push   $0x26
  801dcb:	e8 cd fa ff ff       	call   80189d <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd3:	90                   	nop
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dda:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ddd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	6a 00                	push   $0x0
  801de8:	53                   	push   %ebx
  801de9:	51                   	push   %ecx
  801dea:	52                   	push   %edx
  801deb:	50                   	push   %eax
  801dec:	6a 27                	push   $0x27
  801dee:	e8 aa fa ff ff       	call   80189d <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
}
  801df6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	52                   	push   %edx
  801e0b:	50                   	push   %eax
  801e0c:	6a 28                	push   $0x28
  801e0e:	e8 8a fa ff ff       	call   80189d <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e1b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e21:	8b 45 08             	mov    0x8(%ebp),%eax
  801e24:	6a 00                	push   $0x0
  801e26:	51                   	push   %ecx
  801e27:	ff 75 10             	pushl  0x10(%ebp)
  801e2a:	52                   	push   %edx
  801e2b:	50                   	push   %eax
  801e2c:	6a 29                	push   $0x29
  801e2e:	e8 6a fa ff ff       	call   80189d <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	ff 75 10             	pushl  0x10(%ebp)
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	ff 75 08             	pushl  0x8(%ebp)
  801e48:	6a 12                	push   $0x12
  801e4a:	e8 4e fa ff ff       	call   80189d <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e52:	90                   	nop
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	52                   	push   %edx
  801e65:	50                   	push   %eax
  801e66:	6a 2a                	push   $0x2a
  801e68:	e8 30 fa ff ff       	call   80189d <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
	return;
  801e70:	90                   	nop
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	50                   	push   %eax
  801e82:	6a 2b                	push   $0x2b
  801e84:	e8 14 fa ff ff       	call   80189d <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	ff 75 0c             	pushl  0xc(%ebp)
  801e9a:	ff 75 08             	pushl  0x8(%ebp)
  801e9d:	6a 2c                	push   $0x2c
  801e9f:	e8 f9 f9 ff ff       	call   80189d <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
	return;
  801ea7:	90                   	nop
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	ff 75 0c             	pushl  0xc(%ebp)
  801eb6:	ff 75 08             	pushl  0x8(%ebp)
  801eb9:	6a 2d                	push   $0x2d
  801ebb:	e8 dd f9 ff ff       	call   80189d <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
	return;
  801ec3:	90                   	nop
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 2e                	push   $0x2e
  801ed8:	e8 c0 f9 ff ff       	call   80189d <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
  801ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	50                   	push   %eax
  801ef7:	6a 2f                	push   $0x2f
  801ef9:	e8 9f f9 ff ff       	call   80189d <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
	return;
  801f01:	90                   	nop
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801f07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	52                   	push   %edx
  801f14:	50                   	push   %eax
  801f15:	6a 30                	push   $0x30
  801f17:	e8 81 f9 ff ff       	call   80189d <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
	return;
  801f1f:	90                   	nop
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	50                   	push   %eax
  801f34:	6a 31                	push   $0x31
  801f36:	e8 62 f9 ff ff       	call   80189d <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
  801f3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801f41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	50                   	push   %eax
  801f55:	6a 32                	push   $0x32
  801f57:	e8 41 f9 ff ff       	call   80189d <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
	return;
  801f5f:	90                   	nop
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	83 e8 04             	sub    $0x4,%eax
  801f6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f74:	8b 00                	mov    (%eax),%eax
  801f76:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	83 e8 04             	sub    $0x4,%eax
  801f87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f8d:	8b 00                	mov    (%eax),%eax
  801f8f:	83 e0 01             	and    $0x1,%eax
  801f92:	85 c0                	test   %eax,%eax
  801f94:	0f 94 c0             	sete   %al
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa9:	83 f8 02             	cmp    $0x2,%eax
  801fac:	74 2b                	je     801fd9 <alloc_block+0x40>
  801fae:	83 f8 02             	cmp    $0x2,%eax
  801fb1:	7f 07                	jg     801fba <alloc_block+0x21>
  801fb3:	83 f8 01             	cmp    $0x1,%eax
  801fb6:	74 0e                	je     801fc6 <alloc_block+0x2d>
  801fb8:	eb 58                	jmp    802012 <alloc_block+0x79>
  801fba:	83 f8 03             	cmp    $0x3,%eax
  801fbd:	74 2d                	je     801fec <alloc_block+0x53>
  801fbf:	83 f8 04             	cmp    $0x4,%eax
  801fc2:	74 3b                	je     801fff <alloc_block+0x66>
  801fc4:	eb 4c                	jmp    802012 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	ff 75 08             	pushl  0x8(%ebp)
  801fcc:	e8 11 03 00 00       	call   8022e2 <alloc_block_FF>
  801fd1:	83 c4 10             	add    $0x10,%esp
  801fd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fd7:	eb 4a                	jmp    802023 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801fd9:	83 ec 0c             	sub    $0xc,%esp
  801fdc:	ff 75 08             	pushl  0x8(%ebp)
  801fdf:	e8 c7 19 00 00       	call   8039ab <alloc_block_NF>
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801fea:	eb 37                	jmp    802023 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801fec:	83 ec 0c             	sub    $0xc,%esp
  801fef:	ff 75 08             	pushl  0x8(%ebp)
  801ff2:	e8 a7 07 00 00       	call   80279e <alloc_block_BF>
  801ff7:	83 c4 10             	add    $0x10,%esp
  801ffa:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ffd:	eb 24                	jmp    802023 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801fff:	83 ec 0c             	sub    $0xc,%esp
  802002:	ff 75 08             	pushl  0x8(%ebp)
  802005:	e8 84 19 00 00       	call   80398e <alloc_block_WF>
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802010:	eb 11                	jmp    802023 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802012:	83 ec 0c             	sub    $0xc,%esp
  802015:	68 dc 43 80 00       	push   $0x8043dc
  80201a:	e8 a9 e3 ff ff       	call   8003c8 <cprintf>
  80201f:	83 c4 10             	add    $0x10,%esp
		break;
  802022:	90                   	nop
	}
	return va;
  802023:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	53                   	push   %ebx
  80202c:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	68 fc 43 80 00       	push   $0x8043fc
  802037:	e8 8c e3 ff ff       	call   8003c8 <cprintf>
  80203c:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80203f:	83 ec 0c             	sub    $0xc,%esp
  802042:	68 27 44 80 00       	push   $0x804427
  802047:	e8 7c e3 ff ff       	call   8003c8 <cprintf>
  80204c:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802055:	eb 37                	jmp    80208e <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802057:	83 ec 0c             	sub    $0xc,%esp
  80205a:	ff 75 f4             	pushl  -0xc(%ebp)
  80205d:	e8 19 ff ff ff       	call   801f7b <is_free_block>
  802062:	83 c4 10             	add    $0x10,%esp
  802065:	0f be d8             	movsbl %al,%ebx
  802068:	83 ec 0c             	sub    $0xc,%esp
  80206b:	ff 75 f4             	pushl  -0xc(%ebp)
  80206e:	e8 ef fe ff ff       	call   801f62 <get_block_size>
  802073:	83 c4 10             	add    $0x10,%esp
  802076:	83 ec 04             	sub    $0x4,%esp
  802079:	53                   	push   %ebx
  80207a:	50                   	push   %eax
  80207b:	68 3f 44 80 00       	push   $0x80443f
  802080:	e8 43 e3 ff ff       	call   8003c8 <cprintf>
  802085:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802088:	8b 45 10             	mov    0x10(%ebp),%eax
  80208b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802092:	74 07                	je     80209b <print_blocks_list+0x73>
  802094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802097:	8b 00                	mov    (%eax),%eax
  802099:	eb 05                	jmp    8020a0 <print_blocks_list+0x78>
  80209b:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a0:	89 45 10             	mov    %eax,0x10(%ebp)
  8020a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	75 ad                	jne    802057 <print_blocks_list+0x2f>
  8020aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ae:	75 a7                	jne    802057 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8020b0:	83 ec 0c             	sub    $0xc,%esp
  8020b3:	68 fc 43 80 00       	push   $0x8043fc
  8020b8:	e8 0b e3 ff ff       	call   8003c8 <cprintf>
  8020bd:	83 c4 10             	add    $0x10,%esp

}
  8020c0:	90                   	nop
  8020c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	83 e0 01             	and    $0x1,%eax
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	74 03                	je     8020d9 <initialize_dynamic_allocator+0x13>
  8020d6:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  8020d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020dd:	0f 84 c7 01 00 00    	je     8022aa <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  8020e3:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  8020ea:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  8020ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f3:	01 d0                	add    %edx,%eax
  8020f5:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  8020fa:	0f 87 ad 01 00 00    	ja     8022ad <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	85 c0                	test   %eax,%eax
  802105:	0f 89 a5 01 00 00    	jns    8022b0 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80210b:	8b 55 08             	mov    0x8(%ebp),%edx
  80210e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802111:	01 d0                	add    %edx,%eax
  802113:	83 e8 04             	sub    $0x4,%eax
  802116:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80211b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802122:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802127:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212a:	e9 87 00 00 00       	jmp    8021b6 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  80212f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802133:	75 14                	jne    802149 <initialize_dynamic_allocator+0x83>
  802135:	83 ec 04             	sub    $0x4,%esp
  802138:	68 57 44 80 00       	push   $0x804457
  80213d:	6a 79                	push   $0x79
  80213f:	68 75 44 80 00       	push   $0x804475
  802144:	e8 bb 18 00 00       	call   803a04 <_panic>
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	8b 00                	mov    (%eax),%eax
  80214e:	85 c0                	test   %eax,%eax
  802150:	74 10                	je     802162 <initialize_dynamic_allocator+0x9c>
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	8b 00                	mov    (%eax),%eax
  802157:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215a:	8b 52 04             	mov    0x4(%edx),%edx
  80215d:	89 50 04             	mov    %edx,0x4(%eax)
  802160:	eb 0b                	jmp    80216d <initialize_dynamic_allocator+0xa7>
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	8b 40 04             	mov    0x4(%eax),%eax
  802168:	a3 30 50 80 00       	mov    %eax,0x805030
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	8b 40 04             	mov    0x4(%eax),%eax
  802173:	85 c0                	test   %eax,%eax
  802175:	74 0f                	je     802186 <initialize_dynamic_allocator+0xc0>
  802177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217a:	8b 40 04             	mov    0x4(%eax),%eax
  80217d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802180:	8b 12                	mov    (%edx),%edx
  802182:	89 10                	mov    %edx,(%eax)
  802184:	eb 0a                	jmp    802190 <initialize_dynamic_allocator+0xca>
  802186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802189:	8b 00                	mov    (%eax),%eax
  80218b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802193:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a3:	a1 38 50 80 00       	mov    0x805038,%eax
  8021a8:	48                   	dec    %eax
  8021a9:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  8021ae:	a1 34 50 80 00       	mov    0x805034,%eax
  8021b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ba:	74 07                	je     8021c3 <initialize_dynamic_allocator+0xfd>
  8021bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bf:	8b 00                	mov    (%eax),%eax
  8021c1:	eb 05                	jmp    8021c8 <initialize_dynamic_allocator+0x102>
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	a3 34 50 80 00       	mov    %eax,0x805034
  8021cd:	a1 34 50 80 00       	mov    0x805034,%eax
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	0f 85 55 ff ff ff    	jne    80212f <initialize_dynamic_allocator+0x69>
  8021da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021de:	0f 85 4b ff ff ff    	jne    80212f <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  8021ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ed:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  8021f3:	a1 44 50 80 00       	mov    0x805044,%eax
  8021f8:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  8021fd:	a1 40 50 80 00       	mov    0x805040,%eax
  802202:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	83 c0 08             	add    $0x8,%eax
  80220e:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	83 c0 04             	add    $0x4,%eax
  802217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221a:	83 ea 08             	sub    $0x8,%edx
  80221d:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  80221f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	01 d0                	add    %edx,%eax
  802227:	83 e8 08             	sub    $0x8,%eax
  80222a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222d:	83 ea 08             	sub    $0x8,%edx
  802230:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802235:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80223b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802245:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802249:	75 17                	jne    802262 <initialize_dynamic_allocator+0x19c>
  80224b:	83 ec 04             	sub    $0x4,%esp
  80224e:	68 90 44 80 00       	push   $0x804490
  802253:	68 90 00 00 00       	push   $0x90
  802258:	68 75 44 80 00       	push   $0x804475
  80225d:	e8 a2 17 00 00       	call   803a04 <_panic>
  802262:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802268:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226b:	89 10                	mov    %edx,(%eax)
  80226d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802270:	8b 00                	mov    (%eax),%eax
  802272:	85 c0                	test   %eax,%eax
  802274:	74 0d                	je     802283 <initialize_dynamic_allocator+0x1bd>
  802276:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80227b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80227e:	89 50 04             	mov    %edx,0x4(%eax)
  802281:	eb 08                	jmp    80228b <initialize_dynamic_allocator+0x1c5>
  802283:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802286:	a3 30 50 80 00       	mov    %eax,0x805030
  80228b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802293:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802296:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80229d:	a1 38 50 80 00       	mov    0x805038,%eax
  8022a2:	40                   	inc    %eax
  8022a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8022a8:	eb 07                	jmp    8022b1 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8022aa:	90                   	nop
  8022ab:	eb 04                	jmp    8022b1 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8022ad:	90                   	nop
  8022ae:	eb 01                	jmp    8022b1 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8022b0:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8022b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b9:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	8d 50 fc             	lea    -0x4(%eax),%edx
  8022c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c5:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	83 e8 04             	sub    $0x4,%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	83 e0 fe             	and    $0xfffffffe,%eax
  8022d2:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	01 c2                	add    %eax,%edx
  8022da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022dd:	89 02                	mov    %eax,(%edx)
}
  8022df:	90                   	nop
  8022e0:	5d                   	pop    %ebp
  8022e1:	c3                   	ret    

008022e2 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	83 e0 01             	and    $0x1,%eax
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	74 03                	je     8022f5 <alloc_block_FF+0x13>
  8022f2:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8022f5:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8022f9:	77 07                	ja     802302 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8022fb:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802302:	a1 24 50 80 00       	mov    0x805024,%eax
  802307:	85 c0                	test   %eax,%eax
  802309:	75 73                	jne    80237e <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	83 c0 10             	add    $0x10,%eax
  802311:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802314:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80231b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80231e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802321:	01 d0                	add    %edx,%eax
  802323:	48                   	dec    %eax
  802324:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802327:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80232a:	ba 00 00 00 00       	mov    $0x0,%edx
  80232f:	f7 75 ec             	divl   -0x14(%ebp)
  802332:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802335:	29 d0                	sub    %edx,%eax
  802337:	c1 e8 0c             	shr    $0xc,%eax
  80233a:	83 ec 0c             	sub    $0xc,%esp
  80233d:	50                   	push   %eax
  80233e:	e8 27 f0 ff ff       	call   80136a <sbrk>
  802343:	83 c4 10             	add    $0x10,%esp
  802346:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802349:	83 ec 0c             	sub    $0xc,%esp
  80234c:	6a 00                	push   $0x0
  80234e:	e8 17 f0 ff ff       	call   80136a <sbrk>
  802353:	83 c4 10             	add    $0x10,%esp
  802356:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802359:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80235c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80235f:	83 ec 08             	sub    $0x8,%esp
  802362:	50                   	push   %eax
  802363:	ff 75 e4             	pushl  -0x1c(%ebp)
  802366:	e8 5b fd ff ff       	call   8020c6 <initialize_dynamic_allocator>
  80236b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80236e:	83 ec 0c             	sub    $0xc,%esp
  802371:	68 b3 44 80 00       	push   $0x8044b3
  802376:	e8 4d e0 ff ff       	call   8003c8 <cprintf>
  80237b:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80237e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802382:	75 0a                	jne    80238e <alloc_block_FF+0xac>
	        return NULL;
  802384:	b8 00 00 00 00       	mov    $0x0,%eax
  802389:	e9 0e 04 00 00       	jmp    80279c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80238e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802395:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80239a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239d:	e9 f3 02 00 00       	jmp    802695 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8023a8:	83 ec 0c             	sub    $0xc,%esp
  8023ab:	ff 75 bc             	pushl  -0x44(%ebp)
  8023ae:	e8 af fb ff ff       	call   801f62 <get_block_size>
  8023b3:	83 c4 10             	add    $0x10,%esp
  8023b6:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	83 c0 08             	add    $0x8,%eax
  8023bf:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023c2:	0f 87 c5 02 00 00    	ja     80268d <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	83 c0 18             	add    $0x18,%eax
  8023ce:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8023d1:	0f 87 19 02 00 00    	ja     8025f0 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8023d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8023da:	2b 45 08             	sub    0x8(%ebp),%eax
  8023dd:	83 e8 08             	sub    $0x8,%eax
  8023e0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8d 50 08             	lea    0x8(%eax),%edx
  8023e9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023ec:	01 d0                	add    %edx,%eax
  8023ee:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	83 c0 08             	add    $0x8,%eax
  8023f7:	83 ec 04             	sub    $0x4,%esp
  8023fa:	6a 01                	push   $0x1
  8023fc:	50                   	push   %eax
  8023fd:	ff 75 bc             	pushl  -0x44(%ebp)
  802400:	e8 ae fe ff ff       	call   8022b3 <set_block_data>
  802405:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 40 04             	mov    0x4(%eax),%eax
  80240e:	85 c0                	test   %eax,%eax
  802410:	75 68                	jne    80247a <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802412:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802416:	75 17                	jne    80242f <alloc_block_FF+0x14d>
  802418:	83 ec 04             	sub    $0x4,%esp
  80241b:	68 90 44 80 00       	push   $0x804490
  802420:	68 d7 00 00 00       	push   $0xd7
  802425:	68 75 44 80 00       	push   $0x804475
  80242a:	e8 d5 15 00 00       	call   803a04 <_panic>
  80242f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802435:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802438:	89 10                	mov    %edx,(%eax)
  80243a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80243d:	8b 00                	mov    (%eax),%eax
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 0d                	je     802450 <alloc_block_FF+0x16e>
  802443:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802448:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80244b:	89 50 04             	mov    %edx,0x4(%eax)
  80244e:	eb 08                	jmp    802458 <alloc_block_FF+0x176>
  802450:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802453:	a3 30 50 80 00       	mov    %eax,0x805030
  802458:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80245b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802460:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802463:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246a:	a1 38 50 80 00       	mov    0x805038,%eax
  80246f:	40                   	inc    %eax
  802470:	a3 38 50 80 00       	mov    %eax,0x805038
  802475:	e9 dc 00 00 00       	jmp    802556 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 00                	mov    (%eax),%eax
  80247f:	85 c0                	test   %eax,%eax
  802481:	75 65                	jne    8024e8 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802483:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802487:	75 17                	jne    8024a0 <alloc_block_FF+0x1be>
  802489:	83 ec 04             	sub    $0x4,%esp
  80248c:	68 c4 44 80 00       	push   $0x8044c4
  802491:	68 db 00 00 00       	push   $0xdb
  802496:	68 75 44 80 00       	push   $0x804475
  80249b:	e8 64 15 00 00       	call   803a04 <_panic>
  8024a0:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8024a6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a9:	89 50 04             	mov    %edx,0x4(%eax)
  8024ac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024af:	8b 40 04             	mov    0x4(%eax),%eax
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	74 0c                	je     8024c2 <alloc_block_FF+0x1e0>
  8024b6:	a1 30 50 80 00       	mov    0x805030,%eax
  8024bb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8024be:	89 10                	mov    %edx,(%eax)
  8024c0:	eb 08                	jmp    8024ca <alloc_block_FF+0x1e8>
  8024c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8024ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024cd:	a3 30 50 80 00       	mov    %eax,0x805030
  8024d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024db:	a1 38 50 80 00       	mov    0x805038,%eax
  8024e0:	40                   	inc    %eax
  8024e1:	a3 38 50 80 00       	mov    %eax,0x805038
  8024e6:	eb 6e                	jmp    802556 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8024e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ec:	74 06                	je     8024f4 <alloc_block_FF+0x212>
  8024ee:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8024f2:	75 17                	jne    80250b <alloc_block_FF+0x229>
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	68 e8 44 80 00       	push   $0x8044e8
  8024fc:	68 df 00 00 00       	push   $0xdf
  802501:	68 75 44 80 00       	push   $0x804475
  802506:	e8 f9 14 00 00       	call   803a04 <_panic>
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 10                	mov    (%eax),%edx
  802510:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802513:	89 10                	mov    %edx,(%eax)
  802515:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	85 c0                	test   %eax,%eax
  80251c:	74 0b                	je     802529 <alloc_block_FF+0x247>
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	8b 00                	mov    (%eax),%eax
  802523:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802526:	89 50 04             	mov    %edx,0x4(%eax)
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80252f:	89 10                	mov    %edx,(%eax)
  802531:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802534:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802537:	89 50 04             	mov    %edx,0x4(%eax)
  80253a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80253d:	8b 00                	mov    (%eax),%eax
  80253f:	85 c0                	test   %eax,%eax
  802541:	75 08                	jne    80254b <alloc_block_FF+0x269>
  802543:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802546:	a3 30 50 80 00       	mov    %eax,0x805030
  80254b:	a1 38 50 80 00       	mov    0x805038,%eax
  802550:	40                   	inc    %eax
  802551:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255a:	75 17                	jne    802573 <alloc_block_FF+0x291>
  80255c:	83 ec 04             	sub    $0x4,%esp
  80255f:	68 57 44 80 00       	push   $0x804457
  802564:	68 e1 00 00 00       	push   $0xe1
  802569:	68 75 44 80 00       	push   $0x804475
  80256e:	e8 91 14 00 00       	call   803a04 <_panic>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 00                	mov    (%eax),%eax
  802578:	85 c0                	test   %eax,%eax
  80257a:	74 10                	je     80258c <alloc_block_FF+0x2aa>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802584:	8b 52 04             	mov    0x4(%edx),%edx
  802587:	89 50 04             	mov    %edx,0x4(%eax)
  80258a:	eb 0b                	jmp    802597 <alloc_block_FF+0x2b5>
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 40 04             	mov    0x4(%eax),%eax
  802592:	a3 30 50 80 00       	mov    %eax,0x805030
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 40 04             	mov    0x4(%eax),%eax
  80259d:	85 c0                	test   %eax,%eax
  80259f:	74 0f                	je     8025b0 <alloc_block_FF+0x2ce>
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 40 04             	mov    0x4(%eax),%eax
  8025a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025aa:	8b 12                	mov    (%edx),%edx
  8025ac:	89 10                	mov    %edx,(%eax)
  8025ae:	eb 0a                	jmp    8025ba <alloc_block_FF+0x2d8>
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 00                	mov    (%eax),%eax
  8025b5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025cd:	a1 38 50 80 00       	mov    0x805038,%eax
  8025d2:	48                   	dec    %eax
  8025d3:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8025d8:	83 ec 04             	sub    $0x4,%esp
  8025db:	6a 00                	push   $0x0
  8025dd:	ff 75 b4             	pushl  -0x4c(%ebp)
  8025e0:	ff 75 b0             	pushl  -0x50(%ebp)
  8025e3:	e8 cb fc ff ff       	call   8022b3 <set_block_data>
  8025e8:	83 c4 10             	add    $0x10,%esp
  8025eb:	e9 95 00 00 00       	jmp    802685 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8025f0:	83 ec 04             	sub    $0x4,%esp
  8025f3:	6a 01                	push   $0x1
  8025f5:	ff 75 b8             	pushl  -0x48(%ebp)
  8025f8:	ff 75 bc             	pushl  -0x44(%ebp)
  8025fb:	e8 b3 fc ff ff       	call   8022b3 <set_block_data>
  802600:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802607:	75 17                	jne    802620 <alloc_block_FF+0x33e>
  802609:	83 ec 04             	sub    $0x4,%esp
  80260c:	68 57 44 80 00       	push   $0x804457
  802611:	68 e8 00 00 00       	push   $0xe8
  802616:	68 75 44 80 00       	push   $0x804475
  80261b:	e8 e4 13 00 00       	call   803a04 <_panic>
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 00                	mov    (%eax),%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	74 10                	je     802639 <alloc_block_FF+0x357>
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802631:	8b 52 04             	mov    0x4(%edx),%edx
  802634:	89 50 04             	mov    %edx,0x4(%eax)
  802637:	eb 0b                	jmp    802644 <alloc_block_FF+0x362>
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 40 04             	mov    0x4(%eax),%eax
  80263f:	a3 30 50 80 00       	mov    %eax,0x805030
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 40 04             	mov    0x4(%eax),%eax
  80264a:	85 c0                	test   %eax,%eax
  80264c:	74 0f                	je     80265d <alloc_block_FF+0x37b>
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 40 04             	mov    0x4(%eax),%eax
  802654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802657:	8b 12                	mov    (%edx),%edx
  802659:	89 10                	mov    %edx,(%eax)
  80265b:	eb 0a                	jmp    802667 <alloc_block_FF+0x385>
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 00                	mov    (%eax),%eax
  802662:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267a:	a1 38 50 80 00       	mov    0x805038,%eax
  80267f:	48                   	dec    %eax
  802680:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802685:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802688:	e9 0f 01 00 00       	jmp    80279c <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80268d:	a1 34 50 80 00       	mov    0x805034,%eax
  802692:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802695:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802699:	74 07                	je     8026a2 <alloc_block_FF+0x3c0>
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 00                	mov    (%eax),%eax
  8026a0:	eb 05                	jmp    8026a7 <alloc_block_FF+0x3c5>
  8026a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a7:	a3 34 50 80 00       	mov    %eax,0x805034
  8026ac:	a1 34 50 80 00       	mov    0x805034,%eax
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	0f 85 e9 fc ff ff    	jne    8023a2 <alloc_block_FF+0xc0>
  8026b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bd:	0f 85 df fc ff ff    	jne    8023a2 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	83 c0 08             	add    $0x8,%eax
  8026c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8026cc:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8026d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026d9:	01 d0                	add    %edx,%eax
  8026db:	48                   	dec    %eax
  8026dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8026df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e7:	f7 75 d8             	divl   -0x28(%ebp)
  8026ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026ed:	29 d0                	sub    %edx,%eax
  8026ef:	c1 e8 0c             	shr    $0xc,%eax
  8026f2:	83 ec 0c             	sub    $0xc,%esp
  8026f5:	50                   	push   %eax
  8026f6:	e8 6f ec ff ff       	call   80136a <sbrk>
  8026fb:	83 c4 10             	add    $0x10,%esp
  8026fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802701:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802705:	75 0a                	jne    802711 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802707:	b8 00 00 00 00       	mov    $0x0,%eax
  80270c:	e9 8b 00 00 00       	jmp    80279c <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802711:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802718:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80271b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80271e:	01 d0                	add    %edx,%eax
  802720:	48                   	dec    %eax
  802721:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802724:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802727:	ba 00 00 00 00       	mov    $0x0,%edx
  80272c:	f7 75 cc             	divl   -0x34(%ebp)
  80272f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802732:	29 d0                	sub    %edx,%eax
  802734:	8d 50 fc             	lea    -0x4(%eax),%edx
  802737:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80273a:	01 d0                	add    %edx,%eax
  80273c:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802741:	a1 40 50 80 00       	mov    0x805040,%eax
  802746:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80274c:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802753:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802756:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802759:	01 d0                	add    %edx,%eax
  80275b:	48                   	dec    %eax
  80275c:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80275f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802762:	ba 00 00 00 00       	mov    $0x0,%edx
  802767:	f7 75 c4             	divl   -0x3c(%ebp)
  80276a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80276d:	29 d0                	sub    %edx,%eax
  80276f:	83 ec 04             	sub    $0x4,%esp
  802772:	6a 01                	push   $0x1
  802774:	50                   	push   %eax
  802775:	ff 75 d0             	pushl  -0x30(%ebp)
  802778:	e8 36 fb ff ff       	call   8022b3 <set_block_data>
  80277d:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802780:	83 ec 0c             	sub    $0xc,%esp
  802783:	ff 75 d0             	pushl  -0x30(%ebp)
  802786:	e8 f8 09 00 00       	call   803183 <free_block>
  80278b:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80278e:	83 ec 0c             	sub    $0xc,%esp
  802791:	ff 75 08             	pushl  0x8(%ebp)
  802794:	e8 49 fb ff ff       	call   8022e2 <alloc_block_FF>
  802799:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80279c:	c9                   	leave  
  80279d:	c3                   	ret    

0080279e <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80279e:	55                   	push   %ebp
  80279f:	89 e5                	mov    %esp,%ebp
  8027a1:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	83 e0 01             	and    $0x1,%eax
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	74 03                	je     8027b1 <alloc_block_BF+0x13>
  8027ae:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8027b1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8027b5:	77 07                	ja     8027be <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8027b7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8027be:	a1 24 50 80 00       	mov    0x805024,%eax
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	75 73                	jne    80283a <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8027c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ca:	83 c0 10             	add    $0x10,%eax
  8027cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8027d0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8027d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027dd:	01 d0                	add    %edx,%eax
  8027df:	48                   	dec    %eax
  8027e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8027e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8027eb:	f7 75 e0             	divl   -0x20(%ebp)
  8027ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027f1:	29 d0                	sub    %edx,%eax
  8027f3:	c1 e8 0c             	shr    $0xc,%eax
  8027f6:	83 ec 0c             	sub    $0xc,%esp
  8027f9:	50                   	push   %eax
  8027fa:	e8 6b eb ff ff       	call   80136a <sbrk>
  8027ff:	83 c4 10             	add    $0x10,%esp
  802802:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802805:	83 ec 0c             	sub    $0xc,%esp
  802808:	6a 00                	push   $0x0
  80280a:	e8 5b eb ff ff       	call   80136a <sbrk>
  80280f:	83 c4 10             	add    $0x10,%esp
  802812:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802818:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80281b:	83 ec 08             	sub    $0x8,%esp
  80281e:	50                   	push   %eax
  80281f:	ff 75 d8             	pushl  -0x28(%ebp)
  802822:	e8 9f f8 ff ff       	call   8020c6 <initialize_dynamic_allocator>
  802827:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80282a:	83 ec 0c             	sub    $0xc,%esp
  80282d:	68 b3 44 80 00       	push   $0x8044b3
  802832:	e8 91 db ff ff       	call   8003c8 <cprintf>
  802837:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80283a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802841:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802848:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80284f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802856:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80285b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285e:	e9 1d 01 00 00       	jmp    802980 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802869:	83 ec 0c             	sub    $0xc,%esp
  80286c:	ff 75 a8             	pushl  -0x58(%ebp)
  80286f:	e8 ee f6 ff ff       	call   801f62 <get_block_size>
  802874:	83 c4 10             	add    $0x10,%esp
  802877:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80287a:	8b 45 08             	mov    0x8(%ebp),%eax
  80287d:	83 c0 08             	add    $0x8,%eax
  802880:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802883:	0f 87 ef 00 00 00    	ja     802978 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	83 c0 18             	add    $0x18,%eax
  80288f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802892:	77 1d                	ja     8028b1 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802897:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80289a:	0f 86 d8 00 00 00    	jbe    802978 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8028a0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8028a6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028ac:	e9 c7 00 00 00       	jmp    802978 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	83 c0 08             	add    $0x8,%eax
  8028b7:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028ba:	0f 85 9d 00 00 00    	jne    80295d <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	6a 01                	push   $0x1
  8028c5:	ff 75 a4             	pushl  -0x5c(%ebp)
  8028c8:	ff 75 a8             	pushl  -0x58(%ebp)
  8028cb:	e8 e3 f9 ff ff       	call   8022b3 <set_block_data>
  8028d0:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8028d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d7:	75 17                	jne    8028f0 <alloc_block_BF+0x152>
  8028d9:	83 ec 04             	sub    $0x4,%esp
  8028dc:	68 57 44 80 00       	push   $0x804457
  8028e1:	68 2c 01 00 00       	push   $0x12c
  8028e6:	68 75 44 80 00       	push   $0x804475
  8028eb:	e8 14 11 00 00       	call   803a04 <_panic>
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 10                	je     802909 <alloc_block_BF+0x16b>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802901:	8b 52 04             	mov    0x4(%edx),%edx
  802904:	89 50 04             	mov    %edx,0x4(%eax)
  802907:	eb 0b                	jmp    802914 <alloc_block_BF+0x176>
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 40 04             	mov    0x4(%eax),%eax
  80290f:	a3 30 50 80 00       	mov    %eax,0x805030
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 40 04             	mov    0x4(%eax),%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	74 0f                	je     80292d <alloc_block_BF+0x18f>
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802927:	8b 12                	mov    (%edx),%edx
  802929:	89 10                	mov    %edx,(%eax)
  80292b:	eb 0a                	jmp    802937 <alloc_block_BF+0x199>
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 00                	mov    (%eax),%eax
  802932:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294a:	a1 38 50 80 00       	mov    0x805038,%eax
  80294f:	48                   	dec    %eax
  802950:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802955:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802958:	e9 01 04 00 00       	jmp    802d5e <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80295d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802960:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802963:	76 13                	jbe    802978 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802965:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80296c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80296f:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802972:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802975:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802978:	a1 34 50 80 00       	mov    0x805034,%eax
  80297d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802980:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802984:	74 07                	je     80298d <alloc_block_BF+0x1ef>
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 00                	mov    (%eax),%eax
  80298b:	eb 05                	jmp    802992 <alloc_block_BF+0x1f4>
  80298d:	b8 00 00 00 00       	mov    $0x0,%eax
  802992:	a3 34 50 80 00       	mov    %eax,0x805034
  802997:	a1 34 50 80 00       	mov    0x805034,%eax
  80299c:	85 c0                	test   %eax,%eax
  80299e:	0f 85 bf fe ff ff    	jne    802863 <alloc_block_BF+0xc5>
  8029a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a8:	0f 85 b5 fe ff ff    	jne    802863 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8029ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029b2:	0f 84 26 02 00 00    	je     802bde <alloc_block_BF+0x440>
  8029b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029bc:	0f 85 1c 02 00 00    	jne    802bde <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8029c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c8:	83 e8 08             	sub    $0x8,%eax
  8029cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d1:	8d 50 08             	lea    0x8(%eax),%edx
  8029d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d7:	01 d0                	add    %edx,%eax
  8029d9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	83 c0 08             	add    $0x8,%eax
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	6a 01                	push   $0x1
  8029e7:	50                   	push   %eax
  8029e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8029eb:	e8 c3 f8 ff ff       	call   8022b3 <set_block_data>
  8029f0:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8029f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f6:	8b 40 04             	mov    0x4(%eax),%eax
  8029f9:	85 c0                	test   %eax,%eax
  8029fb:	75 68                	jne    802a65 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029fd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a01:	75 17                	jne    802a1a <alloc_block_BF+0x27c>
  802a03:	83 ec 04             	sub    $0x4,%esp
  802a06:	68 90 44 80 00       	push   $0x804490
  802a0b:	68 45 01 00 00       	push   $0x145
  802a10:	68 75 44 80 00       	push   $0x804475
  802a15:	e8 ea 0f 00 00       	call   803a04 <_panic>
  802a1a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802a20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a23:	89 10                	mov    %edx,(%eax)
  802a25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	74 0d                	je     802a3b <alloc_block_BF+0x29d>
  802a2e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802a33:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a36:	89 50 04             	mov    %edx,0x4(%eax)
  802a39:	eb 08                	jmp    802a43 <alloc_block_BF+0x2a5>
  802a3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a3e:	a3 30 50 80 00       	mov    %eax,0x805030
  802a43:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a46:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a55:	a1 38 50 80 00       	mov    0x805038,%eax
  802a5a:	40                   	inc    %eax
  802a5b:	a3 38 50 80 00       	mov    %eax,0x805038
  802a60:	e9 dc 00 00 00       	jmp    802b41 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a68:	8b 00                	mov    (%eax),%eax
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	75 65                	jne    802ad3 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802a6e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a72:	75 17                	jne    802a8b <alloc_block_BF+0x2ed>
  802a74:	83 ec 04             	sub    $0x4,%esp
  802a77:	68 c4 44 80 00       	push   $0x8044c4
  802a7c:	68 4a 01 00 00       	push   $0x14a
  802a81:	68 75 44 80 00       	push   $0x804475
  802a86:	e8 79 0f 00 00       	call   803a04 <_panic>
  802a8b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802a91:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a94:	89 50 04             	mov    %edx,0x4(%eax)
  802a97:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a9a:	8b 40 04             	mov    0x4(%eax),%eax
  802a9d:	85 c0                	test   %eax,%eax
  802a9f:	74 0c                	je     802aad <alloc_block_BF+0x30f>
  802aa1:	a1 30 50 80 00       	mov    0x805030,%eax
  802aa6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802aa9:	89 10                	mov    %edx,(%eax)
  802aab:	eb 08                	jmp    802ab5 <alloc_block_BF+0x317>
  802aad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ab5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ab8:	a3 30 50 80 00       	mov    %eax,0x805030
  802abd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac6:	a1 38 50 80 00       	mov    0x805038,%eax
  802acb:	40                   	inc    %eax
  802acc:	a3 38 50 80 00       	mov    %eax,0x805038
  802ad1:	eb 6e                	jmp    802b41 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802ad3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad7:	74 06                	je     802adf <alloc_block_BF+0x341>
  802ad9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802add:	75 17                	jne    802af6 <alloc_block_BF+0x358>
  802adf:	83 ec 04             	sub    $0x4,%esp
  802ae2:	68 e8 44 80 00       	push   $0x8044e8
  802ae7:	68 4f 01 00 00       	push   $0x14f
  802aec:	68 75 44 80 00       	push   $0x804475
  802af1:	e8 0e 0f 00 00       	call   803a04 <_panic>
  802af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af9:	8b 10                	mov    (%eax),%edx
  802afb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802afe:	89 10                	mov    %edx,(%eax)
  802b00:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	85 c0                	test   %eax,%eax
  802b07:	74 0b                	je     802b14 <alloc_block_BF+0x376>
  802b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b11:	89 50 04             	mov    %edx,0x4(%eax)
  802b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b17:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802b1a:	89 10                	mov    %edx,(%eax)
  802b1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b22:	89 50 04             	mov    %edx,0x4(%eax)
  802b25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	75 08                	jne    802b36 <alloc_block_BF+0x398>
  802b2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802b31:	a3 30 50 80 00       	mov    %eax,0x805030
  802b36:	a1 38 50 80 00       	mov    0x805038,%eax
  802b3b:	40                   	inc    %eax
  802b3c:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802b41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b45:	75 17                	jne    802b5e <alloc_block_BF+0x3c0>
  802b47:	83 ec 04             	sub    $0x4,%esp
  802b4a:	68 57 44 80 00       	push   $0x804457
  802b4f:	68 51 01 00 00       	push   $0x151
  802b54:	68 75 44 80 00       	push   $0x804475
  802b59:	e8 a6 0e 00 00       	call   803a04 <_panic>
  802b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	85 c0                	test   %eax,%eax
  802b65:	74 10                	je     802b77 <alloc_block_BF+0x3d9>
  802b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6a:	8b 00                	mov    (%eax),%eax
  802b6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6f:	8b 52 04             	mov    0x4(%edx),%edx
  802b72:	89 50 04             	mov    %edx,0x4(%eax)
  802b75:	eb 0b                	jmp    802b82 <alloc_block_BF+0x3e4>
  802b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7a:	8b 40 04             	mov    0x4(%eax),%eax
  802b7d:	a3 30 50 80 00       	mov    %eax,0x805030
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	8b 40 04             	mov    0x4(%eax),%eax
  802b88:	85 c0                	test   %eax,%eax
  802b8a:	74 0f                	je     802b9b <alloc_block_BF+0x3fd>
  802b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8f:	8b 40 04             	mov    0x4(%eax),%eax
  802b92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b95:	8b 12                	mov    (%edx),%edx
  802b97:	89 10                	mov    %edx,(%eax)
  802b99:	eb 0a                	jmp    802ba5 <alloc_block_BF+0x407>
  802b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9e:	8b 00                	mov    (%eax),%eax
  802ba0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb8:	a1 38 50 80 00       	mov    0x805038,%eax
  802bbd:	48                   	dec    %eax
  802bbe:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802bc3:	83 ec 04             	sub    $0x4,%esp
  802bc6:	6a 00                	push   $0x0
  802bc8:	ff 75 d0             	pushl  -0x30(%ebp)
  802bcb:	ff 75 cc             	pushl  -0x34(%ebp)
  802bce:	e8 e0 f6 ff ff       	call   8022b3 <set_block_data>
  802bd3:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	e9 80 01 00 00       	jmp    802d5e <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802bde:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802be2:	0f 85 9d 00 00 00    	jne    802c85 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802be8:	83 ec 04             	sub    $0x4,%esp
  802beb:	6a 01                	push   $0x1
  802bed:	ff 75 ec             	pushl  -0x14(%ebp)
  802bf0:	ff 75 f0             	pushl  -0x10(%ebp)
  802bf3:	e8 bb f6 ff ff       	call   8022b3 <set_block_data>
  802bf8:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802bfb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bff:	75 17                	jne    802c18 <alloc_block_BF+0x47a>
  802c01:	83 ec 04             	sub    $0x4,%esp
  802c04:	68 57 44 80 00       	push   $0x804457
  802c09:	68 58 01 00 00       	push   $0x158
  802c0e:	68 75 44 80 00       	push   $0x804475
  802c13:	e8 ec 0d 00 00       	call   803a04 <_panic>
  802c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1b:	8b 00                	mov    (%eax),%eax
  802c1d:	85 c0                	test   %eax,%eax
  802c1f:	74 10                	je     802c31 <alloc_block_BF+0x493>
  802c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c29:	8b 52 04             	mov    0x4(%edx),%edx
  802c2c:	89 50 04             	mov    %edx,0x4(%eax)
  802c2f:	eb 0b                	jmp    802c3c <alloc_block_BF+0x49e>
  802c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c34:	8b 40 04             	mov    0x4(%eax),%eax
  802c37:	a3 30 50 80 00       	mov    %eax,0x805030
  802c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3f:	8b 40 04             	mov    0x4(%eax),%eax
  802c42:	85 c0                	test   %eax,%eax
  802c44:	74 0f                	je     802c55 <alloc_block_BF+0x4b7>
  802c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c49:	8b 40 04             	mov    0x4(%eax),%eax
  802c4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4f:	8b 12                	mov    (%edx),%edx
  802c51:	89 10                	mov    %edx,(%eax)
  802c53:	eb 0a                	jmp    802c5f <alloc_block_BF+0x4c1>
  802c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c58:	8b 00                	mov    (%eax),%eax
  802c5a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c72:	a1 38 50 80 00       	mov    0x805038,%eax
  802c77:	48                   	dec    %eax
  802c78:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	e9 d9 00 00 00       	jmp    802d5e <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	83 c0 08             	add    $0x8,%eax
  802c8b:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802c8e:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802c95:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c98:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c9b:	01 d0                	add    %edx,%eax
  802c9d:	48                   	dec    %eax
  802c9e:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ca1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ca4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ca9:	f7 75 c4             	divl   -0x3c(%ebp)
  802cac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802caf:	29 d0                	sub    %edx,%eax
  802cb1:	c1 e8 0c             	shr    $0xc,%eax
  802cb4:	83 ec 0c             	sub    $0xc,%esp
  802cb7:	50                   	push   %eax
  802cb8:	e8 ad e6 ff ff       	call   80136a <sbrk>
  802cbd:	83 c4 10             	add    $0x10,%esp
  802cc0:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802cc3:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802cc7:	75 0a                	jne    802cd3 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cce:	e9 8b 00 00 00       	jmp    802d5e <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802cd3:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802cda:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802cdd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802ce0:	01 d0                	add    %edx,%eax
  802ce2:	48                   	dec    %eax
  802ce3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ce6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ce9:	ba 00 00 00 00       	mov    $0x0,%edx
  802cee:	f7 75 b8             	divl   -0x48(%ebp)
  802cf1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802cf4:	29 d0                	sub    %edx,%eax
  802cf6:	8d 50 fc             	lea    -0x4(%eax),%edx
  802cf9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cfc:	01 d0                	add    %edx,%eax
  802cfe:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802d03:	a1 40 50 80 00       	mov    0x805040,%eax
  802d08:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802d0e:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d15:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802d18:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d1b:	01 d0                	add    %edx,%eax
  802d1d:	48                   	dec    %eax
  802d1e:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d21:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d24:	ba 00 00 00 00       	mov    $0x0,%edx
  802d29:	f7 75 b0             	divl   -0x50(%ebp)
  802d2c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d2f:	29 d0                	sub    %edx,%eax
  802d31:	83 ec 04             	sub    $0x4,%esp
  802d34:	6a 01                	push   $0x1
  802d36:	50                   	push   %eax
  802d37:	ff 75 bc             	pushl  -0x44(%ebp)
  802d3a:	e8 74 f5 ff ff       	call   8022b3 <set_block_data>
  802d3f:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802d42:	83 ec 0c             	sub    $0xc,%esp
  802d45:	ff 75 bc             	pushl  -0x44(%ebp)
  802d48:	e8 36 04 00 00       	call   803183 <free_block>
  802d4d:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802d50:	83 ec 0c             	sub    $0xc,%esp
  802d53:	ff 75 08             	pushl  0x8(%ebp)
  802d56:	e8 43 fa ff ff       	call   80279e <alloc_block_BF>
  802d5b:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802d5e:	c9                   	leave  
  802d5f:	c3                   	ret    

00802d60 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802d60:	55                   	push   %ebp
  802d61:	89 e5                	mov    %esp,%ebp
  802d63:	53                   	push   %ebx
  802d64:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802d67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802d6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802d75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d79:	74 1e                	je     802d99 <merging+0x39>
  802d7b:	ff 75 08             	pushl  0x8(%ebp)
  802d7e:	e8 df f1 ff ff       	call   801f62 <get_block_size>
  802d83:	83 c4 04             	add    $0x4,%esp
  802d86:	89 c2                	mov    %eax,%edx
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	01 d0                	add    %edx,%eax
  802d8d:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d90:	75 07                	jne    802d99 <merging+0x39>
		prev_is_free = 1;
  802d92:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d9d:	74 1e                	je     802dbd <merging+0x5d>
  802d9f:	ff 75 10             	pushl  0x10(%ebp)
  802da2:	e8 bb f1 ff ff       	call   801f62 <get_block_size>
  802da7:	83 c4 04             	add    $0x4,%esp
  802daa:	89 c2                	mov    %eax,%edx
  802dac:	8b 45 10             	mov    0x10(%ebp),%eax
  802daf:	01 d0                	add    %edx,%eax
  802db1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802db4:	75 07                	jne    802dbd <merging+0x5d>
		next_is_free = 1;
  802db6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802dbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc1:	0f 84 cc 00 00 00    	je     802e93 <merging+0x133>
  802dc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dcb:	0f 84 c2 00 00 00    	je     802e93 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802dd1:	ff 75 08             	pushl  0x8(%ebp)
  802dd4:	e8 89 f1 ff ff       	call   801f62 <get_block_size>
  802dd9:	83 c4 04             	add    $0x4,%esp
  802ddc:	89 c3                	mov    %eax,%ebx
  802dde:	ff 75 10             	pushl  0x10(%ebp)
  802de1:	e8 7c f1 ff ff       	call   801f62 <get_block_size>
  802de6:	83 c4 04             	add    $0x4,%esp
  802de9:	01 c3                	add    %eax,%ebx
  802deb:	ff 75 0c             	pushl  0xc(%ebp)
  802dee:	e8 6f f1 ff ff       	call   801f62 <get_block_size>
  802df3:	83 c4 04             	add    $0x4,%esp
  802df6:	01 d8                	add    %ebx,%eax
  802df8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802dfb:	6a 00                	push   $0x0
  802dfd:	ff 75 ec             	pushl  -0x14(%ebp)
  802e00:	ff 75 08             	pushl  0x8(%ebp)
  802e03:	e8 ab f4 ff ff       	call   8022b3 <set_block_data>
  802e08:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802e0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e0f:	75 17                	jne    802e28 <merging+0xc8>
  802e11:	83 ec 04             	sub    $0x4,%esp
  802e14:	68 57 44 80 00       	push   $0x804457
  802e19:	68 7d 01 00 00       	push   $0x17d
  802e1e:	68 75 44 80 00       	push   $0x804475
  802e23:	e8 dc 0b 00 00       	call   803a04 <_panic>
  802e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e2b:	8b 00                	mov    (%eax),%eax
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	74 10                	je     802e41 <merging+0xe1>
  802e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e34:	8b 00                	mov    (%eax),%eax
  802e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e39:	8b 52 04             	mov    0x4(%edx),%edx
  802e3c:	89 50 04             	mov    %edx,0x4(%eax)
  802e3f:	eb 0b                	jmp    802e4c <merging+0xec>
  802e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e44:	8b 40 04             	mov    0x4(%eax),%eax
  802e47:	a3 30 50 80 00       	mov    %eax,0x805030
  802e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	85 c0                	test   %eax,%eax
  802e54:	74 0f                	je     802e65 <merging+0x105>
  802e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e59:	8b 40 04             	mov    0x4(%eax),%eax
  802e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e5f:	8b 12                	mov    (%edx),%edx
  802e61:	89 10                	mov    %edx,(%eax)
  802e63:	eb 0a                	jmp    802e6f <merging+0x10f>
  802e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e82:	a1 38 50 80 00       	mov    0x805038,%eax
  802e87:	48                   	dec    %eax
  802e88:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e8d:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e8e:	e9 ea 02 00 00       	jmp    80317d <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e97:	74 3b                	je     802ed4 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e99:	83 ec 0c             	sub    $0xc,%esp
  802e9c:	ff 75 08             	pushl  0x8(%ebp)
  802e9f:	e8 be f0 ff ff       	call   801f62 <get_block_size>
  802ea4:	83 c4 10             	add    $0x10,%esp
  802ea7:	89 c3                	mov    %eax,%ebx
  802ea9:	83 ec 0c             	sub    $0xc,%esp
  802eac:	ff 75 10             	pushl  0x10(%ebp)
  802eaf:	e8 ae f0 ff ff       	call   801f62 <get_block_size>
  802eb4:	83 c4 10             	add    $0x10,%esp
  802eb7:	01 d8                	add    %ebx,%eax
  802eb9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ebc:	83 ec 04             	sub    $0x4,%esp
  802ebf:	6a 00                	push   $0x0
  802ec1:	ff 75 e8             	pushl  -0x18(%ebp)
  802ec4:	ff 75 08             	pushl  0x8(%ebp)
  802ec7:	e8 e7 f3 ff ff       	call   8022b3 <set_block_data>
  802ecc:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ecf:	e9 a9 02 00 00       	jmp    80317d <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ed4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed8:	0f 84 2d 01 00 00    	je     80300b <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ede:	83 ec 0c             	sub    $0xc,%esp
  802ee1:	ff 75 10             	pushl  0x10(%ebp)
  802ee4:	e8 79 f0 ff ff       	call   801f62 <get_block_size>
  802ee9:	83 c4 10             	add    $0x10,%esp
  802eec:	89 c3                	mov    %eax,%ebx
  802eee:	83 ec 0c             	sub    $0xc,%esp
  802ef1:	ff 75 0c             	pushl  0xc(%ebp)
  802ef4:	e8 69 f0 ff ff       	call   801f62 <get_block_size>
  802ef9:	83 c4 10             	add    $0x10,%esp
  802efc:	01 d8                	add    %ebx,%eax
  802efe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802f01:	83 ec 04             	sub    $0x4,%esp
  802f04:	6a 00                	push   $0x0
  802f06:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f09:	ff 75 10             	pushl  0x10(%ebp)
  802f0c:	e8 a2 f3 ff ff       	call   8022b3 <set_block_data>
  802f11:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802f14:	8b 45 10             	mov    0x10(%ebp),%eax
  802f17:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802f1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f1e:	74 06                	je     802f26 <merging+0x1c6>
  802f20:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f24:	75 17                	jne    802f3d <merging+0x1dd>
  802f26:	83 ec 04             	sub    $0x4,%esp
  802f29:	68 1c 45 80 00       	push   $0x80451c
  802f2e:	68 8d 01 00 00       	push   $0x18d
  802f33:	68 75 44 80 00       	push   $0x804475
  802f38:	e8 c7 0a 00 00       	call   803a04 <_panic>
  802f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f40:	8b 50 04             	mov    0x4(%eax),%edx
  802f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f46:	89 50 04             	mov    %edx,0x4(%eax)
  802f49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f4f:	89 10                	mov    %edx,(%eax)
  802f51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f54:	8b 40 04             	mov    0x4(%eax),%eax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	74 0d                	je     802f68 <merging+0x208>
  802f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f64:	89 10                	mov    %edx,(%eax)
  802f66:	eb 08                	jmp    802f70 <merging+0x210>
  802f68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f6b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f73:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f76:	89 50 04             	mov    %edx,0x4(%eax)
  802f79:	a1 38 50 80 00       	mov    0x805038,%eax
  802f7e:	40                   	inc    %eax
  802f7f:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802f84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f88:	75 17                	jne    802fa1 <merging+0x241>
  802f8a:	83 ec 04             	sub    $0x4,%esp
  802f8d:	68 57 44 80 00       	push   $0x804457
  802f92:	68 8e 01 00 00       	push   $0x18e
  802f97:	68 75 44 80 00       	push   $0x804475
  802f9c:	e8 63 0a 00 00       	call   803a04 <_panic>
  802fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa4:	8b 00                	mov    (%eax),%eax
  802fa6:	85 c0                	test   %eax,%eax
  802fa8:	74 10                	je     802fba <merging+0x25a>
  802faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb2:	8b 52 04             	mov    0x4(%edx),%edx
  802fb5:	89 50 04             	mov    %edx,0x4(%eax)
  802fb8:	eb 0b                	jmp    802fc5 <merging+0x265>
  802fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbd:	8b 40 04             	mov    0x4(%eax),%eax
  802fc0:	a3 30 50 80 00       	mov    %eax,0x805030
  802fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc8:	8b 40 04             	mov    0x4(%eax),%eax
  802fcb:	85 c0                	test   %eax,%eax
  802fcd:	74 0f                	je     802fde <merging+0x27e>
  802fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd2:	8b 40 04             	mov    0x4(%eax),%eax
  802fd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd8:	8b 12                	mov    (%edx),%edx
  802fda:	89 10                	mov    %edx,(%eax)
  802fdc:	eb 0a                	jmp    802fe8 <merging+0x288>
  802fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe1:	8b 00                	mov    (%eax),%eax
  802fe3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802feb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffb:	a1 38 50 80 00       	mov    0x805038,%eax
  803000:	48                   	dec    %eax
  803001:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  803006:	e9 72 01 00 00       	jmp    80317d <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  80300b:	8b 45 10             	mov    0x10(%ebp),%eax
  80300e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  803011:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803015:	74 79                	je     803090 <merging+0x330>
  803017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80301b:	74 73                	je     803090 <merging+0x330>
  80301d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803021:	74 06                	je     803029 <merging+0x2c9>
  803023:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803027:	75 17                	jne    803040 <merging+0x2e0>
  803029:	83 ec 04             	sub    $0x4,%esp
  80302c:	68 e8 44 80 00       	push   $0x8044e8
  803031:	68 94 01 00 00       	push   $0x194
  803036:	68 75 44 80 00       	push   $0x804475
  80303b:	e8 c4 09 00 00       	call   803a04 <_panic>
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	8b 10                	mov    (%eax),%edx
  803045:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803048:	89 10                	mov    %edx,(%eax)
  80304a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304d:	8b 00                	mov    (%eax),%eax
  80304f:	85 c0                	test   %eax,%eax
  803051:	74 0b                	je     80305e <merging+0x2fe>
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80305b:	89 50 04             	mov    %edx,0x4(%eax)
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803064:	89 10                	mov    %edx,(%eax)
  803066:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803069:	8b 55 08             	mov    0x8(%ebp),%edx
  80306c:	89 50 04             	mov    %edx,0x4(%eax)
  80306f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	85 c0                	test   %eax,%eax
  803076:	75 08                	jne    803080 <merging+0x320>
  803078:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307b:	a3 30 50 80 00       	mov    %eax,0x805030
  803080:	a1 38 50 80 00       	mov    0x805038,%eax
  803085:	40                   	inc    %eax
  803086:	a3 38 50 80 00       	mov    %eax,0x805038
  80308b:	e9 ce 00 00 00       	jmp    80315e <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803090:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803094:	74 65                	je     8030fb <merging+0x39b>
  803096:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80309a:	75 17                	jne    8030b3 <merging+0x353>
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	68 c4 44 80 00       	push   $0x8044c4
  8030a4:	68 95 01 00 00       	push   $0x195
  8030a9:	68 75 44 80 00       	push   $0x804475
  8030ae:	e8 51 09 00 00       	call   803a04 <_panic>
  8030b3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8030b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bc:	89 50 04             	mov    %edx,0x4(%eax)
  8030bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c2:	8b 40 04             	mov    0x4(%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	74 0c                	je     8030d5 <merging+0x375>
  8030c9:	a1 30 50 80 00       	mov    0x805030,%eax
  8030ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030d1:	89 10                	mov    %edx,(%eax)
  8030d3:	eb 08                	jmp    8030dd <merging+0x37d>
  8030d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8030e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8030f3:	40                   	inc    %eax
  8030f4:	a3 38 50 80 00       	mov    %eax,0x805038
  8030f9:	eb 63                	jmp    80315e <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  8030fb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8030ff:	75 17                	jne    803118 <merging+0x3b8>
  803101:	83 ec 04             	sub    $0x4,%esp
  803104:	68 90 44 80 00       	push   $0x804490
  803109:	68 98 01 00 00       	push   $0x198
  80310e:	68 75 44 80 00       	push   $0x804475
  803113:	e8 ec 08 00 00       	call   803a04 <_panic>
  803118:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80311e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803121:	89 10                	mov    %edx,(%eax)
  803123:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	74 0d                	je     803139 <merging+0x3d9>
  80312c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803131:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803134:	89 50 04             	mov    %edx,0x4(%eax)
  803137:	eb 08                	jmp    803141 <merging+0x3e1>
  803139:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313c:	a3 30 50 80 00       	mov    %eax,0x805030
  803141:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803144:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803149:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80314c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803153:	a1 38 50 80 00       	mov    0x805038,%eax
  803158:	40                   	inc    %eax
  803159:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  80315e:	83 ec 0c             	sub    $0xc,%esp
  803161:	ff 75 10             	pushl  0x10(%ebp)
  803164:	e8 f9 ed ff ff       	call   801f62 <get_block_size>
  803169:	83 c4 10             	add    $0x10,%esp
  80316c:	83 ec 04             	sub    $0x4,%esp
  80316f:	6a 00                	push   $0x0
  803171:	50                   	push   %eax
  803172:	ff 75 10             	pushl  0x10(%ebp)
  803175:	e8 39 f1 ff ff       	call   8022b3 <set_block_data>
  80317a:	83 c4 10             	add    $0x10,%esp
	}
}
  80317d:	90                   	nop
  80317e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803181:	c9                   	leave  
  803182:	c3                   	ret    

00803183 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803183:	55                   	push   %ebp
  803184:	89 e5                	mov    %esp,%ebp
  803186:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803189:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80318e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803191:	a1 30 50 80 00       	mov    0x805030,%eax
  803196:	3b 45 08             	cmp    0x8(%ebp),%eax
  803199:	73 1b                	jae    8031b6 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80319b:	a1 30 50 80 00       	mov    0x805030,%eax
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	ff 75 08             	pushl  0x8(%ebp)
  8031a6:	6a 00                	push   $0x0
  8031a8:	50                   	push   %eax
  8031a9:	e8 b2 fb ff ff       	call   802d60 <merging>
  8031ae:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031b1:	e9 8b 00 00 00       	jmp    803241 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  8031b6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031be:	76 18                	jbe    8031d8 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  8031c0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031c5:	83 ec 04             	sub    $0x4,%esp
  8031c8:	ff 75 08             	pushl  0x8(%ebp)
  8031cb:	50                   	push   %eax
  8031cc:	6a 00                	push   $0x0
  8031ce:	e8 8d fb ff ff       	call   802d60 <merging>
  8031d3:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031d6:	eb 69                	jmp    803241 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8031d8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e0:	eb 39                	jmp    80321b <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8031e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e8:	73 29                	jae    803213 <free_block+0x90>
  8031ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ed:	8b 00                	mov    (%eax),%eax
  8031ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031f2:	76 1f                	jbe    803213 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8031f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8031fc:	83 ec 04             	sub    $0x4,%esp
  8031ff:	ff 75 08             	pushl  0x8(%ebp)
  803202:	ff 75 f0             	pushl  -0x10(%ebp)
  803205:	ff 75 f4             	pushl  -0xc(%ebp)
  803208:	e8 53 fb ff ff       	call   802d60 <merging>
  80320d:	83 c4 10             	add    $0x10,%esp
			break;
  803210:	90                   	nop
		}
	}
}
  803211:	eb 2e                	jmp    803241 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803213:	a1 34 50 80 00       	mov    0x805034,%eax
  803218:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80321f:	74 07                	je     803228 <free_block+0xa5>
  803221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	eb 05                	jmp    80322d <free_block+0xaa>
  803228:	b8 00 00 00 00       	mov    $0x0,%eax
  80322d:	a3 34 50 80 00       	mov    %eax,0x805034
  803232:	a1 34 50 80 00       	mov    0x805034,%eax
  803237:	85 c0                	test   %eax,%eax
  803239:	75 a7                	jne    8031e2 <free_block+0x5f>
  80323b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323f:	75 a1                	jne    8031e2 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803241:	90                   	nop
  803242:	c9                   	leave  
  803243:	c3                   	ret    

00803244 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803244:	55                   	push   %ebp
  803245:	89 e5                	mov    %esp,%ebp
  803247:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80324a:	ff 75 08             	pushl  0x8(%ebp)
  80324d:	e8 10 ed ff ff       	call   801f62 <get_block_size>
  803252:	83 c4 04             	add    $0x4,%esp
  803255:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80325f:	eb 17                	jmp    803278 <copy_data+0x34>
  803261:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803264:	8b 45 0c             	mov    0xc(%ebp),%eax
  803267:	01 c2                	add    %eax,%edx
  803269:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80326c:	8b 45 08             	mov    0x8(%ebp),%eax
  80326f:	01 c8                	add    %ecx,%eax
  803271:	8a 00                	mov    (%eax),%al
  803273:	88 02                	mov    %al,(%edx)
  803275:	ff 45 fc             	incl   -0x4(%ebp)
  803278:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80327b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80327e:	72 e1                	jb     803261 <copy_data+0x1d>
}
  803280:	90                   	nop
  803281:	c9                   	leave  
  803282:	c3                   	ret    

00803283 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803283:	55                   	push   %ebp
  803284:	89 e5                	mov    %esp,%ebp
  803286:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328d:	75 23                	jne    8032b2 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80328f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803293:	74 13                	je     8032a8 <realloc_block_FF+0x25>
  803295:	83 ec 0c             	sub    $0xc,%esp
  803298:	ff 75 0c             	pushl  0xc(%ebp)
  80329b:	e8 42 f0 ff ff       	call   8022e2 <alloc_block_FF>
  8032a0:	83 c4 10             	add    $0x10,%esp
  8032a3:	e9 e4 06 00 00       	jmp    80398c <realloc_block_FF+0x709>
		return NULL;
  8032a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ad:	e9 da 06 00 00       	jmp    80398c <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8032b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8032b6:	75 18                	jne    8032d0 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8032b8:	83 ec 0c             	sub    $0xc,%esp
  8032bb:	ff 75 08             	pushl  0x8(%ebp)
  8032be:	e8 c0 fe ff ff       	call   803183 <free_block>
  8032c3:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cb:	e9 bc 06 00 00       	jmp    80398c <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  8032d0:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032d4:	77 07                	ja     8032dd <realloc_block_FF+0x5a>
  8032d6:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8032dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e0:	83 e0 01             	and    $0x1,%eax
  8032e3:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8032e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e9:	83 c0 08             	add    $0x8,%eax
  8032ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8032ef:	83 ec 0c             	sub    $0xc,%esp
  8032f2:	ff 75 08             	pushl  0x8(%ebp)
  8032f5:	e8 68 ec ff ff       	call   801f62 <get_block_size>
  8032fa:	83 c4 10             	add    $0x10,%esp
  8032fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803300:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803303:	83 e8 08             	sub    $0x8,%eax
  803306:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	83 e8 04             	sub    $0x4,%eax
  80330f:	8b 00                	mov    (%eax),%eax
  803311:	83 e0 fe             	and    $0xfffffffe,%eax
  803314:	89 c2                	mov    %eax,%edx
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	01 d0                	add    %edx,%eax
  80331b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80331e:	83 ec 0c             	sub    $0xc,%esp
  803321:	ff 75 e4             	pushl  -0x1c(%ebp)
  803324:	e8 39 ec ff ff       	call   801f62 <get_block_size>
  803329:	83 c4 10             	add    $0x10,%esp
  80332c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80332f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803332:	83 e8 08             	sub    $0x8,%eax
  803335:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803338:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80333e:	75 08                	jne    803348 <realloc_block_FF+0xc5>
	{
		 return va;
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	e9 44 06 00 00       	jmp    80398c <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80334e:	0f 83 d5 03 00 00    	jae    803729 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803357:	2b 45 0c             	sub    0xc(%ebp),%eax
  80335a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80335d:	83 ec 0c             	sub    $0xc,%esp
  803360:	ff 75 e4             	pushl  -0x1c(%ebp)
  803363:	e8 13 ec ff ff       	call   801f7b <is_free_block>
  803368:	83 c4 10             	add    $0x10,%esp
  80336b:	84 c0                	test   %al,%al
  80336d:	0f 84 3b 01 00 00    	je     8034ae <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803373:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803376:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803379:	01 d0                	add    %edx,%eax
  80337b:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80337e:	83 ec 04             	sub    $0x4,%esp
  803381:	6a 01                	push   $0x1
  803383:	ff 75 f0             	pushl  -0x10(%ebp)
  803386:	ff 75 08             	pushl  0x8(%ebp)
  803389:	e8 25 ef ff ff       	call   8022b3 <set_block_data>
  80338e:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	83 e8 04             	sub    $0x4,%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	83 e0 fe             	and    $0xfffffffe,%eax
  80339c:	89 c2                	mov    %eax,%edx
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	01 d0                	add    %edx,%eax
  8033a3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8033a6:	83 ec 04             	sub    $0x4,%esp
  8033a9:	6a 00                	push   $0x0
  8033ab:	ff 75 cc             	pushl  -0x34(%ebp)
  8033ae:	ff 75 c8             	pushl  -0x38(%ebp)
  8033b1:	e8 fd ee ff ff       	call   8022b3 <set_block_data>
  8033b6:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8033b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033bd:	74 06                	je     8033c5 <realloc_block_FF+0x142>
  8033bf:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8033c3:	75 17                	jne    8033dc <realloc_block_FF+0x159>
  8033c5:	83 ec 04             	sub    $0x4,%esp
  8033c8:	68 e8 44 80 00       	push   $0x8044e8
  8033cd:	68 f6 01 00 00       	push   $0x1f6
  8033d2:	68 75 44 80 00       	push   $0x804475
  8033d7:	e8 28 06 00 00       	call   803a04 <_panic>
  8033dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033df:	8b 10                	mov    (%eax),%edx
  8033e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e4:	89 10                	mov    %edx,(%eax)
  8033e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8033e9:	8b 00                	mov    (%eax),%eax
  8033eb:	85 c0                	test   %eax,%eax
  8033ed:	74 0b                	je     8033fa <realloc_block_FF+0x177>
  8033ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8033f7:	89 50 04             	mov    %edx,0x4(%eax)
  8033fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fd:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803400:	89 10                	mov    %edx,(%eax)
  803402:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803405:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803408:	89 50 04             	mov    %edx,0x4(%eax)
  80340b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80340e:	8b 00                	mov    (%eax),%eax
  803410:	85 c0                	test   %eax,%eax
  803412:	75 08                	jne    80341c <realloc_block_FF+0x199>
  803414:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803417:	a3 30 50 80 00       	mov    %eax,0x805030
  80341c:	a1 38 50 80 00       	mov    0x805038,%eax
  803421:	40                   	inc    %eax
  803422:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803427:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80342b:	75 17                	jne    803444 <realloc_block_FF+0x1c1>
  80342d:	83 ec 04             	sub    $0x4,%esp
  803430:	68 57 44 80 00       	push   $0x804457
  803435:	68 f7 01 00 00       	push   $0x1f7
  80343a:	68 75 44 80 00       	push   $0x804475
  80343f:	e8 c0 05 00 00       	call   803a04 <_panic>
  803444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803447:	8b 00                	mov    (%eax),%eax
  803449:	85 c0                	test   %eax,%eax
  80344b:	74 10                	je     80345d <realloc_block_FF+0x1da>
  80344d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803450:	8b 00                	mov    (%eax),%eax
  803452:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803455:	8b 52 04             	mov    0x4(%edx),%edx
  803458:	89 50 04             	mov    %edx,0x4(%eax)
  80345b:	eb 0b                	jmp    803468 <realloc_block_FF+0x1e5>
  80345d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803460:	8b 40 04             	mov    0x4(%eax),%eax
  803463:	a3 30 50 80 00       	mov    %eax,0x805030
  803468:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346b:	8b 40 04             	mov    0x4(%eax),%eax
  80346e:	85 c0                	test   %eax,%eax
  803470:	74 0f                	je     803481 <realloc_block_FF+0x1fe>
  803472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803475:	8b 40 04             	mov    0x4(%eax),%eax
  803478:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80347b:	8b 12                	mov    (%edx),%edx
  80347d:	89 10                	mov    %edx,(%eax)
  80347f:	eb 0a                	jmp    80348b <realloc_block_FF+0x208>
  803481:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803484:	8b 00                	mov    (%eax),%eax
  803486:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80348b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803497:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349e:	a1 38 50 80 00       	mov    0x805038,%eax
  8034a3:	48                   	dec    %eax
  8034a4:	a3 38 50 80 00       	mov    %eax,0x805038
  8034a9:	e9 73 02 00 00       	jmp    803721 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8034ae:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8034b2:	0f 86 69 02 00 00    	jbe    803721 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8034b8:	83 ec 04             	sub    $0x4,%esp
  8034bb:	6a 01                	push   $0x1
  8034bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8034c0:	ff 75 08             	pushl  0x8(%ebp)
  8034c3:	e8 eb ed ff ff       	call   8022b3 <set_block_data>
  8034c8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ce:	83 e8 04             	sub    $0x4,%eax
  8034d1:	8b 00                	mov    (%eax),%eax
  8034d3:	83 e0 fe             	and    $0xfffffffe,%eax
  8034d6:	89 c2                	mov    %eax,%edx
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	01 d0                	add    %edx,%eax
  8034dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8034e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8034e8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034ec:	75 68                	jne    803556 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034ee:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034f2:	75 17                	jne    80350b <realloc_block_FF+0x288>
  8034f4:	83 ec 04             	sub    $0x4,%esp
  8034f7:	68 90 44 80 00       	push   $0x804490
  8034fc:	68 06 02 00 00       	push   $0x206
  803501:	68 75 44 80 00       	push   $0x804475
  803506:	e8 f9 04 00 00       	call   803a04 <_panic>
  80350b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803511:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803514:	89 10                	mov    %edx,(%eax)
  803516:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803519:	8b 00                	mov    (%eax),%eax
  80351b:	85 c0                	test   %eax,%eax
  80351d:	74 0d                	je     80352c <realloc_block_FF+0x2a9>
  80351f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803524:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803527:	89 50 04             	mov    %edx,0x4(%eax)
  80352a:	eb 08                	jmp    803534 <realloc_block_FF+0x2b1>
  80352c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80352f:	a3 30 50 80 00       	mov    %eax,0x805030
  803534:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803537:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80353c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80353f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803546:	a1 38 50 80 00       	mov    0x805038,%eax
  80354b:	40                   	inc    %eax
  80354c:	a3 38 50 80 00       	mov    %eax,0x805038
  803551:	e9 b0 01 00 00       	jmp    803706 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803556:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80355b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80355e:	76 68                	jbe    8035c8 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803560:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803564:	75 17                	jne    80357d <realloc_block_FF+0x2fa>
  803566:	83 ec 04             	sub    $0x4,%esp
  803569:	68 90 44 80 00       	push   $0x804490
  80356e:	68 0b 02 00 00       	push   $0x20b
  803573:	68 75 44 80 00       	push   $0x804475
  803578:	e8 87 04 00 00       	call   803a04 <_panic>
  80357d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803583:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803586:	89 10                	mov    %edx,(%eax)
  803588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358b:	8b 00                	mov    (%eax),%eax
  80358d:	85 c0                	test   %eax,%eax
  80358f:	74 0d                	je     80359e <realloc_block_FF+0x31b>
  803591:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803596:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803599:	89 50 04             	mov    %edx,0x4(%eax)
  80359c:	eb 08                	jmp    8035a6 <realloc_block_FF+0x323>
  80359e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035a9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b8:	a1 38 50 80 00       	mov    0x805038,%eax
  8035bd:	40                   	inc    %eax
  8035be:	a3 38 50 80 00       	mov    %eax,0x805038
  8035c3:	e9 3e 01 00 00       	jmp    803706 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8035c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035cd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035d0:	73 68                	jae    80363a <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8035d2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035d6:	75 17                	jne    8035ef <realloc_block_FF+0x36c>
  8035d8:	83 ec 04             	sub    $0x4,%esp
  8035db:	68 c4 44 80 00       	push   $0x8044c4
  8035e0:	68 10 02 00 00       	push   $0x210
  8035e5:	68 75 44 80 00       	push   $0x804475
  8035ea:	e8 15 04 00 00       	call   803a04 <_panic>
  8035ef:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8035f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f8:	89 50 04             	mov    %edx,0x4(%eax)
  8035fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035fe:	8b 40 04             	mov    0x4(%eax),%eax
  803601:	85 c0                	test   %eax,%eax
  803603:	74 0c                	je     803611 <realloc_block_FF+0x38e>
  803605:	a1 30 50 80 00       	mov    0x805030,%eax
  80360a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80360d:	89 10                	mov    %edx,(%eax)
  80360f:	eb 08                	jmp    803619 <realloc_block_FF+0x396>
  803611:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803614:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803619:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80361c:	a3 30 50 80 00       	mov    %eax,0x805030
  803621:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803624:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362a:	a1 38 50 80 00       	mov    0x805038,%eax
  80362f:	40                   	inc    %eax
  803630:	a3 38 50 80 00       	mov    %eax,0x805038
  803635:	e9 cc 00 00 00       	jmp    803706 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80363a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803641:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803649:	e9 8a 00 00 00       	jmp    8036d8 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80364e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803651:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803654:	73 7a                	jae    8036d0 <realloc_block_FF+0x44d>
  803656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803659:	8b 00                	mov    (%eax),%eax
  80365b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80365e:	73 70                	jae    8036d0 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803664:	74 06                	je     80366c <realloc_block_FF+0x3e9>
  803666:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80366a:	75 17                	jne    803683 <realloc_block_FF+0x400>
  80366c:	83 ec 04             	sub    $0x4,%esp
  80366f:	68 e8 44 80 00       	push   $0x8044e8
  803674:	68 1a 02 00 00       	push   $0x21a
  803679:	68 75 44 80 00       	push   $0x804475
  80367e:	e8 81 03 00 00       	call   803a04 <_panic>
  803683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803686:	8b 10                	mov    (%eax),%edx
  803688:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368b:	89 10                	mov    %edx,(%eax)
  80368d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803690:	8b 00                	mov    (%eax),%eax
  803692:	85 c0                	test   %eax,%eax
  803694:	74 0b                	je     8036a1 <realloc_block_FF+0x41e>
  803696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803699:	8b 00                	mov    (%eax),%eax
  80369b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80369e:	89 50 04             	mov    %edx,0x4(%eax)
  8036a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a7:	89 10                	mov    %edx,(%eax)
  8036a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036af:	89 50 04             	mov    %edx,0x4(%eax)
  8036b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b5:	8b 00                	mov    (%eax),%eax
  8036b7:	85 c0                	test   %eax,%eax
  8036b9:	75 08                	jne    8036c3 <realloc_block_FF+0x440>
  8036bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036be:	a3 30 50 80 00       	mov    %eax,0x805030
  8036c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8036c8:	40                   	inc    %eax
  8036c9:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8036ce:	eb 36                	jmp    803706 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8036d0:	a1 34 50 80 00       	mov    0x805034,%eax
  8036d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036dc:	74 07                	je     8036e5 <realloc_block_FF+0x462>
  8036de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e1:	8b 00                	mov    (%eax),%eax
  8036e3:	eb 05                	jmp    8036ea <realloc_block_FF+0x467>
  8036e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8036ea:	a3 34 50 80 00       	mov    %eax,0x805034
  8036ef:	a1 34 50 80 00       	mov    0x805034,%eax
  8036f4:	85 c0                	test   %eax,%eax
  8036f6:	0f 85 52 ff ff ff    	jne    80364e <realloc_block_FF+0x3cb>
  8036fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803700:	0f 85 48 ff ff ff    	jne    80364e <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803706:	83 ec 04             	sub    $0x4,%esp
  803709:	6a 00                	push   $0x0
  80370b:	ff 75 d8             	pushl  -0x28(%ebp)
  80370e:	ff 75 d4             	pushl  -0x2c(%ebp)
  803711:	e8 9d eb ff ff       	call   8022b3 <set_block_data>
  803716:	83 c4 10             	add    $0x10,%esp
				return va;
  803719:	8b 45 08             	mov    0x8(%ebp),%eax
  80371c:	e9 6b 02 00 00       	jmp    80398c <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803721:	8b 45 08             	mov    0x8(%ebp),%eax
  803724:	e9 63 02 00 00       	jmp    80398c <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80372c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80372f:	0f 86 4d 02 00 00    	jbe    803982 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803735:	83 ec 0c             	sub    $0xc,%esp
  803738:	ff 75 e4             	pushl  -0x1c(%ebp)
  80373b:	e8 3b e8 ff ff       	call   801f7b <is_free_block>
  803740:	83 c4 10             	add    $0x10,%esp
  803743:	84 c0                	test   %al,%al
  803745:	0f 84 37 02 00 00    	je     803982 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80374b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803751:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803754:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803757:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80375a:	76 38                	jbe    803794 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80375c:	83 ec 0c             	sub    $0xc,%esp
  80375f:	ff 75 0c             	pushl  0xc(%ebp)
  803762:	e8 7b eb ff ff       	call   8022e2 <alloc_block_FF>
  803767:	83 c4 10             	add    $0x10,%esp
  80376a:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80376d:	83 ec 08             	sub    $0x8,%esp
  803770:	ff 75 c0             	pushl  -0x40(%ebp)
  803773:	ff 75 08             	pushl  0x8(%ebp)
  803776:	e8 c9 fa ff ff       	call   803244 <copy_data>
  80377b:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80377e:	83 ec 0c             	sub    $0xc,%esp
  803781:	ff 75 08             	pushl  0x8(%ebp)
  803784:	e8 fa f9 ff ff       	call   803183 <free_block>
  803789:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80378c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80378f:	e9 f8 01 00 00       	jmp    80398c <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803794:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803797:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80379a:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80379d:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8037a1:	0f 87 a0 00 00 00    	ja     803847 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8037a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037ab:	75 17                	jne    8037c4 <realloc_block_FF+0x541>
  8037ad:	83 ec 04             	sub    $0x4,%esp
  8037b0:	68 57 44 80 00       	push   $0x804457
  8037b5:	68 38 02 00 00       	push   $0x238
  8037ba:	68 75 44 80 00       	push   $0x804475
  8037bf:	e8 40 02 00 00       	call   803a04 <_panic>
  8037c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c7:	8b 00                	mov    (%eax),%eax
  8037c9:	85 c0                	test   %eax,%eax
  8037cb:	74 10                	je     8037dd <realloc_block_FF+0x55a>
  8037cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037d5:	8b 52 04             	mov    0x4(%edx),%edx
  8037d8:	89 50 04             	mov    %edx,0x4(%eax)
  8037db:	eb 0b                	jmp    8037e8 <realloc_block_FF+0x565>
  8037dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e0:	8b 40 04             	mov    0x4(%eax),%eax
  8037e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8037e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037eb:	8b 40 04             	mov    0x4(%eax),%eax
  8037ee:	85 c0                	test   %eax,%eax
  8037f0:	74 0f                	je     803801 <realloc_block_FF+0x57e>
  8037f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f5:	8b 40 04             	mov    0x4(%eax),%eax
  8037f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037fb:	8b 12                	mov    (%edx),%edx
  8037fd:	89 10                	mov    %edx,(%eax)
  8037ff:	eb 0a                	jmp    80380b <realloc_block_FF+0x588>
  803801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803804:	8b 00                	mov    (%eax),%eax
  803806:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80380b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803814:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803817:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80381e:	a1 38 50 80 00       	mov    0x805038,%eax
  803823:	48                   	dec    %eax
  803824:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803829:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80382c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80382f:	01 d0                	add    %edx,%eax
  803831:	83 ec 04             	sub    $0x4,%esp
  803834:	6a 01                	push   $0x1
  803836:	50                   	push   %eax
  803837:	ff 75 08             	pushl  0x8(%ebp)
  80383a:	e8 74 ea ff ff       	call   8022b3 <set_block_data>
  80383f:	83 c4 10             	add    $0x10,%esp
  803842:	e9 36 01 00 00       	jmp    80397d <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803847:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80384a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80384d:	01 d0                	add    %edx,%eax
  80384f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803852:	83 ec 04             	sub    $0x4,%esp
  803855:	6a 01                	push   $0x1
  803857:	ff 75 f0             	pushl  -0x10(%ebp)
  80385a:	ff 75 08             	pushl  0x8(%ebp)
  80385d:	e8 51 ea ff ff       	call   8022b3 <set_block_data>
  803862:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803865:	8b 45 08             	mov    0x8(%ebp),%eax
  803868:	83 e8 04             	sub    $0x4,%eax
  80386b:	8b 00                	mov    (%eax),%eax
  80386d:	83 e0 fe             	and    $0xfffffffe,%eax
  803870:	89 c2                	mov    %eax,%edx
  803872:	8b 45 08             	mov    0x8(%ebp),%eax
  803875:	01 d0                	add    %edx,%eax
  803877:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80387a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80387e:	74 06                	je     803886 <realloc_block_FF+0x603>
  803880:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803884:	75 17                	jne    80389d <realloc_block_FF+0x61a>
  803886:	83 ec 04             	sub    $0x4,%esp
  803889:	68 e8 44 80 00       	push   $0x8044e8
  80388e:	68 44 02 00 00       	push   $0x244
  803893:	68 75 44 80 00       	push   $0x804475
  803898:	e8 67 01 00 00       	call   803a04 <_panic>
  80389d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a0:	8b 10                	mov    (%eax),%edx
  8038a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038a5:	89 10                	mov    %edx,(%eax)
  8038a7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038aa:	8b 00                	mov    (%eax),%eax
  8038ac:	85 c0                	test   %eax,%eax
  8038ae:	74 0b                	je     8038bb <realloc_block_FF+0x638>
  8038b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b3:	8b 00                	mov    (%eax),%eax
  8038b5:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038b8:	89 50 04             	mov    %edx,0x4(%eax)
  8038bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038be:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8038c1:	89 10                	mov    %edx,(%eax)
  8038c3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c9:	89 50 04             	mov    %edx,0x4(%eax)
  8038cc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038cf:	8b 00                	mov    (%eax),%eax
  8038d1:	85 c0                	test   %eax,%eax
  8038d3:	75 08                	jne    8038dd <realloc_block_FF+0x65a>
  8038d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8038d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8038dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8038e2:	40                   	inc    %eax
  8038e3:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8038e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038ec:	75 17                	jne    803905 <realloc_block_FF+0x682>
  8038ee:	83 ec 04             	sub    $0x4,%esp
  8038f1:	68 57 44 80 00       	push   $0x804457
  8038f6:	68 45 02 00 00       	push   $0x245
  8038fb:	68 75 44 80 00       	push   $0x804475
  803900:	e8 ff 00 00 00       	call   803a04 <_panic>
  803905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803908:	8b 00                	mov    (%eax),%eax
  80390a:	85 c0                	test   %eax,%eax
  80390c:	74 10                	je     80391e <realloc_block_FF+0x69b>
  80390e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803911:	8b 00                	mov    (%eax),%eax
  803913:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803916:	8b 52 04             	mov    0x4(%edx),%edx
  803919:	89 50 04             	mov    %edx,0x4(%eax)
  80391c:	eb 0b                	jmp    803929 <realloc_block_FF+0x6a6>
  80391e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803921:	8b 40 04             	mov    0x4(%eax),%eax
  803924:	a3 30 50 80 00       	mov    %eax,0x805030
  803929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80392c:	8b 40 04             	mov    0x4(%eax),%eax
  80392f:	85 c0                	test   %eax,%eax
  803931:	74 0f                	je     803942 <realloc_block_FF+0x6bf>
  803933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803936:	8b 40 04             	mov    0x4(%eax),%eax
  803939:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80393c:	8b 12                	mov    (%edx),%edx
  80393e:	89 10                	mov    %edx,(%eax)
  803940:	eb 0a                	jmp    80394c <realloc_block_FF+0x6c9>
  803942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803945:	8b 00                	mov    (%eax),%eax
  803947:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80394c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803958:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80395f:	a1 38 50 80 00       	mov    0x805038,%eax
  803964:	48                   	dec    %eax
  803965:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80396a:	83 ec 04             	sub    $0x4,%esp
  80396d:	6a 00                	push   $0x0
  80396f:	ff 75 bc             	pushl  -0x44(%ebp)
  803972:	ff 75 b8             	pushl  -0x48(%ebp)
  803975:	e8 39 e9 ff ff       	call   8022b3 <set_block_data>
  80397a:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80397d:	8b 45 08             	mov    0x8(%ebp),%eax
  803980:	eb 0a                	jmp    80398c <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803982:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803989:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80398c:	c9                   	leave  
  80398d:	c3                   	ret    

0080398e <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80398e:	55                   	push   %ebp
  80398f:	89 e5                	mov    %esp,%ebp
  803991:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803994:	83 ec 04             	sub    $0x4,%esp
  803997:	68 54 45 80 00       	push   $0x804554
  80399c:	68 58 02 00 00       	push   $0x258
  8039a1:	68 75 44 80 00       	push   $0x804475
  8039a6:	e8 59 00 00 00       	call   803a04 <_panic>

008039ab <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8039ab:	55                   	push   %ebp
  8039ac:	89 e5                	mov    %esp,%ebp
  8039ae:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8039b1:	83 ec 04             	sub    $0x4,%esp
  8039b4:	68 7c 45 80 00       	push   $0x80457c
  8039b9:	68 61 02 00 00       	push   $0x261
  8039be:	68 75 44 80 00       	push   $0x804475
  8039c3:	e8 3c 00 00 00       	call   803a04 <_panic>

008039c8 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8039c8:	55                   	push   %ebp
  8039c9:	89 e5                	mov    %esp,%ebp
  8039cb:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8039ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8039d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8039d8:	83 ec 0c             	sub    $0xc,%esp
  8039db:	50                   	push   %eax
  8039dc:	e8 74 e0 ff ff       	call   801a55 <sys_cputc>
  8039e1:	83 c4 10             	add    $0x10,%esp
}
  8039e4:	90                   	nop
  8039e5:	c9                   	leave  
  8039e6:	c3                   	ret    

008039e7 <getchar>:


int
getchar(void)
{
  8039e7:	55                   	push   %ebp
  8039e8:	89 e5                	mov    %esp,%ebp
  8039ea:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8039ed:	e8 ff de ff ff       	call   8018f1 <sys_cgetc>
  8039f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8039f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8039f8:	c9                   	leave  
  8039f9:	c3                   	ret    

008039fa <iscons>:

int iscons(int fdnum)
{
  8039fa:	55                   	push   %ebp
  8039fb:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8039fd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803a02:	5d                   	pop    %ebp
  803a03:	c3                   	ret    

00803a04 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803a04:	55                   	push   %ebp
  803a05:	89 e5                	mov    %esp,%ebp
  803a07:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803a0a:	8d 45 10             	lea    0x10(%ebp),%eax
  803a0d:	83 c0 04             	add    $0x4,%eax
  803a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803a13:	a1 60 50 98 00       	mov    0x985060,%eax
  803a18:	85 c0                	test   %eax,%eax
  803a1a:	74 16                	je     803a32 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803a1c:	a1 60 50 98 00       	mov    0x985060,%eax
  803a21:	83 ec 08             	sub    $0x8,%esp
  803a24:	50                   	push   %eax
  803a25:	68 a4 45 80 00       	push   $0x8045a4
  803a2a:	e8 99 c9 ff ff       	call   8003c8 <cprintf>
  803a2f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803a32:	a1 00 50 80 00       	mov    0x805000,%eax
  803a37:	ff 75 0c             	pushl  0xc(%ebp)
  803a3a:	ff 75 08             	pushl  0x8(%ebp)
  803a3d:	50                   	push   %eax
  803a3e:	68 a9 45 80 00       	push   $0x8045a9
  803a43:	e8 80 c9 ff ff       	call   8003c8 <cprintf>
  803a48:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a4b:	8b 45 10             	mov    0x10(%ebp),%eax
  803a4e:	83 ec 08             	sub    $0x8,%esp
  803a51:	ff 75 f4             	pushl  -0xc(%ebp)
  803a54:	50                   	push   %eax
  803a55:	e8 03 c9 ff ff       	call   80035d <vcprintf>
  803a5a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a5d:	83 ec 08             	sub    $0x8,%esp
  803a60:	6a 00                	push   $0x0
  803a62:	68 c5 45 80 00       	push   $0x8045c5
  803a67:	e8 f1 c8 ff ff       	call   80035d <vcprintf>
  803a6c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a6f:	e8 72 c8 ff ff       	call   8002e6 <exit>

	// should not return here
	while (1) ;
  803a74:	eb fe                	jmp    803a74 <_panic+0x70>

00803a76 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a76:	55                   	push   %ebp
  803a77:	89 e5                	mov    %esp,%ebp
  803a79:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a7c:	a1 20 50 80 00       	mov    0x805020,%eax
  803a81:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a8a:	39 c2                	cmp    %eax,%edx
  803a8c:	74 14                	je     803aa2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a8e:	83 ec 04             	sub    $0x4,%esp
  803a91:	68 c8 45 80 00       	push   $0x8045c8
  803a96:	6a 26                	push   $0x26
  803a98:	68 14 46 80 00       	push   $0x804614
  803a9d:	e8 62 ff ff ff       	call   803a04 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803aa2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803aa9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803ab0:	e9 c5 00 00 00       	jmp    803b7a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803abf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac2:	01 d0                	add    %edx,%eax
  803ac4:	8b 00                	mov    (%eax),%eax
  803ac6:	85 c0                	test   %eax,%eax
  803ac8:	75 08                	jne    803ad2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803aca:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803acd:	e9 a5 00 00 00       	jmp    803b77 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803ad2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ad9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803ae0:	eb 69                	jmp    803b4b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803ae2:	a1 20 50 80 00       	mov    0x805020,%eax
  803ae7:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803aed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803af0:	89 d0                	mov    %edx,%eax
  803af2:	01 c0                	add    %eax,%eax
  803af4:	01 d0                	add    %edx,%eax
  803af6:	c1 e0 03             	shl    $0x3,%eax
  803af9:	01 c8                	add    %ecx,%eax
  803afb:	8a 40 04             	mov    0x4(%eax),%al
  803afe:	84 c0                	test   %al,%al
  803b00:	75 46                	jne    803b48 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b02:	a1 20 50 80 00       	mov    0x805020,%eax
  803b07:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b10:	89 d0                	mov    %edx,%eax
  803b12:	01 c0                	add    %eax,%eax
  803b14:	01 d0                	add    %edx,%eax
  803b16:	c1 e0 03             	shl    $0x3,%eax
  803b19:	01 c8                	add    %ecx,%eax
  803b1b:	8b 00                	mov    (%eax),%eax
  803b1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803b20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803b28:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b2d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803b34:	8b 45 08             	mov    0x8(%ebp),%eax
  803b37:	01 c8                	add    %ecx,%eax
  803b39:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803b3b:	39 c2                	cmp    %eax,%edx
  803b3d:	75 09                	jne    803b48 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803b3f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803b46:	eb 15                	jmp    803b5d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b48:	ff 45 e8             	incl   -0x18(%ebp)
  803b4b:	a1 20 50 80 00       	mov    0x805020,%eax
  803b50:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b59:	39 c2                	cmp    %eax,%edx
  803b5b:	77 85                	ja     803ae2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b61:	75 14                	jne    803b77 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b63:	83 ec 04             	sub    $0x4,%esp
  803b66:	68 20 46 80 00       	push   $0x804620
  803b6b:	6a 3a                	push   $0x3a
  803b6d:	68 14 46 80 00       	push   $0x804614
  803b72:	e8 8d fe ff ff       	call   803a04 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b77:	ff 45 f0             	incl   -0x10(%ebp)
  803b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b7d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b80:	0f 8c 2f ff ff ff    	jl     803ab5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b8d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b94:	eb 26                	jmp    803bbc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b96:	a1 20 50 80 00       	mov    0x805020,%eax
  803b9b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ba1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ba4:	89 d0                	mov    %edx,%eax
  803ba6:	01 c0                	add    %eax,%eax
  803ba8:	01 d0                	add    %edx,%eax
  803baa:	c1 e0 03             	shl    $0x3,%eax
  803bad:	01 c8                	add    %ecx,%eax
  803baf:	8a 40 04             	mov    0x4(%eax),%al
  803bb2:	3c 01                	cmp    $0x1,%al
  803bb4:	75 03                	jne    803bb9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803bb6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803bb9:	ff 45 e0             	incl   -0x20(%ebp)
  803bbc:	a1 20 50 80 00       	mov    0x805020,%eax
  803bc1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803bc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bca:	39 c2                	cmp    %eax,%edx
  803bcc:	77 c8                	ja     803b96 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803bd4:	74 14                	je     803bea <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803bd6:	83 ec 04             	sub    $0x4,%esp
  803bd9:	68 74 46 80 00       	push   $0x804674
  803bde:	6a 44                	push   $0x44
  803be0:	68 14 46 80 00       	push   $0x804614
  803be5:	e8 1a fe ff ff       	call   803a04 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803bea:	90                   	nop
  803beb:	c9                   	leave  
  803bec:	c3                   	ret    
  803bed:	66 90                	xchg   %ax,%ax
  803bef:	90                   	nop

00803bf0 <__udivdi3>:
  803bf0:	55                   	push   %ebp
  803bf1:	57                   	push   %edi
  803bf2:	56                   	push   %esi
  803bf3:	53                   	push   %ebx
  803bf4:	83 ec 1c             	sub    $0x1c,%esp
  803bf7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803bfb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c07:	89 ca                	mov    %ecx,%edx
  803c09:	89 f8                	mov    %edi,%eax
  803c0b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c0f:	85 f6                	test   %esi,%esi
  803c11:	75 2d                	jne    803c40 <__udivdi3+0x50>
  803c13:	39 cf                	cmp    %ecx,%edi
  803c15:	77 65                	ja     803c7c <__udivdi3+0x8c>
  803c17:	89 fd                	mov    %edi,%ebp
  803c19:	85 ff                	test   %edi,%edi
  803c1b:	75 0b                	jne    803c28 <__udivdi3+0x38>
  803c1d:	b8 01 00 00 00       	mov    $0x1,%eax
  803c22:	31 d2                	xor    %edx,%edx
  803c24:	f7 f7                	div    %edi
  803c26:	89 c5                	mov    %eax,%ebp
  803c28:	31 d2                	xor    %edx,%edx
  803c2a:	89 c8                	mov    %ecx,%eax
  803c2c:	f7 f5                	div    %ebp
  803c2e:	89 c1                	mov    %eax,%ecx
  803c30:	89 d8                	mov    %ebx,%eax
  803c32:	f7 f5                	div    %ebp
  803c34:	89 cf                	mov    %ecx,%edi
  803c36:	89 fa                	mov    %edi,%edx
  803c38:	83 c4 1c             	add    $0x1c,%esp
  803c3b:	5b                   	pop    %ebx
  803c3c:	5e                   	pop    %esi
  803c3d:	5f                   	pop    %edi
  803c3e:	5d                   	pop    %ebp
  803c3f:	c3                   	ret    
  803c40:	39 ce                	cmp    %ecx,%esi
  803c42:	77 28                	ja     803c6c <__udivdi3+0x7c>
  803c44:	0f bd fe             	bsr    %esi,%edi
  803c47:	83 f7 1f             	xor    $0x1f,%edi
  803c4a:	75 40                	jne    803c8c <__udivdi3+0x9c>
  803c4c:	39 ce                	cmp    %ecx,%esi
  803c4e:	72 0a                	jb     803c5a <__udivdi3+0x6a>
  803c50:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c54:	0f 87 9e 00 00 00    	ja     803cf8 <__udivdi3+0x108>
  803c5a:	b8 01 00 00 00       	mov    $0x1,%eax
  803c5f:	89 fa                	mov    %edi,%edx
  803c61:	83 c4 1c             	add    $0x1c,%esp
  803c64:	5b                   	pop    %ebx
  803c65:	5e                   	pop    %esi
  803c66:	5f                   	pop    %edi
  803c67:	5d                   	pop    %ebp
  803c68:	c3                   	ret    
  803c69:	8d 76 00             	lea    0x0(%esi),%esi
  803c6c:	31 ff                	xor    %edi,%edi
  803c6e:	31 c0                	xor    %eax,%eax
  803c70:	89 fa                	mov    %edi,%edx
  803c72:	83 c4 1c             	add    $0x1c,%esp
  803c75:	5b                   	pop    %ebx
  803c76:	5e                   	pop    %esi
  803c77:	5f                   	pop    %edi
  803c78:	5d                   	pop    %ebp
  803c79:	c3                   	ret    
  803c7a:	66 90                	xchg   %ax,%ax
  803c7c:	89 d8                	mov    %ebx,%eax
  803c7e:	f7 f7                	div    %edi
  803c80:	31 ff                	xor    %edi,%edi
  803c82:	89 fa                	mov    %edi,%edx
  803c84:	83 c4 1c             	add    $0x1c,%esp
  803c87:	5b                   	pop    %ebx
  803c88:	5e                   	pop    %esi
  803c89:	5f                   	pop    %edi
  803c8a:	5d                   	pop    %ebp
  803c8b:	c3                   	ret    
  803c8c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c91:	89 eb                	mov    %ebp,%ebx
  803c93:	29 fb                	sub    %edi,%ebx
  803c95:	89 f9                	mov    %edi,%ecx
  803c97:	d3 e6                	shl    %cl,%esi
  803c99:	89 c5                	mov    %eax,%ebp
  803c9b:	88 d9                	mov    %bl,%cl
  803c9d:	d3 ed                	shr    %cl,%ebp
  803c9f:	89 e9                	mov    %ebp,%ecx
  803ca1:	09 f1                	or     %esi,%ecx
  803ca3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ca7:	89 f9                	mov    %edi,%ecx
  803ca9:	d3 e0                	shl    %cl,%eax
  803cab:	89 c5                	mov    %eax,%ebp
  803cad:	89 d6                	mov    %edx,%esi
  803caf:	88 d9                	mov    %bl,%cl
  803cb1:	d3 ee                	shr    %cl,%esi
  803cb3:	89 f9                	mov    %edi,%ecx
  803cb5:	d3 e2                	shl    %cl,%edx
  803cb7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cbb:	88 d9                	mov    %bl,%cl
  803cbd:	d3 e8                	shr    %cl,%eax
  803cbf:	09 c2                	or     %eax,%edx
  803cc1:	89 d0                	mov    %edx,%eax
  803cc3:	89 f2                	mov    %esi,%edx
  803cc5:	f7 74 24 0c          	divl   0xc(%esp)
  803cc9:	89 d6                	mov    %edx,%esi
  803ccb:	89 c3                	mov    %eax,%ebx
  803ccd:	f7 e5                	mul    %ebp
  803ccf:	39 d6                	cmp    %edx,%esi
  803cd1:	72 19                	jb     803cec <__udivdi3+0xfc>
  803cd3:	74 0b                	je     803ce0 <__udivdi3+0xf0>
  803cd5:	89 d8                	mov    %ebx,%eax
  803cd7:	31 ff                	xor    %edi,%edi
  803cd9:	e9 58 ff ff ff       	jmp    803c36 <__udivdi3+0x46>
  803cde:	66 90                	xchg   %ax,%ax
  803ce0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ce4:	89 f9                	mov    %edi,%ecx
  803ce6:	d3 e2                	shl    %cl,%edx
  803ce8:	39 c2                	cmp    %eax,%edx
  803cea:	73 e9                	jae    803cd5 <__udivdi3+0xe5>
  803cec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803cef:	31 ff                	xor    %edi,%edi
  803cf1:	e9 40 ff ff ff       	jmp    803c36 <__udivdi3+0x46>
  803cf6:	66 90                	xchg   %ax,%ax
  803cf8:	31 c0                	xor    %eax,%eax
  803cfa:	e9 37 ff ff ff       	jmp    803c36 <__udivdi3+0x46>
  803cff:	90                   	nop

00803d00 <__umoddi3>:
  803d00:	55                   	push   %ebp
  803d01:	57                   	push   %edi
  803d02:	56                   	push   %esi
  803d03:	53                   	push   %ebx
  803d04:	83 ec 1c             	sub    $0x1c,%esp
  803d07:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d0b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d13:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803d17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d1b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803d1f:	89 f3                	mov    %esi,%ebx
  803d21:	89 fa                	mov    %edi,%edx
  803d23:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d27:	89 34 24             	mov    %esi,(%esp)
  803d2a:	85 c0                	test   %eax,%eax
  803d2c:	75 1a                	jne    803d48 <__umoddi3+0x48>
  803d2e:	39 f7                	cmp    %esi,%edi
  803d30:	0f 86 a2 00 00 00    	jbe    803dd8 <__umoddi3+0xd8>
  803d36:	89 c8                	mov    %ecx,%eax
  803d38:	89 f2                	mov    %esi,%edx
  803d3a:	f7 f7                	div    %edi
  803d3c:	89 d0                	mov    %edx,%eax
  803d3e:	31 d2                	xor    %edx,%edx
  803d40:	83 c4 1c             	add    $0x1c,%esp
  803d43:	5b                   	pop    %ebx
  803d44:	5e                   	pop    %esi
  803d45:	5f                   	pop    %edi
  803d46:	5d                   	pop    %ebp
  803d47:	c3                   	ret    
  803d48:	39 f0                	cmp    %esi,%eax
  803d4a:	0f 87 ac 00 00 00    	ja     803dfc <__umoddi3+0xfc>
  803d50:	0f bd e8             	bsr    %eax,%ebp
  803d53:	83 f5 1f             	xor    $0x1f,%ebp
  803d56:	0f 84 ac 00 00 00    	je     803e08 <__umoddi3+0x108>
  803d5c:	bf 20 00 00 00       	mov    $0x20,%edi
  803d61:	29 ef                	sub    %ebp,%edi
  803d63:	89 fe                	mov    %edi,%esi
  803d65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d69:	89 e9                	mov    %ebp,%ecx
  803d6b:	d3 e0                	shl    %cl,%eax
  803d6d:	89 d7                	mov    %edx,%edi
  803d6f:	89 f1                	mov    %esi,%ecx
  803d71:	d3 ef                	shr    %cl,%edi
  803d73:	09 c7                	or     %eax,%edi
  803d75:	89 e9                	mov    %ebp,%ecx
  803d77:	d3 e2                	shl    %cl,%edx
  803d79:	89 14 24             	mov    %edx,(%esp)
  803d7c:	89 d8                	mov    %ebx,%eax
  803d7e:	d3 e0                	shl    %cl,%eax
  803d80:	89 c2                	mov    %eax,%edx
  803d82:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d86:	d3 e0                	shl    %cl,%eax
  803d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d8c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d90:	89 f1                	mov    %esi,%ecx
  803d92:	d3 e8                	shr    %cl,%eax
  803d94:	09 d0                	or     %edx,%eax
  803d96:	d3 eb                	shr    %cl,%ebx
  803d98:	89 da                	mov    %ebx,%edx
  803d9a:	f7 f7                	div    %edi
  803d9c:	89 d3                	mov    %edx,%ebx
  803d9e:	f7 24 24             	mull   (%esp)
  803da1:	89 c6                	mov    %eax,%esi
  803da3:	89 d1                	mov    %edx,%ecx
  803da5:	39 d3                	cmp    %edx,%ebx
  803da7:	0f 82 87 00 00 00    	jb     803e34 <__umoddi3+0x134>
  803dad:	0f 84 91 00 00 00    	je     803e44 <__umoddi3+0x144>
  803db3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803db7:	29 f2                	sub    %esi,%edx
  803db9:	19 cb                	sbb    %ecx,%ebx
  803dbb:	89 d8                	mov    %ebx,%eax
  803dbd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803dc1:	d3 e0                	shl    %cl,%eax
  803dc3:	89 e9                	mov    %ebp,%ecx
  803dc5:	d3 ea                	shr    %cl,%edx
  803dc7:	09 d0                	or     %edx,%eax
  803dc9:	89 e9                	mov    %ebp,%ecx
  803dcb:	d3 eb                	shr    %cl,%ebx
  803dcd:	89 da                	mov    %ebx,%edx
  803dcf:	83 c4 1c             	add    $0x1c,%esp
  803dd2:	5b                   	pop    %ebx
  803dd3:	5e                   	pop    %esi
  803dd4:	5f                   	pop    %edi
  803dd5:	5d                   	pop    %ebp
  803dd6:	c3                   	ret    
  803dd7:	90                   	nop
  803dd8:	89 fd                	mov    %edi,%ebp
  803dda:	85 ff                	test   %edi,%edi
  803ddc:	75 0b                	jne    803de9 <__umoddi3+0xe9>
  803dde:	b8 01 00 00 00       	mov    $0x1,%eax
  803de3:	31 d2                	xor    %edx,%edx
  803de5:	f7 f7                	div    %edi
  803de7:	89 c5                	mov    %eax,%ebp
  803de9:	89 f0                	mov    %esi,%eax
  803deb:	31 d2                	xor    %edx,%edx
  803ded:	f7 f5                	div    %ebp
  803def:	89 c8                	mov    %ecx,%eax
  803df1:	f7 f5                	div    %ebp
  803df3:	89 d0                	mov    %edx,%eax
  803df5:	e9 44 ff ff ff       	jmp    803d3e <__umoddi3+0x3e>
  803dfa:	66 90                	xchg   %ax,%ax
  803dfc:	89 c8                	mov    %ecx,%eax
  803dfe:	89 f2                	mov    %esi,%edx
  803e00:	83 c4 1c             	add    $0x1c,%esp
  803e03:	5b                   	pop    %ebx
  803e04:	5e                   	pop    %esi
  803e05:	5f                   	pop    %edi
  803e06:	5d                   	pop    %ebp
  803e07:	c3                   	ret    
  803e08:	3b 04 24             	cmp    (%esp),%eax
  803e0b:	72 06                	jb     803e13 <__umoddi3+0x113>
  803e0d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e11:	77 0f                	ja     803e22 <__umoddi3+0x122>
  803e13:	89 f2                	mov    %esi,%edx
  803e15:	29 f9                	sub    %edi,%ecx
  803e17:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803e1b:	89 14 24             	mov    %edx,(%esp)
  803e1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e22:	8b 44 24 04          	mov    0x4(%esp),%eax
  803e26:	8b 14 24             	mov    (%esp),%edx
  803e29:	83 c4 1c             	add    $0x1c,%esp
  803e2c:	5b                   	pop    %ebx
  803e2d:	5e                   	pop    %esi
  803e2e:	5f                   	pop    %edi
  803e2f:	5d                   	pop    %ebp
  803e30:	c3                   	ret    
  803e31:	8d 76 00             	lea    0x0(%esi),%esi
  803e34:	2b 04 24             	sub    (%esp),%eax
  803e37:	19 fa                	sbb    %edi,%edx
  803e39:	89 d1                	mov    %edx,%ecx
  803e3b:	89 c6                	mov    %eax,%esi
  803e3d:	e9 71 ff ff ff       	jmp    803db3 <__umoddi3+0xb3>
  803e42:	66 90                	xchg   %ax,%ax
  803e44:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803e48:	72 ea                	jb     803e34 <__umoddi3+0x134>
  803e4a:	89 d9                	mov    %ebx,%ecx
  803e4c:	e9 62 ff ff ff       	jmp    803db3 <__umoddi3+0xb3>
