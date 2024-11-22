
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
  800045:	68 a0 3b 80 00       	push   $0x803ba0
  80004a:	e8 81 14 00 00       	call   8014d0 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 a4 3b 80 00       	push   $0x803ba4
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
  80009a:	68 c9 3b 80 00       	push   $0x803bc9
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
  8000da:	68 d0 3b 80 00       	push   $0x803bd0
  8000df:	50                   	push   %eax
  8000e0:	e8 ea 35 00 00       	call   8036cf <create_semaphore>
  8000e5:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	6a 01                	push   $0x1
  8000ed:	6a 04                	push   $0x4
  8000ef:	68 d2 3b 80 00       	push   $0x803bd2
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
  80012e:	68 e0 3b 80 00       	push   $0x803be0
  800133:	e8 50 17 00 00       	call   801888 <sys_create_env>
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
  800164:	68 ea 3b 80 00       	push   $0x803bea
  800169:	e8 1a 17 00 00       	call   801888 <sys_create_env>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 27 17 00 00       	call   8018a6 <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	e8 19 17 00 00       	call   8018a6 <sys_run_env>
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
  8001a4:	68 f4 3b 80 00       	push   $0x803bf4
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
  8001c8:	e8 f8 15 00 00       	call   8017c5 <sys_cputc>
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
  8001d9:	e8 83 14 00 00       	call   801661 <sys_cgetc>
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
  8001f6:	e8 fb 16 00 00       	call   8018f6 <sys_getenvindex>
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
  800264:	e8 11 14 00 00       	call   80167a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	68 24 3c 80 00       	push   $0x803c24
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
  800294:	68 4c 3c 80 00       	push   $0x803c4c
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
  8002c5:	68 74 3c 80 00       	push   $0x803c74
  8002ca:	e8 34 01 00 00       	call   800403 <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d7:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	50                   	push   %eax
  8002e1:	68 cc 3c 80 00       	push   $0x803ccc
  8002e6:	e8 18 01 00 00       	call   800403 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	68 24 3c 80 00       	push   $0x803c24
  8002f6:	e8 08 01 00 00       	call   800403 <cprintf>
  8002fb:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002fe:	e8 91 13 00 00       	call   801694 <sys_unlock_cons>
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
  800316:	e8 a7 15 00 00       	call   8018c2 <sys_destroy_env>
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
  800327:	e8 fc 15 00 00       	call   801928 <sys_exit_env>
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
  800375:	e8 be 12 00 00       	call   801638 <sys_cputs>
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
  8003ec:	e8 47 12 00 00       	call   801638 <sys_cputs>
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
  800436:	e8 3f 12 00 00       	call   80167a <sys_lock_cons>
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
  800456:	e8 39 12 00 00       	call   801694 <sys_unlock_cons>
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
  8004a0:	e8 87 34 00 00       	call   80392c <__udivdi3>
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
  8004f0:	e8 47 35 00 00       	call   803a3c <__umoddi3>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	05 f4 3e 80 00       	add    $0x803ef4,%eax
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
  80064b:	8b 04 85 18 3f 80 00 	mov    0x803f18(,%eax,4),%eax
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
  80072c:	8b 34 9d 60 3d 80 00 	mov    0x803d60(,%ebx,4),%esi
  800733:	85 f6                	test   %esi,%esi
  800735:	75 19                	jne    800750 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800737:	53                   	push   %ebx
  800738:	68 05 3f 80 00       	push   $0x803f05
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
  800751:	68 0e 3f 80 00       	push   $0x803f0e
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
  80077e:	be 11 3f 80 00       	mov    $0x803f11,%esi
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
  801189:	68 88 40 80 00       	push   $0x804088
  80118e:	68 3f 01 00 00       	push   $0x13f
  801193:	68 aa 40 80 00       	push   $0x8040aa
  801198:	e8 a5 25 00 00       	call   803742 <_panic>

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
  8011a9:	e8 35 0a 00 00       	call   801be3 <sys_sbrk>
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
  801224:	e8 3e 08 00 00       	call   801a67 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801229:	85 c0                	test   %eax,%eax
  80122b:	74 16                	je     801243 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 7e 0d 00 00       	call   801fb6 <alloc_block_FF>
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123e:	e9 8a 01 00 00       	jmp    8013cd <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801243:	e8 50 08 00 00       	call   801a98 <sys_isUHeapPlacementStrategyBESTFIT>
  801248:	85 c0                	test   %eax,%eax
  80124a:	0f 84 7d 01 00 00    	je     8013cd <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	ff 75 08             	pushl  0x8(%ebp)
  801256:	e8 17 12 00 00       	call   802472 <alloc_block_BF>
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
  8012a6:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  8012f3:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
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
  80134a:	c7 04 85 60 50 80 00 	movl   $0x1,0x805060(,%eax,4)
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
  8013ac:	89 04 95 60 50 88 00 	mov    %eax,0x885060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 08             	pushl  0x8(%ebp)
  8013b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8013bc:	e8 59 08 00 00       	call   801c1a <sys_allocate_user_mem>
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
  801404:	e8 2d 08 00 00       	call   801c36 <get_block_size>
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80140f:	83 ec 0c             	sub    $0xc,%esp
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	e8 60 1a 00 00       	call   802e7a <free_block>
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
  80144f:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
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
  80148c:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
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
  8014ac:	e8 4d 07 00 00       	call   801bfe <sys_free_user_mem>
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
  8014ba:	68 b8 40 80 00       	push   $0x8040b8
  8014bf:	68 84 00 00 00       	push   $0x84
  8014c4:	68 e2 40 80 00       	push   $0x8040e2
  8014c9:	e8 74 22 00 00       	call   803742 <_panic>
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
  8014e0:	75 07                	jne    8014e9 <smalloc+0x19>
  8014e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e7:	eb 74                	jmp    80155d <smalloc+0x8d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8014e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014ef:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fc:	39 d0                	cmp    %edx,%eax
  8014fe:	73 02                	jae    801502 <smalloc+0x32>
  801500:	89 d0                	mov    %edx,%eax
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	50                   	push   %eax
  801506:	e8 a8 fc ff ff       	call   8011b3 <malloc>
  80150b:	83 c4 10             	add    $0x10,%esp
  80150e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801511:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801515:	75 07                	jne    80151e <smalloc+0x4e>
  801517:	b8 00 00 00 00       	mov    $0x0,%eax
  80151c:	eb 3f                	jmp    80155d <smalloc+0x8d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80151e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801522:	ff 75 ec             	pushl  -0x14(%ebp)
  801525:	50                   	push   %eax
  801526:	ff 75 0c             	pushl  0xc(%ebp)
  801529:	ff 75 08             	pushl  0x8(%ebp)
  80152c:	e8 d4 02 00 00       	call   801805 <sys_createSharedObject>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801537:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80153b:	74 06                	je     801543 <smalloc+0x73>
  80153d:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801541:	75 07                	jne    80154a <smalloc+0x7a>
  801543:	b8 00 00 00 00       	mov    $0x0,%eax
  801548:	eb 13                	jmp    80155d <smalloc+0x8d>
	 cprintf("153\n");
  80154a:	83 ec 0c             	sub    $0xc,%esp
  80154d:	68 ee 40 80 00       	push   $0x8040ee
  801552:	e8 ac ee ff ff       	call   800403 <cprintf>
  801557:	83 c4 10             	add    $0x10,%esp
	 return ptr;
  80155a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80155d:	c9                   	leave  
  80155e:	c3                   	ret    

0080155f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801565:	83 ec 04             	sub    $0x4,%esp
  801568:	68 f4 40 80 00       	push   $0x8040f4
  80156d:	68 a4 00 00 00       	push   $0xa4
  801572:	68 e2 40 80 00       	push   $0x8040e2
  801577:	e8 c6 21 00 00       	call   803742 <_panic>

0080157c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 18 41 80 00       	push   $0x804118
  80158a:	68 bc 00 00 00       	push   $0xbc
  80158f:	68 e2 40 80 00       	push   $0x8040e2
  801594:	e8 a9 21 00 00       	call   803742 <_panic>

00801599 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80159f:	83 ec 04             	sub    $0x4,%esp
  8015a2:	68 3c 41 80 00       	push   $0x80413c
  8015a7:	68 d3 00 00 00       	push   $0xd3
  8015ac:	68 e2 40 80 00       	push   $0x8040e2
  8015b1:	e8 8c 21 00 00       	call   803742 <_panic>

008015b6 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	68 62 41 80 00       	push   $0x804162
  8015c4:	68 df 00 00 00       	push   $0xdf
  8015c9:	68 e2 40 80 00       	push   $0x8040e2
  8015ce:	e8 6f 21 00 00       	call   803742 <_panic>

008015d3 <shrink>:

}
void shrink(uint32 newSize)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	68 62 41 80 00       	push   $0x804162
  8015e1:	68 e4 00 00 00       	push   $0xe4
  8015e6:	68 e2 40 80 00       	push   $0x8040e2
  8015eb:	e8 52 21 00 00       	call   803742 <_panic>

008015f0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f6:	83 ec 04             	sub    $0x4,%esp
  8015f9:	68 62 41 80 00       	push   $0x804162
  8015fe:	68 e9 00 00 00       	push   $0xe9
  801603:	68 e2 40 80 00       	push   $0x8040e2
  801608:	e8 35 21 00 00       	call   803742 <_panic>

0080160d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	57                   	push   %edi
  801611:	56                   	push   %esi
  801612:	53                   	push   %ebx
  801613:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80161f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801622:	8b 7d 18             	mov    0x18(%ebp),%edi
  801625:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801628:	cd 30                	int    $0x30
  80162a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80162d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801630:	83 c4 10             	add    $0x10,%esp
  801633:	5b                   	pop    %ebx
  801634:	5e                   	pop    %esi
  801635:	5f                   	pop    %edi
  801636:	5d                   	pop    %ebp
  801637:	c3                   	ret    

00801638 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 04             	sub    $0x4,%esp
  80163e:	8b 45 10             	mov    0x10(%ebp),%eax
  801641:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801644:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	52                   	push   %edx
  801650:	ff 75 0c             	pushl  0xc(%ebp)
  801653:	50                   	push   %eax
  801654:	6a 00                	push   $0x0
  801656:	e8 b2 ff ff ff       	call   80160d <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	90                   	nop
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <sys_cgetc>:

int
sys_cgetc(void)
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 02                	push   $0x2
  801670:	e8 98 ff ff ff       	call   80160d <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 03                	push   $0x3
  801689:	e8 7f ff ff ff       	call   80160d <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	90                   	nop
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 04                	push   $0x4
  8016a3:	e8 65 ff ff ff       	call   80160d <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	90                   	nop
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	52                   	push   %edx
  8016be:	50                   	push   %eax
  8016bf:	6a 08                	push   $0x8
  8016c1:	e8 47 ff ff ff       	call   80160d <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	56                   	push   %esi
  8016cf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016d0:	8b 75 18             	mov    0x18(%ebp),%esi
  8016d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	56                   	push   %esi
  8016e0:	53                   	push   %ebx
  8016e1:	51                   	push   %ecx
  8016e2:	52                   	push   %edx
  8016e3:	50                   	push   %eax
  8016e4:	6a 09                	push   $0x9
  8016e6:	e8 22 ff ff ff       	call   80160d <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f1:	5b                   	pop    %ebx
  8016f2:	5e                   	pop    %esi
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    

008016f5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	52                   	push   %edx
  801705:	50                   	push   %eax
  801706:	6a 0a                	push   $0xa
  801708:	e8 00 ff ff ff       	call   80160d <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	ff 75 0c             	pushl  0xc(%ebp)
  80171e:	ff 75 08             	pushl  0x8(%ebp)
  801721:	6a 0b                	push   $0xb
  801723:	e8 e5 fe ff ff       	call   80160d <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 0c                	push   $0xc
  80173c:	e8 cc fe ff ff       	call   80160d <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 0d                	push   $0xd
  801755:	e8 b3 fe ff ff       	call   80160d <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 0e                	push   $0xe
  80176e:	e8 9a fe ff ff       	call   80160d <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 0f                	push   $0xf
  801787:	e8 81 fe ff ff       	call   80160d <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	ff 75 08             	pushl  0x8(%ebp)
  80179f:	6a 10                	push   $0x10
  8017a1:	e8 67 fe ff ff       	call   80160d <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 11                	push   $0x11
  8017ba:	e8 4e fe ff ff       	call   80160d <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	90                   	nop
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sys_cputc>:

void
sys_cputc(const char c)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 04             	sub    $0x4,%esp
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017d1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	50                   	push   %eax
  8017de:	6a 01                	push   $0x1
  8017e0:	e8 28 fe ff ff       	call   80160d <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 14                	push   $0x14
  8017fa:	e8 0e fe ff ff       	call   80160d <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	90                   	nop
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	8b 45 10             	mov    0x10(%ebp),%eax
  80180e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801811:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801814:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	6a 00                	push   $0x0
  80181d:	51                   	push   %ecx
  80181e:	52                   	push   %edx
  80181f:	ff 75 0c             	pushl  0xc(%ebp)
  801822:	50                   	push   %eax
  801823:	6a 15                	push   $0x15
  801825:	e8 e3 fd ff ff       	call   80160d <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801832:	8b 55 0c             	mov    0xc(%ebp),%edx
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	52                   	push   %edx
  80183f:	50                   	push   %eax
  801840:	6a 16                	push   $0x16
  801842:	e8 c6 fd ff ff       	call   80160d <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80184f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801852:	8b 55 0c             	mov    0xc(%ebp),%edx
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	51                   	push   %ecx
  80185d:	52                   	push   %edx
  80185e:	50                   	push   %eax
  80185f:	6a 17                	push   $0x17
  801861:	e8 a7 fd ff ff       	call   80160d <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80186e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	52                   	push   %edx
  80187b:	50                   	push   %eax
  80187c:	6a 18                	push   $0x18
  80187e:	e8 8a fd ff ff       	call   80160d <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	6a 00                	push   $0x0
  801890:	ff 75 14             	pushl  0x14(%ebp)
  801893:	ff 75 10             	pushl  0x10(%ebp)
  801896:	ff 75 0c             	pushl  0xc(%ebp)
  801899:	50                   	push   %eax
  80189a:	6a 19                	push   $0x19
  80189c:	e8 6c fd ff ff       	call   80160d <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	50                   	push   %eax
  8018b5:	6a 1a                	push   $0x1a
  8018b7:	e8 51 fd ff ff       	call   80160d <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	90                   	nop
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	50                   	push   %eax
  8018d1:	6a 1b                	push   $0x1b
  8018d3:	e8 35 fd ff ff       	call   80160d <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 05                	push   $0x5
  8018ec:	e8 1c fd ff ff       	call   80160d <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 06                	push   $0x6
  801905:	e8 03 fd ff ff       	call   80160d <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 07                	push   $0x7
  80191e:	e8 ea fc ff ff       	call   80160d <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_exit_env>:


void sys_exit_env(void)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 1c                	push   $0x1c
  801937:	e8 d1 fc ff ff       	call   80160d <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	90                   	nop
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801948:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80194b:	8d 50 04             	lea    0x4(%eax),%edx
  80194e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	52                   	push   %edx
  801958:	50                   	push   %eax
  801959:	6a 1d                	push   $0x1d
  80195b:	e8 ad fc ff ff       	call   80160d <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
	return result;
  801963:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801966:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801969:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80196c:	89 01                	mov    %eax,(%ecx)
  80196e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	c9                   	leave  
  801975:	c2 04 00             	ret    $0x4

00801978 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	ff 75 10             	pushl  0x10(%ebp)
  801982:	ff 75 0c             	pushl  0xc(%ebp)
  801985:	ff 75 08             	pushl  0x8(%ebp)
  801988:	6a 13                	push   $0x13
  80198a:	e8 7e fc ff ff       	call   80160d <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
	return ;
  801992:	90                   	nop
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_rcr2>:
uint32 sys_rcr2()
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 1e                	push   $0x1e
  8019a4:	e8 64 fc ff ff       	call   80160d <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019ba:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	50                   	push   %eax
  8019c7:	6a 1f                	push   $0x1f
  8019c9:	e8 3f fc ff ff       	call   80160d <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d1:	90                   	nop
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <rsttst>:
void rsttst()
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 21                	push   $0x21
  8019e3:	e8 25 fc ff ff       	call   80160d <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019eb:	90                   	nop
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 04             	sub    $0x4,%esp
  8019f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019fa:	8b 55 18             	mov    0x18(%ebp),%edx
  8019fd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a01:	52                   	push   %edx
  801a02:	50                   	push   %eax
  801a03:	ff 75 10             	pushl  0x10(%ebp)
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	ff 75 08             	pushl  0x8(%ebp)
  801a0c:	6a 20                	push   $0x20
  801a0e:	e8 fa fb ff ff       	call   80160d <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
	return ;
  801a16:	90                   	nop
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <chktst>:
void chktst(uint32 n)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	ff 75 08             	pushl  0x8(%ebp)
  801a27:	6a 22                	push   $0x22
  801a29:	e8 df fb ff ff       	call   80160d <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a31:	90                   	nop
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <inctst>:

void inctst()
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 23                	push   $0x23
  801a43:	e8 c5 fb ff ff       	call   80160d <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4b:	90                   	nop
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <gettst>:
uint32 gettst()
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 24                	push   $0x24
  801a5d:	e8 ab fb ff ff       	call   80160d <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 25                	push   $0x25
  801a79:	e8 8f fb ff ff       	call   80160d <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
  801a81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a84:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a88:	75 07                	jne    801a91 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8f:	eb 05                	jmp    801a96 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 25                	push   $0x25
  801aaa:	e8 5e fb ff ff       	call   80160d <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
  801ab2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ab5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ab9:	75 07                	jne    801ac2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801abb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac0:	eb 05                	jmp    801ac7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ac2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 25                	push   $0x25
  801adb:	e8 2d fb ff ff       	call   80160d <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
  801ae3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ae6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801aea:	75 07                	jne    801af3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801aec:	b8 01 00 00 00       	mov    $0x1,%eax
  801af1:	eb 05                	jmp    801af8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801af3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 25                	push   $0x25
  801b0c:	e8 fc fa ff ff       	call   80160d <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
  801b14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b17:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b1b:	75 07                	jne    801b24 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b22:	eb 05                	jmp    801b29 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	6a 26                	push   $0x26
  801b3b:	e8 cd fa ff ff       	call   80160d <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
	return ;
  801b43:	90                   	nop
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b4a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	6a 00                	push   $0x0
  801b58:	53                   	push   %ebx
  801b59:	51                   	push   %ecx
  801b5a:	52                   	push   %edx
  801b5b:	50                   	push   %eax
  801b5c:	6a 27                	push   $0x27
  801b5e:	e8 aa fa ff ff       	call   80160d <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	52                   	push   %edx
  801b7b:	50                   	push   %eax
  801b7c:	6a 28                	push   $0x28
  801b7e:	e8 8a fa ff ff       	call   80160d <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801b8b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	6a 00                	push   $0x0
  801b96:	51                   	push   %ecx
  801b97:	ff 75 10             	pushl  0x10(%ebp)
  801b9a:	52                   	push   %edx
  801b9b:	50                   	push   %eax
  801b9c:	6a 29                	push   $0x29
  801b9e:	e8 6a fa ff ff       	call   80160d <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	ff 75 10             	pushl  0x10(%ebp)
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	6a 12                	push   $0x12
  801bba:	e8 4e fa ff ff       	call   80160d <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc2:	90                   	nop
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801bc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	52                   	push   %edx
  801bd5:	50                   	push   %eax
  801bd6:	6a 2a                	push   $0x2a
  801bd8:	e8 30 fa ff ff       	call   80160d <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
	return;
  801be0:	90                   	nop
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	50                   	push   %eax
  801bf2:	6a 2b                	push   $0x2b
  801bf4:	e8 14 fa ff ff       	call   80160d <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	ff 75 08             	pushl  0x8(%ebp)
  801c0d:	6a 2c                	push   $0x2c
  801c0f:	e8 f9 f9 ff ff       	call   80160d <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
	return;
  801c17:	90                   	nop
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	ff 75 08             	pushl  0x8(%ebp)
  801c29:	6a 2d                	push   $0x2d
  801c2b:	e8 dd f9 ff ff       	call   80160d <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
	return;
  801c33:	90                   	nop
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	83 e8 04             	sub    $0x4,%eax
  801c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c48:	8b 00                	mov    (%eax),%eax
  801c4a:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	83 e8 04             	sub    $0x4,%eax
  801c5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c61:	8b 00                	mov    (%eax),%eax
  801c63:	83 e0 01             	and    $0x1,%eax
  801c66:	85 c0                	test   %eax,%eax
  801c68:	0f 94 c0             	sete   %al
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801c73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7d:	83 f8 02             	cmp    $0x2,%eax
  801c80:	74 2b                	je     801cad <alloc_block+0x40>
  801c82:	83 f8 02             	cmp    $0x2,%eax
  801c85:	7f 07                	jg     801c8e <alloc_block+0x21>
  801c87:	83 f8 01             	cmp    $0x1,%eax
  801c8a:	74 0e                	je     801c9a <alloc_block+0x2d>
  801c8c:	eb 58                	jmp    801ce6 <alloc_block+0x79>
  801c8e:	83 f8 03             	cmp    $0x3,%eax
  801c91:	74 2d                	je     801cc0 <alloc_block+0x53>
  801c93:	83 f8 04             	cmp    $0x4,%eax
  801c96:	74 3b                	je     801cd3 <alloc_block+0x66>
  801c98:	eb 4c                	jmp    801ce6 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801c9a:	83 ec 0c             	sub    $0xc,%esp
  801c9d:	ff 75 08             	pushl  0x8(%ebp)
  801ca0:	e8 11 03 00 00       	call   801fb6 <alloc_block_FF>
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cab:	eb 4a                	jmp    801cf7 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801cad:	83 ec 0c             	sub    $0xc,%esp
  801cb0:	ff 75 08             	pushl  0x8(%ebp)
  801cb3:	e8 fa 19 00 00       	call   8036b2 <alloc_block_NF>
  801cb8:	83 c4 10             	add    $0x10,%esp
  801cbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cbe:	eb 37                	jmp    801cf7 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801cc0:	83 ec 0c             	sub    $0xc,%esp
  801cc3:	ff 75 08             	pushl  0x8(%ebp)
  801cc6:	e8 a7 07 00 00       	call   802472 <alloc_block_BF>
  801ccb:	83 c4 10             	add    $0x10,%esp
  801cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801cd1:	eb 24                	jmp    801cf7 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	ff 75 08             	pushl  0x8(%ebp)
  801cd9:	e8 b7 19 00 00       	call   803695 <alloc_block_WF>
  801cde:	83 c4 10             	add    $0x10,%esp
  801ce1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801ce4:	eb 11                	jmp    801cf7 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801ce6:	83 ec 0c             	sub    $0xc,%esp
  801ce9:	68 74 41 80 00       	push   $0x804174
  801cee:	e8 10 e7 ff ff       	call   800403 <cprintf>
  801cf3:	83 c4 10             	add    $0x10,%esp
		break;
  801cf6:	90                   	nop
	}
	return va;
  801cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	53                   	push   %ebx
  801d00:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801d03:	83 ec 0c             	sub    $0xc,%esp
  801d06:	68 94 41 80 00       	push   $0x804194
  801d0b:	e8 f3 e6 ff ff       	call   800403 <cprintf>
  801d10:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	68 bf 41 80 00       	push   $0x8041bf
  801d1b:	e8 e3 e6 ff ff       	call   800403 <cprintf>
  801d20:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d29:	eb 37                	jmp    801d62 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d2b:	83 ec 0c             	sub    $0xc,%esp
  801d2e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d31:	e8 19 ff ff ff       	call   801c4f <is_free_block>
  801d36:	83 c4 10             	add    $0x10,%esp
  801d39:	0f be d8             	movsbl %al,%ebx
  801d3c:	83 ec 0c             	sub    $0xc,%esp
  801d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d42:	e8 ef fe ff ff       	call   801c36 <get_block_size>
  801d47:	83 c4 10             	add    $0x10,%esp
  801d4a:	83 ec 04             	sub    $0x4,%esp
  801d4d:	53                   	push   %ebx
  801d4e:	50                   	push   %eax
  801d4f:	68 d7 41 80 00       	push   $0x8041d7
  801d54:	e8 aa e6 ff ff       	call   800403 <cprintf>
  801d59:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d66:	74 07                	je     801d6f <print_blocks_list+0x73>
  801d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6b:	8b 00                	mov    (%eax),%eax
  801d6d:	eb 05                	jmp    801d74 <print_blocks_list+0x78>
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d74:	89 45 10             	mov    %eax,0x10(%ebp)
  801d77:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	75 ad                	jne    801d2b <print_blocks_list+0x2f>
  801d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d82:	75 a7                	jne    801d2b <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801d84:	83 ec 0c             	sub    $0xc,%esp
  801d87:	68 94 41 80 00       	push   $0x804194
  801d8c:	e8 72 e6 ff ff       	call   800403 <cprintf>
  801d91:	83 c4 10             	add    $0x10,%esp

}
  801d94:	90                   	nop
  801d95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da3:	83 e0 01             	and    $0x1,%eax
  801da6:	85 c0                	test   %eax,%eax
  801da8:	74 03                	je     801dad <initialize_dynamic_allocator+0x13>
  801daa:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801dad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801db1:	0f 84 c7 01 00 00    	je     801f7e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801db7:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801dbe:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc7:	01 d0                	add    %edx,%eax
  801dc9:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801dce:	0f 87 ad 01 00 00    	ja     801f81 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	0f 89 a5 01 00 00    	jns    801f84 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  801de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de5:	01 d0                	add    %edx,%eax
  801de7:	83 e8 04             	sub    $0x4,%eax
  801dea:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801def:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801df6:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfe:	e9 87 00 00 00       	jmp    801e8a <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801e03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e07:	75 14                	jne    801e1d <initialize_dynamic_allocator+0x83>
  801e09:	83 ec 04             	sub    $0x4,%esp
  801e0c:	68 ef 41 80 00       	push   $0x8041ef
  801e11:	6a 79                	push   $0x79
  801e13:	68 0d 42 80 00       	push   $0x80420d
  801e18:	e8 25 19 00 00       	call   803742 <_panic>
  801e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e20:	8b 00                	mov    (%eax),%eax
  801e22:	85 c0                	test   %eax,%eax
  801e24:	74 10                	je     801e36 <initialize_dynamic_allocator+0x9c>
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	8b 00                	mov    (%eax),%eax
  801e2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2e:	8b 52 04             	mov    0x4(%edx),%edx
  801e31:	89 50 04             	mov    %edx,0x4(%eax)
  801e34:	eb 0b                	jmp    801e41 <initialize_dynamic_allocator+0xa7>
  801e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e39:	8b 40 04             	mov    0x4(%eax),%eax
  801e3c:	a3 30 50 80 00       	mov    %eax,0x805030
  801e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e44:	8b 40 04             	mov    0x4(%eax),%eax
  801e47:	85 c0                	test   %eax,%eax
  801e49:	74 0f                	je     801e5a <initialize_dynamic_allocator+0xc0>
  801e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4e:	8b 40 04             	mov    0x4(%eax),%eax
  801e51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e54:	8b 12                	mov    (%edx),%edx
  801e56:	89 10                	mov    %edx,(%eax)
  801e58:	eb 0a                	jmp    801e64 <initialize_dynamic_allocator+0xca>
  801e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5d:	8b 00                	mov    (%eax),%eax
  801e5f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e77:	a1 38 50 80 00       	mov    0x805038,%eax
  801e7c:	48                   	dec    %eax
  801e7d:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801e82:	a1 34 50 80 00       	mov    0x805034,%eax
  801e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e8e:	74 07                	je     801e97 <initialize_dynamic_allocator+0xfd>
  801e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e93:	8b 00                	mov    (%eax),%eax
  801e95:	eb 05                	jmp    801e9c <initialize_dynamic_allocator+0x102>
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9c:	a3 34 50 80 00       	mov    %eax,0x805034
  801ea1:	a1 34 50 80 00       	mov    0x805034,%eax
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	0f 85 55 ff ff ff    	jne    801e03 <initialize_dynamic_allocator+0x69>
  801eae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb2:	0f 85 4b ff ff ff    	jne    801e03 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801ec7:	a1 44 50 80 00       	mov    0x805044,%eax
  801ecc:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801ed1:	a1 40 50 80 00       	mov    0x805040,%eax
  801ed6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	83 c0 08             	add    $0x8,%eax
  801ee2:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	83 c0 04             	add    $0x4,%eax
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eee:	83 ea 08             	sub    $0x8,%edx
  801ef1:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801ef3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef9:	01 d0                	add    %edx,%eax
  801efb:	83 e8 08             	sub    $0x8,%eax
  801efe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f01:	83 ea 08             	sub    $0x8,%edx
  801f04:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f19:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f1d:	75 17                	jne    801f36 <initialize_dynamic_allocator+0x19c>
  801f1f:	83 ec 04             	sub    $0x4,%esp
  801f22:	68 28 42 80 00       	push   $0x804228
  801f27:	68 90 00 00 00       	push   $0x90
  801f2c:	68 0d 42 80 00       	push   $0x80420d
  801f31:	e8 0c 18 00 00       	call   803742 <_panic>
  801f36:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3f:	89 10                	mov    %edx,(%eax)
  801f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f44:	8b 00                	mov    (%eax),%eax
  801f46:	85 c0                	test   %eax,%eax
  801f48:	74 0d                	je     801f57 <initialize_dynamic_allocator+0x1bd>
  801f4a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f52:	89 50 04             	mov    %edx,0x4(%eax)
  801f55:	eb 08                	jmp    801f5f <initialize_dynamic_allocator+0x1c5>
  801f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f5a:	a3 30 50 80 00       	mov    %eax,0x805030
  801f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f62:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f71:	a1 38 50 80 00       	mov    0x805038,%eax
  801f76:	40                   	inc    %eax
  801f77:	a3 38 50 80 00       	mov    %eax,0x805038
  801f7c:	eb 07                	jmp    801f85 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801f7e:	90                   	nop
  801f7f:	eb 04                	jmp    801f85 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801f81:	90                   	nop
  801f82:	eb 01                	jmp    801f85 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801f84:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8d:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	8d 50 fc             	lea    -0x4(%eax),%edx
  801f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f99:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	83 e8 04             	sub    $0x4,%eax
  801fa1:	8b 00                	mov    (%eax),%eax
  801fa3:	83 e0 fe             	and    $0xfffffffe,%eax
  801fa6:	8d 50 f8             	lea    -0x8(%eax),%edx
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	01 c2                	add    %eax,%edx
  801fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb1:	89 02                	mov    %eax,(%edx)
}
  801fb3:	90                   	nop
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    

00801fb6 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	83 e0 01             	and    $0x1,%eax
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	74 03                	je     801fc9 <alloc_block_FF+0x13>
  801fc6:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  801fc9:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  801fcd:	77 07                	ja     801fd6 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  801fcf:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  801fd6:	a1 24 50 80 00       	mov    0x805024,%eax
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	75 73                	jne    802052 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	83 c0 10             	add    $0x10,%eax
  801fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  801fe8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff5:	01 d0                	add    %edx,%eax
  801ff7:	48                   	dec    %eax
  801ff8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ffe:	ba 00 00 00 00       	mov    $0x0,%edx
  802003:	f7 75 ec             	divl   -0x14(%ebp)
  802006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802009:	29 d0                	sub    %edx,%eax
  80200b:	c1 e8 0c             	shr    $0xc,%eax
  80200e:	83 ec 0c             	sub    $0xc,%esp
  802011:	50                   	push   %eax
  802012:	e8 86 f1 ff ff       	call   80119d <sbrk>
  802017:	83 c4 10             	add    $0x10,%esp
  80201a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80201d:	83 ec 0c             	sub    $0xc,%esp
  802020:	6a 00                	push   $0x0
  802022:	e8 76 f1 ff ff       	call   80119d <sbrk>
  802027:	83 c4 10             	add    $0x10,%esp
  80202a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80202d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802030:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802033:	83 ec 08             	sub    $0x8,%esp
  802036:	50                   	push   %eax
  802037:	ff 75 e4             	pushl  -0x1c(%ebp)
  80203a:	e8 5b fd ff ff       	call   801d9a <initialize_dynamic_allocator>
  80203f:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802042:	83 ec 0c             	sub    $0xc,%esp
  802045:	68 4b 42 80 00       	push   $0x80424b
  80204a:	e8 b4 e3 ff ff       	call   800403 <cprintf>
  80204f:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802052:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802056:	75 0a                	jne    802062 <alloc_block_FF+0xac>
	        return NULL;
  802058:	b8 00 00 00 00       	mov    $0x0,%eax
  80205d:	e9 0e 04 00 00       	jmp    802470 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802062:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802069:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80206e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802071:	e9 f3 02 00 00       	jmp    802369 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802079:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80207c:	83 ec 0c             	sub    $0xc,%esp
  80207f:	ff 75 bc             	pushl  -0x44(%ebp)
  802082:	e8 af fb ff ff       	call   801c36 <get_block_size>
  802087:	83 c4 10             	add    $0x10,%esp
  80208a:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	83 c0 08             	add    $0x8,%eax
  802093:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802096:	0f 87 c5 02 00 00    	ja     802361 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	83 c0 18             	add    $0x18,%eax
  8020a2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020a5:	0f 87 19 02 00 00    	ja     8022c4 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  8020ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8020ae:	2b 45 08             	sub    0x8(%ebp),%eax
  8020b1:	83 e8 08             	sub    $0x8,%eax
  8020b4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	8d 50 08             	lea    0x8(%eax),%edx
  8020bd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8020c0:	01 d0                	add    %edx,%eax
  8020c2:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	83 c0 08             	add    $0x8,%eax
  8020cb:	83 ec 04             	sub    $0x4,%esp
  8020ce:	6a 01                	push   $0x1
  8020d0:	50                   	push   %eax
  8020d1:	ff 75 bc             	pushl  -0x44(%ebp)
  8020d4:	e8 ae fe ff ff       	call   801f87 <set_block_data>
  8020d9:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  8020dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020df:	8b 40 04             	mov    0x4(%eax),%eax
  8020e2:	85 c0                	test   %eax,%eax
  8020e4:	75 68                	jne    80214e <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8020e6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8020ea:	75 17                	jne    802103 <alloc_block_FF+0x14d>
  8020ec:	83 ec 04             	sub    $0x4,%esp
  8020ef:	68 28 42 80 00       	push   $0x804228
  8020f4:	68 d7 00 00 00       	push   $0xd7
  8020f9:	68 0d 42 80 00       	push   $0x80420d
  8020fe:	e8 3f 16 00 00       	call   803742 <_panic>
  802103:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802109:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80210c:	89 10                	mov    %edx,(%eax)
  80210e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802111:	8b 00                	mov    (%eax),%eax
  802113:	85 c0                	test   %eax,%eax
  802115:	74 0d                	je     802124 <alloc_block_FF+0x16e>
  802117:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80211c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80211f:	89 50 04             	mov    %edx,0x4(%eax)
  802122:	eb 08                	jmp    80212c <alloc_block_FF+0x176>
  802124:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802127:	a3 30 50 80 00       	mov    %eax,0x805030
  80212c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80212f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802134:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802137:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80213e:	a1 38 50 80 00       	mov    0x805038,%eax
  802143:	40                   	inc    %eax
  802144:	a3 38 50 80 00       	mov    %eax,0x805038
  802149:	e9 dc 00 00 00       	jmp    80222a <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	8b 00                	mov    (%eax),%eax
  802153:	85 c0                	test   %eax,%eax
  802155:	75 65                	jne    8021bc <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802157:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80215b:	75 17                	jne    802174 <alloc_block_FF+0x1be>
  80215d:	83 ec 04             	sub    $0x4,%esp
  802160:	68 5c 42 80 00       	push   $0x80425c
  802165:	68 db 00 00 00       	push   $0xdb
  80216a:	68 0d 42 80 00       	push   $0x80420d
  80216f:	e8 ce 15 00 00       	call   803742 <_panic>
  802174:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80217a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80217d:	89 50 04             	mov    %edx,0x4(%eax)
  802180:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802183:	8b 40 04             	mov    0x4(%eax),%eax
  802186:	85 c0                	test   %eax,%eax
  802188:	74 0c                	je     802196 <alloc_block_FF+0x1e0>
  80218a:	a1 30 50 80 00       	mov    0x805030,%eax
  80218f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802192:	89 10                	mov    %edx,(%eax)
  802194:	eb 08                	jmp    80219e <alloc_block_FF+0x1e8>
  802196:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802199:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80219e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021a1:	a3 30 50 80 00       	mov    %eax,0x805030
  8021a6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021af:	a1 38 50 80 00       	mov    0x805038,%eax
  8021b4:	40                   	inc    %eax
  8021b5:	a3 38 50 80 00       	mov    %eax,0x805038
  8021ba:	eb 6e                	jmp    80222a <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  8021bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c0:	74 06                	je     8021c8 <alloc_block_FF+0x212>
  8021c2:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021c6:	75 17                	jne    8021df <alloc_block_FF+0x229>
  8021c8:	83 ec 04             	sub    $0x4,%esp
  8021cb:	68 80 42 80 00       	push   $0x804280
  8021d0:	68 df 00 00 00       	push   $0xdf
  8021d5:	68 0d 42 80 00       	push   $0x80420d
  8021da:	e8 63 15 00 00       	call   803742 <_panic>
  8021df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e2:	8b 10                	mov    (%eax),%edx
  8021e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e7:	89 10                	mov    %edx,(%eax)
  8021e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021ec:	8b 00                	mov    (%eax),%eax
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	74 0b                	je     8021fd <alloc_block_FF+0x247>
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	8b 00                	mov    (%eax),%eax
  8021f7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021fa:	89 50 04             	mov    %edx,0x4(%eax)
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802203:	89 10                	mov    %edx,(%eax)
  802205:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220b:	89 50 04             	mov    %edx,0x4(%eax)
  80220e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802211:	8b 00                	mov    (%eax),%eax
  802213:	85 c0                	test   %eax,%eax
  802215:	75 08                	jne    80221f <alloc_block_FF+0x269>
  802217:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80221a:	a3 30 50 80 00       	mov    %eax,0x805030
  80221f:	a1 38 50 80 00       	mov    0x805038,%eax
  802224:	40                   	inc    %eax
  802225:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  80222a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222e:	75 17                	jne    802247 <alloc_block_FF+0x291>
  802230:	83 ec 04             	sub    $0x4,%esp
  802233:	68 ef 41 80 00       	push   $0x8041ef
  802238:	68 e1 00 00 00       	push   $0xe1
  80223d:	68 0d 42 80 00       	push   $0x80420d
  802242:	e8 fb 14 00 00       	call   803742 <_panic>
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	8b 00                	mov    (%eax),%eax
  80224c:	85 c0                	test   %eax,%eax
  80224e:	74 10                	je     802260 <alloc_block_FF+0x2aa>
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	8b 00                	mov    (%eax),%eax
  802255:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802258:	8b 52 04             	mov    0x4(%edx),%edx
  80225b:	89 50 04             	mov    %edx,0x4(%eax)
  80225e:	eb 0b                	jmp    80226b <alloc_block_FF+0x2b5>
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	8b 40 04             	mov    0x4(%eax),%eax
  802266:	a3 30 50 80 00       	mov    %eax,0x805030
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 40 04             	mov    0x4(%eax),%eax
  802271:	85 c0                	test   %eax,%eax
  802273:	74 0f                	je     802284 <alloc_block_FF+0x2ce>
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	8b 40 04             	mov    0x4(%eax),%eax
  80227b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227e:	8b 12                	mov    (%edx),%edx
  802280:	89 10                	mov    %edx,(%eax)
  802282:	eb 0a                	jmp    80228e <alloc_block_FF+0x2d8>
  802284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802287:	8b 00                	mov    (%eax),%eax
  802289:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a1:	a1 38 50 80 00       	mov    0x805038,%eax
  8022a6:	48                   	dec    %eax
  8022a7:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  8022ac:	83 ec 04             	sub    $0x4,%esp
  8022af:	6a 00                	push   $0x0
  8022b1:	ff 75 b4             	pushl  -0x4c(%ebp)
  8022b4:	ff 75 b0             	pushl  -0x50(%ebp)
  8022b7:	e8 cb fc ff ff       	call   801f87 <set_block_data>
  8022bc:	83 c4 10             	add    $0x10,%esp
  8022bf:	e9 95 00 00 00       	jmp    802359 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	6a 01                	push   $0x1
  8022c9:	ff 75 b8             	pushl  -0x48(%ebp)
  8022cc:	ff 75 bc             	pushl  -0x44(%ebp)
  8022cf:	e8 b3 fc ff ff       	call   801f87 <set_block_data>
  8022d4:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  8022d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022db:	75 17                	jne    8022f4 <alloc_block_FF+0x33e>
  8022dd:	83 ec 04             	sub    $0x4,%esp
  8022e0:	68 ef 41 80 00       	push   $0x8041ef
  8022e5:	68 e8 00 00 00       	push   $0xe8
  8022ea:	68 0d 42 80 00       	push   $0x80420d
  8022ef:	e8 4e 14 00 00       	call   803742 <_panic>
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 00                	mov    (%eax),%eax
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	74 10                	je     80230d <alloc_block_FF+0x357>
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 00                	mov    (%eax),%eax
  802302:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802305:	8b 52 04             	mov    0x4(%edx),%edx
  802308:	89 50 04             	mov    %edx,0x4(%eax)
  80230b:	eb 0b                	jmp    802318 <alloc_block_FF+0x362>
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 40 04             	mov    0x4(%eax),%eax
  802313:	a3 30 50 80 00       	mov    %eax,0x805030
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 40 04             	mov    0x4(%eax),%eax
  80231e:	85 c0                	test   %eax,%eax
  802320:	74 0f                	je     802331 <alloc_block_FF+0x37b>
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	8b 40 04             	mov    0x4(%eax),%eax
  802328:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232b:	8b 12                	mov    (%edx),%edx
  80232d:	89 10                	mov    %edx,(%eax)
  80232f:	eb 0a                	jmp    80233b <alloc_block_FF+0x385>
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 00                	mov    (%eax),%eax
  802336:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80234e:	a1 38 50 80 00       	mov    0x805038,%eax
  802353:	48                   	dec    %eax
  802354:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  802359:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80235c:	e9 0f 01 00 00       	jmp    802470 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802361:	a1 34 50 80 00       	mov    0x805034,%eax
  802366:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236d:	74 07                	je     802376 <alloc_block_FF+0x3c0>
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	8b 00                	mov    (%eax),%eax
  802374:	eb 05                	jmp    80237b <alloc_block_FF+0x3c5>
  802376:	b8 00 00 00 00       	mov    $0x0,%eax
  80237b:	a3 34 50 80 00       	mov    %eax,0x805034
  802380:	a1 34 50 80 00       	mov    0x805034,%eax
  802385:	85 c0                	test   %eax,%eax
  802387:	0f 85 e9 fc ff ff    	jne    802076 <alloc_block_FF+0xc0>
  80238d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802391:	0f 85 df fc ff ff    	jne    802076 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	83 c0 08             	add    $0x8,%eax
  80239d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8023a0:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8023a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8023ad:	01 d0                	add    %edx,%eax
  8023af:	48                   	dec    %eax
  8023b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8023b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8023bb:	f7 75 d8             	divl   -0x28(%ebp)
  8023be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023c1:	29 d0                	sub    %edx,%eax
  8023c3:	c1 e8 0c             	shr    $0xc,%eax
  8023c6:	83 ec 0c             	sub    $0xc,%esp
  8023c9:	50                   	push   %eax
  8023ca:	e8 ce ed ff ff       	call   80119d <sbrk>
  8023cf:	83 c4 10             	add    $0x10,%esp
  8023d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  8023d5:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8023d9:	75 0a                	jne    8023e5 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e0:	e9 8b 00 00 00       	jmp    802470 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8023e5:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8023ec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8023ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8023f2:	01 d0                	add    %edx,%eax
  8023f4:	48                   	dec    %eax
  8023f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8023f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802400:	f7 75 cc             	divl   -0x34(%ebp)
  802403:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802406:	29 d0                	sub    %edx,%eax
  802408:	8d 50 fc             	lea    -0x4(%eax),%edx
  80240b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80240e:	01 d0                	add    %edx,%eax
  802410:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802415:	a1 40 50 80 00       	mov    0x805040,%eax
  80241a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802420:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802427:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80242a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80242d:	01 d0                	add    %edx,%eax
  80242f:	48                   	dec    %eax
  802430:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802433:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802436:	ba 00 00 00 00       	mov    $0x0,%edx
  80243b:	f7 75 c4             	divl   -0x3c(%ebp)
  80243e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802441:	29 d0                	sub    %edx,%eax
  802443:	83 ec 04             	sub    $0x4,%esp
  802446:	6a 01                	push   $0x1
  802448:	50                   	push   %eax
  802449:	ff 75 d0             	pushl  -0x30(%ebp)
  80244c:	e8 36 fb ff ff       	call   801f87 <set_block_data>
  802451:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802454:	83 ec 0c             	sub    $0xc,%esp
  802457:	ff 75 d0             	pushl  -0x30(%ebp)
  80245a:	e8 1b 0a 00 00       	call   802e7a <free_block>
  80245f:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802462:	83 ec 0c             	sub    $0xc,%esp
  802465:	ff 75 08             	pushl  0x8(%ebp)
  802468:	e8 49 fb ff ff       	call   801fb6 <alloc_block_FF>
  80246d:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	83 e0 01             	and    $0x1,%eax
  80247e:	85 c0                	test   %eax,%eax
  802480:	74 03                	je     802485 <alloc_block_BF+0x13>
  802482:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802485:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802489:	77 07                	ja     802492 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80248b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802492:	a1 24 50 80 00       	mov    0x805024,%eax
  802497:	85 c0                	test   %eax,%eax
  802499:	75 73                	jne    80250e <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	83 c0 10             	add    $0x10,%eax
  8024a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024a4:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8024ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b1:	01 d0                	add    %edx,%eax
  8024b3:	48                   	dec    %eax
  8024b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8024b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8024bf:	f7 75 e0             	divl   -0x20(%ebp)
  8024c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024c5:	29 d0                	sub    %edx,%eax
  8024c7:	c1 e8 0c             	shr    $0xc,%eax
  8024ca:	83 ec 0c             	sub    $0xc,%esp
  8024cd:	50                   	push   %eax
  8024ce:	e8 ca ec ff ff       	call   80119d <sbrk>
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024d9:	83 ec 0c             	sub    $0xc,%esp
  8024dc:	6a 00                	push   $0x0
  8024de:	e8 ba ec ff ff       	call   80119d <sbrk>
  8024e3:	83 c4 10             	add    $0x10,%esp
  8024e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024ec:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8024ef:	83 ec 08             	sub    $0x8,%esp
  8024f2:	50                   	push   %eax
  8024f3:	ff 75 d8             	pushl  -0x28(%ebp)
  8024f6:	e8 9f f8 ff ff       	call   801d9a <initialize_dynamic_allocator>
  8024fb:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8024fe:	83 ec 0c             	sub    $0xc,%esp
  802501:	68 4b 42 80 00       	push   $0x80424b
  802506:	e8 f8 de ff ff       	call   800403 <cprintf>
  80250b:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80250e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802515:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80251c:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802523:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  80252a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80252f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802532:	e9 1d 01 00 00       	jmp    802654 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80253d:	83 ec 0c             	sub    $0xc,%esp
  802540:	ff 75 a8             	pushl  -0x58(%ebp)
  802543:	e8 ee f6 ff ff       	call   801c36 <get_block_size>
  802548:	83 c4 10             	add    $0x10,%esp
  80254b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	83 c0 08             	add    $0x8,%eax
  802554:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802557:	0f 87 ef 00 00 00    	ja     80264c <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80255d:	8b 45 08             	mov    0x8(%ebp),%eax
  802560:	83 c0 18             	add    $0x18,%eax
  802563:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802566:	77 1d                	ja     802585 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80256e:	0f 86 d8 00 00 00    	jbe    80264c <alloc_block_BF+0x1da>
				{
					best_va = va;
  802574:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802577:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80257a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80257d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802580:	e9 c7 00 00 00       	jmp    80264c <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802585:	8b 45 08             	mov    0x8(%ebp),%eax
  802588:	83 c0 08             	add    $0x8,%eax
  80258b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80258e:	0f 85 9d 00 00 00    	jne    802631 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	6a 01                	push   $0x1
  802599:	ff 75 a4             	pushl  -0x5c(%ebp)
  80259c:	ff 75 a8             	pushl  -0x58(%ebp)
  80259f:	e8 e3 f9 ff ff       	call   801f87 <set_block_data>
  8025a4:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8025a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ab:	75 17                	jne    8025c4 <alloc_block_BF+0x152>
  8025ad:	83 ec 04             	sub    $0x4,%esp
  8025b0:	68 ef 41 80 00       	push   $0x8041ef
  8025b5:	68 2c 01 00 00       	push   $0x12c
  8025ba:	68 0d 42 80 00       	push   $0x80420d
  8025bf:	e8 7e 11 00 00       	call   803742 <_panic>
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	74 10                	je     8025dd <alloc_block_BF+0x16b>
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d5:	8b 52 04             	mov    0x4(%edx),%edx
  8025d8:	89 50 04             	mov    %edx,0x4(%eax)
  8025db:	eb 0b                	jmp    8025e8 <alloc_block_BF+0x176>
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	8b 40 04             	mov    0x4(%eax),%eax
  8025e3:	a3 30 50 80 00       	mov    %eax,0x805030
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ee:	85 c0                	test   %eax,%eax
  8025f0:	74 0f                	je     802601 <alloc_block_BF+0x18f>
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 40 04             	mov    0x4(%eax),%eax
  8025f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fb:	8b 12                	mov    (%edx),%edx
  8025fd:	89 10                	mov    %edx,(%eax)
  8025ff:	eb 0a                	jmp    80260b <alloc_block_BF+0x199>
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 00                	mov    (%eax),%eax
  802606:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261e:	a1 38 50 80 00       	mov    0x805038,%eax
  802623:	48                   	dec    %eax
  802624:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802629:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80262c:	e9 24 04 00 00       	jmp    802a55 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802634:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802637:	76 13                	jbe    80264c <alloc_block_BF+0x1da>
					{
						internal = 1;
  802639:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802640:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802643:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  802646:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802649:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  80264c:	a1 34 50 80 00       	mov    0x805034,%eax
  802651:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802654:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802658:	74 07                	je     802661 <alloc_block_BF+0x1ef>
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 00                	mov    (%eax),%eax
  80265f:	eb 05                	jmp    802666 <alloc_block_BF+0x1f4>
  802661:	b8 00 00 00 00       	mov    $0x0,%eax
  802666:	a3 34 50 80 00       	mov    %eax,0x805034
  80266b:	a1 34 50 80 00       	mov    0x805034,%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	0f 85 bf fe ff ff    	jne    802537 <alloc_block_BF+0xc5>
  802678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267c:	0f 85 b5 fe ff ff    	jne    802537 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802682:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802686:	0f 84 26 02 00 00    	je     8028b2 <alloc_block_BF+0x440>
  80268c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802690:	0f 85 1c 02 00 00    	jne    8028b2 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802699:	2b 45 08             	sub    0x8(%ebp),%eax
  80269c:	83 e8 08             	sub    $0x8,%eax
  80269f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	8d 50 08             	lea    0x8(%eax),%edx
  8026a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ab:	01 d0                	add    %edx,%eax
  8026ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	83 c0 08             	add    $0x8,%eax
  8026b6:	83 ec 04             	sub    $0x4,%esp
  8026b9:	6a 01                	push   $0x1
  8026bb:	50                   	push   %eax
  8026bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8026bf:	e8 c3 f8 ff ff       	call   801f87 <set_block_data>
  8026c4:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  8026c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	75 68                	jne    802739 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  8026d1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8026d5:	75 17                	jne    8026ee <alloc_block_BF+0x27c>
  8026d7:	83 ec 04             	sub    $0x4,%esp
  8026da:	68 28 42 80 00       	push   $0x804228
  8026df:	68 45 01 00 00       	push   $0x145
  8026e4:	68 0d 42 80 00       	push   $0x80420d
  8026e9:	e8 54 10 00 00       	call   803742 <_panic>
  8026ee:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8026f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026f7:	89 10                	mov    %edx,(%eax)
  8026f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	85 c0                	test   %eax,%eax
  802700:	74 0d                	je     80270f <alloc_block_BF+0x29d>
  802702:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802707:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80270a:	89 50 04             	mov    %edx,0x4(%eax)
  80270d:	eb 08                	jmp    802717 <alloc_block_BF+0x2a5>
  80270f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802712:	a3 30 50 80 00       	mov    %eax,0x805030
  802717:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80271a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80271f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802722:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802729:	a1 38 50 80 00       	mov    0x805038,%eax
  80272e:	40                   	inc    %eax
  80272f:	a3 38 50 80 00       	mov    %eax,0x805038
  802734:	e9 dc 00 00 00       	jmp    802815 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	75 65                	jne    8027a7 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802742:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802746:	75 17                	jne    80275f <alloc_block_BF+0x2ed>
  802748:	83 ec 04             	sub    $0x4,%esp
  80274b:	68 5c 42 80 00       	push   $0x80425c
  802750:	68 4a 01 00 00       	push   $0x14a
  802755:	68 0d 42 80 00       	push   $0x80420d
  80275a:	e8 e3 0f 00 00       	call   803742 <_panic>
  80275f:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802765:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802768:	89 50 04             	mov    %edx,0x4(%eax)
  80276b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80276e:	8b 40 04             	mov    0x4(%eax),%eax
  802771:	85 c0                	test   %eax,%eax
  802773:	74 0c                	je     802781 <alloc_block_BF+0x30f>
  802775:	a1 30 50 80 00       	mov    0x805030,%eax
  80277a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80277d:	89 10                	mov    %edx,(%eax)
  80277f:	eb 08                	jmp    802789 <alloc_block_BF+0x317>
  802781:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802784:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802789:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80278c:	a3 30 50 80 00       	mov    %eax,0x805030
  802791:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802794:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279a:	a1 38 50 80 00       	mov    0x805038,%eax
  80279f:	40                   	inc    %eax
  8027a0:	a3 38 50 80 00       	mov    %eax,0x805038
  8027a5:	eb 6e                	jmp    802815 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8027a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ab:	74 06                	je     8027b3 <alloc_block_BF+0x341>
  8027ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027b1:	75 17                	jne    8027ca <alloc_block_BF+0x358>
  8027b3:	83 ec 04             	sub    $0x4,%esp
  8027b6:	68 80 42 80 00       	push   $0x804280
  8027bb:	68 4f 01 00 00       	push   $0x14f
  8027c0:	68 0d 42 80 00       	push   $0x80420d
  8027c5:	e8 78 0f 00 00       	call   803742 <_panic>
  8027ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cd:	8b 10                	mov    (%eax),%edx
  8027cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d2:	89 10                	mov    %edx,(%eax)
  8027d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	74 0b                	je     8027e8 <alloc_block_BF+0x376>
  8027dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e0:	8b 00                	mov    (%eax),%eax
  8027e2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027e5:	89 50 04             	mov    %edx,0x4(%eax)
  8027e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027eb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027ee:	89 10                	mov    %edx,(%eax)
  8027f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f6:	89 50 04             	mov    %edx,0x4(%eax)
  8027f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027fc:	8b 00                	mov    (%eax),%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	75 08                	jne    80280a <alloc_block_BF+0x398>
  802802:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802805:	a3 30 50 80 00       	mov    %eax,0x805030
  80280a:	a1 38 50 80 00       	mov    0x805038,%eax
  80280f:	40                   	inc    %eax
  802810:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802815:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802819:	75 17                	jne    802832 <alloc_block_BF+0x3c0>
  80281b:	83 ec 04             	sub    $0x4,%esp
  80281e:	68 ef 41 80 00       	push   $0x8041ef
  802823:	68 51 01 00 00       	push   $0x151
  802828:	68 0d 42 80 00       	push   $0x80420d
  80282d:	e8 10 0f 00 00       	call   803742 <_panic>
  802832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802835:	8b 00                	mov    (%eax),%eax
  802837:	85 c0                	test   %eax,%eax
  802839:	74 10                	je     80284b <alloc_block_BF+0x3d9>
  80283b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283e:	8b 00                	mov    (%eax),%eax
  802840:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802843:	8b 52 04             	mov    0x4(%edx),%edx
  802846:	89 50 04             	mov    %edx,0x4(%eax)
  802849:	eb 0b                	jmp    802856 <alloc_block_BF+0x3e4>
  80284b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284e:	8b 40 04             	mov    0x4(%eax),%eax
  802851:	a3 30 50 80 00       	mov    %eax,0x805030
  802856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802859:	8b 40 04             	mov    0x4(%eax),%eax
  80285c:	85 c0                	test   %eax,%eax
  80285e:	74 0f                	je     80286f <alloc_block_BF+0x3fd>
  802860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802863:	8b 40 04             	mov    0x4(%eax),%eax
  802866:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802869:	8b 12                	mov    (%edx),%edx
  80286b:	89 10                	mov    %edx,(%eax)
  80286d:	eb 0a                	jmp    802879 <alloc_block_BF+0x407>
  80286f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802872:	8b 00                	mov    (%eax),%eax
  802874:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802885:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80288c:	a1 38 50 80 00       	mov    0x805038,%eax
  802891:	48                   	dec    %eax
  802892:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802897:	83 ec 04             	sub    $0x4,%esp
  80289a:	6a 00                	push   $0x0
  80289c:	ff 75 d0             	pushl  -0x30(%ebp)
  80289f:	ff 75 cc             	pushl  -0x34(%ebp)
  8028a2:	e8 e0 f6 ff ff       	call   801f87 <set_block_data>
  8028a7:	83 c4 10             	add    $0x10,%esp
			return best_va;
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	e9 a3 01 00 00       	jmp    802a55 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  8028b2:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  8028b6:	0f 85 9d 00 00 00    	jne    802959 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  8028bc:	83 ec 04             	sub    $0x4,%esp
  8028bf:	6a 01                	push   $0x1
  8028c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8028c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8028c7:	e8 bb f6 ff ff       	call   801f87 <set_block_data>
  8028cc:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  8028cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028d3:	75 17                	jne    8028ec <alloc_block_BF+0x47a>
  8028d5:	83 ec 04             	sub    $0x4,%esp
  8028d8:	68 ef 41 80 00       	push   $0x8041ef
  8028dd:	68 58 01 00 00       	push   $0x158
  8028e2:	68 0d 42 80 00       	push   $0x80420d
  8028e7:	e8 56 0e 00 00       	call   803742 <_panic>
  8028ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	74 10                	je     802905 <alloc_block_BF+0x493>
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028fd:	8b 52 04             	mov    0x4(%edx),%edx
  802900:	89 50 04             	mov    %edx,0x4(%eax)
  802903:	eb 0b                	jmp    802910 <alloc_block_BF+0x49e>
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	8b 40 04             	mov    0x4(%eax),%eax
  80290b:	a3 30 50 80 00       	mov    %eax,0x805030
  802910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	85 c0                	test   %eax,%eax
  802918:	74 0f                	je     802929 <alloc_block_BF+0x4b7>
  80291a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291d:	8b 40 04             	mov    0x4(%eax),%eax
  802920:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802923:	8b 12                	mov    (%edx),%edx
  802925:	89 10                	mov    %edx,(%eax)
  802927:	eb 0a                	jmp    802933 <alloc_block_BF+0x4c1>
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	8b 00                	mov    (%eax),%eax
  80292e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802946:	a1 38 50 80 00       	mov    0x805038,%eax
  80294b:	48                   	dec    %eax
  80294c:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802954:	e9 fc 00 00 00       	jmp    802a55 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	83 c0 08             	add    $0x8,%eax
  80295f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802962:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802969:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80296c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80296f:	01 d0                	add    %edx,%eax
  802971:	48                   	dec    %eax
  802972:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802975:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802978:	ba 00 00 00 00       	mov    $0x0,%edx
  80297d:	f7 75 c4             	divl   -0x3c(%ebp)
  802980:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802983:	29 d0                	sub    %edx,%eax
  802985:	c1 e8 0c             	shr    $0xc,%eax
  802988:	83 ec 0c             	sub    $0xc,%esp
  80298b:	50                   	push   %eax
  80298c:	e8 0c e8 ff ff       	call   80119d <sbrk>
  802991:	83 c4 10             	add    $0x10,%esp
  802994:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802997:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  80299b:	75 0a                	jne    8029a7 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  80299d:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a2:	e9 ae 00 00 00       	jmp    802a55 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8029a7:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  8029ae:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029b4:	01 d0                	add    %edx,%eax
  8029b6:	48                   	dec    %eax
  8029b7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8029ba:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8029c2:	f7 75 b8             	divl   -0x48(%ebp)
  8029c5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8029c8:	29 d0                	sub    %edx,%eax
  8029ca:	8d 50 fc             	lea    -0x4(%eax),%edx
  8029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029d0:	01 d0                	add    %edx,%eax
  8029d2:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  8029d7:	a1 40 50 80 00       	mov    0x805040,%eax
  8029dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  8029e2:	83 ec 0c             	sub    $0xc,%esp
  8029e5:	68 b4 42 80 00       	push   $0x8042b4
  8029ea:	e8 14 da ff ff       	call   800403 <cprintf>
  8029ef:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  8029f2:	83 ec 08             	sub    $0x8,%esp
  8029f5:	ff 75 bc             	pushl  -0x44(%ebp)
  8029f8:	68 b9 42 80 00       	push   $0x8042b9
  8029fd:	e8 01 da ff ff       	call   800403 <cprintf>
  802a02:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a05:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a0c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a0f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a12:	01 d0                	add    %edx,%eax
  802a14:	48                   	dec    %eax
  802a15:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a18:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a20:	f7 75 b0             	divl   -0x50(%ebp)
  802a23:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a26:	29 d0                	sub    %edx,%eax
  802a28:	83 ec 04             	sub    $0x4,%esp
  802a2b:	6a 01                	push   $0x1
  802a2d:	50                   	push   %eax
  802a2e:	ff 75 bc             	pushl  -0x44(%ebp)
  802a31:	e8 51 f5 ff ff       	call   801f87 <set_block_data>
  802a36:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a39:	83 ec 0c             	sub    $0xc,%esp
  802a3c:	ff 75 bc             	pushl  -0x44(%ebp)
  802a3f:	e8 36 04 00 00       	call   802e7a <free_block>
  802a44:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802a47:	83 ec 0c             	sub    $0xc,%esp
  802a4a:	ff 75 08             	pushl  0x8(%ebp)
  802a4d:	e8 20 fa ff ff       	call   802472 <alloc_block_BF>
  802a52:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802a55:	c9                   	leave  
  802a56:	c3                   	ret    

00802a57 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802a57:	55                   	push   %ebp
  802a58:	89 e5                	mov    %esp,%ebp
  802a5a:	53                   	push   %ebx
  802a5b:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802a5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a65:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802a6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a70:	74 1e                	je     802a90 <merging+0x39>
  802a72:	ff 75 08             	pushl  0x8(%ebp)
  802a75:	e8 bc f1 ff ff       	call   801c36 <get_block_size>
  802a7a:	83 c4 04             	add    $0x4,%esp
  802a7d:	89 c2                	mov    %eax,%edx
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	01 d0                	add    %edx,%eax
  802a84:	3b 45 10             	cmp    0x10(%ebp),%eax
  802a87:	75 07                	jne    802a90 <merging+0x39>
		prev_is_free = 1;
  802a89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802a90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802a94:	74 1e                	je     802ab4 <merging+0x5d>
  802a96:	ff 75 10             	pushl  0x10(%ebp)
  802a99:	e8 98 f1 ff ff       	call   801c36 <get_block_size>
  802a9e:	83 c4 04             	add    $0x4,%esp
  802aa1:	89 c2                	mov    %eax,%edx
  802aa3:	8b 45 10             	mov    0x10(%ebp),%eax
  802aa6:	01 d0                	add    %edx,%eax
  802aa8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802aab:	75 07                	jne    802ab4 <merging+0x5d>
		next_is_free = 1;
  802aad:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802ab4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab8:	0f 84 cc 00 00 00    	je     802b8a <merging+0x133>
  802abe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac2:	0f 84 c2 00 00 00    	je     802b8a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802ac8:	ff 75 08             	pushl  0x8(%ebp)
  802acb:	e8 66 f1 ff ff       	call   801c36 <get_block_size>
  802ad0:	83 c4 04             	add    $0x4,%esp
  802ad3:	89 c3                	mov    %eax,%ebx
  802ad5:	ff 75 10             	pushl  0x10(%ebp)
  802ad8:	e8 59 f1 ff ff       	call   801c36 <get_block_size>
  802add:	83 c4 04             	add    $0x4,%esp
  802ae0:	01 c3                	add    %eax,%ebx
  802ae2:	ff 75 0c             	pushl  0xc(%ebp)
  802ae5:	e8 4c f1 ff ff       	call   801c36 <get_block_size>
  802aea:	83 c4 04             	add    $0x4,%esp
  802aed:	01 d8                	add    %ebx,%eax
  802aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802af2:	6a 00                	push   $0x0
  802af4:	ff 75 ec             	pushl  -0x14(%ebp)
  802af7:	ff 75 08             	pushl  0x8(%ebp)
  802afa:	e8 88 f4 ff ff       	call   801f87 <set_block_data>
  802aff:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802b02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b06:	75 17                	jne    802b1f <merging+0xc8>
  802b08:	83 ec 04             	sub    $0x4,%esp
  802b0b:	68 ef 41 80 00       	push   $0x8041ef
  802b10:	68 7d 01 00 00       	push   $0x17d
  802b15:	68 0d 42 80 00       	push   $0x80420d
  802b1a:	e8 23 0c 00 00       	call   803742 <_panic>
  802b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b22:	8b 00                	mov    (%eax),%eax
  802b24:	85 c0                	test   %eax,%eax
  802b26:	74 10                	je     802b38 <merging+0xe1>
  802b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b30:	8b 52 04             	mov    0x4(%edx),%edx
  802b33:	89 50 04             	mov    %edx,0x4(%eax)
  802b36:	eb 0b                	jmp    802b43 <merging+0xec>
  802b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b3b:	8b 40 04             	mov    0x4(%eax),%eax
  802b3e:	a3 30 50 80 00       	mov    %eax,0x805030
  802b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b46:	8b 40 04             	mov    0x4(%eax),%eax
  802b49:	85 c0                	test   %eax,%eax
  802b4b:	74 0f                	je     802b5c <merging+0x105>
  802b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b50:	8b 40 04             	mov    0x4(%eax),%eax
  802b53:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b56:	8b 12                	mov    (%edx),%edx
  802b58:	89 10                	mov    %edx,(%eax)
  802b5a:	eb 0a                	jmp    802b66 <merging+0x10f>
  802b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b5f:	8b 00                	mov    (%eax),%eax
  802b61:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b79:	a1 38 50 80 00       	mov    0x805038,%eax
  802b7e:	48                   	dec    %eax
  802b7f:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802b84:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802b85:	e9 ea 02 00 00       	jmp    802e74 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8e:	74 3b                	je     802bcb <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802b90:	83 ec 0c             	sub    $0xc,%esp
  802b93:	ff 75 08             	pushl  0x8(%ebp)
  802b96:	e8 9b f0 ff ff       	call   801c36 <get_block_size>
  802b9b:	83 c4 10             	add    $0x10,%esp
  802b9e:	89 c3                	mov    %eax,%ebx
  802ba0:	83 ec 0c             	sub    $0xc,%esp
  802ba3:	ff 75 10             	pushl  0x10(%ebp)
  802ba6:	e8 8b f0 ff ff       	call   801c36 <get_block_size>
  802bab:	83 c4 10             	add    $0x10,%esp
  802bae:	01 d8                	add    %ebx,%eax
  802bb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802bb3:	83 ec 04             	sub    $0x4,%esp
  802bb6:	6a 00                	push   $0x0
  802bb8:	ff 75 e8             	pushl  -0x18(%ebp)
  802bbb:	ff 75 08             	pushl  0x8(%ebp)
  802bbe:	e8 c4 f3 ff ff       	call   801f87 <set_block_data>
  802bc3:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bc6:	e9 a9 02 00 00       	jmp    802e74 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802bcb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bcf:	0f 84 2d 01 00 00    	je     802d02 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802bd5:	83 ec 0c             	sub    $0xc,%esp
  802bd8:	ff 75 10             	pushl  0x10(%ebp)
  802bdb:	e8 56 f0 ff ff       	call   801c36 <get_block_size>
  802be0:	83 c4 10             	add    $0x10,%esp
  802be3:	89 c3                	mov    %eax,%ebx
  802be5:	83 ec 0c             	sub    $0xc,%esp
  802be8:	ff 75 0c             	pushl  0xc(%ebp)
  802beb:	e8 46 f0 ff ff       	call   801c36 <get_block_size>
  802bf0:	83 c4 10             	add    $0x10,%esp
  802bf3:	01 d8                	add    %ebx,%eax
  802bf5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802bf8:	83 ec 04             	sub    $0x4,%esp
  802bfb:	6a 00                	push   $0x0
  802bfd:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c00:	ff 75 10             	pushl  0x10(%ebp)
  802c03:	e8 7f f3 ff ff       	call   801f87 <set_block_data>
  802c08:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  802c0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c15:	74 06                	je     802c1d <merging+0x1c6>
  802c17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c1b:	75 17                	jne    802c34 <merging+0x1dd>
  802c1d:	83 ec 04             	sub    $0x4,%esp
  802c20:	68 c8 42 80 00       	push   $0x8042c8
  802c25:	68 8d 01 00 00       	push   $0x18d
  802c2a:	68 0d 42 80 00       	push   $0x80420d
  802c2f:	e8 0e 0b 00 00       	call   803742 <_panic>
  802c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c37:	8b 50 04             	mov    0x4(%eax),%edx
  802c3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3d:	89 50 04             	mov    %edx,0x4(%eax)
  802c40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c43:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c46:	89 10                	mov    %edx,(%eax)
  802c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	74 0d                	je     802c5f <merging+0x208>
  802c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c55:	8b 40 04             	mov    0x4(%eax),%eax
  802c58:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c5b:	89 10                	mov    %edx,(%eax)
  802c5d:	eb 08                	jmp    802c67 <merging+0x210>
  802c5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c62:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c6d:	89 50 04             	mov    %edx,0x4(%eax)
  802c70:	a1 38 50 80 00       	mov    0x805038,%eax
  802c75:	40                   	inc    %eax
  802c76:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802c7b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c7f:	75 17                	jne    802c98 <merging+0x241>
  802c81:	83 ec 04             	sub    $0x4,%esp
  802c84:	68 ef 41 80 00       	push   $0x8041ef
  802c89:	68 8e 01 00 00       	push   $0x18e
  802c8e:	68 0d 42 80 00       	push   $0x80420d
  802c93:	e8 aa 0a 00 00       	call   803742 <_panic>
  802c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	74 10                	je     802cb1 <merging+0x25a>
  802ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca4:	8b 00                	mov    (%eax),%eax
  802ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ca9:	8b 52 04             	mov    0x4(%edx),%edx
  802cac:	89 50 04             	mov    %edx,0x4(%eax)
  802caf:	eb 0b                	jmp    802cbc <merging+0x265>
  802cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	a3 30 50 80 00       	mov    %eax,0x805030
  802cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 0f                	je     802cd5 <merging+0x27e>
  802cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ccf:	8b 12                	mov    (%edx),%edx
  802cd1:	89 10                	mov    %edx,(%eax)
  802cd3:	eb 0a                	jmp    802cdf <merging+0x288>
  802cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ceb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf2:	a1 38 50 80 00       	mov    0x805038,%eax
  802cf7:	48                   	dec    %eax
  802cf8:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cfd:	e9 72 01 00 00       	jmp    802e74 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802d02:	8b 45 10             	mov    0x10(%ebp),%eax
  802d05:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802d08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0c:	74 79                	je     802d87 <merging+0x330>
  802d0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d12:	74 73                	je     802d87 <merging+0x330>
  802d14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d18:	74 06                	je     802d20 <merging+0x2c9>
  802d1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d1e:	75 17                	jne    802d37 <merging+0x2e0>
  802d20:	83 ec 04             	sub    $0x4,%esp
  802d23:	68 80 42 80 00       	push   $0x804280
  802d28:	68 94 01 00 00       	push   $0x194
  802d2d:	68 0d 42 80 00       	push   $0x80420d
  802d32:	e8 0b 0a 00 00       	call   803742 <_panic>
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	8b 10                	mov    (%eax),%edx
  802d3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d3f:	89 10                	mov    %edx,(%eax)
  802d41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d44:	8b 00                	mov    (%eax),%eax
  802d46:	85 c0                	test   %eax,%eax
  802d48:	74 0b                	je     802d55 <merging+0x2fe>
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d52:	89 50 04             	mov    %edx,0x4(%eax)
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d5b:	89 10                	mov    %edx,(%eax)
  802d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d60:	8b 55 08             	mov    0x8(%ebp),%edx
  802d63:	89 50 04             	mov    %edx,0x4(%eax)
  802d66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d69:	8b 00                	mov    (%eax),%eax
  802d6b:	85 c0                	test   %eax,%eax
  802d6d:	75 08                	jne    802d77 <merging+0x320>
  802d6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d72:	a3 30 50 80 00       	mov    %eax,0x805030
  802d77:	a1 38 50 80 00       	mov    0x805038,%eax
  802d7c:	40                   	inc    %eax
  802d7d:	a3 38 50 80 00       	mov    %eax,0x805038
  802d82:	e9 ce 00 00 00       	jmp    802e55 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802d87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d8b:	74 65                	je     802df2 <merging+0x39b>
  802d8d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d91:	75 17                	jne    802daa <merging+0x353>
  802d93:	83 ec 04             	sub    $0x4,%esp
  802d96:	68 5c 42 80 00       	push   $0x80425c
  802d9b:	68 95 01 00 00       	push   $0x195
  802da0:	68 0d 42 80 00       	push   $0x80420d
  802da5:	e8 98 09 00 00       	call   803742 <_panic>
  802daa:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802db0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db3:	89 50 04             	mov    %edx,0x4(%eax)
  802db6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db9:	8b 40 04             	mov    0x4(%eax),%eax
  802dbc:	85 c0                	test   %eax,%eax
  802dbe:	74 0c                	je     802dcc <merging+0x375>
  802dc0:	a1 30 50 80 00       	mov    0x805030,%eax
  802dc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dc8:	89 10                	mov    %edx,(%eax)
  802dca:	eb 08                	jmp    802dd4 <merging+0x37d>
  802dcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dcf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802dd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd7:	a3 30 50 80 00       	mov    %eax,0x805030
  802ddc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ddf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de5:	a1 38 50 80 00       	mov    0x805038,%eax
  802dea:	40                   	inc    %eax
  802deb:	a3 38 50 80 00       	mov    %eax,0x805038
  802df0:	eb 63                	jmp    802e55 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802df2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802df6:	75 17                	jne    802e0f <merging+0x3b8>
  802df8:	83 ec 04             	sub    $0x4,%esp
  802dfb:	68 28 42 80 00       	push   $0x804228
  802e00:	68 98 01 00 00       	push   $0x198
  802e05:	68 0d 42 80 00       	push   $0x80420d
  802e0a:	e8 33 09 00 00       	call   803742 <_panic>
  802e0f:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e18:	89 10                	mov    %edx,(%eax)
  802e1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 0d                	je     802e30 <merging+0x3d9>
  802e23:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e28:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e2b:	89 50 04             	mov    %edx,0x4(%eax)
  802e2e:	eb 08                	jmp    802e38 <merging+0x3e1>
  802e30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e33:	a3 30 50 80 00       	mov    %eax,0x805030
  802e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e3b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4a:	a1 38 50 80 00       	mov    0x805038,%eax
  802e4f:	40                   	inc    %eax
  802e50:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802e55:	83 ec 0c             	sub    $0xc,%esp
  802e58:	ff 75 10             	pushl  0x10(%ebp)
  802e5b:	e8 d6 ed ff ff       	call   801c36 <get_block_size>
  802e60:	83 c4 10             	add    $0x10,%esp
  802e63:	83 ec 04             	sub    $0x4,%esp
  802e66:	6a 00                	push   $0x0
  802e68:	50                   	push   %eax
  802e69:	ff 75 10             	pushl  0x10(%ebp)
  802e6c:	e8 16 f1 ff ff       	call   801f87 <set_block_data>
  802e71:	83 c4 10             	add    $0x10,%esp
	}
}
  802e74:	90                   	nop
  802e75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e78:	c9                   	leave  
  802e79:	c3                   	ret    

00802e7a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802e7a:	55                   	push   %ebp
  802e7b:	89 e5                	mov    %esp,%ebp
  802e7d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802e80:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e85:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802e88:	a1 30 50 80 00       	mov    0x805030,%eax
  802e8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e90:	73 1b                	jae    802ead <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802e92:	a1 30 50 80 00       	mov    0x805030,%eax
  802e97:	83 ec 04             	sub    $0x4,%esp
  802e9a:	ff 75 08             	pushl  0x8(%ebp)
  802e9d:	6a 00                	push   $0x0
  802e9f:	50                   	push   %eax
  802ea0:	e8 b2 fb ff ff       	call   802a57 <merging>
  802ea5:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ea8:	e9 8b 00 00 00       	jmp    802f38 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802ead:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eb2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb5:	76 18                	jbe    802ecf <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802eb7:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ebc:	83 ec 04             	sub    $0x4,%esp
  802ebf:	ff 75 08             	pushl  0x8(%ebp)
  802ec2:	50                   	push   %eax
  802ec3:	6a 00                	push   $0x0
  802ec5:	e8 8d fb ff ff       	call   802a57 <merging>
  802eca:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802ecd:	eb 69                	jmp    802f38 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802ecf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ed7:	eb 39                	jmp    802f12 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802edf:	73 29                	jae    802f0a <free_block+0x90>
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	8b 00                	mov    (%eax),%eax
  802ee6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee9:	76 1f                	jbe    802f0a <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eee:	8b 00                	mov    (%eax),%eax
  802ef0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802ef3:	83 ec 04             	sub    $0x4,%esp
  802ef6:	ff 75 08             	pushl  0x8(%ebp)
  802ef9:	ff 75 f0             	pushl  -0x10(%ebp)
  802efc:	ff 75 f4             	pushl  -0xc(%ebp)
  802eff:	e8 53 fb ff ff       	call   802a57 <merging>
  802f04:	83 c4 10             	add    $0x10,%esp
			break;
  802f07:	90                   	nop
		}
	}
}
  802f08:	eb 2e                	jmp    802f38 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f0a:	a1 34 50 80 00       	mov    0x805034,%eax
  802f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f16:	74 07                	je     802f1f <free_block+0xa5>
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 00                	mov    (%eax),%eax
  802f1d:	eb 05                	jmp    802f24 <free_block+0xaa>
  802f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f24:	a3 34 50 80 00       	mov    %eax,0x805034
  802f29:	a1 34 50 80 00       	mov    0x805034,%eax
  802f2e:	85 c0                	test   %eax,%eax
  802f30:	75 a7                	jne    802ed9 <free_block+0x5f>
  802f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f36:	75 a1                	jne    802ed9 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f38:	90                   	nop
  802f39:	c9                   	leave  
  802f3a:	c3                   	ret    

00802f3b <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f3b:	55                   	push   %ebp
  802f3c:	89 e5                	mov    %esp,%ebp
  802f3e:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802f41:	ff 75 08             	pushl  0x8(%ebp)
  802f44:	e8 ed ec ff ff       	call   801c36 <get_block_size>
  802f49:	83 c4 04             	add    $0x4,%esp
  802f4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802f4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802f56:	eb 17                	jmp    802f6f <copy_data+0x34>
  802f58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f5e:	01 c2                	add    %eax,%edx
  802f60:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	01 c8                	add    %ecx,%eax
  802f68:	8a 00                	mov    (%eax),%al
  802f6a:	88 02                	mov    %al,(%edx)
  802f6c:	ff 45 fc             	incl   -0x4(%ebp)
  802f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f72:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802f75:	72 e1                	jb     802f58 <copy_data+0x1d>
}
  802f77:	90                   	nop
  802f78:	c9                   	leave  
  802f79:	c3                   	ret    

00802f7a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802f7a:	55                   	push   %ebp
  802f7b:	89 e5                	mov    %esp,%ebp
  802f7d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802f80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f84:	75 23                	jne    802fa9 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802f86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f8a:	74 13                	je     802f9f <realloc_block_FF+0x25>
  802f8c:	83 ec 0c             	sub    $0xc,%esp
  802f8f:	ff 75 0c             	pushl  0xc(%ebp)
  802f92:	e8 1f f0 ff ff       	call   801fb6 <alloc_block_FF>
  802f97:	83 c4 10             	add    $0x10,%esp
  802f9a:	e9 f4 06 00 00       	jmp    803693 <realloc_block_FF+0x719>
		return NULL;
  802f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa4:	e9 ea 06 00 00       	jmp    803693 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  802fa9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fad:	75 18                	jne    802fc7 <realloc_block_FF+0x4d>
	{
		free_block(va);
  802faf:	83 ec 0c             	sub    $0xc,%esp
  802fb2:	ff 75 08             	pushl  0x8(%ebp)
  802fb5:	e8 c0 fe ff ff       	call   802e7a <free_block>
  802fba:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802fbd:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc2:	e9 cc 06 00 00       	jmp    803693 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  802fc7:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802fcb:	77 07                	ja     802fd4 <realloc_block_FF+0x5a>
  802fcd:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  802fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd7:	83 e0 01             	and    $0x1,%eax
  802fda:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  802fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe0:	83 c0 08             	add    $0x8,%eax
  802fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  802fe6:	83 ec 0c             	sub    $0xc,%esp
  802fe9:	ff 75 08             	pushl  0x8(%ebp)
  802fec:	e8 45 ec ff ff       	call   801c36 <get_block_size>
  802ff1:	83 c4 10             	add    $0x10,%esp
  802ff4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  802ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffa:	83 e8 08             	sub    $0x8,%eax
  802ffd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	83 e8 04             	sub    $0x4,%eax
  803006:	8b 00                	mov    (%eax),%eax
  803008:	83 e0 fe             	and    $0xfffffffe,%eax
  80300b:	89 c2                	mov    %eax,%edx
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	01 d0                	add    %edx,%eax
  803012:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803015:	83 ec 0c             	sub    $0xc,%esp
  803018:	ff 75 e4             	pushl  -0x1c(%ebp)
  80301b:	e8 16 ec ff ff       	call   801c36 <get_block_size>
  803020:	83 c4 10             	add    $0x10,%esp
  803023:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803026:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803029:	83 e8 08             	sub    $0x8,%eax
  80302c:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80302f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803032:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803035:	75 08                	jne    80303f <realloc_block_FF+0xc5>
	{
		 return va;
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	e9 54 06 00 00       	jmp    803693 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  80303f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803042:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803045:	0f 83 e5 03 00 00    	jae    803430 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  80304b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304e:	2b 45 0c             	sub    0xc(%ebp),%eax
  803051:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803054:	83 ec 0c             	sub    $0xc,%esp
  803057:	ff 75 e4             	pushl  -0x1c(%ebp)
  80305a:	e8 f0 eb ff ff       	call   801c4f <is_free_block>
  80305f:	83 c4 10             	add    $0x10,%esp
  803062:	84 c0                	test   %al,%al
  803064:	0f 84 3b 01 00 00    	je     8031a5 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80306a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80306d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803070:	01 d0                	add    %edx,%eax
  803072:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803075:	83 ec 04             	sub    $0x4,%esp
  803078:	6a 01                	push   $0x1
  80307a:	ff 75 f0             	pushl  -0x10(%ebp)
  80307d:	ff 75 08             	pushl  0x8(%ebp)
  803080:	e8 02 ef ff ff       	call   801f87 <set_block_data>
  803085:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	83 e8 04             	sub    $0x4,%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	83 e0 fe             	and    $0xfffffffe,%eax
  803093:	89 c2                	mov    %eax,%edx
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	01 d0                	add    %edx,%eax
  80309a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80309d:	83 ec 04             	sub    $0x4,%esp
  8030a0:	6a 00                	push   $0x0
  8030a2:	ff 75 cc             	pushl  -0x34(%ebp)
  8030a5:	ff 75 c8             	pushl  -0x38(%ebp)
  8030a8:	e8 da ee ff ff       	call   801f87 <set_block_data>
  8030ad:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8030b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030b4:	74 06                	je     8030bc <realloc_block_FF+0x142>
  8030b6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8030ba:	75 17                	jne    8030d3 <realloc_block_FF+0x159>
  8030bc:	83 ec 04             	sub    $0x4,%esp
  8030bf:	68 80 42 80 00       	push   $0x804280
  8030c4:	68 f6 01 00 00       	push   $0x1f6
  8030c9:	68 0d 42 80 00       	push   $0x80420d
  8030ce:	e8 6f 06 00 00       	call   803742 <_panic>
  8030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d6:	8b 10                	mov    (%eax),%edx
  8030d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030db:	89 10                	mov    %edx,(%eax)
  8030dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030e0:	8b 00                	mov    (%eax),%eax
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	74 0b                	je     8030f1 <realloc_block_FF+0x177>
  8030e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030ee:	89 50 04             	mov    %edx,0x4(%eax)
  8030f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8030f7:	89 10                	mov    %edx,(%eax)
  8030f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8030fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ff:	89 50 04             	mov    %edx,0x4(%eax)
  803102:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803105:	8b 00                	mov    (%eax),%eax
  803107:	85 c0                	test   %eax,%eax
  803109:	75 08                	jne    803113 <realloc_block_FF+0x199>
  80310b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80310e:	a3 30 50 80 00       	mov    %eax,0x805030
  803113:	a1 38 50 80 00       	mov    0x805038,%eax
  803118:	40                   	inc    %eax
  803119:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80311e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803122:	75 17                	jne    80313b <realloc_block_FF+0x1c1>
  803124:	83 ec 04             	sub    $0x4,%esp
  803127:	68 ef 41 80 00       	push   $0x8041ef
  80312c:	68 f7 01 00 00       	push   $0x1f7
  803131:	68 0d 42 80 00       	push   $0x80420d
  803136:	e8 07 06 00 00       	call   803742 <_panic>
  80313b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	85 c0                	test   %eax,%eax
  803142:	74 10                	je     803154 <realloc_block_FF+0x1da>
  803144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803147:	8b 00                	mov    (%eax),%eax
  803149:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80314c:	8b 52 04             	mov    0x4(%edx),%edx
  80314f:	89 50 04             	mov    %edx,0x4(%eax)
  803152:	eb 0b                	jmp    80315f <realloc_block_FF+0x1e5>
  803154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803157:	8b 40 04             	mov    0x4(%eax),%eax
  80315a:	a3 30 50 80 00       	mov    %eax,0x805030
  80315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803162:	8b 40 04             	mov    0x4(%eax),%eax
  803165:	85 c0                	test   %eax,%eax
  803167:	74 0f                	je     803178 <realloc_block_FF+0x1fe>
  803169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316c:	8b 40 04             	mov    0x4(%eax),%eax
  80316f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803172:	8b 12                	mov    (%edx),%edx
  803174:	89 10                	mov    %edx,(%eax)
  803176:	eb 0a                	jmp    803182 <realloc_block_FF+0x208>
  803178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317b:	8b 00                	mov    (%eax),%eax
  80317d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803182:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803185:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803195:	a1 38 50 80 00       	mov    0x805038,%eax
  80319a:	48                   	dec    %eax
  80319b:	a3 38 50 80 00       	mov    %eax,0x805038
  8031a0:	e9 83 02 00 00       	jmp    803428 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8031a5:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8031a9:	0f 86 69 02 00 00    	jbe    803418 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8031af:	83 ec 04             	sub    $0x4,%esp
  8031b2:	6a 01                	push   $0x1
  8031b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8031b7:	ff 75 08             	pushl  0x8(%ebp)
  8031ba:	e8 c8 ed ff ff       	call   801f87 <set_block_data>
  8031bf:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	83 e8 04             	sub    $0x4,%eax
  8031c8:	8b 00                	mov    (%eax),%eax
  8031ca:	83 e0 fe             	and    $0xfffffffe,%eax
  8031cd:	89 c2                	mov    %eax,%edx
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	01 d0                	add    %edx,%eax
  8031d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  8031d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8031dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  8031df:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8031e3:	75 68                	jne    80324d <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8031e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031e9:	75 17                	jne    803202 <realloc_block_FF+0x288>
  8031eb:	83 ec 04             	sub    $0x4,%esp
  8031ee:	68 28 42 80 00       	push   $0x804228
  8031f3:	68 06 02 00 00       	push   $0x206
  8031f8:	68 0d 42 80 00       	push   $0x80420d
  8031fd:	e8 40 05 00 00       	call   803742 <_panic>
  803202:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803208:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80320b:	89 10                	mov    %edx,(%eax)
  80320d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803210:	8b 00                	mov    (%eax),%eax
  803212:	85 c0                	test   %eax,%eax
  803214:	74 0d                	je     803223 <realloc_block_FF+0x2a9>
  803216:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80321b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80321e:	89 50 04             	mov    %edx,0x4(%eax)
  803221:	eb 08                	jmp    80322b <realloc_block_FF+0x2b1>
  803223:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803226:	a3 30 50 80 00       	mov    %eax,0x805030
  80322b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80322e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803233:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803236:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323d:	a1 38 50 80 00       	mov    0x805038,%eax
  803242:	40                   	inc    %eax
  803243:	a3 38 50 80 00       	mov    %eax,0x805038
  803248:	e9 b0 01 00 00       	jmp    8033fd <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  80324d:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803252:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803255:	76 68                	jbe    8032bf <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803257:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80325b:	75 17                	jne    803274 <realloc_block_FF+0x2fa>
  80325d:	83 ec 04             	sub    $0x4,%esp
  803260:	68 28 42 80 00       	push   $0x804228
  803265:	68 0b 02 00 00       	push   $0x20b
  80326a:	68 0d 42 80 00       	push   $0x80420d
  80326f:	e8 ce 04 00 00       	call   803742 <_panic>
  803274:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80327a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80327d:	89 10                	mov    %edx,(%eax)
  80327f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803282:	8b 00                	mov    (%eax),%eax
  803284:	85 c0                	test   %eax,%eax
  803286:	74 0d                	je     803295 <realloc_block_FF+0x31b>
  803288:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80328d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803290:	89 50 04             	mov    %edx,0x4(%eax)
  803293:	eb 08                	jmp    80329d <realloc_block_FF+0x323>
  803295:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803298:	a3 30 50 80 00       	mov    %eax,0x805030
  80329d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032a0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032af:	a1 38 50 80 00       	mov    0x805038,%eax
  8032b4:	40                   	inc    %eax
  8032b5:	a3 38 50 80 00       	mov    %eax,0x805038
  8032ba:	e9 3e 01 00 00       	jmp    8033fd <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8032bf:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032c4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032c7:	73 68                	jae    803331 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032c9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032cd:	75 17                	jne    8032e6 <realloc_block_FF+0x36c>
  8032cf:	83 ec 04             	sub    $0x4,%esp
  8032d2:	68 5c 42 80 00       	push   $0x80425c
  8032d7:	68 10 02 00 00       	push   $0x210
  8032dc:	68 0d 42 80 00       	push   $0x80420d
  8032e1:	e8 5c 04 00 00       	call   803742 <_panic>
  8032e6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8032ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ef:	89 50 04             	mov    %edx,0x4(%eax)
  8032f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f5:	8b 40 04             	mov    0x4(%eax),%eax
  8032f8:	85 c0                	test   %eax,%eax
  8032fa:	74 0c                	je     803308 <realloc_block_FF+0x38e>
  8032fc:	a1 30 50 80 00       	mov    0x805030,%eax
  803301:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803304:	89 10                	mov    %edx,(%eax)
  803306:	eb 08                	jmp    803310 <realloc_block_FF+0x396>
  803308:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80330b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803310:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803313:	a3 30 50 80 00       	mov    %eax,0x805030
  803318:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80331b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803321:	a1 38 50 80 00       	mov    0x805038,%eax
  803326:	40                   	inc    %eax
  803327:	a3 38 50 80 00       	mov    %eax,0x805038
  80332c:	e9 cc 00 00 00       	jmp    8033fd <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803331:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803338:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80333d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803340:	e9 8a 00 00 00       	jmp    8033cf <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80334b:	73 7a                	jae    8033c7 <realloc_block_FF+0x44d>
  80334d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803350:	8b 00                	mov    (%eax),%eax
  803352:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803355:	73 70                	jae    8033c7 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80335b:	74 06                	je     803363 <realloc_block_FF+0x3e9>
  80335d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803361:	75 17                	jne    80337a <realloc_block_FF+0x400>
  803363:	83 ec 04             	sub    $0x4,%esp
  803366:	68 80 42 80 00       	push   $0x804280
  80336b:	68 1a 02 00 00       	push   $0x21a
  803370:	68 0d 42 80 00       	push   $0x80420d
  803375:	e8 c8 03 00 00       	call   803742 <_panic>
  80337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337d:	8b 10                	mov    (%eax),%edx
  80337f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803382:	89 10                	mov    %edx,(%eax)
  803384:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803387:	8b 00                	mov    (%eax),%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	74 0b                	je     803398 <realloc_block_FF+0x41e>
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	8b 00                	mov    (%eax),%eax
  803392:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803395:	89 50 04             	mov    %edx,0x4(%eax)
  803398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80339e:	89 10                	mov    %edx,(%eax)
  8033a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033a6:	89 50 04             	mov    %edx,0x4(%eax)
  8033a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	85 c0                	test   %eax,%eax
  8033b0:	75 08                	jne    8033ba <realloc_block_FF+0x440>
  8033b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b5:	a3 30 50 80 00       	mov    %eax,0x805030
  8033ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8033bf:	40                   	inc    %eax
  8033c0:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  8033c5:	eb 36                	jmp    8033fd <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  8033c7:	a1 34 50 80 00       	mov    0x805034,%eax
  8033cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d3:	74 07                	je     8033dc <realloc_block_FF+0x462>
  8033d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d8:	8b 00                	mov    (%eax),%eax
  8033da:	eb 05                	jmp    8033e1 <realloc_block_FF+0x467>
  8033dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e1:	a3 34 50 80 00       	mov    %eax,0x805034
  8033e6:	a1 34 50 80 00       	mov    0x805034,%eax
  8033eb:	85 c0                	test   %eax,%eax
  8033ed:	0f 85 52 ff ff ff    	jne    803345 <realloc_block_FF+0x3cb>
  8033f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f7:	0f 85 48 ff ff ff    	jne    803345 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8033fd:	83 ec 04             	sub    $0x4,%esp
  803400:	6a 00                	push   $0x0
  803402:	ff 75 d8             	pushl  -0x28(%ebp)
  803405:	ff 75 d4             	pushl  -0x2c(%ebp)
  803408:	e8 7a eb ff ff       	call   801f87 <set_block_data>
  80340d:	83 c4 10             	add    $0x10,%esp
				return va;
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	e9 7b 02 00 00       	jmp    803693 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803418:	83 ec 0c             	sub    $0xc,%esp
  80341b:	68 fd 42 80 00       	push   $0x8042fd
  803420:	e8 de cf ff ff       	call   800403 <cprintf>
  803425:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	e9 63 02 00 00       	jmp    803693 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803430:	8b 45 0c             	mov    0xc(%ebp),%eax
  803433:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803436:	0f 86 4d 02 00 00    	jbe    803689 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  80343c:	83 ec 0c             	sub    $0xc,%esp
  80343f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803442:	e8 08 e8 ff ff       	call   801c4f <is_free_block>
  803447:	83 c4 10             	add    $0x10,%esp
  80344a:	84 c0                	test   %al,%al
  80344c:	0f 84 37 02 00 00    	je     803689 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803452:	8b 45 0c             	mov    0xc(%ebp),%eax
  803455:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803458:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80345b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80345e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803461:	76 38                	jbe    80349b <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803463:	83 ec 0c             	sub    $0xc,%esp
  803466:	ff 75 08             	pushl  0x8(%ebp)
  803469:	e8 0c fa ff ff       	call   802e7a <free_block>
  80346e:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803471:	83 ec 0c             	sub    $0xc,%esp
  803474:	ff 75 0c             	pushl  0xc(%ebp)
  803477:	e8 3a eb ff ff       	call   801fb6 <alloc_block_FF>
  80347c:	83 c4 10             	add    $0x10,%esp
  80347f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803482:	83 ec 08             	sub    $0x8,%esp
  803485:	ff 75 c0             	pushl  -0x40(%ebp)
  803488:	ff 75 08             	pushl  0x8(%ebp)
  80348b:	e8 ab fa ff ff       	call   802f3b <copy_data>
  803490:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803496:	e9 f8 01 00 00       	jmp    803693 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80349b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8034a1:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8034a4:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8034a8:	0f 87 a0 00 00 00    	ja     80354e <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8034ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034b2:	75 17                	jne    8034cb <realloc_block_FF+0x551>
  8034b4:	83 ec 04             	sub    $0x4,%esp
  8034b7:	68 ef 41 80 00       	push   $0x8041ef
  8034bc:	68 38 02 00 00       	push   $0x238
  8034c1:	68 0d 42 80 00       	push   $0x80420d
  8034c6:	e8 77 02 00 00       	call   803742 <_panic>
  8034cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ce:	8b 00                	mov    (%eax),%eax
  8034d0:	85 c0                	test   %eax,%eax
  8034d2:	74 10                	je     8034e4 <realloc_block_FF+0x56a>
  8034d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d7:	8b 00                	mov    (%eax),%eax
  8034d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034dc:	8b 52 04             	mov    0x4(%edx),%edx
  8034df:	89 50 04             	mov    %edx,0x4(%eax)
  8034e2:	eb 0b                	jmp    8034ef <realloc_block_FF+0x575>
  8034e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034e7:	8b 40 04             	mov    0x4(%eax),%eax
  8034ea:	a3 30 50 80 00       	mov    %eax,0x805030
  8034ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f2:	8b 40 04             	mov    0x4(%eax),%eax
  8034f5:	85 c0                	test   %eax,%eax
  8034f7:	74 0f                	je     803508 <realloc_block_FF+0x58e>
  8034f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fc:	8b 40 04             	mov    0x4(%eax),%eax
  8034ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803502:	8b 12                	mov    (%edx),%edx
  803504:	89 10                	mov    %edx,(%eax)
  803506:	eb 0a                	jmp    803512 <realloc_block_FF+0x598>
  803508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350b:	8b 00                	mov    (%eax),%eax
  80350d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803512:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803515:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80351b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80351e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803525:	a1 38 50 80 00       	mov    0x805038,%eax
  80352a:	48                   	dec    %eax
  80352b:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803530:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803533:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803536:	01 d0                	add    %edx,%eax
  803538:	83 ec 04             	sub    $0x4,%esp
  80353b:	6a 01                	push   $0x1
  80353d:	50                   	push   %eax
  80353e:	ff 75 08             	pushl  0x8(%ebp)
  803541:	e8 41 ea ff ff       	call   801f87 <set_block_data>
  803546:	83 c4 10             	add    $0x10,%esp
  803549:	e9 36 01 00 00       	jmp    803684 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80354e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803551:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803554:	01 d0                	add    %edx,%eax
  803556:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803559:	83 ec 04             	sub    $0x4,%esp
  80355c:	6a 01                	push   $0x1
  80355e:	ff 75 f0             	pushl  -0x10(%ebp)
  803561:	ff 75 08             	pushl  0x8(%ebp)
  803564:	e8 1e ea ff ff       	call   801f87 <set_block_data>
  803569:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	83 e8 04             	sub    $0x4,%eax
  803572:	8b 00                	mov    (%eax),%eax
  803574:	83 e0 fe             	and    $0xfffffffe,%eax
  803577:	89 c2                	mov    %eax,%edx
  803579:	8b 45 08             	mov    0x8(%ebp),%eax
  80357c:	01 d0                	add    %edx,%eax
  80357e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803581:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803585:	74 06                	je     80358d <realloc_block_FF+0x613>
  803587:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80358b:	75 17                	jne    8035a4 <realloc_block_FF+0x62a>
  80358d:	83 ec 04             	sub    $0x4,%esp
  803590:	68 80 42 80 00       	push   $0x804280
  803595:	68 44 02 00 00       	push   $0x244
  80359a:	68 0d 42 80 00       	push   $0x80420d
  80359f:	e8 9e 01 00 00       	call   803742 <_panic>
  8035a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a7:	8b 10                	mov    (%eax),%edx
  8035a9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035ac:	89 10                	mov    %edx,(%eax)
  8035ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035b1:	8b 00                	mov    (%eax),%eax
  8035b3:	85 c0                	test   %eax,%eax
  8035b5:	74 0b                	je     8035c2 <realloc_block_FF+0x648>
  8035b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ba:	8b 00                	mov    (%eax),%eax
  8035bc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035bf:	89 50 04             	mov    %edx,0x4(%eax)
  8035c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c5:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8035c8:	89 10                	mov    %edx,(%eax)
  8035ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d0:	89 50 04             	mov    %edx,0x4(%eax)
  8035d3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035d6:	8b 00                	mov    (%eax),%eax
  8035d8:	85 c0                	test   %eax,%eax
  8035da:	75 08                	jne    8035e4 <realloc_block_FF+0x66a>
  8035dc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8035df:	a3 30 50 80 00       	mov    %eax,0x805030
  8035e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8035e9:	40                   	inc    %eax
  8035ea:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8035ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035f3:	75 17                	jne    80360c <realloc_block_FF+0x692>
  8035f5:	83 ec 04             	sub    $0x4,%esp
  8035f8:	68 ef 41 80 00       	push   $0x8041ef
  8035fd:	68 45 02 00 00       	push   $0x245
  803602:	68 0d 42 80 00       	push   $0x80420d
  803607:	e8 36 01 00 00       	call   803742 <_panic>
  80360c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360f:	8b 00                	mov    (%eax),%eax
  803611:	85 c0                	test   %eax,%eax
  803613:	74 10                	je     803625 <realloc_block_FF+0x6ab>
  803615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803618:	8b 00                	mov    (%eax),%eax
  80361a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80361d:	8b 52 04             	mov    0x4(%edx),%edx
  803620:	89 50 04             	mov    %edx,0x4(%eax)
  803623:	eb 0b                	jmp    803630 <realloc_block_FF+0x6b6>
  803625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803628:	8b 40 04             	mov    0x4(%eax),%eax
  80362b:	a3 30 50 80 00       	mov    %eax,0x805030
  803630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803633:	8b 40 04             	mov    0x4(%eax),%eax
  803636:	85 c0                	test   %eax,%eax
  803638:	74 0f                	je     803649 <realloc_block_FF+0x6cf>
  80363a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363d:	8b 40 04             	mov    0x4(%eax),%eax
  803640:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803643:	8b 12                	mov    (%edx),%edx
  803645:	89 10                	mov    %edx,(%eax)
  803647:	eb 0a                	jmp    803653 <realloc_block_FF+0x6d9>
  803649:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364c:	8b 00                	mov    (%eax),%eax
  80364e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80365c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803666:	a1 38 50 80 00       	mov    0x805038,%eax
  80366b:	48                   	dec    %eax
  80366c:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803671:	83 ec 04             	sub    $0x4,%esp
  803674:	6a 00                	push   $0x0
  803676:	ff 75 bc             	pushl  -0x44(%ebp)
  803679:	ff 75 b8             	pushl  -0x48(%ebp)
  80367c:	e8 06 e9 ff ff       	call   801f87 <set_block_data>
  803681:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803684:	8b 45 08             	mov    0x8(%ebp),%eax
  803687:	eb 0a                	jmp    803693 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803689:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803690:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803693:	c9                   	leave  
  803694:	c3                   	ret    

00803695 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803695:	55                   	push   %ebp
  803696:	89 e5                	mov    %esp,%ebp
  803698:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80369b:	83 ec 04             	sub    $0x4,%esp
  80369e:	68 04 43 80 00       	push   $0x804304
  8036a3:	68 58 02 00 00       	push   $0x258
  8036a8:	68 0d 42 80 00       	push   $0x80420d
  8036ad:	e8 90 00 00 00       	call   803742 <_panic>

008036b2 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8036b2:	55                   	push   %ebp
  8036b3:	89 e5                	mov    %esp,%ebp
  8036b5:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8036b8:	83 ec 04             	sub    $0x4,%esp
  8036bb:	68 2c 43 80 00       	push   $0x80432c
  8036c0:	68 61 02 00 00       	push   $0x261
  8036c5:	68 0d 42 80 00       	push   $0x80420d
  8036ca:	e8 73 00 00 00       	call   803742 <_panic>

008036cf <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8036cf:	55                   	push   %ebp
  8036d0:	89 e5                	mov    %esp,%ebp
  8036d2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8036d5:	83 ec 04             	sub    $0x4,%esp
  8036d8:	68 54 43 80 00       	push   $0x804354
  8036dd:	6a 09                	push   $0x9
  8036df:	68 7c 43 80 00       	push   $0x80437c
  8036e4:	e8 59 00 00 00       	call   803742 <_panic>

008036e9 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8036e9:	55                   	push   %ebp
  8036ea:	89 e5                	mov    %esp,%ebp
  8036ec:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8036ef:	83 ec 04             	sub    $0x4,%esp
  8036f2:	68 8c 43 80 00       	push   $0x80438c
  8036f7:	6a 10                	push   $0x10
  8036f9:	68 7c 43 80 00       	push   $0x80437c
  8036fe:	e8 3f 00 00 00       	call   803742 <_panic>

00803703 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  803703:	55                   	push   %ebp
  803704:	89 e5                	mov    %esp,%ebp
  803706:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803709:	83 ec 04             	sub    $0x4,%esp
  80370c:	68 b4 43 80 00       	push   $0x8043b4
  803711:	6a 18                	push   $0x18
  803713:	68 7c 43 80 00       	push   $0x80437c
  803718:	e8 25 00 00 00       	call   803742 <_panic>

0080371d <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  80371d:	55                   	push   %ebp
  80371e:	89 e5                	mov    %esp,%ebp
  803720:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  803723:	83 ec 04             	sub    $0x4,%esp
  803726:	68 dc 43 80 00       	push   $0x8043dc
  80372b:	6a 20                	push   $0x20
  80372d:	68 7c 43 80 00       	push   $0x80437c
  803732:	e8 0b 00 00 00       	call   803742 <_panic>

00803737 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  803737:	55                   	push   %ebp
  803738:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80373a:	8b 45 08             	mov    0x8(%ebp),%eax
  80373d:	8b 40 10             	mov    0x10(%eax),%eax
}
  803740:	5d                   	pop    %ebp
  803741:	c3                   	ret    

00803742 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803742:	55                   	push   %ebp
  803743:	89 e5                	mov    %esp,%ebp
  803745:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803748:	8d 45 10             	lea    0x10(%ebp),%eax
  80374b:	83 c0 04             	add    $0x4,%eax
  80374e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803751:	a1 60 50 90 00       	mov    0x905060,%eax
  803756:	85 c0                	test   %eax,%eax
  803758:	74 16                	je     803770 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80375a:	a1 60 50 90 00       	mov    0x905060,%eax
  80375f:	83 ec 08             	sub    $0x8,%esp
  803762:	50                   	push   %eax
  803763:	68 04 44 80 00       	push   $0x804404
  803768:	e8 96 cc ff ff       	call   800403 <cprintf>
  80376d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803770:	a1 00 50 80 00       	mov    0x805000,%eax
  803775:	ff 75 0c             	pushl  0xc(%ebp)
  803778:	ff 75 08             	pushl  0x8(%ebp)
  80377b:	50                   	push   %eax
  80377c:	68 09 44 80 00       	push   $0x804409
  803781:	e8 7d cc ff ff       	call   800403 <cprintf>
  803786:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803789:	8b 45 10             	mov    0x10(%ebp),%eax
  80378c:	83 ec 08             	sub    $0x8,%esp
  80378f:	ff 75 f4             	pushl  -0xc(%ebp)
  803792:	50                   	push   %eax
  803793:	e8 00 cc ff ff       	call   800398 <vcprintf>
  803798:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80379b:	83 ec 08             	sub    $0x8,%esp
  80379e:	6a 00                	push   $0x0
  8037a0:	68 25 44 80 00       	push   $0x804425
  8037a5:	e8 ee cb ff ff       	call   800398 <vcprintf>
  8037aa:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8037ad:	e8 6f cb ff ff       	call   800321 <exit>

	// should not return here
	while (1) ;
  8037b2:	eb fe                	jmp    8037b2 <_panic+0x70>

008037b4 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8037b4:	55                   	push   %ebp
  8037b5:	89 e5                	mov    %esp,%ebp
  8037b7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8037ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8037bf:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8037c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037c8:	39 c2                	cmp    %eax,%edx
  8037ca:	74 14                	je     8037e0 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8037cc:	83 ec 04             	sub    $0x4,%esp
  8037cf:	68 28 44 80 00       	push   $0x804428
  8037d4:	6a 26                	push   $0x26
  8037d6:	68 74 44 80 00       	push   $0x804474
  8037db:	e8 62 ff ff ff       	call   803742 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8037e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8037e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8037ee:	e9 c5 00 00 00       	jmp    8038b8 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8037f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	01 d0                	add    %edx,%eax
  803802:	8b 00                	mov    (%eax),%eax
  803804:	85 c0                	test   %eax,%eax
  803806:	75 08                	jne    803810 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803808:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80380b:	e9 a5 00 00 00       	jmp    8038b5 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803810:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803817:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80381e:	eb 69                	jmp    803889 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803820:	a1 20 50 80 00       	mov    0x805020,%eax
  803825:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80382b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80382e:	89 d0                	mov    %edx,%eax
  803830:	01 c0                	add    %eax,%eax
  803832:	01 d0                	add    %edx,%eax
  803834:	c1 e0 03             	shl    $0x3,%eax
  803837:	01 c8                	add    %ecx,%eax
  803839:	8a 40 04             	mov    0x4(%eax),%al
  80383c:	84 c0                	test   %al,%al
  80383e:	75 46                	jne    803886 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803840:	a1 20 50 80 00       	mov    0x805020,%eax
  803845:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  80384b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80384e:	89 d0                	mov    %edx,%eax
  803850:	01 c0                	add    %eax,%eax
  803852:	01 d0                	add    %edx,%eax
  803854:	c1 e0 03             	shl    $0x3,%eax
  803857:	01 c8                	add    %ecx,%eax
  803859:	8b 00                	mov    (%eax),%eax
  80385b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80385e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803861:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803866:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803872:	8b 45 08             	mov    0x8(%ebp),%eax
  803875:	01 c8                	add    %ecx,%eax
  803877:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803879:	39 c2                	cmp    %eax,%edx
  80387b:	75 09                	jne    803886 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80387d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803884:	eb 15                	jmp    80389b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803886:	ff 45 e8             	incl   -0x18(%ebp)
  803889:	a1 20 50 80 00       	mov    0x805020,%eax
  80388e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803894:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803897:	39 c2                	cmp    %eax,%edx
  803899:	77 85                	ja     803820 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80389b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80389f:	75 14                	jne    8038b5 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8038a1:	83 ec 04             	sub    $0x4,%esp
  8038a4:	68 80 44 80 00       	push   $0x804480
  8038a9:	6a 3a                	push   $0x3a
  8038ab:	68 74 44 80 00       	push   $0x804474
  8038b0:	e8 8d fe ff ff       	call   803742 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8038b5:	ff 45 f0             	incl   -0x10(%ebp)
  8038b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8038be:	0f 8c 2f ff ff ff    	jl     8037f3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8038c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038cb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8038d2:	eb 26                	jmp    8038fa <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8038d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8038d9:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8038e2:	89 d0                	mov    %edx,%eax
  8038e4:	01 c0                	add    %eax,%eax
  8038e6:	01 d0                	add    %edx,%eax
  8038e8:	c1 e0 03             	shl    $0x3,%eax
  8038eb:	01 c8                	add    %ecx,%eax
  8038ed:	8a 40 04             	mov    0x4(%eax),%al
  8038f0:	3c 01                	cmp    $0x1,%al
  8038f2:	75 03                	jne    8038f7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8038f4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038f7:	ff 45 e0             	incl   -0x20(%ebp)
  8038fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8038ff:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803905:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803908:	39 c2                	cmp    %eax,%edx
  80390a:	77 c8                	ja     8038d4 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80390c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803912:	74 14                	je     803928 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803914:	83 ec 04             	sub    $0x4,%esp
  803917:	68 d4 44 80 00       	push   $0x8044d4
  80391c:	6a 44                	push   $0x44
  80391e:	68 74 44 80 00       	push   $0x804474
  803923:	e8 1a fe ff ff       	call   803742 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803928:	90                   	nop
  803929:	c9                   	leave  
  80392a:	c3                   	ret    
  80392b:	90                   	nop

0080392c <__udivdi3>:
  80392c:	55                   	push   %ebp
  80392d:	57                   	push   %edi
  80392e:	56                   	push   %esi
  80392f:	53                   	push   %ebx
  803930:	83 ec 1c             	sub    $0x1c,%esp
  803933:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803937:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80393b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80393f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803943:	89 ca                	mov    %ecx,%edx
  803945:	89 f8                	mov    %edi,%eax
  803947:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80394b:	85 f6                	test   %esi,%esi
  80394d:	75 2d                	jne    80397c <__udivdi3+0x50>
  80394f:	39 cf                	cmp    %ecx,%edi
  803951:	77 65                	ja     8039b8 <__udivdi3+0x8c>
  803953:	89 fd                	mov    %edi,%ebp
  803955:	85 ff                	test   %edi,%edi
  803957:	75 0b                	jne    803964 <__udivdi3+0x38>
  803959:	b8 01 00 00 00       	mov    $0x1,%eax
  80395e:	31 d2                	xor    %edx,%edx
  803960:	f7 f7                	div    %edi
  803962:	89 c5                	mov    %eax,%ebp
  803964:	31 d2                	xor    %edx,%edx
  803966:	89 c8                	mov    %ecx,%eax
  803968:	f7 f5                	div    %ebp
  80396a:	89 c1                	mov    %eax,%ecx
  80396c:	89 d8                	mov    %ebx,%eax
  80396e:	f7 f5                	div    %ebp
  803970:	89 cf                	mov    %ecx,%edi
  803972:	89 fa                	mov    %edi,%edx
  803974:	83 c4 1c             	add    $0x1c,%esp
  803977:	5b                   	pop    %ebx
  803978:	5e                   	pop    %esi
  803979:	5f                   	pop    %edi
  80397a:	5d                   	pop    %ebp
  80397b:	c3                   	ret    
  80397c:	39 ce                	cmp    %ecx,%esi
  80397e:	77 28                	ja     8039a8 <__udivdi3+0x7c>
  803980:	0f bd fe             	bsr    %esi,%edi
  803983:	83 f7 1f             	xor    $0x1f,%edi
  803986:	75 40                	jne    8039c8 <__udivdi3+0x9c>
  803988:	39 ce                	cmp    %ecx,%esi
  80398a:	72 0a                	jb     803996 <__udivdi3+0x6a>
  80398c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803990:	0f 87 9e 00 00 00    	ja     803a34 <__udivdi3+0x108>
  803996:	b8 01 00 00 00       	mov    $0x1,%eax
  80399b:	89 fa                	mov    %edi,%edx
  80399d:	83 c4 1c             	add    $0x1c,%esp
  8039a0:	5b                   	pop    %ebx
  8039a1:	5e                   	pop    %esi
  8039a2:	5f                   	pop    %edi
  8039a3:	5d                   	pop    %ebp
  8039a4:	c3                   	ret    
  8039a5:	8d 76 00             	lea    0x0(%esi),%esi
  8039a8:	31 ff                	xor    %edi,%edi
  8039aa:	31 c0                	xor    %eax,%eax
  8039ac:	89 fa                	mov    %edi,%edx
  8039ae:	83 c4 1c             	add    $0x1c,%esp
  8039b1:	5b                   	pop    %ebx
  8039b2:	5e                   	pop    %esi
  8039b3:	5f                   	pop    %edi
  8039b4:	5d                   	pop    %ebp
  8039b5:	c3                   	ret    
  8039b6:	66 90                	xchg   %ax,%ax
  8039b8:	89 d8                	mov    %ebx,%eax
  8039ba:	f7 f7                	div    %edi
  8039bc:	31 ff                	xor    %edi,%edi
  8039be:	89 fa                	mov    %edi,%edx
  8039c0:	83 c4 1c             	add    $0x1c,%esp
  8039c3:	5b                   	pop    %ebx
  8039c4:	5e                   	pop    %esi
  8039c5:	5f                   	pop    %edi
  8039c6:	5d                   	pop    %ebp
  8039c7:	c3                   	ret    
  8039c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039cd:	89 eb                	mov    %ebp,%ebx
  8039cf:	29 fb                	sub    %edi,%ebx
  8039d1:	89 f9                	mov    %edi,%ecx
  8039d3:	d3 e6                	shl    %cl,%esi
  8039d5:	89 c5                	mov    %eax,%ebp
  8039d7:	88 d9                	mov    %bl,%cl
  8039d9:	d3 ed                	shr    %cl,%ebp
  8039db:	89 e9                	mov    %ebp,%ecx
  8039dd:	09 f1                	or     %esi,%ecx
  8039df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039e3:	89 f9                	mov    %edi,%ecx
  8039e5:	d3 e0                	shl    %cl,%eax
  8039e7:	89 c5                	mov    %eax,%ebp
  8039e9:	89 d6                	mov    %edx,%esi
  8039eb:	88 d9                	mov    %bl,%cl
  8039ed:	d3 ee                	shr    %cl,%esi
  8039ef:	89 f9                	mov    %edi,%ecx
  8039f1:	d3 e2                	shl    %cl,%edx
  8039f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039f7:	88 d9                	mov    %bl,%cl
  8039f9:	d3 e8                	shr    %cl,%eax
  8039fb:	09 c2                	or     %eax,%edx
  8039fd:	89 d0                	mov    %edx,%eax
  8039ff:	89 f2                	mov    %esi,%edx
  803a01:	f7 74 24 0c          	divl   0xc(%esp)
  803a05:	89 d6                	mov    %edx,%esi
  803a07:	89 c3                	mov    %eax,%ebx
  803a09:	f7 e5                	mul    %ebp
  803a0b:	39 d6                	cmp    %edx,%esi
  803a0d:	72 19                	jb     803a28 <__udivdi3+0xfc>
  803a0f:	74 0b                	je     803a1c <__udivdi3+0xf0>
  803a11:	89 d8                	mov    %ebx,%eax
  803a13:	31 ff                	xor    %edi,%edi
  803a15:	e9 58 ff ff ff       	jmp    803972 <__udivdi3+0x46>
  803a1a:	66 90                	xchg   %ax,%ax
  803a1c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a20:	89 f9                	mov    %edi,%ecx
  803a22:	d3 e2                	shl    %cl,%edx
  803a24:	39 c2                	cmp    %eax,%edx
  803a26:	73 e9                	jae    803a11 <__udivdi3+0xe5>
  803a28:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a2b:	31 ff                	xor    %edi,%edi
  803a2d:	e9 40 ff ff ff       	jmp    803972 <__udivdi3+0x46>
  803a32:	66 90                	xchg   %ax,%ax
  803a34:	31 c0                	xor    %eax,%eax
  803a36:	e9 37 ff ff ff       	jmp    803972 <__udivdi3+0x46>
  803a3b:	90                   	nop

00803a3c <__umoddi3>:
  803a3c:	55                   	push   %ebp
  803a3d:	57                   	push   %edi
  803a3e:	56                   	push   %esi
  803a3f:	53                   	push   %ebx
  803a40:	83 ec 1c             	sub    $0x1c,%esp
  803a43:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a47:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a4f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a5b:	89 f3                	mov    %esi,%ebx
  803a5d:	89 fa                	mov    %edi,%edx
  803a5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a63:	89 34 24             	mov    %esi,(%esp)
  803a66:	85 c0                	test   %eax,%eax
  803a68:	75 1a                	jne    803a84 <__umoddi3+0x48>
  803a6a:	39 f7                	cmp    %esi,%edi
  803a6c:	0f 86 a2 00 00 00    	jbe    803b14 <__umoddi3+0xd8>
  803a72:	89 c8                	mov    %ecx,%eax
  803a74:	89 f2                	mov    %esi,%edx
  803a76:	f7 f7                	div    %edi
  803a78:	89 d0                	mov    %edx,%eax
  803a7a:	31 d2                	xor    %edx,%edx
  803a7c:	83 c4 1c             	add    $0x1c,%esp
  803a7f:	5b                   	pop    %ebx
  803a80:	5e                   	pop    %esi
  803a81:	5f                   	pop    %edi
  803a82:	5d                   	pop    %ebp
  803a83:	c3                   	ret    
  803a84:	39 f0                	cmp    %esi,%eax
  803a86:	0f 87 ac 00 00 00    	ja     803b38 <__umoddi3+0xfc>
  803a8c:	0f bd e8             	bsr    %eax,%ebp
  803a8f:	83 f5 1f             	xor    $0x1f,%ebp
  803a92:	0f 84 ac 00 00 00    	je     803b44 <__umoddi3+0x108>
  803a98:	bf 20 00 00 00       	mov    $0x20,%edi
  803a9d:	29 ef                	sub    %ebp,%edi
  803a9f:	89 fe                	mov    %edi,%esi
  803aa1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803aa5:	89 e9                	mov    %ebp,%ecx
  803aa7:	d3 e0                	shl    %cl,%eax
  803aa9:	89 d7                	mov    %edx,%edi
  803aab:	89 f1                	mov    %esi,%ecx
  803aad:	d3 ef                	shr    %cl,%edi
  803aaf:	09 c7                	or     %eax,%edi
  803ab1:	89 e9                	mov    %ebp,%ecx
  803ab3:	d3 e2                	shl    %cl,%edx
  803ab5:	89 14 24             	mov    %edx,(%esp)
  803ab8:	89 d8                	mov    %ebx,%eax
  803aba:	d3 e0                	shl    %cl,%eax
  803abc:	89 c2                	mov    %eax,%edx
  803abe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ac2:	d3 e0                	shl    %cl,%eax
  803ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ac8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803acc:	89 f1                	mov    %esi,%ecx
  803ace:	d3 e8                	shr    %cl,%eax
  803ad0:	09 d0                	or     %edx,%eax
  803ad2:	d3 eb                	shr    %cl,%ebx
  803ad4:	89 da                	mov    %ebx,%edx
  803ad6:	f7 f7                	div    %edi
  803ad8:	89 d3                	mov    %edx,%ebx
  803ada:	f7 24 24             	mull   (%esp)
  803add:	89 c6                	mov    %eax,%esi
  803adf:	89 d1                	mov    %edx,%ecx
  803ae1:	39 d3                	cmp    %edx,%ebx
  803ae3:	0f 82 87 00 00 00    	jb     803b70 <__umoddi3+0x134>
  803ae9:	0f 84 91 00 00 00    	je     803b80 <__umoddi3+0x144>
  803aef:	8b 54 24 04          	mov    0x4(%esp),%edx
  803af3:	29 f2                	sub    %esi,%edx
  803af5:	19 cb                	sbb    %ecx,%ebx
  803af7:	89 d8                	mov    %ebx,%eax
  803af9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803afd:	d3 e0                	shl    %cl,%eax
  803aff:	89 e9                	mov    %ebp,%ecx
  803b01:	d3 ea                	shr    %cl,%edx
  803b03:	09 d0                	or     %edx,%eax
  803b05:	89 e9                	mov    %ebp,%ecx
  803b07:	d3 eb                	shr    %cl,%ebx
  803b09:	89 da                	mov    %ebx,%edx
  803b0b:	83 c4 1c             	add    $0x1c,%esp
  803b0e:	5b                   	pop    %ebx
  803b0f:	5e                   	pop    %esi
  803b10:	5f                   	pop    %edi
  803b11:	5d                   	pop    %ebp
  803b12:	c3                   	ret    
  803b13:	90                   	nop
  803b14:	89 fd                	mov    %edi,%ebp
  803b16:	85 ff                	test   %edi,%edi
  803b18:	75 0b                	jne    803b25 <__umoddi3+0xe9>
  803b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b1f:	31 d2                	xor    %edx,%edx
  803b21:	f7 f7                	div    %edi
  803b23:	89 c5                	mov    %eax,%ebp
  803b25:	89 f0                	mov    %esi,%eax
  803b27:	31 d2                	xor    %edx,%edx
  803b29:	f7 f5                	div    %ebp
  803b2b:	89 c8                	mov    %ecx,%eax
  803b2d:	f7 f5                	div    %ebp
  803b2f:	89 d0                	mov    %edx,%eax
  803b31:	e9 44 ff ff ff       	jmp    803a7a <__umoddi3+0x3e>
  803b36:	66 90                	xchg   %ax,%ax
  803b38:	89 c8                	mov    %ecx,%eax
  803b3a:	89 f2                	mov    %esi,%edx
  803b3c:	83 c4 1c             	add    $0x1c,%esp
  803b3f:	5b                   	pop    %ebx
  803b40:	5e                   	pop    %esi
  803b41:	5f                   	pop    %edi
  803b42:	5d                   	pop    %ebp
  803b43:	c3                   	ret    
  803b44:	3b 04 24             	cmp    (%esp),%eax
  803b47:	72 06                	jb     803b4f <__umoddi3+0x113>
  803b49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b4d:	77 0f                	ja     803b5e <__umoddi3+0x122>
  803b4f:	89 f2                	mov    %esi,%edx
  803b51:	29 f9                	sub    %edi,%ecx
  803b53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b57:	89 14 24             	mov    %edx,(%esp)
  803b5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b62:	8b 14 24             	mov    (%esp),%edx
  803b65:	83 c4 1c             	add    $0x1c,%esp
  803b68:	5b                   	pop    %ebx
  803b69:	5e                   	pop    %esi
  803b6a:	5f                   	pop    %edi
  803b6b:	5d                   	pop    %ebp
  803b6c:	c3                   	ret    
  803b6d:	8d 76 00             	lea    0x0(%esi),%esi
  803b70:	2b 04 24             	sub    (%esp),%eax
  803b73:	19 fa                	sbb    %edi,%edx
  803b75:	89 d1                	mov    %edx,%ecx
  803b77:	89 c6                	mov    %eax,%esi
  803b79:	e9 71 ff ff ff       	jmp    803aef <__umoddi3+0xb3>
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b84:	72 ea                	jb     803b70 <__umoddi3+0x134>
  803b86:	89 d9                	mov    %ebx,%ecx
  803b88:	e9 62 ff ff ff       	jmp    803aef <__umoddi3+0xb3>
