
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
  800045:	68 60 3c 80 00       	push   $0x803c60
  80004a:	e8 81 14 00 00       	call   8014d0 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 64 3c 80 00       	push   $0x803c64
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
  80009a:	68 89 3c 80 00       	push   $0x803c89
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
  8000da:	68 90 3c 80 00       	push   $0x803c90
  8000df:	50                   	push   %eax
  8000e0:	e8 9c 36 00 00       	call   803781 <create_semaphore>
  8000e5:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	6a 01                	push   $0x1
  8000ed:	6a 04                	push   $0x4
  8000ef:	68 92 3c 80 00       	push   $0x803c92
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
  80012e:	68 a0 3c 80 00       	push   $0x803ca0
  800133:	e8 02 18 00 00       	call   80193a <sys_create_env>
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
  800164:	68 aa 3c 80 00       	push   $0x803caa
  800169:	e8 cc 17 00 00       	call   80193a <sys_create_env>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 d9 17 00 00       	call   801958 <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	e8 cb 17 00 00       	call   801958 <sys_run_env>
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
  8001a4:	68 b4 3c 80 00       	push   $0x803cb4
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
  8001c8:	e8 aa 16 00 00       	call   801877 <sys_cputc>
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
  8001d9:	e8 35 15 00 00       	call   801713 <sys_cgetc>
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
  8001f6:	e8 ad 17 00 00       	call   8019a8 <sys_getenvindex>
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
  800264:	e8 c3 14 00 00       	call   80172c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	68 e4 3c 80 00       	push   $0x803ce4
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
  800294:	68 0c 3d 80 00       	push   $0x803d0c
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
  8002c5:	68 34 3d 80 00       	push   $0x803d34
  8002ca:	e8 34 01 00 00       	call   800403 <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d7:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	50                   	push   %eax
  8002e1:	68 8c 3d 80 00       	push   $0x803d8c
  8002e6:	e8 18 01 00 00       	call   800403 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	68 e4 3c 80 00       	push   $0x803ce4
  8002f6:	e8 08 01 00 00       	call   800403 <cprintf>
  8002fb:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002fe:	e8 43 14 00 00       	call   801746 <sys_unlock_cons>
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
  800316:	e8 59 16 00 00       	call   801974 <sys_destroy_env>
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
  800327:	e8 ae 16 00 00       	call   8019da <sys_exit_env>
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
  800375:	e8 70 13 00 00       	call   8016ea <sys_cputs>
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
  8003ec:	e8 f9 12 00 00       	call   8016ea <sys_cputs>
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
  800436:	e8 f1 12 00 00       	call   80172c <sys_lock_cons>
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
  800456:	e8 eb 12 00 00       	call   801746 <sys_unlock_cons>
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
  8004a0:	e8 3b 35 00 00       	call   8039e0 <__udivdi3>
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
  8004f0:	e8 fb 35 00 00       	call   803af0 <__umoddi3>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	05 b4 3f 80 00       	add    $0x803fb4,%eax
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
  80064b:	8b 04 85 d8 3f 80 00 	mov    0x803fd8(,%eax,4),%eax
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
  80072c:	8b 34 9d 20 3e 80 00 	mov    0x803e20(,%ebx,4),%esi
  800733:	85 f6                	test   %esi,%esi
  800735:	75 19                	jne    800750 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800737:	53                   	push   %ebx
  800738:	68 c5 3f 80 00       	push   $0x803fc5
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
  800751:	68 ce 3f 80 00       	push   $0x803fce
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
  80077e:	be d1 3f 80 00       	mov    $0x803fd1,%esi
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
  801189:	68 48 41 80 00       	push   $0x804148
  80118e:	68 3f 01 00 00       	push   $0x13f
  801193:	68 6a 41 80 00       	push   $0x80416a
  801198:	e8 57 26 00 00       	call   8037f4 <_panic>

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
  8011a9:	e8 e7 0a 00 00       	call   801c95 <sys_sbrk>
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
  801224:	e8 f0 08 00 00       	call   801b19 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801229:	85 c0                	test   %eax,%eax
  80122b:	74 16                	je     801243 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 30 0e 00 00       	call   802068 <alloc_block_FF>
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123e:	e9 8a 01 00 00       	jmp    8013cd <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801243:	e8 02 09 00 00       	call   801b4a <sys_isUHeapPlacementStrategyBESTFIT>
  801248:	85 c0                	test   %eax,%eax
  80124a:	0f 84 7d 01 00 00    	je     8013cd <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	ff 75 08             	pushl  0x8(%ebp)
  801256:	e8 c9 12 00 00       	call   802524 <alloc_block_BF>
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
  8013bc:	e8 0b 09 00 00       	call   801ccc <sys_allocate_user_mem>
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
  801404:	e8 df 08 00 00       	call   801ce8 <get_block_size>
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80140f:	83 ec 0c             	sub    $0xc,%esp
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	e8 12 1b 00 00       	call   802f2c <free_block>
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
  8014ac:	e8 ff 07 00 00       	call   801cb0 <sys_free_user_mem>
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
  8014ba:	68 78 41 80 00       	push   $0x804178
  8014bf:	68 85 00 00 00       	push   $0x85
  8014c4:	68 a2 41 80 00       	push   $0x8041a2
  8014c9:	e8 26 23 00 00       	call   8037f4 <_panic>
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
  80152f:	e8 83 03 00 00       	call   8018b7 <sys_createSharedObject>
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
  801553:	68 ae 41 80 00       	push   $0x8041ae
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
  801597:	e8 45 03 00 00       	call   8018e1 <sys_getSizeOfSharedObject>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8015a2:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8015a6:	75 07                	jne    8015af <sget+0x27>
  8015a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ad:	eb 5c                	jmp    80160b <sget+0x83>
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
  8015e2:	eb 27                	jmp    80160b <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ea:	ff 75 0c             	pushl  0xc(%ebp)
  8015ed:	ff 75 08             	pushl  0x8(%ebp)
  8015f0:	e8 09 03 00 00       	call   8018fe <sys_getSharedObject>
  8015f5:	83 c4 10             	add    $0x10,%esp
  8015f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8015fb:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8015ff:	75 07                	jne    801608 <sget+0x80>
  801601:	b8 00 00 00 00       	mov    $0x0,%eax
  801606:	eb 03                	jmp    80160b <sget+0x83>
	return ptr;
  801608:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
    int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801613:	8b 55 08             	mov    0x8(%ebp),%edx
  801616:	a1 20 50 80 00       	mov    0x805020,%eax
  80161b:	8b 40 78             	mov    0x78(%eax),%eax
  80161e:	29 c2                	sub    %eax,%edx
  801620:	89 d0                	mov    %edx,%eax
  801622:	2d 00 10 00 00       	sub    $0x1000,%eax
  801627:	c1 e8 0c             	shr    $0xc,%eax
  80162a:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801631:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801634:	83 ec 08             	sub    $0x8,%esp
  801637:	ff 75 08             	pushl  0x8(%ebp)
  80163a:	ff 75 f4             	pushl  -0xc(%ebp)
  80163d:	e8 db 02 00 00       	call   80191d <sys_freeSharedObject>
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	68 c0 41 80 00       	push   $0x8041c0
  801659:	68 dd 00 00 00       	push   $0xdd
  80165e:	68 a2 41 80 00       	push   $0x8041a2
  801663:	e8 8c 21 00 00       	call   8037f4 <_panic>

00801668 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80166e:	83 ec 04             	sub    $0x4,%esp
  801671:	68 e6 41 80 00       	push   $0x8041e6
  801676:	68 e9 00 00 00       	push   $0xe9
  80167b:	68 a2 41 80 00       	push   $0x8041a2
  801680:	e8 6f 21 00 00       	call   8037f4 <_panic>

00801685 <shrink>:

}
void shrink(uint32 newSize)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	68 e6 41 80 00       	push   $0x8041e6
  801693:	68 ee 00 00 00       	push   $0xee
  801698:	68 a2 41 80 00       	push   $0x8041a2
  80169d:	e8 52 21 00 00       	call   8037f4 <_panic>

008016a2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016a8:	83 ec 04             	sub    $0x4,%esp
  8016ab:	68 e6 41 80 00       	push   $0x8041e6
  8016b0:	68 f3 00 00 00       	push   $0xf3
  8016b5:	68 a2 41 80 00       	push   $0x8041a2
  8016ba:	e8 35 21 00 00       	call   8037f4 <_panic>

008016bf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	57                   	push   %edi
  8016c3:	56                   	push   %esi
  8016c4:	53                   	push   %ebx
  8016c5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016d7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016da:	cd 30                	int    $0x30
  8016dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5f                   	pop    %edi
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    

008016ea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	83 ec 04             	sub    $0x4,%esp
  8016f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	52                   	push   %edx
  801702:	ff 75 0c             	pushl  0xc(%ebp)
  801705:	50                   	push   %eax
  801706:	6a 00                	push   $0x0
  801708:	e8 b2 ff ff ff       	call   8016bf <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	90                   	nop
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_cgetc>:

int
sys_cgetc(void)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 02                	push   $0x2
  801722:	e8 98 ff ff ff       	call   8016bf <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 03                	push   $0x3
  80173b:	e8 7f ff ff ff       	call   8016bf <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	90                   	nop
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 04                	push   $0x4
  801755:	e8 65 ff ff ff       	call   8016bf <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	90                   	nop
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801763:	8b 55 0c             	mov    0xc(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	52                   	push   %edx
  801770:	50                   	push   %eax
  801771:	6a 08                	push   $0x8
  801773:	e8 47 ff ff ff       	call   8016bf <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	56                   	push   %esi
  801781:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801782:	8b 75 18             	mov    0x18(%ebp),%esi
  801785:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801788:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80178b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	56                   	push   %esi
  801792:	53                   	push   %ebx
  801793:	51                   	push   %ecx
  801794:	52                   	push   %edx
  801795:	50                   	push   %eax
  801796:	6a 09                	push   $0x9
  801798:	e8 22 ff ff ff       	call   8016bf <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
}
  8017a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a3:	5b                   	pop    %ebx
  8017a4:	5e                   	pop    %esi
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	52                   	push   %edx
  8017b7:	50                   	push   %eax
  8017b8:	6a 0a                	push   $0xa
  8017ba:	e8 00 ff ff ff       	call   8016bf <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	6a 0b                	push   $0xb
  8017d5:	e8 e5 fe ff ff       	call   8016bf <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 0c                	push   $0xc
  8017ee:	e8 cc fe ff ff       	call   8016bf <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 0d                	push   $0xd
  801807:	e8 b3 fe ff ff       	call   8016bf <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 0e                	push   $0xe
  801820:	e8 9a fe ff ff       	call   8016bf <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 0f                	push   $0xf
  801839:	e8 81 fe ff ff       	call   8016bf <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	ff 75 08             	pushl  0x8(%ebp)
  801851:	6a 10                	push   $0x10
  801853:	e8 67 fe ff ff       	call   8016bf <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 11                	push   $0x11
  80186c:	e8 4e fe ff ff       	call   8016bf <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	90                   	nop
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_cputc>:

void
sys_cputc(const char c)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801883:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	50                   	push   %eax
  801890:	6a 01                	push   $0x1
  801892:	e8 28 fe ff ff       	call   8016bf <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	90                   	nop
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 14                	push   $0x14
  8018ac:	e8 0e fe ff ff       	call   8016bf <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	90                   	nop
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018c6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	6a 00                	push   $0x0
  8018cf:	51                   	push   %ecx
  8018d0:	52                   	push   %edx
  8018d1:	ff 75 0c             	pushl  0xc(%ebp)
  8018d4:	50                   	push   %eax
  8018d5:	6a 15                	push   $0x15
  8018d7:	e8 e3 fd ff ff       	call   8016bf <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	52                   	push   %edx
  8018f1:	50                   	push   %eax
  8018f2:	6a 16                	push   $0x16
  8018f4:	e8 c6 fd ff ff       	call   8016bf <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801901:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801904:	8b 55 0c             	mov    0xc(%ebp),%edx
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	51                   	push   %ecx
  80190f:	52                   	push   %edx
  801910:	50                   	push   %eax
  801911:	6a 17                	push   $0x17
  801913:	e8 a7 fd ff ff       	call   8016bf <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801920:	8b 55 0c             	mov    0xc(%ebp),%edx
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	52                   	push   %edx
  80192d:	50                   	push   %eax
  80192e:	6a 18                	push   $0x18
  801930:	e8 8a fd ff ff       	call   8016bf <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	6a 00                	push   $0x0
  801942:	ff 75 14             	pushl  0x14(%ebp)
  801945:	ff 75 10             	pushl  0x10(%ebp)
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	50                   	push   %eax
  80194c:	6a 19                	push   $0x19
  80194e:	e8 6c fd ff ff       	call   8016bf <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	50                   	push   %eax
  801967:	6a 1a                	push   $0x1a
  801969:	e8 51 fd ff ff       	call   8016bf <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	90                   	nop
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	50                   	push   %eax
  801983:	6a 1b                	push   $0x1b
  801985:	e8 35 fd ff ff       	call   8016bf <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 05                	push   $0x5
  80199e:	e8 1c fd ff ff       	call   8016bf <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 06                	push   $0x6
  8019b7:	e8 03 fd ff ff       	call   8016bf <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 07                	push   $0x7
  8019d0:	e8 ea fc ff ff       	call   8016bf <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_exit_env>:


void sys_exit_env(void)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 1c                	push   $0x1c
  8019e9:	e8 d1 fc ff ff       	call   8016bf <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	90                   	nop
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019fa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019fd:	8d 50 04             	lea    0x4(%eax),%edx
  801a00:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	52                   	push   %edx
  801a0a:	50                   	push   %eax
  801a0b:	6a 1d                	push   $0x1d
  801a0d:	e8 ad fc ff ff       	call   8016bf <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
	return result;
  801a15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a1e:	89 01                	mov    %eax,(%ecx)
  801a20:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	c9                   	leave  
  801a27:	c2 04 00             	ret    $0x4

00801a2a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	ff 75 10             	pushl  0x10(%ebp)
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	6a 13                	push   $0x13
  801a3c:	e8 7e fc ff ff       	call   8016bf <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
	return ;
  801a44:	90                   	nop
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 1e                	push   $0x1e
  801a56:	e8 64 fc ff ff       	call   8016bf <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a6c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	50                   	push   %eax
  801a79:	6a 1f                	push   $0x1f
  801a7b:	e8 3f fc ff ff       	call   8016bf <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
	return ;
  801a83:	90                   	nop
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <rsttst>:
void rsttst()
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 21                	push   $0x21
  801a95:	e8 25 fc ff ff       	call   8016bf <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9d:	90                   	nop
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801aac:	8b 55 18             	mov    0x18(%ebp),%edx
  801aaf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab3:	52                   	push   %edx
  801ab4:	50                   	push   %eax
  801ab5:	ff 75 10             	pushl  0x10(%ebp)
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	6a 20                	push   $0x20
  801ac0:	e8 fa fb ff ff       	call   8016bf <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac8:	90                   	nop
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <chktst>:
void chktst(uint32 n)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	ff 75 08             	pushl  0x8(%ebp)
  801ad9:	6a 22                	push   $0x22
  801adb:	e8 df fb ff ff       	call   8016bf <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae3:	90                   	nop
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <inctst>:

void inctst()
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 23                	push   $0x23
  801af5:	e8 c5 fb ff ff       	call   8016bf <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
	return ;
  801afd:	90                   	nop
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <gettst>:
uint32 gettst()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 24                	push   $0x24
  801b0f:	e8 ab fb ff ff       	call   8016bf <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 25                	push   $0x25
  801b2b:	e8 8f fb ff ff       	call   8016bf <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
  801b33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b36:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b3a:	75 07                	jne    801b43 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b41:	eb 05                	jmp    801b48 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 25                	push   $0x25
  801b5c:	e8 5e fb ff ff       	call   8016bf <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
  801b64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b67:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b6b:	75 07                	jne    801b74 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b72:	eb 05                	jmp    801b79 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 25                	push   $0x25
  801b8d:	e8 2d fb ff ff       	call   8016bf <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
  801b95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b98:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b9c:	75 07                	jne    801ba5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba3:	eb 05                	jmp    801baa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ba5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 25                	push   $0x25
  801bbe:	e8 fc fa ff ff       	call   8016bf <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
  801bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bc9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bcd:	75 07                	jne    801bd6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bcf:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd4:	eb 05                	jmp    801bdb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	6a 26                	push   $0x26
  801bed:	e8 cd fa ff ff       	call   8016bf <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf5:	90                   	nop
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bfc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	6a 00                	push   $0x0
  801c0a:	53                   	push   %ebx
  801c0b:	51                   	push   %ecx
  801c0c:	52                   	push   %edx
  801c0d:	50                   	push   %eax
  801c0e:	6a 27                	push   $0x27
  801c10:	e8 aa fa ff ff       	call   8016bf <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	52                   	push   %edx
  801c2d:	50                   	push   %eax
  801c2e:	6a 28                	push   $0x28
  801c30:	e8 8a fa ff ff       	call   8016bf <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c3d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	6a 00                	push   $0x0
  801c48:	51                   	push   %ecx
  801c49:	ff 75 10             	pushl  0x10(%ebp)
  801c4c:	52                   	push   %edx
  801c4d:	50                   	push   %eax
  801c4e:	6a 29                	push   $0x29
  801c50:	e8 6a fa ff ff       	call   8016bf <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	ff 75 10             	pushl  0x10(%ebp)
  801c64:	ff 75 0c             	pushl  0xc(%ebp)
  801c67:	ff 75 08             	pushl  0x8(%ebp)
  801c6a:	6a 12                	push   $0x12
  801c6c:	e8 4e fa ff ff       	call   8016bf <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
	return ;
  801c74:	90                   	nop
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	52                   	push   %edx
  801c87:	50                   	push   %eax
  801c88:	6a 2a                	push   $0x2a
  801c8a:	e8 30 fa ff ff       	call   8016bf <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
	return;
  801c92:	90                   	nop
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c98:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	50                   	push   %eax
  801ca4:	6a 2b                	push   $0x2b
  801ca6:	e8 14 fa ff ff       	call   8016bf <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	ff 75 0c             	pushl  0xc(%ebp)
  801cbc:	ff 75 08             	pushl  0x8(%ebp)
  801cbf:	6a 2c                	push   $0x2c
  801cc1:	e8 f9 f9 ff ff       	call   8016bf <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
	return;
  801cc9:	90                   	nop
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	ff 75 08             	pushl  0x8(%ebp)
  801cdb:	6a 2d                	push   $0x2d
  801cdd:	e8 dd f9 ff ff       	call   8016bf <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
	return;
  801ce5:	90                   	nop
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	83 e8 04             	sub    $0x4,%eax
  801cf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801cf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cfa:	8b 00                	mov    (%eax),%eax
  801cfc:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	83 e8 04             	sub    $0x4,%eax
  801d0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d13:	8b 00                	mov    (%eax),%eax
  801d15:	83 e0 01             	and    $0x1,%eax
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	0f 94 c0             	sete   %al
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801d25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2f:	83 f8 02             	cmp    $0x2,%eax
  801d32:	74 2b                	je     801d5f <alloc_block+0x40>
  801d34:	83 f8 02             	cmp    $0x2,%eax
  801d37:	7f 07                	jg     801d40 <alloc_block+0x21>
  801d39:	83 f8 01             	cmp    $0x1,%eax
  801d3c:	74 0e                	je     801d4c <alloc_block+0x2d>
  801d3e:	eb 58                	jmp    801d98 <alloc_block+0x79>
  801d40:	83 f8 03             	cmp    $0x3,%eax
  801d43:	74 2d                	je     801d72 <alloc_block+0x53>
  801d45:	83 f8 04             	cmp    $0x4,%eax
  801d48:	74 3b                	je     801d85 <alloc_block+0x66>
  801d4a:	eb 4c                	jmp    801d98 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801d4c:	83 ec 0c             	sub    $0xc,%esp
  801d4f:	ff 75 08             	pushl  0x8(%ebp)
  801d52:	e8 11 03 00 00       	call   802068 <alloc_block_FF>
  801d57:	83 c4 10             	add    $0x10,%esp
  801d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d5d:	eb 4a                	jmp    801da9 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801d5f:	83 ec 0c             	sub    $0xc,%esp
  801d62:	ff 75 08             	pushl  0x8(%ebp)
  801d65:	e8 fa 19 00 00       	call   803764 <alloc_block_NF>
  801d6a:	83 c4 10             	add    $0x10,%esp
  801d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d70:	eb 37                	jmp    801da9 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801d72:	83 ec 0c             	sub    $0xc,%esp
  801d75:	ff 75 08             	pushl  0x8(%ebp)
  801d78:	e8 a7 07 00 00       	call   802524 <alloc_block_BF>
  801d7d:	83 c4 10             	add    $0x10,%esp
  801d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d83:	eb 24                	jmp    801da9 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801d85:	83 ec 0c             	sub    $0xc,%esp
  801d88:	ff 75 08             	pushl  0x8(%ebp)
  801d8b:	e8 b7 19 00 00       	call   803747 <alloc_block_WF>
  801d90:	83 c4 10             	add    $0x10,%esp
  801d93:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d96:	eb 11                	jmp    801da9 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801d98:	83 ec 0c             	sub    $0xc,%esp
  801d9b:	68 f8 41 80 00       	push   $0x8041f8
  801da0:	e8 5e e6 ff ff       	call   800403 <cprintf>
  801da5:	83 c4 10             	add    $0x10,%esp
		break;
  801da8:	90                   	nop
	}
	return va;
  801da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	53                   	push   %ebx
  801db2:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801db5:	83 ec 0c             	sub    $0xc,%esp
  801db8:	68 18 42 80 00       	push   $0x804218
  801dbd:	e8 41 e6 ff ff       	call   800403 <cprintf>
  801dc2:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801dc5:	83 ec 0c             	sub    $0xc,%esp
  801dc8:	68 43 42 80 00       	push   $0x804243
  801dcd:	e8 31 e6 ff ff       	call   800403 <cprintf>
  801dd2:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ddb:	eb 37                	jmp    801e14 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801ddd:	83 ec 0c             	sub    $0xc,%esp
  801de0:	ff 75 f4             	pushl  -0xc(%ebp)
  801de3:	e8 19 ff ff ff       	call   801d01 <is_free_block>
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	0f be d8             	movsbl %al,%ebx
  801dee:	83 ec 0c             	sub    $0xc,%esp
  801df1:	ff 75 f4             	pushl  -0xc(%ebp)
  801df4:	e8 ef fe ff ff       	call   801ce8 <get_block_size>
  801df9:	83 c4 10             	add    $0x10,%esp
  801dfc:	83 ec 04             	sub    $0x4,%esp
  801dff:	53                   	push   %ebx
  801e00:	50                   	push   %eax
  801e01:	68 5b 42 80 00       	push   $0x80425b
  801e06:	e8 f8 e5 ff ff       	call   800403 <cprintf>
  801e0b:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e18:	74 07                	je     801e21 <print_blocks_list+0x73>
  801e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1d:	8b 00                	mov    (%eax),%eax
  801e1f:	eb 05                	jmp    801e26 <print_blocks_list+0x78>
  801e21:	b8 00 00 00 00       	mov    $0x0,%eax
  801e26:	89 45 10             	mov    %eax,0x10(%ebp)
  801e29:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	75 ad                	jne    801ddd <print_blocks_list+0x2f>
  801e30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e34:	75 a7                	jne    801ddd <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	68 18 42 80 00       	push   $0x804218
  801e3e:	e8 c0 e5 ff ff       	call   800403 <cprintf>
  801e43:	83 c4 10             	add    $0x10,%esp

}
  801e46:	90                   	nop
  801e47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e55:	83 e0 01             	and    $0x1,%eax
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	74 03                	je     801e5f <initialize_dynamic_allocator+0x13>
  801e5c:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801e5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e63:	0f 84 c7 01 00 00    	je     802030 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801e69:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801e70:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801e73:	8b 55 08             	mov    0x8(%ebp),%edx
  801e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e79:	01 d0                	add    %edx,%eax
  801e7b:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801e80:	0f 87 ad 01 00 00    	ja     802033 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801e86:	8b 45 08             	mov    0x8(%ebp),%eax
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	0f 89 a5 01 00 00    	jns    802036 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801e91:	8b 55 08             	mov    0x8(%ebp),%edx
  801e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e97:	01 d0                	add    %edx,%eax
  801e99:	83 e8 04             	sub    $0x4,%eax
  801e9c:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801ea1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801ea8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb0:	e9 87 00 00 00       	jmp    801f3c <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801eb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb9:	75 14                	jne    801ecf <initialize_dynamic_allocator+0x83>
  801ebb:	83 ec 04             	sub    $0x4,%esp
  801ebe:	68 73 42 80 00       	push   $0x804273
  801ec3:	6a 79                	push   $0x79
  801ec5:	68 91 42 80 00       	push   $0x804291
  801eca:	e8 25 19 00 00       	call   8037f4 <_panic>
  801ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed2:	8b 00                	mov    (%eax),%eax
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	74 10                	je     801ee8 <initialize_dynamic_allocator+0x9c>
  801ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edb:	8b 00                	mov    (%eax),%eax
  801edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee0:	8b 52 04             	mov    0x4(%edx),%edx
  801ee3:	89 50 04             	mov    %edx,0x4(%eax)
  801ee6:	eb 0b                	jmp    801ef3 <initialize_dynamic_allocator+0xa7>
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	8b 40 04             	mov    0x4(%eax),%eax
  801eee:	a3 30 50 80 00       	mov    %eax,0x805030
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 40 04             	mov    0x4(%eax),%eax
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	74 0f                	je     801f0c <initialize_dynamic_allocator+0xc0>
  801efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f00:	8b 40 04             	mov    0x4(%eax),%eax
  801f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f06:	8b 12                	mov    (%edx),%edx
  801f08:	89 10                	mov    %edx,(%eax)
  801f0a:	eb 0a                	jmp    801f16 <initialize_dynamic_allocator+0xca>
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	8b 00                	mov    (%eax),%eax
  801f11:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f29:	a1 38 50 80 00       	mov    0x805038,%eax
  801f2e:	48                   	dec    %eax
  801f2f:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801f34:	a1 34 50 80 00       	mov    0x805034,%eax
  801f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f40:	74 07                	je     801f49 <initialize_dynamic_allocator+0xfd>
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 00                	mov    (%eax),%eax
  801f47:	eb 05                	jmp    801f4e <initialize_dynamic_allocator+0x102>
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	a3 34 50 80 00       	mov    %eax,0x805034
  801f53:	a1 34 50 80 00       	mov    0x805034,%eax
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	0f 85 55 ff ff ff    	jne    801eb5 <initialize_dynamic_allocator+0x69>
  801f60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f64:	0f 85 4b ff ff ff    	jne    801eb5 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f73:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801f79:	a1 44 50 80 00       	mov    0x805044,%eax
  801f7e:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801f83:	a1 40 50 80 00       	mov    0x805040,%eax
  801f88:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	83 c0 08             	add    $0x8,%eax
  801f94:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	83 c0 04             	add    $0x4,%eax
  801f9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa0:	83 ea 08             	sub    $0x8,%edx
  801fa3:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	01 d0                	add    %edx,%eax
  801fad:	83 e8 08             	sub    $0x8,%eax
  801fb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb3:	83 ea 08             	sub    $0x8,%edx
  801fb6:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801fc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801fcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fcf:	75 17                	jne    801fe8 <initialize_dynamic_allocator+0x19c>
  801fd1:	83 ec 04             	sub    $0x4,%esp
  801fd4:	68 ac 42 80 00       	push   $0x8042ac
  801fd9:	68 90 00 00 00       	push   $0x90
  801fde:	68 91 42 80 00       	push   $0x804291
  801fe3:	e8 0c 18 00 00       	call   8037f4 <_panic>
  801fe8:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801fee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff1:	89 10                	mov    %edx,(%eax)
  801ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff6:	8b 00                	mov    (%eax),%eax
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	74 0d                	je     802009 <initialize_dynamic_allocator+0x1bd>
  801ffc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802001:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802004:	89 50 04             	mov    %edx,0x4(%eax)
  802007:	eb 08                	jmp    802011 <initialize_dynamic_allocator+0x1c5>
  802009:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200c:	a3 30 50 80 00       	mov    %eax,0x805030
  802011:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802014:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802019:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802023:	a1 38 50 80 00       	mov    0x805038,%eax
  802028:	40                   	inc    %eax
  802029:	a3 38 50 80 00       	mov    %eax,0x805038
  80202e:	eb 07                	jmp    802037 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  802030:	90                   	nop
  802031:	eb 04                	jmp    802037 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802033:	90                   	nop
  802034:	eb 01                	jmp    802037 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802036:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80203c:	8b 45 10             	mov    0x10(%ebp),%eax
  80203f:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	8d 50 fc             	lea    -0x4(%eax),%edx
  802048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204b:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	83 e8 04             	sub    $0x4,%eax
  802053:	8b 00                	mov    (%eax),%eax
  802055:	83 e0 fe             	and    $0xfffffffe,%eax
  802058:	8d 50 f8             	lea    -0x8(%eax),%edx
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	01 c2                	add    %eax,%edx
  802060:	8b 45 0c             	mov    0xc(%ebp),%eax
  802063:	89 02                	mov    %eax,(%edx)
}
  802065:	90                   	nop
  802066:	5d                   	pop    %ebp
  802067:	c3                   	ret    

00802068 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
  80206b:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	83 e0 01             	and    $0x1,%eax
  802074:	85 c0                	test   %eax,%eax
  802076:	74 03                	je     80207b <alloc_block_FF+0x13>
  802078:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80207b:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80207f:	77 07                	ja     802088 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802081:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802088:	a1 24 50 80 00       	mov    0x805024,%eax
  80208d:	85 c0                	test   %eax,%eax
  80208f:	75 73                	jne    802104 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	83 c0 10             	add    $0x10,%eax
  802097:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80209a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a7:	01 d0                	add    %edx,%eax
  8020a9:	48                   	dec    %eax
  8020aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b5:	f7 75 ec             	divl   -0x14(%ebp)
  8020b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020bb:	29 d0                	sub    %edx,%eax
  8020bd:	c1 e8 0c             	shr    $0xc,%eax
  8020c0:	83 ec 0c             	sub    $0xc,%esp
  8020c3:	50                   	push   %eax
  8020c4:	e8 d4 f0 ff ff       	call   80119d <sbrk>
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8020cf:	83 ec 0c             	sub    $0xc,%esp
  8020d2:	6a 00                	push   $0x0
  8020d4:	e8 c4 f0 ff ff       	call   80119d <sbrk>
  8020d9:	83 c4 10             	add    $0x10,%esp
  8020dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8020df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020e2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8020e5:	83 ec 08             	sub    $0x8,%esp
  8020e8:	50                   	push   %eax
  8020e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020ec:	e8 5b fd ff ff       	call   801e4c <initialize_dynamic_allocator>
  8020f1:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8020f4:	83 ec 0c             	sub    $0xc,%esp
  8020f7:	68 cf 42 80 00       	push   $0x8042cf
  8020fc:	e8 02 e3 ff ff       	call   800403 <cprintf>
  802101:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802104:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802108:	75 0a                	jne    802114 <alloc_block_FF+0xac>
	        return NULL;
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
  80210f:	e9 0e 04 00 00       	jmp    802522 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802114:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  80211b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802120:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802123:	e9 f3 02 00 00       	jmp    80241b <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80212e:	83 ec 0c             	sub    $0xc,%esp
  802131:	ff 75 bc             	pushl  -0x44(%ebp)
  802134:	e8 af fb ff ff       	call   801ce8 <get_block_size>
  802139:	83 c4 10             	add    $0x10,%esp
  80213c:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	83 c0 08             	add    $0x8,%eax
  802145:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802148:	0f 87 c5 02 00 00    	ja     802413 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	83 c0 18             	add    $0x18,%eax
  802154:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802157:	0f 87 19 02 00 00    	ja     802376 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80215d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802160:	2b 45 08             	sub    0x8(%ebp),%eax
  802163:	83 e8 08             	sub    $0x8,%eax
  802166:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	8d 50 08             	lea    0x8(%eax),%edx
  80216f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802172:	01 d0                	add    %edx,%eax
  802174:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	83 c0 08             	add    $0x8,%eax
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	6a 01                	push   $0x1
  802182:	50                   	push   %eax
  802183:	ff 75 bc             	pushl  -0x44(%ebp)
  802186:	e8 ae fe ff ff       	call   802039 <set_block_data>
  80218b:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80218e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802191:	8b 40 04             	mov    0x4(%eax),%eax
  802194:	85 c0                	test   %eax,%eax
  802196:	75 68                	jne    802200 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802198:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80219c:	75 17                	jne    8021b5 <alloc_block_FF+0x14d>
  80219e:	83 ec 04             	sub    $0x4,%esp
  8021a1:	68 ac 42 80 00       	push   $0x8042ac
  8021a6:	68 d7 00 00 00       	push   $0xd7
  8021ab:	68 91 42 80 00       	push   $0x804291
  8021b0:	e8 3f 16 00 00       	call   8037f4 <_panic>
  8021b5:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8021bb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021be:	89 10                	mov    %edx,(%eax)
  8021c0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	74 0d                	je     8021d6 <alloc_block_FF+0x16e>
  8021c9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021ce:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021d1:	89 50 04             	mov    %edx,0x4(%eax)
  8021d4:	eb 08                	jmp    8021de <alloc_block_FF+0x176>
  8021d6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021d9:	a3 30 50 80 00       	mov    %eax,0x805030
  8021de:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021e6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f0:	a1 38 50 80 00       	mov    0x805038,%eax
  8021f5:	40                   	inc    %eax
  8021f6:	a3 38 50 80 00       	mov    %eax,0x805038
  8021fb:	e9 dc 00 00 00       	jmp    8022dc <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  802200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802203:	8b 00                	mov    (%eax),%eax
  802205:	85 c0                	test   %eax,%eax
  802207:	75 65                	jne    80226e <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802209:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80220d:	75 17                	jne    802226 <alloc_block_FF+0x1be>
  80220f:	83 ec 04             	sub    $0x4,%esp
  802212:	68 e0 42 80 00       	push   $0x8042e0
  802217:	68 db 00 00 00       	push   $0xdb
  80221c:	68 91 42 80 00       	push   $0x804291
  802221:	e8 ce 15 00 00       	call   8037f4 <_panic>
  802226:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80222c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80222f:	89 50 04             	mov    %edx,0x4(%eax)
  802232:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802235:	8b 40 04             	mov    0x4(%eax),%eax
  802238:	85 c0                	test   %eax,%eax
  80223a:	74 0c                	je     802248 <alloc_block_FF+0x1e0>
  80223c:	a1 30 50 80 00       	mov    0x805030,%eax
  802241:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802244:	89 10                	mov    %edx,(%eax)
  802246:	eb 08                	jmp    802250 <alloc_block_FF+0x1e8>
  802248:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80224b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802250:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802253:	a3 30 50 80 00       	mov    %eax,0x805030
  802258:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80225b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802261:	a1 38 50 80 00       	mov    0x805038,%eax
  802266:	40                   	inc    %eax
  802267:	a3 38 50 80 00       	mov    %eax,0x805038
  80226c:	eb 6e                	jmp    8022dc <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80226e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802272:	74 06                	je     80227a <alloc_block_FF+0x212>
  802274:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802278:	75 17                	jne    802291 <alloc_block_FF+0x229>
  80227a:	83 ec 04             	sub    $0x4,%esp
  80227d:	68 04 43 80 00       	push   $0x804304
  802282:	68 df 00 00 00       	push   $0xdf
  802287:	68 91 42 80 00       	push   $0x804291
  80228c:	e8 63 15 00 00       	call   8037f4 <_panic>
  802291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802294:	8b 10                	mov    (%eax),%edx
  802296:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802299:	89 10                	mov    %edx,(%eax)
  80229b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 0b                	je     8022af <alloc_block_FF+0x247>
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 00                	mov    (%eax),%eax
  8022a9:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022ac:	89 50 04             	mov    %edx,0x4(%eax)
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022b5:	89 10                	mov    %edx,(%eax)
  8022b7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bd:	89 50 04             	mov    %edx,0x4(%eax)
  8022c0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022c3:	8b 00                	mov    (%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	75 08                	jne    8022d1 <alloc_block_FF+0x269>
  8022c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022cc:	a3 30 50 80 00       	mov    %eax,0x805030
  8022d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8022d6:	40                   	inc    %eax
  8022d7:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8022dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e0:	75 17                	jne    8022f9 <alloc_block_FF+0x291>
  8022e2:	83 ec 04             	sub    $0x4,%esp
  8022e5:	68 73 42 80 00       	push   $0x804273
  8022ea:	68 e1 00 00 00       	push   $0xe1
  8022ef:	68 91 42 80 00       	push   $0x804291
  8022f4:	e8 fb 14 00 00       	call   8037f4 <_panic>
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	85 c0                	test   %eax,%eax
  802300:	74 10                	je     802312 <alloc_block_FF+0x2aa>
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 00                	mov    (%eax),%eax
  802307:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230a:	8b 52 04             	mov    0x4(%edx),%edx
  80230d:	89 50 04             	mov    %edx,0x4(%eax)
  802310:	eb 0b                	jmp    80231d <alloc_block_FF+0x2b5>
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 40 04             	mov    0x4(%eax),%eax
  802318:	a3 30 50 80 00       	mov    %eax,0x805030
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 40 04             	mov    0x4(%eax),%eax
  802323:	85 c0                	test   %eax,%eax
  802325:	74 0f                	je     802336 <alloc_block_FF+0x2ce>
  802327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232a:	8b 40 04             	mov    0x4(%eax),%eax
  80232d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802330:	8b 12                	mov    (%edx),%edx
  802332:	89 10                	mov    %edx,(%eax)
  802334:	eb 0a                	jmp    802340 <alloc_block_FF+0x2d8>
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 00                	mov    (%eax),%eax
  80233b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802353:	a1 38 50 80 00       	mov    0x805038,%eax
  802358:	48                   	dec    %eax
  802359:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  80235e:	83 ec 04             	sub    $0x4,%esp
  802361:	6a 00                	push   $0x0
  802363:	ff 75 b4             	pushl  -0x4c(%ebp)
  802366:	ff 75 b0             	pushl  -0x50(%ebp)
  802369:	e8 cb fc ff ff       	call   802039 <set_block_data>
  80236e:	83 c4 10             	add    $0x10,%esp
  802371:	e9 95 00 00 00       	jmp    80240b <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802376:	83 ec 04             	sub    $0x4,%esp
  802379:	6a 01                	push   $0x1
  80237b:	ff 75 b8             	pushl  -0x48(%ebp)
  80237e:	ff 75 bc             	pushl  -0x44(%ebp)
  802381:	e8 b3 fc ff ff       	call   802039 <set_block_data>
  802386:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238d:	75 17                	jne    8023a6 <alloc_block_FF+0x33e>
  80238f:	83 ec 04             	sub    $0x4,%esp
  802392:	68 73 42 80 00       	push   $0x804273
  802397:	68 e8 00 00 00       	push   $0xe8
  80239c:	68 91 42 80 00       	push   $0x804291
  8023a1:	e8 4e 14 00 00       	call   8037f4 <_panic>
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 00                	mov    (%eax),%eax
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	74 10                	je     8023bf <alloc_block_FF+0x357>
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b7:	8b 52 04             	mov    0x4(%edx),%edx
  8023ba:	89 50 04             	mov    %edx,0x4(%eax)
  8023bd:	eb 0b                	jmp    8023ca <alloc_block_FF+0x362>
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 40 04             	mov    0x4(%eax),%eax
  8023c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 40 04             	mov    0x4(%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	74 0f                	je     8023e3 <alloc_block_FF+0x37b>
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 40 04             	mov    0x4(%eax),%eax
  8023da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023dd:	8b 12                	mov    (%edx),%edx
  8023df:	89 10                	mov    %edx,(%eax)
  8023e1:	eb 0a                	jmp    8023ed <alloc_block_FF+0x385>
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802400:	a1 38 50 80 00       	mov    0x805038,%eax
  802405:	48                   	dec    %eax
  802406:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  80240b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80240e:	e9 0f 01 00 00       	jmp    802522 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802413:	a1 34 50 80 00       	mov    0x805034,%eax
  802418:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241f:	74 07                	je     802428 <alloc_block_FF+0x3c0>
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	8b 00                	mov    (%eax),%eax
  802426:	eb 05                	jmp    80242d <alloc_block_FF+0x3c5>
  802428:	b8 00 00 00 00       	mov    $0x0,%eax
  80242d:	a3 34 50 80 00       	mov    %eax,0x805034
  802432:	a1 34 50 80 00       	mov    0x805034,%eax
  802437:	85 c0                	test   %eax,%eax
  802439:	0f 85 e9 fc ff ff    	jne    802128 <alloc_block_FF+0xc0>
  80243f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802443:	0f 85 df fc ff ff    	jne    802128 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	83 c0 08             	add    $0x8,%eax
  80244f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802452:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802459:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80245c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80245f:	01 d0                	add    %edx,%eax
  802461:	48                   	dec    %eax
  802462:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802468:	ba 00 00 00 00       	mov    $0x0,%edx
  80246d:	f7 75 d8             	divl   -0x28(%ebp)
  802470:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802473:	29 d0                	sub    %edx,%eax
  802475:	c1 e8 0c             	shr    $0xc,%eax
  802478:	83 ec 0c             	sub    $0xc,%esp
  80247b:	50                   	push   %eax
  80247c:	e8 1c ed ff ff       	call   80119d <sbrk>
  802481:	83 c4 10             	add    $0x10,%esp
  802484:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802487:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80248b:	75 0a                	jne    802497 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
  802492:	e9 8b 00 00 00       	jmp    802522 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802497:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80249e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8024a4:	01 d0                	add    %edx,%eax
  8024a6:	48                   	dec    %eax
  8024a7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8024aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8024b2:	f7 75 cc             	divl   -0x34(%ebp)
  8024b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8024b8:	29 d0                	sub    %edx,%eax
  8024ba:	8d 50 fc             	lea    -0x4(%eax),%edx
  8024bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024c0:	01 d0                	add    %edx,%eax
  8024c2:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  8024c7:	a1 40 50 80 00       	mov    0x805040,%eax
  8024cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8024d2:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8024d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024df:	01 d0                	add    %edx,%eax
  8024e1:	48                   	dec    %eax
  8024e2:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8024e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8024ed:	f7 75 c4             	divl   -0x3c(%ebp)
  8024f0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024f3:	29 d0                	sub    %edx,%eax
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	6a 01                	push   $0x1
  8024fa:	50                   	push   %eax
  8024fb:	ff 75 d0             	pushl  -0x30(%ebp)
  8024fe:	e8 36 fb ff ff       	call   802039 <set_block_data>
  802503:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802506:	83 ec 0c             	sub    $0xc,%esp
  802509:	ff 75 d0             	pushl  -0x30(%ebp)
  80250c:	e8 1b 0a 00 00       	call   802f2c <free_block>
  802511:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802514:	83 ec 0c             	sub    $0xc,%esp
  802517:	ff 75 08             	pushl  0x8(%ebp)
  80251a:	e8 49 fb ff ff       	call   802068 <alloc_block_FF>
  80251f:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	83 e0 01             	and    $0x1,%eax
  802530:	85 c0                	test   %eax,%eax
  802532:	74 03                	je     802537 <alloc_block_BF+0x13>
  802534:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802537:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80253b:	77 07                	ja     802544 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80253d:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802544:	a1 24 50 80 00       	mov    0x805024,%eax
  802549:	85 c0                	test   %eax,%eax
  80254b:	75 73                	jne    8025c0 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	83 c0 10             	add    $0x10,%eax
  802553:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802556:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80255d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802560:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802563:	01 d0                	add    %edx,%eax
  802565:	48                   	dec    %eax
  802566:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802569:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80256c:	ba 00 00 00 00       	mov    $0x0,%edx
  802571:	f7 75 e0             	divl   -0x20(%ebp)
  802574:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802577:	29 d0                	sub    %edx,%eax
  802579:	c1 e8 0c             	shr    $0xc,%eax
  80257c:	83 ec 0c             	sub    $0xc,%esp
  80257f:	50                   	push   %eax
  802580:	e8 18 ec ff ff       	call   80119d <sbrk>
  802585:	83 c4 10             	add    $0x10,%esp
  802588:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80258b:	83 ec 0c             	sub    $0xc,%esp
  80258e:	6a 00                	push   $0x0
  802590:	e8 08 ec ff ff       	call   80119d <sbrk>
  802595:	83 c4 10             	add    $0x10,%esp
  802598:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80259b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80259e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8025a1:	83 ec 08             	sub    $0x8,%esp
  8025a4:	50                   	push   %eax
  8025a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8025a8:	e8 9f f8 ff ff       	call   801e4c <initialize_dynamic_allocator>
  8025ad:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8025b0:	83 ec 0c             	sub    $0xc,%esp
  8025b3:	68 cf 42 80 00       	push   $0x8042cf
  8025b8:	e8 46 de ff ff       	call   800403 <cprintf>
  8025bd:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8025c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8025c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8025ce:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8025d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8025dc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8025e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e4:	e9 1d 01 00 00       	jmp    802706 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8025ef:	83 ec 0c             	sub    $0xc,%esp
  8025f2:	ff 75 a8             	pushl  -0x58(%ebp)
  8025f5:	e8 ee f6 ff ff       	call   801ce8 <get_block_size>
  8025fa:	83 c4 10             	add    $0x10,%esp
  8025fd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	83 c0 08             	add    $0x8,%eax
  802606:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802609:	0f 87 ef 00 00 00    	ja     8026fe <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80260f:	8b 45 08             	mov    0x8(%ebp),%eax
  802612:	83 c0 18             	add    $0x18,%eax
  802615:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802618:	77 1d                	ja     802637 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  80261a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802620:	0f 86 d8 00 00 00    	jbe    8026fe <alloc_block_BF+0x1da>
				{
					best_va = va;
  802626:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802629:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80262c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80262f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802632:	e9 c7 00 00 00       	jmp    8026fe <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802637:	8b 45 08             	mov    0x8(%ebp),%eax
  80263a:	83 c0 08             	add    $0x8,%eax
  80263d:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802640:	0f 85 9d 00 00 00    	jne    8026e3 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802646:	83 ec 04             	sub    $0x4,%esp
  802649:	6a 01                	push   $0x1
  80264b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80264e:	ff 75 a8             	pushl  -0x58(%ebp)
  802651:	e8 e3 f9 ff ff       	call   802039 <set_block_data>
  802656:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802659:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265d:	75 17                	jne    802676 <alloc_block_BF+0x152>
  80265f:	83 ec 04             	sub    $0x4,%esp
  802662:	68 73 42 80 00       	push   $0x804273
  802667:	68 2c 01 00 00       	push   $0x12c
  80266c:	68 91 42 80 00       	push   $0x804291
  802671:	e8 7e 11 00 00       	call   8037f4 <_panic>
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 00                	mov    (%eax),%eax
  80267b:	85 c0                	test   %eax,%eax
  80267d:	74 10                	je     80268f <alloc_block_BF+0x16b>
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 00                	mov    (%eax),%eax
  802684:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802687:	8b 52 04             	mov    0x4(%edx),%edx
  80268a:	89 50 04             	mov    %edx,0x4(%eax)
  80268d:	eb 0b                	jmp    80269a <alloc_block_BF+0x176>
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 04             	mov    0x4(%eax),%eax
  802695:	a3 30 50 80 00       	mov    %eax,0x805030
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 40 04             	mov    0x4(%eax),%eax
  8026a0:	85 c0                	test   %eax,%eax
  8026a2:	74 0f                	je     8026b3 <alloc_block_BF+0x18f>
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 40 04             	mov    0x4(%eax),%eax
  8026aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ad:	8b 12                	mov    (%edx),%edx
  8026af:	89 10                	mov    %edx,(%eax)
  8026b1:	eb 0a                	jmp    8026bd <alloc_block_BF+0x199>
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 00                	mov    (%eax),%eax
  8026b8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8026d5:	48                   	dec    %eax
  8026d6:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  8026db:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026de:	e9 24 04 00 00       	jmp    802b07 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8026e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e6:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026e9:	76 13                	jbe    8026fe <alloc_block_BF+0x1da>
					{
						internal = 1;
  8026eb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8026f2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8026f8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026fb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8026fe:	a1 34 50 80 00       	mov    0x805034,%eax
  802703:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802706:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270a:	74 07                	je     802713 <alloc_block_BF+0x1ef>
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	eb 05                	jmp    802718 <alloc_block_BF+0x1f4>
  802713:	b8 00 00 00 00       	mov    $0x0,%eax
  802718:	a3 34 50 80 00       	mov    %eax,0x805034
  80271d:	a1 34 50 80 00       	mov    0x805034,%eax
  802722:	85 c0                	test   %eax,%eax
  802724:	0f 85 bf fe ff ff    	jne    8025e9 <alloc_block_BF+0xc5>
  80272a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272e:	0f 85 b5 fe ff ff    	jne    8025e9 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802738:	0f 84 26 02 00 00    	je     802964 <alloc_block_BF+0x440>
  80273e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802742:	0f 85 1c 02 00 00    	jne    802964 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274b:	2b 45 08             	sub    0x8(%ebp),%eax
  80274e:	83 e8 08             	sub    $0x8,%eax
  802751:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	8d 50 08             	lea    0x8(%eax),%edx
  80275a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275d:	01 d0                	add    %edx,%eax
  80275f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802762:	8b 45 08             	mov    0x8(%ebp),%eax
  802765:	83 c0 08             	add    $0x8,%eax
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	6a 01                	push   $0x1
  80276d:	50                   	push   %eax
  80276e:	ff 75 f0             	pushl  -0x10(%ebp)
  802771:	e8 c3 f8 ff ff       	call   802039 <set_block_data>
  802776:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277c:	8b 40 04             	mov    0x4(%eax),%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	75 68                	jne    8027eb <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802783:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802787:	75 17                	jne    8027a0 <alloc_block_BF+0x27c>
  802789:	83 ec 04             	sub    $0x4,%esp
  80278c:	68 ac 42 80 00       	push   $0x8042ac
  802791:	68 45 01 00 00       	push   $0x145
  802796:	68 91 42 80 00       	push   $0x804291
  80279b:	e8 54 10 00 00       	call   8037f4 <_panic>
  8027a0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8027a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027a9:	89 10                	mov    %edx,(%eax)
  8027ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	74 0d                	je     8027c1 <alloc_block_BF+0x29d>
  8027b4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8027b9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027bc:	89 50 04             	mov    %edx,0x4(%eax)
  8027bf:	eb 08                	jmp    8027c9 <alloc_block_BF+0x2a5>
  8027c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027c4:	a3 30 50 80 00       	mov    %eax,0x805030
  8027c9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027cc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027db:	a1 38 50 80 00       	mov    0x805038,%eax
  8027e0:	40                   	inc    %eax
  8027e1:	a3 38 50 80 00       	mov    %eax,0x805038
  8027e6:	e9 dc 00 00 00       	jmp    8028c7 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	75 65                	jne    802859 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027f4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027f8:	75 17                	jne    802811 <alloc_block_BF+0x2ed>
  8027fa:	83 ec 04             	sub    $0x4,%esp
  8027fd:	68 e0 42 80 00       	push   $0x8042e0
  802802:	68 4a 01 00 00       	push   $0x14a
  802807:	68 91 42 80 00       	push   $0x804291
  80280c:	e8 e3 0f 00 00       	call   8037f4 <_panic>
  802811:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802817:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80281a:	89 50 04             	mov    %edx,0x4(%eax)
  80281d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802820:	8b 40 04             	mov    0x4(%eax),%eax
  802823:	85 c0                	test   %eax,%eax
  802825:	74 0c                	je     802833 <alloc_block_BF+0x30f>
  802827:	a1 30 50 80 00       	mov    0x805030,%eax
  80282c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80282f:	89 10                	mov    %edx,(%eax)
  802831:	eb 08                	jmp    80283b <alloc_block_BF+0x317>
  802833:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802836:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80283b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283e:	a3 30 50 80 00       	mov    %eax,0x805030
  802843:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802846:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284c:	a1 38 50 80 00       	mov    0x805038,%eax
  802851:	40                   	inc    %eax
  802852:	a3 38 50 80 00       	mov    %eax,0x805038
  802857:	eb 6e                	jmp    8028c7 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802859:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80285d:	74 06                	je     802865 <alloc_block_BF+0x341>
  80285f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802863:	75 17                	jne    80287c <alloc_block_BF+0x358>
  802865:	83 ec 04             	sub    $0x4,%esp
  802868:	68 04 43 80 00       	push   $0x804304
  80286d:	68 4f 01 00 00       	push   $0x14f
  802872:	68 91 42 80 00       	push   $0x804291
  802877:	e8 78 0f 00 00       	call   8037f4 <_panic>
  80287c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287f:	8b 10                	mov    (%eax),%edx
  802881:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802884:	89 10                	mov    %edx,(%eax)
  802886:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	74 0b                	je     80289a <alloc_block_BF+0x376>
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802897:	89 50 04             	mov    %edx,0x4(%eax)
  80289a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028a0:	89 10                	mov    %edx,(%eax)
  8028a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a8:	89 50 04             	mov    %edx,0x4(%eax)
  8028ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	75 08                	jne    8028bc <alloc_block_BF+0x398>
  8028b4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028b7:	a3 30 50 80 00       	mov    %eax,0x805030
  8028bc:	a1 38 50 80 00       	mov    0x805038,%eax
  8028c1:	40                   	inc    %eax
  8028c2:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8028c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028cb:	75 17                	jne    8028e4 <alloc_block_BF+0x3c0>
  8028cd:	83 ec 04             	sub    $0x4,%esp
  8028d0:	68 73 42 80 00       	push   $0x804273
  8028d5:	68 51 01 00 00       	push   $0x151
  8028da:	68 91 42 80 00       	push   $0x804291
  8028df:	e8 10 0f 00 00       	call   8037f4 <_panic>
  8028e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e7:	8b 00                	mov    (%eax),%eax
  8028e9:	85 c0                	test   %eax,%eax
  8028eb:	74 10                	je     8028fd <alloc_block_BF+0x3d9>
  8028ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f5:	8b 52 04             	mov    0x4(%edx),%edx
  8028f8:	89 50 04             	mov    %edx,0x4(%eax)
  8028fb:	eb 0b                	jmp    802908 <alloc_block_BF+0x3e4>
  8028fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802900:	8b 40 04             	mov    0x4(%eax),%eax
  802903:	a3 30 50 80 00       	mov    %eax,0x805030
  802908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	74 0f                	je     802921 <alloc_block_BF+0x3fd>
  802912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802915:	8b 40 04             	mov    0x4(%eax),%eax
  802918:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291b:	8b 12                	mov    (%edx),%edx
  80291d:	89 10                	mov    %edx,(%eax)
  80291f:	eb 0a                	jmp    80292b <alloc_block_BF+0x407>
  802921:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802924:	8b 00                	mov    (%eax),%eax
  802926:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802937:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293e:	a1 38 50 80 00       	mov    0x805038,%eax
  802943:	48                   	dec    %eax
  802944:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  802949:	83 ec 04             	sub    $0x4,%esp
  80294c:	6a 00                	push   $0x0
  80294e:	ff 75 d0             	pushl  -0x30(%ebp)
  802951:	ff 75 cc             	pushl  -0x34(%ebp)
  802954:	e8 e0 f6 ff ff       	call   802039 <set_block_data>
  802959:	83 c4 10             	add    $0x10,%esp
			return best_va;
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	e9 a3 01 00 00       	jmp    802b07 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802964:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802968:	0f 85 9d 00 00 00    	jne    802a0b <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  80296e:	83 ec 04             	sub    $0x4,%esp
  802971:	6a 01                	push   $0x1
  802973:	ff 75 ec             	pushl  -0x14(%ebp)
  802976:	ff 75 f0             	pushl  -0x10(%ebp)
  802979:	e8 bb f6 ff ff       	call   802039 <set_block_data>
  80297e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802981:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802985:	75 17                	jne    80299e <alloc_block_BF+0x47a>
  802987:	83 ec 04             	sub    $0x4,%esp
  80298a:	68 73 42 80 00       	push   $0x804273
  80298f:	68 58 01 00 00       	push   $0x158
  802994:	68 91 42 80 00       	push   $0x804291
  802999:	e8 56 0e 00 00       	call   8037f4 <_panic>
  80299e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a1:	8b 00                	mov    (%eax),%eax
  8029a3:	85 c0                	test   %eax,%eax
  8029a5:	74 10                	je     8029b7 <alloc_block_BF+0x493>
  8029a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029aa:	8b 00                	mov    (%eax),%eax
  8029ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029af:	8b 52 04             	mov    0x4(%edx),%edx
  8029b2:	89 50 04             	mov    %edx,0x4(%eax)
  8029b5:	eb 0b                	jmp    8029c2 <alloc_block_BF+0x49e>
  8029b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ba:	8b 40 04             	mov    0x4(%eax),%eax
  8029bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c5:	8b 40 04             	mov    0x4(%eax),%eax
  8029c8:	85 c0                	test   %eax,%eax
  8029ca:	74 0f                	je     8029db <alloc_block_BF+0x4b7>
  8029cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cf:	8b 40 04             	mov    0x4(%eax),%eax
  8029d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d5:	8b 12                	mov    (%edx),%edx
  8029d7:	89 10                	mov    %edx,(%eax)
  8029d9:	eb 0a                	jmp    8029e5 <alloc_block_BF+0x4c1>
  8029db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f8:	a1 38 50 80 00       	mov    0x805038,%eax
  8029fd:	48                   	dec    %eax
  8029fe:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a06:	e9 fc 00 00 00       	jmp    802b07 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	83 c0 08             	add    $0x8,%eax
  802a11:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802a14:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802a1b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a1e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a21:	01 d0                	add    %edx,%eax
  802a23:	48                   	dec    %eax
  802a24:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802a27:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a2a:	ba 00 00 00 00       	mov    $0x0,%edx
  802a2f:	f7 75 c4             	divl   -0x3c(%ebp)
  802a32:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a35:	29 d0                	sub    %edx,%eax
  802a37:	c1 e8 0c             	shr    $0xc,%eax
  802a3a:	83 ec 0c             	sub    $0xc,%esp
  802a3d:	50                   	push   %eax
  802a3e:	e8 5a e7 ff ff       	call   80119d <sbrk>
  802a43:	83 c4 10             	add    $0x10,%esp
  802a46:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802a49:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802a4d:	75 0a                	jne    802a59 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a54:	e9 ae 00 00 00       	jmp    802b07 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a59:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802a60:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a63:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a66:	01 d0                	add    %edx,%eax
  802a68:	48                   	dec    %eax
  802a69:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802a6c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a6f:	ba 00 00 00 00       	mov    $0x0,%edx
  802a74:	f7 75 b8             	divl   -0x48(%ebp)
  802a77:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a7a:	29 d0                	sub    %edx,%eax
  802a7c:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a7f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a82:	01 d0                	add    %edx,%eax
  802a84:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802a89:	a1 40 50 80 00       	mov    0x805040,%eax
  802a8e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802a94:	83 ec 0c             	sub    $0xc,%esp
  802a97:	68 38 43 80 00       	push   $0x804338
  802a9c:	e8 62 d9 ff ff       	call   800403 <cprintf>
  802aa1:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802aa4:	83 ec 08             	sub    $0x8,%esp
  802aa7:	ff 75 bc             	pushl  -0x44(%ebp)
  802aaa:	68 3d 43 80 00       	push   $0x80433d
  802aaf:	e8 4f d9 ff ff       	call   800403 <cprintf>
  802ab4:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802ab7:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802abe:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802ac1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802ac4:	01 d0                	add    %edx,%eax
  802ac6:	48                   	dec    %eax
  802ac7:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802aca:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802acd:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad2:	f7 75 b0             	divl   -0x50(%ebp)
  802ad5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ad8:	29 d0                	sub    %edx,%eax
  802ada:	83 ec 04             	sub    $0x4,%esp
  802add:	6a 01                	push   $0x1
  802adf:	50                   	push   %eax
  802ae0:	ff 75 bc             	pushl  -0x44(%ebp)
  802ae3:	e8 51 f5 ff ff       	call   802039 <set_block_data>
  802ae8:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802aeb:	83 ec 0c             	sub    $0xc,%esp
  802aee:	ff 75 bc             	pushl  -0x44(%ebp)
  802af1:	e8 36 04 00 00       	call   802f2c <free_block>
  802af6:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802af9:	83 ec 0c             	sub    $0xc,%esp
  802afc:	ff 75 08             	pushl  0x8(%ebp)
  802aff:	e8 20 fa ff ff       	call   802524 <alloc_block_BF>
  802b04:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802b07:	c9                   	leave  
  802b08:	c3                   	ret    

00802b09 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802b09:	55                   	push   %ebp
  802b0a:	89 e5                	mov    %esp,%ebp
  802b0c:	53                   	push   %ebx
  802b0d:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802b10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b17:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802b1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b22:	74 1e                	je     802b42 <merging+0x39>
  802b24:	ff 75 08             	pushl  0x8(%ebp)
  802b27:	e8 bc f1 ff ff       	call   801ce8 <get_block_size>
  802b2c:	83 c4 04             	add    $0x4,%esp
  802b2f:	89 c2                	mov    %eax,%edx
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	01 d0                	add    %edx,%eax
  802b36:	3b 45 10             	cmp    0x10(%ebp),%eax
  802b39:	75 07                	jne    802b42 <merging+0x39>
		prev_is_free = 1;
  802b3b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802b42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b46:	74 1e                	je     802b66 <merging+0x5d>
  802b48:	ff 75 10             	pushl  0x10(%ebp)
  802b4b:	e8 98 f1 ff ff       	call   801ce8 <get_block_size>
  802b50:	83 c4 04             	add    $0x4,%esp
  802b53:	89 c2                	mov    %eax,%edx
  802b55:	8b 45 10             	mov    0x10(%ebp),%eax
  802b58:	01 d0                	add    %edx,%eax
  802b5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b5d:	75 07                	jne    802b66 <merging+0x5d>
		next_is_free = 1;
  802b5f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6a:	0f 84 cc 00 00 00    	je     802c3c <merging+0x133>
  802b70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b74:	0f 84 c2 00 00 00    	je     802c3c <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802b7a:	ff 75 08             	pushl  0x8(%ebp)
  802b7d:	e8 66 f1 ff ff       	call   801ce8 <get_block_size>
  802b82:	83 c4 04             	add    $0x4,%esp
  802b85:	89 c3                	mov    %eax,%ebx
  802b87:	ff 75 10             	pushl  0x10(%ebp)
  802b8a:	e8 59 f1 ff ff       	call   801ce8 <get_block_size>
  802b8f:	83 c4 04             	add    $0x4,%esp
  802b92:	01 c3                	add    %eax,%ebx
  802b94:	ff 75 0c             	pushl  0xc(%ebp)
  802b97:	e8 4c f1 ff ff       	call   801ce8 <get_block_size>
  802b9c:	83 c4 04             	add    $0x4,%esp
  802b9f:	01 d8                	add    %ebx,%eax
  802ba1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ba4:	6a 00                	push   $0x0
  802ba6:	ff 75 ec             	pushl  -0x14(%ebp)
  802ba9:	ff 75 08             	pushl  0x8(%ebp)
  802bac:	e8 88 f4 ff ff       	call   802039 <set_block_data>
  802bb1:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802bb4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bb8:	75 17                	jne    802bd1 <merging+0xc8>
  802bba:	83 ec 04             	sub    $0x4,%esp
  802bbd:	68 73 42 80 00       	push   $0x804273
  802bc2:	68 7d 01 00 00       	push   $0x17d
  802bc7:	68 91 42 80 00       	push   $0x804291
  802bcc:	e8 23 0c 00 00       	call   8037f4 <_panic>
  802bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd4:	8b 00                	mov    (%eax),%eax
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	74 10                	je     802bea <merging+0xe1>
  802bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802be2:	8b 52 04             	mov    0x4(%edx),%edx
  802be5:	89 50 04             	mov    %edx,0x4(%eax)
  802be8:	eb 0b                	jmp    802bf5 <merging+0xec>
  802bea:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bed:	8b 40 04             	mov    0x4(%eax),%eax
  802bf0:	a3 30 50 80 00       	mov    %eax,0x805030
  802bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	74 0f                	je     802c0e <merging+0x105>
  802bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c02:	8b 40 04             	mov    0x4(%eax),%eax
  802c05:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c08:	8b 12                	mov    (%edx),%edx
  802c0a:	89 10                	mov    %edx,(%eax)
  802c0c:	eb 0a                	jmp    802c18 <merging+0x10f>
  802c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c11:	8b 00                	mov    (%eax),%eax
  802c13:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2b:	a1 38 50 80 00       	mov    0x805038,%eax
  802c30:	48                   	dec    %eax
  802c31:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802c36:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c37:	e9 ea 02 00 00       	jmp    802f26 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802c3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c40:	74 3b                	je     802c7d <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802c42:	83 ec 0c             	sub    $0xc,%esp
  802c45:	ff 75 08             	pushl  0x8(%ebp)
  802c48:	e8 9b f0 ff ff       	call   801ce8 <get_block_size>
  802c4d:	83 c4 10             	add    $0x10,%esp
  802c50:	89 c3                	mov    %eax,%ebx
  802c52:	83 ec 0c             	sub    $0xc,%esp
  802c55:	ff 75 10             	pushl  0x10(%ebp)
  802c58:	e8 8b f0 ff ff       	call   801ce8 <get_block_size>
  802c5d:	83 c4 10             	add    $0x10,%esp
  802c60:	01 d8                	add    %ebx,%eax
  802c62:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c65:	83 ec 04             	sub    $0x4,%esp
  802c68:	6a 00                	push   $0x0
  802c6a:	ff 75 e8             	pushl  -0x18(%ebp)
  802c6d:	ff 75 08             	pushl  0x8(%ebp)
  802c70:	e8 c4 f3 ff ff       	call   802039 <set_block_data>
  802c75:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c78:	e9 a9 02 00 00       	jmp    802f26 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802c7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c81:	0f 84 2d 01 00 00    	je     802db4 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802c87:	83 ec 0c             	sub    $0xc,%esp
  802c8a:	ff 75 10             	pushl  0x10(%ebp)
  802c8d:	e8 56 f0 ff ff       	call   801ce8 <get_block_size>
  802c92:	83 c4 10             	add    $0x10,%esp
  802c95:	89 c3                	mov    %eax,%ebx
  802c97:	83 ec 0c             	sub    $0xc,%esp
  802c9a:	ff 75 0c             	pushl  0xc(%ebp)
  802c9d:	e8 46 f0 ff ff       	call   801ce8 <get_block_size>
  802ca2:	83 c4 10             	add    $0x10,%esp
  802ca5:	01 d8                	add    %ebx,%eax
  802ca7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802caa:	83 ec 04             	sub    $0x4,%esp
  802cad:	6a 00                	push   $0x0
  802caf:	ff 75 e4             	pushl  -0x1c(%ebp)
  802cb2:	ff 75 10             	pushl  0x10(%ebp)
  802cb5:	e8 7f f3 ff ff       	call   802039 <set_block_data>
  802cba:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  802cc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802cc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cc7:	74 06                	je     802ccf <merging+0x1c6>
  802cc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ccd:	75 17                	jne    802ce6 <merging+0x1dd>
  802ccf:	83 ec 04             	sub    $0x4,%esp
  802cd2:	68 4c 43 80 00       	push   $0x80434c
  802cd7:	68 8d 01 00 00       	push   $0x18d
  802cdc:	68 91 42 80 00       	push   $0x804291
  802ce1:	e8 0e 0b 00 00       	call   8037f4 <_panic>
  802ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ce9:	8b 50 04             	mov    0x4(%eax),%edx
  802cec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cef:	89 50 04             	mov    %edx,0x4(%eax)
  802cf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cf8:	89 10                	mov    %edx,(%eax)
  802cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfd:	8b 40 04             	mov    0x4(%eax),%eax
  802d00:	85 c0                	test   %eax,%eax
  802d02:	74 0d                	je     802d11 <merging+0x208>
  802d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d07:	8b 40 04             	mov    0x4(%eax),%eax
  802d0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d0d:	89 10                	mov    %edx,(%eax)
  802d0f:	eb 08                	jmp    802d19 <merging+0x210>
  802d11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d14:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d1f:	89 50 04             	mov    %edx,0x4(%eax)
  802d22:	a1 38 50 80 00       	mov    0x805038,%eax
  802d27:	40                   	inc    %eax
  802d28:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802d2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d31:	75 17                	jne    802d4a <merging+0x241>
  802d33:	83 ec 04             	sub    $0x4,%esp
  802d36:	68 73 42 80 00       	push   $0x804273
  802d3b:	68 8e 01 00 00       	push   $0x18e
  802d40:	68 91 42 80 00       	push   $0x804291
  802d45:	e8 aa 0a 00 00       	call   8037f4 <_panic>
  802d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	85 c0                	test   %eax,%eax
  802d51:	74 10                	je     802d63 <merging+0x25a>
  802d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d5b:	8b 52 04             	mov    0x4(%edx),%edx
  802d5e:	89 50 04             	mov    %edx,0x4(%eax)
  802d61:	eb 0b                	jmp    802d6e <merging+0x265>
  802d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d66:	8b 40 04             	mov    0x4(%eax),%eax
  802d69:	a3 30 50 80 00       	mov    %eax,0x805030
  802d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d71:	8b 40 04             	mov    0x4(%eax),%eax
  802d74:	85 c0                	test   %eax,%eax
  802d76:	74 0f                	je     802d87 <merging+0x27e>
  802d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d7b:	8b 40 04             	mov    0x4(%eax),%eax
  802d7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d81:	8b 12                	mov    (%edx),%edx
  802d83:	89 10                	mov    %edx,(%eax)
  802d85:	eb 0a                	jmp    802d91 <merging+0x288>
  802d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d8a:	8b 00                	mov    (%eax),%eax
  802d8c:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da4:	a1 38 50 80 00       	mov    0x805038,%eax
  802da9:	48                   	dec    %eax
  802daa:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802daf:	e9 72 01 00 00       	jmp    802f26 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802db4:	8b 45 10             	mov    0x10(%ebp),%eax
  802db7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802dba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbe:	74 79                	je     802e39 <merging+0x330>
  802dc0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dc4:	74 73                	je     802e39 <merging+0x330>
  802dc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dca:	74 06                	je     802dd2 <merging+0x2c9>
  802dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802dd0:	75 17                	jne    802de9 <merging+0x2e0>
  802dd2:	83 ec 04             	sub    $0x4,%esp
  802dd5:	68 04 43 80 00       	push   $0x804304
  802dda:	68 94 01 00 00       	push   $0x194
  802ddf:	68 91 42 80 00       	push   $0x804291
  802de4:	e8 0b 0a 00 00       	call   8037f4 <_panic>
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	8b 10                	mov    (%eax),%edx
  802dee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df1:	89 10                	mov    %edx,(%eax)
  802df3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	74 0b                	je     802e07 <merging+0x2fe>
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	8b 00                	mov    (%eax),%eax
  802e01:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e04:	89 50 04             	mov    %edx,0x4(%eax)
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e0d:	89 10                	mov    %edx,(%eax)
  802e0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e12:	8b 55 08             	mov    0x8(%ebp),%edx
  802e15:	89 50 04             	mov    %edx,0x4(%eax)
  802e18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	75 08                	jne    802e29 <merging+0x320>
  802e21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e24:	a3 30 50 80 00       	mov    %eax,0x805030
  802e29:	a1 38 50 80 00       	mov    0x805038,%eax
  802e2e:	40                   	inc    %eax
  802e2f:	a3 38 50 80 00       	mov    %eax,0x805038
  802e34:	e9 ce 00 00 00       	jmp    802f07 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802e39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3d:	74 65                	je     802ea4 <merging+0x39b>
  802e3f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e43:	75 17                	jne    802e5c <merging+0x353>
  802e45:	83 ec 04             	sub    $0x4,%esp
  802e48:	68 e0 42 80 00       	push   $0x8042e0
  802e4d:	68 95 01 00 00       	push   $0x195
  802e52:	68 91 42 80 00       	push   $0x804291
  802e57:	e8 98 09 00 00       	call   8037f4 <_panic>
  802e5c:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e62:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e65:	89 50 04             	mov    %edx,0x4(%eax)
  802e68:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e6b:	8b 40 04             	mov    0x4(%eax),%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	74 0c                	je     802e7e <merging+0x375>
  802e72:	a1 30 50 80 00       	mov    0x805030,%eax
  802e77:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e7a:	89 10                	mov    %edx,(%eax)
  802e7c:	eb 08                	jmp    802e86 <merging+0x37d>
  802e7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e81:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e89:	a3 30 50 80 00       	mov    %eax,0x805030
  802e8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e97:	a1 38 50 80 00       	mov    0x805038,%eax
  802e9c:	40                   	inc    %eax
  802e9d:	a3 38 50 80 00       	mov    %eax,0x805038
  802ea2:	eb 63                	jmp    802f07 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802ea4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ea8:	75 17                	jne    802ec1 <merging+0x3b8>
  802eaa:	83 ec 04             	sub    $0x4,%esp
  802ead:	68 ac 42 80 00       	push   $0x8042ac
  802eb2:	68 98 01 00 00       	push   $0x198
  802eb7:	68 91 42 80 00       	push   $0x804291
  802ebc:	e8 33 09 00 00       	call   8037f4 <_panic>
  802ec1:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802ec7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eca:	89 10                	mov    %edx,(%eax)
  802ecc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ecf:	8b 00                	mov    (%eax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	74 0d                	je     802ee2 <merging+0x3d9>
  802ed5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eda:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802edd:	89 50 04             	mov    %edx,0x4(%eax)
  802ee0:	eb 08                	jmp    802eea <merging+0x3e1>
  802ee2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee5:	a3 30 50 80 00       	mov    %eax,0x805030
  802eea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eed:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ef2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efc:	a1 38 50 80 00       	mov    0x805038,%eax
  802f01:	40                   	inc    %eax
  802f02:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802f07:	83 ec 0c             	sub    $0xc,%esp
  802f0a:	ff 75 10             	pushl  0x10(%ebp)
  802f0d:	e8 d6 ed ff ff       	call   801ce8 <get_block_size>
  802f12:	83 c4 10             	add    $0x10,%esp
  802f15:	83 ec 04             	sub    $0x4,%esp
  802f18:	6a 00                	push   $0x0
  802f1a:	50                   	push   %eax
  802f1b:	ff 75 10             	pushl  0x10(%ebp)
  802f1e:	e8 16 f1 ff ff       	call   802039 <set_block_data>
  802f23:	83 c4 10             	add    $0x10,%esp
	}
}
  802f26:	90                   	nop
  802f27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f2a:	c9                   	leave  
  802f2b:	c3                   	ret    

00802f2c <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802f2c:	55                   	push   %ebp
  802f2d:	89 e5                	mov    %esp,%ebp
  802f2f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802f32:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f37:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802f3a:	a1 30 50 80 00       	mov    0x805030,%eax
  802f3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f42:	73 1b                	jae    802f5f <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802f44:	a1 30 50 80 00       	mov    0x805030,%eax
  802f49:	83 ec 04             	sub    $0x4,%esp
  802f4c:	ff 75 08             	pushl  0x8(%ebp)
  802f4f:	6a 00                	push   $0x0
  802f51:	50                   	push   %eax
  802f52:	e8 b2 fb ff ff       	call   802b09 <merging>
  802f57:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f5a:	e9 8b 00 00 00       	jmp    802fea <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802f5f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f67:	76 18                	jbe    802f81 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802f69:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f6e:	83 ec 04             	sub    $0x4,%esp
  802f71:	ff 75 08             	pushl  0x8(%ebp)
  802f74:	50                   	push   %eax
  802f75:	6a 00                	push   $0x0
  802f77:	e8 8d fb ff ff       	call   802b09 <merging>
  802f7c:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f7f:	eb 69                	jmp    802fea <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f81:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f89:	eb 39                	jmp    802fc4 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f91:	73 29                	jae    802fbc <free_block+0x90>
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	8b 00                	mov    (%eax),%eax
  802f98:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f9b:	76 1f                	jbe    802fbc <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 00                	mov    (%eax),%eax
  802fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802fa5:	83 ec 04             	sub    $0x4,%esp
  802fa8:	ff 75 08             	pushl  0x8(%ebp)
  802fab:	ff 75 f0             	pushl  -0x10(%ebp)
  802fae:	ff 75 f4             	pushl  -0xc(%ebp)
  802fb1:	e8 53 fb ff ff       	call   802b09 <merging>
  802fb6:	83 c4 10             	add    $0x10,%esp
			break;
  802fb9:	90                   	nop
		}
	}
}
  802fba:	eb 2e                	jmp    802fea <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802fbc:	a1 34 50 80 00       	mov    0x805034,%eax
  802fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc8:	74 07                	je     802fd1 <free_block+0xa5>
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	8b 00                	mov    (%eax),%eax
  802fcf:	eb 05                	jmp    802fd6 <free_block+0xaa>
  802fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd6:	a3 34 50 80 00       	mov    %eax,0x805034
  802fdb:	a1 34 50 80 00       	mov    0x805034,%eax
  802fe0:	85 c0                	test   %eax,%eax
  802fe2:	75 a7                	jne    802f8b <free_block+0x5f>
  802fe4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe8:	75 a1                	jne    802f8b <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fea:	90                   	nop
  802feb:	c9                   	leave  
  802fec:	c3                   	ret    

00802fed <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802fed:	55                   	push   %ebp
  802fee:	89 e5                	mov    %esp,%ebp
  802ff0:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802ff3:	ff 75 08             	pushl  0x8(%ebp)
  802ff6:	e8 ed ec ff ff       	call   801ce8 <get_block_size>
  802ffb:	83 c4 04             	add    $0x4,%esp
  802ffe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  803001:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803008:	eb 17                	jmp    803021 <copy_data+0x34>
  80300a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80300d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803010:	01 c2                	add    %eax,%edx
  803012:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	01 c8                	add    %ecx,%eax
  80301a:	8a 00                	mov    (%eax),%al
  80301c:	88 02                	mov    %al,(%edx)
  80301e:	ff 45 fc             	incl   -0x4(%ebp)
  803021:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803024:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803027:	72 e1                	jb     80300a <copy_data+0x1d>
}
  803029:	90                   	nop
  80302a:	c9                   	leave  
  80302b:	c3                   	ret    

0080302c <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80302c:	55                   	push   %ebp
  80302d:	89 e5                	mov    %esp,%ebp
  80302f:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803032:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803036:	75 23                	jne    80305b <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803038:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80303c:	74 13                	je     803051 <realloc_block_FF+0x25>
  80303e:	83 ec 0c             	sub    $0xc,%esp
  803041:	ff 75 0c             	pushl  0xc(%ebp)
  803044:	e8 1f f0 ff ff       	call   802068 <alloc_block_FF>
  803049:	83 c4 10             	add    $0x10,%esp
  80304c:	e9 f4 06 00 00       	jmp    803745 <realloc_block_FF+0x719>
		return NULL;
  803051:	b8 00 00 00 00       	mov    $0x0,%eax
  803056:	e9 ea 06 00 00       	jmp    803745 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  80305b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80305f:	75 18                	jne    803079 <realloc_block_FF+0x4d>
	{
		free_block(va);
  803061:	83 ec 0c             	sub    $0xc,%esp
  803064:	ff 75 08             	pushl  0x8(%ebp)
  803067:	e8 c0 fe ff ff       	call   802f2c <free_block>
  80306c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80306f:	b8 00 00 00 00       	mov    $0x0,%eax
  803074:	e9 cc 06 00 00       	jmp    803745 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803079:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80307d:	77 07                	ja     803086 <realloc_block_FF+0x5a>
  80307f:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803086:	8b 45 0c             	mov    0xc(%ebp),%eax
  803089:	83 e0 01             	and    $0x1,%eax
  80308c:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80308f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803092:	83 c0 08             	add    $0x8,%eax
  803095:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803098:	83 ec 0c             	sub    $0xc,%esp
  80309b:	ff 75 08             	pushl  0x8(%ebp)
  80309e:	e8 45 ec ff ff       	call   801ce8 <get_block_size>
  8030a3:	83 c4 10             	add    $0x10,%esp
  8030a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8030a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ac:	83 e8 08             	sub    $0x8,%eax
  8030af:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b5:	83 e8 04             	sub    $0x4,%eax
  8030b8:	8b 00                	mov    (%eax),%eax
  8030ba:	83 e0 fe             	and    $0xfffffffe,%eax
  8030bd:	89 c2                	mov    %eax,%edx
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	01 d0                	add    %edx,%eax
  8030c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8030c7:	83 ec 0c             	sub    $0xc,%esp
  8030ca:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030cd:	e8 16 ec ff ff       	call   801ce8 <get_block_size>
  8030d2:	83 c4 10             	add    $0x10,%esp
  8030d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8030d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030db:	83 e8 08             	sub    $0x8,%eax
  8030de:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8030e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030e7:	75 08                	jne    8030f1 <realloc_block_FF+0xc5>
	{
		 return va;
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	e9 54 06 00 00       	jmp    803745 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8030f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030f7:	0f 83 e5 03 00 00    	jae    8034e2 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8030fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803100:	2b 45 0c             	sub    0xc(%ebp),%eax
  803103:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803106:	83 ec 0c             	sub    $0xc,%esp
  803109:	ff 75 e4             	pushl  -0x1c(%ebp)
  80310c:	e8 f0 eb ff ff       	call   801d01 <is_free_block>
  803111:	83 c4 10             	add    $0x10,%esp
  803114:	84 c0                	test   %al,%al
  803116:	0f 84 3b 01 00 00    	je     803257 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80311c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80311f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803122:	01 d0                	add    %edx,%eax
  803124:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803127:	83 ec 04             	sub    $0x4,%esp
  80312a:	6a 01                	push   $0x1
  80312c:	ff 75 f0             	pushl  -0x10(%ebp)
  80312f:	ff 75 08             	pushl  0x8(%ebp)
  803132:	e8 02 ef ff ff       	call   802039 <set_block_data>
  803137:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	83 e8 04             	sub    $0x4,%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	83 e0 fe             	and    $0xfffffffe,%eax
  803145:	89 c2                	mov    %eax,%edx
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	01 d0                	add    %edx,%eax
  80314c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80314f:	83 ec 04             	sub    $0x4,%esp
  803152:	6a 00                	push   $0x0
  803154:	ff 75 cc             	pushl  -0x34(%ebp)
  803157:	ff 75 c8             	pushl  -0x38(%ebp)
  80315a:	e8 da ee ff ff       	call   802039 <set_block_data>
  80315f:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803162:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803166:	74 06                	je     80316e <realloc_block_FF+0x142>
  803168:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80316c:	75 17                	jne    803185 <realloc_block_FF+0x159>
  80316e:	83 ec 04             	sub    $0x4,%esp
  803171:	68 04 43 80 00       	push   $0x804304
  803176:	68 f6 01 00 00       	push   $0x1f6
  80317b:	68 91 42 80 00       	push   $0x804291
  803180:	e8 6f 06 00 00       	call   8037f4 <_panic>
  803185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803188:	8b 10                	mov    (%eax),%edx
  80318a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80318d:	89 10                	mov    %edx,(%eax)
  80318f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803192:	8b 00                	mov    (%eax),%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	74 0b                	je     8031a3 <realloc_block_FF+0x177>
  803198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319b:	8b 00                	mov    (%eax),%eax
  80319d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031a0:	89 50 04             	mov    %edx,0x4(%eax)
  8031a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8031a9:	89 10                	mov    %edx,(%eax)
  8031ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031b1:	89 50 04             	mov    %edx,0x4(%eax)
  8031b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031b7:	8b 00                	mov    (%eax),%eax
  8031b9:	85 c0                	test   %eax,%eax
  8031bb:	75 08                	jne    8031c5 <realloc_block_FF+0x199>
  8031bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031c0:	a3 30 50 80 00       	mov    %eax,0x805030
  8031c5:	a1 38 50 80 00       	mov    0x805038,%eax
  8031ca:	40                   	inc    %eax
  8031cb:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8031d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031d4:	75 17                	jne    8031ed <realloc_block_FF+0x1c1>
  8031d6:	83 ec 04             	sub    $0x4,%esp
  8031d9:	68 73 42 80 00       	push   $0x804273
  8031de:	68 f7 01 00 00       	push   $0x1f7
  8031e3:	68 91 42 80 00       	push   $0x804291
  8031e8:	e8 07 06 00 00       	call   8037f4 <_panic>
  8031ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f0:	8b 00                	mov    (%eax),%eax
  8031f2:	85 c0                	test   %eax,%eax
  8031f4:	74 10                	je     803206 <realloc_block_FF+0x1da>
  8031f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f9:	8b 00                	mov    (%eax),%eax
  8031fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031fe:	8b 52 04             	mov    0x4(%edx),%edx
  803201:	89 50 04             	mov    %edx,0x4(%eax)
  803204:	eb 0b                	jmp    803211 <realloc_block_FF+0x1e5>
  803206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803209:	8b 40 04             	mov    0x4(%eax),%eax
  80320c:	a3 30 50 80 00       	mov    %eax,0x805030
  803211:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803214:	8b 40 04             	mov    0x4(%eax),%eax
  803217:	85 c0                	test   %eax,%eax
  803219:	74 0f                	je     80322a <realloc_block_FF+0x1fe>
  80321b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80321e:	8b 40 04             	mov    0x4(%eax),%eax
  803221:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803224:	8b 12                	mov    (%edx),%edx
  803226:	89 10                	mov    %edx,(%eax)
  803228:	eb 0a                	jmp    803234 <realloc_block_FF+0x208>
  80322a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803237:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803240:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803247:	a1 38 50 80 00       	mov    0x805038,%eax
  80324c:	48                   	dec    %eax
  80324d:	a3 38 50 80 00       	mov    %eax,0x805038
  803252:	e9 83 02 00 00       	jmp    8034da <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803257:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  80325b:	0f 86 69 02 00 00    	jbe    8034ca <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803261:	83 ec 04             	sub    $0x4,%esp
  803264:	6a 01                	push   $0x1
  803266:	ff 75 f0             	pushl  -0x10(%ebp)
  803269:	ff 75 08             	pushl  0x8(%ebp)
  80326c:	e8 c8 ed ff ff       	call   802039 <set_block_data>
  803271:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	83 e8 04             	sub    $0x4,%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	83 e0 fe             	and    $0xfffffffe,%eax
  80327f:	89 c2                	mov    %eax,%edx
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	01 d0                	add    %edx,%eax
  803286:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803289:	a1 38 50 80 00       	mov    0x805038,%eax
  80328e:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803291:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803295:	75 68                	jne    8032ff <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803297:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80329b:	75 17                	jne    8032b4 <realloc_block_FF+0x288>
  80329d:	83 ec 04             	sub    $0x4,%esp
  8032a0:	68 ac 42 80 00       	push   $0x8042ac
  8032a5:	68 06 02 00 00       	push   $0x206
  8032aa:	68 91 42 80 00       	push   $0x804291
  8032af:	e8 40 05 00 00       	call   8037f4 <_panic>
  8032b4:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032bd:	89 10                	mov    %edx,(%eax)
  8032bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032c2:	8b 00                	mov    (%eax),%eax
  8032c4:	85 c0                	test   %eax,%eax
  8032c6:	74 0d                	je     8032d5 <realloc_block_FF+0x2a9>
  8032c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032d0:	89 50 04             	mov    %edx,0x4(%eax)
  8032d3:	eb 08                	jmp    8032dd <realloc_block_FF+0x2b1>
  8032d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d8:	a3 30 50 80 00       	mov    %eax,0x805030
  8032dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e0:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ef:	a1 38 50 80 00       	mov    0x805038,%eax
  8032f4:	40                   	inc    %eax
  8032f5:	a3 38 50 80 00       	mov    %eax,0x805038
  8032fa:	e9 b0 01 00 00       	jmp    8034af <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8032ff:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803304:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803307:	76 68                	jbe    803371 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803309:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80330d:	75 17                	jne    803326 <realloc_block_FF+0x2fa>
  80330f:	83 ec 04             	sub    $0x4,%esp
  803312:	68 ac 42 80 00       	push   $0x8042ac
  803317:	68 0b 02 00 00       	push   $0x20b
  80331c:	68 91 42 80 00       	push   $0x804291
  803321:	e8 ce 04 00 00       	call   8037f4 <_panic>
  803326:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80332c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80332f:	89 10                	mov    %edx,(%eax)
  803331:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803334:	8b 00                	mov    (%eax),%eax
  803336:	85 c0                	test   %eax,%eax
  803338:	74 0d                	je     803347 <realloc_block_FF+0x31b>
  80333a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80333f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803342:	89 50 04             	mov    %edx,0x4(%eax)
  803345:	eb 08                	jmp    80334f <realloc_block_FF+0x323>
  803347:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334a:	a3 30 50 80 00       	mov    %eax,0x805030
  80334f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803352:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803357:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80335a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803361:	a1 38 50 80 00       	mov    0x805038,%eax
  803366:	40                   	inc    %eax
  803367:	a3 38 50 80 00       	mov    %eax,0x805038
  80336c:	e9 3e 01 00 00       	jmp    8034af <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803371:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803376:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803379:	73 68                	jae    8033e3 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  80337b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80337f:	75 17                	jne    803398 <realloc_block_FF+0x36c>
  803381:	83 ec 04             	sub    $0x4,%esp
  803384:	68 e0 42 80 00       	push   $0x8042e0
  803389:	68 10 02 00 00       	push   $0x210
  80338e:	68 91 42 80 00       	push   $0x804291
  803393:	e8 5c 04 00 00       	call   8037f4 <_panic>
  803398:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80339e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a1:	89 50 04             	mov    %edx,0x4(%eax)
  8033a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033a7:	8b 40 04             	mov    0x4(%eax),%eax
  8033aa:	85 c0                	test   %eax,%eax
  8033ac:	74 0c                	je     8033ba <realloc_block_FF+0x38e>
  8033ae:	a1 30 50 80 00       	mov    0x805030,%eax
  8033b3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033b6:	89 10                	mov    %edx,(%eax)
  8033b8:	eb 08                	jmp    8033c2 <realloc_block_FF+0x396>
  8033ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033bd:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8033ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d3:	a1 38 50 80 00       	mov    0x805038,%eax
  8033d8:	40                   	inc    %eax
  8033d9:	a3 38 50 80 00       	mov    %eax,0x805038
  8033de:	e9 cc 00 00 00       	jmp    8034af <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8033e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8033ea:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033f2:	e9 8a 00 00 00       	jmp    803481 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8033f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033fd:	73 7a                	jae    803479 <realloc_block_FF+0x44d>
  8033ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803402:	8b 00                	mov    (%eax),%eax
  803404:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803407:	73 70                	jae    803479 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340d:	74 06                	je     803415 <realloc_block_FF+0x3e9>
  80340f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803413:	75 17                	jne    80342c <realloc_block_FF+0x400>
  803415:	83 ec 04             	sub    $0x4,%esp
  803418:	68 04 43 80 00       	push   $0x804304
  80341d:	68 1a 02 00 00       	push   $0x21a
  803422:	68 91 42 80 00       	push   $0x804291
  803427:	e8 c8 03 00 00       	call   8037f4 <_panic>
  80342c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342f:	8b 10                	mov    (%eax),%edx
  803431:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803434:	89 10                	mov    %edx,(%eax)
  803436:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	85 c0                	test   %eax,%eax
  80343d:	74 0b                	je     80344a <realloc_block_FF+0x41e>
  80343f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803447:	89 50 04             	mov    %edx,0x4(%eax)
  80344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803450:	89 10                	mov    %edx,(%eax)
  803452:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803455:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803458:	89 50 04             	mov    %edx,0x4(%eax)
  80345b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80345e:	8b 00                	mov    (%eax),%eax
  803460:	85 c0                	test   %eax,%eax
  803462:	75 08                	jne    80346c <realloc_block_FF+0x440>
  803464:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803467:	a3 30 50 80 00       	mov    %eax,0x805030
  80346c:	a1 38 50 80 00       	mov    0x805038,%eax
  803471:	40                   	inc    %eax
  803472:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803477:	eb 36                	jmp    8034af <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803479:	a1 34 50 80 00       	mov    0x805034,%eax
  80347e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803485:	74 07                	je     80348e <realloc_block_FF+0x462>
  803487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348a:	8b 00                	mov    (%eax),%eax
  80348c:	eb 05                	jmp    803493 <realloc_block_FF+0x467>
  80348e:	b8 00 00 00 00       	mov    $0x0,%eax
  803493:	a3 34 50 80 00       	mov    %eax,0x805034
  803498:	a1 34 50 80 00       	mov    0x805034,%eax
  80349d:	85 c0                	test   %eax,%eax
  80349f:	0f 85 52 ff ff ff    	jne    8033f7 <realloc_block_FF+0x3cb>
  8034a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a9:	0f 85 48 ff ff ff    	jne    8033f7 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8034af:	83 ec 04             	sub    $0x4,%esp
  8034b2:	6a 00                	push   $0x0
  8034b4:	ff 75 d8             	pushl  -0x28(%ebp)
  8034b7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034ba:	e8 7a eb ff ff       	call   802039 <set_block_data>
  8034bf:	83 c4 10             	add    $0x10,%esp
				return va;
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	e9 7b 02 00 00       	jmp    803745 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8034ca:	83 ec 0c             	sub    $0xc,%esp
  8034cd:	68 81 43 80 00       	push   $0x804381
  8034d2:	e8 2c cf ff ff       	call   800403 <cprintf>
  8034d7:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	e9 63 02 00 00       	jmp    803745 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8034e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8034e8:	0f 86 4d 02 00 00    	jbe    80373b <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8034ee:	83 ec 0c             	sub    $0xc,%esp
  8034f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034f4:	e8 08 e8 ff ff       	call   801d01 <is_free_block>
  8034f9:	83 c4 10             	add    $0x10,%esp
  8034fc:	84 c0                	test   %al,%al
  8034fe:	0f 84 37 02 00 00    	je     80373b <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803504:	8b 45 0c             	mov    0xc(%ebp),%eax
  803507:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80350a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80350d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803510:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803513:	76 38                	jbe    80354d <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803515:	83 ec 0c             	sub    $0xc,%esp
  803518:	ff 75 08             	pushl  0x8(%ebp)
  80351b:	e8 0c fa ff ff       	call   802f2c <free_block>
  803520:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803523:	83 ec 0c             	sub    $0xc,%esp
  803526:	ff 75 0c             	pushl  0xc(%ebp)
  803529:	e8 3a eb ff ff       	call   802068 <alloc_block_FF>
  80352e:	83 c4 10             	add    $0x10,%esp
  803531:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803534:	83 ec 08             	sub    $0x8,%esp
  803537:	ff 75 c0             	pushl  -0x40(%ebp)
  80353a:	ff 75 08             	pushl  0x8(%ebp)
  80353d:	e8 ab fa ff ff       	call   802fed <copy_data>
  803542:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803545:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803548:	e9 f8 01 00 00       	jmp    803745 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80354d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803550:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803553:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803556:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  80355a:	0f 87 a0 00 00 00    	ja     803600 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803560:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803564:	75 17                	jne    80357d <realloc_block_FF+0x551>
  803566:	83 ec 04             	sub    $0x4,%esp
  803569:	68 73 42 80 00       	push   $0x804273
  80356e:	68 38 02 00 00       	push   $0x238
  803573:	68 91 42 80 00       	push   $0x804291
  803578:	e8 77 02 00 00       	call   8037f4 <_panic>
  80357d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803580:	8b 00                	mov    (%eax),%eax
  803582:	85 c0                	test   %eax,%eax
  803584:	74 10                	je     803596 <realloc_block_FF+0x56a>
  803586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803589:	8b 00                	mov    (%eax),%eax
  80358b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80358e:	8b 52 04             	mov    0x4(%edx),%edx
  803591:	89 50 04             	mov    %edx,0x4(%eax)
  803594:	eb 0b                	jmp    8035a1 <realloc_block_FF+0x575>
  803596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803599:	8b 40 04             	mov    0x4(%eax),%eax
  80359c:	a3 30 50 80 00       	mov    %eax,0x805030
  8035a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a4:	8b 40 04             	mov    0x4(%eax),%eax
  8035a7:	85 c0                	test   %eax,%eax
  8035a9:	74 0f                	je     8035ba <realloc_block_FF+0x58e>
  8035ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ae:	8b 40 04             	mov    0x4(%eax),%eax
  8035b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035b4:	8b 12                	mov    (%edx),%edx
  8035b6:	89 10                	mov    %edx,(%eax)
  8035b8:	eb 0a                	jmp    8035c4 <realloc_block_FF+0x598>
  8035ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035bd:	8b 00                	mov    (%eax),%eax
  8035bf:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8035c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d7:	a1 38 50 80 00       	mov    0x805038,%eax
  8035dc:	48                   	dec    %eax
  8035dd:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8035e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035e8:	01 d0                	add    %edx,%eax
  8035ea:	83 ec 04             	sub    $0x4,%esp
  8035ed:	6a 01                	push   $0x1
  8035ef:	50                   	push   %eax
  8035f0:	ff 75 08             	pushl  0x8(%ebp)
  8035f3:	e8 41 ea ff ff       	call   802039 <set_block_data>
  8035f8:	83 c4 10             	add    $0x10,%esp
  8035fb:	e9 36 01 00 00       	jmp    803736 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  803600:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803603:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803606:	01 d0                	add    %edx,%eax
  803608:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  80360b:	83 ec 04             	sub    $0x4,%esp
  80360e:	6a 01                	push   $0x1
  803610:	ff 75 f0             	pushl  -0x10(%ebp)
  803613:	ff 75 08             	pushl  0x8(%ebp)
  803616:	e8 1e ea ff ff       	call   802039 <set_block_data>
  80361b:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80361e:	8b 45 08             	mov    0x8(%ebp),%eax
  803621:	83 e8 04             	sub    $0x4,%eax
  803624:	8b 00                	mov    (%eax),%eax
  803626:	83 e0 fe             	and    $0xfffffffe,%eax
  803629:	89 c2                	mov    %eax,%edx
  80362b:	8b 45 08             	mov    0x8(%ebp),%eax
  80362e:	01 d0                	add    %edx,%eax
  803630:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803633:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803637:	74 06                	je     80363f <realloc_block_FF+0x613>
  803639:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80363d:	75 17                	jne    803656 <realloc_block_FF+0x62a>
  80363f:	83 ec 04             	sub    $0x4,%esp
  803642:	68 04 43 80 00       	push   $0x804304
  803647:	68 44 02 00 00       	push   $0x244
  80364c:	68 91 42 80 00       	push   $0x804291
  803651:	e8 9e 01 00 00       	call   8037f4 <_panic>
  803656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803659:	8b 10                	mov    (%eax),%edx
  80365b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80365e:	89 10                	mov    %edx,(%eax)
  803660:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803663:	8b 00                	mov    (%eax),%eax
  803665:	85 c0                	test   %eax,%eax
  803667:	74 0b                	je     803674 <realloc_block_FF+0x648>
  803669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366c:	8b 00                	mov    (%eax),%eax
  80366e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803671:	89 50 04             	mov    %edx,0x4(%eax)
  803674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803677:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80367a:	89 10                	mov    %edx,(%eax)
  80367c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80367f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803682:	89 50 04             	mov    %edx,0x4(%eax)
  803685:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803688:	8b 00                	mov    (%eax),%eax
  80368a:	85 c0                	test   %eax,%eax
  80368c:	75 08                	jne    803696 <realloc_block_FF+0x66a>
  80368e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803691:	a3 30 50 80 00       	mov    %eax,0x805030
  803696:	a1 38 50 80 00       	mov    0x805038,%eax
  80369b:	40                   	inc    %eax
  80369c:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8036a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036a5:	75 17                	jne    8036be <realloc_block_FF+0x692>
  8036a7:	83 ec 04             	sub    $0x4,%esp
  8036aa:	68 73 42 80 00       	push   $0x804273
  8036af:	68 45 02 00 00       	push   $0x245
  8036b4:	68 91 42 80 00       	push   $0x804291
  8036b9:	e8 36 01 00 00       	call   8037f4 <_panic>
  8036be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c1:	8b 00                	mov    (%eax),%eax
  8036c3:	85 c0                	test   %eax,%eax
  8036c5:	74 10                	je     8036d7 <realloc_block_FF+0x6ab>
  8036c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ca:	8b 00                	mov    (%eax),%eax
  8036cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036cf:	8b 52 04             	mov    0x4(%edx),%edx
  8036d2:	89 50 04             	mov    %edx,0x4(%eax)
  8036d5:	eb 0b                	jmp    8036e2 <realloc_block_FF+0x6b6>
  8036d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036da:	8b 40 04             	mov    0x4(%eax),%eax
  8036dd:	a3 30 50 80 00       	mov    %eax,0x805030
  8036e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e5:	8b 40 04             	mov    0x4(%eax),%eax
  8036e8:	85 c0                	test   %eax,%eax
  8036ea:	74 0f                	je     8036fb <realloc_block_FF+0x6cf>
  8036ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ef:	8b 40 04             	mov    0x4(%eax),%eax
  8036f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036f5:	8b 12                	mov    (%edx),%edx
  8036f7:	89 10                	mov    %edx,(%eax)
  8036f9:	eb 0a                	jmp    803705 <realloc_block_FF+0x6d9>
  8036fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036fe:	8b 00                	mov    (%eax),%eax
  803700:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803711:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803718:	a1 38 50 80 00       	mov    0x805038,%eax
  80371d:	48                   	dec    %eax
  80371e:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  803723:	83 ec 04             	sub    $0x4,%esp
  803726:	6a 00                	push   $0x0
  803728:	ff 75 bc             	pushl  -0x44(%ebp)
  80372b:	ff 75 b8             	pushl  -0x48(%ebp)
  80372e:	e8 06 e9 ff ff       	call   802039 <set_block_data>
  803733:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803736:	8b 45 08             	mov    0x8(%ebp),%eax
  803739:	eb 0a                	jmp    803745 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  80373b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803742:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803745:	c9                   	leave  
  803746:	c3                   	ret    

00803747 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803747:	55                   	push   %ebp
  803748:	89 e5                	mov    %esp,%ebp
  80374a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80374d:	83 ec 04             	sub    $0x4,%esp
  803750:	68 88 43 80 00       	push   $0x804388
  803755:	68 58 02 00 00       	push   $0x258
  80375a:	68 91 42 80 00       	push   $0x804291
  80375f:	e8 90 00 00 00       	call   8037f4 <_panic>

00803764 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803764:	55                   	push   %ebp
  803765:	89 e5                	mov    %esp,%ebp
  803767:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80376a:	83 ec 04             	sub    $0x4,%esp
  80376d:	68 b0 43 80 00       	push   $0x8043b0
  803772:	68 61 02 00 00       	push   $0x261
  803777:	68 91 42 80 00       	push   $0x804291
  80377c:	e8 73 00 00 00       	call   8037f4 <_panic>

00803781 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803781:	55                   	push   %ebp
  803782:	89 e5                	mov    %esp,%ebp
  803784:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803787:	83 ec 04             	sub    $0x4,%esp
  80378a:	68 d8 43 80 00       	push   $0x8043d8
  80378f:	6a 09                	push   $0x9
  803791:	68 00 44 80 00       	push   $0x804400
  803796:	e8 59 00 00 00       	call   8037f4 <_panic>

0080379b <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80379b:	55                   	push   %ebp
  80379c:	89 e5                	mov    %esp,%ebp
  80379e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8037a1:	83 ec 04             	sub    $0x4,%esp
  8037a4:	68 10 44 80 00       	push   $0x804410
  8037a9:	6a 10                	push   $0x10
  8037ab:	68 00 44 80 00       	push   $0x804400
  8037b0:	e8 3f 00 00 00       	call   8037f4 <_panic>

008037b5 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8037b5:	55                   	push   %ebp
  8037b6:	89 e5                	mov    %esp,%ebp
  8037b8:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8037bb:	83 ec 04             	sub    $0x4,%esp
  8037be:	68 38 44 80 00       	push   $0x804438
  8037c3:	6a 18                	push   $0x18
  8037c5:	68 00 44 80 00       	push   $0x804400
  8037ca:	e8 25 00 00 00       	call   8037f4 <_panic>

008037cf <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8037cf:	55                   	push   %ebp
  8037d0:	89 e5                	mov    %esp,%ebp
  8037d2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8037d5:	83 ec 04             	sub    $0x4,%esp
  8037d8:	68 60 44 80 00       	push   $0x804460
  8037dd:	6a 20                	push   $0x20
  8037df:	68 00 44 80 00       	push   $0x804400
  8037e4:	e8 0b 00 00 00       	call   8037f4 <_panic>

008037e9 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8037e9:	55                   	push   %ebp
  8037ea:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8037ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ef:	8b 40 10             	mov    0x10(%eax),%eax
}
  8037f2:	5d                   	pop    %ebp
  8037f3:	c3                   	ret    

008037f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8037f4:	55                   	push   %ebp
  8037f5:	89 e5                	mov    %esp,%ebp
  8037f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8037fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8037fd:	83 c0 04             	add    $0x4,%eax
  803800:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803803:	a1 60 50 98 00       	mov    0x985060,%eax
  803808:	85 c0                	test   %eax,%eax
  80380a:	74 16                	je     803822 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80380c:	a1 60 50 98 00       	mov    0x985060,%eax
  803811:	83 ec 08             	sub    $0x8,%esp
  803814:	50                   	push   %eax
  803815:	68 88 44 80 00       	push   $0x804488
  80381a:	e8 e4 cb ff ff       	call   800403 <cprintf>
  80381f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803822:	a1 00 50 80 00       	mov    0x805000,%eax
  803827:	ff 75 0c             	pushl  0xc(%ebp)
  80382a:	ff 75 08             	pushl  0x8(%ebp)
  80382d:	50                   	push   %eax
  80382e:	68 8d 44 80 00       	push   $0x80448d
  803833:	e8 cb cb ff ff       	call   800403 <cprintf>
  803838:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80383b:	8b 45 10             	mov    0x10(%ebp),%eax
  80383e:	83 ec 08             	sub    $0x8,%esp
  803841:	ff 75 f4             	pushl  -0xc(%ebp)
  803844:	50                   	push   %eax
  803845:	e8 4e cb ff ff       	call   800398 <vcprintf>
  80384a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80384d:	83 ec 08             	sub    $0x8,%esp
  803850:	6a 00                	push   $0x0
  803852:	68 a9 44 80 00       	push   $0x8044a9
  803857:	e8 3c cb ff ff       	call   800398 <vcprintf>
  80385c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80385f:	e8 bd ca ff ff       	call   800321 <exit>

	// should not return here
	while (1) ;
  803864:	eb fe                	jmp    803864 <_panic+0x70>

00803866 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803866:	55                   	push   %ebp
  803867:	89 e5                	mov    %esp,%ebp
  803869:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80386c:	a1 20 50 80 00       	mov    0x805020,%eax
  803871:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80387a:	39 c2                	cmp    %eax,%edx
  80387c:	74 14                	je     803892 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80387e:	83 ec 04             	sub    $0x4,%esp
  803881:	68 ac 44 80 00       	push   $0x8044ac
  803886:	6a 26                	push   $0x26
  803888:	68 f8 44 80 00       	push   $0x8044f8
  80388d:	e8 62 ff ff ff       	call   8037f4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803892:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803899:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8038a0:	e9 c5 00 00 00       	jmp    80396a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8038a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8038af:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b2:	01 d0                	add    %edx,%eax
  8038b4:	8b 00                	mov    (%eax),%eax
  8038b6:	85 c0                	test   %eax,%eax
  8038b8:	75 08                	jne    8038c2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8038ba:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8038bd:	e9 a5 00 00 00       	jmp    803967 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8038c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8038d0:	eb 69                	jmp    80393b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8038d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8038d7:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038e0:	89 d0                	mov    %edx,%eax
  8038e2:	01 c0                	add    %eax,%eax
  8038e4:	01 d0                	add    %edx,%eax
  8038e6:	c1 e0 03             	shl    $0x3,%eax
  8038e9:	01 c8                	add    %ecx,%eax
  8038eb:	8a 40 04             	mov    0x4(%eax),%al
  8038ee:	84 c0                	test   %al,%al
  8038f0:	75 46                	jne    803938 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8038f7:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803900:	89 d0                	mov    %edx,%eax
  803902:	01 c0                	add    %eax,%eax
  803904:	01 d0                	add    %edx,%eax
  803906:	c1 e0 03             	shl    $0x3,%eax
  803909:	01 c8                	add    %ecx,%eax
  80390b:	8b 00                	mov    (%eax),%eax
  80390d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803910:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803913:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803918:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80391a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803924:	8b 45 08             	mov    0x8(%ebp),%eax
  803927:	01 c8                	add    %ecx,%eax
  803929:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80392b:	39 c2                	cmp    %eax,%edx
  80392d:	75 09                	jne    803938 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80392f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803936:	eb 15                	jmp    80394d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803938:	ff 45 e8             	incl   -0x18(%ebp)
  80393b:	a1 20 50 80 00       	mov    0x805020,%eax
  803940:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803946:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803949:	39 c2                	cmp    %eax,%edx
  80394b:	77 85                	ja     8038d2 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80394d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803951:	75 14                	jne    803967 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803953:	83 ec 04             	sub    $0x4,%esp
  803956:	68 04 45 80 00       	push   $0x804504
  80395b:	6a 3a                	push   $0x3a
  80395d:	68 f8 44 80 00       	push   $0x8044f8
  803962:	e8 8d fe ff ff       	call   8037f4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803967:	ff 45 f0             	incl   -0x10(%ebp)
  80396a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80396d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803970:	0f 8c 2f ff ff ff    	jl     8038a5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803976:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80397d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803984:	eb 26                	jmp    8039ac <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803986:	a1 20 50 80 00       	mov    0x805020,%eax
  80398b:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803991:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803994:	89 d0                	mov    %edx,%eax
  803996:	01 c0                	add    %eax,%eax
  803998:	01 d0                	add    %edx,%eax
  80399a:	c1 e0 03             	shl    $0x3,%eax
  80399d:	01 c8                	add    %ecx,%eax
  80399f:	8a 40 04             	mov    0x4(%eax),%al
  8039a2:	3c 01                	cmp    $0x1,%al
  8039a4:	75 03                	jne    8039a9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8039a6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039a9:	ff 45 e0             	incl   -0x20(%ebp)
  8039ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8039b1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8039b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039ba:	39 c2                	cmp    %eax,%edx
  8039bc:	77 c8                	ja     803986 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8039be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8039c4:	74 14                	je     8039da <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8039c6:	83 ec 04             	sub    $0x4,%esp
  8039c9:	68 58 45 80 00       	push   $0x804558
  8039ce:	6a 44                	push   $0x44
  8039d0:	68 f8 44 80 00       	push   $0x8044f8
  8039d5:	e8 1a fe ff ff       	call   8037f4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8039da:	90                   	nop
  8039db:	c9                   	leave  
  8039dc:	c3                   	ret    
  8039dd:	66 90                	xchg   %ax,%ax
  8039df:	90                   	nop

008039e0 <__udivdi3>:
  8039e0:	55                   	push   %ebp
  8039e1:	57                   	push   %edi
  8039e2:	56                   	push   %esi
  8039e3:	53                   	push   %ebx
  8039e4:	83 ec 1c             	sub    $0x1c,%esp
  8039e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8039eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039f7:	89 ca                	mov    %ecx,%edx
  8039f9:	89 f8                	mov    %edi,%eax
  8039fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039ff:	85 f6                	test   %esi,%esi
  803a01:	75 2d                	jne    803a30 <__udivdi3+0x50>
  803a03:	39 cf                	cmp    %ecx,%edi
  803a05:	77 65                	ja     803a6c <__udivdi3+0x8c>
  803a07:	89 fd                	mov    %edi,%ebp
  803a09:	85 ff                	test   %edi,%edi
  803a0b:	75 0b                	jne    803a18 <__udivdi3+0x38>
  803a0d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a12:	31 d2                	xor    %edx,%edx
  803a14:	f7 f7                	div    %edi
  803a16:	89 c5                	mov    %eax,%ebp
  803a18:	31 d2                	xor    %edx,%edx
  803a1a:	89 c8                	mov    %ecx,%eax
  803a1c:	f7 f5                	div    %ebp
  803a1e:	89 c1                	mov    %eax,%ecx
  803a20:	89 d8                	mov    %ebx,%eax
  803a22:	f7 f5                	div    %ebp
  803a24:	89 cf                	mov    %ecx,%edi
  803a26:	89 fa                	mov    %edi,%edx
  803a28:	83 c4 1c             	add    $0x1c,%esp
  803a2b:	5b                   	pop    %ebx
  803a2c:	5e                   	pop    %esi
  803a2d:	5f                   	pop    %edi
  803a2e:	5d                   	pop    %ebp
  803a2f:	c3                   	ret    
  803a30:	39 ce                	cmp    %ecx,%esi
  803a32:	77 28                	ja     803a5c <__udivdi3+0x7c>
  803a34:	0f bd fe             	bsr    %esi,%edi
  803a37:	83 f7 1f             	xor    $0x1f,%edi
  803a3a:	75 40                	jne    803a7c <__udivdi3+0x9c>
  803a3c:	39 ce                	cmp    %ecx,%esi
  803a3e:	72 0a                	jb     803a4a <__udivdi3+0x6a>
  803a40:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a44:	0f 87 9e 00 00 00    	ja     803ae8 <__udivdi3+0x108>
  803a4a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a4f:	89 fa                	mov    %edi,%edx
  803a51:	83 c4 1c             	add    $0x1c,%esp
  803a54:	5b                   	pop    %ebx
  803a55:	5e                   	pop    %esi
  803a56:	5f                   	pop    %edi
  803a57:	5d                   	pop    %ebp
  803a58:	c3                   	ret    
  803a59:	8d 76 00             	lea    0x0(%esi),%esi
  803a5c:	31 ff                	xor    %edi,%edi
  803a5e:	31 c0                	xor    %eax,%eax
  803a60:	89 fa                	mov    %edi,%edx
  803a62:	83 c4 1c             	add    $0x1c,%esp
  803a65:	5b                   	pop    %ebx
  803a66:	5e                   	pop    %esi
  803a67:	5f                   	pop    %edi
  803a68:	5d                   	pop    %ebp
  803a69:	c3                   	ret    
  803a6a:	66 90                	xchg   %ax,%ax
  803a6c:	89 d8                	mov    %ebx,%eax
  803a6e:	f7 f7                	div    %edi
  803a70:	31 ff                	xor    %edi,%edi
  803a72:	89 fa                	mov    %edi,%edx
  803a74:	83 c4 1c             	add    $0x1c,%esp
  803a77:	5b                   	pop    %ebx
  803a78:	5e                   	pop    %esi
  803a79:	5f                   	pop    %edi
  803a7a:	5d                   	pop    %ebp
  803a7b:	c3                   	ret    
  803a7c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a81:	89 eb                	mov    %ebp,%ebx
  803a83:	29 fb                	sub    %edi,%ebx
  803a85:	89 f9                	mov    %edi,%ecx
  803a87:	d3 e6                	shl    %cl,%esi
  803a89:	89 c5                	mov    %eax,%ebp
  803a8b:	88 d9                	mov    %bl,%cl
  803a8d:	d3 ed                	shr    %cl,%ebp
  803a8f:	89 e9                	mov    %ebp,%ecx
  803a91:	09 f1                	or     %esi,%ecx
  803a93:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a97:	89 f9                	mov    %edi,%ecx
  803a99:	d3 e0                	shl    %cl,%eax
  803a9b:	89 c5                	mov    %eax,%ebp
  803a9d:	89 d6                	mov    %edx,%esi
  803a9f:	88 d9                	mov    %bl,%cl
  803aa1:	d3 ee                	shr    %cl,%esi
  803aa3:	89 f9                	mov    %edi,%ecx
  803aa5:	d3 e2                	shl    %cl,%edx
  803aa7:	8b 44 24 08          	mov    0x8(%esp),%eax
  803aab:	88 d9                	mov    %bl,%cl
  803aad:	d3 e8                	shr    %cl,%eax
  803aaf:	09 c2                	or     %eax,%edx
  803ab1:	89 d0                	mov    %edx,%eax
  803ab3:	89 f2                	mov    %esi,%edx
  803ab5:	f7 74 24 0c          	divl   0xc(%esp)
  803ab9:	89 d6                	mov    %edx,%esi
  803abb:	89 c3                	mov    %eax,%ebx
  803abd:	f7 e5                	mul    %ebp
  803abf:	39 d6                	cmp    %edx,%esi
  803ac1:	72 19                	jb     803adc <__udivdi3+0xfc>
  803ac3:	74 0b                	je     803ad0 <__udivdi3+0xf0>
  803ac5:	89 d8                	mov    %ebx,%eax
  803ac7:	31 ff                	xor    %edi,%edi
  803ac9:	e9 58 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803ace:	66 90                	xchg   %ax,%ax
  803ad0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ad4:	89 f9                	mov    %edi,%ecx
  803ad6:	d3 e2                	shl    %cl,%edx
  803ad8:	39 c2                	cmp    %eax,%edx
  803ada:	73 e9                	jae    803ac5 <__udivdi3+0xe5>
  803adc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803adf:	31 ff                	xor    %edi,%edi
  803ae1:	e9 40 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803ae6:	66 90                	xchg   %ax,%ax
  803ae8:	31 c0                	xor    %eax,%eax
  803aea:	e9 37 ff ff ff       	jmp    803a26 <__udivdi3+0x46>
  803aef:	90                   	nop

00803af0 <__umoddi3>:
  803af0:	55                   	push   %ebp
  803af1:	57                   	push   %edi
  803af2:	56                   	push   %esi
  803af3:	53                   	push   %ebx
  803af4:	83 ec 1c             	sub    $0x1c,%esp
  803af7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803afb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803aff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b03:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b0f:	89 f3                	mov    %esi,%ebx
  803b11:	89 fa                	mov    %edi,%edx
  803b13:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b17:	89 34 24             	mov    %esi,(%esp)
  803b1a:	85 c0                	test   %eax,%eax
  803b1c:	75 1a                	jne    803b38 <__umoddi3+0x48>
  803b1e:	39 f7                	cmp    %esi,%edi
  803b20:	0f 86 a2 00 00 00    	jbe    803bc8 <__umoddi3+0xd8>
  803b26:	89 c8                	mov    %ecx,%eax
  803b28:	89 f2                	mov    %esi,%edx
  803b2a:	f7 f7                	div    %edi
  803b2c:	89 d0                	mov    %edx,%eax
  803b2e:	31 d2                	xor    %edx,%edx
  803b30:	83 c4 1c             	add    $0x1c,%esp
  803b33:	5b                   	pop    %ebx
  803b34:	5e                   	pop    %esi
  803b35:	5f                   	pop    %edi
  803b36:	5d                   	pop    %ebp
  803b37:	c3                   	ret    
  803b38:	39 f0                	cmp    %esi,%eax
  803b3a:	0f 87 ac 00 00 00    	ja     803bec <__umoddi3+0xfc>
  803b40:	0f bd e8             	bsr    %eax,%ebp
  803b43:	83 f5 1f             	xor    $0x1f,%ebp
  803b46:	0f 84 ac 00 00 00    	je     803bf8 <__umoddi3+0x108>
  803b4c:	bf 20 00 00 00       	mov    $0x20,%edi
  803b51:	29 ef                	sub    %ebp,%edi
  803b53:	89 fe                	mov    %edi,%esi
  803b55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b59:	89 e9                	mov    %ebp,%ecx
  803b5b:	d3 e0                	shl    %cl,%eax
  803b5d:	89 d7                	mov    %edx,%edi
  803b5f:	89 f1                	mov    %esi,%ecx
  803b61:	d3 ef                	shr    %cl,%edi
  803b63:	09 c7                	or     %eax,%edi
  803b65:	89 e9                	mov    %ebp,%ecx
  803b67:	d3 e2                	shl    %cl,%edx
  803b69:	89 14 24             	mov    %edx,(%esp)
  803b6c:	89 d8                	mov    %ebx,%eax
  803b6e:	d3 e0                	shl    %cl,%eax
  803b70:	89 c2                	mov    %eax,%edx
  803b72:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b76:	d3 e0                	shl    %cl,%eax
  803b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b7c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b80:	89 f1                	mov    %esi,%ecx
  803b82:	d3 e8                	shr    %cl,%eax
  803b84:	09 d0                	or     %edx,%eax
  803b86:	d3 eb                	shr    %cl,%ebx
  803b88:	89 da                	mov    %ebx,%edx
  803b8a:	f7 f7                	div    %edi
  803b8c:	89 d3                	mov    %edx,%ebx
  803b8e:	f7 24 24             	mull   (%esp)
  803b91:	89 c6                	mov    %eax,%esi
  803b93:	89 d1                	mov    %edx,%ecx
  803b95:	39 d3                	cmp    %edx,%ebx
  803b97:	0f 82 87 00 00 00    	jb     803c24 <__umoddi3+0x134>
  803b9d:	0f 84 91 00 00 00    	je     803c34 <__umoddi3+0x144>
  803ba3:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ba7:	29 f2                	sub    %esi,%edx
  803ba9:	19 cb                	sbb    %ecx,%ebx
  803bab:	89 d8                	mov    %ebx,%eax
  803bad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bb1:	d3 e0                	shl    %cl,%eax
  803bb3:	89 e9                	mov    %ebp,%ecx
  803bb5:	d3 ea                	shr    %cl,%edx
  803bb7:	09 d0                	or     %edx,%eax
  803bb9:	89 e9                	mov    %ebp,%ecx
  803bbb:	d3 eb                	shr    %cl,%ebx
  803bbd:	89 da                	mov    %ebx,%edx
  803bbf:	83 c4 1c             	add    $0x1c,%esp
  803bc2:	5b                   	pop    %ebx
  803bc3:	5e                   	pop    %esi
  803bc4:	5f                   	pop    %edi
  803bc5:	5d                   	pop    %ebp
  803bc6:	c3                   	ret    
  803bc7:	90                   	nop
  803bc8:	89 fd                	mov    %edi,%ebp
  803bca:	85 ff                	test   %edi,%edi
  803bcc:	75 0b                	jne    803bd9 <__umoddi3+0xe9>
  803bce:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd3:	31 d2                	xor    %edx,%edx
  803bd5:	f7 f7                	div    %edi
  803bd7:	89 c5                	mov    %eax,%ebp
  803bd9:	89 f0                	mov    %esi,%eax
  803bdb:	31 d2                	xor    %edx,%edx
  803bdd:	f7 f5                	div    %ebp
  803bdf:	89 c8                	mov    %ecx,%eax
  803be1:	f7 f5                	div    %ebp
  803be3:	89 d0                	mov    %edx,%eax
  803be5:	e9 44 ff ff ff       	jmp    803b2e <__umoddi3+0x3e>
  803bea:	66 90                	xchg   %ax,%ax
  803bec:	89 c8                	mov    %ecx,%eax
  803bee:	89 f2                	mov    %esi,%edx
  803bf0:	83 c4 1c             	add    $0x1c,%esp
  803bf3:	5b                   	pop    %ebx
  803bf4:	5e                   	pop    %esi
  803bf5:	5f                   	pop    %edi
  803bf6:	5d                   	pop    %ebp
  803bf7:	c3                   	ret    
  803bf8:	3b 04 24             	cmp    (%esp),%eax
  803bfb:	72 06                	jb     803c03 <__umoddi3+0x113>
  803bfd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c01:	77 0f                	ja     803c12 <__umoddi3+0x122>
  803c03:	89 f2                	mov    %esi,%edx
  803c05:	29 f9                	sub    %edi,%ecx
  803c07:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c0b:	89 14 24             	mov    %edx,(%esp)
  803c0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c12:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c16:	8b 14 24             	mov    (%esp),%edx
  803c19:	83 c4 1c             	add    $0x1c,%esp
  803c1c:	5b                   	pop    %ebx
  803c1d:	5e                   	pop    %esi
  803c1e:	5f                   	pop    %edi
  803c1f:	5d                   	pop    %ebp
  803c20:	c3                   	ret    
  803c21:	8d 76 00             	lea    0x0(%esi),%esi
  803c24:	2b 04 24             	sub    (%esp),%eax
  803c27:	19 fa                	sbb    %edi,%edx
  803c29:	89 d1                	mov    %edx,%ecx
  803c2b:	89 c6                	mov    %eax,%esi
  803c2d:	e9 71 ff ff ff       	jmp    803ba3 <__umoddi3+0xb3>
  803c32:	66 90                	xchg   %ax,%ax
  803c34:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c38:	72 ea                	jb     803c24 <__umoddi3+0x134>
  803c3a:	89 d9                	mov    %ebx,%ecx
  803c3c:	e9 62 ff ff ff       	jmp    803ba3 <__umoddi3+0xb3>
