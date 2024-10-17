
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
  80003e:	e8 70 14 00 00       	call   8014b3 <rsttst>
	int ID1 = sys_create_env("tsc2_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800043:	a1 04 30 80 00       	mov    0x803004,%eax
  800048:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  80004e:	a1 04 30 80 00       	mov    0x803004,%eax
  800053:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800059:	89 c1                	mov    %eax,%ecx
  80005b:	a1 04 30 80 00       	mov    0x803004,%eax
  800060:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800066:	52                   	push   %edx
  800067:	51                   	push   %ecx
  800068:	50                   	push   %eax
  800069:	68 20 1c 80 00       	push   $0x801c20
  80006e:	e8 f4 12 00 00       	call   801367 <sys_create_env>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_run_env(ID1);
  800079:	83 ec 0c             	sub    $0xc,%esp
  80007c:	ff 75 f4             	pushl  -0xc(%ebp)
  80007f:	e8 01 13 00 00       	call   801385 <sys_run_env>
  800084:	83 c4 10             	add    $0x10,%esp

	int ID2 = sys_create_env("tsc2_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800087:	a1 04 30 80 00       	mov    0x803004,%eax
  80008c:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800092:	a1 04 30 80 00       	mov    0x803004,%eax
  800097:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  80009d:	89 c1                	mov    %eax,%ecx
  80009f:	a1 04 30 80 00       	mov    0x803004,%eax
  8000a4:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000aa:	52                   	push   %edx
  8000ab:	51                   	push   %ecx
  8000ac:	50                   	push   %eax
  8000ad:	68 2c 1c 80 00       	push   $0x801c2c
  8000b2:	e8 b0 12 00 00       	call   801367 <sys_create_env>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
//	sys_run_env(ID2);

	int ID3 = sys_create_env("tsc2_slave3", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000bd:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c2:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  8000c8:	a1 04 30 80 00       	mov    0x803004,%eax
  8000cd:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  8000d3:	89 c1                	mov    %eax,%ecx
  8000d5:	a1 04 30 80 00       	mov    0x803004,%eax
  8000da:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8000e0:	52                   	push   %edx
  8000e1:	51                   	push   %ecx
  8000e2:	50                   	push   %eax
  8000e3:	68 38 1c 80 00       	push   $0x801c38
  8000e8:	e8 7a 12 00 00       	call   801367 <sys_create_env>
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
//	sys_run_env(ID3);
	env_sleep(10000);
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	68 10 27 00 00       	push   $0x2710
  8000fb:	e8 19 16 00 00       	call   801719 <env_sleep>
  800100:	83 c4 10             	add    $0x10,%esp

	if (gettst() != 0)
  800103:	e8 25 14 00 00       	call   80152d <gettst>
  800108:	85 c0                	test   %eax,%eax
  80010a:	74 12                	je     80011e <_main+0xe6>
		cprintf("\ntst_syscalls_2 Failed.\n");
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	68 44 1c 80 00       	push   $0x801c44
  800114:	e8 39 02 00 00       	call   800352 <cprintf>
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
  800121:	68 60 1c 80 00       	push   $0x801c60
  800126:	e8 27 02 00 00       	call   800352 <cprintf>
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
  800137:	e8 99 12 00 00       	call   8013d5 <sys_getenvindex>
  80013c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800142:	89 d0                	mov    %edx,%eax
  800144:	c1 e0 06             	shl    $0x6,%eax
  800147:	29 d0                	sub    %edx,%eax
  800149:	c1 e0 02             	shl    $0x2,%eax
  80014c:	01 d0                	add    %edx,%eax
  80014e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800155:	01 c8                	add    %ecx,%eax
  800157:	c1 e0 03             	shl    $0x3,%eax
  80015a:	01 d0                	add    %edx,%eax
  80015c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800163:	29 c2                	sub    %eax,%edx
  800165:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800174:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800179:	a1 04 30 80 00       	mov    0x803004,%eax
  80017e:	8a 40 20             	mov    0x20(%eax),%al
  800181:	84 c0                	test   %al,%al
  800183:	74 0d                	je     800192 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800185:	a1 04 30 80 00       	mov    0x803004,%eax
  80018a:	83 c0 20             	add    $0x20,%eax
  80018d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800192:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800196:	7e 0a                	jle    8001a2 <libmain+0x71>
		binaryname = argv[0];
  800198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019b:	8b 00                	mov    (%eax),%eax
  80019d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	ff 75 0c             	pushl  0xc(%ebp)
  8001a8:	ff 75 08             	pushl  0x8(%ebp)
  8001ab:	e8 88 fe ff ff       	call   800038 <_main>
  8001b0:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001b3:	e8 a1 0f 00 00       	call   801159 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 b8 1c 80 00       	push   $0x801cb8
  8001c0:	e8 8d 01 00 00       	call   800352 <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c8:	a1 04 30 80 00       	mov    0x803004,%eax
  8001cd:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  8001d3:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d8:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	52                   	push   %edx
  8001e2:	50                   	push   %eax
  8001e3:	68 e0 1c 80 00       	push   $0x801ce0
  8001e8:	e8 65 01 00 00       	call   800352 <cprintf>
  8001ed:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f0:	a1 04 30 80 00       	mov    0x803004,%eax
  8001f5:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8001fb:	a1 04 30 80 00       	mov    0x803004,%eax
  800200:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800206:	a1 04 30 80 00       	mov    0x803004,%eax
  80020b:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  800211:	51                   	push   %ecx
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	68 08 1d 80 00       	push   $0x801d08
  800219:	e8 34 01 00 00       	call   800352 <cprintf>
  80021e:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800221:	a1 04 30 80 00       	mov    0x803004,%eax
  800226:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	50                   	push   %eax
  800230:	68 60 1d 80 00       	push   $0x801d60
  800235:	e8 18 01 00 00       	call   800352 <cprintf>
  80023a:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	68 b8 1c 80 00       	push   $0x801cb8
  800245:	e8 08 01 00 00       	call   800352 <cprintf>
  80024a:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80024d:	e8 21 0f 00 00       	call   801173 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800252:	e8 19 00 00 00       	call   800270 <exit>
}
  800257:	90                   	nop
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	6a 00                	push   $0x0
  800265:	e8 37 11 00 00       	call   8013a1 <sys_destroy_env>
  80026a:	83 c4 10             	add    $0x10,%esp
}
  80026d:	90                   	nop
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <exit>:

void
exit(void)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800276:	e8 8c 11 00 00       	call   801407 <sys_exit_env>
}
  80027b:	90                   	nop
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	8d 48 01             	lea    0x1(%eax),%ecx
  80028c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028f:	89 0a                	mov    %ecx,(%edx)
  800291:	8b 55 08             	mov    0x8(%ebp),%edx
  800294:	88 d1                	mov    %dl,%cl
  800296:	8b 55 0c             	mov    0xc(%ebp),%edx
  800299:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80029d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a0:	8b 00                	mov    (%eax),%eax
  8002a2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a7:	75 2c                	jne    8002d5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002a9:	a0 08 30 80 00       	mov    0x803008,%al
  8002ae:	0f b6 c0             	movzbl %al,%eax
  8002b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b4:	8b 12                	mov    (%edx),%edx
  8002b6:	89 d1                	mov    %edx,%ecx
  8002b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bb:	83 c2 08             	add    $0x8,%edx
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	50                   	push   %eax
  8002c2:	51                   	push   %ecx
  8002c3:	52                   	push   %edx
  8002c4:	e8 4e 0e 00 00       	call   801117 <sys_cputs>
  8002c9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d8:	8b 40 04             	mov    0x4(%eax),%eax
  8002db:	8d 50 01             	lea    0x1(%eax),%edx
  8002de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002e4:	90                   	nop
  8002e5:	c9                   	leave  
  8002e6:	c3                   	ret    

008002e7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f7:	00 00 00 
	b.cnt = 0;
  8002fa:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800301:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800310:	50                   	push   %eax
  800311:	68 7e 02 80 00       	push   $0x80027e
  800316:	e8 11 02 00 00       	call   80052c <vprintfmt>
  80031b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80031e:	a0 08 30 80 00       	mov    0x803008,%al
  800323:	0f b6 c0             	movzbl %al,%eax
  800326:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80032c:	83 ec 04             	sub    $0x4,%esp
  80032f:	50                   	push   %eax
  800330:	52                   	push   %edx
  800331:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800337:	83 c0 08             	add    $0x8,%eax
  80033a:	50                   	push   %eax
  80033b:	e8 d7 0d 00 00       	call   801117 <sys_cputs>
  800340:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800343:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  80034a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800350:	c9                   	leave  
  800351:	c3                   	ret    

00800352 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800358:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80035f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800362:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	ff 75 f4             	pushl  -0xc(%ebp)
  80036e:	50                   	push   %eax
  80036f:	e8 73 ff ff ff       	call   8002e7 <vcprintf>
  800374:	83 c4 10             	add    $0x10,%esp
  800377:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80037a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800385:	e8 cf 0d 00 00       	call   801159 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80038a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800390:	8b 45 08             	mov    0x8(%ebp),%eax
  800393:	83 ec 08             	sub    $0x8,%esp
  800396:	ff 75 f4             	pushl  -0xc(%ebp)
  800399:	50                   	push   %eax
  80039a:	e8 48 ff ff ff       	call   8002e7 <vcprintf>
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003a5:	e8 c9 0d 00 00       	call   801173 <sys_unlock_cons>
	return cnt;
  8003aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003ad:	c9                   	leave  
  8003ae:	c3                   	ret    

008003af <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	53                   	push   %ebx
  8003b3:	83 ec 14             	sub    $0x14,%esp
  8003b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ca:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003cd:	77 55                	ja     800424 <printnum+0x75>
  8003cf:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003d2:	72 05                	jb     8003d9 <printnum+0x2a>
  8003d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003d7:	77 4b                	ja     800424 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003dc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003df:	8b 45 18             	mov    0x18(%ebp),%eax
  8003e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e7:	52                   	push   %edx
  8003e8:	50                   	push   %eax
  8003e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8003ef:	e8 c4 15 00 00       	call   8019b8 <__udivdi3>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	83 ec 04             	sub    $0x4,%esp
  8003fa:	ff 75 20             	pushl  0x20(%ebp)
  8003fd:	53                   	push   %ebx
  8003fe:	ff 75 18             	pushl  0x18(%ebp)
  800401:	52                   	push   %edx
  800402:	50                   	push   %eax
  800403:	ff 75 0c             	pushl  0xc(%ebp)
  800406:	ff 75 08             	pushl  0x8(%ebp)
  800409:	e8 a1 ff ff ff       	call   8003af <printnum>
  80040e:	83 c4 20             	add    $0x20,%esp
  800411:	eb 1a                	jmp    80042d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	ff 75 0c             	pushl  0xc(%ebp)
  800419:	ff 75 20             	pushl  0x20(%ebp)
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	ff d0                	call   *%eax
  800421:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800424:	ff 4d 1c             	decl   0x1c(%ebp)
  800427:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80042b:	7f e6                	jg     800413 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80042d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800430:	bb 00 00 00 00       	mov    $0x0,%ebx
  800435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800438:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80043b:	53                   	push   %ebx
  80043c:	51                   	push   %ecx
  80043d:	52                   	push   %edx
  80043e:	50                   	push   %eax
  80043f:	e8 84 16 00 00       	call   801ac8 <__umoddi3>
  800444:	83 c4 10             	add    $0x10,%esp
  800447:	05 94 1f 80 00       	add    $0x801f94,%eax
  80044c:	8a 00                	mov    (%eax),%al
  80044e:	0f be c0             	movsbl %al,%eax
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	ff 75 0c             	pushl  0xc(%ebp)
  800457:	50                   	push   %eax
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	ff d0                	call   *%eax
  80045d:	83 c4 10             	add    $0x10,%esp
}
  800460:	90                   	nop
  800461:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800464:	c9                   	leave  
  800465:	c3                   	ret    

00800466 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800469:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80046d:	7e 1c                	jle    80048b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	8b 00                	mov    (%eax),%eax
  800474:	8d 50 08             	lea    0x8(%eax),%edx
  800477:	8b 45 08             	mov    0x8(%ebp),%eax
  80047a:	89 10                	mov    %edx,(%eax)
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	83 e8 08             	sub    $0x8,%eax
  800484:	8b 50 04             	mov    0x4(%eax),%edx
  800487:	8b 00                	mov    (%eax),%eax
  800489:	eb 40                	jmp    8004cb <getuint+0x65>
	else if (lflag)
  80048b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80048f:	74 1e                	je     8004af <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	8d 50 04             	lea    0x4(%eax),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	89 10                	mov    %edx,(%eax)
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	83 e8 04             	sub    $0x4,%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ad:	eb 1c                	jmp    8004cb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	8d 50 04             	lea    0x4(%eax),%edx
  8004b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ba:	89 10                	mov    %edx,(%eax)
  8004bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	83 e8 04             	sub    $0x4,%eax
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004cb:	5d                   	pop    %ebp
  8004cc:	c3                   	ret    

008004cd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004cd:	55                   	push   %ebp
  8004ce:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004d4:	7e 1c                	jle    8004f2 <getint+0x25>
		return va_arg(*ap, long long);
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	8d 50 08             	lea    0x8(%eax),%edx
  8004de:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e1:	89 10                	mov    %edx,(%eax)
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	8b 00                	mov    (%eax),%eax
  8004e8:	83 e8 08             	sub    $0x8,%eax
  8004eb:	8b 50 04             	mov    0x4(%eax),%edx
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	eb 38                	jmp    80052a <getint+0x5d>
	else if (lflag)
  8004f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004f6:	74 1a                	je     800512 <getint+0x45>
		return va_arg(*ap, long);
  8004f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fb:	8b 00                	mov    (%eax),%eax
  8004fd:	8d 50 04             	lea    0x4(%eax),%edx
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	89 10                	mov    %edx,(%eax)
  800505:	8b 45 08             	mov    0x8(%ebp),%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	83 e8 04             	sub    $0x4,%eax
  80050d:	8b 00                	mov    (%eax),%eax
  80050f:	99                   	cltd   
  800510:	eb 18                	jmp    80052a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800512:	8b 45 08             	mov    0x8(%ebp),%eax
  800515:	8b 00                	mov    (%eax),%eax
  800517:	8d 50 04             	lea    0x4(%eax),%edx
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	89 10                	mov    %edx,(%eax)
  80051f:	8b 45 08             	mov    0x8(%ebp),%eax
  800522:	8b 00                	mov    (%eax),%eax
  800524:	83 e8 04             	sub    $0x4,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	99                   	cltd   
}
  80052a:	5d                   	pop    %ebp
  80052b:	c3                   	ret    

0080052c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
  80052f:	56                   	push   %esi
  800530:	53                   	push   %ebx
  800531:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800534:	eb 17                	jmp    80054d <vprintfmt+0x21>
			if (ch == '\0')
  800536:	85 db                	test   %ebx,%ebx
  800538:	0f 84 c1 03 00 00    	je     8008ff <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	ff 75 0c             	pushl  0xc(%ebp)
  800544:	53                   	push   %ebx
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	ff d0                	call   *%eax
  80054a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80054d:	8b 45 10             	mov    0x10(%ebp),%eax
  800550:	8d 50 01             	lea    0x1(%eax),%edx
  800553:	89 55 10             	mov    %edx,0x10(%ebp)
  800556:	8a 00                	mov    (%eax),%al
  800558:	0f b6 d8             	movzbl %al,%ebx
  80055b:	83 fb 25             	cmp    $0x25,%ebx
  80055e:	75 d6                	jne    800536 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800560:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800564:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80056b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800572:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800579:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800580:	8b 45 10             	mov    0x10(%ebp),%eax
  800583:	8d 50 01             	lea    0x1(%eax),%edx
  800586:	89 55 10             	mov    %edx,0x10(%ebp)
  800589:	8a 00                	mov    (%eax),%al
  80058b:	0f b6 d8             	movzbl %al,%ebx
  80058e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800591:	83 f8 5b             	cmp    $0x5b,%eax
  800594:	0f 87 3d 03 00 00    	ja     8008d7 <vprintfmt+0x3ab>
  80059a:	8b 04 85 b8 1f 80 00 	mov    0x801fb8(,%eax,4),%eax
  8005a1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005a7:	eb d7                	jmp    800580 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005a9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005ad:	eb d1                	jmp    800580 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b9:	89 d0                	mov    %edx,%eax
  8005bb:	c1 e0 02             	shl    $0x2,%eax
  8005be:	01 d0                	add    %edx,%eax
  8005c0:	01 c0                	add    %eax,%eax
  8005c2:	01 d8                	add    %ebx,%eax
  8005c4:	83 e8 30             	sub    $0x30,%eax
  8005c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cd:	8a 00                	mov    (%eax),%al
  8005cf:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005d2:	83 fb 2f             	cmp    $0x2f,%ebx
  8005d5:	7e 3e                	jle    800615 <vprintfmt+0xe9>
  8005d7:	83 fb 39             	cmp    $0x39,%ebx
  8005da:	7f 39                	jg     800615 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005dc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005df:	eb d5                	jmp    8005b6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	83 c0 04             	add    $0x4,%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	83 e8 04             	sub    $0x4,%eax
  8005f0:	8b 00                	mov    (%eax),%eax
  8005f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005f5:	eb 1f                	jmp    800616 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fb:	79 83                	jns    800580 <vprintfmt+0x54>
				width = 0;
  8005fd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800604:	e9 77 ff ff ff       	jmp    800580 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800609:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800610:	e9 6b ff ff ff       	jmp    800580 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800615:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800616:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061a:	0f 89 60 ff ff ff    	jns    800580 <vprintfmt+0x54>
				width = precision, precision = -1;
  800620:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800626:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80062d:	e9 4e ff ff ff       	jmp    800580 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800632:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800635:	e9 46 ff ff ff       	jmp    800580 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	83 c0 04             	add    $0x4,%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
  800643:	8b 45 14             	mov    0x14(%ebp),%eax
  800646:	83 e8 04             	sub    $0x4,%eax
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	50                   	push   %eax
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	ff d0                	call   *%eax
  800657:	83 c4 10             	add    $0x10,%esp
			break;
  80065a:	e9 9b 02 00 00       	jmp    8008fa <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80065f:	8b 45 14             	mov    0x14(%ebp),%eax
  800662:	83 c0 04             	add    $0x4,%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	83 e8 04             	sub    $0x4,%eax
  80066e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800670:	85 db                	test   %ebx,%ebx
  800672:	79 02                	jns    800676 <vprintfmt+0x14a>
				err = -err;
  800674:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800676:	83 fb 64             	cmp    $0x64,%ebx
  800679:	7f 0b                	jg     800686 <vprintfmt+0x15a>
  80067b:	8b 34 9d 00 1e 80 00 	mov    0x801e00(,%ebx,4),%esi
  800682:	85 f6                	test   %esi,%esi
  800684:	75 19                	jne    80069f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800686:	53                   	push   %ebx
  800687:	68 a5 1f 80 00       	push   $0x801fa5
  80068c:	ff 75 0c             	pushl  0xc(%ebp)
  80068f:	ff 75 08             	pushl  0x8(%ebp)
  800692:	e8 70 02 00 00       	call   800907 <printfmt>
  800697:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80069a:	e9 5b 02 00 00       	jmp    8008fa <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80069f:	56                   	push   %esi
  8006a0:	68 ae 1f 80 00       	push   $0x801fae
  8006a5:	ff 75 0c             	pushl  0xc(%ebp)
  8006a8:	ff 75 08             	pushl  0x8(%ebp)
  8006ab:	e8 57 02 00 00       	call   800907 <printfmt>
  8006b0:	83 c4 10             	add    $0x10,%esp
			break;
  8006b3:	e9 42 02 00 00       	jmp    8008fa <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	83 c0 04             	add    $0x4,%eax
  8006be:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	83 e8 04             	sub    $0x4,%eax
  8006c7:	8b 30                	mov    (%eax),%esi
  8006c9:	85 f6                	test   %esi,%esi
  8006cb:	75 05                	jne    8006d2 <vprintfmt+0x1a6>
				p = "(null)";
  8006cd:	be b1 1f 80 00       	mov    $0x801fb1,%esi
			if (width > 0 && padc != '-')
  8006d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d6:	7e 6d                	jle    800745 <vprintfmt+0x219>
  8006d8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006dc:	74 67                	je     800745 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e1:	83 ec 08             	sub    $0x8,%esp
  8006e4:	50                   	push   %eax
  8006e5:	56                   	push   %esi
  8006e6:	e8 1e 03 00 00       	call   800a09 <strnlen>
  8006eb:	83 c4 10             	add    $0x10,%esp
  8006ee:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006f1:	eb 16                	jmp    800709 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006f3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006f7:	83 ec 08             	sub    $0x8,%esp
  8006fa:	ff 75 0c             	pushl  0xc(%ebp)
  8006fd:	50                   	push   %eax
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	ff d0                	call   *%eax
  800703:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800706:	ff 4d e4             	decl   -0x1c(%ebp)
  800709:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070d:	7f e4                	jg     8006f3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070f:	eb 34                	jmp    800745 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800711:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800715:	74 1c                	je     800733 <vprintfmt+0x207>
  800717:	83 fb 1f             	cmp    $0x1f,%ebx
  80071a:	7e 05                	jle    800721 <vprintfmt+0x1f5>
  80071c:	83 fb 7e             	cmp    $0x7e,%ebx
  80071f:	7e 12                	jle    800733 <vprintfmt+0x207>
					putch('?', putdat);
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	6a 3f                	push   $0x3f
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	ff d0                	call   *%eax
  80072e:	83 c4 10             	add    $0x10,%esp
  800731:	eb 0f                	jmp    800742 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800733:	83 ec 08             	sub    $0x8,%esp
  800736:	ff 75 0c             	pushl  0xc(%ebp)
  800739:	53                   	push   %ebx
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	ff d0                	call   *%eax
  80073f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800742:	ff 4d e4             	decl   -0x1c(%ebp)
  800745:	89 f0                	mov    %esi,%eax
  800747:	8d 70 01             	lea    0x1(%eax),%esi
  80074a:	8a 00                	mov    (%eax),%al
  80074c:	0f be d8             	movsbl %al,%ebx
  80074f:	85 db                	test   %ebx,%ebx
  800751:	74 24                	je     800777 <vprintfmt+0x24b>
  800753:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800757:	78 b8                	js     800711 <vprintfmt+0x1e5>
  800759:	ff 4d e0             	decl   -0x20(%ebp)
  80075c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800760:	79 af                	jns    800711 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800762:	eb 13                	jmp    800777 <vprintfmt+0x24b>
				putch(' ', putdat);
  800764:	83 ec 08             	sub    $0x8,%esp
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	6a 20                	push   $0x20
  80076c:	8b 45 08             	mov    0x8(%ebp),%eax
  80076f:	ff d0                	call   *%eax
  800771:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800774:	ff 4d e4             	decl   -0x1c(%ebp)
  800777:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077b:	7f e7                	jg     800764 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80077d:	e9 78 01 00 00       	jmp    8008fa <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 e8             	pushl  -0x18(%ebp)
  800788:	8d 45 14             	lea    0x14(%ebp),%eax
  80078b:	50                   	push   %eax
  80078c:	e8 3c fd ff ff       	call   8004cd <getint>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800797:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80079a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007a0:	85 d2                	test   %edx,%edx
  8007a2:	79 23                	jns    8007c7 <vprintfmt+0x29b>
				putch('-', putdat);
  8007a4:	83 ec 08             	sub    $0x8,%esp
  8007a7:	ff 75 0c             	pushl  0xc(%ebp)
  8007aa:	6a 2d                	push   $0x2d
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	ff d0                	call   *%eax
  8007b1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ba:	f7 d8                	neg    %eax
  8007bc:	83 d2 00             	adc    $0x0,%edx
  8007bf:	f7 da                	neg    %edx
  8007c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007c7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007ce:	e9 bc 00 00 00       	jmp    80088f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d3:	83 ec 08             	sub    $0x8,%esp
  8007d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007dc:	50                   	push   %eax
  8007dd:	e8 84 fc ff ff       	call   800466 <getuint>
  8007e2:	83 c4 10             	add    $0x10,%esp
  8007e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007eb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f2:	e9 98 00 00 00       	jmp    80088f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	6a 58                	push   $0x58
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	ff d0                	call   *%eax
  800804:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800807:	83 ec 08             	sub    $0x8,%esp
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	6a 58                	push   $0x58
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	6a 58                	push   $0x58
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	ff d0                	call   *%eax
  800824:	83 c4 10             	add    $0x10,%esp
			break;
  800827:	e9 ce 00 00 00       	jmp    8008fa <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	6a 30                	push   $0x30
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	ff d0                	call   *%eax
  800839:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	6a 78                	push   $0x78
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 c0 04             	add    $0x4,%eax
  800852:	89 45 14             	mov    %eax,0x14(%ebp)
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	83 e8 04             	sub    $0x4,%eax
  80085b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80085d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800860:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800867:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80086e:	eb 1f                	jmp    80088f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 e8             	pushl  -0x18(%ebp)
  800876:	8d 45 14             	lea    0x14(%ebp),%eax
  800879:	50                   	push   %eax
  80087a:	e8 e7 fb ff ff       	call   800466 <getuint>
  80087f:	83 c4 10             	add    $0x10,%esp
  800882:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800885:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800888:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80088f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800896:	83 ec 04             	sub    $0x4,%esp
  800899:	52                   	push   %edx
  80089a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80089d:	50                   	push   %eax
  80089e:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 00 fb ff ff       	call   8003af <printnum>
  8008af:	83 c4 20             	add    $0x20,%esp
			break;
  8008b2:	eb 46                	jmp    8008fa <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	53                   	push   %ebx
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
			break;
  8008c3:	eb 35                	jmp    8008fa <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8008c5:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  8008cc:	eb 2c                	jmp    8008fa <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8008ce:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  8008d5:	eb 23                	jmp    8008fa <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008d7:	83 ec 08             	sub    $0x8,%esp
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	6a 25                	push   $0x25
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e7:	ff 4d 10             	decl   0x10(%ebp)
  8008ea:	eb 03                	jmp    8008ef <vprintfmt+0x3c3>
  8008ec:	ff 4d 10             	decl   0x10(%ebp)
  8008ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f2:	48                   	dec    %eax
  8008f3:	8a 00                	mov    (%eax),%al
  8008f5:	3c 25                	cmp    $0x25,%al
  8008f7:	75 f3                	jne    8008ec <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008f9:	90                   	nop
		}
	}
  8008fa:	e9 35 fc ff ff       	jmp    800534 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008ff:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800900:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800903:	5b                   	pop    %ebx
  800904:	5e                   	pop    %esi
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80090d:	8d 45 10             	lea    0x10(%ebp),%eax
  800910:	83 c0 04             	add    $0x4,%eax
  800913:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800916:	8b 45 10             	mov    0x10(%ebp),%eax
  800919:	ff 75 f4             	pushl  -0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	ff 75 08             	pushl  0x8(%ebp)
  800923:	e8 04 fc ff ff       	call   80052c <vprintfmt>
  800928:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80092b:	90                   	nop
  80092c:	c9                   	leave  
  80092d:	c3                   	ret    

0080092e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800931:	8b 45 0c             	mov    0xc(%ebp),%eax
  800934:	8b 40 08             	mov    0x8(%eax),%eax
  800937:	8d 50 01             	lea    0x1(%eax),%edx
  80093a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800940:	8b 45 0c             	mov    0xc(%ebp),%eax
  800943:	8b 10                	mov    (%eax),%edx
  800945:	8b 45 0c             	mov    0xc(%ebp),%eax
  800948:	8b 40 04             	mov    0x4(%eax),%eax
  80094b:	39 c2                	cmp    %eax,%edx
  80094d:	73 12                	jae    800961 <sprintputch+0x33>
		*b->buf++ = ch;
  80094f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	8d 48 01             	lea    0x1(%eax),%ecx
  800957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095a:	89 0a                	mov    %ecx,(%edx)
  80095c:	8b 55 08             	mov    0x8(%ebp),%edx
  80095f:	88 10                	mov    %dl,(%eax)
}
  800961:	90                   	nop
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800970:	8b 45 0c             	mov    0xc(%ebp),%eax
  800973:	8d 50 ff             	lea    -0x1(%eax),%edx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	01 d0                	add    %edx,%eax
  80097b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800985:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800989:	74 06                	je     800991 <vsnprintf+0x2d>
  80098b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098f:	7f 07                	jg     800998 <vsnprintf+0x34>
		return -E_INVAL;
  800991:	b8 03 00 00 00       	mov    $0x3,%eax
  800996:	eb 20                	jmp    8009b8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800998:	ff 75 14             	pushl  0x14(%ebp)
  80099b:	ff 75 10             	pushl  0x10(%ebp)
  80099e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009a1:	50                   	push   %eax
  8009a2:	68 2e 09 80 00       	push   $0x80092e
  8009a7:	e8 80 fb ff ff       	call   80052c <vprintfmt>
  8009ac:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009b2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009b8:	c9                   	leave  
  8009b9:	c3                   	ret    

008009ba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009c0:	8d 45 10             	lea    0x10(%ebp),%eax
  8009c3:	83 c0 04             	add    $0x4,%eax
  8009c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8009cf:	50                   	push   %eax
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	ff 75 08             	pushl  0x8(%ebp)
  8009d6:	e8 89 ff ff ff       	call   800964 <vsnprintf>
  8009db:	83 c4 10             	add    $0x10,%esp
  8009de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009e4:	c9                   	leave  
  8009e5:	c3                   	ret    

008009e6 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009f3:	eb 06                	jmp    8009fb <strlen+0x15>
		n++;
  8009f5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f8:	ff 45 08             	incl   0x8(%ebp)
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	8a 00                	mov    (%eax),%al
  800a00:	84 c0                	test   %al,%al
  800a02:	75 f1                	jne    8009f5 <strlen+0xf>
		n++;
	return n;
  800a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a07:	c9                   	leave  
  800a08:	c3                   	ret    

00800a09 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a16:	eb 09                	jmp    800a21 <strnlen+0x18>
		n++;
  800a18:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a1b:	ff 45 08             	incl   0x8(%ebp)
  800a1e:	ff 4d 0c             	decl   0xc(%ebp)
  800a21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a25:	74 09                	je     800a30 <strnlen+0x27>
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	84 c0                	test   %al,%al
  800a2e:	75 e8                	jne    800a18 <strnlen+0xf>
		n++;
	return n;
  800a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a41:	90                   	nop
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8d 50 01             	lea    0x1(%eax),%edx
  800a48:	89 55 08             	mov    %edx,0x8(%ebp)
  800a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a51:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a54:	8a 12                	mov    (%edx),%dl
  800a56:	88 10                	mov    %dl,(%eax)
  800a58:	8a 00                	mov    (%eax),%al
  800a5a:	84 c0                	test   %al,%al
  800a5c:	75 e4                	jne    800a42 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a61:	c9                   	leave  
  800a62:	c3                   	ret    

00800a63 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a76:	eb 1f                	jmp    800a97 <strncpy+0x34>
		*dst++ = *src;
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	8d 50 01             	lea    0x1(%eax),%edx
  800a7e:	89 55 08             	mov    %edx,0x8(%ebp)
  800a81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a84:	8a 12                	mov    (%edx),%dl
  800a86:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8b:	8a 00                	mov    (%eax),%al
  800a8d:	84 c0                	test   %al,%al
  800a8f:	74 03                	je     800a94 <strncpy+0x31>
			src++;
  800a91:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a94:	ff 45 fc             	incl   -0x4(%ebp)
  800a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a9a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a9d:	72 d9                	jb     800a78 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aa2:	c9                   	leave  
  800aa3:	c3                   	ret    

00800aa4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ab0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab4:	74 30                	je     800ae6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ab6:	eb 16                	jmp    800ace <strlcpy+0x2a>
			*dst++ = *src++;
  800ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  800abb:	8d 50 01             	lea    0x1(%eax),%edx
  800abe:	89 55 08             	mov    %edx,0x8(%ebp)
  800ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ac7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aca:	8a 12                	mov    (%edx),%dl
  800acc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ace:	ff 4d 10             	decl   0x10(%ebp)
  800ad1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ad5:	74 09                	je     800ae0 <strlcpy+0x3c>
  800ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ada:	8a 00                	mov    (%eax),%al
  800adc:	84 c0                	test   %al,%al
  800ade:	75 d8                	jne    800ab8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aec:	29 c2                	sub    %eax,%edx
  800aee:	89 d0                	mov    %edx,%eax
}
  800af0:	c9                   	leave  
  800af1:	c3                   	ret    

00800af2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800af5:	eb 06                	jmp    800afd <strcmp+0xb>
		p++, q++;
  800af7:	ff 45 08             	incl   0x8(%ebp)
  800afa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	84 c0                	test   %al,%al
  800b04:	74 0e                	je     800b14 <strcmp+0x22>
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	8a 10                	mov    (%eax),%dl
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8a 00                	mov    (%eax),%al
  800b10:	38 c2                	cmp    %al,%dl
  800b12:	74 e3                	je     800af7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	0f b6 d0             	movzbl %al,%edx
  800b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1f:	8a 00                	mov    (%eax),%al
  800b21:	0f b6 c0             	movzbl %al,%eax
  800b24:	29 c2                	sub    %eax,%edx
  800b26:	89 d0                	mov    %edx,%eax
}
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b2d:	eb 09                	jmp    800b38 <strncmp+0xe>
		n--, p++, q++;
  800b2f:	ff 4d 10             	decl   0x10(%ebp)
  800b32:	ff 45 08             	incl   0x8(%ebp)
  800b35:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3c:	74 17                	je     800b55 <strncmp+0x2b>
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	8a 00                	mov    (%eax),%al
  800b43:	84 c0                	test   %al,%al
  800b45:	74 0e                	je     800b55 <strncmp+0x2b>
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	8a 10                	mov    (%eax),%dl
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	8a 00                	mov    (%eax),%al
  800b51:	38 c2                	cmp    %al,%dl
  800b53:	74 da                	je     800b2f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b59:	75 07                	jne    800b62 <strncmp+0x38>
		return 0;
  800b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b60:	eb 14                	jmp    800b76 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8a 00                	mov    (%eax),%al
  800b67:	0f b6 d0             	movzbl %al,%edx
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	0f b6 c0             	movzbl %al,%eax
  800b72:	29 c2                	sub    %eax,%edx
  800b74:	89 d0                	mov    %edx,%eax
}
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	83 ec 04             	sub    $0x4,%esp
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b84:	eb 12                	jmp    800b98 <strchr+0x20>
		if (*s == c)
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	8a 00                	mov    (%eax),%al
  800b8b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b8e:	75 05                	jne    800b95 <strchr+0x1d>
			return (char *) s;
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	eb 11                	jmp    800ba6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b95:	ff 45 08             	incl   0x8(%ebp)
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8a 00                	mov    (%eax),%al
  800b9d:	84 c0                	test   %al,%al
  800b9f:	75 e5                	jne    800b86 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ba1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    

00800ba8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	83 ec 04             	sub    $0x4,%esp
  800bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bb4:	eb 0d                	jmp    800bc3 <strfind+0x1b>
		if (*s == c)
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	8a 00                	mov    (%eax),%al
  800bbb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bbe:	74 0e                	je     800bce <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bc0:	ff 45 08             	incl   0x8(%ebp)
  800bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc6:	8a 00                	mov    (%eax),%al
  800bc8:	84 c0                	test   %al,%al
  800bca:	75 ea                	jne    800bb6 <strfind+0xe>
  800bcc:	eb 01                	jmp    800bcf <strfind+0x27>
		if (*s == c)
			break;
  800bce:	90                   	nop
	return (char *) s;
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800be0:	8b 45 10             	mov    0x10(%ebp),%eax
  800be3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800be6:	eb 0e                	jmp    800bf6 <memset+0x22>
		*p++ = c;
  800be8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800beb:	8d 50 01             	lea    0x1(%eax),%edx
  800bee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bf6:	ff 4d f8             	decl   -0x8(%ebp)
  800bf9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800bfd:	79 e9                	jns    800be8 <memset+0x14>
		*p++ = c;

	return v;
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c16:	eb 16                	jmp    800c2e <memcpy+0x2a>
		*d++ = *s++;
  800c18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c1b:	8d 50 01             	lea    0x1(%eax),%edx
  800c1e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c27:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c2a:	8a 12                	mov    (%edx),%dl
  800c2c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	89 55 10             	mov    %edx,0x10(%ebp)
  800c37:	85 c0                	test   %eax,%eax
  800c39:	75 dd                	jne    800c18 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c55:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c58:	73 50                	jae    800caa <memmove+0x6a>
  800c5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c60:	01 d0                	add    %edx,%eax
  800c62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c65:	76 43                	jbe    800caa <memmove+0x6a>
		s += n;
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c70:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c73:	eb 10                	jmp    800c85 <memmove+0x45>
			*--d = *--s;
  800c75:	ff 4d f8             	decl   -0x8(%ebp)
  800c78:	ff 4d fc             	decl   -0x4(%ebp)
  800c7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7e:	8a 10                	mov    (%eax),%dl
  800c80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c83:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c8e:	85 c0                	test   %eax,%eax
  800c90:	75 e3                	jne    800c75 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c92:	eb 23                	jmp    800cb7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c97:	8d 50 01             	lea    0x1(%eax),%edx
  800c9a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ca0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ca6:	8a 12                	mov    (%edx),%dl
  800ca8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800caa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cad:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cb0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cb3:	85 c0                	test   %eax,%eax
  800cb5:	75 dd                	jne    800c94 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cce:	eb 2a                	jmp    800cfa <memcmp+0x3e>
		if (*s1 != *s2)
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd3:	8a 10                	mov    (%eax),%dl
  800cd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	38 c2                	cmp    %al,%dl
  800cdc:	74 16                	je     800cf4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	0f b6 d0             	movzbl %al,%edx
  800ce6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 c0             	movzbl %al,%eax
  800cee:	29 c2                	sub    %eax,%edx
  800cf0:	89 d0                	mov    %edx,%eax
  800cf2:	eb 18                	jmp    800d0c <memcmp+0x50>
		s1++, s2++;
  800cf4:	ff 45 fc             	incl   -0x4(%ebp)
  800cf7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d00:	89 55 10             	mov    %edx,0x10(%ebp)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	75 c9                	jne    800cd0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1a:	01 d0                	add    %edx,%eax
  800d1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d1f:	eb 15                	jmp    800d36 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	0f b6 d0             	movzbl %al,%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	0f b6 c0             	movzbl %al,%eax
  800d2f:	39 c2                	cmp    %eax,%edx
  800d31:	74 0d                	je     800d40 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d33:	ff 45 08             	incl   0x8(%ebp)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d3c:	72 e3                	jb     800d21 <memfind+0x13>
  800d3e:	eb 01                	jmp    800d41 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d40:	90                   	nop
	return (void *) s;
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d44:	c9                   	leave  
  800d45:	c3                   	ret    

00800d46 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d5a:	eb 03                	jmp    800d5f <strtol+0x19>
		s++;
  800d5c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	3c 20                	cmp    $0x20,%al
  800d66:	74 f4                	je     800d5c <strtol+0x16>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	3c 09                	cmp    $0x9,%al
  800d6f:	74 eb                	je     800d5c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	8a 00                	mov    (%eax),%al
  800d76:	3c 2b                	cmp    $0x2b,%al
  800d78:	75 05                	jne    800d7f <strtol+0x39>
		s++;
  800d7a:	ff 45 08             	incl   0x8(%ebp)
  800d7d:	eb 13                	jmp    800d92 <strtol+0x4c>
	else if (*s == '-')
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 2d                	cmp    $0x2d,%al
  800d86:	75 0a                	jne    800d92 <strtol+0x4c>
		s++, neg = 1;
  800d88:	ff 45 08             	incl   0x8(%ebp)
  800d8b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d96:	74 06                	je     800d9e <strtol+0x58>
  800d98:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d9c:	75 20                	jne    800dbe <strtol+0x78>
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	3c 30                	cmp    $0x30,%al
  800da5:	75 17                	jne    800dbe <strtol+0x78>
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	40                   	inc    %eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 78                	cmp    $0x78,%al
  800daf:	75 0d                	jne    800dbe <strtol+0x78>
		s += 2, base = 16;
  800db1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800db5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dbc:	eb 28                	jmp    800de6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc2:	75 15                	jne    800dd9 <strtol+0x93>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	3c 30                	cmp    $0x30,%al
  800dcb:	75 0c                	jne    800dd9 <strtol+0x93>
		s++, base = 8;
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dd7:	eb 0d                	jmp    800de6 <strtol+0xa0>
	else if (base == 0)
  800dd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddd:	75 07                	jne    800de6 <strtol+0xa0>
		base = 10;
  800ddf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 00                	mov    (%eax),%al
  800deb:	3c 2f                	cmp    $0x2f,%al
  800ded:	7e 19                	jle    800e08 <strtol+0xc2>
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3c 39                	cmp    $0x39,%al
  800df6:	7f 10                	jg     800e08 <strtol+0xc2>
			dig = *s - '0';
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	0f be c0             	movsbl %al,%eax
  800e00:	83 e8 30             	sub    $0x30,%eax
  800e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e06:	eb 42                	jmp    800e4a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	3c 60                	cmp    $0x60,%al
  800e0f:	7e 19                	jle    800e2a <strtol+0xe4>
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	3c 7a                	cmp    $0x7a,%al
  800e18:	7f 10                	jg     800e2a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	0f be c0             	movsbl %al,%eax
  800e22:	83 e8 57             	sub    $0x57,%eax
  800e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e28:	eb 20                	jmp    800e4a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	3c 40                	cmp    $0x40,%al
  800e31:	7e 39                	jle    800e6c <strtol+0x126>
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	3c 5a                	cmp    $0x5a,%al
  800e3a:	7f 30                	jg     800e6c <strtol+0x126>
			dig = *s - 'A' + 10;
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	0f be c0             	movsbl %al,%eax
  800e44:	83 e8 37             	sub    $0x37,%eax
  800e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e50:	7d 19                	jge    800e6b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e52:	ff 45 08             	incl   0x8(%ebp)
  800e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e58:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e5c:	89 c2                	mov    %eax,%edx
  800e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e61:	01 d0                	add    %edx,%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e66:	e9 7b ff ff ff       	jmp    800de6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e6b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e70:	74 08                	je     800e7a <strtol+0x134>
		*endptr = (char *) s;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e7e:	74 07                	je     800e87 <strtol+0x141>
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e83:	f7 d8                	neg    %eax
  800e85:	eb 03                	jmp    800e8a <strtol+0x144>
  800e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    

00800e8c <ltostr>:

void
ltostr(long value, char *str)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e99:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ea0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ea4:	79 13                	jns    800eb9 <ltostr+0x2d>
	{
		neg = 1;
  800ea6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eb3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800eb6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ec1:	99                   	cltd   
  800ec2:	f7 f9                	idiv   %ecx
  800ec4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ec7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eca:	8d 50 01             	lea    0x1(%eax),%edx
  800ecd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed0:	89 c2                	mov    %eax,%edx
  800ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed5:	01 d0                	add    %edx,%eax
  800ed7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800eda:	83 c2 30             	add    $0x30,%edx
  800edd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800edf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee7:	f7 e9                	imul   %ecx
  800ee9:	c1 fa 02             	sar    $0x2,%edx
  800eec:	89 c8                	mov    %ecx,%eax
  800eee:	c1 f8 1f             	sar    $0x1f,%eax
  800ef1:	29 c2                	sub    %eax,%edx
  800ef3:	89 d0                	mov    %edx,%eax
  800ef5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800ef8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800efc:	75 bb                	jne    800eb9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800efe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	48                   	dec    %eax
  800f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f10:	74 3d                	je     800f4f <ltostr+0xc3>
		start = 1 ;
  800f12:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f19:	eb 34                	jmp    800f4f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f21:	01 d0                	add    %edx,%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	01 c2                	add    %eax,%edx
  800f30:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	01 c8                	add    %ecx,%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f42:	01 c2                	add    %eax,%edx
  800f44:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f47:	88 02                	mov    %al,(%edx)
		start++ ;
  800f49:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f4c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f55:	7c c4                	jl     800f1b <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f57:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	01 d0                	add    %edx,%eax
  800f5f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f62:	90                   	nop
  800f63:	c9                   	leave  
  800f64:	c3                   	ret    

00800f65 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f6b:	ff 75 08             	pushl  0x8(%ebp)
  800f6e:	e8 73 fa ff ff       	call   8009e6 <strlen>
  800f73:	83 c4 04             	add    $0x4,%esp
  800f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	e8 65 fa ff ff       	call   8009e6 <strlen>
  800f81:	83 c4 04             	add    $0x4,%esp
  800f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f95:	eb 17                	jmp    800fae <strcconcat+0x49>
		final[s] = str1[s] ;
  800f97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9d:	01 c2                	add    %eax,%edx
  800f9f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	01 c8                	add    %ecx,%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fab:	ff 45 fc             	incl   -0x4(%ebp)
  800fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fb4:	7c e1                	jl     800f97 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fb6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fbd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fc4:	eb 1f                	jmp    800fe5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc9:	8d 50 01             	lea    0x1(%eax),%edx
  800fcc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fcf:	89 c2                	mov    %eax,%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 c2                	add    %eax,%edx
  800fd6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	01 c8                	add    %ecx,%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fe2:	ff 45 f8             	incl   -0x8(%ebp)
  800fe5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800feb:	7c d9                	jl     800fc6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800fed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff3:	01 d0                	add    %edx,%eax
  800ff5:	c6 00 00             	movb   $0x0,(%eax)
}
  800ff8:	90                   	nop
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800ffe:	8b 45 14             	mov    0x14(%ebp),%eax
  801001:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801007:	8b 45 14             	mov    0x14(%ebp),%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801013:	8b 45 10             	mov    0x10(%ebp),%eax
  801016:	01 d0                	add    %edx,%eax
  801018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80101e:	eb 0c                	jmp    80102c <strsplit+0x31>
			*string++ = 0;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8d 50 01             	lea    0x1(%eax),%edx
  801026:	89 55 08             	mov    %edx,0x8(%ebp)
  801029:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	74 18                	je     80104d <strsplit+0x52>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	0f be c0             	movsbl %al,%eax
  80103d:	50                   	push   %eax
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	e8 32 fb ff ff       	call   800b78 <strchr>
  801046:	83 c4 08             	add    $0x8,%esp
  801049:	85 c0                	test   %eax,%eax
  80104b:	75 d3                	jne    801020 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	84 c0                	test   %al,%al
  801054:	74 5a                	je     8010b0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801056:	8b 45 14             	mov    0x14(%ebp),%eax
  801059:	8b 00                	mov    (%eax),%eax
  80105b:	83 f8 0f             	cmp    $0xf,%eax
  80105e:	75 07                	jne    801067 <strsplit+0x6c>
		{
			return 0;
  801060:	b8 00 00 00 00       	mov    $0x0,%eax
  801065:	eb 66                	jmp    8010cd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801067:	8b 45 14             	mov    0x14(%ebp),%eax
  80106a:	8b 00                	mov    (%eax),%eax
  80106c:	8d 48 01             	lea    0x1(%eax),%ecx
  80106f:	8b 55 14             	mov    0x14(%ebp),%edx
  801072:	89 0a                	mov    %ecx,(%edx)
  801074:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80107b:	8b 45 10             	mov    0x10(%ebp),%eax
  80107e:	01 c2                	add    %eax,%edx
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801085:	eb 03                	jmp    80108a <strsplit+0x8f>
			string++;
  801087:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80108a:	8b 45 08             	mov    0x8(%ebp),%eax
  80108d:	8a 00                	mov    (%eax),%al
  80108f:	84 c0                	test   %al,%al
  801091:	74 8b                	je     80101e <strsplit+0x23>
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	8a 00                	mov    (%eax),%al
  801098:	0f be c0             	movsbl %al,%eax
  80109b:	50                   	push   %eax
  80109c:	ff 75 0c             	pushl  0xc(%ebp)
  80109f:	e8 d4 fa ff ff       	call   800b78 <strchr>
  8010a4:	83 c4 08             	add    $0x8,%esp
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	74 dc                	je     801087 <strsplit+0x8c>
			string++;
	}
  8010ab:	e9 6e ff ff ff       	jmp    80101e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010b0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b4:	8b 00                	mov    (%eax),%eax
  8010b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c0:	01 d0                	add    %edx,%eax
  8010c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	68 28 21 80 00       	push   $0x802128
  8010dd:	68 3f 01 00 00       	push   $0x13f
  8010e2:	68 4a 21 80 00       	push   $0x80214a
  8010e7:	e8 e1 06 00 00       	call   8017cd <_panic>

008010ec <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	57                   	push   %edi
  8010f0:	56                   	push   %esi
  8010f1:	53                   	push   %ebx
  8010f2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801101:	8b 7d 18             	mov    0x18(%ebp),%edi
  801104:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801107:	cd 30                	int    $0x30
  801109:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80110c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80110f:	83 c4 10             	add    $0x10,%esp
  801112:	5b                   	pop    %ebx
  801113:	5e                   	pop    %esi
  801114:	5f                   	pop    %edi
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    

00801117 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	83 ec 04             	sub    $0x4,%esp
  80111d:	8b 45 10             	mov    0x10(%ebp),%eax
  801120:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801123:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	6a 00                	push   $0x0
  80112c:	6a 00                	push   $0x0
  80112e:	52                   	push   %edx
  80112f:	ff 75 0c             	pushl  0xc(%ebp)
  801132:	50                   	push   %eax
  801133:	6a 00                	push   $0x0
  801135:	e8 b2 ff ff ff       	call   8010ec <syscall>
  80113a:	83 c4 18             	add    $0x18,%esp
}
  80113d:	90                   	nop
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    

00801140 <sys_cgetc>:

int
sys_cgetc(void)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801143:	6a 00                	push   $0x0
  801145:	6a 00                	push   $0x0
  801147:	6a 00                	push   $0x0
  801149:	6a 00                	push   $0x0
  80114b:	6a 00                	push   $0x0
  80114d:	6a 02                	push   $0x2
  80114f:	e8 98 ff ff ff       	call   8010ec <syscall>
  801154:	83 c4 18             	add    $0x18,%esp
}
  801157:	c9                   	leave  
  801158:	c3                   	ret    

00801159 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80115c:	6a 00                	push   $0x0
  80115e:	6a 00                	push   $0x0
  801160:	6a 00                	push   $0x0
  801162:	6a 00                	push   $0x0
  801164:	6a 00                	push   $0x0
  801166:	6a 03                	push   $0x3
  801168:	e8 7f ff ff ff       	call   8010ec <syscall>
  80116d:	83 c4 18             	add    $0x18,%esp
}
  801170:	90                   	nop
  801171:	c9                   	leave  
  801172:	c3                   	ret    

00801173 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801176:	6a 00                	push   $0x0
  801178:	6a 00                	push   $0x0
  80117a:	6a 00                	push   $0x0
  80117c:	6a 00                	push   $0x0
  80117e:	6a 00                	push   $0x0
  801180:	6a 04                	push   $0x4
  801182:	e8 65 ff ff ff       	call   8010ec <syscall>
  801187:	83 c4 18             	add    $0x18,%esp
}
  80118a:	90                   	nop
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801190:	8b 55 0c             	mov    0xc(%ebp),%edx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	6a 00                	push   $0x0
  801198:	6a 00                	push   $0x0
  80119a:	6a 00                	push   $0x0
  80119c:	52                   	push   %edx
  80119d:	50                   	push   %eax
  80119e:	6a 08                	push   $0x8
  8011a0:	e8 47 ff ff ff       	call   8010ec <syscall>
  8011a5:	83 c4 18             	add    $0x18,%esp
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	56                   	push   %esi
  8011ae:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8011af:	8b 75 18             	mov    0x18(%ebp),%esi
  8011b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	56                   	push   %esi
  8011bf:	53                   	push   %ebx
  8011c0:	51                   	push   %ecx
  8011c1:	52                   	push   %edx
  8011c2:	50                   	push   %eax
  8011c3:	6a 09                	push   $0x9
  8011c5:	e8 22 ff ff ff       	call   8010ec <syscall>
  8011ca:	83 c4 18             	add    $0x18,%esp
}
  8011cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011d0:	5b                   	pop    %ebx
  8011d1:	5e                   	pop    %esi
  8011d2:	5d                   	pop    %ebp
  8011d3:	c3                   	ret    

008011d4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8011d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011da:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 00                	push   $0x0
  8011e3:	52                   	push   %edx
  8011e4:	50                   	push   %eax
  8011e5:	6a 0a                	push   $0xa
  8011e7:	e8 00 ff ff ff       	call   8010ec <syscall>
  8011ec:	83 c4 18             	add    $0x18,%esp
}
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	6a 00                	push   $0x0
  8011fa:	ff 75 0c             	pushl  0xc(%ebp)
  8011fd:	ff 75 08             	pushl  0x8(%ebp)
  801200:	6a 0b                	push   $0xb
  801202:	e8 e5 fe ff ff       	call   8010ec <syscall>
  801207:	83 c4 18             	add    $0x18,%esp
}
  80120a:	c9                   	leave  
  80120b:	c3                   	ret    

0080120c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80120f:	6a 00                	push   $0x0
  801211:	6a 00                	push   $0x0
  801213:	6a 00                	push   $0x0
  801215:	6a 00                	push   $0x0
  801217:	6a 00                	push   $0x0
  801219:	6a 0c                	push   $0xc
  80121b:	e8 cc fe ff ff       	call   8010ec <syscall>
  801220:	83 c4 18             	add    $0x18,%esp
}
  801223:	c9                   	leave  
  801224:	c3                   	ret    

00801225 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801225:	55                   	push   %ebp
  801226:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801228:	6a 00                	push   $0x0
  80122a:	6a 00                	push   $0x0
  80122c:	6a 00                	push   $0x0
  80122e:	6a 00                	push   $0x0
  801230:	6a 00                	push   $0x0
  801232:	6a 0d                	push   $0xd
  801234:	e8 b3 fe ff ff       	call   8010ec <syscall>
  801239:	83 c4 18             	add    $0x18,%esp
}
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 0e                	push   $0xe
  80124d:	e8 9a fe ff ff       	call   8010ec <syscall>
  801252:	83 c4 18             	add    $0x18,%esp
}
  801255:	c9                   	leave  
  801256:	c3                   	ret    

00801257 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80125a:	6a 00                	push   $0x0
  80125c:	6a 00                	push   $0x0
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 0f                	push   $0xf
  801266:	e8 81 fe ff ff       	call   8010ec <syscall>
  80126b:	83 c4 18             	add    $0x18,%esp
}
  80126e:	c9                   	leave  
  80126f:	c3                   	ret    

00801270 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	ff 75 08             	pushl  0x8(%ebp)
  80127e:	6a 10                	push   $0x10
  801280:	e8 67 fe ff ff       	call   8010ec <syscall>
  801285:	83 c4 18             	add    $0x18,%esp
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	6a 00                	push   $0x0
  801297:	6a 11                	push   $0x11
  801299:	e8 4e fe ff ff       	call   8010ec <syscall>
  80129e:	83 c4 18             	add    $0x18,%esp
}
  8012a1:	90                   	nop
  8012a2:	c9                   	leave  
  8012a3:	c3                   	ret    

008012a4 <sys_cputc>:

void
sys_cputc(const char c)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	83 ec 04             	sub    $0x4,%esp
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8012b0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8012b4:	6a 00                	push   $0x0
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 00                	push   $0x0
  8012ba:	6a 00                	push   $0x0
  8012bc:	50                   	push   %eax
  8012bd:	6a 01                	push   $0x1
  8012bf:	e8 28 fe ff ff       	call   8010ec <syscall>
  8012c4:	83 c4 18             	add    $0x18,%esp
}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	6a 00                	push   $0x0
  8012d5:	6a 00                	push   $0x0
  8012d7:	6a 14                	push   $0x14
  8012d9:	e8 0e fe ff ff       	call   8010ec <syscall>
  8012de:	83 c4 18             	add    $0x18,%esp
}
  8012e1:	90                   	nop
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	83 ec 04             	sub    $0x4,%esp
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012f0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012f3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	6a 00                	push   $0x0
  8012fc:	51                   	push   %ecx
  8012fd:	52                   	push   %edx
  8012fe:	ff 75 0c             	pushl  0xc(%ebp)
  801301:	50                   	push   %eax
  801302:	6a 15                	push   $0x15
  801304:	e8 e3 fd ff ff       	call   8010ec <syscall>
  801309:	83 c4 18             	add    $0x18,%esp
}
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    

0080130e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80130e:	55                   	push   %ebp
  80130f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801311:	8b 55 0c             	mov    0xc(%ebp),%edx
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	52                   	push   %edx
  80131e:	50                   	push   %eax
  80131f:	6a 16                	push   $0x16
  801321:	e8 c6 fd ff ff       	call   8010ec <syscall>
  801326:	83 c4 18             	add    $0x18,%esp
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80132e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801331:	8b 55 0c             	mov    0xc(%ebp),%edx
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	51                   	push   %ecx
  80133c:	52                   	push   %edx
  80133d:	50                   	push   %eax
  80133e:	6a 17                	push   $0x17
  801340:	e8 a7 fd ff ff       	call   8010ec <syscall>
  801345:	83 c4 18             	add    $0x18,%esp
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80134d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	52                   	push   %edx
  80135a:	50                   	push   %eax
  80135b:	6a 18                	push   $0x18
  80135d:	e8 8a fd ff ff       	call   8010ec <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	6a 00                	push   $0x0
  80136f:	ff 75 14             	pushl  0x14(%ebp)
  801372:	ff 75 10             	pushl  0x10(%ebp)
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	50                   	push   %eax
  801379:	6a 19                	push   $0x19
  80137b:	e8 6c fd ff ff       	call   8010ec <syscall>
  801380:	83 c4 18             	add    $0x18,%esp
}
  801383:	c9                   	leave  
  801384:	c3                   	ret    

00801385 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	50                   	push   %eax
  801394:	6a 1a                	push   $0x1a
  801396:	e8 51 fd ff ff       	call   8010ec <syscall>
  80139b:	83 c4 18             	add    $0x18,%esp
}
  80139e:	90                   	nop
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	50                   	push   %eax
  8013b0:	6a 1b                	push   $0x1b
  8013b2:	e8 35 fd ff ff       	call   8010ec <syscall>
  8013b7:	83 c4 18             	add    $0x18,%esp
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 05                	push   $0x5
  8013cb:	e8 1c fd ff ff       	call   8010ec <syscall>
  8013d0:	83 c4 18             	add    $0x18,%esp
}
  8013d3:	c9                   	leave  
  8013d4:	c3                   	ret    

008013d5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 06                	push   $0x6
  8013e4:	e8 03 fd ff ff       	call   8010ec <syscall>
  8013e9:	83 c4 18             	add    $0x18,%esp
}
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 00                	push   $0x0
  8013fb:	6a 07                	push   $0x7
  8013fd:	e8 ea fc ff ff       	call   8010ec <syscall>
  801402:	83 c4 18             	add    $0x18,%esp
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    

00801407 <sys_exit_env>:


void sys_exit_env(void)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 1c                	push   $0x1c
  801416:	e8 d1 fc ff ff       	call   8010ec <syscall>
  80141b:	83 c4 18             	add    $0x18,%esp
}
  80141e:	90                   	nop
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801427:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80142a:	8d 50 04             	lea    0x4(%eax),%edx
  80142d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	52                   	push   %edx
  801437:	50                   	push   %eax
  801438:	6a 1d                	push   $0x1d
  80143a:	e8 ad fc ff ff       	call   8010ec <syscall>
  80143f:	83 c4 18             	add    $0x18,%esp
	return result;
  801442:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801445:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801448:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80144b:	89 01                	mov    %eax,(%ecx)
  80144d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	c9                   	leave  
  801454:	c2 04 00             	ret    $0x4

00801457 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	ff 75 10             	pushl  0x10(%ebp)
  801461:	ff 75 0c             	pushl  0xc(%ebp)
  801464:	ff 75 08             	pushl  0x8(%ebp)
  801467:	6a 13                	push   $0x13
  801469:	e8 7e fc ff ff       	call   8010ec <syscall>
  80146e:	83 c4 18             	add    $0x18,%esp
	return ;
  801471:	90                   	nop
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <sys_rcr2>:
uint32 sys_rcr2()
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 1e                	push   $0x1e
  801483:	e8 64 fc ff ff       	call   8010ec <syscall>
  801488:	83 c4 18             	add    $0x18,%esp
}
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	83 ec 04             	sub    $0x4,%esp
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801499:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	50                   	push   %eax
  8014a6:	6a 1f                	push   $0x1f
  8014a8:	e8 3f fc ff ff       	call   8010ec <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8014b0:	90                   	nop
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <rsttst>:
void rsttst()
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 21                	push   $0x21
  8014c2:	e8 25 fc ff ff       	call   8010ec <syscall>
  8014c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ca:	90                   	nop
}
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	83 ec 04             	sub    $0x4,%esp
  8014d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014d9:	8b 55 18             	mov    0x18(%ebp),%edx
  8014dc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014e0:	52                   	push   %edx
  8014e1:	50                   	push   %eax
  8014e2:	ff 75 10             	pushl  0x10(%ebp)
  8014e5:	ff 75 0c             	pushl  0xc(%ebp)
  8014e8:	ff 75 08             	pushl  0x8(%ebp)
  8014eb:	6a 20                	push   $0x20
  8014ed:	e8 fa fb ff ff       	call   8010ec <syscall>
  8014f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8014f5:	90                   	nop
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <chktst>:
void chktst(uint32 n)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	ff 75 08             	pushl  0x8(%ebp)
  801506:	6a 22                	push   $0x22
  801508:	e8 df fb ff ff       	call   8010ec <syscall>
  80150d:	83 c4 18             	add    $0x18,%esp
	return ;
  801510:	90                   	nop
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <inctst>:

void inctst()
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 23                	push   $0x23
  801522:	e8 c5 fb ff ff       	call   8010ec <syscall>
  801527:	83 c4 18             	add    $0x18,%esp
	return ;
  80152a:	90                   	nop
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <gettst>:
uint32 gettst()
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 24                	push   $0x24
  80153c:	e8 ab fb ff ff       	call   8010ec <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 25                	push   $0x25
  801558:	e8 8f fb ff ff       	call   8010ec <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
  801560:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801563:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801567:	75 07                	jne    801570 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801569:	b8 01 00 00 00       	mov    $0x1,%eax
  80156e:	eb 05                	jmp    801575 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801570:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 25                	push   $0x25
  801589:	e8 5e fb ff ff       	call   8010ec <syscall>
  80158e:	83 c4 18             	add    $0x18,%esp
  801591:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801594:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801598:	75 07                	jne    8015a1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80159a:	b8 01 00 00 00       	mov    $0x1,%eax
  80159f:	eb 05                	jmp    8015a6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 25                	push   $0x25
  8015ba:	e8 2d fb ff ff       	call   8010ec <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
  8015c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015c5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015c9:	75 07                	jne    8015d2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d0:	eb 05                	jmp    8015d7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 25                	push   $0x25
  8015eb:	e8 fc fa ff ff       	call   8010ec <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
  8015f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015f6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015fa:	75 07                	jne    801603 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015fc:	b8 01 00 00 00       	mov    $0x1,%eax
  801601:	eb 05                	jmp    801608 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	ff 75 08             	pushl  0x8(%ebp)
  801618:	6a 26                	push   $0x26
  80161a:	e8 cd fa ff ff       	call   8010ec <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
	return ;
  801622:	90                   	nop
}
  801623:	c9                   	leave  
  801624:	c3                   	ret    

00801625 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801629:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80162c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80162f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	6a 00                	push   $0x0
  801637:	53                   	push   %ebx
  801638:	51                   	push   %ecx
  801639:	52                   	push   %edx
  80163a:	50                   	push   %eax
  80163b:	6a 27                	push   $0x27
  80163d:	e8 aa fa ff ff       	call   8010ec <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80164d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	52                   	push   %edx
  80165a:	50                   	push   %eax
  80165b:	6a 28                	push   $0x28
  80165d:	e8 8a fa ff ff       	call   8010ec <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80166a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80166d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	6a 00                	push   $0x0
  801675:	51                   	push   %ecx
  801676:	ff 75 10             	pushl  0x10(%ebp)
  801679:	52                   	push   %edx
  80167a:	50                   	push   %eax
  80167b:	6a 29                	push   $0x29
  80167d:	e8 6a fa ff ff       	call   8010ec <syscall>
  801682:	83 c4 18             	add    $0x18,%esp
}
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	ff 75 10             	pushl  0x10(%ebp)
  801691:	ff 75 0c             	pushl  0xc(%ebp)
  801694:	ff 75 08             	pushl  0x8(%ebp)
  801697:	6a 12                	push   $0x12
  801699:	e8 4e fa ff ff       	call   8010ec <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a1:	90                   	nop
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8016a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	52                   	push   %edx
  8016b4:	50                   	push   %eax
  8016b5:	6a 2a                	push   $0x2a
  8016b7:	e8 30 fa ff ff       	call   8010ec <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
	return;
  8016bf:	90                   	nop
}
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	68 57 21 80 00       	push   $0x802157
  8016d0:	68 2e 01 00 00       	push   $0x12e
  8016d5:	68 6b 21 80 00       	push   $0x80216b
  8016da:	e8 ee 00 00 00       	call   8017cd <_panic>

008016df <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8016e5:	83 ec 04             	sub    $0x4,%esp
  8016e8:	68 57 21 80 00       	push   $0x802157
  8016ed:	68 35 01 00 00       	push   $0x135
  8016f2:	68 6b 21 80 00       	push   $0x80216b
  8016f7:	e8 d1 00 00 00       	call   8017cd <_panic>

008016fc <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801702:	83 ec 04             	sub    $0x4,%esp
  801705:	68 57 21 80 00       	push   $0x802157
  80170a:	68 3b 01 00 00       	push   $0x13b
  80170f:	68 6b 21 80 00       	push   $0x80216b
  801714:	e8 b4 00 00 00       	call   8017cd <_panic>

00801719 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80171f:	8b 55 08             	mov    0x8(%ebp),%edx
  801722:	89 d0                	mov    %edx,%eax
  801724:	c1 e0 02             	shl    $0x2,%eax
  801727:	01 d0                	add    %edx,%eax
  801729:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801730:	01 d0                	add    %edx,%eax
  801732:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801739:	01 d0                	add    %edx,%eax
  80173b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801742:	01 d0                	add    %edx,%eax
  801744:	c1 e0 04             	shl    $0x4,%eax
  801747:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80174a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801751:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801754:	83 ec 0c             	sub    $0xc,%esp
  801757:	50                   	push   %eax
  801758:	e8 c4 fc ff ff       	call   801421 <sys_get_virtual_time>
  80175d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801760:	eb 41                	jmp    8017a3 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801762:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801765:	83 ec 0c             	sub    $0xc,%esp
  801768:	50                   	push   %eax
  801769:	e8 b3 fc ff ff       	call   801421 <sys_get_virtual_time>
  80176e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801771:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801774:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801777:	29 c2                	sub    %eax,%edx
  801779:	89 d0                	mov    %edx,%eax
  80177b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80177e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801784:	89 d1                	mov    %edx,%ecx
  801786:	29 c1                	sub    %eax,%ecx
  801788:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80178b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80178e:	39 c2                	cmp    %eax,%edx
  801790:	0f 97 c0             	seta   %al
  801793:	0f b6 c0             	movzbl %al,%eax
  801796:	29 c1                	sub    %eax,%ecx
  801798:	89 c8                	mov    %ecx,%eax
  80179a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80179d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8017a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017a9:	72 b7                	jb     801762 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8017ab:	90                   	nop
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8017b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8017bb:	eb 03                	jmp    8017c0 <busy_wait+0x12>
  8017bd:	ff 45 fc             	incl   -0x4(%ebp)
  8017c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017c6:	72 f5                	jb     8017bd <busy_wait+0xf>
	return i;
  8017c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017d3:	8d 45 10             	lea    0x10(%ebp),%eax
  8017d6:	83 c0 04             	add    $0x4,%eax
  8017d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017dc:	a1 24 30 80 00       	mov    0x803024,%eax
  8017e1:	85 c0                	test   %eax,%eax
  8017e3:	74 16                	je     8017fb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8017e5:	a1 24 30 80 00       	mov    0x803024,%eax
  8017ea:	83 ec 08             	sub    $0x8,%esp
  8017ed:	50                   	push   %eax
  8017ee:	68 7c 21 80 00       	push   $0x80217c
  8017f3:	e8 5a eb ff ff       	call   800352 <cprintf>
  8017f8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8017fb:	a1 00 30 80 00       	mov    0x803000,%eax
  801800:	ff 75 0c             	pushl  0xc(%ebp)
  801803:	ff 75 08             	pushl  0x8(%ebp)
  801806:	50                   	push   %eax
  801807:	68 81 21 80 00       	push   $0x802181
  80180c:	e8 41 eb ff ff       	call   800352 <cprintf>
  801811:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801814:	8b 45 10             	mov    0x10(%ebp),%eax
  801817:	83 ec 08             	sub    $0x8,%esp
  80181a:	ff 75 f4             	pushl  -0xc(%ebp)
  80181d:	50                   	push   %eax
  80181e:	e8 c4 ea ff ff       	call   8002e7 <vcprintf>
  801823:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	6a 00                	push   $0x0
  80182b:	68 9d 21 80 00       	push   $0x80219d
  801830:	e8 b2 ea ff ff       	call   8002e7 <vcprintf>
  801835:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801838:	e8 33 ea ff ff       	call   800270 <exit>

	// should not return here
	while (1) ;
  80183d:	eb fe                	jmp    80183d <_panic+0x70>

0080183f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801845:	a1 04 30 80 00       	mov    0x803004,%eax
  80184a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801850:	8b 45 0c             	mov    0xc(%ebp),%eax
  801853:	39 c2                	cmp    %eax,%edx
  801855:	74 14                	je     80186b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	68 a0 21 80 00       	push   $0x8021a0
  80185f:	6a 26                	push   $0x26
  801861:	68 ec 21 80 00       	push   $0x8021ec
  801866:	e8 62 ff ff ff       	call   8017cd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80186b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801872:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801879:	e9 c5 00 00 00       	jmp    801943 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80187e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801881:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	01 d0                	add    %edx,%eax
  80188d:	8b 00                	mov    (%eax),%eax
  80188f:	85 c0                	test   %eax,%eax
  801891:	75 08                	jne    80189b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801893:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801896:	e9 a5 00 00 00       	jmp    801940 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80189b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018a9:	eb 69                	jmp    801914 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018ab:	a1 04 30 80 00       	mov    0x803004,%eax
  8018b0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8018b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018b9:	89 d0                	mov    %edx,%eax
  8018bb:	01 c0                	add    %eax,%eax
  8018bd:	01 d0                	add    %edx,%eax
  8018bf:	c1 e0 03             	shl    $0x3,%eax
  8018c2:	01 c8                	add    %ecx,%eax
  8018c4:	8a 40 04             	mov    0x4(%eax),%al
  8018c7:	84 c0                	test   %al,%al
  8018c9:	75 46                	jne    801911 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018cb:	a1 04 30 80 00       	mov    0x803004,%eax
  8018d0:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  8018d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018d9:	89 d0                	mov    %edx,%eax
  8018db:	01 c0                	add    %eax,%eax
  8018dd:	01 d0                	add    %edx,%eax
  8018df:	c1 e0 03             	shl    $0x3,%eax
  8018e2:	01 c8                	add    %ecx,%eax
  8018e4:	8b 00                	mov    (%eax),%eax
  8018e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018f1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	01 c8                	add    %ecx,%eax
  801902:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801904:	39 c2                	cmp    %eax,%edx
  801906:	75 09                	jne    801911 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801908:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80190f:	eb 15                	jmp    801926 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801911:	ff 45 e8             	incl   -0x18(%ebp)
  801914:	a1 04 30 80 00       	mov    0x803004,%eax
  801919:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  80191f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801922:	39 c2                	cmp    %eax,%edx
  801924:	77 85                	ja     8018ab <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801926:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80192a:	75 14                	jne    801940 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80192c:	83 ec 04             	sub    $0x4,%esp
  80192f:	68 f8 21 80 00       	push   $0x8021f8
  801934:	6a 3a                	push   $0x3a
  801936:	68 ec 21 80 00       	push   $0x8021ec
  80193b:	e8 8d fe ff ff       	call   8017cd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801940:	ff 45 f0             	incl   -0x10(%ebp)
  801943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801946:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801949:	0f 8c 2f ff ff ff    	jl     80187e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80194f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801956:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80195d:	eb 26                	jmp    801985 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80195f:	a1 04 30 80 00       	mov    0x803004,%eax
  801964:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  80196a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80196d:	89 d0                	mov    %edx,%eax
  80196f:	01 c0                	add    %eax,%eax
  801971:	01 d0                	add    %edx,%eax
  801973:	c1 e0 03             	shl    $0x3,%eax
  801976:	01 c8                	add    %ecx,%eax
  801978:	8a 40 04             	mov    0x4(%eax),%al
  80197b:	3c 01                	cmp    $0x1,%al
  80197d:	75 03                	jne    801982 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80197f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801982:	ff 45 e0             	incl   -0x20(%ebp)
  801985:	a1 04 30 80 00       	mov    0x803004,%eax
  80198a:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801993:	39 c2                	cmp    %eax,%edx
  801995:	77 c8                	ja     80195f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80199d:	74 14                	je     8019b3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	68 4c 22 80 00       	push   $0x80224c
  8019a7:	6a 44                	push   $0x44
  8019a9:	68 ec 21 80 00       	push   $0x8021ec
  8019ae:	e8 1a fe ff ff       	call   8017cd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    
  8019b6:	66 90                	xchg   %ax,%ax

008019b8 <__udivdi3>:
  8019b8:	55                   	push   %ebp
  8019b9:	57                   	push   %edi
  8019ba:	56                   	push   %esi
  8019bb:	53                   	push   %ebx
  8019bc:	83 ec 1c             	sub    $0x1c,%esp
  8019bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cf:	89 ca                	mov    %ecx,%edx
  8019d1:	89 f8                	mov    %edi,%eax
  8019d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019d7:	85 f6                	test   %esi,%esi
  8019d9:	75 2d                	jne    801a08 <__udivdi3+0x50>
  8019db:	39 cf                	cmp    %ecx,%edi
  8019dd:	77 65                	ja     801a44 <__udivdi3+0x8c>
  8019df:	89 fd                	mov    %edi,%ebp
  8019e1:	85 ff                	test   %edi,%edi
  8019e3:	75 0b                	jne    8019f0 <__udivdi3+0x38>
  8019e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ea:	31 d2                	xor    %edx,%edx
  8019ec:	f7 f7                	div    %edi
  8019ee:	89 c5                	mov    %eax,%ebp
  8019f0:	31 d2                	xor    %edx,%edx
  8019f2:	89 c8                	mov    %ecx,%eax
  8019f4:	f7 f5                	div    %ebp
  8019f6:	89 c1                	mov    %eax,%ecx
  8019f8:	89 d8                	mov    %ebx,%eax
  8019fa:	f7 f5                	div    %ebp
  8019fc:	89 cf                	mov    %ecx,%edi
  8019fe:	89 fa                	mov    %edi,%edx
  801a00:	83 c4 1c             	add    $0x1c,%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5f                   	pop    %edi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    
  801a08:	39 ce                	cmp    %ecx,%esi
  801a0a:	77 28                	ja     801a34 <__udivdi3+0x7c>
  801a0c:	0f bd fe             	bsr    %esi,%edi
  801a0f:	83 f7 1f             	xor    $0x1f,%edi
  801a12:	75 40                	jne    801a54 <__udivdi3+0x9c>
  801a14:	39 ce                	cmp    %ecx,%esi
  801a16:	72 0a                	jb     801a22 <__udivdi3+0x6a>
  801a18:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a1c:	0f 87 9e 00 00 00    	ja     801ac0 <__udivdi3+0x108>
  801a22:	b8 01 00 00 00       	mov    $0x1,%eax
  801a27:	89 fa                	mov    %edi,%edx
  801a29:	83 c4 1c             	add    $0x1c,%esp
  801a2c:	5b                   	pop    %ebx
  801a2d:	5e                   	pop    %esi
  801a2e:	5f                   	pop    %edi
  801a2f:	5d                   	pop    %ebp
  801a30:	c3                   	ret    
  801a31:	8d 76 00             	lea    0x0(%esi),%esi
  801a34:	31 ff                	xor    %edi,%edi
  801a36:	31 c0                	xor    %eax,%eax
  801a38:	89 fa                	mov    %edi,%edx
  801a3a:	83 c4 1c             	add    $0x1c,%esp
  801a3d:	5b                   	pop    %ebx
  801a3e:	5e                   	pop    %esi
  801a3f:	5f                   	pop    %edi
  801a40:	5d                   	pop    %ebp
  801a41:	c3                   	ret    
  801a42:	66 90                	xchg   %ax,%ax
  801a44:	89 d8                	mov    %ebx,%eax
  801a46:	f7 f7                	div    %edi
  801a48:	31 ff                	xor    %edi,%edi
  801a4a:	89 fa                	mov    %edi,%edx
  801a4c:	83 c4 1c             	add    $0x1c,%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5e                   	pop    %esi
  801a51:	5f                   	pop    %edi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    
  801a54:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a59:	89 eb                	mov    %ebp,%ebx
  801a5b:	29 fb                	sub    %edi,%ebx
  801a5d:	89 f9                	mov    %edi,%ecx
  801a5f:	d3 e6                	shl    %cl,%esi
  801a61:	89 c5                	mov    %eax,%ebp
  801a63:	88 d9                	mov    %bl,%cl
  801a65:	d3 ed                	shr    %cl,%ebp
  801a67:	89 e9                	mov    %ebp,%ecx
  801a69:	09 f1                	or     %esi,%ecx
  801a6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a6f:	89 f9                	mov    %edi,%ecx
  801a71:	d3 e0                	shl    %cl,%eax
  801a73:	89 c5                	mov    %eax,%ebp
  801a75:	89 d6                	mov    %edx,%esi
  801a77:	88 d9                	mov    %bl,%cl
  801a79:	d3 ee                	shr    %cl,%esi
  801a7b:	89 f9                	mov    %edi,%ecx
  801a7d:	d3 e2                	shl    %cl,%edx
  801a7f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a83:	88 d9                	mov    %bl,%cl
  801a85:	d3 e8                	shr    %cl,%eax
  801a87:	09 c2                	or     %eax,%edx
  801a89:	89 d0                	mov    %edx,%eax
  801a8b:	89 f2                	mov    %esi,%edx
  801a8d:	f7 74 24 0c          	divl   0xc(%esp)
  801a91:	89 d6                	mov    %edx,%esi
  801a93:	89 c3                	mov    %eax,%ebx
  801a95:	f7 e5                	mul    %ebp
  801a97:	39 d6                	cmp    %edx,%esi
  801a99:	72 19                	jb     801ab4 <__udivdi3+0xfc>
  801a9b:	74 0b                	je     801aa8 <__udivdi3+0xf0>
  801a9d:	89 d8                	mov    %ebx,%eax
  801a9f:	31 ff                	xor    %edi,%edi
  801aa1:	e9 58 ff ff ff       	jmp    8019fe <__udivdi3+0x46>
  801aa6:	66 90                	xchg   %ax,%ax
  801aa8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801aac:	89 f9                	mov    %edi,%ecx
  801aae:	d3 e2                	shl    %cl,%edx
  801ab0:	39 c2                	cmp    %eax,%edx
  801ab2:	73 e9                	jae    801a9d <__udivdi3+0xe5>
  801ab4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ab7:	31 ff                	xor    %edi,%edi
  801ab9:	e9 40 ff ff ff       	jmp    8019fe <__udivdi3+0x46>
  801abe:	66 90                	xchg   %ax,%ax
  801ac0:	31 c0                	xor    %eax,%eax
  801ac2:	e9 37 ff ff ff       	jmp    8019fe <__udivdi3+0x46>
  801ac7:	90                   	nop

00801ac8 <__umoddi3>:
  801ac8:	55                   	push   %ebp
  801ac9:	57                   	push   %edi
  801aca:	56                   	push   %esi
  801acb:	53                   	push   %ebx
  801acc:	83 ec 1c             	sub    $0x1c,%esp
  801acf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ad3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ad7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801adb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801adf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ae3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ae7:	89 f3                	mov    %esi,%ebx
  801ae9:	89 fa                	mov    %edi,%edx
  801aeb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aef:	89 34 24             	mov    %esi,(%esp)
  801af2:	85 c0                	test   %eax,%eax
  801af4:	75 1a                	jne    801b10 <__umoddi3+0x48>
  801af6:	39 f7                	cmp    %esi,%edi
  801af8:	0f 86 a2 00 00 00    	jbe    801ba0 <__umoddi3+0xd8>
  801afe:	89 c8                	mov    %ecx,%eax
  801b00:	89 f2                	mov    %esi,%edx
  801b02:	f7 f7                	div    %edi
  801b04:	89 d0                	mov    %edx,%eax
  801b06:	31 d2                	xor    %edx,%edx
  801b08:	83 c4 1c             	add    $0x1c,%esp
  801b0b:	5b                   	pop    %ebx
  801b0c:	5e                   	pop    %esi
  801b0d:	5f                   	pop    %edi
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    
  801b10:	39 f0                	cmp    %esi,%eax
  801b12:	0f 87 ac 00 00 00    	ja     801bc4 <__umoddi3+0xfc>
  801b18:	0f bd e8             	bsr    %eax,%ebp
  801b1b:	83 f5 1f             	xor    $0x1f,%ebp
  801b1e:	0f 84 ac 00 00 00    	je     801bd0 <__umoddi3+0x108>
  801b24:	bf 20 00 00 00       	mov    $0x20,%edi
  801b29:	29 ef                	sub    %ebp,%edi
  801b2b:	89 fe                	mov    %edi,%esi
  801b2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b31:	89 e9                	mov    %ebp,%ecx
  801b33:	d3 e0                	shl    %cl,%eax
  801b35:	89 d7                	mov    %edx,%edi
  801b37:	89 f1                	mov    %esi,%ecx
  801b39:	d3 ef                	shr    %cl,%edi
  801b3b:	09 c7                	or     %eax,%edi
  801b3d:	89 e9                	mov    %ebp,%ecx
  801b3f:	d3 e2                	shl    %cl,%edx
  801b41:	89 14 24             	mov    %edx,(%esp)
  801b44:	89 d8                	mov    %ebx,%eax
  801b46:	d3 e0                	shl    %cl,%eax
  801b48:	89 c2                	mov    %eax,%edx
  801b4a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b4e:	d3 e0                	shl    %cl,%eax
  801b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b54:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b58:	89 f1                	mov    %esi,%ecx
  801b5a:	d3 e8                	shr    %cl,%eax
  801b5c:	09 d0                	or     %edx,%eax
  801b5e:	d3 eb                	shr    %cl,%ebx
  801b60:	89 da                	mov    %ebx,%edx
  801b62:	f7 f7                	div    %edi
  801b64:	89 d3                	mov    %edx,%ebx
  801b66:	f7 24 24             	mull   (%esp)
  801b69:	89 c6                	mov    %eax,%esi
  801b6b:	89 d1                	mov    %edx,%ecx
  801b6d:	39 d3                	cmp    %edx,%ebx
  801b6f:	0f 82 87 00 00 00    	jb     801bfc <__umoddi3+0x134>
  801b75:	0f 84 91 00 00 00    	je     801c0c <__umoddi3+0x144>
  801b7b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b7f:	29 f2                	sub    %esi,%edx
  801b81:	19 cb                	sbb    %ecx,%ebx
  801b83:	89 d8                	mov    %ebx,%eax
  801b85:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b89:	d3 e0                	shl    %cl,%eax
  801b8b:	89 e9                	mov    %ebp,%ecx
  801b8d:	d3 ea                	shr    %cl,%edx
  801b8f:	09 d0                	or     %edx,%eax
  801b91:	89 e9                	mov    %ebp,%ecx
  801b93:	d3 eb                	shr    %cl,%ebx
  801b95:	89 da                	mov    %ebx,%edx
  801b97:	83 c4 1c             	add    $0x1c,%esp
  801b9a:	5b                   	pop    %ebx
  801b9b:	5e                   	pop    %esi
  801b9c:	5f                   	pop    %edi
  801b9d:	5d                   	pop    %ebp
  801b9e:	c3                   	ret    
  801b9f:	90                   	nop
  801ba0:	89 fd                	mov    %edi,%ebp
  801ba2:	85 ff                	test   %edi,%edi
  801ba4:	75 0b                	jne    801bb1 <__umoddi3+0xe9>
  801ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bab:	31 d2                	xor    %edx,%edx
  801bad:	f7 f7                	div    %edi
  801baf:	89 c5                	mov    %eax,%ebp
  801bb1:	89 f0                	mov    %esi,%eax
  801bb3:	31 d2                	xor    %edx,%edx
  801bb5:	f7 f5                	div    %ebp
  801bb7:	89 c8                	mov    %ecx,%eax
  801bb9:	f7 f5                	div    %ebp
  801bbb:	89 d0                	mov    %edx,%eax
  801bbd:	e9 44 ff ff ff       	jmp    801b06 <__umoddi3+0x3e>
  801bc2:	66 90                	xchg   %ax,%ax
  801bc4:	89 c8                	mov    %ecx,%eax
  801bc6:	89 f2                	mov    %esi,%edx
  801bc8:	83 c4 1c             	add    $0x1c,%esp
  801bcb:	5b                   	pop    %ebx
  801bcc:	5e                   	pop    %esi
  801bcd:	5f                   	pop    %edi
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    
  801bd0:	3b 04 24             	cmp    (%esp),%eax
  801bd3:	72 06                	jb     801bdb <__umoddi3+0x113>
  801bd5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bd9:	77 0f                	ja     801bea <__umoddi3+0x122>
  801bdb:	89 f2                	mov    %esi,%edx
  801bdd:	29 f9                	sub    %edi,%ecx
  801bdf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801be3:	89 14 24             	mov    %edx,(%esp)
  801be6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bea:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bee:	8b 14 24             	mov    (%esp),%edx
  801bf1:	83 c4 1c             	add    $0x1c,%esp
  801bf4:	5b                   	pop    %ebx
  801bf5:	5e                   	pop    %esi
  801bf6:	5f                   	pop    %edi
  801bf7:	5d                   	pop    %ebp
  801bf8:	c3                   	ret    
  801bf9:	8d 76 00             	lea    0x0(%esi),%esi
  801bfc:	2b 04 24             	sub    (%esp),%eax
  801bff:	19 fa                	sbb    %edi,%edx
  801c01:	89 d1                	mov    %edx,%ecx
  801c03:	89 c6                	mov    %eax,%esi
  801c05:	e9 71 ff ff ff       	jmp    801b7b <__umoddi3+0xb3>
  801c0a:	66 90                	xchg   %ax,%ax
  801c0c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c10:	72 ea                	jb     801bfc <__umoddi3+0x134>
  801c12:	89 d9                	mov    %ebx,%ecx
  801c14:	e9 62 ff ff ff       	jmp    801b7b <__umoddi3+0xb3>
