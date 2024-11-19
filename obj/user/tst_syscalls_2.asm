
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
  80003e:	e8 5a 14 00 00       	call   80149d <rsttst>
	int ID1 = sys_create_env("tsc2_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800043:	a1 04 30 80 00       	mov    0x803004,%eax
  800048:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  80004e:	a1 04 30 80 00       	mov    0x803004,%eax
  800053:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  800059:	89 c1                	mov    %eax,%ecx
  80005b:	a1 04 30 80 00       	mov    0x803004,%eax
  800060:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800066:	52                   	push   %edx
  800067:	51                   	push   %ecx
  800068:	50                   	push   %eax
  800069:	68 00 1c 80 00       	push   $0x801c00
  80006e:	e8 de 12 00 00       	call   801351 <sys_create_env>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_run_env(ID1);
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	e8 eb 12 00 00       	call   80136f <sys_run_env>
  800084:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tsc2_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800087:	a1 04 30 80 00       	mov    0x803004,%eax
  80008c:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  800092:	a1 04 30 80 00       	mov    0x803004,%eax
  800097:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  80009d:	89 c1                	mov    %eax,%ecx
  80009f:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a4:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000aa:	52                   	push   %edx
  8000ab:	51                   	push   %ecx
  8000ac:	50                   	push   %eax
  8000ad:	68 0c 1c 80 00       	push   $0x801c0c
  8000b2:	e8 9a 12 00 00       	call   801351 <sys_create_env>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	sys_run_env(ID2);

	int ID3 = sys_create_env("tsc2_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000bd:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c2:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  8000c8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000cd:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  8000d3:	89 c1                	mov    %eax,%ecx
  8000d5:	a1 04 30 80 00       	mov    0x803004,%eax
  8000da:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e0:	52                   	push   %edx
  8000e1:	51                   	push   %ecx
  8000e2:	50                   	push   %eax
  8000e3:	68 18 1c 80 00       	push   $0x801c18
  8000e8:	e8 64 12 00 00       	call   801351 <sys_create_env>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
//	sys_run_env(ID3);
	env_sleep(10000);
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 10 27 00 00       	push   $0x2710
  8000fb:	e8 ff 15 00 00       	call   8016ff <env_sleep>
  800100:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  800103:	e8 0f 14 00 00       	call   801517 <gettst>
  800108:	85 c0                	test   %eax,%eax
  80010a:	74 12                	je     80011e <_main+0xe6>
		cprintf("\ntst_syscalls_2 Failed.\n");
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	68 24 1c 80 00       	push   $0x801c24
  800114:	e8 23 02 00 00       	call   80033c <cprintf>
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
  800121:	68 40 1c 80 00       	push   $0x801c40
  800126:	e8 11 02 00 00       	call   80033c <cprintf>
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
  800137:	e8 83 12 00 00       	call   8013bf <sys_getenvindex>
  80013c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800142:	89 d0                	mov    %edx,%eax
  800144:	c1 e0 02             	shl    $0x2,%eax
  800147:	01 d0                	add    %edx,%eax
  800149:	01 c0                	add    %eax,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	c1 e0 02             	shl    $0x2,%eax
  800150:	01 d0                	add    %edx,%eax
  800152:	01 c0                	add    %eax,%eax
  800154:	01 d0                	add    %edx,%eax
  800156:	c1 e0 04             	shl    $0x4,%eax
  800159:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015e:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800163:	a1 04 30 80 00       	mov    0x803004,%eax
  800168:	8a 40 20             	mov    0x20(%eax),%al
  80016b:	84 c0                	test   %al,%al
  80016d:	74 0d                	je     80017c <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80016f:	a1 04 30 80 00       	mov    0x803004,%eax
  800174:	83 c0 20             	add    $0x20,%eax
  800177:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800180:	7e 0a                	jle    80018c <libmain+0x5b>
		binaryname = argv[0];
  800182:	8b 45 0c             	mov    0xc(%ebp),%eax
  800185:	8b 00                	mov    (%eax),%eax
  800187:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80018c:	83 ec 08             	sub    $0x8,%esp
  80018f:	ff 75 0c             	pushl  0xc(%ebp)
  800192:	ff 75 08             	pushl  0x8(%ebp)
  800195:	e8 9e fe ff ff       	call   800038 <_main>
  80019a:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80019d:	e8 a1 0f 00 00       	call   801143 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	68 98 1c 80 00       	push   $0x801c98
  8001aa:	e8 8d 01 00 00       	call   80033c <cprintf>
  8001af:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001b2:	a1 04 30 80 00       	mov    0x803004,%eax
  8001b7:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  8001bd:	a1 04 30 80 00       	mov    0x803004,%eax
  8001c2:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  8001c8:	83 ec 04             	sub    $0x4,%esp
  8001cb:	52                   	push   %edx
  8001cc:	50                   	push   %eax
  8001cd:	68 c0 1c 80 00       	push   $0x801cc0
  8001d2:	e8 65 01 00 00       	call   80033c <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001da:	a1 04 30 80 00       	mov    0x803004,%eax
  8001df:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8001e5:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ea:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8001f0:	a1 04 30 80 00       	mov    0x803004,%eax
  8001f5:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8001fb:	51                   	push   %ecx
  8001fc:	52                   	push   %edx
  8001fd:	50                   	push   %eax
  8001fe:	68 e8 1c 80 00       	push   $0x801ce8
  800203:	e8 34 01 00 00       	call   80033c <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80020b:	a1 04 30 80 00       	mov    0x803004,%eax
  800210:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  800216:	83 ec 08             	sub    $0x8,%esp
  800219:	50                   	push   %eax
  80021a:	68 40 1d 80 00       	push   $0x801d40
  80021f:	e8 18 01 00 00       	call   80033c <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 98 1c 80 00       	push   $0x801c98
  80022f:	e8 08 01 00 00       	call   80033c <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800237:	e8 21 0f 00 00       	call   80115d <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80023c:	e8 19 00 00 00       	call   80025a <exit>
}
  800241:	90                   	nop
  800242:	c9                   	leave  
  800243:	c3                   	ret    

00800244 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	6a 00                	push   $0x0
  80024f:	e8 37 11 00 00       	call   80138b <sys_destroy_env>
  800254:	83 c4 10             	add    $0x10,%esp
}
  800257:	90                   	nop
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <exit>:

void
exit(void)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800260:	e8 8c 11 00 00       	call   8013f1 <sys_exit_env>
}
  800265:	90                   	nop
  800266:	c9                   	leave  
  800267:	c3                   	ret    

00800268 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800271:	8b 00                	mov    (%eax),%eax
  800273:	8d 48 01             	lea    0x1(%eax),%ecx
  800276:	8b 55 0c             	mov    0xc(%ebp),%edx
  800279:	89 0a                	mov    %ecx,(%edx)
  80027b:	8b 55 08             	mov    0x8(%ebp),%edx
  80027e:	88 d1                	mov    %dl,%cl
  800280:	8b 55 0c             	mov    0xc(%ebp),%edx
  800283:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028a:	8b 00                	mov    (%eax),%eax
  80028c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800291:	75 2c                	jne    8002bf <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800293:	a0 08 30 80 00       	mov    0x803008,%al
  800298:	0f b6 c0             	movzbl %al,%eax
  80029b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029e:	8b 12                	mov    (%edx),%edx
  8002a0:	89 d1                	mov    %edx,%ecx
  8002a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a5:	83 c2 08             	add    $0x8,%edx
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	50                   	push   %eax
  8002ac:	51                   	push   %ecx
  8002ad:	52                   	push   %edx
  8002ae:	e8 4e 0e 00 00       	call   801101 <sys_cputs>
  8002b3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c2:	8b 40 04             	mov    0x4(%eax),%eax
  8002c5:	8d 50 01             	lea    0x1(%eax),%edx
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002ce:	90                   	nop
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002da:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002e1:	00 00 00 
	b.cnt = 0;
  8002e4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002eb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002ee:	ff 75 0c             	pushl  0xc(%ebp)
  8002f1:	ff 75 08             	pushl  0x8(%ebp)
  8002f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002fa:	50                   	push   %eax
  8002fb:	68 68 02 80 00       	push   $0x800268
  800300:	e8 11 02 00 00       	call   800516 <vprintfmt>
  800305:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800308:	a0 08 30 80 00       	mov    0x803008,%al
  80030d:	0f b6 c0             	movzbl %al,%eax
  800310:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800316:	83 ec 04             	sub    $0x4,%esp
  800319:	50                   	push   %eax
  80031a:	52                   	push   %edx
  80031b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800321:	83 c0 08             	add    $0x8,%eax
  800324:	50                   	push   %eax
  800325:	e8 d7 0d 00 00       	call   801101 <sys_cputs>
  80032a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80032d:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800334:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80033a:	c9                   	leave  
  80033b:	c3                   	ret    

0080033c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800342:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800349:	8d 45 0c             	lea    0xc(%ebp),%eax
  80034c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80034f:	8b 45 08             	mov    0x8(%ebp),%eax
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	ff 75 f4             	pushl  -0xc(%ebp)
  800358:	50                   	push   %eax
  800359:	e8 73 ff ff ff       	call   8002d1 <vcprintf>
  80035e:	83 c4 10             	add    $0x10,%esp
  800361:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800364:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800367:	c9                   	leave  
  800368:	c3                   	ret    

00800369 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800369:	55                   	push   %ebp
  80036a:	89 e5                	mov    %esp,%ebp
  80036c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80036f:	e8 cf 0d 00 00       	call   801143 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800374:	8d 45 0c             	lea    0xc(%ebp),%eax
  800377:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80037a:	8b 45 08             	mov    0x8(%ebp),%eax
  80037d:	83 ec 08             	sub    $0x8,%esp
  800380:	ff 75 f4             	pushl  -0xc(%ebp)
  800383:	50                   	push   %eax
  800384:	e8 48 ff ff ff       	call   8002d1 <vcprintf>
  800389:	83 c4 10             	add    $0x10,%esp
  80038c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80038f:	e8 c9 0d 00 00       	call   80115d <sys_unlock_cons>
	return cnt;
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800397:	c9                   	leave  
  800398:	c3                   	ret    

00800399 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	53                   	push   %ebx
  80039d:	83 ec 14             	sub    $0x14,%esp
  8003a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ac:	8b 45 18             	mov    0x18(%ebp),%eax
  8003af:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003b7:	77 55                	ja     80040e <printnum+0x75>
  8003b9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003bc:	72 05                	jb     8003c3 <printnum+0x2a>
  8003be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003c1:	77 4b                	ja     80040e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003c6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003c9:	8b 45 18             	mov    0x18(%ebp),%eax
  8003cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d1:	52                   	push   %edx
  8003d2:	50                   	push   %eax
  8003d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8003d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d9:	e8 be 15 00 00       	call   80199c <__udivdi3>
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	83 ec 04             	sub    $0x4,%esp
  8003e4:	ff 75 20             	pushl  0x20(%ebp)
  8003e7:	53                   	push   %ebx
  8003e8:	ff 75 18             	pushl  0x18(%ebp)
  8003eb:	52                   	push   %edx
  8003ec:	50                   	push   %eax
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	ff 75 08             	pushl  0x8(%ebp)
  8003f3:	e8 a1 ff ff ff       	call   800399 <printnum>
  8003f8:	83 c4 20             	add    $0x20,%esp
  8003fb:	eb 1a                	jmp    800417 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003fd:	83 ec 08             	sub    $0x8,%esp
  800400:	ff 75 0c             	pushl  0xc(%ebp)
  800403:	ff 75 20             	pushl  0x20(%ebp)
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	ff d0                	call   *%eax
  80040b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80040e:	ff 4d 1c             	decl   0x1c(%ebp)
  800411:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800415:	7f e6                	jg     8003fd <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800417:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80041a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800425:	53                   	push   %ebx
  800426:	51                   	push   %ecx
  800427:	52                   	push   %edx
  800428:	50                   	push   %eax
  800429:	e8 7e 16 00 00       	call   801aac <__umoddi3>
  80042e:	83 c4 10             	add    $0x10,%esp
  800431:	05 74 1f 80 00       	add    $0x801f74,%eax
  800436:	8a 00                	mov    (%eax),%al
  800438:	0f be c0             	movsbl %al,%eax
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	ff 75 0c             	pushl  0xc(%ebp)
  800441:	50                   	push   %eax
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	ff d0                	call   *%eax
  800447:	83 c4 10             	add    $0x10,%esp
}
  80044a:	90                   	nop
  80044b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80044e:	c9                   	leave  
  80044f:	c3                   	ret    

00800450 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800453:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800457:	7e 1c                	jle    800475 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	8d 50 08             	lea    0x8(%eax),%edx
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	89 10                	mov    %edx,(%eax)
  800466:	8b 45 08             	mov    0x8(%ebp),%eax
  800469:	8b 00                	mov    (%eax),%eax
  80046b:	83 e8 08             	sub    $0x8,%eax
  80046e:	8b 50 04             	mov    0x4(%eax),%edx
  800471:	8b 00                	mov    (%eax),%eax
  800473:	eb 40                	jmp    8004b5 <getuint+0x65>
	else if (lflag)
  800475:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800479:	74 1e                	je     800499 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	8d 50 04             	lea    0x4(%eax),%edx
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	89 10                	mov    %edx,(%eax)
  800488:	8b 45 08             	mov    0x8(%ebp),%eax
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	83 e8 04             	sub    $0x4,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	ba 00 00 00 00       	mov    $0x0,%edx
  800497:	eb 1c                	jmp    8004b5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 50 04             	lea    0x4(%eax),%edx
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 10                	mov    %edx,(%eax)
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 e8 04             	sub    $0x4,%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004b5:	5d                   	pop    %ebp
  8004b6:	c3                   	ret    

008004b7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ba:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004be:	7e 1c                	jle    8004dc <getint+0x25>
		return va_arg(*ap, long long);
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	8d 50 08             	lea    0x8(%eax),%edx
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	89 10                	mov    %edx,(%eax)
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	83 e8 08             	sub    $0x8,%eax
  8004d5:	8b 50 04             	mov    0x4(%eax),%edx
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	eb 38                	jmp    800514 <getint+0x5d>
	else if (lflag)
  8004dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004e0:	74 1a                	je     8004fc <getint+0x45>
		return va_arg(*ap, long);
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	8d 50 04             	lea    0x4(%eax),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	89 10                	mov    %edx,(%eax)
  8004ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	83 e8 04             	sub    $0x4,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	99                   	cltd   
  8004fa:	eb 18                	jmp    800514 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	8d 50 04             	lea    0x4(%eax),%edx
  800504:	8b 45 08             	mov    0x8(%ebp),%eax
  800507:	89 10                	mov    %edx,(%eax)
  800509:	8b 45 08             	mov    0x8(%ebp),%eax
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	83 e8 04             	sub    $0x4,%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	99                   	cltd   
}
  800514:	5d                   	pop    %ebp
  800515:	c3                   	ret    

00800516 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800516:	55                   	push   %ebp
  800517:	89 e5                	mov    %esp,%ebp
  800519:	56                   	push   %esi
  80051a:	53                   	push   %ebx
  80051b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80051e:	eb 17                	jmp    800537 <vprintfmt+0x21>
			if (ch == '\0')
  800520:	85 db                	test   %ebx,%ebx
  800522:	0f 84 c1 03 00 00    	je     8008e9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800528:	83 ec 08             	sub    $0x8,%esp
  80052b:	ff 75 0c             	pushl  0xc(%ebp)
  80052e:	53                   	push   %ebx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	ff d0                	call   *%eax
  800534:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800537:	8b 45 10             	mov    0x10(%ebp),%eax
  80053a:	8d 50 01             	lea    0x1(%eax),%edx
  80053d:	89 55 10             	mov    %edx,0x10(%ebp)
  800540:	8a 00                	mov    (%eax),%al
  800542:	0f b6 d8             	movzbl %al,%ebx
  800545:	83 fb 25             	cmp    $0x25,%ebx
  800548:	75 d6                	jne    800520 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80054a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80054e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800555:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80055c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800563:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056a:	8b 45 10             	mov    0x10(%ebp),%eax
  80056d:	8d 50 01             	lea    0x1(%eax),%edx
  800570:	89 55 10             	mov    %edx,0x10(%ebp)
  800573:	8a 00                	mov    (%eax),%al
  800575:	0f b6 d8             	movzbl %al,%ebx
  800578:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80057b:	83 f8 5b             	cmp    $0x5b,%eax
  80057e:	0f 87 3d 03 00 00    	ja     8008c1 <vprintfmt+0x3ab>
  800584:	8b 04 85 98 1f 80 00 	mov    0x801f98(,%eax,4),%eax
  80058b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80058d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800591:	eb d7                	jmp    80056a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800593:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800597:	eb d1                	jmp    80056a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800599:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a3:	89 d0                	mov    %edx,%eax
  8005a5:	c1 e0 02             	shl    $0x2,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	01 c0                	add    %eax,%eax
  8005ac:	01 d8                	add    %ebx,%eax
  8005ae:	83 e8 30             	sub    $0x30,%eax
  8005b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005b7:	8a 00                	mov    (%eax),%al
  8005b9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005bc:	83 fb 2f             	cmp    $0x2f,%ebx
  8005bf:	7e 3e                	jle    8005ff <vprintfmt+0xe9>
  8005c1:	83 fb 39             	cmp    $0x39,%ebx
  8005c4:	7f 39                	jg     8005ff <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005c6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005c9:	eb d5                	jmp    8005a0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	83 c0 04             	add    $0x4,%eax
  8005d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	83 e8 04             	sub    $0x4,%eax
  8005da:	8b 00                	mov    (%eax),%eax
  8005dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005df:	eb 1f                	jmp    800600 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e5:	79 83                	jns    80056a <vprintfmt+0x54>
				width = 0;
  8005e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005ee:	e9 77 ff ff ff       	jmp    80056a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005f3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005fa:	e9 6b ff ff ff       	jmp    80056a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005ff:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800600:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800604:	0f 89 60 ff ff ff    	jns    80056a <vprintfmt+0x54>
				width = precision, precision = -1;
  80060a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80060d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800610:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800617:	e9 4e ff ff ff       	jmp    80056a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80061c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80061f:	e9 46 ff ff ff       	jmp    80056a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	83 c0 04             	add    $0x4,%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	83 e8 04             	sub    $0x4,%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	50                   	push   %eax
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	ff d0                	call   *%eax
  800641:	83 c4 10             	add    $0x10,%esp
			break;
  800644:	e9 9b 02 00 00       	jmp    8008e4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	83 c0 04             	add    $0x4,%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	83 e8 04             	sub    $0x4,%eax
  800658:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80065a:	85 db                	test   %ebx,%ebx
  80065c:	79 02                	jns    800660 <vprintfmt+0x14a>
				err = -err;
  80065e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800660:	83 fb 64             	cmp    $0x64,%ebx
  800663:	7f 0b                	jg     800670 <vprintfmt+0x15a>
  800665:	8b 34 9d e0 1d 80 00 	mov    0x801de0(,%ebx,4),%esi
  80066c:	85 f6                	test   %esi,%esi
  80066e:	75 19                	jne    800689 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800670:	53                   	push   %ebx
  800671:	68 85 1f 80 00       	push   $0x801f85
  800676:	ff 75 0c             	pushl  0xc(%ebp)
  800679:	ff 75 08             	pushl  0x8(%ebp)
  80067c:	e8 70 02 00 00       	call   8008f1 <printfmt>
  800681:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800684:	e9 5b 02 00 00       	jmp    8008e4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800689:	56                   	push   %esi
  80068a:	68 8e 1f 80 00       	push   $0x801f8e
  80068f:	ff 75 0c             	pushl  0xc(%ebp)
  800692:	ff 75 08             	pushl  0x8(%ebp)
  800695:	e8 57 02 00 00       	call   8008f1 <printfmt>
  80069a:	83 c4 10             	add    $0x10,%esp
			break;
  80069d:	e9 42 02 00 00       	jmp    8008e4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	83 c0 04             	add    $0x4,%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	83 e8 04             	sub    $0x4,%eax
  8006b1:	8b 30                	mov    (%eax),%esi
  8006b3:	85 f6                	test   %esi,%esi
  8006b5:	75 05                	jne    8006bc <vprintfmt+0x1a6>
				p = "(null)";
  8006b7:	be 91 1f 80 00       	mov    $0x801f91,%esi
			if (width > 0 && padc != '-')
  8006bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c0:	7e 6d                	jle    80072f <vprintfmt+0x219>
  8006c2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006c6:	74 67                	je     80072f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	50                   	push   %eax
  8006cf:	56                   	push   %esi
  8006d0:	e8 1e 03 00 00       	call   8009f3 <strnlen>
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006db:	eb 16                	jmp    8006f3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006dd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	ff 75 0c             	pushl  0xc(%ebp)
  8006e7:	50                   	push   %eax
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006f0:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f7:	7f e4                	jg     8006dd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f9:	eb 34                	jmp    80072f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006fb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ff:	74 1c                	je     80071d <vprintfmt+0x207>
  800701:	83 fb 1f             	cmp    $0x1f,%ebx
  800704:	7e 05                	jle    80070b <vprintfmt+0x1f5>
  800706:	83 fb 7e             	cmp    $0x7e,%ebx
  800709:	7e 12                	jle    80071d <vprintfmt+0x207>
					putch('?', putdat);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 0c             	pushl  0xc(%ebp)
  800711:	6a 3f                	push   $0x3f
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	ff d0                	call   *%eax
  800718:	83 c4 10             	add    $0x10,%esp
  80071b:	eb 0f                	jmp    80072c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	53                   	push   %ebx
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80072c:	ff 4d e4             	decl   -0x1c(%ebp)
  80072f:	89 f0                	mov    %esi,%eax
  800731:	8d 70 01             	lea    0x1(%eax),%esi
  800734:	8a 00                	mov    (%eax),%al
  800736:	0f be d8             	movsbl %al,%ebx
  800739:	85 db                	test   %ebx,%ebx
  80073b:	74 24                	je     800761 <vprintfmt+0x24b>
  80073d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800741:	78 b8                	js     8006fb <vprintfmt+0x1e5>
  800743:	ff 4d e0             	decl   -0x20(%ebp)
  800746:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074a:	79 af                	jns    8006fb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80074c:	eb 13                	jmp    800761 <vprintfmt+0x24b>
				putch(' ', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	6a 20                	push   $0x20
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	ff d0                	call   *%eax
  80075b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80075e:	ff 4d e4             	decl   -0x1c(%ebp)
  800761:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800765:	7f e7                	jg     80074e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800767:	e9 78 01 00 00       	jmp    8008e4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	ff 75 e8             	pushl  -0x18(%ebp)
  800772:	8d 45 14             	lea    0x14(%ebp),%eax
  800775:	50                   	push   %eax
  800776:	e8 3c fd ff ff       	call   8004b7 <getint>
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800781:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800787:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80078a:	85 d2                	test   %edx,%edx
  80078c:	79 23                	jns    8007b1 <vprintfmt+0x29b>
				putch('-', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	6a 2d                	push   $0x2d
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	ff d0                	call   *%eax
  80079b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80079e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a4:	f7 d8                	neg    %eax
  8007a6:	83 d2 00             	adc    $0x0,%edx
  8007a9:	f7 da                	neg    %edx
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007b1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007b8:	e9 bc 00 00 00       	jmp    800879 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 e8             	pushl  -0x18(%ebp)
  8007c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c6:	50                   	push   %eax
  8007c7:	e8 84 fc ff ff       	call   800450 <getuint>
  8007cc:	83 c4 10             	add    $0x10,%esp
  8007cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007d5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007dc:	e9 98 00 00 00       	jmp    800879 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007e1:	83 ec 08             	sub    $0x8,%esp
  8007e4:	ff 75 0c             	pushl  0xc(%ebp)
  8007e7:	6a 58                	push   $0x58
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	ff d0                	call   *%eax
  8007ee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007f1:	83 ec 08             	sub    $0x8,%esp
  8007f4:	ff 75 0c             	pushl  0xc(%ebp)
  8007f7:	6a 58                	push   $0x58
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	ff d0                	call   *%eax
  8007fe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800801:	83 ec 08             	sub    $0x8,%esp
  800804:	ff 75 0c             	pushl  0xc(%ebp)
  800807:	6a 58                	push   $0x58
  800809:	8b 45 08             	mov    0x8(%ebp),%eax
  80080c:	ff d0                	call   *%eax
  80080e:	83 c4 10             	add    $0x10,%esp
			break;
  800811:	e9 ce 00 00 00       	jmp    8008e4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	ff 75 0c             	pushl  0xc(%ebp)
  80081c:	6a 30                	push   $0x30
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	ff d0                	call   *%eax
  800823:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800826:	83 ec 08             	sub    $0x8,%esp
  800829:	ff 75 0c             	pushl  0xc(%ebp)
  80082c:	6a 78                	push   $0x78
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	ff d0                	call   *%eax
  800833:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	83 c0 04             	add    $0x4,%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	83 e8 04             	sub    $0x4,%eax
  800845:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800847:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80084a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800851:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800858:	eb 1f                	jmp    800879 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 e8             	pushl  -0x18(%ebp)
  800860:	8d 45 14             	lea    0x14(%ebp),%eax
  800863:	50                   	push   %eax
  800864:	e8 e7 fb ff ff       	call   800450 <getuint>
  800869:	83 c4 10             	add    $0x10,%esp
  80086c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800872:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800879:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80087d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800880:	83 ec 04             	sub    $0x4,%esp
  800883:	52                   	push   %edx
  800884:	ff 75 e4             	pushl  -0x1c(%ebp)
  800887:	50                   	push   %eax
  800888:	ff 75 f4             	pushl  -0xc(%ebp)
  80088b:	ff 75 f0             	pushl  -0x10(%ebp)
  80088e:	ff 75 0c             	pushl  0xc(%ebp)
  800891:	ff 75 08             	pushl  0x8(%ebp)
  800894:	e8 00 fb ff ff       	call   800399 <printnum>
  800899:	83 c4 20             	add    $0x20,%esp
			break;
  80089c:	eb 46                	jmp    8008e4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	ff 75 0c             	pushl  0xc(%ebp)
  8008a4:	53                   	push   %ebx
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	ff d0                	call   *%eax
  8008aa:	83 c4 10             	add    $0x10,%esp
			break;
  8008ad:	eb 35                	jmp    8008e4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008af:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8008b6:	eb 2c                	jmp    8008e4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008b8:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8008bf:	eb 23                	jmp    8008e4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	6a 25                	push   $0x25
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d1:	ff 4d 10             	decl   0x10(%ebp)
  8008d4:	eb 03                	jmp    8008d9 <vprintfmt+0x3c3>
  8008d6:	ff 4d 10             	decl   0x10(%ebp)
  8008d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008dc:	48                   	dec    %eax
  8008dd:	8a 00                	mov    (%eax),%al
  8008df:	3c 25                	cmp    $0x25,%al
  8008e1:	75 f3                	jne    8008d6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008e3:	90                   	nop
		}
	}
  8008e4:	e9 35 fc ff ff       	jmp    80051e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008e9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008ed:	5b                   	pop    %ebx
  8008ee:	5e                   	pop    %esi
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f7:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fa:	83 c0 04             	add    $0x4,%eax
  8008fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800900:	8b 45 10             	mov    0x10(%ebp),%eax
  800903:	ff 75 f4             	pushl  -0xc(%ebp)
  800906:	50                   	push   %eax
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	ff 75 08             	pushl  0x8(%ebp)
  80090d:	e8 04 fc ff ff       	call   800516 <vprintfmt>
  800912:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800915:	90                   	nop
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80091b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091e:	8b 40 08             	mov    0x8(%eax),%eax
  800921:	8d 50 01             	lea    0x1(%eax),%edx
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80092a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092d:	8b 10                	mov    (%eax),%edx
  80092f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800932:	8b 40 04             	mov    0x4(%eax),%eax
  800935:	39 c2                	cmp    %eax,%edx
  800937:	73 12                	jae    80094b <sprintputch+0x33>
		*b->buf++ = ch;
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	8d 48 01             	lea    0x1(%eax),%ecx
  800941:	8b 55 0c             	mov    0xc(%ebp),%edx
  800944:	89 0a                	mov    %ecx,(%edx)
  800946:	8b 55 08             	mov    0x8(%ebp),%edx
  800949:	88 10                	mov    %dl,(%eax)
}
  80094b:	90                   	nop
  80094c:	5d                   	pop    %ebp
  80094d:	c3                   	ret    

0080094e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80095a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	01 d0                	add    %edx,%eax
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80096f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800973:	74 06                	je     80097b <vsnprintf+0x2d>
  800975:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800979:	7f 07                	jg     800982 <vsnprintf+0x34>
		return -E_INVAL;
  80097b:	b8 03 00 00 00       	mov    $0x3,%eax
  800980:	eb 20                	jmp    8009a2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800982:	ff 75 14             	pushl  0x14(%ebp)
  800985:	ff 75 10             	pushl  0x10(%ebp)
  800988:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80098b:	50                   	push   %eax
  80098c:	68 18 09 80 00       	push   $0x800918
  800991:	e8 80 fb ff ff       	call   800516 <vprintfmt>
  800996:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800999:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80099f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009a2:	c9                   	leave  
  8009a3:	c3                   	ret    

008009a4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ad:	83 c0 04             	add    $0x4,%eax
  8009b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b9:	50                   	push   %eax
  8009ba:	ff 75 0c             	pushl  0xc(%ebp)
  8009bd:	ff 75 08             	pushl  0x8(%ebp)
  8009c0:	e8 89 ff ff ff       	call   80094e <vsnprintf>
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    

008009d0 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009dd:	eb 06                	jmp    8009e5 <strlen+0x15>
		n++;
  8009df:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e2:	ff 45 08             	incl   0x8(%ebp)
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8a 00                	mov    (%eax),%al
  8009ea:	84 c0                	test   %al,%al
  8009ec:	75 f1                	jne    8009df <strlen+0xf>
		n++;
	return n;
  8009ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009f1:	c9                   	leave  
  8009f2:	c3                   	ret    

008009f3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a00:	eb 09                	jmp    800a0b <strnlen+0x18>
		n++;
  800a02:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a05:	ff 45 08             	incl   0x8(%ebp)
  800a08:	ff 4d 0c             	decl   0xc(%ebp)
  800a0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a0f:	74 09                	je     800a1a <strnlen+0x27>
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8a 00                	mov    (%eax),%al
  800a16:	84 c0                	test   %al,%al
  800a18:	75 e8                	jne    800a02 <strnlen+0xf>
		n++;
	return n;
  800a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    

00800a1f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a2b:	90                   	nop
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8d 50 01             	lea    0x1(%eax),%edx
  800a32:	89 55 08             	mov    %edx,0x8(%ebp)
  800a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a38:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a3b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a3e:	8a 12                	mov    (%edx),%dl
  800a40:	88 10                	mov    %dl,(%eax)
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 e4                	jne    800a2c <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a60:	eb 1f                	jmp    800a81 <strncpy+0x34>
		*dst++ = *src;
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8d 50 01             	lea    0x1(%eax),%edx
  800a68:	89 55 08             	mov    %edx,0x8(%ebp)
  800a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6e:	8a 12                	mov    (%edx),%dl
  800a70:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a75:	8a 00                	mov    (%eax),%al
  800a77:	84 c0                	test   %al,%al
  800a79:	74 03                	je     800a7e <strncpy+0x31>
			src++;
  800a7b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a7e:	ff 45 fc             	incl   -0x4(%ebp)
  800a81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a84:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a87:	72 d9                	jb     800a62 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a8c:	c9                   	leave  
  800a8d:	c3                   	ret    

00800a8e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a9e:	74 30                	je     800ad0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800aa0:	eb 16                	jmp    800ab8 <strlcpy+0x2a>
			*dst++ = *src++;
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8d 50 01             	lea    0x1(%eax),%edx
  800aa8:	89 55 08             	mov    %edx,0x8(%ebp)
  800aab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aae:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ab1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ab4:	8a 12                	mov    (%edx),%dl
  800ab6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab8:	ff 4d 10             	decl   0x10(%ebp)
  800abb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800abf:	74 09                	je     800aca <strlcpy+0x3c>
  800ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac4:	8a 00                	mov    (%eax),%al
  800ac6:	84 c0                	test   %al,%al
  800ac8:	75 d8                	jne    800aa2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ad0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad6:	29 c2                	sub    %eax,%edx
  800ad8:	89 d0                	mov    %edx,%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800adf:	eb 06                	jmp    800ae7 <strcmp+0xb>
		p++, q++;
  800ae1:	ff 45 08             	incl   0x8(%ebp)
  800ae4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8a 00                	mov    (%eax),%al
  800aec:	84 c0                	test   %al,%al
  800aee:	74 0e                	je     800afe <strcmp+0x22>
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	8a 10                	mov    (%eax),%dl
  800af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af8:	8a 00                	mov    (%eax),%al
  800afa:	38 c2                	cmp    %al,%dl
  800afc:	74 e3                	je     800ae1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8a 00                	mov    (%eax),%al
  800b03:	0f b6 d0             	movzbl %al,%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8a 00                	mov    (%eax),%al
  800b0b:	0f b6 c0             	movzbl %al,%eax
  800b0e:	29 c2                	sub    %eax,%edx
  800b10:	89 d0                	mov    %edx,%eax
}
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b17:	eb 09                	jmp    800b22 <strncmp+0xe>
		n--, p++, q++;
  800b19:	ff 4d 10             	decl   0x10(%ebp)
  800b1c:	ff 45 08             	incl   0x8(%ebp)
  800b1f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b26:	74 17                	je     800b3f <strncmp+0x2b>
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	8a 00                	mov    (%eax),%al
  800b2d:	84 c0                	test   %al,%al
  800b2f:	74 0e                	je     800b3f <strncmp+0x2b>
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	8a 10                	mov    (%eax),%dl
  800b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b39:	8a 00                	mov    (%eax),%al
  800b3b:	38 c2                	cmp    %al,%dl
  800b3d:	74 da                	je     800b19 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b43:	75 07                	jne    800b4c <strncmp+0x38>
		return 0;
  800b45:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4a:	eb 14                	jmp    800b60 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8a 00                	mov    (%eax),%al
  800b51:	0f b6 d0             	movzbl %al,%edx
  800b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b57:	8a 00                	mov    (%eax),%al
  800b59:	0f b6 c0             	movzbl %al,%eax
  800b5c:	29 c2                	sub    %eax,%edx
  800b5e:	89 d0                	mov    %edx,%eax
}
  800b60:	5d                   	pop    %ebp
  800b61:	c3                   	ret    

00800b62 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	83 ec 04             	sub    $0x4,%esp
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b6e:	eb 12                	jmp    800b82 <strchr+0x20>
		if (*s == c)
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	8a 00                	mov    (%eax),%al
  800b75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b78:	75 05                	jne    800b7f <strchr+0x1d>
			return (char *) s;
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	eb 11                	jmp    800b90 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b7f:	ff 45 08             	incl   0x8(%ebp)
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	84 c0                	test   %al,%al
  800b89:	75 e5                	jne    800b70 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b90:	c9                   	leave  
  800b91:	c3                   	ret    

00800b92 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	83 ec 04             	sub    $0x4,%esp
  800b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9e:	eb 0d                	jmp    800bad <strfind+0x1b>
		if (*s == c)
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	8a 00                	mov    (%eax),%al
  800ba5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba8:	74 0e                	je     800bb8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800baa:	ff 45 08             	incl   0x8(%ebp)
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8a 00                	mov    (%eax),%al
  800bb2:	84 c0                	test   %al,%al
  800bb4:	75 ea                	jne    800ba0 <strfind+0xe>
  800bb6:	eb 01                	jmp    800bb9 <strfind+0x27>
		if (*s == c)
			break;
  800bb8:	90                   	nop
	return (char *) s;
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bbc:	c9                   	leave  
  800bbd:	c3                   	ret    

00800bbe <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bbe:	55                   	push   %ebp
  800bbf:	89 e5                	mov    %esp,%ebp
  800bc1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bca:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bd0:	eb 0e                	jmp    800be0 <memset+0x22>
		*p++ = c;
  800bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd5:	8d 50 01             	lea    0x1(%eax),%edx
  800bd8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bde:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800be0:	ff 4d f8             	decl   -0x8(%ebp)
  800be3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800be7:	79 e9                	jns    800bd2 <memset+0x14>
		*p++ = c;

	return v;
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c00:	eb 16                	jmp    800c18 <memcpy+0x2a>
		*d++ = *s++;
  800c02:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c0e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c11:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c14:	8a 12                	mov    (%edx),%dl
  800c16:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c18:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c21:	85 c0                	test   %eax,%eax
  800c23:	75 dd                	jne    800c02 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c42:	73 50                	jae    800c94 <memmove+0x6a>
  800c44:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c47:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4a:	01 d0                	add    %edx,%eax
  800c4c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c4f:	76 43                	jbe    800c94 <memmove+0x6a>
		s += n;
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c57:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c5d:	eb 10                	jmp    800c6f <memmove+0x45>
			*--d = *--s;
  800c5f:	ff 4d f8             	decl   -0x8(%ebp)
  800c62:	ff 4d fc             	decl   -0x4(%ebp)
  800c65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c68:	8a 10                	mov    (%eax),%dl
  800c6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c6d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c75:	89 55 10             	mov    %edx,0x10(%ebp)
  800c78:	85 c0                	test   %eax,%eax
  800c7a:	75 e3                	jne    800c5f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c7c:	eb 23                	jmp    800ca1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c87:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c8a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c90:	8a 12                	mov    (%edx),%dl
  800c92:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c94:	8b 45 10             	mov    0x10(%ebp),%eax
  800c97:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c9a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c9d:	85 c0                	test   %eax,%eax
  800c9f:	75 dd                	jne    800c7e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ca4:	c9                   	leave  
  800ca5:	c3                   	ret    

00800ca6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cb8:	eb 2a                	jmp    800ce4 <memcmp+0x3e>
		if (*s1 != *s2)
  800cba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbd:	8a 10                	mov    (%eax),%dl
  800cbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	38 c2                	cmp    %al,%dl
  800cc6:	74 16                	je     800cde <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccb:	8a 00                	mov    (%eax),%al
  800ccd:	0f b6 d0             	movzbl %al,%edx
  800cd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	0f b6 c0             	movzbl %al,%eax
  800cd8:	29 c2                	sub    %eax,%edx
  800cda:	89 d0                	mov    %edx,%eax
  800cdc:	eb 18                	jmp    800cf6 <memcmp+0x50>
		s1++, s2++;
  800cde:	ff 45 fc             	incl   -0x4(%ebp)
  800ce1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cea:	89 55 10             	mov    %edx,0x10(%ebp)
  800ced:	85 c0                	test   %eax,%eax
  800cef:	75 c9                	jne    800cba <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800d01:	8b 45 10             	mov    0x10(%ebp),%eax
  800d04:	01 d0                	add    %edx,%eax
  800d06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d09:	eb 15                	jmp    800d20 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	0f b6 d0             	movzbl %al,%edx
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	0f b6 c0             	movzbl %al,%eax
  800d19:	39 c2                	cmp    %eax,%edx
  800d1b:	74 0d                	je     800d2a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d1d:	ff 45 08             	incl   0x8(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d26:	72 e3                	jb     800d0b <memfind+0x13>
  800d28:	eb 01                	jmp    800d2b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d2a:	90                   	nop
	return (void *) s;
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d2e:	c9                   	leave  
  800d2f:	c3                   	ret    

00800d30 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d3d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d44:	eb 03                	jmp    800d49 <strtol+0x19>
		s++;
  800d46:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	3c 20                	cmp    $0x20,%al
  800d50:	74 f4                	je     800d46 <strtol+0x16>
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	3c 09                	cmp    $0x9,%al
  800d59:	74 eb                	je     800d46 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	3c 2b                	cmp    $0x2b,%al
  800d62:	75 05                	jne    800d69 <strtol+0x39>
		s++;
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	eb 13                	jmp    800d7c <strtol+0x4c>
	else if (*s == '-')
  800d69:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6c:	8a 00                	mov    (%eax),%al
  800d6e:	3c 2d                	cmp    $0x2d,%al
  800d70:	75 0a                	jne    800d7c <strtol+0x4c>
		s++, neg = 1;
  800d72:	ff 45 08             	incl   0x8(%ebp)
  800d75:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d80:	74 06                	je     800d88 <strtol+0x58>
  800d82:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d86:	75 20                	jne    800da8 <strtol+0x78>
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 30                	cmp    $0x30,%al
  800d8f:	75 17                	jne    800da8 <strtol+0x78>
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	40                   	inc    %eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	3c 78                	cmp    $0x78,%al
  800d99:	75 0d                	jne    800da8 <strtol+0x78>
		s += 2, base = 16;
  800d9b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d9f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da6:	eb 28                	jmp    800dd0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800da8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dac:	75 15                	jne    800dc3 <strtol+0x93>
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	3c 30                	cmp    $0x30,%al
  800db5:	75 0c                	jne    800dc3 <strtol+0x93>
		s++, base = 8;
  800db7:	ff 45 08             	incl   0x8(%ebp)
  800dba:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dc1:	eb 0d                	jmp    800dd0 <strtol+0xa0>
	else if (base == 0)
  800dc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc7:	75 07                	jne    800dd0 <strtol+0xa0>
		base = 10;
  800dc9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	3c 2f                	cmp    $0x2f,%al
  800dd7:	7e 19                	jle    800df2 <strtol+0xc2>
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	3c 39                	cmp    $0x39,%al
  800de0:	7f 10                	jg     800df2 <strtol+0xc2>
			dig = *s - '0';
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f be c0             	movsbl %al,%eax
  800dea:	83 e8 30             	sub    $0x30,%eax
  800ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800df0:	eb 42                	jmp    800e34 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	3c 60                	cmp    $0x60,%al
  800df9:	7e 19                	jle    800e14 <strtol+0xe4>
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8a 00                	mov    (%eax),%al
  800e00:	3c 7a                	cmp    $0x7a,%al
  800e02:	7f 10                	jg     800e14 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	0f be c0             	movsbl %al,%eax
  800e0c:	83 e8 57             	sub    $0x57,%eax
  800e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e12:	eb 20                	jmp    800e34 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	8a 00                	mov    (%eax),%al
  800e19:	3c 40                	cmp    $0x40,%al
  800e1b:	7e 39                	jle    800e56 <strtol+0x126>
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	3c 5a                	cmp    $0x5a,%al
  800e24:	7f 30                	jg     800e56 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8a 00                	mov    (%eax),%al
  800e2b:	0f be c0             	movsbl %al,%eax
  800e2e:	83 e8 37             	sub    $0x37,%eax
  800e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e37:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e3a:	7d 19                	jge    800e55 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e3c:	ff 45 08             	incl   0x8(%ebp)
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e46:	89 c2                	mov    %eax,%edx
  800e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4b:	01 d0                	add    %edx,%eax
  800e4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e50:	e9 7b ff ff ff       	jmp    800dd0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e55:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5a:	74 08                	je     800e64 <strtol+0x134>
		*endptr = (char *) s;
  800e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e62:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e64:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e68:	74 07                	je     800e71 <strtol+0x141>
  800e6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6d:	f7 d8                	neg    %eax
  800e6f:	eb 03                	jmp    800e74 <strtol+0x144>
  800e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <ltostr>:

void
ltostr(long value, char *str)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e83:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e8e:	79 13                	jns    800ea3 <ltostr+0x2d>
	{
		neg = 1;
  800e90:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e9d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ea0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800eab:	99                   	cltd   
  800eac:	f7 f9                	idiv   %ecx
  800eae:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb4:	8d 50 01             	lea    0x1(%eax),%edx
  800eb7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eba:	89 c2                	mov    %eax,%edx
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	01 d0                	add    %edx,%eax
  800ec1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ec4:	83 c2 30             	add    $0x30,%edx
  800ec7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ec9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ecc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ed1:	f7 e9                	imul   %ecx
  800ed3:	c1 fa 02             	sar    $0x2,%edx
  800ed6:	89 c8                	mov    %ecx,%eax
  800ed8:	c1 f8 1f             	sar    $0x1f,%eax
  800edb:	29 c2                	sub    %eax,%edx
  800edd:	89 d0                	mov    %edx,%eax
  800edf:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800ee2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ee6:	75 bb                	jne    800ea3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800eef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef2:	48                   	dec    %eax
  800ef3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800ef6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800efa:	74 3d                	je     800f39 <ltostr+0xc3>
		start = 1 ;
  800efc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f03:	eb 34                	jmp    800f39 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	01 d0                	add    %edx,%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f18:	01 c2                	add    %eax,%edx
  800f1a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f20:	01 c8                	add    %ecx,%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	01 c2                	add    %eax,%edx
  800f2e:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f31:	88 02                	mov    %al,(%edx)
		start++ ;
  800f33:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f36:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f3f:	7c c4                	jl     800f05 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f41:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f47:	01 d0                	add    %edx,%eax
  800f49:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f4c:	90                   	nop
  800f4d:	c9                   	leave  
  800f4e:	c3                   	ret    

00800f4f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f55:	ff 75 08             	pushl  0x8(%ebp)
  800f58:	e8 73 fa ff ff       	call   8009d0 <strlen>
  800f5d:	83 c4 04             	add    $0x4,%esp
  800f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f63:	ff 75 0c             	pushl  0xc(%ebp)
  800f66:	e8 65 fa ff ff       	call   8009d0 <strlen>
  800f6b:	83 c4 04             	add    $0x4,%esp
  800f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f7f:	eb 17                	jmp    800f98 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	01 c2                	add    %eax,%edx
  800f89:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	01 c8                	add    %ecx,%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f95:	ff 45 fc             	incl   -0x4(%ebp)
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f9e:	7c e1                	jl     800f81 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fa0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fa7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fae:	eb 1f                	jmp    800fcf <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb3:	8d 50 01             	lea    0x1(%eax),%edx
  800fb6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fb9:	89 c2                	mov    %eax,%edx
  800fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbe:	01 c2                	add    %eax,%edx
  800fc0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc6:	01 c8                	add    %ecx,%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fcc:	ff 45 f8             	incl   -0x8(%ebp)
  800fcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fd5:	7c d9                	jl     800fb0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800fd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	01 d0                	add    %edx,%eax
  800fdf:	c6 00 00             	movb   $0x0,(%eax)
}
  800fe2:	90                   	nop
  800fe3:	c9                   	leave  
  800fe4:	c3                   	ret    

00800fe5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800fe8:	8b 45 14             	mov    0x14(%ebp),%eax
  800feb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800ff1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff4:	8b 00                	mov    (%eax),%eax
  800ff6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  801000:	01 d0                	add    %edx,%eax
  801002:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801008:	eb 0c                	jmp    801016 <strsplit+0x31>
			*string++ = 0;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8d 50 01             	lea    0x1(%eax),%edx
  801010:	89 55 08             	mov    %edx,0x8(%ebp)
  801013:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	84 c0                	test   %al,%al
  80101d:	74 18                	je     801037 <strsplit+0x52>
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	0f be c0             	movsbl %al,%eax
  801027:	50                   	push   %eax
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	e8 32 fb ff ff       	call   800b62 <strchr>
  801030:	83 c4 08             	add    $0x8,%esp
  801033:	85 c0                	test   %eax,%eax
  801035:	75 d3                	jne    80100a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	84 c0                	test   %al,%al
  80103e:	74 5a                	je     80109a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801040:	8b 45 14             	mov    0x14(%ebp),%eax
  801043:	8b 00                	mov    (%eax),%eax
  801045:	83 f8 0f             	cmp    $0xf,%eax
  801048:	75 07                	jne    801051 <strsplit+0x6c>
		{
			return 0;
  80104a:	b8 00 00 00 00       	mov    $0x0,%eax
  80104f:	eb 66                	jmp    8010b7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801051:	8b 45 14             	mov    0x14(%ebp),%eax
  801054:	8b 00                	mov    (%eax),%eax
  801056:	8d 48 01             	lea    0x1(%eax),%ecx
  801059:	8b 55 14             	mov    0x14(%ebp),%edx
  80105c:	89 0a                	mov    %ecx,(%edx)
  80105e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801065:	8b 45 10             	mov    0x10(%ebp),%eax
  801068:	01 c2                	add    %eax,%edx
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80106f:	eb 03                	jmp    801074 <strsplit+0x8f>
			string++;
  801071:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	84 c0                	test   %al,%al
  80107b:	74 8b                	je     801008 <strsplit+0x23>
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f be c0             	movsbl %al,%eax
  801085:	50                   	push   %eax
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	e8 d4 fa ff ff       	call   800b62 <strchr>
  80108e:	83 c4 08             	add    $0x8,%esp
  801091:	85 c0                	test   %eax,%eax
  801093:	74 dc                	je     801071 <strsplit+0x8c>
			string++;
	}
  801095:	e9 6e ff ff ff       	jmp    801008 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80109a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80109b:	8b 45 14             	mov    0x14(%ebp),%eax
  80109e:	8b 00                	mov    (%eax),%eax
  8010a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	01 d0                	add    %edx,%eax
  8010ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010b2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010b7:	c9                   	leave  
  8010b8:	c3                   	ret    

008010b9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8010bf:	83 ec 04             	sub    $0x4,%esp
  8010c2:	68 08 21 80 00       	push   $0x802108
  8010c7:	68 3f 01 00 00       	push   $0x13f
  8010cc:	68 2a 21 80 00       	push   $0x80212a
  8010d1:	e8 dd 06 00 00       	call   8017b3 <_panic>

008010d6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	57                   	push   %edi
  8010da:	56                   	push   %esi
  8010db:	53                   	push   %ebx
  8010dc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010eb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010ee:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010f1:	cd 30                	int    $0x30
  8010f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8010f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010f9:	83 c4 10             	add    $0x10,%esp
  8010fc:	5b                   	pop    %ebx
  8010fd:	5e                   	pop    %esi
  8010fe:	5f                   	pop    %edi
  8010ff:	5d                   	pop    %ebp
  801100:	c3                   	ret    

00801101 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80110d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	6a 00                	push   $0x0
  801116:	6a 00                	push   $0x0
  801118:	52                   	push   %edx
  801119:	ff 75 0c             	pushl  0xc(%ebp)
  80111c:	50                   	push   %eax
  80111d:	6a 00                	push   $0x0
  80111f:	e8 b2 ff ff ff       	call   8010d6 <syscall>
  801124:	83 c4 18             	add    $0x18,%esp
}
  801127:	90                   	nop
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <sys_cgetc>:

int
sys_cgetc(void)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80112d:	6a 00                	push   $0x0
  80112f:	6a 00                	push   $0x0
  801131:	6a 00                	push   $0x0
  801133:	6a 00                	push   $0x0
  801135:	6a 00                	push   $0x0
  801137:	6a 02                	push   $0x2
  801139:	e8 98 ff ff ff       	call   8010d6 <syscall>
  80113e:	83 c4 18             	add    $0x18,%esp
}
  801141:	c9                   	leave  
  801142:	c3                   	ret    

00801143 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801146:	6a 00                	push   $0x0
  801148:	6a 00                	push   $0x0
  80114a:	6a 00                	push   $0x0
  80114c:	6a 00                	push   $0x0
  80114e:	6a 00                	push   $0x0
  801150:	6a 03                	push   $0x3
  801152:	e8 7f ff ff ff       	call   8010d6 <syscall>
  801157:	83 c4 18             	add    $0x18,%esp
}
  80115a:	90                   	nop
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801160:	6a 00                	push   $0x0
  801162:	6a 00                	push   $0x0
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	6a 04                	push   $0x4
  80116c:	e8 65 ff ff ff       	call   8010d6 <syscall>
  801171:	83 c4 18             	add    $0x18,%esp
}
  801174:	90                   	nop
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80117a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80117d:	8b 45 08             	mov    0x8(%ebp),%eax
  801180:	6a 00                	push   $0x0
  801182:	6a 00                	push   $0x0
  801184:	6a 00                	push   $0x0
  801186:	52                   	push   %edx
  801187:	50                   	push   %eax
  801188:	6a 08                	push   $0x8
  80118a:	e8 47 ff ff ff       	call   8010d6 <syscall>
  80118f:	83 c4 18             	add    $0x18,%esp
}
  801192:	c9                   	leave  
  801193:	c3                   	ret    

00801194 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801194:	55                   	push   %ebp
  801195:	89 e5                	mov    %esp,%ebp
  801197:	56                   	push   %esi
  801198:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801199:	8b 75 18             	mov    0x18(%ebp),%esi
  80119c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80119f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	56                   	push   %esi
  8011a9:	53                   	push   %ebx
  8011aa:	51                   	push   %ecx
  8011ab:	52                   	push   %edx
  8011ac:	50                   	push   %eax
  8011ad:	6a 09                	push   $0x9
  8011af:	e8 22 ff ff ff       	call   8010d6 <syscall>
  8011b4:	83 c4 18             	add    $0x18,%esp
}
  8011b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011ba:	5b                   	pop    %ebx
  8011bb:	5e                   	pop    %esi
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    

008011be <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8011c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	6a 00                	push   $0x0
  8011c9:	6a 00                	push   $0x0
  8011cb:	6a 00                	push   $0x0
  8011cd:	52                   	push   %edx
  8011ce:	50                   	push   %eax
  8011cf:	6a 0a                	push   $0xa
  8011d1:	e8 00 ff ff ff       	call   8010d6 <syscall>
  8011d6:	83 c4 18             	add    $0x18,%esp
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8011de:	6a 00                	push   $0x0
  8011e0:	6a 00                	push   $0x0
  8011e2:	6a 00                	push   $0x0
  8011e4:	ff 75 0c             	pushl  0xc(%ebp)
  8011e7:	ff 75 08             	pushl  0x8(%ebp)
  8011ea:	6a 0b                	push   $0xb
  8011ec:	e8 e5 fe ff ff       	call   8010d6 <syscall>
  8011f1:	83 c4 18             	add    $0x18,%esp
}
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 00                	push   $0x0
  801201:	6a 00                	push   $0x0
  801203:	6a 0c                	push   $0xc
  801205:	e8 cc fe ff ff       	call   8010d6 <syscall>
  80120a:	83 c4 18             	add    $0x18,%esp
}
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    

0080120f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801212:	6a 00                	push   $0x0
  801214:	6a 00                	push   $0x0
  801216:	6a 00                	push   $0x0
  801218:	6a 00                	push   $0x0
  80121a:	6a 00                	push   $0x0
  80121c:	6a 0d                	push   $0xd
  80121e:	e8 b3 fe ff ff       	call   8010d6 <syscall>
  801223:	83 c4 18             	add    $0x18,%esp
}
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80122b:	6a 00                	push   $0x0
  80122d:	6a 00                	push   $0x0
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 0e                	push   $0xe
  801237:	e8 9a fe ff ff       	call   8010d6 <syscall>
  80123c:	83 c4 18             	add    $0x18,%esp
}
  80123f:	c9                   	leave  
  801240:	c3                   	ret    

00801241 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801241:	55                   	push   %ebp
  801242:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801244:	6a 00                	push   $0x0
  801246:	6a 00                	push   $0x0
  801248:	6a 00                	push   $0x0
  80124a:	6a 00                	push   $0x0
  80124c:	6a 00                	push   $0x0
  80124e:	6a 0f                	push   $0xf
  801250:	e8 81 fe ff ff       	call   8010d6 <syscall>
  801255:	83 c4 18             	add    $0x18,%esp
}
  801258:	c9                   	leave  
  801259:	c3                   	ret    

0080125a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	6a 00                	push   $0x0
  801265:	ff 75 08             	pushl  0x8(%ebp)
  801268:	6a 10                	push   $0x10
  80126a:	e8 67 fe ff ff       	call   8010d6 <syscall>
  80126f:	83 c4 18             	add    $0x18,%esp
}
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 11                	push   $0x11
  801283:	e8 4e fe ff ff       	call   8010d6 <syscall>
  801288:	83 c4 18             	add    $0x18,%esp
}
  80128b:	90                   	nop
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <sys_cputc>:

void
sys_cputc(const char c)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 04             	sub    $0x4,%esp
  801294:	8b 45 08             	mov    0x8(%ebp),%eax
  801297:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80129a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80129e:	6a 00                	push   $0x0
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	6a 00                	push   $0x0
  8012a6:	50                   	push   %eax
  8012a7:	6a 01                	push   $0x1
  8012a9:	e8 28 fe ff ff       	call   8010d6 <syscall>
  8012ae:	83 c4 18             	add    $0x18,%esp
}
  8012b1:	90                   	nop
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8012b7:	6a 00                	push   $0x0
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 14                	push   $0x14
  8012c3:	e8 0e fe ff ff       	call   8010d6 <syscall>
  8012c8:	83 c4 18             	add    $0x18,%esp
}
  8012cb:	90                   	nop
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 04             	sub    $0x4,%esp
  8012d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012da:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012dd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	6a 00                	push   $0x0
  8012e6:	51                   	push   %ecx
  8012e7:	52                   	push   %edx
  8012e8:	ff 75 0c             	pushl  0xc(%ebp)
  8012eb:	50                   	push   %eax
  8012ec:	6a 15                	push   $0x15
  8012ee:	e8 e3 fd ff ff       	call   8010d6 <syscall>
  8012f3:	83 c4 18             	add    $0x18,%esp
}
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	52                   	push   %edx
  801308:	50                   	push   %eax
  801309:	6a 16                	push   $0x16
  80130b:	e8 c6 fd ff ff       	call   8010d6 <syscall>
  801310:	83 c4 18             	add    $0x18,%esp
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801318:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80131b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	51                   	push   %ecx
  801326:	52                   	push   %edx
  801327:	50                   	push   %eax
  801328:	6a 17                	push   $0x17
  80132a:	e8 a7 fd ff ff       	call   8010d6 <syscall>
  80132f:	83 c4 18             	add    $0x18,%esp
}
  801332:	c9                   	leave  
  801333:	c3                   	ret    

00801334 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801334:	55                   	push   %ebp
  801335:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801337:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	52                   	push   %edx
  801344:	50                   	push   %eax
  801345:	6a 18                	push   $0x18
  801347:	e8 8a fd ff ff       	call   8010d6 <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	c9                   	leave  
  801350:	c3                   	ret    

00801351 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	6a 00                	push   $0x0
  801359:	ff 75 14             	pushl  0x14(%ebp)
  80135c:	ff 75 10             	pushl  0x10(%ebp)
  80135f:	ff 75 0c             	pushl  0xc(%ebp)
  801362:	50                   	push   %eax
  801363:	6a 19                	push   $0x19
  801365:	e8 6c fd ff ff       	call   8010d6 <syscall>
  80136a:	83 c4 18             	add    $0x18,%esp
}
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <sys_run_env>:

void sys_run_env(int32 envId)
{
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	50                   	push   %eax
  80137e:	6a 1a                	push   $0x1a
  801380:	e8 51 fd ff ff       	call   8010d6 <syscall>
  801385:	83 c4 18             	add    $0x18,%esp
}
  801388:	90                   	nop
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	50                   	push   %eax
  80139a:	6a 1b                	push   $0x1b
  80139c:	e8 35 fd ff ff       	call   8010d6 <syscall>
  8013a1:	83 c4 18             	add    $0x18,%esp
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 00                	push   $0x0
  8013b1:	6a 00                	push   $0x0
  8013b3:	6a 05                	push   $0x5
  8013b5:	e8 1c fd ff ff       	call   8010d6 <syscall>
  8013ba:	83 c4 18             	add    $0x18,%esp
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	6a 06                	push   $0x6
  8013ce:	e8 03 fd ff ff       	call   8010d6 <syscall>
  8013d3:	83 c4 18             	add    $0x18,%esp
}
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 07                	push   $0x7
  8013e7:	e8 ea fc ff ff       	call   8010d6 <syscall>
  8013ec:	83 c4 18             	add    $0x18,%esp
}
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <sys_exit_env>:


void sys_exit_env(void)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 1c                	push   $0x1c
  801400:	e8 d1 fc ff ff       	call   8010d6 <syscall>
  801405:	83 c4 18             	add    $0x18,%esp
}
  801408:	90                   	nop
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801411:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801414:	8d 50 04             	lea    0x4(%eax),%edx
  801417:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	52                   	push   %edx
  801421:	50                   	push   %eax
  801422:	6a 1d                	push   $0x1d
  801424:	e8 ad fc ff ff       	call   8010d6 <syscall>
  801429:	83 c4 18             	add    $0x18,%esp
	return result;
  80142c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80142f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	89 01                	mov    %eax,(%ecx)
  801437:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80143a:	8b 45 08             	mov    0x8(%ebp),%eax
  80143d:	c9                   	leave  
  80143e:	c2 04 00             	ret    $0x4

00801441 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	ff 75 10             	pushl  0x10(%ebp)
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	ff 75 08             	pushl  0x8(%ebp)
  801451:	6a 13                	push   $0x13
  801453:	e8 7e fc ff ff       	call   8010d6 <syscall>
  801458:	83 c4 18             	add    $0x18,%esp
	return ;
  80145b:	90                   	nop
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <sys_rcr2>:
uint32 sys_rcr2()
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 1e                	push   $0x1e
  80146d:	e8 64 fc ff ff       	call   8010d6 <syscall>
  801472:	83 c4 18             	add    $0x18,%esp
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801483:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	50                   	push   %eax
  801490:	6a 1f                	push   $0x1f
  801492:	e8 3f fc ff ff       	call   8010d6 <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
	return ;
  80149a:	90                   	nop
}
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <rsttst>:
void rsttst()
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 21                	push   $0x21
  8014ac:	e8 25 fc ff ff       	call   8010d6 <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b4:	90                   	nop
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014c3:	8b 55 18             	mov    0x18(%ebp),%edx
  8014c6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014ca:	52                   	push   %edx
  8014cb:	50                   	push   %eax
  8014cc:	ff 75 10             	pushl  0x10(%ebp)
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	ff 75 08             	pushl  0x8(%ebp)
  8014d5:	6a 20                	push   $0x20
  8014d7:	e8 fa fb ff ff       	call   8010d6 <syscall>
  8014dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8014df:	90                   	nop
}
  8014e0:	c9                   	leave  
  8014e1:	c3                   	ret    

008014e2 <chktst>:
void chktst(uint32 n)
{
  8014e2:	55                   	push   %ebp
  8014e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014e5:	6a 00                	push   $0x0
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	ff 75 08             	pushl  0x8(%ebp)
  8014f0:	6a 22                	push   $0x22
  8014f2:	e8 df fb ff ff       	call   8010d6 <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8014fa:	90                   	nop
}
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <inctst>:

void inctst()
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 23                	push   $0x23
  80150c:	e8 c5 fb ff ff       	call   8010d6 <syscall>
  801511:	83 c4 18             	add    $0x18,%esp
	return ;
  801514:	90                   	nop
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <gettst>:
uint32 gettst()
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 24                	push   $0x24
  801526:	e8 ab fb ff ff       	call   8010d6 <syscall>
  80152b:	83 c4 18             	add    $0x18,%esp
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 25                	push   $0x25
  801542:	e8 8f fb ff ff       	call   8010d6 <syscall>
  801547:	83 c4 18             	add    $0x18,%esp
  80154a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80154d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801551:	75 07                	jne    80155a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801553:	b8 01 00 00 00       	mov    $0x1,%eax
  801558:	eb 05                	jmp    80155f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 25                	push   $0x25
  801573:	e8 5e fb ff ff       	call   8010d6 <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
  80157b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80157e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801582:	75 07                	jne    80158b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801584:	b8 01 00 00 00       	mov    $0x1,%eax
  801589:	eb 05                	jmp    801590 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 25                	push   $0x25
  8015a4:	e8 2d fb ff ff       	call   8010d6 <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
  8015ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015af:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015b3:	75 07                	jne    8015bc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8015ba:	eb 05                	jmp    8015c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 25                	push   $0x25
  8015d5:	e8 fc fa ff ff       	call   8010d6 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
  8015dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015e0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015e4:	75 07                	jne    8015ed <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8015eb:	eb 05                	jmp    8015f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	ff 75 08             	pushl  0x8(%ebp)
  801602:	6a 26                	push   $0x26
  801604:	e8 cd fa ff ff       	call   8010d6 <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
	return ;
  80160c:	90                   	nop
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801613:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801616:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	6a 00                	push   $0x0
  801621:	53                   	push   %ebx
  801622:	51                   	push   %ecx
  801623:	52                   	push   %edx
  801624:	50                   	push   %eax
  801625:	6a 27                	push   $0x27
  801627:	e8 aa fa ff ff       	call   8010d6 <syscall>
  80162c:	83 c4 18             	add    $0x18,%esp
}
  80162f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801637:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	52                   	push   %edx
  801644:	50                   	push   %eax
  801645:	6a 28                	push   $0x28
  801647:	e8 8a fa ff ff       	call   8010d6 <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801654:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801657:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	6a 00                	push   $0x0
  80165f:	51                   	push   %ecx
  801660:	ff 75 10             	pushl  0x10(%ebp)
  801663:	52                   	push   %edx
  801664:	50                   	push   %eax
  801665:	6a 29                	push   $0x29
  801667:	e8 6a fa ff ff       	call   8010d6 <syscall>
  80166c:	83 c4 18             	add    $0x18,%esp
}
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	ff 75 10             	pushl  0x10(%ebp)
  80167b:	ff 75 0c             	pushl  0xc(%ebp)
  80167e:	ff 75 08             	pushl  0x8(%ebp)
  801681:	6a 12                	push   $0x12
  801683:	e8 4e fa ff ff       	call   8010d6 <syscall>
  801688:	83 c4 18             	add    $0x18,%esp
	return ;
  80168b:	90                   	nop
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801691:	8b 55 0c             	mov    0xc(%ebp),%edx
  801694:	8b 45 08             	mov    0x8(%ebp),%eax
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	52                   	push   %edx
  80169e:	50                   	push   %eax
  80169f:	6a 2a                	push   $0x2a
  8016a1:	e8 30 fa ff ff       	call   8010d6 <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
	return;
  8016a9:	90                   	nop
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	50                   	push   %eax
  8016bb:	6a 2b                	push   $0x2b
  8016bd:	e8 14 fa ff ff       	call   8010d6 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	ff 75 0c             	pushl  0xc(%ebp)
  8016d3:	ff 75 08             	pushl  0x8(%ebp)
  8016d6:	6a 2c                	push   $0x2c
  8016d8:	e8 f9 f9 ff ff       	call   8010d6 <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
	return;
  8016e0:	90                   	nop
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	ff 75 08             	pushl  0x8(%ebp)
  8016f2:	6a 2d                	push   $0x2d
  8016f4:	e8 dd f9 ff ff       	call   8010d6 <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
	return;
  8016fc:	90                   	nop
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801705:	8b 55 08             	mov    0x8(%ebp),%edx
  801708:	89 d0                	mov    %edx,%eax
  80170a:	c1 e0 02             	shl    $0x2,%eax
  80170d:	01 d0                	add    %edx,%eax
  80170f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801716:	01 d0                	add    %edx,%eax
  801718:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171f:	01 d0                	add    %edx,%eax
  801721:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801728:	01 d0                	add    %edx,%eax
  80172a:	c1 e0 04             	shl    $0x4,%eax
  80172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801730:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801737:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80173a:	83 ec 0c             	sub    $0xc,%esp
  80173d:	50                   	push   %eax
  80173e:	e8 c8 fc ff ff       	call   80140b <sys_get_virtual_time>
  801743:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801746:	eb 41                	jmp    801789 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801748:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80174b:	83 ec 0c             	sub    $0xc,%esp
  80174e:	50                   	push   %eax
  80174f:	e8 b7 fc ff ff       	call   80140b <sys_get_virtual_time>
  801754:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801757:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80175a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80175d:	29 c2                	sub    %eax,%edx
  80175f:	89 d0                	mov    %edx,%eax
  801761:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801764:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176a:	89 d1                	mov    %edx,%ecx
  80176c:	29 c1                	sub    %eax,%ecx
  80176e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801771:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801774:	39 c2                	cmp    %eax,%edx
  801776:	0f 97 c0             	seta   %al
  801779:	0f b6 c0             	movzbl %al,%eax
  80177c:	29 c1                	sub    %eax,%ecx
  80177e:	89 c8                	mov    %ecx,%eax
  801780:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801783:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801786:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80178f:	72 b7                	jb     801748 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801791:	90                   	nop
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80179a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8017a1:	eb 03                	jmp    8017a6 <busy_wait+0x12>
  8017a3:	ff 45 fc             	incl   -0x4(%ebp)
  8017a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017ac:	72 f5                	jb     8017a3 <busy_wait+0xf>
	return i;
  8017ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8017bc:	83 c0 04             	add    $0x4,%eax
  8017bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017c2:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	74 16                	je     8017e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8017cb:	a1 2c 30 80 00       	mov    0x80302c,%eax
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	50                   	push   %eax
  8017d4:	68 38 21 80 00       	push   $0x802138
  8017d9:	e8 5e eb ff ff       	call   80033c <cprintf>
  8017de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8017e1:	a1 00 30 80 00       	mov    0x803000,%eax
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	ff 75 08             	pushl  0x8(%ebp)
  8017ec:	50                   	push   %eax
  8017ed:	68 3d 21 80 00       	push   $0x80213d
  8017f2:	e8 45 eb ff ff       	call   80033c <cprintf>
  8017f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8017fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	ff 75 f4             	pushl  -0xc(%ebp)
  801803:	50                   	push   %eax
  801804:	e8 c8 ea ff ff       	call   8002d1 <vcprintf>
  801809:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80180c:	83 ec 08             	sub    $0x8,%esp
  80180f:	6a 00                	push   $0x0
  801811:	68 59 21 80 00       	push   $0x802159
  801816:	e8 b6 ea ff ff       	call   8002d1 <vcprintf>
  80181b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80181e:	e8 37 ea ff ff       	call   80025a <exit>

	// should not return here
	while (1) ;
  801823:	eb fe                	jmp    801823 <_panic+0x70>

00801825 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80182b:	a1 04 30 80 00       	mov    0x803004,%eax
  801830:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801836:	8b 45 0c             	mov    0xc(%ebp),%eax
  801839:	39 c2                	cmp    %eax,%edx
  80183b:	74 14                	je     801851 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80183d:	83 ec 04             	sub    $0x4,%esp
  801840:	68 5c 21 80 00       	push   $0x80215c
  801845:	6a 26                	push   $0x26
  801847:	68 a8 21 80 00       	push   $0x8021a8
  80184c:	e8 62 ff ff ff       	call   8017b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801851:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801858:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80185f:	e9 c5 00 00 00       	jmp    801929 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801867:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	01 d0                	add    %edx,%eax
  801873:	8b 00                	mov    (%eax),%eax
  801875:	85 c0                	test   %eax,%eax
  801877:	75 08                	jne    801881 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801879:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80187c:	e9 a5 00 00 00       	jmp    801926 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801881:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801888:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80188f:	eb 69                	jmp    8018fa <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801891:	a1 04 30 80 00       	mov    0x803004,%eax
  801896:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  80189c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80189f:	89 d0                	mov    %edx,%eax
  8018a1:	01 c0                	add    %eax,%eax
  8018a3:	01 d0                	add    %edx,%eax
  8018a5:	c1 e0 03             	shl    $0x3,%eax
  8018a8:	01 c8                	add    %ecx,%eax
  8018aa:	8a 40 04             	mov    0x4(%eax),%al
  8018ad:	84 c0                	test   %al,%al
  8018af:	75 46                	jne    8018f7 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018b1:	a1 04 30 80 00       	mov    0x803004,%eax
  8018b6:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  8018bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018bf:	89 d0                	mov    %edx,%eax
  8018c1:	01 c0                	add    %eax,%eax
  8018c3:	01 d0                	add    %edx,%eax
  8018c5:	c1 e0 03             	shl    $0x3,%eax
  8018c8:	01 c8                	add    %ecx,%eax
  8018ca:	8b 00                	mov    (%eax),%eax
  8018cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	01 c8                	add    %ecx,%eax
  8018e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018ea:	39 c2                	cmp    %eax,%edx
  8018ec:	75 09                	jne    8018f7 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018f5:	eb 15                	jmp    80190c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018f7:	ff 45 e8             	incl   -0x18(%ebp)
  8018fa:	a1 04 30 80 00       	mov    0x803004,%eax
  8018ff:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801908:	39 c2                	cmp    %eax,%edx
  80190a:	77 85                	ja     801891 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80190c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801910:	75 14                	jne    801926 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801912:	83 ec 04             	sub    $0x4,%esp
  801915:	68 b4 21 80 00       	push   $0x8021b4
  80191a:	6a 3a                	push   $0x3a
  80191c:	68 a8 21 80 00       	push   $0x8021a8
  801921:	e8 8d fe ff ff       	call   8017b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801926:	ff 45 f0             	incl   -0x10(%ebp)
  801929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80192f:	0f 8c 2f ff ff ff    	jl     801864 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801935:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80193c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801943:	eb 26                	jmp    80196b <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801945:	a1 04 30 80 00       	mov    0x803004,%eax
  80194a:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801950:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801953:	89 d0                	mov    %edx,%eax
  801955:	01 c0                	add    %eax,%eax
  801957:	01 d0                	add    %edx,%eax
  801959:	c1 e0 03             	shl    $0x3,%eax
  80195c:	01 c8                	add    %ecx,%eax
  80195e:	8a 40 04             	mov    0x4(%eax),%al
  801961:	3c 01                	cmp    $0x1,%al
  801963:	75 03                	jne    801968 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801965:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801968:	ff 45 e0             	incl   -0x20(%ebp)
  80196b:	a1 04 30 80 00       	mov    0x803004,%eax
  801970:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801979:	39 c2                	cmp    %eax,%edx
  80197b:	77 c8                	ja     801945 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80197d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801980:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801983:	74 14                	je     801999 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801985:	83 ec 04             	sub    $0x4,%esp
  801988:	68 08 22 80 00       	push   $0x802208
  80198d:	6a 44                	push   $0x44
  80198f:	68 a8 21 80 00       	push   $0x8021a8
  801994:	e8 1a fe ff ff       	call   8017b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801999:	90                   	nop
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <__udivdi3>:
  80199c:	55                   	push   %ebp
  80199d:	57                   	push   %edi
  80199e:	56                   	push   %esi
  80199f:	53                   	push   %ebx
  8019a0:	83 ec 1c             	sub    $0x1c,%esp
  8019a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019b3:	89 ca                	mov    %ecx,%edx
  8019b5:	89 f8                	mov    %edi,%eax
  8019b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019bb:	85 f6                	test   %esi,%esi
  8019bd:	75 2d                	jne    8019ec <__udivdi3+0x50>
  8019bf:	39 cf                	cmp    %ecx,%edi
  8019c1:	77 65                	ja     801a28 <__udivdi3+0x8c>
  8019c3:	89 fd                	mov    %edi,%ebp
  8019c5:	85 ff                	test   %edi,%edi
  8019c7:	75 0b                	jne    8019d4 <__udivdi3+0x38>
  8019c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ce:	31 d2                	xor    %edx,%edx
  8019d0:	f7 f7                	div    %edi
  8019d2:	89 c5                	mov    %eax,%ebp
  8019d4:	31 d2                	xor    %edx,%edx
  8019d6:	89 c8                	mov    %ecx,%eax
  8019d8:	f7 f5                	div    %ebp
  8019da:	89 c1                	mov    %eax,%ecx
  8019dc:	89 d8                	mov    %ebx,%eax
  8019de:	f7 f5                	div    %ebp
  8019e0:	89 cf                	mov    %ecx,%edi
  8019e2:	89 fa                	mov    %edi,%edx
  8019e4:	83 c4 1c             	add    $0x1c,%esp
  8019e7:	5b                   	pop    %ebx
  8019e8:	5e                   	pop    %esi
  8019e9:	5f                   	pop    %edi
  8019ea:	5d                   	pop    %ebp
  8019eb:	c3                   	ret    
  8019ec:	39 ce                	cmp    %ecx,%esi
  8019ee:	77 28                	ja     801a18 <__udivdi3+0x7c>
  8019f0:	0f bd fe             	bsr    %esi,%edi
  8019f3:	83 f7 1f             	xor    $0x1f,%edi
  8019f6:	75 40                	jne    801a38 <__udivdi3+0x9c>
  8019f8:	39 ce                	cmp    %ecx,%esi
  8019fa:	72 0a                	jb     801a06 <__udivdi3+0x6a>
  8019fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a00:	0f 87 9e 00 00 00    	ja     801aa4 <__udivdi3+0x108>
  801a06:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0b:	89 fa                	mov    %edi,%edx
  801a0d:	83 c4 1c             	add    $0x1c,%esp
  801a10:	5b                   	pop    %ebx
  801a11:	5e                   	pop    %esi
  801a12:	5f                   	pop    %edi
  801a13:	5d                   	pop    %ebp
  801a14:	c3                   	ret    
  801a15:	8d 76 00             	lea    0x0(%esi),%esi
  801a18:	31 ff                	xor    %edi,%edi
  801a1a:	31 c0                	xor    %eax,%eax
  801a1c:	89 fa                	mov    %edi,%edx
  801a1e:	83 c4 1c             	add    $0x1c,%esp
  801a21:	5b                   	pop    %ebx
  801a22:	5e                   	pop    %esi
  801a23:	5f                   	pop    %edi
  801a24:	5d                   	pop    %ebp
  801a25:	c3                   	ret    
  801a26:	66 90                	xchg   %ax,%ax
  801a28:	89 d8                	mov    %ebx,%eax
  801a2a:	f7 f7                	div    %edi
  801a2c:	31 ff                	xor    %edi,%edi
  801a2e:	89 fa                	mov    %edi,%edx
  801a30:	83 c4 1c             	add    $0x1c,%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5f                   	pop    %edi
  801a36:	5d                   	pop    %ebp
  801a37:	c3                   	ret    
  801a38:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a3d:	89 eb                	mov    %ebp,%ebx
  801a3f:	29 fb                	sub    %edi,%ebx
  801a41:	89 f9                	mov    %edi,%ecx
  801a43:	d3 e6                	shl    %cl,%esi
  801a45:	89 c5                	mov    %eax,%ebp
  801a47:	88 d9                	mov    %bl,%cl
  801a49:	d3 ed                	shr    %cl,%ebp
  801a4b:	89 e9                	mov    %ebp,%ecx
  801a4d:	09 f1                	or     %esi,%ecx
  801a4f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a53:	89 f9                	mov    %edi,%ecx
  801a55:	d3 e0                	shl    %cl,%eax
  801a57:	89 c5                	mov    %eax,%ebp
  801a59:	89 d6                	mov    %edx,%esi
  801a5b:	88 d9                	mov    %bl,%cl
  801a5d:	d3 ee                	shr    %cl,%esi
  801a5f:	89 f9                	mov    %edi,%ecx
  801a61:	d3 e2                	shl    %cl,%edx
  801a63:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a67:	88 d9                	mov    %bl,%cl
  801a69:	d3 e8                	shr    %cl,%eax
  801a6b:	09 c2                	or     %eax,%edx
  801a6d:	89 d0                	mov    %edx,%eax
  801a6f:	89 f2                	mov    %esi,%edx
  801a71:	f7 74 24 0c          	divl   0xc(%esp)
  801a75:	89 d6                	mov    %edx,%esi
  801a77:	89 c3                	mov    %eax,%ebx
  801a79:	f7 e5                	mul    %ebp
  801a7b:	39 d6                	cmp    %edx,%esi
  801a7d:	72 19                	jb     801a98 <__udivdi3+0xfc>
  801a7f:	74 0b                	je     801a8c <__udivdi3+0xf0>
  801a81:	89 d8                	mov    %ebx,%eax
  801a83:	31 ff                	xor    %edi,%edi
  801a85:	e9 58 ff ff ff       	jmp    8019e2 <__udivdi3+0x46>
  801a8a:	66 90                	xchg   %ax,%ax
  801a8c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a90:	89 f9                	mov    %edi,%ecx
  801a92:	d3 e2                	shl    %cl,%edx
  801a94:	39 c2                	cmp    %eax,%edx
  801a96:	73 e9                	jae    801a81 <__udivdi3+0xe5>
  801a98:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a9b:	31 ff                	xor    %edi,%edi
  801a9d:	e9 40 ff ff ff       	jmp    8019e2 <__udivdi3+0x46>
  801aa2:	66 90                	xchg   %ax,%ax
  801aa4:	31 c0                	xor    %eax,%eax
  801aa6:	e9 37 ff ff ff       	jmp    8019e2 <__udivdi3+0x46>
  801aab:	90                   	nop

00801aac <__umoddi3>:
  801aac:	55                   	push   %ebp
  801aad:	57                   	push   %edi
  801aae:	56                   	push   %esi
  801aaf:	53                   	push   %ebx
  801ab0:	83 ec 1c             	sub    $0x1c,%esp
  801ab3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ab7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801abb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801abf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ac3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ac7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801acb:	89 f3                	mov    %esi,%ebx
  801acd:	89 fa                	mov    %edi,%edx
  801acf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad3:	89 34 24             	mov    %esi,(%esp)
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	75 1a                	jne    801af4 <__umoddi3+0x48>
  801ada:	39 f7                	cmp    %esi,%edi
  801adc:	0f 86 a2 00 00 00    	jbe    801b84 <__umoddi3+0xd8>
  801ae2:	89 c8                	mov    %ecx,%eax
  801ae4:	89 f2                	mov    %esi,%edx
  801ae6:	f7 f7                	div    %edi
  801ae8:	89 d0                	mov    %edx,%eax
  801aea:	31 d2                	xor    %edx,%edx
  801aec:	83 c4 1c             	add    $0x1c,%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5f                   	pop    %edi
  801af2:	5d                   	pop    %ebp
  801af3:	c3                   	ret    
  801af4:	39 f0                	cmp    %esi,%eax
  801af6:	0f 87 ac 00 00 00    	ja     801ba8 <__umoddi3+0xfc>
  801afc:	0f bd e8             	bsr    %eax,%ebp
  801aff:	83 f5 1f             	xor    $0x1f,%ebp
  801b02:	0f 84 ac 00 00 00    	je     801bb4 <__umoddi3+0x108>
  801b08:	bf 20 00 00 00       	mov    $0x20,%edi
  801b0d:	29 ef                	sub    %ebp,%edi
  801b0f:	89 fe                	mov    %edi,%esi
  801b11:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b15:	89 e9                	mov    %ebp,%ecx
  801b17:	d3 e0                	shl    %cl,%eax
  801b19:	89 d7                	mov    %edx,%edi
  801b1b:	89 f1                	mov    %esi,%ecx
  801b1d:	d3 ef                	shr    %cl,%edi
  801b1f:	09 c7                	or     %eax,%edi
  801b21:	89 e9                	mov    %ebp,%ecx
  801b23:	d3 e2                	shl    %cl,%edx
  801b25:	89 14 24             	mov    %edx,(%esp)
  801b28:	89 d8                	mov    %ebx,%eax
  801b2a:	d3 e0                	shl    %cl,%eax
  801b2c:	89 c2                	mov    %eax,%edx
  801b2e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b32:	d3 e0                	shl    %cl,%eax
  801b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b38:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b3c:	89 f1                	mov    %esi,%ecx
  801b3e:	d3 e8                	shr    %cl,%eax
  801b40:	09 d0                	or     %edx,%eax
  801b42:	d3 eb                	shr    %cl,%ebx
  801b44:	89 da                	mov    %ebx,%edx
  801b46:	f7 f7                	div    %edi
  801b48:	89 d3                	mov    %edx,%ebx
  801b4a:	f7 24 24             	mull   (%esp)
  801b4d:	89 c6                	mov    %eax,%esi
  801b4f:	89 d1                	mov    %edx,%ecx
  801b51:	39 d3                	cmp    %edx,%ebx
  801b53:	0f 82 87 00 00 00    	jb     801be0 <__umoddi3+0x134>
  801b59:	0f 84 91 00 00 00    	je     801bf0 <__umoddi3+0x144>
  801b5f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b63:	29 f2                	sub    %esi,%edx
  801b65:	19 cb                	sbb    %ecx,%ebx
  801b67:	89 d8                	mov    %ebx,%eax
  801b69:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b6d:	d3 e0                	shl    %cl,%eax
  801b6f:	89 e9                	mov    %ebp,%ecx
  801b71:	d3 ea                	shr    %cl,%edx
  801b73:	09 d0                	or     %edx,%eax
  801b75:	89 e9                	mov    %ebp,%ecx
  801b77:	d3 eb                	shr    %cl,%ebx
  801b79:	89 da                	mov    %ebx,%edx
  801b7b:	83 c4 1c             	add    $0x1c,%esp
  801b7e:	5b                   	pop    %ebx
  801b7f:	5e                   	pop    %esi
  801b80:	5f                   	pop    %edi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    
  801b83:	90                   	nop
  801b84:	89 fd                	mov    %edi,%ebp
  801b86:	85 ff                	test   %edi,%edi
  801b88:	75 0b                	jne    801b95 <__umoddi3+0xe9>
  801b8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8f:	31 d2                	xor    %edx,%edx
  801b91:	f7 f7                	div    %edi
  801b93:	89 c5                	mov    %eax,%ebp
  801b95:	89 f0                	mov    %esi,%eax
  801b97:	31 d2                	xor    %edx,%edx
  801b99:	f7 f5                	div    %ebp
  801b9b:	89 c8                	mov    %ecx,%eax
  801b9d:	f7 f5                	div    %ebp
  801b9f:	89 d0                	mov    %edx,%eax
  801ba1:	e9 44 ff ff ff       	jmp    801aea <__umoddi3+0x3e>
  801ba6:	66 90                	xchg   %ax,%ax
  801ba8:	89 c8                	mov    %ecx,%eax
  801baa:	89 f2                	mov    %esi,%edx
  801bac:	83 c4 1c             	add    $0x1c,%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5f                   	pop    %edi
  801bb2:	5d                   	pop    %ebp
  801bb3:	c3                   	ret    
  801bb4:	3b 04 24             	cmp    (%esp),%eax
  801bb7:	72 06                	jb     801bbf <__umoddi3+0x113>
  801bb9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bbd:	77 0f                	ja     801bce <__umoddi3+0x122>
  801bbf:	89 f2                	mov    %esi,%edx
  801bc1:	29 f9                	sub    %edi,%ecx
  801bc3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bc7:	89 14 24             	mov    %edx,(%esp)
  801bca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bce:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bd2:	8b 14 24             	mov    (%esp),%edx
  801bd5:	83 c4 1c             	add    $0x1c,%esp
  801bd8:	5b                   	pop    %ebx
  801bd9:	5e                   	pop    %esi
  801bda:	5f                   	pop    %edi
  801bdb:	5d                   	pop    %ebp
  801bdc:	c3                   	ret    
  801bdd:	8d 76 00             	lea    0x0(%esi),%esi
  801be0:	2b 04 24             	sub    (%esp),%eax
  801be3:	19 fa                	sbb    %edi,%edx
  801be5:	89 d1                	mov    %edx,%ecx
  801be7:	89 c6                	mov    %eax,%esi
  801be9:	e9 71 ff ff ff       	jmp    801b5f <__umoddi3+0xb3>
  801bee:	66 90                	xchg   %ax,%ax
  801bf0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bf4:	72 ea                	jb     801be0 <__umoddi3+0x134>
  801bf6:	89 d9                	mov    %ebx,%ecx
  801bf8:	e9 62 ff ff ff       	jmp    801b5f <__umoddi3+0xb3>
