
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
  800052:	68 e0 3d 80 00       	push   $0x803de0
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
  8000ec:	68 fe 3d 80 00       	push   $0x803dfe
  8000f1:	e8 ff 02 00 00       	call   8003f5 <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 b5 1b 00 00       	call   801cb3 <inctst>
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
  8001bb:	e8 b5 19 00 00       	call   801b75 <sys_getenvindex>
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
  800229:	e8 cb 16 00 00       	call   8018f9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	68 2c 3e 80 00       	push   $0x803e2c
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
  800259:	68 54 3e 80 00       	push   $0x803e54
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
  80028a:	68 7c 3e 80 00       	push   $0x803e7c
  80028f:	e8 34 01 00 00       	call   8003c8 <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800297:	a1 20 50 80 00       	mov    0x805020,%eax
  80029c:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	50                   	push   %eax
  8002a6:	68 d4 3e 80 00       	push   $0x803ed4
  8002ab:	e8 18 01 00 00       	call   8003c8 <cprintf>
  8002b0:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	68 2c 3e 80 00       	push   $0x803e2c
  8002bb:	e8 08 01 00 00       	call   8003c8 <cprintf>
  8002c0:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002c3:	e8 4b 16 00 00       	call   801913 <sys_unlock_cons>
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
  8002db:	e8 61 18 00 00       	call   801b41 <sys_destroy_env>
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
  8002ec:	e8 b6 18 00 00       	call   801ba7 <sys_exit_env>
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
  80033a:	e8 78 15 00 00       	call   8018b7 <sys_cputs>
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
  8003b1:	e8 01 15 00 00       	call   8018b7 <sys_cputs>
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
  8003fb:	e8 f9 14 00 00       	call   8018f9 <sys_lock_cons>
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
  80041b:	e8 f3 14 00 00       	call   801913 <sys_unlock_cons>
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
  800465:	e8 0a 37 00 00       	call   803b74 <__udivdi3>
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
  8004b5:	e8 ca 37 00 00       	call   803c84 <__umoddi3>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	05 14 41 80 00       	add    $0x804114,%eax
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
  800610:	8b 04 85 38 41 80 00 	mov    0x804138(,%eax,4),%eax
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
  8006f1:	8b 34 9d 80 3f 80 00 	mov    0x803f80(,%ebx,4),%esi
  8006f8:	85 f6                	test   %esi,%esi
  8006fa:	75 19                	jne    800715 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006fc:	53                   	push   %ebx
  8006fd:	68 25 41 80 00       	push   $0x804125
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
  800716:	68 2e 41 80 00       	push   $0x80412e
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
  800743:	be 31 41 80 00       	mov    $0x804131,%esi
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
  800a6e:	68 a8 42 80 00       	push   $0x8042a8
  800a73:	e8 50 f9 ff ff       	call   8003c8 <cprintf>
  800a78:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a82:	83 ec 0c             	sub    $0xc,%esp
  800a85:	6a 00                	push   $0x0
  800a87:	e8 f4 2e 00 00       	call   803980 <iscons>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a92:	e8 d6 2e 00 00       	call   80396d <getchar>
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
  800ab0:	68 ab 42 80 00       	push   $0x8042ab
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
  800add:	e8 6c 2e 00 00       	call   80394e <cputchar>
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
  800b14:	e8 35 2e 00 00       	call   80394e <cputchar>
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
  800b3d:	e8 0c 2e 00 00       	call   80394e <cputchar>
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
  800b61:	e8 93 0d 00 00       	call   8018f9 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6a:	74 13                	je     800b7f <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	68 a8 42 80 00       	push   $0x8042a8
  800b77:	e8 4c f8 ff ff       	call   8003c8 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	6a 00                	push   $0x0
  800b8b:	e8 f0 2d 00 00       	call   803980 <iscons>
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b96:	e8 d2 2d 00 00       	call   80396d <getchar>
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
  800bb4:	68 ab 42 80 00       	push   $0x8042ab
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
  800be1:	e8 68 2d 00 00       	call   80394e <cputchar>
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
  800c18:	e8 31 2d 00 00       	call   80394e <cputchar>
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
  800c41:	e8 08 2d 00 00       	call   80394e <cputchar>
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
  800c5c:	e8 b2 0c 00 00       	call   801913 <sys_unlock_cons>
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
  801356:	68 bc 42 80 00       	push   $0x8042bc
  80135b:	68 3f 01 00 00       	push   $0x13f
  801360:	68 de 42 80 00       	push   $0x8042de
  801365:	e8 20 26 00 00       	call   80398a <_panic>

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
  801376:	e8 e7 0a 00 00       	call   801e62 <sys_sbrk>
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
  8013f1:	e8 f0 08 00 00       	call   801ce6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	74 16                	je     801410 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 30 0e 00 00       	call   802235 <alloc_block_FF>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80140b:	e9 8a 01 00 00       	jmp    80159a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801410:	e8 02 09 00 00       	call   801d17 <sys_isUHeapPlacementStrategyBESTFIT>
  801415:	85 c0                	test   %eax,%eax
  801417:	0f 84 7d 01 00 00    	je     80159a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80141d:	83 ec 0c             	sub    $0xc,%esp
  801420:	ff 75 08             	pushl  0x8(%ebp)
  801423:	e8 c9 12 00 00       	call   8026f1 <alloc_block_BF>
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
  801589:	e8 0b 09 00 00       	call   801e99 <sys_allocate_user_mem>
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
  8015d1:	e8 df 08 00 00       	call   801eb5 <get_block_size>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	ff 75 08             	pushl  0x8(%ebp)
  8015e2:	e8 12 1b 00 00       	call   8030f9 <free_block>
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
  801679:	e8 ff 07 00 00       	call   801e7d <sys_free_user_mem>
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
  801687:	68 ec 42 80 00       	push   $0x8042ec
  80168c:	68 85 00 00 00       	push   $0x85
  801691:	68 16 43 80 00       	push   $0x804316
  801696:	e8 ef 22 00 00       	call   80398a <_panic>
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
  8016fc:	e8 83 03 00 00       	call   801a84 <sys_createSharedObject>
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
  801720:	68 22 43 80 00       	push   $0x804322
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
  801764:	e8 45 03 00 00       	call   801aae <sys_getSizeOfSharedObject>
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80176f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801773:	75 07                	jne    80177c <sget+0x27>
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
  80177a:	eb 5c                	jmp    8017d8 <sget+0x83>
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
  8017af:	eb 27                	jmp    8017d8 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8017b1:	83 ec 04             	sub    $0x4,%esp
  8017b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	ff 75 08             	pushl  0x8(%ebp)
  8017bd:	e8 09 03 00 00       	call   801acb <sys_getSharedObject>
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8017c8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8017cc:	75 07                	jne    8017d5 <sget+0x80>
  8017ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d3:	eb 03                	jmp    8017d8 <sget+0x83>
	return ptr;
  8017d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  8017e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8017e8:	8b 40 78             	mov    0x78(%eax),%eax
  8017eb:	29 c2                	sub    %eax,%edx
  8017ed:	89 d0                	mov    %edx,%eax
  8017ef:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017f4:	c1 e8 0c             	shr    $0xc,%eax
  8017f7:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8017fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801801:	83 ec 08             	sub    $0x8,%esp
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	ff 75 f4             	pushl  -0xc(%ebp)
  80180a:	e8 db 02 00 00       	call   801aea <sys_freeSharedObject>
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801815:	90                   	nop
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	68 34 43 80 00       	push   $0x804334
  801826:	68 dd 00 00 00       	push   $0xdd
  80182b:	68 16 43 80 00       	push   $0x804316
  801830:	e8 55 21 00 00       	call   80398a <_panic>

00801835 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183b:	83 ec 04             	sub    $0x4,%esp
  80183e:	68 5a 43 80 00       	push   $0x80435a
  801843:	68 e9 00 00 00       	push   $0xe9
  801848:	68 16 43 80 00       	push   $0x804316
  80184d:	e8 38 21 00 00       	call   80398a <_panic>

00801852 <shrink>:

}
void shrink(uint32 newSize)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801858:	83 ec 04             	sub    $0x4,%esp
  80185b:	68 5a 43 80 00       	push   $0x80435a
  801860:	68 ee 00 00 00       	push   $0xee
  801865:	68 16 43 80 00       	push   $0x804316
  80186a:	e8 1b 21 00 00       	call   80398a <_panic>

0080186f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801875:	83 ec 04             	sub    $0x4,%esp
  801878:	68 5a 43 80 00       	push   $0x80435a
  80187d:	68 f3 00 00 00       	push   $0xf3
  801882:	68 16 43 80 00       	push   $0x804316
  801887:	e8 fe 20 00 00       	call   80398a <_panic>

0080188c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	57                   	push   %edi
  801890:	56                   	push   %esi
  801891:	53                   	push   %ebx
  801892:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80189e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018a4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018a7:	cd 30                	int    $0x30
  8018a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5f                   	pop    %edi
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	52                   	push   %edx
  8018cf:	ff 75 0c             	pushl  0xc(%ebp)
  8018d2:	50                   	push   %eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	e8 b2 ff ff ff       	call   80188c <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	90                   	nop
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 02                	push   $0x2
  8018ef:	e8 98 ff ff ff       	call   80188c <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 03                	push   $0x3
  801908:	e8 7f ff ff ff       	call   80188c <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	90                   	nop
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 04                	push   $0x4
  801922:	e8 65 ff ff ff       	call   80188c <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	90                   	nop
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801930:	8b 55 0c             	mov    0xc(%ebp),%edx
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	52                   	push   %edx
  80193d:	50                   	push   %eax
  80193e:	6a 08                	push   $0x8
  801940:	e8 47 ff ff ff       	call   80188c <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	56                   	push   %esi
  80194e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80194f:	8b 75 18             	mov    0x18(%ebp),%esi
  801952:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801955:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	56                   	push   %esi
  80195f:	53                   	push   %ebx
  801960:	51                   	push   %ecx
  801961:	52                   	push   %edx
  801962:	50                   	push   %eax
  801963:	6a 09                	push   $0x9
  801965:	e8 22 ff ff ff       	call   80188c <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5d                   	pop    %ebp
  801973:	c3                   	ret    

00801974 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801977:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	52                   	push   %edx
  801984:	50                   	push   %eax
  801985:	6a 0a                	push   $0xa
  801987:	e8 00 ff ff ff       	call   80188c <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	ff 75 08             	pushl  0x8(%ebp)
  8019a0:	6a 0b                	push   $0xb
  8019a2:	e8 e5 fe ff ff       	call   80188c <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 0c                	push   $0xc
  8019bb:	e8 cc fe ff ff       	call   80188c <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 0d                	push   $0xd
  8019d4:	e8 b3 fe ff ff       	call   80188c <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 0e                	push   $0xe
  8019ed:	e8 9a fe ff ff       	call   80188c <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 0f                	push   $0xf
  801a06:	e8 81 fe ff ff       	call   80188c <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	ff 75 08             	pushl  0x8(%ebp)
  801a1e:	6a 10                	push   $0x10
  801a20:	e8 67 fe ff ff       	call   80188c <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 11                	push   $0x11
  801a39:	e8 4e fe ff ff       	call   80188c <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	90                   	nop
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_cputc>:

void
sys_cputc(const char c)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a50:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	50                   	push   %eax
  801a5d:	6a 01                	push   $0x1
  801a5f:	e8 28 fe ff ff       	call   80188c <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	90                   	nop
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 14                	push   $0x14
  801a79:	e8 0e fe ff ff       	call   80188c <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	90                   	nop
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a90:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a93:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	51                   	push   %ecx
  801a9d:	52                   	push   %edx
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	50                   	push   %eax
  801aa2:	6a 15                	push   $0x15
  801aa4:	e8 e3 fd ff ff       	call   80188c <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	52                   	push   %edx
  801abe:	50                   	push   %eax
  801abf:	6a 16                	push   $0x16
  801ac1:	e8 c6 fd ff ff       	call   80188c <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ace:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	51                   	push   %ecx
  801adc:	52                   	push   %edx
  801add:	50                   	push   %eax
  801ade:	6a 17                	push   $0x17
  801ae0:	e8 a7 fd ff ff       	call   80188c <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	52                   	push   %edx
  801afa:	50                   	push   %eax
  801afb:	6a 18                	push   $0x18
  801afd:	e8 8a fd ff ff       	call   80188c <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	ff 75 14             	pushl  0x14(%ebp)
  801b12:	ff 75 10             	pushl  0x10(%ebp)
  801b15:	ff 75 0c             	pushl  0xc(%ebp)
  801b18:	50                   	push   %eax
  801b19:	6a 19                	push   $0x19
  801b1b:	e8 6c fd ff ff       	call   80188c <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	50                   	push   %eax
  801b34:	6a 1a                	push   $0x1a
  801b36:	e8 51 fd ff ff       	call   80188c <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	90                   	nop
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	50                   	push   %eax
  801b50:	6a 1b                	push   $0x1b
  801b52:	e8 35 fd ff ff       	call   80188c <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 05                	push   $0x5
  801b6b:	e8 1c fd ff ff       	call   80188c <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 06                	push   $0x6
  801b84:	e8 03 fd ff ff       	call   80188c <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 07                	push   $0x7
  801b9d:	e8 ea fc ff ff       	call   80188c <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_exit_env>:


void sys_exit_env(void)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 1c                	push   $0x1c
  801bb6:	e8 d1 fc ff ff       	call   80188c <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	90                   	nop
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bc7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bca:	8d 50 04             	lea    0x4(%eax),%edx
  801bcd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	52                   	push   %edx
  801bd7:	50                   	push   %eax
  801bd8:	6a 1d                	push   $0x1d
  801bda:	e8 ad fc ff ff       	call   80188c <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
	return result;
  801be2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801be5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801be8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801beb:	89 01                	mov    %eax,(%ecx)
  801bed:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	c9                   	leave  
  801bf4:	c2 04 00             	ret    $0x4

00801bf7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	ff 75 10             	pushl  0x10(%ebp)
  801c01:	ff 75 0c             	pushl  0xc(%ebp)
  801c04:	ff 75 08             	pushl  0x8(%ebp)
  801c07:	6a 13                	push   $0x13
  801c09:	e8 7e fc ff ff       	call   80188c <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c11:	90                   	nop
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 1e                	push   $0x1e
  801c23:	e8 64 fc ff ff       	call   80188c <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 04             	sub    $0x4,%esp
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c39:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	50                   	push   %eax
  801c46:	6a 1f                	push   $0x1f
  801c48:	e8 3f fc ff ff       	call   80188c <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c50:	90                   	nop
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <rsttst>:
void rsttst()
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 21                	push   $0x21
  801c62:	e8 25 fc ff ff       	call   80188c <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6a:	90                   	nop
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	8b 45 14             	mov    0x14(%ebp),%eax
  801c76:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c79:	8b 55 18             	mov    0x18(%ebp),%edx
  801c7c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c80:	52                   	push   %edx
  801c81:	50                   	push   %eax
  801c82:	ff 75 10             	pushl  0x10(%ebp)
  801c85:	ff 75 0c             	pushl  0xc(%ebp)
  801c88:	ff 75 08             	pushl  0x8(%ebp)
  801c8b:	6a 20                	push   $0x20
  801c8d:	e8 fa fb ff ff       	call   80188c <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
	return ;
  801c95:	90                   	nop
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <chktst>:
void chktst(uint32 n)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	ff 75 08             	pushl  0x8(%ebp)
  801ca6:	6a 22                	push   $0x22
  801ca8:	e8 df fb ff ff       	call   80188c <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb0:	90                   	nop
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <inctst>:

void inctst()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 23                	push   $0x23
  801cc2:	e8 c5 fb ff ff       	call   80188c <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cca:	90                   	nop
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <gettst>:
uint32 gettst()
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 24                	push   $0x24
  801cdc:	e8 ab fb ff ff       	call   80188c <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 25                	push   $0x25
  801cf8:	e8 8f fb ff ff       	call   80188c <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
  801d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d03:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d07:	75 07                	jne    801d10 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d09:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0e:	eb 05                	jmp    801d15 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 25                	push   $0x25
  801d29:	e8 5e fb ff ff       	call   80188c <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
  801d31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d34:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d38:	75 07                	jne    801d41 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3f:	eb 05                	jmp    801d46 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 25                	push   $0x25
  801d5a:	e8 2d fb ff ff       	call   80188c <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
  801d62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d65:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d69:	75 07                	jne    801d72 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d70:	eb 05                	jmp    801d77 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 25                	push   $0x25
  801d8b:	e8 fc fa ff ff       	call   80188c <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
  801d93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d96:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d9a:	75 07                	jne    801da3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801da1:	eb 05                	jmp    801da8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	ff 75 08             	pushl  0x8(%ebp)
  801db8:	6a 26                	push   $0x26
  801dba:	e8 cd fa ff ff       	call   80188c <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc2:	90                   	nop
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd5:	6a 00                	push   $0x0
  801dd7:	53                   	push   %ebx
  801dd8:	51                   	push   %ecx
  801dd9:	52                   	push   %edx
  801dda:	50                   	push   %eax
  801ddb:	6a 27                	push   $0x27
  801ddd:	e8 aa fa ff ff       	call   80188c <syscall>
  801de2:	83 c4 18             	add    $0x18,%esp
}
  801de5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ded:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	52                   	push   %edx
  801dfa:	50                   	push   %eax
  801dfb:	6a 28                	push   $0x28
  801dfd:	e8 8a fa ff ff       	call   80188c <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801e0a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	6a 00                	push   $0x0
  801e15:	51                   	push   %ecx
  801e16:	ff 75 10             	pushl  0x10(%ebp)
  801e19:	52                   	push   %edx
  801e1a:	50                   	push   %eax
  801e1b:	6a 29                	push   $0x29
  801e1d:	e8 6a fa ff ff       	call   80188c <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	ff 75 10             	pushl  0x10(%ebp)
  801e31:	ff 75 0c             	pushl  0xc(%ebp)
  801e34:	ff 75 08             	pushl  0x8(%ebp)
  801e37:	6a 12                	push   $0x12
  801e39:	e8 4e fa ff ff       	call   80188c <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e41:	90                   	nop
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801e47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	52                   	push   %edx
  801e54:	50                   	push   %eax
  801e55:	6a 2a                	push   $0x2a
  801e57:	e8 30 fa ff ff       	call   80188c <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
	return;
  801e5f:	90                   	nop
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	50                   	push   %eax
  801e71:	6a 2b                	push   $0x2b
  801e73:	e8 14 fa ff ff       	call   80188c <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	ff 75 0c             	pushl  0xc(%ebp)
  801e89:	ff 75 08             	pushl  0x8(%ebp)
  801e8c:	6a 2c                	push   $0x2c
  801e8e:	e8 f9 f9 ff ff       	call   80188c <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
	return;
  801e96:	90                   	nop
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	ff 75 0c             	pushl  0xc(%ebp)
  801ea5:	ff 75 08             	pushl  0x8(%ebp)
  801ea8:	6a 2d                	push   $0x2d
  801eaa:	e8 dd f9 ff ff       	call   80188c <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
	return;
  801eb2:	90                   	nop
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	83 e8 04             	sub    $0x4,%eax
  801ec1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ec7:	8b 00                	mov    (%eax),%eax
  801ec9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed7:	83 e8 04             	sub    $0x4,%eax
  801eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee0:	8b 00                	mov    (%eax),%eax
  801ee2:	83 e0 01             	and    $0x1,%eax
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	0f 94 c0             	sete   %al
}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ef2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efc:	83 f8 02             	cmp    $0x2,%eax
  801eff:	74 2b                	je     801f2c <alloc_block+0x40>
  801f01:	83 f8 02             	cmp    $0x2,%eax
  801f04:	7f 07                	jg     801f0d <alloc_block+0x21>
  801f06:	83 f8 01             	cmp    $0x1,%eax
  801f09:	74 0e                	je     801f19 <alloc_block+0x2d>
  801f0b:	eb 58                	jmp    801f65 <alloc_block+0x79>
  801f0d:	83 f8 03             	cmp    $0x3,%eax
  801f10:	74 2d                	je     801f3f <alloc_block+0x53>
  801f12:	83 f8 04             	cmp    $0x4,%eax
  801f15:	74 3b                	je     801f52 <alloc_block+0x66>
  801f17:	eb 4c                	jmp    801f65 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801f19:	83 ec 0c             	sub    $0xc,%esp
  801f1c:	ff 75 08             	pushl  0x8(%ebp)
  801f1f:	e8 11 03 00 00       	call   802235 <alloc_block_FF>
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f2a:	eb 4a                	jmp    801f76 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f2c:	83 ec 0c             	sub    $0xc,%esp
  801f2f:	ff 75 08             	pushl  0x8(%ebp)
  801f32:	e8 fa 19 00 00       	call   803931 <alloc_block_NF>
  801f37:	83 c4 10             	add    $0x10,%esp
  801f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f3d:	eb 37                	jmp    801f76 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f3f:	83 ec 0c             	sub    $0xc,%esp
  801f42:	ff 75 08             	pushl  0x8(%ebp)
  801f45:	e8 a7 07 00 00       	call   8026f1 <alloc_block_BF>
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f50:	eb 24                	jmp    801f76 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	ff 75 08             	pushl  0x8(%ebp)
  801f58:	e8 b7 19 00 00       	call   803914 <alloc_block_WF>
  801f5d:	83 c4 10             	add    $0x10,%esp
  801f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f63:	eb 11                	jmp    801f76 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	68 6c 43 80 00       	push   $0x80436c
  801f6d:	e8 56 e4 ff ff       	call   8003c8 <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp
		break;
  801f75:	90                   	nop
	}
	return va;
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	53                   	push   %ebx
  801f7f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	68 8c 43 80 00       	push   $0x80438c
  801f8a:	e8 39 e4 ff ff       	call   8003c8 <cprintf>
  801f8f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f92:	83 ec 0c             	sub    $0xc,%esp
  801f95:	68 b7 43 80 00       	push   $0x8043b7
  801f9a:	e8 29 e4 ff ff       	call   8003c8 <cprintf>
  801f9f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa8:	eb 37                	jmp    801fe1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801faa:	83 ec 0c             	sub    $0xc,%esp
  801fad:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb0:	e8 19 ff ff ff       	call   801ece <is_free_block>
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	0f be d8             	movsbl %al,%ebx
  801fbb:	83 ec 0c             	sub    $0xc,%esp
  801fbe:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc1:	e8 ef fe ff ff       	call   801eb5 <get_block_size>
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	53                   	push   %ebx
  801fcd:	50                   	push   %eax
  801fce:	68 cf 43 80 00       	push   $0x8043cf
  801fd3:	e8 f0 e3 ff ff       	call   8003c8 <cprintf>
  801fd8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe5:	74 07                	je     801fee <print_blocks_list+0x73>
  801fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fea:	8b 00                	mov    (%eax),%eax
  801fec:	eb 05                	jmp    801ff3 <print_blocks_list+0x78>
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff3:	89 45 10             	mov    %eax,0x10(%ebp)
  801ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	75 ad                	jne    801faa <print_blocks_list+0x2f>
  801ffd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802001:	75 a7                	jne    801faa <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	68 8c 43 80 00       	push   $0x80438c
  80200b:	e8 b8 e3 ff ff       	call   8003c8 <cprintf>
  802010:	83 c4 10             	add    $0x10,%esp

}
  802013:	90                   	nop
  802014:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80201f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802022:	83 e0 01             	and    $0x1,%eax
  802025:	85 c0                	test   %eax,%eax
  802027:	74 03                	je     80202c <initialize_dynamic_allocator+0x13>
  802029:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  80202c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802030:	0f 84 c7 01 00 00    	je     8021fd <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  802036:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  80203d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  802040:	8b 55 08             	mov    0x8(%ebp),%edx
  802043:	8b 45 0c             	mov    0xc(%ebp),%eax
  802046:	01 d0                	add    %edx,%eax
  802048:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  80204d:	0f 87 ad 01 00 00    	ja     802200 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	85 c0                	test   %eax,%eax
  802058:	0f 89 a5 01 00 00    	jns    802203 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  80205e:	8b 55 08             	mov    0x8(%ebp),%edx
  802061:	8b 45 0c             	mov    0xc(%ebp),%eax
  802064:	01 d0                	add    %edx,%eax
  802066:	83 e8 04             	sub    $0x4,%eax
  802069:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  80206e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  802075:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80207a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80207d:	e9 87 00 00 00       	jmp    802109 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  802082:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802086:	75 14                	jne    80209c <initialize_dynamic_allocator+0x83>
  802088:	83 ec 04             	sub    $0x4,%esp
  80208b:	68 e7 43 80 00       	push   $0x8043e7
  802090:	6a 79                	push   $0x79
  802092:	68 05 44 80 00       	push   $0x804405
  802097:	e8 ee 18 00 00       	call   80398a <_panic>
  80209c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209f:	8b 00                	mov    (%eax),%eax
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	74 10                	je     8020b5 <initialize_dynamic_allocator+0x9c>
  8020a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a8:	8b 00                	mov    (%eax),%eax
  8020aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ad:	8b 52 04             	mov    0x4(%edx),%edx
  8020b0:	89 50 04             	mov    %edx,0x4(%eax)
  8020b3:	eb 0b                	jmp    8020c0 <initialize_dynamic_allocator+0xa7>
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	8b 40 04             	mov    0x4(%eax),%eax
  8020bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 40 04             	mov    0x4(%eax),%eax
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	74 0f                	je     8020d9 <initialize_dynamic_allocator+0xc0>
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8b 40 04             	mov    0x4(%eax),%eax
  8020d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d3:	8b 12                	mov    (%edx),%edx
  8020d5:	89 10                	mov    %edx,(%eax)
  8020d7:	eb 0a                	jmp    8020e3 <initialize_dynamic_allocator+0xca>
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	8b 00                	mov    (%eax),%eax
  8020de:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8020fb:	48                   	dec    %eax
  8020fc:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802101:	a1 34 50 80 00       	mov    0x805034,%eax
  802106:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802109:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210d:	74 07                	je     802116 <initialize_dynamic_allocator+0xfd>
  80210f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802112:	8b 00                	mov    (%eax),%eax
  802114:	eb 05                	jmp    80211b <initialize_dynamic_allocator+0x102>
  802116:	b8 00 00 00 00       	mov    $0x0,%eax
  80211b:	a3 34 50 80 00       	mov    %eax,0x805034
  802120:	a1 34 50 80 00       	mov    0x805034,%eax
  802125:	85 c0                	test   %eax,%eax
  802127:	0f 85 55 ff ff ff    	jne    802082 <initialize_dynamic_allocator+0x69>
  80212d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802131:	0f 85 4b ff ff ff    	jne    802082 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80213d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802140:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802146:	a1 44 50 80 00       	mov    0x805044,%eax
  80214b:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802150:	a1 40 50 80 00       	mov    0x805040,%eax
  802155:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	83 c0 08             	add    $0x8,%eax
  802161:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	83 c0 04             	add    $0x4,%eax
  80216a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216d:	83 ea 08             	sub    $0x8,%edx
  802170:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802172:	8b 55 0c             	mov    0xc(%ebp),%edx
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	01 d0                	add    %edx,%eax
  80217a:	83 e8 08             	sub    $0x8,%eax
  80217d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802180:	83 ea 08             	sub    $0x8,%edx
  802183:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802188:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80218e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802191:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802198:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80219c:	75 17                	jne    8021b5 <initialize_dynamic_allocator+0x19c>
  80219e:	83 ec 04             	sub    $0x4,%esp
  8021a1:	68 20 44 80 00       	push   $0x804420
  8021a6:	68 90 00 00 00       	push   $0x90
  8021ab:	68 05 44 80 00       	push   $0x804405
  8021b0:	e8 d5 17 00 00       	call   80398a <_panic>
  8021b5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021be:	89 10                	mov    %edx,(%eax)
  8021c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	74 0d                	je     8021d6 <initialize_dynamic_allocator+0x1bd>
  8021c9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021d1:	89 50 04             	mov    %edx,0x4(%eax)
  8021d4:	eb 08                	jmp    8021de <initialize_dynamic_allocator+0x1c5>
  8021d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8021de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f0:	a1 38 50 80 00       	mov    0x805038,%eax
  8021f5:	40                   	inc    %eax
  8021f6:	a3 38 50 80 00       	mov    %eax,0x805038
  8021fb:	eb 07                	jmp    802204 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8021fd:	90                   	nop
  8021fe:	eb 04                	jmp    802204 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802200:	90                   	nop
  802201:	eb 01                	jmp    802204 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802203:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	8d 50 fc             	lea    -0x4(%eax),%edx
  802215:	8b 45 0c             	mov    0xc(%ebp),%eax
  802218:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	83 e8 04             	sub    $0x4,%eax
  802220:	8b 00                	mov    (%eax),%eax
  802222:	83 e0 fe             	and    $0xfffffffe,%eax
  802225:	8d 50 f8             	lea    -0x8(%eax),%edx
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	01 c2                	add    %eax,%edx
  80222d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802230:	89 02                	mov    %eax,(%edx)
}
  802232:	90                   	nop
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    

00802235 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	83 e0 01             	and    $0x1,%eax
  802241:	85 c0                	test   %eax,%eax
  802243:	74 03                	je     802248 <alloc_block_FF+0x13>
  802245:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802248:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80224c:	77 07                	ja     802255 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80224e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802255:	a1 24 50 80 00       	mov    0x805024,%eax
  80225a:	85 c0                	test   %eax,%eax
  80225c:	75 73                	jne    8022d1 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	83 c0 10             	add    $0x10,%eax
  802264:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802267:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80226e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802271:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802274:	01 d0                	add    %edx,%eax
  802276:	48                   	dec    %eax
  802277:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80227a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80227d:	ba 00 00 00 00       	mov    $0x0,%edx
  802282:	f7 75 ec             	divl   -0x14(%ebp)
  802285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802288:	29 d0                	sub    %edx,%eax
  80228a:	c1 e8 0c             	shr    $0xc,%eax
  80228d:	83 ec 0c             	sub    $0xc,%esp
  802290:	50                   	push   %eax
  802291:	e8 d4 f0 ff ff       	call   80136a <sbrk>
  802296:	83 c4 10             	add    $0x10,%esp
  802299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80229c:	83 ec 0c             	sub    $0xc,%esp
  80229f:	6a 00                	push   $0x0
  8022a1:	e8 c4 f0 ff ff       	call   80136a <sbrk>
  8022a6:	83 c4 10             	add    $0x10,%esp
  8022a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8022ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022af:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8022b2:	83 ec 08             	sub    $0x8,%esp
  8022b5:	50                   	push   %eax
  8022b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022b9:	e8 5b fd ff ff       	call   802019 <initialize_dynamic_allocator>
  8022be:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8022c1:	83 ec 0c             	sub    $0xc,%esp
  8022c4:	68 43 44 80 00       	push   $0x804443
  8022c9:	e8 fa e0 ff ff       	call   8003c8 <cprintf>
  8022ce:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8022d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d5:	75 0a                	jne    8022e1 <alloc_block_FF+0xac>
	        return NULL;
  8022d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022dc:	e9 0e 04 00 00       	jmp    8026ef <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8022e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022e8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f0:	e9 f3 02 00 00       	jmp    8025e8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8022fb:	83 ec 0c             	sub    $0xc,%esp
  8022fe:	ff 75 bc             	pushl  -0x44(%ebp)
  802301:	e8 af fb ff ff       	call   801eb5 <get_block_size>
  802306:	83 c4 10             	add    $0x10,%esp
  802309:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	83 c0 08             	add    $0x8,%eax
  802312:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802315:	0f 87 c5 02 00 00    	ja     8025e0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	83 c0 18             	add    $0x18,%eax
  802321:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802324:	0f 87 19 02 00 00    	ja     802543 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80232a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80232d:	2b 45 08             	sub    0x8(%ebp),%eax
  802330:	83 e8 08             	sub    $0x8,%eax
  802333:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	8d 50 08             	lea    0x8(%eax),%edx
  80233c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80233f:	01 d0                	add    %edx,%eax
  802341:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	83 c0 08             	add    $0x8,%eax
  80234a:	83 ec 04             	sub    $0x4,%esp
  80234d:	6a 01                	push   $0x1
  80234f:	50                   	push   %eax
  802350:	ff 75 bc             	pushl  -0x44(%ebp)
  802353:	e8 ae fe ff ff       	call   802206 <set_block_data>
  802358:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 40 04             	mov    0x4(%eax),%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	75 68                	jne    8023cd <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802365:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802369:	75 17                	jne    802382 <alloc_block_FF+0x14d>
  80236b:	83 ec 04             	sub    $0x4,%esp
  80236e:	68 20 44 80 00       	push   $0x804420
  802373:	68 d7 00 00 00       	push   $0xd7
  802378:	68 05 44 80 00       	push   $0x804405
  80237d:	e8 08 16 00 00       	call   80398a <_panic>
  802382:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802388:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80238b:	89 10                	mov    %edx,(%eax)
  80238d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	85 c0                	test   %eax,%eax
  802394:	74 0d                	je     8023a3 <alloc_block_FF+0x16e>
  802396:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80239b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80239e:	89 50 04             	mov    %edx,0x4(%eax)
  8023a1:	eb 08                	jmp    8023ab <alloc_block_FF+0x176>
  8023a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023a6:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ae:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023bd:	a1 38 50 80 00       	mov    0x805038,%eax
  8023c2:	40                   	inc    %eax
  8023c3:	a3 38 50 80 00       	mov    %eax,0x805038
  8023c8:	e9 dc 00 00 00       	jmp    8024a9 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	8b 00                	mov    (%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	75 65                	jne    80243b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8023d6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8023da:	75 17                	jne    8023f3 <alloc_block_FF+0x1be>
  8023dc:	83 ec 04             	sub    $0x4,%esp
  8023df:	68 54 44 80 00       	push   $0x804454
  8023e4:	68 db 00 00 00       	push   $0xdb
  8023e9:	68 05 44 80 00       	push   $0x804405
  8023ee:	e8 97 15 00 00       	call   80398a <_panic>
  8023f3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8023f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023fc:	89 50 04             	mov    %edx,0x4(%eax)
  8023ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802402:	8b 40 04             	mov    0x4(%eax),%eax
  802405:	85 c0                	test   %eax,%eax
  802407:	74 0c                	je     802415 <alloc_block_FF+0x1e0>
  802409:	a1 30 50 80 00       	mov    0x805030,%eax
  80240e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802411:	89 10                	mov    %edx,(%eax)
  802413:	eb 08                	jmp    80241d <alloc_block_FF+0x1e8>
  802415:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802418:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80241d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802420:	a3 30 50 80 00       	mov    %eax,0x805030
  802425:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802428:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242e:	a1 38 50 80 00       	mov    0x805038,%eax
  802433:	40                   	inc    %eax
  802434:	a3 38 50 80 00       	mov    %eax,0x805038
  802439:	eb 6e                	jmp    8024a9 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80243b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243f:	74 06                	je     802447 <alloc_block_FF+0x212>
  802441:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802445:	75 17                	jne    80245e <alloc_block_FF+0x229>
  802447:	83 ec 04             	sub    $0x4,%esp
  80244a:	68 78 44 80 00       	push   $0x804478
  80244f:	68 df 00 00 00       	push   $0xdf
  802454:	68 05 44 80 00       	push   $0x804405
  802459:	e8 2c 15 00 00       	call   80398a <_panic>
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 10                	mov    (%eax),%edx
  802463:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802466:	89 10                	mov    %edx,(%eax)
  802468:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80246b:	8b 00                	mov    (%eax),%eax
  80246d:	85 c0                	test   %eax,%eax
  80246f:	74 0b                	je     80247c <alloc_block_FF+0x247>
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 00                	mov    (%eax),%eax
  802476:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802479:	89 50 04             	mov    %edx,0x4(%eax)
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802482:	89 10                	mov    %edx,(%eax)
  802484:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802487:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248a:	89 50 04             	mov    %edx,0x4(%eax)
  80248d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802490:	8b 00                	mov    (%eax),%eax
  802492:	85 c0                	test   %eax,%eax
  802494:	75 08                	jne    80249e <alloc_block_FF+0x269>
  802496:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802499:	a3 30 50 80 00       	mov    %eax,0x805030
  80249e:	a1 38 50 80 00       	mov    0x805038,%eax
  8024a3:	40                   	inc    %eax
  8024a4:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8024a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ad:	75 17                	jne    8024c6 <alloc_block_FF+0x291>
  8024af:	83 ec 04             	sub    $0x4,%esp
  8024b2:	68 e7 43 80 00       	push   $0x8043e7
  8024b7:	68 e1 00 00 00       	push   $0xe1
  8024bc:	68 05 44 80 00       	push   $0x804405
  8024c1:	e8 c4 14 00 00       	call   80398a <_panic>
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 00                	mov    (%eax),%eax
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	74 10                	je     8024df <alloc_block_FF+0x2aa>
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 00                	mov    (%eax),%eax
  8024d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d7:	8b 52 04             	mov    0x4(%edx),%edx
  8024da:	89 50 04             	mov    %edx,0x4(%eax)
  8024dd:	eb 0b                	jmp    8024ea <alloc_block_FF+0x2b5>
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 04             	mov    0x4(%eax),%eax
  8024e5:	a3 30 50 80 00       	mov    %eax,0x805030
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 40 04             	mov    0x4(%eax),%eax
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	74 0f                	je     802503 <alloc_block_FF+0x2ce>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 04             	mov    0x4(%eax),%eax
  8024fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fd:	8b 12                	mov    (%edx),%edx
  8024ff:	89 10                	mov    %edx,(%eax)
  802501:	eb 0a                	jmp    80250d <alloc_block_FF+0x2d8>
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	8b 00                	mov    (%eax),%eax
  802508:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802520:	a1 38 50 80 00       	mov    0x805038,%eax
  802525:	48                   	dec    %eax
  802526:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80252b:	83 ec 04             	sub    $0x4,%esp
  80252e:	6a 00                	push   $0x0
  802530:	ff 75 b4             	pushl  -0x4c(%ebp)
  802533:	ff 75 b0             	pushl  -0x50(%ebp)
  802536:	e8 cb fc ff ff       	call   802206 <set_block_data>
  80253b:	83 c4 10             	add    $0x10,%esp
  80253e:	e9 95 00 00 00       	jmp    8025d8 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802543:	83 ec 04             	sub    $0x4,%esp
  802546:	6a 01                	push   $0x1
  802548:	ff 75 b8             	pushl  -0x48(%ebp)
  80254b:	ff 75 bc             	pushl  -0x44(%ebp)
  80254e:	e8 b3 fc ff ff       	call   802206 <set_block_data>
  802553:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255a:	75 17                	jne    802573 <alloc_block_FF+0x33e>
  80255c:	83 ec 04             	sub    $0x4,%esp
  80255f:	68 e7 43 80 00       	push   $0x8043e7
  802564:	68 e8 00 00 00       	push   $0xe8
  802569:	68 05 44 80 00       	push   $0x804405
  80256e:	e8 17 14 00 00       	call   80398a <_panic>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 00                	mov    (%eax),%eax
  802578:	85 c0                	test   %eax,%eax
  80257a:	74 10                	je     80258c <alloc_block_FF+0x357>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802584:	8b 52 04             	mov    0x4(%edx),%edx
  802587:	89 50 04             	mov    %edx,0x4(%eax)
  80258a:	eb 0b                	jmp    802597 <alloc_block_FF+0x362>
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 40 04             	mov    0x4(%eax),%eax
  802592:	a3 30 50 80 00       	mov    %eax,0x805030
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 40 04             	mov    0x4(%eax),%eax
  80259d:	85 c0                	test   %eax,%eax
  80259f:	74 0f                	je     8025b0 <alloc_block_FF+0x37b>
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 40 04             	mov    0x4(%eax),%eax
  8025a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025aa:	8b 12                	mov    (%edx),%edx
  8025ac:	89 10                	mov    %edx,(%eax)
  8025ae:	eb 0a                	jmp    8025ba <alloc_block_FF+0x385>
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
	            }
	            return va;
  8025d8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8025db:	e9 0f 01 00 00       	jmp    8026ef <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8025e0:	a1 34 50 80 00       	mov    0x805034,%eax
  8025e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ec:	74 07                	je     8025f5 <alloc_block_FF+0x3c0>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	eb 05                	jmp    8025fa <alloc_block_FF+0x3c5>
  8025f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fa:	a3 34 50 80 00       	mov    %eax,0x805034
  8025ff:	a1 34 50 80 00       	mov    0x805034,%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	0f 85 e9 fc ff ff    	jne    8022f5 <alloc_block_FF+0xc0>
  80260c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802610:	0f 85 df fc ff ff    	jne    8022f5 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	83 c0 08             	add    $0x8,%eax
  80261c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80261f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802626:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802629:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80262c:	01 d0                	add    %edx,%eax
  80262e:	48                   	dec    %eax
  80262f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802632:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802635:	ba 00 00 00 00       	mov    $0x0,%edx
  80263a:	f7 75 d8             	divl   -0x28(%ebp)
  80263d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802640:	29 d0                	sub    %edx,%eax
  802642:	c1 e8 0c             	shr    $0xc,%eax
  802645:	83 ec 0c             	sub    $0xc,%esp
  802648:	50                   	push   %eax
  802649:	e8 1c ed ff ff       	call   80136a <sbrk>
  80264e:	83 c4 10             	add    $0x10,%esp
  802651:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802654:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802658:	75 0a                	jne    802664 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80265a:	b8 00 00 00 00       	mov    $0x0,%eax
  80265f:	e9 8b 00 00 00       	jmp    8026ef <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802664:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80266b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80266e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802671:	01 d0                	add    %edx,%eax
  802673:	48                   	dec    %eax
  802674:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802677:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80267a:	ba 00 00 00 00       	mov    $0x0,%edx
  80267f:	f7 75 cc             	divl   -0x34(%ebp)
  802682:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802685:	29 d0                	sub    %edx,%eax
  802687:	8d 50 fc             	lea    -0x4(%eax),%edx
  80268a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80268d:	01 d0                	add    %edx,%eax
  80268f:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802694:	a1 40 50 80 00       	mov    0x805040,%eax
  802699:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80269f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8026a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026ac:	01 d0                	add    %edx,%eax
  8026ae:	48                   	dec    %eax
  8026af:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8026b2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ba:	f7 75 c4             	divl   -0x3c(%ebp)
  8026bd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026c0:	29 d0                	sub    %edx,%eax
  8026c2:	83 ec 04             	sub    $0x4,%esp
  8026c5:	6a 01                	push   $0x1
  8026c7:	50                   	push   %eax
  8026c8:	ff 75 d0             	pushl  -0x30(%ebp)
  8026cb:	e8 36 fb ff ff       	call   802206 <set_block_data>
  8026d0:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8026d3:	83 ec 0c             	sub    $0xc,%esp
  8026d6:	ff 75 d0             	pushl  -0x30(%ebp)
  8026d9:	e8 1b 0a 00 00       	call   8030f9 <free_block>
  8026de:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8026e1:	83 ec 0c             	sub    $0xc,%esp
  8026e4:	ff 75 08             	pushl  0x8(%ebp)
  8026e7:	e8 49 fb ff ff       	call   802235 <alloc_block_FF>
  8026ec:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	83 e0 01             	and    $0x1,%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	74 03                	je     802704 <alloc_block_BF+0x13>
  802701:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802704:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802708:	77 07                	ja     802711 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80270a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802711:	a1 24 50 80 00       	mov    0x805024,%eax
  802716:	85 c0                	test   %eax,%eax
  802718:	75 73                	jne    80278d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80271a:	8b 45 08             	mov    0x8(%ebp),%eax
  80271d:	83 c0 10             	add    $0x10,%eax
  802720:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802723:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80272a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80272d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802730:	01 d0                	add    %edx,%eax
  802732:	48                   	dec    %eax
  802733:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802736:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802739:	ba 00 00 00 00       	mov    $0x0,%edx
  80273e:	f7 75 e0             	divl   -0x20(%ebp)
  802741:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802744:	29 d0                	sub    %edx,%eax
  802746:	c1 e8 0c             	shr    $0xc,%eax
  802749:	83 ec 0c             	sub    $0xc,%esp
  80274c:	50                   	push   %eax
  80274d:	e8 18 ec ff ff       	call   80136a <sbrk>
  802752:	83 c4 10             	add    $0x10,%esp
  802755:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802758:	83 ec 0c             	sub    $0xc,%esp
  80275b:	6a 00                	push   $0x0
  80275d:	e8 08 ec ff ff       	call   80136a <sbrk>
  802762:	83 c4 10             	add    $0x10,%esp
  802765:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80276b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80276e:	83 ec 08             	sub    $0x8,%esp
  802771:	50                   	push   %eax
  802772:	ff 75 d8             	pushl  -0x28(%ebp)
  802775:	e8 9f f8 ff ff       	call   802019 <initialize_dynamic_allocator>
  80277a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80277d:	83 ec 0c             	sub    $0xc,%esp
  802780:	68 43 44 80 00       	push   $0x804443
  802785:	e8 3e dc ff ff       	call   8003c8 <cprintf>
  80278a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80278d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802794:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80279b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8027a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8027a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b1:	e9 1d 01 00 00       	jmp    8028d3 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8027bc:	83 ec 0c             	sub    $0xc,%esp
  8027bf:	ff 75 a8             	pushl  -0x58(%ebp)
  8027c2:	e8 ee f6 ff ff       	call   801eb5 <get_block_size>
  8027c7:	83 c4 10             	add    $0x10,%esp
  8027ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d0:	83 c0 08             	add    $0x8,%eax
  8027d3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027d6:	0f 87 ef 00 00 00    	ja     8028cb <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	83 c0 18             	add    $0x18,%eax
  8027e2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027e5:	77 1d                	ja     802804 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8027e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ea:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027ed:	0f 86 d8 00 00 00    	jbe    8028cb <alloc_block_BF+0x1da>
				{
					best_va = va;
  8027f3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8027f9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027ff:	e9 c7 00 00 00       	jmp    8028cb <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802804:	8b 45 08             	mov    0x8(%ebp),%eax
  802807:	83 c0 08             	add    $0x8,%eax
  80280a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80280d:	0f 85 9d 00 00 00    	jne    8028b0 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802813:	83 ec 04             	sub    $0x4,%esp
  802816:	6a 01                	push   $0x1
  802818:	ff 75 a4             	pushl  -0x5c(%ebp)
  80281b:	ff 75 a8             	pushl  -0x58(%ebp)
  80281e:	e8 e3 f9 ff ff       	call   802206 <set_block_data>
  802823:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802826:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282a:	75 17                	jne    802843 <alloc_block_BF+0x152>
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	68 e7 43 80 00       	push   $0x8043e7
  802834:	68 2c 01 00 00       	push   $0x12c
  802839:	68 05 44 80 00       	push   $0x804405
  80283e:	e8 47 11 00 00       	call   80398a <_panic>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 00                	mov    (%eax),%eax
  802848:	85 c0                	test   %eax,%eax
  80284a:	74 10                	je     80285c <alloc_block_BF+0x16b>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802854:	8b 52 04             	mov    0x4(%edx),%edx
  802857:	89 50 04             	mov    %edx,0x4(%eax)
  80285a:	eb 0b                	jmp    802867 <alloc_block_BF+0x176>
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	a3 30 50 80 00       	mov    %eax,0x805030
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	74 0f                	je     802880 <alloc_block_BF+0x18f>
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 40 04             	mov    0x4(%eax),%eax
  802877:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287a:	8b 12                	mov    (%edx),%edx
  80287c:	89 10                	mov    %edx,(%eax)
  80287e:	eb 0a                	jmp    80288a <alloc_block_BF+0x199>
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 00                	mov    (%eax),%eax
  802885:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289d:	a1 38 50 80 00       	mov    0x805038,%eax
  8028a2:	48                   	dec    %eax
  8028a3:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8028a8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028ab:	e9 24 04 00 00       	jmp    802cd4 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8028b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8028b6:	76 13                	jbe    8028cb <alloc_block_BF+0x1da>
					{
						internal = 1;
  8028b8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8028bf:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8028c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8028c5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8028c8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8028cb:	a1 34 50 80 00       	mov    0x805034,%eax
  8028d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d7:	74 07                	je     8028e0 <alloc_block_BF+0x1ef>
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	eb 05                	jmp    8028e5 <alloc_block_BF+0x1f4>
  8028e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e5:	a3 34 50 80 00       	mov    %eax,0x805034
  8028ea:	a1 34 50 80 00       	mov    0x805034,%eax
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	0f 85 bf fe ff ff    	jne    8027b6 <alloc_block_BF+0xc5>
  8028f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fb:	0f 85 b5 fe ff ff    	jne    8027b6 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802901:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802905:	0f 84 26 02 00 00    	je     802b31 <alloc_block_BF+0x440>
  80290b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80290f:	0f 85 1c 02 00 00    	jne    802b31 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802918:	2b 45 08             	sub    0x8(%ebp),%eax
  80291b:	83 e8 08             	sub    $0x8,%eax
  80291e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802921:	8b 45 08             	mov    0x8(%ebp),%eax
  802924:	8d 50 08             	lea    0x8(%eax),%edx
  802927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292a:	01 d0                	add    %edx,%eax
  80292c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	83 c0 08             	add    $0x8,%eax
  802935:	83 ec 04             	sub    $0x4,%esp
  802938:	6a 01                	push   $0x1
  80293a:	50                   	push   %eax
  80293b:	ff 75 f0             	pushl  -0x10(%ebp)
  80293e:	e8 c3 f8 ff ff       	call   802206 <set_block_data>
  802943:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802949:	8b 40 04             	mov    0x4(%eax),%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	75 68                	jne    8029b8 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802950:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802954:	75 17                	jne    80296d <alloc_block_BF+0x27c>
  802956:	83 ec 04             	sub    $0x4,%esp
  802959:	68 20 44 80 00       	push   $0x804420
  80295e:	68 45 01 00 00       	push   $0x145
  802963:	68 05 44 80 00       	push   $0x804405
  802968:	e8 1d 10 00 00       	call   80398a <_panic>
  80296d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802973:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802976:	89 10                	mov    %edx,(%eax)
  802978:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	85 c0                	test   %eax,%eax
  80297f:	74 0d                	je     80298e <alloc_block_BF+0x29d>
  802981:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802986:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802989:	89 50 04             	mov    %edx,0x4(%eax)
  80298c:	eb 08                	jmp    802996 <alloc_block_BF+0x2a5>
  80298e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802991:	a3 30 50 80 00       	mov    %eax,0x805030
  802996:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802999:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80299e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029ad:	40                   	inc    %eax
  8029ae:	a3 38 50 80 00       	mov    %eax,0x805038
  8029b3:	e9 dc 00 00 00       	jmp    802a94 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	85 c0                	test   %eax,%eax
  8029bf:	75 65                	jne    802a26 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8029c1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8029c5:	75 17                	jne    8029de <alloc_block_BF+0x2ed>
  8029c7:	83 ec 04             	sub    $0x4,%esp
  8029ca:	68 54 44 80 00       	push   $0x804454
  8029cf:	68 4a 01 00 00       	push   $0x14a
  8029d4:	68 05 44 80 00       	push   $0x804405
  8029d9:	e8 ac 0f 00 00       	call   80398a <_panic>
  8029de:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8029e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029e7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ed:	8b 40 04             	mov    0x4(%eax),%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	74 0c                	je     802a00 <alloc_block_BF+0x30f>
  8029f4:	a1 30 50 80 00       	mov    0x805030,%eax
  8029f9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029fc:	89 10                	mov    %edx,(%eax)
  8029fe:	eb 08                	jmp    802a08 <alloc_block_BF+0x317>
  802a00:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a03:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a08:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a0b:	a3 30 50 80 00       	mov    %eax,0x805030
  802a10:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a19:	a1 38 50 80 00       	mov    0x805038,%eax
  802a1e:	40                   	inc    %eax
  802a1f:	a3 38 50 80 00       	mov    %eax,0x805038
  802a24:	eb 6e                	jmp    802a94 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802a26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a2a:	74 06                	je     802a32 <alloc_block_BF+0x341>
  802a2c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802a30:	75 17                	jne    802a49 <alloc_block_BF+0x358>
  802a32:	83 ec 04             	sub    $0x4,%esp
  802a35:	68 78 44 80 00       	push   $0x804478
  802a3a:	68 4f 01 00 00       	push   $0x14f
  802a3f:	68 05 44 80 00       	push   $0x804405
  802a44:	e8 41 0f 00 00       	call   80398a <_panic>
  802a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4c:	8b 10                	mov    (%eax),%edx
  802a4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a51:	89 10                	mov    %edx,(%eax)
  802a53:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	74 0b                	je     802a67 <alloc_block_BF+0x376>
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a64:	89 50 04             	mov    %edx,0x4(%eax)
  802a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802a6d:	89 10                	mov    %edx,(%eax)
  802a6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a75:	89 50 04             	mov    %edx,0x4(%eax)
  802a78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	75 08                	jne    802a89 <alloc_block_BF+0x398>
  802a81:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a84:	a3 30 50 80 00       	mov    %eax,0x805030
  802a89:	a1 38 50 80 00       	mov    0x805038,%eax
  802a8e:	40                   	inc    %eax
  802a8f:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a98:	75 17                	jne    802ab1 <alloc_block_BF+0x3c0>
  802a9a:	83 ec 04             	sub    $0x4,%esp
  802a9d:	68 e7 43 80 00       	push   $0x8043e7
  802aa2:	68 51 01 00 00       	push   $0x151
  802aa7:	68 05 44 80 00       	push   $0x804405
  802aac:	e8 d9 0e 00 00       	call   80398a <_panic>
  802ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab4:	8b 00                	mov    (%eax),%eax
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	74 10                	je     802aca <alloc_block_BF+0x3d9>
  802aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ac2:	8b 52 04             	mov    0x4(%edx),%edx
  802ac5:	89 50 04             	mov    %edx,0x4(%eax)
  802ac8:	eb 0b                	jmp    802ad5 <alloc_block_BF+0x3e4>
  802aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acd:	8b 40 04             	mov    0x4(%eax),%eax
  802ad0:	a3 30 50 80 00       	mov    %eax,0x805030
  802ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad8:	8b 40 04             	mov    0x4(%eax),%eax
  802adb:	85 c0                	test   %eax,%eax
  802add:	74 0f                	je     802aee <alloc_block_BF+0x3fd>
  802adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae2:	8b 40 04             	mov    0x4(%eax),%eax
  802ae5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae8:	8b 12                	mov    (%edx),%edx
  802aea:	89 10                	mov    %edx,(%eax)
  802aec:	eb 0a                	jmp    802af8 <alloc_block_BF+0x407>
  802aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0b:	a1 38 50 80 00       	mov    0x805038,%eax
  802b10:	48                   	dec    %eax
  802b11:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802b16:	83 ec 04             	sub    $0x4,%esp
  802b19:	6a 00                	push   $0x0
  802b1b:	ff 75 d0             	pushl  -0x30(%ebp)
  802b1e:	ff 75 cc             	pushl  -0x34(%ebp)
  802b21:	e8 e0 f6 ff ff       	call   802206 <set_block_data>
  802b26:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2c:	e9 a3 01 00 00       	jmp    802cd4 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802b31:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802b35:	0f 85 9d 00 00 00    	jne    802bd8 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802b3b:	83 ec 04             	sub    $0x4,%esp
  802b3e:	6a 01                	push   $0x1
  802b40:	ff 75 ec             	pushl  -0x14(%ebp)
  802b43:	ff 75 f0             	pushl  -0x10(%ebp)
  802b46:	e8 bb f6 ff ff       	call   802206 <set_block_data>
  802b4b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b52:	75 17                	jne    802b6b <alloc_block_BF+0x47a>
  802b54:	83 ec 04             	sub    $0x4,%esp
  802b57:	68 e7 43 80 00       	push   $0x8043e7
  802b5c:	68 58 01 00 00       	push   $0x158
  802b61:	68 05 44 80 00       	push   $0x804405
  802b66:	e8 1f 0e 00 00       	call   80398a <_panic>
  802b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6e:	8b 00                	mov    (%eax),%eax
  802b70:	85 c0                	test   %eax,%eax
  802b72:	74 10                	je     802b84 <alloc_block_BF+0x493>
  802b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7c:	8b 52 04             	mov    0x4(%edx),%edx
  802b7f:	89 50 04             	mov    %edx,0x4(%eax)
  802b82:	eb 0b                	jmp    802b8f <alloc_block_BF+0x49e>
  802b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b87:	8b 40 04             	mov    0x4(%eax),%eax
  802b8a:	a3 30 50 80 00       	mov    %eax,0x805030
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	8b 40 04             	mov    0x4(%eax),%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	74 0f                	je     802ba8 <alloc_block_BF+0x4b7>
  802b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9c:	8b 40 04             	mov    0x4(%eax),%eax
  802b9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba2:	8b 12                	mov    (%edx),%edx
  802ba4:	89 10                	mov    %edx,(%eax)
  802ba6:	eb 0a                	jmp    802bb2 <alloc_block_BF+0x4c1>
  802ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc5:	a1 38 50 80 00       	mov    0x805038,%eax
  802bca:	48                   	dec    %eax
  802bcb:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd3:	e9 fc 00 00 00       	jmp    802cd4 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	83 c0 08             	add    $0x8,%eax
  802bde:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802be1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802be8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802beb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802bee:	01 d0                	add    %edx,%eax
  802bf0:	48                   	dec    %eax
  802bf1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802bf4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802bf7:	ba 00 00 00 00       	mov    $0x0,%edx
  802bfc:	f7 75 c4             	divl   -0x3c(%ebp)
  802bff:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c02:	29 d0                	sub    %edx,%eax
  802c04:	c1 e8 0c             	shr    $0xc,%eax
  802c07:	83 ec 0c             	sub    $0xc,%esp
  802c0a:	50                   	push   %eax
  802c0b:	e8 5a e7 ff ff       	call   80136a <sbrk>
  802c10:	83 c4 10             	add    $0x10,%esp
  802c13:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802c16:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802c1a:	75 0a                	jne    802c26 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c21:	e9 ae 00 00 00       	jmp    802cd4 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802c26:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802c2d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c30:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802c33:	01 d0                	add    %edx,%eax
  802c35:	48                   	dec    %eax
  802c36:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802c39:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c3c:	ba 00 00 00 00       	mov    $0x0,%edx
  802c41:	f7 75 b8             	divl   -0x48(%ebp)
  802c44:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802c47:	29 d0                	sub    %edx,%eax
  802c49:	8d 50 fc             	lea    -0x4(%eax),%edx
  802c4c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802c4f:	01 d0                	add    %edx,%eax
  802c51:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802c56:	a1 40 50 80 00       	mov    0x805040,%eax
  802c5b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802c61:	83 ec 0c             	sub    $0xc,%esp
  802c64:	68 ac 44 80 00       	push   $0x8044ac
  802c69:	e8 5a d7 ff ff       	call   8003c8 <cprintf>
  802c6e:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802c71:	83 ec 08             	sub    $0x8,%esp
  802c74:	ff 75 bc             	pushl  -0x44(%ebp)
  802c77:	68 b1 44 80 00       	push   $0x8044b1
  802c7c:	e8 47 d7 ff ff       	call   8003c8 <cprintf>
  802c81:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802c84:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802c8b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802c8e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802c91:	01 d0                	add    %edx,%eax
  802c93:	48                   	dec    %eax
  802c94:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802c97:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  802c9f:	f7 75 b0             	divl   -0x50(%ebp)
  802ca2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ca5:	29 d0                	sub    %edx,%eax
  802ca7:	83 ec 04             	sub    $0x4,%esp
  802caa:	6a 01                	push   $0x1
  802cac:	50                   	push   %eax
  802cad:	ff 75 bc             	pushl  -0x44(%ebp)
  802cb0:	e8 51 f5 ff ff       	call   802206 <set_block_data>
  802cb5:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802cb8:	83 ec 0c             	sub    $0xc,%esp
  802cbb:	ff 75 bc             	pushl  -0x44(%ebp)
  802cbe:	e8 36 04 00 00       	call   8030f9 <free_block>
  802cc3:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802cc6:	83 ec 0c             	sub    $0xc,%esp
  802cc9:	ff 75 08             	pushl  0x8(%ebp)
  802ccc:	e8 20 fa ff ff       	call   8026f1 <alloc_block_BF>
  802cd1:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802cd4:	c9                   	leave  
  802cd5:	c3                   	ret    

00802cd6 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802cd6:	55                   	push   %ebp
  802cd7:	89 e5                	mov    %esp,%ebp
  802cd9:	53                   	push   %ebx
  802cda:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802cdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ce4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cef:	74 1e                	je     802d0f <merging+0x39>
  802cf1:	ff 75 08             	pushl  0x8(%ebp)
  802cf4:	e8 bc f1 ff ff       	call   801eb5 <get_block_size>
  802cf9:	83 c4 04             	add    $0x4,%esp
  802cfc:	89 c2                	mov    %eax,%edx
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	01 d0                	add    %edx,%eax
  802d03:	3b 45 10             	cmp    0x10(%ebp),%eax
  802d06:	75 07                	jne    802d0f <merging+0x39>
		prev_is_free = 1;
  802d08:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802d0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d13:	74 1e                	je     802d33 <merging+0x5d>
  802d15:	ff 75 10             	pushl  0x10(%ebp)
  802d18:	e8 98 f1 ff ff       	call   801eb5 <get_block_size>
  802d1d:	83 c4 04             	add    $0x4,%esp
  802d20:	89 c2                	mov    %eax,%edx
  802d22:	8b 45 10             	mov    0x10(%ebp),%eax
  802d25:	01 d0                	add    %edx,%eax
  802d27:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d2a:	75 07                	jne    802d33 <merging+0x5d>
		next_is_free = 1;
  802d2c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802d33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d37:	0f 84 cc 00 00 00    	je     802e09 <merging+0x133>
  802d3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d41:	0f 84 c2 00 00 00    	je     802e09 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802d47:	ff 75 08             	pushl  0x8(%ebp)
  802d4a:	e8 66 f1 ff ff       	call   801eb5 <get_block_size>
  802d4f:	83 c4 04             	add    $0x4,%esp
  802d52:	89 c3                	mov    %eax,%ebx
  802d54:	ff 75 10             	pushl  0x10(%ebp)
  802d57:	e8 59 f1 ff ff       	call   801eb5 <get_block_size>
  802d5c:	83 c4 04             	add    $0x4,%esp
  802d5f:	01 c3                	add    %eax,%ebx
  802d61:	ff 75 0c             	pushl  0xc(%ebp)
  802d64:	e8 4c f1 ff ff       	call   801eb5 <get_block_size>
  802d69:	83 c4 04             	add    $0x4,%esp
  802d6c:	01 d8                	add    %ebx,%eax
  802d6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d71:	6a 00                	push   $0x0
  802d73:	ff 75 ec             	pushl  -0x14(%ebp)
  802d76:	ff 75 08             	pushl  0x8(%ebp)
  802d79:	e8 88 f4 ff ff       	call   802206 <set_block_data>
  802d7e:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802d81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d85:	75 17                	jne    802d9e <merging+0xc8>
  802d87:	83 ec 04             	sub    $0x4,%esp
  802d8a:	68 e7 43 80 00       	push   $0x8043e7
  802d8f:	68 7d 01 00 00       	push   $0x17d
  802d94:	68 05 44 80 00       	push   $0x804405
  802d99:	e8 ec 0b 00 00       	call   80398a <_panic>
  802d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da1:	8b 00                	mov    (%eax),%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	74 10                	je     802db7 <merging+0xe1>
  802da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  802daf:	8b 52 04             	mov    0x4(%edx),%edx
  802db2:	89 50 04             	mov    %edx,0x4(%eax)
  802db5:	eb 0b                	jmp    802dc2 <merging+0xec>
  802db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dba:	8b 40 04             	mov    0x4(%eax),%eax
  802dbd:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc5:	8b 40 04             	mov    0x4(%eax),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	74 0f                	je     802ddb <merging+0x105>
  802dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcf:	8b 40 04             	mov    0x4(%eax),%eax
  802dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dd5:	8b 12                	mov    (%edx),%edx
  802dd7:	89 10                	mov    %edx,(%eax)
  802dd9:	eb 0a                	jmp    802de5 <merging+0x10f>
  802ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dde:	8b 00                	mov    (%eax),%eax
  802de0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df8:	a1 38 50 80 00       	mov    0x805038,%eax
  802dfd:	48                   	dec    %eax
  802dfe:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802e03:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e04:	e9 ea 02 00 00       	jmp    8030f3 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802e09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0d:	74 3b                	je     802e4a <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802e0f:	83 ec 0c             	sub    $0xc,%esp
  802e12:	ff 75 08             	pushl  0x8(%ebp)
  802e15:	e8 9b f0 ff ff       	call   801eb5 <get_block_size>
  802e1a:	83 c4 10             	add    $0x10,%esp
  802e1d:	89 c3                	mov    %eax,%ebx
  802e1f:	83 ec 0c             	sub    $0xc,%esp
  802e22:	ff 75 10             	pushl  0x10(%ebp)
  802e25:	e8 8b f0 ff ff       	call   801eb5 <get_block_size>
  802e2a:	83 c4 10             	add    $0x10,%esp
  802e2d:	01 d8                	add    %ebx,%eax
  802e2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802e32:	83 ec 04             	sub    $0x4,%esp
  802e35:	6a 00                	push   $0x0
  802e37:	ff 75 e8             	pushl  -0x18(%ebp)
  802e3a:	ff 75 08             	pushl  0x8(%ebp)
  802e3d:	e8 c4 f3 ff ff       	call   802206 <set_block_data>
  802e42:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e45:	e9 a9 02 00 00       	jmp    8030f3 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802e4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e4e:	0f 84 2d 01 00 00    	je     802f81 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802e54:	83 ec 0c             	sub    $0xc,%esp
  802e57:	ff 75 10             	pushl  0x10(%ebp)
  802e5a:	e8 56 f0 ff ff       	call   801eb5 <get_block_size>
  802e5f:	83 c4 10             	add    $0x10,%esp
  802e62:	89 c3                	mov    %eax,%ebx
  802e64:	83 ec 0c             	sub    $0xc,%esp
  802e67:	ff 75 0c             	pushl  0xc(%ebp)
  802e6a:	e8 46 f0 ff ff       	call   801eb5 <get_block_size>
  802e6f:	83 c4 10             	add    $0x10,%esp
  802e72:	01 d8                	add    %ebx,%eax
  802e74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802e77:	83 ec 04             	sub    $0x4,%esp
  802e7a:	6a 00                	push   $0x0
  802e7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  802e7f:	ff 75 10             	pushl  0x10(%ebp)
  802e82:	e8 7f f3 ff ff       	call   802206 <set_block_data>
  802e87:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  802e8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802e90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e94:	74 06                	je     802e9c <merging+0x1c6>
  802e96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e9a:	75 17                	jne    802eb3 <merging+0x1dd>
  802e9c:	83 ec 04             	sub    $0x4,%esp
  802e9f:	68 c0 44 80 00       	push   $0x8044c0
  802ea4:	68 8d 01 00 00       	push   $0x18d
  802ea9:	68 05 44 80 00       	push   $0x804405
  802eae:	e8 d7 0a 00 00       	call   80398a <_panic>
  802eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb6:	8b 50 04             	mov    0x4(%eax),%edx
  802eb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ebc:	89 50 04             	mov    %edx,0x4(%eax)
  802ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec5:	89 10                	mov    %edx,(%eax)
  802ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eca:	8b 40 04             	mov    0x4(%eax),%eax
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	74 0d                	je     802ede <merging+0x208>
  802ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ed4:	8b 40 04             	mov    0x4(%eax),%eax
  802ed7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eda:	89 10                	mov    %edx,(%eax)
  802edc:	eb 08                	jmp    802ee6 <merging+0x210>
  802ede:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ee9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eec:	89 50 04             	mov    %edx,0x4(%eax)
  802eef:	a1 38 50 80 00       	mov    0x805038,%eax
  802ef4:	40                   	inc    %eax
  802ef5:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802efa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802efe:	75 17                	jne    802f17 <merging+0x241>
  802f00:	83 ec 04             	sub    $0x4,%esp
  802f03:	68 e7 43 80 00       	push   $0x8043e7
  802f08:	68 8e 01 00 00       	push   $0x18e
  802f0d:	68 05 44 80 00       	push   $0x804405
  802f12:	e8 73 0a 00 00       	call   80398a <_panic>
  802f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	85 c0                	test   %eax,%eax
  802f1e:	74 10                	je     802f30 <merging+0x25a>
  802f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f23:	8b 00                	mov    (%eax),%eax
  802f25:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f28:	8b 52 04             	mov    0x4(%edx),%edx
  802f2b:	89 50 04             	mov    %edx,0x4(%eax)
  802f2e:	eb 0b                	jmp    802f3b <merging+0x265>
  802f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f33:	8b 40 04             	mov    0x4(%eax),%eax
  802f36:	a3 30 50 80 00       	mov    %eax,0x805030
  802f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3e:	8b 40 04             	mov    0x4(%eax),%eax
  802f41:	85 c0                	test   %eax,%eax
  802f43:	74 0f                	je     802f54 <merging+0x27e>
  802f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f48:	8b 40 04             	mov    0x4(%eax),%eax
  802f4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f4e:	8b 12                	mov    (%edx),%edx
  802f50:	89 10                	mov    %edx,(%eax)
  802f52:	eb 0a                	jmp    802f5e <merging+0x288>
  802f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f57:	8b 00                	mov    (%eax),%eax
  802f59:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f71:	a1 38 50 80 00       	mov    0x805038,%eax
  802f76:	48                   	dec    %eax
  802f77:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802f7c:	e9 72 01 00 00       	jmp    8030f3 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802f81:	8b 45 10             	mov    0x10(%ebp),%eax
  802f84:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802f87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8b:	74 79                	je     803006 <merging+0x330>
  802f8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f91:	74 73                	je     803006 <merging+0x330>
  802f93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f97:	74 06                	je     802f9f <merging+0x2c9>
  802f99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f9d:	75 17                	jne    802fb6 <merging+0x2e0>
  802f9f:	83 ec 04             	sub    $0x4,%esp
  802fa2:	68 78 44 80 00       	push   $0x804478
  802fa7:	68 94 01 00 00       	push   $0x194
  802fac:	68 05 44 80 00       	push   $0x804405
  802fb1:	e8 d4 09 00 00       	call   80398a <_panic>
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	8b 10                	mov    (%eax),%edx
  802fbb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fbe:	89 10                	mov    %edx,(%eax)
  802fc0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc3:	8b 00                	mov    (%eax),%eax
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	74 0b                	je     802fd4 <merging+0x2fe>
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fd1:	89 50 04             	mov    %edx,0x4(%eax)
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fda:	89 10                	mov    %edx,(%eax)
  802fdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe2:	89 50 04             	mov    %edx,0x4(%eax)
  802fe5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	85 c0                	test   %eax,%eax
  802fec:	75 08                	jne    802ff6 <merging+0x320>
  802fee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff1:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff6:	a1 38 50 80 00       	mov    0x805038,%eax
  802ffb:	40                   	inc    %eax
  802ffc:	a3 38 50 80 00       	mov    %eax,0x805038
  803001:	e9 ce 00 00 00       	jmp    8030d4 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  803006:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300a:	74 65                	je     803071 <merging+0x39b>
  80300c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803010:	75 17                	jne    803029 <merging+0x353>
  803012:	83 ec 04             	sub    $0x4,%esp
  803015:	68 54 44 80 00       	push   $0x804454
  80301a:	68 95 01 00 00       	push   $0x195
  80301f:	68 05 44 80 00       	push   $0x804405
  803024:	e8 61 09 00 00       	call   80398a <_panic>
  803029:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80302f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803032:	89 50 04             	mov    %edx,0x4(%eax)
  803035:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803038:	8b 40 04             	mov    0x4(%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 0c                	je     80304b <merging+0x375>
  80303f:	a1 30 50 80 00       	mov    0x805030,%eax
  803044:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803047:	89 10                	mov    %edx,(%eax)
  803049:	eb 08                	jmp    803053 <merging+0x37d>
  80304b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803053:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803056:	a3 30 50 80 00       	mov    %eax,0x805030
  80305b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803064:	a1 38 50 80 00       	mov    0x805038,%eax
  803069:	40                   	inc    %eax
  80306a:	a3 38 50 80 00       	mov    %eax,0x805038
  80306f:	eb 63                	jmp    8030d4 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  803071:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803075:	75 17                	jne    80308e <merging+0x3b8>
  803077:	83 ec 04             	sub    $0x4,%esp
  80307a:	68 20 44 80 00       	push   $0x804420
  80307f:	68 98 01 00 00       	push   $0x198
  803084:	68 05 44 80 00       	push   $0x804405
  803089:	e8 fc 08 00 00       	call   80398a <_panic>
  80308e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803094:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803097:	89 10                	mov    %edx,(%eax)
  803099:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 0d                	je     8030af <merging+0x3d9>
  8030a2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8030aa:	89 50 04             	mov    %edx,0x4(%eax)
  8030ad:	eb 08                	jmp    8030b7 <merging+0x3e1>
  8030af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8030b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030ba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8030ce:	40                   	inc    %eax
  8030cf:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  8030d4:	83 ec 0c             	sub    $0xc,%esp
  8030d7:	ff 75 10             	pushl  0x10(%ebp)
  8030da:	e8 d6 ed ff ff       	call   801eb5 <get_block_size>
  8030df:	83 c4 10             	add    $0x10,%esp
  8030e2:	83 ec 04             	sub    $0x4,%esp
  8030e5:	6a 00                	push   $0x0
  8030e7:	50                   	push   %eax
  8030e8:	ff 75 10             	pushl  0x10(%ebp)
  8030eb:	e8 16 f1 ff ff       	call   802206 <set_block_data>
  8030f0:	83 c4 10             	add    $0x10,%esp
	}
}
  8030f3:	90                   	nop
  8030f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8030f7:	c9                   	leave  
  8030f8:	c3                   	ret    

008030f9 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030f9:	55                   	push   %ebp
  8030fa:	89 e5                	mov    %esp,%ebp
  8030fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  8030ff:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803104:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803107:	a1 30 50 80 00       	mov    0x805030,%eax
  80310c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310f:	73 1b                	jae    80312c <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803111:	a1 30 50 80 00       	mov    0x805030,%eax
  803116:	83 ec 04             	sub    $0x4,%esp
  803119:	ff 75 08             	pushl  0x8(%ebp)
  80311c:	6a 00                	push   $0x0
  80311e:	50                   	push   %eax
  80311f:	e8 b2 fb ff ff       	call   802cd6 <merging>
  803124:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803127:	e9 8b 00 00 00       	jmp    8031b7 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80312c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803131:	3b 45 08             	cmp    0x8(%ebp),%eax
  803134:	76 18                	jbe    80314e <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803136:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80313b:	83 ec 04             	sub    $0x4,%esp
  80313e:	ff 75 08             	pushl  0x8(%ebp)
  803141:	50                   	push   %eax
  803142:	6a 00                	push   $0x0
  803144:	e8 8d fb ff ff       	call   802cd6 <merging>
  803149:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80314c:	eb 69                	jmp    8031b7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80314e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803153:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803156:	eb 39                	jmp    803191 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80315e:	73 29                	jae    803189 <free_block+0x90>
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	3b 45 08             	cmp    0x8(%ebp),%eax
  803168:	76 1f                	jbe    803189 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  803172:	83 ec 04             	sub    $0x4,%esp
  803175:	ff 75 08             	pushl  0x8(%ebp)
  803178:	ff 75 f0             	pushl  -0x10(%ebp)
  80317b:	ff 75 f4             	pushl  -0xc(%ebp)
  80317e:	e8 53 fb ff ff       	call   802cd6 <merging>
  803183:	83 c4 10             	add    $0x10,%esp
			break;
  803186:	90                   	nop
		}
	}
}
  803187:	eb 2e                	jmp    8031b7 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803189:	a1 34 50 80 00       	mov    0x805034,%eax
  80318e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803191:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803195:	74 07                	je     80319e <free_block+0xa5>
  803197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319a:	8b 00                	mov    (%eax),%eax
  80319c:	eb 05                	jmp    8031a3 <free_block+0xaa>
  80319e:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a3:	a3 34 50 80 00       	mov    %eax,0x805034
  8031a8:	a1 34 50 80 00       	mov    0x805034,%eax
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	75 a7                	jne    803158 <free_block+0x5f>
  8031b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b5:	75 a1                	jne    803158 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8031b7:	90                   	nop
  8031b8:	c9                   	leave  
  8031b9:	c3                   	ret    

008031ba <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8031ba:	55                   	push   %ebp
  8031bb:	89 e5                	mov    %esp,%ebp
  8031bd:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8031c0:	ff 75 08             	pushl  0x8(%ebp)
  8031c3:	e8 ed ec ff ff       	call   801eb5 <get_block_size>
  8031c8:	83 c4 04             	add    $0x4,%esp
  8031cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8031ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8031d5:	eb 17                	jmp    8031ee <copy_data+0x34>
  8031d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8031da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031dd:	01 c2                	add    %eax,%edx
  8031df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	01 c8                	add    %ecx,%eax
  8031e7:	8a 00                	mov    (%eax),%al
  8031e9:	88 02                	mov    %al,(%edx)
  8031eb:	ff 45 fc             	incl   -0x4(%ebp)
  8031ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031f1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8031f4:	72 e1                	jb     8031d7 <copy_data+0x1d>
}
  8031f6:	90                   	nop
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    

008031f9 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8031f9:	55                   	push   %ebp
  8031fa:	89 e5                	mov    %esp,%ebp
  8031fc:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8031ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803203:	75 23                	jne    803228 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803205:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803209:	74 13                	je     80321e <realloc_block_FF+0x25>
  80320b:	83 ec 0c             	sub    $0xc,%esp
  80320e:	ff 75 0c             	pushl  0xc(%ebp)
  803211:	e8 1f f0 ff ff       	call   802235 <alloc_block_FF>
  803216:	83 c4 10             	add    $0x10,%esp
  803219:	e9 f4 06 00 00       	jmp    803912 <realloc_block_FF+0x719>
		return NULL;
  80321e:	b8 00 00 00 00       	mov    $0x0,%eax
  803223:	e9 ea 06 00 00       	jmp    803912 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803228:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80322c:	75 18                	jne    803246 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80322e:	83 ec 0c             	sub    $0xc,%esp
  803231:	ff 75 08             	pushl  0x8(%ebp)
  803234:	e8 c0 fe ff ff       	call   8030f9 <free_block>
  803239:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80323c:	b8 00 00 00 00       	mov    $0x0,%eax
  803241:	e9 cc 06 00 00       	jmp    803912 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803246:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80324a:	77 07                	ja     803253 <realloc_block_FF+0x5a>
  80324c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803253:	8b 45 0c             	mov    0xc(%ebp),%eax
  803256:	83 e0 01             	and    $0x1,%eax
  803259:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80325c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80325f:	83 c0 08             	add    $0x8,%eax
  803262:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803265:	83 ec 0c             	sub    $0xc,%esp
  803268:	ff 75 08             	pushl  0x8(%ebp)
  80326b:	e8 45 ec ff ff       	call   801eb5 <get_block_size>
  803270:	83 c4 10             	add    $0x10,%esp
  803273:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803276:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803279:	83 e8 08             	sub    $0x8,%eax
  80327c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	83 e8 04             	sub    $0x4,%eax
  803285:	8b 00                	mov    (%eax),%eax
  803287:	83 e0 fe             	and    $0xfffffffe,%eax
  80328a:	89 c2                	mov    %eax,%edx
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	01 d0                	add    %edx,%eax
  803291:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803294:	83 ec 0c             	sub    $0xc,%esp
  803297:	ff 75 e4             	pushl  -0x1c(%ebp)
  80329a:	e8 16 ec ff ff       	call   801eb5 <get_block_size>
  80329f:	83 c4 10             	add    $0x10,%esp
  8032a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8032a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a8:	83 e8 08             	sub    $0x8,%eax
  8032ab:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8032ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032b1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032b4:	75 08                	jne    8032be <realloc_block_FF+0xc5>
	{
		 return va;
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	e9 54 06 00 00       	jmp    803912 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8032be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8032c4:	0f 83 e5 03 00 00    	jae    8036af <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	2b 45 0c             	sub    0xc(%ebp),%eax
  8032d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8032d3:	83 ec 0c             	sub    $0xc,%esp
  8032d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8032d9:	e8 f0 eb ff ff       	call   801ece <is_free_block>
  8032de:	83 c4 10             	add    $0x10,%esp
  8032e1:	84 c0                	test   %al,%al
  8032e3:	0f 84 3b 01 00 00    	je     803424 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8032e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032ef:	01 d0                	add    %edx,%eax
  8032f1:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8032f4:	83 ec 04             	sub    $0x4,%esp
  8032f7:	6a 01                	push   $0x1
  8032f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8032fc:	ff 75 08             	pushl  0x8(%ebp)
  8032ff:	e8 02 ef ff ff       	call   802206 <set_block_data>
  803304:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	83 e8 04             	sub    $0x4,%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	83 e0 fe             	and    $0xfffffffe,%eax
  803312:	89 c2                	mov    %eax,%edx
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	01 d0                	add    %edx,%eax
  803319:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80331c:	83 ec 04             	sub    $0x4,%esp
  80331f:	6a 00                	push   $0x0
  803321:	ff 75 cc             	pushl  -0x34(%ebp)
  803324:	ff 75 c8             	pushl  -0x38(%ebp)
  803327:	e8 da ee ff ff       	call   802206 <set_block_data>
  80332c:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80332f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803333:	74 06                	je     80333b <realloc_block_FF+0x142>
  803335:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803339:	75 17                	jne    803352 <realloc_block_FF+0x159>
  80333b:	83 ec 04             	sub    $0x4,%esp
  80333e:	68 78 44 80 00       	push   $0x804478
  803343:	68 f6 01 00 00       	push   $0x1f6
  803348:	68 05 44 80 00       	push   $0x804405
  80334d:	e8 38 06 00 00       	call   80398a <_panic>
  803352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803355:	8b 10                	mov    (%eax),%edx
  803357:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80335a:	89 10                	mov    %edx,(%eax)
  80335c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80335f:	8b 00                	mov    (%eax),%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	74 0b                	je     803370 <realloc_block_FF+0x177>
  803365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803368:	8b 00                	mov    (%eax),%eax
  80336a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80336d:	89 50 04             	mov    %edx,0x4(%eax)
  803370:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803373:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803376:	89 10                	mov    %edx,(%eax)
  803378:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80337b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80337e:	89 50 04             	mov    %edx,0x4(%eax)
  803381:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	85 c0                	test   %eax,%eax
  803388:	75 08                	jne    803392 <realloc_block_FF+0x199>
  80338a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80338d:	a3 30 50 80 00       	mov    %eax,0x805030
  803392:	a1 38 50 80 00       	mov    0x805038,%eax
  803397:	40                   	inc    %eax
  803398:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80339d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033a1:	75 17                	jne    8033ba <realloc_block_FF+0x1c1>
  8033a3:	83 ec 04             	sub    $0x4,%esp
  8033a6:	68 e7 43 80 00       	push   $0x8043e7
  8033ab:	68 f7 01 00 00       	push   $0x1f7
  8033b0:	68 05 44 80 00       	push   $0x804405
  8033b5:	e8 d0 05 00 00       	call   80398a <_panic>
  8033ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bd:	8b 00                	mov    (%eax),%eax
  8033bf:	85 c0                	test   %eax,%eax
  8033c1:	74 10                	je     8033d3 <realloc_block_FF+0x1da>
  8033c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033cb:	8b 52 04             	mov    0x4(%edx),%edx
  8033ce:	89 50 04             	mov    %edx,0x4(%eax)
  8033d1:	eb 0b                	jmp    8033de <realloc_block_FF+0x1e5>
  8033d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d6:	8b 40 04             	mov    0x4(%eax),%eax
  8033d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8033de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e1:	8b 40 04             	mov    0x4(%eax),%eax
  8033e4:	85 c0                	test   %eax,%eax
  8033e6:	74 0f                	je     8033f7 <realloc_block_FF+0x1fe>
  8033e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033eb:	8b 40 04             	mov    0x4(%eax),%eax
  8033ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033f1:	8b 12                	mov    (%edx),%edx
  8033f3:	89 10                	mov    %edx,(%eax)
  8033f5:	eb 0a                	jmp    803401 <realloc_block_FF+0x208>
  8033f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803404:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80340a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803414:	a1 38 50 80 00       	mov    0x805038,%eax
  803419:	48                   	dec    %eax
  80341a:	a3 38 50 80 00       	mov    %eax,0x805038
  80341f:	e9 83 02 00 00       	jmp    8036a7 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803424:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803428:	0f 86 69 02 00 00    	jbe    803697 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80342e:	83 ec 04             	sub    $0x4,%esp
  803431:	6a 01                	push   $0x1
  803433:	ff 75 f0             	pushl  -0x10(%ebp)
  803436:	ff 75 08             	pushl  0x8(%ebp)
  803439:	e8 c8 ed ff ff       	call   802206 <set_block_data>
  80343e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803441:	8b 45 08             	mov    0x8(%ebp),%eax
  803444:	83 e8 04             	sub    $0x4,%eax
  803447:	8b 00                	mov    (%eax),%eax
  803449:	83 e0 fe             	and    $0xfffffffe,%eax
  80344c:	89 c2                	mov    %eax,%edx
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	01 d0                	add    %edx,%eax
  803453:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803456:	a1 38 50 80 00       	mov    0x805038,%eax
  80345b:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80345e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803462:	75 68                	jne    8034cc <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803464:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803468:	75 17                	jne    803481 <realloc_block_FF+0x288>
  80346a:	83 ec 04             	sub    $0x4,%esp
  80346d:	68 20 44 80 00       	push   $0x804420
  803472:	68 06 02 00 00       	push   $0x206
  803477:	68 05 44 80 00       	push   $0x804405
  80347c:	e8 09 05 00 00       	call   80398a <_panic>
  803481:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803487:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348a:	89 10                	mov    %edx,(%eax)
  80348c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348f:	8b 00                	mov    (%eax),%eax
  803491:	85 c0                	test   %eax,%eax
  803493:	74 0d                	je     8034a2 <realloc_block_FF+0x2a9>
  803495:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80349a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80349d:	89 50 04             	mov    %edx,0x4(%eax)
  8034a0:	eb 08                	jmp    8034aa <realloc_block_FF+0x2b1>
  8034a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a5:	a3 30 50 80 00       	mov    %eax,0x805030
  8034aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c1:	40                   	inc    %eax
  8034c2:	a3 38 50 80 00       	mov    %eax,0x805038
  8034c7:	e9 b0 01 00 00       	jmp    80367c <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8034cc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8034d1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034d4:	76 68                	jbe    80353e <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8034d6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8034da:	75 17                	jne    8034f3 <realloc_block_FF+0x2fa>
  8034dc:	83 ec 04             	sub    $0x4,%esp
  8034df:	68 20 44 80 00       	push   $0x804420
  8034e4:	68 0b 02 00 00       	push   $0x20b
  8034e9:	68 05 44 80 00       	push   $0x804405
  8034ee:	e8 97 04 00 00       	call   80398a <_panic>
  8034f3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8034f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fc:	89 10                	mov    %edx,(%eax)
  8034fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803501:	8b 00                	mov    (%eax),%eax
  803503:	85 c0                	test   %eax,%eax
  803505:	74 0d                	je     803514 <realloc_block_FF+0x31b>
  803507:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80350c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80350f:	89 50 04             	mov    %edx,0x4(%eax)
  803512:	eb 08                	jmp    80351c <realloc_block_FF+0x323>
  803514:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803517:	a3 30 50 80 00       	mov    %eax,0x805030
  80351c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80351f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803524:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803527:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80352e:	a1 38 50 80 00       	mov    0x805038,%eax
  803533:	40                   	inc    %eax
  803534:	a3 38 50 80 00       	mov    %eax,0x805038
  803539:	e9 3e 01 00 00       	jmp    80367c <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80353e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803543:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803546:	73 68                	jae    8035b0 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803548:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80354c:	75 17                	jne    803565 <realloc_block_FF+0x36c>
  80354e:	83 ec 04             	sub    $0x4,%esp
  803551:	68 54 44 80 00       	push   $0x804454
  803556:	68 10 02 00 00       	push   $0x210
  80355b:	68 05 44 80 00       	push   $0x804405
  803560:	e8 25 04 00 00       	call   80398a <_panic>
  803565:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80356b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80356e:	89 50 04             	mov    %edx,0x4(%eax)
  803571:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803574:	8b 40 04             	mov    0x4(%eax),%eax
  803577:	85 c0                	test   %eax,%eax
  803579:	74 0c                	je     803587 <realloc_block_FF+0x38e>
  80357b:	a1 30 50 80 00       	mov    0x805030,%eax
  803580:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803583:	89 10                	mov    %edx,(%eax)
  803585:	eb 08                	jmp    80358f <realloc_block_FF+0x396>
  803587:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80358a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80358f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803592:	a3 30 50 80 00       	mov    %eax,0x805030
  803597:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80359a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a0:	a1 38 50 80 00       	mov    0x805038,%eax
  8035a5:	40                   	inc    %eax
  8035a6:	a3 38 50 80 00       	mov    %eax,0x805038
  8035ab:	e9 cc 00 00 00       	jmp    80367c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8035b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8035b7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8035bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035bf:	e9 8a 00 00 00       	jmp    80364e <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c7:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035ca:	73 7a                	jae    803646 <realloc_block_FF+0x44d>
  8035cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cf:	8b 00                	mov    (%eax),%eax
  8035d1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8035d4:	73 70                	jae    803646 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8035d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035da:	74 06                	je     8035e2 <realloc_block_FF+0x3e9>
  8035dc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035e0:	75 17                	jne    8035f9 <realloc_block_FF+0x400>
  8035e2:	83 ec 04             	sub    $0x4,%esp
  8035e5:	68 78 44 80 00       	push   $0x804478
  8035ea:	68 1a 02 00 00       	push   $0x21a
  8035ef:	68 05 44 80 00       	push   $0x804405
  8035f4:	e8 91 03 00 00       	call   80398a <_panic>
  8035f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fc:	8b 10                	mov    (%eax),%edx
  8035fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803601:	89 10                	mov    %edx,(%eax)
  803603:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803606:	8b 00                	mov    (%eax),%eax
  803608:	85 c0                	test   %eax,%eax
  80360a:	74 0b                	je     803617 <realloc_block_FF+0x41e>
  80360c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360f:	8b 00                	mov    (%eax),%eax
  803611:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803614:	89 50 04             	mov    %edx,0x4(%eax)
  803617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80361d:	89 10                	mov    %edx,(%eax)
  80361f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803622:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803625:	89 50 04             	mov    %edx,0x4(%eax)
  803628:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80362b:	8b 00                	mov    (%eax),%eax
  80362d:	85 c0                	test   %eax,%eax
  80362f:	75 08                	jne    803639 <realloc_block_FF+0x440>
  803631:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803634:	a3 30 50 80 00       	mov    %eax,0x805030
  803639:	a1 38 50 80 00       	mov    0x805038,%eax
  80363e:	40                   	inc    %eax
  80363f:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803644:	eb 36                	jmp    80367c <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803646:	a1 34 50 80 00       	mov    0x805034,%eax
  80364b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80364e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803652:	74 07                	je     80365b <realloc_block_FF+0x462>
  803654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803657:	8b 00                	mov    (%eax),%eax
  803659:	eb 05                	jmp    803660 <realloc_block_FF+0x467>
  80365b:	b8 00 00 00 00       	mov    $0x0,%eax
  803660:	a3 34 50 80 00       	mov    %eax,0x805034
  803665:	a1 34 50 80 00       	mov    0x805034,%eax
  80366a:	85 c0                	test   %eax,%eax
  80366c:	0f 85 52 ff ff ff    	jne    8035c4 <realloc_block_FF+0x3cb>
  803672:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803676:	0f 85 48 ff ff ff    	jne    8035c4 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80367c:	83 ec 04             	sub    $0x4,%esp
  80367f:	6a 00                	push   $0x0
  803681:	ff 75 d8             	pushl  -0x28(%ebp)
  803684:	ff 75 d4             	pushl  -0x2c(%ebp)
  803687:	e8 7a eb ff ff       	call   802206 <set_block_data>
  80368c:	83 c4 10             	add    $0x10,%esp
				return va;
  80368f:	8b 45 08             	mov    0x8(%ebp),%eax
  803692:	e9 7b 02 00 00       	jmp    803912 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803697:	83 ec 0c             	sub    $0xc,%esp
  80369a:	68 f5 44 80 00       	push   $0x8044f5
  80369f:	e8 24 cd ff ff       	call   8003c8 <cprintf>
  8036a4:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	e9 63 02 00 00       	jmp    803912 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8036af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036b2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8036b5:	0f 86 4d 02 00 00    	jbe    803908 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8036bb:	83 ec 0c             	sub    $0xc,%esp
  8036be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8036c1:	e8 08 e8 ff ff       	call   801ece <is_free_block>
  8036c6:	83 c4 10             	add    $0x10,%esp
  8036c9:	84 c0                	test   %al,%al
  8036cb:	0f 84 37 02 00 00    	je     803908 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8036d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036d4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8036d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8036da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8036dd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036e0:	76 38                	jbe    80371a <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8036e2:	83 ec 0c             	sub    $0xc,%esp
  8036e5:	ff 75 08             	pushl  0x8(%ebp)
  8036e8:	e8 0c fa ff ff       	call   8030f9 <free_block>
  8036ed:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8036f0:	83 ec 0c             	sub    $0xc,%esp
  8036f3:	ff 75 0c             	pushl  0xc(%ebp)
  8036f6:	e8 3a eb ff ff       	call   802235 <alloc_block_FF>
  8036fb:	83 c4 10             	add    $0x10,%esp
  8036fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803701:	83 ec 08             	sub    $0x8,%esp
  803704:	ff 75 c0             	pushl  -0x40(%ebp)
  803707:	ff 75 08             	pushl  0x8(%ebp)
  80370a:	e8 ab fa ff ff       	call   8031ba <copy_data>
  80370f:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803712:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803715:	e9 f8 01 00 00       	jmp    803912 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80371a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80371d:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803720:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803723:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803727:	0f 87 a0 00 00 00    	ja     8037cd <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80372d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803731:	75 17                	jne    80374a <realloc_block_FF+0x551>
  803733:	83 ec 04             	sub    $0x4,%esp
  803736:	68 e7 43 80 00       	push   $0x8043e7
  80373b:	68 38 02 00 00       	push   $0x238
  803740:	68 05 44 80 00       	push   $0x804405
  803745:	e8 40 02 00 00       	call   80398a <_panic>
  80374a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374d:	8b 00                	mov    (%eax),%eax
  80374f:	85 c0                	test   %eax,%eax
  803751:	74 10                	je     803763 <realloc_block_FF+0x56a>
  803753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803756:	8b 00                	mov    (%eax),%eax
  803758:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80375b:	8b 52 04             	mov    0x4(%edx),%edx
  80375e:	89 50 04             	mov    %edx,0x4(%eax)
  803761:	eb 0b                	jmp    80376e <realloc_block_FF+0x575>
  803763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803766:	8b 40 04             	mov    0x4(%eax),%eax
  803769:	a3 30 50 80 00       	mov    %eax,0x805030
  80376e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803771:	8b 40 04             	mov    0x4(%eax),%eax
  803774:	85 c0                	test   %eax,%eax
  803776:	74 0f                	je     803787 <realloc_block_FF+0x58e>
  803778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377b:	8b 40 04             	mov    0x4(%eax),%eax
  80377e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803781:	8b 12                	mov    (%edx),%edx
  803783:	89 10                	mov    %edx,(%eax)
  803785:	eb 0a                	jmp    803791 <realloc_block_FF+0x598>
  803787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378a:	8b 00                	mov    (%eax),%eax
  80378c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803794:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8037a9:	48                   	dec    %eax
  8037aa:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8037af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037b5:	01 d0                	add    %edx,%eax
  8037b7:	83 ec 04             	sub    $0x4,%esp
  8037ba:	6a 01                	push   $0x1
  8037bc:	50                   	push   %eax
  8037bd:	ff 75 08             	pushl  0x8(%ebp)
  8037c0:	e8 41 ea ff ff       	call   802206 <set_block_data>
  8037c5:	83 c4 10             	add    $0x10,%esp
  8037c8:	e9 36 01 00 00       	jmp    803903 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8037cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037d0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037d3:	01 d0                	add    %edx,%eax
  8037d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8037d8:	83 ec 04             	sub    $0x4,%esp
  8037db:	6a 01                	push   $0x1
  8037dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8037e0:	ff 75 08             	pushl  0x8(%ebp)
  8037e3:	e8 1e ea ff ff       	call   802206 <set_block_data>
  8037e8:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8037eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ee:	83 e8 04             	sub    $0x4,%eax
  8037f1:	8b 00                	mov    (%eax),%eax
  8037f3:	83 e0 fe             	and    $0xfffffffe,%eax
  8037f6:	89 c2                	mov    %eax,%edx
  8037f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fb:	01 d0                	add    %edx,%eax
  8037fd:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803800:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803804:	74 06                	je     80380c <realloc_block_FF+0x613>
  803806:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80380a:	75 17                	jne    803823 <realloc_block_FF+0x62a>
  80380c:	83 ec 04             	sub    $0x4,%esp
  80380f:	68 78 44 80 00       	push   $0x804478
  803814:	68 44 02 00 00       	push   $0x244
  803819:	68 05 44 80 00       	push   $0x804405
  80381e:	e8 67 01 00 00       	call   80398a <_panic>
  803823:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803826:	8b 10                	mov    (%eax),%edx
  803828:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80382b:	89 10                	mov    %edx,(%eax)
  80382d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803830:	8b 00                	mov    (%eax),%eax
  803832:	85 c0                	test   %eax,%eax
  803834:	74 0b                	je     803841 <realloc_block_FF+0x648>
  803836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803839:	8b 00                	mov    (%eax),%eax
  80383b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80383e:	89 50 04             	mov    %edx,0x4(%eax)
  803841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803844:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803847:	89 10                	mov    %edx,(%eax)
  803849:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80384c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80384f:	89 50 04             	mov    %edx,0x4(%eax)
  803852:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803855:	8b 00                	mov    (%eax),%eax
  803857:	85 c0                	test   %eax,%eax
  803859:	75 08                	jne    803863 <realloc_block_FF+0x66a>
  80385b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80385e:	a3 30 50 80 00       	mov    %eax,0x805030
  803863:	a1 38 50 80 00       	mov    0x805038,%eax
  803868:	40                   	inc    %eax
  803869:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80386e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803872:	75 17                	jne    80388b <realloc_block_FF+0x692>
  803874:	83 ec 04             	sub    $0x4,%esp
  803877:	68 e7 43 80 00       	push   $0x8043e7
  80387c:	68 45 02 00 00       	push   $0x245
  803881:	68 05 44 80 00       	push   $0x804405
  803886:	e8 ff 00 00 00       	call   80398a <_panic>
  80388b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388e:	8b 00                	mov    (%eax),%eax
  803890:	85 c0                	test   %eax,%eax
  803892:	74 10                	je     8038a4 <realloc_block_FF+0x6ab>
  803894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803897:	8b 00                	mov    (%eax),%eax
  803899:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80389c:	8b 52 04             	mov    0x4(%edx),%edx
  80389f:	89 50 04             	mov    %edx,0x4(%eax)
  8038a2:	eb 0b                	jmp    8038af <realloc_block_FF+0x6b6>
  8038a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a7:	8b 40 04             	mov    0x4(%eax),%eax
  8038aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8038af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b2:	8b 40 04             	mov    0x4(%eax),%eax
  8038b5:	85 c0                	test   %eax,%eax
  8038b7:	74 0f                	je     8038c8 <realloc_block_FF+0x6cf>
  8038b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038bc:	8b 40 04             	mov    0x4(%eax),%eax
  8038bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038c2:	8b 12                	mov    (%edx),%edx
  8038c4:	89 10                	mov    %edx,(%eax)
  8038c6:	eb 0a                	jmp    8038d2 <realloc_block_FF+0x6d9>
  8038c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038cb:	8b 00                	mov    (%eax),%eax
  8038cd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8038d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e5:	a1 38 50 80 00       	mov    0x805038,%eax
  8038ea:	48                   	dec    %eax
  8038eb:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8038f0:	83 ec 04             	sub    $0x4,%esp
  8038f3:	6a 00                	push   $0x0
  8038f5:	ff 75 bc             	pushl  -0x44(%ebp)
  8038f8:	ff 75 b8             	pushl  -0x48(%ebp)
  8038fb:	e8 06 e9 ff ff       	call   802206 <set_block_data>
  803900:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803903:	8b 45 08             	mov    0x8(%ebp),%eax
  803906:	eb 0a                	jmp    803912 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803908:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80390f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803912:	c9                   	leave  
  803913:	c3                   	ret    

00803914 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803914:	55                   	push   %ebp
  803915:	89 e5                	mov    %esp,%ebp
  803917:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80391a:	83 ec 04             	sub    $0x4,%esp
  80391d:	68 fc 44 80 00       	push   $0x8044fc
  803922:	68 58 02 00 00       	push   $0x258
  803927:	68 05 44 80 00       	push   $0x804405
  80392c:	e8 59 00 00 00       	call   80398a <_panic>

00803931 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803931:	55                   	push   %ebp
  803932:	89 e5                	mov    %esp,%ebp
  803934:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803937:	83 ec 04             	sub    $0x4,%esp
  80393a:	68 24 45 80 00       	push   $0x804524
  80393f:	68 61 02 00 00       	push   $0x261
  803944:	68 05 44 80 00       	push   $0x804405
  803949:	e8 3c 00 00 00       	call   80398a <_panic>

0080394e <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80394e:	55                   	push   %ebp
  80394f:	89 e5                	mov    %esp,%ebp
  803951:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80395a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80395e:	83 ec 0c             	sub    $0xc,%esp
  803961:	50                   	push   %eax
  803962:	e8 dd e0 ff ff       	call   801a44 <sys_cputc>
  803967:	83 c4 10             	add    $0x10,%esp
}
  80396a:	90                   	nop
  80396b:	c9                   	leave  
  80396c:	c3                   	ret    

0080396d <getchar>:


int
getchar(void)
{
  80396d:	55                   	push   %ebp
  80396e:	89 e5                	mov    %esp,%ebp
  803970:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  803973:	e8 68 df ff ff       	call   8018e0 <sys_cgetc>
  803978:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  80397b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80397e:	c9                   	leave  
  80397f:	c3                   	ret    

00803980 <iscons>:

int iscons(int fdnum)
{
  803980:	55                   	push   %ebp
  803981:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  803983:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803988:	5d                   	pop    %ebp
  803989:	c3                   	ret    

0080398a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80398a:	55                   	push   %ebp
  80398b:	89 e5                	mov    %esp,%ebp
  80398d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803990:	8d 45 10             	lea    0x10(%ebp),%eax
  803993:	83 c0 04             	add    $0x4,%eax
  803996:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803999:	a1 60 50 98 00       	mov    0x985060,%eax
  80399e:	85 c0                	test   %eax,%eax
  8039a0:	74 16                	je     8039b8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8039a2:	a1 60 50 98 00       	mov    0x985060,%eax
  8039a7:	83 ec 08             	sub    $0x8,%esp
  8039aa:	50                   	push   %eax
  8039ab:	68 4c 45 80 00       	push   $0x80454c
  8039b0:	e8 13 ca ff ff       	call   8003c8 <cprintf>
  8039b5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8039b8:	a1 00 50 80 00       	mov    0x805000,%eax
  8039bd:	ff 75 0c             	pushl  0xc(%ebp)
  8039c0:	ff 75 08             	pushl  0x8(%ebp)
  8039c3:	50                   	push   %eax
  8039c4:	68 51 45 80 00       	push   $0x804551
  8039c9:	e8 fa c9 ff ff       	call   8003c8 <cprintf>
  8039ce:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8039d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8039d4:	83 ec 08             	sub    $0x8,%esp
  8039d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8039da:	50                   	push   %eax
  8039db:	e8 7d c9 ff ff       	call   80035d <vcprintf>
  8039e0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8039e3:	83 ec 08             	sub    $0x8,%esp
  8039e6:	6a 00                	push   $0x0
  8039e8:	68 6d 45 80 00       	push   $0x80456d
  8039ed:	e8 6b c9 ff ff       	call   80035d <vcprintf>
  8039f2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8039f5:	e8 ec c8 ff ff       	call   8002e6 <exit>

	// should not return here
	while (1) ;
  8039fa:	eb fe                	jmp    8039fa <_panic+0x70>

008039fc <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8039fc:	55                   	push   %ebp
  8039fd:	89 e5                	mov    %esp,%ebp
  8039ff:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a02:	a1 20 50 80 00       	mov    0x805020,%eax
  803a07:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a10:	39 c2                	cmp    %eax,%edx
  803a12:	74 14                	je     803a28 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a14:	83 ec 04             	sub    $0x4,%esp
  803a17:	68 70 45 80 00       	push   $0x804570
  803a1c:	6a 26                	push   $0x26
  803a1e:	68 bc 45 80 00       	push   $0x8045bc
  803a23:	e8 62 ff ff ff       	call   80398a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803a2f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a36:	e9 c5 00 00 00       	jmp    803b00 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a45:	8b 45 08             	mov    0x8(%ebp),%eax
  803a48:	01 d0                	add    %edx,%eax
  803a4a:	8b 00                	mov    (%eax),%eax
  803a4c:	85 c0                	test   %eax,%eax
  803a4e:	75 08                	jne    803a58 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a50:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a53:	e9 a5 00 00 00       	jmp    803afd <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a58:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a5f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a66:	eb 69                	jmp    803ad1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a68:	a1 20 50 80 00       	mov    0x805020,%eax
  803a6d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a73:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a76:	89 d0                	mov    %edx,%eax
  803a78:	01 c0                	add    %eax,%eax
  803a7a:	01 d0                	add    %edx,%eax
  803a7c:	c1 e0 03             	shl    $0x3,%eax
  803a7f:	01 c8                	add    %ecx,%eax
  803a81:	8a 40 04             	mov    0x4(%eax),%al
  803a84:	84 c0                	test   %al,%al
  803a86:	75 46                	jne    803ace <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a88:	a1 20 50 80 00       	mov    0x805020,%eax
  803a8d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a93:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a96:	89 d0                	mov    %edx,%eax
  803a98:	01 c0                	add    %eax,%eax
  803a9a:	01 d0                	add    %edx,%eax
  803a9c:	c1 e0 03             	shl    $0x3,%eax
  803a9f:	01 c8                	add    %ecx,%eax
  803aa1:	8b 00                	mov    (%eax),%eax
  803aa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803aa6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803aa9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803aae:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803aba:	8b 45 08             	mov    0x8(%ebp),%eax
  803abd:	01 c8                	add    %ecx,%eax
  803abf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803ac1:	39 c2                	cmp    %eax,%edx
  803ac3:	75 09                	jne    803ace <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803ac5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803acc:	eb 15                	jmp    803ae3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803ace:	ff 45 e8             	incl   -0x18(%ebp)
  803ad1:	a1 20 50 80 00       	mov    0x805020,%eax
  803ad6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803adc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803adf:	39 c2                	cmp    %eax,%edx
  803ae1:	77 85                	ja     803a68 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803ae3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ae7:	75 14                	jne    803afd <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803ae9:	83 ec 04             	sub    $0x4,%esp
  803aec:	68 c8 45 80 00       	push   $0x8045c8
  803af1:	6a 3a                	push   $0x3a
  803af3:	68 bc 45 80 00       	push   $0x8045bc
  803af8:	e8 8d fe ff ff       	call   80398a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803afd:	ff 45 f0             	incl   -0x10(%ebp)
  803b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b03:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b06:	0f 8c 2f ff ff ff    	jl     803a3b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b0c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b13:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b1a:	eb 26                	jmp    803b42 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b1c:	a1 20 50 80 00       	mov    0x805020,%eax
  803b21:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b2a:	89 d0                	mov    %edx,%eax
  803b2c:	01 c0                	add    %eax,%eax
  803b2e:	01 d0                	add    %edx,%eax
  803b30:	c1 e0 03             	shl    $0x3,%eax
  803b33:	01 c8                	add    %ecx,%eax
  803b35:	8a 40 04             	mov    0x4(%eax),%al
  803b38:	3c 01                	cmp    $0x1,%al
  803b3a:	75 03                	jne    803b3f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b3c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b3f:	ff 45 e0             	incl   -0x20(%ebp)
  803b42:	a1 20 50 80 00       	mov    0x805020,%eax
  803b47:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b50:	39 c2                	cmp    %eax,%edx
  803b52:	77 c8                	ja     803b1c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b57:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b5a:	74 14                	je     803b70 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b5c:	83 ec 04             	sub    $0x4,%esp
  803b5f:	68 1c 46 80 00       	push   $0x80461c
  803b64:	6a 44                	push   $0x44
  803b66:	68 bc 45 80 00       	push   $0x8045bc
  803b6b:	e8 1a fe ff ff       	call   80398a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b70:	90                   	nop
  803b71:	c9                   	leave  
  803b72:	c3                   	ret    
  803b73:	90                   	nop

00803b74 <__udivdi3>:
  803b74:	55                   	push   %ebp
  803b75:	57                   	push   %edi
  803b76:	56                   	push   %esi
  803b77:	53                   	push   %ebx
  803b78:	83 ec 1c             	sub    $0x1c,%esp
  803b7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803b7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b8b:	89 ca                	mov    %ecx,%edx
  803b8d:	89 f8                	mov    %edi,%eax
  803b8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b93:	85 f6                	test   %esi,%esi
  803b95:	75 2d                	jne    803bc4 <__udivdi3+0x50>
  803b97:	39 cf                	cmp    %ecx,%edi
  803b99:	77 65                	ja     803c00 <__udivdi3+0x8c>
  803b9b:	89 fd                	mov    %edi,%ebp
  803b9d:	85 ff                	test   %edi,%edi
  803b9f:	75 0b                	jne    803bac <__udivdi3+0x38>
  803ba1:	b8 01 00 00 00       	mov    $0x1,%eax
  803ba6:	31 d2                	xor    %edx,%edx
  803ba8:	f7 f7                	div    %edi
  803baa:	89 c5                	mov    %eax,%ebp
  803bac:	31 d2                	xor    %edx,%edx
  803bae:	89 c8                	mov    %ecx,%eax
  803bb0:	f7 f5                	div    %ebp
  803bb2:	89 c1                	mov    %eax,%ecx
  803bb4:	89 d8                	mov    %ebx,%eax
  803bb6:	f7 f5                	div    %ebp
  803bb8:	89 cf                	mov    %ecx,%edi
  803bba:	89 fa                	mov    %edi,%edx
  803bbc:	83 c4 1c             	add    $0x1c,%esp
  803bbf:	5b                   	pop    %ebx
  803bc0:	5e                   	pop    %esi
  803bc1:	5f                   	pop    %edi
  803bc2:	5d                   	pop    %ebp
  803bc3:	c3                   	ret    
  803bc4:	39 ce                	cmp    %ecx,%esi
  803bc6:	77 28                	ja     803bf0 <__udivdi3+0x7c>
  803bc8:	0f bd fe             	bsr    %esi,%edi
  803bcb:	83 f7 1f             	xor    $0x1f,%edi
  803bce:	75 40                	jne    803c10 <__udivdi3+0x9c>
  803bd0:	39 ce                	cmp    %ecx,%esi
  803bd2:	72 0a                	jb     803bde <__udivdi3+0x6a>
  803bd4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803bd8:	0f 87 9e 00 00 00    	ja     803c7c <__udivdi3+0x108>
  803bde:	b8 01 00 00 00       	mov    $0x1,%eax
  803be3:	89 fa                	mov    %edi,%edx
  803be5:	83 c4 1c             	add    $0x1c,%esp
  803be8:	5b                   	pop    %ebx
  803be9:	5e                   	pop    %esi
  803bea:	5f                   	pop    %edi
  803beb:	5d                   	pop    %ebp
  803bec:	c3                   	ret    
  803bed:	8d 76 00             	lea    0x0(%esi),%esi
  803bf0:	31 ff                	xor    %edi,%edi
  803bf2:	31 c0                	xor    %eax,%eax
  803bf4:	89 fa                	mov    %edi,%edx
  803bf6:	83 c4 1c             	add    $0x1c,%esp
  803bf9:	5b                   	pop    %ebx
  803bfa:	5e                   	pop    %esi
  803bfb:	5f                   	pop    %edi
  803bfc:	5d                   	pop    %ebp
  803bfd:	c3                   	ret    
  803bfe:	66 90                	xchg   %ax,%ax
  803c00:	89 d8                	mov    %ebx,%eax
  803c02:	f7 f7                	div    %edi
  803c04:	31 ff                	xor    %edi,%edi
  803c06:	89 fa                	mov    %edi,%edx
  803c08:	83 c4 1c             	add    $0x1c,%esp
  803c0b:	5b                   	pop    %ebx
  803c0c:	5e                   	pop    %esi
  803c0d:	5f                   	pop    %edi
  803c0e:	5d                   	pop    %ebp
  803c0f:	c3                   	ret    
  803c10:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c15:	89 eb                	mov    %ebp,%ebx
  803c17:	29 fb                	sub    %edi,%ebx
  803c19:	89 f9                	mov    %edi,%ecx
  803c1b:	d3 e6                	shl    %cl,%esi
  803c1d:	89 c5                	mov    %eax,%ebp
  803c1f:	88 d9                	mov    %bl,%cl
  803c21:	d3 ed                	shr    %cl,%ebp
  803c23:	89 e9                	mov    %ebp,%ecx
  803c25:	09 f1                	or     %esi,%ecx
  803c27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c2b:	89 f9                	mov    %edi,%ecx
  803c2d:	d3 e0                	shl    %cl,%eax
  803c2f:	89 c5                	mov    %eax,%ebp
  803c31:	89 d6                	mov    %edx,%esi
  803c33:	88 d9                	mov    %bl,%cl
  803c35:	d3 ee                	shr    %cl,%esi
  803c37:	89 f9                	mov    %edi,%ecx
  803c39:	d3 e2                	shl    %cl,%edx
  803c3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c3f:	88 d9                	mov    %bl,%cl
  803c41:	d3 e8                	shr    %cl,%eax
  803c43:	09 c2                	or     %eax,%edx
  803c45:	89 d0                	mov    %edx,%eax
  803c47:	89 f2                	mov    %esi,%edx
  803c49:	f7 74 24 0c          	divl   0xc(%esp)
  803c4d:	89 d6                	mov    %edx,%esi
  803c4f:	89 c3                	mov    %eax,%ebx
  803c51:	f7 e5                	mul    %ebp
  803c53:	39 d6                	cmp    %edx,%esi
  803c55:	72 19                	jb     803c70 <__udivdi3+0xfc>
  803c57:	74 0b                	je     803c64 <__udivdi3+0xf0>
  803c59:	89 d8                	mov    %ebx,%eax
  803c5b:	31 ff                	xor    %edi,%edi
  803c5d:	e9 58 ff ff ff       	jmp    803bba <__udivdi3+0x46>
  803c62:	66 90                	xchg   %ax,%ax
  803c64:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c68:	89 f9                	mov    %edi,%ecx
  803c6a:	d3 e2                	shl    %cl,%edx
  803c6c:	39 c2                	cmp    %eax,%edx
  803c6e:	73 e9                	jae    803c59 <__udivdi3+0xe5>
  803c70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803c73:	31 ff                	xor    %edi,%edi
  803c75:	e9 40 ff ff ff       	jmp    803bba <__udivdi3+0x46>
  803c7a:	66 90                	xchg   %ax,%ax
  803c7c:	31 c0                	xor    %eax,%eax
  803c7e:	e9 37 ff ff ff       	jmp    803bba <__udivdi3+0x46>
  803c83:	90                   	nop

00803c84 <__umoddi3>:
  803c84:	55                   	push   %ebp
  803c85:	57                   	push   %edi
  803c86:	56                   	push   %esi
  803c87:	53                   	push   %ebx
  803c88:	83 ec 1c             	sub    $0x1c,%esp
  803c8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ca3:	89 f3                	mov    %esi,%ebx
  803ca5:	89 fa                	mov    %edi,%edx
  803ca7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cab:	89 34 24             	mov    %esi,(%esp)
  803cae:	85 c0                	test   %eax,%eax
  803cb0:	75 1a                	jne    803ccc <__umoddi3+0x48>
  803cb2:	39 f7                	cmp    %esi,%edi
  803cb4:	0f 86 a2 00 00 00    	jbe    803d5c <__umoddi3+0xd8>
  803cba:	89 c8                	mov    %ecx,%eax
  803cbc:	89 f2                	mov    %esi,%edx
  803cbe:	f7 f7                	div    %edi
  803cc0:	89 d0                	mov    %edx,%eax
  803cc2:	31 d2                	xor    %edx,%edx
  803cc4:	83 c4 1c             	add    $0x1c,%esp
  803cc7:	5b                   	pop    %ebx
  803cc8:	5e                   	pop    %esi
  803cc9:	5f                   	pop    %edi
  803cca:	5d                   	pop    %ebp
  803ccb:	c3                   	ret    
  803ccc:	39 f0                	cmp    %esi,%eax
  803cce:	0f 87 ac 00 00 00    	ja     803d80 <__umoddi3+0xfc>
  803cd4:	0f bd e8             	bsr    %eax,%ebp
  803cd7:	83 f5 1f             	xor    $0x1f,%ebp
  803cda:	0f 84 ac 00 00 00    	je     803d8c <__umoddi3+0x108>
  803ce0:	bf 20 00 00 00       	mov    $0x20,%edi
  803ce5:	29 ef                	sub    %ebp,%edi
  803ce7:	89 fe                	mov    %edi,%esi
  803ce9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ced:	89 e9                	mov    %ebp,%ecx
  803cef:	d3 e0                	shl    %cl,%eax
  803cf1:	89 d7                	mov    %edx,%edi
  803cf3:	89 f1                	mov    %esi,%ecx
  803cf5:	d3 ef                	shr    %cl,%edi
  803cf7:	09 c7                	or     %eax,%edi
  803cf9:	89 e9                	mov    %ebp,%ecx
  803cfb:	d3 e2                	shl    %cl,%edx
  803cfd:	89 14 24             	mov    %edx,(%esp)
  803d00:	89 d8                	mov    %ebx,%eax
  803d02:	d3 e0                	shl    %cl,%eax
  803d04:	89 c2                	mov    %eax,%edx
  803d06:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d0a:	d3 e0                	shl    %cl,%eax
  803d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d10:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d14:	89 f1                	mov    %esi,%ecx
  803d16:	d3 e8                	shr    %cl,%eax
  803d18:	09 d0                	or     %edx,%eax
  803d1a:	d3 eb                	shr    %cl,%ebx
  803d1c:	89 da                	mov    %ebx,%edx
  803d1e:	f7 f7                	div    %edi
  803d20:	89 d3                	mov    %edx,%ebx
  803d22:	f7 24 24             	mull   (%esp)
  803d25:	89 c6                	mov    %eax,%esi
  803d27:	89 d1                	mov    %edx,%ecx
  803d29:	39 d3                	cmp    %edx,%ebx
  803d2b:	0f 82 87 00 00 00    	jb     803db8 <__umoddi3+0x134>
  803d31:	0f 84 91 00 00 00    	je     803dc8 <__umoddi3+0x144>
  803d37:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d3b:	29 f2                	sub    %esi,%edx
  803d3d:	19 cb                	sbb    %ecx,%ebx
  803d3f:	89 d8                	mov    %ebx,%eax
  803d41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d45:	d3 e0                	shl    %cl,%eax
  803d47:	89 e9                	mov    %ebp,%ecx
  803d49:	d3 ea                	shr    %cl,%edx
  803d4b:	09 d0                	or     %edx,%eax
  803d4d:	89 e9                	mov    %ebp,%ecx
  803d4f:	d3 eb                	shr    %cl,%ebx
  803d51:	89 da                	mov    %ebx,%edx
  803d53:	83 c4 1c             	add    $0x1c,%esp
  803d56:	5b                   	pop    %ebx
  803d57:	5e                   	pop    %esi
  803d58:	5f                   	pop    %edi
  803d59:	5d                   	pop    %ebp
  803d5a:	c3                   	ret    
  803d5b:	90                   	nop
  803d5c:	89 fd                	mov    %edi,%ebp
  803d5e:	85 ff                	test   %edi,%edi
  803d60:	75 0b                	jne    803d6d <__umoddi3+0xe9>
  803d62:	b8 01 00 00 00       	mov    $0x1,%eax
  803d67:	31 d2                	xor    %edx,%edx
  803d69:	f7 f7                	div    %edi
  803d6b:	89 c5                	mov    %eax,%ebp
  803d6d:	89 f0                	mov    %esi,%eax
  803d6f:	31 d2                	xor    %edx,%edx
  803d71:	f7 f5                	div    %ebp
  803d73:	89 c8                	mov    %ecx,%eax
  803d75:	f7 f5                	div    %ebp
  803d77:	89 d0                	mov    %edx,%eax
  803d79:	e9 44 ff ff ff       	jmp    803cc2 <__umoddi3+0x3e>
  803d7e:	66 90                	xchg   %ax,%ax
  803d80:	89 c8                	mov    %ecx,%eax
  803d82:	89 f2                	mov    %esi,%edx
  803d84:	83 c4 1c             	add    $0x1c,%esp
  803d87:	5b                   	pop    %ebx
  803d88:	5e                   	pop    %esi
  803d89:	5f                   	pop    %edi
  803d8a:	5d                   	pop    %ebp
  803d8b:	c3                   	ret    
  803d8c:	3b 04 24             	cmp    (%esp),%eax
  803d8f:	72 06                	jb     803d97 <__umoddi3+0x113>
  803d91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d95:	77 0f                	ja     803da6 <__umoddi3+0x122>
  803d97:	89 f2                	mov    %esi,%edx
  803d99:	29 f9                	sub    %edi,%ecx
  803d9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d9f:	89 14 24             	mov    %edx,(%esp)
  803da2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803da6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803daa:	8b 14 24             	mov    (%esp),%edx
  803dad:	83 c4 1c             	add    $0x1c,%esp
  803db0:	5b                   	pop    %ebx
  803db1:	5e                   	pop    %esi
  803db2:	5f                   	pop    %edi
  803db3:	5d                   	pop    %ebp
  803db4:	c3                   	ret    
  803db5:	8d 76 00             	lea    0x0(%esi),%esi
  803db8:	2b 04 24             	sub    (%esp),%eax
  803dbb:	19 fa                	sbb    %edi,%edx
  803dbd:	89 d1                	mov    %edx,%ecx
  803dbf:	89 c6                	mov    %eax,%esi
  803dc1:	e9 71 ff ff ff       	jmp    803d37 <__umoddi3+0xb3>
  803dc6:	66 90                	xchg   %ax,%ax
  803dc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dcc:	72 ea                	jb     803db8 <__umoddi3+0x134>
  803dce:	89 d9                	mov    %ebx,%ecx
  803dd0:	e9 62 ff ff ff       	jmp    803d37 <__umoddi3+0xb3>
