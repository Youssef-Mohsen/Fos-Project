
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
  800045:	68 00 3c 80 00       	push   $0x803c00
  80004a:	e8 81 14 00 00       	call   8014d0 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 04 3c 80 00       	push   $0x803c04
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
  80009a:	68 29 3c 80 00       	push   $0x803c29
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
  8000da:	68 30 3c 80 00       	push   $0x803c30
  8000df:	50                   	push   %eax
  8000e0:	e8 42 36 00 00       	call   803727 <create_semaphore>
  8000e5:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	6a 01                	push   $0x1
  8000ed:	6a 04                	push   $0x4
  8000ef:	68 32 3c 80 00       	push   $0x803c32
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
  80012e:	68 40 3c 80 00       	push   $0x803c40
  800133:	e8 a8 17 00 00       	call   8018e0 <sys_create_env>
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
  800164:	68 4a 3c 80 00       	push   $0x803c4a
  800169:	e8 72 17 00 00       	call   8018e0 <sys_create_env>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 7f 17 00 00       	call   8018fe <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	e8 71 17 00 00       	call   8018fe <sys_run_env>
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
  8001a4:	68 54 3c 80 00       	push   $0x803c54
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
  8001c8:	e8 50 16 00 00       	call   80181d <sys_cputc>
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
  8001d9:	e8 db 14 00 00       	call   8016b9 <sys_cgetc>
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
  8001f6:	e8 53 17 00 00       	call   80194e <sys_getenvindex>
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
  800264:	e8 69 14 00 00       	call   8016d2 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	68 84 3c 80 00       	push   $0x803c84
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
  800294:	68 ac 3c 80 00       	push   $0x803cac
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
  8002c5:	68 d4 3c 80 00       	push   $0x803cd4
  8002ca:	e8 34 01 00 00       	call   800403 <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d7:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	50                   	push   %eax
  8002e1:	68 2c 3d 80 00       	push   $0x803d2c
  8002e6:	e8 18 01 00 00       	call   800403 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	68 84 3c 80 00       	push   $0x803c84
  8002f6:	e8 08 01 00 00       	call   800403 <cprintf>
  8002fb:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002fe:	e8 e9 13 00 00       	call   8016ec <sys_unlock_cons>
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
  800316:	e8 ff 15 00 00       	call   80191a <sys_destroy_env>
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
  800327:	e8 54 16 00 00       	call   801980 <sys_exit_env>
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
  800375:	e8 16 13 00 00       	call   801690 <sys_cputs>
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
  8003ec:	e8 9f 12 00 00       	call   801690 <sys_cputs>
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
  800436:	e8 97 12 00 00       	call   8016d2 <sys_lock_cons>
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
  800456:	e8 91 12 00 00       	call   8016ec <sys_unlock_cons>
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
  8004a0:	e8 df 34 00 00       	call   803984 <__udivdi3>
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
  8004f0:	e8 9f 35 00 00       	call   803a94 <__umoddi3>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	05 54 3f 80 00       	add    $0x803f54,%eax
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
  80064b:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
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
  80072c:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  800733:	85 f6                	test   %esi,%esi
  800735:	75 19                	jne    800750 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800737:	53                   	push   %ebx
  800738:	68 65 3f 80 00       	push   $0x803f65
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
  800751:	68 6e 3f 80 00       	push   $0x803f6e
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
  80077e:	be 71 3f 80 00       	mov    $0x803f71,%esi
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
  801189:	68 e8 40 80 00       	push   $0x8040e8
  80118e:	68 3f 01 00 00       	push   $0x13f
  801193:	68 0a 41 80 00       	push   $0x80410a
  801198:	e8 fd 25 00 00       	call   80379a <_panic>

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
  8011a9:	e8 8d 0a 00 00       	call   801c3b <sys_sbrk>
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
  801224:	e8 96 08 00 00       	call   801abf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801229:	85 c0                	test   %eax,%eax
  80122b:	74 16                	je     801243 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 d6 0d 00 00       	call   80200e <alloc_block_FF>
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123e:	e9 8a 01 00 00       	jmp    8013cd <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801243:	e8 a8 08 00 00       	call   801af0 <sys_isUHeapPlacementStrategyBESTFIT>
  801248:	85 c0                	test   %eax,%eax
  80124a:	0f 84 7d 01 00 00    	je     8013cd <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	ff 75 08             	pushl  0x8(%ebp)
  801256:	e8 6f 12 00 00       	call   8024ca <alloc_block_BF>
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
  8013bc:	e8 b1 08 00 00       	call   801c72 <sys_allocate_user_mem>
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
  801404:	e8 85 08 00 00       	call   801c8e <get_block_size>
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80140f:	83 ec 0c             	sub    $0xc,%esp
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	e8 b8 1a 00 00       	call   802ed2 <free_block>
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
  8014ac:	e8 a5 07 00 00       	call   801c56 <sys_free_user_mem>
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
  8014ba:	68 18 41 80 00       	push   $0x804118
  8014bf:	68 84 00 00 00       	push   $0x84
  8014c4:	68 42 41 80 00       	push   $0x804142
  8014c9:	e8 cc 22 00 00       	call   80379a <_panic>
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
  8014e7:	eb 64                	jmp    80154d <smalloc+0x7d>
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
  80151c:	eb 2f                	jmp    80154d <smalloc+0x7d>
	 int ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  80151e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801522:	ff 75 ec             	pushl  -0x14(%ebp)
  801525:	50                   	push   %eax
  801526:	ff 75 0c             	pushl  0xc(%ebp)
  801529:	ff 75 08             	pushl  0x8(%ebp)
  80152c:	e8 2c 03 00 00       	call   80185d <sys_createSharedObject>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  801537:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80153b:	74 06                	je     801543 <smalloc+0x73>
  80153d:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801541:	75 07                	jne    80154a <smalloc+0x7a>
  801543:	b8 00 00 00 00       	mov    $0x0,%eax
  801548:	eb 03                	jmp    80154d <smalloc+0x7d>
	 return ptr;
  80154a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	ff 75 0c             	pushl  0xc(%ebp)
  80155b:	ff 75 08             	pushl  0x8(%ebp)
  80155e:	e8 24 03 00 00       	call   801887 <sys_getSizeOfSharedObject>
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801569:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80156d:	75 07                	jne    801576 <sget+0x27>
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
  801574:	eb 5c                	jmp    8015d2 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801579:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80157c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801583:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801589:	39 d0                	cmp    %edx,%eax
  80158b:	7d 02                	jge    80158f <sget+0x40>
  80158d:	89 d0                	mov    %edx,%eax
  80158f:	83 ec 0c             	sub    $0xc,%esp
  801592:	50                   	push   %eax
  801593:	e8 1b fc ff ff       	call   8011b3 <malloc>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80159e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015a2:	75 07                	jne    8015ab <sget+0x5c>
  8015a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a9:	eb 27                	jmp    8015d2 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8015ab:	83 ec 04             	sub    $0x4,%esp
  8015ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8015b1:	ff 75 0c             	pushl  0xc(%ebp)
  8015b4:	ff 75 08             	pushl  0x8(%ebp)
  8015b7:	e8 e8 02 00 00       	call   8018a4 <sys_getSharedObject>
  8015bc:	83 c4 10             	add    $0x10,%esp
  8015bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8015c2:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8015c6:	75 07                	jne    8015cf <sget+0x80>
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cd:	eb 03                	jmp    8015d2 <sget+0x83>
	return ptr;
  8015cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015da:	83 ec 04             	sub    $0x4,%esp
  8015dd:	68 50 41 80 00       	push   $0x804150
  8015e2:	68 c1 00 00 00       	push   $0xc1
  8015e7:	68 42 41 80 00       	push   $0x804142
  8015ec:	e8 a9 21 00 00       	call   80379a <_panic>

008015f1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015f7:	83 ec 04             	sub    $0x4,%esp
  8015fa:	68 74 41 80 00       	push   $0x804174
  8015ff:	68 d8 00 00 00       	push   $0xd8
  801604:	68 42 41 80 00       	push   $0x804142
  801609:	e8 8c 21 00 00       	call   80379a <_panic>

0080160e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 9a 41 80 00       	push   $0x80419a
  80161c:	68 e4 00 00 00       	push   $0xe4
  801621:	68 42 41 80 00       	push   $0x804142
  801626:	e8 6f 21 00 00       	call   80379a <_panic>

0080162b <shrink>:

}
void shrink(uint32 newSize)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801631:	83 ec 04             	sub    $0x4,%esp
  801634:	68 9a 41 80 00       	push   $0x80419a
  801639:	68 e9 00 00 00       	push   $0xe9
  80163e:	68 42 41 80 00       	push   $0x804142
  801643:	e8 52 21 00 00       	call   80379a <_panic>

00801648 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80164e:	83 ec 04             	sub    $0x4,%esp
  801651:	68 9a 41 80 00       	push   $0x80419a
  801656:	68 ee 00 00 00       	push   $0xee
  80165b:	68 42 41 80 00       	push   $0x804142
  801660:	e8 35 21 00 00       	call   80379a <_panic>

00801665 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801665:	55                   	push   %ebp
  801666:	89 e5                	mov    %esp,%ebp
  801668:	57                   	push   %edi
  801669:	56                   	push   %esi
  80166a:	53                   	push   %ebx
  80166b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	8b 55 0c             	mov    0xc(%ebp),%edx
  801674:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801677:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80167a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80167d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801680:	cd 30                	int    $0x30
  801682:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801685:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	5b                   	pop    %ebx
  80168c:	5e                   	pop    %esi
  80168d:	5f                   	pop    %edi
  80168e:	5d                   	pop    %ebp
  80168f:	c3                   	ret    

00801690 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 04             	sub    $0x4,%esp
  801696:	8b 45 10             	mov    0x10(%ebp),%eax
  801699:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80169c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	52                   	push   %edx
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	50                   	push   %eax
  8016ac:	6a 00                	push   $0x0
  8016ae:	e8 b2 ff ff ff       	call   801665 <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	90                   	nop
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 02                	push   $0x2
  8016c8:	e8 98 ff ff ff       	call   801665 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 03                	push   $0x3
  8016e1:	e8 7f ff ff ff       	call   801665 <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	90                   	nop
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 04                	push   $0x4
  8016fb:	e8 65 ff ff ff       	call   801665 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	90                   	nop
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801709:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	52                   	push   %edx
  801716:	50                   	push   %eax
  801717:	6a 08                	push   $0x8
  801719:	e8 47 ff ff ff       	call   801665 <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801728:	8b 75 18             	mov    0x18(%ebp),%esi
  80172b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80172e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801731:	8b 55 0c             	mov    0xc(%ebp),%edx
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	56                   	push   %esi
  801738:	53                   	push   %ebx
  801739:	51                   	push   %ecx
  80173a:	52                   	push   %edx
  80173b:	50                   	push   %eax
  80173c:	6a 09                	push   $0x9
  80173e:	e8 22 ff ff ff       	call   801665 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801749:	5b                   	pop    %ebx
  80174a:	5e                   	pop    %esi
  80174b:	5d                   	pop    %ebp
  80174c:	c3                   	ret    

0080174d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801750:	8b 55 0c             	mov    0xc(%ebp),%edx
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	52                   	push   %edx
  80175d:	50                   	push   %eax
  80175e:	6a 0a                	push   $0xa
  801760:	e8 00 ff ff ff       	call   801665 <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	ff 75 0c             	pushl  0xc(%ebp)
  801776:	ff 75 08             	pushl  0x8(%ebp)
  801779:	6a 0b                	push   $0xb
  80177b:	e8 e5 fe ff ff       	call   801665 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 0c                	push   $0xc
  801794:	e8 cc fe ff ff       	call   801665 <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 0d                	push   $0xd
  8017ad:	e8 b3 fe ff ff       	call   801665 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 0e                	push   $0xe
  8017c6:	e8 9a fe ff ff       	call   801665 <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 0f                	push   $0xf
  8017df:	e8 81 fe ff ff       	call   801665 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	6a 10                	push   $0x10
  8017f9:	e8 67 fe ff ff       	call   801665 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 11                	push   $0x11
  801812:	e8 4e fe ff ff       	call   801665 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	90                   	nop
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_cputc>:

void
sys_cputc(const char c)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801829:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	50                   	push   %eax
  801836:	6a 01                	push   $0x1
  801838:	e8 28 fe ff ff       	call   801665 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	90                   	nop
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 14                	push   $0x14
  801852:	e8 0e fe ff ff       	call   801665 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	8b 45 10             	mov    0x10(%ebp),%eax
  801866:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801869:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80186c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	6a 00                	push   $0x0
  801875:	51                   	push   %ecx
  801876:	52                   	push   %edx
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	50                   	push   %eax
  80187b:	6a 15                	push   $0x15
  80187d:	e8 e3 fd ff ff       	call   801665 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	52                   	push   %edx
  801897:	50                   	push   %eax
  801898:	6a 16                	push   $0x16
  80189a:	e8 c6 fd ff ff       	call   801665 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	51                   	push   %ecx
  8018b5:	52                   	push   %edx
  8018b6:	50                   	push   %eax
  8018b7:	6a 17                	push   $0x17
  8018b9:	e8 a7 fd ff ff       	call   801665 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	52                   	push   %edx
  8018d3:	50                   	push   %eax
  8018d4:	6a 18                	push   $0x18
  8018d6:	e8 8a fd ff ff       	call   801665 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	6a 00                	push   $0x0
  8018e8:	ff 75 14             	pushl  0x14(%ebp)
  8018eb:	ff 75 10             	pushl  0x10(%ebp)
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	50                   	push   %eax
  8018f2:	6a 19                	push   $0x19
  8018f4:	e8 6c fd ff ff       	call   801665 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_run_env>:

void sys_run_env(int32 envId)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	50                   	push   %eax
  80190d:	6a 1a                	push   $0x1a
  80190f:	e8 51 fd ff ff       	call   801665 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	90                   	nop
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	50                   	push   %eax
  801929:	6a 1b                	push   $0x1b
  80192b:	e8 35 fd ff ff       	call   801665 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 05                	push   $0x5
  801944:	e8 1c fd ff ff       	call   801665 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 06                	push   $0x6
  80195d:	e8 03 fd ff ff       	call   801665 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 07                	push   $0x7
  801976:	e8 ea fc ff ff       	call   801665 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_exit_env>:


void sys_exit_env(void)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 1c                	push   $0x1c
  80198f:	e8 d1 fc ff ff       	call   801665 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	90                   	nop
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019a0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a3:	8d 50 04             	lea    0x4(%eax),%edx
  8019a6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	52                   	push   %edx
  8019b0:	50                   	push   %eax
  8019b1:	6a 1d                	push   $0x1d
  8019b3:	e8 ad fc ff ff       	call   801665 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
	return result;
  8019bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c4:	89 01                	mov    %eax,(%ecx)
  8019c6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	c9                   	leave  
  8019cd:	c2 04 00             	ret    $0x4

008019d0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	ff 75 10             	pushl  0x10(%ebp)
  8019da:	ff 75 0c             	pushl  0xc(%ebp)
  8019dd:	ff 75 08             	pushl  0x8(%ebp)
  8019e0:	6a 13                	push   $0x13
  8019e2:	e8 7e fc ff ff       	call   801665 <syscall>
  8019e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ea:	90                   	nop
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_rcr2>:
uint32 sys_rcr2()
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 1e                	push   $0x1e
  8019fc:	e8 64 fc ff ff       	call   801665 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 04             	sub    $0x4,%esp
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a12:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	50                   	push   %eax
  801a1f:	6a 1f                	push   $0x1f
  801a21:	e8 3f fc ff ff       	call   801665 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
	return ;
  801a29:	90                   	nop
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <rsttst>:
void rsttst()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 21                	push   $0x21
  801a3b:	e8 25 fc ff ff       	call   801665 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
	return ;
  801a43:	90                   	nop
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a52:	8b 55 18             	mov    0x18(%ebp),%edx
  801a55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a59:	52                   	push   %edx
  801a5a:	50                   	push   %eax
  801a5b:	ff 75 10             	pushl  0x10(%ebp)
  801a5e:	ff 75 0c             	pushl  0xc(%ebp)
  801a61:	ff 75 08             	pushl  0x8(%ebp)
  801a64:	6a 20                	push   $0x20
  801a66:	e8 fa fb ff ff       	call   801665 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6e:	90                   	nop
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <chktst>:
void chktst(uint32 n)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 08             	pushl  0x8(%ebp)
  801a7f:	6a 22                	push   $0x22
  801a81:	e8 df fb ff ff       	call   801665 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
	return ;
  801a89:	90                   	nop
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <inctst>:

void inctst()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 23                	push   $0x23
  801a9b:	e8 c5 fb ff ff       	call   801665 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa3:	90                   	nop
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <gettst>:
uint32 gettst()
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 24                	push   $0x24
  801ab5:	e8 ab fb ff ff       	call   801665 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 25                	push   $0x25
  801ad1:	e8 8f fb ff ff       	call   801665 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
  801ad9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801adc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ae0:	75 07                	jne    801ae9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ae2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae7:	eb 05                	jmp    801aee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 25                	push   $0x25
  801b02:	e8 5e fb ff ff       	call   801665 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
  801b0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b0d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b11:	75 07                	jne    801b1a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b13:	b8 01 00 00 00       	mov    $0x1,%eax
  801b18:	eb 05                	jmp    801b1f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 25                	push   $0x25
  801b33:	e8 2d fb ff ff       	call   801665 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
  801b3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b3e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b42:	75 07                	jne    801b4b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b44:	b8 01 00 00 00       	mov    $0x1,%eax
  801b49:	eb 05                	jmp    801b50 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 25                	push   $0x25
  801b64:	e8 fc fa ff ff       	call   801665 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
  801b6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b6f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b73:	75 07                	jne    801b7c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b75:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7a:	eb 05                	jmp    801b81 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	ff 75 08             	pushl  0x8(%ebp)
  801b91:	6a 26                	push   $0x26
  801b93:	e8 cd fa ff ff       	call   801665 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9b:	90                   	nop
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ba2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ba5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	53                   	push   %ebx
  801bb1:	51                   	push   %ecx
  801bb2:	52                   	push   %edx
  801bb3:	50                   	push   %eax
  801bb4:	6a 27                	push   $0x27
  801bb6:	e8 aa fa ff ff       	call   801665 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	52                   	push   %edx
  801bd3:	50                   	push   %eax
  801bd4:	6a 28                	push   $0x28
  801bd6:	e8 8a fa ff ff       	call   801665 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801be3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	6a 00                	push   $0x0
  801bee:	51                   	push   %ecx
  801bef:	ff 75 10             	pushl  0x10(%ebp)
  801bf2:	52                   	push   %edx
  801bf3:	50                   	push   %eax
  801bf4:	6a 29                	push   $0x29
  801bf6:	e8 6a fa ff ff       	call   801665 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	ff 75 10             	pushl  0x10(%ebp)
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	ff 75 08             	pushl  0x8(%ebp)
  801c10:	6a 12                	push   $0x12
  801c12:	e8 4e fa ff ff       	call   801665 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1a:	90                   	nop
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	52                   	push   %edx
  801c2d:	50                   	push   %eax
  801c2e:	6a 2a                	push   $0x2a
  801c30:	e8 30 fa ff ff       	call   801665 <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
	return;
  801c38:	90                   	nop
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	50                   	push   %eax
  801c4a:	6a 2b                	push   $0x2b
  801c4c:	e8 14 fa ff ff       	call   801665 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	ff 75 0c             	pushl  0xc(%ebp)
  801c62:	ff 75 08             	pushl  0x8(%ebp)
  801c65:	6a 2c                	push   $0x2c
  801c67:	e8 f9 f9 ff ff       	call   801665 <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
	return;
  801c6f:	90                   	nop
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	ff 75 0c             	pushl  0xc(%ebp)
  801c7e:	ff 75 08             	pushl  0x8(%ebp)
  801c81:	6a 2d                	push   $0x2d
  801c83:	e8 dd f9 ff ff       	call   801665 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
	return;
  801c8b:	90                   	nop
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	83 e8 04             	sub    $0x4,%eax
  801c9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ca0:	8b 00                	mov    (%eax),%eax
  801ca2:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801cad:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb0:	83 e8 04             	sub    $0x4,%eax
  801cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801cb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cb9:	8b 00                	mov    (%eax),%eax
  801cbb:	83 e0 01             	and    $0x1,%eax
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	0f 94 c0             	sete   %al
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ccb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd5:	83 f8 02             	cmp    $0x2,%eax
  801cd8:	74 2b                	je     801d05 <alloc_block+0x40>
  801cda:	83 f8 02             	cmp    $0x2,%eax
  801cdd:	7f 07                	jg     801ce6 <alloc_block+0x21>
  801cdf:	83 f8 01             	cmp    $0x1,%eax
  801ce2:	74 0e                	je     801cf2 <alloc_block+0x2d>
  801ce4:	eb 58                	jmp    801d3e <alloc_block+0x79>
  801ce6:	83 f8 03             	cmp    $0x3,%eax
  801ce9:	74 2d                	je     801d18 <alloc_block+0x53>
  801ceb:	83 f8 04             	cmp    $0x4,%eax
  801cee:	74 3b                	je     801d2b <alloc_block+0x66>
  801cf0:	eb 4c                	jmp    801d3e <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801cf2:	83 ec 0c             	sub    $0xc,%esp
  801cf5:	ff 75 08             	pushl  0x8(%ebp)
  801cf8:	e8 11 03 00 00       	call   80200e <alloc_block_FF>
  801cfd:	83 c4 10             	add    $0x10,%esp
  801d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d03:	eb 4a                	jmp    801d4f <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801d05:	83 ec 0c             	sub    $0xc,%esp
  801d08:	ff 75 08             	pushl  0x8(%ebp)
  801d0b:	e8 fa 19 00 00       	call   80370a <alloc_block_NF>
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d16:	eb 37                	jmp    801d4f <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801d18:	83 ec 0c             	sub    $0xc,%esp
  801d1b:	ff 75 08             	pushl  0x8(%ebp)
  801d1e:	e8 a7 07 00 00       	call   8024ca <alloc_block_BF>
  801d23:	83 c4 10             	add    $0x10,%esp
  801d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d29:	eb 24                	jmp    801d4f <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801d2b:	83 ec 0c             	sub    $0xc,%esp
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	e8 b7 19 00 00       	call   8036ed <alloc_block_WF>
  801d36:	83 c4 10             	add    $0x10,%esp
  801d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d3c:	eb 11                	jmp    801d4f <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801d3e:	83 ec 0c             	sub    $0xc,%esp
  801d41:	68 ac 41 80 00       	push   $0x8041ac
  801d46:	e8 b8 e6 ff ff       	call   800403 <cprintf>
  801d4b:	83 c4 10             	add    $0x10,%esp
		break;
  801d4e:	90                   	nop
	}
	return va;
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	53                   	push   %ebx
  801d58:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801d5b:	83 ec 0c             	sub    $0xc,%esp
  801d5e:	68 cc 41 80 00       	push   $0x8041cc
  801d63:	e8 9b e6 ff ff       	call   800403 <cprintf>
  801d68:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d6b:	83 ec 0c             	sub    $0xc,%esp
  801d6e:	68 f7 41 80 00       	push   $0x8041f7
  801d73:	e8 8b e6 ff ff       	call   800403 <cprintf>
  801d78:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d81:	eb 37                	jmp    801dba <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d83:	83 ec 0c             	sub    $0xc,%esp
  801d86:	ff 75 f4             	pushl  -0xc(%ebp)
  801d89:	e8 19 ff ff ff       	call   801ca7 <is_free_block>
  801d8e:	83 c4 10             	add    $0x10,%esp
  801d91:	0f be d8             	movsbl %al,%ebx
  801d94:	83 ec 0c             	sub    $0xc,%esp
  801d97:	ff 75 f4             	pushl  -0xc(%ebp)
  801d9a:	e8 ef fe ff ff       	call   801c8e <get_block_size>
  801d9f:	83 c4 10             	add    $0x10,%esp
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	53                   	push   %ebx
  801da6:	50                   	push   %eax
  801da7:	68 0f 42 80 00       	push   $0x80420f
  801dac:	e8 52 e6 ff ff       	call   800403 <cprintf>
  801db1:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801db4:	8b 45 10             	mov    0x10(%ebp),%eax
  801db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dbe:	74 07                	je     801dc7 <print_blocks_list+0x73>
  801dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc3:	8b 00                	mov    (%eax),%eax
  801dc5:	eb 05                	jmp    801dcc <print_blocks_list+0x78>
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcc:	89 45 10             	mov    %eax,0x10(%ebp)
  801dcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	75 ad                	jne    801d83 <print_blocks_list+0x2f>
  801dd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dda:	75 a7                	jne    801d83 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	68 cc 41 80 00       	push   $0x8041cc
  801de4:	e8 1a e6 ff ff       	call   800403 <cprintf>
  801de9:	83 c4 10             	add    $0x10,%esp

}
  801dec:	90                   	nop
  801ded:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfb:	83 e0 01             	and    $0x1,%eax
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	74 03                	je     801e05 <initialize_dynamic_allocator+0x13>
  801e02:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801e05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e09:	0f 84 c7 01 00 00    	je     801fd6 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801e0f:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801e16:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801e19:	8b 55 08             	mov    0x8(%ebp),%edx
  801e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1f:	01 d0                	add    %edx,%eax
  801e21:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801e26:	0f 87 ad 01 00 00    	ja     801fd9 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	0f 89 a5 01 00 00    	jns    801fdc <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801e37:	8b 55 08             	mov    0x8(%ebp),%edx
  801e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3d:	01 d0                	add    %edx,%eax
  801e3f:	83 e8 04             	sub    $0x4,%eax
  801e42:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801e47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801e4e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e56:	e9 87 00 00 00       	jmp    801ee2 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5f:	75 14                	jne    801e75 <initialize_dynamic_allocator+0x83>
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	68 27 42 80 00       	push   $0x804227
  801e69:	6a 79                	push   $0x79
  801e6b:	68 45 42 80 00       	push   $0x804245
  801e70:	e8 25 19 00 00       	call   80379a <_panic>
  801e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e78:	8b 00                	mov    (%eax),%eax
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	74 10                	je     801e8e <initialize_dynamic_allocator+0x9c>
  801e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e81:	8b 00                	mov    (%eax),%eax
  801e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e86:	8b 52 04             	mov    0x4(%edx),%edx
  801e89:	89 50 04             	mov    %edx,0x4(%eax)
  801e8c:	eb 0b                	jmp    801e99 <initialize_dynamic_allocator+0xa7>
  801e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e91:	8b 40 04             	mov    0x4(%eax),%eax
  801e94:	a3 30 50 80 00       	mov    %eax,0x805030
  801e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9c:	8b 40 04             	mov    0x4(%eax),%eax
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	74 0f                	je     801eb2 <initialize_dynamic_allocator+0xc0>
  801ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea6:	8b 40 04             	mov    0x4(%eax),%eax
  801ea9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eac:	8b 12                	mov    (%edx),%edx
  801eae:	89 10                	mov    %edx,(%eax)
  801eb0:	eb 0a                	jmp    801ebc <initialize_dynamic_allocator+0xca>
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	8b 00                	mov    (%eax),%eax
  801eb7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ecf:	a1 38 50 80 00       	mov    0x805038,%eax
  801ed4:	48                   	dec    %eax
  801ed5:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801eda:	a1 34 50 80 00       	mov    0x805034,%eax
  801edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee6:	74 07                	je     801eef <initialize_dynamic_allocator+0xfd>
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	8b 00                	mov    (%eax),%eax
  801eed:	eb 05                	jmp    801ef4 <initialize_dynamic_allocator+0x102>
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef4:	a3 34 50 80 00       	mov    %eax,0x805034
  801ef9:	a1 34 50 80 00       	mov    0x805034,%eax
  801efe:	85 c0                	test   %eax,%eax
  801f00:	0f 85 55 ff ff ff    	jne    801e5b <initialize_dynamic_allocator+0x69>
  801f06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0a:	0f 85 4b ff ff ff    	jne    801e5b <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f19:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801f1f:	a1 44 50 80 00       	mov    0x805044,%eax
  801f24:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801f29:	a1 40 50 80 00       	mov    0x805040,%eax
  801f2e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	83 c0 08             	add    $0x8,%eax
  801f3a:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	83 c0 04             	add    $0x4,%eax
  801f43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f46:	83 ea 08             	sub    $0x8,%edx
  801f49:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	01 d0                	add    %edx,%eax
  801f53:	83 e8 08             	sub    $0x8,%eax
  801f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f59:	83 ea 08             	sub    $0x8,%edx
  801f5c:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801f5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f71:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f75:	75 17                	jne    801f8e <initialize_dynamic_allocator+0x19c>
  801f77:	83 ec 04             	sub    $0x4,%esp
  801f7a:	68 60 42 80 00       	push   $0x804260
  801f7f:	68 90 00 00 00       	push   $0x90
  801f84:	68 45 42 80 00       	push   $0x804245
  801f89:	e8 0c 18 00 00       	call   80379a <_panic>
  801f8e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f97:	89 10                	mov    %edx,(%eax)
  801f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9c:	8b 00                	mov    (%eax),%eax
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	74 0d                	je     801faf <initialize_dynamic_allocator+0x1bd>
  801fa2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fa7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801faa:	89 50 04             	mov    %edx,0x4(%eax)
  801fad:	eb 08                	jmp    801fb7 <initialize_dynamic_allocator+0x1c5>
  801faf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb2:	a3 30 50 80 00       	mov    %eax,0x805030
  801fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc9:	a1 38 50 80 00       	mov    0x805038,%eax
  801fce:	40                   	inc    %eax
  801fcf:	a3 38 50 80 00       	mov    %eax,0x805038
  801fd4:	eb 07                	jmp    801fdd <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801fd6:	90                   	nop
  801fd7:	eb 04                	jmp    801fdd <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801fd9:	90                   	nop
  801fda:	eb 01                	jmp    801fdd <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801fdc:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801fe2:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe5:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	8d 50 fc             	lea    -0x4(%eax),%edx
  801fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff1:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	83 e8 04             	sub    $0x4,%eax
  801ff9:	8b 00                	mov    (%eax),%eax
  801ffb:	83 e0 fe             	and    $0xfffffffe,%eax
  801ffe:	8d 50 f8             	lea    -0x8(%eax),%edx
  802001:	8b 45 08             	mov    0x8(%ebp),%eax
  802004:	01 c2                	add    %eax,%edx
  802006:	8b 45 0c             	mov    0xc(%ebp),%eax
  802009:	89 02                	mov    %eax,(%edx)
}
  80200b:	90                   	nop
  80200c:	5d                   	pop    %ebp
  80200d:	c3                   	ret    

0080200e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	83 e0 01             	and    $0x1,%eax
  80201a:	85 c0                	test   %eax,%eax
  80201c:	74 03                	je     802021 <alloc_block_FF+0x13>
  80201e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802021:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802025:	77 07                	ja     80202e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802027:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80202e:	a1 24 50 80 00       	mov    0x805024,%eax
  802033:	85 c0                	test   %eax,%eax
  802035:	75 73                	jne    8020aa <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	83 c0 10             	add    $0x10,%eax
  80203d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802040:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802047:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80204a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204d:	01 d0                	add    %edx,%eax
  80204f:	48                   	dec    %eax
  802050:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802056:	ba 00 00 00 00       	mov    $0x0,%edx
  80205b:	f7 75 ec             	divl   -0x14(%ebp)
  80205e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802061:	29 d0                	sub    %edx,%eax
  802063:	c1 e8 0c             	shr    $0xc,%eax
  802066:	83 ec 0c             	sub    $0xc,%esp
  802069:	50                   	push   %eax
  80206a:	e8 2e f1 ff ff       	call   80119d <sbrk>
  80206f:	83 c4 10             	add    $0x10,%esp
  802072:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802075:	83 ec 0c             	sub    $0xc,%esp
  802078:	6a 00                	push   $0x0
  80207a:	e8 1e f1 ff ff       	call   80119d <sbrk>
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802085:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802088:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80208b:	83 ec 08             	sub    $0x8,%esp
  80208e:	50                   	push   %eax
  80208f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802092:	e8 5b fd ff ff       	call   801df2 <initialize_dynamic_allocator>
  802097:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80209a:	83 ec 0c             	sub    $0xc,%esp
  80209d:	68 83 42 80 00       	push   $0x804283
  8020a2:	e8 5c e3 ff ff       	call   800403 <cprintf>
  8020a7:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8020aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ae:	75 0a                	jne    8020ba <alloc_block_FF+0xac>
	        return NULL;
  8020b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b5:	e9 0e 04 00 00       	jmp    8024c8 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8020ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8020c1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c9:	e9 f3 02 00 00       	jmp    8023c1 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	ff 75 bc             	pushl  -0x44(%ebp)
  8020da:	e8 af fb ff ff       	call   801c8e <get_block_size>
  8020df:	83 c4 10             	add    $0x10,%esp
  8020e2:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	83 c0 08             	add    $0x8,%eax
  8020eb:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020ee:	0f 87 c5 02 00 00    	ja     8023b9 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	83 c0 18             	add    $0x18,%eax
  8020fa:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020fd:	0f 87 19 02 00 00    	ja     80231c <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802103:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802106:	2b 45 08             	sub    0x8(%ebp),%eax
  802109:	83 e8 08             	sub    $0x8,%eax
  80210c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	8d 50 08             	lea    0x8(%eax),%edx
  802115:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802118:	01 d0                	add    %edx,%eax
  80211a:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	83 c0 08             	add    $0x8,%eax
  802123:	83 ec 04             	sub    $0x4,%esp
  802126:	6a 01                	push   $0x1
  802128:	50                   	push   %eax
  802129:	ff 75 bc             	pushl  -0x44(%ebp)
  80212c:	e8 ae fe ff ff       	call   801fdf <set_block_data>
  802131:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802137:	8b 40 04             	mov    0x4(%eax),%eax
  80213a:	85 c0                	test   %eax,%eax
  80213c:	75 68                	jne    8021a6 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80213e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802142:	75 17                	jne    80215b <alloc_block_FF+0x14d>
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	68 60 42 80 00       	push   $0x804260
  80214c:	68 d7 00 00 00       	push   $0xd7
  802151:	68 45 42 80 00       	push   $0x804245
  802156:	e8 3f 16 00 00       	call   80379a <_panic>
  80215b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802161:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802164:	89 10                	mov    %edx,(%eax)
  802166:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802169:	8b 00                	mov    (%eax),%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	74 0d                	je     80217c <alloc_block_FF+0x16e>
  80216f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802174:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802177:	89 50 04             	mov    %edx,0x4(%eax)
  80217a:	eb 08                	jmp    802184 <alloc_block_FF+0x176>
  80217c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80217f:	a3 30 50 80 00       	mov    %eax,0x805030
  802184:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802187:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80218c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80218f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802196:	a1 38 50 80 00       	mov    0x805038,%eax
  80219b:	40                   	inc    %eax
  80219c:	a3 38 50 80 00       	mov    %eax,0x805038
  8021a1:	e9 dc 00 00 00       	jmp    802282 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8021a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a9:	8b 00                	mov    (%eax),%eax
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	75 65                	jne    802214 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8021af:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021b3:	75 17                	jne    8021cc <alloc_block_FF+0x1be>
  8021b5:	83 ec 04             	sub    $0x4,%esp
  8021b8:	68 94 42 80 00       	push   $0x804294
  8021bd:	68 db 00 00 00       	push   $0xdb
  8021c2:	68 45 42 80 00       	push   $0x804245
  8021c7:	e8 ce 15 00 00       	call   80379a <_panic>
  8021cc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8021d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021d5:	89 50 04             	mov    %edx,0x4(%eax)
  8021d8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021db:	8b 40 04             	mov    0x4(%eax),%eax
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	74 0c                	je     8021ee <alloc_block_FF+0x1e0>
  8021e2:	a1 30 50 80 00       	mov    0x805030,%eax
  8021e7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021ea:	89 10                	mov    %edx,(%eax)
  8021ec:	eb 08                	jmp    8021f6 <alloc_block_FF+0x1e8>
  8021ee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8021f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021f9:	a3 30 50 80 00       	mov    %eax,0x805030
  8021fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802207:	a1 38 50 80 00       	mov    0x805038,%eax
  80220c:	40                   	inc    %eax
  80220d:	a3 38 50 80 00       	mov    %eax,0x805038
  802212:	eb 6e                	jmp    802282 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802218:	74 06                	je     802220 <alloc_block_FF+0x212>
  80221a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80221e:	75 17                	jne    802237 <alloc_block_FF+0x229>
  802220:	83 ec 04             	sub    $0x4,%esp
  802223:	68 b8 42 80 00       	push   $0x8042b8
  802228:	68 df 00 00 00       	push   $0xdf
  80222d:	68 45 42 80 00       	push   $0x804245
  802232:	e8 63 15 00 00       	call   80379a <_panic>
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	8b 10                	mov    (%eax),%edx
  80223c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80223f:	89 10                	mov    %edx,(%eax)
  802241:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802244:	8b 00                	mov    (%eax),%eax
  802246:	85 c0                	test   %eax,%eax
  802248:	74 0b                	je     802255 <alloc_block_FF+0x247>
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802252:	89 50 04             	mov    %edx,0x4(%eax)
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80225b:	89 10                	mov    %edx,(%eax)
  80225d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802260:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802263:	89 50 04             	mov    %edx,0x4(%eax)
  802266:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802269:	8b 00                	mov    (%eax),%eax
  80226b:	85 c0                	test   %eax,%eax
  80226d:	75 08                	jne    802277 <alloc_block_FF+0x269>
  80226f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802272:	a3 30 50 80 00       	mov    %eax,0x805030
  802277:	a1 38 50 80 00       	mov    0x805038,%eax
  80227c:	40                   	inc    %eax
  80227d:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802286:	75 17                	jne    80229f <alloc_block_FF+0x291>
  802288:	83 ec 04             	sub    $0x4,%esp
  80228b:	68 27 42 80 00       	push   $0x804227
  802290:	68 e1 00 00 00       	push   $0xe1
  802295:	68 45 42 80 00       	push   $0x804245
  80229a:	e8 fb 14 00 00       	call   80379a <_panic>
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	74 10                	je     8022b8 <alloc_block_FF+0x2aa>
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	8b 00                	mov    (%eax),%eax
  8022ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b0:	8b 52 04             	mov    0x4(%edx),%edx
  8022b3:	89 50 04             	mov    %edx,0x4(%eax)
  8022b6:	eb 0b                	jmp    8022c3 <alloc_block_FF+0x2b5>
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 40 04             	mov    0x4(%eax),%eax
  8022be:	a3 30 50 80 00       	mov    %eax,0x805030
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 40 04             	mov    0x4(%eax),%eax
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	74 0f                	je     8022dc <alloc_block_FF+0x2ce>
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	8b 40 04             	mov    0x4(%eax),%eax
  8022d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d6:	8b 12                	mov    (%edx),%edx
  8022d8:	89 10                	mov    %edx,(%eax)
  8022da:	eb 0a                	jmp    8022e6 <alloc_block_FF+0x2d8>
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	8b 00                	mov    (%eax),%eax
  8022e1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8022fe:	48                   	dec    %eax
  8022ff:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802304:	83 ec 04             	sub    $0x4,%esp
  802307:	6a 00                	push   $0x0
  802309:	ff 75 b4             	pushl  -0x4c(%ebp)
  80230c:	ff 75 b0             	pushl  -0x50(%ebp)
  80230f:	e8 cb fc ff ff       	call   801fdf <set_block_data>
  802314:	83 c4 10             	add    $0x10,%esp
  802317:	e9 95 00 00 00       	jmp    8023b1 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	6a 01                	push   $0x1
  802321:	ff 75 b8             	pushl  -0x48(%ebp)
  802324:	ff 75 bc             	pushl  -0x44(%ebp)
  802327:	e8 b3 fc ff ff       	call   801fdf <set_block_data>
  80232c:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	75 17                	jne    80234c <alloc_block_FF+0x33e>
  802335:	83 ec 04             	sub    $0x4,%esp
  802338:	68 27 42 80 00       	push   $0x804227
  80233d:	68 e8 00 00 00       	push   $0xe8
  802342:	68 45 42 80 00       	push   $0x804245
  802347:	e8 4e 14 00 00       	call   80379a <_panic>
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	85 c0                	test   %eax,%eax
  802353:	74 10                	je     802365 <alloc_block_FF+0x357>
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235d:	8b 52 04             	mov    0x4(%edx),%edx
  802360:	89 50 04             	mov    %edx,0x4(%eax)
  802363:	eb 0b                	jmp    802370 <alloc_block_FF+0x362>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 40 04             	mov    0x4(%eax),%eax
  80236b:	a3 30 50 80 00       	mov    %eax,0x805030
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 40 04             	mov    0x4(%eax),%eax
  802376:	85 c0                	test   %eax,%eax
  802378:	74 0f                	je     802389 <alloc_block_FF+0x37b>
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 40 04             	mov    0x4(%eax),%eax
  802380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802383:	8b 12                	mov    (%edx),%edx
  802385:	89 10                	mov    %edx,(%eax)
  802387:	eb 0a                	jmp    802393 <alloc_block_FF+0x385>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 00                	mov    (%eax),%eax
  80238e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8023ab:	48                   	dec    %eax
  8023ac:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8023b1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023b4:	e9 0f 01 00 00       	jmp    8024c8 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023b9:	a1 34 50 80 00       	mov    0x805034,%eax
  8023be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c5:	74 07                	je     8023ce <alloc_block_FF+0x3c0>
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 00                	mov    (%eax),%eax
  8023cc:	eb 05                	jmp    8023d3 <alloc_block_FF+0x3c5>
  8023ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d3:	a3 34 50 80 00       	mov    %eax,0x805034
  8023d8:	a1 34 50 80 00       	mov    0x805034,%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	0f 85 e9 fc ff ff    	jne    8020ce <alloc_block_FF+0xc0>
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	0f 85 df fc ff ff    	jne    8020ce <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	83 c0 08             	add    $0x8,%eax
  8023f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8023f8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8023ff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802402:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802405:	01 d0                	add    %edx,%eax
  802407:	48                   	dec    %eax
  802408:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80240b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80240e:	ba 00 00 00 00       	mov    $0x0,%edx
  802413:	f7 75 d8             	divl   -0x28(%ebp)
  802416:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802419:	29 d0                	sub    %edx,%eax
  80241b:	c1 e8 0c             	shr    $0xc,%eax
  80241e:	83 ec 0c             	sub    $0xc,%esp
  802421:	50                   	push   %eax
  802422:	e8 76 ed ff ff       	call   80119d <sbrk>
  802427:	83 c4 10             	add    $0x10,%esp
  80242a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80242d:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802431:	75 0a                	jne    80243d <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
  802438:	e9 8b 00 00 00       	jmp    8024c8 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80243d:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802444:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802447:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80244a:	01 d0                	add    %edx,%eax
  80244c:	48                   	dec    %eax
  80244d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802450:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802453:	ba 00 00 00 00       	mov    $0x0,%edx
  802458:	f7 75 cc             	divl   -0x34(%ebp)
  80245b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80245e:	29 d0                	sub    %edx,%eax
  802460:	8d 50 fc             	lea    -0x4(%eax),%edx
  802463:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802466:	01 d0                	add    %edx,%eax
  802468:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80246d:	a1 40 50 80 00       	mov    0x805040,%eax
  802472:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802478:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80247f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802482:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802485:	01 d0                	add    %edx,%eax
  802487:	48                   	dec    %eax
  802488:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80248b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80248e:	ba 00 00 00 00       	mov    $0x0,%edx
  802493:	f7 75 c4             	divl   -0x3c(%ebp)
  802496:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802499:	29 d0                	sub    %edx,%eax
  80249b:	83 ec 04             	sub    $0x4,%esp
  80249e:	6a 01                	push   $0x1
  8024a0:	50                   	push   %eax
  8024a1:	ff 75 d0             	pushl  -0x30(%ebp)
  8024a4:	e8 36 fb ff ff       	call   801fdf <set_block_data>
  8024a9:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8024ac:	83 ec 0c             	sub    $0xc,%esp
  8024af:	ff 75 d0             	pushl  -0x30(%ebp)
  8024b2:	e8 1b 0a 00 00       	call   802ed2 <free_block>
  8024b7:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8024ba:	83 ec 0c             	sub    $0xc,%esp
  8024bd:	ff 75 08             	pushl  0x8(%ebp)
  8024c0:	e8 49 fb ff ff       	call   80200e <alloc_block_FF>
  8024c5:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d3:	83 e0 01             	and    $0x1,%eax
  8024d6:	85 c0                	test   %eax,%eax
  8024d8:	74 03                	je     8024dd <alloc_block_BF+0x13>
  8024da:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024dd:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024e1:	77 07                	ja     8024ea <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024e3:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024ea:	a1 24 50 80 00       	mov    0x805024,%eax
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	75 73                	jne    802566 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f6:	83 c0 10             	add    $0x10,%eax
  8024f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024fc:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802503:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802506:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802509:	01 d0                	add    %edx,%eax
  80250b:	48                   	dec    %eax
  80250c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80250f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802512:	ba 00 00 00 00       	mov    $0x0,%edx
  802517:	f7 75 e0             	divl   -0x20(%ebp)
  80251a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80251d:	29 d0                	sub    %edx,%eax
  80251f:	c1 e8 0c             	shr    $0xc,%eax
  802522:	83 ec 0c             	sub    $0xc,%esp
  802525:	50                   	push   %eax
  802526:	e8 72 ec ff ff       	call   80119d <sbrk>
  80252b:	83 c4 10             	add    $0x10,%esp
  80252e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802531:	83 ec 0c             	sub    $0xc,%esp
  802534:	6a 00                	push   $0x0
  802536:	e8 62 ec ff ff       	call   80119d <sbrk>
  80253b:	83 c4 10             	add    $0x10,%esp
  80253e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802541:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802544:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802547:	83 ec 08             	sub    $0x8,%esp
  80254a:	50                   	push   %eax
  80254b:	ff 75 d8             	pushl  -0x28(%ebp)
  80254e:	e8 9f f8 ff ff       	call   801df2 <initialize_dynamic_allocator>
  802553:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802556:	83 ec 0c             	sub    $0xc,%esp
  802559:	68 83 42 80 00       	push   $0x804283
  80255e:	e8 a0 de ff ff       	call   800403 <cprintf>
  802563:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802566:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80256d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802574:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80257b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802582:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802587:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258a:	e9 1d 01 00 00       	jmp    8026ac <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  802595:	83 ec 0c             	sub    $0xc,%esp
  802598:	ff 75 a8             	pushl  -0x58(%ebp)
  80259b:	e8 ee f6 ff ff       	call   801c8e <get_block_size>
  8025a0:	83 c4 10             	add    $0x10,%esp
  8025a3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8025a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a9:	83 c0 08             	add    $0x8,%eax
  8025ac:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025af:	0f 87 ef 00 00 00    	ja     8026a4 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	83 c0 18             	add    $0x18,%eax
  8025bb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025be:	77 1d                	ja     8025dd <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8025c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025c6:	0f 86 d8 00 00 00    	jbe    8026a4 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8025cc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8025d2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025d8:	e9 c7 00 00 00       	jmp    8026a4 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8025dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e0:	83 c0 08             	add    $0x8,%eax
  8025e3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025e6:	0f 85 9d 00 00 00    	jne    802689 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8025ec:	83 ec 04             	sub    $0x4,%esp
  8025ef:	6a 01                	push   $0x1
  8025f1:	ff 75 a4             	pushl  -0x5c(%ebp)
  8025f4:	ff 75 a8             	pushl  -0x58(%ebp)
  8025f7:	e8 e3 f9 ff ff       	call   801fdf <set_block_data>
  8025fc:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  8025ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802603:	75 17                	jne    80261c <alloc_block_BF+0x152>
  802605:	83 ec 04             	sub    $0x4,%esp
  802608:	68 27 42 80 00       	push   $0x804227
  80260d:	68 2c 01 00 00       	push   $0x12c
  802612:	68 45 42 80 00       	push   $0x804245
  802617:	e8 7e 11 00 00       	call   80379a <_panic>
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	74 10                	je     802635 <alloc_block_BF+0x16b>
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262d:	8b 52 04             	mov    0x4(%edx),%edx
  802630:	89 50 04             	mov    %edx,0x4(%eax)
  802633:	eb 0b                	jmp    802640 <alloc_block_BF+0x176>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 40 04             	mov    0x4(%eax),%eax
  80263b:	a3 30 50 80 00       	mov    %eax,0x805030
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 04             	mov    0x4(%eax),%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	74 0f                	je     802659 <alloc_block_BF+0x18f>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 04             	mov    0x4(%eax),%eax
  802650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802653:	8b 12                	mov    (%edx),%edx
  802655:	89 10                	mov    %edx,(%eax)
  802657:	eb 0a                	jmp    802663 <alloc_block_BF+0x199>
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802676:	a1 38 50 80 00       	mov    0x805038,%eax
  80267b:	48                   	dec    %eax
  80267c:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802681:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802684:	e9 24 04 00 00       	jmp    802aad <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802689:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80268f:	76 13                	jbe    8026a4 <alloc_block_BF+0x1da>
					{
						internal = 1;
  802691:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  802698:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80269b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  80269e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026a1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8026a4:	a1 34 50 80 00       	mov    0x805034,%eax
  8026a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b0:	74 07                	je     8026b9 <alloc_block_BF+0x1ef>
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 00                	mov    (%eax),%eax
  8026b7:	eb 05                	jmp    8026be <alloc_block_BF+0x1f4>
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026be:	a3 34 50 80 00       	mov    %eax,0x805034
  8026c3:	a1 34 50 80 00       	mov    0x805034,%eax
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	0f 85 bf fe ff ff    	jne    80258f <alloc_block_BF+0xc5>
  8026d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d4:	0f 85 b5 fe ff ff    	jne    80258f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8026da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026de:	0f 84 26 02 00 00    	je     80290a <alloc_block_BF+0x440>
  8026e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026e8:	0f 85 1c 02 00 00    	jne    80290a <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8026ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8026f4:	83 e8 08             	sub    $0x8,%eax
  8026f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	8d 50 08             	lea    0x8(%eax),%edx
  802700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802703:	01 d0                	add    %edx,%eax
  802705:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	83 c0 08             	add    $0x8,%eax
  80270e:	83 ec 04             	sub    $0x4,%esp
  802711:	6a 01                	push   $0x1
  802713:	50                   	push   %eax
  802714:	ff 75 f0             	pushl  -0x10(%ebp)
  802717:	e8 c3 f8 ff ff       	call   801fdf <set_block_data>
  80271c:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802722:	8b 40 04             	mov    0x4(%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	75 68                	jne    802791 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802729:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80272d:	75 17                	jne    802746 <alloc_block_BF+0x27c>
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	68 60 42 80 00       	push   $0x804260
  802737:	68 45 01 00 00       	push   $0x145
  80273c:	68 45 42 80 00       	push   $0x804245
  802741:	e8 54 10 00 00       	call   80379a <_panic>
  802746:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80274c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80274f:	89 10                	mov    %edx,(%eax)
  802751:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802754:	8b 00                	mov    (%eax),%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	74 0d                	je     802767 <alloc_block_BF+0x29d>
  80275a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80275f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802762:	89 50 04             	mov    %edx,0x4(%eax)
  802765:	eb 08                	jmp    80276f <alloc_block_BF+0x2a5>
  802767:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80276a:	a3 30 50 80 00       	mov    %eax,0x805030
  80276f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802772:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802777:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80277a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802781:	a1 38 50 80 00       	mov    0x805038,%eax
  802786:	40                   	inc    %eax
  802787:	a3 38 50 80 00       	mov    %eax,0x805038
  80278c:	e9 dc 00 00 00       	jmp    80286d <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802794:	8b 00                	mov    (%eax),%eax
  802796:	85 c0                	test   %eax,%eax
  802798:	75 65                	jne    8027ff <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  80279a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80279e:	75 17                	jne    8027b7 <alloc_block_BF+0x2ed>
  8027a0:	83 ec 04             	sub    $0x4,%esp
  8027a3:	68 94 42 80 00       	push   $0x804294
  8027a8:	68 4a 01 00 00       	push   $0x14a
  8027ad:	68 45 42 80 00       	push   $0x804245
  8027b2:	e8 e3 0f 00 00       	call   80379a <_panic>
  8027b7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027c0:	89 50 04             	mov    %edx,0x4(%eax)
  8027c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027c6:	8b 40 04             	mov    0x4(%eax),%eax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	74 0c                	je     8027d9 <alloc_block_BF+0x30f>
  8027cd:	a1 30 50 80 00       	mov    0x805030,%eax
  8027d2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027d5:	89 10                	mov    %edx,(%eax)
  8027d7:	eb 08                	jmp    8027e1 <alloc_block_BF+0x317>
  8027d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027e1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027e4:	a3 30 50 80 00       	mov    %eax,0x805030
  8027e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f2:	a1 38 50 80 00       	mov    0x805038,%eax
  8027f7:	40                   	inc    %eax
  8027f8:	a3 38 50 80 00       	mov    %eax,0x805038
  8027fd:	eb 6e                	jmp    80286d <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  8027ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802803:	74 06                	je     80280b <alloc_block_BF+0x341>
  802805:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802809:	75 17                	jne    802822 <alloc_block_BF+0x358>
  80280b:	83 ec 04             	sub    $0x4,%esp
  80280e:	68 b8 42 80 00       	push   $0x8042b8
  802813:	68 4f 01 00 00       	push   $0x14f
  802818:	68 45 42 80 00       	push   $0x804245
  80281d:	e8 78 0f 00 00       	call   80379a <_panic>
  802822:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802825:	8b 10                	mov    (%eax),%edx
  802827:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80282a:	89 10                	mov    %edx,(%eax)
  80282c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	74 0b                	je     802840 <alloc_block_BF+0x376>
  802835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802838:	8b 00                	mov    (%eax),%eax
  80283a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80283d:	89 50 04             	mov    %edx,0x4(%eax)
  802840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802843:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802846:	89 10                	mov    %edx,(%eax)
  802848:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80284b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284e:	89 50 04             	mov    %edx,0x4(%eax)
  802851:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	85 c0                	test   %eax,%eax
  802858:	75 08                	jne    802862 <alloc_block_BF+0x398>
  80285a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285d:	a3 30 50 80 00       	mov    %eax,0x805030
  802862:	a1 38 50 80 00       	mov    0x805038,%eax
  802867:	40                   	inc    %eax
  802868:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80286d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802871:	75 17                	jne    80288a <alloc_block_BF+0x3c0>
  802873:	83 ec 04             	sub    $0x4,%esp
  802876:	68 27 42 80 00       	push   $0x804227
  80287b:	68 51 01 00 00       	push   $0x151
  802880:	68 45 42 80 00       	push   $0x804245
  802885:	e8 10 0f 00 00       	call   80379a <_panic>
  80288a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288d:	8b 00                	mov    (%eax),%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	74 10                	je     8028a3 <alloc_block_BF+0x3d9>
  802893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802896:	8b 00                	mov    (%eax),%eax
  802898:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80289b:	8b 52 04             	mov    0x4(%edx),%edx
  80289e:	89 50 04             	mov    %edx,0x4(%eax)
  8028a1:	eb 0b                	jmp    8028ae <alloc_block_BF+0x3e4>
  8028a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a6:	8b 40 04             	mov    0x4(%eax),%eax
  8028a9:	a3 30 50 80 00       	mov    %eax,0x805030
  8028ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b1:	8b 40 04             	mov    0x4(%eax),%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	74 0f                	je     8028c7 <alloc_block_BF+0x3fd>
  8028b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c1:	8b 12                	mov    (%edx),%edx
  8028c3:	89 10                	mov    %edx,(%eax)
  8028c5:	eb 0a                	jmp    8028d1 <alloc_block_BF+0x407>
  8028c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e4:	a1 38 50 80 00       	mov    0x805038,%eax
  8028e9:	48                   	dec    %eax
  8028ea:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8028ef:	83 ec 04             	sub    $0x4,%esp
  8028f2:	6a 00                	push   $0x0
  8028f4:	ff 75 d0             	pushl  -0x30(%ebp)
  8028f7:	ff 75 cc             	pushl  -0x34(%ebp)
  8028fa:	e8 e0 f6 ff ff       	call   801fdf <set_block_data>
  8028ff:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	e9 a3 01 00 00       	jmp    802aad <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80290a:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80290e:	0f 85 9d 00 00 00    	jne    8029b1 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802914:	83 ec 04             	sub    $0x4,%esp
  802917:	6a 01                	push   $0x1
  802919:	ff 75 ec             	pushl  -0x14(%ebp)
  80291c:	ff 75 f0             	pushl  -0x10(%ebp)
  80291f:	e8 bb f6 ff ff       	call   801fdf <set_block_data>
  802924:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802927:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80292b:	75 17                	jne    802944 <alloc_block_BF+0x47a>
  80292d:	83 ec 04             	sub    $0x4,%esp
  802930:	68 27 42 80 00       	push   $0x804227
  802935:	68 58 01 00 00       	push   $0x158
  80293a:	68 45 42 80 00       	push   $0x804245
  80293f:	e8 56 0e 00 00       	call   80379a <_panic>
  802944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802947:	8b 00                	mov    (%eax),%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	74 10                	je     80295d <alloc_block_BF+0x493>
  80294d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802955:	8b 52 04             	mov    0x4(%edx),%edx
  802958:	89 50 04             	mov    %edx,0x4(%eax)
  80295b:	eb 0b                	jmp    802968 <alloc_block_BF+0x49e>
  80295d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802960:	8b 40 04             	mov    0x4(%eax),%eax
  802963:	a3 30 50 80 00       	mov    %eax,0x805030
  802968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296b:	8b 40 04             	mov    0x4(%eax),%eax
  80296e:	85 c0                	test   %eax,%eax
  802970:	74 0f                	je     802981 <alloc_block_BF+0x4b7>
  802972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297b:	8b 12                	mov    (%edx),%edx
  80297d:	89 10                	mov    %edx,(%eax)
  80297f:	eb 0a                	jmp    80298b <alloc_block_BF+0x4c1>
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802997:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299e:	a1 38 50 80 00       	mov    0x805038,%eax
  8029a3:	48                   	dec    %eax
  8029a4:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	e9 fc 00 00 00       	jmp    802aad <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	83 c0 08             	add    $0x8,%eax
  8029b7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8029ba:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8029c1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029c7:	01 d0                	add    %edx,%eax
  8029c9:	48                   	dec    %eax
  8029ca:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8029cd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8029d5:	f7 75 c4             	divl   -0x3c(%ebp)
  8029d8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029db:	29 d0                	sub    %edx,%eax
  8029dd:	c1 e8 0c             	shr    $0xc,%eax
  8029e0:	83 ec 0c             	sub    $0xc,%esp
  8029e3:	50                   	push   %eax
  8029e4:	e8 b4 e7 ff ff       	call   80119d <sbrk>
  8029e9:	83 c4 10             	add    $0x10,%esp
  8029ec:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8029ef:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  8029f3:	75 0a                	jne    8029ff <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  8029f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fa:	e9 ae 00 00 00       	jmp    802aad <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  8029ff:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802a06:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a09:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a0c:	01 d0                	add    %edx,%eax
  802a0e:	48                   	dec    %eax
  802a0f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802a12:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a15:	ba 00 00 00 00       	mov    $0x0,%edx
  802a1a:	f7 75 b8             	divl   -0x48(%ebp)
  802a1d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a20:	29 d0                	sub    %edx,%eax
  802a22:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a25:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a28:	01 d0                	add    %edx,%eax
  802a2a:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802a2f:	a1 40 50 80 00       	mov    0x805040,%eax
  802a34:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802a3a:	83 ec 0c             	sub    $0xc,%esp
  802a3d:	68 ec 42 80 00       	push   $0x8042ec
  802a42:	e8 bc d9 ff ff       	call   800403 <cprintf>
  802a47:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802a4a:	83 ec 08             	sub    $0x8,%esp
  802a4d:	ff 75 bc             	pushl  -0x44(%ebp)
  802a50:	68 f1 42 80 00       	push   $0x8042f1
  802a55:	e8 a9 d9 ff ff       	call   800403 <cprintf>
  802a5a:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a5d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a64:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a67:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a6a:	01 d0                	add    %edx,%eax
  802a6c:	48                   	dec    %eax
  802a6d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a70:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a73:	ba 00 00 00 00       	mov    $0x0,%edx
  802a78:	f7 75 b0             	divl   -0x50(%ebp)
  802a7b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a7e:	29 d0                	sub    %edx,%eax
  802a80:	83 ec 04             	sub    $0x4,%esp
  802a83:	6a 01                	push   $0x1
  802a85:	50                   	push   %eax
  802a86:	ff 75 bc             	pushl  -0x44(%ebp)
  802a89:	e8 51 f5 ff ff       	call   801fdf <set_block_data>
  802a8e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802a91:	83 ec 0c             	sub    $0xc,%esp
  802a94:	ff 75 bc             	pushl  -0x44(%ebp)
  802a97:	e8 36 04 00 00       	call   802ed2 <free_block>
  802a9c:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802a9f:	83 ec 0c             	sub    $0xc,%esp
  802aa2:	ff 75 08             	pushl  0x8(%ebp)
  802aa5:	e8 20 fa ff ff       	call   8024ca <alloc_block_BF>
  802aaa:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802aad:	c9                   	leave  
  802aae:	c3                   	ret    

00802aaf <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802aaf:	55                   	push   %ebp
  802ab0:	89 e5                	mov    %esp,%ebp
  802ab2:	53                   	push   %ebx
  802ab3:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ab6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802abd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ac4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac8:	74 1e                	je     802ae8 <merging+0x39>
  802aca:	ff 75 08             	pushl  0x8(%ebp)
  802acd:	e8 bc f1 ff ff       	call   801c8e <get_block_size>
  802ad2:	83 c4 04             	add    $0x4,%esp
  802ad5:	89 c2                	mov    %eax,%edx
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	01 d0                	add    %edx,%eax
  802adc:	3b 45 10             	cmp    0x10(%ebp),%eax
  802adf:	75 07                	jne    802ae8 <merging+0x39>
		prev_is_free = 1;
  802ae1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802ae8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802aec:	74 1e                	je     802b0c <merging+0x5d>
  802aee:	ff 75 10             	pushl  0x10(%ebp)
  802af1:	e8 98 f1 ff ff       	call   801c8e <get_block_size>
  802af6:	83 c4 04             	add    $0x4,%esp
  802af9:	89 c2                	mov    %eax,%edx
  802afb:	8b 45 10             	mov    0x10(%ebp),%eax
  802afe:	01 d0                	add    %edx,%eax
  802b00:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b03:	75 07                	jne    802b0c <merging+0x5d>
		next_is_free = 1;
  802b05:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802b0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b10:	0f 84 cc 00 00 00    	je     802be2 <merging+0x133>
  802b16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b1a:	0f 84 c2 00 00 00    	je     802be2 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802b20:	ff 75 08             	pushl  0x8(%ebp)
  802b23:	e8 66 f1 ff ff       	call   801c8e <get_block_size>
  802b28:	83 c4 04             	add    $0x4,%esp
  802b2b:	89 c3                	mov    %eax,%ebx
  802b2d:	ff 75 10             	pushl  0x10(%ebp)
  802b30:	e8 59 f1 ff ff       	call   801c8e <get_block_size>
  802b35:	83 c4 04             	add    $0x4,%esp
  802b38:	01 c3                	add    %eax,%ebx
  802b3a:	ff 75 0c             	pushl  0xc(%ebp)
  802b3d:	e8 4c f1 ff ff       	call   801c8e <get_block_size>
  802b42:	83 c4 04             	add    $0x4,%esp
  802b45:	01 d8                	add    %ebx,%eax
  802b47:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b4a:	6a 00                	push   $0x0
  802b4c:	ff 75 ec             	pushl  -0x14(%ebp)
  802b4f:	ff 75 08             	pushl  0x8(%ebp)
  802b52:	e8 88 f4 ff ff       	call   801fdf <set_block_data>
  802b57:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802b5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b5e:	75 17                	jne    802b77 <merging+0xc8>
  802b60:	83 ec 04             	sub    $0x4,%esp
  802b63:	68 27 42 80 00       	push   $0x804227
  802b68:	68 7d 01 00 00       	push   $0x17d
  802b6d:	68 45 42 80 00       	push   $0x804245
  802b72:	e8 23 0c 00 00       	call   80379a <_panic>
  802b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	74 10                	je     802b90 <merging+0xe1>
  802b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b83:	8b 00                	mov    (%eax),%eax
  802b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b88:	8b 52 04             	mov    0x4(%edx),%edx
  802b8b:	89 50 04             	mov    %edx,0x4(%eax)
  802b8e:	eb 0b                	jmp    802b9b <merging+0xec>
  802b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b93:	8b 40 04             	mov    0x4(%eax),%eax
  802b96:	a3 30 50 80 00       	mov    %eax,0x805030
  802b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	74 0f                	je     802bb4 <merging+0x105>
  802ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba8:	8b 40 04             	mov    0x4(%eax),%eax
  802bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bae:	8b 12                	mov    (%edx),%edx
  802bb0:	89 10                	mov    %edx,(%eax)
  802bb2:	eb 0a                	jmp    802bbe <merging+0x10f>
  802bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd1:	a1 38 50 80 00       	mov    0x805038,%eax
  802bd6:	48                   	dec    %eax
  802bd7:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802bdc:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bdd:	e9 ea 02 00 00       	jmp    802ecc <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be6:	74 3b                	je     802c23 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802be8:	83 ec 0c             	sub    $0xc,%esp
  802beb:	ff 75 08             	pushl  0x8(%ebp)
  802bee:	e8 9b f0 ff ff       	call   801c8e <get_block_size>
  802bf3:	83 c4 10             	add    $0x10,%esp
  802bf6:	89 c3                	mov    %eax,%ebx
  802bf8:	83 ec 0c             	sub    $0xc,%esp
  802bfb:	ff 75 10             	pushl  0x10(%ebp)
  802bfe:	e8 8b f0 ff ff       	call   801c8e <get_block_size>
  802c03:	83 c4 10             	add    $0x10,%esp
  802c06:	01 d8                	add    %ebx,%eax
  802c08:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c0b:	83 ec 04             	sub    $0x4,%esp
  802c0e:	6a 00                	push   $0x0
  802c10:	ff 75 e8             	pushl  -0x18(%ebp)
  802c13:	ff 75 08             	pushl  0x8(%ebp)
  802c16:	e8 c4 f3 ff ff       	call   801fdf <set_block_data>
  802c1b:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c1e:	e9 a9 02 00 00       	jmp    802ecc <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802c23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c27:	0f 84 2d 01 00 00    	je     802d5a <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802c2d:	83 ec 0c             	sub    $0xc,%esp
  802c30:	ff 75 10             	pushl  0x10(%ebp)
  802c33:	e8 56 f0 ff ff       	call   801c8e <get_block_size>
  802c38:	83 c4 10             	add    $0x10,%esp
  802c3b:	89 c3                	mov    %eax,%ebx
  802c3d:	83 ec 0c             	sub    $0xc,%esp
  802c40:	ff 75 0c             	pushl  0xc(%ebp)
  802c43:	e8 46 f0 ff ff       	call   801c8e <get_block_size>
  802c48:	83 c4 10             	add    $0x10,%esp
  802c4b:	01 d8                	add    %ebx,%eax
  802c4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802c50:	83 ec 04             	sub    $0x4,%esp
  802c53:	6a 00                	push   $0x0
  802c55:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c58:	ff 75 10             	pushl  0x10(%ebp)
  802c5b:	e8 7f f3 ff ff       	call   801fdf <set_block_data>
  802c60:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c63:	8b 45 10             	mov    0x10(%ebp),%eax
  802c66:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c6d:	74 06                	je     802c75 <merging+0x1c6>
  802c6f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c73:	75 17                	jne    802c8c <merging+0x1dd>
  802c75:	83 ec 04             	sub    $0x4,%esp
  802c78:	68 00 43 80 00       	push   $0x804300
  802c7d:	68 8d 01 00 00       	push   $0x18d
  802c82:	68 45 42 80 00       	push   $0x804245
  802c87:	e8 0e 0b 00 00       	call   80379a <_panic>
  802c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8f:	8b 50 04             	mov    0x4(%eax),%edx
  802c92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c95:	89 50 04             	mov    %edx,0x4(%eax)
  802c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c9e:	89 10                	mov    %edx,(%eax)
  802ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca3:	8b 40 04             	mov    0x4(%eax),%eax
  802ca6:	85 c0                	test   %eax,%eax
  802ca8:	74 0d                	je     802cb7 <merging+0x208>
  802caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cad:	8b 40 04             	mov    0x4(%eax),%eax
  802cb0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cb3:	89 10                	mov    %edx,(%eax)
  802cb5:	eb 08                	jmp    802cbf <merging+0x210>
  802cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cba:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cc2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cc5:	89 50 04             	mov    %edx,0x4(%eax)
  802cc8:	a1 38 50 80 00       	mov    0x805038,%eax
  802ccd:	40                   	inc    %eax
  802cce:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802cd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cd7:	75 17                	jne    802cf0 <merging+0x241>
  802cd9:	83 ec 04             	sub    $0x4,%esp
  802cdc:	68 27 42 80 00       	push   $0x804227
  802ce1:	68 8e 01 00 00       	push   $0x18e
  802ce6:	68 45 42 80 00       	push   $0x804245
  802ceb:	e8 aa 0a 00 00       	call   80379a <_panic>
  802cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf3:	8b 00                	mov    (%eax),%eax
  802cf5:	85 c0                	test   %eax,%eax
  802cf7:	74 10                	je     802d09 <merging+0x25a>
  802cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cfc:	8b 00                	mov    (%eax),%eax
  802cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d01:	8b 52 04             	mov    0x4(%edx),%edx
  802d04:	89 50 04             	mov    %edx,0x4(%eax)
  802d07:	eb 0b                	jmp    802d14 <merging+0x265>
  802d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	a3 30 50 80 00       	mov    %eax,0x805030
  802d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d17:	8b 40 04             	mov    0x4(%eax),%eax
  802d1a:	85 c0                	test   %eax,%eax
  802d1c:	74 0f                	je     802d2d <merging+0x27e>
  802d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d21:	8b 40 04             	mov    0x4(%eax),%eax
  802d24:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d27:	8b 12                	mov    (%edx),%edx
  802d29:	89 10                	mov    %edx,(%eax)
  802d2b:	eb 0a                	jmp    802d37 <merging+0x288>
  802d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d30:	8b 00                	mov    (%eax),%eax
  802d32:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4a:	a1 38 50 80 00       	mov    0x805038,%eax
  802d4f:	48                   	dec    %eax
  802d50:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d55:	e9 72 01 00 00       	jmp    802ecc <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  802d5d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802d60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d64:	74 79                	je     802ddf <merging+0x330>
  802d66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d6a:	74 73                	je     802ddf <merging+0x330>
  802d6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d70:	74 06                	je     802d78 <merging+0x2c9>
  802d72:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d76:	75 17                	jne    802d8f <merging+0x2e0>
  802d78:	83 ec 04             	sub    $0x4,%esp
  802d7b:	68 b8 42 80 00       	push   $0x8042b8
  802d80:	68 94 01 00 00       	push   $0x194
  802d85:	68 45 42 80 00       	push   $0x804245
  802d8a:	e8 0b 0a 00 00       	call   80379a <_panic>
  802d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d92:	8b 10                	mov    (%eax),%edx
  802d94:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d97:	89 10                	mov    %edx,(%eax)
  802d99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d9c:	8b 00                	mov    (%eax),%eax
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	74 0b                	je     802dad <merging+0x2fe>
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802daa:	89 50 04             	mov    %edx,0x4(%eax)
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802db3:	89 10                	mov    %edx,(%eax)
  802db5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802db8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbb:	89 50 04             	mov    %edx,0x4(%eax)
  802dbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	85 c0                	test   %eax,%eax
  802dc5:	75 08                	jne    802dcf <merging+0x320>
  802dc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dca:	a3 30 50 80 00       	mov    %eax,0x805030
  802dcf:	a1 38 50 80 00       	mov    0x805038,%eax
  802dd4:	40                   	inc    %eax
  802dd5:	a3 38 50 80 00       	mov    %eax,0x805038
  802dda:	e9 ce 00 00 00       	jmp    802ead <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802ddf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de3:	74 65                	je     802e4a <merging+0x39b>
  802de5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802de9:	75 17                	jne    802e02 <merging+0x353>
  802deb:	83 ec 04             	sub    $0x4,%esp
  802dee:	68 94 42 80 00       	push   $0x804294
  802df3:	68 95 01 00 00       	push   $0x195
  802df8:	68 45 42 80 00       	push   $0x804245
  802dfd:	e8 98 09 00 00       	call   80379a <_panic>
  802e02:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e0b:	89 50 04             	mov    %edx,0x4(%eax)
  802e0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 0c                	je     802e24 <merging+0x375>
  802e18:	a1 30 50 80 00       	mov    0x805030,%eax
  802e1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e20:	89 10                	mov    %edx,(%eax)
  802e22:	eb 08                	jmp    802e2c <merging+0x37d>
  802e24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e27:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e2f:	a3 30 50 80 00       	mov    %eax,0x805030
  802e34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3d:	a1 38 50 80 00       	mov    0x805038,%eax
  802e42:	40                   	inc    %eax
  802e43:	a3 38 50 80 00       	mov    %eax,0x805038
  802e48:	eb 63                	jmp    802ead <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802e4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e4e:	75 17                	jne    802e67 <merging+0x3b8>
  802e50:	83 ec 04             	sub    $0x4,%esp
  802e53:	68 60 42 80 00       	push   $0x804260
  802e58:	68 98 01 00 00       	push   $0x198
  802e5d:	68 45 42 80 00       	push   $0x804245
  802e62:	e8 33 09 00 00       	call   80379a <_panic>
  802e67:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e70:	89 10                	mov    %edx,(%eax)
  802e72:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e75:	8b 00                	mov    (%eax),%eax
  802e77:	85 c0                	test   %eax,%eax
  802e79:	74 0d                	je     802e88 <merging+0x3d9>
  802e7b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e80:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e83:	89 50 04             	mov    %edx,0x4(%eax)
  802e86:	eb 08                	jmp    802e90 <merging+0x3e1>
  802e88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e8b:	a3 30 50 80 00       	mov    %eax,0x805030
  802e90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e93:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea2:	a1 38 50 80 00       	mov    0x805038,%eax
  802ea7:	40                   	inc    %eax
  802ea8:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802ead:	83 ec 0c             	sub    $0xc,%esp
  802eb0:	ff 75 10             	pushl  0x10(%ebp)
  802eb3:	e8 d6 ed ff ff       	call   801c8e <get_block_size>
  802eb8:	83 c4 10             	add    $0x10,%esp
  802ebb:	83 ec 04             	sub    $0x4,%esp
  802ebe:	6a 00                	push   $0x0
  802ec0:	50                   	push   %eax
  802ec1:	ff 75 10             	pushl  0x10(%ebp)
  802ec4:	e8 16 f1 ff ff       	call   801fdf <set_block_data>
  802ec9:	83 c4 10             	add    $0x10,%esp
	}
}
  802ecc:	90                   	nop
  802ecd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ed0:	c9                   	leave  
  802ed1:	c3                   	ret    

00802ed2 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802ed2:	55                   	push   %ebp
  802ed3:	89 e5                	mov    %esp,%ebp
  802ed5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802ed8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802edd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802ee0:	a1 30 50 80 00       	mov    0x805030,%eax
  802ee5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee8:	73 1b                	jae    802f05 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802eea:	a1 30 50 80 00       	mov    0x805030,%eax
  802eef:	83 ec 04             	sub    $0x4,%esp
  802ef2:	ff 75 08             	pushl  0x8(%ebp)
  802ef5:	6a 00                	push   $0x0
  802ef7:	50                   	push   %eax
  802ef8:	e8 b2 fb ff ff       	call   802aaf <merging>
  802efd:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f00:	e9 8b 00 00 00       	jmp    802f90 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802f05:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f0a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f0d:	76 18                	jbe    802f27 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802f0f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f14:	83 ec 04             	sub    $0x4,%esp
  802f17:	ff 75 08             	pushl  0x8(%ebp)
  802f1a:	50                   	push   %eax
  802f1b:	6a 00                	push   $0x0
  802f1d:	e8 8d fb ff ff       	call   802aaf <merging>
  802f22:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f25:	eb 69                	jmp    802f90 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f27:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2f:	eb 39                	jmp    802f6a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f37:	73 29                	jae    802f62 <free_block+0x90>
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 00                	mov    (%eax),%eax
  802f3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f41:	76 1f                	jbe    802f62 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802f4b:	83 ec 04             	sub    $0x4,%esp
  802f4e:	ff 75 08             	pushl  0x8(%ebp)
  802f51:	ff 75 f0             	pushl  -0x10(%ebp)
  802f54:	ff 75 f4             	pushl  -0xc(%ebp)
  802f57:	e8 53 fb ff ff       	call   802aaf <merging>
  802f5c:	83 c4 10             	add    $0x10,%esp
			break;
  802f5f:	90                   	nop
		}
	}
}
  802f60:	eb 2e                	jmp    802f90 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f62:	a1 34 50 80 00       	mov    0x805034,%eax
  802f67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6e:	74 07                	je     802f77 <free_block+0xa5>
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	eb 05                	jmp    802f7c <free_block+0xaa>
  802f77:	b8 00 00 00 00       	mov    $0x0,%eax
  802f7c:	a3 34 50 80 00       	mov    %eax,0x805034
  802f81:	a1 34 50 80 00       	mov    0x805034,%eax
  802f86:	85 c0                	test   %eax,%eax
  802f88:	75 a7                	jne    802f31 <free_block+0x5f>
  802f8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8e:	75 a1                	jne    802f31 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f90:	90                   	nop
  802f91:	c9                   	leave  
  802f92:	c3                   	ret    

00802f93 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802f93:	55                   	push   %ebp
  802f94:	89 e5                	mov    %esp,%ebp
  802f96:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802f99:	ff 75 08             	pushl  0x8(%ebp)
  802f9c:	e8 ed ec ff ff       	call   801c8e <get_block_size>
  802fa1:	83 c4 04             	add    $0x4,%esp
  802fa4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802fa7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802fae:	eb 17                	jmp    802fc7 <copy_data+0x34>
  802fb0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb6:	01 c2                	add    %eax,%edx
  802fb8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	01 c8                	add    %ecx,%eax
  802fc0:	8a 00                	mov    (%eax),%al
  802fc2:	88 02                	mov    %al,(%edx)
  802fc4:	ff 45 fc             	incl   -0x4(%ebp)
  802fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802fcd:	72 e1                	jb     802fb0 <copy_data+0x1d>
}
  802fcf:	90                   	nop
  802fd0:	c9                   	leave  
  802fd1:	c3                   	ret    

00802fd2 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802fd2:	55                   	push   %ebp
  802fd3:	89 e5                	mov    %esp,%ebp
  802fd5:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802fd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fdc:	75 23                	jne    803001 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802fde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fe2:	74 13                	je     802ff7 <realloc_block_FF+0x25>
  802fe4:	83 ec 0c             	sub    $0xc,%esp
  802fe7:	ff 75 0c             	pushl  0xc(%ebp)
  802fea:	e8 1f f0 ff ff       	call   80200e <alloc_block_FF>
  802fef:	83 c4 10             	add    $0x10,%esp
  802ff2:	e9 f4 06 00 00       	jmp    8036eb <realloc_block_FF+0x719>
		return NULL;
  802ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffc:	e9 ea 06 00 00       	jmp    8036eb <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803001:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803005:	75 18                	jne    80301f <realloc_block_FF+0x4d>
	{
		free_block(va);
  803007:	83 ec 0c             	sub    $0xc,%esp
  80300a:	ff 75 08             	pushl  0x8(%ebp)
  80300d:	e8 c0 fe ff ff       	call   802ed2 <free_block>
  803012:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803015:	b8 00 00 00 00       	mov    $0x0,%eax
  80301a:	e9 cc 06 00 00       	jmp    8036eb <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80301f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803023:	77 07                	ja     80302c <realloc_block_FF+0x5a>
  803025:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80302c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80302f:	83 e0 01             	and    $0x1,%eax
  803032:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803035:	8b 45 0c             	mov    0xc(%ebp),%eax
  803038:	83 c0 08             	add    $0x8,%eax
  80303b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80303e:	83 ec 0c             	sub    $0xc,%esp
  803041:	ff 75 08             	pushl  0x8(%ebp)
  803044:	e8 45 ec ff ff       	call   801c8e <get_block_size>
  803049:	83 c4 10             	add    $0x10,%esp
  80304c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80304f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803052:	83 e8 08             	sub    $0x8,%eax
  803055:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	83 e8 04             	sub    $0x4,%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	83 e0 fe             	and    $0xfffffffe,%eax
  803063:	89 c2                	mov    %eax,%edx
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	01 d0                	add    %edx,%eax
  80306a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80306d:	83 ec 0c             	sub    $0xc,%esp
  803070:	ff 75 e4             	pushl  -0x1c(%ebp)
  803073:	e8 16 ec ff ff       	call   801c8e <get_block_size>
  803078:	83 c4 10             	add    $0x10,%esp
  80307b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80307e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803081:	83 e8 08             	sub    $0x8,%eax
  803084:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80308a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80308d:	75 08                	jne    803097 <realloc_block_FF+0xc5>
	{
		 return va;
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	e9 54 06 00 00       	jmp    8036eb <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  803097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80309d:	0f 83 e5 03 00 00    	jae    803488 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8030a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a6:	2b 45 0c             	sub    0xc(%ebp),%eax
  8030a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8030ac:	83 ec 0c             	sub    $0xc,%esp
  8030af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030b2:	e8 f0 eb ff ff       	call   801ca7 <is_free_block>
  8030b7:	83 c4 10             	add    $0x10,%esp
  8030ba:	84 c0                	test   %al,%al
  8030bc:	0f 84 3b 01 00 00    	je     8031fd <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8030c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030c8:	01 d0                	add    %edx,%eax
  8030ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8030cd:	83 ec 04             	sub    $0x4,%esp
  8030d0:	6a 01                	push   $0x1
  8030d2:	ff 75 f0             	pushl  -0x10(%ebp)
  8030d5:	ff 75 08             	pushl  0x8(%ebp)
  8030d8:	e8 02 ef ff ff       	call   801fdf <set_block_data>
  8030dd:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	83 e8 04             	sub    $0x4,%eax
  8030e6:	8b 00                	mov    (%eax),%eax
  8030e8:	83 e0 fe             	and    $0xfffffffe,%eax
  8030eb:	89 c2                	mov    %eax,%edx
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	01 d0                	add    %edx,%eax
  8030f2:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8030f5:	83 ec 04             	sub    $0x4,%esp
  8030f8:	6a 00                	push   $0x0
  8030fa:	ff 75 cc             	pushl  -0x34(%ebp)
  8030fd:	ff 75 c8             	pushl  -0x38(%ebp)
  803100:	e8 da ee ff ff       	call   801fdf <set_block_data>
  803105:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803108:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80310c:	74 06                	je     803114 <realloc_block_FF+0x142>
  80310e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803112:	75 17                	jne    80312b <realloc_block_FF+0x159>
  803114:	83 ec 04             	sub    $0x4,%esp
  803117:	68 b8 42 80 00       	push   $0x8042b8
  80311c:	68 f6 01 00 00       	push   $0x1f6
  803121:	68 45 42 80 00       	push   $0x804245
  803126:	e8 6f 06 00 00       	call   80379a <_panic>
  80312b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312e:	8b 10                	mov    (%eax),%edx
  803130:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803133:	89 10                	mov    %edx,(%eax)
  803135:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803138:	8b 00                	mov    (%eax),%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 0b                	je     803149 <realloc_block_FF+0x177>
  80313e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803141:	8b 00                	mov    (%eax),%eax
  803143:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803146:	89 50 04             	mov    %edx,0x4(%eax)
  803149:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80314f:	89 10                	mov    %edx,(%eax)
  803151:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803154:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803157:	89 50 04             	mov    %edx,0x4(%eax)
  80315a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	85 c0                	test   %eax,%eax
  803161:	75 08                	jne    80316b <realloc_block_FF+0x199>
  803163:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803166:	a3 30 50 80 00       	mov    %eax,0x805030
  80316b:	a1 38 50 80 00       	mov    0x805038,%eax
  803170:	40                   	inc    %eax
  803171:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803176:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80317a:	75 17                	jne    803193 <realloc_block_FF+0x1c1>
  80317c:	83 ec 04             	sub    $0x4,%esp
  80317f:	68 27 42 80 00       	push   $0x804227
  803184:	68 f7 01 00 00       	push   $0x1f7
  803189:	68 45 42 80 00       	push   $0x804245
  80318e:	e8 07 06 00 00       	call   80379a <_panic>
  803193:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803196:	8b 00                	mov    (%eax),%eax
  803198:	85 c0                	test   %eax,%eax
  80319a:	74 10                	je     8031ac <realloc_block_FF+0x1da>
  80319c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319f:	8b 00                	mov    (%eax),%eax
  8031a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031a4:	8b 52 04             	mov    0x4(%edx),%edx
  8031a7:	89 50 04             	mov    %edx,0x4(%eax)
  8031aa:	eb 0b                	jmp    8031b7 <realloc_block_FF+0x1e5>
  8031ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031af:	8b 40 04             	mov    0x4(%eax),%eax
  8031b2:	a3 30 50 80 00       	mov    %eax,0x805030
  8031b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ba:	8b 40 04             	mov    0x4(%eax),%eax
  8031bd:	85 c0                	test   %eax,%eax
  8031bf:	74 0f                	je     8031d0 <realloc_block_FF+0x1fe>
  8031c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c4:	8b 40 04             	mov    0x4(%eax),%eax
  8031c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031ca:	8b 12                	mov    (%edx),%edx
  8031cc:	89 10                	mov    %edx,(%eax)
  8031ce:	eb 0a                	jmp    8031da <realloc_block_FF+0x208>
  8031d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d3:	8b 00                	mov    (%eax),%eax
  8031d5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ed:	a1 38 50 80 00       	mov    0x805038,%eax
  8031f2:	48                   	dec    %eax
  8031f3:	a3 38 50 80 00       	mov    %eax,0x805038
  8031f8:	e9 83 02 00 00       	jmp    803480 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  8031fd:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803201:	0f 86 69 02 00 00    	jbe    803470 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803207:	83 ec 04             	sub    $0x4,%esp
  80320a:	6a 01                	push   $0x1
  80320c:	ff 75 f0             	pushl  -0x10(%ebp)
  80320f:	ff 75 08             	pushl  0x8(%ebp)
  803212:	e8 c8 ed ff ff       	call   801fdf <set_block_data>
  803217:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80321a:	8b 45 08             	mov    0x8(%ebp),%eax
  80321d:	83 e8 04             	sub    $0x4,%eax
  803220:	8b 00                	mov    (%eax),%eax
  803222:	83 e0 fe             	and    $0xfffffffe,%eax
  803225:	89 c2                	mov    %eax,%edx
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	01 d0                	add    %edx,%eax
  80322c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80322f:	a1 38 50 80 00       	mov    0x805038,%eax
  803234:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803237:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80323b:	75 68                	jne    8032a5 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80323d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803241:	75 17                	jne    80325a <realloc_block_FF+0x288>
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	68 60 42 80 00       	push   $0x804260
  80324b:	68 06 02 00 00       	push   $0x206
  803250:	68 45 42 80 00       	push   $0x804245
  803255:	e8 40 05 00 00       	call   80379a <_panic>
  80325a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803260:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803263:	89 10                	mov    %edx,(%eax)
  803265:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	74 0d                	je     80327b <realloc_block_FF+0x2a9>
  80326e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803273:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803276:	89 50 04             	mov    %edx,0x4(%eax)
  803279:	eb 08                	jmp    803283 <realloc_block_FF+0x2b1>
  80327b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80327e:	a3 30 50 80 00       	mov    %eax,0x805030
  803283:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803286:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80328b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80328e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803295:	a1 38 50 80 00       	mov    0x805038,%eax
  80329a:	40                   	inc    %eax
  80329b:	a3 38 50 80 00       	mov    %eax,0x805038
  8032a0:	e9 b0 01 00 00       	jmp    803455 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8032a5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032ad:	76 68                	jbe    803317 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032af:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032b3:	75 17                	jne    8032cc <realloc_block_FF+0x2fa>
  8032b5:	83 ec 04             	sub    $0x4,%esp
  8032b8:	68 60 42 80 00       	push   $0x804260
  8032bd:	68 0b 02 00 00       	push   $0x20b
  8032c2:	68 45 42 80 00       	push   $0x804245
  8032c7:	e8 ce 04 00 00       	call   80379a <_panic>
  8032cc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d5:	89 10                	mov    %edx,(%eax)
  8032d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032da:	8b 00                	mov    (%eax),%eax
  8032dc:	85 c0                	test   %eax,%eax
  8032de:	74 0d                	je     8032ed <realloc_block_FF+0x31b>
  8032e0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032e8:	89 50 04             	mov    %edx,0x4(%eax)
  8032eb:	eb 08                	jmp    8032f5 <realloc_block_FF+0x323>
  8032ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f0:	a3 30 50 80 00       	mov    %eax,0x805030
  8032f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803300:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803307:	a1 38 50 80 00       	mov    0x805038,%eax
  80330c:	40                   	inc    %eax
  80330d:	a3 38 50 80 00       	mov    %eax,0x805038
  803312:	e9 3e 01 00 00       	jmp    803455 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803317:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80331c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80331f:	73 68                	jae    803389 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803321:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803325:	75 17                	jne    80333e <realloc_block_FF+0x36c>
  803327:	83 ec 04             	sub    $0x4,%esp
  80332a:	68 94 42 80 00       	push   $0x804294
  80332f:	68 10 02 00 00       	push   $0x210
  803334:	68 45 42 80 00       	push   $0x804245
  803339:	e8 5c 04 00 00       	call   80379a <_panic>
  80333e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803344:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803347:	89 50 04             	mov    %edx,0x4(%eax)
  80334a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334d:	8b 40 04             	mov    0x4(%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 0c                	je     803360 <realloc_block_FF+0x38e>
  803354:	a1 30 50 80 00       	mov    0x805030,%eax
  803359:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80335c:	89 10                	mov    %edx,(%eax)
  80335e:	eb 08                	jmp    803368 <realloc_block_FF+0x396>
  803360:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803363:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803368:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336b:	a3 30 50 80 00       	mov    %eax,0x805030
  803370:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803373:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803379:	a1 38 50 80 00       	mov    0x805038,%eax
  80337e:	40                   	inc    %eax
  80337f:	a3 38 50 80 00       	mov    %eax,0x805038
  803384:	e9 cc 00 00 00       	jmp    803455 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803389:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803390:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803395:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803398:	e9 8a 00 00 00       	jmp    803427 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  80339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033a3:	73 7a                	jae    80341f <realloc_block_FF+0x44d>
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	8b 00                	mov    (%eax),%eax
  8033aa:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033ad:	73 70                	jae    80341f <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8033af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b3:	74 06                	je     8033bb <realloc_block_FF+0x3e9>
  8033b5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033b9:	75 17                	jne    8033d2 <realloc_block_FF+0x400>
  8033bb:	83 ec 04             	sub    $0x4,%esp
  8033be:	68 b8 42 80 00       	push   $0x8042b8
  8033c3:	68 1a 02 00 00       	push   $0x21a
  8033c8:	68 45 42 80 00       	push   $0x804245
  8033cd:	e8 c8 03 00 00       	call   80379a <_panic>
  8033d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d5:	8b 10                	mov    (%eax),%edx
  8033d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033da:	89 10                	mov    %edx,(%eax)
  8033dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033df:	8b 00                	mov    (%eax),%eax
  8033e1:	85 c0                	test   %eax,%eax
  8033e3:	74 0b                	je     8033f0 <realloc_block_FF+0x41e>
  8033e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e8:	8b 00                	mov    (%eax),%eax
  8033ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033ed:	89 50 04             	mov    %edx,0x4(%eax)
  8033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033f6:	89 10                	mov    %edx,(%eax)
  8033f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033fe:	89 50 04             	mov    %edx,0x4(%eax)
  803401:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803404:	8b 00                	mov    (%eax),%eax
  803406:	85 c0                	test   %eax,%eax
  803408:	75 08                	jne    803412 <realloc_block_FF+0x440>
  80340a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340d:	a3 30 50 80 00       	mov    %eax,0x805030
  803412:	a1 38 50 80 00       	mov    0x805038,%eax
  803417:	40                   	inc    %eax
  803418:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80341d:	eb 36                	jmp    803455 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80341f:	a1 34 50 80 00       	mov    0x805034,%eax
  803424:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80342b:	74 07                	je     803434 <realloc_block_FF+0x462>
  80342d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803430:	8b 00                	mov    (%eax),%eax
  803432:	eb 05                	jmp    803439 <realloc_block_FF+0x467>
  803434:	b8 00 00 00 00       	mov    $0x0,%eax
  803439:	a3 34 50 80 00       	mov    %eax,0x805034
  80343e:	a1 34 50 80 00       	mov    0x805034,%eax
  803443:	85 c0                	test   %eax,%eax
  803445:	0f 85 52 ff ff ff    	jne    80339d <realloc_block_FF+0x3cb>
  80344b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344f:	0f 85 48 ff ff ff    	jne    80339d <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803455:	83 ec 04             	sub    $0x4,%esp
  803458:	6a 00                	push   $0x0
  80345a:	ff 75 d8             	pushl  -0x28(%ebp)
  80345d:	ff 75 d4             	pushl  -0x2c(%ebp)
  803460:	e8 7a eb ff ff       	call   801fdf <set_block_data>
  803465:	83 c4 10             	add    $0x10,%esp
				return va;
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	e9 7b 02 00 00       	jmp    8036eb <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803470:	83 ec 0c             	sub    $0xc,%esp
  803473:	68 35 43 80 00       	push   $0x804335
  803478:	e8 86 cf ff ff       	call   800403 <cprintf>
  80347d:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	e9 63 02 00 00       	jmp    8036eb <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80348e:	0f 86 4d 02 00 00    	jbe    8036e1 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  803494:	83 ec 0c             	sub    $0xc,%esp
  803497:	ff 75 e4             	pushl  -0x1c(%ebp)
  80349a:	e8 08 e8 ff ff       	call   801ca7 <is_free_block>
  80349f:	83 c4 10             	add    $0x10,%esp
  8034a2:	84 c0                	test   %al,%al
  8034a4:	0f 84 37 02 00 00    	je     8036e1 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8034aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ad:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8034b0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8034b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034b6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034b9:	76 38                	jbe    8034f3 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8034bb:	83 ec 0c             	sub    $0xc,%esp
  8034be:	ff 75 08             	pushl  0x8(%ebp)
  8034c1:	e8 0c fa ff ff       	call   802ed2 <free_block>
  8034c6:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8034c9:	83 ec 0c             	sub    $0xc,%esp
  8034cc:	ff 75 0c             	pushl  0xc(%ebp)
  8034cf:	e8 3a eb ff ff       	call   80200e <alloc_block_FF>
  8034d4:	83 c4 10             	add    $0x10,%esp
  8034d7:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8034da:	83 ec 08             	sub    $0x8,%esp
  8034dd:	ff 75 c0             	pushl  -0x40(%ebp)
  8034e0:	ff 75 08             	pushl  0x8(%ebp)
  8034e3:	e8 ab fa ff ff       	call   802f93 <copy_data>
  8034e8:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8034eb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034ee:	e9 f8 01 00 00       	jmp    8036eb <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8034f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034f6:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8034f9:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8034fc:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803500:	0f 87 a0 00 00 00    	ja     8035a6 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803506:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80350a:	75 17                	jne    803523 <realloc_block_FF+0x551>
  80350c:	83 ec 04             	sub    $0x4,%esp
  80350f:	68 27 42 80 00       	push   $0x804227
  803514:	68 38 02 00 00       	push   $0x238
  803519:	68 45 42 80 00       	push   $0x804245
  80351e:	e8 77 02 00 00       	call   80379a <_panic>
  803523:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803526:	8b 00                	mov    (%eax),%eax
  803528:	85 c0                	test   %eax,%eax
  80352a:	74 10                	je     80353c <realloc_block_FF+0x56a>
  80352c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352f:	8b 00                	mov    (%eax),%eax
  803531:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803534:	8b 52 04             	mov    0x4(%edx),%edx
  803537:	89 50 04             	mov    %edx,0x4(%eax)
  80353a:	eb 0b                	jmp    803547 <realloc_block_FF+0x575>
  80353c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353f:	8b 40 04             	mov    0x4(%eax),%eax
  803542:	a3 30 50 80 00       	mov    %eax,0x805030
  803547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354a:	8b 40 04             	mov    0x4(%eax),%eax
  80354d:	85 c0                	test   %eax,%eax
  80354f:	74 0f                	je     803560 <realloc_block_FF+0x58e>
  803551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803554:	8b 40 04             	mov    0x4(%eax),%eax
  803557:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80355a:	8b 12                	mov    (%edx),%edx
  80355c:	89 10                	mov    %edx,(%eax)
  80355e:	eb 0a                	jmp    80356a <realloc_block_FF+0x598>
  803560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803563:	8b 00                	mov    (%eax),%eax
  803565:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80356a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803576:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357d:	a1 38 50 80 00       	mov    0x805038,%eax
  803582:	48                   	dec    %eax
  803583:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803588:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80358b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80358e:	01 d0                	add    %edx,%eax
  803590:	83 ec 04             	sub    $0x4,%esp
  803593:	6a 01                	push   $0x1
  803595:	50                   	push   %eax
  803596:	ff 75 08             	pushl  0x8(%ebp)
  803599:	e8 41 ea ff ff       	call   801fdf <set_block_data>
  80359e:	83 c4 10             	add    $0x10,%esp
  8035a1:	e9 36 01 00 00       	jmp    8036dc <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8035a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035ac:	01 d0                	add    %edx,%eax
  8035ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8035b1:	83 ec 04             	sub    $0x4,%esp
  8035b4:	6a 01                	push   $0x1
  8035b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8035b9:	ff 75 08             	pushl  0x8(%ebp)
  8035bc:	e8 1e ea ff ff       	call   801fdf <set_block_data>
  8035c1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c7:	83 e8 04             	sub    $0x4,%eax
  8035ca:	8b 00                	mov    (%eax),%eax
  8035cc:	83 e0 fe             	and    $0xfffffffe,%eax
  8035cf:	89 c2                	mov    %eax,%edx
  8035d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d4:	01 d0                	add    %edx,%eax
  8035d6:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8035d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035dd:	74 06                	je     8035e5 <realloc_block_FF+0x613>
  8035df:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8035e3:	75 17                	jne    8035fc <realloc_block_FF+0x62a>
  8035e5:	83 ec 04             	sub    $0x4,%esp
  8035e8:	68 b8 42 80 00       	push   $0x8042b8
  8035ed:	68 44 02 00 00       	push   $0x244
  8035f2:	68 45 42 80 00       	push   $0x804245
  8035f7:	e8 9e 01 00 00       	call   80379a <_panic>
  8035fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ff:	8b 10                	mov    (%eax),%edx
  803601:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803604:	89 10                	mov    %edx,(%eax)
  803606:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803609:	8b 00                	mov    (%eax),%eax
  80360b:	85 c0                	test   %eax,%eax
  80360d:	74 0b                	je     80361a <realloc_block_FF+0x648>
  80360f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803612:	8b 00                	mov    (%eax),%eax
  803614:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803617:	89 50 04             	mov    %edx,0x4(%eax)
  80361a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803620:	89 10                	mov    %edx,(%eax)
  803622:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803625:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803628:	89 50 04             	mov    %edx,0x4(%eax)
  80362b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	85 c0                	test   %eax,%eax
  803632:	75 08                	jne    80363c <realloc_block_FF+0x66a>
  803634:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803637:	a3 30 50 80 00       	mov    %eax,0x805030
  80363c:	a1 38 50 80 00       	mov    0x805038,%eax
  803641:	40                   	inc    %eax
  803642:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803647:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80364b:	75 17                	jne    803664 <realloc_block_FF+0x692>
  80364d:	83 ec 04             	sub    $0x4,%esp
  803650:	68 27 42 80 00       	push   $0x804227
  803655:	68 45 02 00 00       	push   $0x245
  80365a:	68 45 42 80 00       	push   $0x804245
  80365f:	e8 36 01 00 00       	call   80379a <_panic>
  803664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	85 c0                	test   %eax,%eax
  80366b:	74 10                	je     80367d <realloc_block_FF+0x6ab>
  80366d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803670:	8b 00                	mov    (%eax),%eax
  803672:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803675:	8b 52 04             	mov    0x4(%edx),%edx
  803678:	89 50 04             	mov    %edx,0x4(%eax)
  80367b:	eb 0b                	jmp    803688 <realloc_block_FF+0x6b6>
  80367d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803680:	8b 40 04             	mov    0x4(%eax),%eax
  803683:	a3 30 50 80 00       	mov    %eax,0x805030
  803688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368b:	8b 40 04             	mov    0x4(%eax),%eax
  80368e:	85 c0                	test   %eax,%eax
  803690:	74 0f                	je     8036a1 <realloc_block_FF+0x6cf>
  803692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803695:	8b 40 04             	mov    0x4(%eax),%eax
  803698:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80369b:	8b 12                	mov    (%edx),%edx
  80369d:	89 10                	mov    %edx,(%eax)
  80369f:	eb 0a                	jmp    8036ab <realloc_block_FF+0x6d9>
  8036a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a4:	8b 00                	mov    (%eax),%eax
  8036a6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036be:	a1 38 50 80 00       	mov    0x805038,%eax
  8036c3:	48                   	dec    %eax
  8036c4:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8036c9:	83 ec 04             	sub    $0x4,%esp
  8036cc:	6a 00                	push   $0x0
  8036ce:	ff 75 bc             	pushl  -0x44(%ebp)
  8036d1:	ff 75 b8             	pushl  -0x48(%ebp)
  8036d4:	e8 06 e9 ff ff       	call   801fdf <set_block_data>
  8036d9:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8036dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036df:	eb 0a                	jmp    8036eb <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8036e1:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8036e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8036eb:	c9                   	leave  
  8036ec:	c3                   	ret    

008036ed <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8036ed:	55                   	push   %ebp
  8036ee:	89 e5                	mov    %esp,%ebp
  8036f0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8036f3:	83 ec 04             	sub    $0x4,%esp
  8036f6:	68 3c 43 80 00       	push   $0x80433c
  8036fb:	68 58 02 00 00       	push   $0x258
  803700:	68 45 42 80 00       	push   $0x804245
  803705:	e8 90 00 00 00       	call   80379a <_panic>

0080370a <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80370a:	55                   	push   %ebp
  80370b:	89 e5                	mov    %esp,%ebp
  80370d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803710:	83 ec 04             	sub    $0x4,%esp
  803713:	68 64 43 80 00       	push   $0x804364
  803718:	68 61 02 00 00       	push   $0x261
  80371d:	68 45 42 80 00       	push   $0x804245
  803722:	e8 73 00 00 00       	call   80379a <_panic>

00803727 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803727:	55                   	push   %ebp
  803728:	89 e5                	mov    %esp,%ebp
  80372a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  80372d:	83 ec 04             	sub    $0x4,%esp
  803730:	68 8c 43 80 00       	push   $0x80438c
  803735:	6a 09                	push   $0x9
  803737:	68 b4 43 80 00       	push   $0x8043b4
  80373c:	e8 59 00 00 00       	call   80379a <_panic>

00803741 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803741:	55                   	push   %ebp
  803742:	89 e5                	mov    %esp,%ebp
  803744:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803747:	83 ec 04             	sub    $0x4,%esp
  80374a:	68 c4 43 80 00       	push   $0x8043c4
  80374f:	6a 10                	push   $0x10
  803751:	68 b4 43 80 00       	push   $0x8043b4
  803756:	e8 3f 00 00 00       	call   80379a <_panic>

0080375b <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  80375b:	55                   	push   %ebp
  80375c:	89 e5                	mov    %esp,%ebp
  80375e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803761:	83 ec 04             	sub    $0x4,%esp
  803764:	68 ec 43 80 00       	push   $0x8043ec
  803769:	6a 18                	push   $0x18
  80376b:	68 b4 43 80 00       	push   $0x8043b4
  803770:	e8 25 00 00 00       	call   80379a <_panic>

00803775 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803775:	55                   	push   %ebp
  803776:	89 e5                	mov    %esp,%ebp
  803778:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  80377b:	83 ec 04             	sub    $0x4,%esp
  80377e:	68 14 44 80 00       	push   $0x804414
  803783:	6a 20                	push   $0x20
  803785:	68 b4 43 80 00       	push   $0x8043b4
  80378a:	e8 0b 00 00 00       	call   80379a <_panic>

0080378f <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80378f:	55                   	push   %ebp
  803790:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  803792:	8b 45 08             	mov    0x8(%ebp),%eax
  803795:	8b 40 10             	mov    0x10(%eax),%eax
}
  803798:	5d                   	pop    %ebp
  803799:	c3                   	ret    

0080379a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80379a:	55                   	push   %ebp
  80379b:	89 e5                	mov    %esp,%ebp
  80379d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8037a0:	8d 45 10             	lea    0x10(%ebp),%eax
  8037a3:	83 c0 04             	add    $0x4,%eax
  8037a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8037a9:	a1 60 50 90 00       	mov    0x905060,%eax
  8037ae:	85 c0                	test   %eax,%eax
  8037b0:	74 16                	je     8037c8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8037b2:	a1 60 50 90 00       	mov    0x905060,%eax
  8037b7:	83 ec 08             	sub    $0x8,%esp
  8037ba:	50                   	push   %eax
  8037bb:	68 3c 44 80 00       	push   $0x80443c
  8037c0:	e8 3e cc ff ff       	call   800403 <cprintf>
  8037c5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8037c8:	a1 00 50 80 00       	mov    0x805000,%eax
  8037cd:	ff 75 0c             	pushl  0xc(%ebp)
  8037d0:	ff 75 08             	pushl  0x8(%ebp)
  8037d3:	50                   	push   %eax
  8037d4:	68 41 44 80 00       	push   $0x804441
  8037d9:	e8 25 cc ff ff       	call   800403 <cprintf>
  8037de:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8037e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8037e4:	83 ec 08             	sub    $0x8,%esp
  8037e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8037ea:	50                   	push   %eax
  8037eb:	e8 a8 cb ff ff       	call   800398 <vcprintf>
  8037f0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8037f3:	83 ec 08             	sub    $0x8,%esp
  8037f6:	6a 00                	push   $0x0
  8037f8:	68 5d 44 80 00       	push   $0x80445d
  8037fd:	e8 96 cb ff ff       	call   800398 <vcprintf>
  803802:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803805:	e8 17 cb ff ff       	call   800321 <exit>

	// should not return here
	while (1) ;
  80380a:	eb fe                	jmp    80380a <_panic+0x70>

0080380c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80380c:	55                   	push   %ebp
  80380d:	89 e5                	mov    %esp,%ebp
  80380f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803812:	a1 20 50 80 00       	mov    0x805020,%eax
  803817:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80381d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803820:	39 c2                	cmp    %eax,%edx
  803822:	74 14                	je     803838 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803824:	83 ec 04             	sub    $0x4,%esp
  803827:	68 60 44 80 00       	push   $0x804460
  80382c:	6a 26                	push   $0x26
  80382e:	68 ac 44 80 00       	push   $0x8044ac
  803833:	e8 62 ff ff ff       	call   80379a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803838:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80383f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803846:	e9 c5 00 00 00       	jmp    803910 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80384b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803855:	8b 45 08             	mov    0x8(%ebp),%eax
  803858:	01 d0                	add    %edx,%eax
  80385a:	8b 00                	mov    (%eax),%eax
  80385c:	85 c0                	test   %eax,%eax
  80385e:	75 08                	jne    803868 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803860:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803863:	e9 a5 00 00 00       	jmp    80390d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803868:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80386f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803876:	eb 69                	jmp    8038e1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803878:	a1 20 50 80 00       	mov    0x805020,%eax
  80387d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803883:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803886:	89 d0                	mov    %edx,%eax
  803888:	01 c0                	add    %eax,%eax
  80388a:	01 d0                	add    %edx,%eax
  80388c:	c1 e0 03             	shl    $0x3,%eax
  80388f:	01 c8                	add    %ecx,%eax
  803891:	8a 40 04             	mov    0x4(%eax),%al
  803894:	84 c0                	test   %al,%al
  803896:	75 46                	jne    8038de <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803898:	a1 20 50 80 00       	mov    0x805020,%eax
  80389d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038a6:	89 d0                	mov    %edx,%eax
  8038a8:	01 c0                	add    %eax,%eax
  8038aa:	01 d0                	add    %edx,%eax
  8038ac:	c1 e0 03             	shl    $0x3,%eax
  8038af:	01 c8                	add    %ecx,%eax
  8038b1:	8b 00                	mov    (%eax),%eax
  8038b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8038b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8038be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8038c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8038ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cd:	01 c8                	add    %ecx,%eax
  8038cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038d1:	39 c2                	cmp    %eax,%edx
  8038d3:	75 09                	jne    8038de <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8038d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8038dc:	eb 15                	jmp    8038f3 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038de:	ff 45 e8             	incl   -0x18(%ebp)
  8038e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8038e6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8038ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ef:	39 c2                	cmp    %eax,%edx
  8038f1:	77 85                	ja     803878 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8038f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038f7:	75 14                	jne    80390d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8038f9:	83 ec 04             	sub    $0x4,%esp
  8038fc:	68 b8 44 80 00       	push   $0x8044b8
  803901:	6a 3a                	push   $0x3a
  803903:	68 ac 44 80 00       	push   $0x8044ac
  803908:	e8 8d fe ff ff       	call   80379a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80390d:	ff 45 f0             	incl   -0x10(%ebp)
  803910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803913:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803916:	0f 8c 2f ff ff ff    	jl     80384b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80391c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803923:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80392a:	eb 26                	jmp    803952 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80392c:	a1 20 50 80 00       	mov    0x805020,%eax
  803931:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803937:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80393a:	89 d0                	mov    %edx,%eax
  80393c:	01 c0                	add    %eax,%eax
  80393e:	01 d0                	add    %edx,%eax
  803940:	c1 e0 03             	shl    $0x3,%eax
  803943:	01 c8                	add    %ecx,%eax
  803945:	8a 40 04             	mov    0x4(%eax),%al
  803948:	3c 01                	cmp    $0x1,%al
  80394a:	75 03                	jne    80394f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80394c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80394f:	ff 45 e0             	incl   -0x20(%ebp)
  803952:	a1 20 50 80 00       	mov    0x805020,%eax
  803957:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80395d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803960:	39 c2                	cmp    %eax,%edx
  803962:	77 c8                	ja     80392c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803967:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80396a:	74 14                	je     803980 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80396c:	83 ec 04             	sub    $0x4,%esp
  80396f:	68 0c 45 80 00       	push   $0x80450c
  803974:	6a 44                	push   $0x44
  803976:	68 ac 44 80 00       	push   $0x8044ac
  80397b:	e8 1a fe ff ff       	call   80379a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803980:	90                   	nop
  803981:	c9                   	leave  
  803982:	c3                   	ret    
  803983:	90                   	nop

00803984 <__udivdi3>:
  803984:	55                   	push   %ebp
  803985:	57                   	push   %edi
  803986:	56                   	push   %esi
  803987:	53                   	push   %ebx
  803988:	83 ec 1c             	sub    $0x1c,%esp
  80398b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80398f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803993:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803997:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80399b:	89 ca                	mov    %ecx,%edx
  80399d:	89 f8                	mov    %edi,%eax
  80399f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039a3:	85 f6                	test   %esi,%esi
  8039a5:	75 2d                	jne    8039d4 <__udivdi3+0x50>
  8039a7:	39 cf                	cmp    %ecx,%edi
  8039a9:	77 65                	ja     803a10 <__udivdi3+0x8c>
  8039ab:	89 fd                	mov    %edi,%ebp
  8039ad:	85 ff                	test   %edi,%edi
  8039af:	75 0b                	jne    8039bc <__udivdi3+0x38>
  8039b1:	b8 01 00 00 00       	mov    $0x1,%eax
  8039b6:	31 d2                	xor    %edx,%edx
  8039b8:	f7 f7                	div    %edi
  8039ba:	89 c5                	mov    %eax,%ebp
  8039bc:	31 d2                	xor    %edx,%edx
  8039be:	89 c8                	mov    %ecx,%eax
  8039c0:	f7 f5                	div    %ebp
  8039c2:	89 c1                	mov    %eax,%ecx
  8039c4:	89 d8                	mov    %ebx,%eax
  8039c6:	f7 f5                	div    %ebp
  8039c8:	89 cf                	mov    %ecx,%edi
  8039ca:	89 fa                	mov    %edi,%edx
  8039cc:	83 c4 1c             	add    $0x1c,%esp
  8039cf:	5b                   	pop    %ebx
  8039d0:	5e                   	pop    %esi
  8039d1:	5f                   	pop    %edi
  8039d2:	5d                   	pop    %ebp
  8039d3:	c3                   	ret    
  8039d4:	39 ce                	cmp    %ecx,%esi
  8039d6:	77 28                	ja     803a00 <__udivdi3+0x7c>
  8039d8:	0f bd fe             	bsr    %esi,%edi
  8039db:	83 f7 1f             	xor    $0x1f,%edi
  8039de:	75 40                	jne    803a20 <__udivdi3+0x9c>
  8039e0:	39 ce                	cmp    %ecx,%esi
  8039e2:	72 0a                	jb     8039ee <__udivdi3+0x6a>
  8039e4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039e8:	0f 87 9e 00 00 00    	ja     803a8c <__udivdi3+0x108>
  8039ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8039f3:	89 fa                	mov    %edi,%edx
  8039f5:	83 c4 1c             	add    $0x1c,%esp
  8039f8:	5b                   	pop    %ebx
  8039f9:	5e                   	pop    %esi
  8039fa:	5f                   	pop    %edi
  8039fb:	5d                   	pop    %ebp
  8039fc:	c3                   	ret    
  8039fd:	8d 76 00             	lea    0x0(%esi),%esi
  803a00:	31 ff                	xor    %edi,%edi
  803a02:	31 c0                	xor    %eax,%eax
  803a04:	89 fa                	mov    %edi,%edx
  803a06:	83 c4 1c             	add    $0x1c,%esp
  803a09:	5b                   	pop    %ebx
  803a0a:	5e                   	pop    %esi
  803a0b:	5f                   	pop    %edi
  803a0c:	5d                   	pop    %ebp
  803a0d:	c3                   	ret    
  803a0e:	66 90                	xchg   %ax,%ax
  803a10:	89 d8                	mov    %ebx,%eax
  803a12:	f7 f7                	div    %edi
  803a14:	31 ff                	xor    %edi,%edi
  803a16:	89 fa                	mov    %edi,%edx
  803a18:	83 c4 1c             	add    $0x1c,%esp
  803a1b:	5b                   	pop    %ebx
  803a1c:	5e                   	pop    %esi
  803a1d:	5f                   	pop    %edi
  803a1e:	5d                   	pop    %ebp
  803a1f:	c3                   	ret    
  803a20:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a25:	89 eb                	mov    %ebp,%ebx
  803a27:	29 fb                	sub    %edi,%ebx
  803a29:	89 f9                	mov    %edi,%ecx
  803a2b:	d3 e6                	shl    %cl,%esi
  803a2d:	89 c5                	mov    %eax,%ebp
  803a2f:	88 d9                	mov    %bl,%cl
  803a31:	d3 ed                	shr    %cl,%ebp
  803a33:	89 e9                	mov    %ebp,%ecx
  803a35:	09 f1                	or     %esi,%ecx
  803a37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a3b:	89 f9                	mov    %edi,%ecx
  803a3d:	d3 e0                	shl    %cl,%eax
  803a3f:	89 c5                	mov    %eax,%ebp
  803a41:	89 d6                	mov    %edx,%esi
  803a43:	88 d9                	mov    %bl,%cl
  803a45:	d3 ee                	shr    %cl,%esi
  803a47:	89 f9                	mov    %edi,%ecx
  803a49:	d3 e2                	shl    %cl,%edx
  803a4b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a4f:	88 d9                	mov    %bl,%cl
  803a51:	d3 e8                	shr    %cl,%eax
  803a53:	09 c2                	or     %eax,%edx
  803a55:	89 d0                	mov    %edx,%eax
  803a57:	89 f2                	mov    %esi,%edx
  803a59:	f7 74 24 0c          	divl   0xc(%esp)
  803a5d:	89 d6                	mov    %edx,%esi
  803a5f:	89 c3                	mov    %eax,%ebx
  803a61:	f7 e5                	mul    %ebp
  803a63:	39 d6                	cmp    %edx,%esi
  803a65:	72 19                	jb     803a80 <__udivdi3+0xfc>
  803a67:	74 0b                	je     803a74 <__udivdi3+0xf0>
  803a69:	89 d8                	mov    %ebx,%eax
  803a6b:	31 ff                	xor    %edi,%edi
  803a6d:	e9 58 ff ff ff       	jmp    8039ca <__udivdi3+0x46>
  803a72:	66 90                	xchg   %ax,%ax
  803a74:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a78:	89 f9                	mov    %edi,%ecx
  803a7a:	d3 e2                	shl    %cl,%edx
  803a7c:	39 c2                	cmp    %eax,%edx
  803a7e:	73 e9                	jae    803a69 <__udivdi3+0xe5>
  803a80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a83:	31 ff                	xor    %edi,%edi
  803a85:	e9 40 ff ff ff       	jmp    8039ca <__udivdi3+0x46>
  803a8a:	66 90                	xchg   %ax,%ax
  803a8c:	31 c0                	xor    %eax,%eax
  803a8e:	e9 37 ff ff ff       	jmp    8039ca <__udivdi3+0x46>
  803a93:	90                   	nop

00803a94 <__umoddi3>:
  803a94:	55                   	push   %ebp
  803a95:	57                   	push   %edi
  803a96:	56                   	push   %esi
  803a97:	53                   	push   %ebx
  803a98:	83 ec 1c             	sub    $0x1c,%esp
  803a9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803aa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aa7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803aab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803aaf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ab3:	89 f3                	mov    %esi,%ebx
  803ab5:	89 fa                	mov    %edi,%edx
  803ab7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803abb:	89 34 24             	mov    %esi,(%esp)
  803abe:	85 c0                	test   %eax,%eax
  803ac0:	75 1a                	jne    803adc <__umoddi3+0x48>
  803ac2:	39 f7                	cmp    %esi,%edi
  803ac4:	0f 86 a2 00 00 00    	jbe    803b6c <__umoddi3+0xd8>
  803aca:	89 c8                	mov    %ecx,%eax
  803acc:	89 f2                	mov    %esi,%edx
  803ace:	f7 f7                	div    %edi
  803ad0:	89 d0                	mov    %edx,%eax
  803ad2:	31 d2                	xor    %edx,%edx
  803ad4:	83 c4 1c             	add    $0x1c,%esp
  803ad7:	5b                   	pop    %ebx
  803ad8:	5e                   	pop    %esi
  803ad9:	5f                   	pop    %edi
  803ada:	5d                   	pop    %ebp
  803adb:	c3                   	ret    
  803adc:	39 f0                	cmp    %esi,%eax
  803ade:	0f 87 ac 00 00 00    	ja     803b90 <__umoddi3+0xfc>
  803ae4:	0f bd e8             	bsr    %eax,%ebp
  803ae7:	83 f5 1f             	xor    $0x1f,%ebp
  803aea:	0f 84 ac 00 00 00    	je     803b9c <__umoddi3+0x108>
  803af0:	bf 20 00 00 00       	mov    $0x20,%edi
  803af5:	29 ef                	sub    %ebp,%edi
  803af7:	89 fe                	mov    %edi,%esi
  803af9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803afd:	89 e9                	mov    %ebp,%ecx
  803aff:	d3 e0                	shl    %cl,%eax
  803b01:	89 d7                	mov    %edx,%edi
  803b03:	89 f1                	mov    %esi,%ecx
  803b05:	d3 ef                	shr    %cl,%edi
  803b07:	09 c7                	or     %eax,%edi
  803b09:	89 e9                	mov    %ebp,%ecx
  803b0b:	d3 e2                	shl    %cl,%edx
  803b0d:	89 14 24             	mov    %edx,(%esp)
  803b10:	89 d8                	mov    %ebx,%eax
  803b12:	d3 e0                	shl    %cl,%eax
  803b14:	89 c2                	mov    %eax,%edx
  803b16:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b1a:	d3 e0                	shl    %cl,%eax
  803b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b20:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b24:	89 f1                	mov    %esi,%ecx
  803b26:	d3 e8                	shr    %cl,%eax
  803b28:	09 d0                	or     %edx,%eax
  803b2a:	d3 eb                	shr    %cl,%ebx
  803b2c:	89 da                	mov    %ebx,%edx
  803b2e:	f7 f7                	div    %edi
  803b30:	89 d3                	mov    %edx,%ebx
  803b32:	f7 24 24             	mull   (%esp)
  803b35:	89 c6                	mov    %eax,%esi
  803b37:	89 d1                	mov    %edx,%ecx
  803b39:	39 d3                	cmp    %edx,%ebx
  803b3b:	0f 82 87 00 00 00    	jb     803bc8 <__umoddi3+0x134>
  803b41:	0f 84 91 00 00 00    	je     803bd8 <__umoddi3+0x144>
  803b47:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b4b:	29 f2                	sub    %esi,%edx
  803b4d:	19 cb                	sbb    %ecx,%ebx
  803b4f:	89 d8                	mov    %ebx,%eax
  803b51:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b55:	d3 e0                	shl    %cl,%eax
  803b57:	89 e9                	mov    %ebp,%ecx
  803b59:	d3 ea                	shr    %cl,%edx
  803b5b:	09 d0                	or     %edx,%eax
  803b5d:	89 e9                	mov    %ebp,%ecx
  803b5f:	d3 eb                	shr    %cl,%ebx
  803b61:	89 da                	mov    %ebx,%edx
  803b63:	83 c4 1c             	add    $0x1c,%esp
  803b66:	5b                   	pop    %ebx
  803b67:	5e                   	pop    %esi
  803b68:	5f                   	pop    %edi
  803b69:	5d                   	pop    %ebp
  803b6a:	c3                   	ret    
  803b6b:	90                   	nop
  803b6c:	89 fd                	mov    %edi,%ebp
  803b6e:	85 ff                	test   %edi,%edi
  803b70:	75 0b                	jne    803b7d <__umoddi3+0xe9>
  803b72:	b8 01 00 00 00       	mov    $0x1,%eax
  803b77:	31 d2                	xor    %edx,%edx
  803b79:	f7 f7                	div    %edi
  803b7b:	89 c5                	mov    %eax,%ebp
  803b7d:	89 f0                	mov    %esi,%eax
  803b7f:	31 d2                	xor    %edx,%edx
  803b81:	f7 f5                	div    %ebp
  803b83:	89 c8                	mov    %ecx,%eax
  803b85:	f7 f5                	div    %ebp
  803b87:	89 d0                	mov    %edx,%eax
  803b89:	e9 44 ff ff ff       	jmp    803ad2 <__umoddi3+0x3e>
  803b8e:	66 90                	xchg   %ax,%ax
  803b90:	89 c8                	mov    %ecx,%eax
  803b92:	89 f2                	mov    %esi,%edx
  803b94:	83 c4 1c             	add    $0x1c,%esp
  803b97:	5b                   	pop    %ebx
  803b98:	5e                   	pop    %esi
  803b99:	5f                   	pop    %edi
  803b9a:	5d                   	pop    %ebp
  803b9b:	c3                   	ret    
  803b9c:	3b 04 24             	cmp    (%esp),%eax
  803b9f:	72 06                	jb     803ba7 <__umoddi3+0x113>
  803ba1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ba5:	77 0f                	ja     803bb6 <__umoddi3+0x122>
  803ba7:	89 f2                	mov    %esi,%edx
  803ba9:	29 f9                	sub    %edi,%ecx
  803bab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803baf:	89 14 24             	mov    %edx,(%esp)
  803bb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bb6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bba:	8b 14 24             	mov    (%esp),%edx
  803bbd:	83 c4 1c             	add    $0x1c,%esp
  803bc0:	5b                   	pop    %ebx
  803bc1:	5e                   	pop    %esi
  803bc2:	5f                   	pop    %edi
  803bc3:	5d                   	pop    %ebp
  803bc4:	c3                   	ret    
  803bc5:	8d 76 00             	lea    0x0(%esi),%esi
  803bc8:	2b 04 24             	sub    (%esp),%eax
  803bcb:	19 fa                	sbb    %edi,%edx
  803bcd:	89 d1                	mov    %edx,%ecx
  803bcf:	89 c6                	mov    %eax,%esi
  803bd1:	e9 71 ff ff ff       	jmp    803b47 <__umoddi3+0xb3>
  803bd6:	66 90                	xchg   %ax,%ax
  803bd8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bdc:	72 ea                	jb     803bc8 <__umoddi3+0x134>
  803bde:	89 d9                	mov    %ebx,%ecx
  803be0:	e9 62 ff ff ff       	jmp    803b47 <__umoddi3+0xb3>
