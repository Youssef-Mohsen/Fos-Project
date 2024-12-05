
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
  80005c:	68 00 3b 80 00       	push   $0x803b00
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
  8000b9:	68 13 3b 80 00       	push   $0x803b13
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
  80010f:	68 13 3b 80 00       	push   $0x803b13
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
  8001b4:	68 38 3b 80 00       	push   $0x803b38
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
  8001dc:	68 60 3b 80 00       	push   $0x803b60
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
  80020d:	68 88 3b 80 00       	push   $0x803b88
  800212:	e8 34 01 00 00       	call   80034b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 e0 3b 80 00       	push   $0x803be0
  80022e:	e8 18 01 00 00       	call   80034b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 38 3b 80 00       	push   $0x803b38
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
  8003e8:	e8 a3 34 00 00       	call   803890 <__udivdi3>
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
  800438:	e8 63 35 00 00       	call   8039a0 <__umoddi3>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	05 14 3e 80 00       	add    $0x803e14,%eax
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
  800593:	8b 04 85 38 3e 80 00 	mov    0x803e38(,%eax,4),%eax
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
  800674:	8b 34 9d 80 3c 80 00 	mov    0x803c80(,%ebx,4),%esi
  80067b:	85 f6                	test   %esi,%esi
  80067d:	75 19                	jne    800698 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067f:	53                   	push   %ebx
  800680:	68 25 3e 80 00       	push   $0x803e25
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
  800699:	68 2e 3e 80 00       	push   $0x803e2e
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
  8006c6:	be 31 3e 80 00       	mov    $0x803e31,%esi
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
  8010d1:	68 a8 3f 80 00       	push   $0x803fa8
  8010d6:	68 3f 01 00 00       	push   $0x13f
  8010db:	68 ca 3f 80 00       	push   $0x803fca
  8010e0:	e8 c2 25 00 00       	call   8036a7 <_panic>

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
  80117b:	e8 41 0e 00 00       	call   801fc1 <alloc_block_FF>
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
  80119e:	e8 da 12 00 00       	call   80247d <alloc_block_BF>
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
  80134c:	e8 f0 08 00 00       	call   801c41 <get_block_size>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 00 1b 00 00       	call   802e62 <free_block>
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
  801402:	68 d8 3f 80 00       	push   $0x803fd8
  801407:	68 87 00 00 00       	push   $0x87
  80140c:	68 02 40 80 00       	push   $0x804002
  801411:	e8 91 22 00 00       	call   8036a7 <_panic>
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
  8015ad:	68 10 40 80 00       	push   $0x804010
  8015b2:	68 e4 00 00 00       	push   $0xe4
  8015b7:	68 02 40 80 00       	push   $0x804002
  8015bc:	e8 e6 20 00 00       	call   8036a7 <_panic>

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
  8015ca:	68 36 40 80 00       	push   $0x804036
  8015cf:	68 f0 00 00 00       	push   $0xf0
  8015d4:	68 02 40 80 00       	push   $0x804002
  8015d9:	e8 c9 20 00 00       	call   8036a7 <_panic>

008015de <shrink>:

}
void shrink(uint32 newSize)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	68 36 40 80 00       	push   $0x804036
  8015ec:	68 f5 00 00 00       	push   $0xf5
  8015f1:	68 02 40 80 00       	push   $0x804002
  8015f6:	e8 ac 20 00 00       	call   8036a7 <_panic>

008015fb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801601:	83 ec 04             	sub    $0x4,%esp
  801604:	68 36 40 80 00       	push   $0x804036
  801609:	68 fa 00 00 00       	push   $0xfa
  80160e:	68 02 40 80 00       	push   $0x804002
  801613:	e8 8f 20 00 00       	call   8036a7 <_panic>

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

00801c41 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	83 e8 04             	sub    $0x4,%eax
  801c4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801c50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c53:	8b 00                	mov    (%eax),%eax
  801c55:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	83 e8 04             	sub    $0x4,%eax
  801c66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c6c:	8b 00                	mov    (%eax),%eax
  801c6e:	83 e0 01             	and    $0x1,%eax
  801c71:	85 c0                	test   %eax,%eax
  801c73:	0f 94 c0             	sete   %al
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801c7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c88:	83 f8 02             	cmp    $0x2,%eax
  801c8b:	74 2b                	je     801cb8 <alloc_block+0x40>
  801c8d:	83 f8 02             	cmp    $0x2,%eax
  801c90:	7f 07                	jg     801c99 <alloc_block+0x21>
  801c92:	83 f8 01             	cmp    $0x1,%eax
  801c95:	74 0e                	je     801ca5 <alloc_block+0x2d>
  801c97:	eb 58                	jmp    801cf1 <alloc_block+0x79>
  801c99:	83 f8 03             	cmp    $0x3,%eax
  801c9c:	74 2d                	je     801ccb <alloc_block+0x53>
  801c9e:	83 f8 04             	cmp    $0x4,%eax
  801ca1:	74 3b                	je     801cde <alloc_block+0x66>
  801ca3:	eb 4c                	jmp    801cf1 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801ca5:	83 ec 0c             	sub    $0xc,%esp
  801ca8:	ff 75 08             	pushl  0x8(%ebp)
  801cab:	e8 11 03 00 00       	call   801fc1 <alloc_block_FF>
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cb6:	eb 4a                	jmp    801d02 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	ff 75 08             	pushl  0x8(%ebp)
  801cbe:	e8 c7 19 00 00       	call   80368a <alloc_block_NF>
  801cc3:	83 c4 10             	add    $0x10,%esp
  801cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cc9:	eb 37                	jmp    801d02 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801ccb:	83 ec 0c             	sub    $0xc,%esp
  801cce:	ff 75 08             	pushl  0x8(%ebp)
  801cd1:	e8 a7 07 00 00       	call   80247d <alloc_block_BF>
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cdc:	eb 24                	jmp    801d02 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801cde:	83 ec 0c             	sub    $0xc,%esp
  801ce1:	ff 75 08             	pushl  0x8(%ebp)
  801ce4:	e8 84 19 00 00       	call   80366d <alloc_block_WF>
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cef:	eb 11                	jmp    801d02 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801cf1:	83 ec 0c             	sub    $0xc,%esp
  801cf4:	68 48 40 80 00       	push   $0x804048
  801cf9:	e8 4d e6 ff ff       	call   80034b <cprintf>
  801cfe:	83 c4 10             	add    $0x10,%esp
		break;
  801d01:	90                   	nop
	}
	return va;
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	53                   	push   %ebx
  801d0b:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	68 68 40 80 00       	push   $0x804068
  801d16:	e8 30 e6 ff ff       	call   80034b <cprintf>
  801d1b:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d1e:	83 ec 0c             	sub    $0xc,%esp
  801d21:	68 93 40 80 00       	push   $0x804093
  801d26:	e8 20 e6 ff ff       	call   80034b <cprintf>
  801d2b:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d34:	eb 37                	jmp    801d6d <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d36:	83 ec 0c             	sub    $0xc,%esp
  801d39:	ff 75 f4             	pushl  -0xc(%ebp)
  801d3c:	e8 19 ff ff ff       	call   801c5a <is_free_block>
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	0f be d8             	movsbl %al,%ebx
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4d:	e8 ef fe ff ff       	call   801c41 <get_block_size>
  801d52:	83 c4 10             	add    $0x10,%esp
  801d55:	83 ec 04             	sub    $0x4,%esp
  801d58:	53                   	push   %ebx
  801d59:	50                   	push   %eax
  801d5a:	68 ab 40 80 00       	push   $0x8040ab
  801d5f:	e8 e7 e5 ff ff       	call   80034b <cprintf>
  801d64:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801d67:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d71:	74 07                	je     801d7a <print_blocks_list+0x73>
  801d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d76:	8b 00                	mov    (%eax),%eax
  801d78:	eb 05                	jmp    801d7f <print_blocks_list+0x78>
  801d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7f:	89 45 10             	mov    %eax,0x10(%ebp)
  801d82:	8b 45 10             	mov    0x10(%ebp),%eax
  801d85:	85 c0                	test   %eax,%eax
  801d87:	75 ad                	jne    801d36 <print_blocks_list+0x2f>
  801d89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d8d:	75 a7                	jne    801d36 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801d8f:	83 ec 0c             	sub    $0xc,%esp
  801d92:	68 68 40 80 00       	push   $0x804068
  801d97:	e8 af e5 ff ff       	call   80034b <cprintf>
  801d9c:	83 c4 10             	add    $0x10,%esp

}
  801d9f:	90                   	nop
  801da0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dae:	83 e0 01             	and    $0x1,%eax
  801db1:	85 c0                	test   %eax,%eax
  801db3:	74 03                	je     801db8 <initialize_dynamic_allocator+0x13>
  801db5:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801db8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dbc:	0f 84 c7 01 00 00    	je     801f89 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801dc2:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801dc9:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  801dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd2:	01 d0                	add    %edx,%eax
  801dd4:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801dd9:	0f 87 ad 01 00 00    	ja     801f8c <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	85 c0                	test   %eax,%eax
  801de4:	0f 89 a5 01 00 00    	jns    801f8f <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801dea:	8b 55 08             	mov    0x8(%ebp),%edx
  801ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df0:	01 d0                	add    %edx,%eax
  801df2:	83 e8 04             	sub    $0x4,%eax
  801df5:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801dfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801e01:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e09:	e9 87 00 00 00       	jmp    801e95 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801e0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e12:	75 14                	jne    801e28 <initialize_dynamic_allocator+0x83>
  801e14:	83 ec 04             	sub    $0x4,%esp
  801e17:	68 c3 40 80 00       	push   $0x8040c3
  801e1c:	6a 79                	push   $0x79
  801e1e:	68 e1 40 80 00       	push   $0x8040e1
  801e23:	e8 7f 18 00 00       	call   8036a7 <_panic>
  801e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2b:	8b 00                	mov    (%eax),%eax
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	74 10                	je     801e41 <initialize_dynamic_allocator+0x9c>
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	8b 00                	mov    (%eax),%eax
  801e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e39:	8b 52 04             	mov    0x4(%edx),%edx
  801e3c:	89 50 04             	mov    %edx,0x4(%eax)
  801e3f:	eb 0b                	jmp    801e4c <initialize_dynamic_allocator+0xa7>
  801e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e44:	8b 40 04             	mov    0x4(%eax),%eax
  801e47:	a3 30 50 80 00       	mov    %eax,0x805030
  801e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4f:	8b 40 04             	mov    0x4(%eax),%eax
  801e52:	85 c0                	test   %eax,%eax
  801e54:	74 0f                	je     801e65 <initialize_dynamic_allocator+0xc0>
  801e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e59:	8b 40 04             	mov    0x4(%eax),%eax
  801e5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e5f:	8b 12                	mov    (%edx),%edx
  801e61:	89 10                	mov    %edx,(%eax)
  801e63:	eb 0a                	jmp    801e6f <initialize_dynamic_allocator+0xca>
  801e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e68:	8b 00                	mov    (%eax),%eax
  801e6a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e82:	a1 38 50 80 00       	mov    0x805038,%eax
  801e87:	48                   	dec    %eax
  801e88:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801e8d:	a1 34 50 80 00       	mov    0x805034,%eax
  801e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e99:	74 07                	je     801ea2 <initialize_dynamic_allocator+0xfd>
  801e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9e:	8b 00                	mov    (%eax),%eax
  801ea0:	eb 05                	jmp    801ea7 <initialize_dynamic_allocator+0x102>
  801ea2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea7:	a3 34 50 80 00       	mov    %eax,0x805034
  801eac:	a1 34 50 80 00       	mov    0x805034,%eax
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	0f 85 55 ff ff ff    	jne    801e0e <initialize_dynamic_allocator+0x69>
  801eb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ebd:	0f 85 4b ff ff ff    	jne    801e0e <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801ed2:	a1 44 50 80 00       	mov    0x805044,%eax
  801ed7:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801edc:	a1 40 50 80 00       	mov    0x805040,%eax
  801ee1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	83 c0 08             	add    $0x8,%eax
  801eed:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	83 c0 04             	add    $0x4,%eax
  801ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef9:	83 ea 08             	sub    $0x8,%edx
  801efc:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801efe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	01 d0                	add    %edx,%eax
  801f06:	83 e8 08             	sub    $0x8,%eax
  801f09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0c:	83 ea 08             	sub    $0x8,%edx
  801f0f:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f24:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f28:	75 17                	jne    801f41 <initialize_dynamic_allocator+0x19c>
  801f2a:	83 ec 04             	sub    $0x4,%esp
  801f2d:	68 fc 40 80 00       	push   $0x8040fc
  801f32:	68 90 00 00 00       	push   $0x90
  801f37:	68 e1 40 80 00       	push   $0x8040e1
  801f3c:	e8 66 17 00 00       	call   8036a7 <_panic>
  801f41:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4a:	89 10                	mov    %edx,(%eax)
  801f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4f:	8b 00                	mov    (%eax),%eax
  801f51:	85 c0                	test   %eax,%eax
  801f53:	74 0d                	je     801f62 <initialize_dynamic_allocator+0x1bd>
  801f55:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f5d:	89 50 04             	mov    %edx,0x4(%eax)
  801f60:	eb 08                	jmp    801f6a <initialize_dynamic_allocator+0x1c5>
  801f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f65:	a3 30 50 80 00       	mov    %eax,0x805030
  801f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f7c:	a1 38 50 80 00       	mov    0x805038,%eax
  801f81:	40                   	inc    %eax
  801f82:	a3 38 50 80 00       	mov    %eax,0x805038
  801f87:	eb 07                	jmp    801f90 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801f89:	90                   	nop
  801f8a:	eb 04                	jmp    801f90 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801f8c:	90                   	nop
  801f8d:	eb 01                	jmp    801f90 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801f8f:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801f95:	8b 45 10             	mov    0x10(%ebp),%eax
  801f98:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	8d 50 fc             	lea    -0x4(%eax),%edx
  801fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa4:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	83 e8 04             	sub    $0x4,%eax
  801fac:	8b 00                	mov    (%eax),%eax
  801fae:	83 e0 fe             	and    $0xfffffffe,%eax
  801fb1:	8d 50 f8             	lea    -0x8(%eax),%edx
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	01 c2                	add    %eax,%edx
  801fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbc:	89 02                	mov    %eax,(%edx)
}
  801fbe:	90                   	nop
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    

00801fc1 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	83 e0 01             	and    $0x1,%eax
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	74 03                	je     801fd4 <alloc_block_FF+0x13>
  801fd1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801fd4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801fd8:	77 07                	ja     801fe1 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801fda:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801fe1:	a1 24 50 80 00       	mov    0x805024,%eax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	75 73                	jne    80205d <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	83 c0 10             	add    $0x10,%eax
  801ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  801ff3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ffa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ffd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802000:	01 d0                	add    %edx,%eax
  802002:	48                   	dec    %eax
  802003:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802009:	ba 00 00 00 00       	mov    $0x0,%edx
  80200e:	f7 75 ec             	divl   -0x14(%ebp)
  802011:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802014:	29 d0                	sub    %edx,%eax
  802016:	c1 e8 0c             	shr    $0xc,%eax
  802019:	83 ec 0c             	sub    $0xc,%esp
  80201c:	50                   	push   %eax
  80201d:	e8 c3 f0 ff ff       	call   8010e5 <sbrk>
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802028:	83 ec 0c             	sub    $0xc,%esp
  80202b:	6a 00                	push   $0x0
  80202d:	e8 b3 f0 ff ff       	call   8010e5 <sbrk>
  802032:	83 c4 10             	add    $0x10,%esp
  802035:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802038:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80203b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80203e:	83 ec 08             	sub    $0x8,%esp
  802041:	50                   	push   %eax
  802042:	ff 75 e4             	pushl  -0x1c(%ebp)
  802045:	e8 5b fd ff ff       	call   801da5 <initialize_dynamic_allocator>
  80204a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80204d:	83 ec 0c             	sub    $0xc,%esp
  802050:	68 1f 41 80 00       	push   $0x80411f
  802055:	e8 f1 e2 ff ff       	call   80034b <cprintf>
  80205a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80205d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802061:	75 0a                	jne    80206d <alloc_block_FF+0xac>
	        return NULL;
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
  802068:	e9 0e 04 00 00       	jmp    80247b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80206d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802074:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80207c:	e9 f3 02 00 00       	jmp    802374 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802084:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802087:	83 ec 0c             	sub    $0xc,%esp
  80208a:	ff 75 bc             	pushl  -0x44(%ebp)
  80208d:	e8 af fb ff ff       	call   801c41 <get_block_size>
  802092:	83 c4 10             	add    $0x10,%esp
  802095:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	83 c0 08             	add    $0x8,%eax
  80209e:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020a1:	0f 87 c5 02 00 00    	ja     80236c <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	83 c0 18             	add    $0x18,%eax
  8020ad:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020b0:	0f 87 19 02 00 00    	ja     8022cf <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8020b6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020b9:	2b 45 08             	sub    0x8(%ebp),%eax
  8020bc:	83 e8 08             	sub    $0x8,%eax
  8020bf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	8d 50 08             	lea    0x8(%eax),%edx
  8020c8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8020cb:	01 d0                	add    %edx,%eax
  8020cd:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	83 c0 08             	add    $0x8,%eax
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	6a 01                	push   $0x1
  8020db:	50                   	push   %eax
  8020dc:	ff 75 bc             	pushl  -0x44(%ebp)
  8020df:	e8 ae fe ff ff       	call   801f92 <set_block_data>
  8020e4:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8020e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ea:	8b 40 04             	mov    0x4(%eax),%eax
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	75 68                	jne    802159 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8020f1:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8020f5:	75 17                	jne    80210e <alloc_block_FF+0x14d>
  8020f7:	83 ec 04             	sub    $0x4,%esp
  8020fa:	68 fc 40 80 00       	push   $0x8040fc
  8020ff:	68 d7 00 00 00       	push   $0xd7
  802104:	68 e1 40 80 00       	push   $0x8040e1
  802109:	e8 99 15 00 00       	call   8036a7 <_panic>
  80210e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802114:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802117:	89 10                	mov    %edx,(%eax)
  802119:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80211c:	8b 00                	mov    (%eax),%eax
  80211e:	85 c0                	test   %eax,%eax
  802120:	74 0d                	je     80212f <alloc_block_FF+0x16e>
  802122:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802127:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80212a:	89 50 04             	mov    %edx,0x4(%eax)
  80212d:	eb 08                	jmp    802137 <alloc_block_FF+0x176>
  80212f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802132:	a3 30 50 80 00       	mov    %eax,0x805030
  802137:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80213a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80213f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802142:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802149:	a1 38 50 80 00       	mov    0x805038,%eax
  80214e:	40                   	inc    %eax
  80214f:	a3 38 50 80 00       	mov    %eax,0x805038
  802154:	e9 dc 00 00 00       	jmp    802235 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	8b 00                	mov    (%eax),%eax
  80215e:	85 c0                	test   %eax,%eax
  802160:	75 65                	jne    8021c7 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802162:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802166:	75 17                	jne    80217f <alloc_block_FF+0x1be>
  802168:	83 ec 04             	sub    $0x4,%esp
  80216b:	68 30 41 80 00       	push   $0x804130
  802170:	68 db 00 00 00       	push   $0xdb
  802175:	68 e1 40 80 00       	push   $0x8040e1
  80217a:	e8 28 15 00 00       	call   8036a7 <_panic>
  80217f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802185:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802188:	89 50 04             	mov    %edx,0x4(%eax)
  80218b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80218e:	8b 40 04             	mov    0x4(%eax),%eax
  802191:	85 c0                	test   %eax,%eax
  802193:	74 0c                	je     8021a1 <alloc_block_FF+0x1e0>
  802195:	a1 30 50 80 00       	mov    0x805030,%eax
  80219a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80219d:	89 10                	mov    %edx,(%eax)
  80219f:	eb 08                	jmp    8021a9 <alloc_block_FF+0x1e8>
  8021a1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021a4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021ac:	a3 30 50 80 00       	mov    %eax,0x805030
  8021b1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8021bf:	40                   	inc    %eax
  8021c0:	a3 38 50 80 00       	mov    %eax,0x805038
  8021c5:	eb 6e                	jmp    802235 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8021c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cb:	74 06                	je     8021d3 <alloc_block_FF+0x212>
  8021cd:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021d1:	75 17                	jne    8021ea <alloc_block_FF+0x229>
  8021d3:	83 ec 04             	sub    $0x4,%esp
  8021d6:	68 54 41 80 00       	push   $0x804154
  8021db:	68 df 00 00 00       	push   $0xdf
  8021e0:	68 e1 40 80 00       	push   $0x8040e1
  8021e5:	e8 bd 14 00 00       	call   8036a7 <_panic>
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	8b 10                	mov    (%eax),%edx
  8021ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021f2:	89 10                	mov    %edx,(%eax)
  8021f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	74 0b                	je     802208 <alloc_block_FF+0x247>
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	8b 00                	mov    (%eax),%eax
  802202:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802205:	89 50 04             	mov    %edx,0x4(%eax)
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80220e:	89 10                	mov    %edx,(%eax)
  802210:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802213:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802216:	89 50 04             	mov    %edx,0x4(%eax)
  802219:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80221c:	8b 00                	mov    (%eax),%eax
  80221e:	85 c0                	test   %eax,%eax
  802220:	75 08                	jne    80222a <alloc_block_FF+0x269>
  802222:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802225:	a3 30 50 80 00       	mov    %eax,0x805030
  80222a:	a1 38 50 80 00       	mov    0x805038,%eax
  80222f:	40                   	inc    %eax
  802230:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802235:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802239:	75 17                	jne    802252 <alloc_block_FF+0x291>
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	68 c3 40 80 00       	push   $0x8040c3
  802243:	68 e1 00 00 00       	push   $0xe1
  802248:	68 e1 40 80 00       	push   $0x8040e1
  80224d:	e8 55 14 00 00       	call   8036a7 <_panic>
  802252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802255:	8b 00                	mov    (%eax),%eax
  802257:	85 c0                	test   %eax,%eax
  802259:	74 10                	je     80226b <alloc_block_FF+0x2aa>
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 00                	mov    (%eax),%eax
  802260:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802263:	8b 52 04             	mov    0x4(%edx),%edx
  802266:	89 50 04             	mov    %edx,0x4(%eax)
  802269:	eb 0b                	jmp    802276 <alloc_block_FF+0x2b5>
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 40 04             	mov    0x4(%eax),%eax
  802271:	a3 30 50 80 00       	mov    %eax,0x805030
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 40 04             	mov    0x4(%eax),%eax
  80227c:	85 c0                	test   %eax,%eax
  80227e:	74 0f                	je     80228f <alloc_block_FF+0x2ce>
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 40 04             	mov    0x4(%eax),%eax
  802286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802289:	8b 12                	mov    (%edx),%edx
  80228b:	89 10                	mov    %edx,(%eax)
  80228d:	eb 0a                	jmp    802299 <alloc_block_FF+0x2d8>
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	8b 00                	mov    (%eax),%eax
  802294:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8022b1:	48                   	dec    %eax
  8022b2:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	6a 00                	push   $0x0
  8022bc:	ff 75 b4             	pushl  -0x4c(%ebp)
  8022bf:	ff 75 b0             	pushl  -0x50(%ebp)
  8022c2:	e8 cb fc ff ff       	call   801f92 <set_block_data>
  8022c7:	83 c4 10             	add    $0x10,%esp
  8022ca:	e9 95 00 00 00       	jmp    802364 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8022cf:	83 ec 04             	sub    $0x4,%esp
  8022d2:	6a 01                	push   $0x1
  8022d4:	ff 75 b8             	pushl  -0x48(%ebp)
  8022d7:	ff 75 bc             	pushl  -0x44(%ebp)
  8022da:	e8 b3 fc ff ff       	call   801f92 <set_block_data>
  8022df:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8022e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e6:	75 17                	jne    8022ff <alloc_block_FF+0x33e>
  8022e8:	83 ec 04             	sub    $0x4,%esp
  8022eb:	68 c3 40 80 00       	push   $0x8040c3
  8022f0:	68 e8 00 00 00       	push   $0xe8
  8022f5:	68 e1 40 80 00       	push   $0x8040e1
  8022fa:	e8 a8 13 00 00       	call   8036a7 <_panic>
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 00                	mov    (%eax),%eax
  802304:	85 c0                	test   %eax,%eax
  802306:	74 10                	je     802318 <alloc_block_FF+0x357>
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 00                	mov    (%eax),%eax
  80230d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802310:	8b 52 04             	mov    0x4(%edx),%edx
  802313:	89 50 04             	mov    %edx,0x4(%eax)
  802316:	eb 0b                	jmp    802323 <alloc_block_FF+0x362>
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 40 04             	mov    0x4(%eax),%eax
  80231e:	a3 30 50 80 00       	mov    %eax,0x805030
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 40 04             	mov    0x4(%eax),%eax
  802329:	85 c0                	test   %eax,%eax
  80232b:	74 0f                	je     80233c <alloc_block_FF+0x37b>
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 40 04             	mov    0x4(%eax),%eax
  802333:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802336:	8b 12                	mov    (%edx),%edx
  802338:	89 10                	mov    %edx,(%eax)
  80233a:	eb 0a                	jmp    802346 <alloc_block_FF+0x385>
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 00                	mov    (%eax),%eax
  802341:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802359:	a1 38 50 80 00       	mov    0x805038,%eax
  80235e:	48                   	dec    %eax
  80235f:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802364:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802367:	e9 0f 01 00 00       	jmp    80247b <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80236c:	a1 34 50 80 00       	mov    0x805034,%eax
  802371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802378:	74 07                	je     802381 <alloc_block_FF+0x3c0>
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 00                	mov    (%eax),%eax
  80237f:	eb 05                	jmp    802386 <alloc_block_FF+0x3c5>
  802381:	b8 00 00 00 00       	mov    $0x0,%eax
  802386:	a3 34 50 80 00       	mov    %eax,0x805034
  80238b:	a1 34 50 80 00       	mov    0x805034,%eax
  802390:	85 c0                	test   %eax,%eax
  802392:	0f 85 e9 fc ff ff    	jne    802081 <alloc_block_FF+0xc0>
  802398:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239c:	0f 85 df fc ff ff    	jne    802081 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	83 c0 08             	add    $0x8,%eax
  8023a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8023ab:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8023b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023b8:	01 d0                	add    %edx,%eax
  8023ba:	48                   	dec    %eax
  8023bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8023be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c6:	f7 75 d8             	divl   -0x28(%ebp)
  8023c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023cc:	29 d0                	sub    %edx,%eax
  8023ce:	c1 e8 0c             	shr    $0xc,%eax
  8023d1:	83 ec 0c             	sub    $0xc,%esp
  8023d4:	50                   	push   %eax
  8023d5:	e8 0b ed ff ff       	call   8010e5 <sbrk>
  8023da:	83 c4 10             	add    $0x10,%esp
  8023dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8023e0:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8023e4:	75 0a                	jne    8023f0 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023eb:	e9 8b 00 00 00       	jmp    80247b <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8023f0:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8023f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023fd:	01 d0                	add    %edx,%eax
  8023ff:	48                   	dec    %eax
  802400:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802403:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802406:	ba 00 00 00 00       	mov    $0x0,%edx
  80240b:	f7 75 cc             	divl   -0x34(%ebp)
  80240e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802411:	29 d0                	sub    %edx,%eax
  802413:	8d 50 fc             	lea    -0x4(%eax),%edx
  802416:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802419:	01 d0                	add    %edx,%eax
  80241b:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802420:	a1 40 50 80 00       	mov    0x805040,%eax
  802425:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80242b:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802432:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802435:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802438:	01 d0                	add    %edx,%eax
  80243a:	48                   	dec    %eax
  80243b:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80243e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802441:	ba 00 00 00 00       	mov    $0x0,%edx
  802446:	f7 75 c4             	divl   -0x3c(%ebp)
  802449:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80244c:	29 d0                	sub    %edx,%eax
  80244e:	83 ec 04             	sub    $0x4,%esp
  802451:	6a 01                	push   $0x1
  802453:	50                   	push   %eax
  802454:	ff 75 d0             	pushl  -0x30(%ebp)
  802457:	e8 36 fb ff ff       	call   801f92 <set_block_data>
  80245c:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80245f:	83 ec 0c             	sub    $0xc,%esp
  802462:	ff 75 d0             	pushl  -0x30(%ebp)
  802465:	e8 f8 09 00 00       	call   802e62 <free_block>
  80246a:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80246d:	83 ec 0c             	sub    $0xc,%esp
  802470:	ff 75 08             	pushl  0x8(%ebp)
  802473:	e8 49 fb ff ff       	call   801fc1 <alloc_block_FF>
  802478:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
  802480:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	83 e0 01             	and    $0x1,%eax
  802489:	85 c0                	test   %eax,%eax
  80248b:	74 03                	je     802490 <alloc_block_BF+0x13>
  80248d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802490:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802494:	77 07                	ja     80249d <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802496:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80249d:	a1 24 50 80 00       	mov    0x805024,%eax
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	75 73                	jne    802519 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a9:	83 c0 10             	add    $0x10,%eax
  8024ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024af:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8024b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024bc:	01 d0                	add    %edx,%eax
  8024be:	48                   	dec    %eax
  8024bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8024c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ca:	f7 75 e0             	divl   -0x20(%ebp)
  8024cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024d0:	29 d0                	sub    %edx,%eax
  8024d2:	c1 e8 0c             	shr    $0xc,%eax
  8024d5:	83 ec 0c             	sub    $0xc,%esp
  8024d8:	50                   	push   %eax
  8024d9:	e8 07 ec ff ff       	call   8010e5 <sbrk>
  8024de:	83 c4 10             	add    $0x10,%esp
  8024e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024e4:	83 ec 0c             	sub    $0xc,%esp
  8024e7:	6a 00                	push   $0x0
  8024e9:	e8 f7 eb ff ff       	call   8010e5 <sbrk>
  8024ee:	83 c4 10             	add    $0x10,%esp
  8024f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024f7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8024fa:	83 ec 08             	sub    $0x8,%esp
  8024fd:	50                   	push   %eax
  8024fe:	ff 75 d8             	pushl  -0x28(%ebp)
  802501:	e8 9f f8 ff ff       	call   801da5 <initialize_dynamic_allocator>
  802506:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802509:	83 ec 0c             	sub    $0xc,%esp
  80250c:	68 1f 41 80 00       	push   $0x80411f
  802511:	e8 35 de ff ff       	call   80034b <cprintf>
  802516:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802519:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802520:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802527:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80252e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802535:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80253a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253d:	e9 1d 01 00 00       	jmp    80265f <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802548:	83 ec 0c             	sub    $0xc,%esp
  80254b:	ff 75 a8             	pushl  -0x58(%ebp)
  80254e:	e8 ee f6 ff ff       	call   801c41 <get_block_size>
  802553:	83 c4 10             	add    $0x10,%esp
  802556:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802559:	8b 45 08             	mov    0x8(%ebp),%eax
  80255c:	83 c0 08             	add    $0x8,%eax
  80255f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802562:	0f 87 ef 00 00 00    	ja     802657 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802568:	8b 45 08             	mov    0x8(%ebp),%eax
  80256b:	83 c0 18             	add    $0x18,%eax
  80256e:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802571:	77 1d                	ja     802590 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802576:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802579:	0f 86 d8 00 00 00    	jbe    802657 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80257f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802582:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802585:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802588:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80258b:	e9 c7 00 00 00       	jmp    802657 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802590:	8b 45 08             	mov    0x8(%ebp),%eax
  802593:	83 c0 08             	add    $0x8,%eax
  802596:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802599:	0f 85 9d 00 00 00    	jne    80263c <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80259f:	83 ec 04             	sub    $0x4,%esp
  8025a2:	6a 01                	push   $0x1
  8025a4:	ff 75 a4             	pushl  -0x5c(%ebp)
  8025a7:	ff 75 a8             	pushl  -0x58(%ebp)
  8025aa:	e8 e3 f9 ff ff       	call   801f92 <set_block_data>
  8025af:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8025b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b6:	75 17                	jne    8025cf <alloc_block_BF+0x152>
  8025b8:	83 ec 04             	sub    $0x4,%esp
  8025bb:	68 c3 40 80 00       	push   $0x8040c3
  8025c0:	68 2c 01 00 00       	push   $0x12c
  8025c5:	68 e1 40 80 00       	push   $0x8040e1
  8025ca:	e8 d8 10 00 00       	call   8036a7 <_panic>
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	85 c0                	test   %eax,%eax
  8025d6:	74 10                	je     8025e8 <alloc_block_BF+0x16b>
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 00                	mov    (%eax),%eax
  8025dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e0:	8b 52 04             	mov    0x4(%edx),%edx
  8025e3:	89 50 04             	mov    %edx,0x4(%eax)
  8025e6:	eb 0b                	jmp    8025f3 <alloc_block_BF+0x176>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ee:	a3 30 50 80 00       	mov    %eax,0x805030
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 40 04             	mov    0x4(%eax),%eax
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	74 0f                	je     80260c <alloc_block_BF+0x18f>
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 40 04             	mov    0x4(%eax),%eax
  802603:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802606:	8b 12                	mov    (%edx),%edx
  802608:	89 10                	mov    %edx,(%eax)
  80260a:	eb 0a                	jmp    802616 <alloc_block_BF+0x199>
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 00                	mov    (%eax),%eax
  802611:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802629:	a1 38 50 80 00       	mov    0x805038,%eax
  80262e:	48                   	dec    %eax
  80262f:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802634:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802637:	e9 01 04 00 00       	jmp    802a3d <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  80263c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263f:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802642:	76 13                	jbe    802657 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802644:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80264b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80264e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802651:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802654:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802657:	a1 34 50 80 00       	mov    0x805034,%eax
  80265c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802663:	74 07                	je     80266c <alloc_block_BF+0x1ef>
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 00                	mov    (%eax),%eax
  80266a:	eb 05                	jmp    802671 <alloc_block_BF+0x1f4>
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
  802671:	a3 34 50 80 00       	mov    %eax,0x805034
  802676:	a1 34 50 80 00       	mov    0x805034,%eax
  80267b:	85 c0                	test   %eax,%eax
  80267d:	0f 85 bf fe ff ff    	jne    802542 <alloc_block_BF+0xc5>
  802683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802687:	0f 85 b5 fe ff ff    	jne    802542 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80268d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802691:	0f 84 26 02 00 00    	je     8028bd <alloc_block_BF+0x440>
  802697:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80269b:	0f 85 1c 02 00 00    	jne    8028bd <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8026a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a7:	83 e8 08             	sub    $0x8,%eax
  8026aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	8d 50 08             	lea    0x8(%eax),%edx
  8026b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b6:	01 d0                	add    %edx,%eax
  8026b8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8026bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026be:	83 c0 08             	add    $0x8,%eax
  8026c1:	83 ec 04             	sub    $0x4,%esp
  8026c4:	6a 01                	push   $0x1
  8026c6:	50                   	push   %eax
  8026c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8026ca:	e8 c3 f8 ff ff       	call   801f92 <set_block_data>
  8026cf:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8026d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d5:	8b 40 04             	mov    0x4(%eax),%eax
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	75 68                	jne    802744 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026dc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026e0:	75 17                	jne    8026f9 <alloc_block_BF+0x27c>
  8026e2:	83 ec 04             	sub    $0x4,%esp
  8026e5:	68 fc 40 80 00       	push   $0x8040fc
  8026ea:	68 45 01 00 00       	push   $0x145
  8026ef:	68 e1 40 80 00       	push   $0x8040e1
  8026f4:	e8 ae 0f 00 00       	call   8036a7 <_panic>
  8026f9:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8026ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802702:	89 10                	mov    %edx,(%eax)
  802704:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	85 c0                	test   %eax,%eax
  80270b:	74 0d                	je     80271a <alloc_block_BF+0x29d>
  80270d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802712:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802715:	89 50 04             	mov    %edx,0x4(%eax)
  802718:	eb 08                	jmp    802722 <alloc_block_BF+0x2a5>
  80271a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80271d:	a3 30 50 80 00       	mov    %eax,0x805030
  802722:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802725:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80272a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80272d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802734:	a1 38 50 80 00       	mov    0x805038,%eax
  802739:	40                   	inc    %eax
  80273a:	a3 38 50 80 00       	mov    %eax,0x805038
  80273f:	e9 dc 00 00 00       	jmp    802820 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802747:	8b 00                	mov    (%eax),%eax
  802749:	85 c0                	test   %eax,%eax
  80274b:	75 65                	jne    8027b2 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80274d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802751:	75 17                	jne    80276a <alloc_block_BF+0x2ed>
  802753:	83 ec 04             	sub    $0x4,%esp
  802756:	68 30 41 80 00       	push   $0x804130
  80275b:	68 4a 01 00 00       	push   $0x14a
  802760:	68 e1 40 80 00       	push   $0x8040e1
  802765:	e8 3d 0f 00 00       	call   8036a7 <_panic>
  80276a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802770:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802773:	89 50 04             	mov    %edx,0x4(%eax)
  802776:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802779:	8b 40 04             	mov    0x4(%eax),%eax
  80277c:	85 c0                	test   %eax,%eax
  80277e:	74 0c                	je     80278c <alloc_block_BF+0x30f>
  802780:	a1 30 50 80 00       	mov    0x805030,%eax
  802785:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802788:	89 10                	mov    %edx,(%eax)
  80278a:	eb 08                	jmp    802794 <alloc_block_BF+0x317>
  80278c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80278f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802794:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802797:	a3 30 50 80 00       	mov    %eax,0x805030
  80279c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80279f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8027aa:	40                   	inc    %eax
  8027ab:	a3 38 50 80 00       	mov    %eax,0x805038
  8027b0:	eb 6e                	jmp    802820 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8027b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027b6:	74 06                	je     8027be <alloc_block_BF+0x341>
  8027b8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027bc:	75 17                	jne    8027d5 <alloc_block_BF+0x358>
  8027be:	83 ec 04             	sub    $0x4,%esp
  8027c1:	68 54 41 80 00       	push   $0x804154
  8027c6:	68 4f 01 00 00       	push   $0x14f
  8027cb:	68 e1 40 80 00       	push   $0x8040e1
  8027d0:	e8 d2 0e 00 00       	call   8036a7 <_panic>
  8027d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d8:	8b 10                	mov    (%eax),%edx
  8027da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027dd:	89 10                	mov    %edx,(%eax)
  8027df:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 0b                	je     8027f3 <alloc_block_BF+0x376>
  8027e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027f0:	89 50 04             	mov    %edx,0x4(%eax)
  8027f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027f9:	89 10                	mov    %edx,(%eax)
  8027fb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802801:	89 50 04             	mov    %edx,0x4(%eax)
  802804:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802807:	8b 00                	mov    (%eax),%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	75 08                	jne    802815 <alloc_block_BF+0x398>
  80280d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802810:	a3 30 50 80 00       	mov    %eax,0x805030
  802815:	a1 38 50 80 00       	mov    0x805038,%eax
  80281a:	40                   	inc    %eax
  80281b:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802820:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802824:	75 17                	jne    80283d <alloc_block_BF+0x3c0>
  802826:	83 ec 04             	sub    $0x4,%esp
  802829:	68 c3 40 80 00       	push   $0x8040c3
  80282e:	68 51 01 00 00       	push   $0x151
  802833:	68 e1 40 80 00       	push   $0x8040e1
  802838:	e8 6a 0e 00 00       	call   8036a7 <_panic>
  80283d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802840:	8b 00                	mov    (%eax),%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	74 10                	je     802856 <alloc_block_BF+0x3d9>
  802846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284e:	8b 52 04             	mov    0x4(%edx),%edx
  802851:	89 50 04             	mov    %edx,0x4(%eax)
  802854:	eb 0b                	jmp    802861 <alloc_block_BF+0x3e4>
  802856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802859:	8b 40 04             	mov    0x4(%eax),%eax
  80285c:	a3 30 50 80 00       	mov    %eax,0x805030
  802861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802864:	8b 40 04             	mov    0x4(%eax),%eax
  802867:	85 c0                	test   %eax,%eax
  802869:	74 0f                	je     80287a <alloc_block_BF+0x3fd>
  80286b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286e:	8b 40 04             	mov    0x4(%eax),%eax
  802871:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802874:	8b 12                	mov    (%edx),%edx
  802876:	89 10                	mov    %edx,(%eax)
  802878:	eb 0a                	jmp    802884 <alloc_block_BF+0x407>
  80287a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287d:	8b 00                	mov    (%eax),%eax
  80287f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802887:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802890:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802897:	a1 38 50 80 00       	mov    0x805038,%eax
  80289c:	48                   	dec    %eax
  80289d:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8028a2:	83 ec 04             	sub    $0x4,%esp
  8028a5:	6a 00                	push   $0x0
  8028a7:	ff 75 d0             	pushl  -0x30(%ebp)
  8028aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8028ad:	e8 e0 f6 ff ff       	call   801f92 <set_block_data>
  8028b2:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8028b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b8:	e9 80 01 00 00       	jmp    802a3d <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  8028bd:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8028c1:	0f 85 9d 00 00 00    	jne    802964 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8028c7:	83 ec 04             	sub    $0x4,%esp
  8028ca:	6a 01                	push   $0x1
  8028cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8028cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8028d2:	e8 bb f6 ff ff       	call   801f92 <set_block_data>
  8028d7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8028da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028de:	75 17                	jne    8028f7 <alloc_block_BF+0x47a>
  8028e0:	83 ec 04             	sub    $0x4,%esp
  8028e3:	68 c3 40 80 00       	push   $0x8040c3
  8028e8:	68 58 01 00 00       	push   $0x158
  8028ed:	68 e1 40 80 00       	push   $0x8040e1
  8028f2:	e8 b0 0d 00 00       	call   8036a7 <_panic>
  8028f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	74 10                	je     802910 <alloc_block_BF+0x493>
  802900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802903:	8b 00                	mov    (%eax),%eax
  802905:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802908:	8b 52 04             	mov    0x4(%edx),%edx
  80290b:	89 50 04             	mov    %edx,0x4(%eax)
  80290e:	eb 0b                	jmp    80291b <alloc_block_BF+0x49e>
  802910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	a3 30 50 80 00       	mov    %eax,0x805030
  80291b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	74 0f                	je     802934 <alloc_block_BF+0x4b7>
  802925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802928:	8b 40 04             	mov    0x4(%eax),%eax
  80292b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80292e:	8b 12                	mov    (%edx),%edx
  802930:	89 10                	mov    %edx,(%eax)
  802932:	eb 0a                	jmp    80293e <alloc_block_BF+0x4c1>
  802934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80293e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802951:	a1 38 50 80 00       	mov    0x805038,%eax
  802956:	48                   	dec    %eax
  802957:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	e9 d9 00 00 00       	jmp    802a3d <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802964:	8b 45 08             	mov    0x8(%ebp),%eax
  802967:	83 c0 08             	add    $0x8,%eax
  80296a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80296d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802974:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802977:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80297a:	01 d0                	add    %edx,%eax
  80297c:	48                   	dec    %eax
  80297d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802980:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802983:	ba 00 00 00 00       	mov    $0x0,%edx
  802988:	f7 75 c4             	divl   -0x3c(%ebp)
  80298b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80298e:	29 d0                	sub    %edx,%eax
  802990:	c1 e8 0c             	shr    $0xc,%eax
  802993:	83 ec 0c             	sub    $0xc,%esp
  802996:	50                   	push   %eax
  802997:	e8 49 e7 ff ff       	call   8010e5 <sbrk>
  80299c:	83 c4 10             	add    $0x10,%esp
  80299f:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8029a2:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8029a6:	75 0a                	jne    8029b2 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8029a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ad:	e9 8b 00 00 00       	jmp    802a3d <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8029b2:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8029b9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029bf:	01 d0                	add    %edx,%eax
  8029c1:	48                   	dec    %eax
  8029c2:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8029c5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8029cd:	f7 75 b8             	divl   -0x48(%ebp)
  8029d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029d3:	29 d0                	sub    %edx,%eax
  8029d5:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029d8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029db:	01 d0                	add    %edx,%eax
  8029dd:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8029e2:	a1 40 50 80 00       	mov    0x805040,%eax
  8029e7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8029ed:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8029f4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029f7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029fa:	01 d0                	add    %edx,%eax
  8029fc:	48                   	dec    %eax
  8029fd:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a00:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a03:	ba 00 00 00 00       	mov    $0x0,%edx
  802a08:	f7 75 b0             	divl   -0x50(%ebp)
  802a0b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a0e:	29 d0                	sub    %edx,%eax
  802a10:	83 ec 04             	sub    $0x4,%esp
  802a13:	6a 01                	push   $0x1
  802a15:	50                   	push   %eax
  802a16:	ff 75 bc             	pushl  -0x44(%ebp)
  802a19:	e8 74 f5 ff ff       	call   801f92 <set_block_data>
  802a1e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a21:	83 ec 0c             	sub    $0xc,%esp
  802a24:	ff 75 bc             	pushl  -0x44(%ebp)
  802a27:	e8 36 04 00 00       	call   802e62 <free_block>
  802a2c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802a2f:	83 ec 0c             	sub    $0xc,%esp
  802a32:	ff 75 08             	pushl  0x8(%ebp)
  802a35:	e8 43 fa ff ff       	call   80247d <alloc_block_BF>
  802a3a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802a3d:	c9                   	leave  
  802a3e:	c3                   	ret    

00802a3f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802a3f:	55                   	push   %ebp
  802a40:	89 e5                	mov    %esp,%ebp
  802a42:	53                   	push   %ebx
  802a43:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802a46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a4d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802a54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a58:	74 1e                	je     802a78 <merging+0x39>
  802a5a:	ff 75 08             	pushl  0x8(%ebp)
  802a5d:	e8 df f1 ff ff       	call   801c41 <get_block_size>
  802a62:	83 c4 04             	add    $0x4,%esp
  802a65:	89 c2                	mov    %eax,%edx
  802a67:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6a:	01 d0                	add    %edx,%eax
  802a6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  802a6f:	75 07                	jne    802a78 <merging+0x39>
		prev_is_free = 1;
  802a71:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802a78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a7c:	74 1e                	je     802a9c <merging+0x5d>
  802a7e:	ff 75 10             	pushl  0x10(%ebp)
  802a81:	e8 bb f1 ff ff       	call   801c41 <get_block_size>
  802a86:	83 c4 04             	add    $0x4,%esp
  802a89:	89 c2                	mov    %eax,%edx
  802a8b:	8b 45 10             	mov    0x10(%ebp),%eax
  802a8e:	01 d0                	add    %edx,%eax
  802a90:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a93:	75 07                	jne    802a9c <merging+0x5d>
		next_is_free = 1;
  802a95:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802a9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa0:	0f 84 cc 00 00 00    	je     802b72 <merging+0x133>
  802aa6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aaa:	0f 84 c2 00 00 00    	je     802b72 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ab0:	ff 75 08             	pushl  0x8(%ebp)
  802ab3:	e8 89 f1 ff ff       	call   801c41 <get_block_size>
  802ab8:	83 c4 04             	add    $0x4,%esp
  802abb:	89 c3                	mov    %eax,%ebx
  802abd:	ff 75 10             	pushl  0x10(%ebp)
  802ac0:	e8 7c f1 ff ff       	call   801c41 <get_block_size>
  802ac5:	83 c4 04             	add    $0x4,%esp
  802ac8:	01 c3                	add    %eax,%ebx
  802aca:	ff 75 0c             	pushl  0xc(%ebp)
  802acd:	e8 6f f1 ff ff       	call   801c41 <get_block_size>
  802ad2:	83 c4 04             	add    $0x4,%esp
  802ad5:	01 d8                	add    %ebx,%eax
  802ad7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ada:	6a 00                	push   $0x0
  802adc:	ff 75 ec             	pushl  -0x14(%ebp)
  802adf:	ff 75 08             	pushl  0x8(%ebp)
  802ae2:	e8 ab f4 ff ff       	call   801f92 <set_block_data>
  802ae7:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802aea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802aee:	75 17                	jne    802b07 <merging+0xc8>
  802af0:	83 ec 04             	sub    $0x4,%esp
  802af3:	68 c3 40 80 00       	push   $0x8040c3
  802af8:	68 7d 01 00 00       	push   $0x17d
  802afd:	68 e1 40 80 00       	push   $0x8040e1
  802b02:	e8 a0 0b 00 00       	call   8036a7 <_panic>
  802b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b0a:	8b 00                	mov    (%eax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	74 10                	je     802b20 <merging+0xe1>
  802b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b18:	8b 52 04             	mov    0x4(%edx),%edx
  802b1b:	89 50 04             	mov    %edx,0x4(%eax)
  802b1e:	eb 0b                	jmp    802b2b <merging+0xec>
  802b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b23:	8b 40 04             	mov    0x4(%eax),%eax
  802b26:	a3 30 50 80 00       	mov    %eax,0x805030
  802b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b2e:	8b 40 04             	mov    0x4(%eax),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	74 0f                	je     802b44 <merging+0x105>
  802b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b38:	8b 40 04             	mov    0x4(%eax),%eax
  802b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b3e:	8b 12                	mov    (%edx),%edx
  802b40:	89 10                	mov    %edx,(%eax)
  802b42:	eb 0a                	jmp    802b4e <merging+0x10f>
  802b44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b47:	8b 00                	mov    (%eax),%eax
  802b49:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b61:	a1 38 50 80 00       	mov    0x805038,%eax
  802b66:	48                   	dec    %eax
  802b67:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802b6c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b6d:	e9 ea 02 00 00       	jmp    802e5c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802b72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b76:	74 3b                	je     802bb3 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802b78:	83 ec 0c             	sub    $0xc,%esp
  802b7b:	ff 75 08             	pushl  0x8(%ebp)
  802b7e:	e8 be f0 ff ff       	call   801c41 <get_block_size>
  802b83:	83 c4 10             	add    $0x10,%esp
  802b86:	89 c3                	mov    %eax,%ebx
  802b88:	83 ec 0c             	sub    $0xc,%esp
  802b8b:	ff 75 10             	pushl  0x10(%ebp)
  802b8e:	e8 ae f0 ff ff       	call   801c41 <get_block_size>
  802b93:	83 c4 10             	add    $0x10,%esp
  802b96:	01 d8                	add    %ebx,%eax
  802b98:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b9b:	83 ec 04             	sub    $0x4,%esp
  802b9e:	6a 00                	push   $0x0
  802ba0:	ff 75 e8             	pushl  -0x18(%ebp)
  802ba3:	ff 75 08             	pushl  0x8(%ebp)
  802ba6:	e8 e7 f3 ff ff       	call   801f92 <set_block_data>
  802bab:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bae:	e9 a9 02 00 00       	jmp    802e5c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802bb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb7:	0f 84 2d 01 00 00    	je     802cea <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802bbd:	83 ec 0c             	sub    $0xc,%esp
  802bc0:	ff 75 10             	pushl  0x10(%ebp)
  802bc3:	e8 79 f0 ff ff       	call   801c41 <get_block_size>
  802bc8:	83 c4 10             	add    $0x10,%esp
  802bcb:	89 c3                	mov    %eax,%ebx
  802bcd:	83 ec 0c             	sub    $0xc,%esp
  802bd0:	ff 75 0c             	pushl  0xc(%ebp)
  802bd3:	e8 69 f0 ff ff       	call   801c41 <get_block_size>
  802bd8:	83 c4 10             	add    $0x10,%esp
  802bdb:	01 d8                	add    %ebx,%eax
  802bdd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802be0:	83 ec 04             	sub    $0x4,%esp
  802be3:	6a 00                	push   $0x0
  802be5:	ff 75 e4             	pushl  -0x1c(%ebp)
  802be8:	ff 75 10             	pushl  0x10(%ebp)
  802beb:	e8 a2 f3 ff ff       	call   801f92 <set_block_data>
  802bf0:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  802bf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802bf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bfd:	74 06                	je     802c05 <merging+0x1c6>
  802bff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c03:	75 17                	jne    802c1c <merging+0x1dd>
  802c05:	83 ec 04             	sub    $0x4,%esp
  802c08:	68 88 41 80 00       	push   $0x804188
  802c0d:	68 8d 01 00 00       	push   $0x18d
  802c12:	68 e1 40 80 00       	push   $0x8040e1
  802c17:	e8 8b 0a 00 00       	call   8036a7 <_panic>
  802c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c1f:	8b 50 04             	mov    0x4(%eax),%edx
  802c22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c25:	89 50 04             	mov    %edx,0x4(%eax)
  802c28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c2e:	89 10                	mov    %edx,(%eax)
  802c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c33:	8b 40 04             	mov    0x4(%eax),%eax
  802c36:	85 c0                	test   %eax,%eax
  802c38:	74 0d                	je     802c47 <merging+0x208>
  802c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c3d:	8b 40 04             	mov    0x4(%eax),%eax
  802c40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c43:	89 10                	mov    %edx,(%eax)
  802c45:	eb 08                	jmp    802c4f <merging+0x210>
  802c47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c4a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c55:	89 50 04             	mov    %edx,0x4(%eax)
  802c58:	a1 38 50 80 00       	mov    0x805038,%eax
  802c5d:	40                   	inc    %eax
  802c5e:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802c63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c67:	75 17                	jne    802c80 <merging+0x241>
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	68 c3 40 80 00       	push   $0x8040c3
  802c71:	68 8e 01 00 00       	push   $0x18e
  802c76:	68 e1 40 80 00       	push   $0x8040e1
  802c7b:	e8 27 0a 00 00       	call   8036a7 <_panic>
  802c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	74 10                	je     802c99 <merging+0x25a>
  802c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c91:	8b 52 04             	mov    0x4(%edx),%edx
  802c94:	89 50 04             	mov    %edx,0x4(%eax)
  802c97:	eb 0b                	jmp    802ca4 <merging+0x265>
  802c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9c:	8b 40 04             	mov    0x4(%eax),%eax
  802c9f:	a3 30 50 80 00       	mov    %eax,0x805030
  802ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca7:	8b 40 04             	mov    0x4(%eax),%eax
  802caa:	85 c0                	test   %eax,%eax
  802cac:	74 0f                	je     802cbd <merging+0x27e>
  802cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb1:	8b 40 04             	mov    0x4(%eax),%eax
  802cb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cb7:	8b 12                	mov    (%edx),%edx
  802cb9:	89 10                	mov    %edx,(%eax)
  802cbb:	eb 0a                	jmp    802cc7 <merging+0x288>
  802cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc0:	8b 00                	mov    (%eax),%eax
  802cc2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cda:	a1 38 50 80 00       	mov    0x805038,%eax
  802cdf:	48                   	dec    %eax
  802ce0:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ce5:	e9 72 01 00 00       	jmp    802e5c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802cea:	8b 45 10             	mov    0x10(%ebp),%eax
  802ced:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802cf0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf4:	74 79                	je     802d6f <merging+0x330>
  802cf6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cfa:	74 73                	je     802d6f <merging+0x330>
  802cfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d00:	74 06                	je     802d08 <merging+0x2c9>
  802d02:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d06:	75 17                	jne    802d1f <merging+0x2e0>
  802d08:	83 ec 04             	sub    $0x4,%esp
  802d0b:	68 54 41 80 00       	push   $0x804154
  802d10:	68 94 01 00 00       	push   $0x194
  802d15:	68 e1 40 80 00       	push   $0x8040e1
  802d1a:	e8 88 09 00 00       	call   8036a7 <_panic>
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	8b 10                	mov    (%eax),%edx
  802d24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d27:	89 10                	mov    %edx,(%eax)
  802d29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	85 c0                	test   %eax,%eax
  802d30:	74 0b                	je     802d3d <merging+0x2fe>
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	8b 00                	mov    (%eax),%eax
  802d37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d3a:	89 50 04             	mov    %edx,0x4(%eax)
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d43:	89 10                	mov    %edx,(%eax)
  802d45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d48:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4b:	89 50 04             	mov    %edx,0x4(%eax)
  802d4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d51:	8b 00                	mov    (%eax),%eax
  802d53:	85 c0                	test   %eax,%eax
  802d55:	75 08                	jne    802d5f <merging+0x320>
  802d57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d5a:	a3 30 50 80 00       	mov    %eax,0x805030
  802d5f:	a1 38 50 80 00       	mov    0x805038,%eax
  802d64:	40                   	inc    %eax
  802d65:	a3 38 50 80 00       	mov    %eax,0x805038
  802d6a:	e9 ce 00 00 00       	jmp    802e3d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802d6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d73:	74 65                	je     802dda <merging+0x39b>
  802d75:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d79:	75 17                	jne    802d92 <merging+0x353>
  802d7b:	83 ec 04             	sub    $0x4,%esp
  802d7e:	68 30 41 80 00       	push   $0x804130
  802d83:	68 95 01 00 00       	push   $0x195
  802d88:	68 e1 40 80 00       	push   $0x8040e1
  802d8d:	e8 15 09 00 00       	call   8036a7 <_panic>
  802d92:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802d98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9b:	89 50 04             	mov    %edx,0x4(%eax)
  802d9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da1:	8b 40 04             	mov    0x4(%eax),%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 0c                	je     802db4 <merging+0x375>
  802da8:	a1 30 50 80 00       	mov    0x805030,%eax
  802dad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802db0:	89 10                	mov    %edx,(%eax)
  802db2:	eb 08                	jmp    802dbc <merging+0x37d>
  802db4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dbf:	a3 30 50 80 00       	mov    %eax,0x805030
  802dc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dcd:	a1 38 50 80 00       	mov    0x805038,%eax
  802dd2:	40                   	inc    %eax
  802dd3:	a3 38 50 80 00       	mov    %eax,0x805038
  802dd8:	eb 63                	jmp    802e3d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802dda:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dde:	75 17                	jne    802df7 <merging+0x3b8>
  802de0:	83 ec 04             	sub    $0x4,%esp
  802de3:	68 fc 40 80 00       	push   $0x8040fc
  802de8:	68 98 01 00 00       	push   $0x198
  802ded:	68 e1 40 80 00       	push   $0x8040e1
  802df2:	e8 b0 08 00 00       	call   8036a7 <_panic>
  802df7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802dfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e00:	89 10                	mov    %edx,(%eax)
  802e02:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e05:	8b 00                	mov    (%eax),%eax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	74 0d                	je     802e18 <merging+0x3d9>
  802e0b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e10:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e13:	89 50 04             	mov    %edx,0x4(%eax)
  802e16:	eb 08                	jmp    802e20 <merging+0x3e1>
  802e18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e20:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e23:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e32:	a1 38 50 80 00       	mov    0x805038,%eax
  802e37:	40                   	inc    %eax
  802e38:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802e3d:	83 ec 0c             	sub    $0xc,%esp
  802e40:	ff 75 10             	pushl  0x10(%ebp)
  802e43:	e8 f9 ed ff ff       	call   801c41 <get_block_size>
  802e48:	83 c4 10             	add    $0x10,%esp
  802e4b:	83 ec 04             	sub    $0x4,%esp
  802e4e:	6a 00                	push   $0x0
  802e50:	50                   	push   %eax
  802e51:	ff 75 10             	pushl  0x10(%ebp)
  802e54:	e8 39 f1 ff ff       	call   801f92 <set_block_data>
  802e59:	83 c4 10             	add    $0x10,%esp
	}
}
  802e5c:	90                   	nop
  802e5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e60:	c9                   	leave  
  802e61:	c3                   	ret    

00802e62 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e62:	55                   	push   %ebp
  802e63:	89 e5                	mov    %esp,%ebp
  802e65:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802e68:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e6d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802e70:	a1 30 50 80 00       	mov    0x805030,%eax
  802e75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e78:	73 1b                	jae    802e95 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802e7a:	a1 30 50 80 00       	mov    0x805030,%eax
  802e7f:	83 ec 04             	sub    $0x4,%esp
  802e82:	ff 75 08             	pushl  0x8(%ebp)
  802e85:	6a 00                	push   $0x0
  802e87:	50                   	push   %eax
  802e88:	e8 b2 fb ff ff       	call   802a3f <merging>
  802e8d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e90:	e9 8b 00 00 00       	jmp    802f20 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802e95:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9d:	76 18                	jbe    802eb7 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802e9f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ea4:	83 ec 04             	sub    $0x4,%esp
  802ea7:	ff 75 08             	pushl  0x8(%ebp)
  802eaa:	50                   	push   %eax
  802eab:	6a 00                	push   $0x0
  802ead:	e8 8d fb ff ff       	call   802a3f <merging>
  802eb2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802eb5:	eb 69                	jmp    802f20 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802eb7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ebc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebf:	eb 39                	jmp    802efa <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec7:	73 29                	jae    802ef2 <free_block+0x90>
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 00                	mov    (%eax),%eax
  802ece:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed1:	76 1f                	jbe    802ef2 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802edb:	83 ec 04             	sub    $0x4,%esp
  802ede:	ff 75 08             	pushl  0x8(%ebp)
  802ee1:	ff 75 f0             	pushl  -0x10(%ebp)
  802ee4:	ff 75 f4             	pushl  -0xc(%ebp)
  802ee7:	e8 53 fb ff ff       	call   802a3f <merging>
  802eec:	83 c4 10             	add    $0x10,%esp
			break;
  802eef:	90                   	nop
		}
	}
}
  802ef0:	eb 2e                	jmp    802f20 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802ef2:	a1 34 50 80 00       	mov    0x805034,%eax
  802ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efe:	74 07                	je     802f07 <free_block+0xa5>
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 00                	mov    (%eax),%eax
  802f05:	eb 05                	jmp    802f0c <free_block+0xaa>
  802f07:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0c:	a3 34 50 80 00       	mov    %eax,0x805034
  802f11:	a1 34 50 80 00       	mov    0x805034,%eax
  802f16:	85 c0                	test   %eax,%eax
  802f18:	75 a7                	jne    802ec1 <free_block+0x5f>
  802f1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1e:	75 a1                	jne    802ec1 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f20:	90                   	nop
  802f21:	c9                   	leave  
  802f22:	c3                   	ret    

00802f23 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f23:	55                   	push   %ebp
  802f24:	89 e5                	mov    %esp,%ebp
  802f26:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802f29:	ff 75 08             	pushl  0x8(%ebp)
  802f2c:	e8 10 ed ff ff       	call   801c41 <get_block_size>
  802f31:	83 c4 04             	add    $0x4,%esp
  802f34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802f37:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802f3e:	eb 17                	jmp    802f57 <copy_data+0x34>
  802f40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f46:	01 c2                	add    %eax,%edx
  802f48:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	01 c8                	add    %ecx,%eax
  802f50:	8a 00                	mov    (%eax),%al
  802f52:	88 02                	mov    %al,(%edx)
  802f54:	ff 45 fc             	incl   -0x4(%ebp)
  802f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802f5d:	72 e1                	jb     802f40 <copy_data+0x1d>
}
  802f5f:	90                   	nop
  802f60:	c9                   	leave  
  802f61:	c3                   	ret    

00802f62 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802f62:	55                   	push   %ebp
  802f63:	89 e5                	mov    %esp,%ebp
  802f65:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802f68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6c:	75 23                	jne    802f91 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802f6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f72:	74 13                	je     802f87 <realloc_block_FF+0x25>
  802f74:	83 ec 0c             	sub    $0xc,%esp
  802f77:	ff 75 0c             	pushl  0xc(%ebp)
  802f7a:	e8 42 f0 ff ff       	call   801fc1 <alloc_block_FF>
  802f7f:	83 c4 10             	add    $0x10,%esp
  802f82:	e9 e4 06 00 00       	jmp    80366b <realloc_block_FF+0x709>
		return NULL;
  802f87:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8c:	e9 da 06 00 00       	jmp    80366b <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  802f91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f95:	75 18                	jne    802faf <realloc_block_FF+0x4d>
	{
		free_block(va);
  802f97:	83 ec 0c             	sub    $0xc,%esp
  802f9a:	ff 75 08             	pushl  0x8(%ebp)
  802f9d:	e8 c0 fe ff ff       	call   802e62 <free_block>
  802fa2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  802faa:	e9 bc 06 00 00       	jmp    80366b <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  802faf:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802fb3:	77 07                	ja     802fbc <realloc_block_FF+0x5a>
  802fb5:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbf:	83 e0 01             	and    $0x1,%eax
  802fc2:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc8:	83 c0 08             	add    $0x8,%eax
  802fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  802fce:	83 ec 0c             	sub    $0xc,%esp
  802fd1:	ff 75 08             	pushl  0x8(%ebp)
  802fd4:	e8 68 ec ff ff       	call   801c41 <get_block_size>
  802fd9:	83 c4 10             	add    $0x10,%esp
  802fdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe2:	83 e8 08             	sub    $0x8,%eax
  802fe5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	83 e8 04             	sub    $0x4,%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	83 e0 fe             	and    $0xfffffffe,%eax
  802ff3:	89 c2                	mov    %eax,%edx
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	01 d0                	add    %edx,%eax
  802ffa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  802ffd:	83 ec 0c             	sub    $0xc,%esp
  803000:	ff 75 e4             	pushl  -0x1c(%ebp)
  803003:	e8 39 ec ff ff       	call   801c41 <get_block_size>
  803008:	83 c4 10             	add    $0x10,%esp
  80300b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80300e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803011:	83 e8 08             	sub    $0x8,%eax
  803014:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80301a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80301d:	75 08                	jne    803027 <realloc_block_FF+0xc5>
	{
		 return va;
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	e9 44 06 00 00       	jmp    80366b <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  803027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80302d:	0f 83 d5 03 00 00    	jae    803408 <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803033:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803036:	2b 45 0c             	sub    0xc(%ebp),%eax
  803039:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80303c:	83 ec 0c             	sub    $0xc,%esp
  80303f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803042:	e8 13 ec ff ff       	call   801c5a <is_free_block>
  803047:	83 c4 10             	add    $0x10,%esp
  80304a:	84 c0                	test   %al,%al
  80304c:	0f 84 3b 01 00 00    	je     80318d <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803052:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803055:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803058:	01 d0                	add    %edx,%eax
  80305a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80305d:	83 ec 04             	sub    $0x4,%esp
  803060:	6a 01                	push   $0x1
  803062:	ff 75 f0             	pushl  -0x10(%ebp)
  803065:	ff 75 08             	pushl  0x8(%ebp)
  803068:	e8 25 ef ff ff       	call   801f92 <set_block_data>
  80306d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	83 e8 04             	sub    $0x4,%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	83 e0 fe             	and    $0xfffffffe,%eax
  80307b:	89 c2                	mov    %eax,%edx
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	01 d0                	add    %edx,%eax
  803082:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803085:	83 ec 04             	sub    $0x4,%esp
  803088:	6a 00                	push   $0x0
  80308a:	ff 75 cc             	pushl  -0x34(%ebp)
  80308d:	ff 75 c8             	pushl  -0x38(%ebp)
  803090:	e8 fd ee ff ff       	call   801f92 <set_block_data>
  803095:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803098:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80309c:	74 06                	je     8030a4 <realloc_block_FF+0x142>
  80309e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8030a2:	75 17                	jne    8030bb <realloc_block_FF+0x159>
  8030a4:	83 ec 04             	sub    $0x4,%esp
  8030a7:	68 54 41 80 00       	push   $0x804154
  8030ac:	68 f6 01 00 00       	push   $0x1f6
  8030b1:	68 e1 40 80 00       	push   $0x8040e1
  8030b6:	e8 ec 05 00 00       	call   8036a7 <_panic>
  8030bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030be:	8b 10                	mov    (%eax),%edx
  8030c0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030c3:	89 10                	mov    %edx,(%eax)
  8030c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	85 c0                	test   %eax,%eax
  8030cc:	74 0b                	je     8030d9 <realloc_block_FF+0x177>
  8030ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d1:	8b 00                	mov    (%eax),%eax
  8030d3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030d6:	89 50 04             	mov    %edx,0x4(%eax)
  8030d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030dc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030df:	89 10                	mov    %edx,(%eax)
  8030e1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030e7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ea:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030ed:	8b 00                	mov    (%eax),%eax
  8030ef:	85 c0                	test   %eax,%eax
  8030f1:	75 08                	jne    8030fb <realloc_block_FF+0x199>
  8030f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030f6:	a3 30 50 80 00       	mov    %eax,0x805030
  8030fb:	a1 38 50 80 00       	mov    0x805038,%eax
  803100:	40                   	inc    %eax
  803101:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803106:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80310a:	75 17                	jne    803123 <realloc_block_FF+0x1c1>
  80310c:	83 ec 04             	sub    $0x4,%esp
  80310f:	68 c3 40 80 00       	push   $0x8040c3
  803114:	68 f7 01 00 00       	push   $0x1f7
  803119:	68 e1 40 80 00       	push   $0x8040e1
  80311e:	e8 84 05 00 00       	call   8036a7 <_panic>
  803123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	74 10                	je     80313c <realloc_block_FF+0x1da>
  80312c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803134:	8b 52 04             	mov    0x4(%edx),%edx
  803137:	89 50 04             	mov    %edx,0x4(%eax)
  80313a:	eb 0b                	jmp    803147 <realloc_block_FF+0x1e5>
  80313c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313f:	8b 40 04             	mov    0x4(%eax),%eax
  803142:	a3 30 50 80 00       	mov    %eax,0x805030
  803147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314a:	8b 40 04             	mov    0x4(%eax),%eax
  80314d:	85 c0                	test   %eax,%eax
  80314f:	74 0f                	je     803160 <realloc_block_FF+0x1fe>
  803151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803154:	8b 40 04             	mov    0x4(%eax),%eax
  803157:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80315a:	8b 12                	mov    (%edx),%edx
  80315c:	89 10                	mov    %edx,(%eax)
  80315e:	eb 0a                	jmp    80316a <realloc_block_FF+0x208>
  803160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80316a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803176:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317d:	a1 38 50 80 00       	mov    0x805038,%eax
  803182:	48                   	dec    %eax
  803183:	a3 38 50 80 00       	mov    %eax,0x805038
  803188:	e9 73 02 00 00       	jmp    803400 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  80318d:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803191:	0f 86 69 02 00 00    	jbe    803400 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803197:	83 ec 04             	sub    $0x4,%esp
  80319a:	6a 01                	push   $0x1
  80319c:	ff 75 f0             	pushl  -0x10(%ebp)
  80319f:	ff 75 08             	pushl  0x8(%ebp)
  8031a2:	e8 eb ed ff ff       	call   801f92 <set_block_data>
  8031a7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	83 e8 04             	sub    $0x4,%eax
  8031b0:	8b 00                	mov    (%eax),%eax
  8031b2:	83 e0 fe             	and    $0xfffffffe,%eax
  8031b5:	89 c2                	mov    %eax,%edx
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	01 d0                	add    %edx,%eax
  8031bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8031bf:	a1 38 50 80 00       	mov    0x805038,%eax
  8031c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8031c7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8031cb:	75 68                	jne    803235 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8031cd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031d1:	75 17                	jne    8031ea <realloc_block_FF+0x288>
  8031d3:	83 ec 04             	sub    $0x4,%esp
  8031d6:	68 fc 40 80 00       	push   $0x8040fc
  8031db:	68 06 02 00 00       	push   $0x206
  8031e0:	68 e1 40 80 00       	push   $0x8040e1
  8031e5:	e8 bd 04 00 00       	call   8036a7 <_panic>
  8031ea:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031f3:	89 10                	mov    %edx,(%eax)
  8031f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	85 c0                	test   %eax,%eax
  8031fc:	74 0d                	je     80320b <realloc_block_FF+0x2a9>
  8031fe:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803203:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803206:	89 50 04             	mov    %edx,0x4(%eax)
  803209:	eb 08                	jmp    803213 <realloc_block_FF+0x2b1>
  80320b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80320e:	a3 30 50 80 00       	mov    %eax,0x805030
  803213:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803216:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80321b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80321e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803225:	a1 38 50 80 00       	mov    0x805038,%eax
  80322a:	40                   	inc    %eax
  80322b:	a3 38 50 80 00       	mov    %eax,0x805038
  803230:	e9 b0 01 00 00       	jmp    8033e5 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803235:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80323a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80323d:	76 68                	jbe    8032a7 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80323f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803243:	75 17                	jne    80325c <realloc_block_FF+0x2fa>
  803245:	83 ec 04             	sub    $0x4,%esp
  803248:	68 fc 40 80 00       	push   $0x8040fc
  80324d:	68 0b 02 00 00       	push   $0x20b
  803252:	68 e1 40 80 00       	push   $0x8040e1
  803257:	e8 4b 04 00 00       	call   8036a7 <_panic>
  80325c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803262:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803265:	89 10                	mov    %edx,(%eax)
  803267:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80326a:	8b 00                	mov    (%eax),%eax
  80326c:	85 c0                	test   %eax,%eax
  80326e:	74 0d                	je     80327d <realloc_block_FF+0x31b>
  803270:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803275:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803278:	89 50 04             	mov    %edx,0x4(%eax)
  80327b:	eb 08                	jmp    803285 <realloc_block_FF+0x323>
  80327d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803280:	a3 30 50 80 00       	mov    %eax,0x805030
  803285:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803288:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80328d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803290:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803297:	a1 38 50 80 00       	mov    0x805038,%eax
  80329c:	40                   	inc    %eax
  80329d:	a3 38 50 80 00       	mov    %eax,0x805038
  8032a2:	e9 3e 01 00 00       	jmp    8033e5 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8032a7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ac:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032af:	73 68                	jae    803319 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032b1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032b5:	75 17                	jne    8032ce <realloc_block_FF+0x36c>
  8032b7:	83 ec 04             	sub    $0x4,%esp
  8032ba:	68 30 41 80 00       	push   $0x804130
  8032bf:	68 10 02 00 00       	push   $0x210
  8032c4:	68 e1 40 80 00       	push   $0x8040e1
  8032c9:	e8 d9 03 00 00       	call   8036a7 <_panic>
  8032ce:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d7:	89 50 04             	mov    %edx,0x4(%eax)
  8032da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032dd:	8b 40 04             	mov    0x4(%eax),%eax
  8032e0:	85 c0                	test   %eax,%eax
  8032e2:	74 0c                	je     8032f0 <realloc_block_FF+0x38e>
  8032e4:	a1 30 50 80 00       	mov    0x805030,%eax
  8032e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032ec:	89 10                	mov    %edx,(%eax)
  8032ee:	eb 08                	jmp    8032f8 <realloc_block_FF+0x396>
  8032f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032fb:	a3 30 50 80 00       	mov    %eax,0x805030
  803300:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803303:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803309:	a1 38 50 80 00       	mov    0x805038,%eax
  80330e:	40                   	inc    %eax
  80330f:	a3 38 50 80 00       	mov    %eax,0x805038
  803314:	e9 cc 00 00 00       	jmp    8033e5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803319:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803320:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803325:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803328:	e9 8a 00 00 00       	jmp    8033b7 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80332d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803330:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803333:	73 7a                	jae    8033af <realloc_block_FF+0x44d>
  803335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803338:	8b 00                	mov    (%eax),%eax
  80333a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80333d:	73 70                	jae    8033af <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80333f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803343:	74 06                	je     80334b <realloc_block_FF+0x3e9>
  803345:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803349:	75 17                	jne    803362 <realloc_block_FF+0x400>
  80334b:	83 ec 04             	sub    $0x4,%esp
  80334e:	68 54 41 80 00       	push   $0x804154
  803353:	68 1a 02 00 00       	push   $0x21a
  803358:	68 e1 40 80 00       	push   $0x8040e1
  80335d:	e8 45 03 00 00       	call   8036a7 <_panic>
  803362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803365:	8b 10                	mov    (%eax),%edx
  803367:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336a:	89 10                	mov    %edx,(%eax)
  80336c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336f:	8b 00                	mov    (%eax),%eax
  803371:	85 c0                	test   %eax,%eax
  803373:	74 0b                	je     803380 <realloc_block_FF+0x41e>
  803375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803378:	8b 00                	mov    (%eax),%eax
  80337a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80337d:	89 50 04             	mov    %edx,0x4(%eax)
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803386:	89 10                	mov    %edx,(%eax)
  803388:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80338b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80338e:	89 50 04             	mov    %edx,0x4(%eax)
  803391:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803394:	8b 00                	mov    (%eax),%eax
  803396:	85 c0                	test   %eax,%eax
  803398:	75 08                	jne    8033a2 <realloc_block_FF+0x440>
  80339a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339d:	a3 30 50 80 00       	mov    %eax,0x805030
  8033a2:	a1 38 50 80 00       	mov    0x805038,%eax
  8033a7:	40                   	inc    %eax
  8033a8:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8033ad:	eb 36                	jmp    8033e5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8033af:	a1 34 50 80 00       	mov    0x805034,%eax
  8033b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033bb:	74 07                	je     8033c4 <realloc_block_FF+0x462>
  8033bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c0:	8b 00                	mov    (%eax),%eax
  8033c2:	eb 05                	jmp    8033c9 <realloc_block_FF+0x467>
  8033c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c9:	a3 34 50 80 00       	mov    %eax,0x805034
  8033ce:	a1 34 50 80 00       	mov    0x805034,%eax
  8033d3:	85 c0                	test   %eax,%eax
  8033d5:	0f 85 52 ff ff ff    	jne    80332d <realloc_block_FF+0x3cb>
  8033db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033df:	0f 85 48 ff ff ff    	jne    80332d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8033e5:	83 ec 04             	sub    $0x4,%esp
  8033e8:	6a 00                	push   $0x0
  8033ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8033ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033f0:	e8 9d eb ff ff       	call   801f92 <set_block_data>
  8033f5:	83 c4 10             	add    $0x10,%esp
				return va;
  8033f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fb:	e9 6b 02 00 00       	jmp    80366b <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	e9 63 02 00 00       	jmp    80366b <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  803408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80340b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80340e:	0f 86 4d 02 00 00    	jbe    803661 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803414:	83 ec 0c             	sub    $0xc,%esp
  803417:	ff 75 e4             	pushl  -0x1c(%ebp)
  80341a:	e8 3b e8 ff ff       	call   801c5a <is_free_block>
  80341f:	83 c4 10             	add    $0x10,%esp
  803422:	84 c0                	test   %al,%al
  803424:	0f 84 37 02 00 00    	je     803661 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80342a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80342d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803430:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803433:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803436:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803439:	76 38                	jbe    803473 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80343b:	83 ec 0c             	sub    $0xc,%esp
  80343e:	ff 75 0c             	pushl  0xc(%ebp)
  803441:	e8 7b eb ff ff       	call   801fc1 <alloc_block_FF>
  803446:	83 c4 10             	add    $0x10,%esp
  803449:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80344c:	83 ec 08             	sub    $0x8,%esp
  80344f:	ff 75 c0             	pushl  -0x40(%ebp)
  803452:	ff 75 08             	pushl  0x8(%ebp)
  803455:	e8 c9 fa ff ff       	call   802f23 <copy_data>
  80345a:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  80345d:	83 ec 0c             	sub    $0xc,%esp
  803460:	ff 75 08             	pushl  0x8(%ebp)
  803463:	e8 fa f9 ff ff       	call   802e62 <free_block>
  803468:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80346b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80346e:	e9 f8 01 00 00       	jmp    80366b <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803473:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803476:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803479:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80347c:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803480:	0f 87 a0 00 00 00    	ja     803526 <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803486:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80348a:	75 17                	jne    8034a3 <realloc_block_FF+0x541>
  80348c:	83 ec 04             	sub    $0x4,%esp
  80348f:	68 c3 40 80 00       	push   $0x8040c3
  803494:	68 38 02 00 00       	push   $0x238
  803499:	68 e1 40 80 00       	push   $0x8040e1
  80349e:	e8 04 02 00 00       	call   8036a7 <_panic>
  8034a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a6:	8b 00                	mov    (%eax),%eax
  8034a8:	85 c0                	test   %eax,%eax
  8034aa:	74 10                	je     8034bc <realloc_block_FF+0x55a>
  8034ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034b4:	8b 52 04             	mov    0x4(%edx),%edx
  8034b7:	89 50 04             	mov    %edx,0x4(%eax)
  8034ba:	eb 0b                	jmp    8034c7 <realloc_block_FF+0x565>
  8034bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bf:	8b 40 04             	mov    0x4(%eax),%eax
  8034c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8034c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ca:	8b 40 04             	mov    0x4(%eax),%eax
  8034cd:	85 c0                	test   %eax,%eax
  8034cf:	74 0f                	je     8034e0 <realloc_block_FF+0x57e>
  8034d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d4:	8b 40 04             	mov    0x4(%eax),%eax
  8034d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034da:	8b 12                	mov    (%edx),%edx
  8034dc:	89 10                	mov    %edx,(%eax)
  8034de:	eb 0a                	jmp    8034ea <realloc_block_FF+0x588>
  8034e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e3:	8b 00                	mov    (%eax),%eax
  8034e5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803502:	48                   	dec    %eax
  803503:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803508:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80350b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80350e:	01 d0                	add    %edx,%eax
  803510:	83 ec 04             	sub    $0x4,%esp
  803513:	6a 01                	push   $0x1
  803515:	50                   	push   %eax
  803516:	ff 75 08             	pushl  0x8(%ebp)
  803519:	e8 74 ea ff ff       	call   801f92 <set_block_data>
  80351e:	83 c4 10             	add    $0x10,%esp
  803521:	e9 36 01 00 00       	jmp    80365c <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803526:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803529:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80352c:	01 d0                	add    %edx,%eax
  80352e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803531:	83 ec 04             	sub    $0x4,%esp
  803534:	6a 01                	push   $0x1
  803536:	ff 75 f0             	pushl  -0x10(%ebp)
  803539:	ff 75 08             	pushl  0x8(%ebp)
  80353c:	e8 51 ea ff ff       	call   801f92 <set_block_data>
  803541:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	83 e8 04             	sub    $0x4,%eax
  80354a:	8b 00                	mov    (%eax),%eax
  80354c:	83 e0 fe             	and    $0xfffffffe,%eax
  80354f:	89 c2                	mov    %eax,%edx
  803551:	8b 45 08             	mov    0x8(%ebp),%eax
  803554:	01 d0                	add    %edx,%eax
  803556:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803559:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80355d:	74 06                	je     803565 <realloc_block_FF+0x603>
  80355f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803563:	75 17                	jne    80357c <realloc_block_FF+0x61a>
  803565:	83 ec 04             	sub    $0x4,%esp
  803568:	68 54 41 80 00       	push   $0x804154
  80356d:	68 44 02 00 00       	push   $0x244
  803572:	68 e1 40 80 00       	push   $0x8040e1
  803577:	e8 2b 01 00 00       	call   8036a7 <_panic>
  80357c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357f:	8b 10                	mov    (%eax),%edx
  803581:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803584:	89 10                	mov    %edx,(%eax)
  803586:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803589:	8b 00                	mov    (%eax),%eax
  80358b:	85 c0                	test   %eax,%eax
  80358d:	74 0b                	je     80359a <realloc_block_FF+0x638>
  80358f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803592:	8b 00                	mov    (%eax),%eax
  803594:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803597:	89 50 04             	mov    %edx,0x4(%eax)
  80359a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035a0:	89 10                	mov    %edx,(%eax)
  8035a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a8:	89 50 04             	mov    %edx,0x4(%eax)
  8035ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035ae:	8b 00                	mov    (%eax),%eax
  8035b0:	85 c0                	test   %eax,%eax
  8035b2:	75 08                	jne    8035bc <realloc_block_FF+0x65a>
  8035b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8035bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8035c1:	40                   	inc    %eax
  8035c2:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035cb:	75 17                	jne    8035e4 <realloc_block_FF+0x682>
  8035cd:	83 ec 04             	sub    $0x4,%esp
  8035d0:	68 c3 40 80 00       	push   $0x8040c3
  8035d5:	68 45 02 00 00       	push   $0x245
  8035da:	68 e1 40 80 00       	push   $0x8040e1
  8035df:	e8 c3 00 00 00       	call   8036a7 <_panic>
  8035e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e7:	8b 00                	mov    (%eax),%eax
  8035e9:	85 c0                	test   %eax,%eax
  8035eb:	74 10                	je     8035fd <realloc_block_FF+0x69b>
  8035ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f0:	8b 00                	mov    (%eax),%eax
  8035f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f5:	8b 52 04             	mov    0x4(%edx),%edx
  8035f8:	89 50 04             	mov    %edx,0x4(%eax)
  8035fb:	eb 0b                	jmp    803608 <realloc_block_FF+0x6a6>
  8035fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803600:	8b 40 04             	mov    0x4(%eax),%eax
  803603:	a3 30 50 80 00       	mov    %eax,0x805030
  803608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360b:	8b 40 04             	mov    0x4(%eax),%eax
  80360e:	85 c0                	test   %eax,%eax
  803610:	74 0f                	je     803621 <realloc_block_FF+0x6bf>
  803612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803615:	8b 40 04             	mov    0x4(%eax),%eax
  803618:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80361b:	8b 12                	mov    (%edx),%edx
  80361d:	89 10                	mov    %edx,(%eax)
  80361f:	eb 0a                	jmp    80362b <realloc_block_FF+0x6c9>
  803621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803624:	8b 00                	mov    (%eax),%eax
  803626:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80362b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803634:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803637:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363e:	a1 38 50 80 00       	mov    0x805038,%eax
  803643:	48                   	dec    %eax
  803644:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803649:	83 ec 04             	sub    $0x4,%esp
  80364c:	6a 00                	push   $0x0
  80364e:	ff 75 bc             	pushl  -0x44(%ebp)
  803651:	ff 75 b8             	pushl  -0x48(%ebp)
  803654:	e8 39 e9 ff ff       	call   801f92 <set_block_data>
  803659:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	eb 0a                	jmp    80366b <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803661:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80366b:	c9                   	leave  
  80366c:	c3                   	ret    

0080366d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80366d:	55                   	push   %ebp
  80366e:	89 e5                	mov    %esp,%ebp
  803670:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803673:	83 ec 04             	sub    $0x4,%esp
  803676:	68 c0 41 80 00       	push   $0x8041c0
  80367b:	68 58 02 00 00       	push   $0x258
  803680:	68 e1 40 80 00       	push   $0x8040e1
  803685:	e8 1d 00 00 00       	call   8036a7 <_panic>

0080368a <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80368a:	55                   	push   %ebp
  80368b:	89 e5                	mov    %esp,%ebp
  80368d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803690:	83 ec 04             	sub    $0x4,%esp
  803693:	68 e8 41 80 00       	push   $0x8041e8
  803698:	68 61 02 00 00       	push   $0x261
  80369d:	68 e1 40 80 00       	push   $0x8040e1
  8036a2:	e8 00 00 00 00       	call   8036a7 <_panic>

008036a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8036a7:	55                   	push   %ebp
  8036a8:	89 e5                	mov    %esp,%ebp
  8036aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8036ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8036b0:	83 c0 04             	add    $0x4,%eax
  8036b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8036b6:	a1 60 50 98 00       	mov    0x985060,%eax
  8036bb:	85 c0                	test   %eax,%eax
  8036bd:	74 16                	je     8036d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8036bf:	a1 60 50 98 00       	mov    0x985060,%eax
  8036c4:	83 ec 08             	sub    $0x8,%esp
  8036c7:	50                   	push   %eax
  8036c8:	68 10 42 80 00       	push   $0x804210
  8036cd:	e8 79 cc ff ff       	call   80034b <cprintf>
  8036d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8036d5:	a1 00 50 80 00       	mov    0x805000,%eax
  8036da:	ff 75 0c             	pushl  0xc(%ebp)
  8036dd:	ff 75 08             	pushl  0x8(%ebp)
  8036e0:	50                   	push   %eax
  8036e1:	68 15 42 80 00       	push   $0x804215
  8036e6:	e8 60 cc ff ff       	call   80034b <cprintf>
  8036eb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8036ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8036f1:	83 ec 08             	sub    $0x8,%esp
  8036f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8036f7:	50                   	push   %eax
  8036f8:	e8 e3 cb ff ff       	call   8002e0 <vcprintf>
  8036fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803700:	83 ec 08             	sub    $0x8,%esp
  803703:	6a 00                	push   $0x0
  803705:	68 31 42 80 00       	push   $0x804231
  80370a:	e8 d1 cb ff ff       	call   8002e0 <vcprintf>
  80370f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803712:	e8 52 cb ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  803717:	eb fe                	jmp    803717 <_panic+0x70>

00803719 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803719:	55                   	push   %ebp
  80371a:	89 e5                	mov    %esp,%ebp
  80371c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80371f:	a1 20 50 80 00       	mov    0x805020,%eax
  803724:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80372a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80372d:	39 c2                	cmp    %eax,%edx
  80372f:	74 14                	je     803745 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803731:	83 ec 04             	sub    $0x4,%esp
  803734:	68 34 42 80 00       	push   $0x804234
  803739:	6a 26                	push   $0x26
  80373b:	68 80 42 80 00       	push   $0x804280
  803740:	e8 62 ff ff ff       	call   8036a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803745:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80374c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803753:	e9 c5 00 00 00       	jmp    80381d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803762:	8b 45 08             	mov    0x8(%ebp),%eax
  803765:	01 d0                	add    %edx,%eax
  803767:	8b 00                	mov    (%eax),%eax
  803769:	85 c0                	test   %eax,%eax
  80376b:	75 08                	jne    803775 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80376d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803770:	e9 a5 00 00 00       	jmp    80381a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803775:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80377c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803783:	eb 69                	jmp    8037ee <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803785:	a1 20 50 80 00       	mov    0x805020,%eax
  80378a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803790:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803793:	89 d0                	mov    %edx,%eax
  803795:	01 c0                	add    %eax,%eax
  803797:	01 d0                	add    %edx,%eax
  803799:	c1 e0 03             	shl    $0x3,%eax
  80379c:	01 c8                	add    %ecx,%eax
  80379e:	8a 40 04             	mov    0x4(%eax),%al
  8037a1:	84 c0                	test   %al,%al
  8037a3:	75 46                	jne    8037eb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8037a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8037aa:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8037b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037b3:	89 d0                	mov    %edx,%eax
  8037b5:	01 c0                	add    %eax,%eax
  8037b7:	01 d0                	add    %edx,%eax
  8037b9:	c1 e0 03             	shl    $0x3,%eax
  8037bc:	01 c8                	add    %ecx,%eax
  8037be:	8b 00                	mov    (%eax),%eax
  8037c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8037c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8037c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8037cb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8037cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8037d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037da:	01 c8                	add    %ecx,%eax
  8037dc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8037de:	39 c2                	cmp    %eax,%edx
  8037e0:	75 09                	jne    8037eb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8037e2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8037e9:	eb 15                	jmp    803800 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037eb:	ff 45 e8             	incl   -0x18(%ebp)
  8037ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8037f3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8037f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fc:	39 c2                	cmp    %eax,%edx
  8037fe:	77 85                	ja     803785 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803800:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803804:	75 14                	jne    80381a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803806:	83 ec 04             	sub    $0x4,%esp
  803809:	68 8c 42 80 00       	push   $0x80428c
  80380e:	6a 3a                	push   $0x3a
  803810:	68 80 42 80 00       	push   $0x804280
  803815:	e8 8d fe ff ff       	call   8036a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80381a:	ff 45 f0             	incl   -0x10(%ebp)
  80381d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803820:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803823:	0f 8c 2f ff ff ff    	jl     803758 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803829:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803830:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803837:	eb 26                	jmp    80385f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803839:	a1 20 50 80 00       	mov    0x805020,%eax
  80383e:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803844:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803847:	89 d0                	mov    %edx,%eax
  803849:	01 c0                	add    %eax,%eax
  80384b:	01 d0                	add    %edx,%eax
  80384d:	c1 e0 03             	shl    $0x3,%eax
  803850:	01 c8                	add    %ecx,%eax
  803852:	8a 40 04             	mov    0x4(%eax),%al
  803855:	3c 01                	cmp    $0x1,%al
  803857:	75 03                	jne    80385c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803859:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80385c:	ff 45 e0             	incl   -0x20(%ebp)
  80385f:	a1 20 50 80 00       	mov    0x805020,%eax
  803864:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80386a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80386d:	39 c2                	cmp    %eax,%edx
  80386f:	77 c8                	ja     803839 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803874:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803877:	74 14                	je     80388d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803879:	83 ec 04             	sub    $0x4,%esp
  80387c:	68 e0 42 80 00       	push   $0x8042e0
  803881:	6a 44                	push   $0x44
  803883:	68 80 42 80 00       	push   $0x804280
  803888:	e8 1a fe ff ff       	call   8036a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80388d:	90                   	nop
  80388e:	c9                   	leave  
  80388f:	c3                   	ret    

00803890 <__udivdi3>:
  803890:	55                   	push   %ebp
  803891:	57                   	push   %edi
  803892:	56                   	push   %esi
  803893:	53                   	push   %ebx
  803894:	83 ec 1c             	sub    $0x1c,%esp
  803897:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80389b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80389f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038a7:	89 ca                	mov    %ecx,%edx
  8038a9:	89 f8                	mov    %edi,%eax
  8038ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038af:	85 f6                	test   %esi,%esi
  8038b1:	75 2d                	jne    8038e0 <__udivdi3+0x50>
  8038b3:	39 cf                	cmp    %ecx,%edi
  8038b5:	77 65                	ja     80391c <__udivdi3+0x8c>
  8038b7:	89 fd                	mov    %edi,%ebp
  8038b9:	85 ff                	test   %edi,%edi
  8038bb:	75 0b                	jne    8038c8 <__udivdi3+0x38>
  8038bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c2:	31 d2                	xor    %edx,%edx
  8038c4:	f7 f7                	div    %edi
  8038c6:	89 c5                	mov    %eax,%ebp
  8038c8:	31 d2                	xor    %edx,%edx
  8038ca:	89 c8                	mov    %ecx,%eax
  8038cc:	f7 f5                	div    %ebp
  8038ce:	89 c1                	mov    %eax,%ecx
  8038d0:	89 d8                	mov    %ebx,%eax
  8038d2:	f7 f5                	div    %ebp
  8038d4:	89 cf                	mov    %ecx,%edi
  8038d6:	89 fa                	mov    %edi,%edx
  8038d8:	83 c4 1c             	add    $0x1c,%esp
  8038db:	5b                   	pop    %ebx
  8038dc:	5e                   	pop    %esi
  8038dd:	5f                   	pop    %edi
  8038de:	5d                   	pop    %ebp
  8038df:	c3                   	ret    
  8038e0:	39 ce                	cmp    %ecx,%esi
  8038e2:	77 28                	ja     80390c <__udivdi3+0x7c>
  8038e4:	0f bd fe             	bsr    %esi,%edi
  8038e7:	83 f7 1f             	xor    $0x1f,%edi
  8038ea:	75 40                	jne    80392c <__udivdi3+0x9c>
  8038ec:	39 ce                	cmp    %ecx,%esi
  8038ee:	72 0a                	jb     8038fa <__udivdi3+0x6a>
  8038f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038f4:	0f 87 9e 00 00 00    	ja     803998 <__udivdi3+0x108>
  8038fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8038ff:	89 fa                	mov    %edi,%edx
  803901:	83 c4 1c             	add    $0x1c,%esp
  803904:	5b                   	pop    %ebx
  803905:	5e                   	pop    %esi
  803906:	5f                   	pop    %edi
  803907:	5d                   	pop    %ebp
  803908:	c3                   	ret    
  803909:	8d 76 00             	lea    0x0(%esi),%esi
  80390c:	31 ff                	xor    %edi,%edi
  80390e:	31 c0                	xor    %eax,%eax
  803910:	89 fa                	mov    %edi,%edx
  803912:	83 c4 1c             	add    $0x1c,%esp
  803915:	5b                   	pop    %ebx
  803916:	5e                   	pop    %esi
  803917:	5f                   	pop    %edi
  803918:	5d                   	pop    %ebp
  803919:	c3                   	ret    
  80391a:	66 90                	xchg   %ax,%ax
  80391c:	89 d8                	mov    %ebx,%eax
  80391e:	f7 f7                	div    %edi
  803920:	31 ff                	xor    %edi,%edi
  803922:	89 fa                	mov    %edi,%edx
  803924:	83 c4 1c             	add    $0x1c,%esp
  803927:	5b                   	pop    %ebx
  803928:	5e                   	pop    %esi
  803929:	5f                   	pop    %edi
  80392a:	5d                   	pop    %ebp
  80392b:	c3                   	ret    
  80392c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803931:	89 eb                	mov    %ebp,%ebx
  803933:	29 fb                	sub    %edi,%ebx
  803935:	89 f9                	mov    %edi,%ecx
  803937:	d3 e6                	shl    %cl,%esi
  803939:	89 c5                	mov    %eax,%ebp
  80393b:	88 d9                	mov    %bl,%cl
  80393d:	d3 ed                	shr    %cl,%ebp
  80393f:	89 e9                	mov    %ebp,%ecx
  803941:	09 f1                	or     %esi,%ecx
  803943:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803947:	89 f9                	mov    %edi,%ecx
  803949:	d3 e0                	shl    %cl,%eax
  80394b:	89 c5                	mov    %eax,%ebp
  80394d:	89 d6                	mov    %edx,%esi
  80394f:	88 d9                	mov    %bl,%cl
  803951:	d3 ee                	shr    %cl,%esi
  803953:	89 f9                	mov    %edi,%ecx
  803955:	d3 e2                	shl    %cl,%edx
  803957:	8b 44 24 08          	mov    0x8(%esp),%eax
  80395b:	88 d9                	mov    %bl,%cl
  80395d:	d3 e8                	shr    %cl,%eax
  80395f:	09 c2                	or     %eax,%edx
  803961:	89 d0                	mov    %edx,%eax
  803963:	89 f2                	mov    %esi,%edx
  803965:	f7 74 24 0c          	divl   0xc(%esp)
  803969:	89 d6                	mov    %edx,%esi
  80396b:	89 c3                	mov    %eax,%ebx
  80396d:	f7 e5                	mul    %ebp
  80396f:	39 d6                	cmp    %edx,%esi
  803971:	72 19                	jb     80398c <__udivdi3+0xfc>
  803973:	74 0b                	je     803980 <__udivdi3+0xf0>
  803975:	89 d8                	mov    %ebx,%eax
  803977:	31 ff                	xor    %edi,%edi
  803979:	e9 58 ff ff ff       	jmp    8038d6 <__udivdi3+0x46>
  80397e:	66 90                	xchg   %ax,%ax
  803980:	8b 54 24 08          	mov    0x8(%esp),%edx
  803984:	89 f9                	mov    %edi,%ecx
  803986:	d3 e2                	shl    %cl,%edx
  803988:	39 c2                	cmp    %eax,%edx
  80398a:	73 e9                	jae    803975 <__udivdi3+0xe5>
  80398c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80398f:	31 ff                	xor    %edi,%edi
  803991:	e9 40 ff ff ff       	jmp    8038d6 <__udivdi3+0x46>
  803996:	66 90                	xchg   %ax,%ax
  803998:	31 c0                	xor    %eax,%eax
  80399a:	e9 37 ff ff ff       	jmp    8038d6 <__udivdi3+0x46>
  80399f:	90                   	nop

008039a0 <__umoddi3>:
  8039a0:	55                   	push   %ebp
  8039a1:	57                   	push   %edi
  8039a2:	56                   	push   %esi
  8039a3:	53                   	push   %ebx
  8039a4:	83 ec 1c             	sub    $0x1c,%esp
  8039a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039bf:	89 f3                	mov    %esi,%ebx
  8039c1:	89 fa                	mov    %edi,%edx
  8039c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039c7:	89 34 24             	mov    %esi,(%esp)
  8039ca:	85 c0                	test   %eax,%eax
  8039cc:	75 1a                	jne    8039e8 <__umoddi3+0x48>
  8039ce:	39 f7                	cmp    %esi,%edi
  8039d0:	0f 86 a2 00 00 00    	jbe    803a78 <__umoddi3+0xd8>
  8039d6:	89 c8                	mov    %ecx,%eax
  8039d8:	89 f2                	mov    %esi,%edx
  8039da:	f7 f7                	div    %edi
  8039dc:	89 d0                	mov    %edx,%eax
  8039de:	31 d2                	xor    %edx,%edx
  8039e0:	83 c4 1c             	add    $0x1c,%esp
  8039e3:	5b                   	pop    %ebx
  8039e4:	5e                   	pop    %esi
  8039e5:	5f                   	pop    %edi
  8039e6:	5d                   	pop    %ebp
  8039e7:	c3                   	ret    
  8039e8:	39 f0                	cmp    %esi,%eax
  8039ea:	0f 87 ac 00 00 00    	ja     803a9c <__umoddi3+0xfc>
  8039f0:	0f bd e8             	bsr    %eax,%ebp
  8039f3:	83 f5 1f             	xor    $0x1f,%ebp
  8039f6:	0f 84 ac 00 00 00    	je     803aa8 <__umoddi3+0x108>
  8039fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803a01:	29 ef                	sub    %ebp,%edi
  803a03:	89 fe                	mov    %edi,%esi
  803a05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a09:	89 e9                	mov    %ebp,%ecx
  803a0b:	d3 e0                	shl    %cl,%eax
  803a0d:	89 d7                	mov    %edx,%edi
  803a0f:	89 f1                	mov    %esi,%ecx
  803a11:	d3 ef                	shr    %cl,%edi
  803a13:	09 c7                	or     %eax,%edi
  803a15:	89 e9                	mov    %ebp,%ecx
  803a17:	d3 e2                	shl    %cl,%edx
  803a19:	89 14 24             	mov    %edx,(%esp)
  803a1c:	89 d8                	mov    %ebx,%eax
  803a1e:	d3 e0                	shl    %cl,%eax
  803a20:	89 c2                	mov    %eax,%edx
  803a22:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a26:	d3 e0                	shl    %cl,%eax
  803a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a30:	89 f1                	mov    %esi,%ecx
  803a32:	d3 e8                	shr    %cl,%eax
  803a34:	09 d0                	or     %edx,%eax
  803a36:	d3 eb                	shr    %cl,%ebx
  803a38:	89 da                	mov    %ebx,%edx
  803a3a:	f7 f7                	div    %edi
  803a3c:	89 d3                	mov    %edx,%ebx
  803a3e:	f7 24 24             	mull   (%esp)
  803a41:	89 c6                	mov    %eax,%esi
  803a43:	89 d1                	mov    %edx,%ecx
  803a45:	39 d3                	cmp    %edx,%ebx
  803a47:	0f 82 87 00 00 00    	jb     803ad4 <__umoddi3+0x134>
  803a4d:	0f 84 91 00 00 00    	je     803ae4 <__umoddi3+0x144>
  803a53:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a57:	29 f2                	sub    %esi,%edx
  803a59:	19 cb                	sbb    %ecx,%ebx
  803a5b:	89 d8                	mov    %ebx,%eax
  803a5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a61:	d3 e0                	shl    %cl,%eax
  803a63:	89 e9                	mov    %ebp,%ecx
  803a65:	d3 ea                	shr    %cl,%edx
  803a67:	09 d0                	or     %edx,%eax
  803a69:	89 e9                	mov    %ebp,%ecx
  803a6b:	d3 eb                	shr    %cl,%ebx
  803a6d:	89 da                	mov    %ebx,%edx
  803a6f:	83 c4 1c             	add    $0x1c,%esp
  803a72:	5b                   	pop    %ebx
  803a73:	5e                   	pop    %esi
  803a74:	5f                   	pop    %edi
  803a75:	5d                   	pop    %ebp
  803a76:	c3                   	ret    
  803a77:	90                   	nop
  803a78:	89 fd                	mov    %edi,%ebp
  803a7a:	85 ff                	test   %edi,%edi
  803a7c:	75 0b                	jne    803a89 <__umoddi3+0xe9>
  803a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a83:	31 d2                	xor    %edx,%edx
  803a85:	f7 f7                	div    %edi
  803a87:	89 c5                	mov    %eax,%ebp
  803a89:	89 f0                	mov    %esi,%eax
  803a8b:	31 d2                	xor    %edx,%edx
  803a8d:	f7 f5                	div    %ebp
  803a8f:	89 c8                	mov    %ecx,%eax
  803a91:	f7 f5                	div    %ebp
  803a93:	89 d0                	mov    %edx,%eax
  803a95:	e9 44 ff ff ff       	jmp    8039de <__umoddi3+0x3e>
  803a9a:	66 90                	xchg   %ax,%ax
  803a9c:	89 c8                	mov    %ecx,%eax
  803a9e:	89 f2                	mov    %esi,%edx
  803aa0:	83 c4 1c             	add    $0x1c,%esp
  803aa3:	5b                   	pop    %ebx
  803aa4:	5e                   	pop    %esi
  803aa5:	5f                   	pop    %edi
  803aa6:	5d                   	pop    %ebp
  803aa7:	c3                   	ret    
  803aa8:	3b 04 24             	cmp    (%esp),%eax
  803aab:	72 06                	jb     803ab3 <__umoddi3+0x113>
  803aad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ab1:	77 0f                	ja     803ac2 <__umoddi3+0x122>
  803ab3:	89 f2                	mov    %esi,%edx
  803ab5:	29 f9                	sub    %edi,%ecx
  803ab7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803abb:	89 14 24             	mov    %edx,(%esp)
  803abe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ac2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ac6:	8b 14 24             	mov    (%esp),%edx
  803ac9:	83 c4 1c             	add    $0x1c,%esp
  803acc:	5b                   	pop    %ebx
  803acd:	5e                   	pop    %esi
  803ace:	5f                   	pop    %edi
  803acf:	5d                   	pop    %ebp
  803ad0:	c3                   	ret    
  803ad1:	8d 76 00             	lea    0x0(%esi),%esi
  803ad4:	2b 04 24             	sub    (%esp),%eax
  803ad7:	19 fa                	sbb    %edi,%edx
  803ad9:	89 d1                	mov    %edx,%ecx
  803adb:	89 c6                	mov    %eax,%esi
  803add:	e9 71 ff ff ff       	jmp    803a53 <__umoddi3+0xb3>
  803ae2:	66 90                	xchg   %ax,%ax
  803ae4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ae8:	72 ea                	jb     803ad4 <__umoddi3+0x134>
  803aea:	89 d9                	mov    %ebx,%ecx
  803aec:	e9 62 ff ff ff       	jmp    803a53 <__umoddi3+0xb3>
