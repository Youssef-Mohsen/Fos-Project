
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
  80005c:	68 20 3c 80 00       	push   $0x803c20
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
  8000b9:	68 33 3c 80 00       	push   $0x803c33
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
  80010f:	68 33 3c 80 00       	push   $0x803c33
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
  80013e:	e8 ab 18 00 00       	call   8019ee <sys_getenvindex>
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
  8001ac:	e8 c1 15 00 00       	call   801772 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 58 3c 80 00       	push   $0x803c58
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
  8001dc:	68 80 3c 80 00       	push   $0x803c80
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
  80020d:	68 a8 3c 80 00       	push   $0x803ca8
  800212:	e8 34 01 00 00       	call   80034b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 00 3d 80 00       	push   $0x803d00
  80022e:	e8 18 01 00 00       	call   80034b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 58 3c 80 00       	push   $0x803c58
  80023e:	e8 08 01 00 00       	call   80034b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800246:	e8 41 15 00 00       	call   80178c <sys_unlock_cons>
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
  80025e:	e8 57 17 00 00       	call   8019ba <sys_destroy_env>
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
  80026f:	e8 ac 17 00 00       	call   801a20 <sys_exit_env>
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
  8002a2:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  8002bd:	e8 6e 14 00 00       	call   801730 <sys_cputs>
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
  800317:	a0 2c 50 80 00       	mov    0x80502c,%al
  80031c:	0f b6 c0             	movzbl %al,%eax
  80031f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	50                   	push   %eax
  800329:	52                   	push   %edx
  80032a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800330:	83 c0 08             	add    $0x8,%eax
  800333:	50                   	push   %eax
  800334:	e8 f7 13 00 00       	call   801730 <sys_cputs>
  800339:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80033c:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  800351:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  80037e:	e8 ef 13 00 00       	call   801772 <sys_lock_cons>
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
  80039e:	e8 e9 13 00 00       	call   80178c <sys_unlock_cons>
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
  8003e8:	e8 c3 35 00 00       	call   8039b0 <__udivdi3>
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
  800438:	e8 83 36 00 00       	call   803ac0 <__umoddi3>
  80043d:	83 c4 10             	add    $0x10,%esp
  800440:	05 34 3f 80 00       	add    $0x803f34,%eax
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
  800593:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
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
  800674:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  80067b:	85 f6                	test   %esi,%esi
  80067d:	75 19                	jne    800698 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067f:	53                   	push   %ebx
  800680:	68 45 3f 80 00       	push   $0x803f45
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
  800699:	68 4e 3f 80 00       	push   $0x803f4e
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
  8006c6:	be 51 3f 80 00       	mov    $0x803f51,%esi
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
  8008be:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  8008c5:	eb 2c                	jmp    8008f3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008c7:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  8010d1:	68 c8 40 80 00       	push   $0x8040c8
  8010d6:	68 3f 01 00 00       	push   $0x13f
  8010db:	68 ea 40 80 00       	push   $0x8040ea
  8010e0:	e8 e2 26 00 00       	call   8037c7 <_panic>

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
  8010f1:	e8 e5 0b 00 00       	call   801cdb <sys_sbrk>
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
  80116c:	e8 ee 09 00 00       	call   801b5f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801171:	85 c0                	test   %eax,%eax
  801173:	74 16                	je     80118b <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  801175:	83 ec 0c             	sub    $0xc,%esp
  801178:	ff 75 08             	pushl  0x8(%ebp)
  80117b:	e8 2e 0f 00 00       	call   8020ae <alloc_block_FF>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801186:	e9 8a 01 00 00       	jmp    801315 <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  80118b:	e8 00 0a 00 00       	call   801b90 <sys_isUHeapPlacementStrategyBESTFIT>
  801190:	85 c0                	test   %eax,%eax
  801192:	0f 84 7d 01 00 00    	je     801315 <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801198:	83 ec 0c             	sub    $0xc,%esp
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	e8 c7 13 00 00       	call   80256a <alloc_block_BF>
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
  8011ee:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  80123b:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  801292:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  8012f4:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8012fb:	83 ec 08             	sub    $0x8,%esp
  8012fe:	ff 75 08             	pushl  0x8(%ebp)
  801301:	ff 75 f0             	pushl  -0x10(%ebp)
  801304:	e8 09 0a 00 00       	call   801d12 <sys_allocate_user_mem>
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
  80134c:	e8 dd 09 00 00       	call   801d2e <get_block_size>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	ff 75 08             	pushl  0x8(%ebp)
  80135d:	e8 10 1c 00 00       	call   802f72 <free_block>
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
  801397:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
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
  8013d4:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  8013db:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  8013df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	83 ec 08             	sub    $0x8,%esp
  8013e8:	52                   	push   %edx
  8013e9:	50                   	push   %eax
  8013ea:	e8 07 09 00 00       	call   801cf6 <sys_free_user_mem>
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
  801402:	68 f8 40 80 00       	push   $0x8040f8
  801407:	68 88 00 00 00       	push   $0x88
  80140c:	68 22 41 80 00       	push   $0x804122
  801411:	e8 b1 23 00 00       	call   8037c7 <_panic>
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
  801430:	e9 ec 00 00 00       	jmp    801521 <smalloc+0x108>
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
  801461:	75 0a                	jne    80146d <smalloc+0x54>
  801463:	b8 00 00 00 00       	mov    $0x0,%eax
  801468:	e9 b4 00 00 00       	jmp    801521 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80146d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801471:	ff 75 ec             	pushl  -0x14(%ebp)
  801474:	50                   	push   %eax
  801475:	ff 75 0c             	pushl  0xc(%ebp)
  801478:	ff 75 08             	pushl  0x8(%ebp)
  80147b:	e8 7d 04 00 00       	call   8018fd <sys_createSharedObject>
  801480:	83 c4 10             	add    $0x10,%esp
  801483:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801486:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80148a:	74 06                	je     801492 <smalloc+0x79>
  80148c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801490:	75 0a                	jne    80149c <smalloc+0x83>
  801492:	b8 00 00 00 00       	mov    $0x0,%eax
  801497:	e9 85 00 00 00       	jmp    801521 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  80149c:	83 ec 08             	sub    $0x8,%esp
  80149f:	ff 75 ec             	pushl  -0x14(%ebp)
  8014a2:	68 2e 41 80 00       	push   $0x80412e
  8014a7:	e8 9f ee ff ff       	call   80034b <cprintf>
  8014ac:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  8014af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8014b7:	8b 40 78             	mov    0x78(%eax),%eax
  8014ba:	29 c2                	sub    %eax,%edx
  8014bc:	89 d0                	mov    %edx,%eax
  8014be:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014c3:	c1 e8 0c             	shr    $0xc,%eax
  8014c6:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8014cc:	42                   	inc    %edx
  8014cd:	89 15 24 50 80 00    	mov    %edx,0x805024
  8014d3:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8014d9:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8014e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014e3:	a1 20 50 80 00       	mov    0x805020,%eax
  8014e8:	8b 40 78             	mov    0x78(%eax),%eax
  8014eb:	29 c2                	sub    %eax,%edx
  8014ed:	89 d0                	mov    %edx,%eax
  8014ef:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014f4:	c1 e8 0c             	shr    $0xc,%eax
  8014f7:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8014fe:	a1 20 50 80 00       	mov    0x805020,%eax
  801503:	8b 50 10             	mov    0x10(%eax),%edx
  801506:	89 c8                	mov    %ecx,%eax
  801508:	c1 e0 02             	shl    $0x2,%eax
  80150b:	89 c1                	mov    %eax,%ecx
  80150d:	c1 e1 09             	shl    $0x9,%ecx
  801510:	01 c8                	add    %ecx,%eax
  801512:	01 c2                	add    %eax,%edx
  801514:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801517:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  80151e:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801529:	83 ec 08             	sub    $0x8,%esp
  80152c:	ff 75 0c             	pushl  0xc(%ebp)
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 f0 03 00 00       	call   801927 <sys_getSizeOfSharedObject>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  80153d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801541:	75 0a                	jne    80154d <sget+0x2a>
  801543:	b8 00 00 00 00       	mov    $0x0,%eax
  801548:	e9 e7 00 00 00       	jmp    801634 <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80154d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801550:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801553:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80155a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80155d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801560:	39 d0                	cmp    %edx,%eax
  801562:	73 02                	jae    801566 <sget+0x43>
  801564:	89 d0                	mov    %edx,%eax
  801566:	83 ec 0c             	sub    $0xc,%esp
  801569:	50                   	push   %eax
  80156a:	e8 8c fb ff ff       	call   8010fb <malloc>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  801575:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801579:	75 0a                	jne    801585 <sget+0x62>
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
  801580:	e9 af 00 00 00       	jmp    801634 <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	ff 75 e8             	pushl  -0x18(%ebp)
  80158b:	ff 75 0c             	pushl  0xc(%ebp)
  80158e:	ff 75 08             	pushl  0x8(%ebp)
  801591:	e8 ae 03 00 00       	call   801944 <sys_getSharedObject>
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  80159c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80159f:	a1 20 50 80 00       	mov    0x805020,%eax
  8015a4:	8b 40 78             	mov    0x78(%eax),%eax
  8015a7:	29 c2                	sub    %eax,%edx
  8015a9:	89 d0                	mov    %edx,%eax
  8015ab:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015b0:	c1 e8 0c             	shr    $0xc,%eax
  8015b3:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8015b9:	42                   	inc    %edx
  8015ba:	89 15 24 50 80 00    	mov    %edx,0x805024
  8015c0:	8b 15 24 50 80 00    	mov    0x805024,%edx
  8015c6:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  8015cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8015d5:	8b 40 78             	mov    0x78(%eax),%eax
  8015d8:	29 c2                	sub    %eax,%edx
  8015da:	89 d0                	mov    %edx,%eax
  8015dc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015e1:	c1 e8 0c             	shr    $0xc,%eax
  8015e4:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8015eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8015f0:	8b 50 10             	mov    0x10(%eax),%edx
  8015f3:	89 c8                	mov    %ecx,%eax
  8015f5:	c1 e0 02             	shl    $0x2,%eax
  8015f8:	89 c1                	mov    %eax,%ecx
  8015fa:	c1 e1 09             	shl    $0x9,%ecx
  8015fd:	01 c8                	add    %ecx,%eax
  8015ff:	01 c2                	add    %eax,%edx
  801601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801604:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  80160b:	a1 20 50 80 00       	mov    0x805020,%eax
  801610:	8b 40 10             	mov    0x10(%eax),%eax
  801613:	83 ec 08             	sub    $0x8,%esp
  801616:	50                   	push   %eax
  801617:	68 3d 41 80 00       	push   $0x80413d
  80161c:	e8 2a ed ff ff       	call   80034b <cprintf>
  801621:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  801624:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801628:	75 07                	jne    801631 <sget+0x10e>
  80162a:	b8 00 00 00 00       	mov    $0x0,%eax
  80162f:	eb 03                	jmp    801634 <sget+0x111>
	return ptr;
  801631:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  80163c:	8b 55 08             	mov    0x8(%ebp),%edx
  80163f:	a1 20 50 80 00       	mov    0x805020,%eax
  801644:	8b 40 78             	mov    0x78(%eax),%eax
  801647:	29 c2                	sub    %eax,%edx
  801649:	89 d0                	mov    %edx,%eax
  80164b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801650:	c1 e8 0c             	shr    $0xc,%eax
  801653:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  80165a:	a1 20 50 80 00       	mov    0x805020,%eax
  80165f:	8b 50 10             	mov    0x10(%eax),%edx
  801662:	89 c8                	mov    %ecx,%eax
  801664:	c1 e0 02             	shl    $0x2,%eax
  801667:	89 c1                	mov    %eax,%ecx
  801669:	c1 e1 09             	shl    $0x9,%ecx
  80166c:	01 c8                	add    %ecx,%eax
  80166e:	01 d0                	add    %edx,%eax
  801670:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801677:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  80167a:	83 ec 08             	sub    $0x8,%esp
  80167d:	ff 75 08             	pushl  0x8(%ebp)
  801680:	ff 75 f4             	pushl  -0xc(%ebp)
  801683:	e8 db 02 00 00       	call   801963 <sys_freeSharedObject>
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80168e:	90                   	nop
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801697:	83 ec 04             	sub    $0x4,%esp
  80169a:	68 4c 41 80 00       	push   $0x80414c
  80169f:	68 e5 00 00 00       	push   $0xe5
  8016a4:	68 22 41 80 00       	push   $0x804122
  8016a9:	e8 19 21 00 00       	call   8037c7 <_panic>

008016ae <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016b4:	83 ec 04             	sub    $0x4,%esp
  8016b7:	68 72 41 80 00       	push   $0x804172
  8016bc:	68 f1 00 00 00       	push   $0xf1
  8016c1:	68 22 41 80 00       	push   $0x804122
  8016c6:	e8 fc 20 00 00       	call   8037c7 <_panic>

008016cb <shrink>:

}
void shrink(uint32 newSize)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	68 72 41 80 00       	push   $0x804172
  8016d9:	68 f6 00 00 00       	push   $0xf6
  8016de:	68 22 41 80 00       	push   $0x804122
  8016e3:	e8 df 20 00 00       	call   8037c7 <_panic>

008016e8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	68 72 41 80 00       	push   $0x804172
  8016f6:	68 fb 00 00 00       	push   $0xfb
  8016fb:	68 22 41 80 00       	push   $0x804122
  801700:	e8 c2 20 00 00       	call   8037c7 <_panic>

00801705 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	57                   	push   %edi
  801709:	56                   	push   %esi
  80170a:	53                   	push   %ebx
  80170b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	8b 55 0c             	mov    0xc(%ebp),%edx
  801714:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801717:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80171a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80171d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801720:	cd 30                	int    $0x30
  801722:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801725:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	5b                   	pop    %ebx
  80172c:	5e                   	pop    %esi
  80172d:	5f                   	pop    %edi
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    

00801730 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	8b 45 10             	mov    0x10(%ebp),%eax
  801739:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80173c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	52                   	push   %edx
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	50                   	push   %eax
  80174c:	6a 00                	push   $0x0
  80174e:	e8 b2 ff ff ff       	call   801705 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	90                   	nop
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_cgetc>:

int
sys_cgetc(void)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 02                	push   $0x2
  801768:	e8 98 ff ff ff       	call   801705 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 03                	push   $0x3
  801781:	e8 7f ff ff ff       	call   801705 <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	90                   	nop
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 04                	push   $0x4
  80179b:	e8 65 ff ff ff       	call   801705 <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	90                   	nop
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	52                   	push   %edx
  8017b6:	50                   	push   %eax
  8017b7:	6a 08                	push   $0x8
  8017b9:	e8 47 ff ff ff       	call   801705 <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	56                   	push   %esi
  8017c7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017c8:	8b 75 18             	mov    0x18(%ebp),%esi
  8017cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	56                   	push   %esi
  8017d8:	53                   	push   %ebx
  8017d9:	51                   	push   %ecx
  8017da:	52                   	push   %edx
  8017db:	50                   	push   %eax
  8017dc:	6a 09                	push   $0x9
  8017de:	e8 22 ff ff ff       	call   801705 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e9:	5b                   	pop    %ebx
  8017ea:	5e                   	pop    %esi
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    

008017ed <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	52                   	push   %edx
  8017fd:	50                   	push   %eax
  8017fe:	6a 0a                	push   $0xa
  801800:	e8 00 ff ff ff       	call   801705 <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	6a 0b                	push   $0xb
  80181b:	e8 e5 fe ff ff       	call   801705 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 0c                	push   $0xc
  801834:	e8 cc fe ff ff       	call   801705 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 0d                	push   $0xd
  80184d:	e8 b3 fe ff ff       	call   801705 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 0e                	push   $0xe
  801866:	e8 9a fe ff ff       	call   801705 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 0f                	push   $0xf
  80187f:	e8 81 fe ff ff       	call   801705 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	ff 75 08             	pushl  0x8(%ebp)
  801897:	6a 10                	push   $0x10
  801899:	e8 67 fe ff ff       	call   801705 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 11                	push   $0x11
  8018b2:	e8 4e fe ff ff       	call   801705 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	90                   	nop
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_cputc>:

void
sys_cputc(const char c)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018c9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	50                   	push   %eax
  8018d6:	6a 01                	push   $0x1
  8018d8:	e8 28 fe ff ff       	call   801705 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	90                   	nop
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 14                	push   $0x14
  8018f2:	e8 0e fe ff ff       	call   801705 <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	90                   	nop
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	83 ec 04             	sub    $0x4,%esp
  801903:	8b 45 10             	mov    0x10(%ebp),%eax
  801906:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801909:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80190c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	6a 00                	push   $0x0
  801915:	51                   	push   %ecx
  801916:	52                   	push   %edx
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	50                   	push   %eax
  80191b:	6a 15                	push   $0x15
  80191d:	e8 e3 fd ff ff       	call   801705 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80192a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	6a 16                	push   $0x16
  80193a:	e8 c6 fd ff ff       	call   801705 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801947:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	51                   	push   %ecx
  801955:	52                   	push   %edx
  801956:	50                   	push   %eax
  801957:	6a 17                	push   $0x17
  801959:	e8 a7 fd ff ff       	call   801705 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801966:	8b 55 0c             	mov    0xc(%ebp),%edx
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	52                   	push   %edx
  801973:	50                   	push   %eax
  801974:	6a 18                	push   $0x18
  801976:	e8 8a fd ff ff       	call   801705 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	6a 00                	push   $0x0
  801988:	ff 75 14             	pushl  0x14(%ebp)
  80198b:	ff 75 10             	pushl  0x10(%ebp)
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	50                   	push   %eax
  801992:	6a 19                	push   $0x19
  801994:	e8 6c fd ff ff       	call   801705 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	50                   	push   %eax
  8019ad:	6a 1a                	push   $0x1a
  8019af:	e8 51 fd ff ff       	call   801705 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	90                   	nop
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	50                   	push   %eax
  8019c9:	6a 1b                	push   $0x1b
  8019cb:	e8 35 fd ff ff       	call   801705 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 05                	push   $0x5
  8019e4:	e8 1c fd ff ff       	call   801705 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 06                	push   $0x6
  8019fd:	e8 03 fd ff ff       	call   801705 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 07                	push   $0x7
  801a16:	e8 ea fc ff ff       	call   801705 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_exit_env>:


void sys_exit_env(void)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 1c                	push   $0x1c
  801a2f:	e8 d1 fc ff ff       	call   801705 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
}
  801a37:	90                   	nop
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a40:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a43:	8d 50 04             	lea    0x4(%eax),%edx
  801a46:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	52                   	push   %edx
  801a50:	50                   	push   %eax
  801a51:	6a 1d                	push   $0x1d
  801a53:	e8 ad fc ff ff       	call   801705 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
	return result;
  801a5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a64:	89 01                	mov    %eax,(%ecx)
  801a66:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	c9                   	leave  
  801a6d:	c2 04 00             	ret    $0x4

00801a70 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	ff 75 10             	pushl  0x10(%ebp)
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	ff 75 08             	pushl  0x8(%ebp)
  801a80:	6a 13                	push   $0x13
  801a82:	e8 7e fc ff ff       	call   801705 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8a:	90                   	nop
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_rcr2>:
uint32 sys_rcr2()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 1e                	push   $0x1e
  801a9c:	e8 64 fc ff ff       	call   801705 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ab2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	50                   	push   %eax
  801abf:	6a 1f                	push   $0x1f
  801ac1:	e8 3f fc ff ff       	call   801705 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac9:	90                   	nop
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <rsttst>:
void rsttst()
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 21                	push   $0x21
  801adb:	e8 25 fc ff ff       	call   801705 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae3:	90                   	nop
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 04             	sub    $0x4,%esp
  801aec:	8b 45 14             	mov    0x14(%ebp),%eax
  801aef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801af2:	8b 55 18             	mov    0x18(%ebp),%edx
  801af5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801af9:	52                   	push   %edx
  801afa:	50                   	push   %eax
  801afb:	ff 75 10             	pushl  0x10(%ebp)
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	ff 75 08             	pushl  0x8(%ebp)
  801b04:	6a 20                	push   $0x20
  801b06:	e8 fa fb ff ff       	call   801705 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0e:	90                   	nop
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <chktst>:
void chktst(uint32 n)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	ff 75 08             	pushl  0x8(%ebp)
  801b1f:	6a 22                	push   $0x22
  801b21:	e8 df fb ff ff       	call   801705 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
	return ;
  801b29:	90                   	nop
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <inctst>:

void inctst()
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 23                	push   $0x23
  801b3b:	e8 c5 fb ff ff       	call   801705 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
	return ;
  801b43:	90                   	nop
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <gettst>:
uint32 gettst()
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 24                	push   $0x24
  801b55:	e8 ab fb ff ff       	call   801705 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 25                	push   $0x25
  801b71:	e8 8f fb ff ff       	call   801705 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
  801b79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b7c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b80:	75 07                	jne    801b89 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b82:	b8 01 00 00 00       	mov    $0x1,%eax
  801b87:	eb 05                	jmp    801b8e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 25                	push   $0x25
  801ba2:	e8 5e fb ff ff       	call   801705 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
  801baa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bad:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bb1:	75 07                	jne    801bba <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bb3:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb8:	eb 05                	jmp    801bbf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 25                	push   $0x25
  801bd3:	e8 2d fb ff ff       	call   801705 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
  801bdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bde:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801be2:	75 07                	jne    801beb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801be4:	b8 01 00 00 00       	mov    $0x1,%eax
  801be9:	eb 05                	jmp    801bf0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 25                	push   $0x25
  801c04:	e8 fc fa ff ff       	call   801705 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
  801c0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c0f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c13:	75 07                	jne    801c1c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c15:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1a:	eb 05                	jmp    801c21 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	ff 75 08             	pushl  0x8(%ebp)
  801c31:	6a 26                	push   $0x26
  801c33:	e8 cd fa ff ff       	call   801705 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3b:	90                   	nop
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c42:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	6a 00                	push   $0x0
  801c50:	53                   	push   %ebx
  801c51:	51                   	push   %ecx
  801c52:	52                   	push   %edx
  801c53:	50                   	push   %eax
  801c54:	6a 27                	push   $0x27
  801c56:	e8 aa fa ff ff       	call   801705 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	52                   	push   %edx
  801c73:	50                   	push   %eax
  801c74:	6a 28                	push   $0x28
  801c76:	e8 8a fa ff ff       	call   801705 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c83:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	51                   	push   %ecx
  801c8f:	ff 75 10             	pushl  0x10(%ebp)
  801c92:	52                   	push   %edx
  801c93:	50                   	push   %eax
  801c94:	6a 29                	push   $0x29
  801c96:	e8 6a fa ff ff       	call   801705 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	ff 75 10             	pushl  0x10(%ebp)
  801caa:	ff 75 0c             	pushl  0xc(%ebp)
  801cad:	ff 75 08             	pushl  0x8(%ebp)
  801cb0:	6a 12                	push   $0x12
  801cb2:	e8 4e fa ff ff       	call   801705 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cba:	90                   	nop
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	52                   	push   %edx
  801ccd:	50                   	push   %eax
  801cce:	6a 2a                	push   $0x2a
  801cd0:	e8 30 fa ff ff       	call   801705 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
	return;
  801cd8:	90                   	nop
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	50                   	push   %eax
  801cea:	6a 2b                	push   $0x2b
  801cec:	e8 14 fa ff ff       	call   801705 <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	ff 75 0c             	pushl  0xc(%ebp)
  801d02:	ff 75 08             	pushl  0x8(%ebp)
  801d05:	6a 2c                	push   $0x2c
  801d07:	e8 f9 f9 ff ff       	call   801705 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
	return;
  801d0f:	90                   	nop
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	ff 75 0c             	pushl  0xc(%ebp)
  801d1e:	ff 75 08             	pushl  0x8(%ebp)
  801d21:	6a 2d                	push   $0x2d
  801d23:	e8 dd f9 ff ff       	call   801705 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
	return;
  801d2b:	90                   	nop
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	83 e8 04             	sub    $0x4,%eax
  801d3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d40:	8b 00                	mov    (%eax),%eax
  801d42:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	83 e8 04             	sub    $0x4,%eax
  801d53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d59:	8b 00                	mov    (%eax),%eax
  801d5b:	83 e0 01             	and    $0x1,%eax
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	0f 94 c0             	sete   %al
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801d6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d75:	83 f8 02             	cmp    $0x2,%eax
  801d78:	74 2b                	je     801da5 <alloc_block+0x40>
  801d7a:	83 f8 02             	cmp    $0x2,%eax
  801d7d:	7f 07                	jg     801d86 <alloc_block+0x21>
  801d7f:	83 f8 01             	cmp    $0x1,%eax
  801d82:	74 0e                	je     801d92 <alloc_block+0x2d>
  801d84:	eb 58                	jmp    801dde <alloc_block+0x79>
  801d86:	83 f8 03             	cmp    $0x3,%eax
  801d89:	74 2d                	je     801db8 <alloc_block+0x53>
  801d8b:	83 f8 04             	cmp    $0x4,%eax
  801d8e:	74 3b                	je     801dcb <alloc_block+0x66>
  801d90:	eb 4c                	jmp    801dde <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801d92:	83 ec 0c             	sub    $0xc,%esp
  801d95:	ff 75 08             	pushl  0x8(%ebp)
  801d98:	e8 11 03 00 00       	call   8020ae <alloc_block_FF>
  801d9d:	83 c4 10             	add    $0x10,%esp
  801da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801da3:	eb 4a                	jmp    801def <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801da5:	83 ec 0c             	sub    $0xc,%esp
  801da8:	ff 75 08             	pushl  0x8(%ebp)
  801dab:	e8 fa 19 00 00       	call   8037aa <alloc_block_NF>
  801db0:	83 c4 10             	add    $0x10,%esp
  801db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801db6:	eb 37                	jmp    801def <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801db8:	83 ec 0c             	sub    $0xc,%esp
  801dbb:	ff 75 08             	pushl  0x8(%ebp)
  801dbe:	e8 a7 07 00 00       	call   80256a <alloc_block_BF>
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801dc9:	eb 24                	jmp    801def <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	ff 75 08             	pushl  0x8(%ebp)
  801dd1:	e8 b7 19 00 00       	call   80378d <alloc_block_WF>
  801dd6:	83 c4 10             	add    $0x10,%esp
  801dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ddc:	eb 11                	jmp    801def <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801dde:	83 ec 0c             	sub    $0xc,%esp
  801de1:	68 84 41 80 00       	push   $0x804184
  801de6:	e8 60 e5 ff ff       	call   80034b <cprintf>
  801deb:	83 c4 10             	add    $0x10,%esp
		break;
  801dee:	90                   	nop
	}
	return va;
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	53                   	push   %ebx
  801df8:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801dfb:	83 ec 0c             	sub    $0xc,%esp
  801dfe:	68 a4 41 80 00       	push   $0x8041a4
  801e03:	e8 43 e5 ff ff       	call   80034b <cprintf>
  801e08:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e0b:	83 ec 0c             	sub    $0xc,%esp
  801e0e:	68 cf 41 80 00       	push   $0x8041cf
  801e13:	e8 33 e5 ff ff       	call   80034b <cprintf>
  801e18:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e21:	eb 37                	jmp    801e5a <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e23:	83 ec 0c             	sub    $0xc,%esp
  801e26:	ff 75 f4             	pushl  -0xc(%ebp)
  801e29:	e8 19 ff ff ff       	call   801d47 <is_free_block>
  801e2e:	83 c4 10             	add    $0x10,%esp
  801e31:	0f be d8             	movsbl %al,%ebx
  801e34:	83 ec 0c             	sub    $0xc,%esp
  801e37:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3a:	e8 ef fe ff ff       	call   801d2e <get_block_size>
  801e3f:	83 c4 10             	add    $0x10,%esp
  801e42:	83 ec 04             	sub    $0x4,%esp
  801e45:	53                   	push   %ebx
  801e46:	50                   	push   %eax
  801e47:	68 e7 41 80 00       	push   $0x8041e7
  801e4c:	e8 fa e4 ff ff       	call   80034b <cprintf>
  801e51:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801e54:	8b 45 10             	mov    0x10(%ebp),%eax
  801e57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5e:	74 07                	je     801e67 <print_blocks_list+0x73>
  801e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e63:	8b 00                	mov    (%eax),%eax
  801e65:	eb 05                	jmp    801e6c <print_blocks_list+0x78>
  801e67:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6c:	89 45 10             	mov    %eax,0x10(%ebp)
  801e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e72:	85 c0                	test   %eax,%eax
  801e74:	75 ad                	jne    801e23 <print_blocks_list+0x2f>
  801e76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e7a:	75 a7                	jne    801e23 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801e7c:	83 ec 0c             	sub    $0xc,%esp
  801e7f:	68 a4 41 80 00       	push   $0x8041a4
  801e84:	e8 c2 e4 ff ff       	call   80034b <cprintf>
  801e89:	83 c4 10             	add    $0x10,%esp

}
  801e8c:	90                   	nop
  801e8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9b:	83 e0 01             	and    $0x1,%eax
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	74 03                	je     801ea5 <initialize_dynamic_allocator+0x13>
  801ea2:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801ea5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ea9:	0f 84 c7 01 00 00    	je     802076 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801eaf:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  801eb6:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  801ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebf:	01 d0                	add    %edx,%eax
  801ec1:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801ec6:	0f 87 ad 01 00 00    	ja     802079 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	0f 89 a5 01 00 00    	jns    80207c <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  801eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edd:	01 d0                	add    %edx,%eax
  801edf:	83 e8 04             	sub    $0x4,%eax
  801ee2:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  801ee7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801eee:	a1 30 50 80 00       	mov    0x805030,%eax
  801ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef6:	e9 87 00 00 00       	jmp    801f82 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801efb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eff:	75 14                	jne    801f15 <initialize_dynamic_allocator+0x83>
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	68 ff 41 80 00       	push   $0x8041ff
  801f09:	6a 79                	push   $0x79
  801f0b:	68 1d 42 80 00       	push   $0x80421d
  801f10:	e8 b2 18 00 00       	call   8037c7 <_panic>
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	8b 00                	mov    (%eax),%eax
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	74 10                	je     801f2e <initialize_dynamic_allocator+0x9c>
  801f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f21:	8b 00                	mov    (%eax),%eax
  801f23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f26:	8b 52 04             	mov    0x4(%edx),%edx
  801f29:	89 50 04             	mov    %edx,0x4(%eax)
  801f2c:	eb 0b                	jmp    801f39 <initialize_dynamic_allocator+0xa7>
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	8b 40 04             	mov    0x4(%eax),%eax
  801f34:	a3 34 50 80 00       	mov    %eax,0x805034
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	8b 40 04             	mov    0x4(%eax),%eax
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	74 0f                	je     801f52 <initialize_dynamic_allocator+0xc0>
  801f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f46:	8b 40 04             	mov    0x4(%eax),%eax
  801f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4c:	8b 12                	mov    (%edx),%edx
  801f4e:	89 10                	mov    %edx,(%eax)
  801f50:	eb 0a                	jmp    801f5c <initialize_dynamic_allocator+0xca>
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	8b 00                	mov    (%eax),%eax
  801f57:	a3 30 50 80 00       	mov    %eax,0x805030
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f6f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  801f74:	48                   	dec    %eax
  801f75:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801f7a:	a1 38 50 80 00       	mov    0x805038,%eax
  801f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f86:	74 07                	je     801f8f <initialize_dynamic_allocator+0xfd>
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	eb 05                	jmp    801f94 <initialize_dynamic_allocator+0x102>
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f94:	a3 38 50 80 00       	mov    %eax,0x805038
  801f99:	a1 38 50 80 00       	mov    0x805038,%eax
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	0f 85 55 ff ff ff    	jne    801efb <initialize_dynamic_allocator+0x69>
  801fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801faa:	0f 85 4b ff ff ff    	jne    801efb <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801fbf:	a1 48 50 80 00       	mov    0x805048,%eax
  801fc4:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  801fc9:	a1 44 50 80 00       	mov    0x805044,%eax
  801fce:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	83 c0 08             	add    $0x8,%eax
  801fda:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	83 c0 04             	add    $0x4,%eax
  801fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe6:	83 ea 08             	sub    $0x8,%edx
  801fe9:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	01 d0                	add    %edx,%eax
  801ff3:	83 e8 08             	sub    $0x8,%eax
  801ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff9:	83 ea 08             	sub    $0x8,%edx
  801ffc:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802001:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  802007:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802011:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802015:	75 17                	jne    80202e <initialize_dynamic_allocator+0x19c>
  802017:	83 ec 04             	sub    $0x4,%esp
  80201a:	68 38 42 80 00       	push   $0x804238
  80201f:	68 90 00 00 00       	push   $0x90
  802024:	68 1d 42 80 00       	push   $0x80421d
  802029:	e8 99 17 00 00       	call   8037c7 <_panic>
  80202e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802034:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802037:	89 10                	mov    %edx,(%eax)
  802039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203c:	8b 00                	mov    (%eax),%eax
  80203e:	85 c0                	test   %eax,%eax
  802040:	74 0d                	je     80204f <initialize_dynamic_allocator+0x1bd>
  802042:	a1 30 50 80 00       	mov    0x805030,%eax
  802047:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80204a:	89 50 04             	mov    %edx,0x4(%eax)
  80204d:	eb 08                	jmp    802057 <initialize_dynamic_allocator+0x1c5>
  80204f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802052:	a3 34 50 80 00       	mov    %eax,0x805034
  802057:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205a:	a3 30 50 80 00       	mov    %eax,0x805030
  80205f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802062:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802069:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80206e:	40                   	inc    %eax
  80206f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802074:	eb 07                	jmp    80207d <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802076:	90                   	nop
  802077:	eb 04                	jmp    80207d <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802079:	90                   	nop
  80207a:	eb 01                	jmp    80207d <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  80207c:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  802082:	8b 45 10             	mov    0x10(%ebp),%eax
  802085:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	8d 50 fc             	lea    -0x4(%eax),%edx
  80208e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802091:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	83 e8 04             	sub    $0x4,%eax
  802099:	8b 00                	mov    (%eax),%eax
  80209b:	83 e0 fe             	and    $0xfffffffe,%eax
  80209e:	8d 50 f8             	lea    -0x8(%eax),%edx
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	01 c2                	add    %eax,%edx
  8020a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a9:	89 02                	mov    %eax,(%edx)
}
  8020ab:	90                   	nop
  8020ac:	5d                   	pop    %ebp
  8020ad:	c3                   	ret    

008020ae <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	83 e0 01             	and    $0x1,%eax
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	74 03                	je     8020c1 <alloc_block_FF+0x13>
  8020be:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8020c1:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8020c5:	77 07                	ja     8020ce <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8020c7:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8020ce:	a1 28 50 80 00       	mov    0x805028,%eax
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	75 73                	jne    80214a <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	83 c0 10             	add    $0x10,%eax
  8020dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8020e0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ed:	01 d0                	add    %edx,%eax
  8020ef:	48                   	dec    %eax
  8020f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8020fb:	f7 75 ec             	divl   -0x14(%ebp)
  8020fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802101:	29 d0                	sub    %edx,%eax
  802103:	c1 e8 0c             	shr    $0xc,%eax
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	50                   	push   %eax
  80210a:	e8 d6 ef ff ff       	call   8010e5 <sbrk>
  80210f:	83 c4 10             	add    $0x10,%esp
  802112:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802115:	83 ec 0c             	sub    $0xc,%esp
  802118:	6a 00                	push   $0x0
  80211a:	e8 c6 ef ff ff       	call   8010e5 <sbrk>
  80211f:	83 c4 10             	add    $0x10,%esp
  802122:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802125:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802128:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80212b:	83 ec 08             	sub    $0x8,%esp
  80212e:	50                   	push   %eax
  80212f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802132:	e8 5b fd ff ff       	call   801e92 <initialize_dynamic_allocator>
  802137:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80213a:	83 ec 0c             	sub    $0xc,%esp
  80213d:	68 5b 42 80 00       	push   $0x80425b
  802142:	e8 04 e2 ff ff       	call   80034b <cprintf>
  802147:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  80214a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214e:	75 0a                	jne    80215a <alloc_block_FF+0xac>
	        return NULL;
  802150:	b8 00 00 00 00       	mov    $0x0,%eax
  802155:	e9 0e 04 00 00       	jmp    802568 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  80215a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802161:	a1 30 50 80 00       	mov    0x805030,%eax
  802166:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802169:	e9 f3 02 00 00       	jmp    802461 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802174:	83 ec 0c             	sub    $0xc,%esp
  802177:	ff 75 bc             	pushl  -0x44(%ebp)
  80217a:	e8 af fb ff ff       	call   801d2e <get_block_size>
  80217f:	83 c4 10             	add    $0x10,%esp
  802182:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	83 c0 08             	add    $0x8,%eax
  80218b:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80218e:	0f 87 c5 02 00 00    	ja     802459 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	83 c0 18             	add    $0x18,%eax
  80219a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80219d:	0f 87 19 02 00 00    	ja     8023bc <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8021a3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8021a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8021a9:	83 e8 08             	sub    $0x8,%eax
  8021ac:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	8d 50 08             	lea    0x8(%eax),%edx
  8021b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8021b8:	01 d0                	add    %edx,%eax
  8021ba:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	83 c0 08             	add    $0x8,%eax
  8021c3:	83 ec 04             	sub    $0x4,%esp
  8021c6:	6a 01                	push   $0x1
  8021c8:	50                   	push   %eax
  8021c9:	ff 75 bc             	pushl  -0x44(%ebp)
  8021cc:	e8 ae fe ff ff       	call   80207f <set_block_data>
  8021d1:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	8b 40 04             	mov    0x4(%eax),%eax
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	75 68                	jne    802246 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8021de:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021e2:	75 17                	jne    8021fb <alloc_block_FF+0x14d>
  8021e4:	83 ec 04             	sub    $0x4,%esp
  8021e7:	68 38 42 80 00       	push   $0x804238
  8021ec:	68 d7 00 00 00       	push   $0xd7
  8021f1:	68 1d 42 80 00       	push   $0x80421d
  8021f6:	e8 cc 15 00 00       	call   8037c7 <_panic>
  8021fb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802201:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802204:	89 10                	mov    %edx,(%eax)
  802206:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802209:	8b 00                	mov    (%eax),%eax
  80220b:	85 c0                	test   %eax,%eax
  80220d:	74 0d                	je     80221c <alloc_block_FF+0x16e>
  80220f:	a1 30 50 80 00       	mov    0x805030,%eax
  802214:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802217:	89 50 04             	mov    %edx,0x4(%eax)
  80221a:	eb 08                	jmp    802224 <alloc_block_FF+0x176>
  80221c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80221f:	a3 34 50 80 00       	mov    %eax,0x805034
  802224:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802227:	a3 30 50 80 00       	mov    %eax,0x805030
  80222c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80222f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802236:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80223b:	40                   	inc    %eax
  80223c:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802241:	e9 dc 00 00 00       	jmp    802322 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802249:	8b 00                	mov    (%eax),%eax
  80224b:	85 c0                	test   %eax,%eax
  80224d:	75 65                	jne    8022b4 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80224f:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802253:	75 17                	jne    80226c <alloc_block_FF+0x1be>
  802255:	83 ec 04             	sub    $0x4,%esp
  802258:	68 6c 42 80 00       	push   $0x80426c
  80225d:	68 db 00 00 00       	push   $0xdb
  802262:	68 1d 42 80 00       	push   $0x80421d
  802267:	e8 5b 15 00 00       	call   8037c7 <_panic>
  80226c:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802272:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802275:	89 50 04             	mov    %edx,0x4(%eax)
  802278:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80227b:	8b 40 04             	mov    0x4(%eax),%eax
  80227e:	85 c0                	test   %eax,%eax
  802280:	74 0c                	je     80228e <alloc_block_FF+0x1e0>
  802282:	a1 34 50 80 00       	mov    0x805034,%eax
  802287:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80228a:	89 10                	mov    %edx,(%eax)
  80228c:	eb 08                	jmp    802296 <alloc_block_FF+0x1e8>
  80228e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802291:	a3 30 50 80 00       	mov    %eax,0x805030
  802296:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802299:	a3 34 50 80 00       	mov    %eax,0x805034
  80229e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8022ac:	40                   	inc    %eax
  8022ad:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8022b2:	eb 6e                	jmp    802322 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8022b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b8:	74 06                	je     8022c0 <alloc_block_FF+0x212>
  8022ba:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022be:	75 17                	jne    8022d7 <alloc_block_FF+0x229>
  8022c0:	83 ec 04             	sub    $0x4,%esp
  8022c3:	68 90 42 80 00       	push   $0x804290
  8022c8:	68 df 00 00 00       	push   $0xdf
  8022cd:	68 1d 42 80 00       	push   $0x80421d
  8022d2:	e8 f0 14 00 00       	call   8037c7 <_panic>
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 10                	mov    (%eax),%edx
  8022dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022df:	89 10                	mov    %edx,(%eax)
  8022e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e4:	8b 00                	mov    (%eax),%eax
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	74 0b                	je     8022f5 <alloc_block_FF+0x247>
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022f2:	89 50 04             	mov    %edx,0x4(%eax)
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022fb:	89 10                	mov    %edx,(%eax)
  8022fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802300:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802303:	89 50 04             	mov    %edx,0x4(%eax)
  802306:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802309:	8b 00                	mov    (%eax),%eax
  80230b:	85 c0                	test   %eax,%eax
  80230d:	75 08                	jne    802317 <alloc_block_FF+0x269>
  80230f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802312:	a3 34 50 80 00       	mov    %eax,0x805034
  802317:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80231c:	40                   	inc    %eax
  80231d:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802326:	75 17                	jne    80233f <alloc_block_FF+0x291>
  802328:	83 ec 04             	sub    $0x4,%esp
  80232b:	68 ff 41 80 00       	push   $0x8041ff
  802330:	68 e1 00 00 00       	push   $0xe1
  802335:	68 1d 42 80 00       	push   $0x80421d
  80233a:	e8 88 14 00 00       	call   8037c7 <_panic>
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	8b 00                	mov    (%eax),%eax
  802344:	85 c0                	test   %eax,%eax
  802346:	74 10                	je     802358 <alloc_block_FF+0x2aa>
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802350:	8b 52 04             	mov    0x4(%edx),%edx
  802353:	89 50 04             	mov    %edx,0x4(%eax)
  802356:	eb 0b                	jmp    802363 <alloc_block_FF+0x2b5>
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 40 04             	mov    0x4(%eax),%eax
  80235e:	a3 34 50 80 00       	mov    %eax,0x805034
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 40 04             	mov    0x4(%eax),%eax
  802369:	85 c0                	test   %eax,%eax
  80236b:	74 0f                	je     80237c <alloc_block_FF+0x2ce>
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	8b 40 04             	mov    0x4(%eax),%eax
  802373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802376:	8b 12                	mov    (%edx),%edx
  802378:	89 10                	mov    %edx,(%eax)
  80237a:	eb 0a                	jmp    802386 <alloc_block_FF+0x2d8>
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	a3 30 50 80 00       	mov    %eax,0x805030
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802399:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80239e:	48                   	dec    %eax
  80239f:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  8023a4:	83 ec 04             	sub    $0x4,%esp
  8023a7:	6a 00                	push   $0x0
  8023a9:	ff 75 b4             	pushl  -0x4c(%ebp)
  8023ac:	ff 75 b0             	pushl  -0x50(%ebp)
  8023af:	e8 cb fc ff ff       	call   80207f <set_block_data>
  8023b4:	83 c4 10             	add    $0x10,%esp
  8023b7:	e9 95 00 00 00       	jmp    802451 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8023bc:	83 ec 04             	sub    $0x4,%esp
  8023bf:	6a 01                	push   $0x1
  8023c1:	ff 75 b8             	pushl  -0x48(%ebp)
  8023c4:	ff 75 bc             	pushl  -0x44(%ebp)
  8023c7:	e8 b3 fc ff ff       	call   80207f <set_block_data>
  8023cc:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8023cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d3:	75 17                	jne    8023ec <alloc_block_FF+0x33e>
  8023d5:	83 ec 04             	sub    $0x4,%esp
  8023d8:	68 ff 41 80 00       	push   $0x8041ff
  8023dd:	68 e8 00 00 00       	push   $0xe8
  8023e2:	68 1d 42 80 00       	push   $0x80421d
  8023e7:	e8 db 13 00 00       	call   8037c7 <_panic>
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 00                	mov    (%eax),%eax
  8023f1:	85 c0                	test   %eax,%eax
  8023f3:	74 10                	je     802405 <alloc_block_FF+0x357>
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023fd:	8b 52 04             	mov    0x4(%edx),%edx
  802400:	89 50 04             	mov    %edx,0x4(%eax)
  802403:	eb 0b                	jmp    802410 <alloc_block_FF+0x362>
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 40 04             	mov    0x4(%eax),%eax
  80240b:	a3 34 50 80 00       	mov    %eax,0x805034
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 40 04             	mov    0x4(%eax),%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	74 0f                	je     802429 <alloc_block_FF+0x37b>
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 40 04             	mov    0x4(%eax),%eax
  802420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802423:	8b 12                	mov    (%edx),%edx
  802425:	89 10                	mov    %edx,(%eax)
  802427:	eb 0a                	jmp    802433 <alloc_block_FF+0x385>
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	8b 00                	mov    (%eax),%eax
  80242e:	a3 30 50 80 00       	mov    %eax,0x805030
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802446:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80244b:	48                   	dec    %eax
  80244c:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802451:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802454:	e9 0f 01 00 00       	jmp    802568 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802459:	a1 38 50 80 00       	mov    0x805038,%eax
  80245e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802465:	74 07                	je     80246e <alloc_block_FF+0x3c0>
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	eb 05                	jmp    802473 <alloc_block_FF+0x3c5>
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
  802473:	a3 38 50 80 00       	mov    %eax,0x805038
  802478:	a1 38 50 80 00       	mov    0x805038,%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	0f 85 e9 fc ff ff    	jne    80216e <alloc_block_FF+0xc0>
  802485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802489:	0f 85 df fc ff ff    	jne    80216e <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	83 c0 08             	add    $0x8,%eax
  802495:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802498:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80249f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8024a5:	01 d0                	add    %edx,%eax
  8024a7:	48                   	dec    %eax
  8024a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8024ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b3:	f7 75 d8             	divl   -0x28(%ebp)
  8024b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024b9:	29 d0                	sub    %edx,%eax
  8024bb:	c1 e8 0c             	shr    $0xc,%eax
  8024be:	83 ec 0c             	sub    $0xc,%esp
  8024c1:	50                   	push   %eax
  8024c2:	e8 1e ec ff ff       	call   8010e5 <sbrk>
  8024c7:	83 c4 10             	add    $0x10,%esp
  8024ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8024cd:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8024d1:	75 0a                	jne    8024dd <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d8:	e9 8b 00 00 00       	jmp    802568 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8024dd:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8024e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024ea:	01 d0                	add    %edx,%eax
  8024ec:	48                   	dec    %eax
  8024ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8024f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f8:	f7 75 cc             	divl   -0x34(%ebp)
  8024fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024fe:	29 d0                	sub    %edx,%eax
  802500:	8d 50 fc             	lea    -0x4(%eax),%edx
  802503:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802506:	01 d0                	add    %edx,%eax
  802508:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  80250d:	a1 44 50 80 00       	mov    0x805044,%eax
  802512:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802518:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80251f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802522:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802525:	01 d0                	add    %edx,%eax
  802527:	48                   	dec    %eax
  802528:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80252b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80252e:	ba 00 00 00 00       	mov    $0x0,%edx
  802533:	f7 75 c4             	divl   -0x3c(%ebp)
  802536:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802539:	29 d0                	sub    %edx,%eax
  80253b:	83 ec 04             	sub    $0x4,%esp
  80253e:	6a 01                	push   $0x1
  802540:	50                   	push   %eax
  802541:	ff 75 d0             	pushl  -0x30(%ebp)
  802544:	e8 36 fb ff ff       	call   80207f <set_block_data>
  802549:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  80254c:	83 ec 0c             	sub    $0xc,%esp
  80254f:	ff 75 d0             	pushl  -0x30(%ebp)
  802552:	e8 1b 0a 00 00       	call   802f72 <free_block>
  802557:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  80255a:	83 ec 0c             	sub    $0xc,%esp
  80255d:	ff 75 08             	pushl  0x8(%ebp)
  802560:	e8 49 fb ff ff       	call   8020ae <alloc_block_FF>
  802565:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802568:	c9                   	leave  
  802569:	c3                   	ret    

0080256a <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  80256a:	55                   	push   %ebp
  80256b:	89 e5                	mov    %esp,%ebp
  80256d:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802570:	8b 45 08             	mov    0x8(%ebp),%eax
  802573:	83 e0 01             	and    $0x1,%eax
  802576:	85 c0                	test   %eax,%eax
  802578:	74 03                	je     80257d <alloc_block_BF+0x13>
  80257a:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80257d:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802581:	77 07                	ja     80258a <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802583:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80258a:	a1 28 50 80 00       	mov    0x805028,%eax
  80258f:	85 c0                	test   %eax,%eax
  802591:	75 73                	jne    802606 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	83 c0 10             	add    $0x10,%eax
  802599:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80259c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8025a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a9:	01 d0                	add    %edx,%eax
  8025ab:	48                   	dec    %eax
  8025ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8025af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b7:	f7 75 e0             	divl   -0x20(%ebp)
  8025ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025bd:	29 d0                	sub    %edx,%eax
  8025bf:	c1 e8 0c             	shr    $0xc,%eax
  8025c2:	83 ec 0c             	sub    $0xc,%esp
  8025c5:	50                   	push   %eax
  8025c6:	e8 1a eb ff ff       	call   8010e5 <sbrk>
  8025cb:	83 c4 10             	add    $0x10,%esp
  8025ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025d1:	83 ec 0c             	sub    $0xc,%esp
  8025d4:	6a 00                	push   $0x0
  8025d6:	e8 0a eb ff ff       	call   8010e5 <sbrk>
  8025db:	83 c4 10             	add    $0x10,%esp
  8025de:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8025e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025e4:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8025e7:	83 ec 08             	sub    $0x8,%esp
  8025ea:	50                   	push   %eax
  8025eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8025ee:	e8 9f f8 ff ff       	call   801e92 <initialize_dynamic_allocator>
  8025f3:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025f6:	83 ec 0c             	sub    $0xc,%esp
  8025f9:	68 5b 42 80 00       	push   $0x80425b
  8025fe:	e8 48 dd ff ff       	call   80034b <cprintf>
  802603:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80260d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802614:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80261b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802622:	a1 30 50 80 00       	mov    0x805030,%eax
  802627:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262a:	e9 1d 01 00 00       	jmp    80274c <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802635:	83 ec 0c             	sub    $0xc,%esp
  802638:	ff 75 a8             	pushl  -0x58(%ebp)
  80263b:	e8 ee f6 ff ff       	call   801d2e <get_block_size>
  802640:	83 c4 10             	add    $0x10,%esp
  802643:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	83 c0 08             	add    $0x8,%eax
  80264c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80264f:	0f 87 ef 00 00 00    	ja     802744 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	83 c0 18             	add    $0x18,%eax
  80265b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80265e:	77 1d                	ja     80267d <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802663:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802666:	0f 86 d8 00 00 00    	jbe    802744 <alloc_block_BF+0x1da>
				{
					best_va = va;
  80266c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80266f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  802672:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802675:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802678:	e9 c7 00 00 00       	jmp    802744 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80267d:	8b 45 08             	mov    0x8(%ebp),%eax
  802680:	83 c0 08             	add    $0x8,%eax
  802683:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802686:	0f 85 9d 00 00 00    	jne    802729 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	6a 01                	push   $0x1
  802691:	ff 75 a4             	pushl  -0x5c(%ebp)
  802694:	ff 75 a8             	pushl  -0x58(%ebp)
  802697:	e8 e3 f9 ff ff       	call   80207f <set_block_data>
  80269c:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80269f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a3:	75 17                	jne    8026bc <alloc_block_BF+0x152>
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	68 ff 41 80 00       	push   $0x8041ff
  8026ad:	68 2c 01 00 00       	push   $0x12c
  8026b2:	68 1d 42 80 00       	push   $0x80421d
  8026b7:	e8 0b 11 00 00       	call   8037c7 <_panic>
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	74 10                	je     8026d5 <alloc_block_BF+0x16b>
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 00                	mov    (%eax),%eax
  8026ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cd:	8b 52 04             	mov    0x4(%edx),%edx
  8026d0:	89 50 04             	mov    %edx,0x4(%eax)
  8026d3:	eb 0b                	jmp    8026e0 <alloc_block_BF+0x176>
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	a3 34 50 80 00       	mov    %eax,0x805034
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 40 04             	mov    0x4(%eax),%eax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	74 0f                	je     8026f9 <alloc_block_BF+0x18f>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 04             	mov    0x4(%eax),%eax
  8026f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f3:	8b 12                	mov    (%edx),%edx
  8026f5:	89 10                	mov    %edx,(%eax)
  8026f7:	eb 0a                	jmp    802703 <alloc_block_BF+0x199>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	a3 30 50 80 00       	mov    %eax,0x805030
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802716:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80271b:	48                   	dec    %eax
  80271c:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  802721:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802724:	e9 24 04 00 00       	jmp    802b4d <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80272f:	76 13                	jbe    802744 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802731:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802738:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80273b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80273e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802741:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802744:	a1 38 50 80 00       	mov    0x805038,%eax
  802749:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802750:	74 07                	je     802759 <alloc_block_BF+0x1ef>
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 00                	mov    (%eax),%eax
  802757:	eb 05                	jmp    80275e <alloc_block_BF+0x1f4>
  802759:	b8 00 00 00 00       	mov    $0x0,%eax
  80275e:	a3 38 50 80 00       	mov    %eax,0x805038
  802763:	a1 38 50 80 00       	mov    0x805038,%eax
  802768:	85 c0                	test   %eax,%eax
  80276a:	0f 85 bf fe ff ff    	jne    80262f <alloc_block_BF+0xc5>
  802770:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802774:	0f 85 b5 fe ff ff    	jne    80262f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  80277a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277e:	0f 84 26 02 00 00    	je     8029aa <alloc_block_BF+0x440>
  802784:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802788:	0f 85 1c 02 00 00    	jne    8029aa <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80278e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802791:	2b 45 08             	sub    0x8(%ebp),%eax
  802794:	83 e8 08             	sub    $0x8,%eax
  802797:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80279a:	8b 45 08             	mov    0x8(%ebp),%eax
  80279d:	8d 50 08             	lea    0x8(%eax),%edx
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	01 d0                	add    %edx,%eax
  8027a5:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8027a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ab:	83 c0 08             	add    $0x8,%eax
  8027ae:	83 ec 04             	sub    $0x4,%esp
  8027b1:	6a 01                	push   $0x1
  8027b3:	50                   	push   %eax
  8027b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8027b7:	e8 c3 f8 ff ff       	call   80207f <set_block_data>
  8027bc:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c2:	8b 40 04             	mov    0x4(%eax),%eax
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	75 68                	jne    802831 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027cd:	75 17                	jne    8027e6 <alloc_block_BF+0x27c>
  8027cf:	83 ec 04             	sub    $0x4,%esp
  8027d2:	68 38 42 80 00       	push   $0x804238
  8027d7:	68 45 01 00 00       	push   $0x145
  8027dc:	68 1d 42 80 00       	push   $0x80421d
  8027e1:	e8 e1 0f 00 00       	call   8037c7 <_panic>
  8027e6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ef:	89 10                	mov    %edx,(%eax)
  8027f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f4:	8b 00                	mov    (%eax),%eax
  8027f6:	85 c0                	test   %eax,%eax
  8027f8:	74 0d                	je     802807 <alloc_block_BF+0x29d>
  8027fa:	a1 30 50 80 00       	mov    0x805030,%eax
  8027ff:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802802:	89 50 04             	mov    %edx,0x4(%eax)
  802805:	eb 08                	jmp    80280f <alloc_block_BF+0x2a5>
  802807:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80280a:	a3 34 50 80 00       	mov    %eax,0x805034
  80280f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802812:	a3 30 50 80 00       	mov    %eax,0x805030
  802817:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80281a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802821:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802826:	40                   	inc    %eax
  802827:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80282c:	e9 dc 00 00 00       	jmp    80290d <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	85 c0                	test   %eax,%eax
  802838:	75 65                	jne    80289f <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80283a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80283e:	75 17                	jne    802857 <alloc_block_BF+0x2ed>
  802840:	83 ec 04             	sub    $0x4,%esp
  802843:	68 6c 42 80 00       	push   $0x80426c
  802848:	68 4a 01 00 00       	push   $0x14a
  80284d:	68 1d 42 80 00       	push   $0x80421d
  802852:	e8 70 0f 00 00       	call   8037c7 <_panic>
  802857:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80285d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802860:	89 50 04             	mov    %edx,0x4(%eax)
  802863:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802866:	8b 40 04             	mov    0x4(%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 0c                	je     802879 <alloc_block_BF+0x30f>
  80286d:	a1 34 50 80 00       	mov    0x805034,%eax
  802872:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802875:	89 10                	mov    %edx,(%eax)
  802877:	eb 08                	jmp    802881 <alloc_block_BF+0x317>
  802879:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80287c:	a3 30 50 80 00       	mov    %eax,0x805030
  802881:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802884:	a3 34 50 80 00       	mov    %eax,0x805034
  802889:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80288c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802892:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802897:	40                   	inc    %eax
  802898:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80289d:	eb 6e                	jmp    80290d <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80289f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028a3:	74 06                	je     8028ab <alloc_block_BF+0x341>
  8028a5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028a9:	75 17                	jne    8028c2 <alloc_block_BF+0x358>
  8028ab:	83 ec 04             	sub    $0x4,%esp
  8028ae:	68 90 42 80 00       	push   $0x804290
  8028b3:	68 4f 01 00 00       	push   $0x14f
  8028b8:	68 1d 42 80 00       	push   $0x80421d
  8028bd:	e8 05 0f 00 00       	call   8037c7 <_panic>
  8028c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c5:	8b 10                	mov    (%eax),%edx
  8028c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ca:	89 10                	mov    %edx,(%eax)
  8028cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028cf:	8b 00                	mov    (%eax),%eax
  8028d1:	85 c0                	test   %eax,%eax
  8028d3:	74 0b                	je     8028e0 <alloc_block_BF+0x376>
  8028d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d8:	8b 00                	mov    (%eax),%eax
  8028da:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028dd:	89 50 04             	mov    %edx,0x4(%eax)
  8028e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e3:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028e6:	89 10                	mov    %edx,(%eax)
  8028e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ee:	89 50 04             	mov    %edx,0x4(%eax)
  8028f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	75 08                	jne    802902 <alloc_block_BF+0x398>
  8028fa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028fd:	a3 34 50 80 00       	mov    %eax,0x805034
  802902:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802907:	40                   	inc    %eax
  802908:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80290d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802911:	75 17                	jne    80292a <alloc_block_BF+0x3c0>
  802913:	83 ec 04             	sub    $0x4,%esp
  802916:	68 ff 41 80 00       	push   $0x8041ff
  80291b:	68 51 01 00 00       	push   $0x151
  802920:	68 1d 42 80 00       	push   $0x80421d
  802925:	e8 9d 0e 00 00       	call   8037c7 <_panic>
  80292a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	85 c0                	test   %eax,%eax
  802931:	74 10                	je     802943 <alloc_block_BF+0x3d9>
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293b:	8b 52 04             	mov    0x4(%edx),%edx
  80293e:	89 50 04             	mov    %edx,0x4(%eax)
  802941:	eb 0b                	jmp    80294e <alloc_block_BF+0x3e4>
  802943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802946:	8b 40 04             	mov    0x4(%eax),%eax
  802949:	a3 34 50 80 00       	mov    %eax,0x805034
  80294e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802951:	8b 40 04             	mov    0x4(%eax),%eax
  802954:	85 c0                	test   %eax,%eax
  802956:	74 0f                	je     802967 <alloc_block_BF+0x3fd>
  802958:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295b:	8b 40 04             	mov    0x4(%eax),%eax
  80295e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802961:	8b 12                	mov    (%edx),%edx
  802963:	89 10                	mov    %edx,(%eax)
  802965:	eb 0a                	jmp    802971 <alloc_block_BF+0x407>
  802967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296a:	8b 00                	mov    (%eax),%eax
  80296c:	a3 30 50 80 00       	mov    %eax,0x805030
  802971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802974:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802984:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802989:	48                   	dec    %eax
  80298a:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  80298f:	83 ec 04             	sub    $0x4,%esp
  802992:	6a 00                	push   $0x0
  802994:	ff 75 d0             	pushl  -0x30(%ebp)
  802997:	ff 75 cc             	pushl  -0x34(%ebp)
  80299a:	e8 e0 f6 ff ff       	call   80207f <set_block_data>
  80299f:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	e9 a3 01 00 00       	jmp    802b4d <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8029aa:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8029ae:	0f 85 9d 00 00 00    	jne    802a51 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8029b4:	83 ec 04             	sub    $0x4,%esp
  8029b7:	6a 01                	push   $0x1
  8029b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8029bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8029bf:	e8 bb f6 ff ff       	call   80207f <set_block_data>
  8029c4:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8029c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029cb:	75 17                	jne    8029e4 <alloc_block_BF+0x47a>
  8029cd:	83 ec 04             	sub    $0x4,%esp
  8029d0:	68 ff 41 80 00       	push   $0x8041ff
  8029d5:	68 58 01 00 00       	push   $0x158
  8029da:	68 1d 42 80 00       	push   $0x80421d
  8029df:	e8 e3 0d 00 00       	call   8037c7 <_panic>
  8029e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 10                	je     8029fd <alloc_block_BF+0x493>
  8029ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f5:	8b 52 04             	mov    0x4(%edx),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	eb 0b                	jmp    802a08 <alloc_block_BF+0x49e>
  8029fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	a3 34 50 80 00       	mov    %eax,0x805034
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 0f                	je     802a21 <alloc_block_BF+0x4b7>
  802a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a15:	8b 40 04             	mov    0x4(%eax),%eax
  802a18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1b:	8b 12                	mov    (%edx),%edx
  802a1d:	89 10                	mov    %edx,(%eax)
  802a1f:	eb 0a                	jmp    802a2b <alloc_block_BF+0x4c1>
  802a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	a3 30 50 80 00       	mov    %eax,0x805030
  802a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a43:	48                   	dec    %eax
  802a44:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4c:	e9 fc 00 00 00       	jmp    802b4d <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	83 c0 08             	add    $0x8,%eax
  802a57:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a5a:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802a61:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a64:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a67:	01 d0                	add    %edx,%eax
  802a69:	48                   	dec    %eax
  802a6a:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802a6d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a70:	ba 00 00 00 00       	mov    $0x0,%edx
  802a75:	f7 75 c4             	divl   -0x3c(%ebp)
  802a78:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a7b:	29 d0                	sub    %edx,%eax
  802a7d:	c1 e8 0c             	shr    $0xc,%eax
  802a80:	83 ec 0c             	sub    $0xc,%esp
  802a83:	50                   	push   %eax
  802a84:	e8 5c e6 ff ff       	call   8010e5 <sbrk>
  802a89:	83 c4 10             	add    $0x10,%esp
  802a8c:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802a8f:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802a93:	75 0a                	jne    802a9f <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802a95:	b8 00 00 00 00       	mov    $0x0,%eax
  802a9a:	e9 ae 00 00 00       	jmp    802b4d <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a9f:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802aa6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802aa9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802aac:	01 d0                	add    %edx,%eax
  802aae:	48                   	dec    %eax
  802aaf:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802ab2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  802aba:	f7 75 b8             	divl   -0x48(%ebp)
  802abd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802ac0:	29 d0                	sub    %edx,%eax
  802ac2:	8d 50 fc             	lea    -0x4(%eax),%edx
  802ac5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ac8:	01 d0                	add    %edx,%eax
  802aca:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802acf:	a1 44 50 80 00       	mov    0x805044,%eax
  802ad4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ada:	83 ec 0c             	sub    $0xc,%esp
  802add:	68 c4 42 80 00       	push   $0x8042c4
  802ae2:	e8 64 d8 ff ff       	call   80034b <cprintf>
  802ae7:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802aea:	83 ec 08             	sub    $0x8,%esp
  802aed:	ff 75 bc             	pushl  -0x44(%ebp)
  802af0:	68 c9 42 80 00       	push   $0x8042c9
  802af5:	e8 51 d8 ff ff       	call   80034b <cprintf>
  802afa:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802afd:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b04:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b07:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b0a:	01 d0                	add    %edx,%eax
  802b0c:	48                   	dec    %eax
  802b0d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b10:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b13:	ba 00 00 00 00       	mov    $0x0,%edx
  802b18:	f7 75 b0             	divl   -0x50(%ebp)
  802b1b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b1e:	29 d0                	sub    %edx,%eax
  802b20:	83 ec 04             	sub    $0x4,%esp
  802b23:	6a 01                	push   $0x1
  802b25:	50                   	push   %eax
  802b26:	ff 75 bc             	pushl  -0x44(%ebp)
  802b29:	e8 51 f5 ff ff       	call   80207f <set_block_data>
  802b2e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b31:	83 ec 0c             	sub    $0xc,%esp
  802b34:	ff 75 bc             	pushl  -0x44(%ebp)
  802b37:	e8 36 04 00 00       	call   802f72 <free_block>
  802b3c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802b3f:	83 ec 0c             	sub    $0xc,%esp
  802b42:	ff 75 08             	pushl  0x8(%ebp)
  802b45:	e8 20 fa ff ff       	call   80256a <alloc_block_BF>
  802b4a:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802b4d:	c9                   	leave  
  802b4e:	c3                   	ret    

00802b4f <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802b4f:	55                   	push   %ebp
  802b50:	89 e5                	mov    %esp,%ebp
  802b52:	53                   	push   %ebx
  802b53:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802b56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b5d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b68:	74 1e                	je     802b88 <merging+0x39>
  802b6a:	ff 75 08             	pushl  0x8(%ebp)
  802b6d:	e8 bc f1 ff ff       	call   801d2e <get_block_size>
  802b72:	83 c4 04             	add    $0x4,%esp
  802b75:	89 c2                	mov    %eax,%edx
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	01 d0                	add    %edx,%eax
  802b7c:	3b 45 10             	cmp    0x10(%ebp),%eax
  802b7f:	75 07                	jne    802b88 <merging+0x39>
		prev_is_free = 1;
  802b81:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802b88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b8c:	74 1e                	je     802bac <merging+0x5d>
  802b8e:	ff 75 10             	pushl  0x10(%ebp)
  802b91:	e8 98 f1 ff ff       	call   801d2e <get_block_size>
  802b96:	83 c4 04             	add    $0x4,%esp
  802b99:	89 c2                	mov    %eax,%edx
  802b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  802b9e:	01 d0                	add    %edx,%eax
  802ba0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ba3:	75 07                	jne    802bac <merging+0x5d>
		next_is_free = 1;
  802ba5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802bac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb0:	0f 84 cc 00 00 00    	je     802c82 <merging+0x133>
  802bb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bba:	0f 84 c2 00 00 00    	je     802c82 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802bc0:	ff 75 08             	pushl  0x8(%ebp)
  802bc3:	e8 66 f1 ff ff       	call   801d2e <get_block_size>
  802bc8:	83 c4 04             	add    $0x4,%esp
  802bcb:	89 c3                	mov    %eax,%ebx
  802bcd:	ff 75 10             	pushl  0x10(%ebp)
  802bd0:	e8 59 f1 ff ff       	call   801d2e <get_block_size>
  802bd5:	83 c4 04             	add    $0x4,%esp
  802bd8:	01 c3                	add    %eax,%ebx
  802bda:	ff 75 0c             	pushl  0xc(%ebp)
  802bdd:	e8 4c f1 ff ff       	call   801d2e <get_block_size>
  802be2:	83 c4 04             	add    $0x4,%esp
  802be5:	01 d8                	add    %ebx,%eax
  802be7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802bea:	6a 00                	push   $0x0
  802bec:	ff 75 ec             	pushl  -0x14(%ebp)
  802bef:	ff 75 08             	pushl  0x8(%ebp)
  802bf2:	e8 88 f4 ff ff       	call   80207f <set_block_data>
  802bf7:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802bfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bfe:	75 17                	jne    802c17 <merging+0xc8>
  802c00:	83 ec 04             	sub    $0x4,%esp
  802c03:	68 ff 41 80 00       	push   $0x8041ff
  802c08:	68 7d 01 00 00       	push   $0x17d
  802c0d:	68 1d 42 80 00       	push   $0x80421d
  802c12:	e8 b0 0b 00 00       	call   8037c7 <_panic>
  802c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c1a:	8b 00                	mov    (%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	74 10                	je     802c30 <merging+0xe1>
  802c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c23:	8b 00                	mov    (%eax),%eax
  802c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c28:	8b 52 04             	mov    0x4(%edx),%edx
  802c2b:	89 50 04             	mov    %edx,0x4(%eax)
  802c2e:	eb 0b                	jmp    802c3b <merging+0xec>
  802c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c33:	8b 40 04             	mov    0x4(%eax),%eax
  802c36:	a3 34 50 80 00       	mov    %eax,0x805034
  802c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c3e:	8b 40 04             	mov    0x4(%eax),%eax
  802c41:	85 c0                	test   %eax,%eax
  802c43:	74 0f                	je     802c54 <merging+0x105>
  802c45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c48:	8b 40 04             	mov    0x4(%eax),%eax
  802c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c4e:	8b 12                	mov    (%edx),%edx
  802c50:	89 10                	mov    %edx,(%eax)
  802c52:	eb 0a                	jmp    802c5e <merging+0x10f>
  802c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	a3 30 50 80 00       	mov    %eax,0x805030
  802c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c71:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802c76:	48                   	dec    %eax
  802c77:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802c7c:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c7d:	e9 ea 02 00 00       	jmp    802f6c <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802c82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c86:	74 3b                	je     802cc3 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802c88:	83 ec 0c             	sub    $0xc,%esp
  802c8b:	ff 75 08             	pushl  0x8(%ebp)
  802c8e:	e8 9b f0 ff ff       	call   801d2e <get_block_size>
  802c93:	83 c4 10             	add    $0x10,%esp
  802c96:	89 c3                	mov    %eax,%ebx
  802c98:	83 ec 0c             	sub    $0xc,%esp
  802c9b:	ff 75 10             	pushl  0x10(%ebp)
  802c9e:	e8 8b f0 ff ff       	call   801d2e <get_block_size>
  802ca3:	83 c4 10             	add    $0x10,%esp
  802ca6:	01 d8                	add    %ebx,%eax
  802ca8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cab:	83 ec 04             	sub    $0x4,%esp
  802cae:	6a 00                	push   $0x0
  802cb0:	ff 75 e8             	pushl  -0x18(%ebp)
  802cb3:	ff 75 08             	pushl  0x8(%ebp)
  802cb6:	e8 c4 f3 ff ff       	call   80207f <set_block_data>
  802cbb:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cbe:	e9 a9 02 00 00       	jmp    802f6c <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802cc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc7:	0f 84 2d 01 00 00    	je     802dfa <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802ccd:	83 ec 0c             	sub    $0xc,%esp
  802cd0:	ff 75 10             	pushl  0x10(%ebp)
  802cd3:	e8 56 f0 ff ff       	call   801d2e <get_block_size>
  802cd8:	83 c4 10             	add    $0x10,%esp
  802cdb:	89 c3                	mov    %eax,%ebx
  802cdd:	83 ec 0c             	sub    $0xc,%esp
  802ce0:	ff 75 0c             	pushl  0xc(%ebp)
  802ce3:	e8 46 f0 ff ff       	call   801d2e <get_block_size>
  802ce8:	83 c4 10             	add    $0x10,%esp
  802ceb:	01 d8                	add    %ebx,%eax
  802ced:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802cf0:	83 ec 04             	sub    $0x4,%esp
  802cf3:	6a 00                	push   $0x0
  802cf5:	ff 75 e4             	pushl  -0x1c(%ebp)
  802cf8:	ff 75 10             	pushl  0x10(%ebp)
  802cfb:	e8 7f f3 ff ff       	call   80207f <set_block_data>
  802d00:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d03:	8b 45 10             	mov    0x10(%ebp),%eax
  802d06:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d0d:	74 06                	je     802d15 <merging+0x1c6>
  802d0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d13:	75 17                	jne    802d2c <merging+0x1dd>
  802d15:	83 ec 04             	sub    $0x4,%esp
  802d18:	68 d8 42 80 00       	push   $0x8042d8
  802d1d:	68 8d 01 00 00       	push   $0x18d
  802d22:	68 1d 42 80 00       	push   $0x80421d
  802d27:	e8 9b 0a 00 00       	call   8037c7 <_panic>
  802d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2f:	8b 50 04             	mov    0x4(%eax),%edx
  802d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3e:	89 10                	mov    %edx,(%eax)
  802d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d43:	8b 40 04             	mov    0x4(%eax),%eax
  802d46:	85 c0                	test   %eax,%eax
  802d48:	74 0d                	je     802d57 <merging+0x208>
  802d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4d:	8b 40 04             	mov    0x4(%eax),%eax
  802d50:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	eb 08                	jmp    802d5f <merging+0x210>
  802d57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d5a:	a3 30 50 80 00       	mov    %eax,0x805030
  802d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d65:	89 50 04             	mov    %edx,0x4(%eax)
  802d68:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d6d:	40                   	inc    %eax
  802d6e:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  802d73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d77:	75 17                	jne    802d90 <merging+0x241>
  802d79:	83 ec 04             	sub    $0x4,%esp
  802d7c:	68 ff 41 80 00       	push   $0x8041ff
  802d81:	68 8e 01 00 00       	push   $0x18e
  802d86:	68 1d 42 80 00       	push   $0x80421d
  802d8b:	e8 37 0a 00 00       	call   8037c7 <_panic>
  802d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	85 c0                	test   %eax,%eax
  802d97:	74 10                	je     802da9 <merging+0x25a>
  802d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9c:	8b 00                	mov    (%eax),%eax
  802d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da1:	8b 52 04             	mov    0x4(%edx),%edx
  802da4:	89 50 04             	mov    %edx,0x4(%eax)
  802da7:	eb 0b                	jmp    802db4 <merging+0x265>
  802da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dac:	8b 40 04             	mov    0x4(%eax),%eax
  802daf:	a3 34 50 80 00       	mov    %eax,0x805034
  802db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db7:	8b 40 04             	mov    0x4(%eax),%eax
  802dba:	85 c0                	test   %eax,%eax
  802dbc:	74 0f                	je     802dcd <merging+0x27e>
  802dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc1:	8b 40 04             	mov    0x4(%eax),%eax
  802dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802dc7:	8b 12                	mov    (%edx),%edx
  802dc9:	89 10                	mov    %edx,(%eax)
  802dcb:	eb 0a                	jmp    802dd7 <merging+0x288>
  802dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd0:	8b 00                	mov    (%eax),%eax
  802dd2:	a3 30 50 80 00       	mov    %eax,0x805030
  802dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dea:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802def:	48                   	dec    %eax
  802df0:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802df5:	e9 72 01 00 00       	jmp    802f6c <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802dfa:	8b 45 10             	mov    0x10(%ebp),%eax
  802dfd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e04:	74 79                	je     802e7f <merging+0x330>
  802e06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e0a:	74 73                	je     802e7f <merging+0x330>
  802e0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e10:	74 06                	je     802e18 <merging+0x2c9>
  802e12:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e16:	75 17                	jne    802e2f <merging+0x2e0>
  802e18:	83 ec 04             	sub    $0x4,%esp
  802e1b:	68 90 42 80 00       	push   $0x804290
  802e20:	68 94 01 00 00       	push   $0x194
  802e25:	68 1d 42 80 00       	push   $0x80421d
  802e2a:	e8 98 09 00 00       	call   8037c7 <_panic>
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 10                	mov    (%eax),%edx
  802e34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e37:	89 10                	mov    %edx,(%eax)
  802e39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e3c:	8b 00                	mov    (%eax),%eax
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	74 0b                	je     802e4d <merging+0x2fe>
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	8b 00                	mov    (%eax),%eax
  802e47:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e4a:	89 50 04             	mov    %edx,0x4(%eax)
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e53:	89 10                	mov    %edx,(%eax)
  802e55:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e58:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5b:	89 50 04             	mov    %edx,0x4(%eax)
  802e5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e61:	8b 00                	mov    (%eax),%eax
  802e63:	85 c0                	test   %eax,%eax
  802e65:	75 08                	jne    802e6f <merging+0x320>
  802e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e6a:	a3 34 50 80 00       	mov    %eax,0x805034
  802e6f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e74:	40                   	inc    %eax
  802e75:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802e7a:	e9 ce 00 00 00       	jmp    802f4d <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802e7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e83:	74 65                	je     802eea <merging+0x39b>
  802e85:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e89:	75 17                	jne    802ea2 <merging+0x353>
  802e8b:	83 ec 04             	sub    $0x4,%esp
  802e8e:	68 6c 42 80 00       	push   $0x80426c
  802e93:	68 95 01 00 00       	push   $0x195
  802e98:	68 1d 42 80 00       	push   $0x80421d
  802e9d:	e8 25 09 00 00       	call   8037c7 <_panic>
  802ea2:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eab:	89 50 04             	mov    %edx,0x4(%eax)
  802eae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb1:	8b 40 04             	mov    0x4(%eax),%eax
  802eb4:	85 c0                	test   %eax,%eax
  802eb6:	74 0c                	je     802ec4 <merging+0x375>
  802eb8:	a1 34 50 80 00       	mov    0x805034,%eax
  802ebd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ec0:	89 10                	mov    %edx,(%eax)
  802ec2:	eb 08                	jmp    802ecc <merging+0x37d>
  802ec4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec7:	a3 30 50 80 00       	mov    %eax,0x805030
  802ecc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ecf:	a3 34 50 80 00       	mov    %eax,0x805034
  802ed4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802edd:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ee2:	40                   	inc    %eax
  802ee3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802ee8:	eb 63                	jmp    802f4d <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802eea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802eee:	75 17                	jne    802f07 <merging+0x3b8>
  802ef0:	83 ec 04             	sub    $0x4,%esp
  802ef3:	68 38 42 80 00       	push   $0x804238
  802ef8:	68 98 01 00 00       	push   $0x198
  802efd:	68 1d 42 80 00       	push   $0x80421d
  802f02:	e8 c0 08 00 00       	call   8037c7 <_panic>
  802f07:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802f0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f10:	89 10                	mov    %edx,(%eax)
  802f12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	85 c0                	test   %eax,%eax
  802f19:	74 0d                	je     802f28 <merging+0x3d9>
  802f1b:	a1 30 50 80 00       	mov    0x805030,%eax
  802f20:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f23:	89 50 04             	mov    %edx,0x4(%eax)
  802f26:	eb 08                	jmp    802f30 <merging+0x3e1>
  802f28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f2b:	a3 34 50 80 00       	mov    %eax,0x805034
  802f30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f33:	a3 30 50 80 00       	mov    %eax,0x805030
  802f38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f42:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f47:	40                   	inc    %eax
  802f48:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  802f4d:	83 ec 0c             	sub    $0xc,%esp
  802f50:	ff 75 10             	pushl  0x10(%ebp)
  802f53:	e8 d6 ed ff ff       	call   801d2e <get_block_size>
  802f58:	83 c4 10             	add    $0x10,%esp
  802f5b:	83 ec 04             	sub    $0x4,%esp
  802f5e:	6a 00                	push   $0x0
  802f60:	50                   	push   %eax
  802f61:	ff 75 10             	pushl  0x10(%ebp)
  802f64:	e8 16 f1 ff ff       	call   80207f <set_block_data>
  802f69:	83 c4 10             	add    $0x10,%esp
	}
}
  802f6c:	90                   	nop
  802f6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f70:	c9                   	leave  
  802f71:	c3                   	ret    

00802f72 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802f72:	55                   	push   %ebp
  802f73:	89 e5                	mov    %esp,%ebp
  802f75:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802f78:	a1 30 50 80 00       	mov    0x805030,%eax
  802f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802f80:	a1 34 50 80 00       	mov    0x805034,%eax
  802f85:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f88:	73 1b                	jae    802fa5 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802f8a:	a1 34 50 80 00       	mov    0x805034,%eax
  802f8f:	83 ec 04             	sub    $0x4,%esp
  802f92:	ff 75 08             	pushl  0x8(%ebp)
  802f95:	6a 00                	push   $0x0
  802f97:	50                   	push   %eax
  802f98:	e8 b2 fb ff ff       	call   802b4f <merging>
  802f9d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fa0:	e9 8b 00 00 00       	jmp    803030 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802fa5:	a1 30 50 80 00       	mov    0x805030,%eax
  802faa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fad:	76 18                	jbe    802fc7 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802faf:	a1 30 50 80 00       	mov    0x805030,%eax
  802fb4:	83 ec 04             	sub    $0x4,%esp
  802fb7:	ff 75 08             	pushl  0x8(%ebp)
  802fba:	50                   	push   %eax
  802fbb:	6a 00                	push   $0x0
  802fbd:	e8 8d fb ff ff       	call   802b4f <merging>
  802fc2:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fc5:	eb 69                	jmp    803030 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802fc7:	a1 30 50 80 00       	mov    0x805030,%eax
  802fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fcf:	eb 39                	jmp    80300a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fd7:	73 29                	jae    803002 <free_block+0x90>
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fe1:	76 1f                	jbe    803002 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 00                	mov    (%eax),%eax
  802fe8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802feb:	83 ec 04             	sub    $0x4,%esp
  802fee:	ff 75 08             	pushl  0x8(%ebp)
  802ff1:	ff 75 f0             	pushl  -0x10(%ebp)
  802ff4:	ff 75 f4             	pushl  -0xc(%ebp)
  802ff7:	e8 53 fb ff ff       	call   802b4f <merging>
  802ffc:	83 c4 10             	add    $0x10,%esp
			break;
  802fff:	90                   	nop
		}
	}
}
  803000:	eb 2e                	jmp    803030 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803002:	a1 38 50 80 00       	mov    0x805038,%eax
  803007:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300e:	74 07                	je     803017 <free_block+0xa5>
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	eb 05                	jmp    80301c <free_block+0xaa>
  803017:	b8 00 00 00 00       	mov    $0x0,%eax
  80301c:	a3 38 50 80 00       	mov    %eax,0x805038
  803021:	a1 38 50 80 00       	mov    0x805038,%eax
  803026:	85 c0                	test   %eax,%eax
  803028:	75 a7                	jne    802fd1 <free_block+0x5f>
  80302a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302e:	75 a1                	jne    802fd1 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803030:	90                   	nop
  803031:	c9                   	leave  
  803032:	c3                   	ret    

00803033 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803033:	55                   	push   %ebp
  803034:	89 e5                	mov    %esp,%ebp
  803036:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803039:	ff 75 08             	pushl  0x8(%ebp)
  80303c:	e8 ed ec ff ff       	call   801d2e <get_block_size>
  803041:	83 c4 04             	add    $0x4,%esp
  803044:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803047:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80304e:	eb 17                	jmp    803067 <copy_data+0x34>
  803050:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803053:	8b 45 0c             	mov    0xc(%ebp),%eax
  803056:	01 c2                	add    %eax,%edx
  803058:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	01 c8                	add    %ecx,%eax
  803060:	8a 00                	mov    (%eax),%al
  803062:	88 02                	mov    %al,(%edx)
  803064:	ff 45 fc             	incl   -0x4(%ebp)
  803067:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80306a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80306d:	72 e1                	jb     803050 <copy_data+0x1d>
}
  80306f:	90                   	nop
  803070:	c9                   	leave  
  803071:	c3                   	ret    

00803072 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  803072:	55                   	push   %ebp
  803073:	89 e5                	mov    %esp,%ebp
  803075:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803078:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307c:	75 23                	jne    8030a1 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80307e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803082:	74 13                	je     803097 <realloc_block_FF+0x25>
  803084:	83 ec 0c             	sub    $0xc,%esp
  803087:	ff 75 0c             	pushl  0xc(%ebp)
  80308a:	e8 1f f0 ff ff       	call   8020ae <alloc_block_FF>
  80308f:	83 c4 10             	add    $0x10,%esp
  803092:	e9 f4 06 00 00       	jmp    80378b <realloc_block_FF+0x719>
		return NULL;
  803097:	b8 00 00 00 00       	mov    $0x0,%eax
  80309c:	e9 ea 06 00 00       	jmp    80378b <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  8030a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030a5:	75 18                	jne    8030bf <realloc_block_FF+0x4d>
	{
		free_block(va);
  8030a7:	83 ec 0c             	sub    $0xc,%esp
  8030aa:	ff 75 08             	pushl  0x8(%ebp)
  8030ad:	e8 c0 fe ff ff       	call   802f72 <free_block>
  8030b2:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8030b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ba:	e9 cc 06 00 00       	jmp    80378b <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  8030bf:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8030c3:	77 07                	ja     8030cc <realloc_block_FF+0x5a>
  8030c5:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8030cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030cf:	83 e0 01             	and    $0x1,%eax
  8030d2:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8030d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d8:	83 c0 08             	add    $0x8,%eax
  8030db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8030de:	83 ec 0c             	sub    $0xc,%esp
  8030e1:	ff 75 08             	pushl  0x8(%ebp)
  8030e4:	e8 45 ec ff ff       	call   801d2e <get_block_size>
  8030e9:	83 c4 10             	add    $0x10,%esp
  8030ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8030ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f2:	83 e8 08             	sub    $0x8,%eax
  8030f5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	83 e8 04             	sub    $0x4,%eax
  8030fe:	8b 00                	mov    (%eax),%eax
  803100:	83 e0 fe             	and    $0xfffffffe,%eax
  803103:	89 c2                	mov    %eax,%edx
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	01 d0                	add    %edx,%eax
  80310a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80310d:	83 ec 0c             	sub    $0xc,%esp
  803110:	ff 75 e4             	pushl  -0x1c(%ebp)
  803113:	e8 16 ec ff ff       	call   801d2e <get_block_size>
  803118:	83 c4 10             	add    $0x10,%esp
  80311b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80311e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803121:	83 e8 08             	sub    $0x8,%eax
  803124:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80312a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80312d:	75 08                	jne    803137 <realloc_block_FF+0xc5>
	{
		 return va;
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	e9 54 06 00 00       	jmp    80378b <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80313d:	0f 83 e5 03 00 00    	jae    803528 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803146:	2b 45 0c             	sub    0xc(%ebp),%eax
  803149:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  80314c:	83 ec 0c             	sub    $0xc,%esp
  80314f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803152:	e8 f0 eb ff ff       	call   801d47 <is_free_block>
  803157:	83 c4 10             	add    $0x10,%esp
  80315a:	84 c0                	test   %al,%al
  80315c:	0f 84 3b 01 00 00    	je     80329d <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  803162:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803165:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803168:	01 d0                	add    %edx,%eax
  80316a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80316d:	83 ec 04             	sub    $0x4,%esp
  803170:	6a 01                	push   $0x1
  803172:	ff 75 f0             	pushl  -0x10(%ebp)
  803175:	ff 75 08             	pushl  0x8(%ebp)
  803178:	e8 02 ef ff ff       	call   80207f <set_block_data>
  80317d:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	83 e8 04             	sub    $0x4,%eax
  803186:	8b 00                	mov    (%eax),%eax
  803188:	83 e0 fe             	and    $0xfffffffe,%eax
  80318b:	89 c2                	mov    %eax,%edx
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	01 d0                	add    %edx,%eax
  803192:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803195:	83 ec 04             	sub    $0x4,%esp
  803198:	6a 00                	push   $0x0
  80319a:	ff 75 cc             	pushl  -0x34(%ebp)
  80319d:	ff 75 c8             	pushl  -0x38(%ebp)
  8031a0:	e8 da ee ff ff       	call   80207f <set_block_data>
  8031a5:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8031a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031ac:	74 06                	je     8031b4 <realloc_block_FF+0x142>
  8031ae:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8031b2:	75 17                	jne    8031cb <realloc_block_FF+0x159>
  8031b4:	83 ec 04             	sub    $0x4,%esp
  8031b7:	68 90 42 80 00       	push   $0x804290
  8031bc:	68 f6 01 00 00       	push   $0x1f6
  8031c1:	68 1d 42 80 00       	push   $0x80421d
  8031c6:	e8 fc 05 00 00       	call   8037c7 <_panic>
  8031cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ce:	8b 10                	mov    (%eax),%edx
  8031d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031d3:	89 10                	mov    %edx,(%eax)
  8031d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031d8:	8b 00                	mov    (%eax),%eax
  8031da:	85 c0                	test   %eax,%eax
  8031dc:	74 0b                	je     8031e9 <realloc_block_FF+0x177>
  8031de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e1:	8b 00                	mov    (%eax),%eax
  8031e3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031e6:	89 50 04             	mov    %edx,0x4(%eax)
  8031e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ec:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031ef:	89 10                	mov    %edx,(%eax)
  8031f1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031f7:	89 50 04             	mov    %edx,0x4(%eax)
  8031fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031fd:	8b 00                	mov    (%eax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	75 08                	jne    80320b <realloc_block_FF+0x199>
  803203:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803206:	a3 34 50 80 00       	mov    %eax,0x805034
  80320b:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803210:	40                   	inc    %eax
  803211:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803216:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80321a:	75 17                	jne    803233 <realloc_block_FF+0x1c1>
  80321c:	83 ec 04             	sub    $0x4,%esp
  80321f:	68 ff 41 80 00       	push   $0x8041ff
  803224:	68 f7 01 00 00       	push   $0x1f7
  803229:	68 1d 42 80 00       	push   $0x80421d
  80322e:	e8 94 05 00 00       	call   8037c7 <_panic>
  803233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	74 10                	je     80324c <realloc_block_FF+0x1da>
  80323c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323f:	8b 00                	mov    (%eax),%eax
  803241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803244:	8b 52 04             	mov    0x4(%edx),%edx
  803247:	89 50 04             	mov    %edx,0x4(%eax)
  80324a:	eb 0b                	jmp    803257 <realloc_block_FF+0x1e5>
  80324c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324f:	8b 40 04             	mov    0x4(%eax),%eax
  803252:	a3 34 50 80 00       	mov    %eax,0x805034
  803257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325a:	8b 40 04             	mov    0x4(%eax),%eax
  80325d:	85 c0                	test   %eax,%eax
  80325f:	74 0f                	je     803270 <realloc_block_FF+0x1fe>
  803261:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803264:	8b 40 04             	mov    0x4(%eax),%eax
  803267:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80326a:	8b 12                	mov    (%edx),%edx
  80326c:	89 10                	mov    %edx,(%eax)
  80326e:	eb 0a                	jmp    80327a <realloc_block_FF+0x208>
  803270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	a3 30 50 80 00       	mov    %eax,0x805030
  80327a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803286:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803292:	48                   	dec    %eax
  803293:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803298:	e9 83 02 00 00       	jmp    803520 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80329d:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8032a1:	0f 86 69 02 00 00    	jbe    803510 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8032a7:	83 ec 04             	sub    $0x4,%esp
  8032aa:	6a 01                	push   $0x1
  8032ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8032af:	ff 75 08             	pushl  0x8(%ebp)
  8032b2:	e8 c8 ed ff ff       	call   80207f <set_block_data>
  8032b7:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	83 e8 04             	sub    $0x4,%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	83 e0 fe             	and    $0xfffffffe,%eax
  8032c5:	89 c2                	mov    %eax,%edx
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	01 d0                	add    %edx,%eax
  8032cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8032cf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8032d7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8032db:	75 68                	jne    803345 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032dd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032e1:	75 17                	jne    8032fa <realloc_block_FF+0x288>
  8032e3:	83 ec 04             	sub    $0x4,%esp
  8032e6:	68 38 42 80 00       	push   $0x804238
  8032eb:	68 06 02 00 00       	push   $0x206
  8032f0:	68 1d 42 80 00       	push   $0x80421d
  8032f5:	e8 cd 04 00 00       	call   8037c7 <_panic>
  8032fa:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803300:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803303:	89 10                	mov    %edx,(%eax)
  803305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803308:	8b 00                	mov    (%eax),%eax
  80330a:	85 c0                	test   %eax,%eax
  80330c:	74 0d                	je     80331b <realloc_block_FF+0x2a9>
  80330e:	a1 30 50 80 00       	mov    0x805030,%eax
  803313:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803316:	89 50 04             	mov    %edx,0x4(%eax)
  803319:	eb 08                	jmp    803323 <realloc_block_FF+0x2b1>
  80331b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80331e:	a3 34 50 80 00       	mov    %eax,0x805034
  803323:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803326:	a3 30 50 80 00       	mov    %eax,0x805030
  80332b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80332e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803335:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80333a:	40                   	inc    %eax
  80333b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803340:	e9 b0 01 00 00       	jmp    8034f5 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803345:	a1 30 50 80 00       	mov    0x805030,%eax
  80334a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80334d:	76 68                	jbe    8033b7 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80334f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803353:	75 17                	jne    80336c <realloc_block_FF+0x2fa>
  803355:	83 ec 04             	sub    $0x4,%esp
  803358:	68 38 42 80 00       	push   $0x804238
  80335d:	68 0b 02 00 00       	push   $0x20b
  803362:	68 1d 42 80 00       	push   $0x80421d
  803367:	e8 5b 04 00 00       	call   8037c7 <_panic>
  80336c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803372:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803375:	89 10                	mov    %edx,(%eax)
  803377:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	74 0d                	je     80338d <realloc_block_FF+0x31b>
  803380:	a1 30 50 80 00       	mov    0x805030,%eax
  803385:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803388:	89 50 04             	mov    %edx,0x4(%eax)
  80338b:	eb 08                	jmp    803395 <realloc_block_FF+0x323>
  80338d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803390:	a3 34 50 80 00       	mov    %eax,0x805034
  803395:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803398:	a3 30 50 80 00       	mov    %eax,0x805030
  80339d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a7:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033ac:	40                   	inc    %eax
  8033ad:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8033b2:	e9 3e 01 00 00       	jmp    8034f5 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8033b7:	a1 30 50 80 00       	mov    0x805030,%eax
  8033bc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033bf:	73 68                	jae    803429 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8033c1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033c5:	75 17                	jne    8033de <realloc_block_FF+0x36c>
  8033c7:	83 ec 04             	sub    $0x4,%esp
  8033ca:	68 6c 42 80 00       	push   $0x80426c
  8033cf:	68 10 02 00 00       	push   $0x210
  8033d4:	68 1d 42 80 00       	push   $0x80421d
  8033d9:	e8 e9 03 00 00       	call   8037c7 <_panic>
  8033de:	8b 15 34 50 80 00    	mov    0x805034,%edx
  8033e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ed:	8b 40 04             	mov    0x4(%eax),%eax
  8033f0:	85 c0                	test   %eax,%eax
  8033f2:	74 0c                	je     803400 <realloc_block_FF+0x38e>
  8033f4:	a1 34 50 80 00       	mov    0x805034,%eax
  8033f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033fc:	89 10                	mov    %edx,(%eax)
  8033fe:	eb 08                	jmp    803408 <realloc_block_FF+0x396>
  803400:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803403:	a3 30 50 80 00       	mov    %eax,0x805030
  803408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340b:	a3 34 50 80 00       	mov    %eax,0x805034
  803410:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803413:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803419:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80341e:	40                   	inc    %eax
  80341f:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803424:	e9 cc 00 00 00       	jmp    8034f5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803429:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803430:	a1 30 50 80 00       	mov    0x805030,%eax
  803435:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803438:	e9 8a 00 00 00       	jmp    8034c7 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80343d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803440:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803443:	73 7a                	jae    8034bf <realloc_block_FF+0x44d>
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	8b 00                	mov    (%eax),%eax
  80344a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80344d:	73 70                	jae    8034bf <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80344f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803453:	74 06                	je     80345b <realloc_block_FF+0x3e9>
  803455:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803459:	75 17                	jne    803472 <realloc_block_FF+0x400>
  80345b:	83 ec 04             	sub    $0x4,%esp
  80345e:	68 90 42 80 00       	push   $0x804290
  803463:	68 1a 02 00 00       	push   $0x21a
  803468:	68 1d 42 80 00       	push   $0x80421d
  80346d:	e8 55 03 00 00       	call   8037c7 <_panic>
  803472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803475:	8b 10                	mov    (%eax),%edx
  803477:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347a:	89 10                	mov    %edx,(%eax)
  80347c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80347f:	8b 00                	mov    (%eax),%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	74 0b                	je     803490 <realloc_block_FF+0x41e>
  803485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803488:	8b 00                	mov    (%eax),%eax
  80348a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80348d:	89 50 04             	mov    %edx,0x4(%eax)
  803490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803493:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803496:	89 10                	mov    %edx,(%eax)
  803498:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349e:	89 50 04             	mov    %edx,0x4(%eax)
  8034a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a4:	8b 00                	mov    (%eax),%eax
  8034a6:	85 c0                	test   %eax,%eax
  8034a8:	75 08                	jne    8034b2 <realloc_block_FF+0x440>
  8034aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034ad:	a3 34 50 80 00       	mov    %eax,0x805034
  8034b2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034b7:	40                   	inc    %eax
  8034b8:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  8034bd:	eb 36                	jmp    8034f5 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8034bf:	a1 38 50 80 00       	mov    0x805038,%eax
  8034c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034cb:	74 07                	je     8034d4 <realloc_block_FF+0x462>
  8034cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d0:	8b 00                	mov    (%eax),%eax
  8034d2:	eb 05                	jmp    8034d9 <realloc_block_FF+0x467>
  8034d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d9:	a3 38 50 80 00       	mov    %eax,0x805038
  8034de:	a1 38 50 80 00       	mov    0x805038,%eax
  8034e3:	85 c0                	test   %eax,%eax
  8034e5:	0f 85 52 ff ff ff    	jne    80343d <realloc_block_FF+0x3cb>
  8034eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ef:	0f 85 48 ff ff ff    	jne    80343d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8034f5:	83 ec 04             	sub    $0x4,%esp
  8034f8:	6a 00                	push   $0x0
  8034fa:	ff 75 d8             	pushl  -0x28(%ebp)
  8034fd:	ff 75 d4             	pushl  -0x2c(%ebp)
  803500:	e8 7a eb ff ff       	call   80207f <set_block_data>
  803505:	83 c4 10             	add    $0x10,%esp
				return va;
  803508:	8b 45 08             	mov    0x8(%ebp),%eax
  80350b:	e9 7b 02 00 00       	jmp    80378b <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803510:	83 ec 0c             	sub    $0xc,%esp
  803513:	68 0d 43 80 00       	push   $0x80430d
  803518:	e8 2e ce ff ff       	call   80034b <cprintf>
  80351d:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	e9 63 02 00 00       	jmp    80378b <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80352e:	0f 86 4d 02 00 00    	jbe    803781 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803534:	83 ec 0c             	sub    $0xc,%esp
  803537:	ff 75 e4             	pushl  -0x1c(%ebp)
  80353a:	e8 08 e8 ff ff       	call   801d47 <is_free_block>
  80353f:	83 c4 10             	add    $0x10,%esp
  803542:	84 c0                	test   %al,%al
  803544:	0f 84 37 02 00 00    	je     803781 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80354a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803550:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803553:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803556:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803559:	76 38                	jbe    803593 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  80355b:	83 ec 0c             	sub    $0xc,%esp
  80355e:	ff 75 08             	pushl  0x8(%ebp)
  803561:	e8 0c fa ff ff       	call   802f72 <free_block>
  803566:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803569:	83 ec 0c             	sub    $0xc,%esp
  80356c:	ff 75 0c             	pushl  0xc(%ebp)
  80356f:	e8 3a eb ff ff       	call   8020ae <alloc_block_FF>
  803574:	83 c4 10             	add    $0x10,%esp
  803577:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  80357a:	83 ec 08             	sub    $0x8,%esp
  80357d:	ff 75 c0             	pushl  -0x40(%ebp)
  803580:	ff 75 08             	pushl  0x8(%ebp)
  803583:	e8 ab fa ff ff       	call   803033 <copy_data>
  803588:	83 c4 10             	add    $0x10,%esp
				return new_va;
  80358b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80358e:	e9 f8 01 00 00       	jmp    80378b <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803593:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803596:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803599:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80359c:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8035a0:	0f 87 a0 00 00 00    	ja     803646 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8035a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035aa:	75 17                	jne    8035c3 <realloc_block_FF+0x551>
  8035ac:	83 ec 04             	sub    $0x4,%esp
  8035af:	68 ff 41 80 00       	push   $0x8041ff
  8035b4:	68 38 02 00 00       	push   $0x238
  8035b9:	68 1d 42 80 00       	push   $0x80421d
  8035be:	e8 04 02 00 00       	call   8037c7 <_panic>
  8035c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c6:	8b 00                	mov    (%eax),%eax
  8035c8:	85 c0                	test   %eax,%eax
  8035ca:	74 10                	je     8035dc <realloc_block_FF+0x56a>
  8035cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035cf:	8b 00                	mov    (%eax),%eax
  8035d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d4:	8b 52 04             	mov    0x4(%edx),%edx
  8035d7:	89 50 04             	mov    %edx,0x4(%eax)
  8035da:	eb 0b                	jmp    8035e7 <realloc_block_FF+0x575>
  8035dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035df:	8b 40 04             	mov    0x4(%eax),%eax
  8035e2:	a3 34 50 80 00       	mov    %eax,0x805034
  8035e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ea:	8b 40 04             	mov    0x4(%eax),%eax
  8035ed:	85 c0                	test   %eax,%eax
  8035ef:	74 0f                	je     803600 <realloc_block_FF+0x58e>
  8035f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f4:	8b 40 04             	mov    0x4(%eax),%eax
  8035f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035fa:	8b 12                	mov    (%edx),%edx
  8035fc:	89 10                	mov    %edx,(%eax)
  8035fe:	eb 0a                	jmp    80360a <realloc_block_FF+0x598>
  803600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803603:	8b 00                	mov    (%eax),%eax
  803605:	a3 30 50 80 00       	mov    %eax,0x805030
  80360a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803616:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361d:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803622:	48                   	dec    %eax
  803623:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803628:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80362b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80362e:	01 d0                	add    %edx,%eax
  803630:	83 ec 04             	sub    $0x4,%esp
  803633:	6a 01                	push   $0x1
  803635:	50                   	push   %eax
  803636:	ff 75 08             	pushl  0x8(%ebp)
  803639:	e8 41 ea ff ff       	call   80207f <set_block_data>
  80363e:	83 c4 10             	add    $0x10,%esp
  803641:	e9 36 01 00 00       	jmp    80377c <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803646:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803649:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80364c:	01 d0                	add    %edx,%eax
  80364e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803651:	83 ec 04             	sub    $0x4,%esp
  803654:	6a 01                	push   $0x1
  803656:	ff 75 f0             	pushl  -0x10(%ebp)
  803659:	ff 75 08             	pushl  0x8(%ebp)
  80365c:	e8 1e ea ff ff       	call   80207f <set_block_data>
  803661:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803664:	8b 45 08             	mov    0x8(%ebp),%eax
  803667:	83 e8 04             	sub    $0x4,%eax
  80366a:	8b 00                	mov    (%eax),%eax
  80366c:	83 e0 fe             	and    $0xfffffffe,%eax
  80366f:	89 c2                	mov    %eax,%edx
  803671:	8b 45 08             	mov    0x8(%ebp),%eax
  803674:	01 d0                	add    %edx,%eax
  803676:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803679:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80367d:	74 06                	je     803685 <realloc_block_FF+0x613>
  80367f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803683:	75 17                	jne    80369c <realloc_block_FF+0x62a>
  803685:	83 ec 04             	sub    $0x4,%esp
  803688:	68 90 42 80 00       	push   $0x804290
  80368d:	68 44 02 00 00       	push   $0x244
  803692:	68 1d 42 80 00       	push   $0x80421d
  803697:	e8 2b 01 00 00       	call   8037c7 <_panic>
  80369c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369f:	8b 10                	mov    (%eax),%edx
  8036a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036a4:	89 10                	mov    %edx,(%eax)
  8036a6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036a9:	8b 00                	mov    (%eax),%eax
  8036ab:	85 c0                	test   %eax,%eax
  8036ad:	74 0b                	je     8036ba <realloc_block_FF+0x648>
  8036af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b2:	8b 00                	mov    (%eax),%eax
  8036b4:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8036b7:	89 50 04             	mov    %edx,0x4(%eax)
  8036ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036bd:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8036c0:	89 10                	mov    %edx,(%eax)
  8036c2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036c8:	89 50 04             	mov    %edx,0x4(%eax)
  8036cb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036ce:	8b 00                	mov    (%eax),%eax
  8036d0:	85 c0                	test   %eax,%eax
  8036d2:	75 08                	jne    8036dc <realloc_block_FF+0x66a>
  8036d4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8036dc:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036e1:	40                   	inc    %eax
  8036e2:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8036e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036eb:	75 17                	jne    803704 <realloc_block_FF+0x692>
  8036ed:	83 ec 04             	sub    $0x4,%esp
  8036f0:	68 ff 41 80 00       	push   $0x8041ff
  8036f5:	68 45 02 00 00       	push   $0x245
  8036fa:	68 1d 42 80 00       	push   $0x80421d
  8036ff:	e8 c3 00 00 00       	call   8037c7 <_panic>
  803704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803707:	8b 00                	mov    (%eax),%eax
  803709:	85 c0                	test   %eax,%eax
  80370b:	74 10                	je     80371d <realloc_block_FF+0x6ab>
  80370d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803710:	8b 00                	mov    (%eax),%eax
  803712:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803715:	8b 52 04             	mov    0x4(%edx),%edx
  803718:	89 50 04             	mov    %edx,0x4(%eax)
  80371b:	eb 0b                	jmp    803728 <realloc_block_FF+0x6b6>
  80371d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803720:	8b 40 04             	mov    0x4(%eax),%eax
  803723:	a3 34 50 80 00       	mov    %eax,0x805034
  803728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372b:	8b 40 04             	mov    0x4(%eax),%eax
  80372e:	85 c0                	test   %eax,%eax
  803730:	74 0f                	je     803741 <realloc_block_FF+0x6cf>
  803732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803735:	8b 40 04             	mov    0x4(%eax),%eax
  803738:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80373b:	8b 12                	mov    (%edx),%edx
  80373d:	89 10                	mov    %edx,(%eax)
  80373f:	eb 0a                	jmp    80374b <realloc_block_FF+0x6d9>
  803741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803744:	8b 00                	mov    (%eax),%eax
  803746:	a3 30 50 80 00       	mov    %eax,0x805030
  80374b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803757:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80375e:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803763:	48                   	dec    %eax
  803764:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803769:	83 ec 04             	sub    $0x4,%esp
  80376c:	6a 00                	push   $0x0
  80376e:	ff 75 bc             	pushl  -0x44(%ebp)
  803771:	ff 75 b8             	pushl  -0x48(%ebp)
  803774:	e8 06 e9 ff ff       	call   80207f <set_block_data>
  803779:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  80377c:	8b 45 08             	mov    0x8(%ebp),%eax
  80377f:	eb 0a                	jmp    80378b <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803781:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803788:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80378b:	c9                   	leave  
  80378c:	c3                   	ret    

0080378d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80378d:	55                   	push   %ebp
  80378e:	89 e5                	mov    %esp,%ebp
  803790:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803793:	83 ec 04             	sub    $0x4,%esp
  803796:	68 14 43 80 00       	push   $0x804314
  80379b:	68 58 02 00 00       	push   $0x258
  8037a0:	68 1d 42 80 00       	push   $0x80421d
  8037a5:	e8 1d 00 00 00       	call   8037c7 <_panic>

008037aa <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8037aa:	55                   	push   %ebp
  8037ab:	89 e5                	mov    %esp,%ebp
  8037ad:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8037b0:	83 ec 04             	sub    $0x4,%esp
  8037b3:	68 3c 43 80 00       	push   $0x80433c
  8037b8:	68 61 02 00 00       	push   $0x261
  8037bd:	68 1d 42 80 00       	push   $0x80421d
  8037c2:	e8 00 00 00 00       	call   8037c7 <_panic>

008037c7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8037c7:	55                   	push   %ebp
  8037c8:	89 e5                	mov    %esp,%ebp
  8037ca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8037cd:	8d 45 10             	lea    0x10(%ebp),%eax
  8037d0:	83 c0 04             	add    $0x4,%eax
  8037d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8037d6:	a1 60 90 18 01       	mov    0x1189060,%eax
  8037db:	85 c0                	test   %eax,%eax
  8037dd:	74 16                	je     8037f5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8037df:	a1 60 90 18 01       	mov    0x1189060,%eax
  8037e4:	83 ec 08             	sub    $0x8,%esp
  8037e7:	50                   	push   %eax
  8037e8:	68 64 43 80 00       	push   $0x804364
  8037ed:	e8 59 cb ff ff       	call   80034b <cprintf>
  8037f2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8037f5:	a1 00 50 80 00       	mov    0x805000,%eax
  8037fa:	ff 75 0c             	pushl  0xc(%ebp)
  8037fd:	ff 75 08             	pushl  0x8(%ebp)
  803800:	50                   	push   %eax
  803801:	68 69 43 80 00       	push   $0x804369
  803806:	e8 40 cb ff ff       	call   80034b <cprintf>
  80380b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80380e:	8b 45 10             	mov    0x10(%ebp),%eax
  803811:	83 ec 08             	sub    $0x8,%esp
  803814:	ff 75 f4             	pushl  -0xc(%ebp)
  803817:	50                   	push   %eax
  803818:	e8 c3 ca ff ff       	call   8002e0 <vcprintf>
  80381d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803820:	83 ec 08             	sub    $0x8,%esp
  803823:	6a 00                	push   $0x0
  803825:	68 85 43 80 00       	push   $0x804385
  80382a:	e8 b1 ca ff ff       	call   8002e0 <vcprintf>
  80382f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803832:	e8 32 ca ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  803837:	eb fe                	jmp    803837 <_panic+0x70>

00803839 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803839:	55                   	push   %ebp
  80383a:	89 e5                	mov    %esp,%ebp
  80383c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80383f:	a1 20 50 80 00       	mov    0x805020,%eax
  803844:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80384a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80384d:	39 c2                	cmp    %eax,%edx
  80384f:	74 14                	je     803865 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803851:	83 ec 04             	sub    $0x4,%esp
  803854:	68 88 43 80 00       	push   $0x804388
  803859:	6a 26                	push   $0x26
  80385b:	68 d4 43 80 00       	push   $0x8043d4
  803860:	e8 62 ff ff ff       	call   8037c7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803865:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80386c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803873:	e9 c5 00 00 00       	jmp    80393d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80387b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803882:	8b 45 08             	mov    0x8(%ebp),%eax
  803885:	01 d0                	add    %edx,%eax
  803887:	8b 00                	mov    (%eax),%eax
  803889:	85 c0                	test   %eax,%eax
  80388b:	75 08                	jne    803895 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80388d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803890:	e9 a5 00 00 00       	jmp    80393a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803895:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80389c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8038a3:	eb 69                	jmp    80390e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8038a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8038aa:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038b3:	89 d0                	mov    %edx,%eax
  8038b5:	01 c0                	add    %eax,%eax
  8038b7:	01 d0                	add    %edx,%eax
  8038b9:	c1 e0 03             	shl    $0x3,%eax
  8038bc:	01 c8                	add    %ecx,%eax
  8038be:	8a 40 04             	mov    0x4(%eax),%al
  8038c1:	84 c0                	test   %al,%al
  8038c3:	75 46                	jne    80390b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8038ca:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038d3:	89 d0                	mov    %edx,%eax
  8038d5:	01 c0                	add    %eax,%eax
  8038d7:	01 d0                	add    %edx,%eax
  8038d9:	c1 e0 03             	shl    $0x3,%eax
  8038dc:	01 c8                	add    %ecx,%eax
  8038de:	8b 00                	mov    (%eax),%eax
  8038e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8038e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8038eb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8038ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8038f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fa:	01 c8                	add    %ecx,%eax
  8038fc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038fe:	39 c2                	cmp    %eax,%edx
  803900:	75 09                	jne    80390b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803902:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803909:	eb 15                	jmp    803920 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80390b:	ff 45 e8             	incl   -0x18(%ebp)
  80390e:	a1 20 50 80 00       	mov    0x805020,%eax
  803913:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803919:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391c:	39 c2                	cmp    %eax,%edx
  80391e:	77 85                	ja     8038a5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803920:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803924:	75 14                	jne    80393a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803926:	83 ec 04             	sub    $0x4,%esp
  803929:	68 e0 43 80 00       	push   $0x8043e0
  80392e:	6a 3a                	push   $0x3a
  803930:	68 d4 43 80 00       	push   $0x8043d4
  803935:	e8 8d fe ff ff       	call   8037c7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80393a:	ff 45 f0             	incl   -0x10(%ebp)
  80393d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803940:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803943:	0f 8c 2f ff ff ff    	jl     803878 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803949:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803950:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803957:	eb 26                	jmp    80397f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803959:	a1 20 50 80 00       	mov    0x805020,%eax
  80395e:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803964:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803967:	89 d0                	mov    %edx,%eax
  803969:	01 c0                	add    %eax,%eax
  80396b:	01 d0                	add    %edx,%eax
  80396d:	c1 e0 03             	shl    $0x3,%eax
  803970:	01 c8                	add    %ecx,%eax
  803972:	8a 40 04             	mov    0x4(%eax),%al
  803975:	3c 01                	cmp    $0x1,%al
  803977:	75 03                	jne    80397c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803979:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80397c:	ff 45 e0             	incl   -0x20(%ebp)
  80397f:	a1 20 50 80 00       	mov    0x805020,%eax
  803984:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80398a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80398d:	39 c2                	cmp    %eax,%edx
  80398f:	77 c8                	ja     803959 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803994:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803997:	74 14                	je     8039ad <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803999:	83 ec 04             	sub    $0x4,%esp
  80399c:	68 34 44 80 00       	push   $0x804434
  8039a1:	6a 44                	push   $0x44
  8039a3:	68 d4 43 80 00       	push   $0x8043d4
  8039a8:	e8 1a fe ff ff       	call   8037c7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8039ad:	90                   	nop
  8039ae:	c9                   	leave  
  8039af:	c3                   	ret    

008039b0 <__udivdi3>:
  8039b0:	55                   	push   %ebp
  8039b1:	57                   	push   %edi
  8039b2:	56                   	push   %esi
  8039b3:	53                   	push   %ebx
  8039b4:	83 ec 1c             	sub    $0x1c,%esp
  8039b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039c7:	89 ca                	mov    %ecx,%edx
  8039c9:	89 f8                	mov    %edi,%eax
  8039cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039cf:	85 f6                	test   %esi,%esi
  8039d1:	75 2d                	jne    803a00 <__udivdi3+0x50>
  8039d3:	39 cf                	cmp    %ecx,%edi
  8039d5:	77 65                	ja     803a3c <__udivdi3+0x8c>
  8039d7:	89 fd                	mov    %edi,%ebp
  8039d9:	85 ff                	test   %edi,%edi
  8039db:	75 0b                	jne    8039e8 <__udivdi3+0x38>
  8039dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8039e2:	31 d2                	xor    %edx,%edx
  8039e4:	f7 f7                	div    %edi
  8039e6:	89 c5                	mov    %eax,%ebp
  8039e8:	31 d2                	xor    %edx,%edx
  8039ea:	89 c8                	mov    %ecx,%eax
  8039ec:	f7 f5                	div    %ebp
  8039ee:	89 c1                	mov    %eax,%ecx
  8039f0:	89 d8                	mov    %ebx,%eax
  8039f2:	f7 f5                	div    %ebp
  8039f4:	89 cf                	mov    %ecx,%edi
  8039f6:	89 fa                	mov    %edi,%edx
  8039f8:	83 c4 1c             	add    $0x1c,%esp
  8039fb:	5b                   	pop    %ebx
  8039fc:	5e                   	pop    %esi
  8039fd:	5f                   	pop    %edi
  8039fe:	5d                   	pop    %ebp
  8039ff:	c3                   	ret    
  803a00:	39 ce                	cmp    %ecx,%esi
  803a02:	77 28                	ja     803a2c <__udivdi3+0x7c>
  803a04:	0f bd fe             	bsr    %esi,%edi
  803a07:	83 f7 1f             	xor    $0x1f,%edi
  803a0a:	75 40                	jne    803a4c <__udivdi3+0x9c>
  803a0c:	39 ce                	cmp    %ecx,%esi
  803a0e:	72 0a                	jb     803a1a <__udivdi3+0x6a>
  803a10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a14:	0f 87 9e 00 00 00    	ja     803ab8 <__udivdi3+0x108>
  803a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a1f:	89 fa                	mov    %edi,%edx
  803a21:	83 c4 1c             	add    $0x1c,%esp
  803a24:	5b                   	pop    %ebx
  803a25:	5e                   	pop    %esi
  803a26:	5f                   	pop    %edi
  803a27:	5d                   	pop    %ebp
  803a28:	c3                   	ret    
  803a29:	8d 76 00             	lea    0x0(%esi),%esi
  803a2c:	31 ff                	xor    %edi,%edi
  803a2e:	31 c0                	xor    %eax,%eax
  803a30:	89 fa                	mov    %edi,%edx
  803a32:	83 c4 1c             	add    $0x1c,%esp
  803a35:	5b                   	pop    %ebx
  803a36:	5e                   	pop    %esi
  803a37:	5f                   	pop    %edi
  803a38:	5d                   	pop    %ebp
  803a39:	c3                   	ret    
  803a3a:	66 90                	xchg   %ax,%ax
  803a3c:	89 d8                	mov    %ebx,%eax
  803a3e:	f7 f7                	div    %edi
  803a40:	31 ff                	xor    %edi,%edi
  803a42:	89 fa                	mov    %edi,%edx
  803a44:	83 c4 1c             	add    $0x1c,%esp
  803a47:	5b                   	pop    %ebx
  803a48:	5e                   	pop    %esi
  803a49:	5f                   	pop    %edi
  803a4a:	5d                   	pop    %ebp
  803a4b:	c3                   	ret    
  803a4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a51:	89 eb                	mov    %ebp,%ebx
  803a53:	29 fb                	sub    %edi,%ebx
  803a55:	89 f9                	mov    %edi,%ecx
  803a57:	d3 e6                	shl    %cl,%esi
  803a59:	89 c5                	mov    %eax,%ebp
  803a5b:	88 d9                	mov    %bl,%cl
  803a5d:	d3 ed                	shr    %cl,%ebp
  803a5f:	89 e9                	mov    %ebp,%ecx
  803a61:	09 f1                	or     %esi,%ecx
  803a63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a67:	89 f9                	mov    %edi,%ecx
  803a69:	d3 e0                	shl    %cl,%eax
  803a6b:	89 c5                	mov    %eax,%ebp
  803a6d:	89 d6                	mov    %edx,%esi
  803a6f:	88 d9                	mov    %bl,%cl
  803a71:	d3 ee                	shr    %cl,%esi
  803a73:	89 f9                	mov    %edi,%ecx
  803a75:	d3 e2                	shl    %cl,%edx
  803a77:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a7b:	88 d9                	mov    %bl,%cl
  803a7d:	d3 e8                	shr    %cl,%eax
  803a7f:	09 c2                	or     %eax,%edx
  803a81:	89 d0                	mov    %edx,%eax
  803a83:	89 f2                	mov    %esi,%edx
  803a85:	f7 74 24 0c          	divl   0xc(%esp)
  803a89:	89 d6                	mov    %edx,%esi
  803a8b:	89 c3                	mov    %eax,%ebx
  803a8d:	f7 e5                	mul    %ebp
  803a8f:	39 d6                	cmp    %edx,%esi
  803a91:	72 19                	jb     803aac <__udivdi3+0xfc>
  803a93:	74 0b                	je     803aa0 <__udivdi3+0xf0>
  803a95:	89 d8                	mov    %ebx,%eax
  803a97:	31 ff                	xor    %edi,%edi
  803a99:	e9 58 ff ff ff       	jmp    8039f6 <__udivdi3+0x46>
  803a9e:	66 90                	xchg   %ax,%ax
  803aa0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803aa4:	89 f9                	mov    %edi,%ecx
  803aa6:	d3 e2                	shl    %cl,%edx
  803aa8:	39 c2                	cmp    %eax,%edx
  803aaa:	73 e9                	jae    803a95 <__udivdi3+0xe5>
  803aac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803aaf:	31 ff                	xor    %edi,%edi
  803ab1:	e9 40 ff ff ff       	jmp    8039f6 <__udivdi3+0x46>
  803ab6:	66 90                	xchg   %ax,%ax
  803ab8:	31 c0                	xor    %eax,%eax
  803aba:	e9 37 ff ff ff       	jmp    8039f6 <__udivdi3+0x46>
  803abf:	90                   	nop

00803ac0 <__umoddi3>:
  803ac0:	55                   	push   %ebp
  803ac1:	57                   	push   %edi
  803ac2:	56                   	push   %esi
  803ac3:	53                   	push   %ebx
  803ac4:	83 ec 1c             	sub    $0x1c,%esp
  803ac7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803acb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803acf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ad3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ad7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803adb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803adf:	89 f3                	mov    %esi,%ebx
  803ae1:	89 fa                	mov    %edi,%edx
  803ae3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ae7:	89 34 24             	mov    %esi,(%esp)
  803aea:	85 c0                	test   %eax,%eax
  803aec:	75 1a                	jne    803b08 <__umoddi3+0x48>
  803aee:	39 f7                	cmp    %esi,%edi
  803af0:	0f 86 a2 00 00 00    	jbe    803b98 <__umoddi3+0xd8>
  803af6:	89 c8                	mov    %ecx,%eax
  803af8:	89 f2                	mov    %esi,%edx
  803afa:	f7 f7                	div    %edi
  803afc:	89 d0                	mov    %edx,%eax
  803afe:	31 d2                	xor    %edx,%edx
  803b00:	83 c4 1c             	add    $0x1c,%esp
  803b03:	5b                   	pop    %ebx
  803b04:	5e                   	pop    %esi
  803b05:	5f                   	pop    %edi
  803b06:	5d                   	pop    %ebp
  803b07:	c3                   	ret    
  803b08:	39 f0                	cmp    %esi,%eax
  803b0a:	0f 87 ac 00 00 00    	ja     803bbc <__umoddi3+0xfc>
  803b10:	0f bd e8             	bsr    %eax,%ebp
  803b13:	83 f5 1f             	xor    $0x1f,%ebp
  803b16:	0f 84 ac 00 00 00    	je     803bc8 <__umoddi3+0x108>
  803b1c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b21:	29 ef                	sub    %ebp,%edi
  803b23:	89 fe                	mov    %edi,%esi
  803b25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b29:	89 e9                	mov    %ebp,%ecx
  803b2b:	d3 e0                	shl    %cl,%eax
  803b2d:	89 d7                	mov    %edx,%edi
  803b2f:	89 f1                	mov    %esi,%ecx
  803b31:	d3 ef                	shr    %cl,%edi
  803b33:	09 c7                	or     %eax,%edi
  803b35:	89 e9                	mov    %ebp,%ecx
  803b37:	d3 e2                	shl    %cl,%edx
  803b39:	89 14 24             	mov    %edx,(%esp)
  803b3c:	89 d8                	mov    %ebx,%eax
  803b3e:	d3 e0                	shl    %cl,%eax
  803b40:	89 c2                	mov    %eax,%edx
  803b42:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b46:	d3 e0                	shl    %cl,%eax
  803b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b50:	89 f1                	mov    %esi,%ecx
  803b52:	d3 e8                	shr    %cl,%eax
  803b54:	09 d0                	or     %edx,%eax
  803b56:	d3 eb                	shr    %cl,%ebx
  803b58:	89 da                	mov    %ebx,%edx
  803b5a:	f7 f7                	div    %edi
  803b5c:	89 d3                	mov    %edx,%ebx
  803b5e:	f7 24 24             	mull   (%esp)
  803b61:	89 c6                	mov    %eax,%esi
  803b63:	89 d1                	mov    %edx,%ecx
  803b65:	39 d3                	cmp    %edx,%ebx
  803b67:	0f 82 87 00 00 00    	jb     803bf4 <__umoddi3+0x134>
  803b6d:	0f 84 91 00 00 00    	je     803c04 <__umoddi3+0x144>
  803b73:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b77:	29 f2                	sub    %esi,%edx
  803b79:	19 cb                	sbb    %ecx,%ebx
  803b7b:	89 d8                	mov    %ebx,%eax
  803b7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b81:	d3 e0                	shl    %cl,%eax
  803b83:	89 e9                	mov    %ebp,%ecx
  803b85:	d3 ea                	shr    %cl,%edx
  803b87:	09 d0                	or     %edx,%eax
  803b89:	89 e9                	mov    %ebp,%ecx
  803b8b:	d3 eb                	shr    %cl,%ebx
  803b8d:	89 da                	mov    %ebx,%edx
  803b8f:	83 c4 1c             	add    $0x1c,%esp
  803b92:	5b                   	pop    %ebx
  803b93:	5e                   	pop    %esi
  803b94:	5f                   	pop    %edi
  803b95:	5d                   	pop    %ebp
  803b96:	c3                   	ret    
  803b97:	90                   	nop
  803b98:	89 fd                	mov    %edi,%ebp
  803b9a:	85 ff                	test   %edi,%edi
  803b9c:	75 0b                	jne    803ba9 <__umoddi3+0xe9>
  803b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803ba3:	31 d2                	xor    %edx,%edx
  803ba5:	f7 f7                	div    %edi
  803ba7:	89 c5                	mov    %eax,%ebp
  803ba9:	89 f0                	mov    %esi,%eax
  803bab:	31 d2                	xor    %edx,%edx
  803bad:	f7 f5                	div    %ebp
  803baf:	89 c8                	mov    %ecx,%eax
  803bb1:	f7 f5                	div    %ebp
  803bb3:	89 d0                	mov    %edx,%eax
  803bb5:	e9 44 ff ff ff       	jmp    803afe <__umoddi3+0x3e>
  803bba:	66 90                	xchg   %ax,%ax
  803bbc:	89 c8                	mov    %ecx,%eax
  803bbe:	89 f2                	mov    %esi,%edx
  803bc0:	83 c4 1c             	add    $0x1c,%esp
  803bc3:	5b                   	pop    %ebx
  803bc4:	5e                   	pop    %esi
  803bc5:	5f                   	pop    %edi
  803bc6:	5d                   	pop    %ebp
  803bc7:	c3                   	ret    
  803bc8:	3b 04 24             	cmp    (%esp),%eax
  803bcb:	72 06                	jb     803bd3 <__umoddi3+0x113>
  803bcd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bd1:	77 0f                	ja     803be2 <__umoddi3+0x122>
  803bd3:	89 f2                	mov    %esi,%edx
  803bd5:	29 f9                	sub    %edi,%ecx
  803bd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bdb:	89 14 24             	mov    %edx,(%esp)
  803bde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803be2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803be6:	8b 14 24             	mov    (%esp),%edx
  803be9:	83 c4 1c             	add    $0x1c,%esp
  803bec:	5b                   	pop    %ebx
  803bed:	5e                   	pop    %esi
  803bee:	5f                   	pop    %edi
  803bef:	5d                   	pop    %ebp
  803bf0:	c3                   	ret    
  803bf1:	8d 76 00             	lea    0x0(%esi),%esi
  803bf4:	2b 04 24             	sub    (%esp),%eax
  803bf7:	19 fa                	sbb    %edi,%edx
  803bf9:	89 d1                	mov    %edx,%ecx
  803bfb:	89 c6                	mov    %eax,%esi
  803bfd:	e9 71 ff ff ff       	jmp    803b73 <__umoddi3+0xb3>
  803c02:	66 90                	xchg   %ax,%ax
  803c04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c08:	72 ea                	jb     803bf4 <__umoddi3+0x134>
  803c0a:	89 d9                	mov    %ebx,%ecx
  803c0c:	e9 62 ff ff ff       	jmp    803b73 <__umoddi3+0xb3>
