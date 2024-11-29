
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
  800045:	68 40 3d 80 00       	push   $0x803d40
  80004a:	e8 82 14 00 00       	call   8014d1 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 44 3d 80 00       	push   $0x803d44
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
  80009a:	68 69 3d 80 00       	push   $0x803d69
  80009f:	e8 2d 14 00 00       	call   8014d1 <smalloc>
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
  8000da:	68 70 3d 80 00       	push   $0x803d70
  8000df:	50                   	push   %eax
  8000e0:	e8 9a 37 00 00       	call   80387f <create_semaphore>
  8000e5:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	6a 01                	push   $0x1
  8000ed:	6a 04                	push   $0x4
  8000ef:	68 72 3d 80 00       	push   $0x803d72
  8000f4:	e8 d8 13 00 00       	call   8014d1 <smalloc>
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
  80012e:	68 80 3d 80 00       	push   $0x803d80
  800133:	e8 00 19 00 00       	call   801a38 <sys_create_env>
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
  800164:	68 8a 3d 80 00       	push   $0x803d8a
  800169:	e8 ca 18 00 00       	call   801a38 <sys_create_env>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 d7 18 00 00       	call   801a56 <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	e8 c9 18 00 00       	call   801a56 <sys_run_env>
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
  8001a4:	68 94 3d 80 00       	push   $0x803d94
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
  8001c8:	e8 a8 17 00 00       	call   801975 <sys_cputc>
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
  8001d9:	e8 33 16 00 00       	call   801811 <sys_cgetc>
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
  8001f6:	e8 ab 18 00 00       	call   801aa6 <sys_getenvindex>
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
  800264:	e8 c1 15 00 00       	call   80182a <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	68 c4 3d 80 00       	push   $0x803dc4
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
  800294:	68 ec 3d 80 00       	push   $0x803dec
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
  8002c5:	68 14 3e 80 00       	push   $0x803e14
  8002ca:	e8 34 01 00 00       	call   800403 <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d7:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	50                   	push   %eax
  8002e1:	68 6c 3e 80 00       	push   $0x803e6c
  8002e6:	e8 18 01 00 00       	call   800403 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	68 c4 3d 80 00       	push   $0x803dc4
  8002f6:	e8 08 01 00 00       	call   800403 <cprintf>
  8002fb:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002fe:	e8 41 15 00 00       	call   801844 <sys_unlock_cons>
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
  800316:	e8 57 17 00 00       	call   801a72 <sys_destroy_env>
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
  800327:	e8 ac 17 00 00       	call   801ad8 <sys_exit_env>
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
  80035a:	a0 2c 50 80 00       	mov    0x80502c,%al
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
  800375:	e8 6e 14 00 00       	call   8017e8 <sys_cputs>
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
  8003cf:	a0 2c 50 80 00       	mov    0x80502c,%al
  8003d4:	0f b6 c0             	movzbl %al,%eax
  8003d7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	50                   	push   %eax
  8003e1:	52                   	push   %edx
  8003e2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e8:	83 c0 08             	add    $0x8,%eax
  8003eb:	50                   	push   %eax
  8003ec:	e8 f7 13 00 00       	call   8017e8 <sys_cputs>
  8003f1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003f4:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
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
  800409:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  800436:	e8 ef 13 00 00       	call   80182a <sys_lock_cons>
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
  800456:	e8 e9 13 00 00       	call   801844 <sys_unlock_cons>
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
  8004a0:	e8 37 36 00 00       	call   803adc <__udivdi3>
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
  8004f0:	e8 f7 36 00 00       	call   803bec <__umoddi3>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	05 94 40 80 00       	add    $0x804094,%eax
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
  80064b:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
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
  80072c:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  800733:	85 f6                	test   %esi,%esi
  800735:	75 19                	jne    800750 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800737:	53                   	push   %ebx
  800738:	68 a5 40 80 00       	push   $0x8040a5
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
  800751:	68 ae 40 80 00       	push   $0x8040ae
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
  80077e:	be b1 40 80 00       	mov    $0x8040b1,%esi
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
  800976:	c6 05 2c 50 80 00 00 	movb   $0x0,0x80502c
			break;
  80097d:	eb 2c                	jmp    8009ab <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80097f:	c6 05 2c 50 80 00 01 	movb   $0x1,0x80502c
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
  801189:	68 28 42 80 00       	push   $0x804228
  80118e:	68 3f 01 00 00       	push   $0x13f
  801193:	68 4a 42 80 00       	push   $0x80424a
  801198:	e8 55 27 00 00       	call   8038f2 <_panic>

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
  8011a9:	e8 e5 0b 00 00       	call   801d93 <sys_sbrk>
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
  801224:	e8 ee 09 00 00       	call   801c17 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801229:	85 c0                	test   %eax,%eax
  80122b:	74 16                	je     801243 <malloc+0x90>
		{
			//cprintf("47\n");
			ptr = alloc_block_FF(size);
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 2e 0f 00 00       	call   802166 <alloc_block_FF>
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123e:	e9 8a 01 00 00       	jmp    8013cd <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801243:	e8 00 0a 00 00       	call   801c48 <sys_isUHeapPlacementStrategyBESTFIT>
  801248:	85 c0                	test   %eax,%eax
  80124a:	0f 84 7d 01 00 00    	je     8013cd <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	ff 75 08             	pushl  0x8(%ebp)
  801256:	e8 c7 13 00 00       	call   802622 <alloc_block_BF>
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
  8012a6:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  8012f3:	8b 04 85 60 90 08 01 	mov    0x1089060(,%eax,4),%eax
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
  80134a:	c7 04 85 60 90 08 01 	movl   $0x1,0x1089060(,%eax,4)
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
  8013ac:	89 04 95 60 90 10 01 	mov    %eax,0x1109060(,%edx,4)
		sys_allocate_user_mem(i, size);
  8013b3:	83 ec 08             	sub    $0x8,%esp
  8013b6:	ff 75 08             	pushl  0x8(%ebp)
  8013b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8013bc:	e8 09 0a 00 00       	call   801dca <sys_allocate_user_mem>
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
  801404:	e8 dd 09 00 00       	call   801de6 <get_block_size>
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80140f:	83 ec 0c             	sub    $0xc,%esp
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	e8 10 1c 00 00       	call   80302a <free_block>
  80141a:	83 c4 10             	add    $0x10,%esp
		}

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
  80144f:	8b 04 85 60 90 10 01 	mov    0x1109060(,%eax,4),%eax
  801456:	89 45 e8             	mov    %eax,-0x18(%ebp)
		size = no_of_pages * PAGE_SIZE;
  801459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80145c:	c1 e0 0c             	shl    $0xc,%eax
  80145f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for(int k = 0;k<no_of_pages;k++)
  801462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801469:	eb 42                	jmp    8014ad <free+0xdb>
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
  80148c:	c7 04 85 60 90 08 01 	movl   $0x0,0x1089060(,%eax,4)
  801493:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801497:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	52                   	push   %edx
  8014a1:	50                   	push   %eax
  8014a2:	e8 07 09 00 00       	call   801dae <sys_free_user_mem>
  8014a7:	83 c4 10             	add    $0x10,%esp
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
		uint32 no_of_pages = no_pages_marked[UHEAP_PAGE_INDEX((uint32)va)];
		size = no_of_pages * PAGE_SIZE;
		for(int k = 0;k<no_of_pages;k++)
  8014aa:	ff 45 f4             	incl   -0xc(%ebp)
  8014ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8014b3:	72 b6                	jb     80146b <free+0x99>
	uint32 pageA_start = myEnv->heap_hard_limit + PAGE_SIZE;
	uint32 size = 0;
	if((uint32)va < myEnv->heap_hard_limit){
		size = get_block_size(va);
		free_block(va);
	} else if((uint32)va >= pageA_start && (uint32)va < USER_HEAP_MAX){
  8014b5:	eb 17                	jmp    8014ce <free+0xfc>
			isPageMarked[UHEAP_PAGE_INDEX((k*PAGE_SIZE)+(uint32)va)]=0;
			sys_free_user_mem((uint32)va, k);
		}

	} else{
		panic("User free: The virtual Address is invalid");
  8014b7:	83 ec 04             	sub    $0x4,%esp
  8014ba:	68 58 42 80 00       	push   $0x804258
  8014bf:	68 88 00 00 00       	push   $0x88
  8014c4:	68 82 42 80 00       	push   $0x804282
  8014c9:	e8 24 24 00 00       	call   8038f2 <_panic>
	}
}
  8014ce:	90                   	nop
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 28             	sub    $0x28,%esp
  8014d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014da:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8014dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014e1:	75 0a                	jne    8014ed <smalloc+0x1c>
  8014e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e8:	e9 ec 00 00 00       	jmp    8015d9 <smalloc+0x108>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	void *ptr = malloc(MAX(size,PAGE_SIZE));
  8014ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801500:	39 d0                	cmp    %edx,%eax
  801502:	73 02                	jae    801506 <smalloc+0x35>
  801504:	89 d0                	mov    %edx,%eax
  801506:	83 ec 0c             	sub    $0xc,%esp
  801509:	50                   	push   %eax
  80150a:	e8 a4 fc ff ff       	call   8011b3 <malloc>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(ptr == NULL) return NULL;
  801515:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801519:	75 0a                	jne    801525 <smalloc+0x54>
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax
  801520:	e9 b4 00 00 00       	jmp    8015d9 <smalloc+0x108>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801525:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801529:	ff 75 ec             	pushl  -0x14(%ebp)
  80152c:	50                   	push   %eax
  80152d:	ff 75 0c             	pushl  0xc(%ebp)
  801530:	ff 75 08             	pushl  0x8(%ebp)
  801533:	e8 7d 04 00 00       	call   8019b5 <sys_createSharedObject>
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80153e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801542:	74 06                	je     80154a <smalloc+0x79>
  801544:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801548:	75 0a                	jne    801554 <smalloc+0x83>
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
  80154f:	e9 85 00 00 00       	jmp    8015d9 <smalloc+0x108>
	 cprintf("Smalloc : %x \n",ptr);
  801554:	83 ec 08             	sub    $0x8,%esp
  801557:	ff 75 ec             	pushl  -0x14(%ebp)
  80155a:	68 8e 42 80 00       	push   $0x80428e
  80155f:	e8 9f ee ff ff       	call   800403 <cprintf>
  801564:	83 c4 10             	add    $0x10,%esp

	 id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801567:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80156a:	a1 20 50 80 00       	mov    0x805020,%eax
  80156f:	8b 40 78             	mov    0x78(%eax),%eax
  801572:	29 c2                	sub    %eax,%edx
  801574:	89 d0                	mov    %edx,%eax
  801576:	2d 00 10 00 00       	sub    $0x1000,%eax
  80157b:	c1 e8 0c             	shr    $0xc,%eax
  80157e:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801584:	42                   	inc    %edx
  801585:	89 15 24 50 80 00    	mov    %edx,0x805024
  80158b:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801591:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	 ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801598:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80159b:	a1 20 50 80 00       	mov    0x805020,%eax
  8015a0:	8b 40 78             	mov    0x78(%eax),%eax
  8015a3:	29 c2                	sub    %eax,%edx
  8015a5:	89 d0                	mov    %edx,%eax
  8015a7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015ac:	c1 e8 0c             	shr    $0xc,%eax
  8015af:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8015b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8015bb:	8b 50 10             	mov    0x10(%eax),%edx
  8015be:	89 c8                	mov    %ecx,%eax
  8015c0:	c1 e0 02             	shl    $0x2,%eax
  8015c3:	89 c1                	mov    %eax,%ecx
  8015c5:	c1 e1 09             	shl    $0x9,%ecx
  8015c8:	01 c8                	add    %ecx,%eax
  8015ca:	01 c2                	add    %eax,%edx
  8015cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015cf:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  8015d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8015e1:	83 ec 08             	sub    $0x8,%esp
  8015e4:	ff 75 0c             	pushl  0xc(%ebp)
  8015e7:	ff 75 08             	pushl  0x8(%ebp)
  8015ea:	e8 f0 03 00 00       	call   8019df <sys_getSizeOfSharedObject>
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  8015f5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8015f9:	75 0a                	jne    801605 <sget+0x2a>
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801600:	e9 e7 00 00 00       	jmp    8016ec <sget+0x111>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  801605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801608:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80160b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801612:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801618:	39 d0                	cmp    %edx,%eax
  80161a:	73 02                	jae    80161e <sget+0x43>
  80161c:	89 d0                	mov    %edx,%eax
  80161e:	83 ec 0c             	sub    $0xc,%esp
  801621:	50                   	push   %eax
  801622:	e8 8c fb ff ff       	call   8011b3 <malloc>
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  80162d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801631:	75 0a                	jne    80163d <sget+0x62>
  801633:	b8 00 00 00 00       	mov    $0x0,%eax
  801638:	e9 af 00 00 00       	jmp    8016ec <sget+0x111>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	ff 75 e8             	pushl  -0x18(%ebp)
  801643:	ff 75 0c             	pushl  0xc(%ebp)
  801646:	ff 75 08             	pushl  0x8(%ebp)
  801649:	e8 ae 03 00 00       	call   8019fc <sys_getSharedObject>
  80164e:	83 c4 10             	add    $0x10,%esp
  801651:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	id_index[UHEAP_PAGE_INDEX((uint32)ptr)] = ++shared_index;
  801654:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801657:	a1 20 50 80 00       	mov    0x805020,%eax
  80165c:	8b 40 78             	mov    0x78(%eax),%eax
  80165f:	29 c2                	sub    %eax,%edx
  801661:	89 d0                	mov    %edx,%eax
  801663:	2d 00 10 00 00       	sub    $0x1000,%eax
  801668:	c1 e8 0c             	shr    $0xc,%eax
  80166b:	8b 15 24 50 80 00    	mov    0x805024,%edx
  801671:	42                   	inc    %edx
  801672:	89 15 24 50 80 00    	mov    %edx,0x805024
  801678:	8b 15 24 50 80 00    	mov    0x805024,%edx
  80167e:	89 14 85 60 90 00 01 	mov    %edx,0x1009060(,%eax,4)
	ids[ id_index[UHEAP_PAGE_INDEX((uint32)ptr)] ][myEnv->env_id] = ret;
  801685:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801688:	a1 20 50 80 00       	mov    0x805020,%eax
  80168d:	8b 40 78             	mov    0x78(%eax),%eax
  801690:	29 c2                	sub    %eax,%edx
  801692:	89 d0                	mov    %edx,%eax
  801694:	2d 00 10 00 00       	sub    $0x1000,%eax
  801699:	c1 e8 0c             	shr    $0xc,%eax
  80169c:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  8016a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8016a8:	8b 50 10             	mov    0x10(%eax),%edx
  8016ab:	89 c8                	mov    %ecx,%eax
  8016ad:	c1 e0 02             	shl    $0x2,%eax
  8016b0:	89 c1                	mov    %eax,%ecx
  8016b2:	c1 e1 09             	shl    $0x9,%ecx
  8016b5:	01 c8                	add    %ecx,%eax
  8016b7:	01 c2                	add    %eax,%edx
  8016b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016bc:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	cprintf("Env Id : %d\n",myEnv->env_id);
  8016c3:	a1 20 50 80 00       	mov    0x805020,%eax
  8016c8:	8b 40 10             	mov    0x10(%eax),%eax
  8016cb:	83 ec 08             	sub    $0x8,%esp
  8016ce:	50                   	push   %eax
  8016cf:	68 9d 42 80 00       	push   $0x80429d
  8016d4:	e8 2a ed ff ff       	call   800403 <cprintf>
  8016d9:	83 c4 10             	add    $0x10,%esp
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  8016dc:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8016e0:	75 07                	jne    8016e9 <sget+0x10e>
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e7:	eb 03                	jmp    8016ec <sget+0x111>
	return ptr;
  8016e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[id_index[UHEAP_PAGE_INDEX((uint32)virtual_address)]][myEnv->env_id];
  8016f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8016fc:	8b 40 78             	mov    0x78(%eax),%eax
  8016ff:	29 c2                	sub    %eax,%edx
  801701:	89 d0                	mov    %edx,%eax
  801703:	2d 00 10 00 00       	sub    $0x1000,%eax
  801708:	c1 e8 0c             	shr    $0xc,%eax
  80170b:	8b 0c 85 60 90 00 01 	mov    0x1009060(,%eax,4),%ecx
  801712:	a1 20 50 80 00       	mov    0x805020,%eax
  801717:	8b 50 10             	mov    0x10(%eax),%edx
  80171a:	89 c8                	mov    %ecx,%eax
  80171c:	c1 e0 02             	shl    $0x2,%eax
  80171f:	89 c1                	mov    %eax,%ecx
  801721:	c1 e1 09             	shl    $0x9,%ecx
  801724:	01 c8                	add    %ecx,%eax
  801726:	01 d0                	add    %edx,%eax
  801728:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  80172f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801732:	83 ec 08             	sub    $0x8,%esp
  801735:	ff 75 08             	pushl  0x8(%ebp)
  801738:	ff 75 f4             	pushl  -0xc(%ebp)
  80173b:	e8 db 02 00 00       	call   801a1b <sys_freeSharedObject>
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801746:	90                   	nop
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80174f:	83 ec 04             	sub    $0x4,%esp
  801752:	68 ac 42 80 00       	push   $0x8042ac
  801757:	68 e5 00 00 00       	push   $0xe5
  80175c:	68 82 42 80 00       	push   $0x804282
  801761:	e8 8c 21 00 00       	call   8038f2 <_panic>

00801766 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	68 d2 42 80 00       	push   $0x8042d2
  801774:	68 f1 00 00 00       	push   $0xf1
  801779:	68 82 42 80 00       	push   $0x804282
  80177e:	e8 6f 21 00 00       	call   8038f2 <_panic>

00801783 <shrink>:

}
void shrink(uint32 newSize)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	68 d2 42 80 00       	push   $0x8042d2
  801791:	68 f6 00 00 00       	push   $0xf6
  801796:	68 82 42 80 00       	push   $0x804282
  80179b:	e8 52 21 00 00       	call   8038f2 <_panic>

008017a0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a6:	83 ec 04             	sub    $0x4,%esp
  8017a9:	68 d2 42 80 00       	push   $0x8042d2
  8017ae:	68 fb 00 00 00       	push   $0xfb
  8017b3:	68 82 42 80 00       	push   $0x804282
  8017b8:	e8 35 21 00 00       	call   8038f2 <_panic>

008017bd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	57                   	push   %edi
  8017c1:	56                   	push   %esi
  8017c2:	53                   	push   %ebx
  8017c3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017d5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017d8:	cd 30                	int    $0x30
  8017da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	5b                   	pop    %ebx
  8017e4:	5e                   	pop    %esi
  8017e5:	5f                   	pop    %edi
  8017e6:	5d                   	pop    %ebp
  8017e7:	c3                   	ret    

008017e8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017f4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	52                   	push   %edx
  801800:	ff 75 0c             	pushl  0xc(%ebp)
  801803:	50                   	push   %eax
  801804:	6a 00                	push   $0x0
  801806:	e8 b2 ff ff ff       	call   8017bd <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
}
  80180e:	90                   	nop
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_cgetc>:

int
sys_cgetc(void)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 02                	push   $0x2
  801820:	e8 98 ff ff ff       	call   8017bd <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_lock_cons>:

void sys_lock_cons(void)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 03                	push   $0x3
  801839:	e8 7f ff ff ff       	call   8017bd <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	90                   	nop
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 04                	push   $0x4
  801853:	e8 65 ff ff ff       	call   8017bd <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	90                   	nop
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801861:	8b 55 0c             	mov    0xc(%ebp),%edx
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	52                   	push   %edx
  80186e:	50                   	push   %eax
  80186f:	6a 08                	push   $0x8
  801871:	e8 47 ff ff ff       	call   8017bd <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	56                   	push   %esi
  80187f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801880:	8b 75 18             	mov    0x18(%ebp),%esi
  801883:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801886:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801889:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	56                   	push   %esi
  801890:	53                   	push   %ebx
  801891:	51                   	push   %ecx
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	6a 09                	push   $0x9
  801896:	e8 22 ff ff ff       	call   8017bd <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a1:	5b                   	pop    %ebx
  8018a2:	5e                   	pop    %esi
  8018a3:	5d                   	pop    %ebp
  8018a4:	c3                   	ret    

008018a5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	52                   	push   %edx
  8018b5:	50                   	push   %eax
  8018b6:	6a 0a                	push   $0xa
  8018b8:	e8 00 ff ff ff       	call   8017bd <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ce:	ff 75 08             	pushl  0x8(%ebp)
  8018d1:	6a 0b                	push   $0xb
  8018d3:	e8 e5 fe ff ff       	call   8017bd <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 0c                	push   $0xc
  8018ec:	e8 cc fe ff ff       	call   8017bd <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 0d                	push   $0xd
  801905:	e8 b3 fe ff ff       	call   8017bd <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 0e                	push   $0xe
  80191e:	e8 9a fe ff ff       	call   8017bd <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 0f                	push   $0xf
  801937:	e8 81 fe ff ff       	call   8017bd <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	ff 75 08             	pushl  0x8(%ebp)
  80194f:	6a 10                	push   $0x10
  801951:	e8 67 fe ff ff       	call   8017bd <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 11                	push   $0x11
  80196a:	e8 4e fe ff ff       	call   8017bd <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	90                   	nop
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_cputc>:

void
sys_cputc(const char c)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801981:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	50                   	push   %eax
  80198e:	6a 01                	push   $0x1
  801990:	e8 28 fe ff ff       	call   8017bd <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 14                	push   $0x14
  8019aa:	e8 0e fe ff ff       	call   8017bd <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	90                   	nop
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019be:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	6a 00                	push   $0x0
  8019cd:	51                   	push   %ecx
  8019ce:	52                   	push   %edx
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	50                   	push   %eax
  8019d3:	6a 15                	push   $0x15
  8019d5:	e8 e3 fd ff ff       	call   8017bd <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	52                   	push   %edx
  8019ef:	50                   	push   %eax
  8019f0:	6a 16                	push   $0x16
  8019f2:	e8 c6 fd ff ff       	call   8017bd <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	51                   	push   %ecx
  801a0d:	52                   	push   %edx
  801a0e:	50                   	push   %eax
  801a0f:	6a 17                	push   $0x17
  801a11:	e8 a7 fd ff ff       	call   8017bd <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	52                   	push   %edx
  801a2b:	50                   	push   %eax
  801a2c:	6a 18                	push   $0x18
  801a2e:	e8 8a fd ff ff       	call   8017bd <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	6a 00                	push   $0x0
  801a40:	ff 75 14             	pushl  0x14(%ebp)
  801a43:	ff 75 10             	pushl  0x10(%ebp)
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	50                   	push   %eax
  801a4a:	6a 19                	push   $0x19
  801a4c:	e8 6c fd ff ff       	call   8017bd <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	50                   	push   %eax
  801a65:	6a 1a                	push   $0x1a
  801a67:	e8 51 fd ff ff       	call   8017bd <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	90                   	nop
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	50                   	push   %eax
  801a81:	6a 1b                	push   $0x1b
  801a83:	e8 35 fd ff ff       	call   8017bd <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 05                	push   $0x5
  801a9c:	e8 1c fd ff ff       	call   8017bd <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 06                	push   $0x6
  801ab5:	e8 03 fd ff ff       	call   8017bd <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 07                	push   $0x7
  801ace:	e8 ea fc ff ff       	call   8017bd <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_exit_env>:


void sys_exit_env(void)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 1c                	push   $0x1c
  801ae7:	e8 d1 fc ff ff       	call   8017bd <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	90                   	nop
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801af8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801afb:	8d 50 04             	lea    0x4(%eax),%edx
  801afe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 1d                	push   $0x1d
  801b0b:	e8 ad fc ff ff       	call   8017bd <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
	return result;
  801b13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b1c:	89 01                	mov    %eax,(%ecx)
  801b1e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	c9                   	leave  
  801b25:	c2 04 00             	ret    $0x4

00801b28 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	ff 75 10             	pushl  0x10(%ebp)
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	ff 75 08             	pushl  0x8(%ebp)
  801b38:	6a 13                	push   $0x13
  801b3a:	e8 7e fc ff ff       	call   8017bd <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b42:	90                   	nop
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 1e                	push   $0x1e
  801b54:	e8 64 fc ff ff       	call   8017bd <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 04             	sub    $0x4,%esp
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b6a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	50                   	push   %eax
  801b77:	6a 1f                	push   $0x1f
  801b79:	e8 3f fc ff ff       	call   8017bd <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b81:	90                   	nop
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <rsttst>:
void rsttst()
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 21                	push   $0x21
  801b93:	e8 25 fc ff ff       	call   8017bd <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9b:	90                   	nop
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801baa:	8b 55 18             	mov    0x18(%ebp),%edx
  801bad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bb1:	52                   	push   %edx
  801bb2:	50                   	push   %eax
  801bb3:	ff 75 10             	pushl  0x10(%ebp)
  801bb6:	ff 75 0c             	pushl  0xc(%ebp)
  801bb9:	ff 75 08             	pushl  0x8(%ebp)
  801bbc:	6a 20                	push   $0x20
  801bbe:	e8 fa fb ff ff       	call   8017bd <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc6:	90                   	nop
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <chktst>:
void chktst(uint32 n)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	ff 75 08             	pushl  0x8(%ebp)
  801bd7:	6a 22                	push   $0x22
  801bd9:	e8 df fb ff ff       	call   8017bd <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
	return ;
  801be1:	90                   	nop
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <inctst>:

void inctst()
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 23                	push   $0x23
  801bf3:	e8 c5 fb ff ff       	call   8017bd <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfb:	90                   	nop
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <gettst>:
uint32 gettst()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 24                	push   $0x24
  801c0d:	e8 ab fb ff ff       	call   8017bd <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 25                	push   $0x25
  801c29:	e8 8f fb ff ff       	call   8017bd <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
  801c31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c34:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c38:	75 07                	jne    801c41 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3f:	eb 05                	jmp    801c46 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 25                	push   $0x25
  801c5a:	e8 5e fb ff ff       	call   8017bd <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
  801c62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c65:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c69:	75 07                	jne    801c72 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c70:	eb 05                	jmp    801c77 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 25                	push   $0x25
  801c8b:	e8 2d fb ff ff       	call   8017bd <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
  801c93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c96:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c9a:	75 07                	jne    801ca3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca1:	eb 05                	jmp    801ca8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ca3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 25                	push   $0x25
  801cbc:	e8 fc fa ff ff       	call   8017bd <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
  801cc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cc7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ccb:	75 07                	jne    801cd4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ccd:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd2:	eb 05                	jmp    801cd9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	ff 75 08             	pushl  0x8(%ebp)
  801ce9:	6a 26                	push   $0x26
  801ceb:	e8 cd fa ff ff       	call   8017bd <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf3:	90                   	nop
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cfa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cfd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	6a 00                	push   $0x0
  801d08:	53                   	push   %ebx
  801d09:	51                   	push   %ecx
  801d0a:	52                   	push   %edx
  801d0b:	50                   	push   %eax
  801d0c:	6a 27                	push   $0x27
  801d0e:	e8 aa fa ff ff       	call   8017bd <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	52                   	push   %edx
  801d2b:	50                   	push   %eax
  801d2c:	6a 28                	push   $0x28
  801d2e:	e8 8a fa ff ff       	call   8017bd <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801d3b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	6a 00                	push   $0x0
  801d46:	51                   	push   %ecx
  801d47:	ff 75 10             	pushl  0x10(%ebp)
  801d4a:	52                   	push   %edx
  801d4b:	50                   	push   %eax
  801d4c:	6a 29                	push   $0x29
  801d4e:	e8 6a fa ff ff       	call   8017bd <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	ff 75 10             	pushl  0x10(%ebp)
  801d62:	ff 75 0c             	pushl  0xc(%ebp)
  801d65:	ff 75 08             	pushl  0x8(%ebp)
  801d68:	6a 12                	push   $0x12
  801d6a:	e8 4e fa ff ff       	call   8017bd <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d72:	90                   	nop
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801d78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	52                   	push   %edx
  801d85:	50                   	push   %eax
  801d86:	6a 2a                	push   $0x2a
  801d88:	e8 30 fa ff ff       	call   8017bd <syscall>
  801d8d:	83 c4 18             	add    $0x18,%esp
	return;
  801d90:	90                   	nop
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	50                   	push   %eax
  801da2:	6a 2b                	push   $0x2b
  801da4:	e8 14 fa ff ff       	call   8017bd <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	ff 75 0c             	pushl  0xc(%ebp)
  801dba:	ff 75 08             	pushl  0x8(%ebp)
  801dbd:	6a 2c                	push   $0x2c
  801dbf:	e8 f9 f9 ff ff       	call   8017bd <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
	return;
  801dc7:	90                   	nop
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	ff 75 0c             	pushl  0xc(%ebp)
  801dd6:	ff 75 08             	pushl  0x8(%ebp)
  801dd9:	6a 2d                	push   $0x2d
  801ddb:	e8 dd f9 ff ff       	call   8017bd <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
	return;
  801de3:	90                   	nop
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	83 e8 04             	sub    $0x4,%eax
  801df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801df8:	8b 00                	mov    (%eax),%eax
  801dfa:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	83 e8 04             	sub    $0x4,%eax
  801e0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e11:	8b 00                	mov    (%eax),%eax
  801e13:	83 e0 01             	and    $0x1,%eax
  801e16:	85 c0                	test   %eax,%eax
  801e18:	0f 94 c0             	sete   %al
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801e23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2d:	83 f8 02             	cmp    $0x2,%eax
  801e30:	74 2b                	je     801e5d <alloc_block+0x40>
  801e32:	83 f8 02             	cmp    $0x2,%eax
  801e35:	7f 07                	jg     801e3e <alloc_block+0x21>
  801e37:	83 f8 01             	cmp    $0x1,%eax
  801e3a:	74 0e                	je     801e4a <alloc_block+0x2d>
  801e3c:	eb 58                	jmp    801e96 <alloc_block+0x79>
  801e3e:	83 f8 03             	cmp    $0x3,%eax
  801e41:	74 2d                	je     801e70 <alloc_block+0x53>
  801e43:	83 f8 04             	cmp    $0x4,%eax
  801e46:	74 3b                	je     801e83 <alloc_block+0x66>
  801e48:	eb 4c                	jmp    801e96 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801e4a:	83 ec 0c             	sub    $0xc,%esp
  801e4d:	ff 75 08             	pushl  0x8(%ebp)
  801e50:	e8 11 03 00 00       	call   802166 <alloc_block_FF>
  801e55:	83 c4 10             	add    $0x10,%esp
  801e58:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e5b:	eb 4a                	jmp    801ea7 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e5d:	83 ec 0c             	sub    $0xc,%esp
  801e60:	ff 75 08             	pushl  0x8(%ebp)
  801e63:	e8 fa 19 00 00       	call   803862 <alloc_block_NF>
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e6e:	eb 37                	jmp    801ea7 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e70:	83 ec 0c             	sub    $0xc,%esp
  801e73:	ff 75 08             	pushl  0x8(%ebp)
  801e76:	e8 a7 07 00 00       	call   802622 <alloc_block_BF>
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e81:	eb 24                	jmp    801ea7 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e83:	83 ec 0c             	sub    $0xc,%esp
  801e86:	ff 75 08             	pushl  0x8(%ebp)
  801e89:	e8 b7 19 00 00       	call   803845 <alloc_block_WF>
  801e8e:	83 c4 10             	add    $0x10,%esp
  801e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e94:	eb 11                	jmp    801ea7 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	68 e4 42 80 00       	push   $0x8042e4
  801e9e:	e8 60 e5 ff ff       	call   800403 <cprintf>
  801ea3:	83 c4 10             	add    $0x10,%esp
		break;
  801ea6:	90                   	nop
	}
	return va;
  801ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	53                   	push   %ebx
  801eb0:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801eb3:	83 ec 0c             	sub    $0xc,%esp
  801eb6:	68 04 43 80 00       	push   $0x804304
  801ebb:	e8 43 e5 ff ff       	call   800403 <cprintf>
  801ec0:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801ec3:	83 ec 0c             	sub    $0xc,%esp
  801ec6:	68 2f 43 80 00       	push   $0x80432f
  801ecb:	e8 33 e5 ff ff       	call   800403 <cprintf>
  801ed0:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed9:	eb 37                	jmp    801f12 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801edb:	83 ec 0c             	sub    $0xc,%esp
  801ede:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee1:	e8 19 ff ff ff       	call   801dff <is_free_block>
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	0f be d8             	movsbl %al,%ebx
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef2:	e8 ef fe ff ff       	call   801de6 <get_block_size>
  801ef7:	83 c4 10             	add    $0x10,%esp
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	53                   	push   %ebx
  801efe:	50                   	push   %eax
  801eff:	68 47 43 80 00       	push   $0x804347
  801f04:	e8 fa e4 ff ff       	call   800403 <cprintf>
  801f09:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f16:	74 07                	je     801f1f <print_blocks_list+0x73>
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	8b 00                	mov    (%eax),%eax
  801f1d:	eb 05                	jmp    801f24 <print_blocks_list+0x78>
  801f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f24:	89 45 10             	mov    %eax,0x10(%ebp)
  801f27:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	75 ad                	jne    801edb <print_blocks_list+0x2f>
  801f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f32:	75 a7                	jne    801edb <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801f34:	83 ec 0c             	sub    $0xc,%esp
  801f37:	68 04 43 80 00       	push   $0x804304
  801f3c:	e8 c2 e4 ff ff       	call   800403 <cprintf>
  801f41:	83 c4 10             	add    $0x10,%esp

}
  801f44:	90                   	nop
  801f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f53:	83 e0 01             	and    $0x1,%eax
  801f56:	85 c0                	test   %eax,%eax
  801f58:	74 03                	je     801f5d <initialize_dynamic_allocator+0x13>
  801f5a:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f61:	0f 84 c7 01 00 00    	je     80212e <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f67:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  801f6e:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f71:	8b 55 08             	mov    0x8(%ebp),%edx
  801f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f77:	01 d0                	add    %edx,%eax
  801f79:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f7e:	0f 87 ad 01 00 00    	ja     802131 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	85 c0                	test   %eax,%eax
  801f89:	0f 89 a5 01 00 00    	jns    802134 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  801f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f95:	01 d0                	add    %edx,%eax
  801f97:	83 e8 04             	sub    $0x4,%eax
  801f9a:	a3 48 50 80 00       	mov    %eax,0x805048
     struct BlockElement * element = NULL;
  801f9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801fa6:	a1 30 50 80 00       	mov    0x805030,%eax
  801fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fae:	e9 87 00 00 00       	jmp    80203a <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801fb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb7:	75 14                	jne    801fcd <initialize_dynamic_allocator+0x83>
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	68 5f 43 80 00       	push   $0x80435f
  801fc1:	6a 79                	push   $0x79
  801fc3:	68 7d 43 80 00       	push   $0x80437d
  801fc8:	e8 25 19 00 00       	call   8038f2 <_panic>
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	8b 00                	mov    (%eax),%eax
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	74 10                	je     801fe6 <initialize_dynamic_allocator+0x9c>
  801fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd9:	8b 00                	mov    (%eax),%eax
  801fdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fde:	8b 52 04             	mov    0x4(%edx),%edx
  801fe1:	89 50 04             	mov    %edx,0x4(%eax)
  801fe4:	eb 0b                	jmp    801ff1 <initialize_dynamic_allocator+0xa7>
  801fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe9:	8b 40 04             	mov    0x4(%eax),%eax
  801fec:	a3 34 50 80 00       	mov    %eax,0x805034
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	8b 40 04             	mov    0x4(%eax),%eax
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	74 0f                	je     80200a <initialize_dynamic_allocator+0xc0>
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	8b 40 04             	mov    0x4(%eax),%eax
  802001:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802004:	8b 12                	mov    (%edx),%edx
  802006:	89 10                	mov    %edx,(%eax)
  802008:	eb 0a                	jmp    802014 <initialize_dynamic_allocator+0xca>
  80200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200d:	8b 00                	mov    (%eax),%eax
  80200f:	a3 30 50 80 00       	mov    %eax,0x805030
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802027:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80202c:	48                   	dec    %eax
  80202d:	a3 3c 50 80 00       	mov    %eax,0x80503c
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  802032:	a1 38 50 80 00       	mov    0x805038,%eax
  802037:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203e:	74 07                	je     802047 <initialize_dynamic_allocator+0xfd>
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	8b 00                	mov    (%eax),%eax
  802045:	eb 05                	jmp    80204c <initialize_dynamic_allocator+0x102>
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
  80204c:	a3 38 50 80 00       	mov    %eax,0x805038
  802051:	a1 38 50 80 00       	mov    0x805038,%eax
  802056:	85 c0                	test   %eax,%eax
  802058:	0f 85 55 ff ff ff    	jne    801fb3 <initialize_dynamic_allocator+0x69>
  80205e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802062:	0f 85 4b ff ff ff    	jne    801fb3 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80206e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802071:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802077:	a1 48 50 80 00       	mov    0x805048,%eax
  80207c:	a3 44 50 80 00       	mov    %eax,0x805044
    end_block->info = 1;
  802081:	a1 44 50 80 00       	mov    0x805044,%eax
  802086:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	83 c0 08             	add    $0x8,%eax
  802092:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	83 c0 04             	add    $0x4,%eax
  80209b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209e:	83 ea 08             	sub    $0x8,%edx
  8020a1:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  8020a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	01 d0                	add    %edx,%eax
  8020ab:	83 e8 08             	sub    $0x8,%eax
  8020ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b1:	83 ea 08             	sub    $0x8,%edx
  8020b4:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  8020b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  8020bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  8020c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020cd:	75 17                	jne    8020e6 <initialize_dynamic_allocator+0x19c>
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	68 98 43 80 00       	push   $0x804398
  8020d7:	68 90 00 00 00       	push   $0x90
  8020dc:	68 7d 43 80 00       	push   $0x80437d
  8020e1:	e8 0c 18 00 00       	call   8038f2 <_panic>
  8020e6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8020ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ef:	89 10                	mov    %edx,(%eax)
  8020f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f4:	8b 00                	mov    (%eax),%eax
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	74 0d                	je     802107 <initialize_dynamic_allocator+0x1bd>
  8020fa:	a1 30 50 80 00       	mov    0x805030,%eax
  8020ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802102:	89 50 04             	mov    %edx,0x4(%eax)
  802105:	eb 08                	jmp    80210f <initialize_dynamic_allocator+0x1c5>
  802107:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210a:	a3 34 50 80 00       	mov    %eax,0x805034
  80210f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802112:	a3 30 50 80 00       	mov    %eax,0x805030
  802117:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802121:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802126:	40                   	inc    %eax
  802127:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80212c:	eb 07                	jmp    802135 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  80212e:	90                   	nop
  80212f:	eb 04                	jmp    802135 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  802131:	90                   	nop
  802132:	eb 01                	jmp    802135 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  802134:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  80213a:	8b 45 10             	mov    0x10(%ebp),%eax
  80213d:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	8d 50 fc             	lea    -0x4(%eax),%edx
  802146:	8b 45 0c             	mov    0xc(%ebp),%eax
  802149:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	83 e8 04             	sub    $0x4,%eax
  802151:	8b 00                	mov    (%eax),%eax
  802153:	83 e0 fe             	and    $0xfffffffe,%eax
  802156:	8d 50 f8             	lea    -0x8(%eax),%edx
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	01 c2                	add    %eax,%edx
  80215e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802161:	89 02                	mov    %eax,(%edx)
}
  802163:	90                   	nop
  802164:	5d                   	pop    %ebp
  802165:	c3                   	ret    

00802166 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	83 e0 01             	and    $0x1,%eax
  802172:	85 c0                	test   %eax,%eax
  802174:	74 03                	je     802179 <alloc_block_FF+0x13>
  802176:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802179:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80217d:	77 07                	ja     802186 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80217f:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802186:	a1 28 50 80 00       	mov    0x805028,%eax
  80218b:	85 c0                	test   %eax,%eax
  80218d:	75 73                	jne    802202 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	83 c0 10             	add    $0x10,%eax
  802195:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802198:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80219f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a5:	01 d0                	add    %edx,%eax
  8021a7:	48                   	dec    %eax
  8021a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b3:	f7 75 ec             	divl   -0x14(%ebp)
  8021b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021b9:	29 d0                	sub    %edx,%eax
  8021bb:	c1 e8 0c             	shr    $0xc,%eax
  8021be:	83 ec 0c             	sub    $0xc,%esp
  8021c1:	50                   	push   %eax
  8021c2:	e8 d6 ef ff ff       	call   80119d <sbrk>
  8021c7:	83 c4 10             	add    $0x10,%esp
  8021ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8021cd:	83 ec 0c             	sub    $0xc,%esp
  8021d0:	6a 00                	push   $0x0
  8021d2:	e8 c6 ef ff ff       	call   80119d <sbrk>
  8021d7:	83 c4 10             	add    $0x10,%esp
  8021da:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8021dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8021e3:	83 ec 08             	sub    $0x8,%esp
  8021e6:	50                   	push   %eax
  8021e7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021ea:	e8 5b fd ff ff       	call   801f4a <initialize_dynamic_allocator>
  8021ef:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8021f2:	83 ec 0c             	sub    $0xc,%esp
  8021f5:	68 bb 43 80 00       	push   $0x8043bb
  8021fa:	e8 04 e2 ff ff       	call   800403 <cprintf>
  8021ff:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  802202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802206:	75 0a                	jne    802212 <alloc_block_FF+0xac>
	        return NULL;
  802208:	b8 00 00 00 00       	mov    $0x0,%eax
  80220d:	e9 0e 04 00 00       	jmp    802620 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  802212:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  802219:	a1 30 50 80 00       	mov    0x805030,%eax
  80221e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802221:	e9 f3 02 00 00       	jmp    802519 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  80222c:	83 ec 0c             	sub    $0xc,%esp
  80222f:	ff 75 bc             	pushl  -0x44(%ebp)
  802232:	e8 af fb ff ff       	call   801de6 <get_block_size>
  802237:	83 c4 10             	add    $0x10,%esp
  80223a:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	83 c0 08             	add    $0x8,%eax
  802243:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802246:	0f 87 c5 02 00 00    	ja     802511 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	83 c0 18             	add    $0x18,%eax
  802252:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802255:	0f 87 19 02 00 00    	ja     802474 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80225b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80225e:	2b 45 08             	sub    0x8(%ebp),%eax
  802261:	83 e8 08             	sub    $0x8,%eax
  802264:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	8d 50 08             	lea    0x8(%eax),%edx
  80226d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802270:	01 d0                	add    %edx,%eax
  802272:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	83 c0 08             	add    $0x8,%eax
  80227b:	83 ec 04             	sub    $0x4,%esp
  80227e:	6a 01                	push   $0x1
  802280:	50                   	push   %eax
  802281:	ff 75 bc             	pushl  -0x44(%ebp)
  802284:	e8 ae fe ff ff       	call   802137 <set_block_data>
  802289:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	8b 40 04             	mov    0x4(%eax),%eax
  802292:	85 c0                	test   %eax,%eax
  802294:	75 68                	jne    8022fe <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802296:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80229a:	75 17                	jne    8022b3 <alloc_block_FF+0x14d>
  80229c:	83 ec 04             	sub    $0x4,%esp
  80229f:	68 98 43 80 00       	push   $0x804398
  8022a4:	68 d7 00 00 00       	push   $0xd7
  8022a9:	68 7d 43 80 00       	push   $0x80437d
  8022ae:	e8 3f 16 00 00       	call   8038f2 <_panic>
  8022b3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8022b9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022bc:	89 10                	mov    %edx,(%eax)
  8022be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022c1:	8b 00                	mov    (%eax),%eax
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	74 0d                	je     8022d4 <alloc_block_FF+0x16e>
  8022c7:	a1 30 50 80 00       	mov    0x805030,%eax
  8022cc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022cf:	89 50 04             	mov    %edx,0x4(%eax)
  8022d2:	eb 08                	jmp    8022dc <alloc_block_FF+0x176>
  8022d4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022d7:	a3 34 50 80 00       	mov    %eax,0x805034
  8022dc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022df:	a3 30 50 80 00       	mov    %eax,0x805030
  8022e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ee:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8022f3:	40                   	inc    %eax
  8022f4:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8022f9:	e9 dc 00 00 00       	jmp    8023da <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	8b 00                	mov    (%eax),%eax
  802303:	85 c0                	test   %eax,%eax
  802305:	75 65                	jne    80236c <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  802307:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  80230b:	75 17                	jne    802324 <alloc_block_FF+0x1be>
  80230d:	83 ec 04             	sub    $0x4,%esp
  802310:	68 cc 43 80 00       	push   $0x8043cc
  802315:	68 db 00 00 00       	push   $0xdb
  80231a:	68 7d 43 80 00       	push   $0x80437d
  80231f:	e8 ce 15 00 00       	call   8038f2 <_panic>
  802324:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80232a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80232d:	89 50 04             	mov    %edx,0x4(%eax)
  802330:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802333:	8b 40 04             	mov    0x4(%eax),%eax
  802336:	85 c0                	test   %eax,%eax
  802338:	74 0c                	je     802346 <alloc_block_FF+0x1e0>
  80233a:	a1 34 50 80 00       	mov    0x805034,%eax
  80233f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802342:	89 10                	mov    %edx,(%eax)
  802344:	eb 08                	jmp    80234e <alloc_block_FF+0x1e8>
  802346:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802349:	a3 30 50 80 00       	mov    %eax,0x805030
  80234e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802351:	a3 34 50 80 00       	mov    %eax,0x805034
  802356:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802359:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80235f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802364:	40                   	inc    %eax
  802365:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80236a:	eb 6e                	jmp    8023da <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80236c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802370:	74 06                	je     802378 <alloc_block_FF+0x212>
  802372:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802376:	75 17                	jne    80238f <alloc_block_FF+0x229>
  802378:	83 ec 04             	sub    $0x4,%esp
  80237b:	68 f0 43 80 00       	push   $0x8043f0
  802380:	68 df 00 00 00       	push   $0xdf
  802385:	68 7d 43 80 00       	push   $0x80437d
  80238a:	e8 63 15 00 00       	call   8038f2 <_panic>
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	8b 10                	mov    (%eax),%edx
  802394:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802397:	89 10                	mov    %edx,(%eax)
  802399:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	74 0b                	je     8023ad <alloc_block_FF+0x247>
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	8b 00                	mov    (%eax),%eax
  8023a7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023aa:	89 50 04             	mov    %edx,0x4(%eax)
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8023b3:	89 10                	mov    %edx,(%eax)
  8023b5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023bb:	89 50 04             	mov    %edx,0x4(%eax)
  8023be:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023c1:	8b 00                	mov    (%eax),%eax
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	75 08                	jne    8023cf <alloc_block_FF+0x269>
  8023c7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8023ca:	a3 34 50 80 00       	mov    %eax,0x805034
  8023cf:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8023d4:	40                   	inc    %eax
  8023d5:	a3 3c 50 80 00       	mov    %eax,0x80503c
				}
				LIST_REMOVE(&freeBlocksList, blk);
  8023da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023de:	75 17                	jne    8023f7 <alloc_block_FF+0x291>
  8023e0:	83 ec 04             	sub    $0x4,%esp
  8023e3:	68 5f 43 80 00       	push   $0x80435f
  8023e8:	68 e1 00 00 00       	push   $0xe1
  8023ed:	68 7d 43 80 00       	push   $0x80437d
  8023f2:	e8 fb 14 00 00       	call   8038f2 <_panic>
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	85 c0                	test   %eax,%eax
  8023fe:	74 10                	je     802410 <alloc_block_FF+0x2aa>
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802403:	8b 00                	mov    (%eax),%eax
  802405:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802408:	8b 52 04             	mov    0x4(%edx),%edx
  80240b:	89 50 04             	mov    %edx,0x4(%eax)
  80240e:	eb 0b                	jmp    80241b <alloc_block_FF+0x2b5>
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 40 04             	mov    0x4(%eax),%eax
  802416:	a3 34 50 80 00       	mov    %eax,0x805034
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	85 c0                	test   %eax,%eax
  802423:	74 0f                	je     802434 <alloc_block_FF+0x2ce>
  802425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802428:	8b 40 04             	mov    0x4(%eax),%eax
  80242b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242e:	8b 12                	mov    (%edx),%edx
  802430:	89 10                	mov    %edx,(%eax)
  802432:	eb 0a                	jmp    80243e <alloc_block_FF+0x2d8>
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 00                	mov    (%eax),%eax
  802439:	a3 30 50 80 00       	mov    %eax,0x805030
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802451:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802456:	48                   	dec    %eax
  802457:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(new_block_va, remaining_size, 0);
  80245c:	83 ec 04             	sub    $0x4,%esp
  80245f:	6a 00                	push   $0x0
  802461:	ff 75 b4             	pushl  -0x4c(%ebp)
  802464:	ff 75 b0             	pushl  -0x50(%ebp)
  802467:	e8 cb fc ff ff       	call   802137 <set_block_data>
  80246c:	83 c4 10             	add    $0x10,%esp
  80246f:	e9 95 00 00 00       	jmp    802509 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802474:	83 ec 04             	sub    $0x4,%esp
  802477:	6a 01                	push   $0x1
  802479:	ff 75 b8             	pushl  -0x48(%ebp)
  80247c:	ff 75 bc             	pushl  -0x44(%ebp)
  80247f:	e8 b3 fc ff ff       	call   802137 <set_block_data>
  802484:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802487:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248b:	75 17                	jne    8024a4 <alloc_block_FF+0x33e>
  80248d:	83 ec 04             	sub    $0x4,%esp
  802490:	68 5f 43 80 00       	push   $0x80435f
  802495:	68 e8 00 00 00       	push   $0xe8
  80249a:	68 7d 43 80 00       	push   $0x80437d
  80249f:	e8 4e 14 00 00       	call   8038f2 <_panic>
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 00                	mov    (%eax),%eax
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	74 10                	je     8024bd <alloc_block_FF+0x357>
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 00                	mov    (%eax),%eax
  8024b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b5:	8b 52 04             	mov    0x4(%edx),%edx
  8024b8:	89 50 04             	mov    %edx,0x4(%eax)
  8024bb:	eb 0b                	jmp    8024c8 <alloc_block_FF+0x362>
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	a3 34 50 80 00       	mov    %eax,0x805034
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 40 04             	mov    0x4(%eax),%eax
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	74 0f                	je     8024e1 <alloc_block_FF+0x37b>
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	8b 40 04             	mov    0x4(%eax),%eax
  8024d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024db:	8b 12                	mov    (%edx),%edx
  8024dd:	89 10                	mov    %edx,(%eax)
  8024df:	eb 0a                	jmp    8024eb <alloc_block_FF+0x385>
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	a3 30 50 80 00       	mov    %eax,0x805030
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024fe:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802503:	48                   	dec    %eax
  802504:	a3 3c 50 80 00       	mov    %eax,0x80503c
	            }
	            return va;
  802509:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80250c:	e9 0f 01 00 00       	jmp    802620 <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  802511:	a1 38 50 80 00       	mov    0x805038,%eax
  802516:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251d:	74 07                	je     802526 <alloc_block_FF+0x3c0>
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 00                	mov    (%eax),%eax
  802524:	eb 05                	jmp    80252b <alloc_block_FF+0x3c5>
  802526:	b8 00 00 00 00       	mov    $0x0,%eax
  80252b:	a3 38 50 80 00       	mov    %eax,0x805038
  802530:	a1 38 50 80 00       	mov    0x805038,%eax
  802535:	85 c0                	test   %eax,%eax
  802537:	0f 85 e9 fc ff ff    	jne    802226 <alloc_block_FF+0xc0>
  80253d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802541:	0f 85 df fc ff ff    	jne    802226 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	83 c0 08             	add    $0x8,%eax
  80254d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802550:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802557:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80255a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80255d:	01 d0                	add    %edx,%eax
  80255f:	48                   	dec    %eax
  802560:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802563:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802566:	ba 00 00 00 00       	mov    $0x0,%edx
  80256b:	f7 75 d8             	divl   -0x28(%ebp)
  80256e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802571:	29 d0                	sub    %edx,%eax
  802573:	c1 e8 0c             	shr    $0xc,%eax
  802576:	83 ec 0c             	sub    $0xc,%esp
  802579:	50                   	push   %eax
  80257a:	e8 1e ec ff ff       	call   80119d <sbrk>
  80257f:	83 c4 10             	add    $0x10,%esp
  802582:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802585:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802589:	75 0a                	jne    802595 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80258b:	b8 00 00 00 00       	mov    $0x0,%eax
  802590:	e9 8b 00 00 00       	jmp    802620 <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802595:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80259c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80259f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025a2:	01 d0                	add    %edx,%eax
  8025a4:	48                   	dec    %eax
  8025a5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025a8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b0:	f7 75 cc             	divl   -0x34(%ebp)
  8025b3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025b6:	29 d0                	sub    %edx,%eax
  8025b8:	8d 50 fc             	lea    -0x4(%eax),%edx
  8025bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025be:	01 d0                	add    %edx,%eax
  8025c0:	a3 44 50 80 00       	mov    %eax,0x805044
			end_block->info = 1;
  8025c5:	a1 44 50 80 00       	mov    0x805044,%eax
  8025ca:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  8025d0:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  8025d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8025dd:	01 d0                	add    %edx,%eax
  8025df:	48                   	dec    %eax
  8025e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8025e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8025eb:	f7 75 c4             	divl   -0x3c(%ebp)
  8025ee:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025f1:	29 d0                	sub    %edx,%eax
  8025f3:	83 ec 04             	sub    $0x4,%esp
  8025f6:	6a 01                	push   $0x1
  8025f8:	50                   	push   %eax
  8025f9:	ff 75 d0             	pushl  -0x30(%ebp)
  8025fc:	e8 36 fb ff ff       	call   802137 <set_block_data>
  802601:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  802604:	83 ec 0c             	sub    $0xc,%esp
  802607:	ff 75 d0             	pushl  -0x30(%ebp)
  80260a:	e8 1b 0a 00 00       	call   80302a <free_block>
  80260f:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  802612:	83 ec 0c             	sub    $0xc,%esp
  802615:	ff 75 08             	pushl  0x8(%ebp)
  802618:	e8 49 fb ff ff       	call   802166 <alloc_block_FF>
  80261d:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  802620:	c9                   	leave  
  802621:	c3                   	ret    

00802622 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
  802625:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802628:	8b 45 08             	mov    0x8(%ebp),%eax
  80262b:	83 e0 01             	and    $0x1,%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	74 03                	je     802635 <alloc_block_BF+0x13>
  802632:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802635:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802639:	77 07                	ja     802642 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80263b:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802642:	a1 28 50 80 00       	mov    0x805028,%eax
  802647:	85 c0                	test   %eax,%eax
  802649:	75 73                	jne    8026be <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	83 c0 10             	add    $0x10,%eax
  802651:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802654:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80265b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80265e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802661:	01 d0                	add    %edx,%eax
  802663:	48                   	dec    %eax
  802664:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802667:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80266a:	ba 00 00 00 00       	mov    $0x0,%edx
  80266f:	f7 75 e0             	divl   -0x20(%ebp)
  802672:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802675:	29 d0                	sub    %edx,%eax
  802677:	c1 e8 0c             	shr    $0xc,%eax
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	50                   	push   %eax
  80267e:	e8 1a eb ff ff       	call   80119d <sbrk>
  802683:	83 c4 10             	add    $0x10,%esp
  802686:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802689:	83 ec 0c             	sub    $0xc,%esp
  80268c:	6a 00                	push   $0x0
  80268e:	e8 0a eb ff ff       	call   80119d <sbrk>
  802693:	83 c4 10             	add    $0x10,%esp
  802696:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802699:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80269c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80269f:	83 ec 08             	sub    $0x8,%esp
  8026a2:	50                   	push   %eax
  8026a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8026a6:	e8 9f f8 ff ff       	call   801f4a <initialize_dynamic_allocator>
  8026ab:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8026ae:	83 ec 0c             	sub    $0xc,%esp
  8026b1:	68 bb 43 80 00       	push   $0x8043bb
  8026b6:	e8 48 dd ff ff       	call   800403 <cprintf>
  8026bb:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  8026be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  8026c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  8026cc:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  8026d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  8026da:	a1 30 50 80 00       	mov    0x805030,%eax
  8026df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e2:	e9 1d 01 00 00       	jmp    802804 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  8026ed:	83 ec 0c             	sub    $0xc,%esp
  8026f0:	ff 75 a8             	pushl  -0x58(%ebp)
  8026f3:	e8 ee f6 ff ff       	call   801de6 <get_block_size>
  8026f8:	83 c4 10             	add    $0x10,%esp
  8026fb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8026fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802701:	83 c0 08             	add    $0x8,%eax
  802704:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802707:	0f 87 ef 00 00 00    	ja     8027fc <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  80270d:	8b 45 08             	mov    0x8(%ebp),%eax
  802710:	83 c0 18             	add    $0x18,%eax
  802713:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802716:	77 1d                	ja     802735 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  802718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80271e:	0f 86 d8 00 00 00    	jbe    8027fc <alloc_block_BF+0x1da>
				{
					best_va = va;
  802724:	8b 45 a8             	mov    -0x58(%ebp),%eax
  802727:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  80272a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80272d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802730:	e9 c7 00 00 00       	jmp    8027fc <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	83 c0 08             	add    $0x8,%eax
  80273b:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  80273e:	0f 85 9d 00 00 00    	jne    8027e1 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  802744:	83 ec 04             	sub    $0x4,%esp
  802747:	6a 01                	push   $0x1
  802749:	ff 75 a4             	pushl  -0x5c(%ebp)
  80274c:	ff 75 a8             	pushl  -0x58(%ebp)
  80274f:	e8 e3 f9 ff ff       	call   802137 <set_block_data>
  802754:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275b:	75 17                	jne    802774 <alloc_block_BF+0x152>
  80275d:	83 ec 04             	sub    $0x4,%esp
  802760:	68 5f 43 80 00       	push   $0x80435f
  802765:	68 2c 01 00 00       	push   $0x12c
  80276a:	68 7d 43 80 00       	push   $0x80437d
  80276f:	e8 7e 11 00 00       	call   8038f2 <_panic>
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	85 c0                	test   %eax,%eax
  80277b:	74 10                	je     80278d <alloc_block_BF+0x16b>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802785:	8b 52 04             	mov    0x4(%edx),%edx
  802788:	89 50 04             	mov    %edx,0x4(%eax)
  80278b:	eb 0b                	jmp    802798 <alloc_block_BF+0x176>
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 40 04             	mov    0x4(%eax),%eax
  802793:	a3 34 50 80 00       	mov    %eax,0x805034
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	74 0f                	je     8027b1 <alloc_block_BF+0x18f>
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 40 04             	mov    0x4(%eax),%eax
  8027a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ab:	8b 12                	mov    (%edx),%edx
  8027ad:	89 10                	mov    %edx,(%eax)
  8027af:	eb 0a                	jmp    8027bb <alloc_block_BF+0x199>
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	a3 30 50 80 00       	mov    %eax,0x805030
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ce:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8027d3:	48                   	dec    %eax
  8027d4:	a3 3c 50 80 00       	mov    %eax,0x80503c
					return va;
  8027d9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027dc:	e9 24 04 00 00       	jmp    802c05 <alloc_block_BF+0x5e3>
				}
				else
				{
					if (best_blk_size > blk_size)
  8027e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e4:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8027e7:	76 13                	jbe    8027fc <alloc_block_BF+0x1da>
					{
						internal = 1;
  8027e9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  8027f0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8027f6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027f9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8027fc:	a1 38 50 80 00       	mov    0x805038,%eax
  802801:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802804:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802808:	74 07                	je     802811 <alloc_block_BF+0x1ef>
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	eb 05                	jmp    802816 <alloc_block_BF+0x1f4>
  802811:	b8 00 00 00 00       	mov    $0x0,%eax
  802816:	a3 38 50 80 00       	mov    %eax,0x805038
  80281b:	a1 38 50 80 00       	mov    0x805038,%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	0f 85 bf fe ff ff    	jne    8026e7 <alloc_block_BF+0xc5>
  802828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282c:	0f 85 b5 fe ff ff    	jne    8026e7 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  802832:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802836:	0f 84 26 02 00 00    	je     802a62 <alloc_block_BF+0x440>
  80283c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802840:	0f 85 1c 02 00 00    	jne    802a62 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  802846:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802849:	2b 45 08             	sub    0x8(%ebp),%eax
  80284c:	83 e8 08             	sub    $0x8,%eax
  80284f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	8d 50 08             	lea    0x8(%eax),%edx
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	01 d0                	add    %edx,%eax
  80285d:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	83 c0 08             	add    $0x8,%eax
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	6a 01                	push   $0x1
  80286b:	50                   	push   %eax
  80286c:	ff 75 f0             	pushl  -0x10(%ebp)
  80286f:	e8 c3 f8 ff ff       	call   802137 <set_block_data>
  802874:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	8b 40 04             	mov    0x4(%eax),%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	75 68                	jne    8028e9 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802881:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802885:	75 17                	jne    80289e <alloc_block_BF+0x27c>
  802887:	83 ec 04             	sub    $0x4,%esp
  80288a:	68 98 43 80 00       	push   $0x804398
  80288f:	68 45 01 00 00       	push   $0x145
  802894:	68 7d 43 80 00       	push   $0x80437d
  802899:	e8 54 10 00 00       	call   8038f2 <_panic>
  80289e:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028a7:	89 10                	mov    %edx,(%eax)
  8028a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	74 0d                	je     8028bf <alloc_block_BF+0x29d>
  8028b2:	a1 30 50 80 00       	mov    0x805030,%eax
  8028b7:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028ba:	89 50 04             	mov    %edx,0x4(%eax)
  8028bd:	eb 08                	jmp    8028c7 <alloc_block_BF+0x2a5>
  8028bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c2:	a3 34 50 80 00       	mov    %eax,0x805034
  8028c7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028ca:	a3 30 50 80 00       	mov    %eax,0x805030
  8028cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d9:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8028de:	40                   	inc    %eax
  8028df:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8028e4:	e9 dc 00 00 00       	jmp    8029c5 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  8028e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ec:	8b 00                	mov    (%eax),%eax
  8028ee:	85 c0                	test   %eax,%eax
  8028f0:	75 65                	jne    802957 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028f2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028f6:	75 17                	jne    80290f <alloc_block_BF+0x2ed>
  8028f8:	83 ec 04             	sub    $0x4,%esp
  8028fb:	68 cc 43 80 00       	push   $0x8043cc
  802900:	68 4a 01 00 00       	push   $0x14a
  802905:	68 7d 43 80 00       	push   $0x80437d
  80290a:	e8 e3 0f 00 00       	call   8038f2 <_panic>
  80290f:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802915:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802918:	89 50 04             	mov    %edx,0x4(%eax)
  80291b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	74 0c                	je     802931 <alloc_block_BF+0x30f>
  802925:	a1 34 50 80 00       	mov    0x805034,%eax
  80292a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80292d:	89 10                	mov    %edx,(%eax)
  80292f:	eb 08                	jmp    802939 <alloc_block_BF+0x317>
  802931:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802934:	a3 30 50 80 00       	mov    %eax,0x805030
  802939:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80293c:	a3 34 50 80 00       	mov    %eax,0x805034
  802941:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802944:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80294f:	40                   	inc    %eax
  802950:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802955:	eb 6e                	jmp    8029c5 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802957:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80295b:	74 06                	je     802963 <alloc_block_BF+0x341>
  80295d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802961:	75 17                	jne    80297a <alloc_block_BF+0x358>
  802963:	83 ec 04             	sub    $0x4,%esp
  802966:	68 f0 43 80 00       	push   $0x8043f0
  80296b:	68 4f 01 00 00       	push   $0x14f
  802970:	68 7d 43 80 00       	push   $0x80437d
  802975:	e8 78 0f 00 00       	call   8038f2 <_panic>
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	8b 10                	mov    (%eax),%edx
  80297f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802982:	89 10                	mov    %edx,(%eax)
  802984:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 0b                	je     802998 <alloc_block_BF+0x376>
  80298d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802990:	8b 00                	mov    (%eax),%eax
  802992:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802995:	89 50 04             	mov    %edx,0x4(%eax)
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80299e:	89 10                	mov    %edx,(%eax)
  8029a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a6:	89 50 04             	mov    %edx,0x4(%eax)
  8029a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ac:	8b 00                	mov    (%eax),%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	75 08                	jne    8029ba <alloc_block_BF+0x398>
  8029b2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029b5:	a3 34 50 80 00       	mov    %eax,0x805034
  8029ba:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8029bf:	40                   	inc    %eax
  8029c0:	a3 3c 50 80 00       	mov    %eax,0x80503c
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  8029c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029c9:	75 17                	jne    8029e2 <alloc_block_BF+0x3c0>
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	68 5f 43 80 00       	push   $0x80435f
  8029d3:	68 51 01 00 00       	push   $0x151
  8029d8:	68 7d 43 80 00       	push   $0x80437d
  8029dd:	e8 10 0f 00 00       	call   8038f2 <_panic>
  8029e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	74 10                	je     8029fb <alloc_block_BF+0x3d9>
  8029eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ee:	8b 00                	mov    (%eax),%eax
  8029f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f3:	8b 52 04             	mov    0x4(%edx),%edx
  8029f6:	89 50 04             	mov    %edx,0x4(%eax)
  8029f9:	eb 0b                	jmp    802a06 <alloc_block_BF+0x3e4>
  8029fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fe:	8b 40 04             	mov    0x4(%eax),%eax
  802a01:	a3 34 50 80 00       	mov    %eax,0x805034
  802a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a09:	8b 40 04             	mov    0x4(%eax),%eax
  802a0c:	85 c0                	test   %eax,%eax
  802a0e:	74 0f                	je     802a1f <alloc_block_BF+0x3fd>
  802a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a13:	8b 40 04             	mov    0x4(%eax),%eax
  802a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a19:	8b 12                	mov    (%edx),%edx
  802a1b:	89 10                	mov    %edx,(%eax)
  802a1d:	eb 0a                	jmp    802a29 <alloc_block_BF+0x407>
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	a3 30 50 80 00       	mov    %eax,0x805030
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3c:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802a41:	48                   	dec    %eax
  802a42:	a3 3c 50 80 00       	mov    %eax,0x80503c
			set_block_data(new_block_va, remaining_size, 0);
  802a47:	83 ec 04             	sub    $0x4,%esp
  802a4a:	6a 00                	push   $0x0
  802a4c:	ff 75 d0             	pushl  -0x30(%ebp)
  802a4f:	ff 75 cc             	pushl  -0x34(%ebp)
  802a52:	e8 e0 f6 ff ff       	call   802137 <set_block_data>
  802a57:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5d:	e9 a3 01 00 00       	jmp    802c05 <alloc_block_BF+0x5e3>
	}
	else if(internal == 1)
  802a62:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a66:	0f 85 9d 00 00 00    	jne    802b09 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a6c:	83 ec 04             	sub    $0x4,%esp
  802a6f:	6a 01                	push   $0x1
  802a71:	ff 75 ec             	pushl  -0x14(%ebp)
  802a74:	ff 75 f0             	pushl  -0x10(%ebp)
  802a77:	e8 bb f6 ff ff       	call   802137 <set_block_data>
  802a7c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a83:	75 17                	jne    802a9c <alloc_block_BF+0x47a>
  802a85:	83 ec 04             	sub    $0x4,%esp
  802a88:	68 5f 43 80 00       	push   $0x80435f
  802a8d:	68 58 01 00 00       	push   $0x158
  802a92:	68 7d 43 80 00       	push   $0x80437d
  802a97:	e8 56 0e 00 00       	call   8038f2 <_panic>
  802a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9f:	8b 00                	mov    (%eax),%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	74 10                	je     802ab5 <alloc_block_BF+0x493>
  802aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa8:	8b 00                	mov    (%eax),%eax
  802aaa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aad:	8b 52 04             	mov    0x4(%edx),%edx
  802ab0:	89 50 04             	mov    %edx,0x4(%eax)
  802ab3:	eb 0b                	jmp    802ac0 <alloc_block_BF+0x49e>
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	8b 40 04             	mov    0x4(%eax),%eax
  802abb:	a3 34 50 80 00       	mov    %eax,0x805034
  802ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac3:	8b 40 04             	mov    0x4(%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 0f                	je     802ad9 <alloc_block_BF+0x4b7>
  802aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acd:	8b 40 04             	mov    0x4(%eax),%eax
  802ad0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ad3:	8b 12                	mov    (%edx),%edx
  802ad5:	89 10                	mov    %edx,(%eax)
  802ad7:	eb 0a                	jmp    802ae3 <alloc_block_BF+0x4c1>
  802ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	a3 30 50 80 00       	mov    %eax,0x805030
  802ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af6:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802afb:	48                   	dec    %eax
  802afc:	a3 3c 50 80 00       	mov    %eax,0x80503c
		return best_va;
  802b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b04:	e9 fc 00 00 00       	jmp    802c05 <alloc_block_BF+0x5e3>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	83 c0 08             	add    $0x8,%eax
  802b0f:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802b12:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802b19:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b1f:	01 d0                	add    %edx,%eax
  802b21:	48                   	dec    %eax
  802b22:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802b25:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b28:	ba 00 00 00 00       	mov    $0x0,%edx
  802b2d:	f7 75 c4             	divl   -0x3c(%ebp)
  802b30:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802b33:	29 d0                	sub    %edx,%eax
  802b35:	c1 e8 0c             	shr    $0xc,%eax
  802b38:	83 ec 0c             	sub    $0xc,%esp
  802b3b:	50                   	push   %eax
  802b3c:	e8 5c e6 ff ff       	call   80119d <sbrk>
  802b41:	83 c4 10             	add    $0x10,%esp
  802b44:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802b47:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802b4b:	75 0a                	jne    802b57 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b52:	e9 ae 00 00 00       	jmp    802c05 <alloc_block_BF+0x5e3>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b57:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b5e:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b61:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b64:	01 d0                	add    %edx,%eax
  802b66:	48                   	dec    %eax
  802b67:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b6a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b6d:	ba 00 00 00 00       	mov    $0x0,%edx
  802b72:	f7 75 b8             	divl   -0x48(%ebp)
  802b75:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b78:	29 d0                	sub    %edx,%eax
  802b7a:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b7d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b80:	01 d0                	add    %edx,%eax
  802b82:	a3 44 50 80 00       	mov    %eax,0x805044
				end_block->info = 1;
  802b87:	a1 44 50 80 00       	mov    0x805044,%eax
  802b8c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				cprintf("251\n");
  802b92:	83 ec 0c             	sub    $0xc,%esp
  802b95:	68 24 44 80 00       	push   $0x804424
  802b9a:	e8 64 d8 ff ff       	call   800403 <cprintf>
  802b9f:	83 c4 10             	add    $0x10,%esp
			cprintf("address : %x\n",new_mem);
  802ba2:	83 ec 08             	sub    $0x8,%esp
  802ba5:	ff 75 bc             	pushl  -0x44(%ebp)
  802ba8:	68 29 44 80 00       	push   $0x804429
  802bad:	e8 51 d8 ff ff       	call   800403 <cprintf>
  802bb2:	83 c4 10             	add    $0x10,%esp
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802bb5:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802bbc:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802bbf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802bc2:	01 d0                	add    %edx,%eax
  802bc4:	48                   	dec    %eax
  802bc5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802bc8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  802bd0:	f7 75 b0             	divl   -0x50(%ebp)
  802bd3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802bd6:	29 d0                	sub    %edx,%eax
  802bd8:	83 ec 04             	sub    $0x4,%esp
  802bdb:	6a 01                	push   $0x1
  802bdd:	50                   	push   %eax
  802bde:	ff 75 bc             	pushl  -0x44(%ebp)
  802be1:	e8 51 f5 ff ff       	call   802137 <set_block_data>
  802be6:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802be9:	83 ec 0c             	sub    $0xc,%esp
  802bec:	ff 75 bc             	pushl  -0x44(%ebp)
  802bef:	e8 36 04 00 00       	call   80302a <free_block>
  802bf4:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802bf7:	83 ec 0c             	sub    $0xc,%esp
  802bfa:	ff 75 08             	pushl  0x8(%ebp)
  802bfd:	e8 20 fa ff ff       	call   802622 <alloc_block_BF>
  802c02:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802c05:	c9                   	leave  
  802c06:	c3                   	ret    

00802c07 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802c07:	55                   	push   %ebp
  802c08:	89 e5                	mov    %esp,%ebp
  802c0a:	53                   	push   %ebx
  802c0b:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802c0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802c15:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802c1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c20:	74 1e                	je     802c40 <merging+0x39>
  802c22:	ff 75 08             	pushl  0x8(%ebp)
  802c25:	e8 bc f1 ff ff       	call   801de6 <get_block_size>
  802c2a:	83 c4 04             	add    $0x4,%esp
  802c2d:	89 c2                	mov    %eax,%edx
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	01 d0                	add    %edx,%eax
  802c34:	3b 45 10             	cmp    0x10(%ebp),%eax
  802c37:	75 07                	jne    802c40 <merging+0x39>
		prev_is_free = 1;
  802c39:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802c40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c44:	74 1e                	je     802c64 <merging+0x5d>
  802c46:	ff 75 10             	pushl  0x10(%ebp)
  802c49:	e8 98 f1 ff ff       	call   801de6 <get_block_size>
  802c4e:	83 c4 04             	add    $0x4,%esp
  802c51:	89 c2                	mov    %eax,%edx
  802c53:	8b 45 10             	mov    0x10(%ebp),%eax
  802c56:	01 d0                	add    %edx,%eax
  802c58:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c5b:	75 07                	jne    802c64 <merging+0x5d>
		next_is_free = 1;
  802c5d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802c64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c68:	0f 84 cc 00 00 00    	je     802d3a <merging+0x133>
  802c6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c72:	0f 84 c2 00 00 00    	je     802d3a <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c78:	ff 75 08             	pushl  0x8(%ebp)
  802c7b:	e8 66 f1 ff ff       	call   801de6 <get_block_size>
  802c80:	83 c4 04             	add    $0x4,%esp
  802c83:	89 c3                	mov    %eax,%ebx
  802c85:	ff 75 10             	pushl  0x10(%ebp)
  802c88:	e8 59 f1 ff ff       	call   801de6 <get_block_size>
  802c8d:	83 c4 04             	add    $0x4,%esp
  802c90:	01 c3                	add    %eax,%ebx
  802c92:	ff 75 0c             	pushl  0xc(%ebp)
  802c95:	e8 4c f1 ff ff       	call   801de6 <get_block_size>
  802c9a:	83 c4 04             	add    $0x4,%esp
  802c9d:	01 d8                	add    %ebx,%eax
  802c9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802ca2:	6a 00                	push   $0x0
  802ca4:	ff 75 ec             	pushl  -0x14(%ebp)
  802ca7:	ff 75 08             	pushl  0x8(%ebp)
  802caa:	e8 88 f4 ff ff       	call   802137 <set_block_data>
  802caf:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802cb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802cb6:	75 17                	jne    802ccf <merging+0xc8>
  802cb8:	83 ec 04             	sub    $0x4,%esp
  802cbb:	68 5f 43 80 00       	push   $0x80435f
  802cc0:	68 7d 01 00 00       	push   $0x17d
  802cc5:	68 7d 43 80 00       	push   $0x80437d
  802cca:	e8 23 0c 00 00       	call   8038f2 <_panic>
  802ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	74 10                	je     802ce8 <merging+0xe1>
  802cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ce0:	8b 52 04             	mov    0x4(%edx),%edx
  802ce3:	89 50 04             	mov    %edx,0x4(%eax)
  802ce6:	eb 0b                	jmp    802cf3 <merging+0xec>
  802ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ceb:	8b 40 04             	mov    0x4(%eax),%eax
  802cee:	a3 34 50 80 00       	mov    %eax,0x805034
  802cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cf6:	8b 40 04             	mov    0x4(%eax),%eax
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	74 0f                	je     802d0c <merging+0x105>
  802cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d00:	8b 40 04             	mov    0x4(%eax),%eax
  802d03:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d06:	8b 12                	mov    (%edx),%edx
  802d08:	89 10                	mov    %edx,(%eax)
  802d0a:	eb 0a                	jmp    802d16 <merging+0x10f>
  802d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0f:	8b 00                	mov    (%eax),%eax
  802d11:	a3 30 50 80 00       	mov    %eax,0x805030
  802d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d29:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802d2e:	48                   	dec    %eax
  802d2f:	a3 3c 50 80 00       	mov    %eax,0x80503c
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802d34:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d35:	e9 ea 02 00 00       	jmp    803024 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802d3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3e:	74 3b                	je     802d7b <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802d40:	83 ec 0c             	sub    $0xc,%esp
  802d43:	ff 75 08             	pushl  0x8(%ebp)
  802d46:	e8 9b f0 ff ff       	call   801de6 <get_block_size>
  802d4b:	83 c4 10             	add    $0x10,%esp
  802d4e:	89 c3                	mov    %eax,%ebx
  802d50:	83 ec 0c             	sub    $0xc,%esp
  802d53:	ff 75 10             	pushl  0x10(%ebp)
  802d56:	e8 8b f0 ff ff       	call   801de6 <get_block_size>
  802d5b:	83 c4 10             	add    $0x10,%esp
  802d5e:	01 d8                	add    %ebx,%eax
  802d60:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	6a 00                	push   $0x0
  802d68:	ff 75 e8             	pushl  -0x18(%ebp)
  802d6b:	ff 75 08             	pushl  0x8(%ebp)
  802d6e:	e8 c4 f3 ff ff       	call   802137 <set_block_data>
  802d73:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d76:	e9 a9 02 00 00       	jmp    803024 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d7f:	0f 84 2d 01 00 00    	je     802eb2 <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d85:	83 ec 0c             	sub    $0xc,%esp
  802d88:	ff 75 10             	pushl  0x10(%ebp)
  802d8b:	e8 56 f0 ff ff       	call   801de6 <get_block_size>
  802d90:	83 c4 10             	add    $0x10,%esp
  802d93:	89 c3                	mov    %eax,%ebx
  802d95:	83 ec 0c             	sub    $0xc,%esp
  802d98:	ff 75 0c             	pushl  0xc(%ebp)
  802d9b:	e8 46 f0 ff ff       	call   801de6 <get_block_size>
  802da0:	83 c4 10             	add    $0x10,%esp
  802da3:	01 d8                	add    %ebx,%eax
  802da5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802da8:	83 ec 04             	sub    $0x4,%esp
  802dab:	6a 00                	push   $0x0
  802dad:	ff 75 e4             	pushl  -0x1c(%ebp)
  802db0:	ff 75 10             	pushl  0x10(%ebp)
  802db3:	e8 7f f3 ff ff       	call   802137 <set_block_data>
  802db8:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  802dbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802dc1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dc5:	74 06                	je     802dcd <merging+0x1c6>
  802dc7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dcb:	75 17                	jne    802de4 <merging+0x1dd>
  802dcd:	83 ec 04             	sub    $0x4,%esp
  802dd0:	68 38 44 80 00       	push   $0x804438
  802dd5:	68 8d 01 00 00       	push   $0x18d
  802dda:	68 7d 43 80 00       	push   $0x80437d
  802ddf:	e8 0e 0b 00 00       	call   8038f2 <_panic>
  802de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de7:	8b 50 04             	mov    0x4(%eax),%edx
  802dea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ded:	89 50 04             	mov    %edx,0x4(%eax)
  802df0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802df6:	89 10                	mov    %edx,(%eax)
  802df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfb:	8b 40 04             	mov    0x4(%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 0d                	je     802e0f <merging+0x208>
  802e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e05:	8b 40 04             	mov    0x4(%eax),%eax
  802e08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e0b:	89 10                	mov    %edx,(%eax)
  802e0d:	eb 08                	jmp    802e17 <merging+0x210>
  802e0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e12:	a3 30 50 80 00       	mov    %eax,0x805030
  802e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e1d:	89 50 04             	mov    %edx,0x4(%eax)
  802e20:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802e25:	40                   	inc    %eax
  802e26:	a3 3c 50 80 00       	mov    %eax,0x80503c
		LIST_REMOVE(&freeBlocksList, next_block);
  802e2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e2f:	75 17                	jne    802e48 <merging+0x241>
  802e31:	83 ec 04             	sub    $0x4,%esp
  802e34:	68 5f 43 80 00       	push   $0x80435f
  802e39:	68 8e 01 00 00       	push   $0x18e
  802e3e:	68 7d 43 80 00       	push   $0x80437d
  802e43:	e8 aa 0a 00 00       	call   8038f2 <_panic>
  802e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e4b:	8b 00                	mov    (%eax),%eax
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	74 10                	je     802e61 <merging+0x25a>
  802e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e54:	8b 00                	mov    (%eax),%eax
  802e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e59:	8b 52 04             	mov    0x4(%edx),%edx
  802e5c:	89 50 04             	mov    %edx,0x4(%eax)
  802e5f:	eb 0b                	jmp    802e6c <merging+0x265>
  802e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	a3 34 50 80 00       	mov    %eax,0x805034
  802e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6f:	8b 40 04             	mov    0x4(%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 0f                	je     802e85 <merging+0x27e>
  802e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e7f:	8b 12                	mov    (%edx),%edx
  802e81:	89 10                	mov    %edx,(%eax)
  802e83:	eb 0a                	jmp    802e8f <merging+0x288>
  802e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	a3 30 50 80 00       	mov    %eax,0x805030
  802e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea2:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802ea7:	48                   	dec    %eax
  802ea8:	a3 3c 50 80 00       	mov    %eax,0x80503c
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802ead:	e9 72 01 00 00       	jmp    803024 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  802eb5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802eb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ebc:	74 79                	je     802f37 <merging+0x330>
  802ebe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ec2:	74 73                	je     802f37 <merging+0x330>
  802ec4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec8:	74 06                	je     802ed0 <merging+0x2c9>
  802eca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ece:	75 17                	jne    802ee7 <merging+0x2e0>
  802ed0:	83 ec 04             	sub    $0x4,%esp
  802ed3:	68 f0 43 80 00       	push   $0x8043f0
  802ed8:	68 94 01 00 00       	push   $0x194
  802edd:	68 7d 43 80 00       	push   $0x80437d
  802ee2:	e8 0b 0a 00 00       	call   8038f2 <_panic>
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	8b 10                	mov    (%eax),%edx
  802eec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eef:	89 10                	mov    %edx,(%eax)
  802ef1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	85 c0                	test   %eax,%eax
  802ef8:	74 0b                	je     802f05 <merging+0x2fe>
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f02:	89 50 04             	mov    %edx,0x4(%eax)
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f0b:	89 10                	mov    %edx,(%eax)
  802f0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f10:	8b 55 08             	mov    0x8(%ebp),%edx
  802f13:	89 50 04             	mov    %edx,0x4(%eax)
  802f16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f19:	8b 00                	mov    (%eax),%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	75 08                	jne    802f27 <merging+0x320>
  802f1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f22:	a3 34 50 80 00       	mov    %eax,0x805034
  802f27:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f2c:	40                   	inc    %eax
  802f2d:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802f32:	e9 ce 00 00 00       	jmp    803005 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802f37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3b:	74 65                	je     802fa2 <merging+0x39b>
  802f3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f41:	75 17                	jne    802f5a <merging+0x353>
  802f43:	83 ec 04             	sub    $0x4,%esp
  802f46:	68 cc 43 80 00       	push   $0x8043cc
  802f4b:	68 95 01 00 00       	push   $0x195
  802f50:	68 7d 43 80 00       	push   $0x80437d
  802f55:	e8 98 09 00 00       	call   8038f2 <_panic>
  802f5a:	8b 15 34 50 80 00    	mov    0x805034,%edx
  802f60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f63:	89 50 04             	mov    %edx,0x4(%eax)
  802f66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 0c                	je     802f7c <merging+0x375>
  802f70:	a1 34 50 80 00       	mov    0x805034,%eax
  802f75:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f78:	89 10                	mov    %edx,(%eax)
  802f7a:	eb 08                	jmp    802f84 <merging+0x37d>
  802f7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7f:	a3 30 50 80 00       	mov    %eax,0x805030
  802f84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f87:	a3 34 50 80 00       	mov    %eax,0x805034
  802f8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f95:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802f9a:	40                   	inc    %eax
  802f9b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  802fa0:	eb 63                	jmp    803005 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802fa2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802fa6:	75 17                	jne    802fbf <merging+0x3b8>
  802fa8:	83 ec 04             	sub    $0x4,%esp
  802fab:	68 98 43 80 00       	push   $0x804398
  802fb0:	68 98 01 00 00       	push   $0x198
  802fb5:	68 7d 43 80 00       	push   $0x80437d
  802fba:	e8 33 09 00 00       	call   8038f2 <_panic>
  802fbf:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802fc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fc8:	89 10                	mov    %edx,(%eax)
  802fca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fcd:	8b 00                	mov    (%eax),%eax
  802fcf:	85 c0                	test   %eax,%eax
  802fd1:	74 0d                	je     802fe0 <merging+0x3d9>
  802fd3:	a1 30 50 80 00       	mov    0x805030,%eax
  802fd8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fdb:	89 50 04             	mov    %edx,0x4(%eax)
  802fde:	eb 08                	jmp    802fe8 <merging+0x3e1>
  802fe0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe3:	a3 34 50 80 00       	mov    %eax,0x805034
  802fe8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802feb:	a3 30 50 80 00       	mov    %eax,0x805030
  802ff0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ff3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffa:	a1 3c 50 80 00       	mov    0x80503c,%eax
  802fff:	40                   	inc    %eax
  803000:	a3 3c 50 80 00       	mov    %eax,0x80503c
		}
		set_block_data(va, get_block_size(va), 0);
  803005:	83 ec 0c             	sub    $0xc,%esp
  803008:	ff 75 10             	pushl  0x10(%ebp)
  80300b:	e8 d6 ed ff ff       	call   801de6 <get_block_size>
  803010:	83 c4 10             	add    $0x10,%esp
  803013:	83 ec 04             	sub    $0x4,%esp
  803016:	6a 00                	push   $0x0
  803018:	50                   	push   %eax
  803019:	ff 75 10             	pushl  0x10(%ebp)
  80301c:	e8 16 f1 ff ff       	call   802137 <set_block_data>
  803021:	83 c4 10             	add    $0x10,%esp
	}
}
  803024:	90                   	nop
  803025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803028:	c9                   	leave  
  803029:	c3                   	ret    

0080302a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80302a:	55                   	push   %ebp
  80302b:	89 e5                	mov    %esp,%ebp
  80302d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  803030:	a1 30 50 80 00       	mov    0x805030,%eax
  803035:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  803038:	a1 34 50 80 00       	mov    0x805034,%eax
  80303d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803040:	73 1b                	jae    80305d <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  803042:	a1 34 50 80 00       	mov    0x805034,%eax
  803047:	83 ec 04             	sub    $0x4,%esp
  80304a:	ff 75 08             	pushl  0x8(%ebp)
  80304d:	6a 00                	push   $0x0
  80304f:	50                   	push   %eax
  803050:	e8 b2 fb ff ff       	call   802c07 <merging>
  803055:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803058:	e9 8b 00 00 00       	jmp    8030e8 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  80305d:	a1 30 50 80 00       	mov    0x805030,%eax
  803062:	3b 45 08             	cmp    0x8(%ebp),%eax
  803065:	76 18                	jbe    80307f <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  803067:	a1 30 50 80 00       	mov    0x805030,%eax
  80306c:	83 ec 04             	sub    $0x4,%esp
  80306f:	ff 75 08             	pushl  0x8(%ebp)
  803072:	50                   	push   %eax
  803073:	6a 00                	push   $0x0
  803075:	e8 8d fb ff ff       	call   802c07 <merging>
  80307a:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  80307d:	eb 69                	jmp    8030e8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80307f:	a1 30 50 80 00       	mov    0x805030,%eax
  803084:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803087:	eb 39                	jmp    8030c2 <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80308f:	73 29                	jae    8030ba <free_block+0x90>
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	8b 00                	mov    (%eax),%eax
  803096:	3b 45 08             	cmp    0x8(%ebp),%eax
  803099:	76 1f                	jbe    8030ba <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  8030a3:	83 ec 04             	sub    $0x4,%esp
  8030a6:	ff 75 08             	pushl  0x8(%ebp)
  8030a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8030ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8030af:	e8 53 fb ff ff       	call   802c07 <merging>
  8030b4:	83 c4 10             	add    $0x10,%esp
			break;
  8030b7:	90                   	nop
		}
	}
}
  8030b8:	eb 2e                	jmp    8030e8 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  8030ba:	a1 38 50 80 00       	mov    0x805038,%eax
  8030bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c6:	74 07                	je     8030cf <free_block+0xa5>
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	8b 00                	mov    (%eax),%eax
  8030cd:	eb 05                	jmp    8030d4 <free_block+0xaa>
  8030cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d4:	a3 38 50 80 00       	mov    %eax,0x805038
  8030d9:	a1 38 50 80 00       	mov    0x805038,%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	75 a7                	jne    803089 <free_block+0x5f>
  8030e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e6:	75 a1                	jne    803089 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  8030e8:	90                   	nop
  8030e9:	c9                   	leave  
  8030ea:	c3                   	ret    

008030eb <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  8030eb:	55                   	push   %ebp
  8030ec:	89 e5                	mov    %esp,%ebp
  8030ee:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  8030f1:	ff 75 08             	pushl  0x8(%ebp)
  8030f4:	e8 ed ec ff ff       	call   801de6 <get_block_size>
  8030f9:	83 c4 04             	add    $0x4,%esp
  8030fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  8030ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803106:	eb 17                	jmp    80311f <copy_data+0x34>
  803108:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80310b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80310e:	01 c2                	add    %eax,%edx
  803110:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	01 c8                	add    %ecx,%eax
  803118:	8a 00                	mov    (%eax),%al
  80311a:	88 02                	mov    %al,(%edx)
  80311c:	ff 45 fc             	incl   -0x4(%ebp)
  80311f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803122:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  803125:	72 e1                	jb     803108 <copy_data+0x1d>
}
  803127:	90                   	nop
  803128:	c9                   	leave  
  803129:	c3                   	ret    

0080312a <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  80312a:	55                   	push   %ebp
  80312b:	89 e5                	mov    %esp,%ebp
  80312d:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  803130:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803134:	75 23                	jne    803159 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  803136:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80313a:	74 13                	je     80314f <realloc_block_FF+0x25>
  80313c:	83 ec 0c             	sub    $0xc,%esp
  80313f:	ff 75 0c             	pushl  0xc(%ebp)
  803142:	e8 1f f0 ff ff       	call   802166 <alloc_block_FF>
  803147:	83 c4 10             	add    $0x10,%esp
  80314a:	e9 f4 06 00 00       	jmp    803843 <realloc_block_FF+0x719>
		return NULL;
  80314f:	b8 00 00 00 00       	mov    $0x0,%eax
  803154:	e9 ea 06 00 00       	jmp    803843 <realloc_block_FF+0x719>
	}

	if(new_size == 0)
  803159:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80315d:	75 18                	jne    803177 <realloc_block_FF+0x4d>
	{
		free_block(va);
  80315f:	83 ec 0c             	sub    $0xc,%esp
  803162:	ff 75 08             	pushl  0x8(%ebp)
  803165:	e8 c0 fe ff ff       	call   80302a <free_block>
  80316a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80316d:	b8 00 00 00 00       	mov    $0x0,%eax
  803172:	e9 cc 06 00 00       	jmp    803843 <realloc_block_FF+0x719>
	}


	if(new_size < 8) new_size = 8;
  803177:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80317b:	77 07                	ja     803184 <realloc_block_FF+0x5a>
  80317d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803184:	8b 45 0c             	mov    0xc(%ebp),%eax
  803187:	83 e0 01             	and    $0x1,%eax
  80318a:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  80318d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803190:	83 c0 08             	add    $0x8,%eax
  803193:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803196:	83 ec 0c             	sub    $0xc,%esp
  803199:	ff 75 08             	pushl  0x8(%ebp)
  80319c:	e8 45 ec ff ff       	call   801de6 <get_block_size>
  8031a1:	83 c4 10             	add    $0x10,%esp
  8031a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031aa:	83 e8 08             	sub    $0x8,%eax
  8031ad:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	83 e8 04             	sub    $0x4,%eax
  8031b6:	8b 00                	mov    (%eax),%eax
  8031b8:	83 e0 fe             	and    $0xfffffffe,%eax
  8031bb:	89 c2                	mov    %eax,%edx
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	01 d0                	add    %edx,%eax
  8031c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  8031c5:	83 ec 0c             	sub    $0xc,%esp
  8031c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8031cb:	e8 16 ec ff ff       	call   801de6 <get_block_size>
  8031d0:	83 c4 10             	add    $0x10,%esp
  8031d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  8031d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d9:	83 e8 08             	sub    $0x8,%eax
  8031dc:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  8031df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031e5:	75 08                	jne    8031ef <realloc_block_FF+0xc5>
	{
		 return va;
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	e9 54 06 00 00       	jmp    803843 <realloc_block_FF+0x719>

	}


	if(new_size < cur_size)
  8031ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031f2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8031f5:	0f 83 e5 03 00 00    	jae    8035e0 <realloc_block_FF+0x4b6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	2b 45 0c             	sub    0xc(%ebp),%eax
  803201:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803204:	83 ec 0c             	sub    $0xc,%esp
  803207:	ff 75 e4             	pushl  -0x1c(%ebp)
  80320a:	e8 f0 eb ff ff       	call   801dff <is_free_block>
  80320f:	83 c4 10             	add    $0x10,%esp
  803212:	84 c0                	test   %al,%al
  803214:	0f 84 3b 01 00 00    	je     803355 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  80321a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80321d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803220:	01 d0                	add    %edx,%eax
  803222:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  803225:	83 ec 04             	sub    $0x4,%esp
  803228:	6a 01                	push   $0x1
  80322a:	ff 75 f0             	pushl  -0x10(%ebp)
  80322d:	ff 75 08             	pushl  0x8(%ebp)
  803230:	e8 02 ef ff ff       	call   802137 <set_block_data>
  803235:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	83 e8 04             	sub    $0x4,%eax
  80323e:	8b 00                	mov    (%eax),%eax
  803240:	83 e0 fe             	and    $0xfffffffe,%eax
  803243:	89 c2                	mov    %eax,%edx
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	01 d0                	add    %edx,%eax
  80324a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  80324d:	83 ec 04             	sub    $0x4,%esp
  803250:	6a 00                	push   $0x0
  803252:	ff 75 cc             	pushl  -0x34(%ebp)
  803255:	ff 75 c8             	pushl  -0x38(%ebp)
  803258:	e8 da ee ff ff       	call   802137 <set_block_data>
  80325d:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803260:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803264:	74 06                	je     80326c <realloc_block_FF+0x142>
  803266:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80326a:	75 17                	jne    803283 <realloc_block_FF+0x159>
  80326c:	83 ec 04             	sub    $0x4,%esp
  80326f:	68 f0 43 80 00       	push   $0x8043f0
  803274:	68 f6 01 00 00       	push   $0x1f6
  803279:	68 7d 43 80 00       	push   $0x80437d
  80327e:	e8 6f 06 00 00       	call   8038f2 <_panic>
  803283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803286:	8b 10                	mov    (%eax),%edx
  803288:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80328b:	89 10                	mov    %edx,(%eax)
  80328d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803290:	8b 00                	mov    (%eax),%eax
  803292:	85 c0                	test   %eax,%eax
  803294:	74 0b                	je     8032a1 <realloc_block_FF+0x177>
  803296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803299:	8b 00                	mov    (%eax),%eax
  80329b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80329e:	89 50 04             	mov    %edx,0x4(%eax)
  8032a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a4:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8032a7:	89 10                	mov    %edx,(%eax)
  8032a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032af:	89 50 04             	mov    %edx,0x4(%eax)
  8032b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032b5:	8b 00                	mov    (%eax),%eax
  8032b7:	85 c0                	test   %eax,%eax
  8032b9:	75 08                	jne    8032c3 <realloc_block_FF+0x199>
  8032bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8032be:	a3 34 50 80 00       	mov    %eax,0x805034
  8032c3:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8032c8:	40                   	inc    %eax
  8032c9:	a3 3c 50 80 00       	mov    %eax,0x80503c
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  8032ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032d2:	75 17                	jne    8032eb <realloc_block_FF+0x1c1>
  8032d4:	83 ec 04             	sub    $0x4,%esp
  8032d7:	68 5f 43 80 00       	push   $0x80435f
  8032dc:	68 f7 01 00 00       	push   $0x1f7
  8032e1:	68 7d 43 80 00       	push   $0x80437d
  8032e6:	e8 07 06 00 00       	call   8038f2 <_panic>
  8032eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ee:	8b 00                	mov    (%eax),%eax
  8032f0:	85 c0                	test   %eax,%eax
  8032f2:	74 10                	je     803304 <realloc_block_FF+0x1da>
  8032f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f7:	8b 00                	mov    (%eax),%eax
  8032f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032fc:	8b 52 04             	mov    0x4(%edx),%edx
  8032ff:	89 50 04             	mov    %edx,0x4(%eax)
  803302:	eb 0b                	jmp    80330f <realloc_block_FF+0x1e5>
  803304:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803307:	8b 40 04             	mov    0x4(%eax),%eax
  80330a:	a3 34 50 80 00       	mov    %eax,0x805034
  80330f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803312:	8b 40 04             	mov    0x4(%eax),%eax
  803315:	85 c0                	test   %eax,%eax
  803317:	74 0f                	je     803328 <realloc_block_FF+0x1fe>
  803319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331c:	8b 40 04             	mov    0x4(%eax),%eax
  80331f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803322:	8b 12                	mov    (%edx),%edx
  803324:	89 10                	mov    %edx,(%eax)
  803326:	eb 0a                	jmp    803332 <realloc_block_FF+0x208>
  803328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332b:	8b 00                	mov    (%eax),%eax
  80332d:	a3 30 50 80 00       	mov    %eax,0x805030
  803332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803335:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803345:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80334a:	48                   	dec    %eax
  80334b:	a3 3c 50 80 00       	mov    %eax,0x80503c
  803350:	e9 83 02 00 00       	jmp    8035d8 <realloc_block_FF+0x4ae>
		}
		else
		{
			if(remaining_size>=16)
  803355:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  803359:	0f 86 69 02 00 00    	jbe    8035c8 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  80335f:	83 ec 04             	sub    $0x4,%esp
  803362:	6a 01                	push   $0x1
  803364:	ff 75 f0             	pushl  -0x10(%ebp)
  803367:	ff 75 08             	pushl  0x8(%ebp)
  80336a:	e8 c8 ed ff ff       	call   802137 <set_block_data>
  80336f:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	83 e8 04             	sub    $0x4,%eax
  803378:	8b 00                	mov    (%eax),%eax
  80337a:	83 e0 fe             	and    $0xfffffffe,%eax
  80337d:	89 c2                	mov    %eax,%edx
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	01 d0                	add    %edx,%eax
  803384:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803387:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80338c:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80338f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803393:	75 68                	jne    8033fd <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803395:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803399:	75 17                	jne    8033b2 <realloc_block_FF+0x288>
  80339b:	83 ec 04             	sub    $0x4,%esp
  80339e:	68 98 43 80 00       	push   $0x804398
  8033a3:	68 06 02 00 00       	push   $0x206
  8033a8:	68 7d 43 80 00       	push   $0x80437d
  8033ad:	e8 40 05 00 00       	call   8038f2 <_panic>
  8033b2:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8033b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033bb:	89 10                	mov    %edx,(%eax)
  8033bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033c0:	8b 00                	mov    (%eax),%eax
  8033c2:	85 c0                	test   %eax,%eax
  8033c4:	74 0d                	je     8033d3 <realloc_block_FF+0x2a9>
  8033c6:	a1 30 50 80 00       	mov    0x805030,%eax
  8033cb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033ce:	89 50 04             	mov    %edx,0x4(%eax)
  8033d1:	eb 08                	jmp    8033db <realloc_block_FF+0x2b1>
  8033d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d6:	a3 34 50 80 00       	mov    %eax,0x805034
  8033db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033de:	a3 30 50 80 00       	mov    %eax,0x805030
  8033e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ed:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8033f2:	40                   	inc    %eax
  8033f3:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8033f8:	e9 b0 01 00 00       	jmp    8035ad <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  8033fd:	a1 30 50 80 00       	mov    0x805030,%eax
  803402:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803405:	76 68                	jbe    80346f <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803407:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80340b:	75 17                	jne    803424 <realloc_block_FF+0x2fa>
  80340d:	83 ec 04             	sub    $0x4,%esp
  803410:	68 98 43 80 00       	push   $0x804398
  803415:	68 0b 02 00 00       	push   $0x20b
  80341a:	68 7d 43 80 00       	push   $0x80437d
  80341f:	e8 ce 04 00 00       	call   8038f2 <_panic>
  803424:	8b 15 30 50 80 00    	mov    0x805030,%edx
  80342a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342d:	89 10                	mov    %edx,(%eax)
  80342f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	85 c0                	test   %eax,%eax
  803436:	74 0d                	je     803445 <realloc_block_FF+0x31b>
  803438:	a1 30 50 80 00       	mov    0x805030,%eax
  80343d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803440:	89 50 04             	mov    %edx,0x4(%eax)
  803443:	eb 08                	jmp    80344d <realloc_block_FF+0x323>
  803445:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803448:	a3 34 50 80 00       	mov    %eax,0x805034
  80344d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803450:	a3 30 50 80 00       	mov    %eax,0x805030
  803455:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803458:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345f:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803464:	40                   	inc    %eax
  803465:	a3 3c 50 80 00       	mov    %eax,0x80503c
  80346a:	e9 3e 01 00 00       	jmp    8035ad <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  80346f:	a1 30 50 80 00       	mov    0x805030,%eax
  803474:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803477:	73 68                	jae    8034e1 <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803479:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80347d:	75 17                	jne    803496 <realloc_block_FF+0x36c>
  80347f:	83 ec 04             	sub    $0x4,%esp
  803482:	68 cc 43 80 00       	push   $0x8043cc
  803487:	68 10 02 00 00       	push   $0x210
  80348c:	68 7d 43 80 00       	push   $0x80437d
  803491:	e8 5c 04 00 00       	call   8038f2 <_panic>
  803496:	8b 15 34 50 80 00    	mov    0x805034,%edx
  80349c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80349f:	89 50 04             	mov    %edx,0x4(%eax)
  8034a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034a5:	8b 40 04             	mov    0x4(%eax),%eax
  8034a8:	85 c0                	test   %eax,%eax
  8034aa:	74 0c                	je     8034b8 <realloc_block_FF+0x38e>
  8034ac:	a1 34 50 80 00       	mov    0x805034,%eax
  8034b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034b4:	89 10                	mov    %edx,(%eax)
  8034b6:	eb 08                	jmp    8034c0 <realloc_block_FF+0x396>
  8034b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034bb:	a3 30 50 80 00       	mov    %eax,0x805030
  8034c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c3:	a3 34 50 80 00       	mov    %eax,0x805034
  8034c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d1:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8034d6:	40                   	inc    %eax
  8034d7:	a3 3c 50 80 00       	mov    %eax,0x80503c
  8034dc:	e9 cc 00 00 00       	jmp    8035ad <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  8034e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  8034e8:	a1 30 50 80 00       	mov    0x805030,%eax
  8034ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034f0:	e9 8a 00 00 00       	jmp    80357f <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  8034f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8034fb:	73 7a                	jae    803577 <realloc_block_FF+0x44d>
  8034fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803500:	8b 00                	mov    (%eax),%eax
  803502:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803505:	73 70                	jae    803577 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803507:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80350b:	74 06                	je     803513 <realloc_block_FF+0x3e9>
  80350d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803511:	75 17                	jne    80352a <realloc_block_FF+0x400>
  803513:	83 ec 04             	sub    $0x4,%esp
  803516:	68 f0 43 80 00       	push   $0x8043f0
  80351b:	68 1a 02 00 00       	push   $0x21a
  803520:	68 7d 43 80 00       	push   $0x80437d
  803525:	e8 c8 03 00 00       	call   8038f2 <_panic>
  80352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352d:	8b 10                	mov    (%eax),%edx
  80352f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803532:	89 10                	mov    %edx,(%eax)
  803534:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803537:	8b 00                	mov    (%eax),%eax
  803539:	85 c0                	test   %eax,%eax
  80353b:	74 0b                	je     803548 <realloc_block_FF+0x41e>
  80353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803540:	8b 00                	mov    (%eax),%eax
  803542:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803545:	89 50 04             	mov    %edx,0x4(%eax)
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80354e:	89 10                	mov    %edx,(%eax)
  803550:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803556:	89 50 04             	mov    %edx,0x4(%eax)
  803559:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80355c:	8b 00                	mov    (%eax),%eax
  80355e:	85 c0                	test   %eax,%eax
  803560:	75 08                	jne    80356a <realloc_block_FF+0x440>
  803562:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803565:	a3 34 50 80 00       	mov    %eax,0x805034
  80356a:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80356f:	40                   	inc    %eax
  803570:	a3 3c 50 80 00       	mov    %eax,0x80503c
							break;
  803575:	eb 36                	jmp    8035ad <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803577:	a1 38 50 80 00       	mov    0x805038,%eax
  80357c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80357f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803583:	74 07                	je     80358c <realloc_block_FF+0x462>
  803585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803588:	8b 00                	mov    (%eax),%eax
  80358a:	eb 05                	jmp    803591 <realloc_block_FF+0x467>
  80358c:	b8 00 00 00 00       	mov    $0x0,%eax
  803591:	a3 38 50 80 00       	mov    %eax,0x805038
  803596:	a1 38 50 80 00       	mov    0x805038,%eax
  80359b:	85 c0                	test   %eax,%eax
  80359d:	0f 85 52 ff ff ff    	jne    8034f5 <realloc_block_FF+0x3cb>
  8035a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a7:	0f 85 48 ff ff ff    	jne    8034f5 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  8035ad:	83 ec 04             	sub    $0x4,%esp
  8035b0:	6a 00                	push   $0x0
  8035b2:	ff 75 d8             	pushl  -0x28(%ebp)
  8035b5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8035b8:	e8 7a eb ff ff       	call   802137 <set_block_data>
  8035bd:	83 c4 10             	add    $0x10,%esp
				return va;
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	e9 7b 02 00 00       	jmp    803843 <realloc_block_FF+0x719>
			}
			cprintf("16\n");
  8035c8:	83 ec 0c             	sub    $0xc,%esp
  8035cb:	68 6d 44 80 00       	push   $0x80446d
  8035d0:	e8 2e ce ff ff       	call   800403 <cprintf>
  8035d5:	83 c4 10             	add    $0x10,%esp
		}
		return va;
  8035d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035db:	e9 63 02 00 00       	jmp    803843 <realloc_block_FF+0x719>
	}

	if(new_size > cur_size)
  8035e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8035e6:	0f 86 4d 02 00 00    	jbe    803839 <realloc_block_FF+0x70f>
	{
		if(is_free_block(next_va))
  8035ec:	83 ec 0c             	sub    $0xc,%esp
  8035ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8035f2:	e8 08 e8 ff ff       	call   801dff <is_free_block>
  8035f7:	83 c4 10             	add    $0x10,%esp
  8035fa:	84 c0                	test   %al,%al
  8035fc:	0f 84 37 02 00 00    	je     803839 <realloc_block_FF+0x70f>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  803602:	8b 45 0c             	mov    0xc(%ebp),%eax
  803605:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803608:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  80360b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80360e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803611:	76 38                	jbe    80364b <realloc_block_FF+0x521>
			{
				free_block(va); //set it free
  803613:	83 ec 0c             	sub    $0xc,%esp
  803616:	ff 75 08             	pushl  0x8(%ebp)
  803619:	e8 0c fa ff ff       	call   80302a <free_block>
  80361e:	83 c4 10             	add    $0x10,%esp
				void *new_va = alloc_block_FF(new_size); //new allocation
  803621:	83 ec 0c             	sub    $0xc,%esp
  803624:	ff 75 0c             	pushl  0xc(%ebp)
  803627:	e8 3a eb ff ff       	call   802166 <alloc_block_FF>
  80362c:	83 c4 10             	add    $0x10,%esp
  80362f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  803632:	83 ec 08             	sub    $0x8,%esp
  803635:	ff 75 c0             	pushl  -0x40(%ebp)
  803638:	ff 75 08             	pushl  0x8(%ebp)
  80363b:	e8 ab fa ff ff       	call   8030eb <copy_data>
  803640:	83 c4 10             	add    $0x10,%esp
				return new_va;
  803643:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803646:	e9 f8 01 00 00       	jmp    803843 <realloc_block_FF+0x719>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  80364b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80364e:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  803651:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  803654:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  803658:	0f 87 a0 00 00 00    	ja     8036fe <realloc_block_FF+0x5d4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  80365e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803662:	75 17                	jne    80367b <realloc_block_FF+0x551>
  803664:	83 ec 04             	sub    $0x4,%esp
  803667:	68 5f 43 80 00       	push   $0x80435f
  80366c:	68 38 02 00 00       	push   $0x238
  803671:	68 7d 43 80 00       	push   $0x80437d
  803676:	e8 77 02 00 00       	call   8038f2 <_panic>
  80367b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367e:	8b 00                	mov    (%eax),%eax
  803680:	85 c0                	test   %eax,%eax
  803682:	74 10                	je     803694 <realloc_block_FF+0x56a>
  803684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803687:	8b 00                	mov    (%eax),%eax
  803689:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80368c:	8b 52 04             	mov    0x4(%edx),%edx
  80368f:	89 50 04             	mov    %edx,0x4(%eax)
  803692:	eb 0b                	jmp    80369f <realloc_block_FF+0x575>
  803694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803697:	8b 40 04             	mov    0x4(%eax),%eax
  80369a:	a3 34 50 80 00       	mov    %eax,0x805034
  80369f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a2:	8b 40 04             	mov    0x4(%eax),%eax
  8036a5:	85 c0                	test   %eax,%eax
  8036a7:	74 0f                	je     8036b8 <realloc_block_FF+0x58e>
  8036a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ac:	8b 40 04             	mov    0x4(%eax),%eax
  8036af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036b2:	8b 12                	mov    (%edx),%edx
  8036b4:	89 10                	mov    %edx,(%eax)
  8036b6:	eb 0a                	jmp    8036c2 <realloc_block_FF+0x598>
  8036b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036bb:	8b 00                	mov    (%eax),%eax
  8036bd:	a3 30 50 80 00       	mov    %eax,0x805030
  8036c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d5:	a1 3c 50 80 00       	mov    0x80503c,%eax
  8036da:	48                   	dec    %eax
  8036db:	a3 3c 50 80 00       	mov    %eax,0x80503c

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  8036e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8036e6:	01 d0                	add    %edx,%eax
  8036e8:	83 ec 04             	sub    $0x4,%esp
  8036eb:	6a 01                	push   $0x1
  8036ed:	50                   	push   %eax
  8036ee:	ff 75 08             	pushl  0x8(%ebp)
  8036f1:	e8 41 ea ff ff       	call   802137 <set_block_data>
  8036f6:	83 c4 10             	add    $0x10,%esp
  8036f9:	e9 36 01 00 00       	jmp    803834 <realloc_block_FF+0x70a>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  8036fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803701:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803704:	01 d0                	add    %edx,%eax
  803706:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803709:	83 ec 04             	sub    $0x4,%esp
  80370c:	6a 01                	push   $0x1
  80370e:	ff 75 f0             	pushl  -0x10(%ebp)
  803711:	ff 75 08             	pushl  0x8(%ebp)
  803714:	e8 1e ea ff ff       	call   802137 <set_block_data>
  803719:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  80371c:	8b 45 08             	mov    0x8(%ebp),%eax
  80371f:	83 e8 04             	sub    $0x4,%eax
  803722:	8b 00                	mov    (%eax),%eax
  803724:	83 e0 fe             	and    $0xfffffffe,%eax
  803727:	89 c2                	mov    %eax,%edx
  803729:	8b 45 08             	mov    0x8(%ebp),%eax
  80372c:	01 d0                	add    %edx,%eax
  80372e:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  803731:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803735:	74 06                	je     80373d <realloc_block_FF+0x613>
  803737:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  80373b:	75 17                	jne    803754 <realloc_block_FF+0x62a>
  80373d:	83 ec 04             	sub    $0x4,%esp
  803740:	68 f0 43 80 00       	push   $0x8043f0
  803745:	68 44 02 00 00       	push   $0x244
  80374a:	68 7d 43 80 00       	push   $0x80437d
  80374f:	e8 9e 01 00 00       	call   8038f2 <_panic>
  803754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803757:	8b 10                	mov    (%eax),%edx
  803759:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80375c:	89 10                	mov    %edx,(%eax)
  80375e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803761:	8b 00                	mov    (%eax),%eax
  803763:	85 c0                	test   %eax,%eax
  803765:	74 0b                	je     803772 <realloc_block_FF+0x648>
  803767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376a:	8b 00                	mov    (%eax),%eax
  80376c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  80376f:	89 50 04             	mov    %edx,0x4(%eax)
  803772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803775:	8b 55 b8             	mov    -0x48(%ebp),%edx
  803778:	89 10                	mov    %edx,(%eax)
  80377a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80377d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803780:	89 50 04             	mov    %edx,0x4(%eax)
  803783:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803786:	8b 00                	mov    (%eax),%eax
  803788:	85 c0                	test   %eax,%eax
  80378a:	75 08                	jne    803794 <realloc_block_FF+0x66a>
  80378c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80378f:	a3 34 50 80 00       	mov    %eax,0x805034
  803794:	a1 3c 50 80 00       	mov    0x80503c,%eax
  803799:	40                   	inc    %eax
  80379a:	a3 3c 50 80 00       	mov    %eax,0x80503c
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80379f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037a3:	75 17                	jne    8037bc <realloc_block_FF+0x692>
  8037a5:	83 ec 04             	sub    $0x4,%esp
  8037a8:	68 5f 43 80 00       	push   $0x80435f
  8037ad:	68 45 02 00 00       	push   $0x245
  8037b2:	68 7d 43 80 00       	push   $0x80437d
  8037b7:	e8 36 01 00 00       	call   8038f2 <_panic>
  8037bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bf:	8b 00                	mov    (%eax),%eax
  8037c1:	85 c0                	test   %eax,%eax
  8037c3:	74 10                	je     8037d5 <realloc_block_FF+0x6ab>
  8037c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c8:	8b 00                	mov    (%eax),%eax
  8037ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037cd:	8b 52 04             	mov    0x4(%edx),%edx
  8037d0:	89 50 04             	mov    %edx,0x4(%eax)
  8037d3:	eb 0b                	jmp    8037e0 <realloc_block_FF+0x6b6>
  8037d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d8:	8b 40 04             	mov    0x4(%eax),%eax
  8037db:	a3 34 50 80 00       	mov    %eax,0x805034
  8037e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e3:	8b 40 04             	mov    0x4(%eax),%eax
  8037e6:	85 c0                	test   %eax,%eax
  8037e8:	74 0f                	je     8037f9 <realloc_block_FF+0x6cf>
  8037ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ed:	8b 40 04             	mov    0x4(%eax),%eax
  8037f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037f3:	8b 12                	mov    (%edx),%edx
  8037f5:	89 10                	mov    %edx,(%eax)
  8037f7:	eb 0a                	jmp    803803 <realloc_block_FF+0x6d9>
  8037f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fc:	8b 00                	mov    (%eax),%eax
  8037fe:	a3 30 50 80 00       	mov    %eax,0x805030
  803803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803806:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80380c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803816:	a1 3c 50 80 00       	mov    0x80503c,%eax
  80381b:	48                   	dec    %eax
  80381c:	a3 3c 50 80 00       	mov    %eax,0x80503c
				set_block_data(next_new_va, remaining_size, 0);
  803821:	83 ec 04             	sub    $0x4,%esp
  803824:	6a 00                	push   $0x0
  803826:	ff 75 bc             	pushl  -0x44(%ebp)
  803829:	ff 75 b8             	pushl  -0x48(%ebp)
  80382c:	e8 06 e9 ff ff       	call   802137 <set_block_data>
  803831:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  803834:	8b 45 08             	mov    0x8(%ebp),%eax
  803837:	eb 0a                	jmp    803843 <realloc_block_FF+0x719>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  803839:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  803840:	8b 45 08             	mov    0x8(%ebp),%eax
}
  803843:	c9                   	leave  
  803844:	c3                   	ret    

00803845 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803845:	55                   	push   %ebp
  803846:	89 e5                	mov    %esp,%ebp
  803848:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  80384b:	83 ec 04             	sub    $0x4,%esp
  80384e:	68 74 44 80 00       	push   $0x804474
  803853:	68 58 02 00 00       	push   $0x258
  803858:	68 7d 43 80 00       	push   $0x80437d
  80385d:	e8 90 00 00 00       	call   8038f2 <_panic>

00803862 <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803862:	55                   	push   %ebp
  803863:	89 e5                	mov    %esp,%ebp
  803865:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803868:	83 ec 04             	sub    $0x4,%esp
  80386b:	68 9c 44 80 00       	push   $0x80449c
  803870:	68 61 02 00 00       	push   $0x261
  803875:	68 7d 43 80 00       	push   $0x80437d
  80387a:	e8 73 00 00 00       	call   8038f2 <_panic>

0080387f <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80387f:	55                   	push   %ebp
  803880:	89 e5                	mov    %esp,%ebp
  803882:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  803885:	83 ec 04             	sub    $0x4,%esp
  803888:	68 c4 44 80 00       	push   $0x8044c4
  80388d:	6a 09                	push   $0x9
  80388f:	68 ec 44 80 00       	push   $0x8044ec
  803894:	e8 59 00 00 00       	call   8038f2 <_panic>

00803899 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  803899:	55                   	push   %ebp
  80389a:	89 e5                	mov    %esp,%ebp
  80389c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  80389f:	83 ec 04             	sub    $0x4,%esp
  8038a2:	68 fc 44 80 00       	push   $0x8044fc
  8038a7:	6a 10                	push   $0x10
  8038a9:	68 ec 44 80 00       	push   $0x8044ec
  8038ae:	e8 3f 00 00 00       	call   8038f2 <_panic>

008038b3 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8038b3:	55                   	push   %ebp
  8038b4:	89 e5                	mov    %esp,%ebp
  8038b6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8038b9:	83 ec 04             	sub    $0x4,%esp
  8038bc:	68 24 45 80 00       	push   $0x804524
  8038c1:	6a 18                	push   $0x18
  8038c3:	68 ec 44 80 00       	push   $0x8044ec
  8038c8:	e8 25 00 00 00       	call   8038f2 <_panic>

008038cd <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8038cd:	55                   	push   %ebp
  8038ce:	89 e5                	mov    %esp,%ebp
  8038d0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8038d3:	83 ec 04             	sub    $0x4,%esp
  8038d6:	68 4c 45 80 00       	push   $0x80454c
  8038db:	6a 20                	push   $0x20
  8038dd:	68 ec 44 80 00       	push   $0x8044ec
  8038e2:	e8 0b 00 00 00       	call   8038f2 <_panic>

008038e7 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8038e7:	55                   	push   %ebp
  8038e8:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8038ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ed:	8b 40 10             	mov    0x10(%eax),%eax
}
  8038f0:	5d                   	pop    %ebp
  8038f1:	c3                   	ret    

008038f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8038f2:	55                   	push   %ebp
  8038f3:	89 e5                	mov    %esp,%ebp
  8038f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8038f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8038fb:	83 c0 04             	add    $0x4,%eax
  8038fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803901:	a1 60 90 18 01       	mov    0x1189060,%eax
  803906:	85 c0                	test   %eax,%eax
  803908:	74 16                	je     803920 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80390a:	a1 60 90 18 01       	mov    0x1189060,%eax
  80390f:	83 ec 08             	sub    $0x8,%esp
  803912:	50                   	push   %eax
  803913:	68 74 45 80 00       	push   $0x804574
  803918:	e8 e6 ca ff ff       	call   800403 <cprintf>
  80391d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803920:	a1 00 50 80 00       	mov    0x805000,%eax
  803925:	ff 75 0c             	pushl  0xc(%ebp)
  803928:	ff 75 08             	pushl  0x8(%ebp)
  80392b:	50                   	push   %eax
  80392c:	68 79 45 80 00       	push   $0x804579
  803931:	e8 cd ca ff ff       	call   800403 <cprintf>
  803936:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803939:	8b 45 10             	mov    0x10(%ebp),%eax
  80393c:	83 ec 08             	sub    $0x8,%esp
  80393f:	ff 75 f4             	pushl  -0xc(%ebp)
  803942:	50                   	push   %eax
  803943:	e8 50 ca ff ff       	call   800398 <vcprintf>
  803948:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80394b:	83 ec 08             	sub    $0x8,%esp
  80394e:	6a 00                	push   $0x0
  803950:	68 95 45 80 00       	push   $0x804595
  803955:	e8 3e ca ff ff       	call   800398 <vcprintf>
  80395a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80395d:	e8 bf c9 ff ff       	call   800321 <exit>

	// should not return here
	while (1) ;
  803962:	eb fe                	jmp    803962 <_panic+0x70>

00803964 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803964:	55                   	push   %ebp
  803965:	89 e5                	mov    %esp,%ebp
  803967:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80396a:	a1 20 50 80 00       	mov    0x805020,%eax
  80396f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803975:	8b 45 0c             	mov    0xc(%ebp),%eax
  803978:	39 c2                	cmp    %eax,%edx
  80397a:	74 14                	je     803990 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80397c:	83 ec 04             	sub    $0x4,%esp
  80397f:	68 98 45 80 00       	push   $0x804598
  803984:	6a 26                	push   $0x26
  803986:	68 e4 45 80 00       	push   $0x8045e4
  80398b:	e8 62 ff ff ff       	call   8038f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803990:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803997:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80399e:	e9 c5 00 00 00       	jmp    803a68 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8039a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b0:	01 d0                	add    %edx,%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	85 c0                	test   %eax,%eax
  8039b6:	75 08                	jne    8039c0 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8039b8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8039bb:	e9 a5 00 00 00       	jmp    803a65 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8039c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8039c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8039ce:	eb 69                	jmp    803a39 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8039d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8039d5:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039de:	89 d0                	mov    %edx,%eax
  8039e0:	01 c0                	add    %eax,%eax
  8039e2:	01 d0                	add    %edx,%eax
  8039e4:	c1 e0 03             	shl    $0x3,%eax
  8039e7:	01 c8                	add    %ecx,%eax
  8039e9:	8a 40 04             	mov    0x4(%eax),%al
  8039ec:	84 c0                	test   %al,%al
  8039ee:	75 46                	jne    803a36 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8039f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8039f5:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  8039fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039fe:	89 d0                	mov    %edx,%eax
  803a00:	01 c0                	add    %eax,%eax
  803a02:	01 d0                	add    %edx,%eax
  803a04:	c1 e0 03             	shl    $0x3,%eax
  803a07:	01 c8                	add    %ecx,%eax
  803a09:	8b 00                	mov    (%eax),%eax
  803a0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803a0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803a16:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803a22:	8b 45 08             	mov    0x8(%ebp),%eax
  803a25:	01 c8                	add    %ecx,%eax
  803a27:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803a29:	39 c2                	cmp    %eax,%edx
  803a2b:	75 09                	jne    803a36 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803a2d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803a34:	eb 15                	jmp    803a4b <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a36:	ff 45 e8             	incl   -0x18(%ebp)
  803a39:	a1 20 50 80 00       	mov    0x805020,%eax
  803a3e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a47:	39 c2                	cmp    %eax,%edx
  803a49:	77 85                	ja     8039d0 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803a4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a4f:	75 14                	jne    803a65 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803a51:	83 ec 04             	sub    $0x4,%esp
  803a54:	68 f0 45 80 00       	push   $0x8045f0
  803a59:	6a 3a                	push   $0x3a
  803a5b:	68 e4 45 80 00       	push   $0x8045e4
  803a60:	e8 8d fe ff ff       	call   8038f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803a65:	ff 45 f0             	incl   -0x10(%ebp)
  803a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a6e:	0f 8c 2f ff ff ff    	jl     8039a3 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803a74:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a7b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803a82:	eb 26                	jmp    803aaa <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803a84:	a1 20 50 80 00       	mov    0x805020,%eax
  803a89:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803a8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a92:	89 d0                	mov    %edx,%eax
  803a94:	01 c0                	add    %eax,%eax
  803a96:	01 d0                	add    %edx,%eax
  803a98:	c1 e0 03             	shl    $0x3,%eax
  803a9b:	01 c8                	add    %ecx,%eax
  803a9d:	8a 40 04             	mov    0x4(%eax),%al
  803aa0:	3c 01                	cmp    $0x1,%al
  803aa2:	75 03                	jne    803aa7 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803aa4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803aa7:	ff 45 e0             	incl   -0x20(%ebp)
  803aaa:	a1 20 50 80 00       	mov    0x805020,%eax
  803aaf:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ab8:	39 c2                	cmp    %eax,%edx
  803aba:	77 c8                	ja     803a84 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803ac2:	74 14                	je     803ad8 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803ac4:	83 ec 04             	sub    $0x4,%esp
  803ac7:	68 44 46 80 00       	push   $0x804644
  803acc:	6a 44                	push   $0x44
  803ace:	68 e4 45 80 00       	push   $0x8045e4
  803ad3:	e8 1a fe ff ff       	call   8038f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803ad8:	90                   	nop
  803ad9:	c9                   	leave  
  803ada:	c3                   	ret    
  803adb:	90                   	nop

00803adc <__udivdi3>:
  803adc:	55                   	push   %ebp
  803add:	57                   	push   %edi
  803ade:	56                   	push   %esi
  803adf:	53                   	push   %ebx
  803ae0:	83 ec 1c             	sub    $0x1c,%esp
  803ae3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ae7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803aeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803af3:	89 ca                	mov    %ecx,%edx
  803af5:	89 f8                	mov    %edi,%eax
  803af7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803afb:	85 f6                	test   %esi,%esi
  803afd:	75 2d                	jne    803b2c <__udivdi3+0x50>
  803aff:	39 cf                	cmp    %ecx,%edi
  803b01:	77 65                	ja     803b68 <__udivdi3+0x8c>
  803b03:	89 fd                	mov    %edi,%ebp
  803b05:	85 ff                	test   %edi,%edi
  803b07:	75 0b                	jne    803b14 <__udivdi3+0x38>
  803b09:	b8 01 00 00 00       	mov    $0x1,%eax
  803b0e:	31 d2                	xor    %edx,%edx
  803b10:	f7 f7                	div    %edi
  803b12:	89 c5                	mov    %eax,%ebp
  803b14:	31 d2                	xor    %edx,%edx
  803b16:	89 c8                	mov    %ecx,%eax
  803b18:	f7 f5                	div    %ebp
  803b1a:	89 c1                	mov    %eax,%ecx
  803b1c:	89 d8                	mov    %ebx,%eax
  803b1e:	f7 f5                	div    %ebp
  803b20:	89 cf                	mov    %ecx,%edi
  803b22:	89 fa                	mov    %edi,%edx
  803b24:	83 c4 1c             	add    $0x1c,%esp
  803b27:	5b                   	pop    %ebx
  803b28:	5e                   	pop    %esi
  803b29:	5f                   	pop    %edi
  803b2a:	5d                   	pop    %ebp
  803b2b:	c3                   	ret    
  803b2c:	39 ce                	cmp    %ecx,%esi
  803b2e:	77 28                	ja     803b58 <__udivdi3+0x7c>
  803b30:	0f bd fe             	bsr    %esi,%edi
  803b33:	83 f7 1f             	xor    $0x1f,%edi
  803b36:	75 40                	jne    803b78 <__udivdi3+0x9c>
  803b38:	39 ce                	cmp    %ecx,%esi
  803b3a:	72 0a                	jb     803b46 <__udivdi3+0x6a>
  803b3c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b40:	0f 87 9e 00 00 00    	ja     803be4 <__udivdi3+0x108>
  803b46:	b8 01 00 00 00       	mov    $0x1,%eax
  803b4b:	89 fa                	mov    %edi,%edx
  803b4d:	83 c4 1c             	add    $0x1c,%esp
  803b50:	5b                   	pop    %ebx
  803b51:	5e                   	pop    %esi
  803b52:	5f                   	pop    %edi
  803b53:	5d                   	pop    %ebp
  803b54:	c3                   	ret    
  803b55:	8d 76 00             	lea    0x0(%esi),%esi
  803b58:	31 ff                	xor    %edi,%edi
  803b5a:	31 c0                	xor    %eax,%eax
  803b5c:	89 fa                	mov    %edi,%edx
  803b5e:	83 c4 1c             	add    $0x1c,%esp
  803b61:	5b                   	pop    %ebx
  803b62:	5e                   	pop    %esi
  803b63:	5f                   	pop    %edi
  803b64:	5d                   	pop    %ebp
  803b65:	c3                   	ret    
  803b66:	66 90                	xchg   %ax,%ax
  803b68:	89 d8                	mov    %ebx,%eax
  803b6a:	f7 f7                	div    %edi
  803b6c:	31 ff                	xor    %edi,%edi
  803b6e:	89 fa                	mov    %edi,%edx
  803b70:	83 c4 1c             	add    $0x1c,%esp
  803b73:	5b                   	pop    %ebx
  803b74:	5e                   	pop    %esi
  803b75:	5f                   	pop    %edi
  803b76:	5d                   	pop    %ebp
  803b77:	c3                   	ret    
  803b78:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b7d:	89 eb                	mov    %ebp,%ebx
  803b7f:	29 fb                	sub    %edi,%ebx
  803b81:	89 f9                	mov    %edi,%ecx
  803b83:	d3 e6                	shl    %cl,%esi
  803b85:	89 c5                	mov    %eax,%ebp
  803b87:	88 d9                	mov    %bl,%cl
  803b89:	d3 ed                	shr    %cl,%ebp
  803b8b:	89 e9                	mov    %ebp,%ecx
  803b8d:	09 f1                	or     %esi,%ecx
  803b8f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b93:	89 f9                	mov    %edi,%ecx
  803b95:	d3 e0                	shl    %cl,%eax
  803b97:	89 c5                	mov    %eax,%ebp
  803b99:	89 d6                	mov    %edx,%esi
  803b9b:	88 d9                	mov    %bl,%cl
  803b9d:	d3 ee                	shr    %cl,%esi
  803b9f:	89 f9                	mov    %edi,%ecx
  803ba1:	d3 e2                	shl    %cl,%edx
  803ba3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba7:	88 d9                	mov    %bl,%cl
  803ba9:	d3 e8                	shr    %cl,%eax
  803bab:	09 c2                	or     %eax,%edx
  803bad:	89 d0                	mov    %edx,%eax
  803baf:	89 f2                	mov    %esi,%edx
  803bb1:	f7 74 24 0c          	divl   0xc(%esp)
  803bb5:	89 d6                	mov    %edx,%esi
  803bb7:	89 c3                	mov    %eax,%ebx
  803bb9:	f7 e5                	mul    %ebp
  803bbb:	39 d6                	cmp    %edx,%esi
  803bbd:	72 19                	jb     803bd8 <__udivdi3+0xfc>
  803bbf:	74 0b                	je     803bcc <__udivdi3+0xf0>
  803bc1:	89 d8                	mov    %ebx,%eax
  803bc3:	31 ff                	xor    %edi,%edi
  803bc5:	e9 58 ff ff ff       	jmp    803b22 <__udivdi3+0x46>
  803bca:	66 90                	xchg   %ax,%ax
  803bcc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bd0:	89 f9                	mov    %edi,%ecx
  803bd2:	d3 e2                	shl    %cl,%edx
  803bd4:	39 c2                	cmp    %eax,%edx
  803bd6:	73 e9                	jae    803bc1 <__udivdi3+0xe5>
  803bd8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bdb:	31 ff                	xor    %edi,%edi
  803bdd:	e9 40 ff ff ff       	jmp    803b22 <__udivdi3+0x46>
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	31 c0                	xor    %eax,%eax
  803be6:	e9 37 ff ff ff       	jmp    803b22 <__udivdi3+0x46>
  803beb:	90                   	nop

00803bec <__umoddi3>:
  803bec:	55                   	push   %ebp
  803bed:	57                   	push   %edi
  803bee:	56                   	push   %esi
  803bef:	53                   	push   %ebx
  803bf0:	83 ec 1c             	sub    $0x1c,%esp
  803bf3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bf7:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c0b:	89 f3                	mov    %esi,%ebx
  803c0d:	89 fa                	mov    %edi,%edx
  803c0f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c13:	89 34 24             	mov    %esi,(%esp)
  803c16:	85 c0                	test   %eax,%eax
  803c18:	75 1a                	jne    803c34 <__umoddi3+0x48>
  803c1a:	39 f7                	cmp    %esi,%edi
  803c1c:	0f 86 a2 00 00 00    	jbe    803cc4 <__umoddi3+0xd8>
  803c22:	89 c8                	mov    %ecx,%eax
  803c24:	89 f2                	mov    %esi,%edx
  803c26:	f7 f7                	div    %edi
  803c28:	89 d0                	mov    %edx,%eax
  803c2a:	31 d2                	xor    %edx,%edx
  803c2c:	83 c4 1c             	add    $0x1c,%esp
  803c2f:	5b                   	pop    %ebx
  803c30:	5e                   	pop    %esi
  803c31:	5f                   	pop    %edi
  803c32:	5d                   	pop    %ebp
  803c33:	c3                   	ret    
  803c34:	39 f0                	cmp    %esi,%eax
  803c36:	0f 87 ac 00 00 00    	ja     803ce8 <__umoddi3+0xfc>
  803c3c:	0f bd e8             	bsr    %eax,%ebp
  803c3f:	83 f5 1f             	xor    $0x1f,%ebp
  803c42:	0f 84 ac 00 00 00    	je     803cf4 <__umoddi3+0x108>
  803c48:	bf 20 00 00 00       	mov    $0x20,%edi
  803c4d:	29 ef                	sub    %ebp,%edi
  803c4f:	89 fe                	mov    %edi,%esi
  803c51:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c55:	89 e9                	mov    %ebp,%ecx
  803c57:	d3 e0                	shl    %cl,%eax
  803c59:	89 d7                	mov    %edx,%edi
  803c5b:	89 f1                	mov    %esi,%ecx
  803c5d:	d3 ef                	shr    %cl,%edi
  803c5f:	09 c7                	or     %eax,%edi
  803c61:	89 e9                	mov    %ebp,%ecx
  803c63:	d3 e2                	shl    %cl,%edx
  803c65:	89 14 24             	mov    %edx,(%esp)
  803c68:	89 d8                	mov    %ebx,%eax
  803c6a:	d3 e0                	shl    %cl,%eax
  803c6c:	89 c2                	mov    %eax,%edx
  803c6e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c72:	d3 e0                	shl    %cl,%eax
  803c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c78:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c7c:	89 f1                	mov    %esi,%ecx
  803c7e:	d3 e8                	shr    %cl,%eax
  803c80:	09 d0                	or     %edx,%eax
  803c82:	d3 eb                	shr    %cl,%ebx
  803c84:	89 da                	mov    %ebx,%edx
  803c86:	f7 f7                	div    %edi
  803c88:	89 d3                	mov    %edx,%ebx
  803c8a:	f7 24 24             	mull   (%esp)
  803c8d:	89 c6                	mov    %eax,%esi
  803c8f:	89 d1                	mov    %edx,%ecx
  803c91:	39 d3                	cmp    %edx,%ebx
  803c93:	0f 82 87 00 00 00    	jb     803d20 <__umoddi3+0x134>
  803c99:	0f 84 91 00 00 00    	je     803d30 <__umoddi3+0x144>
  803c9f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803ca3:	29 f2                	sub    %esi,%edx
  803ca5:	19 cb                	sbb    %ecx,%ebx
  803ca7:	89 d8                	mov    %ebx,%eax
  803ca9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cad:	d3 e0                	shl    %cl,%eax
  803caf:	89 e9                	mov    %ebp,%ecx
  803cb1:	d3 ea                	shr    %cl,%edx
  803cb3:	09 d0                	or     %edx,%eax
  803cb5:	89 e9                	mov    %ebp,%ecx
  803cb7:	d3 eb                	shr    %cl,%ebx
  803cb9:	89 da                	mov    %ebx,%edx
  803cbb:	83 c4 1c             	add    $0x1c,%esp
  803cbe:	5b                   	pop    %ebx
  803cbf:	5e                   	pop    %esi
  803cc0:	5f                   	pop    %edi
  803cc1:	5d                   	pop    %ebp
  803cc2:	c3                   	ret    
  803cc3:	90                   	nop
  803cc4:	89 fd                	mov    %edi,%ebp
  803cc6:	85 ff                	test   %edi,%edi
  803cc8:	75 0b                	jne    803cd5 <__umoddi3+0xe9>
  803cca:	b8 01 00 00 00       	mov    $0x1,%eax
  803ccf:	31 d2                	xor    %edx,%edx
  803cd1:	f7 f7                	div    %edi
  803cd3:	89 c5                	mov    %eax,%ebp
  803cd5:	89 f0                	mov    %esi,%eax
  803cd7:	31 d2                	xor    %edx,%edx
  803cd9:	f7 f5                	div    %ebp
  803cdb:	89 c8                	mov    %ecx,%eax
  803cdd:	f7 f5                	div    %ebp
  803cdf:	89 d0                	mov    %edx,%eax
  803ce1:	e9 44 ff ff ff       	jmp    803c2a <__umoddi3+0x3e>
  803ce6:	66 90                	xchg   %ax,%ax
  803ce8:	89 c8                	mov    %ecx,%eax
  803cea:	89 f2                	mov    %esi,%edx
  803cec:	83 c4 1c             	add    $0x1c,%esp
  803cef:	5b                   	pop    %ebx
  803cf0:	5e                   	pop    %esi
  803cf1:	5f                   	pop    %edi
  803cf2:	5d                   	pop    %ebp
  803cf3:	c3                   	ret    
  803cf4:	3b 04 24             	cmp    (%esp),%eax
  803cf7:	72 06                	jb     803cff <__umoddi3+0x113>
  803cf9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cfd:	77 0f                	ja     803d0e <__umoddi3+0x122>
  803cff:	89 f2                	mov    %esi,%edx
  803d01:	29 f9                	sub    %edi,%ecx
  803d03:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d07:	89 14 24             	mov    %edx,(%esp)
  803d0a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d0e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d12:	8b 14 24             	mov    (%esp),%edx
  803d15:	83 c4 1c             	add    $0x1c,%esp
  803d18:	5b                   	pop    %ebx
  803d19:	5e                   	pop    %esi
  803d1a:	5f                   	pop    %edi
  803d1b:	5d                   	pop    %ebp
  803d1c:	c3                   	ret    
  803d1d:	8d 76 00             	lea    0x0(%esi),%esi
  803d20:	2b 04 24             	sub    (%esp),%eax
  803d23:	19 fa                	sbb    %edi,%edx
  803d25:	89 d1                	mov    %edx,%ecx
  803d27:	89 c6                	mov    %eax,%esi
  803d29:	e9 71 ff ff ff       	jmp    803c9f <__umoddi3+0xb3>
  803d2e:	66 90                	xchg   %ax,%ax
  803d30:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d34:	72 ea                	jb     803d20 <__umoddi3+0x134>
  803d36:	89 d9                	mov    %ebx,%ecx
  803d38:	e9 62 ff ff ff       	jmp    803c9f <__umoddi3+0xb3>
