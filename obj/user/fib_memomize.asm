
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
  800052:	68 c0 3d 80 00       	push   $0x803dc0
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
  8000ec:	68 de 3d 80 00       	push   $0x803dde
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
  800231:	68 0c 3e 80 00       	push   $0x803e0c
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
  800259:	68 34 3e 80 00       	push   $0x803e34
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
  80028a:	68 5c 3e 80 00       	push   $0x803e5c
  80028f:	e8 34 01 00 00       	call   8003c8 <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800297:	a1 20 50 80 00       	mov    0x805020,%eax
  80029c:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	50                   	push   %eax
  8002a6:	68 b4 3e 80 00       	push   $0x803eb4
  8002ab:	e8 18 01 00 00       	call   8003c8 <cprintf>
  8002b0:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	68 0c 3e 80 00       	push   $0x803e0c
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
  800465:	e8 ea 36 00 00       	call   803b54 <__udivdi3>
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
  8004b5:	e8 aa 37 00 00       	call   803c64 <__umoddi3>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	05 f4 40 80 00       	add    $0x8040f4,%eax
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
  800610:	8b 04 85 18 41 80 00 	mov    0x804118(,%eax,4),%eax
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
  8006f1:	8b 34 9d 60 3f 80 00 	mov    0x803f60(,%ebx,4),%esi
  8006f8:	85 f6                	test   %esi,%esi
  8006fa:	75 19                	jne    800715 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006fc:	53                   	push   %ebx
  8006fd:	68 05 41 80 00       	push   $0x804105
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
  800716:	68 0e 41 80 00       	push   $0x80410e
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
  800743:	be 11 41 80 00       	mov    $0x804111,%esi
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
  800a6e:	68 88 42 80 00       	push   $0x804288
  800a73:	e8 50 f9 ff ff       	call   8003c8 <cprintf>
  800a78:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a82:	83 ec 0c             	sub    $0xc,%esp
  800a85:	6a 00                	push   $0x0
  800a87:	e8 d2 2e 00 00       	call   80395e <iscons>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a92:	e8 b4 2e 00 00       	call   80394b <getchar>
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
  800ab0:	68 8b 42 80 00       	push   $0x80428b
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
  800add:	e8 4a 2e 00 00       	call   80392c <cputchar>
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
  800b14:	e8 13 2e 00 00       	call   80392c <cputchar>
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
  800b3d:	e8 ea 2d 00 00       	call   80392c <cputchar>
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
  800b72:	68 88 42 80 00       	push   $0x804288
  800b77:	e8 4c f8 ff ff       	call   8003c8 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	6a 00                	push   $0x0
  800b8b:	e8 ce 2d 00 00       	call   80395e <iscons>
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b96:	e8 b0 2d 00 00       	call   80394b <getchar>
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
  800bb4:	68 8b 42 80 00       	push   $0x80428b
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
  800be1:	e8 46 2d 00 00       	call   80392c <cputchar>
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
  800c18:	e8 0f 2d 00 00       	call   80392c <cputchar>
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
  800c41:	e8 e6 2c 00 00       	call   80392c <cputchar>
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
  801356:	68 9c 42 80 00       	push   $0x80429c
  80135b:	68 3f 01 00 00       	push   $0x13f
  801360:	68 be 42 80 00       	push   $0x8042be
  801365:	e8 fe 25 00 00       	call   803968 <_panic>

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
  801400:	e8 41 0e 00 00       	call   802246 <alloc_block_FF>
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
  801423:	e8 da 12 00 00       	call   802702 <alloc_block_BF>
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
  8015d1:	e8 f0 08 00 00       	call   801ec6 <get_block_size>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	ff 75 08             	pushl  0x8(%ebp)
  8015e2:	e8 00 1b 00 00       	call   8030e7 <free_block>
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
  801687:	68 cc 42 80 00       	push   $0x8042cc
  80168c:	68 87 00 00 00       	push   $0x87
  801691:	68 f6 42 80 00       	push   $0x8042f6
  801696:	e8 cd 22 00 00       	call   803968 <_panic>
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
  801832:	68 04 43 80 00       	push   $0x804304
  801837:	68 e4 00 00 00       	push   $0xe4
  80183c:	68 f6 42 80 00       	push   $0x8042f6
  801841:	e8 22 21 00 00       	call   803968 <_panic>

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
  80184f:	68 2a 43 80 00       	push   $0x80432a
  801854:	68 f0 00 00 00       	push   $0xf0
  801859:	68 f6 42 80 00       	push   $0x8042f6
  80185e:	e8 05 21 00 00       	call   803968 <_panic>

00801863 <shrink>:

}
void shrink(uint32 newSize)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	68 2a 43 80 00       	push   $0x80432a
  801871:	68 f5 00 00 00       	push   $0xf5
  801876:	68 f6 42 80 00       	push   $0x8042f6
  80187b:	e8 e8 20 00 00       	call   803968 <_panic>

00801880 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	68 2a 43 80 00       	push   $0x80432a
  80188e:	68 fa 00 00 00       	push   $0xfa
  801893:	68 f6 42 80 00       	push   $0x8042f6
  801898:	e8 cb 20 00 00       	call   803968 <_panic>

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

00801ec6 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	83 e8 04             	sub    $0x4,%eax
  801ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed8:	8b 00                	mov    (%eax),%eax
  801eda:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	83 e8 04             	sub    $0x4,%eax
  801eeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef1:	8b 00                	mov    (%eax),%eax
  801ef3:	83 e0 01             	and    $0x1,%eax
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	0f 94 c0             	sete   %al
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801f03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0d:	83 f8 02             	cmp    $0x2,%eax
  801f10:	74 2b                	je     801f3d <alloc_block+0x40>
  801f12:	83 f8 02             	cmp    $0x2,%eax
  801f15:	7f 07                	jg     801f1e <alloc_block+0x21>
  801f17:	83 f8 01             	cmp    $0x1,%eax
  801f1a:	74 0e                	je     801f2a <alloc_block+0x2d>
  801f1c:	eb 58                	jmp    801f76 <alloc_block+0x79>
  801f1e:	83 f8 03             	cmp    $0x3,%eax
  801f21:	74 2d                	je     801f50 <alloc_block+0x53>
  801f23:	83 f8 04             	cmp    $0x4,%eax
  801f26:	74 3b                	je     801f63 <alloc_block+0x66>
  801f28:	eb 4c                	jmp    801f76 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f2a:	83 ec 0c             	sub    $0xc,%esp
  801f2d:	ff 75 08             	pushl  0x8(%ebp)
  801f30:	e8 11 03 00 00       	call   802246 <alloc_block_FF>
  801f35:	83 c4 10             	add    $0x10,%esp
  801f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f3b:	eb 4a                	jmp    801f87 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f3d:	83 ec 0c             	sub    $0xc,%esp
  801f40:	ff 75 08             	pushl  0x8(%ebp)
  801f43:	e8 c7 19 00 00       	call   80390f <alloc_block_NF>
  801f48:	83 c4 10             	add    $0x10,%esp
  801f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f4e:	eb 37                	jmp    801f87 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	ff 75 08             	pushl  0x8(%ebp)
  801f56:	e8 a7 07 00 00       	call   802702 <alloc_block_BF>
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f61:	eb 24                	jmp    801f87 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f63:	83 ec 0c             	sub    $0xc,%esp
  801f66:	ff 75 08             	pushl  0x8(%ebp)
  801f69:	e8 84 19 00 00       	call   8038f2 <alloc_block_WF>
  801f6e:	83 c4 10             	add    $0x10,%esp
  801f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f74:	eb 11                	jmp    801f87 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f76:	83 ec 0c             	sub    $0xc,%esp
  801f79:	68 3c 43 80 00       	push   $0x80433c
  801f7e:	e8 45 e4 ff ff       	call   8003c8 <cprintf>
  801f83:	83 c4 10             	add    $0x10,%esp
		break;
  801f86:	90                   	nop
	}
	return va;
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	53                   	push   %ebx
  801f90:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f93:	83 ec 0c             	sub    $0xc,%esp
  801f96:	68 5c 43 80 00       	push   $0x80435c
  801f9b:	e8 28 e4 ff ff       	call   8003c8 <cprintf>
  801fa0:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801fa3:	83 ec 0c             	sub    $0xc,%esp
  801fa6:	68 87 43 80 00       	push   $0x804387
  801fab:	e8 18 e4 ff ff       	call   8003c8 <cprintf>
  801fb0:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb9:	eb 37                	jmp    801ff2 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801fbb:	83 ec 0c             	sub    $0xc,%esp
  801fbe:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc1:	e8 19 ff ff ff       	call   801edf <is_free_block>
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	0f be d8             	movsbl %al,%ebx
  801fcc:	83 ec 0c             	sub    $0xc,%esp
  801fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd2:	e8 ef fe ff ff       	call   801ec6 <get_block_size>
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	83 ec 04             	sub    $0x4,%esp
  801fdd:	53                   	push   %ebx
  801fde:	50                   	push   %eax
  801fdf:	68 9f 43 80 00       	push   $0x80439f
  801fe4:	e8 df e3 ff ff       	call   8003c8 <cprintf>
  801fe9:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fec:	8b 45 10             	mov    0x10(%ebp),%eax
  801fef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff6:	74 07                	je     801fff <print_blocks_list+0x73>
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	8b 00                	mov    (%eax),%eax
  801ffd:	eb 05                	jmp    802004 <print_blocks_list+0x78>
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
  802004:	89 45 10             	mov    %eax,0x10(%ebp)
  802007:	8b 45 10             	mov    0x10(%ebp),%eax
  80200a:	85 c0                	test   %eax,%eax
  80200c:	75 ad                	jne    801fbb <print_blocks_list+0x2f>
  80200e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802012:	75 a7                	jne    801fbb <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	68 5c 43 80 00       	push   $0x80435c
  80201c:	e8 a7 e3 ff ff       	call   8003c8 <cprintf>
  802021:	83 c4 10             	add    $0x10,%esp

}
  802024:	90                   	nop
  802025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802030:	8b 45 0c             	mov    0xc(%ebp),%eax
  802033:	83 e0 01             	and    $0x1,%eax
  802036:	85 c0                	test   %eax,%eax
  802038:	74 03                	je     80203d <initialize_dynamic_allocator+0x13>
  80203a:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80203d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802041:	0f 84 c7 01 00 00    	je     80220e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802047:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80204e:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802051:	8b 55 08             	mov    0x8(%ebp),%edx
  802054:	8b 45 0c             	mov    0xc(%ebp),%eax
  802057:	01 d0                	add    %edx,%eax
  802059:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80205e:	0f 87 ad 01 00 00    	ja     802211 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	85 c0                	test   %eax,%eax
  802069:	0f 89 a5 01 00 00    	jns    802214 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80206f:	8b 55 08             	mov    0x8(%ebp),%edx
  802072:	8b 45 0c             	mov    0xc(%ebp),%eax
  802075:	01 d0                	add    %edx,%eax
  802077:	83 e8 04             	sub    $0x4,%eax
  80207a:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80207f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802086:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80208b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208e:	e9 87 00 00 00       	jmp    80211a <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802093:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802097:	75 14                	jne    8020ad <initialize_dynamic_allocator+0x83>
  802099:	83 ec 04             	sub    $0x4,%esp
  80209c:	68 b7 43 80 00       	push   $0x8043b7
  8020a1:	6a 79                	push   $0x79
  8020a3:	68 d5 43 80 00       	push   $0x8043d5
  8020a8:	e8 bb 18 00 00       	call   803968 <_panic>
  8020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b0:	8b 00                	mov    (%eax),%eax
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	74 10                	je     8020c6 <initialize_dynamic_allocator+0x9c>
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	8b 00                	mov    (%eax),%eax
  8020bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020be:	8b 52 04             	mov    0x4(%edx),%edx
  8020c1:	89 50 04             	mov    %edx,0x4(%eax)
  8020c4:	eb 0b                	jmp    8020d1 <initialize_dynamic_allocator+0xa7>
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	8b 40 04             	mov    0x4(%eax),%eax
  8020cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	8b 40 04             	mov    0x4(%eax),%eax
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	74 0f                	je     8020ea <initialize_dynamic_allocator+0xc0>
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	8b 40 04             	mov    0x4(%eax),%eax
  8020e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e4:	8b 12                	mov    (%edx),%edx
  8020e6:	89 10                	mov    %edx,(%eax)
  8020e8:	eb 0a                	jmp    8020f4 <initialize_dynamic_allocator+0xca>
  8020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ed:	8b 00                	mov    (%eax),%eax
  8020ef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802100:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802107:	a1 38 50 80 00       	mov    0x805038,%eax
  80210c:	48                   	dec    %eax
  80210d:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802112:	a1 34 50 80 00       	mov    0x805034,%eax
  802117:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80211a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211e:	74 07                	je     802127 <initialize_dynamic_allocator+0xfd>
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	8b 00                	mov    (%eax),%eax
  802125:	eb 05                	jmp    80212c <initialize_dynamic_allocator+0x102>
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
  80212c:	a3 34 50 80 00       	mov    %eax,0x805034
  802131:	a1 34 50 80 00       	mov    0x805034,%eax
  802136:	85 c0                	test   %eax,%eax
  802138:	0f 85 55 ff ff ff    	jne    802093 <initialize_dynamic_allocator+0x69>
  80213e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802142:	0f 85 4b ff ff ff    	jne    802093 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80214e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802151:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802157:	a1 44 50 80 00       	mov    0x805044,%eax
  80215c:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802161:	a1 40 50 80 00       	mov    0x805040,%eax
  802166:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	83 c0 08             	add    $0x8,%eax
  802172:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	83 c0 04             	add    $0x4,%eax
  80217b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217e:	83 ea 08             	sub    $0x8,%edx
  802181:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802183:	8b 55 0c             	mov    0xc(%ebp),%edx
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	01 d0                	add    %edx,%eax
  80218b:	83 e8 08             	sub    $0x8,%eax
  80218e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802191:	83 ea 08             	sub    $0x8,%edx
  802194:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802196:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80219f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8021a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021ad:	75 17                	jne    8021c6 <initialize_dynamic_allocator+0x19c>
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	68 f0 43 80 00       	push   $0x8043f0
  8021b7:	68 90 00 00 00       	push   $0x90
  8021bc:	68 d5 43 80 00       	push   $0x8043d5
  8021c1:	e8 a2 17 00 00       	call   803968 <_panic>
  8021c6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021cf:	89 10                	mov    %edx,(%eax)
  8021d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d4:	8b 00                	mov    (%eax),%eax
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	74 0d                	je     8021e7 <initialize_dynamic_allocator+0x1bd>
  8021da:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021e2:	89 50 04             	mov    %edx,0x4(%eax)
  8021e5:	eb 08                	jmp    8021ef <initialize_dynamic_allocator+0x1c5>
  8021e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8021ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802201:	a1 38 50 80 00       	mov    0x805038,%eax
  802206:	40                   	inc    %eax
  802207:	a3 38 50 80 00       	mov    %eax,0x805038
  80220c:	eb 07                	jmp    802215 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80220e:	90                   	nop
  80220f:	eb 04                	jmp    802215 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802211:	90                   	nop
  802212:	eb 01                	jmp    802215 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802214:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80221a:	8b 45 10             	mov    0x10(%ebp),%eax
  80221d:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	8d 50 fc             	lea    -0x4(%eax),%edx
  802226:	8b 45 0c             	mov    0xc(%ebp),%eax
  802229:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	83 e8 04             	sub    $0x4,%eax
  802231:	8b 00                	mov    (%eax),%eax
  802233:	83 e0 fe             	and    $0xfffffffe,%eax
  802236:	8d 50 f8             	lea    -0x8(%eax),%edx
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	01 c2                	add    %eax,%edx
  80223e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802241:	89 02                	mov    %eax,(%edx)
}
  802243:	90                   	nop
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    

00802246 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	83 e0 01             	and    $0x1,%eax
  802252:	85 c0                	test   %eax,%eax
  802254:	74 03                	je     802259 <alloc_block_FF+0x13>
  802256:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802259:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80225d:	77 07                	ja     802266 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80225f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802266:	a1 24 50 80 00       	mov    0x805024,%eax
  80226b:	85 c0                	test   %eax,%eax
  80226d:	75 73                	jne    8022e2 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	83 c0 10             	add    $0x10,%eax
  802275:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802278:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80227f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802282:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802285:	01 d0                	add    %edx,%eax
  802287:	48                   	dec    %eax
  802288:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80228b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80228e:	ba 00 00 00 00       	mov    $0x0,%edx
  802293:	f7 75 ec             	divl   -0x14(%ebp)
  802296:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802299:	29 d0                	sub    %edx,%eax
  80229b:	c1 e8 0c             	shr    $0xc,%eax
  80229e:	83 ec 0c             	sub    $0xc,%esp
  8022a1:	50                   	push   %eax
  8022a2:	e8 c3 f0 ff ff       	call   80136a <sbrk>
  8022a7:	83 c4 10             	add    $0x10,%esp
  8022aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8022ad:	83 ec 0c             	sub    $0xc,%esp
  8022b0:	6a 00                	push   $0x0
  8022b2:	e8 b3 f0 ff ff       	call   80136a <sbrk>
  8022b7:	83 c4 10             	add    $0x10,%esp
  8022ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8022bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8022c3:	83 ec 08             	sub    $0x8,%esp
  8022c6:	50                   	push   %eax
  8022c7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022ca:	e8 5b fd ff ff       	call   80202a <initialize_dynamic_allocator>
  8022cf:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022d2:	83 ec 0c             	sub    $0xc,%esp
  8022d5:	68 13 44 80 00       	push   $0x804413
  8022da:	e8 e9 e0 ff ff       	call   8003c8 <cprintf>
  8022df:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e6:	75 0a                	jne    8022f2 <alloc_block_FF+0xac>
	        return NULL;
  8022e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ed:	e9 0e 04 00 00       	jmp    802700 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8022f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022f9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802301:	e9 f3 02 00 00       	jmp    8025f9 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802309:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80230c:	83 ec 0c             	sub    $0xc,%esp
  80230f:	ff 75 bc             	pushl  -0x44(%ebp)
  802312:	e8 af fb ff ff       	call   801ec6 <get_block_size>
  802317:	83 c4 10             	add    $0x10,%esp
  80231a:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	83 c0 08             	add    $0x8,%eax
  802323:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802326:	0f 87 c5 02 00 00    	ja     8025f1 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	83 c0 18             	add    $0x18,%eax
  802332:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802335:	0f 87 19 02 00 00    	ja     802554 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80233b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80233e:	2b 45 08             	sub    0x8(%ebp),%eax
  802341:	83 e8 08             	sub    $0x8,%eax
  802344:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	8d 50 08             	lea    0x8(%eax),%edx
  80234d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802350:	01 d0                	add    %edx,%eax
  802352:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	83 c0 08             	add    $0x8,%eax
  80235b:	83 ec 04             	sub    $0x4,%esp
  80235e:	6a 01                	push   $0x1
  802360:	50                   	push   %eax
  802361:	ff 75 bc             	pushl  -0x44(%ebp)
  802364:	e8 ae fe ff ff       	call   802217 <set_block_data>
  802369:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 40 04             	mov    0x4(%eax),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	75 68                	jne    8023de <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802376:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80237a:	75 17                	jne    802393 <alloc_block_FF+0x14d>
  80237c:	83 ec 04             	sub    $0x4,%esp
  80237f:	68 f0 43 80 00       	push   $0x8043f0
  802384:	68 d7 00 00 00       	push   $0xd7
  802389:	68 d5 43 80 00       	push   $0x8043d5
  80238e:	e8 d5 15 00 00       	call   803968 <_panic>
  802393:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802399:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80239c:	89 10                	mov    %edx,(%eax)
  80239e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a1:	8b 00                	mov    (%eax),%eax
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	74 0d                	je     8023b4 <alloc_block_FF+0x16e>
  8023a7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8023ac:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023af:	89 50 04             	mov    %edx,0x4(%eax)
  8023b2:	eb 08                	jmp    8023bc <alloc_block_FF+0x176>
  8023b4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8023bc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023bf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8023d3:	40                   	inc    %eax
  8023d4:	a3 38 50 80 00       	mov    %eax,0x805038
  8023d9:	e9 dc 00 00 00       	jmp    8024ba <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	8b 00                	mov    (%eax),%eax
  8023e3:	85 c0                	test   %eax,%eax
  8023e5:	75 65                	jne    80244c <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023e7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023eb:	75 17                	jne    802404 <alloc_block_FF+0x1be>
  8023ed:	83 ec 04             	sub    $0x4,%esp
  8023f0:	68 24 44 80 00       	push   $0x804424
  8023f5:	68 db 00 00 00       	push   $0xdb
  8023fa:	68 d5 43 80 00       	push   $0x8043d5
  8023ff:	e8 64 15 00 00       	call   803968 <_panic>
  802404:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80240a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80240d:	89 50 04             	mov    %edx,0x4(%eax)
  802410:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802413:	8b 40 04             	mov    0x4(%eax),%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	74 0c                	je     802426 <alloc_block_FF+0x1e0>
  80241a:	a1 30 50 80 00       	mov    0x805030,%eax
  80241f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802422:	89 10                	mov    %edx,(%eax)
  802424:	eb 08                	jmp    80242e <alloc_block_FF+0x1e8>
  802426:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802429:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80242e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802431:	a3 30 50 80 00       	mov    %eax,0x805030
  802436:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802439:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80243f:	a1 38 50 80 00       	mov    0x805038,%eax
  802444:	40                   	inc    %eax
  802445:	a3 38 50 80 00       	mov    %eax,0x805038
  80244a:	eb 6e                	jmp    8024ba <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80244c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802450:	74 06                	je     802458 <alloc_block_FF+0x212>
  802452:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802456:	75 17                	jne    80246f <alloc_block_FF+0x229>
  802458:	83 ec 04             	sub    $0x4,%esp
  80245b:	68 48 44 80 00       	push   $0x804448
  802460:	68 df 00 00 00       	push   $0xdf
  802465:	68 d5 43 80 00       	push   $0x8043d5
  80246a:	e8 f9 14 00 00       	call   803968 <_panic>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 10                	mov    (%eax),%edx
  802474:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802477:	89 10                	mov    %edx,(%eax)
  802479:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80247c:	8b 00                	mov    (%eax),%eax
  80247e:	85 c0                	test   %eax,%eax
  802480:	74 0b                	je     80248d <alloc_block_FF+0x247>
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 00                	mov    (%eax),%eax
  802487:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80248a:	89 50 04             	mov    %edx,0x4(%eax)
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802493:	89 10                	mov    %edx,(%eax)
  802495:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802498:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249b:	89 50 04             	mov    %edx,0x4(%eax)
  80249e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024a1:	8b 00                	mov    (%eax),%eax
  8024a3:	85 c0                	test   %eax,%eax
  8024a5:	75 08                	jne    8024af <alloc_block_FF+0x269>
  8024a7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8024aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8024af:	a1 38 50 80 00       	mov    0x805038,%eax
  8024b4:	40                   	inc    %eax
  8024b5:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8024ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024be:	75 17                	jne    8024d7 <alloc_block_FF+0x291>
  8024c0:	83 ec 04             	sub    $0x4,%esp
  8024c3:	68 b7 43 80 00       	push   $0x8043b7
  8024c8:	68 e1 00 00 00       	push   $0xe1
  8024cd:	68 d5 43 80 00       	push   $0x8043d5
  8024d2:	e8 91 14 00 00       	call   803968 <_panic>
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 00                	mov    (%eax),%eax
  8024dc:	85 c0                	test   %eax,%eax
  8024de:	74 10                	je     8024f0 <alloc_block_FF+0x2aa>
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 00                	mov    (%eax),%eax
  8024e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e8:	8b 52 04             	mov    0x4(%edx),%edx
  8024eb:	89 50 04             	mov    %edx,0x4(%eax)
  8024ee:	eb 0b                	jmp    8024fb <alloc_block_FF+0x2b5>
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 04             	mov    0x4(%eax),%eax
  8024f6:	a3 30 50 80 00       	mov    %eax,0x805030
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	8b 40 04             	mov    0x4(%eax),%eax
  802501:	85 c0                	test   %eax,%eax
  802503:	74 0f                	je     802514 <alloc_block_FF+0x2ce>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 40 04             	mov    0x4(%eax),%eax
  80250b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250e:	8b 12                	mov    (%edx),%edx
  802510:	89 10                	mov    %edx,(%eax)
  802512:	eb 0a                	jmp    80251e <alloc_block_FF+0x2d8>
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 00                	mov    (%eax),%eax
  802519:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802531:	a1 38 50 80 00       	mov    0x805038,%eax
  802536:	48                   	dec    %eax
  802537:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80253c:	83 ec 04             	sub    $0x4,%esp
  80253f:	6a 00                	push   $0x0
  802541:	ff 75 b4             	pushl  -0x4c(%ebp)
  802544:	ff 75 b0             	pushl  -0x50(%ebp)
  802547:	e8 cb fc ff ff       	call   802217 <set_block_data>
  80254c:	83 c4 10             	add    $0x10,%esp
  80254f:	e9 95 00 00 00       	jmp    8025e9 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802554:	83 ec 04             	sub    $0x4,%esp
  802557:	6a 01                	push   $0x1
  802559:	ff 75 b8             	pushl  -0x48(%ebp)
  80255c:	ff 75 bc             	pushl  -0x44(%ebp)
  80255f:	e8 b3 fc ff ff       	call   802217 <set_block_data>
  802564:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256b:	75 17                	jne    802584 <alloc_block_FF+0x33e>
  80256d:	83 ec 04             	sub    $0x4,%esp
  802570:	68 b7 43 80 00       	push   $0x8043b7
  802575:	68 e8 00 00 00       	push   $0xe8
  80257a:	68 d5 43 80 00       	push   $0x8043d5
  80257f:	e8 e4 13 00 00       	call   803968 <_panic>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	85 c0                	test   %eax,%eax
  80258b:	74 10                	je     80259d <alloc_block_FF+0x357>
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802595:	8b 52 04             	mov    0x4(%edx),%edx
  802598:	89 50 04             	mov    %edx,0x4(%eax)
  80259b:	eb 0b                	jmp    8025a8 <alloc_block_FF+0x362>
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 40 04             	mov    0x4(%eax),%eax
  8025a3:	a3 30 50 80 00       	mov    %eax,0x805030
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	8b 40 04             	mov    0x4(%eax),%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	74 0f                	je     8025c1 <alloc_block_FF+0x37b>
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bb:	8b 12                	mov    (%edx),%edx
  8025bd:	89 10                	mov    %edx,(%eax)
  8025bf:	eb 0a                	jmp    8025cb <alloc_block_FF+0x385>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025de:	a1 38 50 80 00       	mov    0x805038,%eax
  8025e3:	48                   	dec    %eax
  8025e4:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8025e9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025ec:	e9 0f 01 00 00       	jmp    802700 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8025f1:	a1 34 50 80 00       	mov    0x805034,%eax
  8025f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fd:	74 07                	je     802606 <alloc_block_FF+0x3c0>
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 00                	mov    (%eax),%eax
  802604:	eb 05                	jmp    80260b <alloc_block_FF+0x3c5>
  802606:	b8 00 00 00 00       	mov    $0x0,%eax
  80260b:	a3 34 50 80 00       	mov    %eax,0x805034
  802610:	a1 34 50 80 00       	mov    0x805034,%eax
  802615:	85 c0                	test   %eax,%eax
  802617:	0f 85 e9 fc ff ff    	jne    802306 <alloc_block_FF+0xc0>
  80261d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802621:	0f 85 df fc ff ff    	jne    802306 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	83 c0 08             	add    $0x8,%eax
  80262d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802630:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802637:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80263a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80263d:	01 d0                	add    %edx,%eax
  80263f:	48                   	dec    %eax
  802640:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802643:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802646:	ba 00 00 00 00       	mov    $0x0,%edx
  80264b:	f7 75 d8             	divl   -0x28(%ebp)
  80264e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802651:	29 d0                	sub    %edx,%eax
  802653:	c1 e8 0c             	shr    $0xc,%eax
  802656:	83 ec 0c             	sub    $0xc,%esp
  802659:	50                   	push   %eax
  80265a:	e8 0b ed ff ff       	call   80136a <sbrk>
  80265f:	83 c4 10             	add    $0x10,%esp
  802662:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802665:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802669:	75 0a                	jne    802675 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80266b:	b8 00 00 00 00       	mov    $0x0,%eax
  802670:	e9 8b 00 00 00       	jmp    802700 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802675:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80267c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80267f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802682:	01 d0                	add    %edx,%eax
  802684:	48                   	dec    %eax
  802685:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802688:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80268b:	ba 00 00 00 00       	mov    $0x0,%edx
  802690:	f7 75 cc             	divl   -0x34(%ebp)
  802693:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802696:	29 d0                	sub    %edx,%eax
  802698:	8d 50 fc             	lea    -0x4(%eax),%edx
  80269b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80269e:	01 d0                	add    %edx,%eax
  8026a0:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8026a5:	a1 40 50 80 00       	mov    0x805040,%eax
  8026aa:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8026b0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8026b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026bd:	01 d0                	add    %edx,%eax
  8026bf:	48                   	dec    %eax
  8026c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8026cb:	f7 75 c4             	divl   -0x3c(%ebp)
  8026ce:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026d1:	29 d0                	sub    %edx,%eax
  8026d3:	83 ec 04             	sub    $0x4,%esp
  8026d6:	6a 01                	push   $0x1
  8026d8:	50                   	push   %eax
  8026d9:	ff 75 d0             	pushl  -0x30(%ebp)
  8026dc:	e8 36 fb ff ff       	call   802217 <set_block_data>
  8026e1:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026e4:	83 ec 0c             	sub    $0xc,%esp
  8026e7:	ff 75 d0             	pushl  -0x30(%ebp)
  8026ea:	e8 f8 09 00 00       	call   8030e7 <free_block>
  8026ef:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8026f2:	83 ec 0c             	sub    $0xc,%esp
  8026f5:	ff 75 08             	pushl  0x8(%ebp)
  8026f8:	e8 49 fb ff ff       	call   802246 <alloc_block_FF>
  8026fd:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
  802705:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	83 e0 01             	and    $0x1,%eax
  80270e:	85 c0                	test   %eax,%eax
  802710:	74 03                	je     802715 <alloc_block_BF+0x13>
  802712:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802715:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802719:	77 07                	ja     802722 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80271b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802722:	a1 24 50 80 00       	mov    0x805024,%eax
  802727:	85 c0                	test   %eax,%eax
  802729:	75 73                	jne    80279e <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80272b:	8b 45 08             	mov    0x8(%ebp),%eax
  80272e:	83 c0 10             	add    $0x10,%eax
  802731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802734:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80273b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80273e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802741:	01 d0                	add    %edx,%eax
  802743:	48                   	dec    %eax
  802744:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802747:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80274a:	ba 00 00 00 00       	mov    $0x0,%edx
  80274f:	f7 75 e0             	divl   -0x20(%ebp)
  802752:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802755:	29 d0                	sub    %edx,%eax
  802757:	c1 e8 0c             	shr    $0xc,%eax
  80275a:	83 ec 0c             	sub    $0xc,%esp
  80275d:	50                   	push   %eax
  80275e:	e8 07 ec ff ff       	call   80136a <sbrk>
  802763:	83 c4 10             	add    $0x10,%esp
  802766:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802769:	83 ec 0c             	sub    $0xc,%esp
  80276c:	6a 00                	push   $0x0
  80276e:	e8 f7 eb ff ff       	call   80136a <sbrk>
  802773:	83 c4 10             	add    $0x10,%esp
  802776:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802779:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80277c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80277f:	83 ec 08             	sub    $0x8,%esp
  802782:	50                   	push   %eax
  802783:	ff 75 d8             	pushl  -0x28(%ebp)
  802786:	e8 9f f8 ff ff       	call   80202a <initialize_dynamic_allocator>
  80278b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80278e:	83 ec 0c             	sub    $0xc,%esp
  802791:	68 13 44 80 00       	push   $0x804413
  802796:	e8 2d dc ff ff       	call   8003c8 <cprintf>
  80279b:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80279e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8027a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8027ac:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8027ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c2:	e9 1d 01 00 00       	jmp    8028e4 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027cd:	83 ec 0c             	sub    $0xc,%esp
  8027d0:	ff 75 a8             	pushl  -0x58(%ebp)
  8027d3:	e8 ee f6 ff ff       	call   801ec6 <get_block_size>
  8027d8:	83 c4 10             	add    $0x10,%esp
  8027db:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	83 c0 08             	add    $0x8,%eax
  8027e4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027e7:	0f 87 ef 00 00 00    	ja     8028dc <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	83 c0 18             	add    $0x18,%eax
  8027f3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027f6:	77 1d                	ja     802815 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8027f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027fe:	0f 86 d8 00 00 00    	jbe    8028dc <alloc_block_BF+0x1da>
				{
					best_va = va;
  802804:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802807:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80280a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80280d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802810:	e9 c7 00 00 00       	jmp    8028dc <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802815:	8b 45 08             	mov    0x8(%ebp),%eax
  802818:	83 c0 08             	add    $0x8,%eax
  80281b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80281e:	0f 85 9d 00 00 00    	jne    8028c1 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802824:	83 ec 04             	sub    $0x4,%esp
  802827:	6a 01                	push   $0x1
  802829:	ff 75 a4             	pushl  -0x5c(%ebp)
  80282c:	ff 75 a8             	pushl  -0x58(%ebp)
  80282f:	e8 e3 f9 ff ff       	call   802217 <set_block_data>
  802834:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283b:	75 17                	jne    802854 <alloc_block_BF+0x152>
  80283d:	83 ec 04             	sub    $0x4,%esp
  802840:	68 b7 43 80 00       	push   $0x8043b7
  802845:	68 2c 01 00 00       	push   $0x12c
  80284a:	68 d5 43 80 00       	push   $0x8043d5
  80284f:	e8 14 11 00 00       	call   803968 <_panic>
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 00                	mov    (%eax),%eax
  802859:	85 c0                	test   %eax,%eax
  80285b:	74 10                	je     80286d <alloc_block_BF+0x16b>
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 00                	mov    (%eax),%eax
  802862:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802865:	8b 52 04             	mov    0x4(%edx),%edx
  802868:	89 50 04             	mov    %edx,0x4(%eax)
  80286b:	eb 0b                	jmp    802878 <alloc_block_BF+0x176>
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 40 04             	mov    0x4(%eax),%eax
  802873:	a3 30 50 80 00       	mov    %eax,0x805030
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 40 04             	mov    0x4(%eax),%eax
  80287e:	85 c0                	test   %eax,%eax
  802880:	74 0f                	je     802891 <alloc_block_BF+0x18f>
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	8b 40 04             	mov    0x4(%eax),%eax
  802888:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288b:	8b 12                	mov    (%edx),%edx
  80288d:	89 10                	mov    %edx,(%eax)
  80288f:	eb 0a                	jmp    80289b <alloc_block_BF+0x199>
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 00                	mov    (%eax),%eax
  802896:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8028b3:	48                   	dec    %eax
  8028b4:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8028b9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028bc:	e9 01 04 00 00       	jmp    802cc2 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  8028c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028c7:	76 13                	jbe    8028dc <alloc_block_BF+0x1da>
					{
						internal = 1;
  8028c9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028d0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8028d6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028d9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8028dc:	a1 34 50 80 00       	mov    0x805034,%eax
  8028e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e8:	74 07                	je     8028f1 <alloc_block_BF+0x1ef>
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 00                	mov    (%eax),%eax
  8028ef:	eb 05                	jmp    8028f6 <alloc_block_BF+0x1f4>
  8028f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f6:	a3 34 50 80 00       	mov    %eax,0x805034
  8028fb:	a1 34 50 80 00       	mov    0x805034,%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	0f 85 bf fe ff ff    	jne    8027c7 <alloc_block_BF+0xc5>
  802908:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290c:	0f 85 b5 fe ff ff    	jne    8027c7 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802912:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802916:	0f 84 26 02 00 00    	je     802b42 <alloc_block_BF+0x440>
  80291c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802920:	0f 85 1c 02 00 00    	jne    802b42 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802929:	2b 45 08             	sub    0x8(%ebp),%eax
  80292c:	83 e8 08             	sub    $0x8,%eax
  80292f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802932:	8b 45 08             	mov    0x8(%ebp),%eax
  802935:	8d 50 08             	lea    0x8(%eax),%edx
  802938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293b:	01 d0                	add    %edx,%eax
  80293d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	83 c0 08             	add    $0x8,%eax
  802946:	83 ec 04             	sub    $0x4,%esp
  802949:	6a 01                	push   $0x1
  80294b:	50                   	push   %eax
  80294c:	ff 75 f0             	pushl  -0x10(%ebp)
  80294f:	e8 c3 f8 ff ff       	call   802217 <set_block_data>
  802954:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295a:	8b 40 04             	mov    0x4(%eax),%eax
  80295d:	85 c0                	test   %eax,%eax
  80295f:	75 68                	jne    8029c9 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802961:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802965:	75 17                	jne    80297e <alloc_block_BF+0x27c>
  802967:	83 ec 04             	sub    $0x4,%esp
  80296a:	68 f0 43 80 00       	push   $0x8043f0
  80296f:	68 45 01 00 00       	push   $0x145
  802974:	68 d5 43 80 00       	push   $0x8043d5
  802979:	e8 ea 0f 00 00       	call   803968 <_panic>
  80297e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802984:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802987:	89 10                	mov    %edx,(%eax)
  802989:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80298c:	8b 00                	mov    (%eax),%eax
  80298e:	85 c0                	test   %eax,%eax
  802990:	74 0d                	je     80299f <alloc_block_BF+0x29d>
  802992:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802997:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80299a:	89 50 04             	mov    %edx,0x4(%eax)
  80299d:	eb 08                	jmp    8029a7 <alloc_block_BF+0x2a5>
  80299f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8029a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029aa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b9:	a1 38 50 80 00       	mov    0x805038,%eax
  8029be:	40                   	inc    %eax
  8029bf:	a3 38 50 80 00       	mov    %eax,0x805038
  8029c4:	e9 dc 00 00 00       	jmp    802aa5 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8029c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cc:	8b 00                	mov    (%eax),%eax
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	75 65                	jne    802a37 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029d2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029d6:	75 17                	jne    8029ef <alloc_block_BF+0x2ed>
  8029d8:	83 ec 04             	sub    $0x4,%esp
  8029db:	68 24 44 80 00       	push   $0x804424
  8029e0:	68 4a 01 00 00       	push   $0x14a
  8029e5:	68 d5 43 80 00       	push   $0x8043d5
  8029ea:	e8 79 0f 00 00       	call   803968 <_panic>
  8029ef:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029fe:	8b 40 04             	mov    0x4(%eax),%eax
  802a01:	85 c0                	test   %eax,%eax
  802a03:	74 0c                	je     802a11 <alloc_block_BF+0x30f>
  802a05:	a1 30 50 80 00       	mov    0x805030,%eax
  802a0a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a0d:	89 10                	mov    %edx,(%eax)
  802a0f:	eb 08                	jmp    802a19 <alloc_block_BF+0x317>
  802a11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a14:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a1c:	a3 30 50 80 00       	mov    %eax,0x805030
  802a21:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2a:	a1 38 50 80 00       	mov    0x805038,%eax
  802a2f:	40                   	inc    %eax
  802a30:	a3 38 50 80 00       	mov    %eax,0x805038
  802a35:	eb 6e                	jmp    802aa5 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a3b:	74 06                	je     802a43 <alloc_block_BF+0x341>
  802a3d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a41:	75 17                	jne    802a5a <alloc_block_BF+0x358>
  802a43:	83 ec 04             	sub    $0x4,%esp
  802a46:	68 48 44 80 00       	push   $0x804448
  802a4b:	68 4f 01 00 00       	push   $0x14f
  802a50:	68 d5 43 80 00       	push   $0x8043d5
  802a55:	e8 0e 0f 00 00       	call   803968 <_panic>
  802a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5d:	8b 10                	mov    (%eax),%edx
  802a5f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a62:	89 10                	mov    %edx,(%eax)
  802a64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	74 0b                	je     802a78 <alloc_block_BF+0x376>
  802a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a75:	89 50 04             	mov    %edx,0x4(%eax)
  802a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a7e:	89 10                	mov    %edx,(%eax)
  802a80:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a86:	89 50 04             	mov    %edx,0x4(%eax)
  802a89:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	75 08                	jne    802a9a <alloc_block_BF+0x398>
  802a92:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a95:	a3 30 50 80 00       	mov    %eax,0x805030
  802a9a:	a1 38 50 80 00       	mov    0x805038,%eax
  802a9f:	40                   	inc    %eax
  802aa0:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802aa5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aa9:	75 17                	jne    802ac2 <alloc_block_BF+0x3c0>
  802aab:	83 ec 04             	sub    $0x4,%esp
  802aae:	68 b7 43 80 00       	push   $0x8043b7
  802ab3:	68 51 01 00 00       	push   $0x151
  802ab8:	68 d5 43 80 00       	push   $0x8043d5
  802abd:	e8 a6 0e 00 00       	call   803968 <_panic>
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	74 10                	je     802adb <alloc_block_BF+0x3d9>
  802acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ad3:	8b 52 04             	mov    0x4(%edx),%edx
  802ad6:	89 50 04             	mov    %edx,0x4(%eax)
  802ad9:	eb 0b                	jmp    802ae6 <alloc_block_BF+0x3e4>
  802adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ade:	8b 40 04             	mov    0x4(%eax),%eax
  802ae1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae9:	8b 40 04             	mov    0x4(%eax),%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	74 0f                	je     802aff <alloc_block_BF+0x3fd>
  802af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af3:	8b 40 04             	mov    0x4(%eax),%eax
  802af6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af9:	8b 12                	mov    (%edx),%edx
  802afb:	89 10                	mov    %edx,(%eax)
  802afd:	eb 0a                	jmp    802b09 <alloc_block_BF+0x407>
  802aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1c:	a1 38 50 80 00       	mov    0x805038,%eax
  802b21:	48                   	dec    %eax
  802b22:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b27:	83 ec 04             	sub    $0x4,%esp
  802b2a:	6a 00                	push   $0x0
  802b2c:	ff 75 d0             	pushl  -0x30(%ebp)
  802b2f:	ff 75 cc             	pushl  -0x34(%ebp)
  802b32:	e8 e0 f6 ff ff       	call   802217 <set_block_data>
  802b37:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3d:	e9 80 01 00 00       	jmp    802cc2 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802b42:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b46:	0f 85 9d 00 00 00    	jne    802be9 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b4c:	83 ec 04             	sub    $0x4,%esp
  802b4f:	6a 01                	push   $0x1
  802b51:	ff 75 ec             	pushl  -0x14(%ebp)
  802b54:	ff 75 f0             	pushl  -0x10(%ebp)
  802b57:	e8 bb f6 ff ff       	call   802217 <set_block_data>
  802b5c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b63:	75 17                	jne    802b7c <alloc_block_BF+0x47a>
  802b65:	83 ec 04             	sub    $0x4,%esp
  802b68:	68 b7 43 80 00       	push   $0x8043b7
  802b6d:	68 58 01 00 00       	push   $0x158
  802b72:	68 d5 43 80 00       	push   $0x8043d5
  802b77:	e8 ec 0d 00 00       	call   803968 <_panic>
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	74 10                	je     802b95 <alloc_block_BF+0x493>
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8d:	8b 52 04             	mov    0x4(%edx),%edx
  802b90:	89 50 04             	mov    %edx,0x4(%eax)
  802b93:	eb 0b                	jmp    802ba0 <alloc_block_BF+0x49e>
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	8b 40 04             	mov    0x4(%eax),%eax
  802b9b:	a3 30 50 80 00       	mov    %eax,0x805030
  802ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba3:	8b 40 04             	mov    0x4(%eax),%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	74 0f                	je     802bb9 <alloc_block_BF+0x4b7>
  802baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bad:	8b 40 04             	mov    0x4(%eax),%eax
  802bb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb3:	8b 12                	mov    (%edx),%edx
  802bb5:	89 10                	mov    %edx,(%eax)
  802bb7:	eb 0a                	jmp    802bc3 <alloc_block_BF+0x4c1>
  802bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbc:	8b 00                	mov    (%eax),%eax
  802bbe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd6:	a1 38 50 80 00       	mov    0x805038,%eax
  802bdb:	48                   	dec    %eax
  802bdc:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be4:	e9 d9 00 00 00       	jmp    802cc2 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	83 c0 08             	add    $0x8,%eax
  802bef:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802bf2:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802bf9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bfc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bff:	01 d0                	add    %edx,%eax
  802c01:	48                   	dec    %eax
  802c02:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802c05:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c08:	ba 00 00 00 00       	mov    $0x0,%edx
  802c0d:	f7 75 c4             	divl   -0x3c(%ebp)
  802c10:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c13:	29 d0                	sub    %edx,%eax
  802c15:	c1 e8 0c             	shr    $0xc,%eax
  802c18:	83 ec 0c             	sub    $0xc,%esp
  802c1b:	50                   	push   %eax
  802c1c:	e8 49 e7 ff ff       	call   80136a <sbrk>
  802c21:	83 c4 10             	add    $0x10,%esp
  802c24:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c27:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c2b:	75 0a                	jne    802c37 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c32:	e9 8b 00 00 00       	jmp    802cc2 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c37:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c3e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c41:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c44:	01 d0                	add    %edx,%eax
  802c46:	48                   	dec    %eax
  802c47:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c4a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c4d:	ba 00 00 00 00       	mov    $0x0,%edx
  802c52:	f7 75 b8             	divl   -0x48(%ebp)
  802c55:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c58:	29 d0                	sub    %edx,%eax
  802c5a:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c5d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c60:	01 d0                	add    %edx,%eax
  802c62:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c67:	a1 40 50 80 00       	mov    0x805040,%eax
  802c6c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c72:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c79:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c7c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c7f:	01 d0                	add    %edx,%eax
  802c81:	48                   	dec    %eax
  802c82:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c85:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c88:	ba 00 00 00 00       	mov    $0x0,%edx
  802c8d:	f7 75 b0             	divl   -0x50(%ebp)
  802c90:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c93:	29 d0                	sub    %edx,%eax
  802c95:	83 ec 04             	sub    $0x4,%esp
  802c98:	6a 01                	push   $0x1
  802c9a:	50                   	push   %eax
  802c9b:	ff 75 bc             	pushl  -0x44(%ebp)
  802c9e:	e8 74 f5 ff ff       	call   802217 <set_block_data>
  802ca3:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802ca6:	83 ec 0c             	sub    $0xc,%esp
  802ca9:	ff 75 bc             	pushl  -0x44(%ebp)
  802cac:	e8 36 04 00 00       	call   8030e7 <free_block>
  802cb1:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802cb4:	83 ec 0c             	sub    $0xc,%esp
  802cb7:	ff 75 08             	pushl  0x8(%ebp)
  802cba:	e8 43 fa ff ff       	call   802702 <alloc_block_BF>
  802cbf:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802cc2:	c9                   	leave  
  802cc3:	c3                   	ret    

00802cc4 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802cc4:	55                   	push   %ebp
  802cc5:	89 e5                	mov    %esp,%ebp
  802cc7:	53                   	push   %ebx
  802cc8:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ccb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802cd2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cdd:	74 1e                	je     802cfd <merging+0x39>
  802cdf:	ff 75 08             	pushl  0x8(%ebp)
  802ce2:	e8 df f1 ff ff       	call   801ec6 <get_block_size>
  802ce7:	83 c4 04             	add    $0x4,%esp
  802cea:	89 c2                	mov    %eax,%edx
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	01 d0                	add    %edx,%eax
  802cf1:	3b 45 10             	cmp    0x10(%ebp),%eax
  802cf4:	75 07                	jne    802cfd <merging+0x39>
		prev_is_free = 1;
  802cf6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802cfd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d01:	74 1e                	je     802d21 <merging+0x5d>
  802d03:	ff 75 10             	pushl  0x10(%ebp)
  802d06:	e8 bb f1 ff ff       	call   801ec6 <get_block_size>
  802d0b:	83 c4 04             	add    $0x4,%esp
  802d0e:	89 c2                	mov    %eax,%edx
  802d10:	8b 45 10             	mov    0x10(%ebp),%eax
  802d13:	01 d0                	add    %edx,%eax
  802d15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d18:	75 07                	jne    802d21 <merging+0x5d>
		next_is_free = 1;
  802d1a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d25:	0f 84 cc 00 00 00    	je     802df7 <merging+0x133>
  802d2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d2f:	0f 84 c2 00 00 00    	je     802df7 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d35:	ff 75 08             	pushl  0x8(%ebp)
  802d38:	e8 89 f1 ff ff       	call   801ec6 <get_block_size>
  802d3d:	83 c4 04             	add    $0x4,%esp
  802d40:	89 c3                	mov    %eax,%ebx
  802d42:	ff 75 10             	pushl  0x10(%ebp)
  802d45:	e8 7c f1 ff ff       	call   801ec6 <get_block_size>
  802d4a:	83 c4 04             	add    $0x4,%esp
  802d4d:	01 c3                	add    %eax,%ebx
  802d4f:	ff 75 0c             	pushl  0xc(%ebp)
  802d52:	e8 6f f1 ff ff       	call   801ec6 <get_block_size>
  802d57:	83 c4 04             	add    $0x4,%esp
  802d5a:	01 d8                	add    %ebx,%eax
  802d5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d5f:	6a 00                	push   $0x0
  802d61:	ff 75 ec             	pushl  -0x14(%ebp)
  802d64:	ff 75 08             	pushl  0x8(%ebp)
  802d67:	e8 ab f4 ff ff       	call   802217 <set_block_data>
  802d6c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d73:	75 17                	jne    802d8c <merging+0xc8>
  802d75:	83 ec 04             	sub    $0x4,%esp
  802d78:	68 b7 43 80 00       	push   $0x8043b7
  802d7d:	68 7d 01 00 00       	push   $0x17d
  802d82:	68 d5 43 80 00       	push   $0x8043d5
  802d87:	e8 dc 0b 00 00       	call   803968 <_panic>
  802d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8f:	8b 00                	mov    (%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 10                	je     802da5 <merging+0xe1>
  802d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d9d:	8b 52 04             	mov    0x4(%edx),%edx
  802da0:	89 50 04             	mov    %edx,0x4(%eax)
  802da3:	eb 0b                	jmp    802db0 <merging+0xec>
  802da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da8:	8b 40 04             	mov    0x4(%eax),%eax
  802dab:	a3 30 50 80 00       	mov    %eax,0x805030
  802db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db3:	8b 40 04             	mov    0x4(%eax),%eax
  802db6:	85 c0                	test   %eax,%eax
  802db8:	74 0f                	je     802dc9 <merging+0x105>
  802dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dbd:	8b 40 04             	mov    0x4(%eax),%eax
  802dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc3:	8b 12                	mov    (%edx),%edx
  802dc5:	89 10                	mov    %edx,(%eax)
  802dc7:	eb 0a                	jmp    802dd3 <merging+0x10f>
  802dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcc:	8b 00                	mov    (%eax),%eax
  802dce:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ddf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de6:	a1 38 50 80 00       	mov    0x805038,%eax
  802deb:	48                   	dec    %eax
  802dec:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802df1:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802df2:	e9 ea 02 00 00       	jmp    8030e1 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802df7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfb:	74 3b                	je     802e38 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802dfd:	83 ec 0c             	sub    $0xc,%esp
  802e00:	ff 75 08             	pushl  0x8(%ebp)
  802e03:	e8 be f0 ff ff       	call   801ec6 <get_block_size>
  802e08:	83 c4 10             	add    $0x10,%esp
  802e0b:	89 c3                	mov    %eax,%ebx
  802e0d:	83 ec 0c             	sub    $0xc,%esp
  802e10:	ff 75 10             	pushl  0x10(%ebp)
  802e13:	e8 ae f0 ff ff       	call   801ec6 <get_block_size>
  802e18:	83 c4 10             	add    $0x10,%esp
  802e1b:	01 d8                	add    %ebx,%eax
  802e1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e20:	83 ec 04             	sub    $0x4,%esp
  802e23:	6a 00                	push   $0x0
  802e25:	ff 75 e8             	pushl  -0x18(%ebp)
  802e28:	ff 75 08             	pushl  0x8(%ebp)
  802e2b:	e8 e7 f3 ff ff       	call   802217 <set_block_data>
  802e30:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e33:	e9 a9 02 00 00       	jmp    8030e1 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e3c:	0f 84 2d 01 00 00    	je     802f6f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e42:	83 ec 0c             	sub    $0xc,%esp
  802e45:	ff 75 10             	pushl  0x10(%ebp)
  802e48:	e8 79 f0 ff ff       	call   801ec6 <get_block_size>
  802e4d:	83 c4 10             	add    $0x10,%esp
  802e50:	89 c3                	mov    %eax,%ebx
  802e52:	83 ec 0c             	sub    $0xc,%esp
  802e55:	ff 75 0c             	pushl  0xc(%ebp)
  802e58:	e8 69 f0 ff ff       	call   801ec6 <get_block_size>
  802e5d:	83 c4 10             	add    $0x10,%esp
  802e60:	01 d8                	add    %ebx,%eax
  802e62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	6a 00                	push   $0x0
  802e6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e6d:	ff 75 10             	pushl  0x10(%ebp)
  802e70:	e8 a2 f3 ff ff       	call   802217 <set_block_data>
  802e75:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e78:	8b 45 10             	mov    0x10(%ebp),%eax
  802e7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e82:	74 06                	je     802e8a <merging+0x1c6>
  802e84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e88:	75 17                	jne    802ea1 <merging+0x1dd>
  802e8a:	83 ec 04             	sub    $0x4,%esp
  802e8d:	68 7c 44 80 00       	push   $0x80447c
  802e92:	68 8d 01 00 00       	push   $0x18d
  802e97:	68 d5 43 80 00       	push   $0x8043d5
  802e9c:	e8 c7 0a 00 00       	call   803968 <_panic>
  802ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea4:	8b 50 04             	mov    0x4(%eax),%edx
  802ea7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eaa:	89 50 04             	mov    %edx,0x4(%eax)
  802ead:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb3:	89 10                	mov    %edx,(%eax)
  802eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb8:	8b 40 04             	mov    0x4(%eax),%eax
  802ebb:	85 c0                	test   %eax,%eax
  802ebd:	74 0d                	je     802ecc <merging+0x208>
  802ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ec2:	8b 40 04             	mov    0x4(%eax),%eax
  802ec5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ec8:	89 10                	mov    %edx,(%eax)
  802eca:	eb 08                	jmp    802ed4 <merging+0x210>
  802ecc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ecf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eda:	89 50 04             	mov    %edx,0x4(%eax)
  802edd:	a1 38 50 80 00       	mov    0x805038,%eax
  802ee2:	40                   	inc    %eax
  802ee3:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802ee8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802eec:	75 17                	jne    802f05 <merging+0x241>
  802eee:	83 ec 04             	sub    $0x4,%esp
  802ef1:	68 b7 43 80 00       	push   $0x8043b7
  802ef6:	68 8e 01 00 00       	push   $0x18e
  802efb:	68 d5 43 80 00       	push   $0x8043d5
  802f00:	e8 63 0a 00 00       	call   803968 <_panic>
  802f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f08:	8b 00                	mov    (%eax),%eax
  802f0a:	85 c0                	test   %eax,%eax
  802f0c:	74 10                	je     802f1e <merging+0x25a>
  802f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f16:	8b 52 04             	mov    0x4(%edx),%edx
  802f19:	89 50 04             	mov    %edx,0x4(%eax)
  802f1c:	eb 0b                	jmp    802f29 <merging+0x265>
  802f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f21:	8b 40 04             	mov    0x4(%eax),%eax
  802f24:	a3 30 50 80 00       	mov    %eax,0x805030
  802f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f2c:	8b 40 04             	mov    0x4(%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 0f                	je     802f42 <merging+0x27e>
  802f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f36:	8b 40 04             	mov    0x4(%eax),%eax
  802f39:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f3c:	8b 12                	mov    (%edx),%edx
  802f3e:	89 10                	mov    %edx,(%eax)
  802f40:	eb 0a                	jmp    802f4c <merging+0x288>
  802f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5f:	a1 38 50 80 00       	mov    0x805038,%eax
  802f64:	48                   	dec    %eax
  802f65:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f6a:	e9 72 01 00 00       	jmp    8030e1 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f6f:	8b 45 10             	mov    0x10(%ebp),%eax
  802f72:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f79:	74 79                	je     802ff4 <merging+0x330>
  802f7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f7f:	74 73                	je     802ff4 <merging+0x330>
  802f81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f85:	74 06                	je     802f8d <merging+0x2c9>
  802f87:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f8b:	75 17                	jne    802fa4 <merging+0x2e0>
  802f8d:	83 ec 04             	sub    $0x4,%esp
  802f90:	68 48 44 80 00       	push   $0x804448
  802f95:	68 94 01 00 00       	push   $0x194
  802f9a:	68 d5 43 80 00       	push   $0x8043d5
  802f9f:	e8 c4 09 00 00       	call   803968 <_panic>
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	8b 10                	mov    (%eax),%edx
  802fa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fac:	89 10                	mov    %edx,(%eax)
  802fae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb1:	8b 00                	mov    (%eax),%eax
  802fb3:	85 c0                	test   %eax,%eax
  802fb5:	74 0b                	je     802fc2 <merging+0x2fe>
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	8b 00                	mov    (%eax),%eax
  802fbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fbf:	89 50 04             	mov    %edx,0x4(%eax)
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fc8:	89 10                	mov    %edx,(%eax)
  802fca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd0:	89 50 04             	mov    %edx,0x4(%eax)
  802fd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	75 08                	jne    802fe4 <merging+0x320>
  802fdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdf:	a3 30 50 80 00       	mov    %eax,0x805030
  802fe4:	a1 38 50 80 00       	mov    0x805038,%eax
  802fe9:	40                   	inc    %eax
  802fea:	a3 38 50 80 00       	mov    %eax,0x805038
  802fef:	e9 ce 00 00 00       	jmp    8030c2 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802ff4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff8:	74 65                	je     80305f <merging+0x39b>
  802ffa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ffe:	75 17                	jne    803017 <merging+0x353>
  803000:	83 ec 04             	sub    $0x4,%esp
  803003:	68 24 44 80 00       	push   $0x804424
  803008:	68 95 01 00 00       	push   $0x195
  80300d:	68 d5 43 80 00       	push   $0x8043d5
  803012:	e8 51 09 00 00       	call   803968 <_panic>
  803017:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80301d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803020:	89 50 04             	mov    %edx,0x4(%eax)
  803023:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803026:	8b 40 04             	mov    0x4(%eax),%eax
  803029:	85 c0                	test   %eax,%eax
  80302b:	74 0c                	je     803039 <merging+0x375>
  80302d:	a1 30 50 80 00       	mov    0x805030,%eax
  803032:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803035:	89 10                	mov    %edx,(%eax)
  803037:	eb 08                	jmp    803041 <merging+0x37d>
  803039:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80303c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803041:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803044:	a3 30 50 80 00       	mov    %eax,0x805030
  803049:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803052:	a1 38 50 80 00       	mov    0x805038,%eax
  803057:	40                   	inc    %eax
  803058:	a3 38 50 80 00       	mov    %eax,0x805038
  80305d:	eb 63                	jmp    8030c2 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  80305f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803063:	75 17                	jne    80307c <merging+0x3b8>
  803065:	83 ec 04             	sub    $0x4,%esp
  803068:	68 f0 43 80 00       	push   $0x8043f0
  80306d:	68 98 01 00 00       	push   $0x198
  803072:	68 d5 43 80 00       	push   $0x8043d5
  803077:	e8 ec 08 00 00       	call   803968 <_panic>
  80307c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803082:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803085:	89 10                	mov    %edx,(%eax)
  803087:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	85 c0                	test   %eax,%eax
  80308e:	74 0d                	je     80309d <merging+0x3d9>
  803090:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803095:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803098:	89 50 04             	mov    %edx,0x4(%eax)
  80309b:	eb 08                	jmp    8030a5 <merging+0x3e1>
  80309d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a0:	a3 30 50 80 00       	mov    %eax,0x805030
  8030a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030a8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8030bc:	40                   	inc    %eax
  8030bd:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8030c2:	83 ec 0c             	sub    $0xc,%esp
  8030c5:	ff 75 10             	pushl  0x10(%ebp)
  8030c8:	e8 f9 ed ff ff       	call   801ec6 <get_block_size>
  8030cd:	83 c4 10             	add    $0x10,%esp
  8030d0:	83 ec 04             	sub    $0x4,%esp
  8030d3:	6a 00                	push   $0x0
  8030d5:	50                   	push   %eax
  8030d6:	ff 75 10             	pushl  0x10(%ebp)
  8030d9:	e8 39 f1 ff ff       	call   802217 <set_block_data>
  8030de:	83 c4 10             	add    $0x10,%esp
	}
}
  8030e1:	90                   	nop
  8030e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030e5:	c9                   	leave  
  8030e6:	c3                   	ret    

008030e7 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030e7:	55                   	push   %ebp
  8030e8:	89 e5                	mov    %esp,%ebp
  8030ea:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030ed:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030f2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  8030f5:	a1 30 50 80 00       	mov    0x805030,%eax
  8030fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030fd:	73 1b                	jae    80311a <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  8030ff:	a1 30 50 80 00       	mov    0x805030,%eax
  803104:	83 ec 04             	sub    $0x4,%esp
  803107:	ff 75 08             	pushl  0x8(%ebp)
  80310a:	6a 00                	push   $0x0
  80310c:	50                   	push   %eax
  80310d:	e8 b2 fb ff ff       	call   802cc4 <merging>
  803112:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803115:	e9 8b 00 00 00       	jmp    8031a5 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80311a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80311f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803122:	76 18                	jbe    80313c <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803124:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803129:	83 ec 04             	sub    $0x4,%esp
  80312c:	ff 75 08             	pushl  0x8(%ebp)
  80312f:	50                   	push   %eax
  803130:	6a 00                	push   $0x0
  803132:	e8 8d fb ff ff       	call   802cc4 <merging>
  803137:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80313a:	eb 69                	jmp    8031a5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80313c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803141:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803144:	eb 39                	jmp    80317f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803149:	3b 45 08             	cmp    0x8(%ebp),%eax
  80314c:	73 29                	jae    803177 <free_block+0x90>
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	8b 00                	mov    (%eax),%eax
  803153:	3b 45 08             	cmp    0x8(%ebp),%eax
  803156:	76 1f                	jbe    803177 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803160:	83 ec 04             	sub    $0x4,%esp
  803163:	ff 75 08             	pushl  0x8(%ebp)
  803166:	ff 75 f0             	pushl  -0x10(%ebp)
  803169:	ff 75 f4             	pushl  -0xc(%ebp)
  80316c:	e8 53 fb ff ff       	call   802cc4 <merging>
  803171:	83 c4 10             	add    $0x10,%esp
			break;
  803174:	90                   	nop
		}
	}
}
  803175:	eb 2e                	jmp    8031a5 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803177:	a1 34 50 80 00       	mov    0x805034,%eax
  80317c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80317f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803183:	74 07                	je     80318c <free_block+0xa5>
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	8b 00                	mov    (%eax),%eax
  80318a:	eb 05                	jmp    803191 <free_block+0xaa>
  80318c:	b8 00 00 00 00       	mov    $0x0,%eax
  803191:	a3 34 50 80 00       	mov    %eax,0x805034
  803196:	a1 34 50 80 00       	mov    0x805034,%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	75 a7                	jne    803146 <free_block+0x5f>
  80319f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a3:	75 a1                	jne    803146 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031a5:	90                   	nop
  8031a6:	c9                   	leave  
  8031a7:	c3                   	ret    

008031a8 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8031a8:	55                   	push   %ebp
  8031a9:	89 e5                	mov    %esp,%ebp
  8031ab:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8031ae:	ff 75 08             	pushl  0x8(%ebp)
  8031b1:	e8 10 ed ff ff       	call   801ec6 <get_block_size>
  8031b6:	83 c4 04             	add    $0x4,%esp
  8031b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8031bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8031c3:	eb 17                	jmp    8031dc <copy_data+0x34>
  8031c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031cb:	01 c2                	add    %eax,%edx
  8031cd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d3:	01 c8                	add    %ecx,%eax
  8031d5:	8a 00                	mov    (%eax),%al
  8031d7:	88 02                	mov    %al,(%edx)
  8031d9:	ff 45 fc             	incl   -0x4(%ebp)
  8031dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031e2:	72 e1                	jb     8031c5 <copy_data+0x1d>
}
  8031e4:	90                   	nop
  8031e5:	c9                   	leave  
  8031e6:	c3                   	ret    

008031e7 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031e7:	55                   	push   %ebp
  8031e8:	89 e5                	mov    %esp,%ebp
  8031ea:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f1:	75 23                	jne    803216 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8031f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8031f7:	74 13                	je     80320c <realloc_block_FF+0x25>
  8031f9:	83 ec 0c             	sub    $0xc,%esp
  8031fc:	ff 75 0c             	pushl  0xc(%ebp)
  8031ff:	e8 42 f0 ff ff       	call   802246 <alloc_block_FF>
  803204:	83 c4 10             	add    $0x10,%esp
  803207:	e9 e4 06 00 00       	jmp    8038f0 <realloc_block_FF+0x709>
		return NULL;
  80320c:	b8 00 00 00 00       	mov    $0x0,%eax
  803211:	e9 da 06 00 00       	jmp    8038f0 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  803216:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80321a:	75 18                	jne    803234 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80321c:	83 ec 0c             	sub    $0xc,%esp
  80321f:	ff 75 08             	pushl  0x8(%ebp)
  803222:	e8 c0 fe ff ff       	call   8030e7 <free_block>
  803227:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80322a:	b8 00 00 00 00       	mov    $0x0,%eax
  80322f:	e9 bc 06 00 00       	jmp    8038f0 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803234:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803238:	77 07                	ja     803241 <realloc_block_FF+0x5a>
  80323a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803241:	8b 45 0c             	mov    0xc(%ebp),%eax
  803244:	83 e0 01             	and    $0x1,%eax
  803247:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80324a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80324d:	83 c0 08             	add    $0x8,%eax
  803250:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803253:	83 ec 0c             	sub    $0xc,%esp
  803256:	ff 75 08             	pushl  0x8(%ebp)
  803259:	e8 68 ec ff ff       	call   801ec6 <get_block_size>
  80325e:	83 c4 10             	add    $0x10,%esp
  803261:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803264:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803267:	83 e8 08             	sub    $0x8,%eax
  80326a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	83 e8 04             	sub    $0x4,%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	83 e0 fe             	and    $0xfffffffe,%eax
  803278:	89 c2                	mov    %eax,%edx
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	01 d0                	add    %edx,%eax
  80327f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803282:	83 ec 0c             	sub    $0xc,%esp
  803285:	ff 75 e4             	pushl  -0x1c(%ebp)
  803288:	e8 39 ec ff ff       	call   801ec6 <get_block_size>
  80328d:	83 c4 10             	add    $0x10,%esp
  803290:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803293:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803296:	83 e8 08             	sub    $0x8,%eax
  803299:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80329c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032a2:	75 08                	jne    8032ac <realloc_block_FF+0xc5>
	{
		 return va;
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	e9 44 06 00 00       	jmp    8038f0 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8032ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032af:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032b2:	0f 83 d5 03 00 00    	jae    80368d <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bb:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032be:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8032c1:	83 ec 0c             	sub    $0xc,%esp
  8032c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032c7:	e8 13 ec ff ff       	call   801edf <is_free_block>
  8032cc:	83 c4 10             	add    $0x10,%esp
  8032cf:	84 c0                	test   %al,%al
  8032d1:	0f 84 3b 01 00 00    	je     803412 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8032d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032dd:	01 d0                	add    %edx,%eax
  8032df:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8032e2:	83 ec 04             	sub    $0x4,%esp
  8032e5:	6a 01                	push   $0x1
  8032e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8032ea:	ff 75 08             	pushl  0x8(%ebp)
  8032ed:	e8 25 ef ff ff       	call   802217 <set_block_data>
  8032f2:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	83 e8 04             	sub    $0x4,%eax
  8032fb:	8b 00                	mov    (%eax),%eax
  8032fd:	83 e0 fe             	and    $0xfffffffe,%eax
  803300:	89 c2                	mov    %eax,%edx
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	01 d0                	add    %edx,%eax
  803307:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80330a:	83 ec 04             	sub    $0x4,%esp
  80330d:	6a 00                	push   $0x0
  80330f:	ff 75 cc             	pushl  -0x34(%ebp)
  803312:	ff 75 c8             	pushl  -0x38(%ebp)
  803315:	e8 fd ee ff ff       	call   802217 <set_block_data>
  80331a:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80331d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803321:	74 06                	je     803329 <realloc_block_FF+0x142>
  803323:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803327:	75 17                	jne    803340 <realloc_block_FF+0x159>
  803329:	83 ec 04             	sub    $0x4,%esp
  80332c:	68 48 44 80 00       	push   $0x804448
  803331:	68 f6 01 00 00       	push   $0x1f6
  803336:	68 d5 43 80 00       	push   $0x8043d5
  80333b:	e8 28 06 00 00       	call   803968 <_panic>
  803340:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803343:	8b 10                	mov    (%eax),%edx
  803345:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803348:	89 10                	mov    %edx,(%eax)
  80334a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80334d:	8b 00                	mov    (%eax),%eax
  80334f:	85 c0                	test   %eax,%eax
  803351:	74 0b                	je     80335e <realloc_block_FF+0x177>
  803353:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803356:	8b 00                	mov    (%eax),%eax
  803358:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80335b:	89 50 04             	mov    %edx,0x4(%eax)
  80335e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803361:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803364:	89 10                	mov    %edx,(%eax)
  803366:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803369:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80336c:	89 50 04             	mov    %edx,0x4(%eax)
  80336f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803372:	8b 00                	mov    (%eax),%eax
  803374:	85 c0                	test   %eax,%eax
  803376:	75 08                	jne    803380 <realloc_block_FF+0x199>
  803378:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80337b:	a3 30 50 80 00       	mov    %eax,0x805030
  803380:	a1 38 50 80 00       	mov    0x805038,%eax
  803385:	40                   	inc    %eax
  803386:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80338b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80338f:	75 17                	jne    8033a8 <realloc_block_FF+0x1c1>
  803391:	83 ec 04             	sub    $0x4,%esp
  803394:	68 b7 43 80 00       	push   $0x8043b7
  803399:	68 f7 01 00 00       	push   $0x1f7
  80339e:	68 d5 43 80 00       	push   $0x8043d5
  8033a3:	e8 c0 05 00 00       	call   803968 <_panic>
  8033a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ab:	8b 00                	mov    (%eax),%eax
  8033ad:	85 c0                	test   %eax,%eax
  8033af:	74 10                	je     8033c1 <realloc_block_FF+0x1da>
  8033b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b4:	8b 00                	mov    (%eax),%eax
  8033b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033b9:	8b 52 04             	mov    0x4(%edx),%edx
  8033bc:	89 50 04             	mov    %edx,0x4(%eax)
  8033bf:	eb 0b                	jmp    8033cc <realloc_block_FF+0x1e5>
  8033c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c4:	8b 40 04             	mov    0x4(%eax),%eax
  8033c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8033cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cf:	8b 40 04             	mov    0x4(%eax),%eax
  8033d2:	85 c0                	test   %eax,%eax
  8033d4:	74 0f                	je     8033e5 <realloc_block_FF+0x1fe>
  8033d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d9:	8b 40 04             	mov    0x4(%eax),%eax
  8033dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033df:	8b 12                	mov    (%edx),%edx
  8033e1:	89 10                	mov    %edx,(%eax)
  8033e3:	eb 0a                	jmp    8033ef <realloc_block_FF+0x208>
  8033e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e8:	8b 00                	mov    (%eax),%eax
  8033ea:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803402:	a1 38 50 80 00       	mov    0x805038,%eax
  803407:	48                   	dec    %eax
  803408:	a3 38 50 80 00       	mov    %eax,0x805038
  80340d:	e9 73 02 00 00       	jmp    803685 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803412:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803416:	0f 86 69 02 00 00    	jbe    803685 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80341c:	83 ec 04             	sub    $0x4,%esp
  80341f:	6a 01                	push   $0x1
  803421:	ff 75 f0             	pushl  -0x10(%ebp)
  803424:	ff 75 08             	pushl  0x8(%ebp)
  803427:	e8 eb ed ff ff       	call   802217 <set_block_data>
  80342c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	83 e8 04             	sub    $0x4,%eax
  803435:	8b 00                	mov    (%eax),%eax
  803437:	83 e0 fe             	and    $0xfffffffe,%eax
  80343a:	89 c2                	mov    %eax,%edx
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	01 d0                	add    %edx,%eax
  803441:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803444:	a1 38 50 80 00       	mov    0x805038,%eax
  803449:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80344c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803450:	75 68                	jne    8034ba <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803452:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803456:	75 17                	jne    80346f <realloc_block_FF+0x288>
  803458:	83 ec 04             	sub    $0x4,%esp
  80345b:	68 f0 43 80 00       	push   $0x8043f0
  803460:	68 06 02 00 00       	push   $0x206
  803465:	68 d5 43 80 00       	push   $0x8043d5
  80346a:	e8 f9 04 00 00       	call   803968 <_panic>
  80346f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803475:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803478:	89 10                	mov    %edx,(%eax)
  80347a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	74 0d                	je     803490 <realloc_block_FF+0x2a9>
  803483:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803488:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80348b:	89 50 04             	mov    %edx,0x4(%eax)
  80348e:	eb 08                	jmp    803498 <realloc_block_FF+0x2b1>
  803490:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803493:	a3 30 50 80 00       	mov    %eax,0x805030
  803498:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8034af:	40                   	inc    %eax
  8034b0:	a3 38 50 80 00       	mov    %eax,0x805038
  8034b5:	e9 b0 01 00 00       	jmp    80366a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8034ba:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034bf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034c2:	76 68                	jbe    80352c <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034c4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034c8:	75 17                	jne    8034e1 <realloc_block_FF+0x2fa>
  8034ca:	83 ec 04             	sub    $0x4,%esp
  8034cd:	68 f0 43 80 00       	push   $0x8043f0
  8034d2:	68 0b 02 00 00       	push   $0x20b
  8034d7:	68 d5 43 80 00       	push   $0x8043d5
  8034dc:	e8 87 04 00 00       	call   803968 <_panic>
  8034e1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ea:	89 10                	mov    %edx,(%eax)
  8034ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ef:	8b 00                	mov    (%eax),%eax
  8034f1:	85 c0                	test   %eax,%eax
  8034f3:	74 0d                	je     803502 <realloc_block_FF+0x31b>
  8034f5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034fd:	89 50 04             	mov    %edx,0x4(%eax)
  803500:	eb 08                	jmp    80350a <realloc_block_FF+0x323>
  803502:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803505:	a3 30 50 80 00       	mov    %eax,0x805030
  80350a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80350d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803512:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803515:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351c:	a1 38 50 80 00       	mov    0x805038,%eax
  803521:	40                   	inc    %eax
  803522:	a3 38 50 80 00       	mov    %eax,0x805038
  803527:	e9 3e 01 00 00       	jmp    80366a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80352c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803531:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803534:	73 68                	jae    80359e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803536:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80353a:	75 17                	jne    803553 <realloc_block_FF+0x36c>
  80353c:	83 ec 04             	sub    $0x4,%esp
  80353f:	68 24 44 80 00       	push   $0x804424
  803544:	68 10 02 00 00       	push   $0x210
  803549:	68 d5 43 80 00       	push   $0x8043d5
  80354e:	e8 15 04 00 00       	call   803968 <_panic>
  803553:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803559:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355c:	89 50 04             	mov    %edx,0x4(%eax)
  80355f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803562:	8b 40 04             	mov    0x4(%eax),%eax
  803565:	85 c0                	test   %eax,%eax
  803567:	74 0c                	je     803575 <realloc_block_FF+0x38e>
  803569:	a1 30 50 80 00       	mov    0x805030,%eax
  80356e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803571:	89 10                	mov    %edx,(%eax)
  803573:	eb 08                	jmp    80357d <realloc_block_FF+0x396>
  803575:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803578:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80357d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803580:	a3 30 50 80 00       	mov    %eax,0x805030
  803585:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803588:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80358e:	a1 38 50 80 00       	mov    0x805038,%eax
  803593:	40                   	inc    %eax
  803594:	a3 38 50 80 00       	mov    %eax,0x805038
  803599:	e9 cc 00 00 00       	jmp    80366a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80359e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8035a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ad:	e9 8a 00 00 00       	jmp    80363c <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8035b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b5:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035b8:	73 7a                	jae    803634 <realloc_block_FF+0x44d>
  8035ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bd:	8b 00                	mov    (%eax),%eax
  8035bf:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035c2:	73 70                	jae    803634 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8035c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c8:	74 06                	je     8035d0 <realloc_block_FF+0x3e9>
  8035ca:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035ce:	75 17                	jne    8035e7 <realloc_block_FF+0x400>
  8035d0:	83 ec 04             	sub    $0x4,%esp
  8035d3:	68 48 44 80 00       	push   $0x804448
  8035d8:	68 1a 02 00 00       	push   $0x21a
  8035dd:	68 d5 43 80 00       	push   $0x8043d5
  8035e2:	e8 81 03 00 00       	call   803968 <_panic>
  8035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ea:	8b 10                	mov    (%eax),%edx
  8035ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035ef:	89 10                	mov    %edx,(%eax)
  8035f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f4:	8b 00                	mov    (%eax),%eax
  8035f6:	85 c0                	test   %eax,%eax
  8035f8:	74 0b                	je     803605 <realloc_block_FF+0x41e>
  8035fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fd:	8b 00                	mov    (%eax),%eax
  8035ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803602:	89 50 04             	mov    %edx,0x4(%eax)
  803605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803608:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80360b:	89 10                	mov    %edx,(%eax)
  80360d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803613:	89 50 04             	mov    %edx,0x4(%eax)
  803616:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803619:	8b 00                	mov    (%eax),%eax
  80361b:	85 c0                	test   %eax,%eax
  80361d:	75 08                	jne    803627 <realloc_block_FF+0x440>
  80361f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803622:	a3 30 50 80 00       	mov    %eax,0x805030
  803627:	a1 38 50 80 00       	mov    0x805038,%eax
  80362c:	40                   	inc    %eax
  80362d:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803632:	eb 36                	jmp    80366a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803634:	a1 34 50 80 00       	mov    0x805034,%eax
  803639:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80363c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803640:	74 07                	je     803649 <realloc_block_FF+0x462>
  803642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803645:	8b 00                	mov    (%eax),%eax
  803647:	eb 05                	jmp    80364e <realloc_block_FF+0x467>
  803649:	b8 00 00 00 00       	mov    $0x0,%eax
  80364e:	a3 34 50 80 00       	mov    %eax,0x805034
  803653:	a1 34 50 80 00       	mov    0x805034,%eax
  803658:	85 c0                	test   %eax,%eax
  80365a:	0f 85 52 ff ff ff    	jne    8035b2 <realloc_block_FF+0x3cb>
  803660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803664:	0f 85 48 ff ff ff    	jne    8035b2 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80366a:	83 ec 04             	sub    $0x4,%esp
  80366d:	6a 00                	push   $0x0
  80366f:	ff 75 d8             	pushl  -0x28(%ebp)
  803672:	ff 75 d4             	pushl  -0x2c(%ebp)
  803675:	e8 9d eb ff ff       	call   802217 <set_block_data>
  80367a:	83 c4 10             	add    $0x10,%esp
				return va;
  80367d:	8b 45 08             	mov    0x8(%ebp),%eax
  803680:	e9 6b 02 00 00       	jmp    8038f0 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803685:	8b 45 08             	mov    0x8(%ebp),%eax
  803688:	e9 63 02 00 00       	jmp    8038f0 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  80368d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803690:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803693:	0f 86 4d 02 00 00    	jbe    8038e6 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803699:	83 ec 0c             	sub    $0xc,%esp
  80369c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80369f:	e8 3b e8 ff ff       	call   801edf <is_free_block>
  8036a4:	83 c4 10             	add    $0x10,%esp
  8036a7:	84 c0                	test   %al,%al
  8036a9:	0f 84 37 02 00 00    	je     8038e6 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8036af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8036b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8036b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036be:	76 38                	jbe    8036f8 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8036c0:	83 ec 0c             	sub    $0xc,%esp
  8036c3:	ff 75 0c             	pushl  0xc(%ebp)
  8036c6:	e8 7b eb ff ff       	call   802246 <alloc_block_FF>
  8036cb:	83 c4 10             	add    $0x10,%esp
  8036ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8036d1:	83 ec 08             	sub    $0x8,%esp
  8036d4:	ff 75 c0             	pushl  -0x40(%ebp)
  8036d7:	ff 75 08             	pushl  0x8(%ebp)
  8036da:	e8 c9 fa ff ff       	call   8031a8 <copy_data>
  8036df:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8036e2:	83 ec 0c             	sub    $0xc,%esp
  8036e5:	ff 75 08             	pushl  0x8(%ebp)
  8036e8:	e8 fa f9 ff ff       	call   8030e7 <free_block>
  8036ed:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8036f0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8036f3:	e9 f8 01 00 00       	jmp    8038f0 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8036f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036fb:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8036fe:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803701:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803705:	0f 87 a0 00 00 00    	ja     8037ab <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80370b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80370f:	75 17                	jne    803728 <realloc_block_FF+0x541>
  803711:	83 ec 04             	sub    $0x4,%esp
  803714:	68 b7 43 80 00       	push   $0x8043b7
  803719:	68 38 02 00 00       	push   $0x238
  80371e:	68 d5 43 80 00       	push   $0x8043d5
  803723:	e8 40 02 00 00       	call   803968 <_panic>
  803728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372b:	8b 00                	mov    (%eax),%eax
  80372d:	85 c0                	test   %eax,%eax
  80372f:	74 10                	je     803741 <realloc_block_FF+0x55a>
  803731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803734:	8b 00                	mov    (%eax),%eax
  803736:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803739:	8b 52 04             	mov    0x4(%edx),%edx
  80373c:	89 50 04             	mov    %edx,0x4(%eax)
  80373f:	eb 0b                	jmp    80374c <realloc_block_FF+0x565>
  803741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803744:	8b 40 04             	mov    0x4(%eax),%eax
  803747:	a3 30 50 80 00       	mov    %eax,0x805030
  80374c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374f:	8b 40 04             	mov    0x4(%eax),%eax
  803752:	85 c0                	test   %eax,%eax
  803754:	74 0f                	je     803765 <realloc_block_FF+0x57e>
  803756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803759:	8b 40 04             	mov    0x4(%eax),%eax
  80375c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80375f:	8b 12                	mov    (%edx),%edx
  803761:	89 10                	mov    %edx,(%eax)
  803763:	eb 0a                	jmp    80376f <realloc_block_FF+0x588>
  803765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803768:	8b 00                	mov    (%eax),%eax
  80376a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80376f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803772:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803782:	a1 38 50 80 00       	mov    0x805038,%eax
  803787:	48                   	dec    %eax
  803788:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80378d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803793:	01 d0                	add    %edx,%eax
  803795:	83 ec 04             	sub    $0x4,%esp
  803798:	6a 01                	push   $0x1
  80379a:	50                   	push   %eax
  80379b:	ff 75 08             	pushl  0x8(%ebp)
  80379e:	e8 74 ea ff ff       	call   802217 <set_block_data>
  8037a3:	83 c4 10             	add    $0x10,%esp
  8037a6:	e9 36 01 00 00       	jmp    8038e1 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8037ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037b1:	01 d0                	add    %edx,%eax
  8037b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8037b6:	83 ec 04             	sub    $0x4,%esp
  8037b9:	6a 01                	push   $0x1
  8037bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8037be:	ff 75 08             	pushl  0x8(%ebp)
  8037c1:	e8 51 ea ff ff       	call   802217 <set_block_data>
  8037c6:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cc:	83 e8 04             	sub    $0x4,%eax
  8037cf:	8b 00                	mov    (%eax),%eax
  8037d1:	83 e0 fe             	and    $0xfffffffe,%eax
  8037d4:	89 c2                	mov    %eax,%edx
  8037d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d9:	01 d0                	add    %edx,%eax
  8037db:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8037de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037e2:	74 06                	je     8037ea <realloc_block_FF+0x603>
  8037e4:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8037e8:	75 17                	jne    803801 <realloc_block_FF+0x61a>
  8037ea:	83 ec 04             	sub    $0x4,%esp
  8037ed:	68 48 44 80 00       	push   $0x804448
  8037f2:	68 44 02 00 00       	push   $0x244
  8037f7:	68 d5 43 80 00       	push   $0x8043d5
  8037fc:	e8 67 01 00 00       	call   803968 <_panic>
  803801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803804:	8b 10                	mov    (%eax),%edx
  803806:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803809:	89 10                	mov    %edx,(%eax)
  80380b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80380e:	8b 00                	mov    (%eax),%eax
  803810:	85 c0                	test   %eax,%eax
  803812:	74 0b                	je     80381f <realloc_block_FF+0x638>
  803814:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803817:	8b 00                	mov    (%eax),%eax
  803819:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80381c:	89 50 04             	mov    %edx,0x4(%eax)
  80381f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803822:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803825:	89 10                	mov    %edx,(%eax)
  803827:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80382a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80382d:	89 50 04             	mov    %edx,0x4(%eax)
  803830:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803833:	8b 00                	mov    (%eax),%eax
  803835:	85 c0                	test   %eax,%eax
  803837:	75 08                	jne    803841 <realloc_block_FF+0x65a>
  803839:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80383c:	a3 30 50 80 00       	mov    %eax,0x805030
  803841:	a1 38 50 80 00       	mov    0x805038,%eax
  803846:	40                   	inc    %eax
  803847:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80384c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803850:	75 17                	jne    803869 <realloc_block_FF+0x682>
  803852:	83 ec 04             	sub    $0x4,%esp
  803855:	68 b7 43 80 00       	push   $0x8043b7
  80385a:	68 45 02 00 00       	push   $0x245
  80385f:	68 d5 43 80 00       	push   $0x8043d5
  803864:	e8 ff 00 00 00       	call   803968 <_panic>
  803869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80386c:	8b 00                	mov    (%eax),%eax
  80386e:	85 c0                	test   %eax,%eax
  803870:	74 10                	je     803882 <realloc_block_FF+0x69b>
  803872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803875:	8b 00                	mov    (%eax),%eax
  803877:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387a:	8b 52 04             	mov    0x4(%edx),%edx
  80387d:	89 50 04             	mov    %edx,0x4(%eax)
  803880:	eb 0b                	jmp    80388d <realloc_block_FF+0x6a6>
  803882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803885:	8b 40 04             	mov    0x4(%eax),%eax
  803888:	a3 30 50 80 00       	mov    %eax,0x805030
  80388d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803890:	8b 40 04             	mov    0x4(%eax),%eax
  803893:	85 c0                	test   %eax,%eax
  803895:	74 0f                	je     8038a6 <realloc_block_FF+0x6bf>
  803897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389a:	8b 40 04             	mov    0x4(%eax),%eax
  80389d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038a0:	8b 12                	mov    (%edx),%edx
  8038a2:	89 10                	mov    %edx,(%eax)
  8038a4:	eb 0a                	jmp    8038b0 <realloc_block_FF+0x6c9>
  8038a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a9:	8b 00                	mov    (%eax),%eax
  8038ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8038c8:	48                   	dec    %eax
  8038c9:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8038ce:	83 ec 04             	sub    $0x4,%esp
  8038d1:	6a 00                	push   $0x0
  8038d3:	ff 75 bc             	pushl  -0x44(%ebp)
  8038d6:	ff 75 b8             	pushl  -0x48(%ebp)
  8038d9:	e8 39 e9 ff ff       	call   802217 <set_block_data>
  8038de:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8038e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e4:	eb 0a                	jmp    8038f0 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8038e6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8038ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8038f0:	c9                   	leave  
  8038f1:	c3                   	ret    

008038f2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8038f2:	55                   	push   %ebp
  8038f3:	89 e5                	mov    %esp,%ebp
  8038f5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8038f8:	83 ec 04             	sub    $0x4,%esp
  8038fb:	68 b4 44 80 00       	push   $0x8044b4
  803900:	68 58 02 00 00       	push   $0x258
  803905:	68 d5 43 80 00       	push   $0x8043d5
  80390a:	e8 59 00 00 00       	call   803968 <_panic>

0080390f <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80390f:	55                   	push   %ebp
  803910:	89 e5                	mov    %esp,%ebp
  803912:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803915:	83 ec 04             	sub    $0x4,%esp
  803918:	68 dc 44 80 00       	push   $0x8044dc
  80391d:	68 61 02 00 00       	push   $0x261
  803922:	68 d5 43 80 00       	push   $0x8043d5
  803927:	e8 3c 00 00 00       	call   803968 <_panic>

0080392c <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80392c:	55                   	push   %ebp
  80392d:	89 e5                	mov    %esp,%ebp
  80392f:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  803932:	8b 45 08             	mov    0x8(%ebp),%eax
  803935:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  803938:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80393c:	83 ec 0c             	sub    $0xc,%esp
  80393f:	50                   	push   %eax
  803940:	e8 10 e1 ff ff       	call   801a55 <sys_cputc>
  803945:	83 c4 10             	add    $0x10,%esp
}
  803948:	90                   	nop
  803949:	c9                   	leave  
  80394a:	c3                   	ret    

0080394b <getchar>:


int
getchar(void)
{
  80394b:	55                   	push   %ebp
  80394c:	89 e5                	mov    %esp,%ebp
  80394e:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803951:	e8 9b df ff ff       	call   8018f1 <sys_cgetc>
  803956:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  803959:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80395c:	c9                   	leave  
  80395d:	c3                   	ret    

0080395e <iscons>:

int iscons(int fdnum)
{
  80395e:	55                   	push   %ebp
  80395f:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803961:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803966:	5d                   	pop    %ebp
  803967:	c3                   	ret    

00803968 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803968:	55                   	push   %ebp
  803969:	89 e5                	mov    %esp,%ebp
  80396b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80396e:	8d 45 10             	lea    0x10(%ebp),%eax
  803971:	83 c0 04             	add    $0x4,%eax
  803974:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803977:	a1 60 50 98 00       	mov    0x985060,%eax
  80397c:	85 c0                	test   %eax,%eax
  80397e:	74 16                	je     803996 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803980:	a1 60 50 98 00       	mov    0x985060,%eax
  803985:	83 ec 08             	sub    $0x8,%esp
  803988:	50                   	push   %eax
  803989:	68 04 45 80 00       	push   $0x804504
  80398e:	e8 35 ca ff ff       	call   8003c8 <cprintf>
  803993:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803996:	a1 00 50 80 00       	mov    0x805000,%eax
  80399b:	ff 75 0c             	pushl  0xc(%ebp)
  80399e:	ff 75 08             	pushl  0x8(%ebp)
  8039a1:	50                   	push   %eax
  8039a2:	68 09 45 80 00       	push   $0x804509
  8039a7:	e8 1c ca ff ff       	call   8003c8 <cprintf>
  8039ac:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8039af:	8b 45 10             	mov    0x10(%ebp),%eax
  8039b2:	83 ec 08             	sub    $0x8,%esp
  8039b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8039b8:	50                   	push   %eax
  8039b9:	e8 9f c9 ff ff       	call   80035d <vcprintf>
  8039be:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8039c1:	83 ec 08             	sub    $0x8,%esp
  8039c4:	6a 00                	push   $0x0
  8039c6:	68 25 45 80 00       	push   $0x804525
  8039cb:	e8 8d c9 ff ff       	call   80035d <vcprintf>
  8039d0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8039d3:	e8 0e c9 ff ff       	call   8002e6 <exit>

	// should not return here
	while (1) ;
  8039d8:	eb fe                	jmp    8039d8 <_panic+0x70>

008039da <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8039da:	55                   	push   %ebp
  8039db:	89 e5                	mov    %esp,%ebp
  8039dd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8039e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8039e5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ee:	39 c2                	cmp    %eax,%edx
  8039f0:	74 14                	je     803a06 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8039f2:	83 ec 04             	sub    $0x4,%esp
  8039f5:	68 28 45 80 00       	push   $0x804528
  8039fa:	6a 26                	push   $0x26
  8039fc:	68 74 45 80 00       	push   $0x804574
  803a01:	e8 62 ff ff ff       	call   803968 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803a0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a14:	e9 c5 00 00 00       	jmp    803ade <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a23:	8b 45 08             	mov    0x8(%ebp),%eax
  803a26:	01 d0                	add    %edx,%eax
  803a28:	8b 00                	mov    (%eax),%eax
  803a2a:	85 c0                	test   %eax,%eax
  803a2c:	75 08                	jne    803a36 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a2e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a31:	e9 a5 00 00 00       	jmp    803adb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a36:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a3d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a44:	eb 69                	jmp    803aaf <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a46:	a1 20 50 80 00       	mov    0x805020,%eax
  803a4b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a51:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a54:	89 d0                	mov    %edx,%eax
  803a56:	01 c0                	add    %eax,%eax
  803a58:	01 d0                	add    %edx,%eax
  803a5a:	c1 e0 03             	shl    $0x3,%eax
  803a5d:	01 c8                	add    %ecx,%eax
  803a5f:	8a 40 04             	mov    0x4(%eax),%al
  803a62:	84 c0                	test   %al,%al
  803a64:	75 46                	jne    803aac <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a66:	a1 20 50 80 00       	mov    0x805020,%eax
  803a6b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a74:	89 d0                	mov    %edx,%eax
  803a76:	01 c0                	add    %eax,%eax
  803a78:	01 d0                	add    %edx,%eax
  803a7a:	c1 e0 03             	shl    $0x3,%eax
  803a7d:	01 c8                	add    %ecx,%eax
  803a7f:	8b 00                	mov    (%eax),%eax
  803a81:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a8c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a91:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a98:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9b:	01 c8                	add    %ecx,%eax
  803a9d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a9f:	39 c2                	cmp    %eax,%edx
  803aa1:	75 09                	jne    803aac <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803aa3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803aaa:	eb 15                	jmp    803ac1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803aac:	ff 45 e8             	incl   -0x18(%ebp)
  803aaf:	a1 20 50 80 00       	mov    0x805020,%eax
  803ab4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803aba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803abd:	39 c2                	cmp    %eax,%edx
  803abf:	77 85                	ja     803a46 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803ac1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ac5:	75 14                	jne    803adb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803ac7:	83 ec 04             	sub    $0x4,%esp
  803aca:	68 80 45 80 00       	push   $0x804580
  803acf:	6a 3a                	push   $0x3a
  803ad1:	68 74 45 80 00       	push   $0x804574
  803ad6:	e8 8d fe ff ff       	call   803968 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803adb:	ff 45 f0             	incl   -0x10(%ebp)
  803ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ae4:	0f 8c 2f ff ff ff    	jl     803a19 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803aea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803af1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803af8:	eb 26                	jmp    803b20 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803afa:	a1 20 50 80 00       	mov    0x805020,%eax
  803aff:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b08:	89 d0                	mov    %edx,%eax
  803b0a:	01 c0                	add    %eax,%eax
  803b0c:	01 d0                	add    %edx,%eax
  803b0e:	c1 e0 03             	shl    $0x3,%eax
  803b11:	01 c8                	add    %ecx,%eax
  803b13:	8a 40 04             	mov    0x4(%eax),%al
  803b16:	3c 01                	cmp    $0x1,%al
  803b18:	75 03                	jne    803b1d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b1a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b1d:	ff 45 e0             	incl   -0x20(%ebp)
  803b20:	a1 20 50 80 00       	mov    0x805020,%eax
  803b25:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b2e:	39 c2                	cmp    %eax,%edx
  803b30:	77 c8                	ja     803afa <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b35:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b38:	74 14                	je     803b4e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b3a:	83 ec 04             	sub    $0x4,%esp
  803b3d:	68 d4 45 80 00       	push   $0x8045d4
  803b42:	6a 44                	push   $0x44
  803b44:	68 74 45 80 00       	push   $0x804574
  803b49:	e8 1a fe ff ff       	call   803968 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b4e:	90                   	nop
  803b4f:	c9                   	leave  
  803b50:	c3                   	ret    
  803b51:	66 90                	xchg   %ax,%ax
  803b53:	90                   	nop

00803b54 <__udivdi3>:
  803b54:	55                   	push   %ebp
  803b55:	57                   	push   %edi
  803b56:	56                   	push   %esi
  803b57:	53                   	push   %ebx
  803b58:	83 ec 1c             	sub    $0x1c,%esp
  803b5b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b5f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b6b:	89 ca                	mov    %ecx,%edx
  803b6d:	89 f8                	mov    %edi,%eax
  803b6f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b73:	85 f6                	test   %esi,%esi
  803b75:	75 2d                	jne    803ba4 <__udivdi3+0x50>
  803b77:	39 cf                	cmp    %ecx,%edi
  803b79:	77 65                	ja     803be0 <__udivdi3+0x8c>
  803b7b:	89 fd                	mov    %edi,%ebp
  803b7d:	85 ff                	test   %edi,%edi
  803b7f:	75 0b                	jne    803b8c <__udivdi3+0x38>
  803b81:	b8 01 00 00 00       	mov    $0x1,%eax
  803b86:	31 d2                	xor    %edx,%edx
  803b88:	f7 f7                	div    %edi
  803b8a:	89 c5                	mov    %eax,%ebp
  803b8c:	31 d2                	xor    %edx,%edx
  803b8e:	89 c8                	mov    %ecx,%eax
  803b90:	f7 f5                	div    %ebp
  803b92:	89 c1                	mov    %eax,%ecx
  803b94:	89 d8                	mov    %ebx,%eax
  803b96:	f7 f5                	div    %ebp
  803b98:	89 cf                	mov    %ecx,%edi
  803b9a:	89 fa                	mov    %edi,%edx
  803b9c:	83 c4 1c             	add    $0x1c,%esp
  803b9f:	5b                   	pop    %ebx
  803ba0:	5e                   	pop    %esi
  803ba1:	5f                   	pop    %edi
  803ba2:	5d                   	pop    %ebp
  803ba3:	c3                   	ret    
  803ba4:	39 ce                	cmp    %ecx,%esi
  803ba6:	77 28                	ja     803bd0 <__udivdi3+0x7c>
  803ba8:	0f bd fe             	bsr    %esi,%edi
  803bab:	83 f7 1f             	xor    $0x1f,%edi
  803bae:	75 40                	jne    803bf0 <__udivdi3+0x9c>
  803bb0:	39 ce                	cmp    %ecx,%esi
  803bb2:	72 0a                	jb     803bbe <__udivdi3+0x6a>
  803bb4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bb8:	0f 87 9e 00 00 00    	ja     803c5c <__udivdi3+0x108>
  803bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  803bc3:	89 fa                	mov    %edi,%edx
  803bc5:	83 c4 1c             	add    $0x1c,%esp
  803bc8:	5b                   	pop    %ebx
  803bc9:	5e                   	pop    %esi
  803bca:	5f                   	pop    %edi
  803bcb:	5d                   	pop    %ebp
  803bcc:	c3                   	ret    
  803bcd:	8d 76 00             	lea    0x0(%esi),%esi
  803bd0:	31 ff                	xor    %edi,%edi
  803bd2:	31 c0                	xor    %eax,%eax
  803bd4:	89 fa                	mov    %edi,%edx
  803bd6:	83 c4 1c             	add    $0x1c,%esp
  803bd9:	5b                   	pop    %ebx
  803bda:	5e                   	pop    %esi
  803bdb:	5f                   	pop    %edi
  803bdc:	5d                   	pop    %ebp
  803bdd:	c3                   	ret    
  803bde:	66 90                	xchg   %ax,%ax
  803be0:	89 d8                	mov    %ebx,%eax
  803be2:	f7 f7                	div    %edi
  803be4:	31 ff                	xor    %edi,%edi
  803be6:	89 fa                	mov    %edi,%edx
  803be8:	83 c4 1c             	add    $0x1c,%esp
  803beb:	5b                   	pop    %ebx
  803bec:	5e                   	pop    %esi
  803bed:	5f                   	pop    %edi
  803bee:	5d                   	pop    %ebp
  803bef:	c3                   	ret    
  803bf0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803bf5:	89 eb                	mov    %ebp,%ebx
  803bf7:	29 fb                	sub    %edi,%ebx
  803bf9:	89 f9                	mov    %edi,%ecx
  803bfb:	d3 e6                	shl    %cl,%esi
  803bfd:	89 c5                	mov    %eax,%ebp
  803bff:	88 d9                	mov    %bl,%cl
  803c01:	d3 ed                	shr    %cl,%ebp
  803c03:	89 e9                	mov    %ebp,%ecx
  803c05:	09 f1                	or     %esi,%ecx
  803c07:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c0b:	89 f9                	mov    %edi,%ecx
  803c0d:	d3 e0                	shl    %cl,%eax
  803c0f:	89 c5                	mov    %eax,%ebp
  803c11:	89 d6                	mov    %edx,%esi
  803c13:	88 d9                	mov    %bl,%cl
  803c15:	d3 ee                	shr    %cl,%esi
  803c17:	89 f9                	mov    %edi,%ecx
  803c19:	d3 e2                	shl    %cl,%edx
  803c1b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c1f:	88 d9                	mov    %bl,%cl
  803c21:	d3 e8                	shr    %cl,%eax
  803c23:	09 c2                	or     %eax,%edx
  803c25:	89 d0                	mov    %edx,%eax
  803c27:	89 f2                	mov    %esi,%edx
  803c29:	f7 74 24 0c          	divl   0xc(%esp)
  803c2d:	89 d6                	mov    %edx,%esi
  803c2f:	89 c3                	mov    %eax,%ebx
  803c31:	f7 e5                	mul    %ebp
  803c33:	39 d6                	cmp    %edx,%esi
  803c35:	72 19                	jb     803c50 <__udivdi3+0xfc>
  803c37:	74 0b                	je     803c44 <__udivdi3+0xf0>
  803c39:	89 d8                	mov    %ebx,%eax
  803c3b:	31 ff                	xor    %edi,%edi
  803c3d:	e9 58 ff ff ff       	jmp    803b9a <__udivdi3+0x46>
  803c42:	66 90                	xchg   %ax,%ax
  803c44:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c48:	89 f9                	mov    %edi,%ecx
  803c4a:	d3 e2                	shl    %cl,%edx
  803c4c:	39 c2                	cmp    %eax,%edx
  803c4e:	73 e9                	jae    803c39 <__udivdi3+0xe5>
  803c50:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c53:	31 ff                	xor    %edi,%edi
  803c55:	e9 40 ff ff ff       	jmp    803b9a <__udivdi3+0x46>
  803c5a:	66 90                	xchg   %ax,%ax
  803c5c:	31 c0                	xor    %eax,%eax
  803c5e:	e9 37 ff ff ff       	jmp    803b9a <__udivdi3+0x46>
  803c63:	90                   	nop

00803c64 <__umoddi3>:
  803c64:	55                   	push   %ebp
  803c65:	57                   	push   %edi
  803c66:	56                   	push   %esi
  803c67:	53                   	push   %ebx
  803c68:	83 ec 1c             	sub    $0x1c,%esp
  803c6b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c6f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c77:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c83:	89 f3                	mov    %esi,%ebx
  803c85:	89 fa                	mov    %edi,%edx
  803c87:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c8b:	89 34 24             	mov    %esi,(%esp)
  803c8e:	85 c0                	test   %eax,%eax
  803c90:	75 1a                	jne    803cac <__umoddi3+0x48>
  803c92:	39 f7                	cmp    %esi,%edi
  803c94:	0f 86 a2 00 00 00    	jbe    803d3c <__umoddi3+0xd8>
  803c9a:	89 c8                	mov    %ecx,%eax
  803c9c:	89 f2                	mov    %esi,%edx
  803c9e:	f7 f7                	div    %edi
  803ca0:	89 d0                	mov    %edx,%eax
  803ca2:	31 d2                	xor    %edx,%edx
  803ca4:	83 c4 1c             	add    $0x1c,%esp
  803ca7:	5b                   	pop    %ebx
  803ca8:	5e                   	pop    %esi
  803ca9:	5f                   	pop    %edi
  803caa:	5d                   	pop    %ebp
  803cab:	c3                   	ret    
  803cac:	39 f0                	cmp    %esi,%eax
  803cae:	0f 87 ac 00 00 00    	ja     803d60 <__umoddi3+0xfc>
  803cb4:	0f bd e8             	bsr    %eax,%ebp
  803cb7:	83 f5 1f             	xor    $0x1f,%ebp
  803cba:	0f 84 ac 00 00 00    	je     803d6c <__umoddi3+0x108>
  803cc0:	bf 20 00 00 00       	mov    $0x20,%edi
  803cc5:	29 ef                	sub    %ebp,%edi
  803cc7:	89 fe                	mov    %edi,%esi
  803cc9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ccd:	89 e9                	mov    %ebp,%ecx
  803ccf:	d3 e0                	shl    %cl,%eax
  803cd1:	89 d7                	mov    %edx,%edi
  803cd3:	89 f1                	mov    %esi,%ecx
  803cd5:	d3 ef                	shr    %cl,%edi
  803cd7:	09 c7                	or     %eax,%edi
  803cd9:	89 e9                	mov    %ebp,%ecx
  803cdb:	d3 e2                	shl    %cl,%edx
  803cdd:	89 14 24             	mov    %edx,(%esp)
  803ce0:	89 d8                	mov    %ebx,%eax
  803ce2:	d3 e0                	shl    %cl,%eax
  803ce4:	89 c2                	mov    %eax,%edx
  803ce6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cea:	d3 e0                	shl    %cl,%eax
  803cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cf0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803cf4:	89 f1                	mov    %esi,%ecx
  803cf6:	d3 e8                	shr    %cl,%eax
  803cf8:	09 d0                	or     %edx,%eax
  803cfa:	d3 eb                	shr    %cl,%ebx
  803cfc:	89 da                	mov    %ebx,%edx
  803cfe:	f7 f7                	div    %edi
  803d00:	89 d3                	mov    %edx,%ebx
  803d02:	f7 24 24             	mull   (%esp)
  803d05:	89 c6                	mov    %eax,%esi
  803d07:	89 d1                	mov    %edx,%ecx
  803d09:	39 d3                	cmp    %edx,%ebx
  803d0b:	0f 82 87 00 00 00    	jb     803d98 <__umoddi3+0x134>
  803d11:	0f 84 91 00 00 00    	je     803da8 <__umoddi3+0x144>
  803d17:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d1b:	29 f2                	sub    %esi,%edx
  803d1d:	19 cb                	sbb    %ecx,%ebx
  803d1f:	89 d8                	mov    %ebx,%eax
  803d21:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d25:	d3 e0                	shl    %cl,%eax
  803d27:	89 e9                	mov    %ebp,%ecx
  803d29:	d3 ea                	shr    %cl,%edx
  803d2b:	09 d0                	or     %edx,%eax
  803d2d:	89 e9                	mov    %ebp,%ecx
  803d2f:	d3 eb                	shr    %cl,%ebx
  803d31:	89 da                	mov    %ebx,%edx
  803d33:	83 c4 1c             	add    $0x1c,%esp
  803d36:	5b                   	pop    %ebx
  803d37:	5e                   	pop    %esi
  803d38:	5f                   	pop    %edi
  803d39:	5d                   	pop    %ebp
  803d3a:	c3                   	ret    
  803d3b:	90                   	nop
  803d3c:	89 fd                	mov    %edi,%ebp
  803d3e:	85 ff                	test   %edi,%edi
  803d40:	75 0b                	jne    803d4d <__umoddi3+0xe9>
  803d42:	b8 01 00 00 00       	mov    $0x1,%eax
  803d47:	31 d2                	xor    %edx,%edx
  803d49:	f7 f7                	div    %edi
  803d4b:	89 c5                	mov    %eax,%ebp
  803d4d:	89 f0                	mov    %esi,%eax
  803d4f:	31 d2                	xor    %edx,%edx
  803d51:	f7 f5                	div    %ebp
  803d53:	89 c8                	mov    %ecx,%eax
  803d55:	f7 f5                	div    %ebp
  803d57:	89 d0                	mov    %edx,%eax
  803d59:	e9 44 ff ff ff       	jmp    803ca2 <__umoddi3+0x3e>
  803d5e:	66 90                	xchg   %ax,%ax
  803d60:	89 c8                	mov    %ecx,%eax
  803d62:	89 f2                	mov    %esi,%edx
  803d64:	83 c4 1c             	add    $0x1c,%esp
  803d67:	5b                   	pop    %ebx
  803d68:	5e                   	pop    %esi
  803d69:	5f                   	pop    %edi
  803d6a:	5d                   	pop    %ebp
  803d6b:	c3                   	ret    
  803d6c:	3b 04 24             	cmp    (%esp),%eax
  803d6f:	72 06                	jb     803d77 <__umoddi3+0x113>
  803d71:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d75:	77 0f                	ja     803d86 <__umoddi3+0x122>
  803d77:	89 f2                	mov    %esi,%edx
  803d79:	29 f9                	sub    %edi,%ecx
  803d7b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d7f:	89 14 24             	mov    %edx,(%esp)
  803d82:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d86:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d8a:	8b 14 24             	mov    (%esp),%edx
  803d8d:	83 c4 1c             	add    $0x1c,%esp
  803d90:	5b                   	pop    %ebx
  803d91:	5e                   	pop    %esi
  803d92:	5f                   	pop    %edi
  803d93:	5d                   	pop    %ebp
  803d94:	c3                   	ret    
  803d95:	8d 76 00             	lea    0x0(%esi),%esi
  803d98:	2b 04 24             	sub    (%esp),%eax
  803d9b:	19 fa                	sbb    %edi,%edx
  803d9d:	89 d1                	mov    %edx,%ecx
  803d9f:	89 c6                	mov    %eax,%esi
  803da1:	e9 71 ff ff ff       	jmp    803d17 <__umoddi3+0xb3>
  803da6:	66 90                	xchg   %ax,%ax
  803da8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dac:	72 ea                	jb     803d98 <__umoddi3+0x134>
  803dae:	89 d9                	mov    %ebx,%ecx
  803db0:	e9 62 ff ff ff       	jmp    803d17 <__umoddi3+0xb3>
