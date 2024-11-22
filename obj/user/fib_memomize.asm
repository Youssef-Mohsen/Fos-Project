
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
  800052:	68 40 3d 80 00       	push   $0x803d40
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
  8000ec:	68 5e 3d 80 00       	push   $0x803d5e
  8000f1:	e8 ff 02 00 00       	call   8003f5 <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 03 1b 00 00       	call   801c01 <inctst>
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
  8001bb:	e8 03 19 00 00       	call   801ac3 <sys_getenvindex>
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
  800229:	e8 19 16 00 00       	call   801847 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	68 8c 3d 80 00       	push   $0x803d8c
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
  800259:	68 b4 3d 80 00       	push   $0x803db4
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
  80028a:	68 dc 3d 80 00       	push   $0x803ddc
  80028f:	e8 34 01 00 00       	call   8003c8 <cprintf>
  800294:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800297:	a1 20 50 80 00       	mov    0x805020,%eax
  80029c:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	50                   	push   %eax
  8002a6:	68 34 3e 80 00       	push   $0x803e34
  8002ab:	e8 18 01 00 00       	call   8003c8 <cprintf>
  8002b0:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	68 8c 3d 80 00       	push   $0x803d8c
  8002bb:	e8 08 01 00 00       	call   8003c8 <cprintf>
  8002c0:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002c3:	e8 99 15 00 00       	call   801861 <sys_unlock_cons>
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
  8002db:	e8 af 17 00 00       	call   801a8f <sys_destroy_env>
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
  8002ec:	e8 04 18 00 00       	call   801af5 <sys_exit_env>
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
  80033a:	e8 c6 14 00 00       	call   801805 <sys_cputs>
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
  8003b1:	e8 4f 14 00 00       	call   801805 <sys_cputs>
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
  8003fb:	e8 47 14 00 00       	call   801847 <sys_lock_cons>
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
  80041b:	e8 41 14 00 00       	call   801861 <sys_unlock_cons>
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
  800465:	e8 5a 36 00 00       	call   803ac4 <__udivdi3>
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
  8004b5:	e8 1a 37 00 00       	call   803bd4 <__umoddi3>
  8004ba:	83 c4 10             	add    $0x10,%esp
  8004bd:	05 74 40 80 00       	add    $0x804074,%eax
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
  800610:	8b 04 85 98 40 80 00 	mov    0x804098(,%eax,4),%eax
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
  8006f1:	8b 34 9d e0 3e 80 00 	mov    0x803ee0(,%ebx,4),%esi
  8006f8:	85 f6                	test   %esi,%esi
  8006fa:	75 19                	jne    800715 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006fc:	53                   	push   %ebx
  8006fd:	68 85 40 80 00       	push   $0x804085
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
  800716:	68 8e 40 80 00       	push   $0x80408e
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
  800743:	be 91 40 80 00       	mov    $0x804091,%esi
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
  800a6e:	68 08 42 80 00       	push   $0x804208
  800a73:	e8 50 f9 ff ff       	call   8003c8 <cprintf>
  800a78:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a82:	83 ec 0c             	sub    $0xc,%esp
  800a85:	6a 00                	push   $0x0
  800a87:	e8 42 2e 00 00       	call   8038ce <iscons>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a92:	e8 24 2e 00 00       	call   8038bb <getchar>
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
  800ab0:	68 0b 42 80 00       	push   $0x80420b
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
  800add:	e8 ba 2d 00 00       	call   80389c <cputchar>
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
  800b14:	e8 83 2d 00 00       	call   80389c <cputchar>
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
  800b3d:	e8 5a 2d 00 00       	call   80389c <cputchar>
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
  800b61:	e8 e1 0c 00 00       	call   801847 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b6a:	74 13                	je     800b7f <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b6c:	83 ec 08             	sub    $0x8,%esp
  800b6f:	ff 75 08             	pushl  0x8(%ebp)
  800b72:	68 08 42 80 00       	push   $0x804208
  800b77:	e8 4c f8 ff ff       	call   8003c8 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b86:	83 ec 0c             	sub    $0xc,%esp
  800b89:	6a 00                	push   $0x0
  800b8b:	e8 3e 2d 00 00       	call   8038ce <iscons>
  800b90:	83 c4 10             	add    $0x10,%esp
  800b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b96:	e8 20 2d 00 00       	call   8038bb <getchar>
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
  800bb4:	68 0b 42 80 00       	push   $0x80420b
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
  800be1:	e8 b6 2c 00 00       	call   80389c <cputchar>
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
  800c18:	e8 7f 2c 00 00       	call   80389c <cputchar>
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
  800c41:	e8 56 2c 00 00       	call   80389c <cputchar>
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
  800c5c:	e8 00 0c 00 00       	call   801861 <sys_unlock_cons>
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
  801356:	68 1c 42 80 00       	push   $0x80421c
  80135b:	68 3f 01 00 00       	push   $0x13f
  801360:	68 3e 42 80 00       	push   $0x80423e
  801365:	e8 6e 25 00 00       	call   8038d8 <_panic>

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
  801376:	e8 35 0a 00 00       	call   801db0 <sys_sbrk>
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
  8013f1:	e8 3e 08 00 00       	call   801c34 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	74 16                	je     801410 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  8013fa:	83 ec 0c             	sub    $0xc,%esp
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 7e 0d 00 00       	call   802183 <alloc_block_FF>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80140b:	e9 8a 01 00 00       	jmp    80159a <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801410:	e8 50 08 00 00       	call   801c65 <sys_isUHeapPlacementStrategyBESTFIT>
  801415:	85 c0                	test   %eax,%eax
  801417:	0f 84 7d 01 00 00    	je     80159a <malloc+0x21a>
			ptr = alloc_block_BF(size);
  80141d:	83 ec 0c             	sub    $0xc,%esp
  801420:	ff 75 08             	pushl  0x8(%ebp)
  801423:	e8 17 12 00 00       	call   80263f <alloc_block_BF>
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
  801589:	e8 59 08 00 00       	call   801de7 <sys_allocate_user_mem>
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
  8015d1:	e8 2d 08 00 00       	call   801e03 <get_block_size>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	ff 75 08             	pushl  0x8(%ebp)
  8015e2:	e8 60 1a 00 00       	call   803047 <free_block>
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
  801679:	e8 4d 07 00 00       	call   801dcb <sys_free_user_mem>
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
  801687:	68 4c 42 80 00       	push   $0x80424c
  80168c:	68 84 00 00 00       	push   $0x84
  801691:	68 76 42 80 00       	push   $0x804276
  801696:	e8 3d 22 00 00       	call   8038d8 <_panic>
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
  8016f9:	e8 d4 02 00 00       	call   8019d2 <sys_createSharedObject>
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
  80171a:	68 82 42 80 00       	push   $0x804282
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
  80172f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801732:	83 ec 04             	sub    $0x4,%esp
  801735:	68 88 42 80 00       	push   $0x804288
  80173a:	68 a4 00 00 00       	push   $0xa4
  80173f:	68 76 42 80 00       	push   $0x804276
  801744:	e8 8f 21 00 00       	call   8038d8 <_panic>

00801749 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80174f:	83 ec 04             	sub    $0x4,%esp
  801752:	68 ac 42 80 00       	push   $0x8042ac
  801757:	68 bc 00 00 00       	push   $0xbc
  80175c:	68 76 42 80 00       	push   $0x804276
  801761:	e8 72 21 00 00       	call   8038d8 <_panic>

00801766 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	68 d0 42 80 00       	push   $0x8042d0
  801774:	68 d3 00 00 00       	push   $0xd3
  801779:	68 76 42 80 00       	push   $0x804276
  80177e:	e8 55 21 00 00       	call   8038d8 <_panic>

00801783 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	68 f6 42 80 00       	push   $0x8042f6
  801791:	68 df 00 00 00       	push   $0xdf
  801796:	68 76 42 80 00       	push   $0x804276
  80179b:	e8 38 21 00 00       	call   8038d8 <_panic>

008017a0 <shrink>:

}
void shrink(uint32 newSize)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	68 f6 42 80 00       	push   $0x8042f6
  8017ae:	68 e4 00 00 00       	push   $0xe4
  8017b3:	68 76 42 80 00       	push   $0x804276
  8017b8:	e8 1b 21 00 00       	call   8038d8 <_panic>

008017bd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	68 f6 42 80 00       	push   $0x8042f6
  8017cb:	68 e9 00 00 00       	push   $0xe9
  8017d0:	68 76 42 80 00       	push   $0x804276
  8017d5:	e8 fe 20 00 00       	call   8038d8 <_panic>

008017da <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	57                   	push   %edi
  8017de:	56                   	push   %esi
  8017df:	53                   	push   %ebx
  8017e0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ef:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f5:	cd 30                	int    $0x30
  8017f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	5b                   	pop    %ebx
  801801:	5e                   	pop    %esi
  801802:	5f                   	pop    %edi
  801803:	5d                   	pop    %ebp
  801804:	c3                   	ret    

00801805 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	8b 45 10             	mov    0x10(%ebp),%eax
  80180e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801811:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	52                   	push   %edx
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	50                   	push   %eax
  801821:	6a 00                	push   $0x0
  801823:	e8 b2 ff ff ff       	call   8017da <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	90                   	nop
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_cgetc>:

int
sys_cgetc(void)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 02                	push   $0x2
  80183d:	e8 98 ff ff ff       	call   8017da <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 03                	push   $0x3
  801856:	e8 7f ff ff ff       	call   8017da <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	90                   	nop
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 04                	push   $0x4
  801870:	e8 65 ff ff ff       	call   8017da <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	90                   	nop
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80187e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	52                   	push   %edx
  80188b:	50                   	push   %eax
  80188c:	6a 08                	push   $0x8
  80188e:	e8 47 ff ff ff       	call   8017da <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	56                   	push   %esi
  80189c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80189d:	8b 75 18             	mov    0x18(%ebp),%esi
  8018a0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	56                   	push   %esi
  8018ad:	53                   	push   %ebx
  8018ae:	51                   	push   %ecx
  8018af:	52                   	push   %edx
  8018b0:	50                   	push   %eax
  8018b1:	6a 09                	push   $0x9
  8018b3:	e8 22 ff ff ff       	call   8017da <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018be:	5b                   	pop    %ebx
  8018bf:	5e                   	pop    %esi
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    

008018c2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	52                   	push   %edx
  8018d2:	50                   	push   %eax
  8018d3:	6a 0a                	push   $0xa
  8018d5:	e8 00 ff ff ff       	call   8017da <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	ff 75 0c             	pushl  0xc(%ebp)
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	6a 0b                	push   $0xb
  8018f0:	e8 e5 fe ff ff       	call   8017da <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 0c                	push   $0xc
  801909:	e8 cc fe ff ff       	call   8017da <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 0d                	push   $0xd
  801922:	e8 b3 fe ff ff       	call   8017da <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 0e                	push   $0xe
  80193b:	e8 9a fe ff ff       	call   8017da <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 0f                	push   $0xf
  801954:	e8 81 fe ff ff       	call   8017da <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	ff 75 08             	pushl  0x8(%ebp)
  80196c:	6a 10                	push   $0x10
  80196e:	e8 67 fe ff ff       	call   8017da <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 11                	push   $0x11
  801987:	e8 4e fe ff ff       	call   8017da <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	90                   	nop
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_cputc>:

void
sys_cputc(const char c)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80199e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	50                   	push   %eax
  8019ab:	6a 01                	push   $0x1
  8019ad:	e8 28 fe ff ff       	call   8017da <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	90                   	nop
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 14                	push   $0x14
  8019c7:	e8 0e fe ff ff       	call   8017da <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 04             	sub    $0x4,%esp
  8019d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019db:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019de:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	51                   	push   %ecx
  8019eb:	52                   	push   %edx
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	6a 15                	push   $0x15
  8019f2:	e8 e3 fd ff ff       	call   8017da <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	52                   	push   %edx
  801a0c:	50                   	push   %eax
  801a0d:	6a 16                	push   $0x16
  801a0f:	e8 c6 fd ff ff       	call   8017da <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	51                   	push   %ecx
  801a2a:	52                   	push   %edx
  801a2b:	50                   	push   %eax
  801a2c:	6a 17                	push   $0x17
  801a2e:	e8 a7 fd ff ff       	call   8017da <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	52                   	push   %edx
  801a48:	50                   	push   %eax
  801a49:	6a 18                	push   $0x18
  801a4b:	e8 8a fd ff ff       	call   8017da <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a58:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	ff 75 14             	pushl  0x14(%ebp)
  801a60:	ff 75 10             	pushl  0x10(%ebp)
  801a63:	ff 75 0c             	pushl  0xc(%ebp)
  801a66:	50                   	push   %eax
  801a67:	6a 19                	push   $0x19
  801a69:	e8 6c fd ff ff       	call   8017da <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	50                   	push   %eax
  801a82:	6a 1a                	push   $0x1a
  801a84:	e8 51 fd ff ff       	call   8017da <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	90                   	nop
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	50                   	push   %eax
  801a9e:	6a 1b                	push   $0x1b
  801aa0:	e8 35 fd ff ff       	call   8017da <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 05                	push   $0x5
  801ab9:	e8 1c fd ff ff       	call   8017da <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 06                	push   $0x6
  801ad2:	e8 03 fd ff ff       	call   8017da <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 07                	push   $0x7
  801aeb:	e8 ea fc ff ff       	call   8017da <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_exit_env>:


void sys_exit_env(void)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 1c                	push   $0x1c
  801b04:	e8 d1 fc ff ff       	call   8017da <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	90                   	nop
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b15:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b18:	8d 50 04             	lea    0x4(%eax),%edx
  801b1b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	52                   	push   %edx
  801b25:	50                   	push   %eax
  801b26:	6a 1d                	push   $0x1d
  801b28:	e8 ad fc ff ff       	call   8017da <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
	return result;
  801b30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b39:	89 01                	mov    %eax,(%ecx)
  801b3b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	c9                   	leave  
  801b42:	c2 04 00             	ret    $0x4

00801b45 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	ff 75 10             	pushl  0x10(%ebp)
  801b4f:	ff 75 0c             	pushl  0xc(%ebp)
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	6a 13                	push   $0x13
  801b57:	e8 7e fc ff ff       	call   8017da <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5f:	90                   	nop
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 1e                	push   $0x1e
  801b71:	e8 64 fc ff ff       	call   8017da <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b87:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	50                   	push   %eax
  801b94:	6a 1f                	push   $0x1f
  801b96:	e8 3f fc ff ff       	call   8017da <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9e:	90                   	nop
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <rsttst>:
void rsttst()
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 21                	push   $0x21
  801bb0:	e8 25 fc ff ff       	call   8017da <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb8:	90                   	nop
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bc7:	8b 55 18             	mov    0x18(%ebp),%edx
  801bca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	ff 75 10             	pushl  0x10(%ebp)
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	6a 20                	push   $0x20
  801bdb:	e8 fa fb ff ff       	call   8017da <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
	return ;
  801be3:	90                   	nop
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <chktst>:
void chktst(uint32 n)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	ff 75 08             	pushl  0x8(%ebp)
  801bf4:	6a 22                	push   $0x22
  801bf6:	e8 df fb ff ff       	call   8017da <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfe:	90                   	nop
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <inctst>:

void inctst()
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 23                	push   $0x23
  801c10:	e8 c5 fb ff ff       	call   8017da <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
	return ;
  801c18:	90                   	nop
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <gettst>:
uint32 gettst()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 24                	push   $0x24
  801c2a:	e8 ab fb ff ff       	call   8017da <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 25                	push   $0x25
  801c46:	e8 8f fb ff ff       	call   8017da <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
  801c4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c51:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c55:	75 07                	jne    801c5e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c57:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5c:	eb 05                	jmp    801c63 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 25                	push   $0x25
  801c77:	e8 5e fb ff ff       	call   8017da <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
  801c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c82:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c86:	75 07                	jne    801c8f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c88:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8d:	eb 05                	jmp    801c94 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 25                	push   $0x25
  801ca8:	e8 2d fb ff ff       	call   8017da <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
  801cb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cb3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cb7:	75 07                	jne    801cc0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbe:	eb 05                	jmp    801cc5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 25                	push   $0x25
  801cd9:	e8 fc fa ff ff       	call   8017da <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
  801ce1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ce4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ce8:	75 07                	jne    801cf1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cea:	b8 01 00 00 00       	mov    $0x1,%eax
  801cef:	eb 05                	jmp    801cf6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	ff 75 08             	pushl  0x8(%ebp)
  801d06:	6a 26                	push   $0x26
  801d08:	e8 cd fa ff ff       	call   8017da <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d10:	90                   	nop
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d17:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	6a 00                	push   $0x0
  801d25:	53                   	push   %ebx
  801d26:	51                   	push   %ecx
  801d27:	52                   	push   %edx
  801d28:	50                   	push   %eax
  801d29:	6a 27                	push   $0x27
  801d2b:	e8 aa fa ff ff       	call   8017da <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
}
  801d33:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	52                   	push   %edx
  801d48:	50                   	push   %eax
  801d49:	6a 28                	push   $0x28
  801d4b:	e8 8a fa ff ff       	call   8017da <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d58:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	6a 00                	push   $0x0
  801d63:	51                   	push   %ecx
  801d64:	ff 75 10             	pushl  0x10(%ebp)
  801d67:	52                   	push   %edx
  801d68:	50                   	push   %eax
  801d69:	6a 29                	push   $0x29
  801d6b:	e8 6a fa ff ff       	call   8017da <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	ff 75 10             	pushl  0x10(%ebp)
  801d7f:	ff 75 0c             	pushl  0xc(%ebp)
  801d82:	ff 75 08             	pushl  0x8(%ebp)
  801d85:	6a 12                	push   $0x12
  801d87:	e8 4e fa ff ff       	call   8017da <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8f:	90                   	nop
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	52                   	push   %edx
  801da2:	50                   	push   %eax
  801da3:	6a 2a                	push   $0x2a
  801da5:	e8 30 fa ff ff       	call   8017da <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
	return;
  801dad:	90                   	nop
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	50                   	push   %eax
  801dbf:	6a 2b                	push   $0x2b
  801dc1:	e8 14 fa ff ff       	call   8017da <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	ff 75 0c             	pushl  0xc(%ebp)
  801dd7:	ff 75 08             	pushl  0x8(%ebp)
  801dda:	6a 2c                	push   $0x2c
  801ddc:	e8 f9 f9 ff ff       	call   8017da <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
	return;
  801de4:	90                   	nop
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	ff 75 0c             	pushl  0xc(%ebp)
  801df3:	ff 75 08             	pushl  0x8(%ebp)
  801df6:	6a 2d                	push   $0x2d
  801df8:	e8 dd f9 ff ff       	call   8017da <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
	return;
  801e00:	90                   	nop
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	83 e8 04             	sub    $0x4,%eax
  801e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e15:	8b 00                	mov    (%eax),%eax
  801e17:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	83 e8 04             	sub    $0x4,%eax
  801e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e2e:	8b 00                	mov    (%eax),%eax
  801e30:	83 e0 01             	and    $0x1,%eax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	0f 94 c0             	sete   %al
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4a:	83 f8 02             	cmp    $0x2,%eax
  801e4d:	74 2b                	je     801e7a <alloc_block+0x40>
  801e4f:	83 f8 02             	cmp    $0x2,%eax
  801e52:	7f 07                	jg     801e5b <alloc_block+0x21>
  801e54:	83 f8 01             	cmp    $0x1,%eax
  801e57:	74 0e                	je     801e67 <alloc_block+0x2d>
  801e59:	eb 58                	jmp    801eb3 <alloc_block+0x79>
  801e5b:	83 f8 03             	cmp    $0x3,%eax
  801e5e:	74 2d                	je     801e8d <alloc_block+0x53>
  801e60:	83 f8 04             	cmp    $0x4,%eax
  801e63:	74 3b                	je     801ea0 <alloc_block+0x66>
  801e65:	eb 4c                	jmp    801eb3 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	ff 75 08             	pushl  0x8(%ebp)
  801e6d:	e8 11 03 00 00       	call   802183 <alloc_block_FF>
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e78:	eb 4a                	jmp    801ec4 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e7a:	83 ec 0c             	sub    $0xc,%esp
  801e7d:	ff 75 08             	pushl  0x8(%ebp)
  801e80:	e8 fa 19 00 00       	call   80387f <alloc_block_NF>
  801e85:	83 c4 10             	add    $0x10,%esp
  801e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e8b:	eb 37                	jmp    801ec4 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e8d:	83 ec 0c             	sub    $0xc,%esp
  801e90:	ff 75 08             	pushl  0x8(%ebp)
  801e93:	e8 a7 07 00 00       	call   80263f <alloc_block_BF>
  801e98:	83 c4 10             	add    $0x10,%esp
  801e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e9e:	eb 24                	jmp    801ec4 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801ea0:	83 ec 0c             	sub    $0xc,%esp
  801ea3:	ff 75 08             	pushl  0x8(%ebp)
  801ea6:	e8 b7 19 00 00       	call   803862 <alloc_block_WF>
  801eab:	83 c4 10             	add    $0x10,%esp
  801eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801eb1:	eb 11                	jmp    801ec4 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801eb3:	83 ec 0c             	sub    $0xc,%esp
  801eb6:	68 08 43 80 00       	push   $0x804308
  801ebb:	e8 08 e5 ff ff       	call   8003c8 <cprintf>
  801ec0:	83 c4 10             	add    $0x10,%esp
		break;
  801ec3:	90                   	nop
	}
	return va;
  801ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	53                   	push   %ebx
  801ecd:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	68 28 43 80 00       	push   $0x804328
  801ed8:	e8 eb e4 ff ff       	call   8003c8 <cprintf>
  801edd:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	68 53 43 80 00       	push   $0x804353
  801ee8:	e8 db e4 ff ff       	call   8003c8 <cprintf>
  801eed:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef6:	eb 37                	jmp    801f2f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801ef8:	83 ec 0c             	sub    $0xc,%esp
  801efb:	ff 75 f4             	pushl  -0xc(%ebp)
  801efe:	e8 19 ff ff ff       	call   801e1c <is_free_block>
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	0f be d8             	movsbl %al,%ebx
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0f:	e8 ef fe ff ff       	call   801e03 <get_block_size>
  801f14:	83 c4 10             	add    $0x10,%esp
  801f17:	83 ec 04             	sub    $0x4,%esp
  801f1a:	53                   	push   %ebx
  801f1b:	50                   	push   %eax
  801f1c:	68 6b 43 80 00       	push   $0x80436b
  801f21:	e8 a2 e4 ff ff       	call   8003c8 <cprintf>
  801f26:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f29:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f33:	74 07                	je     801f3c <print_blocks_list+0x73>
  801f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f38:	8b 00                	mov    (%eax),%eax
  801f3a:	eb 05                	jmp    801f41 <print_blocks_list+0x78>
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f41:	89 45 10             	mov    %eax,0x10(%ebp)
  801f44:	8b 45 10             	mov    0x10(%ebp),%eax
  801f47:	85 c0                	test   %eax,%eax
  801f49:	75 ad                	jne    801ef8 <print_blocks_list+0x2f>
  801f4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4f:	75 a7                	jne    801ef8 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	68 28 43 80 00       	push   $0x804328
  801f59:	e8 6a e4 ff ff       	call   8003c8 <cprintf>
  801f5e:	83 c4 10             	add    $0x10,%esp

}
  801f61:	90                   	nop
  801f62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f70:	83 e0 01             	and    $0x1,%eax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	74 03                	je     801f7a <initialize_dynamic_allocator+0x13>
  801f77:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f7e:	0f 84 c7 01 00 00    	je     80214b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f84:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f8b:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f94:	01 d0                	add    %edx,%eax
  801f96:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f9b:	0f 87 ad 01 00 00    	ja     80214e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	0f 89 a5 01 00 00    	jns    802151 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801fac:	8b 55 08             	mov    0x8(%ebp),%edx
  801faf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb2:	01 d0                	add    %edx,%eax
  801fb4:	83 e8 04             	sub    $0x4,%eax
  801fb7:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801fbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801fc3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fcb:	e9 87 00 00 00       	jmp    802057 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd4:	75 14                	jne    801fea <initialize_dynamic_allocator+0x83>
  801fd6:	83 ec 04             	sub    $0x4,%esp
  801fd9:	68 83 43 80 00       	push   $0x804383
  801fde:	6a 79                	push   $0x79
  801fe0:	68 a1 43 80 00       	push   $0x8043a1
  801fe5:	e8 ee 18 00 00       	call   8038d8 <_panic>
  801fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fed:	8b 00                	mov    (%eax),%eax
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	74 10                	je     802003 <initialize_dynamic_allocator+0x9c>
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	8b 00                	mov    (%eax),%eax
  801ff8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffb:	8b 52 04             	mov    0x4(%edx),%edx
  801ffe:	89 50 04             	mov    %edx,0x4(%eax)
  802001:	eb 0b                	jmp    80200e <initialize_dynamic_allocator+0xa7>
  802003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802006:	8b 40 04             	mov    0x4(%eax),%eax
  802009:	a3 30 50 80 00       	mov    %eax,0x805030
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	8b 40 04             	mov    0x4(%eax),%eax
  802014:	85 c0                	test   %eax,%eax
  802016:	74 0f                	je     802027 <initialize_dynamic_allocator+0xc0>
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	8b 40 04             	mov    0x4(%eax),%eax
  80201e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802021:	8b 12                	mov    (%edx),%edx
  802023:	89 10                	mov    %edx,(%eax)
  802025:	eb 0a                	jmp    802031 <initialize_dynamic_allocator+0xca>
  802027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202a:	8b 00                	mov    (%eax),%eax
  80202c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80203a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802044:	a1 38 50 80 00       	mov    0x805038,%eax
  802049:	48                   	dec    %eax
  80204a:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  80204f:	a1 34 50 80 00       	mov    0x805034,%eax
  802054:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802057:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205b:	74 07                	je     802064 <initialize_dynamic_allocator+0xfd>
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	8b 00                	mov    (%eax),%eax
  802062:	eb 05                	jmp    802069 <initialize_dynamic_allocator+0x102>
  802064:	b8 00 00 00 00       	mov    $0x0,%eax
  802069:	a3 34 50 80 00       	mov    %eax,0x805034
  80206e:	a1 34 50 80 00       	mov    0x805034,%eax
  802073:	85 c0                	test   %eax,%eax
  802075:	0f 85 55 ff ff ff    	jne    801fd0 <initialize_dynamic_allocator+0x69>
  80207b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207f:	0f 85 4b ff ff ff    	jne    801fd0 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80208b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802094:	a1 44 50 80 00       	mov    0x805044,%eax
  802099:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  80209e:	a1 40 50 80 00       	mov    0x805040,%eax
  8020a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	83 c0 08             	add    $0x8,%eax
  8020af:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	83 c0 04             	add    $0x4,%eax
  8020b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bb:	83 ea 08             	sub    $0x8,%edx
  8020be:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	01 d0                	add    %edx,%eax
  8020c8:	83 e8 08             	sub    $0x8,%eax
  8020cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ce:	83 ea 08             	sub    $0x8,%edx
  8020d1:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020ea:	75 17                	jne    802103 <initialize_dynamic_allocator+0x19c>
  8020ec:	83 ec 04             	sub    $0x4,%esp
  8020ef:	68 bc 43 80 00       	push   $0x8043bc
  8020f4:	68 90 00 00 00       	push   $0x90
  8020f9:	68 a1 43 80 00       	push   $0x8043a1
  8020fe:	e8 d5 17 00 00       	call   8038d8 <_panic>
  802103:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210c:	89 10                	mov    %edx,(%eax)
  80210e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802111:	8b 00                	mov    (%eax),%eax
  802113:	85 c0                	test   %eax,%eax
  802115:	74 0d                	je     802124 <initialize_dynamic_allocator+0x1bd>
  802117:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80211c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80211f:	89 50 04             	mov    %edx,0x4(%eax)
  802122:	eb 08                	jmp    80212c <initialize_dynamic_allocator+0x1c5>
  802124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802127:	a3 30 50 80 00       	mov    %eax,0x805030
  80212c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802137:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80213e:	a1 38 50 80 00       	mov    0x805038,%eax
  802143:	40                   	inc    %eax
  802144:	a3 38 50 80 00       	mov    %eax,0x805038
  802149:	eb 07                	jmp    802152 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80214b:	90                   	nop
  80214c:	eb 04                	jmp    802152 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  80214e:	90                   	nop
  80214f:	eb 01                	jmp    802152 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802151:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802157:	8b 45 10             	mov    0x10(%ebp),%eax
  80215a:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	8d 50 fc             	lea    -0x4(%eax),%edx
  802163:	8b 45 0c             	mov    0xc(%ebp),%eax
  802166:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	83 e8 04             	sub    $0x4,%eax
  80216e:	8b 00                	mov    (%eax),%eax
  802170:	83 e0 fe             	and    $0xfffffffe,%eax
  802173:	8d 50 f8             	lea    -0x8(%eax),%edx
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	01 c2                	add    %eax,%edx
  80217b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217e:	89 02                	mov    %eax,(%edx)
}
  802180:	90                   	nop
  802181:	5d                   	pop    %ebp
  802182:	c3                   	ret    

00802183 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	83 e0 01             	and    $0x1,%eax
  80218f:	85 c0                	test   %eax,%eax
  802191:	74 03                	je     802196 <alloc_block_FF+0x13>
  802193:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802196:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80219a:	77 07                	ja     8021a3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80219c:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8021a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	75 73                	jne    80221f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	83 c0 10             	add    $0x10,%eax
  8021b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8021b5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8021bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c2:	01 d0                	add    %edx,%eax
  8021c4:	48                   	dec    %eax
  8021c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d0:	f7 75 ec             	divl   -0x14(%ebp)
  8021d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021d6:	29 d0                	sub    %edx,%eax
  8021d8:	c1 e8 0c             	shr    $0xc,%eax
  8021db:	83 ec 0c             	sub    $0xc,%esp
  8021de:	50                   	push   %eax
  8021df:	e8 86 f1 ff ff       	call   80136a <sbrk>
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021ea:	83 ec 0c             	sub    $0xc,%esp
  8021ed:	6a 00                	push   $0x0
  8021ef:	e8 76 f1 ff ff       	call   80136a <sbrk>
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8021fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021fd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802200:	83 ec 08             	sub    $0x8,%esp
  802203:	50                   	push   %eax
  802204:	ff 75 e4             	pushl  -0x1c(%ebp)
  802207:	e8 5b fd ff ff       	call   801f67 <initialize_dynamic_allocator>
  80220c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80220f:	83 ec 0c             	sub    $0xc,%esp
  802212:	68 df 43 80 00       	push   $0x8043df
  802217:	e8 ac e1 ff ff       	call   8003c8 <cprintf>
  80221c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80221f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802223:	75 0a                	jne    80222f <alloc_block_FF+0xac>
	        return NULL;
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
  80222a:	e9 0e 04 00 00       	jmp    80263d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80222f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802236:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80223b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80223e:	e9 f3 02 00 00       	jmp    802536 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802249:	83 ec 0c             	sub    $0xc,%esp
  80224c:	ff 75 bc             	pushl  -0x44(%ebp)
  80224f:	e8 af fb ff ff       	call   801e03 <get_block_size>
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	83 c0 08             	add    $0x8,%eax
  802260:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802263:	0f 87 c5 02 00 00    	ja     80252e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	83 c0 18             	add    $0x18,%eax
  80226f:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802272:	0f 87 19 02 00 00    	ja     802491 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802278:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80227b:	2b 45 08             	sub    0x8(%ebp),%eax
  80227e:	83 e8 08             	sub    $0x8,%eax
  802281:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	8d 50 08             	lea    0x8(%eax),%edx
  80228a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80228d:	01 d0                	add    %edx,%eax
  80228f:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	83 c0 08             	add    $0x8,%eax
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	6a 01                	push   $0x1
  80229d:	50                   	push   %eax
  80229e:	ff 75 bc             	pushl  -0x44(%ebp)
  8022a1:	e8 ae fe ff ff       	call   802154 <set_block_data>
  8022a6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 40 04             	mov    0x4(%eax),%eax
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	75 68                	jne    80231b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022b3:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022b7:	75 17                	jne    8022d0 <alloc_block_FF+0x14d>
  8022b9:	83 ec 04             	sub    $0x4,%esp
  8022bc:	68 bc 43 80 00       	push   $0x8043bc
  8022c1:	68 d7 00 00 00       	push   $0xd7
  8022c6:	68 a1 43 80 00       	push   $0x8043a1
  8022cb:	e8 08 16 00 00       	call   8038d8 <_panic>
  8022d0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8022d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d9:	89 10                	mov    %edx,(%eax)
  8022db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	74 0d                	je     8022f1 <alloc_block_FF+0x16e>
  8022e4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8022e9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022ec:	89 50 04             	mov    %edx,0x4(%eax)
  8022ef:	eb 08                	jmp    8022f9 <alloc_block_FF+0x176>
  8022f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8022f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022fc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802301:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802304:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230b:	a1 38 50 80 00       	mov    0x805038,%eax
  802310:	40                   	inc    %eax
  802311:	a3 38 50 80 00       	mov    %eax,0x805038
  802316:	e9 dc 00 00 00       	jmp    8023f7 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 00                	mov    (%eax),%eax
  802320:	85 c0                	test   %eax,%eax
  802322:	75 65                	jne    802389 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802324:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802328:	75 17                	jne    802341 <alloc_block_FF+0x1be>
  80232a:	83 ec 04             	sub    $0x4,%esp
  80232d:	68 f0 43 80 00       	push   $0x8043f0
  802332:	68 db 00 00 00       	push   $0xdb
  802337:	68 a1 43 80 00       	push   $0x8043a1
  80233c:	e8 97 15 00 00       	call   8038d8 <_panic>
  802341:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802347:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234a:	89 50 04             	mov    %edx,0x4(%eax)
  80234d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802350:	8b 40 04             	mov    0x4(%eax),%eax
  802353:	85 c0                	test   %eax,%eax
  802355:	74 0c                	je     802363 <alloc_block_FF+0x1e0>
  802357:	a1 30 50 80 00       	mov    0x805030,%eax
  80235c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80235f:	89 10                	mov    %edx,(%eax)
  802361:	eb 08                	jmp    80236b <alloc_block_FF+0x1e8>
  802363:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802366:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80236b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80236e:	a3 30 50 80 00       	mov    %eax,0x805030
  802373:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802376:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237c:	a1 38 50 80 00       	mov    0x805038,%eax
  802381:	40                   	inc    %eax
  802382:	a3 38 50 80 00       	mov    %eax,0x805038
  802387:	eb 6e                	jmp    8023f7 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238d:	74 06                	je     802395 <alloc_block_FF+0x212>
  80238f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802393:	75 17                	jne    8023ac <alloc_block_FF+0x229>
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	68 14 44 80 00       	push   $0x804414
  80239d:	68 df 00 00 00       	push   $0xdf
  8023a2:	68 a1 43 80 00       	push   $0x8043a1
  8023a7:	e8 2c 15 00 00       	call   8038d8 <_panic>
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 10                	mov    (%eax),%edx
  8023b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b4:	89 10                	mov    %edx,(%eax)
  8023b6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b9:	8b 00                	mov    (%eax),%eax
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	74 0b                	je     8023ca <alloc_block_FF+0x247>
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023c7:	89 50 04             	mov    %edx,0x4(%eax)
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023d0:	89 10                	mov    %edx,(%eax)
  8023d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d8:	89 50 04             	mov    %edx,0x4(%eax)
  8023db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023de:	8b 00                	mov    (%eax),%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	75 08                	jne    8023ec <alloc_block_FF+0x269>
  8023e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ec:	a1 38 50 80 00       	mov    0x805038,%eax
  8023f1:	40                   	inc    %eax
  8023f2:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fb:	75 17                	jne    802414 <alloc_block_FF+0x291>
  8023fd:	83 ec 04             	sub    $0x4,%esp
  802400:	68 83 43 80 00       	push   $0x804383
  802405:	68 e1 00 00 00       	push   $0xe1
  80240a:	68 a1 43 80 00       	push   $0x8043a1
  80240f:	e8 c4 14 00 00       	call   8038d8 <_panic>
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 00                	mov    (%eax),%eax
  802419:	85 c0                	test   %eax,%eax
  80241b:	74 10                	je     80242d <alloc_block_FF+0x2aa>
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	8b 00                	mov    (%eax),%eax
  802422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802425:	8b 52 04             	mov    0x4(%edx),%edx
  802428:	89 50 04             	mov    %edx,0x4(%eax)
  80242b:	eb 0b                	jmp    802438 <alloc_block_FF+0x2b5>
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 40 04             	mov    0x4(%eax),%eax
  802433:	a3 30 50 80 00       	mov    %eax,0x805030
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 40 04             	mov    0x4(%eax),%eax
  80243e:	85 c0                	test   %eax,%eax
  802440:	74 0f                	je     802451 <alloc_block_FF+0x2ce>
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	8b 40 04             	mov    0x4(%eax),%eax
  802448:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244b:	8b 12                	mov    (%edx),%edx
  80244d:	89 10                	mov    %edx,(%eax)
  80244f:	eb 0a                	jmp    80245b <alloc_block_FF+0x2d8>
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 00                	mov    (%eax),%eax
  802456:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246e:	a1 38 50 80 00       	mov    0x805038,%eax
  802473:	48                   	dec    %eax
  802474:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802479:	83 ec 04             	sub    $0x4,%esp
  80247c:	6a 00                	push   $0x0
  80247e:	ff 75 b4             	pushl  -0x4c(%ebp)
  802481:	ff 75 b0             	pushl  -0x50(%ebp)
  802484:	e8 cb fc ff ff       	call   802154 <set_block_data>
  802489:	83 c4 10             	add    $0x10,%esp
  80248c:	e9 95 00 00 00       	jmp    802526 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802491:	83 ec 04             	sub    $0x4,%esp
  802494:	6a 01                	push   $0x1
  802496:	ff 75 b8             	pushl  -0x48(%ebp)
  802499:	ff 75 bc             	pushl  -0x44(%ebp)
  80249c:	e8 b3 fc ff ff       	call   802154 <set_block_data>
  8024a1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8024a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a8:	75 17                	jne    8024c1 <alloc_block_FF+0x33e>
  8024aa:	83 ec 04             	sub    $0x4,%esp
  8024ad:	68 83 43 80 00       	push   $0x804383
  8024b2:	68 e8 00 00 00       	push   $0xe8
  8024b7:	68 a1 43 80 00       	push   $0x8043a1
  8024bc:	e8 17 14 00 00       	call   8038d8 <_panic>
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	74 10                	je     8024da <alloc_block_FF+0x357>
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d2:	8b 52 04             	mov    0x4(%edx),%edx
  8024d5:	89 50 04             	mov    %edx,0x4(%eax)
  8024d8:	eb 0b                	jmp    8024e5 <alloc_block_FF+0x362>
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 40 04             	mov    0x4(%eax),%eax
  8024e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	74 0f                	je     8024fe <alloc_block_FF+0x37b>
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	8b 40 04             	mov    0x4(%eax),%eax
  8024f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f8:	8b 12                	mov    (%edx),%edx
  8024fa:	89 10                	mov    %edx,(%eax)
  8024fc:	eb 0a                	jmp    802508 <alloc_block_FF+0x385>
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 00                	mov    (%eax),%eax
  802503:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251b:	a1 38 50 80 00       	mov    0x805038,%eax
  802520:	48                   	dec    %eax
  802521:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802526:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802529:	e9 0f 01 00 00       	jmp    80263d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80252e:	a1 34 50 80 00       	mov    0x805034,%eax
  802533:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253a:	74 07                	je     802543 <alloc_block_FF+0x3c0>
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 00                	mov    (%eax),%eax
  802541:	eb 05                	jmp    802548 <alloc_block_FF+0x3c5>
  802543:	b8 00 00 00 00       	mov    $0x0,%eax
  802548:	a3 34 50 80 00       	mov    %eax,0x805034
  80254d:	a1 34 50 80 00       	mov    0x805034,%eax
  802552:	85 c0                	test   %eax,%eax
  802554:	0f 85 e9 fc ff ff    	jne    802243 <alloc_block_FF+0xc0>
  80255a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255e:	0f 85 df fc ff ff    	jne    802243 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	83 c0 08             	add    $0x8,%eax
  80256a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80256d:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802574:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802577:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80257a:	01 d0                	add    %edx,%eax
  80257c:	48                   	dec    %eax
  80257d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802583:	ba 00 00 00 00       	mov    $0x0,%edx
  802588:	f7 75 d8             	divl   -0x28(%ebp)
  80258b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80258e:	29 d0                	sub    %edx,%eax
  802590:	c1 e8 0c             	shr    $0xc,%eax
  802593:	83 ec 0c             	sub    $0xc,%esp
  802596:	50                   	push   %eax
  802597:	e8 ce ed ff ff       	call   80136a <sbrk>
  80259c:	83 c4 10             	add    $0x10,%esp
  80259f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8025a2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8025a6:	75 0a                	jne    8025b2 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ad:	e9 8b 00 00 00       	jmp    80263d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8025b2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025bf:	01 d0                	add    %edx,%eax
  8025c1:	48                   	dec    %eax
  8025c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8025cd:	f7 75 cc             	divl   -0x34(%ebp)
  8025d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025d3:	29 d0                	sub    %edx,%eax
  8025d5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025db:	01 d0                	add    %edx,%eax
  8025dd:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8025e2:	a1 40 50 80 00       	mov    0x805040,%eax
  8025e7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025ed:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025fa:	01 d0                	add    %edx,%eax
  8025fc:	48                   	dec    %eax
  8025fd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802600:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802603:	ba 00 00 00 00       	mov    $0x0,%edx
  802608:	f7 75 c4             	divl   -0x3c(%ebp)
  80260b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80260e:	29 d0                	sub    %edx,%eax
  802610:	83 ec 04             	sub    $0x4,%esp
  802613:	6a 01                	push   $0x1
  802615:	50                   	push   %eax
  802616:	ff 75 d0             	pushl  -0x30(%ebp)
  802619:	e8 36 fb ff ff       	call   802154 <set_block_data>
  80261e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802621:	83 ec 0c             	sub    $0xc,%esp
  802624:	ff 75 d0             	pushl  -0x30(%ebp)
  802627:	e8 1b 0a 00 00       	call   803047 <free_block>
  80262c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80262f:	83 ec 0c             	sub    $0xc,%esp
  802632:	ff 75 08             	pushl  0x8(%ebp)
  802635:	e8 49 fb ff ff       	call   802183 <alloc_block_FF>
  80263a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80263d:	c9                   	leave  
  80263e:	c3                   	ret    

0080263f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	83 e0 01             	and    $0x1,%eax
  80264b:	85 c0                	test   %eax,%eax
  80264d:	74 03                	je     802652 <alloc_block_BF+0x13>
  80264f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802652:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802656:	77 07                	ja     80265f <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802658:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80265f:	a1 24 50 80 00       	mov    0x805024,%eax
  802664:	85 c0                	test   %eax,%eax
  802666:	75 73                	jne    8026db <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802668:	8b 45 08             	mov    0x8(%ebp),%eax
  80266b:	83 c0 10             	add    $0x10,%eax
  80266e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802671:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802678:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80267b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267e:	01 d0                	add    %edx,%eax
  802680:	48                   	dec    %eax
  802681:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802684:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802687:	ba 00 00 00 00       	mov    $0x0,%edx
  80268c:	f7 75 e0             	divl   -0x20(%ebp)
  80268f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802692:	29 d0                	sub    %edx,%eax
  802694:	c1 e8 0c             	shr    $0xc,%eax
  802697:	83 ec 0c             	sub    $0xc,%esp
  80269a:	50                   	push   %eax
  80269b:	e8 ca ec ff ff       	call   80136a <sbrk>
  8026a0:	83 c4 10             	add    $0x10,%esp
  8026a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026a6:	83 ec 0c             	sub    $0xc,%esp
  8026a9:	6a 00                	push   $0x0
  8026ab:	e8 ba ec ff ff       	call   80136a <sbrk>
  8026b0:	83 c4 10             	add    $0x10,%esp
  8026b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8026b9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8026bc:	83 ec 08             	sub    $0x8,%esp
  8026bf:	50                   	push   %eax
  8026c0:	ff 75 d8             	pushl  -0x28(%ebp)
  8026c3:	e8 9f f8 ff ff       	call   801f67 <initialize_dynamic_allocator>
  8026c8:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026cb:	83 ec 0c             	sub    $0xc,%esp
  8026ce:	68 df 43 80 00       	push   $0x8043df
  8026d3:	e8 f0 dc ff ff       	call   8003c8 <cprintf>
  8026d8:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026e9:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8026f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026f7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ff:	e9 1d 01 00 00       	jmp    802821 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80270a:	83 ec 0c             	sub    $0xc,%esp
  80270d:	ff 75 a8             	pushl  -0x58(%ebp)
  802710:	e8 ee f6 ff ff       	call   801e03 <get_block_size>
  802715:	83 c4 10             	add    $0x10,%esp
  802718:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	83 c0 08             	add    $0x8,%eax
  802721:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802724:	0f 87 ef 00 00 00    	ja     802819 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80272a:	8b 45 08             	mov    0x8(%ebp),%eax
  80272d:	83 c0 18             	add    $0x18,%eax
  802730:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802733:	77 1d                	ja     802752 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802738:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80273b:	0f 86 d8 00 00 00    	jbe    802819 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802741:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802744:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802747:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80274a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80274d:	e9 c7 00 00 00       	jmp    802819 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	83 c0 08             	add    $0x8,%eax
  802758:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80275b:	0f 85 9d 00 00 00    	jne    8027fe <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802761:	83 ec 04             	sub    $0x4,%esp
  802764:	6a 01                	push   $0x1
  802766:	ff 75 a4             	pushl  -0x5c(%ebp)
  802769:	ff 75 a8             	pushl  -0x58(%ebp)
  80276c:	e8 e3 f9 ff ff       	call   802154 <set_block_data>
  802771:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802774:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802778:	75 17                	jne    802791 <alloc_block_BF+0x152>
  80277a:	83 ec 04             	sub    $0x4,%esp
  80277d:	68 83 43 80 00       	push   $0x804383
  802782:	68 2c 01 00 00       	push   $0x12c
  802787:	68 a1 43 80 00       	push   $0x8043a1
  80278c:	e8 47 11 00 00       	call   8038d8 <_panic>
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 00                	mov    (%eax),%eax
  802796:	85 c0                	test   %eax,%eax
  802798:	74 10                	je     8027aa <alloc_block_BF+0x16b>
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a2:	8b 52 04             	mov    0x4(%edx),%edx
  8027a5:	89 50 04             	mov    %edx,0x4(%eax)
  8027a8:	eb 0b                	jmp    8027b5 <alloc_block_BF+0x176>
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 40 04             	mov    0x4(%eax),%eax
  8027b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 04             	mov    0x4(%eax),%eax
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	74 0f                	je     8027ce <alloc_block_BF+0x18f>
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 40 04             	mov    0x4(%eax),%eax
  8027c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c8:	8b 12                	mov    (%edx),%edx
  8027ca:	89 10                	mov    %edx,(%eax)
  8027cc:	eb 0a                	jmp    8027d8 <alloc_block_BF+0x199>
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 00                	mov    (%eax),%eax
  8027d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f0:	48                   	dec    %eax
  8027f1:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8027f6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027f9:	e9 24 04 00 00       	jmp    802c22 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8027fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802801:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802804:	76 13                	jbe    802819 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802806:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80280d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802810:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802813:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802816:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802819:	a1 34 50 80 00       	mov    0x805034,%eax
  80281e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802825:	74 07                	je     80282e <alloc_block_BF+0x1ef>
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	eb 05                	jmp    802833 <alloc_block_BF+0x1f4>
  80282e:	b8 00 00 00 00       	mov    $0x0,%eax
  802833:	a3 34 50 80 00       	mov    %eax,0x805034
  802838:	a1 34 50 80 00       	mov    0x805034,%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	0f 85 bf fe ff ff    	jne    802704 <alloc_block_BF+0xc5>
  802845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802849:	0f 85 b5 fe ff ff    	jne    802704 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80284f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802853:	0f 84 26 02 00 00    	je     802a7f <alloc_block_BF+0x440>
  802859:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80285d:	0f 85 1c 02 00 00    	jne    802a7f <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802866:	2b 45 08             	sub    0x8(%ebp),%eax
  802869:	83 e8 08             	sub    $0x8,%eax
  80286c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	8d 50 08             	lea    0x8(%eax),%edx
  802875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802878:	01 d0                	add    %edx,%eax
  80287a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	83 c0 08             	add    $0x8,%eax
  802883:	83 ec 04             	sub    $0x4,%esp
  802886:	6a 01                	push   $0x1
  802888:	50                   	push   %eax
  802889:	ff 75 f0             	pushl  -0x10(%ebp)
  80288c:	e8 c3 f8 ff ff       	call   802154 <set_block_data>
  802891:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802894:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802897:	8b 40 04             	mov    0x4(%eax),%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	75 68                	jne    802906 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80289e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028a2:	75 17                	jne    8028bb <alloc_block_BF+0x27c>
  8028a4:	83 ec 04             	sub    $0x4,%esp
  8028a7:	68 bc 43 80 00       	push   $0x8043bc
  8028ac:	68 45 01 00 00       	push   $0x145
  8028b1:	68 a1 43 80 00       	push   $0x8043a1
  8028b6:	e8 1d 10 00 00       	call   8038d8 <_panic>
  8028bb:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8028c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c4:	89 10                	mov    %edx,(%eax)
  8028c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c9:	8b 00                	mov    (%eax),%eax
  8028cb:	85 c0                	test   %eax,%eax
  8028cd:	74 0d                	je     8028dc <alloc_block_BF+0x29d>
  8028cf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8028d4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028d7:	89 50 04             	mov    %edx,0x4(%eax)
  8028da:	eb 08                	jmp    8028e4 <alloc_block_BF+0x2a5>
  8028dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028df:	a3 30 50 80 00       	mov    %eax,0x805030
  8028e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8028fb:	40                   	inc    %eax
  8028fc:	a3 38 50 80 00       	mov    %eax,0x805038
  802901:	e9 dc 00 00 00       	jmp    8029e2 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	8b 00                	mov    (%eax),%eax
  80290b:	85 c0                	test   %eax,%eax
  80290d:	75 65                	jne    802974 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80290f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802913:	75 17                	jne    80292c <alloc_block_BF+0x2ed>
  802915:	83 ec 04             	sub    $0x4,%esp
  802918:	68 f0 43 80 00       	push   $0x8043f0
  80291d:	68 4a 01 00 00       	push   $0x14a
  802922:	68 a1 43 80 00       	push   $0x8043a1
  802927:	e8 ac 0f 00 00       	call   8038d8 <_panic>
  80292c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802932:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802935:	89 50 04             	mov    %edx,0x4(%eax)
  802938:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80293b:	8b 40 04             	mov    0x4(%eax),%eax
  80293e:	85 c0                	test   %eax,%eax
  802940:	74 0c                	je     80294e <alloc_block_BF+0x30f>
  802942:	a1 30 50 80 00       	mov    0x805030,%eax
  802947:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80294a:	89 10                	mov    %edx,(%eax)
  80294c:	eb 08                	jmp    802956 <alloc_block_BF+0x317>
  80294e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802951:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802956:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802959:	a3 30 50 80 00       	mov    %eax,0x805030
  80295e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802961:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802967:	a1 38 50 80 00       	mov    0x805038,%eax
  80296c:	40                   	inc    %eax
  80296d:	a3 38 50 80 00       	mov    %eax,0x805038
  802972:	eb 6e                	jmp    8029e2 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802974:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802978:	74 06                	je     802980 <alloc_block_BF+0x341>
  80297a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80297e:	75 17                	jne    802997 <alloc_block_BF+0x358>
  802980:	83 ec 04             	sub    $0x4,%esp
  802983:	68 14 44 80 00       	push   $0x804414
  802988:	68 4f 01 00 00       	push   $0x14f
  80298d:	68 a1 43 80 00       	push   $0x8043a1
  802992:	e8 41 0f 00 00       	call   8038d8 <_panic>
  802997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299a:	8b 10                	mov    (%eax),%edx
  80299c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80299f:	89 10                	mov    %edx,(%eax)
  8029a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a4:	8b 00                	mov    (%eax),%eax
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	74 0b                	je     8029b5 <alloc_block_BF+0x376>
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029b2:	89 50 04             	mov    %edx,0x4(%eax)
  8029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8029bb:	89 10                	mov    %edx,(%eax)
  8029bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c3:	89 50 04             	mov    %edx,0x4(%eax)
  8029c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	75 08                	jne    8029d7 <alloc_block_BF+0x398>
  8029cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029d2:	a3 30 50 80 00       	mov    %eax,0x805030
  8029d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8029dc:	40                   	inc    %eax
  8029dd:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e6:	75 17                	jne    8029ff <alloc_block_BF+0x3c0>
  8029e8:	83 ec 04             	sub    $0x4,%esp
  8029eb:	68 83 43 80 00       	push   $0x804383
  8029f0:	68 51 01 00 00       	push   $0x151
  8029f5:	68 a1 43 80 00       	push   $0x8043a1
  8029fa:	e8 d9 0e 00 00       	call   8038d8 <_panic>
  8029ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	74 10                	je     802a18 <alloc_block_BF+0x3d9>
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	8b 00                	mov    (%eax),%eax
  802a0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a10:	8b 52 04             	mov    0x4(%edx),%edx
  802a13:	89 50 04             	mov    %edx,0x4(%eax)
  802a16:	eb 0b                	jmp    802a23 <alloc_block_BF+0x3e4>
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	8b 40 04             	mov    0x4(%eax),%eax
  802a1e:	a3 30 50 80 00       	mov    %eax,0x805030
  802a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a26:	8b 40 04             	mov    0x4(%eax),%eax
  802a29:	85 c0                	test   %eax,%eax
  802a2b:	74 0f                	je     802a3c <alloc_block_BF+0x3fd>
  802a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a30:	8b 40 04             	mov    0x4(%eax),%eax
  802a33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a36:	8b 12                	mov    (%edx),%edx
  802a38:	89 10                	mov    %edx,(%eax)
  802a3a:	eb 0a                	jmp    802a46 <alloc_block_BF+0x407>
  802a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a59:	a1 38 50 80 00       	mov    0x805038,%eax
  802a5e:	48                   	dec    %eax
  802a5f:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802a64:	83 ec 04             	sub    $0x4,%esp
  802a67:	6a 00                	push   $0x0
  802a69:	ff 75 d0             	pushl  -0x30(%ebp)
  802a6c:	ff 75 cc             	pushl  -0x34(%ebp)
  802a6f:	e8 e0 f6 ff ff       	call   802154 <set_block_data>
  802a74:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7a:	e9 a3 01 00 00       	jmp    802c22 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a7f:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a83:	0f 85 9d 00 00 00    	jne    802b26 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a89:	83 ec 04             	sub    $0x4,%esp
  802a8c:	6a 01                	push   $0x1
  802a8e:	ff 75 ec             	pushl  -0x14(%ebp)
  802a91:	ff 75 f0             	pushl  -0x10(%ebp)
  802a94:	e8 bb f6 ff ff       	call   802154 <set_block_data>
  802a99:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aa0:	75 17                	jne    802ab9 <alloc_block_BF+0x47a>
  802aa2:	83 ec 04             	sub    $0x4,%esp
  802aa5:	68 83 43 80 00       	push   $0x804383
  802aaa:	68 58 01 00 00       	push   $0x158
  802aaf:	68 a1 43 80 00       	push   $0x8043a1
  802ab4:	e8 1f 0e 00 00       	call   8038d8 <_panic>
  802ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 10                	je     802ad2 <alloc_block_BF+0x493>
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	8b 00                	mov    (%eax),%eax
  802ac7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aca:	8b 52 04             	mov    0x4(%edx),%edx
  802acd:	89 50 04             	mov    %edx,0x4(%eax)
  802ad0:	eb 0b                	jmp    802add <alloc_block_BF+0x49e>
  802ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad5:	8b 40 04             	mov    0x4(%eax),%eax
  802ad8:	a3 30 50 80 00       	mov    %eax,0x805030
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	8b 40 04             	mov    0x4(%eax),%eax
  802ae3:	85 c0                	test   %eax,%eax
  802ae5:	74 0f                	je     802af6 <alloc_block_BF+0x4b7>
  802ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af0:	8b 12                	mov    (%edx),%edx
  802af2:	89 10                	mov    %edx,(%eax)
  802af4:	eb 0a                	jmp    802b00 <alloc_block_BF+0x4c1>
  802af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b13:	a1 38 50 80 00       	mov    0x805038,%eax
  802b18:	48                   	dec    %eax
  802b19:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b21:	e9 fc 00 00 00       	jmp    802c22 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	83 c0 08             	add    $0x8,%eax
  802b2c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b2f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b36:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b3c:	01 d0                	add    %edx,%eax
  802b3e:	48                   	dec    %eax
  802b3f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b42:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b45:	ba 00 00 00 00       	mov    $0x0,%edx
  802b4a:	f7 75 c4             	divl   -0x3c(%ebp)
  802b4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b50:	29 d0                	sub    %edx,%eax
  802b52:	c1 e8 0c             	shr    $0xc,%eax
  802b55:	83 ec 0c             	sub    $0xc,%esp
  802b58:	50                   	push   %eax
  802b59:	e8 0c e8 ff ff       	call   80136a <sbrk>
  802b5e:	83 c4 10             	add    $0x10,%esp
  802b61:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b64:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b68:	75 0a                	jne    802b74 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b6f:	e9 ae 00 00 00       	jmp    802c22 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b74:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b7b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b7e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b81:	01 d0                	add    %edx,%eax
  802b83:	48                   	dec    %eax
  802b84:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b87:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  802b8f:	f7 75 b8             	divl   -0x48(%ebp)
  802b92:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b95:	29 d0                	sub    %edx,%eax
  802b97:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b9a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b9d:	01 d0                	add    %edx,%eax
  802b9f:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802ba4:	a1 40 50 80 00       	mov    0x805040,%eax
  802ba9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802baf:	83 ec 0c             	sub    $0xc,%esp
  802bb2:	68 48 44 80 00       	push   $0x804448
  802bb7:	e8 0c d8 ff ff       	call   8003c8 <cprintf>
  802bbc:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802bbf:	83 ec 08             	sub    $0x8,%esp
  802bc2:	ff 75 bc             	pushl  -0x44(%ebp)
  802bc5:	68 4d 44 80 00       	push   $0x80444d
  802bca:	e8 f9 d7 ff ff       	call   8003c8 <cprintf>
  802bcf:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bd2:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802bd9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bdc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bdf:	01 d0                	add    %edx,%eax
  802be1:	48                   	dec    %eax
  802be2:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802be5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802be8:	ba 00 00 00 00       	mov    $0x0,%edx
  802bed:	f7 75 b0             	divl   -0x50(%ebp)
  802bf0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bf3:	29 d0                	sub    %edx,%eax
  802bf5:	83 ec 04             	sub    $0x4,%esp
  802bf8:	6a 01                	push   $0x1
  802bfa:	50                   	push   %eax
  802bfb:	ff 75 bc             	pushl  -0x44(%ebp)
  802bfe:	e8 51 f5 ff ff       	call   802154 <set_block_data>
  802c03:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802c06:	83 ec 0c             	sub    $0xc,%esp
  802c09:	ff 75 bc             	pushl  -0x44(%ebp)
  802c0c:	e8 36 04 00 00       	call   803047 <free_block>
  802c11:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802c14:	83 ec 0c             	sub    $0xc,%esp
  802c17:	ff 75 08             	pushl  0x8(%ebp)
  802c1a:	e8 20 fa ff ff       	call   80263f <alloc_block_BF>
  802c1f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c22:	c9                   	leave  
  802c23:	c3                   	ret    

00802c24 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c24:	55                   	push   %ebp
  802c25:	89 e5                	mov    %esp,%ebp
  802c27:	53                   	push   %ebx
  802c28:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c32:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3d:	74 1e                	je     802c5d <merging+0x39>
  802c3f:	ff 75 08             	pushl  0x8(%ebp)
  802c42:	e8 bc f1 ff ff       	call   801e03 <get_block_size>
  802c47:	83 c4 04             	add    $0x4,%esp
  802c4a:	89 c2                	mov    %eax,%edx
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	01 d0                	add    %edx,%eax
  802c51:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c54:	75 07                	jne    802c5d <merging+0x39>
		prev_is_free = 1;
  802c56:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c61:	74 1e                	je     802c81 <merging+0x5d>
  802c63:	ff 75 10             	pushl  0x10(%ebp)
  802c66:	e8 98 f1 ff ff       	call   801e03 <get_block_size>
  802c6b:	83 c4 04             	add    $0x4,%esp
  802c6e:	89 c2                	mov    %eax,%edx
  802c70:	8b 45 10             	mov    0x10(%ebp),%eax
  802c73:	01 d0                	add    %edx,%eax
  802c75:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c78:	75 07                	jne    802c81 <merging+0x5d>
		next_is_free = 1;
  802c7a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c85:	0f 84 cc 00 00 00    	je     802d57 <merging+0x133>
  802c8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c8f:	0f 84 c2 00 00 00    	je     802d57 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c95:	ff 75 08             	pushl  0x8(%ebp)
  802c98:	e8 66 f1 ff ff       	call   801e03 <get_block_size>
  802c9d:	83 c4 04             	add    $0x4,%esp
  802ca0:	89 c3                	mov    %eax,%ebx
  802ca2:	ff 75 10             	pushl  0x10(%ebp)
  802ca5:	e8 59 f1 ff ff       	call   801e03 <get_block_size>
  802caa:	83 c4 04             	add    $0x4,%esp
  802cad:	01 c3                	add    %eax,%ebx
  802caf:	ff 75 0c             	pushl  0xc(%ebp)
  802cb2:	e8 4c f1 ff ff       	call   801e03 <get_block_size>
  802cb7:	83 c4 04             	add    $0x4,%esp
  802cba:	01 d8                	add    %ebx,%eax
  802cbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cbf:	6a 00                	push   $0x0
  802cc1:	ff 75 ec             	pushl  -0x14(%ebp)
  802cc4:	ff 75 08             	pushl  0x8(%ebp)
  802cc7:	e8 88 f4 ff ff       	call   802154 <set_block_data>
  802ccc:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ccf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cd3:	75 17                	jne    802cec <merging+0xc8>
  802cd5:	83 ec 04             	sub    $0x4,%esp
  802cd8:	68 83 43 80 00       	push   $0x804383
  802cdd:	68 7d 01 00 00       	push   $0x17d
  802ce2:	68 a1 43 80 00       	push   $0x8043a1
  802ce7:	e8 ec 0b 00 00       	call   8038d8 <_panic>
  802cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	74 10                	je     802d05 <merging+0xe1>
  802cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cfd:	8b 52 04             	mov    0x4(%edx),%edx
  802d00:	89 50 04             	mov    %edx,0x4(%eax)
  802d03:	eb 0b                	jmp    802d10 <merging+0xec>
  802d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	a3 30 50 80 00       	mov    %eax,0x805030
  802d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	85 c0                	test   %eax,%eax
  802d18:	74 0f                	je     802d29 <merging+0x105>
  802d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1d:	8b 40 04             	mov    0x4(%eax),%eax
  802d20:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d23:	8b 12                	mov    (%edx),%edx
  802d25:	89 10                	mov    %edx,(%eax)
  802d27:	eb 0a                	jmp    802d33 <merging+0x10f>
  802d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d46:	a1 38 50 80 00       	mov    0x805038,%eax
  802d4b:	48                   	dec    %eax
  802d4c:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d51:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d52:	e9 ea 02 00 00       	jmp    803041 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5b:	74 3b                	je     802d98 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d5d:	83 ec 0c             	sub    $0xc,%esp
  802d60:	ff 75 08             	pushl  0x8(%ebp)
  802d63:	e8 9b f0 ff ff       	call   801e03 <get_block_size>
  802d68:	83 c4 10             	add    $0x10,%esp
  802d6b:	89 c3                	mov    %eax,%ebx
  802d6d:	83 ec 0c             	sub    $0xc,%esp
  802d70:	ff 75 10             	pushl  0x10(%ebp)
  802d73:	e8 8b f0 ff ff       	call   801e03 <get_block_size>
  802d78:	83 c4 10             	add    $0x10,%esp
  802d7b:	01 d8                	add    %ebx,%eax
  802d7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d80:	83 ec 04             	sub    $0x4,%esp
  802d83:	6a 00                	push   $0x0
  802d85:	ff 75 e8             	pushl  -0x18(%ebp)
  802d88:	ff 75 08             	pushl  0x8(%ebp)
  802d8b:	e8 c4 f3 ff ff       	call   802154 <set_block_data>
  802d90:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d93:	e9 a9 02 00 00       	jmp    803041 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9c:	0f 84 2d 01 00 00    	je     802ecf <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802da2:	83 ec 0c             	sub    $0xc,%esp
  802da5:	ff 75 10             	pushl  0x10(%ebp)
  802da8:	e8 56 f0 ff ff       	call   801e03 <get_block_size>
  802dad:	83 c4 10             	add    $0x10,%esp
  802db0:	89 c3                	mov    %eax,%ebx
  802db2:	83 ec 0c             	sub    $0xc,%esp
  802db5:	ff 75 0c             	pushl  0xc(%ebp)
  802db8:	e8 46 f0 ff ff       	call   801e03 <get_block_size>
  802dbd:	83 c4 10             	add    $0x10,%esp
  802dc0:	01 d8                	add    %ebx,%eax
  802dc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802dc5:	83 ec 04             	sub    $0x4,%esp
  802dc8:	6a 00                	push   $0x0
  802dca:	ff 75 e4             	pushl  -0x1c(%ebp)
  802dcd:	ff 75 10             	pushl  0x10(%ebp)
  802dd0:	e8 7f f3 ff ff       	call   802154 <set_block_data>
  802dd5:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802dd8:	8b 45 10             	mov    0x10(%ebp),%eax
  802ddb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802dde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802de2:	74 06                	je     802dea <merging+0x1c6>
  802de4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802de8:	75 17                	jne    802e01 <merging+0x1dd>
  802dea:	83 ec 04             	sub    $0x4,%esp
  802ded:	68 5c 44 80 00       	push   $0x80445c
  802df2:	68 8d 01 00 00       	push   $0x18d
  802df7:	68 a1 43 80 00       	push   $0x8043a1
  802dfc:	e8 d7 0a 00 00       	call   8038d8 <_panic>
  802e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e04:	8b 50 04             	mov    0x4(%eax),%edx
  802e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0a:	89 50 04             	mov    %edx,0x4(%eax)
  802e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e13:	89 10                	mov    %edx,(%eax)
  802e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e18:	8b 40 04             	mov    0x4(%eax),%eax
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	74 0d                	je     802e2c <merging+0x208>
  802e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e22:	8b 40 04             	mov    0x4(%eax),%eax
  802e25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e28:	89 10                	mov    %edx,(%eax)
  802e2a:	eb 08                	jmp    802e34 <merging+0x210>
  802e2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e34:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e37:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e3a:	89 50 04             	mov    %edx,0x4(%eax)
  802e3d:	a1 38 50 80 00       	mov    0x805038,%eax
  802e42:	40                   	inc    %eax
  802e43:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802e48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e4c:	75 17                	jne    802e65 <merging+0x241>
  802e4e:	83 ec 04             	sub    $0x4,%esp
  802e51:	68 83 43 80 00       	push   $0x804383
  802e56:	68 8e 01 00 00       	push   $0x18e
  802e5b:	68 a1 43 80 00       	push   $0x8043a1
  802e60:	e8 73 0a 00 00       	call   8038d8 <_panic>
  802e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	85 c0                	test   %eax,%eax
  802e6c:	74 10                	je     802e7e <merging+0x25a>
  802e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e71:	8b 00                	mov    (%eax),%eax
  802e73:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e76:	8b 52 04             	mov    0x4(%edx),%edx
  802e79:	89 50 04             	mov    %edx,0x4(%eax)
  802e7c:	eb 0b                	jmp    802e89 <merging+0x265>
  802e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e81:	8b 40 04             	mov    0x4(%eax),%eax
  802e84:	a3 30 50 80 00       	mov    %eax,0x805030
  802e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8c:	8b 40 04             	mov    0x4(%eax),%eax
  802e8f:	85 c0                	test   %eax,%eax
  802e91:	74 0f                	je     802ea2 <merging+0x27e>
  802e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e96:	8b 40 04             	mov    0x4(%eax),%eax
  802e99:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e9c:	8b 12                	mov    (%edx),%edx
  802e9e:	89 10                	mov    %edx,(%eax)
  802ea0:	eb 0a                	jmp    802eac <merging+0x288>
  802ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebf:	a1 38 50 80 00       	mov    0x805038,%eax
  802ec4:	48                   	dec    %eax
  802ec5:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802eca:	e9 72 01 00 00       	jmp    803041 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ecf:	8b 45 10             	mov    0x10(%ebp),%eax
  802ed2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ed5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed9:	74 79                	je     802f54 <merging+0x330>
  802edb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802edf:	74 73                	je     802f54 <merging+0x330>
  802ee1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee5:	74 06                	je     802eed <merging+0x2c9>
  802ee7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802eeb:	75 17                	jne    802f04 <merging+0x2e0>
  802eed:	83 ec 04             	sub    $0x4,%esp
  802ef0:	68 14 44 80 00       	push   $0x804414
  802ef5:	68 94 01 00 00       	push   $0x194
  802efa:	68 a1 43 80 00       	push   $0x8043a1
  802eff:	e8 d4 09 00 00       	call   8038d8 <_panic>
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	8b 10                	mov    (%eax),%edx
  802f09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0c:	89 10                	mov    %edx,(%eax)
  802f0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	74 0b                	je     802f22 <merging+0x2fe>
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f1f:	89 50 04             	mov    %edx,0x4(%eax)
  802f22:	8b 45 08             	mov    0x8(%ebp),%eax
  802f25:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f28:	89 10                	mov    %edx,(%eax)
  802f2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f30:	89 50 04             	mov    %edx,0x4(%eax)
  802f33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	75 08                	jne    802f44 <merging+0x320>
  802f3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3f:	a3 30 50 80 00       	mov    %eax,0x805030
  802f44:	a1 38 50 80 00       	mov    0x805038,%eax
  802f49:	40                   	inc    %eax
  802f4a:	a3 38 50 80 00       	mov    %eax,0x805038
  802f4f:	e9 ce 00 00 00       	jmp    803022 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f58:	74 65                	je     802fbf <merging+0x39b>
  802f5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f5e:	75 17                	jne    802f77 <merging+0x353>
  802f60:	83 ec 04             	sub    $0x4,%esp
  802f63:	68 f0 43 80 00       	push   $0x8043f0
  802f68:	68 95 01 00 00       	push   $0x195
  802f6d:	68 a1 43 80 00       	push   $0x8043a1
  802f72:	e8 61 09 00 00       	call   8038d8 <_panic>
  802f77:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f80:	89 50 04             	mov    %edx,0x4(%eax)
  802f83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f86:	8b 40 04             	mov    0x4(%eax),%eax
  802f89:	85 c0                	test   %eax,%eax
  802f8b:	74 0c                	je     802f99 <merging+0x375>
  802f8d:	a1 30 50 80 00       	mov    0x805030,%eax
  802f92:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f95:	89 10                	mov    %edx,(%eax)
  802f97:	eb 08                	jmp    802fa1 <merging+0x37d>
  802f99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f9c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802fa1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fa4:	a3 30 50 80 00       	mov    %eax,0x805030
  802fa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb2:	a1 38 50 80 00       	mov    0x805038,%eax
  802fb7:	40                   	inc    %eax
  802fb8:	a3 38 50 80 00       	mov    %eax,0x805038
  802fbd:	eb 63                	jmp    803022 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fbf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fc3:	75 17                	jne    802fdc <merging+0x3b8>
  802fc5:	83 ec 04             	sub    $0x4,%esp
  802fc8:	68 bc 43 80 00       	push   $0x8043bc
  802fcd:	68 98 01 00 00       	push   $0x198
  802fd2:	68 a1 43 80 00       	push   $0x8043a1
  802fd7:	e8 fc 08 00 00       	call   8038d8 <_panic>
  802fdc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802fe2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe5:	89 10                	mov    %edx,(%eax)
  802fe7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fea:	8b 00                	mov    (%eax),%eax
  802fec:	85 c0                	test   %eax,%eax
  802fee:	74 0d                	je     802ffd <merging+0x3d9>
  802ff0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ff5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ff8:	89 50 04             	mov    %edx,0x4(%eax)
  802ffb:	eb 08                	jmp    803005 <merging+0x3e1>
  802ffd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803000:	a3 30 50 80 00       	mov    %eax,0x805030
  803005:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803008:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80300d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803010:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803017:	a1 38 50 80 00       	mov    0x805038,%eax
  80301c:	40                   	inc    %eax
  80301d:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  803022:	83 ec 0c             	sub    $0xc,%esp
  803025:	ff 75 10             	pushl  0x10(%ebp)
  803028:	e8 d6 ed ff ff       	call   801e03 <get_block_size>
  80302d:	83 c4 10             	add    $0x10,%esp
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	6a 00                	push   $0x0
  803035:	50                   	push   %eax
  803036:	ff 75 10             	pushl  0x10(%ebp)
  803039:	e8 16 f1 ff ff       	call   802154 <set_block_data>
  80303e:	83 c4 10             	add    $0x10,%esp
	}
}
  803041:	90                   	nop
  803042:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803045:	c9                   	leave  
  803046:	c3                   	ret    

00803047 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803047:	55                   	push   %ebp
  803048:	89 e5                	mov    %esp,%ebp
  80304a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  80304d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803052:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803055:	a1 30 50 80 00       	mov    0x805030,%eax
  80305a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80305d:	73 1b                	jae    80307a <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  80305f:	a1 30 50 80 00       	mov    0x805030,%eax
  803064:	83 ec 04             	sub    $0x4,%esp
  803067:	ff 75 08             	pushl  0x8(%ebp)
  80306a:	6a 00                	push   $0x0
  80306c:	50                   	push   %eax
  80306d:	e8 b2 fb ff ff       	call   802c24 <merging>
  803072:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803075:	e9 8b 00 00 00       	jmp    803105 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80307a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80307f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803082:	76 18                	jbe    80309c <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803084:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	ff 75 08             	pushl  0x8(%ebp)
  80308f:	50                   	push   %eax
  803090:	6a 00                	push   $0x0
  803092:	e8 8d fb ff ff       	call   802c24 <merging>
  803097:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80309a:	eb 69                	jmp    803105 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80309c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8030a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030a4:	eb 39                	jmp    8030df <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ac:	73 29                	jae    8030d7 <free_block+0x90>
  8030ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b1:	8b 00                	mov    (%eax),%eax
  8030b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030b6:	76 1f                	jbe    8030d7 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	8b 00                	mov    (%eax),%eax
  8030bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030c0:	83 ec 04             	sub    $0x4,%esp
  8030c3:	ff 75 08             	pushl  0x8(%ebp)
  8030c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8030c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8030cc:	e8 53 fb ff ff       	call   802c24 <merging>
  8030d1:	83 c4 10             	add    $0x10,%esp
			break;
  8030d4:	90                   	nop
		}
	}
}
  8030d5:	eb 2e                	jmp    803105 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030d7:	a1 34 50 80 00       	mov    0x805034,%eax
  8030dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e3:	74 07                	je     8030ec <free_block+0xa5>
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	8b 00                	mov    (%eax),%eax
  8030ea:	eb 05                	jmp    8030f1 <free_block+0xaa>
  8030ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f1:	a3 34 50 80 00       	mov    %eax,0x805034
  8030f6:	a1 34 50 80 00       	mov    0x805034,%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	75 a7                	jne    8030a6 <free_block+0x5f>
  8030ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803103:	75 a1                	jne    8030a6 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803105:	90                   	nop
  803106:	c9                   	leave  
  803107:	c3                   	ret    

00803108 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803108:	55                   	push   %ebp
  803109:	89 e5                	mov    %esp,%ebp
  80310b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80310e:	ff 75 08             	pushl  0x8(%ebp)
  803111:	e8 ed ec ff ff       	call   801e03 <get_block_size>
  803116:	83 c4 04             	add    $0x4,%esp
  803119:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80311c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803123:	eb 17                	jmp    80313c <copy_data+0x34>
  803125:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80312b:	01 c2                	add    %eax,%edx
  80312d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	01 c8                	add    %ecx,%eax
  803135:	8a 00                	mov    (%eax),%al
  803137:	88 02                	mov    %al,(%edx)
  803139:	ff 45 fc             	incl   -0x4(%ebp)
  80313c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80313f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803142:	72 e1                	jb     803125 <copy_data+0x1d>
}
  803144:	90                   	nop
  803145:	c9                   	leave  
  803146:	c3                   	ret    

00803147 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803147:	55                   	push   %ebp
  803148:	89 e5                	mov    %esp,%ebp
  80314a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  80314d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803151:	75 23                	jne    803176 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803153:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803157:	74 13                	je     80316c <realloc_block_FF+0x25>
  803159:	83 ec 0c             	sub    $0xc,%esp
  80315c:	ff 75 0c             	pushl  0xc(%ebp)
  80315f:	e8 1f f0 ff ff       	call   802183 <alloc_block_FF>
  803164:	83 c4 10             	add    $0x10,%esp
  803167:	e9 f4 06 00 00       	jmp    803860 <realloc_block_FF+0x719>
		return NULL;
  80316c:	b8 00 00 00 00       	mov    $0x0,%eax
  803171:	e9 ea 06 00 00       	jmp    803860 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803176:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80317a:	75 18                	jne    803194 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80317c:	83 ec 0c             	sub    $0xc,%esp
  80317f:	ff 75 08             	pushl  0x8(%ebp)
  803182:	e8 c0 fe ff ff       	call   803047 <free_block>
  803187:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80318a:	b8 00 00 00 00       	mov    $0x0,%eax
  80318f:	e9 cc 06 00 00       	jmp    803860 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803194:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803198:	77 07                	ja     8031a1 <realloc_block_FF+0x5a>
  80319a:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8031a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a4:	83 e0 01             	and    $0x1,%eax
  8031a7:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8031aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ad:	83 c0 08             	add    $0x8,%eax
  8031b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8031b3:	83 ec 0c             	sub    $0xc,%esp
  8031b6:	ff 75 08             	pushl  0x8(%ebp)
  8031b9:	e8 45 ec ff ff       	call   801e03 <get_block_size>
  8031be:	83 c4 10             	add    $0x10,%esp
  8031c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c7:	83 e8 08             	sub    $0x8,%eax
  8031ca:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	83 e8 04             	sub    $0x4,%eax
  8031d3:	8b 00                	mov    (%eax),%eax
  8031d5:	83 e0 fe             	and    $0xfffffffe,%eax
  8031d8:	89 c2                	mov    %eax,%edx
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	01 d0                	add    %edx,%eax
  8031df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031e2:	83 ec 0c             	sub    $0xc,%esp
  8031e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031e8:	e8 16 ec ff ff       	call   801e03 <get_block_size>
  8031ed:	83 c4 10             	add    $0x10,%esp
  8031f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f6:	83 e8 08             	sub    $0x8,%eax
  8031f9:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8031fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ff:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803202:	75 08                	jne    80320c <realloc_block_FF+0xc5>
	{
		 return va;
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	e9 54 06 00 00       	jmp    803860 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80320c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80320f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803212:	0f 83 e5 03 00 00    	jae    8035fd <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803218:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80321e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803221:	83 ec 0c             	sub    $0xc,%esp
  803224:	ff 75 e4             	pushl  -0x1c(%ebp)
  803227:	e8 f0 eb ff ff       	call   801e1c <is_free_block>
  80322c:	83 c4 10             	add    $0x10,%esp
  80322f:	84 c0                	test   %al,%al
  803231:	0f 84 3b 01 00 00    	je     803372 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803237:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80323a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80323d:	01 d0                	add    %edx,%eax
  80323f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803242:	83 ec 04             	sub    $0x4,%esp
  803245:	6a 01                	push   $0x1
  803247:	ff 75 f0             	pushl  -0x10(%ebp)
  80324a:	ff 75 08             	pushl  0x8(%ebp)
  80324d:	e8 02 ef ff ff       	call   802154 <set_block_data>
  803252:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	83 e8 04             	sub    $0x4,%eax
  80325b:	8b 00                	mov    (%eax),%eax
  80325d:	83 e0 fe             	and    $0xfffffffe,%eax
  803260:	89 c2                	mov    %eax,%edx
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	01 d0                	add    %edx,%eax
  803267:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80326a:	83 ec 04             	sub    $0x4,%esp
  80326d:	6a 00                	push   $0x0
  80326f:	ff 75 cc             	pushl  -0x34(%ebp)
  803272:	ff 75 c8             	pushl  -0x38(%ebp)
  803275:	e8 da ee ff ff       	call   802154 <set_block_data>
  80327a:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80327d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803281:	74 06                	je     803289 <realloc_block_FF+0x142>
  803283:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803287:	75 17                	jne    8032a0 <realloc_block_FF+0x159>
  803289:	83 ec 04             	sub    $0x4,%esp
  80328c:	68 14 44 80 00       	push   $0x804414
  803291:	68 f6 01 00 00       	push   $0x1f6
  803296:	68 a1 43 80 00       	push   $0x8043a1
  80329b:	e8 38 06 00 00       	call   8038d8 <_panic>
  8032a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a3:	8b 10                	mov    (%eax),%edx
  8032a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032a8:	89 10                	mov    %edx,(%eax)
  8032aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	85 c0                	test   %eax,%eax
  8032b1:	74 0b                	je     8032be <realloc_block_FF+0x177>
  8032b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032bb:	89 50 04             	mov    %edx,0x4(%eax)
  8032be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032c4:	89 10                	mov    %edx,(%eax)
  8032c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032cc:	89 50 04             	mov    %edx,0x4(%eax)
  8032cf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032d2:	8b 00                	mov    (%eax),%eax
  8032d4:	85 c0                	test   %eax,%eax
  8032d6:	75 08                	jne    8032e0 <realloc_block_FF+0x199>
  8032d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032db:	a3 30 50 80 00       	mov    %eax,0x805030
  8032e0:	a1 38 50 80 00       	mov    0x805038,%eax
  8032e5:	40                   	inc    %eax
  8032e6:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032ef:	75 17                	jne    803308 <realloc_block_FF+0x1c1>
  8032f1:	83 ec 04             	sub    $0x4,%esp
  8032f4:	68 83 43 80 00       	push   $0x804383
  8032f9:	68 f7 01 00 00       	push   $0x1f7
  8032fe:	68 a1 43 80 00       	push   $0x8043a1
  803303:	e8 d0 05 00 00       	call   8038d8 <_panic>
  803308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330b:	8b 00                	mov    (%eax),%eax
  80330d:	85 c0                	test   %eax,%eax
  80330f:	74 10                	je     803321 <realloc_block_FF+0x1da>
  803311:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803319:	8b 52 04             	mov    0x4(%edx),%edx
  80331c:	89 50 04             	mov    %edx,0x4(%eax)
  80331f:	eb 0b                	jmp    80332c <realloc_block_FF+0x1e5>
  803321:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803324:	8b 40 04             	mov    0x4(%eax),%eax
  803327:	a3 30 50 80 00       	mov    %eax,0x805030
  80332c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332f:	8b 40 04             	mov    0x4(%eax),%eax
  803332:	85 c0                	test   %eax,%eax
  803334:	74 0f                	je     803345 <realloc_block_FF+0x1fe>
  803336:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803339:	8b 40 04             	mov    0x4(%eax),%eax
  80333c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80333f:	8b 12                	mov    (%edx),%edx
  803341:	89 10                	mov    %edx,(%eax)
  803343:	eb 0a                	jmp    80334f <realloc_block_FF+0x208>
  803345:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803348:	8b 00                	mov    (%eax),%eax
  80334a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80334f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803352:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80335b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803362:	a1 38 50 80 00       	mov    0x805038,%eax
  803367:	48                   	dec    %eax
  803368:	a3 38 50 80 00       	mov    %eax,0x805038
  80336d:	e9 83 02 00 00       	jmp    8035f5 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803372:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803376:	0f 86 69 02 00 00    	jbe    8035e5 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80337c:	83 ec 04             	sub    $0x4,%esp
  80337f:	6a 01                	push   $0x1
  803381:	ff 75 f0             	pushl  -0x10(%ebp)
  803384:	ff 75 08             	pushl  0x8(%ebp)
  803387:	e8 c8 ed ff ff       	call   802154 <set_block_data>
  80338c:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	83 e8 04             	sub    $0x4,%eax
  803395:	8b 00                	mov    (%eax),%eax
  803397:	83 e0 fe             	and    $0xfffffffe,%eax
  80339a:	89 c2                	mov    %eax,%edx
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	01 d0                	add    %edx,%eax
  8033a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8033a4:	a1 38 50 80 00       	mov    0x805038,%eax
  8033a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8033ac:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8033b0:	75 68                	jne    80341a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033b2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033b6:	75 17                	jne    8033cf <realloc_block_FF+0x288>
  8033b8:	83 ec 04             	sub    $0x4,%esp
  8033bb:	68 bc 43 80 00       	push   $0x8043bc
  8033c0:	68 06 02 00 00       	push   $0x206
  8033c5:	68 a1 43 80 00       	push   $0x8043a1
  8033ca:	e8 09 05 00 00       	call   8038d8 <_panic>
  8033cf:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d8:	89 10                	mov    %edx,(%eax)
  8033da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033dd:	8b 00                	mov    (%eax),%eax
  8033df:	85 c0                	test   %eax,%eax
  8033e1:	74 0d                	je     8033f0 <realloc_block_FF+0x2a9>
  8033e3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033eb:	89 50 04             	mov    %edx,0x4(%eax)
  8033ee:	eb 08                	jmp    8033f8 <realloc_block_FF+0x2b1>
  8033f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f3:	a3 30 50 80 00       	mov    %eax,0x805030
  8033f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033fb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803400:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803403:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340a:	a1 38 50 80 00       	mov    0x805038,%eax
  80340f:	40                   	inc    %eax
  803410:	a3 38 50 80 00       	mov    %eax,0x805038
  803415:	e9 b0 01 00 00       	jmp    8035ca <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80341a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80341f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803422:	76 68                	jbe    80348c <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803424:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803428:	75 17                	jne    803441 <realloc_block_FF+0x2fa>
  80342a:	83 ec 04             	sub    $0x4,%esp
  80342d:	68 bc 43 80 00       	push   $0x8043bc
  803432:	68 0b 02 00 00       	push   $0x20b
  803437:	68 a1 43 80 00       	push   $0x8043a1
  80343c:	e8 97 04 00 00       	call   8038d8 <_panic>
  803441:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803447:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344a:	89 10                	mov    %edx,(%eax)
  80344c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344f:	8b 00                	mov    (%eax),%eax
  803451:	85 c0                	test   %eax,%eax
  803453:	74 0d                	je     803462 <realloc_block_FF+0x31b>
  803455:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80345a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80345d:	89 50 04             	mov    %edx,0x4(%eax)
  803460:	eb 08                	jmp    80346a <realloc_block_FF+0x323>
  803462:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803465:	a3 30 50 80 00       	mov    %eax,0x805030
  80346a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80346d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803472:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803475:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347c:	a1 38 50 80 00       	mov    0x805038,%eax
  803481:	40                   	inc    %eax
  803482:	a3 38 50 80 00       	mov    %eax,0x805038
  803487:	e9 3e 01 00 00       	jmp    8035ca <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80348c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803491:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803494:	73 68                	jae    8034fe <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803496:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80349a:	75 17                	jne    8034b3 <realloc_block_FF+0x36c>
  80349c:	83 ec 04             	sub    $0x4,%esp
  80349f:	68 f0 43 80 00       	push   $0x8043f0
  8034a4:	68 10 02 00 00       	push   $0x210
  8034a9:	68 a1 43 80 00       	push   $0x8043a1
  8034ae:	e8 25 04 00 00       	call   8038d8 <_panic>
  8034b3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8034b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bc:	89 50 04             	mov    %edx,0x4(%eax)
  8034bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c2:	8b 40 04             	mov    0x4(%eax),%eax
  8034c5:	85 c0                	test   %eax,%eax
  8034c7:	74 0c                	je     8034d5 <realloc_block_FF+0x38e>
  8034c9:	a1 30 50 80 00       	mov    0x805030,%eax
  8034ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034d1:	89 10                	mov    %edx,(%eax)
  8034d3:	eb 08                	jmp    8034dd <realloc_block_FF+0x396>
  8034d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034d8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8034e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8034f3:	40                   	inc    %eax
  8034f4:	a3 38 50 80 00       	mov    %eax,0x805038
  8034f9:	e9 cc 00 00 00       	jmp    8035ca <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8034fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803505:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80350a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80350d:	e9 8a 00 00 00       	jmp    80359c <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803515:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803518:	73 7a                	jae    803594 <realloc_block_FF+0x44d>
  80351a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351d:	8b 00                	mov    (%eax),%eax
  80351f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803522:	73 70                	jae    803594 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803528:	74 06                	je     803530 <realloc_block_FF+0x3e9>
  80352a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80352e:	75 17                	jne    803547 <realloc_block_FF+0x400>
  803530:	83 ec 04             	sub    $0x4,%esp
  803533:	68 14 44 80 00       	push   $0x804414
  803538:	68 1a 02 00 00       	push   $0x21a
  80353d:	68 a1 43 80 00       	push   $0x8043a1
  803542:	e8 91 03 00 00       	call   8038d8 <_panic>
  803547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354a:	8b 10                	mov    (%eax),%edx
  80354c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80354f:	89 10                	mov    %edx,(%eax)
  803551:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803554:	8b 00                	mov    (%eax),%eax
  803556:	85 c0                	test   %eax,%eax
  803558:	74 0b                	je     803565 <realloc_block_FF+0x41e>
  80355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355d:	8b 00                	mov    (%eax),%eax
  80355f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803562:	89 50 04             	mov    %edx,0x4(%eax)
  803565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803568:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80356b:	89 10                	mov    %edx,(%eax)
  80356d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803573:	89 50 04             	mov    %edx,0x4(%eax)
  803576:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803579:	8b 00                	mov    (%eax),%eax
  80357b:	85 c0                	test   %eax,%eax
  80357d:	75 08                	jne    803587 <realloc_block_FF+0x440>
  80357f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803582:	a3 30 50 80 00       	mov    %eax,0x805030
  803587:	a1 38 50 80 00       	mov    0x805038,%eax
  80358c:	40                   	inc    %eax
  80358d:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803592:	eb 36                	jmp    8035ca <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803594:	a1 34 50 80 00       	mov    0x805034,%eax
  803599:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80359c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a0:	74 07                	je     8035a9 <realloc_block_FF+0x462>
  8035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a5:	8b 00                	mov    (%eax),%eax
  8035a7:	eb 05                	jmp    8035ae <realloc_block_FF+0x467>
  8035a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8035ae:	a3 34 50 80 00       	mov    %eax,0x805034
  8035b3:	a1 34 50 80 00       	mov    0x805034,%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	0f 85 52 ff ff ff    	jne    803512 <realloc_block_FF+0x3cb>
  8035c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c4:	0f 85 48 ff ff ff    	jne    803512 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035ca:	83 ec 04             	sub    $0x4,%esp
  8035cd:	6a 00                	push   $0x0
  8035cf:	ff 75 d8             	pushl  -0x28(%ebp)
  8035d2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035d5:	e8 7a eb ff ff       	call   802154 <set_block_data>
  8035da:	83 c4 10             	add    $0x10,%esp
				return va;
  8035dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e0:	e9 7b 02 00 00       	jmp    803860 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035e5:	83 ec 0c             	sub    $0xc,%esp
  8035e8:	68 91 44 80 00       	push   $0x804491
  8035ed:	e8 d6 cd ff ff       	call   8003c8 <cprintf>
  8035f2:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	e9 63 02 00 00       	jmp    803860 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8035fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803600:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803603:	0f 86 4d 02 00 00    	jbe    803856 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803609:	83 ec 0c             	sub    $0xc,%esp
  80360c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80360f:	e8 08 e8 ff ff       	call   801e1c <is_free_block>
  803614:	83 c4 10             	add    $0x10,%esp
  803617:	84 c0                	test   %al,%al
  803619:	0f 84 37 02 00 00    	je     803856 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80361f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803622:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803625:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803628:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80362b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80362e:	76 38                	jbe    803668 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803630:	83 ec 0c             	sub    $0xc,%esp
  803633:	ff 75 08             	pushl  0x8(%ebp)
  803636:	e8 0c fa ff ff       	call   803047 <free_block>
  80363b:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80363e:	83 ec 0c             	sub    $0xc,%esp
  803641:	ff 75 0c             	pushl  0xc(%ebp)
  803644:	e8 3a eb ff ff       	call   802183 <alloc_block_FF>
  803649:	83 c4 10             	add    $0x10,%esp
  80364c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80364f:	83 ec 08             	sub    $0x8,%esp
  803652:	ff 75 c0             	pushl  -0x40(%ebp)
  803655:	ff 75 08             	pushl  0x8(%ebp)
  803658:	e8 ab fa ff ff       	call   803108 <copy_data>
  80365d:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803660:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803663:	e9 f8 01 00 00       	jmp    803860 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803668:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80366b:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80366e:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803671:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803675:	0f 87 a0 00 00 00    	ja     80371b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80367b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80367f:	75 17                	jne    803698 <realloc_block_FF+0x551>
  803681:	83 ec 04             	sub    $0x4,%esp
  803684:	68 83 43 80 00       	push   $0x804383
  803689:	68 38 02 00 00       	push   $0x238
  80368e:	68 a1 43 80 00       	push   $0x8043a1
  803693:	e8 40 02 00 00       	call   8038d8 <_panic>
  803698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369b:	8b 00                	mov    (%eax),%eax
  80369d:	85 c0                	test   %eax,%eax
  80369f:	74 10                	je     8036b1 <realloc_block_FF+0x56a>
  8036a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a4:	8b 00                	mov    (%eax),%eax
  8036a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036a9:	8b 52 04             	mov    0x4(%edx),%edx
  8036ac:	89 50 04             	mov    %edx,0x4(%eax)
  8036af:	eb 0b                	jmp    8036bc <realloc_block_FF+0x575>
  8036b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b4:	8b 40 04             	mov    0x4(%eax),%eax
  8036b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8036bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036bf:	8b 40 04             	mov    0x4(%eax),%eax
  8036c2:	85 c0                	test   %eax,%eax
  8036c4:	74 0f                	je     8036d5 <realloc_block_FF+0x58e>
  8036c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c9:	8b 40 04             	mov    0x4(%eax),%eax
  8036cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036cf:	8b 12                	mov    (%edx),%edx
  8036d1:	89 10                	mov    %edx,(%eax)
  8036d3:	eb 0a                	jmp    8036df <realloc_block_FF+0x598>
  8036d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d8:	8b 00                	mov    (%eax),%eax
  8036da:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8036f7:	48                   	dec    %eax
  8036f8:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8036fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803703:	01 d0                	add    %edx,%eax
  803705:	83 ec 04             	sub    $0x4,%esp
  803708:	6a 01                	push   $0x1
  80370a:	50                   	push   %eax
  80370b:	ff 75 08             	pushl  0x8(%ebp)
  80370e:	e8 41 ea ff ff       	call   802154 <set_block_data>
  803713:	83 c4 10             	add    $0x10,%esp
  803716:	e9 36 01 00 00       	jmp    803851 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80371b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80371e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803721:	01 d0                	add    %edx,%eax
  803723:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803726:	83 ec 04             	sub    $0x4,%esp
  803729:	6a 01                	push   $0x1
  80372b:	ff 75 f0             	pushl  -0x10(%ebp)
  80372e:	ff 75 08             	pushl  0x8(%ebp)
  803731:	e8 1e ea ff ff       	call   802154 <set_block_data>
  803736:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803739:	8b 45 08             	mov    0x8(%ebp),%eax
  80373c:	83 e8 04             	sub    $0x4,%eax
  80373f:	8b 00                	mov    (%eax),%eax
  803741:	83 e0 fe             	and    $0xfffffffe,%eax
  803744:	89 c2                	mov    %eax,%edx
  803746:	8b 45 08             	mov    0x8(%ebp),%eax
  803749:	01 d0                	add    %edx,%eax
  80374b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80374e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803752:	74 06                	je     80375a <realloc_block_FF+0x613>
  803754:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803758:	75 17                	jne    803771 <realloc_block_FF+0x62a>
  80375a:	83 ec 04             	sub    $0x4,%esp
  80375d:	68 14 44 80 00       	push   $0x804414
  803762:	68 44 02 00 00       	push   $0x244
  803767:	68 a1 43 80 00       	push   $0x8043a1
  80376c:	e8 67 01 00 00       	call   8038d8 <_panic>
  803771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803774:	8b 10                	mov    (%eax),%edx
  803776:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803779:	89 10                	mov    %edx,(%eax)
  80377b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80377e:	8b 00                	mov    (%eax),%eax
  803780:	85 c0                	test   %eax,%eax
  803782:	74 0b                	je     80378f <realloc_block_FF+0x648>
  803784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803787:	8b 00                	mov    (%eax),%eax
  803789:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80378c:	89 50 04             	mov    %edx,0x4(%eax)
  80378f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803792:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803795:	89 10                	mov    %edx,(%eax)
  803797:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80379a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80379d:	89 50 04             	mov    %edx,0x4(%eax)
  8037a0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037a3:	8b 00                	mov    (%eax),%eax
  8037a5:	85 c0                	test   %eax,%eax
  8037a7:	75 08                	jne    8037b1 <realloc_block_FF+0x66a>
  8037a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8037ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8037b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8037b6:	40                   	inc    %eax
  8037b7:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8037bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037c0:	75 17                	jne    8037d9 <realloc_block_FF+0x692>
  8037c2:	83 ec 04             	sub    $0x4,%esp
  8037c5:	68 83 43 80 00       	push   $0x804383
  8037ca:	68 45 02 00 00       	push   $0x245
  8037cf:	68 a1 43 80 00       	push   $0x8043a1
  8037d4:	e8 ff 00 00 00       	call   8038d8 <_panic>
  8037d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037dc:	8b 00                	mov    (%eax),%eax
  8037de:	85 c0                	test   %eax,%eax
  8037e0:	74 10                	je     8037f2 <realloc_block_FF+0x6ab>
  8037e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e5:	8b 00                	mov    (%eax),%eax
  8037e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037ea:	8b 52 04             	mov    0x4(%edx),%edx
  8037ed:	89 50 04             	mov    %edx,0x4(%eax)
  8037f0:	eb 0b                	jmp    8037fd <realloc_block_FF+0x6b6>
  8037f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f5:	8b 40 04             	mov    0x4(%eax),%eax
  8037f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8037fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803800:	8b 40 04             	mov    0x4(%eax),%eax
  803803:	85 c0                	test   %eax,%eax
  803805:	74 0f                	je     803816 <realloc_block_FF+0x6cf>
  803807:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380a:	8b 40 04             	mov    0x4(%eax),%eax
  80380d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803810:	8b 12                	mov    (%edx),%edx
  803812:	89 10                	mov    %edx,(%eax)
  803814:	eb 0a                	jmp    803820 <realloc_block_FF+0x6d9>
  803816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803819:	8b 00                	mov    (%eax),%eax
  80381b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803820:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803823:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80382c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803833:	a1 38 50 80 00       	mov    0x805038,%eax
  803838:	48                   	dec    %eax
  803839:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80383e:	83 ec 04             	sub    $0x4,%esp
  803841:	6a 00                	push   $0x0
  803843:	ff 75 bc             	pushl  -0x44(%ebp)
  803846:	ff 75 b8             	pushl  -0x48(%ebp)
  803849:	e8 06 e9 ff ff       	call   802154 <set_block_data>
  80384e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803851:	8b 45 08             	mov    0x8(%ebp),%eax
  803854:	eb 0a                	jmp    803860 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803856:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  80385d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803860:	c9                   	leave  
  803861:	c3                   	ret    

00803862 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803862:	55                   	push   %ebp
  803863:	89 e5                	mov    %esp,%ebp
  803865:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803868:	83 ec 04             	sub    $0x4,%esp
  80386b:	68 98 44 80 00       	push   $0x804498
  803870:	68 58 02 00 00       	push   $0x258
  803875:	68 a1 43 80 00       	push   $0x8043a1
  80387a:	e8 59 00 00 00       	call   8038d8 <_panic>

0080387f <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80387f:	55                   	push   %ebp
  803880:	89 e5                	mov    %esp,%ebp
  803882:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803885:	83 ec 04             	sub    $0x4,%esp
  803888:	68 c0 44 80 00       	push   $0x8044c0
  80388d:	68 61 02 00 00       	push   $0x261
  803892:	68 a1 43 80 00       	push   $0x8043a1
  803897:	e8 3c 00 00 00       	call   8038d8 <_panic>

0080389c <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80389c:	55                   	push   %ebp
  80389d:	89 e5                	mov    %esp,%ebp
  80389f:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8038a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a5:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8038a8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8038ac:	83 ec 0c             	sub    $0xc,%esp
  8038af:	50                   	push   %eax
  8038b0:	e8 dd e0 ff ff       	call   801992 <sys_cputc>
  8038b5:	83 c4 10             	add    $0x10,%esp
}
  8038b8:	90                   	nop
  8038b9:	c9                   	leave  
  8038ba:	c3                   	ret    

008038bb <getchar>:


int
getchar(void)
{
  8038bb:	55                   	push   %ebp
  8038bc:	89 e5                	mov    %esp,%ebp
  8038be:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8038c1:	e8 68 df ff ff       	call   80182e <sys_cgetc>
  8038c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8038c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8038cc:	c9                   	leave  
  8038cd:	c3                   	ret    

008038ce <iscons>:

int iscons(int fdnum)
{
  8038ce:	55                   	push   %ebp
  8038cf:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8038d1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8038d6:	5d                   	pop    %ebp
  8038d7:	c3                   	ret    

008038d8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8038d8:	55                   	push   %ebp
  8038d9:	89 e5                	mov    %esp,%ebp
  8038db:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8038de:	8d 45 10             	lea    0x10(%ebp),%eax
  8038e1:	83 c0 04             	add    $0x4,%eax
  8038e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8038e7:	a1 60 50 90 00       	mov    0x905060,%eax
  8038ec:	85 c0                	test   %eax,%eax
  8038ee:	74 16                	je     803906 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8038f0:	a1 60 50 90 00       	mov    0x905060,%eax
  8038f5:	83 ec 08             	sub    $0x8,%esp
  8038f8:	50                   	push   %eax
  8038f9:	68 e8 44 80 00       	push   $0x8044e8
  8038fe:	e8 c5 ca ff ff       	call   8003c8 <cprintf>
  803903:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803906:	a1 00 50 80 00       	mov    0x805000,%eax
  80390b:	ff 75 0c             	pushl  0xc(%ebp)
  80390e:	ff 75 08             	pushl  0x8(%ebp)
  803911:	50                   	push   %eax
  803912:	68 ed 44 80 00       	push   $0x8044ed
  803917:	e8 ac ca ff ff       	call   8003c8 <cprintf>
  80391c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80391f:	8b 45 10             	mov    0x10(%ebp),%eax
  803922:	83 ec 08             	sub    $0x8,%esp
  803925:	ff 75 f4             	pushl  -0xc(%ebp)
  803928:	50                   	push   %eax
  803929:	e8 2f ca ff ff       	call   80035d <vcprintf>
  80392e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803931:	83 ec 08             	sub    $0x8,%esp
  803934:	6a 00                	push   $0x0
  803936:	68 09 45 80 00       	push   $0x804509
  80393b:	e8 1d ca ff ff       	call   80035d <vcprintf>
  803940:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803943:	e8 9e c9 ff ff       	call   8002e6 <exit>

	// should not return here
	while (1) ;
  803948:	eb fe                	jmp    803948 <_panic+0x70>

0080394a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80394a:	55                   	push   %ebp
  80394b:	89 e5                	mov    %esp,%ebp
  80394d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803950:	a1 20 50 80 00       	mov    0x805020,%eax
  803955:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80395b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80395e:	39 c2                	cmp    %eax,%edx
  803960:	74 14                	je     803976 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803962:	83 ec 04             	sub    $0x4,%esp
  803965:	68 0c 45 80 00       	push   $0x80450c
  80396a:	6a 26                	push   $0x26
  80396c:	68 58 45 80 00       	push   $0x804558
  803971:	e8 62 ff ff ff       	call   8038d8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803976:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80397d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803984:	e9 c5 00 00 00       	jmp    803a4e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80398c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803993:	8b 45 08             	mov    0x8(%ebp),%eax
  803996:	01 d0                	add    %edx,%eax
  803998:	8b 00                	mov    (%eax),%eax
  80399a:	85 c0                	test   %eax,%eax
  80399c:	75 08                	jne    8039a6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80399e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8039a1:	e9 a5 00 00 00       	jmp    803a4b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8039a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039ad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8039b4:	eb 69                	jmp    803a1f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8039b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8039bb:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039c4:	89 d0                	mov    %edx,%eax
  8039c6:	01 c0                	add    %eax,%eax
  8039c8:	01 d0                	add    %edx,%eax
  8039ca:	c1 e0 03             	shl    $0x3,%eax
  8039cd:	01 c8                	add    %ecx,%eax
  8039cf:	8a 40 04             	mov    0x4(%eax),%al
  8039d2:	84 c0                	test   %al,%al
  8039d4:	75 46                	jne    803a1c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8039d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8039db:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039e4:	89 d0                	mov    %edx,%eax
  8039e6:	01 c0                	add    %eax,%eax
  8039e8:	01 d0                	add    %edx,%eax
  8039ea:	c1 e0 03             	shl    $0x3,%eax
  8039ed:	01 c8                	add    %ecx,%eax
  8039ef:	8b 00                	mov    (%eax),%eax
  8039f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8039f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8039fc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8039fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a01:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a08:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0b:	01 c8                	add    %ecx,%eax
  803a0d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a0f:	39 c2                	cmp    %eax,%edx
  803a11:	75 09                	jne    803a1c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a13:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a1a:	eb 15                	jmp    803a31 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a1c:	ff 45 e8             	incl   -0x18(%ebp)
  803a1f:	a1 20 50 80 00       	mov    0x805020,%eax
  803a24:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2d:	39 c2                	cmp    %eax,%edx
  803a2f:	77 85                	ja     8039b6 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a31:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a35:	75 14                	jne    803a4b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803a37:	83 ec 04             	sub    $0x4,%esp
  803a3a:	68 64 45 80 00       	push   $0x804564
  803a3f:	6a 3a                	push   $0x3a
  803a41:	68 58 45 80 00       	push   $0x804558
  803a46:	e8 8d fe ff ff       	call   8038d8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803a4b:	ff 45 f0             	incl   -0x10(%ebp)
  803a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a51:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a54:	0f 8c 2f ff ff ff    	jl     803989 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803a5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a61:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803a68:	eb 26                	jmp    803a90 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803a6a:	a1 20 50 80 00       	mov    0x805020,%eax
  803a6f:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a78:	89 d0                	mov    %edx,%eax
  803a7a:	01 c0                	add    %eax,%eax
  803a7c:	01 d0                	add    %edx,%eax
  803a7e:	c1 e0 03             	shl    $0x3,%eax
  803a81:	01 c8                	add    %ecx,%eax
  803a83:	8a 40 04             	mov    0x4(%eax),%al
  803a86:	3c 01                	cmp    $0x1,%al
  803a88:	75 03                	jne    803a8d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803a8a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a8d:	ff 45 e0             	incl   -0x20(%ebp)
  803a90:	a1 20 50 80 00       	mov    0x805020,%eax
  803a95:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a9e:	39 c2                	cmp    %eax,%edx
  803aa0:	77 c8                	ja     803a6a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803aa8:	74 14                	je     803abe <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803aaa:	83 ec 04             	sub    $0x4,%esp
  803aad:	68 b8 45 80 00       	push   $0x8045b8
  803ab2:	6a 44                	push   $0x44
  803ab4:	68 58 45 80 00       	push   $0x804558
  803ab9:	e8 1a fe ff ff       	call   8038d8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803abe:	90                   	nop
  803abf:	c9                   	leave  
  803ac0:	c3                   	ret    
  803ac1:	66 90                	xchg   %ax,%ax
  803ac3:	90                   	nop

00803ac4 <__udivdi3>:
  803ac4:	55                   	push   %ebp
  803ac5:	57                   	push   %edi
  803ac6:	56                   	push   %esi
  803ac7:	53                   	push   %ebx
  803ac8:	83 ec 1c             	sub    $0x1c,%esp
  803acb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803acf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ad3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ad7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803adb:	89 ca                	mov    %ecx,%edx
  803add:	89 f8                	mov    %edi,%eax
  803adf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ae3:	85 f6                	test   %esi,%esi
  803ae5:	75 2d                	jne    803b14 <__udivdi3+0x50>
  803ae7:	39 cf                	cmp    %ecx,%edi
  803ae9:	77 65                	ja     803b50 <__udivdi3+0x8c>
  803aeb:	89 fd                	mov    %edi,%ebp
  803aed:	85 ff                	test   %edi,%edi
  803aef:	75 0b                	jne    803afc <__udivdi3+0x38>
  803af1:	b8 01 00 00 00       	mov    $0x1,%eax
  803af6:	31 d2                	xor    %edx,%edx
  803af8:	f7 f7                	div    %edi
  803afa:	89 c5                	mov    %eax,%ebp
  803afc:	31 d2                	xor    %edx,%edx
  803afe:	89 c8                	mov    %ecx,%eax
  803b00:	f7 f5                	div    %ebp
  803b02:	89 c1                	mov    %eax,%ecx
  803b04:	89 d8                	mov    %ebx,%eax
  803b06:	f7 f5                	div    %ebp
  803b08:	89 cf                	mov    %ecx,%edi
  803b0a:	89 fa                	mov    %edi,%edx
  803b0c:	83 c4 1c             	add    $0x1c,%esp
  803b0f:	5b                   	pop    %ebx
  803b10:	5e                   	pop    %esi
  803b11:	5f                   	pop    %edi
  803b12:	5d                   	pop    %ebp
  803b13:	c3                   	ret    
  803b14:	39 ce                	cmp    %ecx,%esi
  803b16:	77 28                	ja     803b40 <__udivdi3+0x7c>
  803b18:	0f bd fe             	bsr    %esi,%edi
  803b1b:	83 f7 1f             	xor    $0x1f,%edi
  803b1e:	75 40                	jne    803b60 <__udivdi3+0x9c>
  803b20:	39 ce                	cmp    %ecx,%esi
  803b22:	72 0a                	jb     803b2e <__udivdi3+0x6a>
  803b24:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b28:	0f 87 9e 00 00 00    	ja     803bcc <__udivdi3+0x108>
  803b2e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b33:	89 fa                	mov    %edi,%edx
  803b35:	83 c4 1c             	add    $0x1c,%esp
  803b38:	5b                   	pop    %ebx
  803b39:	5e                   	pop    %esi
  803b3a:	5f                   	pop    %edi
  803b3b:	5d                   	pop    %ebp
  803b3c:	c3                   	ret    
  803b3d:	8d 76 00             	lea    0x0(%esi),%esi
  803b40:	31 ff                	xor    %edi,%edi
  803b42:	31 c0                	xor    %eax,%eax
  803b44:	89 fa                	mov    %edi,%edx
  803b46:	83 c4 1c             	add    $0x1c,%esp
  803b49:	5b                   	pop    %ebx
  803b4a:	5e                   	pop    %esi
  803b4b:	5f                   	pop    %edi
  803b4c:	5d                   	pop    %ebp
  803b4d:	c3                   	ret    
  803b4e:	66 90                	xchg   %ax,%ax
  803b50:	89 d8                	mov    %ebx,%eax
  803b52:	f7 f7                	div    %edi
  803b54:	31 ff                	xor    %edi,%edi
  803b56:	89 fa                	mov    %edi,%edx
  803b58:	83 c4 1c             	add    $0x1c,%esp
  803b5b:	5b                   	pop    %ebx
  803b5c:	5e                   	pop    %esi
  803b5d:	5f                   	pop    %edi
  803b5e:	5d                   	pop    %ebp
  803b5f:	c3                   	ret    
  803b60:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b65:	89 eb                	mov    %ebp,%ebx
  803b67:	29 fb                	sub    %edi,%ebx
  803b69:	89 f9                	mov    %edi,%ecx
  803b6b:	d3 e6                	shl    %cl,%esi
  803b6d:	89 c5                	mov    %eax,%ebp
  803b6f:	88 d9                	mov    %bl,%cl
  803b71:	d3 ed                	shr    %cl,%ebp
  803b73:	89 e9                	mov    %ebp,%ecx
  803b75:	09 f1                	or     %esi,%ecx
  803b77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b7b:	89 f9                	mov    %edi,%ecx
  803b7d:	d3 e0                	shl    %cl,%eax
  803b7f:	89 c5                	mov    %eax,%ebp
  803b81:	89 d6                	mov    %edx,%esi
  803b83:	88 d9                	mov    %bl,%cl
  803b85:	d3 ee                	shr    %cl,%esi
  803b87:	89 f9                	mov    %edi,%ecx
  803b89:	d3 e2                	shl    %cl,%edx
  803b8b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b8f:	88 d9                	mov    %bl,%cl
  803b91:	d3 e8                	shr    %cl,%eax
  803b93:	09 c2                	or     %eax,%edx
  803b95:	89 d0                	mov    %edx,%eax
  803b97:	89 f2                	mov    %esi,%edx
  803b99:	f7 74 24 0c          	divl   0xc(%esp)
  803b9d:	89 d6                	mov    %edx,%esi
  803b9f:	89 c3                	mov    %eax,%ebx
  803ba1:	f7 e5                	mul    %ebp
  803ba3:	39 d6                	cmp    %edx,%esi
  803ba5:	72 19                	jb     803bc0 <__udivdi3+0xfc>
  803ba7:	74 0b                	je     803bb4 <__udivdi3+0xf0>
  803ba9:	89 d8                	mov    %ebx,%eax
  803bab:	31 ff                	xor    %edi,%edi
  803bad:	e9 58 ff ff ff       	jmp    803b0a <__udivdi3+0x46>
  803bb2:	66 90                	xchg   %ax,%ax
  803bb4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bb8:	89 f9                	mov    %edi,%ecx
  803bba:	d3 e2                	shl    %cl,%edx
  803bbc:	39 c2                	cmp    %eax,%edx
  803bbe:	73 e9                	jae    803ba9 <__udivdi3+0xe5>
  803bc0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bc3:	31 ff                	xor    %edi,%edi
  803bc5:	e9 40 ff ff ff       	jmp    803b0a <__udivdi3+0x46>
  803bca:	66 90                	xchg   %ax,%ax
  803bcc:	31 c0                	xor    %eax,%eax
  803bce:	e9 37 ff ff ff       	jmp    803b0a <__udivdi3+0x46>
  803bd3:	90                   	nop

00803bd4 <__umoddi3>:
  803bd4:	55                   	push   %ebp
  803bd5:	57                   	push   %edi
  803bd6:	56                   	push   %esi
  803bd7:	53                   	push   %ebx
  803bd8:	83 ec 1c             	sub    $0x1c,%esp
  803bdb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bdf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803be3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803be7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803beb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803bef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bf3:	89 f3                	mov    %esi,%ebx
  803bf5:	89 fa                	mov    %edi,%edx
  803bf7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bfb:	89 34 24             	mov    %esi,(%esp)
  803bfe:	85 c0                	test   %eax,%eax
  803c00:	75 1a                	jne    803c1c <__umoddi3+0x48>
  803c02:	39 f7                	cmp    %esi,%edi
  803c04:	0f 86 a2 00 00 00    	jbe    803cac <__umoddi3+0xd8>
  803c0a:	89 c8                	mov    %ecx,%eax
  803c0c:	89 f2                	mov    %esi,%edx
  803c0e:	f7 f7                	div    %edi
  803c10:	89 d0                	mov    %edx,%eax
  803c12:	31 d2                	xor    %edx,%edx
  803c14:	83 c4 1c             	add    $0x1c,%esp
  803c17:	5b                   	pop    %ebx
  803c18:	5e                   	pop    %esi
  803c19:	5f                   	pop    %edi
  803c1a:	5d                   	pop    %ebp
  803c1b:	c3                   	ret    
  803c1c:	39 f0                	cmp    %esi,%eax
  803c1e:	0f 87 ac 00 00 00    	ja     803cd0 <__umoddi3+0xfc>
  803c24:	0f bd e8             	bsr    %eax,%ebp
  803c27:	83 f5 1f             	xor    $0x1f,%ebp
  803c2a:	0f 84 ac 00 00 00    	je     803cdc <__umoddi3+0x108>
  803c30:	bf 20 00 00 00       	mov    $0x20,%edi
  803c35:	29 ef                	sub    %ebp,%edi
  803c37:	89 fe                	mov    %edi,%esi
  803c39:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c3d:	89 e9                	mov    %ebp,%ecx
  803c3f:	d3 e0                	shl    %cl,%eax
  803c41:	89 d7                	mov    %edx,%edi
  803c43:	89 f1                	mov    %esi,%ecx
  803c45:	d3 ef                	shr    %cl,%edi
  803c47:	09 c7                	or     %eax,%edi
  803c49:	89 e9                	mov    %ebp,%ecx
  803c4b:	d3 e2                	shl    %cl,%edx
  803c4d:	89 14 24             	mov    %edx,(%esp)
  803c50:	89 d8                	mov    %ebx,%eax
  803c52:	d3 e0                	shl    %cl,%eax
  803c54:	89 c2                	mov    %eax,%edx
  803c56:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c5a:	d3 e0                	shl    %cl,%eax
  803c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c60:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c64:	89 f1                	mov    %esi,%ecx
  803c66:	d3 e8                	shr    %cl,%eax
  803c68:	09 d0                	or     %edx,%eax
  803c6a:	d3 eb                	shr    %cl,%ebx
  803c6c:	89 da                	mov    %ebx,%edx
  803c6e:	f7 f7                	div    %edi
  803c70:	89 d3                	mov    %edx,%ebx
  803c72:	f7 24 24             	mull   (%esp)
  803c75:	89 c6                	mov    %eax,%esi
  803c77:	89 d1                	mov    %edx,%ecx
  803c79:	39 d3                	cmp    %edx,%ebx
  803c7b:	0f 82 87 00 00 00    	jb     803d08 <__umoddi3+0x134>
  803c81:	0f 84 91 00 00 00    	je     803d18 <__umoddi3+0x144>
  803c87:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c8b:	29 f2                	sub    %esi,%edx
  803c8d:	19 cb                	sbb    %ecx,%ebx
  803c8f:	89 d8                	mov    %ebx,%eax
  803c91:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c95:	d3 e0                	shl    %cl,%eax
  803c97:	89 e9                	mov    %ebp,%ecx
  803c99:	d3 ea                	shr    %cl,%edx
  803c9b:	09 d0                	or     %edx,%eax
  803c9d:	89 e9                	mov    %ebp,%ecx
  803c9f:	d3 eb                	shr    %cl,%ebx
  803ca1:	89 da                	mov    %ebx,%edx
  803ca3:	83 c4 1c             	add    $0x1c,%esp
  803ca6:	5b                   	pop    %ebx
  803ca7:	5e                   	pop    %esi
  803ca8:	5f                   	pop    %edi
  803ca9:	5d                   	pop    %ebp
  803caa:	c3                   	ret    
  803cab:	90                   	nop
  803cac:	89 fd                	mov    %edi,%ebp
  803cae:	85 ff                	test   %edi,%edi
  803cb0:	75 0b                	jne    803cbd <__umoddi3+0xe9>
  803cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  803cb7:	31 d2                	xor    %edx,%edx
  803cb9:	f7 f7                	div    %edi
  803cbb:	89 c5                	mov    %eax,%ebp
  803cbd:	89 f0                	mov    %esi,%eax
  803cbf:	31 d2                	xor    %edx,%edx
  803cc1:	f7 f5                	div    %ebp
  803cc3:	89 c8                	mov    %ecx,%eax
  803cc5:	f7 f5                	div    %ebp
  803cc7:	89 d0                	mov    %edx,%eax
  803cc9:	e9 44 ff ff ff       	jmp    803c12 <__umoddi3+0x3e>
  803cce:	66 90                	xchg   %ax,%ax
  803cd0:	89 c8                	mov    %ecx,%eax
  803cd2:	89 f2                	mov    %esi,%edx
  803cd4:	83 c4 1c             	add    $0x1c,%esp
  803cd7:	5b                   	pop    %ebx
  803cd8:	5e                   	pop    %esi
  803cd9:	5f                   	pop    %edi
  803cda:	5d                   	pop    %ebp
  803cdb:	c3                   	ret    
  803cdc:	3b 04 24             	cmp    (%esp),%eax
  803cdf:	72 06                	jb     803ce7 <__umoddi3+0x113>
  803ce1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ce5:	77 0f                	ja     803cf6 <__umoddi3+0x122>
  803ce7:	89 f2                	mov    %esi,%edx
  803ce9:	29 f9                	sub    %edi,%ecx
  803ceb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803cef:	89 14 24             	mov    %edx,(%esp)
  803cf2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cf6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cfa:	8b 14 24             	mov    (%esp),%edx
  803cfd:	83 c4 1c             	add    $0x1c,%esp
  803d00:	5b                   	pop    %ebx
  803d01:	5e                   	pop    %esi
  803d02:	5f                   	pop    %edi
  803d03:	5d                   	pop    %ebp
  803d04:	c3                   	ret    
  803d05:	8d 76 00             	lea    0x0(%esi),%esi
  803d08:	2b 04 24             	sub    (%esp),%eax
  803d0b:	19 fa                	sbb    %edi,%edx
  803d0d:	89 d1                	mov    %edx,%ecx
  803d0f:	89 c6                	mov    %eax,%esi
  803d11:	e9 71 ff ff ff       	jmp    803c87 <__umoddi3+0xb3>
  803d16:	66 90                	xchg   %ax,%ax
  803d18:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d1c:	72 ea                	jb     803d08 <__umoddi3+0x134>
  803d1e:	89 d9                	mov    %ebx,%ecx
  803d20:	e9 62 ff ff ff       	jmp    803c87 <__umoddi3+0xb3>
