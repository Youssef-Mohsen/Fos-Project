
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
  800052:	68 40 1f 80 00       	push   $0x801f40
  800057:	e8 f7 0a 00 00       	call   800b53 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 4a 0f 00 00       	call   800fbc <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 f0 12 00 00       	call   801378 <malloc>
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
  8000db:	e8 c1 12 00 00       	call   8013a1 <free>
  8000e0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ec:	68 5e 1f 80 00       	push   $0x801f5e
  8000f1:	e8 f7 02 00 00       	call   8003ed <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 b5 17 00 00       	call   8018b3 <inctst>
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
  8001bb:	e8 b5 15 00 00       	call   801775 <sys_getenvindex>
  8001c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001c6:	89 d0                	mov    %edx,%eax
  8001c8:	c1 e0 02             	shl    $0x2,%eax
  8001cb:	01 d0                	add    %edx,%eax
  8001cd:	01 c0                	add    %eax,%eax
  8001cf:	01 d0                	add    %edx,%eax
  8001d1:	c1 e0 02             	shl    $0x2,%eax
  8001d4:	01 d0                	add    %edx,%eax
  8001d6:	01 c0                	add    %eax,%eax
  8001d8:	01 d0                	add    %edx,%eax
  8001da:	c1 e0 04             	shl    $0x4,%eax
  8001dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e2:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001e7:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ec:	8a 40 20             	mov    0x20(%eax),%al
  8001ef:	84 c0                	test   %al,%al
  8001f1:	74 0d                	je     800200 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  8001f3:	a1 04 30 80 00       	mov    0x803004,%eax
  8001f8:	83 c0 20             	add    $0x20,%eax
  8001fb:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800200:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800204:	7e 0a                	jle    800210 <libmain+0x5b>
		binaryname = argv[0];
  800206:	8b 45 0c             	mov    0xc(%ebp),%eax
  800209:	8b 00                	mov    (%eax),%eax
  80020b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800210:	83 ec 08             	sub    $0x8,%esp
  800213:	ff 75 0c             	pushl  0xc(%ebp)
  800216:	ff 75 08             	pushl  0x8(%ebp)
  800219:	e8 1a fe ff ff       	call   800038 <_main>
  80021e:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800221:	e8 d3 12 00 00       	call   8014f9 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800226:	83 ec 0c             	sub    $0xc,%esp
  800229:	68 8c 1f 80 00       	push   $0x801f8c
  80022e:	e8 8d 01 00 00       	call   8003c0 <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800236:	a1 04 30 80 00       	mov    0x803004,%eax
  80023b:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  800241:	a1 04 30 80 00       	mov    0x803004,%eax
  800246:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	52                   	push   %edx
  800250:	50                   	push   %eax
  800251:	68 b4 1f 80 00       	push   $0x801fb4
  800256:	e8 65 01 00 00       	call   8003c0 <cprintf>
  80025b:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025e:	a1 04 30 80 00       	mov    0x803004,%eax
  800263:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  800269:	a1 04 30 80 00       	mov    0x803004,%eax
  80026e:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  800274:	a1 04 30 80 00       	mov    0x803004,%eax
  800279:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  80027f:	51                   	push   %ecx
  800280:	52                   	push   %edx
  800281:	50                   	push   %eax
  800282:	68 dc 1f 80 00       	push   $0x801fdc
  800287:	e8 34 01 00 00       	call   8003c0 <cprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028f:	a1 04 30 80 00       	mov    0x803004,%eax
  800294:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	50                   	push   %eax
  80029e:	68 34 20 80 00       	push   $0x802034
  8002a3:	e8 18 01 00 00       	call   8003c0 <cprintf>
  8002a8:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 8c 1f 80 00       	push   $0x801f8c
  8002b3:	e8 08 01 00 00       	call   8003c0 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002bb:	e8 53 12 00 00       	call   801513 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8002c0:	e8 19 00 00 00       	call   8002de <exit>
}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 00                	push   $0x0
  8002d3:	e8 69 14 00 00       	call   801741 <sys_destroy_env>
  8002d8:	83 c4 10             	add    $0x10,%esp
}
  8002db:	90                   	nop
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <exit>:

void
exit(void)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e4:	e8 be 14 00 00       	call   8017a7 <sys_exit_env>
}
  8002e9:	90                   	nop
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f5:	8b 00                	mov    (%eax),%eax
  8002f7:	8d 48 01             	lea    0x1(%eax),%ecx
  8002fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002fd:	89 0a                	mov    %ecx,(%edx)
  8002ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800302:	88 d1                	mov    %dl,%cl
  800304:	8b 55 0c             	mov    0xc(%ebp),%edx
  800307:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80030b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030e:	8b 00                	mov    (%eax),%eax
  800310:	3d ff 00 00 00       	cmp    $0xff,%eax
  800315:	75 2c                	jne    800343 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800317:	a0 08 30 80 00       	mov    0x803008,%al
  80031c:	0f b6 c0             	movzbl %al,%eax
  80031f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800322:	8b 12                	mov    (%edx),%edx
  800324:	89 d1                	mov    %edx,%ecx
  800326:	8b 55 0c             	mov    0xc(%ebp),%edx
  800329:	83 c2 08             	add    $0x8,%edx
  80032c:	83 ec 04             	sub    $0x4,%esp
  80032f:	50                   	push   %eax
  800330:	51                   	push   %ecx
  800331:	52                   	push   %edx
  800332:	e8 80 11 00 00       	call   8014b7 <sys_cputs>
  800337:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80033a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8b 40 04             	mov    0x4(%eax),%eax
  800349:	8d 50 01             	lea    0x1(%eax),%edx
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800352:	90                   	nop
  800353:	c9                   	leave  
  800354:	c3                   	ret    

00800355 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80035e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800365:	00 00 00 
	b.cnt = 0;
  800368:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80036f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800372:	ff 75 0c             	pushl  0xc(%ebp)
  800375:	ff 75 08             	pushl  0x8(%ebp)
  800378:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80037e:	50                   	push   %eax
  80037f:	68 ec 02 80 00       	push   $0x8002ec
  800384:	e8 11 02 00 00       	call   80059a <vprintfmt>
  800389:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80038c:	a0 08 30 80 00       	mov    0x803008,%al
  800391:	0f b6 c0             	movzbl %al,%eax
  800394:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80039a:	83 ec 04             	sub    $0x4,%esp
  80039d:	50                   	push   %eax
  80039e:	52                   	push   %edx
  80039f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003a5:	83 c0 08             	add    $0x8,%eax
  8003a8:	50                   	push   %eax
  8003a9:	e8 09 11 00 00       	call   8014b7 <sys_cputs>
  8003ae:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003b1:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8003b8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003be:	c9                   	leave  
  8003bf:	c3                   	ret    

008003c0 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003c6:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8003cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8003dc:	50                   	push   %eax
  8003dd:	e8 73 ff ff ff       	call   800355 <vcprintf>
  8003e2:	83 c4 10             	add    $0x10,%esp
  8003e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003eb:	c9                   	leave  
  8003ec:	c3                   	ret    

008003ed <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003f3:	e8 01 11 00 00       	call   8014f9 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003f8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	83 ec 08             	sub    $0x8,%esp
  800404:	ff 75 f4             	pushl  -0xc(%ebp)
  800407:	50                   	push   %eax
  800408:	e8 48 ff ff ff       	call   800355 <vcprintf>
  80040d:	83 c4 10             	add    $0x10,%esp
  800410:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800413:	e8 fb 10 00 00       	call   801513 <sys_unlock_cons>
	return cnt;
  800418:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80041b:	c9                   	leave  
  80041c:	c3                   	ret    

0080041d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80041d:	55                   	push   %ebp
  80041e:	89 e5                	mov    %esp,%ebp
  800420:	53                   	push   %ebx
  800421:	83 ec 14             	sub    $0x14,%esp
  800424:	8b 45 10             	mov    0x10(%ebp),%eax
  800427:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80042a:	8b 45 14             	mov    0x14(%ebp),%eax
  80042d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800430:	8b 45 18             	mov    0x18(%ebp),%eax
  800433:	ba 00 00 00 00       	mov    $0x0,%edx
  800438:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80043b:	77 55                	ja     800492 <printnum+0x75>
  80043d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800440:	72 05                	jb     800447 <printnum+0x2a>
  800442:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800445:	77 4b                	ja     800492 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800447:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80044a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80044d:	8b 45 18             	mov    0x18(%ebp),%eax
  800450:	ba 00 00 00 00       	mov    $0x0,%edx
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	ff 75 f4             	pushl  -0xc(%ebp)
  80045a:	ff 75 f0             	pushl  -0x10(%ebp)
  80045d:	e8 7a 18 00 00       	call   801cdc <__udivdi3>
  800462:	83 c4 10             	add    $0x10,%esp
  800465:	83 ec 04             	sub    $0x4,%esp
  800468:	ff 75 20             	pushl  0x20(%ebp)
  80046b:	53                   	push   %ebx
  80046c:	ff 75 18             	pushl  0x18(%ebp)
  80046f:	52                   	push   %edx
  800470:	50                   	push   %eax
  800471:	ff 75 0c             	pushl  0xc(%ebp)
  800474:	ff 75 08             	pushl  0x8(%ebp)
  800477:	e8 a1 ff ff ff       	call   80041d <printnum>
  80047c:	83 c4 20             	add    $0x20,%esp
  80047f:	eb 1a                	jmp    80049b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 0c             	pushl  0xc(%ebp)
  800487:	ff 75 20             	pushl  0x20(%ebp)
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	ff d0                	call   *%eax
  80048f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800492:	ff 4d 1c             	decl   0x1c(%ebp)
  800495:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800499:	7f e6                	jg     800481 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80049b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80049e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004a9:	53                   	push   %ebx
  8004aa:	51                   	push   %ecx
  8004ab:	52                   	push   %edx
  8004ac:	50                   	push   %eax
  8004ad:	e8 3a 19 00 00       	call   801dec <__umoddi3>
  8004b2:	83 c4 10             	add    $0x10,%esp
  8004b5:	05 74 22 80 00       	add    $0x802274,%eax
  8004ba:	8a 00                	mov    (%eax),%al
  8004bc:	0f be c0             	movsbl %al,%eax
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	ff 75 0c             	pushl  0xc(%ebp)
  8004c5:	50                   	push   %eax
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c9:	ff d0                	call   *%eax
  8004cb:	83 c4 10             	add    $0x10,%esp
}
  8004ce:	90                   	nop
  8004cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d2:	c9                   	leave  
  8004d3:	c3                   	ret    

008004d4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004d7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004db:	7e 1c                	jle    8004f9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	8d 50 08             	lea    0x8(%eax),%edx
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	89 10                	mov    %edx,(%eax)
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	83 e8 08             	sub    $0x8,%eax
  8004f2:	8b 50 04             	mov    0x4(%eax),%edx
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	eb 40                	jmp    800539 <getuint+0x65>
	else if (lflag)
  8004f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004fd:	74 1e                	je     80051d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 50 04             	lea    0x4(%eax),%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	83 e8 04             	sub    $0x4,%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	ba 00 00 00 00       	mov    $0x0,%edx
  80051b:	eb 1c                	jmp    800539 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	8b 00                	mov    (%eax),%eax
  800522:	8d 50 04             	lea    0x4(%eax),%edx
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	89 10                	mov    %edx,(%eax)
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	83 e8 04             	sub    $0x4,%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800539:	5d                   	pop    %ebp
  80053a:	c3                   	ret    

0080053b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80053b:	55                   	push   %ebp
  80053c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80053e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800542:	7e 1c                	jle    800560 <getint+0x25>
		return va_arg(*ap, long long);
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	8d 50 08             	lea    0x8(%eax),%edx
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	89 10                	mov    %edx,(%eax)
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	83 e8 08             	sub    $0x8,%eax
  800559:	8b 50 04             	mov    0x4(%eax),%edx
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	eb 38                	jmp    800598 <getint+0x5d>
	else if (lflag)
  800560:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800564:	74 1a                	je     800580 <getint+0x45>
		return va_arg(*ap, long);
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	8b 00                	mov    (%eax),%eax
  80056b:	8d 50 04             	lea    0x4(%eax),%edx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	89 10                	mov    %edx,(%eax)
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	8b 00                	mov    (%eax),%eax
  800578:	83 e8 04             	sub    $0x4,%eax
  80057b:	8b 00                	mov    (%eax),%eax
  80057d:	99                   	cltd   
  80057e:	eb 18                	jmp    800598 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	8d 50 04             	lea    0x4(%eax),%edx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	89 10                	mov    %edx,(%eax)
  80058d:	8b 45 08             	mov    0x8(%ebp),%eax
  800590:	8b 00                	mov    (%eax),%eax
  800592:	83 e8 04             	sub    $0x4,%eax
  800595:	8b 00                	mov    (%eax),%eax
  800597:	99                   	cltd   
}
  800598:	5d                   	pop    %ebp
  800599:	c3                   	ret    

0080059a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80059a:	55                   	push   %ebp
  80059b:	89 e5                	mov    %esp,%ebp
  80059d:	56                   	push   %esi
  80059e:	53                   	push   %ebx
  80059f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005a2:	eb 17                	jmp    8005bb <vprintfmt+0x21>
			if (ch == '\0')
  8005a4:	85 db                	test   %ebx,%ebx
  8005a6:	0f 84 c1 03 00 00    	je     80096d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	ff 75 0c             	pushl  0xc(%ebp)
  8005b2:	53                   	push   %ebx
  8005b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b6:	ff d0                	call   *%eax
  8005b8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8005be:	8d 50 01             	lea    0x1(%eax),%edx
  8005c1:	89 55 10             	mov    %edx,0x10(%ebp)
  8005c4:	8a 00                	mov    (%eax),%al
  8005c6:	0f b6 d8             	movzbl %al,%ebx
  8005c9:	83 fb 25             	cmp    $0x25,%ebx
  8005cc:	75 d6                	jne    8005a4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005ce:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005d2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005d9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005e7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f1:	8d 50 01             	lea    0x1(%eax),%edx
  8005f4:	89 55 10             	mov    %edx,0x10(%ebp)
  8005f7:	8a 00                	mov    (%eax),%al
  8005f9:	0f b6 d8             	movzbl %al,%ebx
  8005fc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005ff:	83 f8 5b             	cmp    $0x5b,%eax
  800602:	0f 87 3d 03 00 00    	ja     800945 <vprintfmt+0x3ab>
  800608:	8b 04 85 98 22 80 00 	mov    0x802298(,%eax,4),%eax
  80060f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800611:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800615:	eb d7                	jmp    8005ee <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800617:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80061b:	eb d1                	jmp    8005ee <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80061d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800624:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800627:	89 d0                	mov    %edx,%eax
  800629:	c1 e0 02             	shl    $0x2,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	01 d8                	add    %ebx,%eax
  800632:	83 e8 30             	sub    $0x30,%eax
  800635:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800638:	8b 45 10             	mov    0x10(%ebp),%eax
  80063b:	8a 00                	mov    (%eax),%al
  80063d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800640:	83 fb 2f             	cmp    $0x2f,%ebx
  800643:	7e 3e                	jle    800683 <vprintfmt+0xe9>
  800645:	83 fb 39             	cmp    $0x39,%ebx
  800648:	7f 39                	jg     800683 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80064a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80064d:	eb d5                	jmp    800624 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	83 c0 04             	add    $0x4,%eax
  800655:	89 45 14             	mov    %eax,0x14(%ebp)
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	83 e8 04             	sub    $0x4,%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800663:	eb 1f                	jmp    800684 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800665:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800669:	79 83                	jns    8005ee <vprintfmt+0x54>
				width = 0;
  80066b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800672:	e9 77 ff ff ff       	jmp    8005ee <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800677:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80067e:	e9 6b ff ff ff       	jmp    8005ee <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800683:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800684:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800688:	0f 89 60 ff ff ff    	jns    8005ee <vprintfmt+0x54>
				width = precision, precision = -1;
  80068e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800691:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800694:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80069b:	e9 4e ff ff ff       	jmp    8005ee <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006a0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006a3:	e9 46 ff ff ff       	jmp    8005ee <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	83 c0 04             	add    $0x4,%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	83 e8 04             	sub    $0x4,%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	83 ec 08             	sub    $0x8,%esp
  8006bc:	ff 75 0c             	pushl  0xc(%ebp)
  8006bf:	50                   	push   %eax
  8006c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c3:	ff d0                	call   *%eax
  8006c5:	83 c4 10             	add    $0x10,%esp
			break;
  8006c8:	e9 9b 02 00 00       	jmp    800968 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	83 c0 04             	add    $0x4,%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006de:	85 db                	test   %ebx,%ebx
  8006e0:	79 02                	jns    8006e4 <vprintfmt+0x14a>
				err = -err;
  8006e2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006e4:	83 fb 64             	cmp    $0x64,%ebx
  8006e7:	7f 0b                	jg     8006f4 <vprintfmt+0x15a>
  8006e9:	8b 34 9d e0 20 80 00 	mov    0x8020e0(,%ebx,4),%esi
  8006f0:	85 f6                	test   %esi,%esi
  8006f2:	75 19                	jne    80070d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006f4:	53                   	push   %ebx
  8006f5:	68 85 22 80 00       	push   $0x802285
  8006fa:	ff 75 0c             	pushl  0xc(%ebp)
  8006fd:	ff 75 08             	pushl  0x8(%ebp)
  800700:	e8 70 02 00 00       	call   800975 <printfmt>
  800705:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800708:	e9 5b 02 00 00       	jmp    800968 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80070d:	56                   	push   %esi
  80070e:	68 8e 22 80 00       	push   $0x80228e
  800713:	ff 75 0c             	pushl  0xc(%ebp)
  800716:	ff 75 08             	pushl  0x8(%ebp)
  800719:	e8 57 02 00 00       	call   800975 <printfmt>
  80071e:	83 c4 10             	add    $0x10,%esp
			break;
  800721:	e9 42 02 00 00       	jmp    800968 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	83 c0 04             	add    $0x4,%eax
  80072c:	89 45 14             	mov    %eax,0x14(%ebp)
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	83 e8 04             	sub    $0x4,%eax
  800735:	8b 30                	mov    (%eax),%esi
  800737:	85 f6                	test   %esi,%esi
  800739:	75 05                	jne    800740 <vprintfmt+0x1a6>
				p = "(null)";
  80073b:	be 91 22 80 00       	mov    $0x802291,%esi
			if (width > 0 && padc != '-')
  800740:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800744:	7e 6d                	jle    8007b3 <vprintfmt+0x219>
  800746:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80074a:	74 67                	je     8007b3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80074c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80074f:	83 ec 08             	sub    $0x8,%esp
  800752:	50                   	push   %eax
  800753:	56                   	push   %esi
  800754:	e8 26 05 00 00       	call   800c7f <strnlen>
  800759:	83 c4 10             	add    $0x10,%esp
  80075c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80075f:	eb 16                	jmp    800777 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800761:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	50                   	push   %eax
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	ff d0                	call   *%eax
  800771:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800774:	ff 4d e4             	decl   -0x1c(%ebp)
  800777:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077b:	7f e4                	jg     800761 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80077d:	eb 34                	jmp    8007b3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80077f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800783:	74 1c                	je     8007a1 <vprintfmt+0x207>
  800785:	83 fb 1f             	cmp    $0x1f,%ebx
  800788:	7e 05                	jle    80078f <vprintfmt+0x1f5>
  80078a:	83 fb 7e             	cmp    $0x7e,%ebx
  80078d:	7e 12                	jle    8007a1 <vprintfmt+0x207>
					putch('?', putdat);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	6a 3f                	push   $0x3f
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	ff d0                	call   *%eax
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	eb 0f                	jmp    8007b0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	53                   	push   %ebx
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	ff d0                	call   *%eax
  8007ad:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007b0:	ff 4d e4             	decl   -0x1c(%ebp)
  8007b3:	89 f0                	mov    %esi,%eax
  8007b5:	8d 70 01             	lea    0x1(%eax),%esi
  8007b8:	8a 00                	mov    (%eax),%al
  8007ba:	0f be d8             	movsbl %al,%ebx
  8007bd:	85 db                	test   %ebx,%ebx
  8007bf:	74 24                	je     8007e5 <vprintfmt+0x24b>
  8007c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007c5:	78 b8                	js     80077f <vprintfmt+0x1e5>
  8007c7:	ff 4d e0             	decl   -0x20(%ebp)
  8007ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007ce:	79 af                	jns    80077f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007d0:	eb 13                	jmp    8007e5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	ff 75 0c             	pushl  0xc(%ebp)
  8007d8:	6a 20                	push   $0x20
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	ff d0                	call   *%eax
  8007df:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007e2:	ff 4d e4             	decl   -0x1c(%ebp)
  8007e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007e9:	7f e7                	jg     8007d2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007eb:	e9 78 01 00 00       	jmp    800968 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8007f6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f9:	50                   	push   %eax
  8007fa:	e8 3c fd ff ff       	call   80053b <getint>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800805:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80080e:	85 d2                	test   %edx,%edx
  800810:	79 23                	jns    800835 <vprintfmt+0x29b>
				putch('-', putdat);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	6a 2d                	push   $0x2d
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	ff d0                	call   *%eax
  80081f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800825:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800828:	f7 d8                	neg    %eax
  80082a:	83 d2 00             	adc    $0x0,%edx
  80082d:	f7 da                	neg    %edx
  80082f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800832:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800835:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80083c:	e9 bc 00 00 00       	jmp    8008fd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 e8             	pushl  -0x18(%ebp)
  800847:	8d 45 14             	lea    0x14(%ebp),%eax
  80084a:	50                   	push   %eax
  80084b:	e8 84 fc ff ff       	call   8004d4 <getuint>
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800856:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800859:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800860:	e9 98 00 00 00       	jmp    8008fd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	6a 58                	push   $0x58
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	6a 58                	push   $0x58
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	ff d0                	call   *%eax
  800882:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	ff 75 0c             	pushl  0xc(%ebp)
  80088b:	6a 58                	push   $0x58
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	ff d0                	call   *%eax
  800892:	83 c4 10             	add    $0x10,%esp
			break;
  800895:	e9 ce 00 00 00       	jmp    800968 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	6a 30                	push   $0x30
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	ff d0                	call   *%eax
  8008a7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	6a 78                	push   $0x78
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	ff d0                	call   *%eax
  8008b7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 c0 04             	add    $0x4,%eax
  8008c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	83 e8 04             	sub    $0x4,%eax
  8008c9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008dc:	eb 1f                	jmp    8008fd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e7:	50                   	push   %eax
  8008e8:	e8 e7 fb ff ff       	call   8004d4 <getuint>
  8008ed:	83 c4 10             	add    $0x10,%esp
  8008f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008f6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008fd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800904:	83 ec 04             	sub    $0x4,%esp
  800907:	52                   	push   %edx
  800908:	ff 75 e4             	pushl  -0x1c(%ebp)
  80090b:	50                   	push   %eax
  80090c:	ff 75 f4             	pushl  -0xc(%ebp)
  80090f:	ff 75 f0             	pushl  -0x10(%ebp)
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	ff 75 08             	pushl  0x8(%ebp)
  800918:	e8 00 fb ff ff       	call   80041d <printnum>
  80091d:	83 c4 20             	add    $0x20,%esp
			break;
  800920:	eb 46                	jmp    800968 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	53                   	push   %ebx
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
			break;
  800931:	eb 35                	jmp    800968 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800933:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  80093a:	eb 2c                	jmp    800968 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80093c:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800943:	eb 23                	jmp    800968 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 25                	push   $0x25
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800955:	ff 4d 10             	decl   0x10(%ebp)
  800958:	eb 03                	jmp    80095d <vprintfmt+0x3c3>
  80095a:	ff 4d 10             	decl   0x10(%ebp)
  80095d:	8b 45 10             	mov    0x10(%ebp),%eax
  800960:	48                   	dec    %eax
  800961:	8a 00                	mov    (%eax),%al
  800963:	3c 25                	cmp    $0x25,%al
  800965:	75 f3                	jne    80095a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800967:	90                   	nop
		}
	}
  800968:	e9 35 fc ff ff       	jmp    8005a2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80096d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80096e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800971:	5b                   	pop    %ebx
  800972:	5e                   	pop    %esi
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80097b:	8d 45 10             	lea    0x10(%ebp),%eax
  80097e:	83 c0 04             	add    $0x4,%eax
  800981:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800984:	8b 45 10             	mov    0x10(%ebp),%eax
  800987:	ff 75 f4             	pushl  -0xc(%ebp)
  80098a:	50                   	push   %eax
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	ff 75 08             	pushl  0x8(%ebp)
  800991:	e8 04 fc ff ff       	call   80059a <vprintfmt>
  800996:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800999:	90                   	nop
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80099f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a2:	8b 40 08             	mov    0x8(%eax),%eax
  8009a5:	8d 50 01             	lea    0x1(%eax),%edx
  8009a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	8b 10                	mov    (%eax),%edx
  8009b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b6:	8b 40 04             	mov    0x4(%eax),%eax
  8009b9:	39 c2                	cmp    %eax,%edx
  8009bb:	73 12                	jae    8009cf <sprintputch+0x33>
		*b->buf++ = ch;
  8009bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	8d 48 01             	lea    0x1(%eax),%ecx
  8009c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c8:	89 0a                	mov    %ecx,(%edx)
  8009ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8009cd:	88 10                	mov    %dl,(%eax)
}
  8009cf:	90                   	nop
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	01 d0                	add    %edx,%eax
  8009e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009f7:	74 06                	je     8009ff <vsnprintf+0x2d>
  8009f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009fd:	7f 07                	jg     800a06 <vsnprintf+0x34>
		return -E_INVAL;
  8009ff:	b8 03 00 00 00       	mov    $0x3,%eax
  800a04:	eb 20                	jmp    800a26 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a06:	ff 75 14             	pushl  0x14(%ebp)
  800a09:	ff 75 10             	pushl  0x10(%ebp)
  800a0c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	68 9c 09 80 00       	push   $0x80099c
  800a15:	e8 80 fb ff ff       	call   80059a <vprintfmt>
  800a1a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a20:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a26:	c9                   	leave  
  800a27:	c3                   	ret    

00800a28 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800a31:	83 c0 04             	add    $0x4,%eax
  800a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a37:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a3d:	50                   	push   %eax
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	ff 75 08             	pushl  0x8(%ebp)
  800a44:	e8 89 ff ff ff       	call   8009d2 <vsnprintf>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a52:	c9                   	leave  
  800a53:	c3                   	ret    

00800a54 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a5e:	74 13                	je     800a73 <readline+0x1f>
		cprintf("%s", prompt);
  800a60:	83 ec 08             	sub    $0x8,%esp
  800a63:	ff 75 08             	pushl  0x8(%ebp)
  800a66:	68 08 24 80 00       	push   $0x802408
  800a6b:	e8 50 f9 ff ff       	call   8003c0 <cprintf>
  800a70:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a7a:	83 ec 0c             	sub    $0xc,%esp
  800a7d:	6a 00                	push   $0x0
  800a7f:	e8 63 10 00 00       	call   801ae7 <iscons>
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a8a:	e8 45 10 00 00       	call   801ad4 <getchar>
  800a8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a96:	79 22                	jns    800aba <readline+0x66>
			if (c != -E_EOF)
  800a98:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800a9c:	0f 84 ad 00 00 00    	je     800b4f <readline+0xfb>
				cprintf("read error: %e\n", c);
  800aa2:	83 ec 08             	sub    $0x8,%esp
  800aa5:	ff 75 ec             	pushl  -0x14(%ebp)
  800aa8:	68 0b 24 80 00       	push   $0x80240b
  800aad:	e8 0e f9 ff ff       	call   8003c0 <cprintf>
  800ab2:	83 c4 10             	add    $0x10,%esp
			break;
  800ab5:	e9 95 00 00 00       	jmp    800b4f <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800aba:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800abe:	7e 34                	jle    800af4 <readline+0xa0>
  800ac0:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ac7:	7f 2b                	jg     800af4 <readline+0xa0>
			if (echoing)
  800ac9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800acd:	74 0e                	je     800add <readline+0x89>
				cputchar(c);
  800acf:	83 ec 0c             	sub    $0xc,%esp
  800ad2:	ff 75 ec             	pushl  -0x14(%ebp)
  800ad5:	e8 db 0f 00 00       	call   801ab5 <cputchar>
  800ada:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae0:	8d 50 01             	lea    0x1(%eax),%edx
  800ae3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800ae6:	89 c2                	mov    %eax,%edx
  800ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aeb:	01 d0                	add    %edx,%eax
  800aed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800af0:	88 10                	mov    %dl,(%eax)
  800af2:	eb 56                	jmp    800b4a <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800af4:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800af8:	75 1f                	jne    800b19 <readline+0xc5>
  800afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800afe:	7e 19                	jle    800b19 <readline+0xc5>
			if (echoing)
  800b00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b04:	74 0e                	je     800b14 <readline+0xc0>
				cputchar(c);
  800b06:	83 ec 0c             	sub    $0xc,%esp
  800b09:	ff 75 ec             	pushl  -0x14(%ebp)
  800b0c:	e8 a4 0f 00 00       	call   801ab5 <cputchar>
  800b11:	83 c4 10             	add    $0x10,%esp

			i--;
  800b14:	ff 4d f4             	decl   -0xc(%ebp)
  800b17:	eb 31                	jmp    800b4a <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b19:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b1d:	74 0a                	je     800b29 <readline+0xd5>
  800b1f:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b23:	0f 85 61 ff ff ff    	jne    800a8a <readline+0x36>
			if (echoing)
  800b29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b2d:	74 0e                	je     800b3d <readline+0xe9>
				cputchar(c);
  800b2f:	83 ec 0c             	sub    $0xc,%esp
  800b32:	ff 75 ec             	pushl  -0x14(%ebp)
  800b35:	e8 7b 0f 00 00       	call   801ab5 <cputchar>
  800b3a:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	01 d0                	add    %edx,%eax
  800b45:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b48:	eb 06                	jmp    800b50 <readline+0xfc>
		}
	}
  800b4a:	e9 3b ff ff ff       	jmp    800a8a <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b4f:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b50:	90                   	nop
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b59:	e8 9b 09 00 00       	call   8014f9 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b62:	74 13                	je     800b77 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b64:	83 ec 08             	sub    $0x8,%esp
  800b67:	ff 75 08             	pushl  0x8(%ebp)
  800b6a:	68 08 24 80 00       	push   $0x802408
  800b6f:	e8 4c f8 ff ff       	call   8003c0 <cprintf>
  800b74:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	6a 00                	push   $0x0
  800b83:	e8 5f 0f 00 00       	call   801ae7 <iscons>
  800b88:	83 c4 10             	add    $0x10,%esp
  800b8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800b8e:	e8 41 0f 00 00       	call   801ad4 <getchar>
  800b93:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800b96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b9a:	79 22                	jns    800bbe <atomic_readline+0x6b>
				if (c != -E_EOF)
  800b9c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ba0:	0f 84 ad 00 00 00    	je     800c53 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 ec             	pushl  -0x14(%ebp)
  800bac:	68 0b 24 80 00       	push   $0x80240b
  800bb1:	e8 0a f8 ff ff       	call   8003c0 <cprintf>
  800bb6:	83 c4 10             	add    $0x10,%esp
				break;
  800bb9:	e9 95 00 00 00       	jmp    800c53 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bbe:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800bc2:	7e 34                	jle    800bf8 <atomic_readline+0xa5>
  800bc4:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800bcb:	7f 2b                	jg     800bf8 <atomic_readline+0xa5>
				if (echoing)
  800bcd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800bd1:	74 0e                	je     800be1 <atomic_readline+0x8e>
					cputchar(c);
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	ff 75 ec             	pushl  -0x14(%ebp)
  800bd9:	e8 d7 0e 00 00       	call   801ab5 <cputchar>
  800bde:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800be4:	8d 50 01             	lea    0x1(%eax),%edx
  800be7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800bea:	89 c2                	mov    %eax,%edx
  800bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800bf4:	88 10                	mov    %dl,(%eax)
  800bf6:	eb 56                	jmp    800c4e <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800bf8:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800bfc:	75 1f                	jne    800c1d <atomic_readline+0xca>
  800bfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c02:	7e 19                	jle    800c1d <atomic_readline+0xca>
				if (echoing)
  800c04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c08:	74 0e                	je     800c18 <atomic_readline+0xc5>
					cputchar(c);
  800c0a:	83 ec 0c             	sub    $0xc,%esp
  800c0d:	ff 75 ec             	pushl  -0x14(%ebp)
  800c10:	e8 a0 0e 00 00       	call   801ab5 <cputchar>
  800c15:	83 c4 10             	add    $0x10,%esp
				i--;
  800c18:	ff 4d f4             	decl   -0xc(%ebp)
  800c1b:	eb 31                	jmp    800c4e <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c1d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c21:	74 0a                	je     800c2d <atomic_readline+0xda>
  800c23:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c27:	0f 85 61 ff ff ff    	jne    800b8e <atomic_readline+0x3b>
				if (echoing)
  800c2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c31:	74 0e                	je     800c41 <atomic_readline+0xee>
					cputchar(c);
  800c33:	83 ec 0c             	sub    $0xc,%esp
  800c36:	ff 75 ec             	pushl  -0x14(%ebp)
  800c39:	e8 77 0e 00 00       	call   801ab5 <cputchar>
  800c3e:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c47:	01 d0                	add    %edx,%eax
  800c49:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c4c:	eb 06                	jmp    800c54 <atomic_readline+0x101>
			}
		}
  800c4e:	e9 3b ff ff ff       	jmp    800b8e <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c53:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c54:	e8 ba 08 00 00       	call   801513 <sys_unlock_cons>
}
  800c59:	90                   	nop
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c69:	eb 06                	jmp    800c71 <strlen+0x15>
		n++;
  800c6b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6e:	ff 45 08             	incl   0x8(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	84 c0                	test   %al,%al
  800c78:	75 f1                	jne    800c6b <strlen+0xf>
		n++;
	return n;
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 09                	jmp    800c97 <strnlen+0x18>
		n++;
  800c8e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c91:	ff 45 08             	incl   0x8(%ebp)
  800c94:	ff 4d 0c             	decl   0xc(%ebp)
  800c97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9b:	74 09                	je     800ca6 <strnlen+0x27>
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	75 e8                	jne    800c8e <strnlen+0xf>
		n++;
	return n;
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb7:	90                   	nop
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8d 50 01             	lea    0x1(%eax),%edx
  800cbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cca:	8a 12                	mov    (%edx),%dl
  800ccc:	88 10                	mov    %dl,(%eax)
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	75 e4                	jne    800cb8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cec:	eb 1f                	jmp    800d0d <strncpy+0x34>
		*dst++ = *src;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8d 50 01             	lea    0x1(%eax),%edx
  800cf4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfa:	8a 12                	mov    (%edx),%dl
  800cfc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	74 03                	je     800d0a <strncpy+0x31>
			src++;
  800d07:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0a:	ff 45 fc             	incl   -0x4(%ebp)
  800d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d10:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d13:	72 d9                	jb     800cee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d15:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	74 30                	je     800d5c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d2c:	eb 16                	jmp    800d44 <strlcpy+0x2a>
			*dst++ = *src++;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8d 50 01             	lea    0x1(%eax),%edx
  800d34:	89 55 08             	mov    %edx,0x8(%ebp)
  800d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d40:	8a 12                	mov    (%edx),%dl
  800d42:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4b:	74 09                	je     800d56 <strlcpy+0x3c>
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	84 c0                	test   %al,%al
  800d54:	75 d8                	jne    800d2e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d62:	29 c2                	sub    %eax,%edx
  800d64:	89 d0                	mov    %edx,%eax
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d6b:	eb 06                	jmp    800d73 <strcmp+0xb>
		p++, q++;
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	74 0e                	je     800d8a <strcmp+0x22>
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 10                	mov    (%eax),%dl
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	38 c2                	cmp    %al,%dl
  800d88:	74 e3                	je     800d6d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f b6 d0             	movzbl %al,%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	0f b6 c0             	movzbl %al,%eax
  800d9a:	29 c2                	sub    %eax,%edx
  800d9c:	89 d0                	mov    %edx,%eax
}
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da3:	eb 09                	jmp    800dae <strncmp+0xe>
		n--, p++, q++;
  800da5:	ff 4d 10             	decl   0x10(%ebp)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db2:	74 17                	je     800dcb <strncmp+0x2b>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	74 0e                	je     800dcb <strncmp+0x2b>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 10                	mov    (%eax),%dl
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	38 c2                	cmp    %al,%dl
  800dc9:	74 da                	je     800da5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcf:	75 07                	jne    800dd8 <strncmp+0x38>
		return 0;
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd6:	eb 14                	jmp    800dec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 c0             	movzbl %al,%eax
  800de8:	29 c2                	sub    %eax,%edx
  800dea:	89 d0                	mov    %edx,%eax
}
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfa:	eb 12                	jmp    800e0e <strchr+0x20>
		if (*s == c)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e04:	75 05                	jne    800e0b <strchr+0x1d>
			return (char *) s;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	eb 11                	jmp    800e1c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 e5                	jne    800dfc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 04             	sub    $0x4,%esp
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2a:	eb 0d                	jmp    800e39 <strfind+0x1b>
		if (*s == c)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e34:	74 0e                	je     800e44 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 ea                	jne    800e2c <strfind+0xe>
  800e42:	eb 01                	jmp    800e45 <strfind+0x27>
		if (*s == c)
			break;
  800e44:	90                   	nop
	return (char *) s;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e5c:	eb 0e                	jmp    800e6c <memset+0x22>
		*p++ = c;
  800e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e61:	8d 50 01             	lea    0x1(%eax),%edx
  800e64:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e6c:	ff 4d f8             	decl   -0x8(%ebp)
  800e6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e73:	79 e9                	jns    800e5e <memset+0x14>
		*p++ = c;

	return v;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e8c:	eb 16                	jmp    800ea4 <memcpy+0x2a>
		*d++ = *s++;
  800e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea0:	8a 12                	mov    (%edx),%dl
  800ea2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 dd                	jne    800e8e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ece:	73 50                	jae    800f20 <memmove+0x6a>
  800ed0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	01 d0                	add    %edx,%eax
  800ed8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edb:	76 43                	jbe    800f20 <memmove+0x6a>
		s += n;
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee9:	eb 10                	jmp    800efb <memmove+0x45>
			*--d = *--s;
  800eeb:	ff 4d f8             	decl   -0x8(%ebp)
  800eee:	ff 4d fc             	decl   -0x4(%ebp)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efb:	8b 45 10             	mov    0x10(%ebp),%eax
  800efe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f01:	89 55 10             	mov    %edx,0x10(%ebp)
  800f04:	85 c0                	test   %eax,%eax
  800f06:	75 e3                	jne    800eeb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f08:	eb 23                	jmp    800f2d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1c:	8a 12                	mov    (%edx),%dl
  800f1e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f26:	89 55 10             	mov    %edx,0x10(%ebp)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	75 dd                	jne    800f0a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f44:	eb 2a                	jmp    800f70 <memcmp+0x3e>
		if (*s1 != *s2)
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	8a 10                	mov    (%eax),%dl
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	38 c2                	cmp    %al,%dl
  800f52:	74 16                	je     800f6a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f b6 d0             	movzbl %al,%edx
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 c0             	movzbl %al,%eax
  800f64:	29 c2                	sub    %eax,%edx
  800f66:	89 d0                	mov    %edx,%eax
  800f68:	eb 18                	jmp    800f82 <memcmp+0x50>
		s1++, s2++;
  800f6a:	ff 45 fc             	incl   -0x4(%ebp)
  800f6d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 c9                	jne    800f46 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 d0                	add    %edx,%eax
  800f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f95:	eb 15                	jmp    800fac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	0f b6 d0             	movzbl %al,%edx
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	0f b6 c0             	movzbl %al,%eax
  800fa5:	39 c2                	cmp    %eax,%edx
  800fa7:	74 0d                	je     800fb6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb2:	72 e3                	jb     800f97 <memfind+0x13>
  800fb4:	eb 01                	jmp    800fb7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb6:	90                   	nop
	return (void *) s;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd0:	eb 03                	jmp    800fd5 <strtol+0x19>
		s++;
  800fd2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 20                	cmp    $0x20,%al
  800fdc:	74 f4                	je     800fd2 <strtol+0x16>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 09                	cmp    $0x9,%al
  800fe5:	74 eb                	je     800fd2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 2b                	cmp    $0x2b,%al
  800fee:	75 05                	jne    800ff5 <strtol+0x39>
		s++;
  800ff0:	ff 45 08             	incl   0x8(%ebp)
  800ff3:	eb 13                	jmp    801008 <strtol+0x4c>
	else if (*s == '-')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 2d                	cmp    $0x2d,%al
  800ffc:	75 0a                	jne    801008 <strtol+0x4c>
		s++, neg = 1;
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100c:	74 06                	je     801014 <strtol+0x58>
  80100e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801012:	75 20                	jne    801034 <strtol+0x78>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 30                	cmp    $0x30,%al
  80101b:	75 17                	jne    801034 <strtol+0x78>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	40                   	inc    %eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 78                	cmp    $0x78,%al
  801025:	75 0d                	jne    801034 <strtol+0x78>
		s += 2, base = 16;
  801027:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801032:	eb 28                	jmp    80105c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801038:	75 15                	jne    80104f <strtol+0x93>
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 30                	cmp    $0x30,%al
  801041:	75 0c                	jne    80104f <strtol+0x93>
		s++, base = 8;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104d:	eb 0d                	jmp    80105c <strtol+0xa0>
	else if (base == 0)
  80104f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801053:	75 07                	jne    80105c <strtol+0xa0>
		base = 10;
  801055:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 2f                	cmp    $0x2f,%al
  801063:	7e 19                	jle    80107e <strtol+0xc2>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 39                	cmp    $0x39,%al
  80106c:	7f 10                	jg     80107e <strtol+0xc2>
			dig = *s - '0';
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	0f be c0             	movsbl %al,%eax
  801076:	83 e8 30             	sub    $0x30,%eax
  801079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107c:	eb 42                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 60                	cmp    $0x60,%al
  801085:	7e 19                	jle    8010a0 <strtol+0xe4>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 7a                	cmp    $0x7a,%al
  80108e:	7f 10                	jg     8010a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	0f be c0             	movsbl %al,%eax
  801098:	83 e8 57             	sub    $0x57,%eax
  80109b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109e:	eb 20                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 40                	cmp    $0x40,%al
  8010a7:	7e 39                	jle    8010e2 <strtol+0x126>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 5a                	cmp    $0x5a,%al
  8010b0:	7f 30                	jg     8010e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 37             	sub    $0x37,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c6:	7d 19                	jge    8010e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c8:	ff 45 08             	incl   0x8(%ebp)
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010dc:	e9 7b ff ff ff       	jmp    80105c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e6:	74 08                	je     8010f0 <strtol+0x134>
		*endptr = (char *) s;
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f4:	74 07                	je     8010fd <strtol+0x141>
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	f7 d8                	neg    %eax
  8010fb:	eb 03                	jmp    801100 <strtol+0x144>
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <ltostr>:

void
ltostr(long value, char *str)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80110f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111a:	79 13                	jns    80112f <ltostr+0x2d>
	{
		neg = 1;
  80111c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801129:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801137:	99                   	cltd   
  801138:	f7 f9                	idiv   %ecx
  80113a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	8d 50 01             	lea    0x1(%eax),%edx
  801143:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801146:	89 c2                	mov    %eax,%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801150:	83 c2 30             	add    $0x30,%edx
  801153:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801158:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115d:	f7 e9                	imul   %ecx
  80115f:	c1 fa 02             	sar    $0x2,%edx
  801162:	89 c8                	mov    %ecx,%eax
  801164:	c1 f8 1f             	sar    $0x1f,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
  80116b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80116e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801172:	75 bb                	jne    80112f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80117b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117e:	48                   	dec    %eax
  80117f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801182:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801186:	74 3d                	je     8011c5 <ltostr+0xc3>
		start = 1 ;
  801188:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80118f:	eb 34                	jmp    8011c5 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801191:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801194:	8b 45 0c             	mov    0xc(%ebp),%eax
  801197:	01 d0                	add    %edx,%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80119e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	01 c2                	add    %eax,%edx
  8011a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ac:	01 c8                	add    %ecx,%eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b8:	01 c2                	add    %eax,%edx
  8011ba:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011bd:	88 02                	mov    %al,(%edx)
		start++ ;
  8011bf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011c2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011cb:	7c c4                	jl     801191 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011d8:	90                   	nop
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011e1:	ff 75 08             	pushl  0x8(%ebp)
  8011e4:	e8 73 fa ff ff       	call   800c5c <strlen>
  8011e9:	83 c4 04             	add    $0x4,%esp
  8011ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011ef:	ff 75 0c             	pushl  0xc(%ebp)
  8011f2:	e8 65 fa ff ff       	call   800c5c <strlen>
  8011f7:	83 c4 04             	add    $0x4,%esp
  8011fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801204:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80120b:	eb 17                	jmp    801224 <strcconcat+0x49>
		final[s] = str1[s] ;
  80120d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801210:	8b 45 10             	mov    0x10(%ebp),%eax
  801213:	01 c2                	add    %eax,%edx
  801215:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801218:	8b 45 08             	mov    0x8(%ebp),%eax
  80121b:	01 c8                	add    %ecx,%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801221:	ff 45 fc             	incl   -0x4(%ebp)
  801224:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801227:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80122a:	7c e1                	jl     80120d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80122c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801233:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80123a:	eb 1f                	jmp    80125b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80123c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123f:	8d 50 01             	lea    0x1(%eax),%edx
  801242:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801245:	89 c2                	mov    %eax,%edx
  801247:	8b 45 10             	mov    0x10(%ebp),%eax
  80124a:	01 c2                	add    %eax,%edx
  80124c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80124f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801252:	01 c8                	add    %ecx,%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801258:	ff 45 f8             	incl   -0x8(%ebp)
  80125b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801261:	7c d9                	jl     80123c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801263:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c6 00 00             	movb   $0x0,(%eax)
}
  80126e:	90                   	nop
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80127d:	8b 45 14             	mov    0x14(%ebp),%eax
  801280:	8b 00                	mov    (%eax),%eax
  801282:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801289:	8b 45 10             	mov    0x10(%ebp),%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801294:	eb 0c                	jmp    8012a2 <strsplit+0x31>
			*string++ = 0;
  801296:	8b 45 08             	mov    0x8(%ebp),%eax
  801299:	8d 50 01             	lea    0x1(%eax),%edx
  80129c:	89 55 08             	mov    %edx,0x8(%ebp)
  80129f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	84 c0                	test   %al,%al
  8012a9:	74 18                	je     8012c3 <strsplit+0x52>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	0f be c0             	movsbl %al,%eax
  8012b3:	50                   	push   %eax
  8012b4:	ff 75 0c             	pushl  0xc(%ebp)
  8012b7:	e8 32 fb ff ff       	call   800dee <strchr>
  8012bc:	83 c4 08             	add    $0x8,%esp
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	75 d3                	jne    801296 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	84 c0                	test   %al,%al
  8012ca:	74 5a                	je     801326 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012cf:	8b 00                	mov    (%eax),%eax
  8012d1:	83 f8 0f             	cmp    $0xf,%eax
  8012d4:	75 07                	jne    8012dd <strsplit+0x6c>
		{
			return 0;
  8012d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012db:	eb 66                	jmp    801343 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e0:	8b 00                	mov    (%eax),%eax
  8012e2:	8d 48 01             	lea    0x1(%eax),%ecx
  8012e5:	8b 55 14             	mov    0x14(%ebp),%edx
  8012e8:	89 0a                	mov    %ecx,(%edx)
  8012ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f4:	01 c2                	add    %eax,%edx
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012fb:	eb 03                	jmp    801300 <strsplit+0x8f>
			string++;
  8012fd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	84 c0                	test   %al,%al
  801307:	74 8b                	je     801294 <strsplit+0x23>
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	0f be c0             	movsbl %al,%eax
  801311:	50                   	push   %eax
  801312:	ff 75 0c             	pushl  0xc(%ebp)
  801315:	e8 d4 fa ff ff       	call   800dee <strchr>
  80131a:	83 c4 08             	add    $0x8,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	74 dc                	je     8012fd <strsplit+0x8c>
			string++;
	}
  801321:	e9 6e ff ff ff       	jmp    801294 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801326:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801327:	8b 45 14             	mov    0x14(%ebp),%eax
  80132a:	8b 00                	mov    (%eax),%eax
  80132c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801333:	8b 45 10             	mov    0x10(%ebp),%eax
  801336:	01 d0                	add    %edx,%eax
  801338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80133e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80134b:	83 ec 04             	sub    $0x4,%esp
  80134e:	68 1c 24 80 00       	push   $0x80241c
  801353:	68 3f 01 00 00       	push   $0x13f
  801358:	68 3e 24 80 00       	push   $0x80243e
  80135d:	e8 8f 07 00 00       	call   801af1 <_panic>

00801362 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801368:	83 ec 0c             	sub    $0xc,%esp
  80136b:	ff 75 08             	pushl  0x8(%ebp)
  80136e:	e8 ef 06 00 00       	call   801a62 <sys_sbrk>
  801373:	83 c4 10             	add    $0x10,%esp
}
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80137e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801382:	75 07                	jne    80138b <malloc+0x13>
  801384:	b8 00 00 00 00       	mov    $0x0,%eax
  801389:	eb 14                	jmp    80139f <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80138b:	83 ec 04             	sub    $0x4,%esp
  80138e:	68 4c 24 80 00       	push   $0x80244c
  801393:	6a 1b                	push   $0x1b
  801395:	68 71 24 80 00       	push   $0x802471
  80139a:	e8 52 07 00 00       	call   801af1 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8013a7:	83 ec 04             	sub    $0x4,%esp
  8013aa:	68 80 24 80 00       	push   $0x802480
  8013af:	6a 29                	push   $0x29
  8013b1:	68 71 24 80 00       	push   $0x802471
  8013b6:	e8 36 07 00 00       	call   801af1 <_panic>

008013bb <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 18             	sub    $0x18,%esp
  8013c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c4:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8013c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013cb:	75 07                	jne    8013d4 <smalloc+0x19>
  8013cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d2:	eb 14                	jmp    8013e8 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	68 a4 24 80 00       	push   $0x8024a4
  8013dc:	6a 38                	push   $0x38
  8013de:	68 71 24 80 00       	push   $0x802471
  8013e3:	e8 09 07 00 00       	call   801af1 <_panic>
	return NULL;
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013f0:	83 ec 04             	sub    $0x4,%esp
  8013f3:	68 cc 24 80 00       	push   $0x8024cc
  8013f8:	6a 43                	push   $0x43
  8013fa:	68 71 24 80 00       	push   $0x802471
  8013ff:	e8 ed 06 00 00       	call   801af1 <_panic>

00801404 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80140a:	83 ec 04             	sub    $0x4,%esp
  80140d:	68 f0 24 80 00       	push   $0x8024f0
  801412:	6a 5b                	push   $0x5b
  801414:	68 71 24 80 00       	push   $0x802471
  801419:	e8 d3 06 00 00       	call   801af1 <_panic>

0080141e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	68 14 25 80 00       	push   $0x802514
  80142c:	6a 72                	push   $0x72
  80142e:	68 71 24 80 00       	push   $0x802471
  801433:	e8 b9 06 00 00       	call   801af1 <_panic>

00801438 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	68 3a 25 80 00       	push   $0x80253a
  801446:	6a 7e                	push   $0x7e
  801448:	68 71 24 80 00       	push   $0x802471
  80144d:	e8 9f 06 00 00       	call   801af1 <_panic>

00801452 <shrink>:

}
void shrink(uint32 newSize)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801458:	83 ec 04             	sub    $0x4,%esp
  80145b:	68 3a 25 80 00       	push   $0x80253a
  801460:	68 83 00 00 00       	push   $0x83
  801465:	68 71 24 80 00       	push   $0x802471
  80146a:	e8 82 06 00 00       	call   801af1 <_panic>

0080146f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	68 3a 25 80 00       	push   $0x80253a
  80147d:	68 88 00 00 00       	push   $0x88
  801482:	68 71 24 80 00       	push   $0x802471
  801487:	e8 65 06 00 00       	call   801af1 <_panic>

0080148c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	57                   	push   %edi
  801490:	56                   	push   %esi
  801491:	53                   	push   %ebx
  801492:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80149e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014a1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014a4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014a7:	cd 30                	int    $0x30
  8014a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	5b                   	pop    %ebx
  8014b3:	5e                   	pop    %esi
  8014b4:	5f                   	pop    %edi
  8014b5:	5d                   	pop    %ebp
  8014b6:	c3                   	ret    

008014b7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	52                   	push   %edx
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	50                   	push   %eax
  8014d3:	6a 00                	push   $0x0
  8014d5:	e8 b2 ff ff ff       	call   80148c <syscall>
  8014da:	83 c4 18             	add    $0x18,%esp
}
  8014dd:	90                   	nop
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 02                	push   $0x2
  8014ef:	e8 98 ff ff ff       	call   80148c <syscall>
  8014f4:	83 c4 18             	add    $0x18,%esp
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 03                	push   $0x3
  801508:	e8 7f ff ff ff       	call   80148c <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
}
  801510:	90                   	nop
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 04                	push   $0x4
  801522:	e8 65 ff ff ff       	call   80148c <syscall>
  801527:	83 c4 18             	add    $0x18,%esp
}
  80152a:	90                   	nop
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801530:	8b 55 0c             	mov    0xc(%ebp),%edx
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	52                   	push   %edx
  80153d:	50                   	push   %eax
  80153e:	6a 08                	push   $0x8
  801540:	e8 47 ff ff ff       	call   80148c <syscall>
  801545:	83 c4 18             	add    $0x18,%esp
}
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	56                   	push   %esi
  80154e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80154f:	8b 75 18             	mov    0x18(%ebp),%esi
  801552:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801555:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	56                   	push   %esi
  80155f:	53                   	push   %ebx
  801560:	51                   	push   %ecx
  801561:	52                   	push   %edx
  801562:	50                   	push   %eax
  801563:	6a 09                	push   $0x9
  801565:	e8 22 ff ff ff       	call   80148c <syscall>
  80156a:	83 c4 18             	add    $0x18,%esp
}
  80156d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801570:	5b                   	pop    %ebx
  801571:	5e                   	pop    %esi
  801572:	5d                   	pop    %ebp
  801573:	c3                   	ret    

00801574 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	52                   	push   %edx
  801584:	50                   	push   %eax
  801585:	6a 0a                	push   $0xa
  801587:	e8 00 ff ff ff       	call   80148c <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	ff 75 0c             	pushl  0xc(%ebp)
  80159d:	ff 75 08             	pushl  0x8(%ebp)
  8015a0:	6a 0b                	push   $0xb
  8015a2:	e8 e5 fe ff ff       	call   80148c <syscall>
  8015a7:	83 c4 18             	add    $0x18,%esp
}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 0c                	push   $0xc
  8015bb:	e8 cc fe ff ff       	call   80148c <syscall>
  8015c0:	83 c4 18             	add    $0x18,%esp
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 0d                	push   $0xd
  8015d4:	e8 b3 fe ff ff       	call   80148c <syscall>
  8015d9:	83 c4 18             	add    $0x18,%esp
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 0e                	push   $0xe
  8015ed:	e8 9a fe ff ff       	call   80148c <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 0f                	push   $0xf
  801606:	e8 81 fe ff ff       	call   80148c <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	ff 75 08             	pushl  0x8(%ebp)
  80161e:	6a 10                	push   $0x10
  801620:	e8 67 fe ff ff       	call   80148c <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 11                	push   $0x11
  801639:	e8 4e fe ff ff       	call   80148c <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
}
  801641:	90                   	nop
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_cputc>:

void
sys_cputc(const char c)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	83 ec 04             	sub    $0x4,%esp
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801650:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	50                   	push   %eax
  80165d:	6a 01                	push   $0x1
  80165f:	e8 28 fe ff ff       	call   80148c <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
}
  801667:	90                   	nop
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 14                	push   $0x14
  801679:	e8 0e fe ff ff       	call   80148c <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
}
  801681:	90                   	nop
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801690:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801693:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	6a 00                	push   $0x0
  80169c:	51                   	push   %ecx
  80169d:	52                   	push   %edx
  80169e:	ff 75 0c             	pushl  0xc(%ebp)
  8016a1:	50                   	push   %eax
  8016a2:	6a 15                	push   $0x15
  8016a4:	e8 e3 fd ff ff       	call   80148c <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	52                   	push   %edx
  8016be:	50                   	push   %eax
  8016bf:	6a 16                	push   $0x16
  8016c1:	e8 c6 fd ff ff       	call   80148c <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	51                   	push   %ecx
  8016dc:	52                   	push   %edx
  8016dd:	50                   	push   %eax
  8016de:	6a 17                	push   $0x17
  8016e0:	e8 a7 fd ff ff       	call   80148c <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8016ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	52                   	push   %edx
  8016fa:	50                   	push   %eax
  8016fb:	6a 18                	push   $0x18
  8016fd:	e8 8a fd ff ff       	call   80148c <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	6a 00                	push   $0x0
  80170f:	ff 75 14             	pushl  0x14(%ebp)
  801712:	ff 75 10             	pushl  0x10(%ebp)
  801715:	ff 75 0c             	pushl  0xc(%ebp)
  801718:	50                   	push   %eax
  801719:	6a 19                	push   $0x19
  80171b:	e8 6c fd ff ff       	call   80148c <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	50                   	push   %eax
  801734:	6a 1a                	push   $0x1a
  801736:	e8 51 fd ff ff       	call   80148c <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	90                   	nop
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	50                   	push   %eax
  801750:	6a 1b                	push   $0x1b
  801752:	e8 35 fd ff ff       	call   80148c <syscall>
  801757:	83 c4 18             	add    $0x18,%esp
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 05                	push   $0x5
  80176b:	e8 1c fd ff ff       	call   80148c <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 06                	push   $0x6
  801784:	e8 03 fd ff ff       	call   80148c <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 07                	push   $0x7
  80179d:	e8 ea fc ff ff       	call   80148c <syscall>
  8017a2:	83 c4 18             	add    $0x18,%esp
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <sys_exit_env>:


void sys_exit_env(void)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 1c                	push   $0x1c
  8017b6:	e8 d1 fc ff ff       	call   80148c <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
}
  8017be:	90                   	nop
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017ca:	8d 50 04             	lea    0x4(%eax),%edx
  8017cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	52                   	push   %edx
  8017d7:	50                   	push   %eax
  8017d8:	6a 1d                	push   $0x1d
  8017da:	e8 ad fc ff ff       	call   80148c <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
	return result;
  8017e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017eb:	89 01                	mov    %eax,(%ecx)
  8017ed:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	c9                   	leave  
  8017f4:	c2 04 00             	ret    $0x4

008017f7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	ff 75 10             	pushl  0x10(%ebp)
  801801:	ff 75 0c             	pushl  0xc(%ebp)
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	6a 13                	push   $0x13
  801809:	e8 7e fc ff ff       	call   80148c <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
	return ;
  801811:	90                   	nop
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_rcr2>:
uint32 sys_rcr2()
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 1e                	push   $0x1e
  801823:	e8 64 fc ff ff       	call   80148c <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801839:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	50                   	push   %eax
  801846:	6a 1f                	push   $0x1f
  801848:	e8 3f fc ff ff       	call   80148c <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
	return ;
  801850:	90                   	nop
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <rsttst>:
void rsttst()
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 21                	push   $0x21
  801862:	e8 25 fc ff ff       	call   80148c <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
	return ;
  80186a:	90                   	nop
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	8b 45 14             	mov    0x14(%ebp),%eax
  801876:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801879:	8b 55 18             	mov    0x18(%ebp),%edx
  80187c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801880:	52                   	push   %edx
  801881:	50                   	push   %eax
  801882:	ff 75 10             	pushl  0x10(%ebp)
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	ff 75 08             	pushl  0x8(%ebp)
  80188b:	6a 20                	push   $0x20
  80188d:	e8 fa fb ff ff       	call   80148c <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
	return ;
  801895:	90                   	nop
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <chktst>:
void chktst(uint32 n)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	ff 75 08             	pushl  0x8(%ebp)
  8018a6:	6a 22                	push   $0x22
  8018a8:	e8 df fb ff ff       	call   80148c <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b0:	90                   	nop
}
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <inctst>:

void inctst()
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 23                	push   $0x23
  8018c2:	e8 c5 fb ff ff       	call   80148c <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ca:	90                   	nop
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <gettst>:
uint32 gettst()
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 24                	push   $0x24
  8018dc:	e8 ab fb ff ff       	call   80148c <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 25                	push   $0x25
  8018f8:	e8 8f fb ff ff       	call   80148c <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
  801900:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801903:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801907:	75 07                	jne    801910 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801909:	b8 01 00 00 00       	mov    $0x1,%eax
  80190e:	eb 05                	jmp    801915 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801910:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 25                	push   $0x25
  801929:	e8 5e fb ff ff       	call   80148c <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
  801931:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801934:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801938:	75 07                	jne    801941 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80193a:	b8 01 00 00 00       	mov    $0x1,%eax
  80193f:	eb 05                	jmp    801946 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801941:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 25                	push   $0x25
  80195a:	e8 2d fb ff ff       	call   80148c <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
  801962:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801965:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801969:	75 07                	jne    801972 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80196b:	b8 01 00 00 00       	mov    $0x1,%eax
  801970:	eb 05                	jmp    801977 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801972:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 25                	push   $0x25
  80198b:	e8 fc fa ff ff       	call   80148c <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
  801993:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801996:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80199a:	75 07                	jne    8019a3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80199c:	b8 01 00 00 00       	mov    $0x1,%eax
  8019a1:	eb 05                	jmp    8019a8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8019a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	ff 75 08             	pushl  0x8(%ebp)
  8019b8:	6a 26                	push   $0x26
  8019ba:	e8 cd fa ff ff       	call   80148c <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c2:	90                   	nop
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	6a 00                	push   $0x0
  8019d7:	53                   	push   %ebx
  8019d8:	51                   	push   %ecx
  8019d9:	52                   	push   %edx
  8019da:	50                   	push   %eax
  8019db:	6a 27                	push   $0x27
  8019dd:	e8 aa fa ff ff       	call   80148c <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	52                   	push   %edx
  8019fa:	50                   	push   %eax
  8019fb:	6a 28                	push   $0x28
  8019fd:	e8 8a fa ff ff       	call   80148c <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a0a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	51                   	push   %ecx
  801a16:	ff 75 10             	pushl  0x10(%ebp)
  801a19:	52                   	push   %edx
  801a1a:	50                   	push   %eax
  801a1b:	6a 29                	push   $0x29
  801a1d:	e8 6a fa ff ff       	call   80148c <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	ff 75 10             	pushl  0x10(%ebp)
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	ff 75 08             	pushl  0x8(%ebp)
  801a37:	6a 12                	push   $0x12
  801a39:	e8 4e fa ff ff       	call   80148c <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a41:	90                   	nop
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	52                   	push   %edx
  801a54:	50                   	push   %eax
  801a55:	6a 2a                	push   $0x2a
  801a57:	e8 30 fa ff ff       	call   80148c <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
	return;
  801a5f:	90                   	nop
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	50                   	push   %eax
  801a71:	6a 2b                	push   $0x2b
  801a73:	e8 14 fa ff ff       	call   80148c <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	ff 75 0c             	pushl  0xc(%ebp)
  801a89:	ff 75 08             	pushl  0x8(%ebp)
  801a8c:	6a 2c                	push   $0x2c
  801a8e:	e8 f9 f9 ff ff       	call   80148c <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
	return;
  801a96:	90                   	nop
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	ff 75 08             	pushl  0x8(%ebp)
  801aa8:	6a 2d                	push   $0x2d
  801aaa:	e8 dd f9 ff ff       	call   80148c <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
	return;
  801ab2:	90                   	nop
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801ac1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801ac5:	83 ec 0c             	sub    $0xc,%esp
  801ac8:	50                   	push   %eax
  801ac9:	e8 76 fb ff ff       	call   801644 <sys_cputc>
  801ace:	83 c4 10             	add    $0x10,%esp
}
  801ad1:	90                   	nop
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <getchar>:


int
getchar(void)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801ada:	e8 01 fa ff ff       	call   8014e0 <sys_cgetc>
  801adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <iscons>:

int iscons(int fdnum)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801aea:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801aef:	5d                   	pop    %ebp
  801af0:	c3                   	ret    

00801af1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
  801af4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801af7:	8d 45 10             	lea    0x10(%ebp),%eax
  801afa:	83 c0 04             	add    $0x4,%eax
  801afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801b00:	a1 24 30 80 00       	mov    0x803024,%eax
  801b05:	85 c0                	test   %eax,%eax
  801b07:	74 16                	je     801b1f <_panic+0x2e>
		cprintf("%s: ", argv0);
  801b09:	a1 24 30 80 00       	mov    0x803024,%eax
  801b0e:	83 ec 08             	sub    $0x8,%esp
  801b11:	50                   	push   %eax
  801b12:	68 4c 25 80 00       	push   $0x80254c
  801b17:	e8 a4 e8 ff ff       	call   8003c0 <cprintf>
  801b1c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801b1f:	a1 00 30 80 00       	mov    0x803000,%eax
  801b24:	ff 75 0c             	pushl  0xc(%ebp)
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	50                   	push   %eax
  801b2b:	68 51 25 80 00       	push   $0x802551
  801b30:	e8 8b e8 ff ff       	call   8003c0 <cprintf>
  801b35:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801b38:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3b:	83 ec 08             	sub    $0x8,%esp
  801b3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b41:	50                   	push   %eax
  801b42:	e8 0e e8 ff ff       	call   800355 <vcprintf>
  801b47:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801b4a:	83 ec 08             	sub    $0x8,%esp
  801b4d:	6a 00                	push   $0x0
  801b4f:	68 6d 25 80 00       	push   $0x80256d
  801b54:	e8 fc e7 ff ff       	call   800355 <vcprintf>
  801b59:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801b5c:	e8 7d e7 ff ff       	call   8002de <exit>

	// should not return here
	while (1) ;
  801b61:	eb fe                	jmp    801b61 <_panic+0x70>

00801b63 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801b69:	a1 04 30 80 00       	mov    0x803004,%eax
  801b6e:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b77:	39 c2                	cmp    %eax,%edx
  801b79:	74 14                	je     801b8f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801b7b:	83 ec 04             	sub    $0x4,%esp
  801b7e:	68 70 25 80 00       	push   $0x802570
  801b83:	6a 26                	push   $0x26
  801b85:	68 bc 25 80 00       	push   $0x8025bc
  801b8a:	e8 62 ff ff ff       	call   801af1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801b8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801b96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801b9d:	e9 c5 00 00 00       	jmp    801c67 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	01 d0                	add    %edx,%eax
  801bb1:	8b 00                	mov    (%eax),%eax
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	75 08                	jne    801bbf <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801bb7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801bba:	e9 a5 00 00 00       	jmp    801c64 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801bbf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bc6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801bcd:	eb 69                	jmp    801c38 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801bcf:	a1 04 30 80 00       	mov    0x803004,%eax
  801bd4:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801bda:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bdd:	89 d0                	mov    %edx,%eax
  801bdf:	01 c0                	add    %eax,%eax
  801be1:	01 d0                	add    %edx,%eax
  801be3:	c1 e0 03             	shl    $0x3,%eax
  801be6:	01 c8                	add    %ecx,%eax
  801be8:	8a 40 04             	mov    0x4(%eax),%al
  801beb:	84 c0                	test   %al,%al
  801bed:	75 46                	jne    801c35 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801bef:	a1 04 30 80 00       	mov    0x803004,%eax
  801bf4:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801bfa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bfd:	89 d0                	mov    %edx,%eax
  801bff:	01 c0                	add    %eax,%eax
  801c01:	01 d0                	add    %edx,%eax
  801c03:	c1 e0 03             	shl    $0x3,%eax
  801c06:	01 c8                	add    %ecx,%eax
  801c08:	8b 00                	mov    (%eax),%eax
  801c0a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c15:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	01 c8                	add    %ecx,%eax
  801c26:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801c28:	39 c2                	cmp    %eax,%edx
  801c2a:	75 09                	jne    801c35 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801c2c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801c33:	eb 15                	jmp    801c4a <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c35:	ff 45 e8             	incl   -0x18(%ebp)
  801c38:	a1 04 30 80 00       	mov    0x803004,%eax
  801c3d:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c46:	39 c2                	cmp    %eax,%edx
  801c48:	77 85                	ja     801bcf <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801c4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c4e:	75 14                	jne    801c64 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801c50:	83 ec 04             	sub    $0x4,%esp
  801c53:	68 c8 25 80 00       	push   $0x8025c8
  801c58:	6a 3a                	push   $0x3a
  801c5a:	68 bc 25 80 00       	push   $0x8025bc
  801c5f:	e8 8d fe ff ff       	call   801af1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801c64:	ff 45 f0             	incl   -0x10(%ebp)
  801c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c6d:	0f 8c 2f ff ff ff    	jl     801ba2 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801c73:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c7a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c81:	eb 26                	jmp    801ca9 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801c83:	a1 04 30 80 00       	mov    0x803004,%eax
  801c88:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801c8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c91:	89 d0                	mov    %edx,%eax
  801c93:	01 c0                	add    %eax,%eax
  801c95:	01 d0                	add    %edx,%eax
  801c97:	c1 e0 03             	shl    $0x3,%eax
  801c9a:	01 c8                	add    %ecx,%eax
  801c9c:	8a 40 04             	mov    0x4(%eax),%al
  801c9f:	3c 01                	cmp    $0x1,%al
  801ca1:	75 03                	jne    801ca6 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801ca3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ca6:	ff 45 e0             	incl   -0x20(%ebp)
  801ca9:	a1 04 30 80 00       	mov    0x803004,%eax
  801cae:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb7:	39 c2                	cmp    %eax,%edx
  801cb9:	77 c8                	ja     801c83 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801cc1:	74 14                	je     801cd7 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801cc3:	83 ec 04             	sub    $0x4,%esp
  801cc6:	68 1c 26 80 00       	push   $0x80261c
  801ccb:	6a 44                	push   $0x44
  801ccd:	68 bc 25 80 00       	push   $0x8025bc
  801cd2:	e8 1a fe ff ff       	call   801af1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    
  801cda:	66 90                	xchg   %ax,%ax

00801cdc <__udivdi3>:
  801cdc:	55                   	push   %ebp
  801cdd:	57                   	push   %edi
  801cde:	56                   	push   %esi
  801cdf:	53                   	push   %ebx
  801ce0:	83 ec 1c             	sub    $0x1c,%esp
  801ce3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ce7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ceb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cf3:	89 ca                	mov    %ecx,%edx
  801cf5:	89 f8                	mov    %edi,%eax
  801cf7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cfb:	85 f6                	test   %esi,%esi
  801cfd:	75 2d                	jne    801d2c <__udivdi3+0x50>
  801cff:	39 cf                	cmp    %ecx,%edi
  801d01:	77 65                	ja     801d68 <__udivdi3+0x8c>
  801d03:	89 fd                	mov    %edi,%ebp
  801d05:	85 ff                	test   %edi,%edi
  801d07:	75 0b                	jne    801d14 <__udivdi3+0x38>
  801d09:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0e:	31 d2                	xor    %edx,%edx
  801d10:	f7 f7                	div    %edi
  801d12:	89 c5                	mov    %eax,%ebp
  801d14:	31 d2                	xor    %edx,%edx
  801d16:	89 c8                	mov    %ecx,%eax
  801d18:	f7 f5                	div    %ebp
  801d1a:	89 c1                	mov    %eax,%ecx
  801d1c:	89 d8                	mov    %ebx,%eax
  801d1e:	f7 f5                	div    %ebp
  801d20:	89 cf                	mov    %ecx,%edi
  801d22:	89 fa                	mov    %edi,%edx
  801d24:	83 c4 1c             	add    $0x1c,%esp
  801d27:	5b                   	pop    %ebx
  801d28:	5e                   	pop    %esi
  801d29:	5f                   	pop    %edi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    
  801d2c:	39 ce                	cmp    %ecx,%esi
  801d2e:	77 28                	ja     801d58 <__udivdi3+0x7c>
  801d30:	0f bd fe             	bsr    %esi,%edi
  801d33:	83 f7 1f             	xor    $0x1f,%edi
  801d36:	75 40                	jne    801d78 <__udivdi3+0x9c>
  801d38:	39 ce                	cmp    %ecx,%esi
  801d3a:	72 0a                	jb     801d46 <__udivdi3+0x6a>
  801d3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d40:	0f 87 9e 00 00 00    	ja     801de4 <__udivdi3+0x108>
  801d46:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4b:	89 fa                	mov    %edi,%edx
  801d4d:	83 c4 1c             	add    $0x1c,%esp
  801d50:	5b                   	pop    %ebx
  801d51:	5e                   	pop    %esi
  801d52:	5f                   	pop    %edi
  801d53:	5d                   	pop    %ebp
  801d54:	c3                   	ret    
  801d55:	8d 76 00             	lea    0x0(%esi),%esi
  801d58:	31 ff                	xor    %edi,%edi
  801d5a:	31 c0                	xor    %eax,%eax
  801d5c:	89 fa                	mov    %edi,%edx
  801d5e:	83 c4 1c             	add    $0x1c,%esp
  801d61:	5b                   	pop    %ebx
  801d62:	5e                   	pop    %esi
  801d63:	5f                   	pop    %edi
  801d64:	5d                   	pop    %ebp
  801d65:	c3                   	ret    
  801d66:	66 90                	xchg   %ax,%ax
  801d68:	89 d8                	mov    %ebx,%eax
  801d6a:	f7 f7                	div    %edi
  801d6c:	31 ff                	xor    %edi,%edi
  801d6e:	89 fa                	mov    %edi,%edx
  801d70:	83 c4 1c             	add    $0x1c,%esp
  801d73:	5b                   	pop    %ebx
  801d74:	5e                   	pop    %esi
  801d75:	5f                   	pop    %edi
  801d76:	5d                   	pop    %ebp
  801d77:	c3                   	ret    
  801d78:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d7d:	89 eb                	mov    %ebp,%ebx
  801d7f:	29 fb                	sub    %edi,%ebx
  801d81:	89 f9                	mov    %edi,%ecx
  801d83:	d3 e6                	shl    %cl,%esi
  801d85:	89 c5                	mov    %eax,%ebp
  801d87:	88 d9                	mov    %bl,%cl
  801d89:	d3 ed                	shr    %cl,%ebp
  801d8b:	89 e9                	mov    %ebp,%ecx
  801d8d:	09 f1                	or     %esi,%ecx
  801d8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d93:	89 f9                	mov    %edi,%ecx
  801d95:	d3 e0                	shl    %cl,%eax
  801d97:	89 c5                	mov    %eax,%ebp
  801d99:	89 d6                	mov    %edx,%esi
  801d9b:	88 d9                	mov    %bl,%cl
  801d9d:	d3 ee                	shr    %cl,%esi
  801d9f:	89 f9                	mov    %edi,%ecx
  801da1:	d3 e2                	shl    %cl,%edx
  801da3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801da7:	88 d9                	mov    %bl,%cl
  801da9:	d3 e8                	shr    %cl,%eax
  801dab:	09 c2                	or     %eax,%edx
  801dad:	89 d0                	mov    %edx,%eax
  801daf:	89 f2                	mov    %esi,%edx
  801db1:	f7 74 24 0c          	divl   0xc(%esp)
  801db5:	89 d6                	mov    %edx,%esi
  801db7:	89 c3                	mov    %eax,%ebx
  801db9:	f7 e5                	mul    %ebp
  801dbb:	39 d6                	cmp    %edx,%esi
  801dbd:	72 19                	jb     801dd8 <__udivdi3+0xfc>
  801dbf:	74 0b                	je     801dcc <__udivdi3+0xf0>
  801dc1:	89 d8                	mov    %ebx,%eax
  801dc3:	31 ff                	xor    %edi,%edi
  801dc5:	e9 58 ff ff ff       	jmp    801d22 <__udivdi3+0x46>
  801dca:	66 90                	xchg   %ax,%ax
  801dcc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801dd0:	89 f9                	mov    %edi,%ecx
  801dd2:	d3 e2                	shl    %cl,%edx
  801dd4:	39 c2                	cmp    %eax,%edx
  801dd6:	73 e9                	jae    801dc1 <__udivdi3+0xe5>
  801dd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ddb:	31 ff                	xor    %edi,%edi
  801ddd:	e9 40 ff ff ff       	jmp    801d22 <__udivdi3+0x46>
  801de2:	66 90                	xchg   %ax,%ax
  801de4:	31 c0                	xor    %eax,%eax
  801de6:	e9 37 ff ff ff       	jmp    801d22 <__udivdi3+0x46>
  801deb:	90                   	nop

00801dec <__umoddi3>:
  801dec:	55                   	push   %ebp
  801ded:	57                   	push   %edi
  801dee:	56                   	push   %esi
  801def:	53                   	push   %ebx
  801df0:	83 ec 1c             	sub    $0x1c,%esp
  801df3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801df7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e0b:	89 f3                	mov    %esi,%ebx
  801e0d:	89 fa                	mov    %edi,%edx
  801e0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e13:	89 34 24             	mov    %esi,(%esp)
  801e16:	85 c0                	test   %eax,%eax
  801e18:	75 1a                	jne    801e34 <__umoddi3+0x48>
  801e1a:	39 f7                	cmp    %esi,%edi
  801e1c:	0f 86 a2 00 00 00    	jbe    801ec4 <__umoddi3+0xd8>
  801e22:	89 c8                	mov    %ecx,%eax
  801e24:	89 f2                	mov    %esi,%edx
  801e26:	f7 f7                	div    %edi
  801e28:	89 d0                	mov    %edx,%eax
  801e2a:	31 d2                	xor    %edx,%edx
  801e2c:	83 c4 1c             	add    $0x1c,%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5f                   	pop    %edi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    
  801e34:	39 f0                	cmp    %esi,%eax
  801e36:	0f 87 ac 00 00 00    	ja     801ee8 <__umoddi3+0xfc>
  801e3c:	0f bd e8             	bsr    %eax,%ebp
  801e3f:	83 f5 1f             	xor    $0x1f,%ebp
  801e42:	0f 84 ac 00 00 00    	je     801ef4 <__umoddi3+0x108>
  801e48:	bf 20 00 00 00       	mov    $0x20,%edi
  801e4d:	29 ef                	sub    %ebp,%edi
  801e4f:	89 fe                	mov    %edi,%esi
  801e51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e55:	89 e9                	mov    %ebp,%ecx
  801e57:	d3 e0                	shl    %cl,%eax
  801e59:	89 d7                	mov    %edx,%edi
  801e5b:	89 f1                	mov    %esi,%ecx
  801e5d:	d3 ef                	shr    %cl,%edi
  801e5f:	09 c7                	or     %eax,%edi
  801e61:	89 e9                	mov    %ebp,%ecx
  801e63:	d3 e2                	shl    %cl,%edx
  801e65:	89 14 24             	mov    %edx,(%esp)
  801e68:	89 d8                	mov    %ebx,%eax
  801e6a:	d3 e0                	shl    %cl,%eax
  801e6c:	89 c2                	mov    %eax,%edx
  801e6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e72:	d3 e0                	shl    %cl,%eax
  801e74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e78:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e7c:	89 f1                	mov    %esi,%ecx
  801e7e:	d3 e8                	shr    %cl,%eax
  801e80:	09 d0                	or     %edx,%eax
  801e82:	d3 eb                	shr    %cl,%ebx
  801e84:	89 da                	mov    %ebx,%edx
  801e86:	f7 f7                	div    %edi
  801e88:	89 d3                	mov    %edx,%ebx
  801e8a:	f7 24 24             	mull   (%esp)
  801e8d:	89 c6                	mov    %eax,%esi
  801e8f:	89 d1                	mov    %edx,%ecx
  801e91:	39 d3                	cmp    %edx,%ebx
  801e93:	0f 82 87 00 00 00    	jb     801f20 <__umoddi3+0x134>
  801e99:	0f 84 91 00 00 00    	je     801f30 <__umoddi3+0x144>
  801e9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ea3:	29 f2                	sub    %esi,%edx
  801ea5:	19 cb                	sbb    %ecx,%ebx
  801ea7:	89 d8                	mov    %ebx,%eax
  801ea9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ead:	d3 e0                	shl    %cl,%eax
  801eaf:	89 e9                	mov    %ebp,%ecx
  801eb1:	d3 ea                	shr    %cl,%edx
  801eb3:	09 d0                	or     %edx,%eax
  801eb5:	89 e9                	mov    %ebp,%ecx
  801eb7:	d3 eb                	shr    %cl,%ebx
  801eb9:	89 da                	mov    %ebx,%edx
  801ebb:	83 c4 1c             	add    $0x1c,%esp
  801ebe:	5b                   	pop    %ebx
  801ebf:	5e                   	pop    %esi
  801ec0:	5f                   	pop    %edi
  801ec1:	5d                   	pop    %ebp
  801ec2:	c3                   	ret    
  801ec3:	90                   	nop
  801ec4:	89 fd                	mov    %edi,%ebp
  801ec6:	85 ff                	test   %edi,%edi
  801ec8:	75 0b                	jne    801ed5 <__umoddi3+0xe9>
  801eca:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecf:	31 d2                	xor    %edx,%edx
  801ed1:	f7 f7                	div    %edi
  801ed3:	89 c5                	mov    %eax,%ebp
  801ed5:	89 f0                	mov    %esi,%eax
  801ed7:	31 d2                	xor    %edx,%edx
  801ed9:	f7 f5                	div    %ebp
  801edb:	89 c8                	mov    %ecx,%eax
  801edd:	f7 f5                	div    %ebp
  801edf:	89 d0                	mov    %edx,%eax
  801ee1:	e9 44 ff ff ff       	jmp    801e2a <__umoddi3+0x3e>
  801ee6:	66 90                	xchg   %ax,%ax
  801ee8:	89 c8                	mov    %ecx,%eax
  801eea:	89 f2                	mov    %esi,%edx
  801eec:	83 c4 1c             	add    $0x1c,%esp
  801eef:	5b                   	pop    %ebx
  801ef0:	5e                   	pop    %esi
  801ef1:	5f                   	pop    %edi
  801ef2:	5d                   	pop    %ebp
  801ef3:	c3                   	ret    
  801ef4:	3b 04 24             	cmp    (%esp),%eax
  801ef7:	72 06                	jb     801eff <__umoddi3+0x113>
  801ef9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801efd:	77 0f                	ja     801f0e <__umoddi3+0x122>
  801eff:	89 f2                	mov    %esi,%edx
  801f01:	29 f9                	sub    %edi,%ecx
  801f03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f07:	89 14 24             	mov    %edx,(%esp)
  801f0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f12:	8b 14 24             	mov    (%esp),%edx
  801f15:	83 c4 1c             	add    $0x1c,%esp
  801f18:	5b                   	pop    %ebx
  801f19:	5e                   	pop    %esi
  801f1a:	5f                   	pop    %edi
  801f1b:	5d                   	pop    %ebp
  801f1c:	c3                   	ret    
  801f1d:	8d 76 00             	lea    0x0(%esi),%esi
  801f20:	2b 04 24             	sub    (%esp),%eax
  801f23:	19 fa                	sbb    %edi,%edx
  801f25:	89 d1                	mov    %edx,%ecx
  801f27:	89 c6                	mov    %eax,%esi
  801f29:	e9 71 ff ff ff       	jmp    801e9f <__umoddi3+0xb3>
  801f2e:	66 90                	xchg   %ax,%ax
  801f30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f34:	72 ea                	jb     801f20 <__umoddi3+0x134>
  801f36:	89 d9                	mov    %ebx,%ecx
  801f38:	e9 62 ff ff ff       	jmp    801e9f <__umoddi3+0xb3>
