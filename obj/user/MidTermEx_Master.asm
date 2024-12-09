
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
  800045:	68 20 3e 80 00       	push   $0x803e20
  80004a:	e8 82 14 00 00       	call   8014d1 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 24 3e 80 00       	push   $0x803e24
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
  80009a:	68 49 3e 80 00       	push   $0x803e49
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
  8000da:	68 50 3e 80 00       	push   $0x803e50
  8000df:	50                   	push   %eax
  8000e0:	e8 16 37 00 00       	call   8037fb <create_semaphore>
  8000e5:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	6a 01                	push   $0x1
  8000ed:	6a 04                	push   $0x4
  8000ef:	68 52 3e 80 00       	push   $0x803e52
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
  80012e:	68 60 3e 80 00       	push   $0x803e60
  800133:	e8 13 18 00 00       	call   80194b <sys_create_env>
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
  800164:	68 6a 3e 80 00       	push   $0x803e6a
  800169:	e8 dd 17 00 00       	call   80194b <sys_create_env>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 ea 17 00 00       	call   801969 <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	e8 dc 17 00 00       	call   801969 <sys_run_env>
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
  8001a4:	68 74 3e 80 00       	push   $0x803e74
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
  8001c8:	e8 bb 16 00 00       	call   801888 <sys_cputc>
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
  8001d9:	e8 46 15 00 00       	call   801724 <sys_cgetc>
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
  8001f6:	e8 be 17 00 00       	call   8019b9 <sys_getenvindex>
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
  800264:	e8 d4 14 00 00       	call   80173d <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	68 a4 3e 80 00       	push   $0x803ea4
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
  800294:	68 cc 3e 80 00       	push   $0x803ecc
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
  8002c5:	68 f4 3e 80 00       	push   $0x803ef4
  8002ca:	e8 34 01 00 00       	call   800403 <cprintf>
  8002cf:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d7:	8b 80 b8 05 00 00    	mov    0x5b8(%eax),%eax
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	50                   	push   %eax
  8002e1:	68 4c 3f 80 00       	push   $0x803f4c
  8002e6:	e8 18 01 00 00       	call   800403 <cprintf>
  8002eb:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002ee:	83 ec 0c             	sub    $0xc,%esp
  8002f1:	68 a4 3e 80 00       	push   $0x803ea4
  8002f6:	e8 08 01 00 00       	call   800403 <cprintf>
  8002fb:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002fe:	e8 54 14 00 00       	call   801757 <sys_unlock_cons>
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
  800316:	e8 6a 16 00 00       	call   801985 <sys_destroy_env>
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
  800327:	e8 bf 16 00 00       	call   8019eb <sys_exit_env>
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
  800375:	e8 81 13 00 00       	call   8016fb <sys_cputs>
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
  8003ec:	e8 0a 13 00 00       	call   8016fb <sys_cputs>
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
  800436:	e8 02 13 00 00       	call   80173d <sys_lock_cons>
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
  800456:	e8 fc 12 00 00       	call   801757 <sys_unlock_cons>
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
  8004a0:	e8 ff 36 00 00       	call   803ba4 <__udivdi3>
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
  8004f0:	e8 bf 37 00 00       	call   803cb4 <__umoddi3>
  8004f5:	83 c4 10             	add    $0x10,%esp
  8004f8:	05 74 41 80 00       	add    $0x804174,%eax
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
  80064b:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
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
  80072c:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  800733:	85 f6                	test   %esi,%esi
  800735:	75 19                	jne    800750 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800737:	53                   	push   %ebx
  800738:	68 85 41 80 00       	push   $0x804185
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
  800751:	68 8e 41 80 00       	push   $0x80418e
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
  80077e:	be 91 41 80 00       	mov    $0x804191,%esi
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
  801189:	68 08 43 80 00       	push   $0x804308
  80118e:	68 3f 01 00 00       	push   $0x13f
  801193:	68 2a 43 80 00       	push   $0x80432a
  801198:	e8 1c 28 00 00       	call   8039b9 <_panic>

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
  8011a9:	e8 f8 0a 00 00       	call   801ca6 <sys_sbrk>
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
  801224:	e8 01 09 00 00       	call   801b2a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801229:	85 c0                	test   %eax,%eax
  80122b:	74 16                	je     801243 <malloc+0x90>
		{
			
			ptr = alloc_block_FF(size);
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 dd 0e 00 00       	call   802115 <alloc_block_FF>
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123e:	e9 8a 01 00 00       	jmp    8013cd <malloc+0x21a>
		}
		else if (sys_isUHeapPlacementStrategyBESTFIT())
  801243:	e8 13 09 00 00       	call   801b5b <sys_isUHeapPlacementStrategyBESTFIT>
  801248:	85 c0                	test   %eax,%eax
  80124a:	0f 84 7d 01 00 00    	je     8013cd <malloc+0x21a>
			ptr = alloc_block_BF(size);
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	ff 75 08             	pushl  0x8(%ebp)
  801256:	e8 76 13 00 00       	call   8025d1 <alloc_block_BF>
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
  8012b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b8:	05 00 10 00 00       	add    $0x1000,%eax
  8012bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
				uint32 cnt = 0;
  8012c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

				
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
				
				uint32 j = i + (uint32)PAGE_SIZE;
				uint32 cnt = 0;

				
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
				

			}
			sayed:
			if(ok) break;
  801360:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801364:	75 16                	jne    80137c <malloc+0x1c9>
			i += (uint32)PAGE_SIZE;
  801366:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
	else if(num_pages < max_no_of_pages-1) // the else statement in kern/mem/kheap.c/kmalloc is wrong, rewrite it to be correct.
	{
		
		uint32 i = myEnv->heap_hard_limit + PAGE_SIZE;											// start: hardlimit + 4  ______ end: KERNEL_HEAP_MAX
		bool ok = 0;
		while (i < (uint32)USER_HEAP_MAX)
  80136d:	81 7d f0 ff ff ff 9f 	cmpl   $0x9fffffff,-0x10(%ebp)
  801374:	0f 86 15 ff ff ff    	jbe    80128f <malloc+0xdc>
  80137a:	eb 01                	jmp    80137d <malloc+0x1ca>
				}
				

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
  8013bc:	e8 1c 09 00 00       	call   801cdd <sys_allocate_user_mem>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	eb 07                	jmp    8013cd <malloc+0x21a>
		
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
  801404:	e8 8c 09 00 00       	call   801d95 <get_block_size>
  801409:	83 c4 10             	add    $0x10,%esp
  80140c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		free_block(va);
  80140f:	83 ec 0c             	sub    $0xc,%esp
  801412:	ff 75 08             	pushl  0x8(%ebp)
  801415:	e8 9c 1b 00 00       	call   802fb6 <free_block>
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
  80144f:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
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
  80148c:	c7 04 85 60 50 88 00 	movl   $0x0,0x885060(,%eax,4)
  801493:	00 00 00 00 
			sys_free_user_mem((uint32)va, k);
  801497:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	52                   	push   %edx
  8014a1:	50                   	push   %eax
  8014a2:	e8 1a 08 00 00       	call   801cc1 <sys_free_user_mem>
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
  8014ba:	68 38 43 80 00       	push   $0x804338
  8014bf:	68 87 00 00 00       	push   $0x87
  8014c4:	68 62 43 80 00       	push   $0x804362
  8014c9:	e8 eb 24 00 00       	call   8039b9 <_panic>
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
  8014e8:	e9 87 00 00 00       	jmp    801574 <smalloc+0xa3>
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
  801519:	75 07                	jne    801522 <smalloc+0x51>
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax
  801520:	eb 52                	jmp    801574 <smalloc+0xa3>
	 int32 ret = sys_createSharedObject(sharedVarName, size,  isWritable, ptr);
  801522:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801526:	ff 75 ec             	pushl  -0x14(%ebp)
  801529:	50                   	push   %eax
  80152a:	ff 75 0c             	pushl  0xc(%ebp)
  80152d:	ff 75 08             	pushl  0x8(%ebp)
  801530:	e8 93 03 00 00       	call   8018c8 <sys_createSharedObject>
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS) return NULL;
  80153b:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80153f:	74 06                	je     801547 <smalloc+0x76>
  801541:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801545:	75 07                	jne    80154e <smalloc+0x7d>
  801547:	b8 00 00 00 00       	mov    $0x0,%eax
  80154c:	eb 26                	jmp    801574 <smalloc+0xa3>
	 //cprintf("Smalloc : %x \n",ptr);


	 ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  80154e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801551:	a1 20 50 80 00       	mov    0x805020,%eax
  801556:	8b 40 78             	mov    0x78(%eax),%eax
  801559:	29 c2                	sub    %eax,%edx
  80155b:	89 d0                	mov    %edx,%eax
  80155d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801562:	c1 e8 0c             	shr    $0xc,%eax
  801565:	89 c2                	mov    %eax,%edx
  801567:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80156a:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	 return ptr;
  801571:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80157c:	83 ec 08             	sub    $0x8,%esp
  80157f:	ff 75 0c             	pushl  0xc(%ebp)
  801582:	ff 75 08             	pushl  0x8(%ebp)
  801585:	e8 68 03 00 00       	call   8018f2 <sys_getSizeOfSharedObject>
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS) return NULL;
  801590:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801594:	75 07                	jne    80159d <sget+0x27>
  801596:	b8 00 00 00 00       	mov    $0x0,%eax
  80159b:	eb 7f                	jmp    80161c <sget+0xa6>
	void * ptr = malloc(MAX(size,PAGE_SIZE));
  80159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015a3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8015aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b0:	39 d0                	cmp    %edx,%eax
  8015b2:	73 02                	jae    8015b6 <sget+0x40>
  8015b4:	89 d0                	mov    %edx,%eax
  8015b6:	83 ec 0c             	sub    $0xc,%esp
  8015b9:	50                   	push   %eax
  8015ba:	e8 f4 fb ff ff       	call   8011b3 <malloc>
  8015bf:	83 c4 10             	add    $0x10,%esp
  8015c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(ptr == NULL) return NULL;
  8015c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015c9:	75 07                	jne    8015d2 <sget+0x5c>
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d0:	eb 4a                	jmp    80161c <sget+0xa6>
	int32 ret = sys_getSharedObject(ownerEnvID,sharedVarName,ptr);
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8015d8:	ff 75 0c             	pushl  0xc(%ebp)
  8015db:	ff 75 08             	pushl  0x8(%ebp)
  8015de:	e8 2c 03 00 00       	call   80190f <sys_getSharedObject>
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ids[UHEAP_PAGE_INDEX((uint32)ptr)] =  ret;
  8015e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8015f1:	8b 40 78             	mov    0x78(%eax),%eax
  8015f4:	29 c2                	sub    %eax,%edx
  8015f6:	89 d0                	mov    %edx,%eax
  8015f8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015fd:	c1 e8 0c             	shr    $0xc,%eax
  801600:	89 c2                	mov    %eax,%edx
  801602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801605:	89 04 95 60 50 80 00 	mov    %eax,0x805060(,%edx,4)
	
	if(ret == E_SHARED_MEM_NOT_EXISTS ) return NULL;
  80160c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801610:	75 07                	jne    801619 <sget+0xa3>
  801612:	b8 00 00 00 00       	mov    $0x0,%eax
  801617:	eb 03                	jmp    80161c <sget+0xa6>
	return ptr;
  801619:	8b 45 e8             	mov    -0x18(%ebp),%eax
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 18             	sub    $0x18,%esp
    //TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
    // Write your code here, remove the panic and write your code
//    panic("sfree() is not implemented yet...!!");
	int32 id = ids[UHEAP_PAGE_INDEX((uint32)virtual_address)];
  801624:	8b 55 08             	mov    0x8(%ebp),%edx
  801627:	a1 20 50 80 00       	mov    0x805020,%eax
  80162c:	8b 40 78             	mov    0x78(%eax),%eax
  80162f:	29 c2                	sub    %eax,%edx
  801631:	89 d0                	mov    %edx,%eax
  801633:	2d 00 10 00 00       	sub    $0x1000,%eax
  801638:	c1 e8 0c             	shr    $0xc,%eax
  80163b:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801642:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int ret = sys_freeSharedObject(id,virtual_address);
  801645:	83 ec 08             	sub    $0x8,%esp
  801648:	ff 75 08             	pushl  0x8(%ebp)
  80164b:	ff 75 f4             	pushl  -0xc(%ebp)
  80164e:	e8 db 02 00 00       	call   80192e <sys_freeSharedObject>
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	89 45 f0             	mov    %eax,-0x10(%ebp)
}
  801659:	90                   	nop
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801662:	83 ec 04             	sub    $0x4,%esp
  801665:	68 70 43 80 00       	push   $0x804370
  80166a:	68 e4 00 00 00       	push   $0xe4
  80166f:	68 62 43 80 00       	push   $0x804362
  801674:	e8 40 23 00 00       	call   8039b9 <_panic>

00801679 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	68 96 43 80 00       	push   $0x804396
  801687:	68 f0 00 00 00       	push   $0xf0
  80168c:	68 62 43 80 00       	push   $0x804362
  801691:	e8 23 23 00 00       	call   8039b9 <_panic>

00801696 <shrink>:

}
void shrink(uint32 newSize)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80169c:	83 ec 04             	sub    $0x4,%esp
  80169f:	68 96 43 80 00       	push   $0x804396
  8016a4:	68 f5 00 00 00       	push   $0xf5
  8016a9:	68 62 43 80 00       	push   $0x804362
  8016ae:	e8 06 23 00 00       	call   8039b9 <_panic>

008016b3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016b9:	83 ec 04             	sub    $0x4,%esp
  8016bc:	68 96 43 80 00       	push   $0x804396
  8016c1:	68 fa 00 00 00       	push   $0xfa
  8016c6:	68 62 43 80 00       	push   $0x804362
  8016cb:	e8 e9 22 00 00       	call   8039b9 <_panic>

008016d0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	57                   	push   %edi
  8016d4:	56                   	push   %esi
  8016d5:	53                   	push   %ebx
  8016d6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016df:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016e5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016e8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016eb:	cd 30                	int    $0x30
  8016ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	5b                   	pop    %ebx
  8016f7:	5e                   	pop    %esi
  8016f8:	5f                   	pop    %edi
  8016f9:	5d                   	pop    %ebp
  8016fa:	c3                   	ret    

008016fb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	83 ec 04             	sub    $0x4,%esp
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801707:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	52                   	push   %edx
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	50                   	push   %eax
  801717:	6a 00                	push   $0x0
  801719:	e8 b2 ff ff ff       	call   8016d0 <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	90                   	nop
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_cgetc>:

int
sys_cgetc(void)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 02                	push   $0x2
  801733:	e8 98 ff ff ff       	call   8016d0 <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <sys_lock_cons>:

void sys_lock_cons(void)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 03                	push   $0x3
  80174c:	e8 7f ff ff ff       	call   8016d0 <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	90                   	nop
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 04                	push   $0x4
  801766:	e8 65 ff ff ff       	call   8016d0 <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	90                   	nop
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801774:	8b 55 0c             	mov    0xc(%ebp),%edx
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	52                   	push   %edx
  801781:	50                   	push   %eax
  801782:	6a 08                	push   $0x8
  801784:	e8 47 ff ff ff       	call   8016d0 <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
}
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	56                   	push   %esi
  801792:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801793:	8b 75 18             	mov    0x18(%ebp),%esi
  801796:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801799:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80179c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	56                   	push   %esi
  8017a3:	53                   	push   %ebx
  8017a4:	51                   	push   %ecx
  8017a5:	52                   	push   %edx
  8017a6:	50                   	push   %eax
  8017a7:	6a 09                	push   $0x9
  8017a9:	e8 22 ff ff ff       	call   8016d0 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
}
  8017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b4:	5b                   	pop    %ebx
  8017b5:	5e                   	pop    %esi
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    

008017b8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	52                   	push   %edx
  8017c8:	50                   	push   %eax
  8017c9:	6a 0a                	push   $0xa
  8017cb:	e8 00 ff ff ff       	call   8016d0 <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	ff 75 0c             	pushl  0xc(%ebp)
  8017e1:	ff 75 08             	pushl  0x8(%ebp)
  8017e4:	6a 0b                	push   $0xb
  8017e6:	e8 e5 fe ff ff       	call   8016d0 <syscall>
  8017eb:	83 c4 18             	add    $0x18,%esp
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 0c                	push   $0xc
  8017ff:	e8 cc fe ff ff       	call   8016d0 <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	c9                   	leave  
  801808:	c3                   	ret    

00801809 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 0d                	push   $0xd
  801818:	e8 b3 fe ff ff       	call   8016d0 <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 0e                	push   $0xe
  801831:	e8 9a fe ff ff       	call   8016d0 <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 0f                	push   $0xf
  80184a:	e8 81 fe ff ff       	call   8016d0 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	ff 75 08             	pushl  0x8(%ebp)
  801862:	6a 10                	push   $0x10
  801864:	e8 67 fe ff ff       	call   8016d0 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 11                	push   $0x11
  80187d:	e8 4e fe ff ff       	call   8016d0 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	90                   	nop
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_cputc>:

void
sys_cputc(const char c)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801894:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	50                   	push   %eax
  8018a1:	6a 01                	push   $0x1
  8018a3:	e8 28 fe ff ff       	call   8016d0 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	90                   	nop
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 14                	push   $0x14
  8018bd:	e8 0e fe ff ff       	call   8016d0 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	90                   	nop
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 04             	sub    $0x4,%esp
  8018ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018d4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018d7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	51                   	push   %ecx
  8018e1:	52                   	push   %edx
  8018e2:	ff 75 0c             	pushl  0xc(%ebp)
  8018e5:	50                   	push   %eax
  8018e6:	6a 15                	push   $0x15
  8018e8:	e8 e3 fd ff ff       	call   8016d0 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	52                   	push   %edx
  801902:	50                   	push   %eax
  801903:	6a 16                	push   $0x16
  801905:	e8 c6 fd ff ff       	call   8016d0 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801912:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801915:	8b 55 0c             	mov    0xc(%ebp),%edx
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	51                   	push   %ecx
  801920:	52                   	push   %edx
  801921:	50                   	push   %eax
  801922:	6a 17                	push   $0x17
  801924:	e8 a7 fd ff ff       	call   8016d0 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801931:	8b 55 0c             	mov    0xc(%ebp),%edx
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	52                   	push   %edx
  80193e:	50                   	push   %eax
  80193f:	6a 18                	push   $0x18
  801941:	e8 8a fd ff ff       	call   8016d0 <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	6a 00                	push   $0x0
  801953:	ff 75 14             	pushl  0x14(%ebp)
  801956:	ff 75 10             	pushl  0x10(%ebp)
  801959:	ff 75 0c             	pushl  0xc(%ebp)
  80195c:	50                   	push   %eax
  80195d:	6a 19                	push   $0x19
  80195f:	e8 6c fd ff ff       	call   8016d0 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	50                   	push   %eax
  801978:	6a 1a                	push   $0x1a
  80197a:	e8 51 fd ff ff       	call   8016d0 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	90                   	nop
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	50                   	push   %eax
  801994:	6a 1b                	push   $0x1b
  801996:	e8 35 fd ff ff       	call   8016d0 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 05                	push   $0x5
  8019af:	e8 1c fd ff ff       	call   8016d0 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 06                	push   $0x6
  8019c8:	e8 03 fd ff ff       	call   8016d0 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 07                	push   $0x7
  8019e1:	e8 ea fc ff ff       	call   8016d0 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_exit_env>:


void sys_exit_env(void)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 1c                	push   $0x1c
  8019fa:	e8 d1 fc ff ff       	call   8016d0 <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
}
  801a02:	90                   	nop
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a0b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a0e:	8d 50 04             	lea    0x4(%eax),%edx
  801a11:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	52                   	push   %edx
  801a1b:	50                   	push   %eax
  801a1c:	6a 1d                	push   $0x1d
  801a1e:	e8 ad fc ff ff       	call   8016d0 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
	return result;
  801a26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a2f:	89 01                	mov    %eax,(%ecx)
  801a31:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	c9                   	leave  
  801a38:	c2 04 00             	ret    $0x4

00801a3b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	ff 75 10             	pushl  0x10(%ebp)
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	ff 75 08             	pushl  0x8(%ebp)
  801a4b:	6a 13                	push   $0x13
  801a4d:	e8 7e fc ff ff       	call   8016d0 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
	return ;
  801a55:	90                   	nop
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 1e                	push   $0x1e
  801a67:	e8 64 fc ff ff       	call   8016d0 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 04             	sub    $0x4,%esp
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a7d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	50                   	push   %eax
  801a8a:	6a 1f                	push   $0x1f
  801a8c:	e8 3f fc ff ff       	call   8016d0 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
	return ;
  801a94:	90                   	nop
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <rsttst>:
void rsttst()
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 21                	push   $0x21
  801aa6:	e8 25 fc ff ff       	call   8016d0 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
	return ;
  801aae:	90                   	nop
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801abd:	8b 55 18             	mov    0x18(%ebp),%edx
  801ac0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac4:	52                   	push   %edx
  801ac5:	50                   	push   %eax
  801ac6:	ff 75 10             	pushl  0x10(%ebp)
  801ac9:	ff 75 0c             	pushl  0xc(%ebp)
  801acc:	ff 75 08             	pushl  0x8(%ebp)
  801acf:	6a 20                	push   $0x20
  801ad1:	e8 fa fb ff ff       	call   8016d0 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad9:	90                   	nop
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <chktst>:
void chktst(uint32 n)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	ff 75 08             	pushl  0x8(%ebp)
  801aea:	6a 22                	push   $0x22
  801aec:	e8 df fb ff ff       	call   8016d0 <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
	return ;
  801af4:	90                   	nop
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <inctst>:

void inctst()
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 23                	push   $0x23
  801b06:	e8 c5 fb ff ff       	call   8016d0 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0e:	90                   	nop
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <gettst>:
uint32 gettst()
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 24                	push   $0x24
  801b20:	e8 ab fb ff ff       	call   8016d0 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 25                	push   $0x25
  801b3c:	e8 8f fb ff ff       	call   8016d0 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
  801b44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b47:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b4b:	75 07                	jne    801b54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b52:	eb 05                	jmp    801b59 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 25                	push   $0x25
  801b6d:	e8 5e fb ff ff       	call   8016d0 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
  801b75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b78:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b7c:	75 07                	jne    801b85 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b83:	eb 05                	jmp    801b8a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 25                	push   $0x25
  801b9e:	e8 2d fb ff ff       	call   8016d0 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
  801ba6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ba9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bad:	75 07                	jne    801bb6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801baf:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb4:	eb 05                	jmp    801bbb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 25                	push   $0x25
  801bcf:	e8 fc fa ff ff       	call   8016d0 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
  801bd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bda:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bde:	75 07                	jne    801be7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801be0:	b8 01 00 00 00       	mov    $0x1,%eax
  801be5:	eb 05                	jmp    801bec <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	ff 75 08             	pushl  0x8(%ebp)
  801bfc:	6a 26                	push   $0x26
  801bfe:	e8 cd fa ff ff       	call   8016d0 <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
	return ;
  801c06:	90                   	nop
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	6a 00                	push   $0x0
  801c1b:	53                   	push   %ebx
  801c1c:	51                   	push   %ecx
  801c1d:	52                   	push   %edx
  801c1e:	50                   	push   %eax
  801c1f:	6a 27                	push   $0x27
  801c21:	e8 aa fa ff ff       	call   8016d0 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	52                   	push   %edx
  801c3e:	50                   	push   %eax
  801c3f:	6a 28                	push   $0x28
  801c41:	e8 8a fa ff ff       	call   8016d0 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801c4e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	6a 00                	push   $0x0
  801c59:	51                   	push   %ecx
  801c5a:	ff 75 10             	pushl  0x10(%ebp)
  801c5d:	52                   	push   %edx
  801c5e:	50                   	push   %eax
  801c5f:	6a 29                	push   $0x29
  801c61:	e8 6a fa ff ff       	call   8016d0 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	ff 75 10             	pushl  0x10(%ebp)
  801c75:	ff 75 0c             	pushl  0xc(%ebp)
  801c78:	ff 75 08             	pushl  0x8(%ebp)
  801c7b:	6a 12                	push   $0x12
  801c7d:	e8 4e fa ff ff       	call   8016d0 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
	return ;
  801c85:	90                   	nop
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	52                   	push   %edx
  801c98:	50                   	push   %eax
  801c99:	6a 2a                	push   $0x2a
  801c9b:	e8 30 fa ff ff       	call   8016d0 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
	return;
  801ca3:	90                   	nop
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	50                   	push   %eax
  801cb5:	6a 2b                	push   $0x2b
  801cb7:	e8 14 fa ff ff       	call   8016d0 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	ff 75 0c             	pushl  0xc(%ebp)
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	6a 2c                	push   $0x2c
  801cd2:	e8 f9 f9 ff ff       	call   8016d0 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
	return;
  801cda:	90                   	nop
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	ff 75 0c             	pushl  0xc(%ebp)
  801ce9:	ff 75 08             	pushl  0x8(%ebp)
  801cec:	6a 2d                	push   $0x2d
  801cee:	e8 dd f9 ff ff       	call   8016d0 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
	return;
  801cf6:	90                   	nop
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_get_cpu_process>:

struct Env* sys_get_cpu_process()
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return ;
   syscall_return  = ( struct Env*)syscall(SYS_get_cpu_process,0,0,0,0,0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 2e                	push   $0x2e
  801d0b:	e8 c0 f9 ff ff       	call   8016d0 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
  801d13:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801d16:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_init_queue>:
void sys_init_queue(struct Env_Queue*queue){
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_init_queue,(uint32)queue,0,0,0,0);
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	50                   	push   %eax
  801d2a:	6a 2f                	push   $0x2f
  801d2c:	e8 9f f9 ff ff       	call   8016d0 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
	return;
  801d34:	90                   	nop
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_enqueue>:
void sys_enqueue(struct Env_Queue* queue, struct Env* env){
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enqueue,(uint32)queue,(uint32)env,0,0,0);
  801d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	52                   	push   %edx
  801d47:	50                   	push   %eax
  801d48:	6a 30                	push   $0x30
  801d4a:	e8 81 f9 ff ff       	call   8016d0 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
	return;
  801d52:	90                   	nop
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_dequeue>:

struct Env* sys_dequeue(struct Env_Queue* queue)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 10             	sub    $0x10,%esp
   struct Env* syscall_return;
   syscall_return  = ( struct Env*)syscall(SYS_dequeue,(uint32)queue,0,0,0,0);
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	50                   	push   %eax
  801d67:	6a 31                	push   $0x31
  801d69:	e8 62 f9 ff ff       	call   8016d0 <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
  801d71:	89 45 fc             	mov    %eax,-0x4(%ebp)
   return syscall_return ;
  801d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <sys_sched_insert_ready>:

void sys_sched_insert_ready( struct Env* env){
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_sched_insert_ready,(uint32)env,0,0,0,0);
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	50                   	push   %eax
  801d88:	6a 32                	push   $0x32
  801d8a:	e8 41 f9 ff ff       	call   8016d0 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
	return;
  801d92:	90                   	nop
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	83 e8 04             	sub    $0x4,%eax
  801da1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801da4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801da7:	8b 00                	mov    (%eax),%eax
  801da9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	83 e8 04             	sub    $0x4,%eax
  801dba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dc0:	8b 00                	mov    (%eax),%eax
  801dc2:	83 e0 01             	and    $0x1,%eax
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	0f 94 c0             	sete   %al
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801dd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddc:	83 f8 02             	cmp    $0x2,%eax
  801ddf:	74 2b                	je     801e0c <alloc_block+0x40>
  801de1:	83 f8 02             	cmp    $0x2,%eax
  801de4:	7f 07                	jg     801ded <alloc_block+0x21>
  801de6:	83 f8 01             	cmp    $0x1,%eax
  801de9:	74 0e                	je     801df9 <alloc_block+0x2d>
  801deb:	eb 58                	jmp    801e45 <alloc_block+0x79>
  801ded:	83 f8 03             	cmp    $0x3,%eax
  801df0:	74 2d                	je     801e1f <alloc_block+0x53>
  801df2:	83 f8 04             	cmp    $0x4,%eax
  801df5:	74 3b                	je     801e32 <alloc_block+0x66>
  801df7:	eb 4c                	jmp    801e45 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801df9:	83 ec 0c             	sub    $0xc,%esp
  801dfc:	ff 75 08             	pushl  0x8(%ebp)
  801dff:	e8 11 03 00 00       	call   802115 <alloc_block_FF>
  801e04:	83 c4 10             	add    $0x10,%esp
  801e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e0a:	eb 4a                	jmp    801e56 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	ff 75 08             	pushl  0x8(%ebp)
  801e12:	e8 c7 19 00 00       	call   8037de <alloc_block_NF>
  801e17:	83 c4 10             	add    $0x10,%esp
  801e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e1d:	eb 37                	jmp    801e56 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801e1f:	83 ec 0c             	sub    $0xc,%esp
  801e22:	ff 75 08             	pushl  0x8(%ebp)
  801e25:	e8 a7 07 00 00       	call   8025d1 <alloc_block_BF>
  801e2a:	83 c4 10             	add    $0x10,%esp
  801e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e30:	eb 24                	jmp    801e56 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801e32:	83 ec 0c             	sub    $0xc,%esp
  801e35:	ff 75 08             	pushl  0x8(%ebp)
  801e38:	e8 84 19 00 00       	call   8037c1 <alloc_block_WF>
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801e43:	eb 11                	jmp    801e56 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	68 a8 43 80 00       	push   $0x8043a8
  801e4d:	e8 b1 e5 ff ff       	call   800403 <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
		break;
  801e55:	90                   	nop
	}
	return va;
  801e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	53                   	push   %ebx
  801e5f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	68 c8 43 80 00       	push   $0x8043c8
  801e6a:	e8 94 e5 ff ff       	call   800403 <cprintf>
  801e6f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801e72:	83 ec 0c             	sub    $0xc,%esp
  801e75:	68 f3 43 80 00       	push   $0x8043f3
  801e7a:	e8 84 e5 ff ff       	call   800403 <cprintf>
  801e7f:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e88:	eb 37                	jmp    801ec1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801e8a:	83 ec 0c             	sub    $0xc,%esp
  801e8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801e90:	e8 19 ff ff ff       	call   801dae <is_free_block>
  801e95:	83 c4 10             	add    $0x10,%esp
  801e98:	0f be d8             	movsbl %al,%ebx
  801e9b:	83 ec 0c             	sub    $0xc,%esp
  801e9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea1:	e8 ef fe ff ff       	call   801d95 <get_block_size>
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	53                   	push   %ebx
  801ead:	50                   	push   %eax
  801eae:	68 0b 44 80 00       	push   $0x80440b
  801eb3:	e8 4b e5 ff ff       	call   800403 <cprintf>
  801eb8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec5:	74 07                	je     801ece <print_blocks_list+0x73>
  801ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eca:	8b 00                	mov    (%eax),%eax
  801ecc:	eb 05                	jmp    801ed3 <print_blocks_list+0x78>
  801ece:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed3:	89 45 10             	mov    %eax,0x10(%ebp)
  801ed6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	75 ad                	jne    801e8a <print_blocks_list+0x2f>
  801edd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee1:	75 a7                	jne    801e8a <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	68 c8 43 80 00       	push   $0x8043c8
  801eeb:	e8 13 e5 ff ff       	call   800403 <cprintf>
  801ef0:	83 c4 10             	add    $0x10,%esp

}
  801ef3:	90                   	nop
  801ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <initialize_dynamic_allocator>:
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================

// Youssef Mohsen
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 18             	sub    $0x18,%esp
        //==================================================================================
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  801eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f02:	83 e0 01             	and    $0x1,%eax
  801f05:	85 c0                	test   %eax,%eax
  801f07:	74 03                	je     801f0c <initialize_dynamic_allocator+0x13>
  801f09:	ff 45 0c             	incl   0xc(%ebp)
            if (initSizeOfAllocatedSpace == 0)
  801f0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f10:	0f 84 c7 01 00 00    	je     8020dd <initialize_dynamic_allocator+0x1e4>
                return ;
            is_initialized = 1;
  801f16:	c7 05 24 50 80 00 01 	movl   $0x1,0x805024
  801f1d:	00 00 00 
        //TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
  801f20:	8b 55 08             	mov    0x8(%ebp),%edx
  801f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f26:	01 d0                	add    %edx,%eax
  801f28:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
  801f2d:	0f 87 ad 01 00 00    	ja     8020e0 <initialize_dynamic_allocator+0x1e7>
        return;
    if(daStart < USER_HEAP_START)
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	85 c0                	test   %eax,%eax
  801f38:	0f 89 a5 01 00 00    	jns    8020e3 <initialize_dynamic_allocator+0x1ea>
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
  801f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f44:	01 d0                	add    %edx,%eax
  801f46:	83 e8 04             	sub    $0x4,%eax
  801f49:	a3 44 50 80 00       	mov    %eax,0x805044
     struct BlockElement * element = NULL;
  801f4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     LIST_FOREACH(element, &freeBlocksList)
  801f55:	a1 2c 50 80 00       	mov    0x80502c,%eax
  801f5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f5d:	e9 87 00 00 00       	jmp    801fe9 <initialize_dynamic_allocator+0xf0>
     {
        LIST_REMOVE(&freeBlocksList,element);
  801f62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f66:	75 14                	jne    801f7c <initialize_dynamic_allocator+0x83>
  801f68:	83 ec 04             	sub    $0x4,%esp
  801f6b:	68 23 44 80 00       	push   $0x804423
  801f70:	6a 79                	push   $0x79
  801f72:	68 41 44 80 00       	push   $0x804441
  801f77:	e8 3d 1a 00 00       	call   8039b9 <_panic>
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	8b 00                	mov    (%eax),%eax
  801f81:	85 c0                	test   %eax,%eax
  801f83:	74 10                	je     801f95 <initialize_dynamic_allocator+0x9c>
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	8b 00                	mov    (%eax),%eax
  801f8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8d:	8b 52 04             	mov    0x4(%edx),%edx
  801f90:	89 50 04             	mov    %edx,0x4(%eax)
  801f93:	eb 0b                	jmp    801fa0 <initialize_dynamic_allocator+0xa7>
  801f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f98:	8b 40 04             	mov    0x4(%eax),%eax
  801f9b:	a3 30 50 80 00       	mov    %eax,0x805030
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	8b 40 04             	mov    0x4(%eax),%eax
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	74 0f                	je     801fb9 <initialize_dynamic_allocator+0xc0>
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 40 04             	mov    0x4(%eax),%eax
  801fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb3:	8b 12                	mov    (%edx),%edx
  801fb5:	89 10                	mov    %edx,(%eax)
  801fb7:	eb 0a                	jmp    801fc3 <initialize_dynamic_allocator+0xca>
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	8b 00                	mov    (%eax),%eax
  801fbe:	a3 2c 50 80 00       	mov    %eax,0x80502c
  801fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fd6:	a1 38 50 80 00       	mov    0x805038,%eax
  801fdb:	48                   	dec    %eax
  801fdc:	a3 38 50 80 00       	mov    %eax,0x805038
        return;
    if(daStart < USER_HEAP_START)
        return;
    end_add = daStart + initSizeOfAllocatedSpace - sizeof(struct Block_Start_End);
     struct BlockElement * element = NULL;
     LIST_FOREACH(element, &freeBlocksList)
  801fe1:	a1 34 50 80 00       	mov    0x805034,%eax
  801fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fed:	74 07                	je     801ff6 <initialize_dynamic_allocator+0xfd>
  801fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff2:	8b 00                	mov    (%eax),%eax
  801ff4:	eb 05                	jmp    801ffb <initialize_dynamic_allocator+0x102>
  801ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffb:	a3 34 50 80 00       	mov    %eax,0x805034
  802000:	a1 34 50 80 00       	mov    0x805034,%eax
  802005:	85 c0                	test   %eax,%eax
  802007:	0f 85 55 ff ff ff    	jne    801f62 <initialize_dynamic_allocator+0x69>
  80200d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802011:	0f 85 4b ff ff ff    	jne    801f62 <initialize_dynamic_allocator+0x69>
     {
        LIST_REMOVE(&freeBlocksList,element);
     }

    // Create the BEG Block
    struct Block_Start_End* beg_block = (struct Block_Start_End*) daStart;
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    beg_block->info = 1;
  80201d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802020:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

    // Create the END Block
    end_block = (struct Block_Start_End*) (end_add);
  802026:	a1 44 50 80 00       	mov    0x805044,%eax
  80202b:	a3 40 50 80 00       	mov    %eax,0x805040
    end_block->info = 1;
  802030:	a1 40 50 80 00       	mov    0x805040,%eax
  802035:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    // Create the first free block
    struct BlockElement* first_free_block = (struct BlockElement*)(daStart + 2*sizeof(struct Block_Start_End));
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	83 c0 08             	add    $0x8,%eax
  802041:	89 45 ec             	mov    %eax,-0x14(%ebp)


    //Assigning the Heap's Header/Footer values
    *(uint32*)((char*)daStart + 4 /*4 Byte*/) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	83 c0 04             	add    $0x4,%eax
  80204a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204d:	83 ea 08             	sub    $0x8,%edx
  802050:	89 10                	mov    %edx,(%eax)
    *(uint32*)((char*)daStart + initSizeOfAllocatedSpace - 8) = initSizeOfAllocatedSpace - 2 * sizeof(struct Block_Start_End) /*Heap's header/footer*/;
  802052:	8b 55 0c             	mov    0xc(%ebp),%edx
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	01 d0                	add    %edx,%eax
  80205a:	83 e8 08             	sub    $0x8,%eax
  80205d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802060:	83 ea 08             	sub    $0x8,%edx
  802063:	89 10                	mov    %edx,(%eax)

    // Initialize links to the END block
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
  802065:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802068:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
   first_free_block->prev_next_info.le_prev = NULL;
  80206e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802071:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
  802078:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80207c:	75 17                	jne    802095 <initialize_dynamic_allocator+0x19c>
  80207e:	83 ec 04             	sub    $0x4,%esp
  802081:	68 5c 44 80 00       	push   $0x80445c
  802086:	68 90 00 00 00       	push   $0x90
  80208b:	68 41 44 80 00       	push   $0x804441
  802090:	e8 24 19 00 00       	call   8039b9 <_panic>
  802095:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  80209b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209e:	89 10                	mov    %edx,(%eax)
  8020a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a3:	8b 00                	mov    (%eax),%eax
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	74 0d                	je     8020b6 <initialize_dynamic_allocator+0x1bd>
  8020a9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8020ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020b1:	89 50 04             	mov    %edx,0x4(%eax)
  8020b4:	eb 08                	jmp    8020be <initialize_dynamic_allocator+0x1c5>
  8020b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b9:	a3 30 50 80 00       	mov    %eax,0x805030
  8020be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c1:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8020c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d0:	a1 38 50 80 00       	mov    0x805038,%eax
  8020d5:	40                   	inc    %eax
  8020d6:	a3 38 50 80 00       	mov    %eax,0x805038
  8020db:	eb 07                	jmp    8020e4 <initialize_dynamic_allocator+0x1eb>
        //DON'T CHANGE THESE LINES==========================================================
        //==================================================================================
        {
            if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
            if (initSizeOfAllocatedSpace == 0)
                return ;
  8020dd:	90                   	nop
  8020de:	eb 04                	jmp    8020e4 <initialize_dynamic_allocator+0x1eb>
        //COMMENT THE FOLLOWING LINE BEFORE START CODING
        //panic("initialize_dynamic_allocator is not implemented yet");

    // Check for bounds
    if ((daStart + initSizeOfAllocatedSpace) > KERNEL_HEAP_MAX)
        return;
  8020e0:	90                   	nop
  8020e1:	eb 01                	jmp    8020e4 <initialize_dynamic_allocator+0x1eb>
    if(daStart < USER_HEAP_START)
        return;
  8020e3:	90                   	nop
   first_free_block->prev_next_info.le_next = NULL; // Link to the END block
   first_free_block->prev_next_info.le_prev = NULL;

    // Link the first free block into the free block list
    LIST_INSERT_HEAD(&freeBlocksList , first_free_block);
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <set_block_data>:

//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
   //TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
   //COMMENT THE FOLLOWING LINE BEFORE START CODING
   //panic("set_block_data is not implemented yet");
   //Your Code is Here...

	totalSize = totalSize|isAllocated;
  8020e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ec:	09 45 0c             	or     %eax,0xc(%ebp)
   *HEADER(va) = totalSize;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8d 50 fc             	lea    -0x4(%eax),%edx
  8020f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f8:	89 02                	mov    %eax,(%edx)
   *FOOTER(va) = totalSize;
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	83 e8 04             	sub    $0x4,%eax
  802100:	8b 00                	mov    (%eax),%eax
  802102:	83 e0 fe             	and    $0xfffffffe,%eax
  802105:	8d 50 f8             	lea    -0x8(%eax),%edx
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	01 c2                	add    %eax,%edx
  80210d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802110:	89 02                	mov    %eax,(%edx)
}
  802112:	90                   	nop
  802113:	5d                   	pop    %ebp
  802114:	c3                   	ret    

00802115 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================

void *alloc_block_FF(uint32 size)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 58             	sub    $0x58,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	83 e0 01             	and    $0x1,%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	74 03                	je     802128 <alloc_block_FF+0x13>
  802125:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802128:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  80212c:	77 07                	ja     802135 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80212e:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802135:	a1 24 50 80 00       	mov    0x805024,%eax
  80213a:	85 c0                	test   %eax,%eax
  80213c:	75 73                	jne    8021b1 <alloc_block_FF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	83 c0 10             	add    $0x10,%eax
  802144:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802147:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80214e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802151:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802154:	01 d0                	add    %edx,%eax
  802156:	48                   	dec    %eax
  802157:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80215a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80215d:	ba 00 00 00 00       	mov    $0x0,%edx
  802162:	f7 75 ec             	divl   -0x14(%ebp)
  802165:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802168:	29 d0                	sub    %edx,%eax
  80216a:	c1 e8 0c             	shr    $0xc,%eax
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	50                   	push   %eax
  802171:	e8 27 f0 ff ff       	call   80119d <sbrk>
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80217c:	83 ec 0c             	sub    $0xc,%esp
  80217f:	6a 00                	push   $0x0
  802181:	e8 17 f0 ff ff       	call   80119d <sbrk>
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80218c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80218f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802192:	83 ec 08             	sub    $0x8,%esp
  802195:	50                   	push   %eax
  802196:	ff 75 e4             	pushl  -0x1c(%ebp)
  802199:	e8 5b fd ff ff       	call   801ef9 <initialize_dynamic_allocator>
  80219e:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  8021a1:	83 ec 0c             	sub    $0xc,%esp
  8021a4:	68 7f 44 80 00       	push   $0x80447f
  8021a9:	e8 55 e2 ff ff       	call   800403 <cprintf>
  8021ae:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	 if (size == 0) {
  8021b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b5:	75 0a                	jne    8021c1 <alloc_block_FF+0xac>
	        return NULL;
  8021b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021bc:	e9 0e 04 00 00       	jmp    8025cf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
  8021c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	    LIST_FOREACH(blk, &freeBlocksList) {
  8021c8:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8021cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d0:	e9 f3 02 00 00       	jmp    8024c8 <alloc_block_FF+0x3b3>
	        void *va = (void *)blk;
  8021d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	        uint32 blk_size = get_block_size(va);
  8021db:	83 ec 0c             	sub    $0xc,%esp
  8021de:	ff 75 bc             	pushl  -0x44(%ebp)
  8021e1:	e8 af fb ff ff       	call   801d95 <get_block_size>
  8021e6:	83 c4 10             	add    $0x10,%esp
  8021e9:	89 45 b8             	mov    %eax,-0x48(%ebp)

	        if(blk_size >= size + 2 * sizeof(uint32)) {
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	83 c0 08             	add    $0x8,%eax
  8021f2:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8021f5:	0f 87 c5 02 00 00    	ja     8024c0 <alloc_block_FF+0x3ab>
	            if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	83 c0 18             	add    $0x18,%eax
  802201:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  802204:	0f 87 19 02 00 00    	ja     802423 <alloc_block_FF+0x30e>
	            {

				uint32 remaining_size = blk_size - size - 2 * sizeof(uint32);
  80220a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80220d:	2b 45 08             	sub    0x8(%ebp),%eax
  802210:	83 e8 08             	sub    $0x8,%eax
  802213:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				void *new_block_va = (void *)((char *)va + size + 2 * sizeof(uint32));
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	8d 50 08             	lea    0x8(%eax),%edx
  80221c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80221f:	01 d0                	add    %edx,%eax
  802221:	89 45 b0             	mov    %eax,-0x50(%ebp)
				set_block_data(va, size + 2 * sizeof(uint32), 1);
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	83 c0 08             	add    $0x8,%eax
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	6a 01                	push   $0x1
  80222f:	50                   	push   %eax
  802230:	ff 75 bc             	pushl  -0x44(%ebp)
  802233:	e8 ae fe ff ff       	call   8020e6 <set_block_data>
  802238:	83 c4 10             	add    $0x10,%esp

				if (LIST_PREV(blk)==NULL)
  80223b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223e:	8b 40 04             	mov    0x4(%eax),%eax
  802241:	85 c0                	test   %eax,%eax
  802243:	75 68                	jne    8022ad <alloc_block_FF+0x198>
				{
					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802245:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802249:	75 17                	jne    802262 <alloc_block_FF+0x14d>
  80224b:	83 ec 04             	sub    $0x4,%esp
  80224e:	68 5c 44 80 00       	push   $0x80445c
  802253:	68 d7 00 00 00       	push   $0xd7
  802258:	68 41 44 80 00       	push   $0x804441
  80225d:	e8 57 17 00 00       	call   8039b9 <_panic>
  802262:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802268:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80226b:	89 10                	mov    %edx,(%eax)
  80226d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802270:	8b 00                	mov    (%eax),%eax
  802272:	85 c0                	test   %eax,%eax
  802274:	74 0d                	je     802283 <alloc_block_FF+0x16e>
  802276:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80227b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  80227e:	89 50 04             	mov    %edx,0x4(%eax)
  802281:	eb 08                	jmp    80228b <alloc_block_FF+0x176>
  802283:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802286:	a3 30 50 80 00       	mov    %eax,0x805030
  80228b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80228e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802293:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802296:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80229d:	a1 38 50 80 00       	mov    0x805038,%eax
  8022a2:	40                   	inc    %eax
  8022a3:	a3 38 50 80 00       	mov    %eax,0x805038
  8022a8:	e9 dc 00 00 00       	jmp    802389 <alloc_block_FF+0x274>
				}
				else if (LIST_NEXT(blk)==NULL)
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b0:	8b 00                	mov    (%eax),%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	75 65                	jne    80231b <alloc_block_FF+0x206>
				{
					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8022b6:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  8022ba:	75 17                	jne    8022d3 <alloc_block_FF+0x1be>
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	68 90 44 80 00       	push   $0x804490
  8022c4:	68 db 00 00 00       	push   $0xdb
  8022c9:	68 41 44 80 00       	push   $0x804441
  8022ce:	e8 e6 16 00 00       	call   8039b9 <_panic>
  8022d3:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8022d9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022dc:	89 50 04             	mov    %edx,0x4(%eax)
  8022df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022e2:	8b 40 04             	mov    0x4(%eax),%eax
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	74 0c                	je     8022f5 <alloc_block_FF+0x1e0>
  8022e9:	a1 30 50 80 00       	mov    0x805030,%eax
  8022ee:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8022f1:	89 10                	mov    %edx,(%eax)
  8022f3:	eb 08                	jmp    8022fd <alloc_block_FF+0x1e8>
  8022f5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8022f8:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8022fd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802300:	a3 30 50 80 00       	mov    %eax,0x805030
  802305:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802308:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80230e:	a1 38 50 80 00       	mov    0x805038,%eax
  802313:	40                   	inc    %eax
  802314:	a3 38 50 80 00       	mov    %eax,0x805038
  802319:	eb 6e                	jmp    802389 <alloc_block_FF+0x274>
				}
				else
				{
					LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement*)new_block_va);
  80231b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231f:	74 06                	je     802327 <alloc_block_FF+0x212>
  802321:	83 7d b0 00          	cmpl   $0x0,-0x50(%ebp)
  802325:	75 17                	jne    80233e <alloc_block_FF+0x229>
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	68 b4 44 80 00       	push   $0x8044b4
  80232f:	68 df 00 00 00       	push   $0xdf
  802334:	68 41 44 80 00       	push   $0x804441
  802339:	e8 7b 16 00 00       	call   8039b9 <_panic>
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 10                	mov    (%eax),%edx
  802343:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802346:	89 10                	mov    %edx,(%eax)
  802348:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	74 0b                	je     80235c <alloc_block_FF+0x247>
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802359:	89 50 04             	mov    %edx,0x4(%eax)
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  802362:	89 10                	mov    %edx,(%eax)
  802364:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236a:	89 50 04             	mov    %edx,0x4(%eax)
  80236d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802370:	8b 00                	mov    (%eax),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	75 08                	jne    80237e <alloc_block_FF+0x269>
  802376:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802379:	a3 30 50 80 00       	mov    %eax,0x805030
  80237e:	a1 38 50 80 00       	mov    0x805038,%eax
  802383:	40                   	inc    %eax
  802384:	a3 38 50 80 00       	mov    %eax,0x805038
				}
				LIST_REMOVE(&freeBlocksList, blk);
  802389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238d:	75 17                	jne    8023a6 <alloc_block_FF+0x291>
  80238f:	83 ec 04             	sub    $0x4,%esp
  802392:	68 23 44 80 00       	push   $0x804423
  802397:	68 e1 00 00 00       	push   $0xe1
  80239c:	68 41 44 80 00       	push   $0x804441
  8023a1:	e8 13 16 00 00       	call   8039b9 <_panic>
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 00                	mov    (%eax),%eax
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	74 10                	je     8023bf <alloc_block_FF+0x2aa>
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b7:	8b 52 04             	mov    0x4(%edx),%edx
  8023ba:	89 50 04             	mov    %edx,0x4(%eax)
  8023bd:	eb 0b                	jmp    8023ca <alloc_block_FF+0x2b5>
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 40 04             	mov    0x4(%eax),%eax
  8023c5:	a3 30 50 80 00       	mov    %eax,0x805030
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 40 04             	mov    0x4(%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	74 0f                	je     8023e3 <alloc_block_FF+0x2ce>
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 40 04             	mov    0x4(%eax),%eax
  8023da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023dd:	8b 12                	mov    (%edx),%edx
  8023df:	89 10                	mov    %edx,(%eax)
  8023e1:	eb 0a                	jmp    8023ed <alloc_block_FF+0x2d8>
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
				set_block_data(new_block_va, remaining_size, 0);
  80240b:	83 ec 04             	sub    $0x4,%esp
  80240e:	6a 00                	push   $0x0
  802410:	ff 75 b4             	pushl  -0x4c(%ebp)
  802413:	ff 75 b0             	pushl  -0x50(%ebp)
  802416:	e8 cb fc ff ff       	call   8020e6 <set_block_data>
  80241b:	83 c4 10             	add    $0x10,%esp
  80241e:	e9 95 00 00 00       	jmp    8024b8 <alloc_block_FF+0x3a3>
	            }
	            else
	            {

	            	set_block_data(va, blk_size, 1);
  802423:	83 ec 04             	sub    $0x4,%esp
  802426:	6a 01                	push   $0x1
  802428:	ff 75 b8             	pushl  -0x48(%ebp)
  80242b:	ff 75 bc             	pushl  -0x44(%ebp)
  80242e:	e8 b3 fc ff ff       	call   8020e6 <set_block_data>
  802433:	83 c4 10             	add    $0x10,%esp
	            	LIST_REMOVE(&freeBlocksList,blk);
  802436:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243a:	75 17                	jne    802453 <alloc_block_FF+0x33e>
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	68 23 44 80 00       	push   $0x804423
  802444:	68 e8 00 00 00       	push   $0xe8
  802449:	68 41 44 80 00       	push   $0x804441
  80244e:	e8 66 15 00 00       	call   8039b9 <_panic>
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	85 c0                	test   %eax,%eax
  80245a:	74 10                	je     80246c <alloc_block_FF+0x357>
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 00                	mov    (%eax),%eax
  802461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802464:	8b 52 04             	mov    0x4(%edx),%edx
  802467:	89 50 04             	mov    %edx,0x4(%eax)
  80246a:	eb 0b                	jmp    802477 <alloc_block_FF+0x362>
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 04             	mov    0x4(%eax),%eax
  802472:	a3 30 50 80 00       	mov    %eax,0x805030
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 40 04             	mov    0x4(%eax),%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	74 0f                	je     802490 <alloc_block_FF+0x37b>
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 40 04             	mov    0x4(%eax),%eax
  802487:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248a:	8b 12                	mov    (%edx),%edx
  80248c:	89 10                	mov    %edx,(%eax)
  80248e:	eb 0a                	jmp    80249a <alloc_block_FF+0x385>
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 00                	mov    (%eax),%eax
  802495:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ad:	a1 38 50 80 00       	mov    0x805038,%eax
  8024b2:	48                   	dec    %eax
  8024b3:	a3 38 50 80 00       	mov    %eax,0x805038
	            }
	            return va;
  8024b8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8024bb:	e9 0f 01 00 00       	jmp    8025cf <alloc_block_FF+0x4ba>
	    }
	// cprintf("size is %d \n",size);


	    struct BlockElement *blk = NULL;
	    LIST_FOREACH(blk, &freeBlocksList) {
  8024c0:	a1 34 50 80 00       	mov    0x805034,%eax
  8024c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cc:	74 07                	je     8024d5 <alloc_block_FF+0x3c0>
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 00                	mov    (%eax),%eax
  8024d3:	eb 05                	jmp    8024da <alloc_block_FF+0x3c5>
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024da:	a3 34 50 80 00       	mov    %eax,0x805034
  8024df:	a1 34 50 80 00       	mov    0x805034,%eax
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	0f 85 e9 fc ff ff    	jne    8021d5 <alloc_block_FF+0xc0>
  8024ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f0:	0f 85 df fc ff ff    	jne    8021d5 <alloc_block_FF+0xc0>
	            	LIST_REMOVE(&freeBlocksList,blk);
	            }
	            return va;
	        }
	    }
	    uint32 required_size = size + 2 * sizeof(uint32);
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	83 c0 08             	add    $0x8,%eax
  8024fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  8024ff:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802506:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802509:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80250c:	01 d0                	add    %edx,%eax
  80250e:	48                   	dec    %eax
  80250f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802512:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802515:	ba 00 00 00 00       	mov    $0x0,%edx
  80251a:	f7 75 d8             	divl   -0x28(%ebp)
  80251d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802520:	29 d0                	sub    %edx,%eax
  802522:	c1 e8 0c             	shr    $0xc,%eax
  802525:	83 ec 0c             	sub    $0xc,%esp
  802528:	50                   	push   %eax
  802529:	e8 6f ec ff ff       	call   80119d <sbrk>
  80252e:	83 c4 10             	add    $0x10,%esp
  802531:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (new_mem == (void *)-1) {
  802534:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802538:	75 0a                	jne    802544 <alloc_block_FF+0x42f>
			return NULL; // Allocation failed
  80253a:	b8 00 00 00 00       	mov    $0x0,%eax
  80253f:	e9 8b 00 00 00       	jmp    8025cf <alloc_block_FF+0x4ba>
		}
		else {
			end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802544:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80254b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80254e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802551:	01 d0                	add    %edx,%eax
  802553:	48                   	dec    %eax
  802554:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802557:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80255a:	ba 00 00 00 00       	mov    $0x0,%edx
  80255f:	f7 75 cc             	divl   -0x34(%ebp)
  802562:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802565:	29 d0                	sub    %edx,%eax
  802567:	8d 50 fc             	lea    -0x4(%eax),%edx
  80256a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80256d:	01 d0                	add    %edx,%eax
  80256f:	a3 40 50 80 00       	mov    %eax,0x805040
			end_block->info = 1;
  802574:	a1 40 50 80 00       	mov    0x805040,%eax
  802579:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  80257f:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802586:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802589:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80258c:	01 d0                	add    %edx,%eax
  80258e:	48                   	dec    %eax
  80258f:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802592:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802595:	ba 00 00 00 00       	mov    $0x0,%edx
  80259a:	f7 75 c4             	divl   -0x3c(%ebp)
  80259d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8025a0:	29 d0                	sub    %edx,%eax
  8025a2:	83 ec 04             	sub    $0x4,%esp
  8025a5:	6a 01                	push   $0x1
  8025a7:	50                   	push   %eax
  8025a8:	ff 75 d0             	pushl  -0x30(%ebp)
  8025ab:	e8 36 fb ff ff       	call   8020e6 <set_block_data>
  8025b0:	83 c4 10             	add    $0x10,%esp
		free_block(new_mem);
  8025b3:	83 ec 0c             	sub    $0xc,%esp
  8025b6:	ff 75 d0             	pushl  -0x30(%ebp)
  8025b9:	e8 f8 09 00 00       	call   802fb6 <free_block>
  8025be:	83 c4 10             	add    $0x10,%esp
		return alloc_block_FF(size);
  8025c1:	83 ec 0c             	sub    $0xc,%esp
  8025c4:	ff 75 08             	pushl  0x8(%ebp)
  8025c7:	e8 49 fb ff ff       	call   802115 <alloc_block_FF>
  8025cc:	83 c4 10             	add    $0x10,%esp
		}
		return new_mem;
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	83 ec 68             	sub    $0x68,%esp
	//Your Code is Here...
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	83 e0 01             	and    $0x1,%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 03                	je     8025e4 <alloc_block_BF+0x13>
  8025e1:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8025e4:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8025e8:	77 07                	ja     8025f1 <alloc_block_BF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8025ea:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8025f1:	a1 24 50 80 00       	mov    0x805024,%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	75 73                	jne    80266d <alloc_block_BF+0x9c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	83 c0 10             	add    $0x10,%eax
  802600:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802603:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80260a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80260d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802610:	01 d0                	add    %edx,%eax
  802612:	48                   	dec    %eax
  802613:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802616:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802619:	ba 00 00 00 00       	mov    $0x0,%edx
  80261e:	f7 75 e0             	divl   -0x20(%ebp)
  802621:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802624:	29 d0                	sub    %edx,%eax
  802626:	c1 e8 0c             	shr    $0xc,%eax
  802629:	83 ec 0c             	sub    $0xc,%esp
  80262c:	50                   	push   %eax
  80262d:	e8 6b eb ff ff       	call   80119d <sbrk>
  802632:	83 c4 10             	add    $0x10,%esp
  802635:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802638:	83 ec 0c             	sub    $0xc,%esp
  80263b:	6a 00                	push   $0x0
  80263d:	e8 5b eb ff ff       	call   80119d <sbrk>
  802642:	83 c4 10             	add    $0x10,%esp
  802645:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802648:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80264b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80264e:	83 ec 08             	sub    $0x8,%esp
  802651:	50                   	push   %eax
  802652:	ff 75 d8             	pushl  -0x28(%ebp)
  802655:	e8 9f f8 ff ff       	call   801ef9 <initialize_dynamic_allocator>
  80265a:	83 c4 10             	add    $0x10,%esp
			cprintf("Initialized \n");
  80265d:	83 ec 0c             	sub    $0xc,%esp
  802660:	68 7f 44 80 00       	push   $0x80447f
  802665:	e8 99 dd ff ff       	call   800403 <cprintf>
  80266a:	83 c4 10             	add    $0x10,%esp
		}
	}
	//==================================================================================
	//==================================================================================

	struct BlockElement *blk = NULL;
  80266d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	void *best_va=NULL;
  802674:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
  80267b:	c7 45 ec f8 ef ff ff 	movl   $0xffffeff8,-0x14(%ebp)
	bool internal = 0;
  802682:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(blk, &freeBlocksList) {
  802689:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80268e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802691:	e9 1d 01 00 00       	jmp    8027b3 <alloc_block_BF+0x1e2>
		void *va = (void *)blk;
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	89 45 a8             	mov    %eax,-0x58(%ebp)
		uint32 blk_size = get_block_size(va);
  80269c:	83 ec 0c             	sub    $0xc,%esp
  80269f:	ff 75 a8             	pushl  -0x58(%ebp)
  8026a2:	e8 ee f6 ff ff       	call   801d95 <get_block_size>
  8026a7:	83 c4 10             	add    $0x10,%esp
  8026aa:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (blk_size>=size + 2 * sizeof(uint32))
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	83 c0 08             	add    $0x8,%eax
  8026b3:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026b6:	0f 87 ef 00 00 00    	ja     8027ab <alloc_block_BF+0x1da>
		{
			if (blk_size >= size + DYN_ALLOC_MIN_BLOCK_SIZE + 4 * sizeof(uint32))
  8026bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bf:	83 c0 18             	add    $0x18,%eax
  8026c2:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026c5:	77 1d                	ja     8026e4 <alloc_block_BF+0x113>
			{
				if (best_blk_size > blk_size)
  8026c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ca:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026cd:	0f 86 d8 00 00 00    	jbe    8027ab <alloc_block_BF+0x1da>
				{
					best_va = va;
  8026d3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8026d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					best_blk_size = blk_size;
  8026d9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026df:	e9 c7 00 00 00       	jmp    8027ab <alloc_block_BF+0x1da>
				}
			}
			else
			{
				if (blk_size == size + 2 * sizeof(uint32)){
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	83 c0 08             	add    $0x8,%eax
  8026ea:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8026ed:	0f 85 9d 00 00 00    	jne    802790 <alloc_block_BF+0x1bf>
					set_block_data(va, blk_size, 1);
  8026f3:	83 ec 04             	sub    $0x4,%esp
  8026f6:	6a 01                	push   $0x1
  8026f8:	ff 75 a4             	pushl  -0x5c(%ebp)
  8026fb:	ff 75 a8             	pushl  -0x58(%ebp)
  8026fe:	e8 e3 f9 ff ff       	call   8020e6 <set_block_data>
  802703:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,blk);
  802706:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270a:	75 17                	jne    802723 <alloc_block_BF+0x152>
  80270c:	83 ec 04             	sub    $0x4,%esp
  80270f:	68 23 44 80 00       	push   $0x804423
  802714:	68 2c 01 00 00       	push   $0x12c
  802719:	68 41 44 80 00       	push   $0x804441
  80271e:	e8 96 12 00 00       	call   8039b9 <_panic>
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 00                	mov    (%eax),%eax
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 10                	je     80273c <alloc_block_BF+0x16b>
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 00                	mov    (%eax),%eax
  802731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802734:	8b 52 04             	mov    0x4(%edx),%edx
  802737:	89 50 04             	mov    %edx,0x4(%eax)
  80273a:	eb 0b                	jmp    802747 <alloc_block_BF+0x176>
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	8b 40 04             	mov    0x4(%eax),%eax
  802742:	a3 30 50 80 00       	mov    %eax,0x805030
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 40 04             	mov    0x4(%eax),%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	74 0f                	je     802760 <alloc_block_BF+0x18f>
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 40 04             	mov    0x4(%eax),%eax
  802757:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275a:	8b 12                	mov    (%edx),%edx
  80275c:	89 10                	mov    %edx,(%eax)
  80275e:	eb 0a                	jmp    80276a <alloc_block_BF+0x199>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277d:	a1 38 50 80 00       	mov    0x805038,%eax
  802782:	48                   	dec    %eax
  802783:	a3 38 50 80 00       	mov    %eax,0x805038
					return va;
  802788:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80278b:	e9 01 04 00 00       	jmp    802b91 <alloc_block_BF+0x5c0>
				}
				else
				{
					if (best_blk_size > blk_size)
  802790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802793:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  802796:	76 13                	jbe    8027ab <alloc_block_BF+0x1da>
					{
						internal = 1;
  802798:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
						best_va = va;
  80279f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8027a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						best_blk_size = blk_size;
  8027a5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8027a8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	struct BlockElement *blk = NULL;
	void *best_va=NULL;
	uint32 best_blk_size = (uint32)KERNEL_HEAP_MAX - 2 * sizeof(uint32);
	bool internal = 0;
	LIST_FOREACH(blk, &freeBlocksList) {
  8027ab:	a1 34 50 80 00       	mov    0x805034,%eax
  8027b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b7:	74 07                	je     8027c0 <alloc_block_BF+0x1ef>
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 00                	mov    (%eax),%eax
  8027be:	eb 05                	jmp    8027c5 <alloc_block_BF+0x1f4>
  8027c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c5:	a3 34 50 80 00       	mov    %eax,0x805034
  8027ca:	a1 34 50 80 00       	mov    0x805034,%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	0f 85 bf fe ff ff    	jne    802696 <alloc_block_BF+0xc5>
  8027d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027db:	0f 85 b5 fe ff ff    	jne    802696 <alloc_block_BF+0xc5>
			}
		}

	}

	if (best_va !=NULL && internal ==0){
  8027e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027e5:	0f 84 26 02 00 00    	je     802a11 <alloc_block_BF+0x440>
  8027eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027ef:	0f 85 1c 02 00 00    	jne    802a11 <alloc_block_BF+0x440>
		uint32 remaining_size = best_blk_size - size - 2 * sizeof(uint32);
  8027f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f8:	2b 45 08             	sub    0x8(%ebp),%eax
  8027fb:	83 e8 08             	sub    $0x8,%eax
  8027fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
		void *new_block_va = (void *)((char *)best_va + size + 2 * sizeof(uint32));
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	8d 50 08             	lea    0x8(%eax),%edx
  802807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280a:	01 d0                	add    %edx,%eax
  80280c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		set_block_data(best_va, size + 2 * sizeof(uint32), 1);
  80280f:	8b 45 08             	mov    0x8(%ebp),%eax
  802812:	83 c0 08             	add    $0x8,%eax
  802815:	83 ec 04             	sub    $0x4,%esp
  802818:	6a 01                	push   $0x1
  80281a:	50                   	push   %eax
  80281b:	ff 75 f0             	pushl  -0x10(%ebp)
  80281e:	e8 c3 f8 ff ff       	call   8020e6 <set_block_data>
  802823:	83 c4 10             	add    $0x10,%esp

		if (LIST_PREV((struct BlockElement *)best_va)==NULL)
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	8b 40 04             	mov    0x4(%eax),%eax
  80282c:	85 c0                	test   %eax,%eax
  80282e:	75 68                	jne    802898 <alloc_block_BF+0x2c7>
			{

				LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement*)new_block_va);
  802830:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802834:	75 17                	jne    80284d <alloc_block_BF+0x27c>
  802836:	83 ec 04             	sub    $0x4,%esp
  802839:	68 5c 44 80 00       	push   $0x80445c
  80283e:	68 45 01 00 00       	push   $0x145
  802843:	68 41 44 80 00       	push   $0x804441
  802848:	e8 6c 11 00 00       	call   8039b9 <_panic>
  80284d:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802853:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802856:	89 10                	mov    %edx,(%eax)
  802858:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	74 0d                	je     80286e <alloc_block_BF+0x29d>
  802861:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802869:	89 50 04             	mov    %edx,0x4(%eax)
  80286c:	eb 08                	jmp    802876 <alloc_block_BF+0x2a5>
  80286e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802871:	a3 30 50 80 00       	mov    %eax,0x805030
  802876:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802879:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80287e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802881:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802888:	a1 38 50 80 00       	mov    0x805038,%eax
  80288d:	40                   	inc    %eax
  80288e:	a3 38 50 80 00       	mov    %eax,0x805038
  802893:	e9 dc 00 00 00       	jmp    802974 <alloc_block_BF+0x3a3>
			}
			else if (LIST_NEXT((struct BlockElement *)best_va)==NULL)
  802898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	75 65                	jne    802906 <alloc_block_BF+0x335>
			{

				LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement*)new_block_va);
  8028a1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  8028a5:	75 17                	jne    8028be <alloc_block_BF+0x2ed>
  8028a7:	83 ec 04             	sub    $0x4,%esp
  8028aa:	68 90 44 80 00       	push   $0x804490
  8028af:	68 4a 01 00 00       	push   $0x14a
  8028b4:	68 41 44 80 00       	push   $0x804441
  8028b9:	e8 fb 10 00 00       	call   8039b9 <_panic>
  8028be:	8b 15 30 50 80 00    	mov    0x805030,%edx
  8028c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028c7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ca:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028cd:	8b 40 04             	mov    0x4(%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 0c                	je     8028e0 <alloc_block_BF+0x30f>
  8028d4:	a1 30 50 80 00       	mov    0x805030,%eax
  8028d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8028dc:	89 10                	mov    %edx,(%eax)
  8028de:	eb 08                	jmp    8028e8 <alloc_block_BF+0x317>
  8028e0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028e3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8028e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028eb:	a3 30 50 80 00       	mov    %eax,0x805030
  8028f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8028f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f9:	a1 38 50 80 00       	mov    0x805038,%eax
  8028fe:	40                   	inc    %eax
  8028ff:	a3 38 50 80 00       	mov    %eax,0x805038
  802904:	eb 6e                	jmp    802974 <alloc_block_BF+0x3a3>
			}
			else
			{

				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement *)best_va, (struct BlockElement*)new_block_va);
  802906:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80290a:	74 06                	je     802912 <alloc_block_BF+0x341>
  80290c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802910:	75 17                	jne    802929 <alloc_block_BF+0x358>
  802912:	83 ec 04             	sub    $0x4,%esp
  802915:	68 b4 44 80 00       	push   $0x8044b4
  80291a:	68 4f 01 00 00       	push   $0x14f
  80291f:	68 41 44 80 00       	push   $0x804441
  802924:	e8 90 10 00 00       	call   8039b9 <_panic>
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	8b 10                	mov    (%eax),%edx
  80292e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802931:	89 10                	mov    %edx,(%eax)
  802933:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	85 c0                	test   %eax,%eax
  80293a:	74 0b                	je     802947 <alloc_block_BF+0x376>
  80293c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293f:	8b 00                	mov    (%eax),%eax
  802941:	8b 55 cc             	mov    -0x34(%ebp),%edx
  802944:	89 50 04             	mov    %edx,0x4(%eax)
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80294d:	89 10                	mov    %edx,(%eax)
  80294f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802955:	89 50 04             	mov    %edx,0x4(%eax)
  802958:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80295b:	8b 00                	mov    (%eax),%eax
  80295d:	85 c0                	test   %eax,%eax
  80295f:	75 08                	jne    802969 <alloc_block_BF+0x398>
  802961:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802964:	a3 30 50 80 00       	mov    %eax,0x805030
  802969:	a1 38 50 80 00       	mov    0x805038,%eax
  80296e:	40                   	inc    %eax
  80296f:	a3 38 50 80 00       	mov    %eax,0x805038
			}
			LIST_REMOVE(&freeBlocksList, (struct BlockElement *)best_va);
  802974:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802978:	75 17                	jne    802991 <alloc_block_BF+0x3c0>
  80297a:	83 ec 04             	sub    $0x4,%esp
  80297d:	68 23 44 80 00       	push   $0x804423
  802982:	68 51 01 00 00       	push   $0x151
  802987:	68 41 44 80 00       	push   $0x804441
  80298c:	e8 28 10 00 00       	call   8039b9 <_panic>
  802991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802994:	8b 00                	mov    (%eax),%eax
  802996:	85 c0                	test   %eax,%eax
  802998:	74 10                	je     8029aa <alloc_block_BF+0x3d9>
  80299a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029a2:	8b 52 04             	mov    0x4(%edx),%edx
  8029a5:	89 50 04             	mov    %edx,0x4(%eax)
  8029a8:	eb 0b                	jmp    8029b5 <alloc_block_BF+0x3e4>
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	8b 40 04             	mov    0x4(%eax),%eax
  8029b0:	a3 30 50 80 00       	mov    %eax,0x805030
  8029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b8:	8b 40 04             	mov    0x4(%eax),%eax
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	74 0f                	je     8029ce <alloc_block_BF+0x3fd>
  8029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c2:	8b 40 04             	mov    0x4(%eax),%eax
  8029c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029c8:	8b 12                	mov    (%edx),%edx
  8029ca:	89 10                	mov    %edx,(%eax)
  8029cc:	eb 0a                	jmp    8029d8 <alloc_block_BF+0x407>
  8029ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d1:	8b 00                	mov    (%eax),%eax
  8029d3:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8029d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8029f0:	48                   	dec    %eax
  8029f1:	a3 38 50 80 00       	mov    %eax,0x805038
			set_block_data(new_block_va, remaining_size, 0);
  8029f6:	83 ec 04             	sub    $0x4,%esp
  8029f9:	6a 00                	push   $0x0
  8029fb:	ff 75 d0             	pushl  -0x30(%ebp)
  8029fe:	ff 75 cc             	pushl  -0x34(%ebp)
  802a01:	e8 e0 f6 ff ff       	call   8020e6 <set_block_data>
  802a06:	83 c4 10             	add    $0x10,%esp
			return best_va;
  802a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0c:	e9 80 01 00 00       	jmp    802b91 <alloc_block_BF+0x5c0>
	}
	else if(internal == 1)
  802a11:	83 7d e8 01          	cmpl   $0x1,-0x18(%ebp)
  802a15:	0f 85 9d 00 00 00    	jne    802ab8 <alloc_block_BF+0x4e7>
	{
		set_block_data(best_va, best_blk_size, 1);
  802a1b:	83 ec 04             	sub    $0x4,%esp
  802a1e:	6a 01                	push   $0x1
  802a20:	ff 75 ec             	pushl  -0x14(%ebp)
  802a23:	ff 75 f0             	pushl  -0x10(%ebp)
  802a26:	e8 bb f6 ff ff       	call   8020e6 <set_block_data>
  802a2b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&freeBlocksList,(struct BlockElement *)best_va);
  802a2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a32:	75 17                	jne    802a4b <alloc_block_BF+0x47a>
  802a34:	83 ec 04             	sub    $0x4,%esp
  802a37:	68 23 44 80 00       	push   $0x804423
  802a3c:	68 58 01 00 00       	push   $0x158
  802a41:	68 41 44 80 00       	push   $0x804441
  802a46:	e8 6e 0f 00 00       	call   8039b9 <_panic>
  802a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	85 c0                	test   %eax,%eax
  802a52:	74 10                	je     802a64 <alloc_block_BF+0x493>
  802a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a57:	8b 00                	mov    (%eax),%eax
  802a59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a5c:	8b 52 04             	mov    0x4(%edx),%edx
  802a5f:	89 50 04             	mov    %edx,0x4(%eax)
  802a62:	eb 0b                	jmp    802a6f <alloc_block_BF+0x49e>
  802a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a67:	8b 40 04             	mov    0x4(%eax),%eax
  802a6a:	a3 30 50 80 00       	mov    %eax,0x805030
  802a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a72:	8b 40 04             	mov    0x4(%eax),%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	74 0f                	je     802a88 <alloc_block_BF+0x4b7>
  802a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7c:	8b 40 04             	mov    0x4(%eax),%eax
  802a7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a82:	8b 12                	mov    (%edx),%edx
  802a84:	89 10                	mov    %edx,(%eax)
  802a86:	eb 0a                	jmp    802a92 <alloc_block_BF+0x4c1>
  802a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8b:	8b 00                	mov    (%eax),%eax
  802a8d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa5:	a1 38 50 80 00       	mov    0x805038,%eax
  802aaa:	48                   	dec    %eax
  802aab:	a3 38 50 80 00       	mov    %eax,0x805038
		return best_va;
  802ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab3:	e9 d9 00 00 00       	jmp    802b91 <alloc_block_BF+0x5c0>
	}
	uint32 required_size = size + 2 * sizeof(uint32);
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	83 c0 08             	add    $0x8,%eax
  802abe:	89 45 c8             	mov    %eax,-0x38(%ebp)
		    void *new_mem = sbrk(ROUNDUP(required_size, PAGE_SIZE) / PAGE_SIZE);
  802ac1:	c7 45 c4 00 10 00 00 	movl   $0x1000,-0x3c(%ebp)
  802ac8:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802acb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ace:	01 d0                	add    %edx,%eax
  802ad0:	48                   	dec    %eax
  802ad1:	89 45 c0             	mov    %eax,-0x40(%ebp)
  802ad4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  802adc:	f7 75 c4             	divl   -0x3c(%ebp)
  802adf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ae2:	29 d0                	sub    %edx,%eax
  802ae4:	c1 e8 0c             	shr    $0xc,%eax
  802ae7:	83 ec 0c             	sub    $0xc,%esp
  802aea:	50                   	push   %eax
  802aeb:	e8 ad e6 ff ff       	call   80119d <sbrk>
  802af0:	83 c4 10             	add    $0x10,%esp
  802af3:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if (new_mem == (void *)-1) {
  802af6:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
  802afa:	75 0a                	jne    802b06 <alloc_block_BF+0x535>
				return NULL; // Allocation failed
  802afc:	b8 00 00 00 00       	mov    $0x0,%eax
  802b01:	e9 8b 00 00 00       	jmp    802b91 <alloc_block_BF+0x5c0>
			}
			else {
				end_block = (struct Block_Start_End*) (new_mem + ROUNDUP(required_size, PAGE_SIZE)-sizeof(int));
  802b06:	c7 45 b8 00 10 00 00 	movl   $0x1000,-0x48(%ebp)
  802b0d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b10:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802b13:	01 d0                	add    %edx,%eax
  802b15:	48                   	dec    %eax
  802b16:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  802b19:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b1c:	ba 00 00 00 00       	mov    $0x0,%edx
  802b21:	f7 75 b8             	divl   -0x48(%ebp)
  802b24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  802b27:	29 d0                	sub    %edx,%eax
  802b29:	8d 50 fc             	lea    -0x4(%eax),%edx
  802b2c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802b2f:	01 d0                	add    %edx,%eax
  802b31:	a3 40 50 80 00       	mov    %eax,0x805040
				end_block->info = 1;
  802b36:	a1 40 50 80 00       	mov    0x805040,%eax
  802b3b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
				
			
			set_block_data(new_mem, ROUNDUP(required_size, PAGE_SIZE), 1);
  802b41:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802b48:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802b4b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802b4e:	01 d0                	add    %edx,%eax
  802b50:	48                   	dec    %eax
  802b51:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802b54:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b57:	ba 00 00 00 00       	mov    $0x0,%edx
  802b5c:	f7 75 b0             	divl   -0x50(%ebp)
  802b5f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802b62:	29 d0                	sub    %edx,%eax
  802b64:	83 ec 04             	sub    $0x4,%esp
  802b67:	6a 01                	push   $0x1
  802b69:	50                   	push   %eax
  802b6a:	ff 75 bc             	pushl  -0x44(%ebp)
  802b6d:	e8 74 f5 ff ff       	call   8020e6 <set_block_data>
  802b72:	83 c4 10             	add    $0x10,%esp
			free_block(new_mem);
  802b75:	83 ec 0c             	sub    $0xc,%esp
  802b78:	ff 75 bc             	pushl  -0x44(%ebp)
  802b7b:	e8 36 04 00 00       	call   802fb6 <free_block>
  802b80:	83 c4 10             	add    $0x10,%esp
			return alloc_block_BF(size);
  802b83:	83 ec 0c             	sub    $0xc,%esp
  802b86:	ff 75 08             	pushl  0x8(%ebp)
  802b89:	e8 43 fa ff ff       	call   8025d1 <alloc_block_BF>
  802b8e:	83 c4 10             	add    $0x10,%esp
			}
			return new_mem;
}
  802b91:	c9                   	leave  
  802b92:	c3                   	ret    

00802b93 <merging>:

//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void merging(struct BlockElement *prev_block, struct BlockElement *next_block, void* va){
  802b93:	55                   	push   %ebp
  802b94:	89 e5                	mov    %esp,%ebp
  802b96:	53                   	push   %ebx
  802b97:	83 ec 24             	sub    $0x24,%esp
	bool prev_is_free = 0, next_is_free = 0;
  802b9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ba1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	if (prev_block != NULL && (char *)prev_block + get_block_size(prev_block) == (char *)va) {
  802ba8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bac:	74 1e                	je     802bcc <merging+0x39>
  802bae:	ff 75 08             	pushl  0x8(%ebp)
  802bb1:	e8 df f1 ff ff       	call   801d95 <get_block_size>
  802bb6:	83 c4 04             	add    $0x4,%esp
  802bb9:	89 c2                	mov    %eax,%edx
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	01 d0                	add    %edx,%eax
  802bc0:	3b 45 10             	cmp    0x10(%ebp),%eax
  802bc3:	75 07                	jne    802bcc <merging+0x39>
		prev_is_free = 1;
  802bc5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
  802bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802bd0:	74 1e                	je     802bf0 <merging+0x5d>
  802bd2:	ff 75 10             	pushl  0x10(%ebp)
  802bd5:	e8 bb f1 ff ff       	call   801d95 <get_block_size>
  802bda:	83 c4 04             	add    $0x4,%esp
  802bdd:	89 c2                	mov    %eax,%edx
  802bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  802be2:	01 d0                	add    %edx,%eax
  802be4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802be7:	75 07                	jne    802bf0 <merging+0x5d>
		next_is_free = 1;
  802be9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}
	if(prev_is_free && next_is_free)
  802bf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf4:	0f 84 cc 00 00 00    	je     802cc6 <merging+0x133>
  802bfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bfe:	0f 84 c2 00 00 00    	je     802cc6 <merging+0x133>
	{
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
  802c04:	ff 75 08             	pushl  0x8(%ebp)
  802c07:	e8 89 f1 ff ff       	call   801d95 <get_block_size>
  802c0c:	83 c4 04             	add    $0x4,%esp
  802c0f:	89 c3                	mov    %eax,%ebx
  802c11:	ff 75 10             	pushl  0x10(%ebp)
  802c14:	e8 7c f1 ff ff       	call   801d95 <get_block_size>
  802c19:	83 c4 04             	add    $0x4,%esp
  802c1c:	01 c3                	add    %eax,%ebx
  802c1e:	ff 75 0c             	pushl  0xc(%ebp)
  802c21:	e8 6f f1 ff ff       	call   801d95 <get_block_size>
  802c26:	83 c4 04             	add    $0x4,%esp
  802c29:	01 d8                	add    %ebx,%eax
  802c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802c2e:	6a 00                	push   $0x0
  802c30:	ff 75 ec             	pushl  -0x14(%ebp)
  802c33:	ff 75 08             	pushl  0x8(%ebp)
  802c36:	e8 ab f4 ff ff       	call   8020e6 <set_block_data>
  802c3b:	83 c4 0c             	add    $0xc,%esp
		LIST_REMOVE(&freeBlocksList, next_block);
  802c3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c42:	75 17                	jne    802c5b <merging+0xc8>
  802c44:	83 ec 04             	sub    $0x4,%esp
  802c47:	68 23 44 80 00       	push   $0x804423
  802c4c:	68 7d 01 00 00       	push   $0x17d
  802c51:	68 41 44 80 00       	push   $0x804441
  802c56:	e8 5e 0d 00 00       	call   8039b9 <_panic>
  802c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	85 c0                	test   %eax,%eax
  802c62:	74 10                	je     802c74 <merging+0xe1>
  802c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c67:	8b 00                	mov    (%eax),%eax
  802c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c6c:	8b 52 04             	mov    0x4(%edx),%edx
  802c6f:	89 50 04             	mov    %edx,0x4(%eax)
  802c72:	eb 0b                	jmp    802c7f <merging+0xec>
  802c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c77:	8b 40 04             	mov    0x4(%eax),%eax
  802c7a:	a3 30 50 80 00       	mov    %eax,0x805030
  802c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c82:	8b 40 04             	mov    0x4(%eax),%eax
  802c85:	85 c0                	test   %eax,%eax
  802c87:	74 0f                	je     802c98 <merging+0x105>
  802c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c8c:	8b 40 04             	mov    0x4(%eax),%eax
  802c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c92:	8b 12                	mov    (%edx),%edx
  802c94:	89 10                	mov    %edx,(%eax)
  802c96:	eb 0a                	jmp    802ca2 <merging+0x10f>
  802c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ca5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb5:	a1 38 50 80 00       	mov    0x805038,%eax
  802cba:	48                   	dec    %eax
  802cbb:	a3 38 50 80 00       	mov    %eax,0x805038
	}
	if (next_block != NULL && (char *)va + get_block_size(va) == (char *)next_block) {
		next_is_free = 1;
	}
	if(prev_is_free && next_is_free)
	{
  802cc0:	90                   	nop
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802cc1:	e9 ea 02 00 00       	jmp    802fb0 <merging+0x41d>
		//merge - 2 sides
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va) + get_block_size(next_block);
		set_block_data(prev_block, new_block_size, 0);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else if(prev_is_free)
  802cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cca:	74 3b                	je     802d07 <merging+0x174>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
  802ccc:	83 ec 0c             	sub    $0xc,%esp
  802ccf:	ff 75 08             	pushl  0x8(%ebp)
  802cd2:	e8 be f0 ff ff       	call   801d95 <get_block_size>
  802cd7:	83 c4 10             	add    $0x10,%esp
  802cda:	89 c3                	mov    %eax,%ebx
  802cdc:	83 ec 0c             	sub    $0xc,%esp
  802cdf:	ff 75 10             	pushl  0x10(%ebp)
  802ce2:	e8 ae f0 ff ff       	call   801d95 <get_block_size>
  802ce7:	83 c4 10             	add    $0x10,%esp
  802cea:	01 d8                	add    %ebx,%eax
  802cec:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(prev_block, new_block_size, 0);
  802cef:	83 ec 04             	sub    $0x4,%esp
  802cf2:	6a 00                	push   $0x0
  802cf4:	ff 75 e8             	pushl  -0x18(%ebp)
  802cf7:	ff 75 08             	pushl  0x8(%ebp)
  802cfa:	e8 e7 f3 ff ff       	call   8020e6 <set_block_data>
  802cff:	83 c4 10             	add    $0x10,%esp
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802d02:	e9 a9 02 00 00       	jmp    802fb0 <merging+0x41d>
	{
		//merge - left side
		uint32 new_block_size = get_block_size(prev_block) + get_block_size(va);
		set_block_data(prev_block, new_block_size, 0);
	}
	else if(next_is_free)
  802d07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0b:	0f 84 2d 01 00 00    	je     802e3e <merging+0x2ab>
	{
		//merge - right side

		uint32 new_block_size = get_block_size(va) + get_block_size(next_block);
  802d11:	83 ec 0c             	sub    $0xc,%esp
  802d14:	ff 75 10             	pushl  0x10(%ebp)
  802d17:	e8 79 f0 ff ff       	call   801d95 <get_block_size>
  802d1c:	83 c4 10             	add    $0x10,%esp
  802d1f:	89 c3                	mov    %eax,%ebx
  802d21:	83 ec 0c             	sub    $0xc,%esp
  802d24:	ff 75 0c             	pushl  0xc(%ebp)
  802d27:	e8 69 f0 ff ff       	call   801d95 <get_block_size>
  802d2c:	83 c4 10             	add    $0x10,%esp
  802d2f:	01 d8                	add    %ebx,%eax
  802d31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		set_block_data(va, new_block_size, 0);
  802d34:	83 ec 04             	sub    $0x4,%esp
  802d37:	6a 00                	push   $0x0
  802d39:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d3c:	ff 75 10             	pushl  0x10(%ebp)
  802d3f:	e8 a2 f3 ff ff       	call   8020e6 <set_block_data>
  802d44:	83 c4 10             	add    $0x10,%esp

		struct BlockElement *va_block = (struct BlockElement *)va;
  802d47:	8b 45 10             	mov    0x10(%ebp),%eax
  802d4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
  802d4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802d51:	74 06                	je     802d59 <merging+0x1c6>
  802d53:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d57:	75 17                	jne    802d70 <merging+0x1dd>
  802d59:	83 ec 04             	sub    $0x4,%esp
  802d5c:	68 e8 44 80 00       	push   $0x8044e8
  802d61:	68 8d 01 00 00       	push   $0x18d
  802d66:	68 41 44 80 00       	push   $0x804441
  802d6b:	e8 49 0c 00 00       	call   8039b9 <_panic>
  802d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d73:	8b 50 04             	mov    0x4(%eax),%edx
  802d76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d79:	89 50 04             	mov    %edx,0x4(%eax)
  802d7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d82:	89 10                	mov    %edx,(%eax)
  802d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d87:	8b 40 04             	mov    0x4(%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 0d                	je     802d9b <merging+0x208>
  802d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d91:	8b 40 04             	mov    0x4(%eax),%eax
  802d94:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d97:	89 10                	mov    %edx,(%eax)
  802d99:	eb 08                	jmp    802da3 <merging+0x210>
  802d9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9e:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802da9:	89 50 04             	mov    %edx,0x4(%eax)
  802dac:	a1 38 50 80 00       	mov    0x805038,%eax
  802db1:	40                   	inc    %eax
  802db2:	a3 38 50 80 00       	mov    %eax,0x805038
		LIST_REMOVE(&freeBlocksList, next_block);
  802db7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dbb:	75 17                	jne    802dd4 <merging+0x241>
  802dbd:	83 ec 04             	sub    $0x4,%esp
  802dc0:	68 23 44 80 00       	push   $0x804423
  802dc5:	68 8e 01 00 00       	push   $0x18e
  802dca:	68 41 44 80 00       	push   $0x804441
  802dcf:	e8 e5 0b 00 00       	call   8039b9 <_panic>
  802dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 10                	je     802ded <merging+0x25a>
  802ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802de0:	8b 00                	mov    (%eax),%eax
  802de2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802de5:	8b 52 04             	mov    0x4(%edx),%edx
  802de8:	89 50 04             	mov    %edx,0x4(%eax)
  802deb:	eb 0b                	jmp    802df8 <merging+0x265>
  802ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df0:	8b 40 04             	mov    0x4(%eax),%eax
  802df3:	a3 30 50 80 00       	mov    %eax,0x805030
  802df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dfb:	8b 40 04             	mov    0x4(%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 0f                	je     802e11 <merging+0x27e>
  802e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e05:	8b 40 04             	mov    0x4(%eax),%eax
  802e08:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e0b:	8b 12                	mov    (%edx),%edx
  802e0d:	89 10                	mov    %edx,(%eax)
  802e0f:	eb 0a                	jmp    802e1b <merging+0x288>
  802e11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2e:	a1 38 50 80 00       	mov    0x805038,%eax
  802e33:	48                   	dec    %eax
  802e34:	a3 38 50 80 00       	mov    %eax,0x805038
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
		}
		set_block_data(va, get_block_size(va), 0);
	}
}
  802e39:	e9 72 01 00 00       	jmp    802fb0 <merging+0x41d>
		LIST_INSERT_BEFORE(&freeBlocksList, next_block, va_block);
		LIST_REMOVE(&freeBlocksList, next_block);
	}
	else
	{
		struct BlockElement *va_block = (struct BlockElement *)va;
  802e3e:	8b 45 10             	mov    0x10(%ebp),%eax
  802e41:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(prev_block != NULL && next_block != NULL) LIST_INSERT_AFTER(&freeBlocksList, prev_block, va_block);
  802e44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e48:	74 79                	je     802ec3 <merging+0x330>
  802e4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e4e:	74 73                	je     802ec3 <merging+0x330>
  802e50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e54:	74 06                	je     802e5c <merging+0x2c9>
  802e56:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e5a:	75 17                	jne    802e73 <merging+0x2e0>
  802e5c:	83 ec 04             	sub    $0x4,%esp
  802e5f:	68 b4 44 80 00       	push   $0x8044b4
  802e64:	68 94 01 00 00       	push   $0x194
  802e69:	68 41 44 80 00       	push   $0x804441
  802e6e:	e8 46 0b 00 00       	call   8039b9 <_panic>
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	8b 10                	mov    (%eax),%edx
  802e78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e7b:	89 10                	mov    %edx,(%eax)
  802e7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 0b                	je     802e91 <merging+0x2fe>
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e8e:	89 50 04             	mov    %edx,0x4(%eax)
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802e97:	89 10                	mov    %edx,(%eax)
  802e99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ea2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	75 08                	jne    802eb3 <merging+0x320>
  802eab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eae:	a3 30 50 80 00       	mov    %eax,0x805030
  802eb3:	a1 38 50 80 00       	mov    0x805038,%eax
  802eb8:	40                   	inc    %eax
  802eb9:	a3 38 50 80 00       	mov    %eax,0x805038
  802ebe:	e9 ce 00 00 00       	jmp    802f91 <merging+0x3fe>
		else if(prev_block != NULL) LIST_INSERT_TAIL(&freeBlocksList, va_block);
  802ec3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec7:	74 65                	je     802f2e <merging+0x39b>
  802ec9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802ecd:	75 17                	jne    802ee6 <merging+0x353>
  802ecf:	83 ec 04             	sub    $0x4,%esp
  802ed2:	68 90 44 80 00       	push   $0x804490
  802ed7:	68 95 01 00 00       	push   $0x195
  802edc:	68 41 44 80 00       	push   $0x804441
  802ee1:	e8 d3 0a 00 00       	call   8039b9 <_panic>
  802ee6:	8b 15 30 50 80 00    	mov    0x805030,%edx
  802eec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eef:	89 50 04             	mov    %edx,0x4(%eax)
  802ef2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	85 c0                	test   %eax,%eax
  802efa:	74 0c                	je     802f08 <merging+0x375>
  802efc:	a1 30 50 80 00       	mov    0x805030,%eax
  802f01:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f04:	89 10                	mov    %edx,(%eax)
  802f06:	eb 08                	jmp    802f10 <merging+0x37d>
  802f08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0b:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f10:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f13:	a3 30 50 80 00       	mov    %eax,0x805030
  802f18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f21:	a1 38 50 80 00       	mov    0x805038,%eax
  802f26:	40                   	inc    %eax
  802f27:	a3 38 50 80 00       	mov    %eax,0x805038
  802f2c:	eb 63                	jmp    802f91 <merging+0x3fe>
		else
		{
			LIST_INSERT_HEAD(&freeBlocksList, va_block);
  802f2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802f32:	75 17                	jne    802f4b <merging+0x3b8>
  802f34:	83 ec 04             	sub    $0x4,%esp
  802f37:	68 5c 44 80 00       	push   $0x80445c
  802f3c:	68 98 01 00 00       	push   $0x198
  802f41:	68 41 44 80 00       	push   $0x804441
  802f46:	e8 6e 0a 00 00       	call   8039b9 <_panic>
  802f4b:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  802f51:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f54:	89 10                	mov    %edx,(%eax)
  802f56:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	74 0d                	je     802f6c <merging+0x3d9>
  802f5f:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f64:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f67:	89 50 04             	mov    %edx,0x4(%eax)
  802f6a:	eb 08                	jmp    802f74 <merging+0x3e1>
  802f6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f6f:	a3 30 50 80 00       	mov    %eax,0x805030
  802f74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f77:	a3 2c 50 80 00       	mov    %eax,0x80502c
  802f7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f86:	a1 38 50 80 00       	mov    0x805038,%eax
  802f8b:	40                   	inc    %eax
  802f8c:	a3 38 50 80 00       	mov    %eax,0x805038
		}
		set_block_data(va, get_block_size(va), 0);
  802f91:	83 ec 0c             	sub    $0xc,%esp
  802f94:	ff 75 10             	pushl  0x10(%ebp)
  802f97:	e8 f9 ed ff ff       	call   801d95 <get_block_size>
  802f9c:	83 c4 10             	add    $0x10,%esp
  802f9f:	83 ec 04             	sub    $0x4,%esp
  802fa2:	6a 00                	push   $0x0
  802fa4:	50                   	push   %eax
  802fa5:	ff 75 10             	pushl  0x10(%ebp)
  802fa8:	e8 39 f1 ff ff       	call   8020e6 <set_block_data>
  802fad:	83 c4 10             	add    $0x10,%esp
	}
}
  802fb0:	90                   	nop
  802fb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fb4:	c9                   	leave  
  802fb5:	c3                   	ret    

00802fb6 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802fb6:	55                   	push   %ebp
  802fb7:	89 e5                	mov    %esp,%ebp
  802fb9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);
  802fbc:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
  802fc4:	a1 30 50 80 00       	mov    0x805030,%eax
  802fc9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fcc:	73 1b                	jae    802fe9 <free_block+0x33>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
  802fce:	a1 30 50 80 00       	mov    0x805030,%eax
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	ff 75 08             	pushl  0x8(%ebp)
  802fd9:	6a 00                	push   $0x0
  802fdb:	50                   	push   %eax
  802fdc:	e8 b2 fb ff ff       	call   802b93 <merging>
  802fe1:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  802fe4:	e9 8b 00 00 00       	jmp    803074 <free_block+0xbe>
	struct BlockElement *prev_block = LIST_FIRST(&freeBlocksList);

	if((char *)LIST_LAST(&freeBlocksList) < (char *)va){
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
  802fe9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ff1:	76 18                	jbe    80300b <free_block+0x55>
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
  802ff3:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802ff8:	83 ec 04             	sub    $0x4,%esp
  802ffb:	ff 75 08             	pushl  0x8(%ebp)
  802ffe:	50                   	push   %eax
  802fff:	6a 00                	push   $0x0
  803001:	e8 8d fb ff ff       	call   802b93 <merging>
  803006:	83 c4 10             	add    $0x10,%esp
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803009:	eb 69                	jmp    803074 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  80300b:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803013:	eb 39                	jmp    80304e <free_block+0x98>
		if((uint32 *)prev_block < (uint32 *)va && (uint32 *)prev_block->prev_next_info.le_next > (uint32 *)va ){
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301b:	73 29                	jae    803046 <free_block+0x90>
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	3b 45 08             	cmp    0x8(%ebp),%eax
  803025:	76 1f                	jbe    803046 <free_block+0x90>
			//get the address of prev and next
			struct BlockElement *next_block = LIST_NEXT(prev_block);
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			merging(prev_block, next_block, va);
  80302f:	83 ec 04             	sub    $0x4,%esp
  803032:	ff 75 08             	pushl  0x8(%ebp)
  803035:	ff 75 f0             	pushl  -0x10(%ebp)
  803038:	ff 75 f4             	pushl  -0xc(%ebp)
  80303b:	e8 53 fb ff ff       	call   802b93 <merging>
  803040:	83 c4 10             	add    $0x10,%esp
			break;
  803043:	90                   	nop
		}
	}
}
  803044:	eb 2e                	jmp    803074 <free_block+0xbe>
		merging(LIST_LAST(&freeBlocksList), NULL, va);
	}
	else if((char *)LIST_FIRST(&freeBlocksList) > (char *)va) {
		merging(NULL, LIST_FIRST(&freeBlocksList),va);
	}
	else LIST_FOREACH (prev_block, &freeBlocksList){
  803046:	a1 34 50 80 00       	mov    0x805034,%eax
  80304b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803052:	74 07                	je     80305b <free_block+0xa5>
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	eb 05                	jmp    803060 <free_block+0xaa>
  80305b:	b8 00 00 00 00       	mov    $0x0,%eax
  803060:	a3 34 50 80 00       	mov    %eax,0x805034
  803065:	a1 34 50 80 00       	mov    0x805034,%eax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	75 a7                	jne    803015 <free_block+0x5f>
  80306e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803072:	75 a1                	jne    803015 <free_block+0x5f>
			struct BlockElement *next_block = LIST_NEXT(prev_block);
			merging(prev_block, next_block, va);
			break;
		}
	}
}
  803074:	90                   	nop
  803075:	c9                   	leave  
  803076:	c3                   	ret    

00803077 <copy_data>:

//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void copy_data(void *va, void *new_va)
{
  803077:	55                   	push   %ebp
  803078:	89 e5                	mov    %esp,%ebp
  80307a:	83 ec 10             	sub    $0x10,%esp
	uint32 va_size = get_block_size(va);
  80307d:	ff 75 08             	pushl  0x8(%ebp)
  803080:	e8 10 ed ff ff       	call   801d95 <get_block_size>
  803085:	83 c4 04             	add    $0x4,%esp
  803088:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for(int i = 0; i < va_size; i++) *((char *)new_va + i) = *((char *)va + i);
  80308b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  803092:	eb 17                	jmp    8030ab <copy_data+0x34>
  803094:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309a:	01 c2                	add    %eax,%edx
  80309c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	01 c8                	add    %ecx,%eax
  8030a4:	8a 00                	mov    (%eax),%al
  8030a6:	88 02                	mov    %al,(%edx)
  8030a8:	ff 45 fc             	incl   -0x4(%ebp)
  8030ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8030b1:	72 e1                	jb     803094 <copy_data+0x1d>
}
  8030b3:	90                   	nop
  8030b4:	c9                   	leave  
  8030b5:	c3                   	ret    

008030b6 <realloc_block_FF>:

void *realloc_block_FF(void* va, uint32 new_size)
{
  8030b6:	55                   	push   %ebp
  8030b7:	89 e5                	mov    %esp,%ebp
  8030b9:	83 ec 58             	sub    $0x58,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...


	if(va == NULL)
  8030bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c0:	75 23                	jne    8030e5 <realloc_block_FF+0x2f>
	{
		if(new_size != 0) return alloc_block_FF(new_size);
  8030c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030c6:	74 13                	je     8030db <realloc_block_FF+0x25>
  8030c8:	83 ec 0c             	sub    $0xc,%esp
  8030cb:	ff 75 0c             	pushl  0xc(%ebp)
  8030ce:	e8 42 f0 ff ff       	call   802115 <alloc_block_FF>
  8030d3:	83 c4 10             	add    $0x10,%esp
  8030d6:	e9 e4 06 00 00       	jmp    8037bf <realloc_block_FF+0x709>
		return NULL;
  8030db:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e0:	e9 da 06 00 00       	jmp    8037bf <realloc_block_FF+0x709>
	}

	if(new_size == 0)
  8030e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8030e9:	75 18                	jne    803103 <realloc_block_FF+0x4d>
	{
		free_block(va);
  8030eb:	83 ec 0c             	sub    $0xc,%esp
  8030ee:	ff 75 08             	pushl  0x8(%ebp)
  8030f1:	e8 c0 fe ff ff       	call   802fb6 <free_block>
  8030f6:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8030f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fe:	e9 bc 06 00 00       	jmp    8037bf <realloc_block_FF+0x709>
	}


	if(new_size < 8) new_size = 8;
  803103:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803107:	77 07                	ja     803110 <realloc_block_FF+0x5a>
  803109:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	new_size += (new_size % 2);
  803110:	8b 45 0c             	mov    0xc(%ebp),%eax
  803113:	83 e0 01             	and    $0x1,%eax
  803116:	01 45 0c             	add    %eax,0xc(%ebp)

	//cur Block data
	uint32 newBLOCK_size = new_size + 8;
  803119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80311c:	83 c0 08             	add    $0x8,%eax
  80311f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 curBLOCK_size = get_block_size(va) /*BLOCK size in Bytes*/;
  803122:	83 ec 0c             	sub    $0xc,%esp
  803125:	ff 75 08             	pushl  0x8(%ebp)
  803128:	e8 68 ec ff ff       	call   801d95 <get_block_size>
  80312d:	83 c4 10             	add    $0x10,%esp
  803130:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 cur_size = curBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803133:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803136:	83 e8 08             	sub    $0x8,%eax
  803139:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//next Block data
	void *next_va = (void *)(FOOTER(va) + 2);
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	83 e8 04             	sub    $0x4,%eax
  803142:	8b 00                	mov    (%eax),%eax
  803144:	83 e0 fe             	and    $0xfffffffe,%eax
  803147:	89 c2                	mov    %eax,%edx
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	01 d0                	add    %edx,%eax
  80314e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32 nextBLOCK_size = get_block_size(next_va)/*&is_free_block(next_block_va)*/; //=0 if not free
  803151:	83 ec 0c             	sub    $0xc,%esp
  803154:	ff 75 e4             	pushl  -0x1c(%ebp)
  803157:	e8 39 ec ff ff       	call   801d95 <get_block_size>
  80315c:	83 c4 10             	add    $0x10,%esp
  80315f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 next_cur_size = nextBLOCK_size - 8 /*8 Bytes = (Header + Footer) size*/;
  803162:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803165:	83 e8 08             	sub    $0x8,%eax
  803168:	89 45 dc             	mov    %eax,-0x24(%ebp)


	//if the user needs the same size he owns
	if(new_size == cur_size)
  80316b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803171:	75 08                	jne    80317b <realloc_block_FF+0xc5>
	{
		 return va;
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	e9 44 06 00 00       	jmp    8037bf <realloc_block_FF+0x709>

	}


	if(new_size < cur_size)
  80317b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80317e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803181:	0f 83 d5 03 00 00    	jae    80355c <realloc_block_FF+0x4a6>
	{
		uint32 remaining_size = cur_size - new_size; //remaining size in single Bytes
  803187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80318d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(is_free_block(next_va))
  803190:	83 ec 0c             	sub    $0xc,%esp
  803193:	ff 75 e4             	pushl  -0x1c(%ebp)
  803196:	e8 13 ec ff ff       	call   801dae <is_free_block>
  80319b:	83 c4 10             	add    $0x10,%esp
  80319e:	84 c0                	test   %al,%al
  8031a0:	0f 84 3b 01 00 00    	je     8032e1 <realloc_block_FF+0x22b>
		{

			uint32 next_newBLOCK_size = nextBLOCK_size + remaining_size;
  8031a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031ac:	01 d0                	add    %edx,%eax
  8031ae:	89 45 cc             	mov    %eax,-0x34(%ebp)
			set_block_data(va, newBLOCK_size, 1);
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	6a 01                	push   $0x1
  8031b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8031b9:	ff 75 08             	pushl  0x8(%ebp)
  8031bc:	e8 25 ef ff ff       	call   8020e6 <set_block_data>
  8031c1:	83 c4 10             	add    $0x10,%esp
			void *next_new_va = (void *)(FOOTER(va) + 2);
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	83 e8 04             	sub    $0x4,%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	83 e0 fe             	and    $0xfffffffe,%eax
  8031cf:	89 c2                	mov    %eax,%edx
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	01 d0                	add    %edx,%eax
  8031d6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			set_block_data(next_new_va, next_newBLOCK_size, 0);
  8031d9:	83 ec 04             	sub    $0x4,%esp
  8031dc:	6a 00                	push   $0x0
  8031de:	ff 75 cc             	pushl  -0x34(%ebp)
  8031e1:	ff 75 c8             	pushl  -0x38(%ebp)
  8031e4:	e8 fd ee ff ff       	call   8020e6 <set_block_data>
  8031e9:	83 c4 10             	add    $0x10,%esp
			LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8031ec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031f0:	74 06                	je     8031f8 <realloc_block_FF+0x142>
  8031f2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8031f6:	75 17                	jne    80320f <realloc_block_FF+0x159>
  8031f8:	83 ec 04             	sub    $0x4,%esp
  8031fb:	68 b4 44 80 00       	push   $0x8044b4
  803200:	68 f6 01 00 00       	push   $0x1f6
  803205:	68 41 44 80 00       	push   $0x804441
  80320a:	e8 aa 07 00 00       	call   8039b9 <_panic>
  80320f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803212:	8b 10                	mov    (%eax),%edx
  803214:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803217:	89 10                	mov    %edx,(%eax)
  803219:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	85 c0                	test   %eax,%eax
  803220:	74 0b                	je     80322d <realloc_block_FF+0x177>
  803222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803225:	8b 00                	mov    (%eax),%eax
  803227:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80322a:	89 50 04             	mov    %edx,0x4(%eax)
  80322d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803230:	8b 55 c8             	mov    -0x38(%ebp),%edx
  803233:	89 10                	mov    %edx,(%eax)
  803235:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803238:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80323b:	89 50 04             	mov    %edx,0x4(%eax)
  80323e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	85 c0                	test   %eax,%eax
  803245:	75 08                	jne    80324f <realloc_block_FF+0x199>
  803247:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80324a:	a3 30 50 80 00       	mov    %eax,0x805030
  80324f:	a1 38 50 80 00       	mov    0x805038,%eax
  803254:	40                   	inc    %eax
  803255:	a3 38 50 80 00       	mov    %eax,0x805038
			LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80325a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80325e:	75 17                	jne    803277 <realloc_block_FF+0x1c1>
  803260:	83 ec 04             	sub    $0x4,%esp
  803263:	68 23 44 80 00       	push   $0x804423
  803268:	68 f7 01 00 00       	push   $0x1f7
  80326d:	68 41 44 80 00       	push   $0x804441
  803272:	e8 42 07 00 00       	call   8039b9 <_panic>
  803277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	74 10                	je     803290 <realloc_block_FF+0x1da>
  803280:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803283:	8b 00                	mov    (%eax),%eax
  803285:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803288:	8b 52 04             	mov    0x4(%edx),%edx
  80328b:	89 50 04             	mov    %edx,0x4(%eax)
  80328e:	eb 0b                	jmp    80329b <realloc_block_FF+0x1e5>
  803290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803293:	8b 40 04             	mov    0x4(%eax),%eax
  803296:	a3 30 50 80 00       	mov    %eax,0x805030
  80329b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329e:	8b 40 04             	mov    0x4(%eax),%eax
  8032a1:	85 c0                	test   %eax,%eax
  8032a3:	74 0f                	je     8032b4 <realloc_block_FF+0x1fe>
  8032a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a8:	8b 40 04             	mov    0x4(%eax),%eax
  8032ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032ae:	8b 12                	mov    (%edx),%edx
  8032b0:	89 10                	mov    %edx,(%eax)
  8032b2:	eb 0a                	jmp    8032be <realloc_block_FF+0x208>
  8032b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8032be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d1:	a1 38 50 80 00       	mov    0x805038,%eax
  8032d6:	48                   	dec    %eax
  8032d7:	a3 38 50 80 00       	mov    %eax,0x805038
  8032dc:	e9 73 02 00 00       	jmp    803554 <realloc_block_FF+0x49e>
		}
		else
		{
			if(remaining_size>=16)
  8032e1:	83 7d d8 0f          	cmpl   $0xf,-0x28(%ebp)
  8032e5:	0f 86 69 02 00 00    	jbe    803554 <realloc_block_FF+0x49e>
			{
				//uint32 next_new_size = remaining_size - 8;/*+ next_cur_size&is_free_block(next_cur_va)*/
				set_block_data(va, newBLOCK_size, 1);
  8032eb:	83 ec 04             	sub    $0x4,%esp
  8032ee:	6a 01                	push   $0x1
  8032f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8032f3:	ff 75 08             	pushl  0x8(%ebp)
  8032f6:	e8 eb ed ff ff       	call   8020e6 <set_block_data>
  8032fb:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	83 e8 04             	sub    $0x4,%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	83 e0 fe             	and    $0xfffffffe,%eax
  803309:	89 c2                	mov    %eax,%edx
  80330b:	8b 45 08             	mov    0x8(%ebp),%eax
  80330e:	01 d0                	add    %edx,%eax
  803310:	89 45 d4             	mov    %eax,-0x2c(%ebp)

				//insert new block to free_block_list
				uint32 list_size = LIST_SIZE(&freeBlocksList);
  803313:	a1 38 50 80 00       	mov    0x805038,%eax
  803318:	89 45 d0             	mov    %eax,-0x30(%ebp)
				if(list_size == 0)
  80331b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80331f:	75 68                	jne    803389 <realloc_block_FF+0x2d3>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803321:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803325:	75 17                	jne    80333e <realloc_block_FF+0x288>
  803327:	83 ec 04             	sub    $0x4,%esp
  80332a:	68 5c 44 80 00       	push   $0x80445c
  80332f:	68 06 02 00 00       	push   $0x206
  803334:	68 41 44 80 00       	push   $0x804441
  803339:	e8 7b 06 00 00       	call   8039b9 <_panic>
  80333e:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  803344:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803347:	89 10                	mov    %edx,(%eax)
  803349:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80334c:	8b 00                	mov    (%eax),%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	74 0d                	je     80335f <realloc_block_FF+0x2a9>
  803352:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803357:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80335a:	89 50 04             	mov    %edx,0x4(%eax)
  80335d:	eb 08                	jmp    803367 <realloc_block_FF+0x2b1>
  80335f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803362:	a3 30 50 80 00       	mov    %eax,0x805030
  803367:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80336a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80336f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803372:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803379:	a1 38 50 80 00       	mov    0x805038,%eax
  80337e:	40                   	inc    %eax
  80337f:	a3 38 50 80 00       	mov    %eax,0x805038
  803384:	e9 b0 01 00 00       	jmp    803539 <realloc_block_FF+0x483>
				}
				else if((struct BlockElement *)next_new_va < LIST_FIRST(&freeBlocksList))
  803389:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80338e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803391:	76 68                	jbe    8033fb <realloc_block_FF+0x345>
				{

					LIST_INSERT_HEAD(&freeBlocksList, (struct BlockElement *)next_new_va);
  803393:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803397:	75 17                	jne    8033b0 <realloc_block_FF+0x2fa>
  803399:	83 ec 04             	sub    $0x4,%esp
  80339c:	68 5c 44 80 00       	push   $0x80445c
  8033a1:	68 0b 02 00 00       	push   $0x20b
  8033a6:	68 41 44 80 00       	push   $0x804441
  8033ab:	e8 09 06 00 00       	call   8039b9 <_panic>
  8033b0:	8b 15 2c 50 80 00    	mov    0x80502c,%edx
  8033b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b9:	89 10                	mov    %edx,(%eax)
  8033bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033be:	8b 00                	mov    (%eax),%eax
  8033c0:	85 c0                	test   %eax,%eax
  8033c2:	74 0d                	je     8033d1 <realloc_block_FF+0x31b>
  8033c4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  8033c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033cc:	89 50 04             	mov    %edx,0x4(%eax)
  8033cf:	eb 08                	jmp    8033d9 <realloc_block_FF+0x323>
  8033d1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033d4:	a3 30 50 80 00       	mov    %eax,0x805030
  8033d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033dc:	a3 2c 50 80 00       	mov    %eax,0x80502c
  8033e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033eb:	a1 38 50 80 00       	mov    0x805038,%eax
  8033f0:	40                   	inc    %eax
  8033f1:	a3 38 50 80 00       	mov    %eax,0x805038
  8033f6:	e9 3e 01 00 00       	jmp    803539 <realloc_block_FF+0x483>
				}
				else if(LIST_FIRST(&freeBlocksList) < (struct BlockElement *)next_new_va)
  8033fb:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803400:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803403:	73 68                	jae    80346d <realloc_block_FF+0x3b7>
				{

					LIST_INSERT_TAIL(&freeBlocksList, (struct BlockElement *)next_new_va);
  803405:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803409:	75 17                	jne    803422 <realloc_block_FF+0x36c>
  80340b:	83 ec 04             	sub    $0x4,%esp
  80340e:	68 90 44 80 00       	push   $0x804490
  803413:	68 10 02 00 00       	push   $0x210
  803418:	68 41 44 80 00       	push   $0x804441
  80341d:	e8 97 05 00 00       	call   8039b9 <_panic>
  803422:	8b 15 30 50 80 00    	mov    0x805030,%edx
  803428:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80342b:	89 50 04             	mov    %edx,0x4(%eax)
  80342e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803431:	8b 40 04             	mov    0x4(%eax),%eax
  803434:	85 c0                	test   %eax,%eax
  803436:	74 0c                	je     803444 <realloc_block_FF+0x38e>
  803438:	a1 30 50 80 00       	mov    0x805030,%eax
  80343d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803440:	89 10                	mov    %edx,(%eax)
  803442:	eb 08                	jmp    80344c <realloc_block_FF+0x396>
  803444:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803447:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80344c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80344f:	a3 30 50 80 00       	mov    %eax,0x805030
  803454:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803457:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80345d:	a1 38 50 80 00       	mov    0x805038,%eax
  803462:	40                   	inc    %eax
  803463:	a3 38 50 80 00       	mov    %eax,0x805038
  803468:	e9 cc 00 00 00       	jmp    803539 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
  80346d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
					LIST_FOREACH(blk, &freeBlocksList)
  803474:	a1 2c 50 80 00       	mov    0x80502c,%eax
  803479:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80347c:	e9 8a 00 00 00       	jmp    80350b <realloc_block_FF+0x455>
					{
						if(blk < (struct BlockElement *)next_new_va && LIST_NEXT(blk) < (struct BlockElement *)next_new_va)
  803481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803484:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803487:	73 7a                	jae    803503 <realloc_block_FF+0x44d>
  803489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  803491:	73 70                	jae    803503 <realloc_block_FF+0x44d>
						{
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
  803493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803497:	74 06                	je     80349f <realloc_block_FF+0x3e9>
  803499:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80349d:	75 17                	jne    8034b6 <realloc_block_FF+0x400>
  80349f:	83 ec 04             	sub    $0x4,%esp
  8034a2:	68 b4 44 80 00       	push   $0x8044b4
  8034a7:	68 1a 02 00 00       	push   $0x21a
  8034ac:	68 41 44 80 00       	push   $0x804441
  8034b1:	e8 03 05 00 00       	call   8039b9 <_panic>
  8034b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b9:	8b 10                	mov    (%eax),%edx
  8034bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034be:	89 10                	mov    %edx,(%eax)
  8034c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034c3:	8b 00                	mov    (%eax),%eax
  8034c5:	85 c0                	test   %eax,%eax
  8034c7:	74 0b                	je     8034d4 <realloc_block_FF+0x41e>
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 00                	mov    (%eax),%eax
  8034ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034d1:	89 50 04             	mov    %edx,0x4(%eax)
  8034d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8034da:	89 10                	mov    %edx,(%eax)
  8034dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e2:	89 50 04             	mov    %edx,0x4(%eax)
  8034e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	75 08                	jne    8034f6 <realloc_block_FF+0x440>
  8034ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034f1:	a3 30 50 80 00       	mov    %eax,0x805030
  8034f6:	a1 38 50 80 00       	mov    0x805038,%eax
  8034fb:	40                   	inc    %eax
  8034fc:	a3 38 50 80 00       	mov    %eax,0x805038
							break;
  803501:	eb 36                	jmp    803539 <realloc_block_FF+0x483>
				}
				else
				{

					struct BlockElement *blk = NULL;
					LIST_FOREACH(blk, &freeBlocksList)
  803503:	a1 34 50 80 00       	mov    0x805034,%eax
  803508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80350b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80350f:	74 07                	je     803518 <realloc_block_FF+0x462>
  803511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803514:	8b 00                	mov    (%eax),%eax
  803516:	eb 05                	jmp    80351d <realloc_block_FF+0x467>
  803518:	b8 00 00 00 00       	mov    $0x0,%eax
  80351d:	a3 34 50 80 00       	mov    %eax,0x805034
  803522:	a1 34 50 80 00       	mov    0x805034,%eax
  803527:	85 c0                	test   %eax,%eax
  803529:	0f 85 52 ff ff ff    	jne    803481 <realloc_block_FF+0x3cb>
  80352f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803533:	0f 85 48 ff ff ff    	jne    803481 <realloc_block_FF+0x3cb>
							LIST_INSERT_AFTER(&freeBlocksList, blk, (struct BlockElement *)next_new_va);
							break;
						}
					}
				}
				set_block_data(next_new_va, remaining_size, 0);
  803539:	83 ec 04             	sub    $0x4,%esp
  80353c:	6a 00                	push   $0x0
  80353e:	ff 75 d8             	pushl  -0x28(%ebp)
  803541:	ff 75 d4             	pushl  -0x2c(%ebp)
  803544:	e8 9d eb ff ff       	call   8020e6 <set_block_data>
  803549:	83 c4 10             	add    $0x10,%esp
				return va;
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	e9 6b 02 00 00       	jmp    8037bf <realloc_block_FF+0x709>
			}
			
		}
		return va;
  803554:	8b 45 08             	mov    0x8(%ebp),%eax
  803557:	e9 63 02 00 00       	jmp    8037bf <realloc_block_FF+0x709>
	}

	if(new_size > cur_size)
  80355c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80355f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803562:	0f 86 4d 02 00 00    	jbe    8037b5 <realloc_block_FF+0x6ff>
	{
		if(is_free_block(next_va))
  803568:	83 ec 0c             	sub    $0xc,%esp
  80356b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80356e:	e8 3b e8 ff ff       	call   801dae <is_free_block>
  803573:	83 c4 10             	add    $0x10,%esp
  803576:	84 c0                	test   %al,%al
  803578:	0f 84 37 02 00 00    	je     8037b5 <realloc_block_FF+0x6ff>
		{

			uint32 needed_size = new_size - cur_size; //needed size in single Bytes
  80357e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803581:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803584:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if(needed_size > nextBLOCK_size)
  803587:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80358a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80358d:	76 38                	jbe    8035c7 <realloc_block_FF+0x511>
			{
				void *new_va = alloc_block_FF(new_size); //new allocation
  80358f:	83 ec 0c             	sub    $0xc,%esp
  803592:	ff 75 0c             	pushl  0xc(%ebp)
  803595:	e8 7b eb ff ff       	call   802115 <alloc_block_FF>
  80359a:	83 c4 10             	add    $0x10,%esp
  80359d:	89 45 c0             	mov    %eax,-0x40(%ebp)
				copy_data(va, new_va); //transfer data
  8035a0:	83 ec 08             	sub    $0x8,%esp
  8035a3:	ff 75 c0             	pushl  -0x40(%ebp)
  8035a6:	ff 75 08             	pushl  0x8(%ebp)
  8035a9:	e8 c9 fa ff ff       	call   803077 <copy_data>
  8035ae:	83 c4 10             	add    $0x10,%esp
				free_block(va); //set it free
  8035b1:	83 ec 0c             	sub    $0xc,%esp
  8035b4:	ff 75 08             	pushl  0x8(%ebp)
  8035b7:	e8 fa f9 ff ff       	call   802fb6 <free_block>
  8035bc:	83 c4 10             	add    $0x10,%esp
				return new_va;
  8035bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8035c2:	e9 f8 01 00 00       	jmp    8037bf <realloc_block_FF+0x709>
			}
			uint32 remaining_size = nextBLOCK_size - needed_size;
  8035c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ca:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8035cd:	89 45 bc             	mov    %eax,-0x44(%ebp)
			if(remaining_size < 16) //merge next block to my cur block
  8035d0:	83 7d bc 0f          	cmpl   $0xf,-0x44(%ebp)
  8035d4:	0f 87 a0 00 00 00    	ja     80367a <realloc_block_FF+0x5c4>
			{
				//remove from free_block_list, then
				LIST_REMOVE(&freeBlocksList, (struct BlockElement *)next_va);
  8035da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035de:	75 17                	jne    8035f7 <realloc_block_FF+0x541>
  8035e0:	83 ec 04             	sub    $0x4,%esp
  8035e3:	68 23 44 80 00       	push   $0x804423
  8035e8:	68 38 02 00 00       	push   $0x238
  8035ed:	68 41 44 80 00       	push   $0x804441
  8035f2:	e8 c2 03 00 00       	call   8039b9 <_panic>
  8035f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fa:	8b 00                	mov    (%eax),%eax
  8035fc:	85 c0                	test   %eax,%eax
  8035fe:	74 10                	je     803610 <realloc_block_FF+0x55a>
  803600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803603:	8b 00                	mov    (%eax),%eax
  803605:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803608:	8b 52 04             	mov    0x4(%edx),%edx
  80360b:	89 50 04             	mov    %edx,0x4(%eax)
  80360e:	eb 0b                	jmp    80361b <realloc_block_FF+0x565>
  803610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803613:	8b 40 04             	mov    0x4(%eax),%eax
  803616:	a3 30 50 80 00       	mov    %eax,0x805030
  80361b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361e:	8b 40 04             	mov    0x4(%eax),%eax
  803621:	85 c0                	test   %eax,%eax
  803623:	74 0f                	je     803634 <realloc_block_FF+0x57e>
  803625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803628:	8b 40 04             	mov    0x4(%eax),%eax
  80362b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80362e:	8b 12                	mov    (%edx),%edx
  803630:	89 10                	mov    %edx,(%eax)
  803632:	eb 0a                	jmp    80363e <realloc_block_FF+0x588>
  803634:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803637:	8b 00                	mov    (%eax),%eax
  803639:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80363e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803651:	a1 38 50 80 00       	mov    0x805038,%eax
  803656:	48                   	dec    %eax
  803657:	a3 38 50 80 00       	mov    %eax,0x805038

				//set block
				set_block_data(va, curBLOCK_size + nextBLOCK_size, 1);
  80365c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80365f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803662:	01 d0                	add    %edx,%eax
  803664:	83 ec 04             	sub    $0x4,%esp
  803667:	6a 01                	push   $0x1
  803669:	50                   	push   %eax
  80366a:	ff 75 08             	pushl  0x8(%ebp)
  80366d:	e8 74 ea ff ff       	call   8020e6 <set_block_data>
  803672:	83 c4 10             	add    $0x10,%esp
  803675:	e9 36 01 00 00       	jmp    8037b0 <realloc_block_FF+0x6fa>
			}
			else
			{
				newBLOCK_size = curBLOCK_size + needed_size;
  80367a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80367d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803680:	01 d0                	add    %edx,%eax
  803682:	89 45 f0             	mov    %eax,-0x10(%ebp)
				set_block_data(va, newBLOCK_size, 1);
  803685:	83 ec 04             	sub    $0x4,%esp
  803688:	6a 01                	push   $0x1
  80368a:	ff 75 f0             	pushl  -0x10(%ebp)
  80368d:	ff 75 08             	pushl  0x8(%ebp)
  803690:	e8 51 ea ff ff       	call   8020e6 <set_block_data>
  803695:	83 c4 10             	add    $0x10,%esp
				void *next_new_va = (void *)(FOOTER(va) + 2);
  803698:	8b 45 08             	mov    0x8(%ebp),%eax
  80369b:	83 e8 04             	sub    $0x4,%eax
  80369e:	8b 00                	mov    (%eax),%eax
  8036a0:	83 e0 fe             	and    $0xfffffffe,%eax
  8036a3:	89 c2                	mov    %eax,%edx
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	01 d0                	add    %edx,%eax
  8036aa:	89 45 b8             	mov    %eax,-0x48(%ebp)

				//update free_block_list
				LIST_INSERT_AFTER(&freeBlocksList, (struct BlockElement*)next_va, (struct BlockElement*)next_new_va);
  8036ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036b1:	74 06                	je     8036b9 <realloc_block_FF+0x603>
  8036b3:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  8036b7:	75 17                	jne    8036d0 <realloc_block_FF+0x61a>
  8036b9:	83 ec 04             	sub    $0x4,%esp
  8036bc:	68 b4 44 80 00       	push   $0x8044b4
  8036c1:	68 44 02 00 00       	push   $0x244
  8036c6:	68 41 44 80 00       	push   $0x804441
  8036cb:	e8 e9 02 00 00       	call   8039b9 <_panic>
  8036d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d3:	8b 10                	mov    (%eax),%edx
  8036d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036d8:	89 10                	mov    %edx,(%eax)
  8036da:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036dd:	8b 00                	mov    (%eax),%eax
  8036df:	85 c0                	test   %eax,%eax
  8036e1:	74 0b                	je     8036ee <realloc_block_FF+0x638>
  8036e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e6:	8b 00                	mov    (%eax),%eax
  8036e8:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8036eb:	89 50 04             	mov    %edx,0x4(%eax)
  8036ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8036f4:	89 10                	mov    %edx,(%eax)
  8036f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8036f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036fc:	89 50 04             	mov    %edx,0x4(%eax)
  8036ff:	8b 45 b8             	mov    -0x48(%ebp),%eax
  803702:	8b 00                	mov    (%eax),%eax
  803704:	85 c0                	test   %eax,%eax
  803706:	75 08                	jne    803710 <realloc_block_FF+0x65a>
  803708:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80370b:	a3 30 50 80 00       	mov    %eax,0x805030
  803710:	a1 38 50 80 00       	mov    0x805038,%eax
  803715:	40                   	inc    %eax
  803716:	a3 38 50 80 00       	mov    %eax,0x805038
				LIST_REMOVE(&freeBlocksList, (struct BlockElement*)next_va);
  80371b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80371f:	75 17                	jne    803738 <realloc_block_FF+0x682>
  803721:	83 ec 04             	sub    $0x4,%esp
  803724:	68 23 44 80 00       	push   $0x804423
  803729:	68 45 02 00 00       	push   $0x245
  80372e:	68 41 44 80 00       	push   $0x804441
  803733:	e8 81 02 00 00       	call   8039b9 <_panic>
  803738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373b:	8b 00                	mov    (%eax),%eax
  80373d:	85 c0                	test   %eax,%eax
  80373f:	74 10                	je     803751 <realloc_block_FF+0x69b>
  803741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803744:	8b 00                	mov    (%eax),%eax
  803746:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803749:	8b 52 04             	mov    0x4(%edx),%edx
  80374c:	89 50 04             	mov    %edx,0x4(%eax)
  80374f:	eb 0b                	jmp    80375c <realloc_block_FF+0x6a6>
  803751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803754:	8b 40 04             	mov    0x4(%eax),%eax
  803757:	a3 30 50 80 00       	mov    %eax,0x805030
  80375c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375f:	8b 40 04             	mov    0x4(%eax),%eax
  803762:	85 c0                	test   %eax,%eax
  803764:	74 0f                	je     803775 <realloc_block_FF+0x6bf>
  803766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803769:	8b 40 04             	mov    0x4(%eax),%eax
  80376c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80376f:	8b 12                	mov    (%edx),%edx
  803771:	89 10                	mov    %edx,(%eax)
  803773:	eb 0a                	jmp    80377f <realloc_block_FF+0x6c9>
  803775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803778:	8b 00                	mov    (%eax),%eax
  80377a:	a3 2c 50 80 00       	mov    %eax,0x80502c
  80377f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803782:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80378b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803792:	a1 38 50 80 00       	mov    0x805038,%eax
  803797:	48                   	dec    %eax
  803798:	a3 38 50 80 00       	mov    %eax,0x805038
				set_block_data(next_new_va, remaining_size, 0);
  80379d:	83 ec 04             	sub    $0x4,%esp
  8037a0:	6a 00                	push   $0x0
  8037a2:	ff 75 bc             	pushl  -0x44(%ebp)
  8037a5:	ff 75 b8             	pushl  -0x48(%ebp)
  8037a8:	e8 39 e9 ff ff       	call   8020e6 <set_block_data>
  8037ad:	83 c4 10             	add    $0x10,%esp
			}
			return va;
  8037b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b3:	eb 0a                	jmp    8037bf <realloc_block_FF+0x709>
		}
	}

	int abo_salah = 1; // abo salah NUMBER 1
  8037b5:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
	return va;
  8037bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8037bf:	c9                   	leave  
  8037c0:	c3                   	ret    

008037c1 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8037c1:	55                   	push   %ebp
  8037c2:	89 e5                	mov    %esp,%ebp
  8037c4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8037c7:	83 ec 04             	sub    $0x4,%esp
  8037ca:	68 20 45 80 00       	push   $0x804520
  8037cf:	68 58 02 00 00       	push   $0x258
  8037d4:	68 41 44 80 00       	push   $0x804441
  8037d9:	e8 db 01 00 00       	call   8039b9 <_panic>

008037de <alloc_block_NF>:

//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8037de:	55                   	push   %ebp
  8037df:	89 e5                	mov    %esp,%ebp
  8037e1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8037e4:	83 ec 04             	sub    $0x4,%esp
  8037e7:	68 48 45 80 00       	push   $0x804548
  8037ec:	68 61 02 00 00       	push   $0x261
  8037f1:	68 41 44 80 00       	push   $0x804441
  8037f6:	e8 be 01 00 00       	call   8039b9 <_panic>

008037fb <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8037fb:	55                   	push   %ebp
  8037fc:	89 e5                	mov    %esp,%ebp
  8037fe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #02] [2] USER-LEVEL SEMAPHORE - create_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("create_semaphore is not implemented yet");
	//Your Code is Here...

		void* ret = smalloc(semaphoreName, sizeof(struct semaphore), 1);
  803801:	83 ec 04             	sub    $0x4,%esp
  803804:	6a 01                	push   $0x1
  803806:	6a 04                	push   $0x4
  803808:	ff 75 0c             	pushl  0xc(%ebp)
  80380b:	e8 c1 dc ff ff       	call   8014d1 <smalloc>
  803810:	83 c4 10             	add    $0x10,%esp
  803813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (ret == NULL ) panic("no memory in creat_semaphore");
  803816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381a:	75 14                	jne    803830 <create_semaphore+0x35>
  80381c:	83 ec 04             	sub    $0x4,%esp
  80381f:	68 6e 45 80 00       	push   $0x80456e
  803824:	6a 0d                	push   $0xd
  803826:	68 8b 45 80 00       	push   $0x80458b
  80382b:	e8 89 01 00 00       	call   8039b9 <_panic>

	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  803830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803833:	89 45 f0             	mov    %eax,-0x10(%ebp)

	    sem_ptr->semdata->count = value;
  803836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803839:	8b 00                	mov    (%eax),%eax
  80383b:	8b 55 10             	mov    0x10(%ebp),%edx
  80383e:	89 50 10             	mov    %edx,0x10(%eax)
	    sys_init_queue(&(sem_ptr->semdata->queue));
  803841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803844:	8b 00                	mov    (%eax),%eax
  803846:	83 ec 0c             	sub    $0xc,%esp
  803849:	50                   	push   %eax
  80384a:	e8 cc e4 ff ff       	call   801d1b <sys_init_queue>
  80384f:	83 c4 10             	add    $0x10,%esp

	    sem_ptr->semdata->lock = 0;
  803852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803855:	8b 00                	mov    (%eax),%eax
  803857:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	    return *sem_ptr;
  80385e:	8b 45 08             	mov    0x8(%ebp),%eax
  803861:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803864:	8b 12                	mov    (%edx),%edx
  803866:	89 10                	mov    %edx,(%eax)
}
  803868:	8b 45 08             	mov    0x8(%ebp),%eax
  80386b:	c9                   	leave  
  80386c:	c2 04 00             	ret    $0x4

0080386f <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80386f:	55                   	push   %ebp
  803870:	89 e5                	mov    %esp,%ebp
  803872:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS3 - #03] [2] USER-LEVEL SEMAPHORE - get_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("get_semaphore is not implemented yet");
	//Your Code is Here...
		void* ret = sget(ownerEnvID, semaphoreName);
  803875:	83 ec 08             	sub    $0x8,%esp
  803878:	ff 75 10             	pushl  0x10(%ebp)
  80387b:	ff 75 0c             	pushl  0xc(%ebp)
  80387e:	e8 f3 dc ff ff       	call   801576 <sget>
  803883:	83 c4 10             	add    $0x10,%esp
  803886:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ret == NULL ) panic("no semaphore in get_semaphore");
  803889:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80388d:	75 14                	jne    8038a3 <get_semaphore+0x34>
  80388f:	83 ec 04             	sub    $0x4,%esp
  803892:	68 9b 45 80 00       	push   $0x80459b
  803897:	6a 1f                	push   $0x1f
  803899:	68 8b 45 80 00       	push   $0x80458b
  80389e:	e8 16 01 00 00       	call   8039b9 <_panic>
	    struct semaphore* sem_ptr = (struct semaphore*)ret;
  8038a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    return *sem_ptr;
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038af:	8b 12                	mov    (%edx),%edx
  8038b1:	89 10                	mov    %edx,(%eax)
}
  8038b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b6:	c9                   	leave  
  8038b7:	c2 04 00             	ret    $0x4

008038ba <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  8038ba:	55                   	push   %ebp
  8038bb:	89 e5                	mov    %esp,%ebp
  8038bd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #04] [2] USER-LEVEL SEMAPHORE - wait_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("wait_semaphore is not implemented yet");
	//Your Code is Here...
			uint32 key = 1;
  8038c0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
		    do { xchg(&sem.semdata->lock,key); } while (key != 0);
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	83 c0 14             	add    $0x14,%eax
  8038cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8038d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8038d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038dc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  8038df:	f0 87 02             	lock xchg %eax,(%edx)
  8038e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8038e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038e9:	75 dc                	jne    8038c7 <wait_semaphore+0xd>

		    sem.semdata->count--;
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	8b 50 10             	mov    0x10(%eax),%edx
  8038f1:	4a                   	dec    %edx
  8038f2:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count < 0) {
  8038f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f8:	8b 40 10             	mov    0x10(%eax),%eax
  8038fb:	85 c0                	test   %eax,%eax
  8038fd:	79 30                	jns    80392f <wait_semaphore+0x75>

	    	struct Env* cur_env = sys_get_cpu_process();
  8038ff:	e8 f5 e3 ff ff       	call   801cf9 <sys_get_cpu_process>
  803904:	89 45 f0             	mov    %eax,-0x10(%ebp)

//	    	acquire_spinlock(&ProcessQueues.qlock); //acquire procque
	        sys_enqueue(&(sem.semdata->queue),cur_env);  // Add process to waiting queue
  803907:	8b 45 08             	mov    0x8(%ebp),%eax
  80390a:	83 ec 08             	sub    $0x8,%esp
  80390d:	ff 75 f0             	pushl  -0x10(%ebp)
  803910:	50                   	push   %eax
  803911:	e8 21 e4 ff ff       	call   801d37 <sys_enqueue>
  803916:	83 c4 10             	add    $0x10,%esp
	        cur_env->env_status= ENV_BLOCKED;
  803919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80391c:	c7 40 18 03 00 00 00 	movl   $0x3,0x18(%eax)
	        sem.semdata->lock = 0;
  803923:	8b 45 08             	mov    0x8(%ebp),%eax
  803926:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;

}
  80392d:	eb 0a                	jmp    803939 <wait_semaphore+0x7f>
	        cur_env->env_status= ENV_BLOCKED;
	        sem.semdata->lock = 0;
//	        release_spinlock(&ProcessQueues.qlock); //release procque

	    } else
	    	sem.semdata->lock = 0;
  80392f:	8b 45 08             	mov    0x8(%ebp),%eax
  803932:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

}
  803939:	90                   	nop
  80393a:	c9                   	leave  
  80393b:	c3                   	ret    

0080393c <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  80393c:	55                   	push   %ebp
  80393d:	89 e5                	mov    %esp,%ebp
  80393f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS3 - #05] [2] USER-LEVEL SEMAPHORE - signal_semaphore
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
//	panic("signal_semaphore is not implemented yet");
	//Your Code is Here...
		uint32 key = 1;
  803942:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	    do { xchg(&sem.semdata->lock,key ); } while (key != 0);
  803949:	8b 45 08             	mov    0x8(%ebp),%eax
  80394c:	83 c0 14             	add    $0x14,%eax
  80394f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803955:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803958:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80395b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  803961:	f0 87 02             	lock xchg %eax,(%edx)
  803964:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803967:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80396b:	75 dc                	jne    803949 <signal_semaphore+0xd>
	    sem.semdata->count++;
  80396d:	8b 45 08             	mov    0x8(%ebp),%eax
  803970:	8b 50 10             	mov    0x10(%eax),%edx
  803973:	42                   	inc    %edx
  803974:	89 50 10             	mov    %edx,0x10(%eax)
	    if (sem.semdata->count <= 0) {
  803977:	8b 45 08             	mov    0x8(%ebp),%eax
  80397a:	8b 40 10             	mov    0x10(%eax),%eax
  80397d:	85 c0                	test   %eax,%eax
  80397f:	7f 20                	jg     8039a1 <signal_semaphore+0x65>
	        struct Env* env = sys_dequeue(&(sem.semdata->queue)) ;
  803981:	8b 45 08             	mov    0x8(%ebp),%eax
  803984:	83 ec 0c             	sub    $0xc,%esp
  803987:	50                   	push   %eax
  803988:	e8 c8 e3 ff ff       	call   801d55 <sys_dequeue>
  80398d:	83 c4 10             	add    $0x10,%esp
  803990:	89 45 f0             	mov    %eax,-0x10(%ebp)
	        sys_sched_insert_ready(env);
  803993:	83 ec 0c             	sub    $0xc,%esp
  803996:	ff 75 f0             	pushl  -0x10(%ebp)
  803999:	e8 db e3 ff ff       	call   801d79 <sys_sched_insert_ready>
  80399e:	83 c4 10             	add    $0x10,%esp
	    }
	    sem.semdata->lock = 0;
  8039a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  8039ab:	90                   	nop
  8039ac:	c9                   	leave  
  8039ad:	c3                   	ret    

008039ae <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  8039ae:	55                   	push   %ebp
  8039af:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8039b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b4:	8b 40 10             	mov    0x10(%eax),%eax
}
  8039b7:	5d                   	pop    %ebp
  8039b8:	c3                   	ret    

008039b9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8039b9:	55                   	push   %ebp
  8039ba:	89 e5                	mov    %esp,%ebp
  8039bc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8039bf:	8d 45 10             	lea    0x10(%ebp),%eax
  8039c2:	83 c0 04             	add    $0x4,%eax
  8039c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8039c8:	a1 60 50 98 00       	mov    0x985060,%eax
  8039cd:	85 c0                	test   %eax,%eax
  8039cf:	74 16                	je     8039e7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8039d1:	a1 60 50 98 00       	mov    0x985060,%eax
  8039d6:	83 ec 08             	sub    $0x8,%esp
  8039d9:	50                   	push   %eax
  8039da:	68 bc 45 80 00       	push   $0x8045bc
  8039df:	e8 1f ca ff ff       	call   800403 <cprintf>
  8039e4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8039e7:	a1 00 50 80 00       	mov    0x805000,%eax
  8039ec:	ff 75 0c             	pushl  0xc(%ebp)
  8039ef:	ff 75 08             	pushl  0x8(%ebp)
  8039f2:	50                   	push   %eax
  8039f3:	68 c1 45 80 00       	push   $0x8045c1
  8039f8:	e8 06 ca ff ff       	call   800403 <cprintf>
  8039fd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803a00:	8b 45 10             	mov    0x10(%ebp),%eax
  803a03:	83 ec 08             	sub    $0x8,%esp
  803a06:	ff 75 f4             	pushl  -0xc(%ebp)
  803a09:	50                   	push   %eax
  803a0a:	e8 89 c9 ff ff       	call   800398 <vcprintf>
  803a0f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803a12:	83 ec 08             	sub    $0x8,%esp
  803a15:	6a 00                	push   $0x0
  803a17:	68 dd 45 80 00       	push   $0x8045dd
  803a1c:	e8 77 c9 ff ff       	call   800398 <vcprintf>
  803a21:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803a24:	e8 f8 c8 ff ff       	call   800321 <exit>

	// should not return here
	while (1) ;
  803a29:	eb fe                	jmp    803a29 <_panic+0x70>

00803a2b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803a2b:	55                   	push   %ebp
  803a2c:	89 e5                	mov    %esp,%ebp
  803a2e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803a31:	a1 20 50 80 00       	mov    0x805020,%eax
  803a36:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a3f:	39 c2                	cmp    %eax,%edx
  803a41:	74 14                	je     803a57 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803a43:	83 ec 04             	sub    $0x4,%esp
  803a46:	68 e0 45 80 00       	push   $0x8045e0
  803a4b:	6a 26                	push   $0x26
  803a4d:	68 2c 46 80 00       	push   $0x80462c
  803a52:	e8 62 ff ff ff       	call   8039b9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803a57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803a5e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803a65:	e9 c5 00 00 00       	jmp    803b2f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a6d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a74:	8b 45 08             	mov    0x8(%ebp),%eax
  803a77:	01 d0                	add    %edx,%eax
  803a79:	8b 00                	mov    (%eax),%eax
  803a7b:	85 c0                	test   %eax,%eax
  803a7d:	75 08                	jne    803a87 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803a7f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803a82:	e9 a5 00 00 00       	jmp    803b2c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  803a87:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803a8e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803a95:	eb 69                	jmp    803b00 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803a97:	a1 20 50 80 00       	mov    0x805020,%eax
  803a9c:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803aa2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803aa5:	89 d0                	mov    %edx,%eax
  803aa7:	01 c0                	add    %eax,%eax
  803aa9:	01 d0                	add    %edx,%eax
  803aab:	c1 e0 03             	shl    $0x3,%eax
  803aae:	01 c8                	add    %ecx,%eax
  803ab0:	8a 40 04             	mov    0x4(%eax),%al
  803ab3:	84 c0                	test   %al,%al
  803ab5:	75 46                	jne    803afd <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803ab7:	a1 20 50 80 00       	mov    0x805020,%eax
  803abc:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803ac2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ac5:	89 d0                	mov    %edx,%eax
  803ac7:	01 c0                	add    %eax,%eax
  803ac9:	01 d0                	add    %edx,%eax
  803acb:	c1 e0 03             	shl    $0x3,%eax
  803ace:	01 c8                	add    %ecx,%eax
  803ad0:	8b 00                	mov    (%eax),%eax
  803ad2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803ad5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ad8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803add:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ae2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aec:	01 c8                	add    %ecx,%eax
  803aee:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803af0:	39 c2                	cmp    %eax,%edx
  803af2:	75 09                	jne    803afd <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  803af4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803afb:	eb 15                	jmp    803b12 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803afd:	ff 45 e8             	incl   -0x18(%ebp)
  803b00:	a1 20 50 80 00       	mov    0x805020,%eax
  803b05:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0e:	39 c2                	cmp    %eax,%edx
  803b10:	77 85                	ja     803a97 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803b12:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b16:	75 14                	jne    803b2c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  803b18:	83 ec 04             	sub    $0x4,%esp
  803b1b:	68 38 46 80 00       	push   $0x804638
  803b20:	6a 3a                	push   $0x3a
  803b22:	68 2c 46 80 00       	push   $0x80462c
  803b27:	e8 8d fe ff ff       	call   8039b9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803b2c:	ff 45 f0             	incl   -0x10(%ebp)
  803b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b32:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803b35:	0f 8c 2f ff ff ff    	jl     803a6a <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803b3b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b42:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803b49:	eb 26                	jmp    803b71 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803b4b:	a1 20 50 80 00       	mov    0x805020,%eax
  803b50:	8b 88 88 05 00 00    	mov    0x588(%eax),%ecx
  803b56:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b59:	89 d0                	mov    %edx,%eax
  803b5b:	01 c0                	add    %eax,%eax
  803b5d:	01 d0                	add    %edx,%eax
  803b5f:	c1 e0 03             	shl    $0x3,%eax
  803b62:	01 c8                	add    %ecx,%eax
  803b64:	8a 40 04             	mov    0x4(%eax),%al
  803b67:	3c 01                	cmp    $0x1,%al
  803b69:	75 03                	jne    803b6e <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803b6b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803b6e:	ff 45 e0             	incl   -0x20(%ebp)
  803b71:	a1 20 50 80 00       	mov    0x805020,%eax
  803b76:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803b7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b7f:	39 c2                	cmp    %eax,%edx
  803b81:	77 c8                	ja     803b4b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b86:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803b89:	74 14                	je     803b9f <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803b8b:	83 ec 04             	sub    $0x4,%esp
  803b8e:	68 8c 46 80 00       	push   $0x80468c
  803b93:	6a 44                	push   $0x44
  803b95:	68 2c 46 80 00       	push   $0x80462c
  803b9a:	e8 1a fe ff ff       	call   8039b9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803b9f:	90                   	nop
  803ba0:	c9                   	leave  
  803ba1:	c3                   	ret    
  803ba2:	66 90                	xchg   %ax,%ax

00803ba4 <__udivdi3>:
  803ba4:	55                   	push   %ebp
  803ba5:	57                   	push   %edi
  803ba6:	56                   	push   %esi
  803ba7:	53                   	push   %ebx
  803ba8:	83 ec 1c             	sub    $0x1c,%esp
  803bab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803baf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803bb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bb7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bbb:	89 ca                	mov    %ecx,%edx
  803bbd:	89 f8                	mov    %edi,%eax
  803bbf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803bc3:	85 f6                	test   %esi,%esi
  803bc5:	75 2d                	jne    803bf4 <__udivdi3+0x50>
  803bc7:	39 cf                	cmp    %ecx,%edi
  803bc9:	77 65                	ja     803c30 <__udivdi3+0x8c>
  803bcb:	89 fd                	mov    %edi,%ebp
  803bcd:	85 ff                	test   %edi,%edi
  803bcf:	75 0b                	jne    803bdc <__udivdi3+0x38>
  803bd1:	b8 01 00 00 00       	mov    $0x1,%eax
  803bd6:	31 d2                	xor    %edx,%edx
  803bd8:	f7 f7                	div    %edi
  803bda:	89 c5                	mov    %eax,%ebp
  803bdc:	31 d2                	xor    %edx,%edx
  803bde:	89 c8                	mov    %ecx,%eax
  803be0:	f7 f5                	div    %ebp
  803be2:	89 c1                	mov    %eax,%ecx
  803be4:	89 d8                	mov    %ebx,%eax
  803be6:	f7 f5                	div    %ebp
  803be8:	89 cf                	mov    %ecx,%edi
  803bea:	89 fa                	mov    %edi,%edx
  803bec:	83 c4 1c             	add    $0x1c,%esp
  803bef:	5b                   	pop    %ebx
  803bf0:	5e                   	pop    %esi
  803bf1:	5f                   	pop    %edi
  803bf2:	5d                   	pop    %ebp
  803bf3:	c3                   	ret    
  803bf4:	39 ce                	cmp    %ecx,%esi
  803bf6:	77 28                	ja     803c20 <__udivdi3+0x7c>
  803bf8:	0f bd fe             	bsr    %esi,%edi
  803bfb:	83 f7 1f             	xor    $0x1f,%edi
  803bfe:	75 40                	jne    803c40 <__udivdi3+0x9c>
  803c00:	39 ce                	cmp    %ecx,%esi
  803c02:	72 0a                	jb     803c0e <__udivdi3+0x6a>
  803c04:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803c08:	0f 87 9e 00 00 00    	ja     803cac <__udivdi3+0x108>
  803c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c13:	89 fa                	mov    %edi,%edx
  803c15:	83 c4 1c             	add    $0x1c,%esp
  803c18:	5b                   	pop    %ebx
  803c19:	5e                   	pop    %esi
  803c1a:	5f                   	pop    %edi
  803c1b:	5d                   	pop    %ebp
  803c1c:	c3                   	ret    
  803c1d:	8d 76 00             	lea    0x0(%esi),%esi
  803c20:	31 ff                	xor    %edi,%edi
  803c22:	31 c0                	xor    %eax,%eax
  803c24:	89 fa                	mov    %edi,%edx
  803c26:	83 c4 1c             	add    $0x1c,%esp
  803c29:	5b                   	pop    %ebx
  803c2a:	5e                   	pop    %esi
  803c2b:	5f                   	pop    %edi
  803c2c:	5d                   	pop    %ebp
  803c2d:	c3                   	ret    
  803c2e:	66 90                	xchg   %ax,%ax
  803c30:	89 d8                	mov    %ebx,%eax
  803c32:	f7 f7                	div    %edi
  803c34:	31 ff                	xor    %edi,%edi
  803c36:	89 fa                	mov    %edi,%edx
  803c38:	83 c4 1c             	add    $0x1c,%esp
  803c3b:	5b                   	pop    %ebx
  803c3c:	5e                   	pop    %esi
  803c3d:	5f                   	pop    %edi
  803c3e:	5d                   	pop    %ebp
  803c3f:	c3                   	ret    
  803c40:	bd 20 00 00 00       	mov    $0x20,%ebp
  803c45:	89 eb                	mov    %ebp,%ebx
  803c47:	29 fb                	sub    %edi,%ebx
  803c49:	89 f9                	mov    %edi,%ecx
  803c4b:	d3 e6                	shl    %cl,%esi
  803c4d:	89 c5                	mov    %eax,%ebp
  803c4f:	88 d9                	mov    %bl,%cl
  803c51:	d3 ed                	shr    %cl,%ebp
  803c53:	89 e9                	mov    %ebp,%ecx
  803c55:	09 f1                	or     %esi,%ecx
  803c57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803c5b:	89 f9                	mov    %edi,%ecx
  803c5d:	d3 e0                	shl    %cl,%eax
  803c5f:	89 c5                	mov    %eax,%ebp
  803c61:	89 d6                	mov    %edx,%esi
  803c63:	88 d9                	mov    %bl,%cl
  803c65:	d3 ee                	shr    %cl,%esi
  803c67:	89 f9                	mov    %edi,%ecx
  803c69:	d3 e2                	shl    %cl,%edx
  803c6b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c6f:	88 d9                	mov    %bl,%cl
  803c71:	d3 e8                	shr    %cl,%eax
  803c73:	09 c2                	or     %eax,%edx
  803c75:	89 d0                	mov    %edx,%eax
  803c77:	89 f2                	mov    %esi,%edx
  803c79:	f7 74 24 0c          	divl   0xc(%esp)
  803c7d:	89 d6                	mov    %edx,%esi
  803c7f:	89 c3                	mov    %eax,%ebx
  803c81:	f7 e5                	mul    %ebp
  803c83:	39 d6                	cmp    %edx,%esi
  803c85:	72 19                	jb     803ca0 <__udivdi3+0xfc>
  803c87:	74 0b                	je     803c94 <__udivdi3+0xf0>
  803c89:	89 d8                	mov    %ebx,%eax
  803c8b:	31 ff                	xor    %edi,%edi
  803c8d:	e9 58 ff ff ff       	jmp    803bea <__udivdi3+0x46>
  803c92:	66 90                	xchg   %ax,%ax
  803c94:	8b 54 24 08          	mov    0x8(%esp),%edx
  803c98:	89 f9                	mov    %edi,%ecx
  803c9a:	d3 e2                	shl    %cl,%edx
  803c9c:	39 c2                	cmp    %eax,%edx
  803c9e:	73 e9                	jae    803c89 <__udivdi3+0xe5>
  803ca0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ca3:	31 ff                	xor    %edi,%edi
  803ca5:	e9 40 ff ff ff       	jmp    803bea <__udivdi3+0x46>
  803caa:	66 90                	xchg   %ax,%ax
  803cac:	31 c0                	xor    %eax,%eax
  803cae:	e9 37 ff ff ff       	jmp    803bea <__udivdi3+0x46>
  803cb3:	90                   	nop

00803cb4 <__umoddi3>:
  803cb4:	55                   	push   %ebp
  803cb5:	57                   	push   %edi
  803cb6:	56                   	push   %esi
  803cb7:	53                   	push   %ebx
  803cb8:	83 ec 1c             	sub    $0x1c,%esp
  803cbb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803cbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  803cc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803cc7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ccb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ccf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803cd3:	89 f3                	mov    %esi,%ebx
  803cd5:	89 fa                	mov    %edi,%edx
  803cd7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cdb:	89 34 24             	mov    %esi,(%esp)
  803cde:	85 c0                	test   %eax,%eax
  803ce0:	75 1a                	jne    803cfc <__umoddi3+0x48>
  803ce2:	39 f7                	cmp    %esi,%edi
  803ce4:	0f 86 a2 00 00 00    	jbe    803d8c <__umoddi3+0xd8>
  803cea:	89 c8                	mov    %ecx,%eax
  803cec:	89 f2                	mov    %esi,%edx
  803cee:	f7 f7                	div    %edi
  803cf0:	89 d0                	mov    %edx,%eax
  803cf2:	31 d2                	xor    %edx,%edx
  803cf4:	83 c4 1c             	add    $0x1c,%esp
  803cf7:	5b                   	pop    %ebx
  803cf8:	5e                   	pop    %esi
  803cf9:	5f                   	pop    %edi
  803cfa:	5d                   	pop    %ebp
  803cfb:	c3                   	ret    
  803cfc:	39 f0                	cmp    %esi,%eax
  803cfe:	0f 87 ac 00 00 00    	ja     803db0 <__umoddi3+0xfc>
  803d04:	0f bd e8             	bsr    %eax,%ebp
  803d07:	83 f5 1f             	xor    $0x1f,%ebp
  803d0a:	0f 84 ac 00 00 00    	je     803dbc <__umoddi3+0x108>
  803d10:	bf 20 00 00 00       	mov    $0x20,%edi
  803d15:	29 ef                	sub    %ebp,%edi
  803d17:	89 fe                	mov    %edi,%esi
  803d19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d1d:	89 e9                	mov    %ebp,%ecx
  803d1f:	d3 e0                	shl    %cl,%eax
  803d21:	89 d7                	mov    %edx,%edi
  803d23:	89 f1                	mov    %esi,%ecx
  803d25:	d3 ef                	shr    %cl,%edi
  803d27:	09 c7                	or     %eax,%edi
  803d29:	89 e9                	mov    %ebp,%ecx
  803d2b:	d3 e2                	shl    %cl,%edx
  803d2d:	89 14 24             	mov    %edx,(%esp)
  803d30:	89 d8                	mov    %ebx,%eax
  803d32:	d3 e0                	shl    %cl,%eax
  803d34:	89 c2                	mov    %eax,%edx
  803d36:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d3a:	d3 e0                	shl    %cl,%eax
  803d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d40:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d44:	89 f1                	mov    %esi,%ecx
  803d46:	d3 e8                	shr    %cl,%eax
  803d48:	09 d0                	or     %edx,%eax
  803d4a:	d3 eb                	shr    %cl,%ebx
  803d4c:	89 da                	mov    %ebx,%edx
  803d4e:	f7 f7                	div    %edi
  803d50:	89 d3                	mov    %edx,%ebx
  803d52:	f7 24 24             	mull   (%esp)
  803d55:	89 c6                	mov    %eax,%esi
  803d57:	89 d1                	mov    %edx,%ecx
  803d59:	39 d3                	cmp    %edx,%ebx
  803d5b:	0f 82 87 00 00 00    	jb     803de8 <__umoddi3+0x134>
  803d61:	0f 84 91 00 00 00    	je     803df8 <__umoddi3+0x144>
  803d67:	8b 54 24 04          	mov    0x4(%esp),%edx
  803d6b:	29 f2                	sub    %esi,%edx
  803d6d:	19 cb                	sbb    %ecx,%ebx
  803d6f:	89 d8                	mov    %ebx,%eax
  803d71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803d75:	d3 e0                	shl    %cl,%eax
  803d77:	89 e9                	mov    %ebp,%ecx
  803d79:	d3 ea                	shr    %cl,%edx
  803d7b:	09 d0                	or     %edx,%eax
  803d7d:	89 e9                	mov    %ebp,%ecx
  803d7f:	d3 eb                	shr    %cl,%ebx
  803d81:	89 da                	mov    %ebx,%edx
  803d83:	83 c4 1c             	add    $0x1c,%esp
  803d86:	5b                   	pop    %ebx
  803d87:	5e                   	pop    %esi
  803d88:	5f                   	pop    %edi
  803d89:	5d                   	pop    %ebp
  803d8a:	c3                   	ret    
  803d8b:	90                   	nop
  803d8c:	89 fd                	mov    %edi,%ebp
  803d8e:	85 ff                	test   %edi,%edi
  803d90:	75 0b                	jne    803d9d <__umoddi3+0xe9>
  803d92:	b8 01 00 00 00       	mov    $0x1,%eax
  803d97:	31 d2                	xor    %edx,%edx
  803d99:	f7 f7                	div    %edi
  803d9b:	89 c5                	mov    %eax,%ebp
  803d9d:	89 f0                	mov    %esi,%eax
  803d9f:	31 d2                	xor    %edx,%edx
  803da1:	f7 f5                	div    %ebp
  803da3:	89 c8                	mov    %ecx,%eax
  803da5:	f7 f5                	div    %ebp
  803da7:	89 d0                	mov    %edx,%eax
  803da9:	e9 44 ff ff ff       	jmp    803cf2 <__umoddi3+0x3e>
  803dae:	66 90                	xchg   %ax,%ax
  803db0:	89 c8                	mov    %ecx,%eax
  803db2:	89 f2                	mov    %esi,%edx
  803db4:	83 c4 1c             	add    $0x1c,%esp
  803db7:	5b                   	pop    %ebx
  803db8:	5e                   	pop    %esi
  803db9:	5f                   	pop    %edi
  803dba:	5d                   	pop    %ebp
  803dbb:	c3                   	ret    
  803dbc:	3b 04 24             	cmp    (%esp),%eax
  803dbf:	72 06                	jb     803dc7 <__umoddi3+0x113>
  803dc1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803dc5:	77 0f                	ja     803dd6 <__umoddi3+0x122>
  803dc7:	89 f2                	mov    %esi,%edx
  803dc9:	29 f9                	sub    %edi,%ecx
  803dcb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803dcf:	89 14 24             	mov    %edx,(%esp)
  803dd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803dd6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803dda:	8b 14 24             	mov    (%esp),%edx
  803ddd:	83 c4 1c             	add    $0x1c,%esp
  803de0:	5b                   	pop    %ebx
  803de1:	5e                   	pop    %esi
  803de2:	5f                   	pop    %edi
  803de3:	5d                   	pop    %ebp
  803de4:	c3                   	ret    
  803de5:	8d 76 00             	lea    0x0(%esi),%esi
  803de8:	2b 04 24             	sub    (%esp),%eax
  803deb:	19 fa                	sbb    %edi,%edx
  803ded:	89 d1                	mov    %edx,%ecx
  803def:	89 c6                	mov    %eax,%esi
  803df1:	e9 71 ff ff ff       	jmp    803d67 <__umoddi3+0xb3>
  803df6:	66 90                	xchg   %ax,%ax
  803df8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803dfc:	72 ea                	jb     803de8 <__umoddi3+0x134>
  803dfe:	89 d9                	mov    %ebx,%ecx
  803e00:	e9 62 ff ff ff       	jmp    803d67 <__umoddi3+0xb3>
