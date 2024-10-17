
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
  80004b:	e8 b9 10 00 00       	call   801109 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 a0 1c 80 00       	push   $0x801ca0
  800061:	e8 20 03 00 00       	call   800386 <atomic_cprintf>
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
  8000b9:	68 b3 1c 80 00       	push   $0x801cb3
  8000be:	e8 c3 02 00 00       	call   800386 <atomic_cprintf>
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
  8000d7:	e8 56 10 00 00       	call   801132 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 1f 10 00 00       	call   801109 <malloc>
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
  80010f:	68 b3 1c 80 00       	push   $0x801cb3
  800114:	e8 6d 02 00 00       	call   800386 <atomic_cprintf>
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
  80012d:	e8 00 10 00 00       	call   801132 <free>
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
  80013e:	e8 c3 13 00 00       	call   801506 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 06             	shl    $0x6,%eax
  80014e:	29 d0                	sub    %edx,%eax
  800150:	c1 e0 02             	shl    $0x2,%eax
  800153:	01 d0                	add    %edx,%eax
  800155:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015c:	01 c8                	add    %ecx,%eax
  80015e:	c1 e0 03             	shl    $0x3,%eax
  800161:	01 d0                	add    %edx,%eax
  800163:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016a:	29 c2                	sub    %eax,%edx
  80016c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800173:	89 c2                	mov    %eax,%edx
  800175:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  80017b:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800180:	a1 04 30 80 00       	mov    0x803004,%eax
  800185:	8a 40 20             	mov    0x20(%eax),%al
  800188:	84 c0                	test   %al,%al
  80018a:	74 0d                	je     800199 <libmain+0x61>
		binaryname = myEnv->prog_name;
  80018c:	a1 04 30 80 00       	mov    0x803004,%eax
  800191:	83 c0 20             	add    $0x20,%eax
  800194:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800199:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019d:	7e 0a                	jle    8001a9 <libmain+0x71>
		binaryname = argv[0];
  80019f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a2:	8b 00                	mov    (%eax),%eax
  8001a4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 0c             	pushl  0xc(%ebp)
  8001af:	ff 75 08             	pushl  0x8(%ebp)
  8001b2:	e8 81 fe ff ff       	call   800038 <_main>
  8001b7:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001ba:	e8 cb 10 00 00       	call   80128a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	68 d8 1c 80 00       	push   $0x801cd8
  8001c7:	e8 8d 01 00 00       	call   800359 <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d4:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8001da:	a1 04 30 80 00       	mov    0x803004,%eax
  8001df:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	52                   	push   %edx
  8001e9:	50                   	push   %eax
  8001ea:	68 00 1d 80 00       	push   $0x801d00
  8001ef:	e8 65 01 00 00       	call   800359 <cprintf>
  8001f4:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8001fc:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800202:	a1 04 30 80 00       	mov    0x803004,%eax
  800207:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  80020d:	a1 04 30 80 00       	mov    0x803004,%eax
  800212:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800218:	51                   	push   %ecx
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 28 1d 80 00       	push   $0x801d28
  800220:	e8 34 01 00 00       	call   800359 <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800228:	a1 04 30 80 00       	mov    0x803004,%eax
  80022d:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	50                   	push   %eax
  800237:	68 80 1d 80 00       	push   $0x801d80
  80023c:	e8 18 01 00 00       	call   800359 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 d8 1c 80 00       	push   $0x801cd8
  80024c:	e8 08 01 00 00       	call   800359 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800254:	e8 4b 10 00 00       	call   8012a4 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800259:	e8 19 00 00 00       	call   800277 <exit>
}
  80025e:	90                   	nop
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	6a 00                	push   $0x0
  80026c:	e8 61 12 00 00       	call   8014d2 <sys_destroy_env>
  800271:	83 c4 10             	add    $0x10,%esp
}
  800274:	90                   	nop
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <exit>:

void
exit(void)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027d:	e8 b6 12 00 00       	call   801538 <sys_exit_env>
}
  800282:	90                   	nop
  800283:	c9                   	leave  
  800284:	c3                   	ret    

00800285 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800285:	55                   	push   %ebp
  800286:	89 e5                	mov    %esp,%ebp
  800288:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80028b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028e:	8b 00                	mov    (%eax),%eax
  800290:	8d 48 01             	lea    0x1(%eax),%ecx
  800293:	8b 55 0c             	mov    0xc(%ebp),%edx
  800296:	89 0a                	mov    %ecx,(%edx)
  800298:	8b 55 08             	mov    0x8(%ebp),%edx
  80029b:	88 d1                	mov    %dl,%cl
  80029d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a7:	8b 00                	mov    (%eax),%eax
  8002a9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ae:	75 2c                	jne    8002dc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002b0:	a0 08 30 80 00       	mov    0x803008,%al
  8002b5:	0f b6 c0             	movzbl %al,%eax
  8002b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bb:	8b 12                	mov    (%edx),%edx
  8002bd:	89 d1                	mov    %edx,%ecx
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	83 c2 08             	add    $0x8,%edx
  8002c5:	83 ec 04             	sub    $0x4,%esp
  8002c8:	50                   	push   %eax
  8002c9:	51                   	push   %ecx
  8002ca:	52                   	push   %edx
  8002cb:	e8 78 0f 00 00       	call   801248 <sys_cputs>
  8002d0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002df:	8b 40 04             	mov    0x4(%eax),%eax
  8002e2:	8d 50 01             	lea    0x1(%eax),%edx
  8002e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002eb:	90                   	nop
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002fe:	00 00 00 
	b.cnt = 0;
  800301:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800308:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80030b:	ff 75 0c             	pushl  0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800317:	50                   	push   %eax
  800318:	68 85 02 80 00       	push   $0x800285
  80031d:	e8 11 02 00 00       	call   800533 <vprintfmt>
  800322:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800325:	a0 08 30 80 00       	mov    0x803008,%al
  80032a:	0f b6 c0             	movzbl %al,%eax
  80032d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	50                   	push   %eax
  800337:	52                   	push   %edx
  800338:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033e:	83 c0 08             	add    $0x8,%eax
  800341:	50                   	push   %eax
  800342:	e8 01 0f 00 00       	call   801248 <sys_cputs>
  800347:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80034a:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800351:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80035f:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800366:	8d 45 0c             	lea    0xc(%ebp),%eax
  800369:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80036c:	8b 45 08             	mov    0x8(%ebp),%eax
  80036f:	83 ec 08             	sub    $0x8,%esp
  800372:	ff 75 f4             	pushl  -0xc(%ebp)
  800375:	50                   	push   %eax
  800376:	e8 73 ff ff ff       	call   8002ee <vcprintf>
  80037b:	83 c4 10             	add    $0x10,%esp
  80037e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800381:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80038c:	e8 f9 0e 00 00       	call   80128a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800391:	8d 45 0c             	lea    0xc(%ebp),%eax
  800394:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	83 ec 08             	sub    $0x8,%esp
  80039d:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a0:	50                   	push   %eax
  8003a1:	e8 48 ff ff ff       	call   8002ee <vcprintf>
  8003a6:	83 c4 10             	add    $0x10,%esp
  8003a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003ac:	e8 f3 0e 00 00       	call   8012a4 <sys_unlock_cons>
	return cnt;
  8003b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	53                   	push   %ebx
  8003ba:	83 ec 14             	sub    $0x14,%esp
  8003bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c9:	8b 45 18             	mov    0x18(%ebp),%eax
  8003cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003d4:	77 55                	ja     80042b <printnum+0x75>
  8003d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003d9:	72 05                	jb     8003e0 <printnum+0x2a>
  8003db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003de:	77 4b                	ja     80042b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003e0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003e3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8003e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ee:	52                   	push   %edx
  8003ef:	50                   	push   %eax
  8003f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8003f6:	e8 39 16 00 00       	call   801a34 <__udivdi3>
  8003fb:	83 c4 10             	add    $0x10,%esp
  8003fe:	83 ec 04             	sub    $0x4,%esp
  800401:	ff 75 20             	pushl  0x20(%ebp)
  800404:	53                   	push   %ebx
  800405:	ff 75 18             	pushl  0x18(%ebp)
  800408:	52                   	push   %edx
  800409:	50                   	push   %eax
  80040a:	ff 75 0c             	pushl  0xc(%ebp)
  80040d:	ff 75 08             	pushl  0x8(%ebp)
  800410:	e8 a1 ff ff ff       	call   8003b6 <printnum>
  800415:	83 c4 20             	add    $0x20,%esp
  800418:	eb 1a                	jmp    800434 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80041a:	83 ec 08             	sub    $0x8,%esp
  80041d:	ff 75 0c             	pushl  0xc(%ebp)
  800420:	ff 75 20             	pushl  0x20(%ebp)
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	ff d0                	call   *%eax
  800428:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042b:	ff 4d 1c             	decl   0x1c(%ebp)
  80042e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800432:	7f e6                	jg     80041a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800434:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800437:	bb 00 00 00 00       	mov    $0x0,%ebx
  80043c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800442:	53                   	push   %ebx
  800443:	51                   	push   %ecx
  800444:	52                   	push   %edx
  800445:	50                   	push   %eax
  800446:	e8 f9 16 00 00       	call   801b44 <__umoddi3>
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	05 b4 1f 80 00       	add    $0x801fb4,%eax
  800453:	8a 00                	mov    (%eax),%al
  800455:	0f be c0             	movsbl %al,%eax
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 0c             	pushl  0xc(%ebp)
  80045e:	50                   	push   %eax
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	ff d0                	call   *%eax
  800464:	83 c4 10             	add    $0x10,%esp
}
  800467:	90                   	nop
  800468:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80046b:	c9                   	leave  
  80046c:	c3                   	ret    

0080046d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800470:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800474:	7e 1c                	jle    800492 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 50 08             	lea    0x8(%eax),%edx
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	89 10                	mov    %edx,(%eax)
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	83 e8 08             	sub    $0x8,%eax
  80048b:	8b 50 04             	mov    0x4(%eax),%edx
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	eb 40                	jmp    8004d2 <getuint+0x65>
	else if (lflag)
  800492:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800496:	74 1e                	je     8004b6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 04             	lea    0x4(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 04             	sub    $0x4,%eax
  8004ad:	8b 00                	mov    (%eax),%eax
  8004af:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b4:	eb 1c                	jmp    8004d2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	8d 50 04             	lea    0x4(%eax),%edx
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	89 10                	mov    %edx,(%eax)
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	83 e8 04             	sub    $0x4,%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004d2:	5d                   	pop    %ebp
  8004d3:	c3                   	ret    

008004d4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004d4:	55                   	push   %ebp
  8004d5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004d7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004db:	7e 1c                	jle    8004f9 <getint+0x25>
		return va_arg(*ap, long long);
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
  8004f7:	eb 38                	jmp    800531 <getint+0x5d>
	else if (lflag)
  8004f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004fd:	74 1a                	je     800519 <getint+0x45>
		return va_arg(*ap, long);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 50 04             	lea    0x4(%eax),%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	83 e8 04             	sub    $0x4,%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	99                   	cltd   
  800517:	eb 18                	jmp    800531 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800519:	8b 45 08             	mov    0x8(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	8d 50 04             	lea    0x4(%eax),%edx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	89 10                	mov    %edx,(%eax)
  800526:	8b 45 08             	mov    0x8(%ebp),%eax
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	83 e8 04             	sub    $0x4,%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	99                   	cltd   
}
  800531:	5d                   	pop    %ebp
  800532:	c3                   	ret    

00800533 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	56                   	push   %esi
  800537:	53                   	push   %ebx
  800538:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80053b:	eb 17                	jmp    800554 <vprintfmt+0x21>
			if (ch == '\0')
  80053d:	85 db                	test   %ebx,%ebx
  80053f:	0f 84 c1 03 00 00    	je     800906 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	ff 75 0c             	pushl  0xc(%ebp)
  80054b:	53                   	push   %ebx
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	ff d0                	call   *%eax
  800551:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800554:	8b 45 10             	mov    0x10(%ebp),%eax
  800557:	8d 50 01             	lea    0x1(%eax),%edx
  80055a:	89 55 10             	mov    %edx,0x10(%ebp)
  80055d:	8a 00                	mov    (%eax),%al
  80055f:	0f b6 d8             	movzbl %al,%ebx
  800562:	83 fb 25             	cmp    $0x25,%ebx
  800565:	75 d6                	jne    80053d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800567:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80056b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800572:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800580:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800587:	8b 45 10             	mov    0x10(%ebp),%eax
  80058a:	8d 50 01             	lea    0x1(%eax),%edx
  80058d:	89 55 10             	mov    %edx,0x10(%ebp)
  800590:	8a 00                	mov    (%eax),%al
  800592:	0f b6 d8             	movzbl %al,%ebx
  800595:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800598:	83 f8 5b             	cmp    $0x5b,%eax
  80059b:	0f 87 3d 03 00 00    	ja     8008de <vprintfmt+0x3ab>
  8005a1:	8b 04 85 d8 1f 80 00 	mov    0x801fd8(,%eax,4),%eax
  8005a8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005aa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005ae:	eb d7                	jmp    800587 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005b0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005b4:	eb d1                	jmp    800587 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c0:	89 d0                	mov    %edx,%eax
  8005c2:	c1 e0 02             	shl    $0x2,%eax
  8005c5:	01 d0                	add    %edx,%eax
  8005c7:	01 c0                	add    %eax,%eax
  8005c9:	01 d8                	add    %ebx,%eax
  8005cb:	83 e8 30             	sub    $0x30,%eax
  8005ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d4:	8a 00                	mov    (%eax),%al
  8005d6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005d9:	83 fb 2f             	cmp    $0x2f,%ebx
  8005dc:	7e 3e                	jle    80061c <vprintfmt+0xe9>
  8005de:	83 fb 39             	cmp    $0x39,%ebx
  8005e1:	7f 39                	jg     80061c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005e3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005e6:	eb d5                	jmp    8005bd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	83 c0 04             	add    $0x4,%eax
  8005ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	83 e8 04             	sub    $0x4,%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005fc:	eb 1f                	jmp    80061d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800602:	79 83                	jns    800587 <vprintfmt+0x54>
				width = 0;
  800604:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80060b:	e9 77 ff ff ff       	jmp    800587 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800610:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800617:	e9 6b ff ff ff       	jmp    800587 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80061c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80061d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800621:	0f 89 60 ff ff ff    	jns    800587 <vprintfmt+0x54>
				width = precision, precision = -1;
  800627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80062d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800634:	e9 4e ff ff ff       	jmp    800587 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800639:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80063c:	e9 46 ff ff ff       	jmp    800587 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	83 c0 04             	add    $0x4,%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	83 e8 04             	sub    $0x4,%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	83 ec 08             	sub    $0x8,%esp
  800655:	ff 75 0c             	pushl  0xc(%ebp)
  800658:	50                   	push   %eax
  800659:	8b 45 08             	mov    0x8(%ebp),%eax
  80065c:	ff d0                	call   *%eax
  80065e:	83 c4 10             	add    $0x10,%esp
			break;
  800661:	e9 9b 02 00 00       	jmp    800901 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	83 c0 04             	add    $0x4,%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	83 e8 04             	sub    $0x4,%eax
  800675:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800677:	85 db                	test   %ebx,%ebx
  800679:	79 02                	jns    80067d <vprintfmt+0x14a>
				err = -err;
  80067b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80067d:	83 fb 64             	cmp    $0x64,%ebx
  800680:	7f 0b                	jg     80068d <vprintfmt+0x15a>
  800682:	8b 34 9d 20 1e 80 00 	mov    0x801e20(,%ebx,4),%esi
  800689:	85 f6                	test   %esi,%esi
  80068b:	75 19                	jne    8006a6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80068d:	53                   	push   %ebx
  80068e:	68 c5 1f 80 00       	push   $0x801fc5
  800693:	ff 75 0c             	pushl  0xc(%ebp)
  800696:	ff 75 08             	pushl  0x8(%ebp)
  800699:	e8 70 02 00 00       	call   80090e <printfmt>
  80069e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006a1:	e9 5b 02 00 00       	jmp    800901 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006a6:	56                   	push   %esi
  8006a7:	68 ce 1f 80 00       	push   $0x801fce
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	ff 75 08             	pushl  0x8(%ebp)
  8006b2:	e8 57 02 00 00       	call   80090e <printfmt>
  8006b7:	83 c4 10             	add    $0x10,%esp
			break;
  8006ba:	e9 42 02 00 00       	jmp    800901 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	83 c0 04             	add    $0x4,%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	83 e8 04             	sub    $0x4,%eax
  8006ce:	8b 30                	mov    (%eax),%esi
  8006d0:	85 f6                	test   %esi,%esi
  8006d2:	75 05                	jne    8006d9 <vprintfmt+0x1a6>
				p = "(null)";
  8006d4:	be d1 1f 80 00       	mov    $0x801fd1,%esi
			if (width > 0 && padc != '-')
  8006d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006dd:	7e 6d                	jle    80074c <vprintfmt+0x219>
  8006df:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006e3:	74 67                	je     80074c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	50                   	push   %eax
  8006ec:	56                   	push   %esi
  8006ed:	e8 1e 03 00 00       	call   800a10 <strnlen>
  8006f2:	83 c4 10             	add    $0x10,%esp
  8006f5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006f8:	eb 16                	jmp    800710 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006fa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	ff 75 0c             	pushl  0xc(%ebp)
  800704:	50                   	push   %eax
  800705:	8b 45 08             	mov    0x8(%ebp),%eax
  800708:	ff d0                	call   *%eax
  80070a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80070d:	ff 4d e4             	decl   -0x1c(%ebp)
  800710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800714:	7f e4                	jg     8006fa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800716:	eb 34                	jmp    80074c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800718:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80071c:	74 1c                	je     80073a <vprintfmt+0x207>
  80071e:	83 fb 1f             	cmp    $0x1f,%ebx
  800721:	7e 05                	jle    800728 <vprintfmt+0x1f5>
  800723:	83 fb 7e             	cmp    $0x7e,%ebx
  800726:	7e 12                	jle    80073a <vprintfmt+0x207>
					putch('?', putdat);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 0c             	pushl  0xc(%ebp)
  80072e:	6a 3f                	push   $0x3f
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
  800738:	eb 0f                	jmp    800749 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	ff 75 0c             	pushl  0xc(%ebp)
  800740:	53                   	push   %ebx
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	ff d0                	call   *%eax
  800746:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800749:	ff 4d e4             	decl   -0x1c(%ebp)
  80074c:	89 f0                	mov    %esi,%eax
  80074e:	8d 70 01             	lea    0x1(%eax),%esi
  800751:	8a 00                	mov    (%eax),%al
  800753:	0f be d8             	movsbl %al,%ebx
  800756:	85 db                	test   %ebx,%ebx
  800758:	74 24                	je     80077e <vprintfmt+0x24b>
  80075a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80075e:	78 b8                	js     800718 <vprintfmt+0x1e5>
  800760:	ff 4d e0             	decl   -0x20(%ebp)
  800763:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800767:	79 af                	jns    800718 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800769:	eb 13                	jmp    80077e <vprintfmt+0x24b>
				putch(' ', putdat);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	ff 75 0c             	pushl  0xc(%ebp)
  800771:	6a 20                	push   $0x20
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	ff d0                	call   *%eax
  800778:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80077b:	ff 4d e4             	decl   -0x1c(%ebp)
  80077e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800782:	7f e7                	jg     80076b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800784:	e9 78 01 00 00       	jmp    800901 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 e8             	pushl  -0x18(%ebp)
  80078f:	8d 45 14             	lea    0x14(%ebp),%eax
  800792:	50                   	push   %eax
  800793:	e8 3c fd ff ff       	call   8004d4 <getint>
  800798:	83 c4 10             	add    $0x10,%esp
  80079b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a7:	85 d2                	test   %edx,%edx
  8007a9:	79 23                	jns    8007ce <vprintfmt+0x29b>
				putch('-', putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	6a 2d                	push   $0x2d
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	ff d0                	call   *%eax
  8007b8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c1:	f7 d8                	neg    %eax
  8007c3:	83 d2 00             	adc    $0x0,%edx
  8007c6:	f7 da                	neg    %edx
  8007c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007ce:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007d5:	e9 bc 00 00 00       	jmp    800896 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8007e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e3:	50                   	push   %eax
  8007e4:	e8 84 fc ff ff       	call   80046d <getuint>
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007f2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f9:	e9 98 00 00 00       	jmp    800896 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	6a 58                	push   $0x58
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	6a 58                	push   $0x58
  800816:	8b 45 08             	mov    0x8(%ebp),%eax
  800819:	ff d0                	call   *%eax
  80081b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	6a 58                	push   $0x58
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	ff d0                	call   *%eax
  80082b:	83 c4 10             	add    $0x10,%esp
			break;
  80082e:	e9 ce 00 00 00       	jmp    800901 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	ff 75 0c             	pushl  0xc(%ebp)
  800839:	6a 30                	push   $0x30
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	ff d0                	call   *%eax
  800840:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	6a 78                	push   $0x78
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	ff d0                	call   *%eax
  800850:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800853:	8b 45 14             	mov    0x14(%ebp),%eax
  800856:	83 c0 04             	add    $0x4,%eax
  800859:	89 45 14             	mov    %eax,0x14(%ebp)
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	83 e8 04             	sub    $0x4,%eax
  800862:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800864:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800867:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80086e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800875:	eb 1f                	jmp    800896 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800877:	83 ec 08             	sub    $0x8,%esp
  80087a:	ff 75 e8             	pushl  -0x18(%ebp)
  80087d:	8d 45 14             	lea    0x14(%ebp),%eax
  800880:	50                   	push   %eax
  800881:	e8 e7 fb ff ff       	call   80046d <getuint>
  800886:	83 c4 10             	add    $0x10,%esp
  800889:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80088f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800896:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80089a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80089d:	83 ec 04             	sub    $0x4,%esp
  8008a0:	52                   	push   %edx
  8008a1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008a4:	50                   	push   %eax
  8008a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	e8 00 fb ff ff       	call   8003b6 <printnum>
  8008b6:	83 c4 20             	add    $0x20,%esp
			break;
  8008b9:	eb 46                	jmp    800901 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	53                   	push   %ebx
  8008c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c5:	ff d0                	call   *%eax
  8008c7:	83 c4 10             	add    $0x10,%esp
			break;
  8008ca:	eb 35                	jmp    800901 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008cc:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8008d3:	eb 2c                	jmp    800901 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008d5:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8008dc:	eb 23                	jmp    800901 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	6a 25                	push   $0x25
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	ff d0                	call   *%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ee:	ff 4d 10             	decl   0x10(%ebp)
  8008f1:	eb 03                	jmp    8008f6 <vprintfmt+0x3c3>
  8008f3:	ff 4d 10             	decl   0x10(%ebp)
  8008f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f9:	48                   	dec    %eax
  8008fa:	8a 00                	mov    (%eax),%al
  8008fc:	3c 25                	cmp    $0x25,%al
  8008fe:	75 f3                	jne    8008f3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800900:	90                   	nop
		}
	}
  800901:	e9 35 fc ff ff       	jmp    80053b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800906:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800907:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80090a:	5b                   	pop    %ebx
  80090b:	5e                   	pop    %esi
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800914:	8d 45 10             	lea    0x10(%ebp),%eax
  800917:	83 c0 04             	add    $0x4,%eax
  80091a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80091d:	8b 45 10             	mov    0x10(%ebp),%eax
  800920:	ff 75 f4             	pushl  -0xc(%ebp)
  800923:	50                   	push   %eax
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	ff 75 08             	pushl  0x8(%ebp)
  80092a:	e8 04 fc ff ff       	call   800533 <vprintfmt>
  80092f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800932:	90                   	nop
  800933:	c9                   	leave  
  800934:	c3                   	ret    

00800935 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093b:	8b 40 08             	mov    0x8(%eax),%eax
  80093e:	8d 50 01             	lea    0x1(%eax),%edx
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094a:	8b 10                	mov    (%eax),%edx
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	8b 40 04             	mov    0x4(%eax),%eax
  800952:	39 c2                	cmp    %eax,%edx
  800954:	73 12                	jae    800968 <sprintputch+0x33>
		*b->buf++ = ch;
  800956:	8b 45 0c             	mov    0xc(%ebp),%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	8d 48 01             	lea    0x1(%eax),%ecx
  80095e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800961:	89 0a                	mov    %ecx,(%edx)
  800963:	8b 55 08             	mov    0x8(%ebp),%edx
  800966:	88 10                	mov    %dl,(%eax)
}
  800968:	90                   	nop
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	01 d0                	add    %edx,%eax
  800982:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800985:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80098c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800990:	74 06                	je     800998 <vsnprintf+0x2d>
  800992:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800996:	7f 07                	jg     80099f <vsnprintf+0x34>
		return -E_INVAL;
  800998:	b8 03 00 00 00       	mov    $0x3,%eax
  80099d:	eb 20                	jmp    8009bf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80099f:	ff 75 14             	pushl  0x14(%ebp)
  8009a2:	ff 75 10             	pushl  0x10(%ebp)
  8009a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a8:	50                   	push   %eax
  8009a9:	68 35 09 80 00       	push   $0x800935
  8009ae:	e8 80 fb ff ff       	call   800533 <vprintfmt>
  8009b3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009bf:	c9                   	leave  
  8009c0:	c3                   	ret    

008009c1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c7:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ca:	83 c0 04             	add    $0x4,%eax
  8009cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d6:	50                   	push   %eax
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	ff 75 08             	pushl  0x8(%ebp)
  8009dd:	e8 89 ff ff ff       	call   80096b <vsnprintf>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009fa:	eb 06                	jmp    800a02 <strlen+0x15>
		n++;
  8009fc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ff:	ff 45 08             	incl   0x8(%ebp)
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	84 c0                	test   %al,%al
  800a09:	75 f1                	jne    8009fc <strlen+0xf>
		n++;
	return n;
  800a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a0e:	c9                   	leave  
  800a0f:	c3                   	ret    

00800a10 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a1d:	eb 09                	jmp    800a28 <strnlen+0x18>
		n++;
  800a1f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a22:	ff 45 08             	incl   0x8(%ebp)
  800a25:	ff 4d 0c             	decl   0xc(%ebp)
  800a28:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a2c:	74 09                	je     800a37 <strnlen+0x27>
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8a 00                	mov    (%eax),%al
  800a33:	84 c0                	test   %al,%al
  800a35:	75 e8                	jne    800a1f <strnlen+0xf>
		n++;
	return n;
  800a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a48:	90                   	nop
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	8d 50 01             	lea    0x1(%eax),%edx
  800a4f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a55:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a58:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a5b:	8a 12                	mov    (%edx),%dl
  800a5d:	88 10                	mov    %dl,(%eax)
  800a5f:	8a 00                	mov    (%eax),%al
  800a61:	84 c0                	test   %al,%al
  800a63:	75 e4                	jne    800a49 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a7d:	eb 1f                	jmp    800a9e <strncpy+0x34>
		*dst++ = *src;
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	8d 50 01             	lea    0x1(%eax),%edx
  800a85:	89 55 08             	mov    %edx,0x8(%ebp)
  800a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8b:	8a 12                	mov    (%edx),%dl
  800a8d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a92:	8a 00                	mov    (%eax),%al
  800a94:	84 c0                	test   %al,%al
  800a96:	74 03                	je     800a9b <strncpy+0x31>
			src++;
  800a98:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a9b:	ff 45 fc             	incl   -0x4(%ebp)
  800a9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aa1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800aa4:	72 d9                	jb     800a7f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800aa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ab7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800abb:	74 30                	je     800aed <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800abd:	eb 16                	jmp    800ad5 <strlcpy+0x2a>
			*dst++ = *src++;
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8d 50 01             	lea    0x1(%eax),%edx
  800ac5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ace:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ad1:	8a 12                	mov    (%edx),%dl
  800ad3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ad5:	ff 4d 10             	decl   0x10(%ebp)
  800ad8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800adc:	74 09                	je     800ae7 <strlcpy+0x3c>
  800ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae1:	8a 00                	mov    (%eax),%al
  800ae3:	84 c0                	test   %al,%al
  800ae5:	75 d8                	jne    800abf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aed:	8b 55 08             	mov    0x8(%ebp),%edx
  800af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
}
  800af7:	c9                   	leave  
  800af8:	c3                   	ret    

00800af9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800afc:	eb 06                	jmp    800b04 <strcmp+0xb>
		p++, q++;
  800afe:	ff 45 08             	incl   0x8(%ebp)
  800b01:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	84 c0                	test   %al,%al
  800b0b:	74 0e                	je     800b1b <strcmp+0x22>
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8a 10                	mov    (%eax),%dl
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8a 00                	mov    (%eax),%al
  800b17:	38 c2                	cmp    %al,%dl
  800b19:	74 e3                	je     800afe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	8a 00                	mov    (%eax),%al
  800b20:	0f b6 d0             	movzbl %al,%edx
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	0f b6 c0             	movzbl %al,%eax
  800b2b:	29 c2                	sub    %eax,%edx
  800b2d:	89 d0                	mov    %edx,%eax
}
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b34:	eb 09                	jmp    800b3f <strncmp+0xe>
		n--, p++, q++;
  800b36:	ff 4d 10             	decl   0x10(%ebp)
  800b39:	ff 45 08             	incl   0x8(%ebp)
  800b3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b43:	74 17                	je     800b5c <strncmp+0x2b>
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	8a 00                	mov    (%eax),%al
  800b4a:	84 c0                	test   %al,%al
  800b4c:	74 0e                	je     800b5c <strncmp+0x2b>
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	8a 10                	mov    (%eax),%dl
  800b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b56:	8a 00                	mov    (%eax),%al
  800b58:	38 c2                	cmp    %al,%dl
  800b5a:	74 da                	je     800b36 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b60:	75 07                	jne    800b69 <strncmp+0x38>
		return 0;
  800b62:	b8 00 00 00 00       	mov    $0x0,%eax
  800b67:	eb 14                	jmp    800b7d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8a 00                	mov    (%eax),%al
  800b6e:	0f b6 d0             	movzbl %al,%edx
  800b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b74:	8a 00                	mov    (%eax),%al
  800b76:	0f b6 c0             	movzbl %al,%eax
  800b79:	29 c2                	sub    %eax,%edx
  800b7b:	89 d0                	mov    %edx,%eax
}
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 04             	sub    $0x4,%esp
  800b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b88:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b8b:	eb 12                	jmp    800b9f <strchr+0x20>
		if (*s == c)
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8a 00                	mov    (%eax),%al
  800b92:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b95:	75 05                	jne    800b9c <strchr+0x1d>
			return (char *) s;
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	eb 11                	jmp    800bad <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b9c:	ff 45 08             	incl   0x8(%ebp)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8a 00                	mov    (%eax),%al
  800ba4:	84 c0                	test   %al,%al
  800ba6:	75 e5                	jne    800b8d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ba8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    

00800baf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	83 ec 04             	sub    $0x4,%esp
  800bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bbb:	eb 0d                	jmp    800bca <strfind+0x1b>
		if (*s == c)
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	8a 00                	mov    (%eax),%al
  800bc2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bc5:	74 0e                	je     800bd5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bc7:	ff 45 08             	incl   0x8(%ebp)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	84 c0                	test   %al,%al
  800bd1:	75 ea                	jne    800bbd <strfind+0xe>
  800bd3:	eb 01                	jmp    800bd6 <strfind+0x27>
		if (*s == c)
			break;
  800bd5:	90                   	nop
	return (char *) s;
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bed:	eb 0e                	jmp    800bfd <memset+0x22>
		*p++ = c;
  800bef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf2:	8d 50 01             	lea    0x1(%eax),%edx
  800bf5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bfb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bfd:	ff 4d f8             	decl   -0x8(%ebp)
  800c00:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c04:	79 e9                	jns    800bef <memset+0x14>
		*p++ = c;

	return v;
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c1d:	eb 16                	jmp    800c35 <memcpy+0x2a>
		*d++ = *s++;
  800c1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c22:	8d 50 01             	lea    0x1(%eax),%edx
  800c25:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c2b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c2e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c31:	8a 12                	mov    (%edx),%dl
  800c33:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c35:	8b 45 10             	mov    0x10(%ebp),%eax
  800c38:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c3b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c3e:	85 c0                	test   %eax,%eax
  800c40:	75 dd                	jne    800c1f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c45:	c9                   	leave  
  800c46:	c3                   	ret    

00800c47 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c5f:	73 50                	jae    800cb1 <memmove+0x6a>
  800c61:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c64:	8b 45 10             	mov    0x10(%ebp),%eax
  800c67:	01 d0                	add    %edx,%eax
  800c69:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c6c:	76 43                	jbe    800cb1 <memmove+0x6a>
		s += n;
  800c6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c71:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c7a:	eb 10                	jmp    800c8c <memmove+0x45>
			*--d = *--s;
  800c7c:	ff 4d f8             	decl   -0x8(%ebp)
  800c7f:	ff 4d fc             	decl   -0x4(%ebp)
  800c82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c85:	8a 10                	mov    (%eax),%dl
  800c87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c8a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c92:	89 55 10             	mov    %edx,0x10(%ebp)
  800c95:	85 c0                	test   %eax,%eax
  800c97:	75 e3                	jne    800c7c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c99:	eb 23                	jmp    800cbe <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9e:	8d 50 01             	lea    0x1(%eax),%edx
  800ca1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ca4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ca7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800caa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cad:	8a 12                	mov    (%edx),%dl
  800caf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cba:	85 c0                	test   %eax,%eax
  800cbc:	75 dd                	jne    800c9b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cd5:	eb 2a                	jmp    800d01 <memcmp+0x3e>
		if (*s1 != *s2)
  800cd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cda:	8a 10                	mov    (%eax),%dl
  800cdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	38 c2                	cmp    %al,%dl
  800ce3:	74 16                	je     800cfb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ce5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	0f b6 d0             	movzbl %al,%edx
  800ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	0f b6 c0             	movzbl %al,%eax
  800cf5:	29 c2                	sub    %eax,%edx
  800cf7:	89 d0                	mov    %edx,%eax
  800cf9:	eb 18                	jmp    800d13 <memcmp+0x50>
		s1++, s2++;
  800cfb:	ff 45 fc             	incl   -0x4(%ebp)
  800cfe:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d01:	8b 45 10             	mov    0x10(%ebp),%eax
  800d04:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d07:	89 55 10             	mov    %edx,0x10(%ebp)
  800d0a:	85 c0                	test   %eax,%eax
  800d0c:	75 c9                	jne    800cd7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d21:	01 d0                	add    %edx,%eax
  800d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d26:	eb 15                	jmp    800d3d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	0f b6 d0             	movzbl %al,%edx
  800d30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d33:	0f b6 c0             	movzbl %al,%eax
  800d36:	39 c2                	cmp    %eax,%edx
  800d38:	74 0d                	je     800d47 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d3a:	ff 45 08             	incl   0x8(%ebp)
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d43:	72 e3                	jb     800d28 <memfind+0x13>
  800d45:	eb 01                	jmp    800d48 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d47:	90                   	nop
	return (void *) s;
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d5a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d61:	eb 03                	jmp    800d66 <strtol+0x19>
		s++;
  800d63:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3c 20                	cmp    $0x20,%al
  800d6d:	74 f4                	je     800d63 <strtol+0x16>
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	3c 09                	cmp    $0x9,%al
  800d76:	74 eb                	je     800d63 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	3c 2b                	cmp    $0x2b,%al
  800d7f:	75 05                	jne    800d86 <strtol+0x39>
		s++;
  800d81:	ff 45 08             	incl   0x8(%ebp)
  800d84:	eb 13                	jmp    800d99 <strtol+0x4c>
	else if (*s == '-')
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	3c 2d                	cmp    $0x2d,%al
  800d8d:	75 0a                	jne    800d99 <strtol+0x4c>
		s++, neg = 1;
  800d8f:	ff 45 08             	incl   0x8(%ebp)
  800d92:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9d:	74 06                	je     800da5 <strtol+0x58>
  800d9f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800da3:	75 20                	jne    800dc5 <strtol+0x78>
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	3c 30                	cmp    $0x30,%al
  800dac:	75 17                	jne    800dc5 <strtol+0x78>
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	40                   	inc    %eax
  800db2:	8a 00                	mov    (%eax),%al
  800db4:	3c 78                	cmp    $0x78,%al
  800db6:	75 0d                	jne    800dc5 <strtol+0x78>
		s += 2, base = 16;
  800db8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dbc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dc3:	eb 28                	jmp    800ded <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dc5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc9:	75 15                	jne    800de0 <strtol+0x93>
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	3c 30                	cmp    $0x30,%al
  800dd2:	75 0c                	jne    800de0 <strtol+0x93>
		s++, base = 8;
  800dd4:	ff 45 08             	incl   0x8(%ebp)
  800dd7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dde:	eb 0d                	jmp    800ded <strtol+0xa0>
	else if (base == 0)
  800de0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de4:	75 07                	jne    800ded <strtol+0xa0>
		base = 10;
  800de6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	3c 2f                	cmp    $0x2f,%al
  800df4:	7e 19                	jle    800e0f <strtol+0xc2>
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	3c 39                	cmp    $0x39,%al
  800dfd:	7f 10                	jg     800e0f <strtol+0xc2>
			dig = *s - '0';
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	8a 00                	mov    (%eax),%al
  800e04:	0f be c0             	movsbl %al,%eax
  800e07:	83 e8 30             	sub    $0x30,%eax
  800e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e0d:	eb 42                	jmp    800e51 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	3c 60                	cmp    $0x60,%al
  800e16:	7e 19                	jle    800e31 <strtol+0xe4>
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	8a 00                	mov    (%eax),%al
  800e1d:	3c 7a                	cmp    $0x7a,%al
  800e1f:	7f 10                	jg     800e31 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	0f be c0             	movsbl %al,%eax
  800e29:	83 e8 57             	sub    $0x57,%eax
  800e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e2f:	eb 20                	jmp    800e51 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	3c 40                	cmp    $0x40,%al
  800e38:	7e 39                	jle    800e73 <strtol+0x126>
  800e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	3c 5a                	cmp    $0x5a,%al
  800e41:	7f 30                	jg     800e73 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	0f be c0             	movsbl %al,%eax
  800e4b:	83 e8 37             	sub    $0x37,%eax
  800e4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e54:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e57:	7d 19                	jge    800e72 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e59:	ff 45 08             	incl   0x8(%ebp)
  800e5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e63:	89 c2                	mov    %eax,%edx
  800e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e68:	01 d0                	add    %edx,%eax
  800e6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e6d:	e9 7b ff ff ff       	jmp    800ded <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e72:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e77:	74 08                	je     800e81 <strtol+0x134>
		*endptr = (char *) s;
  800e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e81:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e85:	74 07                	je     800e8e <strtol+0x141>
  800e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8a:	f7 d8                	neg    %eax
  800e8c:	eb 03                	jmp    800e91 <strtol+0x144>
  800e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e91:	c9                   	leave  
  800e92:	c3                   	ret    

00800e93 <ltostr>:

void
ltostr(long value, char *str)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e99:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800ea0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ea7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eab:	79 13                	jns    800ec0 <ltostr+0x2d>
	{
		neg = 1;
  800ead:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eba:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ebd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ec8:	99                   	cltd   
  800ec9:	f7 f9                	idiv   %ecx
  800ecb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ece:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed1:	8d 50 01             	lea    0x1(%eax),%edx
  800ed4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed7:	89 c2                	mov    %eax,%edx
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	01 d0                	add    %edx,%eax
  800ede:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ee1:	83 c2 30             	add    $0x30,%edx
  800ee4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ee6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eee:	f7 e9                	imul   %ecx
  800ef0:	c1 fa 02             	sar    $0x2,%edx
  800ef3:	89 c8                	mov    %ecx,%eax
  800ef5:	c1 f8 1f             	sar    $0x1f,%eax
  800ef8:	29 c2                	sub    %eax,%edx
  800efa:	89 d0                	mov    %edx,%eax
  800efc:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800eff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f03:	75 bb                	jne    800ec0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0f:	48                   	dec    %eax
  800f10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f13:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f17:	74 3d                	je     800f56 <ltostr+0xc3>
		start = 1 ;
  800f19:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f20:	eb 34                	jmp    800f56 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f35:	01 c2                	add    %eax,%edx
  800f37:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	01 c8                	add    %ecx,%eax
  800f3f:	8a 00                	mov    (%eax),%al
  800f41:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	01 c2                	add    %eax,%edx
  800f4b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f4e:	88 02                	mov    %al,(%edx)
		start++ ;
  800f50:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f53:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f59:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f5c:	7c c4                	jl     800f22 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f5e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	01 d0                	add    %edx,%eax
  800f66:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f69:	90                   	nop
  800f6a:	c9                   	leave  
  800f6b:	c3                   	ret    

00800f6c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f72:	ff 75 08             	pushl  0x8(%ebp)
  800f75:	e8 73 fa ff ff       	call   8009ed <strlen>
  800f7a:	83 c4 04             	add    $0x4,%esp
  800f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f80:	ff 75 0c             	pushl  0xc(%ebp)
  800f83:	e8 65 fa ff ff       	call   8009ed <strlen>
  800f88:	83 c4 04             	add    $0x4,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f9c:	eb 17                	jmp    800fb5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 c2                	add    %eax,%edx
  800fa6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	01 c8                	add    %ecx,%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fb2:	ff 45 fc             	incl   -0x4(%ebp)
  800fb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fbb:	7c e1                	jl     800f9e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fbd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fc4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fcb:	eb 1f                	jmp    800fec <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd0:	8d 50 01             	lea    0x1(%eax),%edx
  800fd3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd6:	89 c2                	mov    %eax,%edx
  800fd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdb:	01 c2                	add    %eax,%edx
  800fdd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe3:	01 c8                	add    %ecx,%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fe9:	ff 45 f8             	incl   -0x8(%ebp)
  800fec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ff2:	7c d9                	jl     800fcd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ff4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	01 d0                	add    %edx,%eax
  800ffc:	c6 00 00             	movb   $0x0,(%eax)
}
  800fff:	90                   	nop
  801000:	c9                   	leave  
  801001:	c3                   	ret    

00801002 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801005:	8b 45 14             	mov    0x14(%ebp),%eax
  801008:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80100e:	8b 45 14             	mov    0x14(%ebp),%eax
  801011:	8b 00                	mov    (%eax),%eax
  801013:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80101a:	8b 45 10             	mov    0x10(%ebp),%eax
  80101d:	01 d0                	add    %edx,%eax
  80101f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801025:	eb 0c                	jmp    801033 <strsplit+0x31>
			*string++ = 0;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8d 50 01             	lea    0x1(%eax),%edx
  80102d:	89 55 08             	mov    %edx,0x8(%ebp)
  801030:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	84 c0                	test   %al,%al
  80103a:	74 18                	je     801054 <strsplit+0x52>
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	0f be c0             	movsbl %al,%eax
  801044:	50                   	push   %eax
  801045:	ff 75 0c             	pushl  0xc(%ebp)
  801048:	e8 32 fb ff ff       	call   800b7f <strchr>
  80104d:	83 c4 08             	add    $0x8,%esp
  801050:	85 c0                	test   %eax,%eax
  801052:	75 d3                	jne    801027 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	84 c0                	test   %al,%al
  80105b:	74 5a                	je     8010b7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80105d:	8b 45 14             	mov    0x14(%ebp),%eax
  801060:	8b 00                	mov    (%eax),%eax
  801062:	83 f8 0f             	cmp    $0xf,%eax
  801065:	75 07                	jne    80106e <strsplit+0x6c>
		{
			return 0;
  801067:	b8 00 00 00 00       	mov    $0x0,%eax
  80106c:	eb 66                	jmp    8010d4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80106e:	8b 45 14             	mov    0x14(%ebp),%eax
  801071:	8b 00                	mov    (%eax),%eax
  801073:	8d 48 01             	lea    0x1(%eax),%ecx
  801076:	8b 55 14             	mov    0x14(%ebp),%edx
  801079:	89 0a                	mov    %ecx,(%edx)
  80107b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801082:	8b 45 10             	mov    0x10(%ebp),%eax
  801085:	01 c2                	add    %eax,%edx
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80108c:	eb 03                	jmp    801091 <strsplit+0x8f>
			string++;
  80108e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	84 c0                	test   %al,%al
  801098:	74 8b                	je     801025 <strsplit+0x23>
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	0f be c0             	movsbl %al,%eax
  8010a2:	50                   	push   %eax
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	e8 d4 fa ff ff       	call   800b7f <strchr>
  8010ab:	83 c4 08             	add    $0x8,%esp
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	74 dc                	je     80108e <strsplit+0x8c>
			string++;
	}
  8010b2:	e9 6e ff ff ff       	jmp    801025 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010b7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c7:	01 d0                	add    %edx,%eax
  8010c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010cf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010d4:	c9                   	leave  
  8010d5:	c3                   	ret    

008010d6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8010dc:	83 ec 04             	sub    $0x4,%esp
  8010df:	68 48 21 80 00       	push   $0x802148
  8010e4:	68 3f 01 00 00       	push   $0x13f
  8010e9:	68 6a 21 80 00       	push   $0x80216a
  8010ee:	e8 57 07 00 00       	call   80184a <_panic>

008010f3 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8010f9:	83 ec 0c             	sub    $0xc,%esp
  8010fc:	ff 75 08             	pushl  0x8(%ebp)
  8010ff:	e8 ef 06 00 00       	call   8017f3 <sys_sbrk>
  801104:	83 c4 10             	add    $0x10,%esp
}
  801107:	c9                   	leave  
  801108:	c3                   	ret    

00801109 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80110f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801113:	75 07                	jne    80111c <malloc+0x13>
  801115:	b8 00 00 00 00       	mov    $0x0,%eax
  80111a:	eb 14                	jmp    801130 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80111c:	83 ec 04             	sub    $0x4,%esp
  80111f:	68 78 21 80 00       	push   $0x802178
  801124:	6a 1b                	push   $0x1b
  801126:	68 9d 21 80 00       	push   $0x80219d
  80112b:	e8 1a 07 00 00       	call   80184a <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801138:	83 ec 04             	sub    $0x4,%esp
  80113b:	68 ac 21 80 00       	push   $0x8021ac
  801140:	6a 29                	push   $0x29
  801142:	68 9d 21 80 00       	push   $0x80219d
  801147:	e8 fe 06 00 00       	call   80184a <_panic>

0080114c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 18             	sub    $0x18,%esp
  801152:	8b 45 10             	mov    0x10(%ebp),%eax
  801155:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801158:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80115c:	75 07                	jne    801165 <smalloc+0x19>
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	eb 14                	jmp    801179 <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801165:	83 ec 04             	sub    $0x4,%esp
  801168:	68 d0 21 80 00       	push   $0x8021d0
  80116d:	6a 38                	push   $0x38
  80116f:	68 9d 21 80 00       	push   $0x80219d
  801174:	e8 d1 06 00 00       	call   80184a <_panic>
	return NULL;
}
  801179:	c9                   	leave  
  80117a:	c3                   	ret    

0080117b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801181:	83 ec 04             	sub    $0x4,%esp
  801184:	68 f8 21 80 00       	push   $0x8021f8
  801189:	6a 43                	push   $0x43
  80118b:	68 9d 21 80 00       	push   $0x80219d
  801190:	e8 b5 06 00 00       	call   80184a <_panic>

00801195 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80119b:	83 ec 04             	sub    $0x4,%esp
  80119e:	68 1c 22 80 00       	push   $0x80221c
  8011a3:	6a 5b                	push   $0x5b
  8011a5:	68 9d 21 80 00       	push   $0x80219d
  8011aa:	e8 9b 06 00 00       	call   80184a <_panic>

008011af <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8011b5:	83 ec 04             	sub    $0x4,%esp
  8011b8:	68 40 22 80 00       	push   $0x802240
  8011bd:	6a 72                	push   $0x72
  8011bf:	68 9d 21 80 00       	push   $0x80219d
  8011c4:	e8 81 06 00 00       	call   80184a <_panic>

008011c9 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8011cf:	83 ec 04             	sub    $0x4,%esp
  8011d2:	68 66 22 80 00       	push   $0x802266
  8011d7:	6a 7e                	push   $0x7e
  8011d9:	68 9d 21 80 00       	push   $0x80219d
  8011de:	e8 67 06 00 00       	call   80184a <_panic>

008011e3 <shrink>:

}
void shrink(uint32 newSize)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
  8011e6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	68 66 22 80 00       	push   $0x802266
  8011f1:	68 83 00 00 00       	push   $0x83
  8011f6:	68 9d 21 80 00       	push   $0x80219d
  8011fb:	e8 4a 06 00 00       	call   80184a <_panic>

00801200 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801206:	83 ec 04             	sub    $0x4,%esp
  801209:	68 66 22 80 00       	push   $0x802266
  80120e:	68 88 00 00 00       	push   $0x88
  801213:	68 9d 21 80 00       	push   $0x80219d
  801218:	e8 2d 06 00 00       	call   80184a <_panic>

0080121d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	57                   	push   %edi
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
  801223:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80122f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801232:	8b 7d 18             	mov    0x18(%ebp),%edi
  801235:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801238:	cd 30                	int    $0x30
  80123a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801240:	83 c4 10             	add    $0x10,%esp
  801243:	5b                   	pop    %ebx
  801244:	5e                   	pop    %esi
  801245:	5f                   	pop    %edi
  801246:	5d                   	pop    %ebp
  801247:	c3                   	ret    

00801248 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	83 ec 04             	sub    $0x4,%esp
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801254:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	52                   	push   %edx
  801260:	ff 75 0c             	pushl  0xc(%ebp)
  801263:	50                   	push   %eax
  801264:	6a 00                	push   $0x0
  801266:	e8 b2 ff ff ff       	call   80121d <syscall>
  80126b:	83 c4 18             	add    $0x18,%esp
}
  80126e:	90                   	nop
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <sys_cgetc>:

int
sys_cgetc(void)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801274:	6a 00                	push   $0x0
  801276:	6a 00                	push   $0x0
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	6a 00                	push   $0x0
  80127e:	6a 02                	push   $0x2
  801280:	e8 98 ff ff ff       	call   80121d <syscall>
  801285:	83 c4 18             	add    $0x18,%esp
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	6a 03                	push   $0x3
  801299:	e8 7f ff ff ff       	call   80121d <syscall>
  80129e:	83 c4 18             	add    $0x18,%esp
}
  8012a1:	90                   	nop
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 04                	push   $0x4
  8012b3:	e8 65 ff ff ff       	call   80121d <syscall>
  8012b8:	83 c4 18             	add    $0x18,%esp
}
  8012bb:	90                   	nop
  8012bc:	c9                   	leave  
  8012bd:	c3                   	ret    

008012be <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	6a 00                	push   $0x0
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	52                   	push   %edx
  8012ce:	50                   	push   %eax
  8012cf:	6a 08                	push   $0x8
  8012d1:	e8 47 ff ff ff       	call   80121d <syscall>
  8012d6:	83 c4 18             	add    $0x18,%esp
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	56                   	push   %esi
  8012df:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012e0:	8b 75 18             	mov    0x18(%ebp),%esi
  8012e3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	56                   	push   %esi
  8012f0:	53                   	push   %ebx
  8012f1:	51                   	push   %ecx
  8012f2:	52                   	push   %edx
  8012f3:	50                   	push   %eax
  8012f4:	6a 09                	push   $0x9
  8012f6:	e8 22 ff ff ff       	call   80121d <syscall>
  8012fb:	83 c4 18             	add    $0x18,%esp
}
  8012fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801301:	5b                   	pop    %ebx
  801302:	5e                   	pop    %esi
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    

00801305 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801308:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	52                   	push   %edx
  801315:	50                   	push   %eax
  801316:	6a 0a                	push   $0xa
  801318:	e8 00 ff ff ff       	call   80121d <syscall>
  80131d:	83 c4 18             	add    $0x18,%esp
}
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	ff 75 08             	pushl  0x8(%ebp)
  801331:	6a 0b                	push   $0xb
  801333:	e8 e5 fe ff ff       	call   80121d <syscall>
  801338:	83 c4 18             	add    $0x18,%esp
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 0c                	push   $0xc
  80134c:	e8 cc fe ff ff       	call   80121d <syscall>
  801351:	83 c4 18             	add    $0x18,%esp
}
  801354:	c9                   	leave  
  801355:	c3                   	ret    

00801356 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 0d                	push   $0xd
  801365:	e8 b3 fe ff ff       	call   80121d <syscall>
  80136a:	83 c4 18             	add    $0x18,%esp
}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 0e                	push   $0xe
  80137e:	e8 9a fe ff ff       	call   80121d <syscall>
  801383:	83 c4 18             	add    $0x18,%esp
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 0f                	push   $0xf
  801397:	e8 81 fe ff ff       	call   80121d <syscall>
  80139c:	83 c4 18             	add    $0x18,%esp
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	ff 75 08             	pushl  0x8(%ebp)
  8013af:	6a 10                	push   $0x10
  8013b1:	e8 67 fe ff ff       	call   80121d <syscall>
  8013b6:	83 c4 18             	add    $0x18,%esp
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 11                	push   $0x11
  8013ca:	e8 4e fe ff ff       	call   80121d <syscall>
  8013cf:	83 c4 18             	add    $0x18,%esp
}
  8013d2:	90                   	nop
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	83 ec 04             	sub    $0x4,%esp
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013e1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	50                   	push   %eax
  8013ee:	6a 01                	push   $0x1
  8013f0:	e8 28 fe ff ff       	call   80121d <syscall>
  8013f5:	83 c4 18             	add    $0x18,%esp
}
  8013f8:	90                   	nop
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 14                	push   $0x14
  80140a:	e8 0e fe ff ff       	call   80121d <syscall>
  80140f:	83 c4 18             	add    $0x18,%esp
}
  801412:	90                   	nop
  801413:	c9                   	leave  
  801414:	c3                   	ret    

00801415 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	83 ec 04             	sub    $0x4,%esp
  80141b:	8b 45 10             	mov    0x10(%ebp),%eax
  80141e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801421:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801424:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	6a 00                	push   $0x0
  80142d:	51                   	push   %ecx
  80142e:	52                   	push   %edx
  80142f:	ff 75 0c             	pushl  0xc(%ebp)
  801432:	50                   	push   %eax
  801433:	6a 15                	push   $0x15
  801435:	e8 e3 fd ff ff       	call   80121d <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801442:	8b 55 0c             	mov    0xc(%ebp),%edx
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	52                   	push   %edx
  80144f:	50                   	push   %eax
  801450:	6a 16                	push   $0x16
  801452:	e8 c6 fd ff ff       	call   80121d <syscall>
  801457:	83 c4 18             	add    $0x18,%esp
}
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80145f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801462:	8b 55 0c             	mov    0xc(%ebp),%edx
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	51                   	push   %ecx
  80146d:	52                   	push   %edx
  80146e:	50                   	push   %eax
  80146f:	6a 17                	push   $0x17
  801471:	e8 a7 fd ff ff       	call   80121d <syscall>
  801476:	83 c4 18             	add    $0x18,%esp
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80147e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	52                   	push   %edx
  80148b:	50                   	push   %eax
  80148c:	6a 18                	push   $0x18
  80148e:	e8 8a fd ff ff       	call   80121d <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	6a 00                	push   $0x0
  8014a0:	ff 75 14             	pushl  0x14(%ebp)
  8014a3:	ff 75 10             	pushl  0x10(%ebp)
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	50                   	push   %eax
  8014aa:	6a 19                	push   $0x19
  8014ac:	e8 6c fd ff ff       	call   80121d <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	50                   	push   %eax
  8014c5:	6a 1a                	push   $0x1a
  8014c7:	e8 51 fd ff ff       	call   80121d <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	90                   	nop
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	50                   	push   %eax
  8014e1:	6a 1b                	push   $0x1b
  8014e3:	e8 35 fd ff ff       	call   80121d <syscall>
  8014e8:	83 c4 18             	add    $0x18,%esp
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 05                	push   $0x5
  8014fc:	e8 1c fd ff ff       	call   80121d <syscall>
  801501:	83 c4 18             	add    $0x18,%esp
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 06                	push   $0x6
  801515:	e8 03 fd ff ff       	call   80121d <syscall>
  80151a:	83 c4 18             	add    $0x18,%esp
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 07                	push   $0x7
  80152e:	e8 ea fc ff ff       	call   80121d <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_exit_env>:


void sys_exit_env(void)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 1c                	push   $0x1c
  801547:	e8 d1 fc ff ff       	call   80121d <syscall>
  80154c:	83 c4 18             	add    $0x18,%esp
}
  80154f:	90                   	nop
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801558:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80155b:	8d 50 04             	lea    0x4(%eax),%edx
  80155e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	52                   	push   %edx
  801568:	50                   	push   %eax
  801569:	6a 1d                	push   $0x1d
  80156b:	e8 ad fc ff ff       	call   80121d <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
	return result;
  801573:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801576:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801579:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80157c:	89 01                	mov    %eax,(%ecx)
  80157e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	c9                   	leave  
  801585:	c2 04 00             	ret    $0x4

00801588 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	ff 75 10             	pushl  0x10(%ebp)
  801592:	ff 75 0c             	pushl  0xc(%ebp)
  801595:	ff 75 08             	pushl  0x8(%ebp)
  801598:	6a 13                	push   $0x13
  80159a:	e8 7e fc ff ff       	call   80121d <syscall>
  80159f:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a2:	90                   	nop
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 1e                	push   $0x1e
  8015b4:	e8 64 fc ff ff       	call   80121d <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015ca:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	50                   	push   %eax
  8015d7:	6a 1f                	push   $0x1f
  8015d9:	e8 3f fc ff ff       	call   80121d <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e1:	90                   	nop
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <rsttst>:
void rsttst()
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 21                	push   $0x21
  8015f3:	e8 25 fc ff ff       	call   80121d <syscall>
  8015f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015fb:	90                   	nop
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 04             	sub    $0x4,%esp
  801604:	8b 45 14             	mov    0x14(%ebp),%eax
  801607:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80160a:	8b 55 18             	mov    0x18(%ebp),%edx
  80160d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801611:	52                   	push   %edx
  801612:	50                   	push   %eax
  801613:	ff 75 10             	pushl  0x10(%ebp)
  801616:	ff 75 0c             	pushl  0xc(%ebp)
  801619:	ff 75 08             	pushl  0x8(%ebp)
  80161c:	6a 20                	push   $0x20
  80161e:	e8 fa fb ff ff       	call   80121d <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
	return ;
  801626:	90                   	nop
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <chktst>:
void chktst(uint32 n)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	ff 75 08             	pushl  0x8(%ebp)
  801637:	6a 22                	push   $0x22
  801639:	e8 df fb ff ff       	call   80121d <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
	return ;
  801641:	90                   	nop
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <inctst>:

void inctst()
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 23                	push   $0x23
  801653:	e8 c5 fb ff ff       	call   80121d <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
	return ;
  80165b:	90                   	nop
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <gettst>:
uint32 gettst()
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 24                	push   $0x24
  80166d:	e8 ab fb ff ff       	call   80121d <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 25                	push   $0x25
  801689:	e8 8f fb ff ff       	call   80121d <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
  801691:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801694:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801698:	75 07                	jne    8016a1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80169a:	b8 01 00 00 00       	mov    $0x1,%eax
  80169f:	eb 05                	jmp    8016a6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 25                	push   $0x25
  8016ba:	e8 5e fb ff ff       	call   80121d <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
  8016c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016c5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016c9:	75 07                	jne    8016d2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d0:	eb 05                	jmp    8016d7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 25                	push   $0x25
  8016eb:	e8 2d fb ff ff       	call   80121d <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
  8016f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016f6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016fa:	75 07                	jne    801703 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016fc:	b8 01 00 00 00       	mov    $0x1,%eax
  801701:	eb 05                	jmp    801708 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 25                	push   $0x25
  80171c:	e8 fc fa ff ff       	call   80121d <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
  801724:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801727:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80172b:	75 07                	jne    801734 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80172d:	b8 01 00 00 00       	mov    $0x1,%eax
  801732:	eb 05                	jmp    801739 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	ff 75 08             	pushl  0x8(%ebp)
  801749:	6a 26                	push   $0x26
  80174b:	e8 cd fa ff ff       	call   80121d <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
	return ;
  801753:	90                   	nop
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80175a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80175d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801760:	8b 55 0c             	mov    0xc(%ebp),%edx
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	6a 00                	push   $0x0
  801768:	53                   	push   %ebx
  801769:	51                   	push   %ecx
  80176a:	52                   	push   %edx
  80176b:	50                   	push   %eax
  80176c:	6a 27                	push   $0x27
  80176e:	e8 aa fa ff ff       	call   80121d <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	52                   	push   %edx
  80178b:	50                   	push   %eax
  80178c:	6a 28                	push   $0x28
  80178e:	e8 8a fa ff ff       	call   80121d <syscall>
  801793:	83 c4 18             	add    $0x18,%esp
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80179b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80179e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	6a 00                	push   $0x0
  8017a6:	51                   	push   %ecx
  8017a7:	ff 75 10             	pushl  0x10(%ebp)
  8017aa:	52                   	push   %edx
  8017ab:	50                   	push   %eax
  8017ac:	6a 29                	push   $0x29
  8017ae:	e8 6a fa ff ff       	call   80121d <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	ff 75 10             	pushl  0x10(%ebp)
  8017c2:	ff 75 0c             	pushl  0xc(%ebp)
  8017c5:	ff 75 08             	pushl  0x8(%ebp)
  8017c8:	6a 12                	push   $0x12
  8017ca:	e8 4e fa ff ff       	call   80121d <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d2:	90                   	nop
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	52                   	push   %edx
  8017e5:	50                   	push   %eax
  8017e6:	6a 2a                	push   $0x2a
  8017e8:	e8 30 fa ff ff       	call   80121d <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
	return;
  8017f0:	90                   	nop
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	68 76 22 80 00       	push   $0x802276
  801801:	68 2e 01 00 00       	push   $0x12e
  801806:	68 8a 22 80 00       	push   $0x80228a
  80180b:	e8 3a 00 00 00       	call   80184a <_panic>

00801810 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801816:	83 ec 04             	sub    $0x4,%esp
  801819:	68 76 22 80 00       	push   $0x802276
  80181e:	68 35 01 00 00       	push   $0x135
  801823:	68 8a 22 80 00       	push   $0x80228a
  801828:	e8 1d 00 00 00       	call   80184a <_panic>

0080182d <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801833:	83 ec 04             	sub    $0x4,%esp
  801836:	68 76 22 80 00       	push   $0x802276
  80183b:	68 3b 01 00 00       	push   $0x13b
  801840:	68 8a 22 80 00       	push   $0x80228a
  801845:	e8 00 00 00 00       	call   80184a <_panic>

0080184a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801850:	8d 45 10             	lea    0x10(%ebp),%eax
  801853:	83 c0 04             	add    $0x4,%eax
  801856:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801859:	a1 24 30 80 00       	mov    0x803024,%eax
  80185e:	85 c0                	test   %eax,%eax
  801860:	74 16                	je     801878 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801862:	a1 24 30 80 00       	mov    0x803024,%eax
  801867:	83 ec 08             	sub    $0x8,%esp
  80186a:	50                   	push   %eax
  80186b:	68 98 22 80 00       	push   $0x802298
  801870:	e8 e4 ea ff ff       	call   800359 <cprintf>
  801875:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801878:	a1 00 30 80 00       	mov    0x803000,%eax
  80187d:	ff 75 0c             	pushl  0xc(%ebp)
  801880:	ff 75 08             	pushl  0x8(%ebp)
  801883:	50                   	push   %eax
  801884:	68 9d 22 80 00       	push   $0x80229d
  801889:	e8 cb ea ff ff       	call   800359 <cprintf>
  80188e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801891:	8b 45 10             	mov    0x10(%ebp),%eax
  801894:	83 ec 08             	sub    $0x8,%esp
  801897:	ff 75 f4             	pushl  -0xc(%ebp)
  80189a:	50                   	push   %eax
  80189b:	e8 4e ea ff ff       	call   8002ee <vcprintf>
  8018a0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8018a3:	83 ec 08             	sub    $0x8,%esp
  8018a6:	6a 00                	push   $0x0
  8018a8:	68 b9 22 80 00       	push   $0x8022b9
  8018ad:	e8 3c ea ff ff       	call   8002ee <vcprintf>
  8018b2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8018b5:	e8 bd e9 ff ff       	call   800277 <exit>

	// should not return here
	while (1) ;
  8018ba:	eb fe                	jmp    8018ba <_panic+0x70>

008018bc <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8018c2:	a1 04 30 80 00       	mov    0x803004,%eax
  8018c7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d0:	39 c2                	cmp    %eax,%edx
  8018d2:	74 14                	je     8018e8 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8018d4:	83 ec 04             	sub    $0x4,%esp
  8018d7:	68 bc 22 80 00       	push   $0x8022bc
  8018dc:	6a 26                	push   $0x26
  8018de:	68 08 23 80 00       	push   $0x802308
  8018e3:	e8 62 ff ff ff       	call   80184a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8018e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8018ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8018f6:	e9 c5 00 00 00       	jmp    8019c0 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8018fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	01 d0                	add    %edx,%eax
  80190a:	8b 00                	mov    (%eax),%eax
  80190c:	85 c0                	test   %eax,%eax
  80190e:	75 08                	jne    801918 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801910:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801913:	e9 a5 00 00 00       	jmp    8019bd <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801918:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80191f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801926:	eb 69                	jmp    801991 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801928:	a1 04 30 80 00       	mov    0x803004,%eax
  80192d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801933:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801936:	89 d0                	mov    %edx,%eax
  801938:	01 c0                	add    %eax,%eax
  80193a:	01 d0                	add    %edx,%eax
  80193c:	c1 e0 03             	shl    $0x3,%eax
  80193f:	01 c8                	add    %ecx,%eax
  801941:	8a 40 04             	mov    0x4(%eax),%al
  801944:	84 c0                	test   %al,%al
  801946:	75 46                	jne    80198e <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801948:	a1 04 30 80 00       	mov    0x803004,%eax
  80194d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801953:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801956:	89 d0                	mov    %edx,%eax
  801958:	01 c0                	add    %eax,%eax
  80195a:	01 d0                	add    %edx,%eax
  80195c:	c1 e0 03             	shl    $0x3,%eax
  80195f:	01 c8                	add    %ecx,%eax
  801961:	8b 00                	mov    (%eax),%eax
  801963:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801966:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801969:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80196e:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801973:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	01 c8                	add    %ecx,%eax
  80197f:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801981:	39 c2                	cmp    %eax,%edx
  801983:	75 09                	jne    80198e <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801985:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80198c:	eb 15                	jmp    8019a3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80198e:	ff 45 e8             	incl   -0x18(%ebp)
  801991:	a1 04 30 80 00       	mov    0x803004,%eax
  801996:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80199c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80199f:	39 c2                	cmp    %eax,%edx
  8019a1:	77 85                	ja     801928 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8019a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019a7:	75 14                	jne    8019bd <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8019a9:	83 ec 04             	sub    $0x4,%esp
  8019ac:	68 14 23 80 00       	push   $0x802314
  8019b1:	6a 3a                	push   $0x3a
  8019b3:	68 08 23 80 00       	push   $0x802308
  8019b8:	e8 8d fe ff ff       	call   80184a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8019bd:	ff 45 f0             	incl   -0x10(%ebp)
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8019c6:	0f 8c 2f ff ff ff    	jl     8018fb <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8019cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019da:	eb 26                	jmp    801a02 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8019dc:	a1 04 30 80 00       	mov    0x803004,%eax
  8019e1:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8019e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019ea:	89 d0                	mov    %edx,%eax
  8019ec:	01 c0                	add    %eax,%eax
  8019ee:	01 d0                	add    %edx,%eax
  8019f0:	c1 e0 03             	shl    $0x3,%eax
  8019f3:	01 c8                	add    %ecx,%eax
  8019f5:	8a 40 04             	mov    0x4(%eax),%al
  8019f8:	3c 01                	cmp    $0x1,%al
  8019fa:	75 03                	jne    8019ff <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019fc:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019ff:	ff 45 e0             	incl   -0x20(%ebp)
  801a02:	a1 04 30 80 00       	mov    0x803004,%eax
  801a07:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a10:	39 c2                	cmp    %eax,%edx
  801a12:	77 c8                	ja     8019dc <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a17:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a1a:	74 14                	je     801a30 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	68 68 23 80 00       	push   $0x802368
  801a24:	6a 44                	push   $0x44
  801a26:	68 08 23 80 00       	push   $0x802308
  801a2b:	e8 1a fe ff ff       	call   80184a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a30:	90                   	nop
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    
  801a33:	90                   	nop

00801a34 <__udivdi3>:
  801a34:	55                   	push   %ebp
  801a35:	57                   	push   %edi
  801a36:	56                   	push   %esi
  801a37:	53                   	push   %ebx
  801a38:	83 ec 1c             	sub    $0x1c,%esp
  801a3b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a3f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a43:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4b:	89 ca                	mov    %ecx,%edx
  801a4d:	89 f8                	mov    %edi,%eax
  801a4f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a53:	85 f6                	test   %esi,%esi
  801a55:	75 2d                	jne    801a84 <__udivdi3+0x50>
  801a57:	39 cf                	cmp    %ecx,%edi
  801a59:	77 65                	ja     801ac0 <__udivdi3+0x8c>
  801a5b:	89 fd                	mov    %edi,%ebp
  801a5d:	85 ff                	test   %edi,%edi
  801a5f:	75 0b                	jne    801a6c <__udivdi3+0x38>
  801a61:	b8 01 00 00 00       	mov    $0x1,%eax
  801a66:	31 d2                	xor    %edx,%edx
  801a68:	f7 f7                	div    %edi
  801a6a:	89 c5                	mov    %eax,%ebp
  801a6c:	31 d2                	xor    %edx,%edx
  801a6e:	89 c8                	mov    %ecx,%eax
  801a70:	f7 f5                	div    %ebp
  801a72:	89 c1                	mov    %eax,%ecx
  801a74:	89 d8                	mov    %ebx,%eax
  801a76:	f7 f5                	div    %ebp
  801a78:	89 cf                	mov    %ecx,%edi
  801a7a:	89 fa                	mov    %edi,%edx
  801a7c:	83 c4 1c             	add    $0x1c,%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5f                   	pop    %edi
  801a82:	5d                   	pop    %ebp
  801a83:	c3                   	ret    
  801a84:	39 ce                	cmp    %ecx,%esi
  801a86:	77 28                	ja     801ab0 <__udivdi3+0x7c>
  801a88:	0f bd fe             	bsr    %esi,%edi
  801a8b:	83 f7 1f             	xor    $0x1f,%edi
  801a8e:	75 40                	jne    801ad0 <__udivdi3+0x9c>
  801a90:	39 ce                	cmp    %ecx,%esi
  801a92:	72 0a                	jb     801a9e <__udivdi3+0x6a>
  801a94:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a98:	0f 87 9e 00 00 00    	ja     801b3c <__udivdi3+0x108>
  801a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa3:	89 fa                	mov    %edi,%edx
  801aa5:	83 c4 1c             	add    $0x1c,%esp
  801aa8:	5b                   	pop    %ebx
  801aa9:	5e                   	pop    %esi
  801aaa:	5f                   	pop    %edi
  801aab:	5d                   	pop    %ebp
  801aac:	c3                   	ret    
  801aad:	8d 76 00             	lea    0x0(%esi),%esi
  801ab0:	31 ff                	xor    %edi,%edi
  801ab2:	31 c0                	xor    %eax,%eax
  801ab4:	89 fa                	mov    %edi,%edx
  801ab6:	83 c4 1c             	add    $0x1c,%esp
  801ab9:	5b                   	pop    %ebx
  801aba:	5e                   	pop    %esi
  801abb:	5f                   	pop    %edi
  801abc:	5d                   	pop    %ebp
  801abd:	c3                   	ret    
  801abe:	66 90                	xchg   %ax,%ax
  801ac0:	89 d8                	mov    %ebx,%eax
  801ac2:	f7 f7                	div    %edi
  801ac4:	31 ff                	xor    %edi,%edi
  801ac6:	89 fa                	mov    %edi,%edx
  801ac8:	83 c4 1c             	add    $0x1c,%esp
  801acb:	5b                   	pop    %ebx
  801acc:	5e                   	pop    %esi
  801acd:	5f                   	pop    %edi
  801ace:	5d                   	pop    %ebp
  801acf:	c3                   	ret    
  801ad0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ad5:	89 eb                	mov    %ebp,%ebx
  801ad7:	29 fb                	sub    %edi,%ebx
  801ad9:	89 f9                	mov    %edi,%ecx
  801adb:	d3 e6                	shl    %cl,%esi
  801add:	89 c5                	mov    %eax,%ebp
  801adf:	88 d9                	mov    %bl,%cl
  801ae1:	d3 ed                	shr    %cl,%ebp
  801ae3:	89 e9                	mov    %ebp,%ecx
  801ae5:	09 f1                	or     %esi,%ecx
  801ae7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801aeb:	89 f9                	mov    %edi,%ecx
  801aed:	d3 e0                	shl    %cl,%eax
  801aef:	89 c5                	mov    %eax,%ebp
  801af1:	89 d6                	mov    %edx,%esi
  801af3:	88 d9                	mov    %bl,%cl
  801af5:	d3 ee                	shr    %cl,%esi
  801af7:	89 f9                	mov    %edi,%ecx
  801af9:	d3 e2                	shl    %cl,%edx
  801afb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aff:	88 d9                	mov    %bl,%cl
  801b01:	d3 e8                	shr    %cl,%eax
  801b03:	09 c2                	or     %eax,%edx
  801b05:	89 d0                	mov    %edx,%eax
  801b07:	89 f2                	mov    %esi,%edx
  801b09:	f7 74 24 0c          	divl   0xc(%esp)
  801b0d:	89 d6                	mov    %edx,%esi
  801b0f:	89 c3                	mov    %eax,%ebx
  801b11:	f7 e5                	mul    %ebp
  801b13:	39 d6                	cmp    %edx,%esi
  801b15:	72 19                	jb     801b30 <__udivdi3+0xfc>
  801b17:	74 0b                	je     801b24 <__udivdi3+0xf0>
  801b19:	89 d8                	mov    %ebx,%eax
  801b1b:	31 ff                	xor    %edi,%edi
  801b1d:	e9 58 ff ff ff       	jmp    801a7a <__udivdi3+0x46>
  801b22:	66 90                	xchg   %ax,%ax
  801b24:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b28:	89 f9                	mov    %edi,%ecx
  801b2a:	d3 e2                	shl    %cl,%edx
  801b2c:	39 c2                	cmp    %eax,%edx
  801b2e:	73 e9                	jae    801b19 <__udivdi3+0xe5>
  801b30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b33:	31 ff                	xor    %edi,%edi
  801b35:	e9 40 ff ff ff       	jmp    801a7a <__udivdi3+0x46>
  801b3a:	66 90                	xchg   %ax,%ax
  801b3c:	31 c0                	xor    %eax,%eax
  801b3e:	e9 37 ff ff ff       	jmp    801a7a <__udivdi3+0x46>
  801b43:	90                   	nop

00801b44 <__umoddi3>:
  801b44:	55                   	push   %ebp
  801b45:	57                   	push   %edi
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	83 ec 1c             	sub    $0x1c,%esp
  801b4b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b57:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b63:	89 f3                	mov    %esi,%ebx
  801b65:	89 fa                	mov    %edi,%edx
  801b67:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b6b:	89 34 24             	mov    %esi,(%esp)
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	75 1a                	jne    801b8c <__umoddi3+0x48>
  801b72:	39 f7                	cmp    %esi,%edi
  801b74:	0f 86 a2 00 00 00    	jbe    801c1c <__umoddi3+0xd8>
  801b7a:	89 c8                	mov    %ecx,%eax
  801b7c:	89 f2                	mov    %esi,%edx
  801b7e:	f7 f7                	div    %edi
  801b80:	89 d0                	mov    %edx,%eax
  801b82:	31 d2                	xor    %edx,%edx
  801b84:	83 c4 1c             	add    $0x1c,%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
  801b8c:	39 f0                	cmp    %esi,%eax
  801b8e:	0f 87 ac 00 00 00    	ja     801c40 <__umoddi3+0xfc>
  801b94:	0f bd e8             	bsr    %eax,%ebp
  801b97:	83 f5 1f             	xor    $0x1f,%ebp
  801b9a:	0f 84 ac 00 00 00    	je     801c4c <__umoddi3+0x108>
  801ba0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ba5:	29 ef                	sub    %ebp,%edi
  801ba7:	89 fe                	mov    %edi,%esi
  801ba9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bad:	89 e9                	mov    %ebp,%ecx
  801baf:	d3 e0                	shl    %cl,%eax
  801bb1:	89 d7                	mov    %edx,%edi
  801bb3:	89 f1                	mov    %esi,%ecx
  801bb5:	d3 ef                	shr    %cl,%edi
  801bb7:	09 c7                	or     %eax,%edi
  801bb9:	89 e9                	mov    %ebp,%ecx
  801bbb:	d3 e2                	shl    %cl,%edx
  801bbd:	89 14 24             	mov    %edx,(%esp)
  801bc0:	89 d8                	mov    %ebx,%eax
  801bc2:	d3 e0                	shl    %cl,%eax
  801bc4:	89 c2                	mov    %eax,%edx
  801bc6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bca:	d3 e0                	shl    %cl,%eax
  801bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd4:	89 f1                	mov    %esi,%ecx
  801bd6:	d3 e8                	shr    %cl,%eax
  801bd8:	09 d0                	or     %edx,%eax
  801bda:	d3 eb                	shr    %cl,%ebx
  801bdc:	89 da                	mov    %ebx,%edx
  801bde:	f7 f7                	div    %edi
  801be0:	89 d3                	mov    %edx,%ebx
  801be2:	f7 24 24             	mull   (%esp)
  801be5:	89 c6                	mov    %eax,%esi
  801be7:	89 d1                	mov    %edx,%ecx
  801be9:	39 d3                	cmp    %edx,%ebx
  801beb:	0f 82 87 00 00 00    	jb     801c78 <__umoddi3+0x134>
  801bf1:	0f 84 91 00 00 00    	je     801c88 <__umoddi3+0x144>
  801bf7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bfb:	29 f2                	sub    %esi,%edx
  801bfd:	19 cb                	sbb    %ecx,%ebx
  801bff:	89 d8                	mov    %ebx,%eax
  801c01:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c05:	d3 e0                	shl    %cl,%eax
  801c07:	89 e9                	mov    %ebp,%ecx
  801c09:	d3 ea                	shr    %cl,%edx
  801c0b:	09 d0                	or     %edx,%eax
  801c0d:	89 e9                	mov    %ebp,%ecx
  801c0f:	d3 eb                	shr    %cl,%ebx
  801c11:	89 da                	mov    %ebx,%edx
  801c13:	83 c4 1c             	add    $0x1c,%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5e                   	pop    %esi
  801c18:	5f                   	pop    %edi
  801c19:	5d                   	pop    %ebp
  801c1a:	c3                   	ret    
  801c1b:	90                   	nop
  801c1c:	89 fd                	mov    %edi,%ebp
  801c1e:	85 ff                	test   %edi,%edi
  801c20:	75 0b                	jne    801c2d <__umoddi3+0xe9>
  801c22:	b8 01 00 00 00       	mov    $0x1,%eax
  801c27:	31 d2                	xor    %edx,%edx
  801c29:	f7 f7                	div    %edi
  801c2b:	89 c5                	mov    %eax,%ebp
  801c2d:	89 f0                	mov    %esi,%eax
  801c2f:	31 d2                	xor    %edx,%edx
  801c31:	f7 f5                	div    %ebp
  801c33:	89 c8                	mov    %ecx,%eax
  801c35:	f7 f5                	div    %ebp
  801c37:	89 d0                	mov    %edx,%eax
  801c39:	e9 44 ff ff ff       	jmp    801b82 <__umoddi3+0x3e>
  801c3e:	66 90                	xchg   %ax,%ax
  801c40:	89 c8                	mov    %ecx,%eax
  801c42:	89 f2                	mov    %esi,%edx
  801c44:	83 c4 1c             	add    $0x1c,%esp
  801c47:	5b                   	pop    %ebx
  801c48:	5e                   	pop    %esi
  801c49:	5f                   	pop    %edi
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    
  801c4c:	3b 04 24             	cmp    (%esp),%eax
  801c4f:	72 06                	jb     801c57 <__umoddi3+0x113>
  801c51:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c55:	77 0f                	ja     801c66 <__umoddi3+0x122>
  801c57:	89 f2                	mov    %esi,%edx
  801c59:	29 f9                	sub    %edi,%ecx
  801c5b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c5f:	89 14 24             	mov    %edx,(%esp)
  801c62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c66:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c6a:	8b 14 24             	mov    (%esp),%edx
  801c6d:	83 c4 1c             	add    $0x1c,%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5f                   	pop    %edi
  801c73:	5d                   	pop    %ebp
  801c74:	c3                   	ret    
  801c75:	8d 76 00             	lea    0x0(%esi),%esi
  801c78:	2b 04 24             	sub    (%esp),%eax
  801c7b:	19 fa                	sbb    %edi,%edx
  801c7d:	89 d1                	mov    %edx,%ecx
  801c7f:	89 c6                	mov    %eax,%esi
  801c81:	e9 71 ff ff ff       	jmp    801bf7 <__umoddi3+0xb3>
  801c86:	66 90                	xchg   %ax,%ax
  801c88:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c8c:	72 ea                	jb     801c78 <__umoddi3+0x134>
  801c8e:	89 d9                	mov    %ebx,%ecx
  801c90:	e9 62 ff ff ff       	jmp    801bf7 <__umoddi3+0xb3>
