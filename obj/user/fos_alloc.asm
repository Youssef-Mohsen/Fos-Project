
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
  80005c:	68 e0 3a 80 00       	push   $0x803ae0
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
  8000b9:	68 f3 3a 80 00       	push   $0x803af3
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
  80010f:	68 f3 3a 80 00       	push   $0x803af3
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
  80013e:	e8 63 17 00 00       	call   8018a6 <sys_getenvindex>
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
  8001ac:	e8 79 14 00 00       	call   80162a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 18 3b 80 00       	push   $0x803b18
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
  8001dc:	68 40 3b 80 00       	push   $0x803b40
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
  80020d:	68 68 3b 80 00       	push   $0x803b68
  800212:	e8 34 01 00 00       	call   80034b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 c0 3b 80 00       	push   $0x803bc0
  80022e:	e8 18 01 00 00       	call   80034b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 18 3b 80 00       	push   $0x803b18
  80023e:	e8 08 01 00 00       	call   80034b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800246:	e8 f9 13 00 00       	call   801644 <sys_unlock_cons>
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
  80025e:	e8 0f 16 00 00       	call   801872 <sys_destroy_env>
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
  80026f:	e8 64 16 00 00       	call   8018d8 <sys_exit_env>
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
  8002bd:	e8 26 13 00 00       	call   8015e8 <sys_cputs>
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
  800334:	e8 af 12 00 00       	call   8015e8 <sys_cputs>
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
  80037e:	e8 a7 12 00 00       	call   80162a <sys_lock_cons>
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
  80039e:	e8 a1 12 00 00       	call   801644 <sys_unlock_cons>
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
  8003e8:	e8 7b 34 00 00       	call   803868 <__udivdi3>
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
  800438:	e8 3b 35 00 00       	call   803978 <__umoddi3>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	05 f4 3d 80 00       	add    $0x803df4,%eax
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
  800593:	8b 04 85 18 3e 80 00 	mov    0x803e18(,%eax,4),%eax
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
  800674:	8b 34 9d 60 3c 80 00 	mov    0x803c60(,%ebx,4),%esi
  80067b:	85 f6                	test   %esi,%esi
  80067d:	75 19                	jne    800698 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067f:	53                   	push   %ebx
  800680:	68 05 3e 80 00       	push   $0x803e05
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
  800699:	68 0e 3e 80 00       	push   $0x803e0e
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
  8006c6:	be 11 3e 80 00       	mov    $0x803e11,%esi
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
  8010d1:	68 88 3f 80 00       	push   $0x803f88
  8010d6:	68 3f 01 00 00       	push   $0x13f
  8010db:	68 aa 3f 80 00       	push   $0x803faa
  8010e0:	e8 9a 25 00 00       	call   80367f <_panic>

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
  8010f1:	e8 9d 0a 00 00       	call   801b93 <sys_sbrk>
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
  80116c:	e8 a6 08 00 00       	call   801a17 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801171:	85 c0                	test   %eax,%eax
  801173:	74 16                	je     80118b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	ff 75 08             	pushl  0x8(%ebp)
  80117b:	e8 e6 0d 00 00       	call   801f66 <alloc_block_FF>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801186:	e9 8a 01 00 00       	jmp    801315 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80118b:	e8 b8 08 00 00       	call   801a48 <sys_isUHeapPlacementStrategyBESTFIT>
  801190:	85 c0                	test   %eax,%eax
  801192:	0f 84 7d 01 00 00    	je     801315 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801198:	83 ec 0c             	sub    $0xc,%esp
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	e8 7f 12 00 00       	call   802422 <alloc_block_BF>
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
  8011ee:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  80123b:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  801292:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  8012f4:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	ff 75 08             	pushl  0x8(%ebp)
  801301:	ff 75 f0             	pushl  -0x10(%ebp)
  801304:	e8 c1 08 00 00       	call   801bca <sys_allocate_user_mem>
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
  80134c:	e8 95 08 00 00       	call   801be6 <get_block_size>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 c8 1a 00 00       	call   802e2a <free_block>
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
  801397:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  8013d4:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  8013f4:	e8 b5 07 00 00       	call   801bae <sys_free_user_mem>
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
  801402:	68 b8 3f 80 00       	push   $0x803fb8
  801407:	68 84 00 00 00       	push   $0x84
  80140c:	68 e2 3f 80 00       	push   $0x803fe2
  801411:	e8 69 22 00 00       	call   80367f <_panic>
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
  801428:	75 07                	jne    801431 <smalloc+0x19>
  80142a:	b8 00 00 00 00       	mov    $0x0,%eax
  80142f:	eb 74                	jmp    8014a5 <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  801431:	8b 45 0c             	mov    0xc(%ebp),%eax
  801434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801437:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80143e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801444:	39 d0                	cmp    %edx,%eax
  801446:	73 02                	jae    80144a <smalloc+0x32>
  801448:	89 d0                	mov    %edx,%eax
  80144a:	83 ec 0c             	sub    $0xc,%esp
  80144d:	50                   	push   %eax
  80144e:	e8 a8 fc ff ff       	call   8010fb <malloc>
  801453:	83 c4 10             	add    $0x10,%esp
  801456:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801459:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80145d:	75 07                	jne    801466 <smalloc+0x4e>
  80145f:	b8 00 00 00 00       	mov    $0x0,%eax
  801464:	eb 3f                	jmp    8014a5 <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801466:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80146a:	ff 75 ec             	pushl  -0x14(%ebp)
  80146d:	50                   	push   %eax
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	ff 75 08             	pushl  0x8(%ebp)
  801474:	e8 3c 03 00 00       	call   8017b5 <sys_createSharedObject>
  801479:	83 c4 10             	add    $0x10,%esp
  80147c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80147f:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801483:	74 06                	je     80148b <smalloc+0x73>
  801485:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801489:	75 07                	jne    801492 <smalloc+0x7a>
  80148b:	b8 00 00 00 00       	mov    $0x0,%eax
  801490:	eb 13                	jmp    8014a5 <smalloc+0x8d>
	 cprintf("153\n");
  801492:	83 ec 0c             	sub    $0xc,%esp
  801495:	68 ee 3f 80 00       	push   $0x803fee
  80149a:	e8 ac ee ff ff       	call   80034b <cprintf>
  80149f:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  8014a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014ad:	83 ec 08             	sub    $0x8,%esp
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 24 03 00 00       	call   8017df <sys_getSizeOfSharedObject>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8014c1:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8014c5:	75 07                	jne    8014ce <sget+0x27>
  8014c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014cc:	eb 5c                	jmp    80152a <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8014ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014d4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8014db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e1:	39 d0                	cmp    %edx,%eax
  8014e3:	7d 02                	jge    8014e7 <sget+0x40>
  8014e5:	89 d0                	mov    %edx,%eax
  8014e7:	83 ec 0c             	sub    $0xc,%esp
  8014ea:	50                   	push   %eax
  8014eb:	e8 0b fc ff ff       	call   8010fb <malloc>
  8014f0:	83 c4 10             	add    $0x10,%esp
  8014f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8014f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014fa:	75 07                	jne    801503 <sget+0x5c>
  8014fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801501:	eb 27                	jmp    80152a <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	ff 75 e8             	pushl  -0x18(%ebp)
  801509:	ff 75 0c             	pushl  0xc(%ebp)
  80150c:	ff 75 08             	pushl  0x8(%ebp)
  80150f:	e8 e8 02 00 00       	call   8017fc <sys_getSharedObject>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80151a:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80151e:	75 07                	jne    801527 <sget+0x80>
  801520:	b8 00 00 00 00       	mov    $0x0,%eax
  801525:	eb 03                	jmp    80152a <sget+0x83>
	return ptr;
  801527:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	68 f4 3f 80 00       	push   $0x803ff4
  80153a:	68 c2 00 00 00       	push   $0xc2
  80153f:	68 e2 3f 80 00       	push   $0x803fe2
  801544:	e8 36 21 00 00       	call   80367f <_panic>

00801549 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80154f:	83 ec 04             	sub    $0x4,%esp
  801552:	68 18 40 80 00       	push   $0x804018
  801557:	68 d9 00 00 00       	push   $0xd9
  80155c:	68 e2 3f 80 00       	push   $0x803fe2
  801561:	e8 19 21 00 00       	call   80367f <_panic>

00801566 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	68 3e 40 80 00       	push   $0x80403e
  801574:	68 e5 00 00 00       	push   $0xe5
  801579:	68 e2 3f 80 00       	push   $0x803fe2
  80157e:	e8 fc 20 00 00       	call   80367f <_panic>

00801583 <shrink>:

}
void shrink(uint32 newSize)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801589:	83 ec 04             	sub    $0x4,%esp
  80158c:	68 3e 40 80 00       	push   $0x80403e
  801591:	68 ea 00 00 00       	push   $0xea
  801596:	68 e2 3f 80 00       	push   $0x803fe2
  80159b:	e8 df 20 00 00       	call   80367f <_panic>

008015a0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015a6:	83 ec 04             	sub    $0x4,%esp
  8015a9:	68 3e 40 80 00       	push   $0x80403e
  8015ae:	68 ef 00 00 00       	push   $0xef
  8015b3:	68 e2 3f 80 00       	push   $0x803fe2
  8015b8:	e8 c2 20 00 00       	call   80367f <_panic>

008015bd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	57                   	push   %edi
  8015c1:	56                   	push   %esi
  8015c2:	53                   	push   %ebx
  8015c3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015d2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015d5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015d8:	cd 30                	int    $0x30
  8015da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015e0:	83 c4 10             	add    $0x10,%esp
  8015e3:	5b                   	pop    %ebx
  8015e4:	5e                   	pop    %esi
  8015e5:	5f                   	pop    %edi
  8015e6:	5d                   	pop    %ebp
  8015e7:	c3                   	ret    

008015e8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015f4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	52                   	push   %edx
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	50                   	push   %eax
  801604:	6a 00                	push   $0x0
  801606:	e8 b2 ff ff ff       	call   8015bd <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
}
  80160e:	90                   	nop
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_cgetc>:

int
sys_cgetc(void)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 02                	push   $0x2
  801620:	e8 98 ff ff ff       	call   8015bd <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 03                	push   $0x3
  801639:	e8 7f ff ff ff       	call   8015bd <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
}
  801641:	90                   	nop
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 04                	push   $0x4
  801653:	e8 65 ff ff ff       	call   8015bd <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	90                   	nop
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801661:	8b 55 0c             	mov    0xc(%ebp),%edx
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	52                   	push   %edx
  80166e:	50                   	push   %eax
  80166f:	6a 08                	push   $0x8
  801671:	e8 47 ff ff ff       	call   8015bd <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	56                   	push   %esi
  80167f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801680:	8b 75 18             	mov    0x18(%ebp),%esi
  801683:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801686:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801689:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	56                   	push   %esi
  801690:	53                   	push   %ebx
  801691:	51                   	push   %ecx
  801692:	52                   	push   %edx
  801693:	50                   	push   %eax
  801694:	6a 09                	push   $0x9
  801696:	e8 22 ff ff ff       	call   8015bd <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a1:	5b                   	pop    %ebx
  8016a2:	5e                   	pop    %esi
  8016a3:	5d                   	pop    %ebp
  8016a4:	c3                   	ret    

008016a5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	52                   	push   %edx
  8016b5:	50                   	push   %eax
  8016b6:	6a 0a                	push   $0xa
  8016b8:	e8 00 ff ff ff       	call   8015bd <syscall>
  8016bd:	83 c4 18             	add    $0x18,%esp
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	ff 75 08             	pushl  0x8(%ebp)
  8016d1:	6a 0b                	push   $0xb
  8016d3:	e8 e5 fe ff ff       	call   8015bd <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 0c                	push   $0xc
  8016ec:	e8 cc fe ff ff       	call   8015bd <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 0d                	push   $0xd
  801705:	e8 b3 fe ff ff       	call   8015bd <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 0e                	push   $0xe
  80171e:	e8 9a fe ff ff       	call   8015bd <syscall>
  801723:	83 c4 18             	add    $0x18,%esp
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 0f                	push   $0xf
  801737:	e8 81 fe ff ff       	call   8015bd <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	ff 75 08             	pushl  0x8(%ebp)
  80174f:	6a 10                	push   $0x10
  801751:	e8 67 fe ff ff       	call   8015bd <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 11                	push   $0x11
  80176a:	e8 4e fe ff ff       	call   8015bd <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
}
  801772:	90                   	nop
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_cputc>:

void
sys_cputc(const char c)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801781:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	50                   	push   %eax
  80178e:	6a 01                	push   $0x1
  801790:	e8 28 fe ff ff       	call   8015bd <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	90                   	nop
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 14                	push   $0x14
  8017aa:	e8 0e fe ff ff       	call   8015bd <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	90                   	nop
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017be:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	6a 00                	push   $0x0
  8017cd:	51                   	push   %ecx
  8017ce:	52                   	push   %edx
  8017cf:	ff 75 0c             	pushl  0xc(%ebp)
  8017d2:	50                   	push   %eax
  8017d3:	6a 15                	push   $0x15
  8017d5:	e8 e3 fd ff ff       	call   8015bd <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	52                   	push   %edx
  8017ef:	50                   	push   %eax
  8017f0:	6a 16                	push   $0x16
  8017f2:	e8 c6 fd ff ff       	call   8015bd <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801802:	8b 55 0c             	mov    0xc(%ebp),%edx
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	51                   	push   %ecx
  80180d:	52                   	push   %edx
  80180e:	50                   	push   %eax
  80180f:	6a 17                	push   $0x17
  801811:	e8 a7 fd ff ff       	call   8015bd <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80181e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	52                   	push   %edx
  80182b:	50                   	push   %eax
  80182c:	6a 18                	push   $0x18
  80182e:	e8 8a fd ff ff       	call   8015bd <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	ff 75 14             	pushl  0x14(%ebp)
  801843:	ff 75 10             	pushl  0x10(%ebp)
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	50                   	push   %eax
  80184a:	6a 19                	push   $0x19
  80184c:	e8 6c fd ff ff       	call   8015bd <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	50                   	push   %eax
  801865:	6a 1a                	push   $0x1a
  801867:	e8 51 fd ff ff       	call   8015bd <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	90                   	nop
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	50                   	push   %eax
  801881:	6a 1b                	push   $0x1b
  801883:	e8 35 fd ff ff       	call   8015bd <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 05                	push   $0x5
  80189c:	e8 1c fd ff ff       	call   8015bd <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 06                	push   $0x6
  8018b5:	e8 03 fd ff ff       	call   8015bd <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 07                	push   $0x7
  8018ce:	e8 ea fc ff ff       	call   8015bd <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_exit_env>:


void sys_exit_env(void)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 1c                	push   $0x1c
  8018e7:	e8 d1 fc ff ff       	call   8015bd <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	90                   	nop
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018f8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018fb:	8d 50 04             	lea    0x4(%eax),%edx
  8018fe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	52                   	push   %edx
  801908:	50                   	push   %eax
  801909:	6a 1d                	push   $0x1d
  80190b:	e8 ad fc ff ff       	call   8015bd <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
	return result;
  801913:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801916:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801919:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80191c:	89 01                	mov    %eax,(%ecx)
  80191e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	c9                   	leave  
  801925:	c2 04 00             	ret    $0x4

00801928 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	ff 75 10             	pushl  0x10(%ebp)
  801932:	ff 75 0c             	pushl  0xc(%ebp)
  801935:	ff 75 08             	pushl  0x8(%ebp)
  801938:	6a 13                	push   $0x13
  80193a:	e8 7e fc ff ff       	call   8015bd <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
	return ;
  801942:	90                   	nop
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_rcr2>:
uint32 sys_rcr2()
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 1e                	push   $0x1e
  801954:	e8 64 fc ff ff       	call   8015bd <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80196a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	50                   	push   %eax
  801977:	6a 1f                	push   $0x1f
  801979:	e8 3f fc ff ff       	call   8015bd <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
	return ;
  801981:	90                   	nop
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <rsttst>:
void rsttst()
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 21                	push   $0x21
  801993:	e8 25 fc ff ff       	call   8015bd <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
	return ;
  80199b:	90                   	nop
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	83 ec 04             	sub    $0x4,%esp
  8019a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019aa:	8b 55 18             	mov    0x18(%ebp),%edx
  8019ad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	ff 75 10             	pushl  0x10(%ebp)
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	6a 20                	push   $0x20
  8019be:	e8 fa fb ff ff       	call   8015bd <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c6:	90                   	nop
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <chktst>:
void chktst(uint32 n)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	ff 75 08             	pushl  0x8(%ebp)
  8019d7:	6a 22                	push   $0x22
  8019d9:	e8 df fb ff ff       	call   8015bd <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e1:	90                   	nop
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <inctst>:

void inctst()
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 23                	push   $0x23
  8019f3:	e8 c5 fb ff ff       	call   8015bd <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fb:	90                   	nop
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <gettst>:
uint32 gettst()
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 24                	push   $0x24
  801a0d:	e8 ab fb ff ff       	call   8015bd <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 25                	push   $0x25
  801a29:	e8 8f fb ff ff       	call   8015bd <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
  801a31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a34:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a38:	75 07                	jne    801a41 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3f:	eb 05                	jmp    801a46 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 25                	push   $0x25
  801a5a:	e8 5e fb ff ff       	call   8015bd <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
  801a62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a65:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a69:	75 07                	jne    801a72 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a70:	eb 05                	jmp    801a77 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 25                	push   $0x25
  801a8b:	e8 2d fb ff ff       	call   8015bd <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
  801a93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a96:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a9a:	75 07                	jne    801aa3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa1:	eb 05                	jmp    801aa8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 25                	push   $0x25
  801abc:	e8 fc fa ff ff       	call   8015bd <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
  801ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ac7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801acb:	75 07                	jne    801ad4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801acd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad2:	eb 05                	jmp    801ad9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ad4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	ff 75 08             	pushl  0x8(%ebp)
  801ae9:	6a 26                	push   $0x26
  801aeb:	e8 cd fa ff ff       	call   8015bd <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
	return ;
  801af3:	90                   	nop
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801afa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801afd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	53                   	push   %ebx
  801b09:	51                   	push   %ecx
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	6a 27                	push   $0x27
  801b0e:	e8 aa fa ff ff       	call   8015bd <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	52                   	push   %edx
  801b2b:	50                   	push   %eax
  801b2c:	6a 28                	push   $0x28
  801b2e:	e8 8a fa ff ff       	call   8015bd <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b3b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	51                   	push   %ecx
  801b47:	ff 75 10             	pushl  0x10(%ebp)
  801b4a:	52                   	push   %edx
  801b4b:	50                   	push   %eax
  801b4c:	6a 29                	push   $0x29
  801b4e:	e8 6a fa ff ff       	call   8015bd <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	ff 75 10             	pushl  0x10(%ebp)
  801b62:	ff 75 0c             	pushl  0xc(%ebp)
  801b65:	ff 75 08             	pushl  0x8(%ebp)
  801b68:	6a 12                	push   $0x12
  801b6a:	e8 4e fa ff ff       	call   8015bd <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b72:	90                   	nop
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	52                   	push   %edx
  801b85:	50                   	push   %eax
  801b86:	6a 2a                	push   $0x2a
  801b88:	e8 30 fa ff ff       	call   8015bd <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
	return;
  801b90:	90                   	nop
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	50                   	push   %eax
  801ba2:	6a 2b                	push   $0x2b
  801ba4:	e8 14 fa ff ff       	call   8015bd <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	ff 75 08             	pushl  0x8(%ebp)
  801bbd:	6a 2c                	push   $0x2c
  801bbf:	e8 f9 f9 ff ff       	call   8015bd <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
	return;
  801bc7:	90                   	nop
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	6a 2d                	push   $0x2d
  801bdb:	e8 dd f9 ff ff       	call   8015bd <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
	return;
  801be3:	90                   	nop
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801bec:	8b 45 08             	mov    0x8(%ebp),%eax
  801bef:	83 e8 04             	sub    $0x4,%eax
  801bf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bf8:	8b 00                	mov    (%eax),%eax
  801bfa:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	83 e8 04             	sub    $0x4,%eax
  801c0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801c0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c11:	8b 00                	mov    (%eax),%eax
  801c13:	83 e0 01             	and    $0x1,%eax
  801c16:	85 c0                	test   %eax,%eax
  801c18:	0f 94 c0             	sete   %al
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801c23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2d:	83 f8 02             	cmp    $0x2,%eax
  801c30:	74 2b                	je     801c5d <alloc_block+0x40>
  801c32:	83 f8 02             	cmp    $0x2,%eax
  801c35:	7f 07                	jg     801c3e <alloc_block+0x21>
  801c37:	83 f8 01             	cmp    $0x1,%eax
  801c3a:	74 0e                	je     801c4a <alloc_block+0x2d>
  801c3c:	eb 58                	jmp    801c96 <alloc_block+0x79>
  801c3e:	83 f8 03             	cmp    $0x3,%eax
  801c41:	74 2d                	je     801c70 <alloc_block+0x53>
  801c43:	83 f8 04             	cmp    $0x4,%eax
  801c46:	74 3b                	je     801c83 <alloc_block+0x66>
  801c48:	eb 4c                	jmp    801c96 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801c4a:	83 ec 0c             	sub    $0xc,%esp
  801c4d:	ff 75 08             	pushl  0x8(%ebp)
  801c50:	e8 11 03 00 00       	call   801f66 <alloc_block_FF>
  801c55:	83 c4 10             	add    $0x10,%esp
  801c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c5b:	eb 4a                	jmp    801ca7 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801c5d:	83 ec 0c             	sub    $0xc,%esp
  801c60:	ff 75 08             	pushl  0x8(%ebp)
  801c63:	e8 fa 19 00 00       	call   803662 <alloc_block_NF>
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c6e:	eb 37                	jmp    801ca7 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801c70:	83 ec 0c             	sub    $0xc,%esp
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	e8 a7 07 00 00       	call   802422 <alloc_block_BF>
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c81:	eb 24                	jmp    801ca7 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801c83:	83 ec 0c             	sub    $0xc,%esp
  801c86:	ff 75 08             	pushl  0x8(%ebp)
  801c89:	e8 b7 19 00 00       	call   803645 <alloc_block_WF>
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c94:	eb 11                	jmp    801ca7 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	68 50 40 80 00       	push   $0x804050
  801c9e:	e8 a8 e6 ff ff       	call   80034b <cprintf>
  801ca3:	83 c4 10             	add    $0x10,%esp
		break;
  801ca6:	90                   	nop
	}
	return va;
  801ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	53                   	push   %ebx
  801cb0:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801cb3:	83 ec 0c             	sub    $0xc,%esp
  801cb6:	68 70 40 80 00       	push   $0x804070
  801cbb:	e8 8b e6 ff ff       	call   80034b <cprintf>
  801cc0:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801cc3:	83 ec 0c             	sub    $0xc,%esp
  801cc6:	68 9b 40 80 00       	push   $0x80409b
  801ccb:	e8 7b e6 ff ff       	call   80034b <cprintf>
  801cd0:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cd9:	eb 37                	jmp    801d12 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801cdb:	83 ec 0c             	sub    $0xc,%esp
  801cde:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce1:	e8 19 ff ff ff       	call   801bff <is_free_block>
  801ce6:	83 c4 10             	add    $0x10,%esp
  801ce9:	0f be d8             	movsbl %al,%ebx
  801cec:	83 ec 0c             	sub    $0xc,%esp
  801cef:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf2:	e8 ef fe ff ff       	call   801be6 <get_block_size>
  801cf7:	83 c4 10             	add    $0x10,%esp
  801cfa:	83 ec 04             	sub    $0x4,%esp
  801cfd:	53                   	push   %ebx
  801cfe:	50                   	push   %eax
  801cff:	68 b3 40 80 00       	push   $0x8040b3
  801d04:	e8 42 e6 ff ff       	call   80034b <cprintf>
  801d09:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801d0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d16:	74 07                	je     801d1f <print_blocks_list+0x73>
  801d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1b:	8b 00                	mov    (%eax),%eax
  801d1d:	eb 05                	jmp    801d24 <print_blocks_list+0x78>
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d24:	89 45 10             	mov    %eax,0x10(%ebp)
  801d27:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	75 ad                	jne    801cdb <print_blocks_list+0x2f>
  801d2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d32:	75 a7                	jne    801cdb <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801d34:	83 ec 0c             	sub    $0xc,%esp
  801d37:	68 70 40 80 00       	push   $0x804070
  801d3c:	e8 0a e6 ff ff       	call   80034b <cprintf>
  801d41:	83 c4 10             	add    $0x10,%esp

}
  801d44:	90                   	nop
  801d45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d53:	83 e0 01             	and    $0x1,%eax
  801d56:	85 c0                	test   %eax,%eax
  801d58:	74 03                	je     801d5d <initialize_dynamic_allocator+0x13>
  801d5a:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801d5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d61:	0f 84 c7 01 00 00    	je     801f2e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801d67:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801d6e:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801d71:	8b 55 08             	mov    0x8(%ebp),%edx
  801d74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d77:	01 d0                	add    %edx,%eax
  801d79:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801d7e:	0f 87 ad 01 00 00    	ja     801f31 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	85 c0                	test   %eax,%eax
  801d89:	0f 89 a5 01 00 00    	jns    801f34 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  801d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d95:	01 d0                	add    %edx,%eax
  801d97:	83 e8 04             	sub    $0x4,%eax
  801d9a:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801d9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801da6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dae:	e9 87 00 00 00       	jmp    801e3a <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db7:	75 14                	jne    801dcd <initialize_dynamic_allocator+0x83>
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	68 cb 40 80 00       	push   $0x8040cb
  801dc1:	6a 79                	push   $0x79
  801dc3:	68 e9 40 80 00       	push   $0x8040e9
  801dc8:	e8 b2 18 00 00       	call   80367f <_panic>
  801dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd0:	8b 00                	mov    (%eax),%eax
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	74 10                	je     801de6 <initialize_dynamic_allocator+0x9c>
  801dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd9:	8b 00                	mov    (%eax),%eax
  801ddb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dde:	8b 52 04             	mov    0x4(%edx),%edx
  801de1:	89 50 04             	mov    %edx,0x4(%eax)
  801de4:	eb 0b                	jmp    801df1 <initialize_dynamic_allocator+0xa7>
  801de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de9:	8b 40 04             	mov    0x4(%eax),%eax
  801dec:	a3 30 50 80 00       	mov    %eax,0x805030
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	8b 40 04             	mov    0x4(%eax),%eax
  801df7:	85 c0                	test   %eax,%eax
  801df9:	74 0f                	je     801e0a <initialize_dynamic_allocator+0xc0>
  801dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfe:	8b 40 04             	mov    0x4(%eax),%eax
  801e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e04:	8b 12                	mov    (%edx),%edx
  801e06:	89 10                	mov    %edx,(%eax)
  801e08:	eb 0a                	jmp    801e14 <initialize_dynamic_allocator+0xca>
  801e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0d:	8b 00                	mov    (%eax),%eax
  801e0f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e27:	a1 38 50 80 00       	mov    0x805038,%eax
  801e2c:	48                   	dec    %eax
  801e2d:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801e32:	a1 34 50 80 00       	mov    0x805034,%eax
  801e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e3e:	74 07                	je     801e47 <initialize_dynamic_allocator+0xfd>
  801e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e43:	8b 00                	mov    (%eax),%eax
  801e45:	eb 05                	jmp    801e4c <initialize_dynamic_allocator+0x102>
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4c:	a3 34 50 80 00       	mov    %eax,0x805034
  801e51:	a1 34 50 80 00       	mov    0x805034,%eax
  801e56:	85 c0                	test   %eax,%eax
  801e58:	0f 85 55 ff ff ff    	jne    801db3 <initialize_dynamic_allocator+0x69>
  801e5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e62:	0f 85 4b ff ff ff    	jne    801db3 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e71:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801e77:	a1 44 50 80 00       	mov    0x805044,%eax
  801e7c:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801e81:	a1 40 50 80 00       	mov    0x805040,%eax
  801e86:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8f:	83 c0 08             	add    $0x8,%eax
  801e92:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	83 c0 04             	add    $0x4,%eax
  801e9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9e:	83 ea 08             	sub    $0x8,%edx
  801ea1:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	01 d0                	add    %edx,%eax
  801eab:	83 e8 08             	sub    $0x8,%eax
  801eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb1:	83 ea 08             	sub    $0x8,%edx
  801eb4:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801ebf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801ec9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ecd:	75 17                	jne    801ee6 <initialize_dynamic_allocator+0x19c>
  801ecf:	83 ec 04             	sub    $0x4,%esp
  801ed2:	68 04 41 80 00       	push   $0x804104
  801ed7:	68 90 00 00 00       	push   $0x90
  801edc:	68 e9 40 80 00       	push   $0x8040e9
  801ee1:	e8 99 17 00 00       	call   80367f <_panic>
  801ee6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eef:	89 10                	mov    %edx,(%eax)
  801ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef4:	8b 00                	mov    (%eax),%eax
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	74 0d                	je     801f07 <initialize_dynamic_allocator+0x1bd>
  801efa:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801eff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f02:	89 50 04             	mov    %edx,0x4(%eax)
  801f05:	eb 08                	jmp    801f0f <initialize_dynamic_allocator+0x1c5>
  801f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0a:	a3 30 50 80 00       	mov    %eax,0x805030
  801f0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f12:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f21:	a1 38 50 80 00       	mov    0x805038,%eax
  801f26:	40                   	inc    %eax
  801f27:	a3 38 50 80 00       	mov    %eax,0x805038
  801f2c:	eb 07                	jmp    801f35 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801f2e:	90                   	nop
  801f2f:	eb 04                	jmp    801f35 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801f31:	90                   	nop
  801f32:	eb 01                	jmp    801f35 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801f34:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3d:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	8d 50 fc             	lea    -0x4(%eax),%edx
  801f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f49:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	83 e8 04             	sub    $0x4,%eax
  801f51:	8b 00                	mov    (%eax),%eax
  801f53:	83 e0 fe             	and    $0xfffffffe,%eax
  801f56:	8d 50 f8             	lea    -0x8(%eax),%edx
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	01 c2                	add    %eax,%edx
  801f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f61:	89 02                	mov    %eax,(%edx)
}
  801f63:	90                   	nop
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    

00801f66 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	83 e0 01             	and    $0x1,%eax
  801f72:	85 c0                	test   %eax,%eax
  801f74:	74 03                	je     801f79 <alloc_block_FF+0x13>
  801f76:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801f79:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801f7d:	77 07                	ja     801f86 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801f7f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801f86:	a1 24 50 80 00       	mov    0x805024,%eax
  801f8b:	85 c0                	test   %eax,%eax
  801f8d:	75 73                	jne    802002 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	83 c0 10             	add    $0x10,%eax
  801f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  801f98:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa5:	01 d0                	add    %edx,%eax
  801fa7:	48                   	dec    %eax
  801fa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fae:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb3:	f7 75 ec             	divl   -0x14(%ebp)
  801fb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fb9:	29 d0                	sub    %edx,%eax
  801fbb:	c1 e8 0c             	shr    $0xc,%eax
  801fbe:	83 ec 0c             	sub    $0xc,%esp
  801fc1:	50                   	push   %eax
  801fc2:	e8 1e f1 ff ff       	call   8010e5 <sbrk>
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  801fcd:	83 ec 0c             	sub    $0xc,%esp
  801fd0:	6a 00                	push   $0x0
  801fd2:	e8 0e f1 ff ff       	call   8010e5 <sbrk>
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  801fdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fe0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801fe3:	83 ec 08             	sub    $0x8,%esp
  801fe6:	50                   	push   %eax
  801fe7:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fea:	e8 5b fd ff ff       	call   801d4a <initialize_dynamic_allocator>
  801fef:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	68 27 41 80 00       	push   $0x804127
  801ffa:	e8 4c e3 ff ff       	call   80034b <cprintf>
  801fff:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802002:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802006:	75 0a                	jne    802012 <alloc_block_FF+0xac>
	        return NULL;
  802008:	b8 00 00 00 00       	mov    $0x0,%eax
  80200d:	e9 0e 04 00 00       	jmp    802420 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802012:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802019:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80201e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802021:	e9 f3 02 00 00       	jmp    802319 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80202c:	83 ec 0c             	sub    $0xc,%esp
  80202f:	ff 75 bc             	pushl  -0x44(%ebp)
  802032:	e8 af fb ff ff       	call   801be6 <get_block_size>
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	83 c0 08             	add    $0x8,%eax
  802043:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802046:	0f 87 c5 02 00 00    	ja     802311 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	83 c0 18             	add    $0x18,%eax
  802052:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802055:	0f 87 19 02 00 00    	ja     802274 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80205b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80205e:	2b 45 08             	sub    0x8(%ebp),%eax
  802061:	83 e8 08             	sub    $0x8,%eax
  802064:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	8d 50 08             	lea    0x8(%eax),%edx
  80206d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802070:	01 d0                	add    %edx,%eax
  802072:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	83 c0 08             	add    $0x8,%eax
  80207b:	83 ec 04             	sub    $0x4,%esp
  80207e:	6a 01                	push   $0x1
  802080:	50                   	push   %eax
  802081:	ff 75 bc             	pushl  -0x44(%ebp)
  802084:	e8 ae fe ff ff       	call   801f37 <set_block_data>
  802089:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	8b 40 04             	mov    0x4(%eax),%eax
  802092:	85 c0                	test   %eax,%eax
  802094:	75 68                	jne    8020fe <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802096:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80209a:	75 17                	jne    8020b3 <alloc_block_FF+0x14d>
  80209c:	83 ec 04             	sub    $0x4,%esp
  80209f:	68 04 41 80 00       	push   $0x804104
  8020a4:	68 d7 00 00 00       	push   $0xd7
  8020a9:	68 e9 40 80 00       	push   $0x8040e9
  8020ae:	e8 cc 15 00 00       	call   80367f <_panic>
  8020b3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020bc:	89 10                	mov    %edx,(%eax)
  8020be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020c1:	8b 00                	mov    (%eax),%eax
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	74 0d                	je     8020d4 <alloc_block_FF+0x16e>
  8020c7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020cf:	89 50 04             	mov    %edx,0x4(%eax)
  8020d2:	eb 08                	jmp    8020dc <alloc_block_FF+0x176>
  8020d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020d7:	a3 30 50 80 00       	mov    %eax,0x805030
  8020dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020df:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8020f3:	40                   	inc    %eax
  8020f4:	a3 38 50 80 00       	mov    %eax,0x805038
  8020f9:	e9 dc 00 00 00       	jmp    8021da <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	8b 00                	mov    (%eax),%eax
  802103:	85 c0                	test   %eax,%eax
  802105:	75 65                	jne    80216c <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802107:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80210b:	75 17                	jne    802124 <alloc_block_FF+0x1be>
  80210d:	83 ec 04             	sub    $0x4,%esp
  802110:	68 38 41 80 00       	push   $0x804138
  802115:	68 db 00 00 00       	push   $0xdb
  80211a:	68 e9 40 80 00       	push   $0x8040e9
  80211f:	e8 5b 15 00 00       	call   80367f <_panic>
  802124:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80212a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80212d:	89 50 04             	mov    %edx,0x4(%eax)
  802130:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802133:	8b 40 04             	mov    0x4(%eax),%eax
  802136:	85 c0                	test   %eax,%eax
  802138:	74 0c                	je     802146 <alloc_block_FF+0x1e0>
  80213a:	a1 30 50 80 00       	mov    0x805030,%eax
  80213f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802142:	89 10                	mov    %edx,(%eax)
  802144:	eb 08                	jmp    80214e <alloc_block_FF+0x1e8>
  802146:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802149:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80214e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802151:	a3 30 50 80 00       	mov    %eax,0x805030
  802156:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80215f:	a1 38 50 80 00       	mov    0x805038,%eax
  802164:	40                   	inc    %eax
  802165:	a3 38 50 80 00       	mov    %eax,0x805038
  80216a:	eb 6e                	jmp    8021da <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80216c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802170:	74 06                	je     802178 <alloc_block_FF+0x212>
  802172:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802176:	75 17                	jne    80218f <alloc_block_FF+0x229>
  802178:	83 ec 04             	sub    $0x4,%esp
  80217b:	68 5c 41 80 00       	push   $0x80415c
  802180:	68 df 00 00 00       	push   $0xdf
  802185:	68 e9 40 80 00       	push   $0x8040e9
  80218a:	e8 f0 14 00 00       	call   80367f <_panic>
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	8b 10                	mov    (%eax),%edx
  802194:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802197:	89 10                	mov    %edx,(%eax)
  802199:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80219c:	8b 00                	mov    (%eax),%eax
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	74 0b                	je     8021ad <alloc_block_FF+0x247>
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	8b 00                	mov    (%eax),%eax
  8021a7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021aa:	89 50 04             	mov    %edx,0x4(%eax)
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021b3:	89 10                	mov    %edx,(%eax)
  8021b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bb:	89 50 04             	mov    %edx,0x4(%eax)
  8021be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021c1:	8b 00                	mov    (%eax),%eax
  8021c3:	85 c0                	test   %eax,%eax
  8021c5:	75 08                	jne    8021cf <alloc_block_FF+0x269>
  8021c7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8021cf:	a1 38 50 80 00       	mov    0x805038,%eax
  8021d4:	40                   	inc    %eax
  8021d5:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8021da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021de:	75 17                	jne    8021f7 <alloc_block_FF+0x291>
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	68 cb 40 80 00       	push   $0x8040cb
  8021e8:	68 e1 00 00 00       	push   $0xe1
  8021ed:	68 e9 40 80 00       	push   $0x8040e9
  8021f2:	e8 88 14 00 00       	call   80367f <_panic>
  8021f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fa:	8b 00                	mov    (%eax),%eax
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	74 10                	je     802210 <alloc_block_FF+0x2aa>
  802200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802203:	8b 00                	mov    (%eax),%eax
  802205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802208:	8b 52 04             	mov    0x4(%edx),%edx
  80220b:	89 50 04             	mov    %edx,0x4(%eax)
  80220e:	eb 0b                	jmp    80221b <alloc_block_FF+0x2b5>
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 40 04             	mov    0x4(%eax),%eax
  802216:	a3 30 50 80 00       	mov    %eax,0x805030
  80221b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221e:	8b 40 04             	mov    0x4(%eax),%eax
  802221:	85 c0                	test   %eax,%eax
  802223:	74 0f                	je     802234 <alloc_block_FF+0x2ce>
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	8b 40 04             	mov    0x4(%eax),%eax
  80222b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222e:	8b 12                	mov    (%edx),%edx
  802230:	89 10                	mov    %edx,(%eax)
  802232:	eb 0a                	jmp    80223e <alloc_block_FF+0x2d8>
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 00                	mov    (%eax),%eax
  802239:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802251:	a1 38 50 80 00       	mov    0x805038,%eax
  802256:	48                   	dec    %eax
  802257:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	6a 00                	push   $0x0
  802261:	ff 75 b4             	pushl  -0x4c(%ebp)
  802264:	ff 75 b0             	pushl  -0x50(%ebp)
  802267:	e8 cb fc ff ff       	call   801f37 <set_block_data>
  80226c:	83 c4 10             	add    $0x10,%esp
  80226f:	e9 95 00 00 00       	jmp    802309 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802274:	83 ec 04             	sub    $0x4,%esp
  802277:	6a 01                	push   $0x1
  802279:	ff 75 b8             	pushl  -0x48(%ebp)
  80227c:	ff 75 bc             	pushl  -0x44(%ebp)
  80227f:	e8 b3 fc ff ff       	call   801f37 <set_block_data>
  802284:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802287:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228b:	75 17                	jne    8022a4 <alloc_block_FF+0x33e>
  80228d:	83 ec 04             	sub    $0x4,%esp
  802290:	68 cb 40 80 00       	push   $0x8040cb
  802295:	68 e8 00 00 00       	push   $0xe8
  80229a:	68 e9 40 80 00       	push   $0x8040e9
  80229f:	e8 db 13 00 00       	call   80367f <_panic>
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 00                	mov    (%eax),%eax
  8022a9:	85 c0                	test   %eax,%eax
  8022ab:	74 10                	je     8022bd <alloc_block_FF+0x357>
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b0:	8b 00                	mov    (%eax),%eax
  8022b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b5:	8b 52 04             	mov    0x4(%edx),%edx
  8022b8:	89 50 04             	mov    %edx,0x4(%eax)
  8022bb:	eb 0b                	jmp    8022c8 <alloc_block_FF+0x362>
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 40 04             	mov    0x4(%eax),%eax
  8022c3:	a3 30 50 80 00       	mov    %eax,0x805030
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 40 04             	mov    0x4(%eax),%eax
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	74 0f                	je     8022e1 <alloc_block_FF+0x37b>
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 40 04             	mov    0x4(%eax),%eax
  8022d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022db:	8b 12                	mov    (%edx),%edx
  8022dd:	89 10                	mov    %edx,(%eax)
  8022df:	eb 0a                	jmp    8022eb <alloc_block_FF+0x385>
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	8b 00                	mov    (%eax),%eax
  8022e6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022fe:	a1 38 50 80 00       	mov    0x805038,%eax
  802303:	48                   	dec    %eax
  802304:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802309:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80230c:	e9 0f 01 00 00       	jmp    802420 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802311:	a1 34 50 80 00       	mov    0x805034,%eax
  802316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802319:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231d:	74 07                	je     802326 <alloc_block_FF+0x3c0>
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	8b 00                	mov    (%eax),%eax
  802324:	eb 05                	jmp    80232b <alloc_block_FF+0x3c5>
  802326:	b8 00 00 00 00       	mov    $0x0,%eax
  80232b:	a3 34 50 80 00       	mov    %eax,0x805034
  802330:	a1 34 50 80 00       	mov    0x805034,%eax
  802335:	85 c0                	test   %eax,%eax
  802337:	0f 85 e9 fc ff ff    	jne    802026 <alloc_block_FF+0xc0>
  80233d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802341:	0f 85 df fc ff ff    	jne    802026 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	83 c0 08             	add    $0x8,%eax
  80234d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802350:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802357:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80235a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80235d:	01 d0                	add    %edx,%eax
  80235f:	48                   	dec    %eax
  802360:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802363:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802366:	ba 00 00 00 00       	mov    $0x0,%edx
  80236b:	f7 75 d8             	divl   -0x28(%ebp)
  80236e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802371:	29 d0                	sub    %edx,%eax
  802373:	c1 e8 0c             	shr    $0xc,%eax
  802376:	83 ec 0c             	sub    $0xc,%esp
  802379:	50                   	push   %eax
  80237a:	e8 66 ed ff ff       	call   8010e5 <sbrk>
  80237f:	83 c4 10             	add    $0x10,%esp
  802382:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802385:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802389:	75 0a                	jne    802395 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80238b:	b8 00 00 00 00       	mov    $0x0,%eax
  802390:	e9 8b 00 00 00       	jmp    802420 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802395:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80239c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80239f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023a2:	01 d0                	add    %edx,%eax
  8023a4:	48                   	dec    %eax
  8023a5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8023a8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b0:	f7 75 cc             	divl   -0x34(%ebp)
  8023b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023b6:	29 d0                	sub    %edx,%eax
  8023b8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023be:	01 d0                	add    %edx,%eax
  8023c0:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8023c5:	a1 40 50 80 00       	mov    0x805040,%eax
  8023ca:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8023d0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8023d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8023dd:	01 d0                	add    %edx,%eax
  8023df:	48                   	dec    %eax
  8023e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8023e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8023eb:	f7 75 c4             	divl   -0x3c(%ebp)
  8023ee:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023f1:	29 d0                	sub    %edx,%eax
  8023f3:	83 ec 04             	sub    $0x4,%esp
  8023f6:	6a 01                	push   $0x1
  8023f8:	50                   	push   %eax
  8023f9:	ff 75 d0             	pushl  -0x30(%ebp)
  8023fc:	e8 36 fb ff ff       	call   801f37 <set_block_data>
  802401:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802404:	83 ec 0c             	sub    $0xc,%esp
  802407:	ff 75 d0             	pushl  -0x30(%ebp)
  80240a:	e8 1b 0a 00 00       	call   802e2a <free_block>
  80240f:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802412:	83 ec 0c             	sub    $0xc,%esp
  802415:	ff 75 08             	pushl  0x8(%ebp)
  802418:	e8 49 fb ff ff       	call   801f66 <alloc_block_FF>
  80241d:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	83 e0 01             	and    $0x1,%eax
  80242e:	85 c0                	test   %eax,%eax
  802430:	74 03                	je     802435 <alloc_block_BF+0x13>
  802432:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802435:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802439:	77 07                	ja     802442 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80243b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802442:	a1 24 50 80 00       	mov    0x805024,%eax
  802447:	85 c0                	test   %eax,%eax
  802449:	75 73                	jne    8024be <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	83 c0 10             	add    $0x10,%eax
  802451:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802454:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80245b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80245e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802461:	01 d0                	add    %edx,%eax
  802463:	48                   	dec    %eax
  802464:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802467:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80246a:	ba 00 00 00 00       	mov    $0x0,%edx
  80246f:	f7 75 e0             	divl   -0x20(%ebp)
  802472:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802475:	29 d0                	sub    %edx,%eax
  802477:	c1 e8 0c             	shr    $0xc,%eax
  80247a:	83 ec 0c             	sub    $0xc,%esp
  80247d:	50                   	push   %eax
  80247e:	e8 62 ec ff ff       	call   8010e5 <sbrk>
  802483:	83 c4 10             	add    $0x10,%esp
  802486:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802489:	83 ec 0c             	sub    $0xc,%esp
  80248c:	6a 00                	push   $0x0
  80248e:	e8 52 ec ff ff       	call   8010e5 <sbrk>
  802493:	83 c4 10             	add    $0x10,%esp
  802496:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802499:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80249c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80249f:	83 ec 08             	sub    $0x8,%esp
  8024a2:	50                   	push   %eax
  8024a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8024a6:	e8 9f f8 ff ff       	call   801d4a <initialize_dynamic_allocator>
  8024ab:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024ae:	83 ec 0c             	sub    $0xc,%esp
  8024b1:	68 27 41 80 00       	push   $0x804127
  8024b6:	e8 90 de ff ff       	call   80034b <cprintf>
  8024bb:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8024be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8024c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8024cc:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8024d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8024da:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e2:	e9 1d 01 00 00       	jmp    802604 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8024ed:	83 ec 0c             	sub    $0xc,%esp
  8024f0:	ff 75 a8             	pushl  -0x58(%ebp)
  8024f3:	e8 ee f6 ff ff       	call   801be6 <get_block_size>
  8024f8:	83 c4 10             	add    $0x10,%esp
  8024fb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	83 c0 08             	add    $0x8,%eax
  802504:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802507:	0f 87 ef 00 00 00    	ja     8025fc <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	83 c0 18             	add    $0x18,%eax
  802513:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802516:	77 1d                	ja     802535 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80251e:	0f 86 d8 00 00 00    	jbe    8025fc <alloc_block_BF+0x1da>
				{
					best_va = va;
  802524:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802527:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80252a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80252d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802530:	e9 c7 00 00 00       	jmp    8025fc <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802535:	8b 45 08             	mov    0x8(%ebp),%eax
  802538:	83 c0 08             	add    $0x8,%eax
  80253b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80253e:	0f 85 9d 00 00 00    	jne    8025e1 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802544:	83 ec 04             	sub    $0x4,%esp
  802547:	6a 01                	push   $0x1
  802549:	ff 75 a4             	pushl  -0x5c(%ebp)
  80254c:	ff 75 a8             	pushl  -0x58(%ebp)
  80254f:	e8 e3 f9 ff ff       	call   801f37 <set_block_data>
  802554:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	75 17                	jne    802574 <alloc_block_BF+0x152>
  80255d:	83 ec 04             	sub    $0x4,%esp
  802560:	68 cb 40 80 00       	push   $0x8040cb
  802565:	68 2c 01 00 00       	push   $0x12c
  80256a:	68 e9 40 80 00       	push   $0x8040e9
  80256f:	e8 0b 11 00 00       	call   80367f <_panic>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	85 c0                	test   %eax,%eax
  80257b:	74 10                	je     80258d <alloc_block_BF+0x16b>
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 00                	mov    (%eax),%eax
  802582:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802585:	8b 52 04             	mov    0x4(%edx),%edx
  802588:	89 50 04             	mov    %edx,0x4(%eax)
  80258b:	eb 0b                	jmp    802598 <alloc_block_BF+0x176>
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 40 04             	mov    0x4(%eax),%eax
  802593:	a3 30 50 80 00       	mov    %eax,0x805030
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	8b 40 04             	mov    0x4(%eax),%eax
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	74 0f                	je     8025b1 <alloc_block_BF+0x18f>
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 40 04             	mov    0x4(%eax),%eax
  8025a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ab:	8b 12                	mov    (%edx),%edx
  8025ad:	89 10                	mov    %edx,(%eax)
  8025af:	eb 0a                	jmp    8025bb <alloc_block_BF+0x199>
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8025d3:	48                   	dec    %eax
  8025d4:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8025d9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025dc:	e9 24 04 00 00       	jmp    802a05 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8025e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025e7:	76 13                	jbe    8025fc <alloc_block_BF+0x1da>
					{
						internal = 1;
  8025e9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8025f0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8025f6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025f9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8025fc:	a1 34 50 80 00       	mov    0x805034,%eax
  802601:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802608:	74 07                	je     802611 <alloc_block_BF+0x1ef>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	eb 05                	jmp    802616 <alloc_block_BF+0x1f4>
  802611:	b8 00 00 00 00       	mov    $0x0,%eax
  802616:	a3 34 50 80 00       	mov    %eax,0x805034
  80261b:	a1 34 50 80 00       	mov    0x805034,%eax
  802620:	85 c0                	test   %eax,%eax
  802622:	0f 85 bf fe ff ff    	jne    8024e7 <alloc_block_BF+0xc5>
  802628:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262c:	0f 85 b5 fe ff ff    	jne    8024e7 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802632:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802636:	0f 84 26 02 00 00    	je     802862 <alloc_block_BF+0x440>
  80263c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802640:	0f 85 1c 02 00 00    	jne    802862 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802649:	2b 45 08             	sub    0x8(%ebp),%eax
  80264c:	83 e8 08             	sub    $0x8,%eax
  80264f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	8d 50 08             	lea    0x8(%eax),%edx
  802658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265b:	01 d0                	add    %edx,%eax
  80265d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	83 c0 08             	add    $0x8,%eax
  802666:	83 ec 04             	sub    $0x4,%esp
  802669:	6a 01                	push   $0x1
  80266b:	50                   	push   %eax
  80266c:	ff 75 f0             	pushl  -0x10(%ebp)
  80266f:	e8 c3 f8 ff ff       	call   801f37 <set_block_data>
  802674:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267a:	8b 40 04             	mov    0x4(%eax),%eax
  80267d:	85 c0                	test   %eax,%eax
  80267f:	75 68                	jne    8026e9 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802681:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802685:	75 17                	jne    80269e <alloc_block_BF+0x27c>
  802687:	83 ec 04             	sub    $0x4,%esp
  80268a:	68 04 41 80 00       	push   $0x804104
  80268f:	68 45 01 00 00       	push   $0x145
  802694:	68 e9 40 80 00       	push   $0x8040e9
  802699:	e8 e1 0f 00 00       	call   80367f <_panic>
  80269e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8026a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026a7:	89 10                	mov    %edx,(%eax)
  8026a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	74 0d                	je     8026bf <alloc_block_BF+0x29d>
  8026b2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026b7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026ba:	89 50 04             	mov    %edx,0x4(%eax)
  8026bd:	eb 08                	jmp    8026c7 <alloc_block_BF+0x2a5>
  8026bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8026c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026ca:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8026de:	40                   	inc    %eax
  8026df:	a3 38 50 80 00       	mov    %eax,0x805038
  8026e4:	e9 dc 00 00 00       	jmp    8027c5 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8026e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ec:	8b 00                	mov    (%eax),%eax
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	75 65                	jne    802757 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026f6:	75 17                	jne    80270f <alloc_block_BF+0x2ed>
  8026f8:	83 ec 04             	sub    $0x4,%esp
  8026fb:	68 38 41 80 00       	push   $0x804138
  802700:	68 4a 01 00 00       	push   $0x14a
  802705:	68 e9 40 80 00       	push   $0x8040e9
  80270a:	e8 70 0f 00 00       	call   80367f <_panic>
  80270f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802715:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802718:	89 50 04             	mov    %edx,0x4(%eax)
  80271b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	85 c0                	test   %eax,%eax
  802723:	74 0c                	je     802731 <alloc_block_BF+0x30f>
  802725:	a1 30 50 80 00       	mov    0x805030,%eax
  80272a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80272d:	89 10                	mov    %edx,(%eax)
  80272f:	eb 08                	jmp    802739 <alloc_block_BF+0x317>
  802731:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802734:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802739:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80273c:	a3 30 50 80 00       	mov    %eax,0x805030
  802741:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802744:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274a:	a1 38 50 80 00       	mov    0x805038,%eax
  80274f:	40                   	inc    %eax
  802750:	a3 38 50 80 00       	mov    %eax,0x805038
  802755:	eb 6e                	jmp    8027c5 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802757:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80275b:	74 06                	je     802763 <alloc_block_BF+0x341>
  80275d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802761:	75 17                	jne    80277a <alloc_block_BF+0x358>
  802763:	83 ec 04             	sub    $0x4,%esp
  802766:	68 5c 41 80 00       	push   $0x80415c
  80276b:	68 4f 01 00 00       	push   $0x14f
  802770:	68 e9 40 80 00       	push   $0x8040e9
  802775:	e8 05 0f 00 00       	call   80367f <_panic>
  80277a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277d:	8b 10                	mov    (%eax),%edx
  80277f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802782:	89 10                	mov    %edx,(%eax)
  802784:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802787:	8b 00                	mov    (%eax),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 0b                	je     802798 <alloc_block_BF+0x376>
  80278d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802790:	8b 00                	mov    (%eax),%eax
  802792:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802795:	89 50 04             	mov    %edx,0x4(%eax)
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80279e:	89 10                	mov    %edx,(%eax)
  8027a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a6:	89 50 04             	mov    %edx,0x4(%eax)
  8027a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	75 08                	jne    8027ba <alloc_block_BF+0x398>
  8027b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8027ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8027bf:	40                   	inc    %eax
  8027c0:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8027c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c9:	75 17                	jne    8027e2 <alloc_block_BF+0x3c0>
  8027cb:	83 ec 04             	sub    $0x4,%esp
  8027ce:	68 cb 40 80 00       	push   $0x8040cb
  8027d3:	68 51 01 00 00       	push   $0x151
  8027d8:	68 e9 40 80 00       	push   $0x8040e9
  8027dd:	e8 9d 0e 00 00       	call   80367f <_panic>
  8027e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	74 10                	je     8027fb <alloc_block_BF+0x3d9>
  8027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f3:	8b 52 04             	mov    0x4(%edx),%edx
  8027f6:	89 50 04             	mov    %edx,0x4(%eax)
  8027f9:	eb 0b                	jmp    802806 <alloc_block_BF+0x3e4>
  8027fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fe:	8b 40 04             	mov    0x4(%eax),%eax
  802801:	a3 30 50 80 00       	mov    %eax,0x805030
  802806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802809:	8b 40 04             	mov    0x4(%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 0f                	je     80281f <alloc_block_BF+0x3fd>
  802810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802813:	8b 40 04             	mov    0x4(%eax),%eax
  802816:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802819:	8b 12                	mov    (%edx),%edx
  80281b:	89 10                	mov    %edx,(%eax)
  80281d:	eb 0a                	jmp    802829 <alloc_block_BF+0x407>
  80281f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802835:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283c:	a1 38 50 80 00       	mov    0x805038,%eax
  802841:	48                   	dec    %eax
  802842:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802847:	83 ec 04             	sub    $0x4,%esp
  80284a:	6a 00                	push   $0x0
  80284c:	ff 75 d0             	pushl  -0x30(%ebp)
  80284f:	ff 75 cc             	pushl  -0x34(%ebp)
  802852:	e8 e0 f6 ff ff       	call   801f37 <set_block_data>
  802857:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80285a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285d:	e9 a3 01 00 00       	jmp    802a05 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802862:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802866:	0f 85 9d 00 00 00    	jne    802909 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80286c:	83 ec 04             	sub    $0x4,%esp
  80286f:	6a 01                	push   $0x1
  802871:	ff 75 ec             	pushl  -0x14(%ebp)
  802874:	ff 75 f0             	pushl  -0x10(%ebp)
  802877:	e8 bb f6 ff ff       	call   801f37 <set_block_data>
  80287c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80287f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802883:	75 17                	jne    80289c <alloc_block_BF+0x47a>
  802885:	83 ec 04             	sub    $0x4,%esp
  802888:	68 cb 40 80 00       	push   $0x8040cb
  80288d:	68 58 01 00 00       	push   $0x158
  802892:	68 e9 40 80 00       	push   $0x8040e9
  802897:	e8 e3 0d 00 00       	call   80367f <_panic>
  80289c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289f:	8b 00                	mov    (%eax),%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	74 10                	je     8028b5 <alloc_block_BF+0x493>
  8028a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ad:	8b 52 04             	mov    0x4(%edx),%edx
  8028b0:	89 50 04             	mov    %edx,0x4(%eax)
  8028b3:	eb 0b                	jmp    8028c0 <alloc_block_BF+0x49e>
  8028b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b8:	8b 40 04             	mov    0x4(%eax),%eax
  8028bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	8b 40 04             	mov    0x4(%eax),%eax
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	74 0f                	je     8028d9 <alloc_block_BF+0x4b7>
  8028ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cd:	8b 40 04             	mov    0x4(%eax),%eax
  8028d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d3:	8b 12                	mov    (%edx),%edx
  8028d5:	89 10                	mov    %edx,(%eax)
  8028d7:	eb 0a                	jmp    8028e3 <alloc_block_BF+0x4c1>
  8028d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dc:	8b 00                	mov    (%eax),%eax
  8028de:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8028fb:	48                   	dec    %eax
  8028fc:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802904:	e9 fc 00 00 00       	jmp    802a05 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	83 c0 08             	add    $0x8,%eax
  80290f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802912:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802919:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80291c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80291f:	01 d0                	add    %edx,%eax
  802921:	48                   	dec    %eax
  802922:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802925:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802928:	ba 00 00 00 00       	mov    $0x0,%edx
  80292d:	f7 75 c4             	divl   -0x3c(%ebp)
  802930:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802933:	29 d0                	sub    %edx,%eax
  802935:	c1 e8 0c             	shr    $0xc,%eax
  802938:	83 ec 0c             	sub    $0xc,%esp
  80293b:	50                   	push   %eax
  80293c:	e8 a4 e7 ff ff       	call   8010e5 <sbrk>
  802941:	83 c4 10             	add    $0x10,%esp
  802944:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802947:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80294b:	75 0a                	jne    802957 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80294d:	b8 00 00 00 00       	mov    $0x0,%eax
  802952:	e9 ae 00 00 00       	jmp    802a05 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802957:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80295e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802961:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802964:	01 d0                	add    %edx,%eax
  802966:	48                   	dec    %eax
  802967:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80296a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80296d:	ba 00 00 00 00       	mov    $0x0,%edx
  802972:	f7 75 b8             	divl   -0x48(%ebp)
  802975:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802978:	29 d0                	sub    %edx,%eax
  80297a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80297d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802980:	01 d0                	add    %edx,%eax
  802982:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802987:	a1 40 50 80 00       	mov    0x805040,%eax
  80298c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802992:	83 ec 0c             	sub    $0xc,%esp
  802995:	68 90 41 80 00       	push   $0x804190
  80299a:	e8 ac d9 ff ff       	call   80034b <cprintf>
  80299f:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8029a2:	83 ec 08             	sub    $0x8,%esp
  8029a5:	ff 75 bc             	pushl  -0x44(%ebp)
  8029a8:	68 95 41 80 00       	push   $0x804195
  8029ad:	e8 99 d9 ff ff       	call   80034b <cprintf>
  8029b2:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8029b5:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8029bc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029bf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029c2:	01 d0                	add    %edx,%eax
  8029c4:	48                   	dec    %eax
  8029c5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8029c8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8029d0:	f7 75 b0             	divl   -0x50(%ebp)
  8029d3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029d6:	29 d0                	sub    %edx,%eax
  8029d8:	83 ec 04             	sub    $0x4,%esp
  8029db:	6a 01                	push   $0x1
  8029dd:	50                   	push   %eax
  8029de:	ff 75 bc             	pushl  -0x44(%ebp)
  8029e1:	e8 51 f5 ff ff       	call   801f37 <set_block_data>
  8029e6:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8029e9:	83 ec 0c             	sub    $0xc,%esp
  8029ec:	ff 75 bc             	pushl  -0x44(%ebp)
  8029ef:	e8 36 04 00 00       	call   802e2a <free_block>
  8029f4:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8029f7:	83 ec 0c             	sub    $0xc,%esp
  8029fa:	ff 75 08             	pushl  0x8(%ebp)
  8029fd:	e8 20 fa ff ff       	call   802422 <alloc_block_BF>
  802a02:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802a05:	c9                   	leave  
  802a06:	c3                   	ret    

00802a07 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802a07:	55                   	push   %ebp
  802a08:	89 e5                	mov    %esp,%ebp
  802a0a:	53                   	push   %ebx
  802a0b:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802a0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a15:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802a1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a20:	74 1e                	je     802a40 <merging+0x39>
  802a22:	ff 75 08             	pushl  0x8(%ebp)
  802a25:	e8 bc f1 ff ff       	call   801be6 <get_block_size>
  802a2a:	83 c4 04             	add    $0x4,%esp
  802a2d:	89 c2                	mov    %eax,%edx
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	01 d0                	add    %edx,%eax
  802a34:	3b 45 10             	cmp    0x10(%ebp),%eax
  802a37:	75 07                	jne    802a40 <merging+0x39>
		prev_is_free = 1;
  802a39:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802a40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a44:	74 1e                	je     802a64 <merging+0x5d>
  802a46:	ff 75 10             	pushl  0x10(%ebp)
  802a49:	e8 98 f1 ff ff       	call   801be6 <get_block_size>
  802a4e:	83 c4 04             	add    $0x4,%esp
  802a51:	89 c2                	mov    %eax,%edx
  802a53:	8b 45 10             	mov    0x10(%ebp),%eax
  802a56:	01 d0                	add    %edx,%eax
  802a58:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a5b:	75 07                	jne    802a64 <merging+0x5d>
		next_is_free = 1;
  802a5d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802a64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a68:	0f 84 cc 00 00 00    	je     802b3a <merging+0x133>
  802a6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a72:	0f 84 c2 00 00 00    	je     802b3a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802a78:	ff 75 08             	pushl  0x8(%ebp)
  802a7b:	e8 66 f1 ff ff       	call   801be6 <get_block_size>
  802a80:	83 c4 04             	add    $0x4,%esp
  802a83:	89 c3                	mov    %eax,%ebx
  802a85:	ff 75 10             	pushl  0x10(%ebp)
  802a88:	e8 59 f1 ff ff       	call   801be6 <get_block_size>
  802a8d:	83 c4 04             	add    $0x4,%esp
  802a90:	01 c3                	add    %eax,%ebx
  802a92:	ff 75 0c             	pushl  0xc(%ebp)
  802a95:	e8 4c f1 ff ff       	call   801be6 <get_block_size>
  802a9a:	83 c4 04             	add    $0x4,%esp
  802a9d:	01 d8                	add    %ebx,%eax
  802a9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802aa2:	6a 00                	push   $0x0
  802aa4:	ff 75 ec             	pushl  -0x14(%ebp)
  802aa7:	ff 75 08             	pushl  0x8(%ebp)
  802aaa:	e8 88 f4 ff ff       	call   801f37 <set_block_data>
  802aaf:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802ab2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ab6:	75 17                	jne    802acf <merging+0xc8>
  802ab8:	83 ec 04             	sub    $0x4,%esp
  802abb:	68 cb 40 80 00       	push   $0x8040cb
  802ac0:	68 7d 01 00 00       	push   $0x17d
  802ac5:	68 e9 40 80 00       	push   $0x8040e9
  802aca:	e8 b0 0b 00 00       	call   80367f <_panic>
  802acf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad2:	8b 00                	mov    (%eax),%eax
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	74 10                	je     802ae8 <merging+0xe1>
  802ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ae0:	8b 52 04             	mov    0x4(%edx),%edx
  802ae3:	89 50 04             	mov    %edx,0x4(%eax)
  802ae6:	eb 0b                	jmp    802af3 <merging+0xec>
  802ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aeb:	8b 40 04             	mov    0x4(%eax),%eax
  802aee:	a3 30 50 80 00       	mov    %eax,0x805030
  802af3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af6:	8b 40 04             	mov    0x4(%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	74 0f                	je     802b0c <merging+0x105>
  802afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b00:	8b 40 04             	mov    0x4(%eax),%eax
  802b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b06:	8b 12                	mov    (%edx),%edx
  802b08:	89 10                	mov    %edx,(%eax)
  802b0a:	eb 0a                	jmp    802b16 <merging+0x10f>
  802b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b29:	a1 38 50 80 00       	mov    0x805038,%eax
  802b2e:	48                   	dec    %eax
  802b2f:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802b34:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b35:	e9 ea 02 00 00       	jmp    802e24 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802b3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3e:	74 3b                	je     802b7b <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802b40:	83 ec 0c             	sub    $0xc,%esp
  802b43:	ff 75 08             	pushl  0x8(%ebp)
  802b46:	e8 9b f0 ff ff       	call   801be6 <get_block_size>
  802b4b:	83 c4 10             	add    $0x10,%esp
  802b4e:	89 c3                	mov    %eax,%ebx
  802b50:	83 ec 0c             	sub    $0xc,%esp
  802b53:	ff 75 10             	pushl  0x10(%ebp)
  802b56:	e8 8b f0 ff ff       	call   801be6 <get_block_size>
  802b5b:	83 c4 10             	add    $0x10,%esp
  802b5e:	01 d8                	add    %ebx,%eax
  802b60:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b63:	83 ec 04             	sub    $0x4,%esp
  802b66:	6a 00                	push   $0x0
  802b68:	ff 75 e8             	pushl  -0x18(%ebp)
  802b6b:	ff 75 08             	pushl  0x8(%ebp)
  802b6e:	e8 c4 f3 ff ff       	call   801f37 <set_block_data>
  802b73:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b76:	e9 a9 02 00 00       	jmp    802e24 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802b7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7f:	0f 84 2d 01 00 00    	je     802cb2 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802b85:	83 ec 0c             	sub    $0xc,%esp
  802b88:	ff 75 10             	pushl  0x10(%ebp)
  802b8b:	e8 56 f0 ff ff       	call   801be6 <get_block_size>
  802b90:	83 c4 10             	add    $0x10,%esp
  802b93:	89 c3                	mov    %eax,%ebx
  802b95:	83 ec 0c             	sub    $0xc,%esp
  802b98:	ff 75 0c             	pushl  0xc(%ebp)
  802b9b:	e8 46 f0 ff ff       	call   801be6 <get_block_size>
  802ba0:	83 c4 10             	add    $0x10,%esp
  802ba3:	01 d8                	add    %ebx,%eax
  802ba5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ba8:	83 ec 04             	sub    $0x4,%esp
  802bab:	6a 00                	push   $0x0
  802bad:	ff 75 e4             	pushl  -0x1c(%ebp)
  802bb0:	ff 75 10             	pushl  0x10(%ebp)
  802bb3:	e8 7f f3 ff ff       	call   801f37 <set_block_data>
  802bb8:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802bbb:	8b 45 10             	mov    0x10(%ebp),%eax
  802bbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802bc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bc5:	74 06                	je     802bcd <merging+0x1c6>
  802bc7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bcb:	75 17                	jne    802be4 <merging+0x1dd>
  802bcd:	83 ec 04             	sub    $0x4,%esp
  802bd0:	68 a4 41 80 00       	push   $0x8041a4
  802bd5:	68 8d 01 00 00       	push   $0x18d
  802bda:	68 e9 40 80 00       	push   $0x8040e9
  802bdf:	e8 9b 0a 00 00       	call   80367f <_panic>
  802be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be7:	8b 50 04             	mov    0x4(%eax),%edx
  802bea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bed:	89 50 04             	mov    %edx,0x4(%eax)
  802bf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf6:	89 10                	mov    %edx,(%eax)
  802bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bfb:	8b 40 04             	mov    0x4(%eax),%eax
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	74 0d                	je     802c0f <merging+0x208>
  802c02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c05:	8b 40 04             	mov    0x4(%eax),%eax
  802c08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c0b:	89 10                	mov    %edx,(%eax)
  802c0d:	eb 08                	jmp    802c17 <merging+0x210>
  802c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c12:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c1d:	89 50 04             	mov    %edx,0x4(%eax)
  802c20:	a1 38 50 80 00       	mov    0x805038,%eax
  802c25:	40                   	inc    %eax
  802c26:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802c2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c2f:	75 17                	jne    802c48 <merging+0x241>
  802c31:	83 ec 04             	sub    $0x4,%esp
  802c34:	68 cb 40 80 00       	push   $0x8040cb
  802c39:	68 8e 01 00 00       	push   $0x18e
  802c3e:	68 e9 40 80 00       	push   $0x8040e9
  802c43:	e8 37 0a 00 00       	call   80367f <_panic>
  802c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	85 c0                	test   %eax,%eax
  802c4f:	74 10                	je     802c61 <merging+0x25a>
  802c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c54:	8b 00                	mov    (%eax),%eax
  802c56:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c59:	8b 52 04             	mov    0x4(%edx),%edx
  802c5c:	89 50 04             	mov    %edx,0x4(%eax)
  802c5f:	eb 0b                	jmp    802c6c <merging+0x265>
  802c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c64:	8b 40 04             	mov    0x4(%eax),%eax
  802c67:	a3 30 50 80 00       	mov    %eax,0x805030
  802c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	85 c0                	test   %eax,%eax
  802c74:	74 0f                	je     802c85 <merging+0x27e>
  802c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c79:	8b 40 04             	mov    0x4(%eax),%eax
  802c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c7f:	8b 12                	mov    (%edx),%edx
  802c81:	89 10                	mov    %edx,(%eax)
  802c83:	eb 0a                	jmp    802c8f <merging+0x288>
  802c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c88:	8b 00                	mov    (%eax),%eax
  802c8a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ca7:	48                   	dec    %eax
  802ca8:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cad:	e9 72 01 00 00       	jmp    802e24 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802cb2:	8b 45 10             	mov    0x10(%ebp),%eax
  802cb5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802cb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cbc:	74 79                	je     802d37 <merging+0x330>
  802cbe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cc2:	74 73                	je     802d37 <merging+0x330>
  802cc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc8:	74 06                	je     802cd0 <merging+0x2c9>
  802cca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802cce:	75 17                	jne    802ce7 <merging+0x2e0>
  802cd0:	83 ec 04             	sub    $0x4,%esp
  802cd3:	68 5c 41 80 00       	push   $0x80415c
  802cd8:	68 94 01 00 00       	push   $0x194
  802cdd:	68 e9 40 80 00       	push   $0x8040e9
  802ce2:	e8 98 09 00 00       	call   80367f <_panic>
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	8b 10                	mov    (%eax),%edx
  802cec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cef:	89 10                	mov    %edx,(%eax)
  802cf1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cf4:	8b 00                	mov    (%eax),%eax
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	74 0b                	je     802d05 <merging+0x2fe>
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	8b 00                	mov    (%eax),%eax
  802cff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d02:	89 50 04             	mov    %edx,0x4(%eax)
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d0b:	89 10                	mov    %edx,(%eax)
  802d0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d10:	8b 55 08             	mov    0x8(%ebp),%edx
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	75 08                	jne    802d27 <merging+0x320>
  802d1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d22:	a3 30 50 80 00       	mov    %eax,0x805030
  802d27:	a1 38 50 80 00       	mov    0x805038,%eax
  802d2c:	40                   	inc    %eax
  802d2d:	a3 38 50 80 00       	mov    %eax,0x805038
  802d32:	e9 ce 00 00 00       	jmp    802e05 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802d37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d3b:	74 65                	je     802da2 <merging+0x39b>
  802d3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d41:	75 17                	jne    802d5a <merging+0x353>
  802d43:	83 ec 04             	sub    $0x4,%esp
  802d46:	68 38 41 80 00       	push   $0x804138
  802d4b:	68 95 01 00 00       	push   $0x195
  802d50:	68 e9 40 80 00       	push   $0x8040e9
  802d55:	e8 25 09 00 00       	call   80367f <_panic>
  802d5a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802d60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d63:	89 50 04             	mov    %edx,0x4(%eax)
  802d66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d69:	8b 40 04             	mov    0x4(%eax),%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	74 0c                	je     802d7c <merging+0x375>
  802d70:	a1 30 50 80 00       	mov    0x805030,%eax
  802d75:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d78:	89 10                	mov    %edx,(%eax)
  802d7a:	eb 08                	jmp    802d84 <merging+0x37d>
  802d7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d7f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d87:	a3 30 50 80 00       	mov    %eax,0x805030
  802d8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d95:	a1 38 50 80 00       	mov    0x805038,%eax
  802d9a:	40                   	inc    %eax
  802d9b:	a3 38 50 80 00       	mov    %eax,0x805038
  802da0:	eb 63                	jmp    802e05 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802da2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802da6:	75 17                	jne    802dbf <merging+0x3b8>
  802da8:	83 ec 04             	sub    $0x4,%esp
  802dab:	68 04 41 80 00       	push   $0x804104
  802db0:	68 98 01 00 00       	push   $0x198
  802db5:	68 e9 40 80 00       	push   $0x8040e9
  802dba:	e8 c0 08 00 00       	call   80367f <_panic>
  802dbf:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802dc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc8:	89 10                	mov    %edx,(%eax)
  802dca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	74 0d                	je     802de0 <merging+0x3d9>
  802dd3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802dd8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ddb:	89 50 04             	mov    %edx,0x4(%eax)
  802dde:	eb 08                	jmp    802de8 <merging+0x3e1>
  802de0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de3:	a3 30 50 80 00       	mov    %eax,0x805030
  802de8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802deb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802df0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfa:	a1 38 50 80 00       	mov    0x805038,%eax
  802dff:	40                   	inc    %eax
  802e00:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802e05:	83 ec 0c             	sub    $0xc,%esp
  802e08:	ff 75 10             	pushl  0x10(%ebp)
  802e0b:	e8 d6 ed ff ff       	call   801be6 <get_block_size>
  802e10:	83 c4 10             	add    $0x10,%esp
  802e13:	83 ec 04             	sub    $0x4,%esp
  802e16:	6a 00                	push   $0x0
  802e18:	50                   	push   %eax
  802e19:	ff 75 10             	pushl  0x10(%ebp)
  802e1c:	e8 16 f1 ff ff       	call   801f37 <set_block_data>
  802e21:	83 c4 10             	add    $0x10,%esp
	}
}
  802e24:	90                   	nop
  802e25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e28:	c9                   	leave  
  802e29:	c3                   	ret    

00802e2a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e2a:	55                   	push   %ebp
  802e2b:	89 e5                	mov    %esp,%ebp
  802e2d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802e30:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e35:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802e38:	a1 30 50 80 00       	mov    0x805030,%eax
  802e3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e40:	73 1b                	jae    802e5d <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802e42:	a1 30 50 80 00       	mov    0x805030,%eax
  802e47:	83 ec 04             	sub    $0x4,%esp
  802e4a:	ff 75 08             	pushl  0x8(%ebp)
  802e4d:	6a 00                	push   $0x0
  802e4f:	50                   	push   %eax
  802e50:	e8 b2 fb ff ff       	call   802a07 <merging>
  802e55:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e58:	e9 8b 00 00 00       	jmp    802ee8 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802e5d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e62:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e65:	76 18                	jbe    802e7f <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802e67:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e6c:	83 ec 04             	sub    $0x4,%esp
  802e6f:	ff 75 08             	pushl  0x8(%ebp)
  802e72:	50                   	push   %eax
  802e73:	6a 00                	push   $0x0
  802e75:	e8 8d fb ff ff       	call   802a07 <merging>
  802e7a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e7d:	eb 69                	jmp    802ee8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802e7f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e87:	eb 39                	jmp    802ec2 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e8f:	73 29                	jae    802eba <free_block+0x90>
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	8b 00                	mov    (%eax),%eax
  802e96:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e99:	76 1f                	jbe    802eba <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 00                	mov    (%eax),%eax
  802ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802ea3:	83 ec 04             	sub    $0x4,%esp
  802ea6:	ff 75 08             	pushl  0x8(%ebp)
  802ea9:	ff 75 f0             	pushl  -0x10(%ebp)
  802eac:	ff 75 f4             	pushl  -0xc(%ebp)
  802eaf:	e8 53 fb ff ff       	call   802a07 <merging>
  802eb4:	83 c4 10             	add    $0x10,%esp
			break;
  802eb7:	90                   	nop
		}
	}
}
  802eb8:	eb 2e                	jmp    802ee8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802eba:	a1 34 50 80 00       	mov    0x805034,%eax
  802ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec6:	74 07                	je     802ecf <free_block+0xa5>
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 00                	mov    (%eax),%eax
  802ecd:	eb 05                	jmp    802ed4 <free_block+0xaa>
  802ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ed4:	a3 34 50 80 00       	mov    %eax,0x805034
  802ed9:	a1 34 50 80 00       	mov    0x805034,%eax
  802ede:	85 c0                	test   %eax,%eax
  802ee0:	75 a7                	jne    802e89 <free_block+0x5f>
  802ee2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee6:	75 a1                	jne    802e89 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ee8:	90                   	nop
  802ee9:	c9                   	leave  
  802eea:	c3                   	ret    

00802eeb <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802eeb:	55                   	push   %ebp
  802eec:	89 e5                	mov    %esp,%ebp
  802eee:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802ef1:	ff 75 08             	pushl  0x8(%ebp)
  802ef4:	e8 ed ec ff ff       	call   801be6 <get_block_size>
  802ef9:	83 c4 04             	add    $0x4,%esp
  802efc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802eff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802f06:	eb 17                	jmp    802f1f <copy_data+0x34>
  802f08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f0e:	01 c2                	add    %eax,%edx
  802f10:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	01 c8                	add    %ecx,%eax
  802f18:	8a 00                	mov    (%eax),%al
  802f1a:	88 02                	mov    %al,(%edx)
  802f1c:	ff 45 fc             	incl   -0x4(%ebp)
  802f1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f22:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802f25:	72 e1                	jb     802f08 <copy_data+0x1d>
}
  802f27:	90                   	nop
  802f28:	c9                   	leave  
  802f29:	c3                   	ret    

00802f2a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802f2a:	55                   	push   %ebp
  802f2b:	89 e5                	mov    %esp,%ebp
  802f2d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802f30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f34:	75 23                	jne    802f59 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802f36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f3a:	74 13                	je     802f4f <realloc_block_FF+0x25>
  802f3c:	83 ec 0c             	sub    $0xc,%esp
  802f3f:	ff 75 0c             	pushl  0xc(%ebp)
  802f42:	e8 1f f0 ff ff       	call   801f66 <alloc_block_FF>
  802f47:	83 c4 10             	add    $0x10,%esp
  802f4a:	e9 f4 06 00 00       	jmp    803643 <realloc_block_FF+0x719>
		return NULL;
  802f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f54:	e9 ea 06 00 00       	jmp    803643 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802f59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f5d:	75 18                	jne    802f77 <realloc_block_FF+0x4d>
	{
		free_block(va);
  802f5f:	83 ec 0c             	sub    $0xc,%esp
  802f62:	ff 75 08             	pushl  0x8(%ebp)
  802f65:	e8 c0 fe ff ff       	call   802e2a <free_block>
  802f6a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f72:	e9 cc 06 00 00       	jmp    803643 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  802f77:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802f7b:	77 07                	ja     802f84 <realloc_block_FF+0x5a>
  802f7d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f87:	83 e0 01             	and    $0x1,%eax
  802f8a:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f90:	83 c0 08             	add    $0x8,%eax
  802f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  802f96:	83 ec 0c             	sub    $0xc,%esp
  802f99:	ff 75 08             	pushl  0x8(%ebp)
  802f9c:	e8 45 ec ff ff       	call   801be6 <get_block_size>
  802fa1:	83 c4 10             	add    $0x10,%esp
  802fa4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faa:	83 e8 08             	sub    $0x8,%eax
  802fad:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	83 e8 04             	sub    $0x4,%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	83 e0 fe             	and    $0xfffffffe,%eax
  802fbb:	89 c2                	mov    %eax,%edx
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	01 d0                	add    %edx,%eax
  802fc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  802fc5:	83 ec 0c             	sub    $0xc,%esp
  802fc8:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fcb:	e8 16 ec ff ff       	call   801be6 <get_block_size>
  802fd0:	83 c4 10             	add    $0x10,%esp
  802fd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802fd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd9:	83 e8 08             	sub    $0x8,%eax
  802fdc:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  802fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fe5:	75 08                	jne    802fef <realloc_block_FF+0xc5>
	{
		 return va;
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	e9 54 06 00 00       	jmp    803643 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  802fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ff2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ff5:	0f 83 e5 03 00 00    	jae    8033e0 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  802ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffe:	2b 45 0c             	sub    0xc(%ebp),%eax
  803001:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803004:	83 ec 0c             	sub    $0xc,%esp
  803007:	ff 75 e4             	pushl  -0x1c(%ebp)
  80300a:	e8 f0 eb ff ff       	call   801bff <is_free_block>
  80300f:	83 c4 10             	add    $0x10,%esp
  803012:	84 c0                	test   %al,%al
  803014:	0f 84 3b 01 00 00    	je     803155 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80301a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80301d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803020:	01 d0                	add    %edx,%eax
  803022:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803025:	83 ec 04             	sub    $0x4,%esp
  803028:	6a 01                	push   $0x1
  80302a:	ff 75 f0             	pushl  -0x10(%ebp)
  80302d:	ff 75 08             	pushl  0x8(%ebp)
  803030:	e8 02 ef ff ff       	call   801f37 <set_block_data>
  803035:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	83 e8 04             	sub    $0x4,%eax
  80303e:	8b 00                	mov    (%eax),%eax
  803040:	83 e0 fe             	and    $0xfffffffe,%eax
  803043:	89 c2                	mov    %eax,%edx
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	01 d0                	add    %edx,%eax
  80304a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80304d:	83 ec 04             	sub    $0x4,%esp
  803050:	6a 00                	push   $0x0
  803052:	ff 75 cc             	pushl  -0x34(%ebp)
  803055:	ff 75 c8             	pushl  -0x38(%ebp)
  803058:	e8 da ee ff ff       	call   801f37 <set_block_data>
  80305d:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803060:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803064:	74 06                	je     80306c <realloc_block_FF+0x142>
  803066:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80306a:	75 17                	jne    803083 <realloc_block_FF+0x159>
  80306c:	83 ec 04             	sub    $0x4,%esp
  80306f:	68 5c 41 80 00       	push   $0x80415c
  803074:	68 f6 01 00 00       	push   $0x1f6
  803079:	68 e9 40 80 00       	push   $0x8040e9
  80307e:	e8 fc 05 00 00       	call   80367f <_panic>
  803083:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803086:	8b 10                	mov    (%eax),%edx
  803088:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80308b:	89 10                	mov    %edx,(%eax)
  80308d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	85 c0                	test   %eax,%eax
  803094:	74 0b                	je     8030a1 <realloc_block_FF+0x177>
  803096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80309e:	89 50 04             	mov    %edx,0x4(%eax)
  8030a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030a7:	89 10                	mov    %edx,(%eax)
  8030a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030af:	89 50 04             	mov    %edx,0x4(%eax)
  8030b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030b5:	8b 00                	mov    (%eax),%eax
  8030b7:	85 c0                	test   %eax,%eax
  8030b9:	75 08                	jne    8030c3 <realloc_block_FF+0x199>
  8030bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030be:	a3 30 50 80 00       	mov    %eax,0x805030
  8030c3:	a1 38 50 80 00       	mov    0x805038,%eax
  8030c8:	40                   	inc    %eax
  8030c9:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8030ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030d2:	75 17                	jne    8030eb <realloc_block_FF+0x1c1>
  8030d4:	83 ec 04             	sub    $0x4,%esp
  8030d7:	68 cb 40 80 00       	push   $0x8040cb
  8030dc:	68 f7 01 00 00       	push   $0x1f7
  8030e1:	68 e9 40 80 00       	push   $0x8040e9
  8030e6:	e8 94 05 00 00       	call   80367f <_panic>
  8030eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	74 10                	je     803104 <realloc_block_FF+0x1da>
  8030f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030fc:	8b 52 04             	mov    0x4(%edx),%edx
  8030ff:	89 50 04             	mov    %edx,0x4(%eax)
  803102:	eb 0b                	jmp    80310f <realloc_block_FF+0x1e5>
  803104:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803107:	8b 40 04             	mov    0x4(%eax),%eax
  80310a:	a3 30 50 80 00       	mov    %eax,0x805030
  80310f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803112:	8b 40 04             	mov    0x4(%eax),%eax
  803115:	85 c0                	test   %eax,%eax
  803117:	74 0f                	je     803128 <realloc_block_FF+0x1fe>
  803119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311c:	8b 40 04             	mov    0x4(%eax),%eax
  80311f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803122:	8b 12                	mov    (%edx),%edx
  803124:	89 10                	mov    %edx,(%eax)
  803126:	eb 0a                	jmp    803132 <realloc_block_FF+0x208>
  803128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312b:	8b 00                	mov    (%eax),%eax
  80312d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803135:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803145:	a1 38 50 80 00       	mov    0x805038,%eax
  80314a:	48                   	dec    %eax
  80314b:	a3 38 50 80 00       	mov    %eax,0x805038
  803150:	e9 83 02 00 00       	jmp    8033d8 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803155:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803159:	0f 86 69 02 00 00    	jbe    8033c8 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80315f:	83 ec 04             	sub    $0x4,%esp
  803162:	6a 01                	push   $0x1
  803164:	ff 75 f0             	pushl  -0x10(%ebp)
  803167:	ff 75 08             	pushl  0x8(%ebp)
  80316a:	e8 c8 ed ff ff       	call   801f37 <set_block_data>
  80316f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	83 e8 04             	sub    $0x4,%eax
  803178:	8b 00                	mov    (%eax),%eax
  80317a:	83 e0 fe             	and    $0xfffffffe,%eax
  80317d:	89 c2                	mov    %eax,%edx
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	01 d0                	add    %edx,%eax
  803184:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803187:	a1 38 50 80 00       	mov    0x805038,%eax
  80318c:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80318f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803193:	75 68                	jne    8031fd <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803195:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803199:	75 17                	jne    8031b2 <realloc_block_FF+0x288>
  80319b:	83 ec 04             	sub    $0x4,%esp
  80319e:	68 04 41 80 00       	push   $0x804104
  8031a3:	68 06 02 00 00       	push   $0x206
  8031a8:	68 e9 40 80 00       	push   $0x8040e9
  8031ad:	e8 cd 04 00 00       	call   80367f <_panic>
  8031b2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031bb:	89 10                	mov    %edx,(%eax)
  8031bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031c0:	8b 00                	mov    (%eax),%eax
  8031c2:	85 c0                	test   %eax,%eax
  8031c4:	74 0d                	je     8031d3 <realloc_block_FF+0x2a9>
  8031c6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031ce:	89 50 04             	mov    %edx,0x4(%eax)
  8031d1:	eb 08                	jmp    8031db <realloc_block_FF+0x2b1>
  8031d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031d6:	a3 30 50 80 00       	mov    %eax,0x805030
  8031db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031de:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8031f2:	40                   	inc    %eax
  8031f3:	a3 38 50 80 00       	mov    %eax,0x805038
  8031f8:	e9 b0 01 00 00       	jmp    8033ad <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8031fd:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803202:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803205:	76 68                	jbe    80326f <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803207:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80320b:	75 17                	jne    803224 <realloc_block_FF+0x2fa>
  80320d:	83 ec 04             	sub    $0x4,%esp
  803210:	68 04 41 80 00       	push   $0x804104
  803215:	68 0b 02 00 00       	push   $0x20b
  80321a:	68 e9 40 80 00       	push   $0x8040e9
  80321f:	e8 5b 04 00 00       	call   80367f <_panic>
  803224:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80322a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80322d:	89 10                	mov    %edx,(%eax)
  80322f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803232:	8b 00                	mov    (%eax),%eax
  803234:	85 c0                	test   %eax,%eax
  803236:	74 0d                	je     803245 <realloc_block_FF+0x31b>
  803238:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80323d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803240:	89 50 04             	mov    %edx,0x4(%eax)
  803243:	eb 08                	jmp    80324d <realloc_block_FF+0x323>
  803245:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803248:	a3 30 50 80 00       	mov    %eax,0x805030
  80324d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803250:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803255:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803258:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325f:	a1 38 50 80 00       	mov    0x805038,%eax
  803264:	40                   	inc    %eax
  803265:	a3 38 50 80 00       	mov    %eax,0x805038
  80326a:	e9 3e 01 00 00       	jmp    8033ad <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80326f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803274:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803277:	73 68                	jae    8032e1 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803279:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80327d:	75 17                	jne    803296 <realloc_block_FF+0x36c>
  80327f:	83 ec 04             	sub    $0x4,%esp
  803282:	68 38 41 80 00       	push   $0x804138
  803287:	68 10 02 00 00       	push   $0x210
  80328c:	68 e9 40 80 00       	push   $0x8040e9
  803291:	e8 e9 03 00 00       	call   80367f <_panic>
  803296:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80329c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80329f:	89 50 04             	mov    %edx,0x4(%eax)
  8032a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032a5:	8b 40 04             	mov    0x4(%eax),%eax
  8032a8:	85 c0                	test   %eax,%eax
  8032aa:	74 0c                	je     8032b8 <realloc_block_FF+0x38e>
  8032ac:	a1 30 50 80 00       	mov    0x805030,%eax
  8032b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032b4:	89 10                	mov    %edx,(%eax)
  8032b6:	eb 08                	jmp    8032c0 <realloc_block_FF+0x396>
  8032b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032bb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032c3:	a3 30 50 80 00       	mov    %eax,0x805030
  8032c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8032d6:	40                   	inc    %eax
  8032d7:	a3 38 50 80 00       	mov    %eax,0x805038
  8032dc:	e9 cc 00 00 00       	jmp    8033ad <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8032e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8032e8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f0:	e9 8a 00 00 00       	jmp    80337f <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8032f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032fb:	73 7a                	jae    803377 <realloc_block_FF+0x44d>
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	8b 00                	mov    (%eax),%eax
  803302:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803305:	73 70                	jae    803377 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330b:	74 06                	je     803313 <realloc_block_FF+0x3e9>
  80330d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803311:	75 17                	jne    80332a <realloc_block_FF+0x400>
  803313:	83 ec 04             	sub    $0x4,%esp
  803316:	68 5c 41 80 00       	push   $0x80415c
  80331b:	68 1a 02 00 00       	push   $0x21a
  803320:	68 e9 40 80 00       	push   $0x8040e9
  803325:	e8 55 03 00 00       	call   80367f <_panic>
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	8b 10                	mov    (%eax),%edx
  80332f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803332:	89 10                	mov    %edx,(%eax)
  803334:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803337:	8b 00                	mov    (%eax),%eax
  803339:	85 c0                	test   %eax,%eax
  80333b:	74 0b                	je     803348 <realloc_block_FF+0x41e>
  80333d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803340:	8b 00                	mov    (%eax),%eax
  803342:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803345:	89 50 04             	mov    %edx,0x4(%eax)
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80334e:	89 10                	mov    %edx,(%eax)
  803350:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803356:	89 50 04             	mov    %edx,0x4(%eax)
  803359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	85 c0                	test   %eax,%eax
  803360:	75 08                	jne    80336a <realloc_block_FF+0x440>
  803362:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803365:	a3 30 50 80 00       	mov    %eax,0x805030
  80336a:	a1 38 50 80 00       	mov    0x805038,%eax
  80336f:	40                   	inc    %eax
  803370:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803375:	eb 36                	jmp    8033ad <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803377:	a1 34 50 80 00       	mov    0x805034,%eax
  80337c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80337f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803383:	74 07                	je     80338c <realloc_block_FF+0x462>
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	8b 00                	mov    (%eax),%eax
  80338a:	eb 05                	jmp    803391 <realloc_block_FF+0x467>
  80338c:	b8 00 00 00 00       	mov    $0x0,%eax
  803391:	a3 34 50 80 00       	mov    %eax,0x805034
  803396:	a1 34 50 80 00       	mov    0x805034,%eax
  80339b:	85 c0                	test   %eax,%eax
  80339d:	0f 85 52 ff ff ff    	jne    8032f5 <realloc_block_FF+0x3cb>
  8033a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a7:	0f 85 48 ff ff ff    	jne    8032f5 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8033ad:	83 ec 04             	sub    $0x4,%esp
  8033b0:	6a 00                	push   $0x0
  8033b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8033b5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033b8:	e8 7a eb ff ff       	call   801f37 <set_block_data>
  8033bd:	83 c4 10             	add    $0x10,%esp
				return va;
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	e9 7b 02 00 00       	jmp    803643 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8033c8:	83 ec 0c             	sub    $0xc,%esp
  8033cb:	68 d9 41 80 00       	push   $0x8041d9
  8033d0:	e8 76 cf ff ff       	call   80034b <cprintf>
  8033d5:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8033d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033db:	e9 63 02 00 00       	jmp    803643 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8033e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033e3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033e6:	0f 86 4d 02 00 00    	jbe    803639 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8033ec:	83 ec 0c             	sub    $0xc,%esp
  8033ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033f2:	e8 08 e8 ff ff       	call   801bff <is_free_block>
  8033f7:	83 c4 10             	add    $0x10,%esp
  8033fa:	84 c0                	test   %al,%al
  8033fc:	0f 84 37 02 00 00    	je     803639 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803402:	8b 45 0c             	mov    0xc(%ebp),%eax
  803405:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803408:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80340b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80340e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803411:	76 38                	jbe    80344b <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803413:	83 ec 0c             	sub    $0xc,%esp
  803416:	ff 75 08             	pushl  0x8(%ebp)
  803419:	e8 0c fa ff ff       	call   802e2a <free_block>
  80341e:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803421:	83 ec 0c             	sub    $0xc,%esp
  803424:	ff 75 0c             	pushl  0xc(%ebp)
  803427:	e8 3a eb ff ff       	call   801f66 <alloc_block_FF>
  80342c:	83 c4 10             	add    $0x10,%esp
  80342f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803432:	83 ec 08             	sub    $0x8,%esp
  803435:	ff 75 c0             	pushl  -0x40(%ebp)
  803438:	ff 75 08             	pushl  0x8(%ebp)
  80343b:	e8 ab fa ff ff       	call   802eeb <copy_data>
  803440:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803443:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803446:	e9 f8 01 00 00       	jmp    803643 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80344b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80344e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803451:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803454:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803458:	0f 87 a0 00 00 00    	ja     8034fe <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80345e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803462:	75 17                	jne    80347b <realloc_block_FF+0x551>
  803464:	83 ec 04             	sub    $0x4,%esp
  803467:	68 cb 40 80 00       	push   $0x8040cb
  80346c:	68 38 02 00 00       	push   $0x238
  803471:	68 e9 40 80 00       	push   $0x8040e9
  803476:	e8 04 02 00 00       	call   80367f <_panic>
  80347b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347e:	8b 00                	mov    (%eax),%eax
  803480:	85 c0                	test   %eax,%eax
  803482:	74 10                	je     803494 <realloc_block_FF+0x56a>
  803484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803487:	8b 00                	mov    (%eax),%eax
  803489:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348c:	8b 52 04             	mov    0x4(%edx),%edx
  80348f:	89 50 04             	mov    %edx,0x4(%eax)
  803492:	eb 0b                	jmp    80349f <realloc_block_FF+0x575>
  803494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803497:	8b 40 04             	mov    0x4(%eax),%eax
  80349a:	a3 30 50 80 00       	mov    %eax,0x805030
  80349f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a2:	8b 40 04             	mov    0x4(%eax),%eax
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	74 0f                	je     8034b8 <realloc_block_FF+0x58e>
  8034a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ac:	8b 40 04             	mov    0x4(%eax),%eax
  8034af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034b2:	8b 12                	mov    (%edx),%edx
  8034b4:	89 10                	mov    %edx,(%eax)
  8034b6:	eb 0a                	jmp    8034c2 <realloc_block_FF+0x598>
  8034b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bb:	8b 00                	mov    (%eax),%eax
  8034bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d5:	a1 38 50 80 00       	mov    0x805038,%eax
  8034da:	48                   	dec    %eax
  8034db:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8034e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e6:	01 d0                	add    %edx,%eax
  8034e8:	83 ec 04             	sub    $0x4,%esp
  8034eb:	6a 01                	push   $0x1
  8034ed:	50                   	push   %eax
  8034ee:	ff 75 08             	pushl  0x8(%ebp)
  8034f1:	e8 41 ea ff ff       	call   801f37 <set_block_data>
  8034f6:	83 c4 10             	add    $0x10,%esp
  8034f9:	e9 36 01 00 00       	jmp    803634 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8034fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803501:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803504:	01 d0                	add    %edx,%eax
  803506:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803509:	83 ec 04             	sub    $0x4,%esp
  80350c:	6a 01                	push   $0x1
  80350e:	ff 75 f0             	pushl  -0x10(%ebp)
  803511:	ff 75 08             	pushl  0x8(%ebp)
  803514:	e8 1e ea ff ff       	call   801f37 <set_block_data>
  803519:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80351c:	8b 45 08             	mov    0x8(%ebp),%eax
  80351f:	83 e8 04             	sub    $0x4,%eax
  803522:	8b 00                	mov    (%eax),%eax
  803524:	83 e0 fe             	and    $0xfffffffe,%eax
  803527:	89 c2                	mov    %eax,%edx
  803529:	8b 45 08             	mov    0x8(%ebp),%eax
  80352c:	01 d0                	add    %edx,%eax
  80352e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803531:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803535:	74 06                	je     80353d <realloc_block_FF+0x613>
  803537:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80353b:	75 17                	jne    803554 <realloc_block_FF+0x62a>
  80353d:	83 ec 04             	sub    $0x4,%esp
  803540:	68 5c 41 80 00       	push   $0x80415c
  803545:	68 44 02 00 00       	push   $0x244
  80354a:	68 e9 40 80 00       	push   $0x8040e9
  80354f:	e8 2b 01 00 00       	call   80367f <_panic>
  803554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803557:	8b 10                	mov    (%eax),%edx
  803559:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80355c:	89 10                	mov    %edx,(%eax)
  80355e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803561:	8b 00                	mov    (%eax),%eax
  803563:	85 c0                	test   %eax,%eax
  803565:	74 0b                	je     803572 <realloc_block_FF+0x648>
  803567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356a:	8b 00                	mov    (%eax),%eax
  80356c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80356f:	89 50 04             	mov    %edx,0x4(%eax)
  803572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803575:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803578:	89 10                	mov    %edx,(%eax)
  80357a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80357d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803580:	89 50 04             	mov    %edx,0x4(%eax)
  803583:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803586:	8b 00                	mov    (%eax),%eax
  803588:	85 c0                	test   %eax,%eax
  80358a:	75 08                	jne    803594 <realloc_block_FF+0x66a>
  80358c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80358f:	a3 30 50 80 00       	mov    %eax,0x805030
  803594:	a1 38 50 80 00       	mov    0x805038,%eax
  803599:	40                   	inc    %eax
  80359a:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80359f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a3:	75 17                	jne    8035bc <realloc_block_FF+0x692>
  8035a5:	83 ec 04             	sub    $0x4,%esp
  8035a8:	68 cb 40 80 00       	push   $0x8040cb
  8035ad:	68 45 02 00 00       	push   $0x245
  8035b2:	68 e9 40 80 00       	push   $0x8040e9
  8035b7:	e8 c3 00 00 00       	call   80367f <_panic>
  8035bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	85 c0                	test   %eax,%eax
  8035c3:	74 10                	je     8035d5 <realloc_block_FF+0x6ab>
  8035c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c8:	8b 00                	mov    (%eax),%eax
  8035ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035cd:	8b 52 04             	mov    0x4(%edx),%edx
  8035d0:	89 50 04             	mov    %edx,0x4(%eax)
  8035d3:	eb 0b                	jmp    8035e0 <realloc_block_FF+0x6b6>
  8035d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d8:	8b 40 04             	mov    0x4(%eax),%eax
  8035db:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e3:	8b 40 04             	mov    0x4(%eax),%eax
  8035e6:	85 c0                	test   %eax,%eax
  8035e8:	74 0f                	je     8035f9 <realloc_block_FF+0x6cf>
  8035ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ed:	8b 40 04             	mov    0x4(%eax),%eax
  8035f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f3:	8b 12                	mov    (%edx),%edx
  8035f5:	89 10                	mov    %edx,(%eax)
  8035f7:	eb 0a                	jmp    803603 <realloc_block_FF+0x6d9>
  8035f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fc:	8b 00                	mov    (%eax),%eax
  8035fe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803606:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80360c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803616:	a1 38 50 80 00       	mov    0x805038,%eax
  80361b:	48                   	dec    %eax
  80361c:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803621:	83 ec 04             	sub    $0x4,%esp
  803624:	6a 00                	push   $0x0
  803626:	ff 75 bc             	pushl  -0x44(%ebp)
  803629:	ff 75 b8             	pushl  -0x48(%ebp)
  80362c:	e8 06 e9 ff ff       	call   801f37 <set_block_data>
  803631:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803634:	8b 45 08             	mov    0x8(%ebp),%eax
  803637:	eb 0a                	jmp    803643 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803639:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803640:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803643:	c9                   	leave  
  803644:	c3                   	ret    

00803645 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803645:	55                   	push   %ebp
  803646:	89 e5                	mov    %esp,%ebp
  803648:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80364b:	83 ec 04             	sub    $0x4,%esp
  80364e:	68 e0 41 80 00       	push   $0x8041e0
  803653:	68 58 02 00 00       	push   $0x258
  803658:	68 e9 40 80 00       	push   $0x8040e9
  80365d:	e8 1d 00 00 00       	call   80367f <_panic>

00803662 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803662:	55                   	push   %ebp
  803663:	89 e5                	mov    %esp,%ebp
  803665:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803668:	83 ec 04             	sub    $0x4,%esp
  80366b:	68 08 42 80 00       	push   $0x804208
  803670:	68 61 02 00 00       	push   $0x261
  803675:	68 e9 40 80 00       	push   $0x8040e9
  80367a:	e8 00 00 00 00       	call   80367f <_panic>

0080367f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80367f:	55                   	push   %ebp
  803680:	89 e5                	mov    %esp,%ebp
  803682:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803685:	8d 45 10             	lea    0x10(%ebp),%eax
  803688:	83 c0 04             	add    $0x4,%eax
  80368b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80368e:	a1 60 50 90 00       	mov    0x905060,%eax
  803693:	85 c0                	test   %eax,%eax
  803695:	74 16                	je     8036ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  803697:	a1 60 50 90 00       	mov    0x905060,%eax
  80369c:	83 ec 08             	sub    $0x8,%esp
  80369f:	50                   	push   %eax
  8036a0:	68 30 42 80 00       	push   $0x804230
  8036a5:	e8 a1 cc ff ff       	call   80034b <cprintf>
  8036aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8036ad:	a1 00 50 80 00       	mov    0x805000,%eax
  8036b2:	ff 75 0c             	pushl  0xc(%ebp)
  8036b5:	ff 75 08             	pushl  0x8(%ebp)
  8036b8:	50                   	push   %eax
  8036b9:	68 35 42 80 00       	push   $0x804235
  8036be:	e8 88 cc ff ff       	call   80034b <cprintf>
  8036c3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8036c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8036c9:	83 ec 08             	sub    $0x8,%esp
  8036cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8036cf:	50                   	push   %eax
  8036d0:	e8 0b cc ff ff       	call   8002e0 <vcprintf>
  8036d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8036d8:	83 ec 08             	sub    $0x8,%esp
  8036db:	6a 00                	push   $0x0
  8036dd:	68 51 42 80 00       	push   $0x804251
  8036e2:	e8 f9 cb ff ff       	call   8002e0 <vcprintf>
  8036e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8036ea:	e8 7a cb ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  8036ef:	eb fe                	jmp    8036ef <_panic+0x70>

008036f1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8036f1:	55                   	push   %ebp
  8036f2:	89 e5                	mov    %esp,%ebp
  8036f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8036f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8036fc:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803702:	8b 45 0c             	mov    0xc(%ebp),%eax
  803705:	39 c2                	cmp    %eax,%edx
  803707:	74 14                	je     80371d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803709:	83 ec 04             	sub    $0x4,%esp
  80370c:	68 54 42 80 00       	push   $0x804254
  803711:	6a 26                	push   $0x26
  803713:	68 a0 42 80 00       	push   $0x8042a0
  803718:	e8 62 ff ff ff       	call   80367f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80371d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803724:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80372b:	e9 c5 00 00 00       	jmp    8037f5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803733:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	01 d0                	add    %edx,%eax
  80373f:	8b 00                	mov    (%eax),%eax
  803741:	85 c0                	test   %eax,%eax
  803743:	75 08                	jne    80374d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803745:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803748:	e9 a5 00 00 00       	jmp    8037f2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80374d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803754:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80375b:	eb 69                	jmp    8037c6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80375d:	a1 20 50 80 00       	mov    0x805020,%eax
  803762:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803768:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80376b:	89 d0                	mov    %edx,%eax
  80376d:	01 c0                	add    %eax,%eax
  80376f:	01 d0                	add    %edx,%eax
  803771:	c1 e0 03             	shl    $0x3,%eax
  803774:	01 c8                	add    %ecx,%eax
  803776:	8a 40 04             	mov    0x4(%eax),%al
  803779:	84 c0                	test   %al,%al
  80377b:	75 46                	jne    8037c3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80377d:	a1 20 50 80 00       	mov    0x805020,%eax
  803782:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803788:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80378b:	89 d0                	mov    %edx,%eax
  80378d:	01 c0                	add    %eax,%eax
  80378f:	01 d0                	add    %edx,%eax
  803791:	c1 e0 03             	shl    $0x3,%eax
  803794:	01 c8                	add    %ecx,%eax
  803796:	8b 00                	mov    (%eax),%eax
  803798:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80379b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80379e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8037a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8037a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8037af:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b2:	01 c8                	add    %ecx,%eax
  8037b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8037b6:	39 c2                	cmp    %eax,%edx
  8037b8:	75 09                	jne    8037c3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8037ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8037c1:	eb 15                	jmp    8037d8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037c3:	ff 45 e8             	incl   -0x18(%ebp)
  8037c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8037cb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8037d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d4:	39 c2                	cmp    %eax,%edx
  8037d6:	77 85                	ja     80375d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8037d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037dc:	75 14                	jne    8037f2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8037de:	83 ec 04             	sub    $0x4,%esp
  8037e1:	68 ac 42 80 00       	push   $0x8042ac
  8037e6:	6a 3a                	push   $0x3a
  8037e8:	68 a0 42 80 00       	push   $0x8042a0
  8037ed:	e8 8d fe ff ff       	call   80367f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8037f2:	ff 45 f0             	incl   -0x10(%ebp)
  8037f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037fb:	0f 8c 2f ff ff ff    	jl     803730 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803801:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803808:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80380f:	eb 26                	jmp    803837 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803811:	a1 20 50 80 00       	mov    0x805020,%eax
  803816:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80381c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80381f:	89 d0                	mov    %edx,%eax
  803821:	01 c0                	add    %eax,%eax
  803823:	01 d0                	add    %edx,%eax
  803825:	c1 e0 03             	shl    $0x3,%eax
  803828:	01 c8                	add    %ecx,%eax
  80382a:	8a 40 04             	mov    0x4(%eax),%al
  80382d:	3c 01                	cmp    $0x1,%al
  80382f:	75 03                	jne    803834 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803831:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803834:	ff 45 e0             	incl   -0x20(%ebp)
  803837:	a1 20 50 80 00       	mov    0x805020,%eax
  80383c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803842:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803845:	39 c2                	cmp    %eax,%edx
  803847:	77 c8                	ja     803811 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80384f:	74 14                	je     803865 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803851:	83 ec 04             	sub    $0x4,%esp
  803854:	68 00 43 80 00       	push   $0x804300
  803859:	6a 44                	push   $0x44
  80385b:	68 a0 42 80 00       	push   $0x8042a0
  803860:	e8 1a fe ff ff       	call   80367f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803865:	90                   	nop
  803866:	c9                   	leave  
  803867:	c3                   	ret    

00803868 <__udivdi3>:
  803868:	55                   	push   %ebp
  803869:	57                   	push   %edi
  80386a:	56                   	push   %esi
  80386b:	53                   	push   %ebx
  80386c:	83 ec 1c             	sub    $0x1c,%esp
  80386f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803873:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803877:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80387b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80387f:	89 ca                	mov    %ecx,%edx
  803881:	89 f8                	mov    %edi,%eax
  803883:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803887:	85 f6                	test   %esi,%esi
  803889:	75 2d                	jne    8038b8 <__udivdi3+0x50>
  80388b:	39 cf                	cmp    %ecx,%edi
  80388d:	77 65                	ja     8038f4 <__udivdi3+0x8c>
  80388f:	89 fd                	mov    %edi,%ebp
  803891:	85 ff                	test   %edi,%edi
  803893:	75 0b                	jne    8038a0 <__udivdi3+0x38>
  803895:	b8 01 00 00 00       	mov    $0x1,%eax
  80389a:	31 d2                	xor    %edx,%edx
  80389c:	f7 f7                	div    %edi
  80389e:	89 c5                	mov    %eax,%ebp
  8038a0:	31 d2                	xor    %edx,%edx
  8038a2:	89 c8                	mov    %ecx,%eax
  8038a4:	f7 f5                	div    %ebp
  8038a6:	89 c1                	mov    %eax,%ecx
  8038a8:	89 d8                	mov    %ebx,%eax
  8038aa:	f7 f5                	div    %ebp
  8038ac:	89 cf                	mov    %ecx,%edi
  8038ae:	89 fa                	mov    %edi,%edx
  8038b0:	83 c4 1c             	add    $0x1c,%esp
  8038b3:	5b                   	pop    %ebx
  8038b4:	5e                   	pop    %esi
  8038b5:	5f                   	pop    %edi
  8038b6:	5d                   	pop    %ebp
  8038b7:	c3                   	ret    
  8038b8:	39 ce                	cmp    %ecx,%esi
  8038ba:	77 28                	ja     8038e4 <__udivdi3+0x7c>
  8038bc:	0f bd fe             	bsr    %esi,%edi
  8038bf:	83 f7 1f             	xor    $0x1f,%edi
  8038c2:	75 40                	jne    803904 <__udivdi3+0x9c>
  8038c4:	39 ce                	cmp    %ecx,%esi
  8038c6:	72 0a                	jb     8038d2 <__udivdi3+0x6a>
  8038c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038cc:	0f 87 9e 00 00 00    	ja     803970 <__udivdi3+0x108>
  8038d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038d7:	89 fa                	mov    %edi,%edx
  8038d9:	83 c4 1c             	add    $0x1c,%esp
  8038dc:	5b                   	pop    %ebx
  8038dd:	5e                   	pop    %esi
  8038de:	5f                   	pop    %edi
  8038df:	5d                   	pop    %ebp
  8038e0:	c3                   	ret    
  8038e1:	8d 76 00             	lea    0x0(%esi),%esi
  8038e4:	31 ff                	xor    %edi,%edi
  8038e6:	31 c0                	xor    %eax,%eax
  8038e8:	89 fa                	mov    %edi,%edx
  8038ea:	83 c4 1c             	add    $0x1c,%esp
  8038ed:	5b                   	pop    %ebx
  8038ee:	5e                   	pop    %esi
  8038ef:	5f                   	pop    %edi
  8038f0:	5d                   	pop    %ebp
  8038f1:	c3                   	ret    
  8038f2:	66 90                	xchg   %ax,%ax
  8038f4:	89 d8                	mov    %ebx,%eax
  8038f6:	f7 f7                	div    %edi
  8038f8:	31 ff                	xor    %edi,%edi
  8038fa:	89 fa                	mov    %edi,%edx
  8038fc:	83 c4 1c             	add    $0x1c,%esp
  8038ff:	5b                   	pop    %ebx
  803900:	5e                   	pop    %esi
  803901:	5f                   	pop    %edi
  803902:	5d                   	pop    %ebp
  803903:	c3                   	ret    
  803904:	bd 20 00 00 00       	mov    $0x20,%ebp
  803909:	89 eb                	mov    %ebp,%ebx
  80390b:	29 fb                	sub    %edi,%ebx
  80390d:	89 f9                	mov    %edi,%ecx
  80390f:	d3 e6                	shl    %cl,%esi
  803911:	89 c5                	mov    %eax,%ebp
  803913:	88 d9                	mov    %bl,%cl
  803915:	d3 ed                	shr    %cl,%ebp
  803917:	89 e9                	mov    %ebp,%ecx
  803919:	09 f1                	or     %esi,%ecx
  80391b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80391f:	89 f9                	mov    %edi,%ecx
  803921:	d3 e0                	shl    %cl,%eax
  803923:	89 c5                	mov    %eax,%ebp
  803925:	89 d6                	mov    %edx,%esi
  803927:	88 d9                	mov    %bl,%cl
  803929:	d3 ee                	shr    %cl,%esi
  80392b:	89 f9                	mov    %edi,%ecx
  80392d:	d3 e2                	shl    %cl,%edx
  80392f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803933:	88 d9                	mov    %bl,%cl
  803935:	d3 e8                	shr    %cl,%eax
  803937:	09 c2                	or     %eax,%edx
  803939:	89 d0                	mov    %edx,%eax
  80393b:	89 f2                	mov    %esi,%edx
  80393d:	f7 74 24 0c          	divl   0xc(%esp)
  803941:	89 d6                	mov    %edx,%esi
  803943:	89 c3                	mov    %eax,%ebx
  803945:	f7 e5                	mul    %ebp
  803947:	39 d6                	cmp    %edx,%esi
  803949:	72 19                	jb     803964 <__udivdi3+0xfc>
  80394b:	74 0b                	je     803958 <__udivdi3+0xf0>
  80394d:	89 d8                	mov    %ebx,%eax
  80394f:	31 ff                	xor    %edi,%edi
  803951:	e9 58 ff ff ff       	jmp    8038ae <__udivdi3+0x46>
  803956:	66 90                	xchg   %ax,%ax
  803958:	8b 54 24 08          	mov    0x8(%esp),%edx
  80395c:	89 f9                	mov    %edi,%ecx
  80395e:	d3 e2                	shl    %cl,%edx
  803960:	39 c2                	cmp    %eax,%edx
  803962:	73 e9                	jae    80394d <__udivdi3+0xe5>
  803964:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803967:	31 ff                	xor    %edi,%edi
  803969:	e9 40 ff ff ff       	jmp    8038ae <__udivdi3+0x46>
  80396e:	66 90                	xchg   %ax,%ax
  803970:	31 c0                	xor    %eax,%eax
  803972:	e9 37 ff ff ff       	jmp    8038ae <__udivdi3+0x46>
  803977:	90                   	nop

00803978 <__umoddi3>:
  803978:	55                   	push   %ebp
  803979:	57                   	push   %edi
  80397a:	56                   	push   %esi
  80397b:	53                   	push   %ebx
  80397c:	83 ec 1c             	sub    $0x1c,%esp
  80397f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803983:	8b 74 24 34          	mov    0x34(%esp),%esi
  803987:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80398b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80398f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803993:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803997:	89 f3                	mov    %esi,%ebx
  803999:	89 fa                	mov    %edi,%edx
  80399b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80399f:	89 34 24             	mov    %esi,(%esp)
  8039a2:	85 c0                	test   %eax,%eax
  8039a4:	75 1a                	jne    8039c0 <__umoddi3+0x48>
  8039a6:	39 f7                	cmp    %esi,%edi
  8039a8:	0f 86 a2 00 00 00    	jbe    803a50 <__umoddi3+0xd8>
  8039ae:	89 c8                	mov    %ecx,%eax
  8039b0:	89 f2                	mov    %esi,%edx
  8039b2:	f7 f7                	div    %edi
  8039b4:	89 d0                	mov    %edx,%eax
  8039b6:	31 d2                	xor    %edx,%edx
  8039b8:	83 c4 1c             	add    $0x1c,%esp
  8039bb:	5b                   	pop    %ebx
  8039bc:	5e                   	pop    %esi
  8039bd:	5f                   	pop    %edi
  8039be:	5d                   	pop    %ebp
  8039bf:	c3                   	ret    
  8039c0:	39 f0                	cmp    %esi,%eax
  8039c2:	0f 87 ac 00 00 00    	ja     803a74 <__umoddi3+0xfc>
  8039c8:	0f bd e8             	bsr    %eax,%ebp
  8039cb:	83 f5 1f             	xor    $0x1f,%ebp
  8039ce:	0f 84 ac 00 00 00    	je     803a80 <__umoddi3+0x108>
  8039d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8039d9:	29 ef                	sub    %ebp,%edi
  8039db:	89 fe                	mov    %edi,%esi
  8039dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039e1:	89 e9                	mov    %ebp,%ecx
  8039e3:	d3 e0                	shl    %cl,%eax
  8039e5:	89 d7                	mov    %edx,%edi
  8039e7:	89 f1                	mov    %esi,%ecx
  8039e9:	d3 ef                	shr    %cl,%edi
  8039eb:	09 c7                	or     %eax,%edi
  8039ed:	89 e9                	mov    %ebp,%ecx
  8039ef:	d3 e2                	shl    %cl,%edx
  8039f1:	89 14 24             	mov    %edx,(%esp)
  8039f4:	89 d8                	mov    %ebx,%eax
  8039f6:	d3 e0                	shl    %cl,%eax
  8039f8:	89 c2                	mov    %eax,%edx
  8039fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039fe:	d3 e0                	shl    %cl,%eax
  803a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a04:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a08:	89 f1                	mov    %esi,%ecx
  803a0a:	d3 e8                	shr    %cl,%eax
  803a0c:	09 d0                	or     %edx,%eax
  803a0e:	d3 eb                	shr    %cl,%ebx
  803a10:	89 da                	mov    %ebx,%edx
  803a12:	f7 f7                	div    %edi
  803a14:	89 d3                	mov    %edx,%ebx
  803a16:	f7 24 24             	mull   (%esp)
  803a19:	89 c6                	mov    %eax,%esi
  803a1b:	89 d1                	mov    %edx,%ecx
  803a1d:	39 d3                	cmp    %edx,%ebx
  803a1f:	0f 82 87 00 00 00    	jb     803aac <__umoddi3+0x134>
  803a25:	0f 84 91 00 00 00    	je     803abc <__umoddi3+0x144>
  803a2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a2f:	29 f2                	sub    %esi,%edx
  803a31:	19 cb                	sbb    %ecx,%ebx
  803a33:	89 d8                	mov    %ebx,%eax
  803a35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a39:	d3 e0                	shl    %cl,%eax
  803a3b:	89 e9                	mov    %ebp,%ecx
  803a3d:	d3 ea                	shr    %cl,%edx
  803a3f:	09 d0                	or     %edx,%eax
  803a41:	89 e9                	mov    %ebp,%ecx
  803a43:	d3 eb                	shr    %cl,%ebx
  803a45:	89 da                	mov    %ebx,%edx
  803a47:	83 c4 1c             	add    $0x1c,%esp
  803a4a:	5b                   	pop    %ebx
  803a4b:	5e                   	pop    %esi
  803a4c:	5f                   	pop    %edi
  803a4d:	5d                   	pop    %ebp
  803a4e:	c3                   	ret    
  803a4f:	90                   	nop
  803a50:	89 fd                	mov    %edi,%ebp
  803a52:	85 ff                	test   %edi,%edi
  803a54:	75 0b                	jne    803a61 <__umoddi3+0xe9>
  803a56:	b8 01 00 00 00       	mov    $0x1,%eax
  803a5b:	31 d2                	xor    %edx,%edx
  803a5d:	f7 f7                	div    %edi
  803a5f:	89 c5                	mov    %eax,%ebp
  803a61:	89 f0                	mov    %esi,%eax
  803a63:	31 d2                	xor    %edx,%edx
  803a65:	f7 f5                	div    %ebp
  803a67:	89 c8                	mov    %ecx,%eax
  803a69:	f7 f5                	div    %ebp
  803a6b:	89 d0                	mov    %edx,%eax
  803a6d:	e9 44 ff ff ff       	jmp    8039b6 <__umoddi3+0x3e>
  803a72:	66 90                	xchg   %ax,%ax
  803a74:	89 c8                	mov    %ecx,%eax
  803a76:	89 f2                	mov    %esi,%edx
  803a78:	83 c4 1c             	add    $0x1c,%esp
  803a7b:	5b                   	pop    %ebx
  803a7c:	5e                   	pop    %esi
  803a7d:	5f                   	pop    %edi
  803a7e:	5d                   	pop    %ebp
  803a7f:	c3                   	ret    
  803a80:	3b 04 24             	cmp    (%esp),%eax
  803a83:	72 06                	jb     803a8b <__umoddi3+0x113>
  803a85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a89:	77 0f                	ja     803a9a <__umoddi3+0x122>
  803a8b:	89 f2                	mov    %esi,%edx
  803a8d:	29 f9                	sub    %edi,%ecx
  803a8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a93:	89 14 24             	mov    %edx,(%esp)
  803a96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a9e:	8b 14 24             	mov    (%esp),%edx
  803aa1:	83 c4 1c             	add    $0x1c,%esp
  803aa4:	5b                   	pop    %ebx
  803aa5:	5e                   	pop    %esi
  803aa6:	5f                   	pop    %edi
  803aa7:	5d                   	pop    %ebp
  803aa8:	c3                   	ret    
  803aa9:	8d 76 00             	lea    0x0(%esi),%esi
  803aac:	2b 04 24             	sub    (%esp),%eax
  803aaf:	19 fa                	sbb    %edi,%edx
  803ab1:	89 d1                	mov    %edx,%ecx
  803ab3:	89 c6                	mov    %eax,%esi
  803ab5:	e9 71 ff ff ff       	jmp    803a2b <__umoddi3+0xb3>
  803aba:	66 90                	xchg   %ax,%ax
  803abc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ac0:	72 ea                	jb     803aac <__umoddi3+0x134>
  803ac2:	89 d9                	mov    %ebx,%ecx
  803ac4:	e9 62 ff ff ff       	jmp    803a2b <__umoddi3+0xb3>
