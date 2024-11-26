
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 ba 01 00 00       	call   8001f0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 80 3c 80 00       	push   $0x803c80
  80004a:	e8 81 14 00 00       	call   8014d0 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 84 3c 80 00       	push   $0x803c84
  800066:	e8 98 03 00 00       	call   800403 <cprintf>
  80006b:	83 c4 10             	add    $0x10,%esp
	char select = getchar() ;
  80006e:	e8 60 01 00 00       	call   8001d3 <getchar>
  800073:	88 45 f3             	mov    %al,-0xd(%ebp)
	cputchar(select);
  800076:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	50                   	push   %eax
  80007e:	e8 31 01 00 00       	call   8001b4 <cputchar>
  800083:	83 c4 10             	add    $0x10,%esp
	cputchar('\n');
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	e8 24 01 00 00       	call   8001b4 <cputchar>
  800090:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 00                	push   $0x0
  800098:	6a 04                	push   $0x4
  80009a:	68 a9 3c 80 00       	push   $0x803ca9
  80009f:	e8 2c 14 00 00       	call   8014d0 <smalloc>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  8000aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  8000b3:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  8000b7:	74 06                	je     8000bf <_main+0x87>
  8000b9:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  8000bd:	75 09                	jne    8000c8 <_main+0x90>
		*useSem = 1 ;
  8000bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	struct semaphore T ;
	if (*useSem == 1)
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	75 16                	jne    8000e8 <_main+0xb0>
	{
		T = create_semaphore("T", 0);
  8000d2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8000d5:	83 ec 04             	sub    $0x4,%esp
  8000d8:	6a 00                	push   $0x0
  8000da:	68 b0 3c 80 00       	push   $0x803cb0
  8000df:	50                   	push   %eax
  8000e0:	e8 bf 36 00 00       	call   8037a4 <create_semaphore>
  8000e5:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	6a 01                	push   $0x1
  8000ed:	6a 04                	push   $0x4
  8000ef:	68 b2 3c 80 00       	push   $0x803cb2
  8000f4:	e8 d7 13 00 00       	call   8014d0 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800102:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800108:	a1 20 50 80 00       	mov    0x805020,%eax
  80010d:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800113:	a1 20 50 80 00       	mov    0x805020,%eax
  800118:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  80011e:	89 c1                	mov    %eax,%ecx
  800120:	a1 20 50 80 00       	mov    0x805020,%eax
  800125:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80012b:	52                   	push   %edx
  80012c:	51                   	push   %ecx
  80012d:	50                   	push   %eax
  80012e:	68 c0 3c 80 00       	push   $0x803cc0
  800133:	e8 25 18 00 00       	call   80195d <sys_create_env>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80013e:	a1 20 50 80 00       	mov    0x805020,%eax
  800143:	8b 90 8c 05 00 00    	mov    0x58c(%eax),%edx
  800149:	a1 20 50 80 00       	mov    0x805020,%eax
  80014e:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800154:	89 c1                	mov    %eax,%ecx
  800156:	a1 20 50 80 00       	mov    0x805020,%eax
  80015b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800161:	52                   	push   %edx
  800162:	51                   	push   %ecx
  800163:	50                   	push   %eax
  800164:	68 ca 3c 80 00       	push   $0x803cca
  800169:	e8 ef 17 00 00       	call   80195d <sys_create_env>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 fc 17 00 00       	call   80197b <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	e8 ee 17 00 00       	call   80197b <sys_run_env>
  80018d:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800190:	90                   	nop
  800191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	83 f8 02             	cmp    $0x2,%eax
  800199:	75 f6                	jne    800191 <_main+0x159>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80019b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80019e:	8b 00                	mov    (%eax),%eax
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	50                   	push   %eax
  8001a4:	68 d4 3c 80 00       	push   $0x803cd4
  8001a9:	e8 55 02 00 00       	call   800403 <cprintf>
  8001ae:	83 c4 10             	add    $0x10,%esp

	return;
  8001b1:	90                   	nop
}
  8001b2:	c9                   	leave  
  8001b3:	c3                   	ret    

008001b4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8001ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bd:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001c0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001c4:	83 ec 0c             	sub    $0xc,%esp
  8001c7:	50                   	push   %eax
  8001c8:	e8 cd 16 00 00       	call   80189a <sys_cputc>
  8001cd:	83 c4 10             	add    $0x10,%esp
}
  8001d0:	90                   	nop
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <getchar>:


int
getchar(void)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  8001d9:	e8 58 15 00 00       	call   801736 <sys_cgetc>
  8001de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  8001e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <iscons>:

int iscons(int fdnum)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8001e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8001ee:	5d                   	pop    %ebp
  8001ef:	c3                   	ret    

008001f0 <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f6:	e8 d0 17 00 00       	call   8019cb <sys_getenvindex>
  8001fb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800201:	89 d0                	mov    %edx,%eax
  800203:	c1 e0 03             	shl    $0x3,%eax
  800206:	01 d0                	add    %edx,%eax
  800208:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80020f:	01 c8                	add    %ecx,%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	01 d0                	add    %edx,%eax
  800215:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  80021c:	01 c8                	add    %ecx,%eax
  80021e:	01 d0                	add    %edx,%eax
  800220:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800225:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022a:	a1 20 50 80 00       	mov    0x805020,%eax
  80022f:	8a 40 20             	mov    0x20(%eax),%al
  800232:	84 c0                	test   %al,%al
  800234:	74 0d                	je     800243 <libmain+0x53>
		binaryname = myEnv->prog_name;
  800236:	a1 20 50 80 00       	mov    0x805020,%eax
  80023b:	83 c0 20             	add    $0x20,%eax
  80023e:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800243:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800247:	7e 0a                	jle    800253 <libmain+0x63>
		binaryname = argv[0];
  800249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024c:	8b 00                	mov    (%eax),%eax
  80024e:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 d7 fd ff ff       	call   800038 <_main>
  800261:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800264:	e8 e6 14 00 00       	call   80174f <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	68 04 3d 80 00       	push   $0x803d04
  800271:	e8 8d 01 00 00       	call   800403 <cprintf>
  800276:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800279:	a1 20 50 80 00       	mov    0x805020,%eax
  80027e:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800284:	a1 20 50 80 00       	mov    0x805020,%eax
  800289:	8b 80 90 05 00 00    	mov    0x590(%eax),%eax
  80028f:	83 ec 04             	sub    $0x4,%esp
  800292:	52                   	push   %edx
  800293:	50                   	push   %eax
  800294:	68 2c 3d 80 00       	push   $0x803d2c
  800299:	e8 65 01 00 00       	call   800403 <cprintf>
  80029e:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a6:	8b 88 b4 05 00 00    	mov    0x5b4(%eax),%ecx
  8002ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b1:	8b 90 b0 05 00 00    	mov    0x5b0(%eax),%edx
  8002b7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bc:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8002c2:	51                   	push   %ecx
  8002c3:	52                   	push   %edx
  8002c4:	50                   	push   %eax
  8002c5:	68 54 3d 80 00       	push   $0x803d54
  8002ca:	e8 34 01 00 00       	call   800403 <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d7:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	50                   	push   %eax
  8002e1:	68 ac 3d 80 00       	push   $0x803dac
  8002e6:	e8 18 01 00 00       	call   800403 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	68 04 3d 80 00       	push   $0x803d04
  8002f6:	e8 08 01 00 00       	call   800403 <cprintf>
  8002fb:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002fe:	e8 66 14 00 00       	call   801769 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800303:	e8 19 00 00 00       	call   800321 <exit>
}
  800308:	90                   	nop
  800309:	c9                   	leave  
  80030a:	c3                   	ret    

0080030b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80030b:	55                   	push   %ebp
  80030c:	89 e5                	mov    %esp,%ebp
  80030e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800311:	83 ec 0c             	sub    $0xc,%esp
  800314:	6a 00                	push   $0x0
  800316:	e8 7c 16 00 00       	call   801997 <sys_destroy_env>
  80031b:	83 c4 10             	add    $0x10,%esp
}
  80031e:	90                   	nop
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <exit>:

void
exit(void)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800327:	e8 d1 16 00 00       	call   8019fd <sys_exit_env>
}
  80032c:	90                   	nop
  80032d:	c9                   	leave  
  80032e:	c3                   	ret    

0080032f <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	8d 48 01             	lea    0x1(%eax),%ecx
  80033d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800340:	89 0a                	mov    %ecx,(%edx)
  800342:	8b 55 08             	mov    0x8(%ebp),%edx
  800345:	88 d1                	mov    %dl,%cl
  800347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80034a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80034e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	3d ff 00 00 00       	cmp    $0xff,%eax
  800358:	75 2c                	jne    800386 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80035a:	a0 28 50 80 00       	mov    0x805028,%al
  80035f:	0f b6 c0             	movzbl %al,%eax
  800362:	8b 55 0c             	mov    0xc(%ebp),%edx
  800365:	8b 12                	mov    (%edx),%edx
  800367:	89 d1                	mov    %edx,%ecx
  800369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036c:	83 c2 08             	add    $0x8,%edx
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	50                   	push   %eax
  800373:	51                   	push   %ecx
  800374:	52                   	push   %edx
  800375:	e8 93 13 00 00       	call   80170d <sys_cputs>
  80037a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80037d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800380:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800386:	8b 45 0c             	mov    0xc(%ebp),%eax
  800389:	8b 40 04             	mov    0x4(%eax),%eax
  80038c:	8d 50 01             	lea    0x1(%eax),%edx
  80038f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800392:	89 50 04             	mov    %edx,0x4(%eax)
}
  800395:	90                   	nop
  800396:	c9                   	leave  
  800397:	c3                   	ret    

00800398 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003a1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a8:	00 00 00 
	b.cnt = 0;
  8003ab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003b5:	ff 75 0c             	pushl  0xc(%ebp)
  8003b8:	ff 75 08             	pushl  0x8(%ebp)
  8003bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003c1:	50                   	push   %eax
  8003c2:	68 2f 03 80 00       	push   $0x80032f
  8003c7:	e8 11 02 00 00       	call   8005dd <vprintfmt>
  8003cc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8003cf:	a0 28 50 80 00       	mov    0x805028,%al
  8003d4:	0f b6 c0             	movzbl %al,%eax
  8003d7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	50                   	push   %eax
  8003e1:	52                   	push   %edx
  8003e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e8:	83 c0 08             	add    $0x8,%eax
  8003eb:	50                   	push   %eax
  8003ec:	e8 1c 13 00 00       	call   80170d <sys_cputs>
  8003f1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003f4:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8003fb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800401:	c9                   	leave  
  800402:	c3                   	ret    

00800403 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800409:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800410:	8d 45 0c             	lea    0xc(%ebp),%eax
  800413:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	ff 75 f4             	pushl  -0xc(%ebp)
  80041f:	50                   	push   %eax
  800420:	e8 73 ff ff ff       	call   800398 <vcprintf>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80042e:	c9                   	leave  
  80042f:	c3                   	ret    

00800430 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800436:	e8 14 13 00 00       	call   80174f <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80043b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80043e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	83 ec 08             	sub    $0x8,%esp
  800447:	ff 75 f4             	pushl  -0xc(%ebp)
  80044a:	50                   	push   %eax
  80044b:	e8 48 ff ff ff       	call   800398 <vcprintf>
  800450:	83 c4 10             	add    $0x10,%esp
  800453:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800456:	e8 0e 13 00 00       	call   801769 <sys_unlock_cons>
	return cnt;
  80045b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80045e:	c9                   	leave  
  80045f:	c3                   	ret    

00800460 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	53                   	push   %ebx
  800464:	83 ec 14             	sub    $0x14,%esp
  800467:	8b 45 10             	mov    0x10(%ebp),%eax
  80046a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800473:	8b 45 18             	mov    0x18(%ebp),%eax
  800476:	ba 00 00 00 00       	mov    $0x0,%edx
  80047b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80047e:	77 55                	ja     8004d5 <printnum+0x75>
  800480:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800483:	72 05                	jb     80048a <printnum+0x2a>
  800485:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800488:	77 4b                	ja     8004d5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80048a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80048d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800490:	8b 45 18             	mov    0x18(%ebp),%eax
  800493:	ba 00 00 00 00       	mov    $0x0,%edx
  800498:	52                   	push   %edx
  800499:	50                   	push   %eax
  80049a:	ff 75 f4             	pushl  -0xc(%ebp)
  80049d:	ff 75 f0             	pushl  -0x10(%ebp)
  8004a0:	e8 5b 35 00 00       	call   803a00 <__udivdi3>
  8004a5:	83 c4 10             	add    $0x10,%esp
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	ff 75 20             	pushl  0x20(%ebp)
  8004ae:	53                   	push   %ebx
  8004af:	ff 75 18             	pushl  0x18(%ebp)
  8004b2:	52                   	push   %edx
  8004b3:	50                   	push   %eax
  8004b4:	ff 75 0c             	pushl  0xc(%ebp)
  8004b7:	ff 75 08             	pushl  0x8(%ebp)
  8004ba:	e8 a1 ff ff ff       	call   800460 <printnum>
  8004bf:	83 c4 20             	add    $0x20,%esp
  8004c2:	eb 1a                	jmp    8004de <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ca:	ff 75 20             	pushl  0x20(%ebp)
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	ff d0                	call   *%eax
  8004d2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004d5:	ff 4d 1c             	decl   0x1c(%ebp)
  8004d8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004dc:	7f e6                	jg     8004c4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004de:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004ec:	53                   	push   %ebx
  8004ed:	51                   	push   %ecx
  8004ee:	52                   	push   %edx
  8004ef:	50                   	push   %eax
  8004f0:	e8 1b 36 00 00       	call   803b10 <__umoddi3>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	05 d4 3f 80 00       	add    $0x803fd4,%eax
  8004fd:	8a 00                	mov    (%eax),%al
  8004ff:	0f be c0             	movsbl %al,%eax
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	ff 75 0c             	pushl  0xc(%ebp)
  800508:	50                   	push   %eax
  800509:	8b 45 08             	mov    0x8(%ebp),%eax
  80050c:	ff d0                	call   *%eax
  80050e:	83 c4 10             	add    $0x10,%esp
}
  800511:	90                   	nop
  800512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80051a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80051e:	7e 1c                	jle    80053c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	8b 00                	mov    (%eax),%eax
  800525:	8d 50 08             	lea    0x8(%eax),%edx
  800528:	8b 45 08             	mov    0x8(%ebp),%eax
  80052b:	89 10                	mov    %edx,(%eax)
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	8b 00                	mov    (%eax),%eax
  800532:	83 e8 08             	sub    $0x8,%eax
  800535:	8b 50 04             	mov    0x4(%eax),%edx
  800538:	8b 00                	mov    (%eax),%eax
  80053a:	eb 40                	jmp    80057c <getuint+0x65>
	else if (lflag)
  80053c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800540:	74 1e                	je     800560 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800542:	8b 45 08             	mov    0x8(%ebp),%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	8d 50 04             	lea    0x4(%eax),%edx
  80054a:	8b 45 08             	mov    0x8(%ebp),%eax
  80054d:	89 10                	mov    %edx,(%eax)
  80054f:	8b 45 08             	mov    0x8(%ebp),%eax
  800552:	8b 00                	mov    (%eax),%eax
  800554:	83 e8 04             	sub    $0x4,%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	ba 00 00 00 00       	mov    $0x0,%edx
  80055e:	eb 1c                	jmp    80057c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	8b 00                	mov    (%eax),%eax
  800565:	8d 50 04             	lea    0x4(%eax),%edx
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	89 10                	mov    %edx,(%eax)
  80056d:	8b 45 08             	mov    0x8(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	83 e8 04             	sub    $0x4,%eax
  800575:	8b 00                	mov    (%eax),%eax
  800577:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80057c:	5d                   	pop    %ebp
  80057d:	c3                   	ret    

0080057e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800581:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800585:	7e 1c                	jle    8005a3 <getint+0x25>
		return va_arg(*ap, long long);
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	8d 50 08             	lea    0x8(%eax),%edx
  80058f:	8b 45 08             	mov    0x8(%ebp),%eax
  800592:	89 10                	mov    %edx,(%eax)
  800594:	8b 45 08             	mov    0x8(%ebp),%eax
  800597:	8b 00                	mov    (%eax),%eax
  800599:	83 e8 08             	sub    $0x8,%eax
  80059c:	8b 50 04             	mov    0x4(%eax),%edx
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	eb 38                	jmp    8005db <getint+0x5d>
	else if (lflag)
  8005a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005a7:	74 1a                	je     8005c3 <getint+0x45>
		return va_arg(*ap, long);
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	8b 00                	mov    (%eax),%eax
  8005ae:	8d 50 04             	lea    0x4(%eax),%edx
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	89 10                	mov    %edx,(%eax)
  8005b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b9:	8b 00                	mov    (%eax),%eax
  8005bb:	83 e8 04             	sub    $0x4,%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	99                   	cltd   
  8005c1:	eb 18                	jmp    8005db <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	8b 00                	mov    (%eax),%eax
  8005c8:	8d 50 04             	lea    0x4(%eax),%edx
  8005cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ce:	89 10                	mov    %edx,(%eax)
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	83 e8 04             	sub    $0x4,%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	99                   	cltd   
}
  8005db:	5d                   	pop    %ebp
  8005dc:	c3                   	ret    

008005dd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005dd:	55                   	push   %ebp
  8005de:	89 e5                	mov    %esp,%ebp
  8005e0:	56                   	push   %esi
  8005e1:	53                   	push   %ebx
  8005e2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005e5:	eb 17                	jmp    8005fe <vprintfmt+0x21>
			if (ch == '\0')
  8005e7:	85 db                	test   %ebx,%ebx
  8005e9:	0f 84 c1 03 00 00    	je     8009b0 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005ef:	83 ec 08             	sub    $0x8,%esp
  8005f2:	ff 75 0c             	pushl  0xc(%ebp)
  8005f5:	53                   	push   %ebx
  8005f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f9:	ff d0                	call   *%eax
  8005fb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800601:	8d 50 01             	lea    0x1(%eax),%edx
  800604:	89 55 10             	mov    %edx,0x10(%ebp)
  800607:	8a 00                	mov    (%eax),%al
  800609:	0f b6 d8             	movzbl %al,%ebx
  80060c:	83 fb 25             	cmp    $0x25,%ebx
  80060f:	75 d6                	jne    8005e7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800611:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800615:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80061c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800623:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80062a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800631:	8b 45 10             	mov    0x10(%ebp),%eax
  800634:	8d 50 01             	lea    0x1(%eax),%edx
  800637:	89 55 10             	mov    %edx,0x10(%ebp)
  80063a:	8a 00                	mov    (%eax),%al
  80063c:	0f b6 d8             	movzbl %al,%ebx
  80063f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800642:	83 f8 5b             	cmp    $0x5b,%eax
  800645:	0f 87 3d 03 00 00    	ja     800988 <vprintfmt+0x3ab>
  80064b:	8b 04 85 f8 3f 80 00 	mov    0x803ff8(,%eax,4),%eax
  800652:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800654:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800658:	eb d7                	jmp    800631 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80065a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80065e:	eb d1                	jmp    800631 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800660:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800667:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80066a:	89 d0                	mov    %edx,%eax
  80066c:	c1 e0 02             	shl    $0x2,%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	01 c0                	add    %eax,%eax
  800673:	01 d8                	add    %ebx,%eax
  800675:	83 e8 30             	sub    $0x30,%eax
  800678:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80067b:	8b 45 10             	mov    0x10(%ebp),%eax
  80067e:	8a 00                	mov    (%eax),%al
  800680:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800683:	83 fb 2f             	cmp    $0x2f,%ebx
  800686:	7e 3e                	jle    8006c6 <vprintfmt+0xe9>
  800688:	83 fb 39             	cmp    $0x39,%ebx
  80068b:	7f 39                	jg     8006c6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80068d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800690:	eb d5                	jmp    800667 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	83 c0 04             	add    $0x4,%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	83 e8 04             	sub    $0x4,%eax
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006a6:	eb 1f                	jmp    8006c7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ac:	79 83                	jns    800631 <vprintfmt+0x54>
				width = 0;
  8006ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006b5:	e9 77 ff ff ff       	jmp    800631 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006ba:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006c1:	e9 6b ff ff ff       	jmp    800631 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006c6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cb:	0f 89 60 ff ff ff    	jns    800631 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006d7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006de:	e9 4e ff ff ff       	jmp    800631 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006e3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006e6:	e9 46 ff ff ff       	jmp    800631 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	83 c0 04             	add    $0x4,%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 ec 08             	sub    $0x8,%esp
  8006ff:	ff 75 0c             	pushl  0xc(%ebp)
  800702:	50                   	push   %eax
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	ff d0                	call   *%eax
  800708:	83 c4 10             	add    $0x10,%esp
			break;
  80070b:	e9 9b 02 00 00       	jmp    8009ab <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	83 c0 04             	add    $0x4,%eax
  800716:	89 45 14             	mov    %eax,0x14(%ebp)
  800719:	8b 45 14             	mov    0x14(%ebp),%eax
  80071c:	83 e8 04             	sub    $0x4,%eax
  80071f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800721:	85 db                	test   %ebx,%ebx
  800723:	79 02                	jns    800727 <vprintfmt+0x14a>
				err = -err;
  800725:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800727:	83 fb 64             	cmp    $0x64,%ebx
  80072a:	7f 0b                	jg     800737 <vprintfmt+0x15a>
  80072c:	8b 34 9d 40 3e 80 00 	mov    0x803e40(,%ebx,4),%esi
  800733:	85 f6                	test   %esi,%esi
  800735:	75 19                	jne    800750 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800737:	53                   	push   %ebx
  800738:	68 e5 3f 80 00       	push   $0x803fe5
  80073d:	ff 75 0c             	pushl  0xc(%ebp)
  800740:	ff 75 08             	pushl  0x8(%ebp)
  800743:	e8 70 02 00 00       	call   8009b8 <printfmt>
  800748:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80074b:	e9 5b 02 00 00       	jmp    8009ab <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800750:	56                   	push   %esi
  800751:	68 ee 3f 80 00       	push   $0x803fee
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	ff 75 08             	pushl  0x8(%ebp)
  80075c:	e8 57 02 00 00       	call   8009b8 <printfmt>
  800761:	83 c4 10             	add    $0x10,%esp
			break;
  800764:	e9 42 02 00 00       	jmp    8009ab <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	83 c0 04             	add    $0x4,%eax
  80076f:	89 45 14             	mov    %eax,0x14(%ebp)
  800772:	8b 45 14             	mov    0x14(%ebp),%eax
  800775:	83 e8 04             	sub    $0x4,%eax
  800778:	8b 30                	mov    (%eax),%esi
  80077a:	85 f6                	test   %esi,%esi
  80077c:	75 05                	jne    800783 <vprintfmt+0x1a6>
				p = "(null)";
  80077e:	be f1 3f 80 00       	mov    $0x803ff1,%esi
			if (width > 0 && padc != '-')
  800783:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800787:	7e 6d                	jle    8007f6 <vprintfmt+0x219>
  800789:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80078d:	74 67                	je     8007f6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80078f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800792:	83 ec 08             	sub    $0x8,%esp
  800795:	50                   	push   %eax
  800796:	56                   	push   %esi
  800797:	e8 1e 03 00 00       	call   800aba <strnlen>
  80079c:	83 c4 10             	add    $0x10,%esp
  80079f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007a2:	eb 16                	jmp    8007ba <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007a4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	50                   	push   %eax
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	ff d0                	call   *%eax
  8007b4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b7:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007be:	7f e4                	jg     8007a4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c0:	eb 34                	jmp    8007f6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007c2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007c6:	74 1c                	je     8007e4 <vprintfmt+0x207>
  8007c8:	83 fb 1f             	cmp    $0x1f,%ebx
  8007cb:	7e 05                	jle    8007d2 <vprintfmt+0x1f5>
  8007cd:	83 fb 7e             	cmp    $0x7e,%ebx
  8007d0:	7e 12                	jle    8007e4 <vprintfmt+0x207>
					putch('?', putdat);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	ff 75 0c             	pushl  0xc(%ebp)
  8007d8:	6a 3f                	push   $0x3f
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	ff d0                	call   *%eax
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	eb 0f                	jmp    8007f3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ea:	53                   	push   %ebx
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	ff d0                	call   *%eax
  8007f0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f3:	ff 4d e4             	decl   -0x1c(%ebp)
  8007f6:	89 f0                	mov    %esi,%eax
  8007f8:	8d 70 01             	lea    0x1(%eax),%esi
  8007fb:	8a 00                	mov    (%eax),%al
  8007fd:	0f be d8             	movsbl %al,%ebx
  800800:	85 db                	test   %ebx,%ebx
  800802:	74 24                	je     800828 <vprintfmt+0x24b>
  800804:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800808:	78 b8                	js     8007c2 <vprintfmt+0x1e5>
  80080a:	ff 4d e0             	decl   -0x20(%ebp)
  80080d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800811:	79 af                	jns    8007c2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800813:	eb 13                	jmp    800828 <vprintfmt+0x24b>
				putch(' ', putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	ff 75 0c             	pushl  0xc(%ebp)
  80081b:	6a 20                	push   $0x20
  80081d:	8b 45 08             	mov    0x8(%ebp),%eax
  800820:	ff d0                	call   *%eax
  800822:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800825:	ff 4d e4             	decl   -0x1c(%ebp)
  800828:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082c:	7f e7                	jg     800815 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80082e:	e9 78 01 00 00       	jmp    8009ab <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800833:	83 ec 08             	sub    $0x8,%esp
  800836:	ff 75 e8             	pushl  -0x18(%ebp)
  800839:	8d 45 14             	lea    0x14(%ebp),%eax
  80083c:	50                   	push   %eax
  80083d:	e8 3c fd ff ff       	call   80057e <getint>
  800842:	83 c4 10             	add    $0x10,%esp
  800845:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800848:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80084b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800851:	85 d2                	test   %edx,%edx
  800853:	79 23                	jns    800878 <vprintfmt+0x29b>
				putch('-', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 2d                	push   $0x2d
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800868:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80086b:	f7 d8                	neg    %eax
  80086d:	83 d2 00             	adc    $0x0,%edx
  800870:	f7 da                	neg    %edx
  800872:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800875:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800878:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80087f:	e9 bc 00 00 00       	jmp    800940 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800884:	83 ec 08             	sub    $0x8,%esp
  800887:	ff 75 e8             	pushl  -0x18(%ebp)
  80088a:	8d 45 14             	lea    0x14(%ebp),%eax
  80088d:	50                   	push   %eax
  80088e:	e8 84 fc ff ff       	call   800517 <getuint>
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800899:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80089c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008a3:	e9 98 00 00 00       	jmp    800940 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008a8:	83 ec 08             	sub    $0x8,%esp
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	6a 58                	push   $0x58
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	ff d0                	call   *%eax
  8008b5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008b8:	83 ec 08             	sub    $0x8,%esp
  8008bb:	ff 75 0c             	pushl  0xc(%ebp)
  8008be:	6a 58                	push   $0x58
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	ff d0                	call   *%eax
  8008c5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008c8:	83 ec 08             	sub    $0x8,%esp
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	6a 58                	push   $0x58
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	ff d0                	call   *%eax
  8008d5:	83 c4 10             	add    $0x10,%esp
			break;
  8008d8:	e9 ce 00 00 00       	jmp    8009ab <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	6a 30                	push   $0x30
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	ff d0                	call   *%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	6a 78                	push   $0x78
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	ff d0                	call   *%eax
  8008fa:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	83 c0 04             	add    $0x4,%eax
  800903:	89 45 14             	mov    %eax,0x14(%ebp)
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 e8 04             	sub    $0x4,%eax
  80090c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80090e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800911:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800918:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80091f:	eb 1f                	jmp    800940 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 e8             	pushl  -0x18(%ebp)
  800927:	8d 45 14             	lea    0x14(%ebp),%eax
  80092a:	50                   	push   %eax
  80092b:	e8 e7 fb ff ff       	call   800517 <getuint>
  800930:	83 c4 10             	add    $0x10,%esp
  800933:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800936:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800939:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800940:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800947:	83 ec 04             	sub    $0x4,%esp
  80094a:	52                   	push   %edx
  80094b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80094e:	50                   	push   %eax
  80094f:	ff 75 f4             	pushl  -0xc(%ebp)
  800952:	ff 75 f0             	pushl  -0x10(%ebp)
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	ff 75 08             	pushl  0x8(%ebp)
  80095b:	e8 00 fb ff ff       	call   800460 <printnum>
  800960:	83 c4 20             	add    $0x20,%esp
			break;
  800963:	eb 46                	jmp    8009ab <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	ff 75 0c             	pushl  0xc(%ebp)
  80096b:	53                   	push   %ebx
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	ff d0                	call   *%eax
  800971:	83 c4 10             	add    $0x10,%esp
			break;
  800974:	eb 35                	jmp    8009ab <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800976:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
			break;
  80097d:	eb 2c                	jmp    8009ab <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80097f:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
			break;
  800986:	eb 23                	jmp    8009ab <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	6a 25                	push   $0x25
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800998:	ff 4d 10             	decl   0x10(%ebp)
  80099b:	eb 03                	jmp    8009a0 <vprintfmt+0x3c3>
  80099d:	ff 4d 10             	decl   0x10(%ebp)
  8009a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a3:	48                   	dec    %eax
  8009a4:	8a 00                	mov    (%eax),%al
  8009a6:	3c 25                	cmp    $0x25,%al
  8009a8:	75 f3                	jne    80099d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009aa:	90                   	nop
		}
	}
  8009ab:	e9 35 fc ff ff       	jmp    8005e5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009b0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009b4:	5b                   	pop    %ebx
  8009b5:	5e                   	pop    %esi
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009be:	8d 45 10             	lea    0x10(%ebp),%eax
  8009c1:	83 c0 04             	add    $0x4,%eax
  8009c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8009cd:	50                   	push   %eax
  8009ce:	ff 75 0c             	pushl  0xc(%ebp)
  8009d1:	ff 75 08             	pushl  0x8(%ebp)
  8009d4:	e8 04 fc ff ff       	call   8005dd <vprintfmt>
  8009d9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009dc:	90                   	nop
  8009dd:	c9                   	leave  
  8009de:	c3                   	ret    

008009df <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e5:	8b 40 08             	mov    0x8(%eax),%eax
  8009e8:	8d 50 01             	lea    0x1(%eax),%edx
  8009eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ee:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f4:	8b 10                	mov    (%eax),%edx
  8009f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f9:	8b 40 04             	mov    0x4(%eax),%eax
  8009fc:	39 c2                	cmp    %eax,%edx
  8009fe:	73 12                	jae    800a12 <sprintputch+0x33>
		*b->buf++ = ch;
  800a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a03:	8b 00                	mov    (%eax),%eax
  800a05:	8d 48 01             	lea    0x1(%eax),%ecx
  800a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0b:	89 0a                	mov    %ecx,(%edx)
  800a0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800a10:	88 10                	mov    %dl,(%eax)
}
  800a12:	90                   	nop
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	01 d0                	add    %edx,%eax
  800a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a3a:	74 06                	je     800a42 <vsnprintf+0x2d>
  800a3c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a40:	7f 07                	jg     800a49 <vsnprintf+0x34>
		return -E_INVAL;
  800a42:	b8 03 00 00 00       	mov    $0x3,%eax
  800a47:	eb 20                	jmp    800a69 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a49:	ff 75 14             	pushl  0x14(%ebp)
  800a4c:	ff 75 10             	pushl  0x10(%ebp)
  800a4f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	68 df 09 80 00       	push   $0x8009df
  800a58:	e8 80 fb ff ff       	call   8005dd <vprintfmt>
  800a5d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a63:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a69:	c9                   	leave  
  800a6a:	c3                   	ret    

00800a6b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a71:	8d 45 10             	lea    0x10(%ebp),%eax
  800a74:	83 c0 04             	add    $0x4,%eax
  800a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a80:	50                   	push   %eax
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	ff 75 08             	pushl  0x8(%ebp)
  800a87:	e8 89 ff ff ff       	call   800a15 <vsnprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aa4:	eb 06                	jmp    800aac <strlen+0x15>
		n++;
  800aa6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa9:	ff 45 08             	incl   0x8(%ebp)
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	8a 00                	mov    (%eax),%al
  800ab1:	84 c0                	test   %al,%al
  800ab3:	75 f1                	jne    800aa6 <strlen+0xf>
		n++;
	return n;
  800ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ab8:	c9                   	leave  
  800ab9:	c3                   	ret    

00800aba <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ac7:	eb 09                	jmp    800ad2 <strnlen+0x18>
		n++;
  800ac9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800acc:	ff 45 08             	incl   0x8(%ebp)
  800acf:	ff 4d 0c             	decl   0xc(%ebp)
  800ad2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad6:	74 09                	je     800ae1 <strnlen+0x27>
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	8a 00                	mov    (%eax),%al
  800add:	84 c0                	test   %al,%al
  800adf:	75 e8                	jne    800ac9 <strnlen+0xf>
		n++;
	return n;
  800ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800af2:	90                   	nop
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	8d 50 01             	lea    0x1(%eax),%edx
  800af9:	89 55 08             	mov    %edx,0x8(%ebp)
  800afc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b02:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b05:	8a 12                	mov    (%edx),%dl
  800b07:	88 10                	mov    %dl,(%eax)
  800b09:	8a 00                	mov    (%eax),%al
  800b0b:	84 c0                	test   %al,%al
  800b0d:	75 e4                	jne    800af3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b27:	eb 1f                	jmp    800b48 <strncpy+0x34>
		*dst++ = *src;
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8d 50 01             	lea    0x1(%eax),%edx
  800b2f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b35:	8a 12                	mov    (%edx),%dl
  800b37:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	8a 00                	mov    (%eax),%al
  800b3e:	84 c0                	test   %al,%al
  800b40:	74 03                	je     800b45 <strncpy+0x31>
			src++;
  800b42:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b45:	ff 45 fc             	incl   -0x4(%ebp)
  800b48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b4b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b4e:	72 d9                	jb     800b29 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b50:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b65:	74 30                	je     800b97 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b67:	eb 16                	jmp    800b7f <strlcpy+0x2a>
			*dst++ = *src++;
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8d 50 01             	lea    0x1(%eax),%edx
  800b6f:	89 55 08             	mov    %edx,0x8(%ebp)
  800b72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b75:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b78:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b7b:	8a 12                	mov    (%edx),%dl
  800b7d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b7f:	ff 4d 10             	decl   0x10(%ebp)
  800b82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b86:	74 09                	je     800b91 <strlcpy+0x3c>
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8a 00                	mov    (%eax),%al
  800b8d:	84 c0                	test   %al,%al
  800b8f:	75 d8                	jne    800b69 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b97:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b9d:	29 c2                	sub    %eax,%edx
  800b9f:	89 d0                	mov    %edx,%eax
}
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    

00800ba3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ba6:	eb 06                	jmp    800bae <strcmp+0xb>
		p++, q++;
  800ba8:	ff 45 08             	incl   0x8(%ebp)
  800bab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	84 c0                	test   %al,%al
  800bb5:	74 0e                	je     800bc5 <strcmp+0x22>
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	8a 10                	mov    (%eax),%dl
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	38 c2                	cmp    %al,%dl
  800bc3:	74 e3                	je     800ba8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8a 00                	mov    (%eax),%al
  800bca:	0f b6 d0             	movzbl %al,%edx
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	0f b6 c0             	movzbl %al,%eax
  800bd5:	29 c2                	sub    %eax,%edx
  800bd7:	89 d0                	mov    %edx,%eax
}
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800bde:	eb 09                	jmp    800be9 <strncmp+0xe>
		n--, p++, q++;
  800be0:	ff 4d 10             	decl   0x10(%ebp)
  800be3:	ff 45 08             	incl   0x8(%ebp)
  800be6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800be9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bed:	74 17                	je     800c06 <strncmp+0x2b>
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8a 00                	mov    (%eax),%al
  800bf4:	84 c0                	test   %al,%al
  800bf6:	74 0e                	je     800c06 <strncmp+0x2b>
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8a 10                	mov    (%eax),%dl
  800bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	38 c2                	cmp    %al,%dl
  800c04:	74 da                	je     800be0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c0a:	75 07                	jne    800c13 <strncmp+0x38>
		return 0;
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c11:	eb 14                	jmp    800c27 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	0f b6 d0             	movzbl %al,%edx
  800c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	0f b6 c0             	movzbl %al,%eax
  800c23:	29 c2                	sub    %eax,%edx
  800c25:	89 d0                	mov    %edx,%eax
}
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c35:	eb 12                	jmp    800c49 <strchr+0x20>
		if (*s == c)
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8a 00                	mov    (%eax),%al
  800c3c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c3f:	75 05                	jne    800c46 <strchr+0x1d>
			return (char *) s;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	eb 11                	jmp    800c57 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c46:	ff 45 08             	incl   0x8(%ebp)
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	84 c0                	test   %al,%al
  800c50:	75 e5                	jne    800c37 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c57:	c9                   	leave  
  800c58:	c3                   	ret    

00800c59 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	83 ec 04             	sub    $0x4,%esp
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c65:	eb 0d                	jmp    800c74 <strfind+0x1b>
		if (*s == c)
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	8a 00                	mov    (%eax),%al
  800c6c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c6f:	74 0e                	je     800c7f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c71:	ff 45 08             	incl   0x8(%ebp)
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	8a 00                	mov    (%eax),%al
  800c79:	84 c0                	test   %al,%al
  800c7b:	75 ea                	jne    800c67 <strfind+0xe>
  800c7d:	eb 01                	jmp    800c80 <strfind+0x27>
		if (*s == c)
			break;
  800c7f:	90                   	nop
	return (char *) s;
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c83:	c9                   	leave  
  800c84:	c3                   	ret    

00800c85 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c91:	8b 45 10             	mov    0x10(%ebp),%eax
  800c94:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c97:	eb 0e                	jmp    800ca7 <memset+0x22>
		*p++ = c;
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ca7:	ff 4d f8             	decl   -0x8(%ebp)
  800caa:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cae:	79 e9                	jns    800c99 <memset+0x14>
		*p++ = c;

	return v;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800cc7:	eb 16                	jmp    800cdf <memcpy+0x2a>
		*d++ = *s++;
  800cc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccc:	8d 50 01             	lea    0x1(%eax),%edx
  800ccf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cd5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cdb:	8a 12                	mov    (%edx),%dl
  800cdd:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800cdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce8:	85 c0                	test   %eax,%eax
  800cea:	75 dd                	jne    800cc9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cef:	c9                   	leave  
  800cf0:	c3                   	ret    

00800cf1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d06:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d09:	73 50                	jae    800d5b <memmove+0x6a>
  800d0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d11:	01 d0                	add    %edx,%eax
  800d13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d16:	76 43                	jbe    800d5b <memmove+0x6a>
		s += n;
  800d18:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d21:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d24:	eb 10                	jmp    800d36 <memmove+0x45>
			*--d = *--s;
  800d26:	ff 4d f8             	decl   -0x8(%ebp)
  800d29:	ff 4d fc             	decl   -0x4(%ebp)
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2f:	8a 10                	mov    (%eax),%dl
  800d31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d34:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d36:	8b 45 10             	mov    0x10(%ebp),%eax
  800d39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	75 e3                	jne    800d26 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d43:	eb 23                	jmp    800d68 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d48:	8d 50 01             	lea    0x1(%eax),%edx
  800d4b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d51:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d54:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d57:	8a 12                	mov    (%edx),%dl
  800d59:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d61:	89 55 10             	mov    %edx,0x10(%ebp)
  800d64:	85 c0                	test   %eax,%eax
  800d66:	75 dd                	jne    800d45 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    

00800d6d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d7f:	eb 2a                	jmp    800dab <memcmp+0x3e>
		if (*s1 != *s2)
  800d81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d84:	8a 10                	mov    (%eax),%dl
  800d86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	38 c2                	cmp    %al,%dl
  800d8d:	74 16                	je     800da5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	0f b6 d0             	movzbl %al,%edx
  800d97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	0f b6 c0             	movzbl %al,%eax
  800d9f:	29 c2                	sub    %eax,%edx
  800da1:	89 d0                	mov    %edx,%eax
  800da3:	eb 18                	jmp    800dbd <memcmp+0x50>
		s1++, s2++;
  800da5:	ff 45 fc             	incl   -0x4(%ebp)
  800da8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800dab:	8b 45 10             	mov    0x10(%ebp),%eax
  800dae:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db1:	89 55 10             	mov    %edx,0x10(%ebp)
  800db4:	85 c0                	test   %eax,%eax
  800db6:	75 c9                	jne    800d81 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800dc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcb:	01 d0                	add    %edx,%eax
  800dcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dd0:	eb 15                	jmp    800de7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	0f b6 c0             	movzbl %al,%eax
  800de0:	39 c2                	cmp    %eax,%edx
  800de2:	74 0d                	je     800df1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ded:	72 e3                	jb     800dd2 <memfind+0x13>
  800def:	eb 01                	jmp    800df2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800df1:	90                   	nop
	return (void *) s;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df5:	c9                   	leave  
  800df6:	c3                   	ret    

00800df7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800dfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e04:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e0b:	eb 03                	jmp    800e10 <strtol+0x19>
		s++;
  800e0d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	3c 20                	cmp    $0x20,%al
  800e17:	74 f4                	je     800e0d <strtol+0x16>
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8a 00                	mov    (%eax),%al
  800e1e:	3c 09                	cmp    $0x9,%al
  800e20:	74 eb                	je     800e0d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e22:	8b 45 08             	mov    0x8(%ebp),%eax
  800e25:	8a 00                	mov    (%eax),%al
  800e27:	3c 2b                	cmp    $0x2b,%al
  800e29:	75 05                	jne    800e30 <strtol+0x39>
		s++;
  800e2b:	ff 45 08             	incl   0x8(%ebp)
  800e2e:	eb 13                	jmp    800e43 <strtol+0x4c>
	else if (*s == '-')
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	3c 2d                	cmp    $0x2d,%al
  800e37:	75 0a                	jne    800e43 <strtol+0x4c>
		s++, neg = 1;
  800e39:	ff 45 08             	incl   0x8(%ebp)
  800e3c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e47:	74 06                	je     800e4f <strtol+0x58>
  800e49:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e4d:	75 20                	jne    800e6f <strtol+0x78>
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	3c 30                	cmp    $0x30,%al
  800e56:	75 17                	jne    800e6f <strtol+0x78>
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	40                   	inc    %eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	3c 78                	cmp    $0x78,%al
  800e60:	75 0d                	jne    800e6f <strtol+0x78>
		s += 2, base = 16;
  800e62:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e66:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e6d:	eb 28                	jmp    800e97 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e73:	75 15                	jne    800e8a <strtol+0x93>
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 30                	cmp    $0x30,%al
  800e7c:	75 0c                	jne    800e8a <strtol+0x93>
		s++, base = 8;
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e88:	eb 0d                	jmp    800e97 <strtol+0xa0>
	else if (base == 0)
  800e8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8e:	75 07                	jne    800e97 <strtol+0xa0>
		base = 10;
  800e90:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	3c 2f                	cmp    $0x2f,%al
  800e9e:	7e 19                	jle    800eb9 <strtol+0xc2>
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	3c 39                	cmp    $0x39,%al
  800ea7:	7f 10                	jg     800eb9 <strtol+0xc2>
			dig = *s - '0';
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	0f be c0             	movsbl %al,%eax
  800eb1:	83 e8 30             	sub    $0x30,%eax
  800eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eb7:	eb 42                	jmp    800efb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8a 00                	mov    (%eax),%al
  800ebe:	3c 60                	cmp    $0x60,%al
  800ec0:	7e 19                	jle    800edb <strtol+0xe4>
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	8a 00                	mov    (%eax),%al
  800ec7:	3c 7a                	cmp    $0x7a,%al
  800ec9:	7f 10                	jg     800edb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	0f be c0             	movsbl %al,%eax
  800ed3:	83 e8 57             	sub    $0x57,%eax
  800ed6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ed9:	eb 20                	jmp    800efb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800edb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	3c 40                	cmp    $0x40,%al
  800ee2:	7e 39                	jle    800f1d <strtol+0x126>
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	3c 5a                	cmp    $0x5a,%al
  800eeb:	7f 30                	jg     800f1d <strtol+0x126>
			dig = *s - 'A' + 10;
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f be c0             	movsbl %al,%eax
  800ef5:	83 e8 37             	sub    $0x37,%eax
  800ef8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800efe:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f01:	7d 19                	jge    800f1c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f03:	ff 45 08             	incl   0x8(%ebp)
  800f06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f09:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f0d:	89 c2                	mov    %eax,%edx
  800f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f12:	01 d0                	add    %edx,%eax
  800f14:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f17:	e9 7b ff ff ff       	jmp    800e97 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f1c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f21:	74 08                	je     800f2b <strtol+0x134>
		*endptr = (char *) s;
  800f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f2f:	74 07                	je     800f38 <strtol+0x141>
  800f31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f34:	f7 d8                	neg    %eax
  800f36:	eb 03                	jmp    800f3b <strtol+0x144>
  800f38:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <ltostr>:

void
ltostr(long value, char *str)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f43:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f4a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f55:	79 13                	jns    800f6a <ltostr+0x2d>
	{
		neg = 1;
  800f57:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f64:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f67:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f72:	99                   	cltd   
  800f73:	f7 f9                	idiv   %ecx
  800f75:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f7b:	8d 50 01             	lea    0x1(%eax),%edx
  800f7e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f81:	89 c2                	mov    %eax,%edx
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	01 d0                	add    %edx,%eax
  800f88:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f8b:	83 c2 30             	add    $0x30,%edx
  800f8e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f93:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f98:	f7 e9                	imul   %ecx
  800f9a:	c1 fa 02             	sar    $0x2,%edx
  800f9d:	89 c8                	mov    %ecx,%eax
  800f9f:	c1 f8 1f             	sar    $0x1f,%eax
  800fa2:	29 c2                	sub    %eax,%edx
  800fa4:	89 d0                	mov    %edx,%eax
  800fa6:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800fa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fad:	75 bb                	jne    800f6a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb9:	48                   	dec    %eax
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fc1:	74 3d                	je     801000 <ltostr+0xc3>
		start = 1 ;
  800fc3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fca:	eb 34                	jmp    801000 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd2:	01 d0                	add    %edx,%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 c2                	add    %eax,%edx
  800fe1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe7:	01 c8                	add    %ecx,%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	01 c2                	add    %eax,%edx
  800ff5:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ff8:	88 02                	mov    %al,(%edx)
		start++ ;
  800ffa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ffd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801003:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801006:	7c c4                	jl     800fcc <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801008:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80100b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100e:	01 d0                	add    %edx,%eax
  801010:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801013:	90                   	nop
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80101c:	ff 75 08             	pushl  0x8(%ebp)
  80101f:	e8 73 fa ff ff       	call   800a97 <strlen>
  801024:	83 c4 04             	add    $0x4,%esp
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80102a:	ff 75 0c             	pushl  0xc(%ebp)
  80102d:	e8 65 fa ff ff       	call   800a97 <strlen>
  801032:	83 c4 04             	add    $0x4,%esp
  801035:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801038:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80103f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801046:	eb 17                	jmp    80105f <strcconcat+0x49>
		final[s] = str1[s] ;
  801048:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104b:	8b 45 10             	mov    0x10(%ebp),%eax
  80104e:	01 c2                	add    %eax,%edx
  801050:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	01 c8                	add    %ecx,%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80105c:	ff 45 fc             	incl   -0x4(%ebp)
  80105f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801062:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801065:	7c e1                	jl     801048 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801067:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80106e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801075:	eb 1f                	jmp    801096 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801077:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107a:	8d 50 01             	lea    0x1(%eax),%edx
  80107d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801080:	89 c2                	mov    %eax,%edx
  801082:	8b 45 10             	mov    0x10(%ebp),%eax
  801085:	01 c2                	add    %eax,%edx
  801087:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80108a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108d:	01 c8                	add    %ecx,%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801093:	ff 45 f8             	incl   -0x8(%ebp)
  801096:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801099:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80109c:	7c d9                	jl     801077 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80109e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	01 d0                	add    %edx,%eax
  8010a6:	c6 00 00             	movb   $0x0,(%eax)
}
  8010a9:	90                   	nop
  8010aa:	c9                   	leave  
  8010ab:	c3                   	ret    

008010ac <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010af:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c7:	01 d0                	add    %edx,%eax
  8010c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010cf:	eb 0c                	jmp    8010dd <strsplit+0x31>
			*string++ = 0;
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	8d 50 01             	lea    0x1(%eax),%edx
  8010d7:	89 55 08             	mov    %edx,0x8(%ebp)
  8010da:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	84 c0                	test   %al,%al
  8010e4:	74 18                	je     8010fe <strsplit+0x52>
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	0f be c0             	movsbl %al,%eax
  8010ee:	50                   	push   %eax
  8010ef:	ff 75 0c             	pushl  0xc(%ebp)
  8010f2:	e8 32 fb ff ff       	call   800c29 <strchr>
  8010f7:	83 c4 08             	add    $0x8,%esp
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 d3                	jne    8010d1 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	84 c0                	test   %al,%al
  801105:	74 5a                	je     801161 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801107:	8b 45 14             	mov    0x14(%ebp),%eax
  80110a:	8b 00                	mov    (%eax),%eax
  80110c:	83 f8 0f             	cmp    $0xf,%eax
  80110f:	75 07                	jne    801118 <strsplit+0x6c>
		{
			return 0;
  801111:	b8 00 00 00 00       	mov    $0x0,%eax
  801116:	eb 66                	jmp    80117e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801118:	8b 45 14             	mov    0x14(%ebp),%eax
  80111b:	8b 00                	mov    (%eax),%eax
  80111d:	8d 48 01             	lea    0x1(%eax),%ecx
  801120:	8b 55 14             	mov    0x14(%ebp),%edx
  801123:	89 0a                	mov    %ecx,(%edx)
  801125:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80112c:	8b 45 10             	mov    0x10(%ebp),%eax
  80112f:	01 c2                	add    %eax,%edx
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801136:	eb 03                	jmp    80113b <strsplit+0x8f>
			string++;
  801138:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	84 c0                	test   %al,%al
  801142:	74 8b                	je     8010cf <strsplit+0x23>
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	0f be c0             	movsbl %al,%eax
  80114c:	50                   	push   %eax
  80114d:	ff 75 0c             	pushl  0xc(%ebp)
  801150:	e8 d4 fa ff ff       	call   800c29 <strchr>
  801155:	83 c4 08             	add    $0x8,%esp
  801158:	85 c0                	test   %eax,%eax
  80115a:	74 dc                	je     801138 <strsplit+0x8c>
			string++;
	}
  80115c:	e9 6e ff ff ff       	jmp    8010cf <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801161:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801162:	8b 45 14             	mov    0x14(%ebp),%eax
  801165:	8b 00                	mov    (%eax),%eax
  801167:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80116e:	8b 45 10             	mov    0x10(%ebp),%eax
  801171:	01 d0                	add    %edx,%eax
  801173:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801179:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80117e:	c9                   	leave  
  80117f:	c3                   	ret    

00801180 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801186:	83 ec 04             	sub    $0x4,%esp
  801189:	68 68 41 80 00       	push   $0x804168
  80118e:	68 3f 01 00 00       	push   $0x13f
  801193:	68 8a 41 80 00       	push   $0x80418a
  801198:	e8 7a 26 00 00       	call   803817 <_panic>

0080119d <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8011a3:	83 ec 0c             	sub    $0xc,%esp
  8011a6:	ff 75 08             	pushl  0x8(%ebp)
  8011a9:	e8 0a 0b 00 00       	call   801cb8 <sys_sbrk>
  8011ae:	83 c4 10             	add    $0x10,%esp
}
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    

008011b3 <malloc>:
	if(pt_get_page_permissions(ptr_page_directory,virtual_address) & PERM_AVAILABLE)return 1;
	//if(virtual_address&PERM_AVAILABLE) return 1;
	return 0;
}*/
void* malloc(uint32 size)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	83 ec 38             	sub    $0x38,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8011b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011bd:	75 0a                	jne    8011c9 <malloc+0x16>
  8011bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c4:	e9 07 02 00 00       	jmp    8013d0 <malloc+0x21d>
	// Write your code here, remove the panic and write your code
//	panic("malloc() is not implemented yet...!!");
//	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy
	uint32 num_pages = ROUNDUP(size ,PAGE_SIZE) / PAGE_SIZE;
  8011c9:	c7 45 dc 00 10 00 00 	movl   $0x1000,-0x24(%ebp)
  8011d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011d6:	01 d0                	add    %edx,%eax
  8011d8:	48                   	dec    %eax
  8011d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011df:	ba 00 00 00 00       	mov    $0x0,%edx
  8011e4:	f7 75 dc             	divl   -0x24(%ebp)
  8011e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011ea:	29 d0                	sub    %edx,%eax
  8011ec:	c1 e8 0c             	shr    $0xc,%eax
  8011ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 max_no_of_pages = ROUNDDOWN((uint32)USER_HEAP_MAX - (myEnv->heap_hard_limit + (uint32)PAGE_SIZE) ,PAGE_SIZE) / PAGE_SIZE;
  8011f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8011f7:	8b 40 78             	mov    0x78(%eax),%eax
  8011fa:	ba 00 f0 ff 9f       	mov    $0x9ffff000,%edx
  8011ff:	29 c2                	sub    %eax,%edx
  801201:	89 d0                	mov    %edx,%eax
  801203:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801206:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801209:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80120e:	c1 e8 0c             	shr    $0xc,%eax
  801211:	89 45 cc             	mov    %eax,-0x34(%ebp)
	void *ptr = NULL;
  801214:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE)
  80121b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801222:	77 42                	ja     801266 <malloc+0xb3>
	{
		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801224:	e8 13 09 00 00       	call   801b3c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801229:	85 c0                	test   %eax,%eax
  80122b:	74 16                	je     801243 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 53 0e 00 00       	call   80208b <alloc_block_FF>
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123e:	e9 8a 01 00 00       	jmp    8013cd <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801243:	e8 25 09 00 00       	call   801b6d <sys_isUHeapPlacementStrategyBESTFIT>
  801248:	85 c0                	test   %eax,%eax
  80124a:	0f 84 7d 01 00 00    	je     8013cd <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	ff 75 08             	pushl  0x8(%ebp)
  801256:	e8 ec 12 00 00       	call   802547 <alloc_block_BF>
  80125b:	83 c4 10             	add    $0x10,%esp
  80125e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801261:	e9 67 01 00 00       	jmp    8013cd <malloc+0x21a>
	}
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
  801266:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801269:	48                   	dec    %eax
  80126a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80126d:	0f 86 53 01 00 00    	jbe    8013c6 <malloc+0x213>
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
  801273:	a1 20 50 80 00       	mov    0x805020,%eax
  801278:	8b 40 78             	mov    0x78(%eax),%eax
  80127b:	05 00 10 00 00       	add    $0x1000,%eax
  801280:	89 45 f0             	mov    %eax,-0x10(%ebp)
		bool ok = 0;
  801283:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		while (i < (uint32)USER_HEAP_MAX)
  80128a:	e9 de 00 00 00       	jmp    80136d <malloc+0x1ba>
		{
			//cprintf("57\n");
			if (!isPageMarked[UHEAP_PAGE_INDEX(i)])
  80128f:	a1 20 50 80 00       	mov    0x805020,%eax
  801294:	8b 40 78             	mov    0x78(%eax),%eax
  801297:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80129a:	29 c2                	sub    %eax,%edx
  80129c:	89 d0                	mov    %edx,%eax
  80129e:	2d 00 10 00 00       	sub    $0x1000,%eax
  8012a3:	c1 e8 0c             	shr    $0xc,%eax
  8012a6:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	0f 85 ab 00 00 00    	jne    801360 <malloc+0x1ad>
			{
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
  8012b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b8:	05 00 10 00 00       	add    $0x1000,%eax
  8012bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8012c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  8012c7:	eb 47                	jmp    801310 <malloc+0x15d>
				{
					if(j >= (uint32)USER_HEAP_MAX) return NULL;
  8012c9:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8012d0:	76 0a                	jbe    8012dc <malloc+0x129>
  8012d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d7:	e9 f4 00 00 00       	jmp    8013d0 <malloc+0x21d>
					if (isPageMarked[UHEAP_PAGE_INDEX(j)])
  8012dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8012e1:	8b 40 78             	mov    0x78(%eax),%eax
  8012e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8012e7:	29 c2                	sub    %eax,%edx
  8012e9:	89 d0                	mov    %edx,%eax
  8012eb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8012f0:	c1 e8 0c             	shr    $0xc,%eax
  8012f3:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	74 08                	je     801306 <malloc+0x153>
					{
						//cprintf("71\n");
						i = j;
  8012fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801301:	89 45 f0             	mov    %eax,-0x10(%ebp)
						goto sayed;
  801304:	eb 5a                	jmp    801360 <malloc+0x1ad>
					}

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++
  801306:	81 45 e8 00 10 00 00 	addl   $0x1000,-0x18(%ebp)

					cnt++;
  80130d:	ff 45 e4             	incl   -0x1c(%ebp)
				//cprintf("60\n");
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				//cprintf("64\n");
				while(cnt < num_pages - 1)
  801310:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801313:	48                   	dec    %eax
  801314:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801317:	77 b0                	ja     8012c9 <malloc+0x116>

					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
  801319:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
				for(int k = 0;k<num_pages;k++)
  801320:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801327:	eb 2f                	jmp    801358 <malloc+0x1a5>
				{
					isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+i)]=1;
  801329:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80132c:	c1 e0 0c             	shl    $0xc,%eax
  80132f:	89 c2                	mov    %eax,%edx
  801331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801334:	01 c2                	add    %eax,%edx
  801336:	a1 20 50 80 00       	mov    0x805020,%eax
  80133b:	8b 40 78             	mov    0x78(%eax),%eax
  80133e:	29 c2                	sub    %eax,%edx
  801340:	89 d0                	mov    %edx,%eax
  801342:	2d 00 10 00 00       	sub    $0x1000,%eax
  801347:	c1 e8 0c             	shr    $0xc,%eax
  80134a:	c7 04 85 60 50 88 00 	movl   $0x1,0x885060(,%eax,4)
  801351:	01 00 00 00 
					j += (uint32)PAGE_SIZE; // <-- changed, was j ++

					cnt++;
				}
				ok = 1;
				for(int k = 0;k<num_pages;k++)
  801355:	ff 45 e0             	incl   -0x20(%ebp)
  801358:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80135b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80135e:	72 c9                	jb     801329 <malloc+0x176>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  801360:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801364:	75 16                	jne    80137c <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801366:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		//cprintf("52\n");
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  80136d:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801374:	0f 86 15 ff ff ff    	jbe    80128f <malloc+0xdc>
  80137a:	eb 01                	jmp    80137d <malloc+0x1ca>
				}
				//cprintf("79\n");

			}
			sayed:
			if(ok) break;
  80137c:	90                   	nop
			i += (uint32)PAGE_SIZE;
		}

		if(!ok) return NULL;
  80137d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801381:	75 07                	jne    80138a <malloc+0x1d7>
  801383:	b8 00 00 00 00       	mov    $0x0,%eax
  801388:	eb 46                	jmp    8013d0 <malloc+0x21d>
		ptr = (void*)i;
  80138a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		no_pages_marked[UHEAP_PAGE_INDEX(i)] = num_pages;
  801390:	a1 20 50 80 00       	mov    0x805020,%eax
  801395:	8b 40 78             	mov    0x78(%eax),%eax
  801398:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80139b:	29 c2                	sub    %eax,%edx
  80139d:	89 d0                	mov    %edx,%eax
  80139f:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a4:	c1 e8 0c             	shr    $0xc,%eax
  8013a7:	89 c2                	mov    %eax,%edx
  8013a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013ac:	89 04 95 60 50 90 00 	mov    %eax,0x905060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 08             	pushl  0x8(%ebp)
  8013b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8013bc:	e8 2e 09 00 00       	call   801cef <sys_allocate_user_mem>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	eb 07                	jmp    8013cd <malloc+0x21a>
		//cprintf("91\n");
	}
	else
	{
		return NULL;
  8013c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013cb:	eb 03                	jmp    8013d0 <malloc+0x21d>
	}
	return ptr;
  8013cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* va)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
//	panic("free() is not implemented yet...!!");
	//what's the hard_limit of user heap
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
  8013d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8013dd:	8b 40 78             	mov    0x78(%eax),%eax
  8013e0:	05 00 10 00 00       	add    $0x1000,%eax
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 size = 0;
  8013e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	if((uint32)va < myEnv->heap_hard_limit){
  8013ef:	a1 20 50 80 00       	mov    0x805020,%eax
  8013f4:	8b 50 78             	mov    0x78(%eax),%edx
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	39 c2                	cmp    %eax,%edx
  8013fc:	76 24                	jbe    801422 <free+0x50>
		size = get_block_size(va);
  8013fe:	83 ec 0c             	sub    $0xc,%esp
  801401:	ff 75 08             	pushl  0x8(%ebp)
  801404:	e8 02 09 00 00       	call   801d0b <get_block_size>
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80140f:	83 ec 0c             	sub    $0xc,%esp
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	e8 35 1b 00 00       	call   802f4f <free_block>
  80141a:	83 c4 10             	add    $0x10,%esp
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  80141d:	e9 ac 00 00 00       	jmp    8014ce <free+0xfc>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  801422:	8b 45 08             	mov    0x8(%ebp),%eax
  801425:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801428:	0f 82 89 00 00 00    	jb     8014b7 <free+0xe5>
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	3d ff ff ff 9f       	cmp    $0x9fffffff,%eax
  801436:	77 7f                	ja     8014b7 <free+0xe5>
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
  801438:	8b 55 08             	mov    0x8(%ebp),%edx
  80143b:	a1 20 50 80 00       	mov    0x805020,%eax
  801440:	8b 40 78             	mov    0x78(%eax),%eax
  801443:	29 c2                	sub    %eax,%edx
  801445:	89 d0                	mov    %edx,%eax
  801447:	2d 00 10 00 00       	sub    $0x1000,%eax
  80144c:	c1 e8 0c             	shr    $0xc,%eax
  80144f:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801456:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80145c:	c1 e0 0c             	shl    $0xc,%eax
  80145f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801469:	eb 2f                	jmp    80149a <free+0xc8>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	c1 e0 0c             	shl    $0xc,%eax
  801471:	89 c2                	mov    %eax,%edx
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	01 c2                	add    %eax,%edx
  801478:	a1 20 50 80 00       	mov    0x805020,%eax
  80147d:	8b 40 78             	mov    0x78(%eax),%eax
  801480:	29 c2                	sub    %eax,%edx
  801482:	89 d0                	mov    %edx,%eax
  801484:	2d 00 10 00 00       	sub    $0x1000,%eax
  801489:	c1 e8 0c             	shr    $0xc,%eax
  80148c:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801493:	00 00 00 00 
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  801497:	ff 45 f4             	incl   -0xc(%ebp)
  80149a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8014a0:	72 c9                	jb     80146b <free+0x99>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	ff 75 ec             	pushl  -0x14(%ebp)
  8014ab:	50                   	push   %eax
  8014ac:	e8 22 08 00 00       	call   801cd3 <sys_free_user_mem>
  8014b1:	83 c4 10             	add    $0x10,%esp
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8014b4:	90                   	nop
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
	}
}
  8014b5:	eb 17                	jmp    8014ce <free+0xfc>
		{
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
		}
		sys_free_user_mem((uint32)va, size);
	} else{
		panic("User free: The virtual Address is invalid");
  8014b7:	83 ec 04             	sub    $0x4,%esp
  8014ba:	68 98 41 80 00       	push   $0x804198
  8014bf:	68 85 00 00 00       	push   $0x85
  8014c4:	68 c2 41 80 00       	push   $0x8041c2
  8014c9:	e8 49 23 00 00       	call   803817 <_panic>
	}
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 28             	sub    $0x28,%esp
  8014d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d9:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8014dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014e0:	75 0a                	jne    8014ec <smalloc+0x1c>
  8014e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e7:	e9 9a 00 00 00       	jmp    801586 <smalloc+0xb6>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8014ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ff:	39 d0                	cmp    %edx,%eax
  801501:	73 02                	jae    801505 <smalloc+0x35>
  801503:	89 d0                	mov    %edx,%eax
  801505:	83 ec 0c             	sub    $0xc,%esp
  801508:	50                   	push   %eax
  801509:	e8 a5 fc ff ff       	call   8011b3 <malloc>
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801514:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801518:	75 07                	jne    801521 <smalloc+0x51>
  80151a:	b8 00 00 00 00       	mov    $0x0,%eax
  80151f:	eb 65                	jmp    801586 <smalloc+0xb6>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801521:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801525:	ff 75 ec             	pushl  -0x14(%ebp)
  801528:	50                   	push   %eax
  801529:	ff 75 0c             	pushl  0xc(%ebp)
  80152c:	ff 75 08             	pushl  0x8(%ebp)
  80152f:	e8 a6 03 00 00       	call   8018da <sys_createSharedObject>
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80153a:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80153e:	74 06                	je     801546 <smalloc+0x76>
  801540:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801544:	75 07                	jne    80154d <smalloc+0x7d>
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
  80154b:	eb 39                	jmp    801586 <smalloc+0xb6>
	 cprintf("Smalloc : %x \n",ptr);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	ff 75 ec             	pushl  -0x14(%ebp)
  801553:	68 ce 41 80 00       	push   $0x8041ce
  801558:	e8 a6 ee ff ff       	call   800403 <cprintf>
  80155d:	83 c4 10             	add    $0x10,%esp
	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  801560:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801563:	a1 20 50 80 00       	mov    0x805020,%eax
  801568:	8b 40 78             	mov    0x78(%eax),%eax
  80156b:	29 c2                	sub    %eax,%edx
  80156d:	89 d0                	mov    %edx,%eax
  80156f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801574:	c1 e8 0c             	shr    $0xc,%eax
  801577:	89 c2                	mov    %eax,%edx
  801579:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80157c:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801583:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80158e:	83 ec 08             	sub    $0x8,%esp
  801591:	ff 75 0c             	pushl  0xc(%ebp)
  801594:	ff 75 08             	pushl  0x8(%ebp)
  801597:	e8 68 03 00 00       	call   801904 <sys_getSizeOfSharedObject>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8015a2:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8015a6:	75 07                	jne    8015af <sget+0x27>
  8015a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ad:	eb 7f                	jmp    80162e <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  8015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015b5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8015bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c2:	39 d0                	cmp    %edx,%eax
  8015c4:	7d 02                	jge    8015c8 <sget+0x40>
  8015c6:	89 d0                	mov    %edx,%eax
  8015c8:	83 ec 0c             	sub    $0xc,%esp
  8015cb:	50                   	push   %eax
  8015cc:	e8 e2 fb ff ff       	call   8011b3 <malloc>
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8015d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015db:	75 07                	jne    8015e4 <sget+0x5c>
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e2:	eb 4a                	jmp    80162e <sget+0xa6>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ea:	ff 75 0c             	pushl  0xc(%ebp)
  8015ed:	ff 75 08             	pushl  0x8(%ebp)
  8015f0:	e8 2c 03 00 00       	call   801921 <sys_getSharedObject>
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] = ret;
  8015fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015fe:	a1 20 50 80 00       	mov    0x805020,%eax
  801603:	8b 40 78             	mov    0x78(%eax),%eax
  801606:	29 c2                	sub    %eax,%edx
  801608:	89 d0                	mov    %edx,%eax
  80160a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80160f:	c1 e8 0c             	shr    $0xc,%eax
  801612:	89 c2                	mov    %eax,%edx
  801614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801617:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80161e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801622:	75 07                	jne    80162b <sget+0xa3>
  801624:	b8 00 00 00 00       	mov    $0x0,%eax
  801629:	eb 03                	jmp    80162e <sget+0xa6>
	return ptr;
  80162b:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801636:	8b 55 08             	mov    0x8(%ebp),%edx
  801639:	a1 20 50 80 00       	mov    0x805020,%eax
  80163e:	8b 40 78             	mov    0x78(%eax),%eax
  801641:	29 c2                	sub    %eax,%edx
  801643:	89 d0                	mov    %edx,%eax
  801645:	2d 00 10 00 00       	sub    $0x1000,%eax
  80164a:	c1 e8 0c             	shr    $0xc,%eax
  80164d:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801654:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801657:	83 ec 08             	sub    $0x8,%esp
  80165a:	ff 75 08             	pushl  0x8(%ebp)
  80165d:	ff 75 f4             	pushl  -0xc(%ebp)
  801660:	e8 db 02 00 00       	call   801940 <sys_freeSharedObject>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  80166b:	90                   	nop
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801674:	83 ec 04             	sub    $0x4,%esp
  801677:	68 e0 41 80 00       	push   $0x8041e0
  80167c:	68 de 00 00 00       	push   $0xde
  801681:	68 c2 41 80 00       	push   $0x8041c2
  801686:	e8 8c 21 00 00       	call   803817 <_panic>

0080168b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	68 06 42 80 00       	push   $0x804206
  801699:	68 ea 00 00 00       	push   $0xea
  80169e:	68 c2 41 80 00       	push   $0x8041c2
  8016a3:	e8 6f 21 00 00       	call   803817 <_panic>

008016a8 <shrink>:

}
void shrink(uint32 newSize)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
  8016ab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	68 06 42 80 00       	push   $0x804206
  8016b6:	68 ef 00 00 00       	push   $0xef
  8016bb:	68 c2 41 80 00       	push   $0x8041c2
  8016c0:	e8 52 21 00 00       	call   803817 <_panic>

008016c5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	68 06 42 80 00       	push   $0x804206
  8016d3:	68 f4 00 00 00       	push   $0xf4
  8016d8:	68 c2 41 80 00       	push   $0x8041c2
  8016dd:	e8 35 21 00 00       	call   803817 <_panic>

008016e2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	57                   	push   %edi
  8016e6:	56                   	push   %esi
  8016e7:	53                   	push   %ebx
  8016e8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016fa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016fd:	cd 30                	int    $0x30
  8016ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801702:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	5b                   	pop    %ebx
  801709:	5e                   	pop    %esi
  80170a:	5f                   	pop    %edi
  80170b:	5d                   	pop    %ebp
  80170c:	c3                   	ret    

0080170d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	8b 45 10             	mov    0x10(%ebp),%eax
  801716:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801719:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	52                   	push   %edx
  801725:	ff 75 0c             	pushl  0xc(%ebp)
  801728:	50                   	push   %eax
  801729:	6a 00                	push   $0x0
  80172b:	e8 b2 ff ff ff       	call   8016e2 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	90                   	nop
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <sys_cgetc>:

int
sys_cgetc(void)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 02                	push   $0x2
  801745:	e8 98 ff ff ff       	call   8016e2 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <sys_lock_cons>:

void sys_lock_cons(void)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 03                	push   $0x3
  80175e:	e8 7f ff ff ff       	call   8016e2 <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	90                   	nop
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 04                	push   $0x4
  801778:	e8 65 ff ff ff       	call   8016e2 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	90                   	nop
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801786:	8b 55 0c             	mov    0xc(%ebp),%edx
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	52                   	push   %edx
  801793:	50                   	push   %eax
  801794:	6a 08                	push   $0x8
  801796:	e8 47 ff ff ff       	call   8016e2 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	56                   	push   %esi
  8017a4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017a5:	8b 75 18             	mov    0x18(%ebp),%esi
  8017a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	56                   	push   %esi
  8017b5:	53                   	push   %ebx
  8017b6:	51                   	push   %ecx
  8017b7:	52                   	push   %edx
  8017b8:	50                   	push   %eax
  8017b9:	6a 09                	push   $0x9
  8017bb:	e8 22 ff ff ff       	call   8016e2 <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c6:	5b                   	pop    %ebx
  8017c7:	5e                   	pop    %esi
  8017c8:	5d                   	pop    %ebp
  8017c9:	c3                   	ret    

008017ca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	52                   	push   %edx
  8017da:	50                   	push   %eax
  8017db:	6a 0a                	push   $0xa
  8017dd:	e8 00 ff ff ff       	call   8016e2 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	ff 75 0c             	pushl  0xc(%ebp)
  8017f3:	ff 75 08             	pushl  0x8(%ebp)
  8017f6:	6a 0b                	push   $0xb
  8017f8:	e8 e5 fe ff ff       	call   8016e2 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 0c                	push   $0xc
  801811:	e8 cc fe ff ff       	call   8016e2 <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 0d                	push   $0xd
  80182a:	e8 b3 fe ff ff       	call   8016e2 <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 0e                	push   $0xe
  801843:	e8 9a fe ff ff       	call   8016e2 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 0f                	push   $0xf
  80185c:	e8 81 fe ff ff       	call   8016e2 <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	6a 10                	push   $0x10
  801876:	e8 67 fe ff ff       	call   8016e2 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 11                	push   $0x11
  80188f:	e8 4e fe ff ff       	call   8016e2 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	90                   	nop
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_cputc>:

void
sys_cputc(const char c)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 04             	sub    $0x4,%esp
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	50                   	push   %eax
  8018b3:	6a 01                	push   $0x1
  8018b5:	e8 28 fe ff ff       	call   8016e2 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	90                   	nop
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 14                	push   $0x14
  8018cf:	e8 0e fe ff ff       	call   8016e2 <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	90                   	nop
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018e6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018e9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	6a 00                	push   $0x0
  8018f2:	51                   	push   %ecx
  8018f3:	52                   	push   %edx
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	50                   	push   %eax
  8018f8:	6a 15                	push   $0x15
  8018fa:	e8 e3 fd ff ff       	call   8016e2 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	52                   	push   %edx
  801914:	50                   	push   %eax
  801915:	6a 16                	push   $0x16
  801917:	e8 c6 fd ff ff       	call   8016e2 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801924:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	51                   	push   %ecx
  801932:	52                   	push   %edx
  801933:	50                   	push   %eax
  801934:	6a 17                	push   $0x17
  801936:	e8 a7 fd ff ff       	call   8016e2 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 18                	push   $0x18
  801953:	e8 8a fd ff ff       	call   8016e2 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	6a 00                	push   $0x0
  801965:	ff 75 14             	pushl  0x14(%ebp)
  801968:	ff 75 10             	pushl  0x10(%ebp)
  80196b:	ff 75 0c             	pushl  0xc(%ebp)
  80196e:	50                   	push   %eax
  80196f:	6a 19                	push   $0x19
  801971:	e8 6c fd ff ff       	call   8016e2 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_run_env>:

void sys_run_env(int32 envId)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	50                   	push   %eax
  80198a:	6a 1a                	push   $0x1a
  80198c:	e8 51 fd ff ff       	call   8016e2 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	90                   	nop
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	50                   	push   %eax
  8019a6:	6a 1b                	push   $0x1b
  8019a8:	e8 35 fd ff ff       	call   8016e2 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 05                	push   $0x5
  8019c1:	e8 1c fd ff ff       	call   8016e2 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 06                	push   $0x6
  8019da:	e8 03 fd ff ff       	call   8016e2 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 07                	push   $0x7
  8019f3:	e8 ea fc ff ff       	call   8016e2 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_exit_env>:


void sys_exit_env(void)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 1c                	push   $0x1c
  801a0c:	e8 d1 fc ff ff       	call   8016e2 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	90                   	nop
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a20:	8d 50 04             	lea    0x4(%eax),%edx
  801a23:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	52                   	push   %edx
  801a2d:	50                   	push   %eax
  801a2e:	6a 1d                	push   $0x1d
  801a30:	e8 ad fc ff ff       	call   8016e2 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
	return result;
  801a38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a41:	89 01                	mov    %eax,(%ecx)
  801a43:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	c9                   	leave  
  801a4a:	c2 04 00             	ret    $0x4

00801a4d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	ff 75 10             	pushl  0x10(%ebp)
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	ff 75 08             	pushl  0x8(%ebp)
  801a5d:	6a 13                	push   $0x13
  801a5f:	e8 7e fc ff ff       	call   8016e2 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
	return ;
  801a67:	90                   	nop
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_rcr2>:
uint32 sys_rcr2()
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 1e                	push   $0x1e
  801a79:	e8 64 fc ff ff       	call   8016e2 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a8f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	50                   	push   %eax
  801a9c:	6a 1f                	push   $0x1f
  801a9e:	e8 3f fc ff ff       	call   8016e2 <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa6:	90                   	nop
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <rsttst>:
void rsttst()
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 21                	push   $0x21
  801ab8:	e8 25 fc ff ff       	call   8016e2 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac0:	90                   	nop
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 04             	sub    $0x4,%esp
  801ac9:	8b 45 14             	mov    0x14(%ebp),%eax
  801acc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801acf:	8b 55 18             	mov    0x18(%ebp),%edx
  801ad2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	ff 75 10             	pushl  0x10(%ebp)
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	ff 75 08             	pushl  0x8(%ebp)
  801ae1:	6a 20                	push   $0x20
  801ae3:	e8 fa fb ff ff       	call   8016e2 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
	return ;
  801aeb:	90                   	nop
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <chktst>:
void chktst(uint32 n)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 08             	pushl  0x8(%ebp)
  801afc:	6a 22                	push   $0x22
  801afe:	e8 df fb ff ff       	call   8016e2 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
	return ;
  801b06:	90                   	nop
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <inctst>:

void inctst()
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 23                	push   $0x23
  801b18:	e8 c5 fb ff ff       	call   8016e2 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b20:	90                   	nop
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <gettst>:
uint32 gettst()
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 24                	push   $0x24
  801b32:	e8 ab fb ff ff       	call   8016e2 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 25                	push   $0x25
  801b4e:	e8 8f fb ff ff       	call   8016e2 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
  801b56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b59:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b5d:	75 07                	jne    801b66 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b64:	eb 05                	jmp    801b6b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 25                	push   $0x25
  801b7f:	e8 5e fb ff ff       	call   8016e2 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
  801b87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b8a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b8e:	75 07                	jne    801b97 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b90:	b8 01 00 00 00       	mov    $0x1,%eax
  801b95:	eb 05                	jmp    801b9c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 25                	push   $0x25
  801bb0:	e8 2d fb ff ff       	call   8016e2 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
  801bb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bbb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bbf:	75 07                	jne    801bc8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc6:	eb 05                	jmp    801bcd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 25                	push   $0x25
  801be1:	e8 fc fa ff ff       	call   8016e2 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
  801be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bf0:	75 07                	jne    801bf9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf7:	eb 05                	jmp    801bfe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	ff 75 08             	pushl  0x8(%ebp)
  801c0e:	6a 26                	push   $0x26
  801c10:	e8 cd fa ff ff       	call   8016e2 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
	return ;
  801c18:	90                   	nop
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	53                   	push   %ebx
  801c2e:	51                   	push   %ecx
  801c2f:	52                   	push   %edx
  801c30:	50                   	push   %eax
  801c31:	6a 27                	push   $0x27
  801c33:	e8 aa fa ff ff       	call   8016e2 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	52                   	push   %edx
  801c50:	50                   	push   %eax
  801c51:	6a 28                	push   $0x28
  801c53:	e8 8a fa ff ff       	call   8016e2 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c60:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	6a 00                	push   $0x0
  801c6b:	51                   	push   %ecx
  801c6c:	ff 75 10             	pushl  0x10(%ebp)
  801c6f:	52                   	push   %edx
  801c70:	50                   	push   %eax
  801c71:	6a 29                	push   $0x29
  801c73:	e8 6a fa ff ff       	call   8016e2 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	ff 75 10             	pushl  0x10(%ebp)
  801c87:	ff 75 0c             	pushl  0xc(%ebp)
  801c8a:	ff 75 08             	pushl  0x8(%ebp)
  801c8d:	6a 12                	push   $0x12
  801c8f:	e8 4e fa ff ff       	call   8016e2 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
	return ;
  801c97:	90                   	nop
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	52                   	push   %edx
  801caa:	50                   	push   %eax
  801cab:	6a 2a                	push   $0x2a
  801cad:	e8 30 fa ff ff       	call   8016e2 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
	return;
  801cb5:	90                   	nop
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	50                   	push   %eax
  801cc7:	6a 2b                	push   $0x2b
  801cc9:	e8 14 fa ff ff       	call   8016e2 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	ff 75 0c             	pushl  0xc(%ebp)
  801cdf:	ff 75 08             	pushl  0x8(%ebp)
  801ce2:	6a 2c                	push   $0x2c
  801ce4:	e8 f9 f9 ff ff       	call   8016e2 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
	return;
  801cec:	90                   	nop
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	ff 75 0c             	pushl  0xc(%ebp)
  801cfb:	ff 75 08             	pushl  0x8(%ebp)
  801cfe:	6a 2d                	push   $0x2d
  801d00:	e8 dd f9 ff ff       	call   8016e2 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
	return;
  801d08:	90                   	nop
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	83 e8 04             	sub    $0x4,%eax
  801d17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d1d:	8b 00                	mov    (%eax),%eax
  801d1f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	83 e8 04             	sub    $0x4,%eax
  801d30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801d33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d36:	8b 00                	mov    (%eax),%eax
  801d38:	83 e0 01             	and    $0x1,%eax
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	0f 94 c0             	sete   %al
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801d48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d52:	83 f8 02             	cmp    $0x2,%eax
  801d55:	74 2b                	je     801d82 <alloc_block+0x40>
  801d57:	83 f8 02             	cmp    $0x2,%eax
  801d5a:	7f 07                	jg     801d63 <alloc_block+0x21>
  801d5c:	83 f8 01             	cmp    $0x1,%eax
  801d5f:	74 0e                	je     801d6f <alloc_block+0x2d>
  801d61:	eb 58                	jmp    801dbb <alloc_block+0x79>
  801d63:	83 f8 03             	cmp    $0x3,%eax
  801d66:	74 2d                	je     801d95 <alloc_block+0x53>
  801d68:	83 f8 04             	cmp    $0x4,%eax
  801d6b:	74 3b                	je     801da8 <alloc_block+0x66>
  801d6d:	eb 4c                	jmp    801dbb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801d6f:	83 ec 0c             	sub    $0xc,%esp
  801d72:	ff 75 08             	pushl  0x8(%ebp)
  801d75:	e8 11 03 00 00       	call   80208b <alloc_block_FF>
  801d7a:	83 c4 10             	add    $0x10,%esp
  801d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d80:	eb 4a                	jmp    801dcc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801d82:	83 ec 0c             	sub    $0xc,%esp
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	e8 fa 19 00 00       	call   803787 <alloc_block_NF>
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d93:	eb 37                	jmp    801dcc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801d95:	83 ec 0c             	sub    $0xc,%esp
  801d98:	ff 75 08             	pushl  0x8(%ebp)
  801d9b:	e8 a7 07 00 00       	call   802547 <alloc_block_BF>
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801da6:	eb 24                	jmp    801dcc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801da8:	83 ec 0c             	sub    $0xc,%esp
  801dab:	ff 75 08             	pushl  0x8(%ebp)
  801dae:	e8 b7 19 00 00       	call   80376a <alloc_block_WF>
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801db9:	eb 11                	jmp    801dcc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801dbb:	83 ec 0c             	sub    $0xc,%esp
  801dbe:	68 18 42 80 00       	push   $0x804218
  801dc3:	e8 3b e6 ff ff       	call   800403 <cprintf>
  801dc8:	83 c4 10             	add    $0x10,%esp
		break;
  801dcb:	90                   	nop
	}
	return va;
  801dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	53                   	push   %ebx
  801dd5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	68 38 42 80 00       	push   $0x804238
  801de0:	e8 1e e6 ff ff       	call   800403 <cprintf>
  801de5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801de8:	83 ec 0c             	sub    $0xc,%esp
  801deb:	68 63 42 80 00       	push   $0x804263
  801df0:	e8 0e e6 ff ff       	call   800403 <cprintf>
  801df5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfe:	eb 37                	jmp    801e37 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	ff 75 f4             	pushl  -0xc(%ebp)
  801e06:	e8 19 ff ff ff       	call   801d24 <is_free_block>
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	0f be d8             	movsbl %al,%ebx
  801e11:	83 ec 0c             	sub    $0xc,%esp
  801e14:	ff 75 f4             	pushl  -0xc(%ebp)
  801e17:	e8 ef fe ff ff       	call   801d0b <get_block_size>
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	83 ec 04             	sub    $0x4,%esp
  801e22:	53                   	push   %ebx
  801e23:	50                   	push   %eax
  801e24:	68 7b 42 80 00       	push   $0x80427b
  801e29:	e8 d5 e5 ff ff       	call   800403 <cprintf>
  801e2e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801e31:	8b 45 10             	mov    0x10(%ebp),%eax
  801e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e3b:	74 07                	je     801e44 <print_blocks_list+0x73>
  801e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e40:	8b 00                	mov    (%eax),%eax
  801e42:	eb 05                	jmp    801e49 <print_blocks_list+0x78>
  801e44:	b8 00 00 00 00       	mov    $0x0,%eax
  801e49:	89 45 10             	mov    %eax,0x10(%ebp)
  801e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	75 ad                	jne    801e00 <print_blocks_list+0x2f>
  801e53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e57:	75 a7                	jne    801e00 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801e59:	83 ec 0c             	sub    $0xc,%esp
  801e5c:	68 38 42 80 00       	push   $0x804238
  801e61:	e8 9d e5 ff ff       	call   800403 <cprintf>
  801e66:	83 c4 10             	add    $0x10,%esp

}
  801e69:	90                   	nop
  801e6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e78:	83 e0 01             	and    $0x1,%eax
  801e7b:	85 c0                	test   %eax,%eax
  801e7d:	74 03                	je     801e82 <initialize_dynamic_allocator+0x13>
  801e7f:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801e82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e86:	0f 84 c7 01 00 00    	je     802053 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801e8c:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801e93:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801e96:	8b 55 08             	mov    0x8(%ebp),%edx
  801e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9c:	01 d0                	add    %edx,%eax
  801e9e:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801ea3:	0f 87 ad 01 00 00    	ja     802056 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	85 c0                	test   %eax,%eax
  801eae:	0f 89 a5 01 00 00    	jns    802059 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  801eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eba:	01 d0                	add    %edx,%eax
  801ebc:	83 e8 04             	sub    $0x4,%eax
  801ebf:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801ec4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801ecb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed3:	e9 87 00 00 00       	jmp    801f5f <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edc:	75 14                	jne    801ef2 <initialize_dynamic_allocator+0x83>
  801ede:	83 ec 04             	sub    $0x4,%esp
  801ee1:	68 93 42 80 00       	push   $0x804293
  801ee6:	6a 79                	push   $0x79
  801ee8:	68 b1 42 80 00       	push   $0x8042b1
  801eed:	e8 25 19 00 00       	call   803817 <_panic>
  801ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef5:	8b 00                	mov    (%eax),%eax
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	74 10                	je     801f0b <initialize_dynamic_allocator+0x9c>
  801efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efe:	8b 00                	mov    (%eax),%eax
  801f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f03:	8b 52 04             	mov    0x4(%edx),%edx
  801f06:	89 50 04             	mov    %edx,0x4(%eax)
  801f09:	eb 0b                	jmp    801f16 <initialize_dynamic_allocator+0xa7>
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	8b 40 04             	mov    0x4(%eax),%eax
  801f11:	a3 30 50 80 00       	mov    %eax,0x805030
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	8b 40 04             	mov    0x4(%eax),%eax
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	74 0f                	je     801f2f <initialize_dynamic_allocator+0xc0>
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	8b 40 04             	mov    0x4(%eax),%eax
  801f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f29:	8b 12                	mov    (%edx),%edx
  801f2b:	89 10                	mov    %edx,(%eax)
  801f2d:	eb 0a                	jmp    801f39 <initialize_dynamic_allocator+0xca>
  801f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f32:	8b 00                	mov    (%eax),%eax
  801f34:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f4c:	a1 38 50 80 00       	mov    0x805038,%eax
  801f51:	48                   	dec    %eax
  801f52:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801f57:	a1 34 50 80 00       	mov    0x805034,%eax
  801f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f63:	74 07                	je     801f6c <initialize_dynamic_allocator+0xfd>
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	8b 00                	mov    (%eax),%eax
  801f6a:	eb 05                	jmp    801f71 <initialize_dynamic_allocator+0x102>
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f71:	a3 34 50 80 00       	mov    %eax,0x805034
  801f76:	a1 34 50 80 00       	mov    0x805034,%eax
  801f7b:	85 c0                	test   %eax,%eax
  801f7d:	0f 85 55 ff ff ff    	jne    801ed8 <initialize_dynamic_allocator+0x69>
  801f83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f87:	0f 85 4b ff ff ff    	jne    801ed8 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f96:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801f9c:	a1 44 50 80 00       	mov    0x805044,%eax
  801fa1:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801fa6:	a1 40 50 80 00       	mov    0x805040,%eax
  801fab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	83 c0 08             	add    $0x8,%eax
  801fb7:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	83 c0 04             	add    $0x4,%eax
  801fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc3:	83 ea 08             	sub    $0x8,%edx
  801fc6:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	01 d0                	add    %edx,%eax
  801fd0:	83 e8 08             	sub    $0x8,%eax
  801fd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd6:	83 ea 08             	sub    $0x8,%edx
  801fd9:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801fee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ff2:	75 17                	jne    80200b <initialize_dynamic_allocator+0x19c>
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	68 cc 42 80 00       	push   $0x8042cc
  801ffc:	68 90 00 00 00       	push   $0x90
  802001:	68 b1 42 80 00       	push   $0x8042b1
  802006:	e8 0c 18 00 00       	call   803817 <_panic>
  80200b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802011:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802014:	89 10                	mov    %edx,(%eax)
  802016:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802019:	8b 00                	mov    (%eax),%eax
  80201b:	85 c0                	test   %eax,%eax
  80201d:	74 0d                	je     80202c <initialize_dynamic_allocator+0x1bd>
  80201f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802024:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802027:	89 50 04             	mov    %edx,0x4(%eax)
  80202a:	eb 08                	jmp    802034 <initialize_dynamic_allocator+0x1c5>
  80202c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202f:	a3 30 50 80 00       	mov    %eax,0x805030
  802034:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802037:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80203c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802046:	a1 38 50 80 00       	mov    0x805038,%eax
  80204b:	40                   	inc    %eax
  80204c:	a3 38 50 80 00       	mov    %eax,0x805038
  802051:	eb 07                	jmp    80205a <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802053:	90                   	nop
  802054:	eb 04                	jmp    80205a <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802056:	90                   	nop
  802057:	eb 01                	jmp    80205a <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802059:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80205f:	8b 45 10             	mov    0x10(%ebp),%eax
  802062:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	8d 50 fc             	lea    -0x4(%eax),%edx
  80206b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206e:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	83 e8 04             	sub    $0x4,%eax
  802076:	8b 00                	mov    (%eax),%eax
  802078:	83 e0 fe             	and    $0xfffffffe,%eax
  80207b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	01 c2                	add    %eax,%edx
  802083:	8b 45 0c             	mov    0xc(%ebp),%eax
  802086:	89 02                	mov    %eax,(%edx)
}
  802088:	90                   	nop
  802089:	5d                   	pop    %ebp
  80208a:	c3                   	ret    

0080208b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	83 e0 01             	and    $0x1,%eax
  802097:	85 c0                	test   %eax,%eax
  802099:	74 03                	je     80209e <alloc_block_FF+0x13>
  80209b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80209e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8020a2:	77 07                	ja     8020ab <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8020a4:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8020ab:	a1 24 50 80 00       	mov    0x805024,%eax
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	75 73                	jne    802127 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	83 c0 10             	add    $0x10,%eax
  8020ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8020bd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ca:	01 d0                	add    %edx,%eax
  8020cc:	48                   	dec    %eax
  8020cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d8:	f7 75 ec             	divl   -0x14(%ebp)
  8020db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020de:	29 d0                	sub    %edx,%eax
  8020e0:	c1 e8 0c             	shr    $0xc,%eax
  8020e3:	83 ec 0c             	sub    $0xc,%esp
  8020e6:	50                   	push   %eax
  8020e7:	e8 b1 f0 ff ff       	call   80119d <sbrk>
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8020f2:	83 ec 0c             	sub    $0xc,%esp
  8020f5:	6a 00                	push   $0x0
  8020f7:	e8 a1 f0 ff ff       	call   80119d <sbrk>
  8020fc:	83 c4 10             	add    $0x10,%esp
  8020ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802102:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802105:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802108:	83 ec 08             	sub    $0x8,%esp
  80210b:	50                   	push   %eax
  80210c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80210f:	e8 5b fd ff ff       	call   801e6f <initialize_dynamic_allocator>
  802114:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802117:	83 ec 0c             	sub    $0xc,%esp
  80211a:	68 ef 42 80 00       	push   $0x8042ef
  80211f:	e8 df e2 ff ff       	call   800403 <cprintf>
  802124:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802127:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80212b:	75 0a                	jne    802137 <alloc_block_FF+0xac>
	        return NULL;
  80212d:	b8 00 00 00 00       	mov    $0x0,%eax
  802132:	e9 0e 04 00 00       	jmp    802545 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80213e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802143:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802146:	e9 f3 02 00 00       	jmp    80243e <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  80214b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  802151:	83 ec 0c             	sub    $0xc,%esp
  802154:	ff 75 bc             	pushl  -0x44(%ebp)
  802157:	e8 af fb ff ff       	call   801d0b <get_block_size>
  80215c:	83 c4 10             	add    $0x10,%esp
  80215f:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	83 c0 08             	add    $0x8,%eax
  802168:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80216b:	0f 87 c5 02 00 00    	ja     802436 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	83 c0 18             	add    $0x18,%eax
  802177:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80217a:	0f 87 19 02 00 00    	ja     802399 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802180:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802183:	2b 45 08             	sub    0x8(%ebp),%eax
  802186:	83 e8 08             	sub    $0x8,%eax
  802189:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	8d 50 08             	lea    0x8(%eax),%edx
  802192:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802195:	01 d0                	add    %edx,%eax
  802197:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	83 c0 08             	add    $0x8,%eax
  8021a0:	83 ec 04             	sub    $0x4,%esp
  8021a3:	6a 01                	push   $0x1
  8021a5:	50                   	push   %eax
  8021a6:	ff 75 bc             	pushl  -0x44(%ebp)
  8021a9:	e8 ae fe ff ff       	call   80205c <set_block_data>
  8021ae:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 40 04             	mov    0x4(%eax),%eax
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	75 68                	jne    802223 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8021bb:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021bf:	75 17                	jne    8021d8 <alloc_block_FF+0x14d>
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	68 cc 42 80 00       	push   $0x8042cc
  8021c9:	68 d7 00 00 00       	push   $0xd7
  8021ce:	68 b1 42 80 00       	push   $0x8042b1
  8021d3:	e8 3f 16 00 00       	call   803817 <_panic>
  8021d8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e1:	89 10                	mov    %edx,(%eax)
  8021e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e6:	8b 00                	mov    (%eax),%eax
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	74 0d                	je     8021f9 <alloc_block_FF+0x16e>
  8021ec:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021f1:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021f4:	89 50 04             	mov    %edx,0x4(%eax)
  8021f7:	eb 08                	jmp    802201 <alloc_block_FF+0x176>
  8021f9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021fc:	a3 30 50 80 00       	mov    %eax,0x805030
  802201:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802204:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802209:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80220c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802213:	a1 38 50 80 00       	mov    0x805038,%eax
  802218:	40                   	inc    %eax
  802219:	a3 38 50 80 00       	mov    %eax,0x805038
  80221e:	e9 dc 00 00 00       	jmp    8022ff <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	8b 00                	mov    (%eax),%eax
  802228:	85 c0                	test   %eax,%eax
  80222a:	75 65                	jne    802291 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80222c:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802230:	75 17                	jne    802249 <alloc_block_FF+0x1be>
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	68 00 43 80 00       	push   $0x804300
  80223a:	68 db 00 00 00       	push   $0xdb
  80223f:	68 b1 42 80 00       	push   $0x8042b1
  802244:	e8 ce 15 00 00       	call   803817 <_panic>
  802249:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80224f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802252:	89 50 04             	mov    %edx,0x4(%eax)
  802255:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802258:	8b 40 04             	mov    0x4(%eax),%eax
  80225b:	85 c0                	test   %eax,%eax
  80225d:	74 0c                	je     80226b <alloc_block_FF+0x1e0>
  80225f:	a1 30 50 80 00       	mov    0x805030,%eax
  802264:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802267:	89 10                	mov    %edx,(%eax)
  802269:	eb 08                	jmp    802273 <alloc_block_FF+0x1e8>
  80226b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80226e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802273:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802276:	a3 30 50 80 00       	mov    %eax,0x805030
  80227b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80227e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802284:	a1 38 50 80 00       	mov    0x805038,%eax
  802289:	40                   	inc    %eax
  80228a:	a3 38 50 80 00       	mov    %eax,0x805038
  80228f:	eb 6e                	jmp    8022ff <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802295:	74 06                	je     80229d <alloc_block_FF+0x212>
  802297:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80229b:	75 17                	jne    8022b4 <alloc_block_FF+0x229>
  80229d:	83 ec 04             	sub    $0x4,%esp
  8022a0:	68 24 43 80 00       	push   $0x804324
  8022a5:	68 df 00 00 00       	push   $0xdf
  8022aa:	68 b1 42 80 00       	push   $0x8042b1
  8022af:	e8 63 15 00 00       	call   803817 <_panic>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 10                	mov    (%eax),%edx
  8022b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022bc:	89 10                	mov    %edx,(%eax)
  8022be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022c1:	8b 00                	mov    (%eax),%eax
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	74 0b                	je     8022d2 <alloc_block_FF+0x247>
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 00                	mov    (%eax),%eax
  8022cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022cf:	89 50 04             	mov    %edx,0x4(%eax)
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022d8:	89 10                	mov    %edx,(%eax)
  8022da:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e0:	89 50 04             	mov    %edx,0x4(%eax)
  8022e3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e6:	8b 00                	mov    (%eax),%eax
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	75 08                	jne    8022f4 <alloc_block_FF+0x269>
  8022ec:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022ef:	a3 30 50 80 00       	mov    %eax,0x805030
  8022f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8022f9:	40                   	inc    %eax
  8022fa:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8022ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802303:	75 17                	jne    80231c <alloc_block_FF+0x291>
  802305:	83 ec 04             	sub    $0x4,%esp
  802308:	68 93 42 80 00       	push   $0x804293
  80230d:	68 e1 00 00 00       	push   $0xe1
  802312:	68 b1 42 80 00       	push   $0x8042b1
  802317:	e8 fb 14 00 00       	call   803817 <_panic>
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	85 c0                	test   %eax,%eax
  802323:	74 10                	je     802335 <alloc_block_FF+0x2aa>
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232d:	8b 52 04             	mov    0x4(%edx),%edx
  802330:	89 50 04             	mov    %edx,0x4(%eax)
  802333:	eb 0b                	jmp    802340 <alloc_block_FF+0x2b5>
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 40 04             	mov    0x4(%eax),%eax
  80233b:	a3 30 50 80 00       	mov    %eax,0x805030
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 40 04             	mov    0x4(%eax),%eax
  802346:	85 c0                	test   %eax,%eax
  802348:	74 0f                	je     802359 <alloc_block_FF+0x2ce>
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	8b 40 04             	mov    0x4(%eax),%eax
  802350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802353:	8b 12                	mov    (%edx),%edx
  802355:	89 10                	mov    %edx,(%eax)
  802357:	eb 0a                	jmp    802363 <alloc_block_FF+0x2d8>
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802376:	a1 38 50 80 00       	mov    0x805038,%eax
  80237b:	48                   	dec    %eax
  80237c:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802381:	83 ec 04             	sub    $0x4,%esp
  802384:	6a 00                	push   $0x0
  802386:	ff 75 b4             	pushl  -0x4c(%ebp)
  802389:	ff 75 b0             	pushl  -0x50(%ebp)
  80238c:	e8 cb fc ff ff       	call   80205c <set_block_data>
  802391:	83 c4 10             	add    $0x10,%esp
  802394:	e9 95 00 00 00       	jmp    80242e <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802399:	83 ec 04             	sub    $0x4,%esp
  80239c:	6a 01                	push   $0x1
  80239e:	ff 75 b8             	pushl  -0x48(%ebp)
  8023a1:	ff 75 bc             	pushl  -0x44(%ebp)
  8023a4:	e8 b3 fc ff ff       	call   80205c <set_block_data>
  8023a9:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8023ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b0:	75 17                	jne    8023c9 <alloc_block_FF+0x33e>
  8023b2:	83 ec 04             	sub    $0x4,%esp
  8023b5:	68 93 42 80 00       	push   $0x804293
  8023ba:	68 e8 00 00 00       	push   $0xe8
  8023bf:	68 b1 42 80 00       	push   $0x8042b1
  8023c4:	e8 4e 14 00 00       	call   803817 <_panic>
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	74 10                	je     8023e2 <alloc_block_FF+0x357>
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 00                	mov    (%eax),%eax
  8023d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023da:	8b 52 04             	mov    0x4(%edx),%edx
  8023dd:	89 50 04             	mov    %edx,0x4(%eax)
  8023e0:	eb 0b                	jmp    8023ed <alloc_block_FF+0x362>
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 40 04             	mov    0x4(%eax),%eax
  8023e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 40 04             	mov    0x4(%eax),%eax
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	74 0f                	je     802406 <alloc_block_FF+0x37b>
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 40 04             	mov    0x4(%eax),%eax
  8023fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802400:	8b 12                	mov    (%edx),%edx
  802402:	89 10                	mov    %edx,(%eax)
  802404:	eb 0a                	jmp    802410 <alloc_block_FF+0x385>
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802423:	a1 38 50 80 00       	mov    0x805038,%eax
  802428:	48                   	dec    %eax
  802429:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80242e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802431:	e9 0f 01 00 00       	jmp    802545 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802436:	a1 34 50 80 00       	mov    0x805034,%eax
  80243b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802442:	74 07                	je     80244b <alloc_block_FF+0x3c0>
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	eb 05                	jmp    802450 <alloc_block_FF+0x3c5>
  80244b:	b8 00 00 00 00       	mov    $0x0,%eax
  802450:	a3 34 50 80 00       	mov    %eax,0x805034
  802455:	a1 34 50 80 00       	mov    0x805034,%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	0f 85 e9 fc ff ff    	jne    80214b <alloc_block_FF+0xc0>
  802462:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802466:	0f 85 df fc ff ff    	jne    80214b <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	83 c0 08             	add    $0x8,%eax
  802472:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802475:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80247c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80247f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802482:	01 d0                	add    %edx,%eax
  802484:	48                   	dec    %eax
  802485:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802488:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80248b:	ba 00 00 00 00       	mov    $0x0,%edx
  802490:	f7 75 d8             	divl   -0x28(%ebp)
  802493:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802496:	29 d0                	sub    %edx,%eax
  802498:	c1 e8 0c             	shr    $0xc,%eax
  80249b:	83 ec 0c             	sub    $0xc,%esp
  80249e:	50                   	push   %eax
  80249f:	e8 f9 ec ff ff       	call   80119d <sbrk>
  8024a4:	83 c4 10             	add    $0x10,%esp
  8024a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8024aa:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8024ae:	75 0a                	jne    8024ba <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8024b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b5:	e9 8b 00 00 00       	jmp    802545 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8024ba:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8024c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024c7:	01 d0                	add    %edx,%eax
  8024c9:	48                   	dec    %eax
  8024ca:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8024cd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8024d5:	f7 75 cc             	divl   -0x34(%ebp)
  8024d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024db:	29 d0                	sub    %edx,%eax
  8024dd:	8d 50 fc             	lea    -0x4(%eax),%edx
  8024e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024e3:	01 d0                	add    %edx,%eax
  8024e5:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8024ea:	a1 40 50 80 00       	mov    0x805040,%eax
  8024ef:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8024f5:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8024fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024ff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802502:	01 d0                	add    %edx,%eax
  802504:	48                   	dec    %eax
  802505:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802508:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80250b:	ba 00 00 00 00       	mov    $0x0,%edx
  802510:	f7 75 c4             	divl   -0x3c(%ebp)
  802513:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802516:	29 d0                	sub    %edx,%eax
  802518:	83 ec 04             	sub    $0x4,%esp
  80251b:	6a 01                	push   $0x1
  80251d:	50                   	push   %eax
  80251e:	ff 75 d0             	pushl  -0x30(%ebp)
  802521:	e8 36 fb ff ff       	call   80205c <set_block_data>
  802526:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802529:	83 ec 0c             	sub    $0xc,%esp
  80252c:	ff 75 d0             	pushl  -0x30(%ebp)
  80252f:	e8 1b 0a 00 00       	call   802f4f <free_block>
  802534:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802537:	83 ec 0c             	sub    $0xc,%esp
  80253a:	ff 75 08             	pushl  0x8(%ebp)
  80253d:	e8 49 fb ff ff       	call   80208b <alloc_block_FF>
  802542:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	83 e0 01             	and    $0x1,%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	74 03                	je     80255a <alloc_block_BF+0x13>
  802557:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80255a:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80255e:	77 07                	ja     802567 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802560:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802567:	a1 24 50 80 00       	mov    0x805024,%eax
  80256c:	85 c0                	test   %eax,%eax
  80256e:	75 73                	jne    8025e3 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802570:	8b 45 08             	mov    0x8(%ebp),%eax
  802573:	83 c0 10             	add    $0x10,%eax
  802576:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802579:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802580:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802586:	01 d0                	add    %edx,%eax
  802588:	48                   	dec    %eax
  802589:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80258c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80258f:	ba 00 00 00 00       	mov    $0x0,%edx
  802594:	f7 75 e0             	divl   -0x20(%ebp)
  802597:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80259a:	29 d0                	sub    %edx,%eax
  80259c:	c1 e8 0c             	shr    $0xc,%eax
  80259f:	83 ec 0c             	sub    $0xc,%esp
  8025a2:	50                   	push   %eax
  8025a3:	e8 f5 eb ff ff       	call   80119d <sbrk>
  8025a8:	83 c4 10             	add    $0x10,%esp
  8025ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8025ae:	83 ec 0c             	sub    $0xc,%esp
  8025b1:	6a 00                	push   $0x0
  8025b3:	e8 e5 eb ff ff       	call   80119d <sbrk>
  8025b8:	83 c4 10             	add    $0x10,%esp
  8025bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8025be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025c1:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8025c4:	83 ec 08             	sub    $0x8,%esp
  8025c7:	50                   	push   %eax
  8025c8:	ff 75 d8             	pushl  -0x28(%ebp)
  8025cb:	e8 9f f8 ff ff       	call   801e6f <initialize_dynamic_allocator>
  8025d0:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025d3:	83 ec 0c             	sub    $0xc,%esp
  8025d6:	68 ef 42 80 00       	push   $0x8042ef
  8025db:	e8 23 de ff ff       	call   800403 <cprintf>
  8025e0:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8025e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8025ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8025f1:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8025f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8025ff:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802604:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802607:	e9 1d 01 00 00       	jmp    802729 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802612:	83 ec 0c             	sub    $0xc,%esp
  802615:	ff 75 a8             	pushl  -0x58(%ebp)
  802618:	e8 ee f6 ff ff       	call   801d0b <get_block_size>
  80261d:	83 c4 10             	add    $0x10,%esp
  802620:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802623:	8b 45 08             	mov    0x8(%ebp),%eax
  802626:	83 c0 08             	add    $0x8,%eax
  802629:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80262c:	0f 87 ef 00 00 00    	ja     802721 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	83 c0 18             	add    $0x18,%eax
  802638:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80263b:	77 1d                	ja     80265a <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80263d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802640:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802643:	0f 86 d8 00 00 00    	jbe    802721 <alloc_block_BF+0x1da>
				{
					best_va = va;
  802649:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80264c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80264f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802652:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802655:	e9 c7 00 00 00       	jmp    802721 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  80265a:	8b 45 08             	mov    0x8(%ebp),%eax
  80265d:	83 c0 08             	add    $0x8,%eax
  802660:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802663:	0f 85 9d 00 00 00    	jne    802706 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802669:	83 ec 04             	sub    $0x4,%esp
  80266c:	6a 01                	push   $0x1
  80266e:	ff 75 a4             	pushl  -0x5c(%ebp)
  802671:	ff 75 a8             	pushl  -0x58(%ebp)
  802674:	e8 e3 f9 ff ff       	call   80205c <set_block_data>
  802679:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80267c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802680:	75 17                	jne    802699 <alloc_block_BF+0x152>
  802682:	83 ec 04             	sub    $0x4,%esp
  802685:	68 93 42 80 00       	push   $0x804293
  80268a:	68 2c 01 00 00       	push   $0x12c
  80268f:	68 b1 42 80 00       	push   $0x8042b1
  802694:	e8 7e 11 00 00       	call   803817 <_panic>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 10                	je     8026b2 <alloc_block_BF+0x16b>
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 00                	mov    (%eax),%eax
  8026a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026aa:	8b 52 04             	mov    0x4(%edx),%edx
  8026ad:	89 50 04             	mov    %edx,0x4(%eax)
  8026b0:	eb 0b                	jmp    8026bd <alloc_block_BF+0x176>
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 04             	mov    0x4(%eax),%eax
  8026b8:	a3 30 50 80 00       	mov    %eax,0x805030
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 40 04             	mov    0x4(%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	74 0f                	je     8026d6 <alloc_block_BF+0x18f>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d0:	8b 12                	mov    (%edx),%edx
  8026d2:	89 10                	mov    %edx,(%eax)
  8026d4:	eb 0a                	jmp    8026e0 <alloc_block_BF+0x199>
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 00                	mov    (%eax),%eax
  8026db:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f3:	a1 38 50 80 00       	mov    0x805038,%eax
  8026f8:	48                   	dec    %eax
  8026f9:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8026fe:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802701:	e9 24 04 00 00       	jmp    802b2a <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802706:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802709:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80270c:	76 13                	jbe    802721 <alloc_block_BF+0x1da>
					{
						internal = 1;
  80270e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802715:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802718:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80271b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80271e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  802721:	a1 34 50 80 00       	mov    0x805034,%eax
  802726:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272d:	74 07                	je     802736 <alloc_block_BF+0x1ef>
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 00                	mov    (%eax),%eax
  802734:	eb 05                	jmp    80273b <alloc_block_BF+0x1f4>
  802736:	b8 00 00 00 00       	mov    $0x0,%eax
  80273b:	a3 34 50 80 00       	mov    %eax,0x805034
  802740:	a1 34 50 80 00       	mov    0x805034,%eax
  802745:	85 c0                	test   %eax,%eax
  802747:	0f 85 bf fe ff ff    	jne    80260c <alloc_block_BF+0xc5>
  80274d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802751:	0f 85 b5 fe ff ff    	jne    80260c <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802757:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80275b:	0f 84 26 02 00 00    	je     802987 <alloc_block_BF+0x440>
  802761:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802765:	0f 85 1c 02 00 00    	jne    802987 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  80276b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276e:	2b 45 08             	sub    0x8(%ebp),%eax
  802771:	83 e8 08             	sub    $0x8,%eax
  802774:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	8d 50 08             	lea    0x8(%eax),%edx
  80277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802780:	01 d0                	add    %edx,%eax
  802782:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802785:	8b 45 08             	mov    0x8(%ebp),%eax
  802788:	83 c0 08             	add    $0x8,%eax
  80278b:	83 ec 04             	sub    $0x4,%esp
  80278e:	6a 01                	push   $0x1
  802790:	50                   	push   %eax
  802791:	ff 75 f0             	pushl  -0x10(%ebp)
  802794:	e8 c3 f8 ff ff       	call   80205c <set_block_data>
  802799:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80279c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279f:	8b 40 04             	mov    0x4(%eax),%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	75 68                	jne    80280e <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027a6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027aa:	75 17                	jne    8027c3 <alloc_block_BF+0x27c>
  8027ac:	83 ec 04             	sub    $0x4,%esp
  8027af:	68 cc 42 80 00       	push   $0x8042cc
  8027b4:	68 45 01 00 00       	push   $0x145
  8027b9:	68 b1 42 80 00       	push   $0x8042b1
  8027be:	e8 54 10 00 00       	call   803817 <_panic>
  8027c3:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8027c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027cc:	89 10                	mov    %edx,(%eax)
  8027ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d1:	8b 00                	mov    (%eax),%eax
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	74 0d                	je     8027e4 <alloc_block_BF+0x29d>
  8027d7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027dc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027df:	89 50 04             	mov    %edx,0x4(%eax)
  8027e2:	eb 08                	jmp    8027ec <alloc_block_BF+0x2a5>
  8027e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e7:	a3 30 50 80 00       	mov    %eax,0x805030
  8027ec:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ef:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027fe:	a1 38 50 80 00       	mov    0x805038,%eax
  802803:	40                   	inc    %eax
  802804:	a3 38 50 80 00       	mov    %eax,0x805038
  802809:	e9 dc 00 00 00       	jmp    8028ea <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  80280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	75 65                	jne    80287c <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802817:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80281b:	75 17                	jne    802834 <alloc_block_BF+0x2ed>
  80281d:	83 ec 04             	sub    $0x4,%esp
  802820:	68 00 43 80 00       	push   $0x804300
  802825:	68 4a 01 00 00       	push   $0x14a
  80282a:	68 b1 42 80 00       	push   $0x8042b1
  80282f:	e8 e3 0f 00 00       	call   803817 <_panic>
  802834:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80283a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283d:	89 50 04             	mov    %edx,0x4(%eax)
  802840:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802843:	8b 40 04             	mov    0x4(%eax),%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	74 0c                	je     802856 <alloc_block_BF+0x30f>
  80284a:	a1 30 50 80 00       	mov    0x805030,%eax
  80284f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802852:	89 10                	mov    %edx,(%eax)
  802854:	eb 08                	jmp    80285e <alloc_block_BF+0x317>
  802856:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802859:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80285e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802861:	a3 30 50 80 00       	mov    %eax,0x805030
  802866:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286f:	a1 38 50 80 00       	mov    0x805038,%eax
  802874:	40                   	inc    %eax
  802875:	a3 38 50 80 00       	mov    %eax,0x805038
  80287a:	eb 6e                	jmp    8028ea <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80287c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802880:	74 06                	je     802888 <alloc_block_BF+0x341>
  802882:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802886:	75 17                	jne    80289f <alloc_block_BF+0x358>
  802888:	83 ec 04             	sub    $0x4,%esp
  80288b:	68 24 43 80 00       	push   $0x804324
  802890:	68 4f 01 00 00       	push   $0x14f
  802895:	68 b1 42 80 00       	push   $0x8042b1
  80289a:	e8 78 0f 00 00       	call   803817 <_panic>
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	8b 10                	mov    (%eax),%edx
  8028a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a7:	89 10                	mov    %edx,(%eax)
  8028a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	74 0b                	je     8028bd <alloc_block_BF+0x376>
  8028b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028ba:	89 50 04             	mov    %edx,0x4(%eax)
  8028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028c3:	89 10                	mov    %edx,(%eax)
  8028c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cb:	89 50 04             	mov    %edx,0x4(%eax)
  8028ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d1:	8b 00                	mov    (%eax),%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	75 08                	jne    8028df <alloc_block_BF+0x398>
  8028d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028da:	a3 30 50 80 00       	mov    %eax,0x805030
  8028df:	a1 38 50 80 00       	mov    0x805038,%eax
  8028e4:	40                   	inc    %eax
  8028e5:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8028ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ee:	75 17                	jne    802907 <alloc_block_BF+0x3c0>
  8028f0:	83 ec 04             	sub    $0x4,%esp
  8028f3:	68 93 42 80 00       	push   $0x804293
  8028f8:	68 51 01 00 00       	push   $0x151
  8028fd:	68 b1 42 80 00       	push   $0x8042b1
  802902:	e8 10 0f 00 00       	call   803817 <_panic>
  802907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290a:	8b 00                	mov    (%eax),%eax
  80290c:	85 c0                	test   %eax,%eax
  80290e:	74 10                	je     802920 <alloc_block_BF+0x3d9>
  802910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802913:	8b 00                	mov    (%eax),%eax
  802915:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802918:	8b 52 04             	mov    0x4(%edx),%edx
  80291b:	89 50 04             	mov    %edx,0x4(%eax)
  80291e:	eb 0b                	jmp    80292b <alloc_block_BF+0x3e4>
  802920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802923:	8b 40 04             	mov    0x4(%eax),%eax
  802926:	a3 30 50 80 00       	mov    %eax,0x805030
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	8b 40 04             	mov    0x4(%eax),%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	74 0f                	je     802944 <alloc_block_BF+0x3fd>
  802935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802938:	8b 40 04             	mov    0x4(%eax),%eax
  80293b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293e:	8b 12                	mov    (%edx),%edx
  802940:	89 10                	mov    %edx,(%eax)
  802942:	eb 0a                	jmp    80294e <alloc_block_BF+0x407>
  802944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802947:	8b 00                	mov    (%eax),%eax
  802949:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80294e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802951:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802961:	a1 38 50 80 00       	mov    0x805038,%eax
  802966:	48                   	dec    %eax
  802967:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  80296c:	83 ec 04             	sub    $0x4,%esp
  80296f:	6a 00                	push   $0x0
  802971:	ff 75 d0             	pushl  -0x30(%ebp)
  802974:	ff 75 cc             	pushl  -0x34(%ebp)
  802977:	e8 e0 f6 ff ff       	call   80205c <set_block_data>
  80297c:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80297f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802982:	e9 a3 01 00 00       	jmp    802b2a <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802987:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80298b:	0f 85 9d 00 00 00    	jne    802a2e <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802991:	83 ec 04             	sub    $0x4,%esp
  802994:	6a 01                	push   $0x1
  802996:	ff 75 ec             	pushl  -0x14(%ebp)
  802999:	ff 75 f0             	pushl  -0x10(%ebp)
  80299c:	e8 bb f6 ff ff       	call   80205c <set_block_data>
  8029a1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8029a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029a8:	75 17                	jne    8029c1 <alloc_block_BF+0x47a>
  8029aa:	83 ec 04             	sub    $0x4,%esp
  8029ad:	68 93 42 80 00       	push   $0x804293
  8029b2:	68 58 01 00 00       	push   $0x158
  8029b7:	68 b1 42 80 00       	push   $0x8042b1
  8029bc:	e8 56 0e 00 00       	call   803817 <_panic>
  8029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c4:	8b 00                	mov    (%eax),%eax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	74 10                	je     8029da <alloc_block_BF+0x493>
  8029ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d2:	8b 52 04             	mov    0x4(%edx),%edx
  8029d5:	89 50 04             	mov    %edx,0x4(%eax)
  8029d8:	eb 0b                	jmp    8029e5 <alloc_block_BF+0x49e>
  8029da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dd:	8b 40 04             	mov    0x4(%eax),%eax
  8029e0:	a3 30 50 80 00       	mov    %eax,0x805030
  8029e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e8:	8b 40 04             	mov    0x4(%eax),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	74 0f                	je     8029fe <alloc_block_BF+0x4b7>
  8029ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f2:	8b 40 04             	mov    0x4(%eax),%eax
  8029f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f8:	8b 12                	mov    (%edx),%edx
  8029fa:	89 10                	mov    %edx,(%eax)
  8029fc:	eb 0a                	jmp    802a08 <alloc_block_BF+0x4c1>
  8029fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a01:	8b 00                	mov    (%eax),%eax
  802a03:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1b:	a1 38 50 80 00       	mov    0x805038,%eax
  802a20:	48                   	dec    %eax
  802a21:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a29:	e9 fc 00 00 00       	jmp    802b2a <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	83 c0 08             	add    $0x8,%eax
  802a34:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a37:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802a3e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a41:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a44:	01 d0                	add    %edx,%eax
  802a46:	48                   	dec    %eax
  802a47:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802a4a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  802a52:	f7 75 c4             	divl   -0x3c(%ebp)
  802a55:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a58:	29 d0                	sub    %edx,%eax
  802a5a:	c1 e8 0c             	shr    $0xc,%eax
  802a5d:	83 ec 0c             	sub    $0xc,%esp
  802a60:	50                   	push   %eax
  802a61:	e8 37 e7 ff ff       	call   80119d <sbrk>
  802a66:	83 c4 10             	add    $0x10,%esp
  802a69:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802a6c:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802a70:	75 0a                	jne    802a7c <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802a72:	b8 00 00 00 00       	mov    $0x0,%eax
  802a77:	e9 ae 00 00 00       	jmp    802b2a <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a7c:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802a83:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a86:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a89:	01 d0                	add    %edx,%eax
  802a8b:	48                   	dec    %eax
  802a8c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802a8f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a92:	ba 00 00 00 00       	mov    $0x0,%edx
  802a97:	f7 75 b8             	divl   -0x48(%ebp)
  802a9a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a9d:	29 d0                	sub    %edx,%eax
  802a9f:	8d 50 fc             	lea    -0x4(%eax),%edx
  802aa2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802aa5:	01 d0                	add    %edx,%eax
  802aa7:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802aac:	a1 40 50 80 00       	mov    0x805040,%eax
  802ab1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802ab7:	83 ec 0c             	sub    $0xc,%esp
  802aba:	68 58 43 80 00       	push   $0x804358
  802abf:	e8 3f d9 ff ff       	call   800403 <cprintf>
  802ac4:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802ac7:	83 ec 08             	sub    $0x8,%esp
  802aca:	ff 75 bc             	pushl  -0x44(%ebp)
  802acd:	68 5d 43 80 00       	push   $0x80435d
  802ad2:	e8 2c d9 ff ff       	call   800403 <cprintf>
  802ad7:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ada:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802ae1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ae4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ae7:	01 d0                	add    %edx,%eax
  802ae9:	48                   	dec    %eax
  802aea:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802aed:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802af0:	ba 00 00 00 00       	mov    $0x0,%edx
  802af5:	f7 75 b0             	divl   -0x50(%ebp)
  802af8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802afb:	29 d0                	sub    %edx,%eax
  802afd:	83 ec 04             	sub    $0x4,%esp
  802b00:	6a 01                	push   $0x1
  802b02:	50                   	push   %eax
  802b03:	ff 75 bc             	pushl  -0x44(%ebp)
  802b06:	e8 51 f5 ff ff       	call   80205c <set_block_data>
  802b0b:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b0e:	83 ec 0c             	sub    $0xc,%esp
  802b11:	ff 75 bc             	pushl  -0x44(%ebp)
  802b14:	e8 36 04 00 00       	call   802f4f <free_block>
  802b19:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802b1c:	83 ec 0c             	sub    $0xc,%esp
  802b1f:	ff 75 08             	pushl  0x8(%ebp)
  802b22:	e8 20 fa ff ff       	call   802547 <alloc_block_BF>
  802b27:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802b2a:	c9                   	leave  
  802b2b:	c3                   	ret    

00802b2c <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802b2c:	55                   	push   %ebp
  802b2d:	89 e5                	mov    %esp,%ebp
  802b2f:	53                   	push   %ebx
  802b30:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802b33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802b41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b45:	74 1e                	je     802b65 <merging+0x39>
  802b47:	ff 75 08             	pushl  0x8(%ebp)
  802b4a:	e8 bc f1 ff ff       	call   801d0b <get_block_size>
  802b4f:	83 c4 04             	add    $0x4,%esp
  802b52:	89 c2                	mov    %eax,%edx
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	01 d0                	add    %edx,%eax
  802b59:	3b 45 10             	cmp    0x10(%ebp),%eax
  802b5c:	75 07                	jne    802b65 <merging+0x39>
		prev_is_free = 1;
  802b5e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802b65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b69:	74 1e                	je     802b89 <merging+0x5d>
  802b6b:	ff 75 10             	pushl  0x10(%ebp)
  802b6e:	e8 98 f1 ff ff       	call   801d0b <get_block_size>
  802b73:	83 c4 04             	add    $0x4,%esp
  802b76:	89 c2                	mov    %eax,%edx
  802b78:	8b 45 10             	mov    0x10(%ebp),%eax
  802b7b:	01 d0                	add    %edx,%eax
  802b7d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b80:	75 07                	jne    802b89 <merging+0x5d>
		next_is_free = 1;
  802b82:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8d:	0f 84 cc 00 00 00    	je     802c5f <merging+0x133>
  802b93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b97:	0f 84 c2 00 00 00    	je     802c5f <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802b9d:	ff 75 08             	pushl  0x8(%ebp)
  802ba0:	e8 66 f1 ff ff       	call   801d0b <get_block_size>
  802ba5:	83 c4 04             	add    $0x4,%esp
  802ba8:	89 c3                	mov    %eax,%ebx
  802baa:	ff 75 10             	pushl  0x10(%ebp)
  802bad:	e8 59 f1 ff ff       	call   801d0b <get_block_size>
  802bb2:	83 c4 04             	add    $0x4,%esp
  802bb5:	01 c3                	add    %eax,%ebx
  802bb7:	ff 75 0c             	pushl  0xc(%ebp)
  802bba:	e8 4c f1 ff ff       	call   801d0b <get_block_size>
  802bbf:	83 c4 04             	add    $0x4,%esp
  802bc2:	01 d8                	add    %ebx,%eax
  802bc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802bc7:	6a 00                	push   $0x0
  802bc9:	ff 75 ec             	pushl  -0x14(%ebp)
  802bcc:	ff 75 08             	pushl  0x8(%ebp)
  802bcf:	e8 88 f4 ff ff       	call   80205c <set_block_data>
  802bd4:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802bd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bdb:	75 17                	jne    802bf4 <merging+0xc8>
  802bdd:	83 ec 04             	sub    $0x4,%esp
  802be0:	68 93 42 80 00       	push   $0x804293
  802be5:	68 7d 01 00 00       	push   $0x17d
  802bea:	68 b1 42 80 00       	push   $0x8042b1
  802bef:	e8 23 0c 00 00       	call   803817 <_panic>
  802bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	74 10                	je     802c0d <merging+0xe1>
  802bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c05:	8b 52 04             	mov    0x4(%edx),%edx
  802c08:	89 50 04             	mov    %edx,0x4(%eax)
  802c0b:	eb 0b                	jmp    802c18 <merging+0xec>
  802c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c10:	8b 40 04             	mov    0x4(%eax),%eax
  802c13:	a3 30 50 80 00       	mov    %eax,0x805030
  802c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c1b:	8b 40 04             	mov    0x4(%eax),%eax
  802c1e:	85 c0                	test   %eax,%eax
  802c20:	74 0f                	je     802c31 <merging+0x105>
  802c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c25:	8b 40 04             	mov    0x4(%eax),%eax
  802c28:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c2b:	8b 12                	mov    (%edx),%edx
  802c2d:	89 10                	mov    %edx,(%eax)
  802c2f:	eb 0a                	jmp    802c3b <merging+0x10f>
  802c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4e:	a1 38 50 80 00       	mov    0x805038,%eax
  802c53:	48                   	dec    %eax
  802c54:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802c59:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c5a:	e9 ea 02 00 00       	jmp    802f49 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c63:	74 3b                	je     802ca0 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802c65:	83 ec 0c             	sub    $0xc,%esp
  802c68:	ff 75 08             	pushl  0x8(%ebp)
  802c6b:	e8 9b f0 ff ff       	call   801d0b <get_block_size>
  802c70:	83 c4 10             	add    $0x10,%esp
  802c73:	89 c3                	mov    %eax,%ebx
  802c75:	83 ec 0c             	sub    $0xc,%esp
  802c78:	ff 75 10             	pushl  0x10(%ebp)
  802c7b:	e8 8b f0 ff ff       	call   801d0b <get_block_size>
  802c80:	83 c4 10             	add    $0x10,%esp
  802c83:	01 d8                	add    %ebx,%eax
  802c85:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c88:	83 ec 04             	sub    $0x4,%esp
  802c8b:	6a 00                	push   $0x0
  802c8d:	ff 75 e8             	pushl  -0x18(%ebp)
  802c90:	ff 75 08             	pushl  0x8(%ebp)
  802c93:	e8 c4 f3 ff ff       	call   80205c <set_block_data>
  802c98:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c9b:	e9 a9 02 00 00       	jmp    802f49 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802ca0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca4:	0f 84 2d 01 00 00    	je     802dd7 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802caa:	83 ec 0c             	sub    $0xc,%esp
  802cad:	ff 75 10             	pushl  0x10(%ebp)
  802cb0:	e8 56 f0 ff ff       	call   801d0b <get_block_size>
  802cb5:	83 c4 10             	add    $0x10,%esp
  802cb8:	89 c3                	mov    %eax,%ebx
  802cba:	83 ec 0c             	sub    $0xc,%esp
  802cbd:	ff 75 0c             	pushl  0xc(%ebp)
  802cc0:	e8 46 f0 ff ff       	call   801d0b <get_block_size>
  802cc5:	83 c4 10             	add    $0x10,%esp
  802cc8:	01 d8                	add    %ebx,%eax
  802cca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802ccd:	83 ec 04             	sub    $0x4,%esp
  802cd0:	6a 00                	push   $0x0
  802cd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  802cd5:	ff 75 10             	pushl  0x10(%ebp)
  802cd8:	e8 7f f3 ff ff       	call   80205c <set_block_data>
  802cdd:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  802ce3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802ce6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cea:	74 06                	je     802cf2 <merging+0x1c6>
  802cec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802cf0:	75 17                	jne    802d09 <merging+0x1dd>
  802cf2:	83 ec 04             	sub    $0x4,%esp
  802cf5:	68 6c 43 80 00       	push   $0x80436c
  802cfa:	68 8d 01 00 00       	push   $0x18d
  802cff:	68 b1 42 80 00       	push   $0x8042b1
  802d04:	e8 0e 0b 00 00       	call   803817 <_panic>
  802d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0c:	8b 50 04             	mov    0x4(%eax),%edx
  802d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d12:	89 50 04             	mov    %edx,0x4(%eax)
  802d15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d1b:	89 10                	mov    %edx,(%eax)
  802d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d20:	8b 40 04             	mov    0x4(%eax),%eax
  802d23:	85 c0                	test   %eax,%eax
  802d25:	74 0d                	je     802d34 <merging+0x208>
  802d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2a:	8b 40 04             	mov    0x4(%eax),%eax
  802d2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d30:	89 10                	mov    %edx,(%eax)
  802d32:	eb 08                	jmp    802d3c <merging+0x210>
  802d34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d37:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d42:	89 50 04             	mov    %edx,0x4(%eax)
  802d45:	a1 38 50 80 00       	mov    0x805038,%eax
  802d4a:	40                   	inc    %eax
  802d4b:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802d50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d54:	75 17                	jne    802d6d <merging+0x241>
  802d56:	83 ec 04             	sub    $0x4,%esp
  802d59:	68 93 42 80 00       	push   $0x804293
  802d5e:	68 8e 01 00 00       	push   $0x18e
  802d63:	68 b1 42 80 00       	push   $0x8042b1
  802d68:	e8 aa 0a 00 00       	call   803817 <_panic>
  802d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	85 c0                	test   %eax,%eax
  802d74:	74 10                	je     802d86 <merging+0x25a>
  802d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d7e:	8b 52 04             	mov    0x4(%edx),%edx
  802d81:	89 50 04             	mov    %edx,0x4(%eax)
  802d84:	eb 0b                	jmp    802d91 <merging+0x265>
  802d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d89:	8b 40 04             	mov    0x4(%eax),%eax
  802d8c:	a3 30 50 80 00       	mov    %eax,0x805030
  802d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d94:	8b 40 04             	mov    0x4(%eax),%eax
  802d97:	85 c0                	test   %eax,%eax
  802d99:	74 0f                	je     802daa <merging+0x27e>
  802d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9e:	8b 40 04             	mov    0x4(%eax),%eax
  802da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802da4:	8b 12                	mov    (%edx),%edx
  802da6:	89 10                	mov    %edx,(%eax)
  802da8:	eb 0a                	jmp    802db4 <merging+0x288>
  802daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802db7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc7:	a1 38 50 80 00       	mov    0x805038,%eax
  802dcc:	48                   	dec    %eax
  802dcd:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802dd2:	e9 72 01 00 00       	jmp    802f49 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802dd7:	8b 45 10             	mov    0x10(%ebp),%eax
  802dda:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802ddd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de1:	74 79                	je     802e5c <merging+0x330>
  802de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802de7:	74 73                	je     802e5c <merging+0x330>
  802de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ded:	74 06                	je     802df5 <merging+0x2c9>
  802def:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802df3:	75 17                	jne    802e0c <merging+0x2e0>
  802df5:	83 ec 04             	sub    $0x4,%esp
  802df8:	68 24 43 80 00       	push   $0x804324
  802dfd:	68 94 01 00 00       	push   $0x194
  802e02:	68 b1 42 80 00       	push   $0x8042b1
  802e07:	e8 0b 0a 00 00       	call   803817 <_panic>
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	8b 10                	mov    (%eax),%edx
  802e11:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e14:	89 10                	mov    %edx,(%eax)
  802e16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e19:	8b 00                	mov    (%eax),%eax
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	74 0b                	je     802e2a <merging+0x2fe>
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	8b 00                	mov    (%eax),%eax
  802e24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e27:	89 50 04             	mov    %edx,0x4(%eax)
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e30:	89 10                	mov    %edx,(%eax)
  802e32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e35:	8b 55 08             	mov    0x8(%ebp),%edx
  802e38:	89 50 04             	mov    %edx,0x4(%eax)
  802e3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e3e:	8b 00                	mov    (%eax),%eax
  802e40:	85 c0                	test   %eax,%eax
  802e42:	75 08                	jne    802e4c <merging+0x320>
  802e44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e47:	a3 30 50 80 00       	mov    %eax,0x805030
  802e4c:	a1 38 50 80 00       	mov    0x805038,%eax
  802e51:	40                   	inc    %eax
  802e52:	a3 38 50 80 00       	mov    %eax,0x805038
  802e57:	e9 ce 00 00 00       	jmp    802f2a <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802e5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e60:	74 65                	je     802ec7 <merging+0x39b>
  802e62:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e66:	75 17                	jne    802e7f <merging+0x353>
  802e68:	83 ec 04             	sub    $0x4,%esp
  802e6b:	68 00 43 80 00       	push   $0x804300
  802e70:	68 95 01 00 00       	push   $0x195
  802e75:	68 b1 42 80 00       	push   $0x8042b1
  802e7a:	e8 98 09 00 00       	call   803817 <_panic>
  802e7f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e85:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e88:	89 50 04             	mov    %edx,0x4(%eax)
  802e8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e8e:	8b 40 04             	mov    0x4(%eax),%eax
  802e91:	85 c0                	test   %eax,%eax
  802e93:	74 0c                	je     802ea1 <merging+0x375>
  802e95:	a1 30 50 80 00       	mov    0x805030,%eax
  802e9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e9d:	89 10                	mov    %edx,(%eax)
  802e9f:	eb 08                	jmp    802ea9 <merging+0x37d>
  802ea1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea4:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ea9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eac:	a3 30 50 80 00       	mov    %eax,0x805030
  802eb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eba:	a1 38 50 80 00       	mov    0x805038,%eax
  802ebf:	40                   	inc    %eax
  802ec0:	a3 38 50 80 00       	mov    %eax,0x805038
  802ec5:	eb 63                	jmp    802f2a <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802ec7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ecb:	75 17                	jne    802ee4 <merging+0x3b8>
  802ecd:	83 ec 04             	sub    $0x4,%esp
  802ed0:	68 cc 42 80 00       	push   $0x8042cc
  802ed5:	68 98 01 00 00       	push   $0x198
  802eda:	68 b1 42 80 00       	push   $0x8042b1
  802edf:	e8 33 09 00 00       	call   803817 <_panic>
  802ee4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802eea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eed:	89 10                	mov    %edx,(%eax)
  802eef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef2:	8b 00                	mov    (%eax),%eax
  802ef4:	85 c0                	test   %eax,%eax
  802ef6:	74 0d                	je     802f05 <merging+0x3d9>
  802ef8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802efd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f00:	89 50 04             	mov    %edx,0x4(%eax)
  802f03:	eb 08                	jmp    802f0d <merging+0x3e1>
  802f05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f08:	a3 30 50 80 00       	mov    %eax,0x805030
  802f0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f10:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1f:	a1 38 50 80 00       	mov    0x805038,%eax
  802f24:	40                   	inc    %eax
  802f25:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802f2a:	83 ec 0c             	sub    $0xc,%esp
  802f2d:	ff 75 10             	pushl  0x10(%ebp)
  802f30:	e8 d6 ed ff ff       	call   801d0b <get_block_size>
  802f35:	83 c4 10             	add    $0x10,%esp
  802f38:	83 ec 04             	sub    $0x4,%esp
  802f3b:	6a 00                	push   $0x0
  802f3d:	50                   	push   %eax
  802f3e:	ff 75 10             	pushl  0x10(%ebp)
  802f41:	e8 16 f1 ff ff       	call   80205c <set_block_data>
  802f46:	83 c4 10             	add    $0x10,%esp
	}
}
  802f49:	90                   	nop
  802f4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f4d:	c9                   	leave  
  802f4e:	c3                   	ret    

00802f4f <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802f4f:	55                   	push   %ebp
  802f50:	89 e5                	mov    %esp,%ebp
  802f52:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802f55:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f5a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802f5d:	a1 30 50 80 00       	mov    0x805030,%eax
  802f62:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f65:	73 1b                	jae    802f82 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802f67:	a1 30 50 80 00       	mov    0x805030,%eax
  802f6c:	83 ec 04             	sub    $0x4,%esp
  802f6f:	ff 75 08             	pushl  0x8(%ebp)
  802f72:	6a 00                	push   $0x0
  802f74:	50                   	push   %eax
  802f75:	e8 b2 fb ff ff       	call   802b2c <merging>
  802f7a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f7d:	e9 8b 00 00 00       	jmp    80300d <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802f82:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f8a:	76 18                	jbe    802fa4 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802f8c:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f91:	83 ec 04             	sub    $0x4,%esp
  802f94:	ff 75 08             	pushl  0x8(%ebp)
  802f97:	50                   	push   %eax
  802f98:	6a 00                	push   $0x0
  802f9a:	e8 8d fb ff ff       	call   802b2c <merging>
  802f9f:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fa2:	eb 69                	jmp    80300d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802fa4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fac:	eb 39                	jmp    802fe7 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb4:	73 29                	jae    802fdf <free_block+0x90>
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	8b 00                	mov    (%eax),%eax
  802fbb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fbe:	76 1f                	jbe    802fdf <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	8b 00                	mov    (%eax),%eax
  802fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802fc8:	83 ec 04             	sub    $0x4,%esp
  802fcb:	ff 75 08             	pushl  0x8(%ebp)
  802fce:	ff 75 f0             	pushl  -0x10(%ebp)
  802fd1:	ff 75 f4             	pushl  -0xc(%ebp)
  802fd4:	e8 53 fb ff ff       	call   802b2c <merging>
  802fd9:	83 c4 10             	add    $0x10,%esp
			break;
  802fdc:	90                   	nop
		}
	}
}
  802fdd:	eb 2e                	jmp    80300d <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802fdf:	a1 34 50 80 00       	mov    0x805034,%eax
  802fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802feb:	74 07                	je     802ff4 <free_block+0xa5>
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	eb 05                	jmp    802ff9 <free_block+0xaa>
  802ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff9:	a3 34 50 80 00       	mov    %eax,0x805034
  802ffe:	a1 34 50 80 00       	mov    0x805034,%eax
  803003:	85 c0                	test   %eax,%eax
  803005:	75 a7                	jne    802fae <free_block+0x5f>
  803007:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300b:	75 a1                	jne    802fae <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80300d:	90                   	nop
  80300e:	c9                   	leave  
  80300f:	c3                   	ret    

00803010 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803010:	55                   	push   %ebp
  803011:	89 e5                	mov    %esp,%ebp
  803013:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  803016:	ff 75 08             	pushl  0x8(%ebp)
  803019:	e8 ed ec ff ff       	call   801d0b <get_block_size>
  80301e:	83 c4 04             	add    $0x4,%esp
  803021:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803024:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80302b:	eb 17                	jmp    803044 <copy_data+0x34>
  80302d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803030:	8b 45 0c             	mov    0xc(%ebp),%eax
  803033:	01 c2                	add    %eax,%edx
  803035:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	01 c8                	add    %ecx,%eax
  80303d:	8a 00                	mov    (%eax),%al
  80303f:	88 02                	mov    %al,(%edx)
  803041:	ff 45 fc             	incl   -0x4(%ebp)
  803044:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803047:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80304a:	72 e1                	jb     80302d <copy_data+0x1d>
}
  80304c:	90                   	nop
  80304d:	c9                   	leave  
  80304e:	c3                   	ret    

0080304f <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80304f:	55                   	push   %ebp
  803050:	89 e5                	mov    %esp,%ebp
  803052:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803059:	75 23                	jne    80307e <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  80305b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80305f:	74 13                	je     803074 <realloc_block_FF+0x25>
  803061:	83 ec 0c             	sub    $0xc,%esp
  803064:	ff 75 0c             	pushl  0xc(%ebp)
  803067:	e8 1f f0 ff ff       	call   80208b <alloc_block_FF>
  80306c:	83 c4 10             	add    $0x10,%esp
  80306f:	e9 f4 06 00 00       	jmp    803768 <realloc_block_FF+0x719>
		return NULL;
  803074:	b8 00 00 00 00       	mov    $0x0,%eax
  803079:	e9 ea 06 00 00       	jmp    803768 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80307e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803082:	75 18                	jne    80309c <realloc_block_FF+0x4d>
	{
		free_block(va);
  803084:	83 ec 0c             	sub    $0xc,%esp
  803087:	ff 75 08             	pushl  0x8(%ebp)
  80308a:	e8 c0 fe ff ff       	call   802f4f <free_block>
  80308f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803092:	b8 00 00 00 00       	mov    $0x0,%eax
  803097:	e9 cc 06 00 00       	jmp    803768 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80309c:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8030a0:	77 07                	ja     8030a9 <realloc_block_FF+0x5a>
  8030a2:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  8030a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ac:	83 e0 01             	and    $0x1,%eax
  8030af:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  8030b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030b5:	83 c0 08             	add    $0x8,%eax
  8030b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  8030bb:	83 ec 0c             	sub    $0xc,%esp
  8030be:	ff 75 08             	pushl  0x8(%ebp)
  8030c1:	e8 45 ec ff ff       	call   801d0b <get_block_size>
  8030c6:	83 c4 10             	add    $0x10,%esp
  8030c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8030cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cf:	83 e8 08             	sub    $0x8,%eax
  8030d2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	83 e8 04             	sub    $0x4,%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	83 e0 fe             	and    $0xfffffffe,%eax
  8030e0:	89 c2                	mov    %eax,%edx
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	01 d0                	add    %edx,%eax
  8030e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8030ea:	83 ec 0c             	sub    $0xc,%esp
  8030ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030f0:	e8 16 ec ff ff       	call   801d0b <get_block_size>
  8030f5:	83 c4 10             	add    $0x10,%esp
  8030f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8030fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fe:	83 e8 08             	sub    $0x8,%eax
  803101:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803104:	8b 45 0c             	mov    0xc(%ebp),%eax
  803107:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80310a:	75 08                	jne    803114 <realloc_block_FF+0xc5>
	{
		 return va;
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	e9 54 06 00 00       	jmp    803768 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803114:	8b 45 0c             	mov    0xc(%ebp),%eax
  803117:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80311a:	0f 83 e5 03 00 00    	jae    803505 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803120:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803123:	2b 45 0c             	sub    0xc(%ebp),%eax
  803126:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803129:	83 ec 0c             	sub    $0xc,%esp
  80312c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80312f:	e8 f0 eb ff ff       	call   801d24 <is_free_block>
  803134:	83 c4 10             	add    $0x10,%esp
  803137:	84 c0                	test   %al,%al
  803139:	0f 84 3b 01 00 00    	je     80327a <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80313f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803142:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803145:	01 d0                	add    %edx,%eax
  803147:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  80314a:	83 ec 04             	sub    $0x4,%esp
  80314d:	6a 01                	push   $0x1
  80314f:	ff 75 f0             	pushl  -0x10(%ebp)
  803152:	ff 75 08             	pushl  0x8(%ebp)
  803155:	e8 02 ef ff ff       	call   80205c <set_block_data>
  80315a:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	83 e8 04             	sub    $0x4,%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	83 e0 fe             	and    $0xfffffffe,%eax
  803168:	89 c2                	mov    %eax,%edx
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	01 d0                	add    %edx,%eax
  80316f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803172:	83 ec 04             	sub    $0x4,%esp
  803175:	6a 00                	push   $0x0
  803177:	ff 75 cc             	pushl  -0x34(%ebp)
  80317a:	ff 75 c8             	pushl  -0x38(%ebp)
  80317d:	e8 da ee ff ff       	call   80205c <set_block_data>
  803182:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803185:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803189:	74 06                	je     803191 <realloc_block_FF+0x142>
  80318b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80318f:	75 17                	jne    8031a8 <realloc_block_FF+0x159>
  803191:	83 ec 04             	sub    $0x4,%esp
  803194:	68 24 43 80 00       	push   $0x804324
  803199:	68 f6 01 00 00       	push   $0x1f6
  80319e:	68 b1 42 80 00       	push   $0x8042b1
  8031a3:	e8 6f 06 00 00       	call   803817 <_panic>
  8031a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ab:	8b 10                	mov    (%eax),%edx
  8031ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031b0:	89 10                	mov    %edx,(%eax)
  8031b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	85 c0                	test   %eax,%eax
  8031b9:	74 0b                	je     8031c6 <realloc_block_FF+0x177>
  8031bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031be:	8b 00                	mov    (%eax),%eax
  8031c0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031c3:	89 50 04             	mov    %edx,0x4(%eax)
  8031c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031cc:	89 10                	mov    %edx,(%eax)
  8031ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031d4:	89 50 04             	mov    %edx,0x4(%eax)
  8031d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
  8031dc:	85 c0                	test   %eax,%eax
  8031de:	75 08                	jne    8031e8 <realloc_block_FF+0x199>
  8031e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8031e8:	a1 38 50 80 00       	mov    0x805038,%eax
  8031ed:	40                   	inc    %eax
  8031ee:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8031f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031f7:	75 17                	jne    803210 <realloc_block_FF+0x1c1>
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 93 42 80 00       	push   $0x804293
  803201:	68 f7 01 00 00       	push   $0x1f7
  803206:	68 b1 42 80 00       	push   $0x8042b1
  80320b:	e8 07 06 00 00       	call   803817 <_panic>
  803210:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 10                	je     803229 <realloc_block_FF+0x1da>
  803219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803221:	8b 52 04             	mov    0x4(%edx),%edx
  803224:	89 50 04             	mov    %edx,0x4(%eax)
  803227:	eb 0b                	jmp    803234 <realloc_block_FF+0x1e5>
  803229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322c:	8b 40 04             	mov    0x4(%eax),%eax
  80322f:	a3 30 50 80 00       	mov    %eax,0x805030
  803234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803237:	8b 40 04             	mov    0x4(%eax),%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	74 0f                	je     80324d <realloc_block_FF+0x1fe>
  80323e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803241:	8b 40 04             	mov    0x4(%eax),%eax
  803244:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803247:	8b 12                	mov    (%edx),%edx
  803249:	89 10                	mov    %edx,(%eax)
  80324b:	eb 0a                	jmp    803257 <realloc_block_FF+0x208>
  80324d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803260:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803263:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326a:	a1 38 50 80 00       	mov    0x805038,%eax
  80326f:	48                   	dec    %eax
  803270:	a3 38 50 80 00       	mov    %eax,0x805038
  803275:	e9 83 02 00 00       	jmp    8034fd <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80327a:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80327e:	0f 86 69 02 00 00    	jbe    8034ed <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803284:	83 ec 04             	sub    $0x4,%esp
  803287:	6a 01                	push   $0x1
  803289:	ff 75 f0             	pushl  -0x10(%ebp)
  80328c:	ff 75 08             	pushl  0x8(%ebp)
  80328f:	e8 c8 ed ff ff       	call   80205c <set_block_data>
  803294:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803297:	8b 45 08             	mov    0x8(%ebp),%eax
  80329a:	83 e8 04             	sub    $0x4,%eax
  80329d:	8b 00                	mov    (%eax),%eax
  80329f:	83 e0 fe             	and    $0xfffffffe,%eax
  8032a2:	89 c2                	mov    %eax,%edx
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	01 d0                	add    %edx,%eax
  8032a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8032ac:	a1 38 50 80 00       	mov    0x805038,%eax
  8032b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8032b4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8032b8:	75 68                	jne    803322 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032ba:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032be:	75 17                	jne    8032d7 <realloc_block_FF+0x288>
  8032c0:	83 ec 04             	sub    $0x4,%esp
  8032c3:	68 cc 42 80 00       	push   $0x8042cc
  8032c8:	68 06 02 00 00       	push   $0x206
  8032cd:	68 b1 42 80 00       	push   $0x8042b1
  8032d2:	e8 40 05 00 00       	call   803817 <_panic>
  8032d7:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e0:	89 10                	mov    %edx,(%eax)
  8032e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e5:	8b 00                	mov    (%eax),%eax
  8032e7:	85 c0                	test   %eax,%eax
  8032e9:	74 0d                	je     8032f8 <realloc_block_FF+0x2a9>
  8032eb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032f3:	89 50 04             	mov    %edx,0x4(%eax)
  8032f6:	eb 08                	jmp    803300 <realloc_block_FF+0x2b1>
  8032f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032fb:	a3 30 50 80 00       	mov    %eax,0x805030
  803300:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803303:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803308:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80330b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803312:	a1 38 50 80 00       	mov    0x805038,%eax
  803317:	40                   	inc    %eax
  803318:	a3 38 50 80 00       	mov    %eax,0x805038
  80331d:	e9 b0 01 00 00       	jmp    8034d2 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803322:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803327:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80332a:	76 68                	jbe    803394 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80332c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803330:	75 17                	jne    803349 <realloc_block_FF+0x2fa>
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	68 cc 42 80 00       	push   $0x8042cc
  80333a:	68 0b 02 00 00       	push   $0x20b
  80333f:	68 b1 42 80 00       	push   $0x8042b1
  803344:	e8 ce 04 00 00       	call   803817 <_panic>
  803349:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80334f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803352:	89 10                	mov    %edx,(%eax)
  803354:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	85 c0                	test   %eax,%eax
  80335b:	74 0d                	je     80336a <realloc_block_FF+0x31b>
  80335d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803362:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803365:	89 50 04             	mov    %edx,0x4(%eax)
  803368:	eb 08                	jmp    803372 <realloc_block_FF+0x323>
  80336a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336d:	a3 30 50 80 00       	mov    %eax,0x805030
  803372:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803375:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80337a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803384:	a1 38 50 80 00       	mov    0x805038,%eax
  803389:	40                   	inc    %eax
  80338a:	a3 38 50 80 00       	mov    %eax,0x805038
  80338f:	e9 3e 01 00 00       	jmp    8034d2 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803394:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803399:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80339c:	73 68                	jae    803406 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80339e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033a2:	75 17                	jne    8033bb <realloc_block_FF+0x36c>
  8033a4:	83 ec 04             	sub    $0x4,%esp
  8033a7:	68 00 43 80 00       	push   $0x804300
  8033ac:	68 10 02 00 00       	push   $0x210
  8033b1:	68 b1 42 80 00       	push   $0x8042b1
  8033b6:	e8 5c 04 00 00       	call   803817 <_panic>
  8033bb:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8033c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c4:	89 50 04             	mov    %edx,0x4(%eax)
  8033c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ca:	8b 40 04             	mov    0x4(%eax),%eax
  8033cd:	85 c0                	test   %eax,%eax
  8033cf:	74 0c                	je     8033dd <realloc_block_FF+0x38e>
  8033d1:	a1 30 50 80 00       	mov    0x805030,%eax
  8033d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033d9:	89 10                	mov    %edx,(%eax)
  8033db:	eb 08                	jmp    8033e5 <realloc_block_FF+0x396>
  8033dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e8:	a3 30 50 80 00       	mov    %eax,0x805030
  8033ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8033fb:	40                   	inc    %eax
  8033fc:	a3 38 50 80 00       	mov    %eax,0x805038
  803401:	e9 cc 00 00 00       	jmp    8034d2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  80340d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803412:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803415:	e9 8a 00 00 00       	jmp    8034a4 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80341a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803420:	73 7a                	jae    80349c <realloc_block_FF+0x44d>
  803422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803425:	8b 00                	mov    (%eax),%eax
  803427:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80342a:	73 70                	jae    80349c <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  80342c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803430:	74 06                	je     803438 <realloc_block_FF+0x3e9>
  803432:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803436:	75 17                	jne    80344f <realloc_block_FF+0x400>
  803438:	83 ec 04             	sub    $0x4,%esp
  80343b:	68 24 43 80 00       	push   $0x804324
  803440:	68 1a 02 00 00       	push   $0x21a
  803445:	68 b1 42 80 00       	push   $0x8042b1
  80344a:	e8 c8 03 00 00       	call   803817 <_panic>
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 10                	mov    (%eax),%edx
  803454:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803457:	89 10                	mov    %edx,(%eax)
  803459:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	85 c0                	test   %eax,%eax
  803460:	74 0b                	je     80346d <realloc_block_FF+0x41e>
  803462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803465:	8b 00                	mov    (%eax),%eax
  803467:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80346a:	89 50 04             	mov    %edx,0x4(%eax)
  80346d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803470:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803473:	89 10                	mov    %edx,(%eax)
  803475:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803478:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80347b:	89 50 04             	mov    %edx,0x4(%eax)
  80347e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803481:	8b 00                	mov    (%eax),%eax
  803483:	85 c0                	test   %eax,%eax
  803485:	75 08                	jne    80348f <realloc_block_FF+0x440>
  803487:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80348a:	a3 30 50 80 00       	mov    %eax,0x805030
  80348f:	a1 38 50 80 00       	mov    0x805038,%eax
  803494:	40                   	inc    %eax
  803495:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80349a:	eb 36                	jmp    8034d2 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80349c:	a1 34 50 80 00       	mov    0x805034,%eax
  8034a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a8:	74 07                	je     8034b1 <realloc_block_FF+0x462>
  8034aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	eb 05                	jmp    8034b6 <realloc_block_FF+0x467>
  8034b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b6:	a3 34 50 80 00       	mov    %eax,0x805034
  8034bb:	a1 34 50 80 00       	mov    0x805034,%eax
  8034c0:	85 c0                	test   %eax,%eax
  8034c2:	0f 85 52 ff ff ff    	jne    80341a <realloc_block_FF+0x3cb>
  8034c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034cc:	0f 85 48 ff ff ff    	jne    80341a <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8034d2:	83 ec 04             	sub    $0x4,%esp
  8034d5:	6a 00                	push   $0x0
  8034d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8034da:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034dd:	e8 7a eb ff ff       	call   80205c <set_block_data>
  8034e2:	83 c4 10             	add    $0x10,%esp
				return va;
  8034e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e8:	e9 7b 02 00 00       	jmp    803768 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8034ed:	83 ec 0c             	sub    $0xc,%esp
  8034f0:	68 a1 43 80 00       	push   $0x8043a1
  8034f5:	e8 09 cf ff ff       	call   800403 <cprintf>
  8034fa:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803500:	e9 63 02 00 00       	jmp    803768 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803505:	8b 45 0c             	mov    0xc(%ebp),%eax
  803508:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80350b:	0f 86 4d 02 00 00    	jbe    80375e <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803511:	83 ec 0c             	sub    $0xc,%esp
  803514:	ff 75 e4             	pushl  -0x1c(%ebp)
  803517:	e8 08 e8 ff ff       	call   801d24 <is_free_block>
  80351c:	83 c4 10             	add    $0x10,%esp
  80351f:	84 c0                	test   %al,%al
  803521:	0f 84 37 02 00 00    	je     80375e <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80352a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80352d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803530:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803533:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803536:	76 38                	jbe    803570 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803538:	83 ec 0c             	sub    $0xc,%esp
  80353b:	ff 75 08             	pushl  0x8(%ebp)
  80353e:	e8 0c fa ff ff       	call   802f4f <free_block>
  803543:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803546:	83 ec 0c             	sub    $0xc,%esp
  803549:	ff 75 0c             	pushl  0xc(%ebp)
  80354c:	e8 3a eb ff ff       	call   80208b <alloc_block_FF>
  803551:	83 c4 10             	add    $0x10,%esp
  803554:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803557:	83 ec 08             	sub    $0x8,%esp
  80355a:	ff 75 c0             	pushl  -0x40(%ebp)
  80355d:	ff 75 08             	pushl  0x8(%ebp)
  803560:	e8 ab fa ff ff       	call   803010 <copy_data>
  803565:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803568:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80356b:	e9 f8 01 00 00       	jmp    803768 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803570:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803573:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803576:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803579:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80357d:	0f 87 a0 00 00 00    	ja     803623 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803583:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803587:	75 17                	jne    8035a0 <realloc_block_FF+0x551>
  803589:	83 ec 04             	sub    $0x4,%esp
  80358c:	68 93 42 80 00       	push   $0x804293
  803591:	68 38 02 00 00       	push   $0x238
  803596:	68 b1 42 80 00       	push   $0x8042b1
  80359b:	e8 77 02 00 00       	call   803817 <_panic>
  8035a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a3:	8b 00                	mov    (%eax),%eax
  8035a5:	85 c0                	test   %eax,%eax
  8035a7:	74 10                	je     8035b9 <realloc_block_FF+0x56a>
  8035a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ac:	8b 00                	mov    (%eax),%eax
  8035ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035b1:	8b 52 04             	mov    0x4(%edx),%edx
  8035b4:	89 50 04             	mov    %edx,0x4(%eax)
  8035b7:	eb 0b                	jmp    8035c4 <realloc_block_FF+0x575>
  8035b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035bc:	8b 40 04             	mov    0x4(%eax),%eax
  8035bf:	a3 30 50 80 00       	mov    %eax,0x805030
  8035c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	74 0f                	je     8035dd <realloc_block_FF+0x58e>
  8035ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d1:	8b 40 04             	mov    0x4(%eax),%eax
  8035d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d7:	8b 12                	mov    (%edx),%edx
  8035d9:	89 10                	mov    %edx,(%eax)
  8035db:	eb 0a                	jmp    8035e7 <realloc_block_FF+0x598>
  8035dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e0:	8b 00                	mov    (%eax),%eax
  8035e2:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035fa:	a1 38 50 80 00       	mov    0x805038,%eax
  8035ff:	48                   	dec    %eax
  803600:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803605:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803608:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80360b:	01 d0                	add    %edx,%eax
  80360d:	83 ec 04             	sub    $0x4,%esp
  803610:	6a 01                	push   $0x1
  803612:	50                   	push   %eax
  803613:	ff 75 08             	pushl  0x8(%ebp)
  803616:	e8 41 ea ff ff       	call   80205c <set_block_data>
  80361b:	83 c4 10             	add    $0x10,%esp
  80361e:	e9 36 01 00 00       	jmp    803759 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803623:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803626:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803629:	01 d0                	add    %edx,%eax
  80362b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80362e:	83 ec 04             	sub    $0x4,%esp
  803631:	6a 01                	push   $0x1
  803633:	ff 75 f0             	pushl  -0x10(%ebp)
  803636:	ff 75 08             	pushl  0x8(%ebp)
  803639:	e8 1e ea ff ff       	call   80205c <set_block_data>
  80363e:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	83 e8 04             	sub    $0x4,%eax
  803647:	8b 00                	mov    (%eax),%eax
  803649:	83 e0 fe             	and    $0xfffffffe,%eax
  80364c:	89 c2                	mov    %eax,%edx
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	01 d0                	add    %edx,%eax
  803653:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803656:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80365a:	74 06                	je     803662 <realloc_block_FF+0x613>
  80365c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  803660:	75 17                	jne    803679 <realloc_block_FF+0x62a>
  803662:	83 ec 04             	sub    $0x4,%esp
  803665:	68 24 43 80 00       	push   $0x804324
  80366a:	68 44 02 00 00       	push   $0x244
  80366f:	68 b1 42 80 00       	push   $0x8042b1
  803674:	e8 9e 01 00 00       	call   803817 <_panic>
  803679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367c:	8b 10                	mov    (%eax),%edx
  80367e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803681:	89 10                	mov    %edx,(%eax)
  803683:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803686:	8b 00                	mov    (%eax),%eax
  803688:	85 c0                	test   %eax,%eax
  80368a:	74 0b                	je     803697 <realloc_block_FF+0x648>
  80368c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368f:	8b 00                	mov    (%eax),%eax
  803691:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803694:	89 50 04             	mov    %edx,0x4(%eax)
  803697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369a:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80369d:	89 10                	mov    %edx,(%eax)
  80369f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036a5:	89 50 04             	mov    %edx,0x4(%eax)
  8036a8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036ab:	8b 00                	mov    (%eax),%eax
  8036ad:	85 c0                	test   %eax,%eax
  8036af:	75 08                	jne    8036b9 <realloc_block_FF+0x66a>
  8036b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036b4:	a3 30 50 80 00       	mov    %eax,0x805030
  8036b9:	a1 38 50 80 00       	mov    0x805038,%eax
  8036be:	40                   	inc    %eax
  8036bf:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8036c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036c8:	75 17                	jne    8036e1 <realloc_block_FF+0x692>
  8036ca:	83 ec 04             	sub    $0x4,%esp
  8036cd:	68 93 42 80 00       	push   $0x804293
  8036d2:	68 45 02 00 00       	push   $0x245
  8036d7:	68 b1 42 80 00       	push   $0x8042b1
  8036dc:	e8 36 01 00 00       	call   803817 <_panic>
  8036e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e4:	8b 00                	mov    (%eax),%eax
  8036e6:	85 c0                	test   %eax,%eax
  8036e8:	74 10                	je     8036fa <realloc_block_FF+0x6ab>
  8036ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ed:	8b 00                	mov    (%eax),%eax
  8036ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036f2:	8b 52 04             	mov    0x4(%edx),%edx
  8036f5:	89 50 04             	mov    %edx,0x4(%eax)
  8036f8:	eb 0b                	jmp    803705 <realloc_block_FF+0x6b6>
  8036fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fd:	8b 40 04             	mov    0x4(%eax),%eax
  803700:	a3 30 50 80 00       	mov    %eax,0x805030
  803705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803708:	8b 40 04             	mov    0x4(%eax),%eax
  80370b:	85 c0                	test   %eax,%eax
  80370d:	74 0f                	je     80371e <realloc_block_FF+0x6cf>
  80370f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803712:	8b 40 04             	mov    0x4(%eax),%eax
  803715:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803718:	8b 12                	mov    (%edx),%edx
  80371a:	89 10                	mov    %edx,(%eax)
  80371c:	eb 0a                	jmp    803728 <realloc_block_FF+0x6d9>
  80371e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803721:	8b 00                	mov    (%eax),%eax
  803723:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80372b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803734:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373b:	a1 38 50 80 00       	mov    0x805038,%eax
  803740:	48                   	dec    %eax
  803741:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803746:	83 ec 04             	sub    $0x4,%esp
  803749:	6a 00                	push   $0x0
  80374b:	ff 75 bc             	pushl  -0x44(%ebp)
  80374e:	ff 75 b8             	pushl  -0x48(%ebp)
  803751:	e8 06 e9 ff ff       	call   80205c <set_block_data>
  803756:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803759:	8b 45 08             	mov    0x8(%ebp),%eax
  80375c:	eb 0a                	jmp    803768 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80375e:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803765:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803768:	c9                   	leave  
  803769:	c3                   	ret    

0080376a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80376a:	55                   	push   %ebp
  80376b:	89 e5                	mov    %esp,%ebp
  80376d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803770:	83 ec 04             	sub    $0x4,%esp
  803773:	68 a8 43 80 00       	push   $0x8043a8
  803778:	68 58 02 00 00       	push   $0x258
  80377d:	68 b1 42 80 00       	push   $0x8042b1
  803782:	e8 90 00 00 00       	call   803817 <_panic>

00803787 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803787:	55                   	push   %ebp
  803788:	89 e5                	mov    %esp,%ebp
  80378a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80378d:	83 ec 04             	sub    $0x4,%esp
  803790:	68 d0 43 80 00       	push   $0x8043d0
  803795:	68 61 02 00 00       	push   $0x261
  80379a:	68 b1 42 80 00       	push   $0x8042b1
  80379f:	e8 73 00 00 00       	call   803817 <_panic>

008037a4 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8037a4:	55                   	push   %ebp
  8037a5:	89 e5                	mov    %esp,%ebp
  8037a7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8037aa:	83 ec 04             	sub    $0x4,%esp
  8037ad:	68 f8 43 80 00       	push   $0x8043f8
  8037b2:	6a 09                	push   $0x9
  8037b4:	68 20 44 80 00       	push   $0x804420
  8037b9:	e8 59 00 00 00       	call   803817 <_panic>

008037be <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8037be:	55                   	push   %ebp
  8037bf:	89 e5                	mov    %esp,%ebp
  8037c1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8037c4:	83 ec 04             	sub    $0x4,%esp
  8037c7:	68 30 44 80 00       	push   $0x804430
  8037cc:	6a 10                	push   $0x10
  8037ce:	68 20 44 80 00       	push   $0x804420
  8037d3:	e8 3f 00 00 00       	call   803817 <_panic>

008037d8 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8037d8:	55                   	push   %ebp
  8037d9:	89 e5                	mov    %esp,%ebp
  8037db:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8037de:	83 ec 04             	sub    $0x4,%esp
  8037e1:	68 58 44 80 00       	push   $0x804458
  8037e6:	6a 18                	push   $0x18
  8037e8:	68 20 44 80 00       	push   $0x804420
  8037ed:	e8 25 00 00 00       	call   803817 <_panic>

008037f2 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8037f2:	55                   	push   %ebp
  8037f3:	89 e5                	mov    %esp,%ebp
  8037f5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8037f8:	83 ec 04             	sub    $0x4,%esp
  8037fb:	68 80 44 80 00       	push   $0x804480
  803800:	6a 20                	push   $0x20
  803802:	68 20 44 80 00       	push   $0x804420
  803807:	e8 0b 00 00 00       	call   803817 <_panic>

0080380c <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80380c:	55                   	push   %ebp
  80380d:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80380f:	8b 45 08             	mov    0x8(%ebp),%eax
  803812:	8b 40 10             	mov    0x10(%eax),%eax
}
  803815:	5d                   	pop    %ebp
  803816:	c3                   	ret    

00803817 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803817:	55                   	push   %ebp
  803818:	89 e5                	mov    %esp,%ebp
  80381a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80381d:	8d 45 10             	lea    0x10(%ebp),%eax
  803820:	83 c0 04             	add    $0x4,%eax
  803823:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803826:	a1 60 50 98 00       	mov    0x985060,%eax
  80382b:	85 c0                	test   %eax,%eax
  80382d:	74 16                	je     803845 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80382f:	a1 60 50 98 00       	mov    0x985060,%eax
  803834:	83 ec 08             	sub    $0x8,%esp
  803837:	50                   	push   %eax
  803838:	68 a8 44 80 00       	push   $0x8044a8
  80383d:	e8 c1 cb ff ff       	call   800403 <cprintf>
  803842:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803845:	a1 00 50 80 00       	mov    0x805000,%eax
  80384a:	ff 75 0c             	pushl  0xc(%ebp)
  80384d:	ff 75 08             	pushl  0x8(%ebp)
  803850:	50                   	push   %eax
  803851:	68 ad 44 80 00       	push   $0x8044ad
  803856:	e8 a8 cb ff ff       	call   800403 <cprintf>
  80385b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80385e:	8b 45 10             	mov    0x10(%ebp),%eax
  803861:	83 ec 08             	sub    $0x8,%esp
  803864:	ff 75 f4             	pushl  -0xc(%ebp)
  803867:	50                   	push   %eax
  803868:	e8 2b cb ff ff       	call   800398 <vcprintf>
  80386d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803870:	83 ec 08             	sub    $0x8,%esp
  803873:	6a 00                	push   $0x0
  803875:	68 c9 44 80 00       	push   $0x8044c9
  80387a:	e8 19 cb ff ff       	call   800398 <vcprintf>
  80387f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803882:	e8 9a ca ff ff       	call   800321 <exit>

	// should not return here
	while (1) ;
  803887:	eb fe                	jmp    803887 <_panic+0x70>

00803889 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803889:	55                   	push   %ebp
  80388a:	89 e5                	mov    %esp,%ebp
  80388c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80388f:	a1 20 50 80 00       	mov    0x805020,%eax
  803894:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80389a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80389d:	39 c2                	cmp    %eax,%edx
  80389f:	74 14                	je     8038b5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8038a1:	83 ec 04             	sub    $0x4,%esp
  8038a4:	68 cc 44 80 00       	push   $0x8044cc
  8038a9:	6a 26                	push   $0x26
  8038ab:	68 18 45 80 00       	push   $0x804518
  8038b0:	e8 62 ff ff ff       	call   803817 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8038b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8038bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8038c3:	e9 c5 00 00 00       	jmp    80398d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8038c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d5:	01 d0                	add    %edx,%eax
  8038d7:	8b 00                	mov    (%eax),%eax
  8038d9:	85 c0                	test   %eax,%eax
  8038db:	75 08                	jne    8038e5 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8038dd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8038e0:	e9 a5 00 00 00       	jmp    80398a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8038e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8038f3:	eb 69                	jmp    80395e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8038f5:	a1 20 50 80 00       	mov    0x805020,%eax
  8038fa:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803900:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803903:	89 d0                	mov    %edx,%eax
  803905:	01 c0                	add    %eax,%eax
  803907:	01 d0                	add    %edx,%eax
  803909:	c1 e0 03             	shl    $0x3,%eax
  80390c:	01 c8                	add    %ecx,%eax
  80390e:	8a 40 04             	mov    0x4(%eax),%al
  803911:	84 c0                	test   %al,%al
  803913:	75 46                	jne    80395b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803915:	a1 20 50 80 00       	mov    0x805020,%eax
  80391a:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803920:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803923:	89 d0                	mov    %edx,%eax
  803925:	01 c0                	add    %eax,%eax
  803927:	01 d0                	add    %edx,%eax
  803929:	c1 e0 03             	shl    $0x3,%eax
  80392c:	01 c8                	add    %ecx,%eax
  80392e:	8b 00                	mov    (%eax),%eax
  803930:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803933:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803936:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80393b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80393d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803940:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803947:	8b 45 08             	mov    0x8(%ebp),%eax
  80394a:	01 c8                	add    %ecx,%eax
  80394c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80394e:	39 c2                	cmp    %eax,%edx
  803950:	75 09                	jne    80395b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803952:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803959:	eb 15                	jmp    803970 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80395b:	ff 45 e8             	incl   -0x18(%ebp)
  80395e:	a1 20 50 80 00       	mov    0x805020,%eax
  803963:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803969:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396c:	39 c2                	cmp    %eax,%edx
  80396e:	77 85                	ja     8038f5 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803970:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803974:	75 14                	jne    80398a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803976:	83 ec 04             	sub    $0x4,%esp
  803979:	68 24 45 80 00       	push   $0x804524
  80397e:	6a 3a                	push   $0x3a
  803980:	68 18 45 80 00       	push   $0x804518
  803985:	e8 8d fe ff ff       	call   803817 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80398a:	ff 45 f0             	incl   -0x10(%ebp)
  80398d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803990:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803993:	0f 8c 2f ff ff ff    	jl     8038c8 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803999:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039a0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8039a7:	eb 26                	jmp    8039cf <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8039a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8039ae:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039b7:	89 d0                	mov    %edx,%eax
  8039b9:	01 c0                	add    %eax,%eax
  8039bb:	01 d0                	add    %edx,%eax
  8039bd:	c1 e0 03             	shl    $0x3,%eax
  8039c0:	01 c8                	add    %ecx,%eax
  8039c2:	8a 40 04             	mov    0x4(%eax),%al
  8039c5:	3c 01                	cmp    $0x1,%al
  8039c7:	75 03                	jne    8039cc <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8039c9:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039cc:	ff 45 e0             	incl   -0x20(%ebp)
  8039cf:	a1 20 50 80 00       	mov    0x805020,%eax
  8039d4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039dd:	39 c2                	cmp    %eax,%edx
  8039df:	77 c8                	ja     8039a9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8039e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039e7:	74 14                	je     8039fd <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8039e9:	83 ec 04             	sub    $0x4,%esp
  8039ec:	68 78 45 80 00       	push   $0x804578
  8039f1:	6a 44                	push   $0x44
  8039f3:	68 18 45 80 00       	push   $0x804518
  8039f8:	e8 1a fe ff ff       	call   803817 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8039fd:	90                   	nop
  8039fe:	c9                   	leave  
  8039ff:	c3                   	ret    

00803a00 <__udivdi3>:
  803a00:	55                   	push   %ebp
  803a01:	57                   	push   %edi
  803a02:	56                   	push   %esi
  803a03:	53                   	push   %ebx
  803a04:	83 ec 1c             	sub    $0x1c,%esp
  803a07:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a0b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a0f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a13:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a17:	89 ca                	mov    %ecx,%edx
  803a19:	89 f8                	mov    %edi,%eax
  803a1b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a1f:	85 f6                	test   %esi,%esi
  803a21:	75 2d                	jne    803a50 <__udivdi3+0x50>
  803a23:	39 cf                	cmp    %ecx,%edi
  803a25:	77 65                	ja     803a8c <__udivdi3+0x8c>
  803a27:	89 fd                	mov    %edi,%ebp
  803a29:	85 ff                	test   %edi,%edi
  803a2b:	75 0b                	jne    803a38 <__udivdi3+0x38>
  803a2d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a32:	31 d2                	xor    %edx,%edx
  803a34:	f7 f7                	div    %edi
  803a36:	89 c5                	mov    %eax,%ebp
  803a38:	31 d2                	xor    %edx,%edx
  803a3a:	89 c8                	mov    %ecx,%eax
  803a3c:	f7 f5                	div    %ebp
  803a3e:	89 c1                	mov    %eax,%ecx
  803a40:	89 d8                	mov    %ebx,%eax
  803a42:	f7 f5                	div    %ebp
  803a44:	89 cf                	mov    %ecx,%edi
  803a46:	89 fa                	mov    %edi,%edx
  803a48:	83 c4 1c             	add    $0x1c,%esp
  803a4b:	5b                   	pop    %ebx
  803a4c:	5e                   	pop    %esi
  803a4d:	5f                   	pop    %edi
  803a4e:	5d                   	pop    %ebp
  803a4f:	c3                   	ret    
  803a50:	39 ce                	cmp    %ecx,%esi
  803a52:	77 28                	ja     803a7c <__udivdi3+0x7c>
  803a54:	0f bd fe             	bsr    %esi,%edi
  803a57:	83 f7 1f             	xor    $0x1f,%edi
  803a5a:	75 40                	jne    803a9c <__udivdi3+0x9c>
  803a5c:	39 ce                	cmp    %ecx,%esi
  803a5e:	72 0a                	jb     803a6a <__udivdi3+0x6a>
  803a60:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a64:	0f 87 9e 00 00 00    	ja     803b08 <__udivdi3+0x108>
  803a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a6f:	89 fa                	mov    %edi,%edx
  803a71:	83 c4 1c             	add    $0x1c,%esp
  803a74:	5b                   	pop    %ebx
  803a75:	5e                   	pop    %esi
  803a76:	5f                   	pop    %edi
  803a77:	5d                   	pop    %ebp
  803a78:	c3                   	ret    
  803a79:	8d 76 00             	lea    0x0(%esi),%esi
  803a7c:	31 ff                	xor    %edi,%edi
  803a7e:	31 c0                	xor    %eax,%eax
  803a80:	89 fa                	mov    %edi,%edx
  803a82:	83 c4 1c             	add    $0x1c,%esp
  803a85:	5b                   	pop    %ebx
  803a86:	5e                   	pop    %esi
  803a87:	5f                   	pop    %edi
  803a88:	5d                   	pop    %ebp
  803a89:	c3                   	ret    
  803a8a:	66 90                	xchg   %ax,%ax
  803a8c:	89 d8                	mov    %ebx,%eax
  803a8e:	f7 f7                	div    %edi
  803a90:	31 ff                	xor    %edi,%edi
  803a92:	89 fa                	mov    %edi,%edx
  803a94:	83 c4 1c             	add    $0x1c,%esp
  803a97:	5b                   	pop    %ebx
  803a98:	5e                   	pop    %esi
  803a99:	5f                   	pop    %edi
  803a9a:	5d                   	pop    %ebp
  803a9b:	c3                   	ret    
  803a9c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803aa1:	89 eb                	mov    %ebp,%ebx
  803aa3:	29 fb                	sub    %edi,%ebx
  803aa5:	89 f9                	mov    %edi,%ecx
  803aa7:	d3 e6                	shl    %cl,%esi
  803aa9:	89 c5                	mov    %eax,%ebp
  803aab:	88 d9                	mov    %bl,%cl
  803aad:	d3 ed                	shr    %cl,%ebp
  803aaf:	89 e9                	mov    %ebp,%ecx
  803ab1:	09 f1                	or     %esi,%ecx
  803ab3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ab7:	89 f9                	mov    %edi,%ecx
  803ab9:	d3 e0                	shl    %cl,%eax
  803abb:	89 c5                	mov    %eax,%ebp
  803abd:	89 d6                	mov    %edx,%esi
  803abf:	88 d9                	mov    %bl,%cl
  803ac1:	d3 ee                	shr    %cl,%esi
  803ac3:	89 f9                	mov    %edi,%ecx
  803ac5:	d3 e2                	shl    %cl,%edx
  803ac7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803acb:	88 d9                	mov    %bl,%cl
  803acd:	d3 e8                	shr    %cl,%eax
  803acf:	09 c2                	or     %eax,%edx
  803ad1:	89 d0                	mov    %edx,%eax
  803ad3:	89 f2                	mov    %esi,%edx
  803ad5:	f7 74 24 0c          	divl   0xc(%esp)
  803ad9:	89 d6                	mov    %edx,%esi
  803adb:	89 c3                	mov    %eax,%ebx
  803add:	f7 e5                	mul    %ebp
  803adf:	39 d6                	cmp    %edx,%esi
  803ae1:	72 19                	jb     803afc <__udivdi3+0xfc>
  803ae3:	74 0b                	je     803af0 <__udivdi3+0xf0>
  803ae5:	89 d8                	mov    %ebx,%eax
  803ae7:	31 ff                	xor    %edi,%edi
  803ae9:	e9 58 ff ff ff       	jmp    803a46 <__udivdi3+0x46>
  803aee:	66 90                	xchg   %ax,%ax
  803af0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803af4:	89 f9                	mov    %edi,%ecx
  803af6:	d3 e2                	shl    %cl,%edx
  803af8:	39 c2                	cmp    %eax,%edx
  803afa:	73 e9                	jae    803ae5 <__udivdi3+0xe5>
  803afc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803aff:	31 ff                	xor    %edi,%edi
  803b01:	e9 40 ff ff ff       	jmp    803a46 <__udivdi3+0x46>
  803b06:	66 90                	xchg   %ax,%ax
  803b08:	31 c0                	xor    %eax,%eax
  803b0a:	e9 37 ff ff ff       	jmp    803a46 <__udivdi3+0x46>
  803b0f:	90                   	nop

00803b10 <__umoddi3>:
  803b10:	55                   	push   %ebp
  803b11:	57                   	push   %edi
  803b12:	56                   	push   %esi
  803b13:	53                   	push   %ebx
  803b14:	83 ec 1c             	sub    $0x1c,%esp
  803b17:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b1b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b1f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b23:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b2b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b2f:	89 f3                	mov    %esi,%ebx
  803b31:	89 fa                	mov    %edi,%edx
  803b33:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b37:	89 34 24             	mov    %esi,(%esp)
  803b3a:	85 c0                	test   %eax,%eax
  803b3c:	75 1a                	jne    803b58 <__umoddi3+0x48>
  803b3e:	39 f7                	cmp    %esi,%edi
  803b40:	0f 86 a2 00 00 00    	jbe    803be8 <__umoddi3+0xd8>
  803b46:	89 c8                	mov    %ecx,%eax
  803b48:	89 f2                	mov    %esi,%edx
  803b4a:	f7 f7                	div    %edi
  803b4c:	89 d0                	mov    %edx,%eax
  803b4e:	31 d2                	xor    %edx,%edx
  803b50:	83 c4 1c             	add    $0x1c,%esp
  803b53:	5b                   	pop    %ebx
  803b54:	5e                   	pop    %esi
  803b55:	5f                   	pop    %edi
  803b56:	5d                   	pop    %ebp
  803b57:	c3                   	ret    
  803b58:	39 f0                	cmp    %esi,%eax
  803b5a:	0f 87 ac 00 00 00    	ja     803c0c <__umoddi3+0xfc>
  803b60:	0f bd e8             	bsr    %eax,%ebp
  803b63:	83 f5 1f             	xor    $0x1f,%ebp
  803b66:	0f 84 ac 00 00 00    	je     803c18 <__umoddi3+0x108>
  803b6c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b71:	29 ef                	sub    %ebp,%edi
  803b73:	89 fe                	mov    %edi,%esi
  803b75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b79:	89 e9                	mov    %ebp,%ecx
  803b7b:	d3 e0                	shl    %cl,%eax
  803b7d:	89 d7                	mov    %edx,%edi
  803b7f:	89 f1                	mov    %esi,%ecx
  803b81:	d3 ef                	shr    %cl,%edi
  803b83:	09 c7                	or     %eax,%edi
  803b85:	89 e9                	mov    %ebp,%ecx
  803b87:	d3 e2                	shl    %cl,%edx
  803b89:	89 14 24             	mov    %edx,(%esp)
  803b8c:	89 d8                	mov    %ebx,%eax
  803b8e:	d3 e0                	shl    %cl,%eax
  803b90:	89 c2                	mov    %eax,%edx
  803b92:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b96:	d3 e0                	shl    %cl,%eax
  803b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b9c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba0:	89 f1                	mov    %esi,%ecx
  803ba2:	d3 e8                	shr    %cl,%eax
  803ba4:	09 d0                	or     %edx,%eax
  803ba6:	d3 eb                	shr    %cl,%ebx
  803ba8:	89 da                	mov    %ebx,%edx
  803baa:	f7 f7                	div    %edi
  803bac:	89 d3                	mov    %edx,%ebx
  803bae:	f7 24 24             	mull   (%esp)
  803bb1:	89 c6                	mov    %eax,%esi
  803bb3:	89 d1                	mov    %edx,%ecx
  803bb5:	39 d3                	cmp    %edx,%ebx
  803bb7:	0f 82 87 00 00 00    	jb     803c44 <__umoddi3+0x134>
  803bbd:	0f 84 91 00 00 00    	je     803c54 <__umoddi3+0x144>
  803bc3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bc7:	29 f2                	sub    %esi,%edx
  803bc9:	19 cb                	sbb    %ecx,%ebx
  803bcb:	89 d8                	mov    %ebx,%eax
  803bcd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bd1:	d3 e0                	shl    %cl,%eax
  803bd3:	89 e9                	mov    %ebp,%ecx
  803bd5:	d3 ea                	shr    %cl,%edx
  803bd7:	09 d0                	or     %edx,%eax
  803bd9:	89 e9                	mov    %ebp,%ecx
  803bdb:	d3 eb                	shr    %cl,%ebx
  803bdd:	89 da                	mov    %ebx,%edx
  803bdf:	83 c4 1c             	add    $0x1c,%esp
  803be2:	5b                   	pop    %ebx
  803be3:	5e                   	pop    %esi
  803be4:	5f                   	pop    %edi
  803be5:	5d                   	pop    %ebp
  803be6:	c3                   	ret    
  803be7:	90                   	nop
  803be8:	89 fd                	mov    %edi,%ebp
  803bea:	85 ff                	test   %edi,%edi
  803bec:	75 0b                	jne    803bf9 <__umoddi3+0xe9>
  803bee:	b8 01 00 00 00       	mov    $0x1,%eax
  803bf3:	31 d2                	xor    %edx,%edx
  803bf5:	f7 f7                	div    %edi
  803bf7:	89 c5                	mov    %eax,%ebp
  803bf9:	89 f0                	mov    %esi,%eax
  803bfb:	31 d2                	xor    %edx,%edx
  803bfd:	f7 f5                	div    %ebp
  803bff:	89 c8                	mov    %ecx,%eax
  803c01:	f7 f5                	div    %ebp
  803c03:	89 d0                	mov    %edx,%eax
  803c05:	e9 44 ff ff ff       	jmp    803b4e <__umoddi3+0x3e>
  803c0a:	66 90                	xchg   %ax,%ax
  803c0c:	89 c8                	mov    %ecx,%eax
  803c0e:	89 f2                	mov    %esi,%edx
  803c10:	83 c4 1c             	add    $0x1c,%esp
  803c13:	5b                   	pop    %ebx
  803c14:	5e                   	pop    %esi
  803c15:	5f                   	pop    %edi
  803c16:	5d                   	pop    %ebp
  803c17:	c3                   	ret    
  803c18:	3b 04 24             	cmp    (%esp),%eax
  803c1b:	72 06                	jb     803c23 <__umoddi3+0x113>
  803c1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c21:	77 0f                	ja     803c32 <__umoddi3+0x122>
  803c23:	89 f2                	mov    %esi,%edx
  803c25:	29 f9                	sub    %edi,%ecx
  803c27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c2b:	89 14 24             	mov    %edx,(%esp)
  803c2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c32:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c36:	8b 14 24             	mov    (%esp),%edx
  803c39:	83 c4 1c             	add    $0x1c,%esp
  803c3c:	5b                   	pop    %ebx
  803c3d:	5e                   	pop    %esi
  803c3e:	5f                   	pop    %edi
  803c3f:	5d                   	pop    %ebp
  803c40:	c3                   	ret    
  803c41:	8d 76 00             	lea    0x0(%esi),%esi
  803c44:	2b 04 24             	sub    (%esp),%eax
  803c47:	19 fa                	sbb    %edi,%edx
  803c49:	89 d1                	mov    %edx,%ecx
  803c4b:	89 c6                	mov    %eax,%esi
  803c4d:	e9 71 ff ff ff       	jmp    803bc3 <__umoddi3+0xb3>
  803c52:	66 90                	xchg   %ax,%ax
  803c54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c58:	72 ea                	jb     803c44 <__umoddi3+0x134>
  803c5a:	89 d9                	mov    %ebx,%ecx
  803c5c:	e9 62 ff ff ff       	jmp    803bc3 <__umoddi3+0xb3>
