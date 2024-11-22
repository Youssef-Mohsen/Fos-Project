
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
  8000e0:	e8 52 36 00 00       	call   803737 <create_semaphore>
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
  800133:	e8 b8 17 00 00       	call   8018f0 <sys_create_env>
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
  800169:	e8 82 17 00 00       	call   8018f0 <sys_create_env>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 8f 17 00 00       	call   80190e <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	e8 81 17 00 00       	call   80190e <sys_run_env>
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
  8001c8:	e8 60 16 00 00       	call   80182d <sys_cputc>
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
  8001d9:	e8 eb 14 00 00       	call   8016c9 <sys_cgetc>
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
  8001f6:	e8 63 17 00 00       	call   80195e <sys_getenvindex>
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
  800264:	e8 79 14 00 00       	call   8016e2 <sys_lock_cons>
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
  8002fe:	e8 f9 13 00 00       	call   8016fc <sys_unlock_cons>
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
  800316:	e8 0f 16 00 00       	call   80192a <sys_destroy_env>
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
  800327:	e8 64 16 00 00       	call   801990 <sys_exit_env>
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
  800375:	e8 26 13 00 00       	call   8016a0 <sys_cputs>
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
  8003ec:	e8 af 12 00 00       	call   8016a0 <sys_cputs>
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
  800436:	e8 a7 12 00 00       	call   8016e2 <sys_lock_cons>
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
  800456:	e8 a1 12 00 00       	call   8016fc <sys_unlock_cons>
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
  8004a0:	e8 ef 34 00 00       	call   803994 <__udivdi3>
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
  8004f0:	e8 af 35 00 00       	call   803aa4 <__umoddi3>
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
  801198:	e8 0d 26 00 00       	call   8037aa <_panic>

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
  8011a9:	e8 9d 0a 00 00       	call   801c4b <sys_sbrk>
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
  801224:	e8 a6 08 00 00       	call   801acf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801229:	85 c0                	test   %eax,%eax
  80122b:	74 16                	je     801243 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 e6 0d 00 00       	call   80201e <alloc_block_FF>
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123e:	e9 8a 01 00 00       	jmp    8013cd <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801243:	e8 b8 08 00 00       	call   801b00 <sys_isUHeapPlacementStrategyBESTFIT>
  801248:	85 c0                	test   %eax,%eax
  80124a:	0f 84 7d 01 00 00    	je     8013cd <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	ff 75 08             	pushl  0x8(%ebp)
  801256:	e8 7f 12 00 00       	call   8024da <alloc_block_BF>
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
  8013bc:	e8 c1 08 00 00       	call   801c82 <sys_allocate_user_mem>
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
  801404:	e8 95 08 00 00       	call   801c9e <get_block_size>
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80140f:	83 ec 0c             	sub    $0xc,%esp
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	e8 c8 1a 00 00       	call   802ee2 <free_block>
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
  8014ac:	e8 b5 07 00 00       	call   801c66 <sys_free_user_mem>
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
  8014c9:	e8 dc 22 00 00       	call   8037aa <_panic>
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
  80152c:	e8 3c 03 00 00       	call   80186d <sys_createSharedObject>
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
  80154d:	68 4e 41 80 00       	push   $0x80414e
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
  801562:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801565:	83 ec 08             	sub    $0x8,%esp
  801568:	ff 75 0c             	pushl  0xc(%ebp)
  80156b:	ff 75 08             	pushl  0x8(%ebp)
  80156e:	e8 24 03 00 00       	call   801897 <sys_getSizeOfSharedObject>
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801579:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80157d:	75 07                	jne    801586 <sget+0x27>
  80157f:	b8 00 00 00 00       	mov    $0x0,%eax
  801584:	eb 5c                	jmp    8015e2 <sget+0x83>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801589:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80158c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801593:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	39 d0                	cmp    %edx,%eax
  80159b:	7d 02                	jge    80159f <sget+0x40>
  80159d:	89 d0                	mov    %edx,%eax
  80159f:	83 ec 0c             	sub    $0xc,%esp
  8015a2:	50                   	push   %eax
  8015a3:	e8 0b fc ff ff       	call   8011b3 <malloc>
  8015a8:	83 c4 10             	add    $0x10,%esp
  8015ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8015ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015b2:	75 07                	jne    8015bb <sget+0x5c>
  8015b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b9:	eb 27                	jmp    8015e2 <sget+0x83>
	int ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	ff 75 e8             	pushl  -0x18(%ebp)
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	ff 75 08             	pushl  0x8(%ebp)
  8015c7:	e8 e8 02 00 00       	call   8018b4 <sys_getSharedObject>
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8015d2:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8015d6:	75 07                	jne    8015df <sget+0x80>
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015dd:	eb 03                	jmp    8015e2 <sget+0x83>
	return ptr;
  8015df:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015ea:	83 ec 04             	sub    $0x4,%esp
  8015ed:	68 54 41 80 00       	push   $0x804154
  8015f2:	68 c2 00 00 00       	push   $0xc2
  8015f7:	68 42 41 80 00       	push   $0x804142
  8015fc:	e8 a9 21 00 00       	call   8037aa <_panic>

00801601 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801607:	83 ec 04             	sub    $0x4,%esp
  80160a:	68 78 41 80 00       	push   $0x804178
  80160f:	68 d9 00 00 00       	push   $0xd9
  801614:	68 42 41 80 00       	push   $0x804142
  801619:	e8 8c 21 00 00       	call   8037aa <_panic>

0080161e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801624:	83 ec 04             	sub    $0x4,%esp
  801627:	68 9e 41 80 00       	push   $0x80419e
  80162c:	68 e5 00 00 00       	push   $0xe5
  801631:	68 42 41 80 00       	push   $0x804142
  801636:	e8 6f 21 00 00       	call   8037aa <_panic>

0080163b <shrink>:

}
void shrink(uint32 newSize)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	68 9e 41 80 00       	push   $0x80419e
  801649:	68 ea 00 00 00       	push   $0xea
  80164e:	68 42 41 80 00       	push   $0x804142
  801653:	e8 52 21 00 00       	call   8037aa <_panic>

00801658 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80165e:	83 ec 04             	sub    $0x4,%esp
  801661:	68 9e 41 80 00       	push   $0x80419e
  801666:	68 ef 00 00 00       	push   $0xef
  80166b:	68 42 41 80 00       	push   $0x804142
  801670:	e8 35 21 00 00       	call   8037aa <_panic>

00801675 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	57                   	push   %edi
  801679:	56                   	push   %esi
  80167a:	53                   	push   %ebx
  80167b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	8b 55 0c             	mov    0xc(%ebp),%edx
  801684:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801687:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80168a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80168d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801690:	cd 30                	int    $0x30
  801692:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801695:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	5b                   	pop    %ebx
  80169c:	5e                   	pop    %esi
  80169d:	5f                   	pop    %edi
  80169e:	5d                   	pop    %ebp
  80169f:	c3                   	ret    

008016a0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016ac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	52                   	push   %edx
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	50                   	push   %eax
  8016bc:	6a 00                	push   $0x0
  8016be:	e8 b2 ff ff ff       	call   801675 <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
}
  8016c6:	90                   	nop
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 02                	push   $0x2
  8016d8:	e8 98 ff ff ff       	call   801675 <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 03                	push   $0x3
  8016f1:	e8 7f ff ff ff       	call   801675 <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
}
  8016f9:	90                   	nop
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 04                	push   $0x4
  80170b:	e8 65 ff ff ff       	call   801675 <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
}
  801713:	90                   	nop
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	52                   	push   %edx
  801726:	50                   	push   %eax
  801727:	6a 08                	push   $0x8
  801729:	e8 47 ff ff ff       	call   801675 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	56                   	push   %esi
  801737:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801738:	8b 75 18             	mov    0x18(%ebp),%esi
  80173b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801741:	8b 55 0c             	mov    0xc(%ebp),%edx
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	56                   	push   %esi
  801748:	53                   	push   %ebx
  801749:	51                   	push   %ecx
  80174a:	52                   	push   %edx
  80174b:	50                   	push   %eax
  80174c:	6a 09                	push   $0x9
  80174e:	e8 22 ff ff ff       	call   801675 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801759:	5b                   	pop    %ebx
  80175a:	5e                   	pop    %esi
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    

0080175d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801760:	8b 55 0c             	mov    0xc(%ebp),%edx
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	52                   	push   %edx
  80176d:	50                   	push   %eax
  80176e:	6a 0a                	push   $0xa
  801770:	e8 00 ff ff ff       	call   801675 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	ff 75 0c             	pushl  0xc(%ebp)
  801786:	ff 75 08             	pushl  0x8(%ebp)
  801789:	6a 0b                	push   $0xb
  80178b:	e8 e5 fe ff ff       	call   801675 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 0c                	push   $0xc
  8017a4:	e8 cc fe ff ff       	call   801675 <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 0d                	push   $0xd
  8017bd:	e8 b3 fe ff ff       	call   801675 <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 0e                	push   $0xe
  8017d6:	e8 9a fe ff ff       	call   801675 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 0f                	push   $0xf
  8017ef:	e8 81 fe ff ff       	call   801675 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	6a 10                	push   $0x10
  801809:	e8 67 fe ff ff       	call   801675 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 11                	push   $0x11
  801822:	e8 4e fe ff ff       	call   801675 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	90                   	nop
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_cputc>:

void
sys_cputc(const char c)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801839:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	50                   	push   %eax
  801846:	6a 01                	push   $0x1
  801848:	e8 28 fe ff ff       	call   801675 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	90                   	nop
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 14                	push   $0x14
  801862:	e8 0e fe ff ff       	call   801675 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	90                   	nop
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	8b 45 10             	mov    0x10(%ebp),%eax
  801876:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801879:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80187c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	6a 00                	push   $0x0
  801885:	51                   	push   %ecx
  801886:	52                   	push   %edx
  801887:	ff 75 0c             	pushl  0xc(%ebp)
  80188a:	50                   	push   %eax
  80188b:	6a 15                	push   $0x15
  80188d:	e8 e3 fd ff ff       	call   801675 <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	6a 16                	push   $0x16
  8018aa:	e8 c6 fd ff ff       	call   801675 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	51                   	push   %ecx
  8018c5:	52                   	push   %edx
  8018c6:	50                   	push   %eax
  8018c7:	6a 17                	push   $0x17
  8018c9:	e8 a7 fd ff ff       	call   801675 <syscall>
  8018ce:	83 c4 18             	add    $0x18,%esp
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	52                   	push   %edx
  8018e3:	50                   	push   %eax
  8018e4:	6a 18                	push   $0x18
  8018e6:	e8 8a fd ff ff       	call   801675 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	ff 75 14             	pushl  0x14(%ebp)
  8018fb:	ff 75 10             	pushl  0x10(%ebp)
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	50                   	push   %eax
  801902:	6a 19                	push   $0x19
  801904:	e8 6c fd ff ff       	call   801675 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	50                   	push   %eax
  80191d:	6a 1a                	push   $0x1a
  80191f:	e8 51 fd ff ff       	call   801675 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	90                   	nop
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	50                   	push   %eax
  801939:	6a 1b                	push   $0x1b
  80193b:	e8 35 fd ff ff       	call   801675 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 05                	push   $0x5
  801954:	e8 1c fd ff ff       	call   801675 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 06                	push   $0x6
  80196d:	e8 03 fd ff ff       	call   801675 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 07                	push   $0x7
  801986:	e8 ea fc ff ff       	call   801675 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_exit_env>:


void sys_exit_env(void)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 1c                	push   $0x1c
  80199f:	e8 d1 fc ff ff       	call   801675 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	90                   	nop
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019b0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019b3:	8d 50 04             	lea    0x4(%eax),%edx
  8019b6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	52                   	push   %edx
  8019c0:	50                   	push   %eax
  8019c1:	6a 1d                	push   $0x1d
  8019c3:	e8 ad fc ff ff       	call   801675 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
	return result;
  8019cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019d4:	89 01                	mov    %eax,(%ecx)
  8019d6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	c9                   	leave  
  8019dd:	c2 04 00             	ret    $0x4

008019e0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	ff 75 10             	pushl  0x10(%ebp)
  8019ea:	ff 75 0c             	pushl  0xc(%ebp)
  8019ed:	ff 75 08             	pushl  0x8(%ebp)
  8019f0:	6a 13                	push   $0x13
  8019f2:	e8 7e fc ff ff       	call   801675 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019fa:	90                   	nop
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_rcr2>:
uint32 sys_rcr2()
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 1e                	push   $0x1e
  801a0c:	e8 64 fc ff ff       	call   801675 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 04             	sub    $0x4,%esp
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a22:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	50                   	push   %eax
  801a2f:	6a 1f                	push   $0x1f
  801a31:	e8 3f fc ff ff       	call   801675 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
	return ;
  801a39:	90                   	nop
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <rsttst>:
void rsttst()
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 21                	push   $0x21
  801a4b:	e8 25 fc ff ff       	call   801675 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
	return ;
  801a53:	90                   	nop
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 04             	sub    $0x4,%esp
  801a5c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a62:	8b 55 18             	mov    0x18(%ebp),%edx
  801a65:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a69:	52                   	push   %edx
  801a6a:	50                   	push   %eax
  801a6b:	ff 75 10             	pushl  0x10(%ebp)
  801a6e:	ff 75 0c             	pushl  0xc(%ebp)
  801a71:	ff 75 08             	pushl  0x8(%ebp)
  801a74:	6a 20                	push   $0x20
  801a76:	e8 fa fb ff ff       	call   801675 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7e:	90                   	nop
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <chktst>:
void chktst(uint32 n)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	ff 75 08             	pushl  0x8(%ebp)
  801a8f:	6a 22                	push   $0x22
  801a91:	e8 df fb ff ff       	call   801675 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
	return ;
  801a99:	90                   	nop
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <inctst>:

void inctst()
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 23                	push   $0x23
  801aab:	e8 c5 fb ff ff       	call   801675 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab3:	90                   	nop
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <gettst>:
uint32 gettst()
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 24                	push   $0x24
  801ac5:	e8 ab fb ff ff       	call   801675 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 25                	push   $0x25
  801ae1:	e8 8f fb ff ff       	call   801675 <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
  801ae9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801aec:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801af0:	75 07                	jne    801af9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801af2:	b8 01 00 00 00       	mov    $0x1,%eax
  801af7:	eb 05                	jmp    801afe <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801af9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 25                	push   $0x25
  801b12:	e8 5e fb ff ff       	call   801675 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
  801b1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b1d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b21:	75 07                	jne    801b2a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b23:	b8 01 00 00 00       	mov    $0x1,%eax
  801b28:	eb 05                	jmp    801b2f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 25                	push   $0x25
  801b43:	e8 2d fb ff ff       	call   801675 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
  801b4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b4e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b52:	75 07                	jne    801b5b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b54:	b8 01 00 00 00       	mov    $0x1,%eax
  801b59:	eb 05                	jmp    801b60 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 25                	push   $0x25
  801b74:	e8 fc fa ff ff       	call   801675 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
  801b7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b7f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b83:	75 07                	jne    801b8c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b85:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8a:	eb 05                	jmp    801b91 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	ff 75 08             	pushl  0x8(%ebp)
  801ba1:	6a 26                	push   $0x26
  801ba3:	e8 cd fa ff ff       	call   801675 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bab:	90                   	nop
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bb2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	6a 00                	push   $0x0
  801bc0:	53                   	push   %ebx
  801bc1:	51                   	push   %ecx
  801bc2:	52                   	push   %edx
  801bc3:	50                   	push   %eax
  801bc4:	6a 27                	push   $0x27
  801bc6:	e8 aa fa ff ff       	call   801675 <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
}
  801bce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	52                   	push   %edx
  801be3:	50                   	push   %eax
  801be4:	6a 28                	push   $0x28
  801be6:	e8 8a fa ff ff       	call   801675 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801bf3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	51                   	push   %ecx
  801bff:	ff 75 10             	pushl  0x10(%ebp)
  801c02:	52                   	push   %edx
  801c03:	50                   	push   %eax
  801c04:	6a 29                	push   $0x29
  801c06:	e8 6a fa ff ff       	call   801675 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	ff 75 10             	pushl  0x10(%ebp)
  801c1a:	ff 75 0c             	pushl  0xc(%ebp)
  801c1d:	ff 75 08             	pushl  0x8(%ebp)
  801c20:	6a 12                	push   $0x12
  801c22:	e8 4e fa ff ff       	call   801675 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2a:	90                   	nop
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	52                   	push   %edx
  801c3d:	50                   	push   %eax
  801c3e:	6a 2a                	push   $0x2a
  801c40:	e8 30 fa ff ff       	call   801675 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
	return;
  801c48:	90                   	nop
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	50                   	push   %eax
  801c5a:	6a 2b                	push   $0x2b
  801c5c:	e8 14 fa ff ff       	call   801675 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	ff 75 08             	pushl  0x8(%ebp)
  801c75:	6a 2c                	push   $0x2c
  801c77:	e8 f9 f9 ff ff       	call   801675 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
	return;
  801c7f:	90                   	nop
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	ff 75 0c             	pushl  0xc(%ebp)
  801c8e:	ff 75 08             	pushl  0x8(%ebp)
  801c91:	6a 2d                	push   $0x2d
  801c93:	e8 dd f9 ff ff       	call   801675 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
	return;
  801c9b:	90                   	nop
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	83 e8 04             	sub    $0x4,%eax
  801caa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801cad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cb0:	8b 00                	mov    (%eax),%eax
  801cb2:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	83 e8 04             	sub    $0x4,%eax
  801cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801cc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cc9:	8b 00                	mov    (%eax),%eax
  801ccb:	83 e0 01             	and    $0x1,%eax
  801cce:	85 c0                	test   %eax,%eax
  801cd0:	0f 94 c0             	sete   %al
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801cdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce5:	83 f8 02             	cmp    $0x2,%eax
  801ce8:	74 2b                	je     801d15 <alloc_block+0x40>
  801cea:	83 f8 02             	cmp    $0x2,%eax
  801ced:	7f 07                	jg     801cf6 <alloc_block+0x21>
  801cef:	83 f8 01             	cmp    $0x1,%eax
  801cf2:	74 0e                	je     801d02 <alloc_block+0x2d>
  801cf4:	eb 58                	jmp    801d4e <alloc_block+0x79>
  801cf6:	83 f8 03             	cmp    $0x3,%eax
  801cf9:	74 2d                	je     801d28 <alloc_block+0x53>
  801cfb:	83 f8 04             	cmp    $0x4,%eax
  801cfe:	74 3b                	je     801d3b <alloc_block+0x66>
  801d00:	eb 4c                	jmp    801d4e <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801d02:	83 ec 0c             	sub    $0xc,%esp
  801d05:	ff 75 08             	pushl  0x8(%ebp)
  801d08:	e8 11 03 00 00       	call   80201e <alloc_block_FF>
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d13:	eb 4a                	jmp    801d5f <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801d15:	83 ec 0c             	sub    $0xc,%esp
  801d18:	ff 75 08             	pushl  0x8(%ebp)
  801d1b:	e8 fa 19 00 00       	call   80371a <alloc_block_NF>
  801d20:	83 c4 10             	add    $0x10,%esp
  801d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d26:	eb 37                	jmp    801d5f <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801d28:	83 ec 0c             	sub    $0xc,%esp
  801d2b:	ff 75 08             	pushl  0x8(%ebp)
  801d2e:	e8 a7 07 00 00       	call   8024da <alloc_block_BF>
  801d33:	83 c4 10             	add    $0x10,%esp
  801d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d39:	eb 24                	jmp    801d5f <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801d3b:	83 ec 0c             	sub    $0xc,%esp
  801d3e:	ff 75 08             	pushl  0x8(%ebp)
  801d41:	e8 b7 19 00 00       	call   8036fd <alloc_block_WF>
  801d46:	83 c4 10             	add    $0x10,%esp
  801d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801d4c:	eb 11                	jmp    801d5f <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801d4e:	83 ec 0c             	sub    $0xc,%esp
  801d51:	68 b0 41 80 00       	push   $0x8041b0
  801d56:	e8 a8 e6 ff ff       	call   800403 <cprintf>
  801d5b:	83 c4 10             	add    $0x10,%esp
		break;
  801d5e:	90                   	nop
	}
	return va;
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	53                   	push   %ebx
  801d68:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801d6b:	83 ec 0c             	sub    $0xc,%esp
  801d6e:	68 d0 41 80 00       	push   $0x8041d0
  801d73:	e8 8b e6 ff ff       	call   800403 <cprintf>
  801d78:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	68 fb 41 80 00       	push   $0x8041fb
  801d83:	e8 7b e6 ff ff       	call   800403 <cprintf>
  801d88:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d91:	eb 37                	jmp    801dca <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801d93:	83 ec 0c             	sub    $0xc,%esp
  801d96:	ff 75 f4             	pushl  -0xc(%ebp)
  801d99:	e8 19 ff ff ff       	call   801cb7 <is_free_block>
  801d9e:	83 c4 10             	add    $0x10,%esp
  801da1:	0f be d8             	movsbl %al,%ebx
  801da4:	83 ec 0c             	sub    $0xc,%esp
  801da7:	ff 75 f4             	pushl  -0xc(%ebp)
  801daa:	e8 ef fe ff ff       	call   801c9e <get_block_size>
  801daf:	83 c4 10             	add    $0x10,%esp
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	53                   	push   %ebx
  801db6:	50                   	push   %eax
  801db7:	68 13 42 80 00       	push   $0x804213
  801dbc:	e8 42 e6 ff ff       	call   800403 <cprintf>
  801dc1:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801dc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dce:	74 07                	je     801dd7 <print_blocks_list+0x73>
  801dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd3:	8b 00                	mov    (%eax),%eax
  801dd5:	eb 05                	jmp    801ddc <print_blocks_list+0x78>
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddc:	89 45 10             	mov    %eax,0x10(%ebp)
  801ddf:	8b 45 10             	mov    0x10(%ebp),%eax
  801de2:	85 c0                	test   %eax,%eax
  801de4:	75 ad                	jne    801d93 <print_blocks_list+0x2f>
  801de6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dea:	75 a7                	jne    801d93 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801dec:	83 ec 0c             	sub    $0xc,%esp
  801def:	68 d0 41 80 00       	push   $0x8041d0
  801df4:	e8 0a e6 ff ff       	call   800403 <cprintf>
  801df9:	83 c4 10             	add    $0x10,%esp

}
  801dfc:	90                   	nop
  801dfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0b:	83 e0 01             	and    $0x1,%eax
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	74 03                	je     801e15 <initialize_dynamic_allocator+0x13>
  801e12:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801e15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e19:	0f 84 c7 01 00 00    	je     801fe6 <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801e1f:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801e26:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801e29:	8b 55 08             	mov    0x8(%ebp),%edx
  801e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2f:	01 d0                	add    %edx,%eax
  801e31:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801e36:	0f 87 ad 01 00 00    	ja     801fe9 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	0f 89 a5 01 00 00    	jns    801fec <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801e47:	8b 55 08             	mov    0x8(%ebp),%edx
  801e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4d:	01 d0                	add    %edx,%eax
  801e4f:	83 e8 04             	sub    $0x4,%eax
  801e52:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801e57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801e5e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801e63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e66:	e9 87 00 00 00       	jmp    801ef2 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801e6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e6f:	75 14                	jne    801e85 <initialize_dynamic_allocator+0x83>
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	68 2b 42 80 00       	push   $0x80422b
  801e79:	6a 79                	push   $0x79
  801e7b:	68 49 42 80 00       	push   $0x804249
  801e80:	e8 25 19 00 00       	call   8037aa <_panic>
  801e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e88:	8b 00                	mov    (%eax),%eax
  801e8a:	85 c0                	test   %eax,%eax
  801e8c:	74 10                	je     801e9e <initialize_dynamic_allocator+0x9c>
  801e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e91:	8b 00                	mov    (%eax),%eax
  801e93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e96:	8b 52 04             	mov    0x4(%edx),%edx
  801e99:	89 50 04             	mov    %edx,0x4(%eax)
  801e9c:	eb 0b                	jmp    801ea9 <initialize_dynamic_allocator+0xa7>
  801e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea1:	8b 40 04             	mov    0x4(%eax),%eax
  801ea4:	a3 30 50 80 00       	mov    %eax,0x805030
  801ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eac:	8b 40 04             	mov    0x4(%eax),%eax
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	74 0f                	je     801ec2 <initialize_dynamic_allocator+0xc0>
  801eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb6:	8b 40 04             	mov    0x4(%eax),%eax
  801eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ebc:	8b 12                	mov    (%edx),%edx
  801ebe:	89 10                	mov    %edx,(%eax)
  801ec0:	eb 0a                	jmp    801ecc <initialize_dynamic_allocator+0xca>
  801ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec5:	8b 00                	mov    (%eax),%eax
  801ec7:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801edf:	a1 38 50 80 00       	mov    0x805038,%eax
  801ee4:	48                   	dec    %eax
  801ee5:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801eea:	a1 34 50 80 00       	mov    0x805034,%eax
  801eef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef6:	74 07                	je     801eff <initialize_dynamic_allocator+0xfd>
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	8b 00                	mov    (%eax),%eax
  801efd:	eb 05                	jmp    801f04 <initialize_dynamic_allocator+0x102>
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	a3 34 50 80 00       	mov    %eax,0x805034
  801f09:	a1 34 50 80 00       	mov    0x805034,%eax
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	0f 85 55 ff ff ff    	jne    801e6b <initialize_dynamic_allocator+0x69>
  801f16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f1a:	0f 85 4b ff ff ff    	jne    801e6b <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  801f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f29:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  801f2f:	a1 44 50 80 00       	mov    0x805044,%eax
  801f34:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  801f39:	a1 40 50 80 00       	mov    0x805040,%eax
  801f3e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	83 c0 08             	add    $0x8,%eax
  801f4a:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	83 c0 04             	add    $0x4,%eax
  801f53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f56:	83 ea 08             	sub    $0x8,%edx
  801f59:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  801f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	01 d0                	add    %edx,%eax
  801f63:	83 e8 08             	sub    $0x8,%eax
  801f66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f69:	83 ea 08             	sub    $0x8,%edx
  801f6c:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  801f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  801f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  801f81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f85:	75 17                	jne    801f9e <initialize_dynamic_allocator+0x19c>
  801f87:	83 ec 04             	sub    $0x4,%esp
  801f8a:	68 64 42 80 00       	push   $0x804264
  801f8f:	68 90 00 00 00       	push   $0x90
  801f94:	68 49 42 80 00       	push   $0x804249
  801f99:	e8 0c 18 00 00       	call   8037aa <_panic>
  801f9e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  801fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa7:	89 10                	mov    %edx,(%eax)
  801fa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fac:	8b 00                	mov    (%eax),%eax
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	74 0d                	je     801fbf <initialize_dynamic_allocator+0x1bd>
  801fb2:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801fb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fba:	89 50 04             	mov    %edx,0x4(%eax)
  801fbd:	eb 08                	jmp    801fc7 <initialize_dynamic_allocator+0x1c5>
  801fbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc2:	a3 30 50 80 00       	mov    %eax,0x805030
  801fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fca:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fd9:	a1 38 50 80 00       	mov    0x805038,%eax
  801fde:	40                   	inc    %eax
  801fdf:	a3 38 50 80 00       	mov    %eax,0x805038
  801fe4:	eb 07                	jmp    801fed <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  801fe6:	90                   	nop
  801fe7:	eb 04                	jmp    801fed <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  801fe9:	90                   	nop
  801fea:	eb 01                	jmp    801fed <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  801fec:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  801ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff5:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	8d 50 fc             	lea    -0x4(%eax),%edx
  801ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802001:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	83 e8 04             	sub    $0x4,%eax
  802009:	8b 00                	mov    (%eax),%eax
  80200b:	83 e0 fe             	and    $0xfffffffe,%eax
  80200e:	8d 50 f8             	lea    -0x8(%eax),%edx
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	01 c2                	add    %eax,%edx
  802016:	8b 45 0c             	mov    0xc(%ebp),%eax
  802019:	89 02                	mov    %eax,(%edx)
}
  80201b:	90                   	nop
  80201c:	5d                   	pop    %ebp
  80201d:	c3                   	ret    

0080201e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	83 e0 01             	and    $0x1,%eax
  80202a:	85 c0                	test   %eax,%eax
  80202c:	74 03                	je     802031 <alloc_block_FF+0x13>
  80202e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802031:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802035:	77 07                	ja     80203e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802037:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80203e:	a1 24 50 80 00       	mov    0x805024,%eax
  802043:	85 c0                	test   %eax,%eax
  802045:	75 73                	jne    8020ba <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	83 c0 10             	add    $0x10,%eax
  80204d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802050:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80205a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205d:	01 d0                	add    %edx,%eax
  80205f:	48                   	dec    %eax
  802060:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802063:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802066:	ba 00 00 00 00       	mov    $0x0,%edx
  80206b:	f7 75 ec             	divl   -0x14(%ebp)
  80206e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802071:	29 d0                	sub    %edx,%eax
  802073:	c1 e8 0c             	shr    $0xc,%eax
  802076:	83 ec 0c             	sub    $0xc,%esp
  802079:	50                   	push   %eax
  80207a:	e8 1e f1 ff ff       	call   80119d <sbrk>
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802085:	83 ec 0c             	sub    $0xc,%esp
  802088:	6a 00                	push   $0x0
  80208a:	e8 0e f1 ff ff       	call   80119d <sbrk>
  80208f:	83 c4 10             	add    $0x10,%esp
  802092:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802095:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802098:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80209b:	83 ec 08             	sub    $0x8,%esp
  80209e:	50                   	push   %eax
  80209f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020a2:	e8 5b fd ff ff       	call   801e02 <initialize_dynamic_allocator>
  8020a7:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	68 87 42 80 00       	push   $0x804287
  8020b2:	e8 4c e3 ff ff       	call   800403 <cprintf>
  8020b7:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8020ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020be:	75 0a                	jne    8020ca <alloc_block_FF+0xac>
	        return NULL;
  8020c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c5:	e9 0e 04 00 00       	jmp    8024d8 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8020ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8020d1:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d9:	e9 f3 02 00 00       	jmp    8023d1 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8020e4:	83 ec 0c             	sub    $0xc,%esp
  8020e7:	ff 75 bc             	pushl  -0x44(%ebp)
  8020ea:	e8 af fb ff ff       	call   801c9e <get_block_size>
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	83 c0 08             	add    $0x8,%eax
  8020fb:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8020fe:	0f 87 c5 02 00 00    	ja     8023c9 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	83 c0 18             	add    $0x18,%eax
  80210a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  80210d:	0f 87 19 02 00 00    	ja     80232c <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  802113:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802116:	2b 45 08             	sub    0x8(%ebp),%eax
  802119:	83 e8 08             	sub    $0x8,%eax
  80211c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	8d 50 08             	lea    0x8(%eax),%edx
  802125:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802128:	01 d0                	add    %edx,%eax
  80212a:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	83 c0 08             	add    $0x8,%eax
  802133:	83 ec 04             	sub    $0x4,%esp
  802136:	6a 01                	push   $0x1
  802138:	50                   	push   %eax
  802139:	ff 75 bc             	pushl  -0x44(%ebp)
  80213c:	e8 ae fe ff ff       	call   801fef <set_block_data>
  802141:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  802144:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802147:	8b 40 04             	mov    0x4(%eax),%eax
  80214a:	85 c0                	test   %eax,%eax
  80214c:	75 68                	jne    8021b6 <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  80214e:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802152:	75 17                	jne    80216b <alloc_block_FF+0x14d>
  802154:	83 ec 04             	sub    $0x4,%esp
  802157:	68 64 42 80 00       	push   $0x804264
  80215c:	68 d7 00 00 00       	push   $0xd7
  802161:	68 49 42 80 00       	push   $0x804249
  802166:	e8 3f 16 00 00       	call   8037aa <_panic>
  80216b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802171:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802174:	89 10                	mov    %edx,(%eax)
  802176:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802179:	8b 00                	mov    (%eax),%eax
  80217b:	85 c0                	test   %eax,%eax
  80217d:	74 0d                	je     80218c <alloc_block_FF+0x16e>
  80217f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802184:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802187:	89 50 04             	mov    %edx,0x4(%eax)
  80218a:	eb 08                	jmp    802194 <alloc_block_FF+0x176>
  80218c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80218f:	a3 30 50 80 00       	mov    %eax,0x805030
  802194:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802197:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80219c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80219f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a6:	a1 38 50 80 00       	mov    0x805038,%eax
  8021ab:	40                   	inc    %eax
  8021ac:	a3 38 50 80 00       	mov    %eax,0x805038
  8021b1:	e9 dc 00 00 00       	jmp    802292 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8021b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b9:	8b 00                	mov    (%eax),%eax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	75 65                	jne    802224 <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8021bf:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8021c3:	75 17                	jne    8021dc <alloc_block_FF+0x1be>
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	68 98 42 80 00       	push   $0x804298
  8021cd:	68 db 00 00 00       	push   $0xdb
  8021d2:	68 49 42 80 00       	push   $0x804249
  8021d7:	e8 ce 15 00 00       	call   8037aa <_panic>
  8021dc:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8021e2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021e5:	89 50 04             	mov    %edx,0x4(%eax)
  8021e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8021eb:	8b 40 04             	mov    0x4(%eax),%eax
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	74 0c                	je     8021fe <alloc_block_FF+0x1e0>
  8021f2:	a1 30 50 80 00       	mov    0x805030,%eax
  8021f7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8021fa:	89 10                	mov    %edx,(%eax)
  8021fc:	eb 08                	jmp    802206 <alloc_block_FF+0x1e8>
  8021fe:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802201:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802206:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802209:	a3 30 50 80 00       	mov    %eax,0x805030
  80220e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802211:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802217:	a1 38 50 80 00       	mov    0x805038,%eax
  80221c:	40                   	inc    %eax
  80221d:	a3 38 50 80 00       	mov    %eax,0x805038
  802222:	eb 6e                	jmp    802292 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  802224:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802228:	74 06                	je     802230 <alloc_block_FF+0x212>
  80222a:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80222e:	75 17                	jne    802247 <alloc_block_FF+0x229>
  802230:	83 ec 04             	sub    $0x4,%esp
  802233:	68 bc 42 80 00       	push   $0x8042bc
  802238:	68 df 00 00 00       	push   $0xdf
  80223d:	68 49 42 80 00       	push   $0x804249
  802242:	e8 63 15 00 00       	call   8037aa <_panic>
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	8b 10                	mov    (%eax),%edx
  80224c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80224f:	89 10                	mov    %edx,(%eax)
  802251:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802254:	8b 00                	mov    (%eax),%eax
  802256:	85 c0                	test   %eax,%eax
  802258:	74 0b                	je     802265 <alloc_block_FF+0x247>
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	8b 00                	mov    (%eax),%eax
  80225f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802262:	89 50 04             	mov    %edx,0x4(%eax)
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80226b:	89 10                	mov    %edx,(%eax)
  80226d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802273:	89 50 04             	mov    %edx,0x4(%eax)
  802276:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	85 c0                	test   %eax,%eax
  80227d:	75 08                	jne    802287 <alloc_block_FF+0x269>
  80227f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802282:	a3 30 50 80 00       	mov    %eax,0x805030
  802287:	a1 38 50 80 00       	mov    0x805038,%eax
  80228c:	40                   	inc    %eax
  80228d:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802296:	75 17                	jne    8022af <alloc_block_FF+0x291>
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	68 2b 42 80 00       	push   $0x80422b
  8022a0:	68 e1 00 00 00       	push   $0xe1
  8022a5:	68 49 42 80 00       	push   $0x804249
  8022aa:	e8 fb 14 00 00       	call   8037aa <_panic>
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 00                	mov    (%eax),%eax
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	74 10                	je     8022c8 <alloc_block_FF+0x2aa>
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 00                	mov    (%eax),%eax
  8022bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c0:	8b 52 04             	mov    0x4(%edx),%edx
  8022c3:	89 50 04             	mov    %edx,0x4(%eax)
  8022c6:	eb 0b                	jmp    8022d3 <alloc_block_FF+0x2b5>
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 40 04             	mov    0x4(%eax),%eax
  8022ce:	a3 30 50 80 00       	mov    %eax,0x805030
  8022d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d6:	8b 40 04             	mov    0x4(%eax),%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	74 0f                	je     8022ec <alloc_block_FF+0x2ce>
  8022dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e0:	8b 40 04             	mov    0x4(%eax),%eax
  8022e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e6:	8b 12                	mov    (%edx),%edx
  8022e8:	89 10                	mov    %edx,(%eax)
  8022ea:	eb 0a                	jmp    8022f6 <alloc_block_FF+0x2d8>
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	8b 00                	mov    (%eax),%eax
  8022f1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802309:	a1 38 50 80 00       	mov    0x805038,%eax
  80230e:	48                   	dec    %eax
  80230f:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(new_block_va, remaining_size, 0);
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	6a 00                	push   $0x0
  802319:	ff 75 b4             	pushl  -0x4c(%ebp)
  80231c:	ff 75 b0             	pushl  -0x50(%ebp)
  80231f:	e8 cb fc ff ff       	call   801fef <set_block_data>
  802324:	83 c4 10             	add    $0x10,%esp
  802327:	e9 95 00 00 00       	jmp    8023c1 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  80232c:	83 ec 04             	sub    $0x4,%esp
  80232f:	6a 01                	push   $0x1
  802331:	ff 75 b8             	pushl  -0x48(%ebp)
  802334:	ff 75 bc             	pushl  -0x44(%ebp)
  802337:	e8 b3 fc ff ff       	call   801fef <set_block_data>
  80233c:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  80233f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802343:	75 17                	jne    80235c <alloc_block_FF+0x33e>
  802345:	83 ec 04             	sub    $0x4,%esp
  802348:	68 2b 42 80 00       	push   $0x80422b
  80234d:	68 e8 00 00 00       	push   $0xe8
  802352:	68 49 42 80 00       	push   $0x804249
  802357:	e8 4e 14 00 00       	call   8037aa <_panic>
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	8b 00                	mov    (%eax),%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	74 10                	je     802375 <alloc_block_FF+0x357>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 00                	mov    (%eax),%eax
  80236a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236d:	8b 52 04             	mov    0x4(%edx),%edx
  802370:	89 50 04             	mov    %edx,0x4(%eax)
  802373:	eb 0b                	jmp    802380 <alloc_block_FF+0x362>
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	8b 40 04             	mov    0x4(%eax),%eax
  80237b:	a3 30 50 80 00       	mov    %eax,0x805030
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	8b 40 04             	mov    0x4(%eax),%eax
  802386:	85 c0                	test   %eax,%eax
  802388:	74 0f                	je     802399 <alloc_block_FF+0x37b>
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 40 04             	mov    0x4(%eax),%eax
  802390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802393:	8b 12                	mov    (%edx),%edx
  802395:	89 10                	mov    %edx,(%eax)
  802397:	eb 0a                	jmp    8023a3 <alloc_block_FF+0x385>
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b6:	a1 38 50 80 00       	mov    0x805038,%eax
  8023bb:	48                   	dec    %eax
  8023bc:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8023c1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8023c4:	e9 0f 01 00 00       	jmp    8024d8 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8023c9:	a1 34 50 80 00       	mov    0x805034,%eax
  8023ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d5:	74 07                	je     8023de <alloc_block_FF+0x3c0>
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	8b 00                	mov    (%eax),%eax
  8023dc:	eb 05                	jmp    8023e3 <alloc_block_FF+0x3c5>
  8023de:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e3:	a3 34 50 80 00       	mov    %eax,0x805034
  8023e8:	a1 34 50 80 00       	mov    0x805034,%eax
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	0f 85 e9 fc ff ff    	jne    8020de <alloc_block_FF+0xc0>
  8023f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f9:	0f 85 df fc ff ff    	jne    8020de <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	83 c0 08             	add    $0x8,%eax
  802405:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802408:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80240f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802412:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802415:	01 d0                	add    %edx,%eax
  802417:	48                   	dec    %eax
  802418:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80241b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80241e:	ba 00 00 00 00       	mov    $0x0,%edx
  802423:	f7 75 d8             	divl   -0x28(%ebp)
  802426:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802429:	29 d0                	sub    %edx,%eax
  80242b:	c1 e8 0c             	shr    $0xc,%eax
  80242e:	83 ec 0c             	sub    $0xc,%esp
  802431:	50                   	push   %eax
  802432:	e8 66 ed ff ff       	call   80119d <sbrk>
  802437:	83 c4 10             	add    $0x10,%esp
  80243a:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  80243d:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802441:	75 0a                	jne    80244d <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  802443:	b8 00 00 00 00       	mov    $0x0,%eax
  802448:	e9 8b 00 00 00       	jmp    8024d8 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  80244d:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802454:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802457:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80245a:	01 d0                	add    %edx,%eax
  80245c:	48                   	dec    %eax
  80245d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802460:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802463:	ba 00 00 00 00       	mov    $0x0,%edx
  802468:	f7 75 cc             	divl   -0x34(%ebp)
  80246b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80246e:	29 d0                	sub    %edx,%eax
  802470:	8d 50 fc             	lea    -0x4(%eax),%edx
  802473:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802476:	01 d0                	add    %edx,%eax
  802478:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  80247d:	a1 40 50 80 00       	mov    0x805040,%eax
  802482:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802488:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  80248f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802492:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802495:	01 d0                	add    %edx,%eax
  802497:	48                   	dec    %eax
  802498:	89 45 c0             	mov    %eax,-0x40(%ebp)
  80249b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80249e:	ba 00 00 00 00       	mov    $0x0,%edx
  8024a3:	f7 75 c4             	divl   -0x3c(%ebp)
  8024a6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8024a9:	29 d0                	sub    %edx,%eax
  8024ab:	83 ec 04             	sub    $0x4,%esp
  8024ae:	6a 01                	push   $0x1
  8024b0:	50                   	push   %eax
  8024b1:	ff 75 d0             	pushl  -0x30(%ebp)
  8024b4:	e8 36 fb ff ff       	call   801fef <set_block_data>
  8024b9:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8024bc:	83 ec 0c             	sub    $0xc,%esp
  8024bf:	ff 75 d0             	pushl  -0x30(%ebp)
  8024c2:	e8 1b 0a 00 00       	call   802ee2 <free_block>
  8024c7:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8024ca:	83 ec 0c             	sub    $0xc,%esp
  8024cd:	ff 75 08             	pushl  0x8(%ebp)
  8024d0:	e8 49 fb ff ff       	call   80201e <alloc_block_FF>
  8024d5:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e3:	83 e0 01             	and    $0x1,%eax
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	74 03                	je     8024ed <alloc_block_BF+0x13>
  8024ea:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024ed:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024f1:	77 07                	ja     8024fa <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024f3:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024fa:	a1 24 50 80 00       	mov    0x805024,%eax
  8024ff:	85 c0                	test   %eax,%eax
  802501:	75 73                	jne    802576 <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	83 c0 10             	add    $0x10,%eax
  802509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80250c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802513:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802516:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802519:	01 d0                	add    %edx,%eax
  80251b:	48                   	dec    %eax
  80251c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80251f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802522:	ba 00 00 00 00       	mov    $0x0,%edx
  802527:	f7 75 e0             	divl   -0x20(%ebp)
  80252a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80252d:	29 d0                	sub    %edx,%eax
  80252f:	c1 e8 0c             	shr    $0xc,%eax
  802532:	83 ec 0c             	sub    $0xc,%esp
  802535:	50                   	push   %eax
  802536:	e8 62 ec ff ff       	call   80119d <sbrk>
  80253b:	83 c4 10             	add    $0x10,%esp
  80253e:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802541:	83 ec 0c             	sub    $0xc,%esp
  802544:	6a 00                	push   $0x0
  802546:	e8 52 ec ff ff       	call   80119d <sbrk>
  80254b:	83 c4 10             	add    $0x10,%esp
  80254e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802551:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802554:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802557:	83 ec 08             	sub    $0x8,%esp
  80255a:	50                   	push   %eax
  80255b:	ff 75 d8             	pushl  -0x28(%ebp)
  80255e:	e8 9f f8 ff ff       	call   801e02 <initialize_dynamic_allocator>
  802563:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  802566:	83 ec 0c             	sub    $0xc,%esp
  802569:	68 87 42 80 00       	push   $0x804287
  80256e:	e8 90 de ff ff       	call   800403 <cprintf>
  802573:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  802576:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  80257d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  802584:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  80258b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802592:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802597:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259a:	e9 1d 01 00 00       	jmp    8026bc <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8025a5:	83 ec 0c             	sub    $0xc,%esp
  8025a8:	ff 75 a8             	pushl  -0x58(%ebp)
  8025ab:	e8 ee f6 ff ff       	call   801c9e <get_block_size>
  8025b0:	83 c4 10             	add    $0x10,%esp
  8025b3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	83 c0 08             	add    $0x8,%eax
  8025bc:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025bf:	0f 87 ef 00 00 00    	ja     8026b4 <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	83 c0 18             	add    $0x18,%eax
  8025cb:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025ce:	77 1d                	ja     8025ed <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8025d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025d6:	0f 86 d8 00 00 00    	jbe    8026b4 <alloc_block_BF+0x1da>
				{
					best_va = va;
  8025dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8025df:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8025e2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8025e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025e8:	e9 c7 00 00 00       	jmp    8026b4 <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	83 c0 08             	add    $0x8,%eax
  8025f3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8025f6:	0f 85 9d 00 00 00    	jne    802699 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8025fc:	83 ec 04             	sub    $0x4,%esp
  8025ff:	6a 01                	push   $0x1
  802601:	ff 75 a4             	pushl  -0x5c(%ebp)
  802604:	ff 75 a8             	pushl  -0x58(%ebp)
  802607:	e8 e3 f9 ff ff       	call   801fef <set_block_data>
  80260c:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  80260f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802613:	75 17                	jne    80262c <alloc_block_BF+0x152>
  802615:	83 ec 04             	sub    $0x4,%esp
  802618:	68 2b 42 80 00       	push   $0x80422b
  80261d:	68 2c 01 00 00       	push   $0x12c
  802622:	68 49 42 80 00       	push   $0x804249
  802627:	e8 7e 11 00 00       	call   8037aa <_panic>
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 00                	mov    (%eax),%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	74 10                	je     802645 <alloc_block_BF+0x16b>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 00                	mov    (%eax),%eax
  80263a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263d:	8b 52 04             	mov    0x4(%edx),%edx
  802640:	89 50 04             	mov    %edx,0x4(%eax)
  802643:	eb 0b                	jmp    802650 <alloc_block_BF+0x176>
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 40 04             	mov    0x4(%eax),%eax
  80264b:	a3 30 50 80 00       	mov    %eax,0x805030
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 40 04             	mov    0x4(%eax),%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	74 0f                	je     802669 <alloc_block_BF+0x18f>
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 04             	mov    0x4(%eax),%eax
  802660:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802663:	8b 12                	mov    (%edx),%edx
  802665:	89 10                	mov    %edx,(%eax)
  802667:	eb 0a                	jmp    802673 <alloc_block_BF+0x199>
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 00                	mov    (%eax),%eax
  80266e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802686:	a1 38 50 80 00       	mov    0x805038,%eax
  80268b:	48                   	dec    %eax
  80268c:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802691:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802694:	e9 24 04 00 00       	jmp    802abd <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  802699:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269c:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80269f:	76 13                	jbe    8026b4 <alloc_block_BF+0x1da>
					{
						internal = 1;
  8026a1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8026a8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8026ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8026b4:	a1 34 50 80 00       	mov    0x805034,%eax
  8026b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c0:	74 07                	je     8026c9 <alloc_block_BF+0x1ef>
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 00                	mov    (%eax),%eax
  8026c7:	eb 05                	jmp    8026ce <alloc_block_BF+0x1f4>
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ce:	a3 34 50 80 00       	mov    %eax,0x805034
  8026d3:	a1 34 50 80 00       	mov    0x805034,%eax
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	0f 85 bf fe ff ff    	jne    80259f <alloc_block_BF+0xc5>
  8026e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e4:	0f 85 b5 fe ff ff    	jne    80259f <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8026ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026ee:	0f 84 26 02 00 00    	je     80291a <alloc_block_BF+0x440>
  8026f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026f8:	0f 85 1c 02 00 00    	jne    80291a <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8026fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802701:	2b 45 08             	sub    0x8(%ebp),%eax
  802704:	83 e8 08             	sub    $0x8,%eax
  802707:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  80270a:	8b 45 08             	mov    0x8(%ebp),%eax
  80270d:	8d 50 08             	lea    0x8(%eax),%edx
  802710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802713:	01 d0                	add    %edx,%eax
  802715:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802718:	8b 45 08             	mov    0x8(%ebp),%eax
  80271b:	83 c0 08             	add    $0x8,%eax
  80271e:	83 ec 04             	sub    $0x4,%esp
  802721:	6a 01                	push   $0x1
  802723:	50                   	push   %eax
  802724:	ff 75 f0             	pushl  -0x10(%ebp)
  802727:	e8 c3 f8 ff ff       	call   801fef <set_block_data>
  80272c:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  80272f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802732:	8b 40 04             	mov    0x4(%eax),%eax
  802735:	85 c0                	test   %eax,%eax
  802737:	75 68                	jne    8027a1 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802739:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80273d:	75 17                	jne    802756 <alloc_block_BF+0x27c>
  80273f:	83 ec 04             	sub    $0x4,%esp
  802742:	68 64 42 80 00       	push   $0x804264
  802747:	68 45 01 00 00       	push   $0x145
  80274c:	68 49 42 80 00       	push   $0x804249
  802751:	e8 54 10 00 00       	call   8037aa <_panic>
  802756:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80275c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80275f:	89 10                	mov    %edx,(%eax)
  802761:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	85 c0                	test   %eax,%eax
  802768:	74 0d                	je     802777 <alloc_block_BF+0x29d>
  80276a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80276f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802772:	89 50 04             	mov    %edx,0x4(%eax)
  802775:	eb 08                	jmp    80277f <alloc_block_BF+0x2a5>
  802777:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80277a:	a3 30 50 80 00       	mov    %eax,0x805030
  80277f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802782:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802787:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80278a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802791:	a1 38 50 80 00       	mov    0x805038,%eax
  802796:	40                   	inc    %eax
  802797:	a3 38 50 80 00       	mov    %eax,0x805038
  80279c:	e9 dc 00 00 00       	jmp    80287d <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8027a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	85 c0                	test   %eax,%eax
  8027a8:	75 65                	jne    80280f <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8027aa:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8027ae:	75 17                	jne    8027c7 <alloc_block_BF+0x2ed>
  8027b0:	83 ec 04             	sub    $0x4,%esp
  8027b3:	68 98 42 80 00       	push   $0x804298
  8027b8:	68 4a 01 00 00       	push   $0x14a
  8027bd:	68 49 42 80 00       	push   $0x804249
  8027c2:	e8 e3 0f 00 00       	call   8037aa <_panic>
  8027c7:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8027cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d0:	89 50 04             	mov    %edx,0x4(%eax)
  8027d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027d6:	8b 40 04             	mov    0x4(%eax),%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	74 0c                	je     8027e9 <alloc_block_BF+0x30f>
  8027dd:	a1 30 50 80 00       	mov    0x805030,%eax
  8027e2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8027e5:	89 10                	mov    %edx,(%eax)
  8027e7:	eb 08                	jmp    8027f1 <alloc_block_BF+0x317>
  8027e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027ec:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8027f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027f4:	a3 30 50 80 00       	mov    %eax,0x805030
  8027f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802802:	a1 38 50 80 00       	mov    0x805038,%eax
  802807:	40                   	inc    %eax
  802808:	a3 38 50 80 00       	mov    %eax,0x805038
  80280d:	eb 6e                	jmp    80287d <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  80280f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802813:	74 06                	je     80281b <alloc_block_BF+0x341>
  802815:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802819:	75 17                	jne    802832 <alloc_block_BF+0x358>
  80281b:	83 ec 04             	sub    $0x4,%esp
  80281e:	68 bc 42 80 00       	push   $0x8042bc
  802823:	68 4f 01 00 00       	push   $0x14f
  802828:	68 49 42 80 00       	push   $0x804249
  80282d:	e8 78 0f 00 00       	call   8037aa <_panic>
  802832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802835:	8b 10                	mov    (%eax),%edx
  802837:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283a:	89 10                	mov    %edx,(%eax)
  80283c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80283f:	8b 00                	mov    (%eax),%eax
  802841:	85 c0                	test   %eax,%eax
  802843:	74 0b                	je     802850 <alloc_block_BF+0x376>
  802845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802848:	8b 00                	mov    (%eax),%eax
  80284a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80284d:	89 50 04             	mov    %edx,0x4(%eax)
  802850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802853:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802856:	89 10                	mov    %edx,(%eax)
  802858:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285e:	89 50 04             	mov    %edx,0x4(%eax)
  802861:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	85 c0                	test   %eax,%eax
  802868:	75 08                	jne    802872 <alloc_block_BF+0x398>
  80286a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80286d:	a3 30 50 80 00       	mov    %eax,0x805030
  802872:	a1 38 50 80 00       	mov    0x805038,%eax
  802877:	40                   	inc    %eax
  802878:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  80287d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802881:	75 17                	jne    80289a <alloc_block_BF+0x3c0>
  802883:	83 ec 04             	sub    $0x4,%esp
  802886:	68 2b 42 80 00       	push   $0x80422b
  80288b:	68 51 01 00 00       	push   $0x151
  802890:	68 49 42 80 00       	push   $0x804249
  802895:	e8 10 0f 00 00       	call   8037aa <_panic>
  80289a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289d:	8b 00                	mov    (%eax),%eax
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	74 10                	je     8028b3 <alloc_block_BF+0x3d9>
  8028a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a6:	8b 00                	mov    (%eax),%eax
  8028a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ab:	8b 52 04             	mov    0x4(%edx),%edx
  8028ae:	89 50 04             	mov    %edx,0x4(%eax)
  8028b1:	eb 0b                	jmp    8028be <alloc_block_BF+0x3e4>
  8028b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b6:	8b 40 04             	mov    0x4(%eax),%eax
  8028b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8028be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	85 c0                	test   %eax,%eax
  8028c6:	74 0f                	je     8028d7 <alloc_block_BF+0x3fd>
  8028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d1:	8b 12                	mov    (%edx),%edx
  8028d3:	89 10                	mov    %edx,(%eax)
  8028d5:	eb 0a                	jmp    8028e1 <alloc_block_BF+0x407>
  8028d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f4:	a1 38 50 80 00       	mov    0x805038,%eax
  8028f9:	48                   	dec    %eax
  8028fa:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8028ff:	83 ec 04             	sub    $0x4,%esp
  802902:	6a 00                	push   $0x0
  802904:	ff 75 d0             	pushl  -0x30(%ebp)
  802907:	ff 75 cc             	pushl  -0x34(%ebp)
  80290a:	e8 e0 f6 ff ff       	call   801fef <set_block_data>
  80290f:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802915:	e9 a3 01 00 00       	jmp    802abd <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  80291a:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  80291e:	0f 85 9d 00 00 00    	jne    8029c1 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802924:	83 ec 04             	sub    $0x4,%esp
  802927:	6a 01                	push   $0x1
  802929:	ff 75 ec             	pushl  -0x14(%ebp)
  80292c:	ff 75 f0             	pushl  -0x10(%ebp)
  80292f:	e8 bb f6 ff ff       	call   801fef <set_block_data>
  802934:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802937:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80293b:	75 17                	jne    802954 <alloc_block_BF+0x47a>
  80293d:	83 ec 04             	sub    $0x4,%esp
  802940:	68 2b 42 80 00       	push   $0x80422b
  802945:	68 58 01 00 00       	push   $0x158
  80294a:	68 49 42 80 00       	push   $0x804249
  80294f:	e8 56 0e 00 00       	call   8037aa <_panic>
  802954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	85 c0                	test   %eax,%eax
  80295b:	74 10                	je     80296d <alloc_block_BF+0x493>
  80295d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802965:	8b 52 04             	mov    0x4(%edx),%edx
  802968:	89 50 04             	mov    %edx,0x4(%eax)
  80296b:	eb 0b                	jmp    802978 <alloc_block_BF+0x49e>
  80296d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802970:	8b 40 04             	mov    0x4(%eax),%eax
  802973:	a3 30 50 80 00       	mov    %eax,0x805030
  802978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297b:	8b 40 04             	mov    0x4(%eax),%eax
  80297e:	85 c0                	test   %eax,%eax
  802980:	74 0f                	je     802991 <alloc_block_BF+0x4b7>
  802982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802985:	8b 40 04             	mov    0x4(%eax),%eax
  802988:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298b:	8b 12                	mov    (%edx),%edx
  80298d:	89 10                	mov    %edx,(%eax)
  80298f:	eb 0a                	jmp    80299b <alloc_block_BF+0x4c1>
  802991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802994:	8b 00                	mov    (%eax),%eax
  802996:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80299b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ae:	a1 38 50 80 00       	mov    0x805038,%eax
  8029b3:	48                   	dec    %eax
  8029b4:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  8029b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bc:	e9 fc 00 00 00       	jmp    802abd <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	83 c0 08             	add    $0x8,%eax
  8029c7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8029ca:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8029d1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8029d4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029d7:	01 d0                	add    %edx,%eax
  8029d9:	48                   	dec    %eax
  8029da:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8029dd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8029e5:	f7 75 c4             	divl   -0x3c(%ebp)
  8029e8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029eb:	29 d0                	sub    %edx,%eax
  8029ed:	c1 e8 0c             	shr    $0xc,%eax
  8029f0:	83 ec 0c             	sub    $0xc,%esp
  8029f3:	50                   	push   %eax
  8029f4:	e8 a4 e7 ff ff       	call   80119d <sbrk>
  8029f9:	83 c4 10             	add    $0x10,%esp
  8029fc:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  8029ff:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802a03:	75 0a                	jne    802a0f <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802a05:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0a:	e9 ae 00 00 00       	jmp    802abd <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802a0f:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802a16:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a19:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a1c:	01 d0                	add    %edx,%eax
  802a1e:	48                   	dec    %eax
  802a1f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802a22:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a25:	ba 00 00 00 00       	mov    $0x0,%edx
  802a2a:	f7 75 b8             	divl   -0x48(%ebp)
  802a2d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802a30:	29 d0                	sub    %edx,%eax
  802a32:	8d 50 fc             	lea    -0x4(%eax),%edx
  802a35:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a38:	01 d0                	add    %edx,%eax
  802a3a:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802a3f:	a1 40 50 80 00       	mov    0x805040,%eax
  802a44:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802a4a:	83 ec 0c             	sub    $0xc,%esp
  802a4d:	68 f0 42 80 00       	push   $0x8042f0
  802a52:	e8 ac d9 ff ff       	call   800403 <cprintf>
  802a57:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802a5a:	83 ec 08             	sub    $0x8,%esp
  802a5d:	ff 75 bc             	pushl  -0x44(%ebp)
  802a60:	68 f5 42 80 00       	push   $0x8042f5
  802a65:	e8 99 d9 ff ff       	call   800403 <cprintf>
  802a6a:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802a6d:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a74:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802a77:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a7a:	01 d0                	add    %edx,%eax
  802a7c:	48                   	dec    %eax
  802a7d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a80:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a83:	ba 00 00 00 00       	mov    $0x0,%edx
  802a88:	f7 75 b0             	divl   -0x50(%ebp)
  802a8b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a8e:	29 d0                	sub    %edx,%eax
  802a90:	83 ec 04             	sub    $0x4,%esp
  802a93:	6a 01                	push   $0x1
  802a95:	50                   	push   %eax
  802a96:	ff 75 bc             	pushl  -0x44(%ebp)
  802a99:	e8 51 f5 ff ff       	call   801fef <set_block_data>
  802a9e:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802aa1:	83 ec 0c             	sub    $0xc,%esp
  802aa4:	ff 75 bc             	pushl  -0x44(%ebp)
  802aa7:	e8 36 04 00 00       	call   802ee2 <free_block>
  802aac:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802aaf:	83 ec 0c             	sub    $0xc,%esp
  802ab2:	ff 75 08             	pushl  0x8(%ebp)
  802ab5:	e8 20 fa ff ff       	call   8024da <alloc_block_BF>
  802aba:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802abd:	c9                   	leave  
  802abe:	c3                   	ret    

00802abf <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802abf:	55                   	push   %ebp
  802ac0:	89 e5                	mov    %esp,%ebp
  802ac2:	53                   	push   %ebx
  802ac3:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802ac6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802acd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ad4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad8:	74 1e                	je     802af8 <merging+0x39>
  802ada:	ff 75 08             	pushl  0x8(%ebp)
  802add:	e8 bc f1 ff ff       	call   801c9e <get_block_size>
  802ae2:	83 c4 04             	add    $0x4,%esp
  802ae5:	89 c2                	mov    %eax,%edx
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	01 d0                	add    %edx,%eax
  802aec:	3b 45 10             	cmp    0x10(%ebp),%eax
  802aef:	75 07                	jne    802af8 <merging+0x39>
		prev_is_free = 1;
  802af1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802af8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802afc:	74 1e                	je     802b1c <merging+0x5d>
  802afe:	ff 75 10             	pushl  0x10(%ebp)
  802b01:	e8 98 f1 ff ff       	call   801c9e <get_block_size>
  802b06:	83 c4 04             	add    $0x4,%esp
  802b09:	89 c2                	mov    %eax,%edx
  802b0b:	8b 45 10             	mov    0x10(%ebp),%eax
  802b0e:	01 d0                	add    %edx,%eax
  802b10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b13:	75 07                	jne    802b1c <merging+0x5d>
		next_is_free = 1;
  802b15:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802b1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b20:	0f 84 cc 00 00 00    	je     802bf2 <merging+0x133>
  802b26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b2a:	0f 84 c2 00 00 00    	je     802bf2 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802b30:	ff 75 08             	pushl  0x8(%ebp)
  802b33:	e8 66 f1 ff ff       	call   801c9e <get_block_size>
  802b38:	83 c4 04             	add    $0x4,%esp
  802b3b:	89 c3                	mov    %eax,%ebx
  802b3d:	ff 75 10             	pushl  0x10(%ebp)
  802b40:	e8 59 f1 ff ff       	call   801c9e <get_block_size>
  802b45:	83 c4 04             	add    $0x4,%esp
  802b48:	01 c3                	add    %eax,%ebx
  802b4a:	ff 75 0c             	pushl  0xc(%ebp)
  802b4d:	e8 4c f1 ff ff       	call   801c9e <get_block_size>
  802b52:	83 c4 04             	add    $0x4,%esp
  802b55:	01 d8                	add    %ebx,%eax
  802b57:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802b5a:	6a 00                	push   $0x0
  802b5c:	ff 75 ec             	pushl  -0x14(%ebp)
  802b5f:	ff 75 08             	pushl  0x8(%ebp)
  802b62:	e8 88 f4 ff ff       	call   801fef <set_block_data>
  802b67:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802b6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b6e:	75 17                	jne    802b87 <merging+0xc8>
  802b70:	83 ec 04             	sub    $0x4,%esp
  802b73:	68 2b 42 80 00       	push   $0x80422b
  802b78:	68 7d 01 00 00       	push   $0x17d
  802b7d:	68 49 42 80 00       	push   $0x804249
  802b82:	e8 23 0c 00 00       	call   8037aa <_panic>
  802b87:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	85 c0                	test   %eax,%eax
  802b8e:	74 10                	je     802ba0 <merging+0xe1>
  802b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b98:	8b 52 04             	mov    0x4(%edx),%edx
  802b9b:	89 50 04             	mov    %edx,0x4(%eax)
  802b9e:	eb 0b                	jmp    802bab <merging+0xec>
  802ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba3:	8b 40 04             	mov    0x4(%eax),%eax
  802ba6:	a3 30 50 80 00       	mov    %eax,0x805030
  802bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bae:	8b 40 04             	mov    0x4(%eax),%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	74 0f                	je     802bc4 <merging+0x105>
  802bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bb8:	8b 40 04             	mov    0x4(%eax),%eax
  802bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bbe:	8b 12                	mov    (%edx),%edx
  802bc0:	89 10                	mov    %edx,(%eax)
  802bc2:	eb 0a                	jmp    802bce <merging+0x10f>
  802bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bc7:	8b 00                	mov    (%eax),%eax
  802bc9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be1:	a1 38 50 80 00       	mov    0x805038,%eax
  802be6:	48                   	dec    %eax
  802be7:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802bec:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802bed:	e9 ea 02 00 00       	jmp    802edc <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802bf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf6:	74 3b                	je     802c33 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802bf8:	83 ec 0c             	sub    $0xc,%esp
  802bfb:	ff 75 08             	pushl  0x8(%ebp)
  802bfe:	e8 9b f0 ff ff       	call   801c9e <get_block_size>
  802c03:	83 c4 10             	add    $0x10,%esp
  802c06:	89 c3                	mov    %eax,%ebx
  802c08:	83 ec 0c             	sub    $0xc,%esp
  802c0b:	ff 75 10             	pushl  0x10(%ebp)
  802c0e:	e8 8b f0 ff ff       	call   801c9e <get_block_size>
  802c13:	83 c4 10             	add    $0x10,%esp
  802c16:	01 d8                	add    %ebx,%eax
  802c18:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c1b:	83 ec 04             	sub    $0x4,%esp
  802c1e:	6a 00                	push   $0x0
  802c20:	ff 75 e8             	pushl  -0x18(%ebp)
  802c23:	ff 75 08             	pushl  0x8(%ebp)
  802c26:	e8 c4 f3 ff ff       	call   801fef <set_block_data>
  802c2b:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802c2e:	e9 a9 02 00 00       	jmp    802edc <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802c33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c37:	0f 84 2d 01 00 00    	je     802d6a <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802c3d:	83 ec 0c             	sub    $0xc,%esp
  802c40:	ff 75 10             	pushl  0x10(%ebp)
  802c43:	e8 56 f0 ff ff       	call   801c9e <get_block_size>
  802c48:	83 c4 10             	add    $0x10,%esp
  802c4b:	89 c3                	mov    %eax,%ebx
  802c4d:	83 ec 0c             	sub    $0xc,%esp
  802c50:	ff 75 0c             	pushl  0xc(%ebp)
  802c53:	e8 46 f0 ff ff       	call   801c9e <get_block_size>
  802c58:	83 c4 10             	add    $0x10,%esp
  802c5b:	01 d8                	add    %ebx,%eax
  802c5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802c60:	83 ec 04             	sub    $0x4,%esp
  802c63:	6a 00                	push   $0x0
  802c65:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c68:	ff 75 10             	pushl  0x10(%ebp)
  802c6b:	e8 7f f3 ff ff       	call   801fef <set_block_data>
  802c70:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802c73:	8b 45 10             	mov    0x10(%ebp),%eax
  802c76:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802c79:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c7d:	74 06                	je     802c85 <merging+0x1c6>
  802c7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c83:	75 17                	jne    802c9c <merging+0x1dd>
  802c85:	83 ec 04             	sub    $0x4,%esp
  802c88:	68 04 43 80 00       	push   $0x804304
  802c8d:	68 8d 01 00 00       	push   $0x18d
  802c92:	68 49 42 80 00       	push   $0x804249
  802c97:	e8 0e 0b 00 00       	call   8037aa <_panic>
  802c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9f:	8b 50 04             	mov    0x4(%eax),%edx
  802ca2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca5:	89 50 04             	mov    %edx,0x4(%eax)
  802ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cae:	89 10                	mov    %edx,(%eax)
  802cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb3:	8b 40 04             	mov    0x4(%eax),%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	74 0d                	je     802cc7 <merging+0x208>
  802cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cbd:	8b 40 04             	mov    0x4(%eax),%eax
  802cc0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cc3:	89 10                	mov    %edx,(%eax)
  802cc5:	eb 08                	jmp    802ccf <merging+0x210>
  802cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cca:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cd5:	89 50 04             	mov    %edx,0x4(%eax)
  802cd8:	a1 38 50 80 00       	mov    0x805038,%eax
  802cdd:	40                   	inc    %eax
  802cde:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802ce3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ce7:	75 17                	jne    802d00 <merging+0x241>
  802ce9:	83 ec 04             	sub    $0x4,%esp
  802cec:	68 2b 42 80 00       	push   $0x80422b
  802cf1:	68 8e 01 00 00       	push   $0x18e
  802cf6:	68 49 42 80 00       	push   $0x804249
  802cfb:	e8 aa 0a 00 00       	call   8037aa <_panic>
  802d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	74 10                	je     802d19 <merging+0x25a>
  802d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d11:	8b 52 04             	mov    0x4(%edx),%edx
  802d14:	89 50 04             	mov    %edx,0x4(%eax)
  802d17:	eb 0b                	jmp    802d24 <merging+0x265>
  802d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d1c:	8b 40 04             	mov    0x4(%eax),%eax
  802d1f:	a3 30 50 80 00       	mov    %eax,0x805030
  802d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d27:	8b 40 04             	mov    0x4(%eax),%eax
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	74 0f                	je     802d3d <merging+0x27e>
  802d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d31:	8b 40 04             	mov    0x4(%eax),%eax
  802d34:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d37:	8b 12                	mov    (%edx),%edx
  802d39:	89 10                	mov    %edx,(%eax)
  802d3b:	eb 0a                	jmp    802d47 <merging+0x288>
  802d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5a:	a1 38 50 80 00       	mov    0x805038,%eax
  802d5f:	48                   	dec    %eax
  802d60:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d65:	e9 72 01 00 00       	jmp    802edc <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802d6a:	8b 45 10             	mov    0x10(%ebp),%eax
  802d6d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802d70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d74:	74 79                	je     802def <merging+0x330>
  802d76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d7a:	74 73                	je     802def <merging+0x330>
  802d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d80:	74 06                	je     802d88 <merging+0x2c9>
  802d82:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d86:	75 17                	jne    802d9f <merging+0x2e0>
  802d88:	83 ec 04             	sub    $0x4,%esp
  802d8b:	68 bc 42 80 00       	push   $0x8042bc
  802d90:	68 94 01 00 00       	push   $0x194
  802d95:	68 49 42 80 00       	push   $0x804249
  802d9a:	e8 0b 0a 00 00       	call   8037aa <_panic>
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	8b 10                	mov    (%eax),%edx
  802da4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da7:	89 10                	mov    %edx,(%eax)
  802da9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dac:	8b 00                	mov    (%eax),%eax
  802dae:	85 c0                	test   %eax,%eax
  802db0:	74 0b                	je     802dbd <merging+0x2fe>
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	8b 00                	mov    (%eax),%eax
  802db7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dba:	89 50 04             	mov    %edx,0x4(%eax)
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dc3:	89 10                	mov    %edx,(%eax)
  802dc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcb:	89 50 04             	mov    %edx,0x4(%eax)
  802dce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	75 08                	jne    802ddf <merging+0x320>
  802dd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dda:	a3 30 50 80 00       	mov    %eax,0x805030
  802ddf:	a1 38 50 80 00       	mov    0x805038,%eax
  802de4:	40                   	inc    %eax
  802de5:	a3 38 50 80 00       	mov    %eax,0x805038
  802dea:	e9 ce 00 00 00       	jmp    802ebd <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802def:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df3:	74 65                	je     802e5a <merging+0x39b>
  802df5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802df9:	75 17                	jne    802e12 <merging+0x353>
  802dfb:	83 ec 04             	sub    $0x4,%esp
  802dfe:	68 98 42 80 00       	push   $0x804298
  802e03:	68 95 01 00 00       	push   $0x195
  802e08:	68 49 42 80 00       	push   $0x804249
  802e0d:	e8 98 09 00 00       	call   8037aa <_panic>
  802e12:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802e18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e1b:	89 50 04             	mov    %edx,0x4(%eax)
  802e1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e21:	8b 40 04             	mov    0x4(%eax),%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	74 0c                	je     802e34 <merging+0x375>
  802e28:	a1 30 50 80 00       	mov    0x805030,%eax
  802e2d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e30:	89 10                	mov    %edx,(%eax)
  802e32:	eb 08                	jmp    802e3c <merging+0x37d>
  802e34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e37:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e3f:	a3 30 50 80 00       	mov    %eax,0x805030
  802e44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4d:	a1 38 50 80 00       	mov    0x805038,%eax
  802e52:	40                   	inc    %eax
  802e53:	a3 38 50 80 00       	mov    %eax,0x805038
  802e58:	eb 63                	jmp    802ebd <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802e5a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e5e:	75 17                	jne    802e77 <merging+0x3b8>
  802e60:	83 ec 04             	sub    $0x4,%esp
  802e63:	68 64 42 80 00       	push   $0x804264
  802e68:	68 98 01 00 00       	push   $0x198
  802e6d:	68 49 42 80 00       	push   $0x804249
  802e72:	e8 33 09 00 00       	call   8037aa <_panic>
  802e77:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802e7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e80:	89 10                	mov    %edx,(%eax)
  802e82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	85 c0                	test   %eax,%eax
  802e89:	74 0d                	je     802e98 <merging+0x3d9>
  802e8b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e90:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e93:	89 50 04             	mov    %edx,0x4(%eax)
  802e96:	eb 08                	jmp    802ea0 <merging+0x3e1>
  802e98:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9b:	a3 30 50 80 00       	mov    %eax,0x805030
  802ea0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb2:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb7:	40                   	inc    %eax
  802eb8:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802ebd:	83 ec 0c             	sub    $0xc,%esp
  802ec0:	ff 75 10             	pushl  0x10(%ebp)
  802ec3:	e8 d6 ed ff ff       	call   801c9e <get_block_size>
  802ec8:	83 c4 10             	add    $0x10,%esp
  802ecb:	83 ec 04             	sub    $0x4,%esp
  802ece:	6a 00                	push   $0x0
  802ed0:	50                   	push   %eax
  802ed1:	ff 75 10             	pushl  0x10(%ebp)
  802ed4:	e8 16 f1 ff ff       	call   801fef <set_block_data>
  802ed9:	83 c4 10             	add    $0x10,%esp
	}
}
  802edc:	90                   	nop
  802edd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802ee0:	c9                   	leave  
  802ee1:	c3                   	ret    

00802ee2 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802ee2:	55                   	push   %ebp
  802ee3:	89 e5                	mov    %esp,%ebp
  802ee5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802ee8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802eed:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802ef0:	a1 30 50 80 00       	mov    0x805030,%eax
  802ef5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ef8:	73 1b                	jae    802f15 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802efa:	a1 30 50 80 00       	mov    0x805030,%eax
  802eff:	83 ec 04             	sub    $0x4,%esp
  802f02:	ff 75 08             	pushl  0x8(%ebp)
  802f05:	6a 00                	push   $0x0
  802f07:	50                   	push   %eax
  802f08:	e8 b2 fb ff ff       	call   802abf <merging>
  802f0d:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f10:	e9 8b 00 00 00       	jmp    802fa0 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802f15:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f1d:	76 18                	jbe    802f37 <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802f1f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f24:	83 ec 04             	sub    $0x4,%esp
  802f27:	ff 75 08             	pushl  0x8(%ebp)
  802f2a:	50                   	push   %eax
  802f2b:	6a 00                	push   $0x0
  802f2d:	e8 8d fb ff ff       	call   802abf <merging>
  802f32:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802f35:	eb 69                	jmp    802fa0 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f37:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3f:	eb 39                	jmp    802f7a <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f47:	73 29                	jae    802f72 <free_block+0x90>
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f51:	76 1f                	jbe    802f72 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  802f5b:	83 ec 04             	sub    $0x4,%esp
  802f5e:	ff 75 08             	pushl  0x8(%ebp)
  802f61:	ff 75 f0             	pushl  -0x10(%ebp)
  802f64:	ff 75 f4             	pushl  -0xc(%ebp)
  802f67:	e8 53 fb ff ff       	call   802abf <merging>
  802f6c:	83 c4 10             	add    $0x10,%esp
			break;
  802f6f:	90                   	nop
		}
	}
}
  802f70:	eb 2e                	jmp    802fa0 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  802f72:	a1 34 50 80 00       	mov    0x805034,%eax
  802f77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7e:	74 07                	je     802f87 <free_block+0xa5>
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	8b 00                	mov    (%eax),%eax
  802f85:	eb 05                	jmp    802f8c <free_block+0xaa>
  802f87:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8c:	a3 34 50 80 00       	mov    %eax,0x805034
  802f91:	a1 34 50 80 00       	mov    0x805034,%eax
  802f96:	85 c0                	test   %eax,%eax
  802f98:	75 a7                	jne    802f41 <free_block+0x5f>
  802f9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9e:	75 a1                	jne    802f41 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fa0:	90                   	nop
  802fa1:	c9                   	leave  
  802fa2:	c3                   	ret    

00802fa3 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  802fa3:	55                   	push   %ebp
  802fa4:	89 e5                	mov    %esp,%ebp
  802fa6:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  802fa9:	ff 75 08             	pushl  0x8(%ebp)
  802fac:	e8 ed ec ff ff       	call   801c9e <get_block_size>
  802fb1:	83 c4 04             	add    $0x4,%esp
  802fb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  802fb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802fbe:	eb 17                	jmp    802fd7 <copy_data+0x34>
  802fc0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc6:	01 c2                	add    %eax,%edx
  802fc8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	01 c8                	add    %ecx,%eax
  802fd0:	8a 00                	mov    (%eax),%al
  802fd2:	88 02                	mov    %al,(%edx)
  802fd4:	ff 45 fc             	incl   -0x4(%ebp)
  802fd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802fda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802fdd:	72 e1                	jb     802fc0 <copy_data+0x1d>
}
  802fdf:	90                   	nop
  802fe0:	c9                   	leave  
  802fe1:	c3                   	ret    

00802fe2 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  802fe2:	55                   	push   %ebp
  802fe3:	89 e5                	mov    %esp,%ebp
  802fe5:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  802fe8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fec:	75 23                	jne    803011 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  802fee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ff2:	74 13                	je     803007 <realloc_block_FF+0x25>
  802ff4:	83 ec 0c             	sub    $0xc,%esp
  802ff7:	ff 75 0c             	pushl  0xc(%ebp)
  802ffa:	e8 1f f0 ff ff       	call   80201e <alloc_block_FF>
  802fff:	83 c4 10             	add    $0x10,%esp
  803002:	e9 f4 06 00 00       	jmp    8036fb <realloc_block_FF+0x719>
		return NULL;
  803007:	b8 00 00 00 00       	mov    $0x0,%eax
  80300c:	e9 ea 06 00 00       	jmp    8036fb <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803011:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803015:	75 18                	jne    80302f <realloc_block_FF+0x4d>
	{
		free_block(va);
  803017:	83 ec 0c             	sub    $0xc,%esp
  80301a:	ff 75 08             	pushl  0x8(%ebp)
  80301d:	e8 c0 fe ff ff       	call   802ee2 <free_block>
  803022:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803025:	b8 00 00 00 00       	mov    $0x0,%eax
  80302a:	e9 cc 06 00 00       	jmp    8036fb <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  80302f:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803033:	77 07                	ja     80303c <realloc_block_FF+0x5a>
  803035:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  80303c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303f:	83 e0 01             	and    $0x1,%eax
  803042:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803045:	8b 45 0c             	mov    0xc(%ebp),%eax
  803048:	83 c0 08             	add    $0x8,%eax
  80304b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  80304e:	83 ec 0c             	sub    $0xc,%esp
  803051:	ff 75 08             	pushl  0x8(%ebp)
  803054:	e8 45 ec ff ff       	call   801c9e <get_block_size>
  803059:	83 c4 10             	add    $0x10,%esp
  80305c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80305f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803062:	83 e8 08             	sub    $0x8,%eax
  803065:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	83 e8 04             	sub    $0x4,%eax
  80306e:	8b 00                	mov    (%eax),%eax
  803070:	83 e0 fe             	and    $0xfffffffe,%eax
  803073:	89 c2                	mov    %eax,%edx
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	01 d0                	add    %edx,%eax
  80307a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  80307d:	83 ec 0c             	sub    $0xc,%esp
  803080:	ff 75 e4             	pushl  -0x1c(%ebp)
  803083:	e8 16 ec ff ff       	call   801c9e <get_block_size>
  803088:	83 c4 10             	add    $0x10,%esp
  80308b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  80308e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803091:	83 e8 08             	sub    $0x8,%eax
  803094:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  803097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80309d:	75 08                	jne    8030a7 <realloc_block_FF+0xc5>
	{
		 return va;
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	e9 54 06 00 00       	jmp    8036fb <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8030a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030aa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8030ad:	0f 83 e5 03 00 00    	jae    803498 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8030b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b6:	2b 45 0c             	sub    0xc(%ebp),%eax
  8030b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  8030bc:	83 ec 0c             	sub    $0xc,%esp
  8030bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8030c2:	e8 f0 eb ff ff       	call   801cb7 <is_free_block>
  8030c7:	83 c4 10             	add    $0x10,%esp
  8030ca:	84 c0                	test   %al,%al
  8030cc:	0f 84 3b 01 00 00    	je     80320d <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8030d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030d8:	01 d0                	add    %edx,%eax
  8030da:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8030dd:	83 ec 04             	sub    $0x4,%esp
  8030e0:	6a 01                	push   $0x1
  8030e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8030e5:	ff 75 08             	pushl  0x8(%ebp)
  8030e8:	e8 02 ef ff ff       	call   801fef <set_block_data>
  8030ed:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	83 e8 04             	sub    $0x4,%eax
  8030f6:	8b 00                	mov    (%eax),%eax
  8030f8:	83 e0 fe             	and    $0xfffffffe,%eax
  8030fb:	89 c2                	mov    %eax,%edx
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	01 d0                	add    %edx,%eax
  803102:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  803105:	83 ec 04             	sub    $0x4,%esp
  803108:	6a 00                	push   $0x0
  80310a:	ff 75 cc             	pushl  -0x34(%ebp)
  80310d:	ff 75 c8             	pushl  -0x38(%ebp)
  803110:	e8 da ee ff ff       	call   801fef <set_block_data>
  803115:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803118:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80311c:	74 06                	je     803124 <realloc_block_FF+0x142>
  80311e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803122:	75 17                	jne    80313b <realloc_block_FF+0x159>
  803124:	83 ec 04             	sub    $0x4,%esp
  803127:	68 bc 42 80 00       	push   $0x8042bc
  80312c:	68 f6 01 00 00       	push   $0x1f6
  803131:	68 49 42 80 00       	push   $0x804249
  803136:	e8 6f 06 00 00       	call   8037aa <_panic>
  80313b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313e:	8b 10                	mov    (%eax),%edx
  803140:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803143:	89 10                	mov    %edx,(%eax)
  803145:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	74 0b                	je     803159 <realloc_block_FF+0x177>
  80314e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803151:	8b 00                	mov    (%eax),%eax
  803153:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803156:	89 50 04             	mov    %edx,0x4(%eax)
  803159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80315f:	89 10                	mov    %edx,(%eax)
  803161:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803164:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803167:	89 50 04             	mov    %edx,0x4(%eax)
  80316a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	75 08                	jne    80317b <realloc_block_FF+0x199>
  803173:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803176:	a3 30 50 80 00       	mov    %eax,0x805030
  80317b:	a1 38 50 80 00       	mov    0x805038,%eax
  803180:	40                   	inc    %eax
  803181:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803186:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80318a:	75 17                	jne    8031a3 <realloc_block_FF+0x1c1>
  80318c:	83 ec 04             	sub    $0x4,%esp
  80318f:	68 2b 42 80 00       	push   $0x80422b
  803194:	68 f7 01 00 00       	push   $0x1f7
  803199:	68 49 42 80 00       	push   $0x804249
  80319e:	e8 07 06 00 00       	call   8037aa <_panic>
  8031a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a6:	8b 00                	mov    (%eax),%eax
  8031a8:	85 c0                	test   %eax,%eax
  8031aa:	74 10                	je     8031bc <realloc_block_FF+0x1da>
  8031ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031b4:	8b 52 04             	mov    0x4(%edx),%edx
  8031b7:	89 50 04             	mov    %edx,0x4(%eax)
  8031ba:	eb 0b                	jmp    8031c7 <realloc_block_FF+0x1e5>
  8031bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031bf:	8b 40 04             	mov    0x4(%eax),%eax
  8031c2:	a3 30 50 80 00       	mov    %eax,0x805030
  8031c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ca:	8b 40 04             	mov    0x4(%eax),%eax
  8031cd:	85 c0                	test   %eax,%eax
  8031cf:	74 0f                	je     8031e0 <realloc_block_FF+0x1fe>
  8031d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d4:	8b 40 04             	mov    0x4(%eax),%eax
  8031d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031da:	8b 12                	mov    (%edx),%edx
  8031dc:	89 10                	mov    %edx,(%eax)
  8031de:	eb 0a                	jmp    8031ea <realloc_block_FF+0x208>
  8031e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e3:	8b 00                	mov    (%eax),%eax
  8031e5:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8031ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fd:	a1 38 50 80 00       	mov    0x805038,%eax
  803202:	48                   	dec    %eax
  803203:	a3 38 50 80 00       	mov    %eax,0x805038
  803208:	e9 83 02 00 00       	jmp    803490 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  80320d:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803211:	0f 86 69 02 00 00    	jbe    803480 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  803217:	83 ec 04             	sub    $0x4,%esp
  80321a:	6a 01                	push   $0x1
  80321c:	ff 75 f0             	pushl  -0x10(%ebp)
  80321f:	ff 75 08             	pushl  0x8(%ebp)
  803222:	e8 c8 ed ff ff       	call   801fef <set_block_data>
  803227:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	83 e8 04             	sub    $0x4,%eax
  803230:	8b 00                	mov    (%eax),%eax
  803232:	83 e0 fe             	and    $0xfffffffe,%eax
  803235:	89 c2                	mov    %eax,%edx
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	01 d0                	add    %edx,%eax
  80323c:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  80323f:	a1 38 50 80 00       	mov    0x805038,%eax
  803244:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  803247:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80324b:	75 68                	jne    8032b5 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  80324d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803251:	75 17                	jne    80326a <realloc_block_FF+0x288>
  803253:	83 ec 04             	sub    $0x4,%esp
  803256:	68 64 42 80 00       	push   $0x804264
  80325b:	68 06 02 00 00       	push   $0x206
  803260:	68 49 42 80 00       	push   $0x804249
  803265:	e8 40 05 00 00       	call   8037aa <_panic>
  80326a:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803270:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803273:	89 10                	mov    %edx,(%eax)
  803275:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	85 c0                	test   %eax,%eax
  80327c:	74 0d                	je     80328b <realloc_block_FF+0x2a9>
  80327e:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803283:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803286:	89 50 04             	mov    %edx,0x4(%eax)
  803289:	eb 08                	jmp    803293 <realloc_block_FF+0x2b1>
  80328b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80328e:	a3 30 50 80 00       	mov    %eax,0x805030
  803293:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803296:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80329b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80329e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a5:	a1 38 50 80 00       	mov    0x805038,%eax
  8032aa:	40                   	inc    %eax
  8032ab:	a3 38 50 80 00       	mov    %eax,0x805038
  8032b0:	e9 b0 01 00 00       	jmp    803465 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8032b5:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032ba:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8032bd:	76 68                	jbe    803327 <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  8032bf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8032c3:	75 17                	jne    8032dc <realloc_block_FF+0x2fa>
  8032c5:	83 ec 04             	sub    $0x4,%esp
  8032c8:	68 64 42 80 00       	push   $0x804264
  8032cd:	68 0b 02 00 00       	push   $0x20b
  8032d2:	68 49 42 80 00       	push   $0x804249
  8032d7:	e8 ce 04 00 00       	call   8037aa <_panic>
  8032dc:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8032e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032e5:	89 10                	mov    %edx,(%eax)
  8032e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ea:	8b 00                	mov    (%eax),%eax
  8032ec:	85 c0                	test   %eax,%eax
  8032ee:	74 0d                	je     8032fd <realloc_block_FF+0x31b>
  8032f0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8032f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032f8:	89 50 04             	mov    %edx,0x4(%eax)
  8032fb:	eb 08                	jmp    803305 <realloc_block_FF+0x323>
  8032fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803300:	a3 30 50 80 00       	mov    %eax,0x805030
  803305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803308:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80330d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803310:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803317:	a1 38 50 80 00       	mov    0x805038,%eax
  80331c:	40                   	inc    %eax
  80331d:	a3 38 50 80 00       	mov    %eax,0x805038
  803322:	e9 3e 01 00 00       	jmp    803465 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  803327:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80332c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80332f:	73 68                	jae    803399 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803331:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803335:	75 17                	jne    80334e <realloc_block_FF+0x36c>
  803337:	83 ec 04             	sub    $0x4,%esp
  80333a:	68 98 42 80 00       	push   $0x804298
  80333f:	68 10 02 00 00       	push   $0x210
  803344:	68 49 42 80 00       	push   $0x804249
  803349:	e8 5c 04 00 00       	call   8037aa <_panic>
  80334e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803354:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803357:	89 50 04             	mov    %edx,0x4(%eax)
  80335a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80335d:	8b 40 04             	mov    0x4(%eax),%eax
  803360:	85 c0                	test   %eax,%eax
  803362:	74 0c                	je     803370 <realloc_block_FF+0x38e>
  803364:	a1 30 50 80 00       	mov    0x805030,%eax
  803369:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80336c:	89 10                	mov    %edx,(%eax)
  80336e:	eb 08                	jmp    803378 <realloc_block_FF+0x396>
  803370:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803373:	a3 2c 50 80 00       	mov    %eax,0x80502c
  803378:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80337b:	a3 30 50 80 00       	mov    %eax,0x805030
  803380:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803389:	a1 38 50 80 00       	mov    0x805038,%eax
  80338e:	40                   	inc    %eax
  80338f:	a3 38 50 80 00       	mov    %eax,0x805038
  803394:	e9 cc 00 00 00       	jmp    803465 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  803399:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8033a0:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a8:	e9 8a 00 00 00       	jmp    803437 <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8033ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033b3:	73 7a                	jae    80342f <realloc_block_FF+0x44d>
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	8b 00                	mov    (%eax),%eax
  8033ba:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8033bd:	73 70                	jae    80342f <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  8033bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c3:	74 06                	je     8033cb <realloc_block_FF+0x3e9>
  8033c5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8033c9:	75 17                	jne    8033e2 <realloc_block_FF+0x400>
  8033cb:	83 ec 04             	sub    $0x4,%esp
  8033ce:	68 bc 42 80 00       	push   $0x8042bc
  8033d3:	68 1a 02 00 00       	push   $0x21a
  8033d8:	68 49 42 80 00       	push   $0x804249
  8033dd:	e8 c8 03 00 00       	call   8037aa <_panic>
  8033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e5:	8b 10                	mov    (%eax),%edx
  8033e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ea:	89 10                	mov    %edx,(%eax)
  8033ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033ef:	8b 00                	mov    (%eax),%eax
  8033f1:	85 c0                	test   %eax,%eax
  8033f3:	74 0b                	je     803400 <realloc_block_FF+0x41e>
  8033f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f8:	8b 00                	mov    (%eax),%eax
  8033fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033fd:	89 50 04             	mov    %edx,0x4(%eax)
  803400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803403:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803406:	89 10                	mov    %edx,(%eax)
  803408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80340b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80340e:	89 50 04             	mov    %edx,0x4(%eax)
  803411:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803414:	8b 00                	mov    (%eax),%eax
  803416:	85 c0                	test   %eax,%eax
  803418:	75 08                	jne    803422 <realloc_block_FF+0x440>
  80341a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80341d:	a3 30 50 80 00       	mov    %eax,0x805030
  803422:	a1 38 50 80 00       	mov    0x805038,%eax
  803427:	40                   	inc    %eax
  803428:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  80342d:	eb 36                	jmp    803465 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  80342f:	a1 34 50 80 00       	mov    0x805034,%eax
  803434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803437:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343b:	74 07                	je     803444 <realloc_block_FF+0x462>
  80343d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803440:	8b 00                	mov    (%eax),%eax
  803442:	eb 05                	jmp    803449 <realloc_block_FF+0x467>
  803444:	b8 00 00 00 00       	mov    $0x0,%eax
  803449:	a3 34 50 80 00       	mov    %eax,0x805034
  80344e:	a1 34 50 80 00       	mov    0x805034,%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	0f 85 52 ff ff ff    	jne    8033ad <realloc_block_FF+0x3cb>
  80345b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345f:	0f 85 48 ff ff ff    	jne    8033ad <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803465:	83 ec 04             	sub    $0x4,%esp
  803468:	6a 00                	push   $0x0
  80346a:	ff 75 d8             	pushl  -0x28(%ebp)
  80346d:	ff 75 d4             	pushl  -0x2c(%ebp)
  803470:	e8 7a eb ff ff       	call   801fef <set_block_data>
  803475:	83 c4 10             	add    $0x10,%esp
				return va;
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	e9 7b 02 00 00       	jmp    8036fb <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  803480:	83 ec 0c             	sub    $0xc,%esp
  803483:	68 39 43 80 00       	push   $0x804339
  803488:	e8 76 cf ff ff       	call   800403 <cprintf>
  80348d:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	e9 63 02 00 00       	jmp    8036fb <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  803498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80349b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80349e:	0f 86 4d 02 00 00    	jbe    8036f1 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8034a4:	83 ec 0c             	sub    $0xc,%esp
  8034a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034aa:	e8 08 e8 ff ff       	call   801cb7 <is_free_block>
  8034af:	83 c4 10             	add    $0x10,%esp
  8034b2:	84 c0                	test   %al,%al
  8034b4:	0f 84 37 02 00 00    	je     8036f1 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  8034ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034bd:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8034c0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  8034c3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8034c6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034c9:	76 38                	jbe    803503 <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  8034cb:	83 ec 0c             	sub    $0xc,%esp
  8034ce:	ff 75 08             	pushl  0x8(%ebp)
  8034d1:	e8 0c fa ff ff       	call   802ee2 <free_block>
  8034d6:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  8034d9:	83 ec 0c             	sub    $0xc,%esp
  8034dc:	ff 75 0c             	pushl  0xc(%ebp)
  8034df:	e8 3a eb ff ff       	call   80201e <alloc_block_FF>
  8034e4:	83 c4 10             	add    $0x10,%esp
  8034e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8034ea:	83 ec 08             	sub    $0x8,%esp
  8034ed:	ff 75 c0             	pushl  -0x40(%ebp)
  8034f0:	ff 75 08             	pushl  0x8(%ebp)
  8034f3:	e8 ab fa ff ff       	call   802fa3 <copy_data>
  8034f8:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8034fb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8034fe:	e9 f8 01 00 00       	jmp    8036fb <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  803503:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803506:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803509:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  80350c:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803510:	0f 87 a0 00 00 00    	ja     8035b6 <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  803516:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80351a:	75 17                	jne    803533 <realloc_block_FF+0x551>
  80351c:	83 ec 04             	sub    $0x4,%esp
  80351f:	68 2b 42 80 00       	push   $0x80422b
  803524:	68 38 02 00 00       	push   $0x238
  803529:	68 49 42 80 00       	push   $0x804249
  80352e:	e8 77 02 00 00       	call   8037aa <_panic>
  803533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803536:	8b 00                	mov    (%eax),%eax
  803538:	85 c0                	test   %eax,%eax
  80353a:	74 10                	je     80354c <realloc_block_FF+0x56a>
  80353c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353f:	8b 00                	mov    (%eax),%eax
  803541:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803544:	8b 52 04             	mov    0x4(%edx),%edx
  803547:	89 50 04             	mov    %edx,0x4(%eax)
  80354a:	eb 0b                	jmp    803557 <realloc_block_FF+0x575>
  80354c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80354f:	8b 40 04             	mov    0x4(%eax),%eax
  803552:	a3 30 50 80 00       	mov    %eax,0x805030
  803557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355a:	8b 40 04             	mov    0x4(%eax),%eax
  80355d:	85 c0                	test   %eax,%eax
  80355f:	74 0f                	je     803570 <realloc_block_FF+0x58e>
  803561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803564:	8b 40 04             	mov    0x4(%eax),%eax
  803567:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80356a:	8b 12                	mov    (%edx),%edx
  80356c:	89 10                	mov    %edx,(%eax)
  80356e:	eb 0a                	jmp    80357a <realloc_block_FF+0x598>
  803570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803573:	8b 00                	mov    (%eax),%eax
  803575:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80357a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803586:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358d:	a1 38 50 80 00       	mov    0x805038,%eax
  803592:	48                   	dec    %eax
  803593:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  803598:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80359b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80359e:	01 d0                	add    %edx,%eax
  8035a0:	83 ec 04             	sub    $0x4,%esp
  8035a3:	6a 01                	push   $0x1
  8035a5:	50                   	push   %eax
  8035a6:	ff 75 08             	pushl  0x8(%ebp)
  8035a9:	e8 41 ea ff ff       	call   801fef <set_block_data>
  8035ae:	83 c4 10             	add    $0x10,%esp
  8035b1:	e9 36 01 00 00       	jmp    8036ec <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8035b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8035bc:	01 d0                	add    %edx,%eax
  8035be:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  8035c1:	83 ec 04             	sub    $0x4,%esp
  8035c4:	6a 01                	push   $0x1
  8035c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8035c9:	ff 75 08             	pushl  0x8(%ebp)
  8035cc:	e8 1e ea ff ff       	call   801fef <set_block_data>
  8035d1:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d7:	83 e8 04             	sub    $0x4,%eax
  8035da:	8b 00                	mov    (%eax),%eax
  8035dc:	83 e0 fe             	and    $0xfffffffe,%eax
  8035df:	89 c2                	mov    %eax,%edx
  8035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e4:	01 d0                	add    %edx,%eax
  8035e6:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8035e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035ed:	74 06                	je     8035f5 <realloc_block_FF+0x613>
  8035ef:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8035f3:	75 17                	jne    80360c <realloc_block_FF+0x62a>
  8035f5:	83 ec 04             	sub    $0x4,%esp
  8035f8:	68 bc 42 80 00       	push   $0x8042bc
  8035fd:	68 44 02 00 00       	push   $0x244
  803602:	68 49 42 80 00       	push   $0x804249
  803607:	e8 9e 01 00 00       	call   8037aa <_panic>
  80360c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360f:	8b 10                	mov    (%eax),%edx
  803611:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803614:	89 10                	mov    %edx,(%eax)
  803616:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803619:	8b 00                	mov    (%eax),%eax
  80361b:	85 c0                	test   %eax,%eax
  80361d:	74 0b                	je     80362a <realloc_block_FF+0x648>
  80361f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803622:	8b 00                	mov    (%eax),%eax
  803624:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803627:	89 50 04             	mov    %edx,0x4(%eax)
  80362a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80362d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803630:	89 10                	mov    %edx,(%eax)
  803632:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803635:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803638:	89 50 04             	mov    %edx,0x4(%eax)
  80363b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80363e:	8b 00                	mov    (%eax),%eax
  803640:	85 c0                	test   %eax,%eax
  803642:	75 08                	jne    80364c <realloc_block_FF+0x66a>
  803644:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803647:	a3 30 50 80 00       	mov    %eax,0x805030
  80364c:	a1 38 50 80 00       	mov    0x805038,%eax
  803651:	40                   	inc    %eax
  803652:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  803657:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80365b:	75 17                	jne    803674 <realloc_block_FF+0x692>
  80365d:	83 ec 04             	sub    $0x4,%esp
  803660:	68 2b 42 80 00       	push   $0x80422b
  803665:	68 45 02 00 00       	push   $0x245
  80366a:	68 49 42 80 00       	push   $0x804249
  80366f:	e8 36 01 00 00       	call   8037aa <_panic>
  803674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803677:	8b 00                	mov    (%eax),%eax
  803679:	85 c0                	test   %eax,%eax
  80367b:	74 10                	je     80368d <realloc_block_FF+0x6ab>
  80367d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803680:	8b 00                	mov    (%eax),%eax
  803682:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803685:	8b 52 04             	mov    0x4(%edx),%edx
  803688:	89 50 04             	mov    %edx,0x4(%eax)
  80368b:	eb 0b                	jmp    803698 <realloc_block_FF+0x6b6>
  80368d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803690:	8b 40 04             	mov    0x4(%eax),%eax
  803693:	a3 30 50 80 00       	mov    %eax,0x805030
  803698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369b:	8b 40 04             	mov    0x4(%eax),%eax
  80369e:	85 c0                	test   %eax,%eax
  8036a0:	74 0f                	je     8036b1 <realloc_block_FF+0x6cf>
  8036a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a5:	8b 40 04             	mov    0x4(%eax),%eax
  8036a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036ab:	8b 12                	mov    (%edx),%edx
  8036ad:	89 10                	mov    %edx,(%eax)
  8036af:	eb 0a                	jmp    8036bb <realloc_block_FF+0x6d9>
  8036b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b4:	8b 00                	mov    (%eax),%eax
  8036b6:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8036bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ce:	a1 38 50 80 00       	mov    0x805038,%eax
  8036d3:	48                   	dec    %eax
  8036d4:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  8036d9:	83 ec 04             	sub    $0x4,%esp
  8036dc:	6a 00                	push   $0x0
  8036de:	ff 75 bc             	pushl  -0x44(%ebp)
  8036e1:	ff 75 b8             	pushl  -0x48(%ebp)
  8036e4:	e8 06 e9 ff ff       	call   801fef <set_block_data>
  8036e9:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8036ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ef:	eb 0a                	jmp    8036fb <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8036f1:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8036f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8036fb:	c9                   	leave  
  8036fc:	c3                   	ret    

008036fd <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8036fd:	55                   	push   %ebp
  8036fe:	89 e5                	mov    %esp,%ebp
  803700:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803703:	83 ec 04             	sub    $0x4,%esp
  803706:	68 40 43 80 00       	push   $0x804340
  80370b:	68 58 02 00 00       	push   $0x258
  803710:	68 49 42 80 00       	push   $0x804249
  803715:	e8 90 00 00 00       	call   8037aa <_panic>

0080371a <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80371a:	55                   	push   %ebp
  80371b:	89 e5                	mov    %esp,%ebp
  80371d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803720:	83 ec 04             	sub    $0x4,%esp
  803723:	68 68 43 80 00       	push   $0x804368
  803728:	68 61 02 00 00       	push   $0x261
  80372d:	68 49 42 80 00       	push   $0x804249
  803732:	e8 73 00 00 00       	call   8037aa <_panic>

00803737 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803737:	55                   	push   %ebp
  803738:	89 e5                	mov    %esp,%ebp
  80373a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  80373d:	83 ec 04             	sub    $0x4,%esp
  803740:	68 90 43 80 00       	push   $0x804390
  803745:	6a 09                	push   $0x9
  803747:	68 b8 43 80 00       	push   $0x8043b8
  80374c:	e8 59 00 00 00       	call   8037aa <_panic>

00803751 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803751:	55                   	push   %ebp
  803752:	89 e5                	mov    %esp,%ebp
  803754:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  803757:	83 ec 04             	sub    $0x4,%esp
  80375a:	68 c8 43 80 00       	push   $0x8043c8
  80375f:	6a 10                	push   $0x10
  803761:	68 b8 43 80 00       	push   $0x8043b8
  803766:	e8 3f 00 00 00       	call   8037aa <_panic>

0080376b <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  80376b:	55                   	push   %ebp
  80376c:	89 e5                	mov    %esp,%ebp
  80376e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  803771:	83 ec 04             	sub    $0x4,%esp
  803774:	68 f0 43 80 00       	push   $0x8043f0
  803779:	6a 18                	push   $0x18
  80377b:	68 b8 43 80 00       	push   $0x8043b8
  803780:	e8 25 00 00 00       	call   8037aa <_panic>

00803785 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  803785:	55                   	push   %ebp
  803786:	89 e5                	mov    %esp,%ebp
  803788:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  80378b:	83 ec 04             	sub    $0x4,%esp
  80378e:	68 18 44 80 00       	push   $0x804418
  803793:	6a 20                	push   $0x20
  803795:	68 b8 43 80 00       	push   $0x8043b8
  80379a:	e8 0b 00 00 00       	call   8037aa <_panic>

0080379f <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80379f:	55                   	push   %ebp
  8037a0:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8037a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a5:	8b 40 10             	mov    0x10(%eax),%eax
}
  8037a8:	5d                   	pop    %ebp
  8037a9:	c3                   	ret    

008037aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8037aa:	55                   	push   %ebp
  8037ab:	89 e5                	mov    %esp,%ebp
  8037ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8037b0:	8d 45 10             	lea    0x10(%ebp),%eax
  8037b3:	83 c0 04             	add    $0x4,%eax
  8037b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8037b9:	a1 60 50 90 00       	mov    0x905060,%eax
  8037be:	85 c0                	test   %eax,%eax
  8037c0:	74 16                	je     8037d8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8037c2:	a1 60 50 90 00       	mov    0x905060,%eax
  8037c7:	83 ec 08             	sub    $0x8,%esp
  8037ca:	50                   	push   %eax
  8037cb:	68 40 44 80 00       	push   $0x804440
  8037d0:	e8 2e cc ff ff       	call   800403 <cprintf>
  8037d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8037d8:	a1 00 50 80 00       	mov    0x805000,%eax
  8037dd:	ff 75 0c             	pushl  0xc(%ebp)
  8037e0:	ff 75 08             	pushl  0x8(%ebp)
  8037e3:	50                   	push   %eax
  8037e4:	68 45 44 80 00       	push   $0x804445
  8037e9:	e8 15 cc ff ff       	call   800403 <cprintf>
  8037ee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8037f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8037f4:	83 ec 08             	sub    $0x8,%esp
  8037f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8037fa:	50                   	push   %eax
  8037fb:	e8 98 cb ff ff       	call   800398 <vcprintf>
  803800:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803803:	83 ec 08             	sub    $0x8,%esp
  803806:	6a 00                	push   $0x0
  803808:	68 61 44 80 00       	push   $0x804461
  80380d:	e8 86 cb ff ff       	call   800398 <vcprintf>
  803812:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803815:	e8 07 cb ff ff       	call   800321 <exit>

	// should not return here
	while (1) ;
  80381a:	eb fe                	jmp    80381a <_panic+0x70>

0080381c <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80381c:	55                   	push   %ebp
  80381d:	89 e5                	mov    %esp,%ebp
  80381f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803822:	a1 20 50 80 00       	mov    0x805020,%eax
  803827:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80382d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803830:	39 c2                	cmp    %eax,%edx
  803832:	74 14                	je     803848 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803834:	83 ec 04             	sub    $0x4,%esp
  803837:	68 64 44 80 00       	push   $0x804464
  80383c:	6a 26                	push   $0x26
  80383e:	68 b0 44 80 00       	push   $0x8044b0
  803843:	e8 62 ff ff ff       	call   8037aa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803848:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80384f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803856:	e9 c5 00 00 00       	jmp    803920 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80385b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803865:	8b 45 08             	mov    0x8(%ebp),%eax
  803868:	01 d0                	add    %edx,%eax
  80386a:	8b 00                	mov    (%eax),%eax
  80386c:	85 c0                	test   %eax,%eax
  80386e:	75 08                	jne    803878 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803870:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803873:	e9 a5 00 00 00       	jmp    80391d <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803878:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80387f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803886:	eb 69                	jmp    8038f1 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803888:	a1 20 50 80 00       	mov    0x805020,%eax
  80388d:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803893:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803896:	89 d0                	mov    %edx,%eax
  803898:	01 c0                	add    %eax,%eax
  80389a:	01 d0                	add    %edx,%eax
  80389c:	c1 e0 03             	shl    $0x3,%eax
  80389f:	01 c8                	add    %ecx,%eax
  8038a1:	8a 40 04             	mov    0x4(%eax),%al
  8038a4:	84 c0                	test   %al,%al
  8038a6:	75 46                	jne    8038ee <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8038ad:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8038b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8038b6:	89 d0                	mov    %edx,%eax
  8038b8:	01 c0                	add    %eax,%eax
  8038ba:	01 d0                	add    %edx,%eax
  8038bc:	c1 e0 03             	shl    $0x3,%eax
  8038bf:	01 c8                	add    %ecx,%eax
  8038c1:	8b 00                	mov    (%eax),%eax
  8038c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8038c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8038c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8038ce:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8038d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8038da:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dd:	01 c8                	add    %ecx,%eax
  8038df:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8038e1:	39 c2                	cmp    %eax,%edx
  8038e3:	75 09                	jne    8038ee <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8038e5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8038ec:	eb 15                	jmp    803903 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8038ee:	ff 45 e8             	incl   -0x18(%ebp)
  8038f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8038f6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8038fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038ff:	39 c2                	cmp    %eax,%edx
  803901:	77 85                	ja     803888 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803903:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803907:	75 14                	jne    80391d <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803909:	83 ec 04             	sub    $0x4,%esp
  80390c:	68 bc 44 80 00       	push   $0x8044bc
  803911:	6a 3a                	push   $0x3a
  803913:	68 b0 44 80 00       	push   $0x8044b0
  803918:	e8 8d fe ff ff       	call   8037aa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80391d:	ff 45 f0             	incl   -0x10(%ebp)
  803920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803923:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803926:	0f 8c 2f ff ff ff    	jl     80385b <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80392c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803933:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80393a:	eb 26                	jmp    803962 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80393c:	a1 20 50 80 00       	mov    0x805020,%eax
  803941:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803947:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80394a:	89 d0                	mov    %edx,%eax
  80394c:	01 c0                	add    %eax,%eax
  80394e:	01 d0                	add    %edx,%eax
  803950:	c1 e0 03             	shl    $0x3,%eax
  803953:	01 c8                	add    %ecx,%eax
  803955:	8a 40 04             	mov    0x4(%eax),%al
  803958:	3c 01                	cmp    $0x1,%al
  80395a:	75 03                	jne    80395f <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80395c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80395f:	ff 45 e0             	incl   -0x20(%ebp)
  803962:	a1 20 50 80 00       	mov    0x805020,%eax
  803967:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80396d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803970:	39 c2                	cmp    %eax,%edx
  803972:	77 c8                	ja     80393c <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803977:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80397a:	74 14                	je     803990 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80397c:	83 ec 04             	sub    $0x4,%esp
  80397f:	68 10 45 80 00       	push   $0x804510
  803984:	6a 44                	push   $0x44
  803986:	68 b0 44 80 00       	push   $0x8044b0
  80398b:	e8 1a fe ff ff       	call   8037aa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803990:	90                   	nop
  803991:	c9                   	leave  
  803992:	c3                   	ret    
  803993:	90                   	nop

00803994 <__udivdi3>:
  803994:	55                   	push   %ebp
  803995:	57                   	push   %edi
  803996:	56                   	push   %esi
  803997:	53                   	push   %ebx
  803998:	83 ec 1c             	sub    $0x1c,%esp
  80399b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80399f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8039a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8039ab:	89 ca                	mov    %ecx,%edx
  8039ad:	89 f8                	mov    %edi,%eax
  8039af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8039b3:	85 f6                	test   %esi,%esi
  8039b5:	75 2d                	jne    8039e4 <__udivdi3+0x50>
  8039b7:	39 cf                	cmp    %ecx,%edi
  8039b9:	77 65                	ja     803a20 <__udivdi3+0x8c>
  8039bb:	89 fd                	mov    %edi,%ebp
  8039bd:	85 ff                	test   %edi,%edi
  8039bf:	75 0b                	jne    8039cc <__udivdi3+0x38>
  8039c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8039c6:	31 d2                	xor    %edx,%edx
  8039c8:	f7 f7                	div    %edi
  8039ca:	89 c5                	mov    %eax,%ebp
  8039cc:	31 d2                	xor    %edx,%edx
  8039ce:	89 c8                	mov    %ecx,%eax
  8039d0:	f7 f5                	div    %ebp
  8039d2:	89 c1                	mov    %eax,%ecx
  8039d4:	89 d8                	mov    %ebx,%eax
  8039d6:	f7 f5                	div    %ebp
  8039d8:	89 cf                	mov    %ecx,%edi
  8039da:	89 fa                	mov    %edi,%edx
  8039dc:	83 c4 1c             	add    $0x1c,%esp
  8039df:	5b                   	pop    %ebx
  8039e0:	5e                   	pop    %esi
  8039e1:	5f                   	pop    %edi
  8039e2:	5d                   	pop    %ebp
  8039e3:	c3                   	ret    
  8039e4:	39 ce                	cmp    %ecx,%esi
  8039e6:	77 28                	ja     803a10 <__udivdi3+0x7c>
  8039e8:	0f bd fe             	bsr    %esi,%edi
  8039eb:	83 f7 1f             	xor    $0x1f,%edi
  8039ee:	75 40                	jne    803a30 <__udivdi3+0x9c>
  8039f0:	39 ce                	cmp    %ecx,%esi
  8039f2:	72 0a                	jb     8039fe <__udivdi3+0x6a>
  8039f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039f8:	0f 87 9e 00 00 00    	ja     803a9c <__udivdi3+0x108>
  8039fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803a03:	89 fa                	mov    %edi,%edx
  803a05:	83 c4 1c             	add    $0x1c,%esp
  803a08:	5b                   	pop    %ebx
  803a09:	5e                   	pop    %esi
  803a0a:	5f                   	pop    %edi
  803a0b:	5d                   	pop    %ebp
  803a0c:	c3                   	ret    
  803a0d:	8d 76 00             	lea    0x0(%esi),%esi
  803a10:	31 ff                	xor    %edi,%edi
  803a12:	31 c0                	xor    %eax,%eax
  803a14:	89 fa                	mov    %edi,%edx
  803a16:	83 c4 1c             	add    $0x1c,%esp
  803a19:	5b                   	pop    %ebx
  803a1a:	5e                   	pop    %esi
  803a1b:	5f                   	pop    %edi
  803a1c:	5d                   	pop    %ebp
  803a1d:	c3                   	ret    
  803a1e:	66 90                	xchg   %ax,%ax
  803a20:	89 d8                	mov    %ebx,%eax
  803a22:	f7 f7                	div    %edi
  803a24:	31 ff                	xor    %edi,%edi
  803a26:	89 fa                	mov    %edi,%edx
  803a28:	83 c4 1c             	add    $0x1c,%esp
  803a2b:	5b                   	pop    %ebx
  803a2c:	5e                   	pop    %esi
  803a2d:	5f                   	pop    %edi
  803a2e:	5d                   	pop    %ebp
  803a2f:	c3                   	ret    
  803a30:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a35:	89 eb                	mov    %ebp,%ebx
  803a37:	29 fb                	sub    %edi,%ebx
  803a39:	89 f9                	mov    %edi,%ecx
  803a3b:	d3 e6                	shl    %cl,%esi
  803a3d:	89 c5                	mov    %eax,%ebp
  803a3f:	88 d9                	mov    %bl,%cl
  803a41:	d3 ed                	shr    %cl,%ebp
  803a43:	89 e9                	mov    %ebp,%ecx
  803a45:	09 f1                	or     %esi,%ecx
  803a47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a4b:	89 f9                	mov    %edi,%ecx
  803a4d:	d3 e0                	shl    %cl,%eax
  803a4f:	89 c5                	mov    %eax,%ebp
  803a51:	89 d6                	mov    %edx,%esi
  803a53:	88 d9                	mov    %bl,%cl
  803a55:	d3 ee                	shr    %cl,%esi
  803a57:	89 f9                	mov    %edi,%ecx
  803a59:	d3 e2                	shl    %cl,%edx
  803a5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a5f:	88 d9                	mov    %bl,%cl
  803a61:	d3 e8                	shr    %cl,%eax
  803a63:	09 c2                	or     %eax,%edx
  803a65:	89 d0                	mov    %edx,%eax
  803a67:	89 f2                	mov    %esi,%edx
  803a69:	f7 74 24 0c          	divl   0xc(%esp)
  803a6d:	89 d6                	mov    %edx,%esi
  803a6f:	89 c3                	mov    %eax,%ebx
  803a71:	f7 e5                	mul    %ebp
  803a73:	39 d6                	cmp    %edx,%esi
  803a75:	72 19                	jb     803a90 <__udivdi3+0xfc>
  803a77:	74 0b                	je     803a84 <__udivdi3+0xf0>
  803a79:	89 d8                	mov    %ebx,%eax
  803a7b:	31 ff                	xor    %edi,%edi
  803a7d:	e9 58 ff ff ff       	jmp    8039da <__udivdi3+0x46>
  803a82:	66 90                	xchg   %ax,%ax
  803a84:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a88:	89 f9                	mov    %edi,%ecx
  803a8a:	d3 e2                	shl    %cl,%edx
  803a8c:	39 c2                	cmp    %eax,%edx
  803a8e:	73 e9                	jae    803a79 <__udivdi3+0xe5>
  803a90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a93:	31 ff                	xor    %edi,%edi
  803a95:	e9 40 ff ff ff       	jmp    8039da <__udivdi3+0x46>
  803a9a:	66 90                	xchg   %ax,%ax
  803a9c:	31 c0                	xor    %eax,%eax
  803a9e:	e9 37 ff ff ff       	jmp    8039da <__udivdi3+0x46>
  803aa3:	90                   	nop

00803aa4 <__umoddi3>:
  803aa4:	55                   	push   %ebp
  803aa5:	57                   	push   %edi
  803aa6:	56                   	push   %esi
  803aa7:	53                   	push   %ebx
  803aa8:	83 ec 1c             	sub    $0x1c,%esp
  803aab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803aaf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ab3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ab7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803abb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803abf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ac3:	89 f3                	mov    %esi,%ebx
  803ac5:	89 fa                	mov    %edi,%edx
  803ac7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803acb:	89 34 24             	mov    %esi,(%esp)
  803ace:	85 c0                	test   %eax,%eax
  803ad0:	75 1a                	jne    803aec <__umoddi3+0x48>
  803ad2:	39 f7                	cmp    %esi,%edi
  803ad4:	0f 86 a2 00 00 00    	jbe    803b7c <__umoddi3+0xd8>
  803ada:	89 c8                	mov    %ecx,%eax
  803adc:	89 f2                	mov    %esi,%edx
  803ade:	f7 f7                	div    %edi
  803ae0:	89 d0                	mov    %edx,%eax
  803ae2:	31 d2                	xor    %edx,%edx
  803ae4:	83 c4 1c             	add    $0x1c,%esp
  803ae7:	5b                   	pop    %ebx
  803ae8:	5e                   	pop    %esi
  803ae9:	5f                   	pop    %edi
  803aea:	5d                   	pop    %ebp
  803aeb:	c3                   	ret    
  803aec:	39 f0                	cmp    %esi,%eax
  803aee:	0f 87 ac 00 00 00    	ja     803ba0 <__umoddi3+0xfc>
  803af4:	0f bd e8             	bsr    %eax,%ebp
  803af7:	83 f5 1f             	xor    $0x1f,%ebp
  803afa:	0f 84 ac 00 00 00    	je     803bac <__umoddi3+0x108>
  803b00:	bf 20 00 00 00       	mov    $0x20,%edi
  803b05:	29 ef                	sub    %ebp,%edi
  803b07:	89 fe                	mov    %edi,%esi
  803b09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b0d:	89 e9                	mov    %ebp,%ecx
  803b0f:	d3 e0                	shl    %cl,%eax
  803b11:	89 d7                	mov    %edx,%edi
  803b13:	89 f1                	mov    %esi,%ecx
  803b15:	d3 ef                	shr    %cl,%edi
  803b17:	09 c7                	or     %eax,%edi
  803b19:	89 e9                	mov    %ebp,%ecx
  803b1b:	d3 e2                	shl    %cl,%edx
  803b1d:	89 14 24             	mov    %edx,(%esp)
  803b20:	89 d8                	mov    %ebx,%eax
  803b22:	d3 e0                	shl    %cl,%eax
  803b24:	89 c2                	mov    %eax,%edx
  803b26:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b2a:	d3 e0                	shl    %cl,%eax
  803b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b30:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b34:	89 f1                	mov    %esi,%ecx
  803b36:	d3 e8                	shr    %cl,%eax
  803b38:	09 d0                	or     %edx,%eax
  803b3a:	d3 eb                	shr    %cl,%ebx
  803b3c:	89 da                	mov    %ebx,%edx
  803b3e:	f7 f7                	div    %edi
  803b40:	89 d3                	mov    %edx,%ebx
  803b42:	f7 24 24             	mull   (%esp)
  803b45:	89 c6                	mov    %eax,%esi
  803b47:	89 d1                	mov    %edx,%ecx
  803b49:	39 d3                	cmp    %edx,%ebx
  803b4b:	0f 82 87 00 00 00    	jb     803bd8 <__umoddi3+0x134>
  803b51:	0f 84 91 00 00 00    	je     803be8 <__umoddi3+0x144>
  803b57:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b5b:	29 f2                	sub    %esi,%edx
  803b5d:	19 cb                	sbb    %ecx,%ebx
  803b5f:	89 d8                	mov    %ebx,%eax
  803b61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b65:	d3 e0                	shl    %cl,%eax
  803b67:	89 e9                	mov    %ebp,%ecx
  803b69:	d3 ea                	shr    %cl,%edx
  803b6b:	09 d0                	or     %edx,%eax
  803b6d:	89 e9                	mov    %ebp,%ecx
  803b6f:	d3 eb                	shr    %cl,%ebx
  803b71:	89 da                	mov    %ebx,%edx
  803b73:	83 c4 1c             	add    $0x1c,%esp
  803b76:	5b                   	pop    %ebx
  803b77:	5e                   	pop    %esi
  803b78:	5f                   	pop    %edi
  803b79:	5d                   	pop    %ebp
  803b7a:	c3                   	ret    
  803b7b:	90                   	nop
  803b7c:	89 fd                	mov    %edi,%ebp
  803b7e:	85 ff                	test   %edi,%edi
  803b80:	75 0b                	jne    803b8d <__umoddi3+0xe9>
  803b82:	b8 01 00 00 00       	mov    $0x1,%eax
  803b87:	31 d2                	xor    %edx,%edx
  803b89:	f7 f7                	div    %edi
  803b8b:	89 c5                	mov    %eax,%ebp
  803b8d:	89 f0                	mov    %esi,%eax
  803b8f:	31 d2                	xor    %edx,%edx
  803b91:	f7 f5                	div    %ebp
  803b93:	89 c8                	mov    %ecx,%eax
  803b95:	f7 f5                	div    %ebp
  803b97:	89 d0                	mov    %edx,%eax
  803b99:	e9 44 ff ff ff       	jmp    803ae2 <__umoddi3+0x3e>
  803b9e:	66 90                	xchg   %ax,%ax
  803ba0:	89 c8                	mov    %ecx,%eax
  803ba2:	89 f2                	mov    %esi,%edx
  803ba4:	83 c4 1c             	add    $0x1c,%esp
  803ba7:	5b                   	pop    %ebx
  803ba8:	5e                   	pop    %esi
  803ba9:	5f                   	pop    %edi
  803baa:	5d                   	pop    %ebp
  803bab:	c3                   	ret    
  803bac:	3b 04 24             	cmp    (%esp),%eax
  803baf:	72 06                	jb     803bb7 <__umoddi3+0x113>
  803bb1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803bb5:	77 0f                	ja     803bc6 <__umoddi3+0x122>
  803bb7:	89 f2                	mov    %esi,%edx
  803bb9:	29 f9                	sub    %edi,%ecx
  803bbb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803bbf:	89 14 24             	mov    %edx,(%esp)
  803bc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bc6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803bca:	8b 14 24             	mov    (%esp),%edx
  803bcd:	83 c4 1c             	add    $0x1c,%esp
  803bd0:	5b                   	pop    %ebx
  803bd1:	5e                   	pop    %esi
  803bd2:	5f                   	pop    %edi
  803bd3:	5d                   	pop    %ebp
  803bd4:	c3                   	ret    
  803bd5:	8d 76 00             	lea    0x0(%esi),%esi
  803bd8:	2b 04 24             	sub    (%esp),%eax
  803bdb:	19 fa                	sbb    %edi,%edx
  803bdd:	89 d1                	mov    %edx,%ecx
  803bdf:	89 c6                	mov    %eax,%esi
  803be1:	e9 71 ff ff ff       	jmp    803b57 <__umoddi3+0xb3>
  803be6:	66 90                	xchg   %ax,%ax
  803be8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bec:	72 ea                	jb     803bd8 <__umoddi3+0x134>
  803bee:	89 d9                	mov    %ebx,%ecx
  803bf0:	e9 62 ff ff ff       	jmp    803b57 <__umoddi3+0xb3>
