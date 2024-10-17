
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 47 01 00 00       	call   80017d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 21 15 00 00       	call   801564 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 20 1e 80 00       	push   $0x801e20
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 6a 11 00 00       	call   8011c0 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 22 1e 80 00       	push   $0x801e22
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 54 11 00 00       	call   8011c0 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 29 1e 80 00       	push   $0x801e29
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 3e 11 00 00       	call   8011c0 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	struct semaphore T ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 25                	jne    8000b7 <_main+0x7f>
	{
		T = get_semaphore(parentenvID, "T");
  800092:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800095:	83 ec 04             	sub    $0x4,%esp
  800098:	68 37 1e 80 00       	push   $0x801e37
  80009d:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a0:	50                   	push   %eax
  8000a1:	e8 03 18 00 00       	call   8018a9 <get_semaphore>
  8000a6:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(T);
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000af:	e8 0f 18 00 00       	call   8018c3 <wait_semaphore>
  8000b4:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000b7:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 d4 14 00 00       	call   801597 <sys_get_virtual_time>
  8000c3:	83 c4 0c             	add    $0xc,%esp
  8000c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000c9:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d3:	f7 f1                	div    %ecx
  8000d5:	89 d0                	mov    %edx,%eax
  8000d7:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	50                   	push   %eax
  8000e6:	e8 17 18 00 00       	call   801902 <env_sleep>
  8000eb:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f1:	8b 00                	mov    (%eax),%eax
  8000f3:	40                   	inc    %eax
  8000f4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000f7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 94 14 00 00       	call   801597 <sys_get_virtual_time>
  800103:	83 c4 0c             	add    $0xc,%esp
  800106:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800109:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80010e:	ba 00 00 00 00       	mov    $0x0,%edx
  800113:	f7 f1                	div    %ecx
  800115:	89 d0                	mov    %edx,%eax
  800117:	05 d0 07 00 00       	add    $0x7d0,%eax
  80011c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80011f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 d7 17 00 00       	call   801902 <env_sleep>
  80012b:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80012e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800131:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800134:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800136:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	50                   	push   %eax
  80013d:	e8 55 14 00 00       	call   801597 <sys_get_virtual_time>
  800142:	83 c4 0c             	add    $0xc,%esp
  800145:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800148:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80014d:	ba 00 00 00 00       	mov    $0x0,%edx
  800152:	f7 f1                	div    %ecx
  800154:	89 d0                	mov    %edx,%eax
  800156:	05 d0 07 00 00       	add    $0x7d0,%eax
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80015e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	50                   	push   %eax
  800165:	e8 98 17 00 00       	call   801902 <env_sleep>
  80016a:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80016d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800170:	8b 00                	mov    (%eax),%eax
  800172:	8d 50 01             	lea    0x1(%eax),%edx
  800175:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800178:	89 10                	mov    %edx,(%eax)

}
  80017a:	90                   	nop
  80017b:	c9                   	leave  
  80017c:	c3                   	ret    

0080017d <libmain>:

volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800183:	e8 c3 13 00 00       	call   80154b <sys_getenvindex>
  800188:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80018b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018e:	89 d0                	mov    %edx,%eax
  800190:	c1 e0 06             	shl    $0x6,%eax
  800193:	29 d0                	sub    %edx,%eax
  800195:	c1 e0 02             	shl    $0x2,%eax
  800198:	01 d0                	add    %edx,%eax
  80019a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001a1:	01 c8                	add    %ecx,%eax
  8001a3:	c1 e0 03             	shl    $0x3,%eax
  8001a6:	01 d0                	add    %edx,%eax
  8001a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001af:	29 c2                	sub    %eax,%edx
  8001b1:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8001c0:	a3 04 30 80 00       	mov    %eax,0x803004

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c5:	a1 04 30 80 00       	mov    0x803004,%eax
  8001ca:	8a 40 20             	mov    0x20(%eax),%al
  8001cd:	84 c0                	test   %al,%al
  8001cf:	74 0d                	je     8001de <libmain+0x61>
		binaryname = myEnv->prog_name;
  8001d1:	a1 04 30 80 00       	mov    0x803004,%eax
  8001d6:	83 c0 20             	add    $0x20,%eax
  8001d9:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e2:	7e 0a                	jle    8001ee <libmain+0x71>
		binaryname = argv[0];
  8001e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e7:	8b 00                	mov    (%eax),%eax
  8001e9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	ff 75 0c             	pushl  0xc(%ebp)
  8001f4:	ff 75 08             	pushl  0x8(%ebp)
  8001f7:	e8 3c fe ff ff       	call   800038 <_main>
  8001fc:	83 c4 10             	add    $0x10,%esp



	//	sys_lock_cons();
	sys_lock_cons();
  8001ff:	e8 cb 10 00 00       	call   8012cf <sys_lock_cons>
	{
		cprintf("**************************************\n");
  800204:	83 ec 0c             	sub    $0xc,%esp
  800207:	68 54 1e 80 00       	push   $0x801e54
  80020c:	e8 8d 01 00 00       	call   80039e <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
		cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800214:	a1 04 30 80 00       	mov    0x803004,%eax
  800219:	8b 90 50 da 01 00    	mov    0x1da50(%eax),%edx
  80021f:	a1 04 30 80 00       	mov    0x803004,%eax
  800224:	8b 80 40 da 01 00    	mov    0x1da40(%eax),%eax
  80022a:	83 ec 04             	sub    $0x4,%esp
  80022d:	52                   	push   %edx
  80022e:	50                   	push   %eax
  80022f:	68 7c 1e 80 00       	push   $0x801e7c
  800234:	e8 65 01 00 00       	call   80039e <cprintf>
  800239:	83 c4 10             	add    $0x10,%esp
		cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80023c:	a1 04 30 80 00       	mov    0x803004,%eax
  800241:	8b 88 64 da 01 00    	mov    0x1da64(%eax),%ecx
  800247:	a1 04 30 80 00       	mov    0x803004,%eax
  80024c:	8b 90 60 da 01 00    	mov    0x1da60(%eax),%edx
  800252:	a1 04 30 80 00       	mov    0x803004,%eax
  800257:	8b 80 5c da 01 00    	mov    0x1da5c(%eax),%eax
  80025d:	51                   	push   %ecx
  80025e:	52                   	push   %edx
  80025f:	50                   	push   %eax
  800260:	68 a4 1e 80 00       	push   $0x801ea4
  800265:	e8 34 01 00 00       	call   80039e <cprintf>
  80026a:	83 c4 10             	add    $0x10,%esp
		//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
		cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80026d:	a1 04 30 80 00       	mov    0x803004,%eax
  800272:	8b 80 68 da 01 00    	mov    0x1da68(%eax),%eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	50                   	push   %eax
  80027c:	68 fc 1e 80 00       	push   $0x801efc
  800281:	e8 18 01 00 00       	call   80039e <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
		cprintf("**************************************\n");
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	68 54 1e 80 00       	push   $0x801e54
  800291:	e8 08 01 00 00       	call   80039e <cprintf>
  800296:	83 c4 10             	add    $0x10,%esp
	}
	sys_unlock_cons();
  800299:	e8 4b 10 00 00       	call   8012e9 <sys_unlock_cons>
//	sys_unlock_cons();

	// exit gracefully
	exit();
  80029e:	e8 19 00 00 00       	call   8002bc <exit>
}
  8002a3:	90                   	nop
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ac:	83 ec 0c             	sub    $0xc,%esp
  8002af:	6a 00                	push   $0x0
  8002b1:	e8 61 12 00 00       	call   801517 <sys_destroy_env>
  8002b6:	83 c4 10             	add    $0x10,%esp
}
  8002b9:	90                   	nop
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <exit>:

void
exit(void)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c2:	e8 b6 12 00 00       	call   80157d <sys_exit_env>
}
  8002c7:	90                   	nop
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    

008002ca <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d3:	8b 00                	mov    (%eax),%eax
  8002d5:	8d 48 01             	lea    0x1(%eax),%ecx
  8002d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002db:	89 0a                	mov    %ecx,(%edx)
  8002dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e0:	88 d1                	mov    %dl,%cl
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ec:	8b 00                	mov    (%eax),%eax
  8002ee:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f3:	75 2c                	jne    800321 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002f5:	a0 08 30 80 00       	mov    0x803008,%al
  8002fa:	0f b6 c0             	movzbl %al,%eax
  8002fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800300:	8b 12                	mov    (%edx),%edx
  800302:	89 d1                	mov    %edx,%ecx
  800304:	8b 55 0c             	mov    0xc(%ebp),%edx
  800307:	83 c2 08             	add    $0x8,%edx
  80030a:	83 ec 04             	sub    $0x4,%esp
  80030d:	50                   	push   %eax
  80030e:	51                   	push   %ecx
  80030f:	52                   	push   %edx
  800310:	e8 78 0f 00 00       	call   80128d <sys_cputs>
  800315:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8b 40 04             	mov    0x4(%eax),%eax
  800327:	8d 50 01             	lea    0x1(%eax),%edx
  80032a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800330:	90                   	nop
  800331:	c9                   	leave  
  800332:	c3                   	ret    

00800333 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80033c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800343:	00 00 00 
	b.cnt = 0;
  800346:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80034d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800350:	ff 75 0c             	pushl  0xc(%ebp)
  800353:	ff 75 08             	pushl  0x8(%ebp)
  800356:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80035c:	50                   	push   %eax
  80035d:	68 ca 02 80 00       	push   $0x8002ca
  800362:	e8 11 02 00 00       	call   800578 <vprintfmt>
  800367:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80036a:	a0 08 30 80 00       	mov    0x803008,%al
  80036f:	0f b6 c0             	movzbl %al,%eax
  800372:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800378:	83 ec 04             	sub    $0x4,%esp
  80037b:	50                   	push   %eax
  80037c:	52                   	push   %edx
  80037d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800383:	83 c0 08             	add    $0x8,%eax
  800386:	50                   	push   %eax
  800387:	e8 01 0f 00 00       	call   80128d <sys_cputs>
  80038c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80038f:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
	return b.cnt;
  800396:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80039c:	c9                   	leave  
  80039d:	c3                   	ret    

0080039e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003a4:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
	va_start(ap, fmt);
  8003ab:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ba:	50                   	push   %eax
  8003bb:	e8 73 ff ff ff       	call   800333 <vcprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003c9:	c9                   	leave  
  8003ca:	c3                   	ret    

008003cb <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003cb:	55                   	push   %ebp
  8003cc:	89 e5                	mov    %esp,%ebp
  8003ce:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003d1:	e8 f9 0e 00 00       	call   8012cf <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e5:	50                   	push   %eax
  8003e6:	e8 48 ff ff ff       	call   800333 <vcprintf>
  8003eb:	83 c4 10             	add    $0x10,%esp
  8003ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003f1:	e8 f3 0e 00 00       	call   8012e9 <sys_unlock_cons>
	return cnt;
  8003f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f9:	c9                   	leave  
  8003fa:	c3                   	ret    

008003fb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
  8003fe:	53                   	push   %ebx
  8003ff:	83 ec 14             	sub    $0x14,%esp
  800402:	8b 45 10             	mov    0x10(%ebp),%eax
  800405:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800408:	8b 45 14             	mov    0x14(%ebp),%eax
  80040b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80040e:	8b 45 18             	mov    0x18(%ebp),%eax
  800411:	ba 00 00 00 00       	mov    $0x0,%edx
  800416:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800419:	77 55                	ja     800470 <printnum+0x75>
  80041b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80041e:	72 05                	jb     800425 <printnum+0x2a>
  800420:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800423:	77 4b                	ja     800470 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800425:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800428:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80042b:	8b 45 18             	mov    0x18(%ebp),%eax
  80042e:	ba 00 00 00 00       	mov    $0x0,%edx
  800433:	52                   	push   %edx
  800434:	50                   	push   %eax
  800435:	ff 75 f4             	pushl  -0xc(%ebp)
  800438:	ff 75 f0             	pushl  -0x10(%ebp)
  80043b:	e8 60 17 00 00       	call   801ba0 <__udivdi3>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	ff 75 20             	pushl  0x20(%ebp)
  800449:	53                   	push   %ebx
  80044a:	ff 75 18             	pushl  0x18(%ebp)
  80044d:	52                   	push   %edx
  80044e:	50                   	push   %eax
  80044f:	ff 75 0c             	pushl  0xc(%ebp)
  800452:	ff 75 08             	pushl  0x8(%ebp)
  800455:	e8 a1 ff ff ff       	call   8003fb <printnum>
  80045a:	83 c4 20             	add    $0x20,%esp
  80045d:	eb 1a                	jmp    800479 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	ff 75 0c             	pushl  0xc(%ebp)
  800465:	ff 75 20             	pushl  0x20(%ebp)
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	ff d0                	call   *%eax
  80046d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800470:	ff 4d 1c             	decl   0x1c(%ebp)
  800473:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800477:	7f e6                	jg     80045f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800479:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80047c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800484:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800487:	53                   	push   %ebx
  800488:	51                   	push   %ecx
  800489:	52                   	push   %edx
  80048a:	50                   	push   %eax
  80048b:	e8 20 18 00 00       	call   801cb0 <__umoddi3>
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	05 34 21 80 00       	add    $0x802134,%eax
  800498:	8a 00                	mov    (%eax),%al
  80049a:	0f be c0             	movsbl %al,%eax
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 0c             	pushl  0xc(%ebp)
  8004a3:	50                   	push   %eax
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	ff d0                	call   *%eax
  8004a9:	83 c4 10             	add    $0x10,%esp
}
  8004ac:	90                   	nop
  8004ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004b5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004b9:	7e 1c                	jle    8004d7 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	8d 50 08             	lea    0x8(%eax),%edx
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	89 10                	mov    %edx,(%eax)
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	83 e8 08             	sub    $0x8,%eax
  8004d0:	8b 50 04             	mov    0x4(%eax),%edx
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	eb 40                	jmp    800517 <getuint+0x65>
	else if (lflag)
  8004d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004db:	74 1e                	je     8004fb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	8b 00                	mov    (%eax),%eax
  8004e2:	8d 50 04             	lea    0x4(%eax),%edx
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	89 10                	mov    %edx,(%eax)
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	83 e8 04             	sub    $0x4,%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f9:	eb 1c                	jmp    800517 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 50 04             	lea    0x4(%eax),%edx
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	89 10                	mov    %edx,(%eax)
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	83 e8 04             	sub    $0x4,%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800517:	5d                   	pop    %ebp
  800518:	c3                   	ret    

00800519 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80051c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800520:	7e 1c                	jle    80053e <getint+0x25>
		return va_arg(*ap, long long);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	8d 50 08             	lea    0x8(%eax),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	89 10                	mov    %edx,(%eax)
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	83 e8 08             	sub    $0x8,%eax
  800537:	8b 50 04             	mov    0x4(%eax),%edx
  80053a:	8b 00                	mov    (%eax),%eax
  80053c:	eb 38                	jmp    800576 <getint+0x5d>
	else if (lflag)
  80053e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800542:	74 1a                	je     80055e <getint+0x45>
		return va_arg(*ap, long);
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	8b 00                	mov    (%eax),%eax
  800549:	8d 50 04             	lea    0x4(%eax),%edx
  80054c:	8b 45 08             	mov    0x8(%ebp),%eax
  80054f:	89 10                	mov    %edx,(%eax)
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	8b 00                	mov    (%eax),%eax
  800556:	83 e8 04             	sub    $0x4,%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	99                   	cltd   
  80055c:	eb 18                	jmp    800576 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	8d 50 04             	lea    0x4(%eax),%edx
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	89 10                	mov    %edx,(%eax)
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	83 e8 04             	sub    $0x4,%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	99                   	cltd   
}
  800576:	5d                   	pop    %ebp
  800577:	c3                   	ret    

00800578 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	56                   	push   %esi
  80057c:	53                   	push   %ebx
  80057d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800580:	eb 17                	jmp    800599 <vprintfmt+0x21>
			if (ch == '\0')
  800582:	85 db                	test   %ebx,%ebx
  800584:	0f 84 c1 03 00 00    	je     80094b <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	ff 75 0c             	pushl  0xc(%ebp)
  800590:	53                   	push   %ebx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	ff d0                	call   *%eax
  800596:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800599:	8b 45 10             	mov    0x10(%ebp),%eax
  80059c:	8d 50 01             	lea    0x1(%eax),%edx
  80059f:	89 55 10             	mov    %edx,0x10(%ebp)
  8005a2:	8a 00                	mov    (%eax),%al
  8005a4:	0f b6 d8             	movzbl %al,%ebx
  8005a7:	83 fb 25             	cmp    $0x25,%ebx
  8005aa:	75 d6                	jne    800582 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005ac:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005b0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005b7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005c5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cf:	8d 50 01             	lea    0x1(%eax),%edx
  8005d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8005d5:	8a 00                	mov    (%eax),%al
  8005d7:	0f b6 d8             	movzbl %al,%ebx
  8005da:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005dd:	83 f8 5b             	cmp    $0x5b,%eax
  8005e0:	0f 87 3d 03 00 00    	ja     800923 <vprintfmt+0x3ab>
  8005e6:	8b 04 85 58 21 80 00 	mov    0x802158(,%eax,4),%eax
  8005ed:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005ef:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005f3:	eb d7                	jmp    8005cc <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005f5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005f9:	eb d1                	jmp    8005cc <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005fb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800602:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800605:	89 d0                	mov    %edx,%eax
  800607:	c1 e0 02             	shl    $0x2,%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	01 c0                	add    %eax,%eax
  80060e:	01 d8                	add    %ebx,%eax
  800610:	83 e8 30             	sub    $0x30,%eax
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800616:	8b 45 10             	mov    0x10(%ebp),%eax
  800619:	8a 00                	mov    (%eax),%al
  80061b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80061e:	83 fb 2f             	cmp    $0x2f,%ebx
  800621:	7e 3e                	jle    800661 <vprintfmt+0xe9>
  800623:	83 fb 39             	cmp    $0x39,%ebx
  800626:	7f 39                	jg     800661 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800628:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80062b:	eb d5                	jmp    800602 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80062d:	8b 45 14             	mov    0x14(%ebp),%eax
  800630:	83 c0 04             	add    $0x4,%eax
  800633:	89 45 14             	mov    %eax,0x14(%ebp)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	83 e8 04             	sub    $0x4,%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800641:	eb 1f                	jmp    800662 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800643:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800647:	79 83                	jns    8005cc <vprintfmt+0x54>
				width = 0;
  800649:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800650:	e9 77 ff ff ff       	jmp    8005cc <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800655:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80065c:	e9 6b ff ff ff       	jmp    8005cc <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800661:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800662:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800666:	0f 89 60 ff ff ff    	jns    8005cc <vprintfmt+0x54>
				width = precision, precision = -1;
  80066c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800672:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800679:	e9 4e ff ff ff       	jmp    8005cc <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80067e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800681:	e9 46 ff ff ff       	jmp    8005cc <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	83 c0 04             	add    $0x4,%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	83 e8 04             	sub    $0x4,%eax
  800695:	8b 00                	mov    (%eax),%eax
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	50                   	push   %eax
  80069e:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a1:	ff d0                	call   *%eax
  8006a3:	83 c4 10             	add    $0x10,%esp
			break;
  8006a6:	e9 9b 02 00 00       	jmp    800946 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	83 c0 04             	add    $0x4,%eax
  8006b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	83 e8 04             	sub    $0x4,%eax
  8006ba:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006bc:	85 db                	test   %ebx,%ebx
  8006be:	79 02                	jns    8006c2 <vprintfmt+0x14a>
				err = -err;
  8006c0:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006c2:	83 fb 64             	cmp    $0x64,%ebx
  8006c5:	7f 0b                	jg     8006d2 <vprintfmt+0x15a>
  8006c7:	8b 34 9d a0 1f 80 00 	mov    0x801fa0(,%ebx,4),%esi
  8006ce:	85 f6                	test   %esi,%esi
  8006d0:	75 19                	jne    8006eb <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006d2:	53                   	push   %ebx
  8006d3:	68 45 21 80 00       	push   $0x802145
  8006d8:	ff 75 0c             	pushl  0xc(%ebp)
  8006db:	ff 75 08             	pushl  0x8(%ebp)
  8006de:	e8 70 02 00 00       	call   800953 <printfmt>
  8006e3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006e6:	e9 5b 02 00 00       	jmp    800946 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006eb:	56                   	push   %esi
  8006ec:	68 4e 21 80 00       	push   $0x80214e
  8006f1:	ff 75 0c             	pushl  0xc(%ebp)
  8006f4:	ff 75 08             	pushl  0x8(%ebp)
  8006f7:	e8 57 02 00 00       	call   800953 <printfmt>
  8006fc:	83 c4 10             	add    $0x10,%esp
			break;
  8006ff:	e9 42 02 00 00       	jmp    800946 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	83 c0 04             	add    $0x4,%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	83 e8 04             	sub    $0x4,%eax
  800713:	8b 30                	mov    (%eax),%esi
  800715:	85 f6                	test   %esi,%esi
  800717:	75 05                	jne    80071e <vprintfmt+0x1a6>
				p = "(null)";
  800719:	be 51 21 80 00       	mov    $0x802151,%esi
			if (width > 0 && padc != '-')
  80071e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800722:	7e 6d                	jle    800791 <vprintfmt+0x219>
  800724:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800728:	74 67                	je     800791 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80072a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	50                   	push   %eax
  800731:	56                   	push   %esi
  800732:	e8 1e 03 00 00       	call   800a55 <strnlen>
  800737:	83 c4 10             	add    $0x10,%esp
  80073a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80073d:	eb 16                	jmp    800755 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80073f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	50                   	push   %eax
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	ff d0                	call   *%eax
  80074f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800752:	ff 4d e4             	decl   -0x1c(%ebp)
  800755:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800759:	7f e4                	jg     80073f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80075b:	eb 34                	jmp    800791 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80075d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800761:	74 1c                	je     80077f <vprintfmt+0x207>
  800763:	83 fb 1f             	cmp    $0x1f,%ebx
  800766:	7e 05                	jle    80076d <vprintfmt+0x1f5>
  800768:	83 fb 7e             	cmp    $0x7e,%ebx
  80076b:	7e 12                	jle    80077f <vprintfmt+0x207>
					putch('?', putdat);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	6a 3f                	push   $0x3f
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
  80077d:	eb 0f                	jmp    80078e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	53                   	push   %ebx
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	ff d0                	call   *%eax
  80078b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80078e:	ff 4d e4             	decl   -0x1c(%ebp)
  800791:	89 f0                	mov    %esi,%eax
  800793:	8d 70 01             	lea    0x1(%eax),%esi
  800796:	8a 00                	mov    (%eax),%al
  800798:	0f be d8             	movsbl %al,%ebx
  80079b:	85 db                	test   %ebx,%ebx
  80079d:	74 24                	je     8007c3 <vprintfmt+0x24b>
  80079f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a3:	78 b8                	js     80075d <vprintfmt+0x1e5>
  8007a5:	ff 4d e0             	decl   -0x20(%ebp)
  8007a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007ac:	79 af                	jns    80075d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007ae:	eb 13                	jmp    8007c3 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	6a 20                	push   $0x20
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	ff d0                	call   *%eax
  8007bd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c0:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c7:	7f e7                	jg     8007b0 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007c9:	e9 78 01 00 00       	jmp    800946 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d7:	50                   	push   %eax
  8007d8:	e8 3c fd ff ff       	call   800519 <getint>
  8007dd:	83 c4 10             	add    $0x10,%esp
  8007e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ec:	85 d2                	test   %edx,%edx
  8007ee:	79 23                	jns    800813 <vprintfmt+0x29b>
				putch('-', putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	6a 2d                	push   $0x2d
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	ff d0                	call   *%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800803:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800806:	f7 d8                	neg    %eax
  800808:	83 d2 00             	adc    $0x0,%edx
  80080b:	f7 da                	neg    %edx
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800813:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081a:	e9 bc 00 00 00       	jmp    8008db <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	ff 75 e8             	pushl  -0x18(%ebp)
  800825:	8d 45 14             	lea    0x14(%ebp),%eax
  800828:	50                   	push   %eax
  800829:	e8 84 fc ff ff       	call   8004b2 <getuint>
  80082e:	83 c4 10             	add    $0x10,%esp
  800831:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800834:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800837:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80083e:	e9 98 00 00 00       	jmp    8008db <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	6a 58                	push   $0x58
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	ff d0                	call   *%eax
  800850:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	6a 58                	push   $0x58
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	ff d0                	call   *%eax
  800860:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	6a 58                	push   $0x58
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	ff d0                	call   *%eax
  800870:	83 c4 10             	add    $0x10,%esp
			break;
  800873:	e9 ce 00 00 00       	jmp    800946 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	ff 75 0c             	pushl  0xc(%ebp)
  80087e:	6a 30                	push   $0x30
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	ff d0                	call   *%eax
  800885:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	ff 75 0c             	pushl  0xc(%ebp)
  80088e:	6a 78                	push   $0x78
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 c0 04             	add    $0x4,%eax
  80089e:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	83 e8 04             	sub    $0x4,%eax
  8008a7:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008b3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008ba:	eb 1f                	jmp    8008db <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008bc:	83 ec 08             	sub    $0x8,%esp
  8008bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8008c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c5:	50                   	push   %eax
  8008c6:	e8 e7 fb ff ff       	call   8004b2 <getuint>
  8008cb:	83 c4 10             	add    $0x10,%esp
  8008ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008d4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008db:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e2:	83 ec 04             	sub    $0x4,%esp
  8008e5:	52                   	push   %edx
  8008e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008e9:	50                   	push   %eax
  8008ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 00 fb ff ff       	call   8003fb <printnum>
  8008fb:	83 c4 20             	add    $0x20,%esp
			break;
  8008fe:	eb 46                	jmp    800946 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	53                   	push   %ebx
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
			break;
  80090f:	eb 35                	jmp    800946 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800911:	c6 05 08 30 80 00 00 	movb   $0x0,0x803008
			break;
  800918:	eb 2c                	jmp    800946 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  80091a:	c6 05 08 30 80 00 01 	movb   $0x1,0x803008
			break;
  800921:	eb 23                	jmp    800946 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800923:	83 ec 08             	sub    $0x8,%esp
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	6a 25                	push   $0x25
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	ff d0                	call   *%eax
  800930:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800933:	ff 4d 10             	decl   0x10(%ebp)
  800936:	eb 03                	jmp    80093b <vprintfmt+0x3c3>
  800938:	ff 4d 10             	decl   0x10(%ebp)
  80093b:	8b 45 10             	mov    0x10(%ebp),%eax
  80093e:	48                   	dec    %eax
  80093f:	8a 00                	mov    (%eax),%al
  800941:	3c 25                	cmp    $0x25,%al
  800943:	75 f3                	jne    800938 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800945:	90                   	nop
		}
	}
  800946:	e9 35 fc ff ff       	jmp    800580 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80094b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80094c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80094f:	5b                   	pop    %ebx
  800950:	5e                   	pop    %esi
  800951:	5d                   	pop    %ebp
  800952:	c3                   	ret    

00800953 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800953:	55                   	push   %ebp
  800954:	89 e5                	mov    %esp,%ebp
  800956:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800959:	8d 45 10             	lea    0x10(%ebp),%eax
  80095c:	83 c0 04             	add    $0x4,%eax
  80095f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800962:	8b 45 10             	mov    0x10(%ebp),%eax
  800965:	ff 75 f4             	pushl  -0xc(%ebp)
  800968:	50                   	push   %eax
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	ff 75 08             	pushl  0x8(%ebp)
  80096f:	e8 04 fc ff ff       	call   800578 <vprintfmt>
  800974:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800977:	90                   	nop
  800978:	c9                   	leave  
  800979:	c3                   	ret    

0080097a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80097d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800980:	8b 40 08             	mov    0x8(%eax),%eax
  800983:	8d 50 01             	lea    0x1(%eax),%edx
  800986:	8b 45 0c             	mov    0xc(%ebp),%eax
  800989:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	8b 10                	mov    (%eax),%edx
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
  800994:	8b 40 04             	mov    0x4(%eax),%eax
  800997:	39 c2                	cmp    %eax,%edx
  800999:	73 12                	jae    8009ad <sprintputch+0x33>
		*b->buf++ = ch;
  80099b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099e:	8b 00                	mov    (%eax),%eax
  8009a0:	8d 48 01             	lea    0x1(%eax),%ecx
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a6:	89 0a                	mov    %ecx,(%edx)
  8009a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8009ab:	88 10                	mov    %dl,(%eax)
}
  8009ad:	90                   	nop
  8009ae:	5d                   	pop    %ebp
  8009af:	c3                   	ret    

008009b0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009bf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	01 d0                	add    %edx,%eax
  8009c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009d5:	74 06                	je     8009dd <vsnprintf+0x2d>
  8009d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009db:	7f 07                	jg     8009e4 <vsnprintf+0x34>
		return -E_INVAL;
  8009dd:	b8 03 00 00 00       	mov    $0x3,%eax
  8009e2:	eb 20                	jmp    800a04 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009e4:	ff 75 14             	pushl  0x14(%ebp)
  8009e7:	ff 75 10             	pushl  0x10(%ebp)
  8009ea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009ed:	50                   	push   %eax
  8009ee:	68 7a 09 80 00       	push   $0x80097a
  8009f3:	e8 80 fb ff ff       	call   800578 <vprintfmt>
  8009f8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009fe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800a0f:	83 c0 04             	add    $0x4,%eax
  800a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a15:	8b 45 10             	mov    0x10(%ebp),%eax
  800a18:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1b:	50                   	push   %eax
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	ff 75 08             	pushl  0x8(%ebp)
  800a22:	e8 89 ff ff ff       	call   8009b0 <vsnprintf>
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a30:	c9                   	leave  
  800a31:	c3                   	ret    

00800a32 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a3f:	eb 06                	jmp    800a47 <strlen+0x15>
		n++;
  800a41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a44:	ff 45 08             	incl   0x8(%ebp)
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8a 00                	mov    (%eax),%al
  800a4c:	84 c0                	test   %al,%al
  800a4e:	75 f1                	jne    800a41 <strlen+0xf>
		n++;
	return n;
  800a50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a53:	c9                   	leave  
  800a54:	c3                   	ret    

00800a55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a62:	eb 09                	jmp    800a6d <strnlen+0x18>
		n++;
  800a64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a67:	ff 45 08             	incl   0x8(%ebp)
  800a6a:	ff 4d 0c             	decl   0xc(%ebp)
  800a6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a71:	74 09                	je     800a7c <strnlen+0x27>
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	8a 00                	mov    (%eax),%al
  800a78:	84 c0                	test   %al,%al
  800a7a:	75 e8                	jne    800a64 <strnlen+0xf>
		n++;
	return n;
  800a7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a7f:	c9                   	leave  
  800a80:	c3                   	ret    

00800a81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a8d:	90                   	nop
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	8d 50 01             	lea    0x1(%eax),%edx
  800a94:	89 55 08             	mov    %edx,0x8(%ebp)
  800a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aa0:	8a 12                	mov    (%edx),%dl
  800aa2:	88 10                	mov    %dl,(%eax)
  800aa4:	8a 00                	mov    (%eax),%al
  800aa6:	84 c0                	test   %al,%al
  800aa8:	75 e4                	jne    800a8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800aaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aad:	c9                   	leave  
  800aae:	c3                   	ret    

00800aaf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800abb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ac2:	eb 1f                	jmp    800ae3 <strncpy+0x34>
		*dst++ = *src;
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8d 50 01             	lea    0x1(%eax),%edx
  800aca:	89 55 08             	mov    %edx,0x8(%ebp)
  800acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad0:	8a 12                	mov    (%edx),%dl
  800ad2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	8a 00                	mov    (%eax),%al
  800ad9:	84 c0                	test   %al,%al
  800adb:	74 03                	je     800ae0 <strncpy+0x31>
			src++;
  800add:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ae0:	ff 45 fc             	incl   -0x4(%ebp)
  800ae3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ae9:	72 d9                	jb     800ac4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800aeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800afc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b00:	74 30                	je     800b32 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b02:	eb 16                	jmp    800b1a <strlcpy+0x2a>
			*dst++ = *src++;
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8d 50 01             	lea    0x1(%eax),%edx
  800b0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b16:	8a 12                	mov    (%edx),%dl
  800b18:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b1a:	ff 4d 10             	decl   0x10(%ebp)
  800b1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b21:	74 09                	je     800b2c <strlcpy+0x3c>
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	84 c0                	test   %al,%al
  800b2a:	75 d8                	jne    800b04 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b32:	8b 55 08             	mov    0x8(%ebp),%edx
  800b35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b38:	29 c2                	sub    %eax,%edx
  800b3a:	89 d0                	mov    %edx,%eax
}
  800b3c:	c9                   	leave  
  800b3d:	c3                   	ret    

00800b3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b41:	eb 06                	jmp    800b49 <strcmp+0xb>
		p++, q++;
  800b43:	ff 45 08             	incl   0x8(%ebp)
  800b46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8a 00                	mov    (%eax),%al
  800b4e:	84 c0                	test   %al,%al
  800b50:	74 0e                	je     800b60 <strcmp+0x22>
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	8a 10                	mov    (%eax),%dl
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	8a 00                	mov    (%eax),%al
  800b5c:	38 c2                	cmp    %al,%dl
  800b5e:	74 e3                	je     800b43 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8a 00                	mov    (%eax),%al
  800b65:	0f b6 d0             	movzbl %al,%edx
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	8a 00                	mov    (%eax),%al
  800b6d:	0f b6 c0             	movzbl %al,%eax
  800b70:	29 c2                	sub    %eax,%edx
  800b72:	89 d0                	mov    %edx,%eax
}
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b79:	eb 09                	jmp    800b84 <strncmp+0xe>
		n--, p++, q++;
  800b7b:	ff 4d 10             	decl   0x10(%ebp)
  800b7e:	ff 45 08             	incl   0x8(%ebp)
  800b81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b88:	74 17                	je     800ba1 <strncmp+0x2b>
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8a 00                	mov    (%eax),%al
  800b8f:	84 c0                	test   %al,%al
  800b91:	74 0e                	je     800ba1 <strncmp+0x2b>
  800b93:	8b 45 08             	mov    0x8(%ebp),%eax
  800b96:	8a 10                	mov    (%eax),%dl
  800b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9b:	8a 00                	mov    (%eax),%al
  800b9d:	38 c2                	cmp    %al,%dl
  800b9f:	74 da                	je     800b7b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ba1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ba5:	75 07                	jne    800bae <strncmp+0x38>
		return 0;
  800ba7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bac:	eb 14                	jmp    800bc2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	0f b6 d0             	movzbl %al,%edx
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8a 00                	mov    (%eax),%al
  800bbb:	0f b6 c0             	movzbl %al,%eax
  800bbe:	29 c2                	sub    %eax,%edx
  800bc0:	89 d0                	mov    %edx,%eax
}
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	83 ec 04             	sub    $0x4,%esp
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bd0:	eb 12                	jmp    800be4 <strchr+0x20>
		if (*s == c)
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bda:	75 05                	jne    800be1 <strchr+0x1d>
			return (char *) s;
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	eb 11                	jmp    800bf2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800be1:	ff 45 08             	incl   0x8(%ebp)
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8a 00                	mov    (%eax),%al
  800be9:	84 c0                	test   %al,%al
  800beb:	75 e5                	jne    800bd2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf2:	c9                   	leave  
  800bf3:	c3                   	ret    

00800bf4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 04             	sub    $0x4,%esp
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c00:	eb 0d                	jmp    800c0f <strfind+0x1b>
		if (*s == c)
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8a 00                	mov    (%eax),%al
  800c07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c0a:	74 0e                	je     800c1a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c0c:	ff 45 08             	incl   0x8(%ebp)
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	84 c0                	test   %al,%al
  800c16:	75 ea                	jne    800c02 <strfind+0xe>
  800c18:	eb 01                	jmp    800c1b <strfind+0x27>
		if (*s == c)
			break;
  800c1a:	90                   	nop
	return (char *) s;
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c32:	eb 0e                	jmp    800c42 <memset+0x22>
		*p++ = c;
  800c34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c37:	8d 50 01             	lea    0x1(%eax),%edx
  800c3a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c40:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c42:	ff 4d f8             	decl   -0x8(%ebp)
  800c45:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c49:	79 e9                	jns    800c34 <memset+0x14>
		*p++ = c;

	return v;
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c4e:	c9                   	leave  
  800c4f:	c3                   	ret    

00800c50 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c62:	eb 16                	jmp    800c7a <memcpy+0x2a>
		*d++ = *s++;
  800c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c67:	8d 50 01             	lea    0x1(%eax),%edx
  800c6a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c73:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c76:	8a 12                	mov    (%edx),%dl
  800c78:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c80:	89 55 10             	mov    %edx,0x10(%ebp)
  800c83:	85 c0                	test   %eax,%eax
  800c85:	75 dd                	jne    800c64 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c8a:	c9                   	leave  
  800c8b:	c3                   	ret    

00800c8c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c8c:	55                   	push   %ebp
  800c8d:	89 e5                	mov    %esp,%ebp
  800c8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ca4:	73 50                	jae    800cf6 <memmove+0x6a>
  800ca6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	01 d0                	add    %edx,%eax
  800cae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cb1:	76 43                	jbe    800cf6 <memmove+0x6a>
		s += n;
  800cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cbf:	eb 10                	jmp    800cd1 <memmove+0x45>
			*--d = *--s;
  800cc1:	ff 4d f8             	decl   -0x8(%ebp)
  800cc4:	ff 4d fc             	decl   -0x4(%ebp)
  800cc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cca:	8a 10                	mov    (%eax),%dl
  800ccc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cda:	85 c0                	test   %eax,%eax
  800cdc:	75 e3                	jne    800cc1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cde:	eb 23                	jmp    800d03 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ce0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ce3:	8d 50 01             	lea    0x1(%eax),%edx
  800ce6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ce9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cf2:	8a 12                	mov    (%edx),%dl
  800cf4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cfc:	89 55 10             	mov    %edx,0x10(%ebp)
  800cff:	85 c0                	test   %eax,%eax
  800d01:	75 dd                	jne    800ce0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d06:	c9                   	leave  
  800d07:	c3                   	ret    

00800d08 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d1a:	eb 2a                	jmp    800d46 <memcmp+0x3e>
		if (*s1 != *s2)
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1f:	8a 10                	mov    (%eax),%dl
  800d21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	38 c2                	cmp    %al,%dl
  800d28:	74 16                	je     800d40 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	0f b6 d0             	movzbl %al,%edx
  800d32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 c0             	movzbl %al,%eax
  800d3a:	29 c2                	sub    %eax,%edx
  800d3c:	89 d0                	mov    %edx,%eax
  800d3e:	eb 18                	jmp    800d58 <memcmp+0x50>
		s1++, s2++;
  800d40:	ff 45 fc             	incl   -0x4(%ebp)
  800d43:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d46:	8b 45 10             	mov    0x10(%ebp),%eax
  800d49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	75 c9                	jne    800d1c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d58:	c9                   	leave  
  800d59:	c3                   	ret    

00800d5a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d60:	8b 55 08             	mov    0x8(%ebp),%edx
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	01 d0                	add    %edx,%eax
  800d68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d6b:	eb 15                	jmp    800d82 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	0f b6 d0             	movzbl %al,%edx
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	0f b6 c0             	movzbl %al,%eax
  800d7b:	39 c2                	cmp    %eax,%edx
  800d7d:	74 0d                	je     800d8c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d7f:	ff 45 08             	incl   0x8(%ebp)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d88:	72 e3                	jb     800d6d <memfind+0x13>
  800d8a:	eb 01                	jmp    800d8d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d8c:	90                   	nop
	return (void *) s;
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d90:	c9                   	leave  
  800d91:	c3                   	ret    

00800d92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d9f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800da6:	eb 03                	jmp    800dab <strtol+0x19>
		s++;
  800da8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	3c 20                	cmp    $0x20,%al
  800db2:	74 f4                	je     800da8 <strtol+0x16>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	3c 09                	cmp    $0x9,%al
  800dbb:	74 eb                	je     800da8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	3c 2b                	cmp    $0x2b,%al
  800dc4:	75 05                	jne    800dcb <strtol+0x39>
		s++;
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	eb 13                	jmp    800dde <strtol+0x4c>
	else if (*s == '-')
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	3c 2d                	cmp    $0x2d,%al
  800dd2:	75 0a                	jne    800dde <strtol+0x4c>
		s++, neg = 1;
  800dd4:	ff 45 08             	incl   0x8(%ebp)
  800dd7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800de2:	74 06                	je     800dea <strtol+0x58>
  800de4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800de8:	75 20                	jne    800e0a <strtol+0x78>
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	3c 30                	cmp    $0x30,%al
  800df1:	75 17                	jne    800e0a <strtol+0x78>
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	40                   	inc    %eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	3c 78                	cmp    $0x78,%al
  800dfb:	75 0d                	jne    800e0a <strtol+0x78>
		s += 2, base = 16;
  800dfd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e01:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e08:	eb 28                	jmp    800e32 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0e:	75 15                	jne    800e25 <strtol+0x93>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	3c 30                	cmp    $0x30,%al
  800e17:	75 0c                	jne    800e25 <strtol+0x93>
		s++, base = 8;
  800e19:	ff 45 08             	incl   0x8(%ebp)
  800e1c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e23:	eb 0d                	jmp    800e32 <strtol+0xa0>
	else if (base == 0)
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	75 07                	jne    800e32 <strtol+0xa0>
		base = 10;
  800e2b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	3c 2f                	cmp    $0x2f,%al
  800e39:	7e 19                	jle    800e54 <strtol+0xc2>
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	3c 39                	cmp    $0x39,%al
  800e42:	7f 10                	jg     800e54 <strtol+0xc2>
			dig = *s - '0';
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	0f be c0             	movsbl %al,%eax
  800e4c:	83 e8 30             	sub    $0x30,%eax
  800e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e52:	eb 42                	jmp    800e96 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3c 60                	cmp    $0x60,%al
  800e5b:	7e 19                	jle    800e76 <strtol+0xe4>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	3c 7a                	cmp    $0x7a,%al
  800e64:	7f 10                	jg     800e76 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	0f be c0             	movsbl %al,%eax
  800e6e:	83 e8 57             	sub    $0x57,%eax
  800e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e74:	eb 20                	jmp    800e96 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8a 00                	mov    (%eax),%al
  800e7b:	3c 40                	cmp    $0x40,%al
  800e7d:	7e 39                	jle    800eb8 <strtol+0x126>
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	3c 5a                	cmp    $0x5a,%al
  800e86:	7f 30                	jg     800eb8 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	0f be c0             	movsbl %al,%eax
  800e90:	83 e8 37             	sub    $0x37,%eax
  800e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e9c:	7d 19                	jge    800eb7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e9e:	ff 45 08             	incl   0x8(%ebp)
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ea8:	89 c2                	mov    %eax,%edx
  800eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ead:	01 d0                	add    %edx,%eax
  800eaf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800eb2:	e9 7b ff ff ff       	jmp    800e32 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800eb7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800eb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebc:	74 08                	je     800ec6 <strtol+0x134>
		*endptr = (char *) s;
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ec6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800eca:	74 07                	je     800ed3 <strtol+0x141>
  800ecc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecf:	f7 d8                	neg    %eax
  800ed1:	eb 03                	jmp    800ed6 <strtol+0x144>
  800ed3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ed6:	c9                   	leave  
  800ed7:	c3                   	ret    

00800ed8 <ltostr>:

void
ltostr(long value, char *str)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ede:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800ee5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ef0:	79 13                	jns    800f05 <ltostr+0x2d>
	{
		neg = 1;
  800ef2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f02:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f0d:	99                   	cltd   
  800f0e:	f7 f9                	idiv   %ecx
  800f10:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f16:	8d 50 01             	lea    0x1(%eax),%edx
  800f19:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f1c:	89 c2                	mov    %eax,%edx
  800f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f21:	01 d0                	add    %edx,%eax
  800f23:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f26:	83 c2 30             	add    $0x30,%edx
  800f29:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f33:	f7 e9                	imul   %ecx
  800f35:	c1 fa 02             	sar    $0x2,%edx
  800f38:	89 c8                	mov    %ecx,%eax
  800f3a:	c1 f8 1f             	sar    $0x1f,%eax
  800f3d:	29 c2                	sub    %eax,%edx
  800f3f:	89 d0                	mov    %edx,%eax
  800f41:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f48:	75 bb                	jne    800f05 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f54:	48                   	dec    %eax
  800f55:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f58:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f5c:	74 3d                	je     800f9b <ltostr+0xc3>
		start = 1 ;
  800f5e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f65:	eb 34                	jmp    800f9b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 d0                	add    %edx,%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7a:	01 c2                	add    %eax,%edx
  800f7c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f82:	01 c8                	add    %ecx,%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	01 c2                	add    %eax,%edx
  800f90:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f93:	88 02                	mov    %al,(%edx)
		start++ ;
  800f95:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f98:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f9e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fa1:	7c c4                	jl     800f67 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fa3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa9:	01 d0                	add    %edx,%eax
  800fab:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fae:	90                   	nop
  800faf:	c9                   	leave  
  800fb0:	c3                   	ret    

00800fb1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fb7:	ff 75 08             	pushl  0x8(%ebp)
  800fba:	e8 73 fa ff ff       	call   800a32 <strlen>
  800fbf:	83 c4 04             	add    $0x4,%esp
  800fc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	e8 65 fa ff ff       	call   800a32 <strlen>
  800fcd:	83 c4 04             	add    $0x4,%esp
  800fd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fda:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fe1:	eb 17                	jmp    800ffa <strcconcat+0x49>
		final[s] = str1[s] ;
  800fe3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	01 c2                	add    %eax,%edx
  800feb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	01 c8                	add    %ecx,%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ff7:	ff 45 fc             	incl   -0x4(%ebp)
  800ffa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801000:	7c e1                	jl     800fe3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801002:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801009:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801010:	eb 1f                	jmp    801031 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801012:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801015:	8d 50 01             	lea    0x1(%eax),%edx
  801018:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80101b:	89 c2                	mov    %eax,%edx
  80101d:	8b 45 10             	mov    0x10(%ebp),%eax
  801020:	01 c2                	add    %eax,%edx
  801022:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	01 c8                	add    %ecx,%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80102e:	ff 45 f8             	incl   -0x8(%ebp)
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801034:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801037:	7c d9                	jl     801012 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801039:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80103c:	8b 45 10             	mov    0x10(%ebp),%eax
  80103f:	01 d0                	add    %edx,%eax
  801041:	c6 00 00             	movb   $0x0,(%eax)
}
  801044:	90                   	nop
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80104a:	8b 45 14             	mov    0x14(%ebp),%eax
  80104d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801053:	8b 45 14             	mov    0x14(%ebp),%eax
  801056:	8b 00                	mov    (%eax),%eax
  801058:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80105f:	8b 45 10             	mov    0x10(%ebp),%eax
  801062:	01 d0                	add    %edx,%eax
  801064:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80106a:	eb 0c                	jmp    801078 <strsplit+0x31>
			*string++ = 0;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8d 50 01             	lea    0x1(%eax),%edx
  801072:	89 55 08             	mov    %edx,0x8(%ebp)
  801075:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801078:	8b 45 08             	mov    0x8(%ebp),%eax
  80107b:	8a 00                	mov    (%eax),%al
  80107d:	84 c0                	test   %al,%al
  80107f:	74 18                	je     801099 <strsplit+0x52>
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	8a 00                	mov    (%eax),%al
  801086:	0f be c0             	movsbl %al,%eax
  801089:	50                   	push   %eax
  80108a:	ff 75 0c             	pushl  0xc(%ebp)
  80108d:	e8 32 fb ff ff       	call   800bc4 <strchr>
  801092:	83 c4 08             	add    $0x8,%esp
  801095:	85 c0                	test   %eax,%eax
  801097:	75 d3                	jne    80106c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	8a 00                	mov    (%eax),%al
  80109e:	84 c0                	test   %al,%al
  8010a0:	74 5a                	je     8010fc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a5:	8b 00                	mov    (%eax),%eax
  8010a7:	83 f8 0f             	cmp    $0xf,%eax
  8010aa:	75 07                	jne    8010b3 <strsplit+0x6c>
		{
			return 0;
  8010ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b1:	eb 66                	jmp    801119 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b6:	8b 00                	mov    (%eax),%eax
  8010b8:	8d 48 01             	lea    0x1(%eax),%ecx
  8010bb:	8b 55 14             	mov    0x14(%ebp),%edx
  8010be:	89 0a                	mov    %ecx,(%edx)
  8010c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	01 c2                	add    %eax,%edx
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010d1:	eb 03                	jmp    8010d6 <strsplit+0x8f>
			string++;
  8010d3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	84 c0                	test   %al,%al
  8010dd:	74 8b                	je     80106a <strsplit+0x23>
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	0f be c0             	movsbl %al,%eax
  8010e7:	50                   	push   %eax
  8010e8:	ff 75 0c             	pushl  0xc(%ebp)
  8010eb:	e8 d4 fa ff ff       	call   800bc4 <strchr>
  8010f0:	83 c4 08             	add    $0x8,%esp
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	74 dc                	je     8010d3 <strsplit+0x8c>
			string++;
	}
  8010f7:	e9 6e ff ff ff       	jmp    80106a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010fc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801100:	8b 00                	mov    (%eax),%eax
  801102:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801109:	8b 45 10             	mov    0x10(%ebp),%eax
  80110c:	01 d0                	add    %edx,%eax
  80110e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801114:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801121:	83 ec 04             	sub    $0x4,%esp
  801124:	68 c8 22 80 00       	push   $0x8022c8
  801129:	68 3f 01 00 00       	push   $0x13f
  80112e:	68 ea 22 80 00       	push   $0x8022ea
  801133:	e8 7e 08 00 00       	call   8019b6 <_panic>

00801138 <sbrk>:
//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  80113e:	83 ec 0c             	sub    $0xc,%esp
  801141:	ff 75 08             	pushl  0x8(%ebp)
  801144:	e8 ef 06 00 00       	call   801838 <sys_sbrk>
  801149:	83 c4 10             	add    $0x10,%esp
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <malloc>:

//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  801154:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801158:	75 07                	jne    801161 <malloc+0x13>
  80115a:	b8 00 00 00 00       	mov    $0x0,%eax
  80115f:	eb 14                	jmp    801175 <malloc+0x27>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - malloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801161:	83 ec 04             	sub    $0x4,%esp
  801164:	68 f8 22 80 00       	push   $0x8022f8
  801169:	6a 1b                	push   $0x1b
  80116b:	68 1d 23 80 00       	push   $0x80231d
  801170:	e8 41 08 00 00       	call   8019b6 <_panic>
	return NULL;
	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

}
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <free>:

//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - free() [User Side]
	// Write your code here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80117d:	83 ec 04             	sub    $0x4,%esp
  801180:	68 2c 23 80 00       	push   $0x80232c
  801185:	6a 29                	push   $0x29
  801187:	68 1d 23 80 00       	push   $0x80231d
  80118c:	e8 25 08 00 00       	call   8019b6 <_panic>

00801191 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 18             	sub    $0x18,%esp
  801197:	8b 45 10             	mov    0x10(%ebp),%eax
  80119a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0) return NULL ;
  80119d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a1:	75 07                	jne    8011aa <smalloc+0x19>
  8011a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a8:	eb 14                	jmp    8011be <smalloc+0x2d>
	//==============================================================
	//[PROJECT'24.MS2] [2] USER HEAP - smalloc() [User Side]
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8011aa:	83 ec 04             	sub    $0x4,%esp
  8011ad:	68 50 23 80 00       	push   $0x802350
  8011b2:	6a 38                	push   $0x38
  8011b4:	68 1d 23 80 00       	push   $0x80231d
  8011b9:	e8 f8 07 00 00       	call   8019b6 <_panic>
	return NULL;
}
  8011be:	c9                   	leave  
  8011bf:	c3                   	ret    

008011c0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2] [2] USER HEAP - sget() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8011c6:	83 ec 04             	sub    $0x4,%esp
  8011c9:	68 78 23 80 00       	push   $0x802378
  8011ce:	6a 43                	push   $0x43
  8011d0:	68 1d 23 80 00       	push   $0x80231d
  8011d5:	e8 dc 07 00 00       	call   8019b6 <_panic>

008011da <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS2 BONUS] [2] USER HEAP - sfree() [User Side]
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8011e0:	83 ec 04             	sub    $0x4,%esp
  8011e3:	68 9c 23 80 00       	push   $0x80239c
  8011e8:	6a 5b                	push   $0x5b
  8011ea:	68 1d 23 80 00       	push   $0x80231d
  8011ef:	e8 c2 07 00 00       	call   8019b6 <_panic>

008011f4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8011fa:	83 ec 04             	sub    $0x4,%esp
  8011fd:	68 c0 23 80 00       	push   $0x8023c0
  801202:	6a 72                	push   $0x72
  801204:	68 1d 23 80 00       	push   $0x80231d
  801209:	e8 a8 07 00 00       	call   8019b6 <_panic>

0080120e <expand>:
//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801214:	83 ec 04             	sub    $0x4,%esp
  801217:	68 e6 23 80 00       	push   $0x8023e6
  80121c:	6a 7e                	push   $0x7e
  80121e:	68 1d 23 80 00       	push   $0x80231d
  801223:	e8 8e 07 00 00       	call   8019b6 <_panic>

00801228 <shrink>:

}
void shrink(uint32 newSize)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80122e:	83 ec 04             	sub    $0x4,%esp
  801231:	68 e6 23 80 00       	push   $0x8023e6
  801236:	68 83 00 00 00       	push   $0x83
  80123b:	68 1d 23 80 00       	push   $0x80231d
  801240:	e8 71 07 00 00       	call   8019b6 <_panic>

00801245 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80124b:	83 ec 04             	sub    $0x4,%esp
  80124e:	68 e6 23 80 00       	push   $0x8023e6
  801253:	68 88 00 00 00       	push   $0x88
  801258:	68 1d 23 80 00       	push   $0x80231d
  80125d:	e8 54 07 00 00       	call   8019b6 <_panic>

00801262 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	57                   	push   %edi
  801266:	56                   	push   %esi
  801267:	53                   	push   %ebx
  801268:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801271:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801274:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801277:	8b 7d 18             	mov    0x18(%ebp),%edi
  80127a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80127d:	cd 30                	int    $0x30
  80127f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801282:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801285:	83 c4 10             	add    $0x10,%esp
  801288:	5b                   	pop    %ebx
  801289:	5e                   	pop    %esi
  80128a:	5f                   	pop    %edi
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    

0080128d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	8b 45 10             	mov    0x10(%ebp),%eax
  801296:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801299:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	6a 00                	push   $0x0
  8012a2:	6a 00                	push   $0x0
  8012a4:	52                   	push   %edx
  8012a5:	ff 75 0c             	pushl  0xc(%ebp)
  8012a8:	50                   	push   %eax
  8012a9:	6a 00                	push   $0x0
  8012ab:	e8 b2 ff ff ff       	call   801262 <syscall>
  8012b0:	83 c4 18             	add    $0x18,%esp
}
  8012b3:	90                   	nop
  8012b4:	c9                   	leave  
  8012b5:	c3                   	ret    

008012b6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012b6:	55                   	push   %ebp
  8012b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 02                	push   $0x2
  8012c5:	e8 98 ff ff ff       	call   801262 <syscall>
  8012ca:	83 c4 18             	add    $0x18,%esp
}
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <sys_lock_cons>:

void sys_lock_cons(void)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 03                	push   $0x3
  8012de:	e8 7f ff ff ff       	call   801262 <syscall>
  8012e3:	83 c4 18             	add    $0x18,%esp
}
  8012e6:	90                   	nop
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 04                	push   $0x4
  8012f8:	e8 65 ff ff ff       	call   801262 <syscall>
  8012fd:	83 c4 18             	add    $0x18,%esp
}
  801300:	90                   	nop
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801306:	8b 55 0c             	mov    0xc(%ebp),%edx
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	52                   	push   %edx
  801313:	50                   	push   %eax
  801314:	6a 08                	push   $0x8
  801316:	e8 47 ff ff ff       	call   801262 <syscall>
  80131b:	83 c4 18             	add    $0x18,%esp
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	56                   	push   %esi
  801324:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801325:	8b 75 18             	mov    0x18(%ebp),%esi
  801328:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80132b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80132e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801331:	8b 45 08             	mov    0x8(%ebp),%eax
  801334:	56                   	push   %esi
  801335:	53                   	push   %ebx
  801336:	51                   	push   %ecx
  801337:	52                   	push   %edx
  801338:	50                   	push   %eax
  801339:	6a 09                	push   $0x9
  80133b:	e8 22 ff ff ff       	call   801262 <syscall>
  801340:	83 c4 18             	add    $0x18,%esp
}
  801343:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801346:	5b                   	pop    %ebx
  801347:	5e                   	pop    %esi
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    

0080134a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80134d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	52                   	push   %edx
  80135a:	50                   	push   %eax
  80135b:	6a 0a                	push   $0xa
  80135d:	e8 00 ff ff ff       	call   801262 <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	ff 75 0c             	pushl  0xc(%ebp)
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	6a 0b                	push   $0xb
  801378:	e8 e5 fe ff ff       	call   801262 <syscall>
  80137d:	83 c4 18             	add    $0x18,%esp
}
  801380:	c9                   	leave  
  801381:	c3                   	ret    

00801382 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 0c                	push   $0xc
  801391:	e8 cc fe ff ff       	call   801262 <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 0d                	push   $0xd
  8013aa:	e8 b3 fe ff ff       	call   801262 <syscall>
  8013af:	83 c4 18             	add    $0x18,%esp
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 0e                	push   $0xe
  8013c3:	e8 9a fe ff ff       	call   801262 <syscall>
  8013c8:	83 c4 18             	add    $0x18,%esp
}
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    

008013cd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 0f                	push   $0xf
  8013dc:	e8 81 fe ff ff       	call   801262 <syscall>
  8013e1:	83 c4 18             	add    $0x18,%esp
}
  8013e4:	c9                   	leave  
  8013e5:	c3                   	ret    

008013e6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	ff 75 08             	pushl  0x8(%ebp)
  8013f4:	6a 10                	push   $0x10
  8013f6:	e8 67 fe ff ff       	call   801262 <syscall>
  8013fb:	83 c4 18             	add    $0x18,%esp
}
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    

00801400 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 11                	push   $0x11
  80140f:	e8 4e fe ff ff       	call   801262 <syscall>
  801414:	83 c4 18             	add    $0x18,%esp
}
  801417:	90                   	nop
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <sys_cputc>:

void
sys_cputc(const char c)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 04             	sub    $0x4,%esp
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801426:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	50                   	push   %eax
  801433:	6a 01                	push   $0x1
  801435:	e8 28 fe ff ff       	call   801262 <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 14                	push   $0x14
  80144f:	e8 0e fe ff ff       	call   801262 <syscall>
  801454:	83 c4 18             	add    $0x18,%esp
}
  801457:	90                   	nop
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	8b 45 10             	mov    0x10(%ebp),%eax
  801463:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801466:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801469:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	6a 00                	push   $0x0
  801472:	51                   	push   %ecx
  801473:	52                   	push   %edx
  801474:	ff 75 0c             	pushl  0xc(%ebp)
  801477:	50                   	push   %eax
  801478:	6a 15                	push   $0x15
  80147a:	e8 e3 fd ff ff       	call   801262 <syscall>
  80147f:	83 c4 18             	add    $0x18,%esp
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	52                   	push   %edx
  801494:	50                   	push   %eax
  801495:	6a 16                	push   $0x16
  801497:	e8 c6 fd ff ff       	call   801262 <syscall>
  80149c:	83 c4 18             	add    $0x18,%esp
}
  80149f:	c9                   	leave  
  8014a0:	c3                   	ret    

008014a1 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8014a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	51                   	push   %ecx
  8014b2:	52                   	push   %edx
  8014b3:	50                   	push   %eax
  8014b4:	6a 17                	push   $0x17
  8014b6:	e8 a7 fd ff ff       	call   801262 <syscall>
  8014bb:	83 c4 18             	add    $0x18,%esp
}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8014c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	52                   	push   %edx
  8014d0:	50                   	push   %eax
  8014d1:	6a 18                	push   $0x18
  8014d3:	e8 8a fd ff ff       	call   801262 <syscall>
  8014d8:	83 c4 18             	add    $0x18,%esp
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	6a 00                	push   $0x0
  8014e5:	ff 75 14             	pushl  0x14(%ebp)
  8014e8:	ff 75 10             	pushl  0x10(%ebp)
  8014eb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ee:	50                   	push   %eax
  8014ef:	6a 19                	push   $0x19
  8014f1:	e8 6c fd ff ff       	call   801262 <syscall>
  8014f6:	83 c4 18             	add    $0x18,%esp
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <sys_run_env>:

void sys_run_env(int32 envId)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	50                   	push   %eax
  80150a:	6a 1a                	push   $0x1a
  80150c:	e8 51 fd ff ff       	call   801262 <syscall>
  801511:	83 c4 18             	add    $0x18,%esp
}
  801514:	90                   	nop
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80151a:	8b 45 08             	mov    0x8(%ebp),%eax
  80151d:	6a 00                	push   $0x0
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	50                   	push   %eax
  801526:	6a 1b                	push   $0x1b
  801528:	e8 35 fd ff ff       	call   801262 <syscall>
  80152d:	83 c4 18             	add    $0x18,%esp
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 05                	push   $0x5
  801541:	e8 1c fd ff ff       	call   801262 <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
}
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 06                	push   $0x6
  80155a:	e8 03 fd ff ff       	call   801262 <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 07                	push   $0x7
  801573:	e8 ea fc ff ff       	call   801262 <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_exit_env>:


void sys_exit_env(void)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 1c                	push   $0x1c
  80158c:	e8 d1 fc ff ff       	call   801262 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	90                   	nop
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80159d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015a0:	8d 50 04             	lea    0x4(%eax),%edx
  8015a3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	52                   	push   %edx
  8015ad:	50                   	push   %eax
  8015ae:	6a 1d                	push   $0x1d
  8015b0:	e8 ad fc ff ff       	call   801262 <syscall>
  8015b5:	83 c4 18             	add    $0x18,%esp
	return result;
  8015b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015c1:	89 01                	mov    %eax,(%ecx)
  8015c3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	c9                   	leave  
  8015ca:	c2 04 00             	ret    $0x4

008015cd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	ff 75 10             	pushl  0x10(%ebp)
  8015d7:	ff 75 0c             	pushl  0xc(%ebp)
  8015da:	ff 75 08             	pushl  0x8(%ebp)
  8015dd:	6a 13                	push   $0x13
  8015df:	e8 7e fc ff ff       	call   801262 <syscall>
  8015e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8015e7:	90                   	nop
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_rcr2>:
uint32 sys_rcr2()
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 1e                	push   $0x1e
  8015f9:	e8 64 fc ff ff       	call   801262 <syscall>
  8015fe:	83 c4 18             	add    $0x18,%esp
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80160f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	50                   	push   %eax
  80161c:	6a 1f                	push   $0x1f
  80161e:	e8 3f fc ff ff       	call   801262 <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
	return ;
  801626:	90                   	nop
}
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <rsttst>:
void rsttst()
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 21                	push   $0x21
  801638:	e8 25 fc ff ff       	call   801262 <syscall>
  80163d:	83 c4 18             	add    $0x18,%esp
	return ;
  801640:	90                   	nop
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	8b 45 14             	mov    0x14(%ebp),%eax
  80164c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80164f:	8b 55 18             	mov    0x18(%ebp),%edx
  801652:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801656:	52                   	push   %edx
  801657:	50                   	push   %eax
  801658:	ff 75 10             	pushl  0x10(%ebp)
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	ff 75 08             	pushl  0x8(%ebp)
  801661:	6a 20                	push   $0x20
  801663:	e8 fa fb ff ff       	call   801262 <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
	return ;
  80166b:	90                   	nop
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <chktst>:
void chktst(uint32 n)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	ff 75 08             	pushl  0x8(%ebp)
  80167c:	6a 22                	push   $0x22
  80167e:	e8 df fb ff ff       	call   801262 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
	return ;
  801686:	90                   	nop
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <inctst>:

void inctst()
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 23                	push   $0x23
  801698:	e8 c5 fb ff ff       	call   801262 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
	return ;
  8016a0:	90                   	nop
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <gettst>:
uint32 gettst()
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 24                	push   $0x24
  8016b2:	e8 ab fb ff ff       	call   801262 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 25                	push   $0x25
  8016ce:	e8 8f fb ff ff       	call   801262 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
  8016d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016d9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016dd:	75 07                	jne    8016e6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016df:	b8 01 00 00 00       	mov    $0x1,%eax
  8016e4:	eb 05                	jmp    8016eb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 25                	push   $0x25
  8016ff:	e8 5e fb ff ff       	call   801262 <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
  801707:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80170a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80170e:	75 07                	jne    801717 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801710:	b8 01 00 00 00       	mov    $0x1,%eax
  801715:	eb 05                	jmp    80171c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 25                	push   $0x25
  801730:	e8 2d fb ff ff       	call   801262 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
  801738:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80173b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80173f:	75 07                	jne    801748 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801741:	b8 01 00 00 00       	mov    $0x1,%eax
  801746:	eb 05                	jmp    80174d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 25                	push   $0x25
  801761:	e8 fc fa ff ff       	call   801262 <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
  801769:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80176c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801770:	75 07                	jne    801779 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801772:	b8 01 00 00 00       	mov    $0x1,%eax
  801777:	eb 05                	jmp    80177e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801779:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	ff 75 08             	pushl  0x8(%ebp)
  80178e:	6a 26                	push   $0x26
  801790:	e8 cd fa ff ff       	call   801262 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
	return ;
  801798:	90                   	nop
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80179f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	53                   	push   %ebx
  8017ae:	51                   	push   %ecx
  8017af:	52                   	push   %edx
  8017b0:	50                   	push   %eax
  8017b1:	6a 27                	push   $0x27
  8017b3:	e8 aa fa ff ff       	call   801262 <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	52                   	push   %edx
  8017d0:	50                   	push   %eax
  8017d1:	6a 28                	push   $0x28
  8017d3:	e8 8a fa ff ff       	call   801262 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  8017e0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	6a 00                	push   $0x0
  8017eb:	51                   	push   %ecx
  8017ec:	ff 75 10             	pushl  0x10(%ebp)
  8017ef:	52                   	push   %edx
  8017f0:	50                   	push   %eax
  8017f1:	6a 29                	push   $0x29
  8017f3:	e8 6a fa ff ff       	call   801262 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	ff 75 10             	pushl  0x10(%ebp)
  801807:	ff 75 0c             	pushl  0xc(%ebp)
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	6a 12                	push   $0x12
  80180f:	e8 4e fa ff ff       	call   801262 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
	return ;
  801817:	90                   	nop
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  80181d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	52                   	push   %edx
  80182a:	50                   	push   %eax
  80182b:	6a 2a                	push   $0x2a
  80182d:	e8 30 fa ff ff       	call   801262 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
	return;
  801835:	90                   	nop
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_sbrk>:


//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80183e:	83 ec 04             	sub    $0x4,%esp
  801841:	68 f6 23 80 00       	push   $0x8023f6
  801846:	68 2e 01 00 00       	push   $0x12e
  80184b:	68 0a 24 80 00       	push   $0x80240a
  801850:	e8 61 01 00 00       	call   8019b6 <_panic>

00801855 <sys_free_user_mem>:
	return NULL;
}

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  80185b:	83 ec 04             	sub    $0x4,%esp
  80185e:	68 f6 23 80 00       	push   $0x8023f6
  801863:	68 35 01 00 00       	push   $0x135
  801868:	68 0a 24 80 00       	push   $0x80240a
  80186d:	e8 44 01 00 00       	call   8019b6 <_panic>

00801872 <sys_allocate_user_mem>:
}

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 08             	sub    $0x8,%esp
	//Comment the following line before start coding...
	panic("not implemented yet");
  801878:	83 ec 04             	sub    $0x4,%esp
  80187b:	68 f6 23 80 00       	push   $0x8023f6
  801880:	68 3b 01 00 00       	push   $0x13b
  801885:	68 0a 24 80 00       	push   $0x80240a
  80188a:	e8 27 01 00 00       	call   8019b6 <_panic>

0080188f <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("create_semaphore is not implemented yet");
  801895:	83 ec 04             	sub    $0x4,%esp
  801898:	68 18 24 80 00       	push   $0x802418
  80189d:	6a 09                	push   $0x9
  80189f:	68 40 24 80 00       	push   $0x802440
  8018a4:	e8 0d 01 00 00       	call   8019b6 <_panic>

008018a9 <get_semaphore>:
	//Your Code is Here...
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("get_semaphore is not implemented yet");
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	68 50 24 80 00       	push   $0x802450
  8018b7:	6a 10                	push   $0x10
  8018b9:	68 40 24 80 00       	push   $0x802440
  8018be:	e8 f3 00 00 00       	call   8019b6 <_panic>

008018c3 <wait_semaphore>:
	//Your Code is Here...
}

void wait_semaphore(struct semaphore sem)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("wait_semaphore is not implemented yet");
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	68 78 24 80 00       	push   $0x802478
  8018d1:	6a 18                	push   $0x18
  8018d3:	68 40 24 80 00       	push   $0x802440
  8018d8:	e8 d9 00 00 00       	call   8019b6 <_panic>

008018dd <signal_semaphore>:
	//Your Code is Here...
}

void signal_semaphore(struct semaphore sem)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT'24.MS3]
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	panic("signal_semaphore is not implemented yet");
  8018e3:	83 ec 04             	sub    $0x4,%esp
  8018e6:	68 a0 24 80 00       	push   $0x8024a0
  8018eb:	6a 20                	push   $0x20
  8018ed:	68 40 24 80 00       	push   $0x802440
  8018f2:	e8 bf 00 00 00       	call   8019b6 <_panic>

008018f7 <semaphore_count>:
	//Your Code is Here...
}

int semaphore_count(struct semaphore sem)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	8b 40 10             	mov    0x10(%eax),%eax
}
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801908:	8b 55 08             	mov    0x8(%ebp),%edx
  80190b:	89 d0                	mov    %edx,%eax
  80190d:	c1 e0 02             	shl    $0x2,%eax
  801910:	01 d0                	add    %edx,%eax
  801912:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801919:	01 d0                	add    %edx,%eax
  80191b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801922:	01 d0                	add    %edx,%eax
  801924:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80192b:	01 d0                	add    %edx,%eax
  80192d:	c1 e0 04             	shl    $0x4,%eax
  801930:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801933:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80193a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80193d:	83 ec 0c             	sub    $0xc,%esp
  801940:	50                   	push   %eax
  801941:	e8 51 fc ff ff       	call   801597 <sys_get_virtual_time>
  801946:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801949:	eb 41                	jmp    80198c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80194b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80194e:	83 ec 0c             	sub    $0xc,%esp
  801951:	50                   	push   %eax
  801952:	e8 40 fc ff ff       	call   801597 <sys_get_virtual_time>
  801957:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80195a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80195d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801960:	29 c2                	sub    %eax,%edx
  801962:	89 d0                	mov    %edx,%eax
  801964:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801967:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80196a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80196d:	89 d1                	mov    %edx,%ecx
  80196f:	29 c1                	sub    %eax,%ecx
  801971:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801974:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801977:	39 c2                	cmp    %eax,%edx
  801979:	0f 97 c0             	seta   %al
  80197c:	0f b6 c0             	movzbl %al,%eax
  80197f:	29 c1                	sub    %eax,%ecx
  801981:	89 c8                	mov    %ecx,%eax
  801983:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801986:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801989:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80198c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801992:	72 b7                	jb     80194b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801994:	90                   	nop
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80199d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8019a4:	eb 03                	jmp    8019a9 <busy_wait+0x12>
  8019a6:	ff 45 fc             	incl   -0x4(%ebp)
  8019a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019af:	72 f5                	jb     8019a6 <busy_wait+0xf>
	return i;
  8019b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8019bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8019bf:	83 c0 04             	add    $0x4,%eax
  8019c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8019c5:	a1 24 30 80 00       	mov    0x803024,%eax
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	74 16                	je     8019e4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8019ce:	a1 24 30 80 00       	mov    0x803024,%eax
  8019d3:	83 ec 08             	sub    $0x8,%esp
  8019d6:	50                   	push   %eax
  8019d7:	68 c8 24 80 00       	push   $0x8024c8
  8019dc:	e8 bd e9 ff ff       	call   80039e <cprintf>
  8019e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8019e4:	a1 00 30 80 00       	mov    0x803000,%eax
  8019e9:	ff 75 0c             	pushl  0xc(%ebp)
  8019ec:	ff 75 08             	pushl  0x8(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	68 cd 24 80 00       	push   $0x8024cd
  8019f5:	e8 a4 e9 ff ff       	call   80039e <cprintf>
  8019fa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8019fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801a00:	83 ec 08             	sub    $0x8,%esp
  801a03:	ff 75 f4             	pushl  -0xc(%ebp)
  801a06:	50                   	push   %eax
  801a07:	e8 27 e9 ff ff       	call   800333 <vcprintf>
  801a0c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	6a 00                	push   $0x0
  801a14:	68 e9 24 80 00       	push   $0x8024e9
  801a19:	e8 15 e9 ff ff       	call   800333 <vcprintf>
  801a1e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a21:	e8 96 e8 ff ff       	call   8002bc <exit>

	// should not return here
	while (1) ;
  801a26:	eb fe                	jmp    801a26 <_panic+0x70>

00801a28 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a2e:	a1 04 30 80 00       	mov    0x803004,%eax
  801a33:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3c:	39 c2                	cmp    %eax,%edx
  801a3e:	74 14                	je     801a54 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	68 ec 24 80 00       	push   $0x8024ec
  801a48:	6a 26                	push   $0x26
  801a4a:	68 38 25 80 00       	push   $0x802538
  801a4f:	e8 62 ff ff ff       	call   8019b6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a62:	e9 c5 00 00 00       	jmp    801b2c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	01 d0                	add    %edx,%eax
  801a76:	8b 00                	mov    (%eax),%eax
  801a78:	85 c0                	test   %eax,%eax
  801a7a:	75 08                	jne    801a84 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a7c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a7f:	e9 a5 00 00 00       	jmp    801b29 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a84:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a8b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a92:	eb 69                	jmp    801afd <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a94:	a1 04 30 80 00       	mov    0x803004,%eax
  801a99:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801a9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801aa2:	89 d0                	mov    %edx,%eax
  801aa4:	01 c0                	add    %eax,%eax
  801aa6:	01 d0                	add    %edx,%eax
  801aa8:	c1 e0 03             	shl    $0x3,%eax
  801aab:	01 c8                	add    %ecx,%eax
  801aad:	8a 40 04             	mov    0x4(%eax),%al
  801ab0:	84 c0                	test   %al,%al
  801ab2:	75 46                	jne    801afa <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ab4:	a1 04 30 80 00       	mov    0x803004,%eax
  801ab9:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801abf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ac2:	89 d0                	mov    %edx,%eax
  801ac4:	01 c0                	add    %eax,%eax
  801ac6:	01 d0                	add    %edx,%eax
  801ac8:	c1 e0 03             	shl    $0x3,%eax
  801acb:	01 c8                	add    %ecx,%eax
  801acd:	8b 00                	mov    (%eax),%eax
  801acf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ad2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ad5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ada:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801adf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	01 c8                	add    %ecx,%eax
  801aeb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801aed:	39 c2                	cmp    %eax,%edx
  801aef:	75 09                	jne    801afa <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801af1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801af8:	eb 15                	jmp    801b0f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801afa:	ff 45 e8             	incl   -0x18(%ebp)
  801afd:	a1 04 30 80 00       	mov    0x803004,%eax
  801b02:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b0b:	39 c2                	cmp    %eax,%edx
  801b0d:	77 85                	ja     801a94 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b13:	75 14                	jne    801b29 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801b15:	83 ec 04             	sub    $0x4,%esp
  801b18:	68 44 25 80 00       	push   $0x802544
  801b1d:	6a 3a                	push   $0x3a
  801b1f:	68 38 25 80 00       	push   $0x802538
  801b24:	e8 8d fe ff ff       	call   8019b6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b29:	ff 45 f0             	incl   -0x10(%ebp)
  801b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b32:	0f 8c 2f ff ff ff    	jl     801a67 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b38:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b3f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b46:	eb 26                	jmp    801b6e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b48:	a1 04 30 80 00       	mov    0x803004,%eax
  801b4d:	8b 88 38 da 01 00    	mov    0x1da38(%eax),%ecx
  801b53:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b56:	89 d0                	mov    %edx,%eax
  801b58:	01 c0                	add    %eax,%eax
  801b5a:	01 d0                	add    %edx,%eax
  801b5c:	c1 e0 03             	shl    $0x3,%eax
  801b5f:	01 c8                	add    %ecx,%eax
  801b61:	8a 40 04             	mov    0x4(%eax),%al
  801b64:	3c 01                	cmp    $0x1,%al
  801b66:	75 03                	jne    801b6b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b68:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b6b:	ff 45 e0             	incl   -0x20(%ebp)
  801b6e:	a1 04 30 80 00       	mov    0x803004,%eax
  801b73:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801b79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b7c:	39 c2                	cmp    %eax,%edx
  801b7e:	77 c8                	ja     801b48 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b83:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b86:	74 14                	je     801b9c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	68 98 25 80 00       	push   $0x802598
  801b90:	6a 44                	push   $0x44
  801b92:	68 38 25 80 00       	push   $0x802538
  801b97:	e8 1a fe ff ff       	call   8019b6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b9c:	90                   	nop
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    
  801b9f:	90                   	nop

00801ba0 <__udivdi3>:
  801ba0:	55                   	push   %ebp
  801ba1:	57                   	push   %edi
  801ba2:	56                   	push   %esi
  801ba3:	53                   	push   %ebx
  801ba4:	83 ec 1c             	sub    $0x1c,%esp
  801ba7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801baf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bb3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bb7:	89 ca                	mov    %ecx,%edx
  801bb9:	89 f8                	mov    %edi,%eax
  801bbb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bbf:	85 f6                	test   %esi,%esi
  801bc1:	75 2d                	jne    801bf0 <__udivdi3+0x50>
  801bc3:	39 cf                	cmp    %ecx,%edi
  801bc5:	77 65                	ja     801c2c <__udivdi3+0x8c>
  801bc7:	89 fd                	mov    %edi,%ebp
  801bc9:	85 ff                	test   %edi,%edi
  801bcb:	75 0b                	jne    801bd8 <__udivdi3+0x38>
  801bcd:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd2:	31 d2                	xor    %edx,%edx
  801bd4:	f7 f7                	div    %edi
  801bd6:	89 c5                	mov    %eax,%ebp
  801bd8:	31 d2                	xor    %edx,%edx
  801bda:	89 c8                	mov    %ecx,%eax
  801bdc:	f7 f5                	div    %ebp
  801bde:	89 c1                	mov    %eax,%ecx
  801be0:	89 d8                	mov    %ebx,%eax
  801be2:	f7 f5                	div    %ebp
  801be4:	89 cf                	mov    %ecx,%edi
  801be6:	89 fa                	mov    %edi,%edx
  801be8:	83 c4 1c             	add    $0x1c,%esp
  801beb:	5b                   	pop    %ebx
  801bec:	5e                   	pop    %esi
  801bed:	5f                   	pop    %edi
  801bee:	5d                   	pop    %ebp
  801bef:	c3                   	ret    
  801bf0:	39 ce                	cmp    %ecx,%esi
  801bf2:	77 28                	ja     801c1c <__udivdi3+0x7c>
  801bf4:	0f bd fe             	bsr    %esi,%edi
  801bf7:	83 f7 1f             	xor    $0x1f,%edi
  801bfa:	75 40                	jne    801c3c <__udivdi3+0x9c>
  801bfc:	39 ce                	cmp    %ecx,%esi
  801bfe:	72 0a                	jb     801c0a <__udivdi3+0x6a>
  801c00:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c04:	0f 87 9e 00 00 00    	ja     801ca8 <__udivdi3+0x108>
  801c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0f:	89 fa                	mov    %edi,%edx
  801c11:	83 c4 1c             	add    $0x1c,%esp
  801c14:	5b                   	pop    %ebx
  801c15:	5e                   	pop    %esi
  801c16:	5f                   	pop    %edi
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    
  801c19:	8d 76 00             	lea    0x0(%esi),%esi
  801c1c:	31 ff                	xor    %edi,%edi
  801c1e:	31 c0                	xor    %eax,%eax
  801c20:	89 fa                	mov    %edi,%edx
  801c22:	83 c4 1c             	add    $0x1c,%esp
  801c25:	5b                   	pop    %ebx
  801c26:	5e                   	pop    %esi
  801c27:	5f                   	pop    %edi
  801c28:	5d                   	pop    %ebp
  801c29:	c3                   	ret    
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	89 d8                	mov    %ebx,%eax
  801c2e:	f7 f7                	div    %edi
  801c30:	31 ff                	xor    %edi,%edi
  801c32:	89 fa                	mov    %edi,%edx
  801c34:	83 c4 1c             	add    $0x1c,%esp
  801c37:	5b                   	pop    %ebx
  801c38:	5e                   	pop    %esi
  801c39:	5f                   	pop    %edi
  801c3a:	5d                   	pop    %ebp
  801c3b:	c3                   	ret    
  801c3c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c41:	89 eb                	mov    %ebp,%ebx
  801c43:	29 fb                	sub    %edi,%ebx
  801c45:	89 f9                	mov    %edi,%ecx
  801c47:	d3 e6                	shl    %cl,%esi
  801c49:	89 c5                	mov    %eax,%ebp
  801c4b:	88 d9                	mov    %bl,%cl
  801c4d:	d3 ed                	shr    %cl,%ebp
  801c4f:	89 e9                	mov    %ebp,%ecx
  801c51:	09 f1                	or     %esi,%ecx
  801c53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c57:	89 f9                	mov    %edi,%ecx
  801c59:	d3 e0                	shl    %cl,%eax
  801c5b:	89 c5                	mov    %eax,%ebp
  801c5d:	89 d6                	mov    %edx,%esi
  801c5f:	88 d9                	mov    %bl,%cl
  801c61:	d3 ee                	shr    %cl,%esi
  801c63:	89 f9                	mov    %edi,%ecx
  801c65:	d3 e2                	shl    %cl,%edx
  801c67:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c6b:	88 d9                	mov    %bl,%cl
  801c6d:	d3 e8                	shr    %cl,%eax
  801c6f:	09 c2                	or     %eax,%edx
  801c71:	89 d0                	mov    %edx,%eax
  801c73:	89 f2                	mov    %esi,%edx
  801c75:	f7 74 24 0c          	divl   0xc(%esp)
  801c79:	89 d6                	mov    %edx,%esi
  801c7b:	89 c3                	mov    %eax,%ebx
  801c7d:	f7 e5                	mul    %ebp
  801c7f:	39 d6                	cmp    %edx,%esi
  801c81:	72 19                	jb     801c9c <__udivdi3+0xfc>
  801c83:	74 0b                	je     801c90 <__udivdi3+0xf0>
  801c85:	89 d8                	mov    %ebx,%eax
  801c87:	31 ff                	xor    %edi,%edi
  801c89:	e9 58 ff ff ff       	jmp    801be6 <__udivdi3+0x46>
  801c8e:	66 90                	xchg   %ax,%ax
  801c90:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c94:	89 f9                	mov    %edi,%ecx
  801c96:	d3 e2                	shl    %cl,%edx
  801c98:	39 c2                	cmp    %eax,%edx
  801c9a:	73 e9                	jae    801c85 <__udivdi3+0xe5>
  801c9c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c9f:	31 ff                	xor    %edi,%edi
  801ca1:	e9 40 ff ff ff       	jmp    801be6 <__udivdi3+0x46>
  801ca6:	66 90                	xchg   %ax,%ax
  801ca8:	31 c0                	xor    %eax,%eax
  801caa:	e9 37 ff ff ff       	jmp    801be6 <__udivdi3+0x46>
  801caf:	90                   	nop

00801cb0 <__umoddi3>:
  801cb0:	55                   	push   %ebp
  801cb1:	57                   	push   %edi
  801cb2:	56                   	push   %esi
  801cb3:	53                   	push   %ebx
  801cb4:	83 ec 1c             	sub    $0x1c,%esp
  801cb7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cbb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cc3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ccb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ccf:	89 f3                	mov    %esi,%ebx
  801cd1:	89 fa                	mov    %edi,%edx
  801cd3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cd7:	89 34 24             	mov    %esi,(%esp)
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	75 1a                	jne    801cf8 <__umoddi3+0x48>
  801cde:	39 f7                	cmp    %esi,%edi
  801ce0:	0f 86 a2 00 00 00    	jbe    801d88 <__umoddi3+0xd8>
  801ce6:	89 c8                	mov    %ecx,%eax
  801ce8:	89 f2                	mov    %esi,%edx
  801cea:	f7 f7                	div    %edi
  801cec:	89 d0                	mov    %edx,%eax
  801cee:	31 d2                	xor    %edx,%edx
  801cf0:	83 c4 1c             	add    $0x1c,%esp
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5f                   	pop    %edi
  801cf6:	5d                   	pop    %ebp
  801cf7:	c3                   	ret    
  801cf8:	39 f0                	cmp    %esi,%eax
  801cfa:	0f 87 ac 00 00 00    	ja     801dac <__umoddi3+0xfc>
  801d00:	0f bd e8             	bsr    %eax,%ebp
  801d03:	83 f5 1f             	xor    $0x1f,%ebp
  801d06:	0f 84 ac 00 00 00    	je     801db8 <__umoddi3+0x108>
  801d0c:	bf 20 00 00 00       	mov    $0x20,%edi
  801d11:	29 ef                	sub    %ebp,%edi
  801d13:	89 fe                	mov    %edi,%esi
  801d15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d19:	89 e9                	mov    %ebp,%ecx
  801d1b:	d3 e0                	shl    %cl,%eax
  801d1d:	89 d7                	mov    %edx,%edi
  801d1f:	89 f1                	mov    %esi,%ecx
  801d21:	d3 ef                	shr    %cl,%edi
  801d23:	09 c7                	or     %eax,%edi
  801d25:	89 e9                	mov    %ebp,%ecx
  801d27:	d3 e2                	shl    %cl,%edx
  801d29:	89 14 24             	mov    %edx,(%esp)
  801d2c:	89 d8                	mov    %ebx,%eax
  801d2e:	d3 e0                	shl    %cl,%eax
  801d30:	89 c2                	mov    %eax,%edx
  801d32:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d36:	d3 e0                	shl    %cl,%eax
  801d38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d40:	89 f1                	mov    %esi,%ecx
  801d42:	d3 e8                	shr    %cl,%eax
  801d44:	09 d0                	or     %edx,%eax
  801d46:	d3 eb                	shr    %cl,%ebx
  801d48:	89 da                	mov    %ebx,%edx
  801d4a:	f7 f7                	div    %edi
  801d4c:	89 d3                	mov    %edx,%ebx
  801d4e:	f7 24 24             	mull   (%esp)
  801d51:	89 c6                	mov    %eax,%esi
  801d53:	89 d1                	mov    %edx,%ecx
  801d55:	39 d3                	cmp    %edx,%ebx
  801d57:	0f 82 87 00 00 00    	jb     801de4 <__umoddi3+0x134>
  801d5d:	0f 84 91 00 00 00    	je     801df4 <__umoddi3+0x144>
  801d63:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d67:	29 f2                	sub    %esi,%edx
  801d69:	19 cb                	sbb    %ecx,%ebx
  801d6b:	89 d8                	mov    %ebx,%eax
  801d6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d71:	d3 e0                	shl    %cl,%eax
  801d73:	89 e9                	mov    %ebp,%ecx
  801d75:	d3 ea                	shr    %cl,%edx
  801d77:	09 d0                	or     %edx,%eax
  801d79:	89 e9                	mov    %ebp,%ecx
  801d7b:	d3 eb                	shr    %cl,%ebx
  801d7d:	89 da                	mov    %ebx,%edx
  801d7f:	83 c4 1c             	add    $0x1c,%esp
  801d82:	5b                   	pop    %ebx
  801d83:	5e                   	pop    %esi
  801d84:	5f                   	pop    %edi
  801d85:	5d                   	pop    %ebp
  801d86:	c3                   	ret    
  801d87:	90                   	nop
  801d88:	89 fd                	mov    %edi,%ebp
  801d8a:	85 ff                	test   %edi,%edi
  801d8c:	75 0b                	jne    801d99 <__umoddi3+0xe9>
  801d8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d93:	31 d2                	xor    %edx,%edx
  801d95:	f7 f7                	div    %edi
  801d97:	89 c5                	mov    %eax,%ebp
  801d99:	89 f0                	mov    %esi,%eax
  801d9b:	31 d2                	xor    %edx,%edx
  801d9d:	f7 f5                	div    %ebp
  801d9f:	89 c8                	mov    %ecx,%eax
  801da1:	f7 f5                	div    %ebp
  801da3:	89 d0                	mov    %edx,%eax
  801da5:	e9 44 ff ff ff       	jmp    801cee <__umoddi3+0x3e>
  801daa:	66 90                	xchg   %ax,%ax
  801dac:	89 c8                	mov    %ecx,%eax
  801dae:	89 f2                	mov    %esi,%edx
  801db0:	83 c4 1c             	add    $0x1c,%esp
  801db3:	5b                   	pop    %ebx
  801db4:	5e                   	pop    %esi
  801db5:	5f                   	pop    %edi
  801db6:	5d                   	pop    %ebp
  801db7:	c3                   	ret    
  801db8:	3b 04 24             	cmp    (%esp),%eax
  801dbb:	72 06                	jb     801dc3 <__umoddi3+0x113>
  801dbd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801dc1:	77 0f                	ja     801dd2 <__umoddi3+0x122>
  801dc3:	89 f2                	mov    %esi,%edx
  801dc5:	29 f9                	sub    %edi,%ecx
  801dc7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801dcb:	89 14 24             	mov    %edx,(%esp)
  801dce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dd2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dd6:	8b 14 24             	mov    (%esp),%edx
  801dd9:	83 c4 1c             	add    $0x1c,%esp
  801ddc:	5b                   	pop    %ebx
  801ddd:	5e                   	pop    %esi
  801dde:	5f                   	pop    %edi
  801ddf:	5d                   	pop    %ebp
  801de0:	c3                   	ret    
  801de1:	8d 76 00             	lea    0x0(%esi),%esi
  801de4:	2b 04 24             	sub    (%esp),%eax
  801de7:	19 fa                	sbb    %edi,%edx
  801de9:	89 d1                	mov    %edx,%ecx
  801deb:	89 c6                	mov    %eax,%esi
  801ded:	e9 71 ff ff ff       	jmp    801d63 <__umoddi3+0xb3>
  801df2:	66 90                	xchg   %ax,%ax
  801df4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801df8:	72 ea                	jb     801de4 <__umoddi3+0x134>
  801dfa:	89 d9                	mov    %ebx,%ecx
  801dfc:	e9 62 ff ff ff       	jmp    801d63 <__umoddi3+0xb3>
