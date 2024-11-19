
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
  80004b:	e8 a3 10 00 00       	call   8010f3 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 80 1c 80 00       	push   $0x801c80
  800061:	e8 0a 03 00 00       	call   800370 <atomic_cprintf>
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
  8000b9:	68 93 1c 80 00       	push   $0x801c93
  8000be:	e8 ad 02 00 00       	call   800370 <atomic_cprintf>
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
  8000d7:	e8 40 10 00 00       	call   80111c <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 09 10 00 00       	call   8010f3 <malloc>
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
  80010f:	68 93 1c 80 00       	push   $0x801c93
  800114:	e8 57 02 00 00       	call   800370 <atomic_cprintf>
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
  80012d:	e8 ea 0f 00 00       	call   80111c <free>
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
  80013e:	e8 ad 13 00 00       	call   8014f0 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 02             	shl    $0x2,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	01 c0                	add    %eax,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	c1 e0 02             	shl    $0x2,%eax
  800157:	01 d0                	add    %edx,%eax
  800159:	01 c0                	add    %eax,%eax
  80015b:	01 d0                	add    %edx,%eax
  80015d:	c1 e0 04             	shl    $0x4,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016a:	a1 04 30 80 00       	mov    0x803004,%eax
  80016f:	8a 40 20             	mov    0x20(%eax),%al
  800172:	84 c0                	test   %al,%al
  800174:	74 0d                	je     800183 <libmain+0x4b>
		binaryname = myEnv->prog_name;
  800176:	a1 04 30 80 00       	mov    0x803004,%eax
  80017b:	83 c0 20             	add    $0x20,%eax
  80017e:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800183:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800187:	7e 0a                	jle    800193 <libmain+0x5b>
		binaryname = argv[0];
  800189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018c:	8b 00                	mov    (%eax),%eax
  80018e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800193:	83 ec 08             	sub    $0x8,%esp
  800196:	ff 75 0c             	pushl  0xc(%ebp)
  800199:	ff 75 08             	pushl  0x8(%ebp)
  80019c:	e8 97 fe ff ff       	call   800038 <_main>
  8001a1:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001a4:	e8 cb 10 00 00       	call   801274 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001a9:	83 ec 0c             	sub    $0xc,%esp
  8001ac:	68 b8 1c 80 00       	push   $0x801cb8
  8001b1:	e8 8d 01 00 00       	call   800343 <cprintf>
  8001b6:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b9:	a1 04 30 80 00       	mov    0x803004,%eax
  8001be:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8001c4:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c9:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	52                   	push   %edx
  8001d3:	50                   	push   %eax
  8001d4:	68 e0 1c 80 00       	push   $0x801ce0
  8001d9:	e8 65 01 00 00       	call   800343 <cprintf>
  8001de:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e1:	a1 04 30 80 00       	mov    0x803004,%eax
  8001e6:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8001ec:	a1 04 30 80 00       	mov    0x803004,%eax
  8001f1:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8001f7:	a1 04 30 80 00       	mov    0x803004,%eax
  8001fc:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800202:	51                   	push   %ecx
  800203:	52                   	push   %edx
  800204:	50                   	push   %eax
  800205:	68 08 1d 80 00       	push   $0x801d08
  80020a:	e8 34 01 00 00       	call   800343 <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800212:	a1 04 30 80 00       	mov    0x803004,%eax
  800217:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	50                   	push   %eax
  800221:	68 60 1d 80 00       	push   $0x801d60
  800226:	e8 18 01 00 00       	call   800343 <cprintf>
  80022b:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80022e:	83 ec 0c             	sub    $0xc,%esp
  800231:	68 b8 1c 80 00       	push   $0x801cb8
  800236:	e8 08 01 00 00       	call   800343 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80023e:	e8 4b 10 00 00       	call   80128e <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800243:	e8 19 00 00 00       	call   800261 <exit>
}
  800248:	90                   	nop
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800251:	83 ec 0c             	sub    $0xc,%esp
  800254:	6a 00                	push   $0x0
  800256:	e8 61 12 00 00       	call   8014bc <sys_destroy_env>
  80025b:	83 c4 10             	add    $0x10,%esp
}
  80025e:	90                   	nop
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <exit>:

void
exit(void)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800267:	e8 b6 12 00 00       	call   801522 <sys_exit_env>
}
  80026c:	90                   	nop
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800275:	8b 45 0c             	mov    0xc(%ebp),%eax
  800278:	8b 00                	mov    (%eax),%eax
  80027a:	8d 48 01             	lea    0x1(%eax),%ecx
  80027d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800280:	89 0a                	mov    %ecx,(%edx)
  800282:	8b 55 08             	mov    0x8(%ebp),%edx
  800285:	88 d1                	mov    %dl,%cl
  800287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80028e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800291:	8b 00                	mov    (%eax),%eax
  800293:	3d ff 00 00 00       	cmp    $0xff,%eax
  800298:	75 2c                	jne    8002c6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80029a:	a0 08 30 80 00       	mov    0x803008,%al
  80029f:	0f b6 c0             	movzbl %al,%eax
  8002a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a5:	8b 12                	mov    (%edx),%edx
  8002a7:	89 d1                	mov    %edx,%ecx
  8002a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ac:	83 c2 08             	add    $0x8,%edx
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	50                   	push   %eax
  8002b3:	51                   	push   %ecx
  8002b4:	52                   	push   %edx
  8002b5:	e8 78 0f 00 00       	call   801232 <sys_cputs>
  8002ba:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 40 04             	mov    0x4(%eax),%eax
  8002cc:	8d 50 01             	lea    0x1(%eax),%edx
  8002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002d5:	90                   	nop
  8002d6:	c9                   	leave  
  8002d7:	c3                   	ret    

008002d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e8:	00 00 00 
	b.cnt = 0;
  8002eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002f5:	ff 75 0c             	pushl  0xc(%ebp)
  8002f8:	ff 75 08             	pushl  0x8(%ebp)
  8002fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800301:	50                   	push   %eax
  800302:	68 6f 02 80 00       	push   $0x80026f
  800307:	e8 11 02 00 00       	call   80051d <vprintfmt>
  80030c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80030f:	a0 08 30 80 00       	mov    0x803008,%al
  800314:	0f b6 c0             	movzbl %al,%eax
  800317:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80031d:	83 ec 04             	sub    $0x4,%esp
  800320:	50                   	push   %eax
  800321:	52                   	push   %edx
  800322:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800328:	83 c0 08             	add    $0x8,%eax
  80032b:	50                   	push   %eax
  80032c:	e8 01 0f 00 00       	call   801232 <sys_cputs>
  800331:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800334:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80033b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800341:	c9                   	leave  
  800342:	c3                   	ret    

00800343 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800349:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800350:	8d 45 0c             	lea    0xc(%ebp),%eax
  800353:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800356:	8b 45 08             	mov    0x8(%ebp),%eax
  800359:	83 ec 08             	sub    $0x8,%esp
  80035c:	ff 75 f4             	pushl  -0xc(%ebp)
  80035f:	50                   	push   %eax
  800360:	e8 73 ff ff ff       	call   8002d8 <vcprintf>
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80036b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800376:	e8 f9 0e 00 00       	call   801274 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80037b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80037e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	ff 75 f4             	pushl  -0xc(%ebp)
  80038a:	50                   	push   %eax
  80038b:	e8 48 ff ff ff       	call   8002d8 <vcprintf>
  800390:	83 c4 10             	add    $0x10,%esp
  800393:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800396:	e8 f3 0e 00 00       	call   80128e <sys_unlock_cons>
	return cnt;
  80039b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	53                   	push   %ebx
  8003a4:	83 ec 14             	sub    $0x14,%esp
  8003a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b3:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003be:	77 55                	ja     800415 <printnum+0x75>
  8003c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c3:	72 05                	jb     8003ca <printnum+0x2a>
  8003c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003c8:	77 4b                	ja     800415 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003ca:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003cd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d8:	52                   	push   %edx
  8003d9:	50                   	push   %eax
  8003da:	ff 75 f4             	pushl  -0xc(%ebp)
  8003dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e0:	e8 37 16 00 00       	call   801a1c <__udivdi3>
  8003e5:	83 c4 10             	add    $0x10,%esp
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	ff 75 20             	pushl  0x20(%ebp)
  8003ee:	53                   	push   %ebx
  8003ef:	ff 75 18             	pushl  0x18(%ebp)
  8003f2:	52                   	push   %edx
  8003f3:	50                   	push   %eax
  8003f4:	ff 75 0c             	pushl  0xc(%ebp)
  8003f7:	ff 75 08             	pushl  0x8(%ebp)
  8003fa:	e8 a1 ff ff ff       	call   8003a0 <printnum>
  8003ff:	83 c4 20             	add    $0x20,%esp
  800402:	eb 1a                	jmp    80041e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800404:	83 ec 08             	sub    $0x8,%esp
  800407:	ff 75 0c             	pushl  0xc(%ebp)
  80040a:	ff 75 20             	pushl  0x20(%ebp)
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	ff d0                	call   *%eax
  800412:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800415:	ff 4d 1c             	decl   0x1c(%ebp)
  800418:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80041c:	7f e6                	jg     800404 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80041e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800421:	bb 00 00 00 00       	mov    $0x0,%ebx
  800426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800429:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80042c:	53                   	push   %ebx
  80042d:	51                   	push   %ecx
  80042e:	52                   	push   %edx
  80042f:	50                   	push   %eax
  800430:	e8 f7 16 00 00       	call   801b2c <__umoddi3>
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	05 94 1f 80 00       	add    $0x801f94,%eax
  80043d:	8a 00                	mov    (%eax),%al
  80043f:	0f be c0             	movsbl %al,%eax
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	ff 75 0c             	pushl  0xc(%ebp)
  800448:	50                   	push   %eax
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	ff d0                	call   *%eax
  80044e:	83 c4 10             	add    $0x10,%esp
}
  800451:	90                   	nop
  800452:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80045e:	7e 1c                	jle    80047c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	8d 50 08             	lea    0x8(%eax),%edx
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	89 10                	mov    %edx,(%eax)
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 e8 08             	sub    $0x8,%eax
  800475:	8b 50 04             	mov    0x4(%eax),%edx
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	eb 40                	jmp    8004bc <getuint+0x65>
	else if (lflag)
  80047c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800480:	74 1e                	je     8004a0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	8d 50 04             	lea    0x4(%eax),%edx
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	89 10                	mov    %edx,(%eax)
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	83 e8 04             	sub    $0x4,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	ba 00 00 00 00       	mov    $0x0,%edx
  80049e:	eb 1c                	jmp    8004bc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	8d 50 04             	lea    0x4(%eax),%edx
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	89 10                	mov    %edx,(%eax)
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	83 e8 04             	sub    $0x4,%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004bc:	5d                   	pop    %ebp
  8004bd:	c3                   	ret    

008004be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004c5:	7e 1c                	jle    8004e3 <getint+0x25>
		return va_arg(*ap, long long);
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	8d 50 08             	lea    0x8(%eax),%edx
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	83 e8 08             	sub    $0x8,%eax
  8004dc:	8b 50 04             	mov    0x4(%eax),%edx
  8004df:	8b 00                	mov    (%eax),%eax
  8004e1:	eb 38                	jmp    80051b <getint+0x5d>
	else if (lflag)
  8004e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004e7:	74 1a                	je     800503 <getint+0x45>
		return va_arg(*ap, long);
  8004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ec:	8b 00                	mov    (%eax),%eax
  8004ee:	8d 50 04             	lea    0x4(%eax),%edx
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	89 10                	mov    %edx,(%eax)
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	8b 00                	mov    (%eax),%eax
  8004fb:	83 e8 04             	sub    $0x4,%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	99                   	cltd   
  800501:	eb 18                	jmp    80051b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	8d 50 04             	lea    0x4(%eax),%edx
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	89 10                	mov    %edx,(%eax)
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	83 e8 04             	sub    $0x4,%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	99                   	cltd   
}
  80051b:	5d                   	pop    %ebp
  80051c:	c3                   	ret    

0080051d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	56                   	push   %esi
  800521:	53                   	push   %ebx
  800522:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800525:	eb 17                	jmp    80053e <vprintfmt+0x21>
			if (ch == '\0')
  800527:	85 db                	test   %ebx,%ebx
  800529:	0f 84 c1 03 00 00    	je     8008f0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	ff 75 0c             	pushl  0xc(%ebp)
  800535:	53                   	push   %ebx
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	ff d0                	call   *%eax
  80053b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80053e:	8b 45 10             	mov    0x10(%ebp),%eax
  800541:	8d 50 01             	lea    0x1(%eax),%edx
  800544:	89 55 10             	mov    %edx,0x10(%ebp)
  800547:	8a 00                	mov    (%eax),%al
  800549:	0f b6 d8             	movzbl %al,%ebx
  80054c:	83 fb 25             	cmp    $0x25,%ebx
  80054f:	75 d6                	jne    800527 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800551:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800555:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80055c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800563:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80056a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800571:	8b 45 10             	mov    0x10(%ebp),%eax
  800574:	8d 50 01             	lea    0x1(%eax),%edx
  800577:	89 55 10             	mov    %edx,0x10(%ebp)
  80057a:	8a 00                	mov    (%eax),%al
  80057c:	0f b6 d8             	movzbl %al,%ebx
  80057f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800582:	83 f8 5b             	cmp    $0x5b,%eax
  800585:	0f 87 3d 03 00 00    	ja     8008c8 <vprintfmt+0x3ab>
  80058b:	8b 04 85 b8 1f 80 00 	mov    0x801fb8(,%eax,4),%eax
  800592:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800594:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800598:	eb d7                	jmp    800571 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80059e:	eb d1                	jmp    800571 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005aa:	89 d0                	mov    %edx,%eax
  8005ac:	c1 e0 02             	shl    $0x2,%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	01 c0                	add    %eax,%eax
  8005b3:	01 d8                	add    %ebx,%eax
  8005b5:	83 e8 30             	sub    $0x30,%eax
  8005b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8005be:	8a 00                	mov    (%eax),%al
  8005c0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c3:	83 fb 2f             	cmp    $0x2f,%ebx
  8005c6:	7e 3e                	jle    800606 <vprintfmt+0xe9>
  8005c8:	83 fb 39             	cmp    $0x39,%ebx
  8005cb:	7f 39                	jg     800606 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005cd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d0:	eb d5                	jmp    8005a7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	83 c0 04             	add    $0x4,%eax
  8005d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	83 e8 04             	sub    $0x4,%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005e6:	eb 1f                	jmp    800607 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ec:	79 83                	jns    800571 <vprintfmt+0x54>
				width = 0;
  8005ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005f5:	e9 77 ff ff ff       	jmp    800571 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005fa:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800601:	e9 6b ff ff ff       	jmp    800571 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800606:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800607:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80060b:	0f 89 60 ff ff ff    	jns    800571 <vprintfmt+0x54>
				width = precision, precision = -1;
  800611:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800617:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80061e:	e9 4e ff ff ff       	jmp    800571 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800623:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800626:	e9 46 ff ff ff       	jmp    800571 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	83 c0 04             	add    $0x4,%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	83 e8 04             	sub    $0x4,%eax
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	ff 75 0c             	pushl  0xc(%ebp)
  800642:	50                   	push   %eax
  800643:	8b 45 08             	mov    0x8(%ebp),%eax
  800646:	ff d0                	call   *%eax
  800648:	83 c4 10             	add    $0x10,%esp
			break;
  80064b:	e9 9b 02 00 00       	jmp    8008eb <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	83 c0 04             	add    $0x4,%eax
  800656:	89 45 14             	mov    %eax,0x14(%ebp)
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	83 e8 04             	sub    $0x4,%eax
  80065f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800661:	85 db                	test   %ebx,%ebx
  800663:	79 02                	jns    800667 <vprintfmt+0x14a>
				err = -err;
  800665:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800667:	83 fb 64             	cmp    $0x64,%ebx
  80066a:	7f 0b                	jg     800677 <vprintfmt+0x15a>
  80066c:	8b 34 9d 00 1e 80 00 	mov    0x801e00(,%ebx,4),%esi
  800673:	85 f6                	test   %esi,%esi
  800675:	75 19                	jne    800690 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800677:	53                   	push   %ebx
  800678:	68 a5 1f 80 00       	push   $0x801fa5
  80067d:	ff 75 0c             	pushl  0xc(%ebp)
  800680:	ff 75 08             	pushl  0x8(%ebp)
  800683:	e8 70 02 00 00       	call   8008f8 <printfmt>
  800688:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80068b:	e9 5b 02 00 00       	jmp    8008eb <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800690:	56                   	push   %esi
  800691:	68 ae 1f 80 00       	push   $0x801fae
  800696:	ff 75 0c             	pushl  0xc(%ebp)
  800699:	ff 75 08             	pushl  0x8(%ebp)
  80069c:	e8 57 02 00 00       	call   8008f8 <printfmt>
  8006a1:	83 c4 10             	add    $0x10,%esp
			break;
  8006a4:	e9 42 02 00 00       	jmp    8008eb <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	83 c0 04             	add    $0x4,%eax
  8006af:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	83 e8 04             	sub    $0x4,%eax
  8006b8:	8b 30                	mov    (%eax),%esi
  8006ba:	85 f6                	test   %esi,%esi
  8006bc:	75 05                	jne    8006c3 <vprintfmt+0x1a6>
				p = "(null)";
  8006be:	be b1 1f 80 00       	mov    $0x801fb1,%esi
			if (width > 0 && padc != '-')
  8006c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c7:	7e 6d                	jle    800736 <vprintfmt+0x219>
  8006c9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006cd:	74 67                	je     800736 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	50                   	push   %eax
  8006d6:	56                   	push   %esi
  8006d7:	e8 1e 03 00 00       	call   8009fa <strnlen>
  8006dc:	83 c4 10             	add    $0x10,%esp
  8006df:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e2:	eb 16                	jmp    8006fa <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006e4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	50                   	push   %eax
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f7:	ff 4d e4             	decl   -0x1c(%ebp)
  8006fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fe:	7f e4                	jg     8006e4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800700:	eb 34                	jmp    800736 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800702:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800706:	74 1c                	je     800724 <vprintfmt+0x207>
  800708:	83 fb 1f             	cmp    $0x1f,%ebx
  80070b:	7e 05                	jle    800712 <vprintfmt+0x1f5>
  80070d:	83 fb 7e             	cmp    $0x7e,%ebx
  800710:	7e 12                	jle    800724 <vprintfmt+0x207>
					putch('?', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	6a 3f                	push   $0x3f
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	ff d0                	call   *%eax
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	eb 0f                	jmp    800733 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 0c             	pushl  0xc(%ebp)
  80072a:	53                   	push   %ebx
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	ff d0                	call   *%eax
  800730:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800733:	ff 4d e4             	decl   -0x1c(%ebp)
  800736:	89 f0                	mov    %esi,%eax
  800738:	8d 70 01             	lea    0x1(%eax),%esi
  80073b:	8a 00                	mov    (%eax),%al
  80073d:	0f be d8             	movsbl %al,%ebx
  800740:	85 db                	test   %ebx,%ebx
  800742:	74 24                	je     800768 <vprintfmt+0x24b>
  800744:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800748:	78 b8                	js     800702 <vprintfmt+0x1e5>
  80074a:	ff 4d e0             	decl   -0x20(%ebp)
  80074d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800751:	79 af                	jns    800702 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800753:	eb 13                	jmp    800768 <vprintfmt+0x24b>
				putch(' ', putdat);
  800755:	83 ec 08             	sub    $0x8,%esp
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	6a 20                	push   $0x20
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800765:	ff 4d e4             	decl   -0x1c(%ebp)
  800768:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80076c:	7f e7                	jg     800755 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80076e:	e9 78 01 00 00       	jmp    8008eb <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	ff 75 e8             	pushl  -0x18(%ebp)
  800779:	8d 45 14             	lea    0x14(%ebp),%eax
  80077c:	50                   	push   %eax
  80077d:	e8 3c fd ff ff       	call   8004be <getint>
  800782:	83 c4 10             	add    $0x10,%esp
  800785:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800788:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800791:	85 d2                	test   %edx,%edx
  800793:	79 23                	jns    8007b8 <vprintfmt+0x29b>
				putch('-', putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	6a 2d                	push   $0x2d
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	ff d0                	call   *%eax
  8007a2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ab:	f7 d8                	neg    %eax
  8007ad:	83 d2 00             	adc    $0x0,%edx
  8007b0:	f7 da                	neg    %edx
  8007b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007b8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007bf:	e9 bc 00 00 00       	jmp    800880 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c4:	83 ec 08             	sub    $0x8,%esp
  8007c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ca:	8d 45 14             	lea    0x14(%ebp),%eax
  8007cd:	50                   	push   %eax
  8007ce:	e8 84 fc ff ff       	call   800457 <getuint>
  8007d3:	83 c4 10             	add    $0x10,%esp
  8007d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007dc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e3:	e9 98 00 00 00       	jmp    800880 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	6a 58                	push   $0x58
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	ff d0                	call   *%eax
  8007f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007f8:	83 ec 08             	sub    $0x8,%esp
  8007fb:	ff 75 0c             	pushl  0xc(%ebp)
  8007fe:	6a 58                	push   $0x58
  800800:	8b 45 08             	mov    0x8(%ebp),%eax
  800803:	ff d0                	call   *%eax
  800805:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	6a 58                	push   $0x58
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	ff d0                	call   *%eax
  800815:	83 c4 10             	add    $0x10,%esp
			break;
  800818:	e9 ce 00 00 00       	jmp    8008eb <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	6a 30                	push   $0x30
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80082d:	83 ec 08             	sub    $0x8,%esp
  800830:	ff 75 0c             	pushl  0xc(%ebp)
  800833:	6a 78                	push   $0x78
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	ff d0                	call   *%eax
  80083a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	83 c0 04             	add    $0x4,%eax
  800843:	89 45 14             	mov    %eax,0x14(%ebp)
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	83 e8 04             	sub    $0x4,%eax
  80084c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80084e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800851:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800858:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80085f:	eb 1f                	jmp    800880 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 e8             	pushl  -0x18(%ebp)
  800867:	8d 45 14             	lea    0x14(%ebp),%eax
  80086a:	50                   	push   %eax
  80086b:	e8 e7 fb ff ff       	call   800457 <getuint>
  800870:	83 c4 10             	add    $0x10,%esp
  800873:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800876:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800879:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800880:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800884:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800887:	83 ec 04             	sub    $0x4,%esp
  80088a:	52                   	push   %edx
  80088b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80088e:	50                   	push   %eax
  80088f:	ff 75 f4             	pushl  -0xc(%ebp)
  800892:	ff 75 f0             	pushl  -0x10(%ebp)
  800895:	ff 75 0c             	pushl  0xc(%ebp)
  800898:	ff 75 08             	pushl  0x8(%ebp)
  80089b:	e8 00 fb ff ff       	call   8003a0 <printnum>
  8008a0:	83 c4 20             	add    $0x20,%esp
			break;
  8008a3:	eb 46                	jmp    8008eb <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	53                   	push   %ebx
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
			break;
  8008b4:	eb 35                	jmp    8008eb <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008b6:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8008bd:	eb 2c                	jmp    8008eb <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008bf:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8008c6:	eb 23                	jmp    8008eb <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	6a 25                	push   $0x25
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	ff d0                	call   *%eax
  8008d5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d8:	ff 4d 10             	decl   0x10(%ebp)
  8008db:	eb 03                	jmp    8008e0 <vprintfmt+0x3c3>
  8008dd:	ff 4d 10             	decl   0x10(%ebp)
  8008e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e3:	48                   	dec    %eax
  8008e4:	8a 00                	mov    (%eax),%al
  8008e6:	3c 25                	cmp    $0x25,%al
  8008e8:	75 f3                	jne    8008dd <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008ea:	90                   	nop
		}
	}
  8008eb:	e9 35 fc ff ff       	jmp    800525 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008f0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008fe:	8d 45 10             	lea    0x10(%ebp),%eax
  800901:	83 c0 04             	add    $0x4,%eax
  800904:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800907:	8b 45 10             	mov    0x10(%ebp),%eax
  80090a:	ff 75 f4             	pushl  -0xc(%ebp)
  80090d:	50                   	push   %eax
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	ff 75 08             	pushl  0x8(%ebp)
  800914:	e8 04 fc ff ff       	call   80051d <vprintfmt>
  800919:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80091c:	90                   	nop
  80091d:	c9                   	leave  
  80091e:	c3                   	ret    

0080091f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800922:	8b 45 0c             	mov    0xc(%ebp),%eax
  800925:	8b 40 08             	mov    0x8(%eax),%eax
  800928:	8d 50 01             	lea    0x1(%eax),%edx
  80092b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800931:	8b 45 0c             	mov    0xc(%ebp),%eax
  800934:	8b 10                	mov    (%eax),%edx
  800936:	8b 45 0c             	mov    0xc(%ebp),%eax
  800939:	8b 40 04             	mov    0x4(%eax),%eax
  80093c:	39 c2                	cmp    %eax,%edx
  80093e:	73 12                	jae    800952 <sprintputch+0x33>
		*b->buf++ = ch;
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
  800943:	8b 00                	mov    (%eax),%eax
  800945:	8d 48 01             	lea    0x1(%eax),%ecx
  800948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094b:	89 0a                	mov    %ecx,(%edx)
  80094d:	8b 55 08             	mov    0x8(%ebp),%edx
  800950:	88 10                	mov    %dl,(%eax)
}
  800952:	90                   	nop
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800961:	8b 45 0c             	mov    0xc(%ebp),%eax
  800964:	8d 50 ff             	lea    -0x1(%eax),%edx
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	01 d0                	add    %edx,%eax
  80096c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800976:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80097a:	74 06                	je     800982 <vsnprintf+0x2d>
  80097c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800980:	7f 07                	jg     800989 <vsnprintf+0x34>
		return -E_INVAL;
  800982:	b8 03 00 00 00       	mov    $0x3,%eax
  800987:	eb 20                	jmp    8009a9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800989:	ff 75 14             	pushl  0x14(%ebp)
  80098c:	ff 75 10             	pushl  0x10(%ebp)
  80098f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800992:	50                   	push   %eax
  800993:	68 1f 09 80 00       	push   $0x80091f
  800998:	e8 80 fb ff ff       	call   80051d <vprintfmt>
  80099d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    

008009ab <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009b1:	8d 45 10             	lea    0x10(%ebp),%eax
  8009b4:	83 c0 04             	add    $0x4,%eax
  8009b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c0:	50                   	push   %eax
  8009c1:	ff 75 0c             	pushl  0xc(%ebp)
  8009c4:	ff 75 08             	pushl  0x8(%ebp)
  8009c7:	e8 89 ff ff ff       	call   800955 <vsnprintf>
  8009cc:	83 c4 10             	add    $0x10,%esp
  8009cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009d5:	c9                   	leave  
  8009d6:	c3                   	ret    

008009d7 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009e4:	eb 06                	jmp    8009ec <strlen+0x15>
		n++;
  8009e6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e9:	ff 45 08             	incl   0x8(%ebp)
  8009ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ef:	8a 00                	mov    (%eax),%al
  8009f1:	84 c0                	test   %al,%al
  8009f3:	75 f1                	jne    8009e6 <strlen+0xf>
		n++;
	return n;
  8009f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f8:	c9                   	leave  
  8009f9:	c3                   	ret    

008009fa <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a07:	eb 09                	jmp    800a12 <strnlen+0x18>
		n++;
  800a09:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0c:	ff 45 08             	incl   0x8(%ebp)
  800a0f:	ff 4d 0c             	decl   0xc(%ebp)
  800a12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a16:	74 09                	je     800a21 <strnlen+0x27>
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8a 00                	mov    (%eax),%al
  800a1d:	84 c0                	test   %al,%al
  800a1f:	75 e8                	jne    800a09 <strnlen+0xf>
		n++;
	return n;
  800a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a32:	90                   	nop
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8d 50 01             	lea    0x1(%eax),%edx
  800a39:	89 55 08             	mov    %edx,0x8(%ebp)
  800a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a42:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a45:	8a 12                	mov    (%edx),%dl
  800a47:	88 10                	mov    %dl,(%eax)
  800a49:	8a 00                	mov    (%eax),%al
  800a4b:	84 c0                	test   %al,%al
  800a4d:	75 e4                	jne    800a33 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a52:	c9                   	leave  
  800a53:	c3                   	ret    

00800a54 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a60:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a67:	eb 1f                	jmp    800a88 <strncpy+0x34>
		*dst++ = *src;
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8d 50 01             	lea    0x1(%eax),%edx
  800a6f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a75:	8a 12                	mov    (%edx),%dl
  800a77:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	8a 00                	mov    (%eax),%al
  800a7e:	84 c0                	test   %al,%al
  800a80:	74 03                	je     800a85 <strncpy+0x31>
			src++;
  800a82:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a85:	ff 45 fc             	incl   -0x4(%ebp)
  800a88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a8b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a8e:	72 d9                	jb     800a69 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a90:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a93:	c9                   	leave  
  800a94:	c3                   	ret    

00800a95 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aa1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa5:	74 30                	je     800ad7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aa7:	eb 16                	jmp    800abf <strlcpy+0x2a>
			*dst++ = *src++;
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	8d 50 01             	lea    0x1(%eax),%edx
  800aaf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ab8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800abb:	8a 12                	mov    (%edx),%dl
  800abd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800abf:	ff 4d 10             	decl   0x10(%ebp)
  800ac2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac6:	74 09                	je     800ad1 <strlcpy+0x3c>
  800ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acb:	8a 00                	mov    (%eax),%al
  800acd:	84 c0                	test   %al,%al
  800acf:	75 d8                	jne    800aa9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  800ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800add:	29 c2                	sub    %eax,%edx
  800adf:	89 d0                	mov    %edx,%eax
}
  800ae1:	c9                   	leave  
  800ae2:	c3                   	ret    

00800ae3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ae6:	eb 06                	jmp    800aee <strcmp+0xb>
		p++, q++;
  800ae8:	ff 45 08             	incl   0x8(%ebp)
  800aeb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	74 0e                	je     800b05 <strcmp+0x22>
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8a 10                	mov    (%eax),%dl
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	8a 00                	mov    (%eax),%al
  800b01:	38 c2                	cmp    %al,%dl
  800b03:	74 e3                	je     800ae8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b05:	8b 45 08             	mov    0x8(%ebp),%eax
  800b08:	8a 00                	mov    (%eax),%al
  800b0a:	0f b6 d0             	movzbl %al,%edx
  800b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b10:	8a 00                	mov    (%eax),%al
  800b12:	0f b6 c0             	movzbl %al,%eax
  800b15:	29 c2                	sub    %eax,%edx
  800b17:	89 d0                	mov    %edx,%eax
}
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b1e:	eb 09                	jmp    800b29 <strncmp+0xe>
		n--, p++, q++;
  800b20:	ff 4d 10             	decl   0x10(%ebp)
  800b23:	ff 45 08             	incl   0x8(%ebp)
  800b26:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b2d:	74 17                	je     800b46 <strncmp+0x2b>
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8a 00                	mov    (%eax),%al
  800b34:	84 c0                	test   %al,%al
  800b36:	74 0e                	je     800b46 <strncmp+0x2b>
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8a 10                	mov    (%eax),%dl
  800b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b40:	8a 00                	mov    (%eax),%al
  800b42:	38 c2                	cmp    %al,%dl
  800b44:	74 da                	je     800b20 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b4a:	75 07                	jne    800b53 <strncmp+0x38>
		return 0;
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b51:	eb 14                	jmp    800b67 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8a 00                	mov    (%eax),%al
  800b58:	0f b6 d0             	movzbl %al,%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	8a 00                	mov    (%eax),%al
  800b60:	0f b6 c0             	movzbl %al,%eax
  800b63:	29 c2                	sub    %eax,%edx
  800b65:	89 d0                	mov    %edx,%eax
}
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	83 ec 04             	sub    $0x4,%esp
  800b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b75:	eb 12                	jmp    800b89 <strchr+0x20>
		if (*s == c)
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8a 00                	mov    (%eax),%al
  800b7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b7f:	75 05                	jne    800b86 <strchr+0x1d>
			return (char *) s;
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	eb 11                	jmp    800b97 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b86:	ff 45 08             	incl   0x8(%ebp)
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8a 00                	mov    (%eax),%al
  800b8e:	84 c0                	test   %al,%al
  800b90:	75 e5                	jne    800b77 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    

00800b99 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	83 ec 04             	sub    $0x4,%esp
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ba5:	eb 0d                	jmp    800bb4 <strfind+0x1b>
		if (*s == c)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800baf:	74 0e                	je     800bbf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bb1:	ff 45 08             	incl   0x8(%ebp)
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	8a 00                	mov    (%eax),%al
  800bb9:	84 c0                	test   %al,%al
  800bbb:	75 ea                	jne    800ba7 <strfind+0xe>
  800bbd:	eb 01                	jmp    800bc0 <strfind+0x27>
		if (*s == c)
			break;
  800bbf:	90                   	nop
	return (char *) s;
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bd7:	eb 0e                	jmp    800be7 <memset+0x22>
		*p++ = c;
  800bd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bdc:	8d 50 01             	lea    0x1(%eax),%edx
  800bdf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800be7:	ff 4d f8             	decl   -0x8(%ebp)
  800bea:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bee:	79 e9                	jns    800bd9 <memset+0x14>
		*p++ = c;

	return v;
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bf3:	c9                   	leave  
  800bf4:	c3                   	ret    

00800bf5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c07:	eb 16                	jmp    800c1f <memcpy+0x2a>
		*d++ = *s++;
  800c09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c0c:	8d 50 01             	lea    0x1(%eax),%edx
  800c0f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c18:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c1b:	8a 12                	mov    (%edx),%dl
  800c1d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c22:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c25:	89 55 10             	mov    %edx,0x10(%ebp)
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	75 dd                	jne    800c09 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c2f:	c9                   	leave  
  800c30:	c3                   	ret    

00800c31 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c49:	73 50                	jae    800c9b <memmove+0x6a>
  800c4b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	01 d0                	add    %edx,%eax
  800c53:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c56:	76 43                	jbe    800c9b <memmove+0x6a>
		s += n;
  800c58:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c61:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c64:	eb 10                	jmp    800c76 <memmove+0x45>
			*--d = *--s;
  800c66:	ff 4d f8             	decl   -0x8(%ebp)
  800c69:	ff 4d fc             	decl   -0x4(%ebp)
  800c6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6f:	8a 10                	mov    (%eax),%dl
  800c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c74:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c76:	8b 45 10             	mov    0x10(%ebp),%eax
  800c79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c7c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	75 e3                	jne    800c66 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c83:	eb 23                	jmp    800ca8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c88:	8d 50 01             	lea    0x1(%eax),%edx
  800c8b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c91:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c94:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c97:	8a 12                	mov    (%edx),%dl
  800c99:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca4:	85 c0                	test   %eax,%eax
  800ca6:	75 dd                	jne    800c85 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cbf:	eb 2a                	jmp    800ceb <memcmp+0x3e>
		if (*s1 != *s2)
  800cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc4:	8a 10                	mov    (%eax),%dl
  800cc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	38 c2                	cmp    %al,%dl
  800ccd:	74 16                	je     800ce5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	0f b6 d0             	movzbl %al,%edx
  800cd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	0f b6 c0             	movzbl %al,%eax
  800cdf:	29 c2                	sub    %eax,%edx
  800ce1:	89 d0                	mov    %edx,%eax
  800ce3:	eb 18                	jmp    800cfd <memcmp+0x50>
		s1++, s2++;
  800ce5:	ff 45 fc             	incl   -0x4(%ebp)
  800ce8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf1:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	75 c9                	jne    800cc1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d05:	8b 55 08             	mov    0x8(%ebp),%edx
  800d08:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0b:	01 d0                	add    %edx,%eax
  800d0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d10:	eb 15                	jmp    800d27 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	0f b6 d0             	movzbl %al,%edx
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	0f b6 c0             	movzbl %al,%eax
  800d20:	39 c2                	cmp    %eax,%edx
  800d22:	74 0d                	je     800d31 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d24:	ff 45 08             	incl   0x8(%ebp)
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d2d:	72 e3                	jb     800d12 <memfind+0x13>
  800d2f:	eb 01                	jmp    800d32 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d31:	90                   	nop
	return (void *) s;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d35:	c9                   	leave  
  800d36:	c3                   	ret    

00800d37 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d44:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4b:	eb 03                	jmp    800d50 <strtol+0x19>
		s++;
  800d4d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	3c 20                	cmp    $0x20,%al
  800d57:	74 f4                	je     800d4d <strtol+0x16>
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	3c 09                	cmp    $0x9,%al
  800d60:	74 eb                	je     800d4d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	3c 2b                	cmp    $0x2b,%al
  800d69:	75 05                	jne    800d70 <strtol+0x39>
		s++;
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	eb 13                	jmp    800d83 <strtol+0x4c>
	else if (*s == '-')
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	3c 2d                	cmp    $0x2d,%al
  800d77:	75 0a                	jne    800d83 <strtol+0x4c>
		s++, neg = 1;
  800d79:	ff 45 08             	incl   0x8(%ebp)
  800d7c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d87:	74 06                	je     800d8f <strtol+0x58>
  800d89:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d8d:	75 20                	jne    800daf <strtol+0x78>
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	3c 30                	cmp    $0x30,%al
  800d96:	75 17                	jne    800daf <strtol+0x78>
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	40                   	inc    %eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	3c 78                	cmp    $0x78,%al
  800da0:	75 0d                	jne    800daf <strtol+0x78>
		s += 2, base = 16;
  800da2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800da6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dad:	eb 28                	jmp    800dd7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800daf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db3:	75 15                	jne    800dca <strtol+0x93>
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 30                	cmp    $0x30,%al
  800dbc:	75 0c                	jne    800dca <strtol+0x93>
		s++, base = 8;
  800dbe:	ff 45 08             	incl   0x8(%ebp)
  800dc1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dc8:	eb 0d                	jmp    800dd7 <strtol+0xa0>
	else if (base == 0)
  800dca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dce:	75 07                	jne    800dd7 <strtol+0xa0>
		base = 10;
  800dd0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	3c 2f                	cmp    $0x2f,%al
  800dde:	7e 19                	jle    800df9 <strtol+0xc2>
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	3c 39                	cmp    $0x39,%al
  800de7:	7f 10                	jg     800df9 <strtol+0xc2>
			dig = *s - '0';
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f be c0             	movsbl %al,%eax
  800df1:	83 e8 30             	sub    $0x30,%eax
  800df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800df7:	eb 42                	jmp    800e3b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8a 00                	mov    (%eax),%al
  800dfe:	3c 60                	cmp    $0x60,%al
  800e00:	7e 19                	jle    800e1b <strtol+0xe4>
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	3c 7a                	cmp    $0x7a,%al
  800e09:	7f 10                	jg     800e1b <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	0f be c0             	movsbl %al,%eax
  800e13:	83 e8 57             	sub    $0x57,%eax
  800e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e19:	eb 20                	jmp    800e3b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3c 40                	cmp    $0x40,%al
  800e22:	7e 39                	jle    800e5d <strtol+0x126>
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	3c 5a                	cmp    $0x5a,%al
  800e2b:	7f 30                	jg     800e5d <strtol+0x126>
			dig = *s - 'A' + 10;
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	0f be c0             	movsbl %al,%eax
  800e35:	83 e8 37             	sub    $0x37,%eax
  800e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e3e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e41:	7d 19                	jge    800e5c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e49:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e4d:	89 c2                	mov    %eax,%edx
  800e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e52:	01 d0                	add    %edx,%eax
  800e54:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e57:	e9 7b ff ff ff       	jmp    800dd7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e5c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e61:	74 08                	je     800e6b <strtol+0x134>
		*endptr = (char *) s;
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	8b 55 08             	mov    0x8(%ebp),%edx
  800e69:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e6b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e6f:	74 07                	je     800e78 <strtol+0x141>
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e74:	f7 d8                	neg    %eax
  800e76:	eb 03                	jmp    800e7b <strtol+0x144>
  800e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <ltostr>:

void
ltostr(long value, char *str)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e8a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e95:	79 13                	jns    800eaa <ltostr+0x2d>
	{
		neg = 1;
  800e97:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ea4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ea7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eb2:	99                   	cltd   
  800eb3:	f7 f9                	idiv   %ecx
  800eb5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	8d 50 01             	lea    0x1(%eax),%edx
  800ebe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec1:	89 c2                	mov    %eax,%edx
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	01 d0                	add    %edx,%eax
  800ec8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ecb:	83 c2 30             	add    $0x30,%edx
  800ece:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ed0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ed8:	f7 e9                	imul   %ecx
  800eda:	c1 fa 02             	sar    $0x2,%edx
  800edd:	89 c8                	mov    %ecx,%eax
  800edf:	c1 f8 1f             	sar    $0x1f,%eax
  800ee2:	29 c2                	sub    %eax,%edx
  800ee4:	89 d0                	mov    %edx,%eax
  800ee6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800ee9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eed:	75 bb                	jne    800eaa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800eef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	48                   	dec    %eax
  800efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800efd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f01:	74 3d                	je     800f40 <ltostr+0xc3>
		start = 1 ;
  800f03:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f0a:	eb 34                	jmp    800f40 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f12:	01 d0                	add    %edx,%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1f:	01 c2                	add    %eax,%edx
  800f21:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f27:	01 c8                	add    %ecx,%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	01 c2                	add    %eax,%edx
  800f35:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f38:	88 02                	mov    %al,(%edx)
		start++ ;
  800f3a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f3d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f43:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f46:	7c c4                	jl     800f0c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f48:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4e:	01 d0                	add    %edx,%eax
  800f50:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f53:	90                   	nop
  800f54:	c9                   	leave  
  800f55:	c3                   	ret    

00800f56 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f5c:	ff 75 08             	pushl  0x8(%ebp)
  800f5f:	e8 73 fa ff ff       	call   8009d7 <strlen>
  800f64:	83 c4 04             	add    $0x4,%esp
  800f67:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f6a:	ff 75 0c             	pushl  0xc(%ebp)
  800f6d:	e8 65 fa ff ff       	call   8009d7 <strlen>
  800f72:	83 c4 04             	add    $0x4,%esp
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f86:	eb 17                	jmp    800f9f <strcconcat+0x49>
		final[s] = str1[s] ;
  800f88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8e:	01 c2                	add    %eax,%edx
  800f90:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	01 c8                	add    %ecx,%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f9c:	ff 45 fc             	incl   -0x4(%ebp)
  800f9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fa5:	7c e1                	jl     800f88 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fa7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fb5:	eb 1f                	jmp    800fd6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fba:	8d 50 01             	lea    0x1(%eax),%edx
  800fbd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fc0:	89 c2                	mov    %eax,%edx
  800fc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc5:	01 c2                	add    %eax,%edx
  800fc7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcd:	01 c8                	add    %ecx,%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fd3:	ff 45 f8             	incl   -0x8(%ebp)
  800fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fdc:	7c d9                	jl     800fb7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800fde:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe4:	01 d0                	add    %edx,%eax
  800fe6:	c6 00 00             	movb   $0x0,(%eax)
}
  800fe9:	90                   	nop
  800fea:	c9                   	leave  
  800feb:	c3                   	ret    

00800fec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800fef:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800ff8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffb:	8b 00                	mov    (%eax),%eax
  800ffd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80100f:	eb 0c                	jmp    80101d <strsplit+0x31>
			*string++ = 0;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8d 50 01             	lea    0x1(%eax),%edx
  801017:	89 55 08             	mov    %edx,0x8(%ebp)
  80101a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	84 c0                	test   %al,%al
  801024:	74 18                	je     80103e <strsplit+0x52>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	0f be c0             	movsbl %al,%eax
  80102e:	50                   	push   %eax
  80102f:	ff 75 0c             	pushl  0xc(%ebp)
  801032:	e8 32 fb ff ff       	call   800b69 <strchr>
  801037:	83 c4 08             	add    $0x8,%esp
  80103a:	85 c0                	test   %eax,%eax
  80103c:	75 d3                	jne    801011 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	84 c0                	test   %al,%al
  801045:	74 5a                	je     8010a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801047:	8b 45 14             	mov    0x14(%ebp),%eax
  80104a:	8b 00                	mov    (%eax),%eax
  80104c:	83 f8 0f             	cmp    $0xf,%eax
  80104f:	75 07                	jne    801058 <strsplit+0x6c>
		{
			return 0;
  801051:	b8 00 00 00 00       	mov    $0x0,%eax
  801056:	eb 66                	jmp    8010be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801058:	8b 45 14             	mov    0x14(%ebp),%eax
  80105b:	8b 00                	mov    (%eax),%eax
  80105d:	8d 48 01             	lea    0x1(%eax),%ecx
  801060:	8b 55 14             	mov    0x14(%ebp),%edx
  801063:	89 0a                	mov    %ecx,(%edx)
  801065:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80106c:	8b 45 10             	mov    0x10(%ebp),%eax
  80106f:	01 c2                	add    %eax,%edx
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801076:	eb 03                	jmp    80107b <strsplit+0x8f>
			string++;
  801078:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8a 00                	mov    (%eax),%al
  801080:	84 c0                	test   %al,%al
  801082:	74 8b                	je     80100f <strsplit+0x23>
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	0f be c0             	movsbl %al,%eax
  80108c:	50                   	push   %eax
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	e8 d4 fa ff ff       	call   800b69 <strchr>
  801095:	83 c4 08             	add    $0x8,%esp
  801098:	85 c0                	test   %eax,%eax
  80109a:	74 dc                	je     801078 <strsplit+0x8c>
			string++;
	}
  80109c:	e9 6e ff ff ff       	jmp    80100f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a5:	8b 00                	mov    (%eax),%eax
  8010a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b1:	01 d0                	add    %edx,%eax
  8010b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010be:	c9                   	leave  
  8010bf:	c3                   	ret    

008010c0 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8010c6:	83 ec 04             	sub    $0x4,%esp
  8010c9:	68 28 21 80 00       	push   $0x802128
  8010ce:	68 3f 01 00 00       	push   $0x13f
  8010d3:	68 4a 21 80 00       	push   $0x80214a
  8010d8:	e8 53 07 00 00       	call   801830 <_panic>

008010dd <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8010e3:	83 ec 0c             	sub    $0xc,%esp
  8010e6:	ff 75 08             	pushl  0x8(%ebp)
  8010e9:	e8 ef 06 00 00       	call   8017dd <sys_sbrk>
  8010ee:	83 c4 10             	add    $0x10,%esp
}
  8010f1:	c9                   	leave  
  8010f2:	c3                   	ret    

008010f3 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8010f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010fd:	75 07                	jne    801106 <malloc+0x13>
  8010ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801104:	eb 14                	jmp    80111a <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801106:	83 ec 04             	sub    $0x4,%esp
  801109:	68 58 21 80 00       	push   $0x802158
  80110e:	6a 1b                	push   $0x1b
  801110:	68 7d 21 80 00       	push   $0x80217d
  801115:	e8 16 07 00 00       	call   801830 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801122:	83 ec 04             	sub    $0x4,%esp
  801125:	68 8c 21 80 00       	push   $0x80218c
  80112a:	6a 29                	push   $0x29
  80112c:	68 7d 21 80 00       	push   $0x80217d
  801131:	e8 fa 06 00 00       	call   801830 <_panic>

00801136 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 18             	sub    $0x18,%esp
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801142:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801146:	75 07                	jne    80114f <smalloc+0x19>
  801148:	b8 00 00 00 00       	mov    $0x0,%eax
  80114d:	eb 14                	jmp    801163 <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80114f:	83 ec 04             	sub    $0x4,%esp
  801152:	68 b0 21 80 00       	push   $0x8021b0
  801157:	6a 38                	push   $0x38
  801159:	68 7d 21 80 00       	push   $0x80217d
  80115e:	e8 cd 06 00 00       	call   801830 <_panic>
	return NULL;
}
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80116b:	83 ec 04             	sub    $0x4,%esp
  80116e:	68 d8 21 80 00       	push   $0x8021d8
  801173:	6a 43                	push   $0x43
  801175:	68 7d 21 80 00       	push   $0x80217d
  80117a:	e8 b1 06 00 00       	call   801830 <_panic>

0080117f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801185:	83 ec 04             	sub    $0x4,%esp
  801188:	68 fc 21 80 00       	push   $0x8021fc
  80118d:	6a 5b                	push   $0x5b
  80118f:	68 7d 21 80 00       	push   $0x80217d
  801194:	e8 97 06 00 00       	call   801830 <_panic>

00801199 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80119f:	83 ec 04             	sub    $0x4,%esp
  8011a2:	68 20 22 80 00       	push   $0x802220
  8011a7:	6a 72                	push   $0x72
  8011a9:	68 7d 21 80 00       	push   $0x80217d
  8011ae:	e8 7d 06 00 00       	call   801830 <_panic>

008011b3 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8011b9:	83 ec 04             	sub    $0x4,%esp
  8011bc:	68 46 22 80 00       	push   $0x802246
  8011c1:	6a 7e                	push   $0x7e
  8011c3:	68 7d 21 80 00       	push   $0x80217d
  8011c8:	e8 63 06 00 00       	call   801830 <_panic>

008011cd <shrink>:

}
void shrink(uint32 newSize)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8011d3:	83 ec 04             	sub    $0x4,%esp
  8011d6:	68 46 22 80 00       	push   $0x802246
  8011db:	68 83 00 00 00       	push   $0x83
  8011e0:	68 7d 21 80 00       	push   $0x80217d
  8011e5:	e8 46 06 00 00       	call   801830 <_panic>

008011ea <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8011f0:	83 ec 04             	sub    $0x4,%esp
  8011f3:	68 46 22 80 00       	push   $0x802246
  8011f8:	68 88 00 00 00       	push   $0x88
  8011fd:	68 7d 21 80 00       	push   $0x80217d
  801202:	e8 29 06 00 00       	call   801830 <_panic>

00801207 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	57                   	push   %edi
  80120b:	56                   	push   %esi
  80120c:	53                   	push   %ebx
  80120d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8b 55 0c             	mov    0xc(%ebp),%edx
  801216:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801219:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80121c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80121f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801222:	cd 30                	int    $0x30
  801224:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801227:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80122a:	83 c4 10             	add    $0x10,%esp
  80122d:	5b                   	pop    %ebx
  80122e:	5e                   	pop    %esi
  80122f:	5f                   	pop    %edi
  801230:	5d                   	pop    %ebp
  801231:	c3                   	ret    

00801232 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801232:	55                   	push   %ebp
  801233:	89 e5                	mov    %esp,%ebp
  801235:	83 ec 04             	sub    $0x4,%esp
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80123e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	52                   	push   %edx
  80124a:	ff 75 0c             	pushl  0xc(%ebp)
  80124d:	50                   	push   %eax
  80124e:	6a 00                	push   $0x0
  801250:	e8 b2 ff ff ff       	call   801207 <syscall>
  801255:	83 c4 18             	add    $0x18,%esp
}
  801258:	90                   	nop
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <sys_cgetc>:

int
sys_cgetc(void)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	6a 00                	push   $0x0
  801268:	6a 02                	push   $0x2
  80126a:	e8 98 ff ff ff       	call   801207 <syscall>
  80126f:	83 c4 18             	add    $0x18,%esp
}
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 03                	push   $0x3
  801283:	e8 7f ff ff ff       	call   801207 <syscall>
  801288:	83 c4 18             	add    $0x18,%esp
}
  80128b:	90                   	nop
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	6a 04                	push   $0x4
  80129d:	e8 65 ff ff ff       	call   801207 <syscall>
  8012a2:	83 c4 18             	add    $0x18,%esp
}
  8012a5:	90                   	nop
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	6a 00                	push   $0x0
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	52                   	push   %edx
  8012b8:	50                   	push   %eax
  8012b9:	6a 08                	push   $0x8
  8012bb:	e8 47 ff ff ff       	call   801207 <syscall>
  8012c0:	83 c4 18             	add    $0x18,%esp
}
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	56                   	push   %esi
  8012c9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012ca:	8b 75 18             	mov    0x18(%ebp),%esi
  8012cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	56                   	push   %esi
  8012da:	53                   	push   %ebx
  8012db:	51                   	push   %ecx
  8012dc:	52                   	push   %edx
  8012dd:	50                   	push   %eax
  8012de:	6a 09                	push   $0x9
  8012e0:	e8 22 ff ff ff       	call   801207 <syscall>
  8012e5:	83 c4 18             	add    $0x18,%esp
}
  8012e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012eb:	5b                   	pop    %ebx
  8012ec:	5e                   	pop    %esi
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    

008012ef <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8012f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 00                	push   $0x0
  8012fc:	6a 00                	push   $0x0
  8012fe:	52                   	push   %edx
  8012ff:	50                   	push   %eax
  801300:	6a 0a                	push   $0xa
  801302:	e8 00 ff ff ff       	call   801207 <syscall>
  801307:	83 c4 18             	add    $0x18,%esp
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	ff 75 0c             	pushl  0xc(%ebp)
  801318:	ff 75 08             	pushl  0x8(%ebp)
  80131b:	6a 0b                	push   $0xb
  80131d:	e8 e5 fe ff ff       	call   801207 <syscall>
  801322:	83 c4 18             	add    $0x18,%esp
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 0c                	push   $0xc
  801336:	e8 cc fe ff ff       	call   801207 <syscall>
  80133b:	83 c4 18             	add    $0x18,%esp
}
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801343:	6a 00                	push   $0x0
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 0d                	push   $0xd
  80134f:	e8 b3 fe ff ff       	call   801207 <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 0e                	push   $0xe
  801368:	e8 9a fe ff ff       	call   801207 <syscall>
  80136d:	83 c4 18             	add    $0x18,%esp
}
  801370:	c9                   	leave  
  801371:	c3                   	ret    

00801372 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 0f                	push   $0xf
  801381:	e8 81 fe ff ff       	call   801207 <syscall>
  801386:	83 c4 18             	add    $0x18,%esp
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	6a 10                	push   $0x10
  80139b:	e8 67 fe ff ff       	call   801207 <syscall>
  8013a0:	83 c4 18             	add    $0x18,%esp
}
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    

008013a5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 00                	push   $0x0
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 11                	push   $0x11
  8013b4:	e8 4e fe ff ff       	call   801207 <syscall>
  8013b9:	83 c4 18             	add    $0x18,%esp
}
  8013bc:	90                   	nop
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <sys_cputc>:

void
sys_cputc(const char c)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 04             	sub    $0x4,%esp
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8013cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	50                   	push   %eax
  8013d8:	6a 01                	push   $0x1
  8013da:	e8 28 fe ff ff       	call   801207 <syscall>
  8013df:	83 c4 18             	add    $0x18,%esp
}
  8013e2:	90                   	nop
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    

008013e5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 14                	push   $0x14
  8013f4:	e8 0e fe ff ff       	call   801207 <syscall>
  8013f9:	83 c4 18             	add    $0x18,%esp
}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 04             	sub    $0x4,%esp
  801405:	8b 45 10             	mov    0x10(%ebp),%eax
  801408:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80140b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80140e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	6a 00                	push   $0x0
  801417:	51                   	push   %ecx
  801418:	52                   	push   %edx
  801419:	ff 75 0c             	pushl  0xc(%ebp)
  80141c:	50                   	push   %eax
  80141d:	6a 15                	push   $0x15
  80141f:	e8 e3 fd ff ff       	call   801207 <syscall>
  801424:	83 c4 18             	add    $0x18,%esp
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80142c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	52                   	push   %edx
  801439:	50                   	push   %eax
  80143a:	6a 16                	push   $0x16
  80143c:	e8 c6 fd ff ff       	call   801207 <syscall>
  801441:	83 c4 18             	add    $0x18,%esp
}
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801449:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80144c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	51                   	push   %ecx
  801457:	52                   	push   %edx
  801458:	50                   	push   %eax
  801459:	6a 17                	push   $0x17
  80145b:	e8 a7 fd ff ff       	call   801207 <syscall>
  801460:	83 c4 18             	add    $0x18,%esp
}
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	52                   	push   %edx
  801475:	50                   	push   %eax
  801476:	6a 18                	push   $0x18
  801478:	e8 8a fd ff ff       	call   801207 <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
}
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	6a 00                	push   $0x0
  80148a:	ff 75 14             	pushl  0x14(%ebp)
  80148d:	ff 75 10             	pushl  0x10(%ebp)
  801490:	ff 75 0c             	pushl  0xc(%ebp)
  801493:	50                   	push   %eax
  801494:	6a 19                	push   $0x19
  801496:	e8 6c fd ff ff       	call   801207 <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	50                   	push   %eax
  8014af:	6a 1a                	push   $0x1a
  8014b1:	e8 51 fd ff ff       	call   801207 <syscall>
  8014b6:	83 c4 18             	add    $0x18,%esp
}
  8014b9:	90                   	nop
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	50                   	push   %eax
  8014cb:	6a 1b                	push   $0x1b
  8014cd:	e8 35 fd ff ff       	call   801207 <syscall>
  8014d2:	83 c4 18             	add    $0x18,%esp
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 05                	push   $0x5
  8014e6:	e8 1c fd ff ff       	call   801207 <syscall>
  8014eb:	83 c4 18             	add    $0x18,%esp
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 06                	push   $0x6
  8014ff:	e8 03 fd ff ff       	call   801207 <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 07                	push   $0x7
  801518:	e8 ea fc ff ff       	call   801207 <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <sys_exit_env>:


void sys_exit_env(void)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 1c                	push   $0x1c
  801531:	e8 d1 fc ff ff       	call   801207 <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	90                   	nop
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801542:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801545:	8d 50 04             	lea    0x4(%eax),%edx
  801548:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	52                   	push   %edx
  801552:	50                   	push   %eax
  801553:	6a 1d                	push   $0x1d
  801555:	e8 ad fc ff ff       	call   801207 <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
	return result;
  80155d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801560:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801563:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801566:	89 01                	mov    %eax,(%ecx)
  801568:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	c9                   	leave  
  80156f:	c2 04 00             	ret    $0x4

00801572 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	ff 75 10             	pushl  0x10(%ebp)
  80157c:	ff 75 0c             	pushl  0xc(%ebp)
  80157f:	ff 75 08             	pushl  0x8(%ebp)
  801582:	6a 13                	push   $0x13
  801584:	e8 7e fc ff ff       	call   801207 <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
	return ;
  80158c:	90                   	nop
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_rcr2>:
uint32 sys_rcr2()
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 1e                	push   $0x1e
  80159e:	e8 64 fc ff ff       	call   801207 <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 04             	sub    $0x4,%esp
  8015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015b4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	50                   	push   %eax
  8015c1:	6a 1f                	push   $0x1f
  8015c3:	e8 3f fc ff ff       	call   801207 <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8015cb:	90                   	nop
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <rsttst>:
void rsttst()
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 21                	push   $0x21
  8015dd:	e8 25 fc ff ff       	call   801207 <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e5:	90                   	nop
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8015f4:	8b 55 18             	mov    0x18(%ebp),%edx
  8015f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8015fb:	52                   	push   %edx
  8015fc:	50                   	push   %eax
  8015fd:	ff 75 10             	pushl  0x10(%ebp)
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	ff 75 08             	pushl  0x8(%ebp)
  801606:	6a 20                	push   $0x20
  801608:	e8 fa fb ff ff       	call   801207 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
	return ;
  801610:	90                   	nop
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <chktst>:
void chktst(uint32 n)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	ff 75 08             	pushl  0x8(%ebp)
  801621:	6a 22                	push   $0x22
  801623:	e8 df fb ff ff       	call   801207 <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
	return ;
  80162b:	90                   	nop
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <inctst>:

void inctst()
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 23                	push   $0x23
  80163d:	e8 c5 fb ff ff       	call   801207 <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
	return ;
  801645:	90                   	nop
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <gettst>:
uint32 gettst()
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 24                	push   $0x24
  801657:	e8 ab fb ff ff       	call   801207 <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 25                	push   $0x25
  801673:	e8 8f fb ff ff       	call   801207 <syscall>
  801678:	83 c4 18             	add    $0x18,%esp
  80167b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80167e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801682:	75 07                	jne    80168b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801684:	b8 01 00 00 00       	mov    $0x1,%eax
  801689:	eb 05                	jmp    801690 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80168b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 25                	push   $0x25
  8016a4:	e8 5e fb ff ff       	call   801207 <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
  8016ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016af:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016b3:	75 07                	jne    8016bc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ba:	eb 05                	jmp    8016c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 25                	push   $0x25
  8016d5:	e8 2d fb ff ff       	call   801207 <syscall>
  8016da:	83 c4 18             	add    $0x18,%esp
  8016dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8016e0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8016e4:	75 07                	jne    8016ed <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8016e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8016eb:	eb 05                	jmp    8016f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 25                	push   $0x25
  801706:	e8 fc fa ff ff       	call   801207 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
  80170e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801711:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801715:	75 07                	jne    80171e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801717:	b8 01 00 00 00       	mov    $0x1,%eax
  80171c:	eb 05                	jmp    801723 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	ff 75 08             	pushl  0x8(%ebp)
  801733:	6a 26                	push   $0x26
  801735:	e8 cd fa ff ff       	call   801207 <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
	return ;
  80173d:	90                   	nop
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801744:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801747:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	6a 00                	push   $0x0
  801752:	53                   	push   %ebx
  801753:	51                   	push   %ecx
  801754:	52                   	push   %edx
  801755:	50                   	push   %eax
  801756:	6a 27                	push   $0x27
  801758:	e8 aa fa ff ff       	call   801207 <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801768:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	52                   	push   %edx
  801775:	50                   	push   %eax
  801776:	6a 28                	push   $0x28
  801778:	e8 8a fa ff ff       	call   801207 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801785:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801788:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	6a 00                	push   $0x0
  801790:	51                   	push   %ecx
  801791:	ff 75 10             	pushl  0x10(%ebp)
  801794:	52                   	push   %edx
  801795:	50                   	push   %eax
  801796:	6a 29                	push   $0x29
  801798:	e8 6a fa ff ff       	call   801207 <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	ff 75 10             	pushl  0x10(%ebp)
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	ff 75 08             	pushl  0x8(%ebp)
  8017b2:	6a 12                	push   $0x12
  8017b4:	e8 4e fa ff ff       	call   801207 <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bc:	90                   	nop
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8017c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	52                   	push   %edx
  8017cf:	50                   	push   %eax
  8017d0:	6a 2a                	push   $0x2a
  8017d2:	e8 30 fa ff ff       	call   801207 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
	return;
  8017da:	90                   	nop
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	50                   	push   %eax
  8017ec:	6a 2b                	push   $0x2b
  8017ee:	e8 14 fa ff ff       	call   801207 <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	ff 75 0c             	pushl  0xc(%ebp)
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	6a 2c                	push   $0x2c
  801809:	e8 f9 f9 ff ff       	call   801207 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
	return;
  801811:	90                   	nop
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	ff 75 08             	pushl  0x8(%ebp)
  801823:	6a 2d                	push   $0x2d
  801825:	e8 dd f9 ff ff       	call   801207 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
	return;
  80182d:	90                   	nop
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801836:	8d 45 10             	lea    0x10(%ebp),%eax
  801839:	83 c0 04             	add    $0x4,%eax
  80183c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80183f:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801844:	85 c0                	test   %eax,%eax
  801846:	74 16                	je     80185e <_panic+0x2e>
		cprintf("%s: ", argv0);
  801848:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80184d:	83 ec 08             	sub    $0x8,%esp
  801850:	50                   	push   %eax
  801851:	68 58 22 80 00       	push   $0x802258
  801856:	e8 e8 ea ff ff       	call   800343 <cprintf>
  80185b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80185e:	a1 00 30 80 00       	mov    0x803000,%eax
  801863:	ff 75 0c             	pushl  0xc(%ebp)
  801866:	ff 75 08             	pushl  0x8(%ebp)
  801869:	50                   	push   %eax
  80186a:	68 5d 22 80 00       	push   $0x80225d
  80186f:	e8 cf ea ff ff       	call   800343 <cprintf>
  801874:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801877:	8b 45 10             	mov    0x10(%ebp),%eax
  80187a:	83 ec 08             	sub    $0x8,%esp
  80187d:	ff 75 f4             	pushl  -0xc(%ebp)
  801880:	50                   	push   %eax
  801881:	e8 52 ea ff ff       	call   8002d8 <vcprintf>
  801886:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801889:	83 ec 08             	sub    $0x8,%esp
  80188c:	6a 00                	push   $0x0
  80188e:	68 79 22 80 00       	push   $0x802279
  801893:	e8 40 ea ff ff       	call   8002d8 <vcprintf>
  801898:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80189b:	e8 c1 e9 ff ff       	call   800261 <exit>

	// should not return here
	while (1) ;
  8018a0:	eb fe                	jmp    8018a0 <_panic+0x70>

008018a2 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8018a8:	a1 04 30 80 00       	mov    0x803004,%eax
  8018ad:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b6:	39 c2                	cmp    %eax,%edx
  8018b8:	74 14                	je     8018ce <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	68 7c 22 80 00       	push   $0x80227c
  8018c2:	6a 26                	push   $0x26
  8018c4:	68 c8 22 80 00       	push   $0x8022c8
  8018c9:	e8 62 ff ff ff       	call   801830 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8018ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8018d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8018dc:	e9 c5 00 00 00       	jmp    8019a6 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8018e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	01 d0                	add    %edx,%eax
  8018f0:	8b 00                	mov    (%eax),%eax
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	75 08                	jne    8018fe <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018f6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018f9:	e9 a5 00 00 00       	jmp    8019a3 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8018fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801905:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80190c:	eb 69                	jmp    801977 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80190e:	a1 04 30 80 00       	mov    0x803004,%eax
  801913:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801919:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80191c:	89 d0                	mov    %edx,%eax
  80191e:	01 c0                	add    %eax,%eax
  801920:	01 d0                	add    %edx,%eax
  801922:	c1 e0 03             	shl    $0x3,%eax
  801925:	01 c8                	add    %ecx,%eax
  801927:	8a 40 04             	mov    0x4(%eax),%al
  80192a:	84 c0                	test   %al,%al
  80192c:	75 46                	jne    801974 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80192e:	a1 04 30 80 00       	mov    0x803004,%eax
  801933:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801939:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80193c:	89 d0                	mov    %edx,%eax
  80193e:	01 c0                	add    %eax,%eax
  801940:	01 d0                	add    %edx,%eax
  801942:	c1 e0 03             	shl    $0x3,%eax
  801945:	01 c8                	add    %ecx,%eax
  801947:	8b 00                	mov    (%eax),%eax
  801949:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80194c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80194f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801954:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801959:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	01 c8                	add    %ecx,%eax
  801965:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801967:	39 c2                	cmp    %eax,%edx
  801969:	75 09                	jne    801974 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80196b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801972:	eb 15                	jmp    801989 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801974:	ff 45 e8             	incl   -0x18(%ebp)
  801977:	a1 04 30 80 00       	mov    0x803004,%eax
  80197c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801982:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801985:	39 c2                	cmp    %eax,%edx
  801987:	77 85                	ja     80190e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801989:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80198d:	75 14                	jne    8019a3 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80198f:	83 ec 04             	sub    $0x4,%esp
  801992:	68 d4 22 80 00       	push   $0x8022d4
  801997:	6a 3a                	push   $0x3a
  801999:	68 c8 22 80 00       	push   $0x8022c8
  80199e:	e8 8d fe ff ff       	call   801830 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8019a3:	ff 45 f0             	incl   -0x10(%ebp)
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8019ac:	0f 8c 2f ff ff ff    	jl     8018e1 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8019b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019c0:	eb 26                	jmp    8019e8 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8019c2:	a1 04 30 80 00       	mov    0x803004,%eax
  8019c7:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8019cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019d0:	89 d0                	mov    %edx,%eax
  8019d2:	01 c0                	add    %eax,%eax
  8019d4:	01 d0                	add    %edx,%eax
  8019d6:	c1 e0 03             	shl    $0x3,%eax
  8019d9:	01 c8                	add    %ecx,%eax
  8019db:	8a 40 04             	mov    0x4(%eax),%al
  8019de:	3c 01                	cmp    $0x1,%al
  8019e0:	75 03                	jne    8019e5 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019e2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019e5:	ff 45 e0             	incl   -0x20(%ebp)
  8019e8:	a1 04 30 80 00       	mov    0x803004,%eax
  8019ed:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019f6:	39 c2                	cmp    %eax,%edx
  8019f8:	77 c8                	ja     8019c2 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a00:	74 14                	je     801a16 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	68 28 23 80 00       	push   $0x802328
  801a0a:	6a 44                	push   $0x44
  801a0c:	68 c8 22 80 00       	push   $0x8022c8
  801a11:	e8 1a fe ff ff       	call   801830 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a16:	90                   	nop
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    
  801a19:	66 90                	xchg   %ax,%ax
  801a1b:	90                   	nop

00801a1c <__udivdi3>:
  801a1c:	55                   	push   %ebp
  801a1d:	57                   	push   %edi
  801a1e:	56                   	push   %esi
  801a1f:	53                   	push   %ebx
  801a20:	83 ec 1c             	sub    $0x1c,%esp
  801a23:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a27:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a33:	89 ca                	mov    %ecx,%edx
  801a35:	89 f8                	mov    %edi,%eax
  801a37:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a3b:	85 f6                	test   %esi,%esi
  801a3d:	75 2d                	jne    801a6c <__udivdi3+0x50>
  801a3f:	39 cf                	cmp    %ecx,%edi
  801a41:	77 65                	ja     801aa8 <__udivdi3+0x8c>
  801a43:	89 fd                	mov    %edi,%ebp
  801a45:	85 ff                	test   %edi,%edi
  801a47:	75 0b                	jne    801a54 <__udivdi3+0x38>
  801a49:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4e:	31 d2                	xor    %edx,%edx
  801a50:	f7 f7                	div    %edi
  801a52:	89 c5                	mov    %eax,%ebp
  801a54:	31 d2                	xor    %edx,%edx
  801a56:	89 c8                	mov    %ecx,%eax
  801a58:	f7 f5                	div    %ebp
  801a5a:	89 c1                	mov    %eax,%ecx
  801a5c:	89 d8                	mov    %ebx,%eax
  801a5e:	f7 f5                	div    %ebp
  801a60:	89 cf                	mov    %ecx,%edi
  801a62:	89 fa                	mov    %edi,%edx
  801a64:	83 c4 1c             	add    $0x1c,%esp
  801a67:	5b                   	pop    %ebx
  801a68:	5e                   	pop    %esi
  801a69:	5f                   	pop    %edi
  801a6a:	5d                   	pop    %ebp
  801a6b:	c3                   	ret    
  801a6c:	39 ce                	cmp    %ecx,%esi
  801a6e:	77 28                	ja     801a98 <__udivdi3+0x7c>
  801a70:	0f bd fe             	bsr    %esi,%edi
  801a73:	83 f7 1f             	xor    $0x1f,%edi
  801a76:	75 40                	jne    801ab8 <__udivdi3+0x9c>
  801a78:	39 ce                	cmp    %ecx,%esi
  801a7a:	72 0a                	jb     801a86 <__udivdi3+0x6a>
  801a7c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a80:	0f 87 9e 00 00 00    	ja     801b24 <__udivdi3+0x108>
  801a86:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8b:	89 fa                	mov    %edi,%edx
  801a8d:	83 c4 1c             	add    $0x1c,%esp
  801a90:	5b                   	pop    %ebx
  801a91:	5e                   	pop    %esi
  801a92:	5f                   	pop    %edi
  801a93:	5d                   	pop    %ebp
  801a94:	c3                   	ret    
  801a95:	8d 76 00             	lea    0x0(%esi),%esi
  801a98:	31 ff                	xor    %edi,%edi
  801a9a:	31 c0                	xor    %eax,%eax
  801a9c:	89 fa                	mov    %edi,%edx
  801a9e:	83 c4 1c             	add    $0x1c,%esp
  801aa1:	5b                   	pop    %ebx
  801aa2:	5e                   	pop    %esi
  801aa3:	5f                   	pop    %edi
  801aa4:	5d                   	pop    %ebp
  801aa5:	c3                   	ret    
  801aa6:	66 90                	xchg   %ax,%ax
  801aa8:	89 d8                	mov    %ebx,%eax
  801aaa:	f7 f7                	div    %edi
  801aac:	31 ff                	xor    %edi,%edi
  801aae:	89 fa                	mov    %edi,%edx
  801ab0:	83 c4 1c             	add    $0x1c,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5f                   	pop    %edi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
  801ab8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801abd:	89 eb                	mov    %ebp,%ebx
  801abf:	29 fb                	sub    %edi,%ebx
  801ac1:	89 f9                	mov    %edi,%ecx
  801ac3:	d3 e6                	shl    %cl,%esi
  801ac5:	89 c5                	mov    %eax,%ebp
  801ac7:	88 d9                	mov    %bl,%cl
  801ac9:	d3 ed                	shr    %cl,%ebp
  801acb:	89 e9                	mov    %ebp,%ecx
  801acd:	09 f1                	or     %esi,%ecx
  801acf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ad3:	89 f9                	mov    %edi,%ecx
  801ad5:	d3 e0                	shl    %cl,%eax
  801ad7:	89 c5                	mov    %eax,%ebp
  801ad9:	89 d6                	mov    %edx,%esi
  801adb:	88 d9                	mov    %bl,%cl
  801add:	d3 ee                	shr    %cl,%esi
  801adf:	89 f9                	mov    %edi,%ecx
  801ae1:	d3 e2                	shl    %cl,%edx
  801ae3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ae7:	88 d9                	mov    %bl,%cl
  801ae9:	d3 e8                	shr    %cl,%eax
  801aeb:	09 c2                	or     %eax,%edx
  801aed:	89 d0                	mov    %edx,%eax
  801aef:	89 f2                	mov    %esi,%edx
  801af1:	f7 74 24 0c          	divl   0xc(%esp)
  801af5:	89 d6                	mov    %edx,%esi
  801af7:	89 c3                	mov    %eax,%ebx
  801af9:	f7 e5                	mul    %ebp
  801afb:	39 d6                	cmp    %edx,%esi
  801afd:	72 19                	jb     801b18 <__udivdi3+0xfc>
  801aff:	74 0b                	je     801b0c <__udivdi3+0xf0>
  801b01:	89 d8                	mov    %ebx,%eax
  801b03:	31 ff                	xor    %edi,%edi
  801b05:	e9 58 ff ff ff       	jmp    801a62 <__udivdi3+0x46>
  801b0a:	66 90                	xchg   %ax,%ax
  801b0c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b10:	89 f9                	mov    %edi,%ecx
  801b12:	d3 e2                	shl    %cl,%edx
  801b14:	39 c2                	cmp    %eax,%edx
  801b16:	73 e9                	jae    801b01 <__udivdi3+0xe5>
  801b18:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b1b:	31 ff                	xor    %edi,%edi
  801b1d:	e9 40 ff ff ff       	jmp    801a62 <__udivdi3+0x46>
  801b22:	66 90                	xchg   %ax,%ax
  801b24:	31 c0                	xor    %eax,%eax
  801b26:	e9 37 ff ff ff       	jmp    801a62 <__udivdi3+0x46>
  801b2b:	90                   	nop

00801b2c <__umoddi3>:
  801b2c:	55                   	push   %ebp
  801b2d:	57                   	push   %edi
  801b2e:	56                   	push   %esi
  801b2f:	53                   	push   %ebx
  801b30:	83 ec 1c             	sub    $0x1c,%esp
  801b33:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b37:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b3b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b3f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b47:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b4b:	89 f3                	mov    %esi,%ebx
  801b4d:	89 fa                	mov    %edi,%edx
  801b4f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b53:	89 34 24             	mov    %esi,(%esp)
  801b56:	85 c0                	test   %eax,%eax
  801b58:	75 1a                	jne    801b74 <__umoddi3+0x48>
  801b5a:	39 f7                	cmp    %esi,%edi
  801b5c:	0f 86 a2 00 00 00    	jbe    801c04 <__umoddi3+0xd8>
  801b62:	89 c8                	mov    %ecx,%eax
  801b64:	89 f2                	mov    %esi,%edx
  801b66:	f7 f7                	div    %edi
  801b68:	89 d0                	mov    %edx,%eax
  801b6a:	31 d2                	xor    %edx,%edx
  801b6c:	83 c4 1c             	add    $0x1c,%esp
  801b6f:	5b                   	pop    %ebx
  801b70:	5e                   	pop    %esi
  801b71:	5f                   	pop    %edi
  801b72:	5d                   	pop    %ebp
  801b73:	c3                   	ret    
  801b74:	39 f0                	cmp    %esi,%eax
  801b76:	0f 87 ac 00 00 00    	ja     801c28 <__umoddi3+0xfc>
  801b7c:	0f bd e8             	bsr    %eax,%ebp
  801b7f:	83 f5 1f             	xor    $0x1f,%ebp
  801b82:	0f 84 ac 00 00 00    	je     801c34 <__umoddi3+0x108>
  801b88:	bf 20 00 00 00       	mov    $0x20,%edi
  801b8d:	29 ef                	sub    %ebp,%edi
  801b8f:	89 fe                	mov    %edi,%esi
  801b91:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b95:	89 e9                	mov    %ebp,%ecx
  801b97:	d3 e0                	shl    %cl,%eax
  801b99:	89 d7                	mov    %edx,%edi
  801b9b:	89 f1                	mov    %esi,%ecx
  801b9d:	d3 ef                	shr    %cl,%edi
  801b9f:	09 c7                	or     %eax,%edi
  801ba1:	89 e9                	mov    %ebp,%ecx
  801ba3:	d3 e2                	shl    %cl,%edx
  801ba5:	89 14 24             	mov    %edx,(%esp)
  801ba8:	89 d8                	mov    %ebx,%eax
  801baa:	d3 e0                	shl    %cl,%eax
  801bac:	89 c2                	mov    %eax,%edx
  801bae:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bb2:	d3 e0                	shl    %cl,%eax
  801bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bbc:	89 f1                	mov    %esi,%ecx
  801bbe:	d3 e8                	shr    %cl,%eax
  801bc0:	09 d0                	or     %edx,%eax
  801bc2:	d3 eb                	shr    %cl,%ebx
  801bc4:	89 da                	mov    %ebx,%edx
  801bc6:	f7 f7                	div    %edi
  801bc8:	89 d3                	mov    %edx,%ebx
  801bca:	f7 24 24             	mull   (%esp)
  801bcd:	89 c6                	mov    %eax,%esi
  801bcf:	89 d1                	mov    %edx,%ecx
  801bd1:	39 d3                	cmp    %edx,%ebx
  801bd3:	0f 82 87 00 00 00    	jb     801c60 <__umoddi3+0x134>
  801bd9:	0f 84 91 00 00 00    	je     801c70 <__umoddi3+0x144>
  801bdf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801be3:	29 f2                	sub    %esi,%edx
  801be5:	19 cb                	sbb    %ecx,%ebx
  801be7:	89 d8                	mov    %ebx,%eax
  801be9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801bed:	d3 e0                	shl    %cl,%eax
  801bef:	89 e9                	mov    %ebp,%ecx
  801bf1:	d3 ea                	shr    %cl,%edx
  801bf3:	09 d0                	or     %edx,%eax
  801bf5:	89 e9                	mov    %ebp,%ecx
  801bf7:	d3 eb                	shr    %cl,%ebx
  801bf9:	89 da                	mov    %ebx,%edx
  801bfb:	83 c4 1c             	add    $0x1c,%esp
  801bfe:	5b                   	pop    %ebx
  801bff:	5e                   	pop    %esi
  801c00:	5f                   	pop    %edi
  801c01:	5d                   	pop    %ebp
  801c02:	c3                   	ret    
  801c03:	90                   	nop
  801c04:	89 fd                	mov    %edi,%ebp
  801c06:	85 ff                	test   %edi,%edi
  801c08:	75 0b                	jne    801c15 <__umoddi3+0xe9>
  801c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0f:	31 d2                	xor    %edx,%edx
  801c11:	f7 f7                	div    %edi
  801c13:	89 c5                	mov    %eax,%ebp
  801c15:	89 f0                	mov    %esi,%eax
  801c17:	31 d2                	xor    %edx,%edx
  801c19:	f7 f5                	div    %ebp
  801c1b:	89 c8                	mov    %ecx,%eax
  801c1d:	f7 f5                	div    %ebp
  801c1f:	89 d0                	mov    %edx,%eax
  801c21:	e9 44 ff ff ff       	jmp    801b6a <__umoddi3+0x3e>
  801c26:	66 90                	xchg   %ax,%ax
  801c28:	89 c8                	mov    %ecx,%eax
  801c2a:	89 f2                	mov    %esi,%edx
  801c2c:	83 c4 1c             	add    $0x1c,%esp
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	5f                   	pop    %edi
  801c32:	5d                   	pop    %ebp
  801c33:	c3                   	ret    
  801c34:	3b 04 24             	cmp    (%esp),%eax
  801c37:	72 06                	jb     801c3f <__umoddi3+0x113>
  801c39:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c3d:	77 0f                	ja     801c4e <__umoddi3+0x122>
  801c3f:	89 f2                	mov    %esi,%edx
  801c41:	29 f9                	sub    %edi,%ecx
  801c43:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c47:	89 14 24             	mov    %edx,(%esp)
  801c4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c4e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c52:	8b 14 24             	mov    (%esp),%edx
  801c55:	83 c4 1c             	add    $0x1c,%esp
  801c58:	5b                   	pop    %ebx
  801c59:	5e                   	pop    %esi
  801c5a:	5f                   	pop    %edi
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    
  801c5d:	8d 76 00             	lea    0x0(%esi),%esi
  801c60:	2b 04 24             	sub    (%esp),%eax
  801c63:	19 fa                	sbb    %edi,%edx
  801c65:	89 d1                	mov    %edx,%ecx
  801c67:	89 c6                	mov    %eax,%esi
  801c69:	e9 71 ff ff ff       	jmp    801bdf <__umoddi3+0xb3>
  801c6e:	66 90                	xchg   %ax,%ax
  801c70:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c74:	72 ea                	jb     801c60 <__umoddi3+0x134>
  801c76:	89 d9                	mov    %ebx,%ecx
  801c78:	e9 62 ff ff ff       	jmp    801bdf <__umoddi3+0xb3>
