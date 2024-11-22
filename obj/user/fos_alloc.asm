
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
  80005c:	68 80 3a 80 00       	push   $0x803a80
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
  8000b9:	68 93 3a 80 00       	push   $0x803a93
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
  80010f:	68 93 3a 80 00       	push   $0x803a93
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
  80013e:	e8 fb 16 00 00       	call   80183e <sys_getenvindex>
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
  8001ac:	e8 11 14 00 00       	call   8015c2 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 b8 3a 80 00       	push   $0x803ab8
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
  8001dc:	68 e0 3a 80 00       	push   $0x803ae0
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
  80020d:	68 08 3b 80 00       	push   $0x803b08
  800212:	e8 34 01 00 00       	call   80034b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 60 3b 80 00       	push   $0x803b60
  80022e:	e8 18 01 00 00       	call   80034b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 b8 3a 80 00       	push   $0x803ab8
  80023e:	e8 08 01 00 00       	call   80034b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800246:	e8 91 13 00 00       	call   8015dc <sys_unlock_cons>
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
  80025e:	e8 a7 15 00 00       	call   80180a <sys_destroy_env>
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
  80026f:	e8 fc 15 00 00       	call   801870 <sys_exit_env>
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
  8002bd:	e8 be 12 00 00       	call   801580 <sys_cputs>
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
  800334:	e8 47 12 00 00       	call   801580 <sys_cputs>
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
  80037e:	e8 3f 12 00 00       	call   8015c2 <sys_lock_cons>
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
  80039e:	e8 39 12 00 00       	call   8015dc <sys_unlock_cons>
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
  8003e8:	e8 13 34 00 00       	call   803800 <__udivdi3>
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
  800438:	e8 d3 34 00 00       	call   803910 <__umoddi3>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	05 94 3d 80 00       	add    $0x803d94,%eax
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
  800593:	8b 04 85 b8 3d 80 00 	mov    0x803db8(,%eax,4),%eax
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
  800674:	8b 34 9d 00 3c 80 00 	mov    0x803c00(,%ebx,4),%esi
  80067b:	85 f6                	test   %esi,%esi
  80067d:	75 19                	jne    800698 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067f:	53                   	push   %ebx
  800680:	68 a5 3d 80 00       	push   $0x803da5
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
  800699:	68 ae 3d 80 00       	push   $0x803dae
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
  8006c6:	be b1 3d 80 00       	mov    $0x803db1,%esi
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
  8010d1:	68 28 3f 80 00       	push   $0x803f28
  8010d6:	68 3f 01 00 00       	push   $0x13f
  8010db:	68 4a 3f 80 00       	push   $0x803f4a
  8010e0:	e8 32 25 00 00       	call   803617 <_panic>

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
  8010f1:	e8 35 0a 00 00       	call   801b2b <sys_sbrk>
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
  80116c:	e8 3e 08 00 00       	call   8019af <sys_isUHeapPlacementStrategyFIRSTFIT>
  801171:	85 c0                	test   %eax,%eax
  801173:	74 16                	je     80118b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	ff 75 08             	pushl  0x8(%ebp)
  80117b:	e8 7e 0d 00 00       	call   801efe <alloc_block_FF>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801186:	e9 8a 01 00 00       	jmp    801315 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80118b:	e8 50 08 00 00       	call   8019e0 <sys_isUHeapPlacementStrategyBESTFIT>
  801190:	85 c0                	test   %eax,%eax
  801192:	0f 84 7d 01 00 00    	je     801315 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801198:	83 ec 0c             	sub    $0xc,%esp
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	e8 17 12 00 00       	call   8023ba <alloc_block_BF>
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
  801304:	e8 59 08 00 00       	call   801b62 <sys_allocate_user_mem>
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
  80134c:	e8 2d 08 00 00       	call   801b7e <get_block_size>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 60 1a 00 00       	call   802dc2 <free_block>
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
  8013f4:	e8 4d 07 00 00       	call   801b46 <sys_free_user_mem>
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
  801402:	68 58 3f 80 00       	push   $0x803f58
  801407:	68 84 00 00 00       	push   $0x84
  80140c:	68 82 3f 80 00       	push   $0x803f82
  801411:	e8 01 22 00 00       	call   803617 <_panic>
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
  801474:	e8 d4 02 00 00       	call   80174d <sys_createSharedObject>
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
  801495:	68 8e 3f 80 00       	push   $0x803f8e
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
  8014aa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014ad:	83 ec 04             	sub    $0x4,%esp
  8014b0:	68 94 3f 80 00       	push   $0x803f94
  8014b5:	68 a4 00 00 00       	push   $0xa4
  8014ba:	68 82 3f 80 00       	push   $0x803f82
  8014bf:	e8 53 21 00 00       	call   803617 <_panic>

008014c4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	68 b8 3f 80 00       	push   $0x803fb8
  8014d2:	68 bc 00 00 00       	push   $0xbc
  8014d7:	68 82 3f 80 00       	push   $0x803f82
  8014dc:	e8 36 21 00 00       	call   803617 <_panic>

008014e1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	68 dc 3f 80 00       	push   $0x803fdc
  8014ef:	68 d3 00 00 00       	push   $0xd3
  8014f4:	68 82 3f 80 00       	push   $0x803f82
  8014f9:	e8 19 21 00 00       	call   803617 <_panic>

008014fe <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801504:	83 ec 04             	sub    $0x4,%esp
  801507:	68 02 40 80 00       	push   $0x804002
  80150c:	68 df 00 00 00       	push   $0xdf
  801511:	68 82 3f 80 00       	push   $0x803f82
  801516:	e8 fc 20 00 00       	call   803617 <_panic>

0080151b <shrink>:

}
void shrink(uint32 newSize)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	68 02 40 80 00       	push   $0x804002
  801529:	68 e4 00 00 00       	push   $0xe4
  80152e:	68 82 3f 80 00       	push   $0x803f82
  801533:	e8 df 20 00 00       	call   803617 <_panic>

00801538 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	68 02 40 80 00       	push   $0x804002
  801546:	68 e9 00 00 00       	push   $0xe9
  80154b:	68 82 3f 80 00       	push   $0x803f82
  801550:	e8 c2 20 00 00       	call   803617 <_panic>

00801555 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	57                   	push   %edi
  801559:	56                   	push   %esi
  80155a:	53                   	push   %ebx
  80155b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	8b 55 0c             	mov    0xc(%ebp),%edx
  801564:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801567:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80156a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80156d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801570:	cd 30                	int    $0x30
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5f                   	pop    %edi
  80157e:	5d                   	pop    %ebp
  80157f:	c3                   	ret    

00801580 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	8b 45 10             	mov    0x10(%ebp),%eax
  801589:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80158c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	52                   	push   %edx
  801598:	ff 75 0c             	pushl  0xc(%ebp)
  80159b:	50                   	push   %eax
  80159c:	6a 00                	push   $0x0
  80159e:	e8 b2 ff ff ff       	call   801555 <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
}
  8015a6:	90                   	nop
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 02                	push   $0x2
  8015b8:	e8 98 ff ff ff       	call   801555 <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 03                	push   $0x3
  8015d1:	e8 7f ff ff ff       	call   801555 <syscall>
  8015d6:	83 c4 18             	add    $0x18,%esp
}
  8015d9:	90                   	nop
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 04                	push   $0x4
  8015eb:	e8 65 ff ff ff       	call   801555 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	90                   	nop
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	52                   	push   %edx
  801606:	50                   	push   %eax
  801607:	6a 08                	push   $0x8
  801609:	e8 47 ff ff ff       	call   801555 <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	56                   	push   %esi
  801617:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801618:	8b 75 18             	mov    0x18(%ebp),%esi
  80161b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80161e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	56                   	push   %esi
  801628:	53                   	push   %ebx
  801629:	51                   	push   %ecx
  80162a:	52                   	push   %edx
  80162b:	50                   	push   %eax
  80162c:	6a 09                	push   $0x9
  80162e:	e8 22 ff ff ff       	call   801555 <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
}
  801636:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801639:	5b                   	pop    %ebx
  80163a:	5e                   	pop    %esi
  80163b:	5d                   	pop    %ebp
  80163c:	c3                   	ret    

0080163d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801640:	8b 55 0c             	mov    0xc(%ebp),%edx
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	52                   	push   %edx
  80164d:	50                   	push   %eax
  80164e:	6a 0a                	push   $0xa
  801650:	e8 00 ff ff ff       	call   801555 <syscall>
  801655:	83 c4 18             	add    $0x18,%esp
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	ff 75 08             	pushl  0x8(%ebp)
  801669:	6a 0b                	push   $0xb
  80166b:	e8 e5 fe ff ff       	call   801555 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
}
  801673:	c9                   	leave  
  801674:	c3                   	ret    

00801675 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 0c                	push   $0xc
  801684:	e8 cc fe ff ff       	call   801555 <syscall>
  801689:	83 c4 18             	add    $0x18,%esp
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 0d                	push   $0xd
  80169d:	e8 b3 fe ff ff       	call   801555 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 0e                	push   $0xe
  8016b6:	e8 9a fe ff ff       	call   801555 <syscall>
  8016bb:	83 c4 18             	add    $0x18,%esp
}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 0f                	push   $0xf
  8016cf:	e8 81 fe ff ff       	call   801555 <syscall>
  8016d4:	83 c4 18             	add    $0x18,%esp
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	ff 75 08             	pushl  0x8(%ebp)
  8016e7:	6a 10                	push   $0x10
  8016e9:	e8 67 fe ff ff       	call   801555 <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 11                	push   $0x11
  801702:	e8 4e fe ff ff       	call   801555 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	90                   	nop
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_cputc>:

void
sys_cputc(const char c)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801719:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	50                   	push   %eax
  801726:	6a 01                	push   $0x1
  801728:	e8 28 fe ff ff       	call   801555 <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	90                   	nop
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 14                	push   $0x14
  801742:	e8 0e fe ff ff       	call   801555 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	90                   	nop
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	8b 45 10             	mov    0x10(%ebp),%eax
  801756:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801759:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80175c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	6a 00                	push   $0x0
  801765:	51                   	push   %ecx
  801766:	52                   	push   %edx
  801767:	ff 75 0c             	pushl  0xc(%ebp)
  80176a:	50                   	push   %eax
  80176b:	6a 15                	push   $0x15
  80176d:	e8 e3 fd ff ff       	call   801555 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80177a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	52                   	push   %edx
  801787:	50                   	push   %eax
  801788:	6a 16                	push   $0x16
  80178a:	e8 c6 fd ff ff       	call   801555 <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801797:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80179a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	51                   	push   %ecx
  8017a5:	52                   	push   %edx
  8017a6:	50                   	push   %eax
  8017a7:	6a 17                	push   $0x17
  8017a9:	e8 a7 fd ff ff       	call   801555 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	52                   	push   %edx
  8017c3:	50                   	push   %eax
  8017c4:	6a 18                	push   $0x18
  8017c6:	e8 8a fd ff ff       	call   801555 <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	6a 00                	push   $0x0
  8017d8:	ff 75 14             	pushl  0x14(%ebp)
  8017db:	ff 75 10             	pushl  0x10(%ebp)
  8017de:	ff 75 0c             	pushl  0xc(%ebp)
  8017e1:	50                   	push   %eax
  8017e2:	6a 19                	push   $0x19
  8017e4:	e8 6c fd ff ff       	call   801555 <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_run_env>:

void sys_run_env(int32 envId)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	50                   	push   %eax
  8017fd:	6a 1a                	push   $0x1a
  8017ff:	e8 51 fd ff ff       	call   801555 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	50                   	push   %eax
  801819:	6a 1b                	push   $0x1b
  80181b:	e8 35 fd ff ff       	call   801555 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 05                	push   $0x5
  801834:	e8 1c fd ff ff       	call   801555 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 06                	push   $0x6
  80184d:	e8 03 fd ff ff       	call   801555 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 07                	push   $0x7
  801866:	e8 ea fc ff ff       	call   801555 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_exit_env>:


void sys_exit_env(void)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 1c                	push   $0x1c
  80187f:	e8 d1 fc ff ff       	call   801555 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	90                   	nop
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801890:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801893:	8d 50 04             	lea    0x4(%eax),%edx
  801896:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	52                   	push   %edx
  8018a0:	50                   	push   %eax
  8018a1:	6a 1d                	push   $0x1d
  8018a3:	e8 ad fc ff ff       	call   801555 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
	return result;
  8018ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018b4:	89 01                	mov    %eax,(%ecx)
  8018b6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	c9                   	leave  
  8018bd:	c2 04 00             	ret    $0x4

008018c0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	ff 75 10             	pushl  0x10(%ebp)
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	ff 75 08             	pushl  0x8(%ebp)
  8018d0:	6a 13                	push   $0x13
  8018d2:	e8 7e fc ff ff       	call   801555 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018da:	90                   	nop
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_rcr2>:
uint32 sys_rcr2()
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 1e                	push   $0x1e
  8018ec:	e8 64 fc ff ff       	call   801555 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
  8018f9:	83 ec 04             	sub    $0x4,%esp
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801902:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	50                   	push   %eax
  80190f:	6a 1f                	push   $0x1f
  801911:	e8 3f fc ff ff       	call   801555 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
	return ;
  801919:	90                   	nop
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <rsttst>:
void rsttst()
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 21                	push   $0x21
  80192b:	e8 25 fc ff ff       	call   801555 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
	return ;
  801933:	90                   	nop
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	8b 45 14             	mov    0x14(%ebp),%eax
  80193f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801942:	8b 55 18             	mov    0x18(%ebp),%edx
  801945:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801949:	52                   	push   %edx
  80194a:	50                   	push   %eax
  80194b:	ff 75 10             	pushl  0x10(%ebp)
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	ff 75 08             	pushl  0x8(%ebp)
  801954:	6a 20                	push   $0x20
  801956:	e8 fa fb ff ff       	call   801555 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
	return ;
  80195e:	90                   	nop
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <chktst>:
void chktst(uint32 n)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	ff 75 08             	pushl  0x8(%ebp)
  80196f:	6a 22                	push   $0x22
  801971:	e8 df fb ff ff       	call   801555 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
	return ;
  801979:	90                   	nop
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <inctst>:

void inctst()
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 23                	push   $0x23
  80198b:	e8 c5 fb ff ff       	call   801555 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
	return ;
  801993:	90                   	nop
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <gettst>:
uint32 gettst()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 24                	push   $0x24
  8019a5:	e8 ab fb ff ff       	call   801555 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 25                	push   $0x25
  8019c1:	e8 8f fb ff ff       	call   801555 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
  8019c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019cc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019d0:	75 07                	jne    8019d9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d7:	eb 05                	jmp    8019de <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 25                	push   $0x25
  8019f2:	e8 5e fb ff ff       	call   801555 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
  8019fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019fd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a01:	75 07                	jne    801a0a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a03:	b8 01 00 00 00       	mov    $0x1,%eax
  801a08:	eb 05                	jmp    801a0f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 25                	push   $0x25
  801a23:	e8 2d fb ff ff       	call   801555 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
  801a2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a2e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a32:	75 07                	jne    801a3b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a34:	b8 01 00 00 00       	mov    $0x1,%eax
  801a39:	eb 05                	jmp    801a40 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 25                	push   $0x25
  801a54:	e8 fc fa ff ff       	call   801555 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
  801a5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a5f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a63:	75 07                	jne    801a6c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a65:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6a:	eb 05                	jmp    801a71 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	ff 75 08             	pushl  0x8(%ebp)
  801a81:	6a 26                	push   $0x26
  801a83:	e8 cd fa ff ff       	call   801555 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8b:	90                   	nop
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a92:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a95:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	53                   	push   %ebx
  801aa1:	51                   	push   %ecx
  801aa2:	52                   	push   %edx
  801aa3:	50                   	push   %eax
  801aa4:	6a 27                	push   $0x27
  801aa6:	e8 aa fa ff ff       	call   801555 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	52                   	push   %edx
  801ac3:	50                   	push   %eax
  801ac4:	6a 28                	push   $0x28
  801ac6:	e8 8a fa ff ff       	call   801555 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801ad3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	51                   	push   %ecx
  801adf:	ff 75 10             	pushl  0x10(%ebp)
  801ae2:	52                   	push   %edx
  801ae3:	50                   	push   %eax
  801ae4:	6a 29                	push   $0x29
  801ae6:	e8 6a fa ff ff       	call   801555 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	ff 75 10             	pushl  0x10(%ebp)
  801afa:	ff 75 0c             	pushl  0xc(%ebp)
  801afd:	ff 75 08             	pushl  0x8(%ebp)
  801b00:	6a 12                	push   $0x12
  801b02:	e8 4e fa ff ff       	call   801555 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0a:	90                   	nop
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 2a                	push   $0x2a
  801b20:	e8 30 fa ff ff       	call   801555 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
	return;
  801b28:	90                   	nop
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	50                   	push   %eax
  801b3a:	6a 2b                	push   $0x2b
  801b3c:	e8 14 fa ff ff       	call   801555 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	ff 75 0c             	pushl  0xc(%ebp)
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	6a 2c                	push   $0x2c
  801b57:	e8 f9 f9 ff ff       	call   801555 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
	return;
  801b5f:	90                   	nop
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	ff 75 0c             	pushl  0xc(%ebp)
  801b6e:	ff 75 08             	pushl  0x8(%ebp)
  801b71:	6a 2d                	push   $0x2d
  801b73:	e8 dd f9 ff ff       	call   801555 <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
	return;
  801b7b:	90                   	nop
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	83 e8 04             	sub    $0x4,%eax
  801b8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b90:	8b 00                	mov    (%eax),%eax
  801b92:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	83 e8 04             	sub    $0x4,%eax
  801ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801ba6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba9:	8b 00                	mov    (%eax),%eax
  801bab:	83 e0 01             	and    $0x1,%eax
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	0f 94 c0             	sete   %al
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801bbb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	83 f8 02             	cmp    $0x2,%eax
  801bc8:	74 2b                	je     801bf5 <alloc_block+0x40>
  801bca:	83 f8 02             	cmp    $0x2,%eax
  801bcd:	7f 07                	jg     801bd6 <alloc_block+0x21>
  801bcf:	83 f8 01             	cmp    $0x1,%eax
  801bd2:	74 0e                	je     801be2 <alloc_block+0x2d>
  801bd4:	eb 58                	jmp    801c2e <alloc_block+0x79>
  801bd6:	83 f8 03             	cmp    $0x3,%eax
  801bd9:	74 2d                	je     801c08 <alloc_block+0x53>
  801bdb:	83 f8 04             	cmp    $0x4,%eax
  801bde:	74 3b                	je     801c1b <alloc_block+0x66>
  801be0:	eb 4c                	jmp    801c2e <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	ff 75 08             	pushl  0x8(%ebp)
  801be8:	e8 11 03 00 00       	call   801efe <alloc_block_FF>
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801bf3:	eb 4a                	jmp    801c3f <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801bf5:	83 ec 0c             	sub    $0xc,%esp
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	e8 fa 19 00 00       	call   8035fa <alloc_block_NF>
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c06:	eb 37                	jmp    801c3f <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801c08:	83 ec 0c             	sub    $0xc,%esp
  801c0b:	ff 75 08             	pushl  0x8(%ebp)
  801c0e:	e8 a7 07 00 00       	call   8023ba <alloc_block_BF>
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c19:	eb 24                	jmp    801c3f <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801c1b:	83 ec 0c             	sub    $0xc,%esp
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	e8 b7 19 00 00       	call   8035dd <alloc_block_WF>
  801c26:	83 c4 10             	add    $0x10,%esp
  801c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c2c:	eb 11                	jmp    801c3f <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801c2e:	83 ec 0c             	sub    $0xc,%esp
  801c31:	68 14 40 80 00       	push   $0x804014
  801c36:	e8 10 e7 ff ff       	call   80034b <cprintf>
  801c3b:	83 c4 10             	add    $0x10,%esp
		break;
  801c3e:	90                   	nop
	}
	return va;
  801c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	53                   	push   %ebx
  801c48:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801c4b:	83 ec 0c             	sub    $0xc,%esp
  801c4e:	68 34 40 80 00       	push   $0x804034
  801c53:	e8 f3 e6 ff ff       	call   80034b <cprintf>
  801c58:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801c5b:	83 ec 0c             	sub    $0xc,%esp
  801c5e:	68 5f 40 80 00       	push   $0x80405f
  801c63:	e8 e3 e6 ff ff       	call   80034b <cprintf>
  801c68:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c71:	eb 37                	jmp    801caa <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801c73:	83 ec 0c             	sub    $0xc,%esp
  801c76:	ff 75 f4             	pushl  -0xc(%ebp)
  801c79:	e8 19 ff ff ff       	call   801b97 <is_free_block>
  801c7e:	83 c4 10             	add    $0x10,%esp
  801c81:	0f be d8             	movsbl %al,%ebx
  801c84:	83 ec 0c             	sub    $0xc,%esp
  801c87:	ff 75 f4             	pushl  -0xc(%ebp)
  801c8a:	e8 ef fe ff ff       	call   801b7e <get_block_size>
  801c8f:	83 c4 10             	add    $0x10,%esp
  801c92:	83 ec 04             	sub    $0x4,%esp
  801c95:	53                   	push   %ebx
  801c96:	50                   	push   %eax
  801c97:	68 77 40 80 00       	push   $0x804077
  801c9c:	e8 aa e6 ff ff       	call   80034b <cprintf>
  801ca1:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801ca4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801caa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cae:	74 07                	je     801cb7 <print_blocks_list+0x73>
  801cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb3:	8b 00                	mov    (%eax),%eax
  801cb5:	eb 05                	jmp    801cbc <print_blocks_list+0x78>
  801cb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbc:	89 45 10             	mov    %eax,0x10(%ebp)
  801cbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc2:	85 c0                	test   %eax,%eax
  801cc4:	75 ad                	jne    801c73 <print_blocks_list+0x2f>
  801cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cca:	75 a7                	jne    801c73 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801ccc:	83 ec 0c             	sub    $0xc,%esp
  801ccf:	68 34 40 80 00       	push   $0x804034
  801cd4:	e8 72 e6 ff ff       	call   80034b <cprintf>
  801cd9:	83 c4 10             	add    $0x10,%esp

}
  801cdc:	90                   	nop
  801cdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ceb:	83 e0 01             	and    $0x1,%eax
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	74 03                	je     801cf5 <initialize_dynamic_allocator+0x13>
  801cf2:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801cf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cf9:	0f 84 c7 01 00 00    	je     801ec6 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801cff:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801d06:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801d09:	8b 55 08             	mov    0x8(%ebp),%edx
  801d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0f:	01 d0                	add    %edx,%eax
  801d11:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801d16:	0f 87 ad 01 00 00    	ja     801ec9 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	0f 89 a5 01 00 00    	jns    801ecc <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801d27:	8b 55 08             	mov    0x8(%ebp),%edx
  801d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2d:	01 d0                	add    %edx,%eax
  801d2f:	83 e8 04             	sub    $0x4,%eax
  801d32:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801d3e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d46:	e9 87 00 00 00       	jmp    801dd2 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801d4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4f:	75 14                	jne    801d65 <initialize_dynamic_allocator+0x83>
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	68 8f 40 80 00       	push   $0x80408f
  801d59:	6a 79                	push   $0x79
  801d5b:	68 ad 40 80 00       	push   $0x8040ad
  801d60:	e8 b2 18 00 00       	call   803617 <_panic>
  801d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d68:	8b 00                	mov    (%eax),%eax
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	74 10                	je     801d7e <initialize_dynamic_allocator+0x9c>
  801d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d71:	8b 00                	mov    (%eax),%eax
  801d73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d76:	8b 52 04             	mov    0x4(%edx),%edx
  801d79:	89 50 04             	mov    %edx,0x4(%eax)
  801d7c:	eb 0b                	jmp    801d89 <initialize_dynamic_allocator+0xa7>
  801d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d81:	8b 40 04             	mov    0x4(%eax),%eax
  801d84:	a3 30 50 80 00       	mov    %eax,0x805030
  801d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8c:	8b 40 04             	mov    0x4(%eax),%eax
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	74 0f                	je     801da2 <initialize_dynamic_allocator+0xc0>
  801d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d96:	8b 40 04             	mov    0x4(%eax),%eax
  801d99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d9c:	8b 12                	mov    (%edx),%edx
  801d9e:	89 10                	mov    %edx,(%eax)
  801da0:	eb 0a                	jmp    801dac <initialize_dynamic_allocator+0xca>
  801da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da5:	8b 00                	mov    (%eax),%eax
  801da7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dbf:	a1 38 50 80 00       	mov    0x805038,%eax
  801dc4:	48                   	dec    %eax
  801dc5:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801dca:	a1 34 50 80 00       	mov    0x805034,%eax
  801dcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd6:	74 07                	je     801ddf <initialize_dynamic_allocator+0xfd>
  801dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddb:	8b 00                	mov    (%eax),%eax
  801ddd:	eb 05                	jmp    801de4 <initialize_dynamic_allocator+0x102>
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
  801de4:	a3 34 50 80 00       	mov    %eax,0x805034
  801de9:	a1 34 50 80 00       	mov    0x805034,%eax
  801dee:	85 c0                	test   %eax,%eax
  801df0:	0f 85 55 ff ff ff    	jne    801d4b <initialize_dynamic_allocator+0x69>
  801df6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dfa:	0f 85 4b ff ff ff    	jne    801d4b <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e09:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801e0f:	a1 44 50 80 00       	mov    0x805044,%eax
  801e14:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801e19:	a1 40 50 80 00       	mov    0x805040,%eax
  801e1e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	83 c0 08             	add    $0x8,%eax
  801e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	83 c0 04             	add    $0x4,%eax
  801e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e36:	83 ea 08             	sub    $0x8,%edx
  801e39:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	01 d0                	add    %edx,%eax
  801e43:	83 e8 08             	sub    $0x8,%eax
  801e46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e49:	83 ea 08             	sub    $0x8,%edx
  801e4c:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801e4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801e61:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e65:	75 17                	jne    801e7e <initialize_dynamic_allocator+0x19c>
  801e67:	83 ec 04             	sub    $0x4,%esp
  801e6a:	68 c8 40 80 00       	push   $0x8040c8
  801e6f:	68 90 00 00 00       	push   $0x90
  801e74:	68 ad 40 80 00       	push   $0x8040ad
  801e79:	e8 99 17 00 00       	call   803617 <_panic>
  801e7e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e87:	89 10                	mov    %edx,(%eax)
  801e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e8c:	8b 00                	mov    (%eax),%eax
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	74 0d                	je     801e9f <initialize_dynamic_allocator+0x1bd>
  801e92:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e97:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e9a:	89 50 04             	mov    %edx,0x4(%eax)
  801e9d:	eb 08                	jmp    801ea7 <initialize_dynamic_allocator+0x1c5>
  801e9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea2:	a3 30 50 80 00       	mov    %eax,0x805030
  801ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eaa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eb9:	a1 38 50 80 00       	mov    0x805038,%eax
  801ebe:	40                   	inc    %eax
  801ebf:	a3 38 50 80 00       	mov    %eax,0x805038
  801ec4:	eb 07                	jmp    801ecd <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801ec6:	90                   	nop
  801ec7:	eb 04                	jmp    801ecd <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801ec9:	90                   	nop
  801eca:	eb 01                	jmp    801ecd <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801ecc:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed5:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8d 50 fc             	lea    -0x4(%eax),%edx
  801ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee1:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	83 e8 04             	sub    $0x4,%eax
  801ee9:	8b 00                	mov    (%eax),%eax
  801eeb:	83 e0 fe             	and    $0xfffffffe,%eax
  801eee:	8d 50 f8             	lea    -0x8(%eax),%edx
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	01 c2                	add    %eax,%edx
  801ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef9:	89 02                	mov    %eax,(%edx)
}
  801efb:	90                   	nop
  801efc:	5d                   	pop    %ebp
  801efd:	c3                   	ret    

00801efe <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	83 e0 01             	and    $0x1,%eax
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	74 03                	je     801f11 <alloc_block_FF+0x13>
  801f0e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801f11:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801f15:	77 07                	ja     801f1e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801f17:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801f1e:	a1 24 50 80 00       	mov    0x805024,%eax
  801f23:	85 c0                	test   %eax,%eax
  801f25:	75 73                	jne    801f9a <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	83 c0 10             	add    $0x10,%eax
  801f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  801f30:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3d:	01 d0                	add    %edx,%eax
  801f3f:	48                   	dec    %eax
  801f40:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f46:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4b:	f7 75 ec             	divl   -0x14(%ebp)
  801f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f51:	29 d0                	sub    %edx,%eax
  801f53:	c1 e8 0c             	shr    $0xc,%eax
  801f56:	83 ec 0c             	sub    $0xc,%esp
  801f59:	50                   	push   %eax
  801f5a:	e8 86 f1 ff ff       	call   8010e5 <sbrk>
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	6a 00                	push   $0x0
  801f6a:	e8 76 f1 ff ff       	call   8010e5 <sbrk>
  801f6f:	83 c4 10             	add    $0x10,%esp
  801f72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  801f75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f78:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801f7b:	83 ec 08             	sub    $0x8,%esp
  801f7e:	50                   	push   %eax
  801f7f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f82:	e8 5b fd ff ff       	call   801ce2 <initialize_dynamic_allocator>
  801f87:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  801f8a:	83 ec 0c             	sub    $0xc,%esp
  801f8d:	68 eb 40 80 00       	push   $0x8040eb
  801f92:	e8 b4 e3 ff ff       	call   80034b <cprintf>
  801f97:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  801f9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f9e:	75 0a                	jne    801faa <alloc_block_FF+0xac>
	        return NULL;
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	e9 0e 04 00 00       	jmp    8023b8 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  801faa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  801fb1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb9:	e9 f3 02 00 00       	jmp    8022b1 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	ff 75 bc             	pushl  -0x44(%ebp)
  801fca:	e8 af fb ff ff       	call   801b7e <get_block_size>
  801fcf:	83 c4 10             	add    $0x10,%esp
  801fd2:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	83 c0 08             	add    $0x8,%eax
  801fdb:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801fde:	0f 87 c5 02 00 00    	ja     8022a9 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	83 c0 18             	add    $0x18,%eax
  801fea:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801fed:	0f 87 19 02 00 00    	ja     80220c <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  801ff3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801ff6:	2b 45 08             	sub    0x8(%ebp),%eax
  801ff9:	83 e8 08             	sub    $0x8,%eax
  801ffc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	8d 50 08             	lea    0x8(%eax),%edx
  802005:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802008:	01 d0                	add    %edx,%eax
  80200a:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	83 c0 08             	add    $0x8,%eax
  802013:	83 ec 04             	sub    $0x4,%esp
  802016:	6a 01                	push   $0x1
  802018:	50                   	push   %eax
  802019:	ff 75 bc             	pushl  -0x44(%ebp)
  80201c:	e8 ae fe ff ff       	call   801ecf <set_block_data>
  802021:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802027:	8b 40 04             	mov    0x4(%eax),%eax
  80202a:	85 c0                	test   %eax,%eax
  80202c:	75 68                	jne    802096 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80202e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802032:	75 17                	jne    80204b <alloc_block_FF+0x14d>
  802034:	83 ec 04             	sub    $0x4,%esp
  802037:	68 c8 40 80 00       	push   $0x8040c8
  80203c:	68 d7 00 00 00       	push   $0xd7
  802041:	68 ad 40 80 00       	push   $0x8040ad
  802046:	e8 cc 15 00 00       	call   803617 <_panic>
  80204b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802051:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802054:	89 10                	mov    %edx,(%eax)
  802056:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802059:	8b 00                	mov    (%eax),%eax
  80205b:	85 c0                	test   %eax,%eax
  80205d:	74 0d                	je     80206c <alloc_block_FF+0x16e>
  80205f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802064:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802067:	89 50 04             	mov    %edx,0x4(%eax)
  80206a:	eb 08                	jmp    802074 <alloc_block_FF+0x176>
  80206c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80206f:	a3 30 50 80 00       	mov    %eax,0x805030
  802074:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802077:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80207c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80207f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802086:	a1 38 50 80 00       	mov    0x805038,%eax
  80208b:	40                   	inc    %eax
  80208c:	a3 38 50 80 00       	mov    %eax,0x805038
  802091:	e9 dc 00 00 00       	jmp    802172 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802099:	8b 00                	mov    (%eax),%eax
  80209b:	85 c0                	test   %eax,%eax
  80209d:	75 65                	jne    802104 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80209f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8020a3:	75 17                	jne    8020bc <alloc_block_FF+0x1be>
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	68 fc 40 80 00       	push   $0x8040fc
  8020ad:	68 db 00 00 00       	push   $0xdb
  8020b2:	68 ad 40 80 00       	push   $0x8040ad
  8020b7:	e8 5b 15 00 00       	call   803617 <_panic>
  8020bc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8020c2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020c5:	89 50 04             	mov    %edx,0x4(%eax)
  8020c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020cb:	8b 40 04             	mov    0x4(%eax),%eax
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	74 0c                	je     8020de <alloc_block_FF+0x1e0>
  8020d2:	a1 30 50 80 00       	mov    0x805030,%eax
  8020d7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020da:	89 10                	mov    %edx,(%eax)
  8020dc:	eb 08                	jmp    8020e6 <alloc_block_FF+0x1e8>
  8020de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020e9:	a3 30 50 80 00       	mov    %eax,0x805030
  8020ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8020fc:	40                   	inc    %eax
  8020fd:	a3 38 50 80 00       	mov    %eax,0x805038
  802102:	eb 6e                	jmp    802172 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802104:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802108:	74 06                	je     802110 <alloc_block_FF+0x212>
  80210a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80210e:	75 17                	jne    802127 <alloc_block_FF+0x229>
  802110:	83 ec 04             	sub    $0x4,%esp
  802113:	68 20 41 80 00       	push   $0x804120
  802118:	68 df 00 00 00       	push   $0xdf
  80211d:	68 ad 40 80 00       	push   $0x8040ad
  802122:	e8 f0 14 00 00       	call   803617 <_panic>
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	8b 10                	mov    (%eax),%edx
  80212c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80212f:	89 10                	mov    %edx,(%eax)
  802131:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802134:	8b 00                	mov    (%eax),%eax
  802136:	85 c0                	test   %eax,%eax
  802138:	74 0b                	je     802145 <alloc_block_FF+0x247>
  80213a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802142:	89 50 04             	mov    %edx,0x4(%eax)
  802145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802148:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80214b:	89 10                	mov    %edx,(%eax)
  80214d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802150:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802153:	89 50 04             	mov    %edx,0x4(%eax)
  802156:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802159:	8b 00                	mov    (%eax),%eax
  80215b:	85 c0                	test   %eax,%eax
  80215d:	75 08                	jne    802167 <alloc_block_FF+0x269>
  80215f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802162:	a3 30 50 80 00       	mov    %eax,0x805030
  802167:	a1 38 50 80 00       	mov    0x805038,%eax
  80216c:	40                   	inc    %eax
  80216d:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802172:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802176:	75 17                	jne    80218f <alloc_block_FF+0x291>
  802178:	83 ec 04             	sub    $0x4,%esp
  80217b:	68 8f 40 80 00       	push   $0x80408f
  802180:	68 e1 00 00 00       	push   $0xe1
  802185:	68 ad 40 80 00       	push   $0x8040ad
  80218a:	e8 88 14 00 00       	call   803617 <_panic>
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	8b 00                	mov    (%eax),%eax
  802194:	85 c0                	test   %eax,%eax
  802196:	74 10                	je     8021a8 <alloc_block_FF+0x2aa>
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	8b 00                	mov    (%eax),%eax
  80219d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a0:	8b 52 04             	mov    0x4(%edx),%edx
  8021a3:	89 50 04             	mov    %edx,0x4(%eax)
  8021a6:	eb 0b                	jmp    8021b3 <alloc_block_FF+0x2b5>
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	8b 40 04             	mov    0x4(%eax),%eax
  8021ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b6:	8b 40 04             	mov    0x4(%eax),%eax
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	74 0f                	je     8021cc <alloc_block_FF+0x2ce>
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	8b 40 04             	mov    0x4(%eax),%eax
  8021c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c6:	8b 12                	mov    (%edx),%edx
  8021c8:	89 10                	mov    %edx,(%eax)
  8021ca:	eb 0a                	jmp    8021d6 <alloc_block_FF+0x2d8>
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	8b 00                	mov    (%eax),%eax
  8021d1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e9:	a1 38 50 80 00       	mov    0x805038,%eax
  8021ee:	48                   	dec    %eax
  8021ef:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8021f4:	83 ec 04             	sub    $0x4,%esp
  8021f7:	6a 00                	push   $0x0
  8021f9:	ff 75 b4             	pushl  -0x4c(%ebp)
  8021fc:	ff 75 b0             	pushl  -0x50(%ebp)
  8021ff:	e8 cb fc ff ff       	call   801ecf <set_block_data>
  802204:	83 c4 10             	add    $0x10,%esp
  802207:	e9 95 00 00 00       	jmp    8022a1 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80220c:	83 ec 04             	sub    $0x4,%esp
  80220f:	6a 01                	push   $0x1
  802211:	ff 75 b8             	pushl  -0x48(%ebp)
  802214:	ff 75 bc             	pushl  -0x44(%ebp)
  802217:	e8 b3 fc ff ff       	call   801ecf <set_block_data>
  80221c:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80221f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802223:	75 17                	jne    80223c <alloc_block_FF+0x33e>
  802225:	83 ec 04             	sub    $0x4,%esp
  802228:	68 8f 40 80 00       	push   $0x80408f
  80222d:	68 e8 00 00 00       	push   $0xe8
  802232:	68 ad 40 80 00       	push   $0x8040ad
  802237:	e8 db 13 00 00       	call   803617 <_panic>
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	8b 00                	mov    (%eax),%eax
  802241:	85 c0                	test   %eax,%eax
  802243:	74 10                	je     802255 <alloc_block_FF+0x357>
  802245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224d:	8b 52 04             	mov    0x4(%edx),%edx
  802250:	89 50 04             	mov    %edx,0x4(%eax)
  802253:	eb 0b                	jmp    802260 <alloc_block_FF+0x362>
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	8b 40 04             	mov    0x4(%eax),%eax
  80225b:	a3 30 50 80 00       	mov    %eax,0x805030
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	8b 40 04             	mov    0x4(%eax),%eax
  802266:	85 c0                	test   %eax,%eax
  802268:	74 0f                	je     802279 <alloc_block_FF+0x37b>
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	8b 40 04             	mov    0x4(%eax),%eax
  802270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802273:	8b 12                	mov    (%edx),%edx
  802275:	89 10                	mov    %edx,(%eax)
  802277:	eb 0a                	jmp    802283 <alloc_block_FF+0x385>
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	8b 00                	mov    (%eax),%eax
  80227e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802296:	a1 38 50 80 00       	mov    0x805038,%eax
  80229b:	48                   	dec    %eax
  80229c:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8022a1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022a4:	e9 0f 01 00 00       	jmp    8023b8 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8022a9:	a1 34 50 80 00       	mov    0x805034,%eax
  8022ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b5:	74 07                	je     8022be <alloc_block_FF+0x3c0>
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 00                	mov    (%eax),%eax
  8022bc:	eb 05                	jmp    8022c3 <alloc_block_FF+0x3c5>
  8022be:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c3:	a3 34 50 80 00       	mov    %eax,0x805034
  8022c8:	a1 34 50 80 00       	mov    0x805034,%eax
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	0f 85 e9 fc ff ff    	jne    801fbe <alloc_block_FF+0xc0>
  8022d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d9:	0f 85 df fc ff ff    	jne    801fbe <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	83 c0 08             	add    $0x8,%eax
  8022e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8022e8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8022ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8022f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8022f5:	01 d0                	add    %edx,%eax
  8022f7:	48                   	dec    %eax
  8022f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8022fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8022fe:	ba 00 00 00 00       	mov    $0x0,%edx
  802303:	f7 75 d8             	divl   -0x28(%ebp)
  802306:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802309:	29 d0                	sub    %edx,%eax
  80230b:	c1 e8 0c             	shr    $0xc,%eax
  80230e:	83 ec 0c             	sub    $0xc,%esp
  802311:	50                   	push   %eax
  802312:	e8 ce ed ff ff       	call   8010e5 <sbrk>
  802317:	83 c4 10             	add    $0x10,%esp
  80231a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80231d:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802321:	75 0a                	jne    80232d <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
  802328:	e9 8b 00 00 00       	jmp    8023b8 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80232d:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802334:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802337:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80233a:	01 d0                	add    %edx,%eax
  80233c:	48                   	dec    %eax
  80233d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802340:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802343:	ba 00 00 00 00       	mov    $0x0,%edx
  802348:	f7 75 cc             	divl   -0x34(%ebp)
  80234b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80234e:	29 d0                	sub    %edx,%eax
  802350:	8d 50 fc             	lea    -0x4(%eax),%edx
  802353:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802356:	01 d0                	add    %edx,%eax
  802358:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80235d:	a1 40 50 80 00       	mov    0x805040,%eax
  802362:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802368:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80236f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802372:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802375:	01 d0                	add    %edx,%eax
  802377:	48                   	dec    %eax
  802378:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80237b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80237e:	ba 00 00 00 00       	mov    $0x0,%edx
  802383:	f7 75 c4             	divl   -0x3c(%ebp)
  802386:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802389:	29 d0                	sub    %edx,%eax
  80238b:	83 ec 04             	sub    $0x4,%esp
  80238e:	6a 01                	push   $0x1
  802390:	50                   	push   %eax
  802391:	ff 75 d0             	pushl  -0x30(%ebp)
  802394:	e8 36 fb ff ff       	call   801ecf <set_block_data>
  802399:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80239c:	83 ec 0c             	sub    $0xc,%esp
  80239f:	ff 75 d0             	pushl  -0x30(%ebp)
  8023a2:	e8 1b 0a 00 00       	call   802dc2 <free_block>
  8023a7:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8023aa:	83 ec 0c             	sub    $0xc,%esp
  8023ad:	ff 75 08             	pushl  0x8(%ebp)
  8023b0:	e8 49 fb ff ff       	call   801efe <alloc_block_FF>
  8023b5:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	83 e0 01             	and    $0x1,%eax
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	74 03                	je     8023cd <alloc_block_BF+0x13>
  8023ca:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8023cd:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8023d1:	77 07                	ja     8023da <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8023d3:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8023da:	a1 24 50 80 00       	mov    0x805024,%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	75 73                	jne    802456 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	83 c0 10             	add    $0x10,%eax
  8023e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8023ec:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8023f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f9:	01 d0                	add    %edx,%eax
  8023fb:	48                   	dec    %eax
  8023fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8023ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802402:	ba 00 00 00 00       	mov    $0x0,%edx
  802407:	f7 75 e0             	divl   -0x20(%ebp)
  80240a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80240d:	29 d0                	sub    %edx,%eax
  80240f:	c1 e8 0c             	shr    $0xc,%eax
  802412:	83 ec 0c             	sub    $0xc,%esp
  802415:	50                   	push   %eax
  802416:	e8 ca ec ff ff       	call   8010e5 <sbrk>
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802421:	83 ec 0c             	sub    $0xc,%esp
  802424:	6a 00                	push   $0x0
  802426:	e8 ba ec ff ff       	call   8010e5 <sbrk>
  80242b:	83 c4 10             	add    $0x10,%esp
  80242e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802431:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802434:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802437:	83 ec 08             	sub    $0x8,%esp
  80243a:	50                   	push   %eax
  80243b:	ff 75 d8             	pushl  -0x28(%ebp)
  80243e:	e8 9f f8 ff ff       	call   801ce2 <initialize_dynamic_allocator>
  802443:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802446:	83 ec 0c             	sub    $0xc,%esp
  802449:	68 eb 40 80 00       	push   $0x8040eb
  80244e:	e8 f8 de ff ff       	call   80034b <cprintf>
  802453:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802456:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80245d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802464:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80246b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802472:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802477:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247a:	e9 1d 01 00 00       	jmp    80259c <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802485:	83 ec 0c             	sub    $0xc,%esp
  802488:	ff 75 a8             	pushl  -0x58(%ebp)
  80248b:	e8 ee f6 ff ff       	call   801b7e <get_block_size>
  802490:	83 c4 10             	add    $0x10,%esp
  802493:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	83 c0 08             	add    $0x8,%eax
  80249c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80249f:	0f 87 ef 00 00 00    	ja     802594 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	83 c0 18             	add    $0x18,%eax
  8024ab:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8024ae:	77 1d                	ja     8024cd <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8024b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8024b6:	0f 86 d8 00 00 00    	jbe    802594 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8024bc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8024bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8024c2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8024c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8024c8:	e9 c7 00 00 00       	jmp    802594 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	83 c0 08             	add    $0x8,%eax
  8024d3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8024d6:	0f 85 9d 00 00 00    	jne    802579 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8024dc:	83 ec 04             	sub    $0x4,%esp
  8024df:	6a 01                	push   $0x1
  8024e1:	ff 75 a4             	pushl  -0x5c(%ebp)
  8024e4:	ff 75 a8             	pushl  -0x58(%ebp)
  8024e7:	e8 e3 f9 ff ff       	call   801ecf <set_block_data>
  8024ec:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8024ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f3:	75 17                	jne    80250c <alloc_block_BF+0x152>
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	68 8f 40 80 00       	push   $0x80408f
  8024fd:	68 2c 01 00 00       	push   $0x12c
  802502:	68 ad 40 80 00       	push   $0x8040ad
  802507:	e8 0b 11 00 00       	call   803617 <_panic>
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 00                	mov    (%eax),%eax
  802511:	85 c0                	test   %eax,%eax
  802513:	74 10                	je     802525 <alloc_block_BF+0x16b>
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251d:	8b 52 04             	mov    0x4(%edx),%edx
  802520:	89 50 04             	mov    %edx,0x4(%eax)
  802523:	eb 0b                	jmp    802530 <alloc_block_BF+0x176>
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 40 04             	mov    0x4(%eax),%eax
  80252b:	a3 30 50 80 00       	mov    %eax,0x805030
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 40 04             	mov    0x4(%eax),%eax
  802536:	85 c0                	test   %eax,%eax
  802538:	74 0f                	je     802549 <alloc_block_BF+0x18f>
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 04             	mov    0x4(%eax),%eax
  802540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802543:	8b 12                	mov    (%edx),%edx
  802545:	89 10                	mov    %edx,(%eax)
  802547:	eb 0a                	jmp    802553 <alloc_block_BF+0x199>
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802566:	a1 38 50 80 00       	mov    0x805038,%eax
  80256b:	48                   	dec    %eax
  80256c:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802571:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802574:	e9 24 04 00 00       	jmp    80299d <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802579:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80257f:	76 13                	jbe    802594 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802581:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802588:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80258b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80258e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802591:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802594:	a1 34 50 80 00       	mov    0x805034,%eax
  802599:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a0:	74 07                	je     8025a9 <alloc_block_BF+0x1ef>
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 00                	mov    (%eax),%eax
  8025a7:	eb 05                	jmp    8025ae <alloc_block_BF+0x1f4>
  8025a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ae:	a3 34 50 80 00       	mov    %eax,0x805034
  8025b3:	a1 34 50 80 00       	mov    0x805034,%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	0f 85 bf fe ff ff    	jne    80247f <alloc_block_BF+0xc5>
  8025c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c4:	0f 85 b5 fe ff ff    	jne    80247f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8025ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ce:	0f 84 26 02 00 00    	je     8027fa <alloc_block_BF+0x440>
  8025d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025d8:	0f 85 1c 02 00 00    	jne    8027fa <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8025de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e1:	2b 45 08             	sub    0x8(%ebp),%eax
  8025e4:	83 e8 08             	sub    $0x8,%eax
  8025e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	8d 50 08             	lea    0x8(%eax),%edx
  8025f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f3:	01 d0                	add    %edx,%eax
  8025f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fb:	83 c0 08             	add    $0x8,%eax
  8025fe:	83 ec 04             	sub    $0x4,%esp
  802601:	6a 01                	push   $0x1
  802603:	50                   	push   %eax
  802604:	ff 75 f0             	pushl  -0x10(%ebp)
  802607:	e8 c3 f8 ff ff       	call   801ecf <set_block_data>
  80260c:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80260f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802612:	8b 40 04             	mov    0x4(%eax),%eax
  802615:	85 c0                	test   %eax,%eax
  802617:	75 68                	jne    802681 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802619:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80261d:	75 17                	jne    802636 <alloc_block_BF+0x27c>
  80261f:	83 ec 04             	sub    $0x4,%esp
  802622:	68 c8 40 80 00       	push   $0x8040c8
  802627:	68 45 01 00 00       	push   $0x145
  80262c:	68 ad 40 80 00       	push   $0x8040ad
  802631:	e8 e1 0f 00 00       	call   803617 <_panic>
  802636:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80263c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80263f:	89 10                	mov    %edx,(%eax)
  802641:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	74 0d                	je     802657 <alloc_block_BF+0x29d>
  80264a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80264f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802652:	89 50 04             	mov    %edx,0x4(%eax)
  802655:	eb 08                	jmp    80265f <alloc_block_BF+0x2a5>
  802657:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80265a:	a3 30 50 80 00       	mov    %eax,0x805030
  80265f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802662:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802667:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80266a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802671:	a1 38 50 80 00       	mov    0x805038,%eax
  802676:	40                   	inc    %eax
  802677:	a3 38 50 80 00       	mov    %eax,0x805038
  80267c:	e9 dc 00 00 00       	jmp    80275d <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802684:	8b 00                	mov    (%eax),%eax
  802686:	85 c0                	test   %eax,%eax
  802688:	75 65                	jne    8026ef <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80268a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80268e:	75 17                	jne    8026a7 <alloc_block_BF+0x2ed>
  802690:	83 ec 04             	sub    $0x4,%esp
  802693:	68 fc 40 80 00       	push   $0x8040fc
  802698:	68 4a 01 00 00       	push   $0x14a
  80269d:	68 ad 40 80 00       	push   $0x8040ad
  8026a2:	e8 70 0f 00 00       	call   803617 <_panic>
  8026a7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8026ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026b0:	89 50 04             	mov    %edx,0x4(%eax)
  8026b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026b6:	8b 40 04             	mov    0x4(%eax),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 0c                	je     8026c9 <alloc_block_BF+0x30f>
  8026bd:	a1 30 50 80 00       	mov    0x805030,%eax
  8026c2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	eb 08                	jmp    8026d1 <alloc_block_BF+0x317>
  8026c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026cc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8026d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e2:	a1 38 50 80 00       	mov    0x805038,%eax
  8026e7:	40                   	inc    %eax
  8026e8:	a3 38 50 80 00       	mov    %eax,0x805038
  8026ed:	eb 6e                	jmp    80275d <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8026ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f3:	74 06                	je     8026fb <alloc_block_BF+0x341>
  8026f5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026f9:	75 17                	jne    802712 <alloc_block_BF+0x358>
  8026fb:	83 ec 04             	sub    $0x4,%esp
  8026fe:	68 20 41 80 00       	push   $0x804120
  802703:	68 4f 01 00 00       	push   $0x14f
  802708:	68 ad 40 80 00       	push   $0x8040ad
  80270d:	e8 05 0f 00 00       	call   803617 <_panic>
  802712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802715:	8b 10                	mov    (%eax),%edx
  802717:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80271a:	89 10                	mov    %edx,(%eax)
  80271c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80271f:	8b 00                	mov    (%eax),%eax
  802721:	85 c0                	test   %eax,%eax
  802723:	74 0b                	je     802730 <alloc_block_BF+0x376>
  802725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80272d:	89 50 04             	mov    %edx,0x4(%eax)
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802736:	89 10                	mov    %edx,(%eax)
  802738:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80273b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80273e:	89 50 04             	mov    %edx,0x4(%eax)
  802741:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	85 c0                	test   %eax,%eax
  802748:	75 08                	jne    802752 <alloc_block_BF+0x398>
  80274a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80274d:	a3 30 50 80 00       	mov    %eax,0x805030
  802752:	a1 38 50 80 00       	mov    0x805038,%eax
  802757:	40                   	inc    %eax
  802758:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80275d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802761:	75 17                	jne    80277a <alloc_block_BF+0x3c0>
  802763:	83 ec 04             	sub    $0x4,%esp
  802766:	68 8f 40 80 00       	push   $0x80408f
  80276b:	68 51 01 00 00       	push   $0x151
  802770:	68 ad 40 80 00       	push   $0x8040ad
  802775:	e8 9d 0e 00 00       	call   803617 <_panic>
  80277a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277d:	8b 00                	mov    (%eax),%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	74 10                	je     802793 <alloc_block_BF+0x3d9>
  802783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80278b:	8b 52 04             	mov    0x4(%edx),%edx
  80278e:	89 50 04             	mov    %edx,0x4(%eax)
  802791:	eb 0b                	jmp    80279e <alloc_block_BF+0x3e4>
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	8b 40 04             	mov    0x4(%eax),%eax
  802799:	a3 30 50 80 00       	mov    %eax,0x805030
  80279e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a1:	8b 40 04             	mov    0x4(%eax),%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	74 0f                	je     8027b7 <alloc_block_BF+0x3fd>
  8027a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ab:	8b 40 04             	mov    0x4(%eax),%eax
  8027ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b1:	8b 12                	mov    (%edx),%edx
  8027b3:	89 10                	mov    %edx,(%eax)
  8027b5:	eb 0a                	jmp    8027c1 <alloc_block_BF+0x407>
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	8b 00                	mov    (%eax),%eax
  8027bc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d4:	a1 38 50 80 00       	mov    0x805038,%eax
  8027d9:	48                   	dec    %eax
  8027da:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8027df:	83 ec 04             	sub    $0x4,%esp
  8027e2:	6a 00                	push   $0x0
  8027e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8027e7:	ff 75 cc             	pushl  -0x34(%ebp)
  8027ea:	e8 e0 f6 ff ff       	call   801ecf <set_block_data>
  8027ef:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8027f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f5:	e9 a3 01 00 00       	jmp    80299d <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8027fa:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8027fe:	0f 85 9d 00 00 00    	jne    8028a1 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802804:	83 ec 04             	sub    $0x4,%esp
  802807:	6a 01                	push   $0x1
  802809:	ff 75 ec             	pushl  -0x14(%ebp)
  80280c:	ff 75 f0             	pushl  -0x10(%ebp)
  80280f:	e8 bb f6 ff ff       	call   801ecf <set_block_data>
  802814:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802817:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80281b:	75 17                	jne    802834 <alloc_block_BF+0x47a>
  80281d:	83 ec 04             	sub    $0x4,%esp
  802820:	68 8f 40 80 00       	push   $0x80408f
  802825:	68 58 01 00 00       	push   $0x158
  80282a:	68 ad 40 80 00       	push   $0x8040ad
  80282f:	e8 e3 0d 00 00       	call   803617 <_panic>
  802834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802837:	8b 00                	mov    (%eax),%eax
  802839:	85 c0                	test   %eax,%eax
  80283b:	74 10                	je     80284d <alloc_block_BF+0x493>
  80283d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802840:	8b 00                	mov    (%eax),%eax
  802842:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802845:	8b 52 04             	mov    0x4(%edx),%edx
  802848:	89 50 04             	mov    %edx,0x4(%eax)
  80284b:	eb 0b                	jmp    802858 <alloc_block_BF+0x49e>
  80284d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802850:	8b 40 04             	mov    0x4(%eax),%eax
  802853:	a3 30 50 80 00       	mov    %eax,0x805030
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	74 0f                	je     802871 <alloc_block_BF+0x4b7>
  802862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802865:	8b 40 04             	mov    0x4(%eax),%eax
  802868:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80286b:	8b 12                	mov    (%edx),%edx
  80286d:	89 10                	mov    %edx,(%eax)
  80286f:	eb 0a                	jmp    80287b <alloc_block_BF+0x4c1>
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802874:	8b 00                	mov    (%eax),%eax
  802876:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80287b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802887:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80288e:	a1 38 50 80 00       	mov    0x805038,%eax
  802893:	48                   	dec    %eax
  802894:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289c:	e9 fc 00 00 00       	jmp    80299d <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8028a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a4:	83 c0 08             	add    $0x8,%eax
  8028a7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8028aa:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8028b1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8028b4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8028b7:	01 d0                	add    %edx,%eax
  8028b9:	48                   	dec    %eax
  8028ba:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8028bd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8028c5:	f7 75 c4             	divl   -0x3c(%ebp)
  8028c8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8028cb:	29 d0                	sub    %edx,%eax
  8028cd:	c1 e8 0c             	shr    $0xc,%eax
  8028d0:	83 ec 0c             	sub    $0xc,%esp
  8028d3:	50                   	push   %eax
  8028d4:	e8 0c e8 ff ff       	call   8010e5 <sbrk>
  8028d9:	83 c4 10             	add    $0x10,%esp
  8028dc:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8028df:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8028e3:	75 0a                	jne    8028ef <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8028e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ea:	e9 ae 00 00 00       	jmp    80299d <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8028ef:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8028f6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8028f9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8028fc:	01 d0                	add    %edx,%eax
  8028fe:	48                   	dec    %eax
  8028ff:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802902:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802905:	ba 00 00 00 00       	mov    $0x0,%edx
  80290a:	f7 75 b8             	divl   -0x48(%ebp)
  80290d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802910:	29 d0                	sub    %edx,%eax
  802912:	8d 50 fc             	lea    -0x4(%eax),%edx
  802915:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802918:	01 d0                	add    %edx,%eax
  80291a:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  80291f:	a1 40 50 80 00       	mov    0x805040,%eax
  802924:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  80292a:	83 ec 0c             	sub    $0xc,%esp
  80292d:	68 54 41 80 00       	push   $0x804154
  802932:	e8 14 da ff ff       	call   80034b <cprintf>
  802937:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  80293a:	83 ec 08             	sub    $0x8,%esp
  80293d:	ff 75 bc             	pushl  -0x44(%ebp)
  802940:	68 59 41 80 00       	push   $0x804159
  802945:	e8 01 da ff ff       	call   80034b <cprintf>
  80294a:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80294d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802954:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802957:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80295a:	01 d0                	add    %edx,%eax
  80295c:	48                   	dec    %eax
  80295d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802960:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802963:	ba 00 00 00 00       	mov    $0x0,%edx
  802968:	f7 75 b0             	divl   -0x50(%ebp)
  80296b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80296e:	29 d0                	sub    %edx,%eax
  802970:	83 ec 04             	sub    $0x4,%esp
  802973:	6a 01                	push   $0x1
  802975:	50                   	push   %eax
  802976:	ff 75 bc             	pushl  -0x44(%ebp)
  802979:	e8 51 f5 ff ff       	call   801ecf <set_block_data>
  80297e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802981:	83 ec 0c             	sub    $0xc,%esp
  802984:	ff 75 bc             	pushl  -0x44(%ebp)
  802987:	e8 36 04 00 00       	call   802dc2 <free_block>
  80298c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  80298f:	83 ec 0c             	sub    $0xc,%esp
  802992:	ff 75 08             	pushl  0x8(%ebp)
  802995:	e8 20 fa ff ff       	call   8023ba <alloc_block_BF>
  80299a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  80299d:	c9                   	leave  
  80299e:	c3                   	ret    

0080299f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  80299f:	55                   	push   %ebp
  8029a0:	89 e5                	mov    %esp,%ebp
  8029a2:	53                   	push   %ebx
  8029a3:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8029a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  8029b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b8:	74 1e                	je     8029d8 <merging+0x39>
  8029ba:	ff 75 08             	pushl  0x8(%ebp)
  8029bd:	e8 bc f1 ff ff       	call   801b7e <get_block_size>
  8029c2:	83 c4 04             	add    $0x4,%esp
  8029c5:	89 c2                	mov    %eax,%edx
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	01 d0                	add    %edx,%eax
  8029cc:	3b 45 10             	cmp    0x10(%ebp),%eax
  8029cf:	75 07                	jne    8029d8 <merging+0x39>
		prev_is_free = 1;
  8029d1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  8029d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8029dc:	74 1e                	je     8029fc <merging+0x5d>
  8029de:	ff 75 10             	pushl  0x10(%ebp)
  8029e1:	e8 98 f1 ff ff       	call   801b7e <get_block_size>
  8029e6:	83 c4 04             	add    $0x4,%esp
  8029e9:	89 c2                	mov    %eax,%edx
  8029eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8029ee:	01 d0                	add    %edx,%eax
  8029f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029f3:	75 07                	jne    8029fc <merging+0x5d>
		next_is_free = 1;
  8029f5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  8029fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a00:	0f 84 cc 00 00 00    	je     802ad2 <merging+0x133>
  802a06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a0a:	0f 84 c2 00 00 00    	je     802ad2 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802a10:	ff 75 08             	pushl  0x8(%ebp)
  802a13:	e8 66 f1 ff ff       	call   801b7e <get_block_size>
  802a18:	83 c4 04             	add    $0x4,%esp
  802a1b:	89 c3                	mov    %eax,%ebx
  802a1d:	ff 75 10             	pushl  0x10(%ebp)
  802a20:	e8 59 f1 ff ff       	call   801b7e <get_block_size>
  802a25:	83 c4 04             	add    $0x4,%esp
  802a28:	01 c3                	add    %eax,%ebx
  802a2a:	ff 75 0c             	pushl  0xc(%ebp)
  802a2d:	e8 4c f1 ff ff       	call   801b7e <get_block_size>
  802a32:	83 c4 04             	add    $0x4,%esp
  802a35:	01 d8                	add    %ebx,%eax
  802a37:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802a3a:	6a 00                	push   $0x0
  802a3c:	ff 75 ec             	pushl  -0x14(%ebp)
  802a3f:	ff 75 08             	pushl  0x8(%ebp)
  802a42:	e8 88 f4 ff ff       	call   801ecf <set_block_data>
  802a47:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802a4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a4e:	75 17                	jne    802a67 <merging+0xc8>
  802a50:	83 ec 04             	sub    $0x4,%esp
  802a53:	68 8f 40 80 00       	push   $0x80408f
  802a58:	68 7d 01 00 00       	push   $0x17d
  802a5d:	68 ad 40 80 00       	push   $0x8040ad
  802a62:	e8 b0 0b 00 00       	call   803617 <_panic>
  802a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 10                	je     802a80 <merging+0xe1>
  802a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a73:	8b 00                	mov    (%eax),%eax
  802a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a78:	8b 52 04             	mov    0x4(%edx),%edx
  802a7b:	89 50 04             	mov    %edx,0x4(%eax)
  802a7e:	eb 0b                	jmp    802a8b <merging+0xec>
  802a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a83:	8b 40 04             	mov    0x4(%eax),%eax
  802a86:	a3 30 50 80 00       	mov    %eax,0x805030
  802a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a8e:	8b 40 04             	mov    0x4(%eax),%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	74 0f                	je     802aa4 <merging+0x105>
  802a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a98:	8b 40 04             	mov    0x4(%eax),%eax
  802a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a9e:	8b 12                	mov    (%edx),%edx
  802aa0:	89 10                	mov    %edx,(%eax)
  802aa2:	eb 0a                	jmp    802aae <merging+0x10f>
  802aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ab1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac1:	a1 38 50 80 00       	mov    0x805038,%eax
  802ac6:	48                   	dec    %eax
  802ac7:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802acc:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802acd:	e9 ea 02 00 00       	jmp    802dbc <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802ad2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad6:	74 3b                	je     802b13 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ad8:	83 ec 0c             	sub    $0xc,%esp
  802adb:	ff 75 08             	pushl  0x8(%ebp)
  802ade:	e8 9b f0 ff ff       	call   801b7e <get_block_size>
  802ae3:	83 c4 10             	add    $0x10,%esp
  802ae6:	89 c3                	mov    %eax,%ebx
  802ae8:	83 ec 0c             	sub    $0xc,%esp
  802aeb:	ff 75 10             	pushl  0x10(%ebp)
  802aee:	e8 8b f0 ff ff       	call   801b7e <get_block_size>
  802af3:	83 c4 10             	add    $0x10,%esp
  802af6:	01 d8                	add    %ebx,%eax
  802af8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802afb:	83 ec 04             	sub    $0x4,%esp
  802afe:	6a 00                	push   $0x0
  802b00:	ff 75 e8             	pushl  -0x18(%ebp)
  802b03:	ff 75 08             	pushl  0x8(%ebp)
  802b06:	e8 c4 f3 ff ff       	call   801ecf <set_block_data>
  802b0b:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b0e:	e9 a9 02 00 00       	jmp    802dbc <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802b13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b17:	0f 84 2d 01 00 00    	je     802c4a <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802b1d:	83 ec 0c             	sub    $0xc,%esp
  802b20:	ff 75 10             	pushl  0x10(%ebp)
  802b23:	e8 56 f0 ff ff       	call   801b7e <get_block_size>
  802b28:	83 c4 10             	add    $0x10,%esp
  802b2b:	89 c3                	mov    %eax,%ebx
  802b2d:	83 ec 0c             	sub    $0xc,%esp
  802b30:	ff 75 0c             	pushl  0xc(%ebp)
  802b33:	e8 46 f0 ff ff       	call   801b7e <get_block_size>
  802b38:	83 c4 10             	add    $0x10,%esp
  802b3b:	01 d8                	add    %ebx,%eax
  802b3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802b40:	83 ec 04             	sub    $0x4,%esp
  802b43:	6a 00                	push   $0x0
  802b45:	ff 75 e4             	pushl  -0x1c(%ebp)
  802b48:	ff 75 10             	pushl  0x10(%ebp)
  802b4b:	e8 7f f3 ff ff       	call   801ecf <set_block_data>
  802b50:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802b53:	8b 45 10             	mov    0x10(%ebp),%eax
  802b56:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802b59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b5d:	74 06                	je     802b65 <merging+0x1c6>
  802b5f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b63:	75 17                	jne    802b7c <merging+0x1dd>
  802b65:	83 ec 04             	sub    $0x4,%esp
  802b68:	68 68 41 80 00       	push   $0x804168
  802b6d:	68 8d 01 00 00       	push   $0x18d
  802b72:	68 ad 40 80 00       	push   $0x8040ad
  802b77:	e8 9b 0a 00 00       	call   803617 <_panic>
  802b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b7f:	8b 50 04             	mov    0x4(%eax),%edx
  802b82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b85:	89 50 04             	mov    %edx,0x4(%eax)
  802b88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b8e:	89 10                	mov    %edx,(%eax)
  802b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b93:	8b 40 04             	mov    0x4(%eax),%eax
  802b96:	85 c0                	test   %eax,%eax
  802b98:	74 0d                	je     802ba7 <merging+0x208>
  802b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ba0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ba3:	89 10                	mov    %edx,(%eax)
  802ba5:	eb 08                	jmp    802baf <merging+0x210>
  802ba7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802baa:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bb5:	89 50 04             	mov    %edx,0x4(%eax)
  802bb8:	a1 38 50 80 00       	mov    0x805038,%eax
  802bbd:	40                   	inc    %eax
  802bbe:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802bc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bc7:	75 17                	jne    802be0 <merging+0x241>
  802bc9:	83 ec 04             	sub    $0x4,%esp
  802bcc:	68 8f 40 80 00       	push   $0x80408f
  802bd1:	68 8e 01 00 00       	push   $0x18e
  802bd6:	68 ad 40 80 00       	push   $0x8040ad
  802bdb:	e8 37 0a 00 00       	call   803617 <_panic>
  802be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802be3:	8b 00                	mov    (%eax),%eax
  802be5:	85 c0                	test   %eax,%eax
  802be7:	74 10                	je     802bf9 <merging+0x25a>
  802be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bec:	8b 00                	mov    (%eax),%eax
  802bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bf1:	8b 52 04             	mov    0x4(%edx),%edx
  802bf4:	89 50 04             	mov    %edx,0x4(%eax)
  802bf7:	eb 0b                	jmp    802c04 <merging+0x265>
  802bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bfc:	8b 40 04             	mov    0x4(%eax),%eax
  802bff:	a3 30 50 80 00       	mov    %eax,0x805030
  802c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	74 0f                	je     802c1d <merging+0x27e>
  802c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c11:	8b 40 04             	mov    0x4(%eax),%eax
  802c14:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c17:	8b 12                	mov    (%edx),%edx
  802c19:	89 10                	mov    %edx,(%eax)
  802c1b:	eb 0a                	jmp    802c27 <merging+0x288>
  802c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3a:	a1 38 50 80 00       	mov    0x805038,%eax
  802c3f:	48                   	dec    %eax
  802c40:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c45:	e9 72 01 00 00       	jmp    802dbc <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  802c4d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802c50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c54:	74 79                	je     802ccf <merging+0x330>
  802c56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c5a:	74 73                	je     802ccf <merging+0x330>
  802c5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c60:	74 06                	je     802c68 <merging+0x2c9>
  802c62:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802c66:	75 17                	jne    802c7f <merging+0x2e0>
  802c68:	83 ec 04             	sub    $0x4,%esp
  802c6b:	68 20 41 80 00       	push   $0x804120
  802c70:	68 94 01 00 00       	push   $0x194
  802c75:	68 ad 40 80 00       	push   $0x8040ad
  802c7a:	e8 98 09 00 00       	call   803617 <_panic>
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	8b 10                	mov    (%eax),%edx
  802c84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c87:	89 10                	mov    %edx,(%eax)
  802c89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	85 c0                	test   %eax,%eax
  802c90:	74 0b                	je     802c9d <merging+0x2fe>
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	8b 00                	mov    (%eax),%eax
  802c97:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c9a:	89 50 04             	mov    %edx,0x4(%eax)
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ca3:	89 10                	mov    %edx,(%eax)
  802ca5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  802cab:	89 50 04             	mov    %edx,0x4(%eax)
  802cae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	75 08                	jne    802cbf <merging+0x320>
  802cb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cba:	a3 30 50 80 00       	mov    %eax,0x805030
  802cbf:	a1 38 50 80 00       	mov    0x805038,%eax
  802cc4:	40                   	inc    %eax
  802cc5:	a3 38 50 80 00       	mov    %eax,0x805038
  802cca:	e9 ce 00 00 00       	jmp    802d9d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802ccf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd3:	74 65                	je     802d3a <merging+0x39b>
  802cd5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802cd9:	75 17                	jne    802cf2 <merging+0x353>
  802cdb:	83 ec 04             	sub    $0x4,%esp
  802cde:	68 fc 40 80 00       	push   $0x8040fc
  802ce3:	68 95 01 00 00       	push   $0x195
  802ce8:	68 ad 40 80 00       	push   $0x8040ad
  802ced:	e8 25 09 00 00       	call   803617 <_panic>
  802cf2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802cf8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cfb:	89 50 04             	mov    %edx,0x4(%eax)
  802cfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d01:	8b 40 04             	mov    0x4(%eax),%eax
  802d04:	85 c0                	test   %eax,%eax
  802d06:	74 0c                	je     802d14 <merging+0x375>
  802d08:	a1 30 50 80 00       	mov    0x805030,%eax
  802d0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d10:	89 10                	mov    %edx,(%eax)
  802d12:	eb 08                	jmp    802d1c <merging+0x37d>
  802d14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d17:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d1f:	a3 30 50 80 00       	mov    %eax,0x805030
  802d24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2d:	a1 38 50 80 00       	mov    0x805038,%eax
  802d32:	40                   	inc    %eax
  802d33:	a3 38 50 80 00       	mov    %eax,0x805038
  802d38:	eb 63                	jmp    802d9d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802d3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d3e:	75 17                	jne    802d57 <merging+0x3b8>
  802d40:	83 ec 04             	sub    $0x4,%esp
  802d43:	68 c8 40 80 00       	push   $0x8040c8
  802d48:	68 98 01 00 00       	push   $0x198
  802d4d:	68 ad 40 80 00       	push   $0x8040ad
  802d52:	e8 c0 08 00 00       	call   803617 <_panic>
  802d57:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d60:	89 10                	mov    %edx,(%eax)
  802d62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d65:	8b 00                	mov    (%eax),%eax
  802d67:	85 c0                	test   %eax,%eax
  802d69:	74 0d                	je     802d78 <merging+0x3d9>
  802d6b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d70:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d73:	89 50 04             	mov    %edx,0x4(%eax)
  802d76:	eb 08                	jmp    802d80 <merging+0x3e1>
  802d78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d7b:	a3 30 50 80 00       	mov    %eax,0x805030
  802d80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d83:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d92:	a1 38 50 80 00       	mov    0x805038,%eax
  802d97:	40                   	inc    %eax
  802d98:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802d9d:	83 ec 0c             	sub    $0xc,%esp
  802da0:	ff 75 10             	pushl  0x10(%ebp)
  802da3:	e8 d6 ed ff ff       	call   801b7e <get_block_size>
  802da8:	83 c4 10             	add    $0x10,%esp
  802dab:	83 ec 04             	sub    $0x4,%esp
  802dae:	6a 00                	push   $0x0
  802db0:	50                   	push   %eax
  802db1:	ff 75 10             	pushl  0x10(%ebp)
  802db4:	e8 16 f1 ff ff       	call   801ecf <set_block_data>
  802db9:	83 c4 10             	add    $0x10,%esp
	}
}
  802dbc:	90                   	nop
  802dbd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802dc0:	c9                   	leave  
  802dc1:	c3                   	ret    

00802dc2 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802dc2:	55                   	push   %ebp
  802dc3:	89 e5                	mov    %esp,%ebp
  802dc5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802dc8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802dd0:	a1 30 50 80 00       	mov    0x805030,%eax
  802dd5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dd8:	73 1b                	jae    802df5 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802dda:	a1 30 50 80 00       	mov    0x805030,%eax
  802ddf:	83 ec 04             	sub    $0x4,%esp
  802de2:	ff 75 08             	pushl  0x8(%ebp)
  802de5:	6a 00                	push   $0x0
  802de7:	50                   	push   %eax
  802de8:	e8 b2 fb ff ff       	call   80299f <merging>
  802ded:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802df0:	e9 8b 00 00 00       	jmp    802e80 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802df5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802dfa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dfd:	76 18                	jbe    802e17 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802dff:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e04:	83 ec 04             	sub    $0x4,%esp
  802e07:	ff 75 08             	pushl  0x8(%ebp)
  802e0a:	50                   	push   %eax
  802e0b:	6a 00                	push   $0x0
  802e0d:	e8 8d fb ff ff       	call   80299f <merging>
  802e12:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e15:	eb 69                	jmp    802e80 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802e17:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1f:	eb 39                	jmp    802e5a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e24:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e27:	73 29                	jae    802e52 <free_block+0x90>
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e31:	76 1f                	jbe    802e52 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802e3b:	83 ec 04             	sub    $0x4,%esp
  802e3e:	ff 75 08             	pushl  0x8(%ebp)
  802e41:	ff 75 f0             	pushl  -0x10(%ebp)
  802e44:	ff 75 f4             	pushl  -0xc(%ebp)
  802e47:	e8 53 fb ff ff       	call   80299f <merging>
  802e4c:	83 c4 10             	add    $0x10,%esp
			break;
  802e4f:	90                   	nop
		}
	}
}
  802e50:	eb 2e                	jmp    802e80 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802e52:	a1 34 50 80 00       	mov    0x805034,%eax
  802e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5e:	74 07                	je     802e67 <free_block+0xa5>
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 00                	mov    (%eax),%eax
  802e65:	eb 05                	jmp    802e6c <free_block+0xaa>
  802e67:	b8 00 00 00 00       	mov    $0x0,%eax
  802e6c:	a3 34 50 80 00       	mov    %eax,0x805034
  802e71:	a1 34 50 80 00       	mov    0x805034,%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	75 a7                	jne    802e21 <free_block+0x5f>
  802e7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7e:	75 a1                	jne    802e21 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e80:	90                   	nop
  802e81:	c9                   	leave  
  802e82:	c3                   	ret    

00802e83 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802e83:	55                   	push   %ebp
  802e84:	89 e5                	mov    %esp,%ebp
  802e86:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802e89:	ff 75 08             	pushl  0x8(%ebp)
  802e8c:	e8 ed ec ff ff       	call   801b7e <get_block_size>
  802e91:	83 c4 04             	add    $0x4,%esp
  802e94:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802e97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802e9e:	eb 17                	jmp    802eb7 <copy_data+0x34>
  802ea0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea6:	01 c2                	add    %eax,%edx
  802ea8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	01 c8                	add    %ecx,%eax
  802eb0:	8a 00                	mov    (%eax),%al
  802eb2:	88 02                	mov    %al,(%edx)
  802eb4:	ff 45 fc             	incl   -0x4(%ebp)
  802eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802eba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802ebd:	72 e1                	jb     802ea0 <copy_data+0x1d>
}
  802ebf:	90                   	nop
  802ec0:	c9                   	leave  
  802ec1:	c3                   	ret    

00802ec2 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802ec2:	55                   	push   %ebp
  802ec3:	89 e5                	mov    %esp,%ebp
  802ec5:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802ec8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecc:	75 23                	jne    802ef1 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802ece:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ed2:	74 13                	je     802ee7 <realloc_block_FF+0x25>
  802ed4:	83 ec 0c             	sub    $0xc,%esp
  802ed7:	ff 75 0c             	pushl  0xc(%ebp)
  802eda:	e8 1f f0 ff ff       	call   801efe <alloc_block_FF>
  802edf:	83 c4 10             	add    $0x10,%esp
  802ee2:	e9 f4 06 00 00       	jmp    8035db <realloc_block_FF+0x719>
		return NULL;
  802ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  802eec:	e9 ea 06 00 00       	jmp    8035db <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802ef1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ef5:	75 18                	jne    802f0f <realloc_block_FF+0x4d>
	{
		free_block(va);
  802ef7:	83 ec 0c             	sub    $0xc,%esp
  802efa:	ff 75 08             	pushl  0x8(%ebp)
  802efd:	e8 c0 fe ff ff       	call   802dc2 <free_block>
  802f02:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f05:	b8 00 00 00 00       	mov    $0x0,%eax
  802f0a:	e9 cc 06 00 00       	jmp    8035db <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  802f0f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802f13:	77 07                	ja     802f1c <realloc_block_FF+0x5a>
  802f15:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1f:	83 e0 01             	and    $0x1,%eax
  802f22:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f28:	83 c0 08             	add    $0x8,%eax
  802f2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  802f2e:	83 ec 0c             	sub    $0xc,%esp
  802f31:	ff 75 08             	pushl  0x8(%ebp)
  802f34:	e8 45 ec ff ff       	call   801b7e <get_block_size>
  802f39:	83 c4 10             	add    $0x10,%esp
  802f3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802f3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f42:	83 e8 08             	sub    $0x8,%eax
  802f45:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	83 e8 04             	sub    $0x4,%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	83 e0 fe             	and    $0xfffffffe,%eax
  802f53:	89 c2                	mov    %eax,%edx
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	01 d0                	add    %edx,%eax
  802f5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  802f5d:	83 ec 0c             	sub    $0xc,%esp
  802f60:	ff 75 e4             	pushl  -0x1c(%ebp)
  802f63:	e8 16 ec ff ff       	call   801b7e <get_block_size>
  802f68:	83 c4 10             	add    $0x10,%esp
  802f6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802f6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f71:	83 e8 08             	sub    $0x8,%eax
  802f74:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  802f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f7a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f7d:	75 08                	jne    802f87 <realloc_block_FF+0xc5>
	{
		 return va;
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	e9 54 06 00 00       	jmp    8035db <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  802f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f8a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f8d:	0f 83 e5 03 00 00    	jae    803378 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  802f93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f96:	2b 45 0c             	sub    0xc(%ebp),%eax
  802f99:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  802f9c:	83 ec 0c             	sub    $0xc,%esp
  802f9f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fa2:	e8 f0 eb ff ff       	call   801b97 <is_free_block>
  802fa7:	83 c4 10             	add    $0x10,%esp
  802faa:	84 c0                	test   %al,%al
  802fac:	0f 84 3b 01 00 00    	je     8030ed <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  802fb2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fb5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802fb8:	01 d0                	add    %edx,%eax
  802fba:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  802fbd:	83 ec 04             	sub    $0x4,%esp
  802fc0:	6a 01                	push   $0x1
  802fc2:	ff 75 f0             	pushl  -0x10(%ebp)
  802fc5:	ff 75 08             	pushl  0x8(%ebp)
  802fc8:	e8 02 ef ff ff       	call   801ecf <set_block_data>
  802fcd:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	83 e8 04             	sub    $0x4,%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	83 e0 fe             	and    $0xfffffffe,%eax
  802fdb:	89 c2                	mov    %eax,%edx
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	01 d0                	add    %edx,%eax
  802fe2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  802fe5:	83 ec 04             	sub    $0x4,%esp
  802fe8:	6a 00                	push   $0x0
  802fea:	ff 75 cc             	pushl  -0x34(%ebp)
  802fed:	ff 75 c8             	pushl  -0x38(%ebp)
  802ff0:	e8 da ee ff ff       	call   801ecf <set_block_data>
  802ff5:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  802ff8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ffc:	74 06                	je     803004 <realloc_block_FF+0x142>
  802ffe:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803002:	75 17                	jne    80301b <realloc_block_FF+0x159>
  803004:	83 ec 04             	sub    $0x4,%esp
  803007:	68 20 41 80 00       	push   $0x804120
  80300c:	68 f6 01 00 00       	push   $0x1f6
  803011:	68 ad 40 80 00       	push   $0x8040ad
  803016:	e8 fc 05 00 00       	call   803617 <_panic>
  80301b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301e:	8b 10                	mov    (%eax),%edx
  803020:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803023:	89 10                	mov    %edx,(%eax)
  803025:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803028:	8b 00                	mov    (%eax),%eax
  80302a:	85 c0                	test   %eax,%eax
  80302c:	74 0b                	je     803039 <realloc_block_FF+0x177>
  80302e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803031:	8b 00                	mov    (%eax),%eax
  803033:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803036:	89 50 04             	mov    %edx,0x4(%eax)
  803039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80303f:	89 10                	mov    %edx,(%eax)
  803041:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803044:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803047:	89 50 04             	mov    %edx,0x4(%eax)
  80304a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80304d:	8b 00                	mov    (%eax),%eax
  80304f:	85 c0                	test   %eax,%eax
  803051:	75 08                	jne    80305b <realloc_block_FF+0x199>
  803053:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803056:	a3 30 50 80 00       	mov    %eax,0x805030
  80305b:	a1 38 50 80 00       	mov    0x805038,%eax
  803060:	40                   	inc    %eax
  803061:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803066:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80306a:	75 17                	jne    803083 <realloc_block_FF+0x1c1>
  80306c:	83 ec 04             	sub    $0x4,%esp
  80306f:	68 8f 40 80 00       	push   $0x80408f
  803074:	68 f7 01 00 00       	push   $0x1f7
  803079:	68 ad 40 80 00       	push   $0x8040ad
  80307e:	e8 94 05 00 00       	call   803617 <_panic>
  803083:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	85 c0                	test   %eax,%eax
  80308a:	74 10                	je     80309c <realloc_block_FF+0x1da>
  80308c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803094:	8b 52 04             	mov    0x4(%edx),%edx
  803097:	89 50 04             	mov    %edx,0x4(%eax)
  80309a:	eb 0b                	jmp    8030a7 <realloc_block_FF+0x1e5>
  80309c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309f:	8b 40 04             	mov    0x4(%eax),%eax
  8030a2:	a3 30 50 80 00       	mov    %eax,0x805030
  8030a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030aa:	8b 40 04             	mov    0x4(%eax),%eax
  8030ad:	85 c0                	test   %eax,%eax
  8030af:	74 0f                	je     8030c0 <realloc_block_FF+0x1fe>
  8030b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b4:	8b 40 04             	mov    0x4(%eax),%eax
  8030b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ba:	8b 12                	mov    (%edx),%edx
  8030bc:	89 10                	mov    %edx,(%eax)
  8030be:	eb 0a                	jmp    8030ca <realloc_block_FF+0x208>
  8030c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8030ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8030e2:	48                   	dec    %eax
  8030e3:	a3 38 50 80 00       	mov    %eax,0x805038
  8030e8:	e9 83 02 00 00       	jmp    803370 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8030ed:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8030f1:	0f 86 69 02 00 00    	jbe    803360 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8030f7:	83 ec 04             	sub    $0x4,%esp
  8030fa:	6a 01                	push   $0x1
  8030fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8030ff:	ff 75 08             	pushl  0x8(%ebp)
  803102:	e8 c8 ed ff ff       	call   801ecf <set_block_data>
  803107:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	83 e8 04             	sub    $0x4,%eax
  803110:	8b 00                	mov    (%eax),%eax
  803112:	83 e0 fe             	and    $0xfffffffe,%eax
  803115:	89 c2                	mov    %eax,%edx
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	01 d0                	add    %edx,%eax
  80311c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80311f:	a1 38 50 80 00       	mov    0x805038,%eax
  803124:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803127:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80312b:	75 68                	jne    803195 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80312d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803131:	75 17                	jne    80314a <realloc_block_FF+0x288>
  803133:	83 ec 04             	sub    $0x4,%esp
  803136:	68 c8 40 80 00       	push   $0x8040c8
  80313b:	68 06 02 00 00       	push   $0x206
  803140:	68 ad 40 80 00       	push   $0x8040ad
  803145:	e8 cd 04 00 00       	call   803617 <_panic>
  80314a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803150:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803153:	89 10                	mov    %edx,(%eax)
  803155:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	85 c0                	test   %eax,%eax
  80315c:	74 0d                	je     80316b <realloc_block_FF+0x2a9>
  80315e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803163:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803166:	89 50 04             	mov    %edx,0x4(%eax)
  803169:	eb 08                	jmp    803173 <realloc_block_FF+0x2b1>
  80316b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80316e:	a3 30 50 80 00       	mov    %eax,0x805030
  803173:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803176:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80317b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80317e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803185:	a1 38 50 80 00       	mov    0x805038,%eax
  80318a:	40                   	inc    %eax
  80318b:	a3 38 50 80 00       	mov    %eax,0x805038
  803190:	e9 b0 01 00 00       	jmp    803345 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803195:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80319a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80319d:	76 68                	jbe    803207 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80319f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031a3:	75 17                	jne    8031bc <realloc_block_FF+0x2fa>
  8031a5:	83 ec 04             	sub    $0x4,%esp
  8031a8:	68 c8 40 80 00       	push   $0x8040c8
  8031ad:	68 0b 02 00 00       	push   $0x20b
  8031b2:	68 ad 40 80 00       	push   $0x8040ad
  8031b7:	e8 5b 04 00 00       	call   803617 <_panic>
  8031bc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031c5:	89 10                	mov    %edx,(%eax)
  8031c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	85 c0                	test   %eax,%eax
  8031ce:	74 0d                	je     8031dd <realloc_block_FF+0x31b>
  8031d0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031d8:	89 50 04             	mov    %edx,0x4(%eax)
  8031db:	eb 08                	jmp    8031e5 <realloc_block_FF+0x323>
  8031dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8031e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f7:	a1 38 50 80 00       	mov    0x805038,%eax
  8031fc:	40                   	inc    %eax
  8031fd:	a3 38 50 80 00       	mov    %eax,0x805038
  803202:	e9 3e 01 00 00       	jmp    803345 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803207:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80320c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80320f:	73 68                	jae    803279 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803211:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803215:	75 17                	jne    80322e <realloc_block_FF+0x36c>
  803217:	83 ec 04             	sub    $0x4,%esp
  80321a:	68 fc 40 80 00       	push   $0x8040fc
  80321f:	68 10 02 00 00       	push   $0x210
  803224:	68 ad 40 80 00       	push   $0x8040ad
  803229:	e8 e9 03 00 00       	call   803617 <_panic>
  80322e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803234:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803237:	89 50 04             	mov    %edx,0x4(%eax)
  80323a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80323d:	8b 40 04             	mov    0x4(%eax),%eax
  803240:	85 c0                	test   %eax,%eax
  803242:	74 0c                	je     803250 <realloc_block_FF+0x38e>
  803244:	a1 30 50 80 00       	mov    0x805030,%eax
  803249:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80324c:	89 10                	mov    %edx,(%eax)
  80324e:	eb 08                	jmp    803258 <realloc_block_FF+0x396>
  803250:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803253:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803258:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80325b:	a3 30 50 80 00       	mov    %eax,0x805030
  803260:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803263:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803269:	a1 38 50 80 00       	mov    0x805038,%eax
  80326e:	40                   	inc    %eax
  80326f:	a3 38 50 80 00       	mov    %eax,0x805038
  803274:	e9 cc 00 00 00       	jmp    803345 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803279:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803280:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803285:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803288:	e9 8a 00 00 00       	jmp    803317 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803293:	73 7a                	jae    80330f <realloc_block_FF+0x44d>
  803295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803298:	8b 00                	mov    (%eax),%eax
  80329a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80329d:	73 70                	jae    80330f <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80329f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a3:	74 06                	je     8032ab <realloc_block_FF+0x3e9>
  8032a5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032a9:	75 17                	jne    8032c2 <realloc_block_FF+0x400>
  8032ab:	83 ec 04             	sub    $0x4,%esp
  8032ae:	68 20 41 80 00       	push   $0x804120
  8032b3:	68 1a 02 00 00       	push   $0x21a
  8032b8:	68 ad 40 80 00       	push   $0x8040ad
  8032bd:	e8 55 03 00 00       	call   803617 <_panic>
  8032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c5:	8b 10                	mov    (%eax),%edx
  8032c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ca:	89 10                	mov    %edx,(%eax)
  8032cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032cf:	8b 00                	mov    (%eax),%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	74 0b                	je     8032e0 <realloc_block_FF+0x41e>
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	8b 00                	mov    (%eax),%eax
  8032da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032dd:	89 50 04             	mov    %edx,0x4(%eax)
  8032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032e6:	89 10                	mov    %edx,(%eax)
  8032e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ee:	89 50 04             	mov    %edx,0x4(%eax)
  8032f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	85 c0                	test   %eax,%eax
  8032f8:	75 08                	jne    803302 <realloc_block_FF+0x440>
  8032fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032fd:	a3 30 50 80 00       	mov    %eax,0x805030
  803302:	a1 38 50 80 00       	mov    0x805038,%eax
  803307:	40                   	inc    %eax
  803308:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80330d:	eb 36                	jmp    803345 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80330f:	a1 34 50 80 00       	mov    0x805034,%eax
  803314:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80331b:	74 07                	je     803324 <realloc_block_FF+0x462>
  80331d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803320:	8b 00                	mov    (%eax),%eax
  803322:	eb 05                	jmp    803329 <realloc_block_FF+0x467>
  803324:	b8 00 00 00 00       	mov    $0x0,%eax
  803329:	a3 34 50 80 00       	mov    %eax,0x805034
  80332e:	a1 34 50 80 00       	mov    0x805034,%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	0f 85 52 ff ff ff    	jne    80328d <realloc_block_FF+0x3cb>
  80333b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80333f:	0f 85 48 ff ff ff    	jne    80328d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	6a 00                	push   $0x0
  80334a:	ff 75 d8             	pushl  -0x28(%ebp)
  80334d:	ff 75 d4             	pushl  -0x2c(%ebp)
  803350:	e8 7a eb ff ff       	call   801ecf <set_block_data>
  803355:	83 c4 10             	add    $0x10,%esp
				return va;
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	e9 7b 02 00 00       	jmp    8035db <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803360:	83 ec 0c             	sub    $0xc,%esp
  803363:	68 9d 41 80 00       	push   $0x80419d
  803368:	e8 de cf ff ff       	call   80034b <cprintf>
  80336d:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803370:	8b 45 08             	mov    0x8(%ebp),%eax
  803373:	e9 63 02 00 00       	jmp    8035db <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80337b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80337e:	0f 86 4d 02 00 00    	jbe    8035d1 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803384:	83 ec 0c             	sub    $0xc,%esp
  803387:	ff 75 e4             	pushl  -0x1c(%ebp)
  80338a:	e8 08 e8 ff ff       	call   801b97 <is_free_block>
  80338f:	83 c4 10             	add    $0x10,%esp
  803392:	84 c0                	test   %al,%al
  803394:	0f 84 37 02 00 00    	je     8035d1 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80339a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80339d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8033a0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8033a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8033a6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033a9:	76 38                	jbe    8033e3 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8033ab:	83 ec 0c             	sub    $0xc,%esp
  8033ae:	ff 75 08             	pushl  0x8(%ebp)
  8033b1:	e8 0c fa ff ff       	call   802dc2 <free_block>
  8033b6:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8033b9:	83 ec 0c             	sub    $0xc,%esp
  8033bc:	ff 75 0c             	pushl  0xc(%ebp)
  8033bf:	e8 3a eb ff ff       	call   801efe <alloc_block_FF>
  8033c4:	83 c4 10             	add    $0x10,%esp
  8033c7:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8033ca:	83 ec 08             	sub    $0x8,%esp
  8033cd:	ff 75 c0             	pushl  -0x40(%ebp)
  8033d0:	ff 75 08             	pushl  0x8(%ebp)
  8033d3:	e8 ab fa ff ff       	call   802e83 <copy_data>
  8033d8:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8033db:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8033de:	e9 f8 01 00 00       	jmp    8035db <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8033e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e6:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8033e9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8033ec:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8033f0:	0f 87 a0 00 00 00    	ja     803496 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8033f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033fa:	75 17                	jne    803413 <realloc_block_FF+0x551>
  8033fc:	83 ec 04             	sub    $0x4,%esp
  8033ff:	68 8f 40 80 00       	push   $0x80408f
  803404:	68 38 02 00 00       	push   $0x238
  803409:	68 ad 40 80 00       	push   $0x8040ad
  80340e:	e8 04 02 00 00       	call   803617 <_panic>
  803413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803416:	8b 00                	mov    (%eax),%eax
  803418:	85 c0                	test   %eax,%eax
  80341a:	74 10                	je     80342c <realloc_block_FF+0x56a>
  80341c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341f:	8b 00                	mov    (%eax),%eax
  803421:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803424:	8b 52 04             	mov    0x4(%edx),%edx
  803427:	89 50 04             	mov    %edx,0x4(%eax)
  80342a:	eb 0b                	jmp    803437 <realloc_block_FF+0x575>
  80342c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342f:	8b 40 04             	mov    0x4(%eax),%eax
  803432:	a3 30 50 80 00       	mov    %eax,0x805030
  803437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343a:	8b 40 04             	mov    0x4(%eax),%eax
  80343d:	85 c0                	test   %eax,%eax
  80343f:	74 0f                	je     803450 <realloc_block_FF+0x58e>
  803441:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803444:	8b 40 04             	mov    0x4(%eax),%eax
  803447:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80344a:	8b 12                	mov    (%edx),%edx
  80344c:	89 10                	mov    %edx,(%eax)
  80344e:	eb 0a                	jmp    80345a <realloc_block_FF+0x598>
  803450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803453:	8b 00                	mov    (%eax),%eax
  803455:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80345a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803466:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346d:	a1 38 50 80 00       	mov    0x805038,%eax
  803472:	48                   	dec    %eax
  803473:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803478:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80347b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80347e:	01 d0                	add    %edx,%eax
  803480:	83 ec 04             	sub    $0x4,%esp
  803483:	6a 01                	push   $0x1
  803485:	50                   	push   %eax
  803486:	ff 75 08             	pushl  0x8(%ebp)
  803489:	e8 41 ea ff ff       	call   801ecf <set_block_data>
  80348e:	83 c4 10             	add    $0x10,%esp
  803491:	e9 36 01 00 00       	jmp    8035cc <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803496:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803499:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80349c:	01 d0                	add    %edx,%eax
  80349e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8034a1:	83 ec 04             	sub    $0x4,%esp
  8034a4:	6a 01                	push   $0x1
  8034a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8034a9:	ff 75 08             	pushl  0x8(%ebp)
  8034ac:	e8 1e ea ff ff       	call   801ecf <set_block_data>
  8034b1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b7:	83 e8 04             	sub    $0x4,%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	83 e0 fe             	and    $0xfffffffe,%eax
  8034bf:	89 c2                	mov    %eax,%edx
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	01 d0                	add    %edx,%eax
  8034c6:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8034c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034cd:	74 06                	je     8034d5 <realloc_block_FF+0x613>
  8034cf:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8034d3:	75 17                	jne    8034ec <realloc_block_FF+0x62a>
  8034d5:	83 ec 04             	sub    $0x4,%esp
  8034d8:	68 20 41 80 00       	push   $0x804120
  8034dd:	68 44 02 00 00       	push   $0x244
  8034e2:	68 ad 40 80 00       	push   $0x8040ad
  8034e7:	e8 2b 01 00 00       	call   803617 <_panic>
  8034ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ef:	8b 10                	mov    (%eax),%edx
  8034f1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8034f4:	89 10                	mov    %edx,(%eax)
  8034f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8034f9:	8b 00                	mov    (%eax),%eax
  8034fb:	85 c0                	test   %eax,%eax
  8034fd:	74 0b                	je     80350a <realloc_block_FF+0x648>
  8034ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803502:	8b 00                	mov    (%eax),%eax
  803504:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803507:	89 50 04             	mov    %edx,0x4(%eax)
  80350a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803510:	89 10                	mov    %edx,(%eax)
  803512:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803515:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803518:	89 50 04             	mov    %edx,0x4(%eax)
  80351b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80351e:	8b 00                	mov    (%eax),%eax
  803520:	85 c0                	test   %eax,%eax
  803522:	75 08                	jne    80352c <realloc_block_FF+0x66a>
  803524:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803527:	a3 30 50 80 00       	mov    %eax,0x805030
  80352c:	a1 38 50 80 00       	mov    0x805038,%eax
  803531:	40                   	inc    %eax
  803532:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803537:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80353b:	75 17                	jne    803554 <realloc_block_FF+0x692>
  80353d:	83 ec 04             	sub    $0x4,%esp
  803540:	68 8f 40 80 00       	push   $0x80408f
  803545:	68 45 02 00 00       	push   $0x245
  80354a:	68 ad 40 80 00       	push   $0x8040ad
  80354f:	e8 c3 00 00 00       	call   803617 <_panic>
  803554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803557:	8b 00                	mov    (%eax),%eax
  803559:	85 c0                	test   %eax,%eax
  80355b:	74 10                	je     80356d <realloc_block_FF+0x6ab>
  80355d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803560:	8b 00                	mov    (%eax),%eax
  803562:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803565:	8b 52 04             	mov    0x4(%edx),%edx
  803568:	89 50 04             	mov    %edx,0x4(%eax)
  80356b:	eb 0b                	jmp    803578 <realloc_block_FF+0x6b6>
  80356d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803570:	8b 40 04             	mov    0x4(%eax),%eax
  803573:	a3 30 50 80 00       	mov    %eax,0x805030
  803578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357b:	8b 40 04             	mov    0x4(%eax),%eax
  80357e:	85 c0                	test   %eax,%eax
  803580:	74 0f                	je     803591 <realloc_block_FF+0x6cf>
  803582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803585:	8b 40 04             	mov    0x4(%eax),%eax
  803588:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80358b:	8b 12                	mov    (%edx),%edx
  80358d:	89 10                	mov    %edx,(%eax)
  80358f:	eb 0a                	jmp    80359b <realloc_block_FF+0x6d9>
  803591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803594:	8b 00                	mov    (%eax),%eax
  803596:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80359b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8035b3:	48                   	dec    %eax
  8035b4:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8035b9:	83 ec 04             	sub    $0x4,%esp
  8035bc:	6a 00                	push   $0x0
  8035be:	ff 75 bc             	pushl  -0x44(%ebp)
  8035c1:	ff 75 b8             	pushl  -0x48(%ebp)
  8035c4:	e8 06 e9 ff ff       	call   801ecf <set_block_data>
  8035c9:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8035cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cf:	eb 0a                	jmp    8035db <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8035d1:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8035d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8035db:	c9                   	leave  
  8035dc:	c3                   	ret    

008035dd <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8035dd:	55                   	push   %ebp
  8035de:	89 e5                	mov    %esp,%ebp
  8035e0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8035e3:	83 ec 04             	sub    $0x4,%esp
  8035e6:	68 a4 41 80 00       	push   $0x8041a4
  8035eb:	68 58 02 00 00       	push   $0x258
  8035f0:	68 ad 40 80 00       	push   $0x8040ad
  8035f5:	e8 1d 00 00 00       	call   803617 <_panic>

008035fa <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8035fa:	55                   	push   %ebp
  8035fb:	89 e5                	mov    %esp,%ebp
  8035fd:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803600:	83 ec 04             	sub    $0x4,%esp
  803603:	68 cc 41 80 00       	push   $0x8041cc
  803608:	68 61 02 00 00       	push   $0x261
  80360d:	68 ad 40 80 00       	push   $0x8040ad
  803612:	e8 00 00 00 00       	call   803617 <_panic>

00803617 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803617:	55                   	push   %ebp
  803618:	89 e5                	mov    %esp,%ebp
  80361a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80361d:	8d 45 10             	lea    0x10(%ebp),%eax
  803620:	83 c0 04             	add    $0x4,%eax
  803623:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803626:	a1 60 50 90 00       	mov    0x905060,%eax
  80362b:	85 c0                	test   %eax,%eax
  80362d:	74 16                	je     803645 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80362f:	a1 60 50 90 00       	mov    0x905060,%eax
  803634:	83 ec 08             	sub    $0x8,%esp
  803637:	50                   	push   %eax
  803638:	68 f4 41 80 00       	push   $0x8041f4
  80363d:	e8 09 cd ff ff       	call   80034b <cprintf>
  803642:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803645:	a1 00 50 80 00       	mov    0x805000,%eax
  80364a:	ff 75 0c             	pushl  0xc(%ebp)
  80364d:	ff 75 08             	pushl  0x8(%ebp)
  803650:	50                   	push   %eax
  803651:	68 f9 41 80 00       	push   $0x8041f9
  803656:	e8 f0 cc ff ff       	call   80034b <cprintf>
  80365b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80365e:	8b 45 10             	mov    0x10(%ebp),%eax
  803661:	83 ec 08             	sub    $0x8,%esp
  803664:	ff 75 f4             	pushl  -0xc(%ebp)
  803667:	50                   	push   %eax
  803668:	e8 73 cc ff ff       	call   8002e0 <vcprintf>
  80366d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803670:	83 ec 08             	sub    $0x8,%esp
  803673:	6a 00                	push   $0x0
  803675:	68 15 42 80 00       	push   $0x804215
  80367a:	e8 61 cc ff ff       	call   8002e0 <vcprintf>
  80367f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803682:	e8 e2 cb ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  803687:	eb fe                	jmp    803687 <_panic+0x70>

00803689 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803689:	55                   	push   %ebp
  80368a:	89 e5                	mov    %esp,%ebp
  80368c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80368f:	a1 20 50 80 00       	mov    0x805020,%eax
  803694:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80369a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369d:	39 c2                	cmp    %eax,%edx
  80369f:	74 14                	je     8036b5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8036a1:	83 ec 04             	sub    $0x4,%esp
  8036a4:	68 18 42 80 00       	push   $0x804218
  8036a9:	6a 26                	push   $0x26
  8036ab:	68 64 42 80 00       	push   $0x804264
  8036b0:	e8 62 ff ff ff       	call   803617 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8036b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8036bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8036c3:	e9 c5 00 00 00       	jmp    80378d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8036c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8036d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d5:	01 d0                	add    %edx,%eax
  8036d7:	8b 00                	mov    (%eax),%eax
  8036d9:	85 c0                	test   %eax,%eax
  8036db:	75 08                	jne    8036e5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8036dd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8036e0:	e9 a5 00 00 00       	jmp    80378a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8036e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8036ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8036f3:	eb 69                	jmp    80375e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8036f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8036fa:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803700:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803703:	89 d0                	mov    %edx,%eax
  803705:	01 c0                	add    %eax,%eax
  803707:	01 d0                	add    %edx,%eax
  803709:	c1 e0 03             	shl    $0x3,%eax
  80370c:	01 c8                	add    %ecx,%eax
  80370e:	8a 40 04             	mov    0x4(%eax),%al
  803711:	84 c0                	test   %al,%al
  803713:	75 46                	jne    80375b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803715:	a1 20 50 80 00       	mov    0x805020,%eax
  80371a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803720:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803723:	89 d0                	mov    %edx,%eax
  803725:	01 c0                	add    %eax,%eax
  803727:	01 d0                	add    %edx,%eax
  803729:	c1 e0 03             	shl    $0x3,%eax
  80372c:	01 c8                	add    %ecx,%eax
  80372e:	8b 00                	mov    (%eax),%eax
  803730:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803733:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803736:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80373b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80373d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803740:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803747:	8b 45 08             	mov    0x8(%ebp),%eax
  80374a:	01 c8                	add    %ecx,%eax
  80374c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80374e:	39 c2                	cmp    %eax,%edx
  803750:	75 09                	jne    80375b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803752:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803759:	eb 15                	jmp    803770 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80375b:	ff 45 e8             	incl   -0x18(%ebp)
  80375e:	a1 20 50 80 00       	mov    0x805020,%eax
  803763:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803769:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376c:	39 c2                	cmp    %eax,%edx
  80376e:	77 85                	ja     8036f5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803770:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803774:	75 14                	jne    80378a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803776:	83 ec 04             	sub    $0x4,%esp
  803779:	68 70 42 80 00       	push   $0x804270
  80377e:	6a 3a                	push   $0x3a
  803780:	68 64 42 80 00       	push   $0x804264
  803785:	e8 8d fe ff ff       	call   803617 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80378a:	ff 45 f0             	incl   -0x10(%ebp)
  80378d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803790:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803793:	0f 8c 2f ff ff ff    	jl     8036c8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803799:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8037a7:	eb 26                	jmp    8037cf <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8037a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8037ae:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8037b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037b7:	89 d0                	mov    %edx,%eax
  8037b9:	01 c0                	add    %eax,%eax
  8037bb:	01 d0                	add    %edx,%eax
  8037bd:	c1 e0 03             	shl    $0x3,%eax
  8037c0:	01 c8                	add    %ecx,%eax
  8037c2:	8a 40 04             	mov    0x4(%eax),%al
  8037c5:	3c 01                	cmp    $0x1,%al
  8037c7:	75 03                	jne    8037cc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8037c9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037cc:	ff 45 e0             	incl   -0x20(%ebp)
  8037cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8037d4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8037da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037dd:	39 c2                	cmp    %eax,%edx
  8037df:	77 c8                	ja     8037a9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8037e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8037e7:	74 14                	je     8037fd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8037e9:	83 ec 04             	sub    $0x4,%esp
  8037ec:	68 c4 42 80 00       	push   $0x8042c4
  8037f1:	6a 44                	push   $0x44
  8037f3:	68 64 42 80 00       	push   $0x804264
  8037f8:	e8 1a fe ff ff       	call   803617 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8037fd:	90                   	nop
  8037fe:	c9                   	leave  
  8037ff:	c3                   	ret    

00803800 <__udivdi3>:
  803800:	55                   	push   %ebp
  803801:	57                   	push   %edi
  803802:	56                   	push   %esi
  803803:	53                   	push   %ebx
  803804:	83 ec 1c             	sub    $0x1c,%esp
  803807:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80380b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80380f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803813:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803817:	89 ca                	mov    %ecx,%edx
  803819:	89 f8                	mov    %edi,%eax
  80381b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80381f:	85 f6                	test   %esi,%esi
  803821:	75 2d                	jne    803850 <__udivdi3+0x50>
  803823:	39 cf                	cmp    %ecx,%edi
  803825:	77 65                	ja     80388c <__udivdi3+0x8c>
  803827:	89 fd                	mov    %edi,%ebp
  803829:	85 ff                	test   %edi,%edi
  80382b:	75 0b                	jne    803838 <__udivdi3+0x38>
  80382d:	b8 01 00 00 00       	mov    $0x1,%eax
  803832:	31 d2                	xor    %edx,%edx
  803834:	f7 f7                	div    %edi
  803836:	89 c5                	mov    %eax,%ebp
  803838:	31 d2                	xor    %edx,%edx
  80383a:	89 c8                	mov    %ecx,%eax
  80383c:	f7 f5                	div    %ebp
  80383e:	89 c1                	mov    %eax,%ecx
  803840:	89 d8                	mov    %ebx,%eax
  803842:	f7 f5                	div    %ebp
  803844:	89 cf                	mov    %ecx,%edi
  803846:	89 fa                	mov    %edi,%edx
  803848:	83 c4 1c             	add    $0x1c,%esp
  80384b:	5b                   	pop    %ebx
  80384c:	5e                   	pop    %esi
  80384d:	5f                   	pop    %edi
  80384e:	5d                   	pop    %ebp
  80384f:	c3                   	ret    
  803850:	39 ce                	cmp    %ecx,%esi
  803852:	77 28                	ja     80387c <__udivdi3+0x7c>
  803854:	0f bd fe             	bsr    %esi,%edi
  803857:	83 f7 1f             	xor    $0x1f,%edi
  80385a:	75 40                	jne    80389c <__udivdi3+0x9c>
  80385c:	39 ce                	cmp    %ecx,%esi
  80385e:	72 0a                	jb     80386a <__udivdi3+0x6a>
  803860:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803864:	0f 87 9e 00 00 00    	ja     803908 <__udivdi3+0x108>
  80386a:	b8 01 00 00 00       	mov    $0x1,%eax
  80386f:	89 fa                	mov    %edi,%edx
  803871:	83 c4 1c             	add    $0x1c,%esp
  803874:	5b                   	pop    %ebx
  803875:	5e                   	pop    %esi
  803876:	5f                   	pop    %edi
  803877:	5d                   	pop    %ebp
  803878:	c3                   	ret    
  803879:	8d 76 00             	lea    0x0(%esi),%esi
  80387c:	31 ff                	xor    %edi,%edi
  80387e:	31 c0                	xor    %eax,%eax
  803880:	89 fa                	mov    %edi,%edx
  803882:	83 c4 1c             	add    $0x1c,%esp
  803885:	5b                   	pop    %ebx
  803886:	5e                   	pop    %esi
  803887:	5f                   	pop    %edi
  803888:	5d                   	pop    %ebp
  803889:	c3                   	ret    
  80388a:	66 90                	xchg   %ax,%ax
  80388c:	89 d8                	mov    %ebx,%eax
  80388e:	f7 f7                	div    %edi
  803890:	31 ff                	xor    %edi,%edi
  803892:	89 fa                	mov    %edi,%edx
  803894:	83 c4 1c             	add    $0x1c,%esp
  803897:	5b                   	pop    %ebx
  803898:	5e                   	pop    %esi
  803899:	5f                   	pop    %edi
  80389a:	5d                   	pop    %ebp
  80389b:	c3                   	ret    
  80389c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038a1:	89 eb                	mov    %ebp,%ebx
  8038a3:	29 fb                	sub    %edi,%ebx
  8038a5:	89 f9                	mov    %edi,%ecx
  8038a7:	d3 e6                	shl    %cl,%esi
  8038a9:	89 c5                	mov    %eax,%ebp
  8038ab:	88 d9                	mov    %bl,%cl
  8038ad:	d3 ed                	shr    %cl,%ebp
  8038af:	89 e9                	mov    %ebp,%ecx
  8038b1:	09 f1                	or     %esi,%ecx
  8038b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038b7:	89 f9                	mov    %edi,%ecx
  8038b9:	d3 e0                	shl    %cl,%eax
  8038bb:	89 c5                	mov    %eax,%ebp
  8038bd:	89 d6                	mov    %edx,%esi
  8038bf:	88 d9                	mov    %bl,%cl
  8038c1:	d3 ee                	shr    %cl,%esi
  8038c3:	89 f9                	mov    %edi,%ecx
  8038c5:	d3 e2                	shl    %cl,%edx
  8038c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038cb:	88 d9                	mov    %bl,%cl
  8038cd:	d3 e8                	shr    %cl,%eax
  8038cf:	09 c2                	or     %eax,%edx
  8038d1:	89 d0                	mov    %edx,%eax
  8038d3:	89 f2                	mov    %esi,%edx
  8038d5:	f7 74 24 0c          	divl   0xc(%esp)
  8038d9:	89 d6                	mov    %edx,%esi
  8038db:	89 c3                	mov    %eax,%ebx
  8038dd:	f7 e5                	mul    %ebp
  8038df:	39 d6                	cmp    %edx,%esi
  8038e1:	72 19                	jb     8038fc <__udivdi3+0xfc>
  8038e3:	74 0b                	je     8038f0 <__udivdi3+0xf0>
  8038e5:	89 d8                	mov    %ebx,%eax
  8038e7:	31 ff                	xor    %edi,%edi
  8038e9:	e9 58 ff ff ff       	jmp    803846 <__udivdi3+0x46>
  8038ee:	66 90                	xchg   %ax,%ax
  8038f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038f4:	89 f9                	mov    %edi,%ecx
  8038f6:	d3 e2                	shl    %cl,%edx
  8038f8:	39 c2                	cmp    %eax,%edx
  8038fa:	73 e9                	jae    8038e5 <__udivdi3+0xe5>
  8038fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038ff:	31 ff                	xor    %edi,%edi
  803901:	e9 40 ff ff ff       	jmp    803846 <__udivdi3+0x46>
  803906:	66 90                	xchg   %ax,%ax
  803908:	31 c0                	xor    %eax,%eax
  80390a:	e9 37 ff ff ff       	jmp    803846 <__udivdi3+0x46>
  80390f:	90                   	nop

00803910 <__umoddi3>:
  803910:	55                   	push   %ebp
  803911:	57                   	push   %edi
  803912:	56                   	push   %esi
  803913:	53                   	push   %ebx
  803914:	83 ec 1c             	sub    $0x1c,%esp
  803917:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80391b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80391f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803923:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803927:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80392b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80392f:	89 f3                	mov    %esi,%ebx
  803931:	89 fa                	mov    %edi,%edx
  803933:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803937:	89 34 24             	mov    %esi,(%esp)
  80393a:	85 c0                	test   %eax,%eax
  80393c:	75 1a                	jne    803958 <__umoddi3+0x48>
  80393e:	39 f7                	cmp    %esi,%edi
  803940:	0f 86 a2 00 00 00    	jbe    8039e8 <__umoddi3+0xd8>
  803946:	89 c8                	mov    %ecx,%eax
  803948:	89 f2                	mov    %esi,%edx
  80394a:	f7 f7                	div    %edi
  80394c:	89 d0                	mov    %edx,%eax
  80394e:	31 d2                	xor    %edx,%edx
  803950:	83 c4 1c             	add    $0x1c,%esp
  803953:	5b                   	pop    %ebx
  803954:	5e                   	pop    %esi
  803955:	5f                   	pop    %edi
  803956:	5d                   	pop    %ebp
  803957:	c3                   	ret    
  803958:	39 f0                	cmp    %esi,%eax
  80395a:	0f 87 ac 00 00 00    	ja     803a0c <__umoddi3+0xfc>
  803960:	0f bd e8             	bsr    %eax,%ebp
  803963:	83 f5 1f             	xor    $0x1f,%ebp
  803966:	0f 84 ac 00 00 00    	je     803a18 <__umoddi3+0x108>
  80396c:	bf 20 00 00 00       	mov    $0x20,%edi
  803971:	29 ef                	sub    %ebp,%edi
  803973:	89 fe                	mov    %edi,%esi
  803975:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803979:	89 e9                	mov    %ebp,%ecx
  80397b:	d3 e0                	shl    %cl,%eax
  80397d:	89 d7                	mov    %edx,%edi
  80397f:	89 f1                	mov    %esi,%ecx
  803981:	d3 ef                	shr    %cl,%edi
  803983:	09 c7                	or     %eax,%edi
  803985:	89 e9                	mov    %ebp,%ecx
  803987:	d3 e2                	shl    %cl,%edx
  803989:	89 14 24             	mov    %edx,(%esp)
  80398c:	89 d8                	mov    %ebx,%eax
  80398e:	d3 e0                	shl    %cl,%eax
  803990:	89 c2                	mov    %eax,%edx
  803992:	8b 44 24 08          	mov    0x8(%esp),%eax
  803996:	d3 e0                	shl    %cl,%eax
  803998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80399c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039a0:	89 f1                	mov    %esi,%ecx
  8039a2:	d3 e8                	shr    %cl,%eax
  8039a4:	09 d0                	or     %edx,%eax
  8039a6:	d3 eb                	shr    %cl,%ebx
  8039a8:	89 da                	mov    %ebx,%edx
  8039aa:	f7 f7                	div    %edi
  8039ac:	89 d3                	mov    %edx,%ebx
  8039ae:	f7 24 24             	mull   (%esp)
  8039b1:	89 c6                	mov    %eax,%esi
  8039b3:	89 d1                	mov    %edx,%ecx
  8039b5:	39 d3                	cmp    %edx,%ebx
  8039b7:	0f 82 87 00 00 00    	jb     803a44 <__umoddi3+0x134>
  8039bd:	0f 84 91 00 00 00    	je     803a54 <__umoddi3+0x144>
  8039c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039c7:	29 f2                	sub    %esi,%edx
  8039c9:	19 cb                	sbb    %ecx,%ebx
  8039cb:	89 d8                	mov    %ebx,%eax
  8039cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039d1:	d3 e0                	shl    %cl,%eax
  8039d3:	89 e9                	mov    %ebp,%ecx
  8039d5:	d3 ea                	shr    %cl,%edx
  8039d7:	09 d0                	or     %edx,%eax
  8039d9:	89 e9                	mov    %ebp,%ecx
  8039db:	d3 eb                	shr    %cl,%ebx
  8039dd:	89 da                	mov    %ebx,%edx
  8039df:	83 c4 1c             	add    $0x1c,%esp
  8039e2:	5b                   	pop    %ebx
  8039e3:	5e                   	pop    %esi
  8039e4:	5f                   	pop    %edi
  8039e5:	5d                   	pop    %ebp
  8039e6:	c3                   	ret    
  8039e7:	90                   	nop
  8039e8:	89 fd                	mov    %edi,%ebp
  8039ea:	85 ff                	test   %edi,%edi
  8039ec:	75 0b                	jne    8039f9 <__umoddi3+0xe9>
  8039ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8039f3:	31 d2                	xor    %edx,%edx
  8039f5:	f7 f7                	div    %edi
  8039f7:	89 c5                	mov    %eax,%ebp
  8039f9:	89 f0                	mov    %esi,%eax
  8039fb:	31 d2                	xor    %edx,%edx
  8039fd:	f7 f5                	div    %ebp
  8039ff:	89 c8                	mov    %ecx,%eax
  803a01:	f7 f5                	div    %ebp
  803a03:	89 d0                	mov    %edx,%eax
  803a05:	e9 44 ff ff ff       	jmp    80394e <__umoddi3+0x3e>
  803a0a:	66 90                	xchg   %ax,%ax
  803a0c:	89 c8                	mov    %ecx,%eax
  803a0e:	89 f2                	mov    %esi,%edx
  803a10:	83 c4 1c             	add    $0x1c,%esp
  803a13:	5b                   	pop    %ebx
  803a14:	5e                   	pop    %esi
  803a15:	5f                   	pop    %edi
  803a16:	5d                   	pop    %ebp
  803a17:	c3                   	ret    
  803a18:	3b 04 24             	cmp    (%esp),%eax
  803a1b:	72 06                	jb     803a23 <__umoddi3+0x113>
  803a1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a21:	77 0f                	ja     803a32 <__umoddi3+0x122>
  803a23:	89 f2                	mov    %esi,%edx
  803a25:	29 f9                	sub    %edi,%ecx
  803a27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a2b:	89 14 24             	mov    %edx,(%esp)
  803a2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a32:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a36:	8b 14 24             	mov    (%esp),%edx
  803a39:	83 c4 1c             	add    $0x1c,%esp
  803a3c:	5b                   	pop    %ebx
  803a3d:	5e                   	pop    %esi
  803a3e:	5f                   	pop    %edi
  803a3f:	5d                   	pop    %ebp
  803a40:	c3                   	ret    
  803a41:	8d 76 00             	lea    0x0(%esi),%esi
  803a44:	2b 04 24             	sub    (%esp),%eax
  803a47:	19 fa                	sbb    %edi,%edx
  803a49:	89 d1                	mov    %edx,%ecx
  803a4b:	89 c6                	mov    %eax,%esi
  803a4d:	e9 71 ff ff ff       	jmp    8039c3 <__umoddi3+0xb3>
  803a52:	66 90                	xchg   %ax,%ax
  803a54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a58:	72 ea                	jb     803a44 <__umoddi3+0x134>
  803a5a:	89 d9                	mov    %ebx,%ecx
  803a5c:	e9 62 ff ff ff       	jmp    8039c3 <__umoddi3+0xb3>
