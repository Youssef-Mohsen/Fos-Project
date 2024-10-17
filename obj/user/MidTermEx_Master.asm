
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
  800045:	68 e0 1d 80 00       	push   $0x801de0
  80004a:	e8 b5 11 00 00       	call   801204 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 e4 1d 80 00       	push   $0x801de4
  800066:	e8 a6 03 00 00       	call   800411 <cprintf>
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
  80009a:	68 09 1e 80 00       	push   $0x801e09
  80009f:	e8 60 11 00 00       	call   801204 <smalloc>
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
  8000da:	68 10 1e 80 00       	push   $0x801e10
  8000df:	50                   	push   %eax
  8000e0:	e8 1d 18 00 00       	call   801902 <create_semaphore>
  8000e5:	83 c4 0c             	add    $0xc,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e8:	83 ec 04             	sub    $0x4,%esp
  8000eb:	6a 01                	push   $0x1
  8000ed:	6a 04                	push   $0x4
  8000ef:	68 12 1e 80 00       	push   $0x801e12
  8000f4:	e8 0b 11 00 00       	call   801204 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800102:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800108:	a1 04 30 80 00       	mov    0x803004,%eax
  80010d:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800113:	a1 04 30 80 00       	mov    0x803004,%eax
  800118:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  80011e:	89 c1                	mov    %eax,%ecx
  800120:	a1 04 30 80 00       	mov    0x803004,%eax
  800125:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80012b:	52                   	push   %edx
  80012c:	51                   	push   %ecx
  80012d:	50                   	push   %eax
  80012e:	68 20 1e 80 00       	push   $0x801e20
  800133:	e8 18 14 00 00       	call   801550 <sys_create_env>
  800138:	83 c4 10             	add    $0x10,%esp
  80013b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80013e:	a1 04 30 80 00       	mov    0x803004,%eax
  800143:	8b 90 3c da 01 00    	mov    0x1da3c(%eax),%edx
  800149:	a1 04 30 80 00       	mov    0x803004,%eax
  80014e:	8b 80 34 da 01 00    	mov    0x1da34(%eax),%eax
  800154:	89 c1                	mov    %eax,%ecx
  800156:	a1 04 30 80 00       	mov    0x803004,%eax
  80015b:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  800161:	52                   	push   %edx
  800162:	51                   	push   %ecx
  800163:	50                   	push   %eax
  800164:	68 2a 1e 80 00       	push   $0x801e2a
  800169:	e8 e2 13 00 00       	call   801550 <sys_create_env>
  80016e:	83 c4 10             	add    $0x10,%esp
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80017a:	e8 ef 13 00 00       	call   80156e <sys_run_env>
  80017f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	ff 75 e0             	pushl  -0x20(%ebp)
  800188:	e8 e1 13 00 00       	call   80156e <sys_run_env>
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
  8001a4:	68 34 1e 80 00       	push   $0x801e34
  8001a9:	e8 63 02 00 00       	call   800411 <cprintf>
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
  8001c8:	e8 c0 12 00 00       	call   80148d <sys_cputc>
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
  8001d9:	e8 4b 11 00 00       	call   801329 <sys_cgetc>
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
  8001f6:	e8 c3 13 00 00       	call   8015be <sys_getenvindex>
  8001fb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800201:	89 d0                	mov    %edx,%eax
  800203:	c1 e0 06             	shl    $0x6,%eax
  800206:	29 d0                	sub    %edx,%eax
  800208:	c1 e0 02             	shl    $0x2,%eax
  80020b:	01 d0                	add    %edx,%eax
  80020d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800214:	01 c8                	add    %ecx,%eax
  800216:	c1 e0 03             	shl    $0x3,%eax
  800219:	01 d0                	add    %edx,%eax
  80021b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800222:	29 c2                	sub    %eax,%edx
  800224:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  80022b:	89 c2                	mov    %eax,%edx
  80022d:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800233:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800238:	a1 04 30 80 00       	mov    0x803004,%eax
  80023d:	8a 40 20             	mov    0x20(%eax),%al
  800240:	84 c0                	test   %al,%al
  800242:	74 0d                	je     800251 <libmain+0x61>
		binaryname = myEnv->prog_name;
  800244:	a1 04 30 80 00       	mov    0x803004,%eax
  800249:	83 c0 20             	add    $0x20,%eax
  80024c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800255:	7e 0a                	jle    800261 <libmain+0x71>
		binaryname = argv[0];
  800257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025a:	8b 00                	mov    (%eax),%eax
  80025c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800261:	83 ec 08             	sub    $0x8,%esp
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 c9 fd ff ff       	call   800038 <_main>
  80026f:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  800272:	e8 cb 10 00 00       	call   801342 <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	68 64 1e 80 00       	push   $0x801e64
  80027f:	e8 8d 01 00 00       	call   800411 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800287:	a1 04 30 80 00       	mov    0x803004,%eax
  80028c:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  800292:	a1 04 30 80 00       	mov    0x803004,%eax
  800297:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80029d:	83 ec 04             	sub    $0x4,%esp
  8002a0:	52                   	push   %edx
  8002a1:	50                   	push   %eax
  8002a2:	68 8c 1e 80 00       	push   $0x801e8c
  8002a7:	e8 65 01 00 00       	call   800411 <cprintf>
  8002ac:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002af:	a1 04 30 80 00       	mov    0x803004,%eax
  8002b4:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  8002ba:	a1 04 30 80 00       	mov    0x803004,%eax
  8002bf:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  8002c5:	a1 04 30 80 00       	mov    0x803004,%eax
  8002ca:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  8002d0:	51                   	push   %ecx
  8002d1:	52                   	push   %edx
  8002d2:	50                   	push   %eax
  8002d3:	68 b4 1e 80 00       	push   $0x801eb4
  8002d8:	e8 34 01 00 00       	call   800411 <cprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002e0:	a1 04 30 80 00       	mov    0x803004,%eax
  8002e5:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	50                   	push   %eax
  8002ef:	68 0c 1f 80 00       	push   $0x801f0c
  8002f4:	e8 18 01 00 00       	call   800411 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  8002fc:	83 ec 0c             	sub    $0xc,%esp
  8002ff:	68 64 1e 80 00       	push   $0x801e64
  800304:	e8 08 01 00 00       	call   800411 <cprintf>
  800309:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  80030c:	e8 4b 10 00 00       	call   80135c <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  800311:	e8 19 00 00 00       	call   80032f <exit>
}
  800316:	90                   	nop
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	6a 00                	push   $0x0
  800324:	e8 61 12 00 00       	call   80158a <sys_destroy_env>
  800329:	83 c4 10             	add    $0x10,%esp
}
  80032c:	90                   	nop
  80032d:	c9                   	leave  
  80032e:	c3                   	ret    

0080032f <exit>:

void
exit(void)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800335:	e8 b6 12 00 00       	call   8015f0 <sys_exit_env>
}
  80033a:	90                   	nop
  80033b:	c9                   	leave  
  80033c:	c3                   	ret    

0080033d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80033d:	55                   	push   %ebp
  80033e:	89 e5                	mov    %esp,%ebp
  800340:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8b 00                	mov    (%eax),%eax
  800348:	8d 48 01             	lea    0x1(%eax),%ecx
  80034b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80034e:	89 0a                	mov    %ecx,(%edx)
  800350:	8b 55 08             	mov    0x8(%ebp),%edx
  800353:	88 d1                	mov    %dl,%cl
  800355:	8b 55 0c             	mov    0xc(%ebp),%edx
  800358:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80035c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035f:	8b 00                	mov    (%eax),%eax
  800361:	3d ff 00 00 00       	cmp    $0xff,%eax
  800366:	75 2c                	jne    800394 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800368:	a0 08 30 80 00       	mov    0x803008,%al
  80036d:	0f b6 c0             	movzbl %al,%eax
  800370:	8b 55 0c             	mov    0xc(%ebp),%edx
  800373:	8b 12                	mov    (%edx),%edx
  800375:	89 d1                	mov    %edx,%ecx
  800377:	8b 55 0c             	mov    0xc(%ebp),%edx
  80037a:	83 c2 08             	add    $0x8,%edx
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	50                   	push   %eax
  800381:	51                   	push   %ecx
  800382:	52                   	push   %edx
  800383:	e8 78 0f 00 00       	call   801300 <sys_cputs>
  800388:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80038b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800394:	8b 45 0c             	mov    0xc(%ebp),%eax
  800397:	8b 40 04             	mov    0x4(%eax),%eax
  80039a:	8d 50 01             	lea    0x1(%eax),%edx
  80039d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003a3:	90                   	nop
  8003a4:	c9                   	leave  
  8003a5:	c3                   	ret    

008003a6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003af:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003b6:	00 00 00 
	b.cnt = 0;
  8003b9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003c0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003cf:	50                   	push   %eax
  8003d0:	68 3d 03 80 00       	push   $0x80033d
  8003d5:	e8 11 02 00 00       	call   8005eb <vprintfmt>
  8003da:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8003dd:	a0 08 30 80 00       	mov    0x803008,%al
  8003e2:	0f b6 c0             	movzbl %al,%eax
  8003e5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003eb:	83 ec 04             	sub    $0x4,%esp
  8003ee:	50                   	push   %eax
  8003ef:	52                   	push   %edx
  8003f0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f6:	83 c0 08             	add    $0x8,%eax
  8003f9:	50                   	push   %eax
  8003fa:	e8 01 0f 00 00       	call   801300 <sys_cputs>
  8003ff:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800402:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800409:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80040f:	c9                   	leave  
  800410:	c3                   	ret    

00800411 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800411:	55                   	push   %ebp
  800412:	89 e5                	mov    %esp,%ebp
  800414:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800417:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  80041e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800421:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	83 ec 08             	sub    $0x8,%esp
  80042a:	ff 75 f4             	pushl  -0xc(%ebp)
  80042d:	50                   	push   %eax
  80042e:	e8 73 ff ff ff       	call   8003a6 <vcprintf>
  800433:	83 c4 10             	add    $0x10,%esp
  800436:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800439:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800444:	e8 f9 0e 00 00       	call   801342 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800449:	8d 45 0c             	lea    0xc(%ebp),%eax
  80044c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80044f:	8b 45 08             	mov    0x8(%ebp),%eax
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	ff 75 f4             	pushl  -0xc(%ebp)
  800458:	50                   	push   %eax
  800459:	e8 48 ff ff ff       	call   8003a6 <vcprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
  800461:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800464:	e8 f3 0e 00 00       	call   80135c <sys_unlock_cons>
	return cnt;
  800469:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	53                   	push   %ebx
  800472:	83 ec 14             	sub    $0x14,%esp
  800475:	8b 45 10             	mov    0x10(%ebp),%eax
  800478:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80047b:	8b 45 14             	mov    0x14(%ebp),%eax
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800481:	8b 45 18             	mov    0x18(%ebp),%eax
  800484:	ba 00 00 00 00       	mov    $0x0,%edx
  800489:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80048c:	77 55                	ja     8004e3 <printnum+0x75>
  80048e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800491:	72 05                	jb     800498 <printnum+0x2a>
  800493:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800496:	77 4b                	ja     8004e3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800498:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80049b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80049e:	8b 45 18             	mov    0x18(%ebp),%eax
  8004a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a6:	52                   	push   %edx
  8004a7:	50                   	push   %eax
  8004a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8004ae:	e8 ad 16 00 00       	call   801b60 <__udivdi3>
  8004b3:	83 c4 10             	add    $0x10,%esp
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	ff 75 20             	pushl  0x20(%ebp)
  8004bc:	53                   	push   %ebx
  8004bd:	ff 75 18             	pushl  0x18(%ebp)
  8004c0:	52                   	push   %edx
  8004c1:	50                   	push   %eax
  8004c2:	ff 75 0c             	pushl  0xc(%ebp)
  8004c5:	ff 75 08             	pushl  0x8(%ebp)
  8004c8:	e8 a1 ff ff ff       	call   80046e <printnum>
  8004cd:	83 c4 20             	add    $0x20,%esp
  8004d0:	eb 1a                	jmp    8004ec <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	ff 75 0c             	pushl  0xc(%ebp)
  8004d8:	ff 75 20             	pushl  0x20(%ebp)
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	ff d0                	call   *%eax
  8004e0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e3:	ff 4d 1c             	decl   0x1c(%ebp)
  8004e6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004ea:	7f e6                	jg     8004d2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ec:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004fa:	53                   	push   %ebx
  8004fb:	51                   	push   %ecx
  8004fc:	52                   	push   %edx
  8004fd:	50                   	push   %eax
  8004fe:	e8 6d 17 00 00       	call   801c70 <__umoddi3>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	05 34 21 80 00       	add    $0x802134,%eax
  80050b:	8a 00                	mov    (%eax),%al
  80050d:	0f be c0             	movsbl %al,%eax
  800510:	83 ec 08             	sub    $0x8,%esp
  800513:	ff 75 0c             	pushl  0xc(%ebp)
  800516:	50                   	push   %eax
  800517:	8b 45 08             	mov    0x8(%ebp),%eax
  80051a:	ff d0                	call   *%eax
  80051c:	83 c4 10             	add    $0x10,%esp
}
  80051f:	90                   	nop
  800520:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800528:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80052c:	7e 1c                	jle    80054a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	8d 50 08             	lea    0x8(%eax),%edx
  800536:	8b 45 08             	mov    0x8(%ebp),%eax
  800539:	89 10                	mov    %edx,(%eax)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	83 e8 08             	sub    $0x8,%eax
  800543:	8b 50 04             	mov    0x4(%eax),%edx
  800546:	8b 00                	mov    (%eax),%eax
  800548:	eb 40                	jmp    80058a <getuint+0x65>
	else if (lflag)
  80054a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80054e:	74 1e                	je     80056e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	8d 50 04             	lea    0x4(%eax),%edx
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	89 10                	mov    %edx,(%eax)
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 e8 04             	sub    $0x4,%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	ba 00 00 00 00       	mov    $0x0,%edx
  80056c:	eb 1c                	jmp    80058a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	8d 50 04             	lea    0x4(%eax),%edx
  800576:	8b 45 08             	mov    0x8(%ebp),%eax
  800579:	89 10                	mov    %edx,(%eax)
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	83 e8 04             	sub    $0x4,%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80058a:	5d                   	pop    %ebp
  80058b:	c3                   	ret    

0080058c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80058f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800593:	7e 1c                	jle    8005b1 <getint+0x25>
		return va_arg(*ap, long long);
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	8d 50 08             	lea    0x8(%eax),%edx
  80059d:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a0:	89 10                	mov    %edx,(%eax)
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	83 e8 08             	sub    $0x8,%eax
  8005aa:	8b 50 04             	mov    0x4(%eax),%edx
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	eb 38                	jmp    8005e9 <getint+0x5d>
	else if (lflag)
  8005b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005b5:	74 1a                	je     8005d1 <getint+0x45>
		return va_arg(*ap, long);
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	8d 50 04             	lea    0x4(%eax),%edx
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	89 10                	mov    %edx,(%eax)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 e8 04             	sub    $0x4,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	99                   	cltd   
  8005cf:	eb 18                	jmp    8005e9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	8d 50 04             	lea    0x4(%eax),%edx
  8005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dc:	89 10                	mov    %edx,(%eax)
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	83 e8 04             	sub    $0x4,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	99                   	cltd   
}
  8005e9:	5d                   	pop    %ebp
  8005ea:	c3                   	ret    

008005eb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005eb:	55                   	push   %ebp
  8005ec:	89 e5                	mov    %esp,%ebp
  8005ee:	56                   	push   %esi
  8005ef:	53                   	push   %ebx
  8005f0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005f3:	eb 17                	jmp    80060c <vprintfmt+0x21>
			if (ch == '\0')
  8005f5:	85 db                	test   %ebx,%ebx
  8005f7:	0f 84 c1 03 00 00    	je     8009be <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	ff 75 0c             	pushl  0xc(%ebp)
  800603:	53                   	push   %ebx
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	ff d0                	call   *%eax
  800609:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80060c:	8b 45 10             	mov    0x10(%ebp),%eax
  80060f:	8d 50 01             	lea    0x1(%eax),%edx
  800612:	89 55 10             	mov    %edx,0x10(%ebp)
  800615:	8a 00                	mov    (%eax),%al
  800617:	0f b6 d8             	movzbl %al,%ebx
  80061a:	83 fb 25             	cmp    $0x25,%ebx
  80061d:	75 d6                	jne    8005f5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80061f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800623:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80062a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800631:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800638:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063f:	8b 45 10             	mov    0x10(%ebp),%eax
  800642:	8d 50 01             	lea    0x1(%eax),%edx
  800645:	89 55 10             	mov    %edx,0x10(%ebp)
  800648:	8a 00                	mov    (%eax),%al
  80064a:	0f b6 d8             	movzbl %al,%ebx
  80064d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800650:	83 f8 5b             	cmp    $0x5b,%eax
  800653:	0f 87 3d 03 00 00    	ja     800996 <vprintfmt+0x3ab>
  800659:	8b 04 85 58 21 80 00 	mov    0x802158(,%eax,4),%eax
  800660:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800662:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800666:	eb d7                	jmp    80063f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800668:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80066c:	eb d1                	jmp    80063f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80066e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800675:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800678:	89 d0                	mov    %edx,%eax
  80067a:	c1 e0 02             	shl    $0x2,%eax
  80067d:	01 d0                	add    %edx,%eax
  80067f:	01 c0                	add    %eax,%eax
  800681:	01 d8                	add    %ebx,%eax
  800683:	83 e8 30             	sub    $0x30,%eax
  800686:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800689:	8b 45 10             	mov    0x10(%ebp),%eax
  80068c:	8a 00                	mov    (%eax),%al
  80068e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800691:	83 fb 2f             	cmp    $0x2f,%ebx
  800694:	7e 3e                	jle    8006d4 <vprintfmt+0xe9>
  800696:	83 fb 39             	cmp    $0x39,%ebx
  800699:	7f 39                	jg     8006d4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80069b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80069e:	eb d5                	jmp    800675 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	83 c0 04             	add    $0x4,%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ac:	83 e8 04             	sub    $0x4,%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006b4:	eb 1f                	jmp    8006d5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ba:	79 83                	jns    80063f <vprintfmt+0x54>
				width = 0;
  8006bc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8006c3:	e9 77 ff ff ff       	jmp    80063f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8006c8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8006cf:	e9 6b ff ff ff       	jmp    80063f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8006d4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006d9:	0f 89 60 ff ff ff    	jns    80063f <vprintfmt+0x54>
				width = precision, precision = -1;
  8006df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006ec:	e9 4e ff ff ff       	jmp    80063f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006f1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006f4:	e9 46 ff ff ff       	jmp    80063f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fc:	83 c0 04             	add    $0x4,%eax
  8006ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	83 e8 04             	sub    $0x4,%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	50                   	push   %eax
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	ff d0                	call   *%eax
  800716:	83 c4 10             	add    $0x10,%esp
			break;
  800719:	e9 9b 02 00 00       	jmp    8009b9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	83 c0 04             	add    $0x4,%eax
  800724:	89 45 14             	mov    %eax,0x14(%ebp)
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	83 e8 04             	sub    $0x4,%eax
  80072d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80072f:	85 db                	test   %ebx,%ebx
  800731:	79 02                	jns    800735 <vprintfmt+0x14a>
				err = -err;
  800733:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800735:	83 fb 64             	cmp    $0x64,%ebx
  800738:	7f 0b                	jg     800745 <vprintfmt+0x15a>
  80073a:	8b 34 9d a0 1f 80 00 	mov    0x801fa0(,%ebx,4),%esi
  800741:	85 f6                	test   %esi,%esi
  800743:	75 19                	jne    80075e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800745:	53                   	push   %ebx
  800746:	68 45 21 80 00       	push   $0x802145
  80074b:	ff 75 0c             	pushl  0xc(%ebp)
  80074e:	ff 75 08             	pushl  0x8(%ebp)
  800751:	e8 70 02 00 00       	call   8009c6 <printfmt>
  800756:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800759:	e9 5b 02 00 00       	jmp    8009b9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80075e:	56                   	push   %esi
  80075f:	68 4e 21 80 00       	push   $0x80214e
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	ff 75 08             	pushl  0x8(%ebp)
  80076a:	e8 57 02 00 00       	call   8009c6 <printfmt>
  80076f:	83 c4 10             	add    $0x10,%esp
			break;
  800772:	e9 42 02 00 00       	jmp    8009b9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	83 c0 04             	add    $0x4,%eax
  80077d:	89 45 14             	mov    %eax,0x14(%ebp)
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	83 e8 04             	sub    $0x4,%eax
  800786:	8b 30                	mov    (%eax),%esi
  800788:	85 f6                	test   %esi,%esi
  80078a:	75 05                	jne    800791 <vprintfmt+0x1a6>
				p = "(null)";
  80078c:	be 51 21 80 00       	mov    $0x802151,%esi
			if (width > 0 && padc != '-')
  800791:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800795:	7e 6d                	jle    800804 <vprintfmt+0x219>
  800797:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80079b:	74 67                	je     800804 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80079d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	50                   	push   %eax
  8007a4:	56                   	push   %esi
  8007a5:	e8 1e 03 00 00       	call   800ac8 <strnlen>
  8007aa:	83 c4 10             	add    $0x10,%esp
  8007ad:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007b0:	eb 16                	jmp    8007c8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007b2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	50                   	push   %eax
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	ff d0                	call   *%eax
  8007c2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c5:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007cc:	7f e4                	jg     8007b2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ce:	eb 34                	jmp    800804 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8007d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007d4:	74 1c                	je     8007f2 <vprintfmt+0x207>
  8007d6:	83 fb 1f             	cmp    $0x1f,%ebx
  8007d9:	7e 05                	jle    8007e0 <vprintfmt+0x1f5>
  8007db:	83 fb 7e             	cmp    $0x7e,%ebx
  8007de:	7e 12                	jle    8007f2 <vprintfmt+0x207>
					putch('?', putdat);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	6a 3f                	push   $0x3f
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	ff d0                	call   *%eax
  8007ed:	83 c4 10             	add    $0x10,%esp
  8007f0:	eb 0f                	jmp    800801 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	ff 75 0c             	pushl  0xc(%ebp)
  8007f8:	53                   	push   %ebx
  8007f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fc:	ff d0                	call   *%eax
  8007fe:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800801:	ff 4d e4             	decl   -0x1c(%ebp)
  800804:	89 f0                	mov    %esi,%eax
  800806:	8d 70 01             	lea    0x1(%eax),%esi
  800809:	8a 00                	mov    (%eax),%al
  80080b:	0f be d8             	movsbl %al,%ebx
  80080e:	85 db                	test   %ebx,%ebx
  800810:	74 24                	je     800836 <vprintfmt+0x24b>
  800812:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800816:	78 b8                	js     8007d0 <vprintfmt+0x1e5>
  800818:	ff 4d e0             	decl   -0x20(%ebp)
  80081b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80081f:	79 af                	jns    8007d0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800821:	eb 13                	jmp    800836 <vprintfmt+0x24b>
				putch(' ', putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	ff 75 0c             	pushl  0xc(%ebp)
  800829:	6a 20                	push   $0x20
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800833:	ff 4d e4             	decl   -0x1c(%ebp)
  800836:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083a:	7f e7                	jg     800823 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80083c:	e9 78 01 00 00       	jmp    8009b9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 e8             	pushl  -0x18(%ebp)
  800847:	8d 45 14             	lea    0x14(%ebp),%eax
  80084a:	50                   	push   %eax
  80084b:	e8 3c fd ff ff       	call   80058c <getint>
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800856:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085f:	85 d2                	test   %edx,%edx
  800861:	79 23                	jns    800886 <vprintfmt+0x29b>
				putch('-', putdat);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	6a 2d                	push   $0x2d
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	ff d0                	call   *%eax
  800870:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800876:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800879:	f7 d8                	neg    %eax
  80087b:	83 d2 00             	adc    $0x0,%edx
  80087e:	f7 da                	neg    %edx
  800880:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800883:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800886:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80088d:	e9 bc 00 00 00       	jmp    80094e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	ff 75 e8             	pushl  -0x18(%ebp)
  800898:	8d 45 14             	lea    0x14(%ebp),%eax
  80089b:	50                   	push   %eax
  80089c:	e8 84 fc ff ff       	call   800525 <getuint>
  8008a1:	83 c4 10             	add    $0x10,%esp
  8008a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008aa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008b1:	e9 98 00 00 00       	jmp    80094e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	6a 58                	push   $0x58
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	ff d0                	call   *%eax
  8008c3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	6a 58                	push   $0x58
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	ff d0                	call   *%eax
  8008d3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	6a 58                	push   $0x58
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	ff d0                	call   *%eax
  8008e3:	83 c4 10             	add    $0x10,%esp
			break;
  8008e6:	e9 ce 00 00 00       	jmp    8009b9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	6a 30                	push   $0x30
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	ff d0                	call   *%eax
  8008f8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	6a 78                	push   $0x78
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	ff d0                	call   *%eax
  800908:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80090b:	8b 45 14             	mov    0x14(%ebp),%eax
  80090e:	83 c0 04             	add    $0x4,%eax
  800911:	89 45 14             	mov    %eax,0x14(%ebp)
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	83 e8 04             	sub    $0x4,%eax
  80091a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80091c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80091f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800926:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80092d:	eb 1f                	jmp    80094e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80092f:	83 ec 08             	sub    $0x8,%esp
  800932:	ff 75 e8             	pushl  -0x18(%ebp)
  800935:	8d 45 14             	lea    0x14(%ebp),%eax
  800938:	50                   	push   %eax
  800939:	e8 e7 fb ff ff       	call   800525 <getuint>
  80093e:	83 c4 10             	add    $0x10,%esp
  800941:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800944:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800947:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80094e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800955:	83 ec 04             	sub    $0x4,%esp
  800958:	52                   	push   %edx
  800959:	ff 75 e4             	pushl  -0x1c(%ebp)
  80095c:	50                   	push   %eax
  80095d:	ff 75 f4             	pushl  -0xc(%ebp)
  800960:	ff 75 f0             	pushl  -0x10(%ebp)
  800963:	ff 75 0c             	pushl  0xc(%ebp)
  800966:	ff 75 08             	pushl  0x8(%ebp)
  800969:	e8 00 fb ff ff       	call   80046e <printnum>
  80096e:	83 c4 20             	add    $0x20,%esp
			break;
  800971:	eb 46                	jmp    8009b9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800973:	83 ec 08             	sub    $0x8,%esp
  800976:	ff 75 0c             	pushl  0xc(%ebp)
  800979:	53                   	push   %ebx
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	ff d0                	call   *%eax
  80097f:	83 c4 10             	add    $0x10,%esp
			break;
  800982:	eb 35                	jmp    8009b9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800984:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  80098b:	eb 2c                	jmp    8009b9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80098d:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800994:	eb 23                	jmp    8009b9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	6a 25                	push   $0x25
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009a6:	ff 4d 10             	decl   0x10(%ebp)
  8009a9:	eb 03                	jmp    8009ae <vprintfmt+0x3c3>
  8009ab:	ff 4d 10             	decl   0x10(%ebp)
  8009ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b1:	48                   	dec    %eax
  8009b2:	8a 00                	mov    (%eax),%al
  8009b4:	3c 25                	cmp    $0x25,%al
  8009b6:	75 f3                	jne    8009ab <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8009b8:	90                   	nop
		}
	}
  8009b9:	e9 35 fc ff ff       	jmp    8005f3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009be:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009c2:	5b                   	pop    %ebx
  8009c3:	5e                   	pop    %esi
  8009c4:	5d                   	pop    %ebp
  8009c5:	c3                   	ret    

008009c6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8009cc:	8d 45 10             	lea    0x10(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8009d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	ff 75 08             	pushl  0x8(%ebp)
  8009e2:	e8 04 fc ff ff       	call   8005eb <vprintfmt>
  8009e7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8009ea:	90                   	nop
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f3:	8b 40 08             	mov    0x8(%eax),%eax
  8009f6:	8d 50 01             	lea    0x1(%eax),%edx
  8009f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a02:	8b 10                	mov    (%eax),%edx
  800a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a07:	8b 40 04             	mov    0x4(%eax),%eax
  800a0a:	39 c2                	cmp    %eax,%edx
  800a0c:	73 12                	jae    800a20 <sprintputch+0x33>
		*b->buf++ = ch;
  800a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a11:	8b 00                	mov    (%eax),%eax
  800a13:	8d 48 01             	lea    0x1(%eax),%ecx
  800a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a19:	89 0a                	mov    %ecx,(%edx)
  800a1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1e:	88 10                	mov    %dl,(%eax)
}
  800a20:	90                   	nop
  800a21:	5d                   	pop    %ebp
  800a22:	c3                   	ret    

00800a23 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	01 d0                	add    %edx,%eax
  800a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a48:	74 06                	je     800a50 <vsnprintf+0x2d>
  800a4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a4e:	7f 07                	jg     800a57 <vsnprintf+0x34>
		return -E_INVAL;
  800a50:	b8 03 00 00 00       	mov    $0x3,%eax
  800a55:	eb 20                	jmp    800a77 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a57:	ff 75 14             	pushl  0x14(%ebp)
  800a5a:	ff 75 10             	pushl  0x10(%ebp)
  800a5d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a60:	50                   	push   %eax
  800a61:	68 ed 09 80 00       	push   $0x8009ed
  800a66:	e8 80 fb ff ff       	call   8005eb <vprintfmt>
  800a6b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a71:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a77:	c9                   	leave  
  800a78:	c3                   	ret    

00800a79 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a7f:	8d 45 10             	lea    0x10(%ebp),%eax
  800a82:	83 c0 04             	add    $0x4,%eax
  800a85:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a88:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8e:	50                   	push   %eax
  800a8f:	ff 75 0c             	pushl  0xc(%ebp)
  800a92:	ff 75 08             	pushl  0x8(%ebp)
  800a95:	e8 89 ff ff ff       	call   800a23 <vsnprintf>
  800a9a:	83 c4 10             	add    $0x10,%esp
  800a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa3:	c9                   	leave  
  800aa4:	c3                   	ret    

00800aa5 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800aab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ab2:	eb 06                	jmp    800aba <strlen+0x15>
		n++;
  800ab4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ab7:	ff 45 08             	incl   0x8(%ebp)
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8a 00                	mov    (%eax),%al
  800abf:	84 c0                	test   %al,%al
  800ac1:	75 f1                	jne    800ab4 <strlen+0xf>
		n++;
	return n;
  800ac3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ac6:	c9                   	leave  
  800ac7:	c3                   	ret    

00800ac8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ace:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ad5:	eb 09                	jmp    800ae0 <strnlen+0x18>
		n++;
  800ad7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ada:	ff 45 08             	incl   0x8(%ebp)
  800add:	ff 4d 0c             	decl   0xc(%ebp)
  800ae0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ae4:	74 09                	je     800aef <strnlen+0x27>
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8a 00                	mov    (%eax),%al
  800aeb:	84 c0                	test   %al,%al
  800aed:	75 e8                	jne    800ad7 <strnlen+0xf>
		n++;
	return n;
  800aef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800af2:	c9                   	leave  
  800af3:	c3                   	ret    

00800af4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b00:	90                   	nop
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	8d 50 01             	lea    0x1(%eax),%edx
  800b07:	89 55 08             	mov    %edx,0x8(%ebp)
  800b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b10:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b13:	8a 12                	mov    (%edx),%dl
  800b15:	88 10                	mov    %dl,(%eax)
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	75 e4                	jne    800b01 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b35:	eb 1f                	jmp    800b56 <strncpy+0x34>
		*dst++ = *src;
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8d 50 01             	lea    0x1(%eax),%edx
  800b3d:	89 55 08             	mov    %edx,0x8(%ebp)
  800b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b43:	8a 12                	mov    (%edx),%dl
  800b45:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8a 00                	mov    (%eax),%al
  800b4c:	84 c0                	test   %al,%al
  800b4e:	74 03                	je     800b53 <strncpy+0x31>
			src++;
  800b50:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b53:	ff 45 fc             	incl   -0x4(%ebp)
  800b56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b59:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b5c:	72 d9                	jb     800b37 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b73:	74 30                	je     800ba5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b75:	eb 16                	jmp    800b8d <strlcpy+0x2a>
			*dst++ = *src++;
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8d 50 01             	lea    0x1(%eax),%edx
  800b7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b83:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b86:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b89:	8a 12                	mov    (%edx),%dl
  800b8b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b8d:	ff 4d 10             	decl   0x10(%ebp)
  800b90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b94:	74 09                	je     800b9f <strlcpy+0x3c>
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	84 c0                	test   %al,%al
  800b9d:	75 d8                	jne    800b77 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bab:	29 c2                	sub    %eax,%edx
  800bad:	89 d0                	mov    %edx,%eax
}
  800baf:	c9                   	leave  
  800bb0:	c3                   	ret    

00800bb1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800bb4:	eb 06                	jmp    800bbc <strcmp+0xb>
		p++, q++;
  800bb6:	ff 45 08             	incl   0x8(%ebp)
  800bb9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	84 c0                	test   %al,%al
  800bc3:	74 0e                	je     800bd3 <strcmp+0x22>
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8a 10                	mov    (%eax),%dl
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	38 c2                	cmp    %al,%dl
  800bd1:	74 e3                	je     800bb6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 d0             	movzbl %al,%edx
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f b6 c0             	movzbl %al,%eax
  800be3:	29 c2                	sub    %eax,%edx
  800be5:	89 d0                	mov    %edx,%eax
}
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800bec:	eb 09                	jmp    800bf7 <strncmp+0xe>
		n--, p++, q++;
  800bee:	ff 4d 10             	decl   0x10(%ebp)
  800bf1:	ff 45 08             	incl   0x8(%ebp)
  800bf4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800bf7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bfb:	74 17                	je     800c14 <strncmp+0x2b>
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	74 0e                	je     800c14 <strncmp+0x2b>
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8a 10                	mov    (%eax),%dl
  800c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0e:	8a 00                	mov    (%eax),%al
  800c10:	38 c2                	cmp    %al,%dl
  800c12:	74 da                	je     800bee <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c18:	75 07                	jne    800c21 <strncmp+0x38>
		return 0;
  800c1a:	b8 00 00 00 00       	mov    $0x0,%eax
  800c1f:	eb 14                	jmp    800c35 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8a 00                	mov    (%eax),%al
  800c26:	0f b6 d0             	movzbl %al,%edx
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	0f b6 c0             	movzbl %al,%eax
  800c31:	29 c2                	sub    %eax,%edx
  800c33:	89 d0                	mov    %edx,%eax
}
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 04             	sub    $0x4,%esp
  800c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c40:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c43:	eb 12                	jmp    800c57 <strchr+0x20>
		if (*s == c)
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c4d:	75 05                	jne    800c54 <strchr+0x1d>
			return (char *) s;
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	eb 11                	jmp    800c65 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c54:	ff 45 08             	incl   0x8(%ebp)
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	75 e5                	jne    800c45 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c65:	c9                   	leave  
  800c66:	c3                   	ret    

00800c67 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 04             	sub    $0x4,%esp
  800c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c70:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c73:	eb 0d                	jmp    800c82 <strfind+0x1b>
		if (*s == c)
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	8a 00                	mov    (%eax),%al
  800c7a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c7d:	74 0e                	je     800c8d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c7f:	ff 45 08             	incl   0x8(%ebp)
  800c82:	8b 45 08             	mov    0x8(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	84 c0                	test   %al,%al
  800c89:	75 ea                	jne    800c75 <strfind+0xe>
  800c8b:	eb 01                	jmp    800c8e <strfind+0x27>
		if (*s == c)
			break;
  800c8d:	90                   	nop
	return (char *) s;
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c91:	c9                   	leave  
  800c92:	c3                   	ret    

00800c93 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ca5:	eb 0e                	jmp    800cb5 <memset+0x22>
		*p++ = c;
  800ca7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800caa:	8d 50 01             	lea    0x1(%eax),%edx
  800cad:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cb5:	ff 4d f8             	decl   -0x8(%ebp)
  800cb8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cbc:	79 e9                	jns    800ca7 <memset+0x14>
		*p++ = c;

	return v;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800cd5:	eb 16                	jmp    800ced <memcpy+0x2a>
		*d++ = *s++;
  800cd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cda:	8d 50 01             	lea    0x1(%eax),%edx
  800cdd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ce0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ce3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ced:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf3:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	75 dd                	jne    800cd7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d14:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d17:	73 50                	jae    800d69 <memmove+0x6a>
  800d19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1f:	01 d0                	add    %edx,%eax
  800d21:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d24:	76 43                	jbe    800d69 <memmove+0x6a>
		s += n;
  800d26:	8b 45 10             	mov    0x10(%ebp),%eax
  800d29:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d32:	eb 10                	jmp    800d44 <memmove+0x45>
			*--d = *--s;
  800d34:	ff 4d f8             	decl   -0x8(%ebp)
  800d37:	ff 4d fc             	decl   -0x4(%ebp)
  800d3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d3d:	8a 10                	mov    (%eax),%dl
  800d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d42:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d44:	8b 45 10             	mov    0x10(%ebp),%eax
  800d47:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	75 e3                	jne    800d34 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d51:	eb 23                	jmp    800d76 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d56:	8d 50 01             	lea    0x1(%eax),%edx
  800d59:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d5f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d62:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d65:	8a 12                	mov    (%edx),%dl
  800d67:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d69:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d72:	85 c0                	test   %eax,%eax
  800d74:	75 dd                	jne    800d53 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d79:	c9                   	leave  
  800d7a:	c3                   	ret    

00800d7b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d8d:	eb 2a                	jmp    800db9 <memcmp+0x3e>
		if (*s1 != *s2)
  800d8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d92:	8a 10                	mov    (%eax),%dl
  800d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	38 c2                	cmp    %al,%dl
  800d9b:	74 16                	je     800db3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	0f b6 d0             	movzbl %al,%edx
  800da5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	0f b6 c0             	movzbl %al,%eax
  800dad:	29 c2                	sub    %eax,%edx
  800daf:	89 d0                	mov    %edx,%eax
  800db1:	eb 18                	jmp    800dcb <memcmp+0x50>
		s1++, s2++;
  800db3:	ff 45 fc             	incl   -0x4(%ebp)
  800db6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	75 c9                	jne    800d8f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dcb:	c9                   	leave  
  800dcc:	c3                   	ret    

00800dcd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd9:	01 d0                	add    %edx,%eax
  800ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800dde:	eb 15                	jmp    800df5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 d0             	movzbl %al,%edx
  800de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800deb:	0f b6 c0             	movzbl %al,%eax
  800dee:	39 c2                	cmp    %eax,%edx
  800df0:	74 0d                	je     800dff <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800df2:	ff 45 08             	incl   0x8(%ebp)
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dfb:	72 e3                	jb     800de0 <memfind+0x13>
  800dfd:	eb 01                	jmp    800e00 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800dff:	90                   	nop
	return (void *) s;
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e03:	c9                   	leave  
  800e04:	c3                   	ret    

00800e05 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e12:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e19:	eb 03                	jmp    800e1e <strtol+0x19>
		s++;
  800e1b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	3c 20                	cmp    $0x20,%al
  800e25:	74 f4                	je     800e1b <strtol+0x16>
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 00                	mov    (%eax),%al
  800e2c:	3c 09                	cmp    $0x9,%al
  800e2e:	74 eb                	je     800e1b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	3c 2b                	cmp    $0x2b,%al
  800e37:	75 05                	jne    800e3e <strtol+0x39>
		s++;
  800e39:	ff 45 08             	incl   0x8(%ebp)
  800e3c:	eb 13                	jmp    800e51 <strtol+0x4c>
	else if (*s == '-')
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	3c 2d                	cmp    $0x2d,%al
  800e45:	75 0a                	jne    800e51 <strtol+0x4c>
		s++, neg = 1;
  800e47:	ff 45 08             	incl   0x8(%ebp)
  800e4a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e55:	74 06                	je     800e5d <strtol+0x58>
  800e57:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e5b:	75 20                	jne    800e7d <strtol+0x78>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	3c 30                	cmp    $0x30,%al
  800e64:	75 17                	jne    800e7d <strtol+0x78>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	40                   	inc    %eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 78                	cmp    $0x78,%al
  800e6e:	75 0d                	jne    800e7d <strtol+0x78>
		s += 2, base = 16;
  800e70:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e74:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e7b:	eb 28                	jmp    800ea5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e81:	75 15                	jne    800e98 <strtol+0x93>
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	3c 30                	cmp    $0x30,%al
  800e8a:	75 0c                	jne    800e98 <strtol+0x93>
		s++, base = 8;
  800e8c:	ff 45 08             	incl   0x8(%ebp)
  800e8f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e96:	eb 0d                	jmp    800ea5 <strtol+0xa0>
	else if (base == 0)
  800e98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9c:	75 07                	jne    800ea5 <strtol+0xa0>
		base = 10;
  800e9e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	3c 2f                	cmp    $0x2f,%al
  800eac:	7e 19                	jle    800ec7 <strtol+0xc2>
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	3c 39                	cmp    $0x39,%al
  800eb5:	7f 10                	jg     800ec7 <strtol+0xc2>
			dig = *s - '0';
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	0f be c0             	movsbl %al,%eax
  800ebf:	83 e8 30             	sub    $0x30,%eax
  800ec2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ec5:	eb 42                	jmp    800f09 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	3c 60                	cmp    $0x60,%al
  800ece:	7e 19                	jle    800ee9 <strtol+0xe4>
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	3c 7a                	cmp    $0x7a,%al
  800ed7:	7f 10                	jg     800ee9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	0f be c0             	movsbl %al,%eax
  800ee1:	83 e8 57             	sub    $0x57,%eax
  800ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ee7:	eb 20                	jmp    800f09 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	3c 40                	cmp    $0x40,%al
  800ef0:	7e 39                	jle    800f2b <strtol+0x126>
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	3c 5a                	cmp    $0x5a,%al
  800ef9:	7f 30                	jg     800f2b <strtol+0x126>
			dig = *s - 'A' + 10;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	0f be c0             	movsbl %al,%eax
  800f03:	83 e8 37             	sub    $0x37,%eax
  800f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f0c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f0f:	7d 19                	jge    800f2a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f11:	ff 45 08             	incl   0x8(%ebp)
  800f14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f17:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f25:	e9 7b ff ff ff       	jmp    800ea5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f2a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f2f:	74 08                	je     800f39 <strtol+0x134>
		*endptr = (char *) s;
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8b 55 08             	mov    0x8(%ebp),%edx
  800f37:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f39:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f3d:	74 07                	je     800f46 <strtol+0x141>
  800f3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f42:	f7 d8                	neg    %eax
  800f44:	eb 03                	jmp    800f49 <strtol+0x144>
  800f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f49:	c9                   	leave  
  800f4a:	c3                   	ret    

00800f4b <ltostr>:

void
ltostr(long value, char *str)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f58:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f63:	79 13                	jns    800f78 <ltostr+0x2d>
	{
		neg = 1;
  800f65:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f72:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f75:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f80:	99                   	cltd   
  800f81:	f7 f9                	idiv   %ecx
  800f83:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f89:	8d 50 01             	lea    0x1(%eax),%edx
  800f8c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f8f:	89 c2                	mov    %eax,%edx
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f99:	83 c2 30             	add    $0x30,%edx
  800f9c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fa6:	f7 e9                	imul   %ecx
  800fa8:	c1 fa 02             	sar    $0x2,%edx
  800fab:	89 c8                	mov    %ecx,%eax
  800fad:	c1 f8 1f             	sar    $0x1f,%eax
  800fb0:	29 c2                	sub    %eax,%edx
  800fb2:	89 d0                	mov    %edx,%eax
  800fb4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800fb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fbb:	75 bb                	jne    800f78 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800fbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	48                   	dec    %eax
  800fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800fcb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800fcf:	74 3d                	je     80100e <ltostr+0xc3>
		start = 1 ;
  800fd1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fd8:	eb 34                	jmp    80100e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fe7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fed:	01 c2                	add    %eax,%edx
  800fef:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	01 c8                	add    %ecx,%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ffb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ffe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801001:	01 c2                	add    %eax,%edx
  801003:	8a 45 eb             	mov    -0x15(%ebp),%al
  801006:	88 02                	mov    %al,(%edx)
		start++ ;
  801008:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80100b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80100e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801011:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801014:	7c c4                	jl     800fda <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801016:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	01 d0                	add    %edx,%eax
  80101e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801021:	90                   	nop
  801022:	c9                   	leave  
  801023:	c3                   	ret    

00801024 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80102a:	ff 75 08             	pushl  0x8(%ebp)
  80102d:	e8 73 fa ff ff       	call   800aa5 <strlen>
  801032:	83 c4 04             	add    $0x4,%esp
  801035:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801038:	ff 75 0c             	pushl  0xc(%ebp)
  80103b:	e8 65 fa ff ff       	call   800aa5 <strlen>
  801040:	83 c4 04             	add    $0x4,%esp
  801043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801046:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80104d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801054:	eb 17                	jmp    80106d <strcconcat+0x49>
		final[s] = str1[s] ;
  801056:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801059:	8b 45 10             	mov    0x10(%ebp),%eax
  80105c:	01 c2                	add    %eax,%edx
  80105e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	01 c8                	add    %ecx,%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80106a:	ff 45 fc             	incl   -0x4(%ebp)
  80106d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801070:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801073:	7c e1                	jl     801056 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801075:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80107c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801083:	eb 1f                	jmp    8010a4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801085:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801088:	8d 50 01             	lea    0x1(%eax),%edx
  80108b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80108e:	89 c2                	mov    %eax,%edx
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	01 c2                	add    %eax,%edx
  801095:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	01 c8                	add    %ecx,%eax
  80109d:	8a 00                	mov    (%eax),%al
  80109f:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010a1:	ff 45 f8             	incl   -0x8(%ebp)
  8010a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010aa:	7c d9                	jl     801085 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8010ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 d0                	add    %edx,%eax
  8010b4:	c6 00 00             	movb   $0x0,(%eax)
}
  8010b7:	90                   	nop
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8010bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8010c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c9:	8b 00                	mov    (%eax),%eax
  8010cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d5:	01 d0                	add    %edx,%eax
  8010d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010dd:	eb 0c                	jmp    8010eb <strsplit+0x31>
			*string++ = 0;
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8d 50 01             	lea    0x1(%eax),%edx
  8010e5:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e8:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8a 00                	mov    (%eax),%al
  8010f0:	84 c0                	test   %al,%al
  8010f2:	74 18                	je     80110c <strsplit+0x52>
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	0f be c0             	movsbl %al,%eax
  8010fc:	50                   	push   %eax
  8010fd:	ff 75 0c             	pushl  0xc(%ebp)
  801100:	e8 32 fb ff ff       	call   800c37 <strchr>
  801105:	83 c4 08             	add    $0x8,%esp
  801108:	85 c0                	test   %eax,%eax
  80110a:	75 d3                	jne    8010df <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	84 c0                	test   %al,%al
  801113:	74 5a                	je     80116f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801115:	8b 45 14             	mov    0x14(%ebp),%eax
  801118:	8b 00                	mov    (%eax),%eax
  80111a:	83 f8 0f             	cmp    $0xf,%eax
  80111d:	75 07                	jne    801126 <strsplit+0x6c>
		{
			return 0;
  80111f:	b8 00 00 00 00       	mov    $0x0,%eax
  801124:	eb 66                	jmp    80118c <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801126:	8b 45 14             	mov    0x14(%ebp),%eax
  801129:	8b 00                	mov    (%eax),%eax
  80112b:	8d 48 01             	lea    0x1(%eax),%ecx
  80112e:	8b 55 14             	mov    0x14(%ebp),%edx
  801131:	89 0a                	mov    %ecx,(%edx)
  801133:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80113a:	8b 45 10             	mov    0x10(%ebp),%eax
  80113d:	01 c2                	add    %eax,%edx
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801144:	eb 03                	jmp    801149 <strsplit+0x8f>
			string++;
  801146:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	84 c0                	test   %al,%al
  801150:	74 8b                	je     8010dd <strsplit+0x23>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	0f be c0             	movsbl %al,%eax
  80115a:	50                   	push   %eax
  80115b:	ff 75 0c             	pushl  0xc(%ebp)
  80115e:	e8 d4 fa ff ff       	call   800c37 <strchr>
  801163:	83 c4 08             	add    $0x8,%esp
  801166:	85 c0                	test   %eax,%eax
  801168:	74 dc                	je     801146 <strsplit+0x8c>
			string++;
	}
  80116a:	e9 6e ff ff ff       	jmp    8010dd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80116f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801170:	8b 45 14             	mov    0x14(%ebp),%eax
  801173:	8b 00                	mov    (%eax),%eax
  801175:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117c:	8b 45 10             	mov    0x10(%ebp),%eax
  80117f:	01 d0                	add    %edx,%eax
  801181:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801187:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80118c:	c9                   	leave  
  80118d:	c3                   	ret    

0080118e <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801194:	83 ec 04             	sub    $0x4,%esp
  801197:	68 c8 22 80 00       	push   $0x8022c8
  80119c:	68 3f 01 00 00       	push   $0x13f
  8011a1:	68 ea 22 80 00       	push   $0x8022ea
  8011a6:	e8 ca 07 00 00       	call   801975 <_panic>

008011ab <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	ff 75 08             	pushl  0x8(%ebp)
  8011b7:	e8 ef 06 00 00       	call   8018ab <sys_sbrk>
  8011bc:	83 c4 10             	add    $0x10,%esp
}
  8011bf:	c9                   	leave  
  8011c0:	c3                   	ret    

008011c1 <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  8011c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cb:	75 07                	jne    8011d4 <malloc+0x13>
  8011cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d2:	eb 14                	jmp    8011e8 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8011d4:	83 ec 04             	sub    $0x4,%esp
  8011d7:	68 f8 22 80 00       	push   $0x8022f8
  8011dc:	6a 1b                	push   $0x1b
  8011de:	68 1d 23 80 00       	push   $0x80231d
  8011e3:	e8 8d 07 00 00       	call   801975 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  8011e8:	c9                   	leave  
  8011e9:	c3                   	ret    

008011ea <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8011f0:	83 ec 04             	sub    $0x4,%esp
  8011f3:	68 2c 23 80 00       	push   $0x80232c
  8011f8:	6a 29                	push   $0x29
  8011fa:	68 1d 23 80 00       	push   $0x80231d
  8011ff:	e8 71 07 00 00       	call   801975 <_panic>

00801204 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	83 ec 18             	sub    $0x18,%esp
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
  80120d:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801210:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801214:	75 07                	jne    80121d <smalloc+0x19>
  801216:	b8 00 00 00 00       	mov    $0x0,%eax
  80121b:	eb 14                	jmp    801231 <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80121d:	83 ec 04             	sub    $0x4,%esp
  801220:	68 50 23 80 00       	push   $0x802350
  801225:	6a 38                	push   $0x38
  801227:	68 1d 23 80 00       	push   $0x80231d
  80122c:	e8 44 07 00 00       	call   801975 <_panic>
	return NULL;
}
  801231:	c9                   	leave  
  801232:	c3                   	ret    

00801233 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801239:	83 ec 04             	sub    $0x4,%esp
  80123c:	68 78 23 80 00       	push   $0x802378
  801241:	6a 43                	push   $0x43
  801243:	68 1d 23 80 00       	push   $0x80231d
  801248:	e8 28 07 00 00       	call   801975 <_panic>

0080124d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801253:	83 ec 04             	sub    $0x4,%esp
  801256:	68 9c 23 80 00       	push   $0x80239c
  80125b:	6a 5b                	push   $0x5b
  80125d:	68 1d 23 80 00       	push   $0x80231d
  801262:	e8 0e 07 00 00       	call   801975 <_panic>

00801267 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80126d:	83 ec 04             	sub    $0x4,%esp
  801270:	68 c0 23 80 00       	push   $0x8023c0
  801275:	6a 72                	push   $0x72
  801277:	68 1d 23 80 00       	push   $0x80231d
  80127c:	e8 f4 06 00 00       	call   801975 <_panic>

00801281 <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	68 e6 23 80 00       	push   $0x8023e6
  80128f:	6a 7e                	push   $0x7e
  801291:	68 1d 23 80 00       	push   $0x80231d
  801296:	e8 da 06 00 00       	call   801975 <_panic>

0080129b <shrink>:

}
void shrink(uint32 newSize)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8012a1:	83 ec 04             	sub    $0x4,%esp
  8012a4:	68 e6 23 80 00       	push   $0x8023e6
  8012a9:	68 83 00 00 00       	push   $0x83
  8012ae:	68 1d 23 80 00       	push   $0x80231d
  8012b3:	e8 bd 06 00 00       	call   801975 <_panic>

008012b8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	68 e6 23 80 00       	push   $0x8023e6
  8012c6:	68 88 00 00 00       	push   $0x88
  8012cb:	68 1d 23 80 00       	push   $0x80231d
  8012d0:	e8 a0 06 00 00       	call   801975 <_panic>

008012d5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	57                   	push   %edi
  8012d9:	56                   	push   %esi
  8012da:	53                   	push   %ebx
  8012db:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012ea:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012ed:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012f0:	cd 30                	int    $0x30
  8012f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	5b                   	pop    %ebx
  8012fc:	5e                   	pop    %esi
  8012fd:	5f                   	pop    %edi
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    

00801300 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 04             	sub    $0x4,%esp
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80130c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	52                   	push   %edx
  801318:	ff 75 0c             	pushl  0xc(%ebp)
  80131b:	50                   	push   %eax
  80131c:	6a 00                	push   $0x0
  80131e:	e8 b2 ff ff ff       	call   8012d5 <syscall>
  801323:	83 c4 18             	add    $0x18,%esp
}
  801326:	90                   	nop
  801327:	c9                   	leave  
  801328:	c3                   	ret    

00801329 <sys_cgetc>:

int
sys_cgetc(void)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80132c:	6a 00                	push   $0x0
  80132e:	6a 00                	push   $0x0
  801330:	6a 00                	push   $0x0
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 02                	push   $0x2
  801338:	e8 98 ff ff ff       	call   8012d5 <syscall>
  80133d:	83 c4 18             	add    $0x18,%esp
}
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <sys_lock_cons>:

void sys_lock_cons(void)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801345:	6a 00                	push   $0x0
  801347:	6a 00                	push   $0x0
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 03                	push   $0x3
  801351:	e8 7f ff ff ff       	call   8012d5 <syscall>
  801356:	83 c4 18             	add    $0x18,%esp
}
  801359:	90                   	nop
  80135a:	c9                   	leave  
  80135b:	c3                   	ret    

0080135c <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	6a 04                	push   $0x4
  80136b:	e8 65 ff ff ff       	call   8012d5 <syscall>
  801370:	83 c4 18             	add    $0x18,%esp
}
  801373:	90                   	nop
  801374:	c9                   	leave  
  801375:	c3                   	ret    

00801376 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801379:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	52                   	push   %edx
  801386:	50                   	push   %eax
  801387:	6a 08                	push   $0x8
  801389:	e8 47 ff ff ff       	call   8012d5 <syscall>
  80138e:	83 c4 18             	add    $0x18,%esp
}
  801391:	c9                   	leave  
  801392:	c3                   	ret    

00801393 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	56                   	push   %esi
  801397:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801398:	8b 75 18             	mov    0x18(%ebp),%esi
  80139b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80139e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	56                   	push   %esi
  8013a8:	53                   	push   %ebx
  8013a9:	51                   	push   %ecx
  8013aa:	52                   	push   %edx
  8013ab:	50                   	push   %eax
  8013ac:	6a 09                	push   $0x9
  8013ae:	e8 22 ff ff ff       	call   8012d5 <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b9:	5b                   	pop    %ebx
  8013ba:	5e                   	pop    %esi
  8013bb:	5d                   	pop    %ebp
  8013bc:	c3                   	ret    

008013bd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	52                   	push   %edx
  8013cd:	50                   	push   %eax
  8013ce:	6a 0a                	push   $0xa
  8013d0:	e8 00 ff ff ff       	call   8012d5 <syscall>
  8013d5:	83 c4 18             	add    $0x18,%esp
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	ff 75 08             	pushl  0x8(%ebp)
  8013e9:	6a 0b                	push   $0xb
  8013eb:	e8 e5 fe ff ff       	call   8012d5 <syscall>
  8013f0:	83 c4 18             	add    $0x18,%esp
}
  8013f3:	c9                   	leave  
  8013f4:	c3                   	ret    

008013f5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 0c                	push   $0xc
  801404:	e8 cc fe ff ff       	call   8012d5 <syscall>
  801409:	83 c4 18             	add    $0x18,%esp
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 0d                	push   $0xd
  80141d:	e8 b3 fe ff ff       	call   8012d5 <syscall>
  801422:	83 c4 18             	add    $0x18,%esp
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 0e                	push   $0xe
  801436:	e8 9a fe ff ff       	call   8012d5 <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 0f                	push   $0xf
  80144f:	e8 81 fe ff ff       	call   8012d5 <syscall>
  801454:	83 c4 18             	add    $0x18,%esp
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	ff 75 08             	pushl  0x8(%ebp)
  801467:	6a 10                	push   $0x10
  801469:	e8 67 fe ff ff       	call   8012d5 <syscall>
  80146e:	83 c4 18             	add    $0x18,%esp
}
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	6a 11                	push   $0x11
  801482:	e8 4e fe ff ff       	call   8012d5 <syscall>
  801487:	83 c4 18             	add    $0x18,%esp
}
  80148a:	90                   	nop
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <sys_cputc>:

void
sys_cputc(const char c)
{
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
  801490:	83 ec 04             	sub    $0x4,%esp
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801499:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	50                   	push   %eax
  8014a6:	6a 01                	push   $0x1
  8014a8:	e8 28 fe ff ff       	call   8012d5 <syscall>
  8014ad:	83 c4 18             	add    $0x18,%esp
}
  8014b0:	90                   	nop
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 14                	push   $0x14
  8014c2:	e8 0e fe ff ff       	call   8012d5 <syscall>
  8014c7:	83 c4 18             	add    $0x18,%esp
}
  8014ca:	90                   	nop
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    

008014cd <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	83 ec 04             	sub    $0x4,%esp
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8014d9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	6a 00                	push   $0x0
  8014e5:	51                   	push   %ecx
  8014e6:	52                   	push   %edx
  8014e7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ea:	50                   	push   %eax
  8014eb:	6a 15                	push   $0x15
  8014ed:	e8 e3 fd ff ff       	call   8012d5 <syscall>
  8014f2:	83 c4 18             	add    $0x18,%esp
}
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8014fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 00                	push   $0x0
  801506:	52                   	push   %edx
  801507:	50                   	push   %eax
  801508:	6a 16                	push   $0x16
  80150a:	e8 c6 fd ff ff       	call   8012d5 <syscall>
  80150f:	83 c4 18             	add    $0x18,%esp
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801517:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80151a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	51                   	push   %ecx
  801525:	52                   	push   %edx
  801526:	50                   	push   %eax
  801527:	6a 17                	push   $0x17
  801529:	e8 a7 fd ff ff       	call   8012d5 <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801536:	8b 55 0c             	mov    0xc(%ebp),%edx
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	52                   	push   %edx
  801543:	50                   	push   %eax
  801544:	6a 18                	push   $0x18
  801546:	e8 8a fd ff ff       	call   8012d5 <syscall>
  80154b:	83 c4 18             	add    $0x18,%esp
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	6a 00                	push   $0x0
  801558:	ff 75 14             	pushl  0x14(%ebp)
  80155b:	ff 75 10             	pushl  0x10(%ebp)
  80155e:	ff 75 0c             	pushl  0xc(%ebp)
  801561:	50                   	push   %eax
  801562:	6a 19                	push   $0x19
  801564:	e8 6c fd ff ff       	call   8012d5 <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <sys_run_env>:

void sys_run_env(int32 envId)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	50                   	push   %eax
  80157d:	6a 1a                	push   $0x1a
  80157f:	e8 51 fd ff ff       	call   8012d5 <syscall>
  801584:	83 c4 18             	add    $0x18,%esp
}
  801587:	90                   	nop
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	50                   	push   %eax
  801599:	6a 1b                	push   $0x1b
  80159b:	e8 35 fd ff ff       	call   8012d5 <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 05                	push   $0x5
  8015b4:	e8 1c fd ff ff       	call   8012d5 <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 06                	push   $0x6
  8015cd:	e8 03 fd ff ff       	call   8012d5 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 07                	push   $0x7
  8015e6:	e8 ea fc ff ff       	call   8012d5 <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_exit_env>:


void sys_exit_env(void)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 1c                	push   $0x1c
  8015ff:	e8 d1 fc ff ff       	call   8012d5 <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	90                   	nop
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801610:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801613:	8d 50 04             	lea    0x4(%eax),%edx
  801616:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	52                   	push   %edx
  801620:	50                   	push   %eax
  801621:	6a 1d                	push   $0x1d
  801623:	e8 ad fc ff ff       	call   8012d5 <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
	return result;
  80162b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801631:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801634:	89 01                	mov    %eax,(%ecx)
  801636:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	c9                   	leave  
  80163d:	c2 04 00             	ret    $0x4

00801640 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	ff 75 10             	pushl  0x10(%ebp)
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	ff 75 08             	pushl  0x8(%ebp)
  801650:	6a 13                	push   $0x13
  801652:	e8 7e fc ff ff       	call   8012d5 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
	return ;
  80165a:	90                   	nop
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_rcr2>:
uint32 sys_rcr2()
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 1e                	push   $0x1e
  80166c:	e8 64 fc ff ff       	call   8012d5 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	83 ec 04             	sub    $0x4,%esp
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801682:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	50                   	push   %eax
  80168f:	6a 1f                	push   $0x1f
  801691:	e8 3f fc ff ff       	call   8012d5 <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
	return ;
  801699:	90                   	nop
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <rsttst>:
void rsttst()
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 21                	push   $0x21
  8016ab:	e8 25 fc ff ff       	call   8012d5 <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b3:	90                   	nop
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 04             	sub    $0x4,%esp
  8016bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016c2:	8b 55 18             	mov    0x18(%ebp),%edx
  8016c5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016c9:	52                   	push   %edx
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 10             	pushl  0x10(%ebp)
  8016ce:	ff 75 0c             	pushl  0xc(%ebp)
  8016d1:	ff 75 08             	pushl  0x8(%ebp)
  8016d4:	6a 20                	push   $0x20
  8016d6:	e8 fa fb ff ff       	call   8012d5 <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
	return ;
  8016de:	90                   	nop
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <chktst>:
void chktst(uint32 n)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	ff 75 08             	pushl  0x8(%ebp)
  8016ef:	6a 22                	push   $0x22
  8016f1:	e8 df fb ff ff       	call   8012d5 <syscall>
  8016f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016f9:	90                   	nop
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <inctst>:

void inctst()
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 23                	push   $0x23
  80170b:	e8 c5 fb ff ff       	call   8012d5 <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
	return ;
  801713:	90                   	nop
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <gettst>:
uint32 gettst()
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 24                	push   $0x24
  801725:	e8 ab fb ff ff       	call   8012d5 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 25                	push   $0x25
  801741:	e8 8f fb ff ff       	call   8012d5 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
  801749:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80174c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801750:	75 07                	jne    801759 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801752:	b8 01 00 00 00       	mov    $0x1,%eax
  801757:	eb 05                	jmp    80175e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 25                	push   $0x25
  801772:	e8 5e fb ff ff       	call   8012d5 <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
  80177a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80177d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801781:	75 07                	jne    80178a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801783:	b8 01 00 00 00       	mov    $0x1,%eax
  801788:	eb 05                	jmp    80178f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80178a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 25                	push   $0x25
  8017a3:	e8 2d fb ff ff       	call   8012d5 <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
  8017ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017ae:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017b2:	75 07                	jne    8017bb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b9:	eb 05                	jmp    8017c0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 25                	push   $0x25
  8017d4:	e8 fc fa ff ff       	call   8012d5 <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
  8017dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017df:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017e3:	75 07                	jne    8017ec <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ea:	eb 05                	jmp    8017f1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	ff 75 08             	pushl  0x8(%ebp)
  801801:	6a 26                	push   $0x26
  801803:	e8 cd fa ff ff       	call   8012d5 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
	return ;
  80180b:	90                   	nop
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801812:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801815:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	53                   	push   %ebx
  801821:	51                   	push   %ecx
  801822:	52                   	push   %edx
  801823:	50                   	push   %eax
  801824:	6a 27                	push   $0x27
  801826:	e8 aa fa ff ff       	call   8012d5 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801836:	8b 55 0c             	mov    0xc(%ebp),%edx
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	52                   	push   %edx
  801843:	50                   	push   %eax
  801844:	6a 28                	push   $0x28
  801846:	e8 8a fa ff ff       	call   8012d5 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  801853:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801856:	8b 55 0c             	mov    0xc(%ebp),%edx
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	6a 00                	push   $0x0
  80185e:	51                   	push   %ecx
  80185f:	ff 75 10             	pushl  0x10(%ebp)
  801862:	52                   	push   %edx
  801863:	50                   	push   %eax
  801864:	6a 29                	push   $0x29
  801866:	e8 6a fa ff ff       	call   8012d5 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	ff 75 10             	pushl  0x10(%ebp)
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	ff 75 08             	pushl  0x8(%ebp)
  801880:	6a 12                	push   $0x12
  801882:	e8 4e fa ff ff       	call   8012d5 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
	return ;
  80188a:	90                   	nop
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  801890:	8b 55 0c             	mov    0xc(%ebp),%edx
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	52                   	push   %edx
  80189d:	50                   	push   %eax
  80189e:	6a 2a                	push   $0x2a
  8018a0:	e8 30 fa ff ff       	call   8012d5 <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
	return;
  8018a8:	90                   	nop
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	68 f6 23 80 00       	push   $0x8023f6
  8018b9:	68 2e 01 00 00       	push   $0x12e
  8018be:	68 0a 24 80 00       	push   $0x80240a
  8018c3:	e8 ad 00 00 00       	call   801975 <_panic>

008018c8 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	68 f6 23 80 00       	push   $0x8023f6
  8018d6:	68 35 01 00 00       	push   $0x135
  8018db:	68 0a 24 80 00       	push   $0x80240a
  8018e0:	e8 90 00 00 00       	call   801975 <_panic>

008018e5 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  8018eb:	83 ec 04             	sub    $0x4,%esp
  8018ee:	68 f6 23 80 00       	push   $0x8023f6
  8018f3:	68 3b 01 00 00       	push   $0x13b
  8018f8:	68 0a 24 80 00       	push   $0x80240a
  8018fd:	e8 73 00 00 00       	call   801975 <_panic>

00801902 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	68 18 24 80 00       	push   $0x802418
  801910:	6a 09                	push   $0x9
  801912:	68 40 24 80 00       	push   $0x802440
  801917:	e8 59 00 00 00       	call   801975 <_panic>

0080191c <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	68 50 24 80 00       	push   $0x802450
  80192a:	6a 10                	push   $0x10
  80192c:	68 40 24 80 00       	push   $0x802440
  801931:	e8 3f 00 00 00       	call   801975 <_panic>

00801936 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	68 78 24 80 00       	push   $0x802478
  801944:	6a 18                	push   $0x18
  801946:	68 40 24 80 00       	push   $0x802440
  80194b:	e8 25 00 00 00       	call   801975 <_panic>

00801950 <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  801956:	83 ec 04             	sub    $0x4,%esp
  801959:	68 a0 24 80 00       	push   $0x8024a0
  80195e:	6a 20                	push   $0x20
  801960:	68 40 24 80 00       	push   $0x802440
  801965:	e8 0b 00 00 00       	call   801975 <_panic>

0080196a <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8b 40 10             	mov    0x10(%eax),%eax
}
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    

00801975 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80197b:	8d 45 10             	lea    0x10(%ebp),%eax
  80197e:	83 c0 04             	add    $0x4,%eax
  801981:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801984:	a1 24 30 80 00       	mov    0x803024,%eax
  801989:	85 c0                	test   %eax,%eax
  80198b:	74 16                	je     8019a3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80198d:	a1 24 30 80 00       	mov    0x803024,%eax
  801992:	83 ec 08             	sub    $0x8,%esp
  801995:	50                   	push   %eax
  801996:	68 c8 24 80 00       	push   $0x8024c8
  80199b:	e8 71 ea ff ff       	call   800411 <cprintf>
  8019a0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8019a3:	a1 00 30 80 00       	mov    0x803000,%eax
  8019a8:	ff 75 0c             	pushl  0xc(%ebp)
  8019ab:	ff 75 08             	pushl  0x8(%ebp)
  8019ae:	50                   	push   %eax
  8019af:	68 cd 24 80 00       	push   $0x8024cd
  8019b4:	e8 58 ea ff ff       	call   800411 <cprintf>
  8019b9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8019bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bf:	83 ec 08             	sub    $0x8,%esp
  8019c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c5:	50                   	push   %eax
  8019c6:	e8 db e9 ff ff       	call   8003a6 <vcprintf>
  8019cb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8019ce:	83 ec 08             	sub    $0x8,%esp
  8019d1:	6a 00                	push   $0x0
  8019d3:	68 e9 24 80 00       	push   $0x8024e9
  8019d8:	e8 c9 e9 ff ff       	call   8003a6 <vcprintf>
  8019dd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019e0:	e8 4a e9 ff ff       	call   80032f <exit>

	// should not return here
	while (1) ;
  8019e5:	eb fe                	jmp    8019e5 <_panic+0x70>

008019e7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019ed:	a1 04 30 80 00       	mov    0x803004,%eax
  8019f2:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8019f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fb:	39 c2                	cmp    %eax,%edx
  8019fd:	74 14                	je     801a13 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	68 ec 24 80 00       	push   $0x8024ec
  801a07:	6a 26                	push   $0x26
  801a09:	68 38 25 80 00       	push   $0x802538
  801a0e:	e8 62 ff ff ff       	call   801975 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a21:	e9 c5 00 00 00       	jmp    801aeb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	01 d0                	add    %edx,%eax
  801a35:	8b 00                	mov    (%eax),%eax
  801a37:	85 c0                	test   %eax,%eax
  801a39:	75 08                	jne    801a43 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a3b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a3e:	e9 a5 00 00 00       	jmp    801ae8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a43:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a4a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a51:	eb 69                	jmp    801abc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a53:	a1 04 30 80 00       	mov    0x803004,%eax
  801a58:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a61:	89 d0                	mov    %edx,%eax
  801a63:	01 c0                	add    %eax,%eax
  801a65:	01 d0                	add    %edx,%eax
  801a67:	c1 e0 03             	shl    $0x3,%eax
  801a6a:	01 c8                	add    %ecx,%eax
  801a6c:	8a 40 04             	mov    0x4(%eax),%al
  801a6f:	84 c0                	test   %al,%al
  801a71:	75 46                	jne    801ab9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a73:	a1 04 30 80 00       	mov    0x803004,%eax
  801a78:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a7e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a81:	89 d0                	mov    %edx,%eax
  801a83:	01 c0                	add    %eax,%eax
  801a85:	01 d0                	add    %edx,%eax
  801a87:	c1 e0 03             	shl    $0x3,%eax
  801a8a:	01 c8                	add    %ecx,%eax
  801a8c:	8b 00                	mov    (%eax),%eax
  801a8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a94:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a99:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	01 c8                	add    %ecx,%eax
  801aaa:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801aac:	39 c2                	cmp    %eax,%edx
  801aae:	75 09                	jne    801ab9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801ab0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801ab7:	eb 15                	jmp    801ace <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ab9:	ff 45 e8             	incl   -0x18(%ebp)
  801abc:	a1 04 30 80 00       	mov    0x803004,%eax
  801ac1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801ac7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aca:	39 c2                	cmp    %eax,%edx
  801acc:	77 85                	ja     801a53 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801ace:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ad2:	75 14                	jne    801ae8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801ad4:	83 ec 04             	sub    $0x4,%esp
  801ad7:	68 44 25 80 00       	push   $0x802544
  801adc:	6a 3a                	push   $0x3a
  801ade:	68 38 25 80 00       	push   $0x802538
  801ae3:	e8 8d fe ff ff       	call   801975 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801ae8:	ff 45 f0             	incl   -0x10(%ebp)
  801aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801af1:	0f 8c 2f ff ff ff    	jl     801a26 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801af7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801afe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b05:	eb 26                	jmp    801b2d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b07:	a1 04 30 80 00       	mov    0x803004,%eax
  801b0c:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b12:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b15:	89 d0                	mov    %edx,%eax
  801b17:	01 c0                	add    %eax,%eax
  801b19:	01 d0                	add    %edx,%eax
  801b1b:	c1 e0 03             	shl    $0x3,%eax
  801b1e:	01 c8                	add    %ecx,%eax
  801b20:	8a 40 04             	mov    0x4(%eax),%al
  801b23:	3c 01                	cmp    $0x1,%al
  801b25:	75 03                	jne    801b2a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b27:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b2a:	ff 45 e0             	incl   -0x20(%ebp)
  801b2d:	a1 04 30 80 00       	mov    0x803004,%eax
  801b32:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b3b:	39 c2                	cmp    %eax,%edx
  801b3d:	77 c8                	ja     801b07 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b42:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b45:	74 14                	je     801b5b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	68 98 25 80 00       	push   $0x802598
  801b4f:	6a 44                	push   $0x44
  801b51:	68 38 25 80 00       	push   $0x802538
  801b56:	e8 1a fe ff ff       	call   801975 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b5b:	90                   	nop
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    
  801b5e:	66 90                	xchg   %ax,%ax

00801b60 <__udivdi3>:
  801b60:	55                   	push   %ebp
  801b61:	57                   	push   %edi
  801b62:	56                   	push   %esi
  801b63:	53                   	push   %ebx
  801b64:	83 ec 1c             	sub    $0x1c,%esp
  801b67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b77:	89 ca                	mov    %ecx,%edx
  801b79:	89 f8                	mov    %edi,%eax
  801b7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b7f:	85 f6                	test   %esi,%esi
  801b81:	75 2d                	jne    801bb0 <__udivdi3+0x50>
  801b83:	39 cf                	cmp    %ecx,%edi
  801b85:	77 65                	ja     801bec <__udivdi3+0x8c>
  801b87:	89 fd                	mov    %edi,%ebp
  801b89:	85 ff                	test   %edi,%edi
  801b8b:	75 0b                	jne    801b98 <__udivdi3+0x38>
  801b8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b92:	31 d2                	xor    %edx,%edx
  801b94:	f7 f7                	div    %edi
  801b96:	89 c5                	mov    %eax,%ebp
  801b98:	31 d2                	xor    %edx,%edx
  801b9a:	89 c8                	mov    %ecx,%eax
  801b9c:	f7 f5                	div    %ebp
  801b9e:	89 c1                	mov    %eax,%ecx
  801ba0:	89 d8                	mov    %ebx,%eax
  801ba2:	f7 f5                	div    %ebp
  801ba4:	89 cf                	mov    %ecx,%edi
  801ba6:	89 fa                	mov    %edi,%edx
  801ba8:	83 c4 1c             	add    $0x1c,%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5e                   	pop    %esi
  801bad:	5f                   	pop    %edi
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    
  801bb0:	39 ce                	cmp    %ecx,%esi
  801bb2:	77 28                	ja     801bdc <__udivdi3+0x7c>
  801bb4:	0f bd fe             	bsr    %esi,%edi
  801bb7:	83 f7 1f             	xor    $0x1f,%edi
  801bba:	75 40                	jne    801bfc <__udivdi3+0x9c>
  801bbc:	39 ce                	cmp    %ecx,%esi
  801bbe:	72 0a                	jb     801bca <__udivdi3+0x6a>
  801bc0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bc4:	0f 87 9e 00 00 00    	ja     801c68 <__udivdi3+0x108>
  801bca:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcf:	89 fa                	mov    %edi,%edx
  801bd1:	83 c4 1c             	add    $0x1c,%esp
  801bd4:	5b                   	pop    %ebx
  801bd5:	5e                   	pop    %esi
  801bd6:	5f                   	pop    %edi
  801bd7:	5d                   	pop    %ebp
  801bd8:	c3                   	ret    
  801bd9:	8d 76 00             	lea    0x0(%esi),%esi
  801bdc:	31 ff                	xor    %edi,%edi
  801bde:	31 c0                	xor    %eax,%eax
  801be0:	89 fa                	mov    %edi,%edx
  801be2:	83 c4 1c             	add    $0x1c,%esp
  801be5:	5b                   	pop    %ebx
  801be6:	5e                   	pop    %esi
  801be7:	5f                   	pop    %edi
  801be8:	5d                   	pop    %ebp
  801be9:	c3                   	ret    
  801bea:	66 90                	xchg   %ax,%ax
  801bec:	89 d8                	mov    %ebx,%eax
  801bee:	f7 f7                	div    %edi
  801bf0:	31 ff                	xor    %edi,%edi
  801bf2:	89 fa                	mov    %edi,%edx
  801bf4:	83 c4 1c             	add    $0x1c,%esp
  801bf7:	5b                   	pop    %ebx
  801bf8:	5e                   	pop    %esi
  801bf9:	5f                   	pop    %edi
  801bfa:	5d                   	pop    %ebp
  801bfb:	c3                   	ret    
  801bfc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c01:	89 eb                	mov    %ebp,%ebx
  801c03:	29 fb                	sub    %edi,%ebx
  801c05:	89 f9                	mov    %edi,%ecx
  801c07:	d3 e6                	shl    %cl,%esi
  801c09:	89 c5                	mov    %eax,%ebp
  801c0b:	88 d9                	mov    %bl,%cl
  801c0d:	d3 ed                	shr    %cl,%ebp
  801c0f:	89 e9                	mov    %ebp,%ecx
  801c11:	09 f1                	or     %esi,%ecx
  801c13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c17:	89 f9                	mov    %edi,%ecx
  801c19:	d3 e0                	shl    %cl,%eax
  801c1b:	89 c5                	mov    %eax,%ebp
  801c1d:	89 d6                	mov    %edx,%esi
  801c1f:	88 d9                	mov    %bl,%cl
  801c21:	d3 ee                	shr    %cl,%esi
  801c23:	89 f9                	mov    %edi,%ecx
  801c25:	d3 e2                	shl    %cl,%edx
  801c27:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c2b:	88 d9                	mov    %bl,%cl
  801c2d:	d3 e8                	shr    %cl,%eax
  801c2f:	09 c2                	or     %eax,%edx
  801c31:	89 d0                	mov    %edx,%eax
  801c33:	89 f2                	mov    %esi,%edx
  801c35:	f7 74 24 0c          	divl   0xc(%esp)
  801c39:	89 d6                	mov    %edx,%esi
  801c3b:	89 c3                	mov    %eax,%ebx
  801c3d:	f7 e5                	mul    %ebp
  801c3f:	39 d6                	cmp    %edx,%esi
  801c41:	72 19                	jb     801c5c <__udivdi3+0xfc>
  801c43:	74 0b                	je     801c50 <__udivdi3+0xf0>
  801c45:	89 d8                	mov    %ebx,%eax
  801c47:	31 ff                	xor    %edi,%edi
  801c49:	e9 58 ff ff ff       	jmp    801ba6 <__udivdi3+0x46>
  801c4e:	66 90                	xchg   %ax,%ax
  801c50:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c54:	89 f9                	mov    %edi,%ecx
  801c56:	d3 e2                	shl    %cl,%edx
  801c58:	39 c2                	cmp    %eax,%edx
  801c5a:	73 e9                	jae    801c45 <__udivdi3+0xe5>
  801c5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c5f:	31 ff                	xor    %edi,%edi
  801c61:	e9 40 ff ff ff       	jmp    801ba6 <__udivdi3+0x46>
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	31 c0                	xor    %eax,%eax
  801c6a:	e9 37 ff ff ff       	jmp    801ba6 <__udivdi3+0x46>
  801c6f:	90                   	nop

00801c70 <__umoddi3>:
  801c70:	55                   	push   %ebp
  801c71:	57                   	push   %edi
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	83 ec 1c             	sub    $0x1c,%esp
  801c77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c8f:	89 f3                	mov    %esi,%ebx
  801c91:	89 fa                	mov    %edi,%edx
  801c93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c97:	89 34 24             	mov    %esi,(%esp)
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	75 1a                	jne    801cb8 <__umoddi3+0x48>
  801c9e:	39 f7                	cmp    %esi,%edi
  801ca0:	0f 86 a2 00 00 00    	jbe    801d48 <__umoddi3+0xd8>
  801ca6:	89 c8                	mov    %ecx,%eax
  801ca8:	89 f2                	mov    %esi,%edx
  801caa:	f7 f7                	div    %edi
  801cac:	89 d0                	mov    %edx,%eax
  801cae:	31 d2                	xor    %edx,%edx
  801cb0:	83 c4 1c             	add    $0x1c,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5f                   	pop    %edi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    
  801cb8:	39 f0                	cmp    %esi,%eax
  801cba:	0f 87 ac 00 00 00    	ja     801d6c <__umoddi3+0xfc>
  801cc0:	0f bd e8             	bsr    %eax,%ebp
  801cc3:	83 f5 1f             	xor    $0x1f,%ebp
  801cc6:	0f 84 ac 00 00 00    	je     801d78 <__umoddi3+0x108>
  801ccc:	bf 20 00 00 00       	mov    $0x20,%edi
  801cd1:	29 ef                	sub    %ebp,%edi
  801cd3:	89 fe                	mov    %edi,%esi
  801cd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cd9:	89 e9                	mov    %ebp,%ecx
  801cdb:	d3 e0                	shl    %cl,%eax
  801cdd:	89 d7                	mov    %edx,%edi
  801cdf:	89 f1                	mov    %esi,%ecx
  801ce1:	d3 ef                	shr    %cl,%edi
  801ce3:	09 c7                	or     %eax,%edi
  801ce5:	89 e9                	mov    %ebp,%ecx
  801ce7:	d3 e2                	shl    %cl,%edx
  801ce9:	89 14 24             	mov    %edx,(%esp)
  801cec:	89 d8                	mov    %ebx,%eax
  801cee:	d3 e0                	shl    %cl,%eax
  801cf0:	89 c2                	mov    %eax,%edx
  801cf2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cf6:	d3 e0                	shl    %cl,%eax
  801cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d00:	89 f1                	mov    %esi,%ecx
  801d02:	d3 e8                	shr    %cl,%eax
  801d04:	09 d0                	or     %edx,%eax
  801d06:	d3 eb                	shr    %cl,%ebx
  801d08:	89 da                	mov    %ebx,%edx
  801d0a:	f7 f7                	div    %edi
  801d0c:	89 d3                	mov    %edx,%ebx
  801d0e:	f7 24 24             	mull   (%esp)
  801d11:	89 c6                	mov    %eax,%esi
  801d13:	89 d1                	mov    %edx,%ecx
  801d15:	39 d3                	cmp    %edx,%ebx
  801d17:	0f 82 87 00 00 00    	jb     801da4 <__umoddi3+0x134>
  801d1d:	0f 84 91 00 00 00    	je     801db4 <__umoddi3+0x144>
  801d23:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d27:	29 f2                	sub    %esi,%edx
  801d29:	19 cb                	sbb    %ecx,%ebx
  801d2b:	89 d8                	mov    %ebx,%eax
  801d2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d31:	d3 e0                	shl    %cl,%eax
  801d33:	89 e9                	mov    %ebp,%ecx
  801d35:	d3 ea                	shr    %cl,%edx
  801d37:	09 d0                	or     %edx,%eax
  801d39:	89 e9                	mov    %ebp,%ecx
  801d3b:	d3 eb                	shr    %cl,%ebx
  801d3d:	89 da                	mov    %ebx,%edx
  801d3f:	83 c4 1c             	add    $0x1c,%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5f                   	pop    %edi
  801d45:	5d                   	pop    %ebp
  801d46:	c3                   	ret    
  801d47:	90                   	nop
  801d48:	89 fd                	mov    %edi,%ebp
  801d4a:	85 ff                	test   %edi,%edi
  801d4c:	75 0b                	jne    801d59 <__umoddi3+0xe9>
  801d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d53:	31 d2                	xor    %edx,%edx
  801d55:	f7 f7                	div    %edi
  801d57:	89 c5                	mov    %eax,%ebp
  801d59:	89 f0                	mov    %esi,%eax
  801d5b:	31 d2                	xor    %edx,%edx
  801d5d:	f7 f5                	div    %ebp
  801d5f:	89 c8                	mov    %ecx,%eax
  801d61:	f7 f5                	div    %ebp
  801d63:	89 d0                	mov    %edx,%eax
  801d65:	e9 44 ff ff ff       	jmp    801cae <__umoddi3+0x3e>
  801d6a:	66 90                	xchg   %ax,%ax
  801d6c:	89 c8                	mov    %ecx,%eax
  801d6e:	89 f2                	mov    %esi,%edx
  801d70:	83 c4 1c             	add    $0x1c,%esp
  801d73:	5b                   	pop    %ebx
  801d74:	5e                   	pop    %esi
  801d75:	5f                   	pop    %edi
  801d76:	5d                   	pop    %ebp
  801d77:	c3                   	ret    
  801d78:	3b 04 24             	cmp    (%esp),%eax
  801d7b:	72 06                	jb     801d83 <__umoddi3+0x113>
  801d7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d81:	77 0f                	ja     801d92 <__umoddi3+0x122>
  801d83:	89 f2                	mov    %esi,%edx
  801d85:	29 f9                	sub    %edi,%ecx
  801d87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d8b:	89 14 24             	mov    %edx,(%esp)
  801d8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d92:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d96:	8b 14 24             	mov    (%esp),%edx
  801d99:	83 c4 1c             	add    $0x1c,%esp
  801d9c:	5b                   	pop    %ebx
  801d9d:	5e                   	pop    %esi
  801d9e:	5f                   	pop    %edi
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    
  801da1:	8d 76 00             	lea    0x0(%esi),%esi
  801da4:	2b 04 24             	sub    (%esp),%eax
  801da7:	19 fa                	sbb    %edi,%edx
  801da9:	89 d1                	mov    %edx,%ecx
  801dab:	89 c6                	mov    %eax,%esi
  801dad:	e9 71 ff ff ff       	jmp    801d23 <__umoddi3+0xb3>
  801db2:	66 90                	xchg   %ax,%ax
  801db4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801db8:	72 ea                	jb     801da4 <__umoddi3+0x134>
  801dba:	89 d9                	mov    %ebx,%ecx
  801dbc:	e9 62 ff ff ff       	jmp    801d23 <__umoddi3+0xb3>
