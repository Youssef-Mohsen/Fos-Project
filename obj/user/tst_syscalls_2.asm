
obj/user/tst_syscalls_2:     file format elf32-i386


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
  800031:	e8 fb 00 00 00       	call   800131 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the correct validation of system call params
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	rsttst();
  80003e:	e8 62 14 00 00       	call   8014a5 <rsttst>
	int ID1 = sys_create_env("tsc2_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800043:	a1 04 30 80 00       	mov    0x803004,%eax
  800048:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  80004e:	a1 04 30 80 00       	mov    0x803004,%eax
  800053:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800059:	89 c1                	mov    %eax,%ecx
  80005b:	a1 04 30 80 00       	mov    0x803004,%eax
  800060:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800066:	52                   	push   %edx
  800067:	51                   	push   %ecx
  800068:	50                   	push   %eax
  800069:	68 c0 1c 80 00       	push   $0x801cc0
  80006e:	e8 e6 12 00 00       	call   801359 <sys_create_env>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_run_env(ID1);
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	e8 f3 12 00 00       	call   801377 <sys_run_env>
  800084:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tsc2_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800087:	a1 04 30 80 00       	mov    0x803004,%eax
  80008c:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800092:	a1 04 30 80 00       	mov    0x803004,%eax
  800097:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80009d:	89 c1                	mov    %eax,%ecx
  80009f:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000aa:	52                   	push   %edx
  8000ab:	51                   	push   %ecx
  8000ac:	50                   	push   %eax
  8000ad:	68 cc 1c 80 00       	push   $0x801ccc
  8000b2:	e8 a2 12 00 00       	call   801359 <sys_create_env>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	sys_run_env(ID2);

	int ID3 = sys_create_env("tsc2_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000bd:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c2:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  8000c8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000cd:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8000d3:	89 c1                	mov    %eax,%ecx
  8000d5:	a1 04 30 80 00       	mov    0x803004,%eax
  8000da:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000e0:	52                   	push   %edx
  8000e1:	51                   	push   %ecx
  8000e2:	50                   	push   %eax
  8000e3:	68 d8 1c 80 00       	push   $0x801cd8
  8000e8:	e8 6c 12 00 00       	call   801359 <sys_create_env>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
//	sys_run_env(ID3);
	env_sleep(10000);
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 10 27 00 00       	push   $0x2710
  8000fb:	e8 a3 16 00 00       	call   8017a3 <env_sleep>
  800100:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  800103:	e8 17 14 00 00       	call   80151f <gettst>
  800108:	85 c0                	test   %eax,%eax
  80010a:	74 12                	je     80011e <_main+0xe6>
		cprintf("\ntst_syscalls_2 Failed.\n");
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	68 e4 1c 80 00       	push   $0x801ce4
  800114:	e8 2b 02 00 00       	call   800344 <cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nCongratulations... tst system calls #2 completed successfully\n");

}
  80011c:	eb 10                	jmp    80012e <_main+0xf6>
	env_sleep(10000);

	if (gettst() != 0)
		cprintf("\ntst_syscalls_2 Failed.\n");
	else
		cprintf("\nCongratulations... tst system calls #2 completed successfully\n");
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 00 1d 80 00       	push   $0x801d00
  800126:	e8 19 02 00 00       	call   800344 <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp

}
  80012e:	90                   	nop
  80012f:	c9                   	leave  
  800130:	c3                   	ret    

00800131 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800131:	55                   	push   %ebp
  800132:	89 e5                	mov    %esp,%ebp
  800134:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800137:	e8 8b 12 00 00       	call   8013c7 <sys_getenvindex>
  80013c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800142:	89 d0                	mov    %edx,%eax
  800144:	c1 e0 03             	shl    $0x3,%eax
  800147:	01 d0                	add    %edx,%eax
  800149:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800150:	01 c8                	add    %ecx,%eax
  800152:	01 c0                	add    %eax,%eax
  800154:	01 d0                	add    %edx,%eax
  800156:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80015d:	01 c8                	add    %ecx,%eax
  80015f:	01 d0                	add    %edx,%eax
  800161:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800166:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016b:	a1 04 30 80 00       	mov    0x803004,%eax
  800170:	8a 40 20             	mov    0x20(%eax),%al
  800173:	84 c0                	test   %al,%al
  800175:	74 0d                	je     800184 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800177:	a1 04 30 80 00       	mov    0x803004,%eax
  80017c:	83 c0 20             	add    $0x20,%eax
  80017f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800184:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800188:	7e 0a                	jle    800194 <libmain+0x63>
		binaryname = argv[0];
  80018a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018d:	8b 00                	mov    (%eax),%eax
  80018f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800194:	83 ec 08             	sub    $0x8,%esp
  800197:	ff 75 0c             	pushl  0xc(%ebp)
  80019a:	ff 75 08             	pushl  0x8(%ebp)
  80019d:	e8 96 fe ff ff       	call   800038 <_main>
  8001a2:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001a5:	e8 a1 0f 00 00       	call   80114b <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	68 58 1d 80 00       	push   $0x801d58
  8001b2:	e8 8d 01 00 00       	call   800344 <cprintf>
  8001b7:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001ba:	a1 04 30 80 00       	mov    0x803004,%eax
  8001bf:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001c5:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ca:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	52                   	push   %edx
  8001d4:	50                   	push   %eax
  8001d5:	68 80 1d 80 00       	push   $0x801d80
  8001da:	e8 65 01 00 00       	call   800344 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e2:	a1 04 30 80 00       	mov    0x803004,%eax
  8001e7:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8001ed:	a1 04 30 80 00       	mov    0x803004,%eax
  8001f2:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8001f8:	a1 04 30 80 00       	mov    0x803004,%eax
  8001fd:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800203:	51                   	push   %ecx
  800204:	52                   	push   %edx
  800205:	50                   	push   %eax
  800206:	68 a8 1d 80 00       	push   $0x801da8
  80020b:	e8 34 01 00 00       	call   800344 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800213:	a1 04 30 80 00       	mov    0x803004,%eax
  800218:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  80021e:	83 ec 08             	sub    $0x8,%esp
  800221:	50                   	push   %eax
  800222:	68 00 1e 80 00       	push   $0x801e00
  800227:	e8 18 01 00 00       	call   800344 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80022f:	83 ec 0c             	sub    $0xc,%esp
  800232:	68 58 1d 80 00       	push   $0x801d58
  800237:	e8 08 01 00 00       	call   800344 <cprintf>
  80023c:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80023f:	e8 21 0f 00 00       	call   801165 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800244:	e8 19 00 00 00       	call   800262 <exit>
}
  800249:	90                   	nop
  80024a:	c9                   	leave  
  80024b:	c3                   	ret    

0080024c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800252:	83 ec 0c             	sub    $0xc,%esp
  800255:	6a 00                	push   $0x0
  800257:	e8 37 11 00 00       	call   801393 <sys_destroy_env>
  80025c:	83 c4 10             	add    $0x10,%esp
}
  80025f:	90                   	nop
  800260:	c9                   	leave  
  800261:	c3                   	ret    

00800262 <exit>:

void
exit(void)
{
  800262:	55                   	push   %ebp
  800263:	89 e5                	mov    %esp,%ebp
  800265:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800268:	e8 8c 11 00 00       	call   8013f9 <sys_exit_env>
}
  80026d:	90                   	nop
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800276:	8b 45 0c             	mov    0xc(%ebp),%eax
  800279:	8b 00                	mov    (%eax),%eax
  80027b:	8d 48 01             	lea    0x1(%eax),%ecx
  80027e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800281:	89 0a                	mov    %ecx,(%edx)
  800283:	8b 55 08             	mov    0x8(%ebp),%edx
  800286:	88 d1                	mov    %dl,%cl
  800288:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80028f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	3d ff 00 00 00       	cmp    $0xff,%eax
  800299:	75 2c                	jne    8002c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80029b:	a0 08 30 80 00       	mov    0x803008,%al
  8002a0:	0f b6 c0             	movzbl %al,%eax
  8002a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a6:	8b 12                	mov    (%edx),%edx
  8002a8:	89 d1                	mov    %edx,%ecx
  8002aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ad:	83 c2 08             	add    $0x8,%edx
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	50                   	push   %eax
  8002b4:	51                   	push   %ecx
  8002b5:	52                   	push   %edx
  8002b6:	e8 4e 0e 00 00       	call   801109 <sys_cputs>
  8002bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ca:	8b 40 04             	mov    0x4(%eax),%eax
  8002cd:	8d 50 01             	lea    0x1(%eax),%edx
  8002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002d6:	90                   	nop
  8002d7:	c9                   	leave  
  8002d8:	c3                   	ret    

008002d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e9:	00 00 00 
	b.cnt = 0;
  8002ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002f6:	ff 75 0c             	pushl  0xc(%ebp)
  8002f9:	ff 75 08             	pushl  0x8(%ebp)
  8002fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800302:	50                   	push   %eax
  800303:	68 70 02 80 00       	push   $0x800270
  800308:	e8 11 02 00 00       	call   80051e <vprintfmt>
  80030d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800310:	a0 08 30 80 00       	mov    0x803008,%al
  800315:	0f b6 c0             	movzbl %al,%eax
  800318:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	50                   	push   %eax
  800322:	52                   	push   %edx
  800323:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800329:	83 c0 08             	add    $0x8,%eax
  80032c:	50                   	push   %eax
  80032d:	e8 d7 0d 00 00       	call   801109 <sys_cputs>
  800332:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800335:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80033c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800342:	c9                   	leave  
  800343:	c3                   	ret    

00800344 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80034a:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800351:	8d 45 0c             	lea    0xc(%ebp),%eax
  800354:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800357:	8b 45 08             	mov    0x8(%ebp),%eax
  80035a:	83 ec 08             	sub    $0x8,%esp
  80035d:	ff 75 f4             	pushl  -0xc(%ebp)
  800360:	50                   	push   %eax
  800361:	e8 73 ff ff ff       	call   8002d9 <vcprintf>
  800366:	83 c4 10             	add    $0x10,%esp
  800369:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80036c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80036f:	c9                   	leave  
  800370:	c3                   	ret    

00800371 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
  800374:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800377:	e8 cf 0d 00 00       	call   80114b <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80037c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80037f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800382:	8b 45 08             	mov    0x8(%ebp),%eax
  800385:	83 ec 08             	sub    $0x8,%esp
  800388:	ff 75 f4             	pushl  -0xc(%ebp)
  80038b:	50                   	push   %eax
  80038c:	e8 48 ff ff ff       	call   8002d9 <vcprintf>
  800391:	83 c4 10             	add    $0x10,%esp
  800394:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800397:	e8 c9 0d 00 00       	call   801165 <sys_unlock_cons>
	return cnt;
  80039c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80039f:	c9                   	leave  
  8003a0:	c3                   	ret    

008003a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	53                   	push   %ebx
  8003a5:	83 ec 14             	sub    $0x14,%esp
  8003a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003bf:	77 55                	ja     800416 <printnum+0x75>
  8003c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c4:	72 05                	jb     8003cb <printnum+0x2a>
  8003c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003c9:	77 4b                	ja     800416 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d9:	52                   	push   %edx
  8003da:	50                   	push   %eax
  8003db:	ff 75 f4             	pushl  -0xc(%ebp)
  8003de:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e1:	e8 5a 16 00 00       	call   801a40 <__udivdi3>
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	ff 75 20             	pushl  0x20(%ebp)
  8003ef:	53                   	push   %ebx
  8003f0:	ff 75 18             	pushl  0x18(%ebp)
  8003f3:	52                   	push   %edx
  8003f4:	50                   	push   %eax
  8003f5:	ff 75 0c             	pushl  0xc(%ebp)
  8003f8:	ff 75 08             	pushl  0x8(%ebp)
  8003fb:	e8 a1 ff ff ff       	call   8003a1 <printnum>
  800400:	83 c4 20             	add    $0x20,%esp
  800403:	eb 1a                	jmp    80041f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	ff 75 0c             	pushl  0xc(%ebp)
  80040b:	ff 75 20             	pushl  0x20(%ebp)
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	ff d0                	call   *%eax
  800413:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800416:	ff 4d 1c             	decl   0x1c(%ebp)
  800419:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80041d:	7f e6                	jg     800405 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80041f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800422:	bb 00 00 00 00       	mov    $0x0,%ebx
  800427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80042d:	53                   	push   %ebx
  80042e:	51                   	push   %ecx
  80042f:	52                   	push   %edx
  800430:	50                   	push   %eax
  800431:	e8 1a 17 00 00       	call   801b50 <__umoddi3>
  800436:	83 c4 10             	add    $0x10,%esp
  800439:	05 34 20 80 00       	add    $0x802034,%eax
  80043e:	8a 00                	mov    (%eax),%al
  800440:	0f be c0             	movsbl %al,%eax
  800443:	83 ec 08             	sub    $0x8,%esp
  800446:	ff 75 0c             	pushl  0xc(%ebp)
  800449:	50                   	push   %eax
  80044a:	8b 45 08             	mov    0x8(%ebp),%eax
  80044d:	ff d0                	call   *%eax
  80044f:	83 c4 10             	add    $0x10,%esp
}
  800452:	90                   	nop
  800453:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80045f:	7e 1c                	jle    80047d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	8d 50 08             	lea    0x8(%eax),%edx
  800469:	8b 45 08             	mov    0x8(%ebp),%eax
  80046c:	89 10                	mov    %edx,(%eax)
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	83 e8 08             	sub    $0x8,%eax
  800476:	8b 50 04             	mov    0x4(%eax),%edx
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	eb 40                	jmp    8004bd <getuint+0x65>
	else if (lflag)
  80047d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800481:	74 1e                	je     8004a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	8d 50 04             	lea    0x4(%eax),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	89 10                	mov    %edx,(%eax)
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	83 e8 04             	sub    $0x4,%eax
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	ba 00 00 00 00       	mov    $0x0,%edx
  80049f:	eb 1c                	jmp    8004bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	8d 50 04             	lea    0x4(%eax),%edx
  8004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ac:	89 10                	mov    %edx,(%eax)
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	83 e8 04             	sub    $0x4,%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004bd:	5d                   	pop    %ebp
  8004be:	c3                   	ret    

008004bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004bf:	55                   	push   %ebp
  8004c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004c6:	7e 1c                	jle    8004e4 <getint+0x25>
		return va_arg(*ap, long long);
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	8d 50 08             	lea    0x8(%eax),%edx
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	89 10                	mov    %edx,(%eax)
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	83 e8 08             	sub    $0x8,%eax
  8004dd:	8b 50 04             	mov    0x4(%eax),%edx
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	eb 38                	jmp    80051c <getint+0x5d>
	else if (lflag)
  8004e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004e8:	74 1a                	je     800504 <getint+0x45>
		return va_arg(*ap, long);
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	8d 50 04             	lea    0x4(%eax),%edx
  8004f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f5:	89 10                	mov    %edx,(%eax)
  8004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	83 e8 04             	sub    $0x4,%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	99                   	cltd   
  800502:	eb 18                	jmp    80051c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 50 04             	lea    0x4(%eax),%edx
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	89 10                	mov    %edx,(%eax)
  800511:	8b 45 08             	mov    0x8(%ebp),%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	83 e8 04             	sub    $0x4,%eax
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	99                   	cltd   
}
  80051c:	5d                   	pop    %ebp
  80051d:	c3                   	ret    

0080051e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	56                   	push   %esi
  800522:	53                   	push   %ebx
  800523:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800526:	eb 17                	jmp    80053f <vprintfmt+0x21>
			if (ch == '\0')
  800528:	85 db                	test   %ebx,%ebx
  80052a:	0f 84 c1 03 00 00    	je     8008f1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	ff 75 0c             	pushl  0xc(%ebp)
  800536:	53                   	push   %ebx
  800537:	8b 45 08             	mov    0x8(%ebp),%eax
  80053a:	ff d0                	call   *%eax
  80053c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80053f:	8b 45 10             	mov    0x10(%ebp),%eax
  800542:	8d 50 01             	lea    0x1(%eax),%edx
  800545:	89 55 10             	mov    %edx,0x10(%ebp)
  800548:	8a 00                	mov    (%eax),%al
  80054a:	0f b6 d8             	movzbl %al,%ebx
  80054d:	83 fb 25             	cmp    $0x25,%ebx
  800550:	75 d6                	jne    800528 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800552:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800556:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80055d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800564:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80056b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800572:	8b 45 10             	mov    0x10(%ebp),%eax
  800575:	8d 50 01             	lea    0x1(%eax),%edx
  800578:	89 55 10             	mov    %edx,0x10(%ebp)
  80057b:	8a 00                	mov    (%eax),%al
  80057d:	0f b6 d8             	movzbl %al,%ebx
  800580:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800583:	83 f8 5b             	cmp    $0x5b,%eax
  800586:	0f 87 3d 03 00 00    	ja     8008c9 <vprintfmt+0x3ab>
  80058c:	8b 04 85 58 20 80 00 	mov    0x802058(,%eax,4),%eax
  800593:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800595:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800599:	eb d7                	jmp    800572 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80059f:	eb d1                	jmp    800572 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005ab:	89 d0                	mov    %edx,%eax
  8005ad:	c1 e0 02             	shl    $0x2,%eax
  8005b0:	01 d0                	add    %edx,%eax
  8005b2:	01 c0                	add    %eax,%eax
  8005b4:	01 d8                	add    %ebx,%eax
  8005b6:	83 e8 30             	sub    $0x30,%eax
  8005b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005bf:	8a 00                	mov    (%eax),%al
  8005c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8005c7:	7e 3e                	jle    800607 <vprintfmt+0xe9>
  8005c9:	83 fb 39             	cmp    $0x39,%ebx
  8005cc:	7f 39                	jg     800607 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d1:	eb d5                	jmp    8005a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	83 c0 04             	add    $0x4,%eax
  8005d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	83 e8 04             	sub    $0x4,%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005e7:	eb 1f                	jmp    800608 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ed:	79 83                	jns    800572 <vprintfmt+0x54>
				width = 0;
  8005ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005f6:	e9 77 ff ff ff       	jmp    800572 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800602:	e9 6b ff ff ff       	jmp    800572 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800607:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800608:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80060c:	0f 89 60 ff ff ff    	jns    800572 <vprintfmt+0x54>
				width = precision, precision = -1;
  800612:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800615:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800618:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80061f:	e9 4e ff ff ff       	jmp    800572 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800624:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800627:	e9 46 ff ff ff       	jmp    800572 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	83 c0 04             	add    $0x4,%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	83 e8 04             	sub    $0x4,%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 0c             	pushl  0xc(%ebp)
  800643:	50                   	push   %eax
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	ff d0                	call   *%eax
  800649:	83 c4 10             	add    $0x10,%esp
			break;
  80064c:	e9 9b 02 00 00       	jmp    8008ec <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	83 c0 04             	add    $0x4,%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	83 e8 04             	sub    $0x4,%eax
  800660:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800662:	85 db                	test   %ebx,%ebx
  800664:	79 02                	jns    800668 <vprintfmt+0x14a>
				err = -err;
  800666:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800668:	83 fb 64             	cmp    $0x64,%ebx
  80066b:	7f 0b                	jg     800678 <vprintfmt+0x15a>
  80066d:	8b 34 9d a0 1e 80 00 	mov    0x801ea0(,%ebx,4),%esi
  800674:	85 f6                	test   %esi,%esi
  800676:	75 19                	jne    800691 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800678:	53                   	push   %ebx
  800679:	68 45 20 80 00       	push   $0x802045
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	ff 75 08             	pushl  0x8(%ebp)
  800684:	e8 70 02 00 00       	call   8008f9 <printfmt>
  800689:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80068c:	e9 5b 02 00 00       	jmp    8008ec <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800691:	56                   	push   %esi
  800692:	68 4e 20 80 00       	push   $0x80204e
  800697:	ff 75 0c             	pushl  0xc(%ebp)
  80069a:	ff 75 08             	pushl  0x8(%ebp)
  80069d:	e8 57 02 00 00       	call   8008f9 <printfmt>
  8006a2:	83 c4 10             	add    $0x10,%esp
			break;
  8006a5:	e9 42 02 00 00       	jmp    8008ec <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	83 c0 04             	add    $0x4,%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	83 e8 04             	sub    $0x4,%eax
  8006b9:	8b 30                	mov    (%eax),%esi
  8006bb:	85 f6                	test   %esi,%esi
  8006bd:	75 05                	jne    8006c4 <vprintfmt+0x1a6>
				p = "(null)";
  8006bf:	be 51 20 80 00       	mov    $0x802051,%esi
			if (width > 0 && padc != '-')
  8006c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c8:	7e 6d                	jle    800737 <vprintfmt+0x219>
  8006ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006ce:	74 67                	je     800737 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	50                   	push   %eax
  8006d7:	56                   	push   %esi
  8006d8:	e8 1e 03 00 00       	call   8009fb <strnlen>
  8006dd:	83 c4 10             	add    $0x10,%esp
  8006e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e3:	eb 16                	jmp    8006fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	ff 75 0c             	pushl  0xc(%ebp)
  8006ef:	50                   	push   %eax
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	ff d0                	call   *%eax
  8006f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8006fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ff:	7f e4                	jg     8006e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800701:	eb 34                	jmp    800737 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800703:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800707:	74 1c                	je     800725 <vprintfmt+0x207>
  800709:	83 fb 1f             	cmp    $0x1f,%ebx
  80070c:	7e 05                	jle    800713 <vprintfmt+0x1f5>
  80070e:	83 fb 7e             	cmp    $0x7e,%ebx
  800711:	7e 12                	jle    800725 <vprintfmt+0x207>
					putch('?', putdat);
  800713:	83 ec 08             	sub    $0x8,%esp
  800716:	ff 75 0c             	pushl  0xc(%ebp)
  800719:	6a 3f                	push   $0x3f
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	ff d0                	call   *%eax
  800720:	83 c4 10             	add    $0x10,%esp
  800723:	eb 0f                	jmp    800734 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	ff 75 0c             	pushl  0xc(%ebp)
  80072b:	53                   	push   %ebx
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	ff d0                	call   *%eax
  800731:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800734:	ff 4d e4             	decl   -0x1c(%ebp)
  800737:	89 f0                	mov    %esi,%eax
  800739:	8d 70 01             	lea    0x1(%eax),%esi
  80073c:	8a 00                	mov    (%eax),%al
  80073e:	0f be d8             	movsbl %al,%ebx
  800741:	85 db                	test   %ebx,%ebx
  800743:	74 24                	je     800769 <vprintfmt+0x24b>
  800745:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800749:	78 b8                	js     800703 <vprintfmt+0x1e5>
  80074b:	ff 4d e0             	decl   -0x20(%ebp)
  80074e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800752:	79 af                	jns    800703 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800754:	eb 13                	jmp    800769 <vprintfmt+0x24b>
				putch(' ', putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	6a 20                	push   $0x20
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	ff d0                	call   *%eax
  800763:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800766:	ff 4d e4             	decl   -0x1c(%ebp)
  800769:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80076d:	7f e7                	jg     800756 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80076f:	e9 78 01 00 00       	jmp    8008ec <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	ff 75 e8             	pushl  -0x18(%ebp)
  80077a:	8d 45 14             	lea    0x14(%ebp),%eax
  80077d:	50                   	push   %eax
  80077e:	e8 3c fd ff ff       	call   8004bf <getint>
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800789:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80078c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800792:	85 d2                	test   %edx,%edx
  800794:	79 23                	jns    8007b9 <vprintfmt+0x29b>
				putch('-', putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	6a 2d                	push   $0x2d
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	ff d0                	call   *%eax
  8007a3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	f7 d8                	neg    %eax
  8007ae:	83 d2 00             	adc    $0x0,%edx
  8007b1:	f7 da                	neg    %edx
  8007b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c0:	e9 bc 00 00 00       	jmp    800881 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8007cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ce:	50                   	push   %eax
  8007cf:	e8 84 fc ff ff       	call   800458 <getuint>
  8007d4:	83 c4 10             	add    $0x10,%esp
  8007d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e4:	e9 98 00 00 00       	jmp    800881 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	ff 75 0c             	pushl  0xc(%ebp)
  8007ef:	6a 58                	push   $0x58
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	ff d0                	call   *%eax
  8007f6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	6a 58                	push   $0x58
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	ff d0                	call   *%eax
  800806:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	6a 58                	push   $0x58
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
			break;
  800819:	e9 ce 00 00 00       	jmp    8008ec <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	6a 30                	push   $0x30
  800826:	8b 45 08             	mov    0x8(%ebp),%eax
  800829:	ff d0                	call   *%eax
  80082b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	6a 78                	push   $0x78
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	83 c0 04             	add    $0x4,%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	83 e8 04             	sub    $0x4,%eax
  80084d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80084f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800852:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800859:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800860:	eb 1f                	jmp    800881 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	ff 75 e8             	pushl  -0x18(%ebp)
  800868:	8d 45 14             	lea    0x14(%ebp),%eax
  80086b:	50                   	push   %eax
  80086c:	e8 e7 fb ff ff       	call   800458 <getuint>
  800871:	83 c4 10             	add    $0x10,%esp
  800874:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800877:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80087a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800881:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800888:	83 ec 04             	sub    $0x4,%esp
  80088b:	52                   	push   %edx
  80088c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80088f:	50                   	push   %eax
  800890:	ff 75 f4             	pushl  -0xc(%ebp)
  800893:	ff 75 f0             	pushl  -0x10(%ebp)
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	ff 75 08             	pushl  0x8(%ebp)
  80089c:	e8 00 fb ff ff       	call   8003a1 <printnum>
  8008a1:	83 c4 20             	add    $0x20,%esp
			break;
  8008a4:	eb 46                	jmp    8008ec <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008a6:	83 ec 08             	sub    $0x8,%esp
  8008a9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ac:	53                   	push   %ebx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	ff d0                	call   *%eax
  8008b2:	83 c4 10             	add    $0x10,%esp
			break;
  8008b5:	eb 35                	jmp    8008ec <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008b7:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8008be:	eb 2c                	jmp    8008ec <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008c0:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8008c7:	eb 23                	jmp    8008ec <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c9:	83 ec 08             	sub    $0x8,%esp
  8008cc:	ff 75 0c             	pushl  0xc(%ebp)
  8008cf:	6a 25                	push   $0x25
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d9:	ff 4d 10             	decl   0x10(%ebp)
  8008dc:	eb 03                	jmp    8008e1 <vprintfmt+0x3c3>
  8008de:	ff 4d 10             	decl   0x10(%ebp)
  8008e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e4:	48                   	dec    %eax
  8008e5:	8a 00                	mov    (%eax),%al
  8008e7:	3c 25                	cmp    $0x25,%al
  8008e9:	75 f3                	jne    8008de <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008eb:	90                   	nop
		}
	}
  8008ec:	e9 35 fc ff ff       	jmp    800526 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008f1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008f5:	5b                   	pop    %ebx
  8008f6:	5e                   	pop    %esi
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008ff:	8d 45 10             	lea    0x10(%ebp),%eax
  800902:	83 c0 04             	add    $0x4,%eax
  800905:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800908:	8b 45 10             	mov    0x10(%ebp),%eax
  80090b:	ff 75 f4             	pushl  -0xc(%ebp)
  80090e:	50                   	push   %eax
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	ff 75 08             	pushl  0x8(%ebp)
  800915:	e8 04 fc ff ff       	call   80051e <vprintfmt>
  80091a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80091d:	90                   	nop
  80091e:	c9                   	leave  
  80091f:	c3                   	ret    

00800920 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800923:	8b 45 0c             	mov    0xc(%ebp),%eax
  800926:	8b 40 08             	mov    0x8(%eax),%eax
  800929:	8d 50 01             	lea    0x1(%eax),%edx
  80092c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	8b 10                	mov    (%eax),%edx
  800937:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093a:	8b 40 04             	mov    0x4(%eax),%eax
  80093d:	39 c2                	cmp    %eax,%edx
  80093f:	73 12                	jae    800953 <sprintputch+0x33>
		*b->buf++ = ch;
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	8d 48 01             	lea    0x1(%eax),%ecx
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 0a                	mov    %ecx,(%edx)
  80094e:	8b 55 08             	mov    0x8(%ebp),%edx
  800951:	88 10                	mov    %dl,(%eax)
}
  800953:	90                   	nop
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800962:	8b 45 0c             	mov    0xc(%ebp),%eax
  800965:	8d 50 ff             	lea    -0x1(%eax),%edx
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	01 d0                	add    %edx,%eax
  80096d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800970:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800977:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80097b:	74 06                	je     800983 <vsnprintf+0x2d>
  80097d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800981:	7f 07                	jg     80098a <vsnprintf+0x34>
		return -E_INVAL;
  800983:	b8 03 00 00 00       	mov    $0x3,%eax
  800988:	eb 20                	jmp    8009aa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80098a:	ff 75 14             	pushl  0x14(%ebp)
  80098d:	ff 75 10             	pushl  0x10(%ebp)
  800990:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800993:	50                   	push   %eax
  800994:	68 20 09 80 00       	push   $0x800920
  800999:	e8 80 fb ff ff       	call   80051e <vprintfmt>
  80099e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009aa:	c9                   	leave  
  8009ab:	c3                   	ret    

008009ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8009b5:	83 c0 04             	add    $0x4,%eax
  8009b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009be:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c1:	50                   	push   %eax
  8009c2:	ff 75 0c             	pushl  0xc(%ebp)
  8009c5:	ff 75 08             	pushl  0x8(%ebp)
  8009c8:	e8 89 ff ff ff       	call   800956 <vsnprintf>
  8009cd:	83 c4 10             	add    $0x10,%esp
  8009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009d6:	c9                   	leave  
  8009d7:	c3                   	ret    

008009d8 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009e5:	eb 06                	jmp    8009ed <strlen+0x15>
		n++;
  8009e7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ea:	ff 45 08             	incl   0x8(%ebp)
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	8a 00                	mov    (%eax),%al
  8009f2:	84 c0                	test   %al,%al
  8009f4:	75 f1                	jne    8009e7 <strlen+0xf>
		n++;
	return n;
  8009f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    

008009fb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a08:	eb 09                	jmp    800a13 <strnlen+0x18>
		n++;
  800a0a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0d:	ff 45 08             	incl   0x8(%ebp)
  800a10:	ff 4d 0c             	decl   0xc(%ebp)
  800a13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a17:	74 09                	je     800a22 <strnlen+0x27>
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8a 00                	mov    (%eax),%al
  800a1e:	84 c0                	test   %al,%al
  800a20:	75 e8                	jne    800a0a <strnlen+0xf>
		n++;
	return n;
  800a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a33:	90                   	nop
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8d 50 01             	lea    0x1(%eax),%edx
  800a3a:	89 55 08             	mov    %edx,0x8(%ebp)
  800a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a43:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a46:	8a 12                	mov    (%edx),%dl
  800a48:	88 10                	mov    %dl,(%eax)
  800a4a:	8a 00                	mov    (%eax),%al
  800a4c:	84 c0                	test   %al,%al
  800a4e:	75 e4                	jne    800a34 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a53:	c9                   	leave  
  800a54:	c3                   	ret    

00800a55 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a68:	eb 1f                	jmp    800a89 <strncpy+0x34>
		*dst++ = *src;
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8d 50 01             	lea    0x1(%eax),%edx
  800a70:	89 55 08             	mov    %edx,0x8(%ebp)
  800a73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a76:	8a 12                	mov    (%edx),%dl
  800a78:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	84 c0                	test   %al,%al
  800a81:	74 03                	je     800a86 <strncpy+0x31>
			src++;
  800a83:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a86:	ff 45 fc             	incl   -0x4(%ebp)
  800a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a8c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a8f:	72 d9                	jb     800a6a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a91:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a94:	c9                   	leave  
  800a95:	c3                   	ret    

00800a96 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800aa2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa6:	74 30                	je     800ad8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aa8:	eb 16                	jmp    800ac0 <strlcpy+0x2a>
			*dst++ = *src++;
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	8d 50 01             	lea    0x1(%eax),%edx
  800ab0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ab9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800abc:	8a 12                	mov    (%edx),%dl
  800abe:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ac0:	ff 4d 10             	decl   0x10(%ebp)
  800ac3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac7:	74 09                	je     800ad2 <strlcpy+0x3c>
  800ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	84 c0                	test   %al,%al
  800ad0:	75 d8                	jne    800aaa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad8:	8b 55 08             	mov    0x8(%ebp),%edx
  800adb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ade:	29 c2                	sub    %eax,%edx
  800ae0:	89 d0                	mov    %edx,%eax
}
  800ae2:	c9                   	leave  
  800ae3:	c3                   	ret    

00800ae4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ae7:	eb 06                	jmp    800aef <strcmp+0xb>
		p++, q++;
  800ae9:	ff 45 08             	incl   0x8(%ebp)
  800aec:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	84 c0                	test   %al,%al
  800af6:	74 0e                	je     800b06 <strcmp+0x22>
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8a 10                	mov    (%eax),%dl
  800afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	38 c2                	cmp    %al,%dl
  800b04:	74 e3                	je     800ae9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	8a 00                	mov    (%eax),%al
  800b0b:	0f b6 d0             	movzbl %al,%edx
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	0f b6 c0             	movzbl %al,%eax
  800b16:	29 c2                	sub    %eax,%edx
  800b18:	89 d0                	mov    %edx,%eax
}
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b1f:	eb 09                	jmp    800b2a <strncmp+0xe>
		n--, p++, q++;
  800b21:	ff 4d 10             	decl   0x10(%ebp)
  800b24:	ff 45 08             	incl   0x8(%ebp)
  800b27:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b2e:	74 17                	je     800b47 <strncmp+0x2b>
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	8a 00                	mov    (%eax),%al
  800b35:	84 c0                	test   %al,%al
  800b37:	74 0e                	je     800b47 <strncmp+0x2b>
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8a 10                	mov    (%eax),%dl
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	8a 00                	mov    (%eax),%al
  800b43:	38 c2                	cmp    %al,%dl
  800b45:	74 da                	je     800b21 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b4b:	75 07                	jne    800b54 <strncmp+0x38>
		return 0;
  800b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800b52:	eb 14                	jmp    800b68 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8a 00                	mov    (%eax),%al
  800b59:	0f b6 d0             	movzbl %al,%edx
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8a 00                	mov    (%eax),%al
  800b61:	0f b6 c0             	movzbl %al,%eax
  800b64:	29 c2                	sub    %eax,%edx
  800b66:	89 d0                	mov    %edx,%eax
}
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 04             	sub    $0x4,%esp
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b76:	eb 12                	jmp    800b8a <strchr+0x20>
		if (*s == c)
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8a 00                	mov    (%eax),%al
  800b7d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b80:	75 05                	jne    800b87 <strchr+0x1d>
			return (char *) s;
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	eb 11                	jmp    800b98 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b87:	ff 45 08             	incl   0x8(%ebp)
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8a 00                	mov    (%eax),%al
  800b8f:	84 c0                	test   %al,%al
  800b91:	75 e5                	jne    800b78 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 04             	sub    $0x4,%esp
  800ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ba6:	eb 0d                	jmp    800bb5 <strfind+0x1b>
		if (*s == c)
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8a 00                	mov    (%eax),%al
  800bad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bb0:	74 0e                	je     800bc0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bb2:	ff 45 08             	incl   0x8(%ebp)
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8a 00                	mov    (%eax),%al
  800bba:	84 c0                	test   %al,%al
  800bbc:	75 ea                	jne    800ba8 <strfind+0xe>
  800bbe:	eb 01                	jmp    800bc1 <strfind+0x27>
		if (*s == c)
			break;
  800bc0:	90                   	nop
	return (char *) s;
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bd8:	eb 0e                	jmp    800be8 <memset+0x22>
		*p++ = c;
  800bda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bdd:	8d 50 01             	lea    0x1(%eax),%edx
  800be0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800be8:	ff 4d f8             	decl   -0x8(%ebp)
  800beb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bef:	79 e9                	jns    800bda <memset+0x14>
		*p++ = c;

	return v;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c08:	eb 16                	jmp    800c20 <memcpy+0x2a>
		*d++ = *s++;
  800c0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c0d:	8d 50 01             	lea    0x1(%eax),%edx
  800c10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c1c:	8a 12                	mov    (%edx),%dl
  800c1e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c20:	8b 45 10             	mov    0x10(%ebp),%eax
  800c23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c26:	89 55 10             	mov    %edx,0x10(%ebp)
  800c29:	85 c0                	test   %eax,%eax
  800c2b:	75 dd                	jne    800c0a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c47:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c4a:	73 50                	jae    800c9c <memmove+0x6a>
  800c4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c52:	01 d0                	add    %edx,%eax
  800c54:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c57:	76 43                	jbe    800c9c <memmove+0x6a>
		s += n;
  800c59:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c62:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c65:	eb 10                	jmp    800c77 <memmove+0x45>
			*--d = *--s;
  800c67:	ff 4d f8             	decl   -0x8(%ebp)
  800c6a:	ff 4d fc             	decl   -0x4(%ebp)
  800c6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c70:	8a 10                	mov    (%eax),%dl
  800c72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c75:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c77:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c7d:	89 55 10             	mov    %edx,0x10(%ebp)
  800c80:	85 c0                	test   %eax,%eax
  800c82:	75 e3                	jne    800c67 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c84:	eb 23                	jmp    800ca9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c89:	8d 50 01             	lea    0x1(%eax),%edx
  800c8c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c95:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c98:	8a 12                	mov    (%edx),%dl
  800c9a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	75 dd                	jne    800c86 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cac:	c9                   	leave  
  800cad:	c3                   	ret    

00800cae <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cc0:	eb 2a                	jmp    800cec <memcmp+0x3e>
		if (*s1 != *s2)
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc5:	8a 10                	mov    (%eax),%dl
  800cc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	38 c2                	cmp    %al,%dl
  800cce:	74 16                	je     800ce6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	0f b6 d0             	movzbl %al,%edx
  800cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	0f b6 c0             	movzbl %al,%eax
  800ce0:	29 c2                	sub    %eax,%edx
  800ce2:	89 d0                	mov    %edx,%eax
  800ce4:	eb 18                	jmp    800cfe <memcmp+0x50>
		s1++, s2++;
  800ce6:	ff 45 fc             	incl   -0x4(%ebp)
  800ce9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cec:	8b 45 10             	mov    0x10(%ebp),%eax
  800cef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf2:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf5:	85 c0                	test   %eax,%eax
  800cf7:	75 c9                	jne    800cc2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cfe:	c9                   	leave  
  800cff:	c3                   	ret    

00800d00 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d06:	8b 55 08             	mov    0x8(%ebp),%edx
  800d09:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0c:	01 d0                	add    %edx,%eax
  800d0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d11:	eb 15                	jmp    800d28 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	0f b6 d0             	movzbl %al,%edx
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	0f b6 c0             	movzbl %al,%eax
  800d21:	39 c2                	cmp    %eax,%edx
  800d23:	74 0d                	je     800d32 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d25:	ff 45 08             	incl   0x8(%ebp)
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d2e:	72 e3                	jb     800d13 <memfind+0x13>
  800d30:	eb 01                	jmp    800d33 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d32:	90                   	nop
	return (void *) s;
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d36:	c9                   	leave  
  800d37:	c3                   	ret    

00800d38 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d45:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4c:	eb 03                	jmp    800d51 <strtol+0x19>
		s++;
  800d4e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	3c 20                	cmp    $0x20,%al
  800d58:	74 f4                	je     800d4e <strtol+0x16>
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	3c 09                	cmp    $0x9,%al
  800d61:	74 eb                	je     800d4e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	3c 2b                	cmp    $0x2b,%al
  800d6a:	75 05                	jne    800d71 <strtol+0x39>
		s++;
  800d6c:	ff 45 08             	incl   0x8(%ebp)
  800d6f:	eb 13                	jmp    800d84 <strtol+0x4c>
	else if (*s == '-')
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	3c 2d                	cmp    $0x2d,%al
  800d78:	75 0a                	jne    800d84 <strtol+0x4c>
		s++, neg = 1;
  800d7a:	ff 45 08             	incl   0x8(%ebp)
  800d7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d88:	74 06                	je     800d90 <strtol+0x58>
  800d8a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d8e:	75 20                	jne    800db0 <strtol+0x78>
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	3c 30                	cmp    $0x30,%al
  800d97:	75 17                	jne    800db0 <strtol+0x78>
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	40                   	inc    %eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	3c 78                	cmp    $0x78,%al
  800da1:	75 0d                	jne    800db0 <strtol+0x78>
		s += 2, base = 16;
  800da3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800da7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dae:	eb 28                	jmp    800dd8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800db0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db4:	75 15                	jne    800dcb <strtol+0x93>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 30                	cmp    $0x30,%al
  800dbd:	75 0c                	jne    800dcb <strtol+0x93>
		s++, base = 8;
  800dbf:	ff 45 08             	incl   0x8(%ebp)
  800dc2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dc9:	eb 0d                	jmp    800dd8 <strtol+0xa0>
	else if (base == 0)
  800dcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcf:	75 07                	jne    800dd8 <strtol+0xa0>
		base = 10;
  800dd1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	3c 2f                	cmp    $0x2f,%al
  800ddf:	7e 19                	jle    800dfa <strtol+0xc2>
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	3c 39                	cmp    $0x39,%al
  800de8:	7f 10                	jg     800dfa <strtol+0xc2>
			dig = *s - '0';
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f be c0             	movsbl %al,%eax
  800df2:	83 e8 30             	sub    $0x30,%eax
  800df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800df8:	eb 42                	jmp    800e3c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfd:	8a 00                	mov    (%eax),%al
  800dff:	3c 60                	cmp    $0x60,%al
  800e01:	7e 19                	jle    800e1c <strtol+0xe4>
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	3c 7a                	cmp    $0x7a,%al
  800e0a:	7f 10                	jg     800e1c <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	0f be c0             	movsbl %al,%eax
  800e14:	83 e8 57             	sub    $0x57,%eax
  800e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1a:	eb 20                	jmp    800e3c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	3c 40                	cmp    $0x40,%al
  800e23:	7e 39                	jle    800e5e <strtol+0x126>
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 00                	mov    (%eax),%al
  800e2a:	3c 5a                	cmp    $0x5a,%al
  800e2c:	7f 30                	jg     800e5e <strtol+0x126>
			dig = *s - 'A' + 10;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	0f be c0             	movsbl %al,%eax
  800e36:	83 e8 37             	sub    $0x37,%eax
  800e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e3f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e42:	7d 19                	jge    800e5d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e44:	ff 45 08             	incl   0x8(%ebp)
  800e47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e4e:	89 c2                	mov    %eax,%edx
  800e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e53:	01 d0                	add    %edx,%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e58:	e9 7b ff ff ff       	jmp    800dd8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e5d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e5e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e62:	74 08                	je     800e6c <strtol+0x134>
		*endptr = (char *) s;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e6c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e70:	74 07                	je     800e79 <strtol+0x141>
  800e72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e75:	f7 d8                	neg    %eax
  800e77:	eb 03                	jmp    800e7c <strtol+0x144>
  800e79:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <ltostr>:

void
ltostr(long value, char *str)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e8b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e96:	79 13                	jns    800eab <ltostr+0x2d>
	{
		neg = 1;
  800e98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ea5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ea8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eb3:	99                   	cltd   
  800eb4:	f7 f9                	idiv   %ecx
  800eb6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebc:	8d 50 01             	lea    0x1(%eax),%edx
  800ebf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ec2:	89 c2                	mov    %eax,%edx
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	01 d0                	add    %edx,%eax
  800ec9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ecc:	83 c2 30             	add    $0x30,%edx
  800ecf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ed1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ed9:	f7 e9                	imul   %ecx
  800edb:	c1 fa 02             	sar    $0x2,%edx
  800ede:	89 c8                	mov    %ecx,%eax
  800ee0:	c1 f8 1f             	sar    $0x1f,%eax
  800ee3:	29 c2                	sub    %eax,%edx
  800ee5:	89 d0                	mov    %edx,%eax
  800ee7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800eea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800eee:	75 bb                	jne    800eab <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ef0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800ef7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efa:	48                   	dec    %eax
  800efb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800efe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f02:	74 3d                	je     800f41 <ltostr+0xc3>
		start = 1 ;
  800f04:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f0b:	eb 34                	jmp    800f41 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	01 d0                	add    %edx,%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f20:	01 c2                	add    %eax,%edx
  800f22:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	01 c8                	add    %ecx,%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	01 c2                	add    %eax,%edx
  800f36:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f39:	88 02                	mov    %al,(%edx)
		start++ ;
  800f3b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f3e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f47:	7c c4                	jl     800f0d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f49:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4f:	01 d0                	add    %edx,%eax
  800f51:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f54:	90                   	nop
  800f55:	c9                   	leave  
  800f56:	c3                   	ret    

00800f57 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f5d:	ff 75 08             	pushl  0x8(%ebp)
  800f60:	e8 73 fa ff ff       	call   8009d8 <strlen>
  800f65:	83 c4 04             	add    $0x4,%esp
  800f68:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f6b:	ff 75 0c             	pushl  0xc(%ebp)
  800f6e:	e8 65 fa ff ff       	call   8009d8 <strlen>
  800f73:	83 c4 04             	add    $0x4,%esp
  800f76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f87:	eb 17                	jmp    800fa0 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f89:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 c2                	add    %eax,%edx
  800f91:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	01 c8                	add    %ecx,%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f9d:	ff 45 fc             	incl   -0x4(%ebp)
  800fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fa6:	7c e1                	jl     800f89 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fa8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800faf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fb6:	eb 1f                	jmp    800fd7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fbb:	8d 50 01             	lea    0x1(%eax),%edx
  800fbe:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fc1:	89 c2                	mov    %eax,%edx
  800fc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc6:	01 c2                	add    %eax,%edx
  800fc8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fce:	01 c8                	add    %ecx,%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fd4:	ff 45 f8             	incl   -0x8(%ebp)
  800fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fda:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fdd:	7c d9                	jl     800fb8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800fdf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe5:	01 d0                	add    %edx,%eax
  800fe7:	c6 00 00             	movb   $0x0,(%eax)
}
  800fea:	90                   	nop
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800ff0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800ff9:	8b 45 14             	mov    0x14(%ebp),%eax
  800ffc:	8b 00                	mov    (%eax),%eax
  800ffe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801005:	8b 45 10             	mov    0x10(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801010:	eb 0c                	jmp    80101e <strsplit+0x31>
			*string++ = 0;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	8d 50 01             	lea    0x1(%eax),%edx
  801018:	89 55 08             	mov    %edx,0x8(%ebp)
  80101b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	84 c0                	test   %al,%al
  801025:	74 18                	je     80103f <strsplit+0x52>
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f be c0             	movsbl %al,%eax
  80102f:	50                   	push   %eax
  801030:	ff 75 0c             	pushl  0xc(%ebp)
  801033:	e8 32 fb ff ff       	call   800b6a <strchr>
  801038:	83 c4 08             	add    $0x8,%esp
  80103b:	85 c0                	test   %eax,%eax
  80103d:	75 d3                	jne    801012 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	84 c0                	test   %al,%al
  801046:	74 5a                	je     8010a2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801048:	8b 45 14             	mov    0x14(%ebp),%eax
  80104b:	8b 00                	mov    (%eax),%eax
  80104d:	83 f8 0f             	cmp    $0xf,%eax
  801050:	75 07                	jne    801059 <strsplit+0x6c>
		{
			return 0;
  801052:	b8 00 00 00 00       	mov    $0x0,%eax
  801057:	eb 66                	jmp    8010bf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801059:	8b 45 14             	mov    0x14(%ebp),%eax
  80105c:	8b 00                	mov    (%eax),%eax
  80105e:	8d 48 01             	lea    0x1(%eax),%ecx
  801061:	8b 55 14             	mov    0x14(%ebp),%edx
  801064:	89 0a                	mov    %ecx,(%edx)
  801066:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80106d:	8b 45 10             	mov    0x10(%ebp),%eax
  801070:	01 c2                	add    %eax,%edx
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801077:	eb 03                	jmp    80107c <strsplit+0x8f>
			string++;
  801079:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8a 00                	mov    (%eax),%al
  801081:	84 c0                	test   %al,%al
  801083:	74 8b                	je     801010 <strsplit+0x23>
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	0f be c0             	movsbl %al,%eax
  80108d:	50                   	push   %eax
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	e8 d4 fa ff ff       	call   800b6a <strchr>
  801096:	83 c4 08             	add    $0x8,%esp
  801099:	85 c0                	test   %eax,%eax
  80109b:	74 dc                	je     801079 <strsplit+0x8c>
			string++;
	}
  80109d:	e9 6e ff ff ff       	jmp    801010 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010a2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a6:	8b 00                	mov    (%eax),%eax
  8010a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 d0                	add    %edx,%eax
  8010b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010ba:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    

008010c1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8010c7:	83 ec 04             	sub    $0x4,%esp
  8010ca:	68 c8 21 80 00       	push   $0x8021c8
  8010cf:	68 3f 01 00 00       	push   $0x13f
  8010d4:	68 ea 21 80 00       	push   $0x8021ea
  8010d9:	e8 79 07 00 00       	call   801857 <_panic>

008010de <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	57                   	push   %edi
  8010e2:	56                   	push   %esi
  8010e3:	53                   	push   %ebx
  8010e4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010f0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010f3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010f6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010f9:	cd 30                	int    $0x30
  8010fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801101:	83 c4 10             	add    $0x10,%esp
  801104:	5b                   	pop    %ebx
  801105:	5e                   	pop    %esi
  801106:	5f                   	pop    %edi
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 04             	sub    $0x4,%esp
  80110f:	8b 45 10             	mov    0x10(%ebp),%eax
  801112:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801115:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	52                   	push   %edx
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	50                   	push   %eax
  801125:	6a 00                	push   $0x0
  801127:	e8 b2 ff ff ff       	call   8010de <syscall>
  80112c:	83 c4 18             	add    $0x18,%esp
}
  80112f:	90                   	nop
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <sys_cgetc>:

int
sys_cgetc(void)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801135:	6a 00                	push   $0x0
  801137:	6a 00                	push   $0x0
  801139:	6a 00                	push   $0x0
  80113b:	6a 00                	push   $0x0
  80113d:	6a 00                	push   $0x0
  80113f:	6a 02                	push   $0x2
  801141:	e8 98 ff ff ff       	call   8010de <syscall>
  801146:	83 c4 18             	add    $0x18,%esp
}
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <sys_lock_cons>:

void sys_lock_cons(void)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80114e:	6a 00                	push   $0x0
  801150:	6a 00                	push   $0x0
  801152:	6a 00                	push   $0x0
  801154:	6a 00                	push   $0x0
  801156:	6a 00                	push   $0x0
  801158:	6a 03                	push   $0x3
  80115a:	e8 7f ff ff ff       	call   8010de <syscall>
  80115f:	83 c4 18             	add    $0x18,%esp
}
  801162:	90                   	nop
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	6a 00                	push   $0x0
  801170:	6a 00                	push   $0x0
  801172:	6a 04                	push   $0x4
  801174:	e8 65 ff ff ff       	call   8010de <syscall>
  801179:	83 c4 18             	add    $0x18,%esp
}
  80117c:	90                   	nop
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801182:	8b 55 0c             	mov    0xc(%ebp),%edx
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	6a 00                	push   $0x0
  80118a:	6a 00                	push   $0x0
  80118c:	6a 00                	push   $0x0
  80118e:	52                   	push   %edx
  80118f:	50                   	push   %eax
  801190:	6a 08                	push   $0x8
  801192:	e8 47 ff ff ff       	call   8010de <syscall>
  801197:	83 c4 18             	add    $0x18,%esp
}
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	56                   	push   %esi
  8011a0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8011a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8011a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
  8011b2:	51                   	push   %ecx
  8011b3:	52                   	push   %edx
  8011b4:	50                   	push   %eax
  8011b5:	6a 09                	push   $0x9
  8011b7:	e8 22 ff ff ff       	call   8010de <syscall>
  8011bc:	83 c4 18             	add    $0x18,%esp
}
  8011bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011c2:	5b                   	pop    %ebx
  8011c3:	5e                   	pop    %esi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    

008011c6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8011c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	6a 00                	push   $0x0
  8011d1:	6a 00                	push   $0x0
  8011d3:	6a 00                	push   $0x0
  8011d5:	52                   	push   %edx
  8011d6:	50                   	push   %eax
  8011d7:	6a 0a                	push   $0xa
  8011d9:	e8 00 ff ff ff       	call   8010de <syscall>
  8011de:	83 c4 18             	add    $0x18,%esp
}
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    

008011e3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 00                	push   $0x0
  8011ec:	ff 75 0c             	pushl  0xc(%ebp)
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	6a 0b                	push   $0xb
  8011f4:	e8 e5 fe ff ff       	call   8010de <syscall>
  8011f9:	83 c4 18             	add    $0x18,%esp
}
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    

008011fe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801201:	6a 00                	push   $0x0
  801203:	6a 00                	push   $0x0
  801205:	6a 00                	push   $0x0
  801207:	6a 00                	push   $0x0
  801209:	6a 00                	push   $0x0
  80120b:	6a 0c                	push   $0xc
  80120d:	e8 cc fe ff ff       	call   8010de <syscall>
  801212:	83 c4 18             	add    $0x18,%esp
}
  801215:	c9                   	leave  
  801216:	c3                   	ret    

00801217 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80121a:	6a 00                	push   $0x0
  80121c:	6a 00                	push   $0x0
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	6a 00                	push   $0x0
  801224:	6a 0d                	push   $0xd
  801226:	e8 b3 fe ff ff       	call   8010de <syscall>
  80122b:	83 c4 18             	add    $0x18,%esp
}
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    

00801230 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 0e                	push   $0xe
  80123f:	e8 9a fe ff ff       	call   8010de <syscall>
  801244:	83 c4 18             	add    $0x18,%esp
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 0f                	push   $0xf
  801258:	e8 81 fe ff ff       	call   8010de <syscall>
  80125d:	83 c4 18             	add    $0x18,%esp
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	ff 75 08             	pushl  0x8(%ebp)
  801270:	6a 10                	push   $0x10
  801272:	e8 67 fe ff ff       	call   8010de <syscall>
  801277:	83 c4 18             	add    $0x18,%esp
}
  80127a:	c9                   	leave  
  80127b:	c3                   	ret    

0080127c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 00                	push   $0x0
  801287:	6a 00                	push   $0x0
  801289:	6a 11                	push   $0x11
  80128b:	e8 4e fe ff ff       	call   8010de <syscall>
  801290:	83 c4 18             	add    $0x18,%esp
}
  801293:	90                   	nop
  801294:	c9                   	leave  
  801295:	c3                   	ret    

00801296 <sys_cputc>:

void
sys_cputc(const char c)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	83 ec 04             	sub    $0x4,%esp
  80129c:	8b 45 08             	mov    0x8(%ebp),%eax
  80129f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8012a2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	50                   	push   %eax
  8012af:	6a 01                	push   $0x1
  8012b1:	e8 28 fe ff ff       	call   8010de <syscall>
  8012b6:	83 c4 18             	add    $0x18,%esp
}
  8012b9:	90                   	nop
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	6a 00                	push   $0x0
  8012c9:	6a 14                	push   $0x14
  8012cb:	e8 0e fe ff ff       	call   8010de <syscall>
  8012d0:	83 c4 18             	add    $0x18,%esp
}
  8012d3:	90                   	nop
  8012d4:	c9                   	leave  
  8012d5:	c3                   	ret    

008012d6 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	83 ec 04             	sub    $0x4,%esp
  8012dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012df:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ec:	6a 00                	push   $0x0
  8012ee:	51                   	push   %ecx
  8012ef:	52                   	push   %edx
  8012f0:	ff 75 0c             	pushl  0xc(%ebp)
  8012f3:	50                   	push   %eax
  8012f4:	6a 15                	push   $0x15
  8012f6:	e8 e3 fd ff ff       	call   8010de <syscall>
  8012fb:	83 c4 18             	add    $0x18,%esp
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801303:	8b 55 0c             	mov    0xc(%ebp),%edx
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	52                   	push   %edx
  801310:	50                   	push   %eax
  801311:	6a 16                	push   $0x16
  801313:	e8 c6 fd ff ff       	call   8010de <syscall>
  801318:	83 c4 18             	add    $0x18,%esp
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801320:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801323:	8b 55 0c             	mov    0xc(%ebp),%edx
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	51                   	push   %ecx
  80132e:	52                   	push   %edx
  80132f:	50                   	push   %eax
  801330:	6a 17                	push   $0x17
  801332:	e8 a7 fd ff ff       	call   8010de <syscall>
  801337:	83 c4 18             	add    $0x18,%esp
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80133f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801342:	8b 45 08             	mov    0x8(%ebp),%eax
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	52                   	push   %edx
  80134c:	50                   	push   %eax
  80134d:	6a 18                	push   $0x18
  80134f:	e8 8a fd ff ff       	call   8010de <syscall>
  801354:	83 c4 18             	add    $0x18,%esp
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    

00801359 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	6a 00                	push   $0x0
  801361:	ff 75 14             	pushl  0x14(%ebp)
  801364:	ff 75 10             	pushl  0x10(%ebp)
  801367:	ff 75 0c             	pushl  0xc(%ebp)
  80136a:	50                   	push   %eax
  80136b:	6a 19                	push   $0x19
  80136d:	e8 6c fd ff ff       	call   8010de <syscall>
  801372:	83 c4 18             	add    $0x18,%esp
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	50                   	push   %eax
  801386:	6a 1a                	push   $0x1a
  801388:	e8 51 fd ff ff       	call   8010de <syscall>
  80138d:	83 c4 18             	add    $0x18,%esp
}
  801390:	90                   	nop
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	50                   	push   %eax
  8013a2:	6a 1b                	push   $0x1b
  8013a4:	e8 35 fd ff ff       	call   8010de <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
}
  8013ac:	c9                   	leave  
  8013ad:	c3                   	ret    

008013ae <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 00                	push   $0x0
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 05                	push   $0x5
  8013bd:	e8 1c fd ff ff       	call   8010de <syscall>
  8013c2:	83 c4 18             	add    $0x18,%esp
}
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 00                	push   $0x0
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 06                	push   $0x6
  8013d6:	e8 03 fd ff ff       	call   8010de <syscall>
  8013db:	83 c4 18             	add    $0x18,%esp
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 07                	push   $0x7
  8013ef:	e8 ea fc ff ff       	call   8010de <syscall>
  8013f4:	83 c4 18             	add    $0x18,%esp
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <sys_exit_env>:


void sys_exit_env(void)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 00                	push   $0x0
  801406:	6a 1c                	push   $0x1c
  801408:	e8 d1 fc ff ff       	call   8010de <syscall>
  80140d:	83 c4 18             	add    $0x18,%esp
}
  801410:	90                   	nop
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801419:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80141c:	8d 50 04             	lea    0x4(%eax),%edx
  80141f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	52                   	push   %edx
  801429:	50                   	push   %eax
  80142a:	6a 1d                	push   $0x1d
  80142c:	e8 ad fc ff ff       	call   8010de <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
	return result;
  801434:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801437:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80143d:	89 01                	mov    %eax,(%ecx)
  80143f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	c9                   	leave  
  801446:	c2 04 00             	ret    $0x4

00801449 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	ff 75 10             	pushl  0x10(%ebp)
  801453:	ff 75 0c             	pushl  0xc(%ebp)
  801456:	ff 75 08             	pushl  0x8(%ebp)
  801459:	6a 13                	push   $0x13
  80145b:	e8 7e fc ff ff       	call   8010de <syscall>
  801460:	83 c4 18             	add    $0x18,%esp
	return ;
  801463:	90                   	nop
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <sys_rcr2>:
uint32 sys_rcr2()
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 1e                	push   $0x1e
  801475:	e8 64 fc ff ff       	call   8010de <syscall>
  80147a:	83 c4 18             	add    $0x18,%esp
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	83 ec 04             	sub    $0x4,%esp
  801485:	8b 45 08             	mov    0x8(%ebp),%eax
  801488:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80148b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	50                   	push   %eax
  801498:	6a 1f                	push   $0x1f
  80149a:	e8 3f fc ff ff       	call   8010de <syscall>
  80149f:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a2:	90                   	nop
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <rsttst>:
void rsttst()
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 21                	push   $0x21
  8014b4:	e8 25 fc ff ff       	call   8010de <syscall>
  8014b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8014bc:	90                   	nop
}
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	83 ec 04             	sub    $0x4,%esp
  8014c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014cb:	8b 55 18             	mov    0x18(%ebp),%edx
  8014ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014d2:	52                   	push   %edx
  8014d3:	50                   	push   %eax
  8014d4:	ff 75 10             	pushl  0x10(%ebp)
  8014d7:	ff 75 0c             	pushl  0xc(%ebp)
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	6a 20                	push   $0x20
  8014df:	e8 fa fb ff ff       	call   8010de <syscall>
  8014e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8014e7:	90                   	nop
}
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <chktst>:
void chktst(uint32 n)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 00                	push   $0x0
  8014f5:	ff 75 08             	pushl  0x8(%ebp)
  8014f8:	6a 22                	push   $0x22
  8014fa:	e8 df fb ff ff       	call   8010de <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801502:	90                   	nop
}
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <inctst>:

void inctst()
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 23                	push   $0x23
  801514:	e8 c5 fb ff ff       	call   8010de <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
	return ;
  80151c:	90                   	nop
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <gettst>:
uint32 gettst()
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 24                	push   $0x24
  80152e:	e8 ab fb ff ff       	call   8010de <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 25                	push   $0x25
  80154a:	e8 8f fb ff ff       	call   8010de <syscall>
  80154f:	83 c4 18             	add    $0x18,%esp
  801552:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801555:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801559:	75 07                	jne    801562 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80155b:	b8 01 00 00 00       	mov    $0x1,%eax
  801560:	eb 05                	jmp    801567 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801562:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801567:	c9                   	leave  
  801568:	c3                   	ret    

00801569 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 25                	push   $0x25
  80157b:	e8 5e fb ff ff       	call   8010de <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
  801583:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801586:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80158a:	75 07                	jne    801593 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80158c:	b8 01 00 00 00       	mov    $0x1,%eax
  801591:	eb 05                	jmp    801598 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 25                	push   $0x25
  8015ac:	e8 2d fb ff ff       	call   8010de <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
  8015b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015b7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015bb:	75 07                	jne    8015c4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8015c2:	eb 05                	jmp    8015c9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 25                	push   $0x25
  8015dd:	e8 fc fa ff ff       	call   8010de <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
  8015e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015e8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015ec:	75 07                	jne    8015f5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f3:	eb 05                	jmp    8015fa <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	ff 75 08             	pushl  0x8(%ebp)
  80160a:	6a 26                	push   $0x26
  80160c:	e8 cd fa ff ff       	call   8010de <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
	return ;
  801614:	90                   	nop
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80161b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80161e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	6a 00                	push   $0x0
  801629:	53                   	push   %ebx
  80162a:	51                   	push   %ecx
  80162b:	52                   	push   %edx
  80162c:	50                   	push   %eax
  80162d:	6a 27                	push   $0x27
  80162f:	e8 aa fa ff ff       	call   8010de <syscall>
  801634:	83 c4 18             	add    $0x18,%esp
}
  801637:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	52                   	push   %edx
  80164c:	50                   	push   %eax
  80164d:	6a 28                	push   $0x28
  80164f:	e8 8a fa ff ff       	call   8010de <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	c9                   	leave  
  801658:	c3                   	ret    

00801659 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80165c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80165f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	6a 00                	push   $0x0
  801667:	51                   	push   %ecx
  801668:	ff 75 10             	pushl  0x10(%ebp)
  80166b:	52                   	push   %edx
  80166c:	50                   	push   %eax
  80166d:	6a 29                	push   $0x29
  80166f:	e8 6a fa ff ff       	call   8010de <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	ff 75 10             	pushl  0x10(%ebp)
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	ff 75 08             	pushl  0x8(%ebp)
  801689:	6a 12                	push   $0x12
  80168b:	e8 4e fa ff ff       	call   8010de <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
	return ;
  801693:	90                   	nop
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	52                   	push   %edx
  8016a6:	50                   	push   %eax
  8016a7:	6a 2a                	push   $0x2a
  8016a9:	e8 30 fa ff ff       	call   8010de <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
	return;
  8016b1:	90                   	nop
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	50                   	push   %eax
  8016c3:	6a 2b                	push   $0x2b
  8016c5:	e8 14 fa ff ff       	call   8010de <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	ff 75 08             	pushl  0x8(%ebp)
  8016de:	6a 2c                	push   $0x2c
  8016e0:	e8 f9 f9 ff ff       	call   8010de <syscall>
  8016e5:	83 c4 18             	add    $0x18,%esp
	return;
  8016e8:	90                   	nop
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	ff 75 0c             	pushl  0xc(%ebp)
  8016f7:	ff 75 08             	pushl  0x8(%ebp)
  8016fa:	6a 2d                	push   $0x2d
  8016fc:	e8 dd f9 ff ff       	call   8010de <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
	return;
  801704:	90                   	nop
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 2e                	push   $0x2e
  801719:	e8 c0 f9 ff ff       	call   8010de <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
  801721:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801724:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	50                   	push   %eax
  801738:	6a 2f                	push   $0x2f
  80173a:	e8 9f f9 ff ff       	call   8010de <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
	return;
  801742:	90                   	nop
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801748:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	52                   	push   %edx
  801755:	50                   	push   %eax
  801756:	6a 30                	push   $0x30
  801758:	e8 81 f9 ff ff       	call   8010de <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
	return;
  801760:	90                   	nop
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
  801766:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	50                   	push   %eax
  801775:	6a 31                	push   $0x31
  801777:	e8 62 f9 ff ff       	call   8010de <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
  80177f:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801782:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	50                   	push   %eax
  801796:	6a 32                	push   $0x32
  801798:	e8 41 f9 ff ff       	call   8010de <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
	return;
  8017a0:	90                   	nop
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8017a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ac:	89 d0                	mov    %edx,%eax
  8017ae:	c1 e0 02             	shl    $0x2,%eax
  8017b1:	01 d0                	add    %edx,%eax
  8017b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ba:	01 d0                	add    %edx,%eax
  8017bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c3:	01 d0                	add    %edx,%eax
  8017c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017cc:	01 d0                	add    %edx,%eax
  8017ce:	c1 e0 04             	shl    $0x4,%eax
  8017d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8017d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8017db:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8017de:	83 ec 0c             	sub    $0xc,%esp
  8017e1:	50                   	push   %eax
  8017e2:	e8 2c fc ff ff       	call   801413 <sys_get_virtual_time>
  8017e7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8017ea:	eb 41                	jmp    80182d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8017ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8017ef:	83 ec 0c             	sub    $0xc,%esp
  8017f2:	50                   	push   %eax
  8017f3:	e8 1b fc ff ff       	call   801413 <sys_get_virtual_time>
  8017f8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8017fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801801:	29 c2                	sub    %eax,%edx
  801803:	89 d0                	mov    %edx,%eax
  801805:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801808:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80180b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180e:	89 d1                	mov    %edx,%ecx
  801810:	29 c1                	sub    %eax,%ecx
  801812:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801815:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801818:	39 c2                	cmp    %eax,%edx
  80181a:	0f 97 c0             	seta   %al
  80181d:	0f b6 c0             	movzbl %al,%eax
  801820:	29 c1                	sub    %eax,%ecx
  801822:	89 c8                	mov    %ecx,%eax
  801824:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801827:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80182a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80182d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801830:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801833:	72 b7                	jb     8017ec <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801835:	90                   	nop
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80183e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801845:	eb 03                	jmp    80184a <busy_wait+0x12>
  801847:	ff 45 fc             	incl   -0x4(%ebp)
  80184a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801850:	72 f5                	jb     801847 <busy_wait+0xf>
	return i;
  801852:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80185d:	8d 45 10             	lea    0x10(%ebp),%eax
  801860:	83 c0 04             	add    $0x4,%eax
  801863:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801866:	a1 2c 30 80 00       	mov    0x80302c,%eax
  80186b:	85 c0                	test   %eax,%eax
  80186d:	74 16                	je     801885 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80186f:	a1 2c 30 80 00       	mov    0x80302c,%eax
  801874:	83 ec 08             	sub    $0x8,%esp
  801877:	50                   	push   %eax
  801878:	68 f8 21 80 00       	push   $0x8021f8
  80187d:	e8 c2 ea ff ff       	call   800344 <cprintf>
  801882:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801885:	a1 00 30 80 00       	mov    0x803000,%eax
  80188a:	ff 75 0c             	pushl  0xc(%ebp)
  80188d:	ff 75 08             	pushl  0x8(%ebp)
  801890:	50                   	push   %eax
  801891:	68 fd 21 80 00       	push   $0x8021fd
  801896:	e8 a9 ea ff ff       	call   800344 <cprintf>
  80189b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80189e:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a7:	50                   	push   %eax
  8018a8:	e8 2c ea ff ff       	call   8002d9 <vcprintf>
  8018ad:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8018b0:	83 ec 08             	sub    $0x8,%esp
  8018b3:	6a 00                	push   $0x0
  8018b5:	68 19 22 80 00       	push   $0x802219
  8018ba:	e8 1a ea ff ff       	call   8002d9 <vcprintf>
  8018bf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8018c2:	e8 9b e9 ff ff       	call   800262 <exit>

	// should not return here
	while (1) ;
  8018c7:	eb fe                	jmp    8018c7 <_panic+0x70>

008018c9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8018cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8018d4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8018da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dd:	39 c2                	cmp    %eax,%edx
  8018df:	74 14                	je     8018f5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8018e1:	83 ec 04             	sub    $0x4,%esp
  8018e4:	68 1c 22 80 00       	push   $0x80221c
  8018e9:	6a 26                	push   $0x26
  8018eb:	68 68 22 80 00       	push   $0x802268
  8018f0:	e8 62 ff ff ff       	call   801857 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8018f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8018fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801903:	e9 c5 00 00 00       	jmp    8019cd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	01 d0                	add    %edx,%eax
  801917:	8b 00                	mov    (%eax),%eax
  801919:	85 c0                	test   %eax,%eax
  80191b:	75 08                	jne    801925 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80191d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801920:	e9 a5 00 00 00       	jmp    8019ca <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801925:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80192c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801933:	eb 69                	jmp    80199e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801935:	a1 04 30 80 00       	mov    0x803004,%eax
  80193a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801940:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801943:	89 d0                	mov    %edx,%eax
  801945:	01 c0                	add    %eax,%eax
  801947:	01 d0                	add    %edx,%eax
  801949:	c1 e0 03             	shl    $0x3,%eax
  80194c:	01 c8                	add    %ecx,%eax
  80194e:	8a 40 04             	mov    0x4(%eax),%al
  801951:	84 c0                	test   %al,%al
  801953:	75 46                	jne    80199b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801955:	a1 04 30 80 00       	mov    0x803004,%eax
  80195a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  801960:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801963:	89 d0                	mov    %edx,%eax
  801965:	01 c0                	add    %eax,%eax
  801967:	01 d0                	add    %edx,%eax
  801969:	c1 e0 03             	shl    $0x3,%eax
  80196c:	01 c8                	add    %ecx,%eax
  80196e:	8b 00                	mov    (%eax),%eax
  801970:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801973:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801976:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80197b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80197d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801980:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	01 c8                	add    %ecx,%eax
  80198c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80198e:	39 c2                	cmp    %eax,%edx
  801990:	75 09                	jne    80199b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801992:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801999:	eb 15                	jmp    8019b0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80199b:	ff 45 e8             	incl   -0x18(%ebp)
  80199e:	a1 04 30 80 00       	mov    0x803004,%eax
  8019a3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8019a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019ac:	39 c2                	cmp    %eax,%edx
  8019ae:	77 85                	ja     801935 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8019b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019b4:	75 14                	jne    8019ca <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8019b6:	83 ec 04             	sub    $0x4,%esp
  8019b9:	68 74 22 80 00       	push   $0x802274
  8019be:	6a 3a                	push   $0x3a
  8019c0:	68 68 22 80 00       	push   $0x802268
  8019c5:	e8 8d fe ff ff       	call   801857 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8019ca:	ff 45 f0             	incl   -0x10(%ebp)
  8019cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8019d3:	0f 8c 2f ff ff ff    	jl     801908 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8019d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8019e7:	eb 26                	jmp    801a0f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8019e9:	a1 04 30 80 00       	mov    0x803004,%eax
  8019ee:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8019f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019f7:	89 d0                	mov    %edx,%eax
  8019f9:	01 c0                	add    %eax,%eax
  8019fb:	01 d0                	add    %edx,%eax
  8019fd:	c1 e0 03             	shl    $0x3,%eax
  801a00:	01 c8                	add    %ecx,%eax
  801a02:	8a 40 04             	mov    0x4(%eax),%al
  801a05:	3c 01                	cmp    $0x1,%al
  801a07:	75 03                	jne    801a0c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801a09:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a0c:	ff 45 e0             	incl   -0x20(%ebp)
  801a0f:	a1 04 30 80 00       	mov    0x803004,%eax
  801a14:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801a1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a1d:	39 c2                	cmp    %eax,%edx
  801a1f:	77 c8                	ja     8019e9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801a27:	74 14                	je     801a3d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	68 c8 22 80 00       	push   $0x8022c8
  801a31:	6a 44                	push   $0x44
  801a33:	68 68 22 80 00       	push   $0x802268
  801a38:	e8 1a fe ff ff       	call   801857 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <__udivdi3>:
  801a40:	55                   	push   %ebp
  801a41:	57                   	push   %edi
  801a42:	56                   	push   %esi
  801a43:	53                   	push   %ebx
  801a44:	83 ec 1c             	sub    $0x1c,%esp
  801a47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a57:	89 ca                	mov    %ecx,%edx
  801a59:	89 f8                	mov    %edi,%eax
  801a5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a5f:	85 f6                	test   %esi,%esi
  801a61:	75 2d                	jne    801a90 <__udivdi3+0x50>
  801a63:	39 cf                	cmp    %ecx,%edi
  801a65:	77 65                	ja     801acc <__udivdi3+0x8c>
  801a67:	89 fd                	mov    %edi,%ebp
  801a69:	85 ff                	test   %edi,%edi
  801a6b:	75 0b                	jne    801a78 <__udivdi3+0x38>
  801a6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a72:	31 d2                	xor    %edx,%edx
  801a74:	f7 f7                	div    %edi
  801a76:	89 c5                	mov    %eax,%ebp
  801a78:	31 d2                	xor    %edx,%edx
  801a7a:	89 c8                	mov    %ecx,%eax
  801a7c:	f7 f5                	div    %ebp
  801a7e:	89 c1                	mov    %eax,%ecx
  801a80:	89 d8                	mov    %ebx,%eax
  801a82:	f7 f5                	div    %ebp
  801a84:	89 cf                	mov    %ecx,%edi
  801a86:	89 fa                	mov    %edi,%edx
  801a88:	83 c4 1c             	add    $0x1c,%esp
  801a8b:	5b                   	pop    %ebx
  801a8c:	5e                   	pop    %esi
  801a8d:	5f                   	pop    %edi
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    
  801a90:	39 ce                	cmp    %ecx,%esi
  801a92:	77 28                	ja     801abc <__udivdi3+0x7c>
  801a94:	0f bd fe             	bsr    %esi,%edi
  801a97:	83 f7 1f             	xor    $0x1f,%edi
  801a9a:	75 40                	jne    801adc <__udivdi3+0x9c>
  801a9c:	39 ce                	cmp    %ecx,%esi
  801a9e:	72 0a                	jb     801aaa <__udivdi3+0x6a>
  801aa0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801aa4:	0f 87 9e 00 00 00    	ja     801b48 <__udivdi3+0x108>
  801aaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801aaf:	89 fa                	mov    %edi,%edx
  801ab1:	83 c4 1c             	add    $0x1c,%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5f                   	pop    %edi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    
  801ab9:	8d 76 00             	lea    0x0(%esi),%esi
  801abc:	31 ff                	xor    %edi,%edi
  801abe:	31 c0                	xor    %eax,%eax
  801ac0:	89 fa                	mov    %edi,%edx
  801ac2:	83 c4 1c             	add    $0x1c,%esp
  801ac5:	5b                   	pop    %ebx
  801ac6:	5e                   	pop    %esi
  801ac7:	5f                   	pop    %edi
  801ac8:	5d                   	pop    %ebp
  801ac9:	c3                   	ret    
  801aca:	66 90                	xchg   %ax,%ax
  801acc:	89 d8                	mov    %ebx,%eax
  801ace:	f7 f7                	div    %edi
  801ad0:	31 ff                	xor    %edi,%edi
  801ad2:	89 fa                	mov    %edi,%edx
  801ad4:	83 c4 1c             	add    $0x1c,%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5f                   	pop    %edi
  801ada:	5d                   	pop    %ebp
  801adb:	c3                   	ret    
  801adc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ae1:	89 eb                	mov    %ebp,%ebx
  801ae3:	29 fb                	sub    %edi,%ebx
  801ae5:	89 f9                	mov    %edi,%ecx
  801ae7:	d3 e6                	shl    %cl,%esi
  801ae9:	89 c5                	mov    %eax,%ebp
  801aeb:	88 d9                	mov    %bl,%cl
  801aed:	d3 ed                	shr    %cl,%ebp
  801aef:	89 e9                	mov    %ebp,%ecx
  801af1:	09 f1                	or     %esi,%ecx
  801af3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801af7:	89 f9                	mov    %edi,%ecx
  801af9:	d3 e0                	shl    %cl,%eax
  801afb:	89 c5                	mov    %eax,%ebp
  801afd:	89 d6                	mov    %edx,%esi
  801aff:	88 d9                	mov    %bl,%cl
  801b01:	d3 ee                	shr    %cl,%esi
  801b03:	89 f9                	mov    %edi,%ecx
  801b05:	d3 e2                	shl    %cl,%edx
  801b07:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0b:	88 d9                	mov    %bl,%cl
  801b0d:	d3 e8                	shr    %cl,%eax
  801b0f:	09 c2                	or     %eax,%edx
  801b11:	89 d0                	mov    %edx,%eax
  801b13:	89 f2                	mov    %esi,%edx
  801b15:	f7 74 24 0c          	divl   0xc(%esp)
  801b19:	89 d6                	mov    %edx,%esi
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	f7 e5                	mul    %ebp
  801b1f:	39 d6                	cmp    %edx,%esi
  801b21:	72 19                	jb     801b3c <__udivdi3+0xfc>
  801b23:	74 0b                	je     801b30 <__udivdi3+0xf0>
  801b25:	89 d8                	mov    %ebx,%eax
  801b27:	31 ff                	xor    %edi,%edi
  801b29:	e9 58 ff ff ff       	jmp    801a86 <__udivdi3+0x46>
  801b2e:	66 90                	xchg   %ax,%ax
  801b30:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b34:	89 f9                	mov    %edi,%ecx
  801b36:	d3 e2                	shl    %cl,%edx
  801b38:	39 c2                	cmp    %eax,%edx
  801b3a:	73 e9                	jae    801b25 <__udivdi3+0xe5>
  801b3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b3f:	31 ff                	xor    %edi,%edi
  801b41:	e9 40 ff ff ff       	jmp    801a86 <__udivdi3+0x46>
  801b46:	66 90                	xchg   %ax,%ax
  801b48:	31 c0                	xor    %eax,%eax
  801b4a:	e9 37 ff ff ff       	jmp    801a86 <__udivdi3+0x46>
  801b4f:	90                   	nop

00801b50 <__umoddi3>:
  801b50:	55                   	push   %ebp
  801b51:	57                   	push   %edi
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	83 ec 1c             	sub    $0x1c,%esp
  801b57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b6f:	89 f3                	mov    %esi,%ebx
  801b71:	89 fa                	mov    %edi,%edx
  801b73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b77:	89 34 24             	mov    %esi,(%esp)
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	75 1a                	jne    801b98 <__umoddi3+0x48>
  801b7e:	39 f7                	cmp    %esi,%edi
  801b80:	0f 86 a2 00 00 00    	jbe    801c28 <__umoddi3+0xd8>
  801b86:	89 c8                	mov    %ecx,%eax
  801b88:	89 f2                	mov    %esi,%edx
  801b8a:	f7 f7                	div    %edi
  801b8c:	89 d0                	mov    %edx,%eax
  801b8e:	31 d2                	xor    %edx,%edx
  801b90:	83 c4 1c             	add    $0x1c,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    
  801b98:	39 f0                	cmp    %esi,%eax
  801b9a:	0f 87 ac 00 00 00    	ja     801c4c <__umoddi3+0xfc>
  801ba0:	0f bd e8             	bsr    %eax,%ebp
  801ba3:	83 f5 1f             	xor    $0x1f,%ebp
  801ba6:	0f 84 ac 00 00 00    	je     801c58 <__umoddi3+0x108>
  801bac:	bf 20 00 00 00       	mov    $0x20,%edi
  801bb1:	29 ef                	sub    %ebp,%edi
  801bb3:	89 fe                	mov    %edi,%esi
  801bb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801bb9:	89 e9                	mov    %ebp,%ecx
  801bbb:	d3 e0                	shl    %cl,%eax
  801bbd:	89 d7                	mov    %edx,%edi
  801bbf:	89 f1                	mov    %esi,%ecx
  801bc1:	d3 ef                	shr    %cl,%edi
  801bc3:	09 c7                	or     %eax,%edi
  801bc5:	89 e9                	mov    %ebp,%ecx
  801bc7:	d3 e2                	shl    %cl,%edx
  801bc9:	89 14 24             	mov    %edx,(%esp)
  801bcc:	89 d8                	mov    %ebx,%eax
  801bce:	d3 e0                	shl    %cl,%eax
  801bd0:	89 c2                	mov    %eax,%edx
  801bd2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd6:	d3 e0                	shl    %cl,%eax
  801bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801be0:	89 f1                	mov    %esi,%ecx
  801be2:	d3 e8                	shr    %cl,%eax
  801be4:	09 d0                	or     %edx,%eax
  801be6:	d3 eb                	shr    %cl,%ebx
  801be8:	89 da                	mov    %ebx,%edx
  801bea:	f7 f7                	div    %edi
  801bec:	89 d3                	mov    %edx,%ebx
  801bee:	f7 24 24             	mull   (%esp)
  801bf1:	89 c6                	mov    %eax,%esi
  801bf3:	89 d1                	mov    %edx,%ecx
  801bf5:	39 d3                	cmp    %edx,%ebx
  801bf7:	0f 82 87 00 00 00    	jb     801c84 <__umoddi3+0x134>
  801bfd:	0f 84 91 00 00 00    	je     801c94 <__umoddi3+0x144>
  801c03:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c07:	29 f2                	sub    %esi,%edx
  801c09:	19 cb                	sbb    %ecx,%ebx
  801c0b:	89 d8                	mov    %ebx,%eax
  801c0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c11:	d3 e0                	shl    %cl,%eax
  801c13:	89 e9                	mov    %ebp,%ecx
  801c15:	d3 ea                	shr    %cl,%edx
  801c17:	09 d0                	or     %edx,%eax
  801c19:	89 e9                	mov    %ebp,%ecx
  801c1b:	d3 eb                	shr    %cl,%ebx
  801c1d:	89 da                	mov    %ebx,%edx
  801c1f:	83 c4 1c             	add    $0x1c,%esp
  801c22:	5b                   	pop    %ebx
  801c23:	5e                   	pop    %esi
  801c24:	5f                   	pop    %edi
  801c25:	5d                   	pop    %ebp
  801c26:	c3                   	ret    
  801c27:	90                   	nop
  801c28:	89 fd                	mov    %edi,%ebp
  801c2a:	85 ff                	test   %edi,%edi
  801c2c:	75 0b                	jne    801c39 <__umoddi3+0xe9>
  801c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c33:	31 d2                	xor    %edx,%edx
  801c35:	f7 f7                	div    %edi
  801c37:	89 c5                	mov    %eax,%ebp
  801c39:	89 f0                	mov    %esi,%eax
  801c3b:	31 d2                	xor    %edx,%edx
  801c3d:	f7 f5                	div    %ebp
  801c3f:	89 c8                	mov    %ecx,%eax
  801c41:	f7 f5                	div    %ebp
  801c43:	89 d0                	mov    %edx,%eax
  801c45:	e9 44 ff ff ff       	jmp    801b8e <__umoddi3+0x3e>
  801c4a:	66 90                	xchg   %ax,%ax
  801c4c:	89 c8                	mov    %ecx,%eax
  801c4e:	89 f2                	mov    %esi,%edx
  801c50:	83 c4 1c             	add    $0x1c,%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5f                   	pop    %edi
  801c56:	5d                   	pop    %ebp
  801c57:	c3                   	ret    
  801c58:	3b 04 24             	cmp    (%esp),%eax
  801c5b:	72 06                	jb     801c63 <__umoddi3+0x113>
  801c5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c61:	77 0f                	ja     801c72 <__umoddi3+0x122>
  801c63:	89 f2                	mov    %esi,%edx
  801c65:	29 f9                	sub    %edi,%ecx
  801c67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c6b:	89 14 24             	mov    %edx,(%esp)
  801c6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c72:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c76:	8b 14 24             	mov    (%esp),%edx
  801c79:	83 c4 1c             	add    $0x1c,%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5f                   	pop    %edi
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    
  801c81:	8d 76 00             	lea    0x0(%esi),%esi
  801c84:	2b 04 24             	sub    (%esp),%eax
  801c87:	19 fa                	sbb    %edi,%edx
  801c89:	89 d1                	mov    %edx,%ecx
  801c8b:	89 c6                	mov    %eax,%esi
  801c8d:	e9 71 ff ff ff       	jmp    801c03 <__umoddi3+0xb3>
  801c92:	66 90                	xchg   %ax,%ax
  801c94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c98:	72 ea                	jb     801c84 <__umoddi3+0x134>
  801c9a:	89 d9                	mov    %ebx,%ecx
  801c9c:	e9 62 ff ff ff       	jmp    801c03 <__umoddi3+0xb3>
