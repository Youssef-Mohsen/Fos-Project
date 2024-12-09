
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 ab 10 00 00       	call   8010fb <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 a0 3b 80 00       	push   $0x803ba0
  800061:	e8 12 03 00 00       	call   800378 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 b3 3b 80 00       	push   $0x803bb3
  8000be:	e8 b5 02 00 00       	call   800378 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 3e 12 00 00       	call   80131a <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 11 10 00 00       	call   8010fb <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 b3 3b 80 00       	push   $0x803bb3
  800114:	e8 5f 02 00 00       	call   800378 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 e8 11 00 00       	call   80131a <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 be 17 00 00       	call   801901 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800157:	01 c8                	add    %ecx,%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	01 d0                	add    %edx,%eax
  80015d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800164:	01 c8                	add    %ecx,%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80016d:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800172:	a1 20 50 80 00       	mov    0x805020,%eax
  800177:	8a 40 20             	mov    0x20(%eax),%al
  80017a:	84 c0                	test   %al,%al
  80017c:	74 0d                	je     80018b <libmain+0x53>
		binaryname = myEnv->prog_name;
  80017e:	a1 20 50 80 00       	mov    0x805020,%eax
  800183:	83 c0 20             	add    $0x20,%eax
  800186:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018f:	7e 0a                	jle    80019b <libmain+0x63>
		binaryname = argv[0];
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	e8 8f fe ff ff       	call   800038 <_main>
  8001a9:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001ac:	e8 d4 14 00 00       	call   801685 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 d8 3b 80 00       	push   $0x803bd8
  8001b9:	e8 8d 01 00 00       	call   80034b <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c6:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d1:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	52                   	push   %edx
  8001db:	50                   	push   %eax
  8001dc:	68 00 3c 80 00       	push   $0x803c00
  8001e1:	e8 65 01 00 00       	call   80034b <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ee:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f9:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800204:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80020a:	51                   	push   %ecx
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 28 3c 80 00       	push   $0x803c28
  800212:	e8 34 01 00 00       	call   80034b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 80 3c 80 00       	push   $0x803c80
  80022e:	e8 18 01 00 00       	call   80034b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 d8 3b 80 00       	push   $0x803bd8
  80023e:	e8 08 01 00 00       	call   80034b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800246:	e8 54 14 00 00       	call   80169f <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80024b:	e8 19 00 00 00       	call   800269 <exit>
}
  800250:	90                   	nop
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	6a 00                	push   $0x0
  80025e:	e8 6a 16 00 00       	call   8018cd <sys_destroy_env>
  800263:	83 c4 10             	add    $0x10,%esp
}
  800266:	90                   	nop
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <exit>:

void
exit(void)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026f:	e8 bf 16 00 00       	call   801933 <sys_exit_env>
}
  800274:	90                   	nop
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80027d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800280:	8b 00                	mov    (%eax),%eax
  800282:	8d 48 01             	lea    0x1(%eax),%ecx
  800285:	8b 55 0c             	mov    0xc(%ebp),%edx
  800288:	89 0a                	mov    %ecx,(%edx)
  80028a:	8b 55 08             	mov    0x8(%ebp),%edx
  80028d:	88 d1                	mov    %dl,%cl
  80028f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800292:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800296:	8b 45 0c             	mov    0xc(%ebp),%eax
  800299:	8b 00                	mov    (%eax),%eax
  80029b:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a0:	75 2c                	jne    8002ce <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002a2:	a0 28 50 80 00       	mov    0x805028,%al
  8002a7:	0f b6 c0             	movzbl %al,%eax
  8002aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ad:	8b 12                	mov    (%edx),%edx
  8002af:	89 d1                	mov    %edx,%ecx
  8002b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b4:	83 c2 08             	add    $0x8,%edx
  8002b7:	83 ec 04             	sub    $0x4,%esp
  8002ba:	50                   	push   %eax
  8002bb:	51                   	push   %ecx
  8002bc:	52                   	push   %edx
  8002bd:	e8 81 13 00 00       	call   801643 <sys_cputs>
  8002c2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d1:	8b 40 04             	mov    0x4(%eax),%eax
  8002d4:	8d 50 01             	lea    0x1(%eax),%edx
  8002d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002da:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f0:	00 00 00 
	b.cnt = 0;
  8002f3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002fa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002fd:	ff 75 0c             	pushl  0xc(%ebp)
  800300:	ff 75 08             	pushl  0x8(%ebp)
  800303:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800309:	50                   	push   %eax
  80030a:	68 77 02 80 00       	push   $0x800277
  80030f:	e8 11 02 00 00       	call   800525 <vprintfmt>
  800314:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800317:	a0 28 50 80 00       	mov    0x805028,%al
  80031c:	0f b6 c0             	movzbl %al,%eax
  80031f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	50                   	push   %eax
  800329:	52                   	push   %edx
  80032a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800330:	83 c0 08             	add    $0x8,%eax
  800333:	50                   	push   %eax
  800334:	e8 0a 13 00 00       	call   801643 <sys_cputs>
  800339:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80033c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800343:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800349:	c9                   	leave  
  80034a:	c3                   	ret    

0080034b <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80034b:	55                   	push   %ebp
  80034c:	89 e5                	mov    %esp,%ebp
  80034e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800351:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800358:	8d 45 0c             	lea    0xc(%ebp),%eax
  80035b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80035e:	8b 45 08             	mov    0x8(%ebp),%eax
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	ff 75 f4             	pushl  -0xc(%ebp)
  800367:	50                   	push   %eax
  800368:	e8 73 ff ff ff       	call   8002e0 <vcprintf>
  80036d:	83 c4 10             	add    $0x10,%esp
  800370:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800373:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80037e:	e8 02 13 00 00       	call   801685 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800383:	8d 45 0c             	lea    0xc(%ebp),%eax
  800386:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	ff 75 f4             	pushl  -0xc(%ebp)
  800392:	50                   	push   %eax
  800393:	e8 48 ff ff ff       	call   8002e0 <vcprintf>
  800398:	83 c4 10             	add    $0x10,%esp
  80039b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80039e:	e8 fc 12 00 00       	call   80169f <sys_unlock_cons>
	return cnt;
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	53                   	push   %ebx
  8003ac:	83 ec 14             	sub    $0x14,%esp
  8003af:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003bb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003be:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c6:	77 55                	ja     80041d <printnum+0x75>
  8003c8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003cb:	72 05                	jb     8003d2 <printnum+0x2a>
  8003cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d0:	77 4b                	ja     80041d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003db:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e0:	52                   	push   %edx
  8003e1:	50                   	push   %eax
  8003e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e8:	e8 3f 35 00 00       	call   80392c <__udivdi3>
  8003ed:	83 c4 10             	add    $0x10,%esp
  8003f0:	83 ec 04             	sub    $0x4,%esp
  8003f3:	ff 75 20             	pushl  0x20(%ebp)
  8003f6:	53                   	push   %ebx
  8003f7:	ff 75 18             	pushl  0x18(%ebp)
  8003fa:	52                   	push   %edx
  8003fb:	50                   	push   %eax
  8003fc:	ff 75 0c             	pushl  0xc(%ebp)
  8003ff:	ff 75 08             	pushl  0x8(%ebp)
  800402:	e8 a1 ff ff ff       	call   8003a8 <printnum>
  800407:	83 c4 20             	add    $0x20,%esp
  80040a:	eb 1a                	jmp    800426 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80040c:	83 ec 08             	sub    $0x8,%esp
  80040f:	ff 75 0c             	pushl  0xc(%ebp)
  800412:	ff 75 20             	pushl  0x20(%ebp)
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	ff d0                	call   *%eax
  80041a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041d:	ff 4d 1c             	decl   0x1c(%ebp)
  800420:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800424:	7f e6                	jg     80040c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800426:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800429:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800431:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800434:	53                   	push   %ebx
  800435:	51                   	push   %ecx
  800436:	52                   	push   %edx
  800437:	50                   	push   %eax
  800438:	e8 ff 35 00 00       	call   803a3c <__umoddi3>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	05 b4 3e 80 00       	add    $0x803eb4,%eax
  800445:	8a 00                	mov    (%eax),%al
  800447:	0f be c0             	movsbl %al,%eax
  80044a:	83 ec 08             	sub    $0x8,%esp
  80044d:	ff 75 0c             	pushl  0xc(%ebp)
  800450:	50                   	push   %eax
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	ff d0                	call   *%eax
  800456:	83 c4 10             	add    $0x10,%esp
}
  800459:	90                   	nop
  80045a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800462:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800466:	7e 1c                	jle    800484 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 50 08             	lea    0x8(%eax),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	89 10                	mov    %edx,(%eax)
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	83 e8 08             	sub    $0x8,%eax
  80047d:	8b 50 04             	mov    0x4(%eax),%edx
  800480:	8b 00                	mov    (%eax),%eax
  800482:	eb 40                	jmp    8004c4 <getuint+0x65>
	else if (lflag)
  800484:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800488:	74 1e                	je     8004a8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	8d 50 04             	lea    0x4(%eax),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	89 10                	mov    %edx,(%eax)
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	83 e8 04             	sub    $0x4,%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a6:	eb 1c                	jmp    8004c4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	8d 50 04             	lea    0x4(%eax),%edx
  8004b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b3:	89 10                	mov    %edx,(%eax)
  8004b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	83 e8 04             	sub    $0x4,%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c4:	5d                   	pop    %ebp
  8004c5:	c3                   	ret    

008004c6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004cd:	7e 1c                	jle    8004eb <getint+0x25>
		return va_arg(*ap, long long);
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 50 08             	lea    0x8(%eax),%edx
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	89 10                	mov    %edx,(%eax)
  8004dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	83 e8 08             	sub    $0x8,%eax
  8004e4:	8b 50 04             	mov    0x4(%eax),%edx
  8004e7:	8b 00                	mov    (%eax),%eax
  8004e9:	eb 38                	jmp    800523 <getint+0x5d>
	else if (lflag)
  8004eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ef:	74 1a                	je     80050b <getint+0x45>
		return va_arg(*ap, long);
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	8d 50 04             	lea    0x4(%eax),%edx
  8004f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fc:	89 10                	mov    %edx,(%eax)
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	8b 00                	mov    (%eax),%eax
  800503:	83 e8 04             	sub    $0x4,%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	99                   	cltd   
  800509:	eb 18                	jmp    800523 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	8d 50 04             	lea    0x4(%eax),%edx
  800513:	8b 45 08             	mov    0x8(%ebp),%eax
  800516:	89 10                	mov    %edx,(%eax)
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	83 e8 04             	sub    $0x4,%eax
  800520:	8b 00                	mov    (%eax),%eax
  800522:	99                   	cltd   
}
  800523:	5d                   	pop    %ebp
  800524:	c3                   	ret    

00800525 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	56                   	push   %esi
  800529:	53                   	push   %ebx
  80052a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052d:	eb 17                	jmp    800546 <vprintfmt+0x21>
			if (ch == '\0')
  80052f:	85 db                	test   %ebx,%ebx
  800531:	0f 84 c1 03 00 00    	je     8008f8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	ff 75 0c             	pushl  0xc(%ebp)
  80053d:	53                   	push   %ebx
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	ff d0                	call   *%eax
  800543:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800546:	8b 45 10             	mov    0x10(%ebp),%eax
  800549:	8d 50 01             	lea    0x1(%eax),%edx
  80054c:	89 55 10             	mov    %edx,0x10(%ebp)
  80054f:	8a 00                	mov    (%eax),%al
  800551:	0f b6 d8             	movzbl %al,%ebx
  800554:	83 fb 25             	cmp    $0x25,%ebx
  800557:	75 d6                	jne    80052f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800559:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80055d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800564:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80056b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800572:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800579:	8b 45 10             	mov    0x10(%ebp),%eax
  80057c:	8d 50 01             	lea    0x1(%eax),%edx
  80057f:	89 55 10             	mov    %edx,0x10(%ebp)
  800582:	8a 00                	mov    (%eax),%al
  800584:	0f b6 d8             	movzbl %al,%ebx
  800587:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80058a:	83 f8 5b             	cmp    $0x5b,%eax
  80058d:	0f 87 3d 03 00 00    	ja     8008d0 <vprintfmt+0x3ab>
  800593:	8b 04 85 d8 3e 80 00 	mov    0x803ed8(,%eax,4),%eax
  80059a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80059c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005a0:	eb d7                	jmp    800579 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005a2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005a6:	eb d1                	jmp    800579 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b2:	89 d0                	mov    %edx,%eax
  8005b4:	c1 e0 02             	shl    $0x2,%eax
  8005b7:	01 d0                	add    %edx,%eax
  8005b9:	01 c0                	add    %eax,%eax
  8005bb:	01 d8                	add    %ebx,%eax
  8005bd:	83 e8 30             	sub    $0x30,%eax
  8005c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c6:	8a 00                	mov    (%eax),%al
  8005c8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005cb:	83 fb 2f             	cmp    $0x2f,%ebx
  8005ce:	7e 3e                	jle    80060e <vprintfmt+0xe9>
  8005d0:	83 fb 39             	cmp    $0x39,%ebx
  8005d3:	7f 39                	jg     80060e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d8:	eb d5                	jmp    8005af <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	83 c0 04             	add    $0x4,%eax
  8005e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	83 e8 04             	sub    $0x4,%eax
  8005e9:	8b 00                	mov    (%eax),%eax
  8005eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005ee:	eb 1f                	jmp    80060f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f4:	79 83                	jns    800579 <vprintfmt+0x54>
				width = 0;
  8005f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005fd:	e9 77 ff ff ff       	jmp    800579 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800602:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800609:	e9 6b ff ff ff       	jmp    800579 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80060e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800613:	0f 89 60 ff ff ff    	jns    800579 <vprintfmt+0x54>
				width = precision, precision = -1;
  800619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80061c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800626:	e9 4e ff ff ff       	jmp    800579 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80062b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80062e:	e9 46 ff ff ff       	jmp    800579 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	83 c0 04             	add    $0x4,%eax
  800639:	89 45 14             	mov    %eax,0x14(%ebp)
  80063c:	8b 45 14             	mov    0x14(%ebp),%eax
  80063f:	83 e8 04             	sub    $0x4,%eax
  800642:	8b 00                	mov    (%eax),%eax
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	ff 75 0c             	pushl  0xc(%ebp)
  80064a:	50                   	push   %eax
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	ff d0                	call   *%eax
  800650:	83 c4 10             	add    $0x10,%esp
			break;
  800653:	e9 9b 02 00 00       	jmp    8008f3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	83 c0 04             	add    $0x4,%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	83 e8 04             	sub    $0x4,%eax
  800667:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800669:	85 db                	test   %ebx,%ebx
  80066b:	79 02                	jns    80066f <vprintfmt+0x14a>
				err = -err;
  80066d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80066f:	83 fb 64             	cmp    $0x64,%ebx
  800672:	7f 0b                	jg     80067f <vprintfmt+0x15a>
  800674:	8b 34 9d 20 3d 80 00 	mov    0x803d20(,%ebx,4),%esi
  80067b:	85 f6                	test   %esi,%esi
  80067d:	75 19                	jne    800698 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067f:	53                   	push   %ebx
  800680:	68 c5 3e 80 00       	push   $0x803ec5
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	ff 75 08             	pushl  0x8(%ebp)
  80068b:	e8 70 02 00 00       	call   800900 <printfmt>
  800690:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800693:	e9 5b 02 00 00       	jmp    8008f3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800698:	56                   	push   %esi
  800699:	68 ce 3e 80 00       	push   $0x803ece
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	ff 75 08             	pushl  0x8(%ebp)
  8006a4:	e8 57 02 00 00       	call   800900 <printfmt>
  8006a9:	83 c4 10             	add    $0x10,%esp
			break;
  8006ac:	e9 42 02 00 00       	jmp    8008f3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	83 c0 04             	add    $0x4,%eax
  8006b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	83 e8 04             	sub    $0x4,%eax
  8006c0:	8b 30                	mov    (%eax),%esi
  8006c2:	85 f6                	test   %esi,%esi
  8006c4:	75 05                	jne    8006cb <vprintfmt+0x1a6>
				p = "(null)";
  8006c6:	be d1 3e 80 00       	mov    $0x803ed1,%esi
			if (width > 0 && padc != '-')
  8006cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cf:	7e 6d                	jle    80073e <vprintfmt+0x219>
  8006d1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006d5:	74 67                	je     80073e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	50                   	push   %eax
  8006de:	56                   	push   %esi
  8006df:	e8 1e 03 00 00       	call   800a02 <strnlen>
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006ea:	eb 16                	jmp    800702 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006ec:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006f0:	83 ec 08             	sub    $0x8,%esp
  8006f3:	ff 75 0c             	pushl  0xc(%ebp)
  8006f6:	50                   	push   %eax
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	ff d0                	call   *%eax
  8006fc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ff:	ff 4d e4             	decl   -0x1c(%ebp)
  800702:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800706:	7f e4                	jg     8006ec <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800708:	eb 34                	jmp    80073e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80070a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80070e:	74 1c                	je     80072c <vprintfmt+0x207>
  800710:	83 fb 1f             	cmp    $0x1f,%ebx
  800713:	7e 05                	jle    80071a <vprintfmt+0x1f5>
  800715:	83 fb 7e             	cmp    $0x7e,%ebx
  800718:	7e 12                	jle    80072c <vprintfmt+0x207>
					putch('?', putdat);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 0c             	pushl  0xc(%ebp)
  800720:	6a 3f                	push   $0x3f
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	ff d0                	call   *%eax
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	eb 0f                	jmp    80073b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80072c:	83 ec 08             	sub    $0x8,%esp
  80072f:	ff 75 0c             	pushl  0xc(%ebp)
  800732:	53                   	push   %ebx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	ff d0                	call   *%eax
  800738:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80073b:	ff 4d e4             	decl   -0x1c(%ebp)
  80073e:	89 f0                	mov    %esi,%eax
  800740:	8d 70 01             	lea    0x1(%eax),%esi
  800743:	8a 00                	mov    (%eax),%al
  800745:	0f be d8             	movsbl %al,%ebx
  800748:	85 db                	test   %ebx,%ebx
  80074a:	74 24                	je     800770 <vprintfmt+0x24b>
  80074c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800750:	78 b8                	js     80070a <vprintfmt+0x1e5>
  800752:	ff 4d e0             	decl   -0x20(%ebp)
  800755:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800759:	79 af                	jns    80070a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80075b:	eb 13                	jmp    800770 <vprintfmt+0x24b>
				putch(' ', putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	6a 20                	push   $0x20
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	ff d0                	call   *%eax
  80076a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076d:	ff 4d e4             	decl   -0x1c(%ebp)
  800770:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800774:	7f e7                	jg     80075d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800776:	e9 78 01 00 00       	jmp    8008f3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 e8             	pushl  -0x18(%ebp)
  800781:	8d 45 14             	lea    0x14(%ebp),%eax
  800784:	50                   	push   %eax
  800785:	e8 3c fd ff ff       	call   8004c6 <getint>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800790:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800799:	85 d2                	test   %edx,%edx
  80079b:	79 23                	jns    8007c0 <vprintfmt+0x29b>
				putch('-', putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	ff 75 0c             	pushl  0xc(%ebp)
  8007a3:	6a 2d                	push   $0x2d
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	ff d0                	call   *%eax
  8007aa:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b3:	f7 d8                	neg    %eax
  8007b5:	83 d2 00             	adc    $0x0,%edx
  8007b8:	f7 da                	neg    %edx
  8007ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007c0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c7:	e9 bc 00 00 00       	jmp    800888 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d5:	50                   	push   %eax
  8007d6:	e8 84 fc ff ff       	call   80045f <getuint>
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007e4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007eb:	e9 98 00 00 00       	jmp    800888 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	6a 58                	push   $0x58
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	ff d0                	call   *%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800800:	83 ec 08             	sub    $0x8,%esp
  800803:	ff 75 0c             	pushl  0xc(%ebp)
  800806:	6a 58                	push   $0x58
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	ff d0                	call   *%eax
  80080d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800810:	83 ec 08             	sub    $0x8,%esp
  800813:	ff 75 0c             	pushl  0xc(%ebp)
  800816:	6a 58                	push   $0x58
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	ff d0                	call   *%eax
  80081d:	83 c4 10             	add    $0x10,%esp
			break;
  800820:	e9 ce 00 00 00       	jmp    8008f3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	6a 30                	push   $0x30
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	ff d0                	call   *%eax
  800832:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	6a 78                	push   $0x78
  80083d:	8b 45 08             	mov    0x8(%ebp),%eax
  800840:	ff d0                	call   *%eax
  800842:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	83 c0 04             	add    $0x4,%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	83 e8 04             	sub    $0x4,%eax
  800854:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800856:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800859:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800860:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800867:	eb 1f                	jmp    800888 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800869:	83 ec 08             	sub    $0x8,%esp
  80086c:	ff 75 e8             	pushl  -0x18(%ebp)
  80086f:	8d 45 14             	lea    0x14(%ebp),%eax
  800872:	50                   	push   %eax
  800873:	e8 e7 fb ff ff       	call   80045f <getuint>
  800878:	83 c4 10             	add    $0x10,%esp
  80087b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800881:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800888:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088f:	83 ec 04             	sub    $0x4,%esp
  800892:	52                   	push   %edx
  800893:	ff 75 e4             	pushl  -0x1c(%ebp)
  800896:	50                   	push   %eax
  800897:	ff 75 f4             	pushl  -0xc(%ebp)
  80089a:	ff 75 f0             	pushl  -0x10(%ebp)
  80089d:	ff 75 0c             	pushl  0xc(%ebp)
  8008a0:	ff 75 08             	pushl  0x8(%ebp)
  8008a3:	e8 00 fb ff ff       	call   8003a8 <printnum>
  8008a8:	83 c4 20             	add    $0x20,%esp
			break;
  8008ab:	eb 46                	jmp    8008f3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 0c             	pushl  0xc(%ebp)
  8008b3:	53                   	push   %ebx
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
			break;
  8008bc:	eb 35                	jmp    8008f3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008be:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  8008c5:	eb 2c                	jmp    8008f3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008c7:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  8008ce:	eb 23                	jmp    8008f3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	6a 25                	push   $0x25
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	ff d0                	call   *%eax
  8008dd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e0:	ff 4d 10             	decl   0x10(%ebp)
  8008e3:	eb 03                	jmp    8008e8 <vprintfmt+0x3c3>
  8008e5:	ff 4d 10             	decl   0x10(%ebp)
  8008e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008eb:	48                   	dec    %eax
  8008ec:	8a 00                	mov    (%eax),%al
  8008ee:	3c 25                	cmp    $0x25,%al
  8008f0:	75 f3                	jne    8008e5 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008f2:	90                   	nop
		}
	}
  8008f3:	e9 35 fc ff ff       	jmp    80052d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008f8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008fc:	5b                   	pop    %ebx
  8008fd:	5e                   	pop    %esi
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800906:	8d 45 10             	lea    0x10(%ebp),%eax
  800909:	83 c0 04             	add    $0x4,%eax
  80090c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80090f:	8b 45 10             	mov    0x10(%ebp),%eax
  800912:	ff 75 f4             	pushl  -0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	ff 75 08             	pushl  0x8(%ebp)
  80091c:	e8 04 fc ff ff       	call   800525 <vprintfmt>
  800921:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800924:	90                   	nop
  800925:	c9                   	leave  
  800926:	c3                   	ret    

00800927 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80092a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092d:	8b 40 08             	mov    0x8(%eax),%eax
  800930:	8d 50 01             	lea    0x1(%eax),%edx
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	8b 10                	mov    (%eax),%edx
  80093e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800941:	8b 40 04             	mov    0x4(%eax),%eax
  800944:	39 c2                	cmp    %eax,%edx
  800946:	73 12                	jae    80095a <sprintputch+0x33>
		*b->buf++ = ch;
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	8b 00                	mov    (%eax),%eax
  80094d:	8d 48 01             	lea    0x1(%eax),%ecx
  800950:	8b 55 0c             	mov    0xc(%ebp),%edx
  800953:	89 0a                	mov    %ecx,(%edx)
  800955:	8b 55 08             	mov    0x8(%ebp),%edx
  800958:	88 10                	mov    %dl,(%eax)
}
  80095a:	90                   	nop
  80095b:	5d                   	pop    %ebp
  80095c:	c3                   	ret    

0080095d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800969:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	01 d0                	add    %edx,%eax
  800974:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800977:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80097e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800982:	74 06                	je     80098a <vsnprintf+0x2d>
  800984:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800988:	7f 07                	jg     800991 <vsnprintf+0x34>
		return -E_INVAL;
  80098a:	b8 03 00 00 00       	mov    $0x3,%eax
  80098f:	eb 20                	jmp    8009b1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800991:	ff 75 14             	pushl  0x14(%ebp)
  800994:	ff 75 10             	pushl  0x10(%ebp)
  800997:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80099a:	50                   	push   %eax
  80099b:	68 27 09 80 00       	push   $0x800927
  8009a0:	e8 80 fb ff ff       	call   800525 <vprintfmt>
  8009a5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009b1:	c9                   	leave  
  8009b2:	c3                   	ret    

008009b3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8009bc:	83 c0 04             	add    $0x4,%eax
  8009bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c8:	50                   	push   %eax
  8009c9:	ff 75 0c             	pushl  0xc(%ebp)
  8009cc:	ff 75 08             	pushl  0x8(%ebp)
  8009cf:	e8 89 ff ff ff       	call   80095d <vsnprintf>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009dd:	c9                   	leave  
  8009de:	c3                   	ret    

008009df <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ec:	eb 06                	jmp    8009f4 <strlen+0x15>
		n++;
  8009ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f1:	ff 45 08             	incl   0x8(%ebp)
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8a 00                	mov    (%eax),%al
  8009f9:	84 c0                	test   %al,%al
  8009fb:	75 f1                	jne    8009ee <strlen+0xf>
		n++;
	return n;
  8009fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    

00800a02 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0f:	eb 09                	jmp    800a1a <strnlen+0x18>
		n++;
  800a11:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a14:	ff 45 08             	incl   0x8(%ebp)
  800a17:	ff 4d 0c             	decl   0xc(%ebp)
  800a1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a1e:	74 09                	je     800a29 <strnlen+0x27>
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8a 00                	mov    (%eax),%al
  800a25:	84 c0                	test   %al,%al
  800a27:	75 e8                	jne    800a11 <strnlen+0xf>
		n++;
	return n;
  800a29:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a2c:	c9                   	leave  
  800a2d:	c3                   	ret    

00800a2e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a3a:	90                   	nop
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	8d 50 01             	lea    0x1(%eax),%edx
  800a41:	89 55 08             	mov    %edx,0x8(%ebp)
  800a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a47:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a4a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a4d:	8a 12                	mov    (%edx),%dl
  800a4f:	88 10                	mov    %dl,(%eax)
  800a51:	8a 00                	mov    (%eax),%al
  800a53:	84 c0                	test   %al,%al
  800a55:	75 e4                	jne    800a3b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a5a:	c9                   	leave  
  800a5b:	c3                   	ret    

00800a5c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a68:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a6f:	eb 1f                	jmp    800a90 <strncpy+0x34>
		*dst++ = *src;
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	8d 50 01             	lea    0x1(%eax),%edx
  800a77:	89 55 08             	mov    %edx,0x8(%ebp)
  800a7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7d:	8a 12                	mov    (%edx),%dl
  800a7f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	8a 00                	mov    (%eax),%al
  800a86:	84 c0                	test   %al,%al
  800a88:	74 03                	je     800a8d <strncpy+0x31>
			src++;
  800a8a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a8d:	ff 45 fc             	incl   -0x4(%ebp)
  800a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a93:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a96:	72 d9                	jb     800a71 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a98:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aad:	74 30                	je     800adf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aaf:	eb 16                	jmp    800ac7 <strlcpy+0x2a>
			*dst++ = *src++;
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	8d 50 01             	lea    0x1(%eax),%edx
  800ab7:	89 55 08             	mov    %edx,0x8(%ebp)
  800aba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ac0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ac3:	8a 12                	mov    (%edx),%dl
  800ac5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ac7:	ff 4d 10             	decl   0x10(%ebp)
  800aca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ace:	74 09                	je     800ad9 <strlcpy+0x3c>
  800ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	84 c0                	test   %al,%al
  800ad7:	75 d8                	jne    800ab1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800adf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae5:	29 c2                	sub    %eax,%edx
  800ae7:	89 d0                	mov    %edx,%eax
}
  800ae9:	c9                   	leave  
  800aea:	c3                   	ret    

00800aeb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800aee:	eb 06                	jmp    800af6 <strcmp+0xb>
		p++, q++;
  800af0:	ff 45 08             	incl   0x8(%ebp)
  800af3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	84 c0                	test   %al,%al
  800afd:	74 0e                	je     800b0d <strcmp+0x22>
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8a 10                	mov    (%eax),%dl
  800b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	38 c2                	cmp    %al,%dl
  800b0b:	74 e3                	je     800af0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8a 00                	mov    (%eax),%al
  800b12:	0f b6 d0             	movzbl %al,%edx
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	0f b6 c0             	movzbl %al,%eax
  800b1d:	29 c2                	sub    %eax,%edx
  800b1f:	89 d0                	mov    %edx,%eax
}
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b26:	eb 09                	jmp    800b31 <strncmp+0xe>
		n--, p++, q++;
  800b28:	ff 4d 10             	decl   0x10(%ebp)
  800b2b:	ff 45 08             	incl   0x8(%ebp)
  800b2e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b35:	74 17                	je     800b4e <strncmp+0x2b>
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8a 00                	mov    (%eax),%al
  800b3c:	84 c0                	test   %al,%al
  800b3e:	74 0e                	je     800b4e <strncmp+0x2b>
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8a 10                	mov    (%eax),%dl
  800b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b48:	8a 00                	mov    (%eax),%al
  800b4a:	38 c2                	cmp    %al,%dl
  800b4c:	74 da                	je     800b28 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b52:	75 07                	jne    800b5b <strncmp+0x38>
		return 0;
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
  800b59:	eb 14                	jmp    800b6f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	8a 00                	mov    (%eax),%al
  800b60:	0f b6 d0             	movzbl %al,%edx
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	0f b6 c0             	movzbl %al,%eax
  800b6b:	29 c2                	sub    %eax,%edx
  800b6d:	89 d0                	mov    %edx,%eax
}
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 04             	sub    $0x4,%esp
  800b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b7d:	eb 12                	jmp    800b91 <strchr+0x20>
		if (*s == c)
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b87:	75 05                	jne    800b8e <strchr+0x1d>
			return (char *) s;
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	eb 11                	jmp    800b9f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b8e:	ff 45 08             	incl   0x8(%ebp)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	84 c0                	test   %al,%al
  800b98:	75 e5                	jne    800b7f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9f:	c9                   	leave  
  800ba0:	c3                   	ret    

00800ba1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	83 ec 04             	sub    $0x4,%esp
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bad:	eb 0d                	jmp    800bbc <strfind+0x1b>
		if (*s == c)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bb7:	74 0e                	je     800bc7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bb9:	ff 45 08             	incl   0x8(%ebp)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	84 c0                	test   %al,%al
  800bc3:	75 ea                	jne    800baf <strfind+0xe>
  800bc5:	eb 01                	jmp    800bc8 <strfind+0x27>
		if (*s == c)
			break;
  800bc7:	90                   	nop
	return (char *) s;
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bdf:	eb 0e                	jmp    800bef <memset+0x22>
		*p++ = c;
  800be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be4:	8d 50 01             	lea    0x1(%eax),%edx
  800be7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bed:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bef:	ff 4d f8             	decl   -0x8(%ebp)
  800bf2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bf6:	79 e9                	jns    800be1 <memset+0x14>
		*p++ = c;

	return v;
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c0f:	eb 16                	jmp    800c27 <memcpy+0x2a>
		*d++ = *s++;
  800c11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c14:	8d 50 01             	lea    0x1(%eax),%edx
  800c17:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c20:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c23:	8a 12                	mov    (%edx),%dl
  800c25:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c27:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2d:	89 55 10             	mov    %edx,0x10(%ebp)
  800c30:	85 c0                	test   %eax,%eax
  800c32:	75 dd                	jne    800c11 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c37:	c9                   	leave  
  800c38:	c3                   	ret    

00800c39 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c51:	73 50                	jae    800ca3 <memmove+0x6a>
  800c53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c56:	8b 45 10             	mov    0x10(%ebp),%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c5e:	76 43                	jbe    800ca3 <memmove+0x6a>
		s += n;
  800c60:	8b 45 10             	mov    0x10(%ebp),%eax
  800c63:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c66:	8b 45 10             	mov    0x10(%ebp),%eax
  800c69:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c6c:	eb 10                	jmp    800c7e <memmove+0x45>
			*--d = *--s;
  800c6e:	ff 4d f8             	decl   -0x8(%ebp)
  800c71:	ff 4d fc             	decl   -0x4(%ebp)
  800c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c77:	8a 10                	mov    (%eax),%dl
  800c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c84:	89 55 10             	mov    %edx,0x10(%ebp)
  800c87:	85 c0                	test   %eax,%eax
  800c89:	75 e3                	jne    800c6e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c8b:	eb 23                	jmp    800cb0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c90:	8d 50 01             	lea    0x1(%eax),%edx
  800c93:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c96:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c99:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c9c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c9f:	8a 12                	mov    (%edx),%dl
  800ca1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca9:	89 55 10             	mov    %edx,0x10(%ebp)
  800cac:	85 c0                	test   %eax,%eax
  800cae:	75 dd                	jne    800c8d <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cc7:	eb 2a                	jmp    800cf3 <memcmp+0x3e>
		if (*s1 != *s2)
  800cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccc:	8a 10                	mov    (%eax),%dl
  800cce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	38 c2                	cmp    %al,%dl
  800cd5:	74 16                	je     800ced <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	0f b6 d0             	movzbl %al,%edx
  800cdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	0f b6 c0             	movzbl %al,%eax
  800ce7:	29 c2                	sub    %eax,%edx
  800ce9:	89 d0                	mov    %edx,%eax
  800ceb:	eb 18                	jmp    800d05 <memcmp+0x50>
		s1++, s2++;
  800ced:	ff 45 fc             	incl   -0x4(%ebp)
  800cf0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cf3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf9:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	75 c9                	jne    800cc9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d10:	8b 45 10             	mov    0x10(%ebp),%eax
  800d13:	01 d0                	add    %edx,%eax
  800d15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d18:	eb 15                	jmp    800d2f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	0f b6 d0             	movzbl %al,%edx
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	0f b6 c0             	movzbl %al,%eax
  800d28:	39 c2                	cmp    %eax,%edx
  800d2a:	74 0d                	je     800d39 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d2c:	ff 45 08             	incl   0x8(%ebp)
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d35:	72 e3                	jb     800d1a <memfind+0x13>
  800d37:	eb 01                	jmp    800d3a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d39:	90                   	nop
	return (void *) s;
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d3d:	c9                   	leave  
  800d3e:	c3                   	ret    

00800d3f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d4c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d53:	eb 03                	jmp    800d58 <strtol+0x19>
		s++;
  800d55:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3c 20                	cmp    $0x20,%al
  800d5f:	74 f4                	je     800d55 <strtol+0x16>
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3c 09                	cmp    $0x9,%al
  800d68:	74 eb                	je     800d55 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	3c 2b                	cmp    $0x2b,%al
  800d71:	75 05                	jne    800d78 <strtol+0x39>
		s++;
  800d73:	ff 45 08             	incl   0x8(%ebp)
  800d76:	eb 13                	jmp    800d8b <strtol+0x4c>
	else if (*s == '-')
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	3c 2d                	cmp    $0x2d,%al
  800d7f:	75 0a                	jne    800d8b <strtol+0x4c>
		s++, neg = 1;
  800d81:	ff 45 08             	incl   0x8(%ebp)
  800d84:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8f:	74 06                	je     800d97 <strtol+0x58>
  800d91:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d95:	75 20                	jne    800db7 <strtol+0x78>
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	3c 30                	cmp    $0x30,%al
  800d9e:	75 17                	jne    800db7 <strtol+0x78>
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	40                   	inc    %eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	3c 78                	cmp    $0x78,%al
  800da8:	75 0d                	jne    800db7 <strtol+0x78>
		s += 2, base = 16;
  800daa:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800db5:	eb 28                	jmp    800ddf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800db7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbb:	75 15                	jne    800dd2 <strtol+0x93>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	3c 30                	cmp    $0x30,%al
  800dc4:	75 0c                	jne    800dd2 <strtol+0x93>
		s++, base = 8;
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dd0:	eb 0d                	jmp    800ddf <strtol+0xa0>
	else if (base == 0)
  800dd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd6:	75 07                	jne    800ddf <strtol+0xa0>
		base = 10;
  800dd8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	8a 00                	mov    (%eax),%al
  800de4:	3c 2f                	cmp    $0x2f,%al
  800de6:	7e 19                	jle    800e01 <strtol+0xc2>
  800de8:	8b 45 08             	mov    0x8(%ebp),%eax
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	3c 39                	cmp    $0x39,%al
  800def:	7f 10                	jg     800e01 <strtol+0xc2>
			dig = *s - '0';
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8a 00                	mov    (%eax),%al
  800df6:	0f be c0             	movsbl %al,%eax
  800df9:	83 e8 30             	sub    $0x30,%eax
  800dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dff:	eb 42                	jmp    800e43 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	3c 60                	cmp    $0x60,%al
  800e08:	7e 19                	jle    800e23 <strtol+0xe4>
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	3c 7a                	cmp    $0x7a,%al
  800e11:	7f 10                	jg     800e23 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	0f be c0             	movsbl %al,%eax
  800e1b:	83 e8 57             	sub    $0x57,%eax
  800e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e21:	eb 20                	jmp    800e43 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	3c 40                	cmp    $0x40,%al
  800e2a:	7e 39                	jle    800e65 <strtol+0x126>
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	3c 5a                	cmp    $0x5a,%al
  800e33:	7f 30                	jg     800e65 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	8a 00                	mov    (%eax),%al
  800e3a:	0f be c0             	movsbl %al,%eax
  800e3d:	83 e8 37             	sub    $0x37,%eax
  800e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e46:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e49:	7d 19                	jge    800e64 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e4b:	ff 45 08             	incl   0x8(%ebp)
  800e4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e51:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e55:	89 c2                	mov    %eax,%edx
  800e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e5a:	01 d0                	add    %edx,%eax
  800e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e5f:	e9 7b ff ff ff       	jmp    800ddf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e64:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e69:	74 08                	je     800e73 <strtol+0x134>
		*endptr = (char *) s;
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e73:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e77:	74 07                	je     800e80 <strtol+0x141>
  800e79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7c:	f7 d8                	neg    %eax
  800e7e:	eb 03                	jmp    800e83 <strtol+0x144>
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <ltostr>:

void
ltostr(long value, char *str)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e8b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e92:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e9d:	79 13                	jns    800eb2 <ltostr+0x2d>
	{
		neg = 1;
  800e9f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eac:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800eaf:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eba:	99                   	cltd   
  800ebb:	f7 f9                	idiv   %ecx
  800ebd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ec0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec3:	8d 50 01             	lea    0x1(%eax),%edx
  800ec6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec9:	89 c2                	mov    %eax,%edx
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	01 d0                	add    %edx,%eax
  800ed0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ed3:	83 c2 30             	add    $0x30,%edx
  800ed6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ed8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee0:	f7 e9                	imul   %ecx
  800ee2:	c1 fa 02             	sar    $0x2,%edx
  800ee5:	89 c8                	mov    %ecx,%eax
  800ee7:	c1 f8 1f             	sar    $0x1f,%eax
  800eea:	29 c2                	sub    %eax,%edx
  800eec:	89 d0                	mov    %edx,%eax
  800eee:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800ef1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ef5:	75 bb                	jne    800eb2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ef7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f01:	48                   	dec    %eax
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f05:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f09:	74 3d                	je     800f48 <ltostr+0xc3>
		start = 1 ;
  800f0b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f12:	eb 34                	jmp    800f48 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	01 c2                	add    %eax,%edx
  800f29:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2f:	01 c8                	add    %ecx,%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3b:	01 c2                	add    %eax,%edx
  800f3d:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f40:	88 02                	mov    %al,(%edx)
		start++ ;
  800f42:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f45:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f4b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f4e:	7c c4                	jl     800f14 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f50:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	01 d0                	add    %edx,%eax
  800f58:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f5b:	90                   	nop
  800f5c:	c9                   	leave  
  800f5d:	c3                   	ret    

00800f5e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f64:	ff 75 08             	pushl  0x8(%ebp)
  800f67:	e8 73 fa ff ff       	call   8009df <strlen>
  800f6c:	83 c4 04             	add    $0x4,%esp
  800f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	e8 65 fa ff ff       	call   8009df <strlen>
  800f7a:	83 c4 04             	add    $0x4,%esp
  800f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f8e:	eb 17                	jmp    800fa7 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f93:	8b 45 10             	mov    0x10(%ebp),%eax
  800f96:	01 c2                	add    %eax,%edx
  800f98:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	01 c8                	add    %ecx,%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fa4:	ff 45 fc             	incl   -0x4(%ebp)
  800fa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fad:	7c e1                	jl     800f90 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800faf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fb6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fbd:	eb 1f                	jmp    800fde <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8d 50 01             	lea    0x1(%eax),%edx
  800fc5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	01 c2                	add    %eax,%edx
  800fcf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd5:	01 c8                	add    %ecx,%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fdb:	ff 45 f8             	incl   -0x8(%ebp)
  800fde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe4:	7c d9                	jl     800fbf <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800fe6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fec:	01 d0                	add    %edx,%eax
  800fee:	c6 00 00             	movb   $0x0,(%eax)
}
  800ff1:	90                   	nop
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800ff7:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801000:	8b 45 14             	mov    0x14(%ebp),%eax
  801003:	8b 00                	mov    (%eax),%eax
  801005:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80100c:	8b 45 10             	mov    0x10(%ebp),%eax
  80100f:	01 d0                	add    %edx,%eax
  801011:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801017:	eb 0c                	jmp    801025 <strsplit+0x31>
			*string++ = 0;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8d 50 01             	lea    0x1(%eax),%edx
  80101f:	89 55 08             	mov    %edx,0x8(%ebp)
  801022:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	84 c0                	test   %al,%al
  80102c:	74 18                	je     801046 <strsplit+0x52>
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	0f be c0             	movsbl %al,%eax
  801036:	50                   	push   %eax
  801037:	ff 75 0c             	pushl  0xc(%ebp)
  80103a:	e8 32 fb ff ff       	call   800b71 <strchr>
  80103f:	83 c4 08             	add    $0x8,%esp
  801042:	85 c0                	test   %eax,%eax
  801044:	75 d3                	jne    801019 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	84 c0                	test   %al,%al
  80104d:	74 5a                	je     8010a9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80104f:	8b 45 14             	mov    0x14(%ebp),%eax
  801052:	8b 00                	mov    (%eax),%eax
  801054:	83 f8 0f             	cmp    $0xf,%eax
  801057:	75 07                	jne    801060 <strsplit+0x6c>
		{
			return 0;
  801059:	b8 00 00 00 00       	mov    $0x0,%eax
  80105e:	eb 66                	jmp    8010c6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801060:	8b 45 14             	mov    0x14(%ebp),%eax
  801063:	8b 00                	mov    (%eax),%eax
  801065:	8d 48 01             	lea    0x1(%eax),%ecx
  801068:	8b 55 14             	mov    0x14(%ebp),%edx
  80106b:	89 0a                	mov    %ecx,(%edx)
  80106d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801074:	8b 45 10             	mov    0x10(%ebp),%eax
  801077:	01 c2                	add    %eax,%edx
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80107e:	eb 03                	jmp    801083 <strsplit+0x8f>
			string++;
  801080:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	74 8b                	je     801017 <strsplit+0x23>
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	0f be c0             	movsbl %al,%eax
  801094:	50                   	push   %eax
  801095:	ff 75 0c             	pushl  0xc(%ebp)
  801098:	e8 d4 fa ff ff       	call   800b71 <strchr>
  80109d:	83 c4 08             	add    $0x8,%esp
  8010a0:	85 c0                	test   %eax,%eax
  8010a2:	74 dc                	je     801080 <strsplit+0x8c>
			string++;
	}
  8010a4:	e9 6e ff ff ff       	jmp    801017 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010a9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b9:	01 d0                	add    %edx,%eax
  8010bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    

008010c8 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8010ce:	83 ec 04             	sub    $0x4,%esp
  8010d1:	68 48 40 80 00       	push   $0x804048
  8010d6:	68 3f 01 00 00       	push   $0x13f
  8010db:	68 6a 40 80 00       	push   $0x80406a
  8010e0:	e8 5e 26 00 00       	call   803743 <_panic>

008010e5 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8010eb:	83 ec 0c             	sub    $0xc,%esp
  8010ee:	ff 75 08             	pushl  0x8(%ebp)
  8010f1:	e8 f8 0a 00 00       	call   801bee <sys_sbrk>
  8010f6:	83 c4 10             	add    $0x10,%esp
}
  8010f9:	c9                   	leave  
  8010fa:	c3                   	ret    

008010fb <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801101:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801105:	75 0a                	jne    801111 <malloc+0x16>
  801107:	b8 00 00 00 00       	mov    $0x0,%eax
  80110c:	e9 07 02 00 00       	jmp    801318 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  801111:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  801118:	8b 55 08             	mov    0x8(%ebp),%edx
  80111b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	48                   	dec    %eax
  801121:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801124:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801127:	ba 00 00 00 00       	mov    $0x0,%edx
  80112c:	f7 75 dc             	divl   -0x24(%ebp)
  80112f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801132:	29 d0                	sub    %edx,%eax
  801134:	c1 e8 0c             	shr    $0xc,%eax
  801137:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  80113a:	a1 20 50 80 00       	mov    0x805020,%eax
  80113f:	8b 40 78             	mov    0x78(%eax),%eax
  801142:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  801147:	29 c2                	sub    %eax,%edx
  801149:	89 d0                	mov    %edx,%eax
  80114b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80114e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801151:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801156:	c1 e8 0c             	shr    $0xc,%eax
  801159:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  80115c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  801163:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  80116a:	77 42                	ja     8011ae <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80116c:	e8 01 09 00 00       	call   801a72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801171:	85 c0                	test   %eax,%eax
  801173:	74 16                	je     80118b <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	ff 75 08             	pushl  0x8(%ebp)
  80117b:	e8 dd 0e 00 00       	call   80205d <alloc_block_FF>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801186:	e9 8a 01 00 00       	jmp    801315 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80118b:	e8 13 09 00 00       	call   801aa3 <sys_isUHeapPlacementStrategyBESTFIT>
  801190:	85 c0                	test   %eax,%eax
  801192:	0f 84 7d 01 00 00    	je     801315 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801198:	83 ec 0c             	sub    $0xc,%esp
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	e8 76 13 00 00       	call   802519 <alloc_block_BF>
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011a9:	e9 67 01 00 00       	jmp    801315 <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  8011ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011b1:	48                   	dec    %eax
  8011b2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8011b5:	0f 86 53 01 00 00    	jbe    80130e <malloc+0x213>
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  8011bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8011c0:	8b 40 78             	mov    0x78(%eax),%eax
  8011c3:	05 00 10 00 00       	add    $0x1000,%eax
  8011c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  8011cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  8011d2:	e9 de 00 00 00       	jmp    8012b5 <malloc+0x1ba>
		{
			
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  8011d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8011dc:	8b 40 78             	mov    0x78(%eax),%eax
  8011df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011e2:	29 c2                	sub    %eax,%edx
  8011e4:	89 d0                	mov    %edx,%eax
  8011e6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011eb:	c1 e8 0c             	shr    $0xc,%eax
  8011ee:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	0f 85 ab 00 00 00    	jne    8012a8 <malloc+0x1ad>
			{
				
				uint32 j = i + (uint32)PAGE_SIZE;
  8011fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801200:	05 00 10 00 00       	add    $0x1000,%eax
  801205:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801208:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
				while(cnt < num_pages - 1)
  80120f:	eb 47                	jmp    801258 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  801211:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  801218:	76 0a                	jbe    801224 <malloc+0x129>
  80121a:	b8 00 00 00 00       	mov    $0x0,%eax
  80121f:	e9 f4 00 00 00       	jmp    801318 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  801224:	a1 20 50 80 00       	mov    0x805020,%eax
  801229:	8b 40 78             	mov    0x78(%eax),%eax
  80122c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80122f:	29 c2                	sub    %eax,%edx
  801231:	89 d0                	mov    %edx,%eax
  801233:	2d 00 10 00 00       	sub    $0x1000,%eax
  801238:	c1 e8 0c             	shr    $0xc,%eax
  80123b:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801242:	85 c0                	test   %eax,%eax
  801244:	74 08                	je     80124e <malloc+0x153>
					{
						
						i = j;
  801246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801249:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  80124c:	eb 5a                	jmp    8012a8 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  80124e:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  801255:	ff 45 e4             	incl   -0x1c(%ebp)
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
				while(cnt < num_pages - 1)
  801258:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80125b:	48                   	dec    %eax
  80125c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80125f:	77 b0                	ja     801211 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801261:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801268:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80126f:	eb 2f                	jmp    8012a0 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801274:	c1 e0 0c             	shl    $0xc,%eax
  801277:	89 c2                	mov    %eax,%edx
  801279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127c:	01 c2                	add    %eax,%edx
  80127e:	a1 20 50 80 00       	mov    0x805020,%eax
  801283:	8b 40 78             	mov    0x78(%eax),%eax
  801286:	29 c2                	sub    %eax,%edx
  801288:	89 d0                	mov    %edx,%eax
  80128a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80128f:	c1 e8 0c             	shr    $0xc,%eax
  801292:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801299:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  80129d:	ff 45 e0             	incl   -0x20(%ebp)
  8012a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012a3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8012a6:	72 c9                	jb     801271 <malloc+0x176>
				}
				

			}
			sayed:
			if(ok) break;
  8012a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012ac:	75 16                	jne    8012c4 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8012ae:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8012b5:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8012bc:	0f 86 15 ff ff ff    	jbe    8011d7 <malloc+0xdc>
  8012c2:	eb 01                	jmp    8012c5 <malloc+0x1ca>
				}
				

			}
			sayed:
			if(ok) break;
  8012c4:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  8012c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012c9:	75 07                	jne    8012d2 <malloc+0x1d7>
  8012cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d0:	eb 46                	jmp    801318 <malloc+0x21d>
		ptr = (void*)i;
  8012d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  8012d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8012dd:	8b 40 78             	mov    0x78(%eax),%eax
  8012e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012e3:	29 c2                	sub    %eax,%edx
  8012e5:	89 d0                	mov    %edx,%eax
  8012e7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8012ec:	c1 e8 0c             	shr    $0xc,%eax
  8012ef:	89 c2                	mov    %eax,%edx
  8012f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8012f4:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	ff 75 08             	pushl  0x8(%ebp)
  801301:	ff 75 f0             	pushl  -0x10(%ebp)
  801304:	e8 1c 09 00 00       	call   801c25 <sys_allocate_user_mem>
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	eb 07                	jmp    801315 <malloc+0x21a>
		
	}
	else
	{
		return NULL;
  80130e:	b8 00 00 00 00       	mov    $0x0,%eax
  801313:	eb 03                	jmp    801318 <malloc+0x21d>
	}
	return ptr;
  801315:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  801320:	a1 20 50 80 00       	mov    0x805020,%eax
  801325:	8b 40 78             	mov    0x78(%eax),%eax
  801328:	05 00 10 00 00       	add    $0x1000,%eax
  80132d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  801330:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  801337:	a1 20 50 80 00       	mov    0x805020,%eax
  80133c:	8b 50 78             	mov    0x78(%eax),%edx
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	39 c2                	cmp    %eax,%edx
  801344:	76 24                	jbe    80136a <free+0x50>
		size = get_block_size(va);
  801346:	83 ec 0c             	sub    $0xc,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	e8 8c 09 00 00       	call   801cdd <get_block_size>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 9c 1b 00 00       	call   802efe <free_block>
  801362:	83 c4 10             	add    $0x10,%esp
		}

	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  801365:	e9 ac 00 00 00       	jmp    801416 <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801370:	0f 82 89 00 00 00    	jb     8013ff <free+0xe5>
  801376:	8b 45 08             	mov    0x8(%ebp),%eax
  801379:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  80137e:	77 7f                	ja     8013ff <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801380:	8b 55 08             	mov    0x8(%ebp),%edx
  801383:	a1 20 50 80 00       	mov    0x805020,%eax
  801388:	8b 40 78             	mov    0x78(%eax),%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
  80138f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801394:	c1 e8 0c             	shr    $0xc,%eax
  801397:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  80139e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  8013a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013a4:	c1 e0 0c             	shl    $0xc,%eax
  8013a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  8013aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8013b1:	eb 42                	jmp    8013f5 <free+0xdb>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  8013b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b6:	c1 e0 0c             	shl    $0xc,%eax
  8013b9:	89 c2                	mov    %eax,%edx
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	01 c2                	add    %eax,%edx
  8013c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8013c5:	8b 40 78             	mov    0x78(%eax),%eax
  8013c8:	29 c2                	sub    %eax,%edx
  8013ca:	89 d0                	mov    %edx,%eax
  8013cc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013d1:	c1 e8 0c             	shr    $0xc,%eax
  8013d4:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  8013db:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8013df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	83 ec 08             	sub    $0x8,%esp
  8013e8:	52                   	push   %edx
  8013e9:	50                   	push   %eax
  8013ea:	e8 1a 08 00 00       	call   801c09 <sys_free_user_mem>
  8013ef:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8013f2:	ff 45 f4             	incl   -0xc(%ebp)
  8013f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f8:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8013fb:	72 b6                	jb     8013b3 <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8013fd:	eb 17                	jmp    801416 <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  8013ff:	83 ec 04             	sub    $0x4,%esp
  801402:	68 78 40 80 00       	push   $0x804078
  801407:	68 87 00 00 00       	push   $0x87
  80140c:	68 a2 40 80 00       	push   $0x8040a2
  801411:	e8 2d 23 00 00       	call   803743 <_panic>
	}
}
  801416:	90                   	nop
  801417:	c9                   	leave  
  801418:	c3                   	ret    

00801419 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	83 ec 28             	sub    $0x28,%esp
  80141f:	8b 45 10             	mov    0x10(%ebp),%eax
  801422:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801425:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801429:	75 0a                	jne    801435 <smalloc+0x1c>
  80142b:	b8 00 00 00 00       	mov    $0x0,%eax
  801430:	e9 87 00 00 00       	jmp    8014bc <smalloc+0xa3>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801435:	8b 45 0c             	mov    0xc(%ebp),%eax
  801438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80143b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801442:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801448:	39 d0                	cmp    %edx,%eax
  80144a:	73 02                	jae    80144e <smalloc+0x35>
  80144c:	89 d0                	mov    %edx,%eax
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	50                   	push   %eax
  801452:	e8 a4 fc ff ff       	call   8010fb <malloc>
  801457:	83 c4 10             	add    $0x10,%esp
  80145a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80145d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801461:	75 07                	jne    80146a <smalloc+0x51>
  801463:	b8 00 00 00 00       	mov    $0x0,%eax
  801468:	eb 52                	jmp    8014bc <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80146a:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80146e:	ff 75 ec             	pushl  -0x14(%ebp)
  801471:	50                   	push   %eax
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	ff 75 08             	pushl  0x8(%ebp)
  801478:	e8 93 03 00 00       	call   801810 <sys_createSharedObject>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801483:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801487:	74 06                	je     80148f <smalloc+0x76>
  801489:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80148d:	75 07                	jne    801496 <smalloc+0x7d>
  80148f:	b8 00 00 00 00       	mov    $0x0,%eax
  801494:	eb 26                	jmp    8014bc <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801496:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801499:	a1 20 50 80 00       	mov    0x805020,%eax
  80149e:	8b 40 78             	mov    0x78(%eax),%eax
  8014a1:	29 c2                	sub    %eax,%edx
  8014a3:	89 d0                	mov    %edx,%eax
  8014a5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014aa:	c1 e8 0c             	shr    $0xc,%eax
  8014ad:	89 c2                	mov    %eax,%edx
  8014af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b2:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8014b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014c4:	83 ec 08             	sub    $0x8,%esp
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	ff 75 08             	pushl  0x8(%ebp)
  8014cd:	e8 68 03 00 00       	call   80183a <sys_getSizeOfSharedObject>
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8014d8:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8014dc:	75 07                	jne    8014e5 <sget+0x27>
  8014de:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e3:	eb 7f                	jmp    801564 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8014e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014eb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8014f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f8:	39 d0                	cmp    %edx,%eax
  8014fa:	73 02                	jae    8014fe <sget+0x40>
  8014fc:	89 d0                	mov    %edx,%eax
  8014fe:	83 ec 0c             	sub    $0xc,%esp
  801501:	50                   	push   %eax
  801502:	e8 f4 fb ff ff       	call   8010fb <malloc>
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80150d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801511:	75 07                	jne    80151a <sget+0x5c>
  801513:	b8 00 00 00 00       	mov    $0x0,%eax
  801518:	eb 4a                	jmp    801564 <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	ff 75 e8             	pushl  -0x18(%ebp)
  801520:	ff 75 0c             	pushl  0xc(%ebp)
  801523:	ff 75 08             	pushl  0x8(%ebp)
  801526:	e8 2c 03 00 00       	call   801857 <sys_getSharedObject>
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  801531:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801534:	a1 20 50 80 00       	mov    0x805020,%eax
  801539:	8b 40 78             	mov    0x78(%eax),%eax
  80153c:	29 c2                	sub    %eax,%edx
  80153e:	89 d0                	mov    %edx,%eax
  801540:	2d 00 10 00 00       	sub    $0x1000,%eax
  801545:	c1 e8 0c             	shr    $0xc,%eax
  801548:	89 c2                	mov    %eax,%edx
  80154a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80154d:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801554:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801558:	75 07                	jne    801561 <sget+0xa3>
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	eb 03                	jmp    801564 <sget+0xa6>
	return ptr;
  801561:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80156c:	8b 55 08             	mov    0x8(%ebp),%edx
  80156f:	a1 20 50 80 00       	mov    0x805020,%eax
  801574:	8b 40 78             	mov    0x78(%eax),%eax
  801577:	29 c2                	sub    %eax,%edx
  801579:	89 d0                	mov    %edx,%eax
  80157b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801580:	c1 e8 0c             	shr    $0xc,%eax
  801583:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80158a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80158d:	83 ec 08             	sub    $0x8,%esp
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	ff 75 f4             	pushl  -0xc(%ebp)
  801596:	e8 db 02 00 00       	call   801876 <sys_freeSharedObject>
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8015a1:	90                   	nop
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015aa:	83 ec 04             	sub    $0x4,%esp
  8015ad:	68 b0 40 80 00       	push   $0x8040b0
  8015b2:	68 e4 00 00 00       	push   $0xe4
  8015b7:	68 a2 40 80 00       	push   $0x8040a2
  8015bc:	e8 82 21 00 00       	call   803743 <_panic>

008015c1 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	68 d6 40 80 00       	push   $0x8040d6
  8015cf:	68 f0 00 00 00       	push   $0xf0
  8015d4:	68 a2 40 80 00       	push   $0x8040a2
  8015d9:	e8 65 21 00 00       	call   803743 <_panic>

008015de <shrink>:

}
void shrink(uint32 newSize)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	68 d6 40 80 00       	push   $0x8040d6
  8015ec:	68 f5 00 00 00       	push   $0xf5
  8015f1:	68 a2 40 80 00       	push   $0x8040a2
  8015f6:	e8 48 21 00 00       	call   803743 <_panic>

008015fb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801601:	83 ec 04             	sub    $0x4,%esp
  801604:	68 d6 40 80 00       	push   $0x8040d6
  801609:	68 fa 00 00 00       	push   $0xfa
  80160e:	68 a2 40 80 00       	push   $0x8040a2
  801613:	e8 2b 21 00 00       	call   803743 <_panic>

00801618 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	57                   	push   %edi
  80161c:	56                   	push   %esi
  80161d:	53                   	push   %ebx
  80161e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8b 55 0c             	mov    0xc(%ebp),%edx
  801627:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80162a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80162d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801630:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801633:	cd 30                	int    $0x30
  801635:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801638:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80163b:	83 c4 10             	add    $0x10,%esp
  80163e:	5b                   	pop    %ebx
  80163f:	5e                   	pop    %esi
  801640:	5f                   	pop    %edi
  801641:	5d                   	pop    %ebp
  801642:	c3                   	ret    

00801643 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	8b 45 10             	mov    0x10(%ebp),%eax
  80164c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80164f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	52                   	push   %edx
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	50                   	push   %eax
  80165f:	6a 00                	push   $0x0
  801661:	e8 b2 ff ff ff       	call   801618 <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	90                   	nop
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <sys_cgetc>:

int
sys_cgetc(void)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 02                	push   $0x2
  80167b:	e8 98 ff ff ff       	call   801618 <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 03                	push   $0x3
  801694:	e8 7f ff ff ff       	call   801618 <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	90                   	nop
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 04                	push   $0x4
  8016ae:	e8 65 ff ff ff       	call   801618 <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	90                   	nop
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	52                   	push   %edx
  8016c9:	50                   	push   %eax
  8016ca:	6a 08                	push   $0x8
  8016cc:	e8 47 ff ff ff       	call   801618 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	56                   	push   %esi
  8016da:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016db:	8b 75 18             	mov    0x18(%ebp),%esi
  8016de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	56                   	push   %esi
  8016eb:	53                   	push   %ebx
  8016ec:	51                   	push   %ecx
  8016ed:	52                   	push   %edx
  8016ee:	50                   	push   %eax
  8016ef:	6a 09                	push   $0x9
  8016f1:	e8 22 ff ff ff       	call   801618 <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
}
  8016f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016fc:	5b                   	pop    %ebx
  8016fd:	5e                   	pop    %esi
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    

00801700 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801703:	8b 55 0c             	mov    0xc(%ebp),%edx
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	52                   	push   %edx
  801710:	50                   	push   %eax
  801711:	6a 0a                	push   $0xa
  801713:	e8 00 ff ff ff       	call   801618 <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
}
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	ff 75 0c             	pushl  0xc(%ebp)
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	6a 0b                	push   $0xb
  80172e:	e8 e5 fe ff ff       	call   801618 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 0c                	push   $0xc
  801747:	e8 cc fe ff ff       	call   801618 <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 0d                	push   $0xd
  801760:	e8 b3 fe ff ff       	call   801618 <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 0e                	push   $0xe
  801779:	e8 9a fe ff ff       	call   801618 <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 0f                	push   $0xf
  801792:	e8 81 fe ff ff       	call   801618 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	ff 75 08             	pushl  0x8(%ebp)
  8017aa:	6a 10                	push   $0x10
  8017ac:	e8 67 fe ff ff       	call   801618 <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 11                	push   $0x11
  8017c5:	e8 4e fe ff ff       	call   801618 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	90                   	nop
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 04             	sub    $0x4,%esp
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017dc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	50                   	push   %eax
  8017e9:	6a 01                	push   $0x1
  8017eb:	e8 28 fe ff ff       	call   801618 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	90                   	nop
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 14                	push   $0x14
  801805:	e8 0e fe ff ff       	call   801618 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	90                   	nop
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 04             	sub    $0x4,%esp
  801816:	8b 45 10             	mov    0x10(%ebp),%eax
  801819:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80181c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80181f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	6a 00                	push   $0x0
  801828:	51                   	push   %ecx
  801829:	52                   	push   %edx
  80182a:	ff 75 0c             	pushl  0xc(%ebp)
  80182d:	50                   	push   %eax
  80182e:	6a 15                	push   $0x15
  801830:	e8 e3 fd ff ff       	call   801618 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80183d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	52                   	push   %edx
  80184a:	50                   	push   %eax
  80184b:	6a 16                	push   $0x16
  80184d:	e8 c6 fd ff ff       	call   801618 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80185a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	51                   	push   %ecx
  801868:	52                   	push   %edx
  801869:	50                   	push   %eax
  80186a:	6a 17                	push   $0x17
  80186c:	e8 a7 fd ff ff       	call   801618 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801879:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	52                   	push   %edx
  801886:	50                   	push   %eax
  801887:	6a 18                	push   $0x18
  801889:	e8 8a fd ff ff       	call   801618 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	ff 75 14             	pushl  0x14(%ebp)
  80189e:	ff 75 10             	pushl  0x10(%ebp)
  8018a1:	ff 75 0c             	pushl  0xc(%ebp)
  8018a4:	50                   	push   %eax
  8018a5:	6a 19                	push   $0x19
  8018a7:	e8 6c fd ff ff       	call   801618 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	50                   	push   %eax
  8018c0:	6a 1a                	push   $0x1a
  8018c2:	e8 51 fd ff ff       	call   801618 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	90                   	nop
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	50                   	push   %eax
  8018dc:	6a 1b                	push   $0x1b
  8018de:	e8 35 fd ff ff       	call   801618 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 05                	push   $0x5
  8018f7:	e8 1c fd ff ff       	call   801618 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 06                	push   $0x6
  801910:	e8 03 fd ff ff       	call   801618 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 07                	push   $0x7
  801929:	e8 ea fc ff ff       	call   801618 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_exit_env>:


void sys_exit_env(void)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 1c                	push   $0x1c
  801942:	e8 d1 fc ff ff       	call   801618 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	90                   	nop
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801953:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801956:	8d 50 04             	lea    0x4(%eax),%edx
  801959:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	52                   	push   %edx
  801963:	50                   	push   %eax
  801964:	6a 1d                	push   $0x1d
  801966:	e8 ad fc ff ff       	call   801618 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
	return result;
  80196e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801971:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801974:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801977:	89 01                	mov    %eax,(%ecx)
  801979:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	c9                   	leave  
  801980:	c2 04 00             	ret    $0x4

00801983 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	ff 75 10             	pushl  0x10(%ebp)
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	ff 75 08             	pushl  0x8(%ebp)
  801993:	6a 13                	push   $0x13
  801995:	e8 7e fc ff ff       	call   801618 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
	return ;
  80199d:	90                   	nop
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 1e                	push   $0x1e
  8019af:	e8 64 fc ff ff       	call   801618 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019c5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	50                   	push   %eax
  8019d2:	6a 1f                	push   $0x1f
  8019d4:	e8 3f fc ff ff       	call   801618 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019dc:	90                   	nop
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <rsttst>:
void rsttst()
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 21                	push   $0x21
  8019ee:	e8 25 fc ff ff       	call   801618 <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f6:	90                   	nop
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 04             	sub    $0x4,%esp
  8019ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801a02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a05:	8b 55 18             	mov    0x18(%ebp),%edx
  801a08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a0c:	52                   	push   %edx
  801a0d:	50                   	push   %eax
  801a0e:	ff 75 10             	pushl  0x10(%ebp)
  801a11:	ff 75 0c             	pushl  0xc(%ebp)
  801a14:	ff 75 08             	pushl  0x8(%ebp)
  801a17:	6a 20                	push   $0x20
  801a19:	e8 fa fb ff ff       	call   801618 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a21:	90                   	nop
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <chktst>:
void chktst(uint32 n)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	ff 75 08             	pushl  0x8(%ebp)
  801a32:	6a 22                	push   $0x22
  801a34:	e8 df fb ff ff       	call   801618 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3c:	90                   	nop
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <inctst>:

void inctst()
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 23                	push   $0x23
  801a4e:	e8 c5 fb ff ff       	call   801618 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
	return ;
  801a56:	90                   	nop
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <gettst>:
uint32 gettst()
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 24                	push   $0x24
  801a68:	e8 ab fb ff ff       	call   801618 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 25                	push   $0x25
  801a84:	e8 8f fb ff ff       	call   801618 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
  801a8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a8f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a93:	75 07                	jne    801a9c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a95:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9a:	eb 05                	jmp    801aa1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 25                	push   $0x25
  801ab5:	e8 5e fb ff ff       	call   801618 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
  801abd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ac0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ac4:	75 07                	jne    801acd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ac6:	b8 01 00 00 00       	mov    $0x1,%eax
  801acb:	eb 05                	jmp    801ad2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 25                	push   $0x25
  801ae6:	e8 2d fb ff ff       	call   801618 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
  801aee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801af1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801af5:	75 07                	jne    801afe <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801af7:	b8 01 00 00 00       	mov    $0x1,%eax
  801afc:	eb 05                	jmp    801b03 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 25                	push   $0x25
  801b17:	e8 fc fa ff ff       	call   801618 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
  801b1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b22:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b26:	75 07                	jne    801b2f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b28:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2d:	eb 05                	jmp    801b34 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	ff 75 08             	pushl  0x8(%ebp)
  801b44:	6a 26                	push   $0x26
  801b46:	e8 cd fa ff ff       	call   801618 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4e:	90                   	nop
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	6a 00                	push   $0x0
  801b63:	53                   	push   %ebx
  801b64:	51                   	push   %ecx
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	6a 27                	push   $0x27
  801b69:	e8 aa fa ff ff       	call   801618 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	52                   	push   %edx
  801b86:	50                   	push   %eax
  801b87:	6a 28                	push   $0x28
  801b89:	e8 8a fa ff ff       	call   801618 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b96:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	6a 00                	push   $0x0
  801ba1:	51                   	push   %ecx
  801ba2:	ff 75 10             	pushl  0x10(%ebp)
  801ba5:	52                   	push   %edx
  801ba6:	50                   	push   %eax
  801ba7:	6a 29                	push   $0x29
  801ba9:	e8 6a fa ff ff       	call   801618 <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	ff 75 10             	pushl  0x10(%ebp)
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	ff 75 08             	pushl  0x8(%ebp)
  801bc3:	6a 12                	push   $0x12
  801bc5:	e8 4e fa ff ff       	call   801618 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcd:	90                   	nop
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	52                   	push   %edx
  801be0:	50                   	push   %eax
  801be1:	6a 2a                	push   $0x2a
  801be3:	e8 30 fa ff ff       	call   801618 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
	return;
  801beb:	90                   	nop
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	50                   	push   %eax
  801bfd:	6a 2b                	push   $0x2b
  801bff:	e8 14 fa ff ff       	call   801618 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	ff 75 0c             	pushl  0xc(%ebp)
  801c15:	ff 75 08             	pushl  0x8(%ebp)
  801c18:	6a 2c                	push   $0x2c
  801c1a:	e8 f9 f9 ff ff       	call   801618 <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
	return;
  801c22:	90                   	nop
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	ff 75 0c             	pushl  0xc(%ebp)
  801c31:	ff 75 08             	pushl  0x8(%ebp)
  801c34:	6a 2d                	push   $0x2d
  801c36:	e8 dd f9 ff ff       	call   801618 <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
	return;
  801c3e:	90                   	nop
}
  801c3f:	c9                   	leave  
  801c40:	c3                   	ret    

00801c41 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 2e                	push   $0x2e
  801c53:	e8 c0 f9 ff ff       	call   801618 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
  801c5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	50                   	push   %eax
  801c72:	6a 2f                	push   $0x2f
  801c74:	e8 9f f9 ff ff       	call   801618 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
	return;
  801c7c:	90                   	nop
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	52                   	push   %edx
  801c8f:	50                   	push   %eax
  801c90:	6a 30                	push   $0x30
  801c92:	e8 81 f9 ff ff       	call   801618 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
	return;
  801c9a:	90                   	nop
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	50                   	push   %eax
  801caf:	6a 31                	push   $0x31
  801cb1:	e8 62 f9 ff ff       	call   801618 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
  801cb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	50                   	push   %eax
  801cd0:	6a 32                	push   $0x32
  801cd2:	e8 41 f9 ff ff       	call   801618 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
	return;
  801cda:	90                   	nop
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	83 e8 04             	sub    $0x4,%eax
  801ce9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801cec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cef:	8b 00                	mov    (%eax),%eax
  801cf1:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	83 e8 04             	sub    $0x4,%eax
  801d02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801d05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d08:	8b 00                	mov    (%eax),%eax
  801d0a:	83 e0 01             	and    $0x1,%eax
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	0f 94 c0             	sete   %al
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801d1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d24:	83 f8 02             	cmp    $0x2,%eax
  801d27:	74 2b                	je     801d54 <alloc_block+0x40>
  801d29:	83 f8 02             	cmp    $0x2,%eax
  801d2c:	7f 07                	jg     801d35 <alloc_block+0x21>
  801d2e:	83 f8 01             	cmp    $0x1,%eax
  801d31:	74 0e                	je     801d41 <alloc_block+0x2d>
  801d33:	eb 58                	jmp    801d8d <alloc_block+0x79>
  801d35:	83 f8 03             	cmp    $0x3,%eax
  801d38:	74 2d                	je     801d67 <alloc_block+0x53>
  801d3a:	83 f8 04             	cmp    $0x4,%eax
  801d3d:	74 3b                	je     801d7a <alloc_block+0x66>
  801d3f:	eb 4c                	jmp    801d8d <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801d41:	83 ec 0c             	sub    $0xc,%esp
  801d44:	ff 75 08             	pushl  0x8(%ebp)
  801d47:	e8 11 03 00 00       	call   80205d <alloc_block_FF>
  801d4c:	83 c4 10             	add    $0x10,%esp
  801d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d52:	eb 4a                	jmp    801d9e <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801d54:	83 ec 0c             	sub    $0xc,%esp
  801d57:	ff 75 08             	pushl  0x8(%ebp)
  801d5a:	e8 c7 19 00 00       	call   803726 <alloc_block_NF>
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d65:	eb 37                	jmp    801d9e <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	ff 75 08             	pushl  0x8(%ebp)
  801d6d:	e8 a7 07 00 00       	call   802519 <alloc_block_BF>
  801d72:	83 c4 10             	add    $0x10,%esp
  801d75:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d78:	eb 24                	jmp    801d9e <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	ff 75 08             	pushl  0x8(%ebp)
  801d80:	e8 84 19 00 00       	call   803709 <alloc_block_WF>
  801d85:	83 c4 10             	add    $0x10,%esp
  801d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d8b:	eb 11                	jmp    801d9e <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801d8d:	83 ec 0c             	sub    $0xc,%esp
  801d90:	68 e8 40 80 00       	push   $0x8040e8
  801d95:	e8 b1 e5 ff ff       	call   80034b <cprintf>
  801d9a:	83 c4 10             	add    $0x10,%esp
		break;
  801d9d:	90                   	nop
	}
	return va;
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	53                   	push   %ebx
  801da7:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801daa:	83 ec 0c             	sub    $0xc,%esp
  801dad:	68 08 41 80 00       	push   $0x804108
  801db2:	e8 94 e5 ff ff       	call   80034b <cprintf>
  801db7:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801dba:	83 ec 0c             	sub    $0xc,%esp
  801dbd:	68 33 41 80 00       	push   $0x804133
  801dc2:	e8 84 e5 ff ff       	call   80034b <cprintf>
  801dc7:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd0:	eb 37                	jmp    801e09 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801dd2:	83 ec 0c             	sub    $0xc,%esp
  801dd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd8:	e8 19 ff ff ff       	call   801cf6 <is_free_block>
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	0f be d8             	movsbl %al,%ebx
  801de3:	83 ec 0c             	sub    $0xc,%esp
  801de6:	ff 75 f4             	pushl  -0xc(%ebp)
  801de9:	e8 ef fe ff ff       	call   801cdd <get_block_size>
  801dee:	83 c4 10             	add    $0x10,%esp
  801df1:	83 ec 04             	sub    $0x4,%esp
  801df4:	53                   	push   %ebx
  801df5:	50                   	push   %eax
  801df6:	68 4b 41 80 00       	push   $0x80414b
  801dfb:	e8 4b e5 ff ff       	call   80034b <cprintf>
  801e00:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801e03:	8b 45 10             	mov    0x10(%ebp),%eax
  801e06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e0d:	74 07                	je     801e16 <print_blocks_list+0x73>
  801e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e12:	8b 00                	mov    (%eax),%eax
  801e14:	eb 05                	jmp    801e1b <print_blocks_list+0x78>
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1b:	89 45 10             	mov    %eax,0x10(%ebp)
  801e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e21:	85 c0                	test   %eax,%eax
  801e23:	75 ad                	jne    801dd2 <print_blocks_list+0x2f>
  801e25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e29:	75 a7                	jne    801dd2 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	68 08 41 80 00       	push   $0x804108
  801e33:	e8 13 e5 ff ff       	call   80034b <cprintf>
  801e38:	83 c4 10             	add    $0x10,%esp

}
  801e3b:	90                   	nop
  801e3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4a:	83 e0 01             	and    $0x1,%eax
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	74 03                	je     801e54 <initialize_dynamic_allocator+0x13>
  801e51:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801e54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e58:	0f 84 c7 01 00 00    	je     802025 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801e5e:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801e65:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801e68:	8b 55 08             	mov    0x8(%ebp),%edx
  801e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6e:	01 d0                	add    %edx,%eax
  801e70:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801e75:	0f 87 ad 01 00 00    	ja     802028 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	0f 89 a5 01 00 00    	jns    80202b <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801e86:	8b 55 08             	mov    0x8(%ebp),%edx
  801e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8c:	01 d0                	add    %edx,%eax
  801e8e:	83 e8 04             	sub    $0x4,%eax
  801e91:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801e96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801e9d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ea2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea5:	e9 87 00 00 00       	jmp    801f31 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801eaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eae:	75 14                	jne    801ec4 <initialize_dynamic_allocator+0x83>
  801eb0:	83 ec 04             	sub    $0x4,%esp
  801eb3:	68 63 41 80 00       	push   $0x804163
  801eb8:	6a 79                	push   $0x79
  801eba:	68 81 41 80 00       	push   $0x804181
  801ebf:	e8 7f 18 00 00       	call   803743 <_panic>
  801ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec7:	8b 00                	mov    (%eax),%eax
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	74 10                	je     801edd <initialize_dynamic_allocator+0x9c>
  801ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed0:	8b 00                	mov    (%eax),%eax
  801ed2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed5:	8b 52 04             	mov    0x4(%edx),%edx
  801ed8:	89 50 04             	mov    %edx,0x4(%eax)
  801edb:	eb 0b                	jmp    801ee8 <initialize_dynamic_allocator+0xa7>
  801edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee0:	8b 40 04             	mov    0x4(%eax),%eax
  801ee3:	a3 30 50 80 00       	mov    %eax,0x805030
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	8b 40 04             	mov    0x4(%eax),%eax
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	74 0f                	je     801f01 <initialize_dynamic_allocator+0xc0>
  801ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef5:	8b 40 04             	mov    0x4(%eax),%eax
  801ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efb:	8b 12                	mov    (%edx),%edx
  801efd:	89 10                	mov    %edx,(%eax)
  801eff:	eb 0a                	jmp    801f0b <initialize_dynamic_allocator+0xca>
  801f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f04:	8b 00                	mov    (%eax),%eax
  801f06:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f1e:	a1 38 50 80 00       	mov    0x805038,%eax
  801f23:	48                   	dec    %eax
  801f24:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801f29:	a1 34 50 80 00       	mov    0x805034,%eax
  801f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f35:	74 07                	je     801f3e <initialize_dynamic_allocator+0xfd>
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	8b 00                	mov    (%eax),%eax
  801f3c:	eb 05                	jmp    801f43 <initialize_dynamic_allocator+0x102>
  801f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f43:	a3 34 50 80 00       	mov    %eax,0x805034
  801f48:	a1 34 50 80 00       	mov    0x805034,%eax
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	0f 85 55 ff ff ff    	jne    801eaa <initialize_dynamic_allocator+0x69>
  801f55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f59:	0f 85 4b ff ff ff    	jne    801eaa <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f68:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801f6e:	a1 44 50 80 00       	mov    0x805044,%eax
  801f73:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801f78:	a1 40 50 80 00       	mov    0x805040,%eax
  801f7d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	83 c0 08             	add    $0x8,%eax
  801f89:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	83 c0 04             	add    $0x4,%eax
  801f92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f95:	83 ea 08             	sub    $0x8,%edx
  801f98:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	01 d0                	add    %edx,%eax
  801fa2:	83 e8 08             	sub    $0x8,%eax
  801fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa8:	83 ea 08             	sub    $0x8,%edx
  801fab:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801fb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801fc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fc4:	75 17                	jne    801fdd <initialize_dynamic_allocator+0x19c>
  801fc6:	83 ec 04             	sub    $0x4,%esp
  801fc9:	68 9c 41 80 00       	push   $0x80419c
  801fce:	68 90 00 00 00       	push   $0x90
  801fd3:	68 81 41 80 00       	push   $0x804181
  801fd8:	e8 66 17 00 00       	call   803743 <_panic>
  801fdd:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801fe3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe6:	89 10                	mov    %edx,(%eax)
  801fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801feb:	8b 00                	mov    (%eax),%eax
  801fed:	85 c0                	test   %eax,%eax
  801fef:	74 0d                	je     801ffe <initialize_dynamic_allocator+0x1bd>
  801ff1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ff6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ff9:	89 50 04             	mov    %edx,0x4(%eax)
  801ffc:	eb 08                	jmp    802006 <initialize_dynamic_allocator+0x1c5>
  801ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802001:	a3 30 50 80 00       	mov    %eax,0x805030
  802006:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802009:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80200e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802011:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802018:	a1 38 50 80 00       	mov    0x805038,%eax
  80201d:	40                   	inc    %eax
  80201e:	a3 38 50 80 00       	mov    %eax,0x805038
  802023:	eb 07                	jmp    80202c <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802025:	90                   	nop
  802026:	eb 04                	jmp    80202c <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802028:	90                   	nop
  802029:	eb 01                	jmp    80202c <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80202b:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802031:	8b 45 10             	mov    0x10(%ebp),%eax
  802034:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80203d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802040:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	83 e8 04             	sub    $0x4,%eax
  802048:	8b 00                	mov    (%eax),%eax
  80204a:	83 e0 fe             	and    $0xfffffffe,%eax
  80204d:	8d 50 f8             	lea    -0x8(%eax),%edx
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	01 c2                	add    %eax,%edx
  802055:	8b 45 0c             	mov    0xc(%ebp),%eax
  802058:	89 02                	mov    %eax,(%edx)
}
  80205a:	90                   	nop
  80205b:	5d                   	pop    %ebp
  80205c:	c3                   	ret    

0080205d <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	83 e0 01             	and    $0x1,%eax
  802069:	85 c0                	test   %eax,%eax
  80206b:	74 03                	je     802070 <alloc_block_FF+0x13>
  80206d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802070:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802074:	77 07                	ja     80207d <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802076:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80207d:	a1 24 50 80 00       	mov    0x805024,%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	75 73                	jne    8020f9 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	83 c0 10             	add    $0x10,%eax
  80208c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80208f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802096:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802099:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209c:	01 d0                	add    %edx,%eax
  80209e:	48                   	dec    %eax
  80209f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8020aa:	f7 75 ec             	divl   -0x14(%ebp)
  8020ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020b0:	29 d0                	sub    %edx,%eax
  8020b2:	c1 e8 0c             	shr    $0xc,%eax
  8020b5:	83 ec 0c             	sub    $0xc,%esp
  8020b8:	50                   	push   %eax
  8020b9:	e8 27 f0 ff ff       	call   8010e5 <sbrk>
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8020c4:	83 ec 0c             	sub    $0xc,%esp
  8020c7:	6a 00                	push   $0x0
  8020c9:	e8 17 f0 ff ff       	call   8010e5 <sbrk>
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8020d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020d7:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8020da:	83 ec 08             	sub    $0x8,%esp
  8020dd:	50                   	push   %eax
  8020de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020e1:	e8 5b fd ff ff       	call   801e41 <initialize_dynamic_allocator>
  8020e6:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8020e9:	83 ec 0c             	sub    $0xc,%esp
  8020ec:	68 bf 41 80 00       	push   $0x8041bf
  8020f1:	e8 55 e2 ff ff       	call   80034b <cprintf>
  8020f6:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8020f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020fd:	75 0a                	jne    802109 <alloc_block_FF+0xac>
	        return NULL;
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802104:	e9 0e 04 00 00       	jmp    802517 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802109:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802110:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802115:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802118:	e9 f3 02 00 00       	jmp    802410 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80211d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802120:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	ff 75 bc             	pushl  -0x44(%ebp)
  802129:	e8 af fb ff ff       	call   801cdd <get_block_size>
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	83 c0 08             	add    $0x8,%eax
  80213a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80213d:	0f 87 c5 02 00 00    	ja     802408 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	83 c0 18             	add    $0x18,%eax
  802149:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80214c:	0f 87 19 02 00 00    	ja     80236b <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802152:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802155:	2b 45 08             	sub    0x8(%ebp),%eax
  802158:	83 e8 08             	sub    $0x8,%eax
  80215b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	8d 50 08             	lea    0x8(%eax),%edx
  802164:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802167:	01 d0                	add    %edx,%eax
  802169:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	83 c0 08             	add    $0x8,%eax
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	6a 01                	push   $0x1
  802177:	50                   	push   %eax
  802178:	ff 75 bc             	pushl  -0x44(%ebp)
  80217b:	e8 ae fe ff ff       	call   80202e <set_block_data>
  802180:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	8b 40 04             	mov    0x4(%eax),%eax
  802189:	85 c0                	test   %eax,%eax
  80218b:	75 68                	jne    8021f5 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80218d:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802191:	75 17                	jne    8021aa <alloc_block_FF+0x14d>
  802193:	83 ec 04             	sub    $0x4,%esp
  802196:	68 9c 41 80 00       	push   $0x80419c
  80219b:	68 d7 00 00 00       	push   $0xd7
  8021a0:	68 81 41 80 00       	push   $0x804181
  8021a5:	e8 99 15 00 00       	call   803743 <_panic>
  8021aa:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021b0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021b3:	89 10                	mov    %edx,(%eax)
  8021b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021b8:	8b 00                	mov    (%eax),%eax
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	74 0d                	je     8021cb <alloc_block_FF+0x16e>
  8021be:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021c3:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021c6:	89 50 04             	mov    %edx,0x4(%eax)
  8021c9:	eb 08                	jmp    8021d3 <alloc_block_FF+0x176>
  8021cb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8021d3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021d6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021db:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e5:	a1 38 50 80 00       	mov    0x805038,%eax
  8021ea:	40                   	inc    %eax
  8021eb:	a3 38 50 80 00       	mov    %eax,0x805038
  8021f0:	e9 dc 00 00 00       	jmp    8022d1 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	8b 00                	mov    (%eax),%eax
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	75 65                	jne    802263 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8021fe:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802202:	75 17                	jne    80221b <alloc_block_FF+0x1be>
  802204:	83 ec 04             	sub    $0x4,%esp
  802207:	68 d0 41 80 00       	push   $0x8041d0
  80220c:	68 db 00 00 00       	push   $0xdb
  802211:	68 81 41 80 00       	push   $0x804181
  802216:	e8 28 15 00 00       	call   803743 <_panic>
  80221b:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802221:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802224:	89 50 04             	mov    %edx,0x4(%eax)
  802227:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80222a:	8b 40 04             	mov    0x4(%eax),%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	74 0c                	je     80223d <alloc_block_FF+0x1e0>
  802231:	a1 30 50 80 00       	mov    0x805030,%eax
  802236:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802239:	89 10                	mov    %edx,(%eax)
  80223b:	eb 08                	jmp    802245 <alloc_block_FF+0x1e8>
  80223d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802240:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802245:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802248:	a3 30 50 80 00       	mov    %eax,0x805030
  80224d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802250:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802256:	a1 38 50 80 00       	mov    0x805038,%eax
  80225b:	40                   	inc    %eax
  80225c:	a3 38 50 80 00       	mov    %eax,0x805038
  802261:	eb 6e                	jmp    8022d1 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802263:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802267:	74 06                	je     80226f <alloc_block_FF+0x212>
  802269:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80226d:	75 17                	jne    802286 <alloc_block_FF+0x229>
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	68 f4 41 80 00       	push   $0x8041f4
  802277:	68 df 00 00 00       	push   $0xdf
  80227c:	68 81 41 80 00       	push   $0x804181
  802281:	e8 bd 14 00 00       	call   803743 <_panic>
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 10                	mov    (%eax),%edx
  80228b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80228e:	89 10                	mov    %edx,(%eax)
  802290:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802293:	8b 00                	mov    (%eax),%eax
  802295:	85 c0                	test   %eax,%eax
  802297:	74 0b                	je     8022a4 <alloc_block_FF+0x247>
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 00                	mov    (%eax),%eax
  80229e:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022a1:	89 50 04             	mov    %edx,0x4(%eax)
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022aa:	89 10                	mov    %edx,(%eax)
  8022ac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b2:	89 50 04             	mov    %edx,0x4(%eax)
  8022b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022b8:	8b 00                	mov    (%eax),%eax
  8022ba:	85 c0                	test   %eax,%eax
  8022bc:	75 08                	jne    8022c6 <alloc_block_FF+0x269>
  8022be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022c1:	a3 30 50 80 00       	mov    %eax,0x805030
  8022c6:	a1 38 50 80 00       	mov    0x805038,%eax
  8022cb:	40                   	inc    %eax
  8022cc:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8022d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d5:	75 17                	jne    8022ee <alloc_block_FF+0x291>
  8022d7:	83 ec 04             	sub    $0x4,%esp
  8022da:	68 63 41 80 00       	push   $0x804163
  8022df:	68 e1 00 00 00       	push   $0xe1
  8022e4:	68 81 41 80 00       	push   $0x804181
  8022e9:	e8 55 14 00 00       	call   803743 <_panic>
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 00                	mov    (%eax),%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	74 10                	je     802307 <alloc_block_FF+0x2aa>
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8b 00                	mov    (%eax),%eax
  8022fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ff:	8b 52 04             	mov    0x4(%edx),%edx
  802302:	89 50 04             	mov    %edx,0x4(%eax)
  802305:	eb 0b                	jmp    802312 <alloc_block_FF+0x2b5>
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 40 04             	mov    0x4(%eax),%eax
  80230d:	a3 30 50 80 00       	mov    %eax,0x805030
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 40 04             	mov    0x4(%eax),%eax
  802318:	85 c0                	test   %eax,%eax
  80231a:	74 0f                	je     80232b <alloc_block_FF+0x2ce>
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 40 04             	mov    0x4(%eax),%eax
  802322:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802325:	8b 12                	mov    (%edx),%edx
  802327:	89 10                	mov    %edx,(%eax)
  802329:	eb 0a                	jmp    802335 <alloc_block_FF+0x2d8>
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	8b 00                	mov    (%eax),%eax
  802330:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802348:	a1 38 50 80 00       	mov    0x805038,%eax
  80234d:	48                   	dec    %eax
  80234e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802353:	83 ec 04             	sub    $0x4,%esp
  802356:	6a 00                	push   $0x0
  802358:	ff 75 b4             	pushl  -0x4c(%ebp)
  80235b:	ff 75 b0             	pushl  -0x50(%ebp)
  80235e:	e8 cb fc ff ff       	call   80202e <set_block_data>
  802363:	83 c4 10             	add    $0x10,%esp
  802366:	e9 95 00 00 00       	jmp    802400 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80236b:	83 ec 04             	sub    $0x4,%esp
  80236e:	6a 01                	push   $0x1
  802370:	ff 75 b8             	pushl  -0x48(%ebp)
  802373:	ff 75 bc             	pushl  -0x44(%ebp)
  802376:	e8 b3 fc ff ff       	call   80202e <set_block_data>
  80237b:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80237e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802382:	75 17                	jne    80239b <alloc_block_FF+0x33e>
  802384:	83 ec 04             	sub    $0x4,%esp
  802387:	68 63 41 80 00       	push   $0x804163
  80238c:	68 e8 00 00 00       	push   $0xe8
  802391:	68 81 41 80 00       	push   $0x804181
  802396:	e8 a8 13 00 00       	call   803743 <_panic>
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	8b 00                	mov    (%eax),%eax
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	74 10                	je     8023b4 <alloc_block_FF+0x357>
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ac:	8b 52 04             	mov    0x4(%edx),%edx
  8023af:	89 50 04             	mov    %edx,0x4(%eax)
  8023b2:	eb 0b                	jmp    8023bf <alloc_block_FF+0x362>
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 40 04             	mov    0x4(%eax),%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	74 0f                	je     8023d8 <alloc_block_FF+0x37b>
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 40 04             	mov    0x4(%eax),%eax
  8023cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d2:	8b 12                	mov    (%edx),%edx
  8023d4:	89 10                	mov    %edx,(%eax)
  8023d6:	eb 0a                	jmp    8023e2 <alloc_block_FF+0x385>
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	8b 00                	mov    (%eax),%eax
  8023dd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f5:	a1 38 50 80 00       	mov    0x805038,%eax
  8023fa:	48                   	dec    %eax
  8023fb:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802400:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802403:	e9 0f 01 00 00       	jmp    802517 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802408:	a1 34 50 80 00       	mov    0x805034,%eax
  80240d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802414:	74 07                	je     80241d <alloc_block_FF+0x3c0>
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 00                	mov    (%eax),%eax
  80241b:	eb 05                	jmp    802422 <alloc_block_FF+0x3c5>
  80241d:	b8 00 00 00 00       	mov    $0x0,%eax
  802422:	a3 34 50 80 00       	mov    %eax,0x805034
  802427:	a1 34 50 80 00       	mov    0x805034,%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	0f 85 e9 fc ff ff    	jne    80211d <alloc_block_FF+0xc0>
  802434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802438:	0f 85 df fc ff ff    	jne    80211d <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	83 c0 08             	add    $0x8,%eax
  802444:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802447:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80244e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802451:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802454:	01 d0                	add    %edx,%eax
  802456:	48                   	dec    %eax
  802457:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80245a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80245d:	ba 00 00 00 00       	mov    $0x0,%edx
  802462:	f7 75 d8             	divl   -0x28(%ebp)
  802465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802468:	29 d0                	sub    %edx,%eax
  80246a:	c1 e8 0c             	shr    $0xc,%eax
  80246d:	83 ec 0c             	sub    $0xc,%esp
  802470:	50                   	push   %eax
  802471:	e8 6f ec ff ff       	call   8010e5 <sbrk>
  802476:	83 c4 10             	add    $0x10,%esp
  802479:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80247c:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802480:	75 0a                	jne    80248c <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
  802487:	e9 8b 00 00 00       	jmp    802517 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80248c:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802493:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802496:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802499:	01 d0                	add    %edx,%eax
  80249b:	48                   	dec    %eax
  80249c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80249f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a7:	f7 75 cc             	divl   -0x34(%ebp)
  8024aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024ad:	29 d0                	sub    %edx,%eax
  8024af:	8d 50 fc             	lea    -0x4(%eax),%edx
  8024b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024b5:	01 d0                	add    %edx,%eax
  8024b7:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8024bc:	a1 40 50 80 00       	mov    0x805040,%eax
  8024c1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8024c7:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8024ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024d1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024d4:	01 d0                	add    %edx,%eax
  8024d6:	48                   	dec    %eax
  8024d7:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8024da:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8024e2:	f7 75 c4             	divl   -0x3c(%ebp)
  8024e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024e8:	29 d0                	sub    %edx,%eax
  8024ea:	83 ec 04             	sub    $0x4,%esp
  8024ed:	6a 01                	push   $0x1
  8024ef:	50                   	push   %eax
  8024f0:	ff 75 d0             	pushl  -0x30(%ebp)
  8024f3:	e8 36 fb ff ff       	call   80202e <set_block_data>
  8024f8:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8024fb:	83 ec 0c             	sub    $0xc,%esp
  8024fe:	ff 75 d0             	pushl  -0x30(%ebp)
  802501:	e8 f8 09 00 00       	call   802efe <free_block>
  802506:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802509:	83 ec 0c             	sub    $0xc,%esp
  80250c:	ff 75 08             	pushl  0x8(%ebp)
  80250f:	e8 49 fb ff ff       	call   80205d <alloc_block_FF>
  802514:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
  80251c:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80251f:	8b 45 08             	mov    0x8(%ebp),%eax
  802522:	83 e0 01             	and    $0x1,%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	74 03                	je     80252c <alloc_block_BF+0x13>
  802529:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80252c:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802530:	77 07                	ja     802539 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802532:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802539:	a1 24 50 80 00       	mov    0x805024,%eax
  80253e:	85 c0                	test   %eax,%eax
  802540:	75 73                	jne    8025b5 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	83 c0 10             	add    $0x10,%eax
  802548:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80254b:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802552:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802555:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802558:	01 d0                	add    %edx,%eax
  80255a:	48                   	dec    %eax
  80255b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80255e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802561:	ba 00 00 00 00       	mov    $0x0,%edx
  802566:	f7 75 e0             	divl   -0x20(%ebp)
  802569:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80256c:	29 d0                	sub    %edx,%eax
  80256e:	c1 e8 0c             	shr    $0xc,%eax
  802571:	83 ec 0c             	sub    $0xc,%esp
  802574:	50                   	push   %eax
  802575:	e8 6b eb ff ff       	call   8010e5 <sbrk>
  80257a:	83 c4 10             	add    $0x10,%esp
  80257d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802580:	83 ec 0c             	sub    $0xc,%esp
  802583:	6a 00                	push   $0x0
  802585:	e8 5b eb ff ff       	call   8010e5 <sbrk>
  80258a:	83 c4 10             	add    $0x10,%esp
  80258d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802590:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802593:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802596:	83 ec 08             	sub    $0x8,%esp
  802599:	50                   	push   %eax
  80259a:	ff 75 d8             	pushl  -0x28(%ebp)
  80259d:	e8 9f f8 ff ff       	call   801e41 <initialize_dynamic_allocator>
  8025a2:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025a5:	83 ec 0c             	sub    $0xc,%esp
  8025a8:	68 bf 41 80 00       	push   $0x8041bf
  8025ad:	e8 99 dd ff ff       	call   80034b <cprintf>
  8025b2:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8025b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8025bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8025c3:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8025ca:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8025d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d9:	e9 1d 01 00 00       	jmp    8026fb <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8025e4:	83 ec 0c             	sub    $0xc,%esp
  8025e7:	ff 75 a8             	pushl  -0x58(%ebp)
  8025ea:	e8 ee f6 ff ff       	call   801cdd <get_block_size>
  8025ef:	83 c4 10             	add    $0x10,%esp
  8025f2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	83 c0 08             	add    $0x8,%eax
  8025fb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025fe:	0f 87 ef 00 00 00    	ja     8026f3 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	83 c0 18             	add    $0x18,%eax
  80260a:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80260d:	77 1d                	ja     80262c <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80260f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802612:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802615:	0f 86 d8 00 00 00    	jbe    8026f3 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80261b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80261e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802621:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802624:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802627:	e9 c7 00 00 00       	jmp    8026f3 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80262c:	8b 45 08             	mov    0x8(%ebp),%eax
  80262f:	83 c0 08             	add    $0x8,%eax
  802632:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802635:	0f 85 9d 00 00 00    	jne    8026d8 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80263b:	83 ec 04             	sub    $0x4,%esp
  80263e:	6a 01                	push   $0x1
  802640:	ff 75 a4             	pushl  -0x5c(%ebp)
  802643:	ff 75 a8             	pushl  -0x58(%ebp)
  802646:	e8 e3 f9 ff ff       	call   80202e <set_block_data>
  80264b:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80264e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802652:	75 17                	jne    80266b <alloc_block_BF+0x152>
  802654:	83 ec 04             	sub    $0x4,%esp
  802657:	68 63 41 80 00       	push   $0x804163
  80265c:	68 2c 01 00 00       	push   $0x12c
  802661:	68 81 41 80 00       	push   $0x804181
  802666:	e8 d8 10 00 00       	call   803743 <_panic>
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	74 10                	je     802684 <alloc_block_BF+0x16b>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267c:	8b 52 04             	mov    0x4(%edx),%edx
  80267f:	89 50 04             	mov    %edx,0x4(%eax)
  802682:	eb 0b                	jmp    80268f <alloc_block_BF+0x176>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 40 04             	mov    0x4(%eax),%eax
  80268a:	a3 30 50 80 00       	mov    %eax,0x805030
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 04             	mov    0x4(%eax),%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	74 0f                	je     8026a8 <alloc_block_BF+0x18f>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 40 04             	mov    0x4(%eax),%eax
  80269f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a2:	8b 12                	mov    (%edx),%edx
  8026a4:	89 10                	mov    %edx,(%eax)
  8026a6:	eb 0a                	jmp    8026b2 <alloc_block_BF+0x199>
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 00                	mov    (%eax),%eax
  8026ad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8026ca:	48                   	dec    %eax
  8026cb:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8026d0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026d3:	e9 01 04 00 00       	jmp    802ad9 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  8026d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026db:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026de:	76 13                	jbe    8026f3 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8026e0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8026e7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8026ed:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026f0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8026f3:	a1 34 50 80 00       	mov    0x805034,%eax
  8026f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ff:	74 07                	je     802708 <alloc_block_BF+0x1ef>
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 00                	mov    (%eax),%eax
  802706:	eb 05                	jmp    80270d <alloc_block_BF+0x1f4>
  802708:	b8 00 00 00 00       	mov    $0x0,%eax
  80270d:	a3 34 50 80 00       	mov    %eax,0x805034
  802712:	a1 34 50 80 00       	mov    0x805034,%eax
  802717:	85 c0                	test   %eax,%eax
  802719:	0f 85 bf fe ff ff    	jne    8025de <alloc_block_BF+0xc5>
  80271f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802723:	0f 85 b5 fe ff ff    	jne    8025de <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802729:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80272d:	0f 84 26 02 00 00    	je     802959 <alloc_block_BF+0x440>
  802733:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802737:	0f 85 1c 02 00 00    	jne    802959 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80273d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802740:	2b 45 08             	sub    0x8(%ebp),%eax
  802743:	83 e8 08             	sub    $0x8,%eax
  802746:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	8d 50 08             	lea    0x8(%eax),%edx
  80274f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802752:	01 d0                	add    %edx,%eax
  802754:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802757:	8b 45 08             	mov    0x8(%ebp),%eax
  80275a:	83 c0 08             	add    $0x8,%eax
  80275d:	83 ec 04             	sub    $0x4,%esp
  802760:	6a 01                	push   $0x1
  802762:	50                   	push   %eax
  802763:	ff 75 f0             	pushl  -0x10(%ebp)
  802766:	e8 c3 f8 ff ff       	call   80202e <set_block_data>
  80276b:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80276e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802771:	8b 40 04             	mov    0x4(%eax),%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	75 68                	jne    8027e0 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802778:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80277c:	75 17                	jne    802795 <alloc_block_BF+0x27c>
  80277e:	83 ec 04             	sub    $0x4,%esp
  802781:	68 9c 41 80 00       	push   $0x80419c
  802786:	68 45 01 00 00       	push   $0x145
  80278b:	68 81 41 80 00       	push   $0x804181
  802790:	e8 ae 0f 00 00       	call   803743 <_panic>
  802795:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80279b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80279e:	89 10                	mov    %edx,(%eax)
  8027a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027a3:	8b 00                	mov    (%eax),%eax
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	74 0d                	je     8027b6 <alloc_block_BF+0x29d>
  8027a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027ae:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027b1:	89 50 04             	mov    %edx,0x4(%eax)
  8027b4:	eb 08                	jmp    8027be <alloc_block_BF+0x2a5>
  8027b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8027be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8027d5:	40                   	inc    %eax
  8027d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8027db:	e9 dc 00 00 00       	jmp    8028bc <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8027e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e3:	8b 00                	mov    (%eax),%eax
  8027e5:	85 c0                	test   %eax,%eax
  8027e7:	75 65                	jne    80284e <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027ed:	75 17                	jne    802806 <alloc_block_BF+0x2ed>
  8027ef:	83 ec 04             	sub    $0x4,%esp
  8027f2:	68 d0 41 80 00       	push   $0x8041d0
  8027f7:	68 4a 01 00 00       	push   $0x14a
  8027fc:	68 81 41 80 00       	push   $0x804181
  802801:	e8 3d 0f 00 00       	call   803743 <_panic>
  802806:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80280c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80280f:	89 50 04             	mov    %edx,0x4(%eax)
  802812:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802815:	8b 40 04             	mov    0x4(%eax),%eax
  802818:	85 c0                	test   %eax,%eax
  80281a:	74 0c                	je     802828 <alloc_block_BF+0x30f>
  80281c:	a1 30 50 80 00       	mov    0x805030,%eax
  802821:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802824:	89 10                	mov    %edx,(%eax)
  802826:	eb 08                	jmp    802830 <alloc_block_BF+0x317>
  802828:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80282b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802830:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802833:	a3 30 50 80 00       	mov    %eax,0x805030
  802838:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802841:	a1 38 50 80 00       	mov    0x805038,%eax
  802846:	40                   	inc    %eax
  802847:	a3 38 50 80 00       	mov    %eax,0x805038
  80284c:	eb 6e                	jmp    8028bc <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80284e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802852:	74 06                	je     80285a <alloc_block_BF+0x341>
  802854:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802858:	75 17                	jne    802871 <alloc_block_BF+0x358>
  80285a:	83 ec 04             	sub    $0x4,%esp
  80285d:	68 f4 41 80 00       	push   $0x8041f4
  802862:	68 4f 01 00 00       	push   $0x14f
  802867:	68 81 41 80 00       	push   $0x804181
  80286c:	e8 d2 0e 00 00       	call   803743 <_panic>
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802874:	8b 10                	mov    (%eax),%edx
  802876:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802879:	89 10                	mov    %edx,(%eax)
  80287b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80287e:	8b 00                	mov    (%eax),%eax
  802880:	85 c0                	test   %eax,%eax
  802882:	74 0b                	je     80288f <alloc_block_BF+0x376>
  802884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802887:	8b 00                	mov    (%eax),%eax
  802889:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80288c:	89 50 04             	mov    %edx,0x4(%eax)
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802895:	89 10                	mov    %edx,(%eax)
  802897:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80289a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80289d:	89 50 04             	mov    %edx,0x4(%eax)
  8028a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	75 08                	jne    8028b1 <alloc_block_BF+0x398>
  8028a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8028b1:	a1 38 50 80 00       	mov    0x805038,%eax
  8028b6:	40                   	inc    %eax
  8028b7:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8028bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c0:	75 17                	jne    8028d9 <alloc_block_BF+0x3c0>
  8028c2:	83 ec 04             	sub    $0x4,%esp
  8028c5:	68 63 41 80 00       	push   $0x804163
  8028ca:	68 51 01 00 00       	push   $0x151
  8028cf:	68 81 41 80 00       	push   $0x804181
  8028d4:	e8 6a 0e 00 00       	call   803743 <_panic>
  8028d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	74 10                	je     8028f2 <alloc_block_BF+0x3d9>
  8028e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ea:	8b 52 04             	mov    0x4(%edx),%edx
  8028ed:	89 50 04             	mov    %edx,0x4(%eax)
  8028f0:	eb 0b                	jmp    8028fd <alloc_block_BF+0x3e4>
  8028f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f5:	8b 40 04             	mov    0x4(%eax),%eax
  8028f8:	a3 30 50 80 00       	mov    %eax,0x805030
  8028fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802900:	8b 40 04             	mov    0x4(%eax),%eax
  802903:	85 c0                	test   %eax,%eax
  802905:	74 0f                	je     802916 <alloc_block_BF+0x3fd>
  802907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290a:	8b 40 04             	mov    0x4(%eax),%eax
  80290d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802910:	8b 12                	mov    (%edx),%edx
  802912:	89 10                	mov    %edx,(%eax)
  802914:	eb 0a                	jmp    802920 <alloc_block_BF+0x407>
  802916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802919:	8b 00                	mov    (%eax),%eax
  80291b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802923:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802933:	a1 38 50 80 00       	mov    0x805038,%eax
  802938:	48                   	dec    %eax
  802939:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80293e:	83 ec 04             	sub    $0x4,%esp
  802941:	6a 00                	push   $0x0
  802943:	ff 75 d0             	pushl  -0x30(%ebp)
  802946:	ff 75 cc             	pushl  -0x34(%ebp)
  802949:	e8 e0 f6 ff ff       	call   80202e <set_block_data>
  80294e:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802954:	e9 80 01 00 00       	jmp    802ad9 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802959:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80295d:	0f 85 9d 00 00 00    	jne    802a00 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802963:	83 ec 04             	sub    $0x4,%esp
  802966:	6a 01                	push   $0x1
  802968:	ff 75 ec             	pushl  -0x14(%ebp)
  80296b:	ff 75 f0             	pushl  -0x10(%ebp)
  80296e:	e8 bb f6 ff ff       	call   80202e <set_block_data>
  802973:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802976:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80297a:	75 17                	jne    802993 <alloc_block_BF+0x47a>
  80297c:	83 ec 04             	sub    $0x4,%esp
  80297f:	68 63 41 80 00       	push   $0x804163
  802984:	68 58 01 00 00       	push   $0x158
  802989:	68 81 41 80 00       	push   $0x804181
  80298e:	e8 b0 0d 00 00       	call   803743 <_panic>
  802993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802996:	8b 00                	mov    (%eax),%eax
  802998:	85 c0                	test   %eax,%eax
  80299a:	74 10                	je     8029ac <alloc_block_BF+0x493>
  80299c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299f:	8b 00                	mov    (%eax),%eax
  8029a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a4:	8b 52 04             	mov    0x4(%edx),%edx
  8029a7:	89 50 04             	mov    %edx,0x4(%eax)
  8029aa:	eb 0b                	jmp    8029b7 <alloc_block_BF+0x49e>
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8029b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ba:	8b 40 04             	mov    0x4(%eax),%eax
  8029bd:	85 c0                	test   %eax,%eax
  8029bf:	74 0f                	je     8029d0 <alloc_block_BF+0x4b7>
  8029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c4:	8b 40 04             	mov    0x4(%eax),%eax
  8029c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ca:	8b 12                	mov    (%edx),%edx
  8029cc:	89 10                	mov    %edx,(%eax)
  8029ce:	eb 0a                	jmp    8029da <alloc_block_BF+0x4c1>
  8029d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8029f2:	48                   	dec    %eax
  8029f3:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	e9 d9 00 00 00       	jmp    802ad9 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	83 c0 08             	add    $0x8,%eax
  802a06:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a09:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802a10:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a16:	01 d0                	add    %edx,%eax
  802a18:	48                   	dec    %eax
  802a19:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802a1c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a24:	f7 75 c4             	divl   -0x3c(%ebp)
  802a27:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a2a:	29 d0                	sub    %edx,%eax
  802a2c:	c1 e8 0c             	shr    $0xc,%eax
  802a2f:	83 ec 0c             	sub    $0xc,%esp
  802a32:	50                   	push   %eax
  802a33:	e8 ad e6 ff ff       	call   8010e5 <sbrk>
  802a38:	83 c4 10             	add    $0x10,%esp
  802a3b:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802a3e:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802a42:	75 0a                	jne    802a4e <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802a44:	b8 00 00 00 00       	mov    $0x0,%eax
  802a49:	e9 8b 00 00 00       	jmp    802ad9 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a4e:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802a55:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a58:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a5b:	01 d0                	add    %edx,%eax
  802a5d:	48                   	dec    %eax
  802a5e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802a61:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a64:	ba 00 00 00 00       	mov    $0x0,%edx
  802a69:	f7 75 b8             	divl   -0x48(%ebp)
  802a6c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a6f:	29 d0                	sub    %edx,%eax
  802a71:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a74:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a77:	01 d0                	add    %edx,%eax
  802a79:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802a7e:	a1 40 50 80 00       	mov    0x805040,%eax
  802a83:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a89:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a90:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a93:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a96:	01 d0                	add    %edx,%eax
  802a98:	48                   	dec    %eax
  802a99:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a9c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a9f:	ba 00 00 00 00       	mov    $0x0,%edx
  802aa4:	f7 75 b0             	divl   -0x50(%ebp)
  802aa7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802aaa:	29 d0                	sub    %edx,%eax
  802aac:	83 ec 04             	sub    $0x4,%esp
  802aaf:	6a 01                	push   $0x1
  802ab1:	50                   	push   %eax
  802ab2:	ff 75 bc             	pushl  -0x44(%ebp)
  802ab5:	e8 74 f5 ff ff       	call   80202e <set_block_data>
  802aba:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802abd:	83 ec 0c             	sub    $0xc,%esp
  802ac0:	ff 75 bc             	pushl  -0x44(%ebp)
  802ac3:	e8 36 04 00 00       	call   802efe <free_block>
  802ac8:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802acb:	83 ec 0c             	sub    $0xc,%esp
  802ace:	ff 75 08             	pushl  0x8(%ebp)
  802ad1:	e8 43 fa ff ff       	call   802519 <alloc_block_BF>
  802ad6:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802ad9:	c9                   	leave  
  802ada:	c3                   	ret    

00802adb <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802adb:	55                   	push   %ebp
  802adc:	89 e5                	mov    %esp,%ebp
  802ade:	53                   	push   %ebx
  802adf:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ae2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ae9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802af0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af4:	74 1e                	je     802b14 <merging+0x39>
  802af6:	ff 75 08             	pushl  0x8(%ebp)
  802af9:	e8 df f1 ff ff       	call   801cdd <get_block_size>
  802afe:	83 c4 04             	add    $0x4,%esp
  802b01:	89 c2                	mov    %eax,%edx
  802b03:	8b 45 08             	mov    0x8(%ebp),%eax
  802b06:	01 d0                	add    %edx,%eax
  802b08:	3b 45 10             	cmp    0x10(%ebp),%eax
  802b0b:	75 07                	jne    802b14 <merging+0x39>
		prev_is_free = 1;
  802b0d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802b14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b18:	74 1e                	je     802b38 <merging+0x5d>
  802b1a:	ff 75 10             	pushl  0x10(%ebp)
  802b1d:	e8 bb f1 ff ff       	call   801cdd <get_block_size>
  802b22:	83 c4 04             	add    $0x4,%esp
  802b25:	89 c2                	mov    %eax,%edx
  802b27:	8b 45 10             	mov    0x10(%ebp),%eax
  802b2a:	01 d0                	add    %edx,%eax
  802b2c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b2f:	75 07                	jne    802b38 <merging+0x5d>
		next_is_free = 1;
  802b31:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802b38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3c:	0f 84 cc 00 00 00    	je     802c0e <merging+0x133>
  802b42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b46:	0f 84 c2 00 00 00    	je     802c0e <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802b4c:	ff 75 08             	pushl  0x8(%ebp)
  802b4f:	e8 89 f1 ff ff       	call   801cdd <get_block_size>
  802b54:	83 c4 04             	add    $0x4,%esp
  802b57:	89 c3                	mov    %eax,%ebx
  802b59:	ff 75 10             	pushl  0x10(%ebp)
  802b5c:	e8 7c f1 ff ff       	call   801cdd <get_block_size>
  802b61:	83 c4 04             	add    $0x4,%esp
  802b64:	01 c3                	add    %eax,%ebx
  802b66:	ff 75 0c             	pushl  0xc(%ebp)
  802b69:	e8 6f f1 ff ff       	call   801cdd <get_block_size>
  802b6e:	83 c4 04             	add    $0x4,%esp
  802b71:	01 d8                	add    %ebx,%eax
  802b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b76:	6a 00                	push   $0x0
  802b78:	ff 75 ec             	pushl  -0x14(%ebp)
  802b7b:	ff 75 08             	pushl  0x8(%ebp)
  802b7e:	e8 ab f4 ff ff       	call   80202e <set_block_data>
  802b83:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802b86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b8a:	75 17                	jne    802ba3 <merging+0xc8>
  802b8c:	83 ec 04             	sub    $0x4,%esp
  802b8f:	68 63 41 80 00       	push   $0x804163
  802b94:	68 7d 01 00 00       	push   $0x17d
  802b99:	68 81 41 80 00       	push   $0x804181
  802b9e:	e8 a0 0b 00 00       	call   803743 <_panic>
  802ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	85 c0                	test   %eax,%eax
  802baa:	74 10                	je     802bbc <merging+0xe1>
  802bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bb4:	8b 52 04             	mov    0x4(%edx),%edx
  802bb7:	89 50 04             	mov    %edx,0x4(%eax)
  802bba:	eb 0b                	jmp    802bc7 <merging+0xec>
  802bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bbf:	8b 40 04             	mov    0x4(%eax),%eax
  802bc2:	a3 30 50 80 00       	mov    %eax,0x805030
  802bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bca:	8b 40 04             	mov    0x4(%eax),%eax
  802bcd:	85 c0                	test   %eax,%eax
  802bcf:	74 0f                	je     802be0 <merging+0x105>
  802bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd4:	8b 40 04             	mov    0x4(%eax),%eax
  802bd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bda:	8b 12                	mov    (%edx),%edx
  802bdc:	89 10                	mov    %edx,(%eax)
  802bde:	eb 0a                	jmp    802bea <merging+0x10f>
  802be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be3:	8b 00                	mov    (%eax),%eax
  802be5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bfd:	a1 38 50 80 00       	mov    0x805038,%eax
  802c02:	48                   	dec    %eax
  802c03:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802c08:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c09:	e9 ea 02 00 00       	jmp    802ef8 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802c0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c12:	74 3b                	je     802c4f <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802c14:	83 ec 0c             	sub    $0xc,%esp
  802c17:	ff 75 08             	pushl  0x8(%ebp)
  802c1a:	e8 be f0 ff ff       	call   801cdd <get_block_size>
  802c1f:	83 c4 10             	add    $0x10,%esp
  802c22:	89 c3                	mov    %eax,%ebx
  802c24:	83 ec 0c             	sub    $0xc,%esp
  802c27:	ff 75 10             	pushl  0x10(%ebp)
  802c2a:	e8 ae f0 ff ff       	call   801cdd <get_block_size>
  802c2f:	83 c4 10             	add    $0x10,%esp
  802c32:	01 d8                	add    %ebx,%eax
  802c34:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c37:	83 ec 04             	sub    $0x4,%esp
  802c3a:	6a 00                	push   $0x0
  802c3c:	ff 75 e8             	pushl  -0x18(%ebp)
  802c3f:	ff 75 08             	pushl  0x8(%ebp)
  802c42:	e8 e7 f3 ff ff       	call   80202e <set_block_data>
  802c47:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c4a:	e9 a9 02 00 00       	jmp    802ef8 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802c4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c53:	0f 84 2d 01 00 00    	je     802d86 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802c59:	83 ec 0c             	sub    $0xc,%esp
  802c5c:	ff 75 10             	pushl  0x10(%ebp)
  802c5f:	e8 79 f0 ff ff       	call   801cdd <get_block_size>
  802c64:	83 c4 10             	add    $0x10,%esp
  802c67:	89 c3                	mov    %eax,%ebx
  802c69:	83 ec 0c             	sub    $0xc,%esp
  802c6c:	ff 75 0c             	pushl  0xc(%ebp)
  802c6f:	e8 69 f0 ff ff       	call   801cdd <get_block_size>
  802c74:	83 c4 10             	add    $0x10,%esp
  802c77:	01 d8                	add    %ebx,%eax
  802c79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802c7c:	83 ec 04             	sub    $0x4,%esp
  802c7f:	6a 00                	push   $0x0
  802c81:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c84:	ff 75 10             	pushl  0x10(%ebp)
  802c87:	e8 a2 f3 ff ff       	call   80202e <set_block_data>
  802c8c:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  802c92:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c99:	74 06                	je     802ca1 <merging+0x1c6>
  802c9b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c9f:	75 17                	jne    802cb8 <merging+0x1dd>
  802ca1:	83 ec 04             	sub    $0x4,%esp
  802ca4:	68 28 42 80 00       	push   $0x804228
  802ca9:	68 8d 01 00 00       	push   $0x18d
  802cae:	68 81 41 80 00       	push   $0x804181
  802cb3:	e8 8b 0a 00 00       	call   803743 <_panic>
  802cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cbb:	8b 50 04             	mov    0x4(%eax),%edx
  802cbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc1:	89 50 04             	mov    %edx,0x4(%eax)
  802cc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cca:	89 10                	mov    %edx,(%eax)
  802ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	85 c0                	test   %eax,%eax
  802cd4:	74 0d                	je     802ce3 <merging+0x208>
  802cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd9:	8b 40 04             	mov    0x4(%eax),%eax
  802cdc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cdf:	89 10                	mov    %edx,(%eax)
  802ce1:	eb 08                	jmp    802ceb <merging+0x210>
  802ce3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cf1:	89 50 04             	mov    %edx,0x4(%eax)
  802cf4:	a1 38 50 80 00       	mov    0x805038,%eax
  802cf9:	40                   	inc    %eax
  802cfa:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802cff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d03:	75 17                	jne    802d1c <merging+0x241>
  802d05:	83 ec 04             	sub    $0x4,%esp
  802d08:	68 63 41 80 00       	push   $0x804163
  802d0d:	68 8e 01 00 00       	push   $0x18e
  802d12:	68 81 41 80 00       	push   $0x804181
  802d17:	e8 27 0a 00 00       	call   803743 <_panic>
  802d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1f:	8b 00                	mov    (%eax),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	74 10                	je     802d35 <merging+0x25a>
  802d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d28:	8b 00                	mov    (%eax),%eax
  802d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d2d:	8b 52 04             	mov    0x4(%edx),%edx
  802d30:	89 50 04             	mov    %edx,0x4(%eax)
  802d33:	eb 0b                	jmp    802d40 <merging+0x265>
  802d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d38:	8b 40 04             	mov    0x4(%eax),%eax
  802d3b:	a3 30 50 80 00       	mov    %eax,0x805030
  802d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d43:	8b 40 04             	mov    0x4(%eax),%eax
  802d46:	85 c0                	test   %eax,%eax
  802d48:	74 0f                	je     802d59 <merging+0x27e>
  802d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4d:	8b 40 04             	mov    0x4(%eax),%eax
  802d50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d53:	8b 12                	mov    (%edx),%edx
  802d55:	89 10                	mov    %edx,(%eax)
  802d57:	eb 0a                	jmp    802d63 <merging+0x288>
  802d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d5c:	8b 00                	mov    (%eax),%eax
  802d5e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d76:	a1 38 50 80 00       	mov    0x805038,%eax
  802d7b:	48                   	dec    %eax
  802d7c:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d81:	e9 72 01 00 00       	jmp    802ef8 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802d86:	8b 45 10             	mov    0x10(%ebp),%eax
  802d89:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802d8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d90:	74 79                	je     802e0b <merging+0x330>
  802d92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d96:	74 73                	je     802e0b <merging+0x330>
  802d98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d9c:	74 06                	je     802da4 <merging+0x2c9>
  802d9e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802da2:	75 17                	jne    802dbb <merging+0x2e0>
  802da4:	83 ec 04             	sub    $0x4,%esp
  802da7:	68 f4 41 80 00       	push   $0x8041f4
  802dac:	68 94 01 00 00       	push   $0x194
  802db1:	68 81 41 80 00       	push   $0x804181
  802db6:	e8 88 09 00 00       	call   803743 <_panic>
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	8b 10                	mov    (%eax),%edx
  802dc0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc3:	89 10                	mov    %edx,(%eax)
  802dc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc8:	8b 00                	mov    (%eax),%eax
  802dca:	85 c0                	test   %eax,%eax
  802dcc:	74 0b                	je     802dd9 <merging+0x2fe>
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dd6:	89 50 04             	mov    %edx,0x4(%eax)
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ddf:	89 10                	mov    %edx,(%eax)
  802de1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de4:	8b 55 08             	mov    0x8(%ebp),%edx
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
  802dea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	85 c0                	test   %eax,%eax
  802df1:	75 08                	jne    802dfb <merging+0x320>
  802df3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df6:	a3 30 50 80 00       	mov    %eax,0x805030
  802dfb:	a1 38 50 80 00       	mov    0x805038,%eax
  802e00:	40                   	inc    %eax
  802e01:	a3 38 50 80 00       	mov    %eax,0x805038
  802e06:	e9 ce 00 00 00       	jmp    802ed9 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802e0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e0f:	74 65                	je     802e76 <merging+0x39b>
  802e11:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e15:	75 17                	jne    802e2e <merging+0x353>
  802e17:	83 ec 04             	sub    $0x4,%esp
  802e1a:	68 d0 41 80 00       	push   $0x8041d0
  802e1f:	68 95 01 00 00       	push   $0x195
  802e24:	68 81 41 80 00       	push   $0x804181
  802e29:	e8 15 09 00 00       	call   803743 <_panic>
  802e2e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e37:	89 50 04             	mov    %edx,0x4(%eax)
  802e3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e3d:	8b 40 04             	mov    0x4(%eax),%eax
  802e40:	85 c0                	test   %eax,%eax
  802e42:	74 0c                	je     802e50 <merging+0x375>
  802e44:	a1 30 50 80 00       	mov    0x805030,%eax
  802e49:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e4c:	89 10                	mov    %edx,(%eax)
  802e4e:	eb 08                	jmp    802e58 <merging+0x37d>
  802e50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e53:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e5b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e69:	a1 38 50 80 00       	mov    0x805038,%eax
  802e6e:	40                   	inc    %eax
  802e6f:	a3 38 50 80 00       	mov    %eax,0x805038
  802e74:	eb 63                	jmp    802ed9 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802e76:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e7a:	75 17                	jne    802e93 <merging+0x3b8>
  802e7c:	83 ec 04             	sub    $0x4,%esp
  802e7f:	68 9c 41 80 00       	push   $0x80419c
  802e84:	68 98 01 00 00       	push   $0x198
  802e89:	68 81 41 80 00       	push   $0x804181
  802e8e:	e8 b0 08 00 00       	call   803743 <_panic>
  802e93:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9c:	89 10                	mov    %edx,(%eax)
  802e9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 0d                	je     802eb4 <merging+0x3d9>
  802ea7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802eaf:	89 50 04             	mov    %edx,0x4(%eax)
  802eb2:	eb 08                	jmp    802ebc <merging+0x3e1>
  802eb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb7:	a3 30 50 80 00       	mov    %eax,0x805030
  802ebc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ebf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ec4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ece:	a1 38 50 80 00       	mov    0x805038,%eax
  802ed3:	40                   	inc    %eax
  802ed4:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802ed9:	83 ec 0c             	sub    $0xc,%esp
  802edc:	ff 75 10             	pushl  0x10(%ebp)
  802edf:	e8 f9 ed ff ff       	call   801cdd <get_block_size>
  802ee4:	83 c4 10             	add    $0x10,%esp
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	6a 00                	push   $0x0
  802eec:	50                   	push   %eax
  802eed:	ff 75 10             	pushl  0x10(%ebp)
  802ef0:	e8 39 f1 ff ff       	call   80202e <set_block_data>
  802ef5:	83 c4 10             	add    $0x10,%esp
	}
}
  802ef8:	90                   	nop
  802ef9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802efc:	c9                   	leave  
  802efd:	c3                   	ret    

00802efe <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802efe:	55                   	push   %ebp
  802eff:	89 e5                	mov    %esp,%ebp
  802f01:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802f04:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f09:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802f0c:	a1 30 50 80 00       	mov    0x805030,%eax
  802f11:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f14:	73 1b                	jae    802f31 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802f16:	a1 30 50 80 00       	mov    0x805030,%eax
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	ff 75 08             	pushl  0x8(%ebp)
  802f21:	6a 00                	push   $0x0
  802f23:	50                   	push   %eax
  802f24:	e8 b2 fb ff ff       	call   802adb <merging>
  802f29:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f2c:	e9 8b 00 00 00       	jmp    802fbc <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802f31:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f36:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f39:	76 18                	jbe    802f53 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802f3b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f40:	83 ec 04             	sub    $0x4,%esp
  802f43:	ff 75 08             	pushl  0x8(%ebp)
  802f46:	50                   	push   %eax
  802f47:	6a 00                	push   $0x0
  802f49:	e8 8d fb ff ff       	call   802adb <merging>
  802f4e:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f51:	eb 69                	jmp    802fbc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f53:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f5b:	eb 39                	jmp    802f96 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f63:	73 29                	jae    802f8e <free_block+0x90>
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 00                	mov    (%eax),%eax
  802f6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f6d:	76 1f                	jbe    802f8e <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802f77:	83 ec 04             	sub    $0x4,%esp
  802f7a:	ff 75 08             	pushl  0x8(%ebp)
  802f7d:	ff 75 f0             	pushl  -0x10(%ebp)
  802f80:	ff 75 f4             	pushl  -0xc(%ebp)
  802f83:	e8 53 fb ff ff       	call   802adb <merging>
  802f88:	83 c4 10             	add    $0x10,%esp
			break;
  802f8b:	90                   	nop
		}
	}
}
  802f8c:	eb 2e                	jmp    802fbc <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f8e:	a1 34 50 80 00       	mov    0x805034,%eax
  802f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9a:	74 07                	je     802fa3 <free_block+0xa5>
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	eb 05                	jmp    802fa8 <free_block+0xaa>
  802fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa8:	a3 34 50 80 00       	mov    %eax,0x805034
  802fad:	a1 34 50 80 00       	mov    0x805034,%eax
  802fb2:	85 c0                	test   %eax,%eax
  802fb4:	75 a7                	jne    802f5d <free_block+0x5f>
  802fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fba:	75 a1                	jne    802f5d <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fbc:	90                   	nop
  802fbd:	c9                   	leave  
  802fbe:	c3                   	ret    

00802fbf <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802fbf:	55                   	push   %ebp
  802fc0:	89 e5                	mov    %esp,%ebp
  802fc2:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802fc5:	ff 75 08             	pushl  0x8(%ebp)
  802fc8:	e8 10 ed ff ff       	call   801cdd <get_block_size>
  802fcd:	83 c4 04             	add    $0x4,%esp
  802fd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802fd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802fda:	eb 17                	jmp    802ff3 <copy_data+0x34>
  802fdc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe2:	01 c2                	add    %eax,%edx
  802fe4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	01 c8                	add    %ecx,%eax
  802fec:	8a 00                	mov    (%eax),%al
  802fee:	88 02                	mov    %al,(%edx)
  802ff0:	ff 45 fc             	incl   -0x4(%ebp)
  802ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ff6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802ff9:	72 e1                	jb     802fdc <copy_data+0x1d>
}
  802ffb:	90                   	nop
  802ffc:	c9                   	leave  
  802ffd:	c3                   	ret    

00802ffe <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802ffe:	55                   	push   %ebp
  802fff:	89 e5                	mov    %esp,%ebp
  803001:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803004:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803008:	75 23                	jne    80302d <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80300a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80300e:	74 13                	je     803023 <realloc_block_FF+0x25>
  803010:	83 ec 0c             	sub    $0xc,%esp
  803013:	ff 75 0c             	pushl  0xc(%ebp)
  803016:	e8 42 f0 ff ff       	call   80205d <alloc_block_FF>
  80301b:	83 c4 10             	add    $0x10,%esp
  80301e:	e9 e4 06 00 00       	jmp    803707 <realloc_block_FF+0x709>
		return NULL;
  803023:	b8 00 00 00 00       	mov    $0x0,%eax
  803028:	e9 da 06 00 00       	jmp    803707 <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  80302d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803031:	75 18                	jne    80304b <realloc_block_FF+0x4d>
	{
		free_block(va);
  803033:	83 ec 0c             	sub    $0xc,%esp
  803036:	ff 75 08             	pushl  0x8(%ebp)
  803039:	e8 c0 fe ff ff       	call   802efe <free_block>
  80303e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803041:	b8 00 00 00 00       	mov    $0x0,%eax
  803046:	e9 bc 06 00 00       	jmp    803707 <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  80304b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80304f:	77 07                	ja     803058 <realloc_block_FF+0x5a>
  803051:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305b:	83 e0 01             	and    $0x1,%eax
  80305e:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803061:	8b 45 0c             	mov    0xc(%ebp),%eax
  803064:	83 c0 08             	add    $0x8,%eax
  803067:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80306a:	83 ec 0c             	sub    $0xc,%esp
  80306d:	ff 75 08             	pushl  0x8(%ebp)
  803070:	e8 68 ec ff ff       	call   801cdd <get_block_size>
  803075:	83 c4 10             	add    $0x10,%esp
  803078:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80307b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307e:	83 e8 08             	sub    $0x8,%eax
  803081:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	83 e8 04             	sub    $0x4,%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	83 e0 fe             	and    $0xfffffffe,%eax
  80308f:	89 c2                	mov    %eax,%edx
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	01 d0                	add    %edx,%eax
  803096:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803099:	83 ec 0c             	sub    $0xc,%esp
  80309c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80309f:	e8 39 ec ff ff       	call   801cdd <get_block_size>
  8030a4:	83 c4 10             	add    $0x10,%esp
  8030a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8030aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ad:	83 e8 08             	sub    $0x8,%eax
  8030b0:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8030b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030b9:	75 08                	jne    8030c3 <realloc_block_FF+0xc5>
	{
		 return va;
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	e9 44 06 00 00       	jmp    803707 <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  8030c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030c6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030c9:	0f 83 d5 03 00 00    	jae    8034a4 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	2b 45 0c             	sub    0xc(%ebp),%eax
  8030d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8030d8:	83 ec 0c             	sub    $0xc,%esp
  8030db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030de:	e8 13 ec ff ff       	call   801cf6 <is_free_block>
  8030e3:	83 c4 10             	add    $0x10,%esp
  8030e6:	84 c0                	test   %al,%al
  8030e8:	0f 84 3b 01 00 00    	je     803229 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8030ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030f4:	01 d0                	add    %edx,%eax
  8030f6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8030f9:	83 ec 04             	sub    $0x4,%esp
  8030fc:	6a 01                	push   $0x1
  8030fe:	ff 75 f0             	pushl  -0x10(%ebp)
  803101:	ff 75 08             	pushl  0x8(%ebp)
  803104:	e8 25 ef ff ff       	call   80202e <set_block_data>
  803109:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	83 e8 04             	sub    $0x4,%eax
  803112:	8b 00                	mov    (%eax),%eax
  803114:	83 e0 fe             	and    $0xfffffffe,%eax
  803117:	89 c2                	mov    %eax,%edx
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	01 d0                	add    %edx,%eax
  80311e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803121:	83 ec 04             	sub    $0x4,%esp
  803124:	6a 00                	push   $0x0
  803126:	ff 75 cc             	pushl  -0x34(%ebp)
  803129:	ff 75 c8             	pushl  -0x38(%ebp)
  80312c:	e8 fd ee ff ff       	call   80202e <set_block_data>
  803131:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803134:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803138:	74 06                	je     803140 <realloc_block_FF+0x142>
  80313a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80313e:	75 17                	jne    803157 <realloc_block_FF+0x159>
  803140:	83 ec 04             	sub    $0x4,%esp
  803143:	68 f4 41 80 00       	push   $0x8041f4
  803148:	68 f6 01 00 00       	push   $0x1f6
  80314d:	68 81 41 80 00       	push   $0x804181
  803152:	e8 ec 05 00 00       	call   803743 <_panic>
  803157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315a:	8b 10                	mov    (%eax),%edx
  80315c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80315f:	89 10                	mov    %edx,(%eax)
  803161:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	74 0b                	je     803175 <realloc_block_FF+0x177>
  80316a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803172:	89 50 04             	mov    %edx,0x4(%eax)
  803175:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803178:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80317b:	89 10                	mov    %edx,(%eax)
  80317d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803183:	89 50 04             	mov    %edx,0x4(%eax)
  803186:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803189:	8b 00                	mov    (%eax),%eax
  80318b:	85 c0                	test   %eax,%eax
  80318d:	75 08                	jne    803197 <realloc_block_FF+0x199>
  80318f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803192:	a3 30 50 80 00       	mov    %eax,0x805030
  803197:	a1 38 50 80 00       	mov    0x805038,%eax
  80319c:	40                   	inc    %eax
  80319d:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8031a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031a6:	75 17                	jne    8031bf <realloc_block_FF+0x1c1>
  8031a8:	83 ec 04             	sub    $0x4,%esp
  8031ab:	68 63 41 80 00       	push   $0x804163
  8031b0:	68 f7 01 00 00       	push   $0x1f7
  8031b5:	68 81 41 80 00       	push   $0x804181
  8031ba:	e8 84 05 00 00       	call   803743 <_panic>
  8031bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c2:	8b 00                	mov    (%eax),%eax
  8031c4:	85 c0                	test   %eax,%eax
  8031c6:	74 10                	je     8031d8 <realloc_block_FF+0x1da>
  8031c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031cb:	8b 00                	mov    (%eax),%eax
  8031cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031d0:	8b 52 04             	mov    0x4(%edx),%edx
  8031d3:	89 50 04             	mov    %edx,0x4(%eax)
  8031d6:	eb 0b                	jmp    8031e3 <realloc_block_FF+0x1e5>
  8031d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031db:	8b 40 04             	mov    0x4(%eax),%eax
  8031de:	a3 30 50 80 00       	mov    %eax,0x805030
  8031e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e6:	8b 40 04             	mov    0x4(%eax),%eax
  8031e9:	85 c0                	test   %eax,%eax
  8031eb:	74 0f                	je     8031fc <realloc_block_FF+0x1fe>
  8031ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f0:	8b 40 04             	mov    0x4(%eax),%eax
  8031f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031f6:	8b 12                	mov    (%edx),%edx
  8031f8:	89 10                	mov    %edx,(%eax)
  8031fa:	eb 0a                	jmp    803206 <realloc_block_FF+0x208>
  8031fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ff:	8b 00                	mov    (%eax),%eax
  803201:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80320f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803212:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803219:	a1 38 50 80 00       	mov    0x805038,%eax
  80321e:	48                   	dec    %eax
  80321f:	a3 38 50 80 00       	mov    %eax,0x805038
  803224:	e9 73 02 00 00       	jmp    80349c <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  803229:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80322d:	0f 86 69 02 00 00    	jbe    80349c <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	6a 01                	push   $0x1
  803238:	ff 75 f0             	pushl  -0x10(%ebp)
  80323b:	ff 75 08             	pushl  0x8(%ebp)
  80323e:	e8 eb ed ff ff       	call   80202e <set_block_data>
  803243:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	83 e8 04             	sub    $0x4,%eax
  80324c:	8b 00                	mov    (%eax),%eax
  80324e:	83 e0 fe             	and    $0xfffffffe,%eax
  803251:	89 c2                	mov    %eax,%edx
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	01 d0                	add    %edx,%eax
  803258:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80325b:	a1 38 50 80 00       	mov    0x805038,%eax
  803260:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803263:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803267:	75 68                	jne    8032d1 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803269:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80326d:	75 17                	jne    803286 <realloc_block_FF+0x288>
  80326f:	83 ec 04             	sub    $0x4,%esp
  803272:	68 9c 41 80 00       	push   $0x80419c
  803277:	68 06 02 00 00       	push   $0x206
  80327c:	68 81 41 80 00       	push   $0x804181
  803281:	e8 bd 04 00 00       	call   803743 <_panic>
  803286:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80328c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80328f:	89 10                	mov    %edx,(%eax)
  803291:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803294:	8b 00                	mov    (%eax),%eax
  803296:	85 c0                	test   %eax,%eax
  803298:	74 0d                	je     8032a7 <realloc_block_FF+0x2a9>
  80329a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80329f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032a2:	89 50 04             	mov    %edx,0x4(%eax)
  8032a5:	eb 08                	jmp    8032af <realloc_block_FF+0x2b1>
  8032a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032aa:	a3 30 50 80 00       	mov    %eax,0x805030
  8032af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032b2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8032c6:	40                   	inc    %eax
  8032c7:	a3 38 50 80 00       	mov    %eax,0x805038
  8032cc:	e9 b0 01 00 00       	jmp    803481 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8032d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032d6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032d9:	76 68                	jbe    803343 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032db:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032df:	75 17                	jne    8032f8 <realloc_block_FF+0x2fa>
  8032e1:	83 ec 04             	sub    $0x4,%esp
  8032e4:	68 9c 41 80 00       	push   $0x80419c
  8032e9:	68 0b 02 00 00       	push   $0x20b
  8032ee:	68 81 41 80 00       	push   $0x804181
  8032f3:	e8 4b 04 00 00       	call   803743 <_panic>
  8032f8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803301:	89 10                	mov    %edx,(%eax)
  803303:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803306:	8b 00                	mov    (%eax),%eax
  803308:	85 c0                	test   %eax,%eax
  80330a:	74 0d                	je     803319 <realloc_block_FF+0x31b>
  80330c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803311:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803314:	89 50 04             	mov    %edx,0x4(%eax)
  803317:	eb 08                	jmp    803321 <realloc_block_FF+0x323>
  803319:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80331c:	a3 30 50 80 00       	mov    %eax,0x805030
  803321:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803324:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803329:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80332c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803333:	a1 38 50 80 00       	mov    0x805038,%eax
  803338:	40                   	inc    %eax
  803339:	a3 38 50 80 00       	mov    %eax,0x805038
  80333e:	e9 3e 01 00 00       	jmp    803481 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803343:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803348:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80334b:	73 68                	jae    8033b5 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80334d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803351:	75 17                	jne    80336a <realloc_block_FF+0x36c>
  803353:	83 ec 04             	sub    $0x4,%esp
  803356:	68 d0 41 80 00       	push   $0x8041d0
  80335b:	68 10 02 00 00       	push   $0x210
  803360:	68 81 41 80 00       	push   $0x804181
  803365:	e8 d9 03 00 00       	call   803743 <_panic>
  80336a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803370:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803373:	89 50 04             	mov    %edx,0x4(%eax)
  803376:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803379:	8b 40 04             	mov    0x4(%eax),%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	74 0c                	je     80338c <realloc_block_FF+0x38e>
  803380:	a1 30 50 80 00       	mov    0x805030,%eax
  803385:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803388:	89 10                	mov    %edx,(%eax)
  80338a:	eb 08                	jmp    803394 <realloc_block_FF+0x396>
  80338c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80338f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803394:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803397:	a3 30 50 80 00       	mov    %eax,0x805030
  80339c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8033aa:	40                   	inc    %eax
  8033ab:	a3 38 50 80 00       	mov    %eax,0x805038
  8033b0:	e9 cc 00 00 00       	jmp    803481 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8033b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8033bc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c4:	e9 8a 00 00 00       	jmp    803453 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033cf:	73 7a                	jae    80344b <realloc_block_FF+0x44d>
  8033d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d4:	8b 00                	mov    (%eax),%eax
  8033d6:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033d9:	73 70                	jae    80344b <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8033db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033df:	74 06                	je     8033e7 <realloc_block_FF+0x3e9>
  8033e1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033e5:	75 17                	jne    8033fe <realloc_block_FF+0x400>
  8033e7:	83 ec 04             	sub    $0x4,%esp
  8033ea:	68 f4 41 80 00       	push   $0x8041f4
  8033ef:	68 1a 02 00 00       	push   $0x21a
  8033f4:	68 81 41 80 00       	push   $0x804181
  8033f9:	e8 45 03 00 00       	call   803743 <_panic>
  8033fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803401:	8b 10                	mov    (%eax),%edx
  803403:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803406:	89 10                	mov    %edx,(%eax)
  803408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340b:	8b 00                	mov    (%eax),%eax
  80340d:	85 c0                	test   %eax,%eax
  80340f:	74 0b                	je     80341c <realloc_block_FF+0x41e>
  803411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803414:	8b 00                	mov    (%eax),%eax
  803416:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803419:	89 50 04             	mov    %edx,0x4(%eax)
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803422:	89 10                	mov    %edx,(%eax)
  803424:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342a:	89 50 04             	mov    %edx,0x4(%eax)
  80342d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803430:	8b 00                	mov    (%eax),%eax
  803432:	85 c0                	test   %eax,%eax
  803434:	75 08                	jne    80343e <realloc_block_FF+0x440>
  803436:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803439:	a3 30 50 80 00       	mov    %eax,0x805030
  80343e:	a1 38 50 80 00       	mov    0x805038,%eax
  803443:	40                   	inc    %eax
  803444:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803449:	eb 36                	jmp    803481 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80344b:	a1 34 50 80 00       	mov    0x805034,%eax
  803450:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803453:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803457:	74 07                	je     803460 <realloc_block_FF+0x462>
  803459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	eb 05                	jmp    803465 <realloc_block_FF+0x467>
  803460:	b8 00 00 00 00       	mov    $0x0,%eax
  803465:	a3 34 50 80 00       	mov    %eax,0x805034
  80346a:	a1 34 50 80 00       	mov    0x805034,%eax
  80346f:	85 c0                	test   %eax,%eax
  803471:	0f 85 52 ff ff ff    	jne    8033c9 <realloc_block_FF+0x3cb>
  803477:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347b:	0f 85 48 ff ff ff    	jne    8033c9 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803481:	83 ec 04             	sub    $0x4,%esp
  803484:	6a 00                	push   $0x0
  803486:	ff 75 d8             	pushl  -0x28(%ebp)
  803489:	ff 75 d4             	pushl  -0x2c(%ebp)
  80348c:	e8 9d eb ff ff       	call   80202e <set_block_data>
  803491:	83 c4 10             	add    $0x10,%esp
				return va;
  803494:	8b 45 08             	mov    0x8(%ebp),%eax
  803497:	e9 6b 02 00 00       	jmp    803707 <realloc_block_FF+0x709>
			}
			
		}
		return va;
  80349c:	8b 45 08             	mov    0x8(%ebp),%eax
  80349f:	e9 63 02 00 00       	jmp    803707 <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  8034a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034aa:	0f 86 4d 02 00 00    	jbe    8036fd <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  8034b0:	83 ec 0c             	sub    $0xc,%esp
  8034b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034b6:	e8 3b e8 ff ff       	call   801cf6 <is_free_block>
  8034bb:	83 c4 10             	add    $0x10,%esp
  8034be:	84 c0                	test   %al,%al
  8034c0:	0f 84 37 02 00 00    	je     8036fd <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8034c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c9:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8034cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8034cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034d2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034d5:	76 38                	jbe    80350f <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  8034d7:	83 ec 0c             	sub    $0xc,%esp
  8034da:	ff 75 0c             	pushl  0xc(%ebp)
  8034dd:	e8 7b eb ff ff       	call   80205d <alloc_block_FF>
  8034e2:	83 c4 10             	add    $0x10,%esp
  8034e5:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8034e8:	83 ec 08             	sub    $0x8,%esp
  8034eb:	ff 75 c0             	pushl  -0x40(%ebp)
  8034ee:	ff 75 08             	pushl  0x8(%ebp)
  8034f1:	e8 c9 fa ff ff       	call   802fbf <copy_data>
  8034f6:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8034f9:	83 ec 0c             	sub    $0xc,%esp
  8034fc:	ff 75 08             	pushl  0x8(%ebp)
  8034ff:	e8 fa f9 ff ff       	call   802efe <free_block>
  803504:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803507:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80350a:	e9 f8 01 00 00       	jmp    803707 <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80350f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803512:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803515:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803518:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80351c:	0f 87 a0 00 00 00    	ja     8035c2 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803522:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803526:	75 17                	jne    80353f <realloc_block_FF+0x541>
  803528:	83 ec 04             	sub    $0x4,%esp
  80352b:	68 63 41 80 00       	push   $0x804163
  803530:	68 38 02 00 00       	push   $0x238
  803535:	68 81 41 80 00       	push   $0x804181
  80353a:	e8 04 02 00 00       	call   803743 <_panic>
  80353f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803542:	8b 00                	mov    (%eax),%eax
  803544:	85 c0                	test   %eax,%eax
  803546:	74 10                	je     803558 <realloc_block_FF+0x55a>
  803548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354b:	8b 00                	mov    (%eax),%eax
  80354d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803550:	8b 52 04             	mov    0x4(%edx),%edx
  803553:	89 50 04             	mov    %edx,0x4(%eax)
  803556:	eb 0b                	jmp    803563 <realloc_block_FF+0x565>
  803558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355b:	8b 40 04             	mov    0x4(%eax),%eax
  80355e:	a3 30 50 80 00       	mov    %eax,0x805030
  803563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803566:	8b 40 04             	mov    0x4(%eax),%eax
  803569:	85 c0                	test   %eax,%eax
  80356b:	74 0f                	je     80357c <realloc_block_FF+0x57e>
  80356d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803570:	8b 40 04             	mov    0x4(%eax),%eax
  803573:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803576:	8b 12                	mov    (%edx),%edx
  803578:	89 10                	mov    %edx,(%eax)
  80357a:	eb 0a                	jmp    803586 <realloc_block_FF+0x588>
  80357c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357f:	8b 00                	mov    (%eax),%eax
  803581:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803589:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80358f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803592:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803599:	a1 38 50 80 00       	mov    0x805038,%eax
  80359e:	48                   	dec    %eax
  80359f:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8035a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035aa:	01 d0                	add    %edx,%eax
  8035ac:	83 ec 04             	sub    $0x4,%esp
  8035af:	6a 01                	push   $0x1
  8035b1:	50                   	push   %eax
  8035b2:	ff 75 08             	pushl  0x8(%ebp)
  8035b5:	e8 74 ea ff ff       	call   80202e <set_block_data>
  8035ba:	83 c4 10             	add    $0x10,%esp
  8035bd:	e9 36 01 00 00       	jmp    8036f8 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8035c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035c8:	01 d0                	add    %edx,%eax
  8035ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8035cd:	83 ec 04             	sub    $0x4,%esp
  8035d0:	6a 01                	push   $0x1
  8035d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8035d5:	ff 75 08             	pushl  0x8(%ebp)
  8035d8:	e8 51 ea ff ff       	call   80202e <set_block_data>
  8035dd:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	83 e8 04             	sub    $0x4,%eax
  8035e6:	8b 00                	mov    (%eax),%eax
  8035e8:	83 e0 fe             	and    $0xfffffffe,%eax
  8035eb:	89 c2                	mov    %eax,%edx
  8035ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f0:	01 d0                	add    %edx,%eax
  8035f2:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8035f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035f9:	74 06                	je     803601 <realloc_block_FF+0x603>
  8035fb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8035ff:	75 17                	jne    803618 <realloc_block_FF+0x61a>
  803601:	83 ec 04             	sub    $0x4,%esp
  803604:	68 f4 41 80 00       	push   $0x8041f4
  803609:	68 44 02 00 00       	push   $0x244
  80360e:	68 81 41 80 00       	push   $0x804181
  803613:	e8 2b 01 00 00       	call   803743 <_panic>
  803618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361b:	8b 10                	mov    (%eax),%edx
  80361d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803620:	89 10                	mov    %edx,(%eax)
  803622:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803625:	8b 00                	mov    (%eax),%eax
  803627:	85 c0                	test   %eax,%eax
  803629:	74 0b                	je     803636 <realloc_block_FF+0x638>
  80362b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803633:	89 50 04             	mov    %edx,0x4(%eax)
  803636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803639:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80363c:	89 10                	mov    %edx,(%eax)
  80363e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803641:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803644:	89 50 04             	mov    %edx,0x4(%eax)
  803647:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80364a:	8b 00                	mov    (%eax),%eax
  80364c:	85 c0                	test   %eax,%eax
  80364e:	75 08                	jne    803658 <realloc_block_FF+0x65a>
  803650:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803653:	a3 30 50 80 00       	mov    %eax,0x805030
  803658:	a1 38 50 80 00       	mov    0x805038,%eax
  80365d:	40                   	inc    %eax
  80365e:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803663:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803667:	75 17                	jne    803680 <realloc_block_FF+0x682>
  803669:	83 ec 04             	sub    $0x4,%esp
  80366c:	68 63 41 80 00       	push   $0x804163
  803671:	68 45 02 00 00       	push   $0x245
  803676:	68 81 41 80 00       	push   $0x804181
  80367b:	e8 c3 00 00 00       	call   803743 <_panic>
  803680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803683:	8b 00                	mov    (%eax),%eax
  803685:	85 c0                	test   %eax,%eax
  803687:	74 10                	je     803699 <realloc_block_FF+0x69b>
  803689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368c:	8b 00                	mov    (%eax),%eax
  80368e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803691:	8b 52 04             	mov    0x4(%edx),%edx
  803694:	89 50 04             	mov    %edx,0x4(%eax)
  803697:	eb 0b                	jmp    8036a4 <realloc_block_FF+0x6a6>
  803699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369c:	8b 40 04             	mov    0x4(%eax),%eax
  80369f:	a3 30 50 80 00       	mov    %eax,0x805030
  8036a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a7:	8b 40 04             	mov    0x4(%eax),%eax
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	74 0f                	je     8036bd <realloc_block_FF+0x6bf>
  8036ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b1:	8b 40 04             	mov    0x4(%eax),%eax
  8036b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036b7:	8b 12                	mov    (%edx),%edx
  8036b9:	89 10                	mov    %edx,(%eax)
  8036bb:	eb 0a                	jmp    8036c7 <realloc_block_FF+0x6c9>
  8036bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c0:	8b 00                	mov    (%eax),%eax
  8036c2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036da:	a1 38 50 80 00       	mov    0x805038,%eax
  8036df:	48                   	dec    %eax
  8036e0:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8036e5:	83 ec 04             	sub    $0x4,%esp
  8036e8:	6a 00                	push   $0x0
  8036ea:	ff 75 bc             	pushl  -0x44(%ebp)
  8036ed:	ff 75 b8             	pushl  -0x48(%ebp)
  8036f0:	e8 39 e9 ff ff       	call   80202e <set_block_data>
  8036f5:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8036f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fb:	eb 0a                	jmp    803707 <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8036fd:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803707:	c9                   	leave  
  803708:	c3                   	ret    

00803709 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803709:	55                   	push   %ebp
  80370a:	89 e5                	mov    %esp,%ebp
  80370c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80370f:	83 ec 04             	sub    $0x4,%esp
  803712:	68 60 42 80 00       	push   $0x804260
  803717:	68 58 02 00 00       	push   $0x258
  80371c:	68 81 41 80 00       	push   $0x804181
  803721:	e8 1d 00 00 00       	call   803743 <_panic>

00803726 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803726:	55                   	push   %ebp
  803727:	89 e5                	mov    %esp,%ebp
  803729:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80372c:	83 ec 04             	sub    $0x4,%esp
  80372f:	68 88 42 80 00       	push   $0x804288
  803734:	68 61 02 00 00       	push   $0x261
  803739:	68 81 41 80 00       	push   $0x804181
  80373e:	e8 00 00 00 00       	call   803743 <_panic>

00803743 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803743:	55                   	push   %ebp
  803744:	89 e5                	mov    %esp,%ebp
  803746:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803749:	8d 45 10             	lea    0x10(%ebp),%eax
  80374c:	83 c0 04             	add    $0x4,%eax
  80374f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803752:	a1 60 50 98 00       	mov    0x985060,%eax
  803757:	85 c0                	test   %eax,%eax
  803759:	74 16                	je     803771 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80375b:	a1 60 50 98 00       	mov    0x985060,%eax
  803760:	83 ec 08             	sub    $0x8,%esp
  803763:	50                   	push   %eax
  803764:	68 b0 42 80 00       	push   $0x8042b0
  803769:	e8 dd cb ff ff       	call   80034b <cprintf>
  80376e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803771:	a1 00 50 80 00       	mov    0x805000,%eax
  803776:	ff 75 0c             	pushl  0xc(%ebp)
  803779:	ff 75 08             	pushl  0x8(%ebp)
  80377c:	50                   	push   %eax
  80377d:	68 b5 42 80 00       	push   $0x8042b5
  803782:	e8 c4 cb ff ff       	call   80034b <cprintf>
  803787:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80378a:	8b 45 10             	mov    0x10(%ebp),%eax
  80378d:	83 ec 08             	sub    $0x8,%esp
  803790:	ff 75 f4             	pushl  -0xc(%ebp)
  803793:	50                   	push   %eax
  803794:	e8 47 cb ff ff       	call   8002e0 <vcprintf>
  803799:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80379c:	83 ec 08             	sub    $0x8,%esp
  80379f:	6a 00                	push   $0x0
  8037a1:	68 d1 42 80 00       	push   $0x8042d1
  8037a6:	e8 35 cb ff ff       	call   8002e0 <vcprintf>
  8037ab:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8037ae:	e8 b6 ca ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  8037b3:	eb fe                	jmp    8037b3 <_panic+0x70>

008037b5 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8037b5:	55                   	push   %ebp
  8037b6:	89 e5                	mov    %esp,%ebp
  8037b8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8037bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8037c0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8037c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037c9:	39 c2                	cmp    %eax,%edx
  8037cb:	74 14                	je     8037e1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8037cd:	83 ec 04             	sub    $0x4,%esp
  8037d0:	68 d4 42 80 00       	push   $0x8042d4
  8037d5:	6a 26                	push   $0x26
  8037d7:	68 20 43 80 00       	push   $0x804320
  8037dc:	e8 62 ff ff ff       	call   803743 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8037e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8037e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8037ef:	e9 c5 00 00 00       	jmp    8038b9 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8037f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803801:	01 d0                	add    %edx,%eax
  803803:	8b 00                	mov    (%eax),%eax
  803805:	85 c0                	test   %eax,%eax
  803807:	75 08                	jne    803811 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803809:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80380c:	e9 a5 00 00 00       	jmp    8038b6 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803811:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803818:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80381f:	eb 69                	jmp    80388a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803821:	a1 20 50 80 00       	mov    0x805020,%eax
  803826:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80382c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80382f:	89 d0                	mov    %edx,%eax
  803831:	01 c0                	add    %eax,%eax
  803833:	01 d0                	add    %edx,%eax
  803835:	c1 e0 03             	shl    $0x3,%eax
  803838:	01 c8                	add    %ecx,%eax
  80383a:	8a 40 04             	mov    0x4(%eax),%al
  80383d:	84 c0                	test   %al,%al
  80383f:	75 46                	jne    803887 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803841:	a1 20 50 80 00       	mov    0x805020,%eax
  803846:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80384c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80384f:	89 d0                	mov    %edx,%eax
  803851:	01 c0                	add    %eax,%eax
  803853:	01 d0                	add    %edx,%eax
  803855:	c1 e0 03             	shl    $0x3,%eax
  803858:	01 c8                	add    %ecx,%eax
  80385a:	8b 00                	mov    (%eax),%eax
  80385c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80385f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803862:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803867:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803873:	8b 45 08             	mov    0x8(%ebp),%eax
  803876:	01 c8                	add    %ecx,%eax
  803878:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80387a:	39 c2                	cmp    %eax,%edx
  80387c:	75 09                	jne    803887 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80387e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803885:	eb 15                	jmp    80389c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803887:	ff 45 e8             	incl   -0x18(%ebp)
  80388a:	a1 20 50 80 00       	mov    0x805020,%eax
  80388f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803895:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803898:	39 c2                	cmp    %eax,%edx
  80389a:	77 85                	ja     803821 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80389c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038a0:	75 14                	jne    8038b6 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8038a2:	83 ec 04             	sub    $0x4,%esp
  8038a5:	68 2c 43 80 00       	push   $0x80432c
  8038aa:	6a 3a                	push   $0x3a
  8038ac:	68 20 43 80 00       	push   $0x804320
  8038b1:	e8 8d fe ff ff       	call   803743 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8038b6:	ff 45 f0             	incl   -0x10(%ebp)
  8038b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8038bf:	0f 8c 2f ff ff ff    	jl     8037f4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8038c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8038d3:	eb 26                	jmp    8038fb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8038d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8038da:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038e3:	89 d0                	mov    %edx,%eax
  8038e5:	01 c0                	add    %eax,%eax
  8038e7:	01 d0                	add    %edx,%eax
  8038e9:	c1 e0 03             	shl    $0x3,%eax
  8038ec:	01 c8                	add    %ecx,%eax
  8038ee:	8a 40 04             	mov    0x4(%eax),%al
  8038f1:	3c 01                	cmp    $0x1,%al
  8038f3:	75 03                	jne    8038f8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8038f5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038f8:	ff 45 e0             	incl   -0x20(%ebp)
  8038fb:	a1 20 50 80 00       	mov    0x805020,%eax
  803900:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803906:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803909:	39 c2                	cmp    %eax,%edx
  80390b:	77 c8                	ja     8038d5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80390d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803910:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803913:	74 14                	je     803929 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803915:	83 ec 04             	sub    $0x4,%esp
  803918:	68 80 43 80 00       	push   $0x804380
  80391d:	6a 44                	push   $0x44
  80391f:	68 20 43 80 00       	push   $0x804320
  803924:	e8 1a fe ff ff       	call   803743 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803929:	90                   	nop
  80392a:	c9                   	leave  
  80392b:	c3                   	ret    

0080392c <__udivdi3>:
  80392c:	55                   	push   %ebp
  80392d:	57                   	push   %edi
  80392e:	56                   	push   %esi
  80392f:	53                   	push   %ebx
  803930:	83 ec 1c             	sub    $0x1c,%esp
  803933:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803937:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80393b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80393f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803943:	89 ca                	mov    %ecx,%edx
  803945:	89 f8                	mov    %edi,%eax
  803947:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80394b:	85 f6                	test   %esi,%esi
  80394d:	75 2d                	jne    80397c <__udivdi3+0x50>
  80394f:	39 cf                	cmp    %ecx,%edi
  803951:	77 65                	ja     8039b8 <__udivdi3+0x8c>
  803953:	89 fd                	mov    %edi,%ebp
  803955:	85 ff                	test   %edi,%edi
  803957:	75 0b                	jne    803964 <__udivdi3+0x38>
  803959:	b8 01 00 00 00       	mov    $0x1,%eax
  80395e:	31 d2                	xor    %edx,%edx
  803960:	f7 f7                	div    %edi
  803962:	89 c5                	mov    %eax,%ebp
  803964:	31 d2                	xor    %edx,%edx
  803966:	89 c8                	mov    %ecx,%eax
  803968:	f7 f5                	div    %ebp
  80396a:	89 c1                	mov    %eax,%ecx
  80396c:	89 d8                	mov    %ebx,%eax
  80396e:	f7 f5                	div    %ebp
  803970:	89 cf                	mov    %ecx,%edi
  803972:	89 fa                	mov    %edi,%edx
  803974:	83 c4 1c             	add    $0x1c,%esp
  803977:	5b                   	pop    %ebx
  803978:	5e                   	pop    %esi
  803979:	5f                   	pop    %edi
  80397a:	5d                   	pop    %ebp
  80397b:	c3                   	ret    
  80397c:	39 ce                	cmp    %ecx,%esi
  80397e:	77 28                	ja     8039a8 <__udivdi3+0x7c>
  803980:	0f bd fe             	bsr    %esi,%edi
  803983:	83 f7 1f             	xor    $0x1f,%edi
  803986:	75 40                	jne    8039c8 <__udivdi3+0x9c>
  803988:	39 ce                	cmp    %ecx,%esi
  80398a:	72 0a                	jb     803996 <__udivdi3+0x6a>
  80398c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803990:	0f 87 9e 00 00 00    	ja     803a34 <__udivdi3+0x108>
  803996:	b8 01 00 00 00       	mov    $0x1,%eax
  80399b:	89 fa                	mov    %edi,%edx
  80399d:	83 c4 1c             	add    $0x1c,%esp
  8039a0:	5b                   	pop    %ebx
  8039a1:	5e                   	pop    %esi
  8039a2:	5f                   	pop    %edi
  8039a3:	5d                   	pop    %ebp
  8039a4:	c3                   	ret    
  8039a5:	8d 76 00             	lea    0x0(%esi),%esi
  8039a8:	31 ff                	xor    %edi,%edi
  8039aa:	31 c0                	xor    %eax,%eax
  8039ac:	89 fa                	mov    %edi,%edx
  8039ae:	83 c4 1c             	add    $0x1c,%esp
  8039b1:	5b                   	pop    %ebx
  8039b2:	5e                   	pop    %esi
  8039b3:	5f                   	pop    %edi
  8039b4:	5d                   	pop    %ebp
  8039b5:	c3                   	ret    
  8039b6:	66 90                	xchg   %ax,%ax
  8039b8:	89 d8                	mov    %ebx,%eax
  8039ba:	f7 f7                	div    %edi
  8039bc:	31 ff                	xor    %edi,%edi
  8039be:	89 fa                	mov    %edi,%edx
  8039c0:	83 c4 1c             	add    $0x1c,%esp
  8039c3:	5b                   	pop    %ebx
  8039c4:	5e                   	pop    %esi
  8039c5:	5f                   	pop    %edi
  8039c6:	5d                   	pop    %ebp
  8039c7:	c3                   	ret    
  8039c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039cd:	89 eb                	mov    %ebp,%ebx
  8039cf:	29 fb                	sub    %edi,%ebx
  8039d1:	89 f9                	mov    %edi,%ecx
  8039d3:	d3 e6                	shl    %cl,%esi
  8039d5:	89 c5                	mov    %eax,%ebp
  8039d7:	88 d9                	mov    %bl,%cl
  8039d9:	d3 ed                	shr    %cl,%ebp
  8039db:	89 e9                	mov    %ebp,%ecx
  8039dd:	09 f1                	or     %esi,%ecx
  8039df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039e3:	89 f9                	mov    %edi,%ecx
  8039e5:	d3 e0                	shl    %cl,%eax
  8039e7:	89 c5                	mov    %eax,%ebp
  8039e9:	89 d6                	mov    %edx,%esi
  8039eb:	88 d9                	mov    %bl,%cl
  8039ed:	d3 ee                	shr    %cl,%esi
  8039ef:	89 f9                	mov    %edi,%ecx
  8039f1:	d3 e2                	shl    %cl,%edx
  8039f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039f7:	88 d9                	mov    %bl,%cl
  8039f9:	d3 e8                	shr    %cl,%eax
  8039fb:	09 c2                	or     %eax,%edx
  8039fd:	89 d0                	mov    %edx,%eax
  8039ff:	89 f2                	mov    %esi,%edx
  803a01:	f7 74 24 0c          	divl   0xc(%esp)
  803a05:	89 d6                	mov    %edx,%esi
  803a07:	89 c3                	mov    %eax,%ebx
  803a09:	f7 e5                	mul    %ebp
  803a0b:	39 d6                	cmp    %edx,%esi
  803a0d:	72 19                	jb     803a28 <__udivdi3+0xfc>
  803a0f:	74 0b                	je     803a1c <__udivdi3+0xf0>
  803a11:	89 d8                	mov    %ebx,%eax
  803a13:	31 ff                	xor    %edi,%edi
  803a15:	e9 58 ff ff ff       	jmp    803972 <__udivdi3+0x46>
  803a1a:	66 90                	xchg   %ax,%ax
  803a1c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a20:	89 f9                	mov    %edi,%ecx
  803a22:	d3 e2                	shl    %cl,%edx
  803a24:	39 c2                	cmp    %eax,%edx
  803a26:	73 e9                	jae    803a11 <__udivdi3+0xe5>
  803a28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a2b:	31 ff                	xor    %edi,%edi
  803a2d:	e9 40 ff ff ff       	jmp    803972 <__udivdi3+0x46>
  803a32:	66 90                	xchg   %ax,%ax
  803a34:	31 c0                	xor    %eax,%eax
  803a36:	e9 37 ff ff ff       	jmp    803972 <__udivdi3+0x46>
  803a3b:	90                   	nop

00803a3c <__umoddi3>:
  803a3c:	55                   	push   %ebp
  803a3d:	57                   	push   %edi
  803a3e:	56                   	push   %esi
  803a3f:	53                   	push   %ebx
  803a40:	83 ec 1c             	sub    $0x1c,%esp
  803a43:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a47:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a5b:	89 f3                	mov    %esi,%ebx
  803a5d:	89 fa                	mov    %edi,%edx
  803a5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a63:	89 34 24             	mov    %esi,(%esp)
  803a66:	85 c0                	test   %eax,%eax
  803a68:	75 1a                	jne    803a84 <__umoddi3+0x48>
  803a6a:	39 f7                	cmp    %esi,%edi
  803a6c:	0f 86 a2 00 00 00    	jbe    803b14 <__umoddi3+0xd8>
  803a72:	89 c8                	mov    %ecx,%eax
  803a74:	89 f2                	mov    %esi,%edx
  803a76:	f7 f7                	div    %edi
  803a78:	89 d0                	mov    %edx,%eax
  803a7a:	31 d2                	xor    %edx,%edx
  803a7c:	83 c4 1c             	add    $0x1c,%esp
  803a7f:	5b                   	pop    %ebx
  803a80:	5e                   	pop    %esi
  803a81:	5f                   	pop    %edi
  803a82:	5d                   	pop    %ebp
  803a83:	c3                   	ret    
  803a84:	39 f0                	cmp    %esi,%eax
  803a86:	0f 87 ac 00 00 00    	ja     803b38 <__umoddi3+0xfc>
  803a8c:	0f bd e8             	bsr    %eax,%ebp
  803a8f:	83 f5 1f             	xor    $0x1f,%ebp
  803a92:	0f 84 ac 00 00 00    	je     803b44 <__umoddi3+0x108>
  803a98:	bf 20 00 00 00       	mov    $0x20,%edi
  803a9d:	29 ef                	sub    %ebp,%edi
  803a9f:	89 fe                	mov    %edi,%esi
  803aa1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803aa5:	89 e9                	mov    %ebp,%ecx
  803aa7:	d3 e0                	shl    %cl,%eax
  803aa9:	89 d7                	mov    %edx,%edi
  803aab:	89 f1                	mov    %esi,%ecx
  803aad:	d3 ef                	shr    %cl,%edi
  803aaf:	09 c7                	or     %eax,%edi
  803ab1:	89 e9                	mov    %ebp,%ecx
  803ab3:	d3 e2                	shl    %cl,%edx
  803ab5:	89 14 24             	mov    %edx,(%esp)
  803ab8:	89 d8                	mov    %ebx,%eax
  803aba:	d3 e0                	shl    %cl,%eax
  803abc:	89 c2                	mov    %eax,%edx
  803abe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ac2:	d3 e0                	shl    %cl,%eax
  803ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ac8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803acc:	89 f1                	mov    %esi,%ecx
  803ace:	d3 e8                	shr    %cl,%eax
  803ad0:	09 d0                	or     %edx,%eax
  803ad2:	d3 eb                	shr    %cl,%ebx
  803ad4:	89 da                	mov    %ebx,%edx
  803ad6:	f7 f7                	div    %edi
  803ad8:	89 d3                	mov    %edx,%ebx
  803ada:	f7 24 24             	mull   (%esp)
  803add:	89 c6                	mov    %eax,%esi
  803adf:	89 d1                	mov    %edx,%ecx
  803ae1:	39 d3                	cmp    %edx,%ebx
  803ae3:	0f 82 87 00 00 00    	jb     803b70 <__umoddi3+0x134>
  803ae9:	0f 84 91 00 00 00    	je     803b80 <__umoddi3+0x144>
  803aef:	8b 54 24 04          	mov    0x4(%esp),%edx
  803af3:	29 f2                	sub    %esi,%edx
  803af5:	19 cb                	sbb    %ecx,%ebx
  803af7:	89 d8                	mov    %ebx,%eax
  803af9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803afd:	d3 e0                	shl    %cl,%eax
  803aff:	89 e9                	mov    %ebp,%ecx
  803b01:	d3 ea                	shr    %cl,%edx
  803b03:	09 d0                	or     %edx,%eax
  803b05:	89 e9                	mov    %ebp,%ecx
  803b07:	d3 eb                	shr    %cl,%ebx
  803b09:	89 da                	mov    %ebx,%edx
  803b0b:	83 c4 1c             	add    $0x1c,%esp
  803b0e:	5b                   	pop    %ebx
  803b0f:	5e                   	pop    %esi
  803b10:	5f                   	pop    %edi
  803b11:	5d                   	pop    %ebp
  803b12:	c3                   	ret    
  803b13:	90                   	nop
  803b14:	89 fd                	mov    %edi,%ebp
  803b16:	85 ff                	test   %edi,%edi
  803b18:	75 0b                	jne    803b25 <__umoddi3+0xe9>
  803b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b1f:	31 d2                	xor    %edx,%edx
  803b21:	f7 f7                	div    %edi
  803b23:	89 c5                	mov    %eax,%ebp
  803b25:	89 f0                	mov    %esi,%eax
  803b27:	31 d2                	xor    %edx,%edx
  803b29:	f7 f5                	div    %ebp
  803b2b:	89 c8                	mov    %ecx,%eax
  803b2d:	f7 f5                	div    %ebp
  803b2f:	89 d0                	mov    %edx,%eax
  803b31:	e9 44 ff ff ff       	jmp    803a7a <__umoddi3+0x3e>
  803b36:	66 90                	xchg   %ax,%ax
  803b38:	89 c8                	mov    %ecx,%eax
  803b3a:	89 f2                	mov    %esi,%edx
  803b3c:	83 c4 1c             	add    $0x1c,%esp
  803b3f:	5b                   	pop    %ebx
  803b40:	5e                   	pop    %esi
  803b41:	5f                   	pop    %edi
  803b42:	5d                   	pop    %ebp
  803b43:	c3                   	ret    
  803b44:	3b 04 24             	cmp    (%esp),%eax
  803b47:	72 06                	jb     803b4f <__umoddi3+0x113>
  803b49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b4d:	77 0f                	ja     803b5e <__umoddi3+0x122>
  803b4f:	89 f2                	mov    %esi,%edx
  803b51:	29 f9                	sub    %edi,%ecx
  803b53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b57:	89 14 24             	mov    %edx,(%esp)
  803b5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b62:	8b 14 24             	mov    (%esp),%edx
  803b65:	83 c4 1c             	add    $0x1c,%esp
  803b68:	5b                   	pop    %ebx
  803b69:	5e                   	pop    %esi
  803b6a:	5f                   	pop    %edi
  803b6b:	5d                   	pop    %ebp
  803b6c:	c3                   	ret    
  803b6d:	8d 76 00             	lea    0x0(%esi),%esi
  803b70:	2b 04 24             	sub    (%esp),%eax
  803b73:	19 fa                	sbb    %edi,%edx
  803b75:	89 d1                	mov    %edx,%ecx
  803b77:	89 c6                	mov    %eax,%esi
  803b79:	e9 71 ff ff ff       	jmp    803aef <__umoddi3+0xb3>
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b84:	72 ea                	jb     803b70 <__umoddi3+0x134>
  803b86:	89 d9                	mov    %ebx,%ecx
  803b88:	e9 62 ff ff ff       	jmp    803aef <__umoddi3+0xb3>
