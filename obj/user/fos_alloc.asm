
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
  80005c:	68 40 3b 80 00       	push   $0x803b40
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
  8000b9:	68 53 3b 80 00       	push   $0x803b53
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
  80010f:	68 53 3b 80 00       	push   $0x803b53
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
  80013e:	e8 d0 17 00 00       	call   801913 <sys_getenvindex>
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
  8001ac:	e8 e6 14 00 00       	call   801697 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 78 3b 80 00       	push   $0x803b78
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
  8001dc:	68 a0 3b 80 00       	push   $0x803ba0
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
  80020d:	68 c8 3b 80 00       	push   $0x803bc8
  800212:	e8 34 01 00 00       	call   80034b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 20 3c 80 00       	push   $0x803c20
  80022e:	e8 18 01 00 00       	call   80034b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 78 3b 80 00       	push   $0x803b78
  80023e:	e8 08 01 00 00       	call   80034b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800246:	e8 66 14 00 00       	call   8016b1 <sys_unlock_cons>
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
  80025e:	e8 7c 16 00 00       	call   8018df <sys_destroy_env>
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
  80026f:	e8 d1 16 00 00       	call   801945 <sys_exit_env>
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
  8002bd:	e8 93 13 00 00       	call   801655 <sys_cputs>
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
  800334:	e8 1c 13 00 00       	call   801655 <sys_cputs>
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
  80037e:	e8 14 13 00 00       	call   801697 <sys_lock_cons>
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
  80039e:	e8 0e 13 00 00       	call   8016b1 <sys_unlock_cons>
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
  8003e8:	e8 eb 34 00 00       	call   8038d8 <__udivdi3>
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
  800438:	e8 ab 35 00 00       	call   8039e8 <__umoddi3>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	05 54 3e 80 00       	add    $0x803e54,%eax
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
  800593:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
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
  800674:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  80067b:	85 f6                	test   %esi,%esi
  80067d:	75 19                	jne    800698 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067f:	53                   	push   %ebx
  800680:	68 65 3e 80 00       	push   $0x803e65
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
  800699:	68 6e 3e 80 00       	push   $0x803e6e
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
  8006c6:	be 71 3e 80 00       	mov    $0x803e71,%esi
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
  8010d1:	68 e8 3f 80 00       	push   $0x803fe8
  8010d6:	68 3f 01 00 00       	push   $0x13f
  8010db:	68 0a 40 80 00       	push   $0x80400a
  8010e0:	e8 07 26 00 00       	call   8036ec <_panic>

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
  8010f1:	e8 0a 0b 00 00       	call   801c00 <sys_sbrk>
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
  80116c:	e8 13 09 00 00       	call   801a84 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801171:	85 c0                	test   %eax,%eax
  801173:	74 16                	je     80118b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	ff 75 08             	pushl  0x8(%ebp)
  80117b:	e8 53 0e 00 00       	call   801fd3 <alloc_block_FF>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801186:	e9 8a 01 00 00       	jmp    801315 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80118b:	e8 25 09 00 00       	call   801ab5 <sys_isUHeapPlacementStrategyBESTFIT>
  801190:	85 c0                	test   %eax,%eax
  801192:	0f 84 7d 01 00 00    	je     801315 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801198:	83 ec 0c             	sub    $0xc,%esp
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	e8 ec 12 00 00       	call   80248f <alloc_block_BF>
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
		//cprintf("52\n");
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
			//cprintf("57\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8011fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801200:	05 00 10 00 00       	add    $0x1000,%eax
  801205:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  801208:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
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
						//cprintf("71\n");
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
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
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
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  8012a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012ac:	75 16                	jne    8012c4 <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  8012ae:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  8012b5:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  8012bc:	0f 86 15 ff ff ff    	jbe    8011d7 <malloc+0xdc>
  8012c2:	eb 01                	jmp    8012c5 <malloc+0x1ca>
				}
				//cprintf("79\n");

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
  801304:	e8 2e 09 00 00       	call   801c37 <sys_allocate_user_mem>
  801309:	83 c4 10             	add    $0x10,%esp
  80130c:	eb 07                	jmp    801315 <malloc+0x21a>
		//cprintf("91\n");
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
  80134c:	e8 02 09 00 00       	call   801c53 <get_block_size>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 35 1b 00 00       	call   802e97 <free_block>
  801362:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
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
  8013b1:	eb 2f                	jmp    8013e2 <free+0xc8>
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
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8013df:	ff 45 f4             	incl   -0xc(%ebp)
  8013e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8013e8:	72 c9                	jb     8013b3 <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	83 ec 08             	sub    $0x8,%esp
  8013f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f3:	50                   	push   %eax
  8013f4:	e8 22 08 00 00       	call   801c1b <sys_free_user_mem>
  8013f9:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8013fc:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8013fd:	eb 17                	jmp    801416 <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8013ff:	83 ec 04             	sub    $0x4,%esp
  801402:	68 18 40 80 00       	push   $0x804018
  801407:	68 85 00 00 00       	push   $0x85
  80140c:	68 42 40 80 00       	push   $0x804042
  801411:	e8 d6 22 00 00       	call   8036ec <_panic>
	}
}
  801416:	c9                   	leave  
  801417:	c3                   	ret    

00801418 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 28             	sub    $0x28,%esp
  80141e:	8b 45 10             	mov    0x10(%ebp),%eax
  801421:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801424:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801428:	75 0a                	jne    801434 <smalloc+0x1c>
  80142a:	b8 00 00 00 00       	mov    $0x0,%eax
  80142f:	e9 9a 00 00 00       	jmp    8014ce <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801434:	8b 45 0c             	mov    0xc(%ebp),%eax
  801437:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80143a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801441:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801447:	39 d0                	cmp    %edx,%eax
  801449:	73 02                	jae    80144d <smalloc+0x35>
  80144b:	89 d0                	mov    %edx,%eax
  80144d:	83 ec 0c             	sub    $0xc,%esp
  801450:	50                   	push   %eax
  801451:	e8 a5 fc ff ff       	call   8010fb <malloc>
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  80145c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801460:	75 07                	jne    801469 <smalloc+0x51>
  801462:	b8 00 00 00 00       	mov    $0x0,%eax
  801467:	eb 65                	jmp    8014ce <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801469:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80146d:	ff 75 ec             	pushl  -0x14(%ebp)
  801470:	50                   	push   %eax
  801471:	ff 75 0c             	pushl  0xc(%ebp)
  801474:	ff 75 08             	pushl  0x8(%ebp)
  801477:	e8 a6 03 00 00       	call   801822 <sys_createSharedObject>
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801482:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801486:	74 06                	je     80148e <smalloc+0x76>
  801488:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80148c:	75 07                	jne    801495 <smalloc+0x7d>
  80148e:	b8 00 00 00 00       	mov    $0x0,%eax
  801493:	eb 39                	jmp    8014ce <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  801495:	83 ec 08             	sub    $0x8,%esp
  801498:	ff 75 ec             	pushl  -0x14(%ebp)
  80149b:	68 4e 40 80 00       	push   $0x80404e
  8014a0:	e8 a6 ee ff ff       	call   80034b <cprintf>
  8014a5:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8014a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8014b0:	8b 40 78             	mov    0x78(%eax),%eax
  8014b3:	29 c2                	sub    %eax,%edx
  8014b5:	89 d0                	mov    %edx,%eax
  8014b7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014bc:	c1 e8 0c             	shr    $0xc,%eax
  8014bf:	89 c2                	mov    %eax,%edx
  8014c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014c4:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8014cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014d6:	83 ec 08             	sub    $0x8,%esp
  8014d9:	ff 75 0c             	pushl  0xc(%ebp)
  8014dc:	ff 75 08             	pushl  0x8(%ebp)
  8014df:	e8 68 03 00 00       	call   80184c <sys_getSizeOfSharedObject>
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8014ea:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8014ee:	75 07                	jne    8014f7 <sget+0x27>
  8014f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f5:	eb 7f                	jmp    801576 <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8014f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014fd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801504:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150a:	39 d0                	cmp    %edx,%eax
  80150c:	7d 02                	jge    801510 <sget+0x40>
  80150e:	89 d0                	mov    %edx,%eax
  801510:	83 ec 0c             	sub    $0xc,%esp
  801513:	50                   	push   %eax
  801514:	e8 e2 fb ff ff       	call   8010fb <malloc>
  801519:	83 c4 10             	add    $0x10,%esp
  80151c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80151f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801523:	75 07                	jne    80152c <sget+0x5c>
  801525:	b8 00 00 00 00       	mov    $0x0,%eax
  80152a:	eb 4a                	jmp    801576 <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	ff 75 e8             	pushl  -0x18(%ebp)
  801532:	ff 75 0c             	pushl  0xc(%ebp)
  801535:	ff 75 08             	pushl  0x8(%ebp)
  801538:	e8 2c 03 00 00       	call   801869 <sys_getSharedObject>
  80153d:	83 c4 10             	add    $0x10,%esp
  801540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801543:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801546:	a1 20 50 80 00       	mov    0x805020,%eax
  80154b:	8b 40 78             	mov    0x78(%eax),%eax
  80154e:	29 c2                	sub    %eax,%edx
  801550:	89 d0                	mov    %edx,%eax
  801552:	2d 00 10 00 00       	sub    $0x1000,%eax
  801557:	c1 e8 0c             	shr    $0xc,%eax
  80155a:	89 c2                	mov    %eax,%edx
  80155c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80155f:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801566:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80156a:	75 07                	jne    801573 <sget+0xa3>
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
  801571:	eb 03                	jmp    801576 <sget+0xa6>
	return ptr;
  801573:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
  80157b:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  80157e:	8b 55 08             	mov    0x8(%ebp),%edx
  801581:	a1 20 50 80 00       	mov    0x805020,%eax
  801586:	8b 40 78             	mov    0x78(%eax),%eax
  801589:	29 c2                	sub    %eax,%edx
  80158b:	89 d0                	mov    %edx,%eax
  80158d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801592:	c1 e8 0c             	shr    $0xc,%eax
  801595:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80159c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	ff 75 08             	pushl  0x8(%ebp)
  8015a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a8:	e8 db 02 00 00       	call   801888 <sys_freeSharedObject>
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  8015b3:	90                   	nop
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	68 60 40 80 00       	push   $0x804060
  8015c4:	68 de 00 00 00       	push   $0xde
  8015c9:	68 42 40 80 00       	push   $0x804042
  8015ce:	e8 19 21 00 00       	call   8036ec <_panic>

008015d3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	68 86 40 80 00       	push   $0x804086
  8015e1:	68 ea 00 00 00       	push   $0xea
  8015e6:	68 42 40 80 00       	push   $0x804042
  8015eb:	e8 fc 20 00 00       	call   8036ec <_panic>

008015f0 <shrink>:

}
void shrink(uint32 newSize)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f6:	83 ec 04             	sub    $0x4,%esp
  8015f9:	68 86 40 80 00       	push   $0x804086
  8015fe:	68 ef 00 00 00       	push   $0xef
  801603:	68 42 40 80 00       	push   $0x804042
  801608:	e8 df 20 00 00       	call   8036ec <_panic>

0080160d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801613:	83 ec 04             	sub    $0x4,%esp
  801616:	68 86 40 80 00       	push   $0x804086
  80161b:	68 f4 00 00 00       	push   $0xf4
  801620:	68 42 40 80 00       	push   $0x804042
  801625:	e8 c2 20 00 00       	call   8036ec <_panic>

0080162a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	57                   	push   %edi
  80162e:	56                   	push   %esi
  80162f:	53                   	push   %ebx
  801630:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	8b 55 0c             	mov    0xc(%ebp),%edx
  801639:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80163f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801642:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801645:	cd 30                	int    $0x30
  801647:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80164a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	5b                   	pop    %ebx
  801651:	5e                   	pop    %esi
  801652:	5f                   	pop    %edi
  801653:	5d                   	pop    %ebp
  801654:	c3                   	ret    

00801655 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801661:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	52                   	push   %edx
  80166d:	ff 75 0c             	pushl  0xc(%ebp)
  801670:	50                   	push   %eax
  801671:	6a 00                	push   $0x0
  801673:	e8 b2 ff ff ff       	call   80162a <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
}
  80167b:	90                   	nop
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <sys_cgetc>:

int
sys_cgetc(void)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 02                	push   $0x2
  80168d:	e8 98 ff ff ff       	call   80162a <syscall>
  801692:	83 c4 18             	add    $0x18,%esp
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 03                	push   $0x3
  8016a6:	e8 7f ff ff ff       	call   80162a <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	90                   	nop
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 04                	push   $0x4
  8016c0:	e8 65 ff ff ff       	call   80162a <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
}
  8016c8:	90                   	nop
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	52                   	push   %edx
  8016db:	50                   	push   %eax
  8016dc:	6a 08                	push   $0x8
  8016de:	e8 47 ff ff ff       	call   80162a <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	56                   	push   %esi
  8016ec:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016ed:	8b 75 18             	mov    0x18(%ebp),%esi
  8016f0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	56                   	push   %esi
  8016fd:	53                   	push   %ebx
  8016fe:	51                   	push   %ecx
  8016ff:	52                   	push   %edx
  801700:	50                   	push   %eax
  801701:	6a 09                	push   $0x9
  801703:	e8 22 ff ff ff       	call   80162a <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170e:	5b                   	pop    %ebx
  80170f:	5e                   	pop    %esi
  801710:	5d                   	pop    %ebp
  801711:	c3                   	ret    

00801712 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801715:	8b 55 0c             	mov    0xc(%ebp),%edx
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	52                   	push   %edx
  801722:	50                   	push   %eax
  801723:	6a 0a                	push   $0xa
  801725:	e8 00 ff ff ff       	call   80162a <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	ff 75 08             	pushl  0x8(%ebp)
  80173e:	6a 0b                	push   $0xb
  801740:	e8 e5 fe ff ff       	call   80162a <syscall>
  801745:	83 c4 18             	add    $0x18,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 0c                	push   $0xc
  801759:	e8 cc fe ff ff       	call   80162a <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 0d                	push   $0xd
  801772:	e8 b3 fe ff ff       	call   80162a <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
}
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 0e                	push   $0xe
  80178b:	e8 9a fe ff ff       	call   80162a <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 0f                	push   $0xf
  8017a4:	e8 81 fe ff ff       	call   80162a <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	ff 75 08             	pushl  0x8(%ebp)
  8017bc:	6a 10                	push   $0x10
  8017be:	e8 67 fe ff ff       	call   80162a <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 11                	push   $0x11
  8017d7:	e8 4e fe ff ff       	call   80162a <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
}
  8017df:	90                   	nop
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 04             	sub    $0x4,%esp
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017ee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	50                   	push   %eax
  8017fb:	6a 01                	push   $0x1
  8017fd:	e8 28 fe ff ff       	call   80162a <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	90                   	nop
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 14                	push   $0x14
  801817:	e8 0e fe ff ff       	call   80162a <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 04             	sub    $0x4,%esp
  801828:	8b 45 10             	mov    0x10(%ebp),%eax
  80182b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80182e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801831:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	6a 00                	push   $0x0
  80183a:	51                   	push   %ecx
  80183b:	52                   	push   %edx
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	50                   	push   %eax
  801840:	6a 15                	push   $0x15
  801842:	e8 e3 fd ff ff       	call   80162a <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80184f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	52                   	push   %edx
  80185c:	50                   	push   %eax
  80185d:	6a 16                	push   $0x16
  80185f:	e8 c6 fd ff ff       	call   80162a <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80186c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	51                   	push   %ecx
  80187a:	52                   	push   %edx
  80187b:	50                   	push   %eax
  80187c:	6a 17                	push   $0x17
  80187e:	e8 a7 fd ff ff       	call   80162a <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	52                   	push   %edx
  801898:	50                   	push   %eax
  801899:	6a 18                	push   $0x18
  80189b:	e8 8a fd ff ff       	call   80162a <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	6a 00                	push   $0x0
  8018ad:	ff 75 14             	pushl  0x14(%ebp)
  8018b0:	ff 75 10             	pushl  0x10(%ebp)
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	50                   	push   %eax
  8018b7:	6a 19                	push   $0x19
  8018b9:	e8 6c fd ff ff       	call   80162a <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	50                   	push   %eax
  8018d2:	6a 1a                	push   $0x1a
  8018d4:	e8 51 fd ff ff       	call   80162a <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	90                   	nop
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	50                   	push   %eax
  8018ee:	6a 1b                	push   $0x1b
  8018f0:	e8 35 fd ff ff       	call   80162a <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 05                	push   $0x5
  801909:	e8 1c fd ff ff       	call   80162a <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 06                	push   $0x6
  801922:	e8 03 fd ff ff       	call   80162a <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 07                	push   $0x7
  80193b:	e8 ea fc ff ff       	call   80162a <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_exit_env>:


void sys_exit_env(void)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 1c                	push   $0x1c
  801954:	e8 d1 fc ff ff       	call   80162a <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	90                   	nop
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801965:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801968:	8d 50 04             	lea    0x4(%eax),%edx
  80196b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	52                   	push   %edx
  801975:	50                   	push   %eax
  801976:	6a 1d                	push   $0x1d
  801978:	e8 ad fc ff ff       	call   80162a <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
	return result;
  801980:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801983:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801986:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801989:	89 01                	mov    %eax,(%ecx)
  80198b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	c9                   	leave  
  801992:	c2 04 00             	ret    $0x4

00801995 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	ff 75 10             	pushl  0x10(%ebp)
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	ff 75 08             	pushl  0x8(%ebp)
  8019a5:	6a 13                	push   $0x13
  8019a7:	e8 7e fc ff ff       	call   80162a <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8019af:	90                   	nop
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 1e                	push   $0x1e
  8019c1:	e8 64 fc ff ff       	call   80162a <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	83 ec 04             	sub    $0x4,%esp
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019d7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	50                   	push   %eax
  8019e4:	6a 1f                	push   $0x1f
  8019e6:	e8 3f fc ff ff       	call   80162a <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ee:	90                   	nop
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <rsttst>:
void rsttst()
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 21                	push   $0x21
  801a00:	e8 25 fc ff ff       	call   80162a <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
	return ;
  801a08:	90                   	nop
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 04             	sub    $0x4,%esp
  801a11:	8b 45 14             	mov    0x14(%ebp),%eax
  801a14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a17:	8b 55 18             	mov    0x18(%ebp),%edx
  801a1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1e:	52                   	push   %edx
  801a1f:	50                   	push   %eax
  801a20:	ff 75 10             	pushl  0x10(%ebp)
  801a23:	ff 75 0c             	pushl  0xc(%ebp)
  801a26:	ff 75 08             	pushl  0x8(%ebp)
  801a29:	6a 20                	push   $0x20
  801a2b:	e8 fa fb ff ff       	call   80162a <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
	return ;
  801a33:	90                   	nop
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <chktst>:
void chktst(uint32 n)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	ff 75 08             	pushl  0x8(%ebp)
  801a44:	6a 22                	push   $0x22
  801a46:	e8 df fb ff ff       	call   80162a <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4e:	90                   	nop
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <inctst>:

void inctst()
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 23                	push   $0x23
  801a60:	e8 c5 fb ff ff       	call   80162a <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
	return ;
  801a68:	90                   	nop
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <gettst>:
uint32 gettst()
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 24                	push   $0x24
  801a7a:	e8 ab fb ff ff       	call   80162a <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 25                	push   $0x25
  801a96:	e8 8f fb ff ff       	call   80162a <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
  801a9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801aa1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801aa5:	75 07                	jne    801aae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801aa7:	b8 01 00 00 00       	mov    $0x1,%eax
  801aac:	eb 05                	jmp    801ab3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801aae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 25                	push   $0x25
  801ac7:	e8 5e fb ff ff       	call   80162a <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
  801acf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ad2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ad6:	75 07                	jne    801adf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ad8:	b8 01 00 00 00       	mov    $0x1,%eax
  801add:	eb 05                	jmp    801ae4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801adf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 25                	push   $0x25
  801af8:	e8 2d fb ff ff       	call   80162a <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
  801b00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b03:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b07:	75 07                	jne    801b10 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b09:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0e:	eb 05                	jmp    801b15 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 25                	push   $0x25
  801b29:	e8 fc fa ff ff       	call   80162a <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
  801b31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b34:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b38:	75 07                	jne    801b41 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3f:	eb 05                	jmp    801b46 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	ff 75 08             	pushl  0x8(%ebp)
  801b56:	6a 26                	push   $0x26
  801b58:	e8 cd fa ff ff       	call   80162a <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b60:	90                   	nop
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	53                   	push   %ebx
  801b76:	51                   	push   %ecx
  801b77:	52                   	push   %edx
  801b78:	50                   	push   %eax
  801b79:	6a 27                	push   $0x27
  801b7b:	e8 aa fa ff ff       	call   80162a <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	6a 28                	push   $0x28
  801b9b:	e8 8a fa ff ff       	call   80162a <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ba8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	51                   	push   %ecx
  801bb4:	ff 75 10             	pushl  0x10(%ebp)
  801bb7:	52                   	push   %edx
  801bb8:	50                   	push   %eax
  801bb9:	6a 29                	push   $0x29
  801bbb:	e8 6a fa ff ff       	call   80162a <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 10             	pushl  0x10(%ebp)
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	ff 75 08             	pushl  0x8(%ebp)
  801bd5:	6a 12                	push   $0x12
  801bd7:	e8 4e fa ff ff       	call   80162a <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdf:	90                   	nop
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	6a 2a                	push   $0x2a
  801bf5:	e8 30 fa ff ff       	call   80162a <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
	return;
  801bfd:	90                   	nop
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c03:	8b 45 08             	mov    0x8(%ebp),%eax
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	50                   	push   %eax
  801c0f:	6a 2b                	push   $0x2b
  801c11:	e8 14 fa ff ff       	call   80162a <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	ff 75 0c             	pushl  0xc(%ebp)
  801c27:	ff 75 08             	pushl  0x8(%ebp)
  801c2a:	6a 2c                	push   $0x2c
  801c2c:	e8 f9 f9 ff ff       	call   80162a <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
	return;
  801c34:	90                   	nop
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	ff 75 0c             	pushl  0xc(%ebp)
  801c43:	ff 75 08             	pushl  0x8(%ebp)
  801c46:	6a 2d                	push   $0x2d
  801c48:	e8 dd f9 ff ff       	call   80162a <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
	return;
  801c50:	90                   	nop
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	83 e8 04             	sub    $0x4,%eax
  801c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801c62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c65:	8b 00                	mov    (%eax),%eax
  801c67:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	83 e8 04             	sub    $0x4,%eax
  801c78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801c7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c7e:	8b 00                	mov    (%eax),%eax
  801c80:	83 e0 01             	and    $0x1,%eax
  801c83:	85 c0                	test   %eax,%eax
  801c85:	0f 94 c0             	sete   %al
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801c90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c9a:	83 f8 02             	cmp    $0x2,%eax
  801c9d:	74 2b                	je     801cca <alloc_block+0x40>
  801c9f:	83 f8 02             	cmp    $0x2,%eax
  801ca2:	7f 07                	jg     801cab <alloc_block+0x21>
  801ca4:	83 f8 01             	cmp    $0x1,%eax
  801ca7:	74 0e                	je     801cb7 <alloc_block+0x2d>
  801ca9:	eb 58                	jmp    801d03 <alloc_block+0x79>
  801cab:	83 f8 03             	cmp    $0x3,%eax
  801cae:	74 2d                	je     801cdd <alloc_block+0x53>
  801cb0:	83 f8 04             	cmp    $0x4,%eax
  801cb3:	74 3b                	je     801cf0 <alloc_block+0x66>
  801cb5:	eb 4c                	jmp    801d03 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801cb7:	83 ec 0c             	sub    $0xc,%esp
  801cba:	ff 75 08             	pushl  0x8(%ebp)
  801cbd:	e8 11 03 00 00       	call   801fd3 <alloc_block_FF>
  801cc2:	83 c4 10             	add    $0x10,%esp
  801cc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cc8:	eb 4a                	jmp    801d14 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801cca:	83 ec 0c             	sub    $0xc,%esp
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	e8 fa 19 00 00       	call   8036cf <alloc_block_NF>
  801cd5:	83 c4 10             	add    $0x10,%esp
  801cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cdb:	eb 37                	jmp    801d14 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	ff 75 08             	pushl  0x8(%ebp)
  801ce3:	e8 a7 07 00 00       	call   80248f <alloc_block_BF>
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cee:	eb 24                	jmp    801d14 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801cf0:	83 ec 0c             	sub    $0xc,%esp
  801cf3:	ff 75 08             	pushl  0x8(%ebp)
  801cf6:	e8 b7 19 00 00       	call   8036b2 <alloc_block_WF>
  801cfb:	83 c4 10             	add    $0x10,%esp
  801cfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d01:	eb 11                	jmp    801d14 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801d03:	83 ec 0c             	sub    $0xc,%esp
  801d06:	68 98 40 80 00       	push   $0x804098
  801d0b:	e8 3b e6 ff ff       	call   80034b <cprintf>
  801d10:	83 c4 10             	add    $0x10,%esp
		break;
  801d13:	90                   	nop
	}
	return va;
  801d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	53                   	push   %ebx
  801d1d:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801d20:	83 ec 0c             	sub    $0xc,%esp
  801d23:	68 b8 40 80 00       	push   $0x8040b8
  801d28:	e8 1e e6 ff ff       	call   80034b <cprintf>
  801d2d:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d30:	83 ec 0c             	sub    $0xc,%esp
  801d33:	68 e3 40 80 00       	push   $0x8040e3
  801d38:	e8 0e e6 ff ff       	call   80034b <cprintf>
  801d3d:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d46:	eb 37                	jmp    801d7f <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4e:	e8 19 ff ff ff       	call   801c6c <is_free_block>
  801d53:	83 c4 10             	add    $0x10,%esp
  801d56:	0f be d8             	movsbl %al,%ebx
  801d59:	83 ec 0c             	sub    $0xc,%esp
  801d5c:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5f:	e8 ef fe ff ff       	call   801c53 <get_block_size>
  801d64:	83 c4 10             	add    $0x10,%esp
  801d67:	83 ec 04             	sub    $0x4,%esp
  801d6a:	53                   	push   %ebx
  801d6b:	50                   	push   %eax
  801d6c:	68 fb 40 80 00       	push   $0x8040fb
  801d71:	e8 d5 e5 ff ff       	call   80034b <cprintf>
  801d76:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801d79:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d83:	74 07                	je     801d8c <print_blocks_list+0x73>
  801d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d88:	8b 00                	mov    (%eax),%eax
  801d8a:	eb 05                	jmp    801d91 <print_blocks_list+0x78>
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d91:	89 45 10             	mov    %eax,0x10(%ebp)
  801d94:	8b 45 10             	mov    0x10(%ebp),%eax
  801d97:	85 c0                	test   %eax,%eax
  801d99:	75 ad                	jne    801d48 <print_blocks_list+0x2f>
  801d9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d9f:	75 a7                	jne    801d48 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801da1:	83 ec 0c             	sub    $0xc,%esp
  801da4:	68 b8 40 80 00       	push   $0x8040b8
  801da9:	e8 9d e5 ff ff       	call   80034b <cprintf>
  801dae:	83 c4 10             	add    $0x10,%esp

}
  801db1:	90                   	nop
  801db2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc0:	83 e0 01             	and    $0x1,%eax
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	74 03                	je     801dca <initialize_dynamic_allocator+0x13>
  801dc7:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801dca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801dce:	0f 84 c7 01 00 00    	je     801f9b <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801dd4:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801ddb:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801dde:	8b 55 08             	mov    0x8(%ebp),%edx
  801de1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de4:	01 d0                	add    %edx,%eax
  801de6:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801deb:	0f 87 ad 01 00 00    	ja     801f9e <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	85 c0                	test   %eax,%eax
  801df6:	0f 89 a5 01 00 00    	jns    801fa1 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  801dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e02:	01 d0                	add    %edx,%eax
  801e04:	83 e8 04             	sub    $0x4,%eax
  801e07:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801e0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801e13:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e1b:	e9 87 00 00 00       	jmp    801ea7 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e24:	75 14                	jne    801e3a <initialize_dynamic_allocator+0x83>
  801e26:	83 ec 04             	sub    $0x4,%esp
  801e29:	68 13 41 80 00       	push   $0x804113
  801e2e:	6a 79                	push   $0x79
  801e30:	68 31 41 80 00       	push   $0x804131
  801e35:	e8 b2 18 00 00       	call   8036ec <_panic>
  801e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3d:	8b 00                	mov    (%eax),%eax
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	74 10                	je     801e53 <initialize_dynamic_allocator+0x9c>
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	8b 00                	mov    (%eax),%eax
  801e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4b:	8b 52 04             	mov    0x4(%edx),%edx
  801e4e:	89 50 04             	mov    %edx,0x4(%eax)
  801e51:	eb 0b                	jmp    801e5e <initialize_dynamic_allocator+0xa7>
  801e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e56:	8b 40 04             	mov    0x4(%eax),%eax
  801e59:	a3 30 50 80 00       	mov    %eax,0x805030
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	8b 40 04             	mov    0x4(%eax),%eax
  801e64:	85 c0                	test   %eax,%eax
  801e66:	74 0f                	je     801e77 <initialize_dynamic_allocator+0xc0>
  801e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6b:	8b 40 04             	mov    0x4(%eax),%eax
  801e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e71:	8b 12                	mov    (%edx),%edx
  801e73:	89 10                	mov    %edx,(%eax)
  801e75:	eb 0a                	jmp    801e81 <initialize_dynamic_allocator+0xca>
  801e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7a:	8b 00                	mov    (%eax),%eax
  801e7c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e94:	a1 38 50 80 00       	mov    0x805038,%eax
  801e99:	48                   	dec    %eax
  801e9a:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801e9f:	a1 34 50 80 00       	mov    0x805034,%eax
  801ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eab:	74 07                	je     801eb4 <initialize_dynamic_allocator+0xfd>
  801ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb0:	8b 00                	mov    (%eax),%eax
  801eb2:	eb 05                	jmp    801eb9 <initialize_dynamic_allocator+0x102>
  801eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb9:	a3 34 50 80 00       	mov    %eax,0x805034
  801ebe:	a1 34 50 80 00       	mov    0x805034,%eax
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	0f 85 55 ff ff ff    	jne    801e20 <initialize_dynamic_allocator+0x69>
  801ecb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ecf:	0f 85 4b ff ff ff    	jne    801e20 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ede:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801ee4:	a1 44 50 80 00       	mov    0x805044,%eax
  801ee9:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801eee:	a1 40 50 80 00       	mov    0x805040,%eax
  801ef3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	83 c0 08             	add    $0x8,%eax
  801eff:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	83 c0 04             	add    $0x4,%eax
  801f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0b:	83 ea 08             	sub    $0x8,%edx
  801f0e:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	01 d0                	add    %edx,%eax
  801f18:	83 e8 08             	sub    $0x8,%eax
  801f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1e:	83 ea 08             	sub    $0x8,%edx
  801f21:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f36:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f3a:	75 17                	jne    801f53 <initialize_dynamic_allocator+0x19c>
  801f3c:	83 ec 04             	sub    $0x4,%esp
  801f3f:	68 4c 41 80 00       	push   $0x80414c
  801f44:	68 90 00 00 00       	push   $0x90
  801f49:	68 31 41 80 00       	push   $0x804131
  801f4e:	e8 99 17 00 00       	call   8036ec <_panic>
  801f53:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f5c:	89 10                	mov    %edx,(%eax)
  801f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f61:	8b 00                	mov    (%eax),%eax
  801f63:	85 c0                	test   %eax,%eax
  801f65:	74 0d                	je     801f74 <initialize_dynamic_allocator+0x1bd>
  801f67:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f6f:	89 50 04             	mov    %edx,0x4(%eax)
  801f72:	eb 08                	jmp    801f7c <initialize_dynamic_allocator+0x1c5>
  801f74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f77:	a3 30 50 80 00       	mov    %eax,0x805030
  801f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f8e:	a1 38 50 80 00       	mov    0x805038,%eax
  801f93:	40                   	inc    %eax
  801f94:	a3 38 50 80 00       	mov    %eax,0x805038
  801f99:	eb 07                	jmp    801fa2 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801f9b:	90                   	nop
  801f9c:	eb 04                	jmp    801fa2 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801f9e:	90                   	nop
  801f9f:	eb 01                	jmp    801fa2 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801fa1:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  801faa:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	8d 50 fc             	lea    -0x4(%eax),%edx
  801fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb6:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	83 e8 04             	sub    $0x4,%eax
  801fbe:	8b 00                	mov    (%eax),%eax
  801fc0:	83 e0 fe             	and    $0xfffffffe,%eax
  801fc3:	8d 50 f8             	lea    -0x8(%eax),%edx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	01 c2                	add    %eax,%edx
  801fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fce:	89 02                	mov    %eax,(%edx)
}
  801fd0:	90                   	nop
  801fd1:	5d                   	pop    %ebp
  801fd2:	c3                   	ret    

00801fd3 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	83 e0 01             	and    $0x1,%eax
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	74 03                	je     801fe6 <alloc_block_FF+0x13>
  801fe3:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801fe6:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801fea:	77 07                	ja     801ff3 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801fec:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801ff3:	a1 24 50 80 00       	mov    0x805024,%eax
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	75 73                	jne    80206f <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	83 c0 10             	add    $0x10,%eax
  802002:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802005:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80200c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80200f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802012:	01 d0                	add    %edx,%eax
  802014:	48                   	dec    %eax
  802015:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802018:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80201b:	ba 00 00 00 00       	mov    $0x0,%edx
  802020:	f7 75 ec             	divl   -0x14(%ebp)
  802023:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802026:	29 d0                	sub    %edx,%eax
  802028:	c1 e8 0c             	shr    $0xc,%eax
  80202b:	83 ec 0c             	sub    $0xc,%esp
  80202e:	50                   	push   %eax
  80202f:	e8 b1 f0 ff ff       	call   8010e5 <sbrk>
  802034:	83 c4 10             	add    $0x10,%esp
  802037:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80203a:	83 ec 0c             	sub    $0xc,%esp
  80203d:	6a 00                	push   $0x0
  80203f:	e8 a1 f0 ff ff       	call   8010e5 <sbrk>
  802044:	83 c4 10             	add    $0x10,%esp
  802047:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80204a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80204d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802050:	83 ec 08             	sub    $0x8,%esp
  802053:	50                   	push   %eax
  802054:	ff 75 e4             	pushl  -0x1c(%ebp)
  802057:	e8 5b fd ff ff       	call   801db7 <initialize_dynamic_allocator>
  80205c:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80205f:	83 ec 0c             	sub    $0xc,%esp
  802062:	68 6f 41 80 00       	push   $0x80416f
  802067:	e8 df e2 ff ff       	call   80034b <cprintf>
  80206c:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80206f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802073:	75 0a                	jne    80207f <alloc_block_FF+0xac>
	        return NULL;
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
  80207a:	e9 0e 04 00 00       	jmp    80248d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80207f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802086:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80208b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208e:	e9 f3 02 00 00       	jmp    802386 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802096:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802099:	83 ec 0c             	sub    $0xc,%esp
  80209c:	ff 75 bc             	pushl  -0x44(%ebp)
  80209f:	e8 af fb ff ff       	call   801c53 <get_block_size>
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	83 c0 08             	add    $0x8,%eax
  8020b0:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020b3:	0f 87 c5 02 00 00    	ja     80237e <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	83 c0 18             	add    $0x18,%eax
  8020bf:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020c2:	0f 87 19 02 00 00    	ja     8022e1 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8020c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8020ce:	83 e8 08             	sub    $0x8,%eax
  8020d1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	8d 50 08             	lea    0x8(%eax),%edx
  8020da:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8020dd:	01 d0                	add    %edx,%eax
  8020df:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	83 c0 08             	add    $0x8,%eax
  8020e8:	83 ec 04             	sub    $0x4,%esp
  8020eb:	6a 01                	push   $0x1
  8020ed:	50                   	push   %eax
  8020ee:	ff 75 bc             	pushl  -0x44(%ebp)
  8020f1:	e8 ae fe ff ff       	call   801fa4 <set_block_data>
  8020f6:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	8b 40 04             	mov    0x4(%eax),%eax
  8020ff:	85 c0                	test   %eax,%eax
  802101:	75 68                	jne    80216b <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802103:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802107:	75 17                	jne    802120 <alloc_block_FF+0x14d>
  802109:	83 ec 04             	sub    $0x4,%esp
  80210c:	68 4c 41 80 00       	push   $0x80414c
  802111:	68 d7 00 00 00       	push   $0xd7
  802116:	68 31 41 80 00       	push   $0x804131
  80211b:	e8 cc 15 00 00       	call   8036ec <_panic>
  802120:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802126:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802129:	89 10                	mov    %edx,(%eax)
  80212b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80212e:	8b 00                	mov    (%eax),%eax
  802130:	85 c0                	test   %eax,%eax
  802132:	74 0d                	je     802141 <alloc_block_FF+0x16e>
  802134:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802139:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80213c:	89 50 04             	mov    %edx,0x4(%eax)
  80213f:	eb 08                	jmp    802149 <alloc_block_FF+0x176>
  802141:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802144:	a3 30 50 80 00       	mov    %eax,0x805030
  802149:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80214c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802151:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802154:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80215b:	a1 38 50 80 00       	mov    0x805038,%eax
  802160:	40                   	inc    %eax
  802161:	a3 38 50 80 00       	mov    %eax,0x805038
  802166:	e9 dc 00 00 00       	jmp    802247 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216e:	8b 00                	mov    (%eax),%eax
  802170:	85 c0                	test   %eax,%eax
  802172:	75 65                	jne    8021d9 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802174:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802178:	75 17                	jne    802191 <alloc_block_FF+0x1be>
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	68 80 41 80 00       	push   $0x804180
  802182:	68 db 00 00 00       	push   $0xdb
  802187:	68 31 41 80 00       	push   $0x804131
  80218c:	e8 5b 15 00 00       	call   8036ec <_panic>
  802191:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802197:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80219a:	89 50 04             	mov    %edx,0x4(%eax)
  80219d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021a0:	8b 40 04             	mov    0x4(%eax),%eax
  8021a3:	85 c0                	test   %eax,%eax
  8021a5:	74 0c                	je     8021b3 <alloc_block_FF+0x1e0>
  8021a7:	a1 30 50 80 00       	mov    0x805030,%eax
  8021ac:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021af:	89 10                	mov    %edx,(%eax)
  8021b1:	eb 08                	jmp    8021bb <alloc_block_FF+0x1e8>
  8021b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021b6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021be:	a3 30 50 80 00       	mov    %eax,0x805030
  8021c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8021d1:	40                   	inc    %eax
  8021d2:	a3 38 50 80 00       	mov    %eax,0x805038
  8021d7:	eb 6e                	jmp    802247 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8021d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021dd:	74 06                	je     8021e5 <alloc_block_FF+0x212>
  8021df:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021e3:	75 17                	jne    8021fc <alloc_block_FF+0x229>
  8021e5:	83 ec 04             	sub    $0x4,%esp
  8021e8:	68 a4 41 80 00       	push   $0x8041a4
  8021ed:	68 df 00 00 00       	push   $0xdf
  8021f2:	68 31 41 80 00       	push   $0x804131
  8021f7:	e8 f0 14 00 00       	call   8036ec <_panic>
  8021fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ff:	8b 10                	mov    (%eax),%edx
  802201:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802204:	89 10                	mov    %edx,(%eax)
  802206:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802209:	8b 00                	mov    (%eax),%eax
  80220b:	85 c0                	test   %eax,%eax
  80220d:	74 0b                	je     80221a <alloc_block_FF+0x247>
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	8b 00                	mov    (%eax),%eax
  802214:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802217:	89 50 04             	mov    %edx,0x4(%eax)
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802220:	89 10                	mov    %edx,(%eax)
  802222:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802225:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802228:	89 50 04             	mov    %edx,0x4(%eax)
  80222b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80222e:	8b 00                	mov    (%eax),%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	75 08                	jne    80223c <alloc_block_FF+0x269>
  802234:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802237:	a3 30 50 80 00       	mov    %eax,0x805030
  80223c:	a1 38 50 80 00       	mov    0x805038,%eax
  802241:	40                   	inc    %eax
  802242:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224b:	75 17                	jne    802264 <alloc_block_FF+0x291>
  80224d:	83 ec 04             	sub    $0x4,%esp
  802250:	68 13 41 80 00       	push   $0x804113
  802255:	68 e1 00 00 00       	push   $0xe1
  80225a:	68 31 41 80 00       	push   $0x804131
  80225f:	e8 88 14 00 00       	call   8036ec <_panic>
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	8b 00                	mov    (%eax),%eax
  802269:	85 c0                	test   %eax,%eax
  80226b:	74 10                	je     80227d <alloc_block_FF+0x2aa>
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	8b 00                	mov    (%eax),%eax
  802272:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802275:	8b 52 04             	mov    0x4(%edx),%edx
  802278:	89 50 04             	mov    %edx,0x4(%eax)
  80227b:	eb 0b                	jmp    802288 <alloc_block_FF+0x2b5>
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 40 04             	mov    0x4(%eax),%eax
  802283:	a3 30 50 80 00       	mov    %eax,0x805030
  802288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228b:	8b 40 04             	mov    0x4(%eax),%eax
  80228e:	85 c0                	test   %eax,%eax
  802290:	74 0f                	je     8022a1 <alloc_block_FF+0x2ce>
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	8b 40 04             	mov    0x4(%eax),%eax
  802298:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229b:	8b 12                	mov    (%edx),%edx
  80229d:	89 10                	mov    %edx,(%eax)
  80229f:	eb 0a                	jmp    8022ab <alloc_block_FF+0x2d8>
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 00                	mov    (%eax),%eax
  8022a6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022be:	a1 38 50 80 00       	mov    0x805038,%eax
  8022c3:	48                   	dec    %eax
  8022c4:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8022c9:	83 ec 04             	sub    $0x4,%esp
  8022cc:	6a 00                	push   $0x0
  8022ce:	ff 75 b4             	pushl  -0x4c(%ebp)
  8022d1:	ff 75 b0             	pushl  -0x50(%ebp)
  8022d4:	e8 cb fc ff ff       	call   801fa4 <set_block_data>
  8022d9:	83 c4 10             	add    $0x10,%esp
  8022dc:	e9 95 00 00 00       	jmp    802376 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8022e1:	83 ec 04             	sub    $0x4,%esp
  8022e4:	6a 01                	push   $0x1
  8022e6:	ff 75 b8             	pushl  -0x48(%ebp)
  8022e9:	ff 75 bc             	pushl  -0x44(%ebp)
  8022ec:	e8 b3 fc ff ff       	call   801fa4 <set_block_data>
  8022f1:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8022f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f8:	75 17                	jne    802311 <alloc_block_FF+0x33e>
  8022fa:	83 ec 04             	sub    $0x4,%esp
  8022fd:	68 13 41 80 00       	push   $0x804113
  802302:	68 e8 00 00 00       	push   $0xe8
  802307:	68 31 41 80 00       	push   $0x804131
  80230c:	e8 db 13 00 00       	call   8036ec <_panic>
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	8b 00                	mov    (%eax),%eax
  802316:	85 c0                	test   %eax,%eax
  802318:	74 10                	je     80232a <alloc_block_FF+0x357>
  80231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231d:	8b 00                	mov    (%eax),%eax
  80231f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802322:	8b 52 04             	mov    0x4(%edx),%edx
  802325:	89 50 04             	mov    %edx,0x4(%eax)
  802328:	eb 0b                	jmp    802335 <alloc_block_FF+0x362>
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	8b 40 04             	mov    0x4(%eax),%eax
  802330:	a3 30 50 80 00       	mov    %eax,0x805030
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 40 04             	mov    0x4(%eax),%eax
  80233b:	85 c0                	test   %eax,%eax
  80233d:	74 0f                	je     80234e <alloc_block_FF+0x37b>
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	8b 40 04             	mov    0x4(%eax),%eax
  802345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802348:	8b 12                	mov    (%edx),%edx
  80234a:	89 10                	mov    %edx,(%eax)
  80234c:	eb 0a                	jmp    802358 <alloc_block_FF+0x385>
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	8b 00                	mov    (%eax),%eax
  802353:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236b:	a1 38 50 80 00       	mov    0x805038,%eax
  802370:	48                   	dec    %eax
  802371:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802376:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802379:	e9 0f 01 00 00       	jmp    80248d <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  80237e:	a1 34 50 80 00       	mov    0x805034,%eax
  802383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802386:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238a:	74 07                	je     802393 <alloc_block_FF+0x3c0>
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	eb 05                	jmp    802398 <alloc_block_FF+0x3c5>
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
  802398:	a3 34 50 80 00       	mov    %eax,0x805034
  80239d:	a1 34 50 80 00       	mov    0x805034,%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	0f 85 e9 fc ff ff    	jne    802093 <alloc_block_FF+0xc0>
  8023aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ae:	0f 85 df fc ff ff    	jne    802093 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	83 c0 08             	add    $0x8,%eax
  8023ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8023bd:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8023c4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023ca:	01 d0                	add    %edx,%eax
  8023cc:	48                   	dec    %eax
  8023cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8023d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8023d8:	f7 75 d8             	divl   -0x28(%ebp)
  8023db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023de:	29 d0                	sub    %edx,%eax
  8023e0:	c1 e8 0c             	shr    $0xc,%eax
  8023e3:	83 ec 0c             	sub    $0xc,%esp
  8023e6:	50                   	push   %eax
  8023e7:	e8 f9 ec ff ff       	call   8010e5 <sbrk>
  8023ec:	83 c4 10             	add    $0x10,%esp
  8023ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8023f2:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8023f6:	75 0a                	jne    802402 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	e9 8b 00 00 00       	jmp    80248d <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802402:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802409:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80240c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80240f:	01 d0                	add    %edx,%eax
  802411:	48                   	dec    %eax
  802412:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802415:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802418:	ba 00 00 00 00       	mov    $0x0,%edx
  80241d:	f7 75 cc             	divl   -0x34(%ebp)
  802420:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802423:	29 d0                	sub    %edx,%eax
  802425:	8d 50 fc             	lea    -0x4(%eax),%edx
  802428:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80242b:	01 d0                	add    %edx,%eax
  80242d:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802432:	a1 40 50 80 00       	mov    0x805040,%eax
  802437:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80243d:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802444:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802447:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80244a:	01 d0                	add    %edx,%eax
  80244c:	48                   	dec    %eax
  80244d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802450:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802453:	ba 00 00 00 00       	mov    $0x0,%edx
  802458:	f7 75 c4             	divl   -0x3c(%ebp)
  80245b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80245e:	29 d0                	sub    %edx,%eax
  802460:	83 ec 04             	sub    $0x4,%esp
  802463:	6a 01                	push   $0x1
  802465:	50                   	push   %eax
  802466:	ff 75 d0             	pushl  -0x30(%ebp)
  802469:	e8 36 fb ff ff       	call   801fa4 <set_block_data>
  80246e:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802471:	83 ec 0c             	sub    $0xc,%esp
  802474:	ff 75 d0             	pushl  -0x30(%ebp)
  802477:	e8 1b 0a 00 00       	call   802e97 <free_block>
  80247c:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80247f:	83 ec 0c             	sub    $0xc,%esp
  802482:	ff 75 08             	pushl  0x8(%ebp)
  802485:	e8 49 fb ff ff       	call   801fd3 <alloc_block_FF>
  80248a:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	83 e0 01             	and    $0x1,%eax
  80249b:	85 c0                	test   %eax,%eax
  80249d:	74 03                	je     8024a2 <alloc_block_BF+0x13>
  80249f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024a2:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024a6:	77 07                	ja     8024af <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024a8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024af:	a1 24 50 80 00       	mov    0x805024,%eax
  8024b4:	85 c0                	test   %eax,%eax
  8024b6:	75 73                	jne    80252b <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	83 c0 10             	add    $0x10,%eax
  8024be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024c1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8024c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ce:	01 d0                	add    %edx,%eax
  8024d0:	48                   	dec    %eax
  8024d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8024d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8024dc:	f7 75 e0             	divl   -0x20(%ebp)
  8024df:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024e2:	29 d0                	sub    %edx,%eax
  8024e4:	c1 e8 0c             	shr    $0xc,%eax
  8024e7:	83 ec 0c             	sub    $0xc,%esp
  8024ea:	50                   	push   %eax
  8024eb:	e8 f5 eb ff ff       	call   8010e5 <sbrk>
  8024f0:	83 c4 10             	add    $0x10,%esp
  8024f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024f6:	83 ec 0c             	sub    $0xc,%esp
  8024f9:	6a 00                	push   $0x0
  8024fb:	e8 e5 eb ff ff       	call   8010e5 <sbrk>
  802500:	83 c4 10             	add    $0x10,%esp
  802503:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802506:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802509:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80250c:	83 ec 08             	sub    $0x8,%esp
  80250f:	50                   	push   %eax
  802510:	ff 75 d8             	pushl  -0x28(%ebp)
  802513:	e8 9f f8 ff ff       	call   801db7 <initialize_dynamic_allocator>
  802518:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80251b:	83 ec 0c             	sub    $0xc,%esp
  80251e:	68 6f 41 80 00       	push   $0x80416f
  802523:	e8 23 de ff ff       	call   80034b <cprintf>
  802528:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80252b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802532:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802539:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802540:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802547:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80254c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254f:	e9 1d 01 00 00       	jmp    802671 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80255a:	83 ec 0c             	sub    $0xc,%esp
  80255d:	ff 75 a8             	pushl  -0x58(%ebp)
  802560:	e8 ee f6 ff ff       	call   801c53 <get_block_size>
  802565:	83 c4 10             	add    $0x10,%esp
  802568:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80256b:	8b 45 08             	mov    0x8(%ebp),%eax
  80256e:	83 c0 08             	add    $0x8,%eax
  802571:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802574:	0f 87 ef 00 00 00    	ja     802669 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	83 c0 18             	add    $0x18,%eax
  802580:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802583:	77 1d                	ja     8025a2 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802588:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80258b:	0f 86 d8 00 00 00    	jbe    802669 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802591:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802594:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802597:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80259a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80259d:	e9 c7 00 00 00       	jmp    802669 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	83 c0 08             	add    $0x8,%eax
  8025a8:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025ab:	0f 85 9d 00 00 00    	jne    80264e <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8025b1:	83 ec 04             	sub    $0x4,%esp
  8025b4:	6a 01                	push   $0x1
  8025b6:	ff 75 a4             	pushl  -0x5c(%ebp)
  8025b9:	ff 75 a8             	pushl  -0x58(%ebp)
  8025bc:	e8 e3 f9 ff ff       	call   801fa4 <set_block_data>
  8025c1:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8025c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c8:	75 17                	jne    8025e1 <alloc_block_BF+0x152>
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	68 13 41 80 00       	push   $0x804113
  8025d2:	68 2c 01 00 00       	push   $0x12c
  8025d7:	68 31 41 80 00       	push   $0x804131
  8025dc:	e8 0b 11 00 00       	call   8036ec <_panic>
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	74 10                	je     8025fa <alloc_block_BF+0x16b>
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f2:	8b 52 04             	mov    0x4(%edx),%edx
  8025f5:	89 50 04             	mov    %edx,0x4(%eax)
  8025f8:	eb 0b                	jmp    802605 <alloc_block_BF+0x176>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 40 04             	mov    0x4(%eax),%eax
  802600:	a3 30 50 80 00       	mov    %eax,0x805030
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 40 04             	mov    0x4(%eax),%eax
  80260b:	85 c0                	test   %eax,%eax
  80260d:	74 0f                	je     80261e <alloc_block_BF+0x18f>
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 40 04             	mov    0x4(%eax),%eax
  802615:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802618:	8b 12                	mov    (%edx),%edx
  80261a:	89 10                	mov    %edx,(%eax)
  80261c:	eb 0a                	jmp    802628 <alloc_block_BF+0x199>
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 00                	mov    (%eax),%eax
  802623:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263b:	a1 38 50 80 00       	mov    0x805038,%eax
  802640:	48                   	dec    %eax
  802641:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802646:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802649:	e9 24 04 00 00       	jmp    802a72 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  80264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802651:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802654:	76 13                	jbe    802669 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802656:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80265d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802660:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802663:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802666:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802669:	a1 34 50 80 00       	mov    0x805034,%eax
  80266e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802675:	74 07                	je     80267e <alloc_block_BF+0x1ef>
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 00                	mov    (%eax),%eax
  80267c:	eb 05                	jmp    802683 <alloc_block_BF+0x1f4>
  80267e:	b8 00 00 00 00       	mov    $0x0,%eax
  802683:	a3 34 50 80 00       	mov    %eax,0x805034
  802688:	a1 34 50 80 00       	mov    0x805034,%eax
  80268d:	85 c0                	test   %eax,%eax
  80268f:	0f 85 bf fe ff ff    	jne    802554 <alloc_block_BF+0xc5>
  802695:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802699:	0f 85 b5 fe ff ff    	jne    802554 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80269f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026a3:	0f 84 26 02 00 00    	je     8028cf <alloc_block_BF+0x440>
  8026a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026ad:	0f 85 1c 02 00 00    	jne    8028cf <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8026b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8026b9:	83 e8 08             	sub    $0x8,%eax
  8026bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8026bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c2:	8d 50 08             	lea    0x8(%eax),%edx
  8026c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c8:	01 d0                	add    %edx,%eax
  8026ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8026cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d0:	83 c0 08             	add    $0x8,%eax
  8026d3:	83 ec 04             	sub    $0x4,%esp
  8026d6:	6a 01                	push   $0x1
  8026d8:	50                   	push   %eax
  8026d9:	ff 75 f0             	pushl  -0x10(%ebp)
  8026dc:	e8 c3 f8 ff ff       	call   801fa4 <set_block_data>
  8026e1:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8026e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	75 68                	jne    802756 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026ee:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026f2:	75 17                	jne    80270b <alloc_block_BF+0x27c>
  8026f4:	83 ec 04             	sub    $0x4,%esp
  8026f7:	68 4c 41 80 00       	push   $0x80414c
  8026fc:	68 45 01 00 00       	push   $0x145
  802701:	68 31 41 80 00       	push   $0x804131
  802706:	e8 e1 0f 00 00       	call   8036ec <_panic>
  80270b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802711:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802714:	89 10                	mov    %edx,(%eax)
  802716:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	85 c0                	test   %eax,%eax
  80271d:	74 0d                	je     80272c <alloc_block_BF+0x29d>
  80271f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802724:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802727:	89 50 04             	mov    %edx,0x4(%eax)
  80272a:	eb 08                	jmp    802734 <alloc_block_BF+0x2a5>
  80272c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80272f:	a3 30 50 80 00       	mov    %eax,0x805030
  802734:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802737:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80273c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80273f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802746:	a1 38 50 80 00       	mov    0x805038,%eax
  80274b:	40                   	inc    %eax
  80274c:	a3 38 50 80 00       	mov    %eax,0x805038
  802751:	e9 dc 00 00 00       	jmp    802832 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	85 c0                	test   %eax,%eax
  80275d:	75 65                	jne    8027c4 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80275f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802763:	75 17                	jne    80277c <alloc_block_BF+0x2ed>
  802765:	83 ec 04             	sub    $0x4,%esp
  802768:	68 80 41 80 00       	push   $0x804180
  80276d:	68 4a 01 00 00       	push   $0x14a
  802772:	68 31 41 80 00       	push   $0x804131
  802777:	e8 70 0f 00 00       	call   8036ec <_panic>
  80277c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802782:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802785:	89 50 04             	mov    %edx,0x4(%eax)
  802788:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80278b:	8b 40 04             	mov    0x4(%eax),%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	74 0c                	je     80279e <alloc_block_BF+0x30f>
  802792:	a1 30 50 80 00       	mov    0x805030,%eax
  802797:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80279a:	89 10                	mov    %edx,(%eax)
  80279c:	eb 08                	jmp    8027a6 <alloc_block_BF+0x317>
  80279e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027a1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8027ae:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b7:	a1 38 50 80 00       	mov    0x805038,%eax
  8027bc:	40                   	inc    %eax
  8027bd:	a3 38 50 80 00       	mov    %eax,0x805038
  8027c2:	eb 6e                	jmp    802832 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8027c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c8:	74 06                	je     8027d0 <alloc_block_BF+0x341>
  8027ca:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027ce:	75 17                	jne    8027e7 <alloc_block_BF+0x358>
  8027d0:	83 ec 04             	sub    $0x4,%esp
  8027d3:	68 a4 41 80 00       	push   $0x8041a4
  8027d8:	68 4f 01 00 00       	push   $0x14f
  8027dd:	68 31 41 80 00       	push   $0x804131
  8027e2:	e8 05 0f 00 00       	call   8036ec <_panic>
  8027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ea:	8b 10                	mov    (%eax),%edx
  8027ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ef:	89 10                	mov    %edx,(%eax)
  8027f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f4:	8b 00                	mov    (%eax),%eax
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	74 0b                	je     802805 <alloc_block_BF+0x376>
  8027fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fd:	8b 00                	mov    (%eax),%eax
  8027ff:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802802:	89 50 04             	mov    %edx,0x4(%eax)
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80280b:	89 10                	mov    %edx,(%eax)
  80280d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802810:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802813:	89 50 04             	mov    %edx,0x4(%eax)
  802816:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802819:	8b 00                	mov    (%eax),%eax
  80281b:	85 c0                	test   %eax,%eax
  80281d:	75 08                	jne    802827 <alloc_block_BF+0x398>
  80281f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802822:	a3 30 50 80 00       	mov    %eax,0x805030
  802827:	a1 38 50 80 00       	mov    0x805038,%eax
  80282c:	40                   	inc    %eax
  80282d:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802832:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802836:	75 17                	jne    80284f <alloc_block_BF+0x3c0>
  802838:	83 ec 04             	sub    $0x4,%esp
  80283b:	68 13 41 80 00       	push   $0x804113
  802840:	68 51 01 00 00       	push   $0x151
  802845:	68 31 41 80 00       	push   $0x804131
  80284a:	e8 9d 0e 00 00       	call   8036ec <_panic>
  80284f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	74 10                	je     802868 <alloc_block_BF+0x3d9>
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802860:	8b 52 04             	mov    0x4(%edx),%edx
  802863:	89 50 04             	mov    %edx,0x4(%eax)
  802866:	eb 0b                	jmp    802873 <alloc_block_BF+0x3e4>
  802868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286b:	8b 40 04             	mov    0x4(%eax),%eax
  80286e:	a3 30 50 80 00       	mov    %eax,0x805030
  802873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802876:	8b 40 04             	mov    0x4(%eax),%eax
  802879:	85 c0                	test   %eax,%eax
  80287b:	74 0f                	je     80288c <alloc_block_BF+0x3fd>
  80287d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802880:	8b 40 04             	mov    0x4(%eax),%eax
  802883:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802886:	8b 12                	mov    (%edx),%edx
  802888:	89 10                	mov    %edx,(%eax)
  80288a:	eb 0a                	jmp    802896 <alloc_block_BF+0x407>
  80288c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a9:	a1 38 50 80 00       	mov    0x805038,%eax
  8028ae:	48                   	dec    %eax
  8028af:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8028b4:	83 ec 04             	sub    $0x4,%esp
  8028b7:	6a 00                	push   $0x0
  8028b9:	ff 75 d0             	pushl  -0x30(%ebp)
  8028bc:	ff 75 cc             	pushl  -0x34(%ebp)
  8028bf:	e8 e0 f6 ff ff       	call   801fa4 <set_block_data>
  8028c4:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8028c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ca:	e9 a3 01 00 00       	jmp    802a72 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8028cf:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8028d3:	0f 85 9d 00 00 00    	jne    802976 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8028d9:	83 ec 04             	sub    $0x4,%esp
  8028dc:	6a 01                	push   $0x1
  8028de:	ff 75 ec             	pushl  -0x14(%ebp)
  8028e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8028e4:	e8 bb f6 ff ff       	call   801fa4 <set_block_data>
  8028e9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8028ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028f0:	75 17                	jne    802909 <alloc_block_BF+0x47a>
  8028f2:	83 ec 04             	sub    $0x4,%esp
  8028f5:	68 13 41 80 00       	push   $0x804113
  8028fa:	68 58 01 00 00       	push   $0x158
  8028ff:	68 31 41 80 00       	push   $0x804131
  802904:	e8 e3 0d 00 00       	call   8036ec <_panic>
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	8b 00                	mov    (%eax),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	74 10                	je     802922 <alloc_block_BF+0x493>
  802912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291a:	8b 52 04             	mov    0x4(%edx),%edx
  80291d:	89 50 04             	mov    %edx,0x4(%eax)
  802920:	eb 0b                	jmp    80292d <alloc_block_BF+0x49e>
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	8b 40 04             	mov    0x4(%eax),%eax
  802928:	a3 30 50 80 00       	mov    %eax,0x805030
  80292d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802930:	8b 40 04             	mov    0x4(%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 0f                	je     802946 <alloc_block_BF+0x4b7>
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802940:	8b 12                	mov    (%edx),%edx
  802942:	89 10                	mov    %edx,(%eax)
  802944:	eb 0a                	jmp    802950 <alloc_block_BF+0x4c1>
  802946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802959:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802963:	a1 38 50 80 00       	mov    0x805038,%eax
  802968:	48                   	dec    %eax
  802969:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  80296e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802971:	e9 fc 00 00 00       	jmp    802a72 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	83 c0 08             	add    $0x8,%eax
  80297c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  80297f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802986:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80298c:	01 d0                	add    %edx,%eax
  80298e:	48                   	dec    %eax
  80298f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802992:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802995:	ba 00 00 00 00       	mov    $0x0,%edx
  80299a:	f7 75 c4             	divl   -0x3c(%ebp)
  80299d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029a0:	29 d0                	sub    %edx,%eax
  8029a2:	c1 e8 0c             	shr    $0xc,%eax
  8029a5:	83 ec 0c             	sub    $0xc,%esp
  8029a8:	50                   	push   %eax
  8029a9:	e8 37 e7 ff ff       	call   8010e5 <sbrk>
  8029ae:	83 c4 10             	add    $0x10,%esp
  8029b1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8029b4:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8029b8:	75 0a                	jne    8029c4 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8029ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bf:	e9 ae 00 00 00       	jmp    802a72 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8029c4:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8029cb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029d1:	01 d0                	add    %edx,%eax
  8029d3:	48                   	dec    %eax
  8029d4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8029d7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029da:	ba 00 00 00 00       	mov    $0x0,%edx
  8029df:	f7 75 b8             	divl   -0x48(%ebp)
  8029e2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029e5:	29 d0                	sub    %edx,%eax
  8029e7:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029ea:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029ed:	01 d0                	add    %edx,%eax
  8029ef:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8029f4:	a1 40 50 80 00       	mov    0x805040,%eax
  8029f9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8029ff:	83 ec 0c             	sub    $0xc,%esp
  802a02:	68 d8 41 80 00       	push   $0x8041d8
  802a07:	e8 3f d9 ff ff       	call   80034b <cprintf>
  802a0c:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802a0f:	83 ec 08             	sub    $0x8,%esp
  802a12:	ff 75 bc             	pushl  -0x44(%ebp)
  802a15:	68 dd 41 80 00       	push   $0x8041dd
  802a1a:	e8 2c d9 ff ff       	call   80034b <cprintf>
  802a1f:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a22:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a29:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a2c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a2f:	01 d0                	add    %edx,%eax
  802a31:	48                   	dec    %eax
  802a32:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a35:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a38:	ba 00 00 00 00       	mov    $0x0,%edx
  802a3d:	f7 75 b0             	divl   -0x50(%ebp)
  802a40:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a43:	29 d0                	sub    %edx,%eax
  802a45:	83 ec 04             	sub    $0x4,%esp
  802a48:	6a 01                	push   $0x1
  802a4a:	50                   	push   %eax
  802a4b:	ff 75 bc             	pushl  -0x44(%ebp)
  802a4e:	e8 51 f5 ff ff       	call   801fa4 <set_block_data>
  802a53:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a56:	83 ec 0c             	sub    $0xc,%esp
  802a59:	ff 75 bc             	pushl  -0x44(%ebp)
  802a5c:	e8 36 04 00 00       	call   802e97 <free_block>
  802a61:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802a64:	83 ec 0c             	sub    $0xc,%esp
  802a67:	ff 75 08             	pushl  0x8(%ebp)
  802a6a:	e8 20 fa ff ff       	call   80248f <alloc_block_BF>
  802a6f:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802a72:	c9                   	leave  
  802a73:	c3                   	ret    

00802a74 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802a74:	55                   	push   %ebp
  802a75:	89 e5                	mov    %esp,%ebp
  802a77:	53                   	push   %ebx
  802a78:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802a89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8d:	74 1e                	je     802aad <merging+0x39>
  802a8f:	ff 75 08             	pushl  0x8(%ebp)
  802a92:	e8 bc f1 ff ff       	call   801c53 <get_block_size>
  802a97:	83 c4 04             	add    $0x4,%esp
  802a9a:	89 c2                	mov    %eax,%edx
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	01 d0                	add    %edx,%eax
  802aa1:	3b 45 10             	cmp    0x10(%ebp),%eax
  802aa4:	75 07                	jne    802aad <merging+0x39>
		prev_is_free = 1;
  802aa6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802aad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ab1:	74 1e                	je     802ad1 <merging+0x5d>
  802ab3:	ff 75 10             	pushl  0x10(%ebp)
  802ab6:	e8 98 f1 ff ff       	call   801c53 <get_block_size>
  802abb:	83 c4 04             	add    $0x4,%esp
  802abe:	89 c2                	mov    %eax,%edx
  802ac0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ac3:	01 d0                	add    %edx,%eax
  802ac5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ac8:	75 07                	jne    802ad1 <merging+0x5d>
		next_is_free = 1;
  802aca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ad1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad5:	0f 84 cc 00 00 00    	je     802ba7 <merging+0x133>
  802adb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802adf:	0f 84 c2 00 00 00    	je     802ba7 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ae5:	ff 75 08             	pushl  0x8(%ebp)
  802ae8:	e8 66 f1 ff ff       	call   801c53 <get_block_size>
  802aed:	83 c4 04             	add    $0x4,%esp
  802af0:	89 c3                	mov    %eax,%ebx
  802af2:	ff 75 10             	pushl  0x10(%ebp)
  802af5:	e8 59 f1 ff ff       	call   801c53 <get_block_size>
  802afa:	83 c4 04             	add    $0x4,%esp
  802afd:	01 c3                	add    %eax,%ebx
  802aff:	ff 75 0c             	pushl  0xc(%ebp)
  802b02:	e8 4c f1 ff ff       	call   801c53 <get_block_size>
  802b07:	83 c4 04             	add    $0x4,%esp
  802b0a:	01 d8                	add    %ebx,%eax
  802b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b0f:	6a 00                	push   $0x0
  802b11:	ff 75 ec             	pushl  -0x14(%ebp)
  802b14:	ff 75 08             	pushl  0x8(%ebp)
  802b17:	e8 88 f4 ff ff       	call   801fa4 <set_block_data>
  802b1c:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802b1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b23:	75 17                	jne    802b3c <merging+0xc8>
  802b25:	83 ec 04             	sub    $0x4,%esp
  802b28:	68 13 41 80 00       	push   $0x804113
  802b2d:	68 7d 01 00 00       	push   $0x17d
  802b32:	68 31 41 80 00       	push   $0x804131
  802b37:	e8 b0 0b 00 00       	call   8036ec <_panic>
  802b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 10                	je     802b55 <merging+0xe1>
  802b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b4d:	8b 52 04             	mov    0x4(%edx),%edx
  802b50:	89 50 04             	mov    %edx,0x4(%eax)
  802b53:	eb 0b                	jmp    802b60 <merging+0xec>
  802b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	a3 30 50 80 00       	mov    %eax,0x805030
  802b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b63:	8b 40 04             	mov    0x4(%eax),%eax
  802b66:	85 c0                	test   %eax,%eax
  802b68:	74 0f                	je     802b79 <merging+0x105>
  802b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b6d:	8b 40 04             	mov    0x4(%eax),%eax
  802b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b73:	8b 12                	mov    (%edx),%edx
  802b75:	89 10                	mov    %edx,(%eax)
  802b77:	eb 0a                	jmp    802b83 <merging+0x10f>
  802b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b96:	a1 38 50 80 00       	mov    0x805038,%eax
  802b9b:	48                   	dec    %eax
  802b9c:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802ba1:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ba2:	e9 ea 02 00 00       	jmp    802e91 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ba7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bab:	74 3b                	je     802be8 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802bad:	83 ec 0c             	sub    $0xc,%esp
  802bb0:	ff 75 08             	pushl  0x8(%ebp)
  802bb3:	e8 9b f0 ff ff       	call   801c53 <get_block_size>
  802bb8:	83 c4 10             	add    $0x10,%esp
  802bbb:	89 c3                	mov    %eax,%ebx
  802bbd:	83 ec 0c             	sub    $0xc,%esp
  802bc0:	ff 75 10             	pushl  0x10(%ebp)
  802bc3:	e8 8b f0 ff ff       	call   801c53 <get_block_size>
  802bc8:	83 c4 10             	add    $0x10,%esp
  802bcb:	01 d8                	add    %ebx,%eax
  802bcd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802bd0:	83 ec 04             	sub    $0x4,%esp
  802bd3:	6a 00                	push   $0x0
  802bd5:	ff 75 e8             	pushl  -0x18(%ebp)
  802bd8:	ff 75 08             	pushl  0x8(%ebp)
  802bdb:	e8 c4 f3 ff ff       	call   801fa4 <set_block_data>
  802be0:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802be3:	e9 a9 02 00 00       	jmp    802e91 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802be8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bec:	0f 84 2d 01 00 00    	je     802d1f <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802bf2:	83 ec 0c             	sub    $0xc,%esp
  802bf5:	ff 75 10             	pushl  0x10(%ebp)
  802bf8:	e8 56 f0 ff ff       	call   801c53 <get_block_size>
  802bfd:	83 c4 10             	add    $0x10,%esp
  802c00:	89 c3                	mov    %eax,%ebx
  802c02:	83 ec 0c             	sub    $0xc,%esp
  802c05:	ff 75 0c             	pushl  0xc(%ebp)
  802c08:	e8 46 f0 ff ff       	call   801c53 <get_block_size>
  802c0d:	83 c4 10             	add    $0x10,%esp
  802c10:	01 d8                	add    %ebx,%eax
  802c12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802c15:	83 ec 04             	sub    $0x4,%esp
  802c18:	6a 00                	push   $0x0
  802c1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c1d:	ff 75 10             	pushl  0x10(%ebp)
  802c20:	e8 7f f3 ff ff       	call   801fa4 <set_block_data>
  802c25:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c28:	8b 45 10             	mov    0x10(%ebp),%eax
  802c2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c32:	74 06                	je     802c3a <merging+0x1c6>
  802c34:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c38:	75 17                	jne    802c51 <merging+0x1dd>
  802c3a:	83 ec 04             	sub    $0x4,%esp
  802c3d:	68 ec 41 80 00       	push   $0x8041ec
  802c42:	68 8d 01 00 00       	push   $0x18d
  802c47:	68 31 41 80 00       	push   $0x804131
  802c4c:	e8 9b 0a 00 00       	call   8036ec <_panic>
  802c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c54:	8b 50 04             	mov    0x4(%eax),%edx
  802c57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5a:	89 50 04             	mov    %edx,0x4(%eax)
  802c5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c63:	89 10                	mov    %edx,(%eax)
  802c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c68:	8b 40 04             	mov    0x4(%eax),%eax
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	74 0d                	je     802c7c <merging+0x208>
  802c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c72:	8b 40 04             	mov    0x4(%eax),%eax
  802c75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c78:	89 10                	mov    %edx,(%eax)
  802c7a:	eb 08                	jmp    802c84 <merging+0x210>
  802c7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c87:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c8a:	89 50 04             	mov    %edx,0x4(%eax)
  802c8d:	a1 38 50 80 00       	mov    0x805038,%eax
  802c92:	40                   	inc    %eax
  802c93:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802c98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c9c:	75 17                	jne    802cb5 <merging+0x241>
  802c9e:	83 ec 04             	sub    $0x4,%esp
  802ca1:	68 13 41 80 00       	push   $0x804113
  802ca6:	68 8e 01 00 00       	push   $0x18e
  802cab:	68 31 41 80 00       	push   $0x804131
  802cb0:	e8 37 0a 00 00       	call   8036ec <_panic>
  802cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb8:	8b 00                	mov    (%eax),%eax
  802cba:	85 c0                	test   %eax,%eax
  802cbc:	74 10                	je     802cce <merging+0x25a>
  802cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc1:	8b 00                	mov    (%eax),%eax
  802cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cc6:	8b 52 04             	mov    0x4(%edx),%edx
  802cc9:	89 50 04             	mov    %edx,0x4(%eax)
  802ccc:	eb 0b                	jmp    802cd9 <merging+0x265>
  802cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd1:	8b 40 04             	mov    0x4(%eax),%eax
  802cd4:	a3 30 50 80 00       	mov    %eax,0x805030
  802cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cdc:	8b 40 04             	mov    0x4(%eax),%eax
  802cdf:	85 c0                	test   %eax,%eax
  802ce1:	74 0f                	je     802cf2 <merging+0x27e>
  802ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cec:	8b 12                	mov    (%edx),%edx
  802cee:	89 10                	mov    %edx,(%eax)
  802cf0:	eb 0a                	jmp    802cfc <merging+0x288>
  802cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf5:	8b 00                	mov    (%eax),%eax
  802cf7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0f:	a1 38 50 80 00       	mov    0x805038,%eax
  802d14:	48                   	dec    %eax
  802d15:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d1a:	e9 72 01 00 00       	jmp    802e91 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802d1f:	8b 45 10             	mov    0x10(%ebp),%eax
  802d22:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802d25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d29:	74 79                	je     802da4 <merging+0x330>
  802d2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d2f:	74 73                	je     802da4 <merging+0x330>
  802d31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d35:	74 06                	je     802d3d <merging+0x2c9>
  802d37:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d3b:	75 17                	jne    802d54 <merging+0x2e0>
  802d3d:	83 ec 04             	sub    $0x4,%esp
  802d40:	68 a4 41 80 00       	push   $0x8041a4
  802d45:	68 94 01 00 00       	push   $0x194
  802d4a:	68 31 41 80 00       	push   $0x804131
  802d4f:	e8 98 09 00 00       	call   8036ec <_panic>
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	8b 10                	mov    (%eax),%edx
  802d59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d5c:	89 10                	mov    %edx,(%eax)
  802d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	74 0b                	je     802d72 <merging+0x2fe>
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	8b 00                	mov    (%eax),%eax
  802d6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d6f:	89 50 04             	mov    %edx,0x4(%eax)
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d78:	89 10                	mov    %edx,(%eax)
  802d7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d80:	89 50 04             	mov    %edx,0x4(%eax)
  802d83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	75 08                	jne    802d94 <merging+0x320>
  802d8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d8f:	a3 30 50 80 00       	mov    %eax,0x805030
  802d94:	a1 38 50 80 00       	mov    0x805038,%eax
  802d99:	40                   	inc    %eax
  802d9a:	a3 38 50 80 00       	mov    %eax,0x805038
  802d9f:	e9 ce 00 00 00       	jmp    802e72 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802da4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da8:	74 65                	je     802e0f <merging+0x39b>
  802daa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dae:	75 17                	jne    802dc7 <merging+0x353>
  802db0:	83 ec 04             	sub    $0x4,%esp
  802db3:	68 80 41 80 00       	push   $0x804180
  802db8:	68 95 01 00 00       	push   $0x195
  802dbd:	68 31 41 80 00       	push   $0x804131
  802dc2:	e8 25 09 00 00       	call   8036ec <_panic>
  802dc7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802dcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd0:	89 50 04             	mov    %edx,0x4(%eax)
  802dd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd6:	8b 40 04             	mov    0x4(%eax),%eax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 0c                	je     802de9 <merging+0x375>
  802ddd:	a1 30 50 80 00       	mov    0x805030,%eax
  802de2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802de5:	89 10                	mov    %edx,(%eax)
  802de7:	eb 08                	jmp    802df1 <merging+0x37d>
  802de9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802df1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df4:	a3 30 50 80 00       	mov    %eax,0x805030
  802df9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dfc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e02:	a1 38 50 80 00       	mov    0x805038,%eax
  802e07:	40                   	inc    %eax
  802e08:	a3 38 50 80 00       	mov    %eax,0x805038
  802e0d:	eb 63                	jmp    802e72 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802e0f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e13:	75 17                	jne    802e2c <merging+0x3b8>
  802e15:	83 ec 04             	sub    $0x4,%esp
  802e18:	68 4c 41 80 00       	push   $0x80414c
  802e1d:	68 98 01 00 00       	push   $0x198
  802e22:	68 31 41 80 00       	push   $0x804131
  802e27:	e8 c0 08 00 00       	call   8036ec <_panic>
  802e2c:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e35:	89 10                	mov    %edx,(%eax)
  802e37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	74 0d                	je     802e4d <merging+0x3d9>
  802e40:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e45:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e48:	89 50 04             	mov    %edx,0x4(%eax)
  802e4b:	eb 08                	jmp    802e55 <merging+0x3e1>
  802e4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e50:	a3 30 50 80 00       	mov    %eax,0x805030
  802e55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e58:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e67:	a1 38 50 80 00       	mov    0x805038,%eax
  802e6c:	40                   	inc    %eax
  802e6d:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802e72:	83 ec 0c             	sub    $0xc,%esp
  802e75:	ff 75 10             	pushl  0x10(%ebp)
  802e78:	e8 d6 ed ff ff       	call   801c53 <get_block_size>
  802e7d:	83 c4 10             	add    $0x10,%esp
  802e80:	83 ec 04             	sub    $0x4,%esp
  802e83:	6a 00                	push   $0x0
  802e85:	50                   	push   %eax
  802e86:	ff 75 10             	pushl  0x10(%ebp)
  802e89:	e8 16 f1 ff ff       	call   801fa4 <set_block_data>
  802e8e:	83 c4 10             	add    $0x10,%esp
	}
}
  802e91:	90                   	nop
  802e92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e95:	c9                   	leave  
  802e96:	c3                   	ret    

00802e97 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e97:	55                   	push   %ebp
  802e98:	89 e5                	mov    %esp,%ebp
  802e9a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802e9d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ea2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802ea5:	a1 30 50 80 00       	mov    0x805030,%eax
  802eaa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ead:	73 1b                	jae    802eca <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802eaf:	a1 30 50 80 00       	mov    0x805030,%eax
  802eb4:	83 ec 04             	sub    $0x4,%esp
  802eb7:	ff 75 08             	pushl  0x8(%ebp)
  802eba:	6a 00                	push   $0x0
  802ebc:	50                   	push   %eax
  802ebd:	e8 b2 fb ff ff       	call   802a74 <merging>
  802ec2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ec5:	e9 8b 00 00 00       	jmp    802f55 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802eca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ecf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed2:	76 18                	jbe    802eec <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802ed4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ed9:	83 ec 04             	sub    $0x4,%esp
  802edc:	ff 75 08             	pushl  0x8(%ebp)
  802edf:	50                   	push   %eax
  802ee0:	6a 00                	push   $0x0
  802ee2:	e8 8d fb ff ff       	call   802a74 <merging>
  802ee7:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802eea:	eb 69                	jmp    802f55 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802eec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ef1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef4:	eb 39                	jmp    802f2f <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802efc:	73 29                	jae    802f27 <free_block+0x90>
  802efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f06:	76 1f                	jbe    802f27 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	8b 00                	mov    (%eax),%eax
  802f0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802f10:	83 ec 04             	sub    $0x4,%esp
  802f13:	ff 75 08             	pushl  0x8(%ebp)
  802f16:	ff 75 f0             	pushl  -0x10(%ebp)
  802f19:	ff 75 f4             	pushl  -0xc(%ebp)
  802f1c:	e8 53 fb ff ff       	call   802a74 <merging>
  802f21:	83 c4 10             	add    $0x10,%esp
			break;
  802f24:	90                   	nop
		}
	}
}
  802f25:	eb 2e                	jmp    802f55 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f27:	a1 34 50 80 00       	mov    0x805034,%eax
  802f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f33:	74 07                	je     802f3c <free_block+0xa5>
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	eb 05                	jmp    802f41 <free_block+0xaa>
  802f3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f41:	a3 34 50 80 00       	mov    %eax,0x805034
  802f46:	a1 34 50 80 00       	mov    0x805034,%eax
  802f4b:	85 c0                	test   %eax,%eax
  802f4d:	75 a7                	jne    802ef6 <free_block+0x5f>
  802f4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f53:	75 a1                	jne    802ef6 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f55:	90                   	nop
  802f56:	c9                   	leave  
  802f57:	c3                   	ret    

00802f58 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f58:	55                   	push   %ebp
  802f59:	89 e5                	mov    %esp,%ebp
  802f5b:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802f5e:	ff 75 08             	pushl  0x8(%ebp)
  802f61:	e8 ed ec ff ff       	call   801c53 <get_block_size>
  802f66:	83 c4 04             	add    $0x4,%esp
  802f69:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802f6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802f73:	eb 17                	jmp    802f8c <copy_data+0x34>
  802f75:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7b:	01 c2                	add    %eax,%edx
  802f7d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	01 c8                	add    %ecx,%eax
  802f85:	8a 00                	mov    (%eax),%al
  802f87:	88 02                	mov    %al,(%edx)
  802f89:	ff 45 fc             	incl   -0x4(%ebp)
  802f8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f8f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802f92:	72 e1                	jb     802f75 <copy_data+0x1d>
}
  802f94:	90                   	nop
  802f95:	c9                   	leave  
  802f96:	c3                   	ret    

00802f97 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802f97:	55                   	push   %ebp
  802f98:	89 e5                	mov    %esp,%ebp
  802f9a:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802f9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa1:	75 23                	jne    802fc6 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802fa3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fa7:	74 13                	je     802fbc <realloc_block_FF+0x25>
  802fa9:	83 ec 0c             	sub    $0xc,%esp
  802fac:	ff 75 0c             	pushl  0xc(%ebp)
  802faf:	e8 1f f0 ff ff       	call   801fd3 <alloc_block_FF>
  802fb4:	83 c4 10             	add    $0x10,%esp
  802fb7:	e9 f4 06 00 00       	jmp    8036b0 <realloc_block_FF+0x719>
		return NULL;
  802fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc1:	e9 ea 06 00 00       	jmp    8036b0 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802fc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fca:	75 18                	jne    802fe4 <realloc_block_FF+0x4d>
	{
		free_block(va);
  802fcc:	83 ec 0c             	sub    $0xc,%esp
  802fcf:	ff 75 08             	pushl  0x8(%ebp)
  802fd2:	e8 c0 fe ff ff       	call   802e97 <free_block>
  802fd7:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802fda:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdf:	e9 cc 06 00 00       	jmp    8036b0 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  802fe4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802fe8:	77 07                	ja     802ff1 <realloc_block_FF+0x5a>
  802fea:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff4:	83 e0 01             	and    $0x1,%eax
  802ff7:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ffd:	83 c0 08             	add    $0x8,%eax
  803000:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803003:	83 ec 0c             	sub    $0xc,%esp
  803006:	ff 75 08             	pushl  0x8(%ebp)
  803009:	e8 45 ec ff ff       	call   801c53 <get_block_size>
  80300e:	83 c4 10             	add    $0x10,%esp
  803011:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803014:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803017:	83 e8 08             	sub    $0x8,%eax
  80301a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	83 e8 04             	sub    $0x4,%eax
  803023:	8b 00                	mov    (%eax),%eax
  803025:	83 e0 fe             	and    $0xfffffffe,%eax
  803028:	89 c2                	mov    %eax,%edx
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	01 d0                	add    %edx,%eax
  80302f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803032:	83 ec 0c             	sub    $0xc,%esp
  803035:	ff 75 e4             	pushl  -0x1c(%ebp)
  803038:	e8 16 ec ff ff       	call   801c53 <get_block_size>
  80303d:	83 c4 10             	add    $0x10,%esp
  803040:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803043:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803046:	83 e8 08             	sub    $0x8,%eax
  803049:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80304c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80304f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803052:	75 08                	jne    80305c <realloc_block_FF+0xc5>
	{
		 return va;
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	e9 54 06 00 00       	jmp    8036b0 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80305c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80305f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803062:	0f 83 e5 03 00 00    	jae    80344d <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803068:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80306e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803071:	83 ec 0c             	sub    $0xc,%esp
  803074:	ff 75 e4             	pushl  -0x1c(%ebp)
  803077:	e8 f0 eb ff ff       	call   801c6c <is_free_block>
  80307c:	83 c4 10             	add    $0x10,%esp
  80307f:	84 c0                	test   %al,%al
  803081:	0f 84 3b 01 00 00    	je     8031c2 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803087:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80308a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80308d:	01 d0                	add    %edx,%eax
  80308f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803092:	83 ec 04             	sub    $0x4,%esp
  803095:	6a 01                	push   $0x1
  803097:	ff 75 f0             	pushl  -0x10(%ebp)
  80309a:	ff 75 08             	pushl  0x8(%ebp)
  80309d:	e8 02 ef ff ff       	call   801fa4 <set_block_data>
  8030a2:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	83 e8 04             	sub    $0x4,%eax
  8030ab:	8b 00                	mov    (%eax),%eax
  8030ad:	83 e0 fe             	and    $0xfffffffe,%eax
  8030b0:	89 c2                	mov    %eax,%edx
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	01 d0                	add    %edx,%eax
  8030b7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8030ba:	83 ec 04             	sub    $0x4,%esp
  8030bd:	6a 00                	push   $0x0
  8030bf:	ff 75 cc             	pushl  -0x34(%ebp)
  8030c2:	ff 75 c8             	pushl  -0x38(%ebp)
  8030c5:	e8 da ee ff ff       	call   801fa4 <set_block_data>
  8030ca:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8030cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030d1:	74 06                	je     8030d9 <realloc_block_FF+0x142>
  8030d3:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8030d7:	75 17                	jne    8030f0 <realloc_block_FF+0x159>
  8030d9:	83 ec 04             	sub    $0x4,%esp
  8030dc:	68 a4 41 80 00       	push   $0x8041a4
  8030e1:	68 f6 01 00 00       	push   $0x1f6
  8030e6:	68 31 41 80 00       	push   $0x804131
  8030eb:	e8 fc 05 00 00       	call   8036ec <_panic>
  8030f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f3:	8b 10                	mov    (%eax),%edx
  8030f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030f8:	89 10                	mov    %edx,(%eax)
  8030fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030fd:	8b 00                	mov    (%eax),%eax
  8030ff:	85 c0                	test   %eax,%eax
  803101:	74 0b                	je     80310e <realloc_block_FF+0x177>
  803103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803106:	8b 00                	mov    (%eax),%eax
  803108:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80310b:	89 50 04             	mov    %edx,0x4(%eax)
  80310e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803111:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803114:	89 10                	mov    %edx,(%eax)
  803116:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803119:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80311c:	89 50 04             	mov    %edx,0x4(%eax)
  80311f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	85 c0                	test   %eax,%eax
  803126:	75 08                	jne    803130 <realloc_block_FF+0x199>
  803128:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80312b:	a3 30 50 80 00       	mov    %eax,0x805030
  803130:	a1 38 50 80 00       	mov    0x805038,%eax
  803135:	40                   	inc    %eax
  803136:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80313b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80313f:	75 17                	jne    803158 <realloc_block_FF+0x1c1>
  803141:	83 ec 04             	sub    $0x4,%esp
  803144:	68 13 41 80 00       	push   $0x804113
  803149:	68 f7 01 00 00       	push   $0x1f7
  80314e:	68 31 41 80 00       	push   $0x804131
  803153:	e8 94 05 00 00       	call   8036ec <_panic>
  803158:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 10                	je     803171 <realloc_block_FF+0x1da>
  803161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803169:	8b 52 04             	mov    0x4(%edx),%edx
  80316c:	89 50 04             	mov    %edx,0x4(%eax)
  80316f:	eb 0b                	jmp    80317c <realloc_block_FF+0x1e5>
  803171:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803174:	8b 40 04             	mov    0x4(%eax),%eax
  803177:	a3 30 50 80 00       	mov    %eax,0x805030
  80317c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317f:	8b 40 04             	mov    0x4(%eax),%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	74 0f                	je     803195 <realloc_block_FF+0x1fe>
  803186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803189:	8b 40 04             	mov    0x4(%eax),%eax
  80318c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80318f:	8b 12                	mov    (%edx),%edx
  803191:	89 10                	mov    %edx,(%eax)
  803193:	eb 0a                	jmp    80319f <realloc_block_FF+0x208>
  803195:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b2:	a1 38 50 80 00       	mov    0x805038,%eax
  8031b7:	48                   	dec    %eax
  8031b8:	a3 38 50 80 00       	mov    %eax,0x805038
  8031bd:	e9 83 02 00 00       	jmp    803445 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8031c2:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8031c6:	0f 86 69 02 00 00    	jbe    803435 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	6a 01                	push   $0x1
  8031d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8031d4:	ff 75 08             	pushl  0x8(%ebp)
  8031d7:	e8 c8 ed ff ff       	call   801fa4 <set_block_data>
  8031dc:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	83 e8 04             	sub    $0x4,%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	83 e0 fe             	and    $0xfffffffe,%eax
  8031ea:	89 c2                	mov    %eax,%edx
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	01 d0                	add    %edx,%eax
  8031f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8031f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8031f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8031fc:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803200:	75 68                	jne    80326a <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803202:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803206:	75 17                	jne    80321f <realloc_block_FF+0x288>
  803208:	83 ec 04             	sub    $0x4,%esp
  80320b:	68 4c 41 80 00       	push   $0x80414c
  803210:	68 06 02 00 00       	push   $0x206
  803215:	68 31 41 80 00       	push   $0x804131
  80321a:	e8 cd 04 00 00       	call   8036ec <_panic>
  80321f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803225:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803228:	89 10                	mov    %edx,(%eax)
  80322a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	85 c0                	test   %eax,%eax
  803231:	74 0d                	je     803240 <realloc_block_FF+0x2a9>
  803233:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803238:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80323b:	89 50 04             	mov    %edx,0x4(%eax)
  80323e:	eb 08                	jmp    803248 <realloc_block_FF+0x2b1>
  803240:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803243:	a3 30 50 80 00       	mov    %eax,0x805030
  803248:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80324b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803250:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803253:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325a:	a1 38 50 80 00       	mov    0x805038,%eax
  80325f:	40                   	inc    %eax
  803260:	a3 38 50 80 00       	mov    %eax,0x805038
  803265:	e9 b0 01 00 00       	jmp    80341a <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80326a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80326f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803272:	76 68                	jbe    8032dc <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803274:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803278:	75 17                	jne    803291 <realloc_block_FF+0x2fa>
  80327a:	83 ec 04             	sub    $0x4,%esp
  80327d:	68 4c 41 80 00       	push   $0x80414c
  803282:	68 0b 02 00 00       	push   $0x20b
  803287:	68 31 41 80 00       	push   $0x804131
  80328c:	e8 5b 04 00 00       	call   8036ec <_panic>
  803291:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803297:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80329a:	89 10                	mov    %edx,(%eax)
  80329c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	85 c0                	test   %eax,%eax
  8032a3:	74 0d                	je     8032b2 <realloc_block_FF+0x31b>
  8032a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032aa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032ad:	89 50 04             	mov    %edx,0x4(%eax)
  8032b0:	eb 08                	jmp    8032ba <realloc_block_FF+0x323>
  8032b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8032ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032cc:	a1 38 50 80 00       	mov    0x805038,%eax
  8032d1:	40                   	inc    %eax
  8032d2:	a3 38 50 80 00       	mov    %eax,0x805038
  8032d7:	e9 3e 01 00 00       	jmp    80341a <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8032dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032e1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032e4:	73 68                	jae    80334e <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032e6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032ea:	75 17                	jne    803303 <realloc_block_FF+0x36c>
  8032ec:	83 ec 04             	sub    $0x4,%esp
  8032ef:	68 80 41 80 00       	push   $0x804180
  8032f4:	68 10 02 00 00       	push   $0x210
  8032f9:	68 31 41 80 00       	push   $0x804131
  8032fe:	e8 e9 03 00 00       	call   8036ec <_panic>
  803303:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803309:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80330c:	89 50 04             	mov    %edx,0x4(%eax)
  80330f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803312:	8b 40 04             	mov    0x4(%eax),%eax
  803315:	85 c0                	test   %eax,%eax
  803317:	74 0c                	je     803325 <realloc_block_FF+0x38e>
  803319:	a1 30 50 80 00       	mov    0x805030,%eax
  80331e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803321:	89 10                	mov    %edx,(%eax)
  803323:	eb 08                	jmp    80332d <realloc_block_FF+0x396>
  803325:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803328:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80332d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803330:	a3 30 50 80 00       	mov    %eax,0x805030
  803335:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333e:	a1 38 50 80 00       	mov    0x805038,%eax
  803343:	40                   	inc    %eax
  803344:	a3 38 50 80 00       	mov    %eax,0x805038
  803349:	e9 cc 00 00 00       	jmp    80341a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80334e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803355:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80335a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80335d:	e9 8a 00 00 00       	jmp    8033ec <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803365:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803368:	73 7a                	jae    8033e4 <realloc_block_FF+0x44d>
  80336a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336d:	8b 00                	mov    (%eax),%eax
  80336f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803372:	73 70                	jae    8033e4 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803378:	74 06                	je     803380 <realloc_block_FF+0x3e9>
  80337a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80337e:	75 17                	jne    803397 <realloc_block_FF+0x400>
  803380:	83 ec 04             	sub    $0x4,%esp
  803383:	68 a4 41 80 00       	push   $0x8041a4
  803388:	68 1a 02 00 00       	push   $0x21a
  80338d:	68 31 41 80 00       	push   $0x804131
  803392:	e8 55 03 00 00       	call   8036ec <_panic>
  803397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339a:	8b 10                	mov    (%eax),%edx
  80339c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80339f:	89 10                	mov    %edx,(%eax)
  8033a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a4:	8b 00                	mov    (%eax),%eax
  8033a6:	85 c0                	test   %eax,%eax
  8033a8:	74 0b                	je     8033b5 <realloc_block_FF+0x41e>
  8033aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ad:	8b 00                	mov    (%eax),%eax
  8033af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033b2:	89 50 04             	mov    %edx,0x4(%eax)
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033bb:	89 10                	mov    %edx,(%eax)
  8033bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033c3:	89 50 04             	mov    %edx,0x4(%eax)
  8033c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c9:	8b 00                	mov    (%eax),%eax
  8033cb:	85 c0                	test   %eax,%eax
  8033cd:	75 08                	jne    8033d7 <realloc_block_FF+0x440>
  8033cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d2:	a3 30 50 80 00       	mov    %eax,0x805030
  8033d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8033dc:	40                   	inc    %eax
  8033dd:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8033e2:	eb 36                	jmp    80341a <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8033e4:	a1 34 50 80 00       	mov    0x805034,%eax
  8033e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f0:	74 07                	je     8033f9 <realloc_block_FF+0x462>
  8033f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f5:	8b 00                	mov    (%eax),%eax
  8033f7:	eb 05                	jmp    8033fe <realloc_block_FF+0x467>
  8033f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033fe:	a3 34 50 80 00       	mov    %eax,0x805034
  803403:	a1 34 50 80 00       	mov    0x805034,%eax
  803408:	85 c0                	test   %eax,%eax
  80340a:	0f 85 52 ff ff ff    	jne    803362 <realloc_block_FF+0x3cb>
  803410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803414:	0f 85 48 ff ff ff    	jne    803362 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80341a:	83 ec 04             	sub    $0x4,%esp
  80341d:	6a 00                	push   $0x0
  80341f:	ff 75 d8             	pushl  -0x28(%ebp)
  803422:	ff 75 d4             	pushl  -0x2c(%ebp)
  803425:	e8 7a eb ff ff       	call   801fa4 <set_block_data>
  80342a:	83 c4 10             	add    $0x10,%esp
				return va;
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	e9 7b 02 00 00       	jmp    8036b0 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803435:	83 ec 0c             	sub    $0xc,%esp
  803438:	68 21 42 80 00       	push   $0x804221
  80343d:	e8 09 cf ff ff       	call   80034b <cprintf>
  803442:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	e9 63 02 00 00       	jmp    8036b0 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  80344d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803450:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803453:	0f 86 4d 02 00 00    	jbe    8036a6 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803459:	83 ec 0c             	sub    $0xc,%esp
  80345c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80345f:	e8 08 e8 ff ff       	call   801c6c <is_free_block>
  803464:	83 c4 10             	add    $0x10,%esp
  803467:	84 c0                	test   %al,%al
  803469:	0f 84 37 02 00 00    	je     8036a6 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80346f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803472:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803475:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803478:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80347b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80347e:	76 38                	jbe    8034b8 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803480:	83 ec 0c             	sub    $0xc,%esp
  803483:	ff 75 08             	pushl  0x8(%ebp)
  803486:	e8 0c fa ff ff       	call   802e97 <free_block>
  80348b:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  80348e:	83 ec 0c             	sub    $0xc,%esp
  803491:	ff 75 0c             	pushl  0xc(%ebp)
  803494:	e8 3a eb ff ff       	call   801fd3 <alloc_block_FF>
  803499:	83 c4 10             	add    $0x10,%esp
  80349c:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80349f:	83 ec 08             	sub    $0x8,%esp
  8034a2:	ff 75 c0             	pushl  -0x40(%ebp)
  8034a5:	ff 75 08             	pushl  0x8(%ebp)
  8034a8:	e8 ab fa ff ff       	call   802f58 <copy_data>
  8034ad:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8034b0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034b3:	e9 f8 01 00 00       	jmp    8036b0 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8034b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034bb:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8034be:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8034c1:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8034c5:	0f 87 a0 00 00 00    	ja     80356b <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8034cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034cf:	75 17                	jne    8034e8 <realloc_block_FF+0x551>
  8034d1:	83 ec 04             	sub    $0x4,%esp
  8034d4:	68 13 41 80 00       	push   $0x804113
  8034d9:	68 38 02 00 00       	push   $0x238
  8034de:	68 31 41 80 00       	push   $0x804131
  8034e3:	e8 04 02 00 00       	call   8036ec <_panic>
  8034e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034eb:	8b 00                	mov    (%eax),%eax
  8034ed:	85 c0                	test   %eax,%eax
  8034ef:	74 10                	je     803501 <realloc_block_FF+0x56a>
  8034f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f4:	8b 00                	mov    (%eax),%eax
  8034f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034f9:	8b 52 04             	mov    0x4(%edx),%edx
  8034fc:	89 50 04             	mov    %edx,0x4(%eax)
  8034ff:	eb 0b                	jmp    80350c <realloc_block_FF+0x575>
  803501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803504:	8b 40 04             	mov    0x4(%eax),%eax
  803507:	a3 30 50 80 00       	mov    %eax,0x805030
  80350c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350f:	8b 40 04             	mov    0x4(%eax),%eax
  803512:	85 c0                	test   %eax,%eax
  803514:	74 0f                	je     803525 <realloc_block_FF+0x58e>
  803516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803519:	8b 40 04             	mov    0x4(%eax),%eax
  80351c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80351f:	8b 12                	mov    (%edx),%edx
  803521:	89 10                	mov    %edx,(%eax)
  803523:	eb 0a                	jmp    80352f <realloc_block_FF+0x598>
  803525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803528:	8b 00                	mov    (%eax),%eax
  80352a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80352f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803532:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803542:	a1 38 50 80 00       	mov    0x805038,%eax
  803547:	48                   	dec    %eax
  803548:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80354d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803550:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803553:	01 d0                	add    %edx,%eax
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	6a 01                	push   $0x1
  80355a:	50                   	push   %eax
  80355b:	ff 75 08             	pushl  0x8(%ebp)
  80355e:	e8 41 ea ff ff       	call   801fa4 <set_block_data>
  803563:	83 c4 10             	add    $0x10,%esp
  803566:	e9 36 01 00 00       	jmp    8036a1 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80356b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80356e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803571:	01 d0                	add    %edx,%eax
  803573:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803576:	83 ec 04             	sub    $0x4,%esp
  803579:	6a 01                	push   $0x1
  80357b:	ff 75 f0             	pushl  -0x10(%ebp)
  80357e:	ff 75 08             	pushl  0x8(%ebp)
  803581:	e8 1e ea ff ff       	call   801fa4 <set_block_data>
  803586:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	83 e8 04             	sub    $0x4,%eax
  80358f:	8b 00                	mov    (%eax),%eax
  803591:	83 e0 fe             	and    $0xfffffffe,%eax
  803594:	89 c2                	mov    %eax,%edx
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	01 d0                	add    %edx,%eax
  80359b:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  80359e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a2:	74 06                	je     8035aa <realloc_block_FF+0x613>
  8035a4:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8035a8:	75 17                	jne    8035c1 <realloc_block_FF+0x62a>
  8035aa:	83 ec 04             	sub    $0x4,%esp
  8035ad:	68 a4 41 80 00       	push   $0x8041a4
  8035b2:	68 44 02 00 00       	push   $0x244
  8035b7:	68 31 41 80 00       	push   $0x804131
  8035bc:	e8 2b 01 00 00       	call   8036ec <_panic>
  8035c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c4:	8b 10                	mov    (%eax),%edx
  8035c6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035c9:	89 10                	mov    %edx,(%eax)
  8035cb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035ce:	8b 00                	mov    (%eax),%eax
  8035d0:	85 c0                	test   %eax,%eax
  8035d2:	74 0b                	je     8035df <realloc_block_FF+0x648>
  8035d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d7:	8b 00                	mov    (%eax),%eax
  8035d9:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035dc:	89 50 04             	mov    %edx,0x4(%eax)
  8035df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035e5:	89 10                	mov    %edx,(%eax)
  8035e7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035ed:	89 50 04             	mov    %edx,0x4(%eax)
  8035f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035f3:	8b 00                	mov    (%eax),%eax
  8035f5:	85 c0                	test   %eax,%eax
  8035f7:	75 08                	jne    803601 <realloc_block_FF+0x66a>
  8035f9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035fc:	a3 30 50 80 00       	mov    %eax,0x805030
  803601:	a1 38 50 80 00       	mov    0x805038,%eax
  803606:	40                   	inc    %eax
  803607:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80360c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803610:	75 17                	jne    803629 <realloc_block_FF+0x692>
  803612:	83 ec 04             	sub    $0x4,%esp
  803615:	68 13 41 80 00       	push   $0x804113
  80361a:	68 45 02 00 00       	push   $0x245
  80361f:	68 31 41 80 00       	push   $0x804131
  803624:	e8 c3 00 00 00       	call   8036ec <_panic>
  803629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362c:	8b 00                	mov    (%eax),%eax
  80362e:	85 c0                	test   %eax,%eax
  803630:	74 10                	je     803642 <realloc_block_FF+0x6ab>
  803632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803635:	8b 00                	mov    (%eax),%eax
  803637:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80363a:	8b 52 04             	mov    0x4(%edx),%edx
  80363d:	89 50 04             	mov    %edx,0x4(%eax)
  803640:	eb 0b                	jmp    80364d <realloc_block_FF+0x6b6>
  803642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803645:	8b 40 04             	mov    0x4(%eax),%eax
  803648:	a3 30 50 80 00       	mov    %eax,0x805030
  80364d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803650:	8b 40 04             	mov    0x4(%eax),%eax
  803653:	85 c0                	test   %eax,%eax
  803655:	74 0f                	je     803666 <realloc_block_FF+0x6cf>
  803657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365a:	8b 40 04             	mov    0x4(%eax),%eax
  80365d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803660:	8b 12                	mov    (%edx),%edx
  803662:	89 10                	mov    %edx,(%eax)
  803664:	eb 0a                	jmp    803670 <realloc_block_FF+0x6d9>
  803666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803669:	8b 00                	mov    (%eax),%eax
  80366b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803673:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803683:	a1 38 50 80 00       	mov    0x805038,%eax
  803688:	48                   	dec    %eax
  803689:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80368e:	83 ec 04             	sub    $0x4,%esp
  803691:	6a 00                	push   $0x0
  803693:	ff 75 bc             	pushl  -0x44(%ebp)
  803696:	ff 75 b8             	pushl  -0x48(%ebp)
  803699:	e8 06 e9 ff ff       	call   801fa4 <set_block_data>
  80369e:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8036a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a4:	eb 0a                	jmp    8036b0 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8036a6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8036ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8036b0:	c9                   	leave  
  8036b1:	c3                   	ret    

008036b2 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8036b2:	55                   	push   %ebp
  8036b3:	89 e5                	mov    %esp,%ebp
  8036b5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8036b8:	83 ec 04             	sub    $0x4,%esp
  8036bb:	68 28 42 80 00       	push   $0x804228
  8036c0:	68 58 02 00 00       	push   $0x258
  8036c5:	68 31 41 80 00       	push   $0x804131
  8036ca:	e8 1d 00 00 00       	call   8036ec <_panic>

008036cf <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8036cf:	55                   	push   %ebp
  8036d0:	89 e5                	mov    %esp,%ebp
  8036d2:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8036d5:	83 ec 04             	sub    $0x4,%esp
  8036d8:	68 50 42 80 00       	push   $0x804250
  8036dd:	68 61 02 00 00       	push   $0x261
  8036e2:	68 31 41 80 00       	push   $0x804131
  8036e7:	e8 00 00 00 00       	call   8036ec <_panic>

008036ec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8036ec:	55                   	push   %ebp
  8036ed:	89 e5                	mov    %esp,%ebp
  8036ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8036f2:	8d 45 10             	lea    0x10(%ebp),%eax
  8036f5:	83 c0 04             	add    $0x4,%eax
  8036f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8036fb:	a1 60 50 98 00       	mov    0x985060,%eax
  803700:	85 c0                	test   %eax,%eax
  803702:	74 16                	je     80371a <_panic+0x2e>
		cprintf("%s: ", argv0);
  803704:	a1 60 50 98 00       	mov    0x985060,%eax
  803709:	83 ec 08             	sub    $0x8,%esp
  80370c:	50                   	push   %eax
  80370d:	68 78 42 80 00       	push   $0x804278
  803712:	e8 34 cc ff ff       	call   80034b <cprintf>
  803717:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80371a:	a1 00 50 80 00       	mov    0x805000,%eax
  80371f:	ff 75 0c             	pushl  0xc(%ebp)
  803722:	ff 75 08             	pushl  0x8(%ebp)
  803725:	50                   	push   %eax
  803726:	68 7d 42 80 00       	push   $0x80427d
  80372b:	e8 1b cc ff ff       	call   80034b <cprintf>
  803730:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803733:	8b 45 10             	mov    0x10(%ebp),%eax
  803736:	83 ec 08             	sub    $0x8,%esp
  803739:	ff 75 f4             	pushl  -0xc(%ebp)
  80373c:	50                   	push   %eax
  80373d:	e8 9e cb ff ff       	call   8002e0 <vcprintf>
  803742:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803745:	83 ec 08             	sub    $0x8,%esp
  803748:	6a 00                	push   $0x0
  80374a:	68 99 42 80 00       	push   $0x804299
  80374f:	e8 8c cb ff ff       	call   8002e0 <vcprintf>
  803754:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803757:	e8 0d cb ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  80375c:	eb fe                	jmp    80375c <_panic+0x70>

0080375e <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80375e:	55                   	push   %ebp
  80375f:	89 e5                	mov    %esp,%ebp
  803761:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803764:	a1 20 50 80 00       	mov    0x805020,%eax
  803769:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80376f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803772:	39 c2                	cmp    %eax,%edx
  803774:	74 14                	je     80378a <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803776:	83 ec 04             	sub    $0x4,%esp
  803779:	68 9c 42 80 00       	push   $0x80429c
  80377e:	6a 26                	push   $0x26
  803780:	68 e8 42 80 00       	push   $0x8042e8
  803785:	e8 62 ff ff ff       	call   8036ec <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80378a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803791:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803798:	e9 c5 00 00 00       	jmp    803862 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80379d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	01 d0                	add    %edx,%eax
  8037ac:	8b 00                	mov    (%eax),%eax
  8037ae:	85 c0                	test   %eax,%eax
  8037b0:	75 08                	jne    8037ba <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8037b2:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8037b5:	e9 a5 00 00 00       	jmp    80385f <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8037ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8037c8:	eb 69                	jmp    803833 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8037ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8037cf:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8037d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037d8:	89 d0                	mov    %edx,%eax
  8037da:	01 c0                	add    %eax,%eax
  8037dc:	01 d0                	add    %edx,%eax
  8037de:	c1 e0 03             	shl    $0x3,%eax
  8037e1:	01 c8                	add    %ecx,%eax
  8037e3:	8a 40 04             	mov    0x4(%eax),%al
  8037e6:	84 c0                	test   %al,%al
  8037e8:	75 46                	jne    803830 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8037ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8037ef:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8037f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037f8:	89 d0                	mov    %edx,%eax
  8037fa:	01 c0                	add    %eax,%eax
  8037fc:	01 d0                	add    %edx,%eax
  8037fe:	c1 e0 03             	shl    $0x3,%eax
  803801:	01 c8                	add    %ecx,%eax
  803803:	8b 00                	mov    (%eax),%eax
  803805:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803808:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80380b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803810:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803815:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80381c:	8b 45 08             	mov    0x8(%ebp),%eax
  80381f:	01 c8                	add    %ecx,%eax
  803821:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803823:	39 c2                	cmp    %eax,%edx
  803825:	75 09                	jne    803830 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803827:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80382e:	eb 15                	jmp    803845 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803830:	ff 45 e8             	incl   -0x18(%ebp)
  803833:	a1 20 50 80 00       	mov    0x805020,%eax
  803838:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80383e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803841:	39 c2                	cmp    %eax,%edx
  803843:	77 85                	ja     8037ca <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803845:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803849:	75 14                	jne    80385f <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80384b:	83 ec 04             	sub    $0x4,%esp
  80384e:	68 f4 42 80 00       	push   $0x8042f4
  803853:	6a 3a                	push   $0x3a
  803855:	68 e8 42 80 00       	push   $0x8042e8
  80385a:	e8 8d fe ff ff       	call   8036ec <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80385f:	ff 45 f0             	incl   -0x10(%ebp)
  803862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803865:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803868:	0f 8c 2f ff ff ff    	jl     80379d <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80386e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803875:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80387c:	eb 26                	jmp    8038a4 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80387e:	a1 20 50 80 00       	mov    0x805020,%eax
  803883:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803889:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80388c:	89 d0                	mov    %edx,%eax
  80388e:	01 c0                	add    %eax,%eax
  803890:	01 d0                	add    %edx,%eax
  803892:	c1 e0 03             	shl    $0x3,%eax
  803895:	01 c8                	add    %ecx,%eax
  803897:	8a 40 04             	mov    0x4(%eax),%al
  80389a:	3c 01                	cmp    $0x1,%al
  80389c:	75 03                	jne    8038a1 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80389e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038a1:	ff 45 e0             	incl   -0x20(%ebp)
  8038a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8038a9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8038af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038b2:	39 c2                	cmp    %eax,%edx
  8038b4:	77 c8                	ja     80387e <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8038b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8038bc:	74 14                	je     8038d2 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8038be:	83 ec 04             	sub    $0x4,%esp
  8038c1:	68 48 43 80 00       	push   $0x804348
  8038c6:	6a 44                	push   $0x44
  8038c8:	68 e8 42 80 00       	push   $0x8042e8
  8038cd:	e8 1a fe ff ff       	call   8036ec <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8038d2:	90                   	nop
  8038d3:	c9                   	leave  
  8038d4:	c3                   	ret    
  8038d5:	66 90                	xchg   %ax,%ax
  8038d7:	90                   	nop

008038d8 <__udivdi3>:
  8038d8:	55                   	push   %ebp
  8038d9:	57                   	push   %edi
  8038da:	56                   	push   %esi
  8038db:	53                   	push   %ebx
  8038dc:	83 ec 1c             	sub    $0x1c,%esp
  8038df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038ef:	89 ca                	mov    %ecx,%edx
  8038f1:	89 f8                	mov    %edi,%eax
  8038f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038f7:	85 f6                	test   %esi,%esi
  8038f9:	75 2d                	jne    803928 <__udivdi3+0x50>
  8038fb:	39 cf                	cmp    %ecx,%edi
  8038fd:	77 65                	ja     803964 <__udivdi3+0x8c>
  8038ff:	89 fd                	mov    %edi,%ebp
  803901:	85 ff                	test   %edi,%edi
  803903:	75 0b                	jne    803910 <__udivdi3+0x38>
  803905:	b8 01 00 00 00       	mov    $0x1,%eax
  80390a:	31 d2                	xor    %edx,%edx
  80390c:	f7 f7                	div    %edi
  80390e:	89 c5                	mov    %eax,%ebp
  803910:	31 d2                	xor    %edx,%edx
  803912:	89 c8                	mov    %ecx,%eax
  803914:	f7 f5                	div    %ebp
  803916:	89 c1                	mov    %eax,%ecx
  803918:	89 d8                	mov    %ebx,%eax
  80391a:	f7 f5                	div    %ebp
  80391c:	89 cf                	mov    %ecx,%edi
  80391e:	89 fa                	mov    %edi,%edx
  803920:	83 c4 1c             	add    $0x1c,%esp
  803923:	5b                   	pop    %ebx
  803924:	5e                   	pop    %esi
  803925:	5f                   	pop    %edi
  803926:	5d                   	pop    %ebp
  803927:	c3                   	ret    
  803928:	39 ce                	cmp    %ecx,%esi
  80392a:	77 28                	ja     803954 <__udivdi3+0x7c>
  80392c:	0f bd fe             	bsr    %esi,%edi
  80392f:	83 f7 1f             	xor    $0x1f,%edi
  803932:	75 40                	jne    803974 <__udivdi3+0x9c>
  803934:	39 ce                	cmp    %ecx,%esi
  803936:	72 0a                	jb     803942 <__udivdi3+0x6a>
  803938:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80393c:	0f 87 9e 00 00 00    	ja     8039e0 <__udivdi3+0x108>
  803942:	b8 01 00 00 00       	mov    $0x1,%eax
  803947:	89 fa                	mov    %edi,%edx
  803949:	83 c4 1c             	add    $0x1c,%esp
  80394c:	5b                   	pop    %ebx
  80394d:	5e                   	pop    %esi
  80394e:	5f                   	pop    %edi
  80394f:	5d                   	pop    %ebp
  803950:	c3                   	ret    
  803951:	8d 76 00             	lea    0x0(%esi),%esi
  803954:	31 ff                	xor    %edi,%edi
  803956:	31 c0                	xor    %eax,%eax
  803958:	89 fa                	mov    %edi,%edx
  80395a:	83 c4 1c             	add    $0x1c,%esp
  80395d:	5b                   	pop    %ebx
  80395e:	5e                   	pop    %esi
  80395f:	5f                   	pop    %edi
  803960:	5d                   	pop    %ebp
  803961:	c3                   	ret    
  803962:	66 90                	xchg   %ax,%ax
  803964:	89 d8                	mov    %ebx,%eax
  803966:	f7 f7                	div    %edi
  803968:	31 ff                	xor    %edi,%edi
  80396a:	89 fa                	mov    %edi,%edx
  80396c:	83 c4 1c             	add    $0x1c,%esp
  80396f:	5b                   	pop    %ebx
  803970:	5e                   	pop    %esi
  803971:	5f                   	pop    %edi
  803972:	5d                   	pop    %ebp
  803973:	c3                   	ret    
  803974:	bd 20 00 00 00       	mov    $0x20,%ebp
  803979:	89 eb                	mov    %ebp,%ebx
  80397b:	29 fb                	sub    %edi,%ebx
  80397d:	89 f9                	mov    %edi,%ecx
  80397f:	d3 e6                	shl    %cl,%esi
  803981:	89 c5                	mov    %eax,%ebp
  803983:	88 d9                	mov    %bl,%cl
  803985:	d3 ed                	shr    %cl,%ebp
  803987:	89 e9                	mov    %ebp,%ecx
  803989:	09 f1                	or     %esi,%ecx
  80398b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80398f:	89 f9                	mov    %edi,%ecx
  803991:	d3 e0                	shl    %cl,%eax
  803993:	89 c5                	mov    %eax,%ebp
  803995:	89 d6                	mov    %edx,%esi
  803997:	88 d9                	mov    %bl,%cl
  803999:	d3 ee                	shr    %cl,%esi
  80399b:	89 f9                	mov    %edi,%ecx
  80399d:	d3 e2                	shl    %cl,%edx
  80399f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039a3:	88 d9                	mov    %bl,%cl
  8039a5:	d3 e8                	shr    %cl,%eax
  8039a7:	09 c2                	or     %eax,%edx
  8039a9:	89 d0                	mov    %edx,%eax
  8039ab:	89 f2                	mov    %esi,%edx
  8039ad:	f7 74 24 0c          	divl   0xc(%esp)
  8039b1:	89 d6                	mov    %edx,%esi
  8039b3:	89 c3                	mov    %eax,%ebx
  8039b5:	f7 e5                	mul    %ebp
  8039b7:	39 d6                	cmp    %edx,%esi
  8039b9:	72 19                	jb     8039d4 <__udivdi3+0xfc>
  8039bb:	74 0b                	je     8039c8 <__udivdi3+0xf0>
  8039bd:	89 d8                	mov    %ebx,%eax
  8039bf:	31 ff                	xor    %edi,%edi
  8039c1:	e9 58 ff ff ff       	jmp    80391e <__udivdi3+0x46>
  8039c6:	66 90                	xchg   %ax,%ax
  8039c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039cc:	89 f9                	mov    %edi,%ecx
  8039ce:	d3 e2                	shl    %cl,%edx
  8039d0:	39 c2                	cmp    %eax,%edx
  8039d2:	73 e9                	jae    8039bd <__udivdi3+0xe5>
  8039d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039d7:	31 ff                	xor    %edi,%edi
  8039d9:	e9 40 ff ff ff       	jmp    80391e <__udivdi3+0x46>
  8039de:	66 90                	xchg   %ax,%ax
  8039e0:	31 c0                	xor    %eax,%eax
  8039e2:	e9 37 ff ff ff       	jmp    80391e <__udivdi3+0x46>
  8039e7:	90                   	nop

008039e8 <__umoddi3>:
  8039e8:	55                   	push   %ebp
  8039e9:	57                   	push   %edi
  8039ea:	56                   	push   %esi
  8039eb:	53                   	push   %ebx
  8039ec:	83 ec 1c             	sub    $0x1c,%esp
  8039ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a07:	89 f3                	mov    %esi,%ebx
  803a09:	89 fa                	mov    %edi,%edx
  803a0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a0f:	89 34 24             	mov    %esi,(%esp)
  803a12:	85 c0                	test   %eax,%eax
  803a14:	75 1a                	jne    803a30 <__umoddi3+0x48>
  803a16:	39 f7                	cmp    %esi,%edi
  803a18:	0f 86 a2 00 00 00    	jbe    803ac0 <__umoddi3+0xd8>
  803a1e:	89 c8                	mov    %ecx,%eax
  803a20:	89 f2                	mov    %esi,%edx
  803a22:	f7 f7                	div    %edi
  803a24:	89 d0                	mov    %edx,%eax
  803a26:	31 d2                	xor    %edx,%edx
  803a28:	83 c4 1c             	add    $0x1c,%esp
  803a2b:	5b                   	pop    %ebx
  803a2c:	5e                   	pop    %esi
  803a2d:	5f                   	pop    %edi
  803a2e:	5d                   	pop    %ebp
  803a2f:	c3                   	ret    
  803a30:	39 f0                	cmp    %esi,%eax
  803a32:	0f 87 ac 00 00 00    	ja     803ae4 <__umoddi3+0xfc>
  803a38:	0f bd e8             	bsr    %eax,%ebp
  803a3b:	83 f5 1f             	xor    $0x1f,%ebp
  803a3e:	0f 84 ac 00 00 00    	je     803af0 <__umoddi3+0x108>
  803a44:	bf 20 00 00 00       	mov    $0x20,%edi
  803a49:	29 ef                	sub    %ebp,%edi
  803a4b:	89 fe                	mov    %edi,%esi
  803a4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a51:	89 e9                	mov    %ebp,%ecx
  803a53:	d3 e0                	shl    %cl,%eax
  803a55:	89 d7                	mov    %edx,%edi
  803a57:	89 f1                	mov    %esi,%ecx
  803a59:	d3 ef                	shr    %cl,%edi
  803a5b:	09 c7                	or     %eax,%edi
  803a5d:	89 e9                	mov    %ebp,%ecx
  803a5f:	d3 e2                	shl    %cl,%edx
  803a61:	89 14 24             	mov    %edx,(%esp)
  803a64:	89 d8                	mov    %ebx,%eax
  803a66:	d3 e0                	shl    %cl,%eax
  803a68:	89 c2                	mov    %eax,%edx
  803a6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a6e:	d3 e0                	shl    %cl,%eax
  803a70:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a74:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a78:	89 f1                	mov    %esi,%ecx
  803a7a:	d3 e8                	shr    %cl,%eax
  803a7c:	09 d0                	or     %edx,%eax
  803a7e:	d3 eb                	shr    %cl,%ebx
  803a80:	89 da                	mov    %ebx,%edx
  803a82:	f7 f7                	div    %edi
  803a84:	89 d3                	mov    %edx,%ebx
  803a86:	f7 24 24             	mull   (%esp)
  803a89:	89 c6                	mov    %eax,%esi
  803a8b:	89 d1                	mov    %edx,%ecx
  803a8d:	39 d3                	cmp    %edx,%ebx
  803a8f:	0f 82 87 00 00 00    	jb     803b1c <__umoddi3+0x134>
  803a95:	0f 84 91 00 00 00    	je     803b2c <__umoddi3+0x144>
  803a9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a9f:	29 f2                	sub    %esi,%edx
  803aa1:	19 cb                	sbb    %ecx,%ebx
  803aa3:	89 d8                	mov    %ebx,%eax
  803aa5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803aa9:	d3 e0                	shl    %cl,%eax
  803aab:	89 e9                	mov    %ebp,%ecx
  803aad:	d3 ea                	shr    %cl,%edx
  803aaf:	09 d0                	or     %edx,%eax
  803ab1:	89 e9                	mov    %ebp,%ecx
  803ab3:	d3 eb                	shr    %cl,%ebx
  803ab5:	89 da                	mov    %ebx,%edx
  803ab7:	83 c4 1c             	add    $0x1c,%esp
  803aba:	5b                   	pop    %ebx
  803abb:	5e                   	pop    %esi
  803abc:	5f                   	pop    %edi
  803abd:	5d                   	pop    %ebp
  803abe:	c3                   	ret    
  803abf:	90                   	nop
  803ac0:	89 fd                	mov    %edi,%ebp
  803ac2:	85 ff                	test   %edi,%edi
  803ac4:	75 0b                	jne    803ad1 <__umoddi3+0xe9>
  803ac6:	b8 01 00 00 00       	mov    $0x1,%eax
  803acb:	31 d2                	xor    %edx,%edx
  803acd:	f7 f7                	div    %edi
  803acf:	89 c5                	mov    %eax,%ebp
  803ad1:	89 f0                	mov    %esi,%eax
  803ad3:	31 d2                	xor    %edx,%edx
  803ad5:	f7 f5                	div    %ebp
  803ad7:	89 c8                	mov    %ecx,%eax
  803ad9:	f7 f5                	div    %ebp
  803adb:	89 d0                	mov    %edx,%eax
  803add:	e9 44 ff ff ff       	jmp    803a26 <__umoddi3+0x3e>
  803ae2:	66 90                	xchg   %ax,%ax
  803ae4:	89 c8                	mov    %ecx,%eax
  803ae6:	89 f2                	mov    %esi,%edx
  803ae8:	83 c4 1c             	add    $0x1c,%esp
  803aeb:	5b                   	pop    %ebx
  803aec:	5e                   	pop    %esi
  803aed:	5f                   	pop    %edi
  803aee:	5d                   	pop    %ebp
  803aef:	c3                   	ret    
  803af0:	3b 04 24             	cmp    (%esp),%eax
  803af3:	72 06                	jb     803afb <__umoddi3+0x113>
  803af5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803af9:	77 0f                	ja     803b0a <__umoddi3+0x122>
  803afb:	89 f2                	mov    %esi,%edx
  803afd:	29 f9                	sub    %edi,%ecx
  803aff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b03:	89 14 24             	mov    %edx,(%esp)
  803b06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b0e:	8b 14 24             	mov    (%esp),%edx
  803b11:	83 c4 1c             	add    $0x1c,%esp
  803b14:	5b                   	pop    %ebx
  803b15:	5e                   	pop    %esi
  803b16:	5f                   	pop    %edi
  803b17:	5d                   	pop    %ebp
  803b18:	c3                   	ret    
  803b19:	8d 76 00             	lea    0x0(%esi),%esi
  803b1c:	2b 04 24             	sub    (%esp),%eax
  803b1f:	19 fa                	sbb    %edi,%edx
  803b21:	89 d1                	mov    %edx,%ecx
  803b23:	89 c6                	mov    %eax,%esi
  803b25:	e9 71 ff ff ff       	jmp    803a9b <__umoddi3+0xb3>
  803b2a:	66 90                	xchg   %ax,%ax
  803b2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b30:	72 ea                	jb     803b1c <__umoddi3+0x134>
  803b32:	89 d9                	mov    %ebx,%ecx
  803b34:	e9 62 ff ff ff       	jmp    803a9b <__umoddi3+0xb3>
