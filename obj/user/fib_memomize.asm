
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
  800052:	68 60 1f 80 00       	push   $0x801f60
  800057:	e8 0d 0b 00 00       	call   800b69 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	index = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e0 fe ff ff    	lea    -0x120(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 60 0f 00 00       	call   800fd2 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int64 *memo = malloc((index+1) * sizeof(int64));
  800078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007b:	40                   	inc    %eax
  80007c:	c1 e0 03             	shl    $0x3,%eax
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	e8 06 13 00 00       	call   80138e <malloc>
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
  8000db:	e8 d7 12 00 00       	call   8013b7 <free>
  8000e0:	83 c4 10             	add    $0x10,%esp

	atomic_cprintf("Fibonacci #%d = %lld\n",index, res);
  8000e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8000e9:	ff 75 f0             	pushl  -0x10(%ebp)
  8000ec:	68 7e 1f 80 00       	push   $0x801f7e
  8000f1:	e8 0d 03 00 00       	call   800403 <atomic_cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's completed successfully
		inctst();
  8000f9:	e8 cb 17 00 00       	call   8018c9 <inctst>
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
  8001bb:	e8 cb 15 00 00       	call   80178b <sys_getenvindex>
  8001c0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001c6:	89 d0                	mov    %edx,%eax
  8001c8:	c1 e0 06             	shl    $0x6,%eax
  8001cb:	29 d0                	sub    %edx,%eax
  8001cd:	c1 e0 02             	shl    $0x2,%eax
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001d9:	01 c8                	add    %ecx,%eax
  8001db:	c1 e0 03             	shl    $0x3,%eax
  8001de:	01 d0                	add    %edx,%eax
  8001e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e7:	29 c2                	sub    %eax,%edx
  8001e9:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8001f0:	89 c2                	mov    %eax,%edx
  8001f2:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001f8:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001fd:	a1 04 30 80 00       	mov    0x803004,%eax
  800202:	8a 40 20             	mov    0x20(%eax),%al
  800205:	84 c0                	test   %al,%al
  800207:	74 0d                	je     800216 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800209:	a1 04 30 80 00       	mov    0x803004,%eax
  80020e:	83 c0 20             	add    $0x20,%eax
  800211:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800216:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80021a:	7e 0a                	jle    800226 <libmain+0x71>
		binaryname = argv[0];
  80021c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021f:	8b 00                	mov    (%eax),%eax
  800221:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800226:	83 ec 08             	sub    $0x8,%esp
  800229:	ff 75 0c             	pushl  0xc(%ebp)
  80022c:	ff 75 08             	pushl  0x8(%ebp)
  80022f:	e8 04 fe ff ff       	call   800038 <_main>
  800234:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800237:	e8 d3 12 00 00       	call   80150f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	68 ac 1f 80 00       	push   $0x801fac
  800244:	e8 8d 01 00 00       	call   8003d6 <cprintf>
  800249:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80024c:	a1 04 30 80 00       	mov    0x803004,%eax
  800251:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800257:	a1 04 30 80 00       	mov    0x803004,%eax
  80025c:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	68 d4 1f 80 00       	push   $0x801fd4
  80026c:	e8 65 01 00 00       	call   8003d6 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800274:	a1 04 30 80 00       	mov    0x803004,%eax
  800279:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  80027f:	a1 04 30 80 00       	mov    0x803004,%eax
  800284:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80028a:	a1 04 30 80 00       	mov    0x803004,%eax
  80028f:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800295:	51                   	push   %ecx
  800296:	52                   	push   %edx
  800297:	50                   	push   %eax
  800298:	68 fc 1f 80 00       	push   $0x801ffc
  80029d:	e8 34 01 00 00       	call   8003d6 <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002a5:	a1 04 30 80 00       	mov    0x803004,%eax
  8002aa:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	50                   	push   %eax
  8002b4:	68 54 20 80 00       	push   $0x802054
  8002b9:	e8 18 01 00 00       	call   8003d6 <cprintf>
  8002be:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	68 ac 1f 80 00       	push   $0x801fac
  8002c9:	e8 08 01 00 00       	call   8003d6 <cprintf>
  8002ce:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002d1:	e8 53 12 00 00       	call   801529 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8002d6:	e8 19 00 00 00       	call   8002f4 <exit>
}
  8002db:	90                   	nop
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002e4:	83 ec 0c             	sub    $0xc,%esp
  8002e7:	6a 00                	push   $0x0
  8002e9:	e8 69 14 00 00       	call   801757 <sys_destroy_env>
  8002ee:	83 c4 10             	add    $0x10,%esp
}
  8002f1:	90                   	nop
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <exit>:

void
exit(void)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002fa:	e8 be 14 00 00       	call   8017bd <sys_exit_env>
}
  8002ff:	90                   	nop
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	8b 00                	mov    (%eax),%eax
  80030d:	8d 48 01             	lea    0x1(%eax),%ecx
  800310:	8b 55 0c             	mov    0xc(%ebp),%edx
  800313:	89 0a                	mov    %ecx,(%edx)
  800315:	8b 55 08             	mov    0x8(%ebp),%edx
  800318:	88 d1                	mov    %dl,%cl
  80031a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80031d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	3d ff 00 00 00       	cmp    $0xff,%eax
  80032b:	75 2c                	jne    800359 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80032d:	a0 08 30 80 00       	mov    0x803008,%al
  800332:	0f b6 c0             	movzbl %al,%eax
  800335:	8b 55 0c             	mov    0xc(%ebp),%edx
  800338:	8b 12                	mov    (%edx),%edx
  80033a:	89 d1                	mov    %edx,%ecx
  80033c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80033f:	83 c2 08             	add    $0x8,%edx
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	50                   	push   %eax
  800346:	51                   	push   %ecx
  800347:	52                   	push   %edx
  800348:	e8 80 11 00 00       	call   8014cd <sys_cputs>
  80034d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800350:	8b 45 0c             	mov    0xc(%ebp),%eax
  800353:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035c:	8b 40 04             	mov    0x4(%eax),%eax
  80035f:	8d 50 01             	lea    0x1(%eax),%edx
  800362:	8b 45 0c             	mov    0xc(%ebp),%eax
  800365:	89 50 04             	mov    %edx,0x4(%eax)
}
  800368:	90                   	nop
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800374:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80037b:	00 00 00 
	b.cnt = 0;
  80037e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800385:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800388:	ff 75 0c             	pushl  0xc(%ebp)
  80038b:	ff 75 08             	pushl  0x8(%ebp)
  80038e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	68 02 03 80 00       	push   $0x800302
  80039a:	e8 11 02 00 00       	call   8005b0 <vprintfmt>
  80039f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8003a2:	a0 08 30 80 00       	mov    0x803008,%al
  8003a7:	0f b6 c0             	movzbl %al,%eax
  8003aa:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003b0:	83 ec 04             	sub    $0x4,%esp
  8003b3:	50                   	push   %eax
  8003b4:	52                   	push   %edx
  8003b5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003bb:	83 c0 08             	add    $0x8,%eax
  8003be:	50                   	push   %eax
  8003bf:	e8 09 11 00 00       	call   8014cd <sys_cputs>
  8003c4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003c7:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8003ce:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003d4:	c9                   	leave  
  8003d5:	c3                   	ret    

008003d6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003dc:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8003e3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ec:	83 ec 08             	sub    $0x8,%esp
  8003ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f2:	50                   	push   %eax
  8003f3:	e8 73 ff ff ff       	call   80036b <vcprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
  8003fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800401:	c9                   	leave  
  800402:	c3                   	ret    

00800403 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800409:	e8 01 11 00 00       	call   80150f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80040e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800411:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	83 ec 08             	sub    $0x8,%esp
  80041a:	ff 75 f4             	pushl  -0xc(%ebp)
  80041d:	50                   	push   %eax
  80041e:	e8 48 ff ff ff       	call   80036b <vcprintf>
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800429:	e8 fb 10 00 00       	call   801529 <sys_unlock_cons>
	return cnt;
  80042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	53                   	push   %ebx
  800437:	83 ec 14             	sub    $0x14,%esp
  80043a:	8b 45 10             	mov    0x10(%ebp),%eax
  80043d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800440:	8b 45 14             	mov    0x14(%ebp),%eax
  800443:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800446:	8b 45 18             	mov    0x18(%ebp),%eax
  800449:	ba 00 00 00 00       	mov    $0x0,%edx
  80044e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800451:	77 55                	ja     8004a8 <printnum+0x75>
  800453:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800456:	72 05                	jb     80045d <printnum+0x2a>
  800458:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80045b:	77 4b                	ja     8004a8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80045d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800460:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800463:	8b 45 18             	mov    0x18(%ebp),%eax
  800466:	ba 00 00 00 00       	mov    $0x0,%edx
  80046b:	52                   	push   %edx
  80046c:	50                   	push   %eax
  80046d:	ff 75 f4             	pushl  -0xc(%ebp)
  800470:	ff 75 f0             	pushl  -0x10(%ebp)
  800473:	e8 7c 18 00 00       	call   801cf4 <__udivdi3>
  800478:	83 c4 10             	add    $0x10,%esp
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	ff 75 20             	pushl  0x20(%ebp)
  800481:	53                   	push   %ebx
  800482:	ff 75 18             	pushl  0x18(%ebp)
  800485:	52                   	push   %edx
  800486:	50                   	push   %eax
  800487:	ff 75 0c             	pushl  0xc(%ebp)
  80048a:	ff 75 08             	pushl  0x8(%ebp)
  80048d:	e8 a1 ff ff ff       	call   800433 <printnum>
  800492:	83 c4 20             	add    $0x20,%esp
  800495:	eb 1a                	jmp    8004b1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800497:	83 ec 08             	sub    $0x8,%esp
  80049a:	ff 75 0c             	pushl  0xc(%ebp)
  80049d:	ff 75 20             	pushl  0x20(%ebp)
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	ff d0                	call   *%eax
  8004a5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004a8:	ff 4d 1c             	decl   0x1c(%ebp)
  8004ab:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004af:	7f e6                	jg     800497 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004b1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004bf:	53                   	push   %ebx
  8004c0:	51                   	push   %ecx
  8004c1:	52                   	push   %edx
  8004c2:	50                   	push   %eax
  8004c3:	e8 3c 19 00 00       	call   801e04 <__umoddi3>
  8004c8:	83 c4 10             	add    $0x10,%esp
  8004cb:	05 94 22 80 00       	add    $0x802294,%eax
  8004d0:	8a 00                	mov    (%eax),%al
  8004d2:	0f be c0             	movsbl %al,%eax
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	ff 75 0c             	pushl  0xc(%ebp)
  8004db:	50                   	push   %eax
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	ff d0                	call   *%eax
  8004e1:	83 c4 10             	add    $0x10,%esp
}
  8004e4:	90                   	nop
  8004e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004e8:	c9                   	leave  
  8004e9:	c3                   	ret    

008004ea <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004f1:	7e 1c                	jle    80050f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	8d 50 08             	lea    0x8(%eax),%edx
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	89 10                	mov    %edx,(%eax)
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	83 e8 08             	sub    $0x8,%eax
  800508:	8b 50 04             	mov    0x4(%eax),%edx
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	eb 40                	jmp    80054f <getuint+0x65>
	else if (lflag)
  80050f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800513:	74 1e                	je     800533 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	8d 50 04             	lea    0x4(%eax),%edx
  80051d:	8b 45 08             	mov    0x8(%ebp),%eax
  800520:	89 10                	mov    %edx,(%eax)
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	83 e8 04             	sub    $0x4,%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	ba 00 00 00 00       	mov    $0x0,%edx
  800531:	eb 1c                	jmp    80054f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800533:	8b 45 08             	mov    0x8(%ebp),%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	8d 50 04             	lea    0x4(%eax),%edx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	89 10                	mov    %edx,(%eax)
  800540:	8b 45 08             	mov    0x8(%ebp),%eax
  800543:	8b 00                	mov    (%eax),%eax
  800545:	83 e8 04             	sub    $0x4,%eax
  800548:	8b 00                	mov    (%eax),%eax
  80054a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80054f:	5d                   	pop    %ebp
  800550:	c3                   	ret    

00800551 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800551:	55                   	push   %ebp
  800552:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800554:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800558:	7e 1c                	jle    800576 <getint+0x25>
		return va_arg(*ap, long long);
  80055a:	8b 45 08             	mov    0x8(%ebp),%eax
  80055d:	8b 00                	mov    (%eax),%eax
  80055f:	8d 50 08             	lea    0x8(%eax),%edx
  800562:	8b 45 08             	mov    0x8(%ebp),%eax
  800565:	89 10                	mov    %edx,(%eax)
  800567:	8b 45 08             	mov    0x8(%ebp),%eax
  80056a:	8b 00                	mov    (%eax),%eax
  80056c:	83 e8 08             	sub    $0x8,%eax
  80056f:	8b 50 04             	mov    0x4(%eax),%edx
  800572:	8b 00                	mov    (%eax),%eax
  800574:	eb 38                	jmp    8005ae <getint+0x5d>
	else if (lflag)
  800576:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80057a:	74 1a                	je     800596 <getint+0x45>
		return va_arg(*ap, long);
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	8d 50 04             	lea    0x4(%eax),%edx
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	89 10                	mov    %edx,(%eax)
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	83 e8 04             	sub    $0x4,%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	99                   	cltd   
  800594:	eb 18                	jmp    8005ae <getint+0x5d>
	else
		return va_arg(*ap, int);
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	8b 00                	mov    (%eax),%eax
  80059b:	8d 50 04             	lea    0x4(%eax),%edx
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	89 10                	mov    %edx,(%eax)
  8005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a6:	8b 00                	mov    (%eax),%eax
  8005a8:	83 e8 04             	sub    $0x4,%eax
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	99                   	cltd   
}
  8005ae:	5d                   	pop    %ebp
  8005af:	c3                   	ret    

008005b0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
  8005b3:	56                   	push   %esi
  8005b4:	53                   	push   %ebx
  8005b5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b8:	eb 17                	jmp    8005d1 <vprintfmt+0x21>
			if (ch == '\0')
  8005ba:	85 db                	test   %ebx,%ebx
  8005bc:	0f 84 c1 03 00 00    	je     800983 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	53                   	push   %ebx
  8005c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cc:	ff d0                	call   *%eax
  8005ce:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d4:	8d 50 01             	lea    0x1(%eax),%edx
  8005d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8005da:	8a 00                	mov    (%eax),%al
  8005dc:	0f b6 d8             	movzbl %al,%ebx
  8005df:	83 fb 25             	cmp    $0x25,%ebx
  8005e2:	75 d6                	jne    8005ba <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005e4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005e8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005ef:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005fd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800604:	8b 45 10             	mov    0x10(%ebp),%eax
  800607:	8d 50 01             	lea    0x1(%eax),%edx
  80060a:	89 55 10             	mov    %edx,0x10(%ebp)
  80060d:	8a 00                	mov    (%eax),%al
  80060f:	0f b6 d8             	movzbl %al,%ebx
  800612:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800615:	83 f8 5b             	cmp    $0x5b,%eax
  800618:	0f 87 3d 03 00 00    	ja     80095b <vprintfmt+0x3ab>
  80061e:	8b 04 85 b8 22 80 00 	mov    0x8022b8(,%eax,4),%eax
  800625:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800627:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80062b:	eb d7                	jmp    800604 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80062d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800631:	eb d1                	jmp    800604 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800633:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80063a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80063d:	89 d0                	mov    %edx,%eax
  80063f:	c1 e0 02             	shl    $0x2,%eax
  800642:	01 d0                	add    %edx,%eax
  800644:	01 c0                	add    %eax,%eax
  800646:	01 d8                	add    %ebx,%eax
  800648:	83 e8 30             	sub    $0x30,%eax
  80064b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80064e:	8b 45 10             	mov    0x10(%ebp),%eax
  800651:	8a 00                	mov    (%eax),%al
  800653:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800656:	83 fb 2f             	cmp    $0x2f,%ebx
  800659:	7e 3e                	jle    800699 <vprintfmt+0xe9>
  80065b:	83 fb 39             	cmp    $0x39,%ebx
  80065e:	7f 39                	jg     800699 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800660:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800663:	eb d5                	jmp    80063a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	83 c0 04             	add    $0x4,%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	83 e8 04             	sub    $0x4,%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800679:	eb 1f                	jmp    80069a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80067b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067f:	79 83                	jns    800604 <vprintfmt+0x54>
				width = 0;
  800681:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800688:	e9 77 ff ff ff       	jmp    800604 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80068d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800694:	e9 6b ff ff ff       	jmp    800604 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800699:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80069a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069e:	0f 89 60 ff ff ff    	jns    800604 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006aa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006b1:	e9 4e ff ff ff       	jmp    800604 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006b6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006b9:	e9 46 ff ff ff       	jmp    800604 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	83 c0 04             	add    $0x4,%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	83 e8 04             	sub    $0x4,%eax
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	83 ec 08             	sub    $0x8,%esp
  8006d2:	ff 75 0c             	pushl  0xc(%ebp)
  8006d5:	50                   	push   %eax
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	ff d0                	call   *%eax
  8006db:	83 c4 10             	add    $0x10,%esp
			break;
  8006de:	e9 9b 02 00 00       	jmp    80097e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	83 c0 04             	add    $0x4,%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	83 e8 04             	sub    $0x4,%eax
  8006f2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006f4:	85 db                	test   %ebx,%ebx
  8006f6:	79 02                	jns    8006fa <vprintfmt+0x14a>
				err = -err;
  8006f8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006fa:	83 fb 64             	cmp    $0x64,%ebx
  8006fd:	7f 0b                	jg     80070a <vprintfmt+0x15a>
  8006ff:	8b 34 9d 00 21 80 00 	mov    0x802100(,%ebx,4),%esi
  800706:	85 f6                	test   %esi,%esi
  800708:	75 19                	jne    800723 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80070a:	53                   	push   %ebx
  80070b:	68 a5 22 80 00       	push   $0x8022a5
  800710:	ff 75 0c             	pushl  0xc(%ebp)
  800713:	ff 75 08             	pushl  0x8(%ebp)
  800716:	e8 70 02 00 00       	call   80098b <printfmt>
  80071b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80071e:	e9 5b 02 00 00       	jmp    80097e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800723:	56                   	push   %esi
  800724:	68 ae 22 80 00       	push   $0x8022ae
  800729:	ff 75 0c             	pushl  0xc(%ebp)
  80072c:	ff 75 08             	pushl  0x8(%ebp)
  80072f:	e8 57 02 00 00       	call   80098b <printfmt>
  800734:	83 c4 10             	add    $0x10,%esp
			break;
  800737:	e9 42 02 00 00       	jmp    80097e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	83 c0 04             	add    $0x4,%eax
  800742:	89 45 14             	mov    %eax,0x14(%ebp)
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	83 e8 04             	sub    $0x4,%eax
  80074b:	8b 30                	mov    (%eax),%esi
  80074d:	85 f6                	test   %esi,%esi
  80074f:	75 05                	jne    800756 <vprintfmt+0x1a6>
				p = "(null)";
  800751:	be b1 22 80 00       	mov    $0x8022b1,%esi
			if (width > 0 && padc != '-')
  800756:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075a:	7e 6d                	jle    8007c9 <vprintfmt+0x219>
  80075c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800760:	74 67                	je     8007c9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800762:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	50                   	push   %eax
  800769:	56                   	push   %esi
  80076a:	e8 26 05 00 00       	call   800c95 <strnlen>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800775:	eb 16                	jmp    80078d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800777:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	50                   	push   %eax
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	ff d0                	call   *%eax
  800787:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80078a:	ff 4d e4             	decl   -0x1c(%ebp)
  80078d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800791:	7f e4                	jg     800777 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800793:	eb 34                	jmp    8007c9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800795:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800799:	74 1c                	je     8007b7 <vprintfmt+0x207>
  80079b:	83 fb 1f             	cmp    $0x1f,%ebx
  80079e:	7e 05                	jle    8007a5 <vprintfmt+0x1f5>
  8007a0:	83 fb 7e             	cmp    $0x7e,%ebx
  8007a3:	7e 12                	jle    8007b7 <vprintfmt+0x207>
					putch('?', putdat);
  8007a5:	83 ec 08             	sub    $0x8,%esp
  8007a8:	ff 75 0c             	pushl  0xc(%ebp)
  8007ab:	6a 3f                	push   $0x3f
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	ff d0                	call   *%eax
  8007b2:	83 c4 10             	add    $0x10,%esp
  8007b5:	eb 0f                	jmp    8007c6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	ff 75 0c             	pushl  0xc(%ebp)
  8007bd:	53                   	push   %ebx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	ff d0                	call   *%eax
  8007c3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c6:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c9:	89 f0                	mov    %esi,%eax
  8007cb:	8d 70 01             	lea    0x1(%eax),%esi
  8007ce:	8a 00                	mov    (%eax),%al
  8007d0:	0f be d8             	movsbl %al,%ebx
  8007d3:	85 db                	test   %ebx,%ebx
  8007d5:	74 24                	je     8007fb <vprintfmt+0x24b>
  8007d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007db:	78 b8                	js     800795 <vprintfmt+0x1e5>
  8007dd:	ff 4d e0             	decl   -0x20(%ebp)
  8007e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007e4:	79 af                	jns    800795 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007e6:	eb 13                	jmp    8007fb <vprintfmt+0x24b>
				putch(' ', putdat);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	6a 20                	push   $0x20
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	ff d0                	call   *%eax
  8007f5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8007fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ff:	7f e7                	jg     8007e8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800801:	e9 78 01 00 00       	jmp    80097e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	ff 75 e8             	pushl  -0x18(%ebp)
  80080c:	8d 45 14             	lea    0x14(%ebp),%eax
  80080f:	50                   	push   %eax
  800810:	e8 3c fd ff ff       	call   800551 <getint>
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80081e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800824:	85 d2                	test   %edx,%edx
  800826:	79 23                	jns    80084b <vprintfmt+0x29b>
				putch('-', putdat);
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	6a 2d                	push   $0x2d
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	ff d0                	call   *%eax
  800835:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80083e:	f7 d8                	neg    %eax
  800840:	83 d2 00             	adc    $0x0,%edx
  800843:	f7 da                	neg    %edx
  800845:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800848:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80084b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800852:	e9 bc 00 00 00       	jmp    800913 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	ff 75 e8             	pushl  -0x18(%ebp)
  80085d:	8d 45 14             	lea    0x14(%ebp),%eax
  800860:	50                   	push   %eax
  800861:	e8 84 fc ff ff       	call   8004ea <getuint>
  800866:	83 c4 10             	add    $0x10,%esp
  800869:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80086f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800876:	e9 98 00 00 00       	jmp    800913 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	6a 58                	push   $0x58
  800883:	8b 45 08             	mov    0x8(%ebp),%eax
  800886:	ff d0                	call   *%eax
  800888:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	ff 75 0c             	pushl  0xc(%ebp)
  800891:	6a 58                	push   $0x58
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	ff d0                	call   *%eax
  800898:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	ff 75 0c             	pushl  0xc(%ebp)
  8008a1:	6a 58                	push   $0x58
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
			break;
  8008ab:	e9 ce 00 00 00       	jmp    80097e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	ff 75 0c             	pushl  0xc(%ebp)
  8008b6:	6a 30                	push   $0x30
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	ff d0                	call   *%eax
  8008bd:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	6a 78                	push   $0x78
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008f2:	eb 1f                	jmp    800913 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8008fa:	8d 45 14             	lea    0x14(%ebp),%eax
  8008fd:	50                   	push   %eax
  8008fe:	e8 e7 fb ff ff       	call   8004ea <getuint>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800909:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80090c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800913:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091a:	83 ec 04             	sub    $0x4,%esp
  80091d:	52                   	push   %edx
  80091e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800921:	50                   	push   %eax
  800922:	ff 75 f4             	pushl  -0xc(%ebp)
  800925:	ff 75 f0             	pushl  -0x10(%ebp)
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	ff 75 08             	pushl  0x8(%ebp)
  80092e:	e8 00 fb ff ff       	call   800433 <printnum>
  800933:	83 c4 20             	add    $0x20,%esp
			break;
  800936:	eb 46                	jmp    80097e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	53                   	push   %ebx
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			break;
  800947:	eb 35                	jmp    80097e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800949:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800950:	eb 2c                	jmp    80097e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800952:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800959:	eb 23                	jmp    80097e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	6a 25                	push   $0x25
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	ff d0                	call   *%eax
  800968:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80096b:	ff 4d 10             	decl   0x10(%ebp)
  80096e:	eb 03                	jmp    800973 <vprintfmt+0x3c3>
  800970:	ff 4d 10             	decl   0x10(%ebp)
  800973:	8b 45 10             	mov    0x10(%ebp),%eax
  800976:	48                   	dec    %eax
  800977:	8a 00                	mov    (%eax),%al
  800979:	3c 25                	cmp    $0x25,%al
  80097b:	75 f3                	jne    800970 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80097d:	90                   	nop
		}
	}
  80097e:	e9 35 fc ff ff       	jmp    8005b8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800983:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800984:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800987:	5b                   	pop    %ebx
  800988:	5e                   	pop    %esi
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800991:	8d 45 10             	lea    0x10(%ebp),%eax
  800994:	83 c0 04             	add    $0x4,%eax
  800997:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80099a:	8b 45 10             	mov    0x10(%ebp),%eax
  80099d:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a0:	50                   	push   %eax
  8009a1:	ff 75 0c             	pushl  0xc(%ebp)
  8009a4:	ff 75 08             	pushl  0x8(%ebp)
  8009a7:	e8 04 fc ff ff       	call   8005b0 <vprintfmt>
  8009ac:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009af:	90                   	nop
  8009b0:	c9                   	leave  
  8009b1:	c3                   	ret    

008009b2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b8:	8b 40 08             	mov    0x8(%eax),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c7:	8b 10                	mov    (%eax),%edx
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	8b 40 04             	mov    0x4(%eax),%eax
  8009cf:	39 c2                	cmp    %eax,%edx
  8009d1:	73 12                	jae    8009e5 <sprintputch+0x33>
		*b->buf++ = ch;
  8009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d6:	8b 00                	mov    (%eax),%eax
  8009d8:	8d 48 01             	lea    0x1(%eax),%ecx
  8009db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009de:	89 0a                	mov    %ecx,(%edx)
  8009e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e3:	88 10                	mov    %dl,(%eax)
}
  8009e5:	90                   	nop
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    

008009e8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009e8:	55                   	push   %ebp
  8009e9:	89 e5                	mov    %esp,%ebp
  8009eb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	01 d0                	add    %edx,%eax
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a0d:	74 06                	je     800a15 <vsnprintf+0x2d>
  800a0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a13:	7f 07                	jg     800a1c <vsnprintf+0x34>
		return -E_INVAL;
  800a15:	b8 03 00 00 00       	mov    $0x3,%eax
  800a1a:	eb 20                	jmp    800a3c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a1c:	ff 75 14             	pushl  0x14(%ebp)
  800a1f:	ff 75 10             	pushl  0x10(%ebp)
  800a22:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a25:	50                   	push   %eax
  800a26:	68 b2 09 80 00       	push   $0x8009b2
  800a2b:	e8 80 fb ff ff       	call   8005b0 <vprintfmt>
  800a30:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a36:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a3c:	c9                   	leave  
  800a3d:	c3                   	ret    

00800a3e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a44:	8d 45 10             	lea    0x10(%ebp),%eax
  800a47:	83 c0 04             	add    $0x4,%eax
  800a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a50:	ff 75 f4             	pushl  -0xc(%ebp)
  800a53:	50                   	push   %eax
  800a54:	ff 75 0c             	pushl  0xc(%ebp)
  800a57:	ff 75 08             	pushl  0x8(%ebp)
  800a5a:	e8 89 ff ff ff       	call   8009e8 <vsnprintf>
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800a70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a74:	74 13                	je     800a89 <readline+0x1f>
		cprintf("%s", prompt);
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 08             	pushl  0x8(%ebp)
  800a7c:	68 28 24 80 00       	push   $0x802428
  800a81:	e8 50 f9 ff ff       	call   8003d6 <cprintf>
  800a86:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a90:	83 ec 0c             	sub    $0xc,%esp
  800a93:	6a 00                	push   $0x0
  800a95:	e8 67 10 00 00       	call   801b01 <iscons>
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800aa0:	e8 49 10 00 00       	call   801aee <getchar>
  800aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800aa8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aac:	79 22                	jns    800ad0 <readline+0x66>
			if (c != -E_EOF)
  800aae:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ab2:	0f 84 ad 00 00 00    	je     800b65 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800ab8:	83 ec 08             	sub    $0x8,%esp
  800abb:	ff 75 ec             	pushl  -0x14(%ebp)
  800abe:	68 2b 24 80 00       	push   $0x80242b
  800ac3:	e8 0e f9 ff ff       	call   8003d6 <cprintf>
  800ac8:	83 c4 10             	add    $0x10,%esp
			break;
  800acb:	e9 95 00 00 00       	jmp    800b65 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ad0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ad4:	7e 34                	jle    800b0a <readline+0xa0>
  800ad6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800add:	7f 2b                	jg     800b0a <readline+0xa0>
			if (echoing)
  800adf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ae3:	74 0e                	je     800af3 <readline+0x89>
				cputchar(c);
  800ae5:	83 ec 0c             	sub    $0xc,%esp
  800ae8:	ff 75 ec             	pushl  -0x14(%ebp)
  800aeb:	e8 df 0f 00 00       	call   801acf <cputchar>
  800af0:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af6:	8d 50 01             	lea    0x1(%eax),%edx
  800af9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b01:	01 d0                	add    %edx,%eax
  800b03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b06:	88 10                	mov    %dl,(%eax)
  800b08:	eb 56                	jmp    800b60 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800b0a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b0e:	75 1f                	jne    800b2f <readline+0xc5>
  800b10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b14:	7e 19                	jle    800b2f <readline+0xc5>
			if (echoing)
  800b16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b1a:	74 0e                	je     800b2a <readline+0xc0>
				cputchar(c);
  800b1c:	83 ec 0c             	sub    $0xc,%esp
  800b1f:	ff 75 ec             	pushl  -0x14(%ebp)
  800b22:	e8 a8 0f 00 00       	call   801acf <cputchar>
  800b27:	83 c4 10             	add    $0x10,%esp

			i--;
  800b2a:	ff 4d f4             	decl   -0xc(%ebp)
  800b2d:	eb 31                	jmp    800b60 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800b2f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b33:	74 0a                	je     800b3f <readline+0xd5>
  800b35:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b39:	0f 85 61 ff ff ff    	jne    800aa0 <readline+0x36>
			if (echoing)
  800b3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b43:	74 0e                	je     800b53 <readline+0xe9>
				cputchar(c);
  800b45:	83 ec 0c             	sub    $0xc,%esp
  800b48:	ff 75 ec             	pushl  -0x14(%ebp)
  800b4b:	e8 7f 0f 00 00       	call   801acf <cputchar>
  800b50:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800b5e:	eb 06                	jmp    800b66 <readline+0xfc>
		}
	}
  800b60:	e9 3b ff ff ff       	jmp    800aa0 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800b65:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800b66:	90                   	nop
  800b67:	c9                   	leave  
  800b68:	c3                   	ret    

00800b69 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800b6f:	e8 9b 09 00 00       	call   80150f <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800b74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b78:	74 13                	je     800b8d <atomic_readline+0x24>
			cprintf("%s", prompt);
  800b7a:	83 ec 08             	sub    $0x8,%esp
  800b7d:	ff 75 08             	pushl  0x8(%ebp)
  800b80:	68 28 24 80 00       	push   $0x802428
  800b85:	e8 4c f8 ff ff       	call   8003d6 <cprintf>
  800b8a:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800b8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800b94:	83 ec 0c             	sub    $0xc,%esp
  800b97:	6a 00                	push   $0x0
  800b99:	e8 63 0f 00 00       	call   801b01 <iscons>
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800ba4:	e8 45 0f 00 00       	call   801aee <getchar>
  800ba9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800bac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800bb0:	79 22                	jns    800bd4 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800bb2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800bb6:	0f 84 ad 00 00 00    	je     800c69 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800bbc:	83 ec 08             	sub    $0x8,%esp
  800bbf:	ff 75 ec             	pushl  -0x14(%ebp)
  800bc2:	68 2b 24 80 00       	push   $0x80242b
  800bc7:	e8 0a f8 ff ff       	call   8003d6 <cprintf>
  800bcc:	83 c4 10             	add    $0x10,%esp
				break;
  800bcf:	e9 95 00 00 00       	jmp    800c69 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800bd4:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800bd8:	7e 34                	jle    800c0e <atomic_readline+0xa5>
  800bda:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800be1:	7f 2b                	jg     800c0e <atomic_readline+0xa5>
				if (echoing)
  800be3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800be7:	74 0e                	je     800bf7 <atomic_readline+0x8e>
					cputchar(c);
  800be9:	83 ec 0c             	sub    $0xc,%esp
  800bec:	ff 75 ec             	pushl  -0x14(%ebp)
  800bef:	e8 db 0e 00 00       	call   801acf <cputchar>
  800bf4:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bfa:	8d 50 01             	lea    0x1(%eax),%edx
  800bfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800c00:	89 c2                	mov    %eax,%edx
  800c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c05:	01 d0                	add    %edx,%eax
  800c07:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c0a:	88 10                	mov    %dl,(%eax)
  800c0c:	eb 56                	jmp    800c64 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800c0e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800c12:	75 1f                	jne    800c33 <atomic_readline+0xca>
  800c14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800c18:	7e 19                	jle    800c33 <atomic_readline+0xca>
				if (echoing)
  800c1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c1e:	74 0e                	je     800c2e <atomic_readline+0xc5>
					cputchar(c);
  800c20:	83 ec 0c             	sub    $0xc,%esp
  800c23:	ff 75 ec             	pushl  -0x14(%ebp)
  800c26:	e8 a4 0e 00 00       	call   801acf <cputchar>
  800c2b:	83 c4 10             	add    $0x10,%esp
				i--;
  800c2e:	ff 4d f4             	decl   -0xc(%ebp)
  800c31:	eb 31                	jmp    800c64 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800c33:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800c37:	74 0a                	je     800c43 <atomic_readline+0xda>
  800c39:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800c3d:	0f 85 61 ff ff ff    	jne    800ba4 <atomic_readline+0x3b>
				if (echoing)
  800c43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c47:	74 0e                	je     800c57 <atomic_readline+0xee>
					cputchar(c);
  800c49:	83 ec 0c             	sub    $0xc,%esp
  800c4c:	ff 75 ec             	pushl  -0x14(%ebp)
  800c4f:	e8 7b 0e 00 00       	call   801acf <cputchar>
  800c54:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	01 d0                	add    %edx,%eax
  800c5f:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800c62:	eb 06                	jmp    800c6a <atomic_readline+0x101>
			}
		}
  800c64:	e9 3b ff ff ff       	jmp    800ba4 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800c69:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800c6a:	e8 ba 08 00 00       	call   801529 <sys_unlock_cons>
}
  800c6f:	90                   	nop
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7f:	eb 06                	jmp    800c87 <strlen+0x15>
		n++;
  800c81:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c84:	ff 45 08             	incl   0x8(%ebp)
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8a 00                	mov    (%eax),%al
  800c8c:	84 c0                	test   %al,%al
  800c8e:	75 f1                	jne    800c81 <strlen+0xf>
		n++;
	return n;
  800c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c93:	c9                   	leave  
  800c94:	c3                   	ret    

00800c95 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c9b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca2:	eb 09                	jmp    800cad <strnlen+0x18>
		n++;
  800ca4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca7:	ff 45 08             	incl   0x8(%ebp)
  800caa:	ff 4d 0c             	decl   0xc(%ebp)
  800cad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb1:	74 09                	je     800cbc <strnlen+0x27>
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	8a 00                	mov    (%eax),%al
  800cb8:	84 c0                	test   %al,%al
  800cba:	75 e8                	jne    800ca4 <strnlen+0xf>
		n++;
	return n;
  800cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ccd:	90                   	nop
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	8d 50 01             	lea    0x1(%eax),%edx
  800cd4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cda:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cdd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce0:	8a 12                	mov    (%edx),%dl
  800ce2:	88 10                	mov    %dl,(%eax)
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	84 c0                	test   %al,%al
  800ce8:	75 e4                	jne    800cce <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cfb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d02:	eb 1f                	jmp    800d23 <strncpy+0x34>
		*dst++ = *src;
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8d 50 01             	lea    0x1(%eax),%edx
  800d0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d10:	8a 12                	mov    (%edx),%dl
  800d12:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	74 03                	je     800d20 <strncpy+0x31>
			src++;
  800d1d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d20:	ff 45 fc             	incl   -0x4(%ebp)
  800d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d26:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d29:	72 d9                	jb     800d04 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d40:	74 30                	je     800d72 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d42:	eb 16                	jmp    800d5a <strlcpy+0x2a>
			*dst++ = *src++;
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8d 50 01             	lea    0x1(%eax),%edx
  800d4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d56:	8a 12                	mov    (%edx),%dl
  800d58:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d5a:	ff 4d 10             	decl   0x10(%ebp)
  800d5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d61:	74 09                	je     800d6c <strlcpy+0x3c>
  800d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	84 c0                	test   %al,%al
  800d6a:	75 d8                	jne    800d44 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d78:	29 c2                	sub    %eax,%edx
  800d7a:	89 d0                	mov    %edx,%eax
}
  800d7c:	c9                   	leave  
  800d7d:	c3                   	ret    

00800d7e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d81:	eb 06                	jmp    800d89 <strcmp+0xb>
		p++, q++;
  800d83:	ff 45 08             	incl   0x8(%ebp)
  800d86:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	84 c0                	test   %al,%al
  800d90:	74 0e                	je     800da0 <strcmp+0x22>
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 10                	mov    (%eax),%dl
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	38 c2                	cmp    %al,%dl
  800d9e:	74 e3                	je     800d83 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	0f b6 d0             	movzbl %al,%edx
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	0f b6 c0             	movzbl %al,%eax
  800db0:	29 c2                	sub    %eax,%edx
  800db2:	89 d0                	mov    %edx,%eax
}
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    

00800db6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db9:	eb 09                	jmp    800dc4 <strncmp+0xe>
		n--, p++, q++;
  800dbb:	ff 4d 10             	decl   0x10(%ebp)
  800dbe:	ff 45 08             	incl   0x8(%ebp)
  800dc1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc8:	74 17                	je     800de1 <strncmp+0x2b>
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	84 c0                	test   %al,%al
  800dd1:	74 0e                	je     800de1 <strncmp+0x2b>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 10                	mov    (%eax),%dl
  800dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	38 c2                	cmp    %al,%dl
  800ddf:	74 da                	je     800dbb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800de1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de5:	75 07                	jne    800dee <strncmp+0x38>
		return 0;
  800de7:	b8 00 00 00 00       	mov    $0x0,%eax
  800dec:	eb 14                	jmp    800e02 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	0f b6 d0             	movzbl %al,%edx
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	0f b6 c0             	movzbl %al,%eax
  800dfe:	29 c2                	sub    %eax,%edx
  800e00:	89 d0                	mov    %edx,%eax
}
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 04             	sub    $0x4,%esp
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e10:	eb 12                	jmp    800e24 <strchr+0x20>
		if (*s == c)
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	8a 00                	mov    (%eax),%al
  800e17:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e1a:	75 05                	jne    800e21 <strchr+0x1d>
			return (char *) s;
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	eb 11                	jmp    800e32 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e21:	ff 45 08             	incl   0x8(%ebp)
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	84 c0                	test   %al,%al
  800e2b:	75 e5                	jne    800e12 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

00800e34 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	83 ec 04             	sub    $0x4,%esp
  800e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e40:	eb 0d                	jmp    800e4f <strfind+0x1b>
		if (*s == c)
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4a:	74 0e                	je     800e5a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e4c:	ff 45 08             	incl   0x8(%ebp)
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	84 c0                	test   %al,%al
  800e56:	75 ea                	jne    800e42 <strfind+0xe>
  800e58:	eb 01                	jmp    800e5b <strfind+0x27>
		if (*s == c)
			break;
  800e5a:	90                   	nop
	return (char *) s;
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5e:	c9                   	leave  
  800e5f:	c3                   	ret    

00800e60 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e72:	eb 0e                	jmp    800e82 <memset+0x22>
		*p++ = c;
  800e74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e80:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e82:	ff 4d f8             	decl   -0x8(%ebp)
  800e85:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e89:	79 e9                	jns    800e74 <memset+0x14>
		*p++ = c;

	return v;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8e:	c9                   	leave  
  800e8f:	c3                   	ret    

00800e90 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ea2:	eb 16                	jmp    800eba <memcpy+0x2a>
		*d++ = *s++;
  800ea4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea7:	8d 50 01             	lea    0x1(%eax),%edx
  800eaa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ead:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb6:	8a 12                	mov    (%edx),%dl
  800eb8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eba:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec3:	85 c0                	test   %eax,%eax
  800ec5:	75 dd                	jne    800ea4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee4:	73 50                	jae    800f36 <memmove+0x6a>
  800ee6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ef1:	76 43                	jbe    800f36 <memmove+0x6a>
		s += n;
  800ef3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  800efc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eff:	eb 10                	jmp    800f11 <memmove+0x45>
			*--d = *--s;
  800f01:	ff 4d f8             	decl   -0x8(%ebp)
  800f04:	ff 4d fc             	decl   -0x4(%ebp)
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	8a 10                	mov    (%eax),%dl
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f11:	8b 45 10             	mov    0x10(%ebp),%eax
  800f14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f17:	89 55 10             	mov    %edx,0x10(%ebp)
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	75 e3                	jne    800f01 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f1e:	eb 23                	jmp    800f43 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f23:	8d 50 01             	lea    0x1(%eax),%edx
  800f26:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f2f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f32:	8a 12                	mov    (%edx),%dl
  800f34:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f36:	8b 45 10             	mov    0x10(%ebp),%eax
  800f39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	75 dd                	jne    800f20 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f5a:	eb 2a                	jmp    800f86 <memcmp+0x3e>
		if (*s1 != *s2)
  800f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5f:	8a 10                	mov    (%eax),%dl
  800f61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	38 c2                	cmp    %al,%dl
  800f68:	74 16                	je     800f80 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f b6 d0             	movzbl %al,%edx
  800f72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	0f b6 c0             	movzbl %al,%eax
  800f7a:	29 c2                	sub    %eax,%edx
  800f7c:	89 d0                	mov    %edx,%eax
  800f7e:	eb 18                	jmp    800f98 <memcmp+0x50>
		s1++, s2++;
  800f80:	ff 45 fc             	incl   -0x4(%ebp)
  800f83:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	75 c9                	jne    800f5c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    

00800f9a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa6:	01 d0                	add    %edx,%eax
  800fa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fab:	eb 15                	jmp    800fc2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	0f b6 d0             	movzbl %al,%edx
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	0f b6 c0             	movzbl %al,%eax
  800fbb:	39 c2                	cmp    %eax,%edx
  800fbd:	74 0d                	je     800fcc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fbf:	ff 45 08             	incl   0x8(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc8:	72 e3                	jb     800fad <memfind+0x13>
  800fca:	eb 01                	jmp    800fcd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fcc:	90                   	nop
	return (void *) s;
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd0:	c9                   	leave  
  800fd1:	c3                   	ret    

00800fd2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fdf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe6:	eb 03                	jmp    800feb <strtol+0x19>
		s++;
  800fe8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 20                	cmp    $0x20,%al
  800ff2:	74 f4                	je     800fe8 <strtol+0x16>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 09                	cmp    $0x9,%al
  800ffb:	74 eb                	je     800fe8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 2b                	cmp    $0x2b,%al
  801004:	75 05                	jne    80100b <strtol+0x39>
		s++;
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	eb 13                	jmp    80101e <strtol+0x4c>
	else if (*s == '-')
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	3c 2d                	cmp    $0x2d,%al
  801012:	75 0a                	jne    80101e <strtol+0x4c>
		s++, neg = 1;
  801014:	ff 45 08             	incl   0x8(%ebp)
  801017:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80101e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801022:	74 06                	je     80102a <strtol+0x58>
  801024:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801028:	75 20                	jne    80104a <strtol+0x78>
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	3c 30                	cmp    $0x30,%al
  801031:	75 17                	jne    80104a <strtol+0x78>
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	40                   	inc    %eax
  801037:	8a 00                	mov    (%eax),%al
  801039:	3c 78                	cmp    $0x78,%al
  80103b:	75 0d                	jne    80104a <strtol+0x78>
		s += 2, base = 16;
  80103d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801041:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801048:	eb 28                	jmp    801072 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80104a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104e:	75 15                	jne    801065 <strtol+0x93>
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3c 30                	cmp    $0x30,%al
  801057:	75 0c                	jne    801065 <strtol+0x93>
		s++, base = 8;
  801059:	ff 45 08             	incl   0x8(%ebp)
  80105c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801063:	eb 0d                	jmp    801072 <strtol+0xa0>
	else if (base == 0)
  801065:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801069:	75 07                	jne    801072 <strtol+0xa0>
		base = 10;
  80106b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	8a 00                	mov    (%eax),%al
  801077:	3c 2f                	cmp    $0x2f,%al
  801079:	7e 19                	jle    801094 <strtol+0xc2>
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	3c 39                	cmp    $0x39,%al
  801082:	7f 10                	jg     801094 <strtol+0xc2>
			dig = *s - '0';
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	0f be c0             	movsbl %al,%eax
  80108c:	83 e8 30             	sub    $0x30,%eax
  80108f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801092:	eb 42                	jmp    8010d6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	8a 00                	mov    (%eax),%al
  801099:	3c 60                	cmp    $0x60,%al
  80109b:	7e 19                	jle    8010b6 <strtol+0xe4>
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	8a 00                	mov    (%eax),%al
  8010a2:	3c 7a                	cmp    $0x7a,%al
  8010a4:	7f 10                	jg     8010b6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8a 00                	mov    (%eax),%al
  8010ab:	0f be c0             	movsbl %al,%eax
  8010ae:	83 e8 57             	sub    $0x57,%eax
  8010b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010b4:	eb 20                	jmp    8010d6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	3c 40                	cmp    $0x40,%al
  8010bd:	7e 39                	jle    8010f8 <strtol+0x126>
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	3c 5a                	cmp    $0x5a,%al
  8010c6:	7f 30                	jg     8010f8 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8a 00                	mov    (%eax),%al
  8010cd:	0f be c0             	movsbl %al,%eax
  8010d0:	83 e8 37             	sub    $0x37,%eax
  8010d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010dc:	7d 19                	jge    8010f7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010de:	ff 45 08             	incl   0x8(%ebp)
  8010e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e8:	89 c2                	mov    %eax,%edx
  8010ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ed:	01 d0                	add    %edx,%eax
  8010ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010f2:	e9 7b ff ff ff       	jmp    801072 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010fc:	74 08                	je     801106 <strtol+0x134>
		*endptr = (char *) s;
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	8b 55 08             	mov    0x8(%ebp),%edx
  801104:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801106:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110a:	74 07                	je     801113 <strtol+0x141>
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	f7 d8                	neg    %eax
  801111:	eb 03                	jmp    801116 <strtol+0x144>
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801116:	c9                   	leave  
  801117:	c3                   	ret    

00801118 <ltostr>:

void
ltostr(long value, char *str)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
  80111b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80111e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801125:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80112c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801130:	79 13                	jns    801145 <ltostr+0x2d>
	{
		neg = 1;
  801132:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80113f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801142:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80114d:	99                   	cltd   
  80114e:	f7 f9                	idiv   %ecx
  801150:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801153:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801156:	8d 50 01             	lea    0x1(%eax),%edx
  801159:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80115c:	89 c2                	mov    %eax,%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801166:	83 c2 30             	add    $0x30,%edx
  801169:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80116b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80116e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801173:	f7 e9                	imul   %ecx
  801175:	c1 fa 02             	sar    $0x2,%edx
  801178:	89 c8                	mov    %ecx,%eax
  80117a:	c1 f8 1f             	sar    $0x1f,%eax
  80117d:	29 c2                	sub    %eax,%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801184:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801188:	75 bb                	jne    801145 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80118a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	48                   	dec    %eax
  801195:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801198:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119c:	74 3d                	je     8011db <ltostr+0xc3>
		start = 1 ;
  80119e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011a5:	eb 34                	jmp    8011db <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8011a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c8                	add    %ecx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	01 c2                	add    %eax,%edx
  8011d0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011d3:	88 02                	mov    %al,(%edx)
		start++ ;
  8011d5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011e1:	7c c4                	jl     8011a7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e9:	01 d0                	add    %edx,%eax
  8011eb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ee:	90                   	nop
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011f7:	ff 75 08             	pushl  0x8(%ebp)
  8011fa:	e8 73 fa ff ff       	call   800c72 <strlen>
  8011ff:	83 c4 04             	add    $0x4,%esp
  801202:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801205:	ff 75 0c             	pushl  0xc(%ebp)
  801208:	e8 65 fa ff ff       	call   800c72 <strlen>
  80120d:	83 c4 04             	add    $0x4,%esp
  801210:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801213:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80121a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801221:	eb 17                	jmp    80123a <strcconcat+0x49>
		final[s] = str1[s] ;
  801223:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801226:	8b 45 10             	mov    0x10(%ebp),%eax
  801229:	01 c2                	add    %eax,%edx
  80122b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	01 c8                	add    %ecx,%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801237:	ff 45 fc             	incl   -0x4(%ebp)
  80123a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801240:	7c e1                	jl     801223 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801242:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801249:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801250:	eb 1f                	jmp    801271 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	8d 50 01             	lea    0x1(%eax),%edx
  801258:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125b:	89 c2                	mov    %eax,%edx
  80125d:	8b 45 10             	mov    0x10(%ebp),%eax
  801260:	01 c2                	add    %eax,%edx
  801262:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 c8                	add    %ecx,%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80126e:	ff 45 f8             	incl   -0x8(%ebp)
  801271:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801274:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801277:	7c d9                	jl     801252 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	c6 00 00             	movb   $0x0,(%eax)
}
  801284:	90                   	nop
  801285:	c9                   	leave  
  801286:	c3                   	ret    

00801287 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80128a:	8b 45 14             	mov    0x14(%ebp),%eax
  80128d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	01 d0                	add    %edx,%eax
  8012a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012aa:	eb 0c                	jmp    8012b8 <strsplit+0x31>
			*string++ = 0;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	8d 50 01             	lea    0x1(%eax),%edx
  8012b2:	89 55 08             	mov    %edx,0x8(%ebp)
  8012b5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	84 c0                	test   %al,%al
  8012bf:	74 18                	je     8012d9 <strsplit+0x52>
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	0f be c0             	movsbl %al,%eax
  8012c9:	50                   	push   %eax
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	e8 32 fb ff ff       	call   800e04 <strchr>
  8012d2:	83 c4 08             	add    $0x8,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	75 d3                	jne    8012ac <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	84 c0                	test   %al,%al
  8012e0:	74 5a                	je     80133c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e5:	8b 00                	mov    (%eax),%eax
  8012e7:	83 f8 0f             	cmp    $0xf,%eax
  8012ea:	75 07                	jne    8012f3 <strsplit+0x6c>
		{
			return 0;
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f1:	eb 66                	jmp    801359 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f6:	8b 00                	mov    (%eax),%eax
  8012f8:	8d 48 01             	lea    0x1(%eax),%ecx
  8012fb:	8b 55 14             	mov    0x14(%ebp),%edx
  8012fe:	89 0a                	mov    %ecx,(%edx)
  801300:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801307:	8b 45 10             	mov    0x10(%ebp),%eax
  80130a:	01 c2                	add    %eax,%edx
  80130c:	8b 45 08             	mov    0x8(%ebp),%eax
  80130f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801311:	eb 03                	jmp    801316 <strsplit+0x8f>
			string++;
  801313:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	8a 00                	mov    (%eax),%al
  80131b:	84 c0                	test   %al,%al
  80131d:	74 8b                	je     8012aa <strsplit+0x23>
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f be c0             	movsbl %al,%eax
  801327:	50                   	push   %eax
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	e8 d4 fa ff ff       	call   800e04 <strchr>
  801330:	83 c4 08             	add    $0x8,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	74 dc                	je     801313 <strsplit+0x8c>
			string++;
	}
  801337:	e9 6e ff ff ff       	jmp    8012aa <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80133c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80133d:	8b 45 14             	mov    0x14(%ebp),%eax
  801340:	8b 00                	mov    (%eax),%eax
  801342:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801349:	8b 45 10             	mov    0x10(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801354:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801359:	c9                   	leave  
  80135a:	c3                   	ret    

0080135b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801361:	83 ec 04             	sub    $0x4,%esp
  801364:	68 3c 24 80 00       	push   $0x80243c
  801369:	68 3f 01 00 00       	push   $0x13f
  80136e:	68 5e 24 80 00       	push   $0x80245e
  801373:	e8 93 07 00 00       	call   801b0b <_panic>

00801378 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80137e:	83 ec 0c             	sub    $0xc,%esp
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	e8 ef 06 00 00       	call   801a78 <sys_sbrk>
  801389:	83 c4 10             	add    $0x10,%esp
}
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801394:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801398:	75 07                	jne    8013a1 <malloc+0x13>
  80139a:	b8 00 00 00 00       	mov    $0x0,%eax
  80139f:	eb 14                	jmp    8013b5 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8013a1:	83 ec 04             	sub    $0x4,%esp
  8013a4:	68 6c 24 80 00       	push   $0x80246c
  8013a9:	6a 1b                	push   $0x1b
  8013ab:	68 91 24 80 00       	push   $0x802491
  8013b0:	e8 56 07 00 00       	call   801b0b <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8013bd:	83 ec 04             	sub    $0x4,%esp
  8013c0:	68 a0 24 80 00       	push   $0x8024a0
  8013c5:	6a 29                	push   $0x29
  8013c7:	68 91 24 80 00       	push   $0x802491
  8013cc:	e8 3a 07 00 00       	call   801b0b <_panic>

008013d1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	83 ec 18             	sub    $0x18,%esp
  8013d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013da:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8013dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013e1:	75 07                	jne    8013ea <smalloc+0x19>
  8013e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e8:	eb 14                	jmp    8013fe <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8013ea:	83 ec 04             	sub    $0x4,%esp
  8013ed:	68 c4 24 80 00       	push   $0x8024c4
  8013f2:	6a 38                	push   $0x38
  8013f4:	68 91 24 80 00       	push   $0x802491
  8013f9:	e8 0d 07 00 00       	call   801b0b <_panic>
	return NULL;
}
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    

00801400 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
  801403:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801406:	83 ec 04             	sub    $0x4,%esp
  801409:	68 ec 24 80 00       	push   $0x8024ec
  80140e:	6a 43                	push   $0x43
  801410:	68 91 24 80 00       	push   $0x802491
  801415:	e8 f1 06 00 00       	call   801b0b <_panic>

0080141a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801420:	83 ec 04             	sub    $0x4,%esp
  801423:	68 10 25 80 00       	push   $0x802510
  801428:	6a 5b                	push   $0x5b
  80142a:	68 91 24 80 00       	push   $0x802491
  80142f:	e8 d7 06 00 00       	call   801b0b <_panic>

00801434 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	68 34 25 80 00       	push   $0x802534
  801442:	6a 72                	push   $0x72
  801444:	68 91 24 80 00       	push   $0x802491
  801449:	e8 bd 06 00 00       	call   801b0b <_panic>

0080144e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801454:	83 ec 04             	sub    $0x4,%esp
  801457:	68 5a 25 80 00       	push   $0x80255a
  80145c:	6a 7e                	push   $0x7e
  80145e:	68 91 24 80 00       	push   $0x802491
  801463:	e8 a3 06 00 00       	call   801b0b <_panic>

00801468 <shrink>:

}
void shrink(uint32 newSize)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
  80146b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80146e:	83 ec 04             	sub    $0x4,%esp
  801471:	68 5a 25 80 00       	push   $0x80255a
  801476:	68 83 00 00 00       	push   $0x83
  80147b:	68 91 24 80 00       	push   $0x802491
  801480:	e8 86 06 00 00       	call   801b0b <_panic>

00801485 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	68 5a 25 80 00       	push   $0x80255a
  801493:	68 88 00 00 00       	push   $0x88
  801498:	68 91 24 80 00       	push   $0x802491
  80149d:	e8 69 06 00 00       	call   801b0b <_panic>

008014a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	57                   	push   %edi
  8014a6:	56                   	push   %esi
  8014a7:	53                   	push   %ebx
  8014a8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014ba:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014bd:	cd 30                	int    $0x30
  8014bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	5b                   	pop    %ebx
  8014c9:	5e                   	pop    %esi
  8014ca:	5f                   	pop    %edi
  8014cb:	5d                   	pop    %ebp
  8014cc:	c3                   	ret    

008014cd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	83 ec 04             	sub    $0x4,%esp
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014d9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	52                   	push   %edx
  8014e5:	ff 75 0c             	pushl  0xc(%ebp)
  8014e8:	50                   	push   %eax
  8014e9:	6a 00                	push   $0x0
  8014eb:	e8 b2 ff ff ff       	call   8014a2 <syscall>
  8014f0:	83 c4 18             	add    $0x18,%esp
}
  8014f3:	90                   	nop
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 02                	push   $0x2
  801505:	e8 98 ff ff ff       	call   8014a2 <syscall>
  80150a:	83 c4 18             	add    $0x18,%esp
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 03                	push   $0x3
  80151e:	e8 7f ff ff ff       	call   8014a2 <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
}
  801526:	90                   	nop
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 04                	push   $0x4
  801538:	e8 65 ff ff ff       	call   8014a2 <syscall>
  80153d:	83 c4 18             	add    $0x18,%esp
}
  801540:	90                   	nop
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801546:	8b 55 0c             	mov    0xc(%ebp),%edx
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	52                   	push   %edx
  801553:	50                   	push   %eax
  801554:	6a 08                	push   $0x8
  801556:	e8 47 ff ff ff       	call   8014a2 <syscall>
  80155b:	83 c4 18             	add    $0x18,%esp
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	56                   	push   %esi
  801564:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801565:	8b 75 18             	mov    0x18(%ebp),%esi
  801568:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80156b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80156e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	56                   	push   %esi
  801575:	53                   	push   %ebx
  801576:	51                   	push   %ecx
  801577:	52                   	push   %edx
  801578:	50                   	push   %eax
  801579:	6a 09                	push   $0x9
  80157b:	e8 22 ff ff ff       	call   8014a2 <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
}
  801583:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801586:	5b                   	pop    %ebx
  801587:	5e                   	pop    %esi
  801588:	5d                   	pop    %ebp
  801589:	c3                   	ret    

0080158a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80158d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	52                   	push   %edx
  80159a:	50                   	push   %eax
  80159b:	6a 0a                	push   $0xa
  80159d:	e8 00 ff ff ff       	call   8014a2 <syscall>
  8015a2:	83 c4 18             	add    $0x18,%esp
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	ff 75 0c             	pushl  0xc(%ebp)
  8015b3:	ff 75 08             	pushl  0x8(%ebp)
  8015b6:	6a 0b                	push   $0xb
  8015b8:	e8 e5 fe ff ff       	call   8014a2 <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 0c                	push   $0xc
  8015d1:	e8 cc fe ff ff       	call   8014a2 <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 0d                	push   $0xd
  8015ea:	e8 b3 fe ff ff       	call   8014a2 <syscall>
  8015ef:	83 c4 18             	add    $0x18,%esp
}
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 0e                	push   $0xe
  801603:	e8 9a fe ff ff       	call   8014a2 <syscall>
  801608:	83 c4 18             	add    $0x18,%esp
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 0f                	push   $0xf
  80161c:	e8 81 fe ff ff       	call   8014a2 <syscall>
  801621:	83 c4 18             	add    $0x18,%esp
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	ff 75 08             	pushl  0x8(%ebp)
  801634:	6a 10                	push   $0x10
  801636:	e8 67 fe ff ff       	call   8014a2 <syscall>
  80163b:	83 c4 18             	add    $0x18,%esp
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 11                	push   $0x11
  80164f:	e8 4e fe ff ff       	call   8014a2 <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	90                   	nop
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <sys_cputc>:

void
sys_cputc(const char c)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801666:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	50                   	push   %eax
  801673:	6a 01                	push   $0x1
  801675:	e8 28 fe ff ff       	call   8014a2 <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
}
  80167d:	90                   	nop
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 14                	push   $0x14
  80168f:	e8 0e fe ff ff       	call   8014a2 <syscall>
  801694:	83 c4 18             	add    $0x18,%esp
}
  801697:	90                   	nop
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 04             	sub    $0x4,%esp
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016a6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016a9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	6a 00                	push   $0x0
  8016b2:	51                   	push   %ecx
  8016b3:	52                   	push   %edx
  8016b4:	ff 75 0c             	pushl  0xc(%ebp)
  8016b7:	50                   	push   %eax
  8016b8:	6a 15                	push   $0x15
  8016ba:	e8 e3 fd ff ff       	call   8014a2 <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	52                   	push   %edx
  8016d4:	50                   	push   %eax
  8016d5:	6a 16                	push   $0x16
  8016d7:	e8 c6 fd ff ff       	call   8014a2 <syscall>
  8016dc:	83 c4 18             	add    $0x18,%esp
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8016e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	51                   	push   %ecx
  8016f2:	52                   	push   %edx
  8016f3:	50                   	push   %eax
  8016f4:	6a 17                	push   $0x17
  8016f6:	e8 a7 fd ff ff       	call   8014a2 <syscall>
  8016fb:	83 c4 18             	add    $0x18,%esp
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801703:	8b 55 0c             	mov    0xc(%ebp),%edx
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	52                   	push   %edx
  801710:	50                   	push   %eax
  801711:	6a 18                	push   $0x18
  801713:	e8 8a fd ff ff       	call   8014a2 <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	6a 00                	push   $0x0
  801725:	ff 75 14             	pushl  0x14(%ebp)
  801728:	ff 75 10             	pushl  0x10(%ebp)
  80172b:	ff 75 0c             	pushl  0xc(%ebp)
  80172e:	50                   	push   %eax
  80172f:	6a 19                	push   $0x19
  801731:	e8 6c fd ff ff       	call   8014a2 <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	50                   	push   %eax
  80174a:	6a 1a                	push   $0x1a
  80174c:	e8 51 fd ff ff       	call   8014a2 <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	90                   	nop
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	50                   	push   %eax
  801766:	6a 1b                	push   $0x1b
  801768:	e8 35 fd ff ff       	call   8014a2 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 05                	push   $0x5
  801781:	e8 1c fd ff ff       	call   8014a2 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 06                	push   $0x6
  80179a:	e8 03 fd ff ff       	call   8014a2 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 07                	push   $0x7
  8017b3:	e8 ea fc ff ff       	call   8014a2 <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <sys_exit_env>:


void sys_exit_env(void)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 1c                	push   $0x1c
  8017cc:	e8 d1 fc ff ff       	call   8014a2 <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
}
  8017d4:	90                   	nop
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8017dd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017e0:	8d 50 04             	lea    0x4(%eax),%edx
  8017e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	52                   	push   %edx
  8017ed:	50                   	push   %eax
  8017ee:	6a 1d                	push   $0x1d
  8017f0:	e8 ad fc ff ff       	call   8014a2 <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
	return result;
  8017f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801801:	89 01                	mov    %eax,(%ecx)
  801803:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	c9                   	leave  
  80180a:	c2 04 00             	ret    $0x4

0080180d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	ff 75 10             	pushl  0x10(%ebp)
  801817:	ff 75 0c             	pushl  0xc(%ebp)
  80181a:	ff 75 08             	pushl  0x8(%ebp)
  80181d:	6a 13                	push   $0x13
  80181f:	e8 7e fc ff ff       	call   8014a2 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
	return ;
  801827:	90                   	nop
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_rcr2>:
uint32 sys_rcr2()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 1e                	push   $0x1e
  801839:	e8 64 fc ff ff       	call   8014a2 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 04             	sub    $0x4,%esp
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80184f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	50                   	push   %eax
  80185c:	6a 1f                	push   $0x1f
  80185e:	e8 3f fc ff ff       	call   8014a2 <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
	return ;
  801866:	90                   	nop
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <rsttst>:
void rsttst()
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 21                	push   $0x21
  801878:	e8 25 fc ff ff       	call   8014a2 <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
	return ;
  801880:	90                   	nop
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	8b 45 14             	mov    0x14(%ebp),%eax
  80188c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80188f:	8b 55 18             	mov    0x18(%ebp),%edx
  801892:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801896:	52                   	push   %edx
  801897:	50                   	push   %eax
  801898:	ff 75 10             	pushl  0x10(%ebp)
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	6a 20                	push   $0x20
  8018a3:	e8 fa fb ff ff       	call   8014a2 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ab:	90                   	nop
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <chktst>:
void chktst(uint32 n)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	ff 75 08             	pushl  0x8(%ebp)
  8018bc:	6a 22                	push   $0x22
  8018be:	e8 df fb ff ff       	call   8014a2 <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c6:	90                   	nop
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <inctst>:

void inctst()
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 23                	push   $0x23
  8018d8:	e8 c5 fb ff ff       	call   8014a2 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e0:	90                   	nop
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <gettst>:
uint32 gettst()
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 24                	push   $0x24
  8018f2:	e8 ab fb ff ff       	call   8014a2 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 25                	push   $0x25
  80190e:	e8 8f fb ff ff       	call   8014a2 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
  801916:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801919:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80191d:	75 07                	jne    801926 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80191f:	b8 01 00 00 00       	mov    $0x1,%eax
  801924:	eb 05                	jmp    80192b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801926:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 25                	push   $0x25
  80193f:	e8 5e fb ff ff       	call   8014a2 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
  801947:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80194a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80194e:	75 07                	jne    801957 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801950:	b8 01 00 00 00       	mov    $0x1,%eax
  801955:	eb 05                	jmp    80195c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801957:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 25                	push   $0x25
  801970:	e8 2d fb ff ff       	call   8014a2 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
  801978:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80197b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80197f:	75 07                	jne    801988 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801981:	b8 01 00 00 00       	mov    $0x1,%eax
  801986:	eb 05                	jmp    80198d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801988:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 25                	push   $0x25
  8019a1:	e8 fc fa ff ff       	call   8014a2 <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
  8019a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8019ac:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8019b0:	75 07                	jne    8019b9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8019b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b7:	eb 05                	jmp    8019be <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	ff 75 08             	pushl  0x8(%ebp)
  8019ce:	6a 26                	push   $0x26
  8019d0:	e8 cd fa ff ff       	call   8014a2 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d8:	90                   	nop
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8019df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	6a 00                	push   $0x0
  8019ed:	53                   	push   %ebx
  8019ee:	51                   	push   %ecx
  8019ef:	52                   	push   %edx
  8019f0:	50                   	push   %eax
  8019f1:	6a 27                	push   $0x27
  8019f3:	e8 aa fa ff ff       	call   8014a2 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	52                   	push   %edx
  801a10:	50                   	push   %eax
  801a11:	6a 28                	push   $0x28
  801a13:	e8 8a fa ff ff       	call   8014a2 <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801a20:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	6a 00                	push   $0x0
  801a2b:	51                   	push   %ecx
  801a2c:	ff 75 10             	pushl  0x10(%ebp)
  801a2f:	52                   	push   %edx
  801a30:	50                   	push   %eax
  801a31:	6a 29                	push   $0x29
  801a33:	e8 6a fa ff ff       	call   8014a2 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	ff 75 10             	pushl  0x10(%ebp)
  801a47:	ff 75 0c             	pushl  0xc(%ebp)
  801a4a:	ff 75 08             	pushl  0x8(%ebp)
  801a4d:	6a 12                	push   $0x12
  801a4f:	e8 4e fa ff ff       	call   8014a2 <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
	return ;
  801a57:	90                   	nop
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	52                   	push   %edx
  801a6a:	50                   	push   %eax
  801a6b:	6a 2a                	push   $0x2a
  801a6d:	e8 30 fa ff ff       	call   8014a2 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
	return;
  801a75:	90                   	nop
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801a7e:	83 ec 04             	sub    $0x4,%esp
  801a81:	68 6a 25 80 00       	push   $0x80256a
  801a86:	68 2e 01 00 00       	push   $0x12e
  801a8b:	68 7e 25 80 00       	push   $0x80257e
  801a90:	e8 76 00 00 00       	call   801b0b <_panic>

00801a95 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801a9b:	83 ec 04             	sub    $0x4,%esp
  801a9e:	68 6a 25 80 00       	push   $0x80256a
  801aa3:	68 35 01 00 00       	push   $0x135
  801aa8:	68 7e 25 80 00       	push   $0x80257e
  801aad:	e8 59 00 00 00       	call   801b0b <_panic>

00801ab2 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801ab8:	83 ec 04             	sub    $0x4,%esp
  801abb:	68 6a 25 80 00       	push   $0x80256a
  801ac0:	68 3b 01 00 00       	push   $0x13b
  801ac5:	68 7e 25 80 00       	push   $0x80257e
  801aca:	e8 3c 00 00 00       	call   801b0b <_panic>

00801acf <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801adb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801adf:	83 ec 0c             	sub    $0xc,%esp
  801ae2:	50                   	push   %eax
  801ae3:	e8 72 fb ff ff       	call   80165a <sys_cputc>
  801ae8:	83 c4 10             	add    $0x10,%esp
}
  801aeb:	90                   	nop
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <getchar>:


int
getchar(void)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801af4:	e8 fd f9 ff ff       	call   8014f6 <sys_cgetc>
  801af9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <iscons>:

int iscons(int fdnum)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801b04:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b09:	5d                   	pop    %ebp
  801b0a:	c3                   	ret    

00801b0b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801b11:	8d 45 10             	lea    0x10(%ebp),%eax
  801b14:	83 c0 04             	add    $0x4,%eax
  801b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801b1a:	a1 24 30 80 00       	mov    0x803024,%eax
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	74 16                	je     801b39 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801b23:	a1 24 30 80 00       	mov    0x803024,%eax
  801b28:	83 ec 08             	sub    $0x8,%esp
  801b2b:	50                   	push   %eax
  801b2c:	68 8c 25 80 00       	push   $0x80258c
  801b31:	e8 a0 e8 ff ff       	call   8003d6 <cprintf>
  801b36:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801b39:	a1 00 30 80 00       	mov    0x803000,%eax
  801b3e:	ff 75 0c             	pushl  0xc(%ebp)
  801b41:	ff 75 08             	pushl  0x8(%ebp)
  801b44:	50                   	push   %eax
  801b45:	68 91 25 80 00       	push   $0x802591
  801b4a:	e8 87 e8 ff ff       	call   8003d6 <cprintf>
  801b4f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801b52:	8b 45 10             	mov    0x10(%ebp),%eax
  801b55:	83 ec 08             	sub    $0x8,%esp
  801b58:	ff 75 f4             	pushl  -0xc(%ebp)
  801b5b:	50                   	push   %eax
  801b5c:	e8 0a e8 ff ff       	call   80036b <vcprintf>
  801b61:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801b64:	83 ec 08             	sub    $0x8,%esp
  801b67:	6a 00                	push   $0x0
  801b69:	68 ad 25 80 00       	push   $0x8025ad
  801b6e:	e8 f8 e7 ff ff       	call   80036b <vcprintf>
  801b73:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801b76:	e8 79 e7 ff ff       	call   8002f4 <exit>

	// should not return here
	while (1) ;
  801b7b:	eb fe                	jmp    801b7b <_panic+0x70>

00801b7d <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801b83:	a1 04 30 80 00       	mov    0x803004,%eax
  801b88:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b91:	39 c2                	cmp    %eax,%edx
  801b93:	74 14                	je     801ba9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	68 b0 25 80 00       	push   $0x8025b0
  801b9d:	6a 26                	push   $0x26
  801b9f:	68 fc 25 80 00       	push   $0x8025fc
  801ba4:	e8 62 ff ff ff       	call   801b0b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801ba9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801bb0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801bb7:	e9 c5 00 00 00       	jmp    801c81 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	01 d0                	add    %edx,%eax
  801bcb:	8b 00                	mov    (%eax),%eax
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	75 08                	jne    801bd9 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801bd1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801bd4:	e9 a5 00 00 00       	jmp    801c7e <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801bd9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801be0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801be7:	eb 69                	jmp    801c52 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801be9:	a1 04 30 80 00       	mov    0x803004,%eax
  801bee:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801bf4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bf7:	89 d0                	mov    %edx,%eax
  801bf9:	01 c0                	add    %eax,%eax
  801bfb:	01 d0                	add    %edx,%eax
  801bfd:	c1 e0 03             	shl    $0x3,%eax
  801c00:	01 c8                	add    %ecx,%eax
  801c02:	8a 40 04             	mov    0x4(%eax),%al
  801c05:	84 c0                	test   %al,%al
  801c07:	75 46                	jne    801c4f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801c09:	a1 04 30 80 00       	mov    0x803004,%eax
  801c0e:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801c14:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c17:	89 d0                	mov    %edx,%eax
  801c19:	01 c0                	add    %eax,%eax
  801c1b:	01 d0                	add    %edx,%eax
  801c1d:	c1 e0 03             	shl    $0x3,%eax
  801c20:	01 c8                	add    %ecx,%eax
  801c22:	8b 00                	mov    (%eax),%eax
  801c24:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c2a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c2f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c34:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	01 c8                	add    %ecx,%eax
  801c40:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801c42:	39 c2                	cmp    %eax,%edx
  801c44:	75 09                	jne    801c4f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801c46:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801c4d:	eb 15                	jmp    801c64 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c4f:	ff 45 e8             	incl   -0x18(%ebp)
  801c52:	a1 04 30 80 00       	mov    0x803004,%eax
  801c57:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801c5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c60:	39 c2                	cmp    %eax,%edx
  801c62:	77 85                	ja     801be9 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801c64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c68:	75 14                	jne    801c7e <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	68 08 26 80 00       	push   $0x802608
  801c72:	6a 3a                	push   $0x3a
  801c74:	68 fc 25 80 00       	push   $0x8025fc
  801c79:	e8 8d fe ff ff       	call   801b0b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801c7e:	ff 45 f0             	incl   -0x10(%ebp)
  801c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c84:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801c87:	0f 8c 2f ff ff ff    	jl     801bbc <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801c8d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801c94:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801c9b:	eb 26                	jmp    801cc3 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801c9d:	a1 04 30 80 00       	mov    0x803004,%eax
  801ca2:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801ca8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cab:	89 d0                	mov    %edx,%eax
  801cad:	01 c0                	add    %eax,%eax
  801caf:	01 d0                	add    %edx,%eax
  801cb1:	c1 e0 03             	shl    $0x3,%eax
  801cb4:	01 c8                	add    %ecx,%eax
  801cb6:	8a 40 04             	mov    0x4(%eax),%al
  801cb9:	3c 01                	cmp    $0x1,%al
  801cbb:	75 03                	jne    801cc0 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801cbd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801cc0:	ff 45 e0             	incl   -0x20(%ebp)
  801cc3:	a1 04 30 80 00       	mov    0x803004,%eax
  801cc8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801cce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cd1:	39 c2                	cmp    %eax,%edx
  801cd3:	77 c8                	ja     801c9d <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801cdb:	74 14                	je     801cf1 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	68 5c 26 80 00       	push   $0x80265c
  801ce5:	6a 44                	push   $0x44
  801ce7:	68 fc 25 80 00       	push   $0x8025fc
  801cec:	e8 1a fe ff ff       	call   801b0b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801cf1:	90                   	nop
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <__udivdi3>:
  801cf4:	55                   	push   %ebp
  801cf5:	57                   	push   %edi
  801cf6:	56                   	push   %esi
  801cf7:	53                   	push   %ebx
  801cf8:	83 ec 1c             	sub    $0x1c,%esp
  801cfb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d0b:	89 ca                	mov    %ecx,%edx
  801d0d:	89 f8                	mov    %edi,%eax
  801d0f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d13:	85 f6                	test   %esi,%esi
  801d15:	75 2d                	jne    801d44 <__udivdi3+0x50>
  801d17:	39 cf                	cmp    %ecx,%edi
  801d19:	77 65                	ja     801d80 <__udivdi3+0x8c>
  801d1b:	89 fd                	mov    %edi,%ebp
  801d1d:	85 ff                	test   %edi,%edi
  801d1f:	75 0b                	jne    801d2c <__udivdi3+0x38>
  801d21:	b8 01 00 00 00       	mov    $0x1,%eax
  801d26:	31 d2                	xor    %edx,%edx
  801d28:	f7 f7                	div    %edi
  801d2a:	89 c5                	mov    %eax,%ebp
  801d2c:	31 d2                	xor    %edx,%edx
  801d2e:	89 c8                	mov    %ecx,%eax
  801d30:	f7 f5                	div    %ebp
  801d32:	89 c1                	mov    %eax,%ecx
  801d34:	89 d8                	mov    %ebx,%eax
  801d36:	f7 f5                	div    %ebp
  801d38:	89 cf                	mov    %ecx,%edi
  801d3a:	89 fa                	mov    %edi,%edx
  801d3c:	83 c4 1c             	add    $0x1c,%esp
  801d3f:	5b                   	pop    %ebx
  801d40:	5e                   	pop    %esi
  801d41:	5f                   	pop    %edi
  801d42:	5d                   	pop    %ebp
  801d43:	c3                   	ret    
  801d44:	39 ce                	cmp    %ecx,%esi
  801d46:	77 28                	ja     801d70 <__udivdi3+0x7c>
  801d48:	0f bd fe             	bsr    %esi,%edi
  801d4b:	83 f7 1f             	xor    $0x1f,%edi
  801d4e:	75 40                	jne    801d90 <__udivdi3+0x9c>
  801d50:	39 ce                	cmp    %ecx,%esi
  801d52:	72 0a                	jb     801d5e <__udivdi3+0x6a>
  801d54:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801d58:	0f 87 9e 00 00 00    	ja     801dfc <__udivdi3+0x108>
  801d5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d63:	89 fa                	mov    %edi,%edx
  801d65:	83 c4 1c             	add    $0x1c,%esp
  801d68:	5b                   	pop    %ebx
  801d69:	5e                   	pop    %esi
  801d6a:	5f                   	pop    %edi
  801d6b:	5d                   	pop    %ebp
  801d6c:	c3                   	ret    
  801d6d:	8d 76 00             	lea    0x0(%esi),%esi
  801d70:	31 ff                	xor    %edi,%edi
  801d72:	31 c0                	xor    %eax,%eax
  801d74:	89 fa                	mov    %edi,%edx
  801d76:	83 c4 1c             	add    $0x1c,%esp
  801d79:	5b                   	pop    %ebx
  801d7a:	5e                   	pop    %esi
  801d7b:	5f                   	pop    %edi
  801d7c:	5d                   	pop    %ebp
  801d7d:	c3                   	ret    
  801d7e:	66 90                	xchg   %ax,%ax
  801d80:	89 d8                	mov    %ebx,%eax
  801d82:	f7 f7                	div    %edi
  801d84:	31 ff                	xor    %edi,%edi
  801d86:	89 fa                	mov    %edi,%edx
  801d88:	83 c4 1c             	add    $0x1c,%esp
  801d8b:	5b                   	pop    %ebx
  801d8c:	5e                   	pop    %esi
  801d8d:	5f                   	pop    %edi
  801d8e:	5d                   	pop    %ebp
  801d8f:	c3                   	ret    
  801d90:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d95:	89 eb                	mov    %ebp,%ebx
  801d97:	29 fb                	sub    %edi,%ebx
  801d99:	89 f9                	mov    %edi,%ecx
  801d9b:	d3 e6                	shl    %cl,%esi
  801d9d:	89 c5                	mov    %eax,%ebp
  801d9f:	88 d9                	mov    %bl,%cl
  801da1:	d3 ed                	shr    %cl,%ebp
  801da3:	89 e9                	mov    %ebp,%ecx
  801da5:	09 f1                	or     %esi,%ecx
  801da7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801dab:	89 f9                	mov    %edi,%ecx
  801dad:	d3 e0                	shl    %cl,%eax
  801daf:	89 c5                	mov    %eax,%ebp
  801db1:	89 d6                	mov    %edx,%esi
  801db3:	88 d9                	mov    %bl,%cl
  801db5:	d3 ee                	shr    %cl,%esi
  801db7:	89 f9                	mov    %edi,%ecx
  801db9:	d3 e2                	shl    %cl,%edx
  801dbb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dbf:	88 d9                	mov    %bl,%cl
  801dc1:	d3 e8                	shr    %cl,%eax
  801dc3:	09 c2                	or     %eax,%edx
  801dc5:	89 d0                	mov    %edx,%eax
  801dc7:	89 f2                	mov    %esi,%edx
  801dc9:	f7 74 24 0c          	divl   0xc(%esp)
  801dcd:	89 d6                	mov    %edx,%esi
  801dcf:	89 c3                	mov    %eax,%ebx
  801dd1:	f7 e5                	mul    %ebp
  801dd3:	39 d6                	cmp    %edx,%esi
  801dd5:	72 19                	jb     801df0 <__udivdi3+0xfc>
  801dd7:	74 0b                	je     801de4 <__udivdi3+0xf0>
  801dd9:	89 d8                	mov    %ebx,%eax
  801ddb:	31 ff                	xor    %edi,%edi
  801ddd:	e9 58 ff ff ff       	jmp    801d3a <__udivdi3+0x46>
  801de2:	66 90                	xchg   %ax,%ax
  801de4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801de8:	89 f9                	mov    %edi,%ecx
  801dea:	d3 e2                	shl    %cl,%edx
  801dec:	39 c2                	cmp    %eax,%edx
  801dee:	73 e9                	jae    801dd9 <__udivdi3+0xe5>
  801df0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801df3:	31 ff                	xor    %edi,%edi
  801df5:	e9 40 ff ff ff       	jmp    801d3a <__udivdi3+0x46>
  801dfa:	66 90                	xchg   %ax,%ax
  801dfc:	31 c0                	xor    %eax,%eax
  801dfe:	e9 37 ff ff ff       	jmp    801d3a <__udivdi3+0x46>
  801e03:	90                   	nop

00801e04 <__umoddi3>:
  801e04:	55                   	push   %ebp
  801e05:	57                   	push   %edi
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	83 ec 1c             	sub    $0x1c,%esp
  801e0b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e17:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e23:	89 f3                	mov    %esi,%ebx
  801e25:	89 fa                	mov    %edi,%edx
  801e27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e2b:	89 34 24             	mov    %esi,(%esp)
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	75 1a                	jne    801e4c <__umoddi3+0x48>
  801e32:	39 f7                	cmp    %esi,%edi
  801e34:	0f 86 a2 00 00 00    	jbe    801edc <__umoddi3+0xd8>
  801e3a:	89 c8                	mov    %ecx,%eax
  801e3c:	89 f2                	mov    %esi,%edx
  801e3e:	f7 f7                	div    %edi
  801e40:	89 d0                	mov    %edx,%eax
  801e42:	31 d2                	xor    %edx,%edx
  801e44:	83 c4 1c             	add    $0x1c,%esp
  801e47:	5b                   	pop    %ebx
  801e48:	5e                   	pop    %esi
  801e49:	5f                   	pop    %edi
  801e4a:	5d                   	pop    %ebp
  801e4b:	c3                   	ret    
  801e4c:	39 f0                	cmp    %esi,%eax
  801e4e:	0f 87 ac 00 00 00    	ja     801f00 <__umoddi3+0xfc>
  801e54:	0f bd e8             	bsr    %eax,%ebp
  801e57:	83 f5 1f             	xor    $0x1f,%ebp
  801e5a:	0f 84 ac 00 00 00    	je     801f0c <__umoddi3+0x108>
  801e60:	bf 20 00 00 00       	mov    $0x20,%edi
  801e65:	29 ef                	sub    %ebp,%edi
  801e67:	89 fe                	mov    %edi,%esi
  801e69:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801e6d:	89 e9                	mov    %ebp,%ecx
  801e6f:	d3 e0                	shl    %cl,%eax
  801e71:	89 d7                	mov    %edx,%edi
  801e73:	89 f1                	mov    %esi,%ecx
  801e75:	d3 ef                	shr    %cl,%edi
  801e77:	09 c7                	or     %eax,%edi
  801e79:	89 e9                	mov    %ebp,%ecx
  801e7b:	d3 e2                	shl    %cl,%edx
  801e7d:	89 14 24             	mov    %edx,(%esp)
  801e80:	89 d8                	mov    %ebx,%eax
  801e82:	d3 e0                	shl    %cl,%eax
  801e84:	89 c2                	mov    %eax,%edx
  801e86:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e8a:	d3 e0                	shl    %cl,%eax
  801e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e90:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e94:	89 f1                	mov    %esi,%ecx
  801e96:	d3 e8                	shr    %cl,%eax
  801e98:	09 d0                	or     %edx,%eax
  801e9a:	d3 eb                	shr    %cl,%ebx
  801e9c:	89 da                	mov    %ebx,%edx
  801e9e:	f7 f7                	div    %edi
  801ea0:	89 d3                	mov    %edx,%ebx
  801ea2:	f7 24 24             	mull   (%esp)
  801ea5:	89 c6                	mov    %eax,%esi
  801ea7:	89 d1                	mov    %edx,%ecx
  801ea9:	39 d3                	cmp    %edx,%ebx
  801eab:	0f 82 87 00 00 00    	jb     801f38 <__umoddi3+0x134>
  801eb1:	0f 84 91 00 00 00    	je     801f48 <__umoddi3+0x144>
  801eb7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ebb:	29 f2                	sub    %esi,%edx
  801ebd:	19 cb                	sbb    %ecx,%ebx
  801ebf:	89 d8                	mov    %ebx,%eax
  801ec1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ec5:	d3 e0                	shl    %cl,%eax
  801ec7:	89 e9                	mov    %ebp,%ecx
  801ec9:	d3 ea                	shr    %cl,%edx
  801ecb:	09 d0                	or     %edx,%eax
  801ecd:	89 e9                	mov    %ebp,%ecx
  801ecf:	d3 eb                	shr    %cl,%ebx
  801ed1:	89 da                	mov    %ebx,%edx
  801ed3:	83 c4 1c             	add    $0x1c,%esp
  801ed6:	5b                   	pop    %ebx
  801ed7:	5e                   	pop    %esi
  801ed8:	5f                   	pop    %edi
  801ed9:	5d                   	pop    %ebp
  801eda:	c3                   	ret    
  801edb:	90                   	nop
  801edc:	89 fd                	mov    %edi,%ebp
  801ede:	85 ff                	test   %edi,%edi
  801ee0:	75 0b                	jne    801eed <__umoddi3+0xe9>
  801ee2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee7:	31 d2                	xor    %edx,%edx
  801ee9:	f7 f7                	div    %edi
  801eeb:	89 c5                	mov    %eax,%ebp
  801eed:	89 f0                	mov    %esi,%eax
  801eef:	31 d2                	xor    %edx,%edx
  801ef1:	f7 f5                	div    %ebp
  801ef3:	89 c8                	mov    %ecx,%eax
  801ef5:	f7 f5                	div    %ebp
  801ef7:	89 d0                	mov    %edx,%eax
  801ef9:	e9 44 ff ff ff       	jmp    801e42 <__umoddi3+0x3e>
  801efe:	66 90                	xchg   %ax,%ax
  801f00:	89 c8                	mov    %ecx,%eax
  801f02:	89 f2                	mov    %esi,%edx
  801f04:	83 c4 1c             	add    $0x1c,%esp
  801f07:	5b                   	pop    %ebx
  801f08:	5e                   	pop    %esi
  801f09:	5f                   	pop    %edi
  801f0a:	5d                   	pop    %ebp
  801f0b:	c3                   	ret    
  801f0c:	3b 04 24             	cmp    (%esp),%eax
  801f0f:	72 06                	jb     801f17 <__umoddi3+0x113>
  801f11:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801f15:	77 0f                	ja     801f26 <__umoddi3+0x122>
  801f17:	89 f2                	mov    %esi,%edx
  801f19:	29 f9                	sub    %edi,%ecx
  801f1b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f1f:	89 14 24             	mov    %edx,(%esp)
  801f22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f26:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f2a:	8b 14 24             	mov    (%esp),%edx
  801f2d:	83 c4 1c             	add    $0x1c,%esp
  801f30:	5b                   	pop    %ebx
  801f31:	5e                   	pop    %esi
  801f32:	5f                   	pop    %edi
  801f33:	5d                   	pop    %ebp
  801f34:	c3                   	ret    
  801f35:	8d 76 00             	lea    0x0(%esi),%esi
  801f38:	2b 04 24             	sub    (%esp),%eax
  801f3b:	19 fa                	sbb    %edi,%edx
  801f3d:	89 d1                	mov    %edx,%ecx
  801f3f:	89 c6                	mov    %eax,%esi
  801f41:	e9 71 ff ff ff       	jmp    801eb7 <__umoddi3+0xb3>
  801f46:	66 90                	xchg   %ax,%ax
  801f48:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801f4c:	72 ea                	jb     801f38 <__umoddi3+0x134>
  801f4e:	89 d9                	mov    %ebx,%ecx
  801f50:	e9 62 ff ff ff       	jmp    801eb7 <__umoddi3+0xb3>
