
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
  80005c:	68 c0 3a 80 00       	push   $0x803ac0
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
  8000b9:	68 d3 3a 80 00       	push   $0x803ad3
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
  80010f:	68 d3 3a 80 00       	push   $0x803ad3
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
  80013e:	e8 53 17 00 00       	call   801896 <sys_getenvindex>
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
  8001ac:	e8 69 14 00 00       	call   80161a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 f8 3a 80 00       	push   $0x803af8
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
  8001dc:	68 20 3b 80 00       	push   $0x803b20
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
  80020d:	68 48 3b 80 00       	push   $0x803b48
  800212:	e8 34 01 00 00       	call   80034b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 a0 3b 80 00       	push   $0x803ba0
  80022e:	e8 18 01 00 00       	call   80034b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 f8 3a 80 00       	push   $0x803af8
  80023e:	e8 08 01 00 00       	call   80034b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800246:	e8 e9 13 00 00       	call   801634 <sys_unlock_cons>
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
  80025e:	e8 ff 15 00 00       	call   801862 <sys_destroy_env>
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
  80026f:	e8 54 16 00 00       	call   8018c8 <sys_exit_env>
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
  8002bd:	e8 16 13 00 00       	call   8015d8 <sys_cputs>
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
  800334:	e8 9f 12 00 00       	call   8015d8 <sys_cputs>
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
  80037e:	e8 97 12 00 00       	call   80161a <sys_lock_cons>
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
  80039e:	e8 91 12 00 00       	call   801634 <sys_unlock_cons>
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
  8003e8:	e8 6b 34 00 00       	call   803858 <__udivdi3>
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
  800438:	e8 2b 35 00 00       	call   803968 <__umoddi3>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	05 d4 3d 80 00       	add    $0x803dd4,%eax
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
  800593:	8b 04 85 f8 3d 80 00 	mov    0x803df8(,%eax,4),%eax
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
  800674:	8b 34 9d 40 3c 80 00 	mov    0x803c40(,%ebx,4),%esi
  80067b:	85 f6                	test   %esi,%esi
  80067d:	75 19                	jne    800698 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067f:	53                   	push   %ebx
  800680:	68 e5 3d 80 00       	push   $0x803de5
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
  800699:	68 ee 3d 80 00       	push   $0x803dee
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
  8006c6:	be f1 3d 80 00       	mov    $0x803df1,%esi
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
  8010d1:	68 68 3f 80 00       	push   $0x803f68
  8010d6:	68 3f 01 00 00       	push   $0x13f
  8010db:	68 8a 3f 80 00       	push   $0x803f8a
  8010e0:	e8 8a 25 00 00       	call   80366f <_panic>

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
  8010f1:	e8 8d 0a 00 00       	call   801b83 <sys_sbrk>
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
  80116c:	e8 96 08 00 00       	call   801a07 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801171:	85 c0                	test   %eax,%eax
  801173:	74 16                	je     80118b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	ff 75 08             	pushl  0x8(%ebp)
  80117b:	e8 d6 0d 00 00       	call   801f56 <alloc_block_FF>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801186:	e9 8a 01 00 00       	jmp    801315 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80118b:	e8 a8 08 00 00       	call   801a38 <sys_isUHeapPlacementStrategyBESTFIT>
  801190:	85 c0                	test   %eax,%eax
  801192:	0f 84 7d 01 00 00    	je     801315 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801198:	83 ec 0c             	sub    $0xc,%esp
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	e8 6f 12 00 00       	call   802412 <alloc_block_BF>
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
  801304:	e8 b1 08 00 00       	call   801bba <sys_allocate_user_mem>
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
  80134c:	e8 85 08 00 00       	call   801bd6 <get_block_size>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 b8 1a 00 00       	call   802e1a <free_block>
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
  8013f4:	e8 a5 07 00 00       	call   801b9e <sys_free_user_mem>
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
  801402:	68 98 3f 80 00       	push   $0x803f98
  801407:	68 84 00 00 00       	push   $0x84
  80140c:	68 c2 3f 80 00       	push   $0x803fc2
  801411:	e8 59 22 00 00       	call   80366f <_panic>
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
  80142f:	eb 64                	jmp    801495 <smalloc+0x7d>
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
  801464:	eb 2f                	jmp    801495 <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801466:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80146a:	ff 75 ec             	pushl  -0x14(%ebp)
  80146d:	50                   	push   %eax
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	ff 75 08             	pushl  0x8(%ebp)
  801474:	e8 2c 03 00 00       	call   8017a5 <sys_createSharedObject>
  801479:	83 c4 10             	add    $0x10,%esp
  80147c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80147f:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801483:	74 06                	je     80148b <smalloc+0x73>
  801485:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801489:	75 07                	jne    801492 <smalloc+0x7a>
  80148b:	b8 00 00 00 00       	mov    $0x0,%eax
  801490:	eb 03                	jmp    801495 <smalloc+0x7d>
	 return ptr;
  801492:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	e8 24 03 00 00       	call   8017cf <sys_getSizeOfSharedObject>
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8014b1:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8014b5:	75 07                	jne    8014be <sget+0x27>
  8014b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bc:	eb 5c                	jmp    80151a <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8014be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014c4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8014cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d1:	39 d0                	cmp    %edx,%eax
  8014d3:	7d 02                	jge    8014d7 <sget+0x40>
  8014d5:	89 d0                	mov    %edx,%eax
  8014d7:	83 ec 0c             	sub    $0xc,%esp
  8014da:	50                   	push   %eax
  8014db:	e8 1b fc ff ff       	call   8010fb <malloc>
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8014e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014ea:	75 07                	jne    8014f3 <sget+0x5c>
  8014ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f1:	eb 27                	jmp    80151a <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	ff 75 e8             	pushl  -0x18(%ebp)
  8014f9:	ff 75 0c             	pushl  0xc(%ebp)
  8014fc:	ff 75 08             	pushl  0x8(%ebp)
  8014ff:	e8 e8 02 00 00       	call   8017ec <sys_getSharedObject>
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80150a:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80150e:	75 07                	jne    801517 <sget+0x80>
  801510:	b8 00 00 00 00       	mov    $0x0,%eax
  801515:	eb 03                	jmp    80151a <sget+0x83>
	return ptr;
  801517:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	68 d0 3f 80 00       	push   $0x803fd0
  80152a:	68 c1 00 00 00       	push   $0xc1
  80152f:	68 c2 3f 80 00       	push   $0x803fc2
  801534:	e8 36 21 00 00       	call   80366f <_panic>

00801539 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80153f:	83 ec 04             	sub    $0x4,%esp
  801542:	68 f4 3f 80 00       	push   $0x803ff4
  801547:	68 d8 00 00 00       	push   $0xd8
  80154c:	68 c2 3f 80 00       	push   $0x803fc2
  801551:	e8 19 21 00 00       	call   80366f <_panic>

00801556 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80155c:	83 ec 04             	sub    $0x4,%esp
  80155f:	68 1a 40 80 00       	push   $0x80401a
  801564:	68 e4 00 00 00       	push   $0xe4
  801569:	68 c2 3f 80 00       	push   $0x803fc2
  80156e:	e8 fc 20 00 00       	call   80366f <_panic>

00801573 <shrink>:

}
void shrink(uint32 newSize)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801579:	83 ec 04             	sub    $0x4,%esp
  80157c:	68 1a 40 80 00       	push   $0x80401a
  801581:	68 e9 00 00 00       	push   $0xe9
  801586:	68 c2 3f 80 00       	push   $0x803fc2
  80158b:	e8 df 20 00 00       	call   80366f <_panic>

00801590 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801596:	83 ec 04             	sub    $0x4,%esp
  801599:	68 1a 40 80 00       	push   $0x80401a
  80159e:	68 ee 00 00 00       	push   $0xee
  8015a3:	68 c2 3f 80 00       	push   $0x803fc2
  8015a8:	e8 c2 20 00 00       	call   80366f <_panic>

008015ad <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	57                   	push   %edi
  8015b1:	56                   	push   %esi
  8015b2:	53                   	push   %ebx
  8015b3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015c2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015c5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015c8:	cd 30                	int    $0x30
  8015ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015d0:	83 c4 10             	add    $0x10,%esp
  8015d3:	5b                   	pop    %ebx
  8015d4:	5e                   	pop    %esi
  8015d5:	5f                   	pop    %edi
  8015d6:	5d                   	pop    %ebp
  8015d7:	c3                   	ret    

008015d8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015e4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	52                   	push   %edx
  8015f0:	ff 75 0c             	pushl  0xc(%ebp)
  8015f3:	50                   	push   %eax
  8015f4:	6a 00                	push   $0x0
  8015f6:	e8 b2 ff ff ff       	call   8015ad <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
}
  8015fe:	90                   	nop
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <sys_cgetc>:

int
sys_cgetc(void)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 02                	push   $0x2
  801610:	e8 98 ff ff ff       	call   8015ad <syscall>
  801615:	83 c4 18             	add    $0x18,%esp
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 03                	push   $0x3
  801629:	e8 7f ff ff ff       	call   8015ad <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
}
  801631:	90                   	nop
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 04                	push   $0x4
  801643:	e8 65 ff ff ff       	call   8015ad <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	90                   	nop
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801651:	8b 55 0c             	mov    0xc(%ebp),%edx
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	52                   	push   %edx
  80165e:	50                   	push   %eax
  80165f:	6a 08                	push   $0x8
  801661:	e8 47 ff ff ff       	call   8015ad <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	56                   	push   %esi
  80166f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801670:	8b 75 18             	mov    0x18(%ebp),%esi
  801673:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801676:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	56                   	push   %esi
  801680:	53                   	push   %ebx
  801681:	51                   	push   %ecx
  801682:	52                   	push   %edx
  801683:	50                   	push   %eax
  801684:	6a 09                	push   $0x9
  801686:	e8 22 ff ff ff       	call   8015ad <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801691:	5b                   	pop    %ebx
  801692:	5e                   	pop    %esi
  801693:	5d                   	pop    %ebp
  801694:	c3                   	ret    

00801695 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	52                   	push   %edx
  8016a5:	50                   	push   %eax
  8016a6:	6a 0a                	push   $0xa
  8016a8:	e8 00 ff ff ff       	call   8015ad <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	ff 75 0c             	pushl  0xc(%ebp)
  8016be:	ff 75 08             	pushl  0x8(%ebp)
  8016c1:	6a 0b                	push   $0xb
  8016c3:	e8 e5 fe ff ff       	call   8015ad <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 0c                	push   $0xc
  8016dc:	e8 cc fe ff ff       	call   8015ad <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 0d                	push   $0xd
  8016f5:	e8 b3 fe ff ff       	call   8015ad <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 0e                	push   $0xe
  80170e:	e8 9a fe ff ff       	call   8015ad <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 0f                	push   $0xf
  801727:	e8 81 fe ff ff       	call   8015ad <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	c9                   	leave  
  801730:	c3                   	ret    

00801731 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	ff 75 08             	pushl  0x8(%ebp)
  80173f:	6a 10                	push   $0x10
  801741:	e8 67 fe ff ff       	call   8015ad <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 11                	push   $0x11
  80175a:	e8 4e fe ff ff       	call   8015ad <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	90                   	nop
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_cputc>:

void
sys_cputc(const char c)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801771:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	50                   	push   %eax
  80177e:	6a 01                	push   $0x1
  801780:	e8 28 fe ff ff       	call   8015ad <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	90                   	nop
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 14                	push   $0x14
  80179a:	e8 0e fe ff ff       	call   8015ad <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
}
  8017a2:	90                   	nop
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 04             	sub    $0x4,%esp
  8017ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017b1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017b4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	6a 00                	push   $0x0
  8017bd:	51                   	push   %ecx
  8017be:	52                   	push   %edx
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	50                   	push   %eax
  8017c3:	6a 15                	push   $0x15
  8017c5:	e8 e3 fd ff ff       	call   8015ad <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	52                   	push   %edx
  8017df:	50                   	push   %eax
  8017e0:	6a 16                	push   $0x16
  8017e2:	e8 c6 fd ff ff       	call   8015ad <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	51                   	push   %ecx
  8017fd:	52                   	push   %edx
  8017fe:	50                   	push   %eax
  8017ff:	6a 17                	push   $0x17
  801801:	e8 a7 fd ff ff       	call   8015ad <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80180e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	52                   	push   %edx
  80181b:	50                   	push   %eax
  80181c:	6a 18                	push   $0x18
  80181e:	e8 8a fd ff ff       	call   8015ad <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	6a 00                	push   $0x0
  801830:	ff 75 14             	pushl  0x14(%ebp)
  801833:	ff 75 10             	pushl  0x10(%ebp)
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	50                   	push   %eax
  80183a:	6a 19                	push   $0x19
  80183c:	e8 6c fd ff ff       	call   8015ad <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	50                   	push   %eax
  801855:	6a 1a                	push   $0x1a
  801857:	e8 51 fd ff ff       	call   8015ad <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	90                   	nop
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	50                   	push   %eax
  801871:	6a 1b                	push   $0x1b
  801873:	e8 35 fd ff ff       	call   8015ad <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 05                	push   $0x5
  80188c:	e8 1c fd ff ff       	call   8015ad <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 06                	push   $0x6
  8018a5:	e8 03 fd ff ff       	call   8015ad <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 07                	push   $0x7
  8018be:	e8 ea fc ff ff       	call   8015ad <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_exit_env>:


void sys_exit_env(void)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 1c                	push   $0x1c
  8018d7:	e8 d1 fc ff ff       	call   8015ad <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	90                   	nop
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018e8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018eb:	8d 50 04             	lea    0x4(%eax),%edx
  8018ee:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	52                   	push   %edx
  8018f8:	50                   	push   %eax
  8018f9:	6a 1d                	push   $0x1d
  8018fb:	e8 ad fc ff ff       	call   8015ad <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
	return result;
  801903:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801906:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801909:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80190c:	89 01                	mov    %eax,(%ecx)
  80190e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	c9                   	leave  
  801915:	c2 04 00             	ret    $0x4

00801918 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	ff 75 10             	pushl  0x10(%ebp)
  801922:	ff 75 0c             	pushl  0xc(%ebp)
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	6a 13                	push   $0x13
  80192a:	e8 7e fc ff ff       	call   8015ad <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
	return ;
  801932:	90                   	nop
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_rcr2>:
uint32 sys_rcr2()
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 1e                	push   $0x1e
  801944:	e8 64 fc ff ff       	call   8015ad <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80195a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	50                   	push   %eax
  801967:	6a 1f                	push   $0x1f
  801969:	e8 3f fc ff ff       	call   8015ad <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
	return ;
  801971:	90                   	nop
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <rsttst>:
void rsttst()
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 21                	push   $0x21
  801983:	e8 25 fc ff ff       	call   8015ad <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
	return ;
  80198b:	90                   	nop
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	8b 45 14             	mov    0x14(%ebp),%eax
  801997:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80199a:	8b 55 18             	mov    0x18(%ebp),%edx
  80199d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019a1:	52                   	push   %edx
  8019a2:	50                   	push   %eax
  8019a3:	ff 75 10             	pushl  0x10(%ebp)
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	ff 75 08             	pushl  0x8(%ebp)
  8019ac:	6a 20                	push   $0x20
  8019ae:	e8 fa fb ff ff       	call   8015ad <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b6:	90                   	nop
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <chktst>:
void chktst(uint32 n)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 08             	pushl  0x8(%ebp)
  8019c7:	6a 22                	push   $0x22
  8019c9:	e8 df fb ff ff       	call   8015ad <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d1:	90                   	nop
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <inctst>:

void inctst()
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 23                	push   $0x23
  8019e3:	e8 c5 fb ff ff       	call   8015ad <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019eb:	90                   	nop
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <gettst>:
uint32 gettst()
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 24                	push   $0x24
  8019fd:	e8 ab fb ff ff       	call   8015ad <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 25                	push   $0x25
  801a19:	e8 8f fb ff ff       	call   8015ad <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
  801a21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a24:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a28:	75 07                	jne    801a31 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2f:	eb 05                	jmp    801a36 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 25                	push   $0x25
  801a4a:	e8 5e fb ff ff       	call   8015ad <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
  801a52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a55:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a59:	75 07                	jne    801a62 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a60:	eb 05                	jmp    801a67 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 25                	push   $0x25
  801a7b:	e8 2d fb ff ff       	call   8015ad <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
  801a83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a86:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a8a:	75 07                	jne    801a93 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801a91:	eb 05                	jmp    801a98 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 25                	push   $0x25
  801aac:	e8 fc fa ff ff       	call   8015ad <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
  801ab4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ab7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801abb:	75 07                	jne    801ac4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801abd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac2:	eb 05                	jmp    801ac9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ac4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	ff 75 08             	pushl  0x8(%ebp)
  801ad9:	6a 26                	push   $0x26
  801adb:	e8 cd fa ff ff       	call   8015ad <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae3:	90                   	nop
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801aea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	6a 00                	push   $0x0
  801af8:	53                   	push   %ebx
  801af9:	51                   	push   %ecx
  801afa:	52                   	push   %edx
  801afb:	50                   	push   %eax
  801afc:	6a 27                	push   $0x27
  801afe:	e8 aa fa ff ff       	call   8015ad <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	52                   	push   %edx
  801b1b:	50                   	push   %eax
  801b1c:	6a 28                	push   $0x28
  801b1e:	e8 8a fa ff ff       	call   8015ad <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b2b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	51                   	push   %ecx
  801b37:	ff 75 10             	pushl  0x10(%ebp)
  801b3a:	52                   	push   %edx
  801b3b:	50                   	push   %eax
  801b3c:	6a 29                	push   $0x29
  801b3e:	e8 6a fa ff ff       	call   8015ad <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	ff 75 10             	pushl  0x10(%ebp)
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	ff 75 08             	pushl  0x8(%ebp)
  801b58:	6a 12                	push   $0x12
  801b5a:	e8 4e fa ff ff       	call   8015ad <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b62:	90                   	nop
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801b68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	52                   	push   %edx
  801b75:	50                   	push   %eax
  801b76:	6a 2a                	push   $0x2a
  801b78:	e8 30 fa ff ff       	call   8015ad <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
	return;
  801b80:	90                   	nop
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	50                   	push   %eax
  801b92:	6a 2b                	push   $0x2b
  801b94:	e8 14 fa ff ff       	call   8015ad <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	ff 75 0c             	pushl  0xc(%ebp)
  801baa:	ff 75 08             	pushl  0x8(%ebp)
  801bad:	6a 2c                	push   $0x2c
  801baf:	e8 f9 f9 ff ff       	call   8015ad <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
	return;
  801bb7:	90                   	nop
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	ff 75 0c             	pushl  0xc(%ebp)
  801bc6:	ff 75 08             	pushl  0x8(%ebp)
  801bc9:	6a 2d                	push   $0x2d
  801bcb:	e8 dd f9 ff ff       	call   8015ad <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
	return;
  801bd3:	90                   	nop
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	83 e8 04             	sub    $0x4,%eax
  801be2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be8:	8b 00                	mov    (%eax),%eax
  801bea:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	83 e8 04             	sub    $0x4,%eax
  801bfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c01:	8b 00                	mov    (%eax),%eax
  801c03:	83 e0 01             	and    $0x1,%eax
  801c06:	85 c0                	test   %eax,%eax
  801c08:	0f 94 c0             	sete   %al
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1d:	83 f8 02             	cmp    $0x2,%eax
  801c20:	74 2b                	je     801c4d <alloc_block+0x40>
  801c22:	83 f8 02             	cmp    $0x2,%eax
  801c25:	7f 07                	jg     801c2e <alloc_block+0x21>
  801c27:	83 f8 01             	cmp    $0x1,%eax
  801c2a:	74 0e                	je     801c3a <alloc_block+0x2d>
  801c2c:	eb 58                	jmp    801c86 <alloc_block+0x79>
  801c2e:	83 f8 03             	cmp    $0x3,%eax
  801c31:	74 2d                	je     801c60 <alloc_block+0x53>
  801c33:	83 f8 04             	cmp    $0x4,%eax
  801c36:	74 3b                	je     801c73 <alloc_block+0x66>
  801c38:	eb 4c                	jmp    801c86 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801c3a:	83 ec 0c             	sub    $0xc,%esp
  801c3d:	ff 75 08             	pushl  0x8(%ebp)
  801c40:	e8 11 03 00 00       	call   801f56 <alloc_block_FF>
  801c45:	83 c4 10             	add    $0x10,%esp
  801c48:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c4b:	eb 4a                	jmp    801c97 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801c4d:	83 ec 0c             	sub    $0xc,%esp
  801c50:	ff 75 08             	pushl  0x8(%ebp)
  801c53:	e8 fa 19 00 00       	call   803652 <alloc_block_NF>
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c5e:	eb 37                	jmp    801c97 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801c60:	83 ec 0c             	sub    $0xc,%esp
  801c63:	ff 75 08             	pushl  0x8(%ebp)
  801c66:	e8 a7 07 00 00       	call   802412 <alloc_block_BF>
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c71:	eb 24                	jmp    801c97 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801c73:	83 ec 0c             	sub    $0xc,%esp
  801c76:	ff 75 08             	pushl  0x8(%ebp)
  801c79:	e8 b7 19 00 00       	call   803635 <alloc_block_WF>
  801c7e:	83 c4 10             	add    $0x10,%esp
  801c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801c84:	eb 11                	jmp    801c97 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801c86:	83 ec 0c             	sub    $0xc,%esp
  801c89:	68 2c 40 80 00       	push   $0x80402c
  801c8e:	e8 b8 e6 ff ff       	call   80034b <cprintf>
  801c93:	83 c4 10             	add    $0x10,%esp
		break;
  801c96:	90                   	nop
	}
	return va;
  801c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801ca3:	83 ec 0c             	sub    $0xc,%esp
  801ca6:	68 4c 40 80 00       	push   $0x80404c
  801cab:	e8 9b e6 ff ff       	call   80034b <cprintf>
  801cb0:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801cb3:	83 ec 0c             	sub    $0xc,%esp
  801cb6:	68 77 40 80 00       	push   $0x804077
  801cbb:	e8 8b e6 ff ff       	call   80034b <cprintf>
  801cc0:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cc9:	eb 37                	jmp    801d02 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801ccb:	83 ec 0c             	sub    $0xc,%esp
  801cce:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd1:	e8 19 ff ff ff       	call   801bef <is_free_block>
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	0f be d8             	movsbl %al,%ebx
  801cdc:	83 ec 0c             	sub    $0xc,%esp
  801cdf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce2:	e8 ef fe ff ff       	call   801bd6 <get_block_size>
  801ce7:	83 c4 10             	add    $0x10,%esp
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	53                   	push   %ebx
  801cee:	50                   	push   %eax
  801cef:	68 8f 40 80 00       	push   $0x80408f
  801cf4:	e8 52 e6 ff ff       	call   80034b <cprintf>
  801cf9:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d06:	74 07                	je     801d0f <print_blocks_list+0x73>
  801d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0b:	8b 00                	mov    (%eax),%eax
  801d0d:	eb 05                	jmp    801d14 <print_blocks_list+0x78>
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d14:	89 45 10             	mov    %eax,0x10(%ebp)
  801d17:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	75 ad                	jne    801ccb <print_blocks_list+0x2f>
  801d1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d22:	75 a7                	jne    801ccb <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801d24:	83 ec 0c             	sub    $0xc,%esp
  801d27:	68 4c 40 80 00       	push   $0x80404c
  801d2c:	e8 1a e6 ff ff       	call   80034b <cprintf>
  801d31:	83 c4 10             	add    $0x10,%esp

}
  801d34:	90                   	nop
  801d35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d43:	83 e0 01             	and    $0x1,%eax
  801d46:	85 c0                	test   %eax,%eax
  801d48:	74 03                	je     801d4d <initialize_dynamic_allocator+0x13>
  801d4a:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801d4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d51:	0f 84 c7 01 00 00    	je     801f1e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801d57:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801d5e:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801d61:	8b 55 08             	mov    0x8(%ebp),%edx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	01 d0                	add    %edx,%eax
  801d69:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801d6e:	0f 87 ad 01 00 00    	ja     801f21 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	85 c0                	test   %eax,%eax
  801d79:	0f 89 a5 01 00 00    	jns    801f24 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  801d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d85:	01 d0                	add    %edx,%eax
  801d87:	83 e8 04             	sub    $0x4,%eax
  801d8a:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801d8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801d96:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d9e:	e9 87 00 00 00       	jmp    801e2a <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801da3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da7:	75 14                	jne    801dbd <initialize_dynamic_allocator+0x83>
  801da9:	83 ec 04             	sub    $0x4,%esp
  801dac:	68 a7 40 80 00       	push   $0x8040a7
  801db1:	6a 79                	push   $0x79
  801db3:	68 c5 40 80 00       	push   $0x8040c5
  801db8:	e8 b2 18 00 00       	call   80366f <_panic>
  801dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc0:	8b 00                	mov    (%eax),%eax
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	74 10                	je     801dd6 <initialize_dynamic_allocator+0x9c>
  801dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc9:	8b 00                	mov    (%eax),%eax
  801dcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dce:	8b 52 04             	mov    0x4(%edx),%edx
  801dd1:	89 50 04             	mov    %edx,0x4(%eax)
  801dd4:	eb 0b                	jmp    801de1 <initialize_dynamic_allocator+0xa7>
  801dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd9:	8b 40 04             	mov    0x4(%eax),%eax
  801ddc:	a3 30 50 80 00       	mov    %eax,0x805030
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	8b 40 04             	mov    0x4(%eax),%eax
  801de7:	85 c0                	test   %eax,%eax
  801de9:	74 0f                	je     801dfa <initialize_dynamic_allocator+0xc0>
  801deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dee:	8b 40 04             	mov    0x4(%eax),%eax
  801df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df4:	8b 12                	mov    (%edx),%edx
  801df6:	89 10                	mov    %edx,(%eax)
  801df8:	eb 0a                	jmp    801e04 <initialize_dynamic_allocator+0xca>
  801dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfd:	8b 00                	mov    (%eax),%eax
  801dff:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e17:	a1 38 50 80 00       	mov    0x805038,%eax
  801e1c:	48                   	dec    %eax
  801e1d:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801e22:	a1 34 50 80 00       	mov    0x805034,%eax
  801e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e2e:	74 07                	je     801e37 <initialize_dynamic_allocator+0xfd>
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	8b 00                	mov    (%eax),%eax
  801e35:	eb 05                	jmp    801e3c <initialize_dynamic_allocator+0x102>
  801e37:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3c:	a3 34 50 80 00       	mov    %eax,0x805034
  801e41:	a1 34 50 80 00       	mov    0x805034,%eax
  801e46:	85 c0                	test   %eax,%eax
  801e48:	0f 85 55 ff ff ff    	jne    801da3 <initialize_dynamic_allocator+0x69>
  801e4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e52:	0f 85 4b ff ff ff    	jne    801da3 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e61:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801e67:	a1 44 50 80 00       	mov    0x805044,%eax
  801e6c:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801e71:	a1 40 50 80 00       	mov    0x805040,%eax
  801e76:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	83 c0 08             	add    $0x8,%eax
  801e82:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	83 c0 04             	add    $0x4,%eax
  801e8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8e:	83 ea 08             	sub    $0x8,%edx
  801e91:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801e93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	01 d0                	add    %edx,%eax
  801e9b:	83 e8 08             	sub    $0x8,%eax
  801e9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea1:	83 ea 08             	sub    $0x8,%edx
  801ea4:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801ea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801eb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ebd:	75 17                	jne    801ed6 <initialize_dynamic_allocator+0x19c>
  801ebf:	83 ec 04             	sub    $0x4,%esp
  801ec2:	68 e0 40 80 00       	push   $0x8040e0
  801ec7:	68 90 00 00 00       	push   $0x90
  801ecc:	68 c5 40 80 00       	push   $0x8040c5
  801ed1:	e8 99 17 00 00       	call   80366f <_panic>
  801ed6:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801edc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801edf:	89 10                	mov    %edx,(%eax)
  801ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee4:	8b 00                	mov    (%eax),%eax
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	74 0d                	je     801ef7 <initialize_dynamic_allocator+0x1bd>
  801eea:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801eef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ef2:	89 50 04             	mov    %edx,0x4(%eax)
  801ef5:	eb 08                	jmp    801eff <initialize_dynamic_allocator+0x1c5>
  801ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efa:	a3 30 50 80 00       	mov    %eax,0x805030
  801eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f02:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f11:	a1 38 50 80 00       	mov    0x805038,%eax
  801f16:	40                   	inc    %eax
  801f17:	a3 38 50 80 00       	mov    %eax,0x805038
  801f1c:	eb 07                	jmp    801f25 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801f1e:	90                   	nop
  801f1f:	eb 04                	jmp    801f25 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801f21:	90                   	nop
  801f22:	eb 01                	jmp    801f25 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801f24:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2d:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	8d 50 fc             	lea    -0x4(%eax),%edx
  801f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f39:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	83 e8 04             	sub    $0x4,%eax
  801f41:	8b 00                	mov    (%eax),%eax
  801f43:	83 e0 fe             	and    $0xfffffffe,%eax
  801f46:	8d 50 f8             	lea    -0x8(%eax),%edx
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	01 c2                	add    %eax,%edx
  801f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f51:	89 02                	mov    %eax,(%edx)
}
  801f53:	90                   	nop
  801f54:	5d                   	pop    %ebp
  801f55:	c3                   	ret    

00801f56 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	83 e0 01             	and    $0x1,%eax
  801f62:	85 c0                	test   %eax,%eax
  801f64:	74 03                	je     801f69 <alloc_block_FF+0x13>
  801f66:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801f69:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801f6d:	77 07                	ja     801f76 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801f6f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801f76:	a1 24 50 80 00       	mov    0x805024,%eax
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	75 73                	jne    801ff2 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	83 c0 10             	add    $0x10,%eax
  801f85:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  801f88:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f95:	01 d0                	add    %edx,%eax
  801f97:	48                   	dec    %eax
  801f98:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa3:	f7 75 ec             	divl   -0x14(%ebp)
  801fa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa9:	29 d0                	sub    %edx,%eax
  801fab:	c1 e8 0c             	shr    $0xc,%eax
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	50                   	push   %eax
  801fb2:	e8 2e f1 ff ff       	call   8010e5 <sbrk>
  801fb7:	83 c4 10             	add    $0x10,%esp
  801fba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	6a 00                	push   $0x0
  801fc2:	e8 1e f1 ff ff       	call   8010e5 <sbrk>
  801fc7:	83 c4 10             	add    $0x10,%esp
  801fca:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  801fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fd0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801fd3:	83 ec 08             	sub    $0x8,%esp
  801fd6:	50                   	push   %eax
  801fd7:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fda:	e8 5b fd ff ff       	call   801d3a <initialize_dynamic_allocator>
  801fdf:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  801fe2:	83 ec 0c             	sub    $0xc,%esp
  801fe5:	68 03 41 80 00       	push   $0x804103
  801fea:	e8 5c e3 ff ff       	call   80034b <cprintf>
  801fef:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  801ff2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ff6:	75 0a                	jne    802002 <alloc_block_FF+0xac>
	        return NULL;
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffd:	e9 0e 04 00 00       	jmp    802410 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802002:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802009:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80200e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802011:	e9 f3 02 00 00       	jmp    802309 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802019:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80201c:	83 ec 0c             	sub    $0xc,%esp
  80201f:	ff 75 bc             	pushl  -0x44(%ebp)
  802022:	e8 af fb ff ff       	call   801bd6 <get_block_size>
  802027:	83 c4 10             	add    $0x10,%esp
  80202a:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	83 c0 08             	add    $0x8,%eax
  802033:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802036:	0f 87 c5 02 00 00    	ja     802301 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	83 c0 18             	add    $0x18,%eax
  802042:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802045:	0f 87 19 02 00 00    	ja     802264 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80204b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80204e:	2b 45 08             	sub    0x8(%ebp),%eax
  802051:	83 e8 08             	sub    $0x8,%eax
  802054:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	8d 50 08             	lea    0x8(%eax),%edx
  80205d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802060:	01 d0                	add    %edx,%eax
  802062:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	83 c0 08             	add    $0x8,%eax
  80206b:	83 ec 04             	sub    $0x4,%esp
  80206e:	6a 01                	push   $0x1
  802070:	50                   	push   %eax
  802071:	ff 75 bc             	pushl  -0x44(%ebp)
  802074:	e8 ae fe ff ff       	call   801f27 <set_block_data>
  802079:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	8b 40 04             	mov    0x4(%eax),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	75 68                	jne    8020ee <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802086:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80208a:	75 17                	jne    8020a3 <alloc_block_FF+0x14d>
  80208c:	83 ec 04             	sub    $0x4,%esp
  80208f:	68 e0 40 80 00       	push   $0x8040e0
  802094:	68 d7 00 00 00       	push   $0xd7
  802099:	68 c5 40 80 00       	push   $0x8040c5
  80209e:	e8 cc 15 00 00       	call   80366f <_panic>
  8020a3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8020a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020ac:	89 10                	mov    %edx,(%eax)
  8020ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020b1:	8b 00                	mov    (%eax),%eax
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	74 0d                	je     8020c4 <alloc_block_FF+0x16e>
  8020b7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020bc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8020bf:	89 50 04             	mov    %edx,0x4(%eax)
  8020c2:	eb 08                	jmp    8020cc <alloc_block_FF+0x176>
  8020c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020c7:	a3 30 50 80 00       	mov    %eax,0x805030
  8020cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020cf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8020d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020de:	a1 38 50 80 00       	mov    0x805038,%eax
  8020e3:	40                   	inc    %eax
  8020e4:	a3 38 50 80 00       	mov    %eax,0x805038
  8020e9:	e9 dc 00 00 00       	jmp    8021ca <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	8b 00                	mov    (%eax),%eax
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	75 65                	jne    80215c <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8020f7:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8020fb:	75 17                	jne    802114 <alloc_block_FF+0x1be>
  8020fd:	83 ec 04             	sub    $0x4,%esp
  802100:	68 14 41 80 00       	push   $0x804114
  802105:	68 db 00 00 00       	push   $0xdb
  80210a:	68 c5 40 80 00       	push   $0x8040c5
  80210f:	e8 5b 15 00 00       	call   80366f <_panic>
  802114:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80211a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80211d:	89 50 04             	mov    %edx,0x4(%eax)
  802120:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802123:	8b 40 04             	mov    0x4(%eax),%eax
  802126:	85 c0                	test   %eax,%eax
  802128:	74 0c                	je     802136 <alloc_block_FF+0x1e0>
  80212a:	a1 30 50 80 00       	mov    0x805030,%eax
  80212f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802132:	89 10                	mov    %edx,(%eax)
  802134:	eb 08                	jmp    80213e <alloc_block_FF+0x1e8>
  802136:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802139:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80213e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802141:	a3 30 50 80 00       	mov    %eax,0x805030
  802146:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802149:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80214f:	a1 38 50 80 00       	mov    0x805038,%eax
  802154:	40                   	inc    %eax
  802155:	a3 38 50 80 00       	mov    %eax,0x805038
  80215a:	eb 6e                	jmp    8021ca <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80215c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802160:	74 06                	je     802168 <alloc_block_FF+0x212>
  802162:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802166:	75 17                	jne    80217f <alloc_block_FF+0x229>
  802168:	83 ec 04             	sub    $0x4,%esp
  80216b:	68 38 41 80 00       	push   $0x804138
  802170:	68 df 00 00 00       	push   $0xdf
  802175:	68 c5 40 80 00       	push   $0x8040c5
  80217a:	e8 f0 14 00 00       	call   80366f <_panic>
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 10                	mov    (%eax),%edx
  802184:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802187:	89 10                	mov    %edx,(%eax)
  802189:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80218c:	8b 00                	mov    (%eax),%eax
  80218e:	85 c0                	test   %eax,%eax
  802190:	74 0b                	je     80219d <alloc_block_FF+0x247>
  802192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802195:	8b 00                	mov    (%eax),%eax
  802197:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80219a:	89 50 04             	mov    %edx,0x4(%eax)
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021a3:	89 10                	mov    %edx,(%eax)
  8021a5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ab:	89 50 04             	mov    %edx,0x4(%eax)
  8021ae:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021b1:	8b 00                	mov    (%eax),%eax
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	75 08                	jne    8021bf <alloc_block_FF+0x269>
  8021b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021ba:	a3 30 50 80 00       	mov    %eax,0x805030
  8021bf:	a1 38 50 80 00       	mov    0x805038,%eax
  8021c4:	40                   	inc    %eax
  8021c5:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8021ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ce:	75 17                	jne    8021e7 <alloc_block_FF+0x291>
  8021d0:	83 ec 04             	sub    $0x4,%esp
  8021d3:	68 a7 40 80 00       	push   $0x8040a7
  8021d8:	68 e1 00 00 00       	push   $0xe1
  8021dd:	68 c5 40 80 00       	push   $0x8040c5
  8021e2:	e8 88 14 00 00       	call   80366f <_panic>
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	8b 00                	mov    (%eax),%eax
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	74 10                	je     802200 <alloc_block_FF+0x2aa>
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	8b 00                	mov    (%eax),%eax
  8021f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f8:	8b 52 04             	mov    0x4(%edx),%edx
  8021fb:	89 50 04             	mov    %edx,0x4(%eax)
  8021fe:	eb 0b                	jmp    80220b <alloc_block_FF+0x2b5>
  802200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802203:	8b 40 04             	mov    0x4(%eax),%eax
  802206:	a3 30 50 80 00       	mov    %eax,0x805030
  80220b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220e:	8b 40 04             	mov    0x4(%eax),%eax
  802211:	85 c0                	test   %eax,%eax
  802213:	74 0f                	je     802224 <alloc_block_FF+0x2ce>
  802215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802218:	8b 40 04             	mov    0x4(%eax),%eax
  80221b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221e:	8b 12                	mov    (%edx),%edx
  802220:	89 10                	mov    %edx,(%eax)
  802222:	eb 0a                	jmp    80222e <alloc_block_FF+0x2d8>
  802224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802227:	8b 00                	mov    (%eax),%eax
  802229:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802241:	a1 38 50 80 00       	mov    0x805038,%eax
  802246:	48                   	dec    %eax
  802247:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80224c:	83 ec 04             	sub    $0x4,%esp
  80224f:	6a 00                	push   $0x0
  802251:	ff 75 b4             	pushl  -0x4c(%ebp)
  802254:	ff 75 b0             	pushl  -0x50(%ebp)
  802257:	e8 cb fc ff ff       	call   801f27 <set_block_data>
  80225c:	83 c4 10             	add    $0x10,%esp
  80225f:	e9 95 00 00 00       	jmp    8022f9 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802264:	83 ec 04             	sub    $0x4,%esp
  802267:	6a 01                	push   $0x1
  802269:	ff 75 b8             	pushl  -0x48(%ebp)
  80226c:	ff 75 bc             	pushl  -0x44(%ebp)
  80226f:	e8 b3 fc ff ff       	call   801f27 <set_block_data>
  802274:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802277:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227b:	75 17                	jne    802294 <alloc_block_FF+0x33e>
  80227d:	83 ec 04             	sub    $0x4,%esp
  802280:	68 a7 40 80 00       	push   $0x8040a7
  802285:	68 e8 00 00 00       	push   $0xe8
  80228a:	68 c5 40 80 00       	push   $0x8040c5
  80228f:	e8 db 13 00 00       	call   80366f <_panic>
  802294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802297:	8b 00                	mov    (%eax),%eax
  802299:	85 c0                	test   %eax,%eax
  80229b:	74 10                	je     8022ad <alloc_block_FF+0x357>
  80229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a0:	8b 00                	mov    (%eax),%eax
  8022a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a5:	8b 52 04             	mov    0x4(%edx),%edx
  8022a8:	89 50 04             	mov    %edx,0x4(%eax)
  8022ab:	eb 0b                	jmp    8022b8 <alloc_block_FF+0x362>
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b0:	8b 40 04             	mov    0x4(%eax),%eax
  8022b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 40 04             	mov    0x4(%eax),%eax
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	74 0f                	je     8022d1 <alloc_block_FF+0x37b>
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 40 04             	mov    0x4(%eax),%eax
  8022c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022cb:	8b 12                	mov    (%edx),%edx
  8022cd:	89 10                	mov    %edx,(%eax)
  8022cf:	eb 0a                	jmp    8022db <alloc_block_FF+0x385>
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	8b 00                	mov    (%eax),%eax
  8022d6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ee:	a1 38 50 80 00       	mov    0x805038,%eax
  8022f3:	48                   	dec    %eax
  8022f4:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8022f9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8022fc:	e9 0f 01 00 00       	jmp    802410 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802301:	a1 34 50 80 00       	mov    0x805034,%eax
  802306:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230d:	74 07                	je     802316 <alloc_block_FF+0x3c0>
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 00                	mov    (%eax),%eax
  802314:	eb 05                	jmp    80231b <alloc_block_FF+0x3c5>
  802316:	b8 00 00 00 00       	mov    $0x0,%eax
  80231b:	a3 34 50 80 00       	mov    %eax,0x805034
  802320:	a1 34 50 80 00       	mov    0x805034,%eax
  802325:	85 c0                	test   %eax,%eax
  802327:	0f 85 e9 fc ff ff    	jne    802016 <alloc_block_FF+0xc0>
  80232d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802331:	0f 85 df fc ff ff    	jne    802016 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	83 c0 08             	add    $0x8,%eax
  80233d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802340:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802347:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80234a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80234d:	01 d0                	add    %edx,%eax
  80234f:	48                   	dec    %eax
  802350:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802353:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802356:	ba 00 00 00 00       	mov    $0x0,%edx
  80235b:	f7 75 d8             	divl   -0x28(%ebp)
  80235e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802361:	29 d0                	sub    %edx,%eax
  802363:	c1 e8 0c             	shr    $0xc,%eax
  802366:	83 ec 0c             	sub    $0xc,%esp
  802369:	50                   	push   %eax
  80236a:	e8 76 ed ff ff       	call   8010e5 <sbrk>
  80236f:	83 c4 10             	add    $0x10,%esp
  802372:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802375:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802379:	75 0a                	jne    802385 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80237b:	b8 00 00 00 00       	mov    $0x0,%eax
  802380:	e9 8b 00 00 00       	jmp    802410 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802385:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80238c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80238f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802392:	01 d0                	add    %edx,%eax
  802394:	48                   	dec    %eax
  802395:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802398:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80239b:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a0:	f7 75 cc             	divl   -0x34(%ebp)
  8023a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023a6:	29 d0                	sub    %edx,%eax
  8023a8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8023ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8023b5:	a1 40 50 80 00       	mov    0x805040,%eax
  8023ba:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8023c0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8023c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023ca:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8023cd:	01 d0                	add    %edx,%eax
  8023cf:	48                   	dec    %eax
  8023d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8023d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8023db:	f7 75 c4             	divl   -0x3c(%ebp)
  8023de:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8023e1:	29 d0                	sub    %edx,%eax
  8023e3:	83 ec 04             	sub    $0x4,%esp
  8023e6:	6a 01                	push   $0x1
  8023e8:	50                   	push   %eax
  8023e9:	ff 75 d0             	pushl  -0x30(%ebp)
  8023ec:	e8 36 fb ff ff       	call   801f27 <set_block_data>
  8023f1:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8023f4:	83 ec 0c             	sub    $0xc,%esp
  8023f7:	ff 75 d0             	pushl  -0x30(%ebp)
  8023fa:	e8 1b 0a 00 00       	call   802e1a <free_block>
  8023ff:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802402:	83 ec 0c             	sub    $0xc,%esp
  802405:	ff 75 08             	pushl  0x8(%ebp)
  802408:	e8 49 fb ff ff       	call   801f56 <alloc_block_FF>
  80240d:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	83 e0 01             	and    $0x1,%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	74 03                	je     802425 <alloc_block_BF+0x13>
  802422:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802425:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802429:	77 07                	ja     802432 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80242b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802432:	a1 24 50 80 00       	mov    0x805024,%eax
  802437:	85 c0                	test   %eax,%eax
  802439:	75 73                	jne    8024ae <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	83 c0 10             	add    $0x10,%eax
  802441:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802444:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80244b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80244e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802451:	01 d0                	add    %edx,%eax
  802453:	48                   	dec    %eax
  802454:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802457:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80245a:	ba 00 00 00 00       	mov    $0x0,%edx
  80245f:	f7 75 e0             	divl   -0x20(%ebp)
  802462:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802465:	29 d0                	sub    %edx,%eax
  802467:	c1 e8 0c             	shr    $0xc,%eax
  80246a:	83 ec 0c             	sub    $0xc,%esp
  80246d:	50                   	push   %eax
  80246e:	e8 72 ec ff ff       	call   8010e5 <sbrk>
  802473:	83 c4 10             	add    $0x10,%esp
  802476:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802479:	83 ec 0c             	sub    $0xc,%esp
  80247c:	6a 00                	push   $0x0
  80247e:	e8 62 ec ff ff       	call   8010e5 <sbrk>
  802483:	83 c4 10             	add    $0x10,%esp
  802486:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802489:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80248c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80248f:	83 ec 08             	sub    $0x8,%esp
  802492:	50                   	push   %eax
  802493:	ff 75 d8             	pushl  -0x28(%ebp)
  802496:	e8 9f f8 ff ff       	call   801d3a <initialize_dynamic_allocator>
  80249b:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80249e:	83 ec 0c             	sub    $0xc,%esp
  8024a1:	68 03 41 80 00       	push   $0x804103
  8024a6:	e8 a0 de ff ff       	call   80034b <cprintf>
  8024ab:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8024ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8024b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8024bc:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8024c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8024ca:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8024cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d2:	e9 1d 01 00 00       	jmp    8025f4 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8024dd:	83 ec 0c             	sub    $0xc,%esp
  8024e0:	ff 75 a8             	pushl  -0x58(%ebp)
  8024e3:	e8 ee f6 ff ff       	call   801bd6 <get_block_size>
  8024e8:	83 c4 10             	add    $0x10,%esp
  8024eb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	83 c0 08             	add    $0x8,%eax
  8024f4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8024f7:	0f 87 ef 00 00 00    	ja     8025ec <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	83 c0 18             	add    $0x18,%eax
  802503:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802506:	77 1d                	ja     802525 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80250e:	0f 86 d8 00 00 00    	jbe    8025ec <alloc_block_BF+0x1da>
				{
					best_va = va;
  802514:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802517:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80251a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80251d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802520:	e9 c7 00 00 00       	jmp    8025ec <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	83 c0 08             	add    $0x8,%eax
  80252b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80252e:	0f 85 9d 00 00 00    	jne    8025d1 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802534:	83 ec 04             	sub    $0x4,%esp
  802537:	6a 01                	push   $0x1
  802539:	ff 75 a4             	pushl  -0x5c(%ebp)
  80253c:	ff 75 a8             	pushl  -0x58(%ebp)
  80253f:	e8 e3 f9 ff ff       	call   801f27 <set_block_data>
  802544:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254b:	75 17                	jne    802564 <alloc_block_BF+0x152>
  80254d:	83 ec 04             	sub    $0x4,%esp
  802550:	68 a7 40 80 00       	push   $0x8040a7
  802555:	68 2c 01 00 00       	push   $0x12c
  80255a:	68 c5 40 80 00       	push   $0x8040c5
  80255f:	e8 0b 11 00 00       	call   80366f <_panic>
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 00                	mov    (%eax),%eax
  802569:	85 c0                	test   %eax,%eax
  80256b:	74 10                	je     80257d <alloc_block_BF+0x16b>
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 00                	mov    (%eax),%eax
  802572:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802575:	8b 52 04             	mov    0x4(%edx),%edx
  802578:	89 50 04             	mov    %edx,0x4(%eax)
  80257b:	eb 0b                	jmp    802588 <alloc_block_BF+0x176>
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 40 04             	mov    0x4(%eax),%eax
  802583:	a3 30 50 80 00       	mov    %eax,0x805030
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 40 04             	mov    0x4(%eax),%eax
  80258e:	85 c0                	test   %eax,%eax
  802590:	74 0f                	je     8025a1 <alloc_block_BF+0x18f>
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 40 04             	mov    0x4(%eax),%eax
  802598:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259b:	8b 12                	mov    (%edx),%edx
  80259d:	89 10                	mov    %edx,(%eax)
  80259f:	eb 0a                	jmp    8025ab <alloc_block_BF+0x199>
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 00                	mov    (%eax),%eax
  8025a6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025be:	a1 38 50 80 00       	mov    0x805038,%eax
  8025c3:	48                   	dec    %eax
  8025c4:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8025c9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025cc:	e9 24 04 00 00       	jmp    8029f5 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8025d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025d7:	76 13                	jbe    8025ec <alloc_block_BF+0x1da>
					{
						internal = 1;
  8025d9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8025e0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8025e6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025e9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8025ec:	a1 34 50 80 00       	mov    0x805034,%eax
  8025f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f8:	74 07                	je     802601 <alloc_block_BF+0x1ef>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	eb 05                	jmp    802606 <alloc_block_BF+0x1f4>
  802601:	b8 00 00 00 00       	mov    $0x0,%eax
  802606:	a3 34 50 80 00       	mov    %eax,0x805034
  80260b:	a1 34 50 80 00       	mov    0x805034,%eax
  802610:	85 c0                	test   %eax,%eax
  802612:	0f 85 bf fe ff ff    	jne    8024d7 <alloc_block_BF+0xc5>
  802618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261c:	0f 85 b5 fe ff ff    	jne    8024d7 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802622:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802626:	0f 84 26 02 00 00    	je     802852 <alloc_block_BF+0x440>
  80262c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802630:	0f 85 1c 02 00 00    	jne    802852 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802636:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802639:	2b 45 08             	sub    0x8(%ebp),%eax
  80263c:	83 e8 08             	sub    $0x8,%eax
  80263f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	8d 50 08             	lea    0x8(%eax),%edx
  802648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264b:	01 d0                	add    %edx,%eax
  80264d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	83 c0 08             	add    $0x8,%eax
  802656:	83 ec 04             	sub    $0x4,%esp
  802659:	6a 01                	push   $0x1
  80265b:	50                   	push   %eax
  80265c:	ff 75 f0             	pushl  -0x10(%ebp)
  80265f:	e8 c3 f8 ff ff       	call   801f27 <set_block_data>
  802664:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266a:	8b 40 04             	mov    0x4(%eax),%eax
  80266d:	85 c0                	test   %eax,%eax
  80266f:	75 68                	jne    8026d9 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802671:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802675:	75 17                	jne    80268e <alloc_block_BF+0x27c>
  802677:	83 ec 04             	sub    $0x4,%esp
  80267a:	68 e0 40 80 00       	push   $0x8040e0
  80267f:	68 45 01 00 00       	push   $0x145
  802684:	68 c5 40 80 00       	push   $0x8040c5
  802689:	e8 e1 0f 00 00       	call   80366f <_panic>
  80268e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802694:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802697:	89 10                	mov    %edx,(%eax)
  802699:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 0d                	je     8026af <alloc_block_BF+0x29d>
  8026a2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8026a7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8026aa:	89 50 04             	mov    %edx,0x4(%eax)
  8026ad:	eb 08                	jmp    8026b7 <alloc_block_BF+0x2a5>
  8026af:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8026b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026ba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c9:	a1 38 50 80 00       	mov    0x805038,%eax
  8026ce:	40                   	inc    %eax
  8026cf:	a3 38 50 80 00       	mov    %eax,0x805038
  8026d4:	e9 dc 00 00 00       	jmp    8027b5 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8026d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026dc:	8b 00                	mov    (%eax),%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	75 65                	jne    802747 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026e2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026e6:	75 17                	jne    8026ff <alloc_block_BF+0x2ed>
  8026e8:	83 ec 04             	sub    $0x4,%esp
  8026eb:	68 14 41 80 00       	push   $0x804114
  8026f0:	68 4a 01 00 00       	push   $0x14a
  8026f5:	68 c5 40 80 00       	push   $0x8040c5
  8026fa:	e8 70 0f 00 00       	call   80366f <_panic>
  8026ff:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802705:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802708:	89 50 04             	mov    %edx,0x4(%eax)
  80270b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80270e:	8b 40 04             	mov    0x4(%eax),%eax
  802711:	85 c0                	test   %eax,%eax
  802713:	74 0c                	je     802721 <alloc_block_BF+0x30f>
  802715:	a1 30 50 80 00       	mov    0x805030,%eax
  80271a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80271d:	89 10                	mov    %edx,(%eax)
  80271f:	eb 08                	jmp    802729 <alloc_block_BF+0x317>
  802721:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802724:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802729:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80272c:	a3 30 50 80 00       	mov    %eax,0x805030
  802731:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802734:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273a:	a1 38 50 80 00       	mov    0x805038,%eax
  80273f:	40                   	inc    %eax
  802740:	a3 38 50 80 00       	mov    %eax,0x805038
  802745:	eb 6e                	jmp    8027b5 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802747:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80274b:	74 06                	je     802753 <alloc_block_BF+0x341>
  80274d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802751:	75 17                	jne    80276a <alloc_block_BF+0x358>
  802753:	83 ec 04             	sub    $0x4,%esp
  802756:	68 38 41 80 00       	push   $0x804138
  80275b:	68 4f 01 00 00       	push   $0x14f
  802760:	68 c5 40 80 00       	push   $0x8040c5
  802765:	e8 05 0f 00 00       	call   80366f <_panic>
  80276a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276d:	8b 10                	mov    (%eax),%edx
  80276f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802772:	89 10                	mov    %edx,(%eax)
  802774:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	85 c0                	test   %eax,%eax
  80277b:	74 0b                	je     802788 <alloc_block_BF+0x376>
  80277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802785:	89 50 04             	mov    %edx,0x4(%eax)
  802788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80278e:	89 10                	mov    %edx,(%eax)
  802790:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802793:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802796:	89 50 04             	mov    %edx,0x4(%eax)
  802799:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	75 08                	jne    8027aa <alloc_block_BF+0x398>
  8027a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027a5:	a3 30 50 80 00       	mov    %eax,0x805030
  8027aa:	a1 38 50 80 00       	mov    0x805038,%eax
  8027af:	40                   	inc    %eax
  8027b0:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8027b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027b9:	75 17                	jne    8027d2 <alloc_block_BF+0x3c0>
  8027bb:	83 ec 04             	sub    $0x4,%esp
  8027be:	68 a7 40 80 00       	push   $0x8040a7
  8027c3:	68 51 01 00 00       	push   $0x151
  8027c8:	68 c5 40 80 00       	push   $0x8040c5
  8027cd:	e8 9d 0e 00 00       	call   80366f <_panic>
  8027d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 10                	je     8027eb <alloc_block_BF+0x3d9>
  8027db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e3:	8b 52 04             	mov    0x4(%edx),%edx
  8027e6:	89 50 04             	mov    %edx,0x4(%eax)
  8027e9:	eb 0b                	jmp    8027f6 <alloc_block_BF+0x3e4>
  8027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ee:	8b 40 04             	mov    0x4(%eax),%eax
  8027f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f9:	8b 40 04             	mov    0x4(%eax),%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	74 0f                	je     80280f <alloc_block_BF+0x3fd>
  802800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802809:	8b 12                	mov    (%edx),%edx
  80280b:	89 10                	mov    %edx,(%eax)
  80280d:	eb 0a                	jmp    802819 <alloc_block_BF+0x407>
  80280f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802825:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282c:	a1 38 50 80 00       	mov    0x805038,%eax
  802831:	48                   	dec    %eax
  802832:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802837:	83 ec 04             	sub    $0x4,%esp
  80283a:	6a 00                	push   $0x0
  80283c:	ff 75 d0             	pushl  -0x30(%ebp)
  80283f:	ff 75 cc             	pushl  -0x34(%ebp)
  802842:	e8 e0 f6 ff ff       	call   801f27 <set_block_data>
  802847:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80284a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284d:	e9 a3 01 00 00       	jmp    8029f5 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802852:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802856:	0f 85 9d 00 00 00    	jne    8028f9 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80285c:	83 ec 04             	sub    $0x4,%esp
  80285f:	6a 01                	push   $0x1
  802861:	ff 75 ec             	pushl  -0x14(%ebp)
  802864:	ff 75 f0             	pushl  -0x10(%ebp)
  802867:	e8 bb f6 ff ff       	call   801f27 <set_block_data>
  80286c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  80286f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802873:	75 17                	jne    80288c <alloc_block_BF+0x47a>
  802875:	83 ec 04             	sub    $0x4,%esp
  802878:	68 a7 40 80 00       	push   $0x8040a7
  80287d:	68 58 01 00 00       	push   $0x158
  802882:	68 c5 40 80 00       	push   $0x8040c5
  802887:	e8 e3 0d 00 00       	call   80366f <_panic>
  80288c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	85 c0                	test   %eax,%eax
  802893:	74 10                	je     8028a5 <alloc_block_BF+0x493>
  802895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80289d:	8b 52 04             	mov    0x4(%edx),%edx
  8028a0:	89 50 04             	mov    %edx,0x4(%eax)
  8028a3:	eb 0b                	jmp    8028b0 <alloc_block_BF+0x49e>
  8028a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a8:	8b 40 04             	mov    0x4(%eax),%eax
  8028ab:	a3 30 50 80 00       	mov    %eax,0x805030
  8028b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b3:	8b 40 04             	mov    0x4(%eax),%eax
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	74 0f                	je     8028c9 <alloc_block_BF+0x4b7>
  8028ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bd:	8b 40 04             	mov    0x4(%eax),%eax
  8028c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c3:	8b 12                	mov    (%edx),%edx
  8028c5:	89 10                	mov    %edx,(%eax)
  8028c7:	eb 0a                	jmp    8028d3 <alloc_block_BF+0x4c1>
  8028c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cc:	8b 00                	mov    (%eax),%eax
  8028ce:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e6:	a1 38 50 80 00       	mov    0x805038,%eax
  8028eb:	48                   	dec    %eax
  8028ec:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	e9 fc 00 00 00       	jmp    8029f5 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	83 c0 08             	add    $0x8,%eax
  8028ff:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802902:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802909:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80290c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80290f:	01 d0                	add    %edx,%eax
  802911:	48                   	dec    %eax
  802912:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802915:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802918:	ba 00 00 00 00       	mov    $0x0,%edx
  80291d:	f7 75 c4             	divl   -0x3c(%ebp)
  802920:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802923:	29 d0                	sub    %edx,%eax
  802925:	c1 e8 0c             	shr    $0xc,%eax
  802928:	83 ec 0c             	sub    $0xc,%esp
  80292b:	50                   	push   %eax
  80292c:	e8 b4 e7 ff ff       	call   8010e5 <sbrk>
  802931:	83 c4 10             	add    $0x10,%esp
  802934:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802937:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80293b:	75 0a                	jne    802947 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
  802942:	e9 ae 00 00 00       	jmp    8029f5 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802947:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  80294e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802951:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802954:	01 d0                	add    %edx,%eax
  802956:	48                   	dec    %eax
  802957:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80295a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80295d:	ba 00 00 00 00       	mov    $0x0,%edx
  802962:	f7 75 b8             	divl   -0x48(%ebp)
  802965:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802968:	29 d0                	sub    %edx,%eax
  80296a:	8d 50 fc             	lea    -0x4(%eax),%edx
  80296d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802970:	01 d0                	add    %edx,%eax
  802972:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802977:	a1 40 50 80 00       	mov    0x805040,%eax
  80297c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802982:	83 ec 0c             	sub    $0xc,%esp
  802985:	68 6c 41 80 00       	push   $0x80416c
  80298a:	e8 bc d9 ff ff       	call   80034b <cprintf>
  80298f:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802992:	83 ec 08             	sub    $0x8,%esp
  802995:	ff 75 bc             	pushl  -0x44(%ebp)
  802998:	68 71 41 80 00       	push   $0x804171
  80299d:	e8 a9 d9 ff ff       	call   80034b <cprintf>
  8029a2:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8029a5:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8029ac:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029af:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029b2:	01 d0                	add    %edx,%eax
  8029b4:	48                   	dec    %eax
  8029b5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8029b8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8029c0:	f7 75 b0             	divl   -0x50(%ebp)
  8029c3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029c6:	29 d0                	sub    %edx,%eax
  8029c8:	83 ec 04             	sub    $0x4,%esp
  8029cb:	6a 01                	push   $0x1
  8029cd:	50                   	push   %eax
  8029ce:	ff 75 bc             	pushl  -0x44(%ebp)
  8029d1:	e8 51 f5 ff ff       	call   801f27 <set_block_data>
  8029d6:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  8029d9:	83 ec 0c             	sub    $0xc,%esp
  8029dc:	ff 75 bc             	pushl  -0x44(%ebp)
  8029df:	e8 36 04 00 00       	call   802e1a <free_block>
  8029e4:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  8029e7:	83 ec 0c             	sub    $0xc,%esp
  8029ea:	ff 75 08             	pushl  0x8(%ebp)
  8029ed:	e8 20 fa ff ff       	call   802412 <alloc_block_BF>
  8029f2:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
  8029fa:	53                   	push   %ebx
  8029fb:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  8029fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802a0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a10:	74 1e                	je     802a30 <merging+0x39>
  802a12:	ff 75 08             	pushl  0x8(%ebp)
  802a15:	e8 bc f1 ff ff       	call   801bd6 <get_block_size>
  802a1a:	83 c4 04             	add    $0x4,%esp
  802a1d:	89 c2                	mov    %eax,%edx
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	01 d0                	add    %edx,%eax
  802a24:	3b 45 10             	cmp    0x10(%ebp),%eax
  802a27:	75 07                	jne    802a30 <merging+0x39>
		prev_is_free = 1;
  802a29:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802a30:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a34:	74 1e                	je     802a54 <merging+0x5d>
  802a36:	ff 75 10             	pushl  0x10(%ebp)
  802a39:	e8 98 f1 ff ff       	call   801bd6 <get_block_size>
  802a3e:	83 c4 04             	add    $0x4,%esp
  802a41:	89 c2                	mov    %eax,%edx
  802a43:	8b 45 10             	mov    0x10(%ebp),%eax
  802a46:	01 d0                	add    %edx,%eax
  802a48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a4b:	75 07                	jne    802a54 <merging+0x5d>
		next_is_free = 1;
  802a4d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a58:	0f 84 cc 00 00 00    	je     802b2a <merging+0x133>
  802a5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a62:	0f 84 c2 00 00 00    	je     802b2a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802a68:	ff 75 08             	pushl  0x8(%ebp)
  802a6b:	e8 66 f1 ff ff       	call   801bd6 <get_block_size>
  802a70:	83 c4 04             	add    $0x4,%esp
  802a73:	89 c3                	mov    %eax,%ebx
  802a75:	ff 75 10             	pushl  0x10(%ebp)
  802a78:	e8 59 f1 ff ff       	call   801bd6 <get_block_size>
  802a7d:	83 c4 04             	add    $0x4,%esp
  802a80:	01 c3                	add    %eax,%ebx
  802a82:	ff 75 0c             	pushl  0xc(%ebp)
  802a85:	e8 4c f1 ff ff       	call   801bd6 <get_block_size>
  802a8a:	83 c4 04             	add    $0x4,%esp
  802a8d:	01 d8                	add    %ebx,%eax
  802a8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802a92:	6a 00                	push   $0x0
  802a94:	ff 75 ec             	pushl  -0x14(%ebp)
  802a97:	ff 75 08             	pushl  0x8(%ebp)
  802a9a:	e8 88 f4 ff ff       	call   801f27 <set_block_data>
  802a9f:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802aa2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802aa6:	75 17                	jne    802abf <merging+0xc8>
  802aa8:	83 ec 04             	sub    $0x4,%esp
  802aab:	68 a7 40 80 00       	push   $0x8040a7
  802ab0:	68 7d 01 00 00       	push   $0x17d
  802ab5:	68 c5 40 80 00       	push   $0x8040c5
  802aba:	e8 b0 0b 00 00       	call   80366f <_panic>
  802abf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	74 10                	je     802ad8 <merging+0xe1>
  802ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802acb:	8b 00                	mov    (%eax),%eax
  802acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ad0:	8b 52 04             	mov    0x4(%edx),%edx
  802ad3:	89 50 04             	mov    %edx,0x4(%eax)
  802ad6:	eb 0b                	jmp    802ae3 <merging+0xec>
  802ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802adb:	8b 40 04             	mov    0x4(%eax),%eax
  802ade:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae6:	8b 40 04             	mov    0x4(%eax),%eax
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	74 0f                	je     802afc <merging+0x105>
  802aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  802af0:	8b 40 04             	mov    0x4(%eax),%eax
  802af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af6:	8b 12                	mov    (%edx),%edx
  802af8:	89 10                	mov    %edx,(%eax)
  802afa:	eb 0a                	jmp    802b06 <merging+0x10f>
  802afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aff:	8b 00                	mov    (%eax),%eax
  802b01:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b19:	a1 38 50 80 00       	mov    0x805038,%eax
  802b1e:	48                   	dec    %eax
  802b1f:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802b24:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b25:	e9 ea 02 00 00       	jmp    802e14 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802b2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2e:	74 3b                	je     802b6b <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802b30:	83 ec 0c             	sub    $0xc,%esp
  802b33:	ff 75 08             	pushl  0x8(%ebp)
  802b36:	e8 9b f0 ff ff       	call   801bd6 <get_block_size>
  802b3b:	83 c4 10             	add    $0x10,%esp
  802b3e:	89 c3                	mov    %eax,%ebx
  802b40:	83 ec 0c             	sub    $0xc,%esp
  802b43:	ff 75 10             	pushl  0x10(%ebp)
  802b46:	e8 8b f0 ff ff       	call   801bd6 <get_block_size>
  802b4b:	83 c4 10             	add    $0x10,%esp
  802b4e:	01 d8                	add    %ebx,%eax
  802b50:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b53:	83 ec 04             	sub    $0x4,%esp
  802b56:	6a 00                	push   $0x0
  802b58:	ff 75 e8             	pushl  -0x18(%ebp)
  802b5b:	ff 75 08             	pushl  0x8(%ebp)
  802b5e:	e8 c4 f3 ff ff       	call   801f27 <set_block_data>
  802b63:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b66:	e9 a9 02 00 00       	jmp    802e14 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802b6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b6f:	0f 84 2d 01 00 00    	je     802ca2 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802b75:	83 ec 0c             	sub    $0xc,%esp
  802b78:	ff 75 10             	pushl  0x10(%ebp)
  802b7b:	e8 56 f0 ff ff       	call   801bd6 <get_block_size>
  802b80:	83 c4 10             	add    $0x10,%esp
  802b83:	89 c3                	mov    %eax,%ebx
  802b85:	83 ec 0c             	sub    $0xc,%esp
  802b88:	ff 75 0c             	pushl  0xc(%ebp)
  802b8b:	e8 46 f0 ff ff       	call   801bd6 <get_block_size>
  802b90:	83 c4 10             	add    $0x10,%esp
  802b93:	01 d8                	add    %ebx,%eax
  802b95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802b98:	83 ec 04             	sub    $0x4,%esp
  802b9b:	6a 00                	push   $0x0
  802b9d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ba0:	ff 75 10             	pushl  0x10(%ebp)
  802ba3:	e8 7f f3 ff ff       	call   801f27 <set_block_data>
  802ba8:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802bab:	8b 45 10             	mov    0x10(%ebp),%eax
  802bae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802bb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bb5:	74 06                	je     802bbd <merging+0x1c6>
  802bb7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bbb:	75 17                	jne    802bd4 <merging+0x1dd>
  802bbd:	83 ec 04             	sub    $0x4,%esp
  802bc0:	68 80 41 80 00       	push   $0x804180
  802bc5:	68 8d 01 00 00       	push   $0x18d
  802bca:	68 c5 40 80 00       	push   $0x8040c5
  802bcf:	e8 9b 0a 00 00       	call   80366f <_panic>
  802bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd7:	8b 50 04             	mov    0x4(%eax),%edx
  802bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bdd:	89 50 04             	mov    %edx,0x4(%eax)
  802be0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802be6:	89 10                	mov    %edx,(%eax)
  802be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802beb:	8b 40 04             	mov    0x4(%eax),%eax
  802bee:	85 c0                	test   %eax,%eax
  802bf0:	74 0d                	je     802bff <merging+0x208>
  802bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf5:	8b 40 04             	mov    0x4(%eax),%eax
  802bf8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bfb:	89 10                	mov    %edx,(%eax)
  802bfd:	eb 08                	jmp    802c07 <merging+0x210>
  802bff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c02:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c0d:	89 50 04             	mov    %edx,0x4(%eax)
  802c10:	a1 38 50 80 00       	mov    0x805038,%eax
  802c15:	40                   	inc    %eax
  802c16:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c1f:	75 17                	jne    802c38 <merging+0x241>
  802c21:	83 ec 04             	sub    $0x4,%esp
  802c24:	68 a7 40 80 00       	push   $0x8040a7
  802c29:	68 8e 01 00 00       	push   $0x18e
  802c2e:	68 c5 40 80 00       	push   $0x8040c5
  802c33:	e8 37 0a 00 00       	call   80366f <_panic>
  802c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	74 10                	je     802c51 <merging+0x25a>
  802c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c49:	8b 52 04             	mov    0x4(%edx),%edx
  802c4c:	89 50 04             	mov    %edx,0x4(%eax)
  802c4f:	eb 0b                	jmp    802c5c <merging+0x265>
  802c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c54:	8b 40 04             	mov    0x4(%eax),%eax
  802c57:	a3 30 50 80 00       	mov    %eax,0x805030
  802c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c5f:	8b 40 04             	mov    0x4(%eax),%eax
  802c62:	85 c0                	test   %eax,%eax
  802c64:	74 0f                	je     802c75 <merging+0x27e>
  802c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c69:	8b 40 04             	mov    0x4(%eax),%eax
  802c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c6f:	8b 12                	mov    (%edx),%edx
  802c71:	89 10                	mov    %edx,(%eax)
  802c73:	eb 0a                	jmp    802c7f <merging+0x288>
  802c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c92:	a1 38 50 80 00       	mov    0x805038,%eax
  802c97:	48                   	dec    %eax
  802c98:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c9d:	e9 72 01 00 00       	jmp    802e14 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  802ca5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ca8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cac:	74 79                	je     802d27 <merging+0x330>
  802cae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cb2:	74 73                	je     802d27 <merging+0x330>
  802cb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb8:	74 06                	je     802cc0 <merging+0x2c9>
  802cba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802cbe:	75 17                	jne    802cd7 <merging+0x2e0>
  802cc0:	83 ec 04             	sub    $0x4,%esp
  802cc3:	68 38 41 80 00       	push   $0x804138
  802cc8:	68 94 01 00 00       	push   $0x194
  802ccd:	68 c5 40 80 00       	push   $0x8040c5
  802cd2:	e8 98 09 00 00       	call   80366f <_panic>
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	8b 10                	mov    (%eax),%edx
  802cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cdf:	89 10                	mov    %edx,(%eax)
  802ce1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	74 0b                	je     802cf5 <merging+0x2fe>
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cf2:	89 50 04             	mov    %edx,0x4(%eax)
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cfb:	89 10                	mov    %edx,(%eax)
  802cfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d00:	8b 55 08             	mov    0x8(%ebp),%edx
  802d03:	89 50 04             	mov    %edx,0x4(%eax)
  802d06:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d09:	8b 00                	mov    (%eax),%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	75 08                	jne    802d17 <merging+0x320>
  802d0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d12:	a3 30 50 80 00       	mov    %eax,0x805030
  802d17:	a1 38 50 80 00       	mov    0x805038,%eax
  802d1c:	40                   	inc    %eax
  802d1d:	a3 38 50 80 00       	mov    %eax,0x805038
  802d22:	e9 ce 00 00 00       	jmp    802df5 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802d27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d2b:	74 65                	je     802d92 <merging+0x39b>
  802d2d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d31:	75 17                	jne    802d4a <merging+0x353>
  802d33:	83 ec 04             	sub    $0x4,%esp
  802d36:	68 14 41 80 00       	push   $0x804114
  802d3b:	68 95 01 00 00       	push   $0x195
  802d40:	68 c5 40 80 00       	push   $0x8040c5
  802d45:	e8 25 09 00 00       	call   80366f <_panic>
  802d4a:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802d50:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d53:	89 50 04             	mov    %edx,0x4(%eax)
  802d56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d59:	8b 40 04             	mov    0x4(%eax),%eax
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	74 0c                	je     802d6c <merging+0x375>
  802d60:	a1 30 50 80 00       	mov    0x805030,%eax
  802d65:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d68:	89 10                	mov    %edx,(%eax)
  802d6a:	eb 08                	jmp    802d74 <merging+0x37d>
  802d6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d6f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d77:	a3 30 50 80 00       	mov    %eax,0x805030
  802d7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d85:	a1 38 50 80 00       	mov    0x805038,%eax
  802d8a:	40                   	inc    %eax
  802d8b:	a3 38 50 80 00       	mov    %eax,0x805038
  802d90:	eb 63                	jmp    802df5 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802d92:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d96:	75 17                	jne    802daf <merging+0x3b8>
  802d98:	83 ec 04             	sub    $0x4,%esp
  802d9b:	68 e0 40 80 00       	push   $0x8040e0
  802da0:	68 98 01 00 00       	push   $0x198
  802da5:	68 c5 40 80 00       	push   $0x8040c5
  802daa:	e8 c0 08 00 00       	call   80366f <_panic>
  802daf:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802db5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db8:	89 10                	mov    %edx,(%eax)
  802dba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	74 0d                	je     802dd0 <merging+0x3d9>
  802dc3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802dc8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dcb:	89 50 04             	mov    %edx,0x4(%eax)
  802dce:	eb 08                	jmp    802dd8 <merging+0x3e1>
  802dd0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd3:	a3 30 50 80 00       	mov    %eax,0x805030
  802dd8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ddb:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802de0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802de3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dea:	a1 38 50 80 00       	mov    0x805038,%eax
  802def:	40                   	inc    %eax
  802df0:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802df5:	83 ec 0c             	sub    $0xc,%esp
  802df8:	ff 75 10             	pushl  0x10(%ebp)
  802dfb:	e8 d6 ed ff ff       	call   801bd6 <get_block_size>
  802e00:	83 c4 10             	add    $0x10,%esp
  802e03:	83 ec 04             	sub    $0x4,%esp
  802e06:	6a 00                	push   $0x0
  802e08:	50                   	push   %eax
  802e09:	ff 75 10             	pushl  0x10(%ebp)
  802e0c:	e8 16 f1 ff ff       	call   801f27 <set_block_data>
  802e11:	83 c4 10             	add    $0x10,%esp
	}
}
  802e14:	90                   	nop
  802e15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e18:	c9                   	leave  
  802e19:	c3                   	ret    

00802e1a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e1a:	55                   	push   %ebp
  802e1b:	89 e5                	mov    %esp,%ebp
  802e1d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802e20:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e25:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802e28:	a1 30 50 80 00       	mov    0x805030,%eax
  802e2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e30:	73 1b                	jae    802e4d <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802e32:	a1 30 50 80 00       	mov    0x805030,%eax
  802e37:	83 ec 04             	sub    $0x4,%esp
  802e3a:	ff 75 08             	pushl  0x8(%ebp)
  802e3d:	6a 00                	push   $0x0
  802e3f:	50                   	push   %eax
  802e40:	e8 b2 fb ff ff       	call   8029f7 <merging>
  802e45:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e48:	e9 8b 00 00 00       	jmp    802ed8 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802e4d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e55:	76 18                	jbe    802e6f <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802e57:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e5c:	83 ec 04             	sub    $0x4,%esp
  802e5f:	ff 75 08             	pushl  0x8(%ebp)
  802e62:	50                   	push   %eax
  802e63:	6a 00                	push   $0x0
  802e65:	e8 8d fb ff ff       	call   8029f7 <merging>
  802e6a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802e6d:	eb 69                	jmp    802ed8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802e6f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e77:	eb 39                	jmp    802eb2 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e7f:	73 29                	jae    802eaa <free_block+0x90>
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	8b 00                	mov    (%eax),%eax
  802e86:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e89:	76 1f                	jbe    802eaa <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 00                	mov    (%eax),%eax
  802e90:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802e93:	83 ec 04             	sub    $0x4,%esp
  802e96:	ff 75 08             	pushl  0x8(%ebp)
  802e99:	ff 75 f0             	pushl  -0x10(%ebp)
  802e9c:	ff 75 f4             	pushl  -0xc(%ebp)
  802e9f:	e8 53 fb ff ff       	call   8029f7 <merging>
  802ea4:	83 c4 10             	add    $0x10,%esp
			break;
  802ea7:	90                   	nop
		}
	}
}
  802ea8:	eb 2e                	jmp    802ed8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802eaa:	a1 34 50 80 00       	mov    0x805034,%eax
  802eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb6:	74 07                	je     802ebf <free_block+0xa5>
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 00                	mov    (%eax),%eax
  802ebd:	eb 05                	jmp    802ec4 <free_block+0xaa>
  802ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec4:	a3 34 50 80 00       	mov    %eax,0x805034
  802ec9:	a1 34 50 80 00       	mov    0x805034,%eax
  802ece:	85 c0                	test   %eax,%eax
  802ed0:	75 a7                	jne    802e79 <free_block+0x5f>
  802ed2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed6:	75 a1                	jne    802e79 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ed8:	90                   	nop
  802ed9:	c9                   	leave  
  802eda:	c3                   	ret    

00802edb <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802edb:	55                   	push   %ebp
  802edc:	89 e5                	mov    %esp,%ebp
  802ede:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802ee1:	ff 75 08             	pushl  0x8(%ebp)
  802ee4:	e8 ed ec ff ff       	call   801bd6 <get_block_size>
  802ee9:	83 c4 04             	add    $0x4,%esp
  802eec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802eef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802ef6:	eb 17                	jmp    802f0f <copy_data+0x34>
  802ef8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802efe:	01 c2                	add    %eax,%edx
  802f00:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	01 c8                	add    %ecx,%eax
  802f08:	8a 00                	mov    (%eax),%al
  802f0a:	88 02                	mov    %al,(%edx)
  802f0c:	ff 45 fc             	incl   -0x4(%ebp)
  802f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f12:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802f15:	72 e1                	jb     802ef8 <copy_data+0x1d>
}
  802f17:	90                   	nop
  802f18:	c9                   	leave  
  802f19:	c3                   	ret    

00802f1a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802f1a:	55                   	push   %ebp
  802f1b:	89 e5                	mov    %esp,%ebp
  802f1d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802f20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f24:	75 23                	jne    802f49 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802f26:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f2a:	74 13                	je     802f3f <realloc_block_FF+0x25>
  802f2c:	83 ec 0c             	sub    $0xc,%esp
  802f2f:	ff 75 0c             	pushl  0xc(%ebp)
  802f32:	e8 1f f0 ff ff       	call   801f56 <alloc_block_FF>
  802f37:	83 c4 10             	add    $0x10,%esp
  802f3a:	e9 f4 06 00 00       	jmp    803633 <realloc_block_FF+0x719>
		return NULL;
  802f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f44:	e9 ea 06 00 00       	jmp    803633 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802f49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f4d:	75 18                	jne    802f67 <realloc_block_FF+0x4d>
	{
		free_block(va);
  802f4f:	83 ec 0c             	sub    $0xc,%esp
  802f52:	ff 75 08             	pushl  0x8(%ebp)
  802f55:	e8 c0 fe ff ff       	call   802e1a <free_block>
  802f5a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802f5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802f62:	e9 cc 06 00 00       	jmp    803633 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  802f67:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802f6b:	77 07                	ja     802f74 <realloc_block_FF+0x5a>
  802f6d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f77:	83 e0 01             	and    $0x1,%eax
  802f7a:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f80:	83 c0 08             	add    $0x8,%eax
  802f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  802f86:	83 ec 0c             	sub    $0xc,%esp
  802f89:	ff 75 08             	pushl  0x8(%ebp)
  802f8c:	e8 45 ec ff ff       	call   801bd6 <get_block_size>
  802f91:	83 c4 10             	add    $0x10,%esp
  802f94:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9a:	83 e8 08             	sub    $0x8,%eax
  802f9d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	83 e8 04             	sub    $0x4,%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	83 e0 fe             	and    $0xfffffffe,%eax
  802fab:	89 c2                	mov    %eax,%edx
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	01 d0                	add    %edx,%eax
  802fb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  802fb5:	83 ec 0c             	sub    $0xc,%esp
  802fb8:	ff 75 e4             	pushl  -0x1c(%ebp)
  802fbb:	e8 16 ec ff ff       	call   801bd6 <get_block_size>
  802fc0:	83 c4 10             	add    $0x10,%esp
  802fc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802fc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc9:	83 e8 08             	sub    $0x8,%eax
  802fcc:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  802fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fd5:	75 08                	jne    802fdf <realloc_block_FF+0xc5>
	{
		 return va;
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	e9 54 06 00 00       	jmp    803633 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  802fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802fe5:	0f 83 e5 03 00 00    	jae    8033d0 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  802feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fee:	2b 45 0c             	sub    0xc(%ebp),%eax
  802ff1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  802ff4:	83 ec 0c             	sub    $0xc,%esp
  802ff7:	ff 75 e4             	pushl  -0x1c(%ebp)
  802ffa:	e8 f0 eb ff ff       	call   801bef <is_free_block>
  802fff:	83 c4 10             	add    $0x10,%esp
  803002:	84 c0                	test   %al,%al
  803004:	0f 84 3b 01 00 00    	je     803145 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80300a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80300d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803010:	01 d0                	add    %edx,%eax
  803012:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803015:	83 ec 04             	sub    $0x4,%esp
  803018:	6a 01                	push   $0x1
  80301a:	ff 75 f0             	pushl  -0x10(%ebp)
  80301d:	ff 75 08             	pushl  0x8(%ebp)
  803020:	e8 02 ef ff ff       	call   801f27 <set_block_data>
  803025:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	83 e8 04             	sub    $0x4,%eax
  80302e:	8b 00                	mov    (%eax),%eax
  803030:	83 e0 fe             	and    $0xfffffffe,%eax
  803033:	89 c2                	mov    %eax,%edx
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	01 d0                	add    %edx,%eax
  80303a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	6a 00                	push   $0x0
  803042:	ff 75 cc             	pushl  -0x34(%ebp)
  803045:	ff 75 c8             	pushl  -0x38(%ebp)
  803048:	e8 da ee ff ff       	call   801f27 <set_block_data>
  80304d:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803050:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803054:	74 06                	je     80305c <realloc_block_FF+0x142>
  803056:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80305a:	75 17                	jne    803073 <realloc_block_FF+0x159>
  80305c:	83 ec 04             	sub    $0x4,%esp
  80305f:	68 38 41 80 00       	push   $0x804138
  803064:	68 f6 01 00 00       	push   $0x1f6
  803069:	68 c5 40 80 00       	push   $0x8040c5
  80306e:	e8 fc 05 00 00       	call   80366f <_panic>
  803073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803076:	8b 10                	mov    (%eax),%edx
  803078:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80307b:	89 10                	mov    %edx,(%eax)
  80307d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	85 c0                	test   %eax,%eax
  803084:	74 0b                	je     803091 <realloc_block_FF+0x177>
  803086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80308e:	89 50 04             	mov    %edx,0x4(%eax)
  803091:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803094:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803097:	89 10                	mov    %edx,(%eax)
  803099:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80309c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80309f:	89 50 04             	mov    %edx,0x4(%eax)
  8030a2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030a5:	8b 00                	mov    (%eax),%eax
  8030a7:	85 c0                	test   %eax,%eax
  8030a9:	75 08                	jne    8030b3 <realloc_block_FF+0x199>
  8030ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030ae:	a3 30 50 80 00       	mov    %eax,0x805030
  8030b3:	a1 38 50 80 00       	mov    0x805038,%eax
  8030b8:	40                   	inc    %eax
  8030b9:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8030be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030c2:	75 17                	jne    8030db <realloc_block_FF+0x1c1>
  8030c4:	83 ec 04             	sub    $0x4,%esp
  8030c7:	68 a7 40 80 00       	push   $0x8040a7
  8030cc:	68 f7 01 00 00       	push   $0x1f7
  8030d1:	68 c5 40 80 00       	push   $0x8040c5
  8030d6:	e8 94 05 00 00       	call   80366f <_panic>
  8030db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030de:	8b 00                	mov    (%eax),%eax
  8030e0:	85 c0                	test   %eax,%eax
  8030e2:	74 10                	je     8030f4 <realloc_block_FF+0x1da>
  8030e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e7:	8b 00                	mov    (%eax),%eax
  8030e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ec:	8b 52 04             	mov    0x4(%edx),%edx
  8030ef:	89 50 04             	mov    %edx,0x4(%eax)
  8030f2:	eb 0b                	jmp    8030ff <realloc_block_FF+0x1e5>
  8030f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	a3 30 50 80 00       	mov    %eax,0x805030
  8030ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803102:	8b 40 04             	mov    0x4(%eax),%eax
  803105:	85 c0                	test   %eax,%eax
  803107:	74 0f                	je     803118 <realloc_block_FF+0x1fe>
  803109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80310c:	8b 40 04             	mov    0x4(%eax),%eax
  80310f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803112:	8b 12                	mov    (%edx),%edx
  803114:	89 10                	mov    %edx,(%eax)
  803116:	eb 0a                	jmp    803122 <realloc_block_FF+0x208>
  803118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311b:	8b 00                	mov    (%eax),%eax
  80311d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803122:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803125:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803135:	a1 38 50 80 00       	mov    0x805038,%eax
  80313a:	48                   	dec    %eax
  80313b:	a3 38 50 80 00       	mov    %eax,0x805038
  803140:	e9 83 02 00 00       	jmp    8033c8 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803145:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803149:	0f 86 69 02 00 00    	jbe    8033b8 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80314f:	83 ec 04             	sub    $0x4,%esp
  803152:	6a 01                	push   $0x1
  803154:	ff 75 f0             	pushl  -0x10(%ebp)
  803157:	ff 75 08             	pushl  0x8(%ebp)
  80315a:	e8 c8 ed ff ff       	call   801f27 <set_block_data>
  80315f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	83 e8 04             	sub    $0x4,%eax
  803168:	8b 00                	mov    (%eax),%eax
  80316a:	83 e0 fe             	and    $0xfffffffe,%eax
  80316d:	89 c2                	mov    %eax,%edx
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	01 d0                	add    %edx,%eax
  803174:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803177:	a1 38 50 80 00       	mov    0x805038,%eax
  80317c:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80317f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803183:	75 68                	jne    8031ed <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803185:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803189:	75 17                	jne    8031a2 <realloc_block_FF+0x288>
  80318b:	83 ec 04             	sub    $0x4,%esp
  80318e:	68 e0 40 80 00       	push   $0x8040e0
  803193:	68 06 02 00 00       	push   $0x206
  803198:	68 c5 40 80 00       	push   $0x8040c5
  80319d:	e8 cd 04 00 00       	call   80366f <_panic>
  8031a2:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8031a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031ab:	89 10                	mov    %edx,(%eax)
  8031ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031b0:	8b 00                	mov    (%eax),%eax
  8031b2:	85 c0                	test   %eax,%eax
  8031b4:	74 0d                	je     8031c3 <realloc_block_FF+0x2a9>
  8031b6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8031be:	89 50 04             	mov    %edx,0x4(%eax)
  8031c1:	eb 08                	jmp    8031cb <realloc_block_FF+0x2b1>
  8031c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031c6:	a3 30 50 80 00       	mov    %eax,0x805030
  8031cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031ce:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031dd:	a1 38 50 80 00       	mov    0x805038,%eax
  8031e2:	40                   	inc    %eax
  8031e3:	a3 38 50 80 00       	mov    %eax,0x805038
  8031e8:	e9 b0 01 00 00       	jmp    80339d <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8031ed:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8031f2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8031f5:	76 68                	jbe    80325f <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8031f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031fb:	75 17                	jne    803214 <realloc_block_FF+0x2fa>
  8031fd:	83 ec 04             	sub    $0x4,%esp
  803200:	68 e0 40 80 00       	push   $0x8040e0
  803205:	68 0b 02 00 00       	push   $0x20b
  80320a:	68 c5 40 80 00       	push   $0x8040c5
  80320f:	e8 5b 04 00 00       	call   80366f <_panic>
  803214:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80321a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80321d:	89 10                	mov    %edx,(%eax)
  80321f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	85 c0                	test   %eax,%eax
  803226:	74 0d                	je     803235 <realloc_block_FF+0x31b>
  803228:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80322d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803230:	89 50 04             	mov    %edx,0x4(%eax)
  803233:	eb 08                	jmp    80323d <realloc_block_FF+0x323>
  803235:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803238:	a3 30 50 80 00       	mov    %eax,0x805030
  80323d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803240:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803245:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803248:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324f:	a1 38 50 80 00       	mov    0x805038,%eax
  803254:	40                   	inc    %eax
  803255:	a3 38 50 80 00       	mov    %eax,0x805038
  80325a:	e9 3e 01 00 00       	jmp    80339d <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80325f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803264:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803267:	73 68                	jae    8032d1 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803269:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80326d:	75 17                	jne    803286 <realloc_block_FF+0x36c>
  80326f:	83 ec 04             	sub    $0x4,%esp
  803272:	68 14 41 80 00       	push   $0x804114
  803277:	68 10 02 00 00       	push   $0x210
  80327c:	68 c5 40 80 00       	push   $0x8040c5
  803281:	e8 e9 03 00 00       	call   80366f <_panic>
  803286:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80328c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80328f:	89 50 04             	mov    %edx,0x4(%eax)
  803292:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803295:	8b 40 04             	mov    0x4(%eax),%eax
  803298:	85 c0                	test   %eax,%eax
  80329a:	74 0c                	je     8032a8 <realloc_block_FF+0x38e>
  80329c:	a1 30 50 80 00       	mov    0x805030,%eax
  8032a1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032a4:	89 10                	mov    %edx,(%eax)
  8032a6:	eb 08                	jmp    8032b0 <realloc_block_FF+0x396>
  8032a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ab:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032b3:	a3 30 50 80 00       	mov    %eax,0x805030
  8032b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c1:	a1 38 50 80 00       	mov    0x805038,%eax
  8032c6:	40                   	inc    %eax
  8032c7:	a3 38 50 80 00       	mov    %eax,0x805038
  8032cc:	e9 cc 00 00 00       	jmp    80339d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8032d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8032d8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032e0:	e9 8a 00 00 00       	jmp    80336f <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8032e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032eb:	73 7a                	jae    803367 <realloc_block_FF+0x44d>
  8032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032f5:	73 70                	jae    803367 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8032f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fb:	74 06                	je     803303 <realloc_block_FF+0x3e9>
  8032fd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803301:	75 17                	jne    80331a <realloc_block_FF+0x400>
  803303:	83 ec 04             	sub    $0x4,%esp
  803306:	68 38 41 80 00       	push   $0x804138
  80330b:	68 1a 02 00 00       	push   $0x21a
  803310:	68 c5 40 80 00       	push   $0x8040c5
  803315:	e8 55 03 00 00       	call   80366f <_panic>
  80331a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331d:	8b 10                	mov    (%eax),%edx
  80331f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803322:	89 10                	mov    %edx,(%eax)
  803324:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	85 c0                	test   %eax,%eax
  80332b:	74 0b                	je     803338 <realloc_block_FF+0x41e>
  80332d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803335:	89 50 04             	mov    %edx,0x4(%eax)
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80333e:	89 10                	mov    %edx,(%eax)
  803340:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803346:	89 50 04             	mov    %edx,0x4(%eax)
  803349:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	75 08                	jne    80335a <realloc_block_FF+0x440>
  803352:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803355:	a3 30 50 80 00       	mov    %eax,0x805030
  80335a:	a1 38 50 80 00       	mov    0x805038,%eax
  80335f:	40                   	inc    %eax
  803360:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803365:	eb 36                	jmp    80339d <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803367:	a1 34 50 80 00       	mov    0x805034,%eax
  80336c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803373:	74 07                	je     80337c <realloc_block_FF+0x462>
  803375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803378:	8b 00                	mov    (%eax),%eax
  80337a:	eb 05                	jmp    803381 <realloc_block_FF+0x467>
  80337c:	b8 00 00 00 00       	mov    $0x0,%eax
  803381:	a3 34 50 80 00       	mov    %eax,0x805034
  803386:	a1 34 50 80 00       	mov    0x805034,%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	0f 85 52 ff ff ff    	jne    8032e5 <realloc_block_FF+0x3cb>
  803393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803397:	0f 85 48 ff ff ff    	jne    8032e5 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  80339d:	83 ec 04             	sub    $0x4,%esp
  8033a0:	6a 00                	push   $0x0
  8033a2:	ff 75 d8             	pushl  -0x28(%ebp)
  8033a5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033a8:	e8 7a eb ff ff       	call   801f27 <set_block_data>
  8033ad:	83 c4 10             	add    $0x10,%esp
				return va;
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	e9 7b 02 00 00       	jmp    803633 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8033b8:	83 ec 0c             	sub    $0xc,%esp
  8033bb:	68 b5 41 80 00       	push   $0x8041b5
  8033c0:	e8 86 cf ff ff       	call   80034b <cprintf>
  8033c5:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	e9 63 02 00 00       	jmp    803633 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8033d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033d3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8033d6:	0f 86 4d 02 00 00    	jbe    803629 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8033dc:	83 ec 0c             	sub    $0xc,%esp
  8033df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8033e2:	e8 08 e8 ff ff       	call   801bef <is_free_block>
  8033e7:	83 c4 10             	add    $0x10,%esp
  8033ea:	84 c0                	test   %al,%al
  8033ec:	0f 84 37 02 00 00    	je     803629 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8033f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8033f8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8033fb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8033fe:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803401:	76 38                	jbe    80343b <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803403:	83 ec 0c             	sub    $0xc,%esp
  803406:	ff 75 08             	pushl  0x8(%ebp)
  803409:	e8 0c fa ff ff       	call   802e1a <free_block>
  80340e:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803411:	83 ec 0c             	sub    $0xc,%esp
  803414:	ff 75 0c             	pushl  0xc(%ebp)
  803417:	e8 3a eb ff ff       	call   801f56 <alloc_block_FF>
  80341c:	83 c4 10             	add    $0x10,%esp
  80341f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803422:	83 ec 08             	sub    $0x8,%esp
  803425:	ff 75 c0             	pushl  -0x40(%ebp)
  803428:	ff 75 08             	pushl  0x8(%ebp)
  80342b:	e8 ab fa ff ff       	call   802edb <copy_data>
  803430:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803433:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803436:	e9 f8 01 00 00       	jmp    803633 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80343b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80343e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803441:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803444:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803448:	0f 87 a0 00 00 00    	ja     8034ee <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80344e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803452:	75 17                	jne    80346b <realloc_block_FF+0x551>
  803454:	83 ec 04             	sub    $0x4,%esp
  803457:	68 a7 40 80 00       	push   $0x8040a7
  80345c:	68 38 02 00 00       	push   $0x238
  803461:	68 c5 40 80 00       	push   $0x8040c5
  803466:	e8 04 02 00 00       	call   80366f <_panic>
  80346b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346e:	8b 00                	mov    (%eax),%eax
  803470:	85 c0                	test   %eax,%eax
  803472:	74 10                	je     803484 <realloc_block_FF+0x56a>
  803474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803477:	8b 00                	mov    (%eax),%eax
  803479:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80347c:	8b 52 04             	mov    0x4(%edx),%edx
  80347f:	89 50 04             	mov    %edx,0x4(%eax)
  803482:	eb 0b                	jmp    80348f <realloc_block_FF+0x575>
  803484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803487:	8b 40 04             	mov    0x4(%eax),%eax
  80348a:	a3 30 50 80 00       	mov    %eax,0x805030
  80348f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803492:	8b 40 04             	mov    0x4(%eax),%eax
  803495:	85 c0                	test   %eax,%eax
  803497:	74 0f                	je     8034a8 <realloc_block_FF+0x58e>
  803499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349c:	8b 40 04             	mov    0x4(%eax),%eax
  80349f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034a2:	8b 12                	mov    (%edx),%edx
  8034a4:	89 10                	mov    %edx,(%eax)
  8034a6:	eb 0a                	jmp    8034b2 <realloc_block_FF+0x598>
  8034a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ab:	8b 00                	mov    (%eax),%eax
  8034ad:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8034b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8034ca:	48                   	dec    %eax
  8034cb:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8034d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034d6:	01 d0                	add    %edx,%eax
  8034d8:	83 ec 04             	sub    $0x4,%esp
  8034db:	6a 01                	push   $0x1
  8034dd:	50                   	push   %eax
  8034de:	ff 75 08             	pushl  0x8(%ebp)
  8034e1:	e8 41 ea ff ff       	call   801f27 <set_block_data>
  8034e6:	83 c4 10             	add    $0x10,%esp
  8034e9:	e9 36 01 00 00       	jmp    803624 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8034ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034f4:	01 d0                	add    %edx,%eax
  8034f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8034f9:	83 ec 04             	sub    $0x4,%esp
  8034fc:	6a 01                	push   $0x1
  8034fe:	ff 75 f0             	pushl  -0x10(%ebp)
  803501:	ff 75 08             	pushl  0x8(%ebp)
  803504:	e8 1e ea ff ff       	call   801f27 <set_block_data>
  803509:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	83 e8 04             	sub    $0x4,%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	83 e0 fe             	and    $0xfffffffe,%eax
  803517:	89 c2                	mov    %eax,%edx
  803519:	8b 45 08             	mov    0x8(%ebp),%eax
  80351c:	01 d0                	add    %edx,%eax
  80351e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803521:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803525:	74 06                	je     80352d <realloc_block_FF+0x613>
  803527:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80352b:	75 17                	jne    803544 <realloc_block_FF+0x62a>
  80352d:	83 ec 04             	sub    $0x4,%esp
  803530:	68 38 41 80 00       	push   $0x804138
  803535:	68 44 02 00 00       	push   $0x244
  80353a:	68 c5 40 80 00       	push   $0x8040c5
  80353f:	e8 2b 01 00 00       	call   80366f <_panic>
  803544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803547:	8b 10                	mov    (%eax),%edx
  803549:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80354c:	89 10                	mov    %edx,(%eax)
  80354e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803551:	8b 00                	mov    (%eax),%eax
  803553:	85 c0                	test   %eax,%eax
  803555:	74 0b                	je     803562 <realloc_block_FF+0x648>
  803557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355a:	8b 00                	mov    (%eax),%eax
  80355c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80355f:	89 50 04             	mov    %edx,0x4(%eax)
  803562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803565:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803568:	89 10                	mov    %edx,(%eax)
  80356a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80356d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803570:	89 50 04             	mov    %edx,0x4(%eax)
  803573:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803576:	8b 00                	mov    (%eax),%eax
  803578:	85 c0                	test   %eax,%eax
  80357a:	75 08                	jne    803584 <realloc_block_FF+0x66a>
  80357c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80357f:	a3 30 50 80 00       	mov    %eax,0x805030
  803584:	a1 38 50 80 00       	mov    0x805038,%eax
  803589:	40                   	inc    %eax
  80358a:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80358f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803593:	75 17                	jne    8035ac <realloc_block_FF+0x692>
  803595:	83 ec 04             	sub    $0x4,%esp
  803598:	68 a7 40 80 00       	push   $0x8040a7
  80359d:	68 45 02 00 00       	push   $0x245
  8035a2:	68 c5 40 80 00       	push   $0x8040c5
  8035a7:	e8 c3 00 00 00       	call   80366f <_panic>
  8035ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035af:	8b 00                	mov    (%eax),%eax
  8035b1:	85 c0                	test   %eax,%eax
  8035b3:	74 10                	je     8035c5 <realloc_block_FF+0x6ab>
  8035b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b8:	8b 00                	mov    (%eax),%eax
  8035ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035bd:	8b 52 04             	mov    0x4(%edx),%edx
  8035c0:	89 50 04             	mov    %edx,0x4(%eax)
  8035c3:	eb 0b                	jmp    8035d0 <realloc_block_FF+0x6b6>
  8035c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c8:	8b 40 04             	mov    0x4(%eax),%eax
  8035cb:	a3 30 50 80 00       	mov    %eax,0x805030
  8035d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d3:	8b 40 04             	mov    0x4(%eax),%eax
  8035d6:	85 c0                	test   %eax,%eax
  8035d8:	74 0f                	je     8035e9 <realloc_block_FF+0x6cf>
  8035da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035dd:	8b 40 04             	mov    0x4(%eax),%eax
  8035e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035e3:	8b 12                	mov    (%edx),%edx
  8035e5:	89 10                	mov    %edx,(%eax)
  8035e7:	eb 0a                	jmp    8035f3 <realloc_block_FF+0x6d9>
  8035e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ec:	8b 00                	mov    (%eax),%eax
  8035ee:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803606:	a1 38 50 80 00       	mov    0x805038,%eax
  80360b:	48                   	dec    %eax
  80360c:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803611:	83 ec 04             	sub    $0x4,%esp
  803614:	6a 00                	push   $0x0
  803616:	ff 75 bc             	pushl  -0x44(%ebp)
  803619:	ff 75 b8             	pushl  -0x48(%ebp)
  80361c:	e8 06 e9 ff ff       	call   801f27 <set_block_data>
  803621:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	eb 0a                	jmp    803633 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803629:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803633:	c9                   	leave  
  803634:	c3                   	ret    

00803635 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803635:	55                   	push   %ebp
  803636:	89 e5                	mov    %esp,%ebp
  803638:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80363b:	83 ec 04             	sub    $0x4,%esp
  80363e:	68 bc 41 80 00       	push   $0x8041bc
  803643:	68 58 02 00 00       	push   $0x258
  803648:	68 c5 40 80 00       	push   $0x8040c5
  80364d:	e8 1d 00 00 00       	call   80366f <_panic>

00803652 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803652:	55                   	push   %ebp
  803653:	89 e5                	mov    %esp,%ebp
  803655:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803658:	83 ec 04             	sub    $0x4,%esp
  80365b:	68 e4 41 80 00       	push   $0x8041e4
  803660:	68 61 02 00 00       	push   $0x261
  803665:	68 c5 40 80 00       	push   $0x8040c5
  80366a:	e8 00 00 00 00       	call   80366f <_panic>

0080366f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80366f:	55                   	push   %ebp
  803670:	89 e5                	mov    %esp,%ebp
  803672:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803675:	8d 45 10             	lea    0x10(%ebp),%eax
  803678:	83 c0 04             	add    $0x4,%eax
  80367b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80367e:	a1 60 50 90 00       	mov    0x905060,%eax
  803683:	85 c0                	test   %eax,%eax
  803685:	74 16                	je     80369d <_panic+0x2e>
		cprintf("%s: ", argv0);
  803687:	a1 60 50 90 00       	mov    0x905060,%eax
  80368c:	83 ec 08             	sub    $0x8,%esp
  80368f:	50                   	push   %eax
  803690:	68 0c 42 80 00       	push   $0x80420c
  803695:	e8 b1 cc ff ff       	call   80034b <cprintf>
  80369a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80369d:	a1 00 50 80 00       	mov    0x805000,%eax
  8036a2:	ff 75 0c             	pushl  0xc(%ebp)
  8036a5:	ff 75 08             	pushl  0x8(%ebp)
  8036a8:	50                   	push   %eax
  8036a9:	68 11 42 80 00       	push   $0x804211
  8036ae:	e8 98 cc ff ff       	call   80034b <cprintf>
  8036b3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8036b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8036b9:	83 ec 08             	sub    $0x8,%esp
  8036bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8036bf:	50                   	push   %eax
  8036c0:	e8 1b cc ff ff       	call   8002e0 <vcprintf>
  8036c5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8036c8:	83 ec 08             	sub    $0x8,%esp
  8036cb:	6a 00                	push   $0x0
  8036cd:	68 2d 42 80 00       	push   $0x80422d
  8036d2:	e8 09 cc ff ff       	call   8002e0 <vcprintf>
  8036d7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8036da:	e8 8a cb ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  8036df:	eb fe                	jmp    8036df <_panic+0x70>

008036e1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8036e1:	55                   	push   %ebp
  8036e2:	89 e5                	mov    %esp,%ebp
  8036e4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8036e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8036ec:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8036f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036f5:	39 c2                	cmp    %eax,%edx
  8036f7:	74 14                	je     80370d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8036f9:	83 ec 04             	sub    $0x4,%esp
  8036fc:	68 30 42 80 00       	push   $0x804230
  803701:	6a 26                	push   $0x26
  803703:	68 7c 42 80 00       	push   $0x80427c
  803708:	e8 62 ff ff ff       	call   80366f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80370d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803714:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80371b:	e9 c5 00 00 00       	jmp    8037e5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803723:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80372a:	8b 45 08             	mov    0x8(%ebp),%eax
  80372d:	01 d0                	add    %edx,%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	85 c0                	test   %eax,%eax
  803733:	75 08                	jne    80373d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803735:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803738:	e9 a5 00 00 00       	jmp    8037e2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80373d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803744:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80374b:	eb 69                	jmp    8037b6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80374d:	a1 20 50 80 00       	mov    0x805020,%eax
  803752:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803758:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80375b:	89 d0                	mov    %edx,%eax
  80375d:	01 c0                	add    %eax,%eax
  80375f:	01 d0                	add    %edx,%eax
  803761:	c1 e0 03             	shl    $0x3,%eax
  803764:	01 c8                	add    %ecx,%eax
  803766:	8a 40 04             	mov    0x4(%eax),%al
  803769:	84 c0                	test   %al,%al
  80376b:	75 46                	jne    8037b3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80376d:	a1 20 50 80 00       	mov    0x805020,%eax
  803772:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803778:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80377b:	89 d0                	mov    %edx,%eax
  80377d:	01 c0                	add    %eax,%eax
  80377f:	01 d0                	add    %edx,%eax
  803781:	c1 e0 03             	shl    $0x3,%eax
  803784:	01 c8                	add    %ecx,%eax
  803786:	8b 00                	mov    (%eax),%eax
  803788:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80378b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80378e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803793:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803798:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80379f:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a2:	01 c8                	add    %ecx,%eax
  8037a4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8037a6:	39 c2                	cmp    %eax,%edx
  8037a8:	75 09                	jne    8037b3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8037aa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8037b1:	eb 15                	jmp    8037c8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037b3:	ff 45 e8             	incl   -0x18(%ebp)
  8037b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8037bb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8037c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c4:	39 c2                	cmp    %eax,%edx
  8037c6:	77 85                	ja     80374d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8037c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037cc:	75 14                	jne    8037e2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8037ce:	83 ec 04             	sub    $0x4,%esp
  8037d1:	68 88 42 80 00       	push   $0x804288
  8037d6:	6a 3a                	push   $0x3a
  8037d8:	68 7c 42 80 00       	push   $0x80427c
  8037dd:	e8 8d fe ff ff       	call   80366f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8037e2:	ff 45 f0             	incl   -0x10(%ebp)
  8037e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8037eb:	0f 8c 2f ff ff ff    	jl     803720 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8037f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8037f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8037ff:	eb 26                	jmp    803827 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803801:	a1 20 50 80 00       	mov    0x805020,%eax
  803806:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80380c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80380f:	89 d0                	mov    %edx,%eax
  803811:	01 c0                	add    %eax,%eax
  803813:	01 d0                	add    %edx,%eax
  803815:	c1 e0 03             	shl    $0x3,%eax
  803818:	01 c8                	add    %ecx,%eax
  80381a:	8a 40 04             	mov    0x4(%eax),%al
  80381d:	3c 01                	cmp    $0x1,%al
  80381f:	75 03                	jne    803824 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803821:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803824:	ff 45 e0             	incl   -0x20(%ebp)
  803827:	a1 20 50 80 00       	mov    0x805020,%eax
  80382c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803832:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803835:	39 c2                	cmp    %eax,%edx
  803837:	77 c8                	ja     803801 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80383f:	74 14                	je     803855 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803841:	83 ec 04             	sub    $0x4,%esp
  803844:	68 dc 42 80 00       	push   $0x8042dc
  803849:	6a 44                	push   $0x44
  80384b:	68 7c 42 80 00       	push   $0x80427c
  803850:	e8 1a fe ff ff       	call   80366f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803855:	90                   	nop
  803856:	c9                   	leave  
  803857:	c3                   	ret    

00803858 <__udivdi3>:
  803858:	55                   	push   %ebp
  803859:	57                   	push   %edi
  80385a:	56                   	push   %esi
  80385b:	53                   	push   %ebx
  80385c:	83 ec 1c             	sub    $0x1c,%esp
  80385f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803863:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803867:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80386b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80386f:	89 ca                	mov    %ecx,%edx
  803871:	89 f8                	mov    %edi,%eax
  803873:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803877:	85 f6                	test   %esi,%esi
  803879:	75 2d                	jne    8038a8 <__udivdi3+0x50>
  80387b:	39 cf                	cmp    %ecx,%edi
  80387d:	77 65                	ja     8038e4 <__udivdi3+0x8c>
  80387f:	89 fd                	mov    %edi,%ebp
  803881:	85 ff                	test   %edi,%edi
  803883:	75 0b                	jne    803890 <__udivdi3+0x38>
  803885:	b8 01 00 00 00       	mov    $0x1,%eax
  80388a:	31 d2                	xor    %edx,%edx
  80388c:	f7 f7                	div    %edi
  80388e:	89 c5                	mov    %eax,%ebp
  803890:	31 d2                	xor    %edx,%edx
  803892:	89 c8                	mov    %ecx,%eax
  803894:	f7 f5                	div    %ebp
  803896:	89 c1                	mov    %eax,%ecx
  803898:	89 d8                	mov    %ebx,%eax
  80389a:	f7 f5                	div    %ebp
  80389c:	89 cf                	mov    %ecx,%edi
  80389e:	89 fa                	mov    %edi,%edx
  8038a0:	83 c4 1c             	add    $0x1c,%esp
  8038a3:	5b                   	pop    %ebx
  8038a4:	5e                   	pop    %esi
  8038a5:	5f                   	pop    %edi
  8038a6:	5d                   	pop    %ebp
  8038a7:	c3                   	ret    
  8038a8:	39 ce                	cmp    %ecx,%esi
  8038aa:	77 28                	ja     8038d4 <__udivdi3+0x7c>
  8038ac:	0f bd fe             	bsr    %esi,%edi
  8038af:	83 f7 1f             	xor    $0x1f,%edi
  8038b2:	75 40                	jne    8038f4 <__udivdi3+0x9c>
  8038b4:	39 ce                	cmp    %ecx,%esi
  8038b6:	72 0a                	jb     8038c2 <__udivdi3+0x6a>
  8038b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038bc:	0f 87 9e 00 00 00    	ja     803960 <__udivdi3+0x108>
  8038c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038c7:	89 fa                	mov    %edi,%edx
  8038c9:	83 c4 1c             	add    $0x1c,%esp
  8038cc:	5b                   	pop    %ebx
  8038cd:	5e                   	pop    %esi
  8038ce:	5f                   	pop    %edi
  8038cf:	5d                   	pop    %ebp
  8038d0:	c3                   	ret    
  8038d1:	8d 76 00             	lea    0x0(%esi),%esi
  8038d4:	31 ff                	xor    %edi,%edi
  8038d6:	31 c0                	xor    %eax,%eax
  8038d8:	89 fa                	mov    %edi,%edx
  8038da:	83 c4 1c             	add    $0x1c,%esp
  8038dd:	5b                   	pop    %ebx
  8038de:	5e                   	pop    %esi
  8038df:	5f                   	pop    %edi
  8038e0:	5d                   	pop    %ebp
  8038e1:	c3                   	ret    
  8038e2:	66 90                	xchg   %ax,%ax
  8038e4:	89 d8                	mov    %ebx,%eax
  8038e6:	f7 f7                	div    %edi
  8038e8:	31 ff                	xor    %edi,%edi
  8038ea:	89 fa                	mov    %edi,%edx
  8038ec:	83 c4 1c             	add    $0x1c,%esp
  8038ef:	5b                   	pop    %ebx
  8038f0:	5e                   	pop    %esi
  8038f1:	5f                   	pop    %edi
  8038f2:	5d                   	pop    %ebp
  8038f3:	c3                   	ret    
  8038f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038f9:	89 eb                	mov    %ebp,%ebx
  8038fb:	29 fb                	sub    %edi,%ebx
  8038fd:	89 f9                	mov    %edi,%ecx
  8038ff:	d3 e6                	shl    %cl,%esi
  803901:	89 c5                	mov    %eax,%ebp
  803903:	88 d9                	mov    %bl,%cl
  803905:	d3 ed                	shr    %cl,%ebp
  803907:	89 e9                	mov    %ebp,%ecx
  803909:	09 f1                	or     %esi,%ecx
  80390b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80390f:	89 f9                	mov    %edi,%ecx
  803911:	d3 e0                	shl    %cl,%eax
  803913:	89 c5                	mov    %eax,%ebp
  803915:	89 d6                	mov    %edx,%esi
  803917:	88 d9                	mov    %bl,%cl
  803919:	d3 ee                	shr    %cl,%esi
  80391b:	89 f9                	mov    %edi,%ecx
  80391d:	d3 e2                	shl    %cl,%edx
  80391f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803923:	88 d9                	mov    %bl,%cl
  803925:	d3 e8                	shr    %cl,%eax
  803927:	09 c2                	or     %eax,%edx
  803929:	89 d0                	mov    %edx,%eax
  80392b:	89 f2                	mov    %esi,%edx
  80392d:	f7 74 24 0c          	divl   0xc(%esp)
  803931:	89 d6                	mov    %edx,%esi
  803933:	89 c3                	mov    %eax,%ebx
  803935:	f7 e5                	mul    %ebp
  803937:	39 d6                	cmp    %edx,%esi
  803939:	72 19                	jb     803954 <__udivdi3+0xfc>
  80393b:	74 0b                	je     803948 <__udivdi3+0xf0>
  80393d:	89 d8                	mov    %ebx,%eax
  80393f:	31 ff                	xor    %edi,%edi
  803941:	e9 58 ff ff ff       	jmp    80389e <__udivdi3+0x46>
  803946:	66 90                	xchg   %ax,%ax
  803948:	8b 54 24 08          	mov    0x8(%esp),%edx
  80394c:	89 f9                	mov    %edi,%ecx
  80394e:	d3 e2                	shl    %cl,%edx
  803950:	39 c2                	cmp    %eax,%edx
  803952:	73 e9                	jae    80393d <__udivdi3+0xe5>
  803954:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803957:	31 ff                	xor    %edi,%edi
  803959:	e9 40 ff ff ff       	jmp    80389e <__udivdi3+0x46>
  80395e:	66 90                	xchg   %ax,%ax
  803960:	31 c0                	xor    %eax,%eax
  803962:	e9 37 ff ff ff       	jmp    80389e <__udivdi3+0x46>
  803967:	90                   	nop

00803968 <__umoddi3>:
  803968:	55                   	push   %ebp
  803969:	57                   	push   %edi
  80396a:	56                   	push   %esi
  80396b:	53                   	push   %ebx
  80396c:	83 ec 1c             	sub    $0x1c,%esp
  80396f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803973:	8b 74 24 34          	mov    0x34(%esp),%esi
  803977:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80397b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80397f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803983:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803987:	89 f3                	mov    %esi,%ebx
  803989:	89 fa                	mov    %edi,%edx
  80398b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80398f:	89 34 24             	mov    %esi,(%esp)
  803992:	85 c0                	test   %eax,%eax
  803994:	75 1a                	jne    8039b0 <__umoddi3+0x48>
  803996:	39 f7                	cmp    %esi,%edi
  803998:	0f 86 a2 00 00 00    	jbe    803a40 <__umoddi3+0xd8>
  80399e:	89 c8                	mov    %ecx,%eax
  8039a0:	89 f2                	mov    %esi,%edx
  8039a2:	f7 f7                	div    %edi
  8039a4:	89 d0                	mov    %edx,%eax
  8039a6:	31 d2                	xor    %edx,%edx
  8039a8:	83 c4 1c             	add    $0x1c,%esp
  8039ab:	5b                   	pop    %ebx
  8039ac:	5e                   	pop    %esi
  8039ad:	5f                   	pop    %edi
  8039ae:	5d                   	pop    %ebp
  8039af:	c3                   	ret    
  8039b0:	39 f0                	cmp    %esi,%eax
  8039b2:	0f 87 ac 00 00 00    	ja     803a64 <__umoddi3+0xfc>
  8039b8:	0f bd e8             	bsr    %eax,%ebp
  8039bb:	83 f5 1f             	xor    $0x1f,%ebp
  8039be:	0f 84 ac 00 00 00    	je     803a70 <__umoddi3+0x108>
  8039c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8039c9:	29 ef                	sub    %ebp,%edi
  8039cb:	89 fe                	mov    %edi,%esi
  8039cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039d1:	89 e9                	mov    %ebp,%ecx
  8039d3:	d3 e0                	shl    %cl,%eax
  8039d5:	89 d7                	mov    %edx,%edi
  8039d7:	89 f1                	mov    %esi,%ecx
  8039d9:	d3 ef                	shr    %cl,%edi
  8039db:	09 c7                	or     %eax,%edi
  8039dd:	89 e9                	mov    %ebp,%ecx
  8039df:	d3 e2                	shl    %cl,%edx
  8039e1:	89 14 24             	mov    %edx,(%esp)
  8039e4:	89 d8                	mov    %ebx,%eax
  8039e6:	d3 e0                	shl    %cl,%eax
  8039e8:	89 c2                	mov    %eax,%edx
  8039ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039ee:	d3 e0                	shl    %cl,%eax
  8039f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039f8:	89 f1                	mov    %esi,%ecx
  8039fa:	d3 e8                	shr    %cl,%eax
  8039fc:	09 d0                	or     %edx,%eax
  8039fe:	d3 eb                	shr    %cl,%ebx
  803a00:	89 da                	mov    %ebx,%edx
  803a02:	f7 f7                	div    %edi
  803a04:	89 d3                	mov    %edx,%ebx
  803a06:	f7 24 24             	mull   (%esp)
  803a09:	89 c6                	mov    %eax,%esi
  803a0b:	89 d1                	mov    %edx,%ecx
  803a0d:	39 d3                	cmp    %edx,%ebx
  803a0f:	0f 82 87 00 00 00    	jb     803a9c <__umoddi3+0x134>
  803a15:	0f 84 91 00 00 00    	je     803aac <__umoddi3+0x144>
  803a1b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a1f:	29 f2                	sub    %esi,%edx
  803a21:	19 cb                	sbb    %ecx,%ebx
  803a23:	89 d8                	mov    %ebx,%eax
  803a25:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a29:	d3 e0                	shl    %cl,%eax
  803a2b:	89 e9                	mov    %ebp,%ecx
  803a2d:	d3 ea                	shr    %cl,%edx
  803a2f:	09 d0                	or     %edx,%eax
  803a31:	89 e9                	mov    %ebp,%ecx
  803a33:	d3 eb                	shr    %cl,%ebx
  803a35:	89 da                	mov    %ebx,%edx
  803a37:	83 c4 1c             	add    $0x1c,%esp
  803a3a:	5b                   	pop    %ebx
  803a3b:	5e                   	pop    %esi
  803a3c:	5f                   	pop    %edi
  803a3d:	5d                   	pop    %ebp
  803a3e:	c3                   	ret    
  803a3f:	90                   	nop
  803a40:	89 fd                	mov    %edi,%ebp
  803a42:	85 ff                	test   %edi,%edi
  803a44:	75 0b                	jne    803a51 <__umoddi3+0xe9>
  803a46:	b8 01 00 00 00       	mov    $0x1,%eax
  803a4b:	31 d2                	xor    %edx,%edx
  803a4d:	f7 f7                	div    %edi
  803a4f:	89 c5                	mov    %eax,%ebp
  803a51:	89 f0                	mov    %esi,%eax
  803a53:	31 d2                	xor    %edx,%edx
  803a55:	f7 f5                	div    %ebp
  803a57:	89 c8                	mov    %ecx,%eax
  803a59:	f7 f5                	div    %ebp
  803a5b:	89 d0                	mov    %edx,%eax
  803a5d:	e9 44 ff ff ff       	jmp    8039a6 <__umoddi3+0x3e>
  803a62:	66 90                	xchg   %ax,%ax
  803a64:	89 c8                	mov    %ecx,%eax
  803a66:	89 f2                	mov    %esi,%edx
  803a68:	83 c4 1c             	add    $0x1c,%esp
  803a6b:	5b                   	pop    %ebx
  803a6c:	5e                   	pop    %esi
  803a6d:	5f                   	pop    %edi
  803a6e:	5d                   	pop    %ebp
  803a6f:	c3                   	ret    
  803a70:	3b 04 24             	cmp    (%esp),%eax
  803a73:	72 06                	jb     803a7b <__umoddi3+0x113>
  803a75:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a79:	77 0f                	ja     803a8a <__umoddi3+0x122>
  803a7b:	89 f2                	mov    %esi,%edx
  803a7d:	29 f9                	sub    %edi,%ecx
  803a7f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a83:	89 14 24             	mov    %edx,(%esp)
  803a86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a8a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a8e:	8b 14 24             	mov    (%esp),%edx
  803a91:	83 c4 1c             	add    $0x1c,%esp
  803a94:	5b                   	pop    %ebx
  803a95:	5e                   	pop    %esi
  803a96:	5f                   	pop    %edi
  803a97:	5d                   	pop    %ebp
  803a98:	c3                   	ret    
  803a99:	8d 76 00             	lea    0x0(%esi),%esi
  803a9c:	2b 04 24             	sub    (%esp),%eax
  803a9f:	19 fa                	sbb    %edi,%edx
  803aa1:	89 d1                	mov    %edx,%ecx
  803aa3:	89 c6                	mov    %eax,%esi
  803aa5:	e9 71 ff ff ff       	jmp    803a1b <__umoddi3+0xb3>
  803aaa:	66 90                	xchg   %ax,%ax
  803aac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ab0:	72 ea                	jb     803a9c <__umoddi3+0x134>
  803ab2:	89 d9                	mov    %ebx,%ecx
  803ab4:	e9 62 ff ff ff       	jmp    803a1b <__umoddi3+0xb3>
