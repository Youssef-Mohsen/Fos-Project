
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
  800045:	68 c0 1d 80 00       	push   $0x801dc0
  80004a:	e8 9f 11 00 00       	call   8011ee <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 c4 1d 80 00       	push   $0x801dc4
  800066:	e8 90 03 00 00       	call   8003fb <cprintf>
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
  80009a:	68 e9 1d 80 00       	push   $0x801de9
  80009f:	e8 4a 11 00 00       	call   8011ee <smalloc>
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
  8000da:	68 f0 1d 80 00       	push   $0x801df0
  8000df:	50                   	push   %eax
  8000e0:	e8 03 18 00 00       	call   8018e8 <create_semaphore>
  8000e5:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	6a 01                	push   $0x1
  8000ed:	6a 04                	push   $0x4
  8000ef:	68 f2 1d 80 00       	push   $0x801df2
  8000f4:	e8 f5 10 00 00       	call   8011ee <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800102:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800108:	a1 04 30 80 00       	mov    0x803004,%eax
  80010d:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  800113:	a1 04 30 80 00       	mov    0x803004,%eax
  800118:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  80011e:	89 c1                	mov    %eax,%ecx
  800120:	a1 04 30 80 00       	mov    0x803004,%eax
  800125:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80012b:	52                   	push   %edx
  80012c:	51                   	push   %ecx
  80012d:	50                   	push   %eax
  80012e:	68 00 1e 80 00       	push   $0x801e00
  800133:	e8 02 14 00 00       	call   80153a <sys_create_env>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80013e:	a1 04 30 80 00       	mov    0x803004,%eax
  800143:	8b 90 80 05 00 00    	mov    0x580(%eax),%edx
  800149:	a1 04 30 80 00       	mov    0x803004,%eax
  80014e:	8b 80 78 05 00 00    	mov    0x578(%eax),%eax
  800154:	89 c1                	mov    %eax,%ecx
  800156:	a1 04 30 80 00       	mov    0x803004,%eax
  80015b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800161:	52                   	push   %edx
  800162:	51                   	push   %ecx
  800163:	50                   	push   %eax
  800164:	68 0a 1e 80 00       	push   $0x801e0a
  800169:	e8 cc 13 00 00       	call   80153a <sys_create_env>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 d9 13 00 00       	call   801558 <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	e8 cb 13 00 00       	call   801558 <sys_run_env>
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
  8001a4:	68 14 1e 80 00       	push   $0x801e14
  8001a9:	e8 4d 02 00 00       	call   8003fb <cprintf>
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
  8001c8:	e8 aa 12 00 00       	call   801477 <sys_cputc>
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
  8001d9:	e8 35 11 00 00       	call   801313 <sys_cgetc>
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
  8001f6:	e8 ad 13 00 00       	call   8015a8 <sys_getenvindex>
  8001fb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800201:	89 d0                	mov    %edx,%eax
  800203:	c1 e0 02             	shl    $0x2,%eax
  800206:	01 d0                	add    %edx,%eax
  800208:	01 c0                	add    %eax,%eax
  80020a:	01 d0                	add    %edx,%eax
  80020c:	c1 e0 02             	shl    $0x2,%eax
  80020f:	01 d0                	add    %edx,%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	01 d0                	add    %edx,%eax
  800215:	c1 e0 04             	shl    $0x4,%eax
  800218:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80021d:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800222:	a1 04 30 80 00       	mov    0x803004,%eax
  800227:	8a 40 20             	mov    0x20(%eax),%al
  80022a:	84 c0                	test   %al,%al
  80022c:	74 0d                	je     80023b <libmain+0x4b>
		binaryname = myEnv->prog_name;
  80022e:	a1 04 30 80 00       	mov    0x803004,%eax
  800233:	83 c0 20             	add    $0x20,%eax
  800236:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023f:	7e 0a                	jle    80024b <libmain+0x5b>
		binaryname = argv[0];
  800241:	8b 45 0c             	mov    0xc(%ebp),%eax
  800244:	8b 00                	mov    (%eax),%eax
  800246:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	ff 75 0c             	pushl  0xc(%ebp)
  800251:	ff 75 08             	pushl  0x8(%ebp)
  800254:	e8 df fd ff ff       	call   800038 <_main>
  800259:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  80025c:	e8 cb 10 00 00       	call   80132c <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	68 44 1e 80 00       	push   $0x801e44
  800269:	e8 8d 01 00 00       	call   8003fb <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800271:	a1 04 30 80 00       	mov    0x803004,%eax
  800276:	8b 90 94 05 00 00    	mov    0x594(%eax),%edx
  80027c:	a1 04 30 80 00       	mov    0x803004,%eax
  800281:	8b 80 84 05 00 00    	mov    0x584(%eax),%eax
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	52                   	push   %edx
  80028b:	50                   	push   %eax
  80028c:	68 6c 1e 80 00       	push   $0x801e6c
  800291:	e8 65 01 00 00       	call   8003fb <cprintf>
  800296:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800299:	a1 04 30 80 00       	mov    0x803004,%eax
  80029e:	8b 88 a8 05 00 00    	mov    0x5a8(%eax),%ecx
  8002a4:	a1 04 30 80 00       	mov    0x803004,%eax
  8002a9:	8b 90 a4 05 00 00    	mov    0x5a4(%eax),%edx
  8002af:	a1 04 30 80 00       	mov    0x803004,%eax
  8002b4:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8002ba:	51                   	push   %ecx
  8002bb:	52                   	push   %edx
  8002bc:	50                   	push   %eax
  8002bd:	68 94 1e 80 00       	push   $0x801e94
  8002c2:	e8 34 01 00 00       	call   8003fb <cprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002ca:	a1 04 30 80 00       	mov    0x803004,%eax
  8002cf:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8002d5:	83 ec 08             	sub    $0x8,%esp
  8002d8:	50                   	push   %eax
  8002d9:	68 ec 1e 80 00       	push   $0x801eec
  8002de:	e8 18 01 00 00       	call   8003fb <cprintf>
  8002e3:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002e6:	83 ec 0c             	sub    $0xc,%esp
  8002e9:	68 44 1e 80 00       	push   $0x801e44
  8002ee:	e8 08 01 00 00       	call   8003fb <cprintf>
  8002f3:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  8002f6:	e8 4b 10 00 00       	call   801346 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  8002fb:	e8 19 00 00 00       	call   800319 <exit>
}
  800300:	90                   	nop
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800309:	83 ec 0c             	sub    $0xc,%esp
  80030c:	6a 00                	push   $0x0
  80030e:	e8 61 12 00 00       	call   801574 <sys_destroy_env>
  800313:	83 c4 10             	add    $0x10,%esp
}
  800316:	90                   	nop
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <exit>:

void
exit(void)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031f:	e8 b6 12 00 00       	call   8015da <sys_exit_env>
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80032d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	8d 48 01             	lea    0x1(%eax),%ecx
  800335:	8b 55 0c             	mov    0xc(%ebp),%edx
  800338:	89 0a                	mov    %ecx,(%edx)
  80033a:	8b 55 08             	mov    0x8(%ebp),%edx
  80033d:	88 d1                	mov    %dl,%cl
  80033f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800342:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800346:	8b 45 0c             	mov    0xc(%ebp),%eax
  800349:	8b 00                	mov    (%eax),%eax
  80034b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800350:	75 2c                	jne    80037e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800352:	a0 08 30 80 00       	mov    0x803008,%al
  800357:	0f b6 c0             	movzbl %al,%eax
  80035a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80035d:	8b 12                	mov    (%edx),%edx
  80035f:	89 d1                	mov    %edx,%ecx
  800361:	8b 55 0c             	mov    0xc(%ebp),%edx
  800364:	83 c2 08             	add    $0x8,%edx
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	50                   	push   %eax
  80036b:	51                   	push   %ecx
  80036c:	52                   	push   %edx
  80036d:	e8 78 0f 00 00       	call   8012ea <sys_cputs>
  800372:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800375:	8b 45 0c             	mov    0xc(%ebp),%eax
  800378:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80037e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800381:	8b 40 04             	mov    0x4(%eax),%eax
  800384:	8d 50 01             	lea    0x1(%eax),%edx
  800387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800399:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003a0:	00 00 00 
	b.cnt = 0;
  8003a3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003aa:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003ad:	ff 75 0c             	pushl  0xc(%ebp)
  8003b0:	ff 75 08             	pushl  0x8(%ebp)
  8003b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003b9:	50                   	push   %eax
  8003ba:	68 27 03 80 00       	push   $0x800327
  8003bf:	e8 11 02 00 00       	call   8005d5 <vprintfmt>
  8003c4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8003c7:	a0 08 30 80 00       	mov    0x803008,%al
  8003cc:	0f b6 c0             	movzbl %al,%eax
  8003cf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003d5:	83 ec 04             	sub    $0x4,%esp
  8003d8:	50                   	push   %eax
  8003d9:	52                   	push   %edx
  8003da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e0:	83 c0 08             	add    $0x8,%eax
  8003e3:	50                   	push   %eax
  8003e4:	e8 01 0f 00 00       	call   8012ea <sys_cputs>
  8003e9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003ec:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  8003f3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003f9:	c9                   	leave  
  8003fa:	c3                   	ret    

008003fb <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800401:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  800408:	8d 45 0c             	lea    0xc(%ebp),%eax
  80040b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	ff 75 f4             	pushl  -0xc(%ebp)
  800417:	50                   	push   %eax
  800418:	e8 73 ff ff ff       	call   800390 <vcprintf>
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800423:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800426:	c9                   	leave  
  800427:	c3                   	ret    

00800428 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
  80042b:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80042e:	e8 f9 0e 00 00       	call   80132c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800433:	8d 45 0c             	lea    0xc(%ebp),%eax
  800436:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 f4             	pushl  -0xc(%ebp)
  800442:	50                   	push   %eax
  800443:	e8 48 ff ff ff       	call   800390 <vcprintf>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80044e:	e8 f3 0e 00 00       	call   801346 <sys_unlock_cons>
	return cnt;
  800453:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800456:	c9                   	leave  
  800457:	c3                   	ret    

00800458 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	53                   	push   %ebx
  80045c:	83 ec 14             	sub    $0x14,%esp
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800465:	8b 45 14             	mov    0x14(%ebp),%eax
  800468:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80046b:	8b 45 18             	mov    0x18(%ebp),%eax
  80046e:	ba 00 00 00 00       	mov    $0x0,%edx
  800473:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800476:	77 55                	ja     8004cd <printnum+0x75>
  800478:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80047b:	72 05                	jb     800482 <printnum+0x2a>
  80047d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800480:	77 4b                	ja     8004cd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800482:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800485:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800488:	8b 45 18             	mov    0x18(%ebp),%eax
  80048b:	ba 00 00 00 00       	mov    $0x0,%edx
  800490:	52                   	push   %edx
  800491:	50                   	push   %eax
  800492:	ff 75 f4             	pushl  -0xc(%ebp)
  800495:	ff 75 f0             	pushl  -0x10(%ebp)
  800498:	e8 a7 16 00 00       	call   801b44 <__udivdi3>
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	83 ec 04             	sub    $0x4,%esp
  8004a3:	ff 75 20             	pushl  0x20(%ebp)
  8004a6:	53                   	push   %ebx
  8004a7:	ff 75 18             	pushl  0x18(%ebp)
  8004aa:	52                   	push   %edx
  8004ab:	50                   	push   %eax
  8004ac:	ff 75 0c             	pushl  0xc(%ebp)
  8004af:	ff 75 08             	pushl  0x8(%ebp)
  8004b2:	e8 a1 ff ff ff       	call   800458 <printnum>
  8004b7:	83 c4 20             	add    $0x20,%esp
  8004ba:	eb 1a                	jmp    8004d6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	ff 75 0c             	pushl  0xc(%ebp)
  8004c2:	ff 75 20             	pushl  0x20(%ebp)
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	ff d0                	call   *%eax
  8004ca:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004cd:	ff 4d 1c             	decl   0x1c(%ebp)
  8004d0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004d4:	7f e6                	jg     8004bc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004e4:	53                   	push   %ebx
  8004e5:	51                   	push   %ecx
  8004e6:	52                   	push   %edx
  8004e7:	50                   	push   %eax
  8004e8:	e8 67 17 00 00       	call   801c54 <__umoddi3>
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	05 14 21 80 00       	add    $0x802114,%eax
  8004f5:	8a 00                	mov    (%eax),%al
  8004f7:	0f be c0             	movsbl %al,%eax
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	ff 75 0c             	pushl  0xc(%ebp)
  800500:	50                   	push   %eax
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	ff d0                	call   *%eax
  800506:	83 c4 10             	add    $0x10,%esp
}
  800509:	90                   	nop
  80050a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800512:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800516:	7e 1c                	jle    800534 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	8d 50 08             	lea    0x8(%eax),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	89 10                	mov    %edx,(%eax)
  800525:	8b 45 08             	mov    0x8(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	83 e8 08             	sub    $0x8,%eax
  80052d:	8b 50 04             	mov    0x4(%eax),%edx
  800530:	8b 00                	mov    (%eax),%eax
  800532:	eb 40                	jmp    800574 <getuint+0x65>
	else if (lflag)
  800534:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800538:	74 1e                	je     800558 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80053a:	8b 45 08             	mov    0x8(%ebp),%eax
  80053d:	8b 00                	mov    (%eax),%eax
  80053f:	8d 50 04             	lea    0x4(%eax),%edx
  800542:	8b 45 08             	mov    0x8(%ebp),%eax
  800545:	89 10                	mov    %edx,(%eax)
  800547:	8b 45 08             	mov    0x8(%ebp),%eax
  80054a:	8b 00                	mov    (%eax),%eax
  80054c:	83 e8 04             	sub    $0x4,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	ba 00 00 00 00       	mov    $0x0,%edx
  800556:	eb 1c                	jmp    800574 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	8b 00                	mov    (%eax),%eax
  80055d:	8d 50 04             	lea    0x4(%eax),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	89 10                	mov    %edx,(%eax)
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	83 e8 04             	sub    $0x4,%eax
  80056d:	8b 00                	mov    (%eax),%eax
  80056f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800574:	5d                   	pop    %ebp
  800575:	c3                   	ret    

00800576 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800579:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80057d:	7e 1c                	jle    80059b <getint+0x25>
		return va_arg(*ap, long long);
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 50 08             	lea    0x8(%eax),%edx
  800587:	8b 45 08             	mov    0x8(%ebp),%eax
  80058a:	89 10                	mov    %edx,(%eax)
  80058c:	8b 45 08             	mov    0x8(%ebp),%eax
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	83 e8 08             	sub    $0x8,%eax
  800594:	8b 50 04             	mov    0x4(%eax),%edx
  800597:	8b 00                	mov    (%eax),%eax
  800599:	eb 38                	jmp    8005d3 <getint+0x5d>
	else if (lflag)
  80059b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80059f:	74 1a                	je     8005bb <getint+0x45>
		return va_arg(*ap, long);
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	8d 50 04             	lea    0x4(%eax),%edx
  8005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ac:	89 10                	mov    %edx,(%eax)
  8005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	83 e8 04             	sub    $0x4,%eax
  8005b6:	8b 00                	mov    (%eax),%eax
  8005b8:	99                   	cltd   
  8005b9:	eb 18                	jmp    8005d3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	8d 50 04             	lea    0x4(%eax),%edx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	89 10                	mov    %edx,(%eax)
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	8b 00                	mov    (%eax),%eax
  8005cd:	83 e8 04             	sub    $0x4,%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	99                   	cltd   
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
  8005d8:	56                   	push   %esi
  8005d9:	53                   	push   %ebx
  8005da:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005dd:	eb 17                	jmp    8005f6 <vprintfmt+0x21>
			if (ch == '\0')
  8005df:	85 db                	test   %ebx,%ebx
  8005e1:	0f 84 c1 03 00 00    	je     8009a8 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005e7:	83 ec 08             	sub    $0x8,%esp
  8005ea:	ff 75 0c             	pushl  0xc(%ebp)
  8005ed:	53                   	push   %ebx
  8005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f1:	ff d0                	call   *%eax
  8005f3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f9:	8d 50 01             	lea    0x1(%eax),%edx
  8005fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8005ff:	8a 00                	mov    (%eax),%al
  800601:	0f b6 d8             	movzbl %al,%ebx
  800604:	83 fb 25             	cmp    $0x25,%ebx
  800607:	75 d6                	jne    8005df <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800609:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80060d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800614:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80061b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800622:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800629:	8b 45 10             	mov    0x10(%ebp),%eax
  80062c:	8d 50 01             	lea    0x1(%eax),%edx
  80062f:	89 55 10             	mov    %edx,0x10(%ebp)
  800632:	8a 00                	mov    (%eax),%al
  800634:	0f b6 d8             	movzbl %al,%ebx
  800637:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80063a:	83 f8 5b             	cmp    $0x5b,%eax
  80063d:	0f 87 3d 03 00 00    	ja     800980 <vprintfmt+0x3ab>
  800643:	8b 04 85 38 21 80 00 	mov    0x802138(,%eax,4),%eax
  80064a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80064c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800650:	eb d7                	jmp    800629 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800652:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800656:	eb d1                	jmp    800629 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800658:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80065f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800662:	89 d0                	mov    %edx,%eax
  800664:	c1 e0 02             	shl    $0x2,%eax
  800667:	01 d0                	add    %edx,%eax
  800669:	01 c0                	add    %eax,%eax
  80066b:	01 d8                	add    %ebx,%eax
  80066d:	83 e8 30             	sub    $0x30,%eax
  800670:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800673:	8b 45 10             	mov    0x10(%ebp),%eax
  800676:	8a 00                	mov    (%eax),%al
  800678:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80067b:	83 fb 2f             	cmp    $0x2f,%ebx
  80067e:	7e 3e                	jle    8006be <vprintfmt+0xe9>
  800680:	83 fb 39             	cmp    $0x39,%ebx
  800683:	7f 39                	jg     8006be <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800685:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800688:	eb d5                	jmp    80065f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80068a:	8b 45 14             	mov    0x14(%ebp),%eax
  80068d:	83 c0 04             	add    $0x4,%eax
  800690:	89 45 14             	mov    %eax,0x14(%ebp)
  800693:	8b 45 14             	mov    0x14(%ebp),%eax
  800696:	83 e8 04             	sub    $0x4,%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80069e:	eb 1f                	jmp    8006bf <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a4:	79 83                	jns    800629 <vprintfmt+0x54>
				width = 0;
  8006a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006ad:	e9 77 ff ff ff       	jmp    800629 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006b2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006b9:	e9 6b ff ff ff       	jmp    800629 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006be:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c3:	0f 89 60 ff ff ff    	jns    800629 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006d6:	e9 4e ff ff ff       	jmp    800629 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006db:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006de:	e9 46 ff ff ff       	jmp    800629 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	83 c0 04             	add    $0x4,%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ef:	83 e8 04             	sub    $0x4,%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 ec 08             	sub    $0x8,%esp
  8006f7:	ff 75 0c             	pushl  0xc(%ebp)
  8006fa:	50                   	push   %eax
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	ff d0                	call   *%eax
  800700:	83 c4 10             	add    $0x10,%esp
			break;
  800703:	e9 9b 02 00 00       	jmp    8009a3 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	83 c0 04             	add    $0x4,%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	83 e8 04             	sub    $0x4,%eax
  800717:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800719:	85 db                	test   %ebx,%ebx
  80071b:	79 02                	jns    80071f <vprintfmt+0x14a>
				err = -err;
  80071d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80071f:	83 fb 64             	cmp    $0x64,%ebx
  800722:	7f 0b                	jg     80072f <vprintfmt+0x15a>
  800724:	8b 34 9d 80 1f 80 00 	mov    0x801f80(,%ebx,4),%esi
  80072b:	85 f6                	test   %esi,%esi
  80072d:	75 19                	jne    800748 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80072f:	53                   	push   %ebx
  800730:	68 25 21 80 00       	push   $0x802125
  800735:	ff 75 0c             	pushl  0xc(%ebp)
  800738:	ff 75 08             	pushl  0x8(%ebp)
  80073b:	e8 70 02 00 00       	call   8009b0 <printfmt>
  800740:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800743:	e9 5b 02 00 00       	jmp    8009a3 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800748:	56                   	push   %esi
  800749:	68 2e 21 80 00       	push   $0x80212e
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	ff 75 08             	pushl  0x8(%ebp)
  800754:	e8 57 02 00 00       	call   8009b0 <printfmt>
  800759:	83 c4 10             	add    $0x10,%esp
			break;
  80075c:	e9 42 02 00 00       	jmp    8009a3 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	83 c0 04             	add    $0x4,%eax
  800767:	89 45 14             	mov    %eax,0x14(%ebp)
  80076a:	8b 45 14             	mov    0x14(%ebp),%eax
  80076d:	83 e8 04             	sub    $0x4,%eax
  800770:	8b 30                	mov    (%eax),%esi
  800772:	85 f6                	test   %esi,%esi
  800774:	75 05                	jne    80077b <vprintfmt+0x1a6>
				p = "(null)";
  800776:	be 31 21 80 00       	mov    $0x802131,%esi
			if (width > 0 && padc != '-')
  80077b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077f:	7e 6d                	jle    8007ee <vprintfmt+0x219>
  800781:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800785:	74 67                	je     8007ee <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800787:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80078a:	83 ec 08             	sub    $0x8,%esp
  80078d:	50                   	push   %eax
  80078e:	56                   	push   %esi
  80078f:	e8 1e 03 00 00       	call   800ab2 <strnlen>
  800794:	83 c4 10             	add    $0x10,%esp
  800797:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80079a:	eb 16                	jmp    8007b2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80079c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 0c             	pushl  0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	ff d0                	call   *%eax
  8007ac:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007af:	ff 4d e4             	decl   -0x1c(%ebp)
  8007b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b6:	7f e4                	jg     80079c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007b8:	eb 34                	jmp    8007ee <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007be:	74 1c                	je     8007dc <vprintfmt+0x207>
  8007c0:	83 fb 1f             	cmp    $0x1f,%ebx
  8007c3:	7e 05                	jle    8007ca <vprintfmt+0x1f5>
  8007c5:	83 fb 7e             	cmp    $0x7e,%ebx
  8007c8:	7e 12                	jle    8007dc <vprintfmt+0x207>
					putch('?', putdat);
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 0c             	pushl  0xc(%ebp)
  8007d0:	6a 3f                	push   $0x3f
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	ff d0                	call   *%eax
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	eb 0f                	jmp    8007eb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	ff 75 0c             	pushl  0xc(%ebp)
  8007e2:	53                   	push   %ebx
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	ff d0                	call   *%eax
  8007e8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8007ee:	89 f0                	mov    %esi,%eax
  8007f0:	8d 70 01             	lea    0x1(%eax),%esi
  8007f3:	8a 00                	mov    (%eax),%al
  8007f5:	0f be d8             	movsbl %al,%ebx
  8007f8:	85 db                	test   %ebx,%ebx
  8007fa:	74 24                	je     800820 <vprintfmt+0x24b>
  8007fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800800:	78 b8                	js     8007ba <vprintfmt+0x1e5>
  800802:	ff 4d e0             	decl   -0x20(%ebp)
  800805:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800809:	79 af                	jns    8007ba <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80080b:	eb 13                	jmp    800820 <vprintfmt+0x24b>
				putch(' ', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 20                	push   $0x20
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80081d:	ff 4d e4             	decl   -0x1c(%ebp)
  800820:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800824:	7f e7                	jg     80080d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800826:	e9 78 01 00 00       	jmp    8009a3 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 e8             	pushl  -0x18(%ebp)
  800831:	8d 45 14             	lea    0x14(%ebp),%eax
  800834:	50                   	push   %eax
  800835:	e8 3c fd ff ff       	call   800576 <getint>
  80083a:	83 c4 10             	add    $0x10,%esp
  80083d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800840:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800846:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800849:	85 d2                	test   %edx,%edx
  80084b:	79 23                	jns    800870 <vprintfmt+0x29b>
				putch('-', putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	6a 2d                	push   $0x2d
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	ff d0                	call   *%eax
  80085a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80085d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800860:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800863:	f7 d8                	neg    %eax
  800865:	83 d2 00             	adc    $0x0,%edx
  800868:	f7 da                	neg    %edx
  80086a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80086d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800870:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800877:	e9 bc 00 00 00       	jmp    800938 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	ff 75 e8             	pushl  -0x18(%ebp)
  800882:	8d 45 14             	lea    0x14(%ebp),%eax
  800885:	50                   	push   %eax
  800886:	e8 84 fc ff ff       	call   80050f <getuint>
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800891:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800894:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80089b:	e9 98 00 00 00       	jmp    800938 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008a0:	83 ec 08             	sub    $0x8,%esp
  8008a3:	ff 75 0c             	pushl  0xc(%ebp)
  8008a6:	6a 58                	push   $0x58
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	ff d0                	call   *%eax
  8008ad:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008b0:	83 ec 08             	sub    $0x8,%esp
  8008b3:	ff 75 0c             	pushl  0xc(%ebp)
  8008b6:	6a 58                	push   $0x58
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	ff d0                	call   *%eax
  8008bd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	6a 58                	push   $0x58
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
			break;
  8008d0:	e9 ce 00 00 00       	jmp    8009a3 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	6a 30                	push   $0x30
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	ff d0                	call   *%eax
  8008e2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008e5:	83 ec 08             	sub    $0x8,%esp
  8008e8:	ff 75 0c             	pushl  0xc(%ebp)
  8008eb:	6a 78                	push   $0x78
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	ff d0                	call   *%eax
  8008f2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f8:	83 c0 04             	add    $0x4,%eax
  8008fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	83 e8 04             	sub    $0x4,%eax
  800904:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800906:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800909:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800910:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800917:	eb 1f                	jmp    800938 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800919:	83 ec 08             	sub    $0x8,%esp
  80091c:	ff 75 e8             	pushl  -0x18(%ebp)
  80091f:	8d 45 14             	lea    0x14(%ebp),%eax
  800922:	50                   	push   %eax
  800923:	e8 e7 fb ff ff       	call   80050f <getuint>
  800928:	83 c4 10             	add    $0x10,%esp
  80092b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80092e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800931:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800938:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80093c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093f:	83 ec 04             	sub    $0x4,%esp
  800942:	52                   	push   %edx
  800943:	ff 75 e4             	pushl  -0x1c(%ebp)
  800946:	50                   	push   %eax
  800947:	ff 75 f4             	pushl  -0xc(%ebp)
  80094a:	ff 75 f0             	pushl  -0x10(%ebp)
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	ff 75 08             	pushl  0x8(%ebp)
  800953:	e8 00 fb ff ff       	call   800458 <printnum>
  800958:	83 c4 20             	add    $0x20,%esp
			break;
  80095b:	eb 46                	jmp    8009a3 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80095d:	83 ec 08             	sub    $0x8,%esp
  800960:	ff 75 0c             	pushl  0xc(%ebp)
  800963:	53                   	push   %ebx
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	ff d0                	call   *%eax
  800969:	83 c4 10             	add    $0x10,%esp
			break;
  80096c:	eb 35                	jmp    8009a3 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80096e:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800975:	eb 2c                	jmp    8009a3 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800977:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  80097e:	eb 23                	jmp    8009a3 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800980:	83 ec 08             	sub    $0x8,%esp
  800983:	ff 75 0c             	pushl  0xc(%ebp)
  800986:	6a 25                	push   $0x25
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	ff d0                	call   *%eax
  80098d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800990:	ff 4d 10             	decl   0x10(%ebp)
  800993:	eb 03                	jmp    800998 <vprintfmt+0x3c3>
  800995:	ff 4d 10             	decl   0x10(%ebp)
  800998:	8b 45 10             	mov    0x10(%ebp),%eax
  80099b:	48                   	dec    %eax
  80099c:	8a 00                	mov    (%eax),%al
  80099e:	3c 25                	cmp    $0x25,%al
  8009a0:	75 f3                	jne    800995 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009a2:	90                   	nop
		}
	}
  8009a3:	e9 35 fc ff ff       	jmp    8005dd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009a8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009ac:	5b                   	pop    %ebx
  8009ad:	5e                   	pop    %esi
  8009ae:	5d                   	pop    %ebp
  8009af:	c3                   	ret    

008009b0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009b6:	8d 45 10             	lea    0x10(%ebp),%eax
  8009b9:	83 c0 04             	add    $0x4,%eax
  8009bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8009c5:	50                   	push   %eax
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	ff 75 08             	pushl  0x8(%ebp)
  8009cc:	e8 04 fc ff ff       	call   8005d5 <vprintfmt>
  8009d1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009d4:	90                   	nop
  8009d5:	c9                   	leave  
  8009d6:	c3                   	ret    

008009d7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009dd:	8b 40 08             	mov    0x8(%eax),%eax
  8009e0:	8d 50 01             	lea    0x1(%eax),%edx
  8009e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	8b 10                	mov    (%eax),%edx
  8009ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f1:	8b 40 04             	mov    0x4(%eax),%eax
  8009f4:	39 c2                	cmp    %eax,%edx
  8009f6:	73 12                	jae    800a0a <sprintputch+0x33>
		*b->buf++ = ch;
  8009f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fb:	8b 00                	mov    (%eax),%eax
  8009fd:	8d 48 01             	lea    0x1(%eax),%ecx
  800a00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a03:	89 0a                	mov    %ecx,(%edx)
  800a05:	8b 55 08             	mov    0x8(%ebp),%edx
  800a08:	88 10                	mov    %dl,(%eax)
}
  800a0a:	90                   	nop
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	01 d0                	add    %edx,%eax
  800a24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a32:	74 06                	je     800a3a <vsnprintf+0x2d>
  800a34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a38:	7f 07                	jg     800a41 <vsnprintf+0x34>
		return -E_INVAL;
  800a3a:	b8 03 00 00 00       	mov    $0x3,%eax
  800a3f:	eb 20                	jmp    800a61 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a41:	ff 75 14             	pushl  0x14(%ebp)
  800a44:	ff 75 10             	pushl  0x10(%ebp)
  800a47:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a4a:	50                   	push   %eax
  800a4b:	68 d7 09 80 00       	push   $0x8009d7
  800a50:	e8 80 fb ff ff       	call   8005d5 <vprintfmt>
  800a55:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a5b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a61:	c9                   	leave  
  800a62:	c3                   	ret    

00800a63 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a69:	8d 45 10             	lea    0x10(%ebp),%eax
  800a6c:	83 c0 04             	add    $0x4,%eax
  800a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a72:	8b 45 10             	mov    0x10(%ebp),%eax
  800a75:	ff 75 f4             	pushl  -0xc(%ebp)
  800a78:	50                   	push   %eax
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	ff 75 08             	pushl  0x8(%ebp)
  800a7f:	e8 89 ff ff ff       	call   800a0d <vsnprintf>
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a9c:	eb 06                	jmp    800aa4 <strlen+0x15>
		n++;
  800a9e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa1:	ff 45 08             	incl   0x8(%ebp)
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	8a 00                	mov    (%eax),%al
  800aa9:	84 c0                	test   %al,%al
  800aab:	75 f1                	jne    800a9e <strlen+0xf>
		n++;
	return n;
  800aad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800abf:	eb 09                	jmp    800aca <strnlen+0x18>
		n++;
  800ac1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac4:	ff 45 08             	incl   0x8(%ebp)
  800ac7:	ff 4d 0c             	decl   0xc(%ebp)
  800aca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ace:	74 09                	je     800ad9 <strnlen+0x27>
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	84 c0                	test   %al,%al
  800ad7:	75 e8                	jne    800ac1 <strnlen+0xf>
		n++;
	return n;
  800ad9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800adc:	c9                   	leave  
  800add:	c3                   	ret    

00800ade <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800aea:	90                   	nop
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8d 50 01             	lea    0x1(%eax),%edx
  800af1:	89 55 08             	mov    %edx,0x8(%ebp)
  800af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800afa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800afd:	8a 12                	mov    (%edx),%dl
  800aff:	88 10                	mov    %dl,(%eax)
  800b01:	8a 00                	mov    (%eax),%al
  800b03:	84 c0                	test   %al,%al
  800b05:	75 e4                	jne    800aeb <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b0a:	c9                   	leave  
  800b0b:	c3                   	ret    

00800b0c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b1f:	eb 1f                	jmp    800b40 <strncpy+0x34>
		*dst++ = *src;
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8d 50 01             	lea    0x1(%eax),%edx
  800b27:	89 55 08             	mov    %edx,0x8(%ebp)
  800b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2d:	8a 12                	mov    (%edx),%dl
  800b2f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8a 00                	mov    (%eax),%al
  800b36:	84 c0                	test   %al,%al
  800b38:	74 03                	je     800b3d <strncpy+0x31>
			src++;
  800b3a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b3d:	ff 45 fc             	incl   -0x4(%ebp)
  800b40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b46:	72 d9                	jb     800b21 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b48:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b4b:	c9                   	leave  
  800b4c:	c3                   	ret    

00800b4d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b5d:	74 30                	je     800b8f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b5f:	eb 16                	jmp    800b77 <strlcpy+0x2a>
			*dst++ = *src++;
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	8d 50 01             	lea    0x1(%eax),%edx
  800b67:	89 55 08             	mov    %edx,0x8(%ebp)
  800b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b73:	8a 12                	mov    (%edx),%dl
  800b75:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b77:	ff 4d 10             	decl   0x10(%ebp)
  800b7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b7e:	74 09                	je     800b89 <strlcpy+0x3c>
  800b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b83:	8a 00                	mov    (%eax),%al
  800b85:	84 c0                	test   %al,%al
  800b87:	75 d8                	jne    800b61 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b95:	29 c2                	sub    %eax,%edx
  800b97:	89 d0                	mov    %edx,%eax
}
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b9e:	eb 06                	jmp    800ba6 <strcmp+0xb>
		p++, q++;
  800ba0:	ff 45 08             	incl   0x8(%ebp)
  800ba3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	74 0e                	je     800bbd <strcmp+0x22>
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 10                	mov    (%eax),%dl
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8a 00                	mov    (%eax),%al
  800bb9:	38 c2                	cmp    %al,%dl
  800bbb:	74 e3                	je     800ba0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	8a 00                	mov    (%eax),%al
  800bc2:	0f b6 d0             	movzbl %al,%edx
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8a 00                	mov    (%eax),%al
  800bca:	0f b6 c0             	movzbl %al,%eax
  800bcd:	29 c2                	sub    %eax,%edx
  800bcf:	89 d0                	mov    %edx,%eax
}
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800bd6:	eb 09                	jmp    800be1 <strncmp+0xe>
		n--, p++, q++;
  800bd8:	ff 4d 10             	decl   0x10(%ebp)
  800bdb:	ff 45 08             	incl   0x8(%ebp)
  800bde:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800be1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be5:	74 17                	je     800bfe <strncmp+0x2b>
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8a 00                	mov    (%eax),%al
  800bec:	84 c0                	test   %al,%al
  800bee:	74 0e                	je     800bfe <strncmp+0x2b>
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8a 10                	mov    (%eax),%dl
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8a 00                	mov    (%eax),%al
  800bfa:	38 c2                	cmp    %al,%dl
  800bfc:	74 da                	je     800bd8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800bfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c02:	75 07                	jne    800c0b <strncmp+0x38>
		return 0;
  800c04:	b8 00 00 00 00       	mov    $0x0,%eax
  800c09:	eb 14                	jmp    800c1f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8a 00                	mov    (%eax),%al
  800c10:	0f b6 d0             	movzbl %al,%edx
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8a 00                	mov    (%eax),%al
  800c18:	0f b6 c0             	movzbl %al,%eax
  800c1b:	29 c2                	sub    %eax,%edx
  800c1d:	89 d0                	mov    %edx,%eax
}
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	83 ec 04             	sub    $0x4,%esp
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c2d:	eb 12                	jmp    800c41 <strchr+0x20>
		if (*s == c)
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8a 00                	mov    (%eax),%al
  800c34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c37:	75 05                	jne    800c3e <strchr+0x1d>
			return (char *) s;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	eb 11                	jmp    800c4f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c3e:	ff 45 08             	incl   0x8(%ebp)
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	84 c0                	test   %al,%al
  800c48:	75 e5                	jne    800c2f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c4f:	c9                   	leave  
  800c50:	c3                   	ret    

00800c51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 04             	sub    $0x4,%esp
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c5d:	eb 0d                	jmp    800c6c <strfind+0x1b>
		if (*s == c)
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8a 00                	mov    (%eax),%al
  800c64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c67:	74 0e                	je     800c77 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c69:	ff 45 08             	incl   0x8(%ebp)
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	8a 00                	mov    (%eax),%al
  800c71:	84 c0                	test   %al,%al
  800c73:	75 ea                	jne    800c5f <strfind+0xe>
  800c75:	eb 01                	jmp    800c78 <strfind+0x27>
		if (*s == c)
			break;
  800c77:	90                   	nop
	return (char *) s;
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c7b:	c9                   	leave  
  800c7c:	c3                   	ret    

00800c7d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c7d:	55                   	push   %ebp
  800c7e:	89 e5                	mov    %esp,%ebp
  800c80:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c89:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c8f:	eb 0e                	jmp    800c9f <memset+0x22>
		*p++ = c;
  800c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c94:	8d 50 01             	lea    0x1(%eax),%edx
  800c97:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c9f:	ff 4d f8             	decl   -0x8(%ebp)
  800ca2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ca6:	79 e9                	jns    800c91 <memset+0x14>
		*p++ = c;

	return v;
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800cbf:	eb 16                	jmp    800cd7 <memcpy+0x2a>
		*d++ = *s++;
  800cc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc4:	8d 50 01             	lea    0x1(%eax),%edx
  800cc7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ccd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cd3:	8a 12                	mov    (%edx),%dl
  800cd5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800cd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cda:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cdd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce0:	85 c0                	test   %eax,%eax
  800ce2:	75 dd                	jne    800cc1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800cfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cfe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d01:	73 50                	jae    800d53 <memmove+0x6a>
  800d03:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d06:	8b 45 10             	mov    0x10(%ebp),%eax
  800d09:	01 d0                	add    %edx,%eax
  800d0b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d0e:	76 43                	jbe    800d53 <memmove+0x6a>
		s += n;
  800d10:	8b 45 10             	mov    0x10(%ebp),%eax
  800d13:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d16:	8b 45 10             	mov    0x10(%ebp),%eax
  800d19:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d1c:	eb 10                	jmp    800d2e <memmove+0x45>
			*--d = *--s;
  800d1e:	ff 4d f8             	decl   -0x8(%ebp)
  800d21:	ff 4d fc             	decl   -0x4(%ebp)
  800d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d27:	8a 10                	mov    (%eax),%dl
  800d29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d34:	89 55 10             	mov    %edx,0x10(%ebp)
  800d37:	85 c0                	test   %eax,%eax
  800d39:	75 e3                	jne    800d1e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d3b:	eb 23                	jmp    800d60 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d40:	8d 50 01             	lea    0x1(%eax),%edx
  800d43:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d46:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d4f:	8a 12                	mov    (%edx),%dl
  800d51:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d53:	8b 45 10             	mov    0x10(%ebp),%eax
  800d56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d59:	89 55 10             	mov    %edx,0x10(%ebp)
  800d5c:	85 c0                	test   %eax,%eax
  800d5e:	75 dd                	jne    800d3d <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d77:	eb 2a                	jmp    800da3 <memcmp+0x3e>
		if (*s1 != *s2)
  800d79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7c:	8a 10                	mov    (%eax),%dl
  800d7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	38 c2                	cmp    %al,%dl
  800d85:	74 16                	je     800d9d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	0f b6 d0             	movzbl %al,%edx
  800d8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	0f b6 c0             	movzbl %al,%eax
  800d97:	29 c2                	sub    %eax,%edx
  800d99:	89 d0                	mov    %edx,%eax
  800d9b:	eb 18                	jmp    800db5 <memcmp+0x50>
		s1++, s2++;
  800d9d:	ff 45 fc             	incl   -0x4(%ebp)
  800da0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800da3:	8b 45 10             	mov    0x10(%ebp),%eax
  800da6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dac:	85 c0                	test   %eax,%eax
  800dae:	75 c9                	jne    800d79 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800db0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db5:	c9                   	leave  
  800db6:	c3                   	ret    

00800db7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	01 d0                	add    %edx,%eax
  800dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dc8:	eb 15                	jmp    800ddf <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	0f b6 d0             	movzbl %al,%edx
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	0f b6 c0             	movzbl %al,%eax
  800dd8:	39 c2                	cmp    %eax,%edx
  800dda:	74 0d                	je     800de9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ddc:	ff 45 08             	incl   0x8(%ebp)
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800de5:	72 e3                	jb     800dca <memfind+0x13>
  800de7:	eb 01                	jmp    800dea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800de9:	90                   	nop
	return (void *) s;
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800df5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800dfc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e03:	eb 03                	jmp    800e08 <strtol+0x19>
		s++;
  800e05:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	3c 20                	cmp    $0x20,%al
  800e0f:	74 f4                	je     800e05 <strtol+0x16>
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	8a 00                	mov    (%eax),%al
  800e16:	3c 09                	cmp    $0x9,%al
  800e18:	74 eb                	je     800e05 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	3c 2b                	cmp    $0x2b,%al
  800e21:	75 05                	jne    800e28 <strtol+0x39>
		s++;
  800e23:	ff 45 08             	incl   0x8(%ebp)
  800e26:	eb 13                	jmp    800e3b <strtol+0x4c>
	else if (*s == '-')
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 2d                	cmp    $0x2d,%al
  800e2f:	75 0a                	jne    800e3b <strtol+0x4c>
		s++, neg = 1;
  800e31:	ff 45 08             	incl   0x8(%ebp)
  800e34:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e3f:	74 06                	je     800e47 <strtol+0x58>
  800e41:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e45:	75 20                	jne    800e67 <strtol+0x78>
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	3c 30                	cmp    $0x30,%al
  800e4e:	75 17                	jne    800e67 <strtol+0x78>
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	40                   	inc    %eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	3c 78                	cmp    $0x78,%al
  800e58:	75 0d                	jne    800e67 <strtol+0x78>
		s += 2, base = 16;
  800e5a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e5e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e65:	eb 28                	jmp    800e8f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e6b:	75 15                	jne    800e82 <strtol+0x93>
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	8a 00                	mov    (%eax),%al
  800e72:	3c 30                	cmp    $0x30,%al
  800e74:	75 0c                	jne    800e82 <strtol+0x93>
		s++, base = 8;
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e80:	eb 0d                	jmp    800e8f <strtol+0xa0>
	else if (base == 0)
  800e82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e86:	75 07                	jne    800e8f <strtol+0xa0>
		base = 10;
  800e88:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	8a 00                	mov    (%eax),%al
  800e94:	3c 2f                	cmp    $0x2f,%al
  800e96:	7e 19                	jle    800eb1 <strtol+0xc2>
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	3c 39                	cmp    $0x39,%al
  800e9f:	7f 10                	jg     800eb1 <strtol+0xc2>
			dig = *s - '0';
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	0f be c0             	movsbl %al,%eax
  800ea9:	83 e8 30             	sub    $0x30,%eax
  800eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800eaf:	eb 42                	jmp    800ef3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	8a 00                	mov    (%eax),%al
  800eb6:	3c 60                	cmp    $0x60,%al
  800eb8:	7e 19                	jle    800ed3 <strtol+0xe4>
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3c 7a                	cmp    $0x7a,%al
  800ec1:	7f 10                	jg     800ed3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	0f be c0             	movsbl %al,%eax
  800ecb:	83 e8 57             	sub    $0x57,%eax
  800ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ed1:	eb 20                	jmp    800ef3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	8a 00                	mov    (%eax),%al
  800ed8:	3c 40                	cmp    $0x40,%al
  800eda:	7e 39                	jle    800f15 <strtol+0x126>
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	3c 5a                	cmp    $0x5a,%al
  800ee3:	7f 30                	jg     800f15 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	0f be c0             	movsbl %al,%eax
  800eed:	83 e8 37             	sub    $0x37,%eax
  800ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef9:	7d 19                	jge    800f14 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800efb:	ff 45 08             	incl   0x8(%ebp)
  800efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f01:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f05:	89 c2                	mov    %eax,%edx
  800f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f0a:	01 d0                	add    %edx,%eax
  800f0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f0f:	e9 7b ff ff ff       	jmp    800e8f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f14:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f19:	74 08                	je     800f23 <strtol+0x134>
		*endptr = (char *) s;
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f27:	74 07                	je     800f30 <strtol+0x141>
  800f29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2c:	f7 d8                	neg    %eax
  800f2e:	eb 03                	jmp    800f33 <strtol+0x144>
  800f30:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f33:	c9                   	leave  
  800f34:	c3                   	ret    

00800f35 <ltostr>:

void
ltostr(long value, char *str)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f42:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f4d:	79 13                	jns    800f62 <ltostr+0x2d>
	{
		neg = 1;
  800f4f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f5c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f5f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f6a:	99                   	cltd   
  800f6b:	f7 f9                	idiv   %ecx
  800f6d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f73:	8d 50 01             	lea    0x1(%eax),%edx
  800f76:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f79:	89 c2                	mov    %eax,%edx
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	01 d0                	add    %edx,%eax
  800f80:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f83:	83 c2 30             	add    $0x30,%edx
  800f86:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f8b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f90:	f7 e9                	imul   %ecx
  800f92:	c1 fa 02             	sar    $0x2,%edx
  800f95:	89 c8                	mov    %ecx,%eax
  800f97:	c1 f8 1f             	sar    $0x1f,%eax
  800f9a:	29 c2                	sub    %eax,%edx
  800f9c:	89 d0                	mov    %edx,%eax
  800f9e:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800fa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa5:	75 bb                	jne    800f62 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fa7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb1:	48                   	dec    %eax
  800fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fb5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fb9:	74 3d                	je     800ff8 <ltostr+0xc3>
		start = 1 ;
  800fbb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fc2:	eb 34                	jmp    800ff8 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fca:	01 d0                	add    %edx,%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	01 c2                	add    %eax,%edx
  800fd9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 c8                	add    %ecx,%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fe5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	01 c2                	add    %eax,%edx
  800fed:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ff0:	88 02                	mov    %al,(%edx)
		start++ ;
  800ff2:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ff5:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ffe:	7c c4                	jl     800fc4 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801000:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801003:	8b 45 0c             	mov    0xc(%ebp),%eax
  801006:	01 d0                	add    %edx,%eax
  801008:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80100b:	90                   	nop
  80100c:	c9                   	leave  
  80100d:	c3                   	ret    

0080100e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801014:	ff 75 08             	pushl  0x8(%ebp)
  801017:	e8 73 fa ff ff       	call   800a8f <strlen>
  80101c:	83 c4 04             	add    $0x4,%esp
  80101f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801022:	ff 75 0c             	pushl  0xc(%ebp)
  801025:	e8 65 fa ff ff       	call   800a8f <strlen>
  80102a:	83 c4 04             	add    $0x4,%esp
  80102d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801030:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801037:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80103e:	eb 17                	jmp    801057 <strcconcat+0x49>
		final[s] = str1[s] ;
  801040:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801043:	8b 45 10             	mov    0x10(%ebp),%eax
  801046:	01 c2                	add    %eax,%edx
  801048:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	01 c8                	add    %ecx,%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801054:	ff 45 fc             	incl   -0x4(%ebp)
  801057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80105a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80105d:	7c e1                	jl     801040 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80105f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801066:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80106d:	eb 1f                	jmp    80108e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80106f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801072:	8d 50 01             	lea    0x1(%eax),%edx
  801075:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801078:	89 c2                	mov    %eax,%edx
  80107a:	8b 45 10             	mov    0x10(%ebp),%eax
  80107d:	01 c2                	add    %eax,%edx
  80107f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801082:	8b 45 0c             	mov    0xc(%ebp),%eax
  801085:	01 c8                	add    %ecx,%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80108b:	ff 45 f8             	incl   -0x8(%ebp)
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801094:	7c d9                	jl     80106f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801096:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	c6 00 00             	movb   $0x0,(%eax)
}
  8010a1:	90                   	nop
  8010a2:	c9                   	leave  
  8010a3:	c3                   	ret    

008010a4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b3:	8b 00                	mov    (%eax),%eax
  8010b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bf:	01 d0                	add    %edx,%eax
  8010c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010c7:	eb 0c                	jmp    8010d5 <strsplit+0x31>
			*string++ = 0;
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8d 50 01             	lea    0x1(%eax),%edx
  8010cf:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	84 c0                	test   %al,%al
  8010dc:	74 18                	je     8010f6 <strsplit+0x52>
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e1:	8a 00                	mov    (%eax),%al
  8010e3:	0f be c0             	movsbl %al,%eax
  8010e6:	50                   	push   %eax
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	e8 32 fb ff ff       	call   800c21 <strchr>
  8010ef:	83 c4 08             	add    $0x8,%esp
  8010f2:	85 c0                	test   %eax,%eax
  8010f4:	75 d3                	jne    8010c9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 5a                	je     801159 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801102:	8b 00                	mov    (%eax),%eax
  801104:	83 f8 0f             	cmp    $0xf,%eax
  801107:	75 07                	jne    801110 <strsplit+0x6c>
		{
			return 0;
  801109:	b8 00 00 00 00       	mov    $0x0,%eax
  80110e:	eb 66                	jmp    801176 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801110:	8b 45 14             	mov    0x14(%ebp),%eax
  801113:	8b 00                	mov    (%eax),%eax
  801115:	8d 48 01             	lea    0x1(%eax),%ecx
  801118:	8b 55 14             	mov    0x14(%ebp),%edx
  80111b:	89 0a                	mov    %ecx,(%edx)
  80111d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801124:	8b 45 10             	mov    0x10(%ebp),%eax
  801127:	01 c2                	add    %eax,%edx
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80112e:	eb 03                	jmp    801133 <strsplit+0x8f>
			string++;
  801130:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	84 c0                	test   %al,%al
  80113a:	74 8b                	je     8010c7 <strsplit+0x23>
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	50                   	push   %eax
  801145:	ff 75 0c             	pushl  0xc(%ebp)
  801148:	e8 d4 fa ff ff       	call   800c21 <strchr>
  80114d:	83 c4 08             	add    $0x8,%esp
  801150:	85 c0                	test   %eax,%eax
  801152:	74 dc                	je     801130 <strsplit+0x8c>
			string++;
	}
  801154:	e9 6e ff ff ff       	jmp    8010c7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801159:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80115a:	8b 45 14             	mov    0x14(%ebp),%eax
  80115d:	8b 00                	mov    (%eax),%eax
  80115f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 d0                	add    %edx,%eax
  80116b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801171:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
  80117b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	68 a8 22 80 00       	push   $0x8022a8
  801186:	68 3f 01 00 00       	push   $0x13f
  80118b:	68 ca 22 80 00       	push   $0x8022ca
  801190:	e8 c6 07 00 00       	call   80195b <_panic>

00801195 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80119b:	83 ec 0c             	sub    $0xc,%esp
  80119e:	ff 75 08             	pushl  0x8(%ebp)
  8011a1:	e8 ef 06 00 00       	call   801895 <sys_sbrk>
  8011a6:	83 c4 10             	add    $0x10,%esp
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8011b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b5:	75 07                	jne    8011be <malloc+0x13>
  8011b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bc:	eb 14                	jmp    8011d2 <malloc+0x27>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #12] [3] USER HEAP [USER SIDE] - malloc()
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8011be:	83 ec 04             	sub    $0x4,%esp
  8011c1:	68 d8 22 80 00       	push   $0x8022d8
  8011c6:	6a 1b                	push   $0x1b
  8011c8:	68 fd 22 80 00       	push   $0x8022fd
  8011cd:	e8 89 07 00 00       	call   80195b <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8011d2:	c9                   	leave  
  8011d3:	c3                   	ret    

008011d4 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8011d4:	55                   	push   %ebp
  8011d5:	89 e5                	mov    %esp,%ebp
  8011d7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8011da:	83 ec 04             	sub    $0x4,%esp
  8011dd:	68 0c 23 80 00       	push   $0x80230c
  8011e2:	6a 29                	push   $0x29
  8011e4:	68 fd 22 80 00       	push   $0x8022fd
  8011e9:	e8 6d 07 00 00       	call   80195b <_panic>

008011ee <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 18             	sub    $0x18,%esp
  8011f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f7:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8011fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011fe:	75 07                	jne    801207 <smalloc+0x19>
  801200:	b8 00 00 00 00       	mov    $0x0,%eax
  801205:	eb 14                	jmp    80121b <smalloc+0x2d>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801207:	83 ec 04             	sub    $0x4,%esp
  80120a:	68 30 23 80 00       	push   $0x802330
  80120f:	6a 38                	push   $0x38
  801211:	68 fd 22 80 00       	push   $0x8022fd
  801216:	e8 40 07 00 00       	call   80195b <_panic>
	return NULL;
}
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	68 58 23 80 00       	push   $0x802358
  80122b:	6a 43                	push   $0x43
  80122d:	68 fd 22 80 00       	push   $0x8022fd
  801232:	e8 24 07 00 00       	call   80195b <_panic>

00801237 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80123d:	83 ec 04             	sub    $0x4,%esp
  801240:	68 7c 23 80 00       	push   $0x80237c
  801245:	6a 5b                	push   $0x5b
  801247:	68 fd 22 80 00       	push   $0x8022fd
  80124c:	e8 0a 07 00 00       	call   80195b <_panic>

00801251 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801257:	83 ec 04             	sub    $0x4,%esp
  80125a:	68 a0 23 80 00       	push   $0x8023a0
  80125f:	6a 72                	push   $0x72
  801261:	68 fd 22 80 00       	push   $0x8022fd
  801266:	e8 f0 06 00 00       	call   80195b <_panic>

0080126b <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801271:	83 ec 04             	sub    $0x4,%esp
  801274:	68 c6 23 80 00       	push   $0x8023c6
  801279:	6a 7e                	push   $0x7e
  80127b:	68 fd 22 80 00       	push   $0x8022fd
  801280:	e8 d6 06 00 00       	call   80195b <_panic>

00801285 <shrink>:

}
void shrink(uint32 newSize)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80128b:	83 ec 04             	sub    $0x4,%esp
  80128e:	68 c6 23 80 00       	push   $0x8023c6
  801293:	68 83 00 00 00       	push   $0x83
  801298:	68 fd 22 80 00       	push   $0x8022fd
  80129d:	e8 b9 06 00 00       	call   80195b <_panic>

008012a2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8012a2:	55                   	push   %ebp
  8012a3:	89 e5                	mov    %esp,%ebp
  8012a5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8012a8:	83 ec 04             	sub    $0x4,%esp
  8012ab:	68 c6 23 80 00       	push   $0x8023c6
  8012b0:	68 88 00 00 00       	push   $0x88
  8012b5:	68 fd 22 80 00       	push   $0x8022fd
  8012ba:	e8 9c 06 00 00       	call   80195b <_panic>

008012bf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	57                   	push   %edi
  8012c3:	56                   	push   %esi
  8012c4:	53                   	push   %ebx
  8012c5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012d7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012da:	cd 30                	int    $0x30
  8012dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	5b                   	pop    %ebx
  8012e6:	5e                   	pop    %esi
  8012e7:	5f                   	pop    %edi
  8012e8:	5d                   	pop    %ebp
  8012e9:	c3                   	ret    

008012ea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	83 ec 04             	sub    $0x4,%esp
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	6a 00                	push   $0x0
  8012ff:	6a 00                	push   $0x0
  801301:	52                   	push   %edx
  801302:	ff 75 0c             	pushl  0xc(%ebp)
  801305:	50                   	push   %eax
  801306:	6a 00                	push   $0x0
  801308:	e8 b2 ff ff ff       	call   8012bf <syscall>
  80130d:	83 c4 18             	add    $0x18,%esp
}
  801310:	90                   	nop
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <sys_cgetc>:

int
sys_cgetc(void)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801316:	6a 00                	push   $0x0
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 02                	push   $0x2
  801322:	e8 98 ff ff ff       	call   8012bf <syscall>
  801327:	83 c4 18             	add    $0x18,%esp
}
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <sys_lock_cons>:

void sys_lock_cons(void)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 03                	push   $0x3
  80133b:	e8 7f ff ff ff       	call   8012bf <syscall>
  801340:	83 c4 18             	add    $0x18,%esp
}
  801343:	90                   	nop
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 04                	push   $0x4
  801355:	e8 65 ff ff ff       	call   8012bf <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
}
  80135d:	90                   	nop
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801363:	8b 55 0c             	mov    0xc(%ebp),%edx
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	52                   	push   %edx
  801370:	50                   	push   %eax
  801371:	6a 08                	push   $0x8
  801373:	e8 47 ff ff ff       	call   8012bf <syscall>
  801378:	83 c4 18             	add    $0x18,%esp
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
  801380:	56                   	push   %esi
  801381:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801382:	8b 75 18             	mov    0x18(%ebp),%esi
  801385:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801388:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80138b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	56                   	push   %esi
  801392:	53                   	push   %ebx
  801393:	51                   	push   %ecx
  801394:	52                   	push   %edx
  801395:	50                   	push   %eax
  801396:	6a 09                	push   $0x9
  801398:	e8 22 ff ff ff       	call   8012bf <syscall>
  80139d:	83 c4 18             	add    $0x18,%esp
}
  8013a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a3:	5b                   	pop    %ebx
  8013a4:	5e                   	pop    %esi
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	52                   	push   %edx
  8013b7:	50                   	push   %eax
  8013b8:	6a 0a                	push   $0xa
  8013ba:	e8 00 ff ff ff       	call   8012bf <syscall>
  8013bf:	83 c4 18             	add    $0x18,%esp
}
  8013c2:	c9                   	leave  
  8013c3:	c3                   	ret    

008013c4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013c7:	6a 00                	push   $0x0
  8013c9:	6a 00                	push   $0x0
  8013cb:	6a 00                	push   $0x0
  8013cd:	ff 75 0c             	pushl  0xc(%ebp)
  8013d0:	ff 75 08             	pushl  0x8(%ebp)
  8013d3:	6a 0b                	push   $0xb
  8013d5:	e8 e5 fe ff ff       	call   8012bf <syscall>
  8013da:	83 c4 18             	add    $0x18,%esp
}
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    

008013df <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013e2:	6a 00                	push   $0x0
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 0c                	push   $0xc
  8013ee:	e8 cc fe ff ff       	call   8012bf <syscall>
  8013f3:	83 c4 18             	add    $0x18,%esp
}
  8013f6:	c9                   	leave  
  8013f7:	c3                   	ret    

008013f8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013fb:	6a 00                	push   $0x0
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 0d                	push   $0xd
  801407:	e8 b3 fe ff ff       	call   8012bf <syscall>
  80140c:	83 c4 18             	add    $0x18,%esp
}
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 0e                	push   $0xe
  801420:	e8 9a fe ff ff       	call   8012bf <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 0f                	push   $0xf
  801439:	e8 81 fe ff ff       	call   8012bf <syscall>
  80143e:	83 c4 18             	add    $0x18,%esp
}
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	ff 75 08             	pushl  0x8(%ebp)
  801451:	6a 10                	push   $0x10
  801453:	e8 67 fe ff ff       	call   8012bf <syscall>
  801458:	83 c4 18             	add    $0x18,%esp
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 11                	push   $0x11
  80146c:	e8 4e fe ff ff       	call   8012bf <syscall>
  801471:	83 c4 18             	add    $0x18,%esp
}
  801474:	90                   	nop
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <sys_cputc>:

void
sys_cputc(const char c)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801483:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	50                   	push   %eax
  801490:	6a 01                	push   $0x1
  801492:	e8 28 fe ff ff       	call   8012bf <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
}
  80149a:	90                   	nop
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 14                	push   $0x14
  8014ac:	e8 0e fe ff ff       	call   8012bf <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
}
  8014b4:	90                   	nop
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014c3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014c6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cd:	6a 00                	push   $0x0
  8014cf:	51                   	push   %ecx
  8014d0:	52                   	push   %edx
  8014d1:	ff 75 0c             	pushl  0xc(%ebp)
  8014d4:	50                   	push   %eax
  8014d5:	6a 15                	push   $0x15
  8014d7:	e8 e3 fd ff ff       	call   8012bf <syscall>
  8014dc:	83 c4 18             	add    $0x18,%esp
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	52                   	push   %edx
  8014f1:	50                   	push   %eax
  8014f2:	6a 16                	push   $0x16
  8014f4:	e8 c6 fd ff ff       	call   8012bf <syscall>
  8014f9:	83 c4 18             	add    $0x18,%esp
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801501:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801504:	8b 55 0c             	mov    0xc(%ebp),%edx
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	51                   	push   %ecx
  80150f:	52                   	push   %edx
  801510:	50                   	push   %eax
  801511:	6a 17                	push   $0x17
  801513:	e8 a7 fd ff ff       	call   8012bf <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801520:	8b 55 0c             	mov    0xc(%ebp),%edx
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	52                   	push   %edx
  80152d:	50                   	push   %eax
  80152e:	6a 18                	push   $0x18
  801530:	e8 8a fd ff ff       	call   8012bf <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80153d:	8b 45 08             	mov    0x8(%ebp),%eax
  801540:	6a 00                	push   $0x0
  801542:	ff 75 14             	pushl  0x14(%ebp)
  801545:	ff 75 10             	pushl  0x10(%ebp)
  801548:	ff 75 0c             	pushl  0xc(%ebp)
  80154b:	50                   	push   %eax
  80154c:	6a 19                	push   $0x19
  80154e:	e8 6c fd ff ff       	call   8012bf <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_run_env>:

void sys_run_env(int32 envId)
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	50                   	push   %eax
  801567:	6a 1a                	push   $0x1a
  801569:	e8 51 fd ff ff       	call   8012bf <syscall>
  80156e:	83 c4 18             	add    $0x18,%esp
}
  801571:	90                   	nop
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	6a 00                	push   $0x0
  801582:	50                   	push   %eax
  801583:	6a 1b                	push   $0x1b
  801585:	e8 35 fd ff ff       	call   8012bf <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 05                	push   $0x5
  80159e:	e8 1c fd ff ff       	call   8012bf <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 06                	push   $0x6
  8015b7:	e8 03 fd ff ff       	call   8012bf <syscall>
  8015bc:	83 c4 18             	add    $0x18,%esp
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 07                	push   $0x7
  8015d0:	e8 ea fc ff ff       	call   8012bf <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sys_exit_env>:


void sys_exit_env(void)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 1c                	push   $0x1c
  8015e9:	e8 d1 fc ff ff       	call   8012bf <syscall>
  8015ee:	83 c4 18             	add    $0x18,%esp
}
  8015f1:	90                   	nop
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8015fa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015fd:	8d 50 04             	lea    0x4(%eax),%edx
  801600:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	52                   	push   %edx
  80160a:	50                   	push   %eax
  80160b:	6a 1d                	push   $0x1d
  80160d:	e8 ad fc ff ff       	call   8012bf <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
	return result;
  801615:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801618:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80161b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80161e:	89 01                	mov    %eax,(%ecx)
  801620:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	c9                   	leave  
  801627:	c2 04 00             	ret    $0x4

0080162a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	ff 75 10             	pushl  0x10(%ebp)
  801634:	ff 75 0c             	pushl  0xc(%ebp)
  801637:	ff 75 08             	pushl  0x8(%ebp)
  80163a:	6a 13                	push   $0x13
  80163c:	e8 7e fc ff ff       	call   8012bf <syscall>
  801641:	83 c4 18             	add    $0x18,%esp
	return ;
  801644:	90                   	nop
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_rcr2>:
uint32 sys_rcr2()
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 1e                	push   $0x1e
  801656:	e8 64 fc ff ff       	call   8012bf <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 04             	sub    $0x4,%esp
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80166c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	50                   	push   %eax
  801679:	6a 1f                	push   $0x1f
  80167b:	e8 3f fc ff ff       	call   8012bf <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
	return ;
  801683:	90                   	nop
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <rsttst>:
void rsttst()
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 21                	push   $0x21
  801695:	e8 25 fc ff ff       	call   8012bf <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
	return ;
  80169d:	90                   	nop
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016ac:	8b 55 18             	mov    0x18(%ebp),%edx
  8016af:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016b3:	52                   	push   %edx
  8016b4:	50                   	push   %eax
  8016b5:	ff 75 10             	pushl  0x10(%ebp)
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	6a 20                	push   $0x20
  8016c0:	e8 fa fb ff ff       	call   8012bf <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c8:	90                   	nop
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <chktst>:
void chktst(uint32 n)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	6a 22                	push   $0x22
  8016db:	e8 df fb ff ff       	call   8012bf <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e3:	90                   	nop
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <inctst>:

void inctst()
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 23                	push   $0x23
  8016f5:	e8 c5 fb ff ff       	call   8012bf <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8016fd:	90                   	nop
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <gettst>:
uint32 gettst()
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 24                	push   $0x24
  80170f:	e8 ab fb ff ff       	call   8012bf <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 25                	push   $0x25
  80172b:	e8 8f fb ff ff       	call   8012bf <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
  801733:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801736:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80173a:	75 07                	jne    801743 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80173c:	b8 01 00 00 00       	mov    $0x1,%eax
  801741:	eb 05                	jmp    801748 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 25                	push   $0x25
  80175c:	e8 5e fb ff ff       	call   8012bf <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
  801764:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801767:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80176b:	75 07                	jne    801774 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80176d:	b8 01 00 00 00       	mov    $0x1,%eax
  801772:	eb 05                	jmp    801779 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801774:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 25                	push   $0x25
  80178d:	e8 2d fb ff ff       	call   8012bf <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
  801795:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801798:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80179c:	75 07                	jne    8017a5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80179e:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a3:	eb 05                	jmp    8017aa <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 25                	push   $0x25
  8017be:	e8 fc fa ff ff       	call   8012bf <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
  8017c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017c9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017cd:	75 07                	jne    8017d6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017cf:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d4:	eb 05                	jmp    8017db <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	ff 75 08             	pushl  0x8(%ebp)
  8017eb:	6a 26                	push   $0x26
  8017ed:	e8 cd fa ff ff       	call   8012bf <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f5:	90                   	nop
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8017fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801802:	8b 55 0c             	mov    0xc(%ebp),%edx
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	53                   	push   %ebx
  80180b:	51                   	push   %ecx
  80180c:	52                   	push   %edx
  80180d:	50                   	push   %eax
  80180e:	6a 27                	push   $0x27
  801810:	e8 aa fa ff ff       	call   8012bf <syscall>
  801815:	83 c4 18             	add    $0x18,%esp
}
  801818:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801820:	8b 55 0c             	mov    0xc(%ebp),%edx
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	52                   	push   %edx
  80182d:	50                   	push   %eax
  80182e:	6a 28                	push   $0x28
  801830:	e8 8a fa ff ff       	call   8012bf <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  80183d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801840:	8b 55 0c             	mov    0xc(%ebp),%edx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	6a 00                	push   $0x0
  801848:	51                   	push   %ecx
  801849:	ff 75 10             	pushl  0x10(%ebp)
  80184c:	52                   	push   %edx
  80184d:	50                   	push   %eax
  80184e:	6a 29                	push   $0x29
  801850:	e8 6a fa ff ff       	call   8012bf <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	ff 75 10             	pushl  0x10(%ebp)
  801864:	ff 75 0c             	pushl  0xc(%ebp)
  801867:	ff 75 08             	pushl  0x8(%ebp)
  80186a:	6a 12                	push   $0x12
  80186c:	e8 4e fa ff ff       	call   8012bf <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
	return ;
  801874:	90                   	nop
}
  801875:	c9                   	leave  
  801876:	c3                   	ret    

00801877 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80187a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	52                   	push   %edx
  801887:	50                   	push   %eax
  801888:	6a 2a                	push   $0x2a
  80188a:	e8 30 fa ff ff       	call   8012bf <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
	return;
  801892:	90                   	nop
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*)syscall(SYS_sbrk,increment,0,0,0,0);
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	50                   	push   %eax
  8018a4:	6a 2b                	push   $0x2b
  8018a6:	e8 14 fa ff ff       	call   8012bf <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_free_user_mem,virtual_address,size,0,0,0);
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	ff 75 08             	pushl  0x8(%ebp)
  8018bf:	6a 2c                	push   $0x2c
  8018c1:	e8 f9 f9 ff ff       	call   8012bf <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
	return;
  8018c9:	90                   	nop
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	syscall(SYS_allocate_user_mem,virtual_address,size,0,0,0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	ff 75 08             	pushl  0x8(%ebp)
  8018db:	6a 2d                	push   $0x2d
  8018dd:	e8 dd f9 ff ff       	call   8012bf <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
	return;
  8018e5:	90                   	nop
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	68 d8 23 80 00       	push   $0x8023d8
  8018f6:	6a 09                	push   $0x9
  8018f8:	68 00 24 80 00       	push   $0x802400
  8018fd:	e8 59 00 00 00       	call   80195b <_panic>

00801902 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	68 10 24 80 00       	push   $0x802410
  801910:	6a 10                	push   $0x10
  801912:	68 00 24 80 00       	push   $0x802400
  801917:	e8 3f 00 00 00       	call   80195b <_panic>

0080191c <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	68 38 24 80 00       	push   $0x802438
  80192a:	6a 18                	push   $0x18
  80192c:	68 00 24 80 00       	push   $0x802400
  801931:	e8 25 00 00 00       	call   80195b <_panic>

00801936 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	68 60 24 80 00       	push   $0x802460
  801944:	6a 20                	push   $0x20
  801946:	68 00 24 80 00       	push   $0x802400
  80194b:	e8 0b 00 00 00       	call   80195b <_panic>

00801950 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8b 40 10             	mov    0x10(%eax),%eax
}
  801959:	5d                   	pop    %ebp
  80195a:	c3                   	ret    

0080195b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801961:	8d 45 10             	lea    0x10(%ebp),%eax
  801964:	83 c0 04             	add    $0x4,%eax
  801967:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80196a:	a1 24 30 80 00       	mov    0x803024,%eax
  80196f:	85 c0                	test   %eax,%eax
  801971:	74 16                	je     801989 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801973:	a1 24 30 80 00       	mov    0x803024,%eax
  801978:	83 ec 08             	sub    $0x8,%esp
  80197b:	50                   	push   %eax
  80197c:	68 88 24 80 00       	push   $0x802488
  801981:	e8 75 ea ff ff       	call   8003fb <cprintf>
  801986:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801989:	a1 00 30 80 00       	mov    0x803000,%eax
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	50                   	push   %eax
  801995:	68 8d 24 80 00       	push   $0x80248d
  80199a:	e8 5c ea ff ff       	call   8003fb <cprintf>
  80199f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8019a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a5:	83 ec 08             	sub    $0x8,%esp
  8019a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ab:	50                   	push   %eax
  8019ac:	e8 df e9 ff ff       	call   800390 <vcprintf>
  8019b1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8019b4:	83 ec 08             	sub    $0x8,%esp
  8019b7:	6a 00                	push   $0x0
  8019b9:	68 a9 24 80 00       	push   $0x8024a9
  8019be:	e8 cd e9 ff ff       	call   800390 <vcprintf>
  8019c3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019c6:	e8 4e e9 ff ff       	call   800319 <exit>

	// should not return here
	while (1) ;
  8019cb:	eb fe                	jmp    8019cb <_panic+0x70>

008019cd <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019d3:	a1 04 30 80 00       	mov    0x803004,%eax
  8019d8:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e1:	39 c2                	cmp    %eax,%edx
  8019e3:	74 14                	je     8019f9 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	68 ac 24 80 00       	push   $0x8024ac
  8019ed:	6a 26                	push   $0x26
  8019ef:	68 f8 24 80 00       	push   $0x8024f8
  8019f4:	e8 62 ff ff ff       	call   80195b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8019f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a07:	e9 c5 00 00 00       	jmp    801ad1 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	01 d0                	add    %edx,%eax
  801a1b:	8b 00                	mov    (%eax),%eax
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	75 08                	jne    801a29 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a21:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a24:	e9 a5 00 00 00       	jmp    801ace <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a29:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a30:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a37:	eb 69                	jmp    801aa2 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a39:	a1 04 30 80 00       	mov    0x803004,%eax
  801a3e:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801a44:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a47:	89 d0                	mov    %edx,%eax
  801a49:	01 c0                	add    %eax,%eax
  801a4b:	01 d0                	add    %edx,%eax
  801a4d:	c1 e0 03             	shl    $0x3,%eax
  801a50:	01 c8                	add    %ecx,%eax
  801a52:	8a 40 04             	mov    0x4(%eax),%al
  801a55:	84 c0                	test   %al,%al
  801a57:	75 46                	jne    801a9f <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a59:	a1 04 30 80 00       	mov    0x803004,%eax
  801a5e:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801a64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a67:	89 d0                	mov    %edx,%eax
  801a69:	01 c0                	add    %eax,%eax
  801a6b:	01 d0                	add    %edx,%eax
  801a6d:	c1 e0 03             	shl    $0x3,%eax
  801a70:	01 c8                	add    %ecx,%eax
  801a72:	8b 00                	mov    (%eax),%eax
  801a74:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a7f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a84:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	01 c8                	add    %ecx,%eax
  801a90:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a92:	39 c2                	cmp    %eax,%edx
  801a94:	75 09                	jne    801a9f <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801a96:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801a9d:	eb 15                	jmp    801ab4 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a9f:	ff 45 e8             	incl   -0x18(%ebp)
  801aa2:	a1 04 30 80 00       	mov    0x803004,%eax
  801aa7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801aad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ab0:	39 c2                	cmp    %eax,%edx
  801ab2:	77 85                	ja     801a39 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801ab4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ab8:	75 14                	jne    801ace <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801aba:	83 ec 04             	sub    $0x4,%esp
  801abd:	68 04 25 80 00       	push   $0x802504
  801ac2:	6a 3a                	push   $0x3a
  801ac4:	68 f8 24 80 00       	push   $0x8024f8
  801ac9:	e8 8d fe ff ff       	call   80195b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801ace:	ff 45 f0             	incl   -0x10(%ebp)
  801ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ad7:	0f 8c 2f ff ff ff    	jl     801a0c <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801add:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ae4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801aeb:	eb 26                	jmp    801b13 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801aed:	a1 04 30 80 00       	mov    0x803004,%eax
  801af2:	8b 88 7c 05 00 00    	mov    0x57c(%eax),%ecx
  801af8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801afb:	89 d0                	mov    %edx,%eax
  801afd:	01 c0                	add    %eax,%eax
  801aff:	01 d0                	add    %edx,%eax
  801b01:	c1 e0 03             	shl    $0x3,%eax
  801b04:	01 c8                	add    %ecx,%eax
  801b06:	8a 40 04             	mov    0x4(%eax),%al
  801b09:	3c 01                	cmp    $0x1,%al
  801b0b:	75 03                	jne    801b10 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b0d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b10:	ff 45 e0             	incl   -0x20(%ebp)
  801b13:	a1 04 30 80 00       	mov    0x803004,%eax
  801b18:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b21:	39 c2                	cmp    %eax,%edx
  801b23:	77 c8                	ja     801aed <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b28:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b2b:	74 14                	je     801b41 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b2d:	83 ec 04             	sub    $0x4,%esp
  801b30:	68 58 25 80 00       	push   $0x802558
  801b35:	6a 44                	push   $0x44
  801b37:	68 f8 24 80 00       	push   $0x8024f8
  801b3c:	e8 1a fe ff ff       	call   80195b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b41:	90                   	nop
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <__udivdi3>:
  801b44:	55                   	push   %ebp
  801b45:	57                   	push   %edi
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	83 ec 1c             	sub    $0x1c,%esp
  801b4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b5b:	89 ca                	mov    %ecx,%edx
  801b5d:	89 f8                	mov    %edi,%eax
  801b5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b63:	85 f6                	test   %esi,%esi
  801b65:	75 2d                	jne    801b94 <__udivdi3+0x50>
  801b67:	39 cf                	cmp    %ecx,%edi
  801b69:	77 65                	ja     801bd0 <__udivdi3+0x8c>
  801b6b:	89 fd                	mov    %edi,%ebp
  801b6d:	85 ff                	test   %edi,%edi
  801b6f:	75 0b                	jne    801b7c <__udivdi3+0x38>
  801b71:	b8 01 00 00 00       	mov    $0x1,%eax
  801b76:	31 d2                	xor    %edx,%edx
  801b78:	f7 f7                	div    %edi
  801b7a:	89 c5                	mov    %eax,%ebp
  801b7c:	31 d2                	xor    %edx,%edx
  801b7e:	89 c8                	mov    %ecx,%eax
  801b80:	f7 f5                	div    %ebp
  801b82:	89 c1                	mov    %eax,%ecx
  801b84:	89 d8                	mov    %ebx,%eax
  801b86:	f7 f5                	div    %ebp
  801b88:	89 cf                	mov    %ecx,%edi
  801b8a:	89 fa                	mov    %edi,%edx
  801b8c:	83 c4 1c             	add    $0x1c,%esp
  801b8f:	5b                   	pop    %ebx
  801b90:	5e                   	pop    %esi
  801b91:	5f                   	pop    %edi
  801b92:	5d                   	pop    %ebp
  801b93:	c3                   	ret    
  801b94:	39 ce                	cmp    %ecx,%esi
  801b96:	77 28                	ja     801bc0 <__udivdi3+0x7c>
  801b98:	0f bd fe             	bsr    %esi,%edi
  801b9b:	83 f7 1f             	xor    $0x1f,%edi
  801b9e:	75 40                	jne    801be0 <__udivdi3+0x9c>
  801ba0:	39 ce                	cmp    %ecx,%esi
  801ba2:	72 0a                	jb     801bae <__udivdi3+0x6a>
  801ba4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ba8:	0f 87 9e 00 00 00    	ja     801c4c <__udivdi3+0x108>
  801bae:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb3:	89 fa                	mov    %edi,%edx
  801bb5:	83 c4 1c             	add    $0x1c,%esp
  801bb8:	5b                   	pop    %ebx
  801bb9:	5e                   	pop    %esi
  801bba:	5f                   	pop    %edi
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    
  801bbd:	8d 76 00             	lea    0x0(%esi),%esi
  801bc0:	31 ff                	xor    %edi,%edi
  801bc2:	31 c0                	xor    %eax,%eax
  801bc4:	89 fa                	mov    %edi,%edx
  801bc6:	83 c4 1c             	add    $0x1c,%esp
  801bc9:	5b                   	pop    %ebx
  801bca:	5e                   	pop    %esi
  801bcb:	5f                   	pop    %edi
  801bcc:	5d                   	pop    %ebp
  801bcd:	c3                   	ret    
  801bce:	66 90                	xchg   %ax,%ax
  801bd0:	89 d8                	mov    %ebx,%eax
  801bd2:	f7 f7                	div    %edi
  801bd4:	31 ff                	xor    %edi,%edi
  801bd6:	89 fa                	mov    %edi,%edx
  801bd8:	83 c4 1c             	add    $0x1c,%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5e                   	pop    %esi
  801bdd:	5f                   	pop    %edi
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    
  801be0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801be5:	89 eb                	mov    %ebp,%ebx
  801be7:	29 fb                	sub    %edi,%ebx
  801be9:	89 f9                	mov    %edi,%ecx
  801beb:	d3 e6                	shl    %cl,%esi
  801bed:	89 c5                	mov    %eax,%ebp
  801bef:	88 d9                	mov    %bl,%cl
  801bf1:	d3 ed                	shr    %cl,%ebp
  801bf3:	89 e9                	mov    %ebp,%ecx
  801bf5:	09 f1                	or     %esi,%ecx
  801bf7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bfb:	89 f9                	mov    %edi,%ecx
  801bfd:	d3 e0                	shl    %cl,%eax
  801bff:	89 c5                	mov    %eax,%ebp
  801c01:	89 d6                	mov    %edx,%esi
  801c03:	88 d9                	mov    %bl,%cl
  801c05:	d3 ee                	shr    %cl,%esi
  801c07:	89 f9                	mov    %edi,%ecx
  801c09:	d3 e2                	shl    %cl,%edx
  801c0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c0f:	88 d9                	mov    %bl,%cl
  801c11:	d3 e8                	shr    %cl,%eax
  801c13:	09 c2                	or     %eax,%edx
  801c15:	89 d0                	mov    %edx,%eax
  801c17:	89 f2                	mov    %esi,%edx
  801c19:	f7 74 24 0c          	divl   0xc(%esp)
  801c1d:	89 d6                	mov    %edx,%esi
  801c1f:	89 c3                	mov    %eax,%ebx
  801c21:	f7 e5                	mul    %ebp
  801c23:	39 d6                	cmp    %edx,%esi
  801c25:	72 19                	jb     801c40 <__udivdi3+0xfc>
  801c27:	74 0b                	je     801c34 <__udivdi3+0xf0>
  801c29:	89 d8                	mov    %ebx,%eax
  801c2b:	31 ff                	xor    %edi,%edi
  801c2d:	e9 58 ff ff ff       	jmp    801b8a <__udivdi3+0x46>
  801c32:	66 90                	xchg   %ax,%ax
  801c34:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c38:	89 f9                	mov    %edi,%ecx
  801c3a:	d3 e2                	shl    %cl,%edx
  801c3c:	39 c2                	cmp    %eax,%edx
  801c3e:	73 e9                	jae    801c29 <__udivdi3+0xe5>
  801c40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c43:	31 ff                	xor    %edi,%edi
  801c45:	e9 40 ff ff ff       	jmp    801b8a <__udivdi3+0x46>
  801c4a:	66 90                	xchg   %ax,%ax
  801c4c:	31 c0                	xor    %eax,%eax
  801c4e:	e9 37 ff ff ff       	jmp    801b8a <__udivdi3+0x46>
  801c53:	90                   	nop

00801c54 <__umoddi3>:
  801c54:	55                   	push   %ebp
  801c55:	57                   	push   %edi
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	83 ec 1c             	sub    $0x1c,%esp
  801c5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c73:	89 f3                	mov    %esi,%ebx
  801c75:	89 fa                	mov    %edi,%edx
  801c77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c7b:	89 34 24             	mov    %esi,(%esp)
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	75 1a                	jne    801c9c <__umoddi3+0x48>
  801c82:	39 f7                	cmp    %esi,%edi
  801c84:	0f 86 a2 00 00 00    	jbe    801d2c <__umoddi3+0xd8>
  801c8a:	89 c8                	mov    %ecx,%eax
  801c8c:	89 f2                	mov    %esi,%edx
  801c8e:	f7 f7                	div    %edi
  801c90:	89 d0                	mov    %edx,%eax
  801c92:	31 d2                	xor    %edx,%edx
  801c94:	83 c4 1c             	add    $0x1c,%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5e                   	pop    %esi
  801c99:	5f                   	pop    %edi
  801c9a:	5d                   	pop    %ebp
  801c9b:	c3                   	ret    
  801c9c:	39 f0                	cmp    %esi,%eax
  801c9e:	0f 87 ac 00 00 00    	ja     801d50 <__umoddi3+0xfc>
  801ca4:	0f bd e8             	bsr    %eax,%ebp
  801ca7:	83 f5 1f             	xor    $0x1f,%ebp
  801caa:	0f 84 ac 00 00 00    	je     801d5c <__umoddi3+0x108>
  801cb0:	bf 20 00 00 00       	mov    $0x20,%edi
  801cb5:	29 ef                	sub    %ebp,%edi
  801cb7:	89 fe                	mov    %edi,%esi
  801cb9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cbd:	89 e9                	mov    %ebp,%ecx
  801cbf:	d3 e0                	shl    %cl,%eax
  801cc1:	89 d7                	mov    %edx,%edi
  801cc3:	89 f1                	mov    %esi,%ecx
  801cc5:	d3 ef                	shr    %cl,%edi
  801cc7:	09 c7                	or     %eax,%edi
  801cc9:	89 e9                	mov    %ebp,%ecx
  801ccb:	d3 e2                	shl    %cl,%edx
  801ccd:	89 14 24             	mov    %edx,(%esp)
  801cd0:	89 d8                	mov    %ebx,%eax
  801cd2:	d3 e0                	shl    %cl,%eax
  801cd4:	89 c2                	mov    %eax,%edx
  801cd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cda:	d3 e0                	shl    %cl,%eax
  801cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ce4:	89 f1                	mov    %esi,%ecx
  801ce6:	d3 e8                	shr    %cl,%eax
  801ce8:	09 d0                	or     %edx,%eax
  801cea:	d3 eb                	shr    %cl,%ebx
  801cec:	89 da                	mov    %ebx,%edx
  801cee:	f7 f7                	div    %edi
  801cf0:	89 d3                	mov    %edx,%ebx
  801cf2:	f7 24 24             	mull   (%esp)
  801cf5:	89 c6                	mov    %eax,%esi
  801cf7:	89 d1                	mov    %edx,%ecx
  801cf9:	39 d3                	cmp    %edx,%ebx
  801cfb:	0f 82 87 00 00 00    	jb     801d88 <__umoddi3+0x134>
  801d01:	0f 84 91 00 00 00    	je     801d98 <__umoddi3+0x144>
  801d07:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d0b:	29 f2                	sub    %esi,%edx
  801d0d:	19 cb                	sbb    %ecx,%ebx
  801d0f:	89 d8                	mov    %ebx,%eax
  801d11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d15:	d3 e0                	shl    %cl,%eax
  801d17:	89 e9                	mov    %ebp,%ecx
  801d19:	d3 ea                	shr    %cl,%edx
  801d1b:	09 d0                	or     %edx,%eax
  801d1d:	89 e9                	mov    %ebp,%ecx
  801d1f:	d3 eb                	shr    %cl,%ebx
  801d21:	89 da                	mov    %ebx,%edx
  801d23:	83 c4 1c             	add    $0x1c,%esp
  801d26:	5b                   	pop    %ebx
  801d27:	5e                   	pop    %esi
  801d28:	5f                   	pop    %edi
  801d29:	5d                   	pop    %ebp
  801d2a:	c3                   	ret    
  801d2b:	90                   	nop
  801d2c:	89 fd                	mov    %edi,%ebp
  801d2e:	85 ff                	test   %edi,%edi
  801d30:	75 0b                	jne    801d3d <__umoddi3+0xe9>
  801d32:	b8 01 00 00 00       	mov    $0x1,%eax
  801d37:	31 d2                	xor    %edx,%edx
  801d39:	f7 f7                	div    %edi
  801d3b:	89 c5                	mov    %eax,%ebp
  801d3d:	89 f0                	mov    %esi,%eax
  801d3f:	31 d2                	xor    %edx,%edx
  801d41:	f7 f5                	div    %ebp
  801d43:	89 c8                	mov    %ecx,%eax
  801d45:	f7 f5                	div    %ebp
  801d47:	89 d0                	mov    %edx,%eax
  801d49:	e9 44 ff ff ff       	jmp    801c92 <__umoddi3+0x3e>
  801d4e:	66 90                	xchg   %ax,%ax
  801d50:	89 c8                	mov    %ecx,%eax
  801d52:	89 f2                	mov    %esi,%edx
  801d54:	83 c4 1c             	add    $0x1c,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5f                   	pop    %edi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    
  801d5c:	3b 04 24             	cmp    (%esp),%eax
  801d5f:	72 06                	jb     801d67 <__umoddi3+0x113>
  801d61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d65:	77 0f                	ja     801d76 <__umoddi3+0x122>
  801d67:	89 f2                	mov    %esi,%edx
  801d69:	29 f9                	sub    %edi,%ecx
  801d6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d6f:	89 14 24             	mov    %edx,(%esp)
  801d72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d76:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d7a:	8b 14 24             	mov    (%esp),%edx
  801d7d:	83 c4 1c             	add    $0x1c,%esp
  801d80:	5b                   	pop    %ebx
  801d81:	5e                   	pop    %esi
  801d82:	5f                   	pop    %edi
  801d83:	5d                   	pop    %ebp
  801d84:	c3                   	ret    
  801d85:	8d 76 00             	lea    0x0(%esi),%esi
  801d88:	2b 04 24             	sub    (%esp),%eax
  801d8b:	19 fa                	sbb    %edi,%edx
  801d8d:	89 d1                	mov    %edx,%ecx
  801d8f:	89 c6                	mov    %eax,%esi
  801d91:	e9 71 ff ff ff       	jmp    801d07 <__umoddi3+0xb3>
  801d96:	66 90                	xchg   %ax,%ax
  801d98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d9c:	72 ea                	jb     801d88 <__umoddi3+0x134>
  801d9e:	89 d9                	mov    %ebx,%ecx
  801da0:	e9 62 ff ff ff       	jmp    801d07 <__umoddi3+0xb3>
